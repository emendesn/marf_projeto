#INCLUDE "PROTHEUS.CH"

/*
=====================================================================================
Programa.:              MGFFIN03
Autor....:              Luis Artuso
Data.....:              22/09/2016
Descricao / Objetivo:   Funcao principal, para chamada via menu
Doc. Origem:            Contrato - GAP MGFFIN03
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
User Function MGFFIN03()

	fExibeTela()

Return


/*
=====================================================================================
Programa.:              fExibeTela
Autor....:              Luis Artuso
Data.....:              21/09/2016
Descricao / Objetivo:   Funcao chamadora da tela principal
Doc. Origem:            Contrato - GAP MGFFIN03
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
Static Function fExibeTela()

	Local oButton1
	Local oButton2
	Local oButton3
	Local oButton4
	Local cGet1		:= Space(50)
	Local dGet2		:= dDataBase
	Local dGet3		:= dDataBase
	Local oSay1
	Local oSay2
	Local cFields	:= ""
	Local cAliasTMP	:= ""
	Local aHeader	:= {}
	Local cStrTran	:= ""
	Local aDados	:= {}
	Local oWBrowse1
	Local oFont
	Local lCodBarra	:= .F.

	Private oDlg := Nil

	cStrTran	:= "SE2."

	cFields		:= "'.F.' AS MARK,  SE2.E2_FILIAL, SE2.E2_PREFIXO, SE2.E2_NUM, SE2.E2_PARCELA, SE2.E2_TIPO, SE2.E2_FORNECE, SE2.E2_LOJA, SE2.E2_NOMFOR, "
	cFields		+= "SE2.E2_EMISSAO, SE2.E2_VENCTO, SE2.E2_VENCREA, SE2.E2_VALOR, SE2.E2_ZNUMPRO, SE2.E2_SALDO, SE2.E2_CODBAR, SE2.E2_LINDIG, SE2.E2_NUMBOR, "
	cFields		+= "'' AS E2_APAGA, SE2.R_E_C_N_O_ REGISTRO "
	cAliasTMP	:= "SE2"

	cStrTran	:= "SE2."

	fMontaDados(cFields , cAliasTMP , @aHeader , @aDados , cStrTran , .F.)

	DEFINE FONT oFont NAME "ARIAL" SIZE 6,15 BOLD

/*	DEFINE MSDIALOG oDlg TITLE "Localizador de Títulos" FROM 000, 000  TO 430, 1250 COLORS 0, 16777215 PIXEL

		@ 004 , 003 TO 212 , 622 LABEL "Seleção de Títulos para gravação de código de barras" PIXEL OF oDlg
		@ 018, 008 SAY oSay1 PROMPT " Digite o Codigo de barras :" SIZE 070, 007 OF oDlg COLORS 0, 16777215 PIXEL FONT oFont
		@ 016, 080 MSGET oGet1 VAR cGet1 SIZE 160, 010 OF oDlg COLORS 0, 16777215 PIXEL
		@ 015, 250 BUTTON oButton1 PROMPT "Pesquisar" SIZE 037, 015 OF oDlg PIXEL ACTION fGeraQry(cFields , @aDados , @cGet1, oDlg , oWBrowse1 , @lCodBarra)
		fWBrowse1(aHeader , @aDados , oDlg , @oWBrowse1 , .F.)
		@ 190, 495 BUTTON oButton2 PROMPT "&Limpa Pesquisa" SIZE 042, 20 OF oDlg PIXEL ACTION fVldGrava(aHeader , @aDados , oDlg , @oWBrowse1 , @cGet1 , .T. , lCodBarra)
		@ 190, 540 BUTTON oButton3 PROMPT "&Grava o Título" SIZE 038, 20 OF oDlg PIXEL ACTION fVldGrava(aHeader , @aDados , oDlg , @oWBrowse1 , @cGet1 , .F. , lCodBarra)
		@ 190, 580 BUTTON oButton4 PROMPT "&Encerra" SIZE 038, 20 OF oDlg PIXEL ACTION oDlg:End()

	ACTIVATE MSDIALOG oDlg CENTERED
*/
	DEFINE MSDIALOG oDlg TITLE "Localizador de Títulos" FROM 000, 000  TO 430, 1250 COLORS 0, 16777215 PIXEL

		@ 004, 003 TO 212 , 622 LABEL "Seleção de Títulos para gravação de código de barras" PIXEL OF oDlg
		@ 018, 008 SAY oSay1 PROMPT " Digite o Codigo de barras :" SIZE 070, 007 OF oDlg COLORS 0, 16777215 PIXEL FONT oFont
		@ 018, 260 SAY oSay2 PROMPT " Vencto de :" SIZE 040, 007 OF oDlg COLORS 0, 16777215 PIXEL FONT oFont
		@ 018, 370 SAY oSay2 PROMPT " Vencto até :" SIZE 040, 007 OF oDlg COLORS 0, 16777215 PIXEL FONT oFont
		@ 016, 080 MSGET oGet1 VAR cGet1 SIZE 160, 010 OF oDlg COLORS 0, 16777215 PIXEL
		@ 016, 300 MSGET oGet2 VAR dGet2 SIZE 60, 010 OF oDlg COLORS 0, 16777215 PIXEL
		@ 016, 410 MSGET oGet3 VAR dGet3 SIZE 60, 010 OF oDlg COLORS 0, 16777215 PIXEL
		@ 015, 480 BUTTON oButton1 PROMPT "Pesquisar" SIZE 037, 015 OF oDlg PIXEL ACTION fGeraQry(cFields , @aDados , @cGet1, @dGet2, @dGet3, oDlg , oWBrowse1 , @lCodBarra)
		fWBrowse1(aHeader , @aDados , oDlg , @oWBrowse1 , .F.)
		@ 190, 495 BUTTON oButton2 PROMPT "&Limpa Pesquisa" SIZE 042, 20 OF oDlg PIXEL ACTION fVldGrava(aHeader , @aDados , oDlg , @oWBrowse1 , @cGet1 , .T. , lCodBarra)
		@ 190, 540 BUTTON oButton3 PROMPT "&Grava o Título" SIZE 038, 20 OF oDlg PIXEL ACTION fVldGrava(aHeader , @aDados , oDlg , @oWBrowse1 , @cGet1 , .F. , lCodBarra)
		@ 190, 580 BUTTON oButton4 PROMPT "&Encerra" SIZE 038, 20 OF oDlg PIXEL ACTION oDlg:End()

	ACTIVATE MSDIALOG oDlg CENTERED

Return

/*
=====================================================================================
Programa.:              fWBrowse1
Autor....:              Luis Artuso
Data.....:              21/09/2016
Descricao / Objetivo:   Atualiza o array 'aDados', que sera exibido na MarkBrowse
Doc. Origem:            Contrato - GAP MGFFIN03
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
Static Function fWBrowse1(aHeader , aDados , oDlg, oWBrowse1 , lAtuDados)

	Local aBrowse 	:= {}
	Local nX		:= 0
	Local nY		:= 0
	Local nPosArray	:= 0
	Local oOK		:= LoadBitmap(GetResources(),"LBOK")
	Local oNO		:= LoadBitmap(GetResources(),"LBNO")

	aBrowse	:= aClone(aDados)

	If !( lAtuDados )
		// Neste caso, somente o array 'aHeader' deve ser gerado
		// Ordem dos campos contidos em 'aHeader'

		@ 035, 007 LISTBOX oWBrowse1 Fields HEADER aHeader[++nPosArray],;// lMark
			aHeader[++nPosArray],; // Ident Baixa
			aHeader[++nPosArray],; // Prefixo
			aHeader[++nPosArray],; // No. Titulo
			aHeader[++nPosArray],; // Parcela
			aHeader[++nPosArray],; // Fornecedor
			aHeader[++nPosArray],; // Loja
			aHeader[++nPosArray],; // Nome Forne
			aHeader[++nPosArray],; // Dt. Emissao
			aHeader[++nPosArray],; // Vencimento
			aHeader[++nPosArray],; // Vencto. Real
			aHeader[++nPosArray],; // Vlr. Titulo
			aHeader[++nPosArray],; // Saldo
			aHeader[++nPosArray];  // Cod.Barras
			SIZE 610 , 150 OF oDlg PIXEL ColSizes 20,35,25,30,25,40,20,80,40,40,40,40,40

		oWBrowse1:SetArray(aBrowse)

		oWBrowse1:bLine := {|| {;
			If(aBrowse[oWBrowse1:nAt,01],oOK,oNO),;
				aBrowse[oWBrowse1:nAt,02],;
				aBrowse[oWBrowse1:nAt,03],;
				aBrowse[oWBrowse1:nAt,04],;
				aBrowse[oWBrowse1:nAt,05],;
				aBrowse[oWBrowse1:nAt,06],;
				aBrowse[oWBrowse1:nAt,07],;
				aBrowse[oWBrowse1:nAt,08],;
				aBrowse[oWBrowse1:nAt,09],;
				aBrowse[oWBrowse1:nAt,10],;
				aBrowse[oWBrowse1:nAt,11],;
				aBrowse[oWBrowse1:nAt,12],;
				aBrowse[oWBrowse1:nAt,13],;
				aBrowse[oWBrowse1:nAt,14],;
			}}
		// DoubleClick event
		//oWBrowse1:bLDblClick := {|| aBrowse[oWBrowse1:nAt,1] := !aBrowse[oWBrowse1:nAt,1],;
		oWBrowse1:bLDblClick := {|| fMarkBrw(@aBrowse,,oWBrowse1:nAt),;
		oWBrowse1:DrawSelect()}

	Else

		oWBrowse1:SetArray(aBrowse)

		oWBrowse1:bLine := {|| {;
			If(aBrowse[oWBrowse1:nAt,01],oOK,oNO),;
				aBrowse[oWBrowse1:nAt,02],;
				aBrowse[oWBrowse1:nAt,03],;
				aBrowse[oWBrowse1:nAt,04],;
				aBrowse[oWBrowse1:nAt,05],;
				aBrowse[oWBrowse1:nAt,06],;
				aBrowse[oWBrowse1:nAt,07],;
				aBrowse[oWBrowse1:nAt,08],;
				aBrowse[oWBrowse1:nAt,09],;
				aBrowse[oWBrowse1:nAt,10],;
				aBrowse[oWBrowse1:nAt,11],;
				aBrowse[oWBrowse1:nAt,12],;
				aBrowse[oWBrowse1:nAt,13],;
				aBrowse[oWBrowse1:nAt,14],;
				aBrowse[oWBrowse1:nAt,15];
			}}
		// DoubleClick event
		//oWBrowse1:bLDblClick := {|| aBrowse[oWBrowse1:nAt,1] := !aBrowse[oWBrowse1:nAt,1],;
		oWBrowse1:bLDblClick := {|| fMarkBrw(@aBrowse,oWBrowse1:nAt),;
		oWBrowse1:DrawSelect()}

		oWBrowse1:Refresh()

	EndIf

Return


Static Function fMarkBrw(aBrowse,nAt)

nAt	:= IIF(nAt==NIL,1,nAt)

If !(nAt == 1 .And. Empty(aBrowse[nAt,4]))

	If !aBrowse[nAt,1] .And. !Empty(aBrowse[nAt,18])
		MsgAlert('Título em borderô, não pode ser selecionado!')
	Else
		aBrowse[nAt,1] := !aBrowse[nAt,1]
	EndIf

EndIf

Return

/*
=====================================================================================
Programa.:              fGeraQry
Autor....:              Luis Artuso
Data.....:              15/09/2016
Descricao / Objetivo:   Gera a Query para avaliar se ha titulos para o codigo de barras informado
Doc. Origem:            Contrato - GAP MGFFIN03
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
Static Function fGeraQry(	cFields		,; // String contendo os campos que serao utilizados para a query e o aHeader da MarkBrowse
							aDados		,; // Este array sera preenchido com o conteudo da Query, caso exista(m) tituluos para o codigo de barras.
							cCodBarra	,; // Codigo de barras para pesquisa
							dVctode     ,; // Data de vencimento inicial
							dVctoAte    ,; // Data de vencimento final
							oDlg		,;
							oWBrowse1 	,;
							lCodBarra 	 ; // Retorna se o conteudo digitado e' um codigo de barras ou linha digitavel do titulo
						)

	Local cQuery	:= ""
	Local cFrom		:= ""
	Local cWhere	:= ""
	Local cAliasTMP	:= ""
	Local lRet		:= .F.
	Local aAreaSE2	:= {}
	Local cAliasSE2	:= ""
	Local nValArred	:= 0
	Local aHeader	:= {}
	Local cStrTran	:= ""
	Local cVcto		:= "" //Recupera as 4 primeiras posicoes do campo pertinente ao vencimento (ultimo bloco do codigo de barras)
	Local cValor	:= "" //Recupera as 10 Ultimas posicoes do campo pertinente ao vencimento  (ultimo bloco do codigo de barras)
	Local dDataBco	:= "" //Calcula-se o numero de dias corridos entre a data base (Fixa em 07/10/1997, conf. BACEN) e a data do vencimento desejado:
	Local dDataCob	:= ""
	Local cValMIn	:= ""
	Local cValMax	:= ""
	Local lExistCod	:= .F. // Valida se o titulo nao tem codigo de barras gravado anteriormente. Caso positivo, bloqueia a gravacao.
	Local cCodTit	:= ""
	Local aBrowse 	:= {}
	Local cCodTmp	:= ""
	Local lDisp	    := .F.
	Local lOk       := .F.
	Local cBarTmp   := ""

  	// Paulo Henrique - TOTVS - 15/08/2019 - Verifica se o código de barras existe
	lOk := fVerCodBar(cCodBarra)
	
	If lOk
		cCodBarra := Space(50)
		aDados	  := Array(1,15)
		fWBrowse1(aHeader , @aDados , oDlg , oWBrowse1 , .T.) //Atualizo o browser conforme resultset gerado pela Query
		Return(lRet)
	EndIf		   

	dDataBco	:= cToD('07/10/1997')

	cAliasSE2	:= "SE2"
	aAreaSE2	:= (cAliasSE2)->(GetArea())

	nValArred	:= SuperGetMv("MGF_E2ARRE" , NIL , 0)

	cQuery		:= "SELECT "
	cFrom		:= "FROM " + RetSqlName(cAliasSE2) + " SE2 "
	
	lCodBarra	:= Len(AllTrim(cCodBarra)) == 44

	If ( lCodBarra )
		cVcto		:= SubStr(cCodBarra , 6 , 4)
		cValor		:= SubStr(cCodBarra , 10 , 10)
	Else

		cCodTMP		:= Right(AllTrim(cCodBarra) , 14) // Retira o ultimo bloco do codigo de barras

		cCodBarra	:= StrTran(cCodBarra , "-" , "") // Elimina '-'
		cCodBarra	:= StrTran(cCodBarra , "." , "") // Elimina '.'
		cCodBarra	:= StrTran(cCodBarra , " " , "") // Elimina espacos

		cVcto		:= Left(cCodTMP,4)
		cValor		:= Right(cCodTMP,10)

	EndIf

	dDataCob	:= DaySum(dDataBco , Val(cVcto))
	cValMin		:= StrZero(Val(cValor) / 100 - nValArred , 12 , 2)
	cValMax		:= StrZero(Val(cValor) / 100 + nValArred , 12 , 2)

	cWhere	:= "WHERE "
	cWhere	+= "SE2.E2_SALDO > 0 "
	//cWhere	+=		"AND ( SE2.E2_VENCTO = '" + dToS( dDataCob ) + "' OR SE2.E2_VENCREA = '" + dToS( dDataCob ) + "' )"
	If Empty(dVctode) .AND. Empty(dVctoAte)
	// 13/03/2018 - Atilio - Incluir tratamento para data = feriado. Incluir prï¿½ximo dia ï¿½til (resultado de DataValida())
		cWhere	+=		"AND ( SE2.E2_VENCTO IN ('" + dToS( dDataCob ) + "','" + dToS( DataValida(dDataCob,.T.) ) + "') "
		cWhere	+=				"OR SE2.E2_VENCREA IN ('" + dToS( dDataCob ) + "','" + dToS( DataValida(dDataCob,.T.) ) + "' )  )"
	Else
	// 04/05/2018 - Barbieri - Tratamento para buscar a data de vencto informado em tela
		cWhere	+= "AND ( SE2.E2_VENCTO BETWEEN '" + dToS( dVctode ) + "' AND '" + dToS( dVctoAte ) + "' "
		cWhere  += "OR SE2.E2_VENCTO BETWEEN '" + dToS( DataValida(dVctode,.T.) ) + "' AND '" + dToS( dVctoAte ) + "' "
		cWhere	+= "OR SE2.E2_VENCREA BETWEEN '" + dToS( dVctode ) + "' AND '" + dToS( dVctoAte ) + "' "
		cWhere  += "OR SE2.E2_VENCREA BETWEEN '" + dToS( DataValida(dVctode,.T.) ) + "' AND '" + dToS( dVctoAte ) + "' ) "
	Endif
	//cWhere	+=		"AND SE2.E2_SALDO+E2_SDACRES-E2_SDDECRE BETWEEN " + cValMin + " AND " + cValMax + " "
	cWhere	+=		"AND (E2_SALDO + E2_SDACRES) - (E2_SDDECRE + E2_COFINS + E2_PIS + E2_CSLL) BETWEEN " + cValMin + " AND " + cValMax + " "
	cWhere	+=		"AND SE2.D_E_L_E_T_ <> '*' "

	//MEMOWRITE("C:\TEMP\"+FunName()+"-"+DTOS(dDataBase)+"-"+StrTran(Time(),":")+".SQL",cQuery + cFields + cFrom + cWhere)

	If Val(cValor) > 0
		cAliasTMP	:= GetNextAlias()
		dbUseArea(.T. , "TOPCONN" , TcGenQry(,,cQuery + cFields + cFrom + cWhere) , cAliasTMP , .F. , .T.)
		lRet		:= (cAliasTMP)->(!EOF())
	EndIf

	cFields	:= StrTran(cFields , ' AS ' , ' ')
	cFields	:= StrTran(cFields , "''" , '')
	cFields	:= StrTran(cFields , ',  ' , ', ')
	cFields	:= StrTran(cFields , ', ' , ',')
	cFields	:= StrTran(cFields , 'SE2.' , '')
	cFields	:= StrTran(cFields , 'R_E_C_N_O_ ' , '')

	If ( lRet )

		lExistCod	:= fMontaDados(cFields , cAliasTMP , @aHeader , @aDados , cStrTran , .T. , @cCodTit , cCodBarra , @lDisp , lCodBarra)

		Do Case
			Case ( lExistCod )
				MsgAlert('Este código de barra já existe no Título : ' +  cCodTit)
				cCodBarra := Space(50)
				aDados	  := Array(1,15)
			Case !( lDisp )
				MsgAlert('Nao existem Títulos disponíveis para este código de barras')
				cCodBarra := Space(50)
				aDados	  := Array(1,15)
		EndCase

		fWBrowse1(aHeader , @aDados , oDlg , oWBrowse1 , .T.) //Atualizo o browser conforme resultset gerado pela Query
		aBrowse	:= aClone(aDados)
		(cAliasTMP)->(dbCloseArea())
		RestArea(aAreaSE2)

	Else

		MsgAlert('não existem Títulos para o código de barras informado')
		aDados		:= Array(1,15)
		cCodBarra	:= Space(50)
		fWBrowse1(aHeader , aDados , oDlg , oWBrowse1 , .T.)

	EndIf

Return lRet

/*
=====================================================================================
Programa.:              fMontaDados
Autor....:              Luis Artuso
Data.....:              15/09/2016
Descricao / Objetivo:   Monta aHeader e aCols para serem exibidos na MarkBrowse
Doc. Origem:            Contrato - GAP MGFFIN03
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
Static Function fMontaDados(cFields		,;	//Campos utilizados para montagem do aHeader (Utilizados para montagem da Query)
							cAliasTMP	,;	//Alias temporario utilizado pela Query
							aHeader		,; 	//Neste array, serao salvos os campos com os respectivos titulos, conforme definido em dicionario (SX3)
							aDados		,;	//Neste Array, serao retornados os dados para exibicao na markbrowse
							cStrTran	,;	//Sera utilizado para eliminar o alias temporario contido na variavel 'cFields'
							lGeraDados	,;	//Se gera o array com 'ResultSet' da Query
							cCodTit	,;	//Caso o codigo de barras ja tenha sido cadastrado, retorna o titulo e informa ao usuario
							cCodBarra	,;	//Caso o codigo de barras ja tenha sido cadastrado, retorna o titulo e informa ao usuario
							lDisp		,;	// Verifica se ha titulos disponiveis para o codigo de barras informado
							lCodBarra	)	// Se codigo digitado e' codigo de barras ou linha digitavel

	Local nLen		:= 0
	Local nReg		:= 0
	Local nY		:= 0
	Local nPosRecno	:= 0
	Local cNameField:= ""
	Local nX		:= 0
	Local aHeadTMP	:= {}
	Local aDadosTMP	:= {}
	Local xConverte	:= NIL
	Local nPosCodBar:= 0
	Local nPosCodDig:= 0
	Local nPosCodTit:= 0
	Local nPosApaga	:= 0
	Local lExistCod	:= .F.
	Local nLoop		:= 0
	Local nPosMark	:= 0

	DEFAULT aHeader	:= {}

	aHeader	:= StrToKarr(StrTran(cFields , cStrTran , "") , ',')
	//Armazena em 'aHeader' os campos contidos em cFields, eliminando o alias gerado para query (ex.: SE2.E2_OK, e' alterado para E2_OK)

	nLen	:= Len(aHeader)
	// Desconsiderar as 2 ultimas posicoes por tratar-se de:
	// 16 -> Indica se o registro deve aparecer no browser, uma vez que o codigo de barra ja esta gravado
	// 17 -> RECNO, que sera' utilizado para indicar qual registro sera' gravado.

	If ( lGeraDados )

		nPosCodBar	:= Ascan(aHeader , "E2_CODBAR")
		nPosCodDig	:= Ascan(aHeader , "E2_LINDIG")
		nPosCodTit	:= Ascan(aHeader , "E2_NUM")
		nPosRecno	:= Ascan(aHeader , "REGISTRO")
		nPosApaga	:= Ascan(aHeader , "E2_APAGA")
		nPosMark	:= 1

		If ( Len(aDados) > 0 )

			aDados	:= Array(1,nLen)

		EndIf

		Do While (cAliasTMP)->(!EOF())

			//Grava em aDados o conteudo do alias temporario gerado atraves da query, para exibicao na markbrowse
			++nReg

			aDados[nReg]	:= Array(nLen) // Posicao adicional criada para armazenar '.F.' (exibir no browse como desmarcado)

			aDados[nReg , nPosMark] := .F. // Falso para permitir 'check' no browse

			aDados[nReg , nPosRecno] := (cAliasTMP)->(REGISTRO)

			aDados[nReg , nPosApaga] := .F. // Se o codigo de barra pesquisado ja tiver sido cadastrado anteriormente, nao sera exibido no browse.

			nLoop	:= nLen - 2

			For nY := 2 TO nLoop

				//A ultima posicao de 'aHeader' refere-se ao Recno, portanto, nao preencher com o titulo (conforme dicionario).

				aDados[nReg , nY] := FieldGet((cAliasTMP)->(FieldPos(AllTrim(aHeader[nY]))))

				Do Case

					Case ( TamSx3(FieldName(FieldPos(AllTrim(aHeader[nY]))))[3] == 'N')

						xConverte	:= Transform(aDados[nReg , nY] ,"@E 999,999,999.99")

						aDados[nReg , nY]	:= xConverte

					Case ( TamSx3(FieldName(FieldPos(AllTrim(aHeader[nY]))))[3] == 'D' )

						xConverte	:= sToD(aDados[nReg , nY])

						aDados[nReg , nY]	:= xConverte

				End Case

			Next

			If !( lExistCod )

				If ( (!(Empty(aDados[nReg , nPosCodBar]))) .OR. (!(Empty(aDados[nReg , nPosCodDig]))) )

					aDados[nReg , nPosApaga] := .T.

					If ( lCodBarra )

						//- Se preenchido o codigo de barras, exibe o conteudo no campo 'Cod. de Barras' no Browse
						If ( AllTrim(aDados[nReg , nPosCodBar]) == AllTrim(cCodBarra) )
							lExistCod	:= .T.
						EndIf

					Else

						//- Se preenchida a linha digitavel, exibe o conteudo no campo 'Cod. de Barras' no Browse
						If ( AllTrim(aDados[nReg , nPosCodDig]) == AllTrim(cCodBarra) )

							lExistCod	:= .T.

						EndIf

					EndIf

					If ( lExistCod )

						cCodTit	:= aDados[nReg , nPosCodTit]

					EndIf

				Else

					lDisp	:= .T.

				EndIf

			EndIf

			(cAliasTMP)->(dbSkip())

			If ((cAliasTMP)->(!EOF()))

				AADD(aDados , {} )

			EndIf

		EndDo

		nLen		:= Len(aDados)

		For nX := 1 TO nLen

			If ( (ValType(aDados[nX , nPosApaga]) == "L") .AND. !( aDados[nX , nPosApaga] ) )

				AADD(aDadosTMP , aClone(aDados[nX]))

			EndIf

		Next nX

		If ( Len(aDadosTMP) > 0 )

			aDados	:= {}

			aDados	:= aClone(aDadosTMP)

		EndIf

	Else

		aDados	:= Array(1 , nLen)

	EndIf

	aHeadTMP	:= Array(nLen)

	For nX := 1 TO Min(nLen,Len(aHeader))
		//Substitui o conteudo de aHeader pelo titulo contido no dicionario (SX3). Ex.: E2_PREFIXO e' alterado para 'Prefixo'.

		If ( nX == 1 )

			aHeadTMP[nX] := ''

		Else

			cNameField	:= AllTrim(RetTitle(AllTrim(aHeader[nX])))

			aHeadTMP[nX] := cNameField

		EndIf

	Next nX

	aHeader	:= aClone(aHeadTMP)

Return lExistCod

/*
=====================================================================================
Programa.:              fVldGrava
Autor....:              Luis Artuso
Data.....:              19/09/2016
Descricao / Objetivo:   Verifica a quantidade de titulos selecionados.
Doc. Origem:            Contrato - GAP MGFFIN03
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
Static Function fVldGrava(aHeader , aDados , oDlg , oWBrowse1 , cCodBarra , lLimpaSel , lCodBarra)

	Local lContinua	:= .F.
	Local aGrava	:= {}
	Local nLen		:= 0
	Local nReg		:= 0

	If !(lLimpaSel)

		aGrava	:= aClone(OWBROWSE1:AARRAY)

		If ( MsgYesNo("Confirma a Seleção?" , "Seleção de Títulos") )

			lContinua	:= fVldSel(aGrava , @nReg )

			If ( lContinua )

				fGrava(cCodBarra , nReg , lCodBarra)

				cCodBarra	:= Space(50)

				//- Limpa e reinicia o browse para as proximas pesquisas

				cCodBarra	:= Space(50)
				nLen		:= Len(aHeader)
				aDados		:= Array(1 , nLen)

				fWBrowse1(aHeader , @aDados , oDlg , @oWBrowse1 , .T.)

			EndIf

		Else

			nLen		:= Len(aHeader)
			aDados		:= Array(1 , nLen)
			cCodBarra	:= Space(50)

			fWBrowse1(aHeader , @aDados , oDlg , @oWBrowse1 , .T.)

		EndIf

	Else

		nLen		:= Len(aHeader)
		aDados		:= Array(1 , nLen)
		cCodBarra	:= Space(50)

		fWBrowse1(aHeader , @aDados , oDlg , @oWBrowse1 , .T.)

	EndIf

Return

/*
=====================================================================================
Programa.:              fVldSel
Autor....:              Luis Artuso
Data.....:              19/09/2016
Descricao / Objetivo:   Verifica a quantidade de titulos selecionados.
Doc. Origem:            Contrato - GAP MGFFIN03
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
Static Function fVldSel(aDados , nReg)

	Local nX		:= 0
	Local nLen		:= 0
	Local nCount	:= 0
	Local lRet		:= .F.
	Local nPosReg	:= 0

	nLen	:= Len(aDados)

	nPosReg	:= Len(aDados[1]) //Retorna posicao referente ao Recno

	Do While ( ++nX <= nLen .AND. (nCount <= 2) )

		If ( (aDados[nX , 1]) .AND. !(ValType(aDados[nX , 2]) == "U") ) // Item selecionado sem pesquisa do codigo de barras. Prevencao de gravacao incorreta.

			++nCount

			nReg	:= aDados[nX , nPosReg]

		EndIf

	EndDo

	Do Case

		Case ( nCount == 0 )

			MsgAlert('Nenhum Título foi selecionado')

		Case ( nCount == 1 )

			lRet	:= .T.

		OtherWise

			MsgAlert('Somente um titulo pode ser selecionado')

	EndCase

Return lRet

/*
=====================================================================================
Programa.:              fGrava
Autor....:              Luis Artuso
Data.....:              19/09/2016
Descricao / Objetivo:   Atualiza o campo E2_CODBAR
Doc. Origem:            Contrato - GAP MGFFIN03
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
Static Function fGrava(cCodBarra , nReg , lCodBarra)

	Local cAliasSE2	:= ""
	Local aAreaSE2	:= {}
	Local nValCod	:= 0
	Local nValDif	:= 0
	Local cCodDig	:= ""
	Local lCodOk	:= .F.
	Local nToler	:= SuperGetMv("MGF_E2TOLE" , NIL , 0.05) //0.05
	Local cTvalAcr  := SuperGetMv("MGF_TPACRE" , NIL , "014")
	Local cTvalDec  := SuperGetMv("MGF_TPDECR" , NIL , "521")

	If ( lCodBarra )
		nValCod		:= Val(SubStr(cCodBarra , 10 , 10)) / 100
	Else
		nValCod		:= Val(Right(cCodBarra , 10)) / 100
	EndIf

	cAliasSE2	:= "SE2"

	aAreaSE2	:= (cAliasSE2)->(GetArea())

	(cAliasSE2)->(dbGoTo(nReg))

	If ( lCodBarra )
		lCodOk	:= fCodBar(cCodBarra)
	Else
		cCodDig	:= fConVld(cCodBarra)

		If ( !Empty(cCodDig) )
			lCodOk	:= .T.
		EndIf
	EndIf

	If ( lCodOk ) .AND. ( RecLock( cAliasSE2 , .F.) )

		// Alteraï¿½ï¿½o solicitada pelo Eric em 21/05/2018
		(cAliasSE2)->(E2_DATAAGE) := (cAliasSE2)->(E2_VENCREA)

		If ( lCodBarra )
			(cAliasSE2)->(E2_CODBAR) := cCodBarra
		Else
			(cAliasSE2)->(E2_LINDIG) := cCodBarra
			(cAliasSE2)->(E2_CODBAR) := cCodDig
		EndIf

		Do Case
			Case ( nValCod < ((cAliasSE2)->(E2_SALDO + E2_SDACRES) - (cAliasSE2)->(E2_SDDECRE + E2_COFINS + E2_PIS + E2_CSLL)) )

				nValDif	:= ( nValCod - ((cAliasSE2)->(E2_SALDO + E2_SDACRES) - (cAliasSE2)->(E2_SDDECRE + E2_COFINS + E2_PIS + E2_CSLL)) )

				If nValDif != 0 .and. Abs(nValDif) <= nToler
					(cAliasSE2)->(E2_DECRESC)	:= IIf((cAliasSE2)->(E2_DECRESC) <= nToler,Abs(nValDif),(cAliasSE2)->(E2_DECRESC) + Abs(nValDif))
					(cAliasSE2)->(E2_SDDECRE)	:= (cAliasSE2)->(E2_DECRESC)

					dbSelectArea('ZDS')
					ZDS->(dbSetOrder(1))
						Reclock("ZDS",.T.)
			            ZDS->ZDS_FILIAL := (cAliasSE2)->(E2_FILIAL)
			            ZDS->ZDS_PREFIX := (cAliasSE2)->(E2_PREFIXO)
			            ZDS->ZDS_NUM    := (cAliasSE2)->(E2_NUM)
			            ZDS->ZDS_PARCEL := (cAliasSE2)->(E2_PARCELA)
			            ZDS->ZDS_TIPO   := (cAliasSE2)->(E2_TIPO)
			            ZDS->ZDS_FORNEC := (cAliasSE2)->(E2_FORNECE)
			            ZDS->ZDS_LOJA   := (cAliasSE2)->(E2_LOJA)
			            ZDS->ZDS_COD    := cTvalDec
			            ZDS->ZDS_VALOR  := (cAliasSE2)->(E2_SDDECRE)
			        ZDS->(MsUnlock())
				Endif
			Case ( nValCod > ((cAliasSE2)->(E2_SALDO + E2_SDACRES) - (cAliasSE2)->(E2_SDDECRE + E2_COFINS + E2_PIS + E2_CSLL)) )

				nValDif	:= ( nValCod - ((cAliasSE2)->(E2_SALDO + E2_SDACRES) - (cAliasSE2)->(E2_SDDECRE + E2_COFINS + E2_PIS + E2_CSLL)) )
				If nValDif != 0 .and. Abs(nValDif) <= nToler
					(cAliasSE2)->(E2_ACRESC)	:= IIf((cAliasSE2)->(E2_ACRESC) <= nToler,Abs(nValDif),(cAliasSE2)->(E2_ACRESC) + Abs(nValDif))
					(cAliasSE2)->(E2_SDACRES)	:= (cAliasSE2)->(E2_ACRESC)

					dbSelectArea('ZDS')
					ZDS->(dbSetOrder(1))
						Reclock("ZDS",.T.)
			            ZDS->ZDS_FILIAL := (cAliasSE2)->(E2_FILIAL)
			            ZDS->ZDS_PREFIX := (cAliasSE2)->(E2_PREFIXO)
			            ZDS->ZDS_NUM    := (cAliasSE2)->(E2_NUM)
			            ZDS->ZDS_PARCEL := (cAliasSE2)->(E2_PARCELA)
			            ZDS->ZDS_TIPO   := (cAliasSE2)->(E2_TIPO)
			            ZDS->ZDS_FORNEC := (cAliasSE2)->(E2_FORNECE)
			            ZDS->ZDS_LOJA   := (cAliasSE2)->(E2_LOJA)
			            ZDS->ZDS_COD    := cTvalAcr
			            ZDS->ZDS_VALOR  := (cAliasSE2)->(E2_SDACRES)
			        ZDS->(MsUnlock())
				Endif

		End Case

		If Empty(nValCod) .and. !Empty(cCodBarra) // nao veio valor no codigo de barras
			(cAliasSE2)->(E2_ZCONTRA) := "2" // contra-apresentacao
		Elseif !Empty(nValCod)
			(cAliasSE2)->(E2_ZCONTRA) := "1" // normal
		Endif

		(cAliasSE2)->(MsUnlock())

		MsgAlert('código de barras gravado com sucesso no Título : ' + (cAliasSE2)->(E2_NUM))

	EndIf

	RestArea(aAreaSE2)

Return

///--------------------------------------------------------------------------\
//| Funï¿½ï¿½o: fConVld				Autor: Flï¿½vio Novaes		Data: 19/10/2003 |
//|--------------------------------------------------------------------------|
//| Descriï¿½ï¿½o: Funï¿½ï¿½o para Conversï¿½o da Representaï¿½ï¿½o Numï¿½rica do código de  |
//|            Barras - Linha Digitï¿½vel (LD) em código de Barras (CB).       |                                                                          |
//\--------------------------------------------------------------------------/
Static FUNCTION fConVld(cCodBarra)
	Local lCodOk	:= .F.

	SETPRVT("cStr")

	cStr := LTRIM(RTRIM(cCodbarra))

	IF VALTYPE(cCodbarra) == NIL .OR. EMPTY(cCodbarra)
		// Se o Campo estï¿½ em Branco não Converte nada.
		cStr := ""
	ELSE
		// Se o Tamanho do String for menor que 44, completa com zeros até 47 dï¿½gitos. Isso ï¿½
		// necessï¿½rio para Bloquetos que não tï¿½m o vencimento e/ou o valor informados na LD.
		cStr := IF(LEN(cStr)<44,cStr+REPL("0",47-LEN(cStr)),cStr)
	ENDIF

	DO CASE
		CASE LEN(cStr) == 47
			cStr := SUBSTR(cStr,1,4)+SUBSTR(cStr,33,15)+SUBSTR(cStr,5,5)+SUBSTR(cStr,11,10)+SUBSTR(cStr,22,10)
		CASE LEN(cStr) == 48
		   cStr := SUBSTR(cStr,1,11)+SUBSTR(cStr,13,11)+SUBSTR(cStr,25,11)+SUBSTR(cStr,37,11)
		OTHERWISE
			cStr := cStr+SPACE(48-LEN(cStr))
	ENDCASE

	lCodOk	:= fCodBar(cStr)

	If !(lCodOk)
		cStr	:= ""
	EndIf

RETURN(cStr)

///--------------------------------------------------------------------------\
//| Funï¿½ï¿½o: fCodBar				Autor:         		Data:
//|--------------------------------------------------------------------------|
//             |
//|--------------------------------------------------------------------------|
//| Descriï¿½ï¿½o: Funï¿½ï¿½o para Validaï¿½ï¿½o de código de Barras (CB) e Representaï¿½ï¿½o|
//|            Numï¿½rica do código de Barras - Linha Digitï¿½vel (LD).          |
//|                                                                          |
//|            A LD de Bloquetos possui trï¿½s Digitos Verificadores (DV) que  |
//|				sï¿½o consistidos pelo Mï¿½dulo 10, alï¿½m do Dï¿½gito Verificador   |
//|				Geral (DVG) que ï¿½ consistido pelo Mï¿½dulo 11. Essa LD tï¿½m 47  |
//|            Dï¿½gitos.                                                      |
//|                                                                          |
//|            A LD de Títulos de Concessinï¿½rias do Serviï¿½o Pï¿½blico e IPTU   |
//|				possui quatro Digitos Verificadores (DV) que sï¿½o consistidos |
//|            pelo Mï¿½dulo 10, alï¿½m do Digito Verificador Geral (DVG) que    |
//|            tambï¿½m ï¿½ consistido pelo Mï¿½dulo 10. Essa LD tï¿½m 48 Dï¿½gitos.   |
//|                                                                          |
//|            O CB de Bloquetos e de Títulos de Concessionï¿½rias do Serviï¿½o  |
//|            Pï¿½blico e IPTU possui apenas o Dï¿½gito Verificador Geral (DVG) |
//|            sendo que a ï¿½nica diferenï¿½a ï¿½ que o CB de Bloquetos ï¿½         |
//|            consistido pelo Mï¿½dulo 11 enquanto que o CB de Títulos de     |
//|            Concessionï¿½rias ï¿½ consistido pelo Mï¿½dulo 10. Todos os CBï¿½s    |
//|            tï¿½m 44 Dï¿½gitos.                                               |
//\--------------------------------------------------------------------------/

Static Function fCodBar(cCodBarra)

LOCAL I
Local lGPS := .F.
SETPRVT("cStr,lRet,cTipo,nConta,nMult,nVal,nDV,cCampo,i,nMod,nDVCalc")

// Retorna .T. se o Campo estiver em Branco.
IF VALTYPE(cCodbarra) == NIL .OR. EMPTY(cCodbarra)
	RETURN(.T.)
ENDIF

cStr := LTRIM(RTRIM(cCodbarra))

// Se o Tamanho do String for 45 ou 46 estï¿½ errado! Retornarï¿½ .F.
lRet := IF(LEN(cStr)==45 .OR. LEN(cStr)==46,.F.,.T.)

// Se o Tamanho do String for menor que 44, completa com zeros até 47 dï¿½gitos. Isso ï¿½
// necessï¿½rio para Bloquetos que não tï¿½m o vencimento e/ou o valor informados na LD.
cStr := IF(LEN(cStr)<44,cStr+REPL("0",47-LEN(cStr)),cStr)

// Verifica se a LD ï¿½ de (B)loquetos ou (C)oncessionï¿½rias/IPTU. Se for CB retorna (I)ndefinido.
cTipo := IF(LEN(cStr)==47,"B",IF(LEN(cStr)==48,"C","I"))

// Verifica se todos os dï¿½gitos sï¿½o numï¿½rios.
FOR i := LEN(cStr) TO 1 STEP -1
	lRet := IF(SUBSTR(cStr,i,1) $ "0123456789",lRet,.F.)
NEXT

IF LEN(cStr) == 47 .AND. lRet
	// Consiste os trï¿½s DVï¿½s de Bloquetos pelo Mï¿½dulo 10.
	nConta  := 1
	WHILE nConta <= 3
		nMult  := 2
		nVal   := 0
		nDV    := VAL(SUBSTR(cStr,IF(nConta==1,10,IF(nConta==2,21,32)),1))
		cCampo := SUBSTR(cStr,IF(nConta==1,1,IF(nConta==2,11,22)),IF(nConta==1,9,10))
		FOR i := LEN(cCampo) TO 1 STEP -1
			nMod  := VAL(SUBSTR(cCampo,i,1)) * nMult
			nVal  := nVal + IF(nMod>9,1,0) + (nMod-IF(nMod>9,10,0))
			nMult := IF(nMult==2,1,2)
		NEXT
		nDVCalc := 10-MOD(nVal,10)
		// Se o DV Calculado for 10 ï¿½ assumido 0 (Zero).
		nDVCalc := IF(nDVCalc==10,0,nDVCalc)
		lRet    := IF(lRet,(nDVCalc==nDV),.F.)
		nConta  := nConta + 1
	ENDDO
	// Se os DVï¿½s foram consistidos com sucesso (lRet=.T.), converte o nï¿½mero para CB para consistir o DVG.
	cStr := IF(lRet,SUBSTR(cStr,1,4)+SUBSTR(cStr,33,15)+SUBSTR(cStr,5,5)+SUBSTR(cStr,11,10)+SUBSTR(cStr,22,10),cStr)
ENDIF

IF LEN(cStr) == 48 .AND. lRet
	// Consiste os quatro DVï¿½s de Títulos de Concessionï¿½rias de Serviï¿½o Pï¿½blico e IPTU pelo Mï¿½dulo 10.
	nConta  := 1
	WHILE nConta <= 4
		nMult  := 2
		nVal   := 0
		nDV    := VAL(SUBSTR(cStr,IF(nConta==1,12,IF(nConta==2,24,IF(nConta==3,36,48))),1))
		cCampo := SUBSTR(cStr,IF(nConta==1,1,IF(nConta==2,13,IF(nConta==3,25,37))),11)
		FOR i := 11 TO 1 STEP -1
			nMod  := VAL(SUBSTR(cCampo,i,1)) * nMult
			nVal  := nVal + IF(nMod>9,1,0) + (nMod-IF(nMod>9,10,0))
			nMult := IF(nMult==2,1,2)
		NEXT
		nDVCalc := 10-MOD(nVal,10)
		// Se o DV Calculado for 10 ï¿½ assumido 0 (Zero).
		nDVCalc := IF(nDVCalc==10,0,nDVCalc)
		lRet    := IF(lRet,(nDVCalc==nDV),.F.)
		nConta  := nConta + 1
	ENDDO
	// Se os DVï¿½s foram consistidos com sucesso (lRet=.T.), converte o nï¿½mero para CB para consistir o DVG.
	cStr := IF(lRet,SUBSTR(cStr,1,11)+SUBSTR(cStr,13,11)+SUBSTR(cStr,25,11)+SUBSTR(cStr,37,11),cStr)
ENDIF

IF LEN(cStr) == 44 .AND. lRet
	IF cTipo $ "BI"
		// Consiste o DVG do CB de Bloquetos pelo Mï¿½dulo 11.
		nMult  := 2
		nVal   := 0
		nDV    := VAL(SUBSTR(cStr,5,1))
		cCampo := SUBSTR(cStr,1,4)+SUBSTR(cStr,6,39)
		FOR i := 43 TO 1 STEP -1
			nMod  := VAL(SUBSTR(cCampo,i,1)) * nMult
			nVal  := nVal + nMod
			nMult := IF(nMult==9,2,nMult+1)
		NEXT
		nDVCalc := 11-MOD(nVal,11)
		// Se o DV Calculado for 0,10 ou 11 ï¿½ assumido 1 (Um).
		nDVCalc := IF(nDVCalc==0 .OR. nDVCalc==10 .OR. nDVCalc==11,1,nDVCalc)
		lRet    := IF(lRet,(nDVCalc==nDV),.F.)
		// Se o Tipo ï¿½ (I)ndefinido E o DVG não foi consistido com sucesso (lRet=.F.), tentarï¿½
		// consistir como CB de Título de Concessionï¿½rias/IPTU no IF abaixo.
	ENDIF
	IF cTipo == "C" .OR. (cTipo == "I" .AND. !lRet)
		// Consiste o DVG do CB de Títulos de Concessionï¿½rias pelo Mï¿½dulo 10.
		lRet   := .T.
		nMult  := 2
		nVal   := 0
		nDV    := VAL(SUBSTR(cStr,4,1))
		cCampo := SUBSTR(cStr,1,3)+SUBSTR(cStr,5,40)
		FOR i := 43 TO 1 STEP -1
			nMod  := VAL(SUBSTR(cCampo,i,1)) * nMult
			nVal  := nVal + IF(nMod>9,1,0) + (nMod-IF(nMod>9,10,0))
			nMult := IF(nMult==2,1,2)
		NEXT
		nDVCalc := 10-MOD(nVal,10)
		// Se o DV Calculado for 10 ï¿½ assumido 0 (Zero).
		nDVCalc := IF(nDVCalc==10,0,nDVCalc)
		lRet    := IF(lRet,(nDVCalc==nDV),.F.)
	ENDIF
ENDIF

// Caso lRet seja .F. tenta validar pelo Mï¿½dulo 11
// (GPS ï¿½ validado por este mï¿½dulo e possui 48 posiï¿½ï¿½es)
// (Guia do Fundo de Garantia e validado por este modulo e possui 48 posicoes)
// As validaï¿½ï¿½es acima não conseguem validar pois esta sendo validado pelo mï¿½dulo 10

IF LEN(cStr) == 48 .AND. !lRet
	//
	// Verifica se todos os dï¿½gitos sï¿½o numï¿½rios.
	lRet := .T.

	For i := LEN(cStr) TO 1 STEP -1
		If lRet
			If SubStr(cStr,i,1) $ "0123456789"
				lRet := .T.
			Else
				lRet := .F.
			EndIf
		EndIf
	Next
	//
	nConta  := 1

	WHILE nConta <= 4

		nMult  := 2
		nVal   := 0
		nMod   := 0
		nDV    := VAL(SUBSTR(cStr,IF(nConta==1,12,IF(nConta==2,24,IF(nConta==3,36,48))),1))
		cCampo := SUBSTR(cStr,IF(nConta==1,1,IF(nConta==2,13,IF(nConta==3,25,37))),11)
		//
		FOR i := 11 TO 1 STEP -1
			nMod  := VAL(SUBSTR(cCampo,i,1)) * nMult
			nVal  += nMod
			If nMult == 9
				nMult := 2
			Else
				nMult := nMult + 1
			EndIf
		NEXT
		//
		nDVCalc := 11-MOD(nVal,11)
		//
		// Se o DV Calculado for 0,10 ou 11 ï¿½ assumido 0
		//
		If nDVCalc==10 .Or. nDVCalc==11
			nDVCalc := 0
		EndIf
		//
		//Alert("Digito Calculado "+str(nDVCalc))
		//
		If lRet
			If nDVCalc==nDV
				lRet := .T.
			Else
				lRet := .F.
			EndIf
		EndIf

		nConta  := nConta + 1
		//
	EndDo
	cStr := SUBSTR(cStr,1,11)+SUBSTR(cStr,13,11)+SUBSTR(cStr,25,11)+SUBSTR(cStr,37,11)
	lGPS := lRet
EndIf

If (Len(cStr) == 44 .And. !lRet ) .Or. lGPS
	//
	// Se os DVï¿½s foram consistidos com sucesso (lRet=.T.), converte o nï¿½mero para CB para consistir o DVG.
	//
	lRet   := .T.
	nMult  := 2
	nVal   := 0
	nDV    := VAL(SUBSTR(cStr,4,1))
	cCampo := AllTrim(SUBSTR(cStr,1,3)+SUBSTR(cStr,5,40))
	For i := 43 To 1 STEP -1
		nMod  := Val(SUBSTR(cCampo,i,1)) * nMult
		nVal  += nMod
		If nMult == 9
			nMult := 2
		Else
			nMult := nMult+1
		EndIf
	Next

	nDVCalc := 11-MOD(nVal,11)

	// Se o DV Calculado for 0,10 ou 11 ï¿½ assumido 1 (Um).
	If nDVCalc==10 .OR. nDVCalc==11 .Or. nDVCalc==0
		nDVCalc := 0 //1
	EndIf

	If lRet
		If nDVCalc == nDV
			lRet := .T.
		Else
			lRet := .F.
		EndIf
	EndIf
	//
	//Alert("Digito Geral Calculado "+str(nDVCalc))
	//
EndIf

If !( lRet )
	MsgAlert('código de barras inválido')
EndIf

RETURN(lRet)

/*
=====================================================================================
Programa.:            fVerCodBar
Autor....:            Paulo Henrique
Data.....:            15/08/2018
Descricao / Objetivo: Verifica se o código de barras já existe
Doc. Origem:          Contrato - GAP MGFFIN03
Solicitante:          Cliente
Uso......:            Marfrig
Obs......:            Faz a busca pelo novo indice
					  Indice 20 - E2_FILIAL+E2_CODBAR (código de Barras)
=====================================================================================
*/
Static Function fVerCodBar(cCodBarra)

Local aArea   := GetArea()
Local lRet    := .F.
Local cLinDig := cCodBarra
Local cCodBar := fConVld(cLinDig) // Converte a linha digitï¿½vel em código de barras ou verifica se o codigo de barra estï¿½ ok

//Alterado Carneiro
//Validando se tem informação no ccampo cCodBarra

IF Empty(cCodBarra) 
	ApMsgAlert(OemToAnsi('Código de barra em branco'),OemToAnsi('ATENÇÃO'))
	Return .F.
EndIf   
	

// Verifica se já existe o código de barras
dbSelectArea("SE2")
dbSetOrder(22) // E2_CODBAR
If !Empty(cCodBar) .AND. dbSeek(cCodBar)
   ApMsgAlert(OemToAnsi('Código de barra já existe no Título : '+SE2->E2_NUM),OemToAnsi('ATENÇÃO'))
   lRet := .T.
EndIf   			

// Verifica se já existe a linha digitável também
dbSelectArea("SE2")   
dbSetOrder(23) // E2_LINDIG
If !Empty(cCodBarra) .AND. dbSeek(cCodBarra)
   ApMsgAlert(OemToAnsi('Linha digitável já existe no Título : '+SE2->E2_NUM),OemToAnsi('ATENÇÃO'))
   If Empty(SE2->E2_CODBAR)
      RecLock("SE2",.F.)
	  SE2->E2_CODBAR := cCodBar
	  MsUnlock()
   EndIf
   lRet := .T.
EndIf		 

RestArea(aArea)

Return(lRet)