## Features

- MongoDB Server Status metrics (*cursors, operations, indexes, storage, etc*)
- MongoDB Replica Set metrics (*members, ping, replication lag, etc*)
- MongoDB Replication Oplog metrics (*size, length in time, etc*)
- MongoDB Sharding metrics (*shards, chunks, db/collections, balancer operations*)
- MongoDB RocksDB storage-engine metrics (*levels, compactions, cache usage, i/o rates, etc*)
- MongoDB WiredTiger storage-engine metrics (*cache, blockmanger, tickets, etc*)


## Building and running

### Building

```bash
make
```


### Running

To define your own MongoDB URL, use environment variable `MONGODB_URL`. If set this variable takes precedence over `-mongodb.uri` flag.

To enable HTTP basic authentication, set environment variable `HTTP_AUTH` to user:password pair. Alternatively, you can
use YAML file with `server_user` and `server_password` fields.

```bash
export MONGODB_URL='mongodb://localhost:27017'
export HTTP_AUTH='user:password'
./mongodb_exporter <flags>
```

### Flags

See the help page with `-h`.

If you use [MongoDB Authorization](https://docs.mongodb.org/manual/core/authorization/), you must:

1. Create a user with '*clusterMonitor*' role and '*read*' on the '*local*' database, like the following (*replace username/password!*):

```js
db.getSiblingDB("admin").createUser({
    user: "mongodb_exporter",
    pwd: "s3cr3tpassw0rd",
    roles: [
        { role: "clusterMonitor", db: "admin" },
        { role: "read", db: "local" }
    ]
})
```

2. Set environment variable `MONGODB_URL` before starting the exporter:

```bash
export MONGODB_URL=mongodb://mongodb_exporter:s3cr3tpassw0rd@localhost:27017
```

## Note about how this works

Point the process to any mongo port and it will detect if it is a mongos, replicaset member, or stand alone mongod and return the appropriate metrics for that type of node. This was done to preent the need to an exporter per type of process.
