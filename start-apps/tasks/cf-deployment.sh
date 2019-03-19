#!/usr/bin/env bash
set -x
COUNT=5

target="cf api $API_ENDPOINT --skip-ssl-validation"
#echo $target
eval $target

echo "Login....."
login="cf auth $USERNAME $PASSWORD"
#echo $login
eval $login

echo "Target Org and Space"
org_space="cf target -o $ORG -s $SPACE"
eval $org_space

applications=`cat pcflab/start-apps/app-list.json | jq -r '.[].application'`

echo "$CF_SUB_COMMAND the app"

for app in $applications
        do
                cf $CF_SUB_COMMAND $app
                for j in $COUNT
                do 
                         
                         STATUS=`cf app $app|grep -e "requested state:"|awk '{print  $3}'`
                         if [[ $STATUS == "stopped" ]]
                         then
                                echo -e "App is still down\n"
                                if [[ $j == $COUNT ]]
                                then
                                        echo "Triggering a mail to user :ravanaiah (ravanaiahweblogic@gail.com)"
                                        mail -s "automation to bring up app failed for $app app" ravanaiahweblogic@gmail.com <<< "automation to bring up this $app app got failed"
                                        break
                                fi
                                cf start $app
                                continue
                          else
                                echo "$i is up and running"
                                break
                          fi
                   done
          done         
                
