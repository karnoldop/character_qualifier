#!/bin/bash

db="tpch.sqlite"
rm -f ${db}
touch ${db}

#sqlite3 ${db} < drop-tables.sql
sqlite3 ${db} < create-tables.sql
sqlite3 ${db} < queries.sql