IF EXISTS (
       SELECT *
       FROM   sysobjects
       WHERE  TYPE         = 'P'
              AND NAME     = 'sp_drop_index'
   )
BEGIN
    DROP PROCEDURE sp_drop_index
END

GO

-- Удаление индексов
CREATE PROCEDURE dbo.sp_drop_index
(
	@Table      SYSNAME = NULL
   ,@Prefix     VARCHAR(8000) = NULL
)
AS
	DECLARE @quoted_tablename     NVARCHAR(270)
	        ,@IndexName           SYSNAME
	        ,@TableName           SYSNAME
	        ,@Str_Sql             VARCHAR(255)
	
	SELECT @IndexName = ''
	
	WHILE 1 = 1
	BEGIN
	    SELECT @IndexName = i.[name], @TableName = t.[name]
	    FROM   sys.indexes i
	           JOIN sys.tables t
	                ON  t.[object_id] = i.[object_id]
	    WHERE  i.is_unique = 0
	           AND i.[name] > @IndexName
	           AND i.is_primary_key = 0
	           AND NOT i.[name] IS NULL
	           AND (
	                   @Prefix IS NULL
	                   OR LEFT(t.[name], 3) IN (SELECT VALUE
	                                            FROM   dbo.f_list_to_table_s(@Prefix))
	               )
	           AND NOT t.[name] LIKE 'sys%'
	           AND t.name = ISNULL(@table, t.name)
	    ORDER BY i.[name] DESC	
	    
	    IF @@ROWCOUNT < 1
	        BREAK
	    
	    SELECT @Str_Sql = 'IF EXISTS ( SELECT  *  FROM    sysindexes WHERE   NAME = ''' + @IndexName + 
	           ''')' + dbo.f_CrLf()
	    
	    SELECT @Str_Sql = @Str_Sql + 'DROP INDEX ' + @IndexName + ' ON ' + @TableName 
	    
	    PRINT @Str_Sql
	    EXEC (@str_sql)
	END
GO


GRANT EXEC ON sp_drop_index TO TetraUsers