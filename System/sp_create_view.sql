IF EXISTS (
       SELECT *
       FROM   sysobjects
       WHERE  TYPE         = 'P'
              AND NAME     = 'sp_create_view'
   )
BEGIN
    DROP PROCEDURE sp_create_view
END

GO

/* Процедура создает view по переданной SQL строке */
CREATE PROCEDURE dbo.sp_create_view
(
	@sSql         NVARCHAR(MAX)
   ,@ViewName     SYSNAME
)
WITH EXECUTE AS OWNER

AS 

DECLARE @sSQL1     AS NVARCHAR(MAX)
	
/*  Удаляем view  */
SELECT @sSql1 = 'IF EXISTS ( SELECT  *
         FROM    sysobjects
         WHERE   name = ''' + @ViewName + ''')	DROP VIEW ' + @ViewName
 
EXEC dbo.sp_executesql @sSQL1
	
/* Создаем view  */
SELECT @sSql1 = 'CREATE VIEW ' + @ViewName + '' + dbo.f_CrLf() --
       + 'AS' + dbo.f_CrLf() --
       + @sSql + dbo.f_CrLf() --
                       ---
                       --PRINT @sSql1
                       ---
EXEC dbo.sp_executesql @sSQL1
	
/* Даём права */
SELECT @sSql1 = 'GRANT SELECT ON ' + @ViewName + ' TO TetraUsers' + dbo.f_CrLf()
EXEC dbo.sp_executesql @sSQL1

GO
GRANT EXEC ON sp_create_view TO TetraUsers
