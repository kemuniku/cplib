#/usr/bin/bash
RESPONSE=$( \
    curl --silent https://api.dropbox.com/oauth2/token \
    --user ${DROPBOX_APP_KEY}:${DROPBOX_APP_SECRET} \
    --data grant_type=refresh_token \
    --data refresh_token=${DROPBOX_REFRESH_TOKEN} \
)
export DROPBOX_TOKEN=$(echo $RESPONSE | jq -r .access_token)
