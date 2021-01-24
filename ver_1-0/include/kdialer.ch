/*
Include DIALUP.CH criada por Fabio Fongaro em 27/02/03
Para facilitar a utilizacao das funcoes de dial-up
*/
#define TYPECONNECTION "PPP"
#DEFINE DIALUPPARAM    "11"

#xcommand CREATE DIALUP [ <name: NAME, ENTRY>      <cEntry>  ] ;
                         [ <device: DEVICE, MODEM>  <cDevice> ] ;
                         [ <dial: DIAL, DIALNUMBER> <cDial>   ] ;
                         [ <user: USER, USERNAME>   <cUser>   ] ;
                         [ <result: RESULT>         <lResult> ] ;
                         => ;                                    
                         [ <lResult> := ]MsRASSetEntryProperties( <cEntry> , <cUser> , <cDevice> , DIALUPPARAM , <cDial> , TYPECONNECTION , .T. , .F. , .T. , .T. , .F. )
                        
#xcommand DEFINE DIALUP [ <name: NAME, ENTRY>      <cEntry>  ] ;
                         [ <dial: DIAL, DIALNUMBER> <cDial>   ] ;
                         [ <user: USER, USERNAME>   <cUser>   ] ;
                         [ <pass: PASSWORD>         <cPwd>    ] ;
                         [ <result: RESULT>         <lResult> ] ;
                         => ;
                         [ <lResult> := ]MsRASSetDialEntryParams( <cEntry> , <cDial> , <cUser> , <cPwd> )
                     

#xcommand CONNECT DIALUP [ <name: NAME, ENTRY>      <cEntry>  ] ;
                          [ <dial: DIAL, DIALNUMBER> <cDial>   ] ;
                          [ <user: USER, USERNAME>   <cUser>   ] ;
                          [ <pass: PASSWORD>         <cPwd>    ] ;
                          [ <result: RESULT>         <lResult> ] ;
                          => ;
                          [ <lResult> := ]MsRASDial( <cEntry> , <cDial> , <cUser> , <cPwd> )

#xcommand GET DIALUP ERROR [ <cError> ] ;
                             => ;
                            [ <cError> := ]MsRASGetStringError(MsRASGetLastError())
                           
#xcommand DISCONNECT DIALUP [<result: RESULT> <lResult> ];
                            => ;
                            [ <lResult> := ]MsRASHangUp()

#xcommand DEFINE STREAM [ <oStream> ] ;
                         [ <txt: TEXT> <cTxt> ] ;
                         => ;
                         [ <oStream> := ] TFileStream():New( <cTxt> )

#translate ExistDialUp( => MsRASDosEntryExist(
#translate GetDialUp( => MsRASGetEntry(
#translate DialUpDevice( => MsRASGetDevice(
#translate DialUpConnected( => MsRASIsConnected(
