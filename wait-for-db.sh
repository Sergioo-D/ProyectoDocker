#!/bin/bash

set -e

host="$1"
shift
port="$1"
shift
cmd="$@"

until mysql -h "$host" -P "$port" -u"bogdanadmin" -p"n!H7Pm9~]w2CCy8?<|yB1apDc4[>BrdkC.#|zG5EQ" -e "SHOW DATABASES;"; do
  >&2 echo "MySQL is unavailable - sleeping"
  sleep 1
done

>&2 echo "MySQL is up - executing command"
exec $cmd
