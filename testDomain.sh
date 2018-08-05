#!/bin/bash
# tleite@bsd.com.br
# V0.1

SITESFILE=sites.txt # lista dos sites por linha
EMAILS="Email para alerta"

while read site; do
    if [ ! -z "${site}" ]; then
        
	    CURL=$( curl -sL -w "%{http_code}\\n" "$site" -o /dev/null)
        
        if echo $CURL | grep "200" > /dev/null
        then
            echo "The HTTP server on ${site} is up!"
        else    

            MESSAGE="This is an alert that your site ${site} has failed to respond 200 OK."

            for EMAIL in $(echo $EMAILS | tr "," " "); do
                SUBJECT="$site (http) Failed"
                echo "$MESSAGE" | mail -s "$SUBJECT" $EMAIL
                echo $SUBJECT
                echo "Alert sent to $EMAIL"
            done      
        fi
    fi
done < $SITESFILE
