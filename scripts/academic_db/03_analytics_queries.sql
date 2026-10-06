SELECT * FROM KHACHHANG;
SELECT * FROM SANPHAM;
SELECT * FROM HOADON;
SELECT * FROM CTHD;
SELECT * FROM NHANVIEN;
--
DECLARE @sql NVARCHAR(MAX) ='';

SELECT @sql = @sql + 'SELECT * FROM ' + QUOTENAME(TABLE_NAME) + ';'
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE' AND TABLE_CATALOG = 'QL_BANHANG';

EXEC sp_executesql @sql;
--Xóa bảng
DROP TABLE NHANVIEN;
--Xóa dữ liệu trong bảng
TRUNCATE TABLE NHANVIEN;
--

sp_help 'NHANVIEN'
sp_tables NULL, 'dbo'
sp_columns 'NHANVIEN'
sp_pkeys 'NHANVIEN'
sp_fkeys 'KHACHHANG'
sp_helpconstraint 'NHANVIEN'
sp_helpsql 'SP_TinhTong'

/*
I. Ngôn ngữ định nghĩa dữ liệu (Data Definition Language):
	1. Tạo các quan hệ và khai báo các khóa chính, khóa ngoại của quan hệ.
	2. Thêm vào thuộc tính GHICHU có kiểu dữ liệu varchar(20) cho quan hệ SANPHAM.
	3. Thêm vào thuộc tính LOAIKH có kiểu dữ liệu là tinyint cho quan hệ KHACHHANG.
	4. Sửa kiểu dữ liệu của thuộc tính GHICHU trong quan hệ SANPHAM thành varchar(100).
	5. Xóa thuộc tính GHICHU trong quan hệ SANPHAM.
	6. Làm thế nào để thuộc tính LOAIKH trong quan hệ KHACHHANG có thể lưu các giá trị là: “Vang lai”, “Thuong xuyen”, “Vip”, …
	7. Đơn vị tính của sản phẩm chỉ có thể là (“cay”,”hop”,”cai”,”quyen”,”chuc”)
	8. Giá bán của sản phẩm từ 500 đồng trở lên.
	9. Mỗi lần mua hàng, khách hàng phải mua ít nhất 1 sản phẩm.
	10. Ngày khách hàng đăng ký là khách hàng thành viên phải lớn hơn ngày sinh của người đó
*/
--2
ALTER TABLE SANPHAM ADD GHICHU VARCHAR(20);
--3
ALTER TABLE KHACHHANG ADD LOAIKH TINYINT;
--4
ALTER TABLE SANPHAM ALTER COLUMN GHICHU VARCHAR(100);
--5
ALTER TABLE SANPHAM DROP COLUMN GHICHU;
--6
ALTER TABLE KHACHHANG  ALTER COLUMN LOAIKH VARCHAR(12);
ALTER TABLE KHACHHANG ADD CONSTRAINT CHECK_LOAIKH CHECK (LOAIKH IN ('Vang lai','Thuong xuyen','Vip'));
--7
ALTER TABLE SANPHAM
ADD CONSTRAINT CHECK_DVT CHECK (DVT IN ('cay', 'hop', 'cai', 'quyen', 'chuc'));
--8
ALTER TABLE SANPHAM ADD CONSTRAINT CHECK_GIA CHECK ( GIA > 500 );
/*
9.
ALTER TABLE CTHD 
ADD CONSTRAINT CHECK_CTHD CHECK ( SL >= 1);
Check không thể sử dụng trong các bảng liên chỉ cho các bảng riêng lẻ.
do đó sử dụng trigger là cách tốt nhất ngoài ra vẫn muốn sử dụng check có thể sử dụng cách sau
*/
ALTER TABLE HOADON ADD CONSTRAINT CHECK_TRIGIA CHECK (TRIGIA >= 500)
--10
ALTER TABLE KHACHHANG ADD CONSTRAINT CHECK_NGDK CHECK (NGDK > NGSINH)


/*
II. Ngôn ngữ thao tác dữ liệu (Data Manipulation Language):
	1. Nhập dữ liệu cho các quan hệ trên.
	2. Tạo quan hệ SANPHAM1 chứa toàn bộ dữ liệu của quan hệ SANPHAM. 
	   Tạo quan hệ KHACHHANG1 chứa toàn bộ dữ liệu của quan hệ KHACHHANG.
	3. Cập nhật giá tăng 5% đối với những sản phẩm do “Thai Lan” sản xuất (cho quan hệ SANPHAM1)
	4. Cập nhật giá giảm 5% đối với những sản phẩm do “Trung Quoc” sản xuất có giá từ 10.000 trở xuống
	   (cho quan hệ SANPHAM1).
	5. Cập nhật giá trị LOAIKH là “Vip” đối với những khách hàng đăng ký thành viên trước ngày
		1/1/2007 có doanh số từ 10.000.000 trở lên hoặc khách hàng đăng ký thành viên từ 1/1/2007 trở về
		sau có doanh số từ 2.000.000 trở lên (cho quan hệ KHACHHANG1).
*/

--3
DROP TABLE SANPHAM1
SELECT * INTO SANPHAM1 FROM SANPHAM
--
UPDATE SANPHAM1
SET GIA = GIA * 1.05
WHERE NUOCSX = 'THAILAN';
--KIEM TRA KẾT QUẢ
SELECT s.TENSP, s.GIA, s1.GIA AS TANGGIA
FROM SANPHAM s, SANPHAM1 S1
WHERE s.NUOCSX = 'THAILAN'  and s.MASP = s1.MASP;
--4 
DROP TABLE SANPHAM1
SELECT * INTO SANPHAM1 FROM SANPHAM
--
UPDATE SANPHAM1
SET GIA = GIA * 0.95
WHERE NUOCSX = 'TRUNGQUOC' AND GIA <= 10000 ;
--KIEM TRA KẾT QUẢ
SELECT s.TENSP, s.GIA, s1.GIA AS GIAMGIA
FROM SANPHAM s, SANPHAM1 S1
WHERE s.NUOCSX = 'TRUNGQUOC' AND s.GIA <= 10000 and s.MASP = s1.MASP;

--5
--DROP TABLE KHACHHANG1
SELECT * INTO KHACHHANG1 FROM KHACHHANG
--
UPDATE KHACHHANG1 
SET LOAIKH = 'Vip'
WHERE (DOANHSO > 10000000 AND NGDK < '1/1/2007') OR (DOANHSO > 20000000 AND NGDK > '1/1/2007')
--KIEM TRA KẾT QUẢ
SELECT K.MAKH, K.DOANHSO, K.LOAIKH , K1.LOAIKH AS LOAIKHCN
FROM KHACHHANG K, KHACHHANG1 K1
WHERE K.MAKH = K1.MAKH

/*
III. Ngôn ngữ truy vấn dữ liệu:
	1. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất.
	2. In ra danh sách các sản phẩm (MASP, TENSP) có đơn vị tính là “cay”, ”quyen”.
	3. In ra danh sách các sản phẩm (MASP,TENSP) có mã sản phẩm bắt đầu là “B” và kết thúc là “01”.
	4. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quốc” sản xuất có giá từ 30.000 đến
	40.000.
	5. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” hoặc “Thai Lan” sản xuất có giá từ
	30.000 đến 40.000.
	6. In ra các số hóa đơn, trị giá hóa đơn bán ra trong ngày 1/1/2007 và ngày 2/1/2007.
	7. In ra các số hóa đơn, trị giá hóa đơn trong tháng 1/2007, sắp xếp theo ngày (tăng dần) và trị giá của
	hóa đơn (giảm dần).
	8. In ra danh sách các khách hàng (MAKH, HOTEN) đã mua hàng trong ngày 1/1/2007.
	9. In ra số hóa đơn, trị giá các hóa đơn do nhân viên có tên “Nguyen Van B” lập trong ngày
	28/10/2006.
	10. In ra danh sách các sản phẩm (MASP,TENSP) được khách hàng có tên “Nguyen Van A” mua trong
	tháng 10/2006.
	11. Tìm các số hóa đơn đã mua sản phẩm có mã số “BB01” hoặc “BB02”.
	12. Tìm các số hóa đơn đã mua sản phẩm có mã số “BB01” hoặc “BB02”, mỗi sản phẩm mua với số
	lượng từ 10 đến 20.
	13. Tìm các số hóa đơn mua cùng lúc 2 sản phẩm có mã số “BB01” và “BB02”, mỗi sản phẩm mua với
	số lượng từ 10 đến 20.
	14. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất hoặc các sản phẩm được
	bán ra trong ngày 1/1/2007.
	15. In ra danh sách các sản phẩm (MASP,TENSP) không bán được.
	16. In ra danh sách các sản phẩm (MASP,TENSP) không bán được trong năm 2006.
	17. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất không bán được trong
	năm 2006.
	18. Tìm số hóa đơn đã mua tất cả các sản phẩm do Singapore sản xuất.
	19. Tìm số hóa đơn trong năm 2006 đã mua ít nhất tất cả các sản phẩm do Singapore sản xuất.
	20. Có bao nhiêu hóa đơn không phải của khách hàng đăng ký thành viên mua?
	21. Có bao nhiêu sản phẩm khác nhau được bán ra trong năm 2006.
	22. Cho biết trị giá hóa đơn cao nhất, thấp nhất là bao nhiêu ?
	23. Trị giá trung bình của tất cả các hóa đơn được bán ra trong năm 2006 là bao nhiêu?
	24. Tính doanh thu bán hàng trong năm 2006.
	25. Tìm số hóa đơn có trị giá cao nhất trong năm 2006.
	26. Tìm họ tên khách hàng đã mua hóa đơn có trị giá cao nhất trong năm 2006.
	27. In ra danh sách 3 khách hàng đầu tiên (MAKH, HOTEN) sắp xếp theo doanh số giảm dần.
	28. In ra danh sách các sản phẩm (MASP, TENSP) có giá bán bằng 1 trong 3 mức giá cao nhất.
	29. In ra danh sách các sản phẩm (MASP, TENSP) do “Thai Lan” sản xuất có giá bằng 1 trong 3 mức
	giá cao nhất (của tất cả các sản phẩm).
	30. In ra danh sách các sản phẩm (MASP, TENSP) do “Trung Quoc” sản xuất có giá bằng 1 trong 3 mức
	giá cao nhất (của sản phẩm do “Trung Quoc” sản xuất).
	31. * In ra danh sách khách hàng nằm trong 3 hạng cao nhất (xếp hạng theo doanh số).
	32. Tính tổng số sản phẩm do “Trung Quoc” sản xuất.
	33. Tính tổng số sản phẩm của từng nước sản xuất.
	34. Với từng nước sản xuất, tìm giá bán cao nhất, thấp nhất, trung bình của các sản phẩm.
	35. Tính doanh thu bán hàng mỗi ngày.
	36. Tính tổng số lượng của từng sản phẩm bán ra trong tháng 10/2006.
	37. Tính doanh thu bán hàng của từng tháng trong năm 2006.
	38. Tìm hóa đơn có mua ít nhất 4 sản phẩm khác nhau.
	39. Tìm hóa đơn có mua 3 sản phẩm do “Viet Nam” sản xuất (3 sản phẩm khác nhau).
	40. Tìm khách hàng (MAKH, HOTEN) có số lần mua hàng nhiều nhất.
	41. Tháng mấy trong năm 2006, doanh số bán hàng cao nhất ?
	42. Tìm sản phẩm (MASP, TENSP) có tổng số lượng bán ra thấp nhất trong năm 2006.
	43. *Mỗi nước sản xuất, tìm sản phẩm (MASP,TENSP) có giá bán cao nhất.
	44. Tìm nước sản xuất sản xuất ít nhất 3 sản phẩm có giá bán khác nhau.
	45. *Trong 10 khách hàng có doanh số cao nhất, tìm khách hàng có số lần mua hàng nhiều nhất.
*/

--1
SELECT MASP,TENSP FROM SANPHAM WHERE NUOCSX = 'TRUNGQUOC'
--2
SELECT MASP,TENSP FROM SANPHAM WHERE DVT = 'Cay' or DVT = 'Quyen'
--3
/*
	%	:Đại diện cho số không hoặc nhiều ký tự
	_	:Đại diện cho một ký tự
	[]	:Đại diện cho bất kỳ ký tự nào trong dấu ngoặc
	^	:Đại diện cho bất kỳ ký tự nào không ở trong dấu ngoặc
	-	:Đại diện cho một loạt các ký tự
*/
SELECT MASP,TENSP FROM SANPHAM WHERE MASP LIKE 'B%01'
--4
SELECT MASP,TENSP FROM SANPHAM WHERE NUOCSX = 'TRUNGQUOC' AND GIA >= 30000 AND GIA <= 40000
SELECT MASP,TENSP FROM SANPHAM WHERE NUOCSX = 'TRUNGQUOC' AND GIA BETWEEN 30000 AND 40000
--5
SELECT MASP,TENSP FROM SANPHAM WHERE NUOCSX = 'TRUNGQUOC' OR NUOCSX = 'THAILAN' AND GIA BETWEEN 30000 AND 40000
SELECT MASP,TENSP FROM SANPHAM WHERE NUOCSX IN ('TRUNGQUOC' ,'THAILAN') AND GIA BETWEEN 30000 AND 40000
--6
SELECT SOHD, TRIGIA FROM HOADON WHERE NGHD = '1/1/2007' OR NGHD = '2/1/2007'
--7
SELECT SOHD, TRIGIA 
FROM HOADON 
WHERE MONTH(NGHD) = 1 AND YEAR(NGHD) = 2007 
ORDER BY NGHD ASC, TRIGIA DESC
--8
SELECT K.MAKH, K.HOTEN 
FROM KHACHHANG K, HOADON H
WHERE H.NGHD = '1/1/2007' AND K.MAKH = H.MAKH
--9



	

