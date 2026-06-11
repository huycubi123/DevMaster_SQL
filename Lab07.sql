-- =======================================================================================
-- Bài 1: Tạo Trigger khi thêm mới dữ liệu dùng để kiểm tra các ràng buộc toàn vẹn
-- dữ liệu như yêu cầu bên dưới.
-- =======================================================================================

-- 1. Xây dựng trigger khi thêm mới dữ liệu vào bảng PNHAP với tên tg_PNHAP_Them. 
-- Trong đó cần kiểm tra các ràng buộc dữ liệu phải hợp lệ.
--     * Số đặt hàng phải có trong bảng DONDH
--     * Ngày nhập hàng phải sau ngày đặt hàng.

-- 2. Xây dựng trigger khi thêm mới dữ liệu vào bảng CTPNHAP với tên tg_CTPNHAP_Them. 
-- Trong đó cần kiểm tra các ràng buộc dữ liệu phải hợp lệ.
--     * Mã vật tư phải có trong bảng CTDONDH ứng với số đặt hàng của phiếu nhập
--     * Số lượng nhập hàng <= (Số lượng đặt – Tổng số lượng đã nhập vào trước đó)


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