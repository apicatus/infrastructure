#!/bin/bash

# Autodeploy Script
watch () {
    APPNAME=$1                                    # App Name
    WATCHDIR=/var/deploy/$APPNAME                 # Watch changes in this directory
    PRFIX=$APPNAME.tar.gz                         # prefix to watch for
    LOGFILE=/var/log/autodeploy.$APPNAME.log      # Log File
    PIDFILE=/var/run/autodeploy.$APPNAME.pid      # PID File
    RUNCMD=./deploy.$APPNAME.sh                   # What to call when changes happen

    # Run Watcher
    inoticoming --foreground --logfile $LOGFILE --pid-file $PIDFILE $WATCHDIR --prefix $PRFIX --stderr-to-log $RUNCMD $WATCHDIR/{} \;
}

APPLICATIONS="landing backend"

for APP in $APPLICATIONS
do
    echo "Watching: " $APP
    watch $APP
done







