USE master
IF EXISTS  (SELECT * FROM SYS.databases WHERE NAME = 'QLGV')
BEGIN
	ALTER DATABASE QLGV SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE QLGV;
END
GO

CREATE DATABASE QLGV
GO

USE QLGV
GO
--Câu 1
CREATE TABLE HOCVIEN (
MaHocVien VARCHAR(10) PRIMARY KEY,
Ho VARCHAR(40),
Ten VARCHAR(40),
NgaySinh SMALLDATETIME,
GioiTinh VARCHAR(3),
NoiSinh VARCHAR(40),
MaLop CHAR(3),
)
GO
CREATE TABLE LOP (
MaLop CHAR(4) PRIMARY KEY,
TenLop VARCHAR(40),
TruongLop CHAR(5),
SiSo TINYINT,
MaGiaoVienChuNhiem CHAR(4),
)
GO
CREATE TABLE KHOA (
MaKhoa CHAR(4) PRIMARY KEY,
TenKhoa VARCHAR(40),
NgayThanhLap SMALLDATETIME,
TruongKhoa CHAR(5),
)
GO
CREATE TABLE GIAOVIEN
(
	MaGiaoVien CHAR(4) PRIMARY KEY,
	Hoten VARCHAR(40),
	HOCVI VARCHAR(10),
	HOCHAM VARCHAR(10),
	GioiTinh VARCHAR(3),
	NgaySinh SMALLDATETIME,
	NgayVaoLam SMALLDATETIME,
	HeSo NUMERIC(4,2),
	MucLuong MONEY,
	MaKhoa CHAR(4) FOREIGN KEY REFERENCES KHOA(MaKhoa),
)
GO
CREATE TABLE MONHOC
(
	MaMonHoc VARCHAR(10) PRIMARY KEY,
	TenMonHoc VARCHAR(40),
	TinChiLiThuyet TINYINT,
	TinChiThucHanh TINYINT,
	MaKhoa CHAR(4) FOREIGN KEY REFERENCES KHOA(MaKhoa),
)
GO

CREATE TABLE DIEUKIEN
(
	MaMonHoc VARCHAR(10) FOREIGN KEY REFERENCES MONHOC(MaMonHoc),
	MaMonHocTruoc VARCHAR(10),
	PRIMARY KEY (MaMonHoc, MaMonHocTruoc),
)
GO
CREATE TABLE GIANGDAY
(
	MaLop CHAR(4) FOREIGN KEY REFERENCES LOP(MaLop),
	MaMonHoc VARCHAR(10) FOREIGN KEY REFERENCES MONHOC(MaMonHoc),
	MaGiaoVien CHAR(4) FOREIGN KEY REFERENCES GIAOVIEN(MaGiaoVien),
	HocKy TINYINT,
	Nam SMALLINT,
	TuNgay SMALLDATETIME,
	DenNgay SMALLDATETIME,
	PRIMARY KEY (MALOP, MaMonHoc),
)
GO


CREATE TABLE KETQUATHI
(
	MaHocVien VARCHAR(10) FOREIGN KEY REFERENCES HOCVIEN(MaHocVien),
	MaMonHoc VARCHAR(10) FOREIGN KEY REFERENCES MONHOC(MaMonHoc),
	LanThi TINYINT,
	NgayThi SMALLDATETIME,
	Diem NUMERIC(4,2),
	KetQua VARCHAR(10),
	PRIMARY KEY(MaHocVien, MaMonHoc, LanThi),
)
GO
ALTER TABLE HOCVIEN
ADD GHICHU VARCHAR(60)
GO

ALTER TABLE HOCVIEN
ADD DIEMTB NUMERIC(4,2)
GO

ALTER TABLE HOCVIEN
ADD XEPLOAI VARCHAR(10)
GO
--Câu 3
ALTER TABLE HOCVIEN
ADD CONSTRAINT CK_GioiTinh CHECK(GioiTinh IN ('NAM','NU'))
GO
--Câu 4
ALTER TABLE KETQUATHI
ADD CONSTRAINT CK_Diem CHECK
(
	DIEM BETWEEN 0 AND 10 AND
	LEN(SUBSTRING(CAST(DIEM AS VARCHAR), CHARINDEX('.', DIEM) +1,1000))>=2
)
GO
--Câu 5
ALTER TABLE KETQUATHI 
ADD CONSTRAINT CK_KUA CHECK(KetQua = IIF( DIEM BETWEEN 5 AND 10, 'DAT', 'KHONG DAT'))
GO

--Câu 6
ALTER TABLE KETQUATHI
ADD CONSTRAINT CK_SoLanThi CHECK(LANTHI <= 3)
GO

--Câu 7
ALTER TABLE GIANGDAY
ADD CONSTRAINT CK_HocKy CHECK(HocKy  BETWEEN 1 AND 3)
GO

--Câu 8
ALTER TABLE GIAOVIEN
ADD CONSTRAINT CK_HocVi CHECK(HocVi IN ('CN', 'KS', 'Ths', 'TS', 'PTS'))
GO

--Bài tập 2: Nhập dữ liệu cho CSDL QuanLyGiaoVu
INSERT INTO KHOA (MaKhoa, TenKhoa, NgayThanhLap, TruongKhoa)
VALUES
('KHMT', 'Khoa hoc may tinh', '2005-07-06', 'GV01'),
('HTTT', 'He thong thong tin', '2005-07-06', 'GV02'),
('CNPM', 'Cong nghe phan mem', '2005-07-06', 'GV04'),
('MTT', 'Mang va truyen thong', '2005-10-20', 'GV03'),
('KTMT', 'Ky thuat may tinh', '2005-12-20', NULL);


INSERT INTO LOP (MaLop, TenLop, TruongLop, SiSo, MaGiaoVienChuNhiem) 
VALUES
('K11', 'Lop 1 khoa 1', 'K1108', 11, 'GV07'),
('K12', 'Lop 2 khoa 1', 'K1205', 12, 'GV09'),
('K13', 'Lop 3 khoa 1', 'K1305', 12, 'GV14');
INSERT INTO MONHOC (MaMonHoc, TenMonHoc, TinChiLiThuyet, TinChiThucHanh, MaKhoa)
VALUES
('THDC', 'Tin hoc dai cuong', 4, 1, 'KHMT'),
('CTRR', 'Cau truc roi rac', 5, 2, 'KHMT'),
('CSDL', 'Co so du lieu', 3, 1, 'HTTT'),
('CTDLGT', 'Cau truc du lieu va giai thuat', 3, 1, 'KHMT'),
('PTTKTT', 'Phan tich thiet ke thuat toan', 3, 0, 'KHMT'),
('DHMT', 'Do hoa may tinh', 3, 1, 'KHMT'),
('KTMT', 'Kien truc may tinh', 3, 0, 'KTMT'),
('TKCSDL', 'Thiet ke co so du lieu', 3, 1, 'HTTT'),
('PTTKHTTT', 'Phan tich thiet ke he thong thong tin', 4, 1, 'HTTT'),
('HDH', 'He dieu hanh', 4, 1, 'KTMT'),
('NMCNPM', 'Nhap mon cong nghe phan mem', 3, 0, 'CNPM'),
('LTCFW', 'Lap trinh C for win', 3, 1, 'CNPM'),
('LTHDT', 'Lap trinh huong doi tuong', 3, 1, 'CNPM');
INSERT INTO GIAOVIEN (MaGiaoVien, HoTen, HOCVI, HOCHAM, GioiTinh, NgaySinh, NgayVaoLam, HeSo, MucLuong, MaKhoa) VALUES
('GV01', 'Ho Thanh Son', 'PTS', 'GS', 'Nam', '1950-05-02', '2004-01-11', 5.00, 2250000, 'KHMT'),
('GV02', 'Tran Tam Thanh', 'TS', 'PGS', 'Nam', '1965-12-17', '2004-04-20', 4.50, 2025000, 'HTTT'),
('GV03', 'Do Nghiem Phung', 'TS', 'GS', 'Nu', '1950-08-01', '2004-09-23', 4.00, 1800000, 'CNPM'),
('GV04', 'Tran Nam Son', 'TS', 'PGS', 'Nam', '1961-02-22', '2005-01-12', 4.50, 2025000, 'KTMT'),
('GV05', 'Mai Thanh Danh', 'ThS', 'GV', 'Nam', '1958-03-12', '2005-01-12', 3.00, 1350000, 'HTTT'),
('GV06', 'Tran Doan Hung', 'TS', 'GV', 'Nam', '1953-03-11', '2005-01-12', 4.50, 2025000, 'KHMT'),
('GV07', 'Nguyen Minh Tien', 'ThS', 'GV', 'Nam', '1971-11-23', '2005-03-01', 4.00, 1800000, 'KHMT'),
('GV08', 'Le Thi Tran', 'KS', NULL, 'Nu', '1974-03-26', '2005-03-01', 1.69, 760500, 'KHMT'),
('GV09', 'Nguyen To Lan', 'ThS', 'GV', 'Nu', '1966-12-31', '2005-03-01', 4.00, 1800000, 'HTTT'),
('GV10', 'Le Tran Anh Loan', 'KS', NULL, 'Nu', '1972-07-17', '2005-03-01', 1.86, 837000, 'CNPM'),
('GV11', 'Ho Thanh Tung', 'CN', 'GV', 'Nam', '1980-01-12', '2005-05-15', 2.67, 1201500, 'MTT'),
('GV12', 'Tran Van Anh', 'CN', NULL, 'Nu', '1981-03-29', '2005-05-15', 1.69, 760500, 'CNPM'),
('GV13', 'Nguyen Linh Dan', 'CN', NULL, 'Nu', '1980-05-23', '2005-05-15', 1.69, 760500, 'KTMT'),
('GV14', 'Truong Minh Chau', 'ThS', 'GV', 'Nu', '1976-11-30', '2005-05-15', 3.00, 1350000, 'MTT'),
('GV15', 'Le Ha Thanh', 'ThS', 'GV', 'Nam', '1978-05-04', '2005-05-15', 3.00, 1350000, 'KHMT');
INSERT INTO GIANGDAY (MaLop, MaMonHoc, MaGiaoVien, HocKy, Nam, TuNgay, DenNgay) 
VALUES
('K11', 'THDC', 'GV07', 1, 2006, '2006-01-02', '2006-05-12'),
('K12', 'THDC', 'GV06', 1, 2006, '2006-01-02', '2006-05-12'),
('K13', 'THDC', 'GV15', 1, 2006, '2006-01-02', '2006-05-12'),
('K11', 'CTRR', 'GV02', 1, 2006, '2006-01-09', '2006-05-17'),
('K12', 'CTRR', 'GV02', 1, 2006, '2006-01-09', '2006-05-17'),
('K13', 'CTRR', 'GV08', 1, 2006, '2006-01-09', '2006-05-17'),
('K11', 'CSDL', 'GV05', 2, 2006, '2006-06-01', '2006-07-15'),
('K12', 'CSDL', 'GV09', 2, 2006, '2006-06-01', '2006-07-15'),
('K13', 'CTDLGT', 'GV15', 2, 2006, '2006-06-01', '2006-07-15'),
('K13', 'CSDL', 'GV05', 3, 2006, '2006-08-01', '2006-12-15'),
('K13', 'DHMT', 'GV07', 3, 2006, '2006-08-01', '2006-12-15'),
('K11', 'CTDLGT', 'GV15', 3, 2006, '2006-08-01', '2006-12-15'),
('K12', 'CTDLGT', 'GV15', 3, 2006, '2006-08-01', '2006-12-15'),
('K11', 'HDH', 'GV04', 1, 2007, '2007-01-02', '2007-02-18'),
('K12', 'HDH', 'GV04', 1, 2007, '2007-01-02', '2007-03-20'),
('K11', 'DHMT', 'GV07', 1, 2007, '2007-02-18', '2007-03-20');
INSERT INTO HOCVIEN (MaHocVien, Ho, Ten, NgaySinh, GioiTinh, NoiSinh, MaLop) 
VALUES
('K1101', 'Nguyen', 'Van A', '1986-01-27', 'Nam', 'TpHCM', 'K11'),
('K1102', 'Tran', 'Ngoc Han', '1986-03-14', 'Nu', 'Kien Giang', 'K11'),
('K1103', 'Ha', 'Duy Lap', '1986-04-18', 'Nam', 'Nghe An', 'K11'),
('K1104', 'Tran', 'Ngoc Linh', '1986-03-30', 'Nu', 'Tay Ninh', 'K11'),
('K1105', 'Tran', 'Minh Long', '1986-02-27', 'Nam', 'TpHCM', 'K11'),
('K1106', 'Le', 'Nhat Minh', '1986-01-24', 'Nam', 'TpHCM', 'K11'),
('K1107', 'Nguyen', 'Nhu Nhut', '1986-01-27', 'Nam', 'Ha Noi', 'K11'),
('K1108', 'Nguyen', 'Manh Tam', '1986-02-27', 'Nam', 'Kien Giang', 'K11'),
('K1109', 'Phan', 'Thi Thanh Tam', '1986-01-27', 'Nu', 'Vinh Long', 'K11'),
('K1110', 'Le', 'Hoai Thuong', '1986-02-05', 'Nu', 'Can Tho', 'K11'),
('K1111', 'Le', 'Ha Vinh', '1986-12-25', 'Nam', 'Vinh Long', 'K11'),
('K1201', 'Nguyen', 'Van B', '1986-02-11', 'Nam', 'TpHCM', 'K12'),
('K1202', 'Nguyen', 'Thi Kim Duyen', '1986-01-18', 'Nu', 'TpHCM', 'K12'),
('K1203', 'Tran', 'Thi Kim Duyen', '1986-09-17', 'Nu', 'TpHCM', 'K12'),
('K1204', 'Truong', 'My Hanh', '1986-05-19', 'Nu', 'Dong Nai', 'K12'),
('K1205', 'Nguyen', 'Thanh Nam', '1986-04-17', 'Nam', 'TpHCM', 'K12'),
('K1206', 'Nguyen', 'Thi Truc Thanh', '1986-03-04', 'Nu', 'Kien Giang', 'K12'),
('K1207', 'Tran', 'Thi Bich Thuy', '1986-02-08', 'Nu', 'Nghe An', 'K12'),
('K1208', 'Huynh', 'Thi Kim Trieu', '1986-04-08', 'Nu', 'Tay Ninh', 'K12'),
('K1209', 'Pham', 'Thanh Trieu', '1986-02-23', 'Nam', 'TpHCM', 'K12'),
('K1210', 'Ngo', 'Thanh Tuan', '1986-02-14', 'Nam', 'TpHCM', 'K12'),
('K1211', 'Do', 'Thi Xuan', '1986-03-09', 'Nu', 'Ha Noi', 'K12'),
('K1212', 'Le', 'Thi Phi Yen', '1986-03-12', 'Nu', 'TpHCM', 'K12'),
('K1301', 'Nguyen', 'Thi Kim Cuc', '1986-06-09', 'Nu', 'Kien Giang', 'K13'),
('K1302', 'Truong', 'Thi My Hien', '1986-03-18', 'Nu', 'Nghe An', 'K13'),
('K1303', 'Le', 'Duc Hien', '1986-03-21', 'Nam', 'Tay Ninh', 'K13'),
('K1304', 'Le', 'Quang Hien', '1986-04-18', 'Nam', 'TpHCM', 'K13'),
('K1305', 'Le', 'Thi Huong', '1986-03-27', 'Nu', 'TpHCM', 'K13'),
('K1306', 'Nguyen', 'Thai Huu', '1986-03-30', 'Nam', 'Ha Noi', 'K13'),
('K1307', 'Tran', 'Minh Man', '1986-05-28', 'Nam', 'TpHCM', 'K13'),
('K1308', 'Nguyen', 'Hieu Nghia', '1986-04-08', 'Nam', 'Kien Giang', 'K13'),
('K1309', 'Nguyen', 'Trung Nghia', '1987-01-18', 'Nam', 'Nghe An', 'K13'),
('K1310', 'Tran', 'Thi Hong Tham', '1986-04-22', 'Nu', 'Tay Ninh', 'K13'),
('K1311', 'Tran', 'Minh Thuc', '1986-04-04', 'Nam', 'TpHCM', 'K13'),
('K1312', 'Nguyen', 'Thi Kim Yen', '1986-09-07', 'Nu', 'TpHCM', 'K13');


INSERT INTO KETQUATHI (MaHocVien, MaMonHoc, LanThi, NgayThi, Diem, KetQua) 
VALUES
('K1101', 'CSDL', 1, '2006-07-20', 10.00, 'Dat'),
('K1101', 'CTDLGT', 1, '2006-12-28', 9.00, 'Dat'),
('K1101', 'THDC', 1, '2006-05-20', 9.00, 'Dat'),
('K1101', 'CTRR', 1, '2006-05-13', 9.50, 'Dat'),
('K1102', 'CSDL', 1, '2006-07-20', 4.00, 'Khong Dat'),
('K1102', 'CSDL', 2, '2006-07-27', 4.25, 'Khong Dat'),
('K1102', 'CSDL', 3, '2006-08-10', 4.50, 'Khong Dat'),
('K1102', 'CTDLGT', 1, '2006-12-28', 4.50, 'Khong Dat'),
('K1102', 'CTDLGT', 2, '2007-01-05', 4.00, 'Khong Dat'),
('K1102', 'CTDLGT', 3, '2007-01-15', 6.00, 'Dat'),
('K1102', 'THDC', 1, '2006-05-20', 5.00, 'Dat'),
('K1102', 'CTRR', 1, '2006-05-13', 7.00, 'Dat'),
('K1103', 'CSDL', 1, '2006-07-20', 3.50, 'Khong Dat'),
('K1103', 'CSDL', 2, '2006-07-27', 8.25, 'Dat'),
('K1103', 'CTDLGT', 1, '2006-12-28', 7.00, 'Dat'),
('K1103', 'THDC', 1, '2006-05-20', 8.00, 'Dat'),
('K1103', 'CTRR', 1, '2006-05-13', 6.50, 'Dat'),
('K1104', 'CSDL', 1, '2006-07-20', 3.75, 'Khong Dat'),
('K1104', 'CTDLGT', 1, '2006-12-28', 4.00, 'Khong Dat'),
('K1104', 'THDC', 1, '2006-05-20', 4.00, 'Khong Dat'),
('K1104', 'CTRR', 1, '2006-05-13', 4.00, 'Khong Dat'),
('K1104', 'CTRR', 2, '2006-05-20', 3.50, 'Khong Dat'),
('K1104', 'CTRR', 3, '2006-06-30', 4.00, 'Khong Dat'),
('K1201', 'CSDL', 1, '2006-07-20', 6.00, 'Dat'),
('K1201', 'CTDLGT', 1, '2006-12-28', 5.00, 'Dat'),
('K1201', 'THDC', 1, '2006-05-20', 8.50, 'Dat'),
('K1201', 'CTRR', 1, '2006-05-13', 9.00, 'Dat'),
('K1202', 'CSDL', 1, '2006-07-20', 8.00, 'Dat'),
('K1202', 'CTDLGT', 1, '2006-12-28', 4.00, 'Khong Dat'),
('K1202', 'CTDLGT', 2, '2007-01-05', 5.00, 'Dat'),
('K1202', 'THDC', 1, '2006-05-20', 4.00, 'Khong Dat'),
('K1202', 'THDC', 2, '2006-05-27', 4.00, 'Khong Dat'),
('K1202', 'CTRR', 1, '2006-05-13', 3.00, 'Khong Dat'),
('K1202', 'CTRR', 2, '2006-05-20', 4.00, 'Khong Dat'),
('K1202', 'CTRR', 3, '2006-06-30', 6.25, 'Dat'),
('K1203', 'CSDL', 1, '2006-07-20', 9.25, 'Dat'),
('K1203', 'CTDLGT', 1, '2006-12-28', 9.50, 'Dat'),
('K1203', 'THDC', 1, '2006-05-20', 10.00, 'Dat'),
('K1203', 'CTRR', 1, '2006-05-13', 10.00, 'Dat'),
('K1204', 'CSDL', 1, '2006-07-20', 8.50, 'Dat'),
('K1204', 'CTDLGT', 1, '2006-12-28', 6.75, 'Dat'),
('K1204', 'THDC', 1, '2006-05-20', 4.00, 'Khong Dat'),
('K1204', 'CTRR', 1, '2006-05-13', 6.00, 'Dat'),
('K1301', 'CSDL', 1, '2006-12-20', 4.25, 'Khong Dat'),
('K1301', 'CTDLGT', 1, '2006-07-25', 8.00, 'Dat'),
('K1301', 'THDC', 1, '2006-05-20', 7.75, 'Dat'),
('K1301', 'CTRR', 1, '2006-05-13', 8.00, 'Dat'),
('K1302', 'CSDL', 1, '2006-12-20', 6.75, 'Dat'),
('K1302', 'CTDLGT', 1, '2006-07-25', 5.00, 'Dat'),
('K1302', 'THDC', 1, '2006-05-20', 8.00, 'Dat'),
('K1302', 'CTRR', 1, '2006-05-13', 8.50, 'Dat'),
('K1303', 'CSDL', 1, '2006-12-20', 4.00, 'Khong Dat'),
('K1303', 'CTDLGT', 1, '2006-07-25', 4.50, 'Khong Dat'),
('K1303', 'CTDLGT', 2, '2006-08-07', 4.00, 'Khong Dat'),
('K1303', 'CTDLGT', 3, '2006-08-15', 4.25, 'Khong Dat'),
('K1303', 'THDC', 1, '2006-05-20', 4.50, 'Khong Dat'),
('K1303', 'CTRR', 1, '2006-05-13', 3.25, 'Khong Dat'),
('K1303', 'CTRR', 2, '2006-05-20', 5.00, 'Dat'),
('K1304', 'CSDL', 1, '2006-12-20', 7.75, 'Dat'),
('K1304', 'CTDLGT', 1, '2006-07-25', 9.75, 'Dat'),
('K1304', 'THDC', 1, '2006-05-20', 5.50, 'Dat'),
('K1304', 'CTRR', 1, '2006-05-13', 5.00, 'Dat'),
('K1305', 'CSDL', 1, '2006-12-20', 9.25, 'Dat'),
('K1305', 'CTDLGT', 1, '2006-07-25', 10.00, 'Dat'),
('K1305', 'THDC', 1, '2006-05-20', 8.00, 'Dat'),
('K1305', 'CTRR', 1, '2006-05-13', 10.00, 'Dat');

INSERT INTO DIEUKIEN (MaMonHoc, MaMonHocTruoc)
VALUES
('CSDL', 'CTRR'),
('CSDL', 'CTDLGT'),
('CTDLGT', 'THDC'),
('PTTKTT', 'THDC'),
('PTTKTT', 'CTDLGT'),
('DHMT', 'THDC'),
('LTHDT', 'THDC'),
('PTTKHTTT', 'CSDL');
SELECT * FROM HOCVIEN
SELECT * FROM DIEUKIEN
SELECT * FROM KETQUATHI
SELECT * FROM GIANGDAY
SELECT * FROM GIAOVIEN
SELECT * FROM MONHOC
SELECT * FROM LOP
SELECT * FROM KHOA
--Bài tập 4
--Câu 11: Học viên ít nhất là 18 tuổi.
SELECT *
FROM HOCVIEN
WHERE DATEDIFF(YEAR, NgaySinh, GETDATE()) >= 18;
--Câu 12: Giảng dạy một môn học ngày bắt đầu (TUNGAY) phải nhỏ hơn ngày kết thúc (DENNGAY).
SELECT *
FROM GIANGDAY
WHERE TuNgay < DenNgay;
--Câu 13:Giáo viên khi vào làm ít nhất là 22 tuổi.
SELECT *
FROM GIAOVIEN
WHERE DATEDIFF(DAY, NgaySinh, GETDATE()) >= 365 * 22;
--Câu 14:Tất cả các môn học đều có số tín chỉ lý thuyết và tín chỉ thực hành chênh lệch nhau không quá 3.
SELECT *
FROM MONHOC
WHERE ABS(TinChiLiThuyet - TinChiThucHanh) <= 3;

--Bài tập 6:
--Câu 1: In ra danh sách (mã học viên, họ tên, ngày sinh, mã lớp) lớp trưởng của các lớp.
SELECT MaHocVien, Ho, Ten, NgaySinh, LOP.MaLop
FROM HOCVIEN
LEFT JOIN LOP ON LOP.TruongLop= HOCVIEN.MaHocVien
WHERE LOP.TruongLop = HOCVIEN.MaHocVien;
--Câu 2: In ra bảng điểm khi thi (mã học viên, họ tên, lần thi, điểm số) môn CTRR của lớp “K12”, sắp xếp theo tên, họ học viên.
SELECT KQ.MaHocVien, HV.Ho + ' ' + HV.Ten AS HoTen, KQ.LanThi, KQ.Diem 
FROM KETQUATHI KQ 
INNER JOIN HOCVIEN HV 
ON KQ.MaHocVien = HV.MaHocVien
WHERE LEFT(HV.MaLop, 3) = 'K12' AND KQ.MaMonHoc = 'CTRR'
ORDER BY HV.Ten, HV.Ho;
--Câu 3:In ra danh sách những học viên (mã học viên, họ tên) và những môn học mà học viên đó thi lần thứ nhất đã đạt.
SELECT KQ.MaHocVien, HV.Ho + ' ' + HV.Ten AS HoTen, KQ.MaMonHoc
FROM KETQUATHI KQ 
INNER JOIN HOCVIEN HV 
ON KQ.MaHocVien = HV.MaHocVien
WHERE KQ.LanThi = 1 AND KQ.KetQua = 'DAT'
ORDER BY KQ.MaHocVien;
--Câu 4: In ra danh sách học viên (mã học viên, họ tên) của lớp “K11” thi môn CTRR không đạt (ở lần thi 1).
SELECT KQ.MaHocVien, HV.Ho + ' ' + HV.Ten AS HoTen
FROM KETQUATHI KQ 
INNER JOIN HOCVIEN HV 
ON KQ.MaHocVien = HV.MaHocVien
WHERE LEFT(HV.MaLop, 3) = 'K11' AND KQ.MaMonHoc = 'CTRR' AND KQ.LanThi = 1 AND KQ.KetQua = 'Khong Dat';
--Câu 5: * Danh sách học viên (mã học viên, họ tên) của lớp “K” thi môn CTRR không đạt (ở tất cả các lần thi).
SELECT A.MaHocVien, A.HoTen 
FROM (
    SELECT KQ.MaHocVien, HV.Ho + ' ' + HV.Ten AS HoTen, KQ.LanThi
    FROM KETQUATHI KQ 
    INNER JOIN HOCVIEN HV 
    ON KQ.MaHocVien = HV.MaHocVien
    WHERE LEFT(HV.MaLop, 3) = 'K11' AND KQ.MaMonHoc = 'CTRR' AND KQ.KetQua = 'Khong Dat'
) A 
INNER JOIN (
    SELECT KQ.MaHocVien, MAX(KQ.LanThi) AS LanThiMax 
    FROM KETQUATHI KQ 
    WHERE LEFT(KQ.MaHocVien, 3) = 'K11' AND KQ.MaMonHoc = 'CTRR'
    GROUP BY KQ.MaHocVien
) B 
ON A.MaHocVien = B.MaHocVien
WHERE A.LanThi = B.LanThiMax;

