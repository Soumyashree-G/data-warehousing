--TRIGGER ON INSERT INTO ORDER_DETAILS


DELIMITER $$
CREATE TRIGGER get_data AFTER insert ON order_details
FOR EACH ROW
BEGIN
    
    INSERT IGNORE INTO sale (order_id) values (NEW.order_id);
    SET @ID = (SELECT id from sale where order_id = NEW.order_id order by order_id desc limit 1);
    INSERT INTO sale_line (sku_id, reference_id) values (NEW.sku_id, @ID);
    
    set @AMT:= (select amount from order_details where order_id = new.order_id order by order_id);
    update sale
    set amount = new.amount  where order_id = new.order_id;
    
END$$
DELIMITER ;;


--TRIGGER AFTER UPDATE ON ORDER_DETAILS

DELIMITER ;;
DELIMITER $$
CREATE TRIGGER get_data1 AFTER update  ON order_details
FOR EACH ROW
BEGIN
    delete from sale where order_id= old.order_id;
    INSERT IGNORE INTO sale (order_id) values (NEW.order_id);
    SET @ID = (SELECT id from sale where order_id = NEW.order_id order by order_id desc limit 1);
    delete from sale_line where sku_id= old.sku_id;
    INSERT INTO sale_line (sku_id, reference_id) values (NEW.sku_id, @ID);
    set @AMT:= (select amount from order_details where order_id = new.order_id order by order_id);
    update sale
    set amount = new.amount  where order_id = new.order_id;
END$$
DELIMITER ;;

--TRIGGER AFTER DELETE

DELIMITER ;;
DELIMITER $$
CREATE TRIGGER get_data2 AFTER DELETE ON order_details
FOR EACH ROW
BEGIN
	delete from sale where order_id = old.order_id;
	delete from sale_line where sku_id=old.sku_id;
	delete from sale where amount = old.amount;
END$$
DELIMITER ;;