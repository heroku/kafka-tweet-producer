#!/usr/bin/env bash
set -eo pipefail

indent() {
    sed -u 's/^/      /'
}

# download and "install" confluent
ARCHIVE_URL=${ARCHIVE_URL_OVERRIDE:-http://packages.confluent.io/archive/3.0/confluent-3.0.0-2.11.tar.gz}

echo "Downloading Confluent" | indent

wget -qO - $ARCHIVE_URL | tar -zxf -
if ! [ $? ]; then
    echo "FAILED to obtain confluent distribution" | indent
    exit 1
fi

cp -a confluent-3.0.0/* $HOME/

# fix broken symlink
cd $HOME/share/java/kafka
ln -sf kafka_2.11-0.10.0.0-cp1.jar kafka.jar
cd $HOME

echo "Copied Confluent ${CONFLUENT_VERSION} successfully" | indent

rm -rf $HOME/share/java/kafka-connect-hdfs $HOME/share/java/schema-registry $HOME/share/java/confluent-control-center
rm -rf $HOME/confluent-3.0.0

echo "Deleted extra share and confluent directories to reduce slug size" | indent

export CLASSPATH="$CLASSPATH:/app/target/kafka-connect-twitter-0.1-jar-with-dependencies.jar"
