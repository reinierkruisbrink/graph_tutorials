# Download the data from: https://github.com/words-sdsc/coursera/blob/hands-on-updates-2024/big-data-5.zip
wget https://github.com/words-sdsc/coursera/raw/refs/heads/hands-on-updates-2024/big-data-5.zip
unzip big-data-5.zip
rm big-data-5.zip

# Pull the Neo4j container
docker pull pramonettivega/neo4j-coursera
# Pull the GraphX container
docker pull pramonettivega/graphx-coursera