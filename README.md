# Graph Tutorials

This repository contains tutorials and examples for working with graph data using Neo4j and GraphX.

## Contents

### Neo4j
- **1-getting_started.cql**: Introduction to Neo4j and basic setup.
- **2-modifying_graphs.cql**: How to modify graphs in Neo4j.
- **3-importing_data.cql**: Importing data into Neo4j.
- **4-basic_queries.cql**: Basic queries in Neo4j.
- **5-path_analytics.cql**: Path analytics using Neo4j.
- **6-connectivity_analytics.cql**: Connectivity analytics using Neo4j.
- **7-assignment.cql**: Assignment for practicing Neo4j queries.

### GraphX
- **...**: ...

## Data

- **big-data-5/graphx/EOADATA/**: Example data for GraphX.
- **big-data-5/neo4j/**: CSV files for Neo4j examples.

## Setup

Run `setup.sh` to set up the environment. Make sure Docker is running (either desktop or daemon).

### Start the Neo4j container (then go to localhost:8080)
`docker run --name neo4j-coursera -p 7474:7474 -p 7687:7687 -d -e NEO4J_AUTH=none pramonettivega/neo4j-coursera`

### Start the GraphX container
`docker run -it --name graphx-coursera -p 4040:4040 pramonettivega/graphx-coursera`