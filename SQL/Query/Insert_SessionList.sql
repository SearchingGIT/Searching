DECLARE @Sender_id int
,@Recipient_id int
,@Ann_id int;

SELECT 
@Sender_id=1
,@Recipient_id=20
,@Ann_id=null;

INSERT INTO SessionList(Sender_id,Recipient_id,Announcing_id,Type_id)
VALUES(@Sender_id,@Recipient_id,@Ann_id,2)