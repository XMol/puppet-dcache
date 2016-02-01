define dcache::dcfile (
  $file,
  $content,
  $source,
  $augeas = {},
  $resource,
) {
  validate_hash($augeas)
  if bool2num($content) + bool2num($source) + bool2num(!empty($augeas)) > 1 {
    fail('Only one out of $content, $source or $augeas ought to be set!')
  }
  
  File {
    path => "$file",
    owner => "$dcache::user",
    group => "$dcache::group",
  }
  
  if $content {
    file { "Set content of '$file'":
      content => "$content",
    }
  } elsif $source {
    file { "Source content of '$file'":
      source => "$source",
    }
  } elsif !empty($augeas) {
    create_resources("dcache::dcfiles::$resource",
                     { $title => { file => $file, augeas => $augeas, } })
  }
}