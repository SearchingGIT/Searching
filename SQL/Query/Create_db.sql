
DROP TABLE Selected_Announcing
go

DROP TABLE Favorite_Announcing
go

DROP TABLE Selected_User
go

DROP TABLE Photo_Categories
go

DROP TABLE Photo_Announcing
go

DROP TABLE Photo_UserList
go

DROP TABLE MessageList
go

DROP TABLE Message_Status
go

DROP TABLE SubscribeList_Session
go

DROP TABLE SessionList
go

DROP TABLE Announcing
go

DROP TABLE AreasOfCity
go

DROP TABLE Categories
go

DROP TABLE Session_Type
go

DROP TABLE UserList
go

DROP TABLE Cities
go

DROP TABLE Country
go

CREATE TABLE Announcing
( 
	Announcing_id        int IDENTITY ( 1,1 ) ,
	Name_Announcing      varchar(256)  NOT NULL ,
	Phone_Announcing     int  NULL ,
	Date_Announcing      date  NOT NULL ,
	Info_Announcing      varchar(max)  NOT NULL ,
	Categories_id        tinyint  NOT NULL ,
	User_id              int  NOT NULL ,
	City_id              int  NOT NULL ,
	Areas_id             int  NULL 
)
go

ALTER TABLE Announcing
	ADD  PRIMARY KEY  CLUSTERED (Announcing_id ASC)
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

CREATE TABLE AreasOfCity
( 
	Areas_id             int IDENTITY ( 1,1 ) ,
	Areas_name           varchar(256)  NOT NULL ,
	City_id              int  NOT NULL 
)
go

ALTER TABLE AreasOfCity
	ADD  PRIMARY KEY  CLUSTERED (Areas_id ASC)
go

CREATE UNIQUE NONCLUSTERED INDEX AK1_AreasOfCity ON AreasOfCity
( 
	Areas_name            ASC
)
go

Revoke all on AreasOfCity to public
go



grant select, insert, delete, update on AreasOfCity to public
go

CREATE TABLE Categories
( 
	Categories_id        tinyint IDENTITY ( 1,1 ) ,
	Name_Category        varchar(256)  NOT NULL ,
	Info_Category        varchar(max)  NOT NULL 
)
go

ALTER TABLE Categories
	ADD  PRIMARY KEY  CLUSTERED (Categories_id ASC)
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

CREATE TABLE Cities
( 
	City_id              int IDENTITY ( 1,1 ) ,
	City_name            varchar(256)  NOT NULL ,
	Country_id           int  NOT NULL 
)
go

ALTER TABLE Cities
	ADD  PRIMARY KEY  CLUSTERED (City_id ASC)
go

CREATE UNIQUE NONCLUSTERED INDEX AK1_Cities ON Cities
( 
	City_name             ASC
)
go

Revoke all on Cities to public
go



grant select, insert, delete, update on Cities to public
go

CREATE TABLE Country
( 
	Country_id           int IDENTITY ( 1,1 ) ,
	Name_country         varchar(256)  NOT NULL 
)
go

ALTER TABLE Country
	ADD  PRIMARY KEY  CLUSTERED (Country_id ASC)
go

CREATE UNIQUE NONCLUSTERED INDEX AK1_Country ON Country
( 
	Name_country          ASC
)
go

Revoke all on Country to public
go



grant select, insert, delete, update on Country to public
go

CREATE TABLE Favorite_Announcing
( 
	id                   int IDENTITY ( 1,1 ) ,
	Announcing_id        int  NOT NULL ,
	User_id              int  NOT NULL 
)
go

ALTER TABLE Favorite_Announcing
	ADD  PRIMARY KEY  CLUSTERED (id ASC)
go

CREATE UNIQUE NONCLUSTERED INDEX AK1_Favorite_Announcing ON Favorite_Announcing
( 
	Announcing_id         ASC,
	User_id               ASC
)
go

Revoke all on Favorite_Announcing to public
go



grant select, insert, delete, update on Favorite_Announcing to public
go

CREATE TABLE Message_Status
( 
	Status_id            tinyint  NOT NULL ,
	Status_name          varchar(256)  NOT NULL 
)
go

ALTER TABLE Message_Status
	ADD  PRIMARY KEY  CLUSTERED (Status_id ASC)
go

CREATE UNIQUE NONCLUSTERED INDEX AK1_Message_Status ON Message_Status
( 
	Status_name           ASC
)
go

Revoke all on Message_Status to public
go



grant select, insert, delete, update on Message_Status to public
go

CREATE TABLE MessageList
( 
	Message_id           int IDENTITY ( 1,1 ) ,
	Date_message         datetime2(0)  NOT NULL ,
	Message              varchar(256)  NOT NULL ,
	Sender_id            int  NOT NULL ,
	Status_id            tinyint  NOT NULL ,
	Session_id           int  NOT NULL ,
	Date_send            datetime2(0)  NULL 
)
go

ALTER TABLE MessageList
	ADD  PRIMARY KEY  CLUSTERED (Message_id ASC)
go

Revoke all on MessageList to public
go



grant select, insert, delete, update on MessageList to public
go

CREATE TABLE Photo_Announcing
( 
	Announcing_id        int  NOT NULL ,
	Photo_announcing     varbinary(max)  NOT NULL 
)
go

ALTER TABLE Photo_Announcing
	ADD  PRIMARY KEY  CLUSTERED (Announcing_id ASC)
go

Revoke all on Photo_Announcing to public
go



grant select, insert, delete, update on Photo_Announcing to public
go

CREATE TABLE Photo_Categories
( 
	Categories_id        tinyint  NOT NULL ,
	Photo_category       varbinary(max)  NOT NULL 
)
go

ALTER TABLE Photo_Categories
	ADD  PRIMARY KEY  CLUSTERED (Categories_id ASC)
go

Revoke all on Photo_Categories to public
go



grant select, insert, delete, update on Photo_Categories to public
go

CREATE TABLE Photo_UserList
( 
	Photo_id             int IDENTITY ( 1,1 ) ,
	User_id              int  NOT NULL ,
	Photo_userList       varbinary(max)  NOT NULL 
)
go

ALTER TABLE Photo_UserList
	ADD  PRIMARY KEY  CLUSTERED (Photo_id ASC)
go

Revoke all on Photo_UserList to public
go



grant select, insert, delete, update on Photo_UserList to public
go

CREATE TABLE Selected_Announcing
( 
	id                   int IDENTITY ( 1,1 ) ,
	Announcing_id        int  NOT NULL ,
	User_id              int  NOT NULL 
)
go

ALTER TABLE Selected_Announcing
	ADD  PRIMARY KEY  CLUSTERED (id ASC)
go

CREATE UNIQUE NONCLUSTERED INDEX AK1_Selected_Announcing ON Selected_Announcing
( 
	Announcing_id         ASC,
	User_id               ASC
)
go

Revoke all on Selected_Announcing to public
go



grant select, insert, delete, update on Selected_Announcing to public
go

CREATE TABLE Selected_User
( 
	id                   int IDENTITY ( 1,1 ) ,
	User_id              int  NOT NULL ,
	Selected_user        int  NOT NULL 
)
go

ALTER TABLE Selected_User
	ADD  PRIMARY KEY  CLUSTERED (id ASC)
go

CREATE UNIQUE NONCLUSTERED INDEX AK1_Selected_User ON Selected_User
( 
	Selected_user         ASC,
	User_id               ASC
)
go

Revoke all on Selected_User to public
go



grant select, insert, delete, update on Selected_User to public
go

CREATE TABLE Session_Type
( 
	Type_id              tinyint  NOT NULL ,
	Session_Name         varchar(256)  NOT NULL 
)
go

ALTER TABLE Session_Type
	ADD  PRIMARY KEY  CLUSTERED (Type_id ASC)
go

CREATE UNIQUE NONCLUSTERED INDEX AK1_Session_Type ON Session_Type
( 
	Session_Name          ASC
)
go

Revoke all on Session_Type to public
go



grant select, insert, delete, update on Session_Type to public
go

CREATE TABLE SessionList
( 
	Session_id           int IDENTITY ( 1,1 ) ,
	Owner_id             int  NOT NULL ,
	Type_id              tinyint  NOT NULL ,
	Announcing_id        int  NULL 
)
go

ALTER TABLE SessionList
	ADD  PRIMARY KEY  CLUSTERED (Session_id ASC)
go

CREATE UNIQUE NONCLUSTERED INDEX AK1_SessionList ON SessionList
( 
	Announcing_id         ASC,
	Owner_id              ASC
)
go

Revoke all on SessionList to public
go



grant select, insert, delete, update on SessionList to public
go

CREATE TABLE SubscribeList_Session
( 
	id                   int IDENTITY ( 1,1 ) ,
	Session_id           int  NOT NULL ,
	User_id              int  NOT NULL 
)
go

ALTER TABLE SubscribeList_Session
	ADD  PRIMARY KEY  CLUSTERED (id ASC)
go

CREATE UNIQUE NONCLUSTERED INDEX AK1_SubscribeList_Session ON SubscribeList_Session
( 
	Session_id            ASC,
	User_id               ASC
)
go

Revoke all on SubscribeList_Session to public
go



CREATE TABLE UserList
( 
	User_id              int IDENTITY ( 1,1 ) ,
	Mail                 varchar(256)  NOT NULL ,
	Phone                varchar(256)  NULL ,
	Gender_user          char(1)  NULL ,
	Date_Bearthday       date  NULL ,
	Password             varchar(4000)  NULL ,
	Info                 varchar(max)  NULL ,
	Country_id           int  NULL ,
	Type_login           tinyint  NOT NULL ,
	City_id              int  NULL ,
	Name                 varchar(256)  NOT NULL ,
	LastName             varchar(256)  NOT NULL 
)
go

ALTER TABLE UserList
	ADD  PRIMARY KEY  CLUSTERED (User_id ASC)
go

CREATE UNIQUE NONCLUSTERED INDEX AK1_UserList ON UserList
( 
	Mail                  ASC,
	Phone                 ASC
)
go

Revoke all on UserList to public
go



grant select, insert, delete, update on UserList to public
go


ALTER TABLE Announcing
	ADD  FOREIGN KEY (Categories_id) REFERENCES Categories(Categories_id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
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


ALTER TABLE AreasOfCity
	ADD  FOREIGN KEY (City_id) REFERENCES Cities(City_id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go


ALTER TABLE Cities
	ADD  FOREIGN KEY (Country_id) REFERENCES Country(Country_id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go


ALTER TABLE Favorite_Announcing
	ADD  FOREIGN KEY (Announcing_id) REFERENCES Announcing(Announcing_id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE Favorite_Announcing
	ADD  FOREIGN KEY (User_id) REFERENCES UserList(User_id)
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


ALTER TABLE Photo_Announcing
	ADD  FOREIGN KEY (Announcing_id) REFERENCES Announcing(Announcing_id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go


ALTER TABLE Photo_Categories
	ADD  FOREIGN KEY (Categories_id) REFERENCES Categories(Categories_id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go


ALTER TABLE Photo_UserList
	ADD  FOREIGN KEY (User_id) REFERENCES UserList(User_id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go


ALTER TABLE Selected_Announcing
	ADD  FOREIGN KEY (Announcing_id) REFERENCES Announcing(Announcing_id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE Selected_Announcing
	ADD  FOREIGN KEY (User_id) REFERENCES UserList(User_id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go


ALTER TABLE Selected_User
	ADD  FOREIGN KEY (User_id) REFERENCES UserList(User_id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE Selected_User
	ADD  FOREIGN KEY (Selected_user) REFERENCES UserList(User_id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go


ALTER TABLE SessionList
	ADD  FOREIGN KEY (Owner_id) REFERENCES UserList(User_id)
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


ALTER TABLE SubscribeList_Session
	ADD  FOREIGN KEY (Session_id) REFERENCES SessionList(Session_id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE SubscribeList_Session
	ADD  FOREIGN KEY (User_id) REFERENCES UserList(User_id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go


ALTER TABLE UserList
	ADD  FOREIGN KEY (Country_id) REFERENCES Country(Country_id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE UserList
	ADD  FOREIGN KEY (City_id) REFERENCES Cities(City_id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go
