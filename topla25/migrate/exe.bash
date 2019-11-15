#!/bin/bash
cd ~/html/project/ezplatform/vendor/ezsystems/ezpublish-kernel/data/update/mysql;
mysql -u root -pezplatform -h db ezplatform < dbupdate-5.4.0-to-6.13.0.sql
mysql -u root -pezplatform -h db ezplatform < dbupdate-6.13.3-to-6.13.4.sql
mysql -u root -pezplatform -h db ezplatform < dbupdate-7.1.0-to-7.2.0.sql
mysql -u root -pezplatform -h db ezplatform < dbupdate-7.2.0-to-7.3.0.sql
mysql -u root -pezplatform -h db ezplatform < dbupdate-7.4.0-to-7.5.0.sql
mysql -u root -pezplatform -h db ezplatform < dbupdate-7.5.2-to-7.5.3.sql
mysql -u root -pezplatform -h db ezplatform < dbupdate-7.5.4-to-7.5.5.sql
cd ~/html/project
mysql -u root -pezplatform -h db ezplatform < ezplatform/vendor/ezsystems/date-based-publisher/bundle/Resources/install/datebasedpublisher_scheduled_version.sql
mysql -u root -pezplatform -h db ezplatform < ezplatform/vendor/ezsystems/flex-workflow/bundle/Resources/install/flex_workflow.sql
mysql -u root -pezplatform -h db ezplatform < ezplatform/vendor/ezsystems/ezplatform-workflow/src/bundle/Resources/install/schema.sql
cd ~/html/project/ezplatform
php -d memory_limit=1536M bin/console ezxmltext:convert-to-richtext --export-dir=ezxmltext-export --export-dir-filter=notice,warning,error --concurrency 4 -v
php bin/console ezplatform:migrate:legacy_matrix --force
php bin/console ezplatform:solr_create_index
php bin/console cache:clear --env=dev
php bin/console cache:pool:clear cache.redis
