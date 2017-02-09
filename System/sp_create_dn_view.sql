IF EXISTS (
       SELECT *
       FROM   sysobjects
       WHERE  TYPE         = 'P'
              AND NAME     = 'sp_create_dn_view'
   )
BEGIN
    DROP PROCEDURE sp_create_dn_view
END

GO

CREATE PROCEDURE dbo.sp_create_dn_view
AS
	DECLARE @tmp_property_fn_main TABLE 
	( 
		ClassID SMALLINT
	   ,PropertyID SMALLINT
	)
	
	DECLARE @Location        AS VARCHAR(64)
	        ,@sSql           AS NVARCHAR(MAX)
	        ,@sSql1          AS NVARCHAR(MAX)
	        ,@sSelect        AS VARCHAR(MAX)
	        ,@sFrom          AS VARCHAR(MAX)
	        ,@sWhere         AS VARCHAR(MAX)
	        ,@NameMetaID     VARCHAR(64)
	        ,@IDName         VARCHAR(64)
	        ,@NameField      VARCHAR(64)
	        ,@ClassID        SMALLINT
	        ,@PropertyID     SMALLINT
	        ,@DomainID       SMALLINT
	        ,@J              INT
	        ,@ViewName       AS VARCHAR(64)
	
	
	SET NOCOUNT ON
	--SET FMTONLY OFF
	
	SELECT @J = 0
	
	INSERT INTO @tmp_property_fn_main (ClassID, PropertyID)
	SELECT DISTINCT
	       cs.ClassID_Slave, cf.MetaObjectID
	FROM   cl_fullname cf
	       JOIN cl_subclass cs
	            ON  cs.ClassID_Master = cf.ClassID
	
	WHILE 1 = 1
	BEGIN
	    SELECT @J = @J + 1
	    
	    IF @j = 1
	        SELECT @ViewName = 'dn_object_property_fn_ob_v'
	    
	    IF @j = 2
	        SELECT @ViewName = 'dn_object_property_fn_tp_v'
	    
	    IF @j = 3
	        SELECT @ViewName = 'dn_object_property_fn_vl_v'
	    
	    IF @j = 2
	        BREAK
	    
	    
	    --SET @i = 0
	    
	    SELECT @sSql1 = '', @sSql = ''
	    
	    /*
	    SELECT  @sSql1 = 'declare @tmp_object_property table (ObjectID int, PropertyID smallint, Value sql_variant)' 
	    SELECT  @sSql1 = @sSql1 + 'declare @tmp_property_fn table (ClassID smallint, PropertyID smallint)' 
	    
	    SELECT  @sSql1 = @sSql1 + '
	    insert into @tmp_property_fn (ClassID, PropertyID)
	    SELECT DISTINCT	cs.ClassID_Slave, cf.MetaObjectID 
	    FROM cl_fullname cf
	    JOIN cl_subclass cs ON cs.ClassID_Master = cf.ClassID
	    ' 
	    */
	    
	    SELECT @Location = ''
	    -- Цикл по универсальным таблицам
	    WHILE 1 = 1
	    BEGIN
	        SELECT @Location = cl.Location, @NameMetaID = cl.NameMetaID, @IDName = cl.IDName, @NameField = 
	               cl.NameField
	        FROM   (
	                   SELECT DISTINCT
	                          ClassID
	                   FROM   mn_object
	               ) mo
	               JOIN cl_property_cl_v cpcv
	                    ON  cpcv.ClassID = mo.ClassID
	               JOIN cp_location cl
	                    ON  cl.Location = cpcv.NameTable
	               JOIN cl_property cp
	                    ON  cp.PropertyID = cpcv.PropertyID
	               JOIN cl_domain cd
	                    ON  cd.DomainID = cp.DomainID
	        WHERE  NOT cl.NameMetaID IS NULL
	               AND cl.Location > @Location
	               AND (
	                       @ViewName = 'dn_object_property_fn_ob_v'
	                       AND cd.DataTypeID IN (1)
	                       OR @ViewName = 'dn_object_property_fn_tp_v'
	                       AND cd.DataTypeID IN (6)
	                       OR @ViewName = 'dn_object_property_fn_vl_v'
	                       AND cd.DataTypeID NOT IN (1, 6)
	                   )
	        ORDER BY cl.Location DESC
	        
	        IF @@ROWCOUNT < 1
	            BREAK
	        
	        
	        SELECT @sSelect = 'select m.' + @IDName + ' as ObjectID, m.' + @NameMetaID +
	               ' as PropertyID, m.' + @NameField
	               + ' as Value'
	        
	        SELECT @sFrom = 'from ' + @Location + ' m' + dbo.f_CrLf() +
	               ' join mn_object mo on mo.ObjectID = m.'
	               + @IDName + dbo.f_CrLf()
	               +
	               'join (SELECT DISTINCT	cs.ClassID_Slave as ClassID, cf.MetaObjectID as PropertyID FROM cl_fullname cf'
	               + dbo.f_CrLf() +
	               'JOIN cl_subclass cs ON cs.ClassID_Master = cf.ClassID
            					) t on t.ClassID = mo.ClassID and t.PropertyID = m.' + @NameMetaID
	        
	        SELECT @sWhere = ''
	        
	        /* ============= Формирование итоговой строки SQL =============== */
	        SELECT @sSql = @sSql + CASE 
	                               	WHEN @sSql = '' 
	                               	THEN ''
	                               	ELSE dbo.f_CrLf() + 'UNION ALL' + dbo.f_CrLf()
	                               END + dbo.f_r_build_sql(@sSelect, @sFrom, @sWhere, '', '')
	    END
	    
	    /*
	    SELECT  @sSql1 = @sSql1 + 'insert into @tmp_object_property(ObjectID, PropertyID, Value) ' + dbo.f_CrLf() + @sSql
	    */
	    
	    ---
	    --    SELECT  @ViewName, @sSql
	    ---
	    
	    SELECT @sSql1 = @sSql1 + @sSql
	    
	    -- Цикл по специальным таблицам
	    SELECT @ClassID = -32000, @sSql = ''
	    WHILE 1 = 1
	    BEGIN
	        SELECT @ClassID = cpc.ClassID
	        FROM   cp_property_cl cpc
	               JOIN cp_location cl
	                    ON  cl.Location = cpc.NameTable
	        WHERE  cl.NameMetaID IS NULL
	               AND cpc.ClassID > @ClassID
	               AND NOT cpc.NameField IS NULL
	        ORDER BY cpc.ClassID DESC
	        
	        IF @@ROWCOUNT < 1
	            BREAK
	        
	        -- Цикл по свойствам
	        SELECT @PropertyID = -9999
	        WHILE 1 = 1
	        BEGIN
	            --SELECT  @I = @I + 1
	            
	            /*        
	            IF @I =256
	            BEGIN
	            SELECT @I =0
	            SELECT @sSql1 = @sSql1 + dbo.f_CrLf() + ' UNION ALL ' + dbo.f_CrLf() + @sSql
	            SELECT @sSql=''
	            --BREAK
	            END
	            */			
	            
	            SELECT @PropertyID = cpc.PropertyID, @Location = cpc.NameTable, @NameField = cpc.NameField, 
	                   @IDName = cl.IDName, @DomainID = cp.DomainID
	            FROM   cp_property_cl cpc
	                   JOIN cp_location cl
	                        ON  cl.Location = cpc.NameTable
	                   JOIN cl_property cp
	                        ON  cp.PropertyID = cpc.PropertyID
	                   JOIN cl_domain cd
	                        ON  cd.DomainID = cp.DomainID
	                   JOIN cl_subclass cs
	                        ON  cs.ClassID_Master = @ClassID
	                   JOIN @tmp_property_fn_main t
	                        ON  t.PropertyID = cpc.PropertyID
	                            AND t.ClassID = cs.ClassID_Slave
	            WHERE  cl.NameMetaID IS NULL
	                   AND cpc.PropertyID > @PropertyID
	                   AND NOT cpc.NameField IS NULL
	                   AND NOT cd.DataTypeID = 14
	                   AND cpc.ClassID = cs.ClassID_Master
	                   AND (
	                           @ViewName = 'dn_object_property_fn_ob_v'
	                           AND cd.DataTypeID IN (1)
	                           OR @ViewName = 'dn_object_property_fn_tp_v'
	                           AND cd.DataTypeID IN (6)
	                           OR @ViewName = 'dn_object_property_fn_vl_v'
	                           AND cd.DataTypeID NOT IN (1, 6)
	                       )
	            ORDER BY cpc.PropertyID DESC
	            
	            IF @@ROWCOUNT < 1
	                BREAK
	            
	            -- Реагируем на varchar(max) (-12045)
	            IF @DomainID <> -12045
	                SELECT @sSelect = 'select m.' + @IDName + ' as ObjectID, ' + LTRIM(STR(@PropertyID))
	                       + ' as PropertyID, m.' + @NameField + ' as Value'
	            ELSE
	                SELECT @sSelect = 'select m.' + @IDName + ' as ObjectID, ' + LTRIM(STR(@PropertyID))
	                       + ' as PropertyID, cast(cast(m.' + @NameField +
	                       ' as varchar(8000)) as sql_variant) as Value'
	            
	            SELECT @sFrom = 'from ' + @Location + ' m'
	            SELECT @sWhere = 'where not ' + @NameField + ' is NULL'
	            
	            /* ============= Формирование итоговой строки SQL =============== */
	            SELECT @sSql = @sSql + CASE 
	                                   	WHEN LTRIM(@sSql) = '' 
	                                   	THEN ''
	                                   	ELSE dbo.f_CrLf() + 'UNION ALL' + dbo.f_CrLf()
	                                   END + dbo.f_r_build_sql(@sSelect, @sFrom, @sWhere, '', '')
	        END
	    END
	    
	    -- Присоединяем последнюю порцию
	    IF NOT @sSql = ''
	        SELECT @sSql1 = @sSql1 + CASE 
	                                 	WHEN LTRIM(@sSql1) = '' 
	                                 	THEN ''
	                                 	ELSE dbo.f_CrLf() + 'UNION ALL' + dbo.f_CrLf()
	                                 END + @sSql
	    
	    
	    IF @sSql1 = ''
	    BEGIN
	        -- Рисуем заглушку
	        SELECT @sSql1 = 
	               'select cast(0 as int) as ObjectID, cast(0 as smallint) as PropertyID, cast(0 as int) as Value'
	               + ' where 1=2'
	    END
	    
	    -- Присоеденяем класс объекта, на который есть ссылка
	    SELECT @sSql1 = 'select m.ObjectID, m.PropertyID, m.Value, mo.ClassID from (' + @sSql1 + ') m'
	           + '  JOIN mn_object mo ON mo.ObjectID = m.[Value]' 
	    
	    -- Удаляем view
	    SELECT @sSql = 
	           'IF EXISTS ( SELECT  *
            FROM    sysobjects
            WHERE   name = ''' + @ViewName + ''') 
		DROP VIEW ' + @ViewName
	    
	    EXEC dbo.sp_executesql @sSQL
	    
	    -- Создаем view
	    SELECT @sSql1 = 'CREATE VIEW ' + @ViewName + dbo.f_CrLf() + ' AS ' + dbo.f_CrLf() +
	           @sSql1 
	    
	    ---
	    --PRINT @sSql1
	    ---
	    
	    EXEC dbo.sp_executesql @sSQL1
	    
	    -- Даём права
	    SELECT @sSql = 'GRANT SELECT ON ' + @ViewName + ' TO TetraUsers' + dbo.f_CrLf()
	    --PRINT @sSql
	    EXEC dbo.sp_executesql @sSQL
	END
GO
GRANT EXEC ON sp_create_dn_view TO TetraUsers
