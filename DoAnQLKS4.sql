SELECT
        (
            CASE
                WHEN SUM(dv.gia) IS NULL THEN
                    0
                ELSE
                    SUM(DV.gia)
            END
        )
    --INTO v_dv
FROM
        thuedichvu tdv
        JOIN dichvu     dv ON dv.tendv = tdv.dichvu
WHERE
        tdv.mapt = '342';