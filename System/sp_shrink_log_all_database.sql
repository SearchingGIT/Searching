IF EXISTS (
       SELECT *
       FROM   sysobjects
       WHERE  TYPE = 'P'
              AND NAME = 'sp_shrink_log_all_database'
   )
BEGIN
    DROP PROCEDURE sp_shrink_log_all_database
END

GO

/* Обрезает файл лога для всех баз */
CREATE PROCEDURE dbo.sp_shrink_log_all_database
AS
	DECLARE @DBname   SYSNAME
	        ,@sSQL    NVARCHAR(4000)
	        ,@errmsg  VARCHAR(8000)
	        ,@errmsgXML     VARCHAR(8000)
	        ,@paramSTR      VARCHAR(256)
	
	SET NOCOUNT ON
	
	BEGIN TRY
		SELECT @DBname = ''
		
		WHILE 1 = 1
		BEGIN
		    SELECT @DBname = d.[name]
		    FROM   sys.databases d
		    WHERE  d.is_db_chaining_on = 0
		           AND d.[name] > @DBname
		    ORDER BY d.[name] DESC
		    
		    IF @@ROWCOUNT < 1
		        BREAK
		    
		    SELECT @sSQL = 'DECLARE @FileName sysname' + dbo.f_CrLf()
		    SELECT @sSQL = @sSQL + 'SET NOCOUNT ON' + dbo.f_CrLf()
		    SELECT @sSQL = @sSQL + 'USE [' + @DBname +']' + dbo.f_CrLf()
		    SELECT @sSQL = @sSQL + 'SELECT @FileName = name FROM sys.sysfiles s WHERE GROUPID =0' + dbo.f_CrLf()  
		    SELECT @sSQL = @sSQL + 'ALTER DATABASE [' + @DBname + '] SET RECOVERY SIMPLE WITH NO_WAIT' + dbo.f_CrLf()
		    SELECT @sSQL = @sSQL + 'DBCC SHRINKFILE (@FileName, 1)' + dbo.f_CrLf() 
		    SELECT @sSQL = @sSQL + 'DBCC SHRINKFILE (@FileName, EMPTYFILE)' + dbo.f_CrLf() 

		    --SELECT @sSQL = @sSQL + 'DBCC SHRINKFILE (@FileName, 0, TRUNCATEONLY)' + dbo.f_CrLf() 
		    
		    ---
		    --PRINT @sSQL
		    ---   
		    
		    EXEC dbo.sp_executesql @sSQL
		END
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