USE [master]
GO

IF EXISTS (
       SELECT *
       FROM   sysobjects
       WHERE  TYPE         = 'P'
              AND NAME     = 'sp_restore_database'
   )
BEGIN
    DROP PROCEDURE sp_restore_database
END
GO

CREATE PROCEDURE dbo.sp_restore_database
(
	@DBName            SYSNAME = NULL OUT
   ,@DBNameMask        SYSNAME = NULL
   ,@Backup            VARCHAR(8000)
   ,@NodeID            INT = NULL
   ,@TypeProjectID     TINYINT = NULL
   ,@Overwrite         BIT = 0 -- Перезаписывать ли существующую БД
   ,@ID                VARCHAR(64) = NULL
)
AS
	DECLARE @errmsg VARCHAR(8000) /* Проверка открытия транзакции */
	        ,@errmsgXML VARCHAR(8000)
	        ,@paramSTR VARCHAR(256)
	
	DECLARE @sSql          AS NVARCHAR(MAX)
	        ,@Data         SYSNAME
	        ,@DataArx      SYSNAME
	        ,@Log          SYSNAME
	        ,@DataInMemory SYSNAME
	        ,@DataPath     VARCHAR(4000)
	        ,@LogPath      VARCHAR(4000)
	        ,@N            INT
	        ,@QtyFiles	   TINYINT	 
	
	--  SELECT  @DBName = 'TEST_KSM1', @Backup = 'd:\Backup\Test.bak'
	SET NOCOUNT ON
	
	CREATE TABLE #TMP
	(
		ID                       INT IDENTITY(1, 1)
	   ,LogicalName              SYSNAME
	   ,PhysicalName             SYSNAME
	   ,TYPE                     VARCHAR(8)
	   ,FileGroupName            SYSNAME NULL
	   ,SIZE                     INT
	   ,MAXSIZE                  BIGINT
	   ,FileId                   INT
	   ,CreateLSN                VARCHAR(8000)
	   ,DropLSN                  INT
	   ,UniqueId                 VARCHAR(8000)
	   ,ReadOnlyLSN              INT
	   ,ReadWriteLSN             INT
	   ,BackupSizeInBytes        INT
	   ,SourceBlockSize          INT
	   ,FileGroupId              INT
	   ,LogGroupGUID             VARCHAR(8000)
	   ,DifferentialBaseLSN      VARCHAR(8000)
	   ,DifferentialBaseGUID     VARCHAR(8000)
	   ,IsReadOnly               INT
	   ,IsPresent                INT
	   ,TDEThumbprint            INT
	)
	
	BEGIN TRY
		
		IF NOT DB_NAME() = 'master'
		BEGIN
		    SELECT @errmsg = 'Процедура {c} должна выполняться только на базе master.'
		    SELECT @paramSTR = '[c, ' + OBJECT_NAME(@@PROCID) + ', 9]' -- 
		    SELECT @errmsgXML = dbo.f_error_2_XML(OBJECT_NAME(@@PROCID), 'SqlRe150','TLRCommonResDB', @errmsg, @paramSTR)
		    RAISERROR (@errmsgXML, 16, 1)
		END
		
		IF @DBName IS NULL
		   AND @DBNameMask IS NULL
		BEGIN
		    SELECT @errmsg = 'Необходимо указать имя либо маску имени БД.'
		    SELECT @errmsgXML = dbo.f_error_2_XML(OBJECT_NAME(@@PROCID), 'SqlRe151','TLRCommonResDB', @errmsg, NULL)
		    RAISERROR (@errmsgXML, 16, 1)
		END 
		
		-- Определяем конечное имя БД
		IF @DBName IS NULL
		BEGIN
		    IF @ID IS NULL -- не Передан конкретный код
		    BEGIN
		        SELECT @N = MAX(CAST(m.N AS INT))
		        FROM   (
		                   SELECT d.Name, SUBSTRING(d.[name], LEN(@DBNameMask), 100) AS N
		                   FROM   sys.databases d
		                   WHERE  (d.[name] LIKE(@DBNameMask) OR d.[name] LIKE(@DBNameMask) + '_%')
		                          AND ISNUMERIC(SUBSTRING(d.[name], LEN(@DBNameMask), 100)) = 1
		               ) m
		        
		        SELECT @N = ISNULL(@N, 0) + 1
		        
		        SELECT @DBName = REPLACE(@DBNameMask, '%', LTRIM(STR(@N)))
		    END
		    ELSE
		        --
		    BEGIN
		        SELECT @DBName = REPLACE(@DBNameMask, '%', '') + LTRIM(@ID)
		    END
		END 
		
		SELECT @DBName = REPLACE(@DBName, '-', '@')
		
		---
		--SELECT @errmsg ='Маска: ''' + LTRIM(isnull(replace(@DBNameMask,'%','пр'), 'NULL')) + ''', БД: ' + LTRIM(isnull(@DBName, 'NULL'))
		---
		
		-- Проверяем, что такой БД нет
		IF @Overwrite = 0
		BEGIN
		    IF EXISTS (
		           SELECT *
		           FROM   sys.databases d
		           WHERE  d.[name] = @DBName
		       )
		    BEGIN
		        SELECT @errmsg = 'База данных с именем {c} существует.' 
				SELECT @paramSTR = '[c, ' + @DBName + ', 9]' -- 
				SELECT @errmsgXML = dbo.f_error_2_XML(OBJECT_NAME(@@PROCID), 'SqlRe152','TLRCommonResDB', @errmsg, @paramSTR)
				RAISERROR (@errmsgXML, 16, 1)
		    END
		END

		IF LTRIM(ISNULL(@Backup, '')) = ''
		BEGIN
		    SELECT @errmsg = 'Не передано название файла бекапа.' 
		    SELECT @errmsgXML = dbo.f_error_2_XML(OBJECT_NAME(@@PROCID), 'SqlRe153','TLRCommonResDB', @errmsg, NULL)
		    RAISERROR (@errmsgXML, 16, 1)
		END
		
		SELECT @sSql = ' RESTORE FILELISTONLY FROM DISK = ''' + @Backup + ''''
		
		INSERT INTO #TMP
		EXEC dbo.sp_executesql @sSQL
		
		EXEC MASTER.dbo.xp_instance_regread N'HKEY_LOCAL_MACHINE'
		    ,N'Software\Microsoft\MSSQLServer\MSSQLServer'
		    ,N'DefaultData'
		    ,@DataPath OUTPUT
		
		EXEC MASTER.dbo.xp_instance_regread N'HKEY_LOCAL_MACHINE'
		    ,N'Software\Microsoft\MSSQLServer\MSSQLServer'
		    ,N'DefaultLog'
		    ,@LogPath OUTPUT
		--exec master.dbo.xp_instance_regread N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\MSSQLServer\MSSQLServer', N'BackupDirectory', @BackupDirectory OUTPUT
		
		SELECT @QtyFiles = COUNT (*) FROM #TMP
		
		IF @QtyFiles <3
		BEGIN
		    SELECT @errmsg = 'Количество файлов базы данных в бекапе {c} не равно трём.'
		    SELECT @paramSTR = '[c, ' + @Backup + ', 9]' -- 
		    SELECT @errmsgXML = dbo.f_error_2_XML(OBJECT_NAME(@@PROCID), 'SqlRe154','TLRCommonResDB', @errmsg, @paramSTR)
		    RAISERROR (@errmsgXML, 16, 1)
		END
		
		SELECT @Data = t.LogicalName
		FROM   #TMP t
		WHERE  t.ID = 1
		
		SELECT @DataArx = t.LogicalName
		FROM   #TMP t
		WHERE  t.ID = 2

		SELECT @DataInMemory = t.LogicalName
		FROM   #TMP t
		WHERE  t.Type='S'
		
		SELECT @Log = t.LogicalName
		FROM   #TMP t
		WHERE  t.Type='L'
		
		---
		--SELECT * FROM #TMP
		--SELECT @Data AS '@Data',@DataArx AS '@DataArx',@Log AS '@Log',@DataInMemory AS '@DataInMemory'
		--RETURN
		---
		
		IF SUBSTRING(@DataPath, LEN(@DataPath), 1) <> '\'
		    SELECT @DataPath = @DataPath + '\'
		
		IF SUBSTRING(@LogPath, LEN(@LogPath), 1) <> '\'
		    SELECT @LogPath = @LogPath + '\'
		
		SELECT @sSql = 'RESTORE DATABASE [' + REPLACE(@DBName, ' ', '') + '] FROM DISK = ''' + @Backup + 
		       '''' + dbo.f_CrLf() --
		       + ' WITH REPLACE' + dbo.f_CrLf() --
		       + ', MOVE ''' + @Data + '''' + ' TO ''' + @DataPath + @DBName + '' + '.mdf''' + dbo.f_CrLf() --
		       + ', MOVE ''' + @DataArx + '''' + ' TO ''' + @DataPath + @DBName + '' + '_ARX.mdf''' + dbo.f_CrLf() --
		       + ', MOVE ''' + @Log + '''' + ' TO ''' + @LogPath + @DBName + '' + '.ldf''' + dbo.f_CrLf()

		IF @QtyFiles =4
		BEGIN
			SELECT @sSql = @sSql 
		       + ', MOVE ''' + @DataInMemory + '''' + ' TO ''' + @DataPath + @DBName + '' + '_inMemo.mdf''' + dbo.f_CrLf() --
		END



		--
		--SELECT @DataPath,@LogPath
		--PRINT @sSQL
		--RETURN
		--  
		
		-- Собственно поднимаем бекап
		EXEC dbo.sp_executesql @sSQL
		
		IF NOT @NodeID IS NULL
		BEGIN
		    SELECT @sSql = 'USE ' + @DBName + dbo.f_CrLf() --
		           + ' UPDATE cc_flag SET NodeID = ' + LTRIM(STR(ISNULL(@NodeID, 0))) -- 
		    EXEC dbo.sp_executesql @sSQL
		END

		IF NOT @TypeProjectID IS NULL
		BEGIN
		    SELECT @sSql = 'USE ' + @DBName + dbo.f_CrLf() --
		           + ' UPDATE cc_flag SET TypeProjectID = ' + LTRIM(STR(ISNULL(@TypeProjectID, 0))) --
		    
		    EXEC dbo.sp_executesql @sSQL
		END

	END TRY
	
	/* ======== Обработчик ошибок ======== */
	BEGIN CATCH
		SELECT @errmsgxml = dbo.f_msg_err(
		           OBJECT_NAME(@@PROCID), ERROR_MESSAGE(), ERROR_PROCEDURE(), ERROR_NUMBER(), ERROR_LINE(), ERROR_STATE(), ERROR_SEVERITY()
		       )
		
		SELECT @errmsgxml = 'Ошибка поднятия бекапа. ' + @errmsgxml + dbo.f_CrLf() + ISNULL('Строка запроса: ' + @sSql, '') 
		
		RAISERROR (@errmsgxml, 16, 1) WITH NOWAIT
	END CATCH
	-------------------------
GO

--GRANT EXEC ON sp_restore_database TO TetraUsers
