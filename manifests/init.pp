# == Class: puppetapply::init
#
class puppetapply(
  $source = undef,
  $ssh_key = undef,
  $function = undef,
  $ourenvironment = undef,
  $project = undef,
  ) {
  class {'puppetapply::install': } ->
  class {'puppetapply::config': }
}
