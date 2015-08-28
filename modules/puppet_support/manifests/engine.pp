class puppet_support::engine {

  # Tim Kay's AWS tool http://timkay.com/aws/ - we use this to pull crap from s3
  file { '/usr/local/bin/aws':
    owner   => 'root',
    group   => 'wheel',
    mode    => '0755',
    source  => 'puppet:///modules/puppet_support/aws',
    require => [ File['/usr/local/bin'], ],
  }

  file { '/private/var/root/.awssecret':
    owner   => 'root',
    group   => 'wheel',
    mode    => '0400',
    source  => 'puppet:///modules/puppet_support/.awssecret',
  }

  file { '/usr/local/sbin/mm_update_puppet_manifests':
    owner   => 'root',
    group   => 'wheel',
    mode    => '0755',
    require => File['/usr/local/sbin'],
    source  => 'puppet:///modules/puppet_support/mm_update_puppet_manifests',
  }

  # helper app that runs puppet and stores the exit status for use by plan B
  file { '/usr/local/sbin/puppetstarter':
    owner   => 'root',
    group   => 'wheel',
    mode    => '0755',
    require => File['/usr/local/sbin'],
    source  => 'puppet:///modules/puppet_support/puppetstarter',
  }

  # facter wrapper that deals with facter bug where you can't do
  # 'facter factname' if factname relies on other facts to compute the value
  file { '/usr/local/bin/fctr':
    owner   => 'root',
    group   => 'wheel',
    mode    => '0755',
    require => File['/usr/local/bin'],
    source  => 'puppet:///modules/puppet_support/fctr.rb',
  }

  file { '/etc/miyamoto/puppet_aws_credentials':
    owner   => 'root',
    group   => 'wheel',
    mode    => '0644',
    require => [ File['/etc/miyamoto'], ],
    source  => 'puppet:///modules/puppet_support/puppet_aws_credentials',
  }

  # directories can go down here
  file {'/etc/miyamoto':
    ensure  => directory,
    owner   => 'root',
    group   => 'wheel',
    mode    => '0755',
  }

  file { '/etc/knobs':
    ensure  => directory,
    owner   => 'root',
    group   => 'wheel',
    mode    => '0755',
  }

  # YMMV for these; brew-friendly permissions here
  file { '/usr/local/bin':
    ensure  => directory,
    owner   => 'root',
    group   => 'admin',
    mode    => '0775',
  }

  file { '/usr/local/sbin':
  ensure  => directory,
  owner   => 'root',
  group   => 'admin',
  mode    => '0775',
  }

}
