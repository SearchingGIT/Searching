IF EXISTS (
       SELECT *
       FROM   sysobjects
       WHERE  TYPE         = 'P'
              AND NAME     = 'sp_create_dn_access'
   )
BEGIN
    DROP PROCEDURE sp_create_dn_access
END

GO

CREATE PROCEDURE dbo.sp_create_dn_access
(
	@UserID INT = NULL
)
WITH                                               

EXECUTE AS OWNER
        AS

SET NOCOUNT ON

--DECLARE @tmp_group TABLE 
--( 
--	UserID INT
--   ,LOGIN VARCHAR(64)
--   ,GroupID INT
--   ,PRIMARY KEY(UserID, GroupID)
--)

DECLARE @sSql AS NVARCHAR(MAX)
        ,@sSql1 AS NVARCHAR(MAX)
        ,@sSelect AS VARCHAR(MAX)
        ,@sFrom AS VARCHAR(MAX)
        ,@sWhere AS VARCHAR(MAX) = ''
        ,@DBObjectName SYSNAME
        ,@GroupID INT
        ,@SubUnitID INT
        ,@pr_399 BIT
        ,@BaseTable VARCHAR(256)

DECLARE @tmp_user TABLE 
( 
	UserID INT
   ,SubUnitID INT NULL
   ,pr_399 BIT NULL
   ,PRIMARY KEY(UserID)
)

DECLARE @tmp_access_class TABLE 
( 
	UserID INT
   ,ClassID SMALLINT
   ,PRIMARY KEY(UserID, ClassID)
)

INSERT INTO @tmp_user(UserID, SubUnitID, pr_399)
SELECT su.UserID, su.SubUnitID, CAST(pr_399.[Value] AS BIT)
FROM   sc_user su
       JOIN mn_object_actual_v mo
            ON  mo.ObjectID = su.UserID
       LEFT JOIN mn_object_property_vl pr_399 WITH (NOLOCK)
            ON  pr_399.ObjectID = mo.ObjectID
                AND pr_399.PropertyID = -399
WHERE  su.UserID = ISNULL(@UserID, su.UserID)                

INSERT INTO @tmp_access_class(UserID, ClassID)
SELECT n.UserID, n.ClassID
FROM   (
           SELECT DISTINCT sug.UserID, src.ClassID
           FROM   sc_user_group sug
                  JOIN sc_matrix sm
                       ON  sm.UserGroupID = sug.UserGroupID
                  JOIN sc_right_class src
                       ON  src.RightID = sm.RightID
                  LEFT JOIN mn_object_del mod1
                       ON  mod1.ObjectID = sug.UserGroupID
                  LEFT JOIN mn_object_del mod2
                       ON  mod2.ObjectID = src.RightID
           WHERE  mod1.ObjectID IS NULL
                  AND mod2.ObjectID IS NULL
       ) m
       RIGHT JOIN (
                SELECT DISTINCT su.UserID, cc.ClassID
                FROM   sc_user su
                       JOIN cl_class cc
                            ON  1 = 1
                       LEFT JOIN cl_subclass cs
                            ON  cs.ClassID_Master = cc.ClassID
                                AND cs.ClassID_Master <> cs.ClassID_Slave
                WHERE  cs.ClassID_Master IS NULL
            ) n
            ON  n.UserID = m.UserID
                AND n.ClassID = m.ClassID
WHERE  m.UserID IS NULL          

IF NOT @UserID IS NULL
    DELETE 
    FROM   @tmp_access_class
    WHERE  UserID <> @UserID 

SELECT @UserID = 0

-- Цикл по пользователям
WHILE 1 = 1
BEGIN
    SELECT @UserID = t.UserID, @SubUnitID = t.SubUnitID, @pr_399 = ISNULL(t.pr_399, 0)
    FROM   @tmp_user t
    WHERE  t.UserID > @UserID
    ORDER BY t.UserID DESC
    
    IF @@ROWCOUNT < 1
        BREAK
    
    
    SELECT @sWhere = '', @sFrom = '', @sSelect = ''
    
    ---
    --SELECT @UserID AS '@UserID',@SubUnitID AS '@SubUnitID',@pr_399 AS '@pr_399'
    ---
    
    SELECT @DBObjectName = 'dn_object_actual_' + LTRIM(STR(@UserID)) + '_v'
    SELECT @sSql = ''
    
    -- Цикл по группам доступа (или проход без ограничения по группам)
    SELECT @GroupID = 0
    WHILE 1 = 1
    BEGIN
        SELECT @sSql1 = ''
        
        -- Не используем группы
        IF @pr_399 = 0
        BEGIN
            SELECT @BaseTable = 'dbo.mn_object_actual_v'
        END
        ELSE
        BEGIN
            -- Используем группы
            SELECT @GroupID = m.GroupID
            FROM   (
                       SELECT CAST(pr_400.[Value] AS INT) AS GroupID
                       FROM   mn_object_property_det pr_400
                              LEFT JOIN mn_object_del mod
                                   ON  mod.ObjectID = CAST(pr_400.[Value] AS INT)
                       WHERE  pr_400.ObjectID = @UserID
                              AND pr_400.PropertyID_Master = -400
                              AND pr_400.PropertyID_Slave = -401
                              AND mod.ObjectID IS NULL
                   ) m
            WHERE  m.GroupID > @GroupID
            ORDER BY m.GroupID DESC
            
            IF @@ROWCOUNT < 1
                BREAK
            
            SELECT @BaseTable = 'dbo.' + dbo.f_name_view_group(@GroupID)
        END
        
        -- SELECT
        SELECT @sSelect = 'SELECT m.ObjectID, m.ClassID'
        
        -- FROM
        SELECT @sFrom = 'FROM ' + @BaseTable + ' m'
        
        -- WHERE
        
        IF EXISTS (
               SELECT *
               FROM   @tmp_access_class t
               WHERE  t.UserID = @UserID
           )
        BEGIN
            SELECT @sWhere = @sWhere + IIF(@sWhere = '', '', ', ') + LTRIM(STR(t.ClassID))
            FROM   @tmp_access_class t
            WHERE  t.UserID = @UserID
            
            SELECT @sWhere = 'WHERE m.ClassID NOT IN (' + @sWhere + ')'
        END
        ELSE
            SELECT @sWhere = 'WHERE 1=1'
        
        -- Ограничение по подразделению
        IF NOT @SubUnitID IS NULL
        BEGIN
            -- Добавляем DISTINCT
            SELECT @sSelect = 'SELECT DISTINCT m.ObjectID, m.ClassID'
            
            SELECT @sFrom = @sFrom + dbo.f_CrLf() --
                   + 
                   'LEFT JOIN (
						mn_object_subunit os(NOLOCK)
						LEFT JOIN mn_object_aggregation moa(NOLOCK) ON moa.ObjectID_Slave = os.SubUnitID
					)
					ON  os.ObjectID = m.ObjectID' + dbo.f_CrLf()
            
            SELECT @sWhere = @sWhere + dbo.f_CrLf() --
                   + 'AND (os.SubUnitID IS NULL' + dbo.f_CrLf() --
                   + 'OR ' + LTRIM(STR(@SubUnitID)) + ' IN (moa.ObjectID_Master, os.SubUnitID)' + ')'
        END 
        
        ---
        --PRINT @sSelect
        --PRINT @sFrom
        --PRINT @sWhere
        ---
        
        -- Сборка запроса
        SELECT @sSql1 = dbo.f_r_build_sql(@sSelect, @sFrom, @sWhere, '', '')
        
        SELECT @sSql = @sSql + IIF(@sSql <> '', dbo.f_CrLf() + 'UNION' + dbo.f_CrLf(), '') + @sSql1
        
        IF @pr_399 = 0
            BREAK
    END -- конец цикла по группам
    
    
    /*  Удаляем функцию */
    SELECT @sSql1 = 
           'IF EXISTS ( SELECT  *
            FROM    sysobjects
            WHERE   name = ''' + @DBObjectName + ''') 
		DROP VIEW ' + @DBObjectName 
    
    --PRINT @sSql1
    EXEC dbo.sp_executesql @sSQL1
    
    /* Создаем функцию */
    SELECT @sSql = 'CREATE VIEW ' + @DBObjectName + dbo.f_CrLf() --
           + 'AS' + dbo.f_CrLf() --
           + @sSql + dbo.f_CrLf() --
    
    ---
    --PRINT '================================================================='
    --PRINT @sSql
    ---
    
    EXEC dbo.sp_executesql @sSQL
    
    /* Даём права */
    SELECT @sSql = 'GRANT SELECT ON ' + @DBObjectName + ' TO TetraUsers' + dbo.f_CrLf()
    --PRINT @sSql1
    EXEC dbo.sp_executesql @sSQL
    
    UPDATE sc_user
    SET    AccessView     = @DBObjectName
    WHERE  UserID         = @UserID
END -- Конец цикла по пользователям
GO

GRANT EXEC ON sp_create_dn_access TO TetraUsers