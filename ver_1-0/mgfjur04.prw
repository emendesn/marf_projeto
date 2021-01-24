#include "totvs.ch"
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'COLORS.CH'     
  
#define CRLF chr(13) + chr(10)             
/*
=====================================================================================
Programa.:              MGFJUR04
Autor....:              Marcelo Carneiro
Data.....:              15/03/2019
Descricao / Objetivo:   Integração Grade de Aprovação SigaJuri
Doc. Origem:            MIT044
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Envio de Email 
=====================================================================================
*/
User Function MGFJUR04 

Local cQuery := ''

Private aMatriz   := {"01","010001"}  
Private lIsBlind  :=  IsBlind() .OR. Type("__LocalDriver") == "U"                                                            
Private cHtml     :=  ''    

IF lIsBlind
	RpcSetType(3)
	RpcSetEnv(aMatriz[1],aMatriz[2])
	If !LockByName("MGFJUR04")
		Conout("JOB já em Execução : MGFJUR04 " + DTOC(dDATABASE) + " - " + TIME() )
		RpcClearEnv()
		Return
	EndIf   
EndIF
          
dbSelectArea('ZJ1')


cQuery  := " SELECT R_E_C_N_O_ RECNOZJ1, ZJ1.* "
cQuery  += " FROM "+RetSqlName("ZJ1")+" ZJ1"
cQuery  += " WHERE D_E_L_E_T_  = ' ' "
cQuery  += " AND ZJ1_EMAIL ='S' "
cQuery  += " AND ZJ1_STATUS not in ('5','6') "


If Select("QRY_EMAIL") > 0                                                           
	QRY_EMAI2->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_EMAIL",.T.,.F.)
dbSelectArea("QRY_EMAIL")
QRY_EMAIL->(dbGoTop())
While QRY_EMAIL->(!EOF())
	ZJ1->(dbGoto(QRY_EMAIL->RECNOZJ1))
	IF EnvMail()                       
		RecLock("ZJ1", .F.)
		ZJ1->ZJ1_EMAIL  := 'N'
		ZJ1->(msUnlock())
	EndIF
	QRY_EMAIL->(dbSkip())
End

Return
******************************************************************************************************************************************************************	
Static Function EnvMail()

Local oMail, oMessage
Local nErro		 := 0
Local lRetMail 	 := .T.
Local cSmtpSrv   := GETMV("MGF_SMTPSV")
Local cCtMail    := 'juridico'//GETMV("MGF_CTMAIL")
Local cPwdMail   := GETMV("MGF_PWMAIL")
Local nMailPort  := GETMV("MGF_PTMAIL")
Local nParSmtpP  := GETMV("MGF_PTSMTP")
Local nSmtpPort
Local nTimeOut   := GETMV("MGF_TMOUT")
Local cEmail     := 'juridico@marfrig.com.br'//GETMV("MGF_EMAIL")
Local cErrMail
Local cTexto     := ''
Local cTexto2    := ''
Local cRegistro  := ''
Local cDados     := ''             
Local cPara      := ''
Local cTab       := ''                 
Local cQuery     := ''
Local cCab       := '' 
Local cTipDesp   := ''
Local nCont      := 0 
                           
Private cGrpJUR  := GetMV('MGF_JGRPAP',.F.,"") 


oMail := TMailManager():New()

if nParSmtpP == 25
	oMail:SetUseSSL( .F. )
	oMail:SetUseTLS( .F. )
	oMail:Init("", cSmtpSrv, cCtMail, cPwdMail,, nParSmtpP)
elseif nParSmtpP == 465
	nSmtpPort := nParSmtpP
	oMail:SetUseSSL( .T. )
	oMail:Init("", cSmtpSrv, cCtMail, cPwdMail,, nSmtpPort)
else
	nParSmtpP == 587
	nSmtpPort := nParSmtpP
	oMail:SetUseTLS( .T. )
	oMail:Init("", cSmtpSrv, cCtMail, cPwdMail,, nSmtpPort)
endif

oMail:SetSmtpTimeOut( nTimeOut )
nErro := oMail:SmtpConnect()

If nErro != 0
	cErrMail :=("ERROR:" + oMail:GetErrorString(nErro))
	//conout(cErrMail)
	IF !lIsBlind
		Alert(cErrMail)
	EndIF
	oMail:SMTPDisconnect()
	lRetMail := .F.
	Return (lRetMail)
Endif

If 	nParSmtpP != 25
	nErro := oMail:SmtpAuth(cCtMail, cPwdMail)
	If nErro != 0
		cErrMail :=("ERROR:" + oMail:GetErrorString(nErro))
		//conout(cErrMail)
		IF !lIsBlind
	   	     Alert(cErrMail)
		EndIF
		oMail:SMTPDisconnect()
		lRetMail := .F.
		Return (lRetMail)
	Endif
Endif                                   
//definição para destino do email ....
cTab := ZJ1->ZJ1_TAB
                                       
dbSelectArea('NUR')
RD0->(DbOrderNickName('USER'))
       
dbSelectArea(cTab)
&(cTab+'->(dbSetOrder(1))')  
&(cTab+'->(dbGoTo(ZJ1->ZJ1_RECNO))')
Do Case
	Case ZJ1->ZJ1_STATUS == '1' .OR.;//Pendente de aprovação juridica vai para Grupo Juridico - Parametro
	     (ZJ1->ZJ1_STATUS == '4' .AND. &(cTab+'->'+cTab+'_XORIG') == '1' )//Rejeitado pelo Cap mas origem interna
		cQuery  := " SELECT RD0_EMAIL "
		cQuery  += " FROM "+RetSqlName("RD0")+" RD0"
		cQuery  += " WHERE RD0.D_E_L_E_T_  = ' ' "
		cQuery  += "  AND RD0_TIPO = '1'"
		cQuery  += "  AND RD0_EMAIL <> ' '"
		If Select("QRY_EMAIL2") > 0
			QRY_EMAIL2->(dbCloseArea())
		EndIf
		cQuery  := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_EMAIL2",.T.,.F.)
		dbSelectArea("QRY_EMAIL2")
		QRY_EMAIL2->(dbGoTop())
		While !QRY_EMAIL2->(EOF())
			nCont++
			cPara += IIF(nCont <> 1,';','')+Alltrim( QRY_EMAIL2->RD0_EMAIL )
			QRY_EMAIL2->(dbSkip())
		End
		
	Case ZJ1->ZJ1_STATUS == '2' //Pendente de aprovação CAP para todos os participantes que são do NUR_XTIPO 3=CAP
		cQuery  := " SELECT RD0_EMAIL "
		cQuery  += " FROM "+RetSqlName("RD0")+" RD0"
		cQuery  += " WHERE RD0.D_E_L_E_T_  = ' ' "
		cQuery  += "  AND RD0_TIPO = '3'"
		cQuery  += "  AND RD0_EMAIL <> ' '"
		If Select("QRY_EMAIL2") > 0
			QRY_EMAIL2->(dbCloseArea())
		EndIf
		cQuery  := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_EMAIL2",.T.,.F.)
		dbSelectArea("QRY_EMAIL2")
		QRY_EMAIL2->(dbGoTop())
		While !QRY_EMAIL2->(EOF())
			nCont++
			cPara += IIF(nCont <> 1,';','')+Alltrim( QRY_EMAIL2->RD0_EMAIL )
			QRY_EMAIL2->(dbSkip())
		End
	Case ZJ1->ZJ1_STATUS == '3' .OR.; //Rejeitado pelo Juridico para o escritorio Juridico SU5 - U5_EMAIL
	     (ZJ1->ZJ1_STATUS == '4' .AND. &(cTab+'->'+cTab+'_XORIG') == '2') //Rejeitado pelo Cap mas origem externa

		cQuery  := " SELECT U5_EMAIL "
		cQuery  += " FROM "+RetSqlName("SU5")
		cQuery  += " WHERE D_E_L_E_T_  = ' ' "
		cQuery  += "  AND U5_CODCONT in ( Select AC8_CODCON"
		cQuery  += "                      from "+RetSqlName("AC8")+ ' B'
		cQuery  += "                      WHERE B.D_E_L_E_T_  = ' ' "
		cQuery  += "                       AND  AC8_ENTIDA = 'SA2'"
		cQuery  += "                       AND  AC8_CODENT = ( Select NUQ_LCORRE || NUQ_CCORRE "
		cQuery  += "                                           from "+RetSqlName("NUQ")+ ' C'
		cQuery  += "                                           WHERE B.D_E_L_E_T_  = ' ' "
		cQuery  += "                                             AND NUQ_CAJURI	   = '"+&(cTab+'->'+cTab+'_CAJURI')+"'	"
		cQuery  += "                                             AND NUQ_COD       = '"+&(cTab+'->'+cTab+'_COD')+"' ) )"
		If Select("QRY_EMAIL2") > 0
			QRY_EMAIL2->(dbCloseArea())
		EndIf
		cQuery  := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_EMAIL2",.T.,.F.)
		dbSelectArea("QRY_EMAIL2")
		QRY_EMAIL2->(dbGoTop())
		While !QRY_EMAIL2->(EOF())
		    nCont++
			cPara += IIF(nCont <> 1,';','')+Alltrim( QRY_EMAIL2->U5_EMAIL )
			QRY_EMAIL2->(dbSkip())
		End
EndCase

//cPara := 'marcelo08.carneiro@gmail.com'
/*
01 - ( Pendente de aprovação juridica )
02 - ( Pendente de aprovação CAP)
03 - ( Rejeitado pelo Juridico )
04 - ( Aprovado )
05 - ( ReAprovado pelo CAP )
*/
      
IF Empty(cPara)      
    Return .F.
EndIF

IF cTAB =='NT2' 
  cTipDesp   := 'Garantia'
Else                      
  cTipDesp   := 'Despesa'
EndIF
cTexto := ''
IF ZJ1->ZJ1_STATUS == '1' .OR. ZJ1->ZJ1_STATUS == '2'
    cCab   := 'Existe uma '+cTipDesp+' pendente de Aprovação'
	cTexto := 'A seguinte '+cTipDesp+' está pendente de aprovação: '
ElseIF  ZJ1->ZJ1_STATUS == '3'    
	cCab   := cTipDesp+' Rejeitada pelo Jurídico'
	cTexto := 'A seguinte '+cTipDesp+' foi rejeitada:'
ElseIF  ZJ1->ZJ1_STATUS == '5'    
	cCab := cTipDesp+' Reprovada pelo Contas à pagar' 
	cTexto := 'A seguinte '+cTipDesp+' foi reprovada:'
EndIF


cHtml     :=  '' 	
cHtml     += '<pre><span style="color: #0000ff;"><span style="font-family:arial,helvetica,sans-serif;"><strong><em>'+cTexto+'</em></strong></span> '
cHtml     += CRLF+' '+CRLF
cHtml     += 'C&oacute;d. do Assunto Jur&iacute;dico .: '+Alltrim(&(cTab+'->'+cTab+'_CAJURI'))+CRLF
cHtml     += 'N&uacute;mero do Processo .......: '+Alltrim(POSICIONE('NUQ',2,XFILIAL('NUQ')+&(cTab+'->'+cTab+'_CAJURI')+'1','NUQ_NUMPRO'))+CRLF        
cHtml     += 'Polo Ativo ...............: '+Alltrim(POSICIONE('NT9',3,XFILIAL('NT9')+&(cTab+'->'+cTab+'_CAJURI')+'1'+'1','NT9_NOME'))+CRLF
cHtml     += 'Polo Passivo .............: '+Alltrim(POSICIONE('NT9',3,XFILIAL('NT9')+&(cTab+'->'+cTab+'_CAJURI')+'2'+'1','NT9_NOME'))+CRLF
cHtml     += 'Data do lan&ccedil;amento........: '+DTOC(&(cTab+'->'+cTab+'_DATA'))+CRLF
cHtml     += 'Moeda ....................: '+POSICIONE('CTO',1,XFILIAL('CTO')+&(cTab+'->'+cTab+'_CMOEDA'),'CTO_SIMB')+CRLF
cHtml     += 'Valor ....................: '+Transform(&(cTab+'->'+cTab+'_VALOR'),"@e 999,999,999.99")+CRLF
IF cTab =='NT2'
  cHtml     += 'Forma de Corre&ccedil;&atilde;o ........: '+POSICIONE('NW7',1,XFILIAL('NW7')+&(cTab+'->'+cTab+'_CCOMON'),'NW7_DESC')+CRLF
  cHtml     += 'Valor Atualizado .........: '+Transform(&(cTab+'->'+cTab+'_VLRATU'),"@e 999,999,999.99")+'</span>'+CRLF                          
EndIF
IF ZJ1->ZJ1_STATUS == '3' .OR.  ZJ1->ZJ1_STATUS == '5'   
	 cHtml     += '<span style="color: #0000ff;">Motivo ...................: '+Alltrim(ZJ1->ZJ1_MOTIVO)+'</span></pre>'
Else
     cHtml     += '</pre>'
EndiF     

oMessage := TMailMessage():New()
oMessage:Clear()
oMessage:cFrom                  := cEmail
oMessage:cTo                    := cPara
oMessage:cCc                    := ""
oMessage:cSubject               := cCab
oMessage:cBody                  := cHtml
nErro := oMessage:Send( oMail )

if nErro != 0
	cErrMail :=("ERROR:" + oMail:GetErrorString(nErro))
	//conout(cErrMail)
	IF !lIsBlind
   	     Alert(cErrMail)
	EndIF
	oMail:SMTPDisconnect()
	lRetMail := .F.
	Return (lRetMail)
Endif

//conout('Desconectando do SMTP')
oMail:SMTPDisconnect()

Return lRetMail
******************************************************************************************************************************************************************	
