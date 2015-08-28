class puppet_support::helpers {

  file { '/usr/local/sbin/mm_lock_puppetstarter':
    owner   => 'root',
    group   => 'wheel',
    mode    => '0755',
    require => File['/usr/local/sbin'],
    source  => 'puppet:///modules/puppet_support/mm_lock_puppetstarter',
  }

  file { '/usr/local/sbin/mm_unlock_puppetstarter':
    owner   => 'root',
    group   => 'wheel',
    mode    => '0755',
    require => File['/usr/local/sbin'],
    source  => 'puppet:///modules/puppet_support/mm_unlock_puppetstarter',
  }

}
