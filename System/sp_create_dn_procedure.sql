IF EXISTS (
       SELECT *
       FROM   sysobjects
       WHERE  TYPE = 'P'
              AND NAME = 'sp_create_dn_procedure'
   )
BEGIN
    DROP PROCEDURE sp_create_dn_procedure
END

GO

CREATE PROCEDURE dbo.sp_create_dn_procedure
AS
	DECLARE @sSql AS NVARCHAR(MAX)
	        ,@sSql1 AS NVARCHAR(MAX)
	        ,@sSelect AS VARCHAR(MAX)
	        ,@sFrom AS VARCHAR(MAX)
	        ,@sSelect1 AS VARCHAR(MAX)
	        ,@sFrom1 AS VARCHAR(MAX)
	        ,@sWhere AS VARCHAR(MAX)
	        ,@ClassID SMALLINT
	        ,@ClassID_Slave SMALLINT
	        ,@ClassList VARCHAR(MAX)
	
	DECLARE @tmp_class TABLE
	(
		ClassID_Fullname SMALLINT
		, ClassID_Slave SMALLINT
		, F BIT DEFAULT 0
		, sSQL VARCHAR(MAX)
	)
	
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
	    
	    SELECT @sSelect = 'select mo.ObjectID, '''''
	    
	    SELECT @sFrom = 'from #tmp_object_fullname t' + dbo.f_CrLf() --
	           + 'join mn_object mo on mo.ObjectID  = t.ObjectID' + dbo.f_CrLf() --
	    
	    SELECT @sWhere = '' --+ dbo.f_CrLf() -- 
	    
	    /* Вызываем процедуру расчета строк запроса */
	    SELECT @sFrom1 = '', @sSelect1 = ''	
	    
	    EXEC dbo.sp_create_fullname_sql @ClassID = @ClassID 
	    	, @ClassID_Slave = @ClassID_Slave 
	    	, @sFrom = @sFrom1 OUT 
	    	, @sSelect = @sSelect1 OUT
	    
	    SELECT @sFrom = @sFrom + @sFrom1, @sSelect = @sSelect + ' ' + @sSelect1 --+ dbo.f_CrLf()
	    
	    SELECT @sSql1 = ' update mo set mo.Fullname = m.Fullname' + dbo.f_CrLf() --
	           + ' from #tmp_object_fullname mo' + dbo.f_CrLf() --
	           + ' join (' + dbo.f_r_build_sql(@sSelect, @sFrom, @sWhere, '', '') + ') m on m.ObjectID = mo.ObjectID'
	    
	    /* ============= Формирование итоговой строки SQL =============== */
/*
	    SELECT @sSql = @sSql + dbo.f_CrLf() + '/* ========= ' + LTRIM(STR(@ClassID_Slave)) + ' (' + LTRIM(STR(@ClassID)) + ') '
	           + '*/' + dbo.f_CrLf() --
	           + 'if @ClassRID = ' + LTRIM(STR(@ClassID_Slave)) + dbo.f_CrLf() --
	                                                                    --+ 'if exists (select * from cl_subclass sc where sc.ClassID_Slave = @ClassID and sc.ClassID_master = '
	                                                                    --+ LTRIM(STR(@ClassID_Slave)) + ')'  + dbo.f_CrLf() --
	           + 'begin' + dbo.f_CrLf() --
	           + '' + @sSql1 + dbo.f_CrLf() -- 
	           + 'return' + dbo.f_CrLf() --
	           + 'end' + dbo.f_CrLf() --
*/	    
---'
	    UPDATE @tmp_class
	    SET    F              = 1
	    	, sSQL            = @sSql1
	    WHERE  ClassID_Slave  = @ClassID_Slave

	END

---
--SELECT * FROM @tmp_class
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
	                                          WHEN @ClassList = '' THEN ''
	                                          ELSE ','
	                                     END + LTRIM(STR(t.ClassID_Slave))
	    FROM   @tmp_class t
	    WHERE  t.sSQL = @sSql1
	           
	           ---
	           --PRINT '=================='
	           --PRINT @ClassList
	           --PRINT @sSql
	           ---

	    SELECT @sSql = @sSql + dbo.f_CrLf() -- 
			+ '/* ========= ' + @ClassList + '*/' + dbo.f_CrLf() --
			+ 'IF @ClassRID IN (' + @ClassList + ')' + dbo.f_CrLf() --
			+ 'BEGIN' + dbo.f_CrLf() --
			+  @sSql1 + dbo.f_CrLf() -- 
			+ 'RETURN' + dbo.f_CrLf() --
			+ 'END' + dbo.f_CrLf() --

	END

	
	/*  Удаляем процедуру */
	SELECT @sSql1 = 
	       'IF EXISTS ( SELECT  *
            FROM    sysobjects
            WHERE   name = ''dn_set_fullname'') 
		DROP PROCEDURE dn_set_fullname' 
	--PRINT @sSql1
	EXEC dbo.sp_executesql @sSQL1
	
	/* Создаем процедуру */
	SELECT @sSql1 = 'CREATE PROCEDURE dn_set_fullname (@ClassID smallint)' + dbo.f_CrLf() --
	       + 'AS' + dbo.f_CrLf() --
	       + 'BEGIN' + dbo.f_CrLf() --
	       + 'declare @ClassRID smallint' + dbo.f_CrLf() --
	       + dbo.f_CrLf() --
	       +'/* CREATE TABLE #tmp_object_fullname (ObjectID int, Fullname varchar(max)) */' + dbo.f_CrLf() --
	       + 'select @ClassRID = m.ClassID_Slave from dbo.cl_subclass_for_calc_fullname m' + dbo.f_CrLf() --
	       + 'join cl_subclass cs on cs.ClassID_Master=m.ClassID_Slave and cs.ClassID_Slave = @ClassID' + dbo.f_CrLf() --
	       + @sSql + dbo.f_CrLf() --
	       + 'RETURN' + dbo.f_CrLf() -- 
	       + 'END'
	
	--PRINT @sSql1
	EXEC dbo.sp_executesql @sSQL1
	
	/* Даём права */
	SELECT @sSql1 = 'GRANT EXECUTE ON dn_set_fullname TO TetraUsers' + dbo.f_CrLf()
	--PRINT @sSql1
	EXEC dbo.sp_executesql @sSQL1
GO
GRANT EXEC ON sp_create_dn_procedure TO TetraUsers
