SELECT current_database();
create table first_table ( col1 integer, col2 integer);
insert into first_table (col1, col2) values(10,15);
insert into first_table (col1, col2) values(11,16);
insert into first_table (col1, col2) values(12,17);
insert into first_table (col1, col2) values(13,18);
insert into first_table (col1, col2) values(14,19);
insert into first_table (col1, col2) values(15,20);
select * from first_table;

select * from base_usuarios;

select * from ibm_prices_bronze;
select * from ibm_prices_silver;
select * from ibm_prices_gold;