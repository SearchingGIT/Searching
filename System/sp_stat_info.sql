IF EXISTS (
       SELECT *
       FROM   sysobjects
       WHERE  TYPE         = 'P'
              AND NAME     = 'sp_stat_info'
   )
BEGIN
    DROP PROCEDURE sp_stat_info
END

GO

CREATE PROCEDURE [dbo].[sp_stat_info]
(
	@Mode TINYINT = 1
)
AS
	DECLARE @Stat VARCHAR(48)
	        ,@TableS VARCHAR(48)
	        ,@Str_Sql VARCHAR(255)
	
	DECLARE sel SCROLL CURSOR
	FOR 
	SELECT s1.Name AS Stat, s2.Name   AS TableS
	FROM   sysindexes s1, sysobjects     s2
	WHERE  (s1.status & 96 = 96)
	       AND s2.ID = s1.ID
	       AND NOT s2.NAME LIKE '%sys_%'
	
	OPEN sel
	FETCH NEXT FROM sel INTO @Stat, @TableS
	WHILE (@@fetch_status <> -1)
	BEGIN
	    SELECT @Str_Sql = CAST(@TableS AS CHAR(48)) + @Stat 
	    PRINT 
	    '==========================================================================================================='
	    PRINT @Str_sql 
	    PRINT 
	    '==========================================================================================================='
	    IF @Mode = 2
	        DBCC SHOW_STATISTICS(@TableS, @Stat)
	    
	    FETCH NEXT FROM sel INTO @Stat, @TableS
	END
	CLOSE sel
	DEALLOCATE sel
GO


GRANT EXEC ON sp_stat_info TO TetraUsers
