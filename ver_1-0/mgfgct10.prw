#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

Static oBrw
/*
=====================================================================================
Programa.:              MGFGCT10
Autor....:              Luis Artuso
Data.....:              19/10/16
Descricao / Objetivo:   Chamada da rotina principal
Doc. Origem:            Contrato - GAP VEN01
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Gera NCC a partir de Desconto a Cliente
=====================================================================================
*/
User Function MGFGCT10()

	Private aRotina		:= {}

	Private cCadastro	:= ""

	fMBrowse()

Return

/*
=====================================================================================
Programa.:              fMBrowse
Autor....:              Luis Artuso
Data.....:              19/10/16
Descricao / Objetivo:   Execucao do mBrowse
Doc. Origem:            Contrato - GAP VEN01
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
Static Function fMBrowse()

	Local cAlias	:= ""

	aRotina		:=	fMenuDef()

	cAlias		:= "ZZ3"

	cCadastro	:= "Cadastro de Notas de Credito"

	mBrowse(06,01,22,75,cAlias)

Return

/*
=====================================================================================
Programa.:              fMenuDef
Autor....:              Luis Artuso
Data.....:              19/10/16
Descricao / Objetivo:
Doc. Origem:            Contrato - GAP VEN01
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
Static Function fMenuDef(lMarkBrow)

	Local aReturn	:=	{}
	Local aAreaSZS	:=	{}
	Local cAliasSZS	:= ""
	Local cChaveSZS	:= ""

	DEFAULT lMarkBrow	:= .F.

	If !( lMarkBrow )

		cAliasSZS	:= "SZS"

		aAreaSZS	:= (cAliasSZS)->(GetArea())

		cChaveSZS	:= xFilial(cAliasSZS) + __cUserId

		AADD(aReturn,{'ARQUIVA' , "MSDOCUMENT"	, 0 , 4})

		AADD(aReturn,{'Incluir' , "AxInclui"	, 0 , 3})

		AADD(aReturn,{'Alterar ' , "AxAltera" , 0 , 4})

		AADD(aReturn,{'Gerar Planilha' , "U_fGct0601"	, 0 , 4})

		(cAliasSZS)->(dbSetOrder(2))

		If (cAliasSZS)->(dbSeek(cChaveSZS)) .AND. ( (cAliasSZS)->ZS_MSBLQL == '2')

			//Somente permite executar a rotina de liberacao de notas, caso usuario esteja cadastrado na tabela de aprovadores E
			//o aprovador esteja liberado.

			AADD(aReturn,{'Seleciona Notas para liberacao' , "U_fGct0603"	, 0 , 4})

		EndIf

		RestArea(aAreaSZS)

	Else

		AADD(aReturn,{'Libera Notas ' , "U_fGct0602" , 0 , 4})

	EndIf

Return aReturn

/*
=====================================================================================
Programa.:              fGct0601
Autor....:              Luis Artuso
Data.....:              19/10/16
Descricao / Objetivo:   Execucao da MarkBrowse
Doc. Origem:            Contrato - GAP VEN01
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
User Function fGct0601()

	Local cAliasTMP	:= ""
	Local aHeader	:= {}
	Local aDados	:= {}

	If ( fPergunta() )

		cAliasTMP	:= GetNextAlias()

		fGeraQry(cAliasTMP)

		If (cAliasTMP)->(EOF())

			MsgAlert('NÃ£o foram encontradas notas para os dados informados')

		Else

			fGeraHead(cAliasTMP , @aHeader)

			fGeraDados(aHeader , @aDados , cAliasTMP)

			fGeraExcel(aHeader , aDados)

		EndIf

	EndIf

Return

/*
=====================================================================================
Programa.:              fGeraQry
Autor....:              Luis Artuso
Data.....:              19/10/16
Descricao / Objetivo:   Executa a query para verificar as notas fiscais para determinado cliente
Doc. Origem:            Contrato - GAP VEN01
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
Static Function fGeraQry(cAliasTMP)

	Local cQuery	:= ""
	Local cSelFrom	:= ""
	Local cFields	:= ""
	Local cWhere	:= ""
	Local cJoin		:= ""
	Local cAliasSD2	:= ""
	Local cAliasSF2	:= ""
	Local cAliasSA1	:= ""
	Local cExists	:= ""
	Local cCharDel	:= ""
	Local cOrder	:= ""
	Local cCgc		:= ""
	Local cDataIni	:= cToD('')
	Local cDataFim	:= cToD('')
	Local cSpace	:= Space(1)
	Local cTipo		:= ""

	cAliasSD2	:= "SD2"
	cAliasSF2	:= "SF2"
	cAliasSA1	:= "SA1"
	cCharDel	:= "'*'"

	cCgcini		:= MV_PAR01
	cCgcfim		:= MV_PAR02
	cDataIni	:= dToS(MV_PAR03)
	cDataFim	:= dToS(MV_PAR04)

	cTipo		:= "N"

	cSelFrom	:= "SELECT "

	cFields		:= "F2_FILIAL , F2_DOC , F2_SERIE , D2_ITEM , D2_DESC , D2_QUANT , "
	cFields		+= "D2_PRCVEN , D2_TOTAL , D2_EMISSAO , F2_COND "

	cFrom		:= "FROM " 
	cFrom		+= 		RetSqlName(cAliasSF2) + " " + cAliasSF2 + " "

	cJoin		:= "INNER JOIN " + RetSqlname(cAliasSD2) + " " + cAliasSD2 + " ON "
	cJoin		+=		cAliasSF2 + ".F2_FILIAL = "		+ cAliasSD2 + ".D2_FILIAL" + " AND "
	cJoin		+=		cAliasSF2 + ".F2_DOC = "		+ cAliasSD2 + ".D2_DOC" + " AND "
	cJoin		+=		cAliasSF2 + ".F2_SERIE = "		+ cAliasSD2 + ".D2_SERIE" + " AND "
	cJoin		+=		cAliasSF2 + ".F2_CLIENTE = "	+ cAliasSD2 + ".D2_CLIENTE "

	cWhere		:= "WHERE "
	cWhere		+=		cAliasSD2 + ".D2_EMISSAO BETWEEN " + cDataIni + " AND " + cDataFim + " AND "
	cWhere		+=		cAliasSD2 + ".D2_TIPO = " + "'" + cTipo + "'" + " AND "

	cExists		+= 		"EXISTS ( "
	cExists		+= 			"SELECT A1_COD FROM " + RetSqlName(cAliasSA1) + " " + cAliasSA1 + cSpace
	cExists		+= 			"WHERE " + cAliasSA1 + ".A1_CGC >= '" + cCgcini + "' "
	cExists		+= 			"AND " + cAliasSA1 + ".A1_CGC <= '" + cCgcfim + "' "
	cExists		+= 			"AND " + cAliasSA1 + ".D_E_L_E_T_ = ' ' " 
	cExists		+=		") "

	cWhere		+= cExists

	cWhere		+= " AND " + cAliasSD2 + ".D_E_L_E_T_ = ' ' " + cSpace
	cWhere		+= " AND " + cAliasSF2 + ".D_E_L_E_T_ = ' ' " + cSpace

	cOrder		:= "ORDER BY "
	cOrder		+= 		cAliasSF2 + ".F2_FILIAL , "
	cOrder		+= 		cAliasSF2 + ".F2_DOC , "
	cOrder		+= 		cAliasSF2 + ".F2_SERIE , "
	cOrder		+= 		cAliasSF2 + ".F2_CLIENTE"

	cQuery	+= cSelFrom + cFields + cFrom +  cJoin + cWhere + cOrder

	fExecQry(cQuery , cAliasTMP)

Return

/*
=====================================================================================
Programa.:              fMarkBrow
Autor....:              Luis Artuso
Data.....:              19/10/16
Descricao / Objetivo:   Execucao da MarkBrowse
Doc. Origem:            Contrato - GAP VEN01
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
Static Function fMarkBrow()

	Local cTitulo	:= ""
	Local cFiltro	:= ""
	Local nLimIni	:= 0
	Local nLimMax	:= 0
	Local cChaveSZS	:= xFilial('SZS') + __cUserId
	Local cAliasZZ3	:= ""

	cAliasSZS	:= "SZS"
	cAliasZZ3	:= "ZZ3"
	(cAliasSZS)->(DBSETORDER(2))
	If (cAliasSZS)->( dbSeek( cChaveSZS ) )
		nLimIni	:= (cAliasSZS)->(ZS_LIMINI)
		nLimMax	:= (cAliasSZS)->(ZS_LIMMAX)
		fMntFiltro(@cFiltro , nLimIni , nLimMax)
	ENDIF

	cTitulo	:= 'Selecao de notas para liberacao'

	aRotina	:= fMenuDef(.T.)

	oBrw := FwMarkBrowse():New()

	oBrw:SetAlias('ZZ3')
	oBrw:SetFieldMark('ZZ3_MARK')
	oBrw:SetMenudef('MGFGCT10')
	oBrw:SetDescription( OEmToAnsi( cTitulo ) ) // Monitor de Check-In

	oBrw:SetAllMark( {|| xMF10AMkZV() } )
	oBrw:SetCustomMarkRec( {|| xMF10MkSZV() } )

	oBrw:SetFilterDefault( cFiltro )

	oBrw:Activate()

Return

/*
=====================================================================================
Programa.:              fGct0602
Autor....:              Luis Artuso
Data.....:              19/10/16
Descricao / Objetivo:   Efetua a liberacao das notas de credito
Doc. Origem:            Contrato - GAP VEN01
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
User Function fGct0602()

	Local aObrigat	:=	{}
	Local cRotAut	:= ""
	Local lOk		:= .F.
	Local cAliasZZ3	:= ""
	Local cNumTit	:= ""
	Local nNumTit	:= 0

	cRotAut		:= "FINA040"

	cAliasZZ3	:= oBrw:Alias()

	Do While (cAliasZZ3)->(!EOF())

		If (oBrw:IsMark())

			cNumTit		:= StrZero(++nNumTit , 9)

			aObrigat	:= fFillObrig(cNumTit) // Preenche os campos para execucao da rotina automatica

			lOk			:= fRunRotAut(aObrigat , cRotAut)

			If ( lOk )

				RecLock(cAliasZZ3 , .F.)

				(cAliasZZ3)->(ZZ3_INTEGR)	:= "1"

				(cAliasZZ3)->(MsUnlock())

			EndIf

		EndIf

		(cAliasZZ3)->(dbSkip())

	EndDo

Return

/*
=====================================================================================
Programa.:              fPergunta
Autor....:              Luis Artuso
Data.....:              19/10/16
Descricao / Objetivo:   Grupo de perguntas para geracao da planilha
Doc. Origem:            Contrato - GAP VEN01
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
Static Function fPergunta

	Local lRet		:= .F.

	Local cPerg		:= ""

	cPerg	:= 'MGFGCT10'

	lRet	:= Pergunte(cPerg , .T.)

Return lRet

/*
=====================================================================================
Programa.:              fGct0603
Autor....:              Luis Artuso
Data.....:              19/10/16
Descricao / Objetivo:   Exibe browse com os contratos
Doc. Origem:            Contrato - GAP VEN01
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
User Function fGct0603(nLimIni , nLimMax)

	fMarkBrow(nLimIni , nLimMax)

Return

/*
=====================================================================================
Programa.:              fExecQry
Autor....:              Luis Artuso
Data.....:              20/10/16
Descricao / Objetivo:   Executa a query e cria o alias temporario
Doc. Origem:            Contrato - GAP VEN01
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
Static Function fExecQry(cQuery , cAlias)

	Local lNewArea	:= .T.
	Local cRdd		:= __cRdd
	Local lShare	:= .F.
	Local lOnlyRead	:= .T.

	dbUseArea(lNewArea , cRdd , TcGenQry(NIL , NIL , cQuery) , cAlias , lShare , lOnlyRead)

Return

/*
=====================================================================================
Programa.:              fGeraHead
Autor....:              Luis Artuso
Data.....:              20/10/16
Descricao / Objetivo:   Gera o array 'aHeader' e atualiza as respectivas posicoes com os titulos, conforme dicionario
Doc. Origem:            Contrato - GAP VEN01
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
Static Function fGeraHead(cAliasTMP , aHeader)

	Local nFields	:= 0
	Local nX		:= 0
	Local cField	:= ""
	Local nTam		:= ""
	Local nDec		:= ""
	Local aRetSX3	:= {}

	nFields	:= (cAliasTMP)->(fCount())

	For nX := 1 TO nFields

		cField	:= (cAliasTMP)->(FieldName(nX))

		aRetSX3	:= TamSX3(cField)
		nTam	:= aRetSX3[1]
		nDec	:= aRetSX3[2]
		cTipo	:= aRetSX3[3]

		cField	:= RetTitle(cField)

		AADD(aHeader , {cField , cTipo , nTam , nDec} )

	Next nX

Return

/*
=====================================================================================
Programa.:              fGeraDados
Autor....:              Luis Artuso
Data.....:              20/10/16
Descricao / Objetivo:   Gera o array 'aDados' com os dados gerados no alias temporario. Os Arrays 'aHeader' e 'aDados' serao utilizados na geracao da planilha.
Doc. Origem:            Contrato - GAP VEN01
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
Static Function fGeraDados(aHeader , aDados , cAlias)

	Local nLenHead	:= 0
	Local nReg		:= 0
	Local nX		:= 0
	Local xDado
	Local cTipo		:= ""
	Local nTam		:= 0
	Local nDec		:= 0
	Local nPosTam	:= 0
	Local nPosDec	:= 0
	Local nPosTipo	:= 0
	Local aDadosTMP	:= {}    
	Local aTotal    := {}
    Local nTotal    := 0
	Local cPicture	:= ""
	Local cTotal    := ""                                              
	Local aAux		:= {}
	Local aAux2		:= {}
	Local cPerc		:= ""
	nLenHead	:= Len(aHeader)

	nPosTipo	:= 2
	nPosTam		:= 3
	nPosDec		:= 4

	cPicture	:= "@E 999,999.99"

	Do While (cAlias)->(!EOF())

		aDadosTMP	:= Array(nLenHead)

		++nReg

		For nX := 1 TO nLenHead

			xDado	:= FieldGet((cAlias)->(FieldPos(FieldName(nX))))

			cTipo	:= aHeader[nX , nPosTipo]

			Do Case

				Case ( cTipo == "N" )

				nTam	:= aHeader[nX , nPosTam]
				nDec	:= aHeader[nX , nPosDec]

				If ( nDec > 0 )

					xDado	:= Transform(xDado , cPicture)

				EndIf

				Case ( cTipo == "D" )

				xDado	:= sToD(xDado)

				Case ( cTipo == "C" )

				xDado	:= CHR(160)+xDado

			End Case

			aDadosTMP[nX]	:= xDado
          
		Next

		AADD(aDados , aDadosTMP)

		aDadosTMP	:= {}
        
		(cAlias)->(dbSkip())

	EndDo
		
		For nX := 1 TO len(aDados)
		
	        nTotal += val(strtran(strtran(aDados[nX][8],"."),",","."))
	
		Next                            
             
///total
		cTotal := Transform(nTotal, cPicture)
		
		aAux := Array(len(aDados[len(aDados)]))
		
		For nX := 1 to len(aAux)
		    aAux[nX] := " "                      
		Next               
		                   
		aAux[8] = cTotal
		aAux[7] = "TOTAL"		
		AADD(aDados ,aAux)                     
//total com desconto
		          
		aAux2 := Array(len(aDados[len(aDados)]))

		For nX := 1 to len(aAux2)
		    aAux2[nX] := " "                      
		Next               
        
        nPerc := ((Val(StrTran(StrTran(cTotal,",",""),".",""))/100)*MV_PAR05/100)  
        

        cPerc := STR(nPerc)      
		
		cPerc := Transform(nPerc, cPicture)
				
		aAux2[7] = "DESC SUGERIDO"
		aAux2[8] = cPerc

		
		AADD(aDados ,aAux2)                     		
Return

/*
=====================================================================================
Programa.:              fGeraExcel
Autor....:              Luis Artuso
Data.....:              20/10/16
Descricao / Objetivo:   Gera a planilha com os dados coletados atraves da query
Doc. Origem:            Contrato - GAP VEN01
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
Static Function fGeraExcel(aHeader , aDados)

	Local cTitulo	:= ""

	cTitulo	:=	SuperGetMv('MGF_VEN0101' , NIL , "Notas de CrÃ©dito")

	MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel", {|| DlgToExcel({{"GETDADOS", cTitulo , aHeader , aDados } } ) } )

Return

/*
=====================================================================================
Programa.:              fMntFiltro
Autor....:              Luis Artuso
Data.....:              20/10/16
Descricao / Objetivo:   Cria o filtro para exibicao da markbrowse
Doc. Origem:            Contrato - GAP VEN01
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
Static Function fMntFiltro(cFiltro , nLimIni , nLimMax)

	Local cAliasZZ3	:= "ZZ3"

	cFiltro	:= (cAliasZZ3) + "->ZZ3_VALOR >= " + AllTrim(Str(nLimIni)) + " .AND. "

	cFiltro	+= (cAliasZZ3) + "->ZZ3_VALOR <= " + AllTrim(Str(nLimMax)) + " .AND. "

	cFiltro	+= "EMPTY(" + (cAliasZZ3) + "->ZZ3_INTEGR" + ")"

	(cAliasZZ3)->(ZZ3_INTEGR)

Return


/*
=====================================================================================
Programa.:              fFillObrig
Autor....:              Luis Artuso
Data.....:              24/10/16
Descricao / Objetivo:   Preenche os campos obrigatorios para execucao do execauto FINA040
Doc. Origem:            Contrato - GAP VEN01
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
Static Function fFillObrig(cNumTit)

	Local aRet		:= {}
	Local cTipo		:= ""
	Local cNaturez	:= ""
	Local cCodCli	:= ""
	Local cLoja		:= ""
	Local dEmissao	:= cToD('')
	Local dVenc		:= cToD('')
	Local dVencReal	:= cToD('')
	Local nValor	:= 0                                   
	Local nVlrCruz	:= 0                                   
	Local cAliasSE1 := "SE1"
	Local cAliasSD1 := "SD1"
	Local cTipodes  := SuperGetMv('MGF_CONTDES' , NIL, '')
	Local cAliasTMP := ""
	Local nNumtit := 0

	Local MGF_NATPAR := SuperGetMv("MGF_NATPAR",,"S")
	Local MGF_NATFIN := "01" //SuperGetMv("MGF_NATFIN",,"1000000000")
	//- Campos Obrigatorios
	// Criado parâmetro p/verificar se o conteúdo da Natureza virá de MV ou Cad Cliente 

	SA1->(dbSetOrder(1)) //A1_FILIAL+A1_COD+A1_LOJA
	If SA1->(DbSeek(xFilial("SA1")+ZZ3->ZZ3_COD+ZZ3->ZZ3_LOJA))
		cNaturez	:= SA1->A1_NATUREZ 
		cCodCli	:= SA1->A1_COD
		cLoja	:= SA1->A1_LOJA
	Else
		IF MGF_NATPAR = "S"
			cNaturez	:= MGF_NATFIN	
		ENDIF
	Endif

	cTipo		:= "NCC"
	dEmissao	:= dDataBase
	dVenc		:= dEmissao + 10
	dVencReal	:= dEmissao + 15
	nValor		:= ZZ3->ZZ3_VALOR
	nVlrCruz	:= ZZ3->ZZ3_VALOR      
	
	cAliasTMP	:= GetNextAlias()
			
	cQuery := "	SELECT COUNT(E1_NUM) TOTAL  "
	cQuery += " FROM " + RetSqlName(cAliasSE1) + " " + cAliasSE1 
	cQuery += " WHERE SE1.E1_CLIENTE = '" + cCodCli + "' " 
	cQuery += " AND SE1.E1_LOJA = '" + cLoja + "' " 
	cQuery += " AND SE1.E1_TIPO = 'NCC'"
	cQuery += " AND SE1.E1_PREFIXO = 'NCC'"
	cQuery += " AND SE1.D_E_L_E_T_=' ' "                          
	
	dbUseArea(.T. , "TOPCONN" , TcGenQry(NIL , NIL , changequery(cQuery)) , cAliasTMP , .F. , .T.)
									                                    
			nNumtit := (cAliasTMP)->TOTAL
			nNumtit++
			cNumTit	:= StrZero(nNumTit , 9)									
			
			AADD(aRet , {"E1_NUM"		, cNumTit	,	NIL})
			AADD(aRet , {"E1_TIPO"		, cTipo		,	NIL}) 
			AADD(aRet , {"E1_PREFIXO"	, "NCC"		,	NIL}) 	
			AADD(aRet , {"E1_NATUREZ"	, cNaturez	,	NIL})
			AADD(aRet , {"E1_CLIENTE"	, cCodCli	,	NIL})
			AADD(aRet , {"E1_LOJA"		, cLoja		,	NIL})
			AADD(aRet , {"E1_EMISSAO"	, dEmissao	,	NIL})
			AADD(aRet , {"E1_VENCTO"	, dVenc		,	NIL})
			AADD(aRet , {"E1_VENCREA"	, dVencReal	,	NIL})
			AADD(aRet , {"E1_VALOR"		, nValor	,	NIL})
			AADD(aRet , {"E1_VLCRUZ"	, nVlrCruz	,	NIL})
			AADD(aRet , {"E1_ZTPDESC"	, cTipodes	,	NIL})
	//- Demais Campos
	
	(cAliasTMP)->(dbCloseArea())                                                                            

Return aRet

/*
=====================================================================================
Programa.:              fRunRotAut
Autor....:              Luis Artuso
Data.....:              24/10/16
Descricao / Objetivo:   Preenche os campos obrigatorios para execucao do execauto FINA040
Doc. Origem:            Contrato - GAP VEN01
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
Static Function fRunRotAut( aItens , cRotAut)
    Local cError     := ''
	Local nOption	:= 0
	Local aLog		:= {}
	Local lRet		:= .F.

	Private lMsErroAuto := .F.	

	nOption		:= 3

	Begin Transaction

		Do Case

			Case ( AllTrim(cRotAut) == "FINA040" )

			MSExecAuto({|x,y| FINA040(x,y)} , aItens , nOption)   // SE1 Contas a Receber em aberto MESTRE

		End Case

		If ( lMsErroAuto )

			aLog := GetAutoGRLog()
			If (!IsBlind()) // COM INTERFACE GRÁFICA
			MostraErro()
		    Else // EM ESTADO DE JOB
		        cError := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO
		
		        ConOut(PadC("Automatic routine ended with error", 80))
		        ConOut("Error: "+ cError)
		    EndIf
			DisarmTransaction()

		Else

			lRet	:= .T.
			//Msalert("NCC gerada com sucesso.")

		EndIf

	End Transaction

Return lRet

/*
=====================================================================================
Programa.:              xMF10MkSZV
Autor....:              Luis Artuso
Data.....:              24/10/16
Descricao / Objetivo:   Marca o registro selecionado no browse, conforme filtro
Doc. Origem:            Contrato - GAP VEN01
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
Static Function xMF10MkSZV(lAll)

	Local lNotMark	:= !(oBrw:IsMark())
	Local cAliasBRW	:= oBrw:Alias()
	Local aAliasBRW	:= (cAliasBRW)->(GetArea())

	DEFAULT lAll	:= .F.

	RecLock( cAliasBRW , .F. )

	(cAliasBRW)->(ZZ3_MARK)	:= iIf( lNotMark , oBrw:Mark() , "")

	(cAliasBRW)->(MsUnlock())

	If !( lAll )

		oBrw:Refresh()

	EndIf

	RestArea(aAliasBRW)

Return

/*
=====================================================================================
Programa.:              xMF10AMkZV
Autor....:              Luis Artuso
Data.....:              24/10/16
Descricao / Objetivo:   Seleciona(marca) todos os registros
Doc. Origem:            Contrato - GAP VEN01
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
Static Function xMF10AMkZV()

	Local cAliasBRW	:= oBrw:Alias()

	(cAliasBRW)->(dbGoTop())

	Do While (cAliasBRW)->(!EOF())

		xMF10MkSZV(.T.)

		(cAliasBRW)->(dbSkip())

	EndDo

	(cAliasBRW)->(dbGoTop())

	oBrw:Refresh()

Return