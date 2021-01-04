#Include "PROTHEUS.CH"  
#Include "RWMAKE.CH"             
#Include "TopConn.ch"  
#Include "vkey.ch"

#DEFINE _ENTER CHR(13)+CHR(10)         



/*/
=============================================================================
{Protheus.doc} MGFFATBS
Tela administração de pedidos do Commerce
@author
Josué Danich
@since
10/03/2020
/*/
user function MGFFATBS()

Private _alista := {}
Private _otemp := nil

MGFATBSINI()

Return()

/*/
=============================================================================
{Protheus.doc} MGFATBSINI
Funcao que controla o processamento
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGFATBSINI()

Private cMarkado	:= GetMark()
Private lInverte	:= .F.



Private aCampos		:= {}

MGFATBSPRC()

Return()


/*/
=============================================================================
{Protheus.doc} MGFATBSPRC
Função que processa os pedidos
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGFATBSPRC()

Private cMarca   := GetMark()
Private aCampos  := {}
Private cPerg		:= 'MGFFATBS'

If Pergunte( cPerg , .T. )

	//================================================================================
	// Cria o arquivo Temporario para insercao dos dados selecionados.
	//================================================================================
	FWMSGRUN( , {|oproc| _nControle := MGFATBSARQ(oproc, .T., .F.) }, "Aguarde!" , 'Lendo Dados dos pedidos...' )

	MGFATBSTRS()//Função que monta a tela para processar

Endif


Return .T.

/*/
=============================================================================
{Protheus.doc} MGFATBSTRS
Função que monta a tela para processar
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGFATBSTRS()

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
Aadd( aBotoes , { "" , {|| MGFATBSC(01) 	}	, "" , "Atualizar"		 			 } )
Aadd( aBotoes , { "" , {|| MGFATBSC(02) 	}	, "" , "Pesquisar"		 			 } )
Aadd( aBotoes , { "" , {|| MGFATBSC(03) 	}	, "" , "Filtro"         			 } )
Aadd( aBotoes , { "" , {|| MGFATBSC(04) 	}	, "" , "Visualizar pedido"			 } )
Aadd( aBotoes , { "" , {|| MGFATBSC(06) 	}	, "" , "Reprocessar pedido"			 } )
Aadd( aBotoes , { "" , {|| MGFATBSC(05) 	}	, "" , "Cancela reserva Getnet"		 } )
Aadd( aBotoes , { "" , {|| MGFATBSC(11) 	}	, "" , "Legenda"       				 } )
Aadd( aBotoes , { "" , {|| MGFATBSC(12) 	}	, "" , "Exporta Excel"       		 } )

//================================================================================
// Faz o calculo automatico de dimensoes de objetos
//================================================================================
aSize := MSADVSIZE() 

//================================================================================
// Cria a tela para selecao dos pedidos
//================================================================================
_ctitulo := "CENTRAL DE PEDIDOS PARA ECOMMERCE"
		

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
	oMark:bMark				:= {|| MGFATBSINV( cMarkado , lInverte  ) }
	oMark:oBrowse:bAllMark	:= {|| MGFATBSALL( cMarkado  ) }
    oCol := oMark:oBrowse:aColumns[2]
    oCol:bData     := {|| U_MGFATBSCL() }
    oMark:oBrowse:aColumns[2]:=oCol

	oDlg1:lMaximized:=.T.

ACTIVATE MSDIALOG oDlg1 ON INIT ( EnchoiceBar(oDlg1,{|| MGFATBSC(02) },{|| nOpca := 2,oDlg1:End()},,aBotoes),;
                                  oPanel:Align:=CONTROL_ALIGN_TOP , oMark:oBrowse:Align:=CONTROL_ALIGN_ALLCLIENT , oMark:oBrowse:Refresh())


Return nOpca

/*/
=============================================================================
{Protheus.doc} MGFATBSPSQ
Funcao para pesquisa no arquivo temporario.
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGFATBSPSQ( oMark , cAlias )

Local oGet1		:= Nil
Local oDlg		:= Nil
Local cGet1		:= Space(40)
Local cComboBx1	:= ""
Local aComboBx1	:= {  "ID E-Commerce","Pedido Protheus"  }
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
{Protheus.doc} MGFATBSINV
Rotina para inverter a marcacao do registro posicionado.
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGFATBSINV( cMarca , lInverte  )

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
{Protheus.doc} MGFATBSALL
Chama Rotina para inverter a marcacao de todos os registros.
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGFATBSALL( cMarca  )

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
{Protheus.doc} MGFATBSARQ
Rotina para criação do arquivo temporário
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGFATBSARQ(oproc,_lini,_lcabec)

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
AADD( aEstru , { "TRBF_FILIA"   , 'C' , 06 , 0 } ) 
AADD( aEstru , { "TRBF_IDECO"   , 'C' , 50 , 0 } )  
AADD( aEstru , { "TRBF_PVPRO"	, 'C' , 10 , 0 } )
AADD( aEstru , { "TRBF_CLIEN"	, 'C' , 100 , 0 } )
AADD( aEstru , { "TRBF_DTENT"	, 'C' , 10 , 0 } )
AADD( aEstru , { "TRBF_DTPED"	, 'C' , 10 , 0 } )
AADD( aEstru , { "TRBF_VENDE"	, 'C' , 100 , 0 } )
AADD( aEstru , { "TRBF_OBS"		, 'C' , 250 , 0 } )
AADD( aEstru , { "TRBF_STATU"	, 'C' , 80 , 0 } )
AADD( aEstru , { "TRBF_DELET"	, 'C' , 01 , 0 } )


//================================================================================
// Armazena no array aCampos o nome, picture e descricao dos campos
//================================================================================
AADD( aCampos , { "TRBF_OK"		, "" , " "					, " "									} )
AADD( aCampos , { "TRBF_OK"		, "" , " "					, " "									} )
AADD( aCampos , { "TRBF_FILIA"	, "" , "Filial"		        , PesqPict( "SA1" , "A1_FILIAL" )	  		} )
AADD( aCampos , { "TRBF_IDECO"	, "" , "Id E-Commerce"	    , PesqPict( "SA1" , "A1_NOME" )			} )
AADD( aCampos , { "TRBF_PVPRO"	, "" , "Pedido Protheus"	, PesqPict( "SA1" , "A1_NOME" )	  		} )
AADD( aCampos , { "TRBF_DTPED"	, "" , "Data Pedido"	    , PesqPict( "SA1" , "A1_NOME" )	  		} )
AADD( aCampos , { "TRBF_DTENT"	, "" , "Data Entrega"	    , PesqPict( "SA1" , "A1_NOME" )	  		} )
AADD( aCampos , { "TRBF_CLIEN"	, "" , "Cliente"    		, PesqPict( "SA1" , "A1_NOME" )	  		} )
AADD( aCampos , { "TRBF_VENDE"	, "" , "Vendedor"	    	, PesqPict( "SA1" , "A1_NOME" )  		} )
AADD( aCampos , { "TRBF_OBS"	, "" , "OBS"	    		, PesqPict( "SA1" , "A1_NOME" )  		} )



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
_otemp:AddIndex( "CO", {"TRBF_IDECO"} )
_otemp:AddIndex( "DE", {"TRBF_PVPRO"} )

_otemp:Create()


//Filtra Filiais
If !empty(MV_PAR01)
	cFiltro += " AND XC5_FILIAL IN " + FormatIn(MV_PAR01,";")
Endif

//Filtra Id ecommerce
If !empty(MV_PAR02)
	cFiltro += " AND XC5_IDECOM >= '" + ALLTRIM(MV_PAR02) + "' AND XC5_IDECOM <= '" + ALLTRIM(MV_PAR03) + "' "
Endif

//Filtra pedidos de venda do Protheus
If !empty(MV_PAR04)
	cFiltro += " AND XC5_PVPROT >= '" + ALLTRIM(MV_PAR04) + "' AND XC5_PVPROT <= '" + ALLTRIM(MV_PAR05) + "' "
Endif

//Filtra CLIENTE
If !empty(MV_PAR06)
	cFiltro += " AND A1_COD >= '" + ALLTRIM(MV_PAR06) + "' AND A1_COD <= '" + ALLTRIM(MV_PAR08) + "' "
Endif

//Filtra LOJA
If !empty(MV_PAR07)
	cFiltro += " AND A1_LOJA >= '" + ALLTRIM(MV_PAR07) + "' AND A1_LOJA <= '" + ALLTRIM(MV_PAR09) + "' "
Endif

//Filtra Vendedor
If !empty(MV_PAR10)
	cFiltro += " AND XC5_VENDED >= '" + ALLTRIM(MV_PAR10) + "' AND XC5_VENDED <= '" + ALLTRIM(MV_PAR11) + "' "
Endif

//Filtra data de entrega
If !empty(MV_PAR12)
	cFiltro += " AND XC5_DTENTR >= '" + ALLTRIM(DTOS(MV_PAR12)) + "' AND XC5_DTENTR <= '" + ALLTRIM(DTOS(MV_PAR13)) + "' "
Endif

//Filtra status
If MV_PAR14 == 2 //Processado
	cFiltro += " AND XC5_STATUS = '3' "	
Endif

If MV_PAR14 == 3 //Erro
	cFiltro += " AND XC5_STATUS = '4' "	
Endif

If MV_PAR14 == 4 //Pendente
	cFiltro += " AND XC5_STATUS = '1' "	
Endif

//Filtra data do pedido
If !empty(MV_PAR15)
	cFiltro += " AND XC5_DTRECE >= '" + ALLTRIM(DTOS(MV_PAR15)) + "' AND XC5_DTRECE <= '" + ALLTRIM(DTOS(MV_PAR16)) + "' "
Endif
                                      
//================================================================================
// Verifica se ja existe um arquivo com mesmo nome, se sim deleta.
//================================================================================
If Select("QRYPED") > 0
	QRYPED->( DBCloseArea() )
EndIf

//================================================================================
// Query para selecao dos dados DOS pedidos
//================================================================================
_cquery := "SELECT XC5_FILIAL,XC5_CLIENT,XC5_PVPROT,XC5_VENDED,XC5_STATUS,XC5_IDECOM,XC5_DTENTR,XC5_DTRECE, "+_ENTER
_cquery += " UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(XC5_OBS, 2000, 1)) AS XC5_OBS, D_E_L_E_T_ AS XC5_DELET "+_ENTER
_cquery += " FROM "+RetSqlName("XC5")+" "+_ENTER
//_cquery += " WHERE D_E_L_E_T_ = ' ' "+_ENTER
//_cquery += " AND XC5_DTRECE >= '" + DTOS(DATE()-GETMV("MGFFATBSD",,30)) + "' "
_cquery += " WHERE XC5_DTRECE >= '" + DTOS(DATE()-GETMV("MGFFATBSD",,30)) + "' "
_cquery += cFiltro + _ENTER
_cquery += " ORDER BY XC5_FILIAL,XC5_IDECOM "+_ENTER
 

oproc:cCaption := ("Carregando query de pedidos...")
ProcessMessages()

TCQUERY _cquery NEW ALIAS "QRYPED"

oproc:cCaption := ("Contando os pedidos...")
ProcessMessages()

nQtdTit := 0
COUNT TO nQtdTit
QRYPED->(Dbgotop())
_npv:=1


DO While QRYPED->(!EOF())

	//Atualiza régua
	oproc:cCaption := ("Processando pedido... ["+ StrZero(_npv,6) +"] de ["+ StrZero(nQtdTit,6) +"]")
    _npv++
	ProcessMessages()

	SA1->(Dbsetorder(15)) //A1_ZCDECOM
	If SA1->(Dbseek(alltrim(QRYPED->XC5_CLIENT)))
		_cnome := alltrim(SA1->A1_COD) + " - " + alltrim(SA1->A1_NOME) + " - " + SA1->A1_DDD + "-" + SA1->A1_TEL
	Else
		_cnome := "  "
	Endif

	SA3->(Dbsetorder(1)) //A3_FILIAL+A3_COD
	If SA3->(Dbseek(xfilial("SA3")+QRYPED->XC5_VENDED))
		_cnomeve := SA3->A3_COD + " - " + alltrim(SA3->A3_NOME) + " - " + alltrim(SA3->A3_DDDTEL) + " - " + alltrim(SA3->A3_TEL)
	Else
		_cnomeve := "  "
	Endif

    Reclock("TRBF",.T.)
  	TRBF->TRBF_FILIA	:= QRYPED->XC5_FILIAL
	TRBF->TRBF_IDECO	:= QRYPED->XC5_IDECOM
	TRBF->TRBF_PVPRO   := QRYPED->XC5_PVPROT
	TRBF->TRBF_CLIEN	:= _cnome
	TRBF->TRBF_DTENT	:= dtoc(STOD(QRYPED->XC5_DTENTR))
	TRBF->TRBF_DTPED	:= dtoc(STOD(QRYPED->XC5_DTRECE))
 	TRBF->TRBF_VENDE	:= _cnomeve
	TRBF->TRBF_OBS		:= strtran(strtran(QRYPED->XC5_OBS,chr(10)," "),chr(13)," ")
	TRBF->TRBF_STATU	:= QRYPED->XC5_STATUS
	TRBF->TRBF_DELET	:= QRYPED->XC5_DELET


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
{Protheus.doc} MGFATBSPPV
Função para visualizar pedido
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGFATBSPPV()   

Private altera := .F.
Private ccadastro := "Visualizando pedido a partir da tela de central de pedidos do E-commerce"

If TRBF->TRBF_DELET == ' '
	If TRBF->(Eof())
		u_MGFmsg("Não há pedido para visualização, ajuste o filtro!")
		Return
	Endif

	DBSelectArea("SC5")
	SC5->( DBSetOrder(1) )
	If SC5->( DBSeek( TRBF->( TRBF_FILIA + TRBF_PVPRO ) ) )
		_cfilori := cfilant
		cfilant := alltrim(TRBF->TRBF_FILIA)
		MatA410(Nil, Nil, Nil, Nil, "A410Visual") 
		cfilant := _cfilori
	Else
		XC5->(Dbsetorder(1))
		If XC5->(Dbseek(ALLTRIM(TRBF->TRBF_FILIA)+TRBF->TRBF_IDECO))
			alert("OBS: (Se consta como incluido, pode ter sido excluido!)" + alltrim(XC5->XC5_OBS))
		Else
			alert("OBS: (da tela) " + alltrim(TRBF->TRBF_OBS))
		Endif
	EndIf
Else
	u_MGFmsg("Este Registro encontra-se Excluido, e não pode ser Visualizado")
Endif	
Return()

/*/
=============================================================================
{Protheus.doc} MGFATBSLegenda
Tela de significado de legendas
@author
Josué Danich
@since
10/03/2020
/*/
STATIC Function MGFATBSLegenda()
Local aLegenda := {}

aAdd(aLegenda, {"BR_VERMELHO"   ,"Pedido com erro"})
aAdd(aLegenda, {"BR_AMARELO"   	,"Pedido em processamento"})
aAdd(aLegenda, {"BR_VERDE"		,"Pedido incluido no Protheus"})
aAdd(aLegenda, {"BR_PRETO"		,"Pedido Excluido"})

BrwLegenda("Legenda","Legenda",aLegenda)

Return .T.

/*/
=============================================================================
{Protheus.doc} MGFATBSC
Chamada de itens do menu
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGFATBSC(_nopc)

Local oproc


Do Case

Case _nopc == 1 
	//Atualizar
	fwmsgrun(,{ || MGFATBSAT() }, "Aguarde...","Carregando dados...")

Case _nopc == 2
	//Pesquisar
	fwmsgrun(,{ || MGFATBSPSQ(oMark,"TRBF") }, "Aguarde...","Carregando dados...")
	
Case _nopc == 3
	//Filtro
	fwmsgrun(,{ || MGFATBSF() }, "Aguarde...","Carregando dados...")
	
Case _nopc == 4
	//Visualizar pedido
	fwmsgrun(,{ || MGFATBSPPV() }, "Aguarde...","Carregando dados...")

Case _nopc == 5
	//Cancela Reserva
	fwmsgrun(,{ || MGFFATCRE() }, "Aguarde...","Carregando dados...")

Case _nopc == 6
	//Reprocessa pedido
	fwmsgrun(,{ || MGFATBSVP() }, "Aguarde...","Carregando dados...")

Case _nopc == 7 
	//Log Integrações pedido
	fwmsgrun(,{ || MGFATBSLI() }, "Aguarde...","Carregando dados...")

Case _nopc == 10
	//Reenvia pedido
	fwmsgrun( , {|oproc| MGFATBSRC() }, "Aguarde!" , 'Carregando dados...' )
	
Case _nopc == 8
	//Reenvia limite de crédito
	fwmsgrun(,{ || MGFATBSRJ() }, "Aguarde...","Carregando dados...")

Case _nopc == 11
	//Legenda
	fwmsgrun(,{ || MGFATBSLegenda() }, "Aguarde...","Carregando dados...")

Case _nopc == 12
	//Exporta para o excel
	fwmsgrun(,{ || MGFATBSEC() }, "Aguarde...","Carregando dados...")
	
Otherwise
	u_MGFmsg("Função em Desenvolvimento","Atenção",,1)
	
EndCase

Return

/*/
=============================================================================
{Protheus.doc} MGFATBSLI
Visualiza log e integração
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGFATBSLI()
Local _asits := {}
Local _aheader := {"Integração","Data","Hora","Status"}

aadd(_asits,{"Tracking de pedido","N/C","N/C","Log não disponível"})

U_MGListBox( "Integrações do Ecommerce" , _aheader , _asits , .T. , 1 )

Return

/*/
=============================================================================
{Protheus.doc} MGFATBSEC
Exporta browse para o excel
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGFATBSEC(oproc)

Local _acolec := {}
Local _aheaderec := {}

AADD( aCampos , { "TRBF_FILIA"	, "" , "Filial"		        , PesqPict( "SA1" , "A1_FILIAL" )	  		} )
AADD( aCampos , { "TRBF_IDECO"	, "" , "Id E-Commerce"	    , PesqPict( "SA1" , "A1_NOME" )			} )
AADD( aCampos , { "TRBF_PVPRO"	, "" , "Pedido Protheus"	, PesqPict( "SA1" , "A1_NOME" )	  		} )
AADD( aCampos , { "TRBF_DTPED"	, "" , "Data Pedido"	    , PesqPict( "SA1" , "A1_NOME" )	  		} )
AADD( aCampos , { "TRBF_DTENT"	, "" , "Data Entrega"	    , PesqPict( "SA1" , "A1_NOME" )	  		} )
AADD( aCampos , { "TRBF_CLIEN"	, "" , "Cliente"    		, PesqPict( "SA1" , "A1_NOME" )	  		} )
AADD( aCampos , { "TRBF_VENDE"	, "" , "Vendedor"	    	, PesqPict( "SA1" , "A1_NOME" )  		} )
AADD( aCampos , { "TRBF_OBS"	, "" , "OBS"	    		, PesqPict( "SA1" , "A1_NOME" )  		} )

	//Monta aheader
	aadd(_aheaderec,"Filial")
	aadd(_aheaderec,"Id E-Commerce" )
	aadd(_aheaderec,"Pedido Protheus" )
	aadd(_aheaderec,"Data Pedido")
	aadd(_aheaderec,"Data Entrega")
	aadd(_aheaderec,"Cliente")
	aadd(_aheaderec,"Vendedor")
	aadd(_aheaderec,"OBS")
	
	//Monta acols
	_nposi := TRBF->(Recno())
	TRBF->(Dbgotop())

	Do while !(TRBF->(Eof()))

		If IsMark( "TRBF_OK" , cMarkado )

			aadd(_acolec, {	TRBF->TRBF_FILIA,;
    				TRBF->TRBF_IDECO,;
    				TRBF->TRBF_PVPRO,;
    				TRBF->TRBF_DTPED,;
    				TRBF->TRBF_DTENT,;
    				TRBF->TRBF_CLIEN,;
    				TRBF->TRBF_VENDE,;
    				TRBF->TRBF_OBS } )

		Endif

		TRBF->(Dbskip())

	Enddo

	//Apresenta itlist
	If len(_acolec) > 0

		U_MGListBox( "Pedidos do Ecommerce" , _aheaderec , _acolec , .T. , 1 )

	Else

		u_MGFmsg("Nenhum registro selecionado!","Atenção",,1)

	Endif

	TRBF->(Dbgoto(_nposi))

Return

/*/
=============================================================================
{Protheus.doc} MGFATBSF
Carrega novo filtro
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGFATBSF(oproc)

If !Pergunte( cPerg , .T. )
	Return
EndIf
       
//================================================================================
// Cria o arquivo Temporario para insercao dos dados selecionados.
//================================================================================
FWMSGRUN( , {|oproc| _nControle := MGFATBSARQ(oproc, .T.) }, "Aguarde!" , 'Lendo Dados dos pedidos...' )

Return

/*/
=============================================================================
{Protheus.doc} MGFATBSAT
Atualiza tela
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGFATBSAT(oproc)

//================================================================================
// Cria o arquivo Temporario para insercao dos dados selecionados.
//================================================================================
FWMSGRUN( , {|oproc| _nControle := MGFATBSARQ(oproc, .T.) }, "Aguarde!" , 'Lendo Dados dos pedidos...' )

Return

/*/
=============================================================================
{Protheus.doc} MGFATBSCL
Retorna cor e legenda
@author
Josué Danich
@since
10/03/2020
/*/
User Function MGFATBSCL()

Local _ccor := "BR_VERDE"

If alltrim(TRBF->TRBF_STATU) == '4'
	_ccor := "BR_VERMELHO"
Endif

If alltrim(TRBF->TRBF_STATU) == '1' .OR. alltrim(TRBF->TRBF_STATU) == '2'
	_ccor := "BR_AMARELO"
Endif

If TRBF->TRBF_DELET == '*'
	_ccor := "BR_PRETO"
Endif

Return _ccor

/*/
=============================================================================
{Protheus.doc} MGFATBSVP
Marca pedido para reprocessamento
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGFATBSVP()

If TRBF->TRBF_DELET == ' '
	If ALLTRIM(TRBF->TRBF_STATU) == "3"
		u_MGFmsg("Pedido já processado!")
	Else
		XC5->(DBsetorder(1)) //XC5_FILIAL + XC5_IDECOM
		If XC5->(Dbseek(ALLTRIM(TRBF->TRBF_FILIAL)+TRBF->TRBF_IDECO))
			Reclock("XC5",.F.)
			XC5->XC5_STATUS := "1"
			XC5->(Msunlock())
			Reclock("TRBF",.F.)
			TRBF->TRBF_STATU := "1"
			TRBF->(Msunlock())
			ProcessMessages()
		Else
			u_MGFmsg("Falha na gravação do registro!")
		Endif
	Endif
ELSE	
	u_MGFmsg("Este Registro encontra-se Excluido, e não pode ser Processado")
Endif

Return

/*/
=============================================================================
{Protheus.doc} MGFFATCRE
Cancela reserva de cartão do pedido
@author
Josué Danich
@since
18/06/2020
/*/
Static function MGFFATCRE()

local cAccessTok	:= ""

//Testa para ver se reserva já não está cancelada ou processada
ZE6->(Dbsetorder(2)) //ZE6_FILIAL+ZE6_PEDIDO
If ZE6->(Dbseek( ALLTRIM(TRBF->( TRBF_FILIA + TRBF_PVPRO ) ))) .AND. ZE6->ZE6_STATUS = '5'

	u_MGFmsg("Reserva já possui cancelamento!","Atenção",,1)
	RETURN

Endif

If !(u_MGFmsg("Deseja cancelar a reserva de cartão de crédito do pedido " +  TRBF->TRBF_IDECO + "?","Atenção",,1,2,2))

	u_MGFmsg("Processo cancelado!","Atenção",,1)
	RETURN

Endif

cfilori := cfilant
cempori := cempant
cfilant := ALLTRIM(TRBF->TRBF_FILIAL)
cempant := substr(ALLTRIM(TRBF->TRBF_FILIAL),1,2)

XC5->(DBsetorder(1)) //XC5_FILIAL + XC5_IDECOM
If XC5->(Dbseek(ALLTRIM(TRBF->TRBF_FILIAL)+TRBF->TRBF_IDECO))

	cAccessTok := u_authGtnt() // Retorna Token para utilizar os metodos da GetNet
	
	if !empty( cAccessTok )

	
		if  XC5->XC5_DTRECE  == dDataBase
	
			// Mesmo dia - Cancelamento D + 0
			aCancel := u_canGtnt0( cAccessTok, allTrim( XC5->XC5_PAYMID ), int( XC5->XC5_VALCAU ), XC5->XC5_FILIAL + XC5->XC5_PVPROT )

			if aCancel[1]
	
				oCancel := nil
				if fwJsonDeserialize( aCancel[2], @oCancel )
	
					cUpdZE6	:= ""

					cUpdZE6 := "UPDATE " + retSQLName("ZE6")								+ CRLF
					cUpdZE6 += "	SET"													+ CRLF
					cUpdZE6 += " 		ZE6_STATUS = '5'"									+ CRLF
					cUpdZE6 += " WHERE"														+ CRLF
					cUpdZE6 += " 		ZE6_NSU	=	'" + allTrim( XC5->XC5_NSU )	+ "'"	+ CRLF

					tcSQLExec( cUpdZE6 )

					u_MGFmsg("Cancelamento realizado com sucesso","Atenção",,1)

				else
					
					u_MGFmsg("Falha no cancelamento!","Atenção",,1)

				endif

			else
				
				u_MGFmsg("Falha no cancelamento!","Atenção",,1)
			
			endif
		
		else
	
			// SOLICITA - Cancelamento D + N
			aCancel := u_canGtntN( cAccessTok, allTrim( XC5->XC5_PAYMID ), int( XC5->XC5_VALCAU ), XC5->XC5_FILIAL + XC5->XC5_PVPROT )
	
			if aCancel[1]

				cUpdZE6	:= ""

				cUpdZE6 := "UPDATE " + retSQLName("ZE6")								+ CRLF
				cUpdZE6 += "	SET"													+ CRLF
				cUpdZE6 += " 		ZE6_STATUS = '5'"									+ CRLF
				cUpdZE6 += " WHERE"														+ CRLF
				cUpdZE6 += " 		ZE6_NSU	=	'" + allTrim( XC5->XC5_NSU )	+ "'"	+ CRLF

				tcSQLExec( cUpdZE6 )
		
				u_MGFmsg("Cancelamento realizado com sucesso","Atenção",,1)
		
			
			else
				
				u_MGFmsg("Falha no cancelamento!","Atenção",,1)

			endif
		
		endif

	else
		
		u_MGFmsg("Falha de autenticação na Getnet","Atenção",,1)

	endif

else
	
	u_MGFmsg("Falha ao localizar pedido!","Atenção",,1)	

Endif

cfilant := cfilori
cempant := cempori
	
return