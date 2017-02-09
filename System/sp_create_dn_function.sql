IF EXISTS (
       SELECT *
       FROM   sysobjects
       WHERE  TYPE         = 'P'
              AND NAME     = 'sp_create_dn_function'
   )
BEGIN
    DROP PROCEDURE sp_create_dn_function
END

GO

CREATE PROCEDURE dbo.sp_create_dn_function
AS
	DECLARE @tmp_class TABLE 
	( 
		ClassID_Fullname SMALLINT
	   ,ClassID_Slave SMALLINT
	   ,F BIT DEFAULT 0
	   ,sSQL VARCHAR(MAX)
	)
	
	DECLARE @sSql               NVARCHAR(MAX)
	        ,@sSql1             NVARCHAR(MAX)
	        ,@sSelect           VARCHAR(MAX)
	        ,@sFrom             VARCHAR(MAX)
	        ,@sSelect1          AS VARCHAR(MAX)
	        ,@sFrom1            VARCHAR(MAX)
	        ,@sWhere            VARCHAR(MAX)
	        ,@ClassID           SMALLINT
	        ,@ClassID_Slave     SMALLINT
	        ,@ClassList         VARCHAR(MAX)
	
	
	SET NOCOUNT ON
	
	-- Получаем список классов для расчета		
	INSERT INTO @tmp_class (ClassID_Fullname, ClassID_Slave)
	SELECT m.ClassID, m.ClassID_Slave
	FROM   dbo.cl_subclass_for_calc_fullname m
	
	---
	--SELECT * FROM @tmp_class
	---
	SELECT @sSql = ''
	
	/* Цикл по классам */
	WHILE 1 = 1
	BEGIN
	    SELECT @ClassID = t.ClassID_Fullname, @ClassID_Slave = t.ClassID_Slave
	    FROM   @tmp_class t
	    WHERE  t.F = 0
	    --AND t.ClassID_Slave = 21711
	    
	    IF @@ROWCOUNT < 1
	        BREAK
	    
	    SELECT @sSelect = 'SELECT mo.ObjectID, '''''
	    
	    SELECT @sFrom = 'FROM mn_object mo' + dbo.f_CrLf()
	    --       + 'join cl_subclass sc on sc.ClassID_Slave = mo.ClassID and sc.ClassID_master = @ClassRID' --+ LTRIM(STR(@ClassID_Slave))
	    --       + dbo.f_CrLf()
	    --       + 'left join mn_object_del mod on mod.ObjectID = mo.ObjectID' --+ dbo.f_CrLf()
	    
	    --SELECT @sWhere = 'WHERE mod.ObjectID is NULL' --+ dbo.f_CrLf() -- 
	    
	    SELECT @sWhere = 'WHERE mo.ObjectID = @ObjectID' --+ dbo.f_CrLf()
	    
	    /* Вызываем процедуру расчета строк запроса */
	    SELECT @sFrom1 = '', @sSelect1 = ''	
	    EXEC dbo.sp_create_fullname_sql @ClassID = @ClassID
	        ,@ClassID_Slave = @ClassID_Slave
	        ,@sFrom = @sFrom1 OUT
	        ,@sSelect = @sSelect1 OUT
	    
	    SELECT @sFrom = @sFrom + ' ' + @sFrom1, @sSelect = @sSelect + ' ' + @sSelect1
	    
	    SELECT @sSql = dbo.f_r_build_sql(@sSelect, @sFrom, @sWhere, '', '')
	    
	    UPDATE @tmp_class
	    SET    F = 1, sSQL       = @sSql
	    WHERE  ClassID_Slave     = @ClassID_Slave
	END /*Конец цикла по классам*/
	
	---
	--SELECT * FROM @tmp_class
	--RETURN
	---
	
	SELECT @sSql = '', @sSql1 = ''
	
	WHILE 1 = 1
	BEGIN
	    SELECT @sSql1 = t.sSQL
	    FROM   @tmp_class t
	    WHERE  t.sSql > @sSql1
	    ORDER BY t.sSQL DESC
	    
	    IF @@ROWCOUNT < 1
	        BREAK
	    
	    SELECT @ClassList = ''
	    
	    SELECT @ClassList = @ClassList + CASE 
	                                     	WHEN @ClassList = '' 
	                                     	THEN ''
	                                     	ELSE ','
	                                     END + LTRIM(STR(t.ClassID_Slave))
	    FROM   @tmp_class t
	    WHERE  t.sSQL = @sSql1
	           
	           --PRINT '=================='
	           --PRINT @ClassList
	           --PRINT @sSql
	           
	           /* ============= Формирование итоговой строки SQL =============== */
	           /*
	           SELECT @sSql = @sSql + dbo.f_CrLf() + '/* ========= ' + @ClassList
	           + '*/' + dbo.f_CrLf() --
+ '
	    
	    IF @ClassRID IN (' + @ClassList + ')' + dbo.f_CrLf() --
+ '
	    BEGIN
	        ' + dbo.f_CrLf() --
+ '
	        IF @ObjectID IS NULL' + dbo.f_CrLf() --
+ '
	        BEGIN
	            ' + dbo.f_CrLf() --
+ 'INSERT INTO @Res (ObjectID, FullName)
	            ' + dbo.f_CrLf() --
+ '' + @sSql1 + dbo.f_CrLf() -- 
+ '
	        END' + dbo.f_CrLf() --
+ '
	        ELSE
	            ' + dbo.f_CrLf() --
+ '
	        BEGIN
	            ' + dbo.f_CrLf() --
+ 'INSERT INTO @Res (ObjectID, FullName)
	            ' + dbo.f_CrLf() --
+ '' + @sSql1 + dbo.f_CrLf() -- 
+ 'AND mo.ObjectID = @ObjectID' + dbo.f_CrLf()
+ '
	        END' + dbo.f_CrLf() --
+ 'RETURN' + dbo.f_CrLf() --
+ '
	    END' + dbo.f_CrLf() --
*/
SELECT @sSql = @sSql + dbo.f_CrLf() -- 
+ '/* ========= ' + @ClassList + '*/' + dbo.f_CrLf() --
+ '
	    
	    IF @ClassRID IN (' + @ClassList + ')' + dbo.f_CrLf() --
+ '
	    BEGIN
	        ' + dbo.f_CrLf() --
+ '
	        SELECT @FullName = m.FullName' + dbo.f_CrLf() --
+ '
	        FROM   ' + dbo.f_CrLf() --
+ '(' + @sSql1 + ') m' + dbo.f_CrLf() -- 
+ '
	        
	        RETURN @FullName' + dbo.f_CrLf() --
+ '
	    END' + dbo.f_CrLf() --

END
	
/*  Удаляем функцию */
SELECT @sSql1 = '
	    
	    IF EXISTS (
	           SELECT *
	           FROM   sysobjects
	           WHERE  NAME = ''dn_f_sel_fullname''
	       )
	        DROP FUNCTION dn_f_sel_fullname' 

--'
	    --PRINT @sSql1
	    EXEC dbo.sp_executesql @sSQL1
	    
	    /* Создаем функцию */
	    /*
	    SELECT @sSql1 = 'CREATE FUNCTION dn_f_sel_fullname (@ClassID smallint, @ObjectID int)' + dbo.f_CrLf() --
	    + 'RETURNS @Res TABLE(ObjectID int, FullName varchar(8000) PRIMARY KEY CLUSTERED (ObjectID))' + dbo.f_CrLf() --
	    + 'AS' + dbo.f_CrLf() --
	    + 'BEGIN' + dbo.f_CrLf() --
	    + 'declare @ClassRID smallint' + dbo.f_CrLf() --
	    + dbo.f_CrLf() --
	    + 'select @ClassRID = m.ClassID_Slave from dbo.cl_subclass_for_calc_fullname m' + dbo.f_CrLf() --
	    + 'join cl_subclass cs on cs.ClassID_Master=m.ClassID_Slave and cs.ClassID_Slave = @ClassID' + dbo.f_CrLf() --
	    + @sSql + dbo.f_CrLf() --
	    + 'RETURN' + dbo.f_CrLf() -- 
	    + 'END'
	    */
	    
	    SELECT @sSql1 = 'CREATE FUNCTION dn_f_sel_fullname (@ClassID smallint, @ObjectID int)' + dbo.f_CrLf() --
	           + 'RETURNS varchar(8000)' + dbo.f_CrLf() --
	           + 'AS' + dbo.f_CrLf() --
	           + 'BEGIN' + dbo.f_CrLf() --
	           + 'declare @ClassRID smallint' + dbo.f_CrLf() --
	           + ', @FullName varchar(8000)' + dbo.f_CrLf() --
	           + dbo.f_CrLf() --
	           + 'select @ClassRID = m.ClassID_Slave from dbo.cl_subclass_for_calc_fullname m' + dbo.f_CrLf() --
	           + 
	           'join cl_subclass cs on cs.ClassID_Master=m.ClassID_Slave and cs.ClassID_Slave = @ClassID' 
	           + dbo.f_CrLf() --
	           + @sSql + dbo.f_CrLf() --
	           + 'RETURN @FullName' + dbo.f_CrLf() -- 
	           + 'END'
	    
	    ---
	    --CREATE TABLE ##ttt(sSql NVARCHAR(MAX))
	    --INSERT INTO ##ttt(sSql)
	    --VALUES (@sSql1)
	    --PRINT @sSql1
	    ---
	    EXEC dbo.sp_executesql @sSQL1
	    
	    /* Даём права */
	    SELECT @sSql1 = 'GRANT EXECUTE ON dn_f_sel_fullname TO TetraUsers' + dbo.f_CrLf()
	    --PRINT @sSql1
	    EXEC dbo.sp_executesql @sSQL1
	    
	    GO
	    
	    GRANT EXEC ON sp_create_dn_function TO TetraUsers
