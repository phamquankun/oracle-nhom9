CREATE OR REPLACE PROCEDURE THANHTIEN_HOADON(
  v_mapt   thuephong.maso%TYPE
) IS

    v_ng   NUMBER := 0;
    v_ttp   NUMBER := 0;
    v_tt   NUMBER := 0;
    v_dv   dichvu.gia%TYPE := 0;
    v_dg   loaiphong.gia%TYPE := 0;
    v_hs   loaikhach.heso%TYPE := 0;
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT
    round((months_between(p.ngaytra, p.ngaythue)) * 31, 1)
    INTO v_ng
    FROM
        thuephong p 
    WHERE
        p.maso = v_mapt;
UPDATE HOADON SET songay=v_ng where v_mapt=mapt;
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
        tdv.mapt = v_mapt;
UPDATE HOADON SET thanhtien_tdv=v_dv where v_mapt=mapt;
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
     * L?y ??n gi� c?a ph�ng l?u v�o bi?n v_dg
     * ??n gi� c?a ph�ng ???c t�nh theo h? s? cao nh?t c?a kh�ch h�ng thu� (v_hs)
     * T�nh ti?n thu� ph�ng l?u v�o bi?n v_tt
     * Ti?n thu� ph�ng �t nh?t l� 200
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
      v_dg := v_dg * v_hs;
      v_ttp := v_dg * v_ng;
      UPDATE HOADON SET THANHTIEN_THUEPHONG=v_ttp where v_mapt=mapt;
    /**
     * T�nh th�nh ti?n c?a h�a ??n l?u v�o bi?n v_tt
     * Th�nh ti?n = ti?n ph�ng + ti?n d?ch v? - khuy?n m�i
     * Khuy?n m�i ch? tr? v�o ti?n thu� ph�ng
     */
    v_tt := v_ttp + v_dv ;
    UPDATE HOADON SET TONGHOADON=v_tt where v_mapt=mapt;
    COMMIT;
END;
execute thanhtien_hoadon('342');
execute thanhtien_hoadon('364');