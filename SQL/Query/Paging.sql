DECLARE @nPage             INT
        ,@sizePage         SMALLINT
        ,@Categories_id     INT


-- Размер страницы и номер страницы

SELECT @nPage = 2
      ,@sizePage         = 5
      ,@Categories_id     = 1;

-- Обычный вариант

SELECT m.*
      ,ROW_NUMBER() OVER(ORDER BY  m.Announcing_id) AS Row_id
FROM   Announcing m
where (m.Categories_id =@Categories_id or @Categories_id is NULL)

-- Вариант с постраничной загрузкой
;

WITH ObjectList AS(
SELECT m.*
      ,ROW_NUMBER() OVER(ORDER BY  m.Announcing_id) AS Row_id
FROM   Announcing m
where (m.Categories_id =@Categories_id or @Categories_id is NULL)
)

SELECT *
FROM   ObjectList
WHERE  Row_id BETWEEN ((@nPage -1) * @sizePage + 1) AND (@nPage * @sizePage)

 