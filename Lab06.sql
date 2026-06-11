-- =======================================================================================
-- Bài 1: Trong cơ sở dữ liệu quản lý bán hàng, tạo các thủ tục nội tại lấy dữ liệu từ 
-- bảng với các yêu cầu sau.
-- =======================================================================================
use QLBanHang
-- 1. Xây dựng thủ tục lấy ra toàn bộ các vật tư có trong bảng VATTU với tên 
-- spud_LayDanhSachVATTU, thủ tục này không có tham số nào. Hành động duy nhất trong 
-- thủ tục này đơn giản chỉ là một câu lệnh truy vấn SELECT * FROM VATTU có sắp xếp 
-- theo thứ tự tên vật tư từ A-Z.
create procedure spud_LayDanhSachVATTU 
as
begin 
select * from VATTU order by TenVTu asc
end 
go
---------------
exec spud_LayDanhSachVATTU

-- 2. Xây dựng thủ tục liệt kê các cột dữ liệu trong bảng NHACC với tên 
-- spud_LayDanhSach_NHACC, thủ tục này có một tham số là mancc có giá trị mặc định 
-- là NULL. Thủ tục thực hiện lấy toàn bộ các nhà cung cấp trong bảng NHACC nếu tham số 
-- mancc không được truyền giá trị, ngược lại, lấy ra thông tin nhà cung cấp với mã 
-- được truyền vào.
create procedure spud_LayDanhSach_NHACC 
@mancc char(3) = null
as
begin 
	if @mancc is null
		select * from NHACC
	else 
	select * from NHACC where MaNhaCc=@mancc
end
go
----------
exec spud_LayDanhSach_NHACC
exec spud_LayDanhSach_NHACC 'C03'

-- 3. Xây dựng thủ tục liệt kê các cột dữ liệu trong hai bảng dữ liệu PXUAT và CTXUAT 
-- và có thêm một cột TENVITU trong bảng VATTU với tên là spud_PXUAT_BcaoPxuat gồm 
-- có 1 tham số vào là: Số phiếu xuất muốn lọc dữ liệu với giá trị mặc định là NULL. 
-- Tuy nhiên nếu lúc gọi thực hiện thủ tục mà không truyền giá trị số phiếu xuất vào 
-- thì xem như không lọc gì cả, khi đó thủ tục sẽ liệt kê tất cả các phiếu xuất đang 
-- có trong bảng PXUAT.
alter procedure spud_PXUAT_BcaoPxuat 
	@soPhieu char(5) = null
as
begin
	if @soPhieu is null
		select *, TenVTu from PXUAT join CTPXUAT on PXUAT.SoPx=CTPXUAT.SoPx join VATTU on CTPXUAT.Mavtu=VATTU.Mavtu
	else 
		select *, TenVTu from PXUAT join CTPXUAT on PXUAT.SoPx=CTPXUAT.SoPx join VATTU on CTPXUAT.Mavtu=VATTU.Mavtu where PXuat.SoPx = @soPhieu
end
---------------
exec spud_PXUAT_BcaoPxuat 
exec spud_PXUAT_BcaoPxuat @soPhieu = 'X002'

-- 4. Xây dựng thủ tục liệt kê các cột dữ liệu trong hai bảng dữ liệu PNHAP và CTNHAP 
-- và có thêm một cột TENVITU trong bảng VATTU với tên là spud_PNHAP_BcaoPNhap gồm 
-- có 1 tham số vào là: Số phiếu nhập muốn lọc dữ liệu với giá trị mặc định là NULL. 
-- Tuy nhiên nếu lúc gọi thực hiện thủ tục mà không truyền giá trị số phiếu nhập vào 
-- thì xem như không lọc gì cả, khi đó thủ tục sẽ liệt kê tất cả các phiếu nhập đang 
-- có trong bảng PNHAP.
create procedure spud_PNHAP_BcaoPNhap 
	@soPhieuNhap char(5) = null
as
begin
	if @soPhieuNhap is null
		select *, TenVTu from PNHAP join CTPNHAP on PNHAP.SoPn=CTPNHAP.SoPn join VATTU on CTPNHAP.Mavtu=VATTU.Mavtu
	else 
		select *, TenVTu from PNHAP join CTPNHAP on PNHAP.SoPn=CTPNHAP.SoPn join VATTU on CTPNHAP.Mavtu=VATTU.Mavtu where PNHAP.SoPn = @soPhieuNhap
end
-----------------
exec spud_PNHAP_BcaoPNhap
exec spud_PNHAP_BcaoPNhap @soPhieuNhap='N004'

-- 5. Xây dựng thủ tục liệt kê các cột dữ liệu trong bảng TONKHO có thể hiện thêm 
-- cột TENVITU trong bảng VATTU với tên spud_TONKHO_BcaoTonkho gồm có 1 tham số vào là: 
-- Năm tháng muốn lọc dữ liệu.
create procedure spud_TONKHO_BcaoTonkho
@namThang char(8) 
as
begin 
	if @namThang is null
	 print N'Phải lọc theo năm - tháng'
	else 
	  select *, TenVTu from TONKHO join VATTU on TONKHO.Mavtu=VATTU.Mavtu where NamThang=@namThang
end
---------------
exec spud_TONKHO_BcaoTonkho
exec spud_TONKHO_BcaoTonkho '201401'

-- =======================================================================================
-- Bài 2: Trong cơ sở dữ liệu quản lý bán hàng, tạo các thủ tục nội tại cập nhật dữ liệu 
-- trong bảng VATTU. Các thủ tục này có kiểm tra các ràng buộc dữ liệu và thông 
-- báo ra các lỗi rõ ràng khi dữ liệu vi phạm các ràng buộc.
-- =======================================================================================

-- 1. Xây dựng thủ tục thêm mới dữ liệu vào bảng VATTU với tên spud_VATTU_Them 
-- gồm có 4 tham số vào chính là giá trị thêm mới cho các cột trong bảng VATTU: 
-- mã vật tư, tên vật tư, đơn vị tính và phần trăm. Trong đó cần kiểm tra các ràng 
-- buộc dữ liệu phải hợp lệ trước khi thực hiện lệnh INSERT INTO để thêm dữ liệu 
-- vào bảng VATTU.
--     * Mã vật tư phải chưa có trong bảng VATTU
--     * Tên vật tư phải duy nhất trong bảng VATTU
--     * Đơn vị tính mặc định là chuỗi rỗng
--     * 0 <= Phần trăm <= 100
alter procedure spud_VATTU 
@maVT char(5) , @TenVT nvarchar(30),@DonVi nvarchar(10) = N'', @phanTram real
as
begin 
	if EXISTS (select Mavtu from VATTU where Mavtu=@maVT) 
		begin print N'Mã vật tư đã tổn tại' end 
	else if EXISTS (select TenVTu from VATTU where TenVTu=@TenVT) 
		begin print N'Tên Vật tư phải là duy nhất' end
	else if @phanTram <0  or  @phanTram >100 
		begin print N'Phần trăm phải nằm trong khoảng 0<=PhanTram<=100' end 
	else 
		insert into VATTU(Mavtu,TenVTu,Dvtinh,Phantram) values (@maVT,@TenVT,@DonVi,@phanTram)
		print N'Thêm thành công vật tư mới'
end
----------------------
exec spud_VATTU 'DD10','Vật tư thêm mới',N'Cái',60

-- 2. Xây dựng thủ tục xóa một vật tư có trong bảng VATTU với tên spud_VATTU_Xoa 
-- gồm có 1 tham số vào chính là mã vật tư cần xóa. Trong đó cần kiểm tra ràng 
-- buộc dữ liệu trước khi thực hiện lệnh DELETE để xóa dữ liệu trong bảng VATTU.
--     * Mã vật tư phải chưa có trong bảng CTDONDH
--     * Mã vật tư phải chưa có trong bảng CTPNHAP
--     * Mã vật tư phải chưa có trong bảng CTPXUAT
--     * Mã vật tư phải chưa có trong bảng TONKHO
create procedure spud_VATTU_Xoa
@maVTXoa char(5)
as
begin 
	if exists (select Mavtu from CTDONDH where Mavtu=@maVTXoa) 
	or exists (select Mavtu from CTPNHAP where Mavtu=@maVTXoa) 
	or exists (select Mavtu from CTPXUAT where Mavtu=@maVTXoa) 
	or exists (select Mavtu from TONKHO where Mavtu=@maVTXoa) 
	begin print N'Không thể xóa'end
	else if not exists (select Mavtu from VATTU where Mavtu=@maVTXoa)
	begin print N'Mã vật tư không tồn tại'end
	else 
	begin
		Delete VATTU where Mavtu=@maVTXoa
		print N'Xóa thành công vật tư mã:' + @MaVTXoa
	end
end  
-------------------------
select * from VATTU
exec spud_VATTU_Xoa 'MMMM'
exec spud_VATTU_Xoa 'DD01'

-- 3. Xây dựng thủ tục sửa đổi vật tư trong bảng VATTU với tên spud_VATTU_Sua 
-- gồm có tối đa 4 tham số vào chính là giá trị cần thay đổi của các cột trong bảng 
-- VATTU (trừ cột mã vật tư): mã vật tư, tên vật tư, đơn vị tính và phần trăm. Trong 
-- thủ tục chỉ thực hiện lệnh UPDATE SET để cập nhật dữ liệu vào bảng VATTU với 
-- các giá trị tương ứng.
create procedure spud_VATTU_Sua
@maVT char(5),@TenVT Nvarchar(30)=null, @DonVi nvarchar(10)=null, @PhanTram real =null
as
begin 
	if exists (select Mavtu from VATTU where Mavtu=@maVT)
	begin 
	update VATTU
	set TenVTu=ISNULL(@TenVT,TenVTu), 
		Dvtinh= isnull(@DonVi,Dvtinh),
		Phantram=ISNULL(@PhanTram,Phantram)
	where Mavtu=@maVT
	end
	else 
	begin print N'Không tồn tại vật tư để sửa' end
end
---------------
select * from VATTU
exec spud_VATTU_Sua 'DD01',N'Tên vật tư DD01',null,100

-- =======================================================================================
-- Bài 3: Trong cơ sở dữ liệu QLBanHang (quản lý bán hàng), tạo các thủ tục nội tại 
-- tính toán với các yêu cầu sau.
-- =======================================================================================

-- 1. Xây dựng thủ tục tính thành tiền của vật tư trong một đơn đặt hàng với tên 
-- spud_DONDH_TinhThanhtien gồm có 2 tham số vào là: Số đặt hàng và Mã vật 
-- tư, 1 tham số ra là: Thành tiền đặt hàng của một vật tư theo số đặt hàng.
create procedure spud_DONDH_TinhThanhtien
@soDatHang char(5), @maVT char(5), @thanhTien money output
as
begin 
	select @thanhTien = max(SlDat * DGNhap)
	from CTDONDH join CTPNHAP on CTDONDH.Mavtu=CTPNHAP.Mavtu
	where CTDONDH.Mavtu = @maVT and SoDH=@soDatHang
end
--------
declare @TT money 
exec spud_DONDH_TinhThanhtien 'D001','DD01',@thanhTien= @TT output 
print N'Giá trị thành tiền: '+ convert(varchar(20),@TT)

-- 2. Xây dựng thủ tục tính tổng số lượng hàng đã nhập với tên 
-- spud_PNHAP_TinhTongSLNHang gồm có 2 tham số vào là: Số đặt hàng và Mã vật 
-- tư, 1 tham số ra là: Tổng số lượng đã nhập hàng của một vật tư theo một số đặt 
-- hàng.
create procedure spud_PNHAP_TinhTongSLNHang
@soDH char(5), @maVT char(5), @tongSoNhap int output
as
begin 
	if exists (select Mavtu from CTPNHAP join PNHAP on CTPNHAP.SoPn=PNHAP.SoPn where SoDH=@soDH and Mavtu=@maVT)
	begin
	select @tongSoNhap= SUM(SLNhap)
	from CTPNHAP join PNHAP on CTPNHAP.SoPn=PNHAP.SoPn
	where SoDH=@soDH and Mavtu=@maVT
	end
	else 
		print N'Mã vật tư không tồn tại '
end
------
declare @tong int
exec spud_PNHAP_TinhTongSLNHang 'D001','DD01',@tong output
print @tong

-- 3. Xây dựng thủ tục tính số lượng đầu kỳ của một vật tư với tên 
-- spud_TONKHO_TinhSLDau gồm có 2 tham số vào là: Năm tháng và Mã vật tư, 1 
-- tham số ra là: Số lượng đầu kỳ của một vật tư theo năm tháng truyền vào.

create procedure spud_TONKHO_TinhSLDau
@namThang varchar(10), @maVT char(5), @soLuong int output
as
begin 
	select @soLuong = SLDau
	from TONKHO 
	where Mavtu=@maVT and NamThang=@namThang
end
---------
declare @sl int
exec spud_TONKHO_TinhSLDau '201402','DD01',@sl output 
print @sl

-- 4. Xây dựng thủ tục tính tổng số lượng nhập và tổng số lượng xuất của một vật tư 
-- với tên spud_TONKHO_TinhTongNX gồm có 2 tham số vào là: Năm tháng và Mã 
-- vật tư, 2 tham số ra là: Tổng số lượng nhập và Tổng số lượng xuất của một vật tư 
-- theo năm tháng truyền vào.
create procedure spud_TONKHO_TinhTongNX
@namThang char(10), @maVT char(5), @TongNhap int output, @TongXuat int output
as
begin 
	select @TongNhap= TongSLN,@TongXuat=TongSLX
	from TONKHO
	where Mavtu=@maVT and NamThang=@namThang
end
-----
declare @TN int, @TX int
exec spud_TONKHO_TinhTongNX '201401','DD01',@TN output,@TX output
print N'Tổng nhập: ' + convert(varchar(10),@TN) + N' \nTổng xuất: ' +convert(varchar(10),@TX)

-- 5. Sử dụng lại các thủ tục spud_TONKHO_TinhSLDau, spud_TONKHO_TinhTongNX của 
-- câu c và d để xây dựng thủ tục tính số lượng tồn kho cuối kỳ của một vật tư với tên 
-- spud_TONKHO_TinhSLCuoi gồm có 2 tham số vào là: Năm tháng và Mã vật tư, 1 
-- tham số ra là: Số lượng cuối kỳ của một vật tư theo năm tháng truyền vào.

create procedure spud_TONKHO_TinhSLCuoi
@NamThang char(10), @maVT char(5), @SoLuongCuoi int output
as
begin 
	declare @slD int
	exec spud_TONKHO_TinhSLDau @NamThang,@maVT, @slD output
	declare @tongNhap int,@tongXuat int 
	exec spud_TONKHO_TinhTongNX @NamThang,@maVT,@tongNhap output, @tongXuat output 
	set @SoLuongCuoi = @slD + @tongNhap - @tongXuat
end
----- 
declare @TC int
exec spud_TONKHO_TinhSLCuoi '201401','DD01',@TC output
print @TC