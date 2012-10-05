# Class: zabbix
#
# This module manages zabbix
#
class zabbix ( $servers="localhost") {

  package {
    ["zabbix-agent"]:
      ensure => present,
    }

  service { "zabbix-agent":
      ensure  => running,
      enable  => true,
      pattern => "zabbix_agentd",
      require => Package["zabbix-agent"];
  } # service

  file {
    '/etc/zabbix/zabbix_agentd/':
      require => Package['zabbix-agent'],
      ensure  => directory;
    '/etc/zabbix/zabbix_agentd.conf':
      ensure  => present,
      notify  => Service['zabbix-agent'],
      content => template('zabbix/zabbix_agentd.conf.erb');
  }

  define conf ( $content, $ensure = "present" )
  {
    file {
      "/etc/zabbix/zabbix_agentd/${name}":
        content => $content,
        notify  => Service['zabbix-agent'],
        ensure  => "${ensure}";
    }
  }
}
