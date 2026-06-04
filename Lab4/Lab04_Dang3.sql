------------------------------- DẠNG: TÍNH TOÁN THỐNG KÊ DỮ LIỆU ----------------------------
use QLSINHVIEN
-- 1. Cho biết trung bình điểm thi theo từng môn, gồm các thông tin: Mã môn, Tên môn, Trung bình điểm thi.
select Ketqua.MaMH, MonHoc.TenMH, Round(AVG(Ketqua.Diem),2) as 'Diem trung binh' from Ketqua join MonHoc on Ketqua.MaMH=MonHoc.MaMH
group by Ketqua.MaMH,MonHoc.TenMH

-- 2. Danh sách số môn thi của từng sinh viên, gồm các thông tin: Họ tên sinh viên, Tên khoa, Tổng số môn thi.
select CONCAT(HoSV, ' ', TenSV) as HoVaTen, Khoa.TenKH, count(Ketqua.MaMH)as SoMonThi from SinhVien join Khoa on SinhVien.MaKH=Khoa.MaKH join Ketqua on SinhVien.MaSV=Ketqua.MaSV
group by HoSV,TenSV,Khoa.TenKH

-- 3. Tổng điểm thi của từng sinh viên, các thông tin: Tên sinh viên, Tên khoa, Phái, Tổng điểm thi.
select TenSV,Khoa.TenKH,Phai, sum(Ketqua.Diem) as TongDiem from SinhVien join Khoa on SinhVien.MaKH=Khoa.MaKH join Ketqua on SinhVien.MaSV=Ketqua.MaSV
group by TenSV, Khoa.TenKH, Phai

-- 4. Cho biết tổng số sinh viên ở mỗi khoa, gồm các thông tin: Tên khoa, Tổng số sinh viên.
select TenKH, COUNT(SinhVien.MaSV) as N'Tổng số sinh viên' from Khoa join SinhVien on Khoa.MaKH=SinhVien.MaKH
group by TenKH

-- 5. Cho biết điểm cao nhất của mỗi sinh viên, gồm thông tin: Họ tên sinh viên, Điểm.
select concat(HoSV, ' ', TenSV) as HoVaTen, MAX(Ketqua.Diem) from SinhVien join Ketqua on SinhVien.MaSV=Ketqua.MaSV
group by HoSV,TenSV

-- 6. Thông tin của môn học có số tiết nhiều nhất: Tên môn học, Số tiết.
	select MonHoc.TenMH from MonHoc
	where Sotiet = (select Max(MonHoc.Sotiet) from MonHoc)
--select * from MonHoc
-- Cách 2: 
	select top 1 with ties TenMH, SoTiet
	from MonHoc
	order by SoTiet desc
-- Cách 3: Áp dụng cho chỉ có 1 cái max 
	select top 1 TenMH, SoTiet
	from MonHoc
	order by SoTiet desc

-- 7. Cho biết học bổng cao nhất của từng khoa, gồm Mã khoa, Tên khoa, Học bổng cao nhất.
select Khoa.MaKH, TenKH, Max(SinhVien.HocBong) as N'Học bổng cao nhất' from Khoa join SinhVien on Khoa.MaKH=SinhVien.MaKH
group by Khoa.MaKH,TenKH

-- 8. Cho biết điểm cao nhất của mỗi môn, gồm: Tên môn, Điểm cao nhất.
select TenMH, MAX(Ketqua.Diem) as DiemCaoNhat from MonHoc join Ketqua on MonHoc.MaMH = Ketqua.MaMH
group by MonHoc.MaMH, TenMH

-- 9. Thống kê số sinh viên học của từng môn, thông tin có: Mã môn, Tên môn, Số sinh viên đang học.
select MonHoc.MaMH, TenMH, Count(Ketqua.MaSV) as N'Số sinh viên đang học' from MonHoc join Ketqua on MonHoc.MaMH=Ketqua.MaMH
group by MonHoc.MaMH,MonHoc.TenMH

-- 10. Cho biết môn nào có điểm thi cao nhất, gồm các thông tin: Tên môn, Số tiết, Tên sinh viên, Điểm.
select TenMH, Sotiet, SinhVien.TenSV, Diem from MonHoc join Ketqua on MonHoc.MaMH=Ketqua.MaMH join SinhVien on Ketqua.MaSV=SinhVien.MaSV  
where Ketqua.Diem = (select MAX(Diem) from Ketqua)

-- 11. Cho biết khoa nào có đông sinh viên nhất, gồm Mã khoa, Tên khoa, Tổng số sinh viên.
select Top 1 with TIES Khoa.MaKH,Khoa.TenKH, COUNT(SinhVien.MaSV) as N'Tổng số sinh viên' from Khoa join SinhVien on Khoa.MaKH=SinhVien.MaKH
group by Khoa.MaKH,Khoa.TenKH
ORDER BY Khoa.MaKH, TenKH

-- Cách 2 : 
SELECT Khoa.MaKH,
       Khoa.TenKH,
       COUNT(SinhVien.MaSV) AS N'Tổng số sinh viên'
FROM Khoa
JOIN SinhVien
    ON Khoa.MaKH = SinhVien.MaKH
GROUP BY Khoa.MaKH, Khoa.TenKH
HAVING COUNT(SinhVien.MaSV) = (
    SELECT MAX(SoLuong)
    FROM (
        SELECT COUNT(MaSV) AS SoLuong
        FROM SinhVien
        GROUP BY MaKH
    ) AS T
);

-- 12. Cho biết khoa nào có sinh viên lãnh học bổng cao nhất, gồm các thông tin sau: Tên Khoa, Họ tên Sinh Viên, Học Bổng  
select Top 1 with ties Khoa.TenKH, concat(HoSV, ' ', TenSV) as HoVaTen, SinhVien.HocBong from Khoa join SinhVien on Khoa.MaKH=SinhVien.MaKH
ORDER BY SinhVien.HocBong DESC

-- 13. Cho biết sinh viên của khoa Tin học có học bổng cao nhất, gồm các thông tin: Mã sinh viên, Họ sinh viên, Tên sinh viên, Tên khoa, Học bổng
select top 1 with ties MaSV,HoSV,TenSV, Khoa.TenKH, HocBong from SinhVien join Khoa on SinhVien.MaKH=Khoa.MaKH 
where Khoa.MaKH='TH'
order by HocBong DESC

-- 14. Cho biết sinh viên nào có điểm môn Cơ sở dữ liệu lớn nhất, gồm thông tin: Họ sinh viên, Tên môn, Điểm
select top 1 with ties CONCAT(HoSV, ' ', TenSV) as HoVaTen, MonHoc.TenMH,Diem from Ketqua join MonHoc on Ketqua.MaMH=MonHoc.MaMH join SinhVien on Ketqua.MaSV=SinhVien.MaSV
where Ketqua.MaMH=01
order by Diem desc

-- 15. Cho biết 3 sinh viên có điểm thi môn Đồ họa thấp nhất, thông tin: Họ tên sinh viên, Tên khoa, Tên môn, Điểm
select top 3 CONCAT(HoSV, ' ', TenSV) as HoVaTen,Khoa.TenKH ,MonHoc.TenMH,Diem from Ketqua join MonHoc on Ketqua.MaMH=MonHoc.MaMH join SinhVien on Ketqua.MaSV=SinhVien.MaSV join Khoa on SinhVien.MaKH=Khoa.MaKH
where Ketqua.MaMH=04
order by Diem asc

-- 16. Cho biết khoa nào có nhiều sinh viên nữ nhất, gồm các thông tin: Mã khoa, Tên khoa
select top 1 with ties Khoa.MaKH,TenKH, count(iif(Phai=1,1,0)) as SoSinhVienNu from Khoa join SinhVien on Khoa.MaKH=SinhVien.MaKH
group by Khoa.MaKH,TenKH 
order by count(iif(Phai=1,1,0)) desc

-- 17. Thống kê sinh viên theo khoa, gồm các thông tin: Mã khoa, Tên khoa, Tổng số sinh viên, Tổng số sinh viên nữ
select Khoa.MaKH,TenKH,COUNT(SinhVien.MaSV)as TongSinhVien ,sum(iif(Phai=1,1,0)) as SoSinhVienNu from Khoa join SinhVien on Khoa.MaKH=SinhVien.MaKH
group by Khoa.MaKH,TenKH 
select * from SinhVien

-- 18. Cho biết kết quả học tập của sinh viên, gồm Họ tên sinh viên, Tên khoa, Kết quả. Trong đó, Kết quả sẽ là Đậu nếu không có môn nào có điểm nhỏ hơn 4
select distinct CONCAT(HoSV, ' ', TenSV)as HoTenSV, Khoa.TenKH, case when Min(Diem) >= 4 then N'Đậu' else N'Trượt' end as N'Kết quả'
from SinhVien join Khoa on SinhVien.MaKH=Khoa.MaKH join Ketqua on SinhVien.MaSV=Ketqua.MaSV
group by HoSV,TenSV,TenKH

-- 19. Danh sách những sinh viên không có môn nào nhỏ hơn 4 điểm, gồm các thông tin: Họ tên sinh viên, Tên khoa, Phái
select distinct CONCAT(HoSV, ' ', TenSV)as HoTenSV, Khoa.TenKH, Phai
from SinhVien join Khoa on SinhVien.MaKH=Khoa.MaKH join Ketqua on SinhVien.MaSV=Ketqua.MaSV
group by HoSV,TenSV,TenKH,Phai
having Min(Ketqua.Diem) >=4

-- 20. Cho biết danh sách những môn không có điểm thi nhỏ hơn 4, gồm các thông tin: Mã môn, Tên Môn
select MonHoc.MaMH, TenMH from MonHoc join Ketqua on MonHoc.MaMH=Ketqua.MaMH
group by MonHoc.MaMH,TenMH
having Min(Ketqua.Diem) >=4

-- 21. Cho biết những khoa không có sinh viên rớt, sinh viên rớt nếu điểm thi của môn nhỏ hơn 5, gồm các thông tin: Mã khoa, Tên khoa
select Khoa.MaKH,TenKH from Khoa join SinhVien on Khoa.MaKH=SinhVien.MaKH join Ketqua on SinhVien.MaSV= Ketqua.MaSV
group by Khoa.MaKH,TenKH
having Min(Ketqua.Diem)>=5

-- 22. Thống kê số sinh viên đậu và số sinh viên rớt của từng môn, biết rằng sinh viên rớt khi điểm của môn nhỏ hơn 5, gồm có: Mã môn, Tên môn, Số sinh viên đậu, Số sinh viên rớt
select MonHoc.MaMH, MonHoc.TenMH, sum(iif(Diem>=5,1,0)) as N'Sinh viên đậu', sum(iif(Diem>=5,0,1)) as N'Sinh viên rớt'  from MonHoc JOIN 
(
-- Lấy danh sách điểm duy nhất, loại bỏ trùng lặp ở Mã Sinh Viên ???????????????????
    SELECT MaMH, Diem 
    FROM Ketqua 
    GROUP BY MaMH, Diem
) AS KQ ON MonHoc.MaMH = KQ.MaMH
group by MonHoc.MaMH,MonHoc.TenMH
select MaMH,Diem from Ketqua group by Ketqua.MaMH,Diem


-- 23. Cho biết môn nào không có sinh viên rớt, gồm có: Mã môn, Tên môn

-- 24. Danh sách sinh viên không có môn nào rớt, thông tin gồm: Mã sinh viên, Họ tên, Mã khoa

-- 25. Danh sách các sinh viên rớt trên 2 môn, gồm Mã sinh viên, Họ sinh viên, Tên sinh viên, Mã khoa

-- 26. Cho biết danh sách những khoa có nhiều hơn 10 sinh viên, gồm Mã khoa, Tên khoa, Tổng số sinh viên của khoa

-- 27. Danh sách những sinh viên thi nhiều hơn 4 môn, gồm có Mã sinh viên, Họ tên sinh viên, Số môn thi

-- 28. Cho biết khoa có 5 sinh viên nam trở lên, thông tin gồm có: Mã khoa, Tên khoa, Tổng số sinh viên nam

-- 29. Danh sách những sinh viên có trung bình điểm thi lớn hơn 4, gồm các thông tin sau: Họ tên sinh viên, Tên khoa, Phái, Điểm trung bình các môn

-- 30. Cho biết trung bình điểm thi của từng môn, chỉ lấy môn nào có trung bình điểm thi lớn hơn 6, thông tin gồm có: Mã môn, Tên môn, Trung bình điểm