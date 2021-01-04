#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)

/*/{Protheus.doc} MGFFAT90
//Envia email com XML de notas faturadas
@author Gustavo
@since 01/08/2018
@version 1.0
@type function
/*/

//------------------------------------------------------------------
// jMGFFT90 - Para execucao via JOB
//------------------------------------------------------------------
user function jMGFFT90( cFilJob )
	RPCSetType( 3 )

	PREPARE ENVIRONMENT EMPRESA left( cFilJob, 2 ) FILIAL cFilJob

	conout('[MGFFAT90] Iniciado para a empresa' + cFilJob + ' - ' + dToC(dDataBase) + " - " + time())

	U_MGFFAT90()

	RESET ENVIRONMENT
return

//------------------------------------------------------------------
// Envia email com XML de notas faturadas
//------------------------------------------------------------------
user function MGFFAT90()
	local aArea			:= nil
	local aAreaSF2		:= nil
	local aAreaIni		:= getArea()
	local cQrySF2		:= ""
	local cXMLFile		:= ""
	local aDataSF2		:= {}
	local nI			:= 0
	local nJ			:= 0
	local cDBSped		:= allTrim( superGetMv( "MGF_DBSPED", .F., "ORACLE/SPED" ) )
	local cSrvSped		:= allTrim( superGetMv( "MGF_SRVSPED", .F., "SPDWFAPL180" ) )
	local nPortSped		:= superGetMv( "MGF_PORSPE", .F., 7890 )
	local nConnExt		:= -1
	local cError		:= ""
	local nConnProt		:= advConnection()
	local cQrySped50	:= ""

	local cIdEnt		:= ""
	local lSdoc			:= TamSx3("F2_SERIE")[1] == 14

	local cEmpAntBkp	:= cEmpAnt
	local cFilAntBkp	:= cFilAnt

	private cDestino	:= ""
	private cChvNFe		:= ""
	private cPrefixo	:= ""

	private aCD			:= {}
	private nI			:= 0

	getSM0()

	for nI := 1 to len( aCD )

		if cFilAnt <> aCD[nI, 2]
			PREPARE ENVIRONMENT EMPRESA aCD[nI, 1] FILIAL aCD[nI, 2]
		endif

		aArea			:= getArea()
		aAreaSF2		:= SF2->( getArea() )

		DBSelectArea("SF2")

		conout( "[MGFFAT90] Selecionando dados da filial " + cFilAnt )

		cQrySF2 := "SELECT R_E_C_N_O_ F2RECNO, F2_CHVNFE, F2_SERIE, F2_DOC"	+ CRLF
		cQrySF2 += " FROM " + retSQLName("SF2") + " SF2"					+ CRLF
		cQrySF2 += " WHERE"													+ CRLF
		cQrySF2 += " 		SF2.F2_XEXPXML	=	'P'"						+ CRLF // F2_XEXPXML -> P Pendente / E Exportado
		cQrySF2 += " 	AND	SF2.F2_CHVNFE	<>	' '"						+ CRLF
		cQrySF2 += " 	AND	SF2.F2_FILIAL	=	'" + xFilial("SF2")+ "'"	+ CRLF
		cQrySF2 += " 	AND	SF2.D_E_L_E_T_	<>	'*'"						+ CRLF

		conout( "[MGFFAT90] " + cQrySF2 )

		tcQuery cQrySF2 New Alias "QRYSF2"

		if !QRYSF2->( EOF() )
			while ( QRYSF2->( !EOF() ) )
				conout("[MGFFAT90] Selecionando Nota: " + QRYSF2->F2_CHVNFE )
	
				cDestino	:= ""
				cChvNFe		:= ""
				cPrefixo	:= ""
				cError		:= ""
	
				cIdEnt := getCfgEntidade(@cError)
	
				XSpedPExp(			;
				cIdEnt				,;
				QRYSF2->F2_SERIE	,;
				QRYSF2->F2_DOC		,;
				QRYSF2->F2_DOC		,;
				"\"					,;
				nil					,;
				cToD('//')			,;
				dDataBase			,;
				"",;
				"",;
				1					,;
				,;
				QRYSF2->F2_SERIE			)

				if file( cDestino+cChvNFe+"-"+cPrefixo+".xml" )
					if envMail( cDestino + cChvNFe + "-" + cPrefixo + ".xml" )
						SF2->( DBGoTo( QRYSF2->F2RECNO ) )
						RecLock( "SF2", .F. )
							SF2->F2_XEXPXML := "E"
						SF2->( msUnlock() )
					endif
				endif

				fErase( cDestino+cChvNFe+"-"+cPrefixo+".xml" )

				QRYSF2->(dbSkip())
			enddo
		else
			conout("Nenhum dado encontrado.")
		endif

		QRYSF2->(DBCloseArea())

		restArea( aAreaSF2 )
		restArea( aArea )

		if cFilAnt <> aCD[nI, 2]
			RESET ENVIRONMENT
		endif

	next nI

	cEmpAnt	:= cEmpAntBkp
	cFilAnt	:= cFilAntBkp

	restArea( aAreaIni )
return

//-------------------------------------------------------------------
// Retorna empresas e filiais
//-------------------------------------------------------------------
static function getSM0()
	local aArea		:= getArea()
	local cNotFil	:= allTrim( superGetMv( "MGF_FAT90A" , , "" ) )
	local cQrySM0	:= "SELECT M0_CODIGO, M0_CODFIL FROM SYS_COMPANY WHERE D_E_L_E_T_ = ' '"

	if !empty( cNotFil )
		cQrySM0 += " AND M0_CODFIL NOT IN (" + cNotFil + ")" 
	endif

	cQrySM0 += " ORDER BY M0_CODIGO, M0_CODFIL"

	conout("[MGFFAT90] [getSM0]" + cQrySM0)

	TcQuery cQrySM0 New Alias "QRYSM0"

	while !QRYSM0->(EOF())
		aadd( aCD, { QRYSM0->M0_CODIGO, QRYSM0->M0_CODFIL } )
		QRYSM0->(DBSkip())
	enddo

	QRYSM0->(DBCloseArea())

	restArea(aArea)
return

//------------------------------------------------------------------------
// Envia email
//------------------------------------------------------------------------
static function envMail( cXMLFile )
	local oMail		:= nil
	local oMessage	:= nil
	local nErro		:= 0
	local lRetMail 	:= .T.
	local cSmtpSrv  := GETMV("MGF_SMTPSV")
	local cCtMail   := GETMV("MGF_CTMAIL")
	local cPwdMail  := GETMV("MGF_PWMAIL")
	local nMailPort := GETMV("MGF_PTMAIL")
	local nParSmtpP := GETMV("MGF_PTSMTP")
	local nSmtpPort
	local nTimeOut  := GETMV("MGF_TMOUT")
	local cEmail    := GETMV("MGF_EMAIL")
	local cErrMail
	local cDestXML	:= allTrim( superGetMv( "MGF_DESXML", .F., "" ) )

	oMail := TMailManager():New()

	if nParSmtpP == 25
		oMail:SetUseSSL( .F. )
		oMail:SetUseTLS( .F. )
		oMail:Init("", cSmtpSrv, "", "",, nParSmtpP)
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
	oMessage:clear()
	oMessage:cFrom                  := cEmail
	oMessage:cTo                    := cDestXML
	oMessage:cCc                    := ""
	oMessage:cSubject               := "Envio de XML"
	oMessage:cBody                  := "XML anexo"
	oMessage:attachFile( cXMLFile )

	nErro := oMessage:Send( oMail )

	if nErro != 0
		cErrMail :=("ERROR:" + oMail:GetErrorString(nErro))
		conout(cErrMail)
		lRetMail := .F.
	endif

	conout('Desconectando do SMTP')
	oMail:SMTPDisconnect()

return lRetMail

//---------------------------------------------------------
// Atualiza o campo F2_XEXPXML na geracao da nota
//---------------------------------------------------------
user function MGFFAT91()
	recLock( "SF2", .F. )
	SF2->F2_XEXPXML := "P"
	SF2->( msUnlock() )
return

Static Function XSpedPExp(cIdEnt,cSerie,cNotaIni,cNotaFim,cDirDest,lEnd,dDataDe,dDataAte,cCnpjDIni,cCnpjDFim,nTipo,lCTe,cSerMax)
	Local aDeleta  := {}

	Local cAlias	:= GetNextAlias()
	Local cAnoInut  := ""
	Local cAnoInut1 := ""
	Local cCanc		:= ""
	Local cChvIni  	:= ""
	Local cChvFin	:= ""
	Local cCNPJDEST := Space(14)
	Local cCondicao	:= ""
	Local cDrive   	:= ""
	Local cIdflush  := cSerie+cNotaIni
	Local cModelo  	:= ""
	Local cNFes     := ""
	Local cURLFDIC	:= GetNewPar("MGF_FINBAU"," ") //Url do Totvs TSS / SPED para geraçao do XML para o FDIC
	Local cURL     	:= PadR(GetNewPar("MV_SPEDURL","http://"),250)
	Local cXmlInut  := ""
	Local cXml		:= ""
	Local cWhere	:= ""
	Local cXmlProt	:= ""
	local cAviso    := ""
	local cErro     := ""
	local cTab		:= ""
	local cCmpNum	:= ""
	local cCmpSer	:= ""
	local cCmpTipo  := ""
	local cCmpLoja  := ""
	local cCmpCliFor	:= ""
	local cCnpj	  		:= ""
	Local cEventoCTe	:= ""
	Local cRetEvento	:= ""
	Local cRodapCTe  	:=""
	local cCabCTe    	:=""
	Local cIdEven	   	:= ""
	local cVerMDfe		:= ""
	local cNumMdfe		:= ""

	Local lOk      	:= .F.
	Local lFlush  	:= .T.
	Local lFinal   	:= .F.
	Local lClearFilter	:= .F.
	Local lExporta 	:= .F.
	Local lUsaColab	:= .F.
	Local lSdoc     := TamSx3("F2_SERIE")[1] == 14

	Local nHandle  	:= 0
	Local nX        := 0
	Local nY		:= 0
	local nZ		:= 0

	Local aInfXml	:= {}

	Local oRetorno
	Local oWS
	Local oXML

	Local lOkCanc		:= .f.

	Default nTipo		:= 1
	Default cNotaIni	:= ""
	Default cNotaFim	:= ""
	Default dDataDe		:= CtoD("01/01/2001")
	Default dDataAte	:= CtoD("  /  /  ")
	Default lCTe		:= IIf (FunName()$"SPEDCTE,TMSA200,TMSAE70,TMSA500,TMSA050",.T.,.F.)
	Default cSerMax 	:= cSerie
	Default cCnpjDIni 	:= '00000000000000'
	Default cCnpjDFim 	:= '99999999999999'

	lUsaColab := UsaColaboracao( IIF(lCte,"2","1") )

	If nTipo == 3
		If !Empty( GetNewPar("MV_NFCEURL","") )
			cURL := PadR(GetNewPar("MV_NFCEURL","http://"),250)
		Endif
	ElseIf !EMPTY(cURLFDIC)
		cURL := cURLFDIC
	Endif

	// Altera o conteúdo da variavel quando for carta de correção para o CTE
	If IntTMS() .and. lCTe
		cTipoNfe := "SAIDA"
	EndIf
	ProcRegua(Val(cNotaFim)-Val(cNotaIni))

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Corrigi diretorio de destino                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SplitPath(cDirDest,@cDrive,@cDestino,"","")
	cDestino := cDrive+cDestino
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicia processamento                                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While lFlush

		If ( nTipo == 1 .And. !lUsaColab ).Or. nTipo == 3 .Or. nTipo == 4
			oWS:= WSNFeSBRA():New()
			oWS:cUSERTOKEN        := "TOTVS"
			oWS:cID_ENT           := cIdEnt
			oWS:_URL              := AllTrim(cURL)+"/NFeSBRA.apw"
			oWS:cIdInicial        := IIf(nTipo==4,'58'+cIdflush,cIdflush) // cNotaIni
			oWS:cIdFinal          := IIf(nTipo==4,'58'+cSerMax+cNotaFim,cSerMax+cNotaFim)
			oWS:dDataDe           := dDataDe
			oWS:dDataAte          := dDataAte
			oWS:cCNPJDESTInicial  := cCnpjDIni
			oWS:cCNPJDESTFinal    := cCnpjDFim
			oWS:nDiasparaExclusao := 0
			lOk:= oWS:RETORNAFX()
			oRetorno := oWS:oWsRetornaFxResult
			lOk := iif( valtype(lOk) == "U", .F., lOk )

			If lOk
				ProcRegua(Len(oRetorno:OWSNOTAS:OWSNFES3))
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Exporta as notas                                                       ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

				For nX := 1 To Len(oRetorno:OWSNOTAS:OWSNFES3)

					//Ponto de Entrada para permitir filtrar as NF
					If ExistBlock("SPDNFE01")
						If !ExecBlock("SPDNFE01",.f.,.f.,{oRetorno:OWSNOTAS:OWSNFES3[nX]})
							loop
						Endif
					Endif

					oXml    := oRetorno:OWSNOTAS:OWSNFES3[nX]
					oXmlExp := XmlParser(oRetorno:OWSNOTAS:OWSNFES3[nX]:OWSNFE:CXML,"","","")
					cXML	:= ""
	
					If Type("oXmlExp:_NFE:_INFNFE:_DEST:_CNPJ")<>"U"
						cCNPJDEST := AllTrim(oXmlExp:_NFE:_INFNFE:_DEST:_CNPJ:TEXT)
					ElseIF Type("oXmlExp:_NFE:_INFNFE:_DEST:_CPF")<>"U"
						cCNPJDEST := AllTrim(oXmlExp:_NFE:_INFNFE:_DEST:_CPF:TEXT)
					Else
						cCNPJDEST := ""
					EndIf
	
					cVerNfe := IIf(Type("oXmlExp:_NFE:_INFNFE:_VERSAO:TEXT") <> "U", oXmlExp:_NFE:_INFNFE:_VERSAO:TEXT, '')
					cVerCte := Iif(Type("oXmlExp:_CTE:_INFCTE:_VERSAO:TEXT") <> "U", oXmlExp:_CTE:_INFCTE:_VERSAO:TEXT, '')
					cVerMDfe:= Iif(Type("oXmlExp:_MDFE:_INFMDFE:_VERSAO:TEXT") <> "U", oXmlExp:_MDFE:_INFMDFE:_VERSAO:TEXT, '')

					If !Empty(oXml:oWSNFe:cProtocolo)
						cNotaIni := oXml:cID
						cIdflush := cNotaIni
						cNFes := cNFes+cNotaIni+CRLF
						cChvNFe  := NfeIdSPED(oXml:oWSNFe:cXML,"Id")
						cModelo := cChvNFe
						cModelo := StrTran(cModelo,"NFe","")
						cModelo := StrTran(cModelo,"CTe","")
						cModelo := StrTran(cModelo,"MDFe","")
						cModelo := SubStr(cModelo,21,02)

						Do Case
							Case cModelo == "57"
								 cPrefixo := "CTe"
							Case cModelo == "65"
								 cPrefixo := "NFCe"
							Case cModelo == "58"
								 cPrefixo := "MDFe"
							OtherWise
								if '<cStat>301</cStat>' $ oXml:oWSNFe:cxmlPROT .or. '<cStat>302</cStat>' $ oXml:oWSNFe:cxmlPROT
									cPrefixo := "den"
								else
									cPrefixo := "NFe"
								endif
						EndCase

						cChvNFe	:= iif( cModelo == "58", SubStr(cChvNFe,5,44), SubStr(cChvNFe,4,44) )
						//--------------------------------------------------
						// Exporta MDFe - (Autorizada)
						//--------------------------------------------------
						if ( (cModelo=="58") .and. alltrim(FunName()) == 'SPEDMDFE' )
							nHandle	:= 0
							nHandle := FCreate(cDestino+cChvNFe+"-"+cPrefixo+".xml")
							if nHandle > 0
								cCab1 := '<?xml version="1.0" encoding="UTF-8"?>'
								cCab1 	+= '<mdfeProc xmlns="http://www.portalfiscal.inf.br/mdfe" versao="'+cVerMDfe+'">'
								cRodap	:= '</mdfeProc>
								FWrite(nHandle,AllTrim(cCab1))
								FWrite(nHandle,AllTrim(oXml:oWSNFe:cXML))
								FWrite(nHandle,AllTrim(oXml:oWSNFe:cXMLPROT))
								FWrite(nHandle,AllTrim(cRodap))
								FClose(nHandle)
								aadd(aDeleta,oXml:cID)
								cNumMdfe += cIdflush+CRLF
							endif
							//--------------------------------------------------
							// Exporta Legado
							//--------------------------------------------------
						elseif alltrim(FunName()) <> 'SPEDMDFE'

							nHandle := FCreate(cDestino+cChvNFe+"-"+cPrefixo+".xml")
							If nHandle > 0
								cCab1 := '<?xml version="1.0" encoding="UTF-8"?>'
								If cModelo == "57"
									cCab1  += '<cteProc xmlns="http://www.portalfiscal.inf.br/cte" versao="'+cVerCte+'">'
									cRodap := '</cteProc>'
								Else
									Do Case
										Case cVerNfe <= "1.07"
										cCab1 += '<nfeProc xmlns="http://www.portalfiscal.inf.br/nfe" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.portalfiscal.inf.br/nfe procNFe_v1.00.xsd" versao="1.00">'
										Case cVerNfe >= "2.00" .And. "cancNFe" $ oXml:oWSNFe:cXML
										cCab1 += '<procCancNFe xmlns="http://www.portalfiscal.inf.br/nfe" versao="' + cVerNfe + '">'
										OtherWise
										cCab1 += '<nfeProc xmlns="http://www.portalfiscal.inf.br/nfe" versao="' + cVerNfe + '">'
									EndCase
									cRodap := '</nfeProc>'
								EndIf
								FWrite(nHandle,AllTrim(cCab1))
								FWrite(nHandle,AllTrim(oXml:oWSNFe:cXML))
								FWrite(nHandle,AllTrim(oXml:oWSNFe:cXMLPROT))
								FWrite(nHandle,AllTrim(cRodap))
								FClose(nHandle)
								aadd(aDeleta,oXml:cID)

								cXML := AllTrim(cCab1)
								cXML += AllTrim(oXml:oWSNFe:cXML)
								cXML += AllTrim(oXml:oWSNFe:cXMLPROT)
								cXML += AllTrim(cRodap)
								If !Empty(cXML)
									If ExistBlock("FISEXPNFE")
										ExecBlock("FISEXPNFE",.f.,.f.,{cXML})
									Endif
								EndIF
							EndIf
						endif
					EndIf

					//----------------------------------------
					// Exporta MDF-e (Eventos)
					//----------------------------------------
					if (alltrim(FunName()) == 'SPEDMDFE')
						if ( (cModelo=="58") .and. (!empty(cChvNFe)) )
							//----------------------------------------
							// Executa o metodo NfeRetornaEvento()
							//----------------------------------------
							oWS:= WSNFeSBRA():New()
							oWS:cUSERTOKEN	:= "TOTVS"
							oWS:cID_ENT		:= cIdEnt
							oWS:_URL		:= AllTrim(cURL)+"/NFeSBRA.apw"
							oWS:cEvenChvNFE	:= cChvNFe
							lOk				:= oWS:NFERETORNAEVENTO()

							if lOk
								if valType(oWS:oWsNfeRetornaEventoResult:oWsNfeRetornaEvento) <> "U"
									aDados := oWS:oWsNfeRetornaEventoResult:oWsNfeRetornaEvento

									for nZ := 1 to len( aDados )
										//Zerando variaveis
										nHandle := 0
										nHandle := FCreate(cDestino + cChvNFe + "-" + cPrefixo + "_evento_" + alltrim(str(nZ)) + ".xml")
										if nHandle > 0
											cCab1 	:= '<?xml version="1.0" encoding="UTF-8"?>'
											cCab1 	+= '<mdfeProc xmlns="http://www.portalfiscal.inf.br/mdfe" versao="'+cVerMDfe+'">'
											cRodap	:= '</mdfeProc>
											fWrite(nHandle,allTrim(cCab1))
											fWrite(nHandle,allTrim(aDados[nZ]:cXML_RET))
											fWrite(nHandle,allTrim(aDados[nZ]:cXML_SIG))
											fWrite(nHandle,allTrim(cRodap))
											fClose(nHandle)
											aAdd(aDeleta,oXml:cID)
										endif
									next nZ
								endif
							endif
						endif
					else
						If ( oXml:OWSNFECANCELADA <> Nil .And. !Empty(oXml:oWSNFeCancelada:cProtocolo) )
							cChave 	  := oXml:OWSNFECANCELADA:CXML
							
							If cModelo == "57" .and. cVerCte >='2.00'
								cChaveCc1 := At("<chCTe>",cChave)+7
							else
								cChaveCc1 := At("<chNFe>",cChave)+7
							endif

							cChaveCan := SubStr(cChave,cChaveCc1,44)

							oWS:= WSNFeSBRA():New()
							oWS:cUSERTOKEN	:= "TOTVS"
							oWS:cID_ENT		:= cIdEnt
							oWS:_URL		:= AllTrim(cURL)+"/NFeSBRA.apw"
							oWS:cID_EVENTO	:= "110111"
							oWS:cChvInicial	:= cChaveCan
							oWS:cChvFinal	:= cChaveCan
							lOkCanc			:= oWS:NFEEXPORTAEVENTO()
							oRetEvCanc 	:= oWS:oWSNFEEXPORTAEVENTORESULT

							if lOkCanc
								cChvNFe  := NfeIdSPED(oXml:oWSNFeCancelada:cXML,"Id")
								cNotaIni := oXml:cID
								cIdflush := cNotaIni
								cNFes := cNFes+cNotaIni+CRLF
								If !"INUT"$oXml:oWSNFeCancelada:cXML
									nHandle := FCreate(cDestino+SubStr(cChvNFe,3,44)+"-ped-can.xml")
									If nHandle > 0
										cCanc := oXml:oWSNFeCancelada:cXML
										If cModelo == "57"
											oXml:oWSNFeCancelada:cXML := '<procCancCTe xmlns="http://www.portalfiscal.inf.br/cte" versao="' + cVerCte + '">' + oXml:oWSNFeCancelada:cXML + "</procCancCTe>"
										Else
											oXml:oWSNFeCancelada:cXML := '<procCancNFe xmlns="http://www.portalfiscal.inf.br/nfe" versao="' + cVerNfe + '">' + oXml:oWSNFeCancelada:cXML + "</procCancNFe>"
										EndIf
										FWrite(nHandle,oXml:oWSNFeCancelada:cXML)
										FClose(nHandle)
										aadd(aDeleta,oXml:cID)
									EndIf
									nHandle := FCreate(cDestino+"\"+SubStr(cChvNFe,3,44)+"-can.xml")
									If nHandle > 0
										If cModelo == "57"
											FWrite(nHandle,'<procCancCTe xmlns="http://www.portalfiscal.inf.br/cte" versao="' + cVerCte + '">' + cCanc + oXml:oWSNFeCancelada:cXMLPROT + "</procCancCTe>")
										Else
											FWrite(nHandle,'<procCancNFe xmlns="http://www.portalfiscal.inf.br/nfe" versao="' + cVerNfe + '">' + cCanc + oXml:oWSNFeCancelada:cXMLPROT + "</procCancNFe>")
										EndIF
										FClose(nHandle)
									EndIf
								Else

									cXmlInut  := oXml:OWSNFECANCELADA:CXML
									cAnoInut1 := At("<ano>",cXmlInut)+5
									cAnoInut  := SubStr(cXmlInut,cAnoInut1,2)
									cXmlProt  := EncodeUtf8(oXml:oWSNFeCancelada:cXMLPROT)
									nHandle := FCreate(cDestino+SubStr(cChvNFe,3,2)+cAnoInut+SubStr(cChvNFe,5,39)+"-ped-inu.xml")
									If nHandle > 0
										FWrite(nHandle,oXml:OWSNFECANCELADA:CXML)
										FClose(nHandle)
										aadd(aDeleta,oXml:cID)
									EndIf
									nHandle := FCreate(cDestino+"\"+cAnoInut+SubStr(cChvNFe,5,39)+"-inu.xml")
									If nHandle > 0
										FWrite(nHandle,cXmlProt)
										FClose(nHandle)
									EndIf
								EndIf
							EndIf
						EndIf
					endif
					IncProc()
				Next nX

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Exclui as notas                                                        ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If !Empty(aDeleta) .And. GetNewPar("MV_SPEDEXP",0)<>0
					oWS:= WSNFeSBRA():New()
					oWS:cUSERTOKEN        := "TOTVS"
					oWS:cID_ENT           := cIdEnt
					oWS:nDIASPARAEXCLUSAO := GetNewPar("MV_SPEDEXP",0)
					oWS:_URL              := AllTrim(cURL)+"/NFeSBRA.apw"
					oWS:oWSNFEID          := NFESBRA_NFES2():New()
					oWS:oWSNFEID:oWSNotas := NFESBRA_ARRAYOFNFESID2():New()
					For nX := 1 To Len(aDeleta)
						aadd(oWS:oWSNFEID:oWSNotas:oWSNFESID2,NFESBRA_NFESID2():New())
						Atail(oWS:oWSNFEID:oWSNotas:oWSNFESID2):cID := aDeleta[nX]
					Next nX
					If !oWS:RETORNANOTAS()
						conout("MGFFAT90 " + IIf( Empty(GetWscError(3)), GetWscError(1), GetWscError(3) ) )
						lFlush := .F.
					EndIf
				EndIf
				aDeleta  := {}
				If ( Len(oRetorno:OWSNOTAS:OWSNFES3) == 0 .And. Empty(cNfes) )
					conout("MGFFAT90 Não há dados")

					SF2->( DBGoTo( (QRYSF2)->F2RECNO ) )
					recLock( "SF2", .F. )
						SF2->F2_XEXPXML := "N"
					SF2->( msUnlock() )

					lFlush := .F.
				EndIf
			Else
				conout("MGFFAT90 " + IIf( Empty(GetWscError(3)), GetWscError(1), GetWscError(3) ) )
				lFinal := .T.
			EndIf

			If lSdoc
				cIdflush := AllTrim(Substr(cIdflush,1,14) + Soma1(AllTrim(substr(cIdflush,15))))
			Else
				cIdflush :=  AllTrim(Substr(cIdflush,1,3) + Soma1(AllTrim(substr(cIdflush,4))))
			EndIf
			If lOk
				If cIdflush <= AllTrim(cNotaIni) .Or. Len(oRetorno:OWSNOTAS:OWSNFES3) == 0 .Or. Empty(cNfes) .Or. ;
				cIdflush <= If(lSdoc,Substr(cNotaIni,1,14)+Replicate('0',Len(AllTrim(mv_par02))-Len(Substr(Rtrim(cNotaIni),15)))+Substr(Rtrim(cNotaIni),15),;
				Substr(cNotaIni,1,3)+Replicate('0',Len(AllTrim(mv_par02))-Len(Substr(Rtrim(cNotaIni),4)))+Substr(Rtrim(cNotaIni),4))// Importou o range completo
					lFlush := .F.
					If !Empty(cNfes)
						conout("MGFFAT90 Solicitação processada com sucesso.")
					else
						conout("MGFFAT90 Não há dados")

						SF2->( DBGoTo( (QRYSF2)->F2RECNO ) )
						recLock( "SF2", .F. )
							SF2->F2_XEXPXML := "N"
						SF2->( msUnlock() )
					EndIf
				EndIf
			Else
				lFlush := .F.
			Endif
			oXmlExp := Nil
			delclassintf()
		endif
	enddo
return

User function xMF3GXML( cFilJob,aDadMV )

	Local cQryDad := ""
	Local cError  := ""
	Local aNotas  := {}

	private cDestino	:= ""
	private cChvNFe		:= ""
	private cPrefixo	:= ""

	conout('[MGFFATA3] Iniciado para a empresa' + cFilJob + ' - ' + dToC(dDataBase) + " - " + time())

	cQryDad := xQryDad(aDadMV[9],aDadMV[10],cFilJob,aDadMV[3],aDadMV[4],aDadMV[5],aDadMV[6],aDadMV[7],aDadMV[8],aDadMV[12],aDadMV[13])

	cIdEnt := getCfgEntidade(@cError)
	While (cQryDad)->(!EOF())
		XSpedPExp(	;
				cIdEnt				,;
				(cQryDad)->SERIE	,;
				(cQryDad)->DOC		,;
				(cQryDad)->DOC		,;
				"\"					,;
				nil					,;
				cToD('//')			,;
				dDataBase			,;
				""					,;
				""					,;
				1					,;
				NIL					,;
				(cQryDad)->SERIE	)

		aaDD(aNotas,{cDestino+cChvNFe+"-"+cPrefixo+".xml",Alltrim(aDadMV[11])+cChvNFe+"-"+cPrefixo+".xml"})

		(cQryDad)->(dbSkip())
	EndDo

	(cQryDad)->(DbCloseArea())

Return aNotas


Static Function xQryDad(cxPar09,cxPar10,cFilDe,cDocDe,cDocAte,cSerDe,cSerAte,cCGCDe,cCGCAte,dEmisDe,dEmisAte)

	Local cNextAlias 	:= GetNextAlias()
	local cIdEnt		:= ""

	If cxPar09 == 1 // 1 = Entrada, 2= Saida
		If cxPar10 == 1 // 1 = Fornecedor, 2 = Cliete
			BeginSql Alias cNextAlias

				SELECT F1_SERIE SERIE, F1_DOC DOC
				FROM %Table:SF1% F1
				INNER JOIN %Table:SA2% A2
					ON A2.A2_COD = F1.F1_FORNECE
					AND A2.A2_LOJA = F1.F1_LOJA
				WHERE
						F1.%NotDel%
					AND A2.%NotDel%
					AND F1.F1_FILIAL = %Exp:cFilDe%
					AND F1.F1_DOC BETWEEN %Exp:cDocDe% AND %Exp:cDocAte%
					AND F1.F1_SERIE BETWEEN %Exp:cSerDe% AND %Exp:cSerAte%
					AND F1.F1_TIPO NOT IN ('B','D')
					AND F1.F1_EMISSAO BETWEEN %Exp:dTos(dEmisDe)% AND %Exp:dTos(dEmisAte)%
					AND A2.A2_CGC BETWEEN %Exp:cCGCDe% AND %Exp:cCGCAte%
				ORDER BY F1.F1_FILIAL,F1.F1_DOC, F1.F1_SERIE

			EndSql
		Else
			BeginSql Alias cNextAlias

				SELECT F1_SERIE SERIE, F1_DOC DOC
				FROM %Table:SF1% F1
				INNER JOIN %Table:SA1% A1
					ON 	A1.A1_COD = F1.F1_FORNECE
					AND	A1.A1_LOJA = F1.F1_LOJA
				WHERE
						F1.%NotDel%
					AND A1.%NotDel%
					AND F1.F1_FILIAL = %Exp:cFilDe%
					AND F1.F1_DOC BETWEEN %Exp:cDocDe% AND %Exp:cDocAte%
					AND F1.F1_SERIE BETWEEN %Exp:cSerDe% AND %Exp:cSerAte%
					AND F1.F1_TIPO IN ('B','D')
					AND F1.F1_FORMUL = 'S'
					AND F1.F1_EMISSAO BETWEEN %Exp:dTos(dEmisDe)% AND %Exp:dTos(dEmisAte)%
					AND A1.A1_CGC BETWEEN %Exp:cCGCDe% AND %Exp:cCGCAte%
				ORDER BY F1.F1_FILIAL,F1.F1_DOC, F1.F1_SERIE

			EndSql
		EndIf
	Else
		If cxPar10 == 1 // 1 = Fornecedor, 2 = Cliete
			BeginSql Alias cNextAlias

				SELECT F2_SERIE SERIE, F2_DOC DOC
				FROM %Table:SF2% F2
				INNER JOIN %Table:SA2% A2
					ON 	A2.A2_COD = F2.F2_CLIENTE
					AND	A2.A2_LOJA = F2.F2_LOJA
				WHERE
						F2.%NotDel%
					AND A2.%NotDel%
					AND F2.F2_FILIAL = %Exp:cFilDe%
					AND F2.F2_DOC BETWEEN %Exp:cDocDe% AND %Exp:cDocAte%
					AND F2.F2_SERIE BETWEEN %Exp:cSerDe% AND %Exp:cSerAte%
					AND F2.F2_TIPO IN ('B','D')
					AND F2.F2_EMISSAO BETWEEN %Exp:dTos(dEmisDe)% AND %Exp:dTos(dEmisAte)%
					AND A2.A1_CGC BETWEEN %Exp:cCGCDe% AND %Exp:cCGCAte%
				ORDER BY F2.F2_FILIAL,F2.F2_DOC, F2.F2_SERIE

			EndSql
		Else
			BeginSql Alias cNextAlias

				SELECT F2_SERIE SERIE, F2_DOC DOC
				FROM %Table:SF2% F2
				INNER JOIN %Table:SA1% A1
					ON 	A1.A1_COD = F2.F2_CLIENTE
					AND	A1.A1_LOJA = F2.F2_LOJA
				WHERE
						F2.%NotDel%
					AND A1.%NotDel%
					AND F2.F2_FILIAL = %Exp:cFilDe%
					AND F2.F2_DOC BETWEEN %Exp:cDocDe% AND %Exp:cDocAte%
					AND F2.F2_SERIE BETWEEN %Exp:cSerDe% AND %Exp:cSerAte%
					AND F2.F2_TIPO NOT IN ('B','D')
					AND F2.F2_EMISSAO BETWEEN %Exp:dTos(dEmisDe)% AND %Exp:dTos(dEmisAte)%
					AND A1.A1_CGC BETWEEN %Exp:cCGCDe% AND %Exp:cCGCAte%
				ORDER BY F2.F2_FILIAL,F2.F2_DOC, F2.F2_SERIE

			EndSql
		EndIf
	EndIf

	(cNextAlias)->(dbGoTop())

return cNextAlias

User Function xMFT90Gr(nRECSE1,cNumRem,cLocal,cCodBco)

	Local aArea		:= GetArea()
	Local aAreaSM0  := SM0->(GetArea())

	Local cError  := ""
	Local aNotas  := {}

	Local cxFilAnt := cFilAnt
	Local cNomClt  := If(AllTrim(cCodBco) == "341","631_","")

	Private cDestino	:= ""
	Private cChvNFe		:= ""
	Private cPrefixo	:= ""
	Private QRYSF2      := xQry2Dad(nRECSE1)

	If U_zMakeDir( Alltrim(cLocal) + "\" + Alltrim(cNumRem) + "\" , "XMLs" )

		SM0->(dbSetOrder(1))

		While (QRYSF2)->(!EOF())

			cFilant := (QRYSF2)->F2_FILIAL
			SM0->(dbSeek(cEmpAnt+cFilant))

			cIdEnt := getCfgEntidade(@cError)

			XSpedPExp(	;
					cIdEnt				,;
					(QRYSF2)->F2_SERIE	,;
					(QRYSF2)->F2_DOC	,;
					(QRYSF2)->F2_DOC	,;
					"\"					,;
					nil					,;
					cToD('01/01/2001')	,;
					dDataBase			,;
					"00000000000000"	,;
					"99999999999999"	,;
					1					,;
					NIL					,;
					(QRYSF2)->F2_SERIE	)

			__COPYFILE( cDestino + cChvNFe + "-" + cPrefixo + ".xml",;
			            Alltrim(cLocal) + "\" + Alltrim(cNumRem) + "\" + cNomClt + cChvNFe + ;
						"-" + cPrefixo + ".xml" )

			fErase( cDestino + cChvNFe + "-" + cPrefixo + ".xml" )

			(QRYSF2)->(dbSkip())
		EndDo
	EndIf

	(QRYSF2)->(DbCloseArea())

	cFilAnt := cxFilAnt
	RestArea(aAreaSM0)
	RestArea(aArea)

return

Static Function xQry2Dad(nRECSE1)

	Local cNextAlias 	:= GetNextAlias()

	BeginSql Alias cNextAlias
		SELECT
			F2.R_E_C_N_O_ AS F2RECNO,
			F2_FILIAL,
			F2_SERIE,
			F2_DOC,F2_SERIE
		FROM %Table:SE1% E1
		INNER JOIN %Table:SF2% F2
			ON F2.F2_FILIAL = E1.E1_FILIAL
			AND F2.F2_DOC = E1.E1_NUM
			AND F2.F2_SERIE = E1.E1_PREFIXO
		WHERE
				E1.%NotDel%
			AND F2.%NotDel%
			AND E1.R_E_C_N_O_ = %Exp:nRECSE1%
	EndSql

	(cNextAlias)->(dbGoTop())

return cNextAlias