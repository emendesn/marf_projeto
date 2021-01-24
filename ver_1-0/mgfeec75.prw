#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"
#include 'fwmvcdef.ch'

#DEFINE CRLF		chr(13) + chr(10)

/*/
==============================================================================================================================================================================
{Protheus.doc} MGFEEC75 
Lançamento das depesas de Despachante

@description
Lançamento das depesas de Despachante gerando SC7 e SF1, SD1
É acionado atraves do programa MGFEEC69

@author Marcelo de Almeida Carneiro
@since 11/11/2019
@type Function 

@table 
    SX5 - Z1 - Fornecedor da Despesa
    EEC - Embarques
    EET - Despesas de EXPORTAVCAO

@param
    
@return
    
@menu
    EEC - Atualizações - Especificos Marfrig - Lançamento de Despesas

@history

/*/   
User Function MGFEEC75()

Local nI         := 0 
Local nPos       := 0 
Local aTotExp    := {}
	
	
Private aExps					:= {}
Private aDetalhes               := {}
Private aDespes					:= {{"","",0,0,"","",0,"","","",0,SPACE(60),{{.F.,"","",0,0}}}}
Private aDespesLan				:= {}
Private cIncDesp    			:= ''
Private nPosDesp    			:=01
Private nPosDesc      			:=02
Private nPosValor               :=03
Private nPosValorPre          	:=04
Private nPosMoeda             	:=05
Private nPosTaxa      			:=06
Private nPosValorMoeda          :=07
Private nPosTipo       			:=08
Private nPosForma     		    :=09
Private nPosForn                :=10
Private nPosFolhas              :=11
Private nPosOBS                 :=12
Private nPosDetalhe             :=13
Private cDespachante            := SY5->Y5_COD
Private cFornece                := SY5->Y5_FORNECE
Private cLoja 					:= SY5->Y5_LOJAF
Private cNatureza               := SY5->Y5_NATUREZ
Private cNome                   := SY5->Y5_NOME
Private dDtEmissao              := MV_PAR02
Private bPreNota                := .F.

For nI := 1 To Len(aMark)
    EEC->(dbGoTo(aMark[nI,01]))
	AAdd( aExps, {	EEC->EEC_FILIAL	,;	//[01]
					EEC->EEC_PEDREF	,;	//[02]
					EEC->EEC_ZEXP	,;	//[03]
					EEC->EEC_IMPORT	,;	//[04]
					EEC->EEC_IMLOJA	,;	//[05]
					EEC->EEC_IMPODE	,;	//[06]
					EEC->EEC_VLFOB  ,; //[07
                    EEC->EEC_PESLIQ ,; //[08]
					EEC->EEC_ZDTSNA, 0}          )	//[09,10]

Next nI

For nI := 1 To Len(aExps)
	nPos :=  AScan(aTotExp ,{|x| x[1] == aExps[nI,03] }) 
	IF nPos == 0 
	   AAdd(aTotExp,{aExps[nI,03],1})
	Else
       aTotExp[nPos,2] += 1
	EndIf
Next nI

For nI := 1 To Len(aExps)
	nPos :=  AScan(aTotExp ,{|x| x[1] == aExps[nI,03] })
	IF nPos > 0  
		aExps[nI,10] := aTotExp[nPos,2]
	EndIf 
Next nI




fwMsgRun(, { || getDespLan() }	, "VerIficando despesas já lançadas"	, "Aguarde. Selecionando histórico de lançamento..." )

While !QRYHIST->(EOF())
	AAdd( aDespesLan, {	QRYHIST->EET_PEDIDO             ,;
	                    QRYHIST->EET_DESPES				,;
						QRYHIST->YB_DESCR				,;
						QRYHIST->EET_XTABPR				,;
						QRYHIST->EET_XMOEPR				,;
						QRYHIST->EET_XPRECA				,;
						QRYHIST->EET_DOCTO				,;
						QRYHIST->EET_ZFORN				,;
						QRYHIST->EET_ZNOMEF				,;
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

showDespes()

Return

//------------------------------------------------------
// Mostra os dados
//------------------------------------------------------
Static Function showDespes()

Local oDlgDespes	:= Nil
Local aCoors		:= 	FWGetDialogSize( oMainWnd )
Local bOk			:= { ||  Gera_Nota() , IIF(bSair,oDlgDespes:End(),)  }
Local bClose		:= { || oDlgDespes:End() }
Local aButtons      := {{"Inclui Despesa", {|| Inclui_Linha()}, "Inclui Despesa","Inclui Despesa",{|| .T.}} } 
Local oPanelUp	
Local oPanMd01
Local oPanMd02		
Local oPanelDw	


Private oFWLayer	:= Nil
Private oExpsBrw	:= Nil
Private oDespesBrw	:= Nil
Private oHistorBrw	:= Nil
Private oDetBrow    := Nil
Private bSair       := .F.

DEFINE MSDIALOG oDlgDespes TITLE 'Despesas de Despachante : '+Alltrim(cDespachante)+' - '+Alltrim(cNome) FROM aCoors[1], aCoors[2] TO aCoors[3], aCoors[4] PIXEL STYLE DS_MODALFRAME
	oFWLayer := FWLayer():New()
	oFWLayer:Init( oDlgDespes /*oOwner*/, .F. /*lCloseBtn*/)

	oFWLayer:AddLine( 'UP'		/*cID*/, 35 /*nPercHeight*/, .F. /*lFixed*/)
	oFWLayer:AddLine( 'MIDDLE'	/*cID*/, 35 /*nPercHeight*/, .F. /*lFixed*/)
	oFWLayer:AddLine( 'DOWN'	/*cID*/, 28 /*nPercHeight*/, .F. /*lFixed*/)

	oFWLayer:AddCollumn( 'ALLUP'	/*cID*/, 100 /*nPercWidth*/, .T. /*lFixed*/, 'UP'		/*cIDLine*/)
	oFWLayer:AddCollumn( 'MID01'	/*cID*/, 65 /*nPercWidth*/, .T. /*lFixed*/, 'MIDDLE'	/*cIDLine*/)
	oFWLayer:AddCollumn( 'MID02'	/*cID*/, 35 /*nPercWidth*/, .T. /*lFixed*/, 'MIDDLE'	/*cIDLine*/)
	oFWLayer:AddCollumn( 'ALLDW'	/*cID*/, 100 /*nPercWidth*/, .T. /*lFixed*/, 'DOWN'		/*cIDLine*/)

	oPanelUp	:= oFWLayer:GetColPanel( 'ALLUP', 'UP'		)
	oPanMd01	:= oFWLayer:GetColPanel( 'MID01', 'MIDDLE'	)
	oPanMd02	:= oFWLayer:GetColPanel( 'MID02', 'MIDDLE'	)
	oPanelDw	:= oFWLayer:GetColPanel( 'ALLDW', 'DOWN'	)

	// Browse de cima com as EXPs selecionadas
	oExpsBrw := fwBrowse():New()
	oExpsBrw:setDataArray()
	oExpsBrw:setArray( aExps )
	oExpsBrw:disableConfig()
	oExpsBrw:disableReport()
	oExpsBrw:setOwner( oPanelUp )

	oExpsBrw:addColumn({"Filial"				, { || aExps[oExpsBrw:nAt,01] }, "C", pesqPict("EEC","EEC_FILIAL")	, 1, tamSx3("EEC_FILIAL")[1]/2	,	, .F.})
	oExpsBrw:addColumn({"Processo"				, { || aExps[oExpsBrw:nAt,02] }, "C", pesqPict("EEC","EEC_PEDREF")	, 1, tamSx3("EEC_PEDREF")[1]/2	,	, .F.})
	oExpsBrw:addColumn({"EXP"					, { || aExps[oExpsBrw:nAt,03] }, "C", pesqPict("EEC","EEC_PEDREF")	, 1, tamSx3("EEC_PEDREF")[1]/2	,	, .F.})
	oExpsBrw:addColumn({"Código Imp."			, { || aExps[oExpsBrw:nAt,04] }, "C", pesqPict("EEC","EEC_IMPORT")	, 1, tamSx3("EEC_IMPORT")[1]/2	,   , .F.})
	oExpsBrw:addColumn({"Loja Imp."				, { || aExps[oExpsBrw:nAt,05] }, "C", pesqPict("EEC","EEC_IMLOJA")	, 1, tamSx3("EEC_IMLOJA")[1]/2	,	, .F.})
	oExpsBrw:addColumn({"Importador"			, { || aExps[oExpsBrw:nAt,06] }, "C", pesqPict("EEC","EEC_IMPODE")	, 1, tamSx3("EEC_IMPODE")[1]/2	,	, .F.})
	oExpsBrw:addColumn({"Valor FOB"			    , { || aExps[oExpsBrw:nAt,07] }, "N", pesqPict("EEC","EEC_VLFOB")	, 1, tamSx3("EEC_VLFOB")[1]/2	,	, .F.})
	oExpsBrw:addColumn({"Peso Total Liquido"	, { || aExps[oExpsBrw:nAt,08] }, "N", pesqPict("EEC","EEC_PESLIQ")	, 1, tamSx3("EEC_PESLIQ")[1]/2	,	, .F.})
	oExpsBrw:addColumn({"Dt. Saida Navio"		, { || aExps[oExpsBrw:nAt,09] }, "N", pesqPict("EEC","EEC_ZDTSN")	, 1, tamSx3("EEC_ZDTSNA")[1]/2	,	, .F.})

	oExpsBrw:activate( .T. )

	// Browse do meio de Despesas
	oDespesBrw := fwBrowse():New()
	oDespesBrw:setDataArray()
	oDespesBrw:setArray( aDespes )
	oDespesBrw:disableConfig()
	oDespesBrw:disableReport()
	oDespesBrw:setOwner( oPanMd01 )

	oDespesBrw:addColumn({"Despesa"			 , {||aDespes[oDespesBrw:nAt,nPosDesp        ]}, "C", pesqPict("ZEE","ZEE_CODDES")	, 1, tamSx3("ZEE_CODDES")[1]/2	,							, .F., , .F.,, ,, .F., .T.,, })
	oDespesBrw:addColumn({"Descrição"		 , {||aDespes[oDespesBrw:nAt,nPosDesc        ]}, "C", "@!"	                        , 1, tamSx3("ZEE_DESPES")[1]/2	,							, .F., , .F.,, ,, .F., .T.,, })
	oDespesBrw:addColumn({"Valor Documento"	 , {||aDespes[oDespesBrw:nAt,nPosValor       ]}, "N", pesqPict("ZEE","ZEE_VALOR")	, 2, tamSx3("ZEE_VALOR")[1]		, tamSx3("ZEE_VALOR")[2]    , .F., , .F.,, ,, .F., .T.,, })
	oDespesBrw:addColumn({"Valor Pré Cálculo", {||aDespes[oDespesBrw:nAt,nPosValorPre    ]}, "N", pesqPict("ZEE","ZEE_VALOR")	, 2, tamSx3("ZEE_VALOR")[1]		, tamSx3("ZEE_VALOR")[2]	, .F., , .F.,, ,, .F., .T.,, })
	oDespesBrw:addColumn({"Moeda"			 , {||aDespes[oDespesBrw:nAt,nPosMoeda       ]}, "C", "@!"		                    , 1, tamSx3("ZEE_MOEDA ")[1]	,		                    , .F., , .F.,, ,, .F., .T.,, })
	oDespesBrw:addColumn({"Taxa Neg."		 , {||aDespes[oDespesBrw:nAt,nPosTaxa 	     ]}, "N", "@E 999.9999"	                , 2, 8		                    , 4		                    , .F., , .F.,, ,, .F., .T.,, })
	oDespesBrw:addColumn({"Valor Moeda"		 , {||aDespes[oDespesBrw:nAt,nPosValorMoeda  ]}, "N", pesqPict("ZEE","ZEE_VALOR")	, 2, tamSx3("ZEE_VALOR")[1]		, tamSx3("ZEE_VALOR")[2]	, .F., , .F.,, ,, .F., .T.,, })
	oDespesBrw:addColumn({"Tipo Cálculo"     , {||aDespes[oDespesBrw:nAt,nPosTipo        ]}, "C", "@!"	                        , 1, 10		                    , 	                        , .F., , .F.,, ,, .F., .T.,, })
	oDespesBrw:addColumn({"Forma de Cálculo" , {||aDespes[oDespesBrw:nAt,nPosForma       ]}, "C", "@!"	                        , 1, 10	                        , 	                        , .F., , .F.,, ,, .F., .T.,, })
	oDespesBrw:addColumn({"Fornecedor"		 , {||aDespes[oDespesBrw:nAt,nPosForn        ]}, "C", "@!"	                        , 1, 3							, 	                        , .F., , .F.,, ,, .F., .T.,, })
	oDespesBrw:addColumn({"Folhas"        	 , {||aDespes[oDespesBrw:nAt,nPosFolhas      ]}, "N", "@E 99999"                    , 2, 5		                    , 0	                        , .F., , .F.,, ,, .F., .T.,, })
	oDespesBrw:addColumn({"Observação"       , {||aDespes[oDespesBrw:nAt,nPosObs         ]}, "C", "@!"                          , 1, 60	    					, 	                        , .T., , .F.,,"xValor" ,, .F., .T.,, })
	
	oDespesBrw:setEditCell( .T. , { || VldObs() } )
	oDespesBrw:setInsert( .F. )
	oDespesBrw:SetDoubleClick ( { || IIf(oDespesBrw:ColPos()==nPosDesp,Inclui_Linha(),.F.) } )
	oDespesBrw:activate( .T. )
	SetKey(VK_F4, {|| Inclui_Linha()})
	
	aDetalhes := aDespes[oDespesBrw:nAt,nPosDetalhe]
	oDetBrow := fwBrowse():New()
	oDetBrow:setDataArray()
	oDetBrow:setArray(aDetalhes)
	oDetBrow:disableConfig()
	oDetBrow:disableReport()
	oDetBrow:setOwner( oPanMd02 )
	oDetBrow:AddMarkColumns({ || IIF(aDetalhes[oDetBrow:nAt,01], 'LBOK', 'LBNO' )},;
	                        { ||  ValAtualiza(1)}   )
	oDetBrow:addColumn({"EXP"	        , { || aDetalhes[oDetBrow:nAt,02] }			   , "C", "@!"                 , 1, 08, ,  .F., , .F.,, ,, .F., .T.,, })
	oDetBrow:addColumn({"Tab"	        , { || aDetalhes[oDetBrow:nAt,03] }			   , "C", "@!"                 , 1, 03, ,  .F., , .F.,, ,, .F., .T.,, })
	oDetBrow:addColumn({"Vlr Calculado" , { || aDetalhes[oDetBrow:nAt,04] }			   , "N", "@E 999,999.99"  	   , 2, 10, 2, .F., , .F.,, ,, .F., .T.,, })
	oDetBrow:addColumn({"Vlr Utilizado" , { || aDetalhes[oDetBrow:nAt,05] }			   , "N", "@E 999,999.99"      , 2, 10, 2, .T., , .F.,,"xValor" ,, .F., .T.,, })
	oDetBrow:setEditCell( .T. , { || ValAtualiza(2) } )
	oDetBrow:activate( .T. )
	
	oDespesBrw:SetChange({|| AtualizaBrowse()} )  

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
	oHistorBrw:addColumn({"Fornecedor Desp."	, {||aDespesLan[oHistorBrw:nAt,08]}, "C", pesqPict("EET","EET_ZFORN")	, 1, tamSx3("EET_ZFORN")[1]		, tamSx3("EET_ZFORN")[2]		, .T. , , .F.,, ,, .F., .T.,									, })
	oHistorBrw:addColumn({"Nome Forncedor"		, {||aDespesLan[oHistorBrw:nAt,09]}, "C", pesqPict("EET","EET_ZNOMEF")	, 1, tamSx3("EET_ZNOMEF")[1]	, tamSx3("EET_ZNOMEF")[2]	, .T. , , .F.,, ,, .F., .T.,									, })
	oHistorBrw:addColumn({"Emissão"				, {||aDespesLan[oHistorBrw:nAt,10]}, "D", pesqPict("SE2","E2_EMISSAO")	, 1, tamSx3("E2_EMISSAO")[1]	, tamSx3("E2_EMISSAO")[2]	, .T. , , .F.,, ,, .F., .T., 									, })
	oHistorBrw:addColumn({"Valor Documento"		, {||aDespesLan[oHistorBrw:nAt,11]}, "N", pesqPict("SE2","E2_VALOR")	, 2, tamSx3("E2_VALOR")[1]		, tamSx3("E2_VALOR")[2]		, .T. , , .F.,, ,, .F., .T.,									, })
	oHistorBrw:addColumn({"Moeda"				, {||aDespesLan[oHistorBrw:nAt,12]}, "C", pesqPict("EET","EET_ZMOED")	, 1, tamSx3("EET_ZMOED")[1]		, tamSx3("EET_ZMOED")[2]	, .T. , , .F.,, ,, .F., .T., { "1=R$","2=US$","3=EUR","4=GBP" }	, })
	oHistorBrw:addColumn({"Taxa Neg."			, {||aDespesLan[oHistorBrw:nAt,13]}, "N", pesqPict("EET","EET_ZTX")		, 2, tamSx3("EET_ZTX")[1]		, tamSx3("EET_ZTX")[2]		, .T. , , .F.,, ,, .F., .T.,									, })
	oHistorBrw:addColumn({"Valor Moeda"			, {||aDespesLan[oHistorBrw:nAt,14]}, "N", pesqPict("EET","EET_ZVLMOE")	, 2, tamSx3("EET_ZVLMOE")[1]	, tamSx3("EET_ZVLMOE")[2]	, .T. , , .F.,, ,, .F., .T.,									, })
	oHistorBrw:addColumn({"Vencimento"			, {||aDespesLan[oHistorBrw:nAt,15]}, "D", pesqPict("EET","EET_DTVENC")	, 1, tamSx3("EET_DTVENC")[1]	, tamSx3("EET_DTVENC")[2]	, .T. , , .F.,, ,, .F., .T.,									, })
	oHistorBrw:addColumn({"Natureza"			, {||aDespesLan[oHistorBrw:nAt,16]}, "C", pesqPict("EET","EET_NATURE")	, 1, tamSx3("EET_NATURE")[1]	, tamSx3("EET_NATURE")[2]	, .T. , , .F.,, ,, .F., .T.,									, })
	oHistorBrw:addColumn({"Prefixo"				, {||aDespesLan[oHistorBrw:nAt,17]}, "C", pesqPict("EET","EET_PREFIX")	, 1, tamSx3("EET_PREFIX")[1]	, tamSx3("EET_PREFIX")[2]	, .T. , , .F.,, ,, .F., .T.,									, })
	oHistorBrw:addColumn({"Centro Custo"		, {||aDespesLan[oHistorBrw:nAt,18]}, "C", pesqPict("EET","EET_ZCCUST")	, 1, tamSx3("EET_ZCCUST")[1]	, tamSx3("EET_ZCCUST")[2]	, .F. , , .F.,, ,, .F., .T.,									, })
	oHistorBrw:addColumn({"Item Ctb.Deb"		, {||aDespesLan[oHistorBrw:nAt,19]}, "C", pesqPict("EET","EET_ZITEMD")	, 1, tamSx3("EET_ZITEMD")[1]	, tamSx3("EET_ZITEMD")[2]	, .F. , , .F.,, ,, .F., .T.,									, })
	oHistorBrw:addColumn({"NF FORNEC"			, {||aDespesLan[oHistorBrw:nAt,20]}, "C", pesqPict("EET","EET_ZNFORN")	, 1, tamSx3("EET_ZNFORN")[1]	, tamSx3("EET_ZNFORN")[2]	, .T. , , .F.,, ,, .F., .T.,									, })

	oHistorBrw:activate( .T. )

	enchoiceBar(oDlgDespes, bOk , bClose,, aButtons)
ACTIVATE MSDIALOG oDlgDespes CENTER
SetKey(VK_F4, {||})
	
Return
*****************************************************************************************************************************************************
Static Function AtualizaBrowse 

aDetalhes := aDespes[oDespesBrw:nAt,nPosDetalhe]
oDetBrow:setArray(aDetalhes)
oDetBrow:Refresh()
oDetBrow:goTop()
oDespesBrw:Refresh()

Return
********************************************************************************************************************************************************
Static Function VldObs()
Local nCol  := oDespesBrw:ColPos()
    
If nCol == nPosOBS .AND. !Empty(aDespes[ oDespesBrw:at() , nPosDesp])
	aDespes[ oDespesBrw:at() , nCol]:= M->xValor
EndIf

Return .T.

********************************************************************************************************************************************************
Static Function ValAtualiza(nTipo)
Local bRet   := .T.
Local nI     := 0 
Local nLinha := oDetBrow:nAt
Local nSoma  := 0

IF nTipo == 1
	aDetalhes[oDetBrow:nAt,01] := !aDetalhes[oDetBrow:nAt,01]
Else
    If M->xValor < 0
			APMsgStop("Valor tem que ser maior que zero.")
			bRet := .F.
	Else		
		aDespes[oDespesBrw:nAt,nPosDetalhe][ oDetBrow:at() ,5]:= M->xValor
	EndIf
EndIF
IF bRet
	For nI := 1 To Len(aDespes[oDespesBrw:nAt,nPosDetalhe]) 
	     IF aDespes[oDespesBrw:nAt,nPosDetalhe][nI,01]
		 	If MV_PAR02 > 0 
		      nSoma  += aDespes[oDespesBrw:nAt,nPosDetalhe][nI,05] * MV_PAR02
			Else
				nSoma  += aDespes[oDespesBrw:nAt,nPosDetalhe][nI,05] 
			EndIf 
		 EndIF
	Next nI
	aDespes[oDespesBrw:nAt,nPosValor] := nSoma
	oDespesBrw:Refresh()
	AtualizaBrowse()
	oDetBrow:goTo(nLinha)
EndIf

Return bRet
****************************************************************************************************************************************************
static function getDespLan()
	Local cQryHist		:= ""
	Local cExpsIn		:= ""
	Local nI			:= 0

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
	cQryHist += " EET_ZFORN			,"												+ CRLF
	cQryHist += " EET_ZNOMEF		,"												+ CRLF
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
	cQryHist += "	AND	EET.D_E_L_E_T_	<>	'*'"									+ CRLF
     //Conout(cQryHist)
	tcQuery cQryHist New Alias "QRYHIST"
return

*****************************************************************************************************
Static Function Inclui_Linha

Local nI     		 := 0
Local nLinha  		:= oDespesBrw:nAt  
Local aRet			:= {}
Local aParambox		:= {}
Private  lTemPreC	:= .F.  // Tem pré calculo definido

IF !Empty(aDespes[nLinha,nPosDesp])
     IF MsgYesNo("Deseja Recalcular a Despesa ?") 
		 If aDespes[nLinha,nPosDesp] $ cIncDesp 
			lTemPreC	:= .T.
		EndIf 

		AAdd( aParambox,{3, "Rateio:"     , 1 , { "Sim" , "Não" } , 070 , "" , .T. } )
		AAdd( aParamBox,{1, "Taxa negoc." ,0       	 , "@E 9,999.9999999"	,,, IIF(!lTemPreC , ".F.",'') ,070,.F.})
		AAdd( aParambox,{1, "Fornecedor:" ,Space(2)	 ,"@!"		      ," Vazio() .OR.  ExistCpo('SX5', 'Z1'+MV_PAR03)  "	,"Z1"	    ,"",050,.F.})
		AAdd( aParamBox,{1, "Folhas:"     ,0         , "@E 999,999",     ,           , ".F." ,070,.F.})
		AAdd( aParamBox,{1, "Valor:"   		,0       , "@E 999,999.9999"	,,, IIF(lTemPreC , ".F.",'') ,070,.F.})
		If ParamBox(aParambox, "Tipo de Lançamento"	, @aRet, , , .T. /*lCentered*/, 0, 0, , , .F. /*lCanSave*/, .F. /*lUserSave*/)
			Calcula_Desp(nLinha)
			AtualizaBrowse()
         EndIf
    Endif
Else    
    cIncDesp := '' 
	cQuery := " SELECT Distinct ZEE_CODDES	"
	cQuery += " From "+retSQLName("ZED")+ " ZED,"+retSQLName("ZEE")+" ZEE"								+ CRLF
	cQuery += " Where  ZED.ZED_DESPAC	=	'"+cDespachante+"'"								+ CRLF 
	cQuery += "    AND ZED.ZED_TIPODE	=	'D'"											+ CRLF 
	cQuery += "    AND ZEE.ZEE_CODIGO	=	ZED.ZED_CODIGO"									+ CRLF
	cQuery += "    AND ZEE.ZEE_FILIAL	=	ZED.ZED_FILIAL"									+ CRLF
	cQuery += "    AND ZEE.D_E_L_E_T_	<>	'*'"											+ CRLF
	cQuery += "    AND ZED.D_E_L_E_T_	<>	'*'"											+ CRLF
	cQuery += " Order by ZEE_CODDES"				+ CRLF
	If Select("QRY_DESP") > 0
		QRY_DESP->(dbCloseArea())
	EndIf
	cQuery  := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_DESP",.T.,.F.)
	QRY_DESP->(dbGoTop())
	While QRY_DESP->(!EOF())
         cIncDesp +=  ' | '+QRY_DESP->ZEE_CODDES
		 QRY_DESP->(dbSkip())
	Enddo
	For nI := 1 To Len(aDespes)
          IF aDespes[nI,01] $ cIncDesp
			  cIncDesp := STRTRAN(cIncDesp, aDespes[nI,01], '' )
		  EndIF	
	Next nI
	If ConPad1(,,,'SYB') //If ConPad1(,,,'XECC73') .AND. SYB->(!EOF())
		If SYB->YB_DESP $ cIncDesp 
			lTemPreC	:= .T.
		Else
			MsgAlert("Despesa não definida em pré cálculo, o pedido ficará bloqueado !!")
			bPreNota := .T.
		EndIf 
		AAdd( aParambox,{3, "Rateio:"     	,1		 , { "Sim" , "Não"} , 070 , "" , .T. } )
		AAdd( aParamBox,{1, "Taxa negoc:"   ,0       , "@E 9,999.9999999"	,,, IIF(!lTemPreC , ".F.",'') ,070,.F.})
		AAdd( aParambox,{1, "Fornecedor:" 	,Space(2),"@!"		      	," Vazio() .OR.  ExistCpo('SX5', 'Z1'+MV_PAR03)  "	,"Z1"	    ,"",050,.F.})
		AAdd( aParamBox,{1, "Folhas:"		,0       , "@E 999,999"		,,,".F.",070,.F.})
		AAdd( aParamBox,{1, "Valor:"   		,0       , "@E 999,999.9999"	,,, IIF(lTemPreC , ".F.",'') ,070,.F.})
		
		If ParamBox(aParambox, "Tipo de Lançamento"	, @aRet, , , .T. /*lCentered*/, 0, 0, , , .F. /*lCanSave*/, .F. /*lUserSave*/)
			
			IF AScan(aDespesLan ,{|x| Alltrim(x[2]) == Alltrim(SYB->YB_DESP) }) <> 0
				 MsgAlert("Despesa já lançada para uma ou mais Exps, o pedido ficará bloqueado !!")
				 bPreNota := .T.
			EndIf
			aDespes[nLinha, nPosDesp    	] := SYB->YB_DESP
			aDespes[nLinha, nPosDesc      	] := SYB->YB_DESCR 
			Calcula_Desp(nLinha)
			AtualizaBrowse()
			AAdd(aDespes,{"","",0,0,"","",0,"","","",0,SPACE(60),{{.F.,"","",0,0}}})		   
			AtualizaBrowse()
		EndIF
	EndIf
EndIF
Return
************************************************************************************************************************************************************
Static Function Calcula_Desp(nReg)

Local nI      := 0
Local aAux    := {}
Local cQuery  := ''
Local nTotal  := 0 
Local nGeral  := 0 
Local nValor  := 0
Local cTab    := ''
Local cMoeda  := ''
Local cTipo   := ""

For nI := 1 To Len(aExps)
	
	cQuery := " SELECT Distinct ZEE_CODIGO ,ZEE_CODDES ,  ZEE_COB, ZEE_TPDESP  , ZEE_MOEDA  , ZEE_VALOR  , ZEE_VALMIN , ZEE_VALMAX , ZEE_FORN   " 	
	cQuery += " From "+retSQLName("ZED")+ " ZED,"+retSQLName("ZEE")+" ZEE"								+ CRLF
	cQuery += " Where  ZED.ZED_TIPODE	=	'D' "											+ CRLF 
	cQuery += "     AND ZEE_CODDES      =   '"+aDespes[nReg,01]+"'"								+ CRLF
	cQuery += " 	AND	ZEE.ZEE_CODIGO	=	ZED.ZED_CODIGO"									+ CRLF
	cQuery += " 	AND	ZEE.ZEE_FILIAL	=	ZED.ZED_FILIAL"									+ CRLF
	cQuery += " 	AND	'" + dToS( dDtEmissao ) + "'	>=	ZEE_DVAL1"				+ CRLF
	cQuery += " 	AND	'" + dToS( dDtEmissao ) + "'	<=	ZEE_DVAL2"				+ CRLF
	cQuery += IIF(Empty(MV_PAR03),"", "     AND ZEE_FORN      =   '"+MV_PAR03+"'"+ CRLF )
	cQuery += " 	AND	ZEE.D_E_L_E_T_	<>	'*'"											+ CRLF
	cQuery += " 	AND	ZED.D_E_L_E_T_	<>	'*'"											+ CRLF
	cQuery += " Order by ZEE_CODIGO ,ZEE_CODDES ,  ZEE_TPDESP  "
	
	If Select("QRY_CALC") > 0
		QRY_CALC->(dbCloseArea())
	EndIf
	cQuery  := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_CALC",.T.,.F.)
	dbSelectArea("QRY_CALC")
	QRY_CALC->(dbGoTop())
	nTotal  := 0 
	IF QRY_CALC->(!Eof())
	    cTab   := QRY_CALC->ZEE_CODIGO
		cMoeda := QRY_CALC->ZEE_MOEDA
		If QRY_CALC->ZEE_TPDESP =='L'
			cTipo  := 'Folhas'
			nTotal := QRY_CALC->ZEE_VALOR * MV_PAR04
		ElseIf QRY_CALC->ZEE_TPDESP =='F'
			nTotal := QRY_CALC->ZEE_VALOR 
			cTipo  := 'Fixo'
		ElseIF QRY_CALC->ZEE_TPDESP =='P' .OR. QRY_CALC->ZEE_TPDESP =='V'
			nValor  := IIF(QRY_CALC->ZEE_TPDESP =='P',aExps[nI,08],aExps[nI,07])
			cTipo   := IIF(QRY_CALC->ZEE_TPDESP =='P',"Peso","Valor Fob")
			While QRY_CALC->(!Eof())
				If   nValor >= QRY_CALC->ZEE_VALMIN  .AND. nValor <=QRY_CALC->ZEE_VALMAX
					nTotal := QRY_CALC->ZEE_VALOR * IIF(QRY_CALC->ZEE_COB=='N',1,IIF(QRY_CALC->ZEE_TPDESP =='P',(nValor/1000),nValor))
					Exit
				EndIf
				QRY_CALC->(dbSkip())
			End
		EndIf
	Else // Despesa não cadastrada
		nTotal := MV_PAR05
		cTipo  := 'Fixo'
	EndIf

	IF MV_PAR01 == 1
	     IF aExps[nI,10] > 0
		      nTotal := nTotal / aExps[nI,10]  
		 EndIf
	EndIF
    AAdd(aAux,{IIf(nTotal > 0 , .T.,.F.),aExps[nI,02], cTab,nTotal,nTotal})  
    nGeral  += nTotal
Next nI
aDespes[nReg,nPosMoeda]      := cMoeda
IF Alltrim(cMoeda)=='R$'
	aDespes[nReg,nPosValorPre]   := nGeral 
	aDespes[nReg,nPosValor]      := nGeral 
	aDespes[nReg, nPosTaxa	  ]  := 0

Else
	If MV_PAR02 > 0
		aDespes[nReg,nPosValorPre]   := nGeral * MV_PAR02
		aDespes[nReg,nPosValor]      := nGeral * MV_PAR02
		aDespes[nReg, nPosTaxa	  ]  := MV_PAR02
	Else 
		aDespes[nReg,nPosValorPre]   := nGeral 
		aDespes[nReg,nPosValor]      := nGeral 
		aDespes[nReg, nPosTaxa	  ]  := 0
	EndIf 

EndIF
aDespes[nReg, nPosValorMoeda] := nGeral
aDespes[nReg, nPosTipo] 	  := cTipo
aDespes[nReg, nPosDetalhe]    := aAux
aDespes[nReg, nPosForma    ]  := IIF(MV_PAR01==1,'Rateio','Sem Rateio')

IF cTipo == 'Folhas'
	aDespes[nReg, nPosFolhas   ]  := MV_PAR04
Else
	aDespes[nReg, nPosFolhas   ]  := 0 
EndIF

aDespes[nReg, nPosForn     ]  := MV_PAR03


Return
********************************************************************************************************************
Static Function Gera_Nota

Local aAreaX		:= getArea()
Local aAreaSC7		:= SC7->( getArea() )
Local aAreaSYB		:= SYB->( getArea() )
Local aAreaEET		:= EET->( getArea() )
Local aAreaEEB		:= EEB->( getArea() )
Local nI            := 0
Local aRet		    := {}
Local aParambox	    := {}

Private bTem            := .F.
Private nValor          := 0 
Private cCondPgtoX	    := ""



For nI := 1 to len(aDespes)
    IF Empty(aDespes[nI,nPosDesp]) .OR. aDespes[nI,nPosValor] == 0 
         Loop
    EndIF
    nValor += aDespes[nI,nPosValor]
	bTem = .T. 
Next Ni
IF !bTem
    bSair       := .F.
    MsgAlert('Não Existe Despesa para ser gerada Nota !!')
    Return
EndIF

DBSelectArea("EET")
AAdd( aParamBox,{1, "Filial :"       ,aExps[01,01]                   ,"@!", "NaoVazio() .AND. ExistCpo('SM0',cEmpAnt+MV_PAR01)"  ,"XM0" ,".F.", 040	, .T.	})
AAdd( aParamBox,{1, "Despachante :"  ,cDespachante    				 ,"@!", ""  		 			 						 ,      ,".F.", 040	, .T.	})
AAdd( aParamBox,{1, "Cod.Forn.Nota:" ,cFornece     					 ,"@!", ""  		 									 ,      ,".F.", 030	, .T.	})
AAdd( aParamBox,{1, "Loja :"         ,cLoja   						 ,"@!", ""  								             ,      ,".F.", 030	, .T.	})
AAdd( aParamBox,{1, "Documento :"    ,Space(tamSx3("F1_DOC")[1])     ,"@!", "U_xEEC75Vld(1) "  								 ,      ,, 030	, .T.	})
AAdd( aParamBox,{1, "Série :"        ,Space(tamSx3("F1_SERIE")[1])   ,"@!", "U_xEEC75Vld(1) .AND. U_xEEC75Vld(2) "  		 ,      ,, 030	, .T.	})
AAdd( aParamBox,{1, "Espécie :"      ,Space(tamSx3("F1_ESPECIE")[1]) ,"@!", "U_xEEC75Vld(2) .AND. U_xEEC75Vld(3)"  			 ,      ,, 030	, .T.	})
AAdd( aParamBox,{1, "Operação :"     ,Space(tamSx3("D1_OPER")[1])    ,"@!", "U_xEEC75Vld(3)"  								 ,      ,, 030	, .T.	})
AAdd( aParamBox,{1, "Emissão :"      ,dDtEmissao                	 ,"@D", ""  						                     ,      ,".F.", 050	, .T.	})
AAdd( aParamBox,{1, "Valor Doc.:"    ,nValor              			 ,"@E 999,999,999.99",   ,,".F.", 070	, .T.	})
AAdd( aParamBox,{1, "Vencimento :"   ,Ctod("  /  /  ")               ,"@D", "MV_PAR11 >= dDataBase"  						 ,      ,, 050	, .T.	})
AAdd( aParamBox,{1, "Natureza :"     ,cNatureza                       ,"@!", "Vazio() .Or. ExistCpo('SED',MV_PAR12)"  		 ,"SED" ,, 050	, .T.	})
AAdd( aParamBox,{1, "NF. Fornec. :"  ,Space(tamSx3("EET_ZNFORN")[1]) ,"@!", ""  		  									 ,      ,".F.", 040	, .T.	})
//AAdd( aParamBox,{1, "Obs :"          ,Space(tamSx3("EET_ZOBS")[1])   ,"@!", ""  		  									 ,      ,, 100	, .F.	})
If ParamBox(aParambox, "Dados da Nota Fiscal"  , @aRet, , , .T. , 0, 0, , , .F. , .F. )
	cCondPgtoX	:= ""
	cCondPgtoX	:= getCndPgto(  MV_PAR11 , MV_PAR09 )
    IF Empty(cCondPgtoX)
	    MsgAlert("Não encontrado uma Condição de Pagamento para a Data de Emissão e Vencimento!!")
	Else
		fwMsgRun(, { || Proc_Nota() }		, "Gerar Nota/Pedido", "Aguarde.... Processando a emissão da Nota/Pedido..." )
	EndIf
EndIF
restArea( aAreaEEB )
restArea( aAreaEET )
restArea( aAreaSYB )
restArea( aAreaSC7 )
restArea( aAreaX )
Return
******************************************************************************************************************
Static Function Proc_Nota

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
Local cEETSeq		:= ""
Local cQryEEB		:= ""
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
Local xMV_PAR01     := MV_PAR01
Local xMV_PAR02     := MV_PAR02
Local xMV_PAR03     := MV_PAR03
Local xMV_PAR04     := MV_PAR04
Local xMV_PAR05     := MV_PAR05
Local xMV_PAR06     := MV_PAR06
Local xMV_PAR07     := MV_PAR07
Local xMV_PAR08     := MV_PAR08
Local xMV_PAR09     := MV_PAR09
Local xMV_PAR10     := MV_PAR10
Local xMV_PAR11     := MV_PAR11
Local xMV_PAR12     := MV_PAR12
Local xMV_PAR13     := MV_PAR13
Local cZCCUST	    := GetMV('MGF_EEC75A',.F.,"2404")
Local cZITEMD	    := GetMV('MGF_EEC75B',.F.,"12")



Private lGradeSC7		:= .F.
Private lMsHelpAuto     := .T.
Private lMsErroAuto     := .F.
Private lAutoErrNoFile  := .T. 

For nI := 1 to Len(aDespes)
	aSC7Cab		:= {}
	aSC7Aux		:= {}
	aSC7Itens	:= {}
	IF Empty(aDespes[nI,nPosDesp]) .OR. aDespes[nI,nPosValor] == 0 
		Loop
	EndIF
	cDoctoAtu	:= xMV_PAR05 + xMV_PAR03
	AAdd( aSC7Cab , { "C7_EMISSAO"		, xMV_PAR09		, Nil } )
	AAdd( aSC7Cab , { "C7_FORNECE"		, xMV_PAR03		, Nil } )
	AAdd( aSC7Cab , { "C7_LOJA"			, xMV_PAR04		, Nil } )
	AAdd( aSC7Cab , { "C7_COND"			, cCondPgtoX	, Nil } )
	AAdd( aSC7Cab , { "C7_FILENT"		, xMV_PAR01		, Nil } )
	AAdd( aSC7Cab , { "C7_FILIAL"		, xMV_PAR01		, Nil } )
	AAdd( aSC7Cab , { "C7_FLUXO"		, "S"			, Nil } )
	AAdd( aSC7Cab , { "C7_XCODAGE"		, cDespachante 	, Nil } )
	aAgr := aDespes[ nI,nPosDetalhe]
	cItemSC7 := ""
	cItemSC7 := strZero ( 0 , tamSX3("C7_ITEM")[1] )
	For nJ := 1 To Len(aAgr )
		IF !aAgr[nJ,01] .OR. aAgr[nJ,05] == 0 
			Loop
		EndIF
		aSC7Aux		:= {}
		cItemSC7	:= soma1( cItemSC7 )

		AAdd( aSC7Aux , { "C7_ITEM"		, cItemSC7					  , Nil } )
		AAdd( aSC7Aux , { "C7_PRODUTO"	, GetAdvFVal("SYB" , "YB_PRODUTO" , xFilial("SYB") + aDespes[ nI , nPosDesp ]	, 1 , "")	, Nil } )
		AAdd( aSC7Aux , { "C7_QUANT"	, 1	                          , Nil } )
		AAdd( aSC7Aux , { "C7_PRECO"	, aAgr[nJ,05]                 , Nil } )
		AAdd( aSC7Aux , { "C7_CC"		, cZCCUST					  , Nil } )
		AAdd( aSC7Aux , { "C7_ZCC"		, cZCCUST					  , Nil } )
		AAdd( aSC7Aux , { "C7_SEQUEN"	, cItemSC7					  , Nil } )
		AAdd( aSC7Aux , { "C7_ORIGEM"	, "SIGAEEC"					  , Nil } )
		AAdd( aSC7Aux , { "C7_FLUXO"	, "S"						  , Nil } )
		AAdd( aSC7Aux , { "C7_QTDSOL"	, 1							  , Nil } )
		AAdd( aSC7Aux , { "C7_ZNATURE"	, xMV_PAR12					  , Nil } )
		AAdd( aSC7Aux , { "C7_ZDOCTO"	, xMV_PAR05 + xMV_PAR06       , Nil } )
		AAdd( aSC7Aux , { "C7_OBS"		, "Emb.Exp: " + aAgr[nJ,02]	  , Nil } )
		AAdd( aSC7Aux , { "C7_ITEMCTA"	, cZITEMD					  , Nil } )
		AAdd( aSC7Aux , { "C7_XSERIE"	, xMV_PAR06					  , Nil } )
		AAdd( aSC7Aux , { "C7_XESPECI"	, xMV_PAR07					  , Nil } )
		AAdd( aSC7Aux , { "C7_XOPER"	, xMV_PAR08					  , Nil } )
		AAdd( aSC7Aux , { "C7_ZCODGRD"	, 'ZZZZZZZZZZ'				  , Nil } )
		AAdd( aSC7Itens , aSC7Aux )
		IF AScan(aExpGrv,{|x| x == aAgr[nJ,02] }) == 0
			AAdd(aExpGrv,aAgr[nJ,02] )
		EndIF		
		If aAgr[nJ,05] <> aAgr[nJ,04]
			AAdd( aDocsPreCa , xMV_PAR05+xMV_PAR06 )
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
		For nX := 1 To len(aErro)
			cErro += aErro[nX] + CRLF  //estava ni
		next nX
		conout( " MGFEEC75 - MATA120 " + cErro )
	Else
		while getSX8Len() > nStackSX8
			CONFIRMSX8()
		Enddo
		AAdd( aDocsSC7 , SC7->C7_NUM )
		conout( " MGFEEC75 - MATA120 - Pedido de Compra: " + SC7->C7_FILIAL + SC7->C7_NUM )
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
			cQryEEB += "	AND	EEB.EEB_CODAGE	=	'" + cDespachante			+ "'"	+ CRLF
			cQryEEB += "	AND	EEB.EEB_FILIAL	=	'" + SC7->C7_FILIAL		+ "'"	+ CRLF
			cQryEEB += " 	AND	EEB.D_E_L_E_T_	<>	'*'"							+ CRLF
		
			conout( cQryEEB )
		
			tcQuery cQryEEB New Alias "QRYEEB"
		
			If QRYEEB->(EOF())
				// SE EMPRESA NAO ESTIVER GRAVADA - INCLUI NA TABELA EEB
					recLock("EEB" , .T.)
					EEB->EEB_FILIAL	:= SC7->C7_FILIAL
					EEB->EEB_CODAGE	:= cDespachante
					EEB->EEB_PEDIDO	:= aExpGrv[nX]	// NUMERO DA EXP
		
					EEB->EEB_TIPOAG	:= GetAdvFVal("SY5" , "Y5_TIPOAGE"	, xFilial("SY5") + cDespachante	, 1 , "")
					EEB->EEB_NOME	:= GetAdvFVal("SY5" , "Y5_NOME"		, xFilial("SY5") + cDespachante	, 1 , "")
		
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
			EET->EET_CODAGE	:= cDespachante
			EET->EET_TIPOAG := GetAdvFVal("SY5" , "Y5_TIPOAGE"	, xFilial("SY5") + cDespachante	, 1 , "")
			EET->EET_OCORRE	:= "Q"
			EET->EET_SEQ	:= cEETSeq
			EET->EET_DESPES	:= aDespes[ nI, nPosDesp ]
			EET->EET_XTABPR	:= aAgr[nX,03]
			EET->EET_XMOEPR	:= aDespes[ nI, nPosMoeda ]
			EET->EET_XPRECA	:= aAgr[nX,05]
			EET->EET_DOCTO	:= xMV_PAR05
			EET->EET_DESADI	:= xMV_PAR09
			EET->EET_VALORR	:= aAgr[nX,05] * IIF(aDespes[ nI, nPosTaxa]==0, 1, aDespes[ nI, nPosTaxa]) 
			EET->EET_ZMOED	:= 'R$'
			EET->EET_ZTX	:= aDespes[ nI, nPosTaxa]// Taxa Neg.
			EET->EET_ZVLMOE	:= aDespes[ nI, nPosValorMoeda] 
			EET->EET_DTVENC	:= xMV_PAR11// Vencimento
			EET->EET_NATURE	:= xMV_PAR12// Natureza
			EET->EET_ZCCUST	:= cZCCUST// Centro Custo
			EET->EET_ZITEMD	:= cZITEMD// Item Ctb.Deb
			EET->EET_ZNFORN	:= xMV_PAR13// NF FORNEC
			EET->EET_ZOBS	:= aDespes[ nI, nPosOBS]
			EET->EET_ZFORN  := aDespes[ nI, nPosForn ]
			EET->EET_ZNOMEF := GetAdvFVal("SX5" , "X5_DESCRI"	, xFilial("SX5")+'Z1'+aDespes[ nI, nPosForn ]	, 1 , "")
			EET->( msUnlock() )
			AAdd(aExclui,EET->(Recno()))
		Next nX
	EndIF
Next nI

If !Empty( aDocsSC7 )
	cDocsSC7 := ""
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
		AAdd( aSF1 , {"F1_FILIAL"	, QRYSC7->C7_FILIAL			, Nil } )
		AAdd( aSF1 , {"F1_TIPO"   	, "N"						, Nil } )
		AAdd( aSF1 , {"F1_FORMUL" 	, "N"						, Nil } )
		AAdd( aSF1 , {"F1_DOC"		, padL( allTrim( QRYSC7->C7_ZDOCTO ) , tamSX3("F1_DOC")[1] , "0" )			, Nil } )
		AAdd( aSF1 , {"F1_SERIE"	, QRYSC7->C7_XSERIE			, Nil } )
		AAdd( aSF1 , {"F1_EMISSAO"	, sToD( QRYSC7->C7_EMISSAO ), Nil } )
		AAdd( aSF1 , {"F1_FORNECE"	, QRYSC7->C7_FORNECE		, Nil } )
		AAdd( aSF1 , {"F1_LOJA"   	, QRYSC7->C7_LOJA			, Nil } )
		AAdd( aSF1 , {"F1_ESPECIE"	, QRYSC7->C7_XESPECI		, Nil } )
		AAdd( aSF1 , {"F1_EST"		, getAdvFVal( "SA2" , "A2_EST" , xFilial("SA2") + QRYSC7->( C7_FORNECE + C7_LOJA ) , 1 , "")					, Nil } )
		AAdd( aSF1 , {"F1_COND"		, QRYSC7->C7_COND			, Nil } )
		AAdd( aSF1 , {"E2_NATUREZ"	, QRYSC7->C7_ZNATURE		, Nil } )
		AAdd( aSF1 , {"F1_DTDIGIT"	, dDataBase					, Nil } )

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

			AAdd( aSD1Aux , { "D1_FILIAL"	, QRYSC7->C7_FILIAL					, Nil } )
			AAdd( aSD1Aux , { "D1_ITEM"		, cItemSD1							, Nil } )
			AAdd( aSD1Aux , { "D1_COD"		, QRYSC7->C7_PRODUTO				, Nil } )
			AAdd( aSD1Aux , { "D1_QUANT"	, QRYSC7->C7_QUANT					, Nil } )
			//AAdd( aSD1Aux , { "D1_VUNIT"	, noRound( QRYSC7->C7_PRECO , 2 )	, Nil } )
			//AAdd( aSD1Aux , { "D1_TOTAL"	, noRound( QRYSC7->C7_PRECO , 2 )	, Nil } )
			AAdd( aSD1Aux , { "D1_VUNIT"	, QRYSC7->C7_PRECO					, Nil } )
			AAdd( aSD1Aux , { "D1_TOTAL"	, QRYSC7->C7_PRECO					, Nil } )

			If lPreCalc .AND. !bPreNota
				// SE PRE CALCULO OK -> NOTA CLASSIfICADA
				AAdd( aSD1Aux , { "D1_OPER"		, QRYSC7->C7_XOPER		, Nil } )
			EndIf
			AAdd(aNotas, {QRYSC7->C7_NUM, Alltrim(QRYSC7->C7_ZDOCTO)+'/'+QRYSC7->C7_XSERIE,cItemSD1,IIF(lPreCalc .AND. !bPreNota,.T.,.F.)})
			
			AAdd( aSD1Aux , { "D1_CC"		, QRYSC7->C7_ZCC		, Nil } )

			AAdd( aSD1Aux, { "D1_PEDIDO"	, QRYSC7->C7_NUM		, Nil } )
			AAdd( aSD1Aux, { "D1_ITEMPC"	, QRYSC7->C7_ITEM		, Nil } )

			AAdd( aSD1Aux, { "D1_ITEMCTA"	, QRYSC7->C7_ITEMCTA	, Nil } )
			AAdd( aSD1Aux, { "D1_QTDPEDI"	, QRYSC7->C7_QUANT		, Nil } )

			AAdd( aSD1 , aSD1Aux )

			AAdd( aC7Num , QRYSC7->C7_NUM )

			QRYSC7->( DBSkip() )
		Enddo

		varInfo( "aSD1" , aSD1 )
		varInfo( "aSF1" , aSF1 )

		lMsErroAuto := .F.
		
		If lPreCalc .AND. !bPreNota
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

			If lPreCalc .AND. !bPreNota
				conout( " MGFEEC75 - MATA103 - " + cErro )
			Else
				conout( " MGFEEC75 - MATA140 - " + cErro )
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

			If lPreCalc .AND. !bPreNota
				conout( " MGFEEC75 - MATA103 - Nota de Entrada: " + SF1->( F1_FILIAL + F1_DOC ) )
			Else
				conout( " MGFEEC75 - MATA140 - PRE Nota de Entrada: " + SF1->( F1_FILIAL + F1_DOC ) )
			EndIf

			AAdd( aDocsSF1 , { SF1->F1_FILIAL , SF1->F1_DOC , SF1->F1_SERIE , SF1->F1_FORNECE , SF1->F1_LOJA } )

			// APOS PROCESSAMENTO - PROCESSAMENTO DE BLOQUEIOS - FAZ ISSO PARA NAO BLOQUEAR GERACAO DA PRE NOTA
			If !lPreCalc .OR. bPreNota 
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


Return
******************************************************************************************************************
User Function xEEC75Vld(nTipo)
Local bRet    := .T.
Local cQuery  := ""

IF nTipo == 1 // Nota fiscal = DOC e Serie
	IF !Empty(MV_PAR01) .AND. !Empty(MV_PAR03) .AND. !Empty(MV_PAR04).AND. !Empty(MV_PAR05) .AND. !Empty(MV_PAR06)
		MV_PAR05 := STRZERO(VAL(MV_PAR05),9)
		MV_PAR13 := MV_PAR05
		cQuery := " SELECT F1_FILIAL, F1_DOC "	
		cQuery += " From "+retSQLName("SF1")
		cQuery += " Where D_E_L_E_T_ = ' ' "								+ CRLF 
		cQuery += "  AND F1_FILIAL	 =	 '"+MV_PAR01+"' "											+ CRLF 
		cQuery += "  AND F1_FORNECE  =   '"+MV_PAR03+"'"								+ CRLF
		cQuery += "  AND F1_LOJA     =   '"+MV_PAR04+"'"								+ CRLF
		cQuery += "  AND F1_DOC      =   '"+MV_PAR05+"'"								+ CRLF
		cQuery += "  AND F1_SERIE    =   '"+MV_PAR06+"'"								+ CRLF
		
		If Select("QRY_VLD") > 0
			QRY_VLD->(dbCloseArea())
		EndIf
		cQuery  := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_VLD",.T.,.F.)
		dbSelectArea("QRY_VLD")
		QRY_VLD->(dbGoTop())
		IF QRY_VLD->(!Eof())
	         MsgAlert('Nota Fiscal/Serie já lançada para o Fornecedor !!')  	
			 bRet  := .F.
		EndIF
	EndIf
ElseIF nTipo == 2 //  Especie = Serie e Especie
	IF !Empty(MV_PAR01) .AND. !Empty(MV_PAR03) .AND. !Empty(MV_PAR04).AND. !Empty(MV_PAR07) .AND. !Empty(MV_PAR06)
		cQuery := " SELECT ZW_ESPECIE "	
		cQuery += " From "+retSQLName("SZW")
		cQuery += " Where D_E_L_E_T_ = ' ' "								+ CRLF 
		cQuery += "  AND ZW_FILIAL	 =	 '"+xFilial("SZW",MV_PAR01)+"' "											+ CRLF 
		cQuery += "  AND ZW_FORNECE  =   '"+MV_PAR03+"'"								+ CRLF
		cQuery += "  AND ZW_LOJA     =   '"+MV_PAR04+"'"								+ CRLF
		cQuery += "  AND ZW_SERIE    =   '"+MV_PAR06+"'"								+ CRLF
		cQuery += "  AND ZW_ESPECIE  =   '"+MV_PAR07+"'"								+ CRLF
		
		If Select("QRY_VLD") > 0
			QRY_VLD->(dbCloseArea())
		EndIf
		cQuery  := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_VLD",.T.,.F.)
		dbSelectArea("QRY_VLD")
		QRY_VLD->(dbGoTop())
		IF QRY_VLD->(Eof())
			MsgStop('Espécie deste documento não está cadastrada para este Fornecedor na tabela de Amarração de Fornecedor x Especie NFE Talonário !!')  	
			bRet := .F.
		EndIF
	EndIf
ElseIf nTipo == 3 // Operacao = Operacao e Especie
	IF !Empty(MV_PAR01) .AND. !Empty(MV_PAR08) .AND. !Empty(MV_PAR07)
		cQuery := " SELECT ZBT_OPER "	
		cQuery += " From "+retSQLName("ZBT")
		cQuery += " Where D_E_L_E_T_ = ' ' "				+ CRLF 
		cQuery += "   AND ZBT_FILIAL =	 '"+xFilial("ZBT",MV_PAR01)+"' "	+ CRLF 
		cQuery += "   AND ZBT_OPER   =   '"+MV_PAR08+"'"	+ CRLF
		cQuery += "   AND ZBT_ESPEC  =   '"+MV_PAR07+"'"	+ CRLF
		
		If Select("QRY_VLD") > 0
			QRY_VLD->(dbCloseArea())
		EndIf
		cQuery  := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_VLD",.T.,.F.)
		dbSelectArea("QRY_VLD")
		QRY_VLD->(dbGoTop())
		IF QRY_VLD->(Eof())
			MsgStop('Não existe amarração do Tipo de Operação X Espécie NFE cadastrada para esta operação !!')  	
			bRet := .F.
		EndIF
	EndIf
EndIf

Return bRet
************************************************************************************************************************************************
Static Function getCndPgto( dVencDespe , dDtEmissao )
Local cRetCondPg	:= ""
Local cQrySE4		:= ""
Local nDias			:= ( dVencDespe - dDtEmissao )

cQrySE4 := "SELECT E4_CODIGO"											+ CRLF
cQrySE4 += " FROM " + retSQLName("SE4") + " SE4"						+ CRLF
cQrySE4 += " WHERE"														+ CRLF

If nDias > 99
	cQrySE4 += "		SE4.E4_COND		=	'" + strZero( nDias , 3 ) + "'"	+ CRLF
Else
	cQrySE4 += "		SE4.E4_COND		=	'" + strZero( nDias , 2 ) + "'"	+ CRLF
EndIf

cQrySE4 += " 	AND	SE4.D_E_L_E_T_	<>	'*'"							+ CRLF
tcQuery cQrySE4 New Alias "QRYSE4"

Conout(cQrySE4)
If !QRYSE4->( EOF() )
	cRetCondPg := QRYSE4->E4_CODIGO
EndIf
QRYSE4->( DBCloseArea() )

return cRetCondPg
