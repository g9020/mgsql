%mgsqlz ;(CM) MGSQL : client-server computing ; 12 feb 2002  02:10pm
 ;
 ;  ----------------------------------------------------------------------------
 ;  | MGSQL                                                                    |
 ;  | Author: Chris Munt cmunt@mgateway.com, chris.e.munt@gmail.com            |
 ;  | Copyright (c) 2016-2019 M/Gateway Developments Ltd,                      |
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
 i $g(%zi("stmt"))'="" k ^mgsqls($j,%zi("stmt"))
 q 0
 ;
ss(%zi,%zo,rn) ; server: row of data
 n i
 i $g(%zi("stmt"))'="" d  q 0
 . f i=1:1 q:'$d(%zo(rn,i))  i $g(%zo(0,i,0))="date" s %zo(rn,i)=$$ddate^%mgsqls($g(%zo(rn,i)),1)
 . m ^mgsqls($j,%zi("stmt"),0,rn)=%zo(rn)
 . q
 w ! f i=1:1 q:'$d(%zo(rn,i))  d
 . i i>1 w ","
 . i $g(%zo(0,i,0))="date" w $$ddate^%mgsqls($g(%zo(rn,i)),1) k %zo(rn,i) q
 . i $g(%zo(rn,i))["," w """"_$g(%zo(rn,i))_"""" q
 . w $g(%zo(rn,i))
 . q
 q 0
 ;
sc(%zi,%zo) ; server: close
 i $g(%zi("stmt"))'="" k ^mgsqls($j,%zi("stmt"),1),^mgsqls($j,%zi("stmt"),2),^mgsqls($j,%zi("stmt"),3)
 q 0
 ;