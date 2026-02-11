set shell := ["bash", "-c"]

spark_version := "3.5"
scala_version := "2.12"
flink_version := "1.20"
java_version  := "21"
lombok_version := "1.18.36"
hive_version := "4.2.0"
hive_compile_version := "3.1.3"
hadoop_version := "3.3.6"


hive_docker_version := "4.2.0"
hadoop_docker_version := "3.4.2"

default: help

help:
    @just --list

clean:
    echo "Cleaning Maven and Docker target directories..."
    mvn clean
    rm -rf docker/target

build-jars:
   mvn clean install -Dmaven.test.skip=true \
        -Dspark3.5 -Dscala-2.12 -Dflink1.20 \
        -Djava.version={{java_version}} \
        -Dhadoop.version={{hadoop_version}} \
        -Dhive.version={{hive_compile_version}} \
        -Dmaven.compiler.annotationProcessorPaths=org.projectlombok:lombok:1.18.36


build-images:
    @echo "Building Hudi Docker Images for Hadoop {{hadoop_version}}..."
    export DOCKER_BUILDKIT=1; \
    export HADOOP_VERSION={{hadoop_version}}; \
    export HIVE_VERSION={{hive_version}}; \
    cd docker && ./build_docker_images.sh

build: build-jars build-images
    echo "Full Hudi Java {{java_version}} build complete!"

demo-up:
    cd docker/compose && docker-compose up -d

demo-down:
    cd docker/compose && docker-compose down

check-tools:
    @command -v java >/dev/null 2>&1 || { echo >&2 "Java is required but not installed. Aborting."; exit 1; }
    @command -v mvn >/dev/null 2>&1 || { echo >&2 "Maven is required but not installed. Aborting."; exit 1; }
    @command -v docker >/dev/null 2>&1 || { echo >&2 "Docker is required but not installed. Aborting."; exit 1; }
    @command echo "All tools (Java, Maven, Docker) are present."
