-- include here any unexpected data to deal with, that could interrupt the migration process
delete from ezimagefile where filepath like "/trashed%";
delete from ezimagefile where filepath like "%ccss_var%";
delete FROM `ezcontentobject_attribute` WHERE (`data_text` LIKE '%ccss_var%' OR `data_type_string` LIKE '%ccss_var%' OR `language_code` LIKE '%ccss_var%' OR `sort_key_string` LIKE '%ccss_var%');
