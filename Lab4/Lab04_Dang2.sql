----------------------------------SỬ DỤNG HÀM TRONG TRUY VẤN DỮ LIỆU ---------------------------------------

-- 1. Liệt kê danh sách sinh viên gồm các thông tin sau: Họ và tên sinh viên, Giới tính, Tuổi, Mã khoa. Trong đó Giới tính hiển thị ở dạng Nam/Nữ tuỳ theo giá trị của field Phai là True hay False, Tuổi sẽ được tính bằng cách lấy năm hiện hành trừ cho năm sinh. Danh sách sẽ được sắp xếp theo thứ tự Tuổi giảm dần.

select concat(HoSV, ' ', TenSV) as HoTenSV, case when Phai=1 then N'Nữ' else N'Nam' end --IIF(Phai = 1, N'Nam', N'Nữ') AS GioiTinh
, (YEAR(GETDATE()) -YEAR(NgaySinh)) as Tuoi  from SinhVien order by Tuoi DESC
-- (Xét trường hợp xét đúng theo ngày)

-- 2. Danh sách sinh viên sinh vào tháng 2 năm 1994, gồm các thông tin: Họ tên sinh viên, Phái, Ngày sinh. Trong đó, Ngày sinh chỉ lấy giá trị ngày của trường NGAYSINH.

-- 3. Sắp xếp dữ liệu giảm dần theo cột Ngày sinh.

-- 4. Cho biết thông tin về mức học bổng của các sinh viên, gồm: Mã sinh viên, Phái, Mã khoa, Mức học bổng. Trong đó, mức học bổng sẽ hiển thị là "Học bổng cao" nếu giá trị của field học bổng lớn hơn 500,000 và ngược lại hiển thị là "Mức trung bình".

-- 5. Cho biết điểm thi của các sinh viên, gồm các thông tin: Họ tên sinh viên, Mã môn học, Điểm. Kết quả sẽ được sắp xếp theo thứ tự Họ tên sinh viên và mã môn học tăng dần.

-- 6. Danh sách sinh viên của khoa Anh văn, điều kiện lọc phải sử dụng tên khoa, gồm các thông tin sau: Họ tên sinh viên, Giới tính, Tên khoa. Trong đó, Giới tính sẽ hiển thị dạng Nam/Nữ.

-- 7. Liệt kê bảng điểm của sinh viên khoa Tin Học, gồm các thông tin: Tên khoa, Họ tên sinh viên, Tên môn học, Số tiết, Điểm.

-- 8. Kết quả học tập của sinh viên, gồm các thông tin: Họ tên sinh viên, Mã khoa, Tên môn học, Điểm thi, Loại. Trong đó, Loại sẽ là Giỏi nếu điểm thi > 8, từ 6 đến 8 là Khá, nhỏ hơn 6 là Trung bình.