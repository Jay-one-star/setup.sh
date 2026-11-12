cd ~
# 改從 archive.apache.org 下載 HBase 2.5.6 並解壓縮
wget https://archive.apache.org/dist/hbase/2.5.6/hbase-2.5.6-bin.tar.gz
tar zxvf hbase-2.5.6-bin.tar.gz && mv hbase-2.5.6 hbase

# 補寫剛才跳過的 HBase 環境設定與節點清單
echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> ~/hbase/conf/hbase-env.sh
echo "export HBASE_DISABLE_HADOOP_CLASSPATH_LOOKUP=\"true\"" >> ~/hbase/conf/hbase-env.sh
echo -e "master0\nworker0" > ~/hbase/conf/regionservers

# 補寫 hbase-site.xml
cat << 'EOF' > ~/hbase/conf/hbase-site.xml
<configuration>
  <property>
    <name>hbase.cluster.distributed</name>
    <value>true</value>
  </property>
  <property>
    <name>hbase.rootdir</name>
    <value>hdfs://master0:9000/hbase</value>
  </property>
  <property>
    <name>hbase.zookeeper.quorum</name>
    <value>master0,worker0</value>
  </property>
</configuration>
EOF
