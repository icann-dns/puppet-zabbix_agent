# = Class: zabbix_agent
#
class zabbix_agent (
  Array[Stdlib::Ip::Address]           $servers,
  Integer[1,100]                       $start_agents,
  Integer[1,5]                         $agent_debug_level,
  Integer[1,30]                        $agent_timeout,
  String                               $package,
  String                               $service,
  String                               $template,
  Stdlib::Absolutepath                 $config_file,
  Stdlib::Filemode                     $mode,
  String                               $owner,
  String                               $group,
  Boolean                              $debug,
  Stdlib::Absolutepath                 $pid_file,
  Stdlib::Absolutepath                 $log_file,
  Stdlib::Port                         $port,
  Stdlib::Absolutepath                 $include_dir,
  Optional[Hash[String[1], String[1]]] $user_parameters,
  ) {

  ensure_packages([$package])
  service { $service:
    ensure  => running,
    enable  => true,
    require => Package[$package],
  }
  file { $config_file:
    ensure  => file,
    mode    => $mode,
    owner   => $owner,
    group   => $group,
    content => template($template),
    require => Package[$package],
    notify  => Service[$service],
  }
  file {$include_dir:
    ensure => directory,
    owner  => $owner,
    group  => $group,
  }
  if $user_parameters {
    file {"${include_dir}/userparameter_puppetmanaged.conf":
      ensure  => file,
      mode    => $mode,
      owner   => $owner,
      group   => $group,
      content => template('zabbix_agent/etc/zabbix/zabbix_agent.d/userparameter_puppetmanaged.conf.erb'),
      require => Package[$package],
      notify  => Service[$service],
    }
  }
}
