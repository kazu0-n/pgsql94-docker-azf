!/bin/sh -eu

ENV_FILE=/etc/sysconfig/azfile_env

AZF_NAME=$(curl -s https://your-host-name/AZF_NAME.txt)
AZF_PASS=$(curl -s https://your-host-name/AZF_PASS.txt)

AZFENV="username=$AZF_NAME\npassword=$AZF_PASS"
echo -e $AZFENV > $ENV_FILE
