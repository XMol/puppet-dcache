# @summary Pattern to validate the gplazma.conf content
type Dcache::Gplazma = Pattern[/\A((|(#.*)|(auth|map|account|session|identity)[ \t]+(optional|required|requisite|sufficient)[ \t]+\S+([ \t]+\S+=\S+)*)\n)*\Z/]
