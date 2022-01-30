
create table ingredients (
    id serial PRIMARY KEY,
    name varchar (100) NOT NULL unique,
    regional_provenance varchar  (100) NOT NULL,
    price decimal,
    from_baker bool,
    stock_amount int,
    is_show bool
);


create table suppliers (
    id serial PRIMARY KEY,
    name varchar  (100) NOT NULL,
    is_active bool
);

create table ingredients_assortment (
  id serial PRIMARY KEY,
  supplier_id int,
  ingredients_id int,
    FOREIGN KEY (ingredients_id)
      REFERENCES ingredients (id),
    FOREIGN KEY (supplier_id)
      REFERENCES suppliers (id)

);

create table customers (
    id serial PRIMARY KEY,
    name varchar (100) NOT NULL
);

create table pizza_compositions (
    id serial PRIMARY KEY,
    pizza_size varchar (100) NOT NULL,
);

create table composition_configs (
    id serial PRIMARY KEY,
    pizza_composition_id int,
    ingredients_id int,
    quantity int,
    total_price decimal,
    FOREIGN KEY (ingredients_id)
      REFERENCES ingredients (id),
    FOREIGN KEY (pizza_composition_id)
      REFERENCES pizza_compositions (id)
);

create table orders (
    id serial PRIMARY KEY,
    customer_id int,
    composition_id int,
    created_on TIMESTAMP NOT NULL,
    FOREIGN KEY (customer_id)
      REFERENCES customers (id),
    FOREIGN KEY (composition_id)
      REFERENCES pizza_compositions (id)

);


-- Order calculate the number of unique regional provenance
-- Order calculate the number of unique regional provenance
-- 
-- Insert Ingredients

create or replace function insert_ingredients(name varchar, regional_provenance varchar, price decimal, from_baker bool, stock_amount int, is_show bool) returns int   as $$
    begin
		insert into ingredients(name, regional_provenance, price, from_baker,  stock_amount, is_show) values (name, regional_provenance, price, from_baker,  stock_amount, is_show) ;
		return (select id from ingredients order by id desc limit 1);
	end
$$ language plpgsql;

-- select insert_ingredients('cheese', 'DE',100.00, false, nulls)
-- select insert_ingredients('chilli sauce', 'DE',100.00, false,10,true )
-- update Ingredients


create or replace function update_ingredients(id_info int, name_info varchar, reg_prov varchar, prc decimal, from_bk bool, stk_amnt int, is_shw bool) returns table(names varchar, regional_provenances varchar, prices decimal, from_bakers bool, stock_amounts int, is_shows bool)   as $$
    begin
		update ingredients set name = name_info, regional_provenance = reg_prov, price = prc, from_baker = from_bk, stock_amount = stk_amnt, is_show = is_shw where id = id_info ;
		return query select name, regional_provenance, price, from_baker, stock_amount, is_show from ingredients where id = id_info;
	end
$$ language plpgsql;

-- Drop
create or replace function delete_ingredients(id_info int) returns void   as $$
    begin
		delete from ingredients where id = id_info ;
	end
$$ language plpgsql;



-- Insert Suppliers
create or replace function insert_suppliers(name varchar,  is_active bool ) returns int as $$
    begin
		insert into suppliers(name, is_active) values (name, is_active) ;
		return (select id from suppliers order by id desc limit 1);
	end
$$ language plpgsql;

-- select insert_ingredients('chilli sauce', 'DE',100.00, false,10,true )
-- Update Suppliers
create or replace function update_supplier(id_info int, name_info varchar, is_actv bool) returns table(names varchar, actv bool)   as $$
    begin
		update suppliers set name = name_info, is_active = is_actv where id = id_info ;
		return query select name, is_active from suppliers where id = id_info;
	end
$$ language plpgsql;

-- Drop Supplier
create or replace function delete_supplier(id_info int) returns void   as $$
    begin
		delete from suppliers where id = id_info ;
	end
$$ language plpgsql;

-- insert ingredients_assortment
create or replace function insert_ingredients_assortment(ingredients_id int,  supplier_id int ) returns int as $$
    begin
		insert into ingredients_assortment(ingredients_id, supplier_id) values (ingredients_id, supplier_id) ;
		return (select id from ingredients_assortment order by id desc limit 1);
	end
$$ language plpgsql;

-- Update ingredients_assortment




-- Insert Customer

create or replace function insert_customer(name varchar ) returns int as $$
    begin
		insert into customers(name) values (name) ;
		return (select id from customers order by id desc limit 1);
	end
$$ language plpgsql;

-- Update Customer
create or replace function update_customer(id_info int, name_info varchar ) returns table(names varchar)   as $$
    begin
		update customers set name = name_info where id = id_info ;
		return query select name from customers where id = id_info;
	end
$$ language plpgsql;



-- Drop Customer
create or replace function delete_customer(id_info int) returns void   as $$
    begin
		delete from customers where id = id_info ;
	end
$$ language plpgsql;


-- update stock

create or replace function change_stock(composition_id int) returns varchar as $$
	declare
	data_comp record;
	current_stock int;
	begin

		for data_comp in
			select * from composition_configs com where com.pizza_composition_id = composition_id
		loop
			select ing.stock_amount into current_stock from ingredients ing where ing.id = data_comp.ingredients_id;
			update ingredients ing set stock_amount = (current_stock-data_comp.quantity) where ing.id=data_comp.ingredients_id;
		end loop;
		return 'SUccess0';
	end
$$ language plpgsql;

-- generate order

create or replace function generate_order(customer_id int, compostion_id int, created_on timestamp) returns varchar as $$
    DECLARE
        r record;
        result bool;
        current_stock int;
    begin
        result := false;
        FOR r in
             select * from composition_configs t where t.pizza_composition_id = compostion_id
        LOOP
            select ing.stock_amount into current_stock from ingredients ing where ing.id = r.ingredients_id;
            if r.quantity > current_stock then
                return 'Stock out for this order';
            end if;
            end loop;
        insert into orders(customer_id, composition_id, created_on) values (customer_id, compostion_id, created_on);
        perform change_stock(compostion_id);
        return 'Order Successfully created';

    end
$$ language plpgsql;

-- test query
-- select generate_order(1,1, '2021-01-24 21:56:48.000000')

-- Pizza Composition Function Start
create or replace function insert_pizza_compositions(pizza_size varchar) returns int   as $$
    begin
		insert into pizza_compositions(pizza_size) values (pizza_size) ;
		return (select id from pizza_compositions order by id desc limit 1);
	end
$$ language plpgsql;


--get pizza_composition
create or replace function get_pizza_composition() returns table(
	composition_id int,
     composition_size varchar,
	base_config_shown bool) as $$ 
	begin
		return query select id ,pizza_size   from pizza_compositions;
	end
$$ language plpgsql;

--update pizza_composition
create or replace function update_pizza_composition(compos_id int,compos_size varchar) returns table(composition_id int,composition_size varchar) as $$ 
	begin
		update pizza_compositions set pizza_size = compos_size  where id= compos_id;
		return query select id ,pizza_size  from pizza_compositions;
	end
$$ language plpgsql;



--delete pizza_composition

create or replace function delete_pizza_composition(pizza_compos_id int) returns void as $$ 
	begin
		DELETE FROM pizza_compositions where id= pizza_compos_id;
	end
$$ language plpgsql;

-- Pizza Composition End

--insert pizza_composition_config

create or replace function insert_pizza_compositions_config(pizza_composition_id int,ingredients_id int,quantity int,total_price decimal) returns int   as $$
    begin
		insert into composition_configs(pizza_composition_id, ingredients_id,quantity,total_price) values (pizza_composition_id, ingredients_id,quantity,total_price) ;
		return (select id from composition_configs order by id desc limit 1);
	end
$$ language plpgsql;

--get pizza_composition_config

create or replace function get_pizza_composition_config() returns table(compos_config_id int,pizzacompositionId int,ingredientsId int,pizza_composition_quantity int,composition_total_price decimal) as $$ 
	begin
		return query select id,pizza_composition_id,ingredients_id,quantity,total_price from composition_configs;
	end
$$ language plpgsql

--upadte pizza_composition_config

create or replace function update_pizza_composition_config(config_id int,pizzacompos_id int,ingredient_id int,compos_quantity int,compos_total_price decimal) returns table(compos_config_id int,pizzacompositionId int,ingredientsId int,pizza_composition_quantity int,composition_total_price decimal) as $$ 
	begin
		update composition_configs set pizza_composition_id=pizzacompos_id,ingredients_id=ingredient_id,quantity=compos_quantity,total_price = compos_total_price where id= config_id;
		return query select id,pizza_composition_id, ingredients_id,quantity,total_price from composition_configs;
	end
$$ language plpgsql;

--delete pizza_composition_config

create or replace function delete_pizza_composition_config(pizza_compos_config_id int) returns void as $$ 
	begin
		DELETE FROM composition_configs where id= pizza_compos_config_id;
	end
$$ language plpgsql;


--get orders


create or replace function get_order() returns table(order_id int,customerId int,compositionId int, createdOn timestamp) as $$ 
	begin
		return query select id,customer_id,composition_id,created_on from orders;
	end
$$ language plpgsql

-- get ingredients
create or replace function get_all_ingredients() returns table(pk int,names varchar,regional_provenances varchar,prices decimal,from_bakers bool,stock_amount int, is_shows bool) as $$
	begin
		return query select id ,name ,regional_provenance ,price ,from_baker, stock_amount, is_show from ingredients;
	end
$$ language plpgsql;

select get_all_ingredients();


-- get suppliers


create or replace function get_all_suppliers(key_search varchar) returns table(pk int,names varchar, is_actives bool) as $$
	begin
	    if key_search = 'ALL' then
            return query select id ,name ,is_active from suppliers;
        else
	        return query select id ,name ,is_active from suppliers where is_active = true;
        end if;

	end
$$ language plpgsql;

-- get customer

create or replace function get_all_customers() returns table(pk int,names varchar) as $$
	begin
	        return query select id ,name  from customers ;

	end
$$ language plpgsql;

select get_all_customers();


create or replace function restock_ingredients(pk int) returns varchar as $$
    DECLARE
        r record;
        ing_ass record;
        is_from_baker bool;
        current_stock int;
        curr_active bool;
	begin
        select ingd.from_baker, ingd.stock_amount into is_from_baker, current_stock from ingredients as ingd where id=pk;
        if is_from_baker then
            update ingredients set stock_amount = current_stock +10 where id=pk;
            return 'SUCCESSFULLY RESTOCK THE INGREDIENTS';
        else
            for r in select * from ingredients_assortment where ingredients_id = pk
            loop
                select sup.is_active into curr_active from suppliers sup where sup.id = r.supplier_id;
                if curr_active then
                    update ingredients set stock_amount = current_stock +10 where id=pk;
                    return 'SUCCESSFULLY RESTOCK THE INGREDIENTS';
                end if;
                end loop;
        end if;
        return 'SUPPLIER NOT AVAILABLE TO RESTOCK THE INGREDIENTS';
	end
$$ language plpgsql;


-- select * from restock_ingredients(2)

create or replace function get_available_suppliers_from_ing_assort(ing_id int) returns table(ids int, sup_name varchar) as $$
    DECLARE
        r record;
	begin
        return query select sup.id,sup.name from suppliers as sup inner join (select * from ingredients_assortment as ing_assort where ing_assort.ingredients_id = ing_id ) as item on item.supplier_id = sup.id;
	end
$$ language plpgsql;

select * from get_available_suppliers_from_ing_assort(3)





