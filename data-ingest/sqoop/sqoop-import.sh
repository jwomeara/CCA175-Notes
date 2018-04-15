# SQOOP Import Notes

# Basic command
sqoop import \
    --connect jdbc:mysql://hostname:port/database \
    --username user --password pass \
    --table tableName \
    --warehouse-dir "/some/hdfs/dir"

#================================================================================================
# DIRECT MODE
#================================================================================================
# Use this option to increase performance
--direct

#================================================================================================
# IMPORT ALL TABLES
#================================================================================================
# NOTE: import-all-tables shares the same set of options as regular ingest
sqoop import-all-tables \
    --connect jdbc:mysql://hostname:port/database \
    --username user --password pass \
    -m #mappers \
    --warehouse-dir "/some/hdfs/dir" \
    --as-textfile

#================================================================================================
# BASIC IMPORT OPTIONS
#================================================================================================
# Import only specific set of columns
sqoop import \
    --connect jdbc:mysql://hostname:port/database \
    --username user --password pass \
    -m #mappers \
    --table tableName \
    --as-textfile \
    --columns "name,employee_id,jobtitle" \
    --warehouse-dir "/some/hdfs/dir"

# Import the results of a free form query
sqoop import \
    --connect jdbc:mysql://hostname:port/database \
    --username user --password pass \
    -m #mappers \
    --query "SELECT * FROM tableName WHERE $CONDITIONS AND name = Joe" \
    --as-textfile \
    --warehouse-dir "/some/hdfs/dir"

# Use where clause to limit results
sqoop import \
    --connect jdbc:mysql://hostname:port/database \
    --username user --password pass \
    -m #mappers \
    --table tableName \
    --where "name = Joe" \
    --as-textfile \
    --warehouse-dir "/some/hdfs/dir"

#================================================================================================
# FIELD, LINE TERMINATION & ENCLOSE OPTIONS
#================================================================================================ 
# Import using \r to terminate lines and \t to terminate fields, with fields encolsed by \"
sqoop import \
    --connect jdbc:mysql://hostname:port/database \
    --username user --password pass \
    -m #mappers \
    --table tableName \
    --enclosed-by \" \
    --fields-terminated-by \t \
    --lines-terminated-by \r \
    --as-textfile \
    --warehouse-dir "/some/hdfs/dir"

#================================================================================================
# INCREMENTAL IMPORT
#================================================================================================
# Incremental import (append) 
# NOTE: Used where new rows are being added with increasing row id values
sqoop import \
    --connect jdbc:mysql://hostname:port/database \
    --username user --password pass \
    -m #mappers \
    --table tableName \
    --incremental append \
    --check-column "id" \
    --as-textfile \
    --warehouse-dir "/some/hdfs/dir"

# Incremental import (last modified)
# NOTE: Used to import all rows after 'last-value' for the specified column
sqoop import \
    --connect jdbc:mysql://hostname:port/database \
    --username user --password pass \
    -m #mappers \
    --table tableName \
    --incremental lastmodified \
    --last-value "2018-01-01"
    --check-column "date" \
    --as-textfile \
    --warehouse-dir "/some/hdfs/dir"

#================================================================================================
# FILE FORMAT OPTIONS
#================================================================================================
# Import from SQL to HDFS as avro
# NOTE: Avro schema will be present in current directory after successful import
sqoop import \
    --connect jdbc:mysql://hostname:port/database \
    --username user --password pass \
    -m #mappers \
    --table tableName \
    --as-avrodatafile \
    --warehouse-dir "/some/hdfs/dir"

# Import from SQL to HDFS as parquet
sqoop import \
    --connect jdbc:mysql://hostname:port/database \
    --username user --password pass \
    -m #mappers \
    --table tableName \
    --as-parquetfile \
    --warehouse-dir "/some/hdfs/dir"

# Import from SQL to HDFS as sequencefile
sqoop import \
    --connect jdbc:mysql://hostname:port/database \
    --username user --password pass \
    -m #mappers \
    --table tableName \
    --as-sequencefile \
    --warehouse-dir "/some/hdfs/dir"

# Import from SQL to HDFS as text (DEFAULT BEHAVIOR)
sqoop import \
    --connect jdbc:mysql://hostname:port/database \
    --username user --password pass \
    -m #mappers \
    --table tableName \
    --as-textfile \
    --warehouse-dir "/some/hdfs/dir"

#================================================================================================
# COMPRESSION OPTIONS
#================================================================================================
# Import from SQL to HDFS as gzip encoded text
sqoop import \
    --connect jdbc:mysql://hostname:port/database \
    --username user --password pass \
    -m #mappers \
    --table tableName \
    --compression-codec "gzip" \
    --compress \
    --as-textfile \
    --warehouse-dir "/some/hdfs/dir"
    
# Import from SQL to HDFS as bzip2 encoded text
sqoop import \
    --connect jdbc:mysql://hostname:port/database \
    --username user --password pass \
    -m #mappers \
    --table tableName \
    --compression-codec "bzip2" \
    --compress \
    --as-textfile \
    --warehouse-dir "/some/hdfs/dir"
    
# Import from SQL to HDFS as snappy encoded text
sqoop import \
    --connect jdbc:mysql://hostname:port/database \
    --username user --password pass \
    -m #mappers \
    --table tableName \
    --compression-codec "snappy" \
    --compress \
    --as-textfile \
    --warehouse-dir "/some/hdfs/dir"

#================================================================================================
# HIVE IMPORT OPTIONS
#================================================================================================
# Import from SQL to HIVE as text
sqoop import \
    --connect jdbc:mysql://hostname:port/database \
    --username user --password pass \
    -m #mappers \
    --table tableName \
    --as-textfile \
    --warehouse-dir "/some/hdfs/dir" \
    --hive-import

# Import from SQL to HIVE as text and overwrite existing table
sqoop import \
    --connect jdbc:mysql://hostname:port/database \
    --username user --password pass \
    -m #mappers \
    --table tableName \
    --as-textfile \
    --warehouse-dir "/some/hdfs/dir" \
    --hive-import \
    --hive-overwrite

# Import from SQL to HIVE as text to a named table
sqoop import \
    --connect jdbc:mysql://hostname:port/database \
    --username user --password pass \
    -m #mappers \
    --table tableName \
    --as-textfile \
    --warehouse-dir "/some/hdfs/dir" \
    --hive-import \
    --hive-table "otherTableName"

# Import from SQL to HIVE and setup partitions dynamically based on a specific key
sqoop import \
    --connect jdbc:mysql://hostname:port/database \
    --username user --password pass \
    -m #mappers \
    --table tableName \
    --as-textfile \
    --warehouse-dir "/some/hdfs/dir" \
    --hive-import \
    --hive-partition-key "state"

# Import from SQL to HIVE and setup a static partition of the given value
sqoop import \
    --connect jdbc:mysql://hostname:port/database \
    --username user --password pass \
    -m #mappers \
    --table tableName \
    --as-textfile \
    --warehouse-dir "/some/hdfs/dir" \
    --hive-import \
    --hive-partition-value "MD"