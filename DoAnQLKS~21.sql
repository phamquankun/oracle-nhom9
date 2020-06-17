select username from dual;

create table ab(
  username nvarchar2(100),
  num number
);

create or replace trigger ab_ins
before insert on ab
for each row
begin
  :new.username := substr(user,4,20);
end;
select * from ab;
insert into ab(num)values('0');

commit;


