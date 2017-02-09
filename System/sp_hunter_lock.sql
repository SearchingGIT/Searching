IF EXISTS (
       SELECT *
       FROM   sysobjects
       WHERE  TYPE         = 'P'
              AND NAME     = 'sp_hunter_lock'
   )
BEGIN
    DROP PROCEDURE sp_hunter_lock
END

GO

/* Процедура предназначена для отлова блокировок. 
Пойманные блокировки пишет в таблицу (которую при необходимости сама же и создает).
Предполагается, что процедура будет запущена в фоновом режиме через SQL Agent
 */
CREATE PROCEDURE dbo.sp_hunter_lock
(
	@TO INT = 5 -- Таймаут сканирования блокировок
)
AS
	DECLARE @TS VARCHAR(8)
	
	SET NOCOUNT ON
	
	/*
	CREATE TABLE ss_lock (
	TableName SYSNAME NULL
	,Start SMALLDATETIME
	,Duration_sec INT
	,SPID_Victim INT
	,sql_Victim VARCHAR(MAX)
	,User_Victim SYSNAME
	,HOST_NAME_Victim SYSNAME
	,program_name_Victim SYSNAME
	,login_name_Victim SYSNAME
	,nt_user_name_Victim SYSNAME
	,TranCount_Victim INT
	,SPID_Aggressor INT
	,sql_Aggressor VARCHAR(MAX) NULL
	,User_Aggressor SYSNAME NULL
	,HOST_NAME_Aggressor SYSNAME
	,program_name_Aggressor SYSNAME
	,login_name_Aggressor SYSNAME
	,nt_user_name_Aggressor SYSNAME
	,TranCount_Aggressor INT NULL)
	
	*/
	
	IF NOT EXISTS (
	       SELECT *
	       FROM   sysobjects
	       WHERE  NAME = 'ss_lock'
	   )
	    CREATE TABLE ss_lock
	    (
	    	TableName                  SYSNAME NULL
	       ,START                      SMALLDATETIME
	       ,Duration_sec               INT
	       ,SPID_Victim                INT
	       ,sql_Victim                 VARCHAR(MAX)
	       ,User_Victim                SYSNAME
	       ,HOST_NAME_Victim           SYSNAME
	       ,program_name_Victim        SYSNAME
	       ,login_name_Victim          SYSNAME
	       ,nt_user_name_Victim        SYSNAME
	       ,TranCount_Victim           INT
	       ,SPID_Aggressor             INT
	       ,sql_Aggressor              VARCHAR(MAX) NULL
	       ,User_Aggressor             SYSNAME NULL
	       ,HOST_NAME_Aggressor        SYSNAME
	       ,program_name_Aggressor     SYSNAME
	       ,login_name_Aggressor       SYSNAME
	       ,nt_user_name_Aggressor     SYSNAME
	       ,TranCount_Aggressor        INT NULL
	    )
	
	WHILE 1 = 1
	BEGIN
	    UPDATE sl
	    SET    Duration_sec = l.duration_sec
	    FROM   ss_lock sl
	           JOIN (
	                    SELECT s1.start_time, DATEDIFF(ss, s1.start_time, GETDATE()) AS duration_sec, s1.session_id AS 
	                           SPID_Victim, s1.blocking_session_id AS SPID_Aggressor
	                    FROM   sys.dm_exec_requests s1
	                           JOIN sys.dm_exec_sessions ss2
	                                ON  s1.blocking_session_id = ss2.session_id
	                           LEFT JOIN sys.dm_exec_requests s2
	                                ON  s2.session_id = ss2.session_id
	                ) l
	                ON  l.SPID_Victim = sl.SPID_Victim
	                    AND l.SPID_Aggressor = sl.SPID_Aggressor
	                    AND sl.Start = CAST(l.start_time AS SMALLDATETIME)
	    
	    INSERT INTO ss_lock(
	        TableName, START, Duration_sec, SPID_Victim, sql_Victim, User_Victim, HOST_NAME_Victim, 
	        program_name_Victim, login_name_Victim, nt_user_name_Victim, TranCount_Victim, SPID_Aggressor, 
	        sql_Aggressor, User_Aggressor, HOST_NAME_Aggressor, program_name_Aggressor, 
	        login_name_Aggressor, nt_user_name_Aggressor, TranCount_Aggressor
	    )
	    SELECT OBJECT_NAME(tl.resource_associated_entity_id) AS TableName, s1.start_time, DATEDIFF(ss, s1.start_time, GETDATE()) AS 
	           duration_sec, s1.session_id AS SPID_Victim, t1.TEXT AS SQL_Victim, USER_NAME(s1.user_id) AS 
	           User_Victim, ss1.HOST_NAME AS HOST_NAME_Victim, ss1.program_name AS program_name_Victim, 
	           ss1.login_name AS login_name_Victim, ss1.nt_user_name AS nt_user_name_Victim, s1.open_transaction_count AS 
	           TranCount_Victim, s1.blocking_session_id AS SPID_Aggressor, t2.TEXT AS SQL_Aggressor, 
	           USER_NAME(s2.user_id) AS User_Aggressor, ss2.HOST_NAME AS HOST_NAME_Aggressor, ss2.program_name AS 
	           program_name_Aggressor, ss2.login_name AS login_name_Aggressor, ss2.nt_user_name AS 
	           nt_user_name_Aggressor, s2.open_transaction_count AS TranCount_Aggressor
	    FROM   sys.dm_exec_requests s1
	           OUTER APPLY sys.dm_exec_sql_text(s1.sql_handle) AS t1
	    JOIN sys.dm_exec_sessions ss1
	                ON  s1.session_id = ss1.session_id
	           JOIN sys.dm_exec_sessions ss2
	                ON  s1.blocking_session_id = ss2.session_id
	           LEFT JOIN sys.dm_exec_requests s2
	                ON  s2.session_id = ss2.session_id
	           OUTER APPLY sys.dm_exec_sql_text(s2.sql_handle) AS t2
	    LEFT JOIN sys.dm_tran_locks tl
	                ON  tl.request_session_id = ss2.session_id
	                    AND tl.resource_type = 'OBJECT'
	    WHERE  NOT EXISTS (
	               SELECT *
	               FROM   ss_lock AS SL
	               WHERE  sl.SPID_Victim = s1.session_id
	                      AND sl.SPID_Aggressor = s1.blocking_session_id
	                      AND sl.Start = CAST(s1.start_time AS SMALLDATETIME)
	           )
	    
	    SELECT @TS = CONVERT(VARCHAR(8), DATEADD(ss, @TO, GETDATE()), 108)
	    
	    WAITFOR TIME @TS
	END
GO

