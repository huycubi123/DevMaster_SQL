--create database QLBanHang2
-------
use QLBanHang2
create table Customer(
	CustID varchar(5) primary key,
	Name nvarchar(20) not null,
	City nvarchar(20)
)

create table SalesPerson(
	SlsPerID varchar(5) primary key,
	Name nvarchar(20) not null,
	user3 float,
	user4 float
) 

create table Inventory(
	InvtID varchar(5) primary key,
	Descr nvarchar(20),
	StkBasePrc float
)

create table xswSalesOrd (
	OrderNbr varchar(5) primary key,
	OrderDate date,
	SlsPerID varchar(5),
	CustID varchar(5),
	OrdAmt float,
	OrderType varchar(10) ,
	OrdDiscAmt float, 

	check (OrderType in ('NT','ND','NM')),
	FOREIGN KEY(CustID) references Customer (CustID),
	foreign key(SlsPerID) references SalesPerson(SlsPerID)
)

create table xswSlsOrdDet(
	OrderNbr varchar(5),
	InvtID varchar(5),
	LineQty int,
	LineAmt float,
	SlsPrice float, 

	primary key (OrderNbr,InvtID),
	foreign key (OrderNbr) references xswSalesOrd (OrderNbr),
	foreign key (InvtID) references Inventory(InvtID)
)

------ Dữ liệu lấy trên mạng ----------------
-- Customer
INSERT INTO Customer VALUES
('C001',N'Nguyễn Văn An',N'Hà Nội'),
('C002',N'Trần Thị Bình',N'Hải Phòng'),
('C003',N'Lê Văn Cường',N'Đà Nẵng'),
('C004',N'Phạm Thị Dung',N'Hồ Chí Minh'),
('C005',N'Hoàng Minh Đức',N'Cần Thơ');

-- SalesPerson
INSERT INTO SalesPerson VALUES
('S001',N'Nguyễn Hải',0.05,1000000),
('S002',N'Trần Minh',0.07,1200000),
('S003',N'Lê Hoàng',0.06,900000),
('S004',N'Phạm Nam',0.08,1500000);

-- Inventory
INSERT INTO Inventory VALUES
('I001',N'Laptop Dell',15000000),
('I002',N'Chuột Logitech',300000),
('I003',N'Bàn phím Cơ',800000),
('I004',N'Màn hình LG',3500000),
('I005',N'Tai nghe Sony',1200000),
('I006',N'USB 64GB',250000);

-- Sales Order
INSERT INTO xswSalesOrd VALUES
('O001','2025-01-10','S001','C001',15600000,'NT',0),
('O002','2025-01-15','S002','C002',4100000,'ND',100000),
('O003','2025-02-01','S003','C003',2400000,'NM',0),
('O004','2025-02-10','S001','C004',18300000,'NT',500000),
('O005','2025-03-05','S004','C005',5000000,'ND',200000);

-- Sales Order Detail
INSERT INTO xswSlsOrdDet VALUES
-- O001
('O001','I001',1,15000000,15000000),
('O001','I002',2,600000,300000),

-- O002
('O002','I004',1,3500000,3500000),
('O002','I006',2,500000,250000),
('O002','I002',1,300000,300000),

-- O003
('O003','I005',2,2400000,1200000),

-- O004
('O004','I001',1,15000000,15000000),
('O004','I003',1,800000,800000),
('O004','I004',1,3500000,3500000),

-- O005
('O005','I005',2,2400000,1200000),
('O005','I006',4,1000000,250000),
('O005','I002',2,600000,300000);


------- 
use QLBanHang2
-- Truy vấn
--Câu 1: Liệt kê 10 hóa đơn gần nhất 
select top 10 OrderNbr,OrderDate,CustID,OrdAmt from xswSalesOrd order by OrderDate desc 

-- Câu 2: Cho biết doanh số tổng theo từng loại đơn hàng 
select OrderType, SUM(OrdAmt) as TongDoanhSo from xswSalesOrd
group by OrderType

-- Câu 3: Liệt kê các dòng chi tiết bán hàng của 1 hóa đơn 
select * from xswSlsOrdDet where OrderNbr = 'O002'

-- Câu 4: Cho biết mặt hàng không được mua trong 6 tháng cuối năm ? 
select distinct Inventory.InvtID,Descr from Inventory join xswSlsOrdDet on Inventory.InvtID=xswSlsOrdDet.InvtID
where OrderNbr not in (select OrderNbr from xswSalesOrd where OrderDate>'20250701') 

-- câu 5: Cho biết mặt hàng nào được mua số lượng nhất đầu 2025
select top 1 Inventory.InvtID,Descr,LineQty from Inventory join xswSlsOrdDet on Inventory.InvtID=xswSlsOrdDet.InvtID
where OrderNbr in (select OrderNbr from xswSalesOrd where OrderDate<'20250701'and OrderDate>='20250101')
order by LineQty desc

-- câu 6: trong năm 2025 có những mặt hàng nào được mua nhỏ hơn 2 lần ? 
select Inventory.InvtID,Descr,count(xswSlsOrdDet.InvtID) as N'Số Lần mua' from Inventory join xswSlsOrdDet on Inventory.InvtID=xswSlsOrdDet.InvtID where OrderNbr in (select OrderNbr from xswSalesOrd where YEAR(OrderDate)='2025')
group by Inventory.InvtID,Descr
having count(xswSlsOrdDet.InvtID) <2
-------- Nghỉ trưa ăn cơm -----------
-- câu 7: Cho biết 10 khách đã mua nhiều nhất (về mặt giá trị) trong Quý 1 năm 2025 
select top 10 xswSalesOrd.CustID,Name,sum(OrdAmt) as TongGiaTri from xswSalesOrd join Customer on xswSalesOrd.CustID=Customer.CustID
where OrderDate >= '20250101' and OrderDate<= '20250331'
group by xswSalesOrd.CustID,Name
order by SUM(OrdAmt) desc

-- câu 8: cho  biết số lượng của từng mặt hàng mà công ty bán cho khách theo từng tháng trong năm 2025 
select Inventory.InvtID,Descr, MONTH(OrderDate) as N'Tháng', SUM(LineQty) as N'Tổng số lượng' from Inventory join xswSlsOrdDet on Inventory.InvtID=xswSlsOrdDet.InvtID join xswSalesOrd on xswSalesOrd.OrderNbr=xswSlsOrdDet.OrderNbr
group by MONTH(OrderDate), Inventory.InvtID,Descr

-- câu 9: Nhân viên nào bán được số lượng nhiều nhất và số lượng hàng bán được là boa nhiêu ? 
select top 1 with ties Name, SUM(LineQty) as N'Tổng số lượng' from SalesPerson join xswSalesOrd on SalesPerson.SlsPerID=xswSalesOrd.SlsPerID join xswSlsOrdDet on xswSalesOrd.OrderNbr=xswSlsOrdDet.OrderNbr
group by Name
order by sum(LineQty) desc
-- câu 10: Cập nhật trường User 3 =10000000 top 10 nhân viên có doanh số cao max quý 1 2025
update SalesPerson set user3=10000000 where SlsPerID in  (select top 10 SalesPerson.SlsPerID from SalesPerson join xswSalesOrd on SalesPerson.SlsPerID=xswSalesOrd.SlsPerID where OrderDate >= '20250101' and OrderDate<= '20250331' group by SalesPerson.SlsPerID order by SUM(OrdAmt) desc)

-- câu 11: update user4=50000000 nhân viên có doanh số cao max 2025
update SalesPerson set user4=50000000 where SlsPerID in (select top 1 with ties SalesPerson.SlsPerID from SalesPerson join xswSalesOrd on SalesPerson.SlsPerID=xswSalesOrd.SlsPerID where Year(OrderDate)= '2025' group by SalesPerson.SlsPerID order by SUM(OrdAmt) desc )

-- câu 12: XÓa mặt hàng không được mua trong bất kì đơn nào 
delete from Inventory where Inventory.InvtID not in (select InvtID from xswSlsOrdDet )

--câu 13 : hiển thị báo cáo doanh số bán hàng theo từng tháng trong 2025
with months as(
	select 1 as monthDem
	union all select 2 
	union all select 3
	union all select 4 
	union all select 5 
	union all select 6 
	union all select 7 
	union all select 8 
	union all select 9 
	union all select 10
	union all select 11
	union all select 12
)
select  M.monthDem as Thang, sum(X.OrdAmt) as DoanhSo  from months M left join xswSalesOrd X on M.monthDem=MONTH(X.OrderDate) and  year(X.OrderDate)=2025
where YEAR(OrderDate)=2025
group by M.monthDem

-- Phần View 
-- Caa 1: ds hóa đơn kèm tên KH + NV 
create view ViewCau1
as 
select OrderNbr,OrderDate,OrdAmt,OrderType,OrdDiscAmt, Customer.Name as TenKhach,SalesPerson.Name as TenSale from xswSalesOrd join Customer on xswSalesOrd.CustID=Customer.CustID join SalesPerson on xswSalesOrd.SlsPerID=SalesPerson.SlsPerID
go
select * from ViewCau1

-- câu 2: view tính số lượng và tổng tiền theo mặt hàng 
create view ViewCau2
as 
select InvtID,sum(LineQty) as TongSoLuong, SUM(LineAmt) as TongTien from xswSlsOrdDet group by InvtID
go
select * from ViewCau2
-- câu 3: đưa ra doanh số theo tháng trong năm dựa trên OrderDate 
create view ViewCau3
as
select sum(OrdAmt) as DoanhSo, MONTH(OrderDate) as Thang from xswSalesOrd group by MONTH(OrderDate)
go

-- câu 4: hiển thị mặt hàng kh bán cho khách tại Hà Nội trong 2025
create view ViewCau4 as
select Inventory.InvtID, Descr from Inventory join xswSlsOrdDet on Inventory.InvtID=xswSlsOrdDet.InvtID join xswSalesOrd on xswSlsOrdDet.OrderNbr=xswSalesOrd.OrderNbr
join Customer on xswSalesOrd.CustID=Customer.CustID
where YEAR(OrderDate)=2025 and City <> N'Hà Nội'
go

-- câu 5 hiện thị hóa đơn bán hàng trong 2025
create view ViewCau5 as
select xswSalesOrd.OrderNbr,OrderDate,SlsPerID,CustID,Descr,LineQty from xswSalesOrd join xswSlsOrdDet on xswSalesOrd.OrderNbr=xswSlsOrdDet.OrderNbr join Inventory on xswSlsOrdDet.InvtID=Inventory.InvtID
go

-- câu 6: những mặt hàng chỉ mua nhỏ hơn 5 lần 
create view ViewCau6 as
select Inventory.InvtID, Descr,COUNT(xswSlsOrdDet.InvtID) as SoLan from Inventory join  xswSlsOrdDet on Inventory.InvtID=xswSlsOrdDet.InvtID
group by Inventory.InvtID, Descr
having COUNT(xswSlsOrdDet.InvtID) <5
go

-- câu 7: cho biết 10 khách mua nhiều nhất (về giá trị trong quý 1)
create view ViewCau7 as
select top 10 xswSalesOrd.CustID,Name,sum(OrdAmt) as TongGiaTri from xswSalesOrd join Customer on xswSalesOrd.CustID=Customer.CustID
where OrderDate >= '20250101' and OrderDate<= '20250331'
group by xswSalesOrd.CustID,Name
order by SUM(OrdAmt) desc
go

-- câu 8: tạo view báo cáo tổng hợp  ? 
create view ViewCau8 as
select SalesPerson.SlsPerID,Name,OrderType,case when OrderType='NT'then N'Nhân viên trả NPP' when OrderType='ND' then N'NPP xuất' when OrderType='NM' then N'Khách trả' end as N'Loại', sum(OrdAmt) as TongGiaTri from SalesPerson join xswSalesOrd on SalesPerson.SlsPerID=xswSalesOrd.SlsPerID
where YEAR(OrderDate)=2025
group by  SalesPerson.SlsPerID,Name,OrderType
go

-- Câu 9: store-procedure
-- câu 1: lấy hóa đơn theo khách 
alter procedure procCau1
 @KhachName nvarchar(20)
as 
begin 
	select * from xswSalesOrd where CustID in (select CustID from Customer where Name like N'%'+ @KhachName+N'%') 
end

exec procCau1 N'Văn'

-- câu 2: thêm 1 dòng chi tiết hóa đơn LineAmt
create procedure procCau2
@OrderNbr varchar(5), @InvtID varchar(5), @LineQty int, @SlsPrice float
as
begin
	if exists (select OrderNbr from xswSlsOrdDet where OrderNbr=@OrderNbr and InvtID=@InvtID )
	begin  print N'Sản phẩm đã tồn tại' end
	else
	begin 
		declare @LineAmt float 
		set @LineAmt=@LineQty*@SlsPrice
		insert into xswSlsOrdDet(OrderNbr,InvtID,LineQty,SlsPrice,LineAmt) values (@OrderNbr,@InvtID,@LineQty,@SlsPrice,@LineAmt)
		print N'Đã thêm'
	end
end
-- Thêm thử 
exec procCau2 'O005','I001','3','10000'
select * from xswSlsOrdDet

-- câu 3: báo cáo doanh số theo khoảng ngày 
create procedure procCau3
@ngayBD date, @ngayKT date
as
begin 
select sum(OrdAmt) as TongDoanhSo from xswSalesOrd where OrderDate between @ngayBD and @ngayKT
end

exec procCau3 '20250101','20250301' 

-- câu 4: liệt kê 10 mặt hàng doanh số cao nhất từi ngày nhập vào 
create procedure procCau4
@ngayBD date, @ngayKT date
as
begin 
	select top 1 with ties i.InvtID,i.Descr, sum(LineAmt) as DoanhSo from Inventory i join xswSlsOrdDet x on i.InvtID=x.InvtID join xswSalesOrd o on x.OrderNbr=o.OrderNbr
	where OrderDate between @ngayBD and @ngayKT
	group by i.InvtID,i.Descr
	order by sum(LineAmt) desc
end

exec procCau4 '20250101','20250301'

-- câu 5: hiển ds khách có số lần mua hàng bằng gái trị truyền vào theo ngày bd,kt
create procedure procCau5
@ngayBD date, @ngayKT date, @solan int
as
begin 
	select Customer.CustID,Name, count(xswSalesOrd.CustID) as Solan from xswSalesOrd join Customer on xswSalesOrd.CustID=Customer.CustID
	where OrderDate between @ngayBD and @ngayKT 
	group by Customer.CustID,Name
	having count(xswSalesOrd.CustID) = @solan
end
exec procCau5 '20250101','20250301',1


-- Câu 6: 
create procedure procCau6
as
begin 
	select s.SlsPerID,s.Name,iif(sum(OrdAmt)<=100000000,N'Ko đạt doanh số',N'Đạt doanh số') from xswSalesOrd o join SalesPerson s on o.SlsPerID=s.SlsPerID
	where YEAR(OrderDate)=2025
	group by s.SlsPerID,s.Name
end
exec procCau6 

-- câu 7:  ???????
create procedure procCau7
@ngayBD date, @ngayKT date
as
begin 
	select Inventory.InvtID,Inventory.Descr,LineQty as N'Số lượng bán',   from xswSlsOrdDet join Inventory on xswSlsOrdDet.InvtID=Inventory.InvtID join xswSalesOrd on xswSalesOrd.OrderNbr=xswSlsOrdDet.OrderNbr 
end

-- câu 8: 
create procedure procCau8
@ngayBD date, @ngayKT date
as
begin 
	select SlsPerID,xswSalesOrd.CustID,Name from xswSalesOrd join Customer on xswSalesOrd.CustID=Customer.CustID
	where xswSalesOrd.OrderNbr not in (select i.OrderNbr from xswSalesOrd i where OrderDate between @ngayBD and @ngayKT )
end 
exec procCau8 '20250101','20250301'

-- câu 9: 
create procedure procCau8
@ngayBD date, @ngayKT date
as
begin 
	select o.SlsPerID,Name,	case when (MONTH(@ngayBD)-1) then CONVERT(nvarchar(20),sum(o.)) the  from xswSalesOrd o join SalesPerson i on o.SlsPerID=i.SlsPerID
end

select MONTH(GETDATE())-1

-- câu 10 


-- Phần trigger 
-- câu 1: tạo trigger khong cho orderDate lớn hơn ngày hiện tại 
create trigger tg_cau1 
on [dbo].[xswSalesOrd]
for insert 
as begin 
	if exists (
		select * from inserted where OrderDate > GETDATE()
	)
	begin print N'Ngày bán kh được trc ngày hiện tại'
				ROLLBACK TRANSACTION
				return 
	end
end

-- câu 2: tạo triiger tự tính LineAmt
create trigger tg_cau2
on [dbo].[xswSlsOrdDet]
for insert, update
as begin 
	if exists (select * from inserted)
	begin 
		update xswSlsOrdDet set LineAmt=xswSlsOrdDet.LineQty*xswSlsOrdDet.SlsPrice 
		from xswSlsOrdDet
		inner join inserted on xswSlsOrdDet.OrderNbr=inserted.OrderNbr
	end
end

-- câu 3: không cho lineQty <=0 và slsprice nhỏ hơn 0.
create trigger tg_cau3
on [dbo].[xswSlsOrdDet]
for insert, update 
as begin 
	if exists( select * from  inserted where LineQty<=0 or SlsPrice<0)
	begin 
		print N'Số lượng - giá trị không hơp lệ'
		ROLLBACK TRANSACTION
		return 
	end
end 

-- câu 4: kiểm tra tính toàn vẹn cho bảng Sales khi thực hiện xóa 1 nhân viên 
create trigger tg_cau4
on [dbo].[SalesPerson]
for delete 
as begin 
	if exists (select * from deleted where SlsPerID in (select SlsPerID from xswSalesOrd))
	begin 
		print N'Nhân viên này đã tồn tại trong dữ liệu hóa đơn bán hàng => Không thể xóa'
		ROLLBACK TRANSACTION
		return 
	end
end

-- câu 5: Viết trigger chỉ cho phép xóa khi doanh số khách nhỏ nhất trong quý 2 năm 2025 và chưa mua đơn hàng nào trong 2 tuần gần đây 
create trigger tg_cau5
on [dbo].[Customer]
for delete 
as begin 
	if exists (select * from deleted where CustID in (select top 2 with ties  CustID from xswSalesOrd where OrderDate between '20250104'and'20250630' group by CustID order by sum(OrdAmt)  ))
	begin 
		print N'Không được xóa'
		ROLLBACK TRANSACTION
		return 
	end
	else if exists (select * from deleted join xswSalesOrd on deleted.CustID=xswSalesOrd.CustID where month(OrderDate)-MONTH(GETDATE))
end