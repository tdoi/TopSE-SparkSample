package jp.topse

import org.apache.spark.SparkContext

object WordCount {
  def main(args: Array[String]) {
    val sc = new SparkContext("local[*]", "WordCount")
    try {
      val fileRDD = sc.textFile(args(0))
      val processedRDD = fileRDD
        .flatMap(elem => elem.split(" "))
        .filter(elem => !elem.isEmpty)
        .map(elem => (elem.toLowerCase, 1))
        .reduceByKey((sum, elem) => sum + elem)

      processedRDD.saveAsTextFile(args(1))
    } finally {
      sc.stop()
    }
  }
}
