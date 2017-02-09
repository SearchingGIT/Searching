
DECLARE @isV BIT

EXEC CheckPass @Mail ='SuccessedRegistration!@mail.ru'
    ,@Pass ='Adolf123'
    ,@isValid  =@isV OUT
    
    SELECT @isV   
