# == Class: puppetapply::install
#
class puppetapply::install {
  vcsrepo { '/root/puppet':
    ensure     => latest,
    provider   => git,
    source     => $puppetapply::source,
    user       => root,
    submodules => true,
    require    => [File_line['bitbucket'], File_line['github'], Package['git']],
  }

  if !defined(File['/root/.ssh']) {
    file { '/root/.ssh':
      ensure => directory,
      mode   => '0700',
      owner  => 'root',
      group  => 'root',
    }
  }

  if !defined(File['/root/.ssh/known_hosts']) {
    file { '/root/.ssh/known_hosts':
      ensure  => present,
      mode    => '0744',
      owner   => 'root',
      group   => 'root',
      require => File['/root/.ssh']
    }
  }

  file_line { 'bitbucket':
    path    => '/root/.ssh/known_hosts',
    line    => 'bitbucket.org ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAubiN81eDcafrgMeLzaFPsw2kNvEcqTKl/VqLat/MaB33pZy0y3rJZtnqwR2qOOvbwKZYKiEO1O6VqNEBxKvJJelCq0dTXWT5pbO2gDXC6h6QDXCaHo6pOHGPUy+YBaGQRGuSusMEASYiWunYN0vCAI8QaXnWMXNMdFP3jHAJH0eDsoiGnLPBlBp4TNm6rYI74nMzgz3B9IikW4WVK+dc8KZJZWYjAuORU3jc1c/NPskD2ASinf8v3xnfXeukU0sJ5N6m5E8VLjObPEO+mN2t/FZTMZLiFqPWc/ALSqnMnnhwrNi2rbfg/rd/IpL8Le3pSBne8+seeFVBoGqzHM9yXw==',
    require => File['/root/.ssh/known_hosts'],
  }

  file_line { 'github':
    path    => '/root/.ssh/known_hosts',
    line    => 'github.com ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==',
    require => File['/root/.ssh/known_hosts'],
  }

  if $::packerbuild {
    file { '/root/.ssh/id_rsa':
      ensure  => file,
      mode    => '0400',
      content => hiera('sshkey'),
    }
    File['/root/.ssh/id_rsa'] ~> Vcsrepo['/root/puppet']
  }

  if !defined(Package['git']) {
    package { 'git':
      ensure => installed,
    }
  }
}
