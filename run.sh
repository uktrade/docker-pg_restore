#!/bin/bash -x

env -
source /.env

export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
export AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION
export PGPASSWORD=$PGPASSWORD

date

DATE=$(date +%Y-%m-%d -d "yesterday")
aws s3 cp --only-show-errors $S3_BUCKET/$DATE.psql.tar /tmp/$DATE.psql.tar
echo "SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = '$PGDATABASE' AND pid <> pg_backend_pid();" | psql -h $PGHOST -U $PGUSER
pg_restore -h $PGHOST -U $PGUSER -d $PGDATABASE -x -O -c -C --if-exists -v /tmp/$DATE.psql.tar
rm -f /tmp/$DATE.psql.tar
