IF EXISTS (
       SELECT *
       FROM   sysobjects
       WHERE  TYPE         = 'P'
              AND NAME     = 'sp_sel_ref_objects'
   )
BEGIN
    DROP PROCEDURE sp_sel_ref_objects
END

GO

/*Возвращает список объектов, которые ссылаются на заданный объект*/
CREATE PROCEDURE dbo.sp_sel_ref_objects
(
	@ObjectList     VARCHAR(8000) -- список ID
   ,@Top1           BIT = 0
)
WITH  

EXECUTE AS OWNER
        AS
 
DECLARE @tmp_id TABLE 
( 
	ObjectID INT PRIMARY KEY
)

DECLARE @tmp_location TABLE 
( 
	ID INT IDENTITY(1, 1)
	PRIMARY KEY
   ,TableName SYSNAME
   ,FieldName SYSNAME
   ,MetaObjectID SMALLINT
   ,MetaObjectID_Slave SMALLINT NULL
   ,IDname SYSNAME
   ,M_S TINYINT NULL
   ,ClassPropertyID SMALLINT
   ,MetaClassID SMALLINT
   ,REQUIRED TINYINT DEFAULT 0
)

DECLARE @ID                      INT
        ,@TableName              SYSNAME
        ,@FieldName              SYSNAME
        ,@MetaObjectID           SMALLINT
        ,@MetaObjectID_Slave     SMALLINT
        ,@IDname                 SYSNAME
        ,@sSql                   AS NVARCHAR(MAX)
        ,@M_S                    TINYINT
        ,@ClassPropertyID        SMALLINT
        ,@ObjectID               INT

CREATE TABLE #tmp_res
(
	ID                   INT IDENTITY(1, 1) PRIMARY KEY
   ,ObjectID             INT
   ,PropertyID           SMALLINT
   ,PropertyID_Slave     SMALLINT
   ,RefObjectID          INT
   ,ClassID              SMALLINT
   ,M_S                  TINYINT
)

SET NOCOUNT ON

INSERT INTO @tmp_id(ObjectID)
SELECT DISTINCT f.ID
FROM   dbo.f_list_to_table(@ObjectList) f

SELECT @ObjectID = 0
WHILE 1 = 1
BEGIN
    SELECT @ObjectID = t.ObjectID
    FROM   @tmp_id t
    WHERE  t.ObjectID > @ObjectID
    ORDER BY t.ObjectID DESC
    
    IF @@ROWCOUNT < 1
        BREAK
    
    
    DELETE 
    FROM   @tmp_location
    
    INSERT INTO @tmp_location (TableName, FieldName, MetaObjectID, IDname, MetaObjectID_Slave, M_S, ClassPropertyID, MetaClassID)
    
    -- Обычные свойства
    SELECT DISTINCT
           cpcv.NameTable, ISNULL(cpcv.NameField, 'Value') AS NameField, cpcv.PropertyID, cl.IDName, NULL, 
           NULL, cpcv.ClassID, 2
    FROM   mn_object mo
           JOIN cl_subclass cs
                ON  cs.ClassID_Slave = mo.ClassID
           JOIN cl_property cp
                ON  cp.MetaObjectID = cs.ClassID_Master
           JOIN cl_domain cd
                ON  cd.DomainID = cp.DomainID
                    AND cd.DataTypeID = 1
           JOIN cp_property_cl cpcv
                ON  cpcv.PropertyID = cp.PropertyID
           JOIN cp_location cl
                ON  cl.Location = cpcv.NameTable
    WHERE  mo.ObjectID = @ObjectID
           AND NOT ISNULL(cpcv.NameField, 'Value') LIKE 'dbo.%'
           AND NOT EXISTS (
                   SELECT *
                   FROM   cl_property_cl cll
                          JOIN cl_subclass cs2
                               ON  cll.ClassID = cs2.ClassID_Master
                                   AND cs2.ClassID_Slave = cpcv.ClassID
                                   AND cll.PropertyID = cpcv.PropertyID
                                   AND cll.autoDel = 1
               )
    
    UNION ALL
    --- Настройки
    SELECT DISTINCT
           'mn_setup' AS NameTable, 'Value' AS NameField, 0, 'SetupID', NULL, 1, 1, 12
    
    -- Линки Мастер
    UNION ALL
    SELECT DISTINCT
           cl2.NameTable, pl.IDName AS NameField, cl.LinkID, pl.NameField, NULL, 0, cl.ClassID_Slave, 6
    FROM   mn_object mo
           JOIN cl_subclass cs
                ON  cs.ClassID_Slave = mo.ClassID
           JOIN cl_link cl
                ON  cs.ClassID_Master = cl.ClassID_Master
           JOIN cp_link cl2
                ON  cl2.LinkID = cl.LinkID
           JOIN cp_location pl
                ON  pl.Location = cl2.NameTable
    WHERE  mo.ObjectID = @ObjectID
           AND (@Top1 = 0 OR cl.DeleteRule IN (0, 2)) 
    -- Линки Подчиненные
    UNION ALL
    SELECT DISTINCT
           cl2.NameTable, pl.NameField, cl.LinkID, pl.IDName, NULL, 1, cl.ClassID_Master, 6
    FROM   mn_object mo
           JOIN cl_subclass cs
                ON  cs.ClassID_Slave = mo.ClassID
           JOIN cl_link cl
                ON  cs.ClassID_Master = cl.ClassID_Slave
           JOIN cp_link cl2
                ON  cl2.LinkID = cl.LinkID
           JOIN cp_location pl
                ON  pl.Location = cl2.NameTable
    WHERE  mo.ObjectID = @ObjectID
           AND (@Top1 = 0 OR cl.DeleteRule IN (0, 1)) 
    -- Табличные свойства
    UNION ALL
    SELECT DISTINCT
           cpcv.NameTable, ISNULL(cpd.NameField, 'Value') AS NameField, cpd.PropertyID_Master, cl.IDName, 
           cpd.PropertyID_Slave, NULL, cpcv.ClassID, 2
    FROM   mn_object mo
           JOIN cl_subclass cs
                ON  cs.ClassID_Slave = mo.ClassID
           JOIN cl_property cp
                ON  cp.MetaObjectID = cs.ClassID_Master
           JOIN cl_domain cd
                ON  cd.DomainID = cp.DomainID
                    AND cd.DataTypeID = 1
           JOIN cp_property_det cpd
                ON  cpd.PropertyID_Slave = cp.PropertyID
           JOIN cp_property_cl cpcv
                ON  cpcv.PropertyID = cpd.PropertyID_Master
           JOIN cp_location cl
                ON  cl.Location = cpcv.NameTable
                    AND NOT cl.Location LIKE 'dbo.%' -- не функция
                    AND NOT cl.Location LIKE '%_v' -- не view
    WHERE  mo.ObjectID = @ObjectID
           AND NOT ISNULL(cpd.NameField, 'Value') LIKE 'dbo.%' -- поле не функция
                                                               -- Агрегация Мастер
    UNION ALL
    SELECT DISTINCT
           'mn_object_aggregation_direct_v' AS NameTable, 'ObjectID_Master' AS NameField, cl.AggregationID, 
           'ObjectID_Slave', NULL, 0, cl.ClassID_slave, 10
    FROM   mn_object mo
           JOIN cl_subclass cs
                ON  cs.ClassID_Slave = mo.ClassID
           JOIN cl_aggregation cl
                ON  cs.ClassID_Master = cl.ClassID_Master
    WHERE  mo.ObjectID = @ObjectID
    -- Агрегация Подчиненные
    UNION ALL
    SELECT DISTINCT
           'mn_object_aggregation_direct_v' AS NameTable, 'ObjectID_Slave' AS NameField, cl.AggregationID, 
           'ObjectID_Master', NULL, 1, cl.ClassID_Master, 10
    FROM   mn_object mo
           JOIN cl_subclass cs
                ON  cs.ClassID_Slave = mo.ClassID
           JOIN cl_aggregation cl
                ON  cs.ClassID_Master = cl.ClassID_Slave
    WHERE  mo.ObjectID = @ObjectID
    
    -- Проставляем обязательность свойств
    UPDATE t
    SET    REQUIRED = cep.[Required]
    FROM   @tmp_location t
           JOIN cl_subclass cs
                ON  cs.ClassID_slave = t.ClassPropertyID
           JOIN cl_editable_property cep
                ON  cep.ClassID = cs.ClassID_Master
                    AND cep.PropertyID = t.MetaObjectID
                    AND t.MetaClassID = 2
                    AND cep.[Required] = 1
    
    UPDATE t
    SET    [Required] = cpd.[Required]
    FROM   @tmp_location t
           JOIN cl_property_det cpd
                ON  cpd.PropertyID_Master = t.MetaObjectID
                    AND cpd.PropertyID_Slave = t.MetaObjectID_Slave
    WHERE  t.MetaClassID = 2
           AND cpd.[Required] = 1
    
    
    ---- Удаляем вычисляемые необязательные свойства
    DELETE 
    FROM   @tmp_location
    WHERE  [Required] = 0
           AND TableName LIKE '%_v'
    
    ---
    --SELECT  * FROM    @tmp_location t --WHERE t.MetaObjectID =319
    --RETURN
    ---
    
    SELECT @ID = 0, @sSql = ''
    WHILE 1 = 1
    BEGIN
        SELECT @ID = t.ID, @TableName = t.TableName, @FieldName = t.FieldName, @MetaObjectID = t.MetaObjectID, 
               @IDname = t.IDname, @MetaObjectID_Slave = t.MetaObjectID_Slave, @M_S = t.M_S, @ClassPropertyID = 
               t.ClassPropertyID
        FROM   @tmp_location t
        WHERE  t.ID > @ID
        ORDER BY t.ID DESC
        
        IF @@ROWCOUNT < 1
            BREAK
        
        IF @IDname = 'SetupID'
        BEGIN
            SELECT @sSql = @sSql + CASE 
                                   	WHEN @sSql = '' 
                                   	THEN ''
                                   	ELSE 'UNION ALL' + dbo.f_CrLf()
                                   END -- 
                   + 'SELECT DISTINCT CAST(' + LTRIM(STR(@MetaObjectID)) + ' AS SMALLINT) AS PropertyID' --
                   + ', CAST(' + ISNULL(LTRIM(STR(@MetaObjectID_Slave)), 'NULL') +
                   ' AS SMALLINT) AS PropertyID_Slave' --
                   + ', m.' + @IDname + ' AS RefObjectID' --
                   + ', -20000 as ClassID' --
                   + ', ' + ISNULL(LTRIM(STR(@M_S)), 'NULL') + ' AS M_S' --
                   + ' FROM ' + @TableName + ' m' --
                   + ' JOIN cl_setupT ct ON ct.SetupID = m.SetupID AND ct.DomainID =-12001' --
                   + ' WHERE m.' + @FieldName + ' = ' + LTRIM(STR(@ObjectID)) + dbo.f_CrLf()
        END
        ELSE
        BEGIN
            SELECT @sSql = @sSql + CASE 
                                   	WHEN @sSql = '' 
                                   	THEN ''
                                   	ELSE 'UNION ALL' + dbo.f_CrLf()
                                   END -- 
                   + 'SELECT DISTINCT CAST(' + LTRIM(STR(@MetaObjectID)) + ' AS SMALLINT) AS PropertyID' --
                   + ', CAST(' + ISNULL(LTRIM(STR(@MetaObjectID_Slave)), 'NULL') +
                   ' AS SMALLINT) AS PropertyID_Slave' --
                   + ', m.' + @IDname + ' AS RefObjectID' --
                   + ', mo.ClassID' --
                   + ', ' + ISNULL(LTRIM(STR(@M_S)), 'NULL') + ' AS M_S' --
                   + ' FROM ' + @TableName + ' m' --
                   + ' JOIN mn_object_actual_v mo on mo.ObjectID = m.' + @IDname --
                   + ' JOIN cl_subclass sc on sc.ClassID_Master = ' + LTRIM(STR(@ClassPropertyID))
                   + ' and sc.ClassID_Slave = mo.ClassID' -- 
                   + ' WHERE m.' + @FieldName + ' = ' + LTRIM(STR(@ObjectID)) + dbo.f_CrLf()
        END
    END
    
    SELECT @sSql = 'SELECT ' --
           + CASE 
             	WHEN @Top1 = 1 
             	THEN 'TOP 1 '
             	ELSE 'DISTINCT '
             END --
           + LTRIM(STR(@ObjectID)) + ' as ObjectID' --
           + ', m.PropertyID, m.PropertyID_Slave, m.RefObjectID, m.ClassID, m.M_S FROM (' -- 
           + @sSql --
           +') m'
    
    ---
    --PRINT @sSql
    ---
    
    SELECT @sSql = 
           'INSERT INTO #tmp_res(ObjectID, PropertyID, PropertyID_Slave, RefObjectID, ClassID, M_S)' -- 
           + dbo.f_CrLf() --
           + @sSql --
    
    EXEC dbo.sp_executesql @sSQL
END

SELECT t.ObjectID, t.PropertyID, t.PropertyID_Slave, t.RefObjectID, t.ClassID, t.M_S
FROM   #tmp_res t
               
             
GO
    
GRANT EXEC ON sp_sel_ref_objects TO TetraUsers
