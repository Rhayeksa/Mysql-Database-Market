DROP DATABASE IF EXISTS db_market;

-- Initial Database
CREATE DATABASE IF NOT EXISTS db_market;

-- Initial Tables
CREATE TABLE IF NOT EXISTS db_market.products(
  	product_id INT AUTO_INCREMENT UNIQUE NOT NULL
  	, name VARCHAR(45) NOT NULL
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

	SET _size = IFNULL(_size, 10);
	SET _page = IFNULL(_page, 1);

	-- validasi
	IF _size <= 0 OR _page <= 0 THEN
		SELECT
			NOW() AS datetime
			, 400 AS code
			, 'Bad Request' AS status
			, 'Parameter Size dan Page tidak boleh kurang dari 1' AS message;
		ROLLBACK;
		LEAVE proc;
	END IF;

	-- code
	SELECT
		NOW() AS datetime
		, 200 AS code
		, 'OK' AS status
		, 'OK' AS message;

	SET v_offset = (_page - 1) * _size;
	SELECT
		product_id
		, name
		, price
		, stock
		, description
	FROM db_market.products
	WHERE deleted_at IS NULL
	LIMIT _size
	OFFSET v_offset;

	SET v_total_data = (SELECT COUNT(1) FROM db_market.products);
	SELECT
		_size AS page_size
		, v_total_data AS total_data
		, ROUND(v_total_data / _size) AS total_page
		, _page AS current_page;

	COMMIT;
END //
-- END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE IF NOT EXISTS db_market.ProductGetById(IN _id INT)
proc:BEGIN
	-- variabel
	DECLARE v_count INT DEFAULT 0;
	
	-- validasi
	SELECT COUNT(1) INTO v_count
	FROM db_market.products
	WHERE product_id = _id;

	IF v_count < 1 THEN
		SELECT
			NOW() AS datetime
			, 404 AS code
			, 'Not found' AS status
			, 'Product tidak ditemukan!' AS message;
		ROLLBACK;
		LEAVE proc;
    END IF;

	-- code
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

-- -- DELIMITER //
-- -- //
-- CREATE PROCEDURE IF NOT EXISTS db_market.GetProductByName(IN _name VARCHAR(45))
-- BEGIN
-- 	DECLARE product_count INT DEFAULT 0;
	
-- 	SELECT COUNT(1) INTO product_count
-- 	FROM db_market.products
-- 	WHERE name = _name;

-- 	IF product_count = 0 THEN
-- 		SIGNAL SQLSTATE '45000'
-- 		SET MESSAGE_TEXT = 'Product tidak ditemukan';
--     END IF;

-- 	SELECT
-- 		product_id
-- 		, name
-- 		, price
-- 		, stock
-- 		, description
-- 	FROM db_market.products
-- 	WHERE name = _name;
-- END
-- -- //
-- -- DELIMITER ;

-- -- DELIMITER //
-- -- //
-- CREATE PROCEDURE IF NOT EXISTS db_market.InsertOneProduct(IN _name VARCHAR(45))
-- BEGIN
-- 	DECLARE product_count INT DEFAULT 0;
	
-- 	SELECT COUNT(1) INTO product_count
-- 	FROM db_market.products
-- 	WHERE name = _name;

-- 	IF product_count = 0 THEN
-- 		SIGNAL SQLSTATE '45000'
-- 		SET MESSAGE_TEXT = 'Product tidak ditemukan';
--     END IF;

-- END
-- -- //
-- -- DELIMITER ;
