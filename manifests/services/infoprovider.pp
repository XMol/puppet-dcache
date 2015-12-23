# dCache doesn't have an explicit info-provider service, as in, there is no
# Java process running for it. Instead, info-provider consists of two
# xml files, which are consumed by a script shipped with dCache, to be
# invoked by a resource BDII daemon.
# Albeit possible, I refuse to manage xml files with Augeas. Even more so,
# since the Xml lense distributed with Augeas is unable to parse dCache's
# default info-provider.xml file.
define dcache::infoprovider (
  $properties = {},
  $tapeinfo = "$dcache::infoprovider_tapeinfo",
  $tapeinfo_content = undef,
  $tapeinfo_source = undef,
  $infoxml = "$dcache::infoprovider_xml",
  $infoxml_content = undef,
  $infoxml_source = undef,
) {
  if $tapeinfo_content and $tapeinfo_source {
    fail("Either set the content of '$tapeinfo' explicitly, or source it, not both!")
  }
  if $infoxml_content and $infoxml_source {
    fail("Either set the content of '$infoxml' explicitly, or source it, not both!")
  }
  
  File {
    owner => "$dcache::dcache_user",
    group => "$dcache::dcache_group",
  }

  if $tapeinfo_content {
    file { "Set content of '$tapeinfo'":
      path => "$tapeinfo",
      content => "$tapeinfo_content",
    }
  } else {
    file { "Source '$tapeinfo'":
      path => "$tapeinfo",
      source => "$tapeinfo_source",
    }
  }

  if $infoxml_content {
    file { "Set content of '$infoxml'":
      path => "$infoxml",
      content => "$infoxml_content",
    }
  } else {
    file { "Source '$infoxml'":
      path => "$infoxml",
      source => "$infoxml_source",
    }
  }
}