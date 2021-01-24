#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"
#include 'fwmvcdef.ch'

#DEFINE CRLF		chr(13) + chr(10)

/*
=====================================================================================
Programa.:              MGFEEC73
Autor....:              Marcelo Carneiro
Data.....:              22/10/2019
Descricao / Objetivo:   Lançamentos Despesas de Terminais
Doc. Origem:            RTASK0010187
Solicitante:            Exportação
Obs......:              Chamado pelo programa MGFECC69 quando for Terminal
=====================================================================================
*/
User Function MGFEEC73()

Local dDtChegada := '' 
Local dDtSaida   := '' 
Local cContainer := ''
Local nTamanho   := 0 
Local nI         := 0 
Local nPos       := 0 
	
	
Private aExps					:= {}
private aDespes					:= {}
Private aDespGeral  			:= {}
private aDespesLan				:= {}
Private cTerminal   			:= ''
Private cIncDesp    			:= ''
Private nPosDesp    			:=01
Private nPosDesc      			:=02
Private nPosTab                	:=03
Private nPosMoeda             	:=04
Private nPosValorPre          	:=05
Private nPosDoc       			:=06
Private nPosSerie 				:=07
Private nPosEspecie 			:=08
Private nPosOper     			:=09
Private nPosEmissao   		    :=10
Private nPosValor               :=11
Private nPosTaxa      			:=12
Private nPosValorMoeda          :=13
Private nPosVenc       			:=14
Private nPosNat       			:=15
Private nPosCCusto       		:=16
Private nPosItemCtb      		:=17
Private nPosNFFornec     		:=18
Private nPosObs         		:=19
Private nPosTipo          	    :=20
Private nPosFornecedor 			:=21
Private nPosLoja             	:=22
Private nPosDetalhe             :=23
Private aCab        :={ {"Despesa"				, nPosDesp    	      },;
						{"Descrição"			, nPosDesc      	  },;
						{"Tabela Pré Cálculo"	, nPosTab             },;
						{"Moeda Pré Cálculo"	, nPosMoeda           },;
						{"Valor Pré Cálculo"	, nPosValorPre        },;
						{"Documento"			, nPosDoc       	  },;
						{"Série"				, nPosSerie 		  },;
						{"Espécie"				, nPosEspecie 	      },;
						{"Operação"			    , nPosOper		      },;
						{"Emissão"				, nPosEmissao		  },;
						{"Valor Documento"		, nPosValor		      },;
						{"Taxa Neg."			, nPosTaxa		      },;
						{"Valor Moeda"		    , nPosValorMoeda      },;
						{"Vencimento"			, nPosVenc		      },;
						{"Natureza"			    , nPosNat			  },;
						{"Centro Custo"		    , nPosCCusto		  },;
						{"Item Ctb.Deb"		    , nPosItemCtb		  },;
						{"NF FORNEC"			, nPosNFFornec	      },;
						{"Observação"		    , nPosObs			  },;
						{"Tipo"			        , nPosTipo            },;
						{"Fornecedor"           , nPosFornecedor      },;
						{"Loja"                 , nPosLoja            } }



For nI := 1 To Len(aMark)
    EEC->(dbGoTo(aMark[nI,01]))
	dDtChegada := Ctod('  /  /  ') 
	dDtSaida   := Ctod('  /  /  ') 
	cContainer := ''
	nTamanho   := 0 
    If ZB8->(dbSeek(xFilial('ZB8',EEC->EEC_FILIAL)+PADR(ALLtrim(EEC->EEC_ZEXP),TamSX3('ZB8_EXP')[01])+EEC->EEC_ZANOEX+EEC->EEC_ZSUBEX))
		dDtChegada := ZB8->ZB8_ZDTDEC 
		dDtSaida   := ZB8->ZB8_ZDAEST 
		cContainer := ZB8->ZB8_ZCONTA
		nTamanho   := GetAdvFVal("EYG","EYG_COMCON",xFilial('EYG',EEC->EEC_FILIAL)+ZB8->ZB8_ZCONTA,1,0)
		cTerminal  := ZB8->ZB8_TERMIN
    EndIf
	AAdd( aExps, {	EEC->EEC_FILIAL																	,;	//[01]
					EEC->EEC_PEDREF																	,;	//[02]
					EEC->EEC_IMPORT																	,;	//[03]
					EEC->EEC_IMLOJA																	,;	//[04]
					EEC->EEC_IMPODE																	,;	//[05]
					cTerminal																	,;	//[06]
					GetAdvFVal("SY5" , "Y5_NOME"	, xFilial("SY5") + cTerminal	, 1 , "")	    ,;	//[07]
					GetAdvFVal("SY5" , "Y5_FORNECE"	, xFilial("SY5") + cTerminal	, 1 , "")	    ,;	//[08]
					GetAdvFVal("SY5" , "Y5_LOJAF"	, xFilial("SY5") + cTerminal	, 1 , "")	    ,;	//[09]
					dDtChegada																	    ,;	//[10]
					dDtSaida																	    ,;	//[11]
					cContainer																	    ,;	//[12]
					nTamanho  																	   	} )	//[13]

Next nI

fwMsgRun(, { || getDesp() }		, "VerIficando despesas"				, "Aguarde. Selecionando despesas de Pré Cálculo..." )

fwMsgRun(, { || getDespLan() }	, "VerIficando despesas já lançadas"	, "Aguarde. Selecionando histórico de lançamento..." )

While !QRYHIST->(EOF())
	AAdd( aDespesLan, {	QRYHIST->EET_PEDIDO             ,;
	                    QRYHIST->EET_DESPES				,;
						QRYHIST->YB_DESCR				,;
						QRYHIST->EET_XTABPR				,;
						QRYHIST->EET_XMOEPR				,;
						QRYHIST->EET_XPRECA				,;
						QRYHIST->EET_DOCTO				,;
						""								,;
						""								,;
						""								,;
						sToD( QRYHIST->EET_DESADI )		,;
						QRYHIST->EET_VALORR				,;
						QRYHIST->EET_ZMOED				,;
						QRYHIST->EET_ZTX				,;
						QRYHIST->EET_ZVLMOE				,;
						sToD( QRYHIST->EET_DTVENC )		,;
						QRYHIST->EET_NATURE				,;
						QRYHIST->EET_PREFIX				,;
						QRYHIST->EET_ZCCUST				,;
						QRYHIST->EET_ZITEMD				,;
						QRYHIST->EET_ZNFORN } )
	QRYHIST->(DBSkip())
Enddo

QRYHIST->(DBCloseArea())

If !empty(aDespes)
	showDespes()
Else
	msgAlert("Não foram encontrados Despesas de Pré Cálculo.")
EndIf

Return

//-----------------------------------------
// Seleciona despesas
//-----------------------------------------
Static Function getDesp( cDespesa )

Local cQryZED := ""
Local nI 	  := 0
Local bPassou := .T. 
Local cZCCUST	    := GetMV('MGF_EEC75A',.F.,"2404")
Local cZITEMD	    := GetMV('MGF_EEC75B',.F.,"12")


If Select("QRYZED") > 0
	QRYZED->(dbCloseArea())
EndIf

cQryZED += " Select Distinct ZEE_CODDES	, ZEE_CODIGO,  ZED.ZED_DTINIC,ZED.ZED_DTFIM,ZEE_MOEDA, ZEE_PCALC"				+ CRLF
cQryZED += " From "+retSQLName("ZED")+ " ZED,"+retSQLName("ZEE")+" ZEE"								+ CRLF
cQryZED += " Where  ZEE.ZEE_TERMIN	=	'"+cTerminal+"'"								+ CRLF 
cQryZED += " 	AND	ZED.ZED_TIPODE	=	'T'"											+ CRLF 
cQryZED += " 	AND	ZEE.ZEE_CODIGO	=	ZED.ZED_CODIGO"									+ CRLF
cQryZED += " 	AND	ZEE.ZEE_FILIAL	=	ZED.ZED_FILIAL"									+ CRLF
cQryZED += " 	AND	ZEE.D_E_L_E_T_	<>	'*'"											+ CRLF
cQryZED += " 	AND	ZED.D_E_L_E_T_	<>	'*'"											+ CRLF
cQryZED += " Order by ZEE_CODDES"				+ CRLF

conout(cQryZED)
tcQuery cQryZED New Alias "QRYZED"

aDespGeral := {}
While !QRYZED->(EOF())
	bPassou := .F.
	For nI := 1  To Len(aExps)
		IF aExps[nI,11]  >= STOD(QRYZED->ZED_DTINIC) .AND. aExps[nI,11] <=STOD(QRYZED->ZED_DTFIM) 
           bPassou := .T.
		   Exit
        EndIF
	Next nI
	IF bPassou
		If QRYZED->ZEE_PCALC <>	'S'	
			cIncDesp +=  ' | '+QRYZED->ZEE_CODDES
			AAdd(aDespGeral,{QRYZED->ZEE_CODDES,QRYZED->ZEE_CODIGO,QRYZED->ZEE_MOEDA,QRYZED->ZED_DTINIC,QRYZED->ZED_DTFIM})
		Else
			AAdd( aDespes, {	QRYZED->ZEE_CODDES																											,; //[01] - "Despesa"
								GetAdvFVal("SYB","YB_DESCR",xFilial("SYB")+QRYZED->ZEE_CODDES,1,"")															,; //[02] - "Descrição"
								QRYZED->ZEE_CODIGO																											,; //[03] - "Tabela Pré Cálculo"
								QRYZED->ZEE_MOEDA																											,; //[04] - "Moeda Pré Cálculo"
								0																															,; //[05] - "Valor Pré Cálculo"
								space( tamSx3("E2_NUM")[1] )																								,; //[06] - "Documento"
								space( tamSx3("F1_SERIE")[1] )																								,; //[07] - "Série"
								space( tamSx3("F1_ESPECIE")[1] )																							,; //[08] - "Espécie"
								space( tamSx3("D1_OPER")[1] )																								,; //[09] - "Operação"
								cToD("//")																													,; //[10] - "Emissão"
								0																															,; //[11] - "Valor Documento"
								0																															,; //[12] - "Taxa Neg."
								0																															,; //[12] - "Taxa Neg."
								cToD("//")																													,; //[13] - "Vencimento"
								getAdvFVal( "SYB" , "YB_NATURE" , xFilial("SYB") + QRYZED->ZEE_CODDES , 1 , "")												,; //[14] - "Natureza"
								cZCCUST																														,; //[16] - "Centro Custo"
								cZITEMD																														,; //[17] - "Item Ctb.Deb"
								space( tamSx3("EET_ZNFORN")[1] )																							,; //[18] - "NF FORNEC"
								space( tamSx3("EET_ZOBS")[1] )																								,; //[19] - "Observação"
								'T' /*space( tamSx3("ZEE_TIPODE")[1] )*/																					,; //[20] - "Tipo Despesa"
								aExps[ 1 , 08 ]  																											,; //[21] - "Fornecedor"
								aExps[ 1 , 09 ],{} }) //[25] e 26- "Desc. Fornecedor"
			Calcula_Desp(Len(aDespes))
		EndIf
	EndIF
	QRYZED->(DBSkip())
Enddo

If Select("QRYZED") > 0
	QRYZED->(dbCloseArea())
EndIf

Return

//------------------------------------------------------
// Mostra os dados
//------------------------------------------------------
static function showDespes()
	Local oDlgDespes	:= nil
	Local aCoors		:= 	FWGetDialogSize( oMainWnd )
	Local bOk			:= { || iIf( chkAllOk() , fwMsgRun(, { || Gera_Nota() , IIF(bSair,oDlgDespes:End(),)  }, "Incluindo Pedido de Compra / Nota de Entrada", "Aguarde. Incluindo Pedido de Compra /  Nota de Entrada..." ) , ) }
	Local bClose		:= { || oDlgDespes:End() }
	Local aButtons      := {{"Inclui Despesa", {|| Inclui_Linha()}, "Inclui Despesa","Inclui Despesa",{|| .T.}} } 

	private oFWLayer	:= nil
	private oExpsBrw	:= nil
	private oDespesBrw	:= nil
	private oHistorBrw	:= nil
	Private bSair       := .F.

	DEFINE MSDIALOG oDlgDespes TITLE 'Despesas de Pré Cálculo' FROM aCoors[1], aCoors[2] TO aCoors[3], aCoors[4] PIXEL STYLE DS_MODALFRAME
		oFWLayer := FWLayer():New()
		oFWLayer:Init( oDlgDespes /*oOwner*/, .F. /*lCloseBtn*/)

		oFWLayer:AddLine( 'UP'		/*cID*/, 35 /*nPercHeight*/, .F. /*lFixed*/)
		oFWLayer:AddLine( 'MIDDLE'	/*cID*/, 35 /*nPercHeight*/, .F. /*lFixed*/)
		oFWLayer:AddLine( 'DOWN'	/*cID*/, 28 /*nPercHeight*/, .F. /*lFixed*/)

		oFWLayer:AddCollumn( 'ALLUP'	/*cID*/, 100 /*nPercWidth*/, .T. /*lFixed*/, 'UP'		/*cIDLine*/)
		oFWLayer:AddCollumn( 'ALLMD'	/*cID*/, 100 /*nPercWidth*/, .T. /*lFixed*/, 'MIDDLE'	/*cIDLine*/)
		oFWLayer:AddCollumn( 'ALLDW'	/*cID*/, 100 /*nPercWidth*/, .T. /*lFixed*/, 'DOWN'		/*cIDLine*/)

		oPanelUp	:= oFWLayer:GetColPanel( 'ALLUP', 'UP'		)
		oPanelMd	:= oFWLayer:GetColPanel( 'ALLMD', 'MIDDLE'	)
		oPanelDw	:= oFWLayer:GetColPanel( 'ALLDW', 'DOWN'	)

		// Browse de cima com as EXPs selecionadas
		oExpsBrw := fwBrowse():New()
		oExpsBrw:setDataArray()
		oExpsBrw:setArray( aExps )
		oExpsBrw:disableConfig()
		oExpsBrw:disableReport()
		oExpsBrw:setOwner( oPanelUp )

		oExpsBrw:addColumn({"Filial"				, { || aExps[oExpsBrw:nAt,01] }, "C", pesqPict("EEC","EEC_FILIAL")	, 1, tamSx3("EEC_FILIAL")[1]/2	,							, .F.})
		oExpsBrw:addColumn({"EXP"					, { || aExps[oExpsBrw:nAt,02] }, "C", pesqPict("EEC","EEC_PEDREF")	, 1, tamSx3("EEC_PEDREF")[1]/2	,							, .F.})
		oExpsBrw:addColumn({"Código Imp."			, { || aExps[oExpsBrw:nAt,03] }, "C", pesqPict("EEC","EEC_IMPORT")	, 1, tamSx3("EEC_IMPORT")[1]/2	,							, .F.})
		oExpsBrw:addColumn({"Loja Imp."				, { || aExps[oExpsBrw:nAt,04] }, "C", pesqPict("EEC","EEC_IMLOJA")	, 1, tamSx3("EEC_IMLOJA")[1]/2	,							, .F.})
		oExpsBrw:addColumn({"Importador"			, { || aExps[oExpsBrw:nAt,05] }, "C", pesqPict("EEC","EEC_IMPODE")	, 1, tamSx3("EEC_IMPODE")[1]/2	,							, .F.})
		oExpsBrw:addColumn({"Cód. Terminal"			, { || aExps[oExpsBrw:nAt,06] }, "C", pesqPict("SY5","Y5_COD")		, 1, tamSx3("Y5_COD")[1]/2		,							, .F.})
		oExpsBrw:addColumn({"Terminal"				, { || aExps[oExpsBrw:nAt,07] }, "C", pesqPict("SY5","Y5_NOME")		, 1, tamSx3("Y5_NOME")[1]/2		,							, .F.})
		oExpsBrw:addColumn({"Terminal Fornec."		, { || aExps[oExpsBrw:nAt,08] }, "C", pesqPict("SY5","Y5_FORNECE")	, 1, tamSx3("Y5_FORNECE")[1]/2	,							, .F.})
		oExpsBrw:addColumn({"Terminal Loja"			, { || aExps[oExpsBrw:nAt,09] }, "C", pesqPict("SY5","Y5_LOJAF")	, 1, tamSx3("Y5_LOJAF")[1]/2	,							, .F.})
		oExpsBrw:addColumn({"Dt Chegada"			, { || aExps[oExpsBrw:nAt,10] }, "D", pesqPict("ZB8","ZB8_ZDTDEC")	, 1, tamSx3("ZB8_ZDTDEC")[1]/2	,							, .F.})
		oExpsBrw:addColumn({"Dt Saida"  			, { || aExps[oExpsBrw:nAt,11] }, "D", pesqPict("ZB8","ZB8_ZDAEST")	, 1, tamSx3("ZB8_ZDAEST")[1]/2	,							, .F.})
		oExpsBrw:addColumn({"Container"		    	, { || aExps[oExpsBrw:nAt,12] }, "C", pesqPict("ZB8","ZB8_ZCONTA")	, 1, tamSx3("ZB8_ZCONTA")[1]/2	,							, .F.})
		oExpsBrw:addColumn({"Tam.Container"	     	, { || aExps[oExpsBrw:nAt,13] }, "N", "@E 99,999.9999"	, 1, tamSx3("EYG_COMCON")[1]/2	,							, .F.}) 

		oExpsBrw:activate( .T. )

		// Browse do meio de Despesas
		oDespesBrw := fwBrowse():New()
		oDespesBrw:setDataArray()
		oDespesBrw:setArray( aDespes )
		oDespesBrw:disableConfig()
		oDespesBrw:disableReport()
		oDespesBrw:setOwner( oPanelMd )


/* add(Column
[n][01] Título da coluna
[n][02] Code-Block de carga dos dados
[n][03] Tipo de dados
[n][04] Máscara
[n][05] Alinhamento (0=Centralizado, 1=Esquerda ou 2=Direita)
[n][06] Tamanho
[n][07] Decimal
[n][08] Indica se permite a edição
[n][09] Code-Block de validação da coluna após a edição
[n][10] Indica se exibe imagem
[n][11] Code-Block de execução do duplo clique
[n][12] Variável a ser utilizada na edição (ReadVar)
[n][13] Code-Block de execução do clique no header
[n][14] Indica se a coluna está deletada
[n][15] Indica se a coluna será exibida nos detalhes do Browse
[n][16] Opções de carga dos dados (Ex: 1=Sim, 2=Não)
[n][17] Id da coluna
[n][18] Indica se a coluna é virtual
*/

		oDespesBrw:addColumn({aCab[01][01]	, {||aDespes[oDespesBrw:nAt,nPosDesp      ]}, "C", pesqPict("ZEE","ZEE_CODDES")	, 1, tamSx3("ZEE_CODDES")[1]/2	,							, .F., , .F.,, ,, .F., .T.,												, })
		oDespesBrw:addColumn({aCab[02][01]	, {||aDespes[oDespesBrw:nAt,nPosDesc      ]}, "C", pesqPict("ZEE","ZEE_DESPES")	, 1, tamSx3("ZEE_DESPES")[1]/2	,							, .F., , .F.,, ,, .F., .T.,												, })
		oDespesBrw:addColumn({aCab[03][01]	, {||aDespes[oDespesBrw:nAt,nPosTab       ]}, "C", pesqPict("ZEE","ZEE_CODIGO")	, 1, tamSx3("ZEE_CODIGO")[1]/2	,							, .F., , .F.,,"xVALOR" ,, .F., .T.,												, })
		oDespesBrw:addColumn({aCab[04][01]	, {||aDespes[oDespesBrw:nAt,nPosMoeda     ]}, "C", pesqPict("ZEE","ZEE_MOEDA")	, 1, tamSx3("ZEE_MOEDA")[1]/2	,							, .F., , .F.,,"xVALOR" ,, .F., .T.,												, })
		oDespesBrw:addColumn({aCab[05][01]	, {||aDespes[oDespesBrw:nAt,nPosValorPre  ]}, "N", pesqPict("ZEE","ZEE_VALOR")	, 2, tamSx3("ZEE_VALOR")[1]		, tamSx3("ZEE_VALOR")[2]	, .F., , .F.,,"xVALOR" ,, .F., .T.,												, })
		oDespesBrw:addColumn({aCab[06][01]	, {||aDespes[oDespesBrw:nAt,nPosDoc       ]}, "C", pesqPict("SE2","E2_NUM")		, 1, tamSx3("E2_NUM")[1]		, tamSx3("E2_NUM")[2]		, .T., , .F.,,"xVALOR" ,, .F., .T.,												, })
		oDespesBrw:addColumn({aCab[07][01]	, {||aDespes[oDespesBrw:nAt,nPosSerie 	  ]}, "C", pesqPict("SF1","F1_SERIE")	, 1, tamSx3("F1_SERIE")[1]		, tamSx3("F1_SERIE")[2]		, .T., , .F.,,"xVALOR" ,, .F., .T.,												, })
		oDespesBrw:addColumn({aCab[08][01]	, {||aDespes[oDespesBrw:nAt,nPosEspecie   ]}, "C", pesqPict("SF1","F1_ESPECIE")	, 1, tamSx3("F1_ESPECIE")[1]	, tamSx3("F1_ESPECIE")[2]	, .T., , .F.,,"xVALOR" ,, .F., .T.,												, })
		oDespesBrw:addColumn({aCab[09][01]	, {||aDespes[oDespesBrw:nAt,nPosOper      ]}, "C", pesqPict("SD1","D1_OPER")	, 1, tamSx3("D1_OPER")[1]		, tamSx3("D1_OPER")[2]		, .T., , .F.,,"xVALOR" ,, .F., .T.,												, })
		oDespesBrw:addColumn({aCab[10][01]	, {||aDespes[oDespesBrw:nAt,nPosEmissao   ]}, "D", pesqPict("SE2","E2_EMISSAO")	, 1, tamSx3("E2_EMISSAO")[1]	, tamSx3("E2_EMISSAO")[2]	, .T., , .F.,,"xVALOR" ,, .F., .T., 												, })
		oDespesBrw:addColumn({aCab[11][01]	, {||aDespes[oDespesBrw:nAt,nPosValor     ]}, "N", pesqPict("SE2","E2_VALOR")	, 2, tamSx3("E2_VALOR")[1]		, tamSx3("E2_VALOR")[2]		, .F., , .F.,,"xVALOR" ,, .F., .T.,												, })
		oDespesBrw:addColumn({aCab[12][01]	, {||aDespes[oDespesBrw:nAt,nPosTaxa      ]}, "N", pesqPict("EET","EET_ZTX")	, 2, tamSx3("EET_ZTX")[1]		, tamSx3("EET_ZTX")[2]		, .T., , .F.,,"xVALOR" ,, .F., .T.,											    , })
		oDespesBrw:addColumn({aCab[13][01]	, {||aDespes[oDespesBrw:nAt,nPosValorMoeda]}, "N", pesqPict("SE2","E2_VALOR")	, 2, tamSx3("E2_VALOR")[1]		, tamSx3("E2_VALOR")[2]		, .F., , .F.,,"xVALOR" ,, .F., .T.,												, })
		oDespesBrw:addColumn({aCab[14][01]	, {||aDespes[oDespesBrw:nAt,nPosVenc      ]}, "D", pesqPict("EET","EET_DTVENC")	, 1, tamSx3("EET_DTVENC")[1]	, tamSx3("EET_DTVENC")[2]	, .T., , .F.,,"xVALOR" ,, .F., .T.,												, })
		oDespesBrw:addColumn({aCab[15][01]	, {||aDespes[oDespesBrw:nAt,nPosNat       ]}, "C", pesqPict("EET","EET_NATURE")	, 1, tamSx3("EET_NATURE")[1]	, tamSx3("EET_NATURE")[2]	, .T., , .F.,,"xVALOR" ,, .F., .T.,												, })
		oDespesBrw:addColumn({aCab[16][01]	, {||aDespes[oDespesBrw:nAt,nPosCCusto    ]}, "C", pesqPict("EET","EET_ZCCUST")	, 1, tamSx3("EET_ZCCUST")[1]	, tamSx3("EET_ZCCUST")[2]	, .F., , .F.,,"xVALOR" ,, .F., .T.,												, })
		oDespesBrw:addColumn({aCab[17][01]	, {||aDespes[oDespesBrw:nAt,nPosItemCtb   ]}, "C", pesqPict("EET","EET_ZITEMD")	, 1, tamSx3("EET_ZITEMD")[1]	, tamSx3("EET_ZITEMD")[2]	, .F., , .F.,,"xVALOR" ,, .F., .T.,												, })
		oDespesBrw:addColumn({aCab[18][01]	, {||aDespes[oDespesBrw:nAt,nPosNFFornec  ]}, "C", pesqPict("EET","EET_ZNFORN")	, 1, tamSx3("EET_ZNFORN")[1]	, tamSx3("EET_ZNFORN")[2]	, .T., , .F.,,"xVALOR" ,, .F., .T.,												, })
		oDespesBrw:addColumn({aCab[19][01]	, {||aDespes[oDespesBrw:nAt,nPosObs       ]}, "C", pesqPict("EET","EET_ZOBS")	, 1, tamSx3("EET_ZOBS")[1]		, tamSx3("EET_ZOBS")[2]		, .T., , .F.,,"xVALOR" ,, .F., .T.,												, })
		oDespesBrw:addColumn({aCab[20][01]	, {||aDespes[oDespesBrw:nAt,nPosTipo      ]}, "C", pesqPict("ZEE","ZEE_TIPODE")	, 1, tamSx3("ZEE_TIPODE")[1]	, tamSx3("ZEE_TIPODE")[2]	, .F., , .F.,,"xVALOR" ,, .F., .T., { "A=Armador","D=Despachante","T=Terminal" }	, })
		oDespesBrw:addColumn({aCab[21][01]	, {||aDespes[oDespesBrw:nAt,nPosFornecedor]}, "C", pesqPict("SY5","Y5_COD")		, 1, tamSx3("Y5_COD")[1]		, tamSx3("Y5_COD")[2]		, .F., , .F.,,"xVALOR" ,, .F., .T.,												, })
		oDespesBrw:addColumn({aCab[22][01] , {||aDespes[oDespesBrw:nAt,nPosLoja      ]}, "C", pesqPict("SY5","Y5_NOME")	, 1, tamSx3("Y5_NOME")[1]		, tamSx3("Y5_NOME")[2]		, .F., , .F.,,"xVALOR" ,, .F., .T.,												, })

		oDespesBrw:setEditCell( .T. , { || vldDoc() } )

		oDespesBrw:setInsert( .F. )
		oDespesBrw:SetDoubleClick ( { || IIf(oDespesBrw:ColPos()==nPosValorPre,Vis_Detalhes(),.F.) } )
		oDespesBrw:setLineOk( { || chkLineOk() } )
        SetKey(VK_F4, {|| Inclui_Linha()})
  
		oDespesBrw:activate( .T. )
		

		// Browse do meio de Despesas
		oHistorBrw := fwBrowse():New()
		oHistorBrw:setDataArray()
		oHistorBrw:setArray( aDespesLan )
		oHistorBrw:disableConfig()
		oHistorBrw:disableReport()
		oHistorBrw:setOwner( oPanelDw )

		oHistorBrw:addColumn({"EXP"					, {||aDespesLan[oHistorBrw:nAt,01]}, "C", pesqPict("EEC","EEC_PEDREF")	, 1, tamSx3("EEC_PEDREF")[1]/2	,							, .F.})
		oHistorBrw:addColumn({"Despesa"				, {||aDespesLan[oHistorBrw:nAt,02]}, "C", pesqPict("ZEE","ZEE_CODDES")	, 1, tamSx3("ZEE_CODDES")[1]/2	,							, .T. , , .F.,, ,, .F., .T.,									, })
		oHistorBrw:addColumn({"Descrição"			, {||aDespesLan[oHistorBrw:nAt,03]}, "C", pesqPict("ZEE","ZEE_DESPES")	, 1, tamSx3("ZEE_DESPES")[1]/2	,							, .F. , , .F.,, ,, .F., .T.,									, })
		oHistorBrw:addColumn({"Tabela Pré Cálculo"	, {||aDespesLan[oHistorBrw:nAt,04]}, "C", pesqPict("ZEE","ZEE_CODIGO")	, 1, tamSx3("ZEE_CODIGO")[1]/2	,							, .F. , , .F.,, ,, .F., .T.,									, })
		oHistorBrw:addColumn({"Moeda Pré Cálculo"	, {||aDespesLan[oHistorBrw:nAt,05]}, "C", pesqPict("ZEE","ZEE_MOEDA")	, 1, tamSx3("ZEE_MOEDA")[1]/2	,							, .F. , , .F.,, ,, .F., .T.,									, })
		oHistorBrw:addColumn({"Valor Pré Cálculo"	, {||aDespesLan[oHistorBrw:nAt,06]}, "N", pesqPict("ZEE","ZEE_VALOR")	, 2, tamSx3("ZEE_VALOR")[1]		, tamSx3("ZEE_VALOR")[2]	, .F. , , .F.,, ,, .F., .T.,									, })
		oHistorBrw:addColumn({"Documento"			, {||aDespesLan[oHistorBrw:nAt,07]}, "C", pesqPict("SE2","E2_NUM")		, 1, tamSx3("E2_NUM")[1]		, tamSx3("E2_NUM")[2]		, .T. , , .F.,, ,, .F., .T.,									, })
		oHistorBrw:addColumn({"Série"				, {||aDespesLan[oHistorBrw:nAt,08]}, "C", pesqPict("SF1","F1_SERIE")	, 1, tamSx3("F1_SERIE")[1]		, tamSx3("F1_SERIE")[2]		, .T. , , .F.,, ,, .F., .T.,									, })
		oHistorBrw:addColumn({"Espécie"				, {||aDespesLan[oHistorBrw:nAt,09]}, "C", pesqPict("SF1","F1_ESPECIE")	, 1, tamSx3("F1_ESPECIE")[1]	, tamSx3("F1_ESPECIE")[2]	, .T. , , .F.,, ,, .F., .T.,									, })
		oHistorBrw:addColumn({"Operação"			, {||aDespesLan[oHistorBrw:nAt,10]}, "C", pesqPict("SD1","D1_OPER")		, 1, tamSx3("D1_OPER")[1]		, tamSx3("D1_OPER")[2]		, .T. , , .F.,, ,, .F., .T.,									, })
		oHistorBrw:addColumn({"Emissão"				, {||aDespesLan[oHistorBrw:nAt,11]}, "D", pesqPict("SE2","E2_EMISSAO")	, 1, tamSx3("E2_EMISSAO")[1]	, tamSx3("E2_EMISSAO")[2]	, .T. , , .F.,, ,, .F., .T., 									, })
		oHistorBrw:addColumn({"Valor Documento"		, {||aDespesLan[oHistorBrw:nAt,12]}, "N", pesqPict("SE2","E2_VALOR")	, 2, tamSx3("E2_VALOR")[1]		, tamSx3("E2_VALOR")[2]		, .T. , , .F.,, ,, .F., .T.,									, })
		oHistorBrw:addColumn({"Moeda"				, {||aDespesLan[oHistorBrw:nAt,13]}, "C", pesqPict("EET","EET_ZMOED")	, 1, tamSx3("EET_ZMOED")[1]		, tamSx3("EET_ZMOED")[2]	, .T. , , .F.,, ,, .F., .T., { "1=R$","2=US$","3=EUR","4=GBP" }	, })
		oHistorBrw:addColumn({"Taxa Neg."			, {||aDespesLan[oHistorBrw:nAt,14]}, "N", pesqPict("EET","EET_ZTX")		, 2, tamSx3("EET_ZTX")[1]		, tamSx3("EET_ZTX")[2]		, .T. , , .F.,, ,, .F., .T.,									, })
		oHistorBrw:addColumn({"Valor Moeda"			, {||aDespesLan[oHistorBrw:nAt,15]}, "N", pesqPict("EET","EET_ZVLMOE")	, 2, tamSx3("EET_ZVLMOE")[1]	, tamSx3("EET_ZVLMOE")[2]	, .T. , , .F.,, ,, .F., .T.,									, })
		oHistorBrw:addColumn({"Vencimento"			, {||aDespesLan[oHistorBrw:nAt,16]}, "D", pesqPict("EET","EET_DTVENC")	, 1, tamSx3("EET_DTVENC")[1]	, tamSx3("EET_DTVENC")[2]	, .T. , , .F.,, ,, .F., .T.,									, })
		oHistorBrw:addColumn({"Natureza"			, {||aDespesLan[oHistorBrw:nAt,17]}, "C", pesqPict("EET","EET_NATURE")	, 1, tamSx3("EET_NATURE")[1]	, tamSx3("EET_NATURE")[2]	, .T. , , .F.,, ,, .F., .T.,									, })
		oHistorBrw:addColumn({"Prefixo"				, {||aDespesLan[oHistorBrw:nAt,18]}, "C", pesqPict("EET","EET_PREFIX")	, 1, tamSx3("EET_PREFIX")[1]	, tamSx3("EET_PREFIX")[2]	, .T. , , .F.,, ,, .F., .T.,									, })
		oHistorBrw:addColumn({"Centro Custo"		, {||aDespesLan[oHistorBrw:nAt,19]}, "C", pesqPict("EET","EET_ZCCUST")	, 1, tamSx3("EET_ZCCUST")[1]	, tamSx3("EET_ZCCUST")[2]	, .F. , , .F.,, ,, .F., .T.,									, })
		oHistorBrw:addColumn({"Item Ctb.Deb"		, {||aDespesLan[oHistorBrw:nAt,20]}, "C", pesqPict("EET","EET_ZITEMD")	, 1, tamSx3("EET_ZITEMD")[1]	, tamSx3("EET_ZITEMD")[2]	, .F. , , .F.,, ,, .F., .T.,									, })
		oHistorBrw:addColumn({"NF FORNEC"			, {||aDespesLan[oHistorBrw:nAt,21]}, "C", pesqPict("EET","EET_ZNFORN")	, 1, tamSx3("EET_ZNFORN")[1]	, tamSx3("EET_ZNFORN")[2]	, .T. , , .F.,, ,, .F., .T.,									, })

		oHistorBrw:activate( .T. )

		enchoiceBar(oDlgDespes, bOk , bClose,, aButtons)
	ACTIVATE MSDIALOG oDlgDespes CENTER
	SetKey(VK_F4, {||})
	
return


//-------------------------------------------------------
//-------------------------------------------------------
static function vldDoc()
	Local nI			:= 0
	Local lRetVld       := .T.
	Local nCol          := oDespesBrw:ColPos()
    Local nGeral        := 0 
    
	If nCol == nPosDoc
		If !Empty( M->xValor )
		    For nI := 1 to Len( aDespes )
				If aDespes[ nI , nPosDoc ] == M->xValor	.and.   nI <> oDespesBrw:at()																	;
			
					aDespes[ oDespesBrw:at() , nPosSerie   ]:= aDespes[ nI , nPosSerie	]
					aDespes[ oDespesBrw:at() , nPosEspecie ]:= aDespes[ nI , nPosEspecie 	]
					aDespes[ oDespesBrw:at() , nPosOper	   ]:= aDespes[ nI , nPosOper		]
					aDespes[ oDespesBrw:at() , nPosEmissao ]:= aDespes[ nI , nPosEmissao		]
					aDespes[ oDespesBrw:at() , nPosVenc	   ]:= aDespes[ nI , nPosVenc		]
					aDespes[ oDespesBrw:at() , nPosNFFornec]:= aDespes[ nI , nPosNFFornec	]
					aDespes[ oDespesBrw:at() , nPosOBS     ]:= aDespes[ nI , nPosObs	]
					Exit                                                     		
				EndIf
			next
		EndIf
	ElseIf (nCol == nPosEspecie  .And. !Empty( M->xValor)  .And. !Empty(aDespes[ oDespesBrw:at() ,nPosSerie])) .OR. ;
           (nCol == nPosSerie    .And. !Empty( M->xValor)  .And. !Empty(aDespes[ oDespesBrw:at() ,nPosEspecie])) 
		IF nCol == nPosEspecie
		   lRetVld := chkSeriEsp(aDespes[ oDespesBrw:at() ,nPosSerie],M->xValor)
		Else
		   lRetVld := chkSeriEsp(M->xValor,aDespes[ oDespesBrw:at() ,nPosEspecie])
		EndIF
	ElseIf (nCol == nPosEspecie  .And. !Empty( M->xValor)  .And. !Empty(aDespes[ oDespesBrw:at() ,nPosOper])) .OR. ;
           (nCol == nPosOper    .And. !Empty( M->xValor)  .And. !Empty(aDespes[ oDespesBrw:at() ,nPosEspecie])) 
		IF nCol == nPosEspecie
		   lRetVld := chkOperac(aDespes[ oDespesBrw:at() ,nPosOper],M->xValor)
		Else
		   lRetVld := chkOperac(M->xValor,aDespes[ oDespesBrw:at() ,nPosEspecie])
		EndIF

	ElseIf nCol == nPosTaxa  .And. !Empty( M->xValor )
		IF M->xValor > 0 .AND. aDespes[ oDespesBrw:at() , nPosMoeda] <> 'R$'
		     For nI := 1 To Len(aDespes[ oDespesBrw:at() , nPosDetalhe] )
				  If aDespes[ oDespesBrw:at() , nPosDetalhe][nI,01]
				       nGeral += aDespes[ oDespesBrw:at() , nPosDetalhe][nI,05]
				  EndIf
			Next nI 
		    aDespes[ oDespesBrw:at() , nPosValor]:= nGeral * M->xValor
		Else
		     APMsgStop("Moeda da Tabela é Real não é possivel colocar a Taxa !!")
		     lRetVld := .F.
		EndIF
	ElseIf nCol == nPosVenc
		If M->xValor < dDataBase
			APMsgStop("Data de Vencimento não pode ser menor que a data atual.")
			lRetVld := .F.
		EndIf
	EndIf

	If lRetVld
		aDespes[ oDespesBrw:at() , nCol]:= M->xValor
	EndIf
	
	//oDespesBrw:refresh(.F.)
return lRetVld

//---------------------------------------------------------------------------------
// VerIfica Série e Espécie do Documento
//---------------------------------------------------------------------------------
static function chkSeriEsp(cSerie,cEspecie)
	Local lChkSerEsp	:= .F.
	Local cQrySZW		:= ""

	cQrySZW := "SELECT COUNT( ZW_ESPECIE ) SZWCOUNT"														+ CRLF
	cQrySZW += " FROM " + retSQLName("SZW") + " SZW"														+ CRLF
	cQrySZW += " WHERE ZW_FORNECE	=	'" + aEXPs[1,08] + "'"									+ CRLF
	cQrySZW += "	AND ZW_LOJA		=	'" + aEXPs[1,09]+ "'"									+ CRLF
	cQrySZW += "	AND ZW_SERIE	=	'" + cSerie	+ "'"	+ CRLF
	cQrySZW += "	AND ZW_ESPECIE	=	'" + cEspecie	+ "'"	+ CRLF
	cQrySZW += " 	AND ZW_FILIAL	=	'" + xFilial("SZW") 										+ "'"	+ CRLF
	cQrySZW += " 	AND	D_E_L_E_T_	<>	'*'"																+ CRLF

	tcQuery cQrySZW New Alias "QRYSZW"

	If QRYSZW->SZWCOUNT > 0
		lChkSerEsp := .T.
	Else
		APMsgStop("Espécie deste documento não está cadastrada para este Fornecedor na tabela de 'Amarração de Fornecedor x Especie NFE Talonário'.")
	EndIf

	QRYSZW->( DBCloseArea() )
return lChkSerEsp

//---------------------------------------------------------------------------------
// VerIfica Operacao do Documento
//---------------------------------------------------------------------------------
static function chkOperac(cOPer,cEspecie)
	Local lChkOperac	:= .F.
	Local cQryZBT		:= ""

	cQryZBT := "SELECT COUNT(*) ZBTCOUNT"																		+ CRLF
	cQryZBT += " FROM " + retSQLName("ZBT") + " ZBT"															+ CRLF
	cQryZBT += " WHERE"																							+ CRLF
	cQryZBT += "		ZBT.ZBT_OPER	=	'" + cOper		+ "'"	+ CRLF
	cQryZBT += "	AND ZBT.ZBT_ESPEC	=	'" + cEspecie	+ "'"	+ CRLF
	cQryZBT += " 	AND ZBT.ZBT_FILIAL	=	'" + xFilial("ZBT") 										+ "'"	+ CRLF
	cQryZBT += " 	AND ZBT.D_E_L_E_T_	<>	'*'"																+ CRLF

	tcQuery cQryZBT New Alias "QRYZBT"

	If QRYZBT->ZBTCOUNT > 0
		lChkOperac := .T.
	Else
		APMsgStop( "Não existe amarração do Tipo de Operação X Espécie NFE cadastrada para esta operação." + CRLF + ;
					"Faça o cadastro desta amarração para incluir este Documento de Entrada." )
	EndIf

	QRYZBT->( DBCloseArea() )
return lChkOperac

//---------------------------------------------------------------------------------
// VerIfica tudo esta ok
//---------------------------------------------------------------------------------
static function chkAllOk()

	local lAllOk	:= .T.
	local nI		:= 0

	for nI := 1 to len( aDespes )
		if !chkLineOk( nI )
			lAllOk := .F.
			exit
		endif
	next


return lAllOk

//---------------------------------------------------------------------------------
// VerIfica Se a linha esta ok
//---------------------------------------------------------------------------------
Static Function chkLineOk( nLineToChk )
Local lChkLineOk	:= .T.
Local nI			:= 0
Local cQrySF1		:= ""
Local cCampo        := ''
Local aCamposObr    := {nPosSerie,nPosEspecie,nPosOper,nPosEmissao,nPosValor,nPosVenc,nPosNat,nPosCCusto,nPosItemCtb,nPosNFFornec}	 

default nLineToChk	:= oDespesBrw:at()

If !Empty( aDespes[ nLineToChk , nPosDoc ] )
	for nI := 1 to len( aCamposObr )
		IF Empty( aDespes[ nLineToChk ,  aCamposObr[ nI ] ] )
			cCampo        :=  aCab[ AScan(aCab,{|x| x[2] == aCamposObr[nI] } ),01]
			lChkLineOk := .F.
			exit
		EndIf
	next

	If !lChkLineOk
		aviso(	"Campos obrigatórios"																	,;
				"O campo " + cCampo + " não foi preenchido."	,;
				{ "Ok" }																				,;
				2																						)
	Else
	    IF aDespes[ nLineToChk , nPosMoeda] <> 'R$' .AND. aDespes[ nLineToChk , nPosTaxa] == 0 
			aviso(	"Taxa", "O pré calculo é em outra moeda, deverá ser preenchido a taxa negociada.",{ "Ok" },2 )			
			lChkLineOk := .F.																
		Else	
			If !empty( aDespes[ nLineToChk , nPosDoc ] )
				cQrySF1 := "SELECT F1_FILIAL, F1_DOC"
				cQrySF1 += " FROM " + retSQLName("SF1") + " SF1"
				cQrySF1 += " WHERE SF1.F1_FORNECE	=	'" + aDespes[ nLineToChk ,nPosFornecedor]	+ "'"
				cQrySF1 += "	AND SF1.F1_LOJA		=	'" + aDespes[ nLineToChk ,nPosLoja]	+ "'"
				cQrySF1 += "	AND	SF1.F1_SERIE	=	'" + aDespes[ nLineToChk , nPosSerie] 				+ "'"
				cQrySF1 += "	AND	SF1.F1_DOC		=	'" + padL( allTrim( aDespes[ nLineToChk , nPosDoc]) , tamSX3("F1_DOC")[1] , "0" )				+ "'"
				cQrySF1 += "	AND SF1.F1_FILIAL	=	'" + aExps[ 1 , 1 ] + "'"
				cQrySF1 += "	AND	SF1.D_E_L_E_T_	<>	'*'"
	
	
				tcQuery cQrySF1 New Alias "QRYSF1"
	
				If !QRYSF1->( EOF() )
					lChkLineOk := .F.
					aviso(	"Documento já lançado"																																,;
							"O Documento " + allTrim( aDespes[ nLineToChk , nPosDoc ]) + "/" + allTrim( aDespes[ nLineToChk , nPosSerie]) + " já está lançado para o fornecedor " 	,;
							{ "Ok" }																																			,;
							2																																					)
				EndIf
	
				QRYSF1->( DBCloseArea() )
			EndIf
		EndIF
	EndIf
	IF lChkLineOk
	   For nI := 1 to Len( aDespes )
			If aDespes[ nI , nPosDoc ] == aDespes[ nLineToChk , nPosDoc ]	.and.   nI <> nLineToChk															
			    aDespes[nI , nPosSerie   ] := aDespes[ nLineToChk , nPosSerie	]
				aDespes[nI , nPosEspecie ] := aDespes[ nLineToChk , nPosEspecie 	]
				aDespes[nI , nPosOper	 ] := aDespes[ nLineToChk , nPosOper		]
				aDespes[nI , nPosEmissao ] := aDespes[ nLineToChk , nPosEmissao		]
				aDespes[nI , nPosVenc	 ] := aDespes[ nLineToChk , nPosVenc		]
				aDespes[nI , nPosNFFornec] := aDespes[ nLineToChk , nPosNFFornec	]
				Exit                                                     		
			EndIf
		Next
	EndIF
	
EndIF

return lChkLineOk

//---------------------------------------------------------------------------------
// Seleciona historico de lancamento
//---------------------------------------------------------------------------------
static function getDespLan()
	Local cQryHist		:= ""
	Local cExpsIn		:= ""
	Local nI			:= 0
	Local cEETLOJAF		:= ""
	Local cEETFORNEC	:= ""

	If len( aExps ) >= 1
		cEETLOJAF	:= GetAdvFVal( "SY5" , "Y5_LOJAF"	, xFilial("SY5") + aExps[ 1 , 09 ]	, 1 , "" )
		cEETFORNEC	:= GetAdvFVal( "SY5" , "Y5_FORNECE"	, xFilial("SY5") + aExps[ 1 , 08 ]	, 1 , "" )
	EndIf

	for nI := 1 to len( aExps )
		cExpsIn += "'" + aExps[ nI , 2 ] + "',"
	next

	cExpsIn := left( cExpsIn , len( cExpsIn ) - 1 ) // remove ultima virgula

	cQryHist := "SELECT"															+ CRLF
	cQryHist += " EET_FILIAL		,"												+ CRLF
	cQryHist += " EET_PEDIDO		,"												+ CRLF
	cQryHist += " EET_PEDCOM		,"												+ CRLF
	cQryHist += " EET_FORNEC		,"												+ CRLF
	cQryHist += " EET_LOJAF			,"												+ CRLF
	cQryHist += " EET_CODAGE		,"												+ CRLF
	cQryHist += " EET_TIPOAG		,"												+ CRLF
	cQryHist += " EET_OCORRE		,"												+ CRLF
	cQryHist += " EET_SEQ			,"												+ CRLF
	cQryHist += " EET_DESPES		,"												+ CRLF
	cQryHist += " EET_XTABPR		,"												+ CRLF
	cQryHist += " EET_XMOEPR		,"												+ CRLF
	cQryHist += " EET_XPRECA		,"												+ CRLF
	cQryHist += " EET_DOCTO			,"												+ CRLF
	cQryHist += " EET_DESADI		,"												+ CRLF
	cQryHist += " EET_VALORR		,"												+ CRLF
	cQryHist += " EET_ZMOED			,"												+ CRLF
	cQryHist += " EET_ZTX			,"												+ CRLF
	cQryHist += " EET_ZVLMOE		,"												+ CRLF
	cQryHist += " EET_DTVENC		,"												+ CRLF
	cQryHist += " EET_NATURE		,"												+ CRLF
	cQryHist += " EET_PREFIX		,"												+ CRLF
	cQryHist += " EET_ZCCUST		,"												+ CRLF
	cQryHist += " EET_ZITEMD		,"												+ CRLF
	cQryHist += " EET_ZNFORN		,"												+ CRLF
	cQryHist += " YB_DESCR"															+ CRLF
	cQryHist += " FROM " + retSQLName("EET") + " EET"								+ CRLF
	cQryHist += " INNER JOIN "	+ retSQLName("SYB") + " SYB"						+ CRLF
	cQryHist += " ON"																+ CRLF
	cQryHist += " 		EET.EET_DESPES	=	SYB.YB_DESP"							+ CRLF
	cQryHist += " 	AND	SYB.YB_FILIAL	=	'" + xFilial("SYB")		+ "'"			+ CRLF
	cQryHist += " 	AND	SYB.D_E_L_E_T_	<>	'*'"									+ CRLF
	cQryHist += " WHERE EET.EET_FILIAL  =  '" + aExps[ 1 , 01 ] + "'"	+ CRLF
	cQryHist += " 	AND	EET.EET_PEDIDO	IN	(" + cExpsIn + ")"	+ CRLF
	cQryHist += "	AND	EET.EET_FORNEC	=	'" + aExps[ 1 , 08 ]	+ "'"					+ CRLF
	cQryHist += "	AND	EET.EET_LOJAF	=	'" + aExps[ 1 , 09 ]	+ "'"					+ CRLF
	cQryHist += "	AND	EET.D_E_L_E_T_	<>	'*'"									+ CRLF
     //Conout(cQryHist)
	tcQuery cQryHist New Alias "QRYHIST"
return

*****************************************************************************************************
Static Function Inclui_Linha

Local nI      := 0
Local nX      := 0 
Local bPassou := .F. 


If ConPad1(,,,'XECC73') .AND. SYB->(!EOF())
    cIncDesp := STRTRAN(cIncDesp, SYB->YB_DESP, '' )
    For nI := 1 To Len(aDespGeral)
		bPassou := .F.
		For nX := 1  To Len(aExps)
			IF aExps[nX,11]  >= SToD(aDespGeral[nI,4]) .AND. aExps[nX,11] <= SToD(aDespGeral[nI,5])  
				bPassou := .T.
				Exit
			EndIF
		Next nX
		IF bPassou
			IF aDespGeral[nI][1] == SYB->YB_DESP	
				AAdd( aDespes, {	SYB->YB_DESP																											,; //[01] - "Despesa"
									SYB->YB_DESCR																											,; //[02] - "Descrição"
									aDespGeral[nI,2]																											,; //[03] - "Tabela Pré Cálculo"
									aDespGeral[nI,3]																											,; //[04] - "Moeda Pré Cálculo"
									0	,; //[05] - "Valor Pré Cálculo"
									space( tamSx3("E2_NUM")[1] )																								,; //[06] - "Documento"
									space( tamSx3("F1_SERIE")[1] )																								,; //[07] - "Série"
									space( tamSx3("F1_ESPECIE")[1] )																							,; //[08] - "Espécie"
									space( tamSx3("D1_OPER")[1] )																								,; //[09] - "Operação"
									cToD("//")																													,; //[10] - "Emissão"
									0	,; //[12] - "Valor Documento"
									0																															,; //[14] - "Taxa Neg."
									0																															,; //[14] - "Taxa Neg."
									cToD("//")																													,; //[16] - "Vencimento"
									SYB->YB_NATURE												                                                               ,; //[17] - "Natureza"
									cZCCUST																														,; //[19] - "Centro Custo"
									cZITEMD																														,; //[20] - "Item Ctb.Deb"
									space( tamSx3("EET_ZNFORN")[1] )																							,; //[21] - "NF FORNEC"
									space( tamSx3("EET_ZOBS")[1] )																								,; //[22] - "Observação"
									'T' /*space( tamSx3("ZEE_TIPODE")[1] )*/																		,; //[23] - "Tipo Despesa"
									aExps[ 1 , 08 ]  														,; //[24] - "Fornecedor"
									aExps[ 1 , 09 ],{} }) //[25] e 26- "Desc. Fornecedor
				Calcula_Desp(Len(aDespes))
			EndIf
		EndIF
	Next nI
	oDespesBrw:Refresh()
EndIf

Return
************************************************************************************************************************************************************
Static Function Calcula_Desp(nReg)

Local nI      := 0
Local aAux    := {}
Local cQuery  := ''
Local nDias   := 0 
Local nTotal  := 0 
Local nGeral  := 0 
Local aCalc   := {}
Local nInicio := 1
Local nFim    := 0
Local nL      := 0 
Local nAcum   := 0 

For nI := 1 To Len(aExps)
    nDias   := DateDIffDay(aExps[nI,11],aExps[nI,10]) + 1
    aCalc   := {} 
	cQuery := " SELECT Distinct ZEE_CODIGO ,ZED_TIPODE, ZEE_CODDES,	ZEE_TERMIN,	ZEE_QTDDIA,	ZEE_PER, ZEE_DIAPER,	ZEE_VLPER,	ZEE_MOEDA,	ZEE_COB,ZEE_CONT,ZEE_PCALC	
	cQuery += " From "+retSQLName("ZED")+ " ZED,"+retSQLName("ZEE")+" ZEE"								+ CRLF
	cQuery += " Where  ZEE.ZEE_TERMIN	=	'"+cTerminal+"'"								+ CRLF 
	cQuery += " 	AND	ZED.ZED_TIPODE	=	'T' "											+ CRLF 
	cQuery += "     AND ZEE_CODDES      =   '"+aDespes[nReg,01]+"'"								+ CRLF
	cQuery += "     AND ZEE_CODIGO  =   '"+aDespes[nReg,03]+"'"								+ CRLF
	cQuery += "     AND ZEE_CONT        =   '"+aExps[nI,12]+"'"								+ CRLF
	cQuery += " 	AND	ZEE.ZEE_CODIGO	=	ZED.ZED_CODIGO"									+ CRLF
	cQuery += " 	AND	ZEE.ZEE_FILIAL	=	ZED.ZED_FILIAL"									+ CRLF
	cQuery += " 	AND	'" + dToS( aExps[nI,11] ) + "'	>=	ZED.ZED_DTINIC"				+ CRLF
	cQuery += " 	AND	'" + dToS( aExps[nI,11] ) + "'	<=	ZED.ZED_DTFIM"				+ CRLF
	cQuery += " 	AND	ZEE.D_E_L_E_T_	<>	'*'"											+ CRLF
	cQuery += " 	AND	ZED.D_E_L_E_T_	<>	'*'"											+ CRLF
	cQuery += " Order by ZED_TIPODE, ZEE_CONT, ZEE_PER "
	
	If Select("QRY_CALC") > 0
		QRY_CALC->(dbCloseArea())
	EndIf
	cQuery  := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_CALC",.T.,.F.)
	dbSelectArea("QRY_CALC")
	QRY_CALC->(dbGoTop())
	nTotal  := 0 
	nInicio := 1
	IF QRY_CALC->(!Eof())
	     
		If QRY_CALC->ZEE_PCALC =='F'
			nTotal := QRY_CALC->ZEE_VLPER
		ElseIF QRY_CALC->ZEE_PCALC =='V'
			While QRY_CALC->(!Eof())
				If QRY_CALC->ZEE_DIAPER == 0
					nFim := 9999
				Else
					nFim := nInicio+QRY_CALC->ZEE_DIAPER -1
				EndIf
				AAdd(aCalc,{nInicio, nFim,QRY_CALC->ZEE_VLPER, QRY_CALC->ZEE_DIAPER,QRY_CALC->ZEE_COB})
				nInicio := nFim + 1
				QRY_CALC->(dbSkip())
			End
			For nL := 1 To Len(aCalc)
				If nDias >= aCalc[nL,01] .AND. nDias <= aCalc[nL,02]
					nTotal += aCalc[nL,03] 
					Exit
				EndIf
			Next nL
		Else
			While QRY_CALC->(!Eof())
				If QRY_CALC->ZEE_DIAPER == 0
					nFim := 9999
				Else
					nFim := nInicio+QRY_CALC->ZEE_DIAPER -1
				EndIf
				AAdd(aCalc,{nInicio, nFim,QRY_CALC->ZEE_VLPER, QRY_CALC->ZEE_DIAPER,QRY_CALC->ZEE_COB})
				nInicio := nFim + 1
				QRY_CALC->(dbSkip())
			End
			nAcum   := 0
			For nL := 1 To Len(aCalc)
				nAcum += aCalc[nL,04]
				If nDias >= aCalc[nL,01] .AND. nDias <= aCalc[nL,02]
					If aCalc[nL,05] == 'S'
						nTotal += nDias * aCalc[nL,03] 
					Else
						If aCalc[nL,04] == 0 
							nTotal += (nDias-nAcum) * aCalc[nL,03]
						Else
							nTotal += (nAcum-nDias) * aCalc[nL,03] 
						EndIf
					EndIf
					Exit
				Else     
					If aCalc[nL,05] == 'S'
						nTotal += nAcum * aCalc[nL,03] 
					Else
						nTotal += aCalc[nL,04] * aCalc[nL,03] 
					EndIf
				EndIf
			Next nL
		EndIf
	EndIf
    AAdd(aAux,{IIf(nTotal > 0 , .T.,.F.),aExps[nI,02], aExps[nI,12],nDias,nTotal,nTotal})  
    nGeral  += nTotal
Next nI
aDespes[nReg,nPosValorPre]   := nGeral
aDespes[nReg,nPosValor]      := nGeral
aDespes[nReg,nPosValorMoeda] := nGeral
aDespes[nReg,nPosDetalhe]    := aAux

Return
*******************************************************************************************************************************************************
Static Function Vis_Detalhes

Local oBtn
Local oDlg1            
Local oOK       := LoadBitmap(GetResources(),'LBOK')
Local oNO       := LoadBitmap(GetResources(),'LBNO')

Private aAgr := aDespes[oDespesBrw:nAt,nPosDetalhe]
Private oBrowse

If Len(aAGR) ==0
	msgAlert('Não há calculos para a Despesa')
Else
	
	DEFINE MSDIALOG oDlg1 TITLE "Calculo da Despesa por EXP" FROM 000, 000  TO 300, 800 COLORS 0, 16777215 PIXEL
	
		oBrowse  := TWBrowse():New( 005, 005,  345, 140,,,,oDlg1, , , ,,{||}, , , , ,,,.F.,,.T.,,.F.,,, )
	    oBrowse:SetArray(aAGR)
	    oBrowse:nAt := 1
	    oBrowse:bLine := { || {IIf(aAGR[oBrowse:nAt,01],oOK,oNO),aAGR[oBrowse:nAt,2],aAGR[oBrowse:nAt,3],aAGR[oBrowse:nAt,4],aAGR[oBrowse:nAt,5]}}
	    oBrowse:bLDblClick := { || aAGR[oBrowse:nAt][1] := !aAGR[oBrowse:nAt][1],oBrowse:DrawSelect()}
	       
	   
		oBrowse:addColumn(TCColumn():new(""               ,{||IIf(aAGR[oBrowse:nAt][01],oOK,oNO)},"@!" ,,,"LEFT"  ,20,.T.,.F.,,,,,))
		oBrowse:addColumn(TCColumn():new("EXP."           ,{||aAGR[oBrowse:nAt][02]},"@!" ,,,"LEFT"  ,70,.F.,.F.,,,,,))
		oBrowse:addColumn(TCColumn():new("Container"      ,{||aAGR[oBrowse:nAt][03]},"@!" ,,,"LEFT"  ,60,.F.,.F.,,,,,))
		oBrowse:addColumn(TCColumn():new("Dias Calculado" ,{||aAGR[oBrowse:nAt][04]},"@!" ,,,"LEFT"  ,60,.F.,.F.,,,,,))
		oBrowse:addColumn(TCColumn():new("Total"          ,{||aAGR[oBrowse:nAt][05]},"@E 999,999.99" ,,,"RIGHT" ,40,.F.,.F.,,,,,))
		oBrowse:DrawSelect()                               
		
		oBtn := TButton():New( 05, 351 ,'Confirmar'    , oDlg1,{|| Alt_Desp(),oDlg1:End()  }  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )
		oBtn := TButton():New( 17, 351 ,'Cancelar'     , oDlg1,{|| oDlg1:End()}  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )
		oBtn := TButton():New( 29, 351 ,'Altera Valor' , oDlg1,{|| Alt_Valor()}  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )
		oBtn := TButton():New( 41, 351 ,'Retorna Valor', oDlg1,{|| aAGR[oBrowse:nAt][05] := aAGR[oBrowse:nAt][06], oBrowse:Refresh() }  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )
		
	ACTIVATE MSDIALOG oDlg1 CENTERED
EndIf

Return .F.
**************************************************************************************************
Static Function Alt_Desp()
Local nI     := 0 
Local nGeral :=  0

For nI := 1 To Len(aAgr )
  If aAgr[nI,01]
       nGeral += aAgr[nI,05]
  EndIf
Next nI 
aDespes[oDespesBrw:nAt,nPosValor]       := nGeral * IIF(aDespes[oDespesBrw:nAt,nPosTaxa]==0,1,aDespes[oDespesBrw:nAt,nPosTaxa])
aDespes[oDespesBrw:nAt,nPosValorMoeda]  := nGeral
aDespes[oDespesBrw:nAt,nPosDetalhe]     := aAgr

Return .T.
****************************************************************************************************************
Static Function Alt_Valor
Local oDLG2
Local oBtn
Local nValor := aAGR[oBrowse:nAt][05]
Local bSaiu  := .F.


DEFINE MSDIALOG oDLG2 TITLE "Altera Valor" FROM 000, 000  TO 080, 296 COLORS 0, 16777215 PIXEL
	@ 008, 002 SAY  "Valor :"                            SIZE 028, 009 OF oDLG2              COLORS 0, 16777215 PIXEL
	@ 006, 025 MSGET  nValor    PICT "@E 999,999,999.99" SIZE 123, 010 OF oDLG2 Valid nValor > 0  COLORS 0, 16777215 PIXEL
	oBtn := TButton():New( 021, 095 ,'Confirmar'    , oDlg2,{|| bSaiu  := .T. , oDLG2:End() }  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )
ACTIVATE MSDIALOG oDLG2 CENTERED
If bSaiu
    aAGR[oBrowse:nAt][05] := nValor
    oBrowse:Refresh()
EndIf

Return 
********************************************************************************************************************
Static Function Gera_Nota

Local aAreaX		:= getArea()
Local aAreaSC7		:= SC7->( getArea() )
Local aAreaSYB		:= SYB->( getArea() )
Local aAreaEET		:= EET->( getArea() )
Local aAreaEEB		:= EEB->( getArea() )
Local cQrySC7		:= ""
Local aSC7Cab		:= {}
Local aSC7Itens		:= {}
Local aSC7Aux		:= {}
Local aSF1			:= {}
Local aSD1			:= {}
Local aSD1Aux		:= {}
Local cItemSD1		:= ""
Local cItemSC7		:= ""
Local nStackSX8		:= getSx8Len()
Local aErro			:= {}
Local cErro			:= ""
Local nI			:= 0
Local nJ			:= 0
Local nX			:= 0
Local aDocsSC7		:= {}
Local cDocsSC7		:= ""
Local aDocsSF1		:= {}
Local cDoctoAtu		:= ""
Local cLogProc		:= ""
Local cQrySD1		:= ""
Local cEETSeq		:= ""
Local cQryEEB		:= ""
Local cCondPgtoX	:= ""
Local nCountParc	:= 0
Local aDocsPreCa	:= {}	// CONTEM OS DOCUMENTOS DO PRE CALCULO
Local lPreCalc		:= .T.	// SE .T. PRE CALCULO OK
Local aC7Num		:= {}	// CONTEM OS PEDIDOS USADOS - PARA GERAR GRADE SE NECESSÁRIO
Local aAgr          := {}
Local aExpGrv       := {}
Local cQuery        := ''
Local aExclui       := {}
Local cRecno        := ''
Local cLogProc2     := ''
Local aNotas        := {} 

Private lGradeSC7		:= .F.
Private lMsHelpAuto     := .T.
Private lMsErroAuto     := .F.
Private lAutoErrNoFile  := .T. // Precisa estar como .T. para GetAutoGRLog() retornar o array com erros
Private bTem            := .F.

DBSelectArea("EET")

// ORDENA POR DOCUMENTO E FORNECEDOR
aSort( aDespes, , , { | x,y | x[nPosDoc] < y[nPosDoc]  } )

For nI := 1 to len(aDespes)
    IF Empty(aDespes[nI,nPosDoc])
         Loop
    EndIF
    bTem = .T. 
Next Ni
IF !bTem
    bSair       := .F.
    MsgAlert('Não foi preenchido nenhum documento !!')
    Return
EndIF


nJ := 1
nCountParc	:= 0
For nI := 1 to len(aDespes)
	aSC7Cab		:= {}
	aSC7Aux		:= {}
	aSC7Itens	:= {}
    IF Empty(aDespes[nI,nPosDoc])
         Loop
    EndIF
	cDoctoAtu	:= aDespes[ nI , nPosDoc] + aDespes[ nI , nPosFornecedor ]
	cCondPgtoX	:= ""
	cCondPgtoX	:= getCndPgto( aDespes[ nI , nPosVenc] , aDespes[ nI , nPosEmissao ] )
	AAdd( aSC7Cab , { "C7_EMISSAO"		, aDespes[ nI , nPosEmissao ]			, nil } )
    AAdd( aSC7Cab , { "C7_FORNECE"		, aExps[ 01 , 08 ]				, nil } )
	AAdd( aSC7Cab , { "C7_LOJA"			, aExps[ 01 , 09 ]				, nil } )
	AAdd( aSC7Cab , { "C7_COND"			, cCondPgtoX					, nil } )
	AAdd( aSC7Cab , { "C7_FILENT"		, aExps[ 01 , 1 ]				, nil } )
	AAdd( aSC7Cab , { "C7_FILIAL"		, aExps[ 01 , 1 ]				, nil } )
	AAdd( aSC7Cab , { "C7_FLUXO"		, "S"							, nil } )
	AAdd( aSC7Cab , { "C7_XCODAGE"		, cTerminal   					, nil } )
    aAgr := aDespes[ nI,nPosDetalhe]
	cItemSC7 := ""
	cItemSC7 := strZero ( 0 , tamSX3("C7_ITEM")[1] )
    For nJ := 1 To Len(aAgr )
    	
    	IF !aAgr[nJ,01] .OR. aAgr[nJ,05] == 0 
    	      Loop
    	EndIF
    	aSC7Aux		:= {}
		cItemSC7	:= soma1( cItemSC7 )

		AAdd( aSC7Aux , { "C7_ITEM"		, cItemSC7																														, nil } )
		AAdd( aSC7Aux , { "C7_PRODUTO"	, GetAdvFVal("SYB" , "YB_PRODUTO" , xFilial("SYB") + aDespes[ nI , nPosDesp ]	, 1 , "")	, nil } )
		AAdd( aSC7Aux , { "C7_QUANT"	, 1	    , nil } )
		AAdd( aSC7Aux , { "C7_PRECO"	, aAgr[nJ,05] , nil } )
		AAdd( aSC7Aux , { "C7_CC"		, aDespes[ nI , nPosCCusto ]													, nil } )
		AAdd( aSC7Aux , { "C7_ZCC"		, aDespes[ nI , nPosCCusto ]													, nil } )
		AAdd( aSC7Aux , { "C7_SEQUEN"	, cItemSC7																										, nil } )
		AAdd( aSC7Aux , { "C7_ORIGEM"	, "SIGAEEC"																										, nil } )
		AAdd( aSC7Aux , { "C7_FLUXO"	, "S"																											, nil } )
		AAdd( aSC7Aux , { "C7_QTDSOL"	, 1																												, nil } )
		AAdd( aSC7Aux , { "C7_ZNATURE"	, aDespes[ nI , nPosNat ]													, nil } )
		AAdd( aSC7Aux , { "C7_ZDOCTO"	, padL( allTrim( aDespes[ nI , nPosDoc ]) , tamSX3("F1_DOC")[1] , "0" )	, nil } )
		AAdd( aSC7Aux , { "C7_OBS"		, "Emb.Exp: " + aAgr[nJ,02]																					, nil } )
		AAdd( aSC7Aux , { "C7_ITEMCTA"	, aDespes[ nI , nPosItemCtb	]												, nil } )
		AAdd( aSC7Aux , { "C7_XSERIE"	, aDespes[ nI , nPosSerie	]												, nil } )
		AAdd( aSC7Aux , { "C7_XESPECI"	, aDespes[ nI , nPosEspecie	]												, nil } )
		AAdd( aSC7Aux , { "C7_XOPER"	, aDespes[ nI , nPosOper	]												, nil } )
		AAdd( aSC7Aux , { "C7_ZCODGRD"	, 'ZZZZZZZZZZ'																									, nil } )
		AAdd( aSC7Itens , aSC7Aux )
		IF AScan(aExpGrv,{|x| x == aAgr[nJ,02] }) == 0
		     AAdd(aExpGrv,aAgr[nJ,02] )
		EndIF		
		If aAgr[nJ,05] <> aAgr[nJ,06]
			AAdd( aDocsPreCa , padL( allTrim( aDespes[ nI , nPosDoc ]) , tamSX3("F1_DOC")[1] , "0" ) )
		EndIf
    Next nJ 
	varInfo( "aSC7Cab"		, aSC7Cab	)
	varInfo( "aSC7Itens"	, aSC7Itens	)
	lMsErroAuto := .F.
	msExecAuto( { | v , w , x , y , z | mata120( v , w , x , y , z ) } , 1 , aSC7Cab , aSC7Itens , 3 , .f. )
	If lMsErroAuto
		while getSX8Len() > nStackSX8
			ROLLBACKSX8()
		Enddo
	    
	    
		aErro := GetAutoGRLog() // Retorna erro em array
		cErro += ""
	
		for nX := 1 to len(aErro)
			cErro += aErro[nI] + CRLF
		next nX
	
		conout( " MGFEEC73 - MATA120 " + cErro )
	Else
		while getSX8Len() > nStackSX8
			CONFIRMSX8()
		Enddo
		AAdd( aDocsSC7 , SC7->C7_NUM )
	
		conout( " MGFEEC73 - MATA120 - Pedido de Compra: " + SC7->C7_FILIAL + SC7->C7_NUM )
		
		cQuery := " Update "+RetSqlName("SC7")
		cQuery += " Set C7_CONAPRO = 'L'"
		cQuery += " Where C7_FILIAL  = '"+SC7->C7_FILIAL+"'"
		cQuery += "   AND C7_NUM     = '"+SC7->C7_NUM+"'"
		cQuery += "   AND D_E_L_E_T_ = ' ' "
        IF (TcSQLExec(cQuery) < 0)        
			conOut(TcSQLError())
		EndIF                             

		cEETSeq := ""
		cEETSeq := strZero ( 0 , tamSX3("EET_SEQ")[1] )
        For nX := 1 To Len(aExpGrv)
			cQryEEB := ""
			cQryEEB := "SELECT EEB_PEDIDO"											+ CRLF
			cQryEEB += " FROM " + retSQLName("EEB") + " EEB"						+ CRLF
			cQryEEB += " WHERE"														+ CRLF
			cQryEEB += "		EEB.EEB_PEDIDO	=	'" + aExpGrv[nX]+ "'"			+ CRLF
			cQryEEB += "	AND	EEB.EEB_CODAGE	=	'" + cTerminal			+ "'"	+ CRLF
			cQryEEB += "	AND	EEB.EEB_FILIAL	=	'" + SC7->C7_FILIAL		+ "'"	+ CRLF
			cQryEEB += " 	AND	EEB.D_E_L_E_T_	<>	'*'"							+ CRLF
		
			conout( cQryEEB )
		
			tcQuery cQryEEB New Alias "QRYEEB"
		
			If QRYEEB->(EOF())
				// SE EMPRESA NAO ESTIVER GRAVADA - INCLUI NA TABELA EEB
					recLock("EEB" , .T.)
					EEB->EEB_FILIAL	:= SC7->C7_FILIAL
					EEB->EEB_CODAGE	:= cTerminal
					EEB->EEB_PEDIDO	:= aExpGrv[nX]	// NUMERO DA EXP
		
					EEB->EEB_TIPOAG	:= GetAdvFVal("SY5" , "Y5_TIPOAGE"	, xFilial("SY5") + cTerminal	, 1 , "")
					EEB->EEB_NOME	:= GetAdvFVal("SY5" , "Y5_NOME"		, xFilial("SY5") + cTerminal	, 1 , "")
		
					EEB->EEB_TXCOMI	:= 0
					EEB->EEB_OCORRE	:= "Q"
					EEB->EEB_TIPCOM	:= "2"
					EEB->EEB_TIPCVL	:= "1"
					EEB->EEB_VALCOM	:= 0
					EEB->EEB_TOTCOM	:= 0
					EEB->EEB_REFAGE	:= ""
					EEB->EEB_FORNEC	:= SC7->C7_FORNECE
					EEB->EEB_LOJAF	:= SC7->C7_LOJA
					EEB->EEB_FOBAGE	:= 0
					EEB->EEB_CONTR	:= ""
					EEB->( msUnlock() )
			EndIf
			QRYEEB->( DBCloseArea() )
		Next nX
		cEETSeq			:= soma1( cEETSeq )
		For nX:= 1 To Len(aAgr )
			IF !aAgr[nX,01] .OR. aAgr[nX,05] == 0 
		    	 Loop
		    EndIF
		    RecLock("EET" , .T.)
			EET->EET_FILIAL	:= SC7->C7_FILIAL
			EET->EET_PEDIDO := aAgr[nX,02]	// NUMERO DA EXP
			EET->EET_PEDCOM	:= SC7->C7_NUM		// NUMERO PEDIDO DE COMPRA
			EET->EET_FORNEC	:= SC7->C7_FORNECE
			EET->EET_LOJAF	:= SC7->C7_LOJA
			EET->EET_CODAGE	:= cTerminal
			EET->EET_TIPOAG := GetAdvFVal("SY5" , "Y5_TIPOAGE"	, xFilial("SY5") + cTerminal	, 1 , "")
			EET->EET_OCORRE	:= "Q"
			EET->EET_SEQ	:= cEETSeq
			EET->EET_DESPES	:= aDespes[ nI, nPosDesp ]
			EET->EET_XTABPR	:= aDespes[ nI, nPosTab ]
			EET->EET_XMOEPR	:= aDespes[ nI, nPosMoeda ]
			EET->EET_XPRECA	:= aAgr[nX,05]
			EET->EET_DOCTO	:= aDespes[ nI, nPosDoc]
			EET->EET_DESADI	:= aDespes[ nI, nPosEmissao ]
			EET->EET_VALORR	:= aAgr[nX,05] * IIF(aDespes[ nI, nPosTaxa]==0, 1, aDespes[ nI, nPosTaxa]) 
			EET->EET_ZMOED	:= 'R$'// MOEDA - 1-R$;2-US$;3-EUR;4-GBP
			EET->EET_ZTX	:= aDespes[ nI, nPosTaxa]// Taxa Neg.
			EET->EET_ZVLMOE	:= aDespes[ nI, nPosValorMoeda] 
			EET->EET_DTVENC	:= aDespes[ nI, nPosVenc]// Vencimento
			EET->EET_NATURE	:= aDespes[ nI, nPosNat ]// Natureza
			EET->EET_ZCCUST	:= aDespes[ nI, nPosCCusto ]// Centro Custo
			EET->EET_ZITEMD	:= aDespes[ nI, nPosItemCtb]// Item Ctb.Deb
			EET->EET_ZNFORN	:= aDespes[ nI, nPosFornecedor]// NF FORNEC

			EET->EET_ZOBS	:= aDespes[ nI, nPosObs	 ]// NF FORNEC


			EET->( msUnlock() )
		    AAdd(aExclui,EET->(Recno()))
		Next nX
	EndIF
Next nI

If !Empty( aDocsSC7 )
	cDocsSC7 := ""
	//IF isInCallStack("U_MGFEEC68") //MGFCOM08 MGFCOM80

	For nI := 1 to len( aDocsSC7 )
		cDocsSC7 += "'" + aDocsSC7[ nI] + "',"
	Next
    
	cDocsSC7 := left( cDocsSC7 , len( cDocsSC7 ) - 1 ) // remove ultima virgula

	cQrySC7	:= ""
	cQrySC7 := "SELECT"
	cQrySC7 += " C7_FILIAL	, C7_ZDOCTO	, C7_EMISSAO	, C7_NUM	, C7_ITEM	,"	+ CRLF
	cQrySC7 += " C7_FORNECE	, C7_LOJA	, C7_ZNATURE	, C7_PRODUTO, C7_ZCC	,"	+ CRLF
	cQrySC7 += " C7_QUANT	, C7_PRECO	, C7_TOTAL		, C7_ITEMCTA,"				+ CRLF
	cQrySC7 += " C7_XSERIE	, C7_XESPECI, C7_XOPER		, C7_COND"					+ CRLF
	cQrySC7 += " FROM " + retSQLName("SC7") + " SC7"								+ CRLF
	cQrySC7 += " WHERE SC7.C7_FILIAL = '"+aExps[ 01 , 1 ]+"'"+ CRLF
	cQrySC7 += " 	AND SC7.C7_NUM	IN	(" + cDocsSC7  + ")"		+ CRLF
	cQrySC7 += " 	AND	SC7.D_E_L_E_T_				<>	'*'"						+ CRLF
	cQrySC7 += " ORDER BY C7_ZDOCTO"												+ CRLF

	conout( cQrySC7 )

	tcQuery cQrySC7 New Alias "QRYSC7"

	// Se lanaçamento de despesas estiver de acordo com o pre calculo gera Nota de Entrada + Titulo com Grade
	cDoctoAtu := ""
	While !QRYSC7->(EOF())
		aSF1 := {}
		AAdd( aSF1 , {"F1_FILIAL"	, QRYSC7->C7_FILIAL			, nil } )
		AAdd( aSF1 , {"F1_TIPO"   	, "N"						, nil } )
		AAdd( aSF1 , {"F1_FORMUL" 	, "N"						, nil } )
		AAdd( aSF1 , {"F1_DOC"		, padL( allTrim( QRYSC7->C7_ZDOCTO ) , tamSX3("F1_DOC")[1] , "0" )			, nil } )
		AAdd( aSF1 , {"F1_SERIE"	, QRYSC7->C7_XSERIE			, nil } )
		AAdd( aSF1 , {"F1_EMISSAO"	, sToD( QRYSC7->C7_EMISSAO ), nil } )
		AAdd( aSF1 , {"F1_FORNECE"	, QRYSC7->C7_FORNECE		, nil } )
		AAdd( aSF1 , {"F1_LOJA"   	, QRYSC7->C7_LOJA			, nil } )
		AAdd( aSF1 , {"F1_ESPECIE"	, QRYSC7->C7_XESPECI		, nil } )
		AAdd( aSF1 , {"F1_EST"		, getAdvFVal( "SA2" , "A2_EST" , xFilial("SA2") + QRYSC7->( C7_FORNECE + C7_LOJA ) , 1 , "")					, nil } )
		AAdd( aSF1 , {"F1_COND"		, QRYSC7->C7_COND			, nil } )
		AAdd( aSF1 , {"E2_NATUREZ"	, QRYSC7->C7_ZNATURE		, nil } )
		AAdd( aSF1 , {"F1_DTDIGIT"	, dDataBase					, nil } )

		cItemSD1	:= ""
		cItemSD1	:= strZero ( 0 , tamSX3("D1_ITEM")[1] )
		cDoctoAtu	:= QRYSC7->( C7_ZDOCTO + C7_FORNECE + C7_LOJA )
		aSD1		:= {}
		lPreCalc	:= .T.

		// VERIfICA PRE CALCULO DE CADA DOCUMENTO
		for nI := 1 to len( aDocsPreCa )
			If allTrim( aDocsPreCa[ nI ] ) == allTrim( QRYSC7->C7_ZDOCTO )
				lPreCalc := .F.
				exit
			EndIf
		next
		// FIM - VERIfICA PRE CALCULO DE CADA DOCUMENTO

		aC7Num := {}
		while !QRYSC7->(EOF()) .and. cDoctoAtu == QRYSC7->( C7_ZDOCTO + C7_FORNECE + C7_LOJA )
			cItemSD1	:= soma1( cItemSD1 )
			aSD1Aux		:= {}

			//varInfo( "D1 1" , QRYSC7->C7_PRECO )
			//varInfo( "D1 2" , noRound( QRYSC7->C7_PRECO , 2 ) )

			AAdd( aSD1Aux , { "D1_FILIAL"	, QRYSC7->C7_FILIAL					, nil } )
			AAdd( aSD1Aux , { "D1_ITEM"		, cItemSD1							, nil } )
			AAdd( aSD1Aux , { "D1_COD"		, QRYSC7->C7_PRODUTO				, nil } )
			AAdd( aSD1Aux , { "D1_QUANT"	, QRYSC7->C7_QUANT					, nil } )
			//AAdd( aSD1Aux , { "D1_VUNIT"	, noRound( QRYSC7->C7_PRECO , 2 )	, nil } )
			//AAdd( aSD1Aux , { "D1_TOTAL"	, noRound( QRYSC7->C7_PRECO , 2 )	, nil } )
			AAdd( aSD1Aux , { "D1_VUNIT"	, QRYSC7->C7_PRECO					, nil } )
			AAdd( aSD1Aux , { "D1_TOTAL"	, QRYSC7->C7_PRECO					, nil } )

			If lPreCalc
				// SE PRE CALCULO OK -> NOTA CLASSIfICADA
				AAdd( aSD1Aux , { "D1_OPER"		, QRYSC7->C7_XOPER		, nil } )
			EndIf
            AAdd(aNotas, {QRYSC7->C7_NUM, Alltrim(QRYSC7->C7_ZDOCTO)+'/'+QRYSC7->C7_XSERIE,cItemSD1,lPreCalc})
            
			AAdd( aSD1Aux , { "D1_CC"		, QRYSC7->C7_ZCC		, nil } )

			AAdd( aSD1Aux, { "D1_PEDIDO"	, QRYSC7->C7_NUM		, NIL } )
			AAdd( aSD1Aux, { "D1_ITEMPC"	, QRYSC7->C7_ITEM		, NIL } )

			AAdd( aSD1Aux, { "D1_ITEMCTA"	, QRYSC7->C7_ITEMCTA	, NIL } )
			AAdd( aSD1Aux, { "D1_QTDPEDI"	, QRYSC7->C7_QUANT		, NIL } )

			AAdd( aSD1 , aSD1Aux )

			AAdd( aC7Num , QRYSC7->C7_NUM )

			QRYSC7->( DBSkip() )
		Enddo

		varInfo( "aSD1" , aSD1 )
		varInfo( "aSF1" , aSF1 )

		lMsErroAuto := .F.
         
		If lPreCalc
			// SE PRE CALCULO OK -> NOTA CLASSIfICADA
			msExecAuto({|x,y,z| MATA103(x,y,z)}, aSF1, aSD1, 3)
		Else
			// SE LANCAMENTO DIVERGENTE DE PRE CALCULO -> PRE NOTA
			msExecAuto({|x,y,z| MATA140(x,y,z)}, aSF1, aSD1, 3)
		EndIf

		If lMsErroAuto
			while getSX8Len() > nStackSX8
				ROLLBACKSX8()
			Enddo

			aErro := GetAutoGRLog() // Retorna erro em array
			cErro := ""

			for nI := 1 to len(aErro)
				cErro += aErro[nI] + CRLF
			next nI

			If lPreCalc
				conout( " MGFEEC73 - MATA103 - " + cErro )
			Else
				conout( " MGFEEC73 - MATA140 - " + cErro )
			EndIf
			//Exclusão dos cadastros 
			cQuery := " Delete "+RetSqlName("SC7")
			cQuery += " Where C7_FILIAL  = '"+aExps[01,1]+"'"
			cQuery += "   AND C7_NUM     IN	(" + cDocsSC7  + ")"	
			cQuery += "   AND D_E_L_E_T_ = ' ' "
	        IF (TcSQLExec(cQuery) < 0)        
				conOut(TcSQLError())
			EndIF 
			cRecno  :='0 '                            
			For nI := 1 to len(aExclui)	
			      cRecno  += ' , '+Alltrim(STR( aExclui[nI]))
			Next nI
			cQuery := " Delete "+RetSqlName("EET")
			cQuery += " Where R_E_C_N_O_   IN	(" + cRecno  + ")"	
			cQuery += "   AND D_E_L_E_T_ = ' ' "
	        IF (TcSQLExec(cQuery) < 0)        
				conOut(TcSQLError())
			EndIF
			aNotas := {}                             
			Exit
		Else
			while getSX8Len() > nStackSX8
				CONFIRMSX8()
			Enddo

			If lPreCalc
				conout( " MGFEEC73 - MATA103 - Nota de Entrada: " + SF1->( F1_FILIAL + F1_DOC ) )
			Else
				conout( " MGFEEC73 - MATA140 - PRE Nota de Entrada: " + SF1->( F1_FILIAL + F1_DOC ) )
			EndIf

			AAdd( aDocsSF1 , { SF1->F1_FILIAL , SF1->F1_DOC , SF1->F1_SERIE , SF1->F1_FORNECE , SF1->F1_LOJA } )

			// APOS PROCESSAMENTO - PROCESSAMENTO DE BLOQUEIOS - FAZ ISSO PARA NAO BLOQUEAR GERACAO DA PRE NOTA
			If !lPreCalc
				for nI := 1 to len( aC7Num )
					lGradeSC7 := .T.
					u_xMG8FIM( aC7Num[ nI ] , 3 , )
				Next
			EndIf
			// FIM - PROCESSAMENTO DE BLOQUEIO
		EndIf
	Enddo

	QRYSC7->(DBCloseArea())

	If Len(aNotas) > 0 
		
		bSair       := .T.
		For nI := 1 To Len(aNotas)
		    IF aNotas[nI,4]  
               cLogProc   += "Nota de Entrada: " + aNotas[nI,2] + " Pedido " + aNotas[nI,1] + " Item " + aNotas[nI,3]  + CRLF
            Else
			   cLogProc2  += "Nota de Entrada: " + aNotas[nI,2] + " Pedido " + aNotas[nI,1] + " Item " + aNotas[nI,3]  + CRLF
			EndIf
		Next nI
		IF !Empty( cLogProc )
		    cLogProc := "Notas geradas : " + CRLF + cLogProc+ CRLF
		EndIF
		
		If !Empty( cLogProc2 )
			cLogProc += "Devido a divergências com o Pré Cálculo, foram geradas as Pré Notas: " + CRLF + cLogProc2
		EndIf

		staticCall( MGFEEC64 , showLog , cLogProc , "Resultado do Lançamento" , "Resultado do Lançamento: " )
	EndIf

	If !empty( cErro )
		staticCall( MGFEEC64 , showLog , cErro , "Erros encontrados" , "Erros encontrados: " )
	EndIf
Else
	If !empty( cErro )
		staticCall( MGFEEC64 , showLog , cErro , "Erros encontrados" , "Erros encontrados: " )
	EndIf
EndIf

restArea( aAreaEEB )
restArea( aAreaEET )
restArea( aAreaSYB )
restArea( aAreaSC7 )
restArea( aAreaX )
Return
//-----------------------------------------------------------------------
// Retorna a Condição de Pagamento de acordo com vencimento informado
//-----------------------------------------------------------------------
static function getCndPgto( dVencDespe , dDtEmissao )
	local cRetCondPg	:= ""
	local cQrySE4		:= ""
	local nDias			:= ( dVencDespe - dDtEmissao )

	cQrySE4 := "SELECT E4_CODIGO"											+ CRLF
	cQrySE4 += " FROM " + retSQLName("SE4") + " SE4"						+ CRLF
	cQrySE4 += " WHERE"														+ CRLF

	if nDias > 99
		cQrySE4 += "		SE4.E4_COND		=	'" + strZero( nDias , 3 ) + "'"	+ CRLF
	else
		cQrySE4 += "		SE4.E4_COND		=	'" + strZero( nDias , 2 ) + "'"	+ CRLF
	endif

	cQrySE4 += " 	AND	SE4.D_E_L_E_T_	<>	'*'"							+ CRLF

	conout( cQrySE4 )

	tcQuery cQrySE4 New Alias "QRYSE4"

	if !QRYSE4->( EOF() )
		cRetCondPg := QRYSE4->E4_CODIGO
	endif

	QRYSE4->( DBCloseArea() )


return cRetCondPg
