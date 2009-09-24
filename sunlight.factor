! Copyright (C) 2009 Michael Stephens.
! See http://factorcode.org/license.txt for BSD license.
USING: kernel json.reader http.client urls locals accessors assocs strings continuations sequences
 math.parser make classes.tuple arrays combinators ;
IN: sunlight

TUPLE: legislator title firstname middlename lastname name_suffix nickname party state district
  in_office gender phone fax website webform email congress_office bioguide_id votesmart_id
  fec_id govtrack_id crp_id eventful_id sunlight_old_id congresspedia_url twitter_id youtube_url ;

TUPLE: district state number ;

TUPLE: committee chamber id name subcommittees members ;

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

: <legislator> ( hash -- leg )
  legislator slot-names [ over at ] map { legislator } prepend
  >tuple nip ;

: <district> ( hash -- district )
  district slot-names [ over at ] map { district } prepend
  >tuple nip ;

: <committee> ( hash -- committee )
  committee slot-names [ over at ] map { committee } prepend
  >tuple nip ;

: extract-legislators ( hash -- seq )
  "legislators" swap at [ "legislator" swap at <legislator> ] map ;

: extract-committee ( hash -- committee )
  "committee" swap at <committee>
  dup subcommittees>> [ "committee" swap at <committee> ] map >>subcommittees
  dup members>> [ "legislator" swap at <legislator> ] map >>members ;

: extract-committees ( hash -- seq )
  "committees" swap at [ extract-committee ] map ;

: 1assoc ( key value -- assoc )
  2array 1array ;

PRIVATE>

: get-legislator ( apikey params -- legislator/f )
  "legislators.get" query "legislator" swap at <legislator> ;

: get-legislators ( apikey params -- legs )
  "legislators.getList" query extract-legislators ;

: legislators-for-zip ( apikey zip -- legs )
  "zip" swap 1assoc "legislators.allForZip" query extract-legislators ;

: districts-for-zip ( apikey zip -- districts )
  "zip" swap 1assoc "districts.getDistrictsFromZip" query "districts" swap at
  [ "district" swap at <district> ] map ;

: zips-for-district ( apikey state district -- zips )
  2array { "state" "district" } swap zip "districts.getZipsFromDistrict" query "zips" swap at ;

: district-for-lat-long ( apikey latitude longitude -- zip )
  2array { "latitude" "longitude" } swap zip "districts.getDistrictFromLatLong" query "districts" swap at
  first "district" swap at <district> ;

: get-committees ( apikey chamber -- committees )
  "chamber" swap 1assoc "committees.getList" query extract-committees ;

: get-committee ( apikey id -- committee/f )
  "id" swap 1assoc "committees.get" query extract-committee ;

: committees-for-legislator ( apikey bioguide-id -- committees )
  "bioguide_id" swap 1assoc "committees.allForLegislator" query extract-committees ;