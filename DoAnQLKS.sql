alter table phong add CONSTRAINT fk_loaiphong FOREIGN KEY (loaiphong) REFERENCES loaiphong(idphong);
alter table thuephong add CONSTRAINT fk_khid FOREIGN KEY (kh_id) REFERENCES khachhang(id);
alter table thuephong add CONSTRAINT fk_sophong FOREIGN KEY (so_phong) REFERENCES phong(sophong);
alter table khachhang add CONSTRAINT fk_lkh FOREIGN KEY (loaikhach) REFERENCES loaikhach(loaikhach);
alter table hoadon add CONSTRAINT fk_ma_nv FOREIGN KEY (manv) REFERENCES nhanvien(manv);
alter table hoadon add CONSTRAINT fk_mapt FOREIGN KEY (mapt) REFERENCES thuephong(maso);
alter table hoadon add CONSTRAINT fk_matdv FOREIGN KEY (matdv) REFERENCES thuedichvu(maso);
alter table thuedichvu add CONSTRAINT fk_mapt_tdv FOREIGN KEY (mapt) REFERENCES thuephong(maso);
create sequence manv
increment by 1
start with 1
maxvalue 999
nocycle;
insert into nhanvien values(manv.nextval,'Quan','000','090','HN','Nothing');
insert into nhanvien values(manv.nextval,'Quan11','11','11','HN1','Nothing1');
alter table dichvu add constraint uq_tendv unique(tendv);
select * from dichvu dv join thuedichvu tdv on dv.tendv=tdv.dichvu;
