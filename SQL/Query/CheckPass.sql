IF EXISTS (
       SELECT *
       FROM   sysobjects
       WHERE  TYPE         = 'P'
              AND NAME     = 'CheckPass'
   )
BEGIN
    DROP PROCEDURE CheckPass
END

GO

CREATE PROCEDURE CheckPass
(
	 @Mail		   VARCHAR(256)
	,@Pass         NVARCHAR(256)
	,@isValid      BIT = 0 OUT
)            
AS	
	    IF EXISTS (
	           SELECT *
	           FROM   UserList UL
	           WHERE  UL.Mail=@Mail
	                  AND (UL.[Password] = HASHBYTES('SHA2_512', @Pass) OR (ul.[PassWord] IS NULL AND @Pass IS NULL))
	       )
	    BEGIN
	        SELECT @isValid = 1
	    END
	    ELSE
	    BEGIN
	        SELECT @isValid = 0
	    END
GO

GRANT EXEC ON CheckPass TO PUBLIC
