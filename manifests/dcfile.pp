define dcache::dcfile (
  $file,
  $content,
  $source,
  $augeas = {},
  $resource,
) {
  validate_hash($augeas)
  if bool2num(empty($content)) +
     bool2num(empty($source)) +
     bool2num(empty($augeas)) < 2 {
    fail('Only one out of $content, $source or $augeas ought to be set!')
  }
  
  File {
    path => "$file",
    owner => "$dcache::user",
    group => "$dcache::group",
  }
  
  if !empty($content) {
    file { "Set content of '$file'":
      content => "$content",
    }
  } elsif !empty($source) {
    file { "Source content of '$file'":
      source => "$source",
    }
  } elsif !empty($augeas) {
    create_resources("dcache::dcfiles::$resource",
                     { $title => { file => $file, augeas => $augeas, } })
  }
}