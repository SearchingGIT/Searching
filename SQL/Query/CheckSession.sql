DECLARE @Sender_id int,
@Recipient_id int,
@Ann_id int;

SELECT 
@Sender_id=30
,@Recipient_id=null
,@Ann_id=11;  

SELECT sl.Session_id FROM SubscribeList_Session s1 JOIN SubscribeList_Session s2 ON s1.Session_id = s2.Session_id JOIN SessionList sl
 ON s1.Session_id = sl.Session_id
  WHERE ( s1.User_id = @Sender_id 
  AND ( s2.User_id = @Recipient_id 
  OR (s1.User_id = @Recipient_id 
  AND s2.User_id = @Sender_id 
  AND s1.User_id != s2.User_id 
  AND s1.Session_id != s2.Session_id) ) 
  AND @Ann_id IS NULL  ) OR (s1.User_id = @Sender_id 
  AND sl.Announcing_id = @Ann_id) 
