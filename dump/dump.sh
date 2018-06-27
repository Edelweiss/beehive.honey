#!/usr/bin/env bash

export PATH=$PATH:/usr/local/bin:/usr/local/git/bin
export CLASSPATH=$CLASSPATH:$HOME/Library/saxon/saxon9he.jar

ini="$(dirname $0)/dump.ini"
repo=$(sed -n 's/.*repo *= *\([^ ]*.*\)/\1/p' < $ini)
log="$repo/dump/dump.log"

echo $log

date > $log

echo "---- initialise" >> $log

echo "PATH: $PATH" >> $log
echo "CLASSPATH: $CLASSPATH" >> $log

today=`date +%Y.%m.%d`
sql="$repo/dump/dump.sql"
xml="$repo/dump/dump.xml"
database=$(sed -n 's/.*database *= *\([^ ]*.*\)/\1/p' < $ini)
user=$(sed -n 's/.*user *= *\([^ ]*.*\)/\1/p' < $ini)
gloin=$(sed -n 's/.*password *= *\([^ ]*.*\)/\1/p' < $ini)

echo "today: $today" >> $log
echo "sql: $sql" >> $log
echo "xml: $xml" >> $log
echo "database: $database" >> $log
echo "user: $user" >> $log

echo "---- git fetch" >> $log
git --git-dir "$repo/.git" fetch >> $log 2>&1
echo "---- git merge" >> $log
git --git-dir "$repo/.git" merge edelweiss/master >> $log 2>&1
echo "---- mysqldump sql" >> $log
mysqldump --single-transaction --password=$gloin --user=$user --ignore-table=$database.user $database > $sql
echo "---- mysqldump xml" >> $log
mysqldump --single-transaction --password=$gloin --user=$user --ignore-table=$database.user --xml $database > $xml
echo "---- git add" >> $log
cd $repo
git add dump >> $log 2>&1
echo "---- git commit" >> $log
git --git-dir "$repo/.git" commit -m "auto save $today" >> $log 2>&1
echo "---- git gc" >> $log
git --git-dir "$repo/.git" gc >> $log 2>&1
echo "---- git push" >> $log
git --git-dir "$repo/.git" push edelweiss master:master >> $log 2>&1

date >> $log

exit 0