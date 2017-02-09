IF EXISTS (
       SELECT *
       FROM   sysobjects
       WHERE  TYPE         = 'P'
              AND NAME     = 'sx_change_pass'
   )
BEGIN
    DROP PROCEDURE sx_change_pass
END

GO

CREATE PROCEDURE dbo.sx_change_pass
(
	 @UserName     SYSNAME
	,@PassOld      NVARCHAR(256) = NULL
	,@PassNew      NVARCHAR(256)
)
WITH   
                       
EXECUTE AS OWNER
        AS

DECLARE @errmsg         VARCHAR(8000) /* Проверка открытия транзакции */
        ,@errmsgXML     VARCHAR(8000)
        ,@paramSTR      VARCHAR(256)
	
SET NOCOUNT ON

DECLARE @PassphraseEnteredByUser     VARCHAR(128)
        ,@pr_383                     SMALLINT
        ,@User_id                    INT
        ,@Password                   VARBINARY(8000)
	
BEGIN TRY
	-- Получаем тип авторизации
	SELECT @pr_383 = pr_383.[Value]
	      ,@User_id = su.[User_id]
	FROM   mn_object_property_tp pr_383
	       JOIN cm_user su
	            ON  su.User_id = pr_383.Object_id
	                AND pr_383.Property_id = -383
	WHERE  su.[Login] = @UserName
	
	IF @pr_383 = -11168 -- Шифрованный пароль
	BEGIN
	    SET @PassphraseEnteredByUser = 'Common'
	    
	    IF NOT EXISTS (
	           SELECT *
	           FROM   cm_user m
	                  LEFT JOIN sx_user_pass p
	                       ON  m.[User_id] = p.USER_ID
	           WHERE  [Login] = @UserName
	                  AND (
	                          CONVERT(NVARCHAR, DecryptByPassPhrase(@PassphraseEnteredByUser, p.[PassWord], 1, CONVERT(VARBINARY, m.User_id))) 
	                          = @PassOld
	                          OR p.[PassWord] IS NULL
	                      )
	       )
	    BEGIN
	        SELECT @errmsg = 'Пароль указан неверно.'
		    SELECT @errmsgXML = dbo.cm_f_error_2_XML(OBJECT_NAME(@@PROCid), @errmsg, NULL, NULL)
	        RAISERROR(@errmsgXML, 16, 1)
	    END
	    
	    SELECT @Password = EncryptByPassPhrase(@PassphraseEnteredByUser, @PassNew, 1, CONVERT(VARBINARY, @User_id))
	END
	
	IF @pr_383 = -11345 -- Хэш функция
	BEGIN
	    IF NOT EXISTS (
	           SELECT *
	           FROM   cm_user m
	                  LEFT JOIN sx_user_pass p
	                       ON  m.[User_id] = p.USER_ID
	           WHERE  [Login] = @UserName
	                  AND (p.[PassWord] = HASHBYTES('SHA2_512', @PassOld) OR p.[PassWord] IS NULL)
	       )
	    BEGIN
	        SELECT @errmsg = 'Пароль указан неверно.'
		    SELECT @errmsgXML = dbo.cm_f_error_2_XML(OBJECT_NAME(@@PROCid), @errmsg, NULL, NULL)
	        RAISERROR(@errmsgXML, 16, 1)
	    END
	    
	    SELECT @Password = HASHBYTES('SHA2_512', @PassNew)
	END
	
	UPDATE su
	SET    su.[PassWord] = @Password
	FROM   sx_user_pass su
	WHERE  su.User_id = @User_id
	
	IF @@ROWCOUNT < 1
	    INSERT INTO dbo.sx_user_pass(USER_ID, PASSWORD)
	    VALUES (@User_id, @Password)
END TRY
	
/* ======== Обработчик ошибок ======== */
BEGIN CATCH
	SELECT @errmsgxml = dbo.cm_f_msg_err(OBJECT_NAME(@@PROCid), ERROR_MESSAGE(), ERROR_PROCEDURE(), ERROR_NUMBER(), ERROR_LINE(), ERROR_STATE(), ERROR_SEVERITY()) 
	RAISERROR (@errmsgxml, 16, 1) WITH NOWAIT
END CATCH
	-------------------------
GO

GRANT EXEC ON sx_change_pass TO AppUsers
