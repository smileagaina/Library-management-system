
--�������ݿ⣨ͼ���ϵͳ��

create database librarysystem
ON
(
	NAME=librarysystem,
	FILENAME='d:\librarysystem.mdf',--�ļ���ַ��ͬ
	SIZE=10,
	MAXSIZE=50,
	FILEGROWTH=5
)
LOG ON
(
	NAME='library',
	FILENAME='d:\librarysystem.ldf',--�ļ���ַ
	SIZE=5MB,
	MAXSIZE=25MB
)
GO

use librarysystem
go


-------------------------------------------------------------------
--������


--1.����Ա�� �ܹ�HumanResources
create schema HumanResources  
go



--������Ա����
/*
Ա�����
��������
Ӣ������
סַ
ְλ
��ϵ��ʽ�������ж����
��������
��ְ����


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


--(�����ϵ��ʽ)��ͨ��EmployeeID��Employee��ϵ
create table HumanResources.EmpContact
(
	EmployeeID varchar(30) not null primary key,
	Contact1 varchar(30) not null check(Contact1 like'1[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),--�ɻ���chrule����
	Contact2 varchar(30)  check(Contact2 like'1[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	Contact3 varchar(30)  check(Contact3 like'1[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	Contact4 varchar(30) check(Contact4 like'1[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
	Foreign key (EmployeeID) references HumanResources.Employee(EmployeeID)
)

go






--������(����Ա)
/*
Ա�����
��¼�˺�
��¼����
*/

create table HumanResources.Administrators
(
    EmployeeID varchar(30) not null primary key,
	LandAccount varchar(30) not null unique,
	LandPassword varchar(30) not null,
	foreign key (EmployeeID) references HumanResources.Employee(EmployeeID)
)
go



--2.�����ܹ�books ʹͼ����Ϣ��ͬһ�ܹ���
create schema books
go 



--������ͼ����������ͼ�������Ϣ
create table books.Categories
(
    CategoriesID int  constraint PK_CategoriesID check(CategoriesID between 0and 9) primary key,  --����
	BookStyle varchar(30) not null  --�������
)
go 


--������(ͼ������)���洢ͼ��������Ϣ
create table books.Field
(
    FieldID  varchar(30) constraint PK_FieldID check(FieldID like '[A-Z][0-9]') primary key,  --������
	FieldName varchar(30) not null,--��������
	FieldDescription varchar(30)  not null , --�������� ԭ����FieldNo
) 
go





--������(ͼ����λ����Ϣ)
/*		
ͼ������ʼ���		
ͼ���Ž�����		
���������
*/

create table books.BookLocations
(	 
     BookBorrowNo int  not null  ,
	 BookStartNo varchar(30) not null primary key,
	 BookStoreNo varchar(30) not null,
)
go



		--������(�������Ϣ)
/*
ͼ����
���������
���������
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







/*������(ͼ����Ϣ),�洢ͼ����ϸ��Ϣ,
����ͼ���š�ͼ�����ơ����ߡ�����������ƣ��������硢���ۡ�
���ʱ�䡢ͼ���������ڹ�������ͼ�����ͼƬ������
*/

create table books.BookDetails
(
	BookID varchar(30)  primary key, --ͼ����
	BookName varchar(30) not null,   --ͼ������
	Author varchar(30)  not null,    --����
	CategoriesID int   not null ,--ͼ�����
	FieldID varchar(30) not null ,--�������ƣ�
	BookPub varchar(30) not null,        --������
	UnitPrice decimal(10,5) not null,--����
	BookInDate datetime not null,    --���ʱ��
	BookTotal int not null,          --ͼ������
	BookInCount int not null,        --�ڹ�����
	BookCoverPic varbinary(max) null,--ͼ�����ͼƬ--cast ('D:\Emp_photo\Emp101.jpg'as varbinary(max)),
	BookIntroduce varchar(50) null	,    --����
	foreign key (CategoriesID) references books.Categories(CategoriesID),--ǰ���������������
	foreign key (FieldID) references books.Field(FieldID),
    foreign key (BookID) references books.BookLocations(BookStartNo),
	foreign key(BookID) references  books.BookInOut(BookID)
)
go 

	--����ȫ������
create  fulltext catalog MyCatalog as default

create unique index Uidx_BookID on books.BookDetails(BookID)
create fulltext index on books.BookDetails(BookName) 
key index Uidx_BookID
alter fulltext index on books.BookDetails
start full population
go


--������ͼ����ʷ��
/*
ͼ���� 
ͼ������
����
���
����
������
����
ɾ������
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

--3.�����û��ܹ� Users
create schema Users
go



--�������û���
/*
���鿨���
�û�����
֤������
���֤�Ż��պ�
��������
��ϵ�绰
��ͥסַ
�ѽ�����
*/
create table users.UserDetailes
(
	LibarayCardID varchar(30) not null primary key,
	UserName varchar(30) not null,
	DocumentType varchar(30) not null,
	PaperNum varchar(30) not null unique check ( len(PaperNum)=18 or len(PaperNum)= 9),
	BirthDate datetime not null ,
	Phone varchar(30) not null check(Phone like'1[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),--�ɻ���chrule����
	[Address] varchar(30) not null,
	BorrowedCount int not null check( BorrowedCount <= 5)
)
go

--4��������ܹ�Penalty


create schema Penalty
go


--���������
/*
���鿨���
ͼ����
��������
������
����ԭ��
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


--������������Ϣ��
/*���鿨���
ͼ����
��������
��������
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
--��������

--��Ա�����в�����Ϣ
--select * from HumanResources.Employee

insert into HumanResources.Employee values
('40701','����','Joseph','����','Administrator','2011-05-24',null),
('40702','����','David','����','worker','2006-06-02','2015-01-24'),
('40703','��ͨ','Aaron','�Ϻ�','Administrator','2003-05-02',null),
('40704','����','mango','����','cleaner','2014-01-03','2005-8-11'),
('40705','����','Devin','����','Administrator','2008-01-02','2008-11-7'),
('40706','���','Mikdde','�Ϻ�','manager','2007-05-02',null)
go



--�����Ա���в�����Ϣ
insert into HumanResources.Administrators values
('40703','350463471','346123'),
('40702','350461583','583725'),
('40701','350462769','273957')
go




--��ͼ�������������
--������ƣ��ڿ�,�ֵ�,ͼ��,��ֽ

insert into books.Categories values
('0','�ڿ�'),
('1','�ֵ�'),
('2','ͼ��'),
('3','��ֽ')
go


--��ͼ�������������
--������������ѧ�ࡢ����ѧ�����η��ɡ����¿�ѧ
-- FieldID  int constraint PK_FieldID check(FieldID like '[A-Z][0-9][0-9]') primary key,��
--FieldName varchar(30) null,--��������
--FieldDescription varchar(30)  not null , --�������� ԭ����FieldNo

insert into books.Field  values
('A1','��������','������ͼ��'),--������,��������,��������
('B2','��ѧ��','ΰ����ѧ'),
('C3','����ѧ','��ͬ��ע'),
('D4','���η���','�̷���'),
('E5','���¿�ѧ','�Ƽ�ǰ��'),
('F6','���̼���','��ľ����'),
('G7','���Լ���','С����'),
('H8','��������','���ո���')
go







--������Ϣ��(Books.Locations)��������
 

insert into books.BookLocations values
(1,'201506130001','A'),
(2,'201506130002','B'),
(3,'201506130003','C'),
(4,'201506130004','D'),
(5,'201506130005','E'),
(6,'201506130006','F')

--������������Ϣ
insert into books.BookInOut values
('201506130001','2015-06-01','2016-07-01',100,50),
('201506130002','2015-05-02','2016-07-02',200,100),
('201506130003','2015-04-03','2016-07-03',500,400),
('201506130004','2015-07-04','2016-08-04',1000,200),
('201506130005','2015-08-05','2016-09-05',2000,200),
('201506130006','2015-06-06','2016-08-06',200,100)
go


----��ͼ����Ϣ(books.BookDetails)���������

insert into books.BookDetails values
('201506130001','���շ���','�Ѱ�','0','A1','�������ճ�����',16.8,'2015-02-01',200,100,cast ('G:\SQL\SQL��Ŀ����\dictionary.jpg'as varbinary(max)),'�ڿ�����С˵������Ʒ'),
('201506130002','��������ԭ��','����Ӣ','2','B2','�廪��ѧ������',56.2,'2003-11-15',20,13,null,'ͼ��������֪ʶ���'),
('201506130003','���ݿ�ԭ��','��ʦ��','2','C3','�ߵȽ���������',65.3,'2007-07-02',2,2,null,'����������ݿ�֪ʶ'),
('201506130004','C�������','̷��ǿ','2','D4','�廪��ѧ������',59.9,'2002-04-02',50,23,null,'��������������ָ��'),
('201506130005','�±��ѧӢ��','Ӧ����','2','E5','������',34.9,'2002-11-12',50,23,null,'Ӣ��α�'),
('201506130006','�±຺���ֵ�','�����ֵ��д��','1','F6','������',65.9,'2015-6-21',50,40,null,'�����ֵ�')
go


--���û����в�����Ϣ
insert into users.UserDetailes values
('Lib000001','�Ʊ�','���֤','370825196902276918','1986-01-01','13589652369','�ൺ','3'),
('Lib000002','ղķ˹','���֤','371254198702054459','1987-02-05','13586578369','�ൺ','5'),
('Lib000003','������','���֤','370215199605057894','1996-05-05','13589895369','�ൺ','2'),
('Lib000004','����','���֤','381548199912068879','1999-12-06','13589147369','�ൺ','1'),
('Lib000005','ŷ��','���֤','380245198811074526','1988-11-07','13589652585','�ൺ','0')
go





--�򷣽���в�����Ϣ
insert into Penalty.PenaltyDetails values
('Lib000001','201506130004',7,10,'4����δ��'),
('Lib000002','201506130001',14,10,'5����û��'),
('Lib000003','201506130002',14,10,'5����û��')
go



--�����������Ϣ
insert into Users.BorrowDetails values
('Lib000001','201506130001','2015-07-01','2015-10-09'),
('Lib000002','201506130002','2015-08-01','2015-09-01'),
('Lib000003','201506130003','2015-10-12','2015-10-30'),
('Lib000004','201506130004','2015-12-10','2016-03-01'),
('Lib000005','201506130005','2015-12-30','2016-03-30')
go




------------------------------------------------------------------------------------
--ʵ�ֲ�ѯ

--------------------User Report Requirements�û���������ã�ͼ����Ϣ��: 
--1�鿴�����˻���Ϣ 
create procedure accountInform_pro 
as
select *from users.UserDetailes

exec accountInform_pro 

drop proc accountInform_pro 
--2�鿴����ͼ�������Ϣ
create proc borrowInfromdetailes @name varchar(20) 
as
select *from Users.BorrowDetails a join users.UserDetailes b 
on a.LibarayCardID = b.LibarayCardID where b.UserName=@name
go

exec borrowInfromdetailes '�Ʊ�'



--3�鿴�������������ض����ֵ�ͼ�����Ϣ 
create proc findBook_pro @word varchar(20) 
as 
select * from books.BookDetails 
where BookName like '%'+@word+'%'
go

exec findBook_pro '��'



--4�鿴ָ�������ͼ�����Ϣ 
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

--5�鿴ָ������ͼ�����Ϣ 
create proc findBookCatego_pro @word varchar(20) 
as 
select * from books.BookDetails 
where CategoriesID = (select CategoriesID from books.Categories where CategoriesID=@word)
go

exec findBookCatego_pro '0'

drop proc findBookCatego_pro

/*
--6 �鿴ָ��������ݵ�ͼ�����Ϣ 
create proc findBookDate_pro @datetime datetime 
as
select * from books.BookDetails where BookInDate=@datetime
go

exec proc findBookDate_pro ''
*/
--7 �鿴ָ�����ߵ�ͼ�����Ϣ  
create proc findBookAuthor @author varchar(20) as
select * from books.BookDetails where Author=@author
go

exec findBookAuthor '̷��ǿ'

--8��ѯ���ܰ���ָ���ؼ��ֵ�ͼ�����Ϣ���ṩ����ȷ���Һ;�ȷ���ң����Ż���ѯЧ�ʣ� 


select BookName from books.BookDetails where freetext(BookName,'C����')
select BookName from books.BookDetails where contains(BookName,'�±�')

--9�鿴ָ��ͼ����ڹ�����
create proc bookSumByName @name varchar(20) 
as
select BookTotal from books.BookDetails  
where BookName=@name
go


exec bookSumByName '�±��ѧӢ��'

--10��ѯ������ߵ��鼮����Ϣ 

select top 1 * from books.BookDetails 
order by UnitPrice desc
go


--11�鿴�ڹ�����С�� 3��ͼ�����Ϣ 

select * from books.BookDetails 
where BookTotal<3
go

--12�鿴ÿ����ÿ���ͼ���Ӧ���鼮���� 
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



exec eachfield_eachcat_pro '��������','�ڿ�'




-----------------------------------�û���������(���𣬽�����Ϣ,ͼ����������)

--1�鿴ָ���û��Ľ�����Ϣ
create proc user_pro @name varchar(20) 
as
select * from users.UserDetailes 
where UserName=@name
go

exec  user_pro '�Ʊ�'



--2�鿴ָ���û��ķ�����Ϣ�������շ����������
create proc informationendpenalty @name varchar(30)
as
select * from 
	penalty.PenaltyDetails 
where 
	LibarayCardID = (select LibarayCardID from users.UserDetailes where UserName = @name ) 
order by PenaltyMoney desc 
go

exec informationendpenalty '�Ʊ�'
exec informationendpenalty 'ղķ˹'


drop  proc informationendpenalty

--3�鿴�����û��ķ�����Ϣ��������������������ߵ�������һ��������ͬ��������ͬ ***

select 
	b.UserName,a.PenaltyMoney ,dense_rank() over(order by a.PenaltyMoney desc) as [rank]
from penalty.PenaltyDetails a 
	join users.UserDetailes b on a.LibarayCardID = b.LibarayCardID 
go


--4�鿴�����û����������ܼƽ������� 

select 
	UserName,sum(BorrowedCount) as TotalNumBooks
from 
	users.UserDetailes
group by UserName,BorrowedCount
go


--5�鿴ָ����ݺ��·ݵĽ��ͼ������
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





--6�鿴�����û�ָ���·ݻ���ݵķ����ܶ� (���·�Ϊ��)
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


--7�鿴ָ���·�ָ��ͼ������������
create proc bookTotalByNameAndMonth @name varchar(20),@month int 
as
select 
	BookInCount 
from 
	books.BookInOut 
where BookID = (select BookID from books.BookDetails where BookName = @name) and month(BookInDate) = @month 

go


exec bookTotalByNameAndMonth 'C�������',7

drop proc bookTotalByNameAndMonth

--8�鿴ÿ�·�ÿ���鼮��������� -----
select 
	'�·�' = datepart(mm,a.BookInDate) ,
	'�������' = sum(a.BookInCount),
	'�鼮����' = b.BookName
from 
	books.BookInOut a join books.BookDetails b 
	on a.BookID = b.BookID
group by datepart(mm,a.BookInDate),b.BookName
order by '�·�'asc
go
	
--9�鿴ÿ�·�ÿ���鼮�����-����֮�� 

select 
	a.BookInCount - a.BookOutCount as IndeleteOutNum,b.BookName    
from 
	books.BookInOut a join books.BookDetails b 
	on a.BookID = b.BookID 
go


--10�鿴�鼮ÿ�������������ͬʱʵ������������������������������

select 
	'�·�'=datepart(mm,BookInDate) ,
	'�����������' = sum(BookInCount),
	'�����������'= lag(sum(BookInCount),1) over(order by datepart(mm,BookInDate) ),--lag ��lead ���� ��ȡ������У���һ�����������еĵ�ǰ�е�������������offset ��ĳ���е�ĳ����
	'�����������'= lead(sum(BookInCount),1)over (order by datepart(mm,BookInDate) )--ag ��lead �ֱ�����ǰ�����
from books.BookInOut
group by datepart(mm,BookInDate) 




---------------------------------------------����Ա��������(Ա����Ϣ)
--Ա����Ϣ��ѯ
--1��ѯָ�����ֵ�Ա������Ϣ
create proc findInformByname @name varchar(20) 
as
select * from 
	HumanResources.Employee 
where ChName = @name
go


exec findInformByname '����'


--2��ѯΪ����Ա��Ա������Ϣ

select 
	a.EmployeeID,a.LandAccount,a.LandPassword,b.ChName
from 
	HumanResources.Administrators a join HumanResources.Employee b 
	on a.EmployeeID = b.EmployeeID
go
--3��ѯ 2012 ��6���Ժ����ͼ��ݵ�Ա������Ϣ

select 
	ChName,EnName,JoinDate
from 
	HumanResources.Employee 

where 
	 JoinDate > '2012-06-01'
go


--4��ѯδ����������ְ��Ա������Ϣ��Ա�������� 1���£� 

select * from 
	HumanResources.Employee 
where month(JoinDate) - month(DepartureDate) < 1
go 




---------------------------------------------------------------------------�������Ĵ���

--1������
--( �û���ʧ����**һ���飬��¼������Ϣͬʱ��ҲҪ��ͼ����Ϣ�м����ڹݿ���ͼ������ )
create trigger trg_destroyBook_penalty
on penalty.PenaltyDetails
for insert 
as
begin 
	update books.BookDetails 
		set BookInCount = BookInCount - 1 
end
go

insert into Penalty.PenaltyDetails values('Lib000005','201506130001',7,20,'6����δ��') --'201506130001'ָ����BookID�����շ���

select*from Penalty.PenaltyDetails
select*from books.BookDetails



--2������
--(ȷ��Ա����ְʱ�����ǹ���Ա����Ա����Ϣ�͹���Ա�˺���Ϣ����ɾ���������������������ɹ�)
--ɾ��������
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



--3������
--��ͼ���ͼ���ɾ�����Զ���ӵ�ͼ����ʷ�� ��

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
delete from books.BookDetails where BookID = '201506130004'------����ɾ��'C�������'

select*from books.BookHistory
select*from books.BookDetails

-------------------------------------------------------------------------------------------

