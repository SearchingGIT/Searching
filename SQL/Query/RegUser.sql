
IF EXISTS (
       SELECT *
       FROM   sysobjects
       WHERE  TYPE         = 'P'
              AND NAME     = 'RegUser'
   )
BEGIN
    DROP PROCEDURE RegUser
END

GO

CREATE PROCEDURE RegUser
(
	@Mail               VARCHAR(256)
   ,@PassNew            NVARCHAR(256)
   ,@Name               VARCHAR(256)
   ,@LastName           VARCHAR(256)
   ,@PHONE              VARCHAR(256)=NULL
   ,@Gender_user        CHAR(1)=null
   ,@Date_Birthday      DATE=null
   ,@Type_login         TINYINT
   ,@City_id            INT = NULL
   ,@Country_id         INT = NULL
   ,@Info               VARCHAR(MAX)=null
   ,@Result             BIT = 0 OUT
)
AS
	DECLARE @errmsg VARCHAR(8000)
	
	IF EXISTS(
	       SELECT *
	       FROM   UserList u
	       WHERE  u.Mail = @Mail
	   )
	BEGIN
	    SELECT @errmsg = 'Запись уже существует'
	    RAISERROR(@errmsg, 16, 1)
	    RETURN
	END
	
	INSERT INTO UserList(Mail, NAME, LastName, Phone, Gender_user,Date_Birthday, Type_login, City_id, Info, Country_id)
	VALUES(
	    @Mail, @Name, @LastName, @Phone, @Gender_user, @Date_Birthday, @Type_login, @City_id, @Info, @Country_id
	)
	
	IF  NOT EXISTS(
	       SELECT *
	       FROM   UserList u
	       WHERE  u.Mail = @Mail
	   )
	BEGIN
	    SELECT @errmsg='не правильно введены данные '
	    RAISERROR(@errmsg,16,1)
	    RETURN
	END	
		--SELECT @errmsg = 'Запись успешно добавлена!'
		--RAISERROR(@errmsg,16,1)
	
	EXEC dbo.ChangePass
	     @Mail = @Mail
	    ,@PassNew = @PassNew
GO	
	

	
	
	GRANT EXEC ON RegUser TO PUBLIC 