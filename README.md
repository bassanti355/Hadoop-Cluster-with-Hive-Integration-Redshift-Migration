# 🚀 Hadoop Cluster with Hive & Tez Integration + Redshift Migration (Dockerized)

This project sets up a complete Hadoop ecosystem with Hive, Tez, and PostgreSQL-backed metadata services using Docker. It is designed to simulate a production-grade environment that supports SQL-based data analytics, query optimization, and future integration with Amazon Redshift for migration or warehousing.

---

## 🧱 Architectural Overview

### 🔍 Goal
To build a fault-tolerant and modular Hadoop cluster where:
- Hive acts as the SQL engine,
- Tez acts as the execution layer for Hive queries,
- PostgreSQL stores Hive metadata externally for durability and sharing,
- Docker Compose orchestrates all services,
- And eventually Redshift or S3 can be added as analytical destinations.

### 🧩 Components Overview

| Component       | Role                                                                 |
|----------------|----------------------------------------------------------------------|
| **Hadoop (HDFS + YARN)** | Core distributed storage and processing layer                |
| **Hive Metastore**       | Stores metadata like table schemas, partitions, and database definitions |
| **HiveServer2**          | Accepts client connections (Beeline, JDBC tools) and executes queries |
| **Tez Engine**           | DAG-based fast processing engine for Hive queries            |
| **PostgreSQL**           | External RDBMS used by the metastore to persist metadata     |
| **Docker Compose**       | Spins up and wires containers: Hadoop, Hive, PostgreSQL, Tez |
| *(Optional)* Redshift    | Target for future data warehousing and analytics             |

---

### 📊 How They Work Together

#### 🔸 Hive Metastore and PostgreSQL
- Hive doesn't store data itself — it stores **metadata**: database names, table definitions, file locations, partition info.
- This metadata is represented internally as **Java objects**.
- **DataNucleus**, an ORM (Object Relational Mapper), translates these objects into SQL statements and persists them to **PostgreSQL** using **JDO API**.

> 💡 Think of it as a translator: Hive says "I created a table," and DataNucleus turns that into an `INSERT INTO TABLES` SQL statement in PostgreSQL.

---

#### 🔸 HiveServer2
- A **Thrift-based daemon** that exposes Hive as a service.
- Tools like **Beeline**, **DbVisualizer**, or any JDBC client connect to HiveServer2.
- It handles:
  - Authentication
  - Query parsing
  - Coordination with the Hive Metastore
  - Sending queries to Tez/YARN for execution

> HiveServer2 is the **gateway** to your data — without it, Hive cannot serve external clients.

---

#### 🔸 Execution Engine: Apache Tez
- Hive originally ran on MapReduce (slow, disk-based).
- Tez replaces that with **DAGs (Directed Acyclic Graphs)** of tasks that are optimized and executed in memory.
- Tez runs on **YARN**, and all Tez jars are stored in **HDFS (/apps/tez/)** so every container can access them.

> This makes Hive queries **much faster** and suitable for interactive workloads.

---

#### 🔸 Data Flow in a Typical Query
Client (Beeline / JDBC)
|
v
HiveServer2
|
v
Hive Metastore -----> PostgreSQL (Metadata retrieval)
|
v
HDFS/YARN + Tez (Query Execution on real data)


1. User submits a query via Beeline.
2. HiveServer2 parses the query, fetches table info from the metastore (which queries PostgreSQL).
3. HiveServer2 submits the job to Tez.
4. Tez runs tasks on the Hadoop cluster.
5. Results are returned to the client.

---

## 🧠 Why This Setup?

Traditional Hive deployments embed the metastore within Hive CLI or HiveServer2. That works for testing, but in real environments:

- You **need multiple Hive clients** to share the same metadata store.
- You **don’t want metadata loss** if a container is deleted.
- You want **reusability and modular deployment** (e.g., you might restart HiveServer2, but keep Metastore running).

Hence:
- Metastore is deployed as a **dedicated container**
- Metadata is persisted in **PostgreSQL**, not in-memory
- HiveServer2 and Metastore **communicate over Thrift**

---

## 🌍 Use Case: Redshift Migration

Eventually, this cluster can:
- Export data from Hive to **S3**
- Create **external tables** in **Amazon Redshift Spectrum**
- Or **migrate metadata** using Hive–Redshift mapping tools

This architecture is a **stepping stone** toward full hybrid cloud analytics.

---

## 🧱 Project Structure

/
├── docker-compose.yml # All containers wired together
├── hadoop/
│ ├── Dockerfile # Hadoop image setup
│ └── config/ # core-site.xml, hdfs-site.xml
├── hive/
│ ├── Dockerfile.hive # Hive + Tez installation
│ ├── hive-site.xml # Hive + JDBC configs
│ ├── tez-site.xml # Tez library references
├── postgres/
│ └── init.sql # Auto-creates metastore DB + user


## 📚 Learn More

- [Hive Metastore Architecture](https://hive.apache.org/docs/latest/adminmanual-metastore-3-administration_75978150/)
- [Apache Tez Installation](https://tez.apache.org/install.html)
- [DataNucleus ORM](https://www.datanucleus.org/)
- [Hive JDBC Drivers](https://cwiki.apache.org/confluence/display/Hive/HiveServer2+Clients)

---

