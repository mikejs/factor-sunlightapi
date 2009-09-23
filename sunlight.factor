! Copyright (C) 2009 Michael Stephens.
! See http://factorcode.org/license.txt for BSD license.
USING: kernel json.reader http.client urls locals accessors assocs strings continuations sequences
 math.parser make classes.tuple ;
IN: sunlight

CONSTANT: sunlight-url URL"  http://services.sunlightlabs.com/api/"

<PRIVATE

: method-url ( method -- url )
  [ sunlight-url clone dup path>> ] dip url-append-path >>path ;

:: query-url ( apikey params method -- url )
  method method-url apikey "apikey" set-query-param
  params over [ -rot swap set-query-param drop ] curry assoc-each ;

: query ( apikey params method -- data )
  query-url [ http-get nip >string json> "response" swap at ] [ 2drop { } ] recover ;

: slot-names ( class -- l )
  all-slots [ name>> ] map ;

PRIVATE>

TUPLE: legislator title firstname middlename lastname name_suffix nickname party state district
  in_office gender phone fax website webform email congress_office bioguide_id votesmart_id
  fec_id govtrack_id crp_id eventful_id sunlight_old_id congresspedia_url twitter_id youtube_url ;

: <legislator> ( hash -- leg )
  legislator slot-names [ over at ] map { legislator } prepend
  >tuple nip ;

: get-legislator ( apikey params -- leg )
  "legislators.get" query "legislator" swap at <legislator> ;

: get-legislators ( apikey params -- legs )
  "legislators.getList" query [ <legislator> ] map ;