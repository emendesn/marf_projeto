#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"

/*
=====================================================================================
Programa............: MGFFAT47
Autor...............: Atilio Amarilla
Data................: 22/08/2017
Descricao / Objetivo: Chamada para reimpress�o/reenvio para sistema WinPrint
Doc. Origem.........: FAT WINPRINT
Solicitante.........: Cliente
Uso.................: 
Obs.................: Integracao Protheus Faturamento x WinPrint. Chamado por PE
FISTRFNFE.
=====================================================================================
*/
User Function MGFFAT47(aParam)
	
	Local cNotaIni	:= cNotaFim	:= Space( TamSX3("F2_DOC")[1] )
	Local nMaxNot	:= GetMV("MGF_FAT47A",,500)
	Local aPergs	:= {}
	Local aRet		:= {}
	Local aArea		:= GetArea()
	Local aAreaSF2	:= SF2->( GetArea() )
	Local aIndArq	:= {}
	Local oWs
	Local cError	:= ""
	
	Private cSerie		:= GetMV("MGF_FAT40A",,"200")
	
	Private dDatIni		:= GetMv("MGF_FAT40B",,STOD("20170715")) 	 // Data Inicio - Referencia para Integracao WinPrint
	
	/*
	Lexmark MGF ET0021B728772F
	\\spdwvapl052\N_USAR_4
	\\spdwvapl052\WINPRINT1TST
	*/
	
	
	cIdEnt := getCfgEntidade(@cError) // cIdEnt := GetIdEnt()
	If Empty(cIdEnt)
		Aviso("SPED", cError, {"STR0114"}, 3)
		Return
	EndIf

	Private cNextAlias  := GetNextAlias()
	
	/*
	1 - MsGet
	[2] : Descricao
	[3] : String contendo o inicializador do campo
	[4] : String contendo a Picture do campo
	[5] : String contendo a validacao
	[6] : Consulta F3
	[7] : String contendo a validacao When
	[8] : Tamanho do MsGet
	[9] : Flag .T./.F. Parametro Obrigatorio ?
	*/
	aAdd( aPergs ,{1,"Numero Nota De : ",cNotaIni,Replicate("9", TamSX3("F2_DOC")[1] ),'.T.'	,	,'.T.',40,.F.})
	aAdd( aPergs ,{1,"Numero Nota Ate: ",cNotaFim,Replicate("9", TamSX3("F2_DOC")[1] ),'.T.'	,	,'.T.',40,.T.})
	
	If !ParamBox(aPergs ,"Parametros WINPRINT - Reimpressao",aRet)
		Aviso("WINPRINT - Reemissao","Processamento Cancelado!",{'Ok'})
		Return aRet
	ElseIf  Val(aRet[2])-Val(aRet[1]) < 0 .Or. aRet[2] < aRet[1]
		Aviso("WINPRINT - Reemissao","Intervalo Invalido!",{'Ok'})
		Return aRet
	ElseIf  Val(aRet[2])-Val(aRet[1]) > nMaxNot
		Aviso("WINPRINT - Reemissao","Intervalo Invalido!"+CRLF+CRLF+"Selecionar maximo de "+AllTrim(Str(nMaxNot))+" notas",{'Ok'})
		Return aRet
	EndIf
	
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
		AND F2_DOC BETWEEN %Exp:aRet[1]% AND %Exp:aRet[2]%
		AND F2_SERIE = %Exp:cSerie%
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

		//MsgRun("WINPRINT, Imprimindo Notas...",,{|| MGFFAT4701() })
		//Processa( {|| MGFFAT4701() },'WINPRINT', 'Imprimindo Notas...',.F. ) //,  )
		MGFFAT4701()

		Aviso("Marfrig - WINPRINT","Final de processamento.",{"Ok"})

	Else
		MsgStop("Nao foram localizadas notas para os parametros selecionados.","Marfrig - WINPRINT")
	EndIf
	
	dbSelectArea(cNextAlias)
	dbCloseArea()
	
	SF2->( RestArea(aAreaSF2) )
	RestArea(aArea)
	
	//MsgStop("Final de processamento.","Reimpressao WINPRINT")
	
Return

Static Function MGFFAT4701()

	//ProcRegua(0)
	
	While !(cNextAlias)->( eof() )
		
		SF2->( dbGoTo( (cNextAlias)->F2_RECNO ) )
		//IncProc("Imprimindo "+SF2->F2_DOC)
		/*
		����������������������������������������������������������������������������������������������������������Ŀ
		� Posicionar na NF para chamar a impressao da DANFE que gera o PDF:                                        |
		������������������������������������������������������������������������������������������������������������*/
		
		cGetIdEntErr := ""
		cFilePrint   := "DANFE_"+cFilAnt+"_"+AllTrim(SF2->F2_DOC)+"_"+AllTrim(SF2->F2_SERIE)+"_"+DTOS(Date())+StrTran(Time(),":")
		cCaminho     := "\spool\" //"C:\TEMP\"  "\spool\"
		
		U_MGFFAT46(cIdEnt,cFilePrint,cCaminho,SF2->F2_DOC,SF2->F2_DOC,SF2->F2_SERIE,"1","2","2")
		
		(cNextAlias)->( dbSkip() )
		
	EndDo
	
Return
