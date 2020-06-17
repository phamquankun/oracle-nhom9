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
        v_cmnd);
    
    v_query := 'CREATE USER '
               || 'c##'
               || v_cmnd
               || ' IDENTIFIED BY '
               || v_cmnd;
    EXECUTE IMMEDIATE ( v_query );
         
    IF v_chucvu like 'L? tân' then
    v_query := 'GRANT c##DA_LETAN TO '
               || 'c##'
               || v_cmnd;
                 EXECUTE IMMEDIATE ( v_query );
    elsif v_chucvu like 'Qu?n lí' then
    v_query := 'GRANT c##DA_QUANLI TO '
               || 'c##'
               || v_cmnd;
                 EXECUTE IMMEDIATE ( v_query );
    else
    v_query := 'GRANT c##DA_KETOAN TO '
               || 'c##'
               || v_cmnd;
                 EXECUTE IMMEDIATE ( v_query );
    end if;   
end;
execute them_nhanvien('Duy Hiu','1011112','0000','Tien Giang','Qu?n lí');