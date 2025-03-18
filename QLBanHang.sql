-- Tao he CSDL
create database BanHang
go
use BanHang

-- Tao bang du lieu
create table KhachHang (
	MaKH varchar (5) primary key,
	TenKH nvarchar (20),
	Email varchar (20),
	ThanhPho nvarchar (15)
)

create table SanPham (
	MaSP varchar (5) primary key,
	TenSP nvarchar (20),
	DonGia bigint,
	DanhMuc varchar (20)
)

create table HoaDon (
	MaHD varchar (5) primary key,
	MaKH varchar (5),
	NgayDat date,
	TotalAmount int
)

create table ChiTietHoaDon (
	MaCTHD varchar (5) primary key,
	MaHD varchar (5),
	MaSP varchar (5),
	SoLuong int,
	SubTotal bigint
)

-- Thiet lap khoa ngoai
alter table HoaDon add foreign key (MaKH) references KhachHang(MaKH)
alter table ChiTietHoaDon add foreign key (MaHD) references HoaDon(MaHD)
alter table ChiTietHoaDon add foreign key (MaSP) references SanPham(MaSP)

-- Them cac bo cho tung bang
INSERT INTO KhachHang VALUES
('KH001', N'Hoàng Minh', 'minh.hoang@gmail.com', N'Hà Nội'),
('KH002', N'Lê Hoa', 'hoa.le@gmail.com', N'Hồ Chí Minh'),
('KH003', N'Trần Anh', 'anh.tran@gmail.com', N'Đà Nẵng'),
('KH004', N'Phạm Vũ', 'vu.pham@gmail.com', N'Hải Phòng');

INSERT INTO SanPham VALUES
('SP101', N'Laptop Dell', 15000000, N'Công nghệ'),
('SP102', N'iPhone 13', 20000000, N'Điện thoại'),
('SP103', N'Tai nghe AirPods', 3500000, N'Phụ kiện'),
('SP104', N'Máy giặt Samsung', 8000000, N'Điện gia dụng');

INSERT INTO HoaDon VALUES
('HD001', 'KH001', '2024-03-10', 15000000),
('HD002', 'KH002', '2024-03-11', 40000000),
('HD003', 'KH003', '2024-03-12', 3500000),
('HD004', 'KH001', '2024-03-14', 8000000);

INSERT INTO ChiTietHoaDon VALUES
('CTHD1', 'HD001', 'SP101', 1, 15000000),
('CTHD2', 'HD002', 'SP102', 2, 40000000),
('CTHD3', 'HD003', 'SP103', 1, 3500000),
('CTHD4', 'HD004', 'SP104', 1, 8000000);

SELECT * FROM KhachHang
SELECT * FROM SanPham
SELECT * FROM HoaDon
SELECT * FROM ChiTietHoaDon

-- 5. Tìm khách hàng đã đặt hàng nhiều nhất (theo số lượng đơn hàng).
select top 1 with ties K.MaKH, TenKH, COUNT(MaHD) as SLDH
from KhachHang K
join HoaDon H on K.MaKH = H.MaKH
group by K.MaKH, TenKH
order by SLDH desc

-- 6. Tìm sản phẩm bán chạy nhất (sản phẩm có tổng số lượng mua nhiều nhất).
select top 1 with ties S.MaSP, TenSP, COUNT(C.MaSP) as SLBR
from SanPham S
join ChiTietHoaDon C on S.MaSP = C.MaSP
group by S.MaSP, TenSP
order by SLBR desc

-- 7. Tìm tổng doanh thu theo từng thành phố.
select ThanhPho, SUM(SubTotal) as TDT
from KhachHang K
join HoaDon H on K.MaKH = H.MaKH
join ChiTietHoaDon C on H.MaHD = C.MaHD
group by ThanhPho
order by TDT

-- 8. Liệt kê danh sách sản phẩm chưa được bán.
select *
from SanPham S
join ChiTietHoaDon C on S.MaSP = C.MaSP
where S.MaSP not in (C.MaSP)

-- 11. Tìm 3 sản phẩm có doanh thu cao nhất.
select top 3 with ties S.MaSP, TenSP, SUM(SubTotal) as TDT
from SanPham S
join ChiTietHoaDon C on S.MaSP = C.MaSP
group by S.MaSP, TenSP
order by TDT desc

-- 12. Hiển thị khách hàng đã chi tiêu nhiều nhất (tính tổng tiền tất cả đơn hàng của họ).
select top 1 with ties K.MaKH, TenKH, SUM(SubTotal) as TCT
from KhachHang K
join HoaDon H on K.MaKH = H.MaKH
join ChiTietHoaDon C on H.MaHD = C.MaHD
group by K.MaKH, TenKH
order by TCT desc

-- 13. Tìm khách hàng chưa từng mua hàng.
select MaKH, TenKH
from KhachHang
where MaKH not in (select MaKH from HoaDon)

-- 14. Tính giá trị trung bình của đơn hàng trong hệ thống.
select AVG(SubTotal) as GTTB
from HoaDon H
join ChiTietHoaDon C on H.MaHD = C.MaHD

-- 15. Tính tổng số lượng sản phẩm đã bán ra theo từng danh mục.
select S.MaSP, TenSP, SUM(SoLuong) as SLBR
from SanPham S
join ChiTietHoaDon C on S.MaSP = C.MaSP
group by S.MaSP, TenSP
order by SLBR desc

-- 16. Tìm đơn hàng có ít nhất 2 sản phẩm trở lên.
INSERT INTO HoaDon VALUES
('HD005', 'KH004', '2024-03-11', 35000000);
INSERT INTO ChiTietHoaDon VALUES
('CTHD5', 'HD005', 'SP101', 1, 15000000),
('CTHD6', 'HD005', 'SP102', 1, 20000000);

DELETE FROM ChiTietHoaDon WHERE MaHD = 'HD005'
DELETE FROM HoaDon WHERE MaKH = 'KH004'

select MaHD, COUNT(MaHD) as SoLoaiSP
from ChiTietHoaDon
group by MaHD
having COUNT(MaHD) >= 2

-- 17. Lấy danh sách khách hàng và số tiền họ đã chi tiêu, sắp xếp theo số tiền giảm dần.
select K.MaKH, TenKH, SUM(SubTotal) as SoTienChiTieu
from KhachHang K
join HoaDon H on K.MaKH = H.MaKH
join ChiTietHoaDon C on H.MaHD = C.MaHD
group by K.MaKH, TenKH
order by SoTienChiTieu desc

-- 18. Lấy danh sách sản phẩm và số lượng đã bán, sắp xếp theo số lượng giảm dần.
select S.MaSP, TenSP, SUM(SoLuong) as SLDB
from SanPham S
join ChiTietHoaDon C on S.MaSP = C.MaSP
group by S.MaSP, TenSP
order by SLDB desc

-- 19. Tìm khách hàng đã đặt hàng gần đây nhất (ngày đặt hàng mới nhất)
select K.MaKH, TenKH, H.NgayDat
from KhachHang K
join HoaDon H on K.MaKH = H.MaKH
where NgayDat = (select MAX(NgayDat) from HoaDon)

-- 20. Tính tổng doanh thu theo từng tháng trong năm 2024.
select MONTH(NgayDat) as Thang, SUM(SubTotal) as TongDoanhThu
from HoaDon H
join ChiTietHoaDon C on H.MaHD = C.MaHD
group by MONTH(NgayDat), YEAR(NgayDat)
having YEAR(NgayDat) = 2024

-- 25. Tìm số lượng khách hàng đến từ mỗi thành phố, sắp xếp theo số lượng giảm dần.
select ThanhPho, COUNT(MaKH) as SLKH
from KhachHang
group by ThanhPho
order by SLKH desc

-- 26. Tìm sản phẩm có giá cao nhất và thấp nhất trong hệ thống.
select MaSP, TenSP, DonGia
from SanPham
where DonGia in (select MAX(DonGia) from SanPham)
or DonGia in (select MIN(DonGia) from SanPham)
order by DonGia desc

-- 28. Xác định sản phẩm có doanh thu trung bình cao nhất (tổng doanh thu chia cho số lần bán).
select top 1 with ties S.MaSP, TenSP, AVG(SubTotal) as DTTB
from SanPham S
join ChiTietHoaDon C on S.MaSP = C.MaSP
group by S.MaSP, TenSP
order by DTTB desc

-- 29. Liệt kê những sản phẩm chỉ được mua bởi một khách hàng duy nhất.
select S.MaSP, TenSP, COUNT(MaKH) as KhachMua
from SanPham S
join ChiTietHoaDon C on S.MaSP = C.MaSP
join HoaDon H on C.MaHD = H.MaHD
group by S.MaSP, TenSP
having COUNT(MaKH) = 1

-- 30. Tìm những sản phẩm có doanh thu lớn hơn mức trung bình của toàn bộ sản phẩm.
select S.MaSP, TenSP, SUM(SubTotal) as TDT
from SanPham S
join ChiTietHoaDon C on S.MaSP = C.MaSP
group by S.MaSP, TenSP
having SUM(SubTotal) > (select AVG(SubTotal) from ChiTietHoaDon)

-- 31. Tìm tổng doanh thu theo từng ngày trong tháng gần nhất.
select DAY(NgayDat) as Ngay, SUM(SubTotal) as TDT
from HoaDon H
join ChiTietHoaDon C on H.MaHD = C.MaHD
where MONTH(NgayDat) in (select MAX(MONTH(NgayDat)) from HoaDon)
group by DAY(NgayDat)

-- 32. Liệt kê số lượng đơn hàng và tổng doanh thu của từng khách hàng, nhưng chỉ hiển thị những khách hàng có tổng chi tiêu > 10 triệu.
select K.MaKH, TenKH, COUNT(C.MaHD) as SLDH, SUM(SubTotal) as TDT
from KhachHang K
join HoaDon H on K.MaKH = H.MaKH
join ChiTietHoaDon C on H.MaHD = C.MaHD
group by K.MaKH, TenKH
having SUM(SubTotal) > 10000000

-- 37. Tìm tháng có doanh thu cao nhất trong năm 2024.
select top 1 with ties MONTH(NgayDat) as Thang, SUM(SubTotal) as TDT
from HoaDon H
join ChiTietHoaDon C on H.MaHD = C.MaHD
group by MONTH(NgayDat), YEAR(NgayDat)
having YEAR(NgayDat) = 2024
order by TDT desc

-- 38. Xác định tỷ lệ phần trăm đóng góp doanh thu của từng khách hàng so với tổng doanh thu toàn hệ thống.
select K.MaKH, TenKH, SUM(SubTotal) as TDT, 100*SUM(SubTotal)/(select SUM(SubTotal) from ChiTietHoaDon) as [Ti Le (%)]
from KhachHang K
join HoaDon H on K.MaKH = H.MaKH
join ChiTietHoaDon C on H.MaHD = C.MaHD
group by K.MaKH, TenKH

-- 39. Tìm khách hàng đã đặt hàng trong tất cả các tháng của năm 2024.
select K.MaKH, TenKH
from KhachHang K
join HoaDon H on K.MaKH = H.MaKH
group by K.MaKH, TenKH
having COUNT(DISTINCT MONTH(NgayDat)) = 12

-- 50. Xác định sản phẩm có thời gian bán chậm nhất, tức là sản phẩm được đặt hàng lần đầu và lần cuối có khoảng cách xa nhất.
select top 1 with ties S.MaSP, TenSP, ABS(DATEDIFF(day, MAX(NgayDat), MIN(NgayDat))) as ThoiGian
from SanPham S
join ChiTietHoaDon C on S.MaSP = C.MaSP
join HoaDon H on C.MaHD = H.MaHD
group by S.MaSP, TenSP
order by ThoiGian desc