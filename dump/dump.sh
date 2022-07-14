#!/usr/bin/env bash
#
# {Authors: Carmen Maria Lanz, Martin Hettich}
# (Sichern der Daten aus der beehive-Datenbank als XML nach git)
# (Soll als cronjob laufen, also _nur_im_Fehlerfall_ Ausgaben auf stdout oder stderr produzieren.)

### Preconditions:
#### in welchem Verzeichnis muß dieses Skript gestartet werden?   : egal, es wechselt => /home/ubuntu/beehive.honey
#### von welchem User?   : ubuntu
#### mit welchen git-credentials?   : ubuntu/.ssh

### Invariants:

### Postconditions:

set -e   ### DEBUGGING: Fail on any error! (AKA: exit immediately on non-zero return)
###set -x ### DEBUGGING: eXplizitly echo commands before executing (AKA: print command trace)

# check and set lock file or exit:
if [[ -f $(dirname $0)/dump-in-progress.lock ]]; then exit 1; fi
touch $(dirname $0)/dump-in-progress.lock


export PATH=$PATH:/usr/local/bin

ini="$(dirname $0)/../environment.ini" ### Ort von repo, Datenbankverbindungdaten
repo=$(sed -n 's/.*repo *= *\([^ ]*.*\)/\1/p' < $ini) ### Ort von beehive.honey, z.B. /home/ubuntu/beehive.honey
log="$repo/dump/dump.log"

if [[ -f $log ]]  ### vorhandenes Log umbenennen:
   then mv -f $log ${log}.old  ### noch älteres Log wird überschrieben.
fi

###!!!### Verbosity:
echo "---- initialize: This is $0 running as $(whoami) on $(hostname -f) in ${PWD}, with variables:  ini=$ini  repo=$repo  log=$log ."
###!!!###

### start new log file:
echo -e "---\nStarting log: $(date --iso=s)" > $log
echo "---- initialize: This is $0 running as $(whoami) on $(hostname -f) in ${PWD}," >> $log
echo "---- with variables:  ini=$ini  repo=$repo  log=$log" >> $log
echo "PATH: $PATH" >> $log
echo "CLASSPATH: $CLASSPATH" >> $log


today=`date --iso=s`
sql="$repo/dump/dump.sql"
xml="$repo/dump/dump.xml"
database=$(sed -n 's/.*database *= *\([^ ]*.*\)/\1/p' < $ini)
user=$(sed -n 's/.*user *= *\([^ ]*.*\)/\1/p' < $ini)
gloin=$(sed -n 's/.*password *= *\([^ ]*.*\)/\1/p' < $ini)

echo "---- and variables:  today: $today  sql: $sql  xml: $xml  database: $database  user: $user" >> $log


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

echo -e "Finishing log: $(date --iso=s)\n..." >> $log

# remove lock file:
rm -f $(dirname $0)/dump-in-progress.lock

exit 0
