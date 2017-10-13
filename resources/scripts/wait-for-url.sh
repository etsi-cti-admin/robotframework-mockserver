#!/bin/sh -e

host="$1"
shift
cmd="$@"

>&2 echo "wait-for-url.sh: checking status of URL ${host}"

until curl -s -o /dev/null "${host}"; do
    >&2 echo "wait-for-url.sh: waiting for URL ${host}"
    sleep 1
done

${cmd}
