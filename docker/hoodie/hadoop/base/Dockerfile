
#  Licensed to the Apache Software Foundation (ASF) under one
#  or more contributor license agreements.  See the NOTICE file
#  distributed with this work for additional information
#  regarding copyright ownership.  The ASF licenses this file
#  to you under the Apache License, Version 2.0 (the
#  "License"); you may not use this file except in compliance
#  with the License.  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
# limitations under the License.

# Use Ubuntu 22.04 (Jammy) - very stable for Hadoop/Big Data stacks
FROM ubuntu:22.04

# Replace MAINTAINER (deprecated) with LABEL
LABEL maintainer="Hoodie"

USER root

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

# Prevent interactive prompts during apt-get
ENV DEBIAN_FRONTEND=noninteractive

ARG HADOOP_VERSION=3.3.4 
ARG HADOOP_URL=https://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz
ENV HADOOP_VERSION ${HADOOP_VERSION}
ENV HADOOP_URL ${HADOOP_URL}

# Install Java 21 and other utilities
RUN set -x \
    && apt-get update \
    && apt-get install -yq \
       openjdk-21-jdk \
       curl \
       wget \
       netcat \
       procps \
    && echo "Fetch URL is : ${HADOOP_URL}" \
    && curl -fSL "${HADOOP_URL}" -o /tmp/hadoop.tar.gz \
    && mkdir -p /opt/hadoop-$HADOOP_VERSION/logs \
    && tar -xzf /tmp/hadoop.tar.gz -C /opt/ \
    && rm /tmp/hadoop.tar.gz \
    && rm -r /opt/hadoop-$HADOOP_VERSION/share/doc \
    && ln -s /opt/hadoop-$HADOOP_VERSION/etc/hadoop /etc/hadoop \
    && if [ -f /etc/hadoop/mapred-site.xml.template ]; then cp /etc/hadoop/mapred-site.xml.template /etc/hadoop/mapred-site.xml; fi \
    && mkdir /hadoop-data \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set Java Environment Variables (Standard path on Ubuntu 22.04)
ENV JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
ENV HADOOP_PREFIX=/opt/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR=/etc/hadoop
ENV MULTIHOMED_NETWORK=1
ENV HADOOP_HOME=${HADOOP_PREFIX}
ENV HADOOP_INSTALL=${HADOOP_HOME}
ENV USER=root

# Add both Java and Hadoop to PATH
ENV PATH $JAVA_HOME/bin:$HADOOP_PREFIX/bin:$PATH

# Exposing a union of ports
EXPOSE 0-1024 4040 7000-10100 5000-5100 50000-50200 58188 58088 58042 

ADD entrypoint.sh /entrypoint.sh
ADD export_container_ip.sh /usr/bin/
RUN chmod a+x /usr/bin/export_container_ip.sh \
    && chmod a+x /entrypoint.sh

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
