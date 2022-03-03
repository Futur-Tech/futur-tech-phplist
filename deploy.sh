#!/usr/bin/env bash

source "$(dirname "$0")/ft-util/ft_util_inc_var"

APP_NAME="futur-tech-phplist"
APP_SHORTNAME="ft-phplist"

BIN_DIR="/usr/local/bin/${APP_NAME}"
SRC_DIR="/usr/local/src/${APP_NAME}"
ETC_CONF="/usr/local/etc/${APP_SHORTNAME}.conf"
SUDOERS_ETC="/etc/sudoers.d/${APP_NAME}"


$S_LOG -d $S_NAME "Start $S_DIR_NAME/$S_NAME $*"


echo "
  INSTALL NEEDED FILES
------------------------------------------"

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

$S_LOG -d "$S_NAME" "End $S_NAME"

echo "
------------------------------------------
        --------------------------
                ----------
"
exit
