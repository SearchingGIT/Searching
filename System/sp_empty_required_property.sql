IF EXISTS (
       SELECT *
       FROM   sysobjects
       WHERE  NAME = 'sp_empty_required_property'
   )
    DROP PROCEDURE sp_empty_required_property    
GO

/* Вовращает список обязательных свойств, которые не заполнены */
CREATE PROCEDURE dbo.sp_empty_required_property
AS
	DECLARE @tmp_property TABLE 
	( 
		ID INT IDENTITY(1, 1)
	   ,PropertyID SMALLINT
	   ,StateValueID SMALLINT NULL
	)
	
	DECLARE @tmp_state TABLE 
	( 
		ID INT IDENTITY(1, 1)
	   ,StateID SMALLINT
	)
	
	DECLARE @sSelect              AS VARCHAR(8000)
	        ,@sFrom               AS VARCHAR(8000)
	        ,@sWhere              AS VARCHAR(8000)
	        ,@sSql                AS NVARCHAR(4000)
	        ,@ClassID             SMALLINT
	        ,@PropertyID          INT
	        ,@errmsg              VARCHAR(8000)
	        ,@Location            AS VARCHAR(8000)
	        ,@NameField           AS VARCHAR(8000)
	        ,@IDName              AS VARCHAR(8000)
	        ,@NameMetaID          AS VARCHAR(8000)
	        ,@StateValueID        SMALLINT
	        ,@LocationState       AS VARCHAR(8000)
	        ,@NameFieldState      AS VARCHAR(8000)
	        ,@IDNameState         AS VARCHAR(8000)
	        ,@ID                  INT
	        ,@List_arx_object     AS VARCHAR(8000)
	        ,@DataTypeID          SMALLINT
	        ,@StateID             SMALLINT
	
	--EXEC sp_msdroptemptable '#tmp_list'
	
	
	CREATE TABLE #tmp_list
	(
		ClassID        SMALLINT
	   ,ObjectID       INT
	   ,PropertyID     SMALLINT
	   ,isDel          BIT
	)
	
	SET NOCOUNT ON
	
	--SET FMTONLY OFF
	
	-- Получаем view, в котрой хнанится список архивных объектов
	SELECT @List_arx_object = cf.List_arx_object
	FROM   cc_flag cf
	
	SELECT @ClassID = -32000
	
	WHILE 1 = 1 -- Цикл по классам
	BEGIN
	    SELECT @ClassID = cc.ClassID
	    FROM   cl_class cc
	           LEFT JOIN cl_subclass cs
	                ON  cs.ClassID_Master = cc.ClassID
	                    AND cs.ClassID_Master <> cs.ClassID_Slave
	    WHERE  cc.ClassID > @ClassID
	           AND cs.ClassID_Slave IS NULL
	               --AND cc.ClassID = 21190
	    ORDER BY cc.ClassID DESC
	    
	    IF @@ROWCOUNT < 1
	        BREAK
	    
	    DELETE 
	    FROM   @tmp_property
	    
	    INSERT INTO @tmp_property (PropertyID, StateValueID)
	    SELECT DISTINCT
	           m.PropertyID, m.StateValueID
	    FROM   cl_editable_property m
	           JOIN cl_subclass cs
	                ON  cs.ClassID_Master = m.ClassID
	                    AND cs.ClassID_Slave = @ClassID
	           JOIN cl_property cp
	                ON  cp.PropertyID = m.PropertyID
	           JOIN cl_domain cd
	                ON  cd.DomainID = cp.DomainID
	    WHERE  m.[Required] = 1
	           AND cd.DataTypeID <> 13 -- Не табличные
	    ORDER BY m.PropertyID, m.StateValueID
	    
	    
	    SELECT @id = 0
	    
	    WHILE 1 = 1 -- Цикл по свойствам
	    BEGIN
	        SELECT @ID = t.ID, @PropertyID = t.PropertyID, @StateValueID = t.StateValueID, @DataTypeID = 
	               cd.DataTypeID
	        FROM   @tmp_property t
	               JOIN cl_property cp
	                    ON  cp.PropertyID = t.PropertyID
	               JOIN cl_domain cd
	                    ON  cd.DomainID = cp.DomainID
	        WHERE  t.ID > @ID
	        ORDER BY t.ID DESC
	        
	        IF @@ROWCOUNT < 1
	            BREAK
	        
	        ---
	        --        SELECT  @errmsg = STR(@PropertyID) + '' + isnull(STR(@StateValueID), '')
	        --       PRINT @errmsg
	        ---		
	        
	        SELECT @NameField = ISNULL(cpc.NameField, 'Value'), @Location = cpc.NameTable, @IDName = cl.IDName, 
	               @NameMetaID = cl.NameMetaID
	        FROM   cp_property_cl cpc
	               JOIN cp_location cl
	                    ON  cl.Location = cpc.NameTable
	               JOIN cl_subclass cs
	                    ON  cs.ClassID_Master = cpc.ClassID
	                        AND cs.ClassID_Slave = @ClassID
	        WHERE  cpc.PropertyID = @PropertyID
	        ORDER BY cs.LevelP DESC
	        
	        ---
	        --SELECT @PropertyID, @Location,@IDName,@NameField
	        ---
	        
	        SELECT @sSelect = 'select mo.ClassID, mo.ObjectID, cast(' + LTRIM(@PropertyID) +
	               ' as smallint) as PropertyID' 
	        
	        SELECT @sFrom = 'from mn_object mo' -- 
	               + ' left join mn_object_del mod on mod.ObjectID = mo.ObjectID' --
	               + ' LEFT JOIN ' + LTRIM(@Location) + ' m on mo.ObjectID = m.' + LTRIM(@IDName) --
	               + ' and not m.' + LTRIM(@NameField) + ' is NULL'
	        
	        IF NOT @NameMetaID IS NULL
	            -- Есть колонка PropertyID
	            SELECT @sFrom = @sFrom + ' and m.' + LTRIM(@NameMetaID) + ' = ' + LTRIM(@PropertyID)
	        
	        SELECT @sWhere = 'where mo.ClassID = ' + LTRIM(@ClassID) --
	               + ' AND mod.ObjectID IS NULL' --
	        
	        IF LTRIM(ISNULL(@List_arx_object, '')) <> '' -- Есть список архивных объектов
	        BEGIN
	            SELECT @sFrom = @sFrom --
	                   + ' left join ' + LTRIM(@List_arx_object) + ' a on a.ObjectID = mo.ObjectID' --
	            SELECT @sWhere = @sWhere --
	                   + ' and a.ObjectID is NULL' --
	        END
	        
	        IF NOT @StateValueID IS NULL -- Обязательность в разрезе состояний
	        BEGIN
	            SELECT @LocationState = csc.NameTable, @IDNameState = cl.IDName, @NameFieldState = csc.NameField
	            FROM   cl_state_value csv
	                   JOIN cp_state_cl csc
	                        ON  csc.StateID = csv.StateID
	                   JOIN cp_location cl
	                        ON  cl.Location = csc.NameTable
	            WHERE  csv.StateValueID = @StateValueID					
	            
	            SELECT @sFrom = @sFrom -- 
	                   + ' join ' + LTRIM(@LocationState) + ' st on st.' + LTRIM(@IDNameState) +
	                   ' = mo.ObjectID' --
	                   + ' and st.' + @NameFieldState + ' = ' + LTRIM(STR(@StateValueID))
	        END
	        
	        IF @DataTypeID = 1 -- Объект. Будем проверять на удалённость
	        BEGIN
	            SELECT @sFrom = @sFrom + ' left join mn_object_del mod1 on mod1.ObjectID = m.' + LTRIM(@NameField)
	            SELECT @sWhere = @sWhere + ' AND (m.' + LTRIM(@IDName) +
	                   ' is NULL or not mod1.ObjectID is NULL)'
	            
	            SELECT @sSelect = @sSelect + ', case when mod1.ObjectID is NULL then 0 else 1 end'
	        END
	        ELSE
	        BEGIN
	            SELECT @sWhere = @sWhere + ' AND m.' + LTRIM(@IDName) + ' is NULL' -- 
	            SELECT @sSelect = @sSelect + ', 0'
	        END 
	        
	        -- формируем окончательную строку запроса
	        SELECT @sSql = dbo.f_r_build_sql(@sSelect, @sFrom, @sWhere, '', '')
	        
	        SELECT @sSql = 'if exists (' + @sSql + ')' -- 
	               + ' begin' --
	               + ' /*print ''sss'' */' --
	               + ' insert into #tmp_list (ClassID, ObjectID, PropertyID, isDel) ' --
	               + @sSql -- 
	               + ' end' --
	        
	        --PRINT @sSql
	        EXEC dbo.sp_executesql @sSQL
	    END
	    
	    
	    -- Цикл по состояниям
	    DELETE 
	    FROM   @tmp_state
	    
	    INSERT INTO @tmp_state(StateID)
	    SELECT DISTINCT csv.StateID
	    FROM   cl_subclass cs
	           JOIN cl_state_cl csv
	                ON  csv.ClassID = cs.ClassID_Master
	    WHERE  cs.ClassID_Slave = @ClassID
	    
	    SELECT @ID = 0
	    
	    WHILE 1 = 1 -- Цикл по состояниям
	    BEGIN
	        SELECT @ID = t.ID, @StateID = t.StateID
	        FROM   @tmp_state t
	        WHERE  t.ID > @ID
	        ORDER BY t.ID DESC
	        
	        IF @@ROWCOUNT < 1
	            BREAK
	        
	        SELECT @NameField = ISNULL(cpc.NameField, 'Value'), @Location = cpc.NameTable, @IDName = cl.IDName, 
	               @NameMetaID = cl.NameMetaID
	        FROM   cp_state_cl cpc
	               JOIN cp_location cl
	                    ON  cl.Location = cpc.NameTable
	               JOIN cl_subclass cs
	                    ON  cs.ClassID_Master = cpc.ClassID
	                        AND cs.ClassID_Slave = @ClassID
	        WHERE  cpc.StateID = @StateID
	        ORDER BY cs.LevelP DESC
	        
	        
	        SELECT @sSelect = 'select mo.ClassID, mo.ObjectID, cast(' + LTRIM(@StateID) +
	               ' as smallint) as StateID' 
	        
	        SELECT @sFrom = 'from mn_object mo' -- 
	               + ' left join mn_object_del mod on mod.ObjectID = mo.ObjectID' --
	               + ' LEFT JOIN ' + LTRIM(@Location) + ' m on mo.ObjectID = m.' + LTRIM(@IDName) --
	               + ' and not m.' + LTRIM(@NameField) + ' is NULL'
	        
	        IF NOT @NameMetaID IS NULL
	            -- Есть колонка StateID
	            SELECT @sFrom = @sFrom + ' and m.' + LTRIM(@NameMetaID) + ' = ' + LTRIM(@StateID)
	        
	        SELECT @sWhere = 'where mo.ClassID = ' + LTRIM(@ClassID) --
	               + ' AND mod.ObjectID IS NULL' --
	        
	        IF LTRIM(ISNULL(@List_arx_object, '')) <> '' -- Есть список архивных объектов
	        BEGIN
	            SELECT @sFrom = @sFrom --
	                   + ' left join ' + LTRIM(@List_arx_object) + ' a on a.ObjectID = mo.ObjectID' --
	            SELECT @sWhere = @sWhere --
	                   + ' and a.ObjectID is NULL' --
	        END
	        
	        SELECT @sWhere = @sWhere + ' AND m.' + LTRIM(@IDName) + ' is NULL' -- 
	        SELECT @sSelect = @sSelect + ', 0'
	        
	        -- формируем окончательную строку запроса
	        SELECT @sSql = dbo.f_r_build_sql(@sSelect, @sFrom, @sWhere, '', '')
	        
	        SELECT @sSql = 'if exists (' + @sSql + ')' -- 
	               + ' begin' --
	               + ' /*print ''sss'' */' --
	               + ' insert into #tmp_list (ClassID, ObjectID, PropertyID, isDel) ' --
	               + @sSql -- 
	               + ' end' --
	        
	        ---
	        --PRINT @sSql
	        ---
	        EXEC dbo.sp_executesql @sSQL
	    END
	END
	
	PRINT 'Кол-во по классам'
	SELECT t.ClassID, cls.[Name] AS 'Класс', t.PropertyID, cls1.[Name] AS 'Свойство/Состояние', COUNT(*)
	FROM   #tmp_list t
	       JOIN cl_locale_string cls
	            ON  cls.MetaObjectID = t.ClassID
	       JOIN cl_locale_string cls1
	            ON  cls1.MetaObjectID = t.PropertyID
	GROUP BY t.ClassID, cls.[Name], t.PropertyID, cls1.[Name]
	ORDER BY 4
	
	
	PRINT 'Общее кол-во'
	SELECT COUNT(*) 'Количество записей'
	FROM   #tmp_list
	
	PRINT 'Первые  100 записей'
	SELECT TOP 100
	       *
	FROM   #tmp_list --WHERE ClassID =21537
	ORDER BY ClassID
GO
GRANT EXECUTE ON sp_empty_required_property TO TetraUsers