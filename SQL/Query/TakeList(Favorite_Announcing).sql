DECLARE @User_ID INT

SELECT a.Announcing_id, a.Name_Announcing, a.Phone_Announcing, a.Areas_id, a.Date_Announcing, a.Info_Announcing, 
       a.Categories_id
FROM   Selected_Announcing fa
       JOIN Announcing a
            ON  a.Announcing_id = fa.Announcing_id
WHERE  fa.[User_id] = @User_ID
