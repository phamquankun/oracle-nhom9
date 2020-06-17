CREATE ROLE c##DA_LETAN NOT IDENTIFIED;
CREATE ROLE c##DA_QUANLI NOT IDENTIFIED;
CREATE ROLE c##DA_KETOAN NOT IDENTIFIED;
GRANT SELECT,INSERT,UPDATE,DELETE ON THUEPHONG  TO c##DA_LETAN;
GRANT SELECT,INSERT,UPDATE,DELETE ON THUEDICHVU TO c##DA_LETAN;
GRANT SELECT,INSERT,UPDATE,DELETE ON KHACHHANG  TO c##DA_QUANLI;
GRANT SELECT,INSERT,UPDATE,DELETE ON NHANVIEN  TO c##DA_QUANLI;
GRANT SELECT,INSERT,UPDATE,DELETE ON PHONG  TO c##DA_QUANLI;
GRANT SELECT,INSERT,UPDATE,DELETE ON LOAIPHONG  TO c##DA_QUANLI;
GRANT SELECT,INSERT,UPDATE,DELETE ON DICHVU  TO c##DA_QUANLI;
GRANT CONNECT TO c##DA_LETAN;
GRANT CONNECT TO c##DA_QUANLI;
GRANT CONNECT TO c##DA_KETOAN;
grant create session to c##DA_LETAN;
grant create session to c##DA_QUANLI;
grant create session to c##DA_KETOAN;
ALTER PROFILE DEFAULT LIMIT PASSWORD_LIFE_TIME UNLIMITED;
grant c##DA_QUANLI to c##DH00;
grant c##DA_Quanli to c##1011112;

grant insert on ab to c##DA_LETAN,c##DA_QUANLI,c##DA_KETOAN;