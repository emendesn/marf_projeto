#include 'protheus.ch'
#include 'totvs.ch'
#include 'topconn.ch'

//----------------------------------------------------------
//----------------------------------------------------------
user function MGFFAT66()

	private oDlg		:= nil
	private oSay1		:= nil
	private oSay2		:= nil
	private oGetDtReemb	:= nil
	private dGetDtReemb	:= dDataBase
	private oGetMotivo	:= nil
	private cGetMotivo	:= nil
	private aCoors		:= 	FWGetDialogSize( oMainWnd )
	
	If !Empty(SC5->C5_NOTA)
		MsgAlert("Pedido de Venda possui nota fiscal, não pode haver alteração!")
		Return
	EndIf

	If FindFunction("U_TAS01StatPV")
		lRet := U_TAS01StatPV({SC5->C5_NUM,2})
		MsgAlert(cValToChar(lRet))
	EndIf	

	If lRet
	DEFINE MSDIALOG oDlg TITLE 'Data de Reembarque' FROM  aCoors[1]/2, aCoors[2]/2 TO aCoors[3]/2-100, aCoors[4]/2-150 PIXEL STYLE DS_MODALFRAME

	@ 010, 005 SAY oSay1 PROMPT "Data Reembarque:"					SIZE 045, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 007, 050 MSGET oGetDtReemb VAR dGetDtReemb	PICTURE "@D"	SIZE 040, 010 OF oDlg COLORS 0, 16777215 PIXEL

	@ 025, 005 SAY oSay2 PROMPT "Motivo:"							SIZE 035, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 025, 050 GET oGetMotivo VAR cGetMotivo OF oDlg MULTILINE		SIZE 175, 044 COLORS 0, 16777215 HSCROLL PIXEL

	@ 080, 005 BUTTON oBtnSelec	PROMPT "Confirmar"	SIZE 037, 012 OF oDlg PIXEL ACTION ( nOpcx := 1, grvDtReemb(), oDlg:end() )
	@ 080, 050 BUTTON oBtnSair	PROMPT "Sair"		SIZE 037, 012 OF oDlg PIXEL ACTION ( nOpcx := 0, oDlg:end() )

	ACTIVATE MSDIALOG oDlg CENTER
	
	EndIf
	
return

//----------------------------------------------------------
// Grava a Data e Motivo da Reembarque
//----------------------------------------------------------
Static Function GrvDtReemb()

	Local cDesEmail := GETMV("MGF_FAT66A") // email de quem recebe 
	Local lEnvEmail	:= GETMV("MGF_FAT66B") // logico, .T.
	
	// Email do operador e vendedores:
	If !Empty(SC5->C5_VEND1)
		_cEmailVend := Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND1,"A3_EMAIL")
	EndIf
	
	If !Empty(UsrRetMail(RetCodUsr()))
		_cEmailUsua:= Alltrim(UsrRetMail(RetCodUsr()))
	EndIf
	
	cDesEmail:= Alltrim(cDesEmail)+";"+_cEmailVend+";"+_cEmailUsua
	
	_cHist := "Dt. Reemb De: "+IIF(Empty(SC5->C5_ZDTREEM),Dtoc(SC5->C5_ZDTEMBA),Dtoc(SC5->C5_ZDTREEM))+" Para: "+Dtoc(dGetDtReemb)+" Motivo De.: "+Alltrim(SC5->C5_ZMOTREE)+" Para: "+Alltrim(cGetMotivo)
	// Gravação de Log de Alteração da Data de Reembarque
	RecLock("ZVH",.T.)
	ZVH->ZVH_FILIAL	:= xFilial("ZVH")     
	ZVH->ZVH_NUM	:= SC5->C5_NUM
	ZVH->ZVH_DATA	:= Date()
	ZVH->ZVH_HORA	:= substr(time(),1,2)+substr(time(),4,2)+substr(time(),7,2)
	ZVH->ZVH_USUPRO	:= CUSERNAME
	ZVH->ZVH_USUWIN	:= LogUserName()
	ZVH->ZVH_MICRO	:= ComputerName()
	ZVH->ZVH_HIST	:= "[MGFFAT66] -" + _cHist
	ZVH->(MsUnlock("ZVH"))

	//Grava nova Data de Reembarque
	RecLock("SC5", .F.)
	SC5->C5_ZDTREEM	:= dGetDtReemb
	SC5->C5_ZMOTREE := cGetMotivo
	SC5->(msUnlock())

	//Envia Mensagem da Data de Reembarque para as Pessoas corretas
	If lEnvEmail .And. !Empty(cDesEmail)
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
		cHtml += "<P><font face = 'verdana' size='5'><strong>ALTERAÇÃO DA DATA DE REEMBARQUE</strong></font></p>" +CRLF
		cHtml += CRLF+"<P><font face = 'verdana' size='3'>PEDIDO:"+SC5->C5_NUM+"</font></p>"
		cHtml += "<P><font face = 'verdana' size='3' color='blue'><strong>[MGFFAT66] Alteração de Data Reembarque</strong></font></p>"
		cHtml += CRLF+"<P><font face = 'verdana' size='3' color='blue'><strong>"+_cHist+"</strong></font></p>"
		cHtml += CRLF+"<P><font face = 'verdana' size='3'>Apenas informativo.</font></p>"
		cHtml += "</BODY>"
		cHtml += "</HTML>"

		EnvMail(cDesEmail,cHtml,"",SC5->C5_NUM)

	EndIf

return

//-----------------------------
// Tela de Historico do Pedido
//-----------------------------

User Function FAT0363(cPed)   // Histórico do Pedido

	Local 	oDlg
	Local 	oLbx
	Local 	cTitulo 	:= ""

	Private aItem		:= {}

	cTitulo := "Histórico do Pedido - " + AllTrim(cPed)

	&& Selecao das informacoes a ser apresentado na tela
	runQry( cPed )

	&& Inicia a montagem do dialogo
	oDlg      := MSDialog():New( 089,232,608,1070,cTitulo,,,.F.,,,,,,.T.,,,.T. )
	oDlg:lCentered := .T.

	&& Listbox o Histórico
	oLbx := TCBrowse():New(008,008,405,243,,,,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,.T.,)
	oLbx:AddColumn( TcColumn():New( "Data"	 			,{ || aItem[oLbx:nAt,01] },"@!"	,,,"LEFT" ,035,.f.,.f.,,,,.f.,) )
	oLbx:AddColumn( TcColumn():New( "Hora"	 			,{ || aItem[oLbx:nAt,02] },"@!"	,,,"LEFT" ,030,.f.,.f.,,,,.f.,) )
	oLbx:AddColumn( TcColumn():New( "Usuário Protheus"	,{ || aItem[oLbx:nAt,03] },""	,,,"LEFT" ,050,.f.,.f.,,,,.f.,) )
	oLbx:AddColumn( TcColumn():New( "Usuário Windows"	,{ || aItem[oLbx:nAt,04] },""	,,,"LEFT" ,050,.f.,.f.,,,,.f.,) )
	oLbx:AddColumn( TcColumn():New( "Micro"	 			,{ || aItem[oLbx:nAt,05] },""	,,,"LEFT" ,050,.f.,.f.,,,,.f.,) )
	oLbx:AddColumn( TcColumn():New( "Histórico"	  		,{ || aItem[oLbx:nAt,06] },""	,,,"LEFT" ,150,.f.,.f.,,,,.f.,) )

	oLbx:SetArray( @aItem )

	&& Finaliza a montagem do dialogo
	oDlg:Activate(,,,.T.)

Return


&& Funcao: runQry()
&& Seleciona os Histórico do Pedido
Static Function runQry( cPed )
	Local cQuery	:= ""
	Local cData		:= ""
	Local cHora		:= ""

	cQuery := "SELECT "
	cQuery +=		"* "
	cQuery += "FROM " + RetSqlName("ZVH") + " ZVH "
	cQuery += "WHERE "
	cQuery +=		"ZVH_FILIAL = '" + xFilial("ZVH") + "' AND "
	cQuery +=		"ZVH_NUM = '" + cPed + "' AND "
	cQuery +=		"ZVH.D_E_L_E_T_ = ' ' "
	CQUERY += " ORDER BY ZVH_DATA,ZVH_HORA "

	TcQuery cQuery New Alias "TZVH"

	While TZVH->(!Eof())

		cHora :=Substr(TZVH->ZVH_HORA,1,2)+":"+Substr(TZVH->ZVH_HORA,3,2)+":"+Substr(TZVH->ZVH_HORA,5,2)
		If Empty(TZVH->ZVH_HORA)
			cHora := ""
		Endif
		If !Empty(TZVH->ZVH_DATA)
			cData := Stod(TZVH->ZVH_DATA)
		Else
			cData := ""
		Endif	
		
		DbSelectArea("ZVH")
		DbSetOrder(0)
		DbGoto(TZVH->R_E_C_N_O_)
		aAdd ( aItem, {	cData  				,;	
		cHora								,;	
		ZVH->ZVH_USUPRO						,;	
		ZVH->ZVH_USUWIN						,;	
		ZVH->ZVH_MICRO						,;	
		ZVH->ZVH_HIST						})
		
		dbSelectArea("TZVH")
		TZVH->(DbSkip())

	EndDo

	TZVH->(DbCloseArea())

Return

/*
========================================================
Função que Envia E-mail do erro (EnvMail())
========================================================
*/
Static Function EnvMail(cPara,cHtml,cAnexo,cPedido)

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
	oMessage:cSubject               := "Aviso de Alteração de Data de Reentrega Pedido"+Alltrim(cPedido)
	oMessage:cBody                  := cHtml
	oMessage:AttachFile( cAnexo )

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

