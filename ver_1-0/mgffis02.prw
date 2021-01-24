#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
=====================================================================================
Programa.:              MGFFIS02
Autor....:              Luis Artuso
Data.....:              14/10/16
Descricao / Objetivo:   Chamada da rotina principal
Doc. Origem:            Contrato - GAP FIS46
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
User Function MGFFIS02()



	Local oBarra

	AtuSX1()

	If ( fPergunta() )



		oBarra	:= MsNewProcess():New({|lEnd| fProcAgreg(oBarra) , "Aguarde... Gerando os arquivos" , .F.})
		oBarra:Activate()

	EndIf

	//fExibeTela()

Return

/*
=====================================================================================
Programa.:              fProcAgreg
Autor....:              Luis Artuso
Data.....:              14/10/16
Descricao / Objetivo:   Execucao das rotinas que geram os respectivos arquivos texto.
Doc. Origem:            Contrato - GAP FIS46
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
Static Function fProcAgreg(oBarra)

	Local nProcessos	:= 0
	Local nX			:= 0
	Local aProcessos	:= {}
	Local cProcesso		:= ""
	Local cDirDest		:= ""

	If (Empty(MV_PAR06))

		MsgAlert('O diretorio de destino está vazio. Reinicie o processamento. ')

	Else

		AADD( aProcessos ,	"fArqEmp(oBarra , MV_PAR06)" 	) //gerou
		AADD( aProcessos ,	"fArqFolha(oBarra , MV_PAR06)" 	)//gerou
		AADD( aProcessos ,	"fArqFrig(oBarra , MV_PAR06)" 	)///verificar
		AADD( aProcessos ,	"fNotaSent(oBarra , MV_PAR06)"	)//Verificar
		AADD( aProcessos ,	"fNotaSen1(oBarra , MV_PAR06)"	)//
		AADD( aProcessos ,	"fCondenas(oBarra , MV_PAR06)"	) // código de condenas
		AADD( aProcessos ,	"fArqGTA(oBarra , MV_PAR06)"	)//
		AADD( aProcessos ,	"fNotaSAI(oBarra , MV_PAR06)"	)//gerou
		AADD( aProcessos ,	"fNotaSA1(oBarra , MV_PAR06)"	)//gerou

		//		AADD( aProcessos ,	"fArqFrig(oBarra , MV_PAR06)" 	)

		nProcessos	:= Len(aProcessos) //Quantidade de arquivos para geracao

		oBarra:SetRegua1(nProcessos)

		For nX	:= 1 TO nProcessos

			cProcesso	:= aProcessos[nX]

			&cProcesso

			oBarra:IncRegua1(nX)

		Next nX

	EndIf

Return

/*
=====================================================================================
Programa.:              fArqEmp
Autor....:              Luis Artuso
Data.....:              14/10/16
Descricao / Objetivo:   Gera o arquivo 'Empresas.txt'
Doc. Origem:            Contrato - GAP FIS46
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:				ARQUIVO DE EMPRESAS
=====================================================================================
*/
Static Function fArqEmp(oBarra , MV_PAR06)

	Local aLayOut	:= {}
	Local aDados	:= {}
	Local cAliasSM0	:= ""
	Local cAliasSA2	:= ""
	Local cAliasSF1	:= ""
	Local cAliasSF2	:= ""
	Local cAliasSA1	:= ""		
	Local cTipo		:= ""
	Local cLinha	:= ""
	Local nTotReg	:= 0
	Local nTotReg2	:= 0
	Local nHandle	:= 0
	Local cArqSaida	:= ""      
	Local cAliasTMP2 := ""              
	Local cChave := ""

	cAliasSM0	:= "SM0"
	cAliasSA2	:= "SA2"
	cAliasSF1	:= "SF1"
	cAliasSF2	:= "SF2"
	cAliasSA1	:= "SA1"

	cTipo		:= "P"

	nTotReg		:= (cAliasSM0)->(RecCount())
	//	nTotReg2	:= (cAliasSA2)->(RecCount())

	oBarra:SetRegua2(nTotReg)
	//	oBarra:SetRegua2(nTotReg2)

	fVldDirDest(@MV_PAR06)

	cArqSaida	:= MV_PAR06 + 'Empresas.txt'

	AADD(aLayOut , {(014 - 001) + 1 , "C" , 0}) //CNPJ OU CPF DO PRODUTOR
	AADD(aLayOut , {(028 - 015) + 1 , "C" , 0}) // INSCRICAO ESTADUAL (ISENTO SE NAO EXISTIR)
	AADD(aLayOut , {(068 - 029) + 1 , "C" , 0}) // RAZAO SOCIAL DO PRODUTOR
	AADD(aLayOut , {(103 - 069) + 1 , "C" , 0}) // CIDADE DO PRODUTOR
	AADD(aLayOut , {(105 - 104) + 1 , "C" , 0}) // UNIDADE DA FEDERACAO
	AADD(aLayOut , {(106 - 106) + 1 , "C" , 0}) // TIPO [V]arejo [A]tacado ou [G]eral [M]archante [P]rodutor


	cAliasTMP2	:= GetNextAlias()


	cQuery		:= " SELECT DISTINCT CGC, INSCR, NOME, MUN, EST " + CRLF
	cQuery		+= " FROM " + CRLF
	cQuery		+= " ( " + CRLF

	cQuery		+= " SELECT A2_CGC CGC, A2_INSCR INSCR, A2_NOME NOME, A2_MUN MUN, A2_EST EST " + CRLF
	cQuery		+= " FROM " + RetSqlName(cAliasSF1) + " " + cAliasSF1 + ", " + RetSqlName(cAliasSA2) + " " + cAliasSA2 + " " + CRLF

	cQuery		+= " WHERE F1_FORNECE = A2_COD " + CRLF
	cQuery		+= " AND F1_LOJA = A2_LOJA " + CRLF
	cQuery		+= " AND F1_EMISSAO >= '" + DTOS(MV_PAR04) + "' " + CRLF 
	cQuery		+= " AND F1_EMISSAO <= '" + DTOS(MV_PAR05) + "' "  + CRLF
	cQuery		+= " AND SA2.D_E_L_E_T_<>'*'"  + CRLF
	cQuery		+= " AND SF1.D_E_L_E_T_<>'*'"  + CRLF
	cQuery		+= " AND F1_FILIAL = '" + cFilAnt + "' " + CRLF

	cQuery		+= " UNION ALL "	 + CRLF

	cQuery		+= " SELECT A1_CGC CGC, A1_INSCR INSCR, A1_NOME NOME, A1_MUN MUN, A1_EST EST" + CRLF

	cQuery		+= " FROM " + RetSqlName(cAliasSF2) + " " + cAliasSF2 + ", " + RetSqlName(cAliasSA1) + " " + cAliasSA1 + " " + CRLF

	cQuery		+= " WHERE F2_CLIENTE = A1_COD " + CRLF
	cQuery		+= " AND F2_LOJA = A1_LOJA " + CRLF
	cQuery		+= " AND F2_EMISSAO >= '" + DTOS(MV_PAR04) + "' " + CRLF 
	cQuery		+= " AND F2_EMISSAO <= '" + DTOS(MV_PAR05) + "' "  + CRLF
	cQuery		+= " AND SF2.D_E_L_E_T_<>'*' " + CRLF
	cQuery		+= " AND F2_FILIAL = '" + cFilAnt + "' " + CRLF
	cQuery		+= " ) " + CRLF
	
	cQuery		+= " ORDER BY 1,2 "

	//MemoWrite("C:\TEMP\fEmpresas.SQL",cQuery)
	
	
	cAliasTMP2	:= GetNextAlias()

	dbUseArea(.T. , "TOPCONN" , TcGenQry(NIL , NIL , cQuery) , cAliasTMP2 , .F. , .T.)


	Do While (cAliasTMP2)->(!EOF())

		If cChave <> (cAliasTMP2)->(CGC  ) + (cAliasTMP2)->(INSCR )			
			AADD(aDados	,	(cAliasTMP2)->(CGC  ))
			AADD(aDados	,	IIf(Empty((cAliasTMP2)->(INSCR)),'ISENTO',(cAliasTMP2)->(INSCR)))
			AADD(aDados	,	(cAliasTMP2)->(NOME ))
			AADD(aDados	,	(cAliasTMP2)->(MUN  ))
			AADD(aDados	,	(cAliasTMP2)->(EST  ))
			AADD(aDados	,	cTipo		         )

			cChave := (cAliasTMP2)->(CGC  ) + (cAliasTMP2)->(INSCR )

			fGeraLinha(aLayOut , aDados , @cLinha)

			fEscreve(cLinha , @nHandle , cArqSaida)


			oBarra:IncRegua2()

			aDados	:= {}
		EndIf

		(cAliasTMP2)->(dbSkip())

	EndDo

	oBarra:IncRegua2()

	aDados	:= {}

	fClose(nHandle)

Return



/*
=====================================================================================
Programa.:              fArqFolha
Autor....:              Luis Artuso
Data.....:              14/10/16
Descricao / Objetivo:   Gera o arquivo 'Folha.txt'
Doc. Origem:            Contrato - GAP FIS46
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
Static Function fArqFolha(oBarra , MV_PAR06)

	Local cQuery	:= ""
	Local cAliasTMP	:= ""
	Local cArqSaida	:= ""
	Local aLayOut	:= {}
	Local aDados	:= {}
	Local nHandle	:= 0
	Local cLinha	:= ""   
	Local nTotReg   := 0// Flávio

	AADD(aLayOut , {(005 - 001) + 1 , "C" , 0}) //PERIODO DA FOLHA DE PAGAMENTO (MM/AA)
	AADD(aLayOut , {(010 - 006) + 1 , "N" , 0}) // NUMERO DE FUNCIONARIOS NO PERIODO
	AADD(aLayOut , {(025 - 011) + 1 , "N" , 2}) // VALOR DA FOLHA DE PAGAMENTO

	AADD(aDados , MV_PAR01) // PERIODO DA FOLHA DE PAGAMENTO (MM/AA)
	AADD(aDados , MV_PAR02) // NUMERO DE FUNCIONARIOS NO PERIODO
	AADD(aDados , MV_PAR03) // VALOR DA FOLHA DE PAGAMENTO

	cAliasTMP	:= GetNextAlias()

	//fGeraQry(cQuery , @cAliasTMP)

	oBarra:SetRegua2(nTotReg)

	fGeraLinha(aLayOut , aDados , @cLinha)

	fVldDirDest(@MV_PAR06)

	cArqSaida	:= MV_PAR06 + 'Folha.txt'

	fEscreve(cLinha , @nHandle , cArqSaida)

	oBarra:IncRegua2()

	//(cAliasTMP)->(dbCloseArea())

	fClose(nHandle)

Return

Static Function fArqFrig(oBarra , MV_PAR06)

	Local cQuery	:= ""
	Local cFrom		:= ""
	Local cFields	:= ""
	Local cCount	:= ""
	Local cWhere	:= ""
	Local cAliasTMP	:= ""
	Local aLayOut	:= {}
	Local aDados	:= {}
	Local cCod		:= ""
	Local cAliasSB1	:= "SB1"
	Local cAliasSD1	:= "SD1"
	Local cAliasSD2	:= "SD2"
	Local cLinha	:= ""
	Local nHandle	:= 0
	Local cArqSaida	:= ""
	Local nTotReg	:= 0

	cCod		:= "999"

	fVldDirDest(@MV_PAR06)

	cArqSaida	:= MV_PAR06 + 'ProdFrig.txt'
/*
	cQuery		:= "SELECT COUNT(B1_COD) TOTAL "

	cQuery		+= " FROM " + RetSqlname(cAliasSB1) + " " + cAliasSB1 + " , " + RetSqlname(cAliasSD1) + " " + cAliasSD1

	cQuery		+= " WHERE D1_COD = B1_COD "
	cQuery		+= " AND D1_EMISSAO >= '" + DTOS(MV_PAR04) + "' "
	cQuery		+= " AND D1_EMISSAO <= '" + DTOS(MV_PAR05) + "' "
	cQuery		+= " AND SD1.D_E_L_E_T_<>'*'"
	cQuery		+= " AND D1_FILIAL = '" + cFilAnt + "' "

	cQuery		+= " UNION ALL "


	cQuery		:= " SELECT COUNT(B1_COD) TOTAL"

	cQuery		+= " FROM " + RetSqlname(cAliasSB1) + " " + cAliasSB1 +", " + RetSqlname(cAliasSD2) + " " +cAliasSD2

	cQuery		+= " WHERE D2_COD = B1_COD "
	cQuery		+= " AND D2_EMISSAO >= '" + DTOS(MV_PAR04) + "' " 
	cQuery		+= " AND D2_EMISSAO <= '" + DTOS(MV_PAR05) + "' "
	cQuery		+= " AND SD2.D_E_L_E_T_<>'*'"
	cQuery		+= " AND D2_FILIAL = '" + cFilAnt + "' "

	//==================================
	//- Prepara/executa a query para contagem dos registros (Incremento da barra de processamento).
	//	cCount		:= " COUNT(B1_COD) TOTAL "

	//	cQuery		:= cQuery + cCount + cFrom + cWhere

	cAliasTMP	:= GetNextAlias()

	fGeraQry(cQuery , cAliasTMP)

	nTotReg	:= (cAliasTMP)->(TOTAL)

	(cAliasTMP)->(dbCloseArea())

	oBarra:SetRegua2(nTotReg)
*/
	//==================================
	//- Executa a query para montagem dos registros que serao gravados
	cAliasTMP	:= GetNextAlias()


	cQuery		:= " SELECT DISTINCT B1_COD CODIGO, B1_DESC DESCRICAO, B1_ZCODSF " + CRLF
	cQuery		+= " FROM "
	cQuery		+= " ( "
	cQuery		+= " SELECT B1_COD, B1_DESC, B1_ZCODSF " + CRLF
	cQuery		+= " FROM " + RetSqlname(cAliasSB1) + " " + cAliasSB1 + ", " + RetSqlname(cAliasSD1) + " " +cAliasSD1 + " " + CRLF 

	cQuery		+= " WHERE D1_COD = B1_COD " + CRLF
	cQuery		+= " AND D1_EMISSAO >= '" + DTOS(MV_PAR04) + "' " + CRLF 
	cQuery		+= " AND D1_EMISSAO <= '" + DTOS(MV_PAR05) + "' " + CRLF
	cQuery		+= " AND SD1.D_E_L_E_T_<>'*'" + CRLF
	cQuery		+= " AND SB1.D_E_L_E_T_<>'*'" + CRLF
	cQuery		+= " AND B1_ZCODSF <> '99996' " + CRLF
	cQuery		+= " AND D1_FILIAL = '" + cFilAnt + "' " + CRLF

	cQuery		+= " UNION ALL " + CRLF

	cQuery		+= " SELECT B1_COD, B1_DESC, B1_ZCODSF " + CRLF

	cQuery		+= " FROM " + RetSqlname(cAliasSB1) + " " + cAliasSB1 +", " + RetSqlname(cAliasSD2) + " " + cAliasSD2 + " " + CRLF   

	cQuery		+= " WHERE D2_COD = B1_COD " + CRLF
	cQuery		+= " AND D2_EMISSAO >= '" + DTOS(MV_PAR04) + "' " + CRLF
	cQuery		+= " AND D2_EMISSAO <= '" + DTOS(MV_PAR05) + "' " + CRLF
	cQuery		+= " AND SD2.D_E_L_E_T_<>'*'" + CRLF
	cQuery		+= " AND SB1.D_E_L_E_T_<>'*'" + CRLF
	cQuery		+= " AND B1_ZCODSF <> '99996' " + CRLF
	cQuery		+= " AND D2_FILIAL = '" + cFilAnt + "' " + CRLF
	cQuery		+= " ) "
	
	//MemoWrite("C:\TEMP\fProdfrig.SQL",cQuery)

	nTotReg := fGeraQry(cQuery , cAliasTMP)
	
	oBarra:SetRegua2(nTotReg)

	If (cAliasTMP)->(!EOF())

		AADD(aLayOut , {(014 - 001) + 1 , "C" , 0}) //CODIGO DO PRODUTO NO FRIGORIFICO
		AADD(aLayOut , {(054 - 015) + 1 , "C" , 0}) //DESCRICAO DO PRODUTO NO FRIGORIFICO
		AADD(aLayOut , {(068 - 055) + 1 , "C" , 0}) //CODIGO DO PRODUTO NA SECRETARIA (OPCIONAL, PODERA SER INFORMADO DEPOIS NO SISTEMA)

		Do While (cAliasTMP)->(!EOF())

			AADD(aDados , (cAliasTMP)->(CODIGO)	  )
			AADD(aDados , (cAliasTMP)->(DESCRICAO))
			AADD(aDados , (cAliasTMP)->(B1_ZCODSF))

			fGeraLinha(aLayOut , aDados , @cLinha)

			fEscreve(cLinha , @nHandle , cArqSaida)

			oBarra:IncRegua2()

			(cAliasTMP)->(dbSkip())

			aDados	:= {}

		EndDo

	EndIf

	(cAliasTMP)->(dbCloseArea())

	fClose(nHandle)

Return

/*
=====================================================================================
Programa.:              fNotaSent
Autor....:              Luis Artuso
Data.....:              14/10/16
Descricao / Objetivo:   Gera o arquivo 'NotaSent.txt'
Doc. Origem:            Contrato - GAP FIS46
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:				ARQUIVO MESTRE DE NOTAS DE PRODUTOR. Serao selecionadas as notas de entrada associadas as notas de abate no periodo.
As notas de abate (tabela) serao determinadas na integracao com o Taura.
=====================================================================================
*/
Static Function fNotaSent(oBarra , MV_PAR06)

	Local cQuery	:= ""
	Local cFields	:= ""
	Local cFrom		:= ""
	Local cWhere	:= ""
	Local cAliasTMP	:= ""
	Local aLayOut	:= {}
	Local aDados	:= {}
	Local cLinha	:= ""
	Local nHandle	:= 0
	Local cArqSaida	:= ""
	Local cAliasZZM	:= ""
	Local cAliasSA2	:= ""
	Local cAliasSF1	:= ""
	Local cAliasZZQ	:= ""
	Local cAliasZZN	:= ""                         
	Local cGta      := ""
	Local cDoc      := ""  
	Local nTotReg   := 0
	Local cDoci		:= ""
	Local cDocf		:= ""
	fVldDirDest(@MV_PAR06)
	cArqSaida	:= MV_PAR06 + 'NotaSent.txt'

	dbSelectArea("ZZP")
	dbSetOrder(1)


	cAliasZZM	:= "ZZM"
	cAliasSA2	:= "SA2" 
	cAliasSF1	:= "SF1" 
	cAliasZZQ	:= "ZZQ"
	cAliasZZN	:= "ZZN"
/*
	cAliasTMP1	:= GetNextAlias()

	cQuery		:= " SELECT "
	cQuery		+= " ( CASE WHEN ZZN_QTPE = '0'  THEN 'N' ELSE 'S' END) CONDENAS, ZZM_DOC NOTAFISCAL , F1_EMISSAO EMISSAO, A2_CGC DOCUMENTO, 'A' VIVOREND, '100' VALORNF, ZZQ_GTA GTA ,"
	cQuery		+= " '0' NFINICIAL , '0' NFFINAL , 'X' TIPOABATE , A2_INSCR INSCREST "
	cQuery		+= "FROM " + RetSqlName(cAliasZZM) + " " + cAliasZZM + ", " + RetSqlName(cAliasSA2) + " " + cAliasSA2 + ", " + RetSqlName(cAliasSF1) + " " + cAliasSF1
	cQuery		+= + ", " + RetSqlName(cAliasZZQ) + " " + cAliasZZQ + ", " + RetSqlName(cAliasZZN) + " " + cAliasZZN

	cQuery		+= " WHERE ZZM_FORNEC = A2_COD" 
	cQuery		+= " AND ZZM_LOJA = A2_LOJA" 
	cQuery		+= " AND ZZM_DOC = F1_DOC"
	cQuery		+= " AND ZZM_FILIAL = F1_FILIAL"  
	cQuery		+= " AND ZZM_SERIE = F1_SERIE" 
	cQuery		+= " AND ZZM_PEDIDO = ZZQ_PEDIDO"
	cQuery		+= " AND ZZM_FILIAL = ZZQ_FILIAL"  	
	cQuery		+= " AND ZZM_PEDIDO = ZZN_PEDIDO"
	cQuery		+= " AND ZZM_FILIAL = ZZN_FILIAL" 	 		              
	cQuery		+= " AND SF1.F1_EMISSAO >= '" + DTOS(MV_PAR04) + "' " 
	cQuery		+= " AND SF1.F1_EMISSAO <= '" + DTOS(MV_PAR05) + "' " 
	cQuery		+= " AND ZZM.D_E_L_E_T_<>'*' "
	cQuery		+= " AND SA2.D_E_L_E_T_<>'*' "
	cQuery		+= " AND SF1.D_E_L_E_T_<>'*' "	
	cQuery		+= " AND ZZQ.D_E_L_E_T_<>'*' "	
	cQuery		+= " AND ZZN.D_E_L_E_T_<>'*' "
	cQuery		+= " AND F1_FILIAL = '" + cFilAnt + "' "

	cAliasTMP1	:= GetNextAlias()

	dbUseArea(.T. , "TOPCONN" , TcGenQry(NIL , NIL , cQuery) , cAliasTMP1 , .F. , .T.)

	While ( cAliasTMP1 )->(!EOF())

		If cGta <> (cAliasTMP1)->GTA		                  
			If cDoc <>(cAliasTMP1)->NOTAFISCAL

				cGta := (cAliasTMP1)->GTA  
				cDoc := (cAliasTMP1)->NOTAFISCAL

				nTotReg ++ 

			EndIf
		EndIf		

		(cAliasTMP1)->(dbSkip())

	Enddo

	(cAliasTMP1)->(dbCloseArea())

	oBarra:SetRegua2(nTotReg)
*/
	//==================================
	//- Executa a query para montagem dos registros que serao gravados
	cAliasTMP	:= GetNextAlias()

	cQuery		:= " SELECT DISTINCT ZZM_PEDIDO PEDIDO, " + CRLF

	// 30/08/2018 - Atilio	- Alteração de conteúdo de VIVOREND: 'A' ==>> 'R'
	//						- VALORNF: '100' ==>> F1_VALMERC
	//cQuery		+= " ( CASE WHEN ZZN_QTPE = '0'  THEN 'N' ELSE 'S' END) CONDENAS, ZZM_DOC NOTAFISCAL , F1_EMISSAO EMISSAO, A2_CGC DOCUMENTO, 'A' VIVOREND, '100' VALORNF, ZZQ_GTA GTA ,"
	cQuery		+= "  CASE WHEN (Select SUM(ZZN_QTPE)"
	cQuery		+= " 			 From "+RetSqlName(cAliasZZN) + " " + cAliasZZN
	cQuery		+= " 			 Where ZZN.D_E_L_E_T_ = ' ' "
	cQuery		+= " 			 AND ZZN_FILIAL = ZZM_FILIAL  AND ZZN_PEDIDO =ZZM_PEDIDO ) = 0  THEN 'N' ELSE 'S' END  CONDENAS, ZZM_DOC NOTAFISCAL , F1_EMISSAO EMISSAO, A2_CGC DOCUMENTO, " + CRLF
	cQuery		+= " 'R' VIVOREND, F1_VALMERC VALORNF, '0' NFINICIAL , '0' NFFINAL , 'P' TIPOABATE , A2_INSCR INSCREST , " 
	cQuery		+= "            (Select MAX(ZZQ_GTA)"
	cQuery		+= " 			 From "+RetSqlName(cAliasZZQ) + " " + cAliasZZQ
	cQuery		+= " 			 Where ZZQ.D_E_L_E_T_ = ' ' "
	cQuery		+= " 			 AND ZZQ_FILIAL = ZZM_FILIAL  AND ZZQ_PEDIDO =ZZM_PEDIDO ) GTA"

	cQuery		+= "FROM " + RetSqlName(cAliasZZM) + " " + cAliasZZM + ", " + RetSqlName(cAliasSA2) + " " + cAliasSA2 + ", " + RetSqlName(cAliasSF1) + " " + cAliasSF1 + " " + CRLF
	cQuery		+= " WHERE ZZM_FORNEC = A2_COD " + CRLF 
	cQuery		+= " AND ZZM_LOJA = A2_LOJA " + CRLF 
	
	cQuery		+= " AND ZZM_FILIAL = F1_FILIAL" 
	cQuery		+= " AND ZZM_DOC    = F1_DOC" 
	cQuery		+= " AND ZZM_SERIE  = F1_SERIE" 
	cQuery		+= " AND Rtrim(ZZM_FORNEC) = RTrim(F1_FORNECE)" 
	cQuery		+= " AND ZZM_LOJA   = F1_LOJA" 

	cQuery		+= " AND SF1.F1_EMISSAO >= '" + DTOS(MV_PAR04) + "' " + CRLF 
	cQuery		+= " AND SF1.F1_EMISSAO <= '" + DTOS(MV_PAR05) + "' "  + CRLF
	cQuery		+= " AND ZZM.D_E_L_E_T_<>'*' " + CRLF
	cQuery		+= " AND SA2.D_E_L_E_T_<>'*' " + CRLF
	cQuery		+= " AND SF1.D_E_L_E_T_<>'*' " + CRLF
	cQuery		+= " AND F1_FILIAL = '" + cFilAnt + "' " + CRLF
/*
	cQuery		+= " AND F1_DOC || F1_SERIE IN " + CRLF
	cQuery		+= " ( " + CRLF
	cQuery		+= " 	SELECT DISTINCT D1_DOC || D1_SERIE " + CRLF
	cQuery		+= "	FROM " + RetSqlName("SD1") + " SD1 " + CRLF
	cQuery		+= " 	INNER JOIN " + RetSqlName("SB1") + " SB1 ON SB1.D_E_L_E_T_ = ' ' " + CRLF 
	cQuery		+= " 		AND B1_FILIAL = '" + xFilial("SB1") + "' " + CRLF
	cQuery		+= " 		AND B1_COD = D1_COD " + CRLF
	cQuery		+= " 		AND B1_ZCODSF <> '99996' " + CRLF
	cQuery		+= " 	WHERE SD1.D_E_L_E_T_ = ' ' "  + CRLF
	cQuery		+= " 		AND D1_FILIAL = '" + cFilAnt + "' " + CRLF
	cQuery		+= " 		AND D1_EMISSAO BETWEEN '" + DTOS(MV_PAR04) + "' AND '" + DTOS(MV_PAR05) + "' " + CRLF
	cQuery		+= " 		AND D1_CF IN ('1101','1151','1201','1410','2101','2151','2201','2410') " + CRLF
	cQuery		+= " ) " + CRLF
*/

	//MemoWrite("C:\TEMP\fNotaSent.SQL",cQuery)

	//	cQuery		:= cQuery + cFields + cFrom + cWhere

	nTotReg := fGeraQry(cQuery , cAliasTMP)

	oBarra:SetRegua2(nTotReg)


	If ( cAliasTMP )->(!EOF())

		AADD(aLayOut , {(006 - 001) + 1 , "N" , 0}) // NUMERO DA NOTA FISCAL
		AADD(aLayOut , {(014 - 007) + 1 , "C" , 0}) // DATA DE EMISSAO (AAAAMMDD)
		AADD(aLayOut , {(028 - 015) + 1 , "C" , 0}) // CNPJ OU CPF DO PRODUTOR
		AADD(aLayOut , {(029 - 029) + 1 , "C" , 0}) // [V]IVO OU A [R]ENDIMENTO [A]MBOS
		AADD(aLayOut , {(044 - 030) + 1 , "N" , 2}) // VALOR TOTAL DA N.F.
		AADD(aLayOut , {(050 - 045) + 1 , "N" , 0}) // GTA
		AADD(aLayOut , {(056 - 051) + 1 , "C" , 0}) // NUMERO DA NOTA DO PRODUTOR INICIAL
		AADD(aLayOut , {(062 - 057) + 1 , "C" , 0}) // NUMERO DA NOTA DO PRODUTOR FINAL
		AADD(aLayOut , {(063 - 063) + 1 , "C" , 0}) // SE HOUVE CONDENAS [S] OU [N]
		AADD(aLayOut , {(064 - 064) + 1 , "C" , 0}) // [P] SE E ABATE PROPRIO OU [T] SE PARA TERCEIROS
		AADD(aLayOut , {(078 - 065) + 1 , "C" , 0}) // [P] INSCRICAO ESTADUAL DO PRODUTOR
/*
		cDoci := (cAliasTMP)->(NOTAFISCAL)
		cDocf := (cAliasTMP)->(NOTAFISCAL)

		Do While (cAliasTMP)->(!EOF()) 

			If	cDoci > cDocf := (NOTAFISCAL)
				cDoci := (cAliasTMP)->(NOTAFISCAL)		
			ElseIf	cDocf < (cAliasTMP)->(NOTAFISCAL)
				cDocf := (cAliasTMP)->(NOTAFISCAL)		
			EndIf                                     

			(cAliasTMP)->(dbSkip())

		EndDo  
*/
		
		(cAliasTMP)->(dbgotop())
		Do While (cAliasTMP)->(!EOF())  

			If ZZP->( dbSeek( xFilial("ZZP") + (cAliasTMP)->PEDIDO   ) )
				cDoci := cDocf := ZZP->ZZP_DOC
				While !ZZP->( eof() ) .And. ZZP->(ZZP_FILIAL+ZZP_PEDIDO) == xFilial("ZZP") + (cAliasTMP)->PEDIDO 
				
					If	cDoci > Right(AllTrim(ZZP->ZZP_DOC),6)
						cDoci := Right(AllTrim(ZZP->ZZP_DOC),6)		
					ElseIf	cDocf < Right(AllTrim(ZZP->ZZP_DOC),6)
						cDocf := Right(AllTrim(ZZP->ZZP_DOC),6)		
					EndIf                                     
		
					ZZP->( dbSkip() )
				EndDo
			Else
				cDoci := cDocf := "000000"
			EndIf

			AADD(aDados , (cAliasTMP)->(NOTAFISCAL)	 )
			AADD(aDados , (cAliasTMP)->(EMISSAO)	 )
			AADD(aDados , (cAliasTMP)->(DOCUMENTO)	 )
			AADD(aDados , (cAliasTMP)->(VIVOREND)	 )
			AADD(aDados , (cAliasTMP)->(VALORNF)	 )
			AADD(aDados , RIGHT(ALLTRIM((cAliasTMP)->(GTA)),6)) 
			AADD(aDados , cDoci						 )
			AADD(aDados , cDocf						 )
			AADD(aDados , (cAliasTMP)->(CONDENAS)	 )
			AADD(aDados , (cAliasTMP)->(TIPOABATE)	 )
			AADD(aDados , (cAliasTMP)->(INSCREST)	 )

			fGeraLinha(aLayOut , aDados , @cLinha)

			fEscreve(cLinha , @nHandle , cArqSaida)

			aDados	:= {}

			(cAliasTMP)->(dbSkip())

		EndDo

	EndIf

	(cAliasTMP)->(dbCloseArea())

	fClose(nHandle)

Return

/*
=====================================================================================
Programa.:              fNotaSen1
Autor....:              Luis Artuso
Data.....:              14/10/16
Descricao / Objetivo:   Gera o arquivo 'NotaSen1.txt'
Doc. Origem:            Contrato - GAP FIS46
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:				ARQUIVO DETALHE DE NOTAS DE PRODUTOR
=====================================================================================
*/
Static Function fNotaSen1(oBarra , MV_PAR06)

	Local cAliasTMP	:= ""
	Local aLayOut	:= {}
	Local aDados	:= {}
	Local cQuery	:= ""
	Local cFrom		:= ""
	Local cFields	:= ""
	Local cWhere	:= ""
	Local cAliasSD1	:= "SD1"
	Local cAliasSA2	:= "SA2"	
	Local cAliasZZM	:= "ZZM"		
	Local cAliasZZN	:= "ZZN"			
	Local cLinha	:= ""
	Local nHandle	:= 0
	Local cArqSaida	:= ""

	fVldDirDest(@MV_PAR06)

	cArqSaida	:= MV_PAR06 + 'NotaSen1.txt'

	cAliasTMP	:= GetNextAlias()

	cAliasSD1	:= "SD1"

	cQuery		:= "SELECT " + CRLF

	// 30/08/2018 - Atilio 	- PESOCARCACA: ZZN_QTKG (PESOVIVO)
	//						- REND_VIVO: 'V'  ==>> 'R' 
	//cQuery		+= "D1_DOC NOTAFISCAL , D1_EMISSAO EMISSAO, A2_CGC DOCUMENTO, D1_COD CODPROD, ZZN_QTCAB QTDCABECAS, ZZN_QTKG PESOVIVO, '0' PESOCARCACA, '0' PCQUILO, "
	cQuery		+= "D1_DOC NOTAFISCAL , D1_EMISSAO EMISSAO, A2_CGC DOCUMENTO, D1_COD CODPROD, D1_QUANT QTDCABECAS, " + CRLF
	cQuery		+= "0 PESOCARCACA, '0' PCQUILO, "
	//cQuery		+= " D1_ITEM NRITEM, A2_INSCR INSCREST, ZZM_EMISSA DTABATE, 'V' REND_VIVO, D1_CF CFOP, D1_PICM ALIQUOTA, D1_TOTAL TOTAL "
	cQuery		+= " D1_ITEM NRITEM, A2_INSCR INSCREST, D1_EMISSAO DTABATE, 'R' REND_VIVO, D1_CF CFOP, D1_PICM ALIQUOTA, D1_TOTAL TOTAL , "
	cQuery		+= "             (Select SUM(ZZN_QTKG)"
	cQuery		+= " 			 From "+RetSqlName(cAliasZZN) + " " + cAliasZZN
	cQuery		+= " 			 Where ZZN.D_E_L_E_T_ = ' ' "
	cQuery		+= " 			 AND ZZN_FILIAL = ZZM_FILIAL  AND ZZN_PEDIDO =ZZM_PEDIDO ) PESOVIVO " //1.47 * 

	cQuery		+= "FROM " + RetSqlName(cAliasSD1) + " " + cAliasSD1 + ", "+ RetSqlName(cAliasSA2) + " " + cAliasSA2 + ", "+ RetSqlName(cAliasZZM) + " " + cAliasZZM 
/*
	cQuery		+= " 	INNER JOIN " + RetSqlName("SB1") + " SB1 ON SB1.D_E_L_E_T_ = ' ' " 
	cQuery		+= " 		AND B1_FILIAL = '" + xFilial("SB1") + "' "
	cQuery		+= " 		AND B1_COD = D1_COD "
	cQuery		+= " 		AND B1_ZCODSF <> '99996' "
*/
	cQuery		+= " WHERE SD1.D_E_L_E_T_ <> '*' " + CRLF
	cQuery		+= " AND D1_FILIAL = '" + cFilAnt + "' " + CRLF
	cQuery		+= " AND D1_EMISSAO >= '" + DTOS(MV_PAR04) + "' " + CRLF
	cQuery		+= " AND D1_EMISSAO <= '" + DTOS(MV_PAR05) + "' " + CRLF 
	cQuery		+= " AND ZZM.D_E_L_E_T_<>'*' " + CRLF
	cQuery		+= " AND ZZM_FILIAL = D1_FILIAL " + CRLF	                          
	cQuery		+= " AND ZZM_DOC = D1_DOC " + CRLF	                          
	cQuery		+= " AND ZZM_SERIE = D1_SERIE " + CRLF		
	cQuery		+= " AND ZZM_FORNEC = D1_FORNECE " + CRLF	                          
	cQuery		+= " AND ZZM_LOJA = D1_LOJA " + CRLF		

	//cQuery		+= " AND ZZN.D_E_L_E_T_<>'*' " + CRLF	
	//cQuery		+= " AND ZZN_PEDIDO = ZZM_PEDIDO " + CRLF			
	//cQuery		+= " AND ZZN_ITEM = SUBSTR(D1_ITEM,3,2) " + CRLF			
	//cQuery		+= " AND ZZN_PRODUT = D1_COD " + CRLF			

	cQuery		+= " AND SA2.D_E_L_E_T_<>'*' " + CRLF	
	cQuery		+= " AND A2_COD = D1_FORNECE " + CRLF
	cQuery		+= " AND A2_LOJA = D1_LOJA " + CRLF	                          

//	cQuery		+= " AND D1_CF IN ('1101','1151','1201','1410','2101','2151','2201','2410') "

	//MemoWrite("C:\TEMP\fNotaSen1.SQL",cQuery)
	//	cQuery		+= cFields + cFrom + cWhere

	fGeraQry(cQuery , @cAliasTMP)

	If (cAliasTMP)->(!EOF())

		AADD(aLayOut , {(006 - 001) + 1 , "C" , 0}) //NUMERO DA NOTA FISCAL
		AADD(aLayOut , {(014 - 007) + 1 , "D" , 0}) //EMISSAO DA NOTA FISCAL (AAAAMMDD)
		AADD(aLayOut , {(028 - 015) + 1 , "C" , 0}) //CNPJ OU CPF DO PRODUTOR
		AADD(aLayOut , {(042 - 029) + 1 , "C" , 0}) //CODIGO DO PRODUTO UTILIZADO NO FRIGORIFICO
		AADD(aLayOut , {(047 - 043) + 1 , "N" , 0}) //QUANTIDADE DE CABECAS
		AADD(aLayOut , {(062 - 048) + 1 , "N" , 3}) //PESO VIVO DE CABECAS - SEPARADO POR PONTOS (3 CASAS DECIMAIS)
		AADD(aLayOut , {(077 - 063) + 1 , "N" , 3}) //PESO DAS CABECAS - SEPARADO POR PONTOS (3 CASAS DECIMAIS)
		AADD(aLayOut , {(092 - 078) + 1 , "N" , 2}) //PRECO POR QUILO - SEPARADO POR PONTOS (2 CASAS DECIMAIS)
		AADD(aLayOut , {(095 - 093) + 1 , "N" , 0}) //NUMERO DO ITEM NA NOTA FISCAL
		AADD(aLayOut , {(109 - 096) + 1 , "C" , 0}) //INSCRICAO ESTADUAL
		AADD(aLayOut , {(117 - 110) + 1 , "D" , 0}) //DATA DO ABATE
		AADD(aLayOut , {(118 - 118) + 1 , "C" , 0}) //[R]ENDIMENTO [V]IVO
		AADD(aLayOut , {(122 - 119) + 1 , "C" , 0}) //CFOP (CODIGO FISCAL) (*)
		AADD(aLayOut , {(128 - 123) + 1 , "N" , 2}) //ALIQUOTA DE ICMS (*)
		//(*)OPCIONAL (PARA FRIGORIFICOS QUE TENHAM OPERACOES INTERESTADUAIS, COMPRAS/VENDAS)

		Do While (cAliasTMP)->(!EOF())

			AADD(aDados , RIGHT(ALLTRIM((cAliasTMP)->(NOTAFISCAL)),6	))
			AADD(aDados , (cAliasTMP)->(EMISSAO)		)
			AADD(aDados , (cAliasTMP)->(DOCUMENTO)		)
			AADD(aDados , (cAliasTMP)->(CODPROD)		)
			AADD(aDados , (cAliasTMP)->(QTDCABECAS)	)
			AADD(aDados , (cAliasTMP)->(PESOVIVO)* 1.47		)
			AADD(aDados , (cAliasTMP)->(PESOVIVO)	)
			AADD(aDados , (cAliasTMP)->(TOTAL) / ((cAliasTMP)->(PESOVIVO)*1.47) )
			AADD(aDados , (cAliasTMP)->(NRITEM)		)
			AADD(aDados , (cAliasTMP)->(INSCREST)		)
			AADD(aDados , (cAliasTMP)->(DTABATE)		)
			AADD(aDados , (cAliasTMP)->(REND_VIVO)		)
			AADD(aDados , (cAliasTMP)->(CFOP)			)
			AADD(aDados , (cAliasTMP)->(ALIQUOTA)		)

			fGeraLinha(aLayOut , aDados , @cLinha)

			fEscreve(cLinha , @nHandle , cArqSaida)

			aDados	:= {}

			(cAliasTMP)->(dbSkip())

		EndDo

	EndIf

	(cAliasTMP)->(dbCloseArea())

	fClose(nHandle)

Return

/*
=====================================================================================
Programa.:              fCondenas
Autor....:              Luis Artuso
Data.....:              14/10/16
Descricao / Objetivo:   Gera o arquivo 'Condenas.txt'
Doc. Origem:            Contrato - GAP FIS46
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
Static Function fCondenas(oBarra , MV_PAR06)

	Local cQuery	:= ""
	Local cFrom		:= ""
	Local cFields	:= ""
	Local cWhere	:= ""
	Local cAliasTMP	:= "" 
	Local cAliasTMP1:= "" 
	Local cAliasSF1 := "SF1"
	Local cAliasSA2 := "SA2"	
	Local cAliasZZM := "ZZM"		
	Local cAliasZZN := "ZZN"			
	Local aLayOut	:= {}
	Local aDados	:= {}
	Local nHandle	:= 0
	Local cLinha	:= 0
	Local cArqSaida	:= ""

	fVldDirDest(@MV_PAR06)

	cArqSaida	:= MV_PAR06 + 'Condenas.txt'
	
	// 31/08/2018 - Atilio - Gerar arquivo vazio, não é necessário gerar informação. 
	nHandle	:= fCreate(cArqSaida)
	
	fClose(nHandle)
/*	
	cAliasTMP	:= GetNextAlias()


	cQuery := "SELECT DISTINCT F1_DOC  NOTAFISCAL, F1_SERIE  SERIE, F1_EMISSAO  EMISSAO, A2_CGC  DOCUMENTO, '0'   COD_CONDENA,  A2_INSCR  INSCREST "

	cQuery += " FROM " + RetSqlName(cAliasSF1) + " " + cAliasSF1 + ", " + RetSqlName(cAliasSA2) + " " + cAliasSA2 + ", "  + RetSqlName(cAliasZZM) + " "	+ cAliasZZM + ", "  + RetSqlName(cAliasZZN) + " " + cAliasZZN  

	cQuery += " WHERE F1_FORNECE = A2_COD "
	cQuery += "	AND F1_LOJA = A2_LOJA "
	cQuery += " AND ZZM_FILIAL = F1_FILIAL "	
	cQuery += " AND ZZM_DOC = F1_DOC "	
	cQuery += " AND ZZM_SERIE = F1_SERIE "
	cQuery += " AND ZZM_FILIAL = ZZN_FILIAL
	cQuery += " AND ZZM_PEDIDO = ZZN_PEDIDO
	cQuery += " AND F1_EMISSAO >= '" + DTOS(MV_PAR04) + "' " 
	cQuery += " AND F1_EMISSAO <= '" + DTOS(MV_PAR05) + "' " 
	cQuery += " AND SF1.D_E_L_E_T_ <> '*' "
	cQuery += " AND F1_FILIAL = '" + cFilAnt + "' "

	fGeraQry(cQuery , cAliasTMP)

	If (cAliasTMP)->(!EOF())

		AADD(aLayOut , {(006 - 001) + 1 , "N" , 0 }) // NUMERO DA NOTA FISCAL
		AADD(aLayOut , {(014 - 007) + 1 , "D" , 0 }) // DATA DE EMISSAO DA NF (AAAAMMDD)
		AADD(aLayOut , {(028 - 015) + 1 , "C" , 0 }) // CNPJ OU CPF DO PRODUTOR
		AADD(aLayOut , {(030 - 029) + 1 , "N" , 0 }) // CODIGO DO TIPO DE CONDENA
		AADD(aLayOut , {(035 - 031) + 1 , "N" , 0 }) // QUANTIDADE DE CONDENAS
		AADD(aLayOut , {(049 - 036) + 1 , "N" , 0 }) // INSCRICAO ESTADUAL DO PRODUTOR

		Do While (cAliasTMP)->(!EOF())

			cAliasTMP1	:= GetNextAlias()                     

			cQuery := "SELECT SUM(ZZN_QTPE) QTDECONDENA "

			cQuery += " FROM " + RetSqlName(cAliasSF1) + " " + cAliasSF1 + ", " + RetSqlName(cAliasSA2) + " " + cAliasSA2 + ", "  + RetSqlName(cAliasZZM) + " ";
			+ cAliasZZM + ", "  + RetSqlName(cAliasZZN) + " " + cAliasZZN  

			cQuery += " WHERE F1_FORNECE = A2_COD "
			cQuery += "	AND F1_LOJA = A2_LOJA "
			cQuery += " AND ZZM_FILIAL = F1_FILIAL "	
			cQuery += " AND ZZM_DOC = F1_DOC "	
			cQuery += " AND ZZM_SERIE = F1_SERIE "
			cQuery += " AND ZZM_FILIAL = ZZN_FILIAL
			cQuery += " AND ZZM_PEDIDO = ZZN_PEDIDO
			cQuery += " AND F1_EMISSAO >= '" + DTOS(MV_PAR04) + "' " 
			cQuery += " AND F1_EMISSAO <= '" + DTOS(MV_PAR05) + "' " 
			cQuery += " AND ZZM_DOC = '" + (cAliasTMP)->(NOTAFISCAL) + "' " 
			cQuery += " AND ZZM_SERIE	= '" + (cAliasTMP)->(SERIE) + "' " 
			cQuery += " AND SF1.D_E_L_E_T_ <> '*' "
			cQuery += " AND F1_FILIAL = '" + cFilAnt + "' "

			fGeraQry(cQuery , cAliasTMP1)


			AADD(aDados , RIGHT(ALLTRIM((cAliasTMP)->(NOTAFISCAL)),6	))
			AADD(aDados , (cAliasTMP)->(EMISSAO)		)
			AADD(aDados , (cAliasTMP)->(DOCUMENTO)		)
			AADD(aDados , (cAliasTMP)->(COD_CONDENA)	)
			AADD(aDados , (cAliasTMP1)->(QTDECONDENA)	)
			AADD(aDados , (cAliasTMP)->(INSCREST)		)

			fGeraLinha(aLayOut , aDados ,  @cLinha)

			fEscreve(cLinha , @nHandle , cArqSaida)

			aDados	:= {}   

			(cAliasTMP1)->(dbCloseArea())

			(cAliasTMP)->(dbSkip())

		EndDo

	EndIf

	(cAliasTMP)->(dbCloseArea())

	fClose(nHandle)
*/
Return

/*
=====================================================================================
Programa.:              fArqGTA
Autor....:              Luis Artuso
Data.....:              14/10/16
Descricao / Objetivo:   Gera o arquivo 'GTA.txt'
Doc. Origem:            Contrato - GAP FIS46
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:				ARQUIVO DE INFORMACOES SOBRE A IDADE DOS ANIMAIS
=====================================================================================
*/
Static Function fArqGTA(oBarra , MV_PAR06)

	Local cQuery	:= ""
	Local cFrom		:= ""
	Local cFields	:= ""
	Local cWhere	:= ""
	Local cAliasTMP	:= ""
	Local cAliasTMP1:= ""	
	Local cAliasTMP2:= ""	
	Local cAliasTMP3:= ""	
	Local cAliasTMP4:= ""	
	Local cAliasTMP5:= ""	
	Local cAliasTMP6:= ""	
	Local cAliasTMP7:= ""				
	Local cAliasTMP8:= ""				
	Local cAliasTMP9:= ""				
	Local cAliasTMP10:= ""				

	Local cAliasSF1	:= "SF1"
	Local cAliasSA2	:= "SA2"	
	Local cAliasZZQ	:= "ZZQ"		
	Local cAliasZZM	:= "ZZM"		
	Local cAliasSD1	:= "SD1"
	Local cAliasSB1 := "SB1"			
	Local aLayOut	:= {}
	Local aDados	:= {}
	Local nHandle	:= 0
	Local cLinha	:= ""
	Local cArqSaida	:= ""

	fVldDirDest(@MV_PAR06)

	cArqSaida	:= MV_PAR06 + 'GTA.txt'

	cAliasTMP	:= GetNextAlias()

	cQuery := "SELECT DISTINCT F1_DOC NOTAFISCAL, F1_EMISSAO EMISSAO, A2_CGC DOCUMENTO, ZZQ_GTA NRGTA, D1_COD PRODUTO, A2_INSCR INSCREST, 'BOVINOS   ' ESPECIE, F1_FORNECE FORNECEDOR, F1_LOJA LOJA, B1_ZAGREGA AGREGA"

	cQuery += " FROM " + RetSqlName(cAliasSF1) + " " + cAliasSF1 + ", " + RetSqlName(cAliasSA2) + " " + cAliasSA2 + ", " + RetSqlName(cAliasZZQ) + " " +;
	cAliasZZQ + ", " + RetSqlName(cAliasZZM) + " " + cAliasZZM + ", " + RetSqlName(cAliasSD1) + " " + cAliasSD1 + ", " + RetSqlName(cAliasSB1) + " " + cAliasSB1

	cQuery += " WHERE F1_FILIAL = D1_FILIAL "
	cQuery += " AND D1_DOC = F1_DOC "
	cQuery += " AND D1_SERIE = F1_SERIE "
	cQuery += " AND D1_FORNECE = F1_FORNECE "
	cQuery += " AND D1_LOJA = F1_LOJA "
	cQuery += " AND F1_FORNECE = A2_COD "
	cQuery += " AND F1_LOJA = A2_LOJA "
	cQuery += " AND ZZM_FILIAL = F1_FILIAL "
	cQuery += " AND ZZM_DOC = F1_DOC "
	cQuery += " AND ZZM_SERIE = F1_SERIE "
	cQuery += " AND ZZM_FILIAL = ZZQ_FILIAL"
	cQuery += " AND ZZM_PEDIDO = ZZQ_PEDIDO"
	CQuery += " AND D1_COD = B1_COD "
	cQuery += " AND F1_EMISSAO >= '" + DTOS(MV_PAR04) + "' " 
	cQuery += " AND F1_EMISSAO <= '" + DTOS(MV_PAR05) + "' " 
	cQuery += " AND SF1.D_E_L_E_T_<>'*' "
	cQuery += " AND SA2.D_E_L_E_T_<>'*' "
	cQuery += " AND ZZQ.D_E_L_E_T_<>'*' "
	cQuery += " AND ZZM.D_E_L_E_T_<>'*' "
	cQuery += " AND SD1.D_E_L_E_T_<>'*' "
	cQuery += " AND F1_FILIAL = '" + cFilAnt + "' "




	//	cQuery += " AND ZZM_DOC = '" + (cAliasTMP)->(NOTAFISCAL) + "' " 
	//	cQuery += " AND ZZM_SERIE	= '" + (cAliasTMP)->(SERIE) + "' " 				


	fGeraQry(cQuery , @cAliasTMP)

	If (cAliasTMP)->(!EOF())

		AADD(aLayOut , { (006 - 001) + 1 , "N" , 0}) //NUMERO DA NOTA FISCAL
		AADD(aLayOut , { (014 - 007) + 1 , "D" , 0}) //DATA DE EMISSAO DA NF (AAAAMMDD)
		AADD(aLayOut , { (028 - 015) + 1 , "C" , 0}) //CNPJ OU CPF DO PRODUTOR
		AADD(aLayOut , { (034 - 029) + 1 , "N" , 0}) //NUMERO DO GTA
		AADD(aLayOut , { (048 - 035) + 1 , "C" , 0}) //INSCRICAO ESTADUAL DO PRODUTOR
		AADD(aLayOut , { (058 - 049) + 1 , "C" , 0}) //ESPECIE (BOVINOS, BUBALINOS OU OVINOS)
		AADD(aLayOut , { (063 - 059) + 1 , "N" , 0}) //QUANTIDADE DE ANIMAIS MACHOS - IDADE ATE 4 MESES
		AADD(aLayOut , { (068 - 064) + 1 , "N" , 0}) //QUANTIDADE DE ANIMAIS FEMEAS - IDADE ATE 4 MESES
		AADD(aLayOut , { (073 - 069) + 1 , "N" , 0}) //QUANTIDADE DE ANIMAIS MACHOS DE 4 A 12 MESES
		AADD(aLayOut , { (078 - 074) + 1 , "N" , 0}) //QUANTIDADE DE ANIMAIS FEMEAS DE 4 A 12 MESES
		AADD(aLayOut , { (083 - 079) + 1 , "N" , 0}) //QUANTIDADE DE ANIMAIS MACHOS DE 12 A 24 MESES
		AADD(aLayOut , { (088 - 084) + 1 , "N" , 0}) //QUANTIDADE DE ANIMAIS FEMEAS DE 12 A 24 MESES
		AADD(aLayOut , { (093 - 089) + 1 , "N" , 0}) //QUANTIDADE DE ANIMAIS MACHOS DE 24 A 36 MESES
		AADD(aLayOut , { (098 - 094) + 1 , "N" , 0}) //QUANTIDADE DE ANIMAIS FEMEAS DE 24 A 36 MESES
		AADD(aLayOut , { (103 - 099) + 1 , "N" , 0}) //QUANTIDADE DE ANIMAIS MACHOS ACIMA DE 36 MESES
		AADD(aLayOut , { (108 - 104) + 1 , "N" , 0}) //QUANTIDADE DE ANIMAIS FEMEAS ACIMA DE 36 MESES
		AADD(aLayOut , { (109 - 109) + 1 , "C" , 0}) //ESPACO EM BRANCO 

		cAliasTMP1	:= GetNextAlias()

		Do While (cAliasTMP)->(!EOF())

			AADD(aDados	,	RIGHT(ALLTRIM((cAliasTMP)->(NOTAFISCAL)),6	))
			AADD(aDados ,	(cAliasTMP)->(EMISSAO)						 )
			AADD(aDados ,	(cAliasTMP)->(DOCUMENTO)					 )
			AADD(aDados ,	RIGHT(ALLTRIM((cAliasTMP)->(NRGTA)),6       ))
			AADD(aDados ,	(cAliasTMP)->(INSCREST)						 )
			AADD(aDados ,	(cAliasTMP)->(ESPECIE)					     )

			cQuery := "SELECT SUM(D1_QUANT)QTD"

			cQuery += " FROM " + RetSqlName(cAliasSF1) + " " + cAliasSF1 + ", " + RetSqlName(cAliasSA2) + " " + cAliasSA2 + ", " + RetSqlName(cAliasZZQ) + " " +;
			cAliasZZQ + ", " + RetSqlName(cAliasZZM) + " " + cAliasZZM + ", " + RetSqlName(cAliasSD1) + " " + cAliasSD1

			cQuery += " WHERE F1_FORNECE = A2_COD "
			cQuery += " AND F1_LOJA = A2_LOJA "
			cQuery += " AND ZZM_FILIAL = F1_FILIAL "	
			cQuery += " AND ZZM_DOC = F1_DOC "	
			cQuery += " AND ZZM_SERIE = F1_SERIE "
			cQuery += " AND D1_FILIAL = F1_FILIAL "	
			cQuery += " AND D1_DOC = F1_DOC "
			cQuery += " AND D1_SERIE = F1_SERIE "
			cQuery += " AND D1_FORNECE = F1_FORNECE "
			cQuery += " AND D1_LOJA = F1_LOJA "
			cQuery += " AND ZZM_FILIAL = ZZQ_FILIAL "
			cQuery += " AND ZZM_PEDIDO = ZZQ_PEDIDO "
			cQuery += " AND F1_FORNECE = '" + (cAliasTMP)->(FORNECEDOR) + "' " 
			cQuery += " AND F1_LOJA = '" + (cAliasTMP)->(LOJA) + "' " 
			cQuery += " AND D1_COD = '" + (cAliasTMP)->(PRODUTO) + "' " 
			cQuery += " AND F1_EMISSAO >= '" + DTOS(MV_PAR04) + "' " 
			cQuery += " AND F1_EMISSAO <= '" + DTOS(MV_PAR05) + "' " 
			cQuery += " AND F1_FILIAL = '" + cFilAnt + "' "
			cQuery += " AND SF1.D_E_L_E_T_<>'*' "
			cQuery += " AND SA2.D_E_L_E_T_<>'*' "
			cQuery += " AND ZZQ.D_E_L_E_T_<>'*' "
			cQuery += " AND ZZM.D_E_L_E_T_<>'*' "
			cQuery += " AND SD1.D_E_L_E_T_<>'*' "				 

			fGeraQry(cQuery , @cAliasTMP1)


			//M04 Animal macho até 4 meses
			AADD(aDados,IIF((cAliasTMP)->AGREGA = 'M04',(cAliasTMP1)->QTD,0))


			//F04 Animal femea até 4 meses	
			AADD(aDados,IIF((cAliasTMP)->AGREGA = 'F04',(cAliasTMP1)->QTD,0))

			//M12 Animal macho até 12 meses				
			AADD(aDados,IIF((cAliasTMP)->AGREGA = 'M12',(cAliasTMP1)->QTD,0))

			//F12 Animal femea até 12 meses				
			AADD(aDados,IIF((cAliasTMP)->AGREGA = 'F12',(cAliasTMP1)->QTD,0))

			//M24 Animal macho até 24 meses				
			AADD(aDados,IIF((cAliasTMP)->AGREGA = 'M24',(cAliasTMP1)->QTD,0))

			//F24 Animal femea até 24 meses	
			AADD(aDados,IIF((cAliasTMP)->AGREGA = 'F24',(cAliasTMP1)->QTD,0))

			//M36 Animal macho até 36 meses	
			AADD(aDados,IIF((cAliasTMP)->AGREGA = 'M36',(cAliasTMP1)->QTD,0))

			//F36 Animal femea até 36 meses	
			AADD(aDados,IIF((cAliasTMP)->AGREGA = 'F36',(cAliasTMP1)->QTD,0))	

			//MXX Animal macho acima de 36 meses	
			AADD(aDados,IIF((cAliasTMP)->AGREGA = 'MXX',(cAliasTMP1)->QTD,0))

			//FXX Animal femea acima de 36 meses	
			AADD(aDados,IIF((cAliasTMP)->AGREGA = 'FXX',(cAliasTMP1)->QTD,0))

			(cAliasTMP1)->(dbCloseArea())

			AADD(aDados ,	" "	)

			fGeraLinha(aLayOut , aDados , @cLinha)

			fEscreve(cLinha , @nHandle , cArqSaida)

			(cAliasTMP)->(dbSkip())

			aDados	:= {}

		EndDo

	EndIf

	(cAliasTMP)->(dbCloseArea())

	fClose(nHandle)

Return

/*
=====================================================================================
Programa.:              fNotaSAI
Autor....:              Luis Artuso
Data.....:              14/10/16
Descricao / Objetivo:   Gera o arquivo 'NotasSai.txt'
Doc. Origem:            Contrato - GAP FIS46
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:				ARQUIVO MESTRE DE NOTAS DE ENTRADA OU SAIDA (CABECALHO)
=====================================================================================
*/
Static Function fNotaSAI(oBarra , MV_PAR06)

	Local cQuery	:= ""
	Local cFrom		:= ""
	Local cFields	:= ""
	Local cWhere	:= ""
	Local cAliasTMP	:= "" 
	Local cAliasSD1 := "SD1"
	Local cAliasSD2 := "SD2"
	local cAliasSF1 := "SF1"
	local cAliasSF2 := "SF2"
	local cAliasSA1 := "SA1"
	local cAliasSA2 := "SA2"	
	Local aLayOut	:= {}
	Local aDados	:= {}
	Local nHandle	:= 0
	Local cLinha	:= 0
	Local cArqSaida	:= ""

	fVldDirDest(@MV_PAR06)

	cArqSaida	:= MV_PAR06 + 'NotasSai.txt'

	cAliasTMP	:= GetNextAlias()


	cQuery		:= " SELECT DISTINCT F1_DOC NOTAFISCAL, F1_EMISSAO EMISSAO, A2_CGC DOCUMENTO, F1_VALBRUT VALORNF, F1_VALICM ICMSNORMAL, F1_ICMSRET ICMSSUBSTIT, 'E' TIPO, A2_INSCR INSCREST, D1_CF CFOP " + CRLF

	cQuery		+= " FROM " + RetSqlName(cAliasSF1) + " " + cAliasSF1 + ", " + RetSqlName(cAliasSA2) + " " + cAliasSA2 + ", " + RetSqlName(cAliasSD1) + " " + cAliasSD1 + " " + CRLF

	cQuery		+= " WHERE F1_FORNECE = A2_COD " + CRLF
	cQuery		+= " AND F1_LOJA = A2_LOJA " + CRLF
	cQuery		+= " AND F1_DOC = D1_DOC " + CRLF
	cQuery		+= " AND F1_FILIAL = D1_FILIAL " + CRLF  	
	cQuery		+= " AND F1_SERIE = D1_SERIE " + CRLF
	cQuery		+= " AND F1_FORNECE = D1_FORNECE " + CRLF
	cQuery		+= " AND F1_LOJA = D1_LOJA " + CRLF 	
	cQuery		+= " AND F1_EMISSAO >= '" + DTOS(MV_PAR04) + "' " + CRLF 
	cQuery		+= " AND F1_EMISSAO <= '" + DTOS(MV_PAR05) + "' " + CRLF
	cQuery		+= " AND SF1.D_E_L_E_T_<>'*' " + CRLF
	cQuery		+= " AND SA2.D_E_L_E_T_<>'*' " + CRLF
	cQuery		+= " AND SD1.D_E_L_E_T_<>'*' " + CRLF	
	cQuery		+= " AND F1_FILIAL = '" + cFilAnt + "' " + CRLF
	cQuery		+= " AND F1_DOC || F1_SERIE IN " + CRLF
	cQuery		+= " ( " + CRLF
	cQuery		+= " 	SELECT DISTINCT D1_DOC || D1_SERIE " + CRLF
	cQuery		+= "	FROM " + RetSqlName("SD1") + " SD1 " + CRLF
	cQuery		+= " 	INNER JOIN " + RetSqlName("SB1") + " SB1 ON SB1.D_E_L_E_T_ = ' ' " + CRLF 
	cQuery		+= " 		AND B1_FILIAL = '" + xFilial("SB1") + "' " + CRLF
	cQuery		+= " 		AND B1_COD = D1_COD " + CRLF
	cQuery		+= " 		AND B1_ZCODSF <> '99996' " + CRLF
	cQuery		+= " 	WHERE SD1.D_E_L_E_T_ = ' ' " + CRLF 
	cQuery		+= " 		AND D1_FILIAL = '" + cFilAnt + "' " + CRLF
	cQuery		+= " 		AND D1_EMISSAO BETWEEN '" + DTOS(MV_PAR04) + "' AND '" + DTOS(MV_PAR05) + "' " + CRLF
	cQuery		+= " 		AND D1_CF IN ('1101','1151','1201','1410','2101','2151','2201','2410') " + CRLF
	cQuery		+= " ) " + CRLF

	cQuery		+= " UNION ALL " + CRLF

	cQuery		+= " SELECT DISTINCT F2_DOC NOTAFISCAL, F2_EMISSAO EMISSAO, A1_CGC DOCUMENTO, F2_VALBRUT VALORNF, F2_VALICM ICMSNORMAL, F2_ICMSRET ICMSSUBSTIT, 'S' TIPO, A1_INSCR INSCREST, D2_CF CFOP " + CRLF

	cQuery		+= " FROM " + RetSqlName(cAliasSF2) + " " + cAliasSF2 + ", " + RetSqlName(cAliasSA1) + " " + cAliasSA1 + ", " + RetSqlName(cAliasSD2) + " " + cAliasSD2 + " " + CRLF

	cQuery		+= " WHERE F2_CLIENTE = A1_COD " + CRLF
	cQuery		+= " AND F2_LOJA = A1_LOJA " + CRLF
	cQuery		+= " AND F2_DOC = D2_DOC " + CRLF 	
	cQuery		+= " AND F2_SERIE = D2_SERIE " + CRLF
	cQuery		+= " AND F2_CLIENTE = D2_CLIENTE " + CRLF
	cQuery		+= " AND F2_LOJA = D2_LOJA " + CRLF
	cQuery		+= " AND F2_FILIAL = D2_FILIAL " + CRLF  	
	cQuery		+= " AND F2_EMISSAO >= '" + DTOS(MV_PAR04) + "' " + CRLF 
	cQuery		+= " AND F2_EMISSAO <= '" + DTOS(MV_PAR05) + "' " + CRLF
	cQuery		+= " AND SF2.D_E_L_E_T_<>'*' " + CRLF
	cQuery		+= " AND SA1.D_E_L_E_T_<>'*' " + CRLF
	cQuery		+= " AND SD2.D_E_L_E_T_<>'*' " + CRLF
	cQuery		+= " AND F2_FILIAL = '" + cFilAnt + "' " + CRLF
	cQuery		+= " AND F2_DOC || F2_SERIE IN " + CRLF
	cQuery		+= " ( " + CRLF
	cQuery		+= " 	SELECT DISTINCT D2_DOC || D2_SERIE " + CRLF
	cQuery		+= "	FROM " + RetSqlName("SD2") + " SD2 " + CRLF
	cQuery		+= " 	INNER JOIN " + RetSqlName("SB1") + " SB1 ON SB1.D_E_L_E_T_ = ' ' " + CRLF 
	cQuery		+= " 		AND B1_FILIAL = '" + xFilial("SB1") + "' " + CRLF
	cQuery		+= " 		AND B1_COD = D2_COD " + CRLF
	cQuery		+= " 		AND B1_ZCODSF <> '99996' " + CRLF
	cQuery		+= " 	WHERE SD2.D_E_L_E_T_ = ' ' " + CRLF 
	cQuery		+= " 		AND D2_FILIAL = '" + cFilAnt + "' " + CRLF
	cQuery		+= " 		AND D2_EMISSAO BETWEEN '" + DTOS(MV_PAR04) + "' AND '" + DTOS(MV_PAR05) + "' " + CRLF
	cQuery		+= " 		AND D2_CF IN ('5101','5105','5118','5151','5401','6101','6105','6118','6151','6401') " + CRLF
	cQuery		+= " ) " + CRLF

	//MemoWrite("C:\TEMP\fNotaSAI.SQL",cQuery)

	fGeraQry(cQuery , @cAliasTMP)

	If (cAliasTMP)->(!EOF())

		AADD(aLayOut , {(006 - 001) + 1 , "N" , 0}) // NUMERO DA NOTA FISCAL
		AADD(aLayOut , {(014 - 007) + 1 , "D" , 0}) // DATA DE EMISSAO DA NOTA FISCAL (AAAAMMDD)
		AADD(aLayOut , {(028 - 015) + 1 , "C" , 0}) // CNPJ OU CPF
		AADD(aLayOut , {(043 - 029) + 1 , "N" , 2}) // VALOR TOTAL DA N.F.
		AADD(aLayOut , {(058 - 044) + 1 , "N" , 2}) // VALOR DO ICMS NORMAL
		AADD(aLayOut , {(073 - 059) + 1 , "N" , 2}) // VALOR DO ICMS SUBSTIT.
		AADD(aLayOut , {(074 - 074) + 1 , "C" , 0}) // [E]NTRADA OU [S]AIDA
		AADD(aLayOut , {(088 - 075) + 1 , "C" , 0}) // INSCRICAO ESTADUAL DA EMPRESA
		AADD(aLayOut , {(092 - 089) + 1 , "C" , 0}) // INFORMAR CFOP

		Do While (cAliasTMP)->(!EOF())

			AADD(aDados , RIGHT(ALLTRIM((cAliasTMP)->(NOTAFISCAL)),6	))
			AADD(aDados , (cAliasTMP)->(EMISSAO)		)
			AADD(aDados , (cAliasTMP)->(DOCUMENTO)		)
			AADD(aDados , (cAliasTMP)->(VALORNF)		)
			AADD(aDados , (cAliasTMP)->(ICMSNORMAL)		)
			AADD(aDados , (cAliasTMP)->(ICMSSUBSTIT)	)
			AADD(aDados , (cAliasTMP)->(TIPO)			)
			AADD(aDados , IIF(Empty((cAliasTMP)->(INSCREST)),"ISENTO",(cAliasTMP)->(INSCREST))		)
			AADD(aDados , (cAliasTMP)->(CFOP)			)

			fGeraLinha(aLayOut , aDados , @cLinha)

			fEscreve(cLinha , @nHandle , cArqSaida)

			(cAliasTMP)->(dbSkip())

			aDados	:= {}

		EndDo

	EndIf

	(cAliasTMP)->(dbCloseArea())

	fClose(nHandle)

Return

/*
=====================================================================================
Programa.:              fNotaSA1
Autor....:              Luis Artuso
Data.....:              14/10/16
Descricao / Objetivo:   Gera o arquivo 'NotasSA1.txt'
Doc. Origem:            Contrato - GAP FIS46
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:				ARQUIVO DETALHE DE NOTAS DE ENTRADA OU SAIDA (ITENS)
=====================================================================================
*/
Static Function fNotaSA1(oBarra , MV_PAR06)

	Local cQuery	:= ""
	Local cFrom		:= ""
	Local cFields	:= ""
	Local cWhere	:= ""
	Local cAliasTMP	:= ""
	Local cAliasSD1 := "SD1"
	Local cAliasSD2 := "SD2"
	local cAliasSF1 := "SF1"
	local cAliasSF2 := "SF2"
	local cAliasSA1 := "SA1"
	local cAliasSA2 := "SA2"	
	Local aLayOut	:= {}
	Local aDados	:= {}
	Local nHandle	:= 0
	Local cLinha	:= 0
	Local cArqSaida	:= ""

	fVldDirDest(@MV_PAR06)

	cArqSaida	:= MV_PAR06 + 'NotasSA1.txt'

	cAliasTMP	:= GetNextAlias()

	cQuery		:= " SELECT DISTINCT NOTAFISCAL, EMISSAO, DOCUMENTO, VALORNF, ICMSNORMAL, ICMSSUBSTIT, TIPO, INSCREST, CFOP, " + CRLF
	cQuery		+= " CODPROD, QTDPECAS, PESO, PCUNITARIO, NRITEM, ALIQUOTA " + CRLF
	cQuery		+= " FROM "
	cQuery		+= " ( "

	cQuery		+= " SELECT F1_DOC NOTAFISCAL, F1_EMISSAO EMISSAO, A2_CGC DOCUMENTO, F1_VALBRUT VALORNF, F1_VALICM ICMSNORMAL, " + CRLF
	// 31/08/2018 - Atilio - Substituir PESO: D1_PESO/D2_PESO ==>> D1_QUANT/D2_QUANT
	//cQuery		+= " D1_COD CODPROD, D1_QUANT QTDPECAS, D1_PESO PESO, D1_VUNIT PCUNITARIO, 'E' TIPO, D1_ITEM NRITEM, D1_PICM ALIQUOTA " + CRLF
	cQuery		+= "  F1_ICMSRET ICMSSUBSTIT, 'E' TIPO, A2_INSCR INSCREST, D1_CF CFOP, D1_COD CODPROD, D1_QUANT QTDPECAS,  " + CRLF 
	
	cQuery		+= "             (Select SUM(ZZN_QTKG)"
	cQuery		+= " 			 From "+RetSqlName('ZZN') + " ZZN, " + RetSqlName('ZZM') + " ZZM"
	cQuery		+= " 			 Where ZZN.D_E_L_E_T_ = ' ' "
	cQuery		+= " 			   AND ZZM.D_E_L_E_T_ = ' ' "
	cQuery		+= " 			   AND ZZN_FILIAL = ZZM_FILIAL  
	cQuery		+= " 			   AND ZZN_PEDIDO = ZZM_PEDIDO
	cQuery		+= "  			   AND ZZN_CODAGR = D1_COD"  
	cQuery		+= "  			   AND ZZM_FILIAL = F1_FILIAL" 
	cQuery		+= " 			   AND ZZM_DOC    = F1_DOC" 
	cQuery		+= " 			   AND ZZM_SERIE  = F1_SERIE" 
	cQuery		+= " 			   AND Rtrim(ZZM_FORNEC) = RTrim(F1_FORNECE)" 
	cQuery		+= " 			   AND ZZM_LOJA   = F1_LOJA	) PESO, " 

	cQuery		+= "  D1_VUNIT PCUNITARIO, D1_ITEM NRITEM, D1_PICM ALIQUOTA " + CRLF

	cQuery		+= " FROM " + RetSqlName(cAliasSF1) + " " + cAliasSF1 + ", " + RetSqlName(cAliasSA2) + " " + cAliasSA2 + ", " + RetSqlName(cAliasSD1) + " " + cAliasSD1 + " " + CRLF 

	cQuery		+= " WHERE F1_FORNECE = A2_COD " + CRLF
	cQuery		+= " AND F1_LOJA = A2_LOJA " + CRLF
	cQuery		+= " AND F1_DOC = D1_DOC " + CRLF
	cQuery		+= " AND F1_SERIE = D1_SERIE " + CRLF
	cQuery		+= " AND F1_FILIAL = D1_FILIAL " + CRLF
	cQuery		+= " AND F1_FORNECE = D1_FORNECE " + CRLF
	cQuery		+= " AND F1_LOJA = D1_LOJA " + CRLF
	cQuery		+= " AND F1_EMISSAO >= '" + DTOS(MV_PAR04) + "' " + CRLF 
	cQuery		+= " AND F1_EMISSAO <= '" + DTOS(MV_PAR05) + "' " + CRLF
	cQuery		+= " AND SF1.D_E_L_E_T_<>'*' " + CRLF
	cQuery		+= " AND SA2.D_E_L_E_T_<>'*' " + CRLF
	cQuery		+= " AND F1_FILIAL = '" + cFilAnt + "' " + CRLF
	cQuery		+= " AND F1_TIPO = 'N' " + CRLF
	cQuery		+= " AND F1_DOC || F1_SERIE IN " + CRLF
	cQuery		+= " ( " + CRLF
	cQuery		+= " 	SELECT DISTINCT D1_DOC || D1_SERIE " + CRLF
	cQuery		+= "	FROM " + RetSqlName("SD1") + " SD1 " + CRLF
	cQuery		+= " 	INNER JOIN " + RetSqlName("SB1") + " SB1 ON SB1.D_E_L_E_T_ = ' ' " + CRLF 
	cQuery		+= " 		AND B1_FILIAL = '" + xFilial("SB1") + "' " + CRLF
	cQuery		+= " 		AND B1_COD = D1_COD " + CRLF
	cQuery		+= " 		AND B1_ZCODSF <> '99996' " + CRLF
	cQuery		+= " 	WHERE SD1.D_E_L_E_T_ = ' ' " + CRLF 
	cQuery		+= " 		AND D1_FILIAL = '" + cFilAnt + "' " + CRLF
	cQuery		+= " 		AND D1_EMISSAO BETWEEN '" + DTOS(MV_PAR04) + "' AND '" + DTOS(MV_PAR05) + "' " + CRLF
	cQuery		+= " 		AND D1_CF IN ('1101','1151','1201','1410','2101','2151','2201','2410') " + CRLF
	cQuery		+= " ) " + CRLF

	cQuery		+= " UNION ALL " + CRLF

	cQuery		+= " SELECT F2_DOC NOTAFISCAL, F2_EMISSAO EMISSAO, A1_CGC DOCUMENTO, F2_VALBRUT VALORNF, F2_VALICM ICMSNORMAL,  " + CRLF
	//cQuery		+= " D2_COD CODPROD, D2_QUANT QTDPECAS, D2_PESO PESO, D2_PRCVEN PCUNITARIO, 'S' TIPO, D2_ITEM NRITEM, D2_ALQIMP1 ALIQUOTA " + CRLF
	cQuery		+= " F2_ICMSRET ICMSSUBSTIT, 'S' TIPO, A1_INSCR INSCREST, D2_CF CFOP, D2_COD CODPROD, D2_QUANT QTDPECAS, D2_QUANT PESO, " + CRLF 
	cQuery		+= " D2_PRCVEN PCUNITARIO, D2_ITEM NRITEM, D2_ALQIMP1 ALIQUOTA " + CRLF

	cQuery		+= " FROM " + RetSqlName(cAliasSF2) + " " + cAliasSF2 + ", " + RetSqlName(cAliasSA1) + " " + cAliasSA1 + ", " + RetSqlName(cAliasSD2) + " " + cAliasSD2 + " " + CRLF

	cQuery		+= " WHERE F2_CLIENTE = A1_COD " + CRLF
	cQuery		+= " AND F2_LOJA = A1_LOJA " + CRLF
	cQuery		+= " AND F2_DOC = D2_DOC " + CRLF
	cQuery		+= " AND F2_SERIE = D2_SERIE " + CRLF
	cQuery		+= " AND F2_CLIENTE = F2_CLIENTE " + CRLF
	cQuery		+= " AND F2_LOJA = D2_LOJA " + CRLF
	cQuery		+= " AND F2_FILIAL = D2_FILIAL " + CRLF  	
	cQuery		+= " AND F2_EMISSAO >= '" + DTOS(MV_PAR04) + "' " + CRLF 
	cQuery		+= " AND F2_EMISSAO <= '" + DTOS(MV_PAR05) + "' " + CRLF
	cQuery		+= " AND SF2.D_E_L_E_T_<>'*' " + CRLF
	cQuery		+= " AND SA1.D_E_L_E_T_<>'*' " + CRLF
	cQuery		+= " AND F2_FILIAL = '" + cFilAnt + "' " + CRLF
	cQuery		+= " AND F2_TIPO = 'N' " + CRLF
	cQuery		+= " AND F2_DOC || F2_SERIE IN " + CRLF
	cQuery		+= " ( " + CRLF
	cQuery		+= " 	SELECT DISTINCT D2_DOC || D2_SERIE " + CRLF
	cQuery		+= "	FROM " + RetSqlName("SD2") + " SD2 " + CRLF
	cQuery		+= " 	INNER JOIN " + RetSqlName("SB1") + " SB1 ON SB1.D_E_L_E_T_ = ' ' " + CRLF 
	cQuery		+= " 		AND B1_FILIAL = '" + xFilial("SB1") + "' " + CRLF
	cQuery		+= " 		AND B1_COD = D2_COD " + CRLF
	cQuery		+= " 		AND B1_ZCODSF <> '99996' " + CRLF
	cQuery		+= " 	WHERE SD2.D_E_L_E_T_ = ' ' " + CRLF 
	cQuery		+= " 		AND D2_FILIAL = '" + cFilAnt + "' " + CRLF
	cQuery		+= " 		AND D2_EMISSAO BETWEEN '" + DTOS(MV_PAR04) + "' AND '" + DTOS(MV_PAR05) + "' " + CRLF
	cQuery		+= " 		AND D2_CF IN ('5101','5105','5118','5151','5401','6101','6105','6118','6151','6401') " + CRLF
	cQuery		+= " ) " + CRLF
	cQuery		+= " ) " + CRLF
	cQuery		+= " ORDER BY TIPO, NOTAFISCAL " + CRLF

	MemoWrite("C:\TEMP\fNotaSA1.SQL",cQuery)
	
	fGeraQry(cQuery , @cAliasTMP)

	If (cAliasTMP)->(!EOF())

		AADD(aLayOut , {(006 - 001) + 1 , "C" , 0 }) // NUMERO DA NOTA FISCAL
		AADD(aLayOut , {(014 - 007) + 1 , "D" , 0 }) // DATA DE EMISSAO DA N.F.
		AADD(aLayOut , {(028 - 015) + 1 , "C" , 0 }) // CNPJ OU CPF
		AADD(aLayOut , {(042 - 029) + 1 , "C" , 0 }) // CODIGO DO PRODUTO UTILIZADO NO FRIGORIFICO
		AADD(aLayOut , {(057 - 043) + 1 , "N" , 3 }) // QUANTIDADE DE PECAS DO PRODUTO
		AADD(aLayOut , {(072 - 058) + 1 , "N" , 3 }) // PESO
		AADD(aLayOut , {(087 - 073) + 1 , "N" , 2 }) // PRECO UNITARIO
		AADD(aLayOut , {(088 - 088) + 1 , "C" , 0 }) // [E]NTRADA OU [S]AIDA
		AADD(aLayOut , {(091 - 089) + 1 , "N" , 0 }) // NUMERO DO ITEM NA NOTA FISCAL
		AADD(aLayOut , {(105 - 092) + 1 , "C" , 0 }) // INSCRICAO ESTADUAL
		AADD(aLayOut , {(109 - 106) + 1 , "N" , 0 }) // CFOP (*)
		AADD(aLayOut , {(115 - 110) + 1 , "N" , 2 }) // ALIQUOTA DE ICMS (*)
		//(*) PARA OS FRIGORIFICOS QUE TENHAM OPERACOES INTERESTADUAIS, COMPRAS/VENDAS

		Do While (cAliasTMP)->(!EOF())

			AADD(aDados , CVALTOCHAR(RIGHT(ALLTRIM((cAliasTMP)->(NOTAFISCAL)),6	)))
			AADD(aDados , (cAliasTMP)->(EMISSAO)		)
			AADD(aDados , (cAliasTMP)->(DOCUMENTO) 		)
			AADD(aDados , (cAliasTMP)->(CODPROD) 		)
			AADD(aDados , (cAliasTMP)->(QTDPECAS) 	 	)
			AADD(aDados , (cAliasTMP)->(PESO)			)
			AADD(aDados , (cAliasTMP)->(PCUNITARIO) 	)
			AADD(aDados , (cAliasTMP)->(TIPO) 		 	)
			AADD(aDados , (cAliasTMP)->(NRITEM) 		)
			AADD(aDados , IIF(Empty((cAliasTMP)->(INSCREST)),"ISENTO",(cAliasTMP)->(INSCREST))		)
			AADD(aDados , (cAliasTMP)->(CFOP) 		 	)
			AADD(aDados , (cAliasTMP)->(ALIQUOTA) 	 	)

			fGeraLinha(aLayout , aDados , @cLinha)

			fEscreve(cLinha , @nHandle , cArqSaida)

			(cAliasTMP)->(dbSkip())

			aDados	:= {}

		EndDo

	EndIf

	(cAliasTMP)->(dbCloseArea())

	fClose(nHandle)

Return

/*
=====================================================================================
Programa.:              fGeraLinha
Autor....:              Luis Artuso
Data.....:              14/10/16
Descricao / Objetivo:   Monta a linha para ser gravada no arquivo saida.
Doc. Origem:            Contrato - GAP FIS46
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
Static Function fGeraLinha(aLayOut , aDados , cLinha)

	Local nLen		:= 0
	Local nX		:= 0
	Local nPosTam	:= 0
	Local nPosTipo	:= 0
	Local nPosDec	:= 0
	Local nTam		:= 0
	Local nDec		:= 0
	Local cTipo		:= ""
	Local xDado

	nPosTam		:= 1
	nPosTipo	:= 2
	nPosDec		:= 3

	nLen	:= Len(aLayOut)

	cLinha	:= ""

	For nX := 1 TO nLen

		xDado	:= aDados[nX]

		nTam	:= aLayOut[nX , nPosTam]

		cTipo	:= aLayOut[nX , nPosTipo]

		Do Case

			Case ( cTipo == "N" )

			nDec	:= aLayOut[nX , nPosDec]

			If ( ValType(xDado) == "N" )

				xDado	:= StrZero(xDado , nTam , nDec)

			Else

				xDado	:= StrZero(Val(xDado) , nTam , nDec)

			EndIf

			OtherWise

			xDado	:= PadR( AllTrim(xDado) , nTam )

		End Case

		cLinha	+= xDado

	Next nX

Return cLinha

/*
=====================================================================================
Programa.:              fEscreve
Autor....:              Luis Artuso
Data.....:              14/10/16
Descricao / Objetivo:   Grava os dados no arquivo saída
Doc. Origem:            Contrato - GAP FIS46
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
Static Function fEscreve(cString , nHandle , cArqSaida)

	Local cEol	:= Chr(13)+Chr(10)

	If ( nHandle == 0 )

		nHandle	:= fCreate(cArqSaida)

	EndIf

	fWrite(nHandle , cString + cEol )

Return

/*
=====================================================================================
Programa.:              fExibeTela
Autor....:              Luis Artuso
Data.....:              14/10/16
Descricao / Objetivo:   Exibe interface para escolha de data, periodo de folha e mes de processamento
Doc. Origem:            Contrato - GAP FIS46
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
Static Function fExibeTela()

	Local cType		:= ""
	Local cArquivo	:= ""
	Local cTitulo01	:= ""
	Local cTitulo02	:= ""
	Local cArq01	:= ""
	Local cArq02	:= ""
	Local cArq03	:= ""
	Local cDirIni	:= ""
	Local cManadRHE	:= "" //Este parametro indica o diretorio padrao para localizacao do arquivo manad gerado pelo RH Evollution
	Local cManadPro	:= "" //Este parametro indica o diretorio padrao para localizacao do arquivo manad gerado pelo Protheus
	Local cExtensao	:= "" //Extensao para geracao
	Local lKeepCase	:= .T.
	Local lArvore	:= .T.
	Local lSalvar	:= .T.
	Local nDialogX	:= 0
	Local nDialogY	:= 0
	Local nTamFonte	:= 0
	Local nLin01	:= 0
	Local nLin02	:= 0
	Local nLabelIni	:= 0
	Local nLabelFim	:= 0
	Local nPosFim	:= 0
	Local nSizeX01	:= 0
	Local nSizeX02	:= 0
	Local nMascPad	:= 0
	Local oSay01
	Local oSay02
	Local oSay03
	Local oSay04
	Local oSay05
	Local oSay06
	Local oDlg
	Local oFont
	Local oFont01
	Local oFont02
	Local oButton01
	Local oButton02
	Local oButton03
	Local oButton04
	Local oButton05
	Local oButton06
	Local nLin01	:= 0
	Local nLin02	:= 0
	Local nLin03	:= 0
	Local nLin04	:= 0
	Local nCol01	:= 0
	Local nCol02	:= 0
	Local nCol03	:= 0
	Local nCol04	:= 0
	Local oSay01
	Local oGet01
	Local cGet01
	Local nSize01	:= 0
	Local nSize02	:= 0

	nDialogX	:= 430
	nDialogY	:= 900

	nLabelIni	:= 212
	nLabelFim	:= nDialogY / 2

	nTamFonte	:= 15

	DEFINE FONT oFont01 NAME "ARIAL" SIZE 1,nTamFonte BOLD

	DEFINE MSDIALOG oDlg TITLE "Geração do arquivo 'FOLHA.TXT' " FROM 000 , 000  TO nDialogX , nDialogY COLORS 0, 16777215 PIXEL

	@ 004 , 003 TO nLabelIni , nLabelFim LABEL "Informe os dados para geração do arquivo" PIXEL OF oDlg

	nLin01	:= 16

	nCol01	:= 15

	nSize01 := 200

	nsize02 := 40

	cGet01	:= Space(05)

	@ nLin01 , nCol01 SAY oSay1 PROMPT " Informe o período da folha de pagamento (Formato MM/AA) :" SIZE nSize01 , 007 OF oDlg COLORS 0, 16777215 PIXEL FONT oFont01

	@ nLin01 , nCol01 + nSize01 MSGET oGet01 VAR cGet01 SIZE nSize02 , 010 OF oDlg COLORS 0, 16777215 PIXEL

	nLin02	:= nLin01 + 24

	nCol02	:= 15

	nSize03 := 200

	nsize04 := 40

	cGet02	:= Space(05)

	@ nLin02, nCol02 SAY oSay1 PROMPT " Informe o número de funcionários :" SIZE nSize03 , 007 OF oDlg COLORS 0, 16777215 PIXEL FONT oFont01

	@ nLin02 , nCol02 + nSize03 MSGET oGet02 VAR cGet02 SIZE nSize04 , 010 OF oDlg COLORS 0, 16777215 PIXEL

	nLin03	:= nLin01 + 24

	nCol03	:= 15

	nSize05 := 200

	nsize06 := 40

	cGet03	:= Space(05)

	@ nLin03 , nCol03 SAY oSay1 PROMPT " Valor da folha de pagamento :" SIZE 070, 007 OF oDlg COLORS 0, 16777215 PIXEL FONT oFont

	@ nLin03 , nCol03 MSGET oGet1 VAR cGet1 SIZE 160, 010 OF oDlg COLORS 0, 16777215 PIXEL

	/*
	//----------- Botao 06

	nLin04		:= 190

	nPosFim04	:= 410

	@ nLin04 , nPosFim04 BUTTON oButton06 PROMPT "&Encerra" SIZE 038, 20 OF oDlg PIXEL ACTION oDlg:End()*/

	ACTIVATE MSDIALOG oDlg CENTERED

Return


/*
=====================================================================================
Programa.:              fPergunta
Autor....:              Luis Artuso
Data.....:              14/10/16
Descricao / Objetivo:   Exibe pergunte
Doc. Origem:            Contrato - GAP FIS46
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
Static Function fPergunta()

	Local cPerg	:= ""
	Local lRet	:= .F.

	cPerg	:= "AGREGAR"
	lRet	:= Pergunte(cPerg , .T.)

Return lRet

/*
=====================================================================================
Programa.:              fGeraQry
Autor....:              Luis Artuso
Data.....:              17/10/16
Descricao / Objetivo:   Executa a query e gera o arquivo temporario
Doc. Origem:            Contrato - GAP FIS46
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
Static Function fGeraQry(cQuery , cAliasTMP)

	Local nCnt := 0
	Local cQuery := ChangeQuery( cQuery )


	If Select(cAliasTMP) > 0           // Verificar se o Alias ja esta aberto.
		DbSelectArea(cAliasTMP)        // Se estiver, devera ser fechado.
		(cAliasTMP)->( DbCloseArea() )
	EndIf

	dbUseArea(.T. , "TOPCONN" , TcGenQry(NIL , NIL , cQuery) , cAliasTMP , .F. , .T.)

	DbSelectArea(cAliasTMP)
	DbGoTop()
	
	DbEval( {|| nCnt++ })              // Conta quantos sao os registros retornados pelo Select.
	
	DbSelectArea(cAliasTMP)
	DbGoTop()



Return nCnt

/*
=====================================================================================
Programa.:              fVldDirDest
Autor....:              Luis Artuso
Data.....:              17/10/16
Descricao / Objetivo:   Valida se a variavel 'MV_PAR06' possui '\'
Doc. Origem:            Contrato - GAP FIS46
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/

Static Function fVldDirDest(MV_PAR06)

	If !(Right(MV_PAR06 , 1) == "\")

		MV_PAR06	+= "\"

	EndIf

Return



/*
=====================================================================================
{Protheus.doc} AtuSX1
Atualização do SX1 - Perguntas

@author TOTVS Protheus
@since  12/04/2017
@obs    Gerado por EXPORDIC - V.5.2.1.0 EFS / Upd. V.4.20.15 EFS
@version 1.0
=====================================================================================
*/

Static Function AtuSX1()
	Local aArea    := GetArea()
	Local aAreaDic := SX1->( GetArea() )
	Local aEstrut  := {}
	Local aStruDic := SX1->( dbStruct() )
	Local aDados   := {}
	Local nI       := 0
	Local nJ       := 0
	Local nTam1    := Len( SX1->X1_GRUPO )
	Local nTam2    := Len( SX1->X1_ORDEM )

	aEstrut := { "X1_GRUPO"  , "X1_ORDEM"  , "X1_PERGUNT", "X1_PERSPA" , "X1_PERENG" , "X1_VARIAVL", "X1_TIPO"   , ;
	"X1_TAMANHO", "X1_DECIMAL", "X1_PRESEL" , "X1_GSC"    , "X1_VALID"  , "X1_VAR01"  , "X1_DEF01"  , ;
	"X1_DEFSPA1", "X1_DEFENG1", "X1_CNT01"  , "X1_VAR02"  , "X1_DEF02"  , "X1_DEFSPA2", "X1_DEFENG2", ;
	"X1_CNT02"  , "X1_VAR03"  , "X1_DEF03"  , "X1_DEFSPA3", "X1_DEFENG3", "X1_CNT03"  , "X1_VAR04"  , ;
	"X1_DEF04"  , "X1_DEFSPA4", "X1_DEFENG4", "X1_CNT04"  , "X1_VAR05"  , "X1_DEF05"  , "X1_DEFSPA5", ;
	"X1_DEFENG5", "X1_CNT05"  , "X1_F3"     , "X1_PYME"   , "X1_GRPSXG" , "X1_HELP"   , "X1_PICTURE", ;
	"X1_IDFIL"  }

	aAdd( aDados, {'AGREGAR','01','Periodo Folha de pagamento','Periodo Folha de pagamento','Periodo Folha de pagamento','MV_CH0','C',5,0,0,'G','','MV_PAR01','','','','10/16','','','','','','','','','','','','','','','','','','','','','','','','','@!',''} )
	aAdd( aDados, {'AGREGAR','02','Quantidade de Funcionarios','Quantidade de Funcionarios','Quantidade de Funcionarios','MV_CH0','C',5,0,0,'G','','MV_PAR02','','','','5000','','','','','','','','','','','','','','','','','','','','','','','','','@!',''} )
	aAdd( aDados, {'AGREGAR','03','Valor da folha de Pagto','Valor da folha de Pagto','Valor da folha de Pagto','MV_CH0','C',10,2,0,'G','','MV_PAR03','','','','100000','','','','','','','','','','','','','','','','','','','','','','','','','@E999,999.99',''} )
	aAdd( aDados, {'AGREGAR','04','Data de Emissao da Nota de:','Data de Emissao da Nota de:','Data de Emissao da Nota de:','MV_CH0','D',8,0,0,'G','','MV_PAR04','','','','20100101','','','','','','','','','','','','','','','','','','','','','','','','','',''} )
	aAdd( aDados, {'AGREGAR','05','Data de Emissao da Nota Ate:','Data de Emissao da Nota Ate:','Data de Emissao da Nota Ate:','MV_CH0','D',8,0,0,'G','','MV_PAR05','','','','20170303','','','','','','','','','','','','','','','','','','','','','','','','','',''} )
	aAdd( aDados, {'AGREGAR','06','Salvar em: ','Salvar em: ','Salvar em: ','MV_CH0','C',8,0,0,'F','','MV_PAR06','179','','',"C:",'','','','','','','','','','','','','','','','','','','','','','','','','',''} )


	//
	// Atualizando dicionário
	//
	dbSelectArea( "SX1" )
	SX1->( dbSetOrder( 1 ) )

	For nI := 1 To Len( aDados )
		If !SX1->( dbSeek( PadR( aDados[nI][1], nTam1 ) + PadR( aDados[nI][2], nTam2 ) ) )
			RecLock( "SX1", .T. )
			For nJ := 1 To Len( aDados[nI] )
				If aScan( aStruDic, { |aX| PadR( aX[1], 10 ) == PadR( aEstrut[nJ], 10 ) } ) > 0
					SX1->( FieldPut( FieldPos( aEstrut[nJ] ), aDados[nI][nJ] ) )
				EndIf
			Next nJ
			MsUnLock()
		EndIf
	Next nI

	RestArea( aAreaDic )
	RestArea( aArea )

Return NIL