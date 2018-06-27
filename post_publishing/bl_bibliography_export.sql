-- mysql hgv -u hgv -p < bl_bibliography_export.sql > bl_bibliography_import.csv

SELECT
  concat(hgvId, ',"', bl, '"') as '"TMNr_plus_texLett",BL'
FROM
  `hgv`
WHERE
  bl LIKE '%XIII, %'