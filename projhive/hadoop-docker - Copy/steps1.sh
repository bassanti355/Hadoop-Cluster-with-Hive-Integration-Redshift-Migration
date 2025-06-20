Solution to installing hadoop:
1)first pull the image to use :
----docker pull ubuntu:22.04
22.04: Pulling from library/ubuntu
The Digest: sha256:ed1544e454989078f5dec1bfdabd8c5cc9c48e0705d07b678ab6ae3fb61952d2
 
2)create network to use ?
-----docker network create hadoop_network
The Digest: 22e2b4d2a1eb35f0a0823cddb3c829dd722b59b7140ce26f5dcc55bb11338a8e
 
3) build the container based on the image  and attach a shell to it
	(take on mind to name it /name host /give it the network/…)
 









4) # 1. Update and install dependencies
1.	package update and upgrade all 
2.	sudo apt update -y
3.	sudo apt upgrade -y
4.	sudo apt install  sudo  
5.	apt install ssh -y
6.	apt install openjdk-8-jdk -y
7.	apt install nano -y
8.	apt install curl -y

# 2. Set root password (optional)
9.	echo "root:123" | sudo chpasswd
# 3. Create hadoop user and group
10.	addgroup Hadoop 
11.	adduser –ingroup hadoop  hadoop
12.	usermod -aG sudo hadoop 

# 4. Set environment variables
13.	sudo -u hadoop bash -c 'echo "     or    nano ~/.bashrc 
14.	export HADOOP_HOME=/usr/local/hadoop
15.	export PATH=\$HADOOP_HOME/bin:\$HADOOP_HOME/sbin:\$PATH:/usr/local/zookeeper/bin
16.	export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
17.	export HDFS_NAMENODE_USER=hadoop
18.	export HDFS_DATANODE_USER=hadoop
19.	export HDFS_SECONDARYNAMENODE_USER=hadoop
20.	export YARN_RESOURCEMANAGER_USER=hadoop
21.	export YARN_NODEMANAGER_USER=hadoop
22.	" >> /home/hadoop/.bashrc'
23.	source ~/.bashrc






# 5. Install Hadoop
24.	sudo wget  https://dlcdn.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz  /tmp
25.	sudo tar -xzf /tmp/hadoop-3.3.6.tar.gz -C /usr/local/ 
26.	sudo mv /usr/local/hadoop-3.3.6 /usr/local/hadoop
27.	sudo rm -f /tmp/hadoop-3.3.6.tar.gz
28.	sudo chown -R hadoop:hadoop /usr/local/hadoop
29.	sudo chmod -R 755 /usr/local/Hadoop
	nano /usr/local/hadoop/etc/hadoop/core-site.xml
nano /usr/local/hadoop/etc/hadoop/hdfs-site.xml 
nano /usr/local/hadoop/etc/hadoop/mapred-site.xml
nano /usr/local/hadoop/etc/hadoop/yarn-site.xml	
nano /usr/local/hadoop/etc/hadoop/hadoop-env.sh


# 6. Install ZooKeeper
31.	sudo wget https://archive.apache.org/dist/zookeeper/zookeeper-3.6.3/apache-zookeeper-3.6.3-bin.tar.gz -P /tmp
32.	sudo tar -xvf /tmp/apache-zookeeper-3.6.3-bin.tar.gz -C /usr/local/
33.	sudo mv /usr/local/apache-zookeeper-3.6.3-bin /usr/local/zookeeper
34.	sudo rm -f /tmp/apache-zookeeper-3.6.3-bin.tar.gz
35.	sudo chown -R hadoop:hadoop /usr/local/zookeeper
36.	sudo chmod -R 755 /usr/local/zookeeper
37.	sudo mkdir -p /usr/local/zookeeper/data
38.	sudo chown -R hadoop:hadoop /usr/local/zookeeper/data
39.	sudo touch /usr/local/zookeeper/data/myid
40.	cp zoo_sample.cfg  /usr/local/zookeeper/zoo.cfg
41.	nano /usr/local/zookeeper/zoo.cfg

# 7. Grant sudo access to hadoop user
echo "hadoop ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers
# 8. Setup SSH
sudo mkdir -p /var/run/sshd
sudo -u hadoop ssh-keygen -t rsa -f /home/hadoop/.ssh/id_rsa -N ""
sudo -u hadoop cat /home/hadoop/.ssh/id_rsa.pub >> /home/hadoop/.ssh/authorized_keys
sudo chmod 600 /home/hadoop/.ssh/authorized_keys

# 9. Create Hadoop directories
sudo mkdir -p /usr/local/hadoop/yarn_data/hdfs/{namenode,datanode,journalnode}
sudo chown -R hadoop:hadoop /usr/local/hadoop/yarn_data
sudo chmod -R 755 /usr/local/hadoop/yarn_data


# 10. Format HDFS
sudo -u hadoop /usr/local/hadoop/bin/hdfs namenode -format

# 11. Start services
ZooKeeper → JournalNodes → NameNode format → Start other services on one node 
ZooKeeper → JournalNodes → Standby format → Start other services on one node 



echo "YAY 😊Hadoop and ZooKeeper setup complete!"




