-- IMPORT_SQL
UPDATE hgv SET bl = CONCAT(bl, IF(bl = '' OR bl IS NULL, '', '; '), 'XIII, S. 2') WHERE hgvId = '10031' AND bl NOT LIKE '%XIII, S.%';
UPDATE hgv SET bl = CONCAT(bl, IF(bl = '' OR bl IS NULL, '', '; '), 'XIII, S. 281/282') WHERE hgvId = '76333' AND bl NOT LIKE '%XIII, S.%';