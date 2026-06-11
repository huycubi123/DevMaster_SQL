-- Bài 1: Tạo các view với yêu cầu sau

-- 1. Liệt kê các sinh viên có học bổng lớn hơn 100,000 và sinh ở Tp HCM, gồm các thông tin: Họ tên sinh viên, Mã khoa, Nơi sinh, Học bổng.
create view vw_SinhVien1
as select CONCAT(HoSV, ' ', TenSV) as HoVaTen, MaKH,NoiSinh,HocBong from SinhVien where HocBong>100000 and NoiSinh= N'Thành phố Hồ Chí Minh'
Go
select * from vw_SinhVien1

-- 2. Danh sách các sinh viên của khoa Anh văn và khoa Triết, gồm các thông tin: Mã sinh viên, Mã khoa, Phái.
create view vw_SinhVienC2
as select MaSV,SinhVien.MaKH,Phai from SinhVien join Khoa on SinhVien.MaKH=Khoa.MaKH where TenKH=N'Anh Văn' and TenKH=N'Triết'
go
select *from vw_SinhVienC2

-- 3. Cho biết những sinh viên có ngày sinh từ ngày 01/01/1986 đến ngày 05/06/1992, gồm các thông tin: Mã sinh viên, Ngày sinh, Nơi sinh, Học bổng.
create view vw_SinhVienC3
as select MaSV, NgaySinh,NoiSinh,HocBong from SinhVien where NgaySinh >= '19860101' and NgaySinh <= '19920605'
go
select *from vw_SinhVienC3

-- 4. Danh sách những sinh viên có học bổng từ 200,000 đến 800,000, gồm các thông tin: Mã sinh viên, Ngày sinh, Phái, Mã khoa.
create view vw_SinhVienC4
as select MaSV,NgaySinh,Phai,MaKH from SinhVien where HocBong>=200000 and HocBong<=800000
go 
select * from vw_SinhVienC4

-- 5. Cho biết những môn học có số tiết lớn hơn 40 và nhỏ hơn 60, gồm các thông tin: Mã môn học, Tên môn học, Số tiết.
create view vw_SinhVienC5
as select MaMH,TenMH,Sotiet from MonHoc where Sotiet>40 and Sotiet<60
go
select * from vw_SinhVienC5

-- 6. Liệt kê những sinh viên nam của khoa Anh văn, gồm các thông tin: Mã sinh viên, Họ tên sinh viên, Phái.
create view vw_SinhVienC6
as select  MaSV,CONCAT(HoSV, ' ', TenSV) as HoVaTen, Phai from SinhVien join Khoa on SinhVien.MaKH=Khoa.MaKH where Phai=0 and TenKH=N'Anh Văn'
go
select * from vw_SinhVienC6

-- 7. Danh sách sinh viên có nơi sinh ở Hà Nội và ngày sinh sau ngày 01/01/1990, gồm các thông tin: Họ sinh viên, Tên sinh viên, Nơi sinh, Ngày sinh.
create view vw_SinhVienC7 
as select CONCAT(HoSV,' ', TenSV) as HoVaTen, NoiSinh,NgaySinh from SinhVien where NoiSinh=N'Hà Nội' and NgaySinh> '19900101'
go 
select * from vw_SinhVienC7

-- 8. Liệt kê những sinh viên nữ, tên có chứa chữ N.
create view vw_SinhVienC8
as select TenSV, Phai from SinhVien where Phai= 1 and TenSV like '%N%' 
go
select * from vw_SinhVienC8

-- 9. Danh sách các nam sinh viên khoa Tin Học có ngày sinh sau ngày 30/5/1986.
create view vw_SinhVienC9
as select TenSV, Phai,TenKH from SinhVien join Khoa on SinhVien.MaKH=Khoa.MaKH where TenKH=N'Tin Học' and NgaySinh > '19860530' and Phai=0
go
select * from vw_SinhVienC9

-- 10. Liệt kê danh sách sinh viên gồm các thông tin sau: Họ và tên sinh viên, Giới tính, Ngày sinh. Trong đó Giới tính hiển thị ở dạng Nam/Nữ tuỳ theo giá trị của field Phai là True hay False.
create view vw_SinhVienC10
as select CONCAT(HoSV, ' ', TenSV) as HoVaTen,iif(Phai=0,N'Nam',N'Nữ') as GioiTinh, NgaySinh from SinhVien
go
select * from vw_SinhVienC10

-- 11. Cho biết danh sách sinh viên gồm các thông tin sau: Mã sinh viên, Tuổi, Nơi sinh, Mã khoa. Trong đó Tuổi sẽ được tính bằng cách lấy năm hiện hành trừ cho năm sinh.
create view vw_SinhVienC11
as select MaSV,(YEAR(GETDATE())-YEAR(NgaySinh)) as Tuoi, NoiSinh,MaKH from SinhVien
go
select * from vw_SinhVienC11

-- 12. Danh sách những sinh viên có tuổi từ 20 đến 30, thông tin gồm: Họ tên sinh viên, Tuổi, Tên khoa.
create view vw_SinhVienC12
as select CONCAT(HoSV, ' ', TenSV) as HoVaTen,(YEAR(GETDATE())-YEAR(NgaySinh)) as Tuoi, TenKH from SinhVien join Khoa on SinhVien.MaKH=Khoa.MaKH
where (YEAR(GETDATE())-YEAR(NgaySinh)) >=20 and (YEAR(GETDATE())-YEAR(NgaySinh))<=30
go
select * from vw_SinhVienC12

-- 13. Cho biết thông tin về mức học bổng của các sinh viên, gồm: Mã sinh viên, Phái, Mã khoa, Mức học bổng. Trong đó, mức học bổng sẽ hiển thị là “Học bổng cao” nếu giá trị của field học bổng lớn hơn 500,000 và ngược lại hiển thị là “Mức trung bình”.
create view vw_SinhVienC13 
as select MaSV,Phai,MaKH, iif(HocBong>500000,N'Học bổng cao', 'Mức trung bình')as N'Mức học bổng' from SinhVien
go
select * from vw_SinhVienC13

-- 14. Danh sách sinh viên của khoa Anh văn, điều kiện lọc phải sử dụng tên khoa, gồm các thông tin sau: Họ tên sinh viên, Giới tính, Tên khoa. Trong đó, Giới tính sẽ hiển thị dạng Nam/Nữ.
create view vw_SinhVienC14
as select CONCAT(HoSV, ' ', TenSV) as HoVaTen, iif(Phai=0,N'Nam',N'Nữ')as GioiTinh,TenKH from SinhVien join Khoa on SinhVien.MaKH=Khoa.MaKH
where TenKH=N'Anh văn'
go
select * from vw_SinhVienC14

-- 15. Liệt kê bảng điểm của sinh viên khoa Tin Học, gồm các thông tin: Tên khoa, Họ tên sinh viên, Tên môn học, Số tiết, Điểm.
create view vw_SinhVienC15
as select CONCAT(HoSV, ' ', TenSV) as HoVaTen,TenKH, TenMH,Sotiet,Diem from SinhVien join Khoa on SinhVien.MaKH=Khoa.MaKH join Ketqua on SinhVien.MaSV=Ketqua.MaSV join MonHoc on Ketqua.MaMH=MonHoc.MaMH
where TenKH= N'Tin học'
go
select * from vw_SinhVienC15

-- 16. Kết quả học tập của sinh viên, gồm các thông tin: Họ tên sinh viên, Mã khoa, Tên môn học, Điểm thi, Loại. Trong đó, Loại sẽ là Giỏi nếu điểm thi > 8, từ 6 đến 8 thì Loại là Khá, nhỏ hơn 6 thì loại là Trung Bình.
create view vw_SinhVienC16
as select CONCAT(HoSV, ' ', TenSV) as HoVaTen,MaKH,Diem, case when Diem>8 then N'Giỏi' when Diem<=8 and Diem>=6 then N'Khá' else N'Trung bình' end as N'Loại' from SinhVien join Ketqua on SinhVien.MaSV=Ketqua.MaSV
go
select * from vw_SinhVienC16

-- 17. Cho biết học bổng cao nhất của từng khoa, gồm Mã khoa, Tên khoa, Học bổng cao nhất.
create view vw_SinhVienC17
as select Khoa.MaKH, TenKH, max(HocBong) as HocBongMax from Khoa join SinhVien on Khoa.MaKH=SinhVien.MaKH
group by Khoa.MaKH,TenKH
go
select * from vw_SinhVienC17

-- 18. Thống kê số sinh viên học của từng môn, thông tin có: Mã môn, Tên môn, Số sinh viên đang học.
create view vw_SinhVienC18
as select MonHoc.MaMH, TenMH, count(MaSV) as SoSinhVien from MonHoc join Ketqua on MonHoc.MaMH=Ketqua.MaMH 
group by MonHoc.MaMH,TenMH
go
select * from vw_SinhVienC18

-- 19. Cho biết môn nào có điểm thi cao nhất, gồm các thông tin: Tên môn, Số tiết, Tên sinh viên, Điểm.
create view vw_SinhVienC19
as select top 1 with ties TenMH,Sotiet,TenSV, Diem from MonHoc join Ketqua on MonHoc.MaMH=Ketqua.MaMH join SinhVien on SinhVien.MaSV= Ketqua.MaSV
group by TenMH,Sotiet,TenSV, Diem 
order by Diem desc
select * from vw_SinhVienC19

-- 20. Cho biết khoa nào có đông sinh viên nhất, gồm Mã khoa, Tên khoa, Tổng số sinh viên.
create view vw_SinhVienC20
as select top 1 with ties Khoa.MaKH,TenKH, count(MaSV) as TongSinhVien from Khoa join SinhVien on Khoa.MaKH=SinhVien.MaKH
group by Khoa.MaKH,TenKH
order by count(MaSV) desc 
go
select * from vw_SinhVienC20

-- 21. Cho biết khoa nào có sinh viên lãnh học bổng cao nhất, gồm các thông tin sau: Tên khoa, Họ tên sinh viên, Học bổng.
create view vw_SinhVienC21
as select top 1 with ties TenKH, HoSV,TenSV,HocBong from Khoa join SinhVien on Khoa.MaKH=SinhVien.MaKH
group by TenKH,HoSV,TenSV,HocBong
order by HocBong desc
go
select * from vw_SinhVienC21

-- 22. Cho biết sinh viên của khoa Tin học có học bổng cao nhất, gồm các thông tin: Mã sinh viên, Họ sinh viên, Tên sinh viên, Tên khoa, Học bổng.
create view vw_SinhVienC22
as select top 1 with ties SinhVien.MaSV, HoSV,TenSV,TenKH,HocBong from Khoa join SinhVien on Khoa.MaKH=SinhVien.MaKH
where TenKH= N'Tin học'
group by SinhVien.MaSV ,TenKH,HoSV,TenSV,HocBong
order by HocBong 
go
select * from vw_SinhVienC22

-- 23. Cho biết sinh viên nào có điểm môn Cơ sở dữ liệu lớn nhất, gồm thông tin: Họ sinh viên, Tên môn, Điểm.
create view vw_SinhVienC23
as select top 1 with ties HoSV,TenSV,TenMH,Diem from SinhVien join Ketqua on SinhVien.MaSV = Ketqua.MaSV join MonHoc on Ketqua.MaMH=MonHoc.MaMH
where TenMH=N'Cơ sở dữ liệu'
group by HoSV,TenSV,TenMH,Diem
order by diem desc
go
select * from vw_SinhVienC23

-- 24. Cho biết 3 sinh viên có điểm thi môn Đồ họa thấp nhất, thông tin: Họ tên sinh viên, Tên khoa, Tên môn, Điểm.
create view vw_SinhVienC24
as select top 3 HoSV,TenSV,TenKH,TenMH,Diem from Khoa join SinhVien on Khoa.MaKH=SinhVien.MaKH join Ketqua on SinhVien.MaSV = Ketqua.MaSV join MonHoc on Ketqua.MaMH=MonHoc.MaMH
where TenMH= N'Đồ họa ứng dụng'
group by HoSV,TenSV,TenKH,TenMH,Diem
order by Diem ASC
go
select * from vw_SinhVienC24

-- 25. Cho biết khoa nào có nhiều sinh viên nữ nhất, gồm các thông tin: Mã khoa, Tên khoa.
create view vw_SinhVienC25
as select top 1 with ties Khoa.MaKH,TenKH from Khoa join SinhVien on Khoa.MaKH=SinhVien.MaKH
where Phai =1
group by Khoa.MaKH,TenKH
order by count(MaSV) desc
select * from vw_SinhVienC25

-- 26. Thống kê sinh viên theo khoa, gồm các thông tin: Mã khoa, Tên khoa, Tổng số sinh viên, Tổng số sinh viên nữ.
create view vw_SinhVienC26
as select Khoa.MaKH, TenKH, count(MaSV) as TongSV, sum(iif(Phai=1,1,0)) as TongSVNu from Khoa join SinhVien on Khoa.MaKH=SinhVien.MaKH
group by Khoa.MaKH,TenKH
go
select * from vw_SinhVienC26

-- 27. Cho biết kết quả học tập của sinh viên, gồm Họ tên sinh viên, Tên khoa, Kết quả. Trong đó, Kết quả sẽ là Đậu nếu không có môn nào có điểm nhỏ hơn 4.
create view vw_SinhVienC27
as select CONCAT(HoSV, ' ', TenSV) as HoVaTen,TenKH, IIF(Min(Diem)>=4, N'Đậu',N'Trượt') as N'Kết quả' from SinhVien join Ketqua on SinhVien.MaSV=Ketqua.MaSV join Khoa on SinhVien.MaKH=Khoa.MaKH
group by HoSV,TenSV,TenKH
go
select * from vw_SinhVienC27

-- 28. Danh sách những sinh viên không có môn nào nhỏ hơn 4 điểm, gồm các thông tin: Họ tên sinh viên, Tên khoa, Phái.
create view vw_SinhVienC28
as select CONCAT(HoSV, ' ', TenSV) as HoVaTen,TenKH,Phai  from SinhVien join Ketqua on SinhVien.MaSV=Ketqua.MaSV join Khoa on SinhVien.MaKH=Khoa.MaKH
group by HoSV,TenSV,TenKH,Phai
having MIN(Diem) >=4
go
select * from vw_SinhVienC28

-- 29. Cho biết danh sách những môn không có điểm thi nhỏ hơn 4, gồm các thông tin: Mã môn, Tên Môn.
create view vw_SinhVienC29
as select MonHoc.MaMH,TenMH from MonHoc join Ketqua on MonHoc.MaMH=Ketqua.MaMH
group by MonHoc.MaMH,TenMH
having MIN(Diem) >=4
go
select * from vw_SinhVienC29

-- 30. Cho biết những khoa không có sinh viên rớt, sinh viên rớt nếu điểm thi của môn nhỏ hơn 5, gồm các thông tin: Mã khoa, Tên khoa.
create view vw_SinhVienC30
as select Khoa.MaKH,TenKH from Khoa join SinhVien on Khoa.MaKH=SinhVien.MaKH join Ketqua on SinhVien.MaSV=Ketqua.MaSV
group by Khoa.MaKH,TenKH
having MIN(Diem) >=5
go
select * from vw_SinhVienC30
