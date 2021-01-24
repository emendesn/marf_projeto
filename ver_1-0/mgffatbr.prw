#Include "PROTHEUS.CH"  
#Include "RWMAKE.CH"             
#Include "TopConn.ch"  
#Include "vkey.ch"

#DEFINE _ENTER CHR(13)+CHR(10)         



/*/
=============================================================================
{Protheus.doc} MGFFATBR
Tela administração de clientes do Commerce
@author
Josué Danich
@since
10/03/2020
/*/
user function MGFFATBR()

Private _alista := {}
Private _otemp := nil

MGFATBRINI()

Return()

/*/
=============================================================================
{Protheus.doc} MGFATBRINI
Funcao que controla o processamento
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGFATBRINI()

Private cMarkado	:= GetMark()
Private lInverte	:= .F.



Private aCampos		:= {}

MGFATBRPRC()

Return()


/*/
=============================================================================
{Protheus.doc} MGFATBRPRC
Função que processa os clientes
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGFATBRPRC()

Private cMarca   := GetMark()
Private aCampos  := {}
Private cPerg		:= 'MGFFATBR'

If Pergunte( cPerg , .T. )

	//================================================================================
	// Cria o arquivo Temporario para insercao dos dados selecionados.
	//================================================================================
	FWMSGRUN( , {|oproc| _nControle := MGFATBRARQ(oproc, .T., .F.) }, "Aguarde!" , 'Lendo Dados dos clientes...' )

	MGFATBRTRS()//Função que monta a tela para processar

Endif


Return .T.

/*/
=============================================================================
{Protheus.doc} MGFATBRTRS
Função que monta a tela para processar
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGFATBRTRS()

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
Aadd( aBotoes , { "" , {|| MGFATBRC(01) 	}	, "" , "Atualizar"		 			 } )
Aadd( aBotoes , { "" , {|| MGFATBRC(02) 	}	, "" , "Pesquisar"		 			 } )
Aadd( aBotoes , { "" , {|| MGFATBRC(03) 	}	, "" , "Filtro"         			 } )
Aadd( aBotoes , { "" , {|| MGFATBRC(04) 	}	, "" , "Visualizar Cliente"			 } )
Aadd( aBotoes , { "" , {|| MGFATBRC(05)		}	, "" , "Visualiza Lim Crédito"		 } )
Aadd( aBotoes , { "" , {|| MGFATBRC(07) 	}	, "" , "Log Integrações"    		 } )
Aadd( aBotoes , { "" , {|| MGFATBRC(10) 	}	, "" , "Reenvia Cliente"   			 } )
Aadd( aBotoes , { "" , {|| MGFATBRC(08) 	}	, "" , "Reenvia Lim Crédito"   		 } )
Aadd( aBotoes , { "" , {|| MGFATBRC(11) 	}	, "" , "Legenda"       				 } )
Aadd( aBotoes , { "" , {|| MGFATBRC(12) 	}	, "" , "Exporta Excel"       		 } )

//================================================================================
// Faz o calculo automatico de dimensoes de objetos
//================================================================================
aSize := MSADVSIZE() 

//================================================================================
// Cria a tela para selecao dos Clientes
//================================================================================
_ctitulo := "CENTRAL DE CLIENTES PARA ECOMMERCE"
		

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
	oMark:bMark				:= {|| MGFATBRINV( cMarkado , lInverte  ) }
	oMark:oBrowse:bAllMark	:= {|| MGFATBRALL( cMarkado  ) }
    oCol := oMark:oBrowse:aColumns[2]
    oCol:bData     := {|| U_MGFATBRCL() }
    oMark:oBrowse:aColumns[2]:=oCol

	oDlg1:lMaximized:=.T.

ACTIVATE MSDIALOG oDlg1 ON INIT ( EnchoiceBar(oDlg1,{|| MGFATBRC(02) },{|| nOpca := 2,oDlg1:End()},,aBotoes),;
                                  oPanel:Align:=CONTROL_ALIGN_TOP , oMark:oBrowse:Align:=CONTROL_ALIGN_ALLCLIENT , oMark:oBrowse:Refresh())


Return nOpca

/*/
=============================================================================
{Protheus.doc} MGFATBRPSQ
Funcao para pesquisa no arquivo temporario.
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGFATBRPSQ( oMark , cAlias )

Local oGet1		:= Nil
Local oDlg		:= Nil
Local cGet1		:= Space(40)
Local cComboBx1	:= ""
Local aComboBx1	:= { "Codigo" , "Nome","Id E-Commerce","Req E-Commerce","CNPJ"  }
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
			TRBF->( DBSetOrder(nI) )
			
			MsSeek( cGet1 , .T. )
			
			oMark:oBrowse:Refresh( .T. )
			
		EndIf
		
	Next nI
	
EndIf

Return()

/*/
=============================================================================
{Protheus.doc} MGFATBRINV
Rotina para inverter a marcacao do registro posicionado.
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGFATBRINV( cMarca , lInverte  )

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
{Protheus.doc} MGFATBRALL
Chama Rotina para inverter a marcacao de todos os registros.
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGFATBRALL( cMarca  )

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
{Protheus.doc} MGFATBRARQ
Rotina para criação do arquivo temporário
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGFATBRARQ(oproc,_lini,_lcabec)

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
AADD( aEstru , { "TRBF_DTCAD"   , 'C' , 10 , 0 } ) 
AADD( aEstru , { "TRBF_COD"	    , 'C' , 06 , 0 } )  
AADD( aEstru , { "TRBF_IDCOM"	, 'C' , 20 , 0 } )
AADD( aEstru , { "TRBF_SRCOM"	, 'C' , 20 , 0 } )
AADD( aEstru , { "TRBF_NOME"	, 'C' , 40 , 0 } )
AADD( aEstru , { "TRBF_NREDU"	, 'C' , 20 , 0 } )
AADD( aEstru , { "TRBF_CGC"		, 'C' , 14 , 0 } )
AADD( aEstru , { "TRBF_TELE"	, 'C' , 50 , 0 } )
AADD( aEstru , { "TRBF_END"		, 'C' , 80 , 0 } )
AADD( aEstru , { "TRBF_CIDAD"	, 'C' , 50 , 0 } )
AADD( aEstru , { "TRBF_UF"		, 'C' , 02 , 0 } )
AADD( aEstru , { "TRBF_BLQ"		, 'C' , 01 , 0 } )


//================================================================================
// Armazena no array aCampos o nome, picture e descricao dos campos
//================================================================================
AADD( aCampos , { "TRBF_OK"		, "" , " "					, " "										} )
AADD( aCampos , { "TRBF_OK"		, "" , " "					, " "										} )
AADD( aCampos , { "TRBF_COD"	, "" , "Código"		        , PesqPict( "SA1" , "A1_COD" )	  		} )
AADD( aCampos , { "TRBF_DTCAD"	, "" , "Data Cadastro"	    , PesqPict( "SA1" , "A1_DTCAD" )	  		} )
AADD( aCampos , { "TRBF_IDCOM"	, "" , "ID Ecommerce"    	, PesqPict( "SA1" , "A1_NOME" )	  		} )
AADD( aCampos , { "TRBF_SRCOM"	, "" , "SR Ecommerce"    	, PesqPict( "SA1" , "A1_NOME" )	  		} )
AADD( aCampos , { "TRBF_NOME"	, "" , "Nome"			    , PesqPict( "SA1" , "A1_NOME" )	  		} )
AADD( aCampos , { "TRBF_NREDU"	, "" , "Nome Fantasia"	    , PesqPict( "SA1" , "A1_NREDUZ" )  		} )
AADD( aCampos , { "TRBF_CGC"	, "" , "CNPJ"		   		 , PesqPict( "SA1" , "A1_CGC" )	  		} )
AADD( aCampos , { "TRBF_TELE"	, "" , "Telefone"	    	, PesqPict( "SA1" , "A1_BAIRRO" ) 		} )
AADD( aCampos , { "TRBF_END"	, "" , "Endereço"		    , PesqPict( "SA1" , "A1_END" )	  		} )
AADD( aCampos , { "TRBF_CIDAD"	, "" , "Cidade"			    , PesqPict( "SA1" , "A1_BAIRRO" )	  		} )
AADD( aCampos , { "TRBF_UF"		, "" , "Estado"			    , PesqPict( "SA1" , "A1_EST" )	  		} )



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
_otemp:AddIndex( "DE", {"TRBF_NOME"} )
_otemp:AddIndex( "IC", {"TRBF_IDCOM"} )
_otemp:AddIndex( "SC", {"TRBF_SRCOM"} )
_otemp:AddIndex( "CG", {"TRBF_CGC"} )

_otemp:Create()

//Filtra Data de cadastro
If !empty(MV_PAR01)
	cFiltro += " AND A1_DTCAD >= '" + DTOS(MV_PAR01) + "' AND A1_DTCAD <= '" + DTOS(MV_PAR02) + "' "
Endif

//Filtra código de cliente
If !empty(MV_PAR03)
	cFiltro += " AND A1_COD >= '" + ALLTRIM(MV_PAR03) + "' AND A1_COD <= '" + ALLTRIM(MV_PAR04) + "' "
Endif

//Filtra nomes de cliente
If !empty(MV_PAR05)
	cFiltro += " AND A1_NOME >= '" + ALLTRIM(MV_PAR05) + "' AND A1_NOME <= '" + ALLTRIM(MV_PAR06) + "' "
Endif

//Filtra IDCOMMERCE
If !empty(MV_PAR07)
	cFiltro += " AND A1_ZCDECOM >= '" + ALLTRIM(MV_PAR07) + "' AND A1_ZCDECOM <= '" + ALLTRIM(MV_PAR08) + "' "
Endif

//Filtra SR COMMERCE
If !empty(MV_PAR09)
	cFiltro += " AND A1_ZCDEREQ >= '" + ALLTRIM(MV_PAR09) + "' AND A1_ZCDEREQ <= '" + ALLTRIM(MV_PAR10) + "' "
Endif

//Filtra CNPJ
If !empty(MV_PAR11)
	cFiltro += " AND A1_CGC >= '" + ALLTRIM(MV_PAR11) + "' AND A1_CGC <= '" + ALLTRIM(MV_PAR12) + "' "
Endif

//Filtra UFs
If !empty(MV_PAR13)
	cFiltro += " AND A1_EST IN " +  FormatIn( alltrim(MV_PAR13), ";" )	
Endif


                                      
//================================================================================
// Verifica se ja existe um arquivo com mesmo nome, se sim deleta.
//================================================================================
If Select("QRYPED") > 0
	QRYPED->( DBCloseArea() )
EndIf

//================================================================================
// Query para selecao dos dados DOS clienteS
//================================================================================
_cquery := "SELECT A1_MSBLQL,A1_COD,A1_ZCDECOM,A1_ZCDEREQ,A1_NOME,A1_NREDUZ,A1_CGC,A1_MUN,A1_END,A1_TEL,A1_DDD,A1_CEP,A1_EST,A1_DTCAD "+_ENTER
_cquery += " FROM "+RetSqlName("SA1")+" "+_ENTER
_cquery += " WHERE D_E_L_E_T_ = ' ' "+_ENTER
_cquery += " AND A1_ZCDEREQ <> ' '"+_ENTER
_cquery += " AND A1_COD <> '000095' AND A1_PESSOA = 'J' "
_cquery += cFiltro + _ENTER
_cquery += " ORDER BY A1_COD,A1_LOJA "+_ENTER
 

oproc:cCaption := ("Carregando query de clientes...")
ProcessMessages()

TCQUERY _cquery NEW ALIAS "QRYPED"

oproc:cCaption := ("Contando os clientes...")
ProcessMessages()

nQtdTit := 0
COUNT TO nQtdTit
QRYPED->(Dbgotop())
_npv:=1


DO While QRYPED->(!EOF())

	//Atualiza régua
	oproc:cCaption := ("Processando cliente... ["+ StrZero(_npv,6) +"] de ["+ StrZero(nQtdTit,6) +"]")
    _npv++
	ProcessMessages()
	

    Reclock("TRBF",.T.)
  	TRBF->TRBF_COD	    := QRYPED->A1_COD
	TRBF->TRBF_DTCAD    := DTOC(STOD(QRYPED->A1_DTCAD))
	TRBF->TRBF_IDCOM	:= QRYPED->A1_ZCDECOM
	TRBF->TRBF_SRCOM	:= QRYPED->A1_ZCDEREQ
 	TRBF->TRBF_NOME		:= QRYPED->A1_NOME
	TRBF->TRBF_NREDU	:= QRYPED->A1_NREDUZ
	TRBF->TRBF_CGC		:= QRYPED->A1_CGC
	TRBF->TRBF_END		:= QRYPED->A1_END
	TRBF->TRBF_CIDAD	:= QRYPED->A1_MUN
	TRBF->TRBF_TELE		:= ALLTRIM(QRYPED->A1_DDD) + " - " + ALLTRIM(QRYPED->A1_TEL)
	TRBF->TRBF_UF		:= QRYPED->A1_EST  
	TRBF->TRBF_BLQ		:= QRYPED->A1_MSBLQL	

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
{Protheus.doc} MGFATBRPPV
Função para visualizar cliente
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGFATBRPPV()   

Private altera := .F.
Private ccadastro := "Visualizando cliente a partir da tela de central de clientes do E-commerce"

If TRBF->(Eof())
	u_MGFmsg("Não há cliente para visualização, ajuste o filtro!")
	Return
Endif

SA1->( DBSetOrder(1) ) //B1_FILIAL+B1_COD
If SA1->( DBSeek( xfilial("SA1") + TRBF->TRBF_COD ) ) 
	mata030({},2)
EndIf

Return()

/*/
=============================================================================
{Protheus.doc} MGFATBRLegenda
Tela de significado de legendas
@author
Josué Danich
@since
10/03/2020
/*/
STATIC Function MGFATBRLegenda()
Local aLegenda := {}

aAdd(aLegenda, {"BR_VERMELHO"   ,"Cliente bloqueado"})
aAdd(aLegenda, {"BR_AMARELO"   	,"Cliente com pendências"})
aAdd(aLegenda, {"BR_AZUL"		,"Cliente com falha de integração"})
aAdd(aLegenda, {"BR_VERDE"		,"Cliente ativo"})

BrwLegenda("Legenda","Legenda",aLegenda)

Return .T.

/*/
=============================================================================
{Protheus.doc} MGFATBRC
Chamada de itens do menu
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGFATBRC(_nopc)

Local oproc


Do Case

Case _nopc == 1 
	//Atualizar
	fwmsgrun(,{ || MGFATBRAT() }, "Aguarde...","Carregando dados...")

Case _nopc == 2
	//Pesquisar
	fwmsgrun(,{ || MGFATBRPSQ(oMark,"TRBF") }, "Aguarde...","Carregando dados...")
	
Case _nopc == 3
	//Filtro
	fwmsgrun(,{ || MGFATBRF() }, "Aguarde...","Carregando dados...")
	
Case _nopc == 4
	//Visualizar cliente
	fwmsgrun(,{ || MGFATBRPPV() }, "Aguarde...","Carregando dados...")

Case _nopc == 5
	//Visualiza limite de crédito
	fwmsgrun(,{ || MGFATBRVP() }, "Aguarde...","Carregando dados...")

Case _nopc == 7 
	//Log Integrações cliente
	fwmsgrun(,{ || MGFATBRLI() }, "Aguarde...","Carregando dados...")

Case _nopc == 10
	//Reenvia cliente
	fwmsgrun( , {|oproc| MGFATBRRC() }, "Aguarde!" , 'Carregando dados...' )
	
Case _nopc == 8
	//Reenvia limite de crédito
	fwmsgrun(,{ || MGFATBRRJ() }, "Aguarde...","Carregando dados...")

Case _nopc == 11
	//Legenda
	fwmsgrun(,{ || MGFATBRLegenda() }, "Aguarde...","Carregando dados...")

Case _nopc == 12
	//Exporta para o excel
	fwmsgrun(,{ || MGFATBREC() }, "Aguarde...","Carregando dados...")
	
Otherwise
	u_MGFmsg("Função em Desenvolvimento","Atenção",,1)
	
EndCase

Return

/*/
=============================================================================
{Protheus.doc} MGFATBRLI
Visualiza log e integração
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGFATBRLI()
Local _asits := {}
Local _aheader := {"Integração","Data","Hora","Status"}

aadd(_asits,{"Cadastro Cliente","N/C","N/C","Log não disponível"})
aadd(_asits,{"Limite de crédito","N/C","N/C","Log não disponível"})

U_MGListBox( "Integrações do Ecommerce" , _aheader , _asits , .T. , 1 )

Return

/*/
=============================================================================
{Protheus.doc} MGFATBREC
Exporta browse para o excel
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGFATBREC(oproc)

Local _acolec := {}
Local _aheaderec := {}

	//Monta aheader
	aadd(_aheaderec,"Código")
	aadd(_aheaderec,"Data Cadastro" )
	aadd(_aheaderec,"ID E-commerce" )
	aadd(_aheaderec,"SR E-commerce")
	aadd(_aheaderec,"Nome")
	aadd(_aheaderec,"Nome Fantasia")
	aadd(_aheaderec,"CNPJ")
	aadd(_aheaderec,"Telefone")
	aadd(_aheaderec,"Endereço")
	aadd(_aheaderec,"Cidade")
	aadd(_aheaderec,"Estado")
	
	//Monta acols
	_nposi := TRBF->(Recno())
	TRBF->(Dbgotop())

	Do while !(TRBF->(Eof()))

		If IsMark( "TRBF_OK" , cMarkado )

			aadd(_acolec, {	TRBF->TRBF_COD,;
    				TRBF->TRBF_DTCAD,;
    				TRBF->TRBF_IDCOM,;
    				TRBF->TRBF_SRCOM,;
    				TRBF->TRBF_NOME,;
    				TRBF->TRBF_NREDU,;
    				TRBF->TRBF_CGC,;
    				TRBF->TRBF_TELE,;
					TRBF->TRBF_END,;
					TRBF->TRBF_CIDAD,;
					TRBF->TRBF_UF } )

		Endif

		TRBF->(Dbskip())

	Enddo

	//Apresenta itlist
	If len(_acolec) > 0

		U_MGListBox( "Clientes do Ecommerce" , _aheaderec , _acolec , .T. , 1 )

	Else

		u_MGFmsg("Nenhum registro selecionado!","Atenção",,1)

	Endif

	TRBF->(Dbgoto(_nposi))

Return

/*/
=============================================================================
{Protheus.doc} MGFATBRF
Carrega novo filtro
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGFATBRF(oproc)

If !Pergunte( cPerg , .T. )
	Return
EndIf
       
//================================================================================
// Cria o arquivo Temporario para insercao dos dados selecionados.
//================================================================================
FWMSGRUN( , {|oproc| _nControle := MGFATBRARQ(oproc, .T.) }, "Aguarde!" , 'Lendo Dados dos Clientes...' )

Return

/*/
=============================================================================
{Protheus.doc} MGFATBRAT
Atualiza tela
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGFATBRAT(oproc)

//================================================================================
// Cria o arquivo Temporario para insercao dos dados selecionados.
//================================================================================
FWMSGRUN( , {|oproc| _nControle := MGFATBRARQ(oproc, .T.) }, "Aguarde!" , 'Lendo Dados dos Clientes...' )

Return

/*/
=============================================================================
{Protheus.doc} MGFATBRCL
Retorna cor e legenda
@author
Josué Danich
@since
10/03/2020
/*/
User Function MGFATBRCL()

Local _ccor := "BR_VERDE"

If TRBF->TRBF_BLQ == '1'
	_ccor := "BR_VERMELHO"
Endif

Return _ccor

/*/
=============================================================================
{Protheus.doc} MGFATBRVP
Visualiza limite de crédito do Cliente no e-commerce
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGFATBRVP()

Local _aitens := {}
local cQWSC31 := ""

If TRBF->(Eof())
	u_MGFmsg("Não há Cliente para visualização, ajuste o filtro!")
	Return
Endif

If select("QRYPED") > 0
	Dbselectarea("QRYPED")
	Dbclosearea("QRYPED")
Endif

cQWSC31 := "SELECT "									+ CRLF
cQWSC31 += "     A1_ZCDEREQ, "							+ CRLF
cQWSC31 += "     A1_ZCDECOM, "							+ CRLF
cQWSC31 += "     A1_VENCLC, "							+ CRLF
cQWSC31 += "     A1_LCFIN, "							+ CRLF
cQWSC31 += "     A1_MSALDO, "							+ CRLF
cQWSC31 += "     A1_MCOMPRA, "							+ CRLF
cQWSC31 += "     A1_ULTCOM, "							+ CRLF
cQWSC31 += "     TITULOS_ATRASADOS A1_ATR, "			+ CRLF
cQWSC31 += "     TOTAL_PEDIDOS A1_SALPED, "				+ CRLF
cQWSC31 += "     LIMITE_DISPONIVEL A1_LC "				+ CRLF
cQWSC31 += " FROM "	+ retSQLName("SA1") + " SA1 "		+ CRLF
cQWSC31 += " INNER JOIN V_LIMITES_CLIENTE VSA1 "		+ CRLF
cQWSC31 += " ON VSA1.RECNO_CLIENTE = SA1.R_E_C_N_O_ " 	+ CRLF
cQWSC31 += " WHERE SA1.D_E_L_E_T_ = ' ' "				+ CRLF
cQWSC31 += " AND (SA1.A1_ZCDECOM <> ' ' or SA1.A1_ZCDEREQ <> ' ' ) "				+ CRLF
cQWSC31 += " AND SA1.A1_COD = '" + alltrim(TRBF->TRBF_COD) + "' "	+ CRLF

TCQUERY cQWSC31 NEW ALIAS "QRYPED"

_ctitulo :=  "Limites de crédito do cliente " + ALLTRIM(TRBF->TRBF_COD) + " - " + ALLTRIM(TRBF->TRBF_NOME) + " para o E-commerce"
_aheaderec := {}
aadd(_aheaderec," ")
aadd(_aheaderec," " )

aadd(_aitens,{"Validade do limite de crédito: " ,dtoc(stod(QRYPED->A1_VENCLC))})
aadd(_aitens,{"Valor do limite de crédito: " ,transform(QRYPED->A1_LCFIN,"@E 999,999,999.99")})
aadd(_aitens,{"Maior Saldo do cliente: " ,transform(QRYPED->A1_MSALDO,"@E 999,999,999.99")})
aadd(_aitens,{"Maior compra do cliente: " ,transform(QRYPED->A1_MCOMPRA,"@E 999,999,999.99")})
aadd(_aitens,{"Última compra: " ,dtoc(stod(QRYPED->A1_ULTCOM))})
aadd(_aitens,{"Valor em atraso: " ,transform(QRYPED->A1_ATR,"@E 999,999,999.99")})
aadd(_aitens,{"Valor em pedidos: " ,transform(QRYPED->A1_SALPED,"@E 999,999,999.99")})
aadd(_aitens,{"Limite disponível: " ,transform(QRYPED->A1_LC,"@E 999,999,999.99")})

U_MGListBox( _ctitulo , _aheaderec , _aitens , .T. , 1 )

Return

/*/
=============================================================================
{Protheus.doc} MGFATBRRL
Reenvia limite de crédito de cliente
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGFATBRRL()

Local _acolec := {}
Local _aheaderec := {}

	//Monta aheader
	aadd(_aheaderec,"Código")
	aadd(_aheaderec,"ID E-commerce" )
	aadd(_aheaderec,"SR E-commerce")
	aadd(_aheaderec,"Nome")
	aadd(_aheaderec,"Nome Fantasia")
	aadd(_aheaderec,"CNPJ")
	aadd(_aheaderec,"Validade limite:")
	aadd(_aheaderec,"Saldo limite:")
	
	//Monta acols
	_nposi := TRBF->(Recno())
	TRBF->(Dbgotop())

	Do while !(TRBF->(Eof()))

		If IsMark( "TRBF_OK" , cMarkado )

			If select("QRYPED") > 0
				Dbselectarea("QRYPED")
				Dbclosearea("QRYPED")
			Endif

			cQWSC31 := "SELECT "									+ CRLF
			cQWSC31 += "     A1_ZCDEREQ, "							+ CRLF
			cQWSC31 += "     A1_ZCDECOM, "							+ CRLF
			cQWSC31 += "     A1_VENCLC, "							+ CRLF
			cQWSC31 += "     A1_LCFIN, "							+ CRLF
			cQWSC31 += "     A1_MSALDO, "							+ CRLF
			cQWSC31 += "     A1_MCOMPRA, "							+ CRLF
			cQWSC31 += "     A1_ULTCOM, "							+ CRLF
			cQWSC31 += "     TITULOS_ATRASADOS A1_ATR, "			+ CRLF
			cQWSC31 += "     TOTAL_PEDIDOS A1_SALPED, "				+ CRLF
			cQWSC31 += "     LIMITE_DISPONIVEL A1_LC "				+ CRLF
			cQWSC31 += " FROM "	+ retSQLName("SA1") + " SA1 "		+ CRLF
			cQWSC31 += " INNER JOIN V_LIMITES_CLIENTE VSA1 "		+ CRLF
			cQWSC31 += " ON VSA1.RECNO_CLIENTE = SA1.R_E_C_N_O_ " 	+ CRLF
			cQWSC31 += " WHERE SA1.D_E_L_E_T_ = ' ' "				+ CRLF
			cQWSC31 += " AND (SA1.A1_ZCDECOM <> ' ' or SA1.A1_ZCDEREQ <> ' ' ) "				+ CRLF
			cQWSC31 += " AND SA1.A1_COD = '" + alltrim(TRBF->TRBF_COD) + "' "	+ CRLF

			TCQUERY cQWSC31 NEW ALIAS "QRYPED"

			aadd(_acolec, {	TRBF->TRBF_COD,;
    				TRBF->TRBF_DTCAD,;
    				TRBF->TRBF_IDCOM,;
    				TRBF->TRBF_SRCOM,;
    				TRBF->TRBF_NOME,;
    				TRBF->TRBF_NREDU,;
    				TRBF->TRBF_CGC,;
					dtoc(stod(QRYPED->A1_VENCLC)),;
    				QRYPED->A1_LC } )

		Endif

		TRBF->(Dbskip())

	Enddo

	//Apresenta itlist
	If len(_acolec) > 0

		If U_MGListBox( "Envia limites de crédito do clientes do Ecommerce" , _aheaderec , _acolec , .T. , 1 )

			U_MWSC31I( cCGC )

		Endif

	Else

		u_MGFmsg("Nenhum registro selecionado!","Atenção",,1)

	Endif

	TRBF->(Dbgoto(_nposi))

Return


/*/
=============================================================================
{Protheus.doc} MGFATBRRC
Reenvia cadastro de cliente
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGFATBRRC()

Local _acolec := {}
Local _aheaderec := {}
Private _ntoti := 0

If TRBF->TRBF_BLQ == '1'

	_cCgcx := TRBF->TRBF_CGC

	DbselectArea("SA1")
	DbSetOrder(3)
	IF Dbseek(xFilial("SA1")+_cCgcx)
		RecLock("SA1",.F.)
			SA1->A1_MSBLQL := "2"
		MsUnLock()
	ENDIF

Endif


	//Monta aheader
	aadd(_aheaderec,"Código")
	aadd(_aheaderec,"Data Cadastro" )
	aadd(_aheaderec,"ID E-commerce" )
	aadd(_aheaderec,"SR E-commerce")
	aadd(_aheaderec,"Nome")
	aadd(_aheaderec,"Nome Fantasia")
	aadd(_aheaderec,"CNPJ")
	aadd(_aheaderec,"Telefone")
	aadd(_aheaderec,"Endereço")
	aadd(_aheaderec,"Cidade")
	aadd(_aheaderec,"Estado")
	
	//Monta acols
	_nposi := TRBF->(Recno())
	TRBF->(Dbgotop())

	Do while !(TRBF->(Eof()))

		If IsMark( "TRBF_OK" , cMarkado )

			aadd(_acolec, {	TRBF->TRBF_COD,;
    				TRBF->TRBF_DTCAD,;
    				TRBF->TRBF_IDCOM,;
    				TRBF->TRBF_SRCOM,;
    				TRBF->TRBF_NOME,;
    				TRBF->TRBF_NREDU,;
    				TRBF->TRBF_CGC,;
    				TRBF->TRBF_TELE,;
					TRBF->TRBF_END,;
					TRBF->TRBF_CIDAD,;
					TRBF->TRBF_UF } )

			_ntoti++

		Endif

		TRBF->(Dbskip())

	Enddo

	//Apresenta itlist
	If len(_acolec) > 0

		If U_MGListBox( "Reenvia cadastro de clientes do Ecommerce?" , _aheaderec , _acolec , .T. , 1 )

			FWMSGRUN( , {|oproc| MGFATBRZC(oproc) }, "Aguarde!" , 'Lendo Dados dos clientes...' )

		Endif

	Else

		u_MGFmsg("Nenhum registro selecionado!","Atenção",,1)

	Endif

	TRBF->(Dbgoto(_nposi))

Return

/*/
=============================================================================
{Protheus.doc} MGFATBRZC
Reenvia cadastro de cliente
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGFATBRZC(oproc)

Local _nni := 1

TRBF->(Dbgotop())

Do while !(TRBF->(Eof()))

	If IsMark( "TRBF_OK" , cMarkado )

		oproc:ccaption := "Reenviando cliente " + alltrim(TRBF->TRBF_NOME) + " - " + strzero(_nni,6) + " de " + strzero(_ntoti,6) + "..." 
		ProcessMessages()

		U_MWSC25I( ALLTRIM(TRBF->TRBF_CGC) )
		Dbselectarea("TRBF")
		_nni++

	Endif

	TRBF->(Dbskip())

Enddo

u_mgfmsg("Completou reenvio de clientes")

Return



/*/
=============================================================================
{Protheus.doc} MGFATBRRJ
Reenvia limite de crédito de cliente
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGFATBRRJ()

Local _acolec := {}
Local _aheaderec := {}
Private _ntoti := 0

	//Monta aheader
	aadd(_aheaderec,"Código")
	aadd(_aheaderec,"Data Cadastro" )
	aadd(_aheaderec,"ID E-commerce" )
	aadd(_aheaderec,"SR E-commerce")
	aadd(_aheaderec,"Nome")
	aadd(_aheaderec,"Nome Fantasia")
	aadd(_aheaderec,"CNPJ")
	aadd(_aheaderec,"Telefone")
	aadd(_aheaderec,"Endereço")
	aadd(_aheaderec,"Cidade")
	aadd(_aheaderec,"Estado")
	
	//Monta acols
	_nposi := TRBF->(Recno())
	TRBF->(Dbgotop())

	Do while !(TRBF->(Eof()))

		If IsMark( "TRBF_OK" , cMarkado )

			aadd(_acolec, {	TRBF->TRBF_COD,;
    				TRBF->TRBF_DTCAD,;
    				TRBF->TRBF_IDCOM,;
    				TRBF->TRBF_SRCOM,;
    				TRBF->TRBF_NOME,;
    				TRBF->TRBF_NREDU,;
    				TRBF->TRBF_CGC,;
    				TRBF->TRBF_TELE,;
					TRBF->TRBF_END,;
					TRBF->TRBF_CIDAD,;
					TRBF->TRBF_UF } )

			_ntoti++

		Endif

		TRBF->(Dbskip())

	Enddo

	//Apresenta itlist
	If len(_acolec) > 0

		If U_MGListBox( "Reenvia limite de crédito de clientes do Ecommerce?" , _aheaderec , _acolec , .T. , 1 )

			FWMSGRUN( , {|oproc| MGFATBRZI(oproc) }, "Aguarde!" , 'Lendo Dados dos clientes...' )

		Endif

	Else

		u_MGFmsg("Nenhum registro selecionado!","Atenção",,1)

	Endif

	TRBF->(Dbgoto(_nposi))

Return

/*/
=============================================================================
{Protheus.doc} MGFATBRZI
Reenvia limite de crédito de cliente
@author
Josué Danich
@since
10/03/2020
/*/
Static Function MGFATBRZI(oproc)

Local _nni := 1

TRBF->(Dbgotop())

Do while !(TRBF->(Eof()))

	If IsMark( "TRBF_OK" , cMarkado )

		oproc:ccaption := "Reenviando limite de crédito do cliente " + alltrim(TRBF->TRBF_NOME) + " - " + strzero(_nni,6) + " de " + strzero(_ntoti,6) + "..." 
		ProcessMessages()

		U_MWSC31I( ALLTRIM(TRBF->TRBF_CGC) )
		_nni++
		Dbselectarea("TRBF")

	Endif

	TRBF->(Dbskip())

Enddo

u_mgfmsg("Completou reenvio de limite de crédito de clientes")

Return

