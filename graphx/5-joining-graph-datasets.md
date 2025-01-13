### Run the following command to access the container's shell
```shell
docker exec -it graphx-coursera /bin/sh
```

### Open a Spark shell
```
spark-shell
```

### Setup the session
```scala
import org.apache.log4j.Logger
import org.apache.log4j.Level
Logger.getLogger("org").setLevel(Level.ERROR)
Logger.getLogger("akka").setLevel(Level.ERROR)
import org.apache.spark.graphx._
import org.apache.spark.rdd._

```

### Create a new dataset
```scala
val airports: RDD[(VertexId, String)] = sc.parallelize(
    List((1L, "Los Angeles International Airport"),
      (2L, "Narita International Airport"),
      (3L, "Singapore Changi Airport"),
      (4L, "Charles de Gaulle Airport"),
      (5L, "Toronto Pearson International Airport")))
```

### Define a list of edges that will make up the flights
```scala
val flights: RDD[Edge[String]] = sc.parallelize(
  List(Edge(1L,4L,"AA1123"),
    Edge(2L, 4L, "JL5427"),
    Edge(3L, 5L, "SQ9338"),
    Edge(1L, 5L, "AA6653"),
    Edge(3L, 4L, "SQ4521")))
```

### Define the flightGraph graph from the airports vertices and the flights edges
```scala
val flightGraph = Graph(airports, flights)
```

### Print the departing and arrival airport and the flight number for each triplet in the flightGraph graph
```scala
flightGraph.triplets.foreach(t => println("Departs from: " + t.srcAttr + " - Arrives at: " + t.dstAttr + " - Flight Number: " + t.attr))
```

### Define an AirportInformation class to store the airport city and code
```scala
case class AirportInformation(city: String, code: String)
```

### Define the list of airport information vertices
```scala
val airportInformation: RDD[(VertexId, AirportInformation)] = sc.parallelize(
  List((2L, AirportInformation("Tokyo", "NRT")),
    (3L, AirportInformation("Singapore", "SIN")),
    (4L, AirportInformation("Paris", "CDG")),
    (5L, AirportInformation("Toronto", "YYZ")),
    (6L, AirportInformation("London", "LHR")),
    (7L, AirportInformation("Hong Kong", "HKG"))))
```

### Create a mapping function that appends the city name to the name of the airport
```scala
def appendAirportInformation(id: VertexId, name: String, airportInformation: AirportInformation): String = name + ":"+ airportInformation.city

```

### Use joinVertices on flightGraph to join the airportInformation vertices to a new graph called flightJoinedGraph
```scala
val flightJoinedGraph =  flightGraph.joinVertices(airportInformation)(appendAirportInformation)
flightJoinedGraph.vertices.foreach(println)
```

### Use outerJoinVertices on flightGraph to join the airportInformation vertices with additional airportInformation such as city and code, to a new graph called flightOuterJoinedGraph
```scala
val flightOuterJoinedGraph = flightGraph.outerJoinVertices(airportInformation)((_,name, airportInformation) => (name, airportInformation))
flightOuterJoinedGraph.vertices.foreach(println)
```

### Use outerJoinVertices on flightGraph to join the airportInformation vertices with additional airportInformation such as city and code, to a new graph called flightOuterJoinedGraphTwo but this time printing 'NA' if there is no additional information
```scala
val flightOuterJoinedGraphTwo = flightGraph.outerJoinVertices(airportInformation)((_, name, airportInformation) => (name, airportInformation.getOrElse(AirportInformation("NA","NA"))))
flightOuterJoinedGraphTwo.vertices.foreach(println)
```

### Create a case class called Airport to store the information for the name, city, and code of the airport
```scala
case class Airport(name: String, city: String, code: String)
```

### Print the airportInformation with the name, city, and code within each other
```scala
  val flightOuterJoinedGraphThree = flightGraph.outerJoinVertices(airportInformation)((_, name, b) => b match {
  case Some(airportInformation) => Airport(name, airportInformation.city, airportInformation.code)
  case None => Airport(name, "", "")
})
flightOuterJoinedGraphThree.vertices.foreach(println)
```
