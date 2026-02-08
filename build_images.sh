mvn clean install -DskipTests -Dspark3.5 -Dscala-2.12 -Dflink1.20 -Djava.version=21
cd docker
DOCKER_BUILDKIT=1 ./build_docker_images.sh
