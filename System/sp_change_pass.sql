IF EXISTS (
       SELECT *
       FROM   sysobjects
       WHERE  TYPE = 'P'
              AND NAME = 'sp_change_pass'
   )
BEGIN
    DROP PROCEDURE sp_change_pass
END

GO

CREATE PROCEDURE dbo.sp_change_pass
(
	@UserName      SYSNAME
	, @PassOld     NVARCHAR(256) = NULL
	, @PassNew     NVARCHAR(256)
)
WITH                       
 EXECUTE AS OWNER
 

AS
DECLARE @errmsg VARCHAR(8000) /* Проверка открытия транзакции */
	        ,@errmsgXML     VARCHAR(8000)
	        ,@paramSTR      VARCHAR(256)
	
SET NOCOUNT ON

DECLARE @PassphraseEnteredByUser     VARCHAR(128)
        ,@pr_383                     SMALLINT
	
BEGIN TRY
	-- Получаем тип авторизации
	SELECT @pr_383 = pr_383.[Value]
	FROM   mn_object_property_tp pr_383
	       JOIN sc_user su
	            ON  su.UserID = pr_383.ObjectID
	                AND pr_383.PropertyID = -383
	WHERE  su.[Login] = @UserName
	
	IF @pr_383 = -11168 -- Шифрованный пароль
	BEGIN
	    SET @PassphraseEnteredByUser = 'TETRA'
	    
	    IF NOT EXISTS (
	           SELECT *
	           FROM   sc_user m
	           WHERE  [Login] = @UserName
	                  AND (
	                          CONVERT(NVARCHAR, DecryptByPassPhrase(@PassphraseEnteredByUser, m.[PassWord], 1, CONVERT(VARBINARY, m.UserID))) 
	                          = @PassOld
	                          OR m.[PassWord] IS NULL
	                      )
	       )
	    BEGIN
	        SELECT @errmsg = 'Пароль указан неверно.'
			SELECT @errmsgXML = dbo.f_error_2_XML(OBJECT_NAME(@@PROCID), 'SqlRe161','TLRCommonResDB', @errmsg, NULL)
			RAISERROR(@errmsgXML, 16, 1)
	    END
	    
	    UPDATE su
	    SET    su.[PassWord] = EncryptByPassPhrase(@PassphraseEnteredByUser, @PassNew, 1, CONVERT(VARBINARY, su.UserID))
	    FROM   sc_user su
	    WHERE  su.[Login] = @UserName
	END
	
	IF @pr_383 = -11345 -- Хэш функция
	BEGIN
	    IF NOT EXISTS (
	           SELECT *
	           FROM   sc_user m
	           WHERE  [Login] = @UserName
	                  AND (m.[PassWord] = HASHBYTES('SHA2_512', @PassOld) OR m.[PassWord] IS NULL)
	       )
	    BEGIN
	        SELECT @errmsg = 'Пароль указан неверно.'
			SELECT @errmsgXML = dbo.f_error_2_XML(OBJECT_NAME(@@PROCID), 'SqlRe161','TLRCommonResDB', @errmsg, NULL)
			RAISERROR(@errmsgXML, 16, 1)
	    END
	    
	    UPDATE su
	    SET    su.[PassWord] = HASHBYTES('SHA2_512', @PassNew)
	    FROM   sc_user su
	    WHERE  su.[Login] = @UserName
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

GRANT EXEC ON sp_change_pass TO TetraUsers
