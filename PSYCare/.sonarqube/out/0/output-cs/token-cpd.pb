º
bE:\Master\Sem1\Requirements\Prototype\PSYCare-Backend\PSYCare\PSYCare\Services\WebSocketService.cs
	namespace 	
PSYCare
 
. 
Services 
{ 
public 

	interface 
IWebSocketService &
{ 
void 
Add 
( 
int 
psychologistId #
,# $
	WebSocket% .
socket/ 5
)5 6
;6 7
void		 
Remove		 
(		 
int		 
psychologistId		 &
)		& '
;		' (
bool

 
TryGet

 
(

 
int

 
psychologistId

 &
,

& '
out

( +
	WebSocket

, 5
socket

6 <
)

< =
;

= >
Task !
SendNotificationAsync "
(" #
int# &
psychologistId' 5
,5 6
string7 =
message> E
)E F
;F G
} 
public 

class 
WebSocketService !
:" #
IWebSocketService$ 5
{ 
private 
readonly  
ConcurrentDictionary -
<- .
int. 1
,1 2
	WebSocket3 <
>< =
_sockets> F
=G H
newI L
(L M
)M N
;N O
public 
void 
Add 
( 
int 
psychologistId *
,* +
	WebSocket, 5
socket6 <
)< =
=>> @
_socketsA I
[I J
psychologistIdJ X
]X Y
=Z [
socket\ b
;b c
public 
void 
Remove 
( 
int 
psychologistId -
)- .
=>/ 1
_sockets2 :
.: ;
	TryRemove; D
(D E
psychologistIdE S
,S T
outU X
_Y Z
)Z [
;[ \
public 
bool 
TryGet 
( 
int 
psychologistId -
,- .
out/ 2
	WebSocket3 <
socket= C
)C D
=>E G
_socketsH P
.P Q
TryGetValueQ \
(\ ]
psychologistId] k
,k l
outm p
socketq w
)w x
;x y
public 
async 
Task !
SendNotificationAsync /
(/ 0
int0 3
psychologistId4 B
,B C
stringD J
messageK R
)R S
{ 	
if 
( 
_sockets 
. 
TryGetValue $
($ %
psychologistId% 3
,3 4
out5 8
var9 <
socket= C
)C D
&&E G
socketH N
.N O
StateO T
==U W
WebSocketStateX f
.f g
Openg k
)k l
{ 
var 
bytes 
= 
System "
." #
Text# '
.' (
Encoding( 0
.0 1
UTF81 5
.5 6
GetBytes6 >
(> ?
message? F
)F G
;G H
await 
socket 
. 
	SendAsync &
(& '
new' *
ArraySegment+ 7
<7 8
byte8 <
>< =
(= >
bytes> C
)C D
,D E 
WebSocketMessageTypeF Z
.Z [
Text[ _
,_ `
truea e
,e f
CancellationTokeng x
.x y
Noney }
)} ~
;~ 
} 
} 	
}   
}!! ŸJ
`E:\Master\Sem1\Requirements\Prototype\PSYCare-Backend\PSYCare\PSYCare\Services\SessionService.cs
	namespace 	
PSYCare
 
. 
Services 
{ 
public		 

class		 
SessionService		 
:		  !
ISessionService		" 1
{

 
private 
readonly 
PSYCareDbContext )
_context* 2
;2 3
public 
SessionService 
( 
PSYCareDbContext .
context/ 6
)6 7
{ 	
_context 
= 
context 
; 
} 	
public 
async 
Task 
< 
SessionResponseDto ,
>, -
CreateAsync. 9
(9 :
SessionCreateDto: J
dtoK N
)N O
{ 	
await 
EnsurePatientExists %
(% &
dto& )
.) *
	PatientId* 3
)3 4
;4 5
await $
EnsurePsychologistExists *
(* +
dto+ .
.. /
PsychologistId/ =
)= >
;> ?
var 
session 
= 
new 
Session %
{ 
	PatientId 
= 
dto 
.  
	PatientId  )
,) *
PsychologistId 
=  
dto! $
.$ %
PsychologistId% 3
,3 4
ScheduledAt 
= 
dto !
.! "
ScheduledAt" -
,- .
Notes 
= 
dto 
. 
Notes !
,! "
Status 
= 
dto 
. 
Status #
} 
; 
_context   
.   
Sessions   
.   
Add   !
(  ! "
session  " )
)  ) *
;  * +
await!! 
_context!! 
.!! 
SaveChangesAsync!! +
(!!+ ,
)!!, -
;!!- .
return## 
MapToDto## 
(## 
session## #
)### $
;##$ %
}$$ 	
public&& 
async&& 
Task&& 
<&& 
IReadOnlyList&& '
<&&' (
SessionResponseDto&&( :
>&&: ;
>&&; <
GetByPatientIdAsync&&= P
(&&P Q
int&&Q T
	patientId&&U ^
)&&^ _
{'' 	
var(( 
sessions(( 
=(( 
await((  
_context((! )
.(() *
Sessions((* 2
.)) 
Where)) 
()) 
s)) 
=>)) 
s)) 
.)) 
	PatientId)) '
==))( *
	patientId))+ 4
)))4 5
.** 
OrderByDescending** "
(**" #
s**# $
=>**% '
s**( )
.**) *
ScheduledAt*** 5
)**5 6
.++ 
ToListAsync++ 
(++ 
)++ 
;++ 
return-- 
sessions-- 
.-- 
Select-- "
(--" #
s--# $
=>--% '
MapToDto--( 0
(--0 1
s--1 2
)--2 3
)--3 4
.--4 5
ToList--5 ;
(--; <
)--< =
;--= >
}.. 	
public00 
async00 
Task00 
<00 
IReadOnlyList00 '
<00' (
SessionResponseDto00( :
>00: ;
>00; <$
GetByPsychologistIdAsync00= U
(00U V
int00V Y
psychologistId00Z h
)00h i
{11 	
var22 
sessions22 
=22 
await22  
_context22! )
.22) *
Sessions22* 2
.33 
Where33 
(33 
s33 
=>33 
s33 
.33 
PsychologistId33 ,
==33- /
psychologistId330 >
)33> ?
.44 
OrderBy44 
(44 
s44 
=>44 
s44 
.44  
ScheduledAt44  +
)44+ ,
.55 
ToListAsync55 
(55 
)55 
;55 
return77 
sessions77 
.77 
Select77 "
(77" #
s77# $
=>77% '
MapToDto77( 0
(770 1
s771 2
)772 3
)773 4
.774 5
ToList775 ;
(77; <
)77< =
;77= >
}88 	
public:: 
async:: 
Task:: 
<:: 
SessionResponseDto:: ,
>::, -
GetByIdAsync::. :
(::: ;
int::; >
	sessionId::? H
)::H I
{;; 	
var<< 
session<< 
=<< 
await<< 
GetSessionOrThrow<<  1
(<<1 2
	sessionId<<2 ;
)<<; <
;<<< =
return== 
MapToDto== 
(== 
session== #
)==# $
;==$ %
}>> 	
public@@ 
async@@ 
Task@@ 
ConfirmSessionAsync@@ -
(@@- .
int@@. 1
	sessionId@@2 ;
)@@; <
{AA 	
varBB 
sessionBB 
=BB 
awaitBB 
GetSessionOrThrowBB  1
(BB1 2
	sessionIdBB2 ;
)BB; <
;BB< =
sessionCC 
.CC 
StatusCC 
=CC 
$strCC (
;CC( )
awaitEE 
_contextEE 
.EE 
SaveChangesAsyncEE +
(EE+ ,
)EE, -
;EE- .
}FF 	
publicHH 
asyncHH 
TaskHH 
CancelSessionAsyncHH ,
(HH, -
intHH- 0
	sessionIdHH1 :
)HH: ;
{II 	
varJJ 
sessionJJ 
=JJ 
awaitJJ 
GetSessionOrThrowJJ  1
(JJ1 2
	sessionIdJJ2 ;
)JJ; <
;JJ< =
sessionKK 
.KK 
StatusKK 
=KK 
$strKK (
;KK( )
awaitMM 
_contextMM 
.MM 
SaveChangesAsyncMM +
(MM+ ,
)MM, -
;MM- .
}NN 	
privateRR 
asyncRR 
TaskRR 
EnsurePatientExistsRR .
(RR. /
intRR/ 2
	patientIdRR3 <
)RR< =
{SS 	
ifTT 
(TT 
!TT 
awaitTT 
_contextTT 
.TT  
PatientsTT  (
.TT( )
AnyAsyncTT) 1
(TT1 2
pTT2 3
=>TT4 6
pTT7 8
.TT8 9
IdTT9 ;
==TT< >
	patientIdTT? H
)TTH I
)TTI J
throwUU 
newUU  
KeyNotFoundExceptionUU .
(UU. /
$"UU/ 1
$strUU1 A
{UUA B
	patientIdUUB K
}UUK L
$strUUL V
"UUV W
)UUW X
;UUX Y
}VV 	
privateXX 
asyncXX 
TaskXX $
EnsurePsychologistExistsXX 3
(XX3 4
intXX4 7
psychologistIdXX8 F
)XXF G
{YY 	
ifZZ 
(ZZ 
!ZZ 
awaitZZ 
_contextZZ 
.ZZ  
PsychologistsZZ  -
.ZZ- .
AnyAsyncZZ. 6
(ZZ6 7
pZZ7 8
=>ZZ9 ;
pZZ< =
.ZZ= >
IdZZ> @
==ZZA C
psychologistIdZZD R
)ZZR S
)ZZS T
throw[[ 
new[[  
KeyNotFoundException[[ .
([[. /
$"[[/ 1
$str[[1 F
{[[F G
psychologistId[[G U
}[[U V
$str[[V `
"[[` a
)[[a b
;[[b c
}\\ 	
private^^ 
async^^ 
Task^^ 
<^^ 
Session^^ "
>^^" #
GetSessionOrThrow^^$ 5
(^^5 6
int^^6 9
	sessionId^^: C
)^^C D
{__ 	
var`` 
session`` 
=`` 
await`` 
_context``  (
.``( )
Sessions``) 1
.``1 2
	FindAsync``2 ;
(``; <
	sessionId``< E
)``E F
;``F G
returnaa 
sessionaa 
??aa 
throwaa #
newaa$ ' 
KeyNotFoundExceptionaa( <
(aa< =
$"aa= ?
$straa? O
{aaO P
	sessionIdaaP Y
}aaY Z
$straaZ d
"aad e
)aae f
;aaf g
}bb 	
privateff 
staticff 
SessionResponseDtoff )
MapToDtoff* 2
(ff2 3
Sessionff3 :
sessionff; B
)ffB C
=>ffD F
newgg 
(gg 
)gg 
{hh 
Idii 
=ii 
sessionii 
.ii 
Idii 
,ii  
	PatientIdjj 
=jj 
sessionjj #
.jj# $
	PatientIdjj$ -
,jj- .
PsychologistIdkk 
=kk  
sessionkk! (
.kk( )
PsychologistIdkk) 7
,kk7 8
ScheduledAtll 
=ll 
sessionll %
.ll% &
ScheduledAtll& 1
,ll1 2
Statusmm 
=mm 
sessionmm  
.mm  !
Statusmm! '
,mm' (
Notesnn 
=nn 
sessionnn 
.nn  
Notesnn  %
}oo 
;oo 
}pp 
}qq ã1
fE:\Master\Sem1\Requirements\Prototype\PSYCare-Backend\PSYCare\PSYCare\Services\PsychologistsService.cs
	namespace 	
PSYCare
 
. 
Services 
; 
public		 
class		  
PsychologistsService		 !
:		" #!
IPsychologistsService		$ 9
{

 
private 
readonly 
PSYCareDbContext %
_context& .
;. /
public 
 
PsychologistsService 
(  
PSYCareDbContext  0
context1 8
)8 9
{ 
_context 
= 
context 
; 
} 
public 

async 
Task 
< 
Psychologist "
?" #
># $$
GetPsychologistByIdAsync% =
(= >
int> A
userIdB H
)H I
{ 
var 
dbUser 
= 
await 
_context #
.# $
Psychologists$ 1
.1 2
	FindAsync2 ;
(; <
userId< B
)B C
;C D
return 
dbUser 
is 
null 
? 
null 
: 
MapToServiceModel 
(  
dbUser  &
)& '
;' (
} 
public 

async 
Task 
< 
List 
< 
Patient "
>" #
?# $
>$ %&
GetPatientsForPsychologist& @
(@ A
intA D
idE G
)G H
{ 
var 
patients 
= 
await 
_context %
.% &
Patients& .
. 
Where 
( 
p 
=> 
p 
. 
PsychologistId (
==) +
id, .
). /
. 
Select 
( 
p 
=> 
MapToPatientModel *
(* +
p+ ,
), -
)- .
.   
ToListAsync   
(   
)   
;   
return"" 
patients"" 
."" 
Count"" 
==""  
$num""! "
?""# $
null""% )
:""* +
patients"", 4
;""4 5
}## 
public%% 

async%% 
Task%% 
<%% 
Psychologist%% "
?%%" #
>%%# $#
CreatePsychologistAsync%%% <
(%%< =
Psychologist%%= I
user%%J N
)%%N O
{&& 
var'' 
dbUser'' 
='' 
MapToDbModel'' !
(''! "
user''" &
)''& '
;''' (
_context)) 
.)) 
Psychologists)) 
.)) 
Add)) "
())" #
dbUser))# )
)))) *
;))* +
await** 
_context** 
.** 
SaveChangesAsync** '
(**' (
)**( )
;**) *
return,, 
MapToServiceModel,,  
(,,  !
dbUser,,! '
),,' (
;,,( )
}-- 
public// 

async// 
Task// 
<// 
List// 
<// 
Psychologist// '
>//' (
>//( )$
GetAllPsychologistsAsync//* B
(//B C
)//C D
=>//E G
await00 
_context00 
.00 
Psychologists00 $
.11 
Select11 
(11 
p11 
=>11 
MapToServiceModel11 *
(11* +
p11+ ,
)11, -
)11- .
.22 
ToListAsync22 
(22 
)22 
;22 
private66 
static66 
Psychologist66 
MapToServiceModel66  1
(661 2
DbPsychologist662 @
dbUser66A G
)66G H
=>66I K
new77 
(77 
)77 
{88 	
Id99 
=99 
dbUser99 
.99 
Id99 
,99 
Email:: 
=:: 
dbUser:: 
.:: 
Email::  
,::  !
Name;; 
=;; 
dbUser;; 
.;; 
Name;; 
,;; 
Location<< 
=<< 
dbUser<< 
.<< 
Location<< &
}== 	
;==	 

private?? 
static?? 
DbPsychologist?? !
MapToDbModel??" .
(??. /
Psychologist??/ ;
user??< @
)??@ A
=>??B D
new@@ 
(@@ 
)@@ 
{AA 	
EmailBB 
=BB 
userBB 
.BB 
EmailBB 
,BB 
NameCC 
=CC 
userCC 
.CC 
NameCC 
,CC 
LocationDD 
=DD 
userDD 
.DD 
LocationDD $
,DD$ %
PasswordEE 
=EE 
userEE 
.EE 
PasswordEE $
}FF 	
;FF	 

privateHH 
staticHH 
PatientHH 
MapToPatientModelHH ,
(HH, -
DatabaseHH- 5
.HH5 6
EntitiesHH6 >
.HH> ?
PatientHH? F
pHHG H
)HHH I
=>HHJ L
newII 
(II 
)II 
{JJ 	
IdKK 
=KK 
pKK 
.KK 
IdKK 
,KK 
EmailLL 
=LL 
pLL 
.LL 
EmailLL 
,LL 
NameMM 
=MM 
pMM 
.MM 
NameMM 
,MM 
PhoneNumberNN 
=NN 
pNN 
.NN 
PhoneNumberNN '
,NN' (
LocationOO 
=OO 
pOO 
.OO 
LocationOO !
,OO! "
IssueDescriptionPP 
=PP 
pPP  
.PP  !
IssueDescriptionPP! 1
,PP1 2
AgeQQ 
=QQ 
pQQ 
.QQ 
AgeQQ 
}RR 	
;RR	 

}SS ˇI
aE:\Master\Sem1\Requirements\Prototype\PSYCare-Backend\PSYCare\PSYCare\Services\PatientsService.cs
	namespace 	
PSYCare
 
. 
Services 
; 
public

 
class

 
PatientsService

 
(

 
PSYCareDbContext

 -
context

. 5
)

5 6
:

7 8
IPatientsService

9 I
{ 
public 

async 
Task 
< 
Patient 
? 
> 
GetPatientByIdAsync  3
(3 4
int4 7
userId8 >
)> ?
{ 
var 
dbUser 
= 
await 
context "
." #
Patients# +
.+ ,
	FindAsync, 5
(5 6
userId6 <
)< =
;= >
return 
dbUser 
is 
null 
? 
null  $
:% &

MapToModel' 1
(1 2
dbUser2 8
)8 9
;9 :
} 
public 

async 
Task 
< 
Patient 
? 
> 
CreatePatientAsync  2
(2 3
Patient3 :
user; ?
)? @
{ 
var 
dbUser 
= 
new 
	DbPatient "
{ 	
Email 
= 
user 
. 
Email 
, 
Name 
= 
user 
. 
Name 
, 
PhoneNumber 
= 
user 
. 
PhoneNumber *
,* +
Location 
= 
user 
. 
Location $
,$ %
IssueDescription 
= 
user #
.# $
IssueDescription$ 4
,4 5
Age 
= 
user 
. 
Age 
, 
Password 
= 
user 
. 
Password $
} 	
;	 

context 
. 
Patients 
. 
Add 
( 
dbUser #
)# $
;$ %
await   
context   
.   
SaveChangesAsync   &
(  & '
)  ' (
;  ( )
return"" 

MapToModel"" 
("" 
dbUser""  
)""  !
;""! "
}## 
public%% 

async%% 
Task%% 
<%% 
Psychologist%% "
?%%" #
>%%# $*
GetPsychologistForPatientAsync%%% C
(%%C D
int%%D G
	patientId%%H Q
)%%Q R
{&& 
return'' 
await'' 
context'' 
.'' 
Patients'' %
.(( 
Where(( 
((( 
p(( 
=>(( 
p(( 
.(( 
Id(( 
==(( 
	patientId((  )
)(() *
.)) 
Select)) 
()) 
p)) 
=>)) 
p)) 
.)) 
Psychologist)) '
==))( *
null))+ /
?))0 1
null))2 6
:))7 8
new))9 <
Psychologist))= I
{** 
Email++ 
=++ 
p++ 
.++ 
Psychologist++ &
.++& '
Email++' ,
,++, -
Name,, 
=,, 
p,, 
.,, 
Psychologist,, %
.,,% &
Name,,& *
,,,* +
Location-- 
=-- 
p-- 
.-- 
Psychologist-- )
.--) *
Location--* 2
}.. 
).. 
.// 
FirstOrDefaultAsync//  
(//  !
)//! "
;//" #
}00 
public22 

async22 
Task22 
<22 
bool22 
>22 
DeletePatientAsync22 .
(22. /
int22/ 2
	patientId223 <
)22< =
{33 
var44 
patient44 
=44 
await44 
context44 #
.44# $
Patients44$ ,
.44, -
	FindAsync44- 6
(446 7
	patientId447 @
)44@ A
;44A B
if55 

(55 
patient55 
is55 
null55 
)55 
{66 	
return77 
false77 
;77 
}88 	
patient:: 
.:: 
PsychologistId:: 
=::  
null::! %
;::% &
await;; 
context;; 
.;; 
SaveChangesAsync;; &
(;;& '
);;' (
;;;( )
return<< 
true<< 
;<< 
}== 
public?? 

async?? 
Task?? 
<?? 
bool?? 
>?? ,
 AssignPsychologistToPatientAsync?? <
(??< =
int??= @
	patientId??A J
,??J K
string??L R
psychologistEmail??S d
)??d e
{@@ 
varAA 
patientAA 
=AA 
awaitAA 
contextAA #
.AA# $
PatientsAA$ ,
.AA, -
	FindAsyncAA- 6
(AA6 7
	patientIdAA7 @
)AA@ A
;AAA B
ifBB 

(BB 
patientBB 
isBB 
nullBB 
)BB 
{CC 	
returnDD 
falseDD 
;DD 
}EE 	
varGG 
psychologistGG 
=GG 
awaitGG  
contextGG! (
.GG( )
PsychologistsGG) 6
.HH 
FirstOrDefaultAsyncHH  
(HH  !
pHH! "
=>HH# %
pHH& '
.HH' (
EmailHH( -
==HH. 0
psychologistEmailHH1 B
)HHB C
;HHC D
ifJJ 

(JJ 
psychologistJJ 
isJJ 
nullJJ  
)JJ  !
{KK 	
returnLL 
falseLL 
;LL 
}MM 	
patientOO 
.OO 
PsychologistIdOO 
=OO  
psychologistOO! -
.OO- .
IdOO. 0
;OO0 1
awaitPP 
contextPP 
.PP 
SaveChangesAsyncPP &
(PP& '
)PP' (
;PP( )
returnRR 
trueRR 
;RR 
}SS 
publicUU 

asyncUU 
TaskUU 
<UU 
PatientUU 
?UU 
>UU 
UpdatePatientAsyncUU  2
(UU2 3
intUU3 6
	patientIdUU7 @
,UU@ A
stringUUB H
?UUH I
	diagnosisUUJ S
,UUS T
stringUUU [
?UU[ \
psychologistNotesUU] n
)UUn o
{VV 
varWW 
patientWW 
=WW 
awaitWW 
contextWW #
.WW# $
PatientsWW$ ,
.WW, -
	FindAsyncWW- 6
(WW6 7
	patientIdWW7 @
)WW@ A
;WWA B
ifXX 

(XX 
patientXX 
isXX 
nullXX 
)XX 
{YY 	
returnZZ 
nullZZ 
;ZZ 
}[[ 	
if]] 

(]] 
	diagnosis]] 
is]] 
not]] 
null]] !
)]]! "
patient]]# *
.]]* +
	Diagnosis]]+ 4
=]]5 6
	diagnosis]]7 @
;]]@ A
if^^ 

(^^ 
psychologistNotes^^ 
is^^  
not^^! $
null^^% )
)^^) *
patient^^+ 2
.^^2 3
PsychologistNotes^^3 D
=^^E F
psychologistNotes^^G X
;^^X Y
await`` 
context`` 
.`` 
SaveChangesAsync`` &
(``& '
)``' (
;``( )
returnaa 

MapToModelaa 
(aa 
patientaa !
)aa! "
;aa" #
}bb 
privatedd 
staticdd 
Patientdd 

MapToModeldd %
(dd% &
	DbPatientdd& /
dbUserdd0 6
)dd6 7
=>dd8 :
newdd; >
(dd> ?
)dd? @
{ee 
Idff 

=ff 
dbUserff 
.ff 
Idff 
,ff 
Emailgg 
=gg 
dbUsergg 
.gg 
Emailgg 
,gg 
Namehh 
=hh 
dbUserhh 
.hh 
Namehh 
,hh 
PhoneNumberii 
=ii 
dbUserii 
.ii 
PhoneNumberii (
,ii( )
Locationjj 
=jj 
dbUserjj 
.jj 
Locationjj "
,jj" #
PsychologistIdkk 
=kk 
dbUserkk 
.kk  
PsychologistIdkk  .
,kk. /
IssueDescriptionll 
=ll 
dbUserll !
.ll! "
IssueDescriptionll" 2
,ll2 3
Agemm 
=mm 
dbUsermm 
.mm 
Agemm 
,mm 
	Diagnosisnn 
=nn 
dbUsernn 
.nn 
	Diagnosisnn $
,nn$ %
PsychologistNotesoo 
=oo 
dbUseroo "
.oo" #
PsychologistNotesoo# 4
}pp 
;pp 
}qq ÀD
]E:\Master\Sem1\Requirements\Prototype\PSYCare-Backend\PSYCare\PSYCare\Services\MoodService.cs
	namespace 	
PSYCare
 
. 
Services 
; 
public		 
class		 
MoodService		 
(		 
PSYCareDbContext		 )
db		* ,
)		, -
:		. /
IMoodService		0 <
{

 
public 

async 
Task 
<  
MoodEntryResponseDto *
>* +
CreateAsync, 7
(7 8
int8 ;
	patientId< E
,E F
MoodEntryCreateDtoG Y
dtoZ ]
)] ^
{ 
Validate 
( 
dto 
) 
; 
if 

( 
! 
await 
db 
. 
Patients 
. 
AnyAsync '
(' (
p( )
=>* ,
p- .
.. /
Id/ 1
==2 4
	patientId5 >
)> ?
)? @
throw 
new  
KeyNotFoundException *
(* +
$str+ >
)> ?
;? @
var 
entity 
= 
new 
	MoodEntry "
{ 	
	PatientId 
= 
	patientId !
,! "
Score 
= 
dto 
. 
Score 
, 
Emoji 
= 
Clean 
( 
dto 
. 
Emoji #
)# $
,$ %
Notes 
= 
Clean 
( 
dto 
. 
Notes #
)# $
,$ %
AudioUrl 
= 
Clean 
( 
dto  
.  !
AudioUrl! )
)) *
,* +
	CreatedAt 
= 
DateTimeOffset &
.& '
UtcNow' -
} 	
;	 

db 

.
 
MoodEntries 
. 
Add 
( 
entity !
)! "
;" #
await 
db 
. 
SaveChangesAsync !
(! "
)" #
;# $
return 
ToDto 
( 
entity 
) 
; 
}   
public"" 

async"" 
Task"" 
<"" 
IReadOnlyList"" #
<""# $ 
MoodEntryResponseDto""$ 8
>""8 9
>""9 :
	ListAsync""; D
(""D E
int""E H
	patientId""I R
,""R S
int""T W
limit""X ]
=""^ _
$num""` b
)""b c
=>""d f
await## 
db## 
.## 
MoodEntries## 
.$$ 
Where$$ 
($$ 
m$$ 
=>$$ 
m$$ 
.$$ 
	PatientId$$ #
==$$$ &
	patientId$$' 0
)$$0 1
.%% 
OrderByDescending%% 
(%% 
m%%  
=>%%! #
m%%$ %
.%%% &
	CreatedAt%%& /
)%%/ 0
.&& 
Take&& 
(&& 
Math&& 
.&& 
Clamp&& 
(&& 
limit&& "
,&&" #
$num&&$ %
,&&% &
$num&&' *
)&&* +
)&&+ ,
.'' 
Select'' 
('' 
m'' 
=>'' 
new''  
MoodEntryResponseDto'' 1
(''1 2
m''2 3
.''3 4
Id''4 6
,''6 7
m''8 9
.''9 :
Score'': ?
,''? @
m''A B
.''B C
Emoji''C H
,''H I
m''J K
.''K L
Notes''L Q
,''Q R
m''S T
.''T U
AudioUrl''U ]
,''] ^
m''_ `
.''` a
	CreatedAt''a j
)''j k
)''k l
.(( 
ToListAsync(( 
((( 
)(( 
;(( 
public** 

async** 
Task** 
UpdateAsync** !
(**! "
int**" %
	patientId**& /
,**/ 0
int**1 4
moodId**5 ;
,**; <
MoodEntryCreateDto**= O
dto**P S
)**S T
{++ 
Validate,, 
(,, 
dto,, 
),, 
;,, 
var.. 
entity.. 
=.. 
await.. 
db.. 
... 
MoodEntries.. )
.// 
FirstOrDefaultAsync//  
(//  !
m//! "
=>//# %
m//& '
.//' (
Id//( *
==//+ -
moodId//. 4
&&//5 7
m//8 9
.//9 :
	PatientId//: C
==//D F
	patientId//G P
)//P Q
;//Q R
if11 

(11 
entity11 
is11 
null11 
)11 
throw22 
new22  
KeyNotFoundException22 *
(22* +
$str22+ A
)22A B
;22B C
entity44 
.44 
Score44 
=44 
dto44 
.44 
Score44  
;44  !
entity55 
.55 
Emoji55 
=55 
Clean55 
(55 
dto55  
.55  !
Emoji55! &
)55& '
;55' (
entity66 
.66 
Notes66 
=66 
Clean66 
(66 
dto66  
.66  !
Notes66! &
)66& '
;66' (
entity77 
.77 
AudioUrl77 
=77 
Clean77 
(77  
dto77  #
.77# $
AudioUrl77$ ,
)77, -
;77- .
await99 
db99 
.99 
SaveChangesAsync99 !
(99! "
)99" #
;99# $
}:: 
public<< 

async<< 
Task<< 
DeleteAsync<< !
(<<! "
int<<" %
	patientId<<& /
,<</ 0
int<<1 4
moodId<<5 ;
)<<; <
{== 
var>> 
entity>> 
=>> 
await>> 
db>> 
.>> 
MoodEntries>> )
.?? 
FirstOrDefaultAsync??  
(??  !
m??! "
=>??# %
m??& '
.??' (
Id??( *
==??+ -
moodId??. 4
&&??5 7
m??8 9
.??9 :
	PatientId??: C
==??D F
	patientId??G P
)??P Q
;??Q R
ifAA 

(AA 
entityAA 
isAA 
nullAA 
)AA 
throwBB 
newBB  
KeyNotFoundExceptionBB *
(BB* +
$strBB+ A
)BBA B
;BBB C
dbDD 

.DD
 
MoodEntriesDD 
.DD 
RemoveDD 
(DD 
entityDD $
)DD$ %
;DD% &
awaitEE 
dbEE 
.EE 
SaveChangesAsyncEE !
(EE! "
)EE" #
;EE# $
}FF 
privateHH 
staticHH  
MoodEntryResponseDtoHH '
ToDtoHH( -
(HH- .
	MoodEntryHH. 7
mHH8 9
)HH9 :
=>II 

newII 
(II 
mII 
.II 
IdII 
,II 
mII 
.II 
ScoreII 
,II 
mII 
.II  
EmojiII  %
,II% &
mII' (
.II( )
NotesII) .
,II. /
mII0 1
.II1 2
AudioUrlII2 :
,II: ;
mII< =
.II= >
	CreatedAtII> G
)IIG H
;IIH I
privateKK 
staticKK 
voidKK 
ValidateKK  
(KK  !
MoodEntryCreateDtoKK! 3
dtoKK4 7
)KK7 8
{LL 
ifMM 

(MM 
dtoMM 
.MM 
ScoreMM 
isMM 
<MM 
$numMM 
orMM 
>MM  !
$numMM" $
)MM$ %
throwNN 
newNN 
ArgumentExceptionNN '
(NN' (
$strNN( H
)NNH I
;NNI J
}OO 
privateQQ 
staticQQ 
stringQQ 
?QQ 
CleanQQ  
(QQ  !
stringQQ! '
?QQ' (
sQQ) *
)QQ* +
=>QQ, .
stringQQ/ 5
.QQ5 6
IsNullOrWhiteSpaceQQ6 H
(QQH I
sQQI J
)QQJ K
?QQL M
nullQQN R
:QQS T
sQQU V
.QQV W
TrimQQW [
(QQ[ \
)QQ\ ]
;QQ] ^
}RR Ã
eE:\Master\Sem1\Requirements\Prototype\PSYCare-Backend\PSYCare\PSYCare\Services\Models\Psychologist.cs
	namespace 	
PSYCare
 
. 
Services 
. 
Models !
;! "
public 
class 
Psychologist 
{ 
public 

int 
Id 
{ 
get 
; 
set 
; 
} 
public 

string 
Name 
{ 
get 
; 
set !
;! "
}# $
public 

string 
Email 
{ 
get 
; 
set "
;" #
}$ %
public 

string 
Password 
{ 
get  
;  !
set" %
;% &
}' (
public		 

string		 
?		 
Location		 
{		 
get		 !
;		! "
set		# &
;		& '
}		( )
}

 ∂
`E:\Master\Sem1\Requirements\Prototype\PSYCare-Backend\PSYCare\PSYCare\Services\Models\Patient.cs
	namespace 	
PSYCare
 
. 
Services 
. 
Models !
;! "
public 
class 
Patient 
{ 
public 

int 
Id 
{ 
get 
; 
set 
; 
} 
public 

string 
Name 
{ 
get 
; 
set !
;! "
}# $
public 

string 
Email 
{ 
get 
; 
set "
;" #
}$ %
public 

string 
PhoneNumber 
{ 
get  #
;# $
set% (
;( )
}* +
public		 

string		 
Password		 
{		 
get		  
;		  !
set		" %
;		% &
}		' (
public

 

int

 
?

 
PsychologistId

 
{

  
get

! $
;

$ %
set

& )
;

) *
}

+ ,
public 

string 
? 
Location 
{ 
get !
;! "
set# &
;& '
}( )
public 

string 
? 
IssueDescription #
{$ %
get& )
;) *
set+ .
;. /
}0 1
public 

int 
Age 
{ 
get 
; 
set 
; 
}  
public 

string 
? 
	Diagnosis 
{ 
get "
;" #
set$ '
;' (
}) *
public 

string 
? 
PsychologistNotes $
{% &
get' *
;* +
set, /
;/ 0
}1 2
} ∑5
`E:\Master\Sem1\Requirements\Prototype\PSYCare-Backend\PSYCare\PSYCare\Services\JournalService.cs
	namespace 	
PSYCare
 
. 
Services 
; 
public 
class 
JournalService 
( 
PSYCareDbContext ,
db- /
)/ 0
:1 2
IJournalService3 B
{		 
public

 

async

 
Task

 
<

 #
JournalEntryResponseDto

 -
>

- .
CreateAsync

/ :
(

: ;
int

; >
	patientId

? H
,

H I!
JournalEntryCreateDto

J _
dto

` c
)

c d
{ 
if 

( 
! 
await 
db 
. 
Patients 
. 
AnyAsync '
(' (
p( )
=>* ,
p- .
.. /
Id/ 1
==2 4
	patientId5 >
)> ?
)? @
throw 
new  
KeyNotFoundException *
(* +
$str+ >
)> ?
;? @
var 
entity 
= 
new 
JournalEntry %
{ 	
	PatientId 
= 
	patientId !
,! "
Text 
= 
Clean 
( 
dto 
. 
Text !
)! "
," #
	CreatedAt 
= 
DateTimeOffset &
.& '
UtcNow' -
} 	
;	 

db 

.
 
JournalEntries 
. 
Add 
( 
entity $
)$ %
;% &
await 
db 
. 
SaveChangesAsync !
(! "
)" #
;# $
return 
ToDto 
( 
entity 
) 
; 
} 
public 

async 
Task 
< 
IReadOnlyList #
<# $#
JournalEntryResponseDto$ ;
>; <
>< =
	ListAsync> G
(G H
intH K
	patientIdL U
,U V
intW Z
limit[ `
=a b
$numc e
)e f
=>g i
await 
db 
. 
JournalEntries 
. 
Where 
( 
m 
=> 
m 
. 
	PatientId #
==$ &
	patientId' 0
)0 1
. 
OrderByDescending 
( 
m  
=>! #
m$ %
.% &
	CreatedAt& /
)/ 0
.   
Take   
(   
Math   
.   
Clamp   
(   
limit   "
,  " #
$num  $ %
,  % &
$num  ' *
)  * +
)  + ,
.!! 
Select!! 
(!! 
m!! 
=>!! 
new!! #
JournalEntryResponseDto!! 4
(!!4 5
m!!5 6
.!!6 7
Id!!7 9
,!!9 :
m!!; <
.!!< =
Text!!= A
,!!A B
m!!C D
.!!D E
	CreatedAt!!E N
)!!N O
)!!O P
."" 
ToListAsync"" 
("" 
)"" 
;"" 
public$$ 

async$$ 
Task$$ 
UpdateAsync$$ !
($$! "
int$$" %
	patientId$$& /
,$$/ 0
int$$1 4
entryId$$5 <
,$$< =!
JournalEntryCreateDto$$> S
dto$$T W
)$$W X
{%% 
var&& 
entity&& 
=&& 
await&& 
db&& 
.&& 
JournalEntries&& ,
.'' 
FirstOrDefaultAsync''  
(''  !
m''! "
=>''# %
m''& '
.''' (
Id''( *
==''+ -
entryId''. 5
&&''6 8
m''9 :
.'': ;
	PatientId''; D
==''E G
	patientId''H Q
)''Q R
;''R S
if)) 

()) 
entity)) 
is)) 
null)) 
))) 
throw** 
new**  
KeyNotFoundException** *
(*** +
$str**+ A
)**A B
;**B C
entity,, 
.,, 
Text,, 
=,, 
Clean,, 
(,, 
dto,, 
.,,  
Text,,  $
),,$ %
;,,% &
await-- 
db-- 
.-- 
SaveChangesAsync-- !
(--! "
)--" #
;--# $
}.. 
public00 

async00 
Task00 
DeleteAsync00 !
(00! "
int00" %
	patientId00& /
,00/ 0
int001 4
entryId005 <
)00< =
{11 
var22 
entity22 
=22 
await22 
db22 
.22 
JournalEntries22 ,
.33 
FirstOrDefaultAsync33  
(33  !
m33! "
=>33# %
m33& '
.33' (
Id33( *
==33+ -
entryId33. 5
&&336 8
m339 :
.33: ;
	PatientId33; D
==33E G
	patientId33H Q
)33Q R
;33R S
if55 

(55 
entity55 
is55 
null55 
)55 
throw66 
new66  
KeyNotFoundException66 *
(66* +
$str66+ A
)66A B
;66B C
db88 

.88
 
JournalEntries88 
.88 
Remove88  
(88  !
entity88! '
)88' (
;88( )
await99 
db99 
.99 
SaveChangesAsync99 !
(99! "
)99" #
;99# $
}:: 
private<< 
static<< #
JournalEntryResponseDto<< *
ToDto<<+ 0
(<<0 1
JournalEntry<<1 =
m<<> ?
)<<? @
=>== 

new== 
(== 
m== 
.== 
Id== 
,== 
m== 
.== 
Text== 
,== 
m== 
.== 
	CreatedAt== (
)==( )
;==) *
private?? 
static?? 
string?? 
??? 
Clean??  
(??  !
string??! '
???' (
s??) *
)??* +
=>@@ 

string@@ 
.@@ 
IsNullOrWhiteSpace@@ $
(@@$ %
s@@% &
)@@& '
?@@( )
null@@* .
:@@/ 0
s@@1 2
.@@2 3
Trim@@3 7
(@@7 8
)@@8 9
;@@9 :
}AA ˇ
lE:\Master\Sem1\Requirements\Prototype\PSYCare-Backend\PSYCare\PSYCare\Services\Interfaces\ISessionService.cs
	namespace 	
PSYCare
 
. 
Services 
. 

Interfaces %
{ 
public 

	interface 
ISessionService $
{ 
Task 
< 
SessionResponseDto 
>  
CreateAsync! ,
(, -
SessionCreateDto- =
dto> A
)A B
;B C
Task 
< 
IReadOnlyList 
< 
SessionResponseDto -
>- .
>. /
GetByPatientIdAsync0 C
(C D
intD G
	patientIdH Q
)Q R
;R S
Task		 
<		 
IReadOnlyList		 
<		 
SessionResponseDto		 -
>		- .
>		. /$
GetByPsychologistIdAsync		0 H
(		H I
int		I L
psychologistId		M [
)		[ \
;		\ ]
Task

 
<

 
SessionResponseDto

 
>

  
GetByIdAsync

! -
(

- .
int

. 1
	sessionId

2 ;
)

; <
;

< =
Task 
ConfirmSessionAsync  
(  !
int! $
	sessionId% .
). /
;/ 0
Task 
CancelSessionAsync 
(  
int  #
	sessionId$ -
)- .
;. /
} 
} Œ	
rE:\Master\Sem1\Requirements\Prototype\PSYCare-Backend\PSYCare\PSYCare\Services\Interfaces\IPsychologistsService.cs
	namespace 	
PSYCare
 
. 
Services 
. 

Interfaces %
;% &
public 
	interface !
IPsychologistsService &
{ 
Task 
< 	
Psychologist	 
? 
> $
GetPsychologistByIdAsync 0
(0 1
int1 4
userId5 ;
); <
;< =
Task 
< 	
Psychologist	 
? 
> #
CreatePsychologistAsync /
(/ 0
Psychologist0 <
user= A
)A B
;B C
Task		 
<		 	
List			 
<		 
Patient		 
>		 
?		 
>		 &
GetPatientsForPsychologist		 3
(		3 4
int		4 7
Id		8 :
)		: ;
;		; <
Task

 
<

 	
List

	 
<

 
Psychologist

 
>

 
>

 $
GetAllPsychologistsAsync

 5
(

5 6
)

6 7
;

7 8
} ¡
mE:\Master\Sem1\Requirements\Prototype\PSYCare-Backend\PSYCare\PSYCare\Services\Interfaces\IPatientsService.cs
	namespace 	
PSYCare
 
. 
Services 
. 

Interfaces %
;% &
public 
	interface 
IPatientsService !
{ 
Task 
< 	
Patient	 
? 
> 
GetPatientByIdAsync &
(& '
int' *
userId+ 1
)1 2
;2 3
Task 
< 	
Patient	 
? 
> 
CreatePatientAsync %
(% &
Patient& -
user. 2
)2 3
;3 4
Task		 
<		 	
Psychologist			 
?		 
>		 *
GetPsychologistForPatientAsync		 6
(		6 7
int		7 :
	patientId		; D
)		D E
;		E F
Task

 
<

 	
bool

	 
>

 ,
 AssignPsychologistToPatientAsync

 /
(

/ 0
int

0 3
	patientId

4 =
,

= >
string

? E
psychologistEmail

F W
)

W X
;

X Y
Task 
< 	
bool	 
> 
DeletePatientAsync !
(! "
int" %
	patientId& /
)/ 0
;0 1
Task 
< 	
Patient	 
? 
> 
UpdatePatientAsync %
(% &
int& )
	patientId* 3
,3 4
string5 ;
	diagnosis< E
,E F
stringG M
psychologistNotesN _
)_ `
;` a
} —

iE:\Master\Sem1\Requirements\Prototype\PSYCare-Backend\PSYCare\PSYCare\Services\Interfaces\IMoodService.cs
	namespace 	
PSYCare
 
. 
Services 
. 

Interfaces %
{ 
public 

	interface 
IMoodService !
{ 
Task 
<  
MoodEntryResponseDto !
>! "
CreateAsync# .
(. /
int/ 2
	patientId3 <
,< =
MoodEntryCreateDto> P
dtoQ T
)T U
;U V
Task 
< 
IReadOnlyList 
<  
MoodEntryResponseDto /
>/ 0
>0 1
	ListAsync2 ;
(; <
int< ?
	patientId@ I
,I J
intK N
limitO T
=U V
$numW Y
)Y Z
;Z [
Task		 
UpdateAsync		 
(		 
int		 
	patientId		 &
,		& '
int		( +
moodId		, 2
,		2 3
MoodEntryCreateDto		4 F
dto		G J
)		J K
;		K L
Task

 
DeleteAsync

 
(

 
int

 
	patientId

 &
,

& '
int

( +
moodId

, 2
)

2 3
;

3 4
} 
} æ

lE:\Master\Sem1\Requirements\Prototype\PSYCare-Backend\PSYCare\PSYCare\Services\Interfaces\IJournalService.cs
	namespace 	
PSYCare
 
. 
Services 
{ 
public 

	interface 
IJournalService $
{ 
Task 
< #
JournalEntryResponseDto $
>$ %
CreateAsync& 1
(1 2
int2 5
	patientId6 ?
,? @!
JournalEntryCreateDtoA V
dtoW Z
)Z [
;[ \
Task 
< 
IReadOnlyList 
< #
JournalEntryResponseDto 2
>2 3
>3 4
	ListAsync5 >
(> ?
int? B
	patientIdC L
,L M
intN Q
limitR W
=X Y
$numZ \
)\ ]
;] ^
Task		 
UpdateAsync		 
(		 
int		 
	patientId		 &
,		& '
int		( +
entryId		, 3
,		3 4!
JournalEntryCreateDto		5 J
dto		K N
)		N O
;		O P
Task

 
DeleteAsync

 
(

 
int

 
	patientId

 &
,

& '
int

( +
entryId

, 3
)

3 4
;

4 5
} 
} ¶
kE:\Master\Sem1\Requirements\Prototype\PSYCare-Backend\PSYCare\PSYCare\Services\Interfaces\ICrisisService.cs
	namespace 	
PSYCare
 
. 
Services 
. 

Interfaces %
{ 
public 

	interface 
ICrisisService #
{ 
Task 
< 
bool 
> +
NotifyPsychologistOfCrisisAsync 2
(2 3
int3 6
	patientId7 @
)@ A
;A B
} 
} Ñ
iE:\Master\Sem1\Requirements\Prototype\PSYCare-Backend\PSYCare\PSYCare\Services\Interfaces\IAuthService.cs
	namespace 	
PSYCare
 
. 
Services 
. 

Interfaces %
;% &
public 
	interface 
IAuthService 
{ 
Task 
< 	
object	 
? 
> 

LoginAsync 
( 
string #
email$ )
,) *
string+ 1
password2 :
): ;
;; <
Task 
< 	
object	 
? 
> 
GetUserByIdAsync "
(" #
int# &
id' )
)) *
;* +
} Í
_E:\Master\Sem1\Requirements\Prototype\PSYCare-Backend\PSYCare\PSYCare\Services\CrisisService.cs
	namespace 	
PSYCare
 
. 
Services 
{ 
public 

class 
CrisisService 
( 
IPatientsService /
patientsService0 ?
,? @
IWebSocketServiceA R
webSocketServiceS c
)c d
:e f
ICrisisServiceg u
{ 
private 
readonly 
IPatientsService )
_patientsService* :
=; <
patientsService= L
;L M
private 
readonly 
IWebSocketService *
_webSocketService+ <
== >
webSocketService? O
;O P
public

 
async

 
Task

 
<

 
bool

 
>

 +
NotifyPsychologistOfCrisisAsync

  ?
(

? @
int

@ C
	patientId

D M
)

M N
{ 	
var 
patient 
= 
await 
_patientsService  0
.0 1
GetPatientByIdAsync1 D
(D E
	patientIdE N
)N O
;O P
if 
( 
patient 
is 
null 
)  
return! '
false( -
;- .
if 
( 
patient 
. 
PsychologistId &
.& '
HasValue' /
)/ 0
{ 
var 
message 
= 
$"  
$str  (
{( )
patient) 0
.0 1
Name1 5
}5 6
$str6 p
{p q
patientq x
.x y
PhoneNumber	y Ñ
}
Ñ Ö
"
Ö Ü
;
Ü á
await 
_webSocketService '
.' (!
SendNotificationAsync( =
(= >
patient> E
.E F
PsychologistIdF T
.T U
ValueU Z
,Z [
message\ c
)c d
;d e
} 
return 
true 
; 
} 	
} 
} ™
]E:\Master\Sem1\Requirements\Prototype\PSYCare-Backend\PSYCare\PSYCare\Services\AuthService.cs
	namespace 	
PSYCare
 
. 
Services 
; 
public 
class 
AuthService 
( 
PSYCareDbContext 
context 
, 
IPatientsService		 
patientsService		 $
,		$ %!
IPsychologistsService

  
psychologistsService

 .
)

. /
:

0 1
IAuthService

2 >
{ 
public 

async 
Task 
< 
object 
? 
> 

LoginAsync )
() *
string* 0
email1 6
,6 7
string8 >
password? G
)G H
{ 
var 
patient 
= 
await 
context #
.# $
Patients$ ,
. 
FirstOrDefaultAsync  
(  !
x! "
=># %
x& '
.' (
Email( -
==. 0
email1 6
&&7 9
x: ;
.; <
Password< D
==E G
passwordH P
)P Q
;Q R
if 

( 
patient 
is 
not 
null 
)  
{ 	
return 
new 
{ 
role 
= 
$str  )
,) *
data+ /
=0 1
patient2 9
}: ;
;; <
} 	
var 
psychologist 
= 
await  
context! (
.( )
Psychologists) 6
. 
FirstOrDefaultAsync  
(  !
x! "
=># %
x& '
.' (
Email( -
==. 0
email1 6
&&7 9
x: ;
.; <
Password< D
==E G
passwordH P
)P Q
;Q R
return 
psychologist 
is 
not "
null# '
? 
new 
{ 
role 
= 
$str )
,) *
data+ /
=0 1
psychologist2 >
}? @
: 
null 
; 
} 
public 

async 
Task 
< 
object 
? 
> 
GetUserByIdAsync /
(/ 0
int0 3
id4 6
)6 7
{ 
var   
psychologist   
=   
await     
psychologistsService  ! 5
.  5 6$
GetPsychologistByIdAsync  6 N
(  N O
id  O Q
)  Q R
;  R S
if!! 

(!! 
psychologist!! 
is!! 
not!! 
null!!  $
)!!$ %
{"" 	
return## 
new## 
{## 
type## 
=## 
$str##  .
,##. /
data##0 4
=##5 6
psychologist##7 C
}##D E
;##E F
}$$ 	
var&& 
patient&& 
=&& 
await&& 
patientsService&& +
.&&+ ,
GetPatientByIdAsync&&, ?
(&&? @
id&&@ B
)&&B C
;&&C D
if'' 

('' 
patient'' 
is'' 
not'' 
null'' 
)''  
{(( 	
return)) 
new)) 
{)) 
type)) 
=)) 
$str))  )
,))) *
data))+ /
=))0 1
patient))2 9
})): ;
;)); <
}** 	
return,, 
null,, 
;,, 
}-- 
}.. äA
PE:\Master\Sem1\Requirements\Prototype\PSYCare-Backend\PSYCare\PSYCare\Program.cs
var		 
builder		 
=		 
WebApplication		 
.		 
CreateBuilder		 *
(		* +
args		+ /
)		/ 0
;		0 1
builder 
. 
Services 
. 
AddCors 
( 
options  
=>! #
{ 
options 
. 
AddDefaultPolicy 
( 
policy #
=>$ &
{ 
policy 
. 
WithOrigins 
( 
$str 2
)2 3
. 
AllowAnyHeader 
( 
) 
. 
AllowAnyMethod 
( 
) 
;  
} 
) 
; 
} 
) 
; 
builder 
. 
Services 
. 
AddDbContext 
< 
PSYCareDbContext .
>. /
(/ 0
options0 7
=>8 :
options 
. 
	UseNpgsql 
( 
builder 
. 
Configuration +
.+ ,
GetConnectionString, ?
(? @
$str@ S
)S T
)T U
)U V
;V W
builder 
. 
Services 
. 
	AddScoped 
< 
IAuthService '
,' (
AuthService) 4
>4 5
(5 6
)6 7
;7 8
builder 
. 
Services 
. 
	AddScoped 
< 
IPatientsService +
,+ ,
PatientsService- <
>< =
(= >
)> ?
;? @
builder 
. 
Services 
. 
	AddScoped 
< !
IPsychologistsService 0
,0 1 
PsychologistsService2 F
>F G
(G H
)H I
;I J
builder 
. 
Services 
. 
	AddScoped 
< 
IMoodService '
,' (
MoodService) 4
>4 5
(5 6
)6 7
;7 8
builder 
. 
Services 
. 
	AddScoped 
< 
ISessionService *
,* +
SessionService, :
>: ;
(; <
)< =
;= >
builder 
. 
Services 
. 
	AddScoped 
< 
IJournalService *
,* +
JournalService, :
>: ;
(; <
)< =
;= >
builder 
. 
Services 
. 
AddSingleton 
< 
IWebSocketService /
,/ 0
WebSocketService1 A
>A B
(B C
)C D
;D E
builder   
.   
Services   
.   
AddControllers   
(    
)    !
;  ! "
builder"" 
."" 
Services"" 
."" #
AddEndpointsApiExplorer"" (
(""( )
)"") *
;""* +
builder## 
.## 
Services## 
.## 
AddSwaggerGen## 
(## 
)##  
;##  !
var$$ 
app$$ 
=$$ 	
builder$$
 
.$$ 
Build$$ 
($$ 
)$$ 
;$$ 
app'' 
.'' 
UseWebSockets'' 
('' 
)'' 
;'' 
var)) 
webSocketClients)) 
=)) 
new)) 

Dictionary)) %
<))% &
int))& )
,))) *
	WebSocket))+ 4
>))4 5
())5 6
)))6 7
;))7 8
app++ 
.++ 
Map++ 
(++ 
$str++ 
,++ 
async++ 
context++ 
=>++ 
{,, 
if-- 
(-- 
context-- 
.-- 

WebSockets-- 
.-- 
IsWebSocketRequest-- -
)--- .
{.. 
var// 
	wsManager// 
=// 
context// 
.//  
RequestServices//  /
./// 0
GetRequiredService//0 B
<//B C
IWebSocketService//C T
>//T U
(//U V
)//V W
;//W X
var00 
	webSocket00 
=00 
await00 
context00 %
.00% &

WebSockets00& 0
.000 1 
AcceptWebSocketAsync001 E
(00E F
)00F G
;00G H
var22 
psychologistIdStr22 
=22 
context22  '
.22' (
Request22( /
.22/ 0
Query220 5
[225 6
$str226 F
]22F G
;22G H
if33 

(33 
!33 
int33 
.33 
TryParse33 
(33 
psychologistIdStr33 +
,33+ ,
out33- 0
int331 4
psychologistId335 C
)33C D
)33D E
{44 	
await55 
	webSocket55 
.55 

CloseAsync55 &
(55& ' 
WebSocketCloseStatus55' ;
.55; <
InvalidPayloadData55< N
,55N O
$str55P \
,55\ ]
CancellationToken55^ o
.55o p
None55p t
)55t u
;55u v
return66 
;66 
}77 	
	wsManager99 
.99 
Add99 
(99 
psychologistId99 $
,99$ %
	webSocket99& /
)99/ 0
;990 1
var;; 
buffer;; 
=;; 
new;; 
byte;; 
[;; 
$num;; "
*;;# $
$num;;% &
];;& '
;;;' (
while<< 
(<< 
	webSocket<< 
.<< 
State<< 
==<< !
WebSocketState<<" 0
.<<0 1
Open<<1 5
)<<5 6
{== 	
var>> 
result>> 
=>> 
await>> 
	webSocket>> (
.>>( )
ReceiveAsync>>) 5
(>>5 6
new>>6 9
ArraySegment>>: F
<>>F G
byte>>G K
>>>K L
(>>L M
buffer>>M S
)>>S T
,>>T U
CancellationToken>>V g
.>>g h
None>>h l
)>>l m
;>>m n
if@@ 
(@@ 
result@@ 
.@@ 
MessageType@@ "
==@@# % 
WebSocketMessageType@@& :
.@@: ;
Close@@; @
)@@@ A
{AA 
	wsManagerBB 
.BB 
RemoveBB  
(BB  !
psychologistIdBB! /
)BB/ 0
;BB0 1
awaitCC 
	webSocketCC 
.CC  

CloseAsyncCC  *
(CC* + 
WebSocketCloseStatusCC+ ?
.CC? @
NormalClosureCC@ M
,CCM N
stringCCO U
.CCU V
EmptyCCV [
,CC[ \
CancellationTokenCC] n
.CCn o
NoneCCo s
)CCs t
;CCt u
}DD 
}EE 	
}FF 
}GG 
)GG 
;GG 
appII 
.II 
UseCorsII 
(II 
)II 
;II 
ifLL 
(LL 
appLL 
.LL 
EnvironmentLL 
.LL 
IsDevelopmentLL !
(LL! "
)LL" #
)LL# $
{MM 
appNN 
.NN 

UseSwaggerNN 
(NN 
)NN 
;NN 
appOO 
.OO 
UseSwaggerUIOO 
(OO 
)OO 
;OO 
}PP 
appRR 
.RR 
UseHttpsRedirectionRR 
(RR 
)RR 
;RR 
appTT 
.TT 
UseAuthorizationTT 
(TT 
)TT 
;TT 
appVV 
.VV 
MapControllersVV 
(VV 
)VV 
;VV 
appXX 
.XX 
RunXX 
(XX 
)XX 	
;XX	 
¶
vE:\Master\Sem1\Requirements\Prototype\PSYCare-Backend\PSYCare\PSYCare\Migrations\20260113212019_UpdateFieldsPatient.cs
	namespace 	
PSYCare
 
. 

Migrations 
{ 
public 

partial 
class 
UpdateFieldsPatient ,
:- .
	Migration/ 8
{		 
	protected 
override 
void 
Up  "
(" #
MigrationBuilder# 3
migrationBuilder4 D
)D E
{ 	
migrationBuilder 
. 
	AddColumn &
<& '
string' -
>- .
(. /
name 
: 
$str !
,! "
table 
: 
$str !
,! "
type 
: 
$str 
, 
nullable 
: 
true 
) 
;  
migrationBuilder 
. 
	AddColumn &
<& '
string' -
>- .
(. /
name 
: 
$str )
,) *
table 
: 
$str !
,! "
type 
: 
$str 
, 
nullable 
: 
true 
) 
;  
} 	
	protected 
override 
void 
Down  $
($ %
MigrationBuilder% 5
migrationBuilder6 F
)F G
{ 	
migrationBuilder 
. 

DropColumn '
(' (
name 
: 
$str !
,! "
table 
: 
$str !
)! "
;" #
migrationBuilder!! 
.!! 

DropColumn!! '
(!!' (
name"" 
:"" 
$str"" )
,"") *
table## 
:## 
$str## !
)##! "
;##" #
}$$ 	
}%% 
}&& Ù
jE:\Master\Sem1\Requirements\Prototype\PSYCare-Backend\PSYCare\PSYCare\Migrations\20260111211720_Journal.cs
	namespace 	
PSYCare
 
. 

Migrations 
{ 
public

 

partial

 
class

 
Journal

  
:

! "
	Migration

# ,
{ 
	protected 
override 
void 
Up  "
(" #
MigrationBuilder# 3
migrationBuilder4 D
)D E
{ 	
migrationBuilder 
. 
CreateTable (
(( )
name 
: 
$str &
,& '
columns 
: 
table 
=> !
new" %
{ 
Id 
= 
table 
. 
Column %
<% &
int& )
>) *
(* +
type+ /
:/ 0
$str1 :
,: ;
nullable< D
:D E
falseF K
)K L
. 

Annotation #
(# $
$str$ D
,D E)
NpgsqlValueGenerationStrategyF c
.c d#
IdentityByDefaultColumnd {
){ |
,| }
	PatientId 
= 
table  %
.% &
Column& ,
<, -
int- 0
>0 1
(1 2
type2 6
:6 7
$str8 A
,A B
nullableC K
:K L
falseM R
)R S
,S T
Text 
= 
table  
.  !
Column! '
<' (
string( .
>. /
(/ 0
type0 4
:4 5
$str6 <
,< =
nullable> F
:F G
trueH L
)L M
,M N
	CreatedAt 
= 
table  %
.% &
Column& ,
<, -
DateTimeOffset- ;
>; <
(< =
type= A
:A B
$strC ]
,] ^
nullable_ g
:g h
falsei n
)n o
} 
, 
constraints 
: 
table "
=># %
{ 
table 
. 

PrimaryKey $
($ %
$str% 8
,8 9
x: ;
=>< >
x? @
.@ A
IdA C
)C D
;D E
table 
. 

ForeignKey $
($ %
name 
: 
$str D
,D E
column 
: 
x  !
=>" $
x% &
.& '
	PatientId' 0
,0 1
principalTable &
:& '
$str( 2
,2 3
principalColumn   '
:  ' (
$str  ) -
,  - .
onDelete!!  
:!!  !
ReferentialAction!!" 3
.!!3 4
Cascade!!4 ;
)!!; <
;!!< =
}"" 
)"" 
;"" 
migrationBuilder$$ 
.$$ 
CreateIndex$$ (
($$( )
name%% 
:%% 
$str%% 3
,%%3 4
table&& 
:&& 
$str&& '
,&&' (
column'' 
:'' 
$str'' #
)''# $
;''$ %
}(( 	
	protected++ 
override++ 
void++ 
Down++  $
(++$ %
MigrationBuilder++% 5
migrationBuilder++6 F
)++F G
{,, 	
migrationBuilder-- 
.-- 
	DropTable-- &
(--& '
name.. 
:.. 
$str.. &
)..& '
;..' (
}// 	
}00 
}11 ‹*
sE:\Master\Sem1\Requirements\Prototype\PSYCare-Backend\PSYCare\PSYCare\Migrations\20260110190005_AddSessionsTable.cs
	namespace 	
PSYCare
 
. 

Migrations 
{ 
public

 

partial

 
class

 
AddSessionsTable

 )
:

* +
	Migration

, 5
{ 
	protected 
override 
void 
Up  "
(" #
MigrationBuilder# 3
migrationBuilder4 D
)D E
{ 	
migrationBuilder 
. 
CreateTable (
(( )
name 
: 
$str  
,  !
columns 
: 
table 
=> !
new" %
{ 
Id 
= 
table 
. 
Column %
<% &
int& )
>) *
(* +
type+ /
:/ 0
$str1 :
,: ;
nullable< D
:D E
falseF K
)K L
. 

Annotation #
(# $
$str$ D
,D E)
NpgsqlValueGenerationStrategyF c
.c d#
IdentityByDefaultColumnd {
){ |
,| }
	PatientId 
= 
table  %
.% &
Column& ,
<, -
int- 0
>0 1
(1 2
type2 6
:6 7
$str8 A
,A B
nullableC K
:K L
falseM R
)R S
,S T
PsychologistId "
=# $
table% *
.* +
Column+ 1
<1 2
int2 5
>5 6
(6 7
type7 ;
:; <
$str= F
,F G
nullableH P
:P Q
falseR W
)W X
,X Y
ScheduledAt 
=  !
table" '
.' (
Column( .
<. /
DateTime/ 7
>7 8
(8 9
type9 =
:= >
$str? Y
,Y Z
nullable[ c
:c d
falsee j
)j k
,k l
Status 
= 
table "
." #
Column# )
<) *
string* 0
>0 1
(1 2
type2 6
:6 7
$str8 O
,O P
	maxLengthQ Z
:Z [
$num\ ^
,^ _
nullable` h
:h i
falsej o
)o p
,p q
Notes 
= 
table !
.! "
Column" (
<( )
string) /
>/ 0
(0 1
type1 5
:5 6
$str7 P
,P Q
	maxLengthR [
:[ \
$num] a
,a b
nullablec k
:k l
truem q
)q r
} 
, 
constraints 
: 
table "
=># %
{ 
table 
. 

PrimaryKey $
($ %
$str% 2
,2 3
x4 5
=>6 8
x9 :
.: ;
Id; =
)= >
;> ?
table 
. 

ForeignKey $
($ %
name 
: 
$str >
,> ?
column   
:   
x    !
=>  " $
x  % &
.  & '
	PatientId  ' 0
,  0 1
principalTable!! &
:!!& '
$str!!( 2
,!!2 3
principalColumn"" '
:""' (
$str"") -
,""- .
onDelete##  
:##  !
ReferentialAction##" 3
.##3 4
Cascade##4 ;
)##; <
;##< =
table$$ 
.$$ 

ForeignKey$$ $
($$$ %
name%% 
:%% 
$str%% H
,%%H I
column&& 
:&& 
x&&  !
=>&&" $
x&&% &
.&&& '
PsychologistId&&' 5
,&&5 6
principalTable'' &
:''& '
$str''( 7
,''7 8
principalColumn(( '
:((' (
$str(() -
,((- .
onDelete))  
:))  !
ReferentialAction))" 3
.))3 4
Cascade))4 ;
))); <
;))< =
}** 
)** 
;** 
migrationBuilder,, 
.,, 
CreateIndex,, (
(,,( )
name-- 
:-- 
$str-- -
,--- .
table.. 
:.. 
$str.. !
,..! "
column// 
:// 
$str// #
)//# $
;//$ %
migrationBuilder11 
.11 
CreateIndex11 (
(11( )
name22 
:22 
$str22 2
,222 3
table33 
:33 
$str33 !
,33! "
column44 
:44 
$str44 (
)44( )
;44) *
}55 	
	protected88 
override88 
void88 
Down88  $
(88$ %
MigrationBuilder88% 5
migrationBuilder886 F
)88F G
{99 	
migrationBuilder:: 
.:: 
	DropTable:: &
(::& '
name;; 
:;; 
$str;;  
);;  !
;;;! "
}<< 	
}== 
}>> ’&
qE:\Master\Sem1\Requirements\Prototype\PSYCare-Backend\PSYCare\PSYCare\Migrations\20260108164849_AddMoodEntries.cs
	namespace 	
PSYCare
 
. 

Migrations 
{ 
public

 

partial

 
class

 
AddMoodEntries

 '
:

( )
	Migration

* 3
{ 
	protected 
override 
void 
Up  "
(" #
MigrationBuilder# 3
migrationBuilder4 D
)D E
{ 	
migrationBuilder 
. 
CreateTable (
(( )
name 
: 
$str $
,$ %
columns 
: 
table 
=> !
new" %
{ 
Id 
= 
table 
. 
Column %
<% &
int& )
>) *
(* +
type+ /
:/ 0
$str1 :
,: ;
nullable< D
:D E
falseF K
)K L
. 

Annotation #
(# $
$str$ D
,D E)
NpgsqlValueGenerationStrategyF c
.c d#
IdentityByDefaultColumnd {
){ |
,| }
	PatientId 
= 
table  %
.% &
Column& ,
<, -
int- 0
>0 1
(1 2
type2 6
:6 7
$str8 A
,A B
nullableC K
:K L
falseM R
)R S
,S T
Score 
= 
table !
.! "
Column" (
<( )
int) ,
>, -
(- .
type. 2
:2 3
$str4 =
,= >
nullable? G
:G H
falseI N
)N O
,O P
Emoji 
= 
table !
.! "
Column" (
<( )
string) /
>/ 0
(0 1
type1 5
:5 6
$str7 =
,= >
nullable? G
:G H
trueI M
)M N
,N O
Notes 
= 
table !
.! "
Column" (
<( )
string) /
>/ 0
(0 1
type1 5
:5 6
$str7 =
,= >
nullable? G
:G H
trueI M
)M N
,N O
AudioUrl 
= 
table $
.$ %
Column% +
<+ ,
string, 2
>2 3
(3 4
type4 8
:8 9
$str: @
,@ A
nullableB J
:J K
trueL P
)P Q
,Q R
	CreatedAt 
= 
table  %
.% &
Column& ,
<, -
DateTimeOffset- ;
>; <
(< =
type= A
:A B
$strC ]
,] ^
nullable_ g
:g h
falsei n
,n o
defaultValueSqlp 
:	 Ä
$str
Å à
)
à â
} 
, 
constraints 
: 
table "
=># %
{ 
table 
. 

PrimaryKey $
($ %
$str% 6
,6 7
x8 9
=>: <
x= >
.> ?
Id? A
)A B
;B C
table 
. 

ForeignKey $
($ %
name   
:   
$str   B
,  B C
column!! 
:!! 
x!!  !
=>!!" $
x!!% &
.!!& '
	PatientId!!' 0
,!!0 1
principalTable"" &
:""& '
$str""( 2
,""2 3
principalColumn## '
:##' (
$str##) -
,##- .
onDelete$$  
:$$  !
ReferentialAction$$" 3
.$$3 4
Cascade$$4 ;
)$$; <
;$$< =
}%% 
)%% 
;%% 
migrationBuilder'' 
.'' 
CreateIndex'' (
(''( )
name(( 
:(( 
$str(( ;
,((; <
table)) 
:)) 
$str)) %
,))% &
columns** 
:** 
new** 
[** 
]** 
{**  
$str**! ,
,**, -
$str**. 9
}**: ;
)**; <
;**< =
}++ 	
	protected.. 
override.. 
void.. 
Down..  $
(..$ %
MigrationBuilder..% 5
migrationBuilder..6 F
)..F G
{// 	
migrationBuilder00 
.00 
	DropTable00 &
(00& '
name11 
:11 
$str11 $
)11$ %
;11% &
}22 	
}33 
}44 ∫@
wE:\Master\Sem1\Requirements\Prototype\PSYCare-Backend\PSYCare\PSYCare\Migrations\20260108123930_UpdateEntitiesFields.cs
	namespace 	
PSYCare
 
. 

Migrations 
{ 
public 

partial 
class  
UpdateEntitiesFields -
:. /
	Migration0 9
{		 
	protected 
override 
void 
Up  "
(" #
MigrationBuilder# 3
migrationBuilder4 D
)D E
{ 	
migrationBuilder 
. 
DropForeignKey +
(+ ,
name 
: 
$str @
,@ A
table 
: 
$str !
)! "
;" #
migrationBuilder 
. 
	DropIndex &
(& '
name 
: 
$str )
,) *
table 
: 
$str !
)! "
;" #
migrationBuilder 
. 

DropColumn '
(' (
name 
: 
$str 
,  
table 
: 
$str !
)! "
;" #
migrationBuilder 
. 
RenameColumn )
() *
name 
: 
$str 
,  
table 
: 
$str !
,! "
newName 
: 
$str +
)+ ,
;, -
migrationBuilder 
. 
AlterColumn (
<( )
int) ,
>, -
(- .
name 
: 
$str &
,& '
table   
:   
$str   !
,  ! "
type!! 
:!! 
$str!! 
,!!  
nullable"" 
:"" 
true"" 
,"" 

oldClrType## 
:## 
typeof## "
(##" #
int### &
)##& '
,##' (
oldType$$ 
:$$ 
$str$$ "
)$$" #
;$$# $
migrationBuilder&& 
.&& 
AlterColumn&& (
<&&( )
string&&) /
>&&/ 0
(&&0 1
name'' 
:'' 
$str'' 
,'' 
table(( 
:(( 
$str(( !
,((! "
type)) 
:)) 
$str)) 
,)) 
nullable** 
:** 
false** 
,**  

oldClrType++ 
:++ 
typeof++ "
(++" #
string++# )
)++) *
,++* +
oldType,, 
:,, 
$str,, 1
,,,1 2
oldMaxLength-- 
:-- 
$num-- !
)--! "
;--" #
migrationBuilder// 
.// 
AlterColumn// (
<//( )
string//) /
>/// 0
(//0 1
name00 
:00 
$str00 
,00 
table11 
:11 
$str11 !
,11! "
type22 
:22 
$str22 
,22 
nullable33 
:33 
false33 
,33  

oldClrType44 
:44 
typeof44 "
(44" #
string44# )
)44) *
,44* +
oldType55 
:55 
$str55 1
,551 2
oldMaxLength66 
:66 
$num66 !
)66! "
;66" #
migrationBuilder88 
.88 
AddForeignKey88 *
(88* +
name99 
:99 
$str99 @
,99@ A
table:: 
::: 
$str:: !
,::! "
column;; 
:;; 
$str;; (
,;;( )
principalTable<< 
:<< 
$str<<  /
,<</ 0
principalColumn== 
:==  
$str==! %
)==% &
;==& '
}>> 	
	protectedAA 
overrideAA 
voidAA 
DownAA  $
(AA$ %
MigrationBuilderAA% 5
migrationBuilderAA6 F
)AAF G
{BB 	
migrationBuilderCC 
.CC 
DropForeignKeyCC +
(CC+ ,
nameDD 
:DD 
$strDD @
,DD@ A
tableEE 
:EE 
$strEE !
)EE! "
;EE" #
migrationBuilderGG 
.GG 
RenameColumnGG )
(GG) *
nameHH 
:HH 
$strHH (
,HH( )
tableII 
:II 
$strII !
,II! "
newNameJJ 
:JJ 
$strJJ "
)JJ" #
;JJ# $
migrationBuilderLL 
.LL 
AlterColumnLL (
<LL( )
intLL) ,
>LL, -
(LL- .
nameMM 
:MM 
$strMM &
,MM& '
tableNN 
:NN 
$strNN !
,NN! "
typeOO 
:OO 
$strOO 
,OO  
nullablePP 
:PP 
falsePP 
,PP  
defaultValueQQ 
:QQ 
$numQQ 
,QQ  

oldClrTypeRR 
:RR 
typeofRR "
(RR" #
intRR# &
)RR& '
,RR' (
oldTypeSS 
:SS 
$strSS "
,SS" #
oldNullableTT 
:TT 
trueTT !
)TT! "
;TT" #
migrationBuilderVV 
.VV 
AlterColumnVV (
<VV( )
stringVV) /
>VV/ 0
(VV0 1
nameWW 
:WW 
$strWW 
,WW 
tableXX 
:XX 
$strXX !
,XX! "
typeYY 
:YY 
$strYY .
,YY. /
	maxLengthZZ 
:ZZ 
$numZZ 
,ZZ 
nullable[[ 
:[[ 
false[[ 
,[[  

oldClrType\\ 
:\\ 
typeof\\ "
(\\" #
string\\# )
)\\) *
,\\* +
oldType]] 
:]] 
$str]] 
)]]  
;]]  !
migrationBuilder__ 
.__ 
AlterColumn__ (
<__( )
string__) /
>__/ 0
(__0 1
name`` 
:`` 
$str`` 
,`` 
tableaa 
:aa 
$straa !
,aa! "
typebb 
:bb 
$strbb .
,bb. /
	maxLengthcc 
:cc 
$numcc 
,cc 
nullabledd 
:dd 
falsedd 
,dd  

oldClrTypeee 
:ee 
typeofee "
(ee" #
stringee# )
)ee) *
,ee* +
oldTypeff 
:ff 
$strff 
)ff  
;ff  !
migrationBuilderhh 
.hh 
	AddColumnhh &
<hh& '
stringhh' -
>hh- .
(hh. /
nameii 
:ii 
$strii 
,ii  
tablejj 
:jj 
$strjj !
,jj! "
typekk 
:kk 
$strkk 
,kk 
nullablell 
:ll 
truell 
)ll 
;ll  
migrationBuildernn 
.nn 
CreateIndexnn (
(nn( )
nameoo 
:oo 
$stroo )
,oo) *
tablepp 
:pp 
$strpp !
,pp! "
columnqq 
:qq 
$strqq 
,qq  
uniquerr 
:rr 
truerr 
)rr 
;rr 
migrationBuildertt 
.tt 
AddForeignKeytt *
(tt* +
nameuu 
:uu 
$struu @
,uu@ A
tablevv 
:vv 
$strvv !
,vv! "
columnww 
:ww 
$strww (
,ww( )
principalTablexx 
:xx 
$strxx  /
,xx/ 0
principalColumnyy 
:yy  
$stryy! %
,yy% &
onDeletezz 
:zz 
ReferentialActionzz +
.zz+ ,
Cascadezz, 3
)zz3 4
;zz4 5
}{{ 	
}|| 
}}} ãu
ÅE:\Master\Sem1\Requirements\Prototype\PSYCare-Backend\PSYCare\PSYCare\Migrations\20260107183811_AddRelationPatientPsychologist.cs
	namespace 	
PSYCare
 
. 

Migrations 
{ 
public		 

partial		 
class		 *
AddRelationPatientPsychologist		 7
:		8 9
	Migration		: C
{

 
	protected 
override 
void 
Up  "
(" #
MigrationBuilder# 3
migrationBuilder4 D
)D E
{ 	
migrationBuilder 
. 
	DropTable &
(& '
name 
: 
$str  
)  !
;! "
migrationBuilder 
. 
AlterColumn (
<( )
string) /
>/ 0
(0 1
name 
: 
$str 
, 
table 
: 
$str &
,& '
type 
: 
$str .
,. /
	maxLength 
: 
$num 
, 
nullable 
: 
false 
,  

oldClrType 
: 
typeof "
(" #
string# )
)) *
,* +
oldType 
: 
$str 
)  
;  !
migrationBuilder 
. 
AlterColumn (
<( )
string) /
>/ 0
(0 1
name 
: 
$str 
, 
table 
: 
$str &
,& '
type 
: 
$str .
,. /
	maxLength 
: 
$num 
, 
nullable 
: 
false 
,  

oldClrType   
:   
typeof   "
(  " #
string  # )
)  ) *
,  * +
oldType!! 
:!! 
$str!! 
)!!  
;!!  !
migrationBuilder## 
.## 
CreateTable## (
(##( )
name$$ 
:$$ 
$str$$  
,$$  !
columns%% 
:%% 
table%% 
=>%% !
new%%" %
{&& 
Id'' 
='' 
table'' 
.'' 
Column'' %
<''% &
int''& )
>'') *
(''* +
type''+ /
:''/ 0
$str''1 :
,'': ;
nullable''< D
:''D E
false''F K
)''K L
.(( 

Annotation(( #
(((# $
$str(($ D
,((D E)
NpgsqlValueGenerationStrategy((F c
.((c d#
IdentityByDefaultColumn((d {
)(({ |
,((| }
PsychologistId)) "
=))# $
table))% *
.))* +
Column))+ 1
<))1 2
int))2 5
>))5 6
())6 7
type))7 ;
:)); <
$str))= F
,))F G
nullable))H P
:))P Q
false))R W
)))W X
,))X Y
Name** 
=** 
table**  
.**  !
Column**! '
<**' (
string**( .
>**. /
(**/ 0
type**0 4
:**4 5
$str**6 N
,**N O
	maxLength**P Y
:**Y Z
$num**[ ^
,**^ _
nullable**` h
:**h i
false**j o
)**o p
,**p q
Email++ 
=++ 
table++ !
.++! "
Column++" (
<++( )
string++) /
>++/ 0
(++0 1
type++1 5
:++5 6
$str++7 O
,++O P
	maxLength++Q Z
:++Z [
$num++\ _
,++_ `
nullable++a i
:++i j
false++k p
)++p q
,++q r
Password,, 
=,, 
table,, $
.,,$ %
Column,,% +
<,,+ ,
string,,, 2
>,,2 3
(,,3 4
type,,4 8
:,,8 9
$str,,: @
,,,@ A
nullable,,B J
:,,J K
false,,L Q
),,Q R
,,,R S
PhoneNumber-- 
=--  !
table--" '
.--' (
Column--( .
<--. /
string--/ 5
>--5 6
(--6 7
type--7 ;
:--; <
$str--= C
,--C D
nullable--E M
:--M N
false--O T
)--T U
,--U V
Faculty.. 
=.. 
table.. #
...# $
Column..$ *
<..* +
string..+ 1
>..1 2
(..2 3
type..3 7
:..7 8
$str..9 ?
,..? @
nullable..A I
:..I J
true..K O
)..O P
,..P Q
Location// 
=// 
table// $
.//$ %
Column//% +
<//+ ,
string//, 2
>//2 3
(//3 4
type//4 8
://8 9
$str//: @
,//@ A
nullable//B J
://J K
true//L P
)//P Q
,//Q R
Problem00 
=00 
table00 #
.00# $
Column00$ *
<00* +
string00+ 1
>001 2
(002 3
type003 7
:007 8
$str009 ?
,00? @
nullable00A I
:00I J
true00K O
)00O P
,00P Q
Age11 
=11 
table11 
.11  
Column11  &
<11& '
int11' *
>11* +
(11+ ,
type11, 0
:110 1
$str112 ;
,11; <
nullable11= E
:11E F
false11G L
)11L M
}22 
,22 
constraints33 
:33 
table33 "
=>33# %
{44 
table55 
.55 

PrimaryKey55 $
(55$ %
$str55% 2
,552 3
x554 5
=>556 8
x559 :
.55: ;
Id55; =
)55= >
;55> ?
table66 
.66 

ForeignKey66 $
(66$ %
name77 
:77 
$str77 H
,77H I
column88 
:88 
x88  !
=>88" $
x88% &
.88& '
PsychologistId88' 5
,885 6
principalTable99 &
:99& '
$str99( 7
,997 8
principalColumn:: '
:::' (
$str::) -
,::- .
onDelete;;  
:;;  !
ReferentialAction;;" 3
.;;3 4
Cascade;;4 ;
);;; <
;;;< =
}<< 
)<< 
;<< 
migrationBuilder>> 
.>> 
CreateIndex>> (
(>>( )
name?? 
:?? 
$str?? .
,??. /
table@@ 
:@@ 
$str@@ &
,@@& '
columnAA 
:AA 
$strAA 
,AA  
uniqueBB 
:BB 
trueBB 
)BB 
;BB 
migrationBuilderDD 
.DD 
CreateIndexDD (
(DD( )
nameEE 
:EE 
$strEE )
,EE) *
tableFF 
:FF 
$strFF !
,FF! "
columnGG 
:GG 
$strGG 
,GG  
uniqueHH 
:HH 
trueHH 
)HH 
;HH 
migrationBuilderJJ 
.JJ 
CreateIndexJJ (
(JJ( )
nameKK 
:KK 
$strKK 2
,KK2 3
tableLL 
:LL 
$strLL !
,LL! "
columnMM 
:MM 
$strMM (
)MM( )
;MM) *
}NN 	
	protectedQQ 
overrideQQ 
voidQQ 
DownQQ  $
(QQ$ %
MigrationBuilderQQ% 5
migrationBuilderQQ6 F
)QQF G
{RR 	
migrationBuilderSS 
.SS 
	DropTableSS &
(SS& '
nameTT 
:TT 
$strTT  
)TT  !
;TT! "
migrationBuilderVV 
.VV 
	DropIndexVV &
(VV& '
nameWW 
:WW 
$strWW .
,WW. /
tableXX 
:XX 
$strXX &
)XX& '
;XX' (
migrationBuilderZZ 
.ZZ 
AlterColumnZZ (
<ZZ( )
stringZZ) /
>ZZ/ 0
(ZZ0 1
name[[ 
:[[ 
$str[[ 
,[[ 
table\\ 
:\\ 
$str\\ &
,\\& '
type]] 
:]] 
$str]] 
,]] 
nullable^^ 
:^^ 
false^^ 
,^^  

oldClrType__ 
:__ 
typeof__ "
(__" #
string__# )
)__) *
,__* +
oldType`` 
:`` 
$str`` 1
,``1 2
oldMaxLengthaa 
:aa 
$numaa !
)aa! "
;aa" #
migrationBuildercc 
.cc 
AlterColumncc (
<cc( )
stringcc) /
>cc/ 0
(cc0 1
namedd 
:dd 
$strdd 
,dd 
tableee 
:ee 
$stree &
,ee& '
typeff 
:ff 
$strff 
,ff 
nullablegg 
:gg 
falsegg 
,gg  

oldClrTypehh 
:hh 
typeofhh "
(hh" #
stringhh# )
)hh) *
,hh* +
oldTypeii 
:ii 
$strii 1
,ii1 2
oldMaxLengthjj 
:jj 
$numjj !
)jj! "
;jj" #
migrationBuilderll 
.ll 
CreateTablell (
(ll( )
namemm 
:mm 
$strmm  
,mm  !
columnsnn 
:nn 
tablenn 
=>nn !
newnn" %
{oo 
Idpp 
=pp 
tablepp 
.pp 
Columnpp %
<pp% &
intpp& )
>pp) *
(pp* +
typepp+ /
:pp/ 0
$strpp1 :
,pp: ;
nullablepp< D
:ppD E
falseppF K
)ppK L
.qq 

Annotationqq #
(qq# $
$strqq$ D
,qqD E)
NpgsqlValueGenerationStrategyqqF c
.qqc d#
IdentityByDefaultColumnqqd {
)qq{ |
,qq| }
Agerr 
=rr 
tablerr 
.rr  
Columnrr  &
<rr& '
intrr' *
>rr* +
(rr+ ,
typerr, 0
:rr0 1
$strrr2 ;
,rr; <
nullablerr= E
:rrE F
falserrG L
)rrL M
,rrM N
Emailss 
=ss 
tabless !
.ss! "
Columnss" (
<ss( )
stringss) /
>ss/ 0
(ss0 1
typess1 5
:ss5 6
$strss7 O
,ssO P
	maxLengthssQ Z
:ssZ [
$numss\ _
,ss_ `
nullablessa i
:ssi j
falsessk p
)ssp q
,ssq r
Facultytt 
=tt 
tablett #
.tt# $
Columntt$ *
<tt* +
stringtt+ 1
>tt1 2
(tt2 3
typett3 7
:tt7 8
$strtt9 ?
,tt? @
nullablettA I
:ttI J
truettK O
)ttO P
,ttP Q
Locationuu 
=uu 
tableuu $
.uu$ %
Columnuu% +
<uu+ ,
stringuu, 2
>uu2 3
(uu3 4
typeuu4 8
:uu8 9
$struu: @
,uu@ A
nullableuuB J
:uuJ K
trueuuL P
)uuP Q
,uuQ R
Namevv 
=vv 
tablevv  
.vv  !
Columnvv! '
<vv' (
stringvv( .
>vv. /
(vv/ 0
typevv0 4
:vv4 5
$strvv6 N
,vvN O
	maxLengthvvP Y
:vvY Z
$numvv[ ^
,vv^ _
nullablevv` h
:vvh i
falsevvj o
)vvo p
,vvp q
Passwordww 
=ww 
tableww $
.ww$ %
Columnww% +
<ww+ ,
stringww, 2
>ww2 3
(ww3 4
typeww4 8
:ww8 9
$strww: @
,ww@ A
nullablewwB J
:wwJ K
falsewwL Q
)wwQ R
,wwR S
PhoneNumberxx 
=xx  !
tablexx" '
.xx' (
Columnxx( .
<xx. /
stringxx/ 5
>xx5 6
(xx6 7
typexx7 ;
:xx; <
$strxx= C
,xxC D
nullablexxE M
:xxM N
falsexxO T
)xxT U
,xxU V
Problemyy 
=yy 
tableyy #
.yy# $
Columnyy$ *
<yy* +
stringyy+ 1
>yy1 2
(yy2 3
typeyy3 7
:yy7 8
$stryy9 ?
,yy? @
nullableyyA I
:yyI J
trueyyK O
)yyO P
,yyP Q
PsychologistIdzz "
=zz# $
tablezz% *
.zz* +
Columnzz+ 1
<zz1 2
intzz2 5
>zz5 6
(zz6 7
typezz7 ;
:zz; <
$strzz= F
,zzF G
nullablezzH P
:zzP Q
truezzR V
)zzV W
}{{ 
,{{ 
constraints|| 
:|| 
table|| "
=>||# %
{}} 
table~~ 
.~~ 

PrimaryKey~~ $
(~~$ %
$str~~% 2
,~~2 3
x~~4 5
=>~~6 8
x~~9 :
.~~: ;
Id~~; =
)~~= >
;~~> ?
table 
. 

ForeignKey $
($ %
name
ÄÄ 
:
ÄÄ 
$str
ÄÄ H
,
ÄÄH I
column
ÅÅ 
:
ÅÅ 
x
ÅÅ  !
=>
ÅÅ" $
x
ÅÅ% &
.
ÅÅ& '
PsychologistId
ÅÅ' 5
,
ÅÅ5 6
principalTable
ÇÇ &
:
ÇÇ& '
$str
ÇÇ( 7
,
ÇÇ7 8
principalColumn
ÉÉ '
:
ÉÉ' (
$str
ÉÉ) -
)
ÉÉ- .
;
ÉÉ. /
}
ÑÑ 
)
ÑÑ 
;
ÑÑ 
migrationBuilder
ÜÜ 
.
ÜÜ 
CreateIndex
ÜÜ (
(
ÜÜ( )
name
áá 
:
áá 
$str
áá )
,
áá) *
table
àà 
:
àà 
$str
àà !
,
àà! "
column
ââ 
:
ââ 
$str
ââ 
,
ââ  
unique
ää 
:
ää 
true
ää 
)
ää 
;
ää 
migrationBuilder
åå 
.
åå 
CreateIndex
åå (
(
åå( )
name
çç 
:
çç 
$str
çç 2
,
çç2 3
table
éé 
:
éé 
$str
éé !
,
éé! "
column
èè 
:
èè 
$str
èè (
)
èè( )
;
èè) *
}
êê 	
}
ëë 
}íí ÓU
|E:\Master\Sem1\Requirements\Prototype\PSYCare-Backend\PSYCare\PSYCare\Migrations\20260107162242_CreatePacientPsychologist.cs
	namespace 	
PSYCare
 
. 

Migrations 
{ 
public		 

partial		 
class		 %
CreatePacientPsychologist		 2
:		3 4
	Migration		5 >
{

 
	protected 
override 
void 
Up  "
(" #
MigrationBuilder# 3
migrationBuilder4 D
)D E
{ 	
migrationBuilder 
. 
	DropTable &
(& '
name 
: 
$str 
) 
; 
migrationBuilder 
. 
CreateTable (
(( )
name 
: 
$str %
,% &
columns 
: 
table 
=> !
new" %
{ 
Id 
= 
table 
. 
Column %
<% &
int& )
>) *
(* +
type+ /
:/ 0
$str1 :
,: ;
nullable< D
:D E
falseF K
)K L
. 

Annotation #
(# $
$str$ D
,D E)
NpgsqlValueGenerationStrategyF c
.c d#
IdentityByDefaultColumnd {
){ |
,| }
Name 
= 
table  
.  !
Column! '
<' (
string( .
>. /
(/ 0
type0 4
:4 5
$str6 <
,< =
nullable> F
:F G
falseH M
)M N
,N O
Email 
= 
table !
.! "
Column" (
<( )
string) /
>/ 0
(0 1
type1 5
:5 6
$str7 =
,= >
nullable? G
:G H
falseI N
)N O
,O P
Password 
= 
table $
.$ %
Column% +
<+ ,
string, 2
>2 3
(3 4
type4 8
:8 9
$str: @
,@ A
nullableB J
:J K
falseL Q
)Q R
,R S
Location 
= 
table $
.$ %
Column% +
<+ ,
string, 2
>2 3
(3 4
type4 8
:8 9
$str: @
,@ A
nullableB J
:J K
trueL P
)P Q
} 
, 
constraints 
: 
table "
=># %
{ 
table 
. 

PrimaryKey $
($ %
$str% 7
,7 8
x9 :
=>; =
x> ?
.? @
Id@ B
)B C
;C D
} 
) 
; 
migrationBuilder!! 
.!! 
CreateTable!! (
(!!( )
name"" 
:"" 
$str""  
,""  !
columns## 
:## 
table## 
=>## !
new##" %
{$$ 
Id%% 
=%% 
table%% 
.%% 
Column%% %
<%%% &
int%%& )
>%%) *
(%%* +
type%%+ /
:%%/ 0
$str%%1 :
,%%: ;
nullable%%< D
:%%D E
false%%F K
)%%K L
.&& 

Annotation&& #
(&&# $
$str&&$ D
,&&D E)
NpgsqlValueGenerationStrategy&&F c
.&&c d#
IdentityByDefaultColumn&&d {
)&&{ |
,&&| }
Name'' 
='' 
table''  
.''  !
Column''! '
<''' (
string''( .
>''. /
(''/ 0
type''0 4
:''4 5
$str''6 N
,''N O
	maxLength''P Y
:''Y Z
$num''[ ^
,''^ _
nullable''` h
:''h i
false''j o
)''o p
,''p q
Email(( 
=(( 
table(( !
.((! "
Column((" (
<((( )
string(() /
>((/ 0
(((0 1
type((1 5
:((5 6
$str((7 O
,((O P
	maxLength((Q Z
:((Z [
$num((\ _
,((_ `
nullable((a i
:((i j
false((k p
)((p q
,((q r
Password)) 
=)) 
table)) $
.))$ %
Column))% +
<))+ ,
string)), 2
>))2 3
())3 4
type))4 8
:))8 9
$str)): @
,))@ A
nullable))B J
:))J K
false))L Q
)))Q R
,))R S
PhoneNumber** 
=**  !
table**" '
.**' (
Column**( .
<**. /
string**/ 5
>**5 6
(**6 7
type**7 ;
:**; <
$str**= C
,**C D
nullable**E M
:**M N
false**O T
)**T U
,**U V
Faculty++ 
=++ 
table++ #
.++# $
Column++$ *
<++* +
string+++ 1
>++1 2
(++2 3
type++3 7
:++7 8
$str++9 ?
,++? @
nullable++A I
:++I J
true++K O
)++O P
,++P Q
Location,, 
=,, 
table,, $
.,,$ %
Column,,% +
<,,+ ,
string,,, 2
>,,2 3
(,,3 4
type,,4 8
:,,8 9
$str,,: @
,,,@ A
nullable,,B J
:,,J K
true,,L P
),,P Q
,,,Q R
Problem-- 
=-- 
table-- #
.--# $
Column--$ *
<--* +
string--+ 1
>--1 2
(--2 3
type--3 7
:--7 8
$str--9 ?
,--? @
nullable--A I
:--I J
true--K O
)--O P
,--P Q
Age.. 
=.. 
table.. 
...  
Column..  &
<..& '
int..' *
>..* +
(..+ ,
type.., 0
:..0 1
$str..2 ;
,..; <
nullable..= E
:..E F
false..G L
)..L M
,..M N
PsychologistId// "
=//# $
table//% *
.//* +
Column//+ 1
<//1 2
int//2 5
>//5 6
(//6 7
type//7 ;
://; <
$str//= F
,//F G
nullable//H P
://P Q
true//R V
)//V W
}00 
,00 
constraints11 
:11 
table11 "
=>11# %
{22 
table33 
.33 

PrimaryKey33 $
(33$ %
$str33% 2
,332 3
x334 5
=>336 8
x339 :
.33: ;
Id33; =
)33= >
;33> ?
table44 
.44 

ForeignKey44 $
(44$ %
name55 
:55 
$str55 H
,55H I
column66 
:66 
x66  !
=>66" $
x66% &
.66& '
PsychologistId66' 5
,665 6
principalTable77 &
:77& '
$str77( 7
,777 8
principalColumn88 '
:88' (
$str88) -
)88- .
;88. /
}99 
)99 
;99 
migrationBuilder;; 
.;; 
CreateIndex;; (
(;;( )
name<< 
:<< 
$str<< )
,<<) *
table== 
:== 
$str== !
,==! "
column>> 
:>> 
$str>> 
,>>  
unique?? 
:?? 
true?? 
)?? 
;?? 
migrationBuilderAA 
.AA 
CreateIndexAA (
(AA( )
nameBB 
:BB 
$strBB 2
,BB2 3
tableCC 
:CC 
$strCC !
,CC! "
columnDD 
:DD 
$strDD (
)DD( )
;DD) *
}EE 	
	protectedHH 
overrideHH 
voidHH 
DownHH  $
(HH$ %
MigrationBuilderHH% 5
migrationBuilderHH6 F
)HHF G
{II 	
migrationBuilderJJ 
.JJ 
	DropTableJJ &
(JJ& '
nameKK 
:KK 
$strKK  
)KK  !
;KK! "
migrationBuilderMM 
.MM 
	DropTableMM &
(MM& '
nameNN 
:NN 
$strNN %
)NN% &
;NN& '
migrationBuilderPP 
.PP 
CreateTablePP (
(PP( )
nameQQ 
:QQ 
$strQQ 
,QQ 
columnsRR 
:RR 
tableRR 
=>RR !
newRR" %
{SS 
IdTT 
=TT 
tableTT 
.TT 
ColumnTT %
<TT% &
intTT& )
>TT) *
(TT* +
typeTT+ /
:TT/ 0
$strTT1 :
,TT: ;
nullableTT< D
:TTD E
falseTTF K
)TTK L
.UU 

AnnotationUU #
(UU# $
$strUU$ D
,UUD E)
NpgsqlValueGenerationStrategyUUF c
.UUc d#
IdentityByDefaultColumnUUd {
)UU{ |
,UU| }
EmailVV 
=VV 
tableVV !
.VV! "
ColumnVV" (
<VV( )
stringVV) /
>VV/ 0
(VV0 1
typeVV1 5
:VV5 6
$strVV7 O
,VVO P
	maxLengthVVQ Z
:VVZ [
$numVV\ _
,VV_ `
nullableVVa i
:VVi j
falseVVk p
)VVp q
,VVq r
NameWW 
=WW 
tableWW  
.WW  !
ColumnWW! '
<WW' (
stringWW( .
>WW. /
(WW/ 0
typeWW0 4
:WW4 5
$strWW6 N
,WWN O
	maxLengthWWP Y
:WWY Z
$numWW[ ^
,WW^ _
nullableWW` h
:WWh i
falseWWj o
)WWo p
}XX 
,XX 
constraintsYY 
:YY 
tableYY "
=>YY# %
{ZZ 
table[[ 
.[[ 

PrimaryKey[[ $
([[$ %
$str[[% /
,[[/ 0
x[[1 2
=>[[3 5
x[[6 7
.[[7 8
Id[[8 :
)[[: ;
;[[; <
}\\ 
)\\ 
;\\ 
migrationBuilder^^ 
.^^ 
CreateIndex^^ (
(^^( )
name__ 
:__ 
$str__ &
,__& '
table`` 
:`` 
$str`` 
,`` 
columnaa 
:aa 
$straa 
,aa  
uniquebb 
:bb 
truebb 
)bb 
;bb 
}cc 	
}dd 
}ee ﬂ
mE:\Master\Sem1\Requirements\Prototype\PSYCare-Backend\PSYCare\PSYCare\Migrations\20260107120424_CreateUser.cs
	namespace 	
PSYCare
 
. 

Migrations 
{ 
public		 

partial		 
class		 

CreateUser		 #
:		$ %
	Migration		& /
{

 
	protected 
override 
void 
Up  "
(" #
MigrationBuilder# 3
migrationBuilder4 D
)D E
{ 	
migrationBuilder 
. 
CreateTable (
(( )
name 
: 
$str 
, 
columns 
: 
table 
=> !
new" %
{ 
Id 
= 
table 
. 
Column %
<% &
int& )
>) *
(* +
type+ /
:/ 0
$str1 :
,: ;
nullable< D
:D E
falseF K
)K L
. 

Annotation #
(# $
$str$ D
,D E)
NpgsqlValueGenerationStrategyF c
.c d#
IdentityByDefaultColumnd {
){ |
,| }
Name 
= 
table  
.  !
Column! '
<' (
string( .
>. /
(/ 0
type0 4
:4 5
$str6 N
,N O
	maxLengthP Y
:Y Z
$num[ ^
,^ _
nullable` h
:h i
falsej o
)o p
,p q
Email 
= 
table !
.! "
Column" (
<( )
string) /
>/ 0
(0 1
type1 5
:5 6
$str7 O
,O P
	maxLengthQ Z
:Z [
$num\ _
,_ `
nullablea i
:i j
falsek p
)p q
} 
, 
constraints 
: 
table "
=># %
{ 
table 
. 

PrimaryKey $
($ %
$str% /
,/ 0
x1 2
=>3 5
x6 7
.7 8
Id8 :
): ;
;; <
} 
) 
; 
migrationBuilder 
. 
CreateIndex (
(( )
name 
: 
$str &
,& '
table 
: 
$str 
, 
column 
: 
$str 
,  
unique   
:   
true   
)   
;   
}!! 	
	protected$$ 
override$$ 
void$$ 
Down$$  $
($$$ %
MigrationBuilder$$% 5
migrationBuilder$$6 F
)$$F G
{%% 	
migrationBuilder&& 
.&& 
	DropTable&& &
(&&& '
name'' 
:'' 
$str'' 
)'' 
;'' 
}(( 	
})) 
}** ∂!
bE:\Master\Sem1\Requirements\Prototype\PSYCare-Backend\PSYCare\PSYCare\Database\PSYCareDbContext.cs
	namespace 	
PSYCare
 
. 
Database 
; 
public 
class 
PSYCareDbContext 
: 
	DbContext  )
{ 
public 

PSYCareDbContext 
( 
DbContextOptions ,
<, -
PSYCareDbContext- =
>= >
options? F
)F G
:		 	
base		
 
(		 
options		 
)		 
{

 
} 
public 

DbSet 
< 
Patient 
> 
Patients "
{# $
get% (
;( )
set* -
;- .
}/ 0
public 

DbSet 
< 
Psychologist 
> 
Psychologists ,
{- .
get/ 2
;2 3
set4 7
;7 8
}9 :
public 

DbSet 
< 
	MoodEntry 
> 
MoodEntries '
{( )
get* -
;- .
set/ 2
;2 3
}4 5
=6 7
default8 ?
!? @
;@ A
public 

DbSet 
< 
Session 
> 
Sessions "
{# $
get% (
;( )
set* -
;- .
}/ 0
public 

DbSet 
< 
JournalEntry 
> 
JournalEntries -
{. /
get0 3
;3 4
set5 8
;8 9
}: ;
	protected 
override 
void 
OnModelCreating +
(+ ,
ModelBuilder, 8
modelBuilder9 E
)E F
{ 
base 
. 
OnModelCreating 
( 
modelBuilder )
)) *
;* +
modelBuilder 
. +
ApplyConfigurationsFromAssembly 4
(4 5
typeof 
( 
PSYCareDbContext #
)# $
.$ %
Assembly% -
) 	
;	 

modelBuilder 
. 
Entity 
< 
	MoodEntry %
>% &
(& '
b' (
=>) +
{ 	
b 
. 
ToTable 
( 
$str $
)$ %
;% &
b 
. 
HasKey 
( 
x 
=> 
x 
. 
Id 
) 
;  
b   
.   
Property   
(   
x   
=>   
x   
.   
Score   #
)  # $
.  $ %

IsRequired  % /
(  / 0
)  0 1
;  1 2
b"" 
."" 
Property"" 
("" 
x"" 
=>"" 
x"" 
."" 
	CreatedAt"" '
)""' (
.## 
HasDefaultValueSql## #
(### $
$str##$ +
)##+ ,
;##, -
b%% 
.%% 
HasIndex%% 
(%% 
x%% 
=>%% 
new%% 
{%%  !
x%%" #
.%%# $
	PatientId%%$ -
,%%- .
x%%/ 0
.%%0 1
	CreatedAt%%1 :
}%%; <
)%%< =
;%%= >
b'' 
.'' 
HasOne'' 
('' 
x'' 
=>'' 
x'' 
.'' 
Patient'' #
)''# $
.(( 
WithMany(( 
((( 
p(( 
=>(( 
p((  
.((  !
MoodEntries((! ,
)((, -
.)) 
HasForeignKey)) 
()) 
x))  
=>))! #
x))$ %
.))% &
	PatientId))& /
)))/ 0
.** 
OnDelete** 
(** 
DeleteBehavior** (
.**( )
Cascade**) 0
)**0 1
;**1 2
}++ 	
)++	 

;++
 
},, 
}-- Ω
bE:\Master\Sem1\Requirements\Prototype\PSYCare-Backend\PSYCare\PSYCare\Database\Entities\Session.cs
	namespace 	
PSYCare
 
. 
Database 
. 
Entities #
{ 
public 

class 
Session 
{ 
[		 	
Key			 
]		 
public

 
int

 
Id

 
{

 
get

 
;

 
set

  
;

  !
}

" #
[ 	
Required	 
] 
public 
int 
	PatientId 
{ 
get "
;" #
set$ '
;' (
}) *
[ 	
Required	 
] 
public 
int 
PsychologistId !
{" #
get$ '
;' (
set) ,
;, -
}. /
[ 	
Required	 
] 
public 
DateTime 
ScheduledAt #
{$ %
get& )
;) *
set+ .
;. /
}0 1
[ 	
Required	 
] 
[ 	
	MaxLength	 
( 
$num 
) 
] 
public 
string 
Status 
{ 
get "
;" #
set$ '
;' (
}) *
=+ ,
$str- 6
;6 7
[ 	
	MaxLength	 
( 
$num 
) 
] 
public 
string 
? 
Notes 
{ 
get "
;" #
set$ '
;' (
}) *
[ 	

ForeignKey	 
( 
nameof 
( 
	PatientId $
)$ %
)% &
]& '
public 
virtual 
Patient 
? 
Patient  '
{( )
get* -
;- .
set/ 2
;2 3
}4 5
[ 	

ForeignKey	 
( 
nameof 
( 
PsychologistId )
)) *
)* +
]+ ,
public   
virtual   
Psychologist   #
?  # $
Psychologist  % 1
{  2 3
get  4 7
;  7 8
set  9 <
;  < =
}  > ?
}!! 
}"" «
gE:\Master\Sem1\Requirements\Prototype\PSYCare-Backend\PSYCare\PSYCare\Database\Entities\Psychologist.cs
	namespace 	
PSYCare
 
. 
Database 
. 
Entities #
{ 
public 

class 
Psychologist 
{ 
public 
int 
Id 
{ 
get 
; 
set  
;  !
}" #
public 
string 
Name 
{ 
get  
;  !
set" %
;% &
}' (
public 
string 
Email 
{ 
get !
;! "
set# &
;& '
}( )
public 
string 
Password 
{  
get! $
;$ %
set& )
;) *
}+ ,
public		 
string		 
?		 
Location		 
{		  !
get		" %
;		% &
set		' *
;		* +
}		, -
public 
ICollection 
< 
Patient "
>" #
Patients$ ,
{- .
get/ 2
;2 3
set4 7
;7 8
}9 :
=; <
new= @
ListA E
<E F
PatientF M
>M N
(N O
)O P
;P Q
} 
} “
bE:\Master\Sem1\Requirements\Prototype\PSYCare-Backend\PSYCare\PSYCare\Database\Entities\Patient.cs
	namespace 	
PSYCare
 
. 
Database 
. 
Entities #
;# $
public 
class 
Patient 
{ 
public 

int 
Id 
{ 
get 
; 
set 
; 
} 
public 

int 
? 
PsychologistId 
{  
get! $
;$ %
set& )
;) *
}+ ,
public 

string 
Name 
{ 
get 
; 
set !
;! "
}# $
public 

string 
Email 
{ 
get 
; 
set "
;" #
}$ %
public		 

string		 
Password		 
{		 
get		  
;		  !
set		" %
;		% &
}		' (
public

 

string

 
PhoneNumber

 
{

 
get

  #
;

# $
set

% (
;

( )
}

* +
public 

string 
? 
Location 
{ 
get !
;! "
set# &
;& '
}( )
public 

string 
? 
IssueDescription #
{$ %
get& )
;) *
set+ .
;. /
}0 1
public 

string 
? 
	Diagnosis 
{ 
get "
;" #
set$ '
;' (
}) *
public 

string 
? 
PsychologistNotes $
{% &
get' *
;* +
set, /
;/ 0
}1 2
public 

int 
Age 
{ 
get 
; 
set 
; 
}  
public 

Psychologist 
? 
Psychologist %
{& '
get( +
;+ ,
set- 0
;0 1
}2 3
public 

ICollection 
< 
	MoodEntry  
>  !
MoodEntries" -
{. /
get0 3
;3 4
set5 8
;8 9
}: ;
=< =
new> A
ListB F
<F G
	MoodEntryG P
>P Q
(Q R
)R S
;S T
public 

ICollection 
< 
JournalEntry #
># $
JournalEntries% 3
{4 5
get6 9
;9 :
set; >
;> ?
}@ A
=B C
newD G
ListH L
<L M
JournalEntryM Y
>Y Z
(Z [
)[ \
;\ ]
} 
dE:\Master\Sem1\Requirements\Prototype\PSYCare-Backend\PSYCare\PSYCare\Database\Entities\MoodEntry.cs
	namespace 	
PSYCare
 
. 
Database 
. 
Entities #
{ 
public 

class 
	MoodEntry 
{ 
public 
int 
Id 
{ 
get 
; 
set  
;  !
}" #
public		 
int		 
	PatientId		 
{		 
get		 "
;		" #
set		$ '
;		' (
}		) *
[ 	
Range	 
( 
$num 
, 
$num 
) 
] 
public 
int 
Score 
{ 
get 
; 
set  #
;# $
}% &
public 
string 
? 
Emoji 
{ 
get "
;" #
set$ '
;' (
}) *
public 
string 
? 
Notes 
{ 
get "
;" #
set$ '
;' (
}) *
public 
string 
? 
AudioUrl 
{  !
get" %
;% &
set' *
;* +
}, -
public 
DateTimeOffset 
	CreatedAt '
{( )
get* -
;- .
set/ 2
;2 3
}4 5
=6 7
DateTimeOffset8 F
.F G
UtcNowG M
;M N
public 
Patient 
Patient 
{  
get! $
;$ %
set& )
;) *
}+ ,
=- .
default/ 6
!6 7
;7 8
} 
} ä

gE:\Master\Sem1\Requirements\Prototype\PSYCare-Backend\PSYCare\PSYCare\Database\Entities\JournalEntry.cs
	namespace 	
PSYCare
 
. 
Database 
. 
Entities #
{ 
public 

class 
JournalEntry 
{ 
public 
int 
Id 
{ 
get 
; 
set  
;  !
}" #
public 
int 
	PatientId 
{ 
get "
;" #
set$ '
;' (
}) *
public		 
string		 
?		 
Text		 
{		 
get		 !
;		! "
set		# &
;		& '
}		( )
public

 
DateTimeOffset

 
	CreatedAt

 '
{

( )
get

* -
;

- .
set

/ 2
;

2 3
}

4 5
=

6 7
DateTimeOffset

8 F
.

F G
UtcNow

G M
;

M N
public 
Patient 
Patient 
{  
get! $
;$ %
set& )
;) *
}+ ,
=- .
default/ 6
!6 7
;7 8
} 
} √
zE:\Master\Sem1\Requirements\Prototype\PSYCare-Backend\PSYCare\PSYCare\Database\Configurations\PsychologistConfiguration.cs
	namespace 	
PSYCare
 
. 
Database 
. 
Configurations )
;) *
public 
class %
PsychologistConfiguration &
:& '$
IEntityTypeConfiguration( @
<@ A
PsychologistA M
>M N
{ 
public		 

void		 
	Configure		 
(		 
EntityTypeBuilder		 +
<		+ ,
Psychologist		, 8
>		8 9
builder		: A
)		A B
{

 
builder 
. 
Property 
( 
x 
=> 
x 
.  
Email  %
)% &
. 

IsRequired 
( 
) 
. 
HasMaxLength 
( 
$num  
)  !
;! "
builder 
. 
HasIndex 
( 
x 
=> 
x 
.  
Email  %
)% &
. 
IsUnique 
( 
) 
; 
builder 
. 
Property 
( 
x 
=> 
x 
.  
Name  $
)$ %
. 

IsRequired 
( 
) 
. 
HasMaxLength 
( 
$num !
)! "
;" #
builder 
. 
HasMany 
( 
p 
=> 
p 
. 
Patients '
)' (
. 
WithOne 
( 
patient 
=> 
patient &
.& '
Psychologist' 3
)3 4
. 
HasForeignKey 
( 
patient !
=>" $
patient% ,
., -
PsychologistId- ;
); <
. 

IsRequired 
( 
false 
) 
; 
} 
} Ó(
gE:\Master\Sem1\Requirements\Prototype\PSYCare-Backend\PSYCare\PSYCare\Controllers\SessionsController.cs
	namespace 	
PSYCare
 
. 
Controllers 
{ 
[ 
ApiController 
] 
[ 
Route 

(
 
$str 
) 
] 
public		 

class		 
SessionsController		 #
:		$ %
ControllerBase		& 4
{

 
private 
readonly 
ISessionService (
_sessionService) 8
;8 9
public 
SessionsController !
(! "
ISessionService" 1
sessionService2 @
)@ A
{ 	
_sessionService 
= 
sessionService ,
;, -
} 	
[ 	
HttpPost	 
] 
public 
async 
Task 
< 
IActionResult '
>' (
CreateSession) 6
(6 7
[7 8
FromBody8 @
]@ A
SessionCreateDtoB R
dtoS V
)V W
{ 	
var 
created 
= 
await 
_sessionService  /
./ 0
CreateAsync0 ;
(; <
dto< ?
)? @
;@ A
return 
CreatedAtAction "
(" #
nameof# )
() *

GetSession* 4
)4 5
,5 6
new7 :
{; <
	sessionId= F
=G H
createdI P
.P Q
IdQ S
}T U
,U V
createdW ^
)^ _
;_ `
} 	
[ 	
HttpGet	 
( 
$str 
) 
]  
public 
async 
Task 
< 
ActionResult &
<& '
SessionResponseDto' 9
>9 :
>: ;

GetSession< F
(F G
intG J
	sessionIdK T
)T U
{ 	
var 
session 
= 
await 
_sessionService  /
./ 0
GetByIdAsync0 <
(< =
	sessionId= F
)F G
;G H
return 
session 
; 
} 	
[   	
HttpGet  	 
(   
$str   &
)  & '
]  ' (
public!! 
async!! 
Task!! 
<!! 
ActionResult!! &
<!!& '
IReadOnlyList!!' 4
<!!4 5
SessionResponseDto!!5 G
>!!G H
>!!H I
>!!I J
GetPatientSessions!!K ]
(!!] ^
int!!^ a
	patientId!!b k
)!!k l
{"" 	
var## 
sessions## 
=## 
await##  
_sessionService##! 0
.##0 1
GetByPatientIdAsync##1 D
(##D E
	patientId##E N
)##N O
;##O P
return$$ 
Ok$$ 
($$ 
sessions$$ 
)$$ 
;$$  
}%% 	
['' 	
HttpGet''	 
('' 
$str'' 0
)''0 1
]''1 2
public(( 
async(( 
Task(( 
<(( 
ActionResult(( &
<((& '
IReadOnlyList((' 4
<((4 5
SessionResponseDto((5 G
>((G H
>((H I
>((I J#
GetPsychologistSessions((K b
(((b c
int((c f
psychologistId((g u
)((u v
{)) 	
var** 
sessions** 
=** 
await**  
_sessionService**! 0
.**0 1$
GetByPsychologistIdAsync**1 I
(**I J
psychologistId**J X
)**X Y
;**Y Z
return++ 
Ok++ 
(++ 
sessions++ 
)++ 
;++  
},, 	
[.. 	
HttpPut..	 
(.. 
$str.. &
)..& '
]..' (
public// 
async// 
Task// 
<// 
IActionResult// '
>//' (
ConfirmSession//) 7
(//7 8
int//8 ;
	sessionId//< E
)//E F
{00 	
await11 
_sessionService11 !
.11! "
ConfirmSessionAsync11" 5
(115 6
	sessionId116 ?
)11? @
;11@ A
return22 
	NoContent22 
(22 
)22 
;22 
}33 	
[55 	
HttpPut55	 
(55 
$str55 %
)55% &
]55& '
public66 
async66 
Task66 
<66 
IActionResult66 '
>66' (
CancelSession66) 6
(666 7
int667 :
	sessionId66; D
)66D E
{77 	
await88 
_sessionService88 !
.88! "
CancelSessionAsync88" 4
(884 5
	sessionId885 >
)88> ?
;88? @
return99 
	NoContent99 
(99 
)99 
;99 
}:: 	
}<< 
}== Í
nE:\Master\Sem1\Requirements\Prototype\PSYCare-Backend\PSYCare\PSYCare\Controllers\Models\MoodEntryCreateDto.cs
	namespace 	
PSYCare
 
. 
Controllers 
. 
Models $
{ 
public 

record 
MoodEntryCreateDto $
($ %
int% (
Score) .
,. /
string0 6
?6 7
Emoji8 =
,= >
string? E
?E F
NotesG L
,L M
stringN T
?T U
AudioUrlV ^
)^ _
;_ `
} ∑É
gE:\Master\Sem1\Requirements\Prototype\PSYCare-Backend\PSYCare\PSYCare\Controllers\PatientsController.cs
	namespace 	
PSYCare
 
. 
Controllers 
; 
[ 
ApiController 
] 
[		 
Route		 
(		 
$str		 
)		 
]		 
public

 
class

 
PatientsController

 
(

  
IPatientsService

  0
patientsService

1 @
,

@ A
IMoodService

B N
moodService

O Z
,

Z [
IJournalService

\ k
journalService

l z
)

z {
:

| }
ControllerBase	

~ å
{ 
private 
readonly 
IPatientsService %
_patientsService& 6
=7 8
patientsService9 H
;H I
private 
readonly 
IMoodService !
_moodService" .
=/ 0
moodService1 <
;< =
private 
readonly 
IJournalService $
_journalService% 4
=5 6
journalService7 E
;E F
[ 
HttpPost 
( 
$str 
) 
] 
public 

async 
Task 
< 
IActionResult #
># $
CreatePatient% 2
(2 3
[3 4
FromBody4 <
]< = 
CreatePatientRequest> R
requestS Z
)Z [
{ 
var 
user 
= 
new 
Services 
.  
Models  &
.& '
Patient' .
{ 	
Email 
= 
request 
. 
Email !
,! "
Name 
= 
request 
. 
Name 
,  
Location 
= 
request 
. 
Location '
,' (
PhoneNumber 
= 
request !
.! "
PhoneNumber" -
,- .
Password 
= 
request 
. 
Password '
,' (
IssueDescription 
= 
request &
.& '
IssueDescription' 7
,7 8
Age 
= 
request 
. 
Age 
} 	
;	 

var 
patient 
= 
await 
_patientsService ,
., -
CreatePatientAsync- ?
(? @
user@ D
)D E
;E F
return 
Ok 
( 
new 
{ 
type 
= 
$str (
,( )
data* .
=/ 0
patient1 8
}9 :
): ;
;; <
}   
["" 
HttpGet"" 
("" 
$str"" &
)""& '
]""' (
public## 

async## 
Task## 
<## 
IActionResult## #
>### $
GetPatientById##% 3
(##3 4
int##4 7
	patientId##8 A
)##A B
{$$ 
var%% 
patient%% 
=%% 
await%% 
_patientsService%% ,
.%%, -
GetPatientByIdAsync%%- @
(%%@ A
	patientId%%A J
)%%J K
;%%K L
return&& 
patient&& 
is&& 
null&& 
?&&  
NotFound&&! )
(&&) *
)&&* +
:&&, -
Ok&&. 0
(&&0 1
patient&&1 8
)&&8 9
;&&9 :
}'' 
[)) 
HttpPut)) 
()) 
$str)) )
)))) *
]))* +
public** 

async** 
Task** 
<** 
IActionResult** #
>**# $
UpdatePatient**% 2
(**2 3
int**3 6
	patientId**7 @
,**@ A
[**B C
FromBody**C K
]**K L 
UpdatePatientRequest**M a
request**b i
)**i j
{++ 
var,, 
updatedPatient,, 
=,, 
await,, "
_patientsService,,# 3
.,,3 4
UpdatePatientAsync,,4 F
(,,F G
	patientId,,G P
,,,P Q
request,,R Y
.,,Y Z
	Diagnosis,,Z c
,,,c d
request,,e l
.,,l m
PsychologistNotes,,m ~
),,~ 
;	,, Ä
return-- 
updatedPatient-- 
is--  
null--! %
?.. 
NotFound.. 
(.. 
).. 
:// 
Ok// 
(// 
new// 
{// 
type// 
=// 
$str// '
,//' (
data//) -
=//. /
updatedPatient//0 >
}//? @
)//@ A
;//A B
}00 
[22 
HttpGet22 
(22 
$str22 +
)22+ ,
]22, -
public33 

async33 
Task33 
<33 
IActionResult33 #
>33# $%
GetPsychologistForPatient33% >
(33> ?
int33? B
	patientId33C L
)33L M
{44 
var55 
psychologist55 
=55 
await55  
_patientsService55! 1
.551 2*
GetPsychologistForPatientAsync552 P
(55P Q
	patientId55Q Z
)55Z [
;55[ \
return66 
psychologist66 
is66 
null66 #
?66$ %
NotFound66& .
(66. /
)66/ 0
:661 2
Ok663 5
(665 6
psychologist666 B
)66B C
;66C D
}77 
[99 

HttpDelete99 
(99 
$str99 ,
)99, -
]99- .
public:: 

async:: 
Task:: 
<:: 
IActionResult:: #
>::# $
DeletePatient::% 2
(::2 3
int::3 6
	patientId::7 @
)::@ A
{;; 
if<< 

(<< 
!<< 
await<< 
_patientsService<< #
.<<# $
DeletePatientAsync<<$ 6
(<<6 7
	patientId<<7 @
)<<@ A
)<<A B
{== 	
return>> 
NotFound>> 
(>> 
)>> 
;>> 
}?? 	
return@@ 
Ok@@ 
(@@ 
new@@ 
{@@ 
message@@ 
=@@  !
$str@@" A
}@@B C
)@@C D
;@@D E
}AA 
[CC 
HttpPostCC 
(CC 
$strCC /
)CC/ 0
]CC0 1
publicDD 

asyncDD 
TaskDD 
<DD 
IActionResultDD #
>DD# $'
AssignPsychologistToPatientDD% @
(DD@ A
intDDA D
	patientIdDDE N
,DDN O
[DDP Q
FromBodyDDQ Y
]DDY Z%
AssignPsychologistRequestDD[ t
requestDDu |
)DD| }
{EE 
ifFF 

(FF 
!FF 
awaitFF 
_patientsServiceFF #
.FF# $,
 AssignPsychologistToPatientAsyncFF$ D
(FFD E
	patientIdFFE N
,FFN O
requestFFP W
.FFW X
PsychologistEmailFFX i
)FFi j
)FFj k
{GG 	
returnHH 
NotFoundHH 
(HH 
$strHH @
)HH@ A
;HHA B
}II 	
returnKK 
OkKK 
(KK 
newKK 
{KK 
messageKK 
=KK  !
$strKK" G
}KKH I
)KKI J
;KKJ K
}LL 
[NN 
HttpPostNN 
(NN 
$strNN !
)NN! "
]NN" #
publicOO 

TaskOO 
<OO 
IActionResultOO 
>OO 

CreateMoodOO )
(OO) *
intOO* -
	patientIdOO. 7
,OO7 8
[OO9 :
FromBodyOO: B
]OOB C
MoodEntryCreateDtoOOD V
dtoOOW Z
)OOZ [
=>PP 

SafeExecutePP 
(PP 
asyncPP 
(PP 
)PP 
=>PP  "
{QQ 	
varRR 
createdRR 
=RR 
awaitRR 
_moodServiceRR  ,
.RR, -
CreateAsyncRR- 8
(RR8 9
	patientIdRR9 B
,RRB C
dtoRRD G
)RRG H
;RRH I
returnSS 
CreatedAtActionSS "
(SS" #
nameofSS# )
(SS) *
GetMoodsSS* 2
)SS2 3
,SS3 4
newSS5 8
{SS9 :
	patientIdSS; D
}SSE F
,SSF G
createdSSH O
)SSO P
;SSP Q
}TT 	
)TT	 

;TT
 
[VV 
HttpGetVV 
(VV 
$strVV  
)VV  !
]VV! "
publicWW 

asyncWW 
TaskWW 
<WW 
ActionResultWW "
<WW" #
IReadOnlyListWW# 0
<WW0 1 
MoodEntryResponseDtoWW1 E
>WWE F
>WWF G
>WWG H
GetMoodsWWI Q
(WWQ R
intWWR U
	patientIdWWV _
,WW_ `
[WWa b
	FromQueryWWb k
]WWk l
intWWm p
limitWWq v
=WWw x
$numWWy {
)WW{ |
{XX 
varYY 
listYY 
=YY 
awaitYY 
_moodServiceYY %
.YY% &
	ListAsyncYY& /
(YY/ 0
	patientIdYY0 9
,YY9 :
limitYY; @
)YY@ A
;YYA B
returnZZ 
OkZZ 
(ZZ 
listZZ 
)ZZ 
;ZZ 
}[[ 
[]] 
HttpPut]] 
(]] 
$str]] )
)]]) *
]]]* +
public^^ 

Task^^ 
<^^ 
IActionResult^^ 
>^^ 

UpdateMood^^ )
(^^) *
int^^* -
	patientId^^. 7
,^^7 8
int^^9 <
moodId^^= C
,^^C D
[^^E F
FromBody^^F N
]^^N O
MoodEntryCreateDto^^P b
dto^^c f
)^^f g
=>__ 

SafeExecute__ 
(__ 
async__ 
(__ 
)__ 
=>__  "
{`` 	
awaitaa 
_moodServiceaa 
.aa 
UpdateAsyncaa *
(aa* +
	patientIdaa+ 4
,aa4 5
moodIdaa6 <
,aa< =
dtoaa> A
)aaA B
;aaB C
returnbb 
	NoContentbb 
(bb 
)bb 
;bb 
}cc 	
)cc	 

;cc
 
[ee 

HttpDeleteee 
(ee 
$stree ,
)ee, -
]ee- .
publicff 

Taskff 
<ff 
IActionResultff 
>ff 

DeleteMoodff )
(ff) *
intff* -
	patientIdff. 7
,ff7 8
intff9 <
moodIdff= C
)ffC D
=>gg 

SafeExecutegg 
(gg 
asyncgg 
(gg 
)gg 
=>gg  "
{hh 	
awaitii 
_moodServiceii 
.ii 
DeleteAsyncii *
(ii* +
	patientIdii+ 4
,ii4 5
moodIdii6 <
)ii< =
;ii= >
returnjj 
	NoContentjj 
(jj 
)jj 
;jj 
}kk 	
)kk	 

;kk
 
[mm 
HttpPostmm 
(mm 
$strmm $
)mm$ %
]mm% &
publicnn 

Tasknn 
<nn 
IActionResultnn 
>nn 
CreateJournalnn ,
(nn, -
intnn- 0
	patientIdnn1 :
,nn: ;
[nn< =
FromBodynn= E
]nnE F!
JournalEntryCreateDtonnG \
dtonn] `
)nn` a
=>oo 

SafeExecuteoo 
(oo 
asyncoo 
(oo 
)oo 
=>oo  "
{pp 	
varqq 
createdqq 
=qq 
awaitqq 
_journalServiceqq  /
.qq/ 0
CreateAsyncqq0 ;
(qq; <
	patientIdqq< E
,qqE F
dtoqqG J
)qqJ K
;qqK L
returnrr 
CreatedAtActionrr "
(rr" #
nameofrr# )
(rr) *
GetJournalsrr* 5
)rr5 6
,rr6 7
newrr8 ;
{rr< =
	patientIdrr> G
}rrH I
,rrI J
createdrrK R
)rrR S
;rrS T
}ss 	
)ss	 

;ss
 
[uu 
HttpGetuu 
(uu 
$struu #
)uu# $
]uu$ %
publicvv 

asyncvv 
Taskvv 
<vv 
ActionResultvv "
<vv" #
IReadOnlyListvv# 0
<vv0 1#
JournalEntryResponseDtovv1 H
>vvH I
>vvI J
>vvJ K
GetJournalsvvL W
(vvW X
intvvX [
	patientIdvv\ e
,vve f
[vvg h
	FromQueryvvh q
]vvq r
intvvs v
limitvvw |
=vv} ~
$num	vv Å
)
vvÅ Ç
{ww 
varxx 
listxx 
=xx 
awaitxx 
_journalServicexx (
.xx( )
	ListAsyncxx) 2
(xx2 3
	patientIdxx3 <
,xx< =
limitxx> C
)xxC D
;xxD E
returnyy 
Okyy 
(yy 
listyy 
)yy 
;yy 
}zz 
[|| 
HttpPut|| 
(|| 
$str|| /
)||/ 0
]||0 1
public}} 

Task}} 
<}} 
IActionResult}} 
>}} 
UpdateJournal}} ,
(}}, -
int}}- 0
	patientId}}1 :
,}}: ;
int}}< ?
	journalId}}@ I
,}}I J
[}}K L
FromBody}}L T
]}}T U!
JournalEntryCreateDto}}V k
dto}}l o
)}}o p
=>~~ 

SafeExecute~~ 
(~~ 
async~~ 
(~~ 
)~~ 
=>~~  "
{ 	
await
ÄÄ 
_journalService
ÄÄ !
.
ÄÄ! "
UpdateAsync
ÄÄ" -
(
ÄÄ- .
	patientId
ÄÄ. 7
,
ÄÄ7 8
	journalId
ÄÄ9 B
,
ÄÄB C
dto
ÄÄD G
)
ÄÄG H
;
ÄÄH I
return
ÅÅ 
	NoContent
ÅÅ 
(
ÅÅ 
)
ÅÅ 
;
ÅÅ 
}
ÇÇ 	
)
ÇÇ	 

;
ÇÇ
 
[
ÑÑ 

HttpDelete
ÑÑ 
(
ÑÑ 
$str
ÑÑ 1
)
ÑÑ1 2
]
ÑÑ2 3
public
ÖÖ 

Task
ÖÖ 
<
ÖÖ 
IActionResult
ÖÖ 
>
ÖÖ 
DeleteJournal
ÜÜ 
(
ÜÜ 
int
ÜÜ 
	patientId
ÜÜ #
,
ÜÜ# $
int
ÜÜ% (
	journalId
ÜÜ) 2
)
ÜÜ2 3
=>
áá 

SafeExecute
áá 
(
áá 
async
áá 
(
áá 
)
áá 
=>
áá  "
{
àà 	
await
ââ 
_journalService
ââ !
.
ââ! "
DeleteAsync
ââ" -
(
ââ- .
	patientId
ââ. 7
,
ââ7 8
	journalId
ââ9 B
)
ââB C
;
ââC D
return
ää 
	NoContent
ää 
(
ää 
)
ää 
;
ää 
}
ãã 	
)
ãã	 

;
ãã
 
private
çç 
static
çç 
async
çç 
Task
çç 
<
çç 
IActionResult
çç +
>
çç+ ,
SafeExecute
çç- 8
(
çç8 9
Func
çç9 =
<
çç= >
Task
çç> B
<
ççB C
IActionResult
ççC P
>
ççP Q
>
ççQ R
action
ççS Y
)
ççY Z
{
éé 
try
èè 
{
êê 	
return
ëë 
await
ëë 
action
ëë 
(
ëë  
)
ëë  !
;
ëë! "
}
íí 	
catch
ìì 
(
ìì 
ArgumentException
ìì  
ex
ìì! #
)
ìì# $
{
ìì% &
return
ìì' -
new
ìì. 1$
BadRequestObjectResult
ìì2 H
(
ììH I
ex
ììI K
.
ììK L
Message
ììL S
)
ììS T
;
ììT U
}
ììV W
catch
îî 
(
îî "
KeyNotFoundException
îî #
ex
îî$ &
)
îî& '
{
îî( )
return
îî* 0
new
îî1 4"
NotFoundObjectResult
îî5 I
(
îîI J
ex
îîJ L
.
îîL M
Message
îîM T
)
îîT U
;
îîU V
}
îîW X
}
ïï 
}ññ ∑
pE:\Master\Sem1\Requirements\Prototype\PSYCare-Backend\PSYCare\PSYCare\Controllers\Models\UpdatePatientRequest.cs
	namespace 	
PSYCare
 
. 
Controllers 
. 
Models $
;$ %
public 
class  
UpdatePatientRequest !
{ 
public 

string 
? 
	Diagnosis 
{ 
get "
;" #
set$ '
;' (
}) *
public 

string 
? 
PsychologistNotes $
{% &
get' *
;* +
set, /
;/ 0
}1 2
} …
fE:\Master\Sem1\Requirements\Prototype\PSYCare-Backend\PSYCare\PSYCare\Controllers\Models\SessionDto.cs
	namespace 	
PSYCare
 
. 
Controllers 
. 
Models $
{ 
public 

class 
SessionCreateDto !
{ 
public 
int 
	PatientId 
{ 
get "
;" #
set$ '
;' (
}) *
public 
int 
PsychologistId !
{" #
get$ '
;' (
set) ,
;, -
}. /
public 
DateTime 
ScheduledAt #
{$ %
get& )
;) *
set+ .
;. /
}0 1
public 
string 
? 
Notes 
{ 
get "
;" #
set$ '
;' (
}) *
public		 
string		 
Status		 
{		 
get		 "
;		" #
set		$ '
;		' (
}		) *
=		+ ,
$str		- 6
;		6 7
}

 
public 

class 
SessionResponseDto #
{ 
public 
int 
Id 
{ 
get 
; 
set  
;  !
}" #
public 
int 
	PatientId 
{ 
get "
;" #
set$ '
;' (
}) *
public 
int 
PsychologistId !
{" #
get$ '
;' (
set) ,
;, -
}. /
public 
DateTime 
ScheduledAt #
{$ %
get& )
;) *
set+ .
;. /
}0 1
public 
string 
? 
Status 
{ 
get  #
;# $
set% (
;( )
}* +
public 
string 
? 
Notes 
{ 
get "
;" #
set$ '
;' (
}) *
} 
} à!
lE:\Master\Sem1\Requirements\Prototype\PSYCare-Backend\PSYCare\PSYCare\Controllers\PsychologistsController.cs
	namespace 	
PSYCare
 
. 
Controllers 
; 
[ 
ApiController 
] 
[		 
Route		 
(		 
$str		 
)		 
]		 
public

 
class

 #
PsychologistsController

 $
:

% &
ControllerBase

' 5
{ 
private 
readonly !
IPsychologistsService *!
_psychologistsService+ @
;@ A
public 
#
PsychologistsController "
(" #!
IPsychologistsService# 8 
psychologistsService9 M
)M N
{ !
_psychologistsService 
=  
psychologistsService  4
;4 5
} 
[ 
HttpPost 
( 
$str  
)  !
]! "
public 

async 
Task 
< 
IActionResult #
># $
CreatePsychologist% 7
(7 8
[8 9
FromBody9 A
]A B%
CreatePsychologistRequestC \
request] d
)d e
{ 
if 

( 
request 
is 
null 
) 
return 

BadRequest 
( 
) 
;  
var 
psychologist 
= 
await  !
_psychologistsService! 6
.6 7#
CreatePsychologistAsync7 N
(N O
MapToServiceModelO `
(` a
requesta h
)h i
)i j
;j k
return 
Ok 
( 
new 
{ 	
type 
= 
$str !
,! "
data 
= 
psychologist 
} 	
)	 

;
 
}   
["" 
HttpGet"" 
("" 
$str"" ,
)"", -
]""- .
public## 

async## 
Task## 
<## 
IActionResult## #
>### $&
GetPatientsForPsychologist##% ?
(##? @
int##@ C
psychologistId##D R
)##R S
{$$ 
var%% 
patients%% 
=%% 
await%% !
_psychologistsService%% 2
.%%2 3&
GetPatientsForPsychologist%%3 M
(%%M N
psychologistId%%N \
)%%\ ]
;%%] ^
return'' 
patients'' 
is'' 
null'' 
?(( 
NotFound(( 
((( 
)(( 
:)) 
Ok)) 
()) 
patients)) 
))) 
;)) 
}** 
[,, 
HttpGet,, 
(,, 
$str,, 
),, 
],, 
public-- 

async-- 
Task-- 
<-- 
IActionResult-- #
>--# $
GetAllPsychologists--% 8
(--8 9
)--9 :
{.. 
var// 
psychologists// 
=// 
await// !!
_psychologistsService//" 7
.//7 8$
GetAllPsychologistsAsync//8 P
(//P Q
)//Q R
;//R S
return00 
Ok00 
(00 
psychologists00 
)00  
;00  !
}11 
private33 
static33 
Psychologist33 
MapToServiceModel33  1
(331 2%
CreatePsychologistRequest332 K
request33L S
)33S T
=>33U W
new44 
(44 
)44 
{55 	
Email66 
=66 
request66 
.66 
Email66 !
,66! "
Name77 
=77 
request77 
.77 
Name77 
,77  
Location88 
=88 
request88 
.88 
Location88 '
,88' (
Password99 
=99 
request99 
.99 
Password99 '
}:: 	
;::	 

};; Â
pE:\Master\Sem1\Requirements\Prototype\PSYCare-Backend\PSYCare\PSYCare\Controllers\Models\MoodEntryResponseDto.cs
	namespace 	
PSYCare
 
. 
Controllers 
. 
Models $
{ 
public 

record  
MoodEntryResponseDto &
(& '
int' *
Id+ -
,- .
int/ 2
Score3 8
,8 9
string: @
?@ A
EmojiB G
,G H
stringI O
?O P
NotesQ V
,V W
stringX ^
?^ _
AudioUrl` h
,h i
DateTimeOffsetj x
	CreatedAt	y Ç
)
Ç É
;
É Ñ
} ç
hE:\Master\Sem1\Requirements\Prototype\PSYCare-Backend\PSYCare\PSYCare\Controllers\Models\LoginRequest.cs
	namespace 	
PSYCare
 
. 
Controllers 
. 
Models $
{ 
public 

class 
LoginRequest 
{ 
public 
string 
Email 
{ 
get !
;! "
set# &
;& '
}( )
public 
string 
Password 
{  
get! $
;$ %
set& )
;) *
}+ ,
} 
} •
sE:\Master\Sem1\Requirements\Prototype\PSYCare-Backend\PSYCare\PSYCare\Controllers\Models\JournalEntryResponseDto.cs
	namespace 	
PSYCare
 
. 
Controllers 
. 
Models $
{ 
public 

record #
JournalEntryResponseDto )
() *
int* -
Id. 0
,0 1
string2 8
?8 9
Text: >
,> ?
DateTimeOffset@ N
	CreatedAtO X
)X Y
;Y Z
} Ø
qE:\Master\Sem1\Requirements\Prototype\PSYCare-Backend\PSYCare\PSYCare\Controllers\Models\JournalEntryCreateDto.cs
	namespace 	
PSYCare
 
. 
Controllers 
. 
Models $
{ 
public 

record !
JournalEntryCreateDto '
(' (
string( .
?. /
Text0 4
)4 5
;5 6
} Ÿ
uE:\Master\Sem1\Requirements\Prototype\PSYCare-Backend\PSYCare\PSYCare\Controllers\Models\CreatePsychologistRequest.cs
	namespace 	
PSYCare
 
. 
Controllers 
. 
Models $
;$ %
public 
class %
CreatePsychologistRequest &
{ 
public 

string 
Email 
{ 
get 
; 
set "
;" #
}$ %
public 

string 
Password 
{ 
get  
;  !
set" %
;% &
}' (
public 

string 
Name 
{ 
get 
; 
set !
;! "
}# $
public 

string 
? 
Location 
{ 
get !
;! "
set# &
;& '
}( )
}		 
pE:\Master\Sem1\Requirements\Prototype\PSYCare-Backend\PSYCare\PSYCare\Controllers\Models\CreatePatientRequest.cs
	namespace 	
PSYCare
 
. 
Controllers 
. 
Models $
{ 
public 

class  
CreatePatientRequest %
{ 
public 
string 
Name 
{ 
get  
;  !
set" %
;% &
}' (
public 
string 
Email 
{ 
get !
;! "
set# &
;& '
}( )
public 
string 
Password 
{  
get! $
;$ %
set& )
;) *
}+ ,
public 
string 
PhoneNumber !
{" #
get$ '
;' (
set) ,
;, -
}. /
public		 
string		 
?		 
Faculty		 
{		  
get		! $
;		$ %
set		& )
;		) *
}		+ ,
public

 
string

 
?

 
Location

 
{

  !
get

" %
;

% &
set

' *
;

* +
}

, -
public 
string 
? 
IssueDescription '
{( )
get* -
;- .
set/ 2
;2 3
}4 5
public 
int 
Age 
{ 
get 
; 
set !
;! "
}# $
} 
} Ü
uE:\Master\Sem1\Requirements\Prototype\PSYCare-Backend\PSYCare\PSYCare\Controllers\Models\AssignPsychologistRequest.cs
	namespace 	
PSYCare
 
. 
Controllers 
. 
Models $
;$ %
public 
class %
AssignPsychologistRequest &
{ 
public 

string 
PsychologistEmail #
{$ %
get& )
;) *
set+ .
;. /
}0 1
} Í
eE:\Master\Sem1\Requirements\Prototype\PSYCare-Backend\PSYCare\PSYCare\Controllers\CrisisController.cs
	namespace 	
PSYCare
 
. 
Controllers 
{ 
[		 
ApiController		 
]		 
[

 
Route

 

(


 
$str

 
)

 
]

 
public 

class 
CrisisController !
:" #

Controller$ .
{ 
private 
readonly 
ICrisisService '
_crisisService( 6
;6 7
public 
CrisisController 
(  
ICrisisService  .
crisisService/ <
)< =
{ 	
_crisisService 
= 
crisisService *
;* +
} 	
[ 	
HttpPost	 
] 
[ 	
Route	 
( 
$str #
)# $
]$ %
public 
async 
Task 
< 
IActionResult '
>' (
Crisis) /
(/ 0
int0 3
	pacientId4 =
)= >
{ 	
if 
( 
! 
await 
_crisisService %
.% &+
NotifyPsychologistOfCrisisAsync& E
(E F
	pacientIdF O
)O P
)P Q
{ 
return 
NotFound 
(  
)  !
;! "
} 
return 
Ok 
( 
new 
{ 
message #
=$ %
$str& K
}L M
)M N
;N O
} 	
} 
}   ˙
cE:\Master\Sem1\Requirements\Prototype\PSYCare-Backend\PSYCare\PSYCare\Controllers\AuthController.cs
	namespace 	
PSYCare
 
. 
Controllers 
; 
[ 
ApiController 
] 
[ 
Route 
( 
$str 
) 
] 
public		 
class		 
AuthController		 
(		 
IAuthService		 (
authService		) 4
)		4 5
:		6 7
ControllerBase		8 F
{

 
private 
readonly 
IAuthService !
_authService" .
=/ 0
authService1 <
;< =
[ 
HttpPost 
( 
$str 
) 
] 
public 

async 
Task 
< 
IActionResult #
># $
Login% *
(* +
[+ ,
FromBody, 4
]4 5
LoginRequest6 B
requestC J
)J K
{ 
var 
result 
= 
await 
_authService '
.' (

LoginAsync( 2
(2 3
request3 :
.: ;
Email; @
,@ A
requestB I
.I J
PasswordJ R
)R S
;S T
return 
result 
is 
null 
? 
Unauthorized  ,
(, -
)- .
:/ 0
Ok1 3
(3 4
result4 :
): ;
;; <
} 
[ 
HttpGet 
( 
$str 
) 
] 
public 

async 
Task 
< 
IActionResult #
># $
GetUserById% 0
(0 1
int1 4
id5 7
)7 8
{ 
var 
result 
= 
await 
_authService '
.' (
GetUserByIdAsync( 8
(8 9
id9 ;
); <
;< =
return 
result 
is 
null 
? 
NotFound  (
(( )
)) *
:+ ,
Ok- /
(/ 0
result0 6
)6 7
;7 8
} 
} 