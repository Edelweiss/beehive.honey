-- IMPORT_SQL
UPDATE hgv SET bl = CONCAT(bl, IF(bl IS NULL OR bl = '', '', '; '), 'XIII, S. 2') WHERE hgvId = '28310';
UPDATE hgv SET bl = CONCAT(bl, IF(bl IS NULL OR bl = '', '', '; '), 'XIII, S. 213') WHERE hgvId = '14599';