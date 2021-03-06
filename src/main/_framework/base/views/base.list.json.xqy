xquery version "1.0-ml";

import module namespace request = "http://xquerrail.com/request" at "../../request.xqy";
   
import module namespace response = "http://xquerrail.com/response" at "../../response.xqy";
   
import module namespace model = "http://xquerrail.com/helper/model" at "../../helpers/model-helper.xqy";

import module namespace domain = "http://xquerrail.com/domain" at "../../domain.xqy";

import module namespace js = "http://xquerrail.com/helper/javascript" at "../../helpers/javascript-helper.xqy";

declare variable $response as map:map external;

response:initialize($response),
let $node := response:body()
let $model :=  domain:get-domain-model($node/@type)
let $result := for $n in $node/*[local-name(.) eq $model/@name]
return 
   model:to-json($model,$n)
return
 if($model) then 
    <x>{js:object((       
        js:keyvalue("type",$node/@type cast as xs:string),
        js:keyvalue("elapsed",fn:string($node/@elapsed)),
        js:keyvalue("processing",xdmp:elapsed-time()),
        js:keyvalue("currentpage",$node/currentpage cast as xs:integer),
        js:keyvalue("pagesize",$node/pagesize cast as xs:integer),
        js:keyvalue("totalpages",$node/totalpages cast as xs:integer),
        js:keyvalue("totalrecords",$node/totalrecords cast as xs:integer),
        js:entry($node/@type,js:a(
        $result
        ))
     ))}</x>/*
 else ()