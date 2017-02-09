IF EXISTS (
       SELECT *
       FROM   sysobjects
       WHERE  NAME = 'sp_full_reindex'
   )
    DROP PROCEDURE sp_full_reindex    
GO

CREATE PROCEDURE [dbo].[sp_full_reindex]
AS
	DECLARE @name   AS VARCHAR(1023)
	        , @sql  AS VARCHAR(2047)
	
	SELECT @name = ''
	WHILE EXISTS (
	          SELECT TOP 1
	                 *
	          FROM   dbo.sysobjects
	          WHERE  OBJECTPROPERTY(id, N'IsUserTable') = 1
	                 AND NAME > @name
	      )
	BEGIN
	    SELECT TOP 1
	           @name = NAME
	    FROM   dbo.sysobjects
	    WHERE  OBJECTPROPERTY(id, N'IsUserTable') = 1
	           AND NAME > @name
	    ORDER BY NAME
	    
	    PRINT 'Reindex table ' + @name + ' ' + CONVERT(VARCHAR(24), GETDATE(), 20)
	    SELECT TOP 1
	           @sql = 'DBCC DBREINDEX (' + CHAR(39) + @name + CHAR(39) + ')'
	    EXEC (@sql)

	    PRINT ''
	END
	
	EXEC sp_updatestats
GO

GO
GRANT EXECUTE ON sp_full_reindex TO TetraUsers