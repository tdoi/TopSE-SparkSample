package jp.topse

import org.apache.spark.SparkContext

object UpperWords {
  def main(args: Array[String]) {
    val sc = new SparkContext("spark://master:7077", "UpperWords")
    try {
      val strList = List("Cat", "Dog", "Fox", "Tiger")
      val rdd = sc.parallelize(strList, 2)
      val upperedRDD = rdd.map(str => str.toUpperCase)
      val upperedList = upperedRDD.collect
      val file = new PrintWriter("/var/tmp/uppers.txt")
      processedRDD.collect.foreach { case (word, count) => file.write(word + ":" + count + "\n") }
      file.close()
//      upperedList.foreach(println)
    } finally {
      sc.stop()
    }
  }
}
