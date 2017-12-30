#!/bin/bash
#set -euo pipefail

exec /usr/local/bin/sqitch --engine pg -u $DATABASE_USERNAME -h $DATABASE_HOST -d $DATABASE_NAME $1
