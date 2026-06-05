--------------------- Sử dụng tham số trong truy vấn ---------------------
-- 1 cho biết danh sách sinh viên của 1 khoa gồm mã sinh viên, họ tên, Giới Tính, tên khoa. Trong đó giá trị mã khoa cần xem sẽ được người dùng nhập vào khi truy vána
declare @MaKhoaCanXem char(4) = 'TH'
select MaSV,HoSV,TenSV Phai,TenKH from SinhVien join Khoa on SinhVien.MaKH=Khoa.MaKH
where SinhVien.MaKH=@MaKhoaCanXem

-- 2 Liệt kê danh sách sinh viên có điểm môn Cơ Sở Dữ Liệu lớn hơn 1 giá trị bất kì được nhập vào khi truy vấn. Mã sinh viên, tên sinh viên, tên môn, điểm
declare @diemYC float = 5
select SinhVien.MaSV, TenSV,TenMH,Diem from SinhVien join Ketqua on SinhVien.MaSV=Ketqua.MaSV join MonHoc on Ketqua.MaMH= MonHoc.MaMH
where Diem > @diemYC and TenMH= N'Cơ sở dữ liệu'

-- Cho kết quả các sinh viên theo môn , tên môn cần xem kết quả sẽ được nhập vào khi thực thi truye vấn. Thông tin hiển thị gồm Mã sinh viên, tên khoa, tên môn, điểm 
declare @tenMon nvarchar(20) = N'Cơ sở dữ liệu'
select SinhVien.MaSV, TenKH,TenMH,Diem from SinhVien join Ketqua on SinhVien.MaSV=Ketqua.MaSV join Khoa on SinhVien.MaKH=Khoa.MaKH join MonHoc on Ketqua.MaMH = MonHoc.MaMH
where TenMH=@tenMon