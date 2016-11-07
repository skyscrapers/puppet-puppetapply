# puppet-puppetapply

This module will add an Git repository and an cron which will automatically update the git master branch to the latest version and run puppet apply afterwards. This makes it possible to keep the server up to date without having the need of an puppetmaster server.

### Usage

```
  class { 'puppetapply':
    source         => 'git@github.com/skyscrapers/puppet-repo',
    ssh_key        => 'private ssh-key',
    function       => 'httpserver',
    ourenvironment => 'production',
    project        => 'client',
  }
