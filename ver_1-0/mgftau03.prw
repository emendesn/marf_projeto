#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"   
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*
==========================================================================================================
Programa.:              MGFTAU03
Autor....:              Marcelo Carneiro         
Data.....:              2017
Descricao / Objetivo:   Executa SQL.
Doc. Origem:            
Solicitante:            Totvs
Uso......:              Marfrig
Obs......:              
==========================================================================================================
*/

User Function MGFTAU03        
Private cSQL      

SetPrvt("oDlg1","oSQL","oBtn1")
                                   
RpcSetType(3)
RpcSetEnv( "01" , "010001" , Nil, Nil, "EST", Nil )

oDlg1      := MSDialog():New( 092,232,426,770,"Executa",,,.F.,,,,,,.T.,,,.T. )
oSQL       := TMultiGet():New( 008,012,{|u| If(PCount()>0,cSQL:=u,cSQL)},oDlg1,244,124,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )
oBtn1      := TButton():New( 136,200,"Executa SQL",oDlg1,{|| Ex_SQL()} ,057,012,,,,.T.,,"",,,,.F. )

oDlg1:Activate(,,,.T.)                             
          
Return
***************************************************************************88888
Static Function Ex_SQL
Local cQuery := ''

cQuery := cSQL
IF (TcSQLExec(cQuery) < 0)
    MemoWrite("c:\temp\Erro"+StrTran(Time(),":","")+".txt",TcSQLError())
EndIF


Return

