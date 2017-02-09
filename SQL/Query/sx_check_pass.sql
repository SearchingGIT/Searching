IF EXISTS (
       SELECT *
       FROM   sysobjects
       WHERE  TYPE         = 'P'
              AND NAME     = 'sx_check_pass'
   )
BEGIN
    DROP PROCEDURE sx_check_pass
END

GO

CREATE PROCEDURE dbo.sx_check_pass
(
	 @UserName     SYSNAME
	,@Pass         NVARCHAR(256)
	,@isValid      BIT = 0 OUT
)
WITH        
             
EXECUTE AS OWNER
        
        AS

DECLARE @errmsg                       VARCHAR(8000) /* Проверка открытия транзакции */
        ,@pr_383                      SMALLINT
        ,@errmsgXML                   VARCHAR(8000)
        ,@paramSTR                    VARCHAR(256)
        ,@PassphraseEnteredByUser     VARCHAR(128)
	
SET NOCOUNT ON

	
BEGIN TRY
	SELECT @isValid = 0
	
	-- Получаем тип авторизации
	SELECT @pr_383 = pr_383.[Value]
	FROM   cm_object_property_st pr_383 WITH(NOLOCK)
	       JOIN cm_user su
	            ON  su.User_id = pr_383.Object_id
	                AND pr_383.Property_id = -383
	WHERE  su.[Login] = @UserName
	
	IF @pr_383 NOT IN (-11168, -11345)
	BEGIN
	    SELECT @errmsg = 'Проверка типа авторизации логина {c} не поддерживается.'
	    SELECT @paramSTR = '[c, ' + @UserName + ', 9]' -- 
	    SELECT @errmsgXML = dbo.cm_f_error_2_XML(OBJECT_NAME(@@PROCid), @errmsg, @paramSTR, NULL)
	    RAISERROR(@errmsgXML, 16, 1)
	END
	
	IF @pr_383 = -11168 -- Шифрованный пароль
	BEGIN
	    SET @PassphraseEnteredByUser = 'Common'
	    
	    IF EXISTS (
	           SELECT *
	           FROM   cm_user m
	                  JOIN sx_user_pass p
	                       ON  m.[User_id] = p.USER_ID
	           WHERE  [Login] = @UserName
	                  AND CONVERT(NVARCHAR, DecryptByPassPhrase(@PassphraseEnteredByUser, p.[PassWord], 1, CONVERT(VARBINARY, m.User_id))) = @Pass
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
	           FROM   cm_user m
	                  left JOIN sx_user_pass p
	                       ON  m.[User_id] = p.USER_ID
	           WHERE  [Login] = @UserName
	                  AND (p.[PassWord] = HASHBYTES('SHA2_512', @Pass) OR (p.[PassWord] IS NULL AND @Pass IS NULL))
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
	SELECT @errmsgxml = dbo.cm_f_msg_err(OBJECT_NAME(@@PROCid), ERROR_MESSAGE(), ERROR_PROCEDURE(), ERROR_NUMBER(), ERROR_LINE(), ERROR_STATE(), ERROR_SEVERITY())
	
	RAISERROR (@errmsgxml, 16, 1) 
	WITH NOWAIT
END CATCH
	-------------------------
GO

GRANT EXEC ON sx_check_pass TO AppUsers
