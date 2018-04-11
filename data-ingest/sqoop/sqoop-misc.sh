# SQOOP Miscellaneous Commands Notes

# Create a hive table without any data
# NOTE: This doesn't seem to work for bzip2 compressed avro data
sqoop create-hive-table --connect jdbc:mysql://hostname:port/dbname --username user --password pass \
    --table "sqlTable" \
    --hive-table "hiveTable"
    
# Evaluate a statement against a database
sqoop eval --connect jdbc:mysql://hostname:port/dbname --username user --password pass \
    --query "SELECT * FROM tableName LIMIT 10"
    
# List Databases available on a server
sqoop list-databases --connect jdbc:myswl://hostname:port --username user --password pass \

# List tables available within a database
sqoop list-tables --connect jdbc:myswl://hostname:port/dbname --username user --password pass \