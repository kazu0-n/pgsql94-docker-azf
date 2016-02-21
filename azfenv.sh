!/bin/sh -eu

ENV_FILE=/etc/sysconfig/azfile_env

AZF_NAME=$(curl -s https://s3-ap-northeast-1.amazonaws.com/dockerenv/AZF_NAME.txt)
AZF_PASS=$(curl -s https://s3-ap-northeast-1.amazonaws.com/dockerenv/AZF_PASS.txt)

AZFENV="username=$AZF_NAME\npassword=$AZF_PASS"
echo -e $AZFENV > $ENV_FILE