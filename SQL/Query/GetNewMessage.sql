DECLARE @User_id int
,@Status_id int;


select @User_id=30,
@Status_id=2;

SELECT * 
FROM SessionList sl
JOIN MessageList ml
ON sl.Session_id=ml.Session_id
where @User_id in(sl.Sender_id,sl.Recipient_id) and @User_id !=ml.Sender_id and ml.Status_id=@Status_id