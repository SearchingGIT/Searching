IF EXISTS (
       SELECT *
       FROM   sysobjects
       WHERE  TYPE         = 'P'
              AND NAME     = 'ChangePass'
   )
BEGIN
    DROP PROCEDURE ChangePass
END

GO

CREATE PROCEDURE ChangePass
(
	@Mail        VARCHAR(256)
   ,@PassNew     NVARCHAR(256)
   ,@PassOld     NVARCHAR(256) = NULL
)
AS
	DECLARE @errmsg        VARCHAR(8000)
	        ,@Password     VARBINARY(8000)
	
	IF NOT EXISTS (
	       SELECT *
	       FROM   UserList u
	       WHERE  u.Mail = @Mail
	              AND (u.[Password] = HASHBYTES('SHA2_512', @PassOld) OR u.[Password] IS NULL)
	   )
	BEGIN
	    SELECT @errmsg = 'Пароль указан неверно.'
	    RAISERROR(@errmsg, 16, 1)
	    RETURN	
	END
	
	SELECT @Password = HASHBYTES('SHA2_512', @PassNew)
	
	
	UPDATE u
	SET    u.[Password] = @Password
	FROM   UserList u
	WHERE  u.Mail = @Mail
	

GO	
	GRANT EXEC ON ChangePass TO PUBLIC 
