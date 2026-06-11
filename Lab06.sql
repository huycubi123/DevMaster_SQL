-- =======================================================================================
-- Bài 1: Trong cơ sở dữ liệu quản lý bán hàng, tạo các thủ tục nội tại lấy dữ liệu từ 
-- bảng với các yêu cầu sau.
-- =======================================================================================

-- 1. Xây dựng thủ tục lấy ra toàn bộ các vật tư có trong bảng VATTU với tên 
-- spud_LayDanhSachVATTU, thủ tục này không có tham số nào. Hành động duy nhất trong 
-- thủ tục này đơn giản chỉ là một câu lệnh truy vấn SELECT * FROM VATTU có sắp xếp 
-- theo thứ tự tên vật tư từ A-Z.

-- 2. Xây dựng thủ tục liệt kê các cột dữ liệu trong bảng NHACC với tên 
-- spud_LayDanhSach_NHACC, thủ tục này có một tham số là mancc có giá trị mặc định 
-- là NULL. Thủ tục thực hiện lấy toàn bộ các nhà cung cấp trong bảng NHACC nếu tham số 
-- mancc không được truyền giá trị, ngược lại, lấy ra thông tin nhà cung cấp với mã 
-- được truyền vào.

-- 3. Xây dựng thủ tục liệt kê các cột dữ liệu trong hai bảng dữ liệu PXUAT và CTXUAT 
-- và có thêm một cột TENVITU trong bảng VATTU với tên là spud_PXUAT_BcaoPxuat gồm 
-- có 1 tham số vào là: Số phiếu xuất muốn lọc dữ liệu với giá trị mặc định là NULL. 
-- Tuy nhiên nếu lúc gọi thực hiện thủ tục mà không truyền giá trị số phiếu xuất vào 
-- thì xem như không lọc gì cả, khi đó thủ tục sẽ liệt kê tất cả các phiếu xuất đang 
-- có trong bảng PXUAT.

-- 4. Xây dựng thủ tục liệt kê các cột dữ liệu trong hai bảng dữ liệu PNHAP và CTNHAP 
-- và có thêm một cột TENVITU trong bảng VATTU với tên là spud_PNHAP_BcaoPNhap gồm 
-- có 1 tham số vào là: Số phiếu nhập muốn lọc dữ liệu với giá trị mặc định là NULL. 
-- Tuy nhiên nếu lúc gọi thực hiện thủ tục mà không truyền giá trị số phiếu nhập vào 
-- thì xem như không lọc gì cả, khi đó thủ tục sẽ liệt kê tất cả các phiếu nhập đang 
-- có trong bảng PNHAP.

-- 5. Xây dựng thủ tục liệt kê các cột dữ liệu trong bảng TONKHO có thể hiện thêm 
-- cột TENVITU trong bảng VATTU với tên spud_TONKHO_BcaoTonkho gồm có 1 tham số vào là: 
-- Năm tháng muốn lọc dữ liệu.


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

-- 2. Xây dựng thủ tục xóa một vật tư có trong bảng VATTU với tên spud_VATTU_Xoa 
-- gồm có 1 tham số vào chính là mã vật tư cần xóa. Trong đó cần kiểm tra ràng 
-- buộc dữ liệu trước khi thực hiện lệnh DELETE để xóa dữ liệu trong bảng VATTU.
--     * Mã vật tư phải chưa có trong bảng CTDONDH
--     * Mã vật tư phải chưa có trong bảng CTPNHAP
--     * Mã vật tư phải chưa có trong bảng CTPXUAT
--     * Mã vật tư phải chưa có trong bảng TONKHO

-- 3. Xây dựng thủ tục sửa đổi vật tư trong bảng VATTU với tên spud_VATTU_Sua 
-- gồm có tối đa 4 tham số vào chính là giá trị cần thay đổi của các cột trong bảng 
-- VATTU (trừ cột mã vật tư): mã vật tư, tên vật tư, đơn vị tính và phần trăm. Trong 
-- thủ tục chỉ thực hiện lệnh UPDATE SET để cập nhật dữ liệu vào bảng VATTU với 
-- các giá trị tương ứng.


-- =======================================================================================
-- Bài 3: Trong cơ sở dữ liệu QLBanHang (quản lý bán hàng), tạo các thủ tục nội tại 
-- tính toán với các yêu cầu sau.
-- =======================================================================================

-- 1. Xây dựng thủ tục tính thành tiền của vật tư trong một đơn đặt hàng với tên 
-- spud_DONDH_TinhThanhtien gồm có 2 tham số vào là: Số đặt hàng và Mã vật 
-- tư, 1 tham số ra là: Thành tiền đặt hàng của một vật tư theo số đặt hàng.

-- 2. Xây dựng thủ tục tính tổng số lượng hàng đã nhập với tên 
-- spud_PNHAP_TinhTongSLNHang gồm có 2 tham số vào là: Số đặt hàng và Mã vật 
-- tư, 1 tham số ra là: Tổng số lượng đã nhập hàng của một vật tư theo một số đặt 
-- hàng.

-- 3. Xây dựng thủ tục tính số lượng đầu kỳ của một vật tư với tên 
-- spud_TONKHO_TinhSLDau gồm có 2 tham số vào là: Năm tháng và Mã vật tư, 1 
-- tham số ra là: Số lượng đầu kỳ của một vật tư theo năm tháng truyền vào.

-- 4. Xây dựng thủ tục tính tổng số lượng nhập và tổng số lượng xuất của một vật tư 
-- với tên spud_TONKHO_TinhTongNX gồm có 2 tham số vào là: Năm tháng và Mã 
-- vật tư, 2 tham số ra là: Tổng số lượng nhập và Tổng số lượng xuất của một vật tư 
-- theo năm tháng truyền vào.

-- 5. Sử dụng lại các thủ tục spud_TONKHO_TinhSLDau, spud_TONKHO_TinhTongNX của 
-- câu c và d để xây dựng thủ tục tính số lượng tồn kho cuối kỳ của một vật tư với tên 
-- spud_TONKHO_TinhSLCuoi gồm có 2 tham số vào là: Năm tháng và Mã vật tư, 1 
-- tham số ra là: Số lượng cuối kỳ của một vật tư theo năm tháng truyền vào.