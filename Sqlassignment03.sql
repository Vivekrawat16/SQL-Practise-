1 Completed Sales Orders (Physical Items)


SELECT  oh.ORDER_ID,
        oi.ORDER_ITEM_SEQ_ID,
        oi.PRODUCT_ID,
        p.PRODUCT_TYPE_ID,
        oh.SALES_CHANNEL_ENUM_ID,
        oh.ORDER_DATE,
        oh.ENTRY_DATE,
        oh.STATUS_ID,
        os.STATUS_DATETIME,
        oh.ORDER_TYPE_ID,
        oh.PRODUCT_STORE_ID
from order_header oh
JOIN order_item oi ON oi.order_id = oh.order_id
JOIN order_status os ON os.order_id = oh.order_id
JOIN product p ON p.product_id = oi.product_id
JOIN product_type pt ON pt.product_type_id = p.PRODUCT_TYPE_ID
WHERE pt.IS_PHYSICAL = 'y'


2 Completed Return Items

select
	rh.RETURN_ID ,
	ri.ORDER_ID ,
	oh.PRODUCT_STORE_ID ,
	ri.STATUS_ID ,
	oh.ORDER_NAME ,
	rh.FROM_PARTY_ID ,
	rh.RETURN_DATE ,
	rh.ENTRY_DATE ,
	rh.RETURN_CHANNEL_ENUM_ID 
from 
return_header rh 
join 
return_item ri on rh.RETURN_ID = ri.RETURN_ID and ri.STATUS_ID = 'RETURN_COMPLETED'
join 
order_header oh on ri.ORDER_ID = oh.ORDER_ID;


3.Single-Return Orders (Last Month)

  
SELECT  p.PARTY_ID,
        p.FIRST_NAME,
        ri.order_id,
        COUNT(DISTINCT rh.return_id) AS total_returns
from return_header rh 
JOIN return_item ri ON ri.return_id = rh.return_id
JOIN person p ON p.party_id = rh.from_party_id
GROUP BY
        p.party_id,
        p.first_name,
        ri.order_id
HAVING COUNT(DISTINCT rh.return_id)  = 1;



4 Returns and Appeasements
  
select
    (select sum(return_quantity)
     from return_item) as total_returns,

    (select sum(return_price)
     from return_item) as return_total,

    (select count(*)
     from return_adjustment
     where return_adjustment_type_id = 'APPEASEMENT') as total_appeasements,

    (select sum(amount)
     from return_adjustment
     where return_adjustment_type_id = 'APPEASEMENT') as appeasements_total;

5 Detailed Return Information
  
SELECT  rh.RETURN_ID,
        rh.ENTRY_DATE,
        ra.RETURN_ADJUSTMENT_TYPE_ID,
        ra.AMOUNT,
        ra.COMMENTS,
        ri.ORDER_ID,
        oh.ORDER_DATE,
        oh.PRODUCT_STORE_ID
from return_header rh
JOIN return_adjustment ra ON ra.return_id = rh.return_id
JOIN return_item ri ON ri.return_id = ra.return_id
JOIN order_header oh ON oh.order_id = ri.order_id



6 Orders with Multiple Returns
  
select ri.ORDER_ID, sum(ri.RETURN_QUANTITY) from 
return_header rh 
join 
return_item ri on rh.RETURN_ID = ri.RETURN_ID and ri.STATUS_ID = 'RETURN_COMPLETED'
group by ri.ORDER_ID
having sum(ri.RETURN_QUANTITY) > 1;

7 Store with Most One-Day Shipped Orders (Last Month)
select s.origin_facility_id as facility_id,
       f.facility_name as name,
       count(distinct s.primary_order_id) as total_one_day_ship_orders
from shipment s
join shipment_method_type smt
    on s.shipment_method_type_id = smt.shipment_method_type_id
join facility f
    on f.facility_id = s.origin_facility_id
where s.status_id = 'SHIPMENT_SHIPPED'
  and  s.shipment_method_type_id = 'NEXT_DAY' 
and year(s.last_modified_date) = year(now() - interval 1 month)
and month(s.last_modified_date) = month(now() - interval 1 month)
group by s.origin_facility_id,
         f.facility_name
order by total_one_day_ship_orders desc;



8 List of Warehouse Pickers

select pr.party_id , 
       	concat(p.FIRST_NAME, ' ', p.LAST_NAME) as full_name, 
       	pr.role_type_id,pl.facility_id, 
       	pl.status_id,pr.THRU_DATE 

from picklist_role pr join picklist pl on pr.picklist_id= pl.picklist_id 
join person p on p.party_id= pr.party_id;


9 Total Facilities That Sell the Product


select pf.product_id,
       count(*) as facility_count
from product_facility pf
group by pf.product_id;


10 Total Items in Various Virtual Facilities
  
select 
ii.product_id,
ii.facility_id,
f.facility_type_id,
ii.Available_To_Promise_Total as ATP,
ii.Quantity_On_Hand_Total as QOH
from inventory_item ii 
join facility f on f.facility_id = ii.facility_id


11.

