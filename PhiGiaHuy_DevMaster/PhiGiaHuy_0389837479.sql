-- Phần Thực Hành
-- Câu 1: 
select a.MaNCC,TenNCC,b.SoDH,NgayDH,c.Mavtu,SlDat,TenVTu,DGNhap,(SlDat*DGNhap) as ThanhTien  from NHACC a join DONDH b on a.MaNCC=b.MaNCC 
																join CTDONDH c on b.SoDH=c.SoDH
																join VATTU d on c.Mavtu=d.Mavtu
																join CTPNHAP e on d.Mavtu=e.Mavtu

-- Câu 2: 
create view vw_GetAll
as select top 100 percent CTPNHAP.SoPn,NgayNhap,SLNhap,DGNhap,SLNhap*DGNhap as ThanhTien,TenVTu from CTPNHAP join PNHAP on CTPNHAP.SoPn=PNHAP.SoPn join VATTU on CTPNHAP.Mavtu=VATTU.Mavtu order by NgayNhap desc
go

-- Câu 3: 
alter procedure cau3 
@thangNam varchar(10), @loiNhuan float output
as
begin
-- slc = sld + sln -slx
	select @loiNhuan=DGXuat*TongSLX - DGNhap*TongSLX  from TONKHO a join VATTU b on a.Mavtu=b.Mavtu join CTPNHAP c on b.Mavtu=c.Mavtu join CTPXUAT d on b.Mavtu=d.Mavtu  where NamThang=@thangNam

end
GO
declare @lN float
exec cau3 '201401', @lN output
select round(@lN,2) as N'Lợi nhuận'

-- Câu 4: 
alter procedure cau4
@maVT char(5), @slTon int output
as
begin 
	select @slTon= SLCuoi from TONKHO where Mavtu=@maVT
end
go

declare @slton int
exec cau4 'DD01', @slton output
select @slton

-- câu 7: 
alter procedure cau7
as
begin 
	select NhaCC.MaNCC,TenNCC,DONDH.SoDH,NgayDH, count(SoPn) as N'Số lần nhập hàng' from NHACC join DONDH on NHACC.MaNCC=DONDH.MaNCC join CTDONDH on DONDH.SoDH=CTDONDH.SoDH join VATTU on CTDONDH.Mavtu=VATTU.Mavtu join CTPNHAP on VATTU.Mavtu=CTPNHAP.Mavtu
	group by NHACC.MaNCC,TenNCC,DONDH.SoDH,NgayDH
end
----
exec cau7


-- câu 5: 
alter trigger cau5 on CTPNhap
for insert
as
begin 
	if exists (
	select CTPNHAP.Mavtu,SUM(SLNhap) from CTPNHAP left join VATTU on CTPNHAP.Mavtu=VATTU.Mavtu left join CTDONDH on VATTU.Mavtu=CTDONDH.Mavtu
	where CTPNHAP.Mavtu=(select Mavtu from inserted)
	group by CTPNHAP.Mavtu 
	having SUM(SLNhap) > sum (SlDat)
	)
	begin 
	 print N'Số lượng nhập phải nhỏ hơn hoặc bằng số lượng đặt'
	 rollback transaction  
	 return
	end
	update TONKHO set TongSLN=TongSLN + (select sum(SLNhap) from inserted where inserted.Mavtu=TONKHO.Mavtu)
end
---
insert CTPNHAP values ()

select * from CTPNHAP
select * from CTDONDH


select CTPNHAP.Mavtu,SUM(SLNhap) from CTPNHAP left join VATTU on CTPNHAP.Mavtu=VATTU.Mavtu 
left join CTDONDH on VATTU.Mavtu=CTDONDH.Mavtu 
group by CTPNHAP.Mavtu,SlDat
having SUM(SLNhap) > SUM(SlDat)
select * from CTDONDH


-- câu 6: 
create trigger cau6 on CTPXUAT
for insert 
as
begin 
	declare @slx int 
	declare @tonkho int
	set @slx= (select SLXuat from inserted)
	set @tonkho = (select SLCuoi from TONKHO)
	if @slx >@tonkho 
	begin 
		print N'Số lượng tồn kho không đủ xuất'
		rollback transaction 
		return 
	end
	update TONKHO set TongSLX=TongSLX+@slx where TONKHO.Mavtu=(select Mavtu from inserted)
end
select * from TONKHO
