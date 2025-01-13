# Graph Tutorials

This repository contains tutorials and examples for working with graph data using Neo4j and GraphX.

## Contents

### Neo4j
- **1-getting_started.md**
- **2-modifying_graphs.md**
- **3-importing_data.md**
- **4-basic_queries.md**
- **5-path_analytics.md**
- **6-connectivity_analytics.md**
- **7-assignment.md**

### GraphX
- **0-setup.md**
- **1-build-a-graph.md**
- **2-building-degree-histogram.md**
- **3-plot-degree-histogram.md**
- **4-connectedness-and-clustering.md**
- **5-joining-graph-datasets.md**

## Data

- **big-data-5/graphx/EOADATA/**: Example data for GraphX.
- **big-data-5/neo4j/**: CSV files for Neo4j examples.

## Setup

Run `setup.sh` to set up the environment. Make sure Docker is running (either desktop or daemon).

### Start the Neo4j container (then go to localhost:7474)
`docker run --name neo4j-coursera -p 7474:7474 -p 7687:7687 -d -e NEO4J_AUTH=none pramonettivega/neo4j-coursera`

### Start the GraphX container
`docker run -it --name graphx-coursera -p 4040:4040 pramonettivega/graphx-coursera`