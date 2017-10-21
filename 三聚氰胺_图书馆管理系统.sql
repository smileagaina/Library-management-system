
--创建数据库（图书馆系统）

create database librarysystem
ON
(
	NAME=librarysystem,
	FILENAME='d:\librarysystem.mdf',--文件地址不同
	SIZE=10,
	MAXSIZE=50,
	FILEGROWTH=5
)
LOG ON
(
	NAME='library',
	FILENAME='d:\librarysystem.ldf',--文件地址
	SIZE=5MB,
	MAXSIZE=25MB
)
GO

use librarysystem
go


-------------------------------------------------------------------
--创建表


--1.创建员工 架构HumanResources
create schema HumanResources  
go



--创建表（员工）
/*
员工编号
中文姓名
英文姓名
住址
职位
联系方式（可能有多个）
加入日期
离职日期


*/
create table HumanResources.Employee
(
	EmployeeID varchar(30) not null primary key,
	ChName varchar(30)  null ,
	EnName varchar(30)not null ,
	Address varchar(30) not null ,
	Post varchar(30) not null,
	JoinDate datetime not null,
	DepartureDate datetime null
)
go


--(多个联系方式)表，通过EmployeeID与Employee联系
create table HumanResources.EmpContact
(
	EmployeeID varchar(30) not null primary key,
	Contact1 varchar(30) not null check(Contact1 like'1[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),--可换成chrule规则
	Contact2 varchar(30)  check(Contact2 like'1[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	Contact3 varchar(30)  check(Contact3 like'1[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	Contact4 varchar(30) check(Contact4 like'1[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
	Foreign key (EmployeeID) references HumanResources.Employee(EmployeeID)
)

go






--创建表(管理员)
/*
员工编号
登录账号
登录密码
*/

create table HumanResources.Administrators
(
    EmployeeID varchar(30) not null primary key,
	LandAccount varchar(30) not null unique,
	LandPassword varchar(30) not null,
	foreign key (EmployeeID) references HumanResources.Employee(EmployeeID)
)
go



--2.创建架构books 使图书信息在同一架构下
create schema books
go 



--创建表（图书类别表）储存图书类别信息
create table books.Categories
(
    CategoriesID int  constraint PK_CategoriesID check(CategoriesID between 0and 9) primary key,  --类别号
	BookStyle varchar(30) not null  --类别名称
)
go 


--创建表(图书领域)，存储图书领域信息
create table books.Field
(
    FieldID  varchar(30) constraint PK_FieldID check(FieldID like '[A-Z][0-9]') primary key,  --领域编号
	FieldName varchar(30) not null,--领域名称
	FieldDescription varchar(30)  not null , --领域描述 原来是FieldNo
) 
go





--创建表(图书存放位置信息)
/*		
图书编号起始编号		
图书编号借书编号		
存放区域编号
*/

create table books.BookLocations
(	 
     BookBorrowNo int  not null  ,
	 BookStartNo varchar(30) not null primary key,
	 BookStoreNo varchar(30) not null,
)
go



		--创建表(出入库信息)
/*
图书编号
出入库日期
出入库数量
*/

create table books.BookInOut
( 
	BookID varchar(30) not null primary key , 
	BookInDate datetime not null,
	BookOutDate datetime null,
	BookInCount int not null,
	BookOutCount int null,
)
go







/*创建表(图书信息),存储图书详细信息,
包括图书编号、图书名称、作者、类别、领域（名称）、出版社、单价、
入库时间、图书总量、在馆数量，图书封面图片，介绍
*/

create table books.BookDetails
(
	BookID varchar(30)  primary key, --图书编号
	BookName varchar(30) not null,   --图书名称
	Author varchar(30)  not null,    --作者
	CategoriesID int   not null ,--图书类别
	FieldID varchar(30) not null ,--领域（名称）
	BookPub varchar(30) not null,        --出版社
	UnitPrice decimal(10,5) not null,--单价
	BookInDate datetime not null,    --入库时间
	BookTotal int not null,          --图书总量
	BookInCount int not null,        --在馆数量
	BookCoverPic varbinary(max) null,--图书封面图片--cast ('D:\Emp_photo\Emp101.jpg'as varbinary(max)),
	BookIntroduce varchar(50) null	,    --介绍
	foreign key (CategoriesID) references books.Categories(CategoriesID),--前面外键，后面主键
	foreign key (FieldID) references books.Field(FieldID),
    foreign key (BookID) references books.BookLocations(BookStartNo),
	foreign key(BookID) references  books.BookInOut(BookID)
)
go 

	--创建全文索引
create  fulltext catalog MyCatalog as default

create unique index Uidx_BookID on books.BookDetails(BookID)
create fulltext index on books.BookDetails(BookName) 
key index Uidx_BookID
alter fulltext index on books.BookDetails
start full population
go


--创建表（图书历史表）
/*
图书编号 
图书名称
作者
类别
领域
出版社
单价
删除日期
*/

create table books.BookHistory
(    
	BookID varchar(30) not null primary key,
    BookName varchar(30) not null  ,
	Author varchar(30) not null ,
	CategoriesID varchar(30) not null,
	FieldNo varchar(30) not null ,
	BookPub varchar(30) null,
	UnitPrice decimal(10,5)  null,
	DropDate datetime  null 
)
go

--3.创建用户架构 Users
create schema Users
go



--创建表（用户）
/*
借书卡编号
用户名称
证件类型
身份证号或护照号
出生日期
联系电话
家庭住址
已借数量
*/
create table users.UserDetailes
(
	LibarayCardID varchar(30) not null primary key,
	UserName varchar(30) not null,
	DocumentType varchar(30) not null,
	PaperNum varchar(30) not null unique check ( len(PaperNum)=18 or len(PaperNum)= 9),
	BirthDate datetime not null ,
	Phone varchar(30) not null check(Phone like'1[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),--可换成chrule规则
	[Address] varchar(30) not null,
	BorrowedCount int not null check( BorrowedCount <= 5)
)
go

--4创建罚金架构Penalty


create schema Penalty
go


--创建罚金表
/*
借书卡编号
图书编号
罚款天数
罚款金额
罚款原因
*/



create table Penalty.PenaltyDetails
(
	LibarayCardID varchar(30)not null primary key ,
	BookID varchar(30) not null,
	PenaltyNumDays int not null,
	PenaltyMoney money not null , 
	PenaltyReason varchar(30) not null,
	foreign key(LibarayCardID) references users.UserDetailes(LibarayCardID)
)
go


--创建表（借书信息）
/*借书卡编号
图书编号
借书日期
还书日期
*/

create table Users.BorrowDetails
(
    LibarayCardID varchar(30) not null primary key,
	BookID varchar(30) not null unique ,
	BorrowDate datetime not null ,
	RepayDate datetime null,
	foreign key (BookID) references books.BookDetails(BookID),
	foreign key(LibarayCardID) references Users.UserDetailes(LibarayCardID)
)
go





--------------------------------------------------------------------------
--插入数据

--向员工表中插入信息
--select * from HumanResources.Employee

insert into HumanResources.Employee values
('40701','李明','Joseph','杭州','Administrator','2011-05-24',null),
('40702','王聪','David','北京','worker','2006-06-02','2015-01-24'),
('40703','周通','Aaron','上海','Administrator','2003-05-02',null),
('40704','刘晓','mango','杭州','cleaner','2014-01-03','2005-8-11'),
('40705','赵琦','Devin','北京','Administrator','2008-01-02','2008-11-7'),
('40706','吴军','Mikdde','上海','manager','2007-05-02',null)
go



--向管理员表中插入信息
insert into HumanResources.Administrators values
('40703','350463471','346123'),
('40702','350461583','583725'),
('40701','350462769','273957')
go




--向图书类别表插入数据
--类别名称：期刊,字典,图书,报纸

insert into books.Categories values
('0','期刊'),
('1','字典'),
('2','图书'),
('3','报纸')
go


--向图书领域插入数据
--经典著作、哲学类、社会科学、政治法律、军事科学
-- FieldID  int constraint PK_FieldID check(FieldID like '[A-Z][0-9][0-9]') primary key,、
--FieldName varchar(30) null,--领域名称
--FieldDescription varchar(30)  not null , --领域描述 原来是FieldNo

insert into books.Field  values
('A1','经典著作','中西方图书'),--领域编号,领域名称,领域描述
('B2','哲学类','伟人哲学'),
('C3','社会科学','共同关注'),
('D4','政治法律','刑法民法'),
('E5','军事科学','科技前沿'),
('F6','工程技术','土木工程'),
('G7','语言技能','小语种'),
('H8','人文艺术','文艺复兴')
go







--向存放信息表(Books.Locations)插入数据
 

insert into books.BookLocations values
(1,'201506130001','A'),
(2,'201506130002','B'),
(3,'201506130003','C'),
(4,'201506130004','D'),
(5,'201506130005','E'),
(6,'201506130006','F')

--向出入库表插入信息
insert into books.BookInOut values
('201506130001','2015-06-01','2016-07-01',100,50),
('201506130002','2015-05-02','2016-07-02',200,100),
('201506130003','2015-04-03','2016-07-03',500,400),
('201506130004','2015-07-04','2016-08-04',1000,200),
('201506130005','2015-08-05','2016-09-05',2000,200),
('201506130006','2015-06-06','2016-08-06',200,100)
go


----向图书信息(books.BookDetails)表插入数据

insert into books.BookDetails values
('201506130001','文艺风赏','笛安','0','A1','长江文艺出版社',16.8,'2015-02-01',200,100,cast ('G:\SQL\SQL项目课上\dictionary.jpg'as varbinary(max)),'期刊类最小说文艺作品'),
('201506130002','计算机组成原理','王爱英','2','B2','清华大学出版社',56.2,'2003-11-15',20,13,null,'图书类计算机知识相关'),
('201506130003','数据库原理','萨师煊','2','C3','高等教育出版社',65.3,'2007-07-02',2,2,null,'计算机类数据库知识'),
('201506130004','C程序设计','谭浩强','2','D4','清华大学出版社',59.9,'2002-04-02',50,23,null,'计算机类程序语言指导'),
('201506130005','新编大学英语','应慧兰','2','E5','外研社',34.9,'2002-11-12',50,23,null,'英语课本'),
('201506130006','新编汉语字典','汉语字典编写组','1','F6','中文社',65.9,'2015-6-21',50,40,null,'汉语字典')
go


--向用户表中插入信息
insert into users.UserDetailes values
('Lib000001','科比','身份证','370825196902276918','1986-01-01','13589652369','青岛','3'),
('Lib000002','詹姆斯','身份证','371254198702054459','1987-02-05','13586578369','青岛','5'),
('Lib000003','杜兰特','身份证','370215199605057894','1996-05-05','13589895369','青岛','2'),
('Lib000004','库里','身份证','381548199912068879','1999-12-06','13589147369','青岛','1'),
('Lib000005','欧文','身份证','380245198811074526','1988-11-07','13589652585','青岛','0')
go





--向罚金表中插入信息
insert into Penalty.PenaltyDetails values
('Lib000001','201506130004',7,10,'4个月未还'),
('Lib000002','201506130001',14,10,'5个月没还'),
('Lib000003','201506130002',14,10,'5个月没还')
go



--向借书表插入信息
insert into Users.BorrowDetails values
('Lib000001','201506130001','2015-07-01','2015-10-09'),
('Lib000002','201506130002','2015-08-01','2015-09-01'),
('Lib000003','201506130003','2015-10-12','2015-10-30'),
('Lib000004','201506130004','2015-12-10','2016-03-01'),
('Lib000005','201506130005','2015-12-30','2016-03-30')
go




------------------------------------------------------------------------------------
--实现查询

--------------------User Report Requirements用户报告需求好（图书信息）: 
--1查看个人账户信息 
create procedure accountInform_pro 
as
select *from users.UserDetailes

exec accountInform_pro 

drop proc accountInform_pro 
--2查看个人图书借阅信息
create proc borrowInfromdetailes @name varchar(20) 
as
select *from Users.BorrowDetails a join users.UserDetailes b 
on a.LibarayCardID = b.LibarayCardID where b.UserName=@name
go

exec borrowInfromdetailes '科比'



--3查看包含书名包含特定文字的图书的信息 
create proc findBook_pro @word varchar(20) 
as 
select * from books.BookDetails 
where BookName like '%'+@word+'%'
go

exec findBook_pro '风'



--4查看指定领域的图书的信息 
select *
from books.Field
where FieldID='B2'

create proc findBookField_pro @word varchar(20) 
as 
select * from books.BookDetails 
where FieldID = (select FieldID from books.Field where FieldID=@word)
go


exec findBookField_pro 'A1'

drop proc findBookField_pro

--5查看指定类别的图书的信息 
create proc findBookCatego_pro @word varchar(20) 
as 
select * from books.BookDetails 
where CategoriesID = (select CategoriesID from books.Categories where CategoriesID=@word)
go

exec findBookCatego_pro '0'

drop proc findBookCatego_pro

/*
--6 查看指定出版年份的图书的信息 
create proc findBookDate_pro @datetime datetime 
as
select * from books.BookDetails where BookInDate=@datetime
go

exec proc findBookDate_pro ''
*/
--7 查看指定作者的图书的信息  
create proc findBookAuthor @author varchar(20) as
select * from books.BookDetails where Author=@author
go

exec findBookAuthor '谭浩强'

--8查询介绍包含指定关键字的图书的信息（提供不精确查找和精确查找，且优化查询效率） 


select BookName from books.BookDetails where freetext(BookName,'C程序')
select BookName from books.BookDetails where contains(BookName,'新编')

--9查看指定图书的在馆数量
create proc bookSumByName @name varchar(20) 
as
select BookTotal from books.BookDetails  
where BookName=@name
go


exec bookSumByName '新编大学英语'

--10查询单价最高的书籍的信息 

select top 1 * from books.BookDetails 
order by UnitPrice desc
go


--11查看在馆数量小于 3的图书的信息 

select * from books.BookDetails 
where BookTotal<3
go

--12查看每领域每类别图书对应的书籍数量 
create proc eachfield_eachcat_pro @FieldName varchar(30),@BookStyle varchar(30)
as
select BookTotal 
from books.BookDetails 
where FieldID = (
                select FieldID 
                from books.Field 
		        where FieldName = @FieldName
			     ) 
	  and CategoriesID = (
			                select CategoriesID 
							from books.Categories 
							where BookStyle=@BookStyle
				          )

go



exec eachfield_eachcat_pro '经典著作','期刊'




-----------------------------------用户报告需求(罚金，借书信息,图书出入库数量)

--1查看指定用户的借书信息
create proc user_pro @name varchar(20) 
as
select * from users.UserDetailes 
where UserName=@name
go

exec  user_pro '科比'



--2查看指定用户的罚金信息，并按照罚金金额降序排序
create proc informationendpenalty @name varchar(30)
as
select * from 
	penalty.PenaltyDetails 
where 
	LibarayCardID = (select LibarayCardID from users.UserDetailes where UserName = @name ) 
order by PenaltyMoney desc 
go

exec informationendpenalty '科比'
exec informationendpenalty '詹姆斯'


drop  proc informationendpenalty

--3查看所有用户的罚金信息，并进行排名，罚金最高的排名第一，罚金相同的排名相同 ***

select 
	b.UserName,a.PenaltyMoney ,dense_rank() over(order by a.PenaltyMoney desc) as [rank]
from penalty.PenaltyDetails a 
	join users.UserDetailes b on a.LibarayCardID = b.LibarayCardID 
go


--4查看所有用户的姓名和总计借书数量 

select 
	UserName,sum(BorrowedCount) as TotalNumBooks
from 
	users.UserDetailes
group by UserName,BorrowedCount
go


--5查看指定年份和月份的借出图书总量
create proc borrowBookTotalBymonthAndYear @month int , @year int 
as  
select 
	sum(all BorrowedCount) as OUTBookNum
from 
	users.UserDetailes a join Users.BorrowDetails b on a.LibarayCardID = b.LibarayCardID 
where 
	month(BorrowDate) = @month and year(BorrowDate) = @year
go

exec borrowBookTotalBymonthAndYear 8,2015


drop proc borrowBookTotalBymonthAndYear





--6查看所有用户指定月份或年份的罚金总额 (以月份为例)
create proc personPenaltyByName @month int        --@year...
as
select 
	b.LibarayCardID,b.UserName,sum(PenaltyMoney ) as TotalsumMoney
from 
	penalty.PenaltyDetails a join Users.UserDetailes b on a.LibarayCardID = b.LibarayCardID
	join Users.BorrowDetails c on c.LibarayCardID = b.LibarayCardID
where 
	datepart(MM, c.RepayDate) = @month	
group by 
	b.LibarayCardID,b.UserName
order by LibarayCardID DESC
go

exec personPenaltyByName 9
exec personPenaltyByName 10

drop proc personPenaltyByName


--7查看指定月份指定图书的入库总数量
create proc bookTotalByNameAndMonth @name varchar(20),@month int 
as
select 
	BookInCount 
from 
	books.BookInOut 
where BookID = (select BookID from books.BookDetails where BookName = @name) and month(BookInDate) = @month 

go


exec bookTotalByNameAndMonth 'C程序设计',7

drop proc bookTotalByNameAndMonth

--8查看每月份每个书籍的入库数量 -----
select 
	'月份' = datepart(mm,a.BookInDate) ,
	'入库总量' = sum(a.BookInCount),
	'书籍名称' = b.BookName
from 
	books.BookInOut a join books.BookDetails b 
	on a.BookID = b.BookID
group by datepart(mm,a.BookInDate),b.BookName
order by '月份'asc
go
	
--9查看每月份每个书籍的入库-出库之差 

select 
	a.BookInCount - a.BookOutCount as IndeleteOutNum,b.BookName    
from 
	books.BookInOut a join books.BookDetails b 
	on a.BookID = b.BookID 
go


--10查看书籍每月入库总数量，同时实现上月入库总数量和下月入库总数量

select 
	'月份'=datepart(mm,BookInDate) ,
	'当月入库总量' = sum(BookInCount),
	'上月入库总量'= lag(sum(BookInCount),1) over(order by datepart(mm,BookInDate) ),--lag 和lead 可以 获取结果集中，按一定排序所排列的当前行的上下相邻若干offset 的某个行的某个列
	'下月入库总量'= lead(sum(BookInCount),1)over (order by datepart(mm,BookInDate) )--ag ，lead 分别是向前，向后；
from books.BookInOut
group by datepart(mm,BookInDate) 




---------------------------------------------管理员报告需求(员工信息)
--员工信息查询
--1查询指定名字的员工的信息
create proc findInformByname @name varchar(20) 
as
select * from 
	HumanResources.Employee 
where ChName = @name
go


exec findInformByname '李明'


--2查询为管理员的员工的信息

select 
	a.EmployeeID,a.LandAccount,a.LandPassword,b.ChName
from 
	HumanResources.Administrators a join HumanResources.Employee b 
	on a.EmployeeID = b.EmployeeID
go
--3查询 2012 年6月以后加入图书馆的员工的信息

select 
	ChName,EnName,JoinDate
from 
	HumanResources.Employee 

where 
	 JoinDate > '2012-06-01'
go


--4查询未过试用期离职的员工的信息（员工试用期 1个月） 

select * from 
	HumanResources.Employee 
where month(JoinDate) - month(DepartureDate) < 1
go 




---------------------------------------------------------------------------触发器的创建

--1触发器
--( 用户丢失或损坏**一本书，记录罚金信息同时，也要在图书信息中减少在馆可用图书数量 )
create trigger trg_destroyBook_penalty
on penalty.PenaltyDetails
for insert 
as
begin 
	update books.BookDetails 
		set BookInCount = BookInCount - 1 
end
go

insert into Penalty.PenaltyDetails values('Lib000005','201506130001',7,20,'6月内未还') --'201506130001'指的是BookID，文艺风赏

select*from Penalty.PenaltyDetails
select*from books.BookDetails



--2触发器
--(确保员工离职时，若是管理员，其员工信息和管理员账号信息都被删除，否则两个操作都不成功)
--删除触发器
create trigger trg_Admin_Emp 
on HumanResources.Administrators
after delete
as
begin
	delete HumanResources.Employee where EmployeeID in(select EmployeeID from deleted)
end




select*from HumanResources.Employee
select*from HumanResources.Administrators

delete from HumanResources.Administrators where EmployeeID = 40701



--3触发器
--（图书从图书表删除后，自动添加到图书历史表 ）

create trigger trg_dele_insert
on books.BookDetails
after delete
as
begin
	declare @bookid varchar(30),@bookname varchar(30),@auther varchar(30),@CategoriesID varchar(30),@FieldID varchar(30),@bookpub varchar(30)
	select 
		@bookid = BookID ,
		@bookname = BookName,
		@auther = Author,
		@CategoriesID = CategoriesID,
		@FieldID = FieldID,
		@bookpub = BookPub
	from deleted
	insert into books.BookHistory values(@bookid,@bookname,@auther,@CategoriesID,@FieldID,@bookpub,null,null)
end

delete from Users.BorrowDetails where BookID = '201506130004'
delete from books.BookDetails where BookID = '201506130004'------例如删除'C程序设计'

select*from books.BookHistory
select*from books.BookDetails

-------------------------------------------------------------------------------------------

