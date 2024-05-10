# Mysql Database Market

Mysql Database Market merupakan project penyimpanan basis data untuk Toko secara sistematis menggunakan database Mysql. Dan pada Mysql Database Market juga terdapat Store Procedure sebagai API

## Database Design

![database design](./images/database%20design%20mysql%20database%20market.png)

## Setup

### Menggunakan Docker Compose

- Buka docker CLI
- Sesuaikan direktori
- Jalankan perintah berikut

```console
docker-compose up -d
```

- (Opsional) Jalankan perintah berikut untuk mengaktifkan pencatatan log

```console
docker exec -t mysql_database_market mysql --user="root" --password="root" --execute="SET GLOBAL log_output = 'FILE'" \
&& docker exec -t mysql_database_market mysql --user="root" --password="root" --execute="SET GLOBAL general_log_file = '/var/log/mysqld.log'" \
&& docker exec -t mysql_database_market mysql --user="root" --password="root" --execute="SET GLOBAL general_log = 'ON'"
```

- (Opsional) Untuk melihat log jalankan perintah berikut

```console
docker exec -t mysql_database_market cat /var/log/mysqld.log
```

## Penggunaan Store Procedure

### Module Products

#### Product Get All

- Menggunakan Aplikasi GUI

```sql
CALL db_market.ProductGetAll(
  :_size -- => INT [NULL || 10]
  , :_page -- => INT [NULL || 1]
);
```

- Menggunakan docker CLI

```console
docker exec -t mysql_database_market docker exec -t mysql_database_market mysql --user=root --password=root --execute="CALL db_market.ProductGetAll(:_size, :_page)"
```

#### Product Get By Id

- Menggunakan Aplikasi GUI

```sql
CALL db_market.ProductGetById(
  :_id -- => INT [1]
);
```

- Menggunakan docker CLI

```console
docker exec -t mysql_database_market docker exec -t mysql_database_market mysql --user=root --password=root --execute="CALL db_market.ProductGetById(:_id)"
```

#### Product Get By Name

- Menggunakan Aplikasi GUI

```sql
CALL db_market.ProductGetByName(
  :_name -- => VARCHAR(45) ['Product 1']
);
```

- Menggunakan docker CLI

```console
docker exec -t mysql_database_market mysql --user=root --password=root --execute="CALL db_market.ProductGetByName(:_name)"
```

#### Product Get By Like Name

- Menggunakan Aplikasi GUI

```sql
CALL db_market.ProductGetByLikeName(
  :_name -- => VARCHAR(45) ['Product']
  , :_size -- => INT [NULL || 10]
  , :_page -- => INT [NULL || 1]
);
```

- Menggunakan docker CLI

```console
docker exec -t mysql_database_market mysql --user=root --password=root --execute="CALL db_market.ProductGetByLikeName(:_name, :_size, :_page)"
```

#### Product Get Empty Stock

- Menggunakan Aplikasi GUI

```sql
CALL db_market.ProductGetEmptyStock(
  :_size -- => [NULL || 10]
  , :_page -- => [NULL || 1]
);
```

- Menggunakan docker CLI

```console
docker exec -t mysql_database_market mysql --user=root --password=root --execute="CALL db_market.ProductGetEmptyStock(:_size, :_page)"
```

#### Product Add One

- Menggunakan Aplikasi GUI

```sql
CALL db_market.ProductAddOne(
  :_name -- => VARCHAR(45) ['Product 1']
  , :_price -- => INT [35000]
  , :_qty-- => INT [15]
  , :_description --TEXT [NULL || 'Description 1']
);
```

- Menggunakan docker CLI

```console
docker exec -t mysql_database_market mysql --user=root --password=root --execute="CALL db_market.ProductGetEmptyStock(:_id, :_name, :_price, :_qty, :_description)"
```

#### Product Add Stock By Id

- Menggunakan Aplikasi GUI

```sql
CALL db_market.ProductAddStockById(
  :_id -- => INT [1]
  , :_qty  -- => INT [15]
);
```

- Menggunakan docker CLI

```console
docker exec -t mysql_database_market mysql --user=root --password=root --execute="CALL db_market.ProductAddStockById(:_id, :_name, :_price, :_qty, :_description)"
```

#### Product Edit One By Id

- Menggunakan Aplikasi GUI

```sql
CALL db_market.ProductEditOneById(
  :_id -- => INT [1]
  , :_name -- => VARCHAR(45) [NULL || 'Product update']
  , :_price  -- => INT [NULL || 35000]
  , :_description  -- => TEXT [NULL || 'Description update']
);
```

- Menggunakan docker CLI

```console
docker exec -t mysql_database_market mysql --user=root --password=root --execute="CALL db_market.ProductEditOneById(:_id, :_name, :_price, :_qty, :_description)"
```

#### Product Delete One By Id

- Menggunakan Aplikasi GUI

```sql
CALL db_market.ProductDeleteOneById(
  :_id -- => INT [1]
);
```

- Menggunakan docker CLI

```console
docker exec -t mysql_database_market mysql --user=root --password=root --execute="CALL db_market.ProductDeleteOneById(:_id)"
```

### Module Customers

#### Customer Get All

- Menggunakan Aplikasi GUI

```sql
CALL db_market.CustomerGetAll(
  :_size -- => INT [NULL || 10]
  , :_page -- => INT [NULL || 1]
);
```

- Menggunakan docker CLI

```console
docker exec -t mysql_database_market mysql --user=root --password=root --execute="CALL db_market.CustomerGetAll(:_size, :_page)"
```

#### Customer Get By Id

- Menggunakan Aplikasi GUI

```sql
CALL db_market.CustomerGetById(
  :_id -- => INT [1]
);
```

- Menggunakan docker CLI

```console
docker exec -t mysql_database_market mysql --user=root --password=root --execute="CALL db_market.CustomerGetById(:_id)"
```

#### Customer Get By Name

- Menggunakan Aplikasi GUI

```sql
CALL db_market.CustomerGetByName(
  :_name -- VARCHAR(45) ['Customer 1']
);
```

- Menggunakan docker CLI

```console
docker exec -t mysql_database_market mysql --user=root --password=root --execute="CALL db_market.CustomerGetByName(:_name)"
```

#### Customer Get By Like Name

- Menggunakan Aplikasi GUI

```sql
CALL db_market.CustomerGetByLikeName(
  :_name -- VARCHAR(45) ['Customer 1']
  , :_size -- => INT [NULL, 10]
  , :_page -- => INT [NULL, 1]
);
```

- Menggunakan docker CLI

```console
docker exec -t mysql_database_market mysql --user=root --password=root --execute="CALL db_market.CustomerGetByLikeName(:_name, :_size, :_page)"
```

#### Customer Get By Gender

- Menggunakan Aplikasi GUI

```sql
CALL db_market.CustomerGetByGender(
  :_gender -- => VARCHAR(6) ['Pria', 'Wanita']
  , :_size -- => INT [NULL, 10]
  , :_page -- => INT [NULL, 1]
);
```

- Menggunakan docker CLI

```console
docker exec -t mysql_database_market mysql --user=root --password=root --execute="CALL db_market.CustomerGetByGender(:_name, :_size, :_page)"
```

#### Customer Add One

- Menggunakan Aplikasi GUI

```sql
CALL db_market.CustomerAddOne(
  :_name -- => VARCHAR(45) ['Customer 1']
  , :_gender -- => VARCHAR(6) ['Pria' || 'Wanita']
  , :_address -- => TEXT ['Address 1']
  , :_is_member -- => BOOLEAN [TRUE || FALSE]
);
```

- Menggunakan docker CLI

```console
docker exec -t mysql_database_market mysql --user=root --password=root --execute="CALL db_market.CustomerAddOne(:_name, :_gender, :_address, :_is_member)"
```

#### Customer Edit One By Id

- Menggunakan Aplikasi GUI

```sql
CALL db_market.CustomerEditOneById(
  :_id -- => INT [1]
  , :_name -- => VARCHAR(45) [NULL || 'name']
  , :_gender -- => VARCHAR(6) [NULL || 'Pria' || 'Wanita']
  , :_address -- => TEXT [NULL || 'address']
  , :_is_member -- => BOOLEAN [NULL || TRUE || FALSE]
);
```

- Menggunakan docker CLI

```console
docker exec -t mysql_database_market mysql --user=root --password=root --execute="CALL db_market.CustomerEditOneById(:id, :_name, :_gender, :_address, :_is_member)"
```

#### Customer Delete One By Id (building)

- Menggunakan Aplikasi GUI

```sql
CALL db_market.CustomerDeleteOneById(
  :_id -- => [1]
);
```

- Menggunakan docker CLI

```console
docker exec -t mysql_database_market mysql --user=root --password=root --execute="CALL db_market.CustomerDeleteOneById(:_id)"
```

### Module Customer Order

#### Customer Order Get By Customer Order Id (building)

- Menggunakan Aplikasi GUI

```sql
CALL db_market.CustomerOrderGetByCustomerOrderId(
  :_id -- [1]
);
```

- Menggunakan docker CLI

```console
docker exec -t mysql_database_market mysql --user=root --password=root --execute="CALL db_market.CustomerOrderGetByCustomerOrderId(:_id)"
```

#### Customer Order Get By Customer Id (building)

- Menggunakan Aplikasi GUI

```sql
CALL db_market.CustomerOrderGetByCustomerId(
  :_id -- => [1]
  , _trans_n -- => [1]
);
```

- Menggunakan docker CLI

```console
docker exec -t mysql_database_market mysql --user=root --password=root --execute="CALL db_market.CustomerOrderGetByCustomerId(:_id, :_trans_n)"
```

#### Customer Order Add One (building)

- Menggunakan Aplikasi GUI

```sql
CALL db_market.CustomerOrderAddOne(
  :_customer_id -- => [1]
  , :_product_id_qty_arr_json -- => [{"product_id":1, "qty":15}, {"product_id":2, "qty":15}, {"product_id":3, "qty":15}]
);
```

- Menggunakan docker CLI

```console
docker exec -t mysql_database_market mysql --user=root --password=root --execute="CALL db_market.CustomerOrderAddOne(:_customer_id, _product_id_qty_arr_json)"
```

#### Customer Order Delete By Customer Order Id (building)

- Menggunakan Aplikasi GUI

```sql
CALL db_market.CustomerOrderDeleteByCustomerOrderId(
  :_id -- [1]
);
```

- Menggunakan docker CLI

```console
docker exec -t mysql_database_market mysql --user=root --password=root --execute="CALL db_market.CustomerOrderDeleteByCustomerOrderId(:_id)"
```
