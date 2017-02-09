IF EXISTS (
       SELECT *
       FROM   sysobjects
       WHERE  TYPE = 'P'
              AND NAME = 'sp_alter_all_database'
   )
BEGIN
    DROP PROCEDURE sp_alter_all_database
END

GO

/* Процедура принимает на вход параметр инструкции ALTER DATABASE 
и последовательно выполняет его для всех прикладных баз сервера */
CREATE PROCEDURE dbo.sp_alter_all_database
(
	@Option VARCHAR(256)
)
AS
	DECLARE @errmsg  VARCHAR(8000) /* Проверка открытия транзакции */
	
	DECLARE @sSql    AS NVARCHAR(MAX)
	       ,@DBName  AS SYSNAME
	        ,@errmsgXML     VARCHAR(8000)
	        ,@paramSTR      VARCHAR(256)
	
	SET NOCOUNT ON
	
	BEGIN TRY
		
		SELECT @DBName = ''
		
		WHILE 1 = 1
		BEGIN
		    SELECT @DBName = S.[name]
		    FROM   SYS.sysdatabases s
		    WHERE  S.[name] > @DBName
		           AND s.dbid > 4
		    ORDER BY
		           S.[name] DESC
		    
		    IF @@ROWCOUNT < 1
		        BREAK
		    
		    SELECT @sSql = 'ALTER DATABASE ' + @DBName + ' SET ' + @Option 
		    
		    --
		    --PRINT @sSQL
		    --  
		    
		    EXEC dbo.sp_executesql @sSQL
		END
		
		PRINT 'Результат'	
		SELECT *	FROM   sys.databases d
	END TRY
	
	/* ======== Обработчик ошибок ======== */
	BEGIN CATCH
		SELECT @errmsgxml = dbo.f_msg_err(
		           OBJECT_NAME(@@PROCID), ERROR_MESSAGE(), ERROR_PROCEDURE(), ERROR_NUMBER(), ERROR_LINE(), ERROR_STATE(), ERROR_SEVERITY()
		       )
		
		RAISERROR (@errmsgxml, 16, 1) WITH NOWAIT
	END CATCH
	-------------------------
GO




--GRANT EXEC ON sp_alter_all_database TO TetraUsers