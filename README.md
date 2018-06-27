# dump

dump - this directory contains xml and sql data as retrieved from database via mysqldump 

# post_publishing

ACHTUNG: Folgende Skripte an die aktuell zu importierende BL-Nummer anpassen (z.B. 'XIII'):

* bl_bibliography_export.sql
* compilation_page_export.sql

After the print release the actual page numbers can be exported in order to import them into Aquila HGV (and then form there into FileMaker HGV and EpiDoc HGV)

(a) Just go to

cd /Users/Admin/beehive.data/post_publishing

(b) and call script

./compilation_page_export_import.sh

(c) Import into FileMaker manually

see point (4) below

The script comprises the following steps:

(1) Export page numbers from production database ‘bl’

mysql -u bl -p < compilation_page_export.sql > compilation_page_import.sql

(2.1) Import into Aquila HGV development

mysql hgv_dev -u hgv -p < compilation_page_import.sql

(2.2) respectively, import into Aquila HGV production

mysql hgv -u hgv -p < compilation_page_import.sql

(3) Export bl bibliography from mysql HGV

mysql -u bl -p < bl_bibliography_export.sql > bl_bibliography_import.csv

(4) Manually import bl bibliography into HGV FileMaker

In

Menu > Ablage/File > Datensätze importieren/Import > Datei/From File

choose

bl_bibliography_import.csv

Dann

Bestehende Datensätze Abgleichen
Erste Zeile ignorieren, enthält Feldnamen
TMNr_plus_texLett = Abgleichfeld
BL = einziges Importfeld

Go!

Danach nicht vergessen, die Datensätze als aktualisiert zu markieren