#include 'protheus.ch'

/*
=====================================================================================
Programa............: MGFFIN96
Autor...............: Joni Lima
Data................: 02/04/2016
Descricao / Objetivo: ExecAuto Inclusao do Movimento do Caixinha
Doc. Origem.........: Contrato - GAP Caixinha
Solicitante.........: Cliente
Uso.................: 
Obs.................: Execauto da rotina FINA560
=====================================================================================
*/
User Function MG97I560(aArray,nOpc)
    Local cError:= ''
	Local aArea := GetArea()

	Local aArray2:= {} // Utilizado na prestacao de contas
	Default nOpc := 3 // 3 - Inclusao, 4 - Prestacao de Contas, 5 - Exclusao
	Private lMsErroAuto := .F.
//
//	//-----------------------------------------------------------------------
//	// Programa de inclusao de movimentos no caixinha via rotina automatica |
//	//-----------------------------------------------------------------------
//	//  aArray := { { "EU_NUM" , "0000000037" , NIL 					},;
//	//                   { "EU_CAIXA" , "CX1" , NIL 					},;
//	//                   { "EU_TIPO" , "01" , NIL 						},; //00 - Despesa, 01 - Adiantamento
//	//                   { "EU_HISTOR" , "TESTE CAIXINHA " , NIL 		},;
//	//                   { "EU_NRCOMP" , "001 " , NIL 					},;
//	//                   { "EU_VALOR" , 500, NIL 						},;
//	//                   { "EU_BENEF" , "TOTVS ", NIL 					},;
//	//                   { "EU_DTDIGIT" , CtoD("05/08/2016"), NIL 		},;
//	//                   { "EU_EMISSAO" , CtoD("05/08/2016"), NIL 		},;
//	//                   { "EU_FORNECE" , "001 ", NIL 					},;
//	//                   { "EU_LOJA" , "01", NIL 						},;
//	//                   { "EU_NOME" , "FORNECEDOR S/ IMPOSTO ", NIL 	},;
//	//                   { "EU_CGC" , "51236848000155", NIL 			},;
//	//                   { "EU_CONTA" , "101010100 ", NIL 				},;
//	//                   { "EU_CONTAD" , "101010200 ", NIL 				},;
//	//                   { "EU_CONTAC" , "101010300 ", NIL 				},;
//	//                   { "EU_CCD" , "10101 ", NIL 					},;
//	//                   { "EU_CCC" , "10102 ", NIL 					},;
//	//                   { "EU_ITEMD" , "1010102 ", NIL 				},;
//	//                   { "EU_ITEMC" , "1010101 ", NIL 				},;
//	//                   { "EU_CLVLDB" , "1010101 ", NIL 				},;
//	//                   { "EU_CLVLCR" , "1010102 ", NIL 				},;
//	//                   { "EU_CODAPRO" , "000001", NIL 				},;
//	//                   { "EU_MOEDA" , 1, NIL 							},;
//	//                   { "EU_VLMOED2" , 0, NIL 						},;
//	//                   { "EU_ENVUMOV" , '2', NIL 						} }
//
	MsExecAuto( { |x,y,z| FINA560(x,y,z)} ,nil , aArray, nOpc)

	If lMsErroAuto
		If (!IsBlind()) // COM INTERFACE GRAFICA
		MostraErro()
	    Else // EM ESTADO DE JOB
	        cError := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO
	
	        ConOut(PadC("Automatic routine ended with error", 80))
	        ConOut("Error: "+ cError)
	    EndIf
	Else
		//Alert("Inclusao do movimento efetuada.")
	Endif

	RestArea(aArea)

Return

/*
=====================================================================================
Programa............: MGFFIN96
Autor...............: Joni Lima
Data................: 02/04/2016
Descricao / Objetivo: ExecAuto Inclusao do Movimento do Caixinha
Doc. Origem.........: Contrato - GAP Caixinha
Solicitante.........: Cliente
Uso.................: 
Obs.................: Execauto da rotina FINA560
=====================================================================================
*/
User Function MG97I050(aArray)
	Local aArea := GetArea()
	Local cError     := ''
	PRIVATE lMsErroAuto := .F.

	//aArray := { { "E2_PREFIXO"  , "PAG"             , NIL },;
	//            { "E2_NUM"      , "0001"            , NIL },;
	//            { "E2_TIPO"     , "NF"              , NIL },;
	//            { "E2_NATUREZ"  , "001"             , NIL },;
	//            { "E2_FORNECE"  , "0001"            , NIL },;
	//            { "E2_EMISSAO"  , CtoD("17/02/2012"), NIL },;
	//            { "E2_VENCTO"   , CtoD("17/02/2012"), NIL },;
	//            { "E2_VENCREA"  , CtoD("17/02/2012"), NIL },;
	//            { "E2_VALOR"    , 5000              , NIL } }

	MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aArray,, 3)  // 3 - Inclusao, 4 - Alteracao, 5 - Exclusao

	If lMsErroAuto
		If (!IsBlind()) // COM INTERFACE GRAFICA
		MostraErro()
	    Else // EM ESTADO DE JOB
	        cError := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO
	
	        ConOut(PadC("Automatic routine ended with error", 80))
	        ConOut("Error: "+ cError)
	    EndIf
	Else
		//Alert("Titulo incluido com sucesso!")
	Endif

	RestArea(aArea)
Return {SE2->(RECNO()),SE2->E2_NUM}

User Function MG97I550(aArray)
    Local cError     := '' 
	PRIVATE lMsErroAuto := .F.

	//aArray := { { "cBanco"   , "001"             , NIL },;
	//            { "cAgencia" , "0479"            , NIL },;
	//            { "cConta"   , "25766"           , NIL },;
	//            { "lMovBco"  , .F.               , NIL },;
	//            { "nVlrRep"  , 200           	   , NIL },;
	//            { "nTxRep"   , 1				   , NIL }}

	MsExecAuto( { |x,y,z| FINA550(x,y,z)}, 6,.T.)  // 3 - Inclusao, 4 - Alteracao, 5 - Exclusao, 6 Reposicao

	If lMsErroAuto
		If (!IsBlind()) // COM INTERFACE GRAFICA
		MostraErro()
	    Else // EM ESTADO DE JOB
	        cError := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO
	
	        ConOut(PadC("Automatic routine ended with error", 80))
	        ConOut("Error: "+ cError)
	    EndIf
	Else
		//Alert("Titulo incluido com sucesso!")
	Endif


Return

///*/{Protheus.doc} MGFFIN97
////TODO  Programa gerado para movimentar E2 atraves do caixinha SEU
//@author leonardo.kume
//@since 30/03/2018
//@version 6
//@return cNum, Numero do Caixinha
//@param aArray, array, descricao
//@type function
///*/
//User Function MGFFIN97()
//
//	Local aArray := { 	{ "E2_PREFIXO"  , GetMv("MGF_FIN97", , "CX1")	, NIL },; //Parametro padrao prefixo do caixinha
//						{ "E2_NUM"      , SEU->EU_NUM          			, NIL },;
//						{ "E2_TIPO"     , SEU->EU_TIPO         			, NIL },;
//						{ "E2_NATUREZ"  , SEU->EU_ZNATUR       			, NIL },;
//						{ "E2_FORNECE"  , SEU->EU_FORNECE   			, NIL },;
//						{ "E2_EMISSAO"  , ddatabase						, NIL },;
//						{ "E2_VENCTO"   , ddatabase+10					, NIL },;
//						{ "E2_VENCREA"  , ddatabase+10 					, NIL },;
//						{ "E2_VALOR"    , SEU->EU_VALOR        			, NIL } }
//
//	u_MGF97SE2(aArray)
//
//Return
//
///*/{Protheus.doc} MGF97DEL
////TODO Delecao registo do SE2
//@author leonardo.kume
//@since 31/03/2018
//@version 6
//
//@type function
///*/
User Function MGF97DEL()
    Local cError     := ''
	Local aArea 	 := GetArea()
	Local aAreaSE2	 := SE2->(GetArea())
	Local aAreaSEU	 := SEU->(GetArea())
	Local aArray	 := {}
	Local nRecSe2	 := SE2->(Recno())
	Local cNextAlias := GetNextAlias()
	Local cNumApr    := ""

	PRIVATE lMsErroAuto := .F.

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif

	BeginSql Alias cNextAlias
		SELECT SEU.R_E_C_N_O_ RECNO, SEU.EU_ZNUMAPR
		FROM %Table:SEU% SEU
		WHERE 	SEU.%NOTDEL% AND
				SEU.EU_ZRECSE2 = %Exp:nRecSE2%
	EndSQL

	(cNextAlias)->(dbGoTop())

	dbSelectArea("SEU")

	While (cNextAlias)->(!EOF())

		cNumApr := (cNextAlias)->EU_ZNUMAPR

		SEU->(dbGoTo((cNextAlias)->RECNO))

		aArray := {{ "EU_FILIAL" , SEU->EU_FILIAL  , NIL },;
					  { "EU_NUM"   , SEU->EU_NUM    , NIL }}
//                    { "EU_CAIXA" , SEU->EU_CAIXA  , NIL },;
//                    { "EU_TIPO"  , SEU->EU_TIPO   , NIL },; //00 - Despesa, 01 - Adiantamento
//                    { "EU_HISTOR", SEU->EU_HISTOR , NIL },;
//                    { "EU_NRCOMP", SEU->EU_NRCOMP , NIL },;
//                    { "EU_VALOR" , SEU->EU_VALOR  , NIL },;
//                    { "EU_BENEF" , SEU->EU_BENEF  , NIL },;
//                    { "EU_DTDIGIT", SEU->EU_DTDIGIT , NIL },;
//                    { "EU_EMISSAO", SEU->EU_EMISSAO , NIL }}

		MsExecAuto( { |x,y,z| FINA560(x,y,z)} ,nil , aArray, 5)

		If lMsErroAuto
			If (!IsBlind()) // COM INTERFACE GRAFICA
			MostraErro()
		    Else // EM ESTADO DE JOB
		        cError := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO
		
		        ConOut(PadC("Automatic routine ended with error", 80))
		        ConOut("Error: "+ cError)
		    EndIf
		Else
			ConfirmSX8()
			//Alert("Inclusao do movimento efetuada.")
		Endif

		(cNextAlias)->(dbSkip())
	EndDo

	(cNextAlias)->(dbCloseArea())

	If !Empty(cNumApr)
		xRetApr(cNumApr)
	Endif

	RestArea(aAreaSEU)
	RestArea(aAreaSE2)
	RestArea(aArea)

Return

Static Function xRetApr(cNumApr)

	Local aArea 	:= GetArea()
	Local aAreaZE0	:= ZE0->(GetArea())
	Local cNextAlias := GetNextAlias()

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif

	BeginSql Alias cNextAlias

		SELECT ZE0.R_E_C_N_O_
		FROM %Table:ZE0%  ZE0
		WHERE
			ZE0.%NOTDEL% AND
			ZE0.ZE0_NAPRCP = %Exp:cNumApr%

	EndSQL

	(cNextAlias)->(dbGoTop())

	dbSelectArea("ZE0")

	While (cNextAlias)->(!EOF())

		ZE0->(dbGoTo((cNextAlias)->RECNO))

		RecLock("ZE0",.F.)
			ZE0->ZE0_APRUNI := " "
			ZE0->ZE0_APRCPA := " "
			ZE0->ZE0_DTBAIX := CtoD("//")
			ZE0->ZE0_APRUNI := " "
			ZE0->ZE0_MARKUN := .F.
			ZE0->ZE0_MARKCP := .F.
			ZE0->ZE0_NAPRUN := " "
			ZE0->ZE0_NAPRCP := " "
		ZE0->(MsUnLock())

		(cNextAlias)->(dbSkip())
	EndDo

	(cNextAlias)->(dbCloseArea())

	RestArea(aAreaZE0)
	RestArea(aArea)

return

//
//user function MGF97SEU(aArray,nOpc)
//
//	Local aArray2:= {} // Utilizado na prestacao de contas
//	Default nOpc := 3 // 3 - Inclusao, 4 - Prestacao de Contas, 5 - Exclusao
//	Private lMsErroAuto := .F.
//
//	//-----------------------------------------------------------------------
//	// Programa de inclusao de movimentos no caixinha via rotina automatica |
//	//-----------------------------------------------------------------------
//	//  aArray := { { "EU_NUM" , "0000000037" , NIL },;
//	//                   { "EU_CAIXA" , "CX1" , NIL },;
//	//                   { "EU_TIPO" , "01" , NIL },; //00 - Despesa, 01 - Adiantamento
//	//                   { "EU_HISTOR" , "TESTE CAIXINHA " , NIL },;
//	//                   { "EU_NRCOMP" , "001 " , NIL },;
//	//                   { "EU_VALOR" , 500, NIL },;
//	//                   { "EU_BENEF" , "TOTVS ", NIL },;
//	//                   { "EU_DTDIGIT" , CtoD("05/08/2016"), NIL },;
//	//                   { "EU_EMISSAO" , CtoD("05/08/2016"), NIL },;
//	//                   { "EU_FORNECE" , "001 ", NIL },;
//	//                   { "EU_LOJA" , "01", NIL },;
//	//                   { "EU_NOME" , "FORNECEDOR S/ IMPOSTO ", NIL },;
//	//                   { "EU_CGC" , "51236848000155", NIL },;
//	//                   { "EU_CONTA" , "101010100 ", NIL },;
//	//                   { "EU_CONTAD" , "101010200 ", NIL },;
//	//                   { "EU_CONTAC" , "101010300 ", NIL },;
//	//                   { "EU_CCD" , "10101 ", NIL },;
//	//                   { "EU_CCC" , "10102 ", NIL },;
//	//                   { "EU_ITEMD" , "1010102 ", NIL },;
//	//                   { "EU_ITEMC" , "1010101 ", NIL },;
//	//                   { "EU_CLVLDB" , "1010101 ", NIL },;
//	//                   { "EU_CLVLCR" , "1010102 ", NIL },;
//	//                   { "EU_CODAPRO" , "000001", NIL },;
//	//                   { "EU_MOEDA" , 1, NIL },;
//	//                   { "EU_VLMOED2" , 0, NIL },;
//	//                   { "EU_ENVUMOV" , '2', NIL } }
//
//	MsExecAuto( { |x,y,z| FINA560(x,y,z)} ,0, aArray, nOpc)
//
//	If lMsErroAuto
//		MostraErro()
//	Else
//		Alert("Inclusao do movimento efetuada.")
//	Endif
//
//return SEU->EU_NUM
//
///*/{Protheus.doc} MGFFIN97
////TODO Programa para gerar o SE2
//@author leonardo.kume
//@since 31/03/2018
//@version 6
//@param aArray, array, descricao
//@type function
///*/
//user function MGF97SE2(aArray)
//
//
//	PRIVATE lMsErroAuto := .F.
//
	//aArray := { { "E2_PREFIXO"  , "PAG"             , NIL },;
	//            { "E2_NUM"      , "0001"            , NIL },;
	//            { "E2_TIPO"     , "NF"              , NIL },;
	//            { "E2_NATUREZ"  , "001"             , NIL },;
	//            { "E2_FORNECE"  , "0001"            , NIL },;
	//            { "E2_EMISSAO"  , CtoD("17/02/2012"), NIL },;
	//            { "E2_VENCTO"   , CtoD("17/02/2012"), NIL },;
	//            { "E2_VENCREA"  , CtoD("17/02/2012"), NIL },;
	//            { "E2_VALOR"    , 5000              , NIL } }
//
//	MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aArray,, 3)  // 3 - Inclusao, 4 - Alteracao, 5 - Exclusao
//
//
//	If lMsErroAuto
//		MostraErro()
//	Else
//		Alert("Titulo incluido com sucesso!")
//	Endif
//
//Return se2->(Recno())