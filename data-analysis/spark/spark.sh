# Spark notes

#================================================================================================
# SPARK SHELL OPTIONS
#================================================================================================
# Run a local instance with 2 threads
spark-shell --master local[2]

# Running spark-shell on a cluster
spark-shell --master yarn

# set amount of memory per executor
--executor-memory 2G

#================================================================================================
# SPARK SUBMIT OPTIONS
#================================================================================================
# Run a local instance with 2 threads
spark-submit \
    --class "SimpleApp" \
    --master local[2] \
    path/to/spark/app.jar

# Running on a cluster in client mode
spark-submit \
    --class "SimpleApp" \
    --master yarn-client \
    path/to/spark/app.jar

# Running on a cluster in client mode
spark-submit \
    --class "SimpleApp" \
    --master yarn-cluster \
    path/to/spark/app.jar

#================================================================================================
# DATA INPUT
#================================================================================================
# read a text file into a value
spark> val textData = sc.textFile("someFile.txt")

# read a directory of text files into a value
# NOTE: Each row corresponds to a line
spark> val textData = sc.textFile("/some/path/to/files*.txt")

# read whole text files into an rdd
# NOTE: Each row corresponds to a specific file, represented as (filename, content)
spark> val fileData = sc.wholeTextFile("/some/directory/of/files*.txt")

#================================================================================================
# DATA OUTPUT
#================================================================================================
# Save as text file
spark> myRdd.saveAsTextFile("/path/to/textFile.txt")

# Save as sequence file
spark> myRdd.saveAsSequenceFile("/path/to/sequenceFile")

# Save as object file
spark> myRdd.saveAsObjectFile("/path/to/objectFile")

#================================================================================================
# RDD ACTIONS
#================================================================================================
# count the lines in a text file
spark> textFile.count()

# return an array of the first n elements
spark> textFile.take(n)

# return n samples of the elements
spark> textFile.takeSample(n)

# return an array of all elements
spark> textFile.collect()

# get the first line of the text file
spark> textFile.first()

# reduce a mapped dataset
spark> myRdd.reduce((a, b) => a + b)

# count by key
spark> myRdd.countByKey()

# for each
spark> myRdd.forEach(data => data.doSomething)

## Double RDD Actions
# Sum
spark> myRdd.sum()

# Mean
spark> myRdd.mean()

# Variance
spark> myRdd.variance()

# Std. Deviation
spark> myRdd.stddev()

#================================================================================================
# RDD TRANSFORMATIONS
#================================================================================================

# map and reduce data
spark> myRdd \
    .map(line => line.split(" ").size) \
    .reduce((a, b) => Math.max(a, b))

# filter lines according to lambda
spark> myRdd \
    .filter(line => line.contains("spark"))

# flat map - one to many mapping
spark> myRdd \
    .flatMap(line => line.split(" "))

# create an rdd that is a sampling of the original rdd
spark> myRdd.sample(n)

# Combine two datasets
spark> myRdd.union(otherRdd)

# Compute intersection of two datasets
spark> myRdd.intersection(otherRdd)

# Compute the distinct elements between two datasets
spark> myRdd.distinct(otherRdd)

# Cartesian (creates all combinations between the two sets)
spark> myRdd.cartesian(otherRdd)

# Subtract - removes supplied elements (rdd2) from rdd1
spark> myRdd.subtract(otherRdd)

# Zip (pairs up the sets)
spark> myRdd.zip(otherRdds)

#================================================================================================
# RDD KEY-WISE TRANSFORMATIONS
#================================================================================================
# Map values
spark> pairRdd.mapValues(val => val.upper())

# Flat map values
spark> pairRdd.flatMapValues(val => val.split(" "))

# Key by
spark> myRdd.keyBy(line => line.split(" ")(0))

# Return keys
spark> pairRdd.keys()

# Return values
spark> pairRdd.rows()

# count by key
spark> pairRdd.countByKey()

# Reduce by key for key-value pairs
# NOTE: Returns a tuple.  Function operates on value data
spark> pairRdd.reduceByKey(a, b) => a + b)

# Group by key
# NOTE: Transforms (K, V) to (K, Iterable<V>)
spark> pairRdd.groupByKey()

# Aggregate by key
# NOTE: Transforms (K, V) to (K, FUNC(V))
spark> pairRdd \
    .aggregateByKey(0)((accum, v) => accum + v, (v1, v2) => v1 + v2)

# Sort by key
## Ascending
spark> pairRdd.sortByKey(true)
## Descending
spark> pairRdd.sortByKey(false)

# NOTE: joins (K, V) with (K, W) as (K, (V, W))
## INNER JOIN
spark> pairRdd.join(otherPairRdd)
## LEFT OUTER JOIN
spark> pairRdd.leftOuterJoin(otherPairRdd)
## RIGHT OUTER JOIN
spark> pairRdd.rightOuterJoin(otherPairRdd)
## FULL OUTER JOIN
spark> pairRdd.fullOuterJoin(otherPairRdd)

# Co-Group
# NOTE: combines(K, V) and (K, W) by key, and returns (K, (Iterable<V>, Iterable<W>))
spark> pairRdd.coGroup(otherPairRdd)

#================================================================================================
# PASSING NAMED FUNCTIONS
#================================================================================================
# Scala function
def toUpper(s: String): String = {
    return s.upper()
}
    
# toUpper function usage
spark> textFile.map(toUpper).take(2)

#================================================================================================
# PASSING ANONYMOUS FUNCTIONS
#================================================================================================
# Long form
scala> textFile.map(line => line.upper()).take(2)

# Short form
scala> textFile.map(_.toUpper()).take(2)

#================================================================================================
# SELF-CONTAINED APPLICATIONS
#================================================================================================
# A simple scala spark app
#################################################################################################
/* SimpleApp.scala */
import org.apache.spark.SparkContext
import org.apache.spark.SparkContext._
import org.apache.spark.SparkConf

object SimpleApp {
  def main(args: Array[String]) {
    val logFile = "YOUR_SPARK_HOME/README.md" // Should be some file on your system
    val conf = new SparkConf().setAppName("Simple Application")
    
    val sc = new SparkContext(conf)

    val logData = sc.textFile(logFile, 2).cache()
    val numAs = logData.filter(line => line.contains("a")).count()
    val numBs = logData.filter(line => line.contains("b")).count()
    println("Lines with a: %s, Lines with b: %s".format(numAs, numBs))
    
    sc.stop()
  }
}
#################################################################################################

# Submitting your scala spark app with spark-submit
spark-submit \
    --class "SimpleApp" \
    --master local[4] \
    path/to/spark/app.jar

#================================================================================================
# MISC SPARK COMMANDS
#================================================================================================
# Parallelize a collection for use in spark
val myArray = Array(1, 2, 3, 4)
val myArrayRDD = sc.parallelize(myArray)