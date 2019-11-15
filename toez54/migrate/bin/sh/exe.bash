#!/bin/bash
set -e # abort on error

START_TIME=$SECONDS;

current_sh_dir=$(cd -P -- "$(dirname -- "$0")" && pwd -P); # get the current sh directory including restructure.sh file
. $current_sh_dir/config.bash; # get config file provided in same folder that contains the current restruture.sh file
echo -e $YELLOW"Do you want to run migration from eZ Publish 4.7 to eZ Publish Platform 5.4 (y/n)?"$RESET_COLOR;
read run_47_to_54;
if [ "$run_47_to_54" != "${run_47_to_54#[Yy]}" ]
then
    echo -e $YELLOW"Do you want to reset database with this one $ORIGINAL_DB (y/n)?"$RESET_COLOR;
    read run_reset_database;
    if [ "$run_reset_database" != "${run_reset_database#[Yy]}" ]
    then
        echo "gunzip < $ORIGINAL_DB | mysql -u $EZPUBLISH_54_DB_USER -p$EZPUBLISH_54_DB_PASSWORD -h $EZPUBLISH_54_DB_HOST $EZPUBLISH_54_DB_NAME" ;
        gunzip < $ORIGINAL_DB | mysql -u $EZPUBLISH_54_DB_USER -p$EZPUBLISH_54_DB_PASSWORD -h $EZPUBLISH_54_DB_HOST $EZPUBLISH_54_DB_NAME ;
        echo "Database reset OK" ;
    fi

    echo -e $YELLOW"Migration path from eZ Publish 4.7 to eZ Publish Platform 5.4"$RESET_COLOR;
    echo "cd $EZPUBLISH_54_ROOT";
    cd "$EZPUBLISH_54_ROOT";
    echo "cd ezpublish_legacy";
    cd ezpublish_legacy;
    echo "You are here `pwd`";

    echo -e $YELLOW"Execute clean Scripts"$RESET_COLOR;
    for i in "${EZPUBLISH_54_DB_CLEAN[@]}"
    do
        echo "$PHP_5_CLI $i" ;
        $PHP_5_CLI $i;
    done

    echo -e $YELLOW"Execute Common Script"$RESET_COLOR;
    for i in "${EZPUBLISH_54_SCRIPT_UPDATE_FILE_COMMON[@]}"
    do
        echo "$PHP_5_CLI $i" ;
        $PHP_5_CLI $i;
    done

    echo -e $YELLOW"Migrate database from eZ Publish 4.7 to 5.1"$RESET_COLOR;
    for i in "${EZPUBLISH_54_DB_UPDATE_FILE_TO_51[@]}"
    do
        echo "mysql -u $EZPUBLISH_54_DB_USER -p$EZPUBLISH_54_DB_PASSWORD -h $EZPUBLISH_54_DB_HOST $EZPUBLISH_54_DB_NAME < $i";
        mysql -u $EZPUBLISH_54_DB_USER -p$EZPUBLISH_54_DB_PASSWORD -h $EZPUBLISH_54_DB_HOST $EZPUBLISH_54_DB_NAME < $i ;
    done

    echo -e $YELLOW"Execute Script from eZ Publish 4.7 to 5.1"$RESET_COLOR;
    for i in "${EZPUBLISH_54_SCRIPT_UPDATE_FILE_TO_51[@]}"
    do
        echo "$PHP_5_CLI $i" ;
        $PHP_5_CLI $i;
    done

    echo -e $YELLOW"Migrate database from eZ Publish 5.1 to 5.4"$RESET_COLOR;
    for i in "${EZPUBLISH_54_DB_UPDATE_FILE_TO_54[@]}"
    do
        echo "mysql -u $EZPUBLISH_54_DB_USER -p$EZPUBLISH_54_DB_PASSWORD -h $EZPUBLISH_54_DB_HOST $EZPUBLISH_54_DB_NAME < $i";
        mysql -u $EZPUBLISH_54_DB_USER -p$EZPUBLISH_54_DB_PASSWORD -h $EZPUBLISH_54_DB_HOST $EZPUBLISH_54_DB_NAME < $i ;
    done

    echo -e $YELLOW"Execute Script from eZ Publish 5.1 to 5.4"$RESET_COLOR;
    for i in "${EZPUBLISH_54_SCRIPT_UPDATE_FILE_TO_54[@]}"
    do
        echo "$PHP_5_CLI $i" ;
        $PHP_5_CLI $i;
    done

    echo -e $YELLOW"Execute specific sql script"$RESET_COLOR;
    echo "cd $EZPUBLISH_54_ROOT";
    cd "$EZPUBLISH_54_ROOT";
    for i in "${SQL_TO_54[@]}"
    do
        echo "mysql -u $EZPUBLISH_54_DB_USER -p$EZPUBLISH_54_DB_PASSWORD -h $EZPUBLISH_54_DB_HOST $EZPUBLISH_54_DB_NAME < $i";
        mysql -u $EZPUBLISH_54_DB_USER -p$EZPUBLISH_54_DB_PASSWORD -h $EZPUBLISH_54_DB_HOST $EZPUBLISH_54_DB_NAME < $i ;
        $PHP_5_CLI $i;
    done

    echo -e $YELLOW"Dump database with the new one"$RESET_COLOR;
    echo "mysqldump -u $EZPUBLISH_54_DB_USER -p$EZPUBLISH_54_DB_PASSWORD -h $EZPUBLISH_54_DB_HOST $EZPUBLISH_54_DB_NAME | gzip > $DB_DUMP" ;
    mysqldump -u $EZPUBLISH_54_DB_USER -p$EZPUBLISH_54_DB_PASSWORD -h $EZPUBLISH_54_DB_HOST $EZPUBLISH_54_DB_NAME | gzip > $DB_DUMP ;
    echo "Database dump OK";

    echo -e $GREEN"Upgrade to 5.4 OK"$RESET_COLOR;
    echo "-----------------------------------------------------------------------------------------------------------------------";

fi

echo -e $YELLOW"Do you want to run migration from eZ Publish Platform 5.4 to platform 2.5  (y/n)?"$RESET_COLOR;
read run_54_to_25;
if [ "$run_54_to_25" != "${run_54_to_25#[Yy]}" ]
then
    echo -e $YELLOW"Running 5.4 to 2.5"$RESET_COLOR;
else
    echo -e $YELLOW"Ok bye"$RESET_COLOR;
fi

ELAPSED_TIME=$(($SECONDS - $START_TIME));
echo -e $YELLOW"DURATION: $(($ELAPSED_TIME/60)) min $(($ELAPSED_TIME%60)) sec"$RESET_COLOR;

exit;
