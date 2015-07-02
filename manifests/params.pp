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

  ### Application related parameters
  $servers           = []
  $start_agents      = 5
  $agent_debug_level = 3
  $agent_timeout     = 3
  $create_user       = true
  $template          = 'zabbix_agennt/etc/zabbix/zabbix_agentd.conf.erb'

  $package = $::operatingsystem ? {
    /(?i:FreeBSD)/ => 'zabbix22-agent',
    default        => 'zabbix-agent',
  }

  $service = $::operatingsystem ? {
    default => 'zabbix-agent',
  }

  $config_file      = $::operatingsystem ? {
    default => '/etc/zabbix/zabbix_agentd.conf',
  }

  $config_file_mode = $::operatingsystem ? {
    default => '0644',
  }

  $config_file_owner = $::operatingsystem ? {
    default => 'root',
  }

  $config_file_group = $::operatingsystem ? {
    default => 'root',
  }

  $pid_file = $::operatingsystem ? {
    default => '/var/run/zabbix/zabbix_agentd.pid',
  }

  $log_file = $::operatingsystem ? {
    default => '/var/log/zabbix/zabbix_agentd.log',
  }

  $port = '10050'
  $protocol = 'tcp'

  # General Settings
  $service_autorestart = true
  $absent = false
  $disable = false
  $disableboot = false

  ### General module variables that can have a site or per module default
  $debug = false
  $audit_only = false
  $noops = undef

}
