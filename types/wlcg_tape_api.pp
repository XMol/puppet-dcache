# @summary Contact details on the /tape REST endpoints.
type Dcache::Wlcg_tape_api = Struct[{
  'sitename'              => String,
  'endpoints'             => Array[
    Struct[{
      'uri'                => Pattern[/\A[\d\w]+:\/\/.*\z/],
      'version'            => String,
      Optional['metadata'] => Hash,
    }]
  ],
  Optional['description'] => String,
}]
