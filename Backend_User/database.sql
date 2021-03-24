CREATE DATABASE sysdb;

CREATE TABLE Role(
id BIGSERIAL,
role BIGINT PRIMARY KEY
);

CREATE TABLE Users(
id BIGSERIAL ,
id_user VARCHAR(100) NOT NULL PRIMARY KEY,
name VARCHAR(50) NOT NULL,
role BIGINT REFERENCES Role(role)
);

CREATE TABLE Url(
id_url SERIAL PRIMARY KEY,
uid VARCHAR(100) REFERENCES Users(id_user),
link text NOT NULL,
lat DOUBLE PRECISION,
long DOUBLE PRECISION
);



INSERT INTO Role(role) VALUES ('1');
INSERT INTO Role(Role) VALUES ('2');
 
 
 INSERT INTO Users(uid,name,role) VALUES ('usr25622','Le Ba Thong','1');
 INSERT INTO Users(uid,name,role) VALUES ('usr25623','Cao Xuan Nghia','2');



insert into Url (uid, link, lat, long) values ('foOByhqWdeOhowUa7qjC7KQSjy22', 'http://dummyimage.com/164x228.jpg/dddddd/000000', -16.0437784, 17.4488071);
insert into Url (uid, link, lat, long) values ('foOByhqWdeOhowUa7qjC7KQSjy22', 'http://dummyimage.com/159x198.jpg/5fa2dd/ffffff', 5.5864963, 53.5866599);
insert into Url (uid, link, lat, long) values ('foOByhqWdeOhowUa7qjC7KQSjy22', 'http://dummyimage.com/174x240.jpg/ff4444/ffffff', 13.6730341, 43.3986916);
insert into Url (uid, link, lat, long) values ('foOByhqWdeOhowUa7qjC7KQSjy22', 'http://dummyimage.com/216x159.jpg/5fa2dd/ffffff', 0.355636, 17.372649);
insert into Url (uid, link, lat, long) values ('foOByhqWdeOhowUa7qjC7KQSjy22', 'http://dummyimage.com/238x248.jpg/cc0000/ffffff', 22.691253, 35.8042947);
insert into Url (uid, link, lat, long) values ('foOByhqWdeOhowUa7qjC7KQSjy22', 'http://dummyimage.com/233x214.jpg/dddddd/000000', 49.6617919, 10.2683199);
insert into Url (uid, link, lat, long) values ('foOByhqWdeOhowUa7qjC7KQSjy22', 'http://dummyimage.com/225x170.jpg/5fa2dd/ffffff', 50.3566891, 14.7342524);
insert into Url (uid, link, lat, long) values ('foOByhqWdeOhowUa7qjC7KQSjy22', 'http://dummyimage.com/138x240.jpg/5fa2dd/ffffff', 56.658933, 52.5557638);
insert into Url (uid, link, lat, long) values ('foOByhqWdeOhowUa7qjC7KQSjy22', 'http://dummyimage.com/138x218.jpg/ff4444/ffffff', -7.0448067, 34.7390267);
insert into Url (uid, link, lat, long) values ('foOByhqWdeOhowUa7qjC7KQSjy22', 'http://dummyimage.com/209x140.jpg/dddddd/000000', 54.24052, 49.5318094);

DELETE FROM Users
WHERE role = '1';

UPDATE Users
SET role = '2' 
WHERE id = ??;
