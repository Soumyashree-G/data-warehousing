DELIMITER $$
CREATE TRIGGER call_the_proc AFTER insert ON order_details
FOR EACH ROW
BEGIN
    CALL get_data2 (new.amount,new.order_id,new.sku_id);
END$$
DELIMITER ;;

--procedure
DELIMITER $$
CREATE PROCEDURE get_data2 ( amt dec(15,3),ord_id int,skuid int )
BEGIN
    INSERT IGNORE INTO sale (order_id) values (ord_id);
	
    SET @ID := (SELECT id from sale where order_id = ord_id order by order_id desc limit 1);
    
    INSERT INTO sale_line (sku_id, reference_id) values (skuid, @ID);
    
    set @AMT:= (select amount from order_details where order_id = ord_id order by order_id);
    
    update sale
    set amount = amt  where order_id = ord_id;

END$$
DELIMITER ;;
drop trigger call_the_proc;
drop procedure if exists get_data2;