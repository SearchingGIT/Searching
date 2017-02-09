IF EXISTS ( SELECT  *
            FROM    sysobjects
            WHERE   Name = 'sp_query_info' ) 
  DROP PROCEDURE sp_query_info    
go

CREATE PROCEDURE dbo.sp_query_info
AS 

/*
	Оригинал
	http://msdn.microsoft.com/ru-ru/magazine/cc135978.aspx
*/

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

PRINT '=================================================================================='
PRINT 'Отсутствующие индексы, вызывающие наибольшие издержки (TOP 10)'
PRINT '=================================================================================='
SELECT TOP 10
        [Total Cost] = ROUND(avg_total_user_cost * avg_user_impact * (user_seeks + user_scans), 0) --
        , avg_user_impact -- Query cost would reduce by this amount, on average.
        , TableName = statement --
        , [EqualityUsage] = equality_columns --
        , [InequalityUsage] = inequality_columns --
        , [Include Cloumns] = included_columns --
FROM    sys.dm_db_missing_index_groups g
        JOIN sys.dm_db_missing_index_group_stats s ON s.group_handle = g.index_group_handle
        JOIN sys.dm_db_missing_index_details d ON d.index_handle = g.index_handle
WHERE   d.database_id = DB_ID()
ORDER BY [Total Cost] DESC 


PRINT '=================================================================================='
PRINT 'Определение наибольших издержек по неиспользуемым индексам (TOP 10)'
PRINT '=================================================================================='

SELECT TOP 10
        TableName = OBJECT_NAME(s.[object_id]) --
        , IndexName = i.name --
        , user_updates --
        , system_updates	
FROM    sys.dm_db_index_usage_stats s
        INNER JOIN sys.indexes i ON s.[object_id] = i.[object_id]
                                    AND s.index_id = i.index_id
WHERE   s.database_id = DB_ID()
        AND OBJECTPROPERTY(s.[object_id], 'IsMsShipped') = 0
        AND user_seeks = 0
        AND user_scans = 0
        AND user_lookups = 0
        AND i.name IS NOT NULL -- I.e. Ignore HEAP indexes.
	-- Below may not be needed, they tend to reflect creation of stats, backups etc...
--	AND	system_seeks = 0
--	AND system_scans = 0
--	AND system_lookups = 0
ORDER BY user_updates DESC


PRINT '=================================================================================='
PRINT 'Определение индексов, вызывающих наибольшие издержки (TOP 10)'
PRINT '=================================================================================='

-- Loop around all the databases on the server.
SELECT TOP 10
        [Maintenance cost] = (user_updates + system_updates) --
        , [Retrieval usage] = (user_seeks + user_scans + user_lookups) --
        , TableName = OBJECT_NAME(s.[object_id]) --
        , IndexName = i.name
		-- Useful fields below:
--		,user_updates  
--		,system_updates
--		,user_seeks 
--		,user_scans 
--		,user_lookups 
--		,system_seeks 
--		,system_scans 
--		,system_lookups 
		-- Useful fields below:
--		,*
FROM    sys.dm_db_index_usage_stats s
        INNER JOIN sys.indexes i ON s.[object_id] = i.[object_id]
                                    AND s.index_id = i.index_id
WHERE   s.database_id = DB_ID()
        AND i.name IS NOT NULL	-- I.e. Ignore HEAP indexes.
        AND OBJECTPROPERTY(s.[object_id], 'IsMsShipped') = 0
        AND (user_updates + system_updates) > 0 -- Only report on active rows.
ORDER BY [Maintenance cost] DESC


PRINT '=================================================================================='
PRINT 'Определение наиболее используемых индексов (TOP 10)'
PRINT '=================================================================================='
SELECT TOP 10
        [Usage] = (user_seeks + user_scans + user_lookups) --
        , TableName = OBJECT_NAME(s.[object_id]) --
        , IndexName = i.name 
FROM    sys.dm_db_index_usage_stats s
        INNER JOIN sys.indexes i ON s.[object_id] = i.[object_id]
                                    AND s.index_id = i.index_id
WHERE   s.database_id = DB_ID()
        AND i.name IS NOT NULL	-- I.e. Ignore HEAP indexes.
        AND OBJECTPROPERTY(s.[object_id], 'IsMsShipped') = 0
        AND (user_seeks + user_scans + user_lookups) > 0 -- Only report on active rows.
ORDER BY [Usage] DESC


PRINT '=================================================================================='
PRINT 'Определение наиболее затратных запросов ввода-вывода (TOP 10)'
PRINT '=================================================================================='
SELECT TOP 10
        [Average IO] = (total_logical_reads + total_logical_writes) / qs.execution_count --
        , [Total IO] = (total_logical_reads + total_logical_writes) --
        , [Execution count] = qs.execution_count --
        ,
        [Individual Query] = SUBSTRING(qt.text, qs.statement_start_offset / 2,
                                       (CASE WHEN qs.statement_end_offset = -1
                                             THEN LEN(CONVERT(NVARCHAR(MAX), qt.text)) * 2
                                             ELSE qs.statement_end_offset
                                        END - qs.statement_start_offset) / 2) --
        , [Parent Query] = qt.text
FROM    sys.dm_exec_query_stats qs
        CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) as qt
WHERE   qt.dbid = DB_ID()
ORDER BY [Average IO] DESC 


PRINT '=================================================================================='
PRINT 'Записи запросов SQL, которые вызывают нагрузку CPU (TOP 10)'
PRINT '=================================================================================='
SELECT TOP 10
        [Average CPU used] = total_worker_time / qs.execution_count --
        , [Total CPU used] = total_worker_time --
        , [Execution count] = qs.execution_count  --
        ,
        [Individual Query] = SUBSTRING(qt.text, qs.statement_start_offset / 2,
                                       (CASE WHEN qs.statement_end_offset = -1
                                             THEN LEN(CONVERT(NVARCHAR(MAX), qt.text)) * 2
                                             ELSE qs.statement_end_offset
                                        END - qs.statement_start_offset) / 2) --
        , [Parent Query] = qt.text
FROM    sys.dm_exec_query_stats qs
        CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) as qt
WHERE   qt.dbid = DB_ID()
ORDER BY [Average CPU used] DESC 


PRINT '=================================================================================='
PRINT 'Определение наиболее часто выполняемых запросов (TOP 10)'
PRINT '=================================================================================='
SELECT TOP 10
        [Execution count] = execution_count --
        ,
        [Individual Query] = SUBSTRING(qt.text, qs.statement_start_offset / 2,
                                       (CASE WHEN qs.statement_end_offset = -1
                                             THEN LEN(CONVERT(NVARCHAR(MAX), qt.text)) * 2
                                             ELSE qs.statement_end_offset
                                        END - qs.statement_start_offset) / 2) --
        , [Parent Query] = qt.text
FROM    sys.dm_exec_query_stats qs
        CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) as qt
WHERE   qt.dbid = DB_ID()
ORDER BY [Execution count] DESC 


PRINT '=================================================================================='
PRINT 'Определение наиболее страдающих от блокировки запросов (TOP 10)'
PRINT '=================================================================================='
SELECT TOP 10
        [Average Time Blocked] = (total_elapsed_time - total_worker_time) / qs.execution_count --
        , [Total Time Blocked] = total_elapsed_time - total_worker_time --
        , [Execution count] = qs.execution_count --
        ,
        [Individual Query] = SUBSTRING(qt.text, qs.statement_start_offset / 2,
                                       (CASE WHEN qs.statement_end_offset = -1
                                             THEN LEN(CONVERT(NVARCHAR(MAX), qt.text)) * 2
                                             ELSE qs.statement_end_offset
                                        END - qs.statement_start_offset) / 2) --
        , [Parent Query] = qt.text
FROM    sys.dm_exec_query_stats qs
        CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) as qt --AND DB_NAME(qt.dbid) = 'pnl'  -- Filter on a given database.
WHERE   qt.dbid = DB_ID()
ORDER BY [Average Time Blocked] DESC 


PRINT '=================================================================================='	
PRINT 'Определение запросов с минимальным повторным использованием планов (TOP 10)'
PRINT '=================================================================================='
SELECT TOP 10
        [Plan usage] = cp.usecounts --
        ,
        [Individual Query] = SUBSTRING(qt.text, qs.statement_start_offset / 2,
                                       (CASE WHEN qs.statement_end_offset = -1
                                             THEN LEN(CONVERT(NVARCHAR(MAX), qt.text)) * 2
                                             ELSE qs.statement_end_offset
                                        END - qs.statement_start_offset) / 2) --
        ,[Parent Query] = qt.text
FROM    sys.dm_exec_query_stats qs
        CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS qt
        JOIN sys.dm_exec_cached_plans as cp on qs.plan_handle = cp.plan_handle
WHERE   cp.plan_handle = qs.plan_handle
        AND qt.dbid = DB_ID()
ORDER BY [Plan usage] ASC


PRINT '=================================================================================='
PRINT 'Наиболее тяжелые запросы чтения (TOP 10)'
PRINT '=================================================================================='
SELECT TOP 10
        [Total Reads] = total_logical_reads --
        ,[Total Writes] = total_logical_writes --
        ,[Execution count] = qs.execution_count --
        ,
        [Individual Query] = SUBSTRING(qt.text, qs.statement_start_offset / 2,
                                       (CASE WHEN qs.statement_end_offset = -1
                                             THEN LEN(CONVERT(NVARCHAR(MAX), qt.text)) * 2
                                             ELSE qs.statement_end_offset
                                        END - qs.statement_start_offset) / 2) --
        ,[Parent Query] = qt.text
FROM    sys.dm_exec_query_stats qs
        CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) as qt
WHERE   qt.dbid = DB_ID()
ORDER BY [Total Reads] DESC


PRINT '=================================================================================='
PRINT 'Наиболее тяжелые запросы записи (TOP 10)'
PRINT '=================================================================================='
SELECT TOP 10
        [Total Writes] = total_logical_writes --
        ,[Total Reads] = total_logical_reads --
        ,[Execution count] = qs.execution_count,
        [Individual Query] = SUBSTRING(qt.text, qs.statement_start_offset / 2,
                                       (CASE WHEN qs.statement_end_offset = -1
                                             THEN LEN(CONVERT(NVARCHAR(MAX), qt.text)) * 2
                                             ELSE qs.statement_end_offset
                                        END - qs.statement_start_offset) / 2) --
        ,[Parent Query] = qt.text
FROM    sys.dm_exec_query_stats qs
        CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) as qt
WHERE   qt.dbid = DB_ID()
ORDER BY [Total Writes] DESC


-- MIGHT BE USEFUL
/*


/* ALTERNATIVE. */
SELECT 'Identify what indexes have a high maintenance cost.' AS [Step];
/* Purpose: Identify what indexes have a high maintenance cost. */
/* Notes : 1. This version shows writes per read, another version shows total updates without reads. */
SELECT 	TOP 10
		DatabaseName = DB_NAME()
		,TableName = OBJECT_NAME(s.[object_id])
		,IndexName = i.name
		,[Writes per read (User)] = user_updates / CASE WHEN (user_seeks + user_scans + user_lookups) = 0 
															THEN 1 
													   ELSE (user_seeks + user_scans + user_lookups) 
												   END 
		,[User writes] = user_updates
		,[User reads] = user_seeks + user_scans + user_lookups
		,[System writes] = system_updates
		,[System reads] = system_seeks + system_scans + system_lookups
		-- Useful fields below:
		--, *
FROM   sys.dm_db_index_usage_stats s 
		, sys.indexes i 
WHERE   s.[object_id] = i.[object_id] 
    AND s.index_id = i.index_id 
    AND s.database_id = DB_ID()
    AND OBJECTPROPERTY(s.[object_id], 'IsMsShipped') = 0
ORDER BY [Writes per read (User)] DESC;


-- Most reused queries...
SELECT TOP 10 
		[Run count] = usecounts
		,[Query] = text
		,DatabaseName = DB_NAME(qt.dbid)
		,*
FROM sys.dm_exec_cached_plans cp
CROSS APPLY sys.dm_exec_sql_text(cp.plan_handle) as qt
--AND DB_NAME(qt.dbid) = 'pnl'  -- Filter on a given database.
ORDER BY 1 DESC;

-- The below does not give the same values as previosu step, maybe related to 
-- individual qry within the parent qry? 
SELECT TOP 10 
		[Run count] = usecounts
        ,[Individual Query] = SUBSTRING (qt.text,qs.statement_start_offset/2, 
         (CASE WHEN qs.statement_end_offset = -1 
			THEN LEN(CONVERT(NVARCHAR(MAX), qt.text)) * 2 
          ELSE qs.statement_end_offset END - qs.statement_start_offset)/2)
		,[Parent Query] = qt.text
		,DatabaseName = DB_NAME(qt.dbid)
		,*
FROM sys.dm_exec_cached_plans cp
INNER JOIN sys.dm_exec_query_stats qs ON cp.plan_handle = qs.plan_handle
CROSS APPLY sys.dm_exec_sql_text(cp.plan_handle) as qt
--AND DB_NAME(qt.dbid) = 'pnl'  -- Filter on a given database.
ORDER BY 1 DESC;

*/


go
GRANT EXECUTE ON sp_query_info TO TetraUsers