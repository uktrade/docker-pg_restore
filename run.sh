#!/bin/bash -xe

env -
export $(cat /.env | xargs)

date

DATE=$(date +%Y-%m-%d)
aws s3 cp --only-show-errors $S3_BUCKET/$DATE.psql.tar /tmp/$DATE.psql.tar
pg_restore -h $DEST_PGHOST -U $DEST_PGUSER -d temp -x -O -c -C --if-exists -v $DUMP_PATH/$DATE.psql.tar
rm -f /tmp/$DATE.psql.tar
