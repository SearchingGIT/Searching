IF EXISTS (
       SELECT *
       FROM   sysobjects
       WHERE  TYPE         = 'P'
              AND NAME     = 'sp_drop_constraints'
   )
BEGIN
    DROP PROCEDURE sp_drop_constraints
END

GO

/* Определение ресурсов для выполнения работы */
CREATE PROCEDURE sp_drop_constraints
(
	@table      SYSNAME
   ,@column     SYSNAME = NULL
   ,@owner      SYSNAME = NULL
)
AS
	DECLARE @errmsg      VARCHAR(8000) /* Проверка открытия транзакции */
	        ,@Source     VARCHAR(64)
	        ,@errmsgXML     VARCHAR(8000)
	        ,@paramSTR      VARCHAR(256)
	
	SET NOCOUNT ON
	SET @Source = OBJECT_NAME(@@PROCID)
	-----------------
	
	DECLARE @const_name NVARCHAR(140)
	DECLARE @objid INT
	DECLARE @retcode INT
	DECLARE @qualified_tablename NVARCHAR(270)
	DECLARE @quoted_tablename NVARCHAR(270)
	DECLARE @quoted_ownername NVARCHAR(270)
	DECLARE @sSql AS NVARCHAR(MAX)
	
	BEGIN TRY
		/*
		** Check for subscribing permission
		*/
		EXEC @retcode = sys.sp_MSreplcheck_subscribe
		IF @retcode <> 0
		   OR @@ERROR <> 0
		    RETURN (1)
		
		SELECT @quoted_tablename = QUOTENAME(@table)
		
		IF @owner IS NOT NULL
		BEGIN
		    SET @quoted_ownername = QUOTENAME(@owner)
		    SET @qualified_tablename = @quoted_ownername + '.' + @quoted_tablename
		END
		ELSE
		    SET @qualified_tablename = @quoted_tablename
		
		SET @objid = OBJECT_ID(@qualified_tablename)
		IF @objid IS NULL
		BEGIN
		    IF @owner IS NULL
		    BEGIN
		        SELECT @objid = OBJECT_ID
		        FROM   sys.objects
		        WHERE  NAME = @quoted_tablename
		    END
		    ELSE
		    BEGIN
		        SELECT @objid = OBJECT_ID
		        FROM   sys.objects
		        WHERE  NAME = @quoted_tablename
		               AND SCHEMA_NAME(SCHEMA_ID) = @quoted_ownername
		    END
		END
		
		IF @objid IS NULL
		    RETURN (1)
		
		
		--	'FK'
		SET @const_name = ''
		WHILE @const_name IS NOT NULL
		BEGIN
		    SELECT @const_name = QUOTENAME(OBJECT_NAME(m.object_id))
		    FROM   sys.foreign_keys m
		           JOIN sys.foreign_key_columns m1
		                ON  m.Object_ID = m1.constraint_object_id
		           JOIN sys.columns c
		                ON  c.OBJECT_ID = m.parent_OBJECT_ID
		                    AND c.column_id = m1.parent_column_id
		    WHERE  m.parent_object_id = @objid
		           AND c.NAME = ISNULL(@column, c.NAME)
		           AND QUOTENAME(OBJECT_NAME(m.object_id)) > @const_name
		    ORDER BY QUOTENAME(OBJECT_NAME(m.object_id)) DESC
		    
		    IF @@ROWCOUNT < 1
		        BREAK
		    
		    SELECT @sSql = 'alter table ' + @qualified_tablename + ' drop constraint ' + @const_name
		    PRINT @sSql
		    
		    EXEC (@sSql)
		END
		
		
		-- Check
		SET @const_name = ''
		WHILE @const_name IS NOT NULL
		BEGIN
		    SELECT @const_name = m.name
		    FROM   sys.check_constraints m
		           JOIN sys.columns c
		                ON  c.OBJECT_ID = m.parent_object_id
		                    AND c.column_id = m.parent_column_id
		    WHERE  m.parent_object_id = @objid
		           AND c.NAME = ISNULL(@column, c.NAME)
		           AND m.name > @const_name
		    ORDER BY m.name DESC
		    
		    IF @@ROWCOUNT < 1
		        BREAK
		    
		    SELECT @sSql = 'alter table ' + @qualified_tablename + ' drop constraint ' + @const_name
		    PRINT @sSql
		    
		    EXEC (@sSql)
		END
		
		-- Default
		SET @const_name = ''
		WHILE @const_name IS NOT NULL
		BEGIN
		    SELECT @const_name = m.name
		    FROM   sys.default_constraints m
		           JOIN sys.columns c
		                ON  c.OBJECT_ID = m.parent_object_id
		                    AND c.column_id = m.parent_column_id
		    WHERE  m.parent_object_id = @objid
		           AND c.NAME = ISNULL(@column, c.NAME)
		           AND m.name > @const_name
		    ORDER BY m.name DESC
		    
		    IF @@ROWCOUNT < 1
		        BREAK
		    
		    SELECT @sSql = 'alter table ' + @qualified_tablename + ' drop constraint ' + @const_name
		    PRINT @sSql
		    
		    EXEC (@sSql)
		END
	END TRY
	
	/* ======== Обработчик ошибок ======== */
	BEGIN CATCH
		SELECT @errmsgxml = dbo.f_msg_err(
		           OBJECT_NAME(@@PROCID), ERROR_MESSAGE(), ERROR_PROCEDURE(), ERROR_NUMBER(), ERROR_LINE(), ERROR_STATE(), ERROR_SEVERITY()
		       )
		
		RAISERROR (@errmsgxml, 16, 1) WITH NOWAIT
	END CATCH
GO

GRANT EXEC ON sp_drop_constraints TO TETRAUSERS
GO


