
execute sp_rename 'Chat', 'MessageList', 'OBJECT'
go

execute sp_rename 'MessageList.User_id', 'Sender_id', 'COLUMN'
go

execute sp_rename 'MessageList.Chat_id', 'Message_id', 'COLUMN'
go

--ALTER TABLE Announcing
--DROP CONSTRAINT R_2998
--go

--ALTER TABLE Announcing
--DROP CONSTRAINT R_2999
--go

--ALTER TABLE Announcing
--DROP CONSTRAINT R_3000
--go

--ALTER TABLE Selected_Announcing
--DROP CONSTRAINT R_2962
--go

--ALTER TABLE Favorite_Announcing
--DROP CONSTRAINT R_2964
--go

--ALTER TABLE Photo_Announcing
--DROP CONSTRAINT R_3003
--go

--ALTER TABLE Announcing
--DROP CONSTRAINT R_2956
--go

--ALTER TABLE Photo_Categories
--DROP CONSTRAINT R_3002
--go

--ALTER TABLE Chat
--DROP CONSTRAINT R_3005
--go

--ALTER TABLE Announcing
--DROP CONSTRAINT PK_Announcing
--go

--ALTER TABLE Categories
--DROP CONSTRAINT PK_Categories
--go

--ALTER TABLE Photo_Categories
--DROP CONSTRAINT PK_Photo_Categories
--go

--ALTER TABLE MessageList
--DROP CONSTRAINT PK_MessageList
--go

execute sp_rename 'Announcing', 'Announcing07AD0602004'
go

execute sp_rename 'Categories', 'Categories07AD0602003'
go

execute sp_rename 'Photo_Categories', 'Photo_Categories07AD0602005'
go

ALTER TABLE MessageList
ADD Status_id  tinyint  NOT NULL
go

ALTER TABLE MessageList
ADD Session_id  int  NOT NULL
go

ALTER TABLE MessageList
ADD Date_send  datetime2(0)  NULL
go

drop Table Announcing 

CREATE TABLE Announcing
( 
	Announcing_id        int IDENTITY ( 1,1 ) ,
	Name_Announcing      varchar(256)  NOT NULL ,
	Phone_Announcing     int  NULL ,
	Date_Announcing      date  NOT NULL ,
	Info_Announcing      varchar(8000)  NOT NULL ,
	Categories_id        tinyint  NOT NULL ,
	User_id              int  NOT NULL ,
	City_id              int  NOT NULL ,
	Areas_id             int  NULL 
)
go

CREATE UNIQUE NONCLUSTERED INDEX AK1_Announcing ON Announcing
( 
	Info_Announcing       ASC,
	Name_Announcing       ASC,
	User_id               ASC
)
go

Revoke all on Announcing to public
go



grant select, insert, delete, update on Announcing to public
go

CREATE TABLE Categories
( 
	Categories_id        tinyint IDENTITY ( 1,1 ) ,
	Name_Category        varchar(256)  NOT NULL ,
	Info_Category        varchar(max)  NOT NULL 
)
go

CREATE UNIQUE NONCLUSTERED INDEX AK1_Categories ON Categories
( 
	Name_Category         ASC
)
go

Revoke all on Categories to public
go



grant select, insert, delete, update on Categories to public
go

CREATE TABLE Message_Status
( 
	Status_id            tinyint  NOT NULL ,
	Status_name          varchar(256)  NOT NULL 
)
go

CREATE UNIQUE NONCLUSTERED INDEX AK1_Message_Status ON Message_Status
( 
	Status_name           ASC
)
go

Revoke all on Message_Status to public
go



CREATE TABLE Photo_Categories
( 
	Categories_id        tinyint  NOT NULL ,
	Photo_category       varbinary(max)  NOT NULL 
)
go

Revoke all on Photo_Categories to public
go



CREATE TABLE Session_Type
( 
	Type_id              tinyint  NOT NULL ,
	Session_Name         varchar(256)  NOT NULL 
)
go

CREATE UNIQUE NONCLUSTERED INDEX AK1_Session_Type ON Session_Type
( 
	Session_Name          ASC
)
go

Revoke all on Session_Type to public
go



CREATE TABLE SessionList
( 
	Session_id           int IDENTITY ( 1,1 ) ,
	Sender_id            int  NOT NULL ,
	Recipient_id         int  NULL ,
	Type_id              tinyint  NOT NULL ,
	Announcing_id        int  NULL 
)
go

CREATE UNIQUE NONCLUSTERED INDEX AK1_SessionList ON SessionList
( 
	Recipient_id          ASC,
	Announcing_id         ASC,
	Sender_id             ASC
)
go

Revoke all on SessionList to public
go



ALTER TABLE Announcing
ADD  PRIMARY KEY  CLUSTERED (Announcing_id ASC)
go


SET IDENTITY_INSERT Announcing ON
INSERT INTO Announcing (Announcing_id, Name_Announcing, Phone_Announcing, Date_Announcing, Info_Announcing, Categories_id, User_id, City_id, Areas_id) SELECT Announcing_id, Name_Announcing, Phone_Announcing, Date_Announcing, Info_Announcing, Categories_id, User_id, City_id, Areas_id FROM Announcing07AD0602004
SET IDENTITY_INSERT Announcing OFF
go

ALTER TABLE Categories
ADD  PRIMARY KEY  CLUSTERED (Categories_id ASC)
go


SET IDENTITY_INSERT Categories ON
INSERT INTO Categories (Categories_id, Name_Category, Info_Category) SELECT Categories_id, Name_Category, Info_Category FROM Categories07AD0602003
SET IDENTITY_INSERT Categories OFF
go

ALTER TABLE Message_Status
ADD  PRIMARY KEY  CLUSTERED (Status_id ASC)
go

ALTER TABLE Photo_Categories
ADD  PRIMARY KEY  CLUSTERED (Categories_id ASC)
go


INSERT INTO Photo_Categories (Categories_id, Photo_category) SELECT Categories_id, Photo_category FROM Photo_Categories07AD0602005

go

ALTER TABLE Session_Type
ADD  PRIMARY KEY  CLUSTERED (Type_id ASC)
go

ALTER TABLE SessionList
ADD  PRIMARY KEY  CLUSTERED (Session_id ASC)
go

ALTER TABLE MessageList
ADD  PRIMARY KEY  CLUSTERED (Message_id ASC)
go

ALTER TABLE Announcing
	ADD  FOREIGN KEY (User_id) REFERENCES UserList(User_id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE Announcing
	ADD  FOREIGN KEY (City_id) REFERENCES Cities(City_id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE Announcing
	ADD  FOREIGN KEY (Areas_id) REFERENCES AreasOfCity(Areas_id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE Selected_Announcing
	ADD  FOREIGN KEY (Announcing_id) REFERENCES Announcing(Announcing_id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE Favorite_Announcing
	ADD  FOREIGN KEY (Announcing_id) REFERENCES Announcing(Announcing_id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE Photo_Announcing
	ADD  FOREIGN KEY (Announcing_id) REFERENCES Announcing(Announcing_id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE Announcing
	ADD  FOREIGN KEY (Categories_id) REFERENCES Categories(Categories_id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE Photo_Categories
	ADD  FOREIGN KEY (Categories_id) REFERENCES Categories(Categories_id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE SessionList
	ADD  FOREIGN KEY (Sender_id) REFERENCES UserList(User_id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE SessionList
	ADD  FOREIGN KEY (Recipient_id) REFERENCES UserList(User_id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE SessionList
	ADD  FOREIGN KEY (Type_id) REFERENCES Session_Type(Type_id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE SessionList
	ADD  FOREIGN KEY (Announcing_id) REFERENCES Announcing(Announcing_id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE MessageList
	ADD  FOREIGN KEY (Sender_id) REFERENCES UserList(User_id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE MessageList
	ADD  FOREIGN KEY (Status_id) REFERENCES Message_Status(Status_id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE MessageList
	ADD  FOREIGN KEY (Session_id) REFERENCES SessionList(Session_id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go


DROP TABLE Announcing07AD0602004
go


DROP TABLE Categories07AD0602003
go


DROP TABLE Photo_Categories07AD0602005
go
