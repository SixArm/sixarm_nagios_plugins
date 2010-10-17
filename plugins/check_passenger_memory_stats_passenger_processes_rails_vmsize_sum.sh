#!/bin/sh

#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program; if not, write to the Free Software
#   Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#
#   Author: Joel Parker Henderson (http://sixarm.com)
#
#   This program is based on code from check_nginx.sh
#   created by Mike Adolphs (http://www.matejunkie.com/)

PROGNAME=`basename $0`
VERSION="Version 1.0.0,"
AUTHOR="2009, Joel Parker Henderson (http://sixarm.com/)"

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
    echo "specifically for Passenger processes Rails VMSize sum."
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
   passenger_memory_stats_passenger_processes_rails_vmsize_sum=`sudo passenger-memory-stats | sed -n '/^-* Passenger processes -*$/,/^$/p' | grep "Rails: " | awk '{ sum += $2 }; END { print sum }'`
}

do_output() {
    output="$passenger_memory_stats_passenger_processes_rails_vmsize_sum passenger memory stats passenger processes rails vmsize sum"
}

do_perfdata() {
    perfdata="'pms_p_vm_sum'=$passenger_memory_stats_passenger_processes_rails_vmsize_sum"
}

# Here we go!
get_vals
do_output
do_perfdata

echo "OK - ${output} | ${perfdata}"
exit $ST_OK

