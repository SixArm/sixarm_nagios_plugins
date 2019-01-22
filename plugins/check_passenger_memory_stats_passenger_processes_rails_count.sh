#!/bin/sh

##
# Nagios plugih to check passenger memory stats,
# passenger processes rails count.
#
# We use this script to do Nagios monitoring on our web servers
# that are running Ruby On Rails, Apache, and Phusion Passenger.
#
# For more information on these:
#
#   * Ruby on Rails: https://rubyonrails.org/
#   * Apache HTTP Server: https://httpd.apache.org/
#   * Phusion Passenger: http://phusion.nl
#   * Nagios monitoring: http://www.nagios.org
#   * Nagios graph tool: http://nagiosgraph.sourceforge.net/
#
# We use this script for gathering memory stats info which we
# display using Nagios Graph overlaid with other Nagios stats,
# so this script always outputs "OK" rather than any alerts.
#
# If you want to use the critical alert features of Nagios,
# then you can modify this script to return different output
# depending on whatever values that you feel are best for
# your own server, available RAM, and Passenger settings.
# If you need help with this, feel free to contact me.
#
#
# ## Troubleshooting
#
# Ensure that you can run this manually:
#
#     sudo passenger-memory-stats |
#     sed -n '/^-* Passenger processes -*$/,/^$/p' |
#     grep "Rails: " |
#     wc -l
#
#
# ## Thanks
#
#  This program is based on code from check_nginx.sh
#  created by Mike Adolphs (http://www.matejunkie.com/)
#
#
# ## Tracking
#
#   * Command: check_passenger_memory_stats_passenger_processes_rails_count
#   * Website: https://sixarm.com/
#   * Cloning: https://github.com/sixarm/sixarm_nagios_plugins
#   * Version: 1.2.1
#   * Created: 2010-10-16
#   * Updated: 2019-01-22
#   * License: GPL
#   * Contact: Joel Parker Henderson (http://joelparkerhenderson.com)
#   * Tracker: cf2313bac9c4086a3d8e64293275ec32
##

PROGNAME=`basename $0`
VERSION="Version 1.2.1,"
AUTHOR="2010, Joel Parker Henderson (joel@sixarm.com, http://sixarm.com/)"

ST_OK=0
ST_WR=1
ST_CR=2
ST_UK=3

print_version() {
    echo "$VERSION $AUTHOR"
}

print_help() {
    print_version $PROGNAME $VERSION
    echo ""
    echo "$PROGNAME is a Nagios plugin to check passenger memory stats,"
    echo "specifically for Passenger processes Rails count."
    echo ""
    exit $ST_UK
}

while test -n "$1"; do
    case "$1" in
        -help|-h)
            print_help
            exit $ST_UK
            ;;
        --version|-v)
            print_version $PROGNAME $VERSION
            exit $ST_UK
            ;;
        *)
            echo "Unknown argument: $1"
            print_help
            exit $ST_UK
            ;;
        esac
    shift
done


get_vals() {
    passenger_memory_stats_passenger_processes_rails_count=`sudo passenger-memory-stats | sed -n '/^-* Passenger processes -*$/,/^$/p' | grep "Rails: " | wc -l`
}

do_output() {
    output="$passenger_memory_stats_passenger_processes_rails_count passenger memory stats passenger processes rails count"
}

do_perfdata() {
    perfdata="'pms_p_count'=$passenger_memory_stats_passenger_processes_rails_count"
}

# Here we go!
get_vals
do_output
do_perfdata

echo "OK - ${output} | ${perfdata}"
exit $ST_OK
