IF EXISTS (
       SELECT *
       FROM   sysobjects
       WHERE  TYPE         = 'P'
              AND NAME     = 'sp_drop_all_view'
   )
BEGIN
    DROP PROCEDURE sp_drop_all_view
END

GO

CREATE PROCEDURE [dbo].[sp_drop_all_view] -- Удаление всех view
AS
	DECLARE @TableID      INT
	        ,@Str_Sql     VARCHAR(255)
	        ,@SPName      VARCHAR(48)
	        ,@errmsg      VARCHAR(255)
	
	/* Собственно удаление */
	WHILE 1 = 1
	BEGIN
	    SELECT @SPName = s.Name
	    FROM   sysobjects s
	    WHERE  xtype = 'V'
	           --   where xtype in ('P', 'TR', 'U', 'V')
	           AND STATUS >= 0
	    ORDER BY xtype, NAME
	    
	    IF @@rowcount < 1
	        BREAK 
	    
	    SELECT @str_sql = 'drop view ' + @SPName 
	    PRINT @Str_sql  
	    EXEC (@str_sql)
	END
GO

GRANT EXEC ON sp_drop_all_view TO TetraUsers

GO