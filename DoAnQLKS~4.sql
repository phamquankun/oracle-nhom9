SELECT
    round((months_between(p.ngaytra, p.ngaythue)) * 31, 1)
    --INTO v_ng
    FROM
        thuephong p 
    WHERE
        p.maso = '342';
        
select * from baocao_loaiphong;