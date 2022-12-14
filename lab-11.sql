﻿create database QLSV
go
use QLSV
go
create table Lop
(
	Malop nvarchar(5) not null,
	TenLop nvarchar(20) not null,
	SiSo int not null
	CONSTRAINT pk_lop  primary key  (Malop)
)
create table Sinhvien
(
	MaSV nvarchar(10) not null,
	Hoten nvarchar(50) not null,
	NgaySinh smalldatetime not null,
	Malop nvarchar(5) not null
	CONSTRAINT pk_masv primary key (MaSV)
)
create table MonHoc
(
	MaMH nvarchar(10) not null,
	TenMH nvarchar(50) not null,
	CONSTRAINT pk_mamh primary key (MaMH)
)
create table KetQua
(
	MaSV nvarchar(10) not null,
	MaMH nvarchar(10) not null,
	Diemthi float not null
)
go
alter table Sinhvien
with check add
CONSTRAINT fk_lop_sinhvien foreign key (Malop) references Lop(Malop)

alter table KetQua
with check add
CONSTRAINT fk_monhoc_ketqua foreign key (MaMH) references MonHoc(MaMH)

alter table KetQua
with check add
CONSTRAINT fk_sinhvien_ketqua foreign key (MaSV) references Sinhvien(MaSV)
insert into Lop values ('L01','Nss',2)
insert into Lop values ('L02','Nsas',2)
insert into Lop values ('L03','N1ss',3)
insert into Sinhvien values ('001','nth',cast('2002-08-29' as date), 'L01')
insert into Sinhvien values ('002','nth1',cast('2002-03-29' as date), 'L02')
insert into Sinhvien values ('003','nth2',cast('2002-04-29' as date), 'L03')
insert into MonHoc values ('mh01','LTCB')
insert into MonHoc values ('mh02','TRR')
insert into MonHoc values ('mh03','TCC')
insert into KetQua values ('001','mh01',8.7)
insert into KetQua values ('001','mh02',7.7)
insert into KetQua values ('003','mh01',9.1)
insert into KetQua values ('002','mh02',8)
insert into KetQua values ('001','mh03',8)
insert into KetQua values ('003','mh02',8.7)
------------Câu 1 Viết hàm diemtb dạng Scarlar function tính điểm trung bình của một sinh viên bất kỳ
create function diemtb(@masv nvarchar(10))
returns float 
as 
begin
return(select (avg(Diemthi)) from KetQua where @masv = MaSV)
end
go
print('Điểm trung bình là: '+CONVERT(nvarchar,dbo.diemtb('002')))
gom MaSV
-------------Câu 2 Viết hàm bằng 2 cách (table – value fuction và multistatement value function) tính điểm trung bình của cả lớp, thông tin gồ, Hoten, ĐiemTB, sử dụng hàm diemtb ở câu 1
create function Tinhdiem(@malop nvarchar(10))
returns table 
as 
return
	select s.masv, Hoten, trungbinh=dbo.diemtb(s.MaSV)
 from Sinhvien s join KetQua k on s.MaSV=k.MaSV
 where MaLop=@malop
 group by s.masv, Hoten
go
create function trbinhlop(@malop nvarchar(10))
returns @dsdiemtb table (masv char(5), tensv nvarchar(20), dtb float)
as
begin
 insert @dsdiemtb
 select s.masv, Hoten, trungbinh=dbo.diemtb(s.MaSV)
 from Sinhvien s join KetQua k on s.MaSV=k.MaSV
 where MaLop=@malop
 group by s.masv, Hoten
 return
end
go
select * from trbinhlop('L01')
--------Câu 3 Viết một thủ tục kiểm tra một sinh viên đã thi bao nhiêu môn, tham số là MaSV, (VD sinh viên có MaSV=01 thi 3 môn) kết quả trả về chuỗi thông báo “Sinh viên 01 thi 3 môn” hoặc “Sinh viên 01 không thi môn nào”
create proc kiemtra @masv nvarchar(10)
as
begin
 declare @dem int
 set @dem=(select count(*) from ketqua where Masv=@masv)
 if @dem = 0
 print 'sinh vien '+@masv + ' khong thi mon nao'
 else
 print 'sinh vien '+ @masv+ ' thi '+cast(@dem as nvarchar(10))+ 'mon'
end
go
exec kiemtra '001'

-----------Câu 4 Viết một trigger kiểm tra sỉ số lớp khi thêm một sinh viên mới vào danh sách sinh viên thì hệ thống cập nhật lại siso của lớp, mỗi lớp tối đa 10SV, nếu thêm vào &gt;10 thì thông báo lớp đầy và hủy giao dịch
create trigger kt_ss
on sinhvien for insert
as
begin
 declare @siso int
 set @siso=(select count(*) from sinhvien s
 where malop in(select malop from inserted))
 if @siso > 10
	 begin
	print 'Lop day'
	rollback tran
	end
	else
	begin
		 update lop
		set SiSo=@siso
		where malop in (select malop from inserted)
 end
end