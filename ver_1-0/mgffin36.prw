#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"

/*
=====================================================================================
Programa............: MGFFIN36
Autor...............: Marcos Andrade
Data................: 27/10/2016
Descricao / Objetivo: Cadastro de Atendente
Doc. Origem.........: Contrato - GAP CRE025
Solicitante.........: Cliente
Uso.................: 
Obs.................: Tela para Filtro dos titulos e interacao da area de cobranca
=====================================================================================
*/
User Function MGFFIN36()


	Local aTamVal	:= TamSX3("E1_VALOR")

	Private cAlias	:= "TRB"
	Private aCampos	:= {}

	Private nValDev		:= 0
	Private aColunas	:= {}
	Private cPicVal	:= PesqPict("SE1","E1_VALOR")
/*
	Private cPatSrv	:= GetMv("MGF_FIN36A",,"\MGF\CRE25\") 		 // Path de gravacao de Arquivos (Server)
	Private cPatLoc	:= GetMv("MGF_FIN36B",,"C:\PROTHEUS\CRE25\") // Path de gravacao de Arquivos (Local)

	If !U_zMakeDir( cPatSrv , "Pasta Servidor" )

		Return

	EndIf

	If !U_zMakeDir( cPatLoc , "Pasta Local" )

		Return

	EndIf
*/
	If Select("ZZA") == 0
		ChKFile("ZZA",.F.)
		ZZA->( dbSetOrder(2) )//ZZA_FILIAL+ZZA_FILGER+ZZA_CODGER
	EndIf
	If Select("ZZB") == 0
		ChKFile("ZZB",.F.)
	EndIf
	If Select("ZZ9") == 0
		ChKFile("ZZ9",.F.)
	EndIf
	If Select("SA6") == 0
		ChKFile("SA6",.F.)
	EndIf

	//MGFFIN3601()

	//instancia a classe
	oBrowse:=FWMBrowse():New()

	//define as colunas para o browse
	/*,;

	{"Email" ,"A1_EMAIL" ,"C",40,0,"@!"}}

	{"Data" ,"DATA" ,"D",8,0,"@D"},;
		{"Fornecedor" ,"CODIGO" ,"C",6,0,"@!"},;
		{"Loja" ,"LOJA" ,"C",4,0,"@!"},;
		{"Nome" ,"NOME" ,"C",40,0,"@!"},;
		{"Produto" ,"PRODUTO","C",15,0,"@!"},;
		{"Descricao" ,"DESCRIC","C",30,0,"@!"},;
		{"Armazem" ,"LOCAL" ,"C",2,0,"@!"},;
		{"Peso Liquido","PLIQUI" ,"N",14,2,"@E 999,999,999.99"}}
	*/
	//aColunas :={{"Email" ,{ || GetAdvFVal("SA1","A1_EMAIL",xFilial("SA1")+SE1->E1_CLIENTE,1,"") } ,"C","@!",1,40,0}}
	// Campos Padr�o - Habilitar Browse
	//	"Nome"
	// E1_NOMCLI

	/*
	Estrutura do array
	[n][01] Titulo da coluna
	[n][02] Code-Block de carga dos dados
	[n][03] Tipo de dados
	[n][04] Mascara
	[n][05] Alinhamento (0=Centralizado, 1=Esquerda ou 2=Direita)
	[n][06] Tamanho
	[n][07] Decimal
	*/
	//	"Valor Pago"
	aAdd( aColunas , {"Valor Pago"		,{ || SE1->( E1_VALOR - E1_SALDO ) } ,"N",cPicVal,2/* */,aTamVal[1],aTamVal[2]} )
	//	"Desconto"
	aAdd( aColunas , {"Desconto"		,{ || SE1->E1_DESCONT } ,"N",cPicVal,2/* */,aTamVal[1],aTamVal[2]} )
	//	"Saldo"
	aAdd( aColunas , {"Saldo"		,{ || SE1->E1_SALDO } ,"N",cPicVal,2/* */,aTamVal[1],aTamVal[2]} )
	//	"Valor Desconto"
	// E1_DESCFIN - Habilitar Browse
	//	"Valor Devolucao"
	//aColunas :={{"Valor Devolucao"	,{ || nValDev } ,"N",cPicVal,2/* */,aTamVal[1],aTamVal[2]}}
	//	"Valor Saldo"
	// E1_SALDO
	//	"% Pago"
	aAdd( aColunas , {"% Pago"		,{ || SE1->( ( ( E1_VALOR - E1_SALDO ) / E1_VALOR ) * 100 ) } ,"N","@E 999.99",2/* */,aTamVal[1],aTamVal[2]} )
	//	"Nosso Numero"
	// E1_NUMBCO
	aAdd( aColunas , {"Nosso Numero"		,{ || SE1->E1_NUMBCO } ,"N",cPicVal,2/* */,aTamVal[1],aTamVal[2]} )
	//	"Portador"
	// E1_PORTADO
	//	"Nome Portador"
	aAdd( aColunas , {"Nome Portador" ,{ || GetAdvFVal("SA6","A6_NOME",xFilial("SA6")+SE1->(E1_PORTADO+E1_AGEDEP+E1_CONTA),1,"") } ,"C","@!",1,40,0} )
	//	"Cliente"
	// E1_CLIENTE
	//	"Loja"
	// E1_LOJA
	//	"Nome"
	// E1_NOMCLI
	//	"DDD"
	aAdd( aColunas , {"DDD" ,{ || GetAdvFVal("SA1","A1_DDD",xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA),1,"") } ,"C","@!",1,TamSX3("A1_DDD")[1],0} )
	//	"Telefone"
	aAdd( aColunas , {"Telefone" ,{ || GetAdvFVal("SA1","A1_TEL",xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA),1,"") } ,"C","@!",1,TamSX3("A1_TEL")[1],0} )
	//	"Contato"
	aAdd( aColunas , {"Contato" ,{ || GetAdvFVal("SA1","A1_CONTATO",xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA),1,"") } ,"C","@!",1,TamSX3("A1_CONTATO")[1],0} )
	//	"Email Cob"
	aAdd( aColunas , {"Email Cob" ,{ || GetAdvFVal("SA1","A1_EMAIL",xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA),1,"") } ,"C","@!",1,TamSX3("A1_EMAIL")[1],0} )
	//
	aAdd( aColunas , {"Segmento" ,{ || GetAdvFVal("SA1","A1_CODSEG",xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA),1,"") } ,"C","@!",TamSX3("A1_CODSEG")[1],40,0} )
	//	"Rede"
	aAdd( aColunas , {"Rede" ,{ || GetAdvFVal("SA1","A1_ZREDE",xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA),1,"") } ,"C","@!",1,TamSX3("A1_ZREDE")[1],0} )

	//	"Data"
	/*
	"Hora"
	"Contatado por"
	"Resposta do Cliente"
	"Numero NFD"
	"Posicao"
	"Modificado por"
	"Custa Cartorio"

	DbSelectArea("ZZ9")
	DbSetOrder(1)
	If DbSeek(xFilial("ZZ9")+(_cAlias2)->ZZB_CODPOS)
		cZZ9Posicao	:=ZZ9->ZZ9_DESPOS
	Endif

	cZZ9Data		:= (_cAlias2)->ZZB_DATA
	cZZ9Hora		:= (_cAlias2)->ZZB_HORA
	cZZ9Contado		:= (_cAlias2)->ZZB_CONTAT
	cZZ9Resp     	:= (_cAlias2)->ZZB_RESPOS
	cZZ9NFD       	:= (_cAlias2)->ZZB_NRONFD
	cZZ9Modif     	:= UsrRetName((_cAlias2)->ZZB_USUARI)
	nZZ9Custa     	:= (_cAlias2)->ZZB_VALCAR
	*/
	//	"Representante"
	aAdd( aColunas , {"Representante" ,{ || SE1->E1_VEND1 } ,"C","@!",1,40,0} )

	aAdd( aColunas , {"Atendente   "		,{ || SE1->E1_ZATEND } ,"C","@!",1,40,0} )
	aAdd( aColunas , {"Segmento    "		,{ || SE1->E1_ZSEGMEN } ,"C","@!",1,40,0} )
	aAdd( aColunas , {"Rede        "		,{ || SE1->E1_ZDESRED } ,"C","@!",1,40,0} )


/*
	//	"Email1"
	aAdd( aColunas , {"Email1" ,{ || GetAdvFVal("ZZA","ZZA_EMAIL1",xFilial("ZZA")+SE1->E1_FILIAL,2,"") } ,"C",,1,TamSX3("ZZA_EMAIL1")[1],0} )
	//	"Email2"
	aAdd( aColunas , {"Email2" ,{ || GetAdvFVal("ZZA","ZZA_EMAIL2",xFilial("ZZA")+SE1->E1_FILIAL,2,"") } ,"C",,1,TamSX3("ZZA_EMAIL1")[1],0} )
	//	"Email3"
	aAdd( aColunas , {"Email3" ,{ || GetAdvFVal("ZZA","ZZA_EMAIL3",xFilial("ZZA")+SE1->E1_FILIAL,2,"") } ,"C",,1,TamSX3("ZZA_EMAIL1")[1],0} )
*/
	//seta as colunas para o browse
	oBrowse:SetFields(aColunas)

	//oBrowse:ColumnsFields(aColunas)

	//descricao do browse
	oBrowse:SetDescription("Acompanhamento Cobranca")

	//tabela temporaria
	oBrowse:SetAlias('SE1')

	//define as legendas
	oBrowse:AddLegend('ROUND(E1_SALDO,2) == 0'													,"BR_VERMELHO"	,"Titulo Baixado"	)
	oBrowse:AddLegend('Empty(E1_NUMBOR) .and.(ROUND(E1_SALDO,2) # ROUND(E1_VALOR,2))'			,"BR_AZUL"		,"Baixado parcialmente"	)
	oBrowse:AddLegend('!Empty(E1_NUMBOR) .And. ROUND(E1_SALDO,2) > 0'							,"BR_PRETO"		,"Titulo em Bordero"	)
	oBrowse:AddLegend('E1_TIPO == "'+MVRECANT+'".and. ROUND(E1_SALDO,2) > 0 .And. !FXAtuTitCo()',"BR_BRANCO"	,"Adiantamento com saldo"	)
	oBrowse:AddLegend('!Empty(E1_NUMBOR) .and.(ROUND(E1_SALDO,2) # ROUND(E1_VALOR,2))'			,"BR_CINZA"		,"Titulo baixado parcialmente e em bordero"	)
	oBrowse:AddLegend('ROUND(E1_SALDO,2) == ROUND(E1_VALOR,2) .and. E1_SITUACA == "F"'			,"BR_AMARELO"	,"Titulo Protestado"	)
	oBrowse:AddLegend('.T.'																		,"BR_VERDE"		,"Titulo em aberto"	)

	if isInCallStack("U_MGFFAT64")
		oModel		:= FWModelActive()
		oMdlCenter	:= oModel:GetModel( 'CENTER' )

		if !oMdlCenter:isEmpty()
			oBrowse:setFilterDefault( "E1_SALDO > 0 .and. E1_CLIENTE == '" + oMdlCenter:getValue("C5_CLIENTE") + "' .and. E1_LOJA == '" + oMdlCenter:getValue("C5_LOJACLI") + "'" )
			oBrowse:SETUSEFILTER( .T. )
		ENDIF

		oBrowse:SetMenuDef( 'MGFFIN36' )
	endif

	// desabilita impressao do browse
	// oBrowse:DisableReport()

	// desabilita o detalhe do registro
	oBrowse:DisableDetails()

	//abre o browse
	oBrowse:Activate()


Return

//-------------------------------------------------------------------
Static Function MenuDef()
	Local aRotina := {}

	ADD OPTION aRotina TITLE 'Pesquisar'	         ACTION 'PesqBrw'			OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE 'Visualizar'            ACTION 'U_MGFIN36B()'      OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Atendimento'	         ACTION 'VIEWDEF.MGFFIN36'	OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Email'		         ACTION 'U_MGFIN36A("1")'	OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Excel'		         ACTION 'U_MGFIN36A("2")'	OPERATION 8 ACCESS 0
//	ADD OPTION aRotina TITLE 'Consulta Atendimentos' ACTION 'U_MGFIN36B()'   	OPERATION 5 ACCESS 0
	ADD OPTION aRotina TITLE 'Refaz todos'		     ACTION 'U_MGFIN36C()'		OPERATION 5 ACCESS 0
    ADD OPTION aRotina TITLE 'Atendimento LOTE'      ACTION 'U_MGFFINX4()'		OPERATION 6 ACCESS 0

Return aRotina

//-------------------------------------------------------------------
Static Function ModelDef()

	Local oModel	:= Nil
	Local oStrZZB 	:= FWFormStruct(1,"ZZB")
	Local _cNomUsr	:= cUserName
	Local aDadosUsu	:={}

	//FWMemoVirtual( oStrZZB, { { 'ZA0_CDSYP1' , 'ZA0_MMSYP1', 'ZZB' } , { 'ZA0_CDSYP2' ,'ZA0_MMSYP2' , 'ZZB'} } )
	//FWMemoVirtual( oStrZZB, { { 'ZZB_PROTES' , 'ZZB_MMSYP1', 'ZZB' } } )

	oStrZZB:setproperty("ZZB_FILIAL"	, MODEL_FIELD_INIT, { || SE1->E1_FILIAL		})
	oStrZZB:setproperty("ZZB_FILORI"	, MODEL_FIELD_INIT, { || SE1->E1_FILIAL		})
	oStrZZB:setproperty("ZZB_PREFIX"	, MODEL_FIELD_INIT, { || SE1->E1_PREFIXO	})
	oStrZZB:setproperty("ZZB_NUM"		, MODEL_FIELD_INIT, { || SE1->E1_NUM		})
	oStrZZB:setproperty("ZZB_PARCEL"	, MODEL_FIELD_INIT, { || SE1->E1_PARCELA	})
	oStrZZB:setproperty("ZZB_TIPO"		, MODEL_FIELD_INIT, { || SE1->E1_TIPO		})

	oStrZZB:setproperty("ZZB_ZATEN"		, MODEL_FIELD_INIT, { || SE1->E1_ZATEND		})
	oStrZZB:setproperty("ZZB_ZSEGME"	, MODEL_FIELD_INIT, { || SE1->E1_ZSEGMEN	})
	oStrZZB:setproperty("ZZB_ZDESRE"	, MODEL_FIELD_INIT, { || SE1->E1_ZDESRED	})
	// Busca dados do usuario para saber qtos digitos usa no ANO.
	PswOrder(2)
	If PswSeek( _cNomUsr, .T. )
		aDadosUsu := PswRet() // Retorna vetor com informacoes do usuario
		oStrZZB:setproperty("ZZB_USUARI"		, MODEL_FIELD_INIT, { || aDadosUsu[1][1] })
		oStrZZB:setproperty("ZZB_USRNOM"		, MODEL_FIELD_INIT, { || aDadosUsu[1][2] })
		oStrZZB:setproperty("ZZB_CONTAT"		, MODEL_FIELD_INIT, { || aDadosUsu[1][4] })
	EndIf

	//oStrZZB:setproperty("ZZB_CLIENT"	, MODEL_FIELD_INIT, { || aListBox1[oListBox1:nAT,06] })

	oModel := MPFormModel():New("XMGFFIN36", /*bPreValidacao*/,/*bPosValidacao*/,/*bCommit*/,/*bCancel*/ )
	oModel:AddFields("TRBMASTER",/*cOwner*/,oStrZZB, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

	oModel:SetDescription('Acompanhamento de Atendimento')
	oModel:SetPrimaryKey({"ZZB_FILIAL","ZZB_PREFIX","ZZB_NUM","ZZB_PARCEL","ZZB_TIPO"})

Return oModel


//-------------------------------------------------------------------
Static Function ViewDef()

	Local oView		:= Nil
	Local oModel	:= FWLoadModel( 'MGFFIN36' )
	Local oStrZZB	:= FWFormStruct( 2,"ZZB" )


	oView := FWFormView():New()
	oView:SetModel(oModel)


	//oStrSZU:RemoveField( 'ZU_CODAPR' )


	oView:AddField( 'VIEW_ZZB' , oStrZZB, 'TRBMASTER' )

	oView:CreateHorizontalBox( 'TELA' , 100 )
	oView:SetOwnerView( 'VIEW_ZZB', 'TELA' )

Return oView



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MGFFIN36  �Autor  �Microsiga           � Data �  11/01/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function FIN36Monta()
	Local _cAlias		:= GetNextAlias()
	Local cQuery		:= ""
	Local oButton1
	Private oListBox1
	Private aListBox1	:= {}
	Private oDlg
	Private lCheckBox1  := .f.

	DEFINE MSDIALOG oDlg TITLE "Acompanhamento Cobranca" FROM 000, 000  TO 500, 1100 COLORS 0, 16777215 PIXEL

	@ 005, 011 GROUP oGroup1 TO 224, 540 OF oDlg COLOR 0, 16777215 PIXEL

	@ 012,016 ListBox oListBox1 Fields ;
		HEADER	""                                   	,;	//01
	"Filial"								,;	//02
	"Titulo"								,;	//03
	"Prefixo"								,;	//04
	"Parcela"								,;	//05
	"Tipo"									,;	//06
	"Emissao"								,;	//07
	"Vencimento"							,;	//08
	"Valor Titulo"							,;	//09
	"Valor Pago"   							,;	//10
	"Valor Desconto"						,;	//11
	"Valor Devolucao"						,;	//12
	"Valor Saldo"							,;	//13
	"% Pago"								,;	//14
	"Nosso Numero"							,;	//15
	"Portador"								,;	//16
	"Nome Portador"							,;	//17
	"Cliente"    							,;	//18
	"Loja"    								,;	//19
	"Nome"    								,;	//20
	"Telefone"                           	,;	//21
	"Contato"                             	,;	//22
	"Email Cob"                            	,;	//23
	"Segmento" 								,;	//24
	"Rede"	                         		,;	//25
	"Data"                              	,;	//26
	"Hora"                           		,;	//27
	"Contatado por"                     	,;	//28
	"Resposta do cliente"                	,;	//29
	"Numero NFD"                        	,;	//30
	"Posicao"                         		,;	//31
	"Modificado por"                      	,;	//32
	"Custa Cartorio"                     	,;	//33
	"Representante"                    		,;	//34
	"Email1"								,;	//35
	"Email2"								,;	//36
	"Email3"								;	//37
	Size 518,205 Of oDlg Pixel						;
		ON DBLCLICK( MarcaItem( aListBox1, oListBox1))	;
		ColSizes 	10,;	//01
	30,;	//02
	30,;	//03
	30,;	//04
	30,;	//05
	30,;	//06
	40,;	//07
	45,;	//08
	55,;	//09
	55,;	//10
	55,;	//11
	55,;	//12
	55,;	//13
	30,;	//14
	90,;	//15
	40,;	//16
	120,;	//17
	30,;	//18
	20,;	//19
	130,;	//20
	30,;	//21
	40,;	//22
	80,;	//23
	80,;	//24
	80,;	//25
	80,;	//26
	80,;	//27
	80,;	//28
	80,;	//29
	80,;	//30
	80,;	//31
	80,;	//32
	80,;	//33
	80,;	//34
	80,;	//35
	80,;	//36
	80		//37


	//@ 228, 016 CHECKBOX oCheckBo1 VAR lCheckBox1 PROMPT "Marcar/Desmarcar" SIZE 105, 008 OF oDlg COLORS 0, 16777215 PIXEL;
	//	On Change marcaItem(aListBox1, @oListBox1, lCheckBox1)
    @ 228, 016 CHECKBOX oCheckBo1 VAR lCheckBox1 PROMPT "Marcar/Desmarcar" SIZE 105, 008 OF oDlg COLORS 0, 16777215 PIXEL;
		On Click(AEval(aListBox1,{|x| x[1]:=lCheckBox1}),oListBox1:referesh()  )  


	@ 228, 287 BUTTON "&Email" 	    	ACTION ( geraExcel("1")  )  SIZE 037, 012 OF oDlg PIXEL    //geraExcel()
	@ 228, 357 BUTTON "E&xcel" 			ACTION ( geraExcel("2")  )	SIZE 037, 012 OF oDlg PIXEL
	@ 228, 437 BUTTON "&Atendimento" 	ACTION ( Atend()  )			SIZE 037, 012 OF oDlg PIXEL
	@ 228, 494 BUTTON "&Sair" 			ACTION (oDlg:End())			SIZE 037, 012 OF oDlg PIXEL

	fListBox1()

	ACTIVATE MSDIALOG oDlg CENTERED

Return



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MGFFIN36  �Autor  �Microsiga           � Data �  11/01/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MarcaItem(aListBox1, oListBox1, lMarcaTodos)

	DEFAULT lMarcaTodos := Nil

	If lMarcaTodos <> Nil

		AEval(aListBox1, {|x| x[1] := lMarcaTodos })

	Else
		aListBox1[oListBox1:nAt][1] := !aListBox1[oListBox1:nAt][1]

	Endif

	oListBox1:Refresh()


Return Nil



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MGFFIN36  �Autor  �Microsiga           � Data �  11/01/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fListBox1()

	Local oCheck  		:= LoadBitmap( GetResources(), "WFCHK" )      // Legends : CHECKED  / LBOK  /LBTIK
	Local oNoCheck		:= LoadBitmap( GetResources(), "WFUNCHK" )    // Legends : UNCHECKED /LBNO
	Local _cAlias1		:= GetNextAlias()
	Local _cAlias2		:= ""
	Local lRet			:= .T.
	Local cPicE1_Val 	:= PesqPict("SE1", "E1_VALOR", 13)		// Pictures usadas para a edicao dos valores
	Local cSegPedido    := ""

	aListBox1:={}

	DbSelectArea("ZZ8")
	DbSetOrder(1)
	IF DbSeek(xFilial("ZZ8")+RetCodUsr())      //ZZ8->USUARI+ZZ8->SEGMEN
		_cSeg := ZZ8->ZZ8_SEGMEN
	EndIf
	//Query de marca x produto x referencia
	cQuery := " SELECT * "
	cQuery += " FROM "+RetSQLName("SE1") + " SE1 "
	cQuery += " WHERE SE1.D_E_L_E_T_= ' ' "

	If Empty(MV_PAR01)
		cQuery += " AND SE1.E1_FILIAL >= ' ' AND SE1.E1_FILIAL <= 'ZZZZZZ'"
	Else
		cPar01	:= MontaStr(MV_PAR01)
		If Len(cPar01) > 6
			cQuery += " AND SE1.E1_FILIAL IN (" 	+ cPar01 + ") "
		Else
			cQuery += " AND SE1.E1_FILIAL = " 	+ cPar01 + " "
		Endif
	Endif

	If Empty(_cSeg)
		cQuery += " AND SE1.E1_ZCODSEG >= ' ' AND SE1.E1_ZCODSEG <= 'ZZZZZZ' "
	Else
		//cPar05	:= MontaStr(_cSeg)
		//If Len(cPar05) > 6
		//	cQuery += " AND SE1.E1_ZCODSEG IN (" 	+ _cSeg + ") "
		//Else
		//	cQuery += " AND SE1.E1_ZCODSEG = " 	+ _cSeg + " "
		//Endif
		cQuery += " AND SE1.E1_ZCODSEG = '" 	+ _cSeg + "' "
	Endif

	cQuery += " AND SE1.E1_VENCTO  BETWEEN '" 	+ DTOS(MV_PAR02) + "' AND '" + DTOS(MV_PAR03) + "' "

	If !Empty(MV_PAR08)  //10
		cPar10	:= MontaStr(MV_PAR08)
		cQuery += " AND SE1.E1_PORTADO IN (" + cPar10 + ") "
	Endif
	cQuery += " ORDER BY SE1.E1_FILIAL, SE1.E1_NUM "

	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T., 'TOPCONN', TcGenQry(,,cQuery), _cAlias1)

	If (_cAlias1)->(EOF())
		GrvList()
	Else

		While (_cAlias1)->(!EOF())

			nValDev			:= 0
			cSegmento		:= ""
			cRede     		:= ""

			cNomeCli		:= ""
			cTel			:= ""
			cContato		:= ""
			cEmail			:= ""
			cZZ9Data		:= ""
			cZZ9Hora		:= ""
			cZZ9Contado		:= ""
			cZZ9Resp     	:= ""
			cZZ9NFD       	:= ""
			cZZ9Posicao    	:= ""
			cZZ9Modif     	:= ""
			cZZ9Instrume   	:= ""
			nZZ9Custa     	:= 0
			cZZ9Repres    	:= ""
			cEmail1			:= ""
			cEmail2			:= ""
			cEmail3			:= ""
			lRet			:= .T.


			//-----------------------------------------------------------------------
			//Busca segmento do Pedido
			//-----------------------------------------------------------------------
			/*DbSelectArea("SC5")
			DbSetOrder(1)
			If DbSeek(xFilial("SC5")+(_cAlias1)->E1_PEDIDO)
				If !Empty(MV_PAR05)
					MV_PAR05	:= MontaStr(MV_PAR05)
					If (SC5->C5_ZCODSEG $ MV_PAR05)
						cSegPedido := C5_ZCODSEG
					Endif
				Endif
			Else
				//-----------------------------------
				//Se nao houver no Pedido, busca cliente
				//-----------------------------------

				DbSelectArea("SA1")
				DbSetOrder(1)
				If DbSeek(xFilial("SA1")+(_cAlias1)->E1_CLIENTE + (_cAlias1)->E1_LOJA	)
					If !Empty(MV_PAR05)
						MV_PAR05	:= MontaStr(MV_PAR05)
						If !(SA1->A1_CODSEG $ MV_PAR05)
							lRet	:= .F.
						Endif
					Endif
				Endif
			Endif*/
			//-----------------------------------------------------------------------
			//Busca dados do Cliente
			//-----------------------------------------------------------------------
			DbSelectArea("SA1")
			DbSetOrder(1)
			If DbSeek(xFilial("SA1")+(_cAlias1)->E1_CLIENTE + (_cAlias1)->E1_LOJA	)
				//-----------------------------------
				//Cliente Intercompany
				//-----------------------------------
				If lRet
					If MV_PAR05==1
						lRet	:= .F.
						DbSelectArea( "SM0" )
						DbGoTop()
						While !SM0->( EOF() )
							If SM0->M0_CGC == SA1->A1_CGC
								lRet	:= .T.
								Exit
							Endif
							SM0->( dbSkip() )
						End
					Endif
				Endif
				//-----------------------------------
				//Cliente Nacional
				//-----------------------------------
				If lRet
					If MV_PAR06==1
						If SA1->A1_PAIS <> "105" //"055"
							lRet	:= .F.
						Endif
					Endif
				Endif
				//-----------------------------------
				//Rede      MV_PAR09
				//-----------------------------------
				If lRet
					If !Empty(MV_PAR07)
						MV_PAR07	:= MontaStr(MV_PAR07)
						If !(SA1->A1_ZREDE $ MV_PAR07)
							lRet	:= .F.
						Endif
					Endif
				Endif
			Endif

			//-----------------------------------------------------------------------------------------------------------------------
			//Busca dados do Representante
			//-----------------------------------------------------------------------------------------------------------------------
			If lRet
				//DbSelectArea("SF2")
				//DbSetOrder(1)
				//If DbSeek(xFilial("SF2") + (_cAlias1)->E1_NUM + (_cAlias1)->E1_PREFIXO+(_cAlias1)->E1_CLIENTE + (_cAlias1)->E1_LOJA	)
				If !Empty(MV_PAR04)   //MV_PAR06
					MV_PAR04	:= MontaStr(MV_PAR04)
					//If !(SF2->F2_VEND1 $ MV_PAR04)
					If !((_cAlias1)->(E1_VEND1) $ MV_PAR04)
						lRet:=.F.
					Endif
				Endif
				cZZ9Repres	:= (_cAlias1)->(E1_VEND1) // SF2->F2_VEND1

				DbSelectArea("ZZA")
				ZZA->(DbSetOrder(2))//ZZA_FILIAL+ZZA_FILGER+ZZA_CODGER
				If ZZA->(DbSeek(	xFilial('ZZA',(_cAlias1)->E1_FILIAL ) + (_cAlias1)->E1_FILIAL ) )/*+(_cAlias1)->(E1_VEND1))*/ //    SF2->F2_VEND1)
					cEmail1		:= ZZA->ZZA_EMAIL1
					cEmail2		:= ZZA->ZZA_EMAIL2
					cEmail3		:= ZZA->ZZA_EMAIL3
				Else
					cEmail1		:= ""
					cEmail2     := ""
					cEmail3		:= ""
				Endif

				//Else
				//	If !Empty(MV_PAR04)
				//		lRet:=.F.
				//	Endif
				//Endif
			Endif

			If lRet
				_cAlias2	:= GetNextAlias()

				//------------------------------------------------------------------------
				//Busca dados na tabela de atendente
				//------------------------------------------------------------------------
				cQuery := " SELECT ZZB.R_E_C_N_O_ CHAVE, ZZB.* "
				cQuery += " FROM "+RetSQLName("ZZB") + " ZZB  "
				cQuery += " WHERE ZZB.ZZB_FILIAL  = '" 	+ xFilial("ZZB") 			+ "' "
				cQuery += " AND ZZB.ZZB_FILORI = '" 	+ (_cAlias1)->E1_FILIAL 	+ "' "
				cQuery += " AND ZZB.ZZB_PREFIX = '" 	+ (_cAlias1)->E1_PREFIXO	+ "' "
				cQuery += " AND ZZB.ZZB_NUM = '" 		+ (_cAlias1)->E1_NUM	 	+ "' "
				cQuery += " AND ZZB.ZZB_PARCEL = '" 	+ (_cAlias1)->E1_PARCELA 	+ "' "
				cQuery += " AND ZZB.ZZB_TIPO = '" 		+ (_cAlias1)->E1_TIPO	 	+ "' "
				cQuery += " AND ZZB.ZZB_ZATEN = '" 		+ (_cAlias1)->E1_ZATEND	 	+ "' "
				cQuery += " AND ZZB.ZZB_ZSEGME= '" 	+ (_cAlias1)->E1_ZSEGMEN	+ "' "
				cQuery += " AND ZZB.ZZB_ZDESRE = '" 	+ (_cAlias1)->E1_ZDESRED 	+ "' "
				cQuery += " AND ZZB.D_E_L_E_T_= ' ' "
				cQuery += " ORDER BY CHAVE DESC "

				cQuery := ChangeQuery(cQuery)
				dbUseArea(.T., 'TOPCONN', TcGenQry(,,cQuery), _cAlias2)

				If (_cAlias2)->(EOF())
				
					If !Empty(MV_PAR09)
						lRet := .F.
					Endif

				Else
					If !Empty(RetCodUsr())   //RetCodUsr()
						RetCodUsr()	:= MontaStr(RetCodUsr())

						If !((_cAlias2)->ZZB_USUARI	$ RetCodUsr())
							lRet := .F.
						Endif
					Endif

					If !Empty(MV_PAR09)
						MV_PAR09	:= MontaStr(MV_PAR09)

						If !((_cAlias2)->ZZB_CODPOS	$ MV_PAR09)
							lRet := .F.
						Endif
					Endif

					If lRet
						DbSelectArea("ZZ9")
						DbSetOrder(1)
						If DbSeek(xFilial("ZZ9")+(_cAlias2)->ZZB_CODPOS)
							cZZ9Posicao	:=ZZ9->ZZ9_DESPOS
						Endif

						cZZ9Data		:= (_cAlias2)->ZZB_DATA
						cZZ9Hora		:= (_cAlias2)->ZZB_HORA
						cZZ9Contado		:= (_cAlias2)->ZZB_CONTAT
						cZZ9Resp     	:= (_cAlias2)->ZZB_RESPOS
						cZZ9NFD       	:= (_cAlias2)->ZZB_NRONFD
						cZZ9Modif     	:= UsrRetName((_cAlias2)->ZZB_USUARI)
						nZZ9Custa     	:= (_cAlias2)->ZZB_VALCAR
					Endif
				Endif
				(_cAlias2)->(DbCloseArea())
			Endif

			If lRet
				If (_cAlias1)->E1_VALOR > (_cAlias1)->E1_SALDO
					nValPag	:= (_cAlias1)->E1_VALOR - (_cAlias1)->E1_SALDO
				Else
					nValPag	:= (_cAlias1)->E1_VALOR
				Endif

				If (_cAlias1)->E1_SALDO > 0
					nPerPag	:= ( (_cAlias1)->E1_SALDO /  (_cAlias1)->E1_VALOR ) * 100
				Else
					nPerPag	:= 100
				Endif

				DbSelectArea("SA6")
				DbSetOrder(1)
				If DbSeek(xFilial("SA6")+(_cAlias1)->E1_PORTADO)
					cNomPort	:= SA6->A6_NOME
				Else
					cNomPort := ""
				Endif

				DbSelectArea("SA1")
				DbSetOrder(1)
				If DbSeek(xFilial("SA1")+(_cAlias1)->E1_CLIENTE + (_cAlias1)->E1_LOJA)
					cNomeCli		:= SA1->A1_NOME
					cTel			:= Alltrim(SA1->A1_DDD) + "-" + Alltrim(SA1->A1_TEL)
					cContato		:= SA1->A1_CONTATO
					cEmail			:= SA1->A1_EMAIL
					cRede			:= SA1->A1_ZREDE
					/*If !Empty(cSegPedido)
					cSegmento		:= cSegPedido
				Else
					cSegmento		:= SA1->A1_CODSEG
				Endif*/
			Endif

			_cEmissao	:= Substr((_cAlias1)->E1_EMISSAO,7,2) + "/" + Substr((_cAlias1)->E1_EMISSAO,5,2) + "/" + Substr((_cAlias1)->E1_EMISSAO,1,4)
			_cVencto	:= Substr((_cAlias1)->E1_VENCTO ,7,2) + "/" + Substr((_cAlias1)->E1_VENCTO ,5,2) + "/" + Substr((_cAlias1)->E1_VENCTO ,1,4)
			cZZ9Data	:= Substr(cZZ9Data              ,7,2) + "/" + Substr(cZZ9Data              ,5,2) + "/" + Substr(cZZ9Data              ,1,4)

			Aadd(	aListBox1									,;
				{	.F.										,;	//01 Checkbox
			(_cAlias1)->E1_FILIAL						,;	//02 FilOrig
			(_cAlias1)->E1_NUM							,;	//03 Titulo
			(_cAlias1)->E1_PREFIXO						,;	//04 Prefixo
			(_cAlias1)->E1_PARCELA						,;	//05 Parcela
			(_cAlias1)->E1_TIPO							,;	//06 Tipo
			_cEmissao 									,;	//07 Emissao
			_cVencto									,;	//08 Vencimento
			Transform((_cAlias1)->E1_VALOR,cPicE1_Val)	,;	//09 Valor do Titulo
			Transform(nValPag,cPicE1_Val)				,;	//10 Valor Pago
			Transform((_cAlias1)->E1_DESCFIN,cPicE1_Val),;	//11 Desconto
			Transform(nValDev,cPicE1_Val)				,;	//12 Valor devolucao		??da onde pegar
			Transform((_cAlias1)->E1_SALDO,cPicE1_Val)	,;	//13 Saldo
			Transform(nPerPag,cPicE1_Val)				,;	//14 Percentual Pago
			(_cAlias1)->E1_NUMBCO						,;	//15 Nosso Numero
			(_cAlias1)->E1_PORTADO						,;	//16 Portador
			cNomPort									,;	//17 Nome do Portador
			(_cAlias1)->E1_CLIENTE						,;	//18 Cliente
			(_cAlias1)->E1_LOJA							,;	//19 LOJA
			cNomeCli									,;	//20 Nome
			cTel										,;	//21 Telefone
			cContato									,;	//22 Contato
			cEmail			       						,;	//23 Email
			(_cAlias1)->E1_ZCODSEG						,; 	//24 Segmento (era cSegmento)
			cRede										,;  //25 Rede
			cZZ9Data									,;  //26 Data Cobranca
			cZZ9Hora									,;  //27 Hora Cobranca
			cZZ9Contado									,;  //28 Contatado por
			cZZ9Resp									,;  //29 Resposta do Cliente
			cZZ9NFD										,;  //30 Nota Fiscal de Devolucao
			cZZ9Posicao									,;  //31 Posicao de cobranca
			cZZ9Modif									,;  //32 Usuario que modificou
			Transform(nZZ9Custa,cPicE1_Val)				,;  //33 Custa de Cartorio
			cZZ9Repres									,;	//34 Representante
			cEmail1										,;	//35 Email Representante1
			cEmail2										,;	//36 Email Representante2
			cEmail3										})	//37 Email Representante3

		Endif
		(_cAlias1)->(DbSkip())
	End
Endif

If Len(aListBox1) == 0
	GrvList()
Endif

oListBox1:SetArray(aListBox1)

oListBox1:bLine := {|| ;
	{Iif(aListBox1[	oListBox1:nAT,1],oCheck ,oNoCheck),;
	aListBox1[oListBox1:nAT,02]	,;
	aListBox1[oListBox1:nAT,03]	,;
	aListBox1[oListBox1:nAT,04] ,;
	aListBox1[oListBox1:nAT,05] ,;
	aListBox1[oListBox1:nAT,06] ,;
	aListBox1[oListBox1:nAT,07] ,;
	aListBox1[oListBox1:nAT,08] ,;
	aListBox1[oListBox1:nAT,09] ,;
	aListBox1[oListBox1:nAT,10] ,;
	aListBox1[oListBox1:nAT,11] ,;
	aListBox1[oListBox1:nAT,12] ,;
	aListBox1[oListBox1:nAT,13] ,;
	aListBox1[oListBox1:nAT,14] ,;
	aListBox1[oListBox1:nAT,15] ,;
	aListBox1[oListBox1:nAT,16] ,;
	aListBox1[oListBox1:nAT,17] ,;
	aListBox1[oListBox1:nAT,18] ,;
	aListBox1[oListBox1:nAT,19] ,;
	aListBox1[oListBox1:nAT,20] ,;
	aListBox1[oListBox1:nAT,21] ,;
	aListBox1[oListBox1:nAT,22]	,;
	aListBox1[oListBox1:nAT,23]	,;
	aListBox1[oListBox1:nAT,24]	,;
	aListBox1[oListBox1:nAT,25]	,;
	aListBox1[oListBox1:nAT,26]	,;
	aListBox1[oListBox1:nAT,27]	,;
	aListBox1[oListBox1:nAT,28]	,;
	aListBox1[oListBox1:nAT,29]	,;
	aListBox1[oListBox1:nAT,30]	,;
	aListBox1[oListBox1:nAT,31]	,;
	aListBox1[oListBox1:nAT,32]	,;
	aListBox1[oListBox1:nAT,33]	,;
	aListBox1[oListBox1:nAT,34] }}

oListBox1:Refresh()

(_cAlias1)->(DbCloseArea())

Return Nil

/*
=====================================================================================
Programa............: MGFFIN36
Autor...............: Marcos Andrade
Data................: 27/10/2016
Descricao / Objetivo: Acompanhamento de cobranca
Doc. Origem.........: Contrato - GAP CRE025
Solicitante.........: Cliente
Uso.................: 
Obs.................: Gerar Excel
=====================================================================================
*/
User Function MGFIN36A( xOpc )//geraExcel( xOpc )

Processa({ || MGFIN36AA(xOpc)})

Return()


Static Function MGFIN36AA(xOpc)

	local nI			:= 0
	Local xTo			:= ""
	Local xFil			:=""
	local cArq			:= ""
	local oExcel		:= FwMSExcel():New()
	local aLinha		:= {}
	local cTable		:= "Acompanhamento Cobranca" // "Table"
	local cTableSum		:= "Acompanhamento Cobranca"
	local cLocArq		:= ""
	local oExcelApp		:= MsExcel():New()
	local cWorkSheet	:= "Cobranca" // "WorkSheet"
	local cWorkShSum	:= "Cobranca"
	Local nMaxComp      := 0
	Local _lLinha		:= .F.
	Local aAreaSE1		:= SE1->( GetArea() )
	Local cAliasB		:= GetNextAlias()
	Local cFilSE1		:= ""
	Local bFiltro := { || }
	Local nCount := 0

	DEFAULT xOpc 		:= "2"

	//oBrowse

	// Sum�rio
	oExcel:AddworkSheet(cWorkSheet)			//Cria Planilha
	oExcel:AddTable(cWorkSheet, cTable) 	//Cria Tabela

	oExcel:AddColumn(cWorkSheet, cTable, "FILIAL"					, 1, 1)
	oExcel:AddColumn(cWorkSheet, cTable, "TITULO"					, 1, 1)
	oExcel:AddColumn(cWorkSheet, cTable, "PREFIXO"					, 1, 1)
	oExcel:AddColumn(cWorkSheet, cTable, "PARCELA"					, 1, 1) // add depois
	oExcel:AddColumn(cWorkSheet, cTable, "TIPO"						, 1, 1)
	oExcel:AddColumn(cWorkSheet, cTable, "EMISSAO"					, 1, 1)
	oExcel:AddColumn(cWorkSheet, cTable, "VENCIMENTO"				, 1, 1)
	oExcel:AddColumn(cWorkSheet, cTable, "VALOR TITULO"				, 1, 1)
	oExcel:AddColumn(cWorkSheet, cTable, "VALOR PAGO" 				, 1, 1)
	oExcel:AddColumn(cWorkSheet, cTable, "DECRESCIMO" 				, 1, 1)
	oExcel:AddColumn(cWorkSheet, cTable, "DESCONTO" 				, 1, 1)
	//oExcel:AddColumn(cWorkSheet, cTable, "DEVOLUCAO"				, 1, 1)
	oExcel:AddColumn(cWorkSheet, cTable, "SALDO"					, 1, 1)
	oExcel:AddColumn(cWorkSheet, cTable, "% PAGO" 					, 1, 1)
	oExcel:AddColumn(cWorkSheet, cTable, "NOSSO NUMERO" 			, 1, 1)
	oExcel:AddColumn(cWorkSheet, cTable, "PORTADOR"					, 1, 1)
	oExcel:AddColumn(cWorkSheet, cTable, "NOME PORTADOR"			, 1, 1)
	oExcel:AddColumn(cWorkSheet, cTable, "CLIENTE"					, 1, 1)
	oExcel:AddColumn(cWorkSheet, cTable, "LOJA"						, 1, 1)
	oExcel:AddColumn(cWorkSheet, cTable, "NOME"						, 1, 1)
	oExcel:AddColumn(cWorkSheet, cTable, "TELEFONE"					, 1, 1)
	oExcel:AddColumn(cWorkSheet, cTable, "CONTATO"					, 1, 1)
	oExcel:AddColumn(cWorkSheet, cTable, "EMAIL"					, 1, 1)
	oExcel:AddColumn(cWorkSheet, cTable, "SEGMENTO"					, 1, 1)
	oExcel:AddColumn(cWorkSheet, cTable, "DESCRICAO SEGM"			, 1, 1)
	oExcel:AddColumn(cWorkSheet, cTable, "REDE"						, 1, 1)
	oExcel:AddColumn(cWorkSheet, cTable, "DESCRICAO REDE"			, 1, 1)
	oExcel:AddColumn(cWorkSheet, cTable, "DATA"						, 1, 1)
	oExcel:AddColumn(cWorkSheet, cTable, "HORA"						, 1, 1)
	//oExcel:AddColumn(cWorkSheet, cTable, "Contatado por"			, 1, 1)
	oExcel:AddColumn(cWorkSheet, cTable, "Resposta do cliente"		, 1, 1)
	oExcel:AddColumn(cWorkSheet, cTable, "Numero NFD"				, 1, 1)
	oExcel:AddColumn(cWorkSheet, cTable, "Posicao"					, 1, 1)
	oExcel:AddColumn(cWorkSheet, cTable, "Modificado por"			, 1, 1)
	oExcel:AddColumn(cWorkSheet, cTable, "Custa Cartorio"			, 1, 1)
	oExcel:AddColumn(cWorkSheet, cTable, "ATENDENTE"				, 1, 1)
	oExcel:AddColumn(cWorkSheet, cTable, "Representante"			, 1, 1)
	oExcel:AddColumn(cWorkSheet, cTable, "CPF/CNPJ"					, 1, 1)
	//oExcel:AddColumn(cWorkSheet, cTable, "SEGMENTO"					, 1, 1)
	//oExcel:AddColumn(cWorkSheet, cTable, "REDE"						, 1, 1)

	cFilSE1	:= oBrowse:FWFILTER():GETEXPRADVPL()
	If Empty(cFilSE1)
		APMsgStop("Para usar a exportacao para Excel, � necessario realizar um Filtro antes no Browse."+CRLF+;
		"Utilize o botao 'Filtrar' localizado no canto direito de cima do Browse.")
		Return()
	Endif

	bFiltro := &( ' { || ' + cFilSE1 + ' } ' )
	SE1->( DBClearFilter())
	SE1->( dbSetFilter( bFiltro, cFilSE1 ) )
	//SE1->(DbSetFilter({|| &(cFilSE1) }, cFilSE1 ))

	SE1->( dbGoTop() )
	SE1->(dbEval( { || nCount++ },,{ || !Eof() } ))

	If !APMsgYesNo("Foram identificados '"+Alltrim(Str(nCount))+"' para serem exportados para o Excel."+CRLF+;
	"Para uma quantidade grande de registros a exportacao pode ser demorada."+CRLF+;
	"Deseja continuar ?")
		If !Empty( cFilSE1 )
			SE1->( DBClearFilter() )
		EndIf

		SE1->( RestArea(aAreaSE1) )

		Return()
	Endif

	ProcRegua(nCount)

	SE1->( dbGoTop() )
	nCount := 0
	While !SE1->( eof() )

		IncProc("Processando registros: "+Str(nCount))
		nCount++

		//For nI:= 1 To Len(aListBox1)

		aLinha := {}

		//--------------------------------------------------------------------
		//Verifica se a quebra por Filial e envia para o gerente responsvel
		//--------------------------------------------------------------------
		If xOpc == "1"

			If Empty(xFil)

				xFil := SE1->E1_FILIAL

				If ZZA->( dbSeek(	xFilial('ZZA') + SE1->E1_FILIAL ) )
					If !Empty(ZZA->ZZA_EMAIL1)
						xTo := AllTrim(ZZA->ZZA_EMAIL1)
					Endif
					If !Empty(ZZA->ZZA_EMAIL2)
						xTo	+= IIf(!Empty(xTo),";","") + AllTrim(ZZA->ZZA_EMAIL2)
					Endif
					If !Empty(ZZA->ZZA_EMAIL3)
						xTo	+= IIf(!Empty(xTo),";","") + AllTrim(ZZA->ZZA_EMAIL3)
					Endif
				Endif

			Else

				If xFil <> SE1->E1_FILIAL

					//Ativa a planilha e deixa pronta para gerar arquivo.
					oExcel:Activate()
					cArq := CriaTrab(NIL, .F.) + ".xml"
					oExcel:GetXMLFile(cArq)

					//__CopyFile(cArq, "C:\Temp\" + cArq)
					//EnvEmail(xTo, "C:\Temp\"+cArq)
					If !Empty(AllTrim(xTo))
						EnvEmail(xTo, "\System\"+cArq)
					Else
						Alert("Nao existe destinat�rio cadastrado nessa selecao!")
					EndIf

					oExcelApp	:= MsExcel():New()
					oExcel		:= FwMSExcel():New()
					aLinha		:= {}
					cArq		:= ""
					cLocArq		:= ""
					xTo 		:= ""

					If !Empty(aListBox1[nI][35])
						xTo := aListBox1[nI][35]
					Endif
					If !Empty(aListBox1[nI][36])
						If !Empty(xTo)
							xTo	+= ";" + aListBox1[nI][36]
						Else
							xTo	+= aListBox1[nI][36]
						Endif
					Endif
					If !Empty(aListBox1[nI][37])
						If !Empty(xTo)
							xTo	+= ";" + aListBox1[nI][37]
						Else
							xTo	+= aListBox1[nI][37]
						Endif
					Endif

					// Sum�rio
					oExcel:AddworkSheet(cWorkSheet)			//Cria Planilha
					oExcel:AddTable(cWorkSheet, cTable) 	//Cria Tabela

					oExcel:AddColumn(cWorkSheet, cTable, "FILIAL"					, 1, 1)
					oExcel:AddColumn(cWorkSheet, cTable, "TITULO"					, 1, 1)
					oExcel:AddColumn(cWorkSheet, cTable, "PREFIXO"					, 1, 1)
					oExcel:AddColumn(cWorkSheet, cTable, "PARCELA"					, 1, 1) // add depois
					oExcel:AddColumn(cWorkSheet, cTable, "TIPO"						, 1, 1)
					oExcel:AddColumn(cWorkSheet, cTable, "EMISSAO"					, 1, 1)
					oExcel:AddColumn(cWorkSheet, cTable, "VENCIMENTO"				, 1, 1)
					oExcel:AddColumn(cWorkSheet, cTable, "VALOR TITULO"				, 1, 1)
					oExcel:AddColumn(cWorkSheet, cTable, "VALOR PAGO" 				, 1, 1)
					oExcel:AddColumn(cWorkSheet, cTable, "DECRESCIMO" 				, 1, 1)
					oExcel:AddColumn(cWorkSheet, cTable, "DESCONTO" 				, 1, 1)
					oExcel:AddColumn(cWorkSheet, cTable, "SALDO"					, 1, 1)
					oExcel:AddColumn(cWorkSheet, cTable, "% PAGO" 					, 1, 1)
					oExcel:AddColumn(cWorkSheet, cTable, "NOSSO NUMERO" 			, 1, 1)
					oExcel:AddColumn(cWorkSheet, cTable, "PORTADOR"					, 1, 1)
					oExcel:AddColumn(cWorkSheet, cTable, "NOME PORTADOR"			, 1, 1)
					oExcel:AddColumn(cWorkSheet, cTable, "CLIENTE"					, 1, 1)
					oExcel:AddColumn(cWorkSheet, cTable, "LOJA"						, 1, 1)
					oExcel:AddColumn(cWorkSheet, cTable, "NOME"						, 1, 1)
					oExcel:AddColumn(cWorkSheet, cTable, "TELEFONE"					, 1, 1)
					oExcel:AddColumn(cWorkSheet, cTable, "CONTATO"					, 1, 1)
					oExcel:AddColumn(cWorkSheet, cTable, "EMAIL"					, 1, 1)
					oExcel:AddColumn(cWorkSheet, cTable, "SEGMENTO"					, 1, 1)
					oExcel:AddColumn(cWorkSheet, cTable, "DESCRICAO SEGM"			, 1, 1)
					oExcel:AddColumn(cWorkSheet, cTable, "REDE"						, 1, 1)
					oExcel:AddColumn(cWorkSheet, cTable, "DESCRICAO REDE"			, 1, 1)
					oExcel:AddColumn(cWorkSheet, cTable, "DATA"						, 1, 1)
					oExcel:AddColumn(cWorkSheet, cTable, "HORA"						, 1, 1)
					oExcel:AddColumn(cWorkSheet, cTable, "Resposta do cliente"		, 1, 1)
					oExcel:AddColumn(cWorkSheet, cTable, "Numero NFD"				, 1, 1)
					oExcel:AddColumn(cWorkSheet, cTable, "Posicao"					, 1, 1)
					oExcel:AddColumn(cWorkSheet, cTable, "Modificado por"			, 1, 1)
					oExcel:AddColumn(cWorkSheet, cTable, "Custa Cartorio"			, 1, 1)
					oExcel:AddColumn(cWorkSheet, cTable, "ATENDENTE"				, 1, 1)
					oExcel:AddColumn(cWorkSheet, cTable, "CPF/CNPJ"					, 1, 1)
					oExcel:AddColumn(cWorkSheet, cTable, "Representante"			, 1, 1)


				Endif
			Endif
		Endif

		_lLinha:= .T.

		aadd(aLinha, SE1->E1_FILIAL			)
		aadd(aLinha, SE1->E1_NUM			)
		aadd(aLinha, SE1->E1_PREFIXO		)
		aadd(aLinha, SE1->E1_PARCELA		)
		aadd(aLinha, SE1->E1_TIPO			)
		aadd(aLinha, DTOC(SE1->E1_EMISSAO )	)
		aadd(aLinha, DTOC(SE1->E1_VENCREA )	)
		aadd(aLinha, Tran(SE1->E1_VALOR,cPicVal)	)
		aadd(aLinha, Tran(SE1->(E1_VALOR-E1_SALDO),cPicVal)	)
		aadd(aLinha, Tran(SE1->E1_DECRESC,cPicVal)		)
		aadd(aLinha, Tran(SE1->E1_DESCFIN,cPicVal)	)
		aadd(aLinha, Tran(SE1->E1_SALDO,cPicVal)	)
		aadd(aLinha, Tran(SE1->( ( ( E1_VALOR - E1_SALDO ) / E1_VALOR ) * 100 ) ,"@E 999.99" )	)
		aadd(aLinha, SE1->E1_NUMBCO		)
		aadd(aLinha, SE1->E1_PORTADO	)

		cNomSA6	:= Posicione("SA6",1,xFilial("SA6")+SE1->(E1_PORTADO+E1_AGEDEP+E1_CONTA),"A6_NOME")
		aadd(aLinha, cNomSA6	)	//17 Nome do Portador
		aadd(aLinha, SE1->E1_CLIENTE	)
		aadd(aLinha, SE1->E1_LOJA		)
		aadd(aLinha, SE1->E1_NOMCLI		)

		Posicione("SA1",1,xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA),"A1_TEL")
		aadd(aLinha, Alltrim(SA1->A1_DDD)+IIF(!Empty(SA1->A1_DDD),'-',"")+Alltrim(SA1->A1_TEL)	)
		aadd(aLinha, SA1->A1_CONTATO	)
		aadd(aLinha, SA1->A1_EMAIL		)
		aadd(aLinha, SA1->A1_CODSEG		)

		aadd(aLinha, GetAdvFVal("AOV", "AOV_DESSEG", xFilial("AOV") + SA1->A1_CODSEG, 1, ""))

		aadd(aLinha, SA1->A1_ZREDE		)

		aadd(aLinha, GetAdvFVal("SZQ", "ZQ_DESCR", xFilial("SZQ") + SA1->A1_ZREDE, 1, ""))

		//------------------------------------------------------------------------
		//Busca dados na tabela de atendente
		//------------------------------------------------------------------------
		cQuery := " SELECT ZZB.R_E_C_N_O_ CHAVE, ZZB.* "
		cQuery += " FROM "+RetSQLName("ZZB") + " ZZB  "
//		cQuery += " WHERE ZZB.ZZB_FILIAL  = '" 	+ xFilial("ZZB") 	+ "' "   // NAO TRATAR FILIAL CONFORME CLAUDIO 16/04/18
		cQuery += " WHERE ZZB.ZZB_FILORI = '" 	+ SE1->E1_FILIAL 	+ "' "
		cQuery += " AND ZZB.ZZB_PREFIX = '" 	+ SE1->E1_PREFIXO	+ "' "
		cQuery += " AND ZZB.ZZB_NUM = '" 		+ SE1->E1_NUM	 	+ "' "
		cQuery += " AND ZZB.ZZB_PARCEL = '" 	+ SE1->E1_PARCELA 	+ "' "
		cQuery += " AND ZZB.ZZB_TIPO = '" 		+ SE1->E1_TIPO	 	+ "' "
		cQuery += " AND ZZB.ZZB_ZATEN = '" 		+ SE1->E1_ZATEND	+ "' "
		//cQuery += " AND ZZB.ZZB_ZSEGME= '" 	    + SE1->E1_ZSEGMEN	+ "' "
		//cQuery += " AND ZZB.ZZB_ZDESRE = '" 	+ SE1->E1_ZDESRED 	+ "' "
		cQuery += " AND ZZB.D_E_L_E_T_= ' ' "
		cQuery += " ORDER BY CHAVE DESC "

		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T., 'TOPCONN', TcGenQry(,,cQuery), cAliasB)

		aadd(aLinha, DTOC(STOD((cAliasB)->ZZB_DATA))	) //26 Data Cobranca
		aadd(aLinha, (cAliasB)->ZZB_HORA	) //27 Hora Cobranca
		//aadd(aLinha, (cAliasB)->ZZB_CONTAT	) //28 Contatado por
		aadd(aLinha, (cAliasB)->ZZB_RESPOS	) //29 Resposta do Cliente
		aadd(aLinha, (cAliasB)->ZZB_NRONFD	) //30 Nota Fiscal de Devolucao
		aadd(aLinha, GetAdvFVal("ZZ9","ZZ9_DESPOS",xFilial("ZZ9")+(cAliasB)->ZZB_CODPOS,1,"")	) //31 Posicao de cobranca

		cNome   := ''
	    cNextAlias := GetNextAlias()

		cUser := AllTrim((cAliasB)->ZZB_USUARI)

		BeginSql Alias cNextAlias

			SELECT
				R_E_C_N_O_ Rec,
				USR_ID,
				USR_CODIGO,
				USR_NOME,
				USR_EMAIL,
				USR_DEPTO,
				USR_CARGO
			FROM
				SYS_USR USR
			WHERE
				USR.D_E_L_E_T_ =' ' and
				USR.USR_ID = %exp:cUser%
		EndSql

		(cNextAlias)->(dbGoTop())

		While (cNextAlias)->(!EOF())
			cNome := (cNextAlias)->USR_NOME
			Exit
			(cNextAlias)->(dbSkip())
		EndDo
		dbSelectArea(cNextAliass)
		dbCloseArea()

		aadd(aLinha, cNome	) //32 Usuario que modificou
		aadd(aLinha, Tran((cAliasB)->ZZB_VALCAR,cPicVal)	) //33 Custa de Cartorio
		aadd(aLinha,  SE1->E1_ZATEND )
		aadd(aLinha, GetAdvFVal("SA3","A3_NOME",xFilial("SA3")+SE1->E1_VEND1,1,"")	)
		aadd(aLinha, Transform(SA1->A1_CGC,IIf(Empty(SA1->A1_CGC),"",IIf(Len(Alltrim(SA1->A1_CGC))==11,"@R 999.999.999-99","@R 99.999.999/9999-99")))) //35 CNPJ

		dbSelectArea(cAliasB)
		dbCloseArea()

		oExcel:addRow(cWorkSheet, cTable, aLinha)

		SE1->( dbSkip() )
		//Next nI
	EndDo

	IncProc("Abrindo Excel...")

	If !Empty( cFilSE1 )
		SE1->( DBClearFilter() )
	EndIf

	SE1->( RestArea(aAreaSE1) )

	If _lLinha
		//Ativa a planilha e deixa pronta para gerar arquivo.
		oExcel:Activate()
		cArq := CriaTrab(NIL, .F.) + ".xml"
		oExcel:GetXMLFile(cArq)

		If xOpc == "2"
			cLocArq := cGetFile("Todos os Arquivos|*.*", OemToAnsi("Informe o diretorio para gravacao do arquivo Excel"), 0, "SERVIDOR\", .T., GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE + GETF_RETDIRECTORY)
			if __CopyFile(cArq, cLocArq + cArq)
				MsgInfo("Relatorio gerado em: " + cLocArq + cArq)
				oExcelApp:WorkBooks:Open(cLocArq + cArq)
				oExcelApp:SetVisible(.T.)
			else
				MsgInfo("Arquivo nao copiado para o Diretorio " + cLocArq + cArq)
			endif
		Else
			//------------------------
			//Envia Email
			//------------------------
			//__CopyFile(cArq, "C:\Temp\" + cArq)
			If !Empty(AllTrim(xTo))
				EnvEmail( xTo, "\System\"+cArq)
			Else
				Alert("Nao existe destinat�rio cadastrado nessa selecao!")
			EndIf
			//EnvEmail( xTo, "C:\Temp\"+cArq)
			MsgAlert("Processamento Finalizado!!!")
		Endif
	Endif
return


/*
=====================================================================================
Programa............: MGFFIN36
Autor...............: Marcos Andrade
Data................: 27/10/2016
Descricao / Objetivo: Acompanhamento de cobranca
Doc. Origem.........: Contrato - GAP CRE025
Solicitante.........: Cliente
Uso.................: 
Obs.................: Envia Email
=====================================================================================
*/

Static Function EnvEmail(xTo, xArq)
	Local cUser 	:= Alltrim(SUPERGETMV("MGF_USER2"  ,,"teste.any"))	//sp01\xxx
	Local cPass 	:= Alltrim(SUPERGETMV("MGF_PASS2"  ,,"T3ste@n123"))//SUPERGETMV("MGF_PASS2"		,,"T3ste@m123"/*"Marfrig@999"*/)         				//xxx
	Local cSendSrv 	:= Alltrim(SUPERGETMV("MGF_SMTPSV" ,,"smtp.marfrig-ad.local"))//SUPERGETMV("MGF_SMTPSV"		,,"smtp.marfrig-ad.local"/*"10.115.242.242"*/) 					//"mail.totvs.com.br"
	Local cEmail	:= Alltrim(SUPERGETMV("MGF_EMAIL"  ,,"teste.any@marfrig.com.br")) //SUPERGETMV("MGF_EMAIL"		,,"teste.any@marfrig.com.br"/*""*/)  									//email que sera incluido no FROM
	Local cMsg 		:= ""
	Local nSendPort := 0
	Local nSendSec  := SUPERGETMV("MGF_PROT2"  ,,2)//2	//criar parametro
	Local nTimeout 	:= 60
	Local xRet
	Local oServer, oMessage

	nTimeout 	:= 60 								// define the timout to 60 seconds
	oServer 	:= TMailManager():New()

	oServer:SetUseSSL( .F. )
	oServer:SetUseTLS( .F. )

	If nSendSec == 0
		nSendPort := 25 //default port for SMTP protocol
	Elseif nSendSec == 1
		nSendPort := 465 //default port for SMTP protocol with SSL
		oServer:SetUseSSL( .T. )
	Else
		nSendPort := 587 //default port for SMTPS protocol with TLS
		oServer:SetUseTLS( .T. )
	Endif

	conout( "=============" )
	conout( "INICIOOOOOOOO" )
	conout( "=============" )

	// once it will only send messages, the receiver server will be passed as ""
	// and the receive port number won't be passed, once it is optional
	xRet := oServer:Init( "", cSendSrv, cUser, cPass, , nSendPort )

	If xRet != 0
		cMsg := "Could not initialize SMTP server: " + oServer:GetErrorString( xRet )
		conout( cMsg )
		return
	Endif

	// the method set the timout for the SMTP server
	xRet := oServer:SetSMTPTimeout( nTimeout )
	If xRet != 0
		cMsg := "Could not set " + cProtocol + " timeout to " + cValToChar( nTimeout )
		conout( cMsg )
	Endif

	// estabilish the connection with the SMTP server
	xRet := oServer:SMTPConnect()
	If xRet <> 0
		cMsg := "Could not connect on SMTP server: " + oServer:GetErrorString( xRet )
		conout( cMsg )
		return
	endif

	// authenticate on the SMTP server (if needed)
	xRet := oServer:SmtpAuth( cUser, cPass )
	if xRet <> 0
		cMsg := "Could not authenticate on SMTP server: " + oServer:GetErrorString( xRet )
		conout( cMsg )
		oServer:SMTPDisconnect()
		return
	endif

	oMessage := TMailMessage():New()
	oMessage:Clear()

	oMessage:cDate 		:= cValToChar( Date() )
	oMessage:cFrom 		:= cEmail
	oMessage:cTo 			:= xTo
	oMessage:cSubject 	:= "Acompanhamento de Cobranca"
	oMessage:cBody 		:= "Segue arquivo para acompanhamento de cobranca."

	xRet := oMessage:AttachFile(xArq)

	//http://tdn.totvs.com/display/tec/TMailMessage%3AAttachFile
	if xRet < 0
		cMsg := "Could not attach file " + xArq
		conout( cMsg )
		Return
	endif

	xRet := oMessage:Send( oServer )
	if xRet <> 0
		cMsg := "Could not send message: " + oServer:GetErrorString( xRet )
		conout( cMsg )
	endif

	xRet := oServer:SMTPDisconnect()
	if xRet <> 0
		cMsg := "Could not disconnect from SMTP server: " + oServer:GetErrorString( xRet )
		conout( cMsg )
	endif

	conout( "=============" )
	conout( "FIMMMMMMMMMMM" )
	conout( "=============" )


Return

Static function MontaStr(cVar)
	Local nX	:= 0
	Local nPos	:= 0
	Local cVar2	:= ""

	Default cVar :=""

	cVar	:= StrTran( Alltrim(cVar), "'", "" )
	cVar	:= StrTran( Alltrim(cVar), ";", "" )

	For nX:=1 To Len(cVar)

		If Empty(cVar)
			Exit
		Endif

		nPos	:= At(",",cVar)

		If nPos == 0
			If Empty(cVar2)
				cVar2 := "'" + cVar + "'"
			Else
				cVar2 += ",'" +cVar + "'"
			Endif
			Exit
		Endif

		If Empty(cVar2)
			cVar2 	:="'" 	+ Substr(cVar, 1, nPos -1 ) 	+ "'"
		Else
			cVar2 	+=",'"	+ Substr(cVar, 1, nPos -1 ) + "'"
		Endif
		cVar	:= Substr(cVar, nPos +1 )

	Next

Return(cVar2)


/*
=====================================================================================
Programa............: MGFFIN36
Autor...............: Marcos Andrade
Data................: 27/10/2016
Descricao / Objetivo: Consulta Especifica
Doc. Origem.........: Contrato - GAP CRE025
Solicitante.........: Cliente
Uso.................: 
Obs.................: Consulta de Atendente
=====================================================================================
*/
User Function FIN36SM0()
	Local aFilM0
	Local nX
	__cMark := ""

	aFilM0 := ADMGETFIL()

	For nX:= 1 to Len(aFilM0)
		If Empty(__cMark)
			__cMark	:= aFilM0[nX]
		Else
			__cMark	+= "," + aFilM0[nX]
		Endif
	Next

Return(.T.)


/*
=====================================================================================
Programa............: MGFFIN36
Autor...............: Marcos Andrade
Data................: 27/10/2016
Descricao / Objetivo: Consulta Especifica
Doc. Origem.........: Contrato - GAP CRE025
Solicitante.........: Cliente
Uso.................: 
Obs.................: Consulta de Atendente
=====================================================================================
*/
User Function FIN36ZZ8()

	__cMark := ""
	FIN36Mark("ATENDENTE")

Return(.T.)

/*
=====================================================================================
Programa............: MGFFIN36
Autor...............: Marcos Andrade
Data................: 27/10/2016
Descricao / Objetivo: Consulta Especifica
Doc. Origem.........: Contrato - GAP CRE025
Solicitante.........: Cliente
Uso.................: 
Obs.................: Consulta de SEGMENTO (SX5)
=====================================================================================
*/
User Function FIN36SX5()

	__cMark := ""
	FIN36Mark("SEGMENTO")

Return(.T.)
/*
=====================================================================================
Programa............: MGFFIN36
Autor...............: Marcos Andrade
Data................: 27/10/2016
Descricao / Objetivo: Consulta Especifica
Doc. Origem.........: Contrato - GAP CRE025
Solicitante.........: Cliente
Uso.................: 
Obs.................: Consulta de Portador
=====================================================================================
*/
User Function FIN36SA3()

	__cMark := ""
	FIN36Mark("REPRESENTANTE")

Return(.T.)

/*
=====================================================================================
Programa............: MGFFIN36
Autor...............: Marcos Andrade
Data................: 27/10/2016
Descricao / Objetivo: Consulta Especifica
Doc. Origem.........: Contrato - GAP CRE025
Solicitante.........: Cliente
Uso.................: 
Obs.................: Consulta de Portador
=====================================================================================
*/
User Function FIN36SA6()

	__cMark := ""
	FIN36Mark("PORTADOR")

Return(.T.)

/*
=====================================================================================
Programa............: MGFFIN36
Autor...............: Marcos Andrade
Data................: 27/10/2016
Descricao / Objetivo: Consulta Especifica
Doc. Origem.........: Contrato - GAP CRE025
Solicitante.........: Cliente
Uso.................: 
Obs.................: Consulta de Rede
=====================================================================================
*/
User Function FIN36SZQ()

	__cMark := ""
	FIN36Mark("REDE")

Return(.T.)

/*
=====================================================================================
Programa............: MGFFIN36
Autor...............: Marcos Andrade
Data................: 27/10/2016
Descricao / Objetivo: Consulta Especifica
Doc. Origem.........: Contrato - GAP CRE025
Solicitante.........: Cliente
Uso.................: 
Obs.................: Consulta de Representante (Vendedor)
=====================================================================================
*/
User Function FIN36ZZ9()

	__cMark := ""
	FIN36Mark("POSICAO")

Return(.T.)

/*
=====================================================================================
Programa............: MGFFIN36
Autor...............: Marcos Andrade
Data................: 27/10/2016
Descricao / Objetivo: Consulta Especifica
Doc. Origem.........: Contrato - GAP CRE025
Solicitante.........: Cliente
Uso.................: 
Obs.................: RETORNO DAS CONSULTAS
=====================================================================================
*/
User Function FIN36Ret()

Return(__cMark)

Static Function FIN36Mark(cTabela)
	Local oButton1
	Local oButton2
	Local oGroup1

	Private oListBox1
	Private nListBox1 := 1
	Private aListBox1:={}
	Private oDlg

	DEFINE MSDIALOG oDlg TITLE "Consulta " + cTabela  FROM 000, 000  TO 500, 550 COLORS 0, 16777215 PIXEL

	@ 005, 007 GROUP oGroup1 TO 218, 267 OF oDlg COLOR 0, 16777215 PIXEL

	@ 012,012 ListBox oListBox1 Fields ;
		HEADER		""                                   	,;	//01
	"Codigo"								,;	//02
	"Descricao"								;	//03
	Size 249,200 Of oDlg Pixel						;
		ON DBLCLICK( MarcaItem( aListBox1, oListBox1))	;
		ColSizes 	10,;	//01
	30,;	//02
	30		//03

	@ 223, 227 BUTTON oButton1 PROMPT "&Cancelar" 	ACTION (oDlg:End()) 				SIZE 037, 012 OF oDlg PIXEL
	@ 224, 179 BUTTON oButton2 PROMPT "&Ok" 		ACTION( RetMark(), oDlg:End() ) 	SIZE 037, 012 OF oDlg PIXEL

	fdados(cTabela)

	ACTIVATE MSDIALOG oDlg CENTERED

Return(.T.)

Static Function FDados(cTabela)
	Local oCheck  	:= LoadBitmap( GetResources(), "WFCHK" )      // Legends : CHECKED  / LBOK  /LBTIK
	Local oNoCheck	:= LoadBitmap( GetResources(), "WFUNCHK" )    // Legends : UNCHECKED /LBNO
	Local _cAlias1	:= GetNextAlias()
	Local _cAlias2	:= ""
	Local lRet		:= .T.

	aListBox1:={}

	If cTabela == "ATENDENTE"
		cQuery := " SELECT ZZ8.ZZ8_USUARI CODIGO "
		cQuery += " FROM "+RetSQLName("ZZ8") + " ZZ8 "
		cQuery += " WHERE ZZ8.ZZ8_FILIAL  = '" + xFilial("ZZ8") 	+ "' "
		cQuery += " AND ZZ8.D_E_L_E_T_= ' ' "

	ElseIf cTabela == "SEGMENTO"
		//cQuery := " SELECT SX5.X5_CHAVE CODIGO, SX5.X5_DESCRI NOME "
		//cQuery += " FROM "+RetSQLName("SX5") + " SX5 "
		//cQuery += " WHERE SX5.X5_FILIAL  = '" + xFilial("SX5") 	+ "' "
		//cQuery += " AND SX5.X5_TABELA = 'T3' "
		//cQuery += " AND SX5.D_E_L_E_T_= ' ' "
		cQuery := " SELECT AOV.AOV_CODSEG CODIGO, AOV.AOV_DESSEG NOME "
		cQuery += " FROM "+RetSQLName("AOV") + " AOV "
		cQuery += " WHERE AOV.AOV_FILIAL  = '" + xFilial("AOV") 	+ "' "
		cQuery += " AND AOV.D_E_L_E_T_= ' ' "

	ElseIf cTabela == "REPRESENTANTE"
		cQuery := " SELECT SA3.A3_COD CODIGO, SA3.A3_NOME NOME "
		cQuery += " FROM "+RetSQLName("SA3") + " SA3 "
		cQuery += " WHERE SA3.A3_FILIAL  = '" + xFilial("SA3") 	+ "' "
		cQuery += " AND SA3.D_E_L_E_T_= ' ' "

	ElseIf cTabela == "PORTADOR"
		cQuery := " SELECT SA6.A6_COD CODIGO, SA6.A6_NOME NOME "
		cQuery += " FROM "+RetSQLName("SA6") + " SA6 "
		cQuery += " WHERE SA6.A6_FILIAL  = '" + xFilial("SA6") 	+ "' "
		cQuery += " AND SA6.D_E_L_E_T_= ' ' "

	ElseIf cTabela == "REDE"
		cQuery := " SELECT SZQ.ZQ_COD CODIGO, SZQ.ZQ_DESCR NOME "
		cQuery += " FROM "+RetSQLName("SZQ") + " SZQ "
		cQuery += " WHERE SZQ.ZQ_FILIAL  = '" + xFilial("SZQ") 	+ "' "
		cQuery += " AND SZQ.D_E_L_E_T_= ' ' "

	ElseIf cTabela == "POSICAO"
		cQuery := " SELECT ZZ9.ZZ9_CODPOS CODIGO, ZZ9.ZZ9_DESPOS NOME "
		cQuery += " FROM "+RetSQLName("ZZ9") + " ZZ9 "
		cQuery += " WHERE ZZ9.ZZ9_FILIAL  = '" + xFilial("ZZ9") 	+ "' "
		cQuery += " AND ZZ9.D_E_L_E_T_= ' ' "
	Endif


	If !Empty(cQuery)
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T., 'TOPCONN', TcGenQry(,,cQuery), _cAlias1)

		If (_cAlias1)->(EOF())
			Aadd(	aListBox1	,;
				{	.F.			,;	//01
			" "			,;	//02
			" "			})	//03
		Else
			While (_cAlias1)->(!EOF())

				If cTabela <> "ATENDENTE"
					Aadd(	aListBox1				,;
						{	.F.						,;	//01
					(_cAlias1)->CODIGO		,;	//02
					(_cAlias1)->NOME		})	//03
				Else
					Aadd(	aListBox1								,;
						{	.F.										,;	//01
					(_cAlias1)->CODIGO						,;	//02
					Alltrim(UsrRetName((_cAlias1)->CODIGO))	})	//03

				Endif
				(_cAlias1)->(DbSkip())
			End
		Endif
	Endif

	oListBox1:SetArray(aListBox1)

	oListBox1:bLine := {|| ;
		{Iif(aListBox1[	oListBox1:nAT,1],oCheck ,oNoCheck),;
		aListBox1[oListBox1:nAT,02]	,;
		aListBox1[oListBox1:nAT,03] }}

	oListBox1:Refresh()

	(_cAlias1)->(DbCloseArea())


Return(.T.)

Static Function RetMark()
	Local nX	:= 0

	__cMark:=""

	For nX:=1 to Len(aListBox1)

		If aListBox1[nX][1]
			If Empty(__cMark)
				__cMark := aListBox1[nX][2]
			Else
				__cMark += "," + aListBox1[nX][2]
			Endif
		End

	Next

Return(.T.)


Static Function GrvList()
	Aadd(	aListBox1	,;
		{	.F.			,;	//01
	" "			,;	//02
	" "			,;	//03
	" "			,;	//04
	" "			,;	//05
	" "			,;	//06
	" "			,;	//07
	" "			,;	//08
	" "			,;	//09
	" "			,;	//10
	" "			,;	//11
	" "			,;	//12
	" "			,;	//13
	" "			,;	//14
	" "			,;	//15
	" "			,;	//16
	" "			,;	//17
	" "			,;	//18
	" "			,;	//19
	" "			,;	//20
	" "			,;	//21
	" "			,;	//22
	" "			,;	//23
	" "			,;	//24
	" "			,;	//25
	" "			,;	//26
	" "			,;	//27
	" "			,;	//28
	" "			,;	//29
	" "			,;	//30
	" "			,;	//31
	" "			,;	//32
	" "			,;	//33
	" "			,;	//34
	" "			,;	//35
	" "			,;	//36
	" "			})	//37
Return

/*
=====================================================================================
Programa............: SEGMSE1
Autor...............: Barbieri
Data................: 07/02/2017
Descricao / Objetivo: Gatilho para campo E1_ZCODSEG
Doc. Origem.........: GAP CRE25
Solicitante.........: Cliente
Uso.................: 
Obs.................:
=====================================================================================
*/
User Function SEGMSE1()

	Local aArea		:= GetArea()
	Local aAreaSC5  := SC5->(GetArea())
	Local aAreaSA1  := SA1->(GetArea())
	Local cCodSeg   := ""

	If FunName() $ "MATA410/MATA460A/MATA461"

		dbSelectArea('SC5')
		dbSetOrder(1)
		SC5->(DbSeek(xFilial('SC5') + SE1->E1_PEDIDO))
		If !Empty(SC5->C5_ZCODSEG)
			cCodSeg := SC5->C5_ZCODSEG
		Else
			dbSelectArea('SA1')
			dbSetOrder(1)
			SA1->(DbSeek(xFilial('SA1') + SE1->E1_CLIENTE + SE1->E1_LOJA))
			cCodSeg := SA1->A1_CODSEG
		Endif

		SE1->E1_ZCODSEG := cCodSeg

	Endif
	RestArea(aAreaSA1)
	RestArea(aAreaSC5)
	RestArea(aArea)

Return


Static Function MGFFIN3601()

	AADD( aCampos , { "E1_FILIAL"	, "C" , TamSX3("E1_FILIAL")[1]	, TamSX3("E1_FILIAL")[2]	} )
	AADD( aCampos , { "E1_CLIENTE"	, "C" , TamSX3("E1_CLIENTE")[1]	, TamSX3("E1_CLIENTE")[2]	} )
	AADD( aCampos , { "E1_NOMCLI"	, "C" , TamSX3("E1_NOMCLI")[1]	, TamSX3("E1_NOMCLI")[2]	} )
	AADD( aCampos , { "E1_NUM"		, "C" , TamSX3("E1_NUM")[1]		, TamSX3("E1_NUM")[2]		} )
	AADD( aCampos , { "E1_EMISSAO"	, "D" , TamSX3("E1_EMISSAO")[1]	, TamSX3("E1_EMISSAO")[2]	} )
	AADD( aCampos , { "E1_VALOR"	, "N" , TamSX3("E1_VALOR")[1]	, TamSX3("E1_VALOR")[2]	} )
	AADD( aCampos , { "E1_OK"		, "C" , 2	, 0	} )

	cNomArq := CriaTrab(,.F.)

	dbCreate( cNomArq , aCampos , "TOPCONN" )

	dbUseArea( .T. , "TOPCONN" , cNomArq , "TRB" , .T. , .F. )
	dbCreateIndex( cNomArq , "E1_CLIENTE+E1_NUM" )

	dbSelectArea( "TRB" )
	dbSetOrder(1)

	SE1->( dbGoTop() )
	While !SE1->( eof() )
		RecLock("TRB",.T.)
		TRB->E1_FILIAL	:= SE1->E1_FILIAL
		TRB->E1_CLIENTE	:= SE1->E1_CLIENTE
		TRB->E1_NOMCLI	:= SE1->E1_NOMCLI
		TRB->E1_EMISSAO	:= SE1->E1_EMISSAO
		TRB->E1_VALOR	:= SE1->E1_VALOR
		TRB->( msUnlock() )

		SE1->( dbSkip() )
	EndDo

Return

/* Funcao que retorna as interacoes de cobranca*/

User Function MGFIN36B()

Local cQuery  := ""
Local cAlias
Local cFilial  := (oBrowse:Alias())->E1_FILIAL
Local cNum     := (oBrowse:Alias())->E1_NUM
Local cParcela := (oBrowse:Alias())->E1_PARCELA
Local cTipo    := (oBrowse:Alias())->E1_TIPO
Local cCliente := (oBrowse:Alias())->E1_CLIENTE
Local cLoja    := (oBrowse:Alias())->E1_LOJA
Local aRet     := {}
Local lMark    := .F.

cAlias	:= GetNextAlias()

cQuery := "SELECT  SE1.* , ZZB.*, ZZB.R_E_C_N_O_  ZZB_RECNO FROM " + RetSqlName("SE1") + " SE1, "+RetSqlName("ZZB") + " ZZB "

cQuery += " WHERE SE1.E1_FILIAL = '" + cFilial + "' "
cQuery += " AND SE1.E1_NUM = ZZB.ZZB_NUM "
cQuery += " AND SE1.E1_PREFIXO = ZZB.ZZB_PREFIX "
cQuery += " AND SE1.E1_PARCELA = ZZB_PARCEL "
cQuery += " AND SE1.E1_TIPO = ZZB.ZZB_TIPO "
cQuery += " AND SE1.E1_FILIAL = ZZB.ZZB_FILORI "
cQuery += " AND SE1.E1_NUM = '" + cNum + "' "
cQuery += " AND SE1.E1_PARCELA = '" + cParcela + "' "
cQuery += " AND SE1.E1_TIPO = '" + cTipo + "' "
cQuery += " AND SE1.E1_CLIENTE = '" + cCliente + "' "
cQuery += " AND SE1.E1_LOJA = '" + cLoja + "' "
/* retirado por Paulo Fernandes devido ao join nao estar atendendo a pesquisa 21/05/2018
cQuery += " AND SE1.E1_ZATEND = ZZB.ZZB_ZATEN	 "
cQuery += " AND SE1.E1_ZSEGMEN= ZZB.ZZB_ZSEGME	 "
cQuery += " AND SE1.E1_ZDESRED= ZZB.ZZB_ZDESRE  "
*/
cQuery += " AND SE1.D_E_L_E_T_='' "
cQuery += " AND ZZB.D_E_L_E_T_='' "

cQuery += " ORDER BY ZZB_DATA "

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlias, .F., .T.)

While !(cAlias)->(eof())

	AADD (aRet, {(cAlias)->ZZB_NUM, (cAlias)->ZZB_PARCEL,(cAlias)->ZZB_TIPO, (cAlias)->ZZB_DATA, (cAlias)->ZZB_HORA, (cAlias)->ZZB_RECNO, (cAlias)->ZZB_FILIAL})

	(cAlias)->(DBSKIP())
Enddo

ListBoxMar(aRet)

Return

Static Function ListBoxMar(aVetor)

Local cVar     := Nil
Local oDlg     := Nil
Local cTitulo  := "Consulta acompanhamentos de cobranca"
Local oOk      := LoadBitmap( GetResources(), "CHECKED" )   //CHECKED    //LBOK  //LBTIK
Local oNo      := LoadBitmap( GetResources(), "UNCHECKED" ) //UNCHECKED  //LBNO
Local oChk     := Nil
Local lMarca   := .T.
Local cNrom	   := ""
Local nLinha	:= 0
Local nTotLinha	:= 0
Local cSveFil	:= cFilAnt
Private cCadastro := "Acompanhamento de cobranca"
Private lChk   := .F.
Private oLbx   := Nil

aVetor1 := aVetor

//+-----------------------------------------------+
//| Monta a tela para usuario visualizar consulta |
//+-----------------------------------------------+
If Len( aVetor1 ) == 0
   Aviso( cTitulo, "Nao h� interacoes", {"Ok"} )
Else


DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 240,500 PIXEL
dBselectArea('ZZB')
@ 10,10 LISTBOX oLbx VAR cVar FIELDS HEADER "Titulo", "Parcela", "Tipo", "Data interacao", "Hora interacao", "Recno" SIZE 230,095 OF oDlg PIXEL ;
  ON dblClick(ZZB->(dBgoto(aVetor1[oLbx:nAt,6])),cSveFil:=cFilAnt,cFilAnt:=aVetor1[oLbx:nAt,7],aXvisual("ZZB",aVetor1[oLbx:nAt,6],2),cFilAnt:=cSveFil)

oLbx:SetArray( aVetor1 )
oLbx:bLine := {|| {aVetor1[oLbx:nAt,1],;
                   aVetor1[oLbx:nAt,2],;
                   aVetor1[oLbx:nAt,3],;
                   Stod(aVetor1[oLbx:nAt,4]),;
                   aVetor1[oLbx:nAt,5],;
                   str(aVetor1[oLbx:nAt,6]),;
                   aVetor1[oLbx:nAt,7]}}
DEFINE SBUTTON FROM 107,213 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg CENTER

Endif

Return


// AQUI REFAZ TODOS AS REGRAS PARA TODOS OS ATENDENTES
User Function MGFIN36C()

Local cQuery  := ""
Local aRet     := .T.

cQuery := " SELECT A1_COD,A1_LOJA,A1_CODSEG,A1_ZREDE,AOV_DESSEG,ZQ_DESCR  "
cQuery += " FROM " + RetSqlName("SA1") + " "
cQuery += " LEFT OUTER JOIN " + RetSqlName("AOV") + " ON  AOV_CODSEG=A1_CODSEG "
cQuery += " LEFT OUTER JOIN " + RetSqlName("SZQ") + " ON  ZQ_COD=A1_ZREDE "
cQuery += " WHERE A1_CODSEG||A1_ZREDE IN ( "
cQuery += " (SELECT ZDM_CODSEG||ZDN_CODRED "
cQuery += " FROM " + RetSqlName("ZDM") + "  "
cQuery += " LEFT OUTER JOIN " + RetSqlName("ZDN") + " ON ZDN010.D_E_L_E_T_<>'*' AND ZDN_USUARI=ZDM_USUARI
cQuery += " WHERE ZDM010.D_E_L_E_T_<>'*'))
cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlias, .F., .T.)

CCONT :=0
While !(cAlias)->(eof())
       CCONT++


	(cAlias)->(DBSKIP())
Enddo
//MSGALERT("QTDE "+TRANS(CCONT,"999999"))

Return
