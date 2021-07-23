package jp.topse

import java.io.PrintWriter
import org.apache.spark.SparkContext

object WordCount {

  def main(args: Array[String]) {
    val sc = new SparkContext("spark://master:7077", "WordCount")
    try {
      val fileRDD = sc.textFile(args(0))
      val processedRDD = fileRDD
        .flatMap(elem => elem.split(" "))
        .filter(elem => !elem.isEmpty)
        .map(elem => (elem.toLowerCase, 1))
        .reduceByKey((sum, elem) => sum + elem, 3)

      processedRDD.saveAsTextFile(args(1))
    } finally {
      sc.stop()
    }
  }
}
