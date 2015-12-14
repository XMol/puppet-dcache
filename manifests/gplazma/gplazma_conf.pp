define dcache::gplazma::gplazma_conf (
  $gplazma_conf = "$dcache::gplazma_conf",
  $content = "",
  $source = undef,
) {
  if $source and $content {
    fail(join(["Either set the content of $gplazma_conf explicitly",
               "or give a source reference, not both!"], " "))
  }
  
  File {
    path => "$gplazma_conf",
    owner => "$dcache::dcache_user",
    group => "$dcache::dcache_group",
  }
  
  if $source {
    file { "Source '$gplazma_conf'":
      source => "$source",
    }
  } else {
    file { "Set content of '$gplazma_conf'":
      content => "$content",
    }
  }
  
}