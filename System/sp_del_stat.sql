IF EXISTS (
       SELECT *
       FROM   sysobjects
       WHERE  NAME = 'sp_del_stat'
   )
    DROP PROCEDURE sp_del_stat    
GO

CREATE PROCEDURE dbo.sp_del_stat
(
	@Prefix VARCHAR(8000) = NULL -- Список трёх первых символов таблицы через пробел. Например 'cl_ cp_ mn_'
)
AS
	DECLARE @Stat VARCHAR(48)
	        ,@TableS VARCHAR(48)
	        ,@Str_Sql VARCHAR(255)
	
	DECLARE sel SCROLL CURSOR
	FOR 
	SELECT s1.Name AS Stat, s2.Name AS TableS
	FROM   sysindexes s1, sysobjects s2
	WHERE  (s1.status & 64 = 64)
	       AND s2.ID = s1.ID
	       AND (
	               @Prefix IS NULL
	               OR LEFT(s2.[name], 3) IN (SELECT VALUE
	                                         FROM   dbo.f_list_to_table_s(@Prefix))
	           )
	       AND NOT s2.NAME LIKE 'sys%'
	
	
	OPEN sel
	
	FETCH NEXT FROM sel INTO @Stat, @TableS
	
	WHILE (@@fetch_status <> -1)
	BEGIN
	    SELECT @Str_Sql = 'DROP STATISTICS ' + @TableS + '.' + @Stat 
	    PRINT @Str_sql	
	    EXEC (@Str_Sql)
	    
	    FETCH NEXT FROM sel INTO @Stat, @TableS
	END
	
	CLOSE sel
	DEALLOCATE sel
GO
GRANT EXECUTE ON sp_del_stat TO TetraUsers