IF EXISTS (
       SELECT *
       FROM   sysobjects
       WHERE  TYPE         = 'P'
              AND NAME     = 'sp_create_user_db'
   )
BEGIN
    DROP PROCEDURE sp_create_user_db
END

GO

CREATE PROCEDURE dbo.sp_create_user_db
(
	@UserName           SYSNAME = NULL OUT
   ,@UserNameMask       SYSNAME = NULL
   ,@DefDB              SYSNAME = NULL
   ,@Name               VARCHAR(256)
   ,@PassWord           VARCHAR(256) = ''
   ,@E_Mail             VARCHAR(256) = NULL
   ,@Tel                VARCHAR(256) = NULL
   ,@TelMob             VARCHAR(256) = NULL
   ,@TypeSecurityID     SMALLINT = NULL
   ,@UserID             INT = NULL OUT
   ,@pr_225             VARCHAR(64) = NULL
   ,@pr_232             VARCHAR(64) = NULL
   ,@pr_234             VARCHAR(64) = NULL
   ,@DocTemplateID      INT = NULL
   ,@needCheckLogin     BIT = 1
   ,@UserGroupID        INT = NULL
)--WITH
 -- EXECUTE AS OWNER
AS
	DECLARE @errmsg VARCHAR(8000) /* Проверка открытия транзакции */
	        ,@errmsgXML VARCHAR(8000)
	        ,@paramSTR VARCHAR(256)
	
	DECLARE @sSql           AS NVARCHAR(MAX) = ''
	        ,@N             INT
	        ,@ContactID     INT
	
	SET NOCOUNT ON
	
	BEGIN TRY
		IF @DocTemplateID IS NULL
		BEGIN
		    SELECT @DocTemplateID = CAST(ms.[Value] AS INT)
		    FROM   mn_setup ms
		    WHERE  ms.SetupID = -64
		END
		
		IF @TypeSecurityID IS NULL
		   AND NOT @DocTemplateID IS NULL
		BEGIN
		    SELECT @TypeSecurityID = pr_558.[Value]
		    FROM   mn_object_property_tp pr_558
		    WHERE  pr_558.ObjectID = @DocTemplateID
		           AND pr_558.PropertyID = -558
		END
		
		IF @TypeSecurityID IS NULL
		BEGIN
		    SELECT @errmsg = 
		           'Не передан тип авторизации пользователя и не указана глобальная настройка =Шаблон пользователя ='
		    
		    SELECT @errmsgXML = dbo.f_error_2_XML(OBJECT_NAME(@@PROCID), 'SqlRe236', 'TLRCommonResDB', @errmsg, NULL)
		    RAISERROR(@errmsgXML, 16, 1)
		END	
		
		IF @UserName IS NULL
		   AND @TypeSecurityID IN (-11345, -11168, -11167)
		BEGIN
		    SELECT @errmsg = 'Для данного вида авторизации необходимо указать имя пользователя.'
		    SELECT @errmsgXML = dbo.f_error_2_XML(OBJECT_NAME(@@PROCID), 'SqlRe149', 'TLRCommonResDB', @errmsg, NULL)
		    RAISERROR(@errmsgXML, 16, 1)
		END
		
		IF @UserName IS NULL
		   AND @UserNameMask IS NULL
		BEGIN
		    SELECT @errmsg = 'Необходимо указать имя либо маску имени пользователя.'
		    SELECT @errmsgXML = dbo.f_error_2_XML(OBJECT_NAME(@@PROCID), 'SqlRe237', 'TLRCommonResDB', @errmsg, NULL)
		    RAISERROR(@errmsgXML, 16, 1)
		END 
		
		IF NOT @TypeSecurityID IN (-11345, -11168, -11167)
		BEGIN
		    -- Определяем конечное имя пользователя
		    IF @UserName IS NULL
		    BEGIN
		        SELECT @N = MAX(m.N)
		        FROM   (
		                   SELECT d.Name, SUBSTRING(d.[name], LEN(@UserNameMask), 100) AS N
		                   FROM   sys.syslogins d
		                   WHERE  d.[name] LIKE @UserNameMask
		                          AND ISNUMERIC(SUBSTRING(d.[name], LEN(@UserNameMask), 100)) = 1
		               ) m
		        
		        SELECT @N = ISNULL(@N, 0) + 1
		        
		        SELECT @UserName = REPLACE(@UserNameMask, '%', LTRIM(STR(@N)))
		    END
		    
		    IF EXISTS (
		           SELECT *
		           FROM   sys.syslogins s
		           WHERE  s.name = @UserName
		       )
		    BEGIN
		        IF @needCheckLogin = 1
		        BEGIN
		            SELECT @errmsg = 'Логин SQL SERVER {c} уже существует.'
					SELECT @paramSTR = '[c, ' + @UserName + ', 9]' -- 
					SELECT @errmsgXML = dbo.f_error_2_XML(OBJECT_NAME(@@PROCID), 'SqlRe230', 'TLRCommonResDB', @errmsg, @paramSTR)
					RAISERROR(@errmsgXML, 16, 1)
		        END
		    END
		    ELSE
		    BEGIN
		        SELECT @sSql = 'CREATE LOGIN [' + @UserName + '] WITH PASSWORD = ''' + @PassWord +
		               ''', CHECK_POLICY = OFF'
		        
		        IF NOT @DefDB IS NULL
		            SELECT @sSql = @sSql + ', DEFAULT_DATABASE = ' + @DefDB
		    END	
		    
		    
		    SELECT @sSql = @sSql -- 
		           + dbo.f_CrLf() --
		           + 'EXEC sp_adduser ''' + @UserName + ''', ''' + @UserName + ''', ''TetraUsers''' 
		    
		    --
		    --PRINT @sSQL
		    --RETURN
		    --  
		    
		    EXEC dbo.sp_executesql @sSQL
		END
		
		BEGIN TRAN /* ========================== Начинаем транзакцию ============================== */
		
		/* Создаём пользователя */
		
		SELECT @UserID = NULL
		
		EXEC dbo.mn_ins_object
		     @ClassID = -20001
		    ,@ObjectID = @UserID OUT
		
		INSERT INTO sc_user(UserID, [Login])
		VALUES(@UserID, @UserName)
		
		INSERT INTO mn_object_property_vl(ObjectID, PropertyID, [Value])
		VALUES(@UserID, -222, @Name)
		
		IF NOT @pr_225 IS NULL
		    INSERT INTO mn_object_property_vl(ObjectID, PropertyID, [Value])
		    VALUES(@UserID, -225, @pr_225)
		
		IF NOT @pr_232 IS NULL
		    INSERT INTO mn_object_property_vl(ObjectID, PropertyID, [Value])
		    VALUES(@UserID, -232, @pr_232)
		
		IF NOT @pr_234 IS NULL
		    INSERT INTO mn_object_property_vl(ObjectID, PropertyID, [Value])
		    VALUES(@UserID, -234, @pr_234)
		
		INSERT INTO mn_object_state(ObjectID, StateID, StateValueID)
		VALUES(@UserID, -2001, -5023)
		
		
		IF NOT @DocTemplateID IS NULL
		BEGIN
		    INSERT INTO mn_object_property_ob(ObjectID, PropertyID, [Value])
		    VALUES (@UserID, -464, @DocTemplateID)
		END 
		
		
		IF NOT @TypeSecurityID IS NULL
		BEGIN
		    INSERT INTO mn_object_property_tp(ObjectID, PropertyID, [Value])
		    VALUES(@UserID, -383, @TypeSecurityID)
		END
		
		--- Закончили свойства		
		EXEC dbo.sc_ins_log @ObjectID = @UserID
		    ,@ObjectName = @Name
		    ,@ActionID = 1
		    ,@UserID = @UserID
		
		EXEC dbo.mn_set_fullname_object @ObjectID = @UserID
		    ,@isNew = 1
		
		EXEC dbo.mn_iu_user @ObjectID = @UserID
		
		-- Устанавливаем пароль пользователям, которые хранятся в таблице
		IF @TypeSecurityID IN (-11345, -11168)
		BEGIN
		    EXEC dbo.sp_change_pass @UserName = @UserName
		        ,@PassNew = @PassWord
		END
		
		-- Включаем пользователя в группу
		IF @UserGroupID IS NULL
		BEGIN
		    SELECT @UserGroupID = CAST(ms.[Value] AS INT)
		    FROM   mn_setup ms
		    WHERE  ms.SetupID = -61
		END
		
		IF NOT @UserGroupID IS NULL
		BEGIN
		    INSERT INTO sc_user_group(UserGroupID, UserID)
		    VALUES (@UserGroupID, @UserID)
		END 
		
		/* Создаём контакт */
		IF NOT @E_Mail IS NULL
		BEGIN
		    EXEC dbo.mn_ins_object @ClassID = -21210
		        ,@ObjectID = @ContactID OUT
		    
		    INSERT INTO co_contact(ContactID, [Name], StateValueID, pr_531, pr_530, pr_529, pr_528, pr_527)
		    VALUES(@ContactID, @Name, -5053, 0, 0, 1, 0, 0)
		    
		    INSERT INTO co_contact_address(ContactID, PropertyID, AddressText)
		    VALUES (@ContactID, -539, @E_Mail)            
		    
		    IF NOT @TelMob IS NULL
		    BEGIN
		        INSERT INTO co_contact_address(ContactID, PropertyID, AddressText)
		        VALUES (@ContactID, -537, @TelMob)
		    END 
		    
		    IF NOT @Tel IS NULL
		    BEGIN
		        INSERT INTO co_contact_address(ContactID, PropertyID, AddressText)
		        VALUES (@ContactID, -538, @Tel)
		    END 
		    
		    EXEC dbo.sc_ins_log @ObjectID = @ContactID
		        ,@ObjectName = @Name
		        ,@ActionID = 1
		        ,@UserID = @UserID
		    
		    EXEC dbo.mn_set_fullname_object @ObjectID = @ContactID
		        ,@isNew = 1
		    
		    EXEC dbo.co_iu_contact @ObjectID = @ContactID
		    
		    -- Регистрируем контакт пользователя
		    INSERT INTO mn_object_property_ob(ObjectID, PropertyID, [Value])
		    VALUES (@UserID, -471, @ContactID)
		END
		
		COMMIT /* ========================== Закрываем транзакцию ============================== */
	END TRY
	
	/* ======== Обработчик ошибок ======== */
	BEGIN CATCH
		IF @@TRANCOUNT > 0
		    ROLLBACK	
		
		SELECT @errmsgxml = dbo.f_msg_err(
		           OBJECT_NAME(@@PROCID), ERROR_MESSAGE(), ERROR_PROCEDURE(), ERROR_NUMBER(), ERROR_LINE(), ERROR_STATE(), ERROR_SEVERITY()
		       )
		
		RAISERROR (@errmsgxml, 16, 1) 
		WITH NOWAIT
	END CATCH
	-------------------------
GO

GRANT EXEC ON sp_create_user_db TO TetraUsers
