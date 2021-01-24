#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"
#include 'fwmvcdef.ch'

#define CRLF chr(13) + chr(10)
/*
=========================================================================================================
Programa.................: MGFGFE17
Autor:...................: Flávio Dentello
Data.....................: 30/10/2017
Descrição / Objetivo.....: Cadastro de excessão
Doc. Origem..............: GAP - GFE93
Solicitante..............: Cliente
Uso......................: Marfrig
Obs......................:
=========================================================================================================
*/

User Function MGFGFE17()
	local cPerg			:= 'MGFGFE17'
	local oGridGfe17	:= nil
	local aCoors		:= 	FWGetDialogSize( oMainWnd )
	local oDlg			:= nil
	local aButtons		:= {}

	private dEmissDx
	private dEmissAx
	private aSF2		:= {}

	if !Pergunte(cPerg,.T.)
		return
	endif

	If !empty(MV_PAR01)
		dEmissDx := MV_PAR01
	EndIf

	If !empty(MV_PAR02)
		dEmissAx := MV_PAR02
	EndIf

	fwMsgRun(, {|| getInfo() }, "Processando. Aguarde...", "Selecionando dados..." )

	if len(aSF2) > 0
		DEFINE MSDIALOG oDlg TITLE 'Seguro Nacional de Cargas' FROM aCoors[1], aCoors[2] TO aCoors[3], aCoors[4] PIXEL //STYLE DS_MODALFRAME
			oGridGfe17 := fwBrowse():New()
			oGridGfe17:setDataArray()
			oGridGfe17:setArray( aSF2 )
			oGridGfe17:disableConfig()
			oGridGfe17:disableReport()
			oGridGfe17:setOwner( oDlg )

/*
			aadd(aSF2, { (cQryGfe17)->M0_CGC	,;
						(cQryGfe17)->F2_EMISSAO	,;
						(cQryGfe17)->F2_DOC		,;
						(cQryGfe17)->F2_SERIE	,;
						(cQryGfe17)->F2_VALBRUT	,;
						(cQryGfe17)->F2_PLIQUI	,;
						(cQryGfe17)->D2_PEDIDO	,;
						(cQryGfe17)->DAI_COD	,;
						(cQryGfe17)->ZJ_NOME	,;
						(cQryGfe17)->F4_CF		,;
						'INDUSTRIAL'			,;
						(cQryGfe17)->ZBV_TAXA	,;
						(cQryGfe17)->PREMIO		,;
						(cQryGfe17)->F2_EST		,;
						(cQryGfe17)->A1_MUN		,;
						(cQryGfe17)->A4_CGC		,;
						(cQryGfe17)->A4_NOME	,;
						(cQryGfe17)->DA3_PLACA	,;
						(cQryGfe17)->YQ_DESCR	,;
						(cQryGfe17)->EE7_PEDIDO	,;
						iif( !empty( (cQryGfe17)->EX9_CONTNR1, (cQryGfe17)->EX9_CONTNR2 ) )											,;
						(cQryGfe17)->COTACAO																						,;
						(cQryGfe17)->PREMIO																							,;
						iif( !empty( (cQryGfe17)->EE7_PEDIDO, (cQryGfe17)->PREMTOTEXP, (cQryGfe17)->PREMTOT  ) ) 		,;
						iif( !empty( (cQryGfe17)->EE7_PEDIDO, (cQryGfe17)->PREMIOFEXP, (cQryGfe17)->PREMTOTIOF  ) ) })
*/

			oGridGfe17:addColumn({"CNPJ"				  , {||aSF2[oGridGfe17:nAt,1]}	, "C", , 1, 14						})
			oGridGfe17:addColumn({"Data"				  , {||aSF2[oGridGfe17:nAt,2]}	, "D", , 1, tamSx3("F2_EMISSAO")[1]	})
			oGridGfe17:addColumn({"Num. NF"				  , {||aSF2[oGridGfe17:nAt,3]}	, "C", , 1, tamSx3("F2_DOC")[1]		})
			oGridGfe17:addColumn({"Serie NF"			  , {||aSF2[oGridGfe17:nAt,4]}	, "C", , 1, tamSx3("F2_SERIE")[1]	})
			oGridGfe17:addColumn({"Valor NF"			  , {||aSF2[oGridGfe17:nAt,5]}	, "N", , 2, tamSx3("F2_VALBRUT")[1]	})
			oGridGfe17:addColumn({"Peso Líquido NF" 	  , {||aSF2[oGridGfe17:nAt,6]}	, "N", , 2, tamSx3("F2_PLIQUI")[1]	})
			oGridGfe17:addColumn({"Num. Pedido"			  , {||aSF2[oGridGfe17:nAt,7]}	, "C", , 1, tamSx3("D2_PEDIDO")[1]	})
			oGridGfe17:addColumn({"OE"       			  , {||aSF2[oGridGfe17:nAt,8]}	, "C", , 1, tamSx3("DAI_COD")[1]	})
			oGridGfe17:addColumn({"Tipo Pedido"			  , {||aSF2[oGridGfe17:nAt,9]}	, "C", , 1, tamSx3("ZJ_NOME")[1]	})
			oGridGfe17:addColumn({"Cod CFOP"			  , {||aSF2[oGridGfe17:nAt,10]}	, "C", , 1, tamSx3("F4_CF")[1] + tamSx3("F4_TEXTO")[1]		})
			oGridGfe17:addColumn({"TP Carregamento"		  , {||aSF2[oGridGfe17:nAt,11]}	, "C", , 1, 10						})
			oGridGfe17:addColumn({"Taxa"				  , {||aSF2[oGridGfe17:nAt,12]}	, "N", , 2, tamSx3("ZBV_TAXA")[1]	})
			oGridGfe17:addColumn({"Vlr Prêmio"			  , {||aSF2[oGridGfe17:nAt,13]}	, "N", , 2, tamSx3("F2_VALBRUT")[1]	})
			oGridGfe17:addColumn({"Estado"			 	  , {||aSF2[oGridGfe17:nAt,14]}	, "C", , 1, tamSx3("F2_EST")[1]		})
			oGridGfe17:addColumn({"Cidade"				  , {||aSF2[oGridGfe17:nAt,15]}	, "C", , 1, tamSx3("A1_MUN")[1]		})
			oGridGfe17:addColumn({"CNPJ Transp."		  , {||aSF2[oGridGfe17:nAt,16]}	, "C", , 1, tamSx3("A4_CGC")[1]		})
			oGridGfe17:addColumn({"Nome Transp."		  , {||aSF2[oGridGfe17:nAt,17]}	, "C", , 1, tamSx3("A4_NOME")[1]	})
			oGridGfe17:addColumn({"Placa"				  , {||aSF2[oGridGfe17:nAt,18]}	, "C", , 1, tamSx3("DA3_PLACA")[1]	})
			oGridGfe17:addColumn({"Tipo Embarque"		  , {||aSF2[oGridGfe17:nAt,19]}	, "C", , 1, tamSx3("YQ_DESCR")[1]	})
			oGridGfe17:addColumn({"EXP"					  , {||aSF2[oGridGfe17:nAt,20]}	, "C", , 1, tamSx3("EE7_PEDIDO")[1]	})
			oGridGfe17:addColumn({"N.Container"		      , {||aSF2[oGridGfe17:nAt,21]}	, "C", , 1, tamSx3("EX9_CONTNR")[1]	})
			oGridGfe17:addColumn({"Cotação"				  , {||aSF2[oGridGfe17:nAt,22]}	, "N", , 2, tamSx3("F2_VALBRUT")[1]	}) // COTACAO
			oGridGfe17:addColumn({"Valor Container"	      , {||aSF2[oGridGfe17:nAt,23]}	, "N", , 2, tamSx3("F2_VALBRUT")[1]	}) // COTACAO
			oGridGfe17:addColumn({"Premio Ref Container"  , {||aSF2[oGridGfe17:nAt,24]}	, "N", , 2, tamSx3("F2_VALBRUT")[1]	}) // PREMIO
			oGridGfe17:addColumn({"Premio Total"		  , {||aSF2[oGridGfe17:nAt,25]}	, "N", , 2, tamSx3("F2_VALBRUT")[1]	}) // PREMIO_TOTAL
			oGridGfe17:addColumn({"Premio Total c/IOF"    , {||aSF2[oGridGfe17:nAt,26]}	, "N", , 2, tamSx3("F2_VALBRUT")[1]	}) // PREMTOTIOF

			oGridGfe17:activate(.T.)

			//ACTIVATE MSDIALOG oDlg CENTER
			//aadd( aButtons, { "HISTORIC", { || TestHist() }, "Histórico...", "Histórico" , { || .T.} } )

			aadd( aButtons, { "HISTORIC", { || U_xImpGFE17() }, "Exportar Excel" } )

		ACTIVATE MSDIALOG oDlg ON INIT (EnchoiceBar( oDlg, { || lOk := .T., oDlg:End() }, {||oDlg:End()}, , @aButtons))
	else
		msgAlert("Não foram encontrados dados com os parâmetros informados.")
	endif
return oGridGfe17

//-----------------------------------------------------------
//
//-----------------------------------------------------------
static function MenuDef()
	Private aRotina := {}

	If Type("aRotina") == "U"
		aRotina := {}
	EndIf

	ADD OPTION aRotina TITLE 'Gerar Planilha' ACTION 'u_xImpGFE17'	OPERATION 2 ACCESS 0
return aRotina

//-----------------------------------------------------------
// Seleciona os dados
//-----------------------------------------------------------
static function getInfo()
	local cQuery	:= ""
	local cTpfis	:= ""
	local cQryGfe17	:= getNextAlias()

	//cTpfis += allTrim( superGetMv('MGF_FRCTRC' , NIL, '') )
	//cTpfis += allTrim( superGetMv('MGF_2RCTRC' , NIL, '') )
	//cTpfis += allTrim( superGetMv('MGF_3RCTRC' , NIL, '') )

	cQuery += " SELECT" + CRLF
	cQuery += "     SM0.M0_CGC, F2_EST, C5_PEDEXP," + CRLF
	cQuery += "     F2_FILIAL, F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA, F2_EMISSAO, F2_VALBRUT, F2_PLIQUI," + CRLF
	cQuery += "     (" + CRLF
	cQuery += "         SELECT D2_PEDIDO" + CRLF
	cQuery += "         FROM " + retSQLName("SD2") + " SD2" + CRLF
	cQuery += "         WHERE" + CRLF
	cQuery += "             SD2.D2_SERIE    =   SF2.F2_SERIE" + CRLF
	cQuery += "         AND SD2.D2_DOC      =   SF2.F2_DOC" + CRLF
	cQuery += "         AND SD2.D2_LOJA     =   SF2.F2_LOJA" + CRLF
	cQuery += "         AND SD2.D2_CLIENTE  =   SF2.F2_CLIENTE" + CRLF
	cQuery += "         AND SD2.D2_FILIAL   =   SF2.F2_FILIAL" + CRLF
	cQuery += "         AND SD2.D_E_L_E_T_  <>  '*'" + CRLF
	cQuery += "         AND ROWNUM          =   1" + CRLF
	cQuery += "     ) D2_PEDIDO," + CRLF
	cQuery += "     DAI_COD," + CRLF
	cQuery += "     C5_ZTIPPED," + CRLF
	cQuery += "     ZJ_NOME," + CRLF
	cQuery += "     (" + CRLF
	cQuery += "         SELECT F4_CF || ' - ' || F4_TEXTO" + CRLF
	cQuery += "         FROM " + retSQLName("SD2") + " SD2" + CRLF
	cQuery += "         INNER JOIN " + retSQLName("SF4") + " SF4" + CRLF
	cQuery += "         ON" + CRLF
	cQuery += "             SF4.F4_CODIGO   =   D2_TES" + CRLF
	cQuery += "         AND SF4.D_E_L_E_T_  <>  '*'" + CRLF
	cQuery += "         WHERE" + CRLF
	cQuery += "             SD2.D2_SERIE    =   SF2.F2_SERIE" + CRLF
	cQuery += "         AND SD2.D2_DOC      =   SF2.F2_DOC" + CRLF
	cQuery += "         AND SD2.D2_LOJA     =   SF2.F2_LOJA" + CRLF
	cQuery += "         AND SD2.D2_CLIENTE  =   SF2.F2_CLIENTE" + CRLF
	cQuery += "         AND SD2.D2_FILIAL   =   SF2.F2_FILIAL" + CRLF
	cQuery += "         AND SD2.D_E_L_E_T_  <>  '*'" + CRLF
	cQuery += "         AND ROWNUM          =   1" + CRLF
	cQuery += "     ) F4_CF," + CRLF
	cQuery += "     'INDUSTRIAL'," + CRLF
	cQuery += "     ZBV_TAXA," + CRLF
	cQuery += "     F2_VALBRUT * (ZBV_TAXA / 100) PREMIO," + CRLF
	cQuery += "     A1_MUN," + CRLF
	cQuery += "     A4_CGC," + CRLF
	cQuery += "     A4_NOME," + CRLF
	cQuery += "     DA3_PLACA," + CRLF
	cQuery += " " + CRLF
	cQuery += "     (" + CRLF
	cQuery += "         SELECT YQ_DESCR" + CRLF
	cQuery += "         FROM " + retSQLName("EE7") + " EE7" + CRLF
	cQuery += "         INNER JOIN " + retSQLName("SYQ") + " SYQ" + CRLF
	cQuery += "         ON" + CRLF
	cQuery += "             SYQ.YQ_VIA          =   EE7.EE7_VIA" + CRLF
	cQuery += "             AND SYQ.D_E_L_E_T_  <>  '*'" + CRLF
	cQuery += "         WHERE" + CRLF
	cQuery += "             EE7.EE7_PEDIDO  =   SC5.C5_PEDEXP  " + CRLF
	cQuery += "             AND EE7.D_E_L_E_T_  <>  '*'" + CRLF
	cQuery += "             AND ROWNUM          =   1" + CRLF
	cQuery += "     ) YQ_DESCR," + CRLF
	cQuery += "     (" + CRLF
	cQuery += "         SELECT EE7_PEDIDO" + CRLF
	cQuery += "         FROM " + retSQLName("EE7") + " EE7" + CRLF
	cQuery += "         WHERE" + CRLF
	cQuery += "             EE7.EE7_PEDIDO  =   SC5.C5_PEDEXP  " + CRLF
	cQuery += "         AND EE7.EE7_FILIAL  =   SC5.C5_FILIAL" + CRLF
	cQuery += "         AND EE7.D_E_L_E_T_  <>  '*'" + CRLF
	cQuery += "     ) EE7_PEDIDO," + CRLF
	cQuery += " " + CRLF
	cQuery += "     (" + CRLF
	cQuery += "         SELECT EX9_CONTNR" + CRLF
	cQuery += "         FROM " + retSQLName("EE7") + " EE7" + CRLF
	cQuery += "         INNER JOIN " + retSQLName("EEC") + " EEC" + CRLF
	cQuery += "         ON" + CRLF
	cQuery += "             EEC_PEDREF = EE7.EE7_PEDIDO" + CRLF
	cQuery += "         AND EEC.D_E_L_E_T_  <>  '*'" + CRLF
	cQuery += "         INNER JOIN " + retSQLName("EX9") + " EX9" + CRLF
	cQuery += "         ON" + CRLF
	cQuery += "             EX9.EX9_PREEMB  =   EEC.EEC_PREEMB" + CRLF
	cQuery += "         AND EX9.D_E_L_E_T_  <>  '*'" + CRLF
	cQuery += "         WHERE" + CRLF
	cQuery += "             EE7.EE7_PEDIDO  =   SC5.C5_PEDEXP  " + CRLF
	cQuery += "         AND EE7.EE7_FILIAL  =   SC5.C5_FILIAL" + CRLF
	cQuery += "         AND EE7.D_E_L_E_T_  <>  '*'" + CRLF
	cQuery += "         AND ROWNUM          =   1" + CRLF
	cQuery += "     ) EX9_CONTN1," + CRLF
	cQuery += " " + CRLF
	cQuery += "     (" + CRLF
	cQuery += "         SELECT EX9_CONTNR" + CRLF
	cQuery += "         FROM " + retSQLName("EE7") + " EE7" + CRLF
	cQuery += "         INNER JOIN " + retSQLName("EX9") + " EX9" + CRLF
	cQuery += "         ON" + CRLF
	cQuery += "             EX9.EX9_PREEMB  =   EE7.EE7_PEDIDO" + CRLF
	cQuery += "         AND EX9.D_E_L_E_T_  <>  '*'" + CRLF
	cQuery += "         WHERE" + CRLF
	cQuery += "             EE7.EE7_PEDIDO  =   SC5.C5_PEDEXP  " + CRLF
	cQuery += "         AND EE7.EE7_FILIAL  =   SC5.C5_FILIAL" + CRLF
	cQuery += "         AND EE7.D_E_L_E_T_  <>  '*'" + CRLF
	cQuery += "         AND ROWNUM          =   1" + CRLF
	cQuery += "     ) EX9_CONTN2," + CRLF

	cQuery += "     COALESCE((" + CRLF
	cQuery += "         SELECT" + CRLF
	cQuery += "             EEM_TXTB" + CRLF
	cQuery += "             *" + CRLF
	cQuery += "             (" + CRLF
	cQuery += "                 SELECT ZBV.ZBV_VALCNT" + CRLF
	cQuery += "                 FROM " + retSQLName("ZBV") + " ZBV" + CRLF
	cQuery += "                 WHERE" + CRLF
	cQuery += "                     SF2.F2_EMISSAO      >=  ZBV_DATAIN" + CRLF
	cQuery += "                 AND ( SF2.F2_EMISSAO    <=  ZBV_DATAFI OR ZBV_DATAFI = ' ' )" + CRLF
	cQuery += "                 AND ZBV_FILIAL          =   SF2.F2_FILIAL" + CRLF
	cQuery += "                 AND ZBV.D_E_L_E_T_      <>  '*'" + CRLF
	cQuery += "                 AND ROWNUM              =   1" + CRLF
	cQuery += "             )" + CRLF
	cQuery += "         FROM " + retSQLName("EEC") + " EEC" + CRLF
	cQuery += "         INNER JOIN " + retSQLName("EEM") + " EEM" + CRLF
	cQuery += "         ON" + CRLF
	cQuery += "             EEM.EEM_PREEMB  =   EEC.EEC_PREEMB" + CRLF
	cQuery += "         AND EEM.D_E_L_E_T_  <>  '*'" + CRLF
	cQuery += "         WHERE" + CRLF
	cQuery += "             EEC.EEC_PEDREF  =   SC5.C5_PEDEXP  " + CRLF
	cQuery += "         AND EEC.EEC_FILIAL  =   SC5.C5_FILIAL" + CRLF
	cQuery += "         AND EEC.D_E_L_E_T_  <>  '*'" + CRLF
	cQuery += "         AND ROWNUM          =   1" + CRLF
	cQuery += "     ), 0) / ZBV_VALCNT COTACAO1," + CRLF

	cQuery += "     COALESCE((" + CRLF
	cQuery += "         SELECT" + CRLF
	cQuery += "             EEM_TXTB" + CRLF
	cQuery += "             *" + CRLF
	cQuery += "             (" + CRLF
	cQuery += "                 SELECT ZBV.ZBV_VALCNT" + CRLF
	cQuery += "                 FROM " + retSQLName("ZBV") + " ZBV" + CRLF
	cQuery += "                 WHERE" + CRLF
	cQuery += "                     SF2.F2_EMISSAO      >=  ZBV_DATAIN" + CRLF
	cQuery += "                 AND ( SF2.F2_EMISSAO    <=  ZBV_DATAFI OR ZBV_DATAFI = ' ' )" + CRLF
	cQuery += "                 AND ZBV_FILIAL          =   SF2.F2_FILIAL" + CRLF
	cQuery += "                 AND ZBV.D_E_L_E_T_      <>  '*'" + CRLF
	cQuery += "                 AND ROWNUM              =   1" + CRLF
	cQuery += "             )" + CRLF
	cQuery += "         FROM " + retSQLName("EEC") + " EEC" + CRLF
	cQuery += "         INNER JOIN " + retSQLName("EEM") + " EEM" + CRLF
	cQuery += "         ON" + CRLF
	cQuery += "             EEM.EEM_PREEMB  =   EEC.EEC_PREEMB" + CRLF
	cQuery += "         AND EEM.D_E_L_E_T_  <>  '*'" + CRLF
	cQuery += "         WHERE" + CRLF
	cQuery += "             EEC.EEC_PEDREF  =   SC5.C5_PEDEXP  " + CRLF
	cQuery += "         AND EEC.EEC_FILIAL  =   SC5.C5_FILIAL" + CRLF
	cQuery += "         AND EEC.D_E_L_E_T_  <>  '*'" + CRLF
	cQuery += "         AND ROWNUM          =   1" + CRLF
	cQuery += "     ), 0) COTACAO2," + CRLF

	cQuery += "     COALESCE((" + CRLF
	cQuery += "         SELECT" + CRLF
	cQuery += "             EEM_TXTB" + CRLF
	cQuery += "             *" + CRLF
	cQuery += "             (" + CRLF
	cQuery += "                 SELECT ZBV.ZBV_VALCNT" + CRLF
	cQuery += "                 FROM " + retSQLName("ZBV") + " ZBV" + CRLF
	cQuery += "                 WHERE" + CRLF
	cQuery += "                     SF2.F2_EMISSAO      >=  ZBV_DATAIN" + CRLF
	cQuery += "                 AND ( SF2.F2_EMISSAO    <=  ZBV_DATAFI OR ZBV_DATAFI = ' ' )" + CRLF
	cQuery += "                 AND ZBV_FILIAL          =   SF2.F2_FILIAL" + CRLF
	cQuery += "                 AND ZBV.D_E_L_E_T_      <>  '*'" + CRLF
	cQuery += "                 AND ROWNUM              =   1" + CRLF
	cQuery += "             )" + CRLF
	cQuery += "         FROM " + retSQLName("EEC") + " EEC" + CRLF
	cQuery += "         INNER JOIN " + retSQLName("EEM") + " EEM" + CRLF
	cQuery += "         ON" + CRLF
	cQuery += "             EEM.EEM_PREEMB  =   EEC.EEC_PREEMB" + CRLF
	cQuery += "         AND EEM.D_E_L_E_T_  <>  '*'" + CRLF
	cQuery += "         WHERE" + CRLF
	cQuery += "             EEC.EEC_PEDREF  =   SC5.C5_PEDEXP  " + CRLF
	cQuery += "         AND EEC.EEC_FILIAL  =   SC5.C5_FILIAL" + CRLF
	cQuery += "         AND EEC.D_E_L_E_T_  <>  '*'" + CRLF
	cQuery += "         AND ROWNUM          =   1" + CRLF
	cQuery += "     ), 0) * ( ZBV.ZBV_TAXA / 100 ) PREMIO_CONT," + CRLF

	cQuery += "     COALESCE((" + CRLF
	cQuery += "         SELECT" + CRLF
	cQuery += "             EEM_TXTB" + CRLF
	cQuery += "             *" + CRLF
	cQuery += "             (" + CRLF
	cQuery += "                 SELECT ZBV.ZBV_VALCNT" + CRLF
	cQuery += "                 FROM " + retSQLName("ZBV") + " ZBV" + CRLF
	cQuery += "                 WHERE" + CRLF
	cQuery += "                     SF2.F2_EMISSAO      >=  ZBV_DATAIN" + CRLF
	cQuery += "                 AND ( SF2.F2_EMISSAO    <=  ZBV_DATAFI OR ZBV_DATAFI = ' ' )" + CRLF
	cQuery += "                 AND ZBV_FILIAL          =   SF2.F2_FILIAL" + CRLF
	cQuery += "                 AND ZBV.D_E_L_E_T_      <>  '*'" + CRLF
	cQuery += "                 AND ROWNUM              =   1" + CRLF
	cQuery += "             )" + CRLF
	cQuery += "         FROM " + retSQLName("EEC") + " EEC" + CRLF
	cQuery += "         INNER JOIN " + retSQLName("EEM") + " EEM" + CRLF
	cQuery += "         ON" + CRLF
	cQuery += "             EEM.EEM_PREEMB  =   EEC.EEC_PREEMB" + CRLF
	cQuery += "         AND EEM.D_E_L_E_T_  <>  '*'" + CRLF
	cQuery += "         WHERE" + CRLF
	cQuery += "             EEC.EEC_PEDREF  =   SC5.C5_PEDEXP  " + CRLF
	cQuery += "         AND EEC.EEC_FILIAL  =   SC5.C5_FILIAL" + CRLF
	cQuery += "         AND EEC.D_E_L_E_T_  <>  '*'" + CRLF
	cQuery += "         AND ROWNUM          =   1" + CRLF
	cQuery += "     ), 0) * ( ZBV.ZBV_TAXA / 100 )" + CRLF
	cQuery += "     + ( F2_VALBRUT * (ZBV_TAXA / 100) ) PREMTOTEXP," + CRLF
	cQuery += "     ( SF2.F2_VALBRUT * ZBV.ZBV_TAXA / 100 ) PREMTOT," + CRLF


	cQuery += "     (COALESCE((" + CRLF
	cQuery += "         SELECT" + CRLF
	cQuery += "             EEM_TXTB" + CRLF
	cQuery += "             *" + CRLF
	cQuery += "             (" + CRLF
	cQuery += "                 SELECT ZBV.ZBV_VALCNT" + CRLF
	cQuery += "                 FROM " + retSQLName("ZBV") + " ZBV" + CRLF
	cQuery += "                 WHERE" + CRLF
	cQuery += "                     SF2.F2_EMISSAO      >=  ZBV_DATAIN" + CRLF
	cQuery += "                 AND ( SF2.F2_EMISSAO    <=  ZBV_DATAFI OR ZBV_DATAFI = ' ' )" + CRLF
	cQuery += "                 AND ZBV_FILIAL          =   SF2.F2_FILIAL" + CRLF
	cQuery += "                 AND ZBV.D_E_L_E_T_      <>  '*'" + CRLF
	cQuery += "                 AND ROWNUM              =   1" + CRLF
	cQuery += "             )" + CRLF
	cQuery += "         FROM " + retSQLName("EEC") + " EEC" + CRLF
	cQuery += "         INNER JOIN " + retSQLName("EEM") + " EEM" + CRLF
	cQuery += "         ON" + CRLF
	cQuery += "             EEM.EEM_PREEMB  =   EEC.EEC_PREEMB" + CRLF
	cQuery += "         AND EEM.D_E_L_E_T_  <>  '*'" + CRLF
	cQuery += "         WHERE" + CRLF
	cQuery += "             EEC.EEC_PEDREF  =   SC5.C5_PEDEXP  " + CRLF
	cQuery += "         AND EEC.EEC_FILIAL  =   SC5.C5_FILIAL" + CRLF
	cQuery += "         AND EEC.D_E_L_E_T_  <>  '*'" + CRLF
	cQuery += "         AND ROWNUM          =   1" + CRLF
	cQuery += "     ), 0) * ( ZBV.ZBV_TAXA / 100 )" + CRLF
	cQuery += "     + ( F2_VALBRUT * (ZBV_TAXA / 100) )) * ( ZBV.ZBV_IOF / 100 ) PREMIOFEXP," + CRLF

	cQuery += "     ( SF2.F2_VALBRUT * ZBV.ZBV_TAXA / 100 ) + ( ( SF2.F2_VALBRUT * ZBV.ZBV_TAXA / 100 ) * ZBV.ZBV_IOF / 100 ) PREMTOTIOF" + CRLF
	cQuery += " FROM " + retSQLName("SF2") + " SF2" + CRLF

	cQuery += " INNER JOIN PROTHEUS.SYS_COMPANY SM0" + CRLF
	cQuery += " ON" + CRLF
	cQuery += "     SM0.M0_CODFIL   = SF2.F2_FILIAL" + CRLF
	cQuery += " AND SM0.D_E_L_E_T_  =  ' '" + CRLF

	cQuery += " LEFT JOIN " + retSQLName("DAI") + " DAI" + CRLF
	cQuery += " ON" + CRLF
	cQuery += "         DAI.DAI_SERIE   =   SF2.F2_SERIE" + CRLF
	cQuery += "     AND DAI.DAI_NFISCA  =   SF2.F2_DOC" + CRLF
	cQuery += "     AND DAI.DAI_LOJA    =   SF2.F2_LOJA" + CRLF
	cQuery += "     AND DAI.DAI_CLIENT  =   SF2.F2_CLIENTE" + CRLF
	cQuery += "     AND DAI.DAI_FILIAL  =   SF2.F2_FILIAL" + CRLF
	cQuery += "     AND DAI.D_E_L_E_T_  <>  '*'" + CRLF
	cQuery += " " + CRLF
	cQuery += " LEFT JOIN " + retSQLName("DAK") + " DAK" + CRLF
	cQuery += " ON" + CRLF
	cQuery += "     DAK.DAK_SEQCAR      =   DAI.DAI_SEQCAR" + CRLF
	cQuery += " AND DAK.DAK_COD         =   DAI.DAI_COD" + CRLF
	cQuery += " AND DAK.DAK_FILIAL      =   DAI.DAI_FILIAL" + CRLF
	cQuery += " AND DAK.D_E_L_E_T_      <>  '*'" + CRLF
	cQuery += " " + CRLF
	cQuery += " LEFT JOIN " + retSQLName("DA3") + " DA3" + CRLF
	cQuery += " ON" + CRLF
	cQuery += "     DA3.DA3_COD         =   DAK.DAK_CAMINH" + CRLF
	cQuery += " AND DA3.D_E_L_E_T_      <>  '*'" + CRLF
	cQuery += " " + CRLF
	cQuery += " INNER JOIN " + retSQLName("SC5") + " SC5" + CRLF
	cQuery += " ON" + CRLF
	cQuery += "         SC5.C5_NUM      =   DAI.DAI_PEDIDO" + CRLF
	cQuery += "     AND SC5.C5_LOJACLI  =   SF2.F2_LOJA" + CRLF
	cQuery += "     AND SC5.C5_CLIENTE  =   SF2.F2_CLIENTE" + CRLF
	cQuery += "     AND SC5.C5_FILIAL   =   SF2.F2_FILIAL" + CRLF
	cQuery += "     AND SC5.D_E_L_E_T_  <>  '*'" + CRLF
	cQuery += " INNER JOIN " + retSQLName("SZJ") + " SZJ" + CRLF
	cQuery += " ON" + CRLF
	cQuery += "     SZJ.ZJ_COD          =   SC5.C5_ZTIPPED" + CRLF
	cQuery += "     AND SZJ.D_E_L_E_T_  <>  '*'" + CRLF
	cQuery += " LEFT JOIN " + retSQLName("ZBV") + " ZBV" + CRLF
	cQuery += " ON" + CRLF
	cQuery += "         (" + CRLF
	cQuery += "         SF2.F2_EMISSAO  >=  ZBV.ZBV_DATAIN AND SF2.F2_EMISSAO <= ZBV.ZBV_DATAFI" + CRLF
	cQuery += "         OR" + CRLF
	cQuery += "         ZBV.ZBV_DATAFI  =   ' '" + CRLF
	cQuery += "         )" + CRLF
	cQuery += "     AND ZBV.ZBV_FILIAL  =   SF2.F2_FILIAL" + CRLF
	cQuery += "     AND ZBV.D_E_L_E_T_  <>  '*'" + CRLF

	cQuery += " INNER JOIN"										+ CRLF
	cQuery += " ("												+ CRLF
	cQuery += " 	SELECT *"									+ CRLF
	cQuery += " 	FROM "		+ retSQLName("SA1") + " SA1"	+ CRLF
	cQuery += " 	LEFT JOIN "	+ retSQLName("ZBC") + " ZBC"	+ CRLF
	cQuery += " 	ON"											+ CRLF
	cQuery += " 		SA1.A1_COD      =   ZBC.ZBC_CLIENT"		+ CRLF
	cQuery += " 	AND SA1.A1_LOJA     =   ZBC.ZBC_LJCLI"		+ CRLF
	cQuery += " 	AND ZBC.D_E_L_E_T_  <>   '*'"				+ CRLF
	cQuery += " 	WHERE"										+ CRLF
	cQuery += " 		ZBC.R_E_C_N_O_	IS NULL"				+ CRLF
	cQuery += " 	AND SA1.D_E_L_E_T_  <>   '*'"				+ CRLF
	cQuery += " ) SUBSA1"										+ CRLF
	cQuery += " ON"												+ CRLF
	cQuery += "         SUBSA1.A1_COD      =   SF2.F2_CLIENTE"	+ CRLF
	cQuery += "     AND SUBSA1.A1_LOJA     =   SF2.F2_LOJA"		+ CRLF

	cQuery += " LEFT JOIN " + retSQLName("SA4") + " SA4" + CRLF
	cQuery += " ON" + CRLF
	cQuery += "         SA4.A4_COD      =   SF2.F2_TRANSP" + CRLF
	cQuery += "     AND SA4.D_E_L_E_T_  <>   '*'" + CRLF
	cQuery += " WHERE" + CRLF
	cQuery += "         SF2.F2_EMISSAO  >=   '" + dToS( dEmissDx ) + "'" + CRLF
	cQuery += "     AND SF2.F2_EMISSAO  <=   '" + dToS( dEmissAx ) + "'    " + CRLF
	cQuery += "     AND SF2.D_E_L_E_T_  <>  '*'" + CRLF

	/*
	cQuery += "     AND SF2.F2_DOC		=	'000005993'" + CRLF
	cQuery += "     AND SF2.F2_SERIE	=	'200'" + CRLF
	*/

	cQuery += "     AND ( SF2.F2_FILIAL , SF2.F2_DOC , SF2.F2_SERIE , SF2.F2_CLIENTE , SF2.F2_LOJA )" + CRLF
	cQuery += "     IN" + CRLF
	cQuery += "     (" + CRLF
	cQuery += "         SELECT SD2.D2_FILIAL , SD2.D2_DOC , SD2.D2_SERIE , SD2.D2_CLIENTE , SD2.D2_LOJA" + CRLF
	cQuery += "         FROM "			+ retSQLName("SD2") + " SD2" + CRLF
	cQuery += "         INNER JOIN "	+ retSQLName("SB1") + " SB1" + CRLF
	cQuery += "         ON" + CRLF
	cQuery += "         	SD2.D2_COD		= SB1.B1_COD" + CRLF
	cQuery += "         AND	SB1.D_E_L_E_T_	= ' '" + CRLF
	
	cQuery += " 		INNER JOIN " + retSQLName("ZF0") + " ZF0 " + CRLF
	cQuery += 					" ON ZF0_CFOP = SD2.D2_CF "
	cQuery += 					" AND ZF0.D_E_L_E_T_= ' '  "
	
	cQuery += "         LEFT JOIN "		+ retSQLName("ZC3") + " ZC3" + CRLF
	cQuery += "         ON" + CRLF
	cQuery += "         	(SB1.B1_COD = ZC3_CODPRO OR SB1.B1_GRTRIB = ZC3_GRTRIB)" + CRLF
	cQuery += "         AND	ZC3.D_E_L_E_T_ = ' '" + CRLF
	cQuery += "         WHERE" + CRLF
	cQuery += " 				ZC3.R_E_C_N_O_ IS NULL" + CRLF
	cQuery += " 			AND	SD2.D2_EMISSAO  >=   '" + dToS( dEmissDx ) + "'" + CRLF
	cQuery += "     		AND SD2.D2_EMISSAO  <=   '" + dToS( dEmissAx ) + "'    " + CRLF
	cQuery += "     		AND	SD2.D2_SERIE    =   SF2.F2_SERIE" + CRLF
	cQuery += "             AND SD2.D2_DOC      =   SF2.F2_DOC" + CRLF
	cQuery += "             AND SD2.D2_LOJA     =   SF2.F2_LOJA" + CRLF
	cQuery += "             AND SD2.D2_CLIENTE  =   SF2.F2_CLIENTE" + CRLF
	cQuery += "             AND SD2.D2_FILIAL   =   SF2.F2_FILIAL" + CRLF

	cQuery += " 			AND	SD2.D2_COD		<=	'500000'" + CRLF
	

/*
	cQuery += "             AND " + CRLF
	cQuery += " 				(" + CRLF
	cQuery += " 				SD2.D2_COD      <=   '500000'" + CRLF
	cQuery += " 				OR" + CRLF
	cQuery += " 				SD2.D2_CF IN" + CRLF
	cQuery += " 				(" + CRLF
	cQuery += 					cTpfis
	cQuery += " 				)" + CRLF
*/
	cQuery += "             AND SD2.D_E_L_E_T_  <>  '*'" + CRLF
	//cQuery += " )" + CRLF
	cQuery += "     )" + CRLF

	memoWrite("C:\TEMP\MGFGFE17.SQL", cQuery)

	tcQuery cQuery New Alias (cQryGfe17)

	if !(cQryGfe17)->(EOF())
		aSF2 := {}

		while !(cQryGfe17)->(EOF())
			aadd(aSF2, { (cQryGfe17)->M0_CGC	,;
						sToD((cQryGfe17)->F2_EMISSAO)	,;
						(cQryGfe17)->F2_DOC		,;
						(cQryGfe17)->F2_SERIE	,;
						(cQryGfe17)->F2_VALBRUT	,;
						(cQryGfe17)->F2_PLIQUI	,;
						(cQryGfe17)->D2_PEDIDO	,;
						(cQryGfe17)->DAI_COD	,;
						(cQryGfe17)->ZJ_NOME	,;
						(cQryGfe17)->F4_CF		,;
						'INDUSTRIAL'			,;
						(cQryGfe17)->ZBV_TAXA	,;
						(cQryGfe17)->PREMIO		,;
						(cQryGfe17)->F2_EST		,;
						(cQryGfe17)->A1_MUN		,;
						(cQryGfe17)->A4_CGC		,;
						(cQryGfe17)->A4_NOME	,;
						(cQryGfe17)->DA3_PLACA	,;
						(cQryGfe17)->YQ_DESCR	,;
						(cQryGfe17)->EE7_PEDIDO	,;
						iif( !empty( (cQryGfe17)->EX9_CONTN1), (cQryGfe17)->EX9_CONTN1, (cQryGfe17)->EX9_CONTN2 )											,;
						(cQryGfe17)->COTACAO1																						,;
						(cQryGfe17)->COTACAO2																						,;
						iif( (cQryGfe17)->COTACAO2 > 0, round((cQryGfe17)->PREMIO_CONT, 2), 0 )											,;
						iif( !empty( (cQryGfe17)->EE7_PEDIDO ), (cQryGfe17)->PREMTOTEXP		, (cQryGfe17)->PREMTOT		) ,;
						iif( !empty( (cQryGfe17)->EE7_PEDIDO ), (cQryGfe17)->PREMIOFEXP	, (cQryGfe17)->PREMTOTIOF	) })
			(cQryGfe17)->(DBSkip())
		enddo
	endif



/*
		oGridGfe17:addColumn({"CNPJ"				  , {||aSF2[oGridGfe17:nAt,1]}	, "C", , 1, tamSx3("ZAV_FILIAL")[1]	})
		oGridGfe17:addColumn({"Data"				  , {||aSF2[oGridGfe17:nAt,2]}	, "C", , 1, tamSx3("ZAV_FILIAL")[1]	})
		oGridGfe17:addColumn({"Num. NF"				  , {||aSF2[oGridGfe17:nAt,3]}	, "C", , 1, tamSx3("ZAV_FILIAL")[1]	})
		oGridGfe17:addColumn({"Serie NF"			  , {||aSF2[oGridGfe17:nAt,4]}	, "C", , 1, tamSx3("ZAV_FILIAL")[1]	})
		oGridGfe17:addColumn({"Valor NF"			  , {||aSF2[oGridGfe17:nAt,5]}	, "C", , 1, tamSx3("ZAV_FILIAL")[1]	})
		oGridGfe17:addColumn({"Peso Líquido NF" 	  , {||aSF2[oGridGfe17:nAt,6]}	, "C", , 1, tamSx3("ZAV_FILIAL")[1]	})
		oGridGfe17:addColumn({"Num. Pedido"			  , {||aSF2[oGridGfe17:nAt,7]}	, "C", , 1, tamSx3("ZAV_FILIAL")[1]	})
		oGridGfe17:addColumn({"OE"       			  , {||aSF2[oGridGfe17:nAt,8]}	, "C", , 1, tamSx3("ZAV_FILIAL")[1]	})
		oGridGfe17:addColumn({"Tipo Pedido"			  , {||aSF2[oGridGfe17:nAt,9]}	, "C", , 1, tamSx3("ZAV_FILIAL")[1]	})
		oGridGfe17:addColumn({"Cod CFOP"			  , {||aSF2[oGridGfe17:nAt,10]}	, "C", , 1, tamSx3("ZAV_FILIAL")[1]	})
		oGridGfe17:addColumn({"Desc. CFOP"	    	  , {||aSF2[oGridGfe17:nAt,11]}	, "C", , 1, tamSx3("ZAV_FILIAL")[1]	})
		oGridGfe17:addColumn({"TP Carregamento"		  , {||aSF2[oGridGfe17:nAt,12]}	, "C", , 1, tamSx3("ZAV_FILIAL")[1]	})
		oGridGfe17:addColumn({"Taxa"				  , {||aSF2[oGridGfe17:nAt,13]}	, "C", , 1, tamSx3("ZAV_FILIAL")[1]	})
		oGridGfe17:addColumn({"Vlr Prêmio"			  , {||aSF2[oGridGfe17:nAt,14]}	, "C", , 1, tamSx3("ZAV_FILIAL")[1]	})
		oGridGfe17:addColumn({"Estado"			 	  , {||aSF2[oGridGfe17:nAt,15]}	, "C", , 1, tamSx3("ZAV_FILIAL")[1]	})
		oGridGfe17:addColumn({"Cidade"				  , {||aSF2[oGridGfe17:nAt,16]}	, "C", , 1, tamSx3("ZAV_FILIAL")[1]	})
		oGridGfe17:addColumn({"CNPJ Transp."		  , {||aSF2[oGridGfe17:nAt,17]}	, "C", , 1, tamSx3("ZAV_FILIAL")[1]	})
		oGridGfe17:addColumn({"Nome Transp."		  , {||aSF2[oGridGfe17:nAt,18]}	, "C", , 1, tamSx3("ZAV_FILIAL")[1]	})
		oGridGfe17:addColumn({"Placa"				  , {||aSF2[oGridGfe17:nAt,19]}	, "C", , 1, tamSx3("ZAV_FILIAL")[1]	})
		oGridGfe17:addColumn({"Tipo Embarque"		  , {||aSF2[oGridGfe17:nAt,20]}	, "C", , 1, tamSx3("ZAV_FILIAL")[1]	})
		oGridGfe17:addColumn({"EXP"					  , {||aSF2[oGridGfe17:nAt,21]}	, "C", , 1, tamSx3("ZAV_FILIAL")[1]	})
		oGridGfe17:addColumn({"N.Container"		      , {||aSF2[oGridGfe17:nAt,22]}	, "C", , 1, tamSx3("ZAV_FILIAL")[1]	})
		oGridGfe17:addColumn({"Valor Container"	      , {||aSF2[oGridGfe17:nAt,23]}	, "C", , 1, tamSx3("ZAV_FILIAL")[1]	})
		oGridGfe17:addColumn({"Premio Ref Container"  , {||aSF2[oGridGfe17:nAt,24]}	, "C", , 1, tamSx3("ZAV_FILIAL")[1]	})
		oGridGfe17:addColumn({"Premio Total"		  , {||aSF2[oGridGfe17:nAt,25]}	, "C", , 1, tamSx3("ZAV_FILIAL")[1]	})
		oGridGfe17:addColumn({"Premio Total c/IOF"    , {||aSF2[oGridGfe17:nAt,26]}	, "C", , 1, tamSx3("ZAV_FILIAL")[1]	})
		oGridGfe17:addColumn({"Itens que nao averbam" , {||aSF2[oGridGfe17:nAt,27]}	, "C", , 1, tamSx3("ZAV_FILIAL")[1]	})
*/


	(cQryGfe17)->(DBCloseArea())
return

user function xImpGFE17()
	private	aRet
	private	aParambox	:=	{}

	aadd(aParambox, {6, "Salvar arquivo Excel em"	, space(100)		, "@!"	, ""	, ""	, 070, .T., "Todos os Arquivos|*.*", GetTempPath(), GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE + GETF_RETDIRECTORY})

	if paramBox(aParambox, "Parâmetros"	, @aRet, , , .T. /*lCentered*/, 0, 0, , , .T. /*lCanSave*/, .T. /*lUserSave*/)
		cursorWait() //Mostra Ampulheta
		msAguarde({|| defRelat()}, "Aguarde...", "Gerando relatório!")
		cursorArrow() //Libera Ampulheta
	endif
return

static function defRelat()
	local oExcel	:= fwMSExcel():New()
	local oExcelApp	:= nil
	local cLocArq	:= allTrim(MV_PAR01)
	local cWrkSht1	:= "Seguro Nacional de Cargas"
	local cTblTit1	:= "MGF - Seguro Nacional de Cargas"
	local nCountQry	:= 0
	local nCountPro	:= 0

	if len(aSF2) <= 0
		msgAlert("Não há dados com os parâmetros informados.")
	else
		nCountQry := len(aSF2)

		msProcTxt("Montando estrutura da planilha...")

		oExcel:AddworkSheet(cWrkSht1)			//Cria Planilha
		oExcel:AddTable(cWrkSht1, cTblTit1) 	//Cria Tabela

		oExcel:AddColumn(cWrkSht1	, cTblTit1, "CNPJ"					, 1 /*nAlign - 1-Left,2-Center,3-Right*/, 1 /*nFormat - ( 1-General,2-Number,3-Monetário,4-DateTime )*/)
		oExcel:AddColumn(cWrkSht1	, cTblTit1, "Data"					, 1 /*nAlign - 1-Left,2-Center,3-Right*/, 1 /*nFormat - ( 1-General,2-Number,3-Monetário,4-DateTime )*/)
		oExcel:AddColumn(cWrkSht1	, cTblTit1, "Num. NF"				, 1 /*nAlign - 1-Left,2-Center,3-Right*/, 1 /*nFormat - ( 1-General,2-Number,3-Monetário,4-DateTime )*/)
		oExcel:AddColumn(cWrkSht1	, cTblTit1, "Serie NF"			 	, 1 /*nAlign - 1-Left,2-Center,3-Right*/, 1 /*nFormat - ( 1-General,2-Number,3-Monetário,4-DateTime )*/)
		oExcel:AddColumn(cWrkSht1	, cTblTit1, "Valor NF"				, 1 /*nAlign - 1-Left,2-Center,3-Right*/, 1 /*nFormat - ( 1-General,2-Number,3-Monetário,4-DateTime )*/)
		oExcel:AddColumn(cWrkSht1	, cTblTit1, "Peso Líquido NF" 		, 1 /*nAlign - 1-Left,2-Center,3-Right*/, 1 /*nFormat - ( 1-General,2-Number,3-Monetário,4-DateTime )*/)
		oExcel:AddColumn(cWrkSht1	, cTblTit1, "Num. Pedido"			, 1 /*nAlign - 1-Left,2-Center,3-Right*/, 1 /*nFormat - ( 1-General,2-Number,3-Monetário,4-DateTime )*/)
		oExcel:AddColumn(cWrkSht1	, cTblTit1, "OE"       			 	, 1 /*nAlign - 1-Left,2-Center,3-Right*/, 1 /*nFormat - ( 1-General,2-Number,3-Monetário,4-DateTime )*/)
		oExcel:AddColumn(cWrkSht1	, cTblTit1, "Tipo Pedido"			, 1 /*nAlign - 1-Left,2-Center,3-Right*/, 1 /*nFormat - ( 1-General,2-Number,3-Monetário,4-DateTime )*/)
		oExcel:AddColumn(cWrkSht1	, cTblTit1, "Cod CFOP"			 	, 1 /*nAlign - 1-Left,2-Center,3-Right*/, 1 /*nFormat - ( 1-General,2-Number,3-Monetário,4-DateTime )*/)
		oExcel:AddColumn(cWrkSht1	, cTblTit1, "TP Carregamento"		, 1 /*nAlign - 1-Left,2-Center,3-Right*/, 1 /*nFormat - ( 1-General,2-Number,3-Monetário,4-DateTime )*/)
		oExcel:AddColumn(cWrkSht1	, cTblTit1, "Taxa"				 	, 1 /*nAlign - 1-Left,2-Center,3-Right*/, 1 /*nFormat - ( 1-General,2-Number,3-Monetário,4-DateTime )*/)
		oExcel:AddColumn(cWrkSht1	, cTblTit1, "Vlr Prêmio"			, 1 /*nAlign - 1-Left,2-Center,3-Right*/, 1 /*nFormat - ( 1-General,2-Number,3-Monetário,4-DateTime )*/)
		oExcel:AddColumn(cWrkSht1	, cTblTit1, "Estado"			 	, 1 /*nAlign - 1-Left,2-Center,3-Right*/, 1 /*nFormat - ( 1-General,2-Number,3-Monetário,4-DateTime )*/)
		oExcel:AddColumn(cWrkSht1	, cTblTit1, "Cidade"				, 1 /*nAlign - 1-Left,2-Center,3-Right*/, 1 /*nFormat - ( 1-General,2-Number,3-Monetário,4-DateTime )*/)
		oExcel:AddColumn(cWrkSht1	, cTblTit1, "CNPJ Transp."		 	, 1 /*nAlign - 1-Left,2-Center,3-Right*/, 1 /*nFormat - ( 1-General,2-Number,3-Monetário,4-DateTime )*/)
		oExcel:AddColumn(cWrkSht1	, cTblTit1, "Nome Transp."		 	, 1 /*nAlign - 1-Left,2-Center,3-Right*/, 1 /*nFormat - ( 1-General,2-Number,3-Monetário,4-DateTime )*/)
		oExcel:AddColumn(cWrkSht1	, cTblTit1, "Placa"				 	, 1 /*nAlign - 1-Left,2-Center,3-Right*/, 1 /*nFormat - ( 1-General,2-Number,3-Monetário,4-DateTime )*/)
		oExcel:AddColumn(cWrkSht1	, cTblTit1, "Tipo Embarque"		 	, 1 /*nAlign - 1-Left,2-Center,3-Right*/, 1 /*nFormat - ( 1-General,2-Number,3-Monetário,4-DateTime )*/)
		oExcel:AddColumn(cWrkSht1	, cTblTit1, "EXP"					, 1 /*nAlign - 1-Left,2-Center,3-Right*/, 1 /*nFormat - ( 1-General,2-Number,3-Monetário,4-DateTime )*/)
		oExcel:AddColumn(cWrkSht1	, cTblTit1, "N.Container"		    , 1 /*nAlign - 1-Left,2-Center,3-Right*/, 1 /*nFormat - ( 1-General,2-Number,3-Monetário,4-DateTime )*/)
		oExcel:AddColumn(cWrkSht1	, cTblTit1, "Cotação"				, 1 /*nAlign - 1-Left,2-Center,3-Right*/, 1 /*nFormat - ( 1-General,2-Number,3-Monetário,4-DateTime )*/)
		oExcel:AddColumn(cWrkSht1	, cTblTit1, "Valor Container"		, 1 /*nAlign - 1-Left,2-Center,3-Right*/, 1 /*nFormat - ( 1-General,2-Number,3-Monetário,4-DateTime )*/)
		oExcel:AddColumn(cWrkSht1	, cTblTit1, "Premio Ref Container"	, 1 /*nAlign - 1-Left,2-Center,3-Right*/, 1 /*nFormat - ( 1-General,2-Number,3-Monetário,4-DateTime )*/)
		oExcel:AddColumn(cWrkSht1	, cTblTit1, "Premio Total"		 	, 1 /*nAlign - 1-Left,2-Center,3-Right*/, 1 /*nFormat - ( 1-General,2-Number,3-Monetário,4-DateTime )*/)
		oExcel:AddColumn(cWrkSht1	, cTblTit1, "Premio Total c/IOF"   	, 1 /*nAlign - 1-Left,2-Center,3-Right*/, 1 /*nFormat - ( 1-General,2-Number,3-Monetário,4-DateTime )*/)

		for nI := 1 to len(aSF2)
			nCountPro++

			msProcTxt("Processando " + str(nCountPro) + " de " + str(nCountQry) )

			aLinha := {}

			aadd( aLinha, aSF2[ nI, 1 ] )
			aadd( aLinha, aSF2[ nI, 2 ] )
			aadd( aLinha, aSF2[ nI, 3 ] )
			aadd( aLinha, aSF2[ nI, 4 ] )
			aadd( aLinha, aSF2[ nI, 5 ] )
			aadd( aLinha, aSF2[ nI, 6 ] )
			aadd( aLinha, aSF2[ nI, 7 ] )
			aadd( aLinha, aSF2[ nI, 8 ] )
			aadd( aLinha, aSF2[ nI, 9 ] )
			aadd( aLinha, aSF2[ nI, 10 ] )
			aadd( aLinha, aSF2[ nI, 11 ] )
			aadd( aLinha, aSF2[ nI, 12 ] )
			aadd( aLinha, aSF2[ nI, 13 ] )
			aadd( aLinha, aSF2[ nI, 14 ] )
			aadd( aLinha, aSF2[ nI, 15 ] )
			aadd( aLinha, aSF2[ nI, 16 ] )
			aadd( aLinha, aSF2[ nI, 17 ] )
			aadd( aLinha, aSF2[ nI, 18 ] )
			aadd( aLinha, aSF2[ nI, 19 ] )
			aadd( aLinha, aSF2[ nI, 20 ] )
			aadd( aLinha, aSF2[ nI, 21 ] )
			aadd( aLinha, aSF2[ nI, 22 ] )
			aadd( aLinha, aSF2[ nI, 23 ] )
			aadd( aLinha, aSF2[ nI, 24 ] )
			aadd( aLinha, aSF2[ nI, 25 ] )
			aadd( aLinha, aSF2[ nI, 26 ] )

			oExcel:addRow(cWrkSht1, cTblTit1, aLinha)
		next

		oExcel:Activate()

		cArq := CriaTrab(NIL, .F.) + ".xml"

		oExcel:GetXMLFile(cArq)

		oExcel:DeActivate()
		oExcel := nil
		freeObj( oExcel )
		delClassINTF()

		msProcTxt("Transferindo para estação...")

		if __CopyFile(cArq, cLocArq + cArq)
			MsgInfo("Relatório gerado em: " + cLocArq + cArq)
			oExcelApp := MsExcel():New()
			oExcelApp:WorkBooks:Open(cLocArq + cArq)
			oExcelApp:SetVisible(.T.)
			oExcelApp:Destroy()
			if !ApOleClient('MsExcel')
				msgAlert("Excel não esta instalado neste computador.")
			endIf

			oExcelApp := nil
			freeObj( oExcelApp )
			delClassINTF()
		endif
	endif
return
