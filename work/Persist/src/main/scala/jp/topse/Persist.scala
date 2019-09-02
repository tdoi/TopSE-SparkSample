package jp.topse

import java.io.PrintWriter
import org.apache.spark.SparkContext
import org.apache.spark.storage.StorageLevel._


object Persist {

  def main(args: Array[String]) {
    val sc = new SparkContext("spark://master:7077", "Persist")
    try {
      val heavyRDD = sc.parallelize( 1 to 1, 1).map{
        d => Thread.sleep(5000)
        d
      }

      var start = System.currentTimeMillis
      heavyRDD.count
      var end = System.currentTimeMillis
      println(s"count job: ${end - start}ms")

      start = System.currentTimeMillis
      heavyRDD.sum
      end = System.currentTimeMillis
      println(s"sum job: ${end - start}ms")
    } finally {
      sc.stop()
    }
  }
}
