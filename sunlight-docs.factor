USING: help.syntax help.markup ;
IN: sunlight

HELP: get-legislator
{ $values { "apikey" "a Sunlight Labs API key" } 
  { "params" "An assoc of search parameters (see the Sunlight API docs for specifics)"}
  { "legislator/f" "A " { $link legislator } ", or f if no results or more than one matching legislator"} }
{ $description "Use the Sunlight Lakbs API to look up a single legislator."}
{ $examples
 { $example
   "USE: sunlight"
   "\"YOUR_API_KEY\" { { \"district\" 4 } { \"state\" \"NC\" } } get-legislator"
   "lastname>> ."
   "\"Price\""
  }
} ;

HELP: get-legislators
{ $values { "apikey" "a Sunlight Labs API key" }
  { "params" "An assoc of search parameters to filter legislators by (see the Sunlight API docs for specifics)"}
  { "legs" "Matching " { $link legislator } " objects" } }
{ $description "Use the Sunlight Labs API to look up all legislators matching a certain set of parameters" } ;

ARTICLE: "sunlight" "Sunlight Labs API"
"Query US legislative information with the Sunlight Labs API "
{ $url "http://wiki.sunlightlabs.com/Sunlight_API_Documentation" } ;

ABOUT: "sunlight"