define dcache::dcfiles::authkeys (
  $file,
  $augeas,
) {
  # Unfortunately, we cannot use Puppet's own ssh_authorized_keys type,
  # because the file is in a location owned by root,
  # yet Puppet tries to write the file as $dcache::user.
  Augeas {
    lens => 'Authorized_Keys.lns',
    incl => $file,
  }
  
  augeas { 'Manage dCache\'s admin authorized keys':
    changes => flatten(map($augeas) |$comment, $details| {[
      "defnode this key[. = '${details[key]}' and type = '${details['type']}' and comment = '${comment}'] '${details[key]}'",
      "set \$this/type '${details['type']}'",
      "set \$this/comment '${comment}'",
    ]}),
  }
}
