# Class: zabbix_agent::params
#
# This class defines default parameters used by the main module class zabbix_agent
# Operating Systems differences in names and paths are addressed here
#
# == Variables
#
# Refer to zabbix_agent class for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It may be imported or inherited by other classes
#
class zabbix_agent::params {

  $servers           = []
  $start_agents      = 5
  $agent_debug_level = 3
  $agent_timeout     = 3
  $port              = 10050
  $protocol          = 'tcp'
  $debug             = false
  $noops             = false
  $template          = 'zabbix_agennt/etc/zabbix/zabbix_agentd.conf.erb'

  $package = $::operatingsystem ? {
    /(?i:FreeBSD)/ => 'zabbix22-agent',
    default        => 'zabbix-agent',
  }

  $service = $::operatingsystem ? {
    /(?i:FreeBSD)/ => 'zabbix_agentd',
    default        => 'zabbix-agent',
  }

  $config_file      = $::operatingsystem ? {
    /(?i:FreeBSD)/ => '/usr/local/etc/zabbix22/zabbix_agentd.conf',
    default        => '/etc/zabbix/zabbix_agentd.conf',
  }

  $config_file_mode = $::operatingsystem ? {
    default => '0644',
  }

  $config_file_owner = $::operatingsystem ? {
    default => 'root',
  }

  $config_file_group = $::operatingsystem ? {
    /(?i:FreeBSD)/ => 'wheel',
    default        => 'root',
  }

  $pid_file = $::operatingsystem ? {
    /(?i:FreeBSD)/ => '/tmp/zabbix_agentd.pid',
    default        => '/var/run/zabbix/zabbix_agentd.pid',
  }

  $log_file = $::operatingsystem ? {
    /(?i:FreeBSD)/ => '/tmp/zabbix_agentd.log',
    default        => '/var/log/zabbix/zabbix_agentd.log',
  }


}
