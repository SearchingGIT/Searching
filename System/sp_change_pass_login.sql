IF EXISTS (
       SELECT *
       FROM   sysobjects
       WHERE  TYPE         = 'P'
              AND NAME     = 'sp_change_pass_login'
   )
BEGIN
    DROP PROCEDURE sp_change_pass_login
END

GO

CREATE PROCEDURE dbo.sp_change_pass_login
(
	@Login       SYSNAME
   ,@PassNew     NVARCHAR(256)
   ,@PassOld     NVARCHAR(256) = NULL
)--WITH
 -- EXECUTE AS OWNER
AS
	DECLARE @errmsg         VARCHAR(8000)
	        , @sSql         NVARCHAR(4000)
	        ,@errmsgXML     VARCHAR(8000)
	        ,@paramSTR      VARCHAR(256)
	
	SET NOCOUNT ON
	
	BEGIN TRY
		--	SELECT USER, DB_NAME()
		
		
		SELECT @sSql = 'ALTER LOGIN ' + @Login + ' WITH PASSWORD = ''' + @PassNew + ''''
		
		IF NOT @PassOld IS NULL
		BEGIN
		    SELECT @sSql = @sSql + 'OLD_PASSWORD = ''' + @PassOld + ''''
		END 
		
		---
		--PRINT @sSql
		---
		
		EXEC dbo.sp_executesql @sSQL
	END TRY
	
	/* ======== Обработчик ошибок ======== */
	BEGIN CATCH
		SELECT @errmsgxml = dbo.f_msg_err(
		           OBJECT_NAME(@@PROCID), ERROR_MESSAGE(), ERROR_PROCEDURE(), ERROR_NUMBER(), ERROR_LINE(), ERROR_STATE(), ERROR_SEVERITY()
		       )
		
		RAISERROR (@errmsgxml, 16, 1) 
		WITH NOWAIT
	END CATCH
	-------------------------
GO

GRANT EXEC ON sp_change_pass_login TO TetraUsers
GRANT EXEC ON sp_change_pass_login TO ANONYMOUS