#Include "PROTHEUS.CH"  
#Include "RWMAKE.CH"             
#Include "TopConn.ch"  
#Include "vkey.ch"

#DEFINE _ENTER CHR(13)+CHR(10)         



/*/
=============================================================================
{Protheus.doc} MGFFATBQ
Tela administração de produtos do Commerce
@author
Josué Danich
@since
10/03/2020
/*/
user function MGFFATBQ()

Private _alista := {}
Private _otemp := nil

MGFATBQINI()

Return()

/*/
=============================================================================
{Protheus.doc} MGFATBQINI
Funcao que controla o processamento
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGFATBQINI()

Private cMarkado	:= GetMark()
Private lInverte	:= .F.



Private aCampos		:= {}

MGFATBQPRC()

Return()


/*/
=============================================================================
{Protheus.doc} MGFATBQPRC
Função que processa os produtos
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGFATBQPRC()

Private cMarca   := GetMark()
Private aCampos  := {}
Private cPerg		:= 'MGFFATBQ'

If Pergunte( cPerg , .T. )

	//================================================================================
	// Cria o arquivo Temporario para insercao dos dados selecionados.
	//================================================================================
	FWMSGRUN( , {|oproc| _nControle := MGFATBQARQ(oproc, .T., .F.) }, "Aguarde!" , 'Lendo Dados dos produtos...' )

	MGFATBQTRS()//Função que monta a tela para processar

Endif


Return .T.

/*/
=============================================================================
{Protheus.doc} MGFATBQTRS
Função que monta a tela para processar
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGFATBQTRS()

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
Aadd( aBotoes , { "" , {|| MGFATBQC(01) 	}	, "" , "Atualizar"		 			 } )
Aadd( aBotoes , { "" , {|| MGFATBQC(02) 	}	, "" , "Pesquisar"		 			 } )
Aadd( aBotoes , { "" , {|| MGFATBQC(03) 	}	, "" , "Filtro"         			 } )
Aadd( aBotoes , { "" , {|| MGFATBQC(04) 	}	, "" , "Visualizar Produto"			 } )
Aadd( aBotoes , { "" , {|| MGFATBQC(05)		}	, "" , "Visualiza Preços"  			 } )
Aadd( aBotoes , { "" , {|| MGFATBQC(06) 	}	, "" , "Visualiza Estoques" 		 } )
Aadd( aBotoes , { "" , {|| MGFATBQC(07) 	}	, "" , "Log Integrações"    		 } )
Aadd( aBotoes , { "" , {|| MGFATBQC(10) 	}	, "" , "Altera Produto"   			 } )
Aadd( aBotoes , { "" , {|| MGFATBQC(11) 	}	, "" , "Legenda"       				 } )
Aadd( aBotoes , { "" , {|| MGFATBQC(12) 	}	, "" , "Exporta Excel"       		 } )

//================================================================================
// Faz o calculo automatico de dimensoes de objetos
//================================================================================
aSize := MSADVSIZE() 

//================================================================================
// Cria a tela para selecao dos produtos
//================================================================================
_ctitulo := "CENTRAL DE PRODUTOS PARA ECOMMERCE"
		

 DEFINE MSDIALOG oDlg1 TITLE OemToAnsi(_ctitulo) From 0,0 To aSize[6],aSize[5] PIXEL

	oPanel       := TPanel():New(30,0,'',oDlg1,, .T., .T.,, ,315,20,.T.,.T. )
	@0.8,00.8 Say OemToAnsi("Quantidade:")						OF oPanel
	@0.8,0005 Say oQtda		VAR nQtdTit		Picture "@E 99999"	OF oPanel SIZE 60,8
		
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
	oMark:bMark				:= {|| MGFATBQINV( cMarkado , lInverte  ) }
	oMark:oBrowse:bAllMark	:= {|| MGFATBQALL( cMarkado  ) }
    oCol := oMark:oBrowse:aColumns[2]
    oCol:bData     := {|| U_MGFATBQCL() }
    oMark:oBrowse:aColumns[2]:=oCol

	oDlg1:lMaximized:=.T.

ACTIVATE MSDIALOG oDlg1 ON INIT ( EnchoiceBar(oDlg1,{|| MGFATBQC(02) },{|| nOpca := 2,oDlg1:End()},,aBotoes),;
                                  oPanel:Align:=CONTROL_ALIGN_TOP , oMark:oBrowse:Align:=CONTROL_ALIGN_ALLCLIENT , oMark:oBrowse:Refresh())


Return nOpca

/*/
=============================================================================
{Protheus.doc} MGFATBQPSQ
Funcao para pesquisa no arquivo temporario.
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGFATBQPSQ( oMark , cAlias )

Local oGet1		:= Nil
Local oDlg		:= Nil
Local cGet1		:= Space(40)
Local cComboBx1	:= ""
Local aComboBx1	:= { "Codigo" , "Descrição"  }
Local nOpca		:= 0
Local nI		:= 0

DEFINE MSDIALOG oDlg TITLE "Pesquisar" FROM 178,181 TO 259,697 PIXEL

	@004,003 ComboBox	cComboBx1	Items aComboBx1 Size 213,010 OF oDlg PIXEL
	@020,003 MsGet		oGet1		Var cGet1		Size 212,009 OF oDlg PIXEL COLOR CLR_BLACK Picture "@!"
	
	DEFINE SBUTTON FROM 004,227 TYPE 1 ENABLE ACTION ( nOpca := 1 , oDlg:End() ) OF oDlg
	DEFINE SBUTTON FROM 021,227 TYPE 2 ENABLE ACTION ( nOpca := 0 , oDlg:End() ) OF oDlg

ACTIVATE MSDIALOG oDlg CENTERED

If nOpca == 1

	For nI := 1 To Len(aComboBx1)
	
		If cComboBx1 == aComboBx1[nI]
		
			DBSelectArea("TRBF")
			TRBF->( DBSetOrder(2) )
			
			MsSeek( cGet1 , .T. )
			
			oMark:oBrowse:Refresh( .T. )
			TRBF->( DBSetOrder(1) )
			
		EndIf
		
	Next nI
	
EndIf

Return()

/*/
=============================================================================
{Protheus.doc} MGFATBQINV
Rotina para inverter a marcacao do registro posicionado.
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGFATBQINV( cMarca , lInverte  )

Local lMarcado := IsMark( "TRBF_OK" , cMarca , lInverte )

If lMarcado
	nQtdTit++
Else
	nQtdTit--
EndIf

oQtda:Refresh()

Return()

/*/
=============================================================================
{Protheus.doc} MGFATBQALL
Chama Rotina para inverter a marcacao de todos os registros.
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGFATBQALL( cMarca  )

fwmsgrun(,{ || MGFATBLL(cMarca) }, "Aguarde...","Carregando dados...")

Return

/*/
=============================================================================
{Protheus.doc} MGFATBLL
Rotina para inverter a marcacao de todos os registros.
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGFATBLL( cMarca  )

Local nReg     := TRBF->( Recno() )
Local lMarcado := .F.

DBSelectArea("TRBF")
TRBF->( DBGoTop() )

While TRBF->( !Eof() )
	
	lMarcado := IsMark( "TRBF_OK" , cMarca , lInverte )
	
	If lMarcado .Or. lInverte
	
		TRBF->( RecLock( "TRBF" , .F. ) )
		TRBF->TRBF_OK := Space(2)
		TRBF->( MsUnLock() )
		
		nQtdTit--
		
	Else
	
		TRBF->( RecLock( "TRBF" , .F. ) )
		TRBF->TRBF_OK := cMarca
		TRBF->( MsUnLock() )
		
		nQtdTit++
		
	EndIf
	
	nQtdTit := IIf( nQtdTit < 0 , 0 , nQtdTit )
	
TRBF->( DBSkip() )
EndDo

TRBF->( DBGoto(nReg) )

oQtda:Refresh()
oMark:oBrowse:Refresh(.T.)

Return()

/*/
=============================================================================
{Protheus.doc} MGFATBQARQ
Rotina para criação do arquivo temporário
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGFATBQARQ(oproc,_lini,_lcabec)

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
AADD( aEstru , { "TRBF_COD"	    , 'C' , 06 , 0 } )  
AADD( aEstru , { "TRBF_DESC"	, 'C' , 100 , 0 } )
AADD( aEstru , { "TRBF_PESOM"	, 'C' , 5 , 0 } )
AADD( aEstru , { "TRBF_LINHA"	, 'C' , 6 , 0 } )
AADD( aEstru , { "TRBF_DLINH"	, 'C' , 30 , 0 } )
AADD( aEstru , { "TRBF_EAN13"	, 'C' , 30 , 0 } )
AADD( aEstru , { "TRBF_CCATE"	, 'C' , 6 , 0 } )
AADD( aEstru , { "TRBF_DCCAT"	, 'C' , 30 , 0 } )
AADD( aEstru , { "TRBF_MARCA"	, 'C' , 6 , 0 } )
AADD( aEstru , { "TRBF_DMARC"	, 'C' , 30 , 0 } )
AADD( aEstru , { "TRBF_ORIGE"	, 'C' , 3 , 0 } )
AADD( aEstru , { "TRBF_DORIG"	, 'C' , 40 , 0 } )


//================================================================================
// Armazena no array aCampos o nome, picture e descricao dos campos
//================================================================================
AADD( aCampos , { "TRBF_OK"		, "" , " "					, " "										} )
AADD( aCampos , { "TRBF_OK"		, "" , " "					, " "										} )
AADD( aCampos , { "TRBF_COD"	, "" , "Código"		        , PesqPict( "SB1" , "B1_COD" )	  		} )
AADD( aCampos , { "TRBF_DESC"	, "" , "Descrição"		    , PesqPict( "SB1" , "B1_DESC" )	  		} )
AADD( aCampos , { "TRBF_PESOM"	, "" , "Peso Médio"		    , PesqPict( "SB1" , "B1_DESC" )	  		} )
AADD( aCampos , { "TRBF_DLINH"	, "" , "Linha"			    , PesqPict( "SB1" , "B1_DESC" )	  		} )
AADD( aCampos , { "TRBF_DCCAT"	, "" , "Categoria"		    , PesqPict( "SB1" , "B1_DESC" )	  		} )
AADD( aCampos , { "TRBF_DMARC"	, "" , "Marca"			    , PesqPict( "SB1" , "B1_DESC" )	  		} )
AADD( aCampos , { "TRBF_DORIG"	, "" , "Origem"			    , PesqPict( "SB1" , "B1_DESC" )	  		} )
AADD( aCampos , { "TRBF_EAN13"	, "" , "EAN13"			    , PesqPict( "SB1" , "B1_DESC" )	  		} )


//================================================================================
// Verifica se ja existe um arquivo com mesmo nome, se sim deleta.
//================================================================================
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
_otemp:AddIndex( "CO", {"TRBF_COD"} )
_otemp:AddIndex( "DE", {"TRBF_DESC"} )

_otemp:Create()

//================================================================================
// Filtra PA ativo menor que 500000
//================================================================================
cFiltro += " AND B1_MSBLQL = '2' AND B1_COD < '500000' "

//Filtro de código de produtos
If !EMPTY(MV_PAR01)
	cFiltro += " AND B1_COD >= '" + alltrim(MV_PAR01) + "' AND B1_COD <= '" + ALLTRIM(MV_PAR02) + "' "
Endif

//Filtro de descrição de produtos
If !EMPTY(MV_PAR03)
	cFiltro += " AND B1_DESC >= '" + alltrim(MV_PAR03) + "' AND B1_DESC <= '" + ALLTRIM(MV_PAR04) + "' "
Endif

//Filtro de peso médio
If MV_PAR05 == 2
	cFiltro += " AND B1_ZPESMED > 0
Elseif MV_PAR05 == 3
	cFiltro += " AND B1_ZPESMED = 0
Endif

//Filtro de linhas
If !EMPTY(MV_PAR06)
	cFiltro += " AND B1_ZLINHA IN " + FormatIn( alltrim(MV_PAR06), ";" )	
Endif

//Filtro de categorias
If !EMPTY(MV_PAR07)
	cFiltro += " AND (( B1_ZCCATEG <> '007' AND B1_ZCCATEG IN " + FormatIn( alltrim(MV_PAR07), ";" )	 + ") "
	_AITENS := STRTOKARR2(alltrim(MV_PAR07), ";")
	_citens := ""
	For _ni := 1 to len(_aitens)
		_citens += alltrim(str(val(_aitens[_ni]))) + ";"
	Next
	cFiltro += " OR (B1_ZCCATEG = '007' AND B1_XINTECO IN " + FormatIn( alltrim(_citens), ";" )	 + ") )"
Endif

//Filtro de marcas
If !EMPTY(MV_PAR08)
	cFiltro += " AND B1_ZMARCAC IN " + FormatIn( alltrim(MV_PAR08), ";" )	
Endif

//Filtro de ORIGENS
If !EMPTY(MV_PAR09)
	cFiltro += " AND B1_ZORIGEM IN " + FormatIn( alltrim(MV_PAR09), ";" )	
Endif

//Filtro de EAN13
If !EMPTY(MV_PAR10)
	cFiltro += " AND B1_ZEAN13 >= '" + alltrim(MV_PAR10) + "' AND B1_ZEAN13 <= '" + ALLTRIM(MV_PAR11) + "' "
Endif

                                        
//================================================================================
// Verifica se ja existe um arquivo com mesmo nome, se sim deleta.
//================================================================================
If Select("QRYPED") > 0
	QRYPED->( DBCloseArea() )
EndIf

//================================================================================
// Query para selecao dos dados DOS PRODUTOS
//================================================================================
_cquery := " SELECT	DISTINCT B1_COD,B1_DESC, B1_ZPESMED,B1_ZLINHA,B1_ZEAN13,B1_ZCCATEG,B1_XINTECO,B1_ZMARCAC,B1_ZORIGEM	FROM		SB1010 B1 "	
_cquery += "   JOIN DA1010 DA1 ON DA1.DA1_FILIAL = '01    ' AND DA1.DA1_CODPRO = B1.B1_COD " 
_cquery += "     JOIN DA0010 DA0 ON DA0.DA0_FILIAL = DA1.DA1_FILIAL AND DA0.DA0_CODTAB = DA1.DA1_CODTAB" 
_cquery += "    WHERE	B1.D_E_L_E_T_ = ' '"  
_cquery += "             AND DA0.DA0_XENVEC	=	'1'"
_cquery += "             AND DA0.DA0_ATIVO	=	'1'"
_cquery += "             AND DA1.DA1_PRCVEN > 1"
_cquery += "             AND DA1.D_E_L_E_T_ <> '*'"
_cquery += "             AND DA1.D_E_L_E_T_ <> '*'"
_cquery += cFiltro
	
_cquery += "	ORDER BY	B1_COD,B1_DESC

oproc:cCaption := ("Carregando query de produtos...")
ProcessMessages()

TCQUERY _cquery NEW ALIAS "QRYPED"

oproc:cCaption := ("Contando os produtos...")
ProcessMessages()

nQtdTit := 0
COUNT TO nQtdTit
QRYPED->(Dbgotop())
_npv:=1


DO While QRYPED->(!EOF())

	//Atualiza régua
	oproc:cCaption := ("Processando produto... ["+ StrZero(_npv,6) +"] de ["+ StrZero(nQtdTit,6) +"]")
    _npv++
	ProcessMessages()
	
	If alltrim(QRYPED->B1_ZCCATEG) != "007"

		_ccateg := QRYPED->B1_ZCCATEG
	Else

		_ccateg := strzero(val(QRYPED->B1_XINTECO),3)

	Endif

    Reclock("TRBF",.T.)
    TRBF->TRBF_COD	    := QRYPED->B1_COD
    TRBF->TRBF_DESC		:= QRYPED->B1_DESC
	TRBF->TRBF_PESOM	:= alltrim(TRANSFORM(QRYPED->B1_ZPESMED,"@E 999,999.99"))
	TRBF->TRBF_DLINH	:= alltrim(QRYPED->B1_ZLINHA + " - " + POSICIONE("ZC4",1,xfilial("ZC4")+QRYPED->B1_ZLINHA,'ZC4_DESCRI'))
	TRBF->TRBF_EAN13	:= ALLTRIM(STR(QRYPED->B1_ZEAN13))
	TRBF->TRBF_DCCATE	:= alltrim(_ccateg + " - " + POSICIONE("ZA4",1,xfilial("ZA4")+_ccateg,'ZA4_DESCR'))
	TRBF->TRBF_DMARCA	:= alltrim(QRYPED->B1_ZMARCAC + " - " + POSICIONE("ZZU",1,xfilial("ZZU")+QRYPED->B1_ZMARCAC,'ZZU_DESCRI'))
	TRBF->TRBF_DORIGE	:= alltrim(QRYPED->B1_ZORIGEM + " - " + POSICIONE("ZDA",1,xfilial("ZDA")+QRYPED->B1_ZORIGEM,'ZDA_DESCR'))
  	
    QRYPED->( DBSkip() )
	
EndDo

QRYPED->( DBCloseArea())

TRBF->(DbGotop())

If _lcabec  //Inicializa cabecalho

	nQtdTit := 0

	oQtda:Refresh()
	
Endif

Return

/*/
=============================================================================
{Protheus.doc} MGFATBQPPV
Função para visualizar Produto
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGFATBQPPV()   

Private altera := .F.
Private ccadastro := "Visualizando produto a partir da tela de central de produtos do E-commerce"

If TRBF->(Eof())
	u_MGFmsg("Não há produto para visualização, ajuste o filtro!")
	Return
Endif

SB1->( DBSetOrder(1) ) //B1_FILIAL+B1_COD
If SB1->( DBSeek( xfilial("SB1") + TRBF->TRBF_COD ) ) 
	axvisual("SB1", SB1->(Recno()), 2) 
EndIf

Return()

/*/
=============================================================================
{Protheus.doc} MGFATBQLegenda
Tela de significado de legendas
@author
Josué Danich
@since
10/03/2020
/*/
STATIC Function MGFATBQLegenda()
Local aLegenda := {}

aAdd(aLegenda, {"BR_VERMELHO"   ,"Produto com falha de cadastro"})
aAdd(aLegenda, {"BR_AMARELO"	,"Produto com falha de integração"})
aAdd(aLegenda, {"BR_VERDE"		,"Produto integrado"})

BrwLegenda("Legenda","Legenda",aLegenda)

Return .T.

/*/
=============================================================================
{Protheus.doc} MGFATBQC
Chamada de itens do menu
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGFATBQC(_nopc)

Local oproc

Do Case

Case _nopc == 1 
	//Atualizar
	fwmsgrun(,{ || MGFATBQAT() }, "Aguarde...","Carregando dados...")

Case _nopc == 2
	//Pesquisar
	fwmsgrun(,{ || MGFATBQPSQ(oMark,"TRBF") }, "Aguarde...","Carregando dados...")
	
Case _nopc == 3
	//Filtro
	fwmsgrun(,{ || MGFATBQF() }, "Aguarde...","Carregando dados...")
	
Case _nopc == 4
	//Visualizar Produto
	fwmsgrun(,{ || MGFATBQPPV() }, "Aguarde...","Carregando dados...")

Case _nopc == 5
	//Visualiza Preços
	fwmsgrun(,{ || MGFATBQVP() }, "Aguarde...","Carregando dados...")

Case _nopc == 6
	//Visualiza Estoques
	fwmsgrun(,{ || MGFATBQME() }, "Aguarde...","Carregando dados...")
	
Case _nopc == 7 
	//Log Integrações Produto
	fwmsgrun(,{ || MGFATBQLI() }, "Aguarde...","Carregando dados...")

Case _nopc == 10
	//Altera Produto
	fwmsgrun( , {|oproc| U_MGFATBQAP() }, "Aguarde!" , 'Carregando dados...' )
	
Case _nopc == 11
	//Legenda
	fwmsgrun(,{ || MGFATBQLegenda() }, "Aguarde...","Carregando dados...")

Case _nopc == 12
	//Legenda
	fwmsgrun(,{ || MGFATBQEC() }, "Aguarde...","Carregando dados...")
	
Otherwise
	u_MGFmsg("Função em Desenvolvimento","Atenção",,1)
	
EndCase

Return

/*/
=============================================================================
{Protheus.doc} MGFATBQLI
Visuliza log
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGFATBQLI()
Local _asits := {}
Local _aheader := {"Integração","Data","Hora","Status"}

If select("QRYZFU") > 0
	Dbselectarea("QRYZFU")
	QRYZFU->(Dbclosearea())
Endif

_cquery := " SELECT	ZFU_DATA1,ZFU_HORA1,ZFU_STATUS	FROM ZFU010 " 
_cquery += "    WHERE ZFU_PROD = '" + ALLTRIM(TRBF->TRBF_COD) +  "'" 
_cquery += " AND ROWNUM	=	'1'"
_cquery += " AND D_E_L_E_T_ <> '*'"
_cquery += " ORDER BY R_E_C_N_O_ DESC "

TCQUERY _cquery NEW ALIAS "QRYZFU"

If QRYZFU->(!EOF())
	aadd(_asits,{"Cadastro Produto",STOD(QRYZFU->ZFU_DATA1),QRYZFU->ZFU_HORA1,QRYZFU->ZFU_STATUS})
Else
	aadd(_asits,{"Cadastro Produto","N/C","N/C","Não enviado para o E-Commerce"})
Endif

aadd(_asits,{"Tabela Preços","N/C","N/C","Log não disponível"})
aadd(_asits,{"Saldos Estoque","N/C","N/C","Log não disponível"})

U_MGListBox( "Integrações do Ecommerce" , _aheader , _asits , .T. , 1 )

Return

/*/
=============================================================================
{Protheus.doc} MGFATBQEC
Exporta browse para o excel
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGFATBQEC(oproc)

Local _acolec := {}
Local _aheaderec := {}

AADD( aCampos , { "TRBF_COD"	, "" , "Código"		        , PesqPict( "SB1" , "B1_COD" )	  		} )
AADD( aCampos , { "TRBF_DESC"	, "" , "Descrição"		    , PesqPict( "SB1" , "B1_DESC" )	  		} )
AADD( aCampos , { "TRBF_PESOM"	, "" , "Peso Médio"		    , PesqPict( "SB1" , "B1_DESC" )	  		} )
AADD( aCampos , { "TRBF_DLINH"	, "" , "Linha"			    , PesqPict( "SB1" , "B1_DESC" )	  		} )
AADD( aCampos , { "TRBF_DCCAT"	, "" , "Categoria"		    , PesqPict( "SB1" , "B1_DESC" )	  		} )
AADD( aCampos , { "TRBF_DMARC"	, "" , "Marca"			    , PesqPict( "SB1" , "B1_DESC" )	  		} )
AADD( aCampos , { "TRBF_DORIG", "" , "Origem"			    , PesqPict( "SB1" , "B1_DESC" )	  		} )
AADD( aCampos , { "TRBF_EAN13"	, "" , "EAN13"			    , PesqPict( "SB1" , "B1_DESC" )	  		} )

	//Monta aheader
	aadd(_aheaderec,"Código")
	aadd(_aheaderec,"Descrição" )
	aadd(_aheaderec,"Peso Médio" )
	aadd(_aheaderec,"Linha")
	aadd(_aheaderec,"Categoria")
	aadd(_aheaderec,"Marca")
	aadd(_aheaderec,"Origem")
	aadd(_aheaderec,"EAN13")
	
	//Monta acols
	_nposi := TRBF->(Recno())
	TRBF->(Dbgotop())

	Do while !(TRBF->(Eof()))

		If IsMark( "TRBF_OK" , cMarkado )

			aadd(_acolec, {	TRBF->TRBF_COD,;
    				TRBF->TRBF_DESC,;
    				TRBF->TRBF_PESOM,;
    				TRBF->TRBF_DLINHA,;
    				TRBF->TRBF_DCCAT,;
    				TRBF->TRBF_DMARC,;
    				TRBF->TRBF_DORIG,;
    				TRBF->TRBF_EAN13 } )

		Endif

		TRBF->(Dbskip())

	Enddo

	//Apresenta itlist
	If len(_acolec) > 0

		U_MGListBox( "Produtos do Ecommerce" , _aheaderec , _acolec , .T. , 1 )

	Else

		u_MGFmsg("Nenhum registro selecionado!","Atenção",,1)

	Endif

	TRBF->(Dbgoto(_nposi))

Return

/*/
=============================================================================
{Protheus.doc} MGFATBQF
Carrega novo filtro
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGFATBQF(oproc)

If !Pergunte( cPerg , .T. )
	Return
EndIf
       
//================================================================================
// Cria o arquivo Temporario para insercao dos dados selecionados.
//================================================================================
FWMSGRUN( , {|oproc| _nControle := MGFATBQARQ(oproc, .T.) }, "Aguarde!" , 'Lendo Dados dos produtos...' )

Return

/*/
=============================================================================
{Protheus.doc} MGFATBQAT
Atualiza tela
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGFATBQAT(oproc)

//================================================================================
// Cria o arquivo Temporario para insercao dos dados selecionados.
//================================================================================
FWMSGRUN( , {|oproc| _nControle := MGFATBQARQ(oproc, .T.) }, "Aguarde!" , 'Lendo Dados dos produtos...' )

Return

/*/
=============================================================================
{Protheus.doc} MGFATBQCL
Retorna cor e legenda
@author
Josué Danich
@since
10/03/2020
/*/
User Function MGFATBQCL()

Local _ccor := "BR_VERDE"

Return _ccor

/*/
=============================================================================
{Protheus.doc} MGFATBQAP
Altera produto
@author
Josué Danich
@since
10/03/2020
/*/
User Function MGFATBQAP()

Local cdescricao := alltrim(TRBF->TRBF_DESC)
Local _cEan13 := alltrim(TRBF->TRBF_EAN13)
Local oEan13
Local codprod := alltrim(TRBF->TRBF_COD)
Local oCancela
Local olinha
Local nlinha := 1
Local ocateg
Local ncateg := 1
Local omarca
Local nmarca := 1
Local oorigem
Local norigem := 1
Local oOK
Local oSay1
Local oSay2
Local oSay3
Local oSay4
Local oSay5
Local oSay6
Local oDlg
Local _aclinhas := MGFATBQCA("ZC4","ZC4_CODIGO","ZC4_DESCRI",1)
Local _accategs := MGFATBQCA("ZA4","ZA4_CODIGO","ZA4_DESCR",1)
Local _acmarcas := MGFATBQCA("ZZU","ZZU_CODIGO","ZZU_DESCRI",1)
Local _acorigens := MGFATBQCA("ZDA","ZDA_COD","ZDA_DESCR",1)
Local _alinhas := MGFATBQCA("ZC4","ZC4_CODIGO","ZC4_DESCRI",2)
Local _acategs := MGFATBQCA("ZA4","ZA4_CODIGO","ZA4_DESCR",2)
Local _amarcas := MGFATBQCA("ZZU","ZZU_CODIGO","ZZU_DESCRI",2)
Local _aorigens := MGFATBQCA("ZDA","ZDA_COD","ZDA_DESCR",2)
Local nopca := 0
Local _lsai := .F.

If TRBF->(Eof())
	u_MGFmsg("Não há produto para alteração, ajuste o filtro!")
	Return
Endif

Do while .not. _lsai

	SB1->(Dbsetorder(1)) //B1_FILIAL+B1_COD
	SB1->(Dbgotop())
	SB1->(Dbseek(xfilial("SB1")+TRBF->TRBF_COD))

	cdescricao := alltrim(TRBF->TRBF_DESC)
	_cEan13 := alltrim(TRBF->TRBF_EAN13)
	codprod := alltrim(TRBF->TRBF_COD)
	nopca := 0

	_npos := ascan(_alinhas,alltrim(SB1->B1_ZLINHA))
	If _npos > 0
		nlinha := _alinhas[_npos]
	Else
		nlinha := "     "
	Endif

	_npos := ascan(_acategs,alltrim(SB1->B1_ZCCATEG))
	If _npos > 0
		ncateg := _acategs[_npos]
	Else
		ncateg := "     "
	Endif

	_npos := ascan(_amarcas,alltrim(SB1->B1_ZMARCAC))
	If _npos > 0
		nmarca := _amarcas[_npos]
	Else
		nmarca := "     "
	Endif

	_npos := ascan(_aorigens,alltrim(SB1->B1_ZORIGEM))
	If _npos > 0
		norigem := _aorigens[_npos]
	Else
		norigem := "     "
	Endif



	DEFINE MSDIALOG oDlg TITLE "Altera Produto do Commerce" FROM 000, 000  TO 300, 480 COLORS 0, 16777215 PIXEL

	@ 011, 008 SAY oSay1 PROMPT "Código" SIZE 018, 001 OF oDlg COLORS 0, 16777215 PIXEL
	@ 010, 006 MSGET codprod VAR codprod SIZE 060, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
	@ 026, 006 MSGET cdescricao VAR cdescricao SIZE 222, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
	@ 051, 009 SAY oSay2 PROMPT "Linha" SIZE 038, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 049, 047 MSCOMBOBOX olinha VAR nlinha ITEMS _alinhas SIZE 181, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 067, 010 SAY oSay3 PROMPT "Categoria" SIZE 038, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 065, 048 MSCOMBOBOX oCateg VAR nCateg ITEMS _acategs SIZE 181, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 083, 010 SAY oSay4 PROMPT "Marca" SIZE 038, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 081, 048 MSCOMBOBOX omarca VAR nmarca ITEMS _amarcas SIZE 181, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 098, 010 SAY oSay5 PROMPT "Origem" SIZE 038, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 096, 048 MSCOMBOBOX oorigem VAR norigem ITEMS _aorigens SIZE 181, 010 OF oDlg COLORS 0, 16777215 PIXEL

	DEFINE SBUTTON FROM 131,188 TYPE 1 ENABLE ACTION ( nOpca := 1 , oDlg:End() ) OF oDlg
	DEFINE SBUTTON FROM 131,141 TYPE 2 ENABLE ACTION ( nOpca := 0 , oDlg:End() ) OF oDlg

	ACTIVATE MSDIALOG oDlg CENTERED

	If nopca == 0
		_lsai := .T.
	Else
		Reclock("SB1",.F.)
		npos := ascan(_alinhas,nlinha)
		If npos > 0
			SB1->B1_ZLINHA 	:= _aclinhas[npos][1]
		Else
			SB1->B1_ZLINHA := "  "
		Endif
		npos := ascan(_acategs,nCateg)
		If npos > 0
			SB1->B1_ZCCATEG := _accategs[npos][1]
		Else
			SB1->B1_ZCCATEG := "   "
		Endif
		npos := ascan(_amarcas,nmarca)
		If npos > 0
			SB1->B1_ZMARCAC := _acmarcas[npos][1]
		Else
			SB1->B1_ZMARCAC := "  "
		Endif
		npos := ascan(_aorigens,norigem)
		If npos > 0
			SB1->B1_ZORIGEM := _acorigens[npos][1]
		Else
			SB1->B1_ZORIGEM := "   "
		Endif

		SB1->B1_ZEAN13  := val(ALLTRIM(_cEan13))
		SB1->(Msunlock())

		Reclock("TRBF",.F.)
		TRBF->TRBF_DLINHA  	:= alltrim(nlinha)
		TRBF->TRBF_DCCAT 	:= alltrim(nCateg)
		TRBF->TRBF_DMARC 	:= alltrim(nmarca)
		TRBF->TRBF_DORIG 	:= alltrim(norigem)
		TRBF->TRBF_EAN13    :=ALLTRIM(_cEan13)
		TRBF->(Msunlock())

		oMark:oBrowse:Refresh(.T.)

		_lsai := .T.

	Endif

Enddo

Return

/*/
=============================================================================
{Protheus.doc} MGFATBQCA
Carrega array de combo
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGFATBQCA(_calias,_ccampcod,_ccampdesc,_ntipo)

Local _aitens := {}

(_calias)->(Dbsetorder(1))
(_calias)->(Dbgotop())

if _ntipo == 1
	aadd(_aitens,{"   ", "    "})
Else
	aadd(_aitens,"   ")
Endif

Do while .not. (_calias)->(Eof())

	if _ntipo == 1
		aadd(_aitens,{alltrim((_calias)->&_ccampcod),alltrim((_calias)->&_ccampdesc)})
	Else
		aadd(_aitens,alltrim((_calias)->&_ccampcod) + " - " + alltrim((_calias)->&_ccampdesc))
	Endif

	(_calias)->(Dbskip())

Enddo

Return _aitens

/*/
=============================================================================
{Protheus.doc} MGFATBQVP
Visualiza preços do produto no e-commerce
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGFATBQVP()

Local _aitens := {}

If TRBF->(Eof())
	u_MGFmsg("Não há produto para visualização, ajuste o filtro!")
	Return
Endif

If select("QRYPED") > 0
	Dbselectarea("QRYPED")
	Dbclosearea("QRYPED")
Endif

_cquery := " SELECT	DA1.DA1_CODTAB,DA0.DA0_DESCRI,DA1.DA1_PRCVEN	FROM DA1010 DA1 JOIN DA0010 " 
_cquery += " DA0 ON DA1.DA1_FILIAL = DA0.DA0_FILIAL AND DA1.DA1_CODTAB = DA0.DA0_CODTAB "
_cquery += "    WHERE DA1.DA1_CODPRO = '" + ALLTRIM(TRBF->TRBF_COD) +  "'" 
_cquery += " AND DA0.DA0_XENVEC	=	'1'"
_cquery += " AND DA0.DA0_ATIVO	=	'1'"
_cquery += " AND DA1.D_E_L_E_T_ <> '*'"
_cquery += " AND DA1.D_E_L_E_T_ <> '*'"
_cquery += " ORDER BY DA0.DA0_CODTAB "

TCQUERY _cquery NEW ALIAS "QRYPED"

DO While QRYPED->(!EOF())

	aadd(_aitens,{	alltrim(QRYPED->DA1_CODTAB) + " - " + alltrim(QRYPED->DA0_DESCRI),;
					transform(QRYPED->DA1_PRCVEN,"@E 999,999.99"),;
					transform(TRBF->TRBF_PESOM,"@E 999"),;
					transform(QRYPED->DA1_PRCVEN*val(TRBF->TRBF_PESOM),"@E 999,999.99")		 })
					
	QRYPED->(Dbskip())

Enddo

_ctitulo :=  "Tabelas de preço do produto " + ALLTRIM(TRBF->TRBF_COD) + " - " + ALLTRIM(TRBF->TRBF_DESC) + " para o E-commerce"
_aheaderec := {}
aadd(_aheaderec,"Tabela")
aadd(_aheaderec,"Preço Protheus" )
aadd(_aheaderec,"Peso médio" )
aadd(_aheaderec,"Preço OCC" )

U_MGListBox( _ctitulo , _aheaderec , _aitens , .T. , 1 )

Return

/*/
=============================================================================
{Protheus.doc} MGFATBQME
Visualiza estoques do Produto
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGFATBQME()

Local _aheaderec := {}
Local _acolec := {}
Local _afiliais := strtokarr2(getmv("MGFWSC27F",,"010016,010041,010044,010050,010066"),",")

If TRBF->(Eof())
	u_MGFmsg("Não há produto para visualização, ajuste o filtro!")
	Return
Endif

//Monta aheader
aadd(_aheaderec,"Filial")
aadd(_aheaderec,"Saldo Taura" )
aadd(_aheaderec,"Pedidos Protheus" )
aadd(_aheaderec,"Saldo Disponível" )
aadd(_aheaderec,"Multiplicador E-Commerce")
aadd(_aheaderec,"Saldo E-Commerce Kg")
aadd(_aheaderec,"Peso Médio")
aadd(_aheaderec,"Saldo E-Commerce Cx")

//Monta acols
For _ii := 1 to len(_afiliais)

	_acolfil := MGFATBQSS(_afiliais[_ii])

	aadd(_acolec,_acolfil)	

Next

//Apresenta itlist
If len(_acolec) > 0

	U_MGListBox( "Estoques do Ecommerce para o produto " + ALLTRIM(TRBF->TRBF_COD) + " - " +  ALLTRIM(TRBF->TRBF_DESC), _aheaderec , _acolec , .T. , 1 )

Else

	u_MGFmsg("Nenhum estoque localizado!","Atenção",,1)

Endif


Return



/*/
=============================================================================
{Protheus.doc} MGFATBQSS
Consulta de dados de estoque do produto
@author
Josué Danich
@since
10/03/2020
/*/
Static function MGFATBQSS(_cfilial)
	local aRetSaldo	:= {}
	local nPorcEcom	:= 0
	local _asaldos := {}
	local _nsaldo := 0
	local _oldfil := cfilant
	Local _nsaldoun := 0

	_cfilold := cfilant
	cfilant := _cfilial
 	nPorcEcom	:= superGetMv( "MGFECOM27B" , , 10 )

	aRetSaldo := {0,0}
	aRetSaldo := MGFATBQSZ(ALLTRIM(TRBF->TRBF_COD), "", cFilAnt, .T.)

	if aRetSaldo[1] > 0
		_nsaldo := round(( ( nPorcEcom / 100 ) * aRetSaldo[1] / val(TRBF->TRBF_PESOM) ),0)
		_nsaldoun := round(( ( nPorcEcom / 100 ) * aRetSaldo[1] ),0)
	endif

	_asaldos := {cfilant + " - " +  FWFilialName(,cfilant),aRetSaldo[2],aRetSaldo[3],aRetSaldo[1],nPorcEcom,_nsaldoun,val(TRBF->TRBF_PESOM),_nsaldo }

	cfilant := _oldfil

return _asaldos

/*/
=============================================================================
{Protheus.doc} MGFATBQSZ
Retorna saldos de produto
@author
Josué Danich
@since
10/03/2020
/*/
static function MGFATBQSZ( cB1Cod, cC5Num, cStockFil, lJobStock, dDtMin, dDtMax, _BlqEst )
	local cQueryProt	:= ""
	local nRetProt		:= 0
	local nRetProt2		:= 0
	local aArea			:= getArea()
	local aAreaSZJ		:= SZJ->(getArea())
	local aAreaSA1		:= SA1->(getArea())
	local aAreaSB1		:= SB1->(getArea())

	local aRet			:= {}
	local aRet2			:= {}
	local nSalProt		:= 0
	local nSalProt2		:= 0
	local nPesoMedio	:= 0
	local aRetStock		:= { 0 , 0 }

	local lRet			:= .F.
	local lFefo			:= .F.

	local nMGFDTMIN		:= 0
	local nMGFDTMAX		:= 0

	local dDataMin		:= CTOD("  /  /  ")
	local dDataMax		:= CTOD("  /  /  ")

	local nDtMin		:= superGetMv("MGF_DTMIN", , 0 )
	local nDtMax		:= superGetMv("MGF_DTMAX", , 0 )

	local nDtMinPr		:= superGetMv( "MGF_MINPR", , 0 )
	local nDtMaxPr		:= superGetMv( "MGF_MAXPR", , 0 )

	default lJobStock	:= .F.
	default cC5Num		:= space(06)
	default cStockFil	:= cFilAnt

	default dDtMin		:= CTOD("  /  /  ")
	default dDtMax		:= CTOD("  /  /  ")
	default _BlqEst		:= .F.

	if !empty( dDtMin )
		dDataMin := dDtMin
	endif

	if !empty( dDtMax )
		dDataMax := dDtMax
	endif

	if !empty( dDataMin ) .and. !empty( dDataMax )
		lFefo := .T.
	endif

	DBSelectArea('SZJ')
	SZJ->(DBSetOrder(1))
	SZJ->(DBSeek(xFilial('SZJ') + SC5->C5_ZTIPPED))

	// Para o tipo VE as datas nao importam na consulta ao Taura, mas na conta para debitar Pedidos do Protheus sim
	dDataMin := CTOD("  /  /  ")
	dDataMax := CTOD("  /  /  ")

	MGFFATBQY( @aRet, cStockFil, ALLTRIM(TRBF->TRBF_COD), .F., dDataMin, dDataMax )

	if aRet[2] > 0
		nPesoMedio := ( aRet[1] / aRet[2] )
	endif

	nRetProt := 0
	nSalProt := 0
	Conout("Parametros enviado para a função MGFFATBQW: "+cB1Cod +"," + cStockFil + "," + cC5Num )
	nRetProt := MGFFATBQW( cB1Cod, cStockFil, cC5Num, dDataMin, dDataMax, _BlqEst )
	nSalProt := ( aRet[01] - nRetProt )
	qTaura   := aRet[01]
	restArea(aAreaSB1)
	restArea(aAreaSA1)
	restArea(aAreaSZJ)
	restArea(aArea)

	aRetStock := { nSalProt,qTaura, nRetProt }
	Conout("[MGFFATBQ] - Resuldado da funcao MGFATBQSZ: Saldo: "+ Alltrim(Transform(nSalProt,"@E 999,999,999.9999")) + " Peso Medio: "+ Alltrim(Transform(nPesoMedio,"@E 999,999,999.9999")) )
return aRetStock


/*/
=============================================================================
{Protheus.doc} MGFFATBQW
Retorna saldos de pedidos de venda de produto
@author
Josué Danich
@since
10/03/2020
/*/
static function MGFFATBQW( cB1Cod, cStockFil, cC5Num, dDataMin, dDataMax, _BlqEst )
	local nSaldoPV		:= 0
	local cQueryProt	:= ""
	local cQryPv		:= getNextAlias()

	Conout("Parametros recebido na função MGFFATBQW: "+cB1Cod +"," + cStockFil + "," + cC5Num )

	// a query abaixo para trazer o saldo que o Protheus tem de pedidos, por produto
	// desconsidera o pedido que está sendo manipulado no momento ou analisado
	// mas considera todos os pedidos que estão com bloqueio seja de estoque o não no sistema
	// gerando erro. Criado um parametro no final para informar se deve ou não descosiderar
	// pedidos com bloqueio de estoque.

	cQueryProt  := "SELECT SUM(C6_QTDVEN) - SUM(C6_QTDENT) AS SALDO"
	cQueryProt  += " FROM " +	RetSqlName("SC6") + " C6 "
	cQueryProt +=  " INNER JOIN " + RetSqlName("SF4") + " F4 ON C6_TES			=	F4_CODIGO AND F4.D_E_L_E_T_	<>	'*' "

	cQueryProt  += " WHERE"
	cQueryProt  += "	    C6.D_E_L_E_T_	<>	'*'"
	cQueryProt	+= "	AND F4.F4_ESTOQUE	=	'S'"
	cQueryProt  += "	AND C6_PRODUTO		=	'" + cB1Cod		+ "'"
	cQueryProt  += "	AND C6_FILIAL		=	'" + cStockFil	+ "'"
	cQueryProt  += "  	AND C6_NOTA			=	'         '"
	cQueryProt  += "  	AND C6_BLQ			<>	'R'"

	if !empty( cC5Num )
		cQueryProt  += "  AND C6_NUM <> '" + cC5Num + "'"
	endif

	if !empty( dDataMin ) .and. !empty( dDataMax )
		cQueryProt  += " AND"
		cQueryProt  += "     ("
		cQueryProt  += "         C6.C6_ZDTMIN BETWEEN '" + dToS( dDataMin ) + "' AND '" + dToS( dDataMax ) + "'"
		cQueryProt  += "         OR"
		cQueryProt  += "         C6.C6_ZDTMAX BETWEEN '" + dToS( dDataMin ) + "' AND '" + dToS( dDataMax ) + "'"
		cQueryProt  += "     )"
	endif

	Conout("[MGFFATBQ] - Roda Query funcao MGFFATBQW: "+ cQueryProt )
	tcQuery cQueryProt New Alias (cQryPv)

	if !(cQryPv)->(EOF())
		nSaldoPV := (cQryPv)->SALDO
	endif

	If Select(cQryPv) > 0
		(cQryPv)->(DBCloseArea())
	EndIf
	Conout("[MGFFATBQ] - Resuldado da Query funcao MGFFATBQW saldo pvs: "+ Transform(nSaldoPV,"@E 999,999,999.9999") )

return nSaldoPV

/*
=====================================================================================
Programa.:              MGFFATBQY
Autor....:              Josué Danich Prestes
Data.....:              18/11/2019
Descricao / Objetivo:   Consulta de resposta de estoque assincrono na tabela ZFP
=====================================================================================
*/
Static Function MGFFATBQY(xRet,xFilProd,xProd,xFEFO,xDTInicial,xDTFinal)
              //MGFFATBQY( @aRet, cStockFil, cB1Cod, .F., dDataMin, dDataMax )

Local _aRet  := {0,0,0,0,0,"","",""}
Local _lret := .T.

If xFEFO
	_ctipo := "F"
Else
	_ctipo := "N"
Endif

//Verifica se tem resposta válida nos últimos 60 minutos
cQryZFQ := " select R_E_C_N_O_ AS REC FROM " + retsqlname("ZFQ") + " where d_e_l_e_t_ <> '*' and "
cQryZFQ += " ZFQ_PROD = '" + alltrim(xProd) + "' AND ZFQ_FILIAL = '" + xFilProd + "' and "
cQryZFQ += " ZFQ_STATUS = 'C' AND ZFQ_TIPOCO = '" + _ctipo + "' and " 
cQryZFQ += " ZFQ_DTRESP = '" + dtos(date()) + "' AND ZFQ_SECMID >= " + alltrim(str(seconds() - 3600)) 

If xFEFO

    cQryZFQ += " AND ZFQ_DTVALI = '" + dtos(xDTInicial) + "' AND ZFQ_DTVALF = '" + dtos(xDTFinal) + "'"

Endif

cQryZFQ += " ORDER BY  ZFQ_DTRESP,ZFQ_HRRESP DESC"

TcQuery cQryZFQ New Alias "QRYZFQ"


If !(QRYZFQ->(EOF()))

    //Retorna resposta válida
	ZFQ->(Dbgoto(QRYZFQ->REC))
	_aRet  := {ZFQ->ZFQ_ESTOQU,ZFQ->ZFQ_CAIXAS,ZFQ->ZFQ_PECAS ,0,ZFQ->ZFQ_PESO,ZFQ->ZFQ_SOLENV,ZFQ->ZFQ_UUID,ZFQ->ZFQ_RESREC}

Else

    //Retorna erro de consulta
	_aRet  := {0,0,0,0,0,"","",""}
	_lret := .F.

Endif

Dbselectarea("QRYZFQ")
Dbclosearea()

xret := _aret

Return _lret