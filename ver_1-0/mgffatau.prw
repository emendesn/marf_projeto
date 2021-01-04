#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "APWEBEX.CH"
/*
=====================================================================================
Programa.:              MGFGFE39	
Autor....:              Rafael Garcia
Data.....:              15/03/2018
Descricao / Objetivo:   Integracao PROTHEUS x MultiEmbarcador - WS envio caminho xml 
Doc. Origem:            Especificacao de Processos_Emissao_CT-e - EF - 01_v2
Solicitante:            Cliente
Uso......:              
Obs......:              WS Server para Integracao de dados 
=====================================================================================
*/

WSSTRUCT MGFFATAUREQXML

	WSDATA Filial		 AS string
	WSDATA OrdemEmb		 AS string
	WSDATA PV			 AS string


ENDWSSTRUCT


WSSTRUCT MGFFATAURETXML
	WSDATA Caminho	as String
	WSDATA status   AS string
	WSDATA Msg  	AS string

ENDWSSTRUCT


/***************************************************************************
* Definicao do Web Service. Retorno OE multiembarcador.				                       *
***************************************************************************/
WSSERVICE MGFFATAU DESCRIPTION "Integracao Protheus x Multiembarcador - envia caminho XML" NameSpace "http://totvs.com.br/MGFFATAU.apw"

	// Passagem dos parametros de entrada
	WSDATA MGFFAUTREQCXML AS MGFFATAUREQXML
	// Retorno (array)
	WSDATA MGFFATAURETCXML  AS MGFFATAURETXML

	WSMETHOD RetCXML DESCRIPTION "Integracao Protheus x Multiembarcador - Retorno caminho XML"

ENDWSSERVICE

/************************************************************************************
** Metodo RetornoCarga
** Grava dados de retorno de Carga - Protocolo ou MsgErro
************************************************************************************/
WSMETHOD RetCXML WSRECEIVE	MGFFAUTREQCXML WSSEND MGFFATAURETCXML WSSERVICE MGFFATAU

	Local aRetFuncao := {}

	Local lReturn	:= .T.

	aRetFuncao	:= u_MGFFATAU(	{	;
	::MGFFAUTREQCXML:Filial		,;
	::MGFFAUTREQCXML:OrdemEmb	,;	
	::MGFFAUTREQCXML:PV		})	// Passagem de parametros para rotina


	// Cria e alimenta uma nova instancia de retorno do cliente
	::MGFFATAURETCXML :=  WSClassNew( "MGFFATAURETXML" )
	::MGFFATAURETCXML:status		:= aRetFuncao[1]
	::MGFFATAURETCXML:Msg			:= aRetFuncao[2]
	::MGFFATAURETCXML:Caminho		:= aRetFuncao[3]


Return lReturn


User Function MGFFATAU(aEmb)
	local aArea:= GetArea()
	local cNota:=""
	local cSerie:=""
	Local cGetIdEntErr  := ""
	local cIdentif:=""
	local aRet:={}
	local cLocal:= Getmv("MGF_FATAU")
	private cDestino	:= ""
	private cChvNFe		:= ""
	private cPrefixo	:= ""
	private cCaminho	:= ""

	RpcSetEnv("01",aEmb[01],,,"FAT",,/*{"SF2"}*/,,,.T.)
	cIdentif := AllTrim(GetIdEntx(cGetIdEntErr,aEmb))
	conout(cIdentif)
	XQSF2(aEmb)
	if !QSF2->(EOF()) 


		cNota:=QSF2->F2_DOC
		cSerie:= QSF2->F2_SERIE

		XSpedPExp(			;
		cIdentif			,;
		cSerie				,;
		cNota				,;
		cNota				,;
		cLocal				,;
		nil					,;
		cToD('//')			,;
		dDataBase			,;
		"",;
		"99999999999999",;
		1					,;
		,;
		cSerie			)

		if file( cDestino+cChvNFe+"-"+cPrefixo+".xml" )
			cCaminho:=GETMV("MGF_FATAU2")+cDestino + cChvNFe + "-" + cPrefixo + ".xml"
			aRet:={"1","Xml Localizado",cCaminho}
			SF2->( DBGoTo( QSF2->R_E_C_N_O_ ) )
			recLock( "SF2", .F. )
			SF2->F2_XOPEXML  := "I"
			SF2->F2_XENVMEM  := "P"
			SF2->( msUnlock() )
		ELSE 
			aRet:={"2","Xml nao Localizado2",cCaminho}
			SF2->( DBGoTo( QSF2->R_E_C_N_O_ ) )
			recLock( "SF2", .F. )
			SF2->F2_XOPEXML  := "I"
			SF2->F2_XENVMEM  := "E"
			SF2->( msUnlock() )
		endif

		QSF2->(DBSKIP())	
	ELSE 
		aRet:={"2","Xml nao Localizado1",cCaminho}
	endif

	IF SELECT("QSF2") > 0
		QSF2->( dbCloseArea() )
	ENDIF  
	RestArea(aArea) 
Return aRet

Static Function GetIdEntx( cError,aEmb ) 
	Local aArea := GetArea() 
	Local cIdEnt := "" 
	Local cURL := PadR(GetNewPar("MV_SPEDURL","http://"),250) 
	Local lMethodOk := .F. 
	Local oWsSPEDAdm 
	QFIL(aEmb[1])

	BEGIN SEQUENCE 
		IF !( CTIsReady(cURL) ) 
			BREAK 
		EndIF 
		cURL := AllTrim(cURL)+"/SPEDADM.apw" 
		IF !( CTIsReady(cURL) ) 
			BREAK 
		EndIF 
		oWsSPEDAdm := WsSPEDAdm():New() 
		oWsSPEDAdm:cUSERTOKEN := "TOTVS" 
		oWsSPEDAdm:oWsEmpresa:cCNPJ := cSM0->( IF(M0_TPINSC==2 .Or. Empty(M0_TPINSC),M0_CGC,"") ) 
		oWsSPEDAdm:oWsEmpresa:cCPF := cSM0->( IF(M0_TPINSC==3,M0_CGC,"") ) 
		oWsSPEDAdm:oWsEmpresa:cIE := cSM0->M0_INSC 
		oWsSPEDAdm:oWsEmpresa:cIM := cSM0->M0_INSCM 
		oWsSPEDAdm:oWsEmpresa:cNOME := cSM0->M0_NOMECOM 
		oWsSPEDAdm:oWsEmpresa:cFANTASIA := cSM0->M0_NOME 
		oWsSPEDAdm:oWsEmpresa:cENDERECO := FisGetEnd(cSM0->M0_ENDENT)[1] 
		oWsSPEDAdm:oWsEmpresa:cNUM := FisGetEnd(cSM0->M0_ENDENT)[3] 
		oWsSPEDAdm:oWsEmpresa:cCOMPL := FisGetEnd(cSM0->M0_ENDENT)[4] 
		oWsSPEDAdm:oWsEmpresa:cUF := cSM0->M0_ESTENT 
		oWsSPEDAdm:oWsEmpresa:cCEP := cSM0->M0_CEPENT 
		oWsSPEDAdm:oWsEmpresa:cCOD_MUN := cSM0->M0_CODMUN 
		oWsSPEDAdm:oWsEmpresa:cCOD_PAIS := "1058" 
		oWsSPEDAdm:oWsEmpresa:cBAIRRO := cSM0->M0_BAIRENT 
		oWsSPEDAdm:oWsEmpresa:cMUN := cSM0->M0_CIDENT 
		oWsSPEDAdm:oWsEmpresa:cCEP_CP := NIL 
		oWsSPEDAdm:oWsEmpresa:cCP := NIL 
		oWsSPEDAdm:oWsEmpresa:cDDD := Str(FisGetTel(cSM0->M0_TEL)[2],3) 
		oWsSPEDAdm:oWsEmpresa:cFONE := AllTrim(Str(FisGetTel(cSM0->M0_TEL)[3],15)) 
		oWsSPEDAdm:oWsEmpresa:cFAX := AllTrim(Str(FisGetTel(cSM0->M0_FAX)[3],15)) 
		oWsSPEDAdm:oWsEmpresa:cEMAIL := UsrRetMail(RetCodUsr()) 
		oWsSPEDAdm:oWsEmpresa:cNIRE := cSM0->M0_NIRE 
		oWsSPEDAdm:oWsEmpresa:dDTRE := stod(cSM0->M0_DTRE) 
		oWsSPEDAdm:oWsEmpresa:cNIT := cSM0->( IF(M0_TPINSC==1,M0_CGC,"") ) 
		oWsSPEDAdm:oWsEmpresa:cINDSITESP := "" 
		oWsSPEDAdm:oWsEmpresa:cID_MATRIZ := "" 
		oWsSPEDAdm:oWsOutrasInscricoes:oWsInscricao := SPEDADM_ARRAYOFSPED_GENERICSTRUCT():New() 
		oWsSPEDAdm:_URL := cURL 
		lMethodOk := oWsSPEDAdm:AdmEmpresas() 
		DEFAULT lMethodOk := .F. 
		IF !( lMethodOk ) 
			cError := IF( Empty( GetWscError(3) ) , GetWscError(1) , GetWscError(3) ) 
			BREAK 
		EndIF 
		cIdEnt := oWsSPEDAdm:cAdmEmpresasResult 
	END SEQUENCE 
	RestArea(aArea) 
	IF SELECT("cSM0") > 0
		cSM0->( dbCloseArea() )
	ENDIF  
	
Return( cIdEnt )

STATIC FUNCTION XQSF2(aEmb)
	Local cQ	 := ""


	IF SELECT("QSF2") > 0
		QSF2->( dbCloseArea() )
	ENDIF  

	cQ := " SELECT  "
	cQ += " SF2.F2_FILIAL,"+CRLF
	cQ += " SF2.F2_DOC,"+CRLF
	cQ += " SF2.F2_SERIE,"+CRLF
	cQ += " SF2.R_E_C_N_O_,"+CRLF
	cQ += " DAI.DAI_COD"+CRLF
	cQ += " FROM "+ retSQLName("SF2") +" SF2"	+CRLF
	cQ += " INNER JOIN DAI010 DAI"+CRLF
	cQ += " ON DAI.DAI_NFISCA=SF2.F2_DOC"+CRLF
	cQ += " AND DAI.DAI_SERIE= SF2.F2_SERIE"+CRLF
	cQ += " AND DAI.D_E_L_E_T_ <>  '*'"+CRLF
	cQ += " AND DAI.DAI_FILIAL=SF2.F2_FILIAL"+CRLF
	cQ += " WHERE "+CRLF					
	cQ += " SF2.D_E_L_E_T_<>'*'"+CRLF
	cQ += " AND SF2.F2_CHVNFE <> ' '"+CRLF
	cQ += " AND SF2.F2_FILIAL ='"+ aEmb[1]+"'"+CRLF
	cQ += " AND DAI.DAI_COD = '" + aEmb[2] + "' "+CRLF
	cQ += " AND DAI.DAI_PEDIDO = '"+ aEmb[3] +"' "+CRLF

	TcQuery changeQuery(cQ) New Alias "QSF2"

Return


Static Function XSpedPExp(cIdEnt,cSerie,cNotaIni,cNotaFim,cDirDest,lEnd,dDataDe,dDataAte,cCnpjDIni,cCnpjDFim,nTipo,lCTe,cSerMax)
	Local aDeleta  := {}

	Local cAlias	:= GetNextAlias()
	Local cAnoInut  := ""
	Local cAnoInut1 := ""
	Local cCanc		:= ""
	Local cChvIni  	:= ""
	Local cChvFin	:= ""
	//Local cChvNFe  	 := ""
	Local cCNPJDEST := Space(14)
	Local cCondicao	:= ""
	//Local cDestino 	:= ""
	Local cDrive   	:= ""
	Local cIdflush  := cSerie+cNotaIni
	Local cModelo  	:= ""
	Local cNFes     := ""
	//Local cPrefixo 	:= ""
	Local cURL     	:= PadR(GetNewPar("MV_SPEDURL","http://"),250)
	Local cXmlInut  := ""
	Local cXml		:= ""
	Local cWhere	:= ""
	Local cXmlProt	:= ""
	local cAviso    := ""
	local cErro     := ""
	local cTab		  := ""
	local cCmpNum	  := ""
	local cCmpSer	  := ""
	local cCmpTipo  := ""
	local cCmpLoja  := ""
	local cCmpCliFor:= ""
	local cCnpj	  := ""
	Local cEventoCTe	:= ""
	Local cRetEvento	:= ""
	Local cRodapCTe  :=""
	local cCabCTe    :=""
	Local cIdEven	   := ""
	local cVerMDfe		:= ""
	local cNumMdfe		:= ""

	Local lOk      	:= .F.
	Local lFlush  	:= .T.
	Local lFinal   	:= .F.
	Local lClearFilter:= .F.
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

	Default nTipo	:= 1
	Default cNotaIni:=""
	Default cNotaFim:=""
	Default dDataDe:=CtoD("01/01/2001")
	Default dDataAte:=CtoD("  /  /  ")
	Default lCTe	:= IIf (FunName()$"SPEDCTE,TMSA200,TMSAE70,TMSA500,TMSA050",.T.,.F.)
	Default cSerMax := cSerie
	Default cCnpjDIni := '00000000000000'
	Default cCnpjDFim := '99999999999999'

	lUsaColab := UsaColaboracao( IIF(lCte,"2","1") )

	If nTipo == 3
		If !Empty( GetNewPar("MV_NFCEURL","") )
			cURL := PadR(GetNewPar("MV_NFCEURL","http://"),250)
		Endif
	Endif

	If IntTMS() .and. lCTe//Altera o conteudo da variavel quando for carta de corre��o para o CTE
		cTipoNfe := "SAIDA"
	EndIf
	ProcRegua(Val(cNotaFim)-Val(cNotaIni))

	//������������������������������������������������������������������������Ŀ
	//� Corrigi diretorio de destino                                           �
	//��������������������������������������������������������������������������
	SplitPath(cDirDest,@cDrive,@cDestino,"","")
	cDestino := cDrive+cDestino
	//������������������������������������������������������������������������Ŀ
	//� Inicia processamento                                                   �
	//��������������������������������������������������������������������������
	Do While lFlush

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
				//������������������������������������������������������������������������Ŀ
				//� Exporta as notas                                                       �
				//��������������������������������������������������������������������������

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
									//cCab1  += '<cteProc xmlns="http://www.portalfiscal.inf.br/cte" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.portalfiscal.inf.br/cte procCTe_v'+cVerCte+'.xsd" versao="'+cVerCte+'">'
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
								/*
								ProcRegua(Len(oRetEvCanc:CSTRING))
								//---------------------------------------------------------------------------
								//| Exporta Cancelamento do Evento da Nf-e                                  |
								//---------------------------------------------------------------------------

								For nY := 1 To Len(oRetEvCanc:CSTRING)
								cXml    := SpecCharc(oRetEvCanc:CSTRING[nY])
								oXmlExp := XmlParser(cXml,"_",@cErro,@cAviso)
								If cModelo == "57" .and. cVerCte >='2.00'
								if Type("oXmlExp:_PROCEVENTONFE:_RETEVENTO:_CTERECEPCAOEVENTORESULT:_RETEVENTOCTE:_INFEVENTO:_CHCTE")<>"U"
								cIdEven	:= 'ID'+oXmlExp:_PROCEVENTONFE:_RETEVENTO:_CTERECEPCAOEVENTORESULT:_RETEVENTOCTE:_INFEVENTO:_CHCTE:TEXT
								elseIf Type("oXmlExp:_PROCEVENTONFE:_RETEVENTO:_RETEVENTOCTE:_INFEVENTO:_CHCTE")<>"U"
								cIdEven	:= 'ID'+oXmlExp:_PROCEVENTONFE:_RETEVENTO:_RETEVENTOCTE:_INFEVENTO:_CHCTE:TEXT
								endif

								If (Type("oXmlExp:_PROCEVENTONFE:_EVENTO:_EVENTOCTE")<>"U") .and. (Type("oXmlExp:_PROCEVENTONFE:_RETEVENTO:_CTERECEPCAOEVENTORESULT:_RETEVENTOCTE")<>"U")
								cCabCTe   := '<procEventoCTe xmlns="http://www.portalfiscal.inf.br/cte" versao="'+cVerCte+'">'
								cEventoCTe:= XmlSaveStr(oXmlExp:_PROCEVENTONFE:_EVENTO:_EVENTOCTE,.F.)
								cRetEvento:= XmlSaveStr(oXmlExp:_PROCEVENTONFE:_RETEVENTO:_CTERECEPCAOEVENTORESULT:_RETEVENTOCTE,.F.)
								cRodapCTe := '</procEventoCTe>'
								CxML:= cCabCTe+cEventoCTe+cRetEvento+cRodapCTe
								ElseIf (Type("oXmlExp:_PROCEVENTONFE:_EVENTO:_EVENTOCTE")<>"U") .and. (Type("oXmlExp:_PROCEVENTONFE:_RETEVENTO:_RETEVENTOCTE:_INFEVENTO")<>"U")
								cCabCTe   := '<procEventoCTe xmlns="http://www.portalfiscal.inf.br/cte" versao="'+cVerCte+'">'
								cEventoCTe:= XmlSaveStr(oXmlExp:_PROCEVENTONFE:_EVENTO:_EVENTOCTE,.F.)
								cRetEvento:= XmlSaveStr(oXmlExp:_PROCEVENTONFE:_RETEVENTO:_RETEVENTOCTE,.F.)
								cRodapCTe := '</procEventoCTe>'
								CxML:= cCabCTe+cEventoCTe+cRetEvento+cRodapCTe
								EndIf

								else
								if Type("oXmlExp:_PROCEVENTONFE:_EVENTO:_ENVEVENTO:_EVENTO:_INFEVENTO:_ID")<>"U"
								cIdEven	:= oXmlExp:_PROCEVENTONFE:_EVENTO:_ENVEVENTO:_EVENTO:_INFEVENTO:_ID:TEXT
								else
								if Type("oXmlExp:_PROCEVENTONFE:_EVENTO:_INFEVENTO:_ID")<>"U"
								cIdEven  := oXmlExp:_PROCEVENTONFE:_EVENTO:_INFEVENTO:_ID:TEXT
								EndIf
								endif
								endif


								nHandle := FCreate(cDestino+SubStr(cIdEven,3)+"-Canc.xml")
								if nHandle > 0
								FWrite(nHandle,AllTrim(cXml))
								FClose(nHandle)
								endIf
								oXmlExp := Nil
								DelClassIntF()
								Next nY
								*/
							Else
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

									//						If Type("oXml:OWSNFECANCELADA:CXML")<>"U"
									cXmlInut  := oXml:OWSNFECANCELADA:CXML
									cAnoInut1 := At("<ano>",cXmlInut)+5
									cAnoInut  := SubStr(cXmlInut,cAnoInut1,2)
									cXmlProt  := EncodeUtf8(oXml:oWSNFeCancelada:cXMLPROT)
									//					 	EndIf
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

				//������������������������������������������������������������������������Ŀ
				//� Exclui as notas                                                        �
				//��������������������������������������������������������������������������
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
						//Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"STR0046"},3)
						conout("MGFFATAU " + IIf( Empty(GetWscError(3)), GetWscError(1), GetWscError(3) ) )
						lFlush := .F.
					EndIf
				EndIf
				aDeleta  := {}
				If ( Len(oRetorno:OWSNOTAS:OWSNFES3) == 0 .And. Empty(cNfes) )
					//Aviso("SPED","Nao h� dados",{"Ok"})	// "Nao h� dados"
					conout("MGFFATAU Nao h� dados")



					lFlush := .F.
				EndIf
			Else
				//Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3))+CRLF+"STR0046",{"OK"},3)
				conout("MGFFATAU " + IIf( Empty(GetWscError(3)), GetWscError(1), GetWscError(3) ) )
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
						/*
						If Aviso("SPED","Solicitacao processada com sucesso.",{"Sim","Nao"}) == 1	//"Solicitacao processada com sucesso."
						if alltrim(FunName()) == 'SPEDMDFE'
						if empty(cNumMdfe)
						Aviso("SPED","Nao h� dados",{"Ok"})	// "Nao h� dados"
						else
						Aviso("STR0126","STR0151"+" "+Upper(cDestino)+CRLF+CRLF+cNumMdfe,{"Ok"})
						endif
						else
						// Exporta Legado
						Aviso("STR0126","STR0151"+" "+Upper(cDestino)+CRLF+CRLF+cNFes,{"Ok"})//STR0151-"XML Exportados para", "XML's Exportados para"
						endif
						EndIf
						*/
						conout("MGFFATAU Solicitacao processada com sucesso.")
					else
						//Aviso("SPED","STR0106",{"Ok"})	// "Nao h� dados"
						conout("MGFFATAU Nao h� dados")

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
static function QFIL(cFil)

	Local cQuery

	IF SELECT("cSM0") > 0
		cSM0->( dbCloseArea() )
	ENDIF  

	cQuery := " SELECT * FROM SYS_COMPANY "
	cQuery += "  WHERE M0_CODFIL = '" + cFil + "'"
	cQuery += "  AND SYS_COMPANY.D_E_L_E_T_= ' ' "

	TcQuery changeQuery(cQuery) New Alias "cSM0"

Return