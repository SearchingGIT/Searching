IF EXISTS (
       SELECT *
       FROM   sysobjects
       WHERE  TYPE = 'P'
              AND NAME = 'sp_remove_fk'
   )
BEGIN
    DROP PROCEDURE sp_remove_fk
END

GO

CREATE PROCEDURE sp_remove_fk
(
	@TableName         VARCHAR(32)
	, @TableFKNameDef  VARCHAR(32) = NULL
	, @isSave          BIT = 0
	, @isRestore       BIT = 0
)
AS
	DECLARE @TableID         INT
	        ,@TableFKName    VARCHAR(32)
	        ,@Str_Sql        VARCHAR(255)
	        ,@FKName         VARCHAR(48)
	        ,@TableNameFull  VARCHAR(255)
	        ,@Poz            TINYINT
	        ,@UserID         INT
	        ,@F1             VARCHAR(255)
	        ,@F2             VARCHAR(255)
	        ,@KeyID          INT
	        ,@FieldName      SYSNAME
	        ,@FieldNameFk    SYSNAME
	        ,@onDelete       SYSNAME
	        ,@onUpdate       SYSNAME
			,@errmsg         VARCHAR(255)
	        ,@errmsgXML     VARCHAR(8000)
	        ,@paramSTR      VARCHAR(256)
	
	
	SET NOCOUNT ON
	/*
	CREATE TABLE tmp_save_fk (
	KeyID INT
	,sKEY SYSNAME
	,TableName SYSNAME
	,TableNameFk SYSNAME
	,FieldName SYSNAME NULL
	,FieldNameFk SYSNAME NULL
	,onDelete SYSNAME
	,onUpdate SYSNAME
	,PRIMARY KEY (KeyID))
	
	*/
	
	SELECT @Poz = CHARINDEX('.', @TableName)
	IF ISNULL(@poz, 0) <= 0
	BEGIN
	    IF EXISTS (
	           SELECT COUNT(*)
	           FROM   sysobjects
	           WHERE  xType = 'U'
	                  AND NAME = @TableName
	           HAVING COUNT(*) > 1
	       )
	    BEGIN
	        SELECT @errmsg= 'Существует несколько таблиц с таким именем'
			SELECT @errmsgXML = dbo.f_error_2_XML(OBJECT_NAME(@@PROCID), 'SqlRe231', 'TLRCommonResDB', @errmsg, NULL)
			RAISERROR(@errmsgXML, 16, 1)
	        RETURN
	    END
	    SELECT @TableID = Id
	    FROM   sysobjects
	    WHERE  xType = 'U'
	           AND NAME = @TableName
	END
	ELSE
	BEGIN
	    SELECT @TableNameFull = @TableName
	    SELECT @TableName = SUBSTRING(@Tablename, @poz + 1, 32)		
	    SELECT @UserId = USER_ID(SUBSTRING(@TableNameFull, 1, @poz - 1))	
	    SELECT @TableID = Id
	    FROM   sysobjects
	    WHERE  xType = 'U'
	           AND NAME = @TableName
	           AND uid = @UserID
	END
	IF ISNULL(LTRIM(@TableID), 0) = 0
	BEGIN
	    SELECT @errmsg = 'Таблица не найдена'
		SELECT @errmsgXML = dbo.f_error_2_XML(OBJECT_NAME(@@PROCID), 'SqlRe232', 'TLRCommonResDB', @errmsg, NULL)
		RAISERROR(@errmsgXML, 16, 1)
	    RETURN
	END
	
	-- Восстанавливаем FK
	IF @isRestore = 1
	BEGIN
	    SELECT @KeyID = 0
	    WHILE 1 = 1
	    BEGIN
	        SELECT @KeyID = t.KeyID, @TableName = t.TableName, @FKName = t.sKEY, @TableFKName = t.TableNameFk, @FieldName = 
	               t.FieldName, @FieldNameFk = t.FieldNameFk, @onDelete = t.onDelete, @onUpdate = t.onUpdate
	        FROM   tmp_save_fk t
	        WHERE  t.TableName = @TableName
	               AND t.TableNameFk = ISNULL(@TableFKNameDef, t.TableNameFk)
	               AND t.KeyID > @KeyID
	        ORDER BY t.KeyID DESC
	        
	        IF @@ROWCOUNT < 1
	            BREAK
	        
	        SELECT @Str_Sql = 'ALTER TABLE ' + @TableFKName --
	               + ' ADD' -- 
	               + ' CONSTRAINT ' + @FKName -- 
	               + ' FOREIGN KEY' + ' ( ' + @FieldNameFk + ' )' --
	               + ' REFERENCES ' + @TableName + ' ( ' + @FieldName + ' )' --
	               + ' ON DELETE ' + @onDelete --
	               + ' ON UPDATE ' + @onUpdate --
	        
	        PRINT @Str_Sql
	        EXEC (@str_sql)
	    END
	    
	    RETURN
	END
	
	-- Сохраняем информацию по всем FK
	IF @isSave = 1
	BEGIN
	    IF NOT EXISTS (
	           SELECT *
	           FROM   sysobjects
	           WHERE  TYPE = 'U'
	                  AND NAME = 'tmp_save_fk'
	       )
	    BEGIN
	        CREATE TABLE tmp_save_fk
	        (
	        	KeyID          INT
	        	, sKEY         SYSNAME
	        	, TableName    SYSNAME
	        	, TableNameFk  SYSNAME
	        	, FieldName    SYSNAME NULL
	        	, FieldNameFk  SYSNAME NULL
	        	, onDelete     SYSNAME
	        	, onUpdate     SYSNAME
	        	, PRIMARY KEY(KeyID)
	        )
	    END
	    ELSE
	    BEGIN
	        SELECT @str_sql = 'DELETE t FROM tmp_save_fk t' 
	               + ' WHERE t.TableName = ''' + @TableName + '''' 
	               + '	AND t.TableNameFk = ' + ISNULL('''' + @TableFKNameDef + '''', 't.TableNameFk')
	        
	        PRINT @Str_Sql
	        EXEC (@str_sql)
	    END
	    
	    -- Заполняем таблицу с FK
	    ---
	    --SELECT * FROM tmp_save_fk
	    ---
	    
	    INSERT INTO tmp_save_fk(KeyID, sKEY, TableName, TableNameFk, onDelete, onUpdate)
	    SELECT m.[object_id], m.Name AS NameFK, o.[name], f.name AS TableNameFK, REPLACE(m.delete_referential_action_desc, '_', ' '), 
	           REPLACE(m.update_referential_action_desc, '_', ' ')
	    FROM   sys.foreign_keys m
	           JOIN SYS.objects f
	                ON  f.[object_id] = m.parent_object_id
	           JOIN SYS.objects o
	                ON  o.[object_id] = m.referenced_object_id
	    WHERE  m.referenced_object_id = @TableID
	           AND f.[name] = ISNULL(@TableFKNameDef, f.[name])
	    
	    SELECT @KeyID = 0
	    WHILE 1 = 1
	    BEGIN
	        SELECT @KeyID = t.KeyID
	        FROM   tmp_save_fk t
	        WHERE  t.KeyID > @KeyID
	        ORDER BY t.KeyID DESC
	        
	        IF @@ROWCOUNT < 1
	            BREAK
	        
	        SELECT @F1 = '', @F2 = ''
	        
	        SELECT @F1 = @F1 + CASE 
	                                WHEN @F1 = '' THEN ''
	                                ELSE ', '
	                           END + c1.[name], @F2 = @F2 + CASE 
	                                                             WHEN @F2 = '' THEN ''
	                                                             ELSE ', '
	                                                        END + c2.[name]
	        FROM   sys.foreign_key_columns fkc
	               JOIN sys.[columns] c1
	                    ON  c1.[object_id] = fkc.referenced_object_id
	                        AND c1.column_id = fkc.referenced_column_id
	               JOIN sys.[columns] c2
	                    ON  c2.[object_id] = fkc.parent_object_id
	                        AND c2.column_id = fkc.parent_column_id
	        WHERE  fkc.constraint_object_id = @KeyID                                 
	        
	        UPDATE tmp_save_fk
	        SET    FieldName   = @F1
	        	, FieldNameFk  = @F2
	        WHERE  KeyID       = @KeyID
	    END
	END
	
	---
	--ALTER TABLE cl_region_property_cl
	--	ADD  FOREIGN KEY (PropertyID,ClassID) REFERENCES cl_property_cl(PropertyID,ClassID)
	--		ON DELETE NO ACTION
	--		ON UPDATE NO ACTION
	
	--go
	--SELECT  @TableName, @TableFKNameDef, @TableID, @TableNameFull
	---
	
	-- Собственно удаление
	DECLARE sel SCROLL CURSOR
	FOR 
	SELECT DISTINCT
	       f.Name, o.name
	FROM   sysforeignkeys m, sysobjects o, sysobjects f
	WHERE  m.rkeyid = @TableID
	       AND o.ID = m.ConstID
	       AND f.ID = o.Parent_obj
	       AND f.[name] = ISNULL(@TableFKNameDef, f.[name])
	OPEN sel
	FETCH NEXT FROM sel INTO @TableFKName, @FkName
	WHILE (@@fetch_status <> -1)
	BEGIN
	    SELECT @str_sql = 'alter table ' + @TableFKName + ' drop constraint ' + @FKName 
	    PRINT @Str_sql	
	    EXEC (@str_sql) 
	    FETCH NEXT FROM sel INTO @tableFKName, @FkName
	END
	CLOSE sel
	DEALLOCATE sel
GO
GRANT EXEC ON sp_remove_fk TO TetraUsers


