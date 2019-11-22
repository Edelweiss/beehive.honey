dump
====

dump - this directory contains xml and sql data as retrieved from database via mysqldump 

post_publishing
===============

ACHTUNG: Folgende Skripte an die aktuell zu importierende BL-Nummer anpassen (z.B. 'XIII'):

* bl_bibliography_export.sql
* compilation_page_export.sql

After the print release the actual page numbers can be exported in order to import them into Aquila HGV (and then form there into FileMaker HGV and EpiDoc HGV)

(a) Go to

```
cd /Users/Admin/beehive.data/post_publishing
```

(b) and call script

```
./compilation_page_export_import.sh
```

(c) Import into FileMaker manually

see point (4) below

___

The script comprises the following steps:

(1) Export page numbers from production database **bl**

```
mysql -u bl -p < compilation_page_export.sql > compilation_page_import.sql
```

(2.1) Import into **Aquila HGV development**

```
mysql hgv_dev -u hgv -p < compilation_page_import.sql
```

(2.2) respectively, import into **Aquila HGV production**

```
mysql hgv -u hgv -p < compilation_page_import.sql
```

(3) update flag **blOnline** in the mysql database

```
mysql hgv -u hgv -p < hgv_blOnline_update.sql
```

(4) Export bl bibliography from mysql **hgv** (field **bl**)

```
mysql -u hgv -p hgv < bl_bibliography_export.sql > bl_bibliography_import.csv
```

(5) Manually import bl bibliography into **HGV FileMaker**

In

Menu > Ablage/File > Datensätze importieren/Import > Datei/From File

choose

```
bl_bibliography_import.csv
```

Dann verwende folgende Einstellungen:

* Passende Datensätz in Ergebnismenge akt.
* Ersten Datensatz ignorieren (enthält Feldname)
* TMNr_plus_texLett = Abgleichfeld
* BL = einziges Importfeld

Go!

Danach nicht vergessen, die Datensätze als aktualisiert zu markieren (Feld **last_modified**)

(6) Update HGV EpiDoc files from HGV FileMaker database

**AT THE MOMENT THIS IS ALL DONE MANUALLY and LOCALLY on elemmire's workstation!!!**

(6.1) Open **FileMaker export** the following fields:

* TMNr_plus_texLett
* BL
* blOnline

Use FMP XML file format for the export file.

(6.2) Run update xslt for EpiDoc

* update git repositories (master_readonly for input and xwalk for output)

```
cd ~/data/idp.data/papyri/master_readonly
git clean -nd
git clean -fd
git checkout .
git fetch papyri
git merge papyri/master
git gc
git status

cd ~/data/idp.data/papyri/xwalk
git clean -nd
git clean -fd
git checkout .
git fetch papyri
git merge papyri/master
git push papyri xwalk_ossiriand:xwalk
```

* place FMP xml file here

```
~/projects/idp.data/data/fmp.xml
```

* run script #52

DIESES SKRIPT MUSS NOCH ANGEPASST WERDEN, damit es sowohl neue Seitenzahlen und BL-Korrekturen als auch das BL-Online-Flag in EpiDoc schreibt

```
cd ~/projects/idp.data
java -Xms512m -Xmx1536m net.sf.saxon.Transform -l -o:052_updateEpiDocFromFmpOrCsv.csv -it:FMP -xsl:052_updateEpiDocFromFmpOrCsv.xsl
```
