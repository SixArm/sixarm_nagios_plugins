#!/bin/sh

##
# Nagios plugih to check passenger memory stats,
# passenger processes rails vmsize sum.
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
#     awk '{ sum += $2 }; END { print sum }'
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
#   * Command: check_passenger_memory_stats_passenger_processes_rails_vmsize_sum
#   * Website: https://sixarm.com/
#   * Cloning: https://github.com/sixarm/sixarm_nagios_plugins
#   * Version: 1.2.2
#   * Created: 2010-10-16
#   * Updated: 2019-01-24
#   * License: GPL
#   * Contact: Joel Parker Henderson (http://joelparkerhenderson.com)
#   * Tracker: 8499035c8690aef0c5a9f5db88146d4c
##

PROGNAME=`basename $0`
VERSION="Version 1.2.2,"
AUTHOR="2010, Joel Parker Henderson (joel@sixarm.com, http://sixarm.com/)"

STATUS_CODE_OK=0
STATUS_CODE_WR=1
STATUS_CODE_CR=2
STATUS_CODE_UK=3

eval "STATUS_ABBR_0=\"OK\""
eval "STATUS_ABBR_1=\"WR\""
eval "STATUS_ABBR_2=\"CR\""
eval "STATUS_ABBR_3=\"UK\""

eval "UNIT_=1"
eval "UNIT_K=1000"
eval "UNIT_M=1000000"
eval "UNIT_G=1000000000"
eval "UNIT_T=1000000000000"

print_version() {
    echo "$VERSION $AUTHOR"
}

print_help() {
    print_version $PROGNAME $VERSION
    echo ""
    echo "$PROGNAME is a Nagios plugin to check passenger memory stats,"
    echo "specifically for Passenger processes Rails VMSize sum."
    echo ""
    exit $STATUS_CODE_UK
}

while test -n "$1"; do
    case "$1" in
        -help|-h)
            print_help
            exit $STATUS_CODE_UK
            ;;
        --version|-v)
            print_version $PROGNAME $VERSION
            exit $STATUS_CODE_UK
            ;;
        *)
            echo "Unknown argument: $1"
            print_help
            exit $STATUS_CODE_UK
            ;;
        esac
    shift
done

get_vals() {
    passenger_memory_stats_passenger_processes_rails_vmsize_sum=`sudo passenger-memory-stats | sed -n '/^-* Passenger processes -*$/,/^$/p' | grep "Rails: " | awk '{ sum += $2 }; END { print sum }'`
    if [ -z "$passenger_memory_stats_passenger_processes_rails_vmsize_sum" ]; then
        passenger_memory_stats_passenger_processes_rails_vmsize_sum=0
    fi
}

do_output() {
    output="$passenger_memory_stats_passenger_processes_rails_vmsize_sum passenger memory stats passenger processes rails vmsize sum"
}

do_perfdata() {
    perfdata="'pms_p_vm_sum'=$passenger_memory_stats_passenger_processes_rails_vmsize_sum"
}

##
# Assess as Ok, Warning, Critical, or Unknown.
#
# This implementation always returns Ok.
# Customize this implementation for your our goals.
#
# Return a status code.
##

assess_via_always_ok() {
    echo $STATUS_CODE_OK
}

##
# Assess as Ok, Warning, Critical, or Unknown.
#
# This implementation uses the approach of lesser is better,
# i.e. a lower number is better than a higher number.
#
# This function	is provided as an example for you to use.
# You can edit this code to use this function, and also edit
# the function to use your own preferred number values.
#
# Return a status code.
##

assess_via_lesser_is_better() {
   if [ "$1" -lt "1" ]; then
      echo $STATUS_CODE_OK
   elif [ "$1" -lt "2" ]; then
      echo $STATUS_CODE_WR
   else
      echo $STATUS_CODE_CR
   fi
}

# Here we go!
get_vals
do_output
do_perfdata

status_code=$(assess_via_always_ok)
echo $(eval echo '$'STATUS_ABBR_$status_code) " - ${output} | ${perfdata}"
exit $status_code
