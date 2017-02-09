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

/* ��������� ������� view �� ���������� SQL ������ */
CREATE PROCEDURE dbo.sp_create_view
(
	@sSql         NVARCHAR(MAX)
   ,@ViewName     SYSNAME
)
WITH EXECUTE AS OWNER

AS 

DECLARE @sSQL1     AS NVARCHAR(MAX)
	
/*  ������� view  */
SELECT @sSql1 = 'IF EXISTS ( SELECT  *
         FROM    sysobjects
         WHERE   name = ''' + @ViewName + ''')	DROP VIEW ' + @ViewName
 
EXEC dbo.sp_executesql @sSQL1
	
/* ������� view  */
SELECT @sSql1 = 'CREATE VIEW ' + @ViewName + '' + dbo.f_CrLf() --
       + 'AS' + dbo.f_CrLf() --
       + @sSql + dbo.f_CrLf() --
                       ---
                       --PRINT @sSql1
                       ---
EXEC dbo.sp_executesql @sSQL1
	
/* ��� ����� */
SELECT @sSql1 = 'GRANT SELECT ON ' + @ViewName + ' TO TetraUsers' + dbo.f_CrLf()
EXEC dbo.sp_executesql @sSQL1

GO
GRANT EXEC ON sp_create_view TO TetraUsers
