IF EXISTS (
       SELECT *
       FROM   sysobjects
       WHERE  TYPE = 'P'
              AND NAME = 'sp_create_fullname_sql'
   )
BEGIN
    DROP PROCEDURE sp_create_fullname_sql
END

GO

/* Вспомогательная процедура формирования строки для расчета fullname */
CREATE PROCEDURE dbo.sp_create_fullname_sql
(
	@ClassID          SMALLINT
	, @ClassID_Slave  SMALLINT
	, @sSelect        VARCHAR(MAX) OUT
	, @sFrom          VARCHAR(MAX) OUT
)
AS
	DECLARE @Location         AS VARCHAR(64)
	        ,@NameMetaID      VARCHAR(64)
	        ,@IDName          VARCHAR(64)
	        ,@NameField       VARCHAR(64)
	        ,@PropertyID      SMALLINT
	        ,@DataTypeID      SMALLINT
	        ,@sAlias          VARCHAR(64)
	        ,@LeftS           VARCHAR(24)
	        ,@RightS          VARCHAR(24)
	        ,@NOrder          INT
	        ,@DomainID        SMALLINT
	        ,@iPrecision      INT
	        ,@iScale          INT
	        ,@isMultilingual  TINYINT
	        ,@notFrom         BIT
	
	SET NOCOUNT ON
	
	SELECT @sSelect = ISNULL(@sSelect, ''), @sFrom = ISNULL(@sFrom, '')
	
	
	DECLARE @tmp_list TABLE
	(
		ID INT IDENTITY(1, 1) PRIMARY KEY
		, PropertyID SMALLINT
		, NameTable VARCHAR(64)
		, NameField VARCHAR(64)
		, IDName VARCHAR(64)
		, sAlias VARCHAR(64)
		, NameMetaID VARCHAR(64)
		, LeftS VARCHAR(24)
		, RightS VARCHAR(24)
		, DataTypeID SMALLINT
		, NOrder INT
		, DomainID SMALLINT
		, iPrecision INT
		, iScale INT
	)
	
	INSERT INTO @tmp_list(
	    PropertyID, NameTable, NameField, IDName, sAlias, NameMetaID, LeftS, RightS, DataTypeID, NOrder, DomainID, 
	    iPrecision, iScale
	)
	SELECT DISTINCT
	       cpc.PropertyID, cpc.NameTable, ISNULL(cpc.NameField, 'Value'), cl.IDName, REPLACE ('pr' + LTRIM(STR(cpc.PropertyID)), '-', '_'), 
	       cl.NameMetaID, ISNULL(cf.LeftS, ''), ISNULL(cf.RightS, ''), cd.DataTypeID, cf.NOrder, cd.DomainID, cd .iPrecision, 
	       cd .iScale
	FROM   cl_fullname cf
	       JOIN (
	                SELECT cs.ClassID_Slave, cpc.PropertyID, MIN(cs.LevelP) AS LevelP
	                FROM   cp_property_cl cpc
	                       JOIN cl_subclass cs
	                            ON  cs.ClassID_Master = cpc.ClassID
	                GROUP BY cs.ClassID_Slave, cpc.PropertyID
	            ) sss
	            ON  sss.PropertyID = cf.MetaObjectID
	                AND sss.ClassID_Slave = @ClassID_Slave
	       JOIN cl_subclass cs
	            ON  cs.ClassID_Slave = @ClassID_Slave
	                AND cs.LevelP = sss.LevelP
	       JOIN cp_property_cl cpc
	            ON  cpc.ClassID = cs.ClassID_Master
	                AND cpc.PropertyID = cf.MetaObjectID
	       JOIN cp_location cl
	            ON  cl.Location = cpc.NameTable
	       JOIN cl_property cp
	            ON  cp.PropertyID = cpc.PropertyID
	       JOIN cl_domain cd
	            ON  cd.DomainID = cp.DomainID
	WHERE  cf.ClassID = @ClassID
	UNION ALL
	SELECT DISTINCT
	       cf.MetaObjectID AS PropertyID, NULL AS NameTable, NULL AS VALUE, NULL AS IDName, REPLACE('pr' + LTRIM(STR(cf.MetaObjectID)), '-', '_'), 
	       NULL AS NameMetaID, ISNULL(cf.LeftS, ''), ISNULL(cf.RightS, '') --
	       , CASE 
	              WHEN cf.MetaObjectID = -1 THEN 1
	              ELSE 0
	         END AS DataTypeID, cf.NOrder, 0 AS DomainID, 0 AS iPrecision, 0 AS iScale
	FROM   cl_fullname cf
	       LEFT JOIN cl_property cp
	            ON  cp.PropertyID = cf.MetaObjectID
	WHERE  cf.ClassID = @ClassID
	       AND cp.PropertyID IS NULL
	ORDER BY cf.NOrder 
	
	---
	--SELECT *	FROM   @tmp_list
	---
	
	SELECT @Location = ''
	
	WHILE 1 = 1
	BEGIN
	    SELECT @Location = m.Location
	    FROM   (
	               SELECT t.NameTable AS Location
	               FROM   @tmp_list t
	               WHERE  t.NameMetaID IS NULL
	               GROUP BY t.NameTable
	               HAVING COUNT(*) > 1
	           ) m
	    WHERE  m.Location > @Location
	    ORDER BY m.Location DESC
	    
	    IF @@ROWCOUNT < 1
	        BREAK
	    
	    SELECT @sAlias = 'pr'
	    SELECT @sAlias = @sAlias + '_' + REPLACE (LTRIM(STR(t.PropertyID)), '-', '_')
	    FROM   @tmp_list t
	    WHERE  t.NameTable = @Location
	    
	    UPDATE @tmp_list
	    SET    sAlias     = @sAlias
	    WHERE  NameTable  = @Location
	END
	
	---
	--SELECT *FROM   @tmp_list
	---
	
	/* Формируем курсор по свойствам */
	DECLARE Cur_mn_tmp1 CURSOR LOCAL FORWARD_ONLY 
	FOR
	SELECT t.PropertyID, t.NameTable, t.NameField, t.IDName, t.sAlias, t.NameMetaID, t.LeftS, t.RightS, t.DataTypeID, t.NOrder, 
	       t.DomainID, t.iPrecision, t.iScale
	FROM   @tmp_list t
	ORDER BY t.NOrder 
	
	OPEN Cur_mn_tmp1
	
	FETCH NEXT FROM Cur_mn_tmp1 INTO @PropertyID, @Location, @NameField, @IDName, @sAlias, @NameMetaID, @LeftS, @RightS,
	@DataTypeID, @NOrder, @DomainID, @iPrecision, @iScale
	WHILE (@@FETCH_STATUS <> -1)
	BEGIN
	    SELECT @notFrom = 0
	    
	    IF EXISTS (
	           SELECT *
	           FROM   @tmp_list t
	           WHERE  t.sAlias = @sAlias
	                  AND t.PropertyID <> @PropertyID
	                  AND t.NOrder < @NOrder
	       )
	    BEGIN
	        SELECT @notFrom = 1
	    END
	    
	    ---
	    --SELECT @PropertyID,@notFrom,@sFrom,@Location
	    ---
	    
	    IF ISNULL(@Location, '') = '' -- Не свойства
	    BEGIN
	        IF @PropertyID = -1 -- Код объекта
	        BEGIN
	            SELECT @sSelect = @sSelect + dbo.f_CrLf() + ' + isnull(''' + @LeftS
	                   + ''' + cast(mo.ObjectID as varchar(256)) + ''' + @RightS + ''', '''')'
	        END
	        
	        IF @PropertyID = 0 -- Класс объекта
	        BEGIN
	            SELECT @sFrom = @sFrom + 'left join cl_locale_string as tt_' + @sAlias -- 
	                   + ' on tt_' + @sAlias + '.MetaObjectID = mo.ClassID' + dbo.f_CrLf()
	                   + ' and tt_' + @sAlias + '.LocaleID = -37' + dbo.f_CrLf()
	            
	            SELECT @sSelect = @sSelect + dbo.f_CrLf() + ' + isnull(''' + @LeftS + ''' + tt_' + @sAlias + '.Name + '''
	                   + @RightS + ''', '''')'
	        END
	        
	        IF ABS(@PropertyID) > 999 -- Указан класс. Запускаем агрегирование
	        BEGIN
	            SELECT @sFrom = @sFrom + 'left join (mn_object_aggregation og_' + @sAlias + dbo.f_CrLf() -- 
	                   + 'join mn_object mo_' + @sAlias + ' on mo_' + @sAlias + '.ObjectID = og_' + @sAlias
	                   + '.ObjectID_Master and mo_' + @sAlias + '.ClassID = ' + LTRIM(STR(@PropertyID)) + dbo.f_CrLf() -- 
	                   + 'join mn_object_fullname as fn_' + @sAlias + ' on fn_' + @sAlias + '.ObjectID = og_' + @sAlias
	                   + '.ObjectID_Master) on og_' + @sAlias + '.ObjectID_Slave = mo.ObjectID' + dbo.f_CrLf()
	            
	            SELECT @sSelect = @sSelect + dbo.f_CrLf() + ' + isnull(''' + @LeftS + ''' + fn_' + @sAlias + '.FullName + '''
	                   + @RightS + ''', '''')'
	        END
	    END
	    ELSE
	        -- Свойства либо метаданные
	    BEGIN
	        --- Узнаем, не мультиязычные ли они
	        SELECT @isMultilingual = MAX(cpc.isMultilingual)
	        FROM   cl_property_cl cpc
	               JOIN cl_subclass cs
	                    ON  cs.ClassID_Master = cpc.ClassID
	        WHERE  cs.ClassID_Slave = @ClassID_Slave
	               AND cpc.PropertyID = @PropertyID
	        
	        IF @notFrom = 0
	            SELECT @sFrom = @sFrom + 'left join ' + @Location + ' as ' + @sAlias + ' on mo.ObjectID = ' + @sAlias +
	                   '.'
	                   + @IDName 
	        
	        IF NOT @NameMetaID IS NULL
	        BEGIN
	            IF @notFrom = 0
	                SELECT @sFrom = @sFrom + ' and ' + @sAlias + '.' + @NameMetaID + ' = ' + LTRIM(STR(@PropertyID))
	            
	            IF @isMultilingual = 1
	               AND @notFrom = 0
	                SELECT @sFrom = @sFrom + ' and ' + @sAlias + '.LocaleID = -37'
	        END 
	        
	        ---
	        --IF @ClassID = -20025 OR @ClassID_Slave =-20025
	        --BEGIN
	        --	SELECT @sFrom
	        --	SELECT @isMultilingual,@NameMetaID
	        --END
	        ---
	        
	        --IF @notFrom =0
	        SELECT @sFrom = @sFrom + dbo.f_CrLf()
	        
	        
	        -- Дополнительные JOIN
	        IF @DataTypeID = 1 -- Объект
	        BEGIN
	            SELECT @sFrom = @sFrom + 'left join mn_object_fullname as fn_' + @sAlias + 'p' + REPLACE (LTRIM(STR(@PropertyID)), '-', '_') 
	                   + ' on fn_' + @sAlias + 'p' + REPLACE (LTRIM(STR(@PropertyID)), '-', '_') + '.ObjectID = ' 
	                   + @sAlias + '.' + @NameField + dbo.f_CrLf()
	            
	            SELECT @sSelect = @sSelect + dbo.f_CrLf() + ' + isnull(''' + @LeftS + ''' + fn_' + @sAlias + 'p' + REPLACE (LTRIM(STR(@PropertyID)), '-', '_') 
	                   + '.FullName + '''
	                   + @RightS + ''', '''')'
	        END
	        
	        IF @DataTypeID IN (2, 3, 4, 5, 6, 15) -- Метаданные
	        BEGIN
	            SELECT @sFrom = @sFrom + 'left join cl_locale_string as tt_' + @sAlias + 'p' + REPLACE (LTRIM(STR(@PropertyID)), '-', '_') -- 
	                   + ' on tt_' + @sAlias + 'p' + REPLACE (LTRIM(STR(@PropertyID)), '-', '_') + '.MetaObjectID = ' + 
	                   @sAlias + '.' + @NameField + dbo.f_CrLf()
	                   + ' and tt_' + @sAlias + + 'p' + REPLACE (LTRIM(STR(@PropertyID)), '-', '_') + '.LocaleID = -37' 
	                   + dbo.f_CrLf()
	            
	            SELECT @sSelect = @sSelect + dbo.f_CrLf() + ' + isnull(''' + @LeftS + ''' + tt_' + @sAlias + 'p' + REPLACE (LTRIM(STR(@PropertyID)), '-', '_') 
	                   + '.Name + '''
	                   + @RightS + ''', '''')'
	        END
	        
	        IF @DataTypeID = 8 -- Числовые с запятой
	        BEGIN
	            SELECT @sSelect = @sSelect + dbo.f_CrLf() + ' + isnull(''' + @LeftS + ''' + replace(cast(cast(' + @sAlias + '.'
	                   + @NameField + ' as numeric(24,' + LTRIM(STR(@iScale)) + ')) as varchar(256)), ''.' + REPLICATE('0', @iScale)
	                   + ''','''') + ''' + @RightS + ''', '''')'
	        END
	        
	        IF @DataTypeID IN (10, 32) -- Дата
	        BEGIN
	            SELECT @sSelect = @sSelect + dbo.f_CrLf() + ' + isnull(''' + @LeftS + ''' + convert(varchar(8), ' + @sAlias +
	                   '.'
	                   + @NameField + ', 4)'
	            
	            IF @iPrecision = 4
	                -- Дата + Время (мсек)
	                SELECT @sSelect = @sSelect + '+ '' '' +  convert(varchar(8), ' + @sAlias + '.' + @NameField +
	                       ', 14)'
	            
	            IF @iPrecision = 3
	                -- Дата + Время (сек)
	                SELECT @sSelect = @sSelect + '+ '' '' +  convert(varchar(8), ' + @sAlias + '.' + @NameField + ', 8)'
	            
	            IF @iPrecision = 2
	                -- Дата + Время (мин)
	                SELECT @sSelect = @sSelect + '+ '' '' + left(convert(varchar(8), ' + @sAlias + '.' + @NameField
	                       + ', 8), 5)'
	            
	            IF @iPrecision = 1
	                -- Дата + Время (часы)
	                SELECT @sSelect = @sSelect + '+ '' '' + left(convert(varchar(8), ' + @sAlias + '.' + @NameField
	                       + ', 8), 2)'
	            
	            SELECT @sSelect = @sSelect + ' + ''' + @RightS + ''', '''')'
	        END
	        
	        IF @DataTypeID = 22 -- Время (в миллисекундах от полуночи)
	        BEGIN
	            SELECT @sSelect = @sSelect + dbo.f_CrLf() + ' + isnull(''' + @LeftS + ''' + convert(varchar(8), dateadd(ms, '
	                   + @sAlias + '.' + @NameField + ', ''01.01.01''), 8)' + ' + ''' + @RightS + ''', '''')'
	        END
	        
	        IF @DataTypeID NOT IN (1, 2, 3, 4, 5, 6, 8, 10, 15, 22) -- Скалярные значения свойств (без обработки)
	        BEGIN
	            SELECT @sSelect = @sSelect + dbo.f_CrLf() + ' + isnull(''' + @LeftS + ''' + cast(' + @sAlias + '.' + @NameField
	                   + ' as varchar(256)) + ''' + @RightS + ''', '''')'
	        END
	    END
	    
	    --SELECT @sFrom
	    
	    FETCH NEXT FROM Cur_mn_tmp1 INTO @PropertyID, @Location, @NameField, @IDName, @sAlias, @NameMetaID, @LeftS, @RightS,
	    @DataTypeID, @NOrder, @DomainID, @iPrecision, @iScale
	END 
	CLOSE Cur_mn_tmp1 
	DEALLOCATE Cur_mn_tmp1 
	/* ==  Конец курсора == */
	
	SELECT @sSelect = @sSelect + ' as FullName'
	
--	SELECT @sSelect
--	SELECT @sFrom
GO

GRANT EXEC ON sp_create_fullname_sql TO TetraUsers
