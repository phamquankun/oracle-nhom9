select * from phong ph join thuephong tp on ph.SOPHONG=tp.SO_PHONG;
select * from thuedichvu tdv, khachhang kh, thuephong tp
where tdv.KH_ID=kh.ID and kh.ID=tp.KH_ID;