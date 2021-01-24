#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"

/*
=====================================================================================
Programa............: MGFFAT40
Autor...............: Atilio Amarilla
Data................: 04/07/2017
Descricao / Objetivo: Job para impressЦo/envio para sistema WinPrint
Doc. Origem.........: FAT WINPRINT
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: IntegraГЦo Protheus Faturamento x WinPrint
=====================================================================================
*/
User Function MFT40JOB(cPar1,cPar2)

	Local aParam	:= { cPar1, cPar2 }

	U_MGFFAT40( aParam )

Return

User Function CallFT40()
	
	U_MGFFAT40( {"01","020001"} )
	
Return

User Function MGFFAT40(aParam)
	
	Local cSelect
	Local aNotas   := {}
	Local oWs
	Local cFaile   //:= GetSrvProfString("Startpath","")+"MGFFAT40"+aParam[1]+aParam[2]+".txt"
	Local cError	:= ""
	
	If ValType(aParam) $ "A"
		
		cFaile   := GetSrvProfString("Startpath","")+"MGFFAT40"+aParam[1]+aParam[2]+".txt"
		
	Else
		
		cFaile   := GetSrvProfString("Startpath","")+"MGFFAT40"+cEmpAnt+cFilAnt+".txt"
		
	EndIf
	/*
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Controle de semaforo - Nao executar caso a ultima execucao ainda nao tenha terminado:                    |
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
	
	nHdFaile := fCreate( cFaile )
	
	If nHdFaile == -1
		ConOut("## MGFFAT40 WINPRINT Ativo ["+cFaile+"] Kill... ##")
		Return
	EndIf
	
	/*
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Job/Schedule - PreparaГЦo do Ambiente                                                                    |
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
	If ValType(aParam) $ "A"
		// TRYEXCEPTION
		RPCSetType(3)
		RpcSetEnv( aParam[1] , aParam[2] , Nil, Nil, "FAT", Nil )
		SetFunName("MGFFAT40")
	EndIf
	
	ConOut("### MGFFAT40 cEmpAnt e cFilAnt: ["+cEmpAnt+"] ["+cFilAnt+"] ###")
	
	Private cSerie		:= GetMV("MGF_FAT40A",,"200")
	
	Private dDatIni		:= GetMv("MGF_FAT40B",,STOD("20170715")) 	 // Data InМcio - ReferЙncia para IntegraГЦo WinPrint
	
	
	/*
	Lexmark MGF ET0021B728772F
	\\spdwvapl052\N_USAR_4
	\\spdwvapl052\WINPRINT1TST
	*/
	Private cNextAlias  := GetNextAlias()
	
	oWs      := WsSpedCfgNFe():New()
	cURL     := PadR(GetMv("MV_SPEDURL"),250)
	
	cIdEnt := getCfgEntidade(@cError)
	
	If Empty(cIdEnt)
		Aviso("SPED", cError, {"STR0114"}, 3)
	EndIf
	
	If CTIsReady()
		
		oWS:cUSERTOKEN := "TOTVS"
		oWS:cID_ENT    := cIdEnt
		/*
		If cFilAnt $ "06"
			oWS:cID_ENT    := "000003"
			cIdEnt         := "000003"
		Else
			oWS:cID_ENT    := "000001"
			cIdEnt         := "000001"
		EndIf
		*/
		oWS:nAmbiente := 0
		oWS:_URL       := AllTrim(cURL)+"/SPEDCFGNFe.apw"
		lOk := oWS:CFGAMBIENTE()
		cAmbiente := oWS:cCfgAmbienteResult
		cAmbiente := Substr(cAmbiente,1,1)
		
	Else
		
		ConOut("WINPRINT-NЦo foi possМvel estabelecer conexЦo com o serviГo da Sefaz.")
		MsgStop("WINPRINT-NЦo foi possМvel estabelecer conexЦo com o serviГo da Sefaz.")
		
		Return
	Endif
	
	ConOut("### Antes do Select ###")
	
	BeginSQL Alias cNextAlias
		
		SELECT DISTINCT( SF2.R_E_C_N_O_ ) F2_RECNO
		FROM %table:SF2% SF2
		INNER JOIN %table:DAI% DAI ON DAI.%notDel%
  			AND DAI_FILIAL = F2_FILIAL
  			AND DAI_NFISCA = F2_DOC
  			AND DAI_SERIE = F2_SERIE
  			AND DAI_CLIENT = F2_CLIENTE
  			AND DAI_LOJA = F2_LOJA
		WHERE SF2.%notDel%
			AND F2_FILIAL = %xFilial:SF2%
			AND F2_EMISSAO >= %Exp:DTOS(dDatIni)%
			AND F2_SERIE = %Exp:cSerie%
			AND F2_ZWINPRN = ' '
		ORDER BY 1
		
	EndSQL

//			AND F2_DOC IN ('000001131','000001132')
	
	aQuery := GetLastQuery()
	
	//MemoWrit( "C:\TEMP\"+FunName()+".SQL" , aQuery[2] )
	//[1] Tabela temp
	//[2] Query
	//..[5]
	
	(cNextAlias)->( DbGoTop() )
	
	//ConOut("### Apos Select. Resultado da Query: ["+(cNextAlias)->F2_NUM+"] ###")
	
	If !Empty( (cNextAlias)->F2_RECNO )
		
		dbSelectArea("SF2")
		dbSetOrder(1)
		
		While !(cNextAlias)->( eof() )
			SF2->( dbGoTo( (cNextAlias)->F2_RECNO ) )
			/*
			здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			Ё Posicionar na NF para chamar a impressao da DANFE que gera o PDF:                                        |
			юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
			
			cGetIdEntErr := ""
			cFilePrint   := "DANFE_"+cFilAnt+"_"+DTOS(Date())+StrTran(Time(),":")
			cCaminho     := "\spool\" //"C:\TEMP\"  "\spool\"
			
			U_MGFFAT46(cIdEnt,cFilePrint,cCaminho,SF2->F2_DOC,SF2->F2_DOC,SF2->F2_SERIE,"1","2","2")
			
			(cNextAlias)->( dbSkip() )
		EndDo
	EndIf
	
	dbSelectArea(cNextAlias)
	dbCloseArea()
	
	
	/*
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Job/Schedule - FinalizaГЦo do Ambiente.                                                                  |
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	*/
	If ValType(aParam) $ "A"
		RpcClearEnv()
	EndIf
	
Return