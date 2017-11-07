#!/bin/bash

pushd /root > /dev/null

if [ -d "tachyon" ]; then
  echo "Tachyon seems to be installed. Exiting."
  return 0
fi

# Github tag:
if [[ "$TACHYON_VERSION" == *\|* ]]
then
  # Not yet supported
  echo "Tachyon git hashes are not yet supported. Please specify a Tachyon release version."
# Pre-package tachyon version
else
  case "$TACHYON_VERSION" in
    0.3.0)
      wget https://s3.amazonaws.com/Tachyon/tachyon-0.3.0-bin.tar.gz
      ;;
    0.4.0)
      wget https://s3.amazonaws.com/Tachyon/tachyon-0.4.0-bin.tar.gz
      ;;
    0.4.1)
      wget https://s3.amazonaws.com/Tachyon/tachyon-0.4.1-bin.tar.gz
      ;;
    0.5.0)
      if [[ "$HADOOP_MAJOR_VERSION" == "1" ]]; then
        wget https://s3.amazonaws.com/Tachyon/tachyon-0.5.0-bin.tar.gz
      else
        wget https://s3.amazonaws.com/Tachyon/tachyon-0.5.0-cdh4-bin.tar.gz
      fi
      ;;
    0.6.0)
      if [[ "$HADOOP_MAJOR_VERSION" == "1" ]]; then
        wget https://s3.amazonaws.com/Tachyon/tachyon-0.6.0-bin.tar.gz
      else
        wget https://s3.amazonaws.com/Tachyon/tachyon-0.6.0-cdh4-bin.tar.gz
      fi
      ;;
    0.6.4)
      if [[ "$HADOOP_MAJOR_VERSION" == "1" ]]; then
        wget https://s3.amazonaws.com/Tachyon/tachyon-0.6.4-bin.tar.gz
      elif [[ "$HADOOP_MAJOR_VERSION" == "2" ]]; then
        wget https://s3.amazonaws.com/Tachyon/tachyon-0.6.4-cdh4-bin.tar.gz
      else
        wget https://s3.amazonaws.com/Tachyon/tachyon-0.6.4-hadoop2.4-bin.tar.gz
      fi
      ;;
    1.6.0)
      wget http://downloads.alluxio.org/downloads/files/$TACHYON_VERSION/alluxio-$TACHYON_VERSION-hadoop-2.7-bin.tar.gz
      ;;
    *)
      if [[ "$HADOOP_MAJOR_VERSION" == "1" ]]; then
        wget https://s3.amazonaws.com/Tachyon/tachyon-$TACHYON_VERSION-bin.tar.gz
      elif [[ "$HADOOP_MAJOR_VERSION" == "2" ]]; then
        wget https://s3.amazonaws.com/Tachyon/tachyon-$TACHYON_VERSION-cdh4-bin.tar.gz
      else
        wget http://downloads.alluxio.org/downloads/files/$TACHYON_VERSION/alluxio-$TACHYON_VERSION-hadoop-2.7-bin.tar.gz
        #wget https://s3.amazonaws.com/Tachyon/tachyon-$TACHYON_VERSION-hadoop2.4-bin.tar.gz
      fi
      if [ $? != 0 ]; then
        echo "ERROR: Unknown Tachyon version"
        return -1
      fi
  esac

  echo "Unpacking Tachyon or Alluxio"
  if $TACHYON_VERSION == "1.6.0" then
    tar xvzf alluxio-*.tar.gz > /tmp/spark-ec2_alluxio.log
    rm alluxio-*.tar.gz
    mv `ls -d alluxio-*` alluxio
  else
    tar xvzf tachyon-*.tar.gz > /tmp/spark-ec2_tachyon.log
    rm tachyon-*.tar.gz
    mv `ls -d tachyon-*` tachyon
  fi
fi

popd > /dev/null
