DECLARE @City_id INT,
@Category_id INT,
@Gender_user VARCHAR,
@MinDateBirthday DATETIME,
@MaxDateBirthday DATETIME,
@Dt_Announcing DATETIME,
@nPage INT,
@sizePage INT,
@Areas_id INT;

SELECT @nPage=2,
@sizePage=4;

WITH ObjectList AS(
                      SELECT a.Info_Announcing
                            ,a.DT_Announcing
                            ,a.User_id
                            ,a.Announcing_id
                            ,a.Name_Announcing
                            ,u.Name
                            ,u.LastName
                            ,ROW_NUMBER() OVER(ORDER BY a.Announcing_id) AS Row_id
                      FROM   Announcing a
                             JOIN Cities c
                                  ON  c.City_id = a.City_id
                             JOIN [UserList] u
                                  ON  u.[User_id] = a.[User_id]
                      WHERE  a.City_id = ISNULL(@City_id, a.City_id)
                             AND (@Areas_id IS NULL OR a.Areas_id = @Areas_id)
                             AND a.Category_id = ISNULL(@Category_id, a.Category_id)
                             AND u.Gender_user = ISNULL(@Gender_user, u.Gender_user)
                             AND u.Date_Birthday BETWEEN ISNULL(@MinDateBirthday, u.Date_Birthday) AND ISNULL(@MaxDateBirthday, u.Date_Birthday)
                             AND a.Dt_Announcing >= ISNULL(@Dt_Announcing, a.Dt_Announcing)
                  )
SELECT *
FROM   ObjectList
WHERE  Row_id BETWEEN((@nPage - 1) * @sizePage + 1) AND(@nPage * @sizePage)