# = Class: zabbix_agent
#
# This is the main zabbix_agent class
#
#
# == Parameters
#
# [*servers*]
#   Ips of the Zabbix server
#
# [*template*]
#   Sets the path to the template to use as content for main configuration file
#   If defined, zabbix_agent main config file has: content => content("$template")
#   Note source and template parameters are mutually exclusive: don't use both
#   Can be defined also by the (top scope) variable $zabbix_agent_template
#
# [*debug*]
#   Set to 'true' to enable modules debugging
#   Can be defined also by the (top scope) variables $zabbix_agent_debug and $debug
#
# [*noops*]
#   Set noop metaparameter to true for all the resources managed by the module.
#   Basically you can run a dryrun for this specific module if you set
#   this to true. Default: undef
#
# Default class params - As defined in zabbix_agent::params.
# Note that these variables are mostly defined and used in the module itself,
# overriding the default values might not affected all the involved components.
# Set and override them only if you know what you're doing.
# Note also that you can't override/set them via top scope variables.
#
# [*package*]
#   The name of zabbix_agent package
#
# [*service*]
#   The name of zabbix_agent service
#
# [*config_file*]
#   Main configuration file path
#
# [*config_file_mode*]
#   Main configuration file path mode
#
# [*config_file_owner*]
#   Main configuration file path owner
#
# [*config_file_group*]
#   Main configuration file path group
#
# [*pid_file*]
#   Path of pid file. Used by monitor
#
# [*log_file*]
#   Log file(s). Used by puppi
#
# [*port*]
#   The listening port, if any, of the service.
#   This is used by monitor, firewall and puppi (optional) components
#   Note: This doesn't necessarily affect the service configuration file
#   Can be defined also by the (top scope) variable $zabbix_agent_port
#
# [*protocol*]
#   The protocol used by the the service.
#   This is used by monitor, firewall and puppi (optional) components
#   Can be defined also by the (top scope) variable $zabbix_agent_protocol
#
#
# See README for usage patterns.
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
  $protocol          = $::zabbix_agent::params::protocol
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
  validate_string($noops)
  validate_absolute_path($pid_file)
  validate_absolute_path($log_file)
  validate_integer($port, 65536)
  validate_string($protocol)


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

  ### Debug
  if $zabbix_agent::bool_debug == true {
    class { 'zabbix_agent::debug': }
  }

}
