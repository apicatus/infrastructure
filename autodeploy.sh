#!/bin/bash

# List of applications separated by spaces
APPLICATIONS="landing frontend"

# Start task by name
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
    inoticoming --foreground --logfile $LOGFILE --pid-file $PIDFILE $WATCHDIR --prefix $PRFIX --stderr-to-log --stdout-to-log $RUNCMD $WATCHDIR/{} \;
}

# Stop task by name
stop () {
    APPNAME=$1                                              # App Name
    PIDFILE=/var/run/apicatus/autodeploy.$APPNAME.pid       # PID File

    # Get rid of the pidfile, since Inoticoming won't do that.
    if [ -r "$PIDFILE" ] ; then
        kill -9 $(cat "$PIDFILE") || true
        rm -f "$PIDFILE"
    fi
}

watchall () {
    for APPNAME in $APPLICATIONS
    do
        echo "Watching: " $APPNAME
        watch $APPNAME
        RETVAL=$?
    done
}

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

restart() {
    echo "Restarting $NAME"
    stopall
    watchall
}

status() {
    echo "Status for $NAME:"
    # This is taking the lazy way out on status, as it will return a list of
    # all running Forever processes. You get to figure out what you want to
    # know from that information.
    #
    # On Ubuntu, this isn't even necessary. To find out whether the service is
    # running, use "service my-application status" which bypasses this script
    # entirely provided you used the service utility to start the process.

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
        status
        ;;
    restart)
        restart
        ;;
    *)
        echo "Usage: {start|stop|status|restart}"
        exit 1
        ;;
esac
exit $RETVAL










