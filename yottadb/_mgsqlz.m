%mgsqlz ;(CM) MGSQL : client-server computing ; 28 Jan 2022  10:04 AM
 ;
 ;  ----------------------------------------------------------------------------
 ;  | MGSQL                                                                    |
 ;  | Author: Chris Munt cmunt@mgateway.com, chris.e.munt@gmail.com            |
 ;  | Copyright (c) 2016-2022 M/Gateway Developments Ltd,                      |
 ;  | Surrey UK.                                                               |
 ;  | All rights reserved.                                                     |
 ;  |                                                                          |
 ;  | http://www.mgateway.com                                                  |
 ;  |                                                                          |
 ;  | Licensed under the Apache License, Version 2.0 (the "License"); you may  |
 ;  | not use this file except in compliance with the License.                 |
 ;  | You may obtain a copy of the License at                                  |
 ;  |                                                                          |
 ;  | http://www.apache.org/licenses/LICENSE-2.0                               |
 ;  |                                                                          |
 ;  | Unless required by applicable law or agreed to in writing, software      |
 ;  | distributed under the License is distributed on an "AS IS" BASIS,        |
 ;  | WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. |
 ;  | See the License for the specific language governing permissions and      |
 ;  | limitations under the License.                                           |
 ;  ----------------------------------------------------------------------------
 ;
a d vers^%mgsql("%mgsqlz") q
 ;
so(%zi,%zo) ; server: open
 i $g(%zi(0,"stmt"))'="" k ^mgsqls($j,%zi(0,"stmt"))
 q 0
 ;
ss(%zi,%zo,rn) ; server: row of data
 n i,stop
 i $g(%zi(0,"stmt"))'="" d  k %zo(rn) q 0
 . f i=1:1 q:'$d(%zo(rn,i))  i $g(%zo(0,i,0))="date" s %zo(rn,i)=$$ddate^%mgsqls($g(%zo(rn,i)),1)
 . m ^mgsqls($j,%zi(0,"stmt"),0,rn)=%zo(rn)
 . q
 i $g(%zi(0,"callback"))'="" d  k %zo(rn) q stop
 . f i=1:1 q:'$d(%zo(rn,i))  i $g(%zo(0,i,0))="date" s %zo(rn,i)=$$ddate^%mgsqls($g(%zo(rn,i)),1)
 . s @("stop=$$"_$g(%zi(0,"callback"))_"(.%zi,.%zo,rn)")
 . q
 w ! f i=1:1 q:'$d(%zo(rn,i))  d
 . i i>1 w ","
 . i $g(%zo(0,i,0))="date" w $$ddate^%mgsqls($g(%zo(rn,i)),1) q
 . i $g(%zo(rn,i))["," w """"_$g(%zo(rn,i))_"""" q
 . w $g(%zo(rn,i))
 . q
 k %zo(rn)
 q 0
 ;
sc(%zi,%zo) ; server: close
 i $g(%zi(0,"stmt"))'="" k ^mgsqls($j,%zi(0,"stmt"),1),^mgsqls($j,%zi(0,"stmt"),2),^mgsqls($j,%zi(0,"stmt"),3)
 q 0
 ;
tpcb(dbid,sql,%zi,%zo,info) ; transaction processing callback
 n ok,cb
 s ok=0
 s cb=$g(%zi(0,"callback")) k %zi(0,"callback")
 i $d(info("tp",0,"start")),cb="",$$isydb^%mgsqls() s %zo("error")="A callback must be defined for transactions in YottaDB" q -1
 i $d(info("tp",0,"start")) k info("tp",0,"start") tstart
 i $g(%zo("routine"))'="" s @("ok=$$exec^"_%zo("routine")_"(.%zi,.%zo)")
 i $d(info("tp",0,"commit")) k info("tp",0,"commit") i $tlevel>0 tcommit
 i $d(info("tp",0,"rollback")) k info("tp",0,"rollback") i $tlevel>0 trollback
 i cb'="" s @("ok=$$"_cb_"(.%zi,.%zo)")
 q ok
 ;
