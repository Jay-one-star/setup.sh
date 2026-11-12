#!/bin/bash

cd ~
# 1. 下載與解壓縮 Hadoop & HBase
wget https://dlcdn.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz
tar zxvf hadoop-3.3.6.tar.gz && mv hadoop-3.3.6 hadoop

wget https://dlcdn.apache.org/hbase/2.5.6/hbase-2.5.6-bin.tar.gz
tar zxvf hbase-2.5.6-bin.tar.gz && mv hbase-2.5.6 hbase

# 2. 寫入環境變數與節點清單 (已改為 master0 與 worker0)
echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> ~/hadoop/libexec/hadoop-config.sh
echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> ~/hadoop/etc/hadoop/hadoop-env.sh
echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> ~/hbase/conf/hbase-env.sh
echo "export HBASE_DISABLE_HADOOP_CLASSPATH_LOOKUP=\"true\"" >> ~/hbase/conf/hbase-env.sh

echo -e "master0\nworker0" > ~/hadoop/etc/hadoop/workers
echo -e "master0\nworker0" > ~/hbase/conf/regionservers

# 3. 覆寫 5 個 XML 設定檔 (主機名稱已改為 master0/worker0，路徑保留 /home/master)
cat << 'EOF' > ~/hadoop/etc/hadoop/core-site.xml
<configuration>
  <property>
    <name>fs.defaultFS</name>
    <value>hdfs://master0:9000</value>
  </property>
  <property>
    <name>hadoop.tmp.dir</name>
    <value>/home/master/hadoop_dir</value>
  </property>
</configuration>
EOF

cat << 'EOF' > ~/hadoop/etc/hadoop/hdfs-site.xml
<configuration>
  <property>
    <name>dfs.replication</name>
    <value>1</value>
  </property>
  <property>
    <name>dfs.permissions</name>
    <value>false</value>
  </property>
</configuration>
EOF

cat << 'EOF' > ~/hadoop/etc/hadoop/mapred-site.xml
<configuration>
  <property>
    <name>mapreduce.framework.name</name>
    <value>yarn</value>
  </property>
  <property>
    <name>yarn.app.mapreduce.am.env</name>
    <value>HADOOP_MAPRED_HOME=/home/master/hadoop</value>
  </property>
  <property>
    <name>mapreduce.map.env</name>
    <value>HADOOP_MAPRED_HOME=/home/master/hadoop</value>
  </property>
  <property>
    <name>mapreduce.reduce.env</name>
    <value>HADOOP_MAPRED_HOME=/home/master/hadoop</value>
  </property>
</configuration>
EOF

cat << 'EOF' > ~/hadoop/etc/hadoop/yarn-site.xml
<configuration>
  <property>
    <name>yarn.resourcemanager.scheduler.address</name>
    <value>master0:8030</value>
  </property>
  <property>
    <name>yarn.resourcemanager.resource-tracker.address</name>
    <value>master0:8031</value>
  </property>
  <property>
    <name>yarn.resourcemanager.address</name>
    <value>master0:8032</value>
  </property>
  <property>
    <name>yarn.nodemanager.address</name>
    <value>0.0.0.0:8034</value>
  </property>
  <property>
    <name>yarn.nodemanager.aux-services</name>
    <value>mapreduce_shuffle</value>
  </property>
  <property>
    <name>yarn.nodemanager.local-dirs</name>
    <value>/home/master/hadoop_dir/nm-local-dir</value>
  </property>
  <property>
    <name>yarn.nodemanager.log-dirs</name>
    <value>/home/master/hadoop_dir/userlogs</value>
  </property>
</configuration>
EOF

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

# 4. 寫入 ~/.bashrc 環境變數
cat << 'EOF' >> ~/.bashrc
export HADOOP_HOME=$HOME/hadoop
export HADOOP_MAPRED_HOME=$HADOOP_HOME
export HADOOP_COMMON_HOME=$HADOOP_HOME
export HADOOP_HDFS_HOME=$HADOOP_HOME
export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
export YARN_HOME=$HADOOP_HOME
export YARN_CONF_DIR=$HADOOP_HOME/etc/hadoop
export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
export HBASE_HOME=$HOME/hbase
export PATH=$PATH:$HBASE_HOME/bin
EOF

echo "設定檔全部寫入完成！請執行 source ~/.bashrc"
