set shell := ["bash", "-c"]

spark_version := "3.5"
scala_version := "2.12"
flink_version := "1.20"
java_version  := "21"
lombok_version := "1.18.36"

default: help

help:
    @just --list

clean:
    echo "Cleaning Maven and Docker target directories..."
    mvn clean
    rm -rf docker/target

build-jars:
    echo "Compiling Hudi JARs with Java {{java_version}}..."
    mvn clean install -DskipTests \
        -Dspark{{spark_version}} \
        -Dscala-{{scala_version}} \
        -Dflink{{flink_version}} \
        -Djava.version={{java_version}} \
        -Dmaven.compiler.annotationProcessorPaths=org.projectlombok:lombok:{{lombok_version}}

build-images:
    echo "Building Hudi Docker Images using BuildKit..."
    export DOCKER_BUILDKIT=1; \
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
