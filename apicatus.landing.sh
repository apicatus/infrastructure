#!/bin/bash
#
# An init.d script for running a Node.js process as a service using Forever as
# the process monitor. For more configuration options associated with Forever,
# see: https://github.com/nodejitsu/forever
#
# You will need to set the environment variables noted below to conform to
# your use case, and change the init info comment block.
#
# This was written for Debian distributions such as Ubuntu, but should still
# work on RedHat, Fedora, or other RPM-based distributions, since none
# of the built-in service functions are used. If you do adapt it to a RPM-based
# system, you'll need to replace the init info comment block with a chkconfig
# comment block.
#
### BEGIN INIT INFO
# Provides:             apicatus
# Required-Start:       $syslog $remote_fs
# Required-Stop:        $syslog $remote_fs
# Should-Start:         $local_fs
# Should-Stop:          $local_fs
# Default-Start:        2 3 4 5
# Default-Stop:         0 1 6
# Short-Description:    Apicatus Landing
# Description:          Apicatus Landing site
### END INIT INFO
#
### BEGIN CHKCONFIG INFO
# chkconfig: 2345 55 25
# description: Apicatus Landing site
### END CHKCONFIG INFO
#
# Based on:
# https://gist.github.com/3748766
# https://github.com/hectorcorrea/hectorcorrea.com/blob/master/etc/forever-initd-hectorcorrea.sh
# https://www.exratione.com/2011/07/running-a-nodejs-server-as-a-service-using-forever/
#
# Source function library. Note that this isn't used here, but remains to be
# uncommented by those who want to edit this script to add more functionality.
# Note that this is Ubuntu-specific. The scripts and script location are different on
# RPM-based distributions.
# . /lib/lsb/init-functions
#
# The example environment variables below assume that Node.js is
# installed into /home/node/local/node by building from source as outlined
# here:
# https://www.exratione.com/2011/07/running-a-nodejs-server-as-a-service-using-forever/
#
# It should be easy enough to adapt to the paths to be appropriate to a
# package installation, but note that the packages available for Ubuntu in
# the default repositories are far behind the times. Most users will be
# building from source to get a more recent Node.js version.
#
# An application name to display in echo text.
# NAME="My Application"
# The full path to the directory containing the node and forever binaries.
# NODE_BIN_DIR=/home/node/local/node/bin
# Set the NODE_PATH to the Node.js main node_modules directory.
# NODE_PATH=/home/node/local/node/lib/node_modules
# The directory containing the application start Javascript file.
# APPLICATION_DIRECTORY=/home/node/my-application
# The application start Javascript filename.
# APPLICATION_START=start-my-application.js
# Process ID file path.
# PIDFILE=/var/run/my-application.pid
# Log file path.
# LOGFILE=/var/log/my-application.log
#
NAME="Apicatus"
NODE_BIN_DIR="/usr/bin"
NODE_PATH="/usr/lib/node_modules"
APPLICATION_DIRECTORY="/var/www/landing"
APPLICATION_START="app.js"
PIDFILE="/var/run/apicatus/autostart.landing.pid"
LOGFILE="/var/log/apicatus/autostart.landing.log"
MIN_UPTIME=5000
SPIN_SLEEP_TIME=2000
#
# Decrypt Function
# Uses the ssh rsa key within your home directory
#
decrypt() {
    PUBLIC_KEY="~/.ssh/id_rsa"
    echo "$1" | openssl base64 -d -A | openssl rsautl -decrypt -inkey <(openssl rsa -in ~/.ssh/id_rsa -outform pem 2> /dev/null)
}

# Add node to the path for situations in which the environment is passed.
PATH=$NODE_BIN_DIR:$PATH
# Export all environment variables that must be visible for the Node.js
# application process forked by Forever. It will not see any of the other
# variables defined in this script.
export NODE_PATH=$NODE_PATH
export NODE_ENV=production
export MONGO_USER=$(decrypt "Y8ZyimnTiChprmvuAG6yi9EtWVbqLgvSgLy+LHrw5JJaM2NFtlhgwGtbYoQhGVMWj7+5EnqIu7LJr/OiEBqkwTW07CQmXpXcekU+FG862cWocrVcBCQxPwQcPENG16RbyzWKDWfP9bg6Js4U/B6gflguGOS0I/xXoJAWzLwVdKQfzn66rSGBV7TYXMXMqrcBfu+Swqa+SscJjkXxWz0EKu99/uLqWgojHSqYJdn1amUrjabclDbij8vO6HdxwPF4YkNjI3+t4HtKF7j4GgSotn+2Q9cd4GwjSqT2dwz9Sa2f9HUJA6L6BXgoi6o6RJeZJwnFHievRV76TOFuDgmlMw==")
export MONGO_PASS=$(decrypt "QSYmzbiFtX8JYr5z8GMQ0aH2EOIZ0//2UPBnROTcmnAF0OtMOsRXKpF3xsn7+jg1U+8JC3nwOdfc7Gv7+rSGPcOMms9XH64YQUQtnMLJDcPsmZIoKnyu2T0S8i6aL4qAPAkRrc0WXTUinL9CpMrvhmBqhWvGinLuoWjcaQGD1gZgWjpm/RnX/Nm3ViY+oEBaqvcDkppUYwxwy2R/JPBKsVTTBhBL1U/57Ehq3e6aiO+WjDreKW9regf6f/9q0hGcKYU41IHS6PKAE7zCADlGcTLGl1h3ImieKRhFuIWzbr1aT+++K19ptH379n4XNA+lO3NW3fMPg6cbV5j7cXG83A==")
export SECRET=$(decrypt "EwyYVOMLMrjUycg6wyWEZD3TnPEdxN46xCzI+XbR8OW+uid2s60DI8DHm3PVFjyWl4j/s8P1PNX8IDQZkyOl4ztnD9GCUkunn/1ILjFDzZWNfgNJCJmJNGpaaGQS6bsgJyUkNqYxLsHFv5ZJefcWufPEYftdGu8ZvaXOQhel5vL5RNMZzxEaNwWa8NyLsC4IAIW+K/Ayqr/W7RnjzWgoE+nzI+vMt2H03PDG1gnCf/WnVv9P8/4/QlQI2G2mWi5bENskHXzMceZUvji3SQKXUoXJHwijpD837aTkWHoxXpQ0kkxgKv1Eqzf856Xdn5MrvlBI06f4NYGcqEkzL+Mc9w==")

start() {
    echo "Starting $NAME"
    # We're calling forever directly without using start-stop-daemon for the
    # sake of simplicity when it comes to environment, and because this way
    # the script will work whether it is executed directly or via the service
    # utility.
    #
    # The minUptime and spinSleepTime settings stop Forever from thrashing if
    # the application fails immediately on launch. This is generally necessary to
    # avoid loading development servers to the point of failure every time
    # someone makes an error in application initialization code, or bringing down
    # production servers the same way if a database or other critical service
    # suddenly becomes inaccessible.
    #
    # The pidfile contains the child process pid, not the forever process pid.
    # We're only using it as a marker for whether or not the process is
    # running.
    #
    # Note that redirecting the output to /dev/null (or anywhere) is necessary
    # to make this script work if provisioning the service via Chef.
    touch $LOGFILE
    touch $PIDFILE

    forever \
        --pidFile $PIDFILE \
        --sourceDir $APPLICATION_DIRECTORY \
        -a \
        -l $LOGFILE \
        --minUptime $MIN_UPTIME \
        --spinSleepTime $SPIN_SLEEP_TIME \
        start $APPLICATION_START 2>&1 > /dev/null &
    RETVAL=$?
}

stop() {
    if [ -f $PIDFILE ]; then
        echo "Shutting down $NAME"
        # Tell Forever to stop the process.
        forever stopbypid $(cat $PIDFILE) 2>&1 > /dev/null
        # Get rid of the pidfile, since Forever won't do that.
        rm -f $PIDFILE
        RETVAL=$?
    else
        echo "$NAME is not running."
        RETVAL=0
    fi
}

restart() {
    echo "Restarting $NAME"
    stop
    start
}

status() {
    # On Ubuntu this isn't even necessary. To find out whether the service is
    # running, use "service my-application status" which bypasses this script
    # entirely provided you used the service utility to start the process.
    #
    # The commented line below is the obvious way of checking whether or not a
    # process is currently running via Forever, but in recent Forever versions
    # when the service is started during Chef provisioning a dead pipe is left
    # behind somewhere and that causes an EPIPE exception to be thrown.
    # forever list | grep -q "$APPLICATION_PATH"
    #
    # So instead we add an extra layer of indirection with this to bypass that
    # issue.
    echo `forever list` | grep -q $(cat $PIDFILE)
    if [ "$?" -eq "0" ]; then
        echo "$NAME is running."
        RETVAL=0
    else
        echo "$NAME is not running."
        RETVAL=3
    fi
}

case "$1" in
    start)
        start
        ;;
    stop)
        stop
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
