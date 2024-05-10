DROP DATABASE IF EXISTS db_market;

-- Initial Database
CREATE DATABASE IF NOT EXISTS db_market;

-- Initial Tables
CREATE TABLE IF NOT EXISTS db_market.products(
  	product_id INT AUTO_INCREMENT UNIQUE NOT NULL
  	, name VARCHAR(45) NOT NULL UNIQUE
  	, price INT NOT NULL
  	, stock INT NOT NULL
  	, description TEXT
  	, created_at DATETIME NOT NULL
  	, updated_at DATETIME NOT NULL
  	, deleted_at DATETIME
	, PRIMARY KEY(product_id)
);

CREATE TABLE IF NOT EXISTS db_market.customers(
	customer_id INT AUTO_INCREMENT UNIQUE NOT NULL
  	, name VARCHAR(45) NOT NULL
  	, gender VARCHAR(6) NOT NULL
  	, address TEXT NOT NULL
  	, is_member BOOLEAN
  	, created_at DATETIME NOT NULL
  	, updated_at DATETIME NOT NULL
  	, deleted_at DATETIME
  	, PRIMARY KEY(customer_id)
);

CREATE TABLE IF NOT EXISTS db_market.customer_order(
	customer_order_id INT NOT NULL
	, customer_id INT NOT NULL
	, grand_total_price INT NOT NULL
	, created_at DATETIME NOT NULL
  	, updated_at DATETIME NOT NULL
  	, deleted_at DATETIME
  	, PRIMARY KEY(customer_order_id)
  	, FOREIGN KEY (customer_id) REFERENCES db_market.customers(customer_id)
);

CREATE TABLE IF NOT EXISTS db_market.customer_order_detail(
	customer_order_detail_id INT AUTO_INCREMENT UNIQUE NOT NULL
	, customer_order_id INT NOT NULL
	, product_id INT NOT NULL
	, price INT NOT NULL
	, quantity INT NOT NULL
	, total_price INT NOT NULL
	, created_at DATETIME NOT NULL
  	, updated_at DATETIME NOT NULL
  	, deleted_at DATETIME
  	, PRIMARY KEY(customer_order_detail_id)
  	, FOREIGN KEY (customer_order_id) REFERENCES db_market.customer_order(customer_order_id)
  	, FOREIGN KEY (product_id) REFERENCES db_market.products(product_id)
);

-- Insert Data Sample
INSERT INTO db_market.products(product_id, name, price, stock, created_at, updated_at)
VALUES
	(1, 'Sabun mandi 25g', 3000, 100, NOW(), NOW())
	, (2, 'Odol 75g', 8000, 50, NOW(), NOW())
	, (3, 'Sikat Gigi', 5000, 150, NOW(), NOW())
;

INSERT INTO db_market.customers(customer_id, name, gender, address, is_member, created_at, updated_at)
VALUES
	(1, 'Pelanggan', 'Pria', 'Home', FALSE, NOW(), NOW())
	, (2, 'Jhon', 'Pria', 'Perum Bumi Indah Blok B1 No. 3', TRUE, NOW(), NOW())
	, (3, 'Fanny', 'Wanita', 'Perum Taman Teknologi AA2 No. 4', TRUE, NOW(), NOW())
;

INSERT INTO db_market.customer_order(customer_order_id, customer_id, grand_total_price, created_at, updated_at)
VALUES
	(1, 1, 16900, NOW(), NOW())
	, (2, 2, 50000, NOW(), NOW())
	, (3, 3, 130000, NOW(), NOW())
;

INSERT INTO db_market.customer_order_detail(customer_order_detail_id, customer_order_id, product_id, price, quantity, total_price, created_at, updated_at)
VALUES
	(1, 1, 1, 3000, 30, 9000, NOW(), NOW())
	, (2, 1, 2, 8000, 20, 160000, NOW(), NOW())
	, (3, 2, 3, 5000, 10, 50000, NOW(), NOW())
	, (4, 3, 2, 8000, 10, 80000, NOW(), NOW())
	, (5, 3, 3, 5000, 10, 50000, NOW(), NOW())
;

-- Initial Store Procedure (PL/SQL)
-- Module Product
DELIMITER //
CREATE PROCEDURE IF NOT EXISTS db_market.ProductGetAll(
	IN _size INT
	, IN _page INT
)
proc:BEGIN
	-- variabel
	DECLARE v_offset INT;
	DECLARE v_total_data INT;

	-- code
	IF _size <= 0 OR _page <= 0 THEN
		SELECT
			NOW() AS datetime
			, 400 AS code
			, 'Bad Request' AS status
			, 'Size dan Page tidak boleh kurang dari 1' AS message;
		ROLLBACK;
		LEAVE proc;
	END IF;

	SELECT COUNT(1) INTO v_total_data
	FROM db_market.products
	WHERE deleted_at IS NULL;

	IF v_total_data < 1 THEN
		SELECT
			NOW() AS datetime
			, 204 AS code
			, 'No Content' AS status
			, 'No Content' AS message;
	ELSE
		SELECT
			NOW() AS datetime
			, 200 AS code
			, 'OK' AS status
			, 'OK' AS message;		
	END IF;

	SET _size = IFNULL(_size, 10);
	SET _page = IFNULL(_page, 1);
	SET v_offset = (_page - 1) * _size;

	SELECT
		product_id
		, name
		, price
		, stock
		, description
	FROM db_market.products
	WHERE deleted_at IS NULL
	ORDER BY product_id DESC
	LIMIT _size
	OFFSET v_offset;

	SELECT
		_size AS page_size
		, v_total_data AS total_data
		, CEIL(v_total_data / _size) AS total_page
		, _page AS current_page;

	COMMIT;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE IF NOT EXISTS db_market.ProductGetById(
	IN _id INT
)
proc:BEGIN
	-- variabel
	DECLARE v_checker INT DEFAULT 0;
	
	-- code
	SELECT COUNT(1) INTO v_checker
	FROM db_market.products
	WHERE deleted_at IS NULL
	AND product_id = _id;

	IF v_checker < 1 THEN
		SELECT
			NOW() AS datetime
			, 404 AS code
			, 'Not found' AS status
			, 'Product dengan id tersebut tidak ditemukan!' AS message;
		ROLLBACK;
		LEAVE proc;
	END IF;

	SELECT
		NOW() AS datetime
		, 200 AS code
		, 'OK' AS status
		, 'OK' AS message;
   
   SELECT
		product_id
		, name
		, price
		, stock
		, description
	FROM db_market.products
	WHERE deleted_at IS NULL
	AND product_id = _id;

	COMMIT;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE IF NOT EXISTS db_market.ProductGetByName(
	IN _name VARCHAR(45)
)
proc:BEGIN
	DECLARE v_checker INT DEFAULT 0;
	
	-- code
	SELECT COUNT(1) INTO v_checker
	FROM db_market.products
	WHERE deleted_at IS NULL
	AND name = _name;

	IF v_checker < 1 THEN
		SELECT
			NOW() AS datetime
			, 404 AS code
			, 'Not found' AS status
			, 'Product dengan nama tersebut tidak ditemukan!' AS message;
		ROLLBACK;
		LEAVE proc;
    END IF;

	SELECT
		NOW() AS datetime
		, 200 AS code
		, 'OK' AS status
		, 'OK' AS message;
   
   SELECT
		product_id
		, name
		, price
		, stock
		, description
	FROM db_market.products
	WHERE deleted_at IS NULL
	AND name = _name;

	COMMIT;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE IF NOT EXISTS db_market.ProductGetByLikeName(
	IN _name VARCHAR(45)
	, IN _size INT
	, IN _page INT
)
proc:BEGIN
	-- variabel	
	DECLARE v_offset INT;
	DECLARE v_total_data INT;
	DECLARE v_total_page INT;
	
	-- code
	IF _size <= 0 OR _page <= 0 THEN
		SELECT
			NOW() AS datetime
			, 400 AS code
			, 'Bad Request' AS status
			, 'Size dan Page tidak boleh kurang dari 1' AS message;
		ROLLBACK;
		LEAVE proc;
	END IF;

	SELECT COUNT(1) INTO v_total_data
	FROM db_market.products
	WHERE deleted_at IS NULL
	AND name LIKE CONCAT('%', _name , '%');

	IF v_total_data < 1 THEN
		SELECT
			NOW() AS datetime
			, 204 AS code
			, 'No Content' AS status
			, 'No Content' AS message;
	ELSE
		SELECT
			NOW() AS datetime
			, 200 AS code
			, 'OK' AS status
			, 'OK' AS message;		
	END IF;

	SET _size = IFNULL(_size, 10);
	SET _page = IFNULL(_page, 1);
	SET v_offset = (_page - 1) * _size;
   
	SELECT
		product_id
		, name
		, price
		, stock
		, description
	FROM db_market.products
	WHERE deleted_at IS NULL
	AND name LIKE CONCAT('%', _name , '%')
	ORDER BY name ASC
	LIMIT _size
	OFFSET v_offset;

	SELECT
		_size AS page_size
		, v_total_data AS total_data
		, CEIL(v_total_data / _size) AS total_page
		, _page AS current_page;

	COMMIT;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE IF NOT EXISTS db_market.ProductGetEmptyStock(
	IN _size INT
	, IN _page INT
)
proc:BEGIN
	-- variabel	
	DECLARE v_offset INT;
	DECLARE v_total_data INT;
	DECLARE v_total_page INT;
	
	-- code
	SET v_total_data = (
		SELECT COUNT(1)
		FROM db_market.products
		WHERE deleted_at IS NULL
		AND stock < 1
	);

	IF v_total_data < 1 THEN
		SELECT
			NOW() AS datetime
			, 204 AS code
			, 'No Content' AS status
			, 'No Content' AS message;
	ELSE
		SELECT
			NOW() AS datetime
			, 200 AS code
			, 'OK' AS status
			, 'OK' AS message;		
    END IF;

	SET _size = IFNULL(_size, 10);
	SET _page = IFNULL(_page, 1);
	SET v_offset = (_page - 1) * _size;

   SELECT
		product_id
		, name
		, price
		, stock
		, description
	FROM db_market.products
	WHERE deleted_at IS NULL
	AND stock < 1
	ORDER BY name ASC
	LIMIT _size
	OFFSET v_offset;

	SELECT
		_size AS page_size
		, v_total_data AS total_data
		, CEIL(v_total_data / _size) AS total_page
		, _page AS current_page;

	COMMIT;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE IF NOT EXISTS db_market.ProductAddOne(
	IN _name VARCHAR(45)
	, IN _price INT
	, IN _qty INT
	, IN _description TEXT
)
proc:BEGIN
	-- variabel	
	DECLARE v_checker INT DEFAULT 0;
	
	-- code
	IF _price < 1 OR _qty < 1 THEN
		SELECT
			NOW() AS datetime
			, 400 AS code
			, 'Bad request' AS status
			, 'Price dan Qty tidak boleh kurang dari 1!' AS message;
		ROLLBACK;
		LEAVE proc;
	END IF;

	SELECT COUNT(1) INTO v_checker
	FROM db_market.products
	WHERE deleted_at IS NULL
	AND name = _name;

	IF v_checker > 0 THEN
		SELECT
			NOW() AS datetime
			, 409 AS code
			, 'Conflict' AS status
			, 'Produk dengan nama tersebut sudah ada!' AS message;
		ROLLBACK;
		LEAVE proc;
		END IF;
		
	INSERT INTO db_market.products(name, price, stock, description, created_at, updated_at)
	VALUES(_name, _price, _qty, _description, NOW(), NOW());

	SELECT
		NOW() AS datetime
		, 201 AS code
		, 'Created' AS status
		, 'Produk berhasil ditambah!' AS message;

	COMMIT;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE IF NOT EXISTS db_market.ProductAddStockById(
	IN _id INT
	, IN _qty INT
)
proc:BEGIN
	-- variabel
	DECLARE v_checker INT DEFAULT 0;
	DECLARE v_stock INT;
	
	-- code
	IF _qty < 1 THEN
		SELECT
			NOW() AS datetime
			, 400 AS code
			, 'Bad request' AS status
			, 'Qty tidak boleh kurang dari 1!' AS message;
		ROLLBACK;
		LEAVE proc;
	END IF;

	SELECT COUNT(1) INTO v_checker
	FROM db_market.products
	WHERE deleted_at IS NULL
	AND product_id = _id;

	IF v_checker < 1 THEN
		SELECT
			NOW() AS datetime
			, 404 AS code
			, 'Not found' AS status
			, 'Produk dengan id tersebut tidak ditemukan!' AS message;
		ROLLBACK;
		LEAVE proc;
    END IF;
   
   SET v_stock = _qty + (SELECT stock FROM db_market.products WHERE product_id = _id);
   
   UPDATE db_market.products
   SET stock = v_stock
   	   , updated_at = NOW()
   WHERE product_id = _id;

	SELECT
		NOW() AS datetime
		, 200 AS code
		, 'OK' AS status
		, 'Stok berhasil ditambahkan!' AS message;

	COMMIT;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE IF NOT EXISTS db_market.ProductEditOneById(
	IN _id INT
	, IN _name VARCHAR(45)
	, IN _price INT
	, IN _description TEXT
)
proc:BEGIN
	-- variabel
	DECLARE v_checker INT DEFAULT 0;
	DECLARE v_name VARCHAR(45);
	DECLARE v_price INT;
	DECLARE v_description TEXT;

	-- code
	IF _price < 1 THEN
		SELECT
			NOW() AS datetime
			, 400 AS code
			, 'Bad request' AS status
			, 'Price tidak boleh kurang dari 1!' AS message;
		ROLLBACK;
		LEAVE proc;
	END IF;

	SELECT COUNT(1) INTO v_checker
	FROM db_market.products
	WHERE deleted_at IS NULL
	AND product_id = _id;

	IF v_checker < 1 THEN
		SELECT
			NOW() AS datetime
			, 404 AS code
			, 'Not found' AS status
			, 'Produk dengan id tersebut tidak ditemukan!' AS message;
		ROLLBACK;
		LEAVE proc;
	ELSEIF v_checker > 1 THEN
		SELECT
			NOW() AS datetime
			, 409 AS code
			, 'Conflict' AS status
			, 'Produk dengan id tersebut duplikat!' AS message;
		ROLLBACK;
		LEAVE proc;	
	END IF;

	SELECT name, price, description
	INTO v_name, v_price, v_description
	FROM db_market.products
	WHERE product_id = _id;

	SET v_name = IFNULL(_name, v_name);
	SET v_price = IFNULL(_price, v_price);
	SET v_description = IFNULL(_description, v_description);

	UPDATE db_market.products
	SET name = v_name
		, price = v_price
		, description = v_description
		, updated_at = NOW()
	WHERE product_id = _id
	AND deleted_at IS NOT NULL;

	SELECT
		NOW() AS datetime
		, 200 AS code
		, 'OK' AS status
		, 'Produk dengan id tersebut berhasil diubah!' AS message;

	COMMIT;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE IF NOT EXISTS db_market.ProductDeleteOneById(
	IN _id INT
)
proc:BEGIN
	-- variabel
	DECLARE v_checker INT DEFAULT 0;

	-- code
	SELECT COUNT(1) INTO v_checker
	FROM db_market.products
	WHERE deleted_at IS NULL
	AND product_id = _id;

	IF v_checker < 1 THEN
		SELECT
			NOW() AS datetime
			, 404 AS code
			, 'Not found' AS status
			, 'Produk dengan id tersebut tidak ditemukan!' AS message;
		ROLLBACK;
		LEAVE proc;
	ELSEIF v_checker > 1 THEN
		SELECT
			NOW() AS datetime
			, 409 AS code
			, 'Conflict' AS status
			, 'Produk dengan id tersebut duplikat!' AS message;
		ROLLBACK;
		LEAVE proc;	
    END IF;

	UPDATE db_market.products
	SET deleted_at = NOW()
	WHERE product_id = _id;

	SELECT
		NOW() AS datetime
		, 200 AS code
		, 'OK' AS status
		, 'Produk dengan id tersebut berhasil dihapus!' AS message;

	COMMIT;
END //
DELIMITER ;

-- Module Customer
DELIMITER //
CREATE PROCEDURE IF NOT EXISTS db_market.CustomerGetAll(
	IN _size INT
	, IN _page INT
)
proc:BEGIN
	-- variabel
	DECLARE v_offset INT;
	DECLARE v_total_data INT;

	-- code
	IF _size <= 0 OR _page <= 0 THEN
		SELECT
			NOW() AS datetime
			, 400 AS code
			, 'Bad Request' AS status
			, 'Size dan Page tidak boleh kurang dari 1' AS message;
		ROLLBACK;
		LEAVE proc;
	END IF;

	SELECT COUNT(1) INTO v_total_data
	FROM db_market.customers
	WHERE deleted_at IS NULL;

	IF v_total_data < 1 THEN
		SELECT
			NOW() AS datetime
			, 204 AS code
			, 'No Content' AS status
			, 'No Content' AS message;
	ELSE
		SELECT
			NOW() AS datetime
			, 200 AS code
			, 'OK' AS status
			, 'OK' AS message;		
	END IF;

	SET _size = IFNULL(_size, 10);
	SET _page = IFNULL(_page, 1);
	SET v_offset = (_page - 1) * _size;

	SELECT
		customer_id
		, name
		, gender
		, address
		, IF(is_member = 1, 'Yes', 'No') AS 'member'
	FROM db_market.customers
	WHERE deleted_at IS NULL
	ORDER BY customer_id DESC
	LIMIT _size
	OFFSET v_offset;

	SELECT
		_size AS page_size
		, v_total_data AS total_data
		, CEIL(v_total_data / _size) AS total_page
		, _page AS current_page;

	COMMIT;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE IF NOT EXISTS db_market.CustomerGetById(
	IN _id INT
)
proc:BEGIN
	-- variabel
	DECLARE v_checker INT DEFAULT 0;
	
	-- code
	SELECT COUNT(1) INTO v_checker
	FROM db_market.customers
	WHERE deleted_at IS NULL
	AND customer_id = _id;

	IF v_checker < 1 THEN
		SELECT
			NOW() AS datetime
			, 404 AS code
			, 'Not found' AS status
			, 'Customer dengan id tersebut tidak ditemukan!' AS message;
		ROLLBACK;
		LEAVE proc;
	END IF;

	SELECT
		NOW() AS datetime
		, 200 AS code
		, 'OK' AS status
		, 'OK' AS message;
   
   SELECT
		customer_id
		, name
		, gender
		, address
		, IF(is_member = 1, 'Yes', 'No') AS 'member'
	FROM db_market.customers
	WHERE deleted_at IS NULL
	AND customer_id = _id;

	COMMIT;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE IF NOT EXISTS db_market.CustomerGetByName(
	IN _name VARCHAR(45)
)
proc:BEGIN
	-- variabel
	DECLARE v_checker INT DEFAULT 0;
	
	-- code
	SELECT COUNT(1) INTO v_checker
	FROM db_market.customers
	WHERE deleted_at IS NULL
	AND name = _name;

	IF v_checker < 1 THEN
		SELECT
			NOW() AS datetime
			, 404 AS code
			, 'Not found' AS status
			, 'Customer dengan nama tersebut tidak ditemukan!' AS message;
		ROLLBACK;
		LEAVE proc;
    END IF;

	SELECT
		NOW() AS datetime
		, 200 AS code
		, 'OK' AS status
		, 'OK' AS message;
   
   SELECT
		customer_id
		, name
		, gender
		, address
		, IF(is_member = 1, 'Yes', 'No') AS 'member'
	FROM db_market.customers
	WHERE deleted_at IS NULL
	AND name = _name;

	COMMIT;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE IF NOT EXISTS db_market.CustomerGetByLikeName(
	IN _name VARCHAR(45)
	, IN _size INT
	, IN _page INT
)
proc:BEGIN
	-- variabel	
	DECLARE v_offset INT;
	DECLARE v_total_data INT;
	DECLARE v_total_page INT;
	
	-- code
	IF _size <= 0 OR _page <= 0 THEN
		SELECT
			NOW() AS datetime
			, 400 AS code
			, 'Bad Request' AS status
			, 'Size dan Page tidak boleh kurang dari 1' AS message;
		ROLLBACK;
		LEAVE proc;
	END IF;

	SELECT COUNT(1) INTO v_total_data
	FROM db_market.customers
	WHERE deleted_at IS NULL
	AND name LIKE CONCAT('%', _name , '%');

	IF v_total_data < 1 THEN
		SELECT
			NOW() AS datetime
			, 204 AS code
			, 'No Content' AS status
			, 'No Content' AS message;
	ELSE
		SELECT
			NOW() AS datetime
			, 200 AS code
			, 'OK' AS status
			, 'OK' AS message;		
	END IF;

	SET _size = IFNULL(_size, 10);
	SET _page = IFNULL(_page, 1);
	SET v_offset = (_page - 1) * _size;
   
	SELECT
		customer_id
		, name
		, gender
		, address
		, IF(is_member = 1, 'Yes', 'No') AS 'member'
	FROM db_market.customers
	WHERE deleted_at IS NULL
	AND name LIKE CONCAT('%', _name , '%')
	ORDER BY name ASC
	LIMIT _size
	OFFSET v_offset;

	SELECT
		_size AS page_size
		, v_total_data AS total_data
		, CEIL(v_total_data / _size) AS total_page
		, _page AS current_page;

	COMMIT;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE IF NOT EXISTS db_market.CustomerGetByGender(
	IN _gender VARCHAR(6)
	, IN _size INT
	, IN _page INT
)
proc:BEGIN
	-- variabel	
	DECLARE v_offset INT;
	DECLARE v_total_data INT;
	DECLARE v_total_page INT;
	
	-- code
	IF _gender NOT IN('Pria', 'Wanita') THEN
		SELECT
			NOW() AS datetime
			, 400 AS code
			, 'Bad Request' AS status
			, 'Gender hanya dapat diinput Pria atau Wanita' AS message;
		ROLLBACK;
		LEAVE proc;
	END IF;

	IF _size <= 0 OR _page <= 0 THEN
		SELECT
			NOW() AS datetime
			, 400 AS code
			, 'Bad Request' AS status
			, 'Size dan Page tidak boleh kurang dari 1' AS message;
		ROLLBACK;
		LEAVE proc;
	END IF;

	SELECT COUNT(1) INTO v_total_data
	FROM db_market.customers
	WHERE deleted_at IS NULL
	AND gender = _gender;

	IF v_total_data < 1 THEN
		SELECT
			NOW() AS datetime
			, 204 AS code
			, 'No Content' AS status
			, 'No Content' AS message;
	ELSE
		SELECT
			NOW() AS datetime
			, 200 AS code
			, 'OK' AS status
			, 'OK' AS message;		
	END IF;

	SET _size = IFNULL(_size, 10);
	SET _page = IFNULL(_page, 1);
	SET v_offset = (_page - 1) * _size;
   
	SELECT
		customer_id
		, name
		, gender
		, address
		, IF(is_member = 1, 'Yes', 'No') AS 'member'
	FROM db_market.customers
	WHERE deleted_at IS NULL
	AND gender = _gender
	ORDER BY name ASC
	LIMIT _size
	OFFSET v_offset;

	SELECT
		_size AS page_size
		, v_total_data AS total_data
		, CEIL(v_total_data / _size) AS total_page
		, _page AS current_page;

	COMMIT;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE IF NOT EXISTS db_market.CustomerAddOne(
	IN _name VARCHAR(45)
	, IN _gender VARCHAR(6)
	, IN _address TEXT
	, IN _is_member BOOLEAN
)
proc:BEGIN
	-- code
	IF _gender NOT IN('Pria', 'Wanita') THEN
		SELECT
			NOW() AS datetime
			, 400 AS code
			, 'Bad Request' AS status
			, 'Gender hanya dapat diinput Pria atau Wanita' AS message;
		ROLLBACK;
		LEAVE proc;
	END IF;

	IF _is_member NOT IN(1, 0, TRUE, FALSE) THEN
		SELECT
			NOW() AS datetime
			, 400 AS code
			, 'Bad Request' AS status
			, 'is_member hanya dapat diinput TRUE atau FALSE' AS message;
		ROLLBACK;
		LEAVE proc;		
	END IF;

	INSERT INTO db_market.customers(name, gender, address, is_member, created_at, updated_at)
	VALUES(_name, CONCAT(UPPER(SUBSTRING(_gender,1,1)), LOWER(SUBSTRING(_gender,2))), _address, _is_member, NOW(), NOW());

	SELECT
		NOW() AS datetime
		, 201 AS code
		, 'Created' AS status
		, 'Pelanggan berhasil ditambah!' AS message;

	COMMIT;
END //
DELIMITER ;

DELIMITER //

DELIMITER ;