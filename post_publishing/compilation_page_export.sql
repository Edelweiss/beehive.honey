-- mysql -u bl -p < compilation_page_export.sql > compilation_page_import.sql

USE bl;

SELECT
  concat("UPDATE hgv SET bl = CONCAT(bl, IF(bl = '' OR bl IS NULL, '', '; '), ", "'", compilation, ", S. ", GROUP_CONCAT(DISTINCT page ORDER BY CAST(page AS UNSIGNED) SEPARATOR '/'),"') WHERE hgvId = '", hgv, "' AND bl NOT LIKE '%", compilation, ", S\.%';") AS '-- IMPORT_SQL'
FROM
  bl
WHERE 
  compilation = 'XIII' AND
  hgv IS NOT NULL AND
  hgv != '' AND
  description NOT LIKE CONCAT(CONVERT(UNHEX('E28692') USING UTF8), ' Nd.%') AND /* → Nd.% */
  description NOT LIKE '= %' AND
  page IS NOT NULL
GROUP BY
  hgv
ORDER BY
  CAST(page AS UNSIGNED);

/*


*/

/*

-- TEST resulting pages

SELECT `hgv`, ddb, CONCAT('XIII, S. ', GROUP_CONCAT(DISTINCT page ORDER BY CAST(page AS UNSIGNED) SEPARATOR '/'))
FROM `bl`
WHERE hgv IS NOT NULL
AND compilation = 'XIII'
AND description NOT LIKE '→ Nd\.%'
AND description NOT LIKE '= %'
GROUP BY hgv
ORDER BY CAST(page AS UNSIGNED)

*/