#Include "PROTHEUS.CH"  
#Include "RWMAKE.CH"             
#Include "TopConn.ch"  
#Include "vkey.ch"

#DEFINE _ENTER CHR(13)+CHR(10)         



/*/
=============================================================================
{Protheus.doc} MGFTAP17
Tela administração de integrações de OP Taura/Protheus
@author
Josué Danich
@since
24/06/2020
/*/
user function MGFTAP17()

Private _alista := {}
Private _otemp := nil
Private cIdProc		:= ""
Private cIdSeq	:= ""
Private cTMPrd		:= GetMv("MGF_TAP02B",,"111")
Private cTMDev		:= GetMv("MGF_TAP02C",,"112")
Private cTMDev2		:= GetMv("MGF_TAP02U",,"001")
Private cTMReq		:= GetMv("MGF_TAP02D",,"555")

Private cMovPrd		:= GetMv("MGF_TAP02E",,"01/")	// Apontamento de Produção
Private cMovReq		:= GetMv("MGF_TAP02F",,"02/")	// Requisição
Private ctpopign	:= GetMv("MGF_TAP02Y",,"14/09/06")   //Tipo de OP QUE TERÁ MOVIMENTO DE  geração  a ser ignorado
Private ctpopig2	:= GetMv("MGF_TAP02Z",,"07/05/13")   //Tipo de OP QUE TERÁ MOVIMENTO de consumo a ser ignorado
Private ctpopign4	:= GetMv("MGF_TAP023",,"14")   //Tipo de OP QUE TERÁ MOVIMENTO DE  geração  a ser ignorado
Private ctpopig5	:= GetMv("MGF_TAP024",,"11")   //2o. Tipo de OP QUE TERÁ MOVIMENTO DE  geração 05  a ser ignorado
Private cMovReq2	:= GetMv("MGF_TAP025",,"05")	// Requisição a ser ignorada pelo ctpoig5

Private _cosso      := GetMv("MGF_TAP027",,"009983;009985") //Produtos osso para evitar duplicata
Private _ctposso    := GetMv("MGF_TAP026",,"06/07") //Tipo operação desossa para evitar duplicata

Private ctpopdes	:= GetMv("MGF_TAP02W",,"07/")   //Tipo de movimento de produção de desossa
Private cEncPrd		:= GetMv("MGF_TAP02K",,"04/")		// Encerramento de Produção
Private cMovDev		:= GetMv("MGF_TAP02L",,"03/")		// Devolução (Apontamento de Sub-produto)
Private cSubPrd		:= GetMv("MGF_TAP02M",,"02/")		// Tipo OP de Subproduto (02 = Miudo). Não gera OP para ZZE_CODPA
Private cTipTrn		:= GetMv("MGF_TAP02N",,"04")		// Tipo OP de Transformação Cabeça de gado em Kg. Processo de Entrada
Private cTipAbt		:= GetMv("MGF_TAP02Q",,"01/")		// Tipo OP de Abate
Private cMovTr 		:= GetMv("MGF_TAP02X",,"06/")		// Tipo Movimento de Transferencia MATA261
Private lAglMov		:= GetMv("MGF_TAP02G",,.T.)			// Aglutina movimentações

MGTAP17INI()

Return()

/*/
=============================================================================
{Protheus.doc} MGTAP17INI
Funcao que controla o processamento
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGTAP17INI()

Private cMarkado	:= GetMark()
Private lInverte	:= .F.



Private aCampos		:= {}

MGTAP17PRC()

Return()


/*/
=============================================================================
{Protheus.doc} MGTAP17PRC
Função que processa as integrações
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGTAP17PRC()

Private cMarca   := GetMark()
Private aCampos  := {}
Private cPerg		:= 'MGFTAP17'

If Pergunte( cPerg , .T. )

	//================================================================================
	// Cria o arquivo Temporario para insercao dos dados selecionados.
	//================================================================================
	FWMSGRUN( , {|oproc| _nControle := MGTAP17ARQ(oproc, .T., .F.) }, "Aguarde!" , 'Lendo Dados das integrações...' )

	MGTAP17TRS()//Função que monta a tela para processar

Endif


Return .T.

/*/
=============================================================================
{Protheus.doc} MGTAP17TRS
Função que monta a tela para processar
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGTAP17TRS()

Local oPanel		:= Nil
Local oDlg1			:= Nil
Local nHeight		:= 0
Local nWidth		:= 0
Local aSize			:= {}
Local aBotoes		:= {}
Local aCoors		:= {}

Private nOpca		:= 0
Private cFiltro		:= "%" 
Private _aAreaCabec	:= {} 
Private _cFilPed	:= ""
Private _cNumPed	:= ""          
Private oMark		:= Nil
Private nQtdTit		:= 0
Private nPesTit	    := 0
Private nValTit     := 0
Private oQtda		:= Nil
Private oPesa		:= Nil
Private oValor      := Nil



//================================================================================
// Botoes da tela.
//================================================================================
Aadd( aBotoes , { "" , {|| MGTAP17C(01) 	}	, "" , "Atualizar"		 			 } )
Aadd( aBotoes , { "" , {|| MGTAP17C(03) 	}	, "" , "Filtro"         			 } )
Aadd( aBotoes , { "" , {|| MGTAP17C(04) 	}	, "" , "Visualizar integração"		 } )
Aadd( aBotoes , { "" , {|| MGTAP17C(05) 	}	, "" , "Reprocessar integração"		 } )
Aadd( aBotoes , { "" , {|| MGTAP17C(11) 	}	, "" , "Legenda"       				 } )
Aadd( aBotoes , { "" , {|| MGTAP17C(02) 	}	, "" , "Exporta integracoes"		 } )

//Adiciona botoes administrativos
_cusercod := RetCodUsr( ) 

If _cusercod $ supergetmv("MGFTAP17US",,"004455")
	Aadd( aBotoes , { "" , {|| MGTAP17C(06) 	}	, "" , "Gera Integração manual" 	 } )
Endif


//================================================================================
// Faz o calculo automatico de dimensoes de objetos
//================================================================================
aSize := MSADVSIZE() 

//================================================================================
// Cria a tela para selecao dos pedidos
//================================================================================
_ctitulo := "CENTRAL DE INTEGRACOES DE OPS TAURA/PROTHEUS"
		

 DEFINE MSDIALOG oDlg1 TITLE OemToAnsi(_ctitulo) From 0,0 To aSize[6],aSize[5] PIXEL

	oPanel       := TPanel():New(30,0,'',oDlg1,, .T., .T.,, ,315,20,.T.,.T. )

	If FlatMode()
	
		aCoors	:= GetScreenRes()
		nHeight	:= aCoors[2]
		nWidth	:= aCoors[1]
		
	Else
	
		nHeight	:= 143
		nWidth	:= 315
		
	Endif
	
	DBSelectArea("TRBF")
	TRBF->(DbGotop()) 
	
	oMark					:= MsSelect():New( "TRBF" , "TRBF_OK" ,, aCampos , @lInverte , @cMarkado , { 35 , 1 , nHeight , nWidth } )

    oCol := oMark:oBrowse:aColumns[2]
    oCol:bData     := {|| U_MGTAP17CL() }
    oMark:oBrowse:aColumns[2]:=oCol

	oDlg1:lMaximized:=.T.

ACTIVATE MSDIALOG oDlg1 ON INIT ( EnchoiceBar(oDlg1,{|| MGTAP17C(02) },{|| nOpca := 2,oDlg1:End()},,aBotoes),;
                                  oPanel:Align:=CONTROL_ALIGN_TOP , oMark:oBrowse:Align:=CONTROL_ALIGN_ALLCLIENT , oMark:oBrowse:Refresh())


Return nOpca


/*/
=============================================================================
{Protheus.doc} MGTAP17ARQ
Rotina para criação do arquivo temporário
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGTAP17ARQ(oproc,_lini,_lcabec)

Local aEstru		:= {}
Local cFiltro		:= "" 
Local _nNumReg		:= 0
Default _lini := .F.
Default _lcabec := .T.

//garante que o pergunte está correto
Pergunte( cPerg , .F. )

//================================================================================
// Armazena no array aEstru a estrutura dos campos da tabela.
//================================================================================
AADD( aEstru , { "TRBF_OK"		, 'C' , 02 , 0 } )
AADD( aEstru , { "TRBF_FILIA"   , 'C' , 35 , 0 } ) 
AADD( aEstru , { "TRBF_ACAO"    , 'C' , 35 , 0 } )  
AADD( aEstru , { "TRBF_OPTAU"   , 'C' , 06 , 0 } )  
AADD( aEstru , { "TRBF_CODIG"   , 'C' , 50 , 0 } )  
AADD( aEstru , { "TRBF_DESCE"   , 'C' , 30 , 0 } )  
AADD( aEstru , { "TRBF_STATU"   , 'C' , 21 , 0 } )  
AADD( aEstru , { "TRBF_ZZEQT"   , 'C' , 10 , 0 } )  
AADD( aEstru , { "TRBF_SD3QT"   , 'C' , 10 , 0 } )
AADD( aEstru , { "TRBF_SD3LT"   , 'C' , 15 , 0 } )


AADD( aCampos , { "TRBF_OK"		, "" , " "					, " "									} )
AADD( aCampos , { "TRBF_OK"		, "" , " "					, " "									} )
AADD( aCampos , { "TRBF_FILIA"	, "" , "Filial"		        , PesqPict( "SA1" , "A1_FILIAL" )	  		} )
AADD( aCampos , { "TRBF_ACAO"	, "" , "Ação"	    		, PesqPict( "SA1" , "A1_NOME" )			} )
AADD( aCampos , { "TRBF_OPTAU"	, "" , "OP Taura"	   		, PesqPict( "SA1" , "A1_NOME" )			} )
AADD( aCampos , { "TRBF_CODIG"	, "" , "Produto"	   		, PesqPict( "SA1" , "A1_NOME" )			} )
AADD( aCampos , { "TRBF_DESCE"	, "" , "Obs Integra"		, PesqPict( "SA1" , "A1_NOME" )			} )
AADD( aCampos , { "TRBF_STATU"	, "" , "Status"	   			, PesqPict( "SA1" , "A1_NOME" )			} )
AADD( aCampos , { "TRBF_ZZEQT"	, "" , "Qtde Integrada"		, PesqPict( "SA1" , "A1_NOME" )			} )
AADD( aCampos , { "TRBF_SD3LT"	, "" , "Lote"				, PesqPict( "SD3" , "D3_ZPEDLOT" )			} )



If Select("TRBF") > 0
	oproc:cCaption := ("Apagando temporário...")
	ProcessMessages()
	TRBF->(DbCloseArea())
	If ValType(_otemp) == "O"
	   _otemp:Delete()
	EndIf
EndIf

oproc:cCaption := ("Criando arquivo temporário...")
ProcessMessages()
_otemp := FWTemporaryTable():New( "TRBF", aEstru )

oproc:cCaption := ("Criando indices do arquivo temporário...")
ProcessMessages()
_otemp:AddIndex( "CO", {"TRBF_OPTAU"} )

_otemp:Create()


//================================================================================
// Verifica se ja existe um arquivo com mesmo nome, se sim deleta.
//================================================================================
If Select("QRYPED") > 0
	QRYPED->( DBCloseArea() )
EndIf

//================================================================================
// Query para selecao dos dados da OP
//================================================================================
_cquery := "SELECT zze_filial,zze_acao,zze_optaur,ZZE_TPMOV,zze_cod,zze_descer,zze_status,sum(zzequant) zzeqt ,sum(quant) sd3qt,zze_pedlot from( "
_cquery += " SELECT zze_filial,zze_acao,zze_optaur,ZZE_TPMOV,zze_cod,zze_descer,sum(zze_quant) zzequant,zze_status,zze_pedlot, "
_cquery += " (select sum(d3_quant) from sd3010 sd3 where sd3.d_e_l_e_t_ <> '*' and d3_filial = zze_filial "
_cquery += "     and d3_zoptaur = zze_optaur and d3_zchaveu = zze_chavea  ) quant, zze_chavea "
_cquery += " from zze010 zze where zze.d_e_l_e_t_ <> '*' "
_cquery += " and zze_filial = '" + alltrim(MV_PAR01)  +  "' and zze_optaur = '" + alltrim(MV_PAR02) +  "'"
If !empty(MV_PAR03)
	_cquery += " and zze_pedlot = '" + alltrim(MV_PAR03)  +  "'"
Endif
_cquery += " and zze_tpmov <> '04' "
_cquery += " and NOT (zze_descer like '%gnorado%') "
_cquery += " group by zze_filial,zze_acao,ZZE_TPMOV,zze_optaur,zze_cod,zze_descer,zze_status,zze_chavea,zze_pedlot ) "
_cquery += " group by zze_filial,zze_acao,ZZE_TPMOV,zze_optaur,zze_cod,zze_descer,zze_status,zze_pedlot "
_cquery += " order by ZZE_COD,zze_acao,zze_pedlot "
 

oproc:cCaption := ("Carregando query de integrações...")
ProcessMessages()

TCQUERY _cquery NEW ALIAS "QRYPED"

oproc:cCaption := ("Contando as integrações...")
ProcessMessages()

nQtdTit := 0
COUNT TO nQtdTit
QRYPED->(Dbgotop())
_npv:=1

If QRYPED->(!EOF())

  DO While QRYPED->(!EOF())

	//Atualiza régua
	oproc:cCaption := ("Processando integração... ["+ StrZero(_npv,6) +"] de ["+ StrZero(nQtdTit,6) +"]")
    _npv++
	ProcessMessages()

	_cstatus := "OUTROS"

	If ALLTRIM(QRYPED->ZZE_STATUS) == '1'
		_cstatus := "PROCESSADO"
	ElseIf ALLTRIM(QRYPED->ZZE_STATUS) == ''
		_cstatus := "PENDENTE"
	ElseIf ALLTRIM(QRYPED->ZZE_STATUS) == '6'
		_cstatus := "FALTA SALDO"
	ElseIf ALLTRIM(QRYPED->ZZE_STATUS) == '2'
		_cstatus := "FALHA ESTORNO"
	Endif

	cMovPrd		:= GetMv("MGF_TAP02E",,"01/")	// Apontamento de Produção

	If QRYPED->ZZE_TPMOV $ (cMovPrd)

		_ctipo := "PRODUÇÃO"

	else

		_ctipo := "CONSUMO"	

	Endif

	If ALLTRIM(QRYPED->ZZE_ACAO) == '1'

		_ctotsd3 := padl(alltrim(transform(QRYPED->SD3QT,"@E 999,999.999")),10)

	else

		_ctotsd3 := "N/D"

	Endif

    Reclock("TRBF",.T.)
  	TRBF->TRBF_FILIA	:= alltrim(QRYPED->ZZE_FILIAL) + " - " + ALLTRIM(FWLOADSM0()[ASCAN(FWLoadSM0(), { |X| X[2] = alltrim(QRYPED->ZZE_FILIAL)})][7])
	TRBF->TRBF_ACAO		:= ALLTRIM(QRYPED->ZZE_ACAO) +  " - " + IIF(ALLTRIM(QRYPED->ZZE_ACAO) = '1',"INTEGRAÇÃO DE " + _ctipo,'ESTORNO DE ' + _CTIPO)
	TRBF->TRBF_OPTAU	:= QRYPED->ZZE_OPTAUR
	TRBF->TRBF_CODIG	:= alltrim(QRYPED->ZZE_COD) + " - " + alltrim(POSICIONE("SB1",1,"      "+PADR(ALLTRIM(QRYPED->ZZE_COD),15),'B1_DESC'))
	TRBF->TRBF_DESCE	:= QRYPED->ZZE_DESCER
	TRBF->TRBF_STATU	:= ALLTRIM(QRYPED->ZZE_STATUS) + " - " + _cstatus
	TRBF->TRBF_ZZEQT	:= padl(alltrim(transform(QRYPED->ZZEQT,"@E 999,999.999")),10)
	TRBF->TRBF_SD3QT	:= _CTOTSD3
	TRBF->TRBF_SD3LT    := alltrim(QRYPED->ZZE_PEDLOT)
	

    QRYPED->( DBSkip() )
	
  EndDo

Else

	//Inclui um registro vazio pra registrar a op e filial escolhida
	 Reclock("TRBF",.T.)
	 TRBF->TRBF_FILIA := alltrim(MV_PAR01)
	 TRBF->TRBF_OPTAU := ALLTRIM(MV_PAR02)
	 TRBF->(msunlock())

Endif

QRYPED->( DBCloseArea())

TRBF->(DbGotop())

Return



/*/
=============================================================================
{Protheus.doc} MGTAP17Legenda
Tela de significado de legendas
@author
Josué Danich
@since
10/03/2020
/*/
STATIC Function MGTAP17Legenda()
Local aLegenda := {}

aAdd(aLegenda, {"BR_VERMELHO"   ,"ERRO ESTORNO DE INTEGRAÇÃO"})
aAdd(aLegenda, {"BR_AMARELO"   	,"INTEGRAÇÃO PENDENTE DE PROCESSAMENTO"})
aAdd(aLegenda, {"BR_VERDE"		,"INTEGRAÇÃO PROCESSADA"})
aAdd(aLegenda, {"BR_PRETO"		,"INTEGRAÇÃO PENDENTE POR FALTA DE ESTOQUE"})
aAdd(aLegenda, {"BR_AZUL"		,"OUTROS"})

BrwLegenda("Legenda","Legenda",aLegenda)

Return .T.

/*/
=============================================================================
{Protheus.doc} MGTAP17C
Chamada de itens do menu
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGTAP17C(_nopc)

Local oproc


Do Case

Case _nopc == 1 
	//Atualizar
	fwmsgrun(,{ || MGTAP17AT() }, "Aguarde...","Carregando dados...")

Case _nopc == 2
	//Xml Geral
	fwmsgrun(,{ || MGTAP17G() }, "Aguarde...","Carregando dados...")
	
Case _nopc == 3
	//Filtro
	fwmsgrun(,{ || MGTAP17F() }, "Aguarde...","Carregando dados...")
	
Case _nopc == 4
	//Visualizar OP
	fwmsgrun(,{ || MGTAP17PPV() }, "Aguarde...","Carregando dados...")

Case _nopc == 5
	//Reprocessa OP
	fwmsgrun(,{ || MGTAP17VP() }, "Aguarde...","Carregando dados...")

Case _nopc == 6
	//Integracao manual
	fwmsgrun(,{ || MGFTAP17RE() }, "Aguarde...","Carregando dados...")
	
Case _nopc == 11
	//Legenda
	fwmsgrun(,{ || MGTAP17Legenda() }, "Aguarde...","Carregando dados...")

	
Otherwise
	u_MGFmsg("Função em Desenvolvimento","Atenção",,1)
	
EndCase

Return

/*/
=============================================================================
{Protheus.doc} MGTAP17PPV
Visualiza OP
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGTAP17PPV()

Local _aheader := {}
Local _acols := {}

//Carrega integrações da OP

_cstatusq := SUBSTR(alltrim(TRBF->TRBF_STATU),1,1)
_cdescer := alltrim(TRBF->TRBF_DESCE)

If _cstatusq == "-"
	_cstatusq := " "
Endif

If _cdescer == ""
	_cdescer := " "
Endif


_cquery := " SELECT ZZE_IDTAUR,zze_filial,zze_acao,zze_optaur,zze_cod,zze_tpop,zze_tpmov,zze_descer,zze_quant ,zze_status,zze_chaveu,ZZE_CHAVEA "
_cquery += " from zze010 zze where zze.d_e_l_e_t_ <> '*' "
_cquery += " and zze_filial = '" + SUBSTR(alltrim(TRBF->TRBF_FILIA),1,6)  +  "' and zze_optaur = '" + alltrim(TRBF->TRBF_OPTAU) +  "'"
_cquery += " and zze_tpmov <> '04' "
_cquery += " and zze_cod = '" + SUBSTR(alltrim(TRBF->TRBF_CODIG),1,6)  +  "' and zze_acao = '" + SUBSTR(alltrim(TRBF->TRBF_ACAO),1,1) +  "'"
_cquery += " and zze_status = '" + _CSTATUSQ + "' and zze_descer = '" + _cdescer  + "' "
_cquery += " order by ZZE_COD,zze_acao,zze_tpop,zze_tpmov,zze_chaveu "


If Select("QRYPED2") > 0
	QRYPED2->(DbCloseArea())
EndIf

TCQUERY _cquery NEW ALIAS "QRYPED2"

If QRYPED2->(EOF())

	u_MGFmsg("Não foram encontrados registros de integração!","Atenção",,1)
	RETURN

Endif

//Carrega array
DO While QRYPED2->(!EOF())

	_cstatus := "OUTROS"

	If ALLTRIM(QRYPED2->ZZE_STATUS) == '1'
		_cstatus := "PROCESSADO"
	ElseIf ALLTRIM(QRYPED2->ZZE_STATUS) == ''
		_cstatus := "PENDENTE"
	ElseIf ALLTRIM(QRYPED2->ZZE_STATUS) == '6'
		_cstatus := "FALTA SALDO"
	ElseIf ALLTRIM(QRYPED2->ZZE_STATUS) == '2'
		_cstatus := "FALHA ESTORNO"
	Endif

	cMovPrd		:= GetMv("MGF_TAP02E",,"01/")	// Apontamento de Produção

	If QRYPED2->ZZE_TPMOV $ (cMovPrd )

		_ctipo := "PRODUÇÃO"

	else

		_ctipo := "CONSUMO"	

	Endif

	aadd(_acols,{	alltrim(QRYPED2->ZZE_FILIAL) + " - " + ALLTRIM(FWLOADSM0()[ASCAN(FWLoadSM0(), { |X| X[2] = alltrim(QRYPED2->ZZE_FILIAL)})][7]),;
					ALLTRIM(QRYPED2->ZZE_ACAO) +  " - " + IIF(ALLTRIM(QRYPED2->ZZE_ACAO) = '1',"INTEGRAÇÃO DE " + _CTIPO,'ESTORNO DE ' +  _CTIPO),;
					alltrim(QRYPED2->ZZE_TPOP),;
					alltrim(QRYPED2->ZZE_TPMOV),;
					alltrim(QRYPED2->ZZE_OPTAUR),;
					alltrim(QRYPED2->ZZE_COD) + " - " + alltrim(POSICIONE("SB1",1,"      "+PADR(ALLTRIM(QRYPED2->ZZE_COD),15),'B1_DESC')),;
					ALLTRIM(QRYPED2->ZZE_STATUS) + " - " + _cstatus,;
					ALLTRIM(QRYPED2->ZZE_DESCER),;
					padl(alltrim(transform(QRYPED2->ZZE_QUANT,"@E 999,999.999")),10),;
					ALLTRIM(QRYPED2->ZZE_CHAVEU),;
					ALLTRIM(QRYPED2->ZZE_CHAVEA),;
					ALLTRIM(QRYPED2->ZZE_IDTAUR)})


	QRYPED2->(Dbskip())

Enddo

//Mostra tela
   _aheader := {   "Filial      ",;
                    "Ação     ",;
					"Tipo OP",;
					"Tipo Movimento",;
                    "OP Taura   ",;
                    "Produto",;
                    "Status ",;
                    "OBS    ",;
                    "Qtde Integrada    ",;
 					"UUID",;
					"UUID Aglutinador",;
					"Id Taura/Origem"}

U_MGListBox( "OP " + alltrim(TRBF->TRBF_FILIA) + "/" + alltrim(TRBF->TRBF_OPTAU) , _aheader , _acols , .T. , 1 )


Return


/*/
=============================================================================
{Protheus.doc} MGTAP17EC
Exporta browse para o excel
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGTAP17EC(oproc)

Local _acolec := {}
Local _aheaderec := {}

AADD( aCampos , { "TRBF_FILIA"	, "" , "Filial"		        , PesqPict( "SA1" , "A1_FILIAL" )	  		} )
AADD( aCampos , { "TRBF_OPTAU"	, "" , "Op Taura"	    	, PesqPict( "SA1" , "A1_NOME" )			} )
AADD( aCampos , { "TRBF_DATAG"	, "" , "Data Geração"		, PesqPict( "SA1" , "A1_NOME" )	  		} )

	//Monta aheader
	aadd(_aheaderec,"Filial")
	aadd(_aheaderec,"Op Taura" )
	aadd(_aheaderec,"Data Geração" )
	
	//Monta acols
	_nposi := TRBF->(Recno())
	TRBF->(Dbgotop())

	Do while !(TRBF->(Eof()))

		aadd(_acolec, {	TRBF->TRBF_FILIA,;
    				TRBF->TRBF_OPTAU,;
    				TRBF->TRBF_DATAG } )


		TRBF->(Dbskip())

	Enddo

	//Apresenta itlist
	If len(_acolec) > 0

		U_MGListBox( "Integrações de OP Taura x Protheus" , _aheaderec , _acolec , .T. , 1 )

	Else

		u_MGFmsg("Nenhum registro selecionado!","Atenção",,1)

	Endif

	TRBF->(Dbgoto(_nposi))

Return

/*/
=============================================================================
{Protheus.doc} MGTAP17F
Carrega novo filtro
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGTAP17F(oproc)

If !Pergunte( cPerg , .T. )
	Return
EndIf
       
//================================================================================
// Cria o arquivo Temporario para insercao dos dados selecionados.
//================================================================================
FWMSGRUN( , {|oproc| _nControle := MGTAP17ARQ(oproc, .T.) }, "Aguarde!" , 'Lendo Dados das integrações...' )

Return

/*/
=============================================================================
{Protheus.doc} MGTAP17AT
Atualiza tela
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGTAP17AT(oproc)

//================================================================================
// Cria o arquivo Temporario para insercao dos dados selecionados.
//================================================================================
FWMSGRUN( , {|oproc| _nControle := MGTAP17ARQ(oproc, .T.) }, "Aguarde!" , 'Lendo Dados das integrações...' )

Return

/*/
=============================================================================
{Protheus.doc} MGTAP17CL
Retorna cor e legenda
@author
Josué Danich
@since
10/03/2020
/*/
User Function MGTAP17CL()

Local _ccor := "BR_AZUL"

If "PENDENTE" $ ALLTRIM(TRBF->TRBF_STATU) 
	_ccor := "BR_AMARELO"
ENDIF

If ALLTRIM(TRBF->TRBF_STATU) == "6 - FALTA SALDO"
	_ccor := "BR_PRETO"
ENDIF

If ALLTRIM(TRBF->TRBF_STATU) == "2 - FALHA ESTORNO"
	_ccor := "BR_VERMELHO"
ENDIF

If ALLTRIM(TRBF->TRBF_STATU) == "1 - PROCESSADO"
	_ccor := "BR_VERDE"
ENDIF

Return _ccor

/*/
=============================================================================
{Protheus.doc} MGTAP17CL
Reprocessamento de OP
@author
Josué Danich
@since
26/06/2020
/*/

Static Function MGTAP17VP()

Local oproc

If !(ALLTRIM(TRBF->TRBF_STATU) == "2 - FALHA ESTORNO" .OR. ALLTRIM(TRBF->TRBF_STATU) == "6 - FALTA SALDO")

	u_MGFmsg("Reprocessamento só pode ser realizado para integrações em status de falha de estorno ou de falha de saldo!","Atenção",,1)
	Return

ENDIF

If (ALLTRIM(TRBF->TRBF_STATU)) == "2 - FALHA ESTORNO"

			_lcontinua := u_MGFmsg("Deseja continuar com reprocessamento do estorno para integração do produto " + SUBSTR(alltrim(TRBF->TRBF_CODIG),1,6) + ;
					" para OP Taura " + alltrim(TRBF->TRBF_OPTAU) + "?",;
				"Atenção",,1,2,2)

		If _lcontinua

			fwmsgrun(,{ |oproc| MGFTP17K(oproc)}, "Aguarde...","Iniciando estorno...")
			u_MGFmsg("Reprocessamento completado!","Atenção",,1)
			fwmsgrun(,{ || MGTAP17AT() }, "Aguarde...","Carregando dados...")
		
		else
			
			u_MGFmsg("Processo cancelado pelo usuário!","Atenção",,1)
			Return

		Endif

ENDIF

If (ALLTRIM(TRBF->TRBF_STATU)) == "6 - FALTA SALDO"

	//Carrega saldo do produto
	SB2->(Dbsetorder(1)) //B2_FILIAL+B2_COD+B2_LOCAL

	If SB2->(Dbseek(SUBSTR(alltrim(TRBF->TRBF_FILIA),1,6)+PADR(SUBSTR(alltrim(TRBF->TRBF_CODIG),1,6),15)+'05'))
		_CESTOQUE := transform(SB2->B2_QATU,"@E 999,999,999.999")
		_nestoque := SB2->B2_QATU
	else
		_cestoque := "0.000"
		_nestoque := 0
	ENDIF

	If _nestoque < superval(STRTRAN(TRBF->TRBF_ZZEQT,".",""))

		u_MGFmsg("Reprocessamento de falta de saldo só pode ser realizado com saldo de estoque suficiente!",;
				"Atenção",;
				"Contate o setor de custos local para análise do saldo de estoque do produto " + SUBSTR(alltrim(TRBF->TRBF_CODIG),1,6) +":"+;
				chr(10)+chr(13) + chr(10)+chr(13) + "Saldo disponível: " + _cestoque + " kg" + ;
				chr(10)+chr(13) + "Consumo necessário: " + alltrim(TRBF->TRBF_ZZEQT) + " kg",1)

		RETURN

	else

		_lcontinua := u_MGFmsg("Deseja continuar com reprocessamento do produto " + SUBSTR(alltrim(TRBF->TRBF_CODIG),1,6) + ;
					" para OP Taura " + alltrim(TRBF->TRBF_OPTAU) + "?",;
				"Atenção",;
				"Existe saldo para o reprocessamento: " + SUBSTR(alltrim(TRBF->TRBF_CODIG),1,6) +;
				chr(10)+chr(13) + chr(10)+chr(13) + "Saldo disponível: " + _cestoque + " kg" + ;
				chr(10)+chr(13) + "Consumo necessário: " + alltrim(TRBF->TRBF_ZZEQT) + " kg",1,2,2)

		If _lcontinua

			MGFTP17T()
			u_MGFmsg("Reprocessamento completado!","Atenção",,1)
			fwmsgrun(,{ || MGTAP17AT() }, "Aguarde...","Carregando dados...")
		
		else
			
			u_MGFmsg("Processo cancelado pelo usuário!","Atenção",,1)
			Return

		Endif

	Endif

ENDIF


//-----------------------------------------------------------------------------------------------------------
/*/{Protheus.doc}MGFTP17T - Movimentos Internos (Mata240) - Requisição para OP (Consumo)  
@author  Atilio Amarilla
@since 08/11/2016
*/
Static Function MGFTP17T()

Local _nni := 0
Local _lretloc := .T.
Local _carealoc := GetNextAlias()
Local _ntot := 0
Local _cultimo := ""

BEGIN SEQUENCE

_cstatusq := SUBSTR(alltrim(TRBF->TRBF_STATU),1,1)
_cdescer := alltrim(TRBF->TRBF_DESCE)

If _cstatusq == "-"
	_cstatusq := " "
Endif

If _cdescer == ""
	_cdescer := " "
Endif


cQryInc := "SELECT ZZE_ID, ZZE_FILIAL, ZZE_GERACA, ZZE_EMISSA, ZZE_TPOP, ZZE_TPMOV, ZZE_CODPA, ZZE_COD, ZZE_LOTECT, ZZE_DTVALI, "+CRLF
cQryInc += "		ZZE_QUANT, ZZE_QTDPCS, ZZE_QTDCXS, ZZE_LOCAL, ZZE_OPTAUR,ZZE_CHAVEU, ZZE.R_E_C_N_O_ RECNO "+CRLF
cQryInc += "FROM "+RetSqlName("ZZE")+" ZZE "+CRLF
cQryInc += "WHERE ZZE.D_E_L_E_T_ = ' ' "+CRLF
cQryInc += " and zze_filial = '" + SUBSTR(alltrim(TRBF->TRBF_FILIA),1,6)  +  "' and zze_optaur = '" + alltrim(TRBF->TRBF_OPTAU) +  "'"
cQryInc += " and zze_cod = '" + SUBSTR(alltrim(TRBF->TRBF_CODIG),1,6)  +  "' and zze_acao = '" + SUBSTR(alltrim(TRBF->TRBF_ACAO),1,1) +  "'"
cQryInc += " and zze_status = '" + _CSTATUSQ + "' and zze_descer = '" + _cdescer  + "' 
cQryInc += "	AND (ZZE_STATUS = '6') "+CRLF
cQryInc += " and zze_tpmov <> '04' "
cQryInc += "ORDER BY ZZE_TPMOV DESC, ZZE_OPTAUR,ZZE_CODPA,ZZE_COD,ZZE_ID "+CRLF 

If Select(_carealoc) > 0
	(_carealoc)->(Dbclosearea())
Endif

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQryInc), _carealoc,.T.,.F.)
dbSelectArea(_carealoc)
(_carealoc)->(DbGoTop())

cCodPA	 := (_carealoc)->ZZE_CODPA
cOPTaura := (_carealoc)->ZZE_OPTAUR
_cultimo	:= (_carealoc)->ZZE_FILIAL+(_carealoc)->ZZE_TPMOV+(_carealoc)->ZZE_OPTAUR+(_carealoc)->ZZE_CODPA+(_carealoc)->ZZE_COD
	
If (_carealoc)->(!Eof())

	_ntot := 1

	While (_carealoc)->(!Eof())
		If _cultimo != (_carealoc)->ZZE_FILIAL+(_carealoc)->ZZE_TPMOV+(_carealoc)->ZZE_OPTAUR+(_carealoc)->ZZE_CODPA+(_carealoc)->ZZE_COD
			_ntot++
			_cultimo	:= (_carealoc)->ZZE_FILIAL+(_carealoc)->ZZE_TPMOV+(_carealoc)->ZZE_OPTAUR+(_carealoc)->ZZE_CODPA+(_carealoc)->ZZE_COD
		Endif
		(_carealoc)->(DbSkip())	
	Enddo

	(_carealoc)->(DbGoTop())

Endif

While (_carealoc)->(!Eof()) .and. _lretloc

	BEGIN TRANSACTION

	aRotThread	:= {}

	While !(_carealoc)->( eof() ) .And. Len( aRotThread  ) < 1 .and. _lretloc
				
		_nni++
		_coptaura := alltrim((_carealoc)->ZZE_OPTAUR)
		_ccodpa := alltrim((_carealoc)->ZZE_CODPA)
		_cchaveu := (_carealoc)->ZZE_CHAVEU
		_nrecno := (_carealoc)->RECNO

		U_MFCONOUT('Executando movimento interno para ' + _coptaura + "/" + _ccodpa + " - " + strzero(_nni,6) + " de " + strzero(_ntot,6) + "...") 

		cTpOP	:= (_carealoc)->ZZE_TPOP
		cCodPA	 := Stuff( Space(TamSX3("B1_COD")[1])     , 1 , Len((_carealoc)->ZZE_CODPA) , (_carealoc)->ZZE_CODPA )
		cOPTaura := Stuff( Space(TamSX3("C2_ZOPTAUR")[1]) , 1 , Len((_carealoc)->ZZE_OPTAUR), (_carealoc)->ZZE_OPTAUR )
		SC2->( dbOrderNickName("OPTAURA") )
		cChave	:= (_carealoc)->ZZE_FILIAL+cOPTaura+cCodPA

		
		If SC2->( dbSeek( cChave ) )

			If !Empty( SC2->C2_DATRF )
				RecLock("SC2",.F.)
				SC2->C2_DATRF	:= CTOD("")
				SC2->( msUnlock() )
			EndIf

			If SC2->C2_PRODUTO == cCodPA
	
				SB1->( dbSeek( xFilial("SB1")+(_carealoc)->ZZE_COD ) )

				If !Empty( (_carealoc)->ZZE_LOCAL )
					cCodLoc	:= Stuff( Space(TamSX3("ZZE_LOCAL")[1]) , 1 , Len((_carealoc)->ZZE_LOCAL) , (_carealoc)->ZZE_LOCAL )
				Else
					cCodLoc	:= SB1->B1_LOCPAD
				EndIf

				cNumOrd	:= SC2->( C2_NUM+C2_ITEM+C2_SEQUEN )
				cNumDoc	:= MGFTP1702()

				If (_carealoc)->ZZE_TPMOV $ cMovDev
					IF Alltrim((_carealoc)->ZZE_TPMOV) == '05'
						cTM := cTMDev2
					Else
						cTM := cTMDev
					EndIF
				Else
					cTM := cTMReq
				EndIf

				cFilAnt		:= (_carealoc)->ZZE_FILIAL
				dDataBase	:= STOD( (_carealoc)->ZZE_EMISSA)

				aRotAuto	:= {}

				_nquant := 0
				_nqtdpcs := 0
				_nqtdcxs := 0
				_cultimo := (_carealoc)->ZZE_FILIAL+(_carealoc)->ZZE_TPMOV+(_carealoc)->ZZE_OPTAUR+(_carealoc)->ZZE_CODPA+(_carealoc)->ZZE_COD
				_cfilial := (_carealoc)->ZZE_FILIAL
				_clocal := (_carealoc)->ZZE_LOCAL  
				_demissao := STOD((_carealoc)->ZZE_EMISSA)
				_ctpop := (_carealoc)->ZZE_TPOP
				_coptaura := (_carealoc)->ZZE_OPTAUR
				_ctpmov := (_carealoc)->ZZE_TPMOV
				_ccodpa := (_carealoc)->ZZE_CODPA
				
				//Busca registros seguintes para aglutinar em uma D3
				Do while (_carealoc)->( !eof()) .and. (_carealoc)->ZZE_FILIAL+(_carealoc)->ZZE_TPMOV+(_carealoc)->ZZE_OPTAUR+(_carealoc)->ZZE_CODPA+(_carealoc)->ZZE_COD == _cultimo

					_nquant += (_carealoc)->ZZE_QUANT
					_nqtdpcs += (_carealoc)->ZZE_QTDPCS
					_nqtdcxs += (_carealoc)->ZZE_QTDCXS

					//Grava mesma chave de aglutinação em todos os registros
					ZZE->(Dbgoto((_carealoc)->RECNO))
					Reclock("ZZE",.F.)
					ZZE->ZZE_CHAVEA := _cchaveu
					ZZE->(Msunlock())

					(_carealoc)->( dbSkip() )

				Enddo
	

				aAdd( aRotAuto ,	{"D3_FILIAL"	, cFilAnt						,NIL} )
				aAdd( aRotAuto ,	{"D3_TM"		, cTM							,NIL} )
				aAdd( aRotAuto ,	{"D3_COD"		, SB1->B1_COD					,NIL} )
				aAdd( aRotAuto ,	{"D3_QUANT"		, _nquant		,NIL} )
				aAdd( aRotAuto ,	{"D3_ZQTDPCS"	, _nqtdpcs		,NIL} )
				aAdd( aRotAuto ,	{"D3_ZQTDCXS"	, _nqtdcxs		,NIL} )
				aAdd( aRotAuto ,	{"D3_OP"		, cNumOrd						,NIL} )
				aAdd( aRotAuto ,	{"D3_LOCAL"		, cCodLoc						,NIL} )
				aAdd( aRotAuto ,	{"D3_DOC"		, cNumDoc						,NIL} )
				aAdd( aRotAuto ,	{"D3_PARCTOT"	, "P"							,NIL} )
				aAdd( aRotAuto ,	{"D3_EMISSAO"	, _demissao,NIL} )
				aAdd( aRotAuto ,	{"D3_ZTIPO"		, _ctpop		,NIL} )

				If SB1->B1_LOCALIZ == "S"
					aAdd( aRotAuto ,	{"D3_LOCALIZ"	, cEndPad				,NIL} )
				EndIf

				aAdd( aRotAuto , {"D3_ZOPTAUR"	, _coptaura			,NIL} )
				aAdd( aRotAuto , {'__ZTPOP'		, _ctpop			,NIL} )
				aAdd( aRotAuto , {'__ZTPMOV'	, _ctpmov			,NIL} )
				aAdd( aRotAuto , {'__ZOPTAURA'	, _coptaura			,NIL} )
				aAdd( aRotAuto , {'__ZCODPA'	, _ccodpa			,NIL} )
				aAdd( aRotAuto , {'__UUID'		, _cchaveu			,NIL} )

				aAdd( aRotAuto , {'__ZLOCAL'	, _clocal			,NIL} )

				aAdd( aRotThread , aRotAuto )

			Else

				ZZE->( dbGoTo( (_carealoc)->RECNO ) )
				
				RecLock("ZZE",.F.)
				ZZE->ZZE_STATUS	:= "2"
				ZZE->ZZE_DESCER	:= "[MGFTAP02] PA "+AllTrim(cCodPA)+" diferente do PA da OP: "+AllTrim(SC2->C2_PRODUTO)+". Chave : "+cChave
				ZZE->ZZE_DTPROC	:=  Date() 
				ZZE->ZZE_HRPROC	:= Time()
				ZZE->( msUnlock() )
	
				U_MFCONOUT('OP não localizada ' + _coptaura + "/" + _ccodpa + " - " + strzero(_nni,6) + " de " + strzero(_ntot,6) + "...") 

			EndIf

		Else

			ZZE->( dbGoTo( (_carealoc)->RECNO ) )
				
			RecLock("ZZE",.F.)
			ZZE->ZZE_STATUS	:= "2"
			ZZE->ZZE_DESCER	:= "[MGFTAP02] OP não localizada. Chave : "+cChave
			ZZE->ZZE_DTPROC	:=  Date() 
			ZZE->ZZE_HRPROC	:= Time()
			ZZE->( msUnlock() )
		
			U_MFCONOUT('OP não localizada ' + _coptaura + "/" + alltrim((_carealoc)->ZZE_COD) + " - " + strzero(_nni,6) + " de " + strzero(_ntot,6) + "...") 

		EndIf

		If _nrecno == (_carealoc)->RECNO //Se não avançou de registro faz avanço agora
			(_carealoc)->(Dbskip())
		Endif

	EndDo

	If Len( aRotThread ) > 0 .and. _lretloc

		cFunTAP		:= "U_MGFTAP05"
		cOpc		:= "1"
		aParThread	:= { " " , " " , cIdProc , "" }
	
		_lretloc := U_MGFTAP05( {cOpc ,;							//01			
								 aRotThread ,;						//02
								 aParThread[1] ,;					//03
								 aParThread[2] ,;					//04
								 aParThread[3] ,;					//05
								 aParThread[4] ,;					//06
								 _cchaveu  ,;						//07
								 _nrecno  } )						//08
		
		If _lretloc
			U_MFCONOUT('Completado movimento interno para ' + alltrim(_coptaura) + "/" + alltrim(_ccodpa) + " - " + strzero(_nni,6) + " de " + strzero(_ntot,6) + "...") 
		Else
			Disarmtransaction() 
			_lretloc := .F.
			U_MFCONOUT('Falha de integridade dos dados...')
		Endif
		aRotThread := {}

	EndIf

	END TRANSACTION

EndDo

dbSelectArea(_carealoc)
dbCloseArea()

END SEQUENCE


Return


//-------------------------------------------------------------------------------------
/*/{Protheus.doc}MGFTP17K - Estorno de Movimentos Internos/Produção (Mata240/Mata250) 
@author  Atilio Amarilla
@since 08/11/2016
*/
Static Function MGFTP17K(oproc)

Local _lretloc := .T.
Local _carealoc := GetNextAlias()
Local _nni := 1
Local _ntot := 0

BEGIN SEQUENCE

_cstatusq := SUBSTR(alltrim(TRBF->TRBF_STATU),1,1)
_cdescer := alltrim(TRBF->TRBF_DESCE)

If _cstatusq == "-"
	_cstatusq := " "
Endif

If _cdescer == ""
	_cdescer := " "
Endif

cQryInc := "SELECT ZZE_ID, ZZE_FILIAL, ZZE_GERACA, ZZE_TPOP, ZZE_TPMOV, ZZE_CODPA, "+CRLF
cQryInc += "		ZZE_COD, EXC.ZZE_LOTECT, EXC.ZZE_DTVALI, EXC.ZZE_QUANT ZZE_QUANT, EXC.ZZE_LOCAL, ZZE_OPTAUR, "+CRLF
cQryInc += "		EXC.ZZE_QTDPCS ZZE_QTDPCS, EXC.ZZE_QTDCXS ZZE_QTDCXS, R_E_C_N_O_ RECNO, ZZE_CHAVEU  "+CRLF
cQryInc += "FROM "+RetSqlName("ZZE")+" EXC "+CRLF
cQryInc += "WHERE EXC.D_E_L_E_T_ = ' ' "+CRLF
cQryInc += "	AND EXC.ZZE_ACAO = '2' "+CRLF
cQryInc += " and zze_filial = '" + SUBSTR(alltrim(TRBF->TRBF_FILIA),1,6)  +  "' and zze_optaur = '" + alltrim(TRBF->TRBF_OPTAU) +  "'"
cQryInc += " and zze_cod = '" + SUBSTR(alltrim(TRBF->TRBF_CODIG),1,6)  +  "' and zze_acao = '" + SUBSTR(alltrim(TRBF->TRBF_ACAO),1,1) +  "'"
cQryInc += " and zze_status = '" + _CSTATUSQ + "' "
cQryInc += "	AND (ZZE_STATUS = '2') "+CRLF
cQryInc += " and zze_tpmov <> '04' "
cQryInc += "ORDER BY ZZE_TPMOV DESC, ZZE_COD, ZZE_ID "+CRLF 

If Select(_carealoc) > 0
	(_carealoc)->(Dbclosearea())
Endif

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQryInc), _carealoc,.T.,.F.)
dbSelectArea(_carealoc)
(_carealoc)->(DbGoTop())

If (_carealoc)->(!Eof())

	While (_carealoc)->(!Eof())
		_ntot++
		(_carealoc)->(Dbskip())
	Enddo

	(_carealoc)->(DbGoTop())

Endif

While (_carealoc)->(!Eof()) .and. _lretloc

	aRotThread	:= {}

	oproc:ccaption := ('Executando estorno de movimento ' + strzero(_nni,6) + " de " + strzero(_ntot,6) + "...") 
	processmessages()

	SB1->( dbSeek( xFilial("SB1")+(_carealoc)->ZZE_COD ) )
	cIdSeq	:= Soma1(cIdSeq)
			
				
	aAdd( aRotThread , {	(_carealoc)->ZZE_FILIAL,	;
									(_carealoc)->ZZE_GERACA,	;
									(_carealoc)->ZZE_TPOP,		;
									(_carealoc)->ZZE_TPMOV,	;
									(_carealoc)->ZZE_CODPA,	;
									(_carealoc)->ZZE_COD,		;
									(_carealoc)->ZZE_LOTECT,	;
									(_carealoc)->ZZE_DTVALI,	;
									(_carealoc)->ZZE_QUANT,	;	
									(_carealoc)->ZZE_LOCAL,	;
									(_carealoc)->ZZE_OPTAUR,	;
									cIdProc,					;
									cIdSeq,						;
									(_carealoc)->ZZE_QTDPCS,	;
									(_carealoc)->ZZE_QTDCXS	;
									}	)


	If Len( aRotThread ) > 0 .and. _lretloc
				
		cFunTAP		:= "U_MGFTAP19"
		cOpc		:= "1"
		aParThread	:= { " " , " " , cIdProc , "" }
		_lretloc := U_MGFTAP19( {aRotThread , aParThread[3],(_carealoc)->ZZE_CHAVEU,(_carealoc)->RECNO} )

		If !_lretloc
			U_MFCONOUT('Falha de integridade dos dados...')
			Disarmtransaction()
			BREAK
		Endif
			
		aRotThread := {}

	EndIf

	oproc:ccaption := ('Completou estorno de movimento '  + strzero(_nni,6) + " de " + strzero(_ntot,6) + "...") 
	processmessages()
	_nni++
	(_carealoc)->( dbSkip() )

EndDo

dbSelectArea(_carealoc)
dbCloseArea()

END SEQUENCE


Return _lretloc

//-----------------------------------------------------------------------------------
/*/{Protheus.doc}MGFTP1702 - Retorna próximo D3_DOC
@author  Atilio Amarilla
@since 08/11/2016
*/
Static Function MGFTP1702() 

Local cNumDoc	:= ""
		
While Empty(cNumDoc) .Or. SD3->( dbSeek( xFilial("SD3")+cNumDoc ) ) 
	cNumDoc	:= GetSXENum("SD3","D3_DOC")
	ConfirmSX8()
EndDo

Return( cNumDoc )

/*/
=============================================================================
{Protheus.doc} MGTAP17G
Exporta todas as integracoes da OP
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGTAP17G()

Local _aheader := {}
Local _acols := {}

//Carrega integrações da OP

_cstatusq := SUBSTR(alltrim(TRBF->TRBF_STATU),1,1)
_cdescer := alltrim(TRBF->TRBF_DESCE)

If _cstatusq == "-"
	_cstatusq := " "
Endif

If _cdescer == ""
	_cdescer := " "
Endif


_cquery := " SELECT zze_filial,zze_acao,zze_optaur,zze_cod,zze_tpop,zze_tpmov,zze_descer,zze_quant ,zze_status,zze_chaveu,ZZE_CHAVEA "
_cquery += " from zze010 zze where zze.d_e_l_e_t_ <> '*' "
_cquery += " and zze_filial = '" + SUBSTR(alltrim(TRBF->TRBF_FILIA),1,6)  +  "' and zze_optaur = '" + alltrim(TRBF->TRBF_OPTAU) +  "'"
_cquery += " and zze_tpmov <> '04' "
_cquery += " order by ZZE_COD,zze_acao,zze_tpop,zze_tpmov,zze_chaveu "


If Select("QRYPED2") > 0
	QRYPED2->(DbCloseArea())
EndIf

TCQUERY _cquery NEW ALIAS "QRYPED2"

If QRYPED2->(EOF())

	u_MGFmsg("Não foram encontrados registros de integração!","Atenção",,1)
	RETURN

Endif

//Carrega array
DO While QRYPED2->(!EOF())

	_cstatus := "OUTROS"

	If ALLTRIM(QRYPED2->ZZE_STATUS) == '1'
		_cstatus := "PROCESSADO"
	ElseIf ALLTRIM(QRYPED2->ZZE_STATUS) == ''
		_cstatus := "PENDENTE"
	ElseIf ALLTRIM(QRYPED2->ZZE_STATUS) == '6'
		_cstatus := "FALTA SALDO"
	ElseIf ALLTRIM(QRYPED2->ZZE_STATUS) == '2'
		_cstatus := "FALHA ESTORNO"
	Endif

	cMovPrd		:= GetMv("MGF_TAP02E",,"01/")	// Apontamento de Produção

	If QRYPED2->ZZE_TPMOV $ (cMovPrd )

		_ctipo := "PRODUÇÃO"

	else

		_ctipo := "CONSUMO"	

	Endif

	aadd(_acols,{	alltrim(QRYPED2->ZZE_FILIAL) + " - " + ALLTRIM(FWLOADSM0()[ASCAN(FWLoadSM0(), { |X| X[2] = alltrim(QRYPED2->ZZE_FILIAL)})][7]),;
					ALLTRIM(QRYPED2->ZZE_ACAO) +  " - " + IIF(ALLTRIM(QRYPED2->ZZE_ACAO) = '1',"INTEGRAÇÃO DE " + _CTIPO,'ESTORNO DE ' +  _CTIPO),;
					alltrim(QRYPED2->ZZE_TPOP),;
					alltrim(QRYPED2->ZZE_TPMOV),;
					alltrim(QRYPED2->ZZE_OPTAUR),;
					alltrim(QRYPED2->ZZE_COD) + " - " + alltrim(POSICIONE("SB1",1,"      "+PADR(ALLTRIM(QRYPED2->ZZE_COD),15),'B1_DESC')),;
					ALLTRIM(QRYPED2->ZZE_STATUS) + " - " + _cstatus,;
					ALLTRIM(QRYPED2->ZZE_DESCER),;
					padl(alltrim(transform(QRYPED2->ZZE_QUANT,"@E 999,999.999")),10),;
					ALLTRIM(QRYPED2->ZZE_CHAVEU),;
					ALLTRIM(QRYPED2->ZZE_CHAVEA)})


	QRYPED2->(Dbskip())

Enddo

//Mostra tela
   _aheader := {   "Filial      ",;
                    "Ação     ",;
					"Tipo OP",;
					"Tipo Movimento",;
                    "OP Taura   ",;
                    "Produto",;
                    "Status ",;
                    "OBS    ",;
                    "Qtde Integrada    ",;
 					"UUID",;
					"UUID Aglutinador"}

U_MGListBox( "OP " + alltrim(TRBF->TRBF_FILIA) + "/" + alltrim(TRBF->TRBF_OPTAU) , _aheader , _acols , .T. , 1 )


Return


/*/
=============================================================================
{Protheus.doc} MGTAP17RE
Geração de integrações manuais
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGFTAP17RE()

Local oGet1		:= Nil
Local oGet2		:= Nil
Local oGet3		:= Nil
Local oDlg		:= Nil
Local cGet1		:= Space(40)
Local cGet2		:= Space(40)
Local cGet3		:= Space(40)
Local cComboBx1	:= ""
Local aComboBx1	:= { "Produção" , "Consumo","Estorno Produção","Estorno Consumo"  }
Local nOpca		:= 0
Local nI		:= 0

Private _cprod := ""
Private _nquant := 0

If !empty(MV_PAR03)
	CGET3 := alltrim(MV_PAR03)
Endif

Do while .T.

DEFINE MSDIALOG oDlg TITLE "Gerar movimento manual" FROM 178,181 TO 336,747 PIXEL

	@004,003 Say "Tipo :"	Size 212,009 OF oDlg PIXEL COLOR CLR_BLACK Picture "@!"
	@004,050 ComboBox	cComboBx1	Items aComboBx1 Size 213,010 OF oDlg PIXEL
	@020,003 Say "Produto :"		Size 212,009 OF oDlg PIXEL COLOR CLR_BLACK Picture "@!"
	@020,050 MsGet		oGet1		Var cGet1		Size 212,009 OF oDlg PIXEL COLOR CLR_BLACK Picture "@!"
	@036,003 Say "Quantidade :"		Size 212,009 OF oDlg PIXEL COLOR CLR_BLACK Picture "@!"
	@036,050 MsGet		oGet2		Var cGet2		Size 212,009 OF oDlg PIXEL COLOR CLR_BLACK Picture "@!"
	@052,003 Say "Lote :"		Size 212,009 OF oDlg PIXEL COLOR CLR_BLACK Picture "@!"
	@052,050 MsGet		oGet3		Var cGet3		Size 212,009 OF oDlg PIXEL COLOR CLR_BLACK Picture "@!"
	
	DEFINE SBUTTON FROM 068,200 TYPE 1 ENABLE ACTION ( nOpca := 1 , oDlg:End() ) OF oDlg
	DEFINE SBUTTON FROM 068,230 TYPE 2 ENABLE ACTION ( nOpca := 0 , oDlg:End() ) OF oDlg

ACTIVATE MSDIALOG oDlg CENTERED

If nOpca == 1

	//vALIDA PRODUTO E QUANTIDADE
	SB1->(Dbsetorder(1)) //b1_filial+b1_cod
	If EMPTY(alltrim(cGet1)) .OR. !(SB1->(Dbseek(xfilial("SB1")+alltrim(cGet1))))
		u_MGFmsg("Produto não encontrado!","Atenção",,1)
		Loop
	Else
		_cprod := alltrim(cGet1)
	Endif

	_cquant := alltrim(strtran(cGet2,",","."))
	_nquant := val(_cquant)

	If _nquant <= 0 .or. _nquant > 1000000
		u_MGFmsg("Quantidade inválida!","Atenção",,1)
		Loop
	Endif

	_lsai := .F.

	For nI := 1 To Len(aComboBx1)
	
		If cComboBx1 == aComboBx1[nI]
		
			_clote := " "

			If !empty(alltrim(cGet3))
				_clote := " e lote " + alltrim(cget3) + " "
			Endif

			//integração manual de produção
			If ni == 1

				_lcontinua := u_MGFmsg("Deseja continuar integração manual de " + ALLTRIM(transform(_nquant,"@E 999,999.999 kg")) + " de produção do produto " + alltrim(cGet1) + ;
					" para OP Taura " + SUBSTR(alltrim(TRBF->TRBF_FILIA),1,6)  +  "/" + alltrim(TRBF->TRBF_OPTAU) + _clote +  "?",;
				"Atenção",,1,2,2)

				If _lcontinua

					FWMSGRUN( , {|oproc| _nControle := MGTAP17PRD(SUBSTR(alltrim(TRBF->TRBF_FILIA),1,6),;
																		 alltrim(TRBF->TRBF_OPTAU),;
																		 _cprod,;
																		 _nquant,;
																		 Oproc,;
																		 alltrim(cget3))  }, "Aguarde!" , 'Processando integração manual...' )
					_lsai := .T.
					fwmsgrun(,{ || MGTAP17AT() }, "Aguarde...","Carregando dados...")

				Else

					u_MGFmsg("Processo cancelado!","Atenção",,1)

				Endif	

			Endif

			//integração manual de consumo
			If ni == 2

					_lcontinua := u_MGFmsg("Deseja continuar integração manual de " + ALLTRIM(transform(_nquant,"@E 999,999.999 kg")) + " de consumo do produto " + alltrim(cGet1) + ;
					" para OP Taura " + SUBSTR(alltrim(TRBF->TRBF_FILIA),1,6)  +  "/" + alltrim(TRBF->TRBF_OPTAU) + _clote + "?",;
				"Atenção",,1,2,2)

				If _lcontinua

					FWMSGRUN( , {|oproc| _nControle := MGTAP17CON(SUBSTR(alltrim(TRBF->TRBF_FILIA),1,6),;
																		 alltrim(TRBF->TRBF_OPTAU),;
																		 _cprod,;
																		 _nquant,;
																		 Oproc,;
																		 alltrim(cget3))  }, "Aguarde!" , 'Processando integração manual...' )
					_lsai := .T.
					fwmsgrun(,{ || MGTAP17AT() }, "Aguarde...","Carregando dados...")

				Else

					u_MGFmsg("Processo cancelado!","Atenção",,1)

				Endif	
			Endif

			//ESTORNO DE PRODUCAO/CONSUMO
			If ni == 3 .OR. ni == 4

				_ctipo := iif(ni==3,"produção","consumo")

				_lcontinua := u_MGFmsg("Deseja continuar integração manual de " + ALLTRIM(transform(_nquant,"@E 999,999.999 kg"));
						 + " de estorno de " + _ctipo + " do produto " + alltrim(cGet1) + ;
					" para OP Taura " + SUBSTR(alltrim(TRBF->TRBF_FILIA),1,6)  +  "/" + alltrim(TRBF->TRBF_OPTAU) + _clote + "?",;
				"Atenção",,1,2,2)

				If _lcontinua

					FWMSGRUN( , {|oproc| _nControle := MGFTP17EST(SUBSTR(alltrim(TRBF->TRBF_FILIA),1,6),;
																		 alltrim(TRBF->TRBF_OPTAU),;
																		 _cprod,;
																		 _nquant,;
																		 Oproc,;
																		 iif(ni==3,1,2),;
																		 alltrim(cget3) ) }, "Aguarde!" , 'Processando estorno manual...' )
					_lsai := .T.
					fwmsgrun(,{ || MGTAP17AT() }, "Aguarde...","Carregando dados...")

				Else

					u_MGFmsg("Processo cancelado!","Atenção",,1)

				Endif	

			Endif
			
		EndIf
		
	Next nI

	If _lsai
		Exit
	Endif

Else

	u_MGFmsg("Processo cancelado!","Atenção",,1)
	Exit

EndIf


Enddo

Return()

/*/
=============================================================================
{Protheus.doc} MGTAP17PRD
Integração manual de produção
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGTAP17PRD(_cfilial,_cop,_cprod,_nquant,OPROC,_clote)

Local anumord := {}
Private cTMPrd		:= GetMv("MGF_TAP02B",,"111")

BEGIN TRANSACTION

//Grava ZZE
RecLock("ZZE",.T.)
ZZE->ZZE_FILIAL	:=	_cfilial
ZZE->ZZE_ID		:=	Subs(DtoS(Date()),3,6)+StrZero( Recno() , Len(ZZE->ZZE_ID)-6 )
ZZE->ZZE_IDTAUR	:=	"MANUAL - " + ALLTRIM(CUSERNAME)
ZZE->ZZE_ACAO	:=	'1'
ZZE->ZZE_OPTAUR	:=	_cop
ZZE->ZZE_TPOP	:=	'01'
ZZE->ZZE_TPMOV	:=	'01'
ZZE->ZZE_GERACA	:=	DTOS(date())
ZZE->ZZE_EMISSA	:=	DTOS(date())
ZZE->ZZE_HORA	:=	time()
ZZE->ZZE_CODPA	:=	_cprod
ZZE->ZZE_COD	:=	_cprod
ZZE->ZZE_QUANT	:=	_nquant
ZZE->ZZE_QTDPCS	:=	0
ZZE->ZZE_QTDCXS	:=	0
ZZE->ZZE_PEDLOT	:=	alltrim(_clote)
ZZE->ZZE_LOCAL	:=	'05'
ZZE->ZZE_CHAVEU :=	FWUUIDV4()
ZZE->ZZE_CHAVEA :=	ZZE->ZZE_CHAVEU
ZZE->ZZE_DTREC  := Date()
ZZE->ZZE_HRREC  := Time()
ZZE->ZZE_STATUS := 'M'

ZZE->( msUnlock() )

_nrecno := ZZE->(Recno())

cCodPA	 := Stuff( Space(TamSX3("B1_COD")[1])     , 1 , Len(ZZE->ZZE_CODPA) , ZZE->ZZE_CODPA )
cOPTaura := Stuff( Space(TamSX3("C2_ZOPTAUR")[1]) , 1 , Len(ZZE->ZZE_OPTAUR), ZZE->ZZE_OPTAUR )
SC2->( dbOrderNickName("OPTAURA") )
cChave	:= ZZE->ZZE_FILIAL+cOPTaura+cCodPA


If SC2->( !dbSeek( cChave ) )

	//Cria OP se necessário
	oproc:ccaption := ('Abrindo OP ' + alltrim(ZZE->ZZE_OPTAUR) + "/" + alltrim(ZZE->ZZE_CODPA)  + "...")
	ProcessMessages()

	aRotThread	:= {}	
	aRotAuto	:= {}

	//Define sequencia, se op tem mais de 6 caracteres coloca caracteres adicionais no c2_sequen
	If len(alltrim(cOPTaura)) <= 6
		_cc2seque := '001'
	Else
		_cc2seque := padl(substr(alltrim(cOPTaura),7,3),3,"0")
	Endif

	_citem := "01"

	//Define item a ser usado
	SC2->(Dbsetorder(1)) //C2_FILIAL+C2_NUM
	If SC2->( dbSeek( _cfilial+ALLTRIM(cOPTaura) ) )

		Do while SC2->C2_FILIAL + SC2->C2_NUM == _cfilial+alltrim(cOPTaura)

			If SC2->C2_ITEM >= _citem
				If SC2->C2_ITEM < '10'
					_citem := strzero(val(SC2->C2_ITEM)+1,2)
				Else
					_citem := soma1(SC2->C2_ITEM)
				Endif
			Endif

		SC2->(Dbskip())

		Enddo

	Endif
	
	aAdd( aRotAuto , {'C2_FILIAL'	, ZZE->ZZE_FILIAL			,NIL} )
	aAdd( aRotAuto , {'C2_PRODUTO'	, ZZE->ZZE_CODPA			,NIL} )
	aAdd( aRotAuto , {'C2_ITEM'		, _citem					,NIL} )
	aAdd( aRotAuto , {'C2_SEQUEN'	, _cc2seque					,NIL} )
	aAdd( aRotAuto , {'C2_NUM'		, alltrim(cOPTaura) 		,NIL} )
	aAdd( aRotAuto , {'C2_QUANT'	, ZZE->ZZE_QUANT			,NIL} )
	aAdd( aRotAuto , {'C2_DATPRI'	, STOD(ZZE->ZZE_GERACA)-3	,NIL} )
	aAdd( aRotAuto , {'C2_DATPRF'	, STOD(ZZE->ZZE_GERACA)		,NIL} )
	aAdd( aRotAuto , {'C2_ZTIPO'	, ZZE->ZZE_TPOP				,NIL} )
	aAdd( aRotAuto , {'C2_ZOPTAUR'	, alltrim(ZZE->ZZE_OPTAUR)	,NIL} )
	aAdd( aRotAuto , {'AUTEXPLODE'	, "N"						,NIL} )
	aAdd( aRotAuto , {'__ZTPOP'		, ZZE->ZZE_TPOP				,NIL} )
	aAdd( aRotThread , aRotAuto )
	
	
	cFunTAP		:= "U_MGFTAP03"
	cOpc		:= "1"
	aParThread	:= { " " , " " , cIdProc , "" }

	IF Len(aRotThread) > 0 
		_lretloc := U_MGFTAP03( {	cOpc ,;						//01
							aRotThread ,; 				//02
							aParThread[1] ,; 			//03
							aParThread[2] ,; 			//04
							aParThread[3] ,; 			//05
							aParThread[4] ,;			//06
							ZZE->ZZE_CHAVEU,;	//07
							ZZE->(RECNO())  	} )	//08
		If _lretloc
			oproc:ccaption := ('Abriu OP ' + SC2->( C2_NUM+C2_ITEM+C2_SEQUEN )  + "...")
			ProcessMessages()
		Else
			U_MFCONOUT('Falha de integridade dos dados...')
			Disarmtransaction()
			u_MGFmsg("Falha na abertura da OP para o movimento manual, operação não realizada!","Atenção",,1)
			Return
		Endif
	EndIF
Endif

cNumOrd	:= SC2->( C2_NUM+C2_ITEM+C2_SEQUEN )
cNumDoc	:= MGFTP1702()

//Chama processamento
aRotThread	:= {}	
aRotauto := {}
aAdd( aRotAuto ,	{"D3_FILIAL"	, ZZE->ZZE_FILIAL		,NIL} )
aAdd( aRotAuto ,	{"D3_TM"		, cTMPrd							,NIL} )
aAdd( aRotAuto ,	{"D3_COD"		, ZZE->ZZE_COD					,NIL} )
aAdd( aRotAuto ,	{"D3_QUANT"		, ZZE->ZZE_QUANT		,NIL} )
aAdd( aRotAuto ,	{"D3_ZQTDPCS"	, 0		,NIL} )
aAdd( aRotAuto ,	{"D3_ZQTDCXS"	, 0		,NIL} )
aAdd( aRotAuto ,	{"D3_OP"		, cNumOrd						,NIL} )
aAdd( aRotAuto ,	{"D3_LOCAL"		, ZZE->ZZE_LOCAL,NIL} )
AAdd( aRotAuto ,	{"D3_DOC"		, cNumDoc						,NIL} )
aAdd( aRotAuto ,	{"D3_PARCTOT"	, "P"							,NIL} )
aAdd( aRotAuto ,	{"D3_EMISSAO"	, STOD(ZZE->ZZE_EMISSA) ,NIL} )
aAdd( aRotAuto ,	{"D3_ZTIPO"		, ZZE->ZZE_TPOP		,NIL} )
aAdd( aRotAuto ,	{"__UUID"		, ZZE->ZZE_CHAVEU		,NIL} )
aAdd( aRotAuto , {"D3_ZOPTAUR"	, ZZE->ZZE_OPTAUR			,NIL} )
aAdd( aRotAuto , {"D3_ZPEDLOT"	, ZZE->ZZE_PEDLOT			,NIL} )
aAdd( aRotAuto , {'__ZTPOP'		, ZZE->ZZE_TPOP			,NIL} )
aAdd( aRotAuto , {'__ZTPMOV'	, ZZE->ZZE_TPMOV			,NIL} )
aAdd( aRotAuto , {'__ZCODPA'	, ZZE->ZZE_CODPA			,NIL} )
aAdd( aRotAuto , {'__ZOPTAURA'	, ZZE->ZZE_OPTAUR			,NIL} )
aAdd( aRotAuto , {'__LOCAL'	    , ZZE->ZZE_LOCAL			,NIL}  )
aAdd( aRotThread , aRotAuto )

oproc:ccaption := ('Gravando movimento de produção...')
ProcessMessages()

cFunTAP		:= "U_MGFTAP04"
cOpc		:= "1"
aParThread	:= { " " , " " , cIdProc , "" }

_lretloc := U_MGFTAP04( {cOpc ,;					//01
						 aRotThread ,;				//02
						 aParThread[1] ,;			//03
						 aParThread[2] ,;			//04
						 aParThread[3] ,;			//05
						ZZE->ZZE_CHAVEU		,;			//06
						_nrecno  	} )				//07

ZZE->(Dbgoto(_nrecno))

If _lretloc .AND. alltrim(SD3->D3_ZCHAVEU) == alltrim(ZZE->ZZE_CHAVEU)
	u_MGFmsg("Completou integração manual com sucesso!","Atenção",,1)
	Reclock("ZZE",.F.)
	ZZE->ZZE_STATUS := "M"
	ZZE->(Msunlock())
Else
	u_MGFmsg("Falha na gravação movimento manual, operação não realizada!","Atenção",,1)
	Disarmtransaction()
Endif

END TRANSACTION

Return

/*/
=============================================================================
{Protheus.doc} MGTAP17CON
Integração manual de consumo
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGTAP17CON(_cfilial,_cop,_cprod,_nquant,OPROC,_clote)

Local anumord := {}
Private cTMPrd		:= GetMv("MGF_TAP02B",,"111")

//valida estoque
SB2->(Dbsetorder(1)) //B2_FILIAL+B2_COD+B2_LOCAL

If SB2->(Dbseek(SUBSTR(alltrim(_cfilial),1,6)+PADR(SUBSTR(alltrim(_cprod),1,6),15)+'05'))
	_CESTOQUE := transform(SB2->B2_QATU,"@E 999,999,999.999")
	_nestoque := SB2->B2_QATU
else
	_cestoque := "0.000"
	_nestoque := 0
ENDIF

If _nestoque < _nquant

	u_MGFmsg("Integração manual de consumo só pode ser realizada com saldo de estoque suficiente!",;
			"Atenção",;
			"Contate o setor de custos local para análise do saldo de estoque do produto " + _cprod +":"+;
			chr(10)+chr(13) + chr(10)+chr(13) + "Saldo disponível: " + _cestoque + " kg" + ;
			chr(10)+chr(13) + "Consumo necessário: " + transform(_nquant,"@E 999,999,999.999") + " kg",1)

		RETURN
Endif

BEGIN TRANSACTION

//Grava ZZE
RecLock("ZZE",.T.)
ZZE->ZZE_FILIAL	:=	_cfilial
ZZE->ZZE_ID		:=	Subs(DtoS(Date()),3,6)+StrZero( Recno() , Len(ZZE->ZZE_ID)-6 )
ZZE->ZZE_IDTAUR	:=	"MANUAL - " + ALLTRIM(CUSERNAME)
ZZE->ZZE_ACAO	:=	'1'
ZZE->ZZE_OPTAUR	:=	_cop
ZZE->ZZE_TPOP	:=	'01'
ZZE->ZZE_TPMOV	:=	'02'
ZZE->ZZE_GERACA	:=	DTOS(date())
ZZE->ZZE_EMISSA	:=	DTOS(date())
ZZE->ZZE_HORA	:=	time()
ZZE->ZZE_CODPA	:=	_cprod
ZZE->ZZE_COD	:=	_cprod
ZZE->ZZE_QUANT	:=	_nquant
ZZE->ZZE_QTDPCS	:=	0
ZZE->ZZE_QTDCXS	:=	0
ZZE->ZZE_PEDLOT	:=	ALLTRIM(_clote)
ZZE->ZZE_LOCAL	:=	'05'
ZZE->ZZE_CHAVEU :=	FWUUIDV4()
ZZE->ZZE_CHAVEA :=	ZZE->ZZE_CHAVEU
ZZE->ZZE_DTREC  := Date()
ZZE->ZZE_HRREC  := Time()
ZZE->ZZE_STATUS := 'M'

ZZE->( msUnlock() )

_nrecno := ZZE->(Recno())

cCodPA	 := Stuff( Space(TamSX3("B1_COD")[1])     , 1 , Len(ZZE->ZZE_CODPA) , ZZE->ZZE_CODPA )
cOPTaura := Stuff( Space(TamSX3("C2_ZOPTAUR")[1]) , 1 , Len(ZZE->ZZE_OPTAUR), ZZE->ZZE_OPTAUR )
SC2->( dbOrderNickName("OPTAURA") )
cChave	:= ZZE->ZZE_FILIAL+cOPTaura+cCodPA


If SC2->( !dbSeek( cChave ) )

	//Cria OP se necessário
	oproc:ccaption := ('Abrindo OP ' + alltrim(ZZE->ZZE_OPTAUR) + "/" + alltrim(ZZE->ZZE_CODPA)  + "...")
	ProcessMessages()

	aRotThread	:= {}	
	aRotAuto	:= {}

	//Define sequencia, se op tem mais de 6 caracteres coloca caracteres adicionais no c2_sequen
	If len(alltrim(cOPTaura)) <= 6
		_cc2seque := '001'
	Else
		_cc2seque := padl(substr(alltrim(cOPTaura),7,3),3,"0")
	Endif

	_citem := "01"

	//Define item a ser usado
	If SC2->( dbSeek( _cfilial+cOPTaura ) )

		Do while SC2->C2_FILIAL + SC2->C2_ZOPTAUR == _cfilial+cOPTaura

			If SC2->C2_ITEM >= _citem
				If SC2->C2_ITEM < '10'
					_citem := strzero(val(SC2->C2_ITEM)+1,2)
				Else
					_citem := soma1(SC2->C2_ITEM)
				Endif
			Endif

		SC2->(Dbskip())

		Enddo

	Endif
	
	aAdd( aRotAuto , {'C2_FILIAL'	, ZZE->ZZE_FILIAL			,NIL} )
	aAdd( aRotAuto , {'C2_PRODUTO'	, ZZE->ZZE_CODPA			,NIL} )
	aAdd( aRotAuto , {'C2_ITEM'		, _citem					,NIL} )
	aAdd( aRotAuto , {'C2_SEQUEN'	, _cc2seque					,NIL} )
	aAdd( aRotAuto , {'C2_NUM'		, alltrim(cOPTaura) 		,NIL} )
	aAdd( aRotAuto , {'C2_QUANT'	, ZZE->ZZE_QUANT			,NIL} )
	aAdd( aRotAuto , {'C2_DATPRI'	, STOD(ZZE->ZZE_GERACA)-3	,NIL} )
	aAdd( aRotAuto , {'C2_DATPRF'	, STOD(ZZE->ZZE_GERACA)		,NIL} )
	aAdd( aRotAuto , {'C2_ZTIPO'	, ZZE->ZZE_TPOP			,NIL} )
	aAdd( aRotAuto , {'C2_ZOPTAUR'	, alltrim(ZZE->ZZE_OPTAUR)	,NIL} )
	aAdd( aRotAuto , {'AUTEXPLODE'	, "N"						,NIL} )
	aAdd( aRotAuto , {'__ZTPOP'		, ZZE->ZZE_TPOP				,NIL} )
	aAdd( aRotThread , aRotAuto )
	
	
	cFunTAP		:= "U_MGFTAP03"
	cOpc		:= "1"
	aParThread	:= { " " , " " , cIdProc , "" }

	IF Len(aRotThread) > 0 
		_lretloc := U_MGFTAP03( {	cOpc ,;						//01
							aRotThread ,; 				//02
							aParThread[1] ,; 			//03
							aParThread[2] ,; 			//04
							aParThread[3] ,; 			//05
							aParThread[4] ,;			//06
							ZZE->ZZE_CHAVEU,;	//07
							ZZE->(RECNO())  	} )	//08
		If _lretloc
			oproc:ccaption := ('Abriu OP ' + SC2->( C2_NUM+C2_ITEM+C2_SEQUEN )  + "...")
			ProcessMessages()
		Else
			U_MFCONOUT('Falha de integridade dos dados...')
			Disarmtransaction()
			u_MGFmsg("Falha na abertura da OP para o movimento manual, operação não realizada!","Atenção",,1)
			Return
		Endif
	EndIF

Endif

cNumOrd	:= SC2->( C2_NUM+C2_ITEM+C2_SEQUEN )
cNumDoc	:= MGFTP1702()

//Chama processamento
aRotThread	:= {}	
aRotauto := {}
aAdd( aRotAuto ,	{"D3_FILIAL"	, ZZE->ZZE_FILIAL		,NIL} )
aAdd( aRotAuto ,	{"D3_TM"		, cTMReq							,NIL} )
aAdd( aRotAuto ,	{"D3_COD"		, ZZE->ZZE_COD					,NIL} )
aAdd( aRotAuto ,	{"D3_QUANT"		, ZZE->ZZE_QUANT		,NIL} )
aAdd( aRotAuto ,	{"D3_ZQTDPCS"	, 0		,NIL} )
aAdd( aRotAuto ,	{"D3_ZQTDCXS"	, 0		,NIL} )
aAdd( aRotAuto ,	{"D3_OP"		, cNumOrd						,NIL} )
aAdd( aRotAuto ,	{"D3_LOCAL"		, ZZE->ZZE_LOCAL,NIL} )
AAdd( aRotAuto ,	{"D3_DOC"		, cNumDoc						,NIL} )
aAdd( aRotAuto ,	{"D3_PARCTOT"	, "P"							,NIL} )
aAdd( aRotAuto ,	{"D3_EMISSAO"	, STOD(ZZE->ZZE_EMISSA) ,NIL} )
aAdd( aRotAuto ,	{"D3_ZTIPO"		, ZZE->ZZE_TPOP		,NIL} )
aAdd( aRotAuto ,	{"__UUID"		, ZZE->ZZE_CHAVEU		,NIL} )
aAdd( aRotAuto , {"D3_ZOPTAUR"	, ZZE->ZZE_OPTAUR			,NIL} )
aAdd( aRotAuto , {"D3_ZPEDLOT"	, ZZE->ZZE_PEDLOT			,NIL} )
aAdd( aRotAuto , {'__ZTPOP'		, ZZE->ZZE_TPOP			,NIL} )
aAdd( aRotAuto , {'__ZTPMOV'	, ZZE->ZZE_TPMOV			,NIL} )
aAdd( aRotAuto , {'__ZCODPA'	, ZZE->ZZE_CODPA			,NIL} )
aAdd( aRotAuto , {'__ZOPTAURA'	, ZZE->ZZE_OPTAUR			,NIL} )
aAdd( aRotAuto , {'__ZLOCAL'	    , ZZE->ZZE_LOCAL			,NIL}  )
aAdd( aRotThread , aRotAuto )

oproc:ccaption := ('Gravando movimento de consumo...')
ProcessMessages()

cFunTAP		:= "U_MGFTAP05"
cOpc		:= "1"
aParThread	:= { " " , " " , cIdProc , "" }

	_lretloc := U_MGFTAP05( {	cOpc ,;							//01			
								 aRotThread ,;						//02
								 aParThread[1] ,;					//03
								 aParThread[2] ,;					//04
								 aParThread[3] ,;					//05
								 aParThread[4] ,;					//06
								 ZZE->ZZE_CHAVEU  ,;				//07
								 _nrecno  } )						//08

ZZE->(Dbgoto(_nrecno))

If _lretloc .AND. alltrim(SD3->D3_ZCHAVEU) == alltrim(ZZE->ZZE_CHAVEU)
	u_MGFmsg("Completou integração manual com sucesso!","Atenção",,1)
	Reclock("ZZE",.F.)
	ZZE->ZZE_STATUS := "M"
	ZZE->(Msunlock())
Else
	u_MGFmsg("Falha na gravação movimento manual, operação não realizada!","Atenção",,1)
	Disarmtransaction()
Endif

END TRANSACTION

Return

//-------------------------------------------------------------------------------------
/*/{Protheus.doc}MGFTP17EST - Integracao manual de estorno
@author  Josué Danich
@since 15/07/2020
*/
Static Function MGFTP17EST(_cfilial,_cop,_cprod,_nquant,OPROC,_ntipo,_clote)

Local _lretloc := .T.

BEGIN TRANSACTION

//Grava ZZE
RecLock("ZZE",.T.)
ZZE->ZZE_FILIAL	:=	_cfilial
ZZE->ZZE_ID		:=	Subs(DtoS(Date()),3,6)+StrZero( Recno() , Len(ZZE->ZZE_ID)-6 )
ZZE->ZZE_IDTAUR	:=	"MANUAL - " + ALLTRIM(CUSERNAME)
ZZE->ZZE_ACAO	:=	'2'
ZZE->ZZE_OPTAUR	:=	_cop
ZZE->ZZE_TPOP	:=	'01'
ZZE->ZZE_TPMOV	:=	iif(_ntipo==1,'01','02')
ZZE->ZZE_GERACA	:=	DTOS(date())
ZZE->ZZE_EMISSA	:=	DTOS(date())
ZZE->ZZE_HORA	:=	time()
ZZE->ZZE_CODPA	:=	_cprod
ZZE->ZZE_COD	:=	_cprod
ZZE->ZZE_QUANT	:=	_nquant
ZZE->ZZE_QTDPCS	:=	0
ZZE->ZZE_QTDCXS	:=	0
ZZE->ZZE_PEDLOT	:=	_clote
ZZE->ZZE_LOCAL	:=	'05'
ZZE->ZZE_CHAVEU :=	FWUUIDV4()
ZZE->ZZE_CHAVEA :=	ZZE->ZZE_CHAVEU
ZZE->ZZE_DTREC  := Date()
ZZE->ZZE_HRREC  := Time()
ZZE->ZZE_STATUS := 'M'

ZZE->( msUnlock() )

_nrecno := ZZE->(Recno())


oproc:ccaption := ('Executando estorno de movimento da OP ' + alltrim(ZZE->ZZE_OPTAUR) + "/" + alltrim(ZZE->ZZE_CODPA)  + "...")
ProcessMessages()

aRotThread	:= {}

SB1->( dbSeek( xFilial("SB1")+ZZE->ZZE_COD ) )
cIdSeq	:= Soma1(cIdSeq)
				
aAdd( aRotThread , {	ZZE->ZZE_FILIAL,	;
									ZZE->ZZE_GERACA,	;
									ZZE->ZZE_TPOP,		;
									ZZE->ZZE_TPMOV,	;
									ZZE->ZZE_CODPA,	;
									ZZE->ZZE_COD,		;
									ZZE->ZZE_LOTECT,	;
									ZZE->ZZE_DTVALI,	;
									ZZE->ZZE_QUANT,	;	
									ZZE->ZZE_LOCAL,	;
									ZZE->ZZE_OPTAUR,	;
									cIdProc,					;
									cIdSeq,						;
									ZZE->ZZE_QTDPCS,	;
									ZZE->ZZE_QTDCXS,;
									_clote									}	)



If Len( aRotThread ) > 0 .and. _lretloc
				
	cFunTAP		:= "U_MGFTAP19"
	cOpc		:= "1"
	aParThread	:= { " " , " " , cIdProc , "" }
	_cret := ""
		_lretloc := U_MGFTAP19( {aRotThread , aParThread[3],ZZE->ZZE_CHAVEU,_nrecno}, @_cret )

	ZZE->(Dbgoto(_nrecno))

	If _lretloc .AND. ZZE->ZZE_STATUS = '1'
		u_MGFmsg("Completou estorno manual com sucesso!","Atenção",,1)
		Reclock("ZZE",.F.)
		ZZE->ZZE_STATUS := "M"
		ZZE->(Msunlock())
	Else
		u_MGFmsg("Falha na gravação estorno manual, operação não realizada!(" + _cret + ")","Atenção",,1)
		Disarmtransaction()
	Endif

EndIf

END TRANSACTION

Return _lretloc


