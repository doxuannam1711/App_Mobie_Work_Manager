create database app_work_mangement
go
use app_work_mangement
go




------<><><><><><><><><><><><><><><><><><><><><>CREATE TABLE DATABASE<><><><><><><><><><><><><><><><><><><><><><><><>--------------
--
-- Cấu trúc bảng cho bảng roles
--
CREATE TABLE  roles  (
RoleID  int IDENTITY(1,1) NOT NULL,
Role  nvarchar(50) NOT NULL,
Permissions  nvarchar(50) ,
Role_User nvarchar(50),
Permission_Role  nvarchar(50) ,
CONSTRAINT PK_roles PRIMARY KEY(RoleID),
)

--
-- Cấu trúc bảng cho bảng users
--
CREATE TABLE  users  (
UserID  int IDENTITY(1,1) NOT NULL,
Username  varchar(50) NOT NULL,
Fullname  nvarchar(255) NOT NULL,
Password  varchar(100) NOT NULL,
Email  varchar(255) NOT NULL,
AvatarUrl  varchar(255),
CreatedDate  datetime ,
LastLoginTime  datetime ,
CONSTRAINT PK_users PRIMARY KEY(UserID),
)

--
-- Cấu trúc bảng cho bảng boards
--
CREATE TABLE boards (
BoardID int IDENTITY(1,1) NOT NULL,
BoardName nvarchar(50) NOT NULL,
CreatedDate datetime NOT NULL,
UserID int NOT NULL,
RoleID int,
Labels  nvarchar(250)  ,
LabelsColor nvarchar(250)  ,
CONSTRAINT PK_boards PRIMARY KEY(BoardID),
CONSTRAINT FK_boards_users FOREIGN KEY(UserID) REFERENCES users(UserID) ,
CONSTRAINT FK_boards_roles FOREIGN KEY(RoleID) REFERENCES roles(RoleID),
)

--
-- Cấu trúc bảng cho bảng  lists
--
CREATE TABLE  lists  (
ListID  int IDENTITY(1,1) NOT NULL,
BoardID  int  NOT NULL,
ListName  nvarchar(255) NOT NULL,
Position  int  ,
Closed  bit  ,
DateCreated  datetime ,
DateLastActivity  datetime ,
DateArchived  datetime  ,
Subscribed  bit  ,
CONSTRAINT PK_lists PRIMARY KEY(ListID),
CONSTRAINT FK_lists_boards FOREIGN KEY(BoardID)REFERENCES Boards(BoardID)
)

--
-- Cấu trúc bảng cho bảng  creators
--
CREATE TABLE  creators  (
CreatorID  int IDENTITY(1,1) NOT NULL,
UserID  int  NOT NULL,
ListID  int ,
BoardID  int ,
CONSTRAINT PK_creators PRIMARY KEY(CreatorID),
CONSTRAINT FK_creators_users FOREIGN KEY(UserID) REFERENCES users(UserID),
CONSTRAINT FK_creators_lists FOREIGN KEY(ListID) REFERENCES lists(ListID),
CONSTRAINT FK_creators_boards FOREIGN KEY(BoardID) REFERENCES boards(BoardID),
)

--
-- Cấu trúc bảng cho bảng  AsignedTo
--
CREATE TABLE  assignedTo (
AssignedToID  int IDENTITY(1,1) NOT NULL,
UserID  int  NOT NULL,
ListID  int ,
BoardID  int ,
CONSTRAINT PK_assignedTo PRIMARY KEY(AssignedToID),
CONSTRAINT FK_asignedTo_users FOREIGN KEY(UserID) REFERENCES users(UserID),
CONSTRAINT FK_asignedTo_lists FOREIGN KEY(ListID) REFERENCES lists(ListID),
CONSTRAINT FK_asignedTo_boards FOREIGN KEY(BoardID) REFERENCES boards(BoardID),
)

--
-- Cấu trúc bảng cho bảng  cards
--
CREATE TABLE  cards  (
CardID  int IDENTITY(1,1) NOT NULL,
ListID  int  NOT NULL,
AssignedToID  int,
CreatorID  int,
Checklist int ,
Label  nvarchar(255)  ,
Comment  int,
CardName  nvarchar(255) NOT NULL,
StatusView  nvarchar(255)  ,
CreatedDate  datetime,
StartDate date ,
DueDate  date,
Attachment  nvarchar(max)  ,
Description  nvarchar(255)  ,
Activity  nvarchar(255),
IntCheckList int,
LabelColor nvarchar(10),
CONSTRAINT PK_cards PRIMARY KEY(CardID),
CONSTRAINT FK_cards_lists FOREIGN KEY(ListID) REFERENCES lists(ListID),
)

--
-- Cấu trúc bảng cho bảng  attachments
--
CREATE TABLE  attachments(
AttachmentID int IDENTITY(1,1) NOT NULL,
CardID int NOT NULL,
AttachmentPath nvarchar(max),
AttachmentName nvarchar(max),
CONSTRAINT PK_attachments PRIMARY KEY(AttachmentID),
CONSTRAINT FK_attachments_cards FOREIGN KEY(CardID) REFERENCES cards(CardID),

)

--
-- Cấu trúc bảng cho bảng  comments
--
CREATE TABLE  comments  (
CommentID  int IDENTITY(1,1) NOT NULL,
UserID  int  NOT NULL,
CardID  int  NOT NULL,
Detail  nvarchar(255) NOT NULL,
CONSTRAINT PK_comments PRIMARY KEY(CommentID),
CONSTRAINT FK_comments_users FOREIGN KEY(UserID) REFERENCES users(UserID),
CONSTRAINT FK_comments_cards FOREIGN KEY(CardID) REFERENCES cards(CardID),
)

--
-- Cấu trúc bảng cho bảng  checklists
--
CREATE TABLE  checklists  (
ChecklistID  int IDENTITY(1,1) NOT NULL,
CardID  int  NOT NULL,
ChecklistTitle nvarchar(255) NOT NULL,
Completed  bit   ,
Position  int NULL,
DateCreated  datetime NULL,
DateUpdated  datetime NULL,
DateCompleted  datetime,
CONSTRAINT PK_checklists PRIMARY KEY(ChecklistID),
CONSTRAINT FK_checklists_cards FOREIGN KEY(CardID) REFERENCES cards(CardID)
)

--
-- Cấu trúc bảng cho bảng  checklistitems
--
CREATE TABLE  checklistitems  (
ChecklistitemID  int IDENTITY(1,1) NOT NULL,
ChecklistID  int  NOT NULL,
Title  nvarchar(255) NOT NULL,
Description  nvarchar(255)  ,
DueDate  datetime  ,
Completed  bit   ,
CompletedDate  datetime  ,
CreatedDate  datetime  ,
UpdatedDate  datetime  ,
Position  int,
CONSTRAINT PK_checklistitems PRIMARY KEY(ChecklistitemID),
CONSTRAINT FK_checklistitems_checklists FOREIGN KEY(ChecklistID) REFERENCES checklists(ChecklistID)
)

--
-- Cấu trúc bảng cho bảng  notification
--
CREATE TABLE  notifications  (
NotificationID  int IDENTITY(1,1) NOT NULL,
UserID  int  NOT NULL,
NotificationType  int NOT NULL,
Title nvarchar(500),
CardID  int,
BoardID  int,
Content  nvarchar(max) NOT NULL,
CreatedDate  datetime NOT NULL,
Status bit  NOT NULL,
CONSTRAINT PK_notifications PRIMARY KEY(NotificationID),
CONSTRAINT FK_notifications_users FOREIGN KEY(UserID) REFERENCES users(UserID),
CONSTRAINT FK_notifications_cards FOREIGN KEY(CardID) REFERENCES cards(CardID),
CONSTRAINT FK_notifications_boards FOREIGN KEY(BoardID) REFERENCES boards(BoardID),
)



------<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>--------------






------<><><><><><><><><><><><><><><><><><><><><>INSERT DATA<><><><><><><><><><><><><><><><><><><><><><><><>--------------


------------------------------ Insert into table Roles --------------------------------------
insert into roles VALUES('edit','','','')
insert into roles VALUES('view','','','')

------------------------------ Insert into table Users --------------------------------------
insert into users VALUES('doxuannam',N'đỗ xuân nam','123456','doxuannam@gmail.com','https://drive.google.com/uc?export=view&id=1kFGCC0oSxUYd8u8O1sM_OlCnyNR-Rmfj','2022-01-14 21:56:19 PM','')
insert into users VALUES('phamphuquang',N'phạm phú quang','123123123','phamphuquang@gmail.com','https://drive.google.com/uc?export=view&id=11Ik67f0n7DwVCGyLai2l6ozc-sksvKxO','2022-2-2 14:48:25 PM','')
insert into users VALUES('buiduccuong',N'bùi đức cường','456456456','buiduccuong@gmail.com','https://drive.google.com/uc?export=view&id=1O7TGLfxEUIVi1Vz_Ih7qsL4eJJ6l20Ke','2022-3-8 08:45:09 AM','')
insert into users VALUES('hoangthigam',N'hoàng thị gấm','123456123456','doxuannam@gmail.com','https://drive.google.com/uc?export=view&id=17dUud_419-ksLeFF0dl3G5rclXNob5kN','2022-3-9 21:56:19 PM','')


--------------------------------------- Insert into table Boards ---------------------------------
insert into boards VALUES(N'Công việc ở công ty','2023-2-20 10:25:48 AM',1,'0',N'green',1)
insert into boards VALUES(N'Công việc ở công ty ABC','2023-3-2',3,'1',N'red',1)
insert into boards VALUES(N'Công việc làm web freelancer','2023-3-2',3,'3','blue',1)
insert into boards VALUES(N'Phân tích nghiệp vụ','2022-1-2',2,'5','yellow',1)
insert into boards VALUES(N'Dự án phong thuỷ thổ địa','2023-3-2',1,'9','red',1)
insert into boards VALUES(N'Sơ đồ chi tiết','2023-4-3',2,'2','blue',1)
insert into boards VALUES(N'Code dự án phát triển','2023-11-2',3,'1','green',1)
insert into boards VALUES(N'Công việc làm web freelancer','2023-9-25',1,'3','yellow',1)
insert into boards VALUES(N'Database hoàn chỉnh','2023-5-20',2,'0','red',1)
insert into boards VALUES(N'Dự án công trình dưỡng lão','2023-7-11',1,'3','green',1)
insert into boards VALUES(N'Phân tích quá trình giảm đau','2023-8-3',2,'0','blue',1)

------------------------------ Insert into table Lists --------------------------------------
insert into lists VALUES(1,N'Website bán hàng',1,'false','2023-2-20','2023-3-1','','true')
insert into lists VALUES(1,N'Website quản lý đất đai',2,'false','2023-2-20','2023-3-1','','true')
insert into lists VALUES(1,N'Làm app quản lý công việc cá nhân',3,'false','2023-2-20','2023-3-1','','true')
insert into lists VALUES(2,N'Phần mềm quản lý nhân viên',4,'false','2023-2-20','2023-3-1','','true')
insert into lists VALUES(3,N'Thiết kế giao diện quản lý điểm trường học',5,'false','2023-2-20','2023-3-1','','true')

------------------------------ Insert into table Creators --------------------------------------
insert into creators VALUES(1,1,1)
insert into creators VALUES(2,2,1)
insert into creators VALUES(3,3,1)

------------------------------ Insert into table AssignedTo --------------------------------------
insert into assignedTo VALUES(1,1,1)
insert into assignedTo VALUES(2,1,1)
insert into assignedTo VALUES(3,1,1)

------------------------------ Insert into table Cards --------------------------------------
insert into cards VALUES(1,3,1,5,'Medium',3,N'FrontEnd','','2023-2-20 11:00:50 AM','2023-2-28','2023-3-5 3:30 PM','','','',3,'red')
insert into cards VALUES(1,3,1,9,'Low',2,N'Create Database','','2023-2-20 11:00:50 AM','2023-2-28','2023-3-5 3:30 PM','','','',5,'green')
insert into cards VALUES(1,3,1,5,'High',1,N'Create WebAPI','','2023-2-20 11:00:50 AM','2023-2-28','2023-3-5 3:30 PM','','','',3,'red')
insert into cards VALUES(1,3,1,1,'High',4,N'BackEnd','','2023-2-20 11:00:50 AM','2023-2-28','2023-3-5 3:30 PM','','','',4,'yellow')
insert into cards VALUES(2,3,2,3,'Medium',5,N'Nghiệp vụ','','2023-2-28 11:00:50 AM','2023-3-28','2023-5-5 3:30 PM','','','',3,'red')
insert into cards VALUES(2,1,2,4,'Low',11,N'Dữ liệu cũ','','2023-5-20 11:00:50 AM','2023-5-28','2023-7-5 3:30 PM','','','',5,'green')
insert into cards VALUES(2,1,3,5,'High',2,N'Dữ liệu mới','','2023-7-20 11:00:50 AM','2023-7-28','2023-9-5 3:30 PM','','','',3,'blue')
insert into cards VALUES(2,3,2,7,'High',3,N'Code lỗi','','2023-10-20 11:00:50 AM','2023-10-28','2023-12-5 3:30 PM','','','',2,'yellow')
insert into cards VALUES(3,3,1,11,'Medium',8,N'Yêu cầu khách hàng','','2023-2-28 11:00:50 AM','2023-3-28','2023-5-5 3:30 PM','','','',2,'blue')
insert into cards VALUES(3,3,1,23,'Low',9,N'Cố gắng mà sửa','','2023-5-20 11:00:50 AM','2023-5-28','2023-7-5 3:30 PM','','','',1,'blue')
insert into cards VALUES(3,3,1,2,'High',11,N'Lỗi tồn đọng','','2023-11-20 11:00:50 AM','2023-11-28','2024-2-5 3:30 PM','','','',1,'blue')
insert into cards VALUES(3,3,1,9,'High',23,N'Khẩn cấp vá lỗi nhanh!','','2023-10-20 11:00:50 AM','2023-10-28','2024-2-5 3:30 PM','','','',1,'red')
insert into cards VALUES(4,2,3,10,'Medium',34,N'Dữ liệu chưa đủ','','2023-2-28 11:00:50 AM','2023-3-28','2023-5-5 3:30 PM','','','',1,'blue')
insert into cards VALUES(4,2,3,11,'Low',45,N'Cường em làm chỗ này đi','','2023-5-20 11:00:50 AM','2023-5-28','2023-7-5 3:30 PM','','','',1,'blue')
insert into cards VALUES(4,2,3,12,'High',5,N'Phân việc của Nam','','2023-7-20 11:00:50 AM','2023-7-28','2023-9-5 3:30 PM','','','',1,'yellow')
insert into cards VALUES(4,1,3,13,'High',3,N'Mọi người tập trung kết quả','','2023-10-20 11:00:50 AM','2023-10-28','2023-12-5 3:30 PM','','','',1,'blue')
insert into cards VALUES(5,3,1,7,'Medium',2,N'Vẽ trên Figma','','2023-2-28 11:00:50 AM','2023-3-28','2023-5-5 3:30 PM','','','',1,'red')
insert into cards VALUES(5,3,1,8,'Medium',3,N'Cắt giao diện','','2023-5-20 11:00:50 AM','2023-5-28','2023-7-5 3:30 PM','','','',1,'blue')

------------------------------ Insert into table comments --------------------------------------
insert into comments VALUES(1,1,N'Yêu cầu đổi lịch hết hạn')
insert into comments VALUES(2,2,N'Xem xét lại database')
insert into comments VALUES(3,3,N'Hoàn thành dự án trước ngày 2/4')
insert into comments VALUES(4,4,N'code em sửa lại r đó ạ!')
insert into comments VALUES(1,5,N'Em đã làm xong ahihi')
insert into comments VALUES(3,6,N'Có con mèo này em nghĩ là ổn đó sếp')
insert into comments VALUES(2,7,N'Bé cún chinh chinh :D')
insert into comments VALUES(4,8,N'HUHU e sẽ sửa lại ạ ')
insert into comments VALUES(3,9,N'Khách hàng hãm vcl')
insert into comments VALUES(1,10,N'E đã sửa lại một số lỗi quan trọng')
insert into comments VALUES(2,11,N'Done đã xong hoàn thành và ấn định')
insert into comments VALUES(3,12,N'Không hiểu kiểu gì lỗi này ở đâu ra dị')

------------------------------ Insert into table checklists --------------------------------------
insert into checklists VALUES('1','Danh sách việc cần làm 1','false',1,'2023-2-20 10:48:50 AM','','')
insert into checklists VALUES('1','Danh sách việc cần làm 2','false',2,'2023-2-20 10:48:50 AM','','')
insert into checklists VALUES('1','Danh sách việc cần làm 3','false',3,'2023-2-20 10:48:50 AM','','')

------------------------------ Insert into table checklistitems --------------------------------------
insert into checklistitems VALUES(1,N'Khảo sát, phân tích nghiệp vụ','','','false','','2023-2-20 10:51:50 AM','',1)
insert into checklistitems VALUES(1,N'Hoàn thành tài liệu chương 1','','','false','','2023-2-20 10:51:50 AM','',2)
insert into checklistitems VALUES(1,N'Hoàn thành tài liệu chương 2','','','false','','2023-2-20 10:51:50 AM','',3)

--------------------------------------- Insert into table notifications -----------------------------------------------
insert into notifications VALUES(1,1,N'Unread',1,1,N'hết hạn vào ngày mai','2023-3-8 09:55:21 AM','true')
insert into notifications VALUES(1,1,N'Unread',1,1,N'hết hạn vào ngày mai','2023-3-8 09:55:21 AM','true')
insert into notifications VALUES(1,1,N'Unread',1,1,N'hết hạn vào ngày mai','2023-3-8 09:55:21 AM','true')
insert into notifications VALUES(1,1,N'Unread',1,1,N'hết hạn vào ngày mai','2023-3-8 09:55:21 AM','true')
insert into notifications VALUES(2,2,N'All categories',1,1,N'đã thay đổi ngày hết hạn','2023-3-7 10:25:41 PM','false')
insert into notifications VALUES(2,2,N'All categories',1,1,N'đã thay đổi ngày hết hạn','2023-3-7 10:25:41 PM','false')
insert into notifications VALUES(2,2,N'All categories',1,1,N'đã thay đổi ngày hết hạn','2023-3-7 10:25:41 PM','false')
insert into notifications VALUES(2,2,N'All categories',1,1,N'đã thay đổi ngày hết hạn','2023-3-7 10:25:41 PM','false')
insert into notifications VALUES(3,3,N'Me',1,1,N'đã di chuyển thẻ sang','2023-3-6 11:57:10 AM','false')
insert into notifications VALUES(3,3,N'Me',1,1,N'đã di chuyển thẻ sang','2023-3-6 11:57:10 AM','false')
insert into notifications VALUES(3,3,N'Me',1,1,N'đã di chuyển thẻ sang','2023-3-6 11:57:10 AM','false')
insert into notifications VALUES(3,3,N'Me',1,1,N'đã di chuyển thẻ sang','2023-3-6 11:57:10 AM','false')
insert into notifications VALUES(3,4,N'Comment',1,1,N'đã bình luận ở thẻ','2023-3-6 11:57:10 AM','false')
insert into notifications VALUES(3,4,N'Comment',1,1,N'đã bình luận ở thẻ','2023-3-6 11:57:10 AM','false')
insert into notifications VALUES(3,4,N'Comment',1,1,N'đã bình luận ở thẻ','2023-3-6 11:57:10 AM','false')
insert into notifications VALUES(3,4,N'Comment',1,1,N'đã bình luận ở thẻ','2023-3-6 11:57:10 AM','false')
insert into notifications VALUES(4,0,N'Default',1,1,N'đã thêm thành viên vào bảng','2023-12-6 11:57:10 AM','false')
insert into notifications VALUES(4,0,N'Default',1,1,N'đã loại thành viên ở thẻ','2023-3-6 11:57:10 AM','false')
insert into notifications VALUES(4,0,N'Default',1,1,N'đã mời thêm thành viên ở bảng','2023-3-6 11:57:10 AM','false')
insert into notifications VALUES(4,0,N'Default',1,1,N'đã mời thêm thành viên ở thẻ','2023-3-6 11:57:10 AM','false')

--------------------------------------- Insert into table attachments -----------------------------------------------
insert into attachments VALUES(1,N'https://drive.google.com/uc?id=1IFsLihg2jGUF9vmjk5ox2G25atpNYqlQ&export=download','sample-docx-file-for-testing')



------<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>--------------








------<><><><><><><><><><><><><><><><><><><><><><><>TRIGGER<><><><><><><><><><><><><><><><><><><><><><><>--------------


---Add the trigger to the table---
CREATE TRIGGER trg_checklist_insert ON checklistitems
AFTER DELETE
AS
BEGIN
  DECLARE @title nvarchar(255);
  SELECT @title = N'thêm checklist ' + Title FROM inserted;
  insert into notifications VALUES(1,1,N'Unread',1,1,@title,'2023-3-8 09:55:21 AM','true')
END

CREATE TRIGGER trg_checklist_delete ON checklistitems
AFTER DELETE
AS
BEGIN
  DECLARE @title nvarchar(255);
  SELECT @title = N'xoá checklist ' + Title FROM deleted;
  insert into notifications VALUES(1,1,N'Unread',1,1,@title,'2023-3-8 09:55:21 AM','true')
END

------<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>--------------




------<><><><><><><><><><><><><><><><><><><><><><>TEST QUERY<><><><><><><><><><><><><><><><><><><><><><>--------------


ALTER TABLE cards 
ALTER  COLUMN DueDate date

ALTER TABLE cards
DROP COLUMN CompletedStatus;

ALTER TABLE cards
ADD LabelColor nchar(10)



SELECT cards.*, COUNT(checklistitems.ChecklistItemID) AS 'SUM', SUM(CASE WHEN checklistitems.Completed = 1 THEN 1 ELSE 0 END) AS 'index_checked'
FROM cards
LEFT JOIN checklists ON cards.cardID = checklists.cardID
LEFT JOIN checklistitems ON checklists.checklistID = checklistitems.checklistID
GROUP BY cards.cardID, cards.ListID, cards.AssignedToID, cards.CreatorID, cards.Checklist, 
cards.Label, cards.Comment, cards.CardName, cards.StatusView, 
cards.CreatedDate, cards.StartDate, cards.DueDate, cards.Attachment,
cards.Description, cards.Activity, cards.IntCheckList, cards.LabelColor


SELECT * from users where UserID=1


UPDATE users SET Username = 'doxuannam1711', Fullname='Đỗ Xuân Nam', Password='123456', Email='doxuannam@gmail.com' WHERE UserID = 1


select notifications.NotificationID,notifications.NotificationType,Content,notifications.CreatedDate,users.Username,boards.BoardName,cards.CardName from notifications inner join users
on notifications.UserID = users.UserID
inner join cards
on notifications.CardID=cards.CardID
inner join boards
on notifications.BoardID=boards.BoardID
inner join lists
on notifications.BoardID=lists.BoardID




SELECT DISTINCT notifications.NotificationID, notifications.NotificationType, Content, notifications.CreatedDate, users.Username, boards.BoardName, cards.CardName
FROM notifications
INNER JOIN users ON notifications.UserID = users.UserID
INNER JOIN cards ON notifications.CardID = cards.CardID
INNER JOIN boards ON notifications.BoardID = boards.BoardID
INNER JOIN lists ON notifications.BoardID = lists.BoardID
ORDER BY notifications.NotificationID DESC;

DELETE FROM notifications WHERE NotificationID = 29;

ALTER TABLE
  users
ALTER COLUMN RoleID  int;
    

INSERT INTO users (Username, Fullname, Password, Email)
VALUES ('tt', 'era', 'sdfaaas', 'dfasde')

SELECT * from users where users.UserID = 1


select users.UserID, users.AvatarUrl, users.Fullname, comments.Detail, comments.CommentID from users inner join comments
on users.UserID = comments.UserID
where comments.CardID=1
order by comments.CommentID Desc

INSERT INTO comments (UserID, CardID, Detail)
VALUES (2, 2, 'Mong code không lỗi')

DELETE FROM comments WHERE CommentID = 16

UPDATE comments SET Detail = 'alo test userID = 2' WHERE CommentID = 23 AND UserID= 1

SELECT * from lists inner join cards on cards.ListID = lists.ListID
where BoardID = 1 

select * from boards where UserID = 1

select * from attachments
where attachments.CardID= 1 order by attachments.AttachmentID DESC

DELETE FROM attachments WHERE AttachmentID = 2


Delete from lists where ListID IN (39);
Delete from cards where CardID IN (33);
Delete from users where UserID IN (15,16);
DBCC CHECKIDENT ('users', RESEED, 14);


------<><><><><><><><><><><><><><><><><><><><><><>Chỉnh sửa cấu trúc database<><><><><><><><><><><><><><><><><><><><><><>--------------
alter table users drop constraint FK_users_roles
ALTER TABLE users
DROP COLUMN RoleID;

ALTER TABLE boards
ADD RoleID int

ALTER TABLE boards
ADD CONSTRAINT FK_boards_roles FOREIGN KEY (RoleID) REFERENCES roles(RoleID);

------<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><<><><><><><><><><><><><><><><><><><><><><><>--------------



---------------------------ADD 21/05--------------------

CREATE TABLE members (
  id INT IDENTITY(1,1) PRIMARY KEY,
  fullname NVARCHAR(255) NOT NULL,
  Email NVARCHAR(255) NOT NULL UNIQUE, 
  AvatarUrl varchar(255),
  assignedTo INT,
);

INSERT INTO members VALUES (N'Bùi Đức Cường', 'buiduccuong@gmail.com', 'https://drive.google.com/uc?export=view&id=1O7TGLfxEUIVi1Vz_Ih7qsL4eJJ6l20Ke', 3);
INSERT INTO members VALUES (N'Phạm Phú Quang', 'phamphuquang@gmail.com', 'https://drive.google.com/uc?export=view&id=11Ik67f0n7DwVCGyLai2l6ozc-sksvKxO', 3);

-------------------------------------------TRIGGER-------------------------------------------
-------------NOTIFICATION-----------

USE [app_work_mangement]
GO
/****** Object:  Trigger [dbo].[tr_InsertNotification]    Script Date: 5/21/2023 4:24:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    ALTER TRIGGER [dbo].[tr_InsertNotification] ON [dbo].[notifications]
AFTER
INSERT
    AS BEGIN DECLARE @title NVARCHAR(MAX),
    @body NVARCHAR(MAX)
	DECLARE @http INT
SELECT
    @title = Title,
    @body = N'DoXuanNam' + Content + N' FrontEnd trong danh sách Website bán hàng ở bảng Công việc freelancer'
FROM
    inserted DECLARE @json NVARCHAR(MAX)
SET
    @json = '{ "to": "/topics/news", "notification": { "title": "' + @title + '", "body": "' + @body + '" } }' DECLARE @url NVARCHAR(MAX)
SET
    @url = 'https://fcm.googleapis.com/fcm/send' DECLARE @http_status INT EXEC sp_OACreate 'MSXML2.ServerXMLHTTP',
    @http OUT EXEC sp_OAMethod @http,
    'open',
    NULL,
    'POST',
    @url,
    'false' EXEC sp_OAMethod @http,
    'setRequestHeader',
    NULL,
    'Content-Type',
    'application/json' EXEC sp_OAMethod @http,
    'setRequestHeader',
    NULL,
    'Authorization',
    'key=AAAACDPhmRI:APA91bHqrKcJrNKCFvghaDhkl523De27PsqyfC7_cKDWJRO3Edp0B1CLh3YDv_LmcnDH-8-gXZO7iYxHzKITmyMQYPkSsYsYMhrl7Puo0SOIjkje7eljIv_VPyM86CZznFfR9Qz3JVIK' EXEC sp_OAMethod @http,
    'send',
    NULL,
    @json EXEC sp_OAGetProperty @http,
    'status',
    @http_status OUT EXEC sp_OADestroy @http PRINT 'Notification sent: ' + @title + ' - ' + @body
END 

----------------CheckList----------------------------------
------DELTE CHECKLIST----------
USE [app_work_mangement]
GO
/****** Object:  Trigger [dbo].[trg_checklist_delete]    Script Date: 5/21/2023 4:25:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[trg_checklist_delete] ON [dbo].[checklistitems]
AFTER DELETE
AS
BEGIN
  DECLARE @title nvarchar(255);
  SELECT @title = N' xoá checklist ' + Title FROM deleted;
  insert into notifications VALUES(1,1,N'Unread',1,1,@title,'2023-3-8 09:55:21 AM','true')
END
-----------INSERT CHECKLIST----------
USE [app_work_mangement]
GO
/****** Object:  Trigger [dbo].[trg_checklist_insert]    Script Date: 5/21/2023 4:25:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[trg_checklist_insert] ON [dbo].[checklistitems]
AFTER INSERT
AS
BEGIN
  DECLARE @title nvarchar(255);
  SELECT @title = N' thêm checklist ' + Title FROM inserted;
  insert into notifications VALUES(1,1,N'Unread',1,1,@title,'2023-3-8 09:55:21 AM','true')
END
----------------COMMENT------------
USE [app_work_mangement]
GO
/****** Object:  Trigger [dbo].[trg_checklist_insert]    Script Date: 5/21/2023 4:25:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[trg_comments_insert] ON [dbo].comments
AFTER INSERT
AS
BEGIN
  DECLARE @title nvarchar(255);
  SELECT @title = N'đã bình luận: ' + Detail FROM inserted;
  insert into notifications VALUES(1,1,N'Comment',1,1,@title,'2023-3-8 09:55:21 AM','true')
END

----------------TEST-------------
INSERT INTO comments VALUES (1,1,N'Cẩn thận trượt đồ án');
---------Attachments----------------
USE [app_work_mangement]
GO
/****** Object:  Trigger [dbo].[trg_checklist_insert]    Script Date: 5/21/2023 4:25:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[trg_attachments_insert] ON [dbo].attachments
AFTER INSERT
AS
BEGIN
  DECLARE @title nvarchar(255);
  SELECT @title = N'đã đính kèm tệp: ' + AttachmentName FROM inserted;
  insert into notifications VALUES(1,1,N'Comment',1,1,@title,'2023-3-8 09:55:21 AM','true')
END
----------------TEST-------------


-------------------------------------------------------------------UPDATE------------------------------------------------------
---- notification ----
USE [app_work_mangement]
GO
/****** Object:  Trigger [dbo].[tr_InsertNotification]    Script Date: 22-May-23 7:19:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    ALTER TRIGGER [dbo].[tr_InsertNotification] ON [dbo].[notifications]
AFTER
INSERT
    AS BEGIN DECLARE @title NVARCHAR(MAX),
    @body NVARCHAR(MAX)
	DECLARE @http INT
SELECT
    @title = Title,
    @body = N'DoXuanNam' + Content + N' FrontEnd trong danh sách Website bán hàng ở bảng Công việc freelancer'
FROM
    inserted DECLARE @json NVARCHAR(MAX)
SET
    @json = '{ "to": "/topics/doan", "notification": { "title": "' + @title + '", "body": "' + @body + '" } }' DECLARE @url NVARCHAR(MAX)
SET
    @url = 'https://fcm.googleapis.com/fcm/send' DECLARE @http_status INT EXEC sp_OACreate 'MSXML2.ServerXMLHTTP',
    @http OUT EXEC sp_OAMethod @http,
    'open',
    NULL,
    'POST',
    @url,
    'false' EXEC sp_OAMethod @http,
    'setRequestHeader',
    NULL,
    'Content-Type',
    'application/json' EXEC sp_OAMethod @http,
    'setRequestHeader',
    NULL,
    'Authorization',
    'key=AAAAxSfIJ_w:APA91bEAoU12d3K0wSKatVnHIzSyBTaRVXrBgJIL4eE_aeEdCg0JmVBbu3UwK7LLDGabgDk8JAs_2jWl-Ezf6MgsRdN0BtwAdzfiNaWDodxJmLBKWReRpYHFo9X8-iVxvE6in4ObsOtR' EXEC sp_OAMethod @http,
    'send',
    NULL,
    @json EXEC sp_OAGetProperty @http,
    'status',
    @http_status OUT EXEC sp_OADestroy @http PRINT 'Notification sent: ' + @title + ' - ' + @body
END 

----card---------

USE [app_work_mangement]
GO
/****** Object:  Trigger [dbo].[tr_UpdateCardNotification]    Script Date: 22-May-23 7:20:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER TRIGGER [dbo].[tr_UpdateCardNotification]
ON [dbo].[cards]
AFTER UPDATE
AS
BEGIN
    DECLARE @title NVARCHAR(MAX), @body NVARCHAR(MAX)
    DECLARE @http INT

    SELECT @title = N'Thông báo nhắc nhở',
           @body = N'Thẻ ' + inserted.CardName + N' sẽ hết hạn sau ' +
                   CAST(DATEDIFF(DAY, GETDATE(),
                                  CASE inserted.Label
                                      WHEN 'Low' THEN DATEADD(DAY, 0, inserted.DueDate)
                                      WHEN 'Medium' THEN DATEADD(DAY, 0, inserted.DueDate)
                                      WHEN 'High' THEN DATEADD(DAY, 0, inserted.DueDate)
                                      ELSE inserted.DueDate
                                  END) AS NVARCHAR(10)) + N' ngày nữa'
    FROM inserted
    WHERE (inserted.Label = 'Low' AND DATEDIFF(DAY, GETDATE(), inserted.DueDate) < 3)
          OR (inserted.Label = 'Medium' AND DATEDIFF(DAY, GETDATE(), inserted.DueDate) < 8)
          OR (inserted.Label = 'High' AND DATEDIFF(DAY, GETDATE(), inserted.DueDate) < 15)

    IF @@ROWCOUNT > 0
    BEGIN
        DECLARE @json NVARCHAR(MAX)
        SET @json = '{ "to": "/topics/doan", "notification": { "title": "' + @title + '", "body": "' + @body + '" } }'

        DECLARE @url NVARCHAR(MAX)
        SET @url = 'https://fcm.googleapis.com/fcm/send'

        DECLARE @http_status INT

        EXEC sp_OACreate 'MSXML2.ServerXMLHTTP', @http OUT
        EXEC sp_OAMethod @http, 'open', NULL, 'POST', @url, 'false'
        EXEC sp_OAMethod @http, 'setRequestHeader', NULL, 'Content-Type', 'application/json'
        EXEC sp_OAMethod @http, 'setRequestHeader', NULL, 'Authorization', 'key=AAAAxSfIJ_w:APA91bEAoU12d3K0wSKatVnHIzSyBTaRVXrBgJIL4eE_aeEdCg0JmVBbu3UwK7LLDGabgDk8JAs_2jWl-Ezf6MgsRdN0BtwAdzfiNaWDodxJmLBKWReRpYHFo9X8-iVxvE6in4ObsOtR'
        EXEC sp_OAMethod @http, 'send', NULL, @json
        EXEC sp_OAGetProperty @http, 'status', @http_status OUT
        EXEC sp_OADestroy @http

        IF @http_status = 200
        BEGIN
            PRINT 'Notification sent: ' + @title + ' - ' + @body
        END
        ELSE
        BEGIN
            PRINT 'Notification failed to send'
        END
    END
END

--- CHECKLIST ----


USE [app_work_mangement]
GO
/****** Object:  Trigger [dbo].[trg_checklist_delete]    Script Date: 22-May-23 7:21:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[trg_checklist_delete] ON [dbo].[checklistitems]
AFTER DELETE
AS
BEGIN
  DECLARE @title nvarchar(255);
  SELECT @title = N' xoá checklist ' + Title + N' ở thẻ' FROM deleted;
  insert into notifications VALUES(1,1,N'CheckList',1,1,@title,'2023-3-8 09:55:21 AM','true')
END

----comment-------------

USE [app_work_mangement]
GO
/****** Object:  Trigger [dbo].[trg_comments_insert]    Script Date: 22-May-23 7:22:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[trg_comments_insert] ON [dbo].[comments]
AFTER INSERT
AS
BEGIN
  DECLARE @title nvarchar(255);
  SELECT @title = N' đã bình luận: ' + Detail + N' ở thẻ' FROM inserted;
  insert into notifications VALUES(1,1,N'Bình Luận',1,1,@title,'2023-3-8 09:55:21 AM','true')
END

----------------------------------------QUERY DELETE EVERYTHING ABOUT USERS-------------------------------------------------------
DELETE FROM checklistitems where CardID IN (SELECT CardID from cards where ListID IN(SELECT ListID FROM lists WHERE BoardID IN (SELECT BoardID FROM boards WHERE UserID=5)))

DELETE FROM attachments where CardID IN (SELECT CardID from cards where ListID IN(SELECT ListID FROM lists WHERE BoardID IN (SELECT BoardID FROM boards WHERE UserID=5)))

delete from comments where CardID IN ( SELECT CardID from cards where ListID IN(SELECT ListID FROM lists WHERE BoardID IN(SELECT BoardID FROM boards WHERE UserID=5)))

delete from comments where UserID = 5

delete from notifications where CardID IN ( SELECT CardID from cards where ListID IN(SELECT ListID FROM lists WHERE BoardID IN(SELECT BoardID FROM boards WHERE UserID=5)))

delete from notifications where BoardID IN (SELECT BoardID FROM boards WHERE UserID=5)

delete from notifications where UserID=5

delete from creators  WHERE UserID=5

delete from assignedTo WHERE UserID=5

delete from cards where ListID IN (SELECT ListID FROM lists WHERE BoardID IN (SELECT BoardID FROM boards WHERE UserID=5))

delete from lists where BoardID IN (SELECT BoardID FROM boards where UserID=5)

delete from boards where UserID=5

delete from users where UserID=5
------------------------------------------------------------------------------------------------------------------------------

SELECT cards.*, COUNT(checklistitems.ChecklistItemID) AS 'SUM', SUM(CASE WHEN checklistitems.Completed = 1 THEN 1 ELSE 0 END) AS 'index_checked'
FROM cards 
LEFT JOIN checklists ON cards.cardID = checklists.cardID
LEFT JOIN checklistitems ON checklists.checklistID = checklistitems.checklistID
WHERE cards.ListID IN (SELECT ListID FROM lists WHERE BoardID IN (SELECT BoardID FROM boards WHERE UserID = 1))
GROUP BY cards.cardID, cards.ListID, cards.AssignedToID, cards.CreatorID, cards.Checklist, 
cards.Label, cards.Comment, cards.CardName, cards.StatusView, 
cards.CreatedDate, cards.StartDate, cards.DueDate, cards.Attachment,
cards.Description, cards.Activity, cards.IntCheckList, cards.LabelColor
ORDER BY cards.CardID DESC;

----------------------------------------CUONG UPDATE 23-05-----------------------------------------
---EDIT notifi table---
ALTER TABLE notifications
ALTER COLUMN Content nvarchar(max) NULL;
-----FIX BUGG API-----------------------
UPDATE cards SET DueDate = '2023-5-27' Where cards.CardID = 1

SELECT name
FROM sys.syslogins

GRANT EXECUTE ON sys.sp_OAMethod TO [IIS APPPOOL\DefaultAppPool];
GRANT EXECUTE ON sys.sp_OAGetProperty TO [IIS APPPOOL\DefaultAppPool];
GRANT EXECUTE ON sys.sp_OADestroy TO [IIS APPPOOL\DefaultAppPool];
----- TRIGGER---------------------------
CREATE TRIGGER [dbo].[tr_UpdateCardNotification]
ON [dbo].[cards]
AFTER UPDATE
AS
BEGIN
    DECLARE @title NVARCHAR(MAX), @body NVARCHAR(MAX)
    DECLARE @http INT

    SELECT @title = N'Thông báo nhắc nhở',
           @body = N'Thẻ ' + inserted.CardName + N' sẽ hết hạn sau ' +
                   CAST(DATEDIFF(DAY, GETDATE(),
                                  CASE inserted.Label
                                      WHEN 'Low' THEN DATEADD(DAY, 0, inserted.DueDate)
                                      WHEN 'Medium' THEN DATEADD(DAY, 0, inserted.DueDate)
                                      WHEN 'High' THEN DATEADD(DAY, 0, inserted.DueDate)
                                      ELSE inserted.DueDate
                                  END) AS NVARCHAR(10)) + N' ngày nữa'
    FROM inserted
    WHERE (inserted.Label = 'Low' AND DATEDIFF(DAY, GETDATE(), inserted.DueDate) < 3)
          OR (inserted.Label = 'Medium' AND DATEDIFF(DAY, GETDATE(), inserted.DueDate) < 8)
          OR (inserted.Label = 'High' AND DATEDIFF(DAY, GETDATE(), inserted.DueDate) < 15)

    IF @@ROWCOUNT > 0
    BEGIN
        DECLARE @json NVARCHAR(MAX)
        SET @json = '{ "to": "/topics/doan", "notification": { "title": "' + @title + '", "body": "' + @body + '" } }'

        DECLARE @url NVARCHAR(MAX)
        SET @url = 'https://fcm.googleapis.com/fcm/send'

        DECLARE @http_status INT

        EXEC sp_OACreate 'MSXML2.ServerXMLHTTP', @http OUT
        EXEC sp_OAMethod @http, 'open', NULL, 'POST', @url, 'false'
        EXEC sp_OAMethod @http, 'setRequestHeader', NULL, 'Content-Type', 'application/json'
        EXEC sp_OAMethod @http, 'setRequestHeader', NULL, 'Authorization', 'key=AAAAxSfIJ_w:APA91bEAoU12d3K0wSKatVnHIzSyBTaRVXrBgJIL4eE_aeEdCg0JmVBbu3UwK7LLDGabgDk8JAs_2jWl-Ezf6MgsRdN0BtwAdzfiNaWDodxJmLBKWReRpYHFo9X8-iVxvE6in4ObsOtR'
        EXEC sp_OAMethod @http, 'send', NULL, @json
        EXEC sp_OAGetProperty @http, 'status', @http_status OUT
        EXEC sp_OADestroy @http

        IF @http_status = 200
        BEGIN
            PRINT 'Notification sent: ' + @title + ' - ' + @body
        END
        ELSE
        BEGIN
            PRINT 'Notification failed to send'
        END
    END
END
-------------------------------------
CREATE TRIGGER [dbo].[tr_InsertNotification] ON [dbo].[notifications]
AFTER
INSERT
    AS BEGIN DECLARE @title NVARCHAR(MAX),
    @body NVARCHAR(MAX)
	DECLARE @http INT
SELECT
    @title = Title,
    @body = N'DoXuanNam' + Content + N' FrontEnd trong danh sách Website bán hàng ở bảng Công việc freelancer'
FROM
    inserted DECLARE @json NVARCHAR(MAX)
SET
    @json = '{ "to": "/topics/doan", "notification": { "title": "' + @title + '", "body": "' + @body + '" } }' DECLARE @url NVARCHAR(MAX)
SET
    @url = 'https://fcm.googleapis.com/fcm/send' DECLARE @http_status INT EXEC sp_OACreate 'MSXML2.ServerXMLHTTP',
    @http OUT EXEC sp_OAMethod @http,
    'open',
    NULL,
    'POST',
    @url,
    'false' EXEC sp_OAMethod @http,
    'setRequestHeader',
    NULL,
    'Content-Type',
    'application/json' EXEC sp_OAMethod @http,
    'setRequestHeader',
    NULL,
    'Authorization',
    'key=AAAAxSfIJ_w:APA91bEAoU12d3K0wSKatVnHIzSyBTaRVXrBgJIL4eE_aeEdCg0JmVBbu3UwK7LLDGabgDk8JAs_2jWl-Ezf6MgsRdN0BtwAdzfiNaWDodxJmLBKWReRpYHFo9X8-iVxvE6in4ObsOtR' EXEC sp_OAMethod @http,
    'send',
    NULL,
    @json EXEC sp_OAGetProperty @http,
    'status',
    @http_status OUT EXEC sp_OADestroy @http PRINT 'Notification sent: ' + @title + ' - ' + @body
END 

-----------------------------------------------------
CREATE TRIGGER [dbo].[trg_checklist_delete] ON [dbo].[checklistitems]
AFTER DELETE
AS
BEGIN
  DECLARE @title nvarchar(255);
  SELECT @title = N' xoá checklist ' + Title + N' ở thẻ' FROM deleted;
  insert into notifications VALUES(1,1,N'CheckList',1,1,@title,'2023-3-8 09:55:21 AM','true')
END
------------------------------------------------------
CREATE TRIGGER [dbo].[trg_checklistitem] ON [dbo].[checklistitems]
AFTER INSERT
AS
BEGIN
  DECLARE @title nvarchar(255);
  SELECT @title = N' đã thêm checklist: ' + Title + N' ở thẻ' FROM inserted;
  insert into notifications VALUES(1,1,N'Công việc',1,1,@title,'2023-3-8 09:55:21 AM','true')
END
-------------------------------------------------------
CREATE TRIGGER [dbo].[trg_comments_comment] ON [dbo].[comments]
AFTER INSERT
AS
BEGIN
  DECLARE @title nvarchar(255);
  SELECT @title = N' đã bình luận: ' + Detail + N' ở thẻ' FROM inserted;
  insert into notifications VALUES(1,4,N'Bình Luận',1,1,@title,'2023-3-8 09:55:21 AM','true')
END
-------------------------------------------------------
CREATE TRIGGER [dbo].[trg_attach] ON [dbo].attachments
AFTER INSERT
AS
BEGIN
  DECLARE @title nvarchar(255);
  SELECT @title = N' đã đính kèm tệp: ' + AttachmentName + N' ở thẻ' FROM inserted;
  insert into notifications VALUES(1,1,N'Thêm tệp đính kèm',1,1,@title,'2023-3-8 09:55:21 AM','true')
END
----------TEST TRIGGER --------------
insert into checklistitems VALUES(1,N'Khảo sát, phân tích nghiệp vụ 2','','','false','','2023-2-20 10:51:50 AM','',1)
insert into comments VALUES(3,12,N'Không hiểu kiểu gì lỗi này ở đâu ra dị')
insert into attachments VALUES(1,N'https://drive.google.com/uc?id=1IFsLihg2jGUF9vmjk5ox2G25atpNYqlQ&export=download','sample-docx-file-for-testing')

--------------------------------------------------------DELETE EVERYTHING ABOUT CARD---------------------------------------------------------------------------------
DELETE FROM checklistitems WHERE CardID=22

DELETE FROM comments WHERE CardID=22

DELETE FROM attachments WHERE CardID = 22

DELETE FROM notifications WHERE CardID=22

DELETE FROM cards WHERE CardID = 22

----------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------Update 26_05---------------------------------
ALTER TABLE cards
DROP CONSTRAINT FK_cards_assignedTo;
ALTER TABLE cards
DROP CONSTRAINT FK_cards_creators;
----------------------------------------QUERY DELETE EVERYTHING ABOUT BOARDS-------------------------------------------------------
DELETE FROM checklistitems WHERE CardID IN(SELECT CardID FROM cards where ListID IN(SELECT ListID FROM lists where BoardID=23))

DELETE FROM attachments where CardID IN (SELECT CardID from cards where ListID IN(SELECT ListID FROM lists WHERE BoardID =23))

delete from comments where CardID IN ( SELECT CardID from cards where ListID IN(SELECT ListID FROM lists WHERE BoardID =23 ))

delete from notifications where CardID IN ( SELECT CardID from cards where ListID IN(SELECT ListID FROM lists WHERE BoardID = 23))

delete from notifications where BoardID= 6

delete from creators  WHERE BoardID=23

delete from assignedTo WHERE BoardID=23

delete from cards where ListID IN (SELECT ListID FROM lists WHERE BoardID = 23)

delete from lists where BoardID = 23

DELETE FROM boards WHERE BoardID = 23
----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------UPDATE 27/05 --------------------------------------------------------------------
---------- comments table ----------------
ALTER TRIGGER [dbo].[trg_comments_comment] ON [dbo].[comments]
AFTER INSERT
AS
BEGIN
  DECLARE @UserID INT, @CardID INT, @title NVARCHAR(255), @Detail NVARCHAR(255);
  
  SELECT @UserID = UserID, @CardID = CardID, @Detail = Detail FROM inserted;
  
  SELECT @title =  N' đã bình luận: ' + @Detail + N' ở thẻ ' ;
  
  INSERT INTO notifications VALUES (@UserID, 4, N'Bình Luận', @CardID, 1, @title, GETDATE(), 'true');
END

-------------- attachment table ----------------------
ALTER TRIGGER [dbo].[trg_attach] ON [dbo].[attachments]
AFTER INSERT
AS
BEGIN
  DECLARE @UserID INT, @CardID INT, @title NVARCHAR(255), @Detail NVARCHAR(255);
  
  SELECT @CardID = CardID, @Detail = AttachmentName FROM inserted;
  
  SELECT @title =  N' đính kèm tệp: ' + @Detail +  N' ở thẻ ' ;
  
  INSERT INTO notifications VALUES (1, 5, N'Bình Luận', @CardID, 1, @title, GETDATE(), 'true');
END

-------------- checklist table --------------------------
GO
ALTER TRIGGER [dbo].[trg_checklistitem] ON [dbo].[checklistitems]
AFTER INSERT
AS
BEGIN
  DECLARE @UserID INT, @CardID INT, @title NVARCHAR(255), @Detail NVARCHAR(255);
  
  SELECT @Detail = Title FROM inserted;
  
  SELECT @title =  N' đã thêm CheckList: ' + @Detail +  N' ở thẻ ' ;
  
  INSERT INTO notifications VALUES (1, 6, N'CheckList', 1, 1, @title, GETDATE(), 'true');
END
--------------- notitication table ----------------------
ALTER TRIGGER [dbo].[tr_InsertNotification] ON [dbo].[notifications]
AFTER
INSERT
    AS BEGIN DECLARE @title NVARCHAR(MAX),
    @body NVARCHAR(MAX)
	DECLARE @http INT
SELECT
    @title = Title,
    @body = (SELECT TOP 1 users.Fullname from users INNER JOIN notifications on notifications.UserID = users.UserID where users.UserID = notifications.UserID) + Content + (SELECT TOP 1 cards.CardName from cards INNER JOIN notifications on notifications.CardID = cards.CardID where cards.CardID = notifications.CardID) 
FROM
    inserted DECLARE @json NVARCHAR(MAX)
SET
    @json = '{ "to": "/topics/doan", "notification": { "title": "' + @title + '", "body": "' + @body + '" } }' DECLARE @url NVARCHAR(MAX)
SET
    @url = 'https://fcm.googleapis.com/fcm/send' DECLARE @http_status INT EXEC sp_OACreate 'MSXML2.ServerXMLHTTP',
    @http OUT EXEC sp_OAMethod @http,
    'open',
    NULL,
    'POST',
    @url,
    'false' EXEC sp_OAMethod @http,
    'setRequestHeader',
    NULL,
    'Content-Type',
    'application/json' EXEC sp_OAMethod @http,
    'setRequestHeader',
    NULL,
    'Authorization',
    'key=AAAAxSfIJ_w:APA91bEAoU12d3K0wSKatVnHIzSyBTaRVXrBgJIL4eE_aeEdCg0JmVBbu3UwK7LLDGabgDk8JAs_2jWl-Ezf6MgsRdN0BtwAdzfiNaWDodxJmLBKWReRpYHFo9X8-iVxvE6in4ObsOtR' EXEC sp_OAMethod @http,
    'send',
    NULL,
    @json EXEC sp_OAGetProperty @http,
    'status',
    @http_status OUT EXEC sp_OADestroy @http PRINT 'Notification sent: ' + @title + ' - ' + @body
END 

----------------------------------------UPDATE 29/5 -------------------------------

DROP TABLE checklistitems
DROP TABLE checklists

CREATE TABLE  checklistitems  (
ChecklistitemID  int IDENTITY(1,1) NOT NULL,
CardID  int  NOT NULL,
Title  nvarchar(255) NOT NULL,
Completed  bit NULL,

CONSTRAINT PK_checklistitems PRIMARY KEY(ChecklistitemID),
CONSTRAINT FK_cards FOREIGN KEY(CardID) REFERENCES cards(CardID)
)


INSERT into checklistitems values(4,'t5',1)
SELECT * FROM boards WHERE BoardName LIKE '%' + @Keyword + '%'
---- SQL TEST ( SAVED ) --------------------------------------
SELECT *, COUNT(comments.Detail) AS 'index_comment' FROM lists
LEFT JOIN cards ON lists.ListID = cards.ListID
LEFT JOIN comments ON comments.cardID = cards.cardID
WHERE lists.BoardID = 1
            GROUP BY cards.cardID, cards.ListID, cards.AssignedToID, cards.CreatorID, cards.Checklist, 
            cards.Label, cards.Comment, cards.CardName, cards.StatusView, 
            cards.CreatedDate, cards.StartDate, cards.DueDate, cards.Attachment,
            cards.Description, cards.Activity, cards.IntCheckList, cards.LabelColor, lists.BoardID, lists.Closed, lists.DateArchived, lists.DateCreated, lists.DateLastActivity,
			lists.ListID, lists.ListName, lists.Position, lists.Subscribed, comments.CommentID, comments.CardID, comments.Detail, comments.UserID

SELECT lists.*,cards.* FROM lists
INNER JOIN cards ON lists.ListID = cards.ListID
LEFT JOIN comments ON comments.cardID = cards.cardID
WHERE lists.BoardID = 1
            GROUP BY cards.cardID, cards.ListID, cards.AssignedToID, cards.CreatorID, cards.Checklist, 
            cards.Label, cards.Comment, cards.CardName, cards.StatusView, 
            cards.CreatedDate, cards.StartDate, cards.DueDate, cards.Attachment,
            cards.Description, cards.Activity, cards.IntCheckList, cards.LabelColor, lists.BoardID, lists.Closed, lists.DateArchived, lists.DateCreated, lists.DateLastActivity,
			lists.ListID, lists.ListName, lists.Position, lists.Subscribed, comments.CommentID, comments.CardID, comments.Detail
SELECT cards.*,COUNT(comments.Detail) AS 'index_comment', COUNT(checklistitems.ChecklistItemID) AS 'SUM', SUM(CASE WHEN checklistitems.Completed = 1 THEN 1 ELSE 0 END) AS 'index_checked'
FROM cards
LEFT JOIN checklistitems ON checklistitems.CardID = cards.CardID
WHERE LOWER(CardName) LIKE '%' + @Keyword + '%' and cards.ListID IN (SELECT ListID FROM lists WHERE BoardID IN (SELECT BoardID FROM boards WHERE UserID = @UserID))
GROUP BY cards.cardID, cards.ListID, cards.AssignedToID, cards.CreatorID, cards.Checklist, 
cards.Label, cards.Comment, cards.CardName, cards.StatusView, 
cards.CreatedDate, cards.StartDate, cards.DueDate, cards.Attachment,
cards.Description, cards.Activity, cards.IntCheckList, cards.LabelColor
ORDER BY cards.CardID DESC;

SELECT cards.*,COUNT(comments.Detail) AS 'index_comment', COUNT(checklistitems.ChecklistItemID) AS 'SUM', SUM(CASE WHEN checklistitems.Completed = 1 THEN 1 ELSE 0 END) AS 'index_checked'
            FROM cards 
            LEFT JOIN checklistitems ON checklistitems.cardID = cards.cardID
			LEFT JOIN comments ON comments.cardID = cards.cardID
WHERE LOWER(CardName) LIKE '%' + @Keyword + '%' and cards.ListID IN (SELECT ListID FROM lists WHERE BoardID IN (SELECT BoardID FROM boards WHERE UserID = @UserID))
            GROUP BY cards.cardID, cards.ListID, cards.AssignedToID, cards.CreatorID, cards.Checklist, 
            cards.Label, cards.Comment, cards.CardName, cards.StatusView, 
            cards.CreatedDate, cards.StartDate, cards.DueDate, cards.Attachment,
            cards.Description, cards.Activity, cards.IntCheckList, cards.LabelColor
            ORDER BY cards.CardID DESC;

SELECT * FROM checklistitems WHERE LOWER(checklistitems.Title) LIKE '%' + 't' + '%'
--------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------- UPDATE 30/05 -------------------------------------------------------------------------
Update notifications SET
Status = 0 Where notifications.NotificationID = 1
--------------------
CREATE TRIGGER [dbo].[trg_checklistitem] ON [dbo].[checklistitems]
AFTER INSERT
AS
BEGIN
  DECLARE @title nvarchar(255);
  SELECT @title = N' đã thêm checklist: ' + Title + N' ở thẻ ' FROM inserted;
  insert into notifications VALUES(1,6,N'Công việc',1,1,@title,'2023-3-8 09:55:21 AM',0)
END
------------------------------
CREATE TRIGGER [dbo].[trg_members] ON [dbo].[members]
AFTER INSERT
AS
BEGIN
  DECLARE @title nvarchar(255);
  SELECT @title = N' đã thêm thành viên mới: ' + fullname + N' ở thẻ ' FROM inserted;
  insert into notifications VALUES(1,1,N'Thẻ Công Việc',1,1,@title,'2023-3-8 09:55:21 AM',0)
END

----------TEST TRIGGER --------------
insert into checklistitems VALUES(4,N'Khảo sát c',0)
insert into members VALUES(N'bui van ba','dsd1s@gmail.com','',3)

