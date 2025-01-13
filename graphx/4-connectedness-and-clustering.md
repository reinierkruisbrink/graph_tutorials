### Run the following command to access the container's shell
```shell
docker exec -it graphx-coursera /bin/sh
```

### Open a Spark shell
```
spark-shell --jars lib/gs-core-1.2.jar,lib/gs-ui-1.2.jar,lib/jcommon1.0.16.jar,lib/jfreechart-1.0.13.jar,lib/xchart-3.8.7.jar,lib/pherd-1.0.jar 
```

### Setup the session
```scala
import org.apache.log4j.Logger
import org.apache.log4j.Level
Logger.getLogger("org").setLevel(Level.ERROR)
Logger.getLogger("akka").setLevel(Level.ERROR)
import org.apache.spark.graphx._
import org.apache.spark.rdd._
import scala.io.Source
import org.graphstream.graph.implementations._

```

### Recreate cities-metro graph
```scala
class PlaceNode(val name: String) extends Serializable
case class Metro(override val name: String, population: Int) extends PlaceNode(name)
case class Country(override val name: String) extends PlaceNode(name)
val metros: RDD[(VertexId, PlaceNode)] =
  sc.textFile("./EOADATA/metro.csv").
    filter(! _.startsWith("#")).
    map {line =>
      val row = line split ','
      (0L + row(0).toInt, Metro(row(1), row(2).toInt))
    }
val countries: RDD[(VertexId, PlaceNode)] =
  sc.textFile("./EOADATA/country.csv").
    filter(! _.startsWith("#")).
    map {line =>
      val row = line split ','
      (100L + row(0).toInt, Country(row(1)))
    }
val mclinks: RDD[Edge[Int]] =
  sc.textFile("./EOADATA/metro_country.csv").
    filter(! _.startsWith("#")).
    map {line =>
      val row = line split ','
      Edge(0L + row(0).toInt, 100L + row(1).toInt, 1)
    }
```

### Load the continent data and view the first 5 vertices and edges
```scala
Source.fromFile("./EOADATA/continent.csv").getLines().take(5).foreach(println)
Source.fromFile("./EOADATA/country_continent.csv").getLines().take(5).foreach(println)
```

### Create a new graph by adding the Continents dataset
```scala
case class Continent(override val name: String) extends PlaceNode(name)
val continents: RDD[(VertexId, PlaceNode)] =
  sc.textFile("./EOADATA/continent.csv").
    filter(! _.startsWith("#")).
    map {line =>
      val row = line split ','
      (200L + row(0).toInt, Continent(row(1))) // Add 200 to the VertexId to keep the indexes unique
    }
val cclinks: RDD[Edge[Int]] =
  sc.textFile("./EOADATA/country_continent.csv").
    filter(! _.startsWith("#")).
    map {line =>
      val row = line split ','
      Edge(100L + row(0).toInt, 200L + row(1).toInt, 1)
    }
```

### Concatenate the three sets of nodes into a single RDD
```scala
val cnodes = metros ++ countries ++ continents

```

### Concatenate the two sets of edges
```scala
val clinks = mclinks ++ cclinks
```

### Create the graph
```scala
val countriesGraph = Graph(cnodes, clinks)
```

### Create a new instance of GraphStream's SingleGraph class using the countriesGraph
```scala
val graph: SingleGraph = new SingleGraph("countriesGraph")
```

### Load the graphX vertices into GraphStream nodes
```scala
for ((id:VertexId, place:PlaceNode) <- countriesGraph.vertices.collect())
{
  val node = graph.addNode(id.toString).asInstanceOf[SingleNode]
  node.addAttribute("name", place.name)
  node.addAttribute("ui.label", place.name)

  if (place.isInstanceOf[Metro])
    node.addAttribute("ui.class", "metro")
  else if(place.isInstanceOf[Country])
    node.addAttribute("ui.class", "country")
  else if(place.isInstanceOf[Continent])
    node.addAttribute("ui.class", "continent")
}
```

### Load the graphX edges into GraphStream edges
```scala
for (Edge(x,y,_) <- countriesGraph.edges.collect()) {
  graph.addEdge(x.toString ++ y.toString, x.toString, y.toString, true).asInstanceOf[AbstractEdge]
}
```

### Save the graph in a graph file
```scala
import org.graphstream.stream.file.FileSinkGraphML
val sink = new FileSinkGraphML()
val graphMLPath = "countriesGraph.graphml"

try {
  sink.writeAll(graph, graphMLPath)
  println(s"Graph exported to GraphML at: $graphMLPath")
} catch {
  case e: Exception => e.printStackTrace()
}
```

### Exit the spark shell with 
CTRL+C then run `exit`

### Copy the graph from the container to your machine
```shell
docker cp graphx-coursera:/countriesGraph.graphml ./countriesGraph.graphml
```

### Install Gephi 
https://gephi.org/users/install

### Open the graph in Gephi
- Find the file and open in Gephi
- This graph does not really tell us anything yet. To get a more appropriate visualization of this network, go to the left corner of the screen to the Appearance window. Select Partition, then ui.class from the drop-down menu. Click Apply.
- The nodes will change color according to their labels. Now we need to get a better layout. In the Layout window on the left, select Yifan Hu Proportional, and then click Run.