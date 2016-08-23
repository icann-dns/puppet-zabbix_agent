# = Class: zabbix_agent
#
class zabbix_agent (
  $servers           = $::zabbix_agent::params::servers,
  $start_agents      = $::zabbix_agent::params::start_agents,
  $agent_debug_level = $::zabbix_agent::params::agent_debug_level,
  $agent_timeout     = $::zabbix_agent::params::agent_timeout,
  $package           = $::zabbix_agent::params::package,
  $service           = $::zabbix_agent::params::service,
  $template          = $::zabbix_agent::params::template,
  $config_file       = $::zabbix_agent::params::config_file,
  $config_file_mode  = $::zabbix_agent::params::config_file_mode,
  $config_file_owner = $::zabbix_agent::params::config_file_owner,
  $config_file_group = $::zabbix_agent::params::config_file_group,
  $debug             = $::zabbix_agent::params::debug,
  $noops             = $::zabbix_agent::params::noops,
  $service_status    = $::zabbix_agent::params::service_status,
  $pid_file          = $::zabbix_agent::params::pid_file,
  $log_file          = $::zabbix_agent::params::log_file,
  $port              = $::zabbix_agent::params::port,
  $protocol          = $::zabbix_agent::params::protocol,
  $include_dir       = $::zabbix_agent::params::include_dir,
  ) inherits zabbix_agent::params {


  validate_array($servers)
  validate_integer($start_agents,100)
  validate_integer($agent_debug_level,100)
  validate_integer($agent_timeout,120)
  validate_string($package)
  validate_string($service)
  validate_string($template)
  validate_absolute_path($config_file)
  validate_string($config_file_mode)
  validate_string($config_file_owner)
  validate_string($config_file_group)
  validate_bool($debug)
  validate_bool($noops)
  validate_absolute_path($pid_file)
  validate_absolute_path($log_file)
  validate_integer($port, 65536)
  validate_string($protocol)
  validate_absolute_path($include_dir)


  package { $package:
    ensure    => present,
    noop      => $noops,
  }
  service { $service:
    ensure => running,
    enable => true,
    noop   => $noops,
    require => Package[$package],
  }

  file { $config_file:
    ensure  => present,
    mode    => $config_file_mode,
    owner   => $config_file_owner,
    group   => $config_file_group,
    content => template($template),
    noop    => $noops,
    require => Package[$package],
    notify  => Service[$service],
  }

}
