#!/usr/bin/env bash
#
#
# (Sichern der Daten aus der beehive-Datenbank als XML nach git)

set -e
set -x

export PATH=$PATH:/usr/local/bin:/usr/local/git/bin
export CLASSPATH=$CLASSPATH:$HOME/Library/saxon/saxon9he.jar

#### in welchem Verzeichnis muß dieses Skript gestartet werden?   : 
#### von welchem User?   : ubuntu
#### mit welchen git-credentials?   : 

ini="$(dirname $0)/../environment.ini"
repo=$(sed -n 's/.*repo *= *\([^ ]*.*\)/\1/p' < $ini)
log="$repo/dump/dump.log"

if [[ -f $log ]]  ### vorhandenes log umbenennen:
   then mv $log ${log}.old
fi

echo "uid=`whoami`  pwd=`pwd`  ini=$ini  repo=$repo  log=$log"  ### Verbosity

date --iso=s > $log

echo "---- initialize: This is $0 running as $USER on $HOST in $PWD" >> $log
echo "PATH: $PATH" >> $log
echo "CLASSPATH: $CLASSPATH" >> $log

today=`date +%Y.%m.%d`   ### Warum nicht date --iso ? wird das log automatisch ausgewertet später?
sql="$repo/dump/dump.sql"
xml="$repo/dump/dump.xml"
database=$(sed -n 's/.*database *= *\([^ ]*.*\)/\1/p' < $ini)
user=$(sed -n 's/.*user *= *\([^ ]*.*\)/\1/p' < $ini)
gloin=$(sed -n 's/.*password *= *\([^ ]*.*\)/\1/p' < $ini)

echo "today: $today" >> $log  ### Diese 5 Echos passen auf eine Zeile.
echo "sql: $sql" >> $log
echo "xml: $xml" >> $log
echo "database: $database" >> $log
echo "user: $user" >> $log

sudo -i -u ubuntu
echo "user: $user" ### Verbosity

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

date --iso=s >> $log  ### Tipp: Das Kommando 'time <name of command or script>' zeigt auch die benötigte Zeit an.

cat $log ### Verbosity

logout  ### logout again after sudo -i
