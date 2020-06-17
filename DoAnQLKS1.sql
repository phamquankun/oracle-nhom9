
--themkhachhang
CREATE OR REPLACE PROCEDURE them_khachhang (
    v_cmnd        khachhang.cmnd%TYPE,
    v_hoten       khachhang.hoten%TYPE,
    v_diachi      khachhang.diachi%TYPE,
    v_sdt         khachhang.sdt%TYPE,
    v_loaikhach   khachhang.loaikhach%TYPE
    
) AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
    /**
     * Thêm khách hàng vào b?ng khachhang
     */
    INSERT INTO khachhang (cmnd,hoten,diachi,sdt,loaikhach) VALUES (
        v_cmnd,
        v_hoten,
        v_diachi,
        v_sdt,
        v_loaikhach
        
    );
    /**
     * Thêm vào b?ng ng??i dùng
     * M?t kh?u m?t ??nh trùng vs CMND
     */

   /* INSERT INTO dangnhap VALUES (
        v_cmnd,
        v_cmnd
    );*/
end;

execute them_khachhang('8989','LeuLeu1','LeuLeuLeu1','0001','NoiDia');
--xoakhachhang
alter table khachhang
add unique(cmnd);
CREATE OR REPLACE PROCEDURE xoa_khachhang (
    v_cmnd khachhang.cmnd%TYPE
) AS
    --v_query   VARCHAR2(1000);
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
    /**
     * Xóa khách hàng trong b?ng nguoidung
     */
    /*DELETE dangnhap
    WHERE
        username = v_cmnd;*/
    /**
     * Xóa khách hàng trong b?ng khách hàng
     */

    DELETE khachhang
    WHERE
        cmnd = v_cmnd;
    /**
     * Xóa user 
     */

    /*v_query := 'DROP USER '
               || 'U'
               || v_cmnd
               || ' CASCADE';*/
    --EXECUTE IMMEDIATE ( v_query );
    /**
     * K?t thúc
     */
    COMMIT;
END;
execute xoa_khachhang('123456');
/
alter table thuephong
modify ngaythue default sysdate;
alter table thuephong modify ngaythue default NULL;
CREATE OR REPLACE PROCEDURE them_phieuthue (
   -- v_maso      thuephong.maso%type,
    v_khid      thuephong.kh_id%type,
    v_sophong   thuephong.so_phong%type,
    v_ngaythue  thuephong.ngaythue%type,
    v_ngaytra   thuephong.ngaytra%type
) AS  v_maso  thuephong.maso%type;
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
    /**
     * 
     */
    INSERT INTO thuephong(kh_id, so_phong,ngaythue,ngaytra) values(v_khid,v_sophong,v_ngaythue,v_ngaytra);
    /**
     * 
     */
      select maso into v_maso
     from thuephong
     order by maso desc
     fetch first 1 row only;
     
    INSERT INTO hoadon(mapt) values(v_maso);

    update phong set tinhtrang = '?ã ??t' where sophong=v_sophong;

    /**
     * K?t thúc
     */
    COMMIT;
END;
alter session set "_oracle_script"=true;
execute them_phieuthue('45','5',to_date('26/05/2020','DD/MM/YYYY'),to_date('27/05/2020','DD/MM/YYYY'));

alter table thuephong add constraint CK_DATE1 check(ngaythue>=sysdate);
alter table thuephong add constraint CK_DATE2 check(ngaytra >=ngaythue);
--xoaphieuthemphpong
CREATE OR REPLACE PROCEDURE xoa_phieuthue (
    v_maso      thuephong.maso%type
) AS
v_sophong   phong.sophong%type;
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
    select so_phong into v_sophong
    from thuephong
    where maso = v_maso;
    /**
     * 
     */
    delete from thuedichvu where mapt=v_maso;
    delete from hoadon where mapt=v_maso;
    delete from thuephong where maso=v_maso;
    /**
     * 
     */

    update phong set tinhtrang = 'Ch?a ??t' where sophong= v_sophong;

    /**
     * K?t thúc
     */
    COMMIT;
END;
execute xoa_phieuthue(344);
/
--themnhanvien
CREATE OR REPLACE PROCEDURE them_nhanvien (
    v_tennv       nhanvien.tennv%TYPE,
    v_cmnd        nhanvien.cmnd%TYPE,
    v_sdt         nhanvien.sdt%TYPE,
    v_diachi      nhanvien.diachi%TYPE,
    v_chucvu      nhanvien.chucvu%TYPE
    
) AS
v_query   VARCHAR2(1000);
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
    /**
     * Them nhan vien vao bang nhan vien
     */
    INSERT INTO nhanvien (manv,tennv,cmnd,sdt,diachi,chucvu) VALUES (
        manv.nextval,
        v_tennv,
        v_cmnd,
        v_sdt,
        v_diachi,
        v_chucvu
        
    );

   INSERT INTO dangnhap VALUES (
        v_cmnd,
        v_cmnd
         
    IF v_chucvu like 'L? tân' then
    v_query := 'GRANT c##DA_LETAN'
               || 'c##'
               || v_cmnd;
    else if v_chucvu like 'Qu?n lí' then
    v_query := 'GRANT c##DA_QUANLI'
               || 'c##'
               || v_cmnd;
    else
    v_query := 'GRANT c##DA_QUANLI'
               || 'c##'
               || v_cmnd;
    end if;
    EXECUTE IMMEDIATE ( v_query );
    
end;
execute them_nhanvien('DP','69','0900','DN','Nothing');
--xoanhanvien
CREATE OR REPLACE PROCEDURE xoa_nhanvien (
    v_cmnd nhanvien.cmnd%TYPE
) AS
    v_query   VARCHAR2(1000);
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
    /**
     * Xóa nhan vien trong b?ng nguoidung
     */
    DELETE dangnhap
    WHERE
        username = v_cmnd;
    /**
     * Xóa nhan vien trong nhan vien
     */

    DELETE nhanvien
    WHERE
        cmnd = v_cmnd;
    /**
     * Xóa user 
     */

    v_query := 'DROP USER '
               || 'c##'
               || v_cmnd
               || ' CASCADE';
    EXECUTE IMMEDIATE ( v_query );
    /**
     * K?t thúc
     */
    COMMIT;
END;
execute xoa_nhanvien('69');
----------------TRIGGER
CREATE OR REPLACE TRIGGER DK_THUEPHONG BEFORE 
  INSERT ON THUEPHONG
  FOR EACH ROW
DECLARE
  v_ngkt date;
  v_tinhtrang varchar2(20);
BEGIN
  SELECT TINHTRANG into v_tinhtrang FROM PHONG P WHERE :new.SO_PHONG = P.SOPHONG;
  IF v_tinhtrang ='?ã ??t' THEN
        SELECT
            ngaytra
        INTO v_ngkt
        FROM
            thuephong
        WHERE
            :new.so_phong = so_phong
        ORDER BY
            ngaytra DESC
        FETCH FIRST 1 ROW ONLY;
        IF v_ngkt > :new.ngaythue THEN
            raise_application_error(-20011, 'Phòng ?ang ???c thuê');
        END IF;
    END IF;
END;

execute them_phieuthue('5','7',to_date('7/6/2020','DD/MM/YYYY'),to_date('10/6/2020','DD/MM/YYYY'));
execute them_phieuthue('5','7',to_date('9/6/2020','DD/MM/YYYY'),to_date('11/6/2020','DD/MM/YYYY'));
execute them_phieuthue('21','7',to_date('9/6/2020','DD/MM/YYYY'),to_date('12/6/2020','DD/MM/YYYY'));
execute them_phieuthue('21','7',to_date('13/6/2020','DD/MM/YYYY'),to_date('16/6/2020','DD/MM/YYYY'));
----------------------------------------------
-----view_baocao loai khach theo thang nam-----
CREATE OR REPLACE VIEW BAOCAO_LK(
  "LK",
  "SL",
  "TL",
  "M",
  "Y"
)  AS 
    SELECT 
        b.lk,
        b.sl,
        ( b.sl / a.tong ) * 100 tile,
        b.m,
        b.y
    FROM 
        (
            SELECT
                COUNT(DISTINCT c.maso) tong,
                EXTRACT(MONTH FROM c.ngaythue) m,
                EXTRACT(YEAR FROM c.ngaythue) y,
                EXTRACT(MONTH FROM c.ngaythue) + EXTRACT(YEAR FROM c.ngaythue) my
            FROM
                ( thuephong   c
                JOIN khachhang   k ON c.kh_id = k.id )
                JOIN loaikhach   l ON k.loaikhach = l.loaikhach 
            GROUP BY
                EXTRACT(MONTH FROM c.ngaythue),
                EXTRACT(YEAR FROM c.ngaythue),
                EXTRACT(MONTH FROM c.ngaythue) + EXTRACT(YEAR FROM c.ngaythue)
        ) a
        JOIN (
            SELECT
                l.loaikhach   lk,
                COUNT(DISTINCT c.maso) sl,
                EXTRACT(MONTH FROM c.ngaythue) m,
                EXTRACT(YEAR FROM c.ngaythue) y,
                EXTRACT(MONTH FROM c.ngaythue) + EXTRACT(YEAR FROM c.ngaythue) my
            FROM
                ( thuephong   c
                JOIN khachhang   k ON c.kh_id = k.id )
                JOIN loaikhach   l ON k.loaikhach = l.loaikhach 
            GROUP BY
                l.loaikhach,
                EXTRACT(MONTH FROM c.ngaythue),
                EXTRACT(YEAR FROM c.ngaythue),
                EXTRACT(MONTH FROM c.ngaythue) + EXTRACT(YEAR FROM c.ngaythue)
        ) b on a.my = b.my
    ORDER BY
        b.m,
        b.y;
select * from baocao_lk;
----------baocao_theo loai phong----------
CREATE OR REPLACE VIEW baocao_loaiphong (
    "LP",
    "SL",
    "TL",
    "M",
    "Y"
) AS
    SELECT
        b.lp,
        b.sl,
        ( b.sl / a.tong ) * 100 tile,
        b.m,
        b.y
    FROM
        (
            SELECT
                COUNT(DISTINCT p.maso) tong,
                EXTRACT(MONTH FROM p.ngaythue) m,
                EXTRACT(YEAR FROM p.ngaythue) y,
                EXTRACT(MONTH FROM p.ngaythue) + EXTRACT(YEAR FROM p.ngaythue) my
            FROM
                ( thuephong   p
                JOIN phong       ph ON p.so_phong = ph.sophong )
                JOIN loaiphong   l ON l.idphong = ph.loaiphong
            GROUP BY
                EXTRACT(MONTH FROM p.ngaythue),
                EXTRACT(YEAR FROM p.ngaythue),
                EXTRACT(MONTH FROM p.ngaythue) + EXTRACT(YEAR FROM p.ngaythue)
        ) a
        JOIN (
            SELECT
                l.idphong   lp,
                COUNT(DISTINCT p.maso) sl,
                EXTRACT(MONTH FROM p.ngaythue) m,
                EXTRACT(YEAR FROM p.ngaythue) y,
                EXTRACT(MONTH FROM p.ngaythue) + EXTRACT(YEAR FROM p.ngaythue) my
            FROM
                ( thuephong   p
                JOIN phong       ph ON p.so_phong = ph.sophong )
                JOIN loaiphong   l ON l.idphong = ph.loaiphong
            GROUP BY
                l.idphong,
                EXTRACT(MONTH FROM p.ngaythue),
                EXTRACT(YEAR FROM p.ngaythue),
                EXTRACT(MONTH FROM p.ngaythue) + EXTRACT(YEAR FROM p.ngaythue)
        ) b ON a.my = b.my
    ORDER BY
        b.m,
        b.y;
select * from BAOCAO_LOAIPHONG;
----baocaotheodichvu
CREATE OR REPLACE VIEW baocao_dichvu (
    "LDV",
    "SL",
    "TL",
    "M",
    "Y"
) AS
    SELECT
        b.ldv,
        b.sl,
        ( b.sl / a.tong ) * 100 tile,
        b.m,
        b.y
    FROM
        (
            SELECT
                COUNT(DISTINCT p.maso) tong,
                EXTRACT(MONTH FROM p.ngaythue) m,
                EXTRACT(YEAR FROM p.ngaythue) y,
                EXTRACT(MONTH FROM p.ngaythue) + EXTRACT(YEAR FROM p.ngaythue) my
            FROM
                 thuedichvu   p
  
            GROUP BY
                EXTRACT(MONTH FROM p.ngaythue),
                EXTRACT(YEAR FROM p.ngaythue),
                EXTRACT(MONTH FROM p.ngaythue) + EXTRACT(YEAR FROM p.ngaythue)
        ) a
        JOIN (
            SELECT
                p.dichvu   ldv,
                COUNT(DISTINCT p.maso) sl,
                EXTRACT(MONTH FROM p.ngaythue) m,
                EXTRACT(YEAR FROM p.ngaythue) y,
                EXTRACT(MONTH FROM p.ngaythue) + EXTRACT(YEAR FROM p.ngaythue) my
            FROM
                 thuedichvu   p
            GROUP BY
                p.dichvu ,
                EXTRACT(MONTH FROM p.ngaythue),
                EXTRACT(YEAR FROM p.ngaythue),
                EXTRACT(MONTH FROM p.ngaythue) + EXTRACT(YEAR FROM p.ngaythue)
        ) b ON a.my = b.my
    ORDER BY
        b.m,
        b.y;
select * from baocao_dichvu;
----------------------
---view_sophong
CREATE OR REPLACE VIEW baocao_sophong (
    "SP",
    "SL",
    "TL",
    "M",
    "Y"
) AS
    SELECT
        b.sp,
        b.sl,
        ( b.sl / a.tong ) * 100 tile,
        b.m,
        b.y
    FROM
        (
            SELECT
                COUNT(DISTINCT p.maso) tong,
                EXTRACT(MONTH FROM p.ngaythue) m,
                EXTRACT(YEAR FROM p.ngaythue) y,
                EXTRACT(MONTH FROM p.ngaythue) + EXTRACT(YEAR FROM p.ngaythue) my
            FROM
                thuephong   p
                JOIN phong       ph ON p.so_phong = ph.sophong 
            GROUP BY
                EXTRACT(MONTH FROM p.ngaythue),
                EXTRACT(YEAR FROM p.ngaythue),
                EXTRACT(MONTH FROM p.ngaythue) + EXTRACT(YEAR FROM p.ngaythue)
        ) a
        JOIN (
            SELECT
                ph.sophong  sp,
                COUNT(DISTINCT p.maso) sl,
                EXTRACT(MONTH FROM p.ngaythue) m,
                EXTRACT(YEAR FROM p.ngaythue) y,
                EXTRACT(MONTH FROM p.ngaythue) + EXTRACT(YEAR FROM p.ngaythue) my
            FROM
                thuephong   p
                JOIN phong       ph ON p.so_phong = ph.sophong 
            GROUP BY
                ph.sophong,
                EXTRACT(MONTH FROM p.ngaythue),
                EXTRACT(YEAR FROM p.ngaythue),
                EXTRACT(MONTH FROM p.ngaythue) + EXTRACT(YEAR FROM p.ngaythue)
        ) b ON a.my = b.my
    ORDER BY
        b.m,
        b.y;
select * from baocao_sophong;
----------tinhtienhoadon
CREATE OR REPLACE PROCEDURE THANHTIEN_HOADON(
  v_mapt   thuephong.maso%TYPE
) IS

    v_ng   NUMBER := 0;
    v_tt   NUMBER := 0;
    v_dv   dichvu.gia%TYPE := 0;
    v_dg   hoadon.thanhtien_thuephong%TYPE := 0;
    v_hs   loaikhach.heso%TYPE := 0;
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT
    round((months_between(p.ngaythue, p.ngaytra)) * 31, 1)
    INTO v_ng
    FROM
        thuephong p join hoadon hd on p.maso=hd.mapt
    WHERE
        p.maso = v_mapt;
SELECT
        (
            CASE
                WHEN SUM(dv.gia) IS NULL THEN
                    0
                ELSE
                    SUM(DV.gia)
            END
        )
    INTO v_dv
FROM
        thuedichvu tdv
        JOIN dichvu     dv ON dv.tendv = tdv.dichvu
WHERE
        tdv.maso = v_mapt;
---------        -------------
SELECT
        lk.heso
    INTO v_hs
FROM
        ( thuephong   c
        JOIN khachhang   k ON c.kh_id = k.id )
        JOIN loaikhach   lk ON lk.loaikhach = k.loaikhach
WHERE
        c.maso = v_mapt
ORDER BY
        lk.heso DESC
FETCH FIRST 1 ROW ONLY;
/**
     * L?y ??n giá c?a phòng l?u vào bi?n v_dg
     * ??n giá c?a phòng ???c tính theo h? s? cao nh?t c?a khách hàng thuê (v_hs)
     * Tính ti?n thuê phòng l?u vào bi?n v_tt
     * Ti?n thuê phòng ít nh?t là 200
    **/
    SELECT
        lp.gia
    INTO v_dg
    FROM
        ( loaiphong   lp
        JOIN phong       p ON lp.idphong = p.loaiphong )
        JOIN thuephong   pt ON pt.so_phong = p.sophong
    WHERE
      pt.maso = v_mapt;
      v_dg := v_dg * v_hs / 100;
      v_tt := v_dg * v_ng;

    /**
     * Tính thành ti?n c?a hóa ??n l?u vào bi?n v_tt
     * Thành ti?n = ti?n phòng + ti?n d?ch v? - khuy?n mãi
     * Khuy?n mãi ch? tr? vào ti?n thuê phòng
     */
    v_tt := v_tt + v_dv - (v_tt / 100 );
    COMMIT;
END;
-----------------------------------------
select p.sophong sp, p.loaiphong lp
from phong p
where p.sophong not in (select distinct tp.so_phong from thuephong tp join hoadon hd on tp.maso=hd.mapt where tonghoadon is null and ((to_date('18/06/2020','DD/MM/YYYY') between tp.ngaythue and tp.ngaytra )
  or (to_date('24/06/2020','DD/MM/YYYY') between tp.ngaythue and tp.ngaytra)
  or (tp.ngaythue between to_date('18/06/2020','DD/MM/YYYY') and to_date('24/06/2020','DD/MM/YYYY'))
  or (tp.ngaytra between to_date('18/06/2020','DD/MM/YYYY') and to_date('24/06/2020','DD/MM/YYYY'))))
  order by sp;





















