use store;
select * from customers where last_name like '%field%' ;
select * from customers where last_name regexp'field';

select * from customers where last_name regexp '^brush';

select * from customers where last_name regexp 'field$';

select * from customers where last_name regexp 'field|mac';

select * from customers where last_name regexp'field|mac|rose';

select * from customers where last_name regexp'field$|mac|rose';

select * from customers where last_name regexp'e';


select * from customers where last_name regexp'[gim]e';

select * from customers where last_name regexp'e[yld]';

select * from customers where last_name regexp'[a-h]e';
-- ^ begining , $ end, | logical 'or' function,[abcd] to match abcd, [a-d] to match from a to d, 

select * from customers where last_name regexp 'ey$|on$';

select * from customers where first_name regexp 'elka|ambur';

select * from customers where last_name regexp '^my|se';

select * from customers where last_name regexp 'b[ru]';

select * from customers where phone is null;

select * from orders where shipped_date or shipper_id is null;

select * from customers
order by first_name;


select * from customers
order by first_name desc;

select * from customers
order by state, first_name;

select * from customers
order by state desc, first_name;

select * from customers
order by state desc, first_name desc;

select first_name , last_name from customers
order by birth_date;

select first_name , last_name, 10 as points from customers
order by first_name  ;

select  * from order_items where order_id = 2
order by quantity*unit_price desc; 

select  *, quantity*unit_price as total_price
from order_items where order_id = 2
order by quantity*unit_price desc; 

select *  from customers limit 3;

select *  from customers limit 6, 3;
-- selects only from 7to 9

select *  from customers 
order by points desc
limit 3;
-- top 3 most loyal customers, note limit should come in end

-- INNER JOIN TO TWO TABLES
select order_id, first_name, last_name  from orders
join customers on 
orders.customer_id = customers.customer_id;
-- orders.customer_id as customer id column is present in both tables


select order_id, orders.customer_id, first_name, last_name  from orders
join customers on 
orders.customer_id = customers.customer_id;

select order_id, o.customer_id, first_name, last_name
from orders o
join customers c 
on  o.customer_id = c.customer_id;

select * 
from order_items oi
join products p on 
oi.product_id = p.product_id;


-- joining across databases from sql_inventory and store databasses

select * 
from order_items oi
join sql_inventory.products p 
on oi.product_id = p.product_id;

-- activating sql inventory data base
use sql_inventory;
select * 
from store.order_items oi
join products p 
on oi.product_id = p.product_id;

-- Self join
use sql_hr;
select *
from employees e
join employees managertable
on e.reports_to = managertable.employee_id;


select e.employee_id, e.first_name, managertable.first_name as manager -- prefix two tables in self join 
from employees e
join employees managertable -- using different alias for same tables in self join
on e.reports_to = managertable.employee_id;

-- joining multiple tables
use store;
select o.order_id, o.order_date, c.first_name, c.last_name, os.name as status
from orders o
join customers c
 on o.customer_id = c.customer_id
join order_statuses os
on  o.status = os.order_status_id;

-- compound join conditions when a table has 2 composite keys ie  2 indexes and second table has also the same columns


-- Outer joins
-- first using inner join to identify missing data on join
use store;
select*
from customers c
join orders o
on c.customer_id=o.customer_id -- we are only returning customers that are common in both columns ie who have orders placed in customer column of order table
order by c.customer_id;

--  now outer joining
select*
from customers c
left join orders o
on c.customer_id=o.customer_id -- all records from customer table are returned ie no matter they have orders or not
order by c.customer_id;

select*
from customers c
right join orders o -- left means 1st table, right means second table
on c.customer_id=o.customer_id -- all reccords from right tbale are returned 
order by c.customer_id;


select p.product_id, p.name, oi.quantity
from products p
left join order_items oi
on p.product_id = oi.product_id;

-- outer joins between multiple table using inner join
select c.customer_id, c.first_name, o.order_id
from customers c
left join orders o
on c.customer_id=o.customer_id -- we are only returning customers that are common in both columns ie who have orders placed in customer column of order table
join shippers sh
on o.shipper_id = sh.shipper_id
order by c.customer_id;


-- outer joins between multiple table using left join
select c.customer_id, c.first_name, o.order_id, sh.name as shipper
from customers c
left join orders o
on c.customer_id=o.customer_id -- we are only returning customers that are common in both columns ie who have orders placed in customer column of order table
left join shippers sh
on o.shipper_id = sh.shipper_id
order by c.customer_id;

select 
o.order_id,
o.order_date,
c.first_name as customer,
sh.name as shipper,
os.name as status
from orders o
join customers c
on o.customer_id-c.customer_id
left join shippers sh
on o.shipper_id = sh.shipper_id
join order_statuses os
on o.status = os.order_status_id; 

-- self outer joins
-- first self inner jion
use sql_hr;
select  e.employee_id,
e.first_name,
m.first_name as manager
from employees e
join employees m
on e.reports_to = m.employee_id;

-- now self outer join
use sql_hr;
select  e.employee_id,
e.first_name,
m.first_name as manager
from employees e
left join employees m -- now the ceo is also listed in employees
on e.reports_to = m.employee_id;

-- using clause
---- first on clause example
use store;
select 
o.order_id, c.first_name
from orders o
join customers c
on o.customer_id = c.customer_id;

-- now usin clause
use store;
select 
o.order_id, c.first_name
from orders o
join customers c
using(customer_id) -- column name is same
left join shippers sh
using (shipper_id) ;

use invoicing;
select p.date, c.name as client, p.amount, pm.name as payment_method
from payments p
join clients c using (client_id)
join payment_methods pm
on p.payment_method = pm.payment_method_id;

-- cross joins to combine every record of one table with every record of another table

use store;
select c.first_name as customer,
p.name as product
from customers c
cross join products p
order by c.first_name;

select sh.name as shipper, p.name as product
from shippers sh
cross join products p
order by sh.name;


-- Unions
select *
from orders
where order_date >= '2019-01-01'; -- not thr right way hardcoding of date 


select order_id, order_date, 'active' as status
from orders
where order_date >= '2019-01-01'  
union 
select order_id, order_date, 'archived' as status
from orders
where order_date < '2019-01-01' ;

-- union from differnt table , just remember combine equal number of columns from both tables
select first_name
from customers
union 
select name
from shippers; 

select customer_id, first_name, points, 'bronze' as type
from customers
where points <2000
union 
select
customer_id, first_name, points, 'silver' as type
from customers
where points between 2000 and 3000
union 
select customer_id, first_name, points, 'gold' as type
from customers 
where points > 3000
order by first_name;

-- column attributes

-- insert row

insert into customers 
values (default, 'john', 'smith', default , null, 'address', 'city', 'se', default );


insert into customers 
(first_name,
last_name,
address,
city, 
state)
values( 'john', 'smith', 'address', 'city', 'st' );


-- inserting multiple rows
use store;
insert into shippers (name)
values ('Shipper1'), ('Shipper2'), ('Shipper3');

insert into products (name, quantity_in_stock,unit_price)
values ('product1', 10, 1.95),
		('product2', 10, 1.95),
		('product3', 10, 1.95);
        
-- INSERTING HIERARCHIAL ROWS
Insert into orders ( customer_id, order_date, status)
values (1, '2019-01-01', 1);

insert into order_items
values
( last_insert_id(), 1,1,2.95);



-- creating a copy of table
create table orders_archived  ;
insert into orders_archived
select *
from orders
where order_date < '2019-01-01';

use sql_invoicing;
create table invoices_archived as
select
	i.invoice_id,
    i.number,
    c.name as client,
    i.invoice_total,
    i.payment_total,
    i.invoice_date,
    i.payment_date,
    i.due_date
from invoices i
join clients c
using (client_id)
where payment_date is not null;

-- updating a single row
update invoices
set payment_total = 10, payment_date = '2019-03-01'
where invoice_id = 1;

update invoices
set payment_total = default, payment_date = null
where invoice_id = 1;

update invoices
set 
payment_total = invoice_total*0.5, 
payment_date = due_date
where invoice_id = 3;

-- updating multiple rows but before we have to tick off safe mode in sql editors in preference in edit tab
use invoicing;
update invoices
set
payment_total = invoice_total*0.5,
payment_date = due_date
where client_id in (3,4);

-- writing sql statement to give any customer born before 1990 50 extra points
use store;
update customers
set points = points +50
where birth_date < '1990-01-01';

-- Using SUBQUERIES in Updates
use invoicing;
update invoices
set
payment_total =invoice_total*0.5,
payment_date = due_date
where client_id =
					(select client_id
                    from clients
                    where name = 'myworks');

-- using subqueries for multiple rows
use invoicing;
update invoices
set
payment_total =invoice_total*0.5,
payment_date = due_date
where client_id in
				(select client_id 
                from clients 
                where state in ( 'CA', 'NY'))







