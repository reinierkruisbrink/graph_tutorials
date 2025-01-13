###  Import the relevant libraries and functions
```scala
import org.knowm.xchart.{XYChartBuilder, SwingWrapper, BitmapEncoder, CategoryChart, CategoryChartBuilder}
import org.knowm.xchart.style.markers.SeriesMarkers
import org.knowm.xchart.BitmapEncoder.BitmapFormat
```

### Define a function to create a histogram of the degrees
```scala
def degreeHistogram(net: Graph[PlaceNode, Int]): Array[(Int, Int)] =
  net.degrees.
    filter { case (vid, count) => vid >= 100 }.
    map(t => (t._2,t._1)).
    groupByKey.map(t => (t._1,t._2.size)).
    sortBy(_._1).collect()
```

### Calculate the probability distribution for the degree histogram
```scala
val nn = metrosGraph.vertices.filter{ case (vid, count) => vid >= 100 }.count()
val metroDegreeDistribution = degreeHistogram(metrosGraph).map({case(d,n) => (d,n.toDouble/nn)})
```

### ...
```scala
val xData = metroDegreeDistribution.map(_._1.toDouble)
val yData = metroDegreeDistribution.map(_._2)

val chart = new XYChartBuilder().width(800).height(600).title("Degree Distribution").xAxisTitle("Degrees").yAxisTitle("Distribution").build()
chart.getStyler.setMarkerSize(6)
val series = chart.addSeries("Degree Distribution", xData, yData)
series.setMarker(SeriesMarkers.CIRCLE)
BitmapEncoder.saveBitmap(chart, "./Degree_Distribution.png", BitmapFormat.PNG)

val chart = new CategoryChartBuilder().width(800).height(600).title("Degree Histogram of Node Degrees").xAxisTitle("Degrees").yAxisTitle("Frequency").build()
chart.addSeries("Frequency", xData.map(_.toDouble), yData.map(_.toDouble)) 
BitmapEncoder.saveBitmap(chart, "./Degree_Histogram.png", BitmapFormat.PNG)
```

### Exit the spark shell with 
CTRL+C then run `exit`

### Copy the distribution from the container to your machine
```shell
docker cp graphx-coursera:Degree_Distribution.png .
```

### Copy the histogram from the container to your machine
```shell
docker cp graphx-coursera:Degree_Histogram.png . 
```