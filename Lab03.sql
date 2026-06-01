USE [master]
GO

/****** Object:  Database [QLHH]    Script Date: 6/1/2026 4:41:06 PM ******/
CREATE DATABASE [QLHH]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'QLHH', 
FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\QLHH.mdf' , 
SIZE = 51200KB , MAXSIZE = 204800KB , FILEGROWTH = 10240KB )
 LOG ON 
( NAME = N'QLHH_log', 
FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\QLHH_log.ldf' , 
SIZE = 10240KB , MAXSIZE = 2048GB , FILEGROWTH = 5120KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO

use [QLHH]
Go

create table VATTU (
 MaVtu Char(4) Primary Key Not Null,  
 TenVTu VarChar(100) Not null Unique, 
 DvTinh Varchar(10) Null Default(''),
 PhanTram Real Check (PhanTram >=0 and PhanTram<=100)
);
gO

create table NHACC(
MaNhaCc char(3) primary key not null,
TenNhaCc varchar(100) not null,
DiaChi varchar(200) not null,
DienThoai varchar(20) null default('Chua co')  
)

create table DONDH(
SoDh char(4) not null primary key,
NgayDh datetime default getDate(),
MaNhaCc char(3) not null
)

create table CTDONDH (
SoDh char(4) not null,
MaVTu char(4) not null,
SlDat int not null check(SlDat>0)
) 

create table PNHAP(
SoPn char(4) primary key,
NgayNhap Datetime,
SoDh char(4) not null foreign key references DONDH(SoDh)
)

create table CTPNHAP (
 SoPn char(4) not null,
 MaVTu char(4) not null,
 SlNhap int not null check(SlNhap > 0),
 DgNhap money not null check(DgNhap > 0),
 primary key (SoPn, MaVTu)
);
go

create table PXUAT (
 SoPx char(4) primary key not null,
 NgayXuat datetime default getDate(),
 TenKh varchar(100) not null
);
go

create table CTPXUAT (
 SoPx char(4) not null,
 MaVTu char(4) not null,
 SlXuat int not null check(SlXuat > 0),
 DgXuat money not null check(DgXuat > 0),
 primary key (SoPx, MaVTu)
);
go

create table TONKHO (
 NamThang char(6) not null,
 MaVTu char(4) not null,
 SLDau int not null check(SLDau >= 0),   
 TongSLN int not null check(TongSLN >= 0),  
 TongSLX int not null check(TongSLX >= 0),  
 SLCuoi as (SLDau + TongSLN - TongSLX),
 primary key (NamThang, MaVTu)
);
go

/* 1. Kết nối bảng DONDH với NHACC */
alter table DONDH
add constraint fk_dondh_nhacc foreign key (MaNhaCc) references NHACC(MaNhaCc);
go

/* 2. Kết nối bảng CTDONDH với DONDH và VATTU */
alter table CTDONDH
add constraint fk_ctdondh_dondh foreign key (SoDh) references DONDH(SoDh);

alter table CTDONDH
add constraint fk_ctdondh_vattu foreign key (MaVTu) references VATTU(MaVtu);
go

/* 3. Kết nối bảng PNHAP với DONDH */
alter table PNHAP
add constraint fk_pnhap_dondh foreign key (SoDh) references DONDH(SoDh);
go

/* 4. Kết nối bảng CTPNHAP với PNHAP và VATTU */
alter table CTPNHAP
add constraint fk_ctpnhap_pnhap foreign key (SoPn) references PNHAP(SoPn);

alter table CTPNHAP
add constraint fk_ctpnhap_vattu foreign key (MaVTu) references VATTU(MaVtu);
go

/* 5. Kết nối bảng CTPXUAT với PXUAT và VATTU */
alter table CTPXUAT
add constraint fk_ctpxuat_pxuat foreign key (SoPx) references PXUAT(SoPx);

alter table CTPXUAT
add constraint fk_ctpxuat_vattu foreign key (MaVTu) references VATTU(MaVtu);
go

/* 6. Kết nối bảng TONKHO với VATTU */
alter table TONKHO
add constraint fk_tonkho_vattu foreign key (MaVTu) references VATTU(MaVtu);
go


insert into NHACC (MaNhaCc, TenNhaCc, DiaChi, DienThoai) values
('C01', N'Lê Minh Thành', N'54, Kim Mã, Cầu Giấy, Hà Nội', '8781024'),
('C02', N'Trần Quang Anh', N'145, Hùng Vương, Hải Dương', '7698154'),
('C03', N'Bùi Hồng Phương', N'154/85, Lê Chân, Hải Phòng', '9600125'),
('C04', N'Vũ Nhật Thắng', N'198/40 Hương Lộ 14 QTB HCM', '8757757'),
('C05', N'Nguyễn Thị Thúy', N'178 Nguyễn Văn Luông Đà Lạt', '7964251'),
('C07', N'Cao Minh Trung', N'125 Lê Quang Sung Nha Trang', default);
go

insert into VATTU (MaVtu, TenVTu, DvTinh, PhanTram) values
('DD01', N'Đầu DVD Hitachi 1 đĩa', N'Bộ', 40),
('DD02', N'Đầu DVD Hitachi 3 đĩa', N'Bộ', 40),
('TL15', N'Tủ lạnh Sanyo 150 lit', N'Cái', 25),
('TL90', N'Tủ lạnh Sanyo 90 lit', N'Cái', 20),
('TV14', N'Tivi Sony 14 inches', N'Cái', 15),
('TV21', N'Tivi Sony 21 inches', N'Cái', 10),
('TV29', N'Tivi Sony 29 inches', N'Cái', 10),
('VD01', N'Đầu VCD Sony 1 đĩa', N'Bộ', 30),
('VD02', N'Đầu VCD Sony 3 đĩa', N'Bộ', 30);
go

insert into DONDH (SoDh, NgayDh, MaNhaCc) values
('D001', '2012-01-15', 'C03'),
('D002', '2012-01-30', 'C01'),
('D003', '2012-02-10', 'C02'),
('D004', '2012-02-17', 'C05'),
('D005', '2012-03-01', 'C02'),
('D006', '2012-03-12', 'C05');
go

insert into CTDONDH (SoDh, MaVTu, SlDat) values
('D001', 'DD01', 10),
('D001', 'DD02', 15),
('D002', 'VD02', 30),
('D003', 'TV14', 10),
('D003', 'TV29', 20),
('D004', 'TL90', 10),
('D005', 'TV14', 10),
('D005', 'TV29', 20),
('D006', 'TV14', 10),
('D006', 'TV29', 20),
('D006', 'VD01', 20);
go

insert into PNHAP (SoPn, NgayNhap, SoDh) values
('N001', '2012-01-17', 'D001'),
('N002', '2012-01-20', 'D001'),
('N003', '2012-01-31', 'D002');
go

insert into CTPNHAP (SoPn, MaVTu, SlNhap, DgNhap) values
('N001', 'DD01', 8, 2500000),
('N001', 'DD02', 10, 3500000),
('N002', 'DD01', 2, 2500000),
('N002', 'DD02', 5, 3500000),
('N003', 'VD02', 30, 2500000);
go

insert into PXUAT (SoPx, NgayXuat, TenKh) values
('X001', '2012-01-17', N'Nguyễn Ngọc Phương Nhi'),
('X002', '2012-01-25', N'Nguyễn Hồng Phương'),
('X003', '2012-01-31', N'Nguyễn Tuấn Tú');
go

-- 8. Chèn dữ liệu vào bảng TONKHO
-- Vì cột SLCuoi là cột tính toán tự động 
-- nên không cần gán giá trị cho nó khi chèn.
insert into TONKHO (NamThang, MaVTu, SLDau, TongSLN, TongSLX) values
('201201', 'DD01', 0, 10, 6),
('201201', 'DD02', 0, 15, 7),
('201201', 'VD02', 0, 30, 10),
('201202', 'DD01', 4, 0, 0),
('201202', 'DD02', 8, 0, 0),
('201202', 'VD02', 20, 0, 0),
('201202', 'TV14', 5, 0, 0),
('201202', 'TV29', 12, 0, 0);
go

