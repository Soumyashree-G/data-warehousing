--trigger_which_calls_the_procedure_on_insert
DELIMITER $$
CREATE TRIGGER call_the_proc AFTER insert ON order_details
FOR EACH ROW
BEGIN
    CALL get_data2 (order_id,amount);
END$$
DELIMITER ;;

--procedure
DELIMITER $$
CREATE PROCEDURE get_data2 ( order_id int,amount dec(10,2))
BEGIN
    INSERT IGNORE INTO sale (order_id) values (NEW.order_id);
    SET @ID = (SELECT id from sale where order_id = NEW.order_id order by order_id desc limit 1);
    INSERT INTO sale_line (sku_id, reference_id) values (NEW.sku_id, @ID);
    
    set @AMT:= (select amount from order_details where order_id = new.order_id order by order_id);
    update sale
    set amount = new.amount  where order_id = new.order_id;
END$$
DELIMITER ;;