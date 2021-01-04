#INCLUDE 'protheus.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'PRTOPDEF.CH'
#INCLUDE 'fwmvcdef.CH'

/*
=====================================================================================
Programa.:              MostraBrw
Autor....:              Luis Artuso
Data.....:              27/09/2016
Descricao / Objetivo:   Chamada da rotina que exibe a mBrowse para manipulacao dos contratos com descontos personalizados.
Doc. Origem:            Contrato - GAP MGFGCT01
Solicitante:            Cliente
Uso......:              
Obs......:
=====================================================================================
*/
User Function MFGCT01()

	fShowBrw()

Return

/*
=====================================================================================
Programa.:              fShowBrw
Autor....:              Luis Artuso
Data.....:              27/09/2016
Descricao / Objetivo:   Exibir o browse para manipulacao da tabela SZR(Descontos Personalizados)
Doc. Origem:            Contrato - GAP MGFGCT01
Solicitante:            Cliente
Uso......:              
Obs......:
=====================================================================================
*/
Static Function fShowBrw()

	Local cTable	:= ""
	Local cTitulo	:= ""
	Local cVldDel	:= ""
	Local cVldAlt	:= ""

	Private aRotina		:= {}
	Private cCadastro	:= ""

	cTable		:= "SZR"
	cTitulo		:= "Cadastro de desconto personalizado"
	cVldDel		:= "U_fVldDel()"
	cVldAlt		:= "U_fVldAlt()"

	aRotina		:= MenuDef()
	cCadastro	:= cTitulo

	dbSelectArea('SZR')

	mBrowse( 06, 01, 22, 75, "SZR")

Return

/*
=====================================================================================
Programa.:              fVldDel
Autor....:              Luis Artuso
Data.....:              27/09/2016
Descricao / Objetivo:   Funcao para validacao de exclusao
Doc. Origem:            Contrato - GAP MGFGCT01
Solicitante:            Cliente
Uso......:              
Obs......:
=====================================================================================
*/
User Function fVldDel()

	Local cAliasSZR	:= ""
	Local aAreaSZR	:= {}
	Local cMensagem	:= ""

	cAliasSZR	:= "SZR"
	aAreaSZR	:= (cAliasSZR)->(GetArea())
	cMensagem	:= "Deseja excluir o desconto ? "

	If ( (MsgNoYes(cMensagem)) .AND. (RecLock(cAliasSZR , .F.)) )

		(cAliasSZR)->(dbDelete())

		(cAliasSZR)->(MsUnlock())

		MsgAlert('Exclu� o registro')

	EndIf

	RestArea(aAreaSZR)

Return .T.

/*
=====================================================================================
Programa.:              fVldAlt
Autor....:              Luis Artuso
Data.....:              27/09/2016
Descricao / Objetivo:   Funcao para validacao de alteracao
Doc. Origem:            Contrato - GAP MGFGCT01
Solicitante:            Cliente
Uso......:              
Obs......:
=====================================================================================
*/
User Function fVldAlt()

Return .T.

/*
=====================================================================================
Programa.:              MenuDef
Autor....:              Luis Artuso
Data.....:              27/09/2016
Descricao / Objetivo:   Retornar para o array 'aRotina' as funcoes para manipulacao do mBrowse
Doc. Origem:            Contrato - GAP MGFGCT01
Solicitante:            Cliente
Uso......:              
Obs......:
=====================================================================================
*/
Static Function MenuDef()

	Local aRotina	:= {}

	AADD(aRotina , {OemToAnsi("Visualizar")	, "AxVisual"	, 0 , 2} )
	AADD(aRotina , {OemToAnsi("Incluir")	, "AxInclui"	, 0 , 3} )
	AADD(aRotina , {OemToAnsi("Alterar")	, "AxAltera"	, 0 , 4} )
	AADD(aRotina , {OemToAnsi("Excluir")	, "U_fVldDel"	, 0 , 4} )

Return aRotina

/*
=====================================================================================
Programa.:              fQrySZR
Autor....:              Luis Artuso
Data.....:              27/09/2016
Descricao / Objetivo:   Gerar a Query para exibir na MarkBrowse os descontos conforme cadastro. Registros pre-existentes serao marcados para facilitar
						ao usuario visualizar os descontos concedidos anteriormente.
Doc. Origem:            Contrato - GAP MGFGCT01
Solicitante:            Cliente
Uso......:              
Obs......:
=====================================================================================
*/
User Function fQrySZR(oModel,cId)

	Local cFields	:= ""
	Local cAlias01	:= ""
	Local cAliasSZR	:= ""
	Local cAliasCNP	:= ""
	Local cOrder	:= ""
	Local aDados	:= {}
	Local aHeader	:= {}
	Local cNumCont	:= ""
	Local cTipoCont	:= ""
	Local cQuery	:= ""

	cAlias01	:= GetNextAlias()

	cAliasSZR	:= "SZR"
	cAliasCNP	:= "CNP"
	cNumCont	:= M->CN9_NUMERO
	cTipoCont	:= M->CN9_TPCTO

	cFields	:= "'' AS MARK, CNP.CNP_CODIGO, CNP.CNP_DESCRI, CNP.CNP_ZDESCP, '' AS REGISTRO, '' AS JAEXISTE , '' AS POSARRAY"

	cQuery	:= "SELECT "

	cQuery	+= 		"'T'" + " AS MARK, CNP.CNP_CODIGO, CNP.CNP_DESCRI, CNP.CNP_ZDESCP, '' AS REGISTRO, '' AS JAEXISTE , '' AS POSARRAY , CNP.CNP_FILIAL "

	cQuery	+=  "FROM "

	cQuery	+=		 RetSqlName(cAliasCNP) + " " + cAliasCNP + " "

	cQuery	+= 		"WHERE EXISTS "

	cQuery	+= 		"( "

	cQuery	+= 			"SELECT SZR.R_E_C_N_O_ "

	cQuery	+= 				"FROM "

	cQuery	+=					RetSqlName(cAliasSZR) + " " + cAliasSZR + " "

	cQuery	+= 				"WHERE "

	cQuery	+=					cAliasSZR + ".ZR_FILIAL  = " + "'" + xFilial(cAliasSZR) + "'" + " AND "

	cQuery	+=					cAliasSZR + ".ZR_ZCONTRA = " + "'" + cNumCont + "'" + " AND "

	cQuery	+=					cAliasSZR + ".ZR_ZTIPO = " + "'" + cTipoCont + "'" + " AND "

	cQuery	+=					cAliasSZR + ".ZR_ZCOD = " + cAliasCNP+".CNP_CODIGO " + " AND "

	cQuery	+=					cAliasSZR + ".D_E_L_E_T_ <> '*'

	cQuery	+= 		") "

	cQuery	+= 		"AND "

	cQuery	+= 			cAliasCNP + ".D_E_L_E_T_ <> '*' "

	cQuery	+= "UNION ALL "

	cQuery	+=		"SELECT "

	cQuery	+=			"'F'" + " AS MARK, CNP.CNP_CODIGO, CNP.CNP_DESCRI, CNP.CNP_ZDESCP, '' AS REGISTRO, '' AS JAEXISTE , '' AS POSARRAY , CNP.CNP_FILIAL "

	cQuery	+=  	"FROM "

	cQuery	+=			RetSqlName(cAliasCNP) + " " + cAliasCNP + " "

	cQuery	+=		"WHERE NOT EXISTS "

	cQuery	+=		"( "

	cQuery	+= 			"SELECT SZR.R_E_C_N_O_ "

	cQuery	+= 				"FROM "

	cQuery	+=					RetSqlName(cAliasSZR) + " " + cAliasSZR + " "

	cQuery	+= 				"WHERE "

	cQuery	+=					cAliasSZR + ".ZR_FILIAL  = " + "'" + xFilial(cAliasSZR) + "'" + " AND "

	cQuery	+=					cAliasSZR + ".ZR_ZCONTRA = " + "'" + cNumCont + "'" + " AND "

	cQuery	+=					cAliasSZR + ".ZR_ZTIPO   = " + "'" + cTipoCont + "'" + " AND "

	cQuery	+=					cAliasSZR + ".ZR_ZCOD   = " + cAliasCNP+".CNP_CODIGO " + " AND "

	cQuery	+= 					cAliasSZR + ".D_E_L_E_T_ <> '*' "

	cQuery	+= 		") "

	cQuery	+= 		"AND "

	cQuery	+= 			cAliasCNP + ".D_E_L_E_T_ <> '*' "

	//cOrder		:=	"ORDER BY "

	//cOrder		+=		"CNP_FILIAL, CNP_CODIGO"

	dbUseArea(.T. , "TOPCONN" , TcGenQry(,,cQuery + cOrder) , cAlias01 , .F. , .T.)

	cFields	:= StrTran(cFields , "CNP." , "") //Elimina ".CNP"

	fGeraDados(@aHeader , @aDados , cAlias01 , cFields )

	If ( Len(aDados) > 0 )
	
		MemoWrite("C:\QRYNCP.sql",cQuery + cOrder)		

		fExibeTela(aHeader , aDados)

	Else

		MsgAlert('Cadastre a tabela de descontos para utiliza��o desta rotina')

	EndIf

	(cAlias01)->(dbCloseArea())

Return

/*
=====================================================================================
Programa.:              fGeraDados
Autor....:              Luis Artuso
Data.....:              27/09/2016
Descricao / Objetivo:   Carrega os arrays 'aHeader' e 'aCols' para exibicao na MarkBrowse
Doc. Origem:            Contrato - GAP MGFGCT01
Solicitante:            Cliente
Uso......:              
Obs......:
=====================================================================================
*/
Static Function fGeraDados(	aHeader 	,;	// Array com cabecalho
							aDados  	,;	// Array com os dados
							cAliasTMP 	,;	// Alias temporario
							cFields 	;	// Campos para criacao do 'aHeader'
							)

	Local nLen		:= 0
	Local nX		:= 0
	Local nReg		:= 0
	Local nPoscod	:= 0
	Local nPosIni	:= 0
	Local cNameField:= ""
	Local aHeadTMP	:= {}
	Local nLimGera	:= 0
	Local nPosIns	:= 0
	Local cNumCont	:= ""
	Local cTipoCont	:= ""
	Local cAliasSZR	:= ""
	Local cChaveSZR	:= ""

	cNumCont	:= M->CN9_NUMERO
	cTipoCont	:= M->CN9_TPCTO
	cAliasSZR	:= "SZR"

	aHeader		:= StrToKarr(cFields , ",") // Armazena em 'aHeader' o conteudo de cFields

	aHeadTMP	:= aClone(aHeader)

	nLen		:= Len(aHeader)

	nPosIni		:= 1

	nPosCod		:= 2

	nLimGera	:= 5

	nPosReg		:= 5

	nPosIns		:= 6

	Do While (cAliasTMP)->(!EOF())

		AADD(aDados , Array(nLen))

		++nReg

		For nX := 1 TO nLen

			Do Case

				Case ( nX == 1 )

					 //A 1 posicao informa como marcado os registros cadastrados anteriormente
					 //aReg[nX , nPosIns] -> Quando 'F', significa que o registro deve ser alterado. Quando 'T', inserido.

					If ((cAliasTMP)->(FieldGet((nX))) == "T")

						aDados[nReg , nX]		:= .T.
						aDados[nReg , nPosIns]	:= .F.

					Else

						aDados[nReg , nX]		:= .F.
						aDados[nReg , nPosIns]	:= .T.

					EndIf

				Case ( nX <= nLimGera )

					//Grava em aDados o conteudo referente ao campo
					aDados[nReg , nX]	:= (cAliasTMP)->(FieldGet((nX)))

					cNameField			:= AllTrim(RetTitle(AllTrim(aHeader[nX])))

					//Atualiza o aHeader com o titulo do campo
					aHeadTMP[nX]		:= cNameField

				Case ( nX == nLen )

					//Grava a posicao original do array. Sera utilizada quando solicitado filtro.
					//Procedimento utilizado para melhoria de performance (evitar Ascan desnecessario).
					aDados[nReg , nX]	:= nReg

				End Case

		Next nX

		If ( aDados[nReg , nPosIni] )

			//Quando registro existente, armazeno o recno no array para permitir um 'dbGoTo' no registro, caso haja alteracao

			cChaveSZR	:= xFilial(cAliasSZR) + cNumCont + cTipoCont + aDados[nReg , nPosCod]

			If ( (cAliasSZR)->(dbSeek(cChaveSZR)) )

				aDados[nReg , nPosReg]	:= (cAliasSZR)->(RECNO())

			Else

				aDados[nReg , nPosReg]	:= 0

			EndIf

		Else

			aDados[nReg , nPosReg]	:= 0

		EndIf

		(cAliasTMP)->(dbSkip())

	EndDo

	aHeader	:= aClone(aHeadTMP)

	nLen	:= Len(aHeadTMP)

	aHeader	:= {}

	For nX := 1 TO nLen

		AADD(aHeader , Array(nLen))

		If ( nX == 1 )

			aHeader[nX] := ''

		Else

			aHeader[nX] := aHeadTMP[nX]

		EndIf

	Next nX

Return

/*
=====================================================================================
Programa.:              fExibeTela
Autor....:              Luis Artuso
Data.....:              27/09/2016
Descricao / Objetivo:   Exibe interface para o usuario selecionar os descontos, na execucao do P.E. CNTA300
Doc. Origem:            Contrato - GAP MGFGCT01
Solicitante:            Cliente
Uso......:              
Obs......:
=====================================================================================
*/
Static Function fExibeTela(aHeader , aDados)

	Local oButton1
	Local oButton2
	Local oButton3
	Local oButton4
	Local oButton5
	Local oButton6
	Local cGet1		:= Space(50)
	Local oSay1
	Local oWBrowse1
	Local oFont
	Local aFilter	:= {}
	Local aPosFilter:= {}

	DEFINE FONT oFont NAME "ARIAL" SIZE 6,15 BOLD

	DEFINE MSDIALOG oDlg TITLE "Selecione de descontos" FROM 000, 000  TO 430, 600 COLORS 0, 16777215 PIXEL

		@ 004 , 003 TO 212 , 300 LABEL "Selecao o(s) desconto(s) � conceder" PIXEL OF oDlg

		@ 018, 008 SAY oSay1 PROMPT " Informe o motivo de desconto :" SIZE 090, 007 OF oDlg COLORS 0, 16777215 PIXEL FONT oFont

		@ 016, 090 MSGET oGet1 VAR cGet1 SIZE 160, 010 OF oDlg COLORS 0, 16777215 PIXEL

		@ 015, 250 BUTTON oButton1 PROMPT "Pesquisar" SIZE 037, 015 OF oDlg PIXEL ACTION fFilBrow(@cGet1 , @aDados , @aFilter , oDlg , oWBrowse1 , @aPosFilter)

		fWBrowse1(aHeader , @aDados , oDlg , @oWBrowse1 , .F.)

		@ 190, 060 BUTTON oButton2 PROMPT "&Seleciona Todos" SIZE 042, 17 OF oDlg PIXEL ACTION fSelAll(@aDados , @aFilter , oDlg , @oWBrowse1 , .F. )

		@ 190, 110 BUTTON oButton3 PROMPT "&Limpa Todos" SIZE 042, 17 OF oDlg PIXEL ACTION fDelAll(@aDados , @aFilter , oDlg , @oWBrowse1 , .F. )

		@ 190, 160 BUTTON oButton4 PROMPT "&Desfaz Filtro" SIZE 042, 17 OF oDlg PIXEL ACTION fFilBrow(@cGet1 , @aDados , @aFilter , oDlg , oWBrowse1 ,;
		@aPosFilter)

		@ 190, 210 BUTTON oButton5 PROMPT "&Grava Desconto" SIZE 045, 17 OF oDlg PIXEL ACTION fGrava(oWBrowse1:aArray , oDlg )

		@ 190, 260 BUTTON oButton6 PROMPT "&Encerra" SIZE 034, 17 OF oDlg PIXEL ACTION oDlg:End()

	ACTIVATE MSDIALOG oDlg CENTERED

Return

/*
=====================================================================================
Programa.:              fWBrowse1
Autor....:              Luis Artuso
Data.....:              21/09/2016
Descricao / Objetivo:   Atualiza o array 'aDados', que sera exibido na MarkBrowse
Doc. Origem:            Contrato - GAP MGFGCT01
Solicitante:            Cliente
Uso......:              
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
			aHeader[++nPosArray],; // Prefixo
			SIZE 290 , 150 OF oDlg PIXEL ColSizes 10,30,170,73

		oWBrowse1:SetArray(aBrowse)

		oWBrowse1:bLine := {|| {;
			If(aBrowse[oWBrowse1:nAt,01],oOK,oNO),;
				aBrowse[oWBrowse1:nAt,02],;
				aBrowse[oWBrowse1:nAt,03],;
				aBrowse[oWBrowse1:nAt,04],;
			}}

		// DoubleClick event
		oWBrowse1:bLDblClick := {|| aBrowse[oWBrowse1:nAt,1] := !aBrowse[oWBrowse1:nAt,1],;
		oWBrowse1:DrawSelect()}

	Else

		oWBrowse1:SetArray(aBrowse)

		oWBrowse1:bLine := {|| {;
			If(aBrowse[oWBrowse1:nAt,01],oOK,oNO),;
				aBrowse[oWBrowse1:nAt,02],;
				aBrowse[oWBrowse1:nAt,03],;
				aBrowse[oWBrowse1:nAt,04],;
			}}
		// DoubleClick event
		oWBrowse1:bLDblClick := {|| aBrowse[oWBrowse1:nAt,1] := !aBrowse[oWBrowse1:nAt,1],;
		oWBrowse1:DrawSelect()}

		oWBrowse1:Refresh()

	EndIf

Return

/*
=====================================================================================
Programa.:              fFilBrow
Autor....:              Luis Artuso
Data.....:              03/10/16
Descricao / Objetivo:   Executa o filtro, conforme informado pelo usuario
Doc. Origem:            Contrato - GAP MGFGCT01
Solicitante:            Cliente
Uso......:              
Obs......:
=====================================================================================
*/
Static Function fFilBrow(cString , aDados , aFilter , oDlg , oWBrowse1 , aPosFilter)

	Local nX			:= 0
	Local nLen			:= 0
	Local nPosDesc		:= 0
	Local aFilterBkp	:= {}

	nPosDesc	:= 3 // Posicao em aDados referente � descricao

	aFilter	:= {}

	nLen		:= Len(aDados)

	For nX := 1 TO nLen

		//Executa o filtro, caso informado

		If ( Upper(AllTrim(cString)) $ Upper(AllTrim(aDados[nX , nPosDesc])))

			AADD(aFilter , aClone(aDados[nX]))
			AADD(aPosFilter , nX)

		EndIf

	Next

	fAtuArr(@aPosFilter , oWBrowse1 , @aDados , @aFilter)

	If ( Len(aFilter) )	//Atualiza o browser, caso localize algum registro

		fWBrowse1(NIL , @aFilter , oDlg , @oWBrowse1 , .T.)

	Else // Senao, todos os registros sao exibidos

		fWBrowse1(NIL , aDados , oDlg , @oWBrowse1 , .T.)

	EndIf

	cString	:= Space(50)

Return

/*
=====================================================================================
Programa.:              fGrava
Autor....:              Luis Artuso
Data.....:              21/09/2016
Descricao / Objetivo:   Grava os registros
Doc. Origem:            Contrato - GAP MGFGCT01
Solicitante:            Cliente
Uso......:              
Obs......:
=====================================================================================
*/
Static Function fGrava(aDados , oObj)

	Local nLen			:= 0
	Local nX			:= 0
	Local cAliasSZR		:= ""
	Local cAliasCN9		:= ""
	Local nRecno		:= 0
	Local nTotDesc		:= 0
	Local nPosCod		:= 0
	Local nPosPerc		:= 0
	Local nPosRecno		:= 0
	Local nPosInsere	:= 0
	Local cChave		:= ""
	Local lInsere		:= .F.
	Local oModel		:= FwModelActivate()    
 	Local oMdlCN9	    := oModel:GetModel('CN9MASTER')

	cAliasSZR	:= "SZR"

	cAliasCN9	:= "CN9"

	nPosCod		:= 2
	nPosPerc	:= 4
	nPosRecno	:= 5
	nPosInsere	:= 6

	nLen		:= Len(aDados)

	If ( (Empty(AllTrim(M->CN9_TPCTO))) )

		MsgAlert('Para gravar o desconto, dever� ser concluido o processo de cadastro do contrato.')

	Else

		For nX := 1 TO nLen

			lInsere	:= (aDados[nX , nPosInsere])

			nRecno	:= aDados[nX , nPosRecno]

			If ( aDados[nX , 1] )

				nTotDesc	+= aDados[nX , nPosPerc]

				If !( lInsere )

					(cAliasSZR)->(dbGoTo(nRecno))

				EndIf

				If ( RecLock(cAliasSZR , lInsere) )

					(cAliasSZR)->(ZR_FILIAL)	:= M->CN9_FILIAL
					(cAliasSZR)->(ZR_ZCONTRA)	:= M->CN9_NUMERO
					(cAliasSZR)->(ZR_ZTIPO)		:= M->CN9_TPCTO
					(cAliasSZR)->(ZR_ZCOD)		:= aDados[nX , nPosCod]

					(cAliasSZR)->(MsUnlock())

				EndIf

			Else

				If ( nRecno > 0 )

					(cAliasSZR)->(dbGoTo(nRecno))

					If ( RecLock(cAliasSZR , .F.) )

						(cAliasSZR)->(dbDelete())

						(cAliasSZR)->(MsUnlock())

					EndIf

				EndIf

			EndIf

		Next nX
        
        oMdlCN9:SetValue('CN9_ZTOTDE',nTotDesc)
        /*
		If ( RecLock(cAliasCN9 , .F.) )

			(cAliasCN9)->(CN9_ZTOTDE)	:= nTotDesc

			(cAliasCN9)->(MsUnlock())

		EndIf
        */
        //oModel
        
		oDlg:End()

	EndIf

Return

/*
=====================================================================================
Programa.:              fAtuArr
Autor....:              Luis Artuso
Data.....:              21/09/2016
Descricao / Objetivo:   Altera o array 'aDados' para exibir na markbrowse os itens filtrados.
Doc. Origem:            Contrato - GAP MGFGCT01
Solicitante:            Cliente
Uso......:              
Obs......:
=====================================================================================
*/
Static Function fAtuArr(aPosFilter, oWBrowse1 , aDados , aFilter)

	Local aAlterados	:= {}
	Local nLen			:= 0
	Local nX			:= 0
	Local nPosAltera	:= 0
	Local nPosArrAlt	:= 0 // variavel que indica a posicao original do array antes do filtro

	aAlterados	:= aClone(oWBrowse1:AARRAY)

	nLen		:= Len(aAlterados)

	nPosArrAlt	:= 7

	For nX := 1 TO nLen

		//Atualiza o array aDados com as alteracoes efetuadas
		nPosAltera		:= aAlterados[nX , nPosArrAlt ]

		aDados[nPosAltera , 1]	:= aAlterados[nX , 1]

	Next nX

	nLen	:= Len(aFilter)

	For nX := 1 TO nLen

		nPosAltera		:= aPosFilter[nX]

		aFilter[nX , 1]	:= aDados[nPosAltera , 1]

	Next nX

	aAlterados	:= {} //Armazena todas as alteracoes, conforme selecionado (ou nao) na markbrowse

	aPosFilter	:= {} // Armazena quais registros sofreram alteracoes

Return

/*
=====================================================================================
Programa.:              fSelAll
Autor....:              Luis Artuso
Data.....:              21/09/2016
Descricao / Objetivo:   Seleciona todos os itens da MarkBrowse. Serao considerados os itens filtrados, conforme informado na pesquisa.
Doc. Origem:            Contrato - GAP MGFGCT01
Solicitante:            Cliente
Uso......:              
Obs......:
=====================================================================================
*/
Static Function fSelAll(aDados , aFilter , oDlg , oWBrowse1 )

	Local nLen		:= 0
	Local nX		:= 0

	nLen	:= Len(aFilter)

	If ( nLen > 0 )

		For nX := 1 TO nLen

			aFilter[nX , 1]	:= .T.

		Next nX

		fWBrowse1(NIL , aFilter , oDlg , @oWBrowse1 , .T.)

	Else

		nLen	:= Len(aDados)

		For nX := 1 TO nLen

			aDados[nX , 1]	:= .T.

		Next nX

		fWBrowse1(NIL , aDados , oDlg , @oWBrowse1 , .T.)

	EndIf

Return

/*
=====================================================================================
Programa.:              fDelAll
Autor....:              Luis Artuso
Data.....:              21/09/2016
Descricao / Objetivo:   Desmarca todos os itens da MarkBrowse. Serao considerados os itens filtrados, conforme informado na pesquisa.
Doc. Origem:            Contrato - GAP MGFGCT01
Solicitante:            Cliente
Uso......:              
Obs......:
=====================================================================================
*/
Static Function fDelAll(aDados , aFilter , oDlg , oWBrowse1 )

	Local nLen		:= 0
	Local nX		:= 0

	nLen	:= Len(aFilter)

	If ( nLen > 0 )

		For nX := 1 TO nLen

			aFilter[nX , 1]	:= .F.

		Next nX

		fWBrowse1(NIL , aFilter , oDlg , @oWBrowse1 , .T.)

	Else

		nLen	:= Len(aDados)

		For nX := 1 TO nLen

			aDados[nX , 1]	:= .F.

		Next nX

		fWBrowse1(NIL , aDados , oDlg , @oWBrowse1 , .T.)

	EndIf

Return