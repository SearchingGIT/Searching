IF EXISTS (
       SELECT *
       FROM   sysobjects
       WHERE  TYPE         = 'P'
              AND NAME     = 'sp_check_property_object'
   )
BEGIN
    DROP PROCEDURE sp_check_property_object
END

GO

/* Проверяет заполненность свойств объекта */
CREATE PROCEDURE dbo.sp_check_property_object
(
	@ObjectID         INT
)
AS
	DECLARE @errmsg VARCHAR(8000) /* Проверка открытия транзакции */
	
	DECLARE @sSql            NVARCHAR(4000)
	        ,@PropertyID     SMALLINT
	        ,@NameTable      VARCHAR(64)
	        ,@NameField      VARCHAR(64)
	        ,@IDName         VARCHAR(64)
	        ,@NameMetaID     VARCHAR(64)

/*	
	CREATE TABLE #tmp_property
	(
		PropertyID     SMALLINT PRIMARY KEY
	   ,NameTable      VARCHAR(64) NULL
	   ,NameField      VARCHAR(64) NULL
	   ,isEmpty        BIT DEFAULT(1)
	)
*/	
	SET NOCOUNT ON
	
	UPDATE t
	SET    NameTable = mm.NameTable, NameField = mm.NameField
	FROM   #tmp_property t
	       JOIN (
	                SELECT t.PropertyID, t.NameTable, t.NameField
	                FROM   (
	                           SELECT cpc.PropertyID, MIN(cs.LevelP) AS LevelP
	                           FROM   mn_object mo
	                                  JOIN cl_subclass cs
	                                       ON  cs.ClassID_Slave = mo.ClassID
	                                  JOIN cp_property_cl cpc
	                                       ON  cpc.ClassID = cs.ClassID_Master
	                           WHERE  mo.ObjectID = @ObjectID
	                           GROUP BY cpc.PropertyID
	                       ) m
	                       JOIN (
	                                SELECT cpc.PropertyID, cpc.NameTable, cpc.NameField, cs.LevelP
	                                FROM   mn_object mo
	                                       JOIN cl_subclass cs
	                                            ON  cs.ClassID_Slave = mo.ClassID
	                                       JOIN cp_property_cl cpc
	                                            ON  cpc.ClassID = cs.ClassID_Master
	                                WHERE  mo.ObjectID = @ObjectID
	                            ) t
	                            ON  t.PropertyID = m.PropertyID
	                                AND t.LevelP = m.LevelP
	            ) mm
	            ON  mm.PropertyID = t.PropertyID
	
	IF EXISTS (
	       SELECT *
	       FROM   #tmp_property
	       WHERE  NameTable IS NULL
	   )
	BEGIN
	    SELECT @errmsg = 'Не указано размещение для свойств объекта с кодом ' + LTRIM(STR(@ObjectID)) +
	           '. Список свойств:'
	    
	    SELECT @errmsg = @errmsg + dbo.f_CrLf() + LTRIM(STR(t.PropertyID))
	    FROM   #tmp_property t
	    WHERE  NameTable IS NULL
	    
	    RAISERROR(@errmsg, 16, 1)
	END
	
	
	-- Цикл по свойствам
	SELECT @PropertyID = -32000
	
	WHILE 1 = 1
	BEGIN
	    SELECT @PropertyID = t.PropertyID, @NameTable = t.NameTable, @NameField = t.NameField, @IDName = 
	           cl.IDName, @NameMetaID = cl.NameMetaID
	    FROM   #tmp_property t
	           JOIN cp_location cl
	                ON  cl.Location = t.NameTable
	    WHERE  t.PropertyID > @PropertyID
	    ORDER BY t.PropertyID DESC
	    
	    IF @@ROWCOUNT < 1
	        BREAK
	    
	    
	    SELECT @NameField = ISNULL(@NameField, 'VALUE') 
	    
	    ---
	    --SELECT @PropertyID AS '@PropertyID', @NameTable AS '@NameTable',@NameField AS '@NameField',@NameMetaID AS '@NameMetaID',@IDName AS '@IDName'
	    ---
	    
	    SELECT @sSql = 'IF EXISTS (' + dbo.f_CrLf()
	    
	    IF @NameMetaID IS NULL
	    BEGIN
	        SELECT @sSql = @sSql + 'SELECT * FROM ' + @NameTable + ' m where m.' + @IDName + ' = ' +
	               LTRIM(STR(@ObjectID)) 
	               + ' AND not m.' + @NameField + ' IS NULL'
	    END
	    ELSE
	    BEGIN
	        SELECT @sSql = @sSql + 'SELECT * FROM ' + @NameTable + ' m where m.' + @IDName + ' = ' +
	               LTRIM(STR(@ObjectID)) + ' AND m.' + @NameMetaID + ' = ' + LTRIM(STR(@PropertyID)) 
	               + ' AND not m.' + @NameField + ' IS NULL'
	    END
	    
	    SELECT @sSql = @sSql + ')' + dbo.f_CrLf() + 'UPDATE #tmp_property SET isEmpty = 0 WHERE PropertyID = ' + LTRIM(STR(@PropertyID))
	    
	    --
	    --PRINT @sSQL
	    --  
	    
	    EXEC dbo.sp_executesql @sSQL
	END
	
	---
	--SELECT *	FROM   #tmp_property
	---
GO
    
GRANT EXEC ON sp_check_property_object TO TetraUsers
