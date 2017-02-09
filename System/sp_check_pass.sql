IF EXISTS (
       SELECT *
       FROM   sysobjects
       WHERE  TYPE         = 'P'
              AND NAME     = 'sp_check_pass'
   )
BEGIN
    DROP PROCEDURE sp_check_pass
END

GO

CREATE PROCEDURE dbo.sp_check_pass
(
	@UserName     SYSNAME
   ,@Pass         NVARCHAR(256)
   ,@isValid      BIT = 0 OUT
)
WITH     
             
EXECUTE AS OWNER
        
        AS

DECLARE @errmsg         VARCHAR(8000) /* Проверка открытия транзакции */
        ,@pr_383        SMALLINT
        ,@errmsgXML     VARCHAR(8000)
        ,@paramSTR      VARCHAR(256)
	
SET NOCOUNT ON

DECLARE @PassphraseEnteredByUser VARCHAR(128)
	
BEGIN TRY
	SELECT @isValid = 0
	
	-- Получаем тип авторизации
	SELECT @pr_383 = pr_383.[Value]
	FROM   mn_object_property_tp pr_383
	       JOIN sc_user su
	            ON  su.UserID = pr_383.ObjectID
	                AND pr_383.PropertyID = -383
	WHERE  su.[Login] = @UserName
	
	IF @pr_383 NOT IN (-11168, -11345)
	BEGIN
	    SELECT @errmsg = 'Проверка типа авторизации логина {c} не поддерживается.'
	    SELECT @paramSTR = '[c, ' + @UserName + ', 9]' -- 
	    SELECT @errmsgXML = dbo.f_error_2_XML(OBJECT_NAME(@@PROCID), 'SqlRe226', 'TLRCommonResDB', @errmsg, NULL)
	    RAISERROR(@errmsgXML, 16, 1)
	END
	
	IF @pr_383 = -11168 -- Шифрованный пароль
	BEGIN
	    SET @PassphraseEnteredByUser = 'TETRA'
	    
	    IF EXISTS (
	           SELECT *
	           FROM   sc_user m
	           WHERE  [Login] = @UserName
	                  AND CONVERT(NVARCHAR, DecryptByPassPhrase(@PassphraseEnteredByUser, m.[PassWord], 1, CONVERT(VARBINARY, m.UserID))) = 
	                      @Pass
	       )
	    BEGIN
	        SELECT @isValid = 1
	    END
	    ELSE
	    BEGIN
	        SELECT @isValid = 0
	    END
	END
	
	IF @pr_383 = -11345 -- Хэш функция
	BEGIN
	    IF EXISTS (
	           SELECT *
	           FROM   sc_user m
	           WHERE  [Login] = @UserName
	                  AND (m.[PassWord] = HASHBYTES('SHA2_512', @Pass) OR (m.[PassWord] IS NULL AND @Pass IS NULL))
	       )
	    BEGIN
	        SELECT @isValid = 1
	    END
	    ELSE
	    BEGIN
	        SELECT @isValid = 0
	    END
	END
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

GRANT EXEC ON sp_check_pass TO TetraUsers
