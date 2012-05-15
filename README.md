# SixArm.com » Nagios » Plugins for monitoring servers

This repo has our custom-built Nagios plugins:
     	  
  * check_passenger_memory_stats_apache_processes_apache2_count
  * check_passenger_memory_stats_apache_processes_apache2_vmsize_max
  * check_passenger_memory_stats_apache_processes_apache2_vmsize_sum
  * check_passenger_memory_stats_apache_processes_total_private_dirty
  * check_passenger_memory_stats_passenger_processes_rails_count
  * check_passenger_memory_stats_passenger_processes_rails_vmsize_max
  * check_passenger_memory_stats_passenger_processes_rails_vmsize_sum
  * check_passenger_memory_stats_passenger_processes_total_private_dirty
  * check_whoami

Each has a plugin script (in the <code>plugins</code> directory) and matching conf files (in the <code>plugins-conf</code> directory) for command cfg and service cfg.

For more info on Passenger and Nagios:

  * Phusion Passenger: http://phusion.nl
  * Nagios monitoring: http://www.nagios.org   
  * Nagios graph tool: http://nagiosgraph.sourceforge.net/


