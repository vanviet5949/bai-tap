﻿create database QLVT
use QLVT

--CAU 1
CREATE TABLE VATTU (
	MAVT CHAR(4) PRIMARY KEY,
	TENVT NVARCHAR(20),
	DVTINH VARCHAR(4),
	SLCON INT
)
GO

CREATE TABLE HDBAN (
	MAHD VARCHAR(10) PRIMARY KEY,
	NGAYXUAT SMALLDATETIME,
	HOTENKHACH NVARCHAR(20)
)
GO

CREATE TABLE HANGXUAT(
	MAHD VARCHAR(10),
	MAVT CHAR(4),
	DONGIA MONEY,
	SLBAN INT,
	CONSTRAINT pk_hx PRIMARY KEY(MAHD, MAVT)
)
GO

INSERT INTO VATTU(MAVT,TENVT,DVTINH,SLCON) VALUES (N'VT01', N'XI MANG', 'VND', 100)
INSERT INTO VATTU(MAVT,TENVT,DVTINH,SLCON) VALUES(N'VT02', N'CAT', 'VND', 200)
INSERT INTO HDBAN(MAHD,NGAYXUAT,HOTENKHACH) VALUES(N'HD0031',CAST(N'2022-7-3'AS DATE),N'VU VAN VIET ')
INSERT INTO HDBAN(MAHD,NGAYXUAT,HOTENKHACH) VALUES(N'HD0035',CAST(N'2022-4-5'AS DATE),N'PHUNG MINH LONG ')
INSERT INTO HANGXUAT(MAHD,MAVT,DONGIA,SLBAN) VALUES(N'HD0031',N'VT01',150000, 200)
INSERT INTO HANGXUAT(MAHD,MAVT,DONGIA,SLBAN) VALUES(N'HD0032',N'VT01',230000, 400)
INSERT INTO HANGXUAT(MAHD,MAVT,DONGIA,SLBAN) VALUES(N'HD0034',N'VT02',110000, 300)
INSERT INTO HANGXUAT(MAHD,MAVT,DONGIA,SLBAN) VALUES(N'HD0035',N'VT02',140000, 100)


--CAU 2
select top 1 MAHD, sum(DONGIA) as TongTien from HANGXUAT group by MAHD,
DONGIA order by DONGIA desc
--CAU 3



--CAU 4
CREATE PROCEDURE C4 
@thang int, @nam int 
AS
SELECT 
SUM(SLBAN * DONGIA)
FROM HANGXUAT HX
INNER JOIN HDBAN HD ON HX.MAHD = HD.MAHD
where MONTH(HD.NGAYXUAT) = @THANG AND YEAR(HD.NGAYXUAT) = @NAM;
select top 1 MAHD, sum(DONGIA) as TongTien from HANGXUAT group by MAHD,
DONGIA order by DONGIA desc


