#!/usr/bin/env bash

BUILD_DIR=$1

indent() {
  # Handle GNU vs BSD sed
  case $(sed --help 2>&1) in
    *GNU*) sed_u () { sed -u "$@"; };;
    *) sed_u () { sed "$@"; };;
  esac

  sed_u 's/^/      /'
}

# download and "install" confluent
ARCHIVE_URL="http://packages.confluent.io/archive/3.0/confluent-3.0.0-2.11.tar.gz"

echo "Downloading Confluent..." | indent

wget -qO - $ARCHIVE_URL | tar -zxf -
if ! [ $? ]; then
    echo "FAILED to obtain confluent distribution" | indent
    exit 1
fi

cp -a confluent-3.0.0/* $BUILD_DIR/

# fix broken symlink
cd $BUILD_DIR/share/java/kafka
ln -sf kafka_2.11-0.10.0.0-cp1.jar kafka.jar
cd $BUILD_DIR

echo "Copied Confluent successfully" | indent

rm -rf $BUILD_DIR/share/java/kafka-connect-hdfs
rm -rf $BUILD_DIR/share/java/schema-registry
rm -rf $BUILD_DIR/share/java/confluent-control-center
rm -rf $BUILD_DIR/confluent-3.0.0

echo "Deleted extra share directories to reduce slug size" | indent

export CLASSPATH="$CLASSPATH:/app/target/kafka-connect-twitter-0.1-jar-with-dependencies.jar"
