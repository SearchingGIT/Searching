IF EXISTS (
       SELECT *
       FROM   sysobjects
       WHERE  NAME = 'sp_set_subclass_for_calc_fullname'
   )
    DROP PROCEDURE dbo.sp_set_subclass_for_calc_fullname    
GO 


/* Заполняет таблицу cl_subclass_for_calc_fullname */
CREATE PROCEDURE sp_set_subclass_for_calc_fullname
AS
	DECLARE @errmsg      VARCHAR(8000)
	        ,@Source     VARCHAR(64)
	
	SET NOCOUNT ON
	SET @Source = OBJECT_NAME(@@PROCID)
	
	DECLARE @Res TABLE 
	( 
		ClassID SMALLINT -- Класс, откуда брать fullname
	   ,ClassID_Slave SMALLINT -- Класс, для котрого необходимо рассчитать fullname
	   ,LevelP INT -- Служебное поле
	)
	
	DECLARE @tmp_class1 TABLE 
	( 
		ClassID SMALLINT
	   ,ClassID_Slave SMALLINT
	   ,ClassID_New SMALLINT
	   ,LevelP SMALLINT
	)
	
	-- Формируем список
	INSERT INTO @Res (ClassID, ClassID_Slave, LevelP)
	SELECT DISTINCT
	       cf.ClassID, cf.ClassID, 1
	FROM   cl_fullname cf
	
	---
	--PRINT 'S1'
	--SELECT  * FROM    @res r WHERE   r.ClassID_Slave IN  (21212,21201,21150)
	---
	
	-- Разбиваем классы, котрые переопределены
	INSERT INTO @tmp_class1 (ClassID, ClassID_Slave, ClassID_New, LevelP)
	SELECT DISTINCT
	       t.ClassID, tt.ClassID, tt.ClassID, cs.LevelP
	FROM   @Res t
	       JOIN cl_subclass cs
	            ON  cs.ClassID_Master = t.ClassID
	                AND cs.ClassID_Master <> cs.ClassID_Slave
	       JOIN @Res tt
	            ON  tt.ClassID = cs.ClassID_Slave 
	
	---
	--PRINT 't1'
	--SELECT  * FROM    @tmp_class1
	---
	
	-- Детализируем классы с учетом переопределения
	--INSERT  INTO @Res (ClassID, ClassID_Slave, LevelP)
	--        SELECT  DISTINCT
	--                t.ClassID, cs.ClassID_Slave, 1
	--        FROM    (SELECT t.ClassID, MAX(LevelP) AS LevelP
	--                 FROM   @tmp_class1 t
	--                 GROUP BY t.ClassID) t
	--                JOIN cl_subclass cs ON cs.ClassID_Master = t.ClassID
	--                                       AND cs.LevelP < t.LevelP
	--                LEFT	JOIN @Res r ON r.ClassID_Slave = cs.ClassID_Slave
	--                LEFT JOIN cl_subclass cs2 ON cs2.ClassID_Master <> cs2.ClassID_Slave
	--                                             AND cs2.ClassID_Master = cs.ClassID_Slave
	--        WHERE   r.ClassID IS NULL
	--                AND cs2.ClassID_Master IS NULL				
	
	
	-- Раскрываем класс первого уровня, которые НЕ переопределены
	INSERT INTO @Res (ClassID, ClassID_Slave, LevelP)
	SELECT DISTINCT
	       t.ClassID, cs.ClassID_Slave, 1
	FROM   @tmp_class1 t
	       JOIN cl_subclass cs
	            ON  cs.ClassID_Master = t.ClassID
	                AND cs.LevelP = 1
	       LEFT JOIN (cl_subclass cs2 JOIN @tmp_class1 t2 ON t2.ClassID_Slave = cs2.ClassID_Slave)
	            ON  cs2.ClassID_Master = cs.ClassID_Slave
	WHERE  cs2.ClassID_master IS NULL 
	
	
	-- Дописываем конечные классы, которые находятся в одной ветке с переопределенным
	INSERT INTO @Res (ClassID, ClassID_Slave, LevelP)
	SELECT DISTINCT m.ClassID, cs.ClassID_Slave, 1
	FROM   (
	           SELECT DISTINCT
	                  t.ClassID, cs.ClassID_Slave, cs3.ClassID_Slave AS ClassID_Slave_p
	           FROM   @tmp_class1 t
	                  JOIN cl_subclass cs
	                       ON  cs.ClassID_Master = t.ClassID
	                           AND cs.LevelP = 1
	                  JOIN (cl_subclass cs2 JOIN @tmp_class1 t2 ON t2.ClassID_Slave = cs2.ClassID_Slave)
	                       ON  cs2.ClassID_Master = cs.ClassID_Slave
	                  JOIN cl_subclass cs3
	                       ON  cs3.ClassID_Master = cs.ClassID_Slave
	                           AND cs3.ClassID_Master <> cs3.ClassID_Slave
	           WHERE  EXISTS (
	                      SELECT *
	                      FROM   @tmp_class1 tt
	                      WHERE  tt.ClassID_Slave = cs3.ClassID_Slave
	                  )
	       ) m
	       JOIN cl_subclass cs
	            ON  cs.ClassID_Master = m.ClassID_Slave
	                AND cs.LevelP > 0 -- Все потомки
	                    
	       LEFT JOIN cl_subclass cs2
	            ON  cs2.ClassID_Master = cs.ClassID_Slave
	                AND cs2.ClassID_Master <> cs2.ClassID_Slave
	WHERE  cs2.ClassID_Master IS NULL
	       AND NOT EXISTS (
	               SELECT *
	               FROM   @tmp_class1 tt
	                      JOIN cl_subclass cs3
	                           ON  cs3.ClassID_Master = tt.ClassID_Slave
	                               AND cs3.ClassID_Slave = cs.ClassID_Slave
	           ) 
	
	
	-- Удаляем ссылку самого на себя для класса верхнего уровня (который только что расскрыли)
	DELETE r
	FROM   @Res r
	       JOIN @tmp_class1 tt
	            ON  tt.ClassID = r.ClassID
	                AND r.ClassID = r.ClassID_Slave
	---
	--PRINT 'S2'
	--SELECT  * FROM    @res r WHERE   r.ClassID  IN (21212,21201,21150)
	---
	
	DELETE 
	FROM   @tmp_class1 
	
	-- Выбираем записи, у которых отличается хранение свойств 
	INSERT INTO @tmp_class1 (ClassID, ClassID_Slave, ClassID_New, LevelP)
	SELECT DISTINCT
	       t.ClassID, t.ClassID_Slave, cs.ClassID_Slave, cs.LevelP
	FROM   @Res t
	       JOIN cl_subclass cs
	            ON  cs.ClassID_Master = t.ClassID_Slave
	                AND cs.ClassID_Master <> cs.ClassID_Slave
	       JOIN (
	                SELECT DISTINCT
	                       cp.ClassID
	                FROM   cp_property_cl cp
	                       JOIN cl_fullname cf
	                            ON  cf.MetaObjectID = cp.PropertyID
	            ) cp
	            ON  cp.ClassID = cs.ClassID_Slave
	
	---
	--PRINT 't2'
	--SELECT  * FROM    @tmp_class1
	---
	
	-- Детализируем классы с учетом хранения свойств
	INSERT INTO @Res (ClassID, ClassID_Slave, LevelP)
	SELECT DISTINCT
	       t.ClassID, cs.ClassID_Slave, 1
	FROM   @tmp_class1 t
	       JOIN cl_subclass cs
	            ON  cs.ClassID_Master = t.ClassID_Slave
	                AND cs.LevelP = t.LevelP
	       LEFT	JOIN @Res r
	            ON  r.ClassID = cs.ClassID_Master
	                AND r.ClassID_Slave = cs.ClassID_Slave
	WHERE  r.ClassID IS NULL				
	
	DELETE t
	FROM   @Res t
	       JOIN @tmp_class1 tt
	            ON  t.ClassID_Slave = tt.ClassID_Slave
	
	
	-- Удаляем те классы, у которых прописаны наследники
	DELETE r
	FROM   @Res r
	       JOIN cl_subclass cs
	            ON  cs.ClassID_Master = r.ClassID_Slave
	       JOIN @Res r1
	            ON  r1.ClassID_Slave = cs.ClassID_Slave
	WHERE  cs.ClassID_Slave <> cs.ClassID_Master
	
	---
	--PRINT 'S3'
	--SELECT  * FROM    @res r WHERE   r.ClassID  IN (21212,21201,21150)
	---
	
	---
	--SELECT  ClassID_Slave FROM    @Res
	--GROUP BY ClassID_Slave
	--HAVING  COUNT(*) > 1
	--RETURN
	---
	
	
	-- Собственно записываем
	TRUNCATE TABLE cl_subclass_for_calc_fullname
	
	INSERT INTO cl_subclass_for_calc_fullname(ClassID_Slave, ClassID)
	SELECT r.ClassID_Slave, r.ClassID
	FROM   @Res r
GO 
GRANT EXECUTE ON dbo.sp_set_subclass_for_calc_fullname TO TetraUsers

