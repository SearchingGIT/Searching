IF EXISTS (
       SELECT *
       FROM   sysobjects
       WHERE  TYPE         = 'P'
              AND NAME     = 'sp_del_user_db'
   )
BEGIN
    DROP PROCEDURE sp_del_user_db
END

GO

/* Удаление пользователя, контакт и логин к БД */
CREATE PROCEDURE dbo.sp_del_user_db
(
	@UserID INT
)
AS
	DECLARE @errmsg VARCHAR(8000) /* Проверка открытия транзакции */
	        ,@errmsgXML     VARCHAR(8000)
	        ,@paramSTR      VARCHAR(256)
	
	DECLARE @sSql                AS NVARCHAR(MAX) = ''
	        ,@ContactID          INT
	        ,@TypeSecurityID     SMALLINT
	        ,@UserName           SYSNAME
	
	SET NOCOUNT ON
	
	BEGIN TRY
		SELECT @TypeSecurityID = [VALUE]
		FROM   mn_object_property_tp
		WHERE  ObjectID           = @UserID
		       AND PropertyID     = -383
		
		SELECT @ContactID = [VALUE]
		FROM   mn_object_property_ob
		WHERE  ObjectID           = @UserID
		       AND PropertyID     = -471
		
		IF NOT @TypeSecurityID IN (-11345, -11168, -11167)
		BEGIN
		    SELECT @UserName = su.[LOGIN]
		    FROM   sc_user su
		    WHERE  su.UserID = @UserID
		    
		    SELECT @sSql = 'DROP LOGIN [' + @UserName + ']'
		    
		    SELECT @sSql = @sSql --
		           + dbo.f_CrLf() --
		           + 'EXEC sp_dropuser ''' + @UserName + '''' 
		    
		    EXEC dbo.sp_executesql @sSQL
		END 
		
		--
		--PRINT @sSQL
		--RETURN
		--  
		
		BEGIN TRAN /* ========================== Начинаем транзакцию ============================== */
		
		/* Удаляем пользователя */
		
		INSERT INTO mn_object_del(ObjectID)
		VALUES (@UserID)
		
		EXEC dbo.sc_ins_log
		     @ObjectID = @UserID
		    ,@ObjectName = ''
		    ,@ActionID = 1
		
		EXEC dbo.mn_d_user @ObjectID = @UserID
		
		UPDATE sc_user
		SET    [LOGIN] = LTRIM(STR(UserID))
		WHERE  UserID = @UserID 
		
		/* Удаляем контакт */
		IF NOT @ContactID IS NULL
		BEGIN
		    INSERT INTO mn_object_del(ObjectID)
		    VALUES (@ContactID)
		    
		    EXEC dbo.sc_ins_log
		         @ObjectID = @ContactID
		        ,@ObjectName = ''
		        ,@ActionID = 1
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

GRANT EXEC ON sp_del_user_db TO TetraUsers