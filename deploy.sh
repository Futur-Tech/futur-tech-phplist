#!/usr/bin/env bash

source "$(dirname "$0")/ft-util/ft_util_inc_var"

APP_NAME="futur-tech-phplist"
APP_SHORTNAME="ft-phplist"

ZBX_CONF_AGENT_D="/etc/zabbix/zabbix_agentd.conf.d"
BIN_DIR="/usr/local/bin/${APP_NAME}"
SRC_DIR="/usr/local/src/${APP_NAME}"
ETC_CONF="/usr/local/etc/${APP_SHORTNAME}.conf"
SUDOERS_ETC="/etc/sudoers.d/${APP_NAME}"


$S_LOG -d $S_NAME "Start $S_DIR_NAME/$S_NAME $*"


echo "
  INSTALL NEEDED FILES
------------------------------------------"

if [ ! -d "${ZBX_CONF_AGENT_D}" ] ; then mkdir "${ZBX_CONF_AGENT_D}" ; $S_LOG -s $? -d $S_NAME "Creating ${ZBX_CONF_AGENT_D} returned EXIT_CODE=$?" ; fi
if [ ! -d "${BIN_DIR}" ] ; then mkdir "${BIN_DIR}" ; $S_LOG -s $? -d $S_NAME "Creating ${BIN_DIR} returned EXIT_CODE=$?" ; fi

$S_DIR/ft-util/ft_util_file-deploy "$S_DIR/bin/" "${BIN_DIR}"
$S_DIR/ft-util/ft_util_file-deploy "$S_DIR/ft-util/ft_util_log" "${BIN_DIR}/ft_util_log"
$S_DIR/ft-util/ft_util_file-deploy "$S_DIR/ft-util/ft_util_inc_var" "${BIN_DIR}/ft_util_inc_var"

cp "$S_DIR_PATH/etc.cron.d/${APP_NAME}" "/etc/cron.d/${APP_NAME}"
$S_LOG -s $? -d $S_NAME "> /etc/cron.d/${APP_NAME}"


echo "
  INSTALL/UPDATE CONF FILE
------------------------------------------"

$S_DIR/ft-util/ft_util_conf-update -s "$S_DIR/etc/${APP_SHORTNAME}.conf" -d "$ETC_CONF"




###############################################
# For when Zabbix monitoring script is ready
#

# $S_DIR/ft-util/ft_util_file-deploy "$S_DIR/etc.zabbix/${APP_NAME}.conf" "${ZBX_CONF_AGENT_D}/${APP_NAME}.conf"

# echo "
#   SETUP SUDOERS FILE
# ------------------------------------------"

# $S_LOG -d $S_NAME -d "$SUDOERS_ETC" "==============================="
# $S_LOG -d $S_NAME -d "$SUDOERS_ETC" "==== SUDOERS CONFIGURATION ===="
# $S_LOG -d $S_NAME -d "$SUDOERS_ETC" "==============================="

# echo "Defaults:zabbix !requiretty" | sudo EDITOR='tee' visudo --file=$SUDOERS_ETC &>/dev/null
# echo "zabbix ALL=(ALL) NOPASSWD:${SRC_DIR}/deploy-update.sh" | sudo EDITOR='tee -a' visudo --file=$SUDOERS_ETC &>/dev/null

# cat $SUDOERS_ETC | $S_LOG -d "$S_NAME" -d "$SUDOERS_ETC" -i 

# $S_LOG -d $S_NAME -d "$SUDOERS_ETC" "==============================="
# $S_LOG -d $S_NAME -d "$SUDOERS_ETC" "==============================="

# echo "
#   RESTART ZABBIX LATER
# ------------------------------------------"

# echo "service zabbix-agent restart" | at now + 1 min &>/dev/null ## restart zabbix agent with a delay
# $S_LOG -s $? -d "$S_NAME" "Scheduling Zabbix Agent Restart"

$S_LOG -d "$S_NAME" "End $S_NAME"

echo "
------------------------------------------
        --------------------------
                ----------
"
exit
