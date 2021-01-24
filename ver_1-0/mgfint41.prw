#include "totvs.ch"
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'COLORS.CH'     
  
#define CRLF chr(13) + chr(10)             
/*
=====================================================================================
Programa............: MGFINT41
Autor...............: Marcelo Carneiro
Data................: 28/03/2017
Descricao / Objetivo: Integração De Cadastros
Doc. Origem.........: Contrato GAPS - MIT044- BLOQUEIO DE CADASTROS
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Envio de Email
=====================================================================================
*/
User Function MGFINT41 

Local cQuery := ''

Private aMatriz   := {"01","010001"}  
Private lIsBlind  :=  IsBlind() .OR. Type("__LocalDriver") == "U"                                                            
Private cHtml     :=  ''    

IF lIsBlind
	RpcSetType(3)
	RpcSetEnv(aMatriz[1],aMatriz[2])
	If !LockByName("MGFINT41")
		Conout("JOB já em Execução : MGFINT41 " + DTOC(dDATABASE) + " - " + TIME() )
		RpcClearEnv()
		Return
	EndIf   
EndIF
          
dbSelectArea('ZB1')


cQuery  := " SELECT R_E_C_N_O_ RECNOZB1, ZB1.* , ( Select MAX(ZB2.ZB2_OBS) "
cQuery  += "                                       FROM "+RetSqlName("ZB2")+" ZB2 "
cQuery  += "                                       Where ZB2.D_E_L_E_T_= '' "
cQuery  += "                                         AND ZB2_ID        = ZB1_ID "
cQuery  += "                                         AND ZB2_STATUS    = '2') ZB1_OBS"
cQuery  += " FROM "+RetSqlName("ZB1")+" ZB1"
cQuery  += " WHERE D_E_L_E_T_  = ' ' "
cQuery  += " AND ZB1_EMAIL ='S' "

If Select("QRY_EMAIL") > 0                                                           
	QRY_EMAIL->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_EMAIL",.T.,.F.)
dbSelectArea("QRY_EMAIL")
QRY_EMAIL->(dbGoTop())
While QRY_EMAIL->(!EOF())
	IF EnvMail('1')
		ZB1->(dbGoto(QRY_EMAIL->RECNOZB1))
		RecLock("ZB1", .F.)
		ZB1->ZB1_EMAIL  := 'N'
		ZB1->(msUnlock())
	EndIF
	QRY_EMAIL->(dbSkip())
End


dbSelectArea('ZB2')

cQuery  := " SELECT ZB2.R_E_C_N_O_ RECNOZB2, ZB1.* , ZB2.* "
cQuery  += " FROM "+RetSqlName("ZB2")+" ZB2, "+RetSqlName("ZB1")+" ZB1"
cQuery  += " WHERE ZB2.D_E_L_E_T_  = ' ' "
cQuery  += "   AND ZB1.D_E_L_E_T_  = ' ' "
cQuery  += "   AND ZB1_ID          = ZB2_ID "
cQuery  += "   AND ZB2_EMAIL       = 'S' "

If Select("QRY_EMAIL") > 0                                                           
	QRY_EMAIL->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_EMAIL",.T.,.F.)
dbSelectArea("QRY_EMAIL")
QRY_EMAIL->(dbGoTop())
While QRY_EMAIL->(!EOF())
	IF EnvMail('2')
	    ZB2->(dbGoto(QRY_EMAIL->RECNOZB2))
	    RecLock("ZB2", .F.)
		ZB2->ZB2_EMAIL  := 'N'
		ZB2->(msUnlock())
	EndIF
	QRY_EMAIL->(dbSkip())
End
Elimina_Cad()

Return
******************************************************************************************************************************************************************	
Static Function EnvMail(cTipo)

Local oMail, oMessage
Local nErro		 := 0
Local lRetMail 	 := .T.
Local cSmtpSrv   := GETMV("MGF_SMTPSV")
Local cCtMail    := GETMV("MGF_CTMAIL")
Local cPwdMail   := GETMV("MGF_PWMAIL")
Local nMailPort  := GETMV("MGF_PTMAIL")
Local nParSmtpP  := GETMV("MGF_PTSMTP")
Local nSmtpPort
Local nTimeOut   := GETMV("MGF_TMOUT")
Local cEmail     := GETMV("MGF_EMAIL")
Local cErrMail
Local cTexto     := ''
Local cTexto2    := ''
Local cRegistro  := ''
Local cDados     := ''             
Local cPara      := ''


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
IF cTipo == '1' 
     cPara := UsrRetMail(QRY_EMAIL->ZB1_USER)
     IF Empty(cPara)
	     //conout('Usuario sem email cadastrado :'+QRY_EMAIL->ZB1_USER)
		IF !lIsBlind
			Alert('Usuario sem email cadastrado :'+QRY_EMAIL->ZB1_USER)
		EndIF
		Return .F.
	EndIF
Else
	dbSelectArea('ZAZ')
	ZAZ->(dbSetOrder(3))
	ZAZ->(dbSeek(QRY_EMAIL->ZB2_IDSET))
	While ZAZ->(!Eof()) .And. ZAZ->ZAZ_IDSET == QRY_EMAIL->ZB2_IDSET
	   cPara += ZAZ->ZAZ_EMAIL+';'
	   ZAZ->(dbSkip())
	End           
	cPara := SUBSTR(cPara,1,Len(cPara)-1)
EndIF     


cTexto := ''
IF QRY_EMAIL->ZB1_TIPO == '1' 
    cTexto += 'Inclusão'
Else
    cTexto +='Alteração'
EndIF
DO CASE 
    CASE QRY_EMAIL->ZB1_CAD == '1'    
       cTexto2    :=  "Cliente"
       dbSelectArea('SA1')                 
       SA1->(dbGoTo(QRY_EMAIL->ZB1_RECNO))
       cRegistro  := SA1->A1_COD 	
       cDados     := SA1->A1_NOME 
    CASE QRY_EMAIL->ZB1_CAD == '2'    
       cTexto2    :=  "Endereço de Entrega"
       dbSelectArea('SZ9')                 
       SZ9->(dbGoTo(QRY_EMAIL->ZB1_RECNO))
       cRegistro  := SZ9->Z9_ZCLIENT	
       cDados     := SZ9->Z9_ZRAZEND
    CASE QRY_EMAIL->ZB1_CAD == '3'    
       cTexto2    :=  "Fornecedor"
       dbSelectArea('SA2')                 
       SA2->(dbGoTo(QRY_EMAIL->ZB1_RECNO))
       cRegistro  := SA2->A2_COD+'-'+SA2->A2_LOJA 	
       cDados     := SA2->A2_NOME 
    CASE QRY_EMAIL->ZB1_CAD == '4'    
       cTexto2    :=  "Transportadora"
       dbSelectArea('SA4')                 
       SA4->(dbGoTo(QRY_EMAIL->ZB1_RECNO))
       cRegistro  := SA4->A4_COD 	
       cDados     := SA4->A4_NOME 
    CASE QRY_EMAIL->ZB1_CAD == '5'    
       cTexto2    :=  "Vendedor"
       dbSelectArea('SA3')                 
       SA3->(dbGoTo(QRY_EMAIL->ZB1_RECNO))
       cRegistro  := SA3->A3_COD 	
       cDados     := SA3->A3_NOME 
    CASE QRY_EMAIL->ZB1_CAD == '6'    
       cTexto2    :=  "Veiculo"
       dbSelectArea('DA3')                 
       DA3->(dbGoTo(QRY_EMAIL->ZB1_RECNO))
       cRegistro  := DA3->DA3_COD	
       cDados     := DA3->DA3_DESC
    CASE QRY_EMAIL->ZB1_CAD == '7'    
       cTexto2    :=  "Motorista"
       dbSelectArea('DA4')                 
       DA4->(dbGoTo(QRY_EMAIL->ZB1_RECNO))
       cRegistro  := DA4->DA4_COD	
       cDados     := DA4->DA4_NOME
    CASE QRY_EMAIL->ZB1_CAD == '8'    
       cTexto2    :=  "Cadastro de Produto"
       dbSelectArea('SB1')                 
       SB1->(dbGoTo(QRY_EMAIL->ZB1_RECNO))
       cRegistro  := SB1->B1_COD
       cDados     := SB1->B1_DESC
ENDCASE                                                    


cHtml     :=  '' 	
cHtml     += "<h2><span style='color: #0000ff;'><strong>WorkFlow de Cadastro</strong></span></h2> "
cHtml     += "<h3><strong>Solicita&ccedil;&atilde;o ID = "+QRY_EMAIL->ZB1_ID+ ' – '+cTexto+' de '+cTexto2+"</strong></h3>"
IF cTipo == '1' 
     cHtml += "<p>A sua solicitação de "+cTexto+' de '+cTexto2+":</p>"       
ElseIF QRY_EMAIL->ZB1_TIPO == '1' 
     cHtml += "<p>Foi realizada uma "+cTexto+" de "+cTexto2+":</p>"
EndIF
cHtml += "                                                                     "
cHtml += "<p><strong>"+Alltrim(cRegistro)+" - "+AllTrim(cDados)+"</strong>"
IF cTipo  == '1'
	cHtml += "  foi <span style='color: #ff0000;'><strong>"+IIF(QRY_EMAIL->ZB1_STATUS=='1','APROVADA','REJEITADA')+"<br /><br /></strong></span>"
	IF QRY_EMAIL->ZB1_STATUS=='1'
	     cHtml += "O cadastro já está disponível no sistema.</p> "  
	Else
	     cHtml += "OBS: "+QRY_EMAIL->ZB1_OBS+"</p> "
	EndIF
Else 
	cHtml += "<p> A solicitação está pendente para sua analise.</p> "
EndIF

oMessage := TMailMessage():New()
oMessage:Clear()
oMessage:cFrom                  := cEmail
oMessage:cTo                    := cPara
oMessage:cCc                    := ""
IF cTipo == '1'                                                   
    oMessage:cSubject               := "WorkFlow de Cadastro - A sua solicitação de cadastro foi "+;
                                        IIF(QRY_EMAIL->ZB1_STATUS=='1','Aprovada','Rejeitada')
ElseIF cTipo == '2'
    oMessage:cSubject               := "WorkFlow de Cadastro - Existe uma pendencia de cadastro para sua analise"
EndIF
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
Static Function Elimina_Cad()       

Local nDias := getMv("MGF_CAD043")
Local cTab  := ''

cQuery  := " SELECT * "
cQuery  += " FROM "+RetSqlName("ZB1")+" ZB1"
cQuery  += " WHERE D_E_L_E_T_ = ' ' "
cQuery  += "   AND ZB1_TIPO   = '1' "
cQuery  += "   AND ZB1_STATUS = '2'"
cQuery  += "   AND ZB1_DATA   <= '"+DTOS(Date()-nDias)+"'"

If Select("QRY_EXCLUI") > 0                                                           
	QRY_EXCLUI->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_EXCLUI",.T.,.F.)
dbSelectArea("QRY_EXCLUI")
QRY_EXCLUI->(dbGoTop())
While QRY_EXCLUI->(!EOF())
	DO CASE
		CASE QRY_EXCLUI->ZB1_CAD == '1'
			cTab       := 'SA1'
		CASE QRY_EXCLUI->ZB1_CAD == '2'
			cTab       := 'SZ9'
		CASE QRY_EXCLUI->ZB1_CAD == '3'
			cTab       := 'SA2'
		CASE QRY_EXCLUI->ZB1_CAD == '4'
			cTab       := 'SA4'
		CASE QRY_EXCLUI->ZB1_CAD == '5'
			cTab       := 'SA3'
		CASE QRY_EXCLUI->ZB1_CAD == '6'
			cTab       := 'DA3'
		CASE QRY_EXCLUI->ZB1_CAD == '7'
			cTab       := 'DA4'
		CASE QRY_EXCLUI->ZB1_CAD == '8'
			cTab       := 'SB1'
	ENDCASE
	dbSelectArea(cTab)
	&(cTab)->(dbGoTo(QRY_EXCLUI->ZB1_RECNO))
	RecLock(cTab, .F.)
	&(cTab)->(dbDelete())
	&(cTab)->(msUnlock())
	QRY_EXCLUI->(dbSkip())
End

Return