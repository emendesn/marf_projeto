#Include "TOTVS.ch"
#Include "Protheus.ch"
#Include "FwMvcDef.ch"
#Include "FwmBrowse.ch"
#Include "TopConn.ch"
#Include "TbiConn.ch"

/*/{Protheus.doc} MGFEEC42
//TODO Descrição auto-gerada.
@author thiago.queiroz
@since 02/10/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function MGFEEC42()

	RPCSetType( 3 )

	If (.F. );CallProc( "RpcSetEnv", "01", "010001",,,,, { } ); Else; RpcSetEnv( "01", "010001",,,,, { } ); endif

	query()

	If (.F. );CallProc( "RpcClearEnv" ); Else; RpcClearEnv( ); endif

return



Static function query()
	Local cAliasZBX := GetNextAlias()
	Local cAliasZBY := GetNextAlias()
	Local aOrcFamil   := {}
	Local aEmails     := {}
	Local nFam        := 0
	Local nUsr        := 0
	Local nI          := 0
	Local cFil		:= ""

	If Select(cAliasZBX)
		(cAliasZBX)->(DbCloseArea())
	EndIf




















	__execSql(cAliasZBX," SELECT SUBSTR(ZZC.ZZC_FILIAL,1,2) ZZC_FILIAL, ZZC.ZZC_ORCAME, ZZC.ZZC_ZFAMIL, ZZC.ZZC_ZTRADE, ZZC.ZZC_PAISET, EEH.EEH_NOME FROM  "+RetSqlName('ZZC')+" ZZC INNER JOIN  "+RetSqlName('EEH')+" EEH ON EEH.D_E_L_E_T_= ' ' AND EEH.EEH_FILIAL =  '" +xFilial('EEH')+"'  AND EEH.EEH_IDIOMA = ZZC.ZZC_IDIOMA AND EEH.EEH_COD = ZZC.ZZC_ZFAMIL WHERE ZZC.D_E_L_E_T_= ' ' AND ZZC.ZZC_FILIAL <> '99' AND ZZC.ZZC_ZDISTR = '1' AND ZZC.ZZC_APROVA = '2' ORDER BY 1,4,2",{},.F.)


	While !(cAliasZBX)->(Eof())


		If cFil <> Substr((cAliasZBX)->ZZC_FILIAL,1,2)

			If Len(aEmails) >0 .and.  Len(aOrcFamil) >0
				EnvAprov(aEmails,aOrcFamil)
			EndIf
			aEmails 	:= {}
			aOrcFamil 	:= {}

			cFil := Substr((cAliasZBX)->ZZC_FILIAL,1,2)











			__execSql(cAliasZBY," SELECT ZBY.ZBY_FILIAL, ZBY.ZBY_APROVA FROM  "+RetSqlName('ZBX')+" ZBX INNER JOIN  "+RetSqlName('ZBY')+" ZBY ON ZBY.D_E_L_E_T_= ' ' AND ZBY.ZBY_FILIAL = ZBX.ZBX_FILIAL AND ZBY.ZBY_NIVEL = ZBX.ZBX_NIVEL WHERE ZBX.D_E_L_E_T_= ' ' AND SUBSTR(ZBX.ZBX_FILIAL,1,2) =  "+___SQLGetValue(CFIL)+" AND ZBX.ZBX_EMAIL = '1'",{},.F.)

			While !(cAliasZBY)->(Eof())
				nUsr := ascan(aEmails,{|x| x == (cAliasZBY)->ZBY_APROVA})
				If    nUsr == 0
					aAdd(aEmails,(cAliasZBY)->ZBY_APROVA)
				EndIf
				(cAliasZBY)->(DbSkip())
			EndDo
			(cAliasZBY)->(DbCloseArea())
		EndIf

		nFam := ascan(aOrcFamil,{|x| x[1] == (cAliasZBX)->ZZC_ZFAMIL})
		If    nFam ==0
			aAdd(aOrcFamil,{(cAliasZBX)->ZZC_ZFAMIL,(cAliasZBX)->EEH_NOME,{{(cAliasZBX)->ZZC_ORCAME,(cAliasZBX)->ZZC_ZTRADE,(cAliasZBX)->ZZC_PAISET}}})
		Else
			aAdd(aOrcFamil[nFam][3],{(cAliasZBX)->ZZC_ORCAME,(cAliasZBX)->ZZC_ZTRADE,(cAliasZBX)->ZZC_PAISET})
		EndIf

		(cAliasZBX)->(DbSkip())
	EndDo

	If Len(aEmails) >0 .and.  Len(aOrcFamil) >0
		EnvAprov(aEmails,aOrcFamil)
	EndIf

Return










Static Function EnvAprov(aEmails,aOrcFamil)
	Local oMail, oMessage
	Local nErro       := 0
	Local lRetMail    := .T.
	Local cSmtpSrv  := GETMV("MGF_SMTPSV")
	Local cCtMail   := GETMV("MGF_CTMAIL")
	Local cPwdMail  := GETMV("MGF_PWMAIL")
	Local nMailPort := GETMV("MGF_PTMAIL")
	Local nParSmtpP := GETMV("MGF_PTSMTP")
	Local nSmtpPort
	Local nTimeOut  := GETMV("MGF_TMOUT")
	Local cEmail    := GETMV("MGF_EMAIL")
	Local cErrMail
	Local cTo		:= ""
	Local cCorpo	:= ""


	If Len(aEmails) > 0 .and.  Len(aOrcFamil) > 0
		cCorpo := "<HTML><BODY><H2>Orçamentos Pendentes "+dtoc(ddatabase)+"</H2><br>" + Chr(13)+Chr(10)
		cCorpo := "<H3>Os seguintes orçamentos estão pendentes de distribuição: </H3>" + Chr(13)+Chr(10)
		For nFam := 1 to Len(aOrcFamil)
			cCorpo += "<H4>Família " + alltrim(aOrcFamil[nFam][1]) + " - " +  Alltrim(aOrcFamil[nFam][2]) + ":</H4>" + Chr(13)+Chr(10)
			cCorpo += "<P>"
			cCorpo += "<UL>"
			For nI := 1 to Len(aOrcFamil[nFam][3])
				cCorpo += "<LI/>" + Alltrim(aOrcFamil[nFam][3][nI][1])
				cCorpo += " - Trader:"+GetAdvFVal("SA3","A3_NOME",xFilial("SA3")+Alltrim(aOrcFamil[nFam][3][nI][2]),1,"")
				cCorpo += " - País Destino:"+GetAdvFVal("SYA","YA_DESCR",xFilial("SYA")+Alltrim(aOrcFamil[nFam][3][nI][3]),1,"")+ Chr(13)+Chr(10)
			next
			cCorpo	+= "</UL>"
			cCorpo	+= "</P>"
		next
		cCorpo += "</BODY></HTML>"
		cTo := Alltrim(UsrRetMail(aEmails[1]))
		For nUsr := 2 To Len(aEmails)
			cTo += ";"+Alltrim(UsrRetMail(aEmails[nUsr]))
		next




	EndIf

	Conout("------------INICIO E-MAIL DISTRIBUICAO------------")
	oMail := TMailManager():New()
	if nParSmtpP == 25
		oMail:SetUseSSL( .F.  )
		oMail:SetUseTLS( .F.  )
		oMail:Init("", cSmtpSrv, "", "",, nParSmtpP)
	elseif nParSmtpP == 465
		nSmtpPort := nParSmtpP
		oMail:SetUseSSL( .T.  )
		oMail:Init("", cSmtpSrv, cCtMail,  cPwdMail,, nSmtpPort)
	else
		nParSmtpP == 587
		nSmtpPort := nParSmtpP
		oMail:SetUseTLS( .T.  )
		oMail:Init("", cSmtpSrv, cCtMail,  cPwdMail,, nSmtpPort)
	endif

	oMail:SetSmtpTimeOut( nTimeOut )
	nErro := oMail:SmtpConnect()
	If nErro <> 0
		cErrMail :=("ERROR:" + oMail:GetErrorString(nErro))
		conout(cErrMail)

		oMail:SMTPDisconnect()
		lRetMail := .F.
	Endif

	If    nParSmtpP <> 25
		nErro := oMail:SmtpAuth(cCtMail, cPwdMail)
		If nErro <> 0
			cErrMail :=("ERROR:" + oMail:GetErrorString(nErro))
			conout(cErrMail)
			oMail:SMTPDisconnect()
			lRetMail := .F.
		Endif
	Endif
	If lRetMail
		oMessage := TMailMessage():New()
		oMessage:Clear()
		oMessage:cFrom                  := cEmail
		oMessage:cTo                    := alltrim(cTo)
		oMessage:cCc                    := ""
		oMessage:cSubject               := "Distribuição de Orçamentos " + DTOC(dDatabase) + " - " + Time()
		oMessage:cBody                           := cCorpo
		nErro := oMessage:Send( oMail )
		if nErro <> 0
			cErrMail :=("ERROR:" + oMail:GetErrorString(nErro))
			conout(cErrMail)
			oMail:SMTPDisconnect()
			lRetMail := .F.
		Endif
		conout("Desconectando do SMTP")
		oMail:SMTPDisconnect()
	EndIf

	Conout("------------FIM E-MAIL DISTRIBUICAO------------")

Return lRetMail
