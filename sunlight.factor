! Copyright (C) 2009 Michael Stephens.
! See http://factorcode.org/license.txt for BSD license.
USING: kernel json.reader http.client urls locals accessors assocs strings continuations sequences
 math.parser make classes.tuple arrays combinators ;
IN: sunlight

<PRIVATE

CONSTANT: sunlight-url URL"  http://services.sunlightlabs.com/api/"

: method-url ( method -- url )
  [ sunlight-url clone dup path>> ] dip url-append-path >>path ;

:: query-url ( apikey params method -- url )
  method method-url apikey "apikey" set-query-param
  params over [ -rot swap set-query-param drop ] curry assoc-each ;

: query ( apikey params method -- data )
  query-url [ http-get nip >string json> "response" swap at ] [ 2drop { } ] recover ;

: slot-names ( class -- l )
  all-slots [ name>> ] map ;

: 1assoc ( key value -- assoc )
  [ 1array ] bi@ zip ;

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
  "legislators.getList" query "legislators" swap at
  [ "legislator" swap at <legislator> ] map ;

: legislators-for-zip ( apikey zip -- legs )
  "zip" swap 1assoc "legislators.allForZip" query "legislators" swap at
  [ "legislator" swap at <legislator> ] map ;

TUPLE: district state number ;

: <district> ( hash -- district )
  district slot-names [ over at ] map { district } prepend
  >tuple nip ;

: districts-for-zip ( apikey zip -- districts )
  "zip" swap 1assoc "districts.getDistrictsFromZip" query "districts" swap at
  [ "district" swap at <district> ] map ;

: zips-for-district ( apikey state district -- zips )
  2array { "state" "district" } swap zip "districts.getZipsFromDistrict" query "zips" swap at ;

: district-for-lat-long ( apikey latitude longitude -- zip )
  2array { "latitude" "longitude" } swap zip "districts.getDistrictFromLatLong" query "districts" swap at
  first "district" swap at <district> ;