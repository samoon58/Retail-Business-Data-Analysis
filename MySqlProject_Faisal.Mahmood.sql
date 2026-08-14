-- Creating database --
create database BaDa_Feb2026_FM; 

-- Use new Database --
Use Bada_Feb2026_FM;

-- Creating table Client --

Create table Clients (
	Client_id INT Not Null,
    Client_Name Varchar(25),
    Street_Address varchar(30),
    Citi Varchar(25),
    State Varchar(25),
    Phone varchar (20),
    PRIMARY KEY (Client_id)
    )
    ;
    
-- Inserting data into table --

INSERT into Clients (Client_id,Client_name,Street_Address,Citi,State,Phone)
Values
(1,'Vinte','3 Nevada Parkway','Syracuse','NY','315-252-7305'),
(2,'Myworks','34267 Glendale Parkway','Huntington','WV','304-659-1170'),
(3,'Yadel','096 Pawling Parkway','San Francisco','CA','415-144-6037'),
(4,'Kwideo','81674 Westerfiend Circle','Waco','TX','254-750-0784'),
(5,'Topiclounge','0863 Farmco Road','Portland','OR','971-888-9129')
;

-- 4.a Unique state --
Select distinct STATE
from mosh_customers;

-- 4.b New price --
Select unit_price , product_id,
unit_price * 1.1 as New_Price
From mosh_products;

-- 4.c invoice date after June 2019 --
-- Need to check as answer should be 7 rows --
SELECT invoice_id,client_id, invoice_total,payment_total,invoice_date,due_date
FROM mosh_invoices
Where invoice_date in(
select invoice_date
from mosh_invoices
where invoice_date> '06/30/2019');

-- 4.c antoher way --
SELECT invoice_id,client_id, invoice_total,payment_total,invoice_date,due_date
FROM mosh_invoices
Where invoice_date >'06/30/2019';


-- 4.d born after 1990 and having points more than 1000 --
SELECT  birth_date,points
from mosh_customers
 where  birth_date > 12/31/1990
 And points > 1000 ;

-- 4.e client id 5 
select client_id,amount
from mosh_payments
where client_id= 5
and amount > 20
;
use  bada_feb2026_fm;

-- 4.f product less expensive than lettuce--subquery
select name, unit_price
from mosh_products
where unit_price <(
select unit_price
from mosh_products
 where name LIKE '%Lettuce%' );
 

-- 5.a All possible payment method by Joining--
select *
from mosh_payment_methods as pm
Join mosh_payments as mp
on pm.payment_method_id = mp.payment_id;

-- 5#b joining clients and invices table--
select ct.client_id,ct.State,ct.phone,ct.client_name,it.payment_total,it.due_date,it.payment_date
from clients as ct
join mosh_invoices as it
	on ct.client_id = it.client_id;
    
-- 6#a clients without invoices
select c.client_id,Client_Name,invoice_total
from clients as c
left Join mosh_invoices as i
	On c.Client_id = i.Client_id
 where i.invoice_id is NULL;


-- revised 6b syntex....
## 6 # b with CTE

WITH larger_client  AS (
	select *
        from mosh_invoices
    where client_id > 3
    )
    select client_id , invoice_total
    from larger_client;
    
    
--- 6#c Group and Rank the clients-- need to use WINDOWS rank 

    SELECT 
        client_id, 
        SUM(invoice_total) as total_invoice ,
	    RANK() OVER (order by sum(invoice_total) DESC ) as Client_rank
	    FROM 
        mosh_invoices
        GROUP BY 
        client_id
;

-- 6#d Client with at least 2 invoices...

Select c.client_id
From clients as c
join mosh_invoices as i
On c.client_id = i.client_id
group by c.client_id
having count(i.invoice_id) >= 2;

-- 6#e Retrieve who choose payment method-1 ---

Select i.client_id,i.number,i.invoice_id,p.payment_method
From mosh_invoices as i	
join mosh_payments as p
On i.invoice_id = p.invoice_id
where p.payment_method = 1;



