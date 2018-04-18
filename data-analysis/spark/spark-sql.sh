# Spark SQL Notes

#================================================================================================
# CREATE SQL/HIVE CONTEXT
#================================================================================================
spark> val sqlCtx = new SQLContext(sc)
spark> val hiveCtx = new HiveContext(sc)

#================================================================================================
# LOADING AND SAVING DATAFRAMES
#================================================================================================
## LOAD OPERATIONS ##
### Load Generic DataFrame ###
spark> val df = sqlContext.read.load("/path/to/any/supported/file.type")

### Load Avro ###
spark> import com.databricks.spark.avro._;
spark> val avroDF = sqlContext.read.avro("/path/to/avrofiles")

### Load JSON ###
spark> val jsonDF = sqlContext.read.json("/path/to/some/jsonfiles")

### Load parquet ###
spark> val parquetDF = sqlContext.read.parquet("/path/to/some/parquetfiles")

### Load JDBC ###
spark> val accountsDF = sqlContext.load("jdbc", \
    Map("url"-> "jdbc:mysql://host:port/database?user=username&password=pass",
    "dbtable" -> "accounts")) 

## SAVE OPERATIONS ##

### Write Avro ###
spark> import com.databricks.spark.avro._;
spark> df.write.avro("/path/to/my/saved/file.avro")

### Write Compressed Avro ###
spark> import com.databricks.spark.avro._;
spark> sqlContext.setConf("spark.sql.avro.compression.codec", "<uncompressed, snappy>")
spark> df.write.avro("/save/path")

### Write JSON ###
spark> df.toJSON.saveAsTextFile("/save/path")

### Write Compressed JSON ###
spark> df.toJSON.saveAsTextFile("/save/path", classOf[org.apache.hadoop.io.compress.GzipCodec])

### Write Parquet ###
spark> df.write.parquet("/save/path")

### Write Compressed Parquet ###
spark> sqlContext.setConf("spark.sql.parquet.compression.codec", "<uncompressed, gzip, lzo, snappy>")
spark> df.write.parquet("/save/path")

### Write Optimized Row Columnar (ORC) data ###
spark> sequenceData.map(x => {var d = x._2.split("\t"); (d(0), d(1), d(2), d(3))}).toDF("col1", "col2", "col3", "col4").write.orc("/path/to/orcfiles")

### Write JDBC ###
val prop = new java.util.Properties
prop.setProperty("driver", "com.mysql.jdbc.Driver")
prop.setProperty("user", "root")
prop.setProperty("password", "pw") 

//jdbc mysql url
val url = "jdbc:mysql://host:port/database"
 
//destination database table 
val table = "tableName"

spark> df.write.mode().jdbc(url, table, prop)

### Save as a Hive Table ###
# NOTE: Only possible with HiveContext
spark> df.write.format("parquet").mode(<append, overwrite, ignore>).options("compression", "snappy").saveAsTable("tableName")

#================================================================================================
# BASIC DATAFRAME OPERATIONS
#================================================================================================
# View a dataframe
spark> dataFrame.show(n)

# Collect
spark> dataFrame.collect()

# Take
spark> dataFrame.take(n)

# Count
spark> dataFrame.count()

# View the schema
spark> dataFrame.printSchema()

# Select a column and show it
# TODO: Slides say to use triple quotes.  This may be specific to HiveContext
spark> dataFrame.select("name").show()

# Select everybody, and increment age by 1
spark> dataFrame.select(dataFrame("name"), dataFrame("age") + 1).show()

# Limit
spark> dataFrame.select(dataFrame("name"), dataFrame("age") + 1).limit(2).show()

# Select using a filter
spark> dataFrame.filter(dataFrame("age") > 21).show()

# Select using where
spark> dataFrame.select("age", "name").where("age > 10").show()

# Sort data
spark> dataFrame.sort(dataFrame("name").asc)

# Count by a column
spark> dataFrame.groupBy("age").count().show()

# Convert an RDD to a DataFrame
spark> val someDataFrame = someRdd.toDF()

# Convert a DataFrame to an RDD
spark> val someRdd = someDF.rdd

# Register a temp table name to a dataframe
spark> someDF.registerTempTable("tableName")

# Rename a column in a dataframe
spark> someDF.select(col("field1").alias("newName"), col("field2"), col("field3"))

#================================================================================================
# GROUP BY -> AGGREGATION (VERY USEFUL)
#================================================================================================
spark> someDF.
	.groupBy(to_date(from_unixtime(col("order_date")/1000)).alias("order_formatted_date"), col("order_status"))
	.agg(round(sum("order_item_subtotal"),2).alias("total_amount"), countDistinct("order_id").alias("total_orders"))
	.orderBy(col("order_formatted_date").desc, col("order_status"), col("total_amount").desc, col("total_orders"));

#================================================================================================
# TMESTAMP TO DATE HANDLING
#================================================================================================
spark> val dates = ordersDF.select(to_date(from_unixtime(ordersDF("order_date"))).alias("date")).show

#================================================================================================
# INFERRING DATAFRAME SCHEMA USING REFLECTION
#================================================================================================
// create a class to represent the schema
spark> case class Person (name: String, age: Int)

// load data as RDD
spark> val people = sc.textFile("/some/text/file.txt").map(_.split(",")).map(p => Person(p(0), p(1).trim.toInt)).toDF()

// assign a table name
spark> people.registerTempTable("people")

// use a select statement to generate a new DataFrame
spark> people.sql("SELECT * FROM people WHERE age > 12 AND age < 20")

#================================================================================================
# PROGRAMMATIC DATAFRAME SCHEMA CREATION
#================================================================================================
// Import Row.
import org.apache.spark.sql.Row;

// Import Spark SQL data types
import org.apache.spark.sql.types.{StructType,StructField,StringType};

// load data as RDD
spark> val people = sc.textFile("/some/text/file.txt").map(_.split(",")).map(p => Row(p(0), p(1).trim))

// create a schema string
spark> val schemaString = "name age"

// Generate the schema based on the string of schema
spark> val schema = \
    StructType( \
        schemaString.split(" ").map(fieldName => StructField(fieldName, StringType, true)))

// Apply the schema to the RDD.
spark> val peopleDF = sqlContext.createDataFrame(people, schema)
    
// assign a table name
spark> peopleDF.registerTempTable("people")

// use a select statement to generate a new DataFrame
spark> people.sql("SELECT * FROM people WHERE age > 12 AND age < 20")