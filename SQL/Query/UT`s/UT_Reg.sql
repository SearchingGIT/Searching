DECLARE @ret INT
DECLARE @isV BIT
	EXEC @ret= RegUser
		@Mail = 'cpi@mail.ru',
		@PassNew = 'restReg3',
		@Name = 'asdezz',
		@LastName ='zzedsa',
		@PHONE = '23',
		@Gender_user = 'æ',
		@Date_Bearthday = '12-12-12',
		@Type_login = '1',
		@City_id = '1',
		@Country_id = '1',
		@Info = 'Info test',
		@Result = @isV OUT
		
		SELECT @ret
	
	