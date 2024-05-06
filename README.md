# Mysql Database Market

Mysql Database Market merupakan project penyimpanan basis data untuk Toko secara sistematis menggunakan database Mysql. Dan pada Mysql Database Market juga terdapat Store Procedure sebagai API

## Database Design

![database design](./images/database%20design%20mysql%20database%20market.png)

## Setup

### Menggunakan Docker Compose

- Buka terminal
- Sesuaikan direktori
- Jalankan perintah berikut

```console
docker-compose up -d
```

- (Opsional) Jalankan perintah berikut untuk mengaktifkan pencatatan log

```console
docker exec -t mysql_database_market mysql --user="root" --password="root" --execute="SET GLOBAL log_output = 'FILE';" \
&& docker exec -t mysql_database_market mysql --user="root" --password="root" --execute="SET GLOBAL general_log_file = '/var/log/mysqld.log';" \
&& docker exec -t mysql_database_market mysql --user="root" --password="root" --execute="SET GLOBAL general_log = 'ON';"
```

- (Opsional) Untuk melihat log jalankan perintah berikut

```console
docker exec -t mysql_database_market cat /var/log/mysqld.log
```

## Penggunaan Store Procedure

### Module Products

#### Product Get All (building)

- Menggunakan Aplikasi GUI

```sql
CALL db_market.ProductGetAll(
  :_size -- => [NULL || 10]
  , :_page -- => [NULL || 1]
);
```

- Menggunakan Terminal

```console
mysql --user=root --password=root --execute="CALL db_market.ProductGetAll(:_size, :_page)"
```

#### Product Get By Id (building)

- Menggunakan Aplikasi GUI

```sql
CALL db_market.ProductGetById(
  :_id -- => [1]
);
```

- Menggunakan Terminal

```console
mysql --user=root --password=root --execute="CALL db_market.ProductGetById(:_id)"
```

#### Product Get By Name (building)

- Menggunakan Aplikasi GUI

```sql
CALL db_market.ProductGetByName(
  :_name -- => ['Product 1']
);
```

- Menggunakan Terminal

```console
mysql --user=root --password=root --execute="CALL db_market.ProductGetByName(:_name)"
```

#### Product Get By Like Name (building)

- Menggunakan Aplikasi GUI

```sql
CALL db_market.ProductGetByLikeName(
  :_name -- => ['Product']
  , :_size -- => [NULL || 10]
  , :_page -- => [NULL || 1]
);
```

- Menggunakan Terminal

```console
mysql --user=root --password=root --execute="CALL db_market.ProductGetByLikeName(:_name, :_size, :_page)"
```

#### Product Get Empty Stock (building)

- Menggunakan Aplikasi GUI

```sql
CALL db_market.ProductGetEmptyStock(
  :_size -- => [NULL || 10]
  , :_page -- => [NULL || 1]
);
```

- Menggunakan Terminal

```console
mysql --user=root --password=root --execute="CALL db_market.ProductGetEmptyStock(:_size, :_page)"
```

#### Product Add One (building)

- Menggunakan Aplikasi GUI

```sql
CALL db_market.ProductAddOne(
  :_id -- => [0] jika insert product baru || [id yang sudah ada] untuk tambah stock product yang sudah ada
  , :_name -- => ['Product 1'] untuk insert product baru. [NULL] jika tambah stock product
  , :_price -- => [35000] untuk insert product baru. [NULL] jika tambah stock product
  , :_qty-- => [15]
  , :_description --[NULL || 'description']
);
```

- Menggunakan Terminal

```console
mysql --user=root --password=root --execute="CALL db_market.ProductGetEmptyStock(:_id, :_name, :_price, :_qty, :_description)"
```

#### Product Edit One By Id (building)

- Menggunakan Aplikasi GUI

```sql
CALL db_market.ProductEditOneById(
  :_id -- => [1]
  , :_name -- => [NULL || 'name']
  , :_price  -- => [NULL || 35000]
  , :_qty  -- => [NULL || 15]
  , :_description  -- => [NULL || 'description']
);
```

- Menggunakan Terminal

```console
mysql --user=root --password=root --execute="CALL db_market.ProductEditOneById(:_id, :_name, :_price, :_qty, :_description)"
```

#### Product Delete One By Id (building)

- Menggunakan Aplikasi GUI

```sql
CALL db_market.ProductDeleteOneById(
  :_id -- => [1]
);
```

- Menggunakan Terminal

```console
mysql --user=root --password=root --execute="CALL db_market.ProductDeleteOneById(:_id)"
```

### Module Customers

#### Customer Get All (building)

- Menggunakan Aplikasi GUI

```sql
CALL db_market.CustomerGetAll(
  :_size -- => [NULL || 10]
  , :_page -- => [NULL || 1]
);
```

- Menggunakan Terminal

```console
mysql --user=root --password=root --execute="CALL db_market.CustomerGetAll(:_size, :_page)"
```

#### Customer Get By Id (building)

- Menggunakan Aplikasi GUI

```sql
CALL db_market.CustomerGetById(
  :_id -- => [1]
);
```

- Menggunakan Terminal

```console
mysql --user=root --password=root --execute="CALL db_market.CustomerGetById(:_id)"
```

#### Customer Get By Name (building)

- Menggunakan Aplikasi GUI

```sql
CALL db_market.CustomerGetByName(
  :_name -- ['Customer 1']
);
```

- Menggunakan Terminal

```console
mysql --user=root --password=root --execute="CALL db_market.CustomerGetByName(:_name)"
```

#### Customer Get By Like Name (building)

- Menggunakan Aplikasi GUI

```sql
CALL db_market.CustomerGetByLikeName(
  :_name -- => ['Customer 1']
  , :_size -- => [NULL, 10]
  , :_page -- => [NULL, 1]
);
```

- Menggunakan Terminal

```console
mysql --user=root --password=root --execute="CALL db_market.CustomerGetByLikeName(:_name, :_size, :_page)"
```

#### Customer Get By Gender (building)

- Menggunakan Aplikasi GUI

```sql
CALL db_market.CustomerGetByGender(
  :_gender -- => ['Pria', 'Wanita']
  , :_size -- => [NULL, 10]
  , :_page -- => [NULL, 1]
);
```

- Menggunakan Terminal

```console
mysql --user=root --password=root --execute="CALL db_market.CustomerGetByGender(:_name, :_size, :_page)"
```

#### Customer Add One (building)

- Menggunakan Aplikasi GUI

```sql
CALL db_market.CustomerAddOne(
  :_name -- => ['Customer 1']
  , :_gender -- => ['Pria' || 'Wanita']
  , :_address -- => ['Address 1']
  , :_is_member -- => [TRUE || FALSE]
);
```

- Menggunakan Terminal

```console
mysql --user=root --password=root --execute="CALL db_market.CustomerAddOne(:_name, :_gender, :_address, :_is_member)"
```

#### Customer Edit One By Id (building)

- Menggunakan Aplikasi GUI

```sql
CALL db_market.CustomerEditOneById(
  :_id -- => [1]
  , :_name -- => [NULL || 'name']
  , :_gender -- => [NULL || 'Pria' || 'Wanita']
  , :_address -- => [NULL || 'address']
  , :_is_member -- => [NULL || TRUE || FALSE]
);
```

- Menggunakan Terminal

```console
mysql --user=root --password=root --execute="CALL db_market.CustomerEditOneById(:id, :_name, :_gender, :_address, :_is_member)"
```

#### Customer Delete One By Id (building)

- Menggunakan Aplikasi GUI

```sql
CALL db_market.CustomerDeleteOneById(
  :_id -- => [1]
);
```

- Menggunakan Terminal

```console
mysql --user=root --password=root --execute="CALL db_market.CustomerDeleteOneById(:_id)"
```

### Module Customer Order

#### Customer Order Get By Customer Order Id (building)

- Menggunakan Aplikasi GUI

```sql
CALL db_market.CustomerOrderGetByCustomerOrderId(
  :_id -- [1]
);
```

- Menggunakan Terminal

```console
mysql --user=root --password=root --execute="CALL db_market.CustomerOrderGetByCustomerOrderId(:_id)"
```

#### Customer Order Get By Customer Id (building)

- Menggunakan Aplikasi GUI

```sql
CALL db_market.CustomerOrderGetByCustomerId(
  :_id -- => [1]
  , _trans_n -- => [1]
);
```

- Menggunakan Terminal

```console
mysql --user=root --password=root --execute="CALL db_market.CustomerOrderGetByCustomerId(:_id, :_trans_n)"
```

#### Customer Order Add One (building)

- Menggunakan Aplikasi GUI

```sql
CALL db_market.CustomerOrderAddOne(
  :_customer_id -- => [1]
  , :_product_id_qty_arr_json -- => [{"product_id":1, "qty":15}, {"product_id":2, "qty":15}, {"product_id":3, "qty":15}]
);
```

- Menggunakan Terminal

```console
mysql --user=root --password=root --execute="CALL db_market.CustomerOrderAddOne(:_customer_id, _product_id_qty_arr_json)"
```

#### Customer Order Delete By Customer Order Id (building)

- Menggunakan Aplikasi GUI

```sql
CALL db_market.CustomerOrderDeleteByCustomerOrderId(
  :_id -- [1]
);
```

- Menggunakan Terminal

```console
mysql --user=root --password=root --execute="CALL db_market.CustomerOrderDeleteByCustomerOrderId(:_id)"
```
