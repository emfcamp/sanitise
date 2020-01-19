--

SET search_path TO mediawiki;

BEGIN;
DELETE FROM ip_changes;
DELETE FROM ipblocks;
UPDATE mwuser SET 
	user_real_name = NULL, 
	user_password = NULL, 
	user_newpassword = NULL, 
	user_email = NULL;
UPDATE recentchanges SET rc_ip = NULL;
DELETE FROM user_newtalk;
DELETE FROM user_properties;

UPDATE pagecontent SET
	old_text = regexp_replace(old_text, 
			'[a-zA-Z0-9_.+\-]+@[a-zA-Z0-9\-]+\.[a-zA-Z0-9\-.]+',
			'[email address removed]',
			'g')
	WHERE old_flags = 'utf-8';

SELECT 'Warning: some pages are not stored in plaintext and will not be sanitised for email addresses' AS warning
	WHERE (SELECT count(distinct old_flags) FROM pagecontent WHERE old_flags != 'utf-8') > 0;
COMMIT;
