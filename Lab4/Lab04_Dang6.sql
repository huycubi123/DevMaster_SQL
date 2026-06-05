------------------- Thêm dữ liệu vào cơ sở dữ liệu------------------------------------
insert into SinhVien (MaSV, HoSV,TenSV,Phai,NgaySinh,NoiSinh,MaKH,HocBong) values ('C10',N'Lê Thành',N'Nguyên',0,'19801020',N'Thành phố Hồ Chí Minh','TH',850000)
insert into MonHoc (MaMH,TenMH,Sotiet) values ('CT',N'Xử lý ảnh',45)
--- chèn điểm cho các sinh viên khoa tin học (kho hiện lỗi trùng thì xét thêm trường hợp loại bỏ)
INSERT INTO Ketqua (MaSV, MaMH, Diem)
SELECT MaSV, '06', 7
FROM SinhVien
WHERE MaKH = 'TH' and MaSV not in (select MaSV from SinhVien where MaSV='A02'); 

----------------- Xóa thông tin trong cơ sở dữ liệu ---------------------------- 

-- 1. Viết câu truy vấn để tạo bảng có tên DeleteTable gồm các thông tin sau: Mã sinh viên, Họ tên sinh viên, Phái, Ngày sinh, Nơi sinh, Tên khoa, Học bổng
select MaSV, concat(HoSV, ' ', TenSV) as HoVaTen, Phai, NgaySinh,NoiSinh,TenKH,HocBong into DeleteTable from SinhVien join Khoa on SinhVien.MaKH= Khoa.MaKH  

-- 2. Xoá tất cả những sinh viên không có học bổng trong bảng DeleteTable
Delete from DeleteTable where HocBong=0 or HocBong is null;

-- 3. Xoá tất cả những sinh viên trong bảng DeleteTable sinh vào ngày 20/12/1987
delete from DeleteTable where NgaySinh ='19871220'

-- 4. Xoá tất cả những sinh viên trong bảng DeleteTable sinh trước tháng 3 năm 1987
delete from DeleteTable where NgaySinh <'19870301'
-- 5. Xoá tất cả những sinh viên nam của khoa Tin học trong bảng DeleteTable
delete from DeleteTable where Phai=1 and TenKH=N'Tin học'

------------------------ Cập nhật thông tin ----------------------
-- Bài 8: Cập nhật thông tin trong cơ sở dữ liệu

-- 1. Cập nhật số tiết của môn Văn phạm thành 45 tiết
update MonHoc set Sotiet=45 where TenMH=N'Đồ họa ứng dụng'

-- 2. Cập nhật tên của sinh viên Trần Thị Mai thành Trần Thanh Kỳ
update SinhVien set HoSV= N'Trần Thanh', TenSV=N'Kỳ' where HoSV = N'Trần Thị' and TenSV=N'Mai'
-- 3. Cập nhật phái của sinh viên Trần Thanh Kỳ thành phái Nam
update SinhVien set Phai=1 where CONCAT(HoSV, ' ',TenSV) = N'Trần Thanh Kỳ'
-- 4. Cập nhật ngày sinh của sinh viên Trần thị thu Thuỷ thành 05/07/1990
update SinhVien set NgaySinh='1990/07/05' where CONCAT(HoSV, ' ',TenSV) = N'Trần Thị Thu Thủy'
-- 5. Tăng học bổng cho tất cả những sinh viên của khoa Anh văn thêm 100,000
update SinhVien set HocBong = HocBong +100000 where MaKH='AV'  
-- 6. Cộng thêm 5 điểm môn Trí Tuệ Nhân Tạo cho các sinh viên thuộc khoa Anh văn.
--    * Điểm tối đa của môn là 10
update Ketqua set Diem= IIF (Diem+5>10,10,Diem+5) 
		from Ketqua join SinhVien on Ketqua.MaSV=SinhVien.MaSV 
		join MonHoc on Ketqua.MaMH=MonHoc.MaMH 
		where MaKH='AV' and TenMH=N'Trí tuệ nhân tạo'


-- 7. Tăng học bổng cho sinh viên theo mô tả sau:
--    * Nếu là phái nữ của khoa Anh văn thì tăng 100,000
--    * Phái nam của khoa Tin học thì tăng 150,000
--    * Những sinh viên khác thì tăng 50,000
update SinhVien set HocBong= HocBong + case 
										when Phai=1 and MaKH='AV' then 100000 
										when Phai=0 and MaKH='TH' then 150000 
										else 50000 
										end 

-- 8. Thay đổi kết quả thi của các sinh viên theo mô tả sau:
--    * Nếu sinh viên của khoa Anh văn thì tăng điểm môn Cơ sở dữ liệu lên 2 điểm
--    * Nếu sinh viên của khoa Tin học thì giảm điểm môn Cơ sở dữ liệu xuống 1 điểm
--    * Những sinh viên của khoa khác thì không thay đổi kết quả
--    * Điểm nhỏ nhất là 0 và cao nhất là 10
update Ketqua set Diem= case when TenKH=N'Anh Văn'then IIF(Diem+2>10,10,Diem+2)														when TenKH=N'Tin học' then IIF(Diem-1<0,0,Diem-1)  
							 end  
from Ketqua join SinhVien on Ketqua.MaSV=SinhVien.MaSV join MonHoc on Ketqua.MaMH= MonHoc.MaMH join Khoa on SinhVien.MaKH=Khoa.MaKH where TenMH=N'Cơ sở dữ liệu'