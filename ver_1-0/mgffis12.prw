#include 'protheus.ch'

/*
=====================================================================================
Programa.:              MGFFIS12
Autor....:              Gustavo Ananias Afonso
Data.....:              11/11/2016
Descricao / Objetivo:   
Doc. Origem:            GAP FIS040
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Cria Log das alterações feitas nas NFs
=====================================================================================
*/
user function MGFFIS12(cTbl, cSeek, nRecno, cTblAlter, nRecnoAlte, cField, cOld, cNew, dDate, cHour, cUser)

	Local cNotaSerie := Subs(cSeek,1,6)+"/"+Subs(cSeek,7,9)+"-"+Subs(cSeek,16,3)

	DBSelectArea("ZZL")

	recLock("ZZL", .T.)
	ZZL->ZZL_FILIAL	:= xFilial("ZZL")
	ZZL->ZZL_NUM	:= GETSXENUM("ZZL","ZZL_NUM")
	ZZL->ZZL_TABLE	:= cTbl
	ZZL->ZZL_SEEK	:= cSeek
	ZZL->ZZL_RECNO	:= nRecno
	ZZL->ZZL_TBLALT	:= cTblAlter
	ZZL->ZZL_RECALT	:= nRecnoAlte
	ZZL->ZZL_FIELD	:= cField
	ZZL->ZZL_OLD	:= cOld
	ZZL->ZZL_NEW	:= cNew
	ZZL->ZZL_DATE	:= dDate
	ZZL->ZZL_HOUR	:= cHour
	ZZL->ZZL_USER	:= cUser
	ZZL->(msUnLock())

	CONFIRMSX8()

	ZZL->(DBCloseArea())

	cHtml := ""
	cHtml += "<HTML>"
	cHtml += "<HEAD>"
	cHtml += "	<META HTTP-EQUIV='CONTENT-TYPE' CONTENT='text/html; charset=utf-8'>"
	cHtml += "	<TITLE></TITLE>"
	cHtml += "	<META NAME='GENERATOR' CONTENT='LibreOffice 4.1.6.2 (Linux)'>"
	cHtml += "	<META NAME='CREATED' CONTENT='0;0'>"
	cHtml += "	<META NAME='CHANGED' CONTENT='0;0'>"
	cHtml += "	<STYLE TYPE='text/html'>"
	cHtml += "	<!--"
	cHtml += "		@page { margin: 0.79in }"
	cHtml += "		P { margin-bottom: 0.08in }"
	cHtml += "		PRE.ctl { font-family: 'arial black', 'avant garde'; font-size: medium; color: #ff0000 }"
	cHtml += "	-->"
	cHtml += "	</STYLE>"
	cHtml += "</HEAD>"
	cHtml += "<BODY LANG='pt-BR' DIR='LTR'>"
	cHtml += "<P><font face = 'verdana' size='4'><strong>ALTERAÇÃO DE NF-E PARA TRANSMISSÃO SEFAZ</strong></font></p>" +CRLF
	cHtml += CRLF+"<P><font face = 'verdana' size='2'>FILIAL/NOTA FISCAL-SÉRIE: </font></p>"
	cHtml += "<P><font face = 'verdana' size='2' color='blue'><strong>"+cNotaSerie+"</strong></font></p>" +CRLF
	cHtml += "<P><font face = 'verdana' size='2'> TABELA ALTERADA: </font></p>"
	cHtml += "<P><font face = 'verdana' size='2' color='blue'><strong>"+cTblAlter+"</strong></font></p>" +CRLF
	cHtml += "<P><font face = 'verdana' size='2'> CAMPO ALTERADO: </font></p>"
	cHtml += "<P><font face = 'verdana' size='2' color='blue'><strong>"+cField+"</strong></font></p>" +CRLF
	cHtml += "<P><font face = 'verdana' size='2'> VALOR ORIGINAL->VALOR ALTERADO: </font></p>"
	cHtml += "<P><font face = 'verdana' size='2' color='blue'><strong>"+cOld+"->"+cNew+"</strong></font></p>" +CRLF
	cHtml += "<P><font face = 'verdana' size='2'> USUÁRIO, DATA E HORA DA ALTERAÇÃO: </font></p>"
	cHtml += "<P><font face = 'verdana' size='2' color='blue'><strong>"+cUser+", "+dtoc(dDate)+" "+cHour+"</strong></font></p>" +CRLF
	cHtml += "</BODY>"
	cHtml += "</HTML>"

	EnvMail()
	return

********************************************************************************
Static Function EnvMail()

	Local oMail, oMessage
	Local nErro		:= 0
	Local lRetMail 	:= .T.
	Local cSmtpSrv  := GETMV("MGF_SMTPSV")
	Local cCtMail   := GETMV("MGF_CTMAIL")
	Local cPwdMail  := GETMV("MGF_PWMAIL")
	Local nMailPort := GETMV("MGF_PTMAIL")
	Local nParSmtpP := GETMV("MGF_PTSMTP")
	Local nSmtpPort
	Local nTimeOut  := GETMV("MGF_TMOUT")
	Local cEmail    := GETMV("MGF_EMAIL")
	Local cErrMail
	Local cPara 	:= GetNewPar("MGF_MAILNF","carlos.amorim@marfrig.com.br")

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
		conout(cErrMail)
		Alert(cErrMail)
		oMail:SMTPDisconnect()
		lRetMail := .F.
		Return (lRetMail)
	Endif

	If 	nParSmtpP != 25
		nErro := oMail:SmtpAuth(cCtMail, cPwdMail)
		If nErro != 0
			cErrMail :=("ERROR:" + oMail:GetErrorString(nErro))
			conout(cErrMail)
			oMail:SMTPDisconnect()
			lRetMail := .F.
			Return (lRetMail)
		Endif
	Endif

	oMessage := TMailMessage():New()
	oMessage:Clear()
	oMessage:cFrom                  := cEmail
	oMessage:cTo                    := cPara
	oMessage:cCc                    := ""
	oMessage:cSubject               := "Aviso de alteração de NF-e"
	oMessage:cBody                  := cHtml
	nErro := oMessage:Send( oMail )

	if nErro != 0
		cErrMail :=("ERROR:" + oMail:GetErrorString(nErro))
		conout(cErrMail)
		Alert(cErrMail)
		oMail:SMTPDisconnect()
		lRetMail := .F.
		Return (lRetMail)
	Endif

	conout('Desconectando do SMTP')
	oMail:SMTPDisconnect()

Return

