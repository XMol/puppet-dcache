define dcache::dcfile (
  $file,
  $source,
  $content,
  $template = {},
  $augeas = {},
  $resource = '', # Only required for $template and $augeas.
) {
  validate_hash($template)
  validate_hash($augeas)
  File {
    path  => $file,
    owner => $dcache::user,
    group => $dcache::group,
  }
  
  if !empty($source) {
    file { "Source content of '${file}'":
      source => $source,
    }
  } elsif !empty($content) {
    file { "Set content of '${file}'":
      content => $content,
    }
  } elsif !empty($template) {
    epp("dcache/${resource}.epp", { 'template' => $template })
  } elsif !empty($augeas) {
    create_resources("dcache::dcfiles::${resource}", { $title => { file => $file, augeas => $augeas, } })
  }
}
