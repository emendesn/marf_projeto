#INCLUDE "Protheus.ch"

STATIC __aCtbVlDtCal := {}

STATIC lDefTopCTB	:= IfDefTopCTB()

/*
=====================================================================================
Programa............: MGFCTB01
Autor...............: Joni Lima
Data................: 05/11/2016
Descricao / Objetivo: Realiza Contabilizacao dos Rateios
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................:
=====================================================================================
*/
User Function MGFCTB01()
	
	Local cPerg	    := PadR("MGFCTB01", Len(SX1->X1_GRUPO))
	
	If Pergunte(cPerg,.T.)
		xMF01ConRt()
	EndIf
	
Return

/*
=====================================================================================
Programa............: xMF01ConRt
Autor...............: Joni Lima
Data................: 07/11/2016
Descricao / Objetivo: Realiza Contabilizacao dos Rateios
Doc. Origem.........: Contrato - GAP CTB01
Solicitante.........: Cliente
Uso.................: 
Obs.................:
=====================================================================================
*/
Static Function xMF01ConRt()
	
	Local aArea		  := GetArea()
	Local aAreaSDE    := SDE->(GetArea())
	Local aCT5		  := {}
	Local lExibeLcto  := MV_PAR05 == 1 //GetMv("MGF_EXIBE",,.T.)
	
	Local cxFilAtu := cFilAnt //Filial Atual
	Local cLoteCTB	:= GetMv("MGF_LOTPAD",,"") //Lote Contabil para esse Lancamento
	Local cArqCTB	:= ""
	Local nTotalLcto:= 0
	
	Local c333		:= ''
	Local c334		:= ''
	Local cSpacFil	:= Replicate(' ',LEN(SM0->M0_CODIGO))
	Local dxDt		:= dDataBase
	
	Local cNextAlias:= GetNextAlias()
	Local aFlagCTB := {}
	
	If xMF01lCont()
		
		If Select(cNextAlias) > 0
			(cNextAlias)->(DbClosearea())
		Endif
		
		BeginSql Alias cNextAlias
			
			SELECT
				SDE.*,SF1.F1_DTDIGIT			
			FROM
				%Table:SDE% SDE, %Table:SF1% SF1
			WHERE
				SDE.DE_FILIAL BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02%
				AND SDE.DE_ZDTLANC = '        '
				AND SDE.D_E_L_E_T_ = ' '
				AND SDE.DE_ZFILDES <> %exp:cSpacFil%
				AND SF1.F1_DTLANC <> ' '
				AND SF1.F1_DTDIGIT BETWEEN %exp:MV_PAR03% AND %exp:MV_PAR04%
				
				AND DE_FILIAL = F1_FILIAL
				AND DE_DOC = F1_DOC
				AND DE_SERIE = F1_SERIE
				AND DE_FORNECE = F1_FORNECE
				AND DE_LOJA = F1_LOJA
				AND SF1.D_E_L_E_T_ = ' '
			
			ORDER BY DE_FILIAL, DE_DOC , DE_ITEMNF
			
		EndSql
		
		(cNextAlias)->(DbGoTop())
		
		dbSelectArea('SDE')
		SDE->(dbSetOrder(1))//DE_FILIAL, DE_DOC, DE_SERIE, DE_FORNECE, DE_LOJA, DE_ITEMNF, DE_ITEM
		
		While (cNextAlias)->(!EOF())
			If SDE->(DbSeek((cNextAlias)->(DE_FILIAL + DE_DOC + DE_SERIE + DE_FORNECE + DE_LOJA + DE_ITEMNF + DE_ITEM)))
				
				c333 := CtRelation("333")
				c334 := CtRelation("334")
								
				dxDt := IIF(ValType((cNextAlias)->F1_DTDIGIT)=='D',(cNextAlias)->F1_DTDIGIT,STOD((cNextAlias)->F1_DTDIGIT))
				
				AADD(aFlagCTB,{"DE_ZDTLANC",dxDt,"SDE",SDE->(Recno()),0,0,0})
				
				cFilAnt := SDE->DE_FILIAL
				SM0->(dbSetOrder(1))//M0_CODIGO + M0_CODFIL
				SM0->(dbSeek(SM0->M0_CODIGO + cFilAnt))
				
				//Realiza Contabilizacao Ponto Lancamento 333
				nHeadProv  := HeadProva(cLoteCTB,"MGFCTB01",Substr(cUsuario,7,6),@cArqCTB)
				nTotalLcto += DetProva(nHeadProv,'333',"MGFCTB01",cLoteCTB,,,,,@c333,@aCT5,,/*@aFlagCTB*/)
				RodaProva(nHeadProv,nTotalLcto)
				cA100Incl(cArqCTB,nHeadProv,1,cLoteCTB,lExibeLcto,.F.,,dxDt,,/*@aFlagCTB*/)
				
				cFilAnt := SDE->DE_ZFILDES
				SM0->(dbSetOrder(1))//M0_CODIGO + M0_CODFIL
				SM0->(dbSeek(SM0->M0_CODIGO + cFilAnt))
				
				//Realiza Contabilizacao Ponto Lancamento 334
				nHeadProv  := HeadProva(cLoteCTB,"MGFCTB01",Substr(cUsuario,7,6),@cArqCTB)
				nTotalLcto += DetProva(nHeadProv,'334',"MGFCTB01",cLoteCTB,,,,,@c334,@aCT5,,@aFlagCTB)
				RodaProva(nHeadProv,nTotalLcto)
				cA100Incl(cArqCTB,nHeadProv,1,cLoteCTB,lExibeLcto,.F.,,dxDt,,@aFlagCTB)
				
			EndIf
			(cNextAlias)->(DbSkip())
		EndDo
		
		(cNextAlias)->(dbCloseArea())
	EndIF

	cFilAnt := cxFilAtu//Retorna Filial que chamou a Execucao
	SM0->(dbSetOrder(1))//M0_CODIGO + M0_CODFIL
	SM0->(dbSeek(SM0->M0_CODIGO + cFilAnt))

	
	RestArea(aAreaSDE)
	RestArea(aArea)
	
Return

/*
=====================================================================================
Programa............: xMF01lCont
Autor...............: Joni Lima
Data................: 09/11/2016
Descricao / Objetivo: Realiza Validacao dos periodos nos calendarios
Doc. Origem.........: Contrato - GAP CTB01
Solicitante.........: Cliente
Uso.................: 
Obs.................: Verifica se o calendario da Filial se encontra fechado ou aberto.
=====================================================================================
*/
Static Function xMF01lCont()
	
	Local aArea		:= GetArea()	
	Local cNextAlias:= GetNextAlias()
	Local cxFilAtu 	:= cFilAnt //Guarda Filial Atual
	Local cErros	:= 'Os Periodos abaixo encontram-se Bloqueados/ou sem Calendario Amarrado com Moeda' + CRLF
	Local cMoeda	:= '01'
	Local aFil		:= {}
	Local aERROS	:= {}
	Local nPos		:= 0
	Local ni		:= 0
	Local lRet		:= .T.
	Local lTempRet	:= .F.
	Local lRetMoed	:= .F.
	Local dDtHav
	Local cSpacFil	:= Replicate(' ',LEN(SM0->M0_CODIGO))
	
	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif
	
	BeginSql Alias cNextAlias
		
		SELECT
			DISTINCT SDE.DE_FILIAL,SDE.DE_ZFILDES, SF1.F1_DTDIGIT
		FROM
			%Table:SDE% SDE, %Table:SF1% SF1
		WHERE
		
			SDE.DE_FILIAL BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02%
			AND SDE.DE_ZDTLANC = '        '
			AND SDE.D_E_L_E_T_ = ' '
			AND SDE.DE_ZFILDES <> %exp:cSpacFil%
			AND SF1.F1_DTLANC <> ' '
			AND SF1.F1_DTDIGIT BETWEEN %exp:MV_PAR03% AND %exp:MV_PAR04%
			
			AND DE_FILIAL = F1_FILIAL
			AND DE_DOC = F1_DOC
			AND DE_SERIE = F1_SERIE
			AND DE_FORNECE = F1_FORNECE
			AND DE_LOJA = F1_LOJA
			AND SF1.D_E_L_E_T_ = ' '
			
			ORDER BY DE_FILIAL, DE_ZFILDES
		
	EndSql
	
	(cNextAlias)->(DbGoTop())
	
	//Monta Array com Filiais e Datas
	While (cNextAlias)->(!EOF())
		
		//Filial Origem
		If Len(aFil) > 0
			nPos := Ascan(aFil,{|x| x[1] + x[2]  == (cNextAlias)->(DE_FILIAL + F1_DTDIGIT)} )
		EndIf		
		If nPos == 0
			AADD(aFil,{(cNextAlias)->DE_FILIAL,(cNextAlias)->F1_DTDIGIT})
		EndIf
		
		//Filial Destino
		If Len(aFil) > 0
			nPos := Ascan(aFil,{|x| x[1] + x[2]  == (cNextAlias)->(DE_ZFILDES + F1_DTDIGIT)} )
		EndIf
		If nPos == 0
			AADD(aFil,{(cNextAlias)->DE_ZFILDES,(cNextAlias)->F1_DTDIGIT})
		EndIf
		
		(cNextAlias)->(DbSkip())
	EndDo
	
	(cNextAlias)->(dbCloseArea())
	
	//Percorre Array, e verifica como esta o calendario para essas filiais e datas
	For ni := 1  To Len(aFil)
		
		cFilAnt  := aFil[ni,1]//Filial
		
		SM0->(dbSetOrder(1))//M0_CODIGO + M0_CODFIL
		SM0->(dbSeek(SM0->M0_CODIGO + cFilAnt))
		
		dDtHav 	 := STOD(aFil[ni,2]) //Pega Data
		lTempRet := U_XXVlDtCal(dDtHav,dDtHav) //Realiza Validacao do Periodo
		//lTempRet := StartJob("U_xM10JobD",GetEnvServer(),.T.,cEmpAnt,cFilAnt,cModulo,dDtHav) //(cEmp,cFil,cModulo,dDt)
		//If lTempRet
			//lTempRet := CtbDtComp(1,dDtHav,cMoeda) //Realiza Validacao do Periodo esta amarrado com Moeda
		//EndIf
		
		If !lTempRet
			AADD(aERROS,'Filial: ' + aFil[ni,1] + ', Data: ' + dToC(dDtHav))
			If lRet //Sera alterado apenas uma vez essa variavel.
				lRet := .F.
			EndIf
		EndIf
		
	Next ni
	
	//Verifica se Gerou erros e apresenta as filiais e datas que estao com datas em calendarios INDISPONIVEIS
	If Len(aERROS) > 0
		For ni := 1 to Len(aERROS)
			cErros += aERROS[ni]
		Next ni
		AVISO('Periodo Bloqueado',cErros,{'OK'},3)
	EndIf
	
	cFilAnt := cxFilAtu //Retorna Filial
	SM0->(dbSetOrder(1))//M0_CODIGO + M0_CODFIL 
	SM0->(dbSeek(SM0->M0_CODIGO + cFilAnt))

	RestArea(aArea)
	
Return lRet

User Function XXVlDtCal(dDtIni,dDtFim,nTMoedas,cMoeda,cStatBlq,lMensagem,cTpSaldo)

Local lDatasOk	:= .T.
Local aCalends	:= {}
Local nCal		:= 1
Local nQ		:= 1
Local lFoundCTG := .F.
Local cQuery 	:= ""
Local nLenStat
Local nX
Local lRet 		:= .F.
Local nPos      := 0
Local lCache := CtbCache(7)

DEFAULT cStatBlq	:= GetNewPar("MV_CTGBLOQ","234")	/// INDICA OS STATUS DE CALENDARIO QUE NAO PERMITEM REPROCESSAR
DEFAULT dDtIni 		:= dDataBase
DEFAULT dDtFim 		:= dDataBase
DEFAULT nTMoedas	:= 2
DEFAULT cMoeda		:= "01"
DEFAULT lMensagem	:= .T.
DEFAULT cTPSaldo		:= ""

__aCtbVlDtCal := {}

If lCache .And. Len(__aCtbVlDtCal) > 0  .And. ( nPos := aScan(__aCtbVlDtCal,{|x|  	x[1] == dDtIni .And. ;
																		x[2] == dDtFim .And. ;
																		x[3] == nTMOedas .And. ;
																		x[4] == cMoeda .And. ;
																		x[5] == cStatBlq .And. ;
																		x[6] == lMensagem .And. ;
																		x[7] == cTpSaldo } ) ) > 0
	lDatasOk := __aCtbVlDtCal[nPos, 8]
																		
	If !lDatasOk .And. lMensagem
		//"O intervalo de datas informadas nao podera ser processado. "#"Verifique o intervalo de datas ou os calend�rios no intervalo."
		//"Moeda "#", o periodo "#" do calendario "#" esta Bloqueado/Encerrado."
		MsgInfo("O intervalo de datas informadas nao podera ser processado. Verifique o intervalo de datas ou os calend�rios no intervalo.","Moeda , o periodo  do calendario  esta Bloqueado/Encerrado.")
	EndIf
Else																		

	__nQuantas 	:= CtbMoedas()
	cStatBlq 	:= Alltrim(cStatBlq)
	nLenStat 	:= Len(cStatBlq)

	
	For nQ := 1 to __nQuantas
		If nTMoedas == 2			/// SE FOR MOEDA ESPEC�FICA
			nQ := Val(cMoeda)
		Else						/// SE FOR PARA TODAS AS MOEDAS
			cMoeda := StrZero(nQ,2)
		Endif
	
		If dDtIni <> dDTFim
			
			If lDefTopCTB .And. nLenStat > 0
				cQuery := " SELECT "
				cQuery += " CTE_FILIAL, "
				cQuery += " CTE_MOEDA, "
				cQuery += " CTG_DTINI, "
				cQuery += " CTG_DTFIM, "
				cQuery += " CTG_CALEND, "
				cQuery += " CTG_PERIOD  "
				cQuery += " FROM " + RetSqlName("CTE")+" CTE, "+ RetSqlName("CTG")+" CTG "
				cQuery += " WHERE CTE_CALEND = CTG_CALEND "
				cQuery += "   AND CTE_FILIAL = '"+xFilial("CTE")+"' "
				cQuery += "   AND CTE_MOEDA = '"+cMoeda+"' "
				cQuery += "   AND CTE.D_E_L_E_T_ = ' ' "
				cQuery += "   AND CTG_FILIAL = '"+xFilial("CTG")+"' "
				cQuery += "   AND CTG_STATUS IN ('"
				For nX := 1 TO nLenStat
					cQuery += Substr(cStatBlq, nX, 1) + If( nX<nLenStat, "','", "" )
				Next
				cQuery += "')"
				cQuery += "   AND CTG.D_E_L_E_T_ = ' ' "
				
		   			//RETIRADO PARA PERFORMANCE - ANSI NAO HA NECESSIDADE DE PASSAR PELA CHANGEQUERY	
					If ! ( Alltrim(Upper(TCGetDB())) $ "MSSQL|MSSQL7|ORACLE" )
						cQuery := ChangeQuery(cQuery)
					EndIf
				
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"CTEBLOQ",.T.,.F.)
				TcSetField("CTEBLOQ","CTG_DTINI","D",8,0)
				TcSetField("CTEBLOQ","CTG_DTFIM","D",8,0)
				
				lRet := CTEBLOQ->(! Eof() )
				
				If lRet
					While CTEBLOQ->(! Eof() )
						aAdd(aCalends,{CTEBLOQ->CTG_DTINI,CTEBLOQ->CTG_DTFIM,CTEBLOQ->CTG_CALEND,CTEBLOQ->CTG_PERIOD,CTG->CTG_EXERC})
						CTEBLOQ->( dbSkip() )
					EndDo
				EndIf
				
				dbSelectArea("CTEBLOQ")
				dbCloseArea()
				
			EndIf
			//se nao conseguiu resolver na query para exibir mensagens coerentes
			If ! lRet
				dbSelectArea("CTE")
				dbSetOrder(1)
				If MsSeek(xFilial("CTE")+cMoeda,.F.)
					While CTE->(!Eof()) .And. CTE->CTE_FILIAL == xFilial("CTE") .and. CTE->CTE_MOEDA == cMoeda
						dbSelectArea("CTG")
						dbSetOrder(2)
						If MsSeek(xFilial("CTG")+CTE->CTE_CALEND,.F.)
							lFoundCTG := .T.
							While !Eof() .and. CTG->CTG_CALEND == CTE->CTE_CALEND
								If CTG->CTG_STATUS$cStatBlq
									aAdd(aCalends,{CTG->CTG_DTINI,CTG->CTG_DTFIM,CTG->CTG_CALEND,CTG->CTG_PERIOD,CTG->CTG_EXERC})
								Else
									If !Empty(cTpSaldo) .AND. dDtIni <= CTG->CTG_DTINI .AND. CTG->CTG_DTINI <= dDtFim .AND. dDtIni <= CTG->CTG_DTFIM .AND. CTG->CTG_DTFIM <= dDtFim
										If !CtbVldArm(CTE->CTE_MOEDA,CTG->CTG_CALEND,CTG->CTG_EXERC,CTG->CTG_PERIOD,cTpSaldo,lMensagem)
											lDatasOk := .F.
											Exit				  									
										EndIf
									EndIf	
								EndIf
								CTG->(dbSkip())
							EndDo
						EndIf
						CTE->(dbSkip())
					EndDo
					If !lFoundCTG	/// SE NAO ENCONTROU NENHUM CALEND�RIO AMARRADO
						If lMensagem
							Help("  ",1,"CTGNOCAD")
						EndIf
						lDatasOk := .F.
					EndIf
				Else
					If lMensagem
						// Nao  h� nenhuma calend�rio montado
						Help("  ",1,"CTGDTOUT")
					EndIf
					lDatasOk := .F.
				EndIf
			EndIf
			If lDatasOk
				For nCal := 1 to Len(aCalends)
					If (dDtIni <= aCalends[nCal][1] .and. dDtFim >= aCalends[nCal][2]) .or.;
						(dDtIni >= aCalends[nCal][1] .and. dDtFim <= aCalends[nCal][2]) .or.;
						(dDtIni <= aCalends[nCal][1] .and. dDtFim >= aCalends[nCal][1] .and. dDtFim <= aCalends[nCal][2]) .or.;
						(dDtIni >= aCalends[nCal][1] .and. dDtIni <= aCalends[nCal][2])
						
						If lMensagem
							//"O intervalo de datas informadas nao podera ser processado. "#"Verifique o intervalo de datas ou os calend�rios no intervalo."
							//"Moeda "#", o periodo "#" do calendario "#" esta Bloqueado/Encerrado."
							MsgInfo("O intervalo de datas informadas nao podera ser processado. Verifique o intervalo de datas ou os calend�rios no intervalo.","Moeda "+StrZero(nQ,2)+", o periodo "+aCalends[nCal][4]+" do calendario "+aCalends[nCal][3]+" esta Bloqueado/Encerrado.")
						EndIf
						lDatasOk := .F.
						Exit
					EndIf
				    
				    If !Empty(cTpSaldo)
						If !CtbVldArm(cMoeda,aCalends[nCal][3],aCalends[nCal][5],aCalends[nCal][4],cTpSaldo,lMensagem)
							lDatasOk := .F.
							Exit				  									
						EndIf
					EndIf	
				Next
			EndIf
			
		Else					/// SE DATA INICIAL E FINAL FOREM IGUAIS (APENAS 1 DATA)
			If lDefTopCTB
				cQuery := " SELECT "
				cQuery += " CTE_FILIAL, "
				cQuery += " CTE_MOEDA, "
				cQuery += " CTG_DTINI, "
				cQuery += " CTG_DTFIM, "
				cQuery += " CTG_CALEND, "
				cQuery += " CTG_PERIOD,  "
				cQuery += " CTG_EXERC  "
				cQuery += " FROM " + RetSqlName("CTE")+" CTE, "+ RetSqlName("CTG")+" CTG "
				cQuery += " WHERE CTE_CALEND = CTG_CALEND "
				cQuery += "   AND CTE_FILIAL = '"+xFilial("CTE")+"' "
				cQuery += "   AND CTE_MOEDA = '"+cMoeda+"' "
				cQuery += "   AND CTE.D_E_L_E_T_ = ' ' "
				cQuery += "   AND CTG_FILIAL = '"+xFilial("CTG")+"' "
				cQuery += "   AND '"+DTOS(dDtIni)+"' BETWEEN CTG_DTINI AND CTG_DTFIM "
				cQuery += "   AND CTG_STATUS IN ('"
				For nX := 1 TO nLenStat
					cQuery += Substr(cStatBlq, nX, 1) + If( nX<nLenStat, "','", "" )
				Next
				cQuery += "')"
				cQuery += "   AND CTG.D_E_L_E_T_ = ' ' "
				
				//RETIRADO PARA PERFORMANCE - ANSI NAO HA NECESSIDADE DE PASSAR PELA CHANGEQUERY	
				If ! ( Alltrim(Upper(TCGetDB())) $ "MSSQL|MSSQL7|ORACLE" )
					cQuery := ChangeQuery(cQuery)
				EndIf
				
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"CTEBLOQ",.T.,.F.)
				TcSetField("CTEBLOQ","CTG_DTINI","D",8,0)
				TcSetField("CTEBLOQ","CTG_DTFIM","D",8,0)
				
				lRet := CTEBLOQ->(! Eof() )
				
				If lRet
					If lMensagem
						//"O intervalo de datas informadas nao podera ser processado. "#"Verifique o intervalo de datas ou os calend�rios no intervalo."
						//"Moeda "#", o periodo "#" do calendario "#" esta Bloqueado/Encerrado."
						MsgInfo("O intervalo de datas informadas nao podera ser processado. Verifique o intervalo de datas ou os calend�rios no intervalo.","Moeda "+cMoeda+", o periodo "+CTEBLOQ->CTG_PERIOD+" do calendario "+CTEBLOQ->CTG_CALEND+" esta Bloqueado/Encerrado.")
					EndIf
					lDatasOk := .F.			
				EndIf
				
				dbSelectArea("CTEBLOQ")
				dbCloseArea()
				
			EndIf
			//se nao conseguiu resolver na query para exibir mensagens coerentes
			If ! lRet
				dbSelectArea("CTE")
				dbSetOrder(1)
				If MsSeek(xFilial("CTE")+cMoeda,.F.)
					While CTE->(!Eof()) .And. CTE->CTE_FILIAL == xFilial("CTE") .and. CTE->CTE_MOEDA == cMoeda
						dbSelectArea("CTG")
						dbSetOrder(2)
						MsSeek(xFilial("CTG")+CTE->CTE_CALEND+DTOS(dDtIni),.T.)
						
						If 	CTG->(Eof()) .or. ;
							CTG->CTG_FILIAL <> xFilial("CTG") .or. ;
							CTG->CTG_CALEND <> CTE->CTE_CALEND .or. ;
							DTOS(dDtIni) < DTOS(CTG->CTG_DTINI)
							CTG->(dbSkip(-1))
						EndIf
						
						If 	CTG->(!Eof()) .And. ;
							CTG->CTG_FILIAL == xFilial("CTG") .And. ;
							CTG->CTG_CALEND == CTE->CTE_CALEND .And. ;
							DTOS(dDtIni) >= DTOS(CTG->CTG_DTINI) .And. ;
							DTOS(dDtIni) <= DTOS(CTG->CTG_DTFIM)
							
							lFoundCTG := .T.
							
							If CTG->CTG_STATUS$cStatBlq
								If lMensagem
									//"O intervalo de datas informadas nao podera ser processado. "#"Verifique o intervalo de datas ou os calend�rios no intervalo."
									//"Moeda "#", o periodo "#" do calendario "#" esta Bloqueado/Encerrado."
									MsgInfo("O intervalo de datas informadas nao podera ser processado. Verifique o intervalo de datas ou os calend�rios no intervalo.","Moeda "+cMoeda+", o periodo "+CTG->CTG_PERIOD+" do calendario "+CTG->CTG_CALEND+" esta Bloqueado/Encerrado.")
								EndIf
								
								lDatasOk := .F.
								Exit
							EndIf
						
							If !Empty(cTpSaldo)
				   				If !CtbVldArm(cMoeda,CTG->CTG_CALEND,CTG->CTG_EXERC,CTG->CTG_PERIOD,cTpSaldo,lMensagem)
									lDatasOk := .F.
									Exit			  									
								EndIf
							EndIf											
						EndIf
						
						CTE->(dbSkip())
					EndDo
					
					If !lFoundCTG
						// Nao  h� nenhuma calend�rio montado
						If lMensagem
							Help("  ",1,"CTGNOCAD")
						Endif
						lDatasOk := .F.
						Exit
					EndIf
				Else
					If lMensagem
						// Nao  h� nenhuma calend�rio montado
						Help("  ",1,"CTGDTOUT")
					EndIf
					lDatasOk := .F.
				EndIf
			EndIf
		EndIf
		
		If nTMoedas == 2 .or. !lDatasOk
			Exit
		Endif
	Next
	If lCache
		//armazena em array static para nao fazer pesquisa a cada nova chamada da funcao
		//os primeiros 7 elementos sao os parametros da chamada da funcao
		//resultado do processamento fica armazenado no elemento 8
		//elementos            1      2       3         4     5         6         7        8
		aAdd(__aCtbVlDtCal, {dDtIni,dDtFim,nTMoedas,cMoeda,cStatBlq,lMensagem,cTpSaldo, lDatasOk} )
	EndIf
EndIf

Return(lDatasOk)
