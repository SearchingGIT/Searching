IF EXISTS (
       SELECT *
       FROM   sysobjects
       WHERE  TYPE = 'P'
              AND NAME = 'sp_create_dn_object'
   )
BEGIN
    DROP PROCEDURE sp_create_dn_object
END

GO

CREATE PROCEDURE dbo.sp_create_dn_object
AS
	-- ќбновл€ем таблицу зависимости классов дл€ расчета
	EXEC dbo.sp_set_subclass_for_calc_fullname
	EXEC dbo.sp_create_dn_function
	EXEC dbo.sp_create_dn_view
	EXEC dbo.sp_create_dn_procedure
GO
GRANT EXEC ON sp_create_dn_object TO TetraUsers
