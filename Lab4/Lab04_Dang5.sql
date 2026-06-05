--------------------- Truy vấn con ---------------------
-- 1. Danh sách sinh viên chưa thi môn nào, thông tin gồm: Mã sinh viên, Mã khoa, Phái.
select MaSV, MaKH, Phai from SinhVien
where MaSV not in (select distinct MaSV from Ketqua )

-- 2. Danh sách những sinh viên chưa thi môn Cơ sở dữ liệu, gồm các thông tin: Mã sinh viên, Họ tên sinh viên, Mã khoa.
select MaSV, HoSV,TenSV, MaKH, Phai from SinhVien
where NOT EXISTS (select distinct MaSV from Ketqua where MaMH='01')

-- 3. Cho biết môn nào chưa có sinh viên thi, gồm thông tin về: Mã môn, Tên môn, Số tiết.
select MaMH,TenMH,Sotiet from MonHoc
where MaMH not in (select distinct MaMH from Ketqua )

-- 4. Khoa nào chưa có sinh viên học.
select MaKH,TenKH from Khoa
where Khoa.MaKH not in (select distinct SinhVien.MaKH from SinhVien)

-- 5. Cho biết những sinh viên của khoa Anh văn chưa thi môn Cơ sở dữ liệu.
select MaSV,HoSV,TenSV from SinhVien sv join Khoa kh on sv.MaKH=kh.MaKH
where sv.MaSV not in (select MaSV from Ketqua join MonHoc on Ketqua.MaMH= MonHoc.MaMH where TenMH=N'Cơ sở dữ liệu') and sv.MaKH='AV'

-- 6. Cho biết môn nào chưa có sinh viên khoa Tin Học thi.
select MaMH,TenMH from MonHoc 
where MaMH not in (select MaMH from Ketqua join SinhVien on Ketqua.MaSV=SinhVien.MaSV where MaKH = 'TH')

-- 7. Danh sách những sinh viên có điểm thi môn Đồ hoạ nhỏ hơn điểm thi môn Đồ hoạ nhỏ nhất của sinh viên khoa Tin học.
select sv.MaSV,sv.HoSV,sv.TenSV,kq.Diem from SinhVien sv join Ketqua kq on sv.MaSV=kq.MaSV
where kq.MaMH = 04 and kq.Diem > ( select MIN(Diem) from Ketqua join SinhVien on Ketqua.MaSV=SinhVien.MaSV where MaMH=04 and MaKH = 'TH')

-- 8. Liệt kê những sinh viên sinh sau sinh viên có tuổi nhỏ nhất trong khoa Anh văn.
select MaSV, TenSV, Phai, (YEAR(GETDATE())-YEAR(NgaySinh)) as Tuoi from SinhVien sv
where Year(sv.NgaySinh) < Year((select top 1 NgaySinh from SinhVien where MaKH='AV' order by NgaySinh desc))

-- 9. Cho biết những sinh viên có học bổng lớn hơn tổng học bổng của những sinh viên thuộc khoa Triết.
select sv.MaSV,sv.HoSV,sv.TenSV, sv.HocBong from SinhVien sv
where sv.HocBong > (select sum(HocBong) from SinhVien where MaKH='TR')

-- 10. Danh sách sinh viên có nơi sinh cùng với nơi sinh của sinh viên có học bổng lớn nhất trong khoa Tin học.
select sv.MaSV,sv.HoSV,sv.TenSV, sv.NoiSinh from SinhVien sv
where sv.NoiSinh = (select top 1 NoiSinh from SinhVien where MaKH='AV' order by HocBong desc )

-- 11. Danh sách sinh viên có điểm cao nhất ứng với mỗi môn, gồm thông tin: Mã sinh viên, Họ tên sinh viên, Tên môn, Điểm.
select sv.MaSV,sv.HoSV,sv.TenSV, TenMH, kq.Diem from SinhVien sv join Ketqua kq on sv.MaSV=kq.MaSV join MonHoc mh on kq.MaMH=mh.MaMH
join (
select MaMH, max(Diem) as Diem from Ketqua
group by MaMH
) as TopMax on kq.Diem=TopMax.Diem and kq.MaMH=TopMax.MaMH

-- 12. Các sinh viên có học bổng cao nhất theo từng khoa, gồm Mã sinh viên, Tên khoa, Học bổng.
select sv.MaSV, sv.TenSV,kh.TenKH,sv.HocBong from SinhVien sv join Khoa kh on sv.MaKH=kh.MaKH
join (select MaKH, MAX(HocBong) as HBMAX from SinhVien group by MaKH) as MaxKhoa on sv.MaKH=MaxKhoa.MaKH and sv.HocBong=MaxKhoa.HBMAX
