use QLSINHVIEN
--- Bài 1: 
-- 1 
select * from MonHoc

-- 2
select MaSV, HoSV, TenSV, HocBong from SinhVien order by MaSV  

--3 
select MaSV, TenSV, Phai,NgaySinh from SinhVien order by MaSV 

-- 4 Tăng dần ngày sinh và giảm dần học bổng
select CONCAT(HoSV, ' ', TenSV )as HoTenSinhVien, NgaySinh, HocBong  from SinhVien order by NgaySinh, HocBong DESC

-- 5 Môn học tên bắt đầu bằng chữ T
select * from MonHoc where TenMH like 'T%'

-- 6 Tên sinh viên kết thúc bằng chữ i 
select CONCAT(HoSV, ' ', TenSV) as HoVaTen, NgaySinh, Phai from SinhVien where TenSV like '%i'

-- 7  (% đại diện 1 chuỗi bất kì, _ đại diện 1 ký tự), luôn phải có chuỗi % để 
select * from Khoa where TenKH like '_N%'

-- 8 Liệt kê sinh viên có chữ Thị 
select * from SinhVien where HoSV like N'%Thị%'

-- 9 Liệt kê những sinh viên có tên bắt đầu bằng chữ cái từ a đến m 
select MaSV , CONCAT(HoSV, ' ', TenSV) as HoVaTen,Phai, HocBong from SinhVien where TenSV like '[a-m]%'

-- 10 Danh sách sinh viên tên có chứ ký tự nằm trong khoảng từ a-m và sắp xếp theo tăng dần tên sinh viên
select CONCAT(HoSV ,' ', TenSV) as HoTenSV,NoiSinh, HocBong from SinhVien 
where TenSV like '%[a-m]%'
order by HoTenSV asc

-- 11. Cho biết danh sách các sinh viên của khoa Anh văn, 
--gồm các thông tin sau: Mã sinh viên, Họ tên sinh viên, Ngày sinh, Mã khoa.
select MaSV,CONCAT(HoSV, ' ' , TenSV), NgaySinh, MaKH from SinhVien
where MaKH= 'AV'

-- 12.Liệt kê danh sách sinh viên của khoa Vật Lý, gồm : Mã sinh viên, Họ tên sinh viên, Ngày sinh. 
--Danh sách sẽ được sắp xếp theo thứ tự Ngày sinh giảm dần.
select MaSV, concat(HoSV, ' ', TenSV), NgaySinh from SinhVien order by NgaySinh desc

-- 13. Cho biết danh sách các sinh viên có học bổng lớn hơn 500,000, gồm các thông tin: 
--Mã sinh viên, Họ tên sinh viên, Mã khoa, Học bổng. Danh sách sẽ được sắp xếp theo thứ tự Mã khoa giảm dần.
select MaSV, concat(HoSV, ' ', TenSV), MaKH, HocBong from SinhVien
where HocBong > 500000

-- 14. Liệt kê danh sách sinh viên sinh vào ngày 20/12/1987, gồm các thông tin: 
--Họ tên sinh viên, Mã khoa, Học bổng.
select  concat(HoSV, ' ', TenSV), MaKH, HocBong, NgaySinh from SinhVien
where NgaySinh = '19871220'

-- 15. Cho biết các sinh viên sinh sau ngày 20/12/1977, gồm các thông tin:
--Họ tên sinh viên, Ngày sinh, Nơi sinh, Học bổng. Danh sách sẽ được sắp xếp theo thứ tự ngày sinh giảm dần.
select  concat(HoSV, ' ', TenSV), NgaySinh, NoiSinh, HocBong from SinhVien
where NgaySinh > '19871220'
order by NgaySinh desc

-- -- 16. Liệt kê các sinh viên có học bổng lớn hơn 100,000 và sinh ở Tp HCM, gồm các thông tin: 
--Họ tên sinh viên, Mã khoa, Nơi sinh, Học bổng.
select  concat(HoSV, ' ', TenSV), NgaySinh, NoiSinh, HocBong from SinhVien
where HocBong >100000 and NoiSinh =N'Tp.HCM'

-- 17. Danh sách các sinh viên của khoa Anh văn và khoa Triết, gồm các thông tin: 
-- Mã sinh viên, Mã khoa, Phái.
select MaSV, MaKH, Phai from SinhVien
where MaKH='AV' or MaKH='TR' 

-- 18. Cho biết những sinh viên có ngày sinh từ ngày 01/01/1986 đến ngày 05/06/1992, gồm các thông tin: 
--Mã sinh viên, Ngày sinh, Nơi sinh, Học bổng.
select MaSV, NgaySinh, NoiSinh, HocBong from SinhVien
where NgaySinh >= '19860101' and NgaySinh <= '19920605' 

-- 19. Danh sách những sinh viên có học bổng từ 200,000 đến 800,000, gồm các thông tin: Mã sinh viên, Ngày sinh, Phái, Mã khoa.
select MaSV, NgaySinh,Phai,MaKH from SinhVien
where HocBong >=200000 and HocBong >= 800000

-- 20. Cho biết những môn học có số tiết lớn hơn 40 và nhỏ hơn 60, gồm các thông tin: Mã môn học, Tên môn học, Số tiết.
select MaMH, TenMH, Sotiet from MonHoc
where Sotiet >40 and Sotiet<60

-- 21. Liệt kê những sinh viên nam của khoa Anh văn, gồm các thông tin: Mã sinh viên, Họ tên sinh viên, Phái.
select MaSV, concat(HoSV, ' ',TenSV )as HoVaTen, Phai from SinhVien
where Phai=0

-- 22. Danh sách sinh viên có nơi sinh ở Hà Nội và ngày sinh sau ngày 01/01/1990, gồm các thông tin: Họ sinh viên, Tên sinh viên, Nơi sinh, Ngày sinh.
select HoSV,TenSV, NoiSinh,NgaySinh from SinhVien
where NoiSinh= N'Hà Nội' and NgaySinh>='19900101'

-- 23. Liệt kê những sinh viên nữ, tên có chứa chữ N.
select *from SinhVien
where Phai=1 and TenSV like '%N%'

-- 24. Danh sách các nam sinh viên khoa Tin học có ngày sinh sau ngày 30/5/1986.
select * from SinhVien
where Phai=0 and MaKH='TH' and NgaySinh>'19860530'

-- 25. Liệt kê danh sách sinh viên gồm các thông tin sau: Họ và tên sinh viên, Giới tính, Ngày sinh. Trong đó Giới tính hiển thị ở dạng Nam/Nữ tuỳ theo giá trị của field Phai là True hay False.
select  concat(HoSV, ' ', TenSV) as HoVaTen, IIF(Phai=0,N'Nam',N'Nữ')as GioiTinh, NgaySinh from SinhVien

-- 26. Cho biết danh sách sinh viên gồm các thông tin sau: Mã sinh viên, Tuổi, Nơi sinh, Mã khoa. Trong đó Tuổi sẽ được tính bằng cách lấy năm hiện hành trừ cho năm sinh.
select MaSV, (YEAR(GETDATE())- YEAR(NgaySinh)) as N'Tuổi',NoiSinh,MaKH from SinhVien

-- 27. Cho biết những sinh viên có tuổi lớn hơn 20, thông tin gồm: Họ tên sinh viên, Tuổi, Học bổng.
select MaSV, (YEAR(GETDATE())- YEAR(NgaySinh)) as N'Tuổi', NoiSinh, HocBong from SinhVien
where (YEAR(GETDATE())- YEAR(NgaySinh)) >20

-- 28. Danh sách những sinh viên có tuổi từ 20 đến 30, thông tin gồm: Họ tên sinh viên, Tuổi, Tên khoa.
select CONCAT(HoSV, ' ',TenSV ) as HoTenSV, (YEAR(GETDATE())- YEAR(NgaySinh)) as N'Tuổi', Khoa.TenKH 
from SinhVien join Khoa on SinhVien.MaKH=Khoa.MaKH 
where (YEAR(GETDATE())- YEAR(NgaySinh)) >= 20 and (YEAR(GETDATE())- YEAR(NgaySinh))<= 30