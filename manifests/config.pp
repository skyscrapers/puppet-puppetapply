# == Class: puppetapply::config
#
class puppetapply::config {

  file { '/usr/local/sbin/puppet_run.sh':
    ensure  => file,
    content => template('puppetapply/puppet_run.sh.erb'),
    mode    => '0744',
    owner   => root,
    group   => root,
  }

  if versioncmp('4', $::puppetversion) =< 0 {
      $logdir = '/var/log/puppetlabs/puppet/agent.log'
  } else {
      $logdir = '/var/log/puppet/agent.log'
  }

  cron { 'puppetapply':
    command => "/usr/local/sbin/puppet_run.sh >> $logdir 2>&1",
    minute  => '*/30',
  }

  logrotate::rule { 'puppet':
    path   => '/var/log/puppet/agent.log',
    rotate => '3',
    size   => '50M',
  }
}
