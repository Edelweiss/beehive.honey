-- mysql -u bl -p < compilation_page_export.sql > compilation_page_import.sql

USE bl;

SELECT
  concat("UPDATE hgv SET bl = CONCAT(bl, IF(bl IS NULL OR bl = '', '', '; '), ", "'", compilation.title, ", S. ", compilationPage,"') WHERE hgvId = '", hgv, "';") AS '-- IMPORT_SQL'
FROM
  correction,
  compilation
WHERE 
  correction.compilation_id = compilation.id AND 
  compilation.title = 'XIII' AND
  hgv IS NOT NULL AND
  hgv != '' AND
  compilationPage IS NOT NULL 
ORDER BY
  CAST(compilationPage AS UNSIGNED);