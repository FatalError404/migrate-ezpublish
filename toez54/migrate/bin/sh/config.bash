#!/bin/bash

# ENVIRONMENTAL PARAMETERS
ENV="develop"

# Dump process to prvide the original database to work with
ORIGINAL_DB="/home/jmo/sites/csm_ezp_54/ezpublish_legacy/dump/prod.sql.gz"
DB_DUMP="/home/jmo/sites/csm_ezp_54/ezpublish_legacy/data/ezplatform.sql.gz"

# 5.4 settings
PHP_5_CLI="php5.6"
EZPUBLISH_54_ROOT="/home/jmo/sites/csm_ezp_54" # path to ezpublish leagcy folder from $HOME
EZPUBLISH_54_DB_HOST="localhost"
EZPUBLISH_54_DB_NAME="csm_ezp_54"
EZPUBLISH_54_DB_USER="csm_ezp"
EZPUBLISH_54_DB_PASSWORD="csm_ezp"

# clean script
EZPUBLISH_54_DB_CLEAN=( "bin/php/trashpurge.php" "bin/php/ezcache.php --clear-all --purge" )

# update common
EZPUBLISH_54_SCRIPT_UPDATE_FILE_COMMON=( "update/common/scripts/cleanup.php all" "update/common/scripts/updatecontentobjectname.php"  )

# Update to 5.1
EZPUBLISH_54_DB_UPDATE_FILE_TO_51=( "update/database/mysql/5.0/dbupdate-4.7.0-to-5.0.0.sql" "update/database/mysql/5.1/dbupdate-5.0.0-to-5.1.0.sql" )
EZPUBLISH_54_SCRIPT_UPDATE_FILE_TO_51=( "update/common/scripts/5.0/deduplicatecontentstategrouplanguage.php" "update/common/scripts/5.0/restorexmlrelations.php" "update/common/scripts/5.0/disablesuspicioususers.php --disable" "update/common/scripts/5.1/fiximagesoutsidevardir.php"  )

# Update to 5.4
EZPUBLISH_54_DB_UPDATE_FILE_TO_54=( "update/database/mysql/5.2/dbupdate-5.1.0-to-5.2.0.sql" "update/database/mysql/5.3/dbupdate-5.2.0-to-5.3.0.sql" "update/database/mysql/5.4/dbupdate-5.3.0-to-5.4.0.sql"  )
EZPUBLISH_54_SCRIPT_UPDATE_FILE_TO_54=( "update/common/scripts/5.2/cleanupdfscache.php" "update/common/scripts/5.3/recreateimagesreferences.php" "update/common/scripts/5.3/updatenodeassignmentparentremoteids.php -n"  )

# Specific sql script path to run during the migration path
SQL_TO_54=( "migrate/sql/clean.54.sql" )

# FOLLOWING SH CONSTANT USED TO DESIGN THE COMMAND LINE (do not modify them)
RESET_COLOR='\033[0m' # RESET
# Regular Colors
RED='\033[0;31m'          # RED
BLACK='\033[0;30m'        # BLACK
GREEN='\033[0;32m'        # Green
YELLOW='\033[0;33m'       # Yellow
BLUE='\033[0;34m'         # Blue
PURPLE='\033[0;35m'       # Purple
CYAN='\033[0;36m'         # Cyan
WHITE='\033[0;37m'        # White
# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGREEN='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBLUE='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White
# Underline
UBLACK='\033[4;30m'       # Black
URed='\033[4;31m'         # Red
UGREEN='\033[4;32m'       # Green
UYellow='\033[4;33m'      # Yellow
UBlue='\033[4;34m'        # Blue
UPurple='\033[4;35m'      # Purple
UCyan='\033[4;36m'        # Cyan
UWHITE='\033[4;37m'       # White
# Background
On_Black='\033[40m'       # Black
On_Red='\033[41m'         # Red
On_Green='\033[42m'       # Green
On_Yellow='\033[43m'      # Yellow
ON_BLUE='\033[44m'        # Blue
ON_PURPLE='\033[45m'      # Purple
ONCYAN='\033[46m'        # Cyan
ONWHITE='\033[47m'       # White
# High Intensity
IBLACK='\033[0;90m'       # Black
IRed='\033[0;91m'         # Red
IGreen='\033[0;92m'       # Green
IYellow='\033[0;93m'      # Yellow
IBLUE='\033[0;94m'        # Blue
IPurple='\033[0;95m'      # Purple
ICyan='\033[0;96m'        # Cyan
IWhite='\033[0;97m'       # White
# Bold High Intensity
BIBlack='\033[1;90m'      # Black
BIRed='\033[1;91m'        # Red
BIGreen='\033[1;92m'      # Green
BIYellow='\033[1;93m'     # Yellow
BIBlue='\033[1;94m'       # Blue
BIPurple='\033[1;95m'     # Purple
BICyan='\033[1;96m'       # Cyan
BIWhite='\033[1;97m'      # White
# High Intensity backgrounds
On_IBlack='\033[0;100m'   # Black
On_IRed='\033[0;101m'     # Red
On_IGreen='\033[0;102m'   # Green
On_IYellow='\033[0;103m'  # Yellow
On_IBlue='\033[0;104m'    # Blue
On_IPurple='\033[0;105m'  # Purple
On_ICyan='\033[0;106m'    # Cyan
On_IWhite='\033[0;107m'   # White
