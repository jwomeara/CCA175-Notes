# HIVE Notes

# Running Hive CLI (beeline)
beeline -u jdbc:hive2://host:port -n username -p password

# Running a HIVE command from the host CLI
beeline -u jdbc:hive2://host:port -n username -p password -e 'some command'

# Running hive
hive

# Running HCatalog CLI
hcat

#================================================================================================
# BEELINE SHELL COMMANDS
#================================================================================================
# Quit beeline
hive> !exit

# Access help
hive> !help

#================================================================================================
# IMPALA METADATA COMMANDS
#================================================================================================
# Use this when a new table is added
hive> INVALIDATE METADATA;

# Use this when data is added to a table
hive> REFRESH tableName;

# Use this when a table has changed significantly
hive> INVALIDATE METADATA tableName;

#================================================================================================
# HIVE CREATE/DROP DATABASE COMMANDS
#================================================================================================
# Create a new Hive database
hive> CREATE DATABASE myDatabase;

# Drop an empty Hive database
hive> DROP DATABASE myDatabase;

# Drop a Hive database and any tables contained within
hive> DROP DATABASE myDatabase CASCADE;

#================================================================================================
# HIVE TABLE CREATION COMMANDS
#================================================================================================
# Available data types
TINYINT
SMALLINT
INT
BIGINT

BOOLEAN

FLOAT
DOUBLE

DECIMAL

STRING
VARCHAR
CHAR

TIMESTAMP
DATE

BINARY

# Create a basic table in Hive with named/typed fields
hive> CREATE TABLE tableName (field1 INT, field2 STRING);

# Create a partitioned table in Hive
hive> CREATE TABLE tableName (field1 INT, field2 STRING)
    PARTITIONED BY (field3 STRING)
    ROW FORMAT DELIMETED
    FIELDS TERMINATED BY ',';

# Create a table, stored as text, using tab delimeter
hive> CREATE TABLE tableName (field1 INT, field2 STRING)
    ROW FORMAT DELIMETED
    FIELDS TERMINATED BY '\t'
    STORED AS TEXTFILE;

# Create a table, stored as sequencefile, using tab delimeter
hive> CREATE TABLE tableName (field1 INT, field2 STRING)
    STORED AS SEQUENCEFILE;

# Create a table, stored as avro
hive> CREATE TABLE tableName
    STORED AS AVRO
    TBLPROPERTIES ('avro.schema.literal'=
        '{"name": "order",
          "type": "record",
          "fields": [
            {"name":"order_id", "type":"int"},
            {"name":"cust_id", "type":"int"},
            {"name":"order_date", "type":"string"}
          ]}');

# Create a table, stored as avro
hive> CREATE EXTERNAL TABLE tableName
    STORED AS AVRO
    TBLPROPERTIES ('avro.schema.url'=
        'hdfs:/loudacre/sqoop_import_accounts.avsc')
    LOCATION '/user/hive/warehouse/tableName';
          
# Create a table, stored as avro, with snappy compression
hive> SET hive.exec.compress.output=true;
hive> SET avro.output.codec=snappy;
hive> CREATE TABLE tableName
    STORED AS AVRO
    TBLPROPERTIES ('avro.schema.literal'=
        '{"name": "order",
          "type": "record",
          "fields": [
            {"name":"order_id", "type":"int"},
            {"name":"cust_id", "type":"int"},
            {"name":"order_date", "type":"string"}
          ]}',
        'avro.output.codec'='snappy',
        'hive.exec.compress.output'='true');

# Create a table, stored as parquet
hive> CREATE TABLE tableName
    STORED AS PARQUET;

# Create a table, stored as parquet, with compression set to snappy
hive> CREATE TABLE tableName
    STORED AS PARQUET;
hive> SET PARQUET_COMPRESSION_CODEC=snappy;
OR
hive> SET parquet.compression=snappy

# ALTERNATIVELY, create a table, stored as parquet, with compression set to snappy
hive> CREATE TABLE tableName
    STORED AS PARQUET
    TBLPROPERTIES ('parquet.compression'='snappy');

# CTAS - Create table as select
hive> CREATE TABLE newTable AS SELECT field1, field2, field3 FROM otherTable WHERE field1 = 'banana';

# Create table and store at specified location
hive> CREATE TABLE tableName (field1 INT, field2 STRING)
    ROW FORMAT DELIMETED
    FIELDS TERMINATED BY ','
    STORED AS TEXTFILE
    LOCATION '/some/hdfs/path';

# Create a table based on external data
hive> CREATE EXTERNAL TABLE tableName (field1 INT, field2 STRING)
    LOCATION '/some/hdfs/path'

# Create a table based on an existing table definition
hive> CREATE TABLE newTable LIKE existingTable;

#================================================================================================
# HIVE DATA LOADING COMMANDS
#================================================================================================
# Load data from flat files into Hive
# NOTE: OVERWRITE indicates that the existing table will be deleted before data is inserted
hive> LOAD DATA LOCAL INPATH './some/local/path/data.txt' OVERWRITE INTO TABLE tableName;

# Load data from flat files into Hive using a static partition
# NOTE: OVERWRITE indicates that the existing table will be deleted before data is inserted
hive> LOAD DATA LOCAL INPATH './some/local/path/data.txt' OVERWRITE INTO TABLE tableName PARTITION (field3="partitionValue");

# Alternatively, simply copy data to the table's directory in HDFS
hdfs dfs -mv /some/hdfs/path /the/table/path

#================================================================================================
# HIVE MISC COMMANDS
#================================================================================================
# Get a list of the tables in hive
hive> SHOW TABLES;

# Get a list of tables matching the pattern
hive> SHOW TABLES '.*s';

# Get the command used to create the table
hive> SHOW CREATE TABLE tableName;

# Get a list of the columns in the table
hive> DESCRIBE tableName;

# Drop a table
# NOTE: Unless this is an external table, this also deletes the underlying data
hive> DROP TABLE tableName;

# Show partitions on a table
hive> SHOW PARTITIONS tableName;

# Add a partition to a table
hive> ALTER TABLE tableName
    ADD PARTITION (partField='partValue')
    LOCATION '/hdfs/path/to/tableName/partValue';
    
# Drop a partition from a table
hive> ALTER TABLE tableName
    DROP PARTITION (partField='partValue');

#================================================================================================
# HIVE ALTER TABLE COMMANDS
#================================================================================================
# Rename a table
hive> ALTER TABLE tableName 
    RENAME TO otherTableName;

# Add columns to a table
# NOTE: This only changes the schema, not the underlying data
hive> ALTER TABLE tableName 
    ADD COLUMNS (field3 INT, field4 STRING);

# Replace columns in a table
# NOTE: Provide a list of the columns as you want them to be
# NOTE: This only changes the schema, not the underlying data
hive> ALTER TABLE tableName 
    REPLACE COLUMNS (field1 INT, field2 STRING, replacedField INT);

#================================================================================================
# HIVE SQL COMMANDS
#================================================================================================
# Available Aggregation functions
count(*), count(expr), count(DISTINCT, expr)
sum(col), sum(DISTINCT, col)
avg(col), avg(DISTINCT, col)
min(col), max(col)

# Basic select statement
hive> SELECT field1 FROM tableName WHERE field2='value';

#================================================================================================
# HIVE INSERT COMMANDS
#================================================================================================
# Write data to a directory in HDFS based on a query
hive> INSERT OVERWRITE DIRECTORY '/some/directory' AS SELECT * FROM tableName WHERE partitionField='partitionValue';

# Write data to a local directory based on a query
hive> INSERT OVERWRITE LOCAL DIRECTORY '/some/local/directory' AS SELECT * FROM tableName WHERE partitionField='partitionValue';

# Write data to a table based on a query
hive> INSERT OVERWRITE TABLE tableName AS SELECT * FROM someOtherTable WHERE partitionField='partitionValue';

# Write data to a table based on a query, and setup a partition
# NOTE: Partitions are automatically created based on the value of the last column
hive> INSERT OVERWRITE TABLE accounts_by_state PARTITION(state) SELECT cust_id, fname, lname, address, city, zipcode, state FROM accounts;

#================================================================================================
# HIVE GROUP BY COMMANDS
#================================================================================================
# Write data of the form (field2, count) where count is a count of rows where field1 > 0
hive> FROM tableName INSERT OVERWRITE TABLE otherTableName SELECT field2, count(*) WHERE field1 > 0 GROUP BY field2;

# Write data of the form (field2, count) where count is a count of rows where field1 > 0
hive> INSERT OVERWRITE TABLE otherTableName SELECT field2, count(*) FROM tableName WHERE field1 > 0 GROUP BY field2;

#================================================================================================
# HIVE JOIN COMMANDS
#================================================================================================
hive> FROM tableName t1 JOIN otherTableName t2 ON (t1.field1 = t2.field2) INSERT OVERWRITE TABLE anotherTableName SELECT t1.field1 , t1.field2, t2.field2;