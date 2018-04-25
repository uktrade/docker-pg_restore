#!/bin/bash -xe

env -
export $(cat /.env | xargs)

date

DATE=$(date +%Y-%m-%d -d "yesterday")
aws s3 cp --only-show-errors $S3_BUCKET/$DATE.psql.tar /tmp/$DATE.psql.tar
echo "SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = '$PGDATABASE' AND pid <> pg_backend_pid();" | psql -h $PGHOST -U $PGUSER
pg_restore -h $PGHOST -U $PGUSER -d $PGDATABASE -x -O -c -C --if-exists -v /tmp/$DATE.psql.tar
rm -f /tmp/$DATE.psql.tar
