# = Class: zabbix_agent
#
class zabbix_agent (
  Array[Stdlib::Ip::Address] $servers,
  Integer[1,100]             $start_agents,
  Integer[1,5]               $agent_debug_level,
  Integer[1,30]              $agent_timeout,
  String                     $package,
  String                     $service,
  String                     $template,
  Stdlib::Absolutepath       $config_file,
  Stdlib::Filemode           $mode,
  String                     $owner,
  String                     $group,
  Boolean                    $debug,
  Stdlib::Absolutepath       $pid_file,
  Stdlib::Absolutepath       $log_file,
  Stdlib::Port               $port,
  Stdlib::Absolutepath       $include_dir,
  ) {

  ensure_packages([$package])
  service { $service:
    ensure  => running,
    enable  => true,
    require => Package[$package],
  }
  file { $config_file:
    ensure  => present,
    mode    => $mode,
    owner   => $owner,
    group   => $group,
    content => template($template),
    require => Package[$package],
    notify  => Service[$service],
  }
}
