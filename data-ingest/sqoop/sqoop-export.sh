# SQOOP Export Notes

# Basic command
sqoop export \
    --connect jdbc:mysql://hostname:port/database \
    --username user --password pass \
    --table tableName \
    --export-dir "/some/hdfs/dir"

#================================================================================================
# BASIC export OPTIONS
#================================================================================================
# Export only specific set of columns
sqoop export \
    --connect jdbc:mysql://hostname:port/database \
    --username user --password pass \
    --table tableName \
    --columns "name,employee_id,jobtitle" \
    --export-dir "/some/hdfs/dir"

# Export as update
sqoop export \
    --connect jdbc:mysql://hostname:port/database \
    --username user --password pass \
    --table tableName \
    --update-key "id"
    --update-mode updateonly
    --export-dir "/some/hdfs/dir"

# Export as update and insert if missing
sqoop export \
    --connect jdbc:mysql://hostname:port/database \
    --username user --password pass \
    --table tableName \
    --update-key "id"
    --update-mode allowinsert
    --export-dir "/some/hdfs/dir"

# Export using specified field, and line terminators, and specified enclosure
sqoop export \
    --connect jdbs:mysql://hostname:port/database \
    --username user --password pass \
    --table tableName \
    --input-enclosed-by \" \
    --input-fields-terminated-by \t \
    --input-lines-terminated-by \r
    --export-dir "/some/hdfs/dir"