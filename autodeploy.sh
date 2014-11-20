#!/bin/bash

# List of applications separated by spaces
APPLICATIONS="landing frontend"

###############################################################################
# Start task by name                                                          #
###############################################################################
watch () {
    APPNAME=$1                                              # App Name
    WATCHDIR=/var/deploy/$APPNAME                           # Watch changes in this directory
    PRFIX=$APPNAME.tar.gz                                   # prefix to watch for
    LOGFILE=/var/log/apicatus/autodeploy.$APPNAME.log       # Log File
    PIDFILE=/var/run/apicatus/autodeploy.$APPNAME.pid       # PID File
    RUNCMD=./deploy.$APPNAME.sh                             # What to call when changes happen

    touch $LOGFILE
    touch $PIDFILE

    # Run Watcher
    inoticoming --logfile $LOGFILE --pid-file $PIDFILE $WATCHDIR --prefix $PRFIX --stderr-to-log --stdout-to-log $RUNCMD $WATCHDIR/{} \;
    return $?
}

###############################################################################
# Stop task by name                                                           #
###############################################################################
stop () {
    APPNAME=$1                                              # App Name
    PIDFILE=/var/run/apicatus/autodeploy.$APPNAME.pid       # PID File

    # Get rid of the pidfile, since Inoticoming won't do that.
    if [ -r "$PIDFILE" ] ; then
        kill -9 $(cat "$PIDFILE") || true
        rm -f "$PIDFILE"
        return $?
    fi
}
###############################################################################
# Watch all applications                                                      #
###############################################################################
watchall () {
    for APPNAME in $APPLICATIONS
    do
        echo "Watching: " $APPNAME
        watch $APPNAME
        RETVAL=$?
    done
}
###############################################################################
# Stop all applications                                                       #
###############################################################################
stopall () {
    for APPNAME in $APPLICATIONS
    do
        PIDFILE=/var/run/apicatus/autodeploy.$APPNAME.pid
        if [ -f $PIDFILE ]; then
            echo "Stopping: " $APPNAME
            stop $APPNAME
            RETVAL=$?
        else
            echo "$APPNAME is not running."
            RETVAL=0
        fi
    done
}

###############################################################################
# Restart all tasks                                                           #
###############################################################################
restartall() {
    echo "Restarting $NAME"
    stopall
    watchall
}

###############################################################################
# Status
###############################################################################
statusall() {
    for APPNAME in $APPLICATIONS
    do
        PIDFILE=/var/run/apicatus/autodeploy.$APPNAME.pid
        if [ -f $PIDFILE ]; then
            ps -ef | grep $PIDFILE
            RETVAL=$?
        else
            echo "$APPNAME is not running."
            RETVAL=0
        fi
    done
    RETVAL=$?
}

case "$1" in
    start)
        watchall
        ;;
    stop)
        stopall
        ;;
    status)
        statusall
        ;;
    restart)
        restartall
        ;;
    *)
        echo "Usage: {start|stop|status|restart}"
        exit 1
        ;;
esac
exit $RETVAL
