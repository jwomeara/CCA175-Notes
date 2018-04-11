# HCATALOG notes

# Specify a single command at host CLI
hcat -e "CREATE TABLE tableName (field1 INT, field2 STRING) \
    ROW FORMAT DELIMETED FIELDS TERMINATED BY ',' \
    LOCATION '/some/hdfs/path';"

# Use hcat to show tables created directly in Hive
hcat -e "SHOW TABLES"

# Use hcat to list the fields in a specific tableName
hcat -e "DESCRIBE tableName"

# Drop a table using hcat
hcat -e "DROP TABLE tableName"