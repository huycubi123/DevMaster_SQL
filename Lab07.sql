-- =======================================================================================
-- Bài 1: Tạo Trigger khi thêm mới dữ liệu dùng để kiểm tra các ràng buộc toàn vẹn
-- dữ liệu như yêu cầu bên dưới.
-- =======================================================================================

-- 1. Xây dựng trigger khi thêm mới dữ liệu vào bảng PNHAP với tên tg_PNHAP_Them. 
-- Trong đó cần kiểm tra các ràng buộc dữ liệu phải hợp lệ.
--     * Số đặt hàng phải có trong bảng DONDH
--     * Ngày nhập hàng phải sau ngày đặt hàng.
create trigger tg_PNHAP_Them on PNHAP
for insert 
as begin 
	if not exists (
	select * from inserted join DONDH on inserted.SoDH=DONDH.SoDH 
	where inserted.SoDH=DONDH.SoDH
	)
	begin 
		print N'Số đặt hàng phải có trong bảng DONDH'
		rollback transaction 
		return
	end
	if exists (
	select * from inserted join DONDH on inserted.SoDH=DONDH.SoDH
	where inserted.NgayNhap < DONDH.NgayDH
	)
	begin 
		print N'Ngày nhập phải sau ngày đặt hàng'
		rollback transaction 
		return 
	end
end
--------------
insert into PNHAP values ('N100', '2016-01-20', 'D001')
insert into PNHAP values ('N300', '2013-01-20', 'D001')

-- 2. Xây dựng trigger khi thêm mới dữ liệu vào bảng CTPNHAP với tên tg_CTPNHAP_Them. 
-- Trong đó cần kiểm tra các ràng buộc dữ liệu phải hợp lệ.
--     * Mã vật tư phải có trong bảng CTDONDH ứng với số đặt hàng của phiếu nhập
--     * Số lượng nhập hàng <= (Số lượng đặt – Tổng số lượng đã nhập vào trước đó) (Sl nhập mới cộng số lượng có sẵn = số tổng sau insert phải < SlDat)
create trigger tg_CTPNHAP_Them on CTPNHAP
for insert 
as begin 
	if not exists (
		select * from inserted join CTDONDH on inserted.Mavtu=CTDONDH.Mavtu join PNHAP on inserted.SoPn=PNHAP.SoPn
		where inserted.Mavtu=CTDONDH.Mavtu and CTDONDH.SoDH=PNHAP.SoDH
	)
	begin 
		print N'Mã vật tư phải có trong bảng CTDONDH ứng với số đặt hàng của phiếu nhập'
		rollback transaction 
		return
	end
	if exists (
		select *
		from inserted i join CTDONDH c on i.Mavtu = c.Mavtu join PNHAP p on i.SoPn = p.SoPn and c.SoDH = p.SoDH
		where
			(
				select isnull(sum(a.SLNhap),0)
				from CTPNHAP a join PNHAP b on a.SoPn=b.SoPn
				where a.Mavtu=i.Mavtu and b.SoDH=p.SoDH
			) > c.SLDat
	)    -- Trigger hoạt động sau khi đã chèn nên SLNhap đang xét đã bao gồm cả cái đã thêm rồi (ở bảng PNHAP)
	begin 
		print N'Số lượng nhập vượt quá số lượng đặt'
		rollback transaction 
		return
	end
end
---------
select * from CTDONDH where SoDH='D001' and Mavtu='DD01'
select * from CTPNHAP where Mavtu='DD01'
insert into CTPNHAP values ('N004','DD01',1,2500000)
insert into CTPNHAP values ('N004','TV32',3,2500000)


create trigger tg_CTPNHAP_Them on CTPNHAP
for insert 
as begin 
	
end

--------------------------------
ALTER TRIGGER tg_CTPNHAP_Them 
ON CTPNHAP
FOR INSERT
AS
BEGIN
	--ma vat tu phai co trong bang CTDONDH ung voi so dat hang cua phieu nhap
	--=>> so don hang trong bang CTDANDH trung voi so don hang trong bang PNHAP
    DECLARE @SoDH_CTDonHang char(4) = null
	DECLARE @SoDH_PNhap char(4)

	SELECT @SoDH_PNhap = SoDH FROM PNHAP WHERE SoPn = (SELECT SoPn FROM inserted)

	SELECT @SoDH_CTDonHang = SoDH FROM CTDONDH WHERE Mavtu = (SELECT Mavtu FROM inserted)
													AND SoDH = @SoDH_PNhap
	SELECT SoDH FROM CTDONDH WHERE Mavtu = N'TV40'
									AND SoDH = N'D004'
	IF @SoDH_CTDonHang <> @SoDH_PNhap -- @SoDH_CTDonHang = NULL
		ROLLBACK TRANSACTION

	--so luong nhap hang = so luong dat - tong so nhap vao truoc do
	--tim so luong nhap vao truoc do
	-- => tìm được các mã phieuesvaf mã vật tư cho bảng [CTNHAP]
	-- => phiếu nhập thì phải tìm từ số SoDH có mã vật tư tương ứng
	-- => Tìm SoHD tương ứng thì cần tìm trong bảng CTDONDH (ra nhiều)
	-- => Loại bỏ bằng cách tìm trong PNHAP với SoDH được lấy từ phiếu nhập SoPN của bảng inserted

	DECLARE @SLNhap int
	SELECT @SLNhap = SLNhap FROM CTPNHAP WHERE Mavtu = (SELECT Mavtu FROM inserted) AND
			SoPn = (SELECT SoPn FROM PNHAP WHERE SoDH = (SELECT SoDH FROM CTDONDH WHERE Mavtu = (SELECT Mavtu FROM inserted)))
	SELECT SLNhap FROM CTPNHAP WHERE Mavtu = 'DD01'

	SELECT * FROM [dbo].[CTDONDH] WHERE Mavtu ='DD01'
	SELECT * FROM [dbo].[PNHAP] WHERE SoDH IN (SELECT SoDH FROM [dbo].[CTDONDH] WHERE Mavtu = 'DD02')
	SELECT * FROM [dbo].[CTPNHAP] WHERE SoPn IN (SELECT SoPn FROM [dbo].[PNHAP] WHERE SoDH IN (SELECT ............

	IF @SoDH_CTDonHang <> @SoDH_PNhap
		ROLLBACK TRANSACTION
END

-- =======================================================================================
-- Bài 2: Tạo Trigger khi xóa dữ liệu dùng để kiểm tra các ràng buộc toàn vẹn dữ liệu
-- như yêu cầu bên dưới.
-- =======================================================================================

-- 1. Xây dựng trigger khi xóa dữ liệu trong bảng PXUAT với tên tg_PXUAT_Xoa. 
-- Trong đó cần thực hiện các hành động:
--     * Thực hiện tự động xóa các dòng dữ liệu liên quan bên bảng CTPXUAT.

-- 2. Xây dựng trigger khi xóa dữ liệu trong bảng PNHAP với tên tg_PNHAP_Xoa. 
-- Trong đó cần thực hiện các hành động:
--     * Thực hiện tự động xóa các dòng dữ liệu liên quan bên bảng CTPNHAP.


-- =======================================================================================
-- Bài 3: Tạo Trigger khi sửa dữ liệu dùng để kiểm tra các ràng buộc toàn vẹn dữ liệu
-- như yêu cầu bên dưới.
-- =======================================================================================

-- 1. Xây dựng trigger khi sửa dữ liệu trong bảng PNHAP với tên tg_PNHAP_Sua. 
-- Trong đó cần kiểm tra các ràng buộc dữ liệu phải hợp lệ.
--     * Không cho phép sửa đổi giá trị của các cột: số nhập hàng, số đặt hàng.
--     * Kiểm tra giá trị mới của cột ngày nhập hàng phải sau ngày đặt hàng.

-- 2. Xây dựng trigger khi sửa dữ liệu trong bảng PXUAT với tên tg_PXUAT_Sua. 
-- Trong đó cần kiểm tra các ràng buộc dữ liệu phải hợp lệ.
--     * Không cho phép sửa đổi giá trị cột số phiếu xuất.
--     * Kiểm tra giá trị mới của ngày xuất phải cùng năm tháng với giá trị cũ của 
--       ngày xuất. Nếu khác nhau thì thông báo lỗi không cho sửa đổi.


-- =======================================================================================
-- Bài 4: Tạo Trigger khi thêm mới dữ liệu dùng để kiểm tra các ràng buộc toàn vẹn
-- dữ liệu và tính toán tự động như yêu cầu bên dưới.
-- =======================================================================================

-- 1. Trong bảng PNHAP tạo thêm cột tổng trị giá có tên TONGTG với kiểu Float dùng 
-- để lưu tổng trị giá của 1 phiếu nhập hàng. Trong trigger tg_CTPNHAP_Them đã 
-- xây dựng trước đó ở phần 1b. Bổ sung thêm các tính toán tự động sau:
--     * Tăng giá trị tại cột TONGTG trong bảng PNHAP khi dữ liệu trong bảng 
--       CTPNHAP được thêm vào.
--     * Tăng giá trị tại cột TONGSLN trong bảng TONKHO khi dữ liệu trong bảng 
--       CTPNHAP được thêm vào.

-- 2. Trong bảng PXUAT tạo thêm cột tổng trị giá có tên TONGTG với kiểu Float dùng 
-- để lưu tổng trị giá của 1 phiếu xuất hàng. Xây dựng trigger khi thêm mới dữ liệu 
-- vào bảng CTPXUAT với tên tg_CTPXUAT_Them. Trong đó cần kiểm tra các ràng 
-- buộc dữ liệu phải hợp lệ và tính toán tự động như sau:
--     * Kiểm tra số phiếu xuất phải tồn tại trong bảng PXUAT.
--     * Kiểm tra mã vật tư phải tồn tại trong bảng VATTU.
--     * Kiểm tra số lượng xuất phải đủ trong bảng TONKHO.
--     * Kiểm tra đơn giá xuất phải dương. 
-- Nếu tất cả các ràng buộc ở trên đều hợp lệ thì tự động thực hiện các hành động sau đây:
--     * Tăng giá trị tại cột TONGTG trong bảng PXUAT.
--     * Tăng giá trị tại cột TONGSLX trong bảng TONKHO.


-- =======================================================================================
-- Bài 5: Tạo Trigger khi xóa dữ liệu dùng để kiểm tra các ràng buộc toàn vẹn dữ liệu
-- và tính toán tự động như yêu cầu bên dưới.
-- =======================================================================================

-- 1. Xây dựng trigger khi xóa dữ liệu trong bảng CTPXUAT với tên tg_CTPXUAT_Xoa. 
-- Trong đó cần thực hiện các tính toán như sau:
--     * Giảm giá trị tại cột TONGTG trong bảng PXUAT.
--     * Giảm giá trị tại cột TONGSLX trong bảng TONKHO.

-- 2. Xây dựng trigger khi xóa dữ liệu trong bảng CTPNHAP với tên tg_CTPNHAP_Xoa. 
-- Trong đó cần thực hiện các tính toán như sau:
--     * Giảm giá trị tại cột TONGTG trong bảng PNHAP.
--     * Giảm giá trị tại cột TONGSLN trong bảng TONKHO.


-- =======================================================================================
-- Bài 6: Xây dựng các INSTEAD OF trigger trên các bảng ảo như sau
-- =======================================================================================

-- 1. Với mỗi hành động thêm, xóa, sửa dữ liệu trong bảng ảo, xây dựng một INSTEAD 
-- OF trigger để thực hiện hành động tương ứng trên bảng chi tiết. Ví dụ, trigger 
-- tạo cho hành động thêm trên vw_VatTu sẽ thêm dữ liệu vào bảng VATTU.
--     * View vw_VatTu được xây dựng từ câu truy vấn SELECT * FROM VATTU.
--     * Cần kiểm tra các ràng buộc sau đây:
--         o Mã vật tư không được trùng.
--         o Tên vật tư là duy nhất.
--         o Đơn vị tính mặc định là chuỗi "".
--         o 0 <= Phần trăm <= 100.

-- 2. Trigger tạo cho hành động thêm trên vw_CTDONDH sẽ thêm dữ liệu vào bảng CTDONDH.
--     * View vw_CTDONDH được xây dựng từ câu truy vấn:
--       SELECT c.*, TenVTu FROM CTDONDH c INNER JOIN VATTU v ON c.mavt=v.mavt.
--     * Cần kiểm tra các ràng buộc sau đây:
--         o Số đặt hàng phải có trong bảng DONDH.
--         o Nếu mã vật tư không có trong bảng VATTU thì thêm mới vào bảng VATTU.
--         o Bộ số đặt hàng và mã vật tư phải chưa có trong CTDONDH.
--         o Số lượng đặt > 0.