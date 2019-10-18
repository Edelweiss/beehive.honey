#!/usr/bin/env bash

today=`date +%Y.%m.%d`

ini="$(dirname $0)/../environment.ini"

database_bl=$(sed -n 's/.*database *= *\([^ ]*.*\)/\1/p' < $ini)
user_bl=$(sed -n 's/.*user *= *\([^ ]*.*\)/\1/p' < $ini)
gloin_bl=$(sed -n 's/.*password *= *\([^ ]*.*\)/\1/p' < $ini)

database_hgv=$(sed -n 's/.*database_hgv *= *\([^ ]*.*\)/\1/p' < $ini)
user_hgv=$(sed -n 's/.*user_hgv *= *\([^ ]*.*\)/\1/p' < $ini)
gloin_hgv=$(sed -n 's/.*password_hgv *= *\([^ ]*.*\)/\1/p' < $ini)

echo "today: $today"
echo "database bl: $database_bl"
echo "user bl: $user_bl"
echo "database hgv: $database_hgv"
echo "user hgv: $user_hgv"

echo "---- export compilation page from bl mysql"
#mysql -u $user_bl --password=$gloin_bl < compilation_page_export.sql > compilation_page_import.sql
# nach diesem Schritt anhalten, um das Ergebnis auf Wohlgefaellingkeit zu ueberpruefen

echo "---- import compilation page into hgv mysql"
mysql $database_hgv -u $user_hgv --password=$gloin_hgv < compilation_page_import.sql

echo "---- update blOnline flag in hgv aquila"
mysql $database_hgv -u $user_hgv --password=$gloin_hgv < hgv_blOnline_update.sql

echo "---- export bl bibliography from hgv mysql"
mysql $database_hgv -u $user_hgv --password=$gloin_hgv < bl_bibliography_export.sql > bl_bibliography_import.csv

echo "---- import bl bibliography into hgv FileMaker"
echo "must be done manually, see README"

echo "---- import bl bibliography into hgv EpiDoc idp.data"
echo "YTBD"

exit 0