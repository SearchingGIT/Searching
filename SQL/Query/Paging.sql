DECLARE @nPage             INT
        ,@sizePage         SMALLINT
        ,@Categories_id     INT


-- ������ �������� � ����� ��������

SELECT @nPage = 2
      ,@sizePage         = 5
      ,@Categories_id     = 1;

-- ������� �������

SELECT m.*
      ,ROW_NUMBER() OVER(ORDER BY  m.Announcing_id) AS Row_id
FROM   Announcing m
where (m.Categories_id =@Categories_id or @Categories_id is NULL)

-- ������� � ������������ ���������
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

 