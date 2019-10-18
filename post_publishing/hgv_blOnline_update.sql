-- mysql hgv -u hgv -p < hgv_blOnline_update.sql

UPDATE hgv SET blOnline = 0;
UPDATE hgv h INNER JOIN (SELECT DISTINCT hgv FROM bl.bl WHERE hgv IS NOT NULL) b ON h.hgvId = b.hgv SET h.blOnline = 1;
