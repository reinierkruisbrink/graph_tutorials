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

```