IF EXISTS (
       SELECT *
       FROM   sysobjects
       WHERE  TYPE = 'P'
              AND NAME = 'sp_remove_pk'
   )
BEGIN
    DROP PROCEDURE sp_remove_pk
END

GO

CREATE PROCEDURE [dbo].[sp_remove_pk]
(
	@TableName   VARCHAR(32)
	, @RemoveFk  BIT = 0
)
AS
	DECLARE @TableId         INT
	        ,@Str_Sql        VARCHAR(255)
	        ,@PKName         VARCHAR(48)
	        ,@TableNameFull  VARCHAR(255)
	        ,@Poz            TINYINT
	        ,@UserID         INT
	        ,@errmsg         VARCHAR(255)
	        ,@errmsgXML     VARCHAR(8000)
	        ,@paramSTR      VARCHAR(256)
	
	/* Определяем имя таблицы */
	SELECT @Poz = CHARINDEX('.', @TableName)
	IF ISNULL(@poz, 0) <= 0
	BEGIN
	    IF EXISTS (
	           SELECT COUNT(*)
	           FROM   sysobjects
	           WHERE  xType = 'U'
	                  AND NAME = @TableName
	           HAVING COUNT(*) > 1
	       )
	    BEGIN
	        SELECT @errmsg= 'Существует несколько таблиц с таким именем'
			SELECT @errmsgXML = dbo.f_error_2_XML(OBJECT_NAME(@@PROCID), 'SqlRe231', 'TLRCommonResDB', @errmsg, NULL)
			RAISERROR(@errmsgXML, 16, 1)
	        RETURN
	    END
	    SELECT @TableID = Id
	    FROM   sysobjects
	    WHERE  xType = 'U'
	           AND NAME = @TableName
	END
	ELSE
	BEGIN
	    SELECT @TableNameFull = @TableName
	    SELECT @TableName = SUBSTRING(@Tablename, @poz + 1, 32)		
	    SELECT @UserId = USER_ID(SUBSTRING(@TableNameFull, 1, @poz - 1))	
	    SELECT @TableID = Id
	    FROM   sysobjects
	    WHERE  xType = 'U'
	           AND NAME = @TableName
	           AND uid = @UserID
	END
	IF ISNULL(LTRIM(@TableID), 0) = 0
	BEGIN
	    SELECT @errmsg = 'Таблица не найдена'
		SELECT @errmsgXML = dbo.f_error_2_XML(OBJECT_NAME(@@PROCID), 'SqlRe232', 'TLRCommonResDB', @errmsg, NULL)
		RAISERROR(@errmsgXML, 16, 1)
	    RETURN
	END
	
	/* Если указаноЮ сначала удаляем FK */
	IF @RemoveFK = 1
	BEGIN
	    EXEC sp_remove_fk @TableName
	END
	
	/* Собственно удаление */
	SELECT @PKName = s1.Name
	FROM   sysobjects s1, sysobjects s2
	WHERE  s1.xType = 'PK'
	       AND s2.ID = s1.Parent_obj
	       AND s2.ID = @TableID
	
	SELECT @str_sql = 'alter table ' + @TableName + ' drop constraint ' + @PKName 
	PRINT @Str_sql	
	EXEC (@str_sql)
GO


GRANT EXEC ON sp_remove_pk TO TetraUsers
