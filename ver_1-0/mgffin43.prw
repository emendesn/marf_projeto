#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#INCLUDE "TOPCONN.CH"
/*
=====================================================================================
Programa.:              MGFFIN43
Autor....:              Atilio Amarilla
Data.....:              30/01/2017
Descricao / Objetivo:   Browse FIDC (MVC)
Doc. Origem:
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
User Function MGFFIN43()
	
	Local oBrowse
	
	Private cTipo	:= ""
	Private aDados	:= {}
	
	// Verificar qual Banco serА UTILIZADO visando identificar os 
	// parБmetros. 28/08/2018- GDN
	Private nMgBco := U_MGFVldBco()
	
	If nMgBco==1
		Private cBcoFIDC	:= GetMv("MGF_FIN43A",,"341/1000/123456/001")	// Banco FIDC
	Else
		Private cBcoFIDC	:= GetMv("MGF_FIN44A",,"237/123/12345/001")		// Banco FIDC
	Endif

	Private aBcoFIDC	:= StrToKArr(cBcoFIDC,"/")
	Private cAgeFIDC, cCtaFIDC, cSubFIDC
	
	cBcoFIDC	:= aBcoFIDC[1]
	cAgeFIDC	:= Stuff( Space( TamSX3("A6_AGENCIA")[1] ) , 1 , Len(AllTrim(aBcoFIDC[2])) , Alltrim(aBcoFIDC[2]) )
	cCtaFIDC	:= Stuff( Space( TamSX3("A6_NUMCON")[1] ) , 1 , Len(AllTrim(aBcoFIDC[3])) , Alltrim(aBcoFIDC[3]) )
	cSubFIDC	:= Stuff( Space( TamSX3("EE_SUBCTA")[1] ) , 1 , Len(AllTrim(aBcoFIDC[4])) , Alltrim(aBcoFIDC[4]) )
	
	If nMgBco==1
		Private cArqCfg	:= GetMv("MGF_FIN43B",,"\EDI\ITAU\FIDC\CFG\FIDC.REM")	// Arquivo de ConfiguraГЦo FIDC
		Private cPatLoc	:= GetMv("MGF_FIN43D",,"C:\ITAU\FIDC\REM\")				// Path de gravaГЦo de Arquivos
	Else
		Private cArqCfg	:= GetMv("MGF_FIN44B",,"\EDI\BRA\FIDC\CFG\FIDC.REM")	// Arquivo de ConfiguraГЦo FIDC
		Private cPatLoc	:= GetMv("MGF_FIN44D",,"C:\BRA\FIDC\REM\")				// Path de gravaГЦo de Arquivos
	Endif	
	
	Private cPatRem	:= GetMv("MGF_FIN43C",,"\EDI\ITAU\FIDC\REM\")			// Path de gravaГЦo de Arquivos

	Private aPatLoc	:= StrToKArr(cPatLoc,"\")
	Private cArqRem, cArqExc
	
	If nMgBco==1
		Private cRecAut	:= GetMv("MGF_FIN43E",,"90")	// Tabela (SX5) com motivos da recompra automАtica
		Private cMotVal	:= GetMv("MGF_FIN43F",,"90")	// CСdigo de recompra para alteraГЦo de valor
		Private cMotDat	:= GetMv("MGF_FIN43G",,"91")	// CСdigo de recompra para alteraГЦo de vencimento
		Private cMotDev	:= GetMv("MGF_FIN43H",,"92")	// CСdigo de recompra para alteraГЦo por baixa (devoluГЦo)
		Private cMotBx	:= GetMv("MGF_FIN43J",,"93")	// CСdigo de recompra para baixa em banco diferente de FIDC
		Private cRecMan	:= GetMv("MGF_FIN43I",,"91")	// Tabela (SX5) com motivos da recompra Manual
	Else
		Private cRecAut	:= GetMv("MGF_FIN44E",,"90")	// Tabela (SX5) com motivos da recompra automАtica
		Private cMotVal	:= GetMv("MGF_FIN44F",,"90")	// CСdigo de recompra para alteraГЦo de valor
		Private cMotDat	:= GetMv("MGF_FIN44G",,"91")	// CСdigo de recompra para alteraГЦo de vencimento
		Private cMotDev	:= GetMv("MGF_FIN44H",,"92")	// CСdigo de recompra para alteraГЦo por baixa (devoluГЦo)
		Private cMotBx	:= GetMv("MGF_FIN44J",,"93")	// CСdigo de recompra para baixa em banco diferente de FIDC
		Private cRecMan	:= GetMv("MGF_FIN44I",,"91")	// Tabela (SX5) com motivos da recompra Manual	
	Endif
	
	If nMgBco==1
		Private cArqCfgRec	:= GetMv("MGF_FIN43K",,"\EDI\ITAU\FIDC\CFG\RECOMPRA.REM")	// Arquivo de ConfiguraГЦo Recompra
		Private nLinGrid	:= GetMv("MGF_FIN43L",,30000)	// NЗmero mАximo de linhas no grid, padrЦo = 990
	Else
		Private cArqCfgRec	:= GetMv("MGF_FIN44K",,"\EDI\BRA\FIDC\CFG\RECOMPRA.REM")	// Arquivo de ConfiguraГЦo Recompra
		Private nLinGrid	:= GetMv("MGF_FIN44L",,30000)	// NЗmero mАximo de linhas no grid, padrЦo = 990
	Endif

	// Instanciamento da Classe de Browse
	oBrowse := FWMBrowse():New()
	
	// DefiniГЦo da tabela do Browse
	oBrowse:SetAlias('ZA7')
	
	// DefiniГЦo da legenda
	oBrowse:AddLegend( "ZA7_TIPO=='1'.And.ZA7_STATUS=='1'"	, "YELLOW"	, "FIDC - Envio Pendente"	)
	oBrowse:AddLegend( "ZA7_TIPO=='1'.And.ZA7_STATUS=='2'"	, "GREEN"	, "FIDC - Enviado"			)
	oBrowse:AddLegend( "ZA7_TIPO=='2'.And.ZA7_STATUS=='1'"	, "ORANGE"	, "Recompra - Envio Pendente")
	oBrowse:AddLegend( "ZA7_TIPO=='2'.And.ZA7_STATUS=='2'"	, "BLUE"	, "Recompra - Enviado"		)

	// Titulo da Browse
	oBrowse:SetDescription('FIDC')
	
	// AtivaГЦo da Classe
	oBrowse:Activate()
	
Return NIL

Return

//-------------------------------------------------------------------

Static function MenuDef()
	local aRotina := {}
	
	ADD OPTION aRotina TITLE 'Pesquisar'		ACTION 'PesqBrw'			OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE 'Visualizar'		ACTION 'VIEWDEF.MGFFIN43'	OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Incluir'			ACTION 'VIEWDEF.MGFFIN43'	OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar'			ACTION 'VIEWDEF.MGFFIN43'	OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Gerar Arq. Rem'	ACTION "U_MGFFIN44()"		OPERATION 6 ACCESS 0
	ADD OPTION aRotina TITLE 'Gerar Arq. XML'	ACTION "U_MGFFINBA()"		OPERATION 9 ACCESS 0
	ADD OPTION aRotina TITLE 'Imprimir'			ACTION "U_MGFFIN46('1')"	OPERATION 7 ACCESS 0
	ADD OPTION aRotina TITLE 'Imprimir Rejeit.'	ACTION "U_MGFFIN46('2')"	OPERATION 8 ACCESS 0
	ADD OPTION aRotina TITLE 'Excluir'			ACTION 'VIEWDEF.MGFFIN43'	OPERATION 5 ACCESS 0
	
Return aRotina

//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
DefiniГЦo do modelo de Dados

@author atilio.duarte

@since 31/01/2017
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ModelDef()
	Local oModel
	
	Local oStr1:= FWFormStruct(1,'ZA7')
	Local oStr2:= FWFormStruct(1,'ZA8')
	
	oModel := MPFormModel():New('ModelZA7')//,,,/*{|oModel| fGrava(oModel)}*/,{|oModel| fSair(oModel)})
	oModel:SetDescription('FIDC')
	
	oModel:addFields('ZA7MASTER',,oStr1)
	
	oModel:SetPrimaryKey({ 'ZA7_FILIAL', 'ZA7_CODREM' })
	
	bPre		:= {|oModelGrid,nLinha,cAcao,cCampo,xValor,xValAt| fbPreGrid(oModelGrid,nLinha,cAcao,cCampo,xValor,xValAt) }
	bLinePre	:= {|oModelGrid,nLinha,cAcao,cCampo,xValor| fbPreLineGrid(oModelGrid,nLinha,cAcao,cCampo,xValor) }
	bLineOk		:= {|oModelGrid,nLinha| fbLineOk(oModelGrid,nLinha) }
	
	oModel:addGrid('ZA8GRID','ZA7MASTER',oStr2,/*blinePre*/,/*bLineOk*/,/*bPre*/,{|| fTudoOk()})
	oModel:SetRelation('ZA8GRID', { { 'ZA8_FILIAL', 'xFilial("ZA8")' }, { 'ZA8_CODREM', 'ZA7_CODREM' } }, ZA8->(IndexKey(1)) )
	
	oModel:GetModel('ZA7MASTER'):SetDescription('FIDC')
	oModel:GetModel('ZA8GRID'):SetDescription('FIDC - TМtulos')

	oModel:GetModel('ZA8GRID'):SETMAXLINE(nLinGrid)
	
	oModel:SetVldActivate( {|oModel| fValidTipo(oModel) } )
	oModel:SetActivate( {|oModel| Processa({|| fInitForm(oModel) },"Aguarde - SeleГЦo de TМtulos") } )
	
Return oModel

//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
DefiniГЦo do interface

@author atilio.duarte

@since 31/01/2017
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ViewDef()
	Local oView
	Local oModel := ModelDef()
	
	Local oStr1:= FWFormStruct(2,'ZA7')
	
	Local cFldZA8   := "ZA8_FILIAL/ZA8_CODREM/"
	Local oStr2:= FWFormStruct(2,'ZA8',{|cCampo|!(AllTrim(cCampo) $ cFldZA8)})
	
	oView := FWFormView():New()
	
	oView:SetModel(oModel)
	oView:SetDescription('FIDC')
	
	oView:AddField('ZA7MASTER' , oStr1 )
	oView:AddGrid('ZA8GRID' , oStr2)
	
	oStr1:SetProperty( '*' , MVC_VIEW_CANCHANGE ,.F.)
	oStr2:SetProperty( '*' , MVC_VIEW_CANCHANGE ,.F.)
	
	oView:CreateHorizontalBox( 'BOXFORM1', 25)
	oView:CreateHorizontalBox( 'BOXFORM2', 75)
	oView:SetOwnerView('ZA8GRID','BOXFORM2')
	oView:SetOwnerView('ZA7MASTER','BOXFORM1')
	
	oView:AddUserButton(═'Recompra Manual'══,═'CLIPS',═{|oView|═U_MGFFIN45()}═)
	oView:AddUserButton(═'Busca de TМtulo'══,═'CLIPS',═{|oView|═U_MGFFIN71()}═)
	oView:AddUserButton(═'Baixa Manual FIDC',═'CLIPS',═{|oView|═U_bxtitfid()}═)
	oView:AddUserButton(═'Recompra Manual Planilha FIDC',═'CLIPS',═{|oView|═U_MGFFINA3()}═)
	
Return oView

Static Function fGrava(oModel)
	
	Local lRet := .T.
	
	Begin Transaction
		
		If oModel:VldData()
			If oModel:GetOperation() == MODEL_OPERATION_INSERT
				ConfirmSX8()
			EndIf
			FwFormCommit(oModel)
			oModel:DeActivate()
		Else
			JurShowErro( oModel:GetModel():GetErrormessage() )
			lRet := .F.
			DisarmTransaction()
		EndIf
	End Transaction
	
Return( lRet )

Static Function fSair(oModel)
	
	Local lRet := .t.
	
	If oModel:GetOperation() == MODEL_OPERATION_INSERT
		RollBackSX8()
	EndIf
	
Return lRet

Static Function fInitForm(oModel)
	
	Local lRet := .T.
	Local oModelCab := oModel:GetModel('ZA7MASTER')
	Local oModelGrid := oModel:GetModel('ZA8GRID')
	Local aPergs	:= {}
	Local aTipos	:= {"FIDC","Recompra","Baixa"}
	Local aRet		:= {}
	Local nLinha
	
	If oModel:GetOperation() == MODEL_OPERATION_INSERT
		
		oModelCab:SetValue( "ZA7_TIPO"	, cTipo	)
		
		oModelGrid:SetNoInsertLine(.F.)
		
		If Len( aDados ) > 0
			For nLinha := 1 to Len( aDados )
				
				If nLinha # 1
					oModelGrid:AddLine()
				EndIf
				
				oModelGrid:GoLine( nLinha )
				oModelGrid:SetValue("ZA8_STATUS"	, "1"			)
				oModelGrid:SetValue("ZA8_PREFIX"	, aDados[nLinha,1,01]	)
				oModelGrid:SetValue("ZA8_NUM"		, aDados[nLinha,1,02]	)
				oModelGrid:SetValue("ZA8_PARCEL"	, aDados[nLinha,1,03]	)
				oModelGrid:SetValue("ZA8_TIPO"		, aDados[nLinha,1,04]	)
				oModelGrid:SetValue("ZA8_VENCRE"	, aDados[nLinha,1,05]	)
				oModelGrid:SetValue("ZA8_VALOR"		, aDados[nLinha,1,06]	)
				oModelGrid:SetValue("ZA8_BANCO"		, aDados[nLinha,1,07]	)
				oModelGrid:SetValue("ZA8_AGENCI"	, aDados[nLinha,1,08]	)
				oModelGrid:SetValue("ZA8_CONTA"		, aDados[nLinha,1,09]	)
				oModelGrid:SetValue("ZA8_NUMBOR"	, aDados[nLinha,1,10]	)
				oModelGrid:SetValue("ZA8_DATBOR"	, aDados[nLinha,1,11]	)
				oModelGrid:SetValue("ZA8_MOTREC"	, aDados[nLinha,1,12]	)
				oModelGrid:SetValue("ZA8_FILORI"	, aDados[nLinha,1,13]	)
				
			Next nLinha
		EndIf
		
	EndIf
	
	oModelGrid:SetNoInsertLine(.T.)
	
	
Return lRet

Static Function fValidTipo(oModel)
	
	Local lRet		:= .T.
	Local aArea		:= GetArea()
	Local cAlias	:= GetNextAlias()
	
	Local nCodRem	:= ""
	
	Local aPergs	:= {}
	Local aTipos	:= {"FIDC","Recompra","Baixa"}
	Local aRet		:= {}
	
	cTipo	:= ""
	aDados	:= {}
	
	If !Empty(ZA7->ZA7_DATA) .And. ( oModel:GetOperation() == MODEL_OPERATION_UPDATE .Or. oModel:GetOperation() == MODEL_OPERATION_DELETE )
		lRet		:= .F.
		Help( ,, 'ARQGERADO',, 'Arquivo remessa jА foi gerado.'+CRLF+'NЦo И permitido '+IIF(oModel:GetOperation() == MODEL_OPERATION_UPDATE,"alterar","excluir")+".", 1, 0 )
	ElseIf oModel:GetOperation() == MODEL_OPERATION_INSERT
		
		If ZA7->( eof() ) .And. ZA7->( bof() )
			cTipo	:= "1"
		Else
			/*
			2 - Combo
			[2] : DescriГЦo
			[3] : NumИrico contendo a opГЦo inicial do combo
			[4] : Array contendo as opГУes do Combo
			[5] : Tamanho do Combo
			[6] : ValidaГЦo
			[7] : Flag .T./.F. ParБmetro ObrigatСrio ?
			*/

			aAdd( aPergs ,{2,"Tipo de Envio",IIf( Len(aRet) > 0,aRet[],"FIDC"), {"FIDC", "Recompra","Baixa","Recompra Manual"}, 50,'Empty(fValTipo(aRet[1]))',.T.})

			If !ParamBox(aPergs ,"Parametros FIDC - Envio",aRet)
				Help( ,, 'FIDC - Envio',, 'Processamento Cancelado', 1, 0 )
				lRet := .F.
				RestArea( aArea )
				Return lRet
			EndIf
			
			If aRet[1] == "FIDC"
				cTipo		:="1"
			ElseIf Subs(aRet[1],1,8) == "Recompra"
				cTipo		:="2"
			ElseIf aRet[1] == "Baixa"
				cTipo		:="3"
            Else
            	cTipo		:="4"
            EndIf
						
		EndIf
		
		
		BeginSQL Alias cAlias
			
			SELECT ZA7_CODREM
			FROM %table:ZA7% ZA7
			WHERE ZA7.%notDel%
			AND ZA7_FILIAL = %xFilial:ZA7%
			AND ZA7_TIPO = %Exp:cTipo%
			AND ZA7_DATA = '        '
			ORDER BY ZA7_CODREM
			
		EndSQL
		
		aQuery := GetLastQuery()
		
		(cAlias)->(dbGoTop())
		If !(cAlias)->(eof()) .And. lRet
			cCodRem	:= (cAlias)->ZA7_CODREM
			lRet := .F.
		EndIf
		
		dbSelectArea(cAlias)
		dbCloseArea()
		
		If !lRet
			Help( ,, 'FIDC - Envio',, "Existe "+aRet[1]+" pendente: "+cCodRem, 1, 0 )
			cTipo	:= ""
			lRet	:= .F.
		Else

			If !( cTipo == "2" .And. IIf( !Empty(aRet) , aRet[1] == "Recompra Manual" , .F. ) )
				fSeleGridF(@aDados)
			EndIf

			If Empty( aDados ) .And. cTipo == "1"
				cTipo	:= ""
				lRet	:= .F.
			EndIf
		EndIf
	EndIf
	
	RestArea( aArea )
	
Return( lRet )

Static Function fSeleGridF(aDados)
	
	Local lRet := .T.
	Local aAux := {}
	
	Local aPergs	:= {}
	Local dEmiIni	:= dDataBase
	Local dEmiFim	:= dDataBase
	Local dCliIni	:= Space(TamSX3("A1_COD")[1])
	Local dCliFim	:= Replicate("Z",TamSX3("A1_COD")[1])
	Local aFilial, nI
	Local cFilQry	:= ""
	Local aSM0      := {} // FWLoadSM0(.T.,,.T.) 
	Local cOpcoes	:= ""
	Local aOpcoes	:= {}
	Local cTitulo	:= "SeleГЦo das Filiais"
	Local MvPar		:= ""//&(Alltrim(ReadVar()))		// Carrega Nome da Variavel do Get em Questao
	Local nTamFil	:= Len(xFilial("SE1"))
	Local cAlias	:= GetNextAlias()

	Private dVctIni	:= dDataBase+1
	Private dVctFim	:= dDataBase+1
	Private aRet := {}
	
	If cTipo == "1"
		/*
		1 - MsGet
		[2] : DescriГЦo
		[3] : String contendo o inicializador do campo
		[4] : String contendo a Picture do campo
		[5] : String contendo a validaГЦo
		[6] : Consulta F3
		[7] : String contendo a validaГЦo When
		[8] : Tamanho do MsGet
		[9] : Flag .T./.F. ParБmetro ObrigatСrio ?
		*/
		aAdd( aPergs ,{1,"EmissЦo De     : ",dEmiIni,"@!",'.T.'	,		,'.T.',50,.T.})
		aAdd( aPergs ,{1,"EmissЦo AtИ    : ",dEmiFim,"@!",'.T.'	,		,'.T.',50,.T.})
		aAdd( aPergs ,{1,"Vencimento De  : ",dVctIni,"@!",'.T.'	,		,'.T.',50,.T.})
		aAdd( aPergs ,{1,"Vencimento AtИ : ",dVctFim,"@!",'.T.'	,		,'.T.',50,.T.})
		aAdd( aPergs ,{1,"Cliente De     : ",dCliIni,"@!",'.T.'	,"SA1"	,'.T.',40,.F.})
		aAdd( aPergs ,{1,"Cliente AtИ    : ",dCliFim,"@!",'.T.'	,"SA1"	,'.T.',40,.T.})
		
		If !ParamBox(aPergs ,"Parametros FIDC - Remessa",aRet)
			Aviso("FIDC - Remessa","Processamento Cancelado!",{'Ok'})
			Return
		EndIf

		If Select(cAlias) > 0
			(cAlias)->(DbClosearea())
		Endif

		BeginSql Alias cAlias

			SELECT M0_CODFIL, M0_FILIAL, M0_CGC
			FROM SYS_COMPANY SM0
			WHERE SM0.%NotDel%
				AND SM0.M0_CODIGO = %Exp:cEmpAnt%
				AND SUBSTR(M0_CODFIL,1,2) = %Exp:Subs(cFilAnt,1,2)%
			ORDER BY M0_CODFIL

		EndSql

		nI	:= 0
		While (cAlias)->(!EOF())
			AADD(aOpcoes, {Subs((cAlias)->M0_CODFIL,1,nTamFil) , (cAlias)->M0_FILIAL , TRANSFORM((cAlias)->M0_CGC, "@R 99.999.999/9999-99" ) } )
			cOpcoes += Subs((cAlias)->M0_CODFIL,1,nTamFil)
			(cAlias)->(dbSkip())
			nI++
		EndDo

		If Select(cAlias) > 0
			(cAlias)->(DbClosearea())
		Endif

		If zAdmOpcoes(@MvPar,cTitulo,aOpcoes,cOpcoes,,,.F.,nTamFil,nI,.T.,,,,,,,,.T.)  // Chama funcao Adm_Opcoes)
							
			If !Empty(cOpcoes)
				For ni := 1 To Len(MvPar) STEP nTamFil
					If Subs(MvPar,nI,nTamFil) <> "******"
						cFilQry += IIF(Empty(cFilQry),"","','") + Subs(MvPar,nI,nTamFil)
					EndIf 
				Next
			EndIf

		EndIf
		
		If Empty(cFilQry)
			cFilQry := cFilAnt
		EndIf

		BeginSQL Alias cAlias
			
			SELECT SE1.R_E_C_N_O_ E1_RECNO, SE1.*
			FROM %table:SE1% SE1
			LEFT JOIN %table:ZA8% ZA8 ON ZA8.%notDel%
				AND ZA8_FILIAL = %xFilial:ZA8%
				AND ZA8_FILORI = E1_FILIAL
				AND ZA8_PREFIX = E1_PREFIXO
				AND ZA8_NUM = E1_NUM
				AND ZA8_PARCEL = E1_PARCELA
				AND ZA8_TIPO = E1_TIPO
				AND ZA8_STATUS IN ('1','2')
			LEFT JOIN %table:ZA7% ZA7 ON ZA7.%notDel%
				AND ZA7_FILIAL = ZA8_FILIAL
				AND ZA7_CODREM = ZA8_CODREM
				AND ZA7_STATUS IN ('1','2')
				AND ZA7_TIPO = '1'
			WHERE SE1.D_E_L_E_T_ = ' '
				AND E1_FILIAL IN ( %Exp:cFilQry% )
				AND E1_EMISSAO BETWEEN %Exp:DTOS(aRet[1])% AND %Exp:DTOS(aRet[2])%
				AND E1_VENCREA BETWEEN %Exp:DTOS(Max(aRet[3],Date()+1))% AND %Exp:DTOS(aRet[4])%
				AND E1_CLIENTE BETWEEN %Exp:aRet[5]% AND %Exp:aRet[6]%
				AND E1_SITUACA = '1'
				AND E1_PORTADO = %Exp:cBcoFIDC%
				AND E1_AGEDEP || E1_CONTA <> %Exp:cAgeFIDC+cCtaFIDC%
				AND E1_BAIXA = ''
				AND E1_IDCNAB <> ''
				AND E1_SDACRES = 0.00
				AND E1_SDDECRE = 0.00
				AND ZA8_NUM IS NULL
			ORDER BY E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO
			
		EndSQL
		
		aQuery := GetLastQuery()

		While !(cAlias)->(EOF())
			
			aAux := {}
			
			aAdd( aAux , {	( cAlias )->E1_PREFIXO			,;
							( cAlias )->E1_NUM				,;
							( cAlias )->E1_PARCELA			,;
							( cAlias )->E1_TIPO				,;
							STOD( ( cAlias )->E1_VENCREA )	,;
							( cAlias )->E1_VALOR			,;
							( cAlias )->E1_PORTADO			,;
							( cAlias )->E1_AGEDEP			,;
							( cAlias )->E1_CONTA			,;
							( cAlias )->E1_NUMBOR			,;
							STOD(( cAlias )->E1_DATABOR )	,;
							"  "							,;
							( cAlias )->E1_FILIAL			} )
			
			aAdd( aDados , aAux )
			
			(cAlias)->( dbSkip() )
		EndDo
		
		dbSelectArea(cAlias)
		dbCloseArea()
		
	Elseif cTipo == "2" // Recompra
		// Busca Recompra AutomАtica
		
		BeginSQL Alias cAlias
			
			SELECT E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_VENCREA, E1_PORTADO, E1_AGEDEP, E1_CONTA, E1_NUMBOR, E1_DATABOR, E1_VALOR, 
				E1_SDACRES, E1_SDDECRE, E1_VENCREA, ZA8_VENCRE, ZA8_CODREM
			FROM %table:SE1% SE1
			INNER JOIN %table:ZA8% ZA8 ON ZA8.%notDel%
				AND ZA8_FILIAL = %xFilial:ZA8%
				AND ZA8_FILORI = E1_FILIAL
				AND ZA8_PREFIX = E1_PREFIXO
				AND ZA8_NUM = E1_NUM
				AND ZA8_PARCEL = E1_PARCELA
				AND ZA8_TIPO = E1_TIPO
				AND ZA8_STATUS IN ('1','2')
				AND ZA8_RECOMP NOT IN  ('1','2')
			INNER JOIN %table:ZA7% ZA7 ON ZA7.%notDel%
				AND ZA7_FILIAL = ZA8_FILIAL
				AND ZA7_CODREM = ZA8_CODREM
				AND ZA7_STATUS IN ('1','2')
				AND ZA7_TIPO = '1'
				AND ZA7_DATA <> '        '
			WHERE SE1.%notDel%
				AND SUBSTR(E1_FILIAL,1,2) = %Exp:Subs(cFilAnt,1,2)%
				AND E1_SITUACA = '1'
				AND E1_PORTADO = %Exp:cBcoFIDC%
				AND E1_AGEDEP = %Exp:cAgeFIDC%
				AND E1_CONTA = %Exp:cCtaFIDC%
				AND E1_BAIXA = '        '
				AND E1_IDCNAB <> '          '
				AND ( E1_SDACRES <> 0.00 OR E1_SDDECRE <> 0.00 OR E1_VENCREA <> ZA8_VENCRE )
			ORDER BY 1, 2, 3, 4, 5
			
		EndSQL
		
		aQuery := GetLastQuery()
		
		MemoWrit( "C:\TEMP\"+FunName()+"-Recompra-E1-"+DTOS(Date())+StrTran(Time(),":")+".SQL" , aQuery[2] )
		
		While !(cAlias)->(EOF())
			
			aAux := {}
			
			cMotRec := "  "
			If ( cAlias )->E1_SDACRES <> 0.00 .Or. ( cAlias )->E1_SDDECRE <> 0.00
				cMotRec := cMotVal
			ElseIf ( cAlias )->E1_VENCREA <> ( cAlias )->ZA8_VENCRE
				cMotRec := cMotDat
			EndIf
			
			aAdd( aAux , {	( cAlias )->E1_PREFIXO			,;
							( cAlias )->E1_NUM				,;
							( cAlias )->E1_PARCELA			,;
							( cAlias )->E1_TIPO				,;
							STOD( ( cAlias )->E1_VENCREA )	,;
							( cAlias )->E1_VALOR			,;
							( cAlias )->E1_PORTADO			,;
							( cAlias )->E1_AGEDEP			,;
							( cAlias )->E1_CONTA			,;
							( cAlias )->ZA8_CODREM			,;
							STOD( ( cAlias )->E1_DATABOR )	,;
							cMotRec							,;
							( cAlias )->E1_FILIAL			} )
			
			aAdd( aDados , aAux )
			
			(cAlias)->( dbSkip() )
		EndDo
		
		dbSelectArea(cAlias)
		dbCloseArea()
		
		// TМtulos Baixados em Banco diferente do FIDC
		
		BeginSQL Alias cAlias
			
			SELECT E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_VENCREA, E1_PORTADO, E1_AGEDEP, E1_CONTA, E1_NUMBOR, E1_DATABOR, 
					MIN(E1_VALOR) E1_VALOR, ZA8_CODREM
			FROM %table:SE1% SE1
			INNER JOIN %table:ZA8% ZA8 ON ZA8.%notDel%
				AND ZA8_FILIAL = %xFilial:ZA8%
				AND ZA8_FILORI = E1_FILIAL
				AND ZA8_PREFIX = E1_PREFIXO
				AND ZA8_NUM = E1_NUM
				AND ZA8_PARCEL = E1_PARCELA
				AND ZA8_TIPO = E1_TIPO
				AND ZA8_STATUS IN ('1','2')
				AND ZA8_RECOMP NOT IN  ('1','2')
			INNER JOIN %table:ZA7% ZA7 ON ZA7.%notDel%
				AND ZA7_FILIAL = ZA8_FILIAL
				AND ZA7_CODREM = ZA8_CODREM
				AND ZA7_STATUS IN ('1','2')
				AND ZA7_TIPO = '1'
				AND ZA7_DATA <> '        '
			INNER JOIN %table:SE5% SE5 ON SE5.%notDel%
				AND E5_FILIAL = E1_FILIAL
				AND E5_PREFIXO = E1_PREFIXO
				AND E5_NUMERO = E1_NUM
				AND E5_PARCELA = E1_PARCELA
				AND E5_TIPO = E1_TIPO
				AND E5_CLIENTE = E1_CLIENTE
				AND E5_LOJA = E1_LOJA
				AND E5_BANCO || E5_AGENCIA || E5_CONTA <> %Exp:CbCOfidc+cAgeFIDC+cCtaFIDC%
				AND E5_RECPAG = 'R'
				AND E5_TIPODOC IN ('VL','BA')
				AND E5_SITUACA = ' '
			WHERE SE1.%notDel%
				AND SUBSTR(E1_FILIAL,1,2) = %Exp:Subs(cFilAnt,1,2)%
				AND E1_SITUACA = '1'
				AND E1_PORTADO = %Exp:cBcoFIDC%
				AND E1_AGEDEP = %Exp:cAgeFIDC%
				AND E1_CONTA = %Exp:cCtaFIDC%
				AND E1_BAIXA <> '        '
				AND E1_IDCNAB <> '          '
			GROUP BY E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_VENCREA, E1_PORTADO, E1_AGEDEP, E1_CONTA, E1_NUMBOR, E1_DATABOR, ZA8_CODREM
			ORDER BY 1, 2, 3, 4, 5
			
		EndSQL
		
		aQuery := GetLastQuery()
		
		MemoWrit( "C:\TEMP\"+FunName()+"-Recompra-E5-"+DTOS(Date())+StrTran(Time(),":")+".SQL" , aQuery[2] )
		
		While !(cAlias)->(EOF())
			
			aAux := {}
			
			cMotRec := cMotBx
			
			aAdd( aAux , {	( cAlias )->E1_PREFIXO			,;
							( cAlias )->E1_NUM				,;
							( cAlias )->E1_PARCELA			,;
							( cAlias )->E1_TIPO				,;
							STOD( ( cAlias )->E1_VENCREA )	,;
							( cAlias )->E1_VALOR			,;
							( cAlias )->E1_PORTADO			,;
							( cAlias )->E1_AGEDEP			,;
							( cAlias )->E1_CONTA			,;
							( cAlias )->ZA8_CODREM			,;
							STOD( ( cAlias )->E1_DATABOR )	,;
							cMotRec							,;
							( cAlias )->E1_FILIAL			} )
			
			aAdd( aDados , aAux )
			
			(cAlias)->( dbSkip() )
		EndDo
		
		dbSelectArea(cAlias)
		dbCloseArea()
		
		// DevoluГУes
		
		BeginSQL Alias cAlias
			
			SELECT E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_VENCREA, E1_PORTADO, E1_AGEDEP, E1_CONTA, E1_NUMBOR, E1_DATABOR, 
					MIN(E1_VALOR) E1_VALOR, ZA8_CODREM
			FROM %table:SE1% SE1
			INNER JOIN %table:ZA8% ZA8 ON ZA8.%notDel%
				AND ZA8_FILIAL = %xFilial:ZA8%
				AND ZA8_FILORI = E1_FILIAL
				AND ZA8_PREFIX = E1_PREFIXO
				AND ZA8_NUM = E1_NUM
				AND ZA8_PARCEL = E1_PARCELA
				AND ZA8_TIPO = E1_TIPO
				AND ZA8_STATUS IN ('1','2')
				AND ZA8_RECOMP NOT IN  ('1','2')
			INNER JOIN %table:ZA7% ZA7 ON ZA7.%notDel%
				AND ZA7_FILIAL = ZA8_FILIAL
				AND ZA7_CODREM = ZA8_CODREM
				AND ZA7_STATUS IN ('1','2')
				AND ZA7_TIPO = '1'
				AND ZA7_DATA <> '        '
			INNER JOIN %table:SD2% SD2 ON SD2.%notDel%
				AND D2_FILIAL = E1_FILIAL
				AND D2_PEDIDO = E1_PEDIDO
				AND D2_SERIE = E1_PREFIXO
				AND D2_DOC = E1_NUM
				AND D2_CLIENTE = E1_CLIENTE
				AND D2_LOJA = E1_LOJA
				AND D2_TIPO = 'N'
				AND D2_QTDEDEV > 0
			WHERE SE1.%notDel%
				AND SUBSTR(E1_FILIAL,1,2) = %Exp:Subs(cFilAnt,1,2)%
				AND E1_SITUACA = '1'
				AND E1_PORTADO = %Exp:cBcoFIDC%
				AND E1_AGEDEP = %Exp:cAgeFIDC%
				AND E1_CONTA = %Exp:cCtaFIDC%
				AND E1_IDCNAB <> '        '
			GROUP BY E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_VENCREA, E1_PORTADO, E1_AGEDEP, E1_CONTA, E1_NUMBOR, E1_DATABOR, ZA8_CODREM
			ORDER BY 1, 2, 3, 4, 5
			
		EndSQL

		aQuery := GetLastQuery()
		
		MemoWrit( "C:\TEMP\"+FunName()+"-Recompra-D2-"+DTOS(Date())+StrTran(Time(),":")+".SQL" , aQuery[2] )
		
		While !(cAlias)->(EOF())
			
			aAux := {}
			
			cMotRec := cMotDev
			
			nPos := aScan(aDados, { |x| x[1]+x[2]+x[3]+x[4]+x[13] = ( cAlias )->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_FILIAL)  })
			
			If nPos == 0
				aAdd( aAux , {	( cAlias )->E1_PREFIXO			,;
								( cAlias )->E1_NUM				,;
								( cAlias )->E1_PARCELA			,;
								( cAlias )->E1_TIPO				,;
								STOD( ( cAlias )->E1_VENCREA )	,;
								( cAlias )->E1_VALOR			,;
								( cAlias )->E1_PORTADO			,;
								( cAlias )->E1_AGEDEP			,;
								( cAlias )->E1_CONTA			,;
								( cAlias )->ZA8_CODREM			,;
								STOD( ( cAlias )->E1_DATABOR )	,;
								cMotRec							,;
								( cAlias )->E1_FILIAL			} )
			
				aAdd( aDados , aAux )
			EndIf
			(cAlias)->( dbSkip() )
		EndDo
		
		dbSelectArea(cAlias)
		dbCloseArea()
		
	ElseIf cTipo == "3"
    // Baixa de titulos fidc - nova rotina Tarcisio

		BeginSQL Alias cAlias
			
			SELECT E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_VENCREA, E1_PORTADO, E1_AGEDEP, E1_CONTA, E1_NUMBOR, E1_DATABOR, E1_VALOR, 
				E1_SDACRES, E1_SDDECRE, E1_VENCREA, ZA8_VENCRE, ZA8_CODREM
			FROM %table:SE1% SE1
			INNER JOIN %table:ZA8% ZA8 ON ZA8.%notDel%
				AND ZA8_FILIAL = %xFilial:ZA8%
				AND ZA8_FILORI = E1_FILIAL
				AND ZA8_PREFIX = E1_PREFIXO
				AND ZA8_NUM = E1_NUM
				AND ZA8_PARCEL = E1_PARCELA
				AND ZA8_TIPO = E1_TIPO
				AND ZA8_STATUS IN ('1','2')
				AND ZA8_RECOMP NOT IN  ('1','2')
			INNER JOIN %table:ZA7% ZA7 ON ZA7.%notDel%
				AND ZA7_FILIAL = ZA8_FILIAL
				AND ZA7_CODREM = ZA8_CODREM
				AND ZA7_STATUS IN ('1','2')
				AND ZA7_TIPO = '1'
				AND ZA7_DATA <> '        '
			WHERE SE1.%notDel%
				AND SUBSTR(E1_FILIAL,1,2) = %Exp:Subs(cFilAnt,1,2)%
				AND E1_SITUACA = '1'
				AND E1_PORTADO = %Exp:cBcoFIDC%
				AND E1_AGEDEP || E1_CONTA = %Exp:cAgeFIDC+cCtaFIDC%
				AND E1_BAIXA =''
				AND E1_IDCNAB <> ''
			ORDER BY 1, 2, 3, 4, 5
			
		EndSQL
		
		aQuery := GetLastQuery()
		
		MemoWrit( "C:\"+FunName()+"-Baixa-E1-"+DTOS(Date())+StrTran(Time(),":")+".SQL" , aQuery[2] )
		
		While !(cAlias)->(EOF())
			
			aAux := {}
			
			cMotRec := "  "
			If ( cAlias )->E1_SDACRES <> 0.00 .Or. ( cAlias )->E1_SDDECRE <> 0.00
				cMotRec := cMotVal
			ElseIf ( cAlias )->E1_VENCREA <> ( cAlias )->ZA8_VENCRE
				cMotRec := cMotDat
			EndIf
			
			aAdd( aAux , {	( cAlias )->E1_PREFIXO			,;
							( cAlias )->E1_NUM				,;
							( cAlias )->E1_PARCELA			,;
							( cAlias )->E1_TIPO				,;
							STOD( ( cAlias )->E1_VENCREA )	,;
							( cAlias )->E1_VALOR			,;
							( cAlias )->E1_PORTADO			,;
							( cAlias )->E1_AGEDEP			,;
							( cAlias )->E1_CONTA			,;
							( cAlias )->ZA8_CODREM			,;
							STOD( ( cAlias )->E1_DATABOR )	,;
							cMotRec							,;
							( cAlias )->E1_FILIAL			} )
			
			aAdd( aDados , aAux )
			
			(cAlias)->( dbSkip() )
		EndDo
		
		dbSelectArea(cAlias)
		dbCloseArea()
		
		// TМtulos Baixados em Banco diferente do FIDC
		
		BeginSQL Alias cAlias
			
			SELECT E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_VENCREA, E1_PORTADO, E1_AGEDEP, E1_CONTA, E1_NUMBOR, E1_DATABOR, 
					MIN(E1_VALOR) E1_VALOR, ZA8_CODREM
			FROM %table:SE1% SE1
			INNER JOIN %table:ZA8% ZA8 ON ZA8.%notDel%
				AND ZA8_FILORI = E1_FILIAL
				AND ZA8_PREFIX = E1_PREFIXO
				AND ZA8_NUM = E1_NUM
				AND ZA8_PARCEL = E1_PARCELA
				AND ZA8_TIPO = E1_TIPO
				AND ZA8_STATUS IN ('1','2')
				AND ZA8_RECOMP NOT IN  ('1','2')
				AND SUBSTR(ZA8_FILIAL,1,2) = %Exp:Subs(cFilAnt,1,2)%
			INNER JOIN %table:ZA7% ZA7 ON ZA7.%notDel%
				AND ZA7_FILIAL = ZA8_FILIAL
				AND ZA7_CODREM = ZA8_CODREM
				AND ZA7_STATUS IN ('1','2')
				AND ZA7_TIPO = '1'
				AND ZA7_DATA <> '        '
				AND SUBSTR(ZA7_FILIAL,1,2) = %Exp:Subs(cFilAnt,1,2)%
			INNER JOIN %table:SE5% SE5 ON SE5.%notDel%
				AND E5_FILIAL = E1_FILIAL
				AND E5_PREFIXO = E1_PREFIXO
				AND E5_NUMERO = E1_NUM
				AND E5_PARCELA = E1_PARCELA
				AND E5_TIPO = E1_TIPO
				AND E5_CLIENTE = E1_CLIENTE
				AND E5_LOJA = E1_LOJA
				AND E5_BANCO || E5_AGENCIA || E5_CONTA <> %Exp:CbCOfidc+cAgeFIDC+cCtaFIDC%
				AND E5_RECPAG = 'R'
				AND E5_TIPODOC IN ('VL','BA')
				AND E5_SITUACA = ' '
			WHERE SE1.%notDel%
				AND SUBSTR(E1_FILIAL,1,2) = %Exp:Subs(cFilAnt,1,2)%
				AND E1_SITUACA = '1'
				AND E1_PORTADO = %Exp:cBcoFIDC%
				AND E1_AGEDEP || E1_CONTA = %Exp:cAgeFIDC+cCtaFIDC%
				AND E1_BAIXA <> ''
				AND E1_IDCNAB <> ''
			GROUP BY E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_VENCREA, E1_PORTADO, E1_AGEDEP, E1_CONTA, E1_NUMBOR, E1_DATABOR, ZA8_CODREM
			ORDER BY 1, 2, 3, 4, 5
			
		EndSQL
		
		aQuery := GetLastQuery()
		
		While !(cAlias)->(EOF())
			
			aAux := {}
			
			cMotRec := cMotBx
			
			aAdd( aAux , {	( cAlias )->E1_PREFIXO			,;
							( cAlias )->E1_NUM				,;
							( cAlias )->E1_PARCELA			,;
							( cAlias )->E1_TIPO				,;
							STOD( ( cAlias )->E1_VENCREA )	,;
							( cAlias )->E1_VALOR			,;
							( cAlias )->E1_PORTADO			,;
							( cAlias )->E1_AGEDEP			,;
							( cAlias )->E1_CONTA			,;
							( cAlias )->ZA8_CODREM			,;
							STOD( ( cAlias )->E1_DATABOR )	,;
							cMotRec							,;
							( cAlias )->E1_FILIAL			} )
			
			aAdd( aDados , aAux )
			
			(cAlias)->( dbSkip() )
		EndDo
		
		dbSelectArea(cAlias)
		dbCloseArea()
		
		// DevoluГУes
		
		BeginSQL Alias cAlias
			
			SELECT E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_VENCREA, E1_PORTADO, E1_AGEDEP, E1_CONTA, E1_NUMBOR, E1_DATABOR, 
					MIN(E1_VALOR) E1_VALOR, ZA8_CODREM
			FROM %table:SE1% SE1
			INNER JOIN %table:ZA8% ZA8 ON ZA8.%notDel%
				AND ZA8_FILORI = E1_FILIAL
				AND ZA8_PREFIX = E1_PREFIXO
				AND ZA8_NUM = E1_NUM
				AND ZA8_PARCEL = E1_PARCELA
				AND ZA8_TIPO = E1_TIPO
				AND ZA8_STATUS IN ('1','2')
				AND ZA8_RECOMP NOT IN  ('1','2')
				AND SUBSTR(ZA8_FILIAL,1,2) = %Exp:Subs(cFilAnt,1,2)%
			INNER JOIN %table:ZA7% ZA7 ON ZA7.%notDel%
				AND ZA7_FILIAL = ZA8_FILIAL
				AND ZA7_CODREM = ZA8_CODREM
				AND ZA7_STATUS IN ('1','2')
				AND ZA7_TIPO = '1'
				AND ZA7_DATA <> '        '
				AND SUBSTR(ZA7_FILIAL,1,2) = %Exp:Subs(cFilAnt,1,2)%
			INNER JOIN %table:SD2% SD2 ON SD2.%notDel%
				AND D2_FILIAL = E1_FILIAL
				AND D2_PEDIDO = E1_PEDIDO
				AND D2_SERIE = E1_PREFIXO
				AND D2_DOC = E1_NUM
				AND D2_CLIENTE = E1_CLIENTE
				AND D2_LOJA = E1_LOJA
				AND D2_TIPO = 'N'
				AND D2_QTDEDEV > 0
			WHERE SE1.%notDel%
				AND SUBSTR(E1_FILIAL,1,2) = %Exp:Subs(cFilAnt,1,2)%
				AND E1_SITUACA = '1'
				AND E1_PORTADO = %Exp:cBcoFIDC%
				AND E1_AGEDEP || E1_CONTA = %Exp:cAgeFIDC+cCtaFIDC%
				AND E1_IDCNAB <> ''
			GROUP BY E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_VENCREA, E1_PORTADO, E1_AGEDEP, E1_CONTA, E1_NUMBOR, E1_DATABOR, ZA8_CODREM
			ORDER BY 1, 2, 3, 4, 5
			
		EndSQL

		aQuery := GetLastQuery()
		
		While !(cAlias)->(EOF())
			
			aAux := {}
			
			cMotRec := cMotDev
			
			aAdd( aAux , {	( cAlias )->E1_PREFIXO			,;
							( cAlias )->E1_NUM				,;
							( cAlias )->E1_PARCELA			,;
							( cAlias )->E1_TIPO				,;
							STOD( ( cAlias )->E1_VENCREA )	,;
							( cAlias )->E1_VALOR			,;
							( cAlias )->E1_PORTADO			,;
							( cAlias )->E1_AGEDEP			,;
							( cAlias )->E1_CONTA			,;
							( cAlias )->ZA8_CODREM			,;
							STOD( ( cAlias )->E1_DATABOR )	,;
							cMotRec							,;
							( cAlias )->E1_FILIAL			} )
			
			aAdd( aDados , aAux )
			
			(cAlias)->( dbSkip() )
		EndDo
		
		dbSelectArea(cAlias)
		dbCloseArea()

	EndIf
	
	
	If Empty(aDados)
		If cTipo == "1"
			Aviso("FIDC - Remessa","NЦo existem registros para os parБmetros informados!",{'Ok'})
		Elseif cTipo == "2"
			Aviso("FIDC - Recompra","NЦo existem registros para seleГЦo automАtica!",{'Ok'})
		ElseIf cTipo == "3"
			Aviso("FIDC - Baixas","NЦo existem registros para seleГЦo automАtica!",{'Ok'})
		EndIf
	EndIf
	
Return


Static Function fInitGridF(oModel,aParam)
	
	Local lRet := .T.
	Local oModelGrid := oModel:GetModel('ZA8GRID')
	
	Local nLinha	:= 1
	
	Local aPergs	:= {}
	Local dEmiIni	:= dDataBase
	Local dEmiFim	:= dDataBase
	Local dVctIni	:= dDataBase
	Local dVctFim	:= dDataBase
	Local dCliIni	:= Space(TamSX3("A1_COD")[1])
	Local dCliFim	:= Replicate("Z",TamSX3("A1_COD")[1])
	Local aRet		:= {}
	
	Local cAlias	:= GetNextAlias()
	
	/*
	1 - MsGet
	[2] : DescriГЦo
	[3] : String contendo o inicializador do campo
	[4] : String contendo a Picture do campo
	[5] : String contendo a validaГЦo
	[6] : Consulta F3
	[7] : String contendo a validaГЦo When
	[8] : Tamanho do MsGet
	[9] : Flag .T./.F. ParБmetro ObrigatСrio ?
	*/

	aAdd( aPergs ,{1,"EmissЦo De     : ",dEmiIni,"@!",'.T.'	,		,'.T.',50,.T.})
	aAdd( aPergs ,{1,"EmissЦo AtИ    : ",dEmiFim,"@!",'.T.'	,		,'.T.',50,.T.})
	aAdd( aPergs ,{1,"Vencimento De  : ",dVctIni,"@!",'.T.'	,		,'.T.',50,.T.})
	aAdd( aPergs ,{1,"Vencimento AtИ : ",dVctFim,"@!",'.T.'	,		,'.T.',50,.T.})
	aAdd( aPergs ,{1,"Cliente De     : ",dCliIni,"@!",'.T.'	,"SA1"	,'.T.',40,.F.})
	aAdd( aPergs ,{1,"Cliente AtИ    : ",dCliFim,"@!",'.T.'	,"SA1"	,'.T.',40,.T.})
	
	If !ParamBox(aPergs ,"Parametros FIDC - Remessa",aRet)
		Aviso("FIDC - Remessa","Processamento Cancelado!",{'Ok'})
		lRet := .F.
		Return lRet
	EndIf
	
	BeginSQL Alias cAlias
		
		SELECT SE1.R_E_C_N_O_ E1_RECNO, SE1.*
		FROM %table:SE1% SE1
		LEFT JOIN %table:ZA8% ZA8 ON ZA8.%notDel%
			AND ZA8_FILORI = E1_FILIAL
			AND ZA8_PREFIX = E1_PREFIXO
			AND ZA8_NUM = E1_NUM
			AND ZA8_PARCEL = E1_PARCELA
			AND ZA8_TIPO = E1_TIPO
			AND ZA8_STATUS IN ('1','2')
			AND SUBSTR(ZA8_FILIAL,1,2) = %Exp:Subs(cFilAnt,1,2)%
		LEFT JOIN %table:ZA7% ZA7 ON ZA7.%notDel%
			AND ZA7_FILIAL = ZA8_FILIAL
			AND ZA7_CODREM = ZA8_CODREM
			AND ZA7_STATUS IN ('1','2')
			AND ZA7_TIPO = '1'
			AND SUBSTR(ZA7_FILIAL,1,2) = %Exp:Subs(cFilAnt,1,2)%
		WHERE SE1.D_E_L_E_T_ = ' '
			AND SUBSTR(E1_FILIAL,1,2) = %Exp:Subs(cFilAnt,1,2)%
			AND E1_EMISSAO BETWEEN %Exp:DTOS(aRet[1])% AND %Exp:DTOS(aRet[2])%
			AND E1_VENCREA BETWEEN %Exp:DTOS(Max(aRet[3],Date()+1))% AND %Exp:DTOS(aRet[4])%
			AND E1_CLIENTE BETWEEN %Exp:aRet[5]% AND %Exp:aRet[6]%
			AND E1_SITUACA = '1'
			AND E1_PORTADO = %Exp:cBcoFIDC%
			AND E1_AGEDEP+E1_CONTA <> %Exp:cAgeFIDC+cCtaFIDC%
			AND E1_BAIXA = ''
			AND E1_IDCNAB <> ''
			AND E1_SDACRES = 0.00
			AND E1_SDDECRE = 0.00
			AND ZA8_NUM IS NULL
		ORDER BY E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO
		
	EndSQL
	
	aQuery := GetLastQuery()
	
	While !(cAlias)->(EOF())
		
		If nLinha # 1
			oModelGrid:AddLine()
		EndIf
		
		oModelGrid:GoLine( nLinha )
		oModelGrid:SetValue("ZA8_STATUS"	, "1"						)
		oModelGrid:SetValue("ZA8_PREFIX"	, ( cAlias )->E1_PREFIXO	)
		oModelGrid:SetValue("ZA8_NUM"		, ( cAlias )->E1_NUM		)
		oModelGrid:SetValue("ZA8_PARCEL"	, ( cAlias )->E1_PARCELA	)
		oModelGrid:SetValue("ZA8_TIPO"		, ( cAlias )->E1_TIPO		)
		oModelGrid:SetValue("ZA8_VENCRE"	, STOD( ( cAlias )->E1_VENCREA )		)
		oModelGrid:SetValue("ZA8_VALOR"		, ( cAlias )->E1_VALOR		)
		oModelGrid:SetValue("ZA8_BANCO"		, ( cAlias )->E1_PORTADO	)
		oModelGrid:SetValue("ZA8_AGENCI"	, ( cAlias )->E1_AGEDEP		)
		oModelGrid:SetValue("ZA8_CONTA"		, ( cAlias )->E1_CONTA		)
		oModelGrid:SetValue("ZA8_NUMBOR"	, ( cAlias )->E1_NUMBOR		)
		oModelGrid:SetValue("ZA8_DATBOR"	, ( cAlias )->E1_DATABOR	)
		oModelGrid:SetValue("ZA8_FILORI"	, ( cAlias )->E1_FILIAL		)
		nLinha ++
		
		(cAlias)->( dbSkip() )
	EndDO
	
	dbSelectArea(cAlias)
	dbCloseArea()
	
Return lRet


Static Function fbPreGrid(oModelGrid,nLinha,cAcao,cCampo,xValor,xValAt)
	
	Local lRet := .T.
	
	If oModelGrid:GetOperation() == MODEL_OPERATION_UPDATE .Or. oModelGrid:GetOperation() == MODEL_OPERATION_INSERT
		If cAcao == "ADDLINE"
			lRet := .F.
		EndIf
	EndIf
	
Return lRet

Static Function fbPreLineGrid(oModelGrid,nLinha,cAcao,cCampo,xValor)
	
	Local lRet := .T.

	If oModelGrid:GetOperation() == MODEL_OPERATION_UPDATE
		If cAcao == "DELETE"
			Help( ,,"AtenГЦo", ,"NЦo И permitido exclusЦo de linhas!",1,0)
			lRet := .F.
		EndIf
	EndIf
	
Return( lRet )

Static Function fbLineOk(oModelGrid,nLinha)
	
	Local lRet := .T.
	
Return lRet

Static Function fTudoOk()
	Local lRet := .T.
	Local oModel := FwModelActive()
	Local oModelZA7 := oModel:GetModel("ZA7MASTER")
	
	oModelZA7:SetValue( "ZA7_EMISSA"	, Date()	)
	
Return lRet

Static Function SeleFil(lTodasFil,lSohFilEmp,cAlias,lSohFilUn,lHlp)                                  

Local cEmpresa 	:= cEmpAnt
Local cTitulo	:= ""
Local MvPar		:= ""
Local MvParDef	:= ""
Local nI 		:= 0
Local aArea 	:= GetArea() 					 // Salva Alias Anterior 
Local nReg	    := 0
Local nSit		:= 0
Local aSit		:= {}
Local aSit_Ant	:= {}
Local aFil 		:= {}	
Local nTamFil	:= Len(xFilial("CT2"))
Local lDefTop 	:= IIF( FindFunction("IfDefTopCTB"), IfDefTopCTB(), .F.) // verificar se pode executar query (TOPCONN)
Local nInc		:= 0    
Local aSM0		:= AdmAbreSM0()
Local aFilAtu	:= {}
Local lPEGetFil := ExistBlock("CTGETFIL")
Local lPESetFil := ExistBlock("CTSETFIL")
Local aFil_Ant
Local lFWCodFil := FindFunction( "FWCodFil" )
Local lGestao	:= AdmGetGest()
Local lFWCompany := FindFunction( "FWCompany" )
Local cEmpFil 	:= " "
Local cUnFil	:= " "
Local nTamEmp	:= 0
Local nTamUn	:= 0
Local lOk		:= .T.

Default lTodasFil 	:= .F.
Default lSohFilEmp 	:= .F.	//Somente filiais da empresa corrente (Gestao Corporativa)
Default lSohFilUn 	:= .F.	//Somente filiais da unidade de negocio corrente (Gestao Corporativa)
Default lHlp		:= .T.
Default cAlias		:= ""

/*
Defines do SM0
SM0_GRPEMP  // CСdigo do grupo de empresas
SM0_CODFIL  // CСdigo da filial contendo todos os nМveis (Emp/UN/Fil)
SM0_EMPRESA // CСdigo da empresa
SM0_UNIDNEG // CСdigo da unidade de negСcio
SM0_FILIAL  // CСdigo da filial
SM0_NOME    // Nome da filial
SM0_NOMRED  // Nome reduzido da filial
SM0_SIZEFIL // Tamanho do campo filial
SM0_LEIAUTE // Leiaute do grupo de empresas
SM0_EMPOK   // Empresa autorizada
SM0_GRPEMP  // CСdigo do grupo de empresas 
SM0_USEROK  // UsuАrio tem permissЦo para usar a empresa/filial
SM0_RECNO   // Recno da filial no SIGAMAT
SM0_LEIAEMP // Leiaute da empresa (EE)
SM0_LEIAUN  // Leiaute da unidade de negСcio (UU)
SM0_LEIAFIL // Leiaute da filial (FFFF)
SM0_STATUS  // Status da filial (0=Liberada para manutenГЦo,1=Bloqueada para manutenГЦo)
SM0_NOMECOM // Nome Comercial
SM0_CGC     // CGC
SM0_DESCEMP // Descricao da Empresa
SM0_DESCUN  // Descricao da Unidade
SM0_DESCGRP // Descricao do Grupo
*/

//Caso o Alias nЦo seja passado, traz as filiais que o usuario tem acesso (modo padrao)
lSohFilEmp := IF(Empty(cAlias),.F.,lSohFilEmp)
lSohFilUN  := IF(Empty(cAlias),.F.,lSohFilUn) .And. lSohFilEmp

//Caso use gestЦo corporativa , busca o codigo da empresa dentro do M0_CODFIL
//Em caso contrario, , traz as filiais que o usuario tem acesso (modo padrao)
cEmpFil := IIF(lGestao .and. lFwCompany, FWCompany(cAlias)," ")
cUnFil  := IIF(lGestao .and. lFwCompany, FWUnitBusiness(cAlias)," ")

//Tamanho do codigo da filial
nTamEmp := Len(cEmpFil)
nTamUn  := Len(cUnFil) 

If lDefTop
	If !IsBlind()
		PswOrder(1)
		If PswSeek( __cUserID, .T. )

			aSit		:= {}
			aFilNome	:= {}
			aFilAtu		:= FWArrFilAtu( cEmpresa, cFilAnt )
			If Len( aFilAtu ) > 0
				cTxtAux := IIF(lGestao,"Empresa/Unidade/Filial de ","Filiais de ")
				cTitulo := cTxtAux + AllTrim( aFilAtu[6] )
			EndIf

			// Adiciona as filiais que o usuario tem permissЦo
			For nInc := 1 To Len( aSM0 )
				//DEFINES da SMO encontra-se no arquivo FWCommand.CH
				//Na funГЦo FWLoadSM0(), ela retorna na posicao [SM0_USEROK] se esta filial И vАlida para o user  
				If (aSM0[nInc][SM0_GRPEMP] == cEmpAnt .And. ((ValType(aSM0[nInc][SM0_EMPOK]) == "L" .And. aSM0[nInc][SM0_EMPOK]) .Or. ValType(aSM0[nInc][SM0_EMPOK]) <> "L") .And. aSM0[nInc][SM0_USEROK] )
					
					//Verificacao se as filiais a serem apresentadas serao 
					//Apenas as filiais da empresa conrrente (M0_CODFIL)
					If lGestao .and. lFwCompany .and. lSohFilEmp
						//Se for exclusivo para empresa
						If !Empty(cEmpFil)
							lOk := IIf(cEmpFil == Substr(aSM0[nInc][2],1,nTamEmp),.T.,.F.)
							/*
							Verifica se as filiais devem pertencer a mesma unidade de negocio da filial corrente*/
							If lOk .And. lSohFilUn
								//Se for exclusivo para unidade de negocio
								If !Empty(cUnFil)
									lOk := IIf(cUnFil == Substr(aSM0[nInc][2],nTamEmp + 1,nTamUn),.T.,.F.)
								Endif
							Endif
						Else
							//Se for tudo compartilhado, traz apenas a filial corrente	
							lOk := IIf(cFilAnt == aSM0[nInc][SM0_CODFIL],.T.,.F.)
						Endif
					Endif

					If lOk
						AAdd(aSit, {aSM0[nInc][SM0_CODFIL],aSM0[nInc][SM0_NOMRED],Transform(aSM0[nInc][SM0_CGC],PesqPict("SA1","A1_CGC"))})
						MvParDef += aSM0[nInc][SM0_CODFIL]
						nI++
					Endif
					
					//ponto de entrada para usuario poder manipular as filiais selecionada 
					//por exemplo para um usuario especifico poderia adicionar uma filial que normalmente nao tem acesso
					If lPESetFil
						aSit_Ant := aClone(aSit)
						aSit := ExecBlock("CTSETFIL",.F.,.F.,{aSit,nI})
								
						If aSit == NIL .Or. Empty(aSit) .Or. !Valtype( "aSit" ) <> "A"
		                	aSit := aClone(aSit_Ant)
						EndIf
                		nI := Len(aSit)
					EndIf
					
				Endif
				
			Next
			If Len( aSit ) <= 0
				// Se nЦo tem permissЦo ou ocorreu erro nos dados do usuario, pego a filial corrente.
				Aadd(aSit, aFilAtu[2]+" - "+aFilAtu[7] )
				MvParDef := aFilAtu[2]
				nI++
			EndIf
		EndIf
		
		aFil := {}
		If ExistBlock("ADMSELFIL")	// PE para substituir a AdmOpcoes
			aFil := ExecBlock("ADMSELFIL",.F.,.F.,{cTitulo,aSit,MvParDef,nTamFil})
		ElseIf zAdmOpcoes(@MvPar,cTitulo,aSit,MvParDef,,,.F.,nTamFil,nI,.T.,,,,,,,,.T.)  // Chama funcao Adm_Opcoes
			nSit := 1 
			For nReg := 1 To len(mvpar) Step nTamFil  // Acumula as filiais num vetor 
				If SubSTR(mvpar, nReg, nTamFil) <> Replicate("*",nTamFil)
			 		AADD(aFil, SubSTR(mvpar, nReg, nTamFil) ) 
				endif	
				nSit++
			next
			If Empty(aFil) .And. lHlp 
	 	  		Help(" ",1,"ADMFILIAL",,"Por favor selecionar pelo menos uma filial",1,0)
			EndIF
			
			If Len(aFil) == Len(aSit)
				lTodasFil := .T.	
			EndIf 
		Endif
	Else
		aFil := {cFilAnt}
	EndIf	

	//ponto de entrada para usuario poder manipular as filiais selecionada 
	//por exemplo para um usuario especifico poderia adicionar uma filial que normalmente nao tem acesso
	If lPEGetFil
		aFil_Ant := aClone(aFil)
		aFil := ExecBlock("CTGETFIL",.F.,.F.,{aFil})
		If aFil == NIL .Or. Empty(aFil)
			aFil := aClone(aFil_Ant)
		EndIf
	EndIf
		
Else
	Help("  ",1,"ADMFILTOP",,"FunГЦo disponМvel apenas para ambientes TopConnect",1,0)
EndIf
	
RestArea(aArea)  

Return(aFil)

Static Function zAdmOpcoes(	uVarRet			,;	//01-Variavel de Retorno
						cTitulo			,;	//2-Titulo da Coluna com as opcoes
						aOpcoes			,;	//3-Opcoes de Escolha (Array de Opcoes)
						cOpcoes			,;	//4-String de Opcoes para Retorno
						nLin1			,;	//5-Nao Utilizado
						nCol1			,;	//6-Nao Utilizado
						l1Elem			,;	//7-Se a Selecao sera de apenas 1 Elemento por vez
						nTam			,;	//8-Tamanho da Chave
						nElemRet		,;	//9-No maximo de elementos na variavel de retorno
						lMultSelect		,;	//10-Inclui Botoes para Selecao de Multiplos Itens
						lComboBox		,;	//11-Se as opcoes serao montadas a partir de ComboBox de Campo ( X3_CBOX )
						cCampo			,;	//12-Qual o Campo para a Montagem do aOpcoes
						lNotOrdena		,;	//13-Nao Permite a Ordenacao
						lNotPesq		,;	//14-Nao Permite a Pesquisa	
						lForceRetArr    ,;	//15-Forca o Retorno Como Array
						cF3				,;	//16-Consulta F3	
						lVisual			,;  //17-Apenas visualizacao
						lColunada		 ;  //18-Apresenta dados em colunas (Apenas AdmGetFil)
				  )
                    	
Local aListBox			:= {}
Local aSvKeys			:= GetKeys()
Local aAdvSize			:= {}
Local aInfoAdvSize		:= {}
Local aObjCoords		:= {}
Local aObjSize			:= {}
Local aLbxCoords		:= {}
Local aBtnCoords		:= {}
Local aGrpCoords		:= {}
Local aButtons			:= {}
Local aX3Box			:= {}

Local bSvF3				:= SetKey( VK_F3  , NIL )
Local bSetF3			:= { || NIL }
Local bSet15			:= { || NIL }
Local bSet24			:= { || NIL }
Local bSetF4			:= { || NIL }
Local bSetF5			:= { || NIL }
Local bSetF6			:= { || NIL }
Local bCapTrc			:= { || NIL }
Local bDlgInit			:= { || NIL }
Local bOrdena			:= { || NIL }
Local bPesquisa			:= { || NIL }

Local cCodOpc			:= ""
Local cDesOpc			:= ""
Local cCodDes			:= ""
Local cPict				:= "@E 999999"
Local cVarQ				:= ""
Local cReplicate		:= ""
Local cTypeRet			:= ""

Local lExistCod			:= .F.
Local lSepInCod			:= .F.

Local nOpcA				:= 0
Local nFor				:= 0
Local nAuxFor			:= 1
Local nOpcoes			:= 0
Local nListBox			:= 0
Local nElemSel			:= 0
Local nInitDesc			:= 1
Local nTamPlus1			:= 0
Local nSize				:= 0

Local oDlg				:= NIL
Local oListbox			:= NIL
Local oElemSel      	:= NIL
Local oElemRet			:= NIL
Local oOpcoes			:= NIL
Local oFontNum			:= NIL
Local oFontTit			:= NIL
Local oBtnMarcTod		:= NIL
Local oBtnDesmTod		:= NIL
Local oBtnInverte		:= NIL
Local oGrpOpc			:= NIL
Local oGrpRet			:= NIL
Local oGrpSel			:= NIL

Local uRet				:= NIL
Local uRetF3			:= NIL  

DEFAULT uVarRet			:= &( ReadVar() )
DEFAULT cTitulo			:= OemToAnsi( "Escolha PadrУes" )
DEFAULT aOpcoes			:= {}
DEFAULT cOpcoes			:= ""
DEFAULT l1Elem			:= .F.
DEFAULT lMultSelect 	:= .T.
DEFAULT lComboBox		:= .F.
DEFAULT cCampo			:= ""
DEFAULT lNotOrdena		:= .F.
DEFAULT lNotPesq		:= .F.
DEFAULT lForceRetArr	:= .F.
DEFAULT lVisual			:= .F.
DEFAULT lColunada		:= .F.

Begin Sequence

	uRet				:= uVarRet
	cTypeVarRet			:= ValType( uVarRet )
	cTypeRet			:= IF( lForceRetArr , "A" , ValType( uRet ) )
	lMultSelect 		:= !( l1Elem )
	nSize				:= If(lColunada,20,0)	
		
	/*
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Coloca o Ponteiro do Cursor em Estado de Espera			   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	*/

	IF !( lComboBox )
		DEFAULT nTam	:= 1
		nTamPlus1		:= ( nTam + 1 )
		IF ( ( nOpcoes := Len( aOpcoes ) ) > 0 )
			For nFor := 1 To nOpcoes
				If !lColunada
				    IF !Empty( cOpcoes )
					    cCodOpc		:= SubStr( cOpcoes , nAuxFor , nTam )
				    	lExistCod	:= .F.
				    	nInitDesc	:= 1
				    	IF !( " <-> "		== SubStr( aOpcoes[ nFor ] , nTamPlus1 , 5 ) ) .and. ;
				    	   !( " <=> "		== SubStr( aOpcoes[ nFor ] , nTamPlus1 , 5 ) ) .and. ;
	  	   			       !( " <-> "		== SubStr( aOpcoes[ nFor ] , nTam      , 5 ) ) .and. ;
				    	   !( " <=> "		== SubStr( aOpcoes[ nFor ] , nTam      , 5 ) ) 
				    		IF !( "<->"		== SubStr( aOpcoes[ nFor ] , nTamPlus1 , 3 ) ) .and. ;
				    		   !( "<=>"		== SubStr( aOpcoes[ nFor ] , nTamPlus1 , 3 ) ) .and. ;
				    		   !( " - "		== SubStr( aOpcoes[ nFor ] , nTamPlus1 , 3 ) ) .and. ;
				    		   !( " = "		== SubStr( aOpcoes[ nFor ] , nTamPlus1 , 3 ) ) .and. ;
				    		   !( "<->"		== SubStr( aOpcoes[ nFor ] , nTam      , 3 ) ) .and. ;
				    		   !( "<=>"		== SubStr( aOpcoes[ nFor ] , nTam	   , 3 ) ) .and. ;
				    		   !( " - "		== SubStr( aOpcoes[ nFor ] , nTam	   , 3 ) ) .and. ;
				    		   !( " = "		== SubStr( aOpcoes[ nFor ] , nTam	   , 3 ) )
				    			IF !( "-"	== SubStr( aOpcoes[ nFor ] , nTamPlus1 , 1 ) ) .and. ;
				    			   !( "="	== SubStr( aOpcoes[ nFor ] , nTamPlus1 , 1 ) ) .and. ;
				    			   !( "-"	== SubStr( aOpcoes[ nFor ] , nTam	   , 1 ) ) .and. ;
				    			   !( "="	== SubStr( aOpcoes[ nFor ] , nTam      , 1 ) )
				    				nInitDesc	:= 1
				    				lExistCod	:= .F.
				    			Else
			    					nInitDesc	:= nTamPlus1 /* 1 */
				    				lExistCod	:= .T.
				    			EndIF
				    		Else
				    			IF (;
				    					lSepInCod := (;
														( "<->" $ cCodOpc ) .or. ;
				    									( "<=>" $ cCodOpc ) .or. ;
				    									( " - " $ cCodOpc ) .or. ;
				    									( " = " $ cCodOpc )		 ;
				    							   	  );
									)			    							   	  		
				    				nInitDesc	:= nTamPlus1
				    			Else
				    				nInitDesc	:= ( nTamPlus1 + 2 ) /* 123 */
				    			EndIF	
				    			lExistCod	:= .T.
				    		EndIF	
				    	Else
			    			IF (;
			    					lSepInCod := (;
			    									( " <-> " $ cCodOpc ) .or. ;
			    									( " <=> " $ cCodOpc )	   ;
			    							   );
								)		    							   
			    				nInitDesc	:= nTamPlus1
			    			Else
				    			nInitDesc	:= ( nTamPlus1 + 4 ) /* 12345 */
				    		EndIF	
				    		lExistCod	:= .T.
				    	EndIF
					    cDesOpc		:= SubStr( aOpcoes[ nFor ] , nInitDesc )
					    cCodDes		:= IF( lExistCod , aOpcoes[ nFor ] , cCodOpc + " - " + cDesOpc )
					    aAdd( aListBox , { .T. , cCodDes , cCodOpc , cDesOpc } )
						nAuxFor := ( ( nFor * nTam ) + 1 )
					Else
						aAdd( aListBox , { .T. , aOpcoes[ nFor ] , aOpcoes[ nFor ] , aOpcoes[ nFor ] } )
					EndIF	
					IF (;
					   		( cTypeVarRet == "C" );
					   		.and.;
					   		( aListBox[ nFor , 03 ] $ uVarRet );
					   	)	
						aListBox[ nFor , 01 ] := .T.
					EndIF
        		Else
				    aAdd( aListBox , { .T. , aOpcoes[ nFor,1 ] , aOpcoes[ nFor,2 ], aOpcoes[ nFor,3 ] } )
				Endif

			Next nFor
		Else
			/*
			здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			Ё Restaura o Ponteiro do Cursor                  			   Ё
			юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			*/
			MsgInfo( OemToAnsi( "NЦo existem dados para consulta" ) , IF( Empty( cTitulo ) , OemToAnsi( "Escolha PadrЖes" ) , cTitulo ) )
			Break
		EndIF	
	Else
		DEFAULT nTam	:= ( TamSx3( cCampo )[1] )
		aListBox := MontaCombo( cCampo , @cTitulo )
		IF ( ( nOpcoes := Len( aListBox ) ) > 0 )
			For nFor := 1 To nOpcoes
		    	IF (;
		    			( cTypeVarRet == "C" );
		    			.and.;
		    			( aListBox[ nFor , 03 ] $ uVarRet );
		    		)	
	    	    	aListBox[ nFor , 01 ] := .T.
	    		EndIF
			Next nFor
		Else
			/*
			здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			Ё Restaura o Ponteiro do Cursor                  			   Ё
			юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			*/
			MsgInfo( OemToAnsi( "NЦo existem dados para consulta" ) , IF( Empty( cTitulo ) , OemToAnsi( "Escolha PadrЖes" ) , cTitulo ) )
		EndIF
	EndIF

	/*
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Define o DEFAULT do Maximo de Elementos que Podem ser RetornaЁ
	Ё dos														   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	*/
	DEFAULT nElemRet := ( Len( &( ReadVar() ) ) / nTam )

	/*
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Define os numeros de Elementos que serao Mostrados		   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	*/
	nOpcoes		:= Len( aListbox )
	nElemRet    := Min( nElemRet , nOpcoes )
	nElemRet	:= IF( !( lMultSelect ) , 01 , nElemRet )
	/*
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Verifica os Elementos ja Selecionados          			   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	*/
	aEval( aListBox , { |x| IF( x[1] , ++nElemSel , NIL ) } )

	/*
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Define Bloco e Botao para a Ordenacao das Opcoes       	   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	*/
	IF !( lNotOrdena )
		bOrdena := { || AdmOpcOrd(;
									oListBox	,;
									"Ordenar <F7>..."		 ;
								 ),;
					 	SetKey( VK_F7 , bOrdena );
					}
		aAdd(; 
				aButtons	,;
								{;
									"SDUORDER"				,;
		   							bOrdena 				,;
		       	   					OemToAnsi( "Ordenar <F7>..." )	,;
		       	   					OemtoAnsi( "OrdenaГЦo" )	 ;
		           				};
		     )					 	
	EndIF
		
	/*
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Define Bloco e  Botao para a Pesquisa                   	   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	*/
	IF !( lNotPesq )
		bPesquisa := { || AdmOpcPsq(;
									oListBox	,;
									"Pesquisar <F8>..."		,;
									lNotOrdena  ,;
									cF3			,;
									aX3Box		 ;
								 ),;
					 	SetKey( VK_F8 , bPesquisa );
					}
		aAdd(; 
				aButtons	,;
								{;
									"PESQUISA"				,;
		   							bPesquisa				,;
		       	   					OemToAnsi( "Pesquisar <F8>..." )	,;
		       	   					OemToAnsi( "Pesquisar" )	 ;
		           				};
		     )					 	
	EndIF	
	
	/*
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Define o Bloco para a CaPexTroca()						   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	*/
	bCapTrc := { |cTipo,lMultSelect| ;
										aListBox := AdmexTroca(;
																oListBox:nAt,;
																@aListBox,;
																l1Elem,;
																nOpcoes,;
																nElemRet,;
																@nElemSel,;
																lMultSelect,;
																cTipo;
															),;
										oListBox:nColPos := 1,;
										oListBox:Refresh(),;
										oElemSel:Refresh();
				}
	
	/*
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Carrega as Dimensoes Disponiveis       					   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	*/
	aAdvSize		:= MsAdvSize( .T. , .T. )
	/*
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Redimensiona                           					   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	*/
	aAdvSize[3] *= ( 73 / 100 )
	aAdvSize[5] *= ( 73 / 100 )
	aAdvSize[6] -= 05.5
	aAdvSize[7] += 05.5
	
	/*
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Monta as Dimensoes dos Objetos         					   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
	aInfoAdvSize	:= { aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 0 , 0 }
	aAdd( aObjCoords , { 070 , 070 , .T. , .T. } )
	aAdd( aObjCoords , { 000 , 000 , .T. , .F. } )
	aObjSize		:= MsObjSize( aInfoAdvSize , aObjCoords )

	If !lVisual
		aLbxCoords	:= { aObjSize[1,1]		, aObjSize[1,2] + 1 , aObjSize[1,4] 	, RetFatListBox(aObjSize[1,4]) }
	Else
		aLbxCoords	:= { aObjSize[1,1]		, aObjSize[1,2] + 1 , aObjSize[1,4] 	, aObjSize[1,3] }
	EndIf

	aBtnCoords	:= { aLbxCoords[4] + 15	, aObjSize[2,2] + 1 , aObjSize[2,3] 	, aObjSize[2,4] / 2  }
	aGrpCoords	:= { aBtnCoords[4] + 05 , aObjSize[2,2] + 2 , aObjSize[2,3]-2	, aObjSize[2,4] }

	/*
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Seta a consulta F3                						   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	*/
	IF !Empty( cCampo )
		IF !Empty( cF3 )
			bSetF3	:= { || AdmPesqF3( cF3 , cCampo , oListBox ) , SetKey( VK_F3 , bSetF3 ) }
		Else
			aX3Box	:= Sx3Box2Arr( cCampo )
		EndIF	
	EndIF	

	/*
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Disponibiliza Dialog para Selecao 						   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	*/
	DEFINE FONT oFontNum NAME "Arial" SIZE 000,-014 BOLD
	DEFINE FONT oFontTit NAME "Arial" SIZE 000,-011 BOLD
	DEFINE MSDIALOG oDlg TITLE cTitulo FROM aAdvSize[7],0 TO aAdvSize[6]+50,aAdvSize[5]+nSize OF GetWndDefault() PIXEL //"Escolha PadrУes"
		
	If lColunada		//Utilizada pela AdmGetFil com Gestao Corporativa
		@ aLbxCoords[1],aLbxCoords[2]	LISTBOX oListBox VAR cVarQ FIELDS HEADER "" , "Filial", "Nome Filial", "CNPJ" SIZE aLbxCoords[3]+(nSize/2),aLbxCoords[4]+(nSize/2);
									ON	DBLCLICK Eval( bCapTrc ) NOSCROLL PIXEL
    Else
		@ aLbxCoords[1],aLbxCoords[2]	LISTBOX oListBox VAR cVarQ FIELDS HEADER "" , OemToAnsi(cTitulo)  SIZE aLbxCoords[3],aLbxCoords[4];
										ON	DBLCLICK Eval( bCapTrc ) NOSCROLL PIXEL
	Endif

	oListBox:SetArray( aListBox )
	oListBox:bLine := { || LineLstBox( oListBox , .T. ) }
	oListBox:bWhen := { || !lVisual }

	IF ( lMultSelect ) .AND. !lVisual
		/*
		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		Ё Define Bloco e o Botao para Marcar Todos    				   Ё
		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		*/
		bSetF4		:= { || Eval( bCapTrc , "M" , lMultSelect ) , SetKey( VK_F4 , bSetF4 ) }
		@ aBtnCoords[1],aBtnCoords[2] 			BUTTON oBtnMarcTod	PROMPT OemToAnsi( "Marca Todos - <F4>" )		SIZE 75,13.50 OF oDlg	PIXEL ACTION Eval( bSetF4 )
	
		/*
		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		Ё Define Bloco e o Botao para Desmarcar Todos    			   Ё
		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		*/
		bSetF5		:= { || Eval( bCapTrc , "D" , lMultSelect ) , SetKey( VK_F5 , bSetF5 ) }
		@ aBtnCoords[1],aBtnCoords[2]+75+3		BUTTON oBtnDesmTod	PROMPT OemToAnsi( "Desmarca Todos - <F5>" )		SIZE 75,13.50 OF oDlg	PIXEL ACTION Eval( bSetF5 )
	
		/*
		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		Ё Define Bloco e o Botao para Inversao da Selecao			   Ё
		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		*/
		bSetF6		:= { || Eval( bCapTrc , "I" , lMultSelect ) , SetKey( VK_F6 , bSetF6 ) }
		@ aBtnCoords[1],aBtnCoords[2]+(75*2)+6	BUTTON oBtnInverte	PROMPT OemToAnsi( "Inverte SeleГЦo - <F6>" ) 	SIZE 75,13.50 OF oDlg	PIXEL ACTION Eval( bSetF6 )
	EndIF

	If !lVisual
		/*
		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		Ё Numero de Elementos para Selecao							   Ё
		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		*/
		@ aGrpCoords[1]+10,aGrpCoords[2] 					GROUP oGrpOpc	TO aGrpCoords[3]+15+5,074.50	OF oDlg LABEL OemtoAnsi("Nro. Elementos")	PIXEL
		oGrpOpc:oFont := oFontTit
		@ aGrpCoords[1]+08+15,aGrpCoords[2]+18				SAY oOpcoes		VAR Transform( nOpcoes	, cPict )	OF oDlg		PIXEL	FONT oFontNum
		
		/*
		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		Ё Maximo de Elementos que poderm Ser Selecionados			   Ё
		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		*/
		@ aGrpCoords[1]+10,(aGrpCoords[2]+75+4)			GROUP oGrpRet	TO aGrpCoords[3]+15+5,152.50	OF oDlg LABEL OemtoAnsi("MАx. Elem. p/ SeleГЦo")   PIXEL
		oGrpRet:oFont := oFontTit
		@ aGrpCoords[1]+08+15,(aGrpCoords[2]+75+4)+18		SAY oElemRet	VAR Transform( nElemRet	, cPict )	OF oDlg		PIXEL	FONT oFontNum
		
		/*
		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		Ё Numero de Elementos Selecionados                		   	   Ё
		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		*/
		@ aGrpCoords[1]+10,(aGrpCoords[2]+(75*2)+7) GROUP oGrpSel	TO aGrpCoords[3]+15+5,230.00	OF oDlg LABEL OemtoAnsi("Elem. Selecionados")	PIXEL
		oGrpSel:oFont := oFontTit
		@ aGrpCoords[1]+08+15,(aGrpCoords[2]+(75*2)+7)+18	SAY oElemSel		VAR Transform( nElemSel	, cPict )	OF oDlg		PIXEL	FONT oFontNum
	EndIf

	/*
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Define Bloco para a Tecla <CTRL-O>              		   	   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	*/
	bSet15 := { || nOpcA := 1 , GetKeys() , SetKey( VK_F3 , NIL ) , oDlg:End() }
	
		/*
		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		Ё Define Bloco para a Tecla <CTRL-X>              		   	   Ё
		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		*/
		bSet24 := { || nOpcA := 0 , GetKeys() , SetKey( VK_F3 , NIL ) , oDlg:End() }
	
		/*
		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		Ё Define Bloco para o Init do Dialog              		   	   Ё
		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		*/
		bDlgInit := { || EnchoiceBar( oDlg , bSet15 , bSet24 , NIL , aButtons ),;
						 IF( lMultSelect ,;
						 		(;
						 		 	SetKey( VK_F3 , bSetF3 ),;
						 		 	SetKey( VK_F4 , bSetF4 ),;
						 		 	SetKey( VK_F5 , bSetF5 ),;
						 		 	SetKey( VK_F6 , bSetF6 );
						 		 ),;
						 		NIL;
						 	),;
						 SetKey( VK_F7 , bOrdena ),;
						 SetKey( VK_F8 , bPesquisa );	
					}
	
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT Eval( bDlgInit )
	
	/*
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Retorna as Opcoes Selecionadas                  		   	   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	*/
	IF ( nOpcA == 1 )
		/*
		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		Ё Coloca o Ponteiro do Cursor em Estado de Espera			   Ё
		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		*/
	    IF ( cTypeRet == "C" )
		    uRet		:= ""
			cReplicate	:= Replicate( "*" , nTam )
		    nListBox := Len( aListBox )
		    For nFor := 1 To nListBox
				IF ( aListBox[ nFor , 01 ] )
					uRet += aListBox[ nFor , IIf(lColunada, 02, 03) ]
		    	ElseIF ( lMultSelect )
		    		uRet += cReplicate
		    	EndIF
		    Next nFor
		ElseIF ( cTypeRet == "A" )
		    uRet	 	:= {}
		    nListBox	:= 0
		    While ( ( nFor := aScan( aListBox , { |x| x[1] } , ++nListBox ) ) > 0 )
		    	nListBox := nFor
				aAdd( uRet , aListBox[ nFor , 03 ] )
		    End While
		EndIF
	EndIF
	
	/*
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Carrega Variavel com retorno por Referencia     		   	   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	*/
	uVarRet := uRet

End Sequence

/*
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё Restaura o Estado das Teclas de Atalho          		   	   Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
*/
RestKeys( aSvKeys , .T. )
SetKey( VK_F3 , bSvF3 )

Return( ( nOpca == 1 ) )

/*
зддддддддддбддддддддддддддддбдддддбдддддддддддддддддддбддддддбдддддддддд©
ЁFunГЦo    ЁCaPexTroca	    ЁAutorЁMarinaldo de Jesus Ё Data Ё11/09/2003Ё
цддддддддддеддддддддддддддддадддддадддддддддддддддддддаддддддадддддддддд╢
ЁDescriГЦo ЁEfetua a Troca da Selecao no ListBox da AdmOpcoes()   		Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<Vide Parametros Formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁAdmOpcoes()                                                 Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
Ё Retorno  ЁArray (Listbox) Com a(s) opcao(oes) Selecionadas			Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ< Vide Parametros Formais 									Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
Static Function AdmexTroca(	nAt			,;	//Indice do ListBox de AdmOpcoes()
							aArray		,;	//Array do ListBox de AdmOpcoes()
							l1Elem		,;	//Se Selecao apenas de 1 elemento
							nOpcoes		,;	//Numero de Elementos disponiveis para Selecao
							nElemRet	,;	//Numero de Elementos que podem ser Retornados
							nElemSel	,;	//Numero de Elementos Selecionados
							lMultSelect	,;	//Se Trata Multipla Selecao
							cTipo		 ;	//Tipo da Multipla Selecao "M"arca Todos; "D"esmarca Todos; "I"nverte Selecao
						   )

Local nOpcao		:= 0

DEFAULT nAt			:= 1
DEFAULT aArray		:= {}
DEFAULT l1Elem		:= .F.
DEFAULT nOpcoes		:= 0
DEFAULT nElemRet	:= 0
DEFAULT nElemSel	:= 0
DEFAULT lMultSelect := .F.
DEFAULT cTipo		:= "I"

/*
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё Coloca o Ponteiro do Cursor em Estado de Espera			   Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
*/
CursorWait()
	IF !Empty( aArray )
		IF !( l1Elem )
			IF !( lMultSelect )
				aArray[nAt,1] := !aArray[nAt,1]
				IF !( aArray[nAt,1] )
					--nElemSel
				Else
					++nElemSel
				EndIF	
			ElseIF ( lMultSelect )
				IF ( cTipo == "M" )
					nElemSel := 0
					aEval( aArray , { |x,y| aArray[y,1] := IF( ( y <= nElemRet ) , ( ++nElemSel , .T. ) , .F. ) } )
				ElseIF ( cTipo == "D" )
					aEval( aArray , { |x,y| aArray[y,1] := .F. , --nElemSel } )
				ElseIF ( cTipo == "I" )
					nElemSel := 0
					aEval( aArray , { |x,y| IF( aArray[y,1] , aArray[y,1] := .F. , IF( ( ( ++nElemSel ) <= nElemRet ) , aArray[y,1] := .T. , NIL ) ) } )
					nElemSel := Min( nElemSel , nElemRet )
				EndIF
			EndIF
		Else
			For nOpcao := 1 To nOpcoes
				IF ( nOpcao == nAt )
					aArray[ nOpcao , 1 ]	:= .T.
				Else
					aArray[ nOpcao , 1 ]	:= .F.
				EndIF
			Next nOpcao
			nElemSel := 01
		EndIF
	EndIF
/*
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё Restaura o Ponteiro do Cursor                  			   Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
*/
CursorArrow()
	
IF ( nElemSel > nElemRet )
	aArray[nAt,1] := .F.
	nElemSel := nElemRet
	MsgInfo(;
				OemToAnsi( "Excedeu o nёmero de elementos permitidos para seleГЦo" ) ,;
				OemToAnsi( "AtenГЦo" )  ;
		    )
ElseIF ( nElemSel < 0 )
	nElemSel := 0
EndIF

Return( aArray )

/*
зддддддддддбддддддддддддддддбдддддбдддддддддддддддддддбддддддбдддддддддд©
ЁFunГЦo    ЁfOpcPesqF3		ЁAutorЁMarinaldo de Jesus Ё Data Ё11/11/2004Ё
цддддддддддеддддддддддддддддадддддадддддддддддддддддддаддддддадддддддддд╢
ЁDescriГЦo ЁEfetua Pesquisa Via Tecla F3                         		Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<Vide Parametros Formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁAdmOpcoes()                                                 Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁRetorno   ЁNIL															Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ< Vide Parametros Formais 									Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
Static Function AdmPesqF3( cF3 , cCampo , oListBox )

Local cAlias
Local lConpad1
Local nAt
Local uRetF3

IF FindFunction( "AliasCpo" )
	cAlias := AliasCpo( cCampo )
	IF (;
			!Empty( cAlias );
			.and.;
			( Select( cAlias ) > 0 );
		)	
		lConpad1 := ConPad1( NIL , NIL , NIL , cF3 , NIL , NIL , .F. )
		IF( lConpad1 )
			uRetF3	:= ( cAlias )->( FieldGet( FieldPos( cCampo ) ) )
			nAt		:= aScan( oListBox:aArray , { |x| x[3] == uRetF3 } )
			IF ( nAt > 0 )
				oListBox:nAt := nAt
				oListBox:Refresh()
			Else
				MsgInfo( OemToAnsi( "cСdigo nЦo encontrado" ) )
			EndIF
		EndIF
	EndIF	
EndIF

Return( NIL )

/*
зддддддддддбддддддддддддддддбдддддбдддддддддддддддддддбддддддбдддддддддд©
ЁFunГЦo    ЁAdmOpcOrd	    ЁAutorЁMarinaldo de Jesus Ё Data Ё11/09/2003Ё
цддддддддддеддддддддддддддддадддддадддддддддддддддддддаддддддадддддддддд╢
ЁDescriГЦo ЁOrdenar as Opcoes em AdmOpcoes                        		Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<Vide Parametros Formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁAdmOpcoes()                                                 Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁRetorno   ЁNIL															Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ< Vide Parametros Formais 									Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
Static Function AdmOpcOrd( oListBox , cTitulo )

Local aSvKeys		:= GetKeys()
Local aAdvSize		:= {}
Local aInfoAdvSize	:= {}
Local aObjCoords	:= {}
Local aObjSize		:= {}

Local bSort			:= { || NIL }

Local lbSet15		:= .F.

Local nOpcRad		:= 1

Local oFont			:= NIL
Local oDlg			:= NIL
Local oGroup		:= NIL
Local oRadio		:= NIL	

/*
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё Monta as Dimensoes dos Objetos         					   Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
*/
aAdvSize		:= MsAdvSize( .T. , .T. )
/*
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё Redimensiona                           					   Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
*/
aAdvSize[3] -= 25
aAdvSize[4] -= 50
aAdvSize[5] -= 50
aAdvSize[6] -= 50
aAdvSize[7] += 50
aInfoAdvSize	:= { aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 0 , 0 }
aAdd( aObjCoords , { 000 , 000 , .T. , .T. } )
aObjSize		:= MsObjSize( aInfoAdvSize , aObjCoords )

/*
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё Define o Bloco para a Teclas <CTRL-O>   ( Button OK da EnchoiЁ
Ё ceBar )													   Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
*/
bSet15 := { ||	(;
					lbSet15 := .T. ,;
					GetKeys(),;
					oDlg:End();
				  );
			}

/*
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё Define o  Bloco  para a Teclas <CTRL-X> ( Button Cancel da EnЁ
Ё choiceBar )												   Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
*/
bSet24 := { || GetKeys() , oDlg:End() }

/*
зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
ЁMonta Dialogo para a selecao do Periodo 					  Ё
юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
*/
DEFINE FONT oFont NAME "Arial" SIZE 0,-11 BOLD
DEFINE MSDIALOG oDlg TITLE OemToAnsi(cTitulo) From aAdvSize[7],0 TO aAdvSize[6],aAdvSize[5] OF GetWndDefault() PIXEL			

	@ aObjSize[1,1] , aObjSize[1,2] GROUP oGroup TO aObjSize[1,3],aObjSize[1,4] LABEL OemToAnsi("OrdenaГЦo") OF oDlg PIXEL
	oGroup:oFont:= oFont

	@ ( aObjSize[1,1] + 010 ) , ( aObjSize[1,2]+005 )	SAY OemToAnsi("Efetuar a OrdenaГЦo por:")	SIZE 300,10 OF oDlg PIXEL FONT oFont
	@ ( aObjSize[1,1] + 010 ) , ( aObjSize[1,2]+100 )	RADIO oRadio VAR nOpcRad	ITEMS 	OemToAnsi("cСdigo"),;
																	 						OemToAnsi("descriГЦo"),;
																	 						OemToAnsi("Мtem selecionado e cСdigo"),;
																	 						OemToAnsi("Мtem selecionado e descriГЦo"),;
																	 						OemToAnsi("Мtem nЦo selecionado e cСdigo"),;
																	 						OemToAnsi("Мtem nЦo selecionado e descriГЦo");
																						SIZE 115,010 OF oDlg PIXEL
	oRadio:oFont := oFont																						

ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar( oDlg , bSet15 , bSet24 )

IF ( lbSet15 )
	Do Case
		Case ( nOpcRad == 1 )
			bSort := { |x,y| x[3] < y[3] }
		Case ( nOpcRad == 2 )
			bSort := { |x,y| x[4] < y[4] }
		Case ( nOpcRad == 3 )
			bSort := { |x,y| ( IF( x[1] , "A" , "Z" ) + x[3] ) < ( IF( y[1] , "A" , "Z" ) + y[3] ) }
		Case ( nOpcRad == 4 )
			bSort := { |x,y| ( IF( x[1] , "A" , "Z" ) + x[4] ) < ( IF( y[1] , "A" , "Z" ) + y[4] ) }
		Case ( nOpcRad == 5 )
			bSort := { |x,y| ( IF( !x[1] , "A" , "Z" ) + x[3] ) < ( IF( !y[1] , "A" , "Z" ) + y[3] ) }
		Case ( nOpcRad == 6 )
			bSort := { |x,y| ( IF( !x[1] , "A" , "Z" ) + x[4] ) < ( IF( !y[1] , "A" , "Z" ) + y[4] ) }
	End Case
	aSort( oListBox:aArray , NIL , NIL , bSort )
	oListBox:nAt := 1
	oListBox:Refresh()
EndIF		

/*
зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё Restaura as Teclas de Atalho                     	  		  Ё
юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
*/
RestKeys( aSvKeys , .T. )

Return( NIL )

/*
зддддддддддбддддддддддддддддбдддддбдддддддддддддддддддбддддддбдддддддддд©
ЁFunГЦo    ЁAdmOpcPsq	    ЁAutorЁMarinaldo de Jesus Ё Data Ё11/09/2003Ё
цддддддддддеддддддддддддддддадддддадддддддддддддддддддаддддддадддддддддд╢
ЁDescriГЦo ЁPesquisar as Opcoes em AdmOpcoes                      		Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<Vide Parametros Formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁAdmOpcoes()                                                 Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁRetorno   ЁNIL															Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ< Vide Parametros Formais 									Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
Static Function AdmOpcPsq( oListBox , cTitulo , lNotOrdena , cF3 , aX3Box )

Local aSvKeys		:= GetKeys()
Local aAdvSize		:= {}
Local aInfoAdvSize	:= {}
Local aObjCoords	:= {}
Local aObjSize		:= {}
Local aCloneArr		:= {}

Local bSort			:= { || NIL }
Local bAscan		:= { || NIL }
Local bSvF3			:= SetKey( VK_F3  , NIL )

Local cCodigo		:= Space( 20 )
Local cDescri		:= Space( 60 )
Local cMsg			:= ""

Local lbSet15		:= .F.

Local nOpcRad		:= 1
Local nAt			:= 0

Local oFont			:= NIL
Local oDlg			:= NIL
Local oGroup		:= NIL
Local oRadio		:= NIL
Local oCodigo		:= NIL

/*
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё Monta as Dimensoes dos Objetos         					   Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
*/
aAdvSize		:= MsAdvSize( .T. , .T. )
/*
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё Redimensiona                           					   Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
*/
aAdvSize[3] -= 25
aAdvSize[4] -= 50
aAdvSize[5] -= 50
aAdvSize[6] -= 50
aAdvSize[7] += 50
aInfoAdvSize	:= { aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 0 , 0 }
aAdd( aObjCoords , { 000 , 000 , .T. , .T. } )
aObjSize		:= MsObjSize( aInfoAdvSize , aObjCoords )

/*
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё Define o Bloco para a Teclas <CTRL-O>   ( Button OK da EnchoiЁ
Ё ceBar )													   Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
*/
bSet15 := { ||	(;
					lbSet15 := .T. ,;
					GetKeys(),;
					oDlg:End();
				  );
			}

/*
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё Define o  Bloco  para a Teclas <CTRL-X> ( Button Cancel da EnЁ
Ё choiceBar )												   Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
*/
bSet24 := { || GetKeys() , oDlg:End() }

/*
зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
ЁMonta Dialogo para a selecao do Periodo 					  Ё
юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
*/
DEFINE FONT oFont NAME "Arial" SIZE 0,-11 BOLD
DEFINE MSDIALOG oDlg TITLE OemToAnsi(cTitulo) From aAdvSize[7],0 TO aAdvSize[6]+20,aAdvSize[5] OF GetWndDefault() PIXEL

	@ aObjSize[1,1],aObjSize[1,2] GROUP oGroup TO aObjSize[1,3]+12,aObjSize[1,4] LABEL OemToAnsi("Pesquisa") OF oDlg PIXEL
	oGroup:oFont:= oFont

	@ ( aObjSize[1,1] + 010 ) , ( aObjSize[1,2]+005 )	SAY OemToAnsi("Efetuar Pesquisa por:")	SIZE 300,10 OF oDlg PIXEL FONT oFont
	@ ( aObjSize[1,1] + 010 ) , ( aObjSize[1,2]+100 )	RADIO oRadio VAR nOpcRad	ITEMS 	OemToAnsi("cСdigo"),;
																	 						OemToAnsi("descriГЦo") ;
																						SIZE 115,010 OF oDlg PIXEL
	oRadio:cToolTip := OemToAnsi( "ApСs selecionar pressione a tecla <TAB> para habilitar a digitaГЦo" )
	oRadio:oFont	:= oFont

	@ ( aObjSize[1,1] + 050 ) , ( aObjSize[1,2]+005 )		SAY OemToAnsi("cСdigo"+":")					SIZE 100,10 OF oDlg PIXEL FONT oFont
	IF Empty( aX3Box )
		@ ( aObjSize[1,1] + 045 ) , ( aObjSize[1,2]+100 )	MSGET oCodigo VAR cCodigo					SIZE 100,10 OF oDlg PIXEL FONT oFont WHEN ( nOpcRad == 1 )	
		IF !Empty( cF3 )
			oCodigo:cF3 := cF3
		EndIF
	Else
		@ ( aObjSize[1,1] + 045 ) , ( aObjSize[1,2]+100 )	COMBOBOX oCodigo VAR cCodigo ITEMS aX3Box	SIZE 100,10 OF oDlg PIXEL FONT oFont WHEN ( nOpcRad == 1 )	
	EndIF

	@ ( aObjSize[1,1] + 070 ) , ( aObjSize[1,2]+005 )	SAY OemToAnsi("descriГЦo"+":")	SIZE 100,10 OF oDlg PIXEL FONT oFont
	@ ( aObjSize[1,1] + 065 ) , ( aObjSize[1,2]+100 )	MSGET oCodigo VAR cDescri	SIZE 190,10 OF oDlg PIXEL FONT oFont WHEN ( nOpcRad == 2 )	

ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar( oDlg , bSet15 , bSet24 )

IF ( lbSet15 )
	Do Case
		Case ( nOpcRad == 1 )
			bSort	:= { |x,y| x[2] < y[2] }
			bAscan	:= { |x| x[2] $ cCodigo }
			cMsg	:= "cСdigo nЦo encontrado"
		Case ( nOpcRad == 2 )
			bSort 	:= { |x,y| x[3] < y[3] }
			bAscan	:= { |x,y| Upper( AllTrim( cDescri ) ) $ SubStr( Upper( AllTrim( x[3] ) ) , 1 , Len( AllTrim( cDescri ) ) ) }
			cMsg	:= "descriГЦo nЦo encontrada"
	End Case
	aCloneArr := aClone( oListBox:aArray )
	IF !( lNotOrdena )
		aSort( oListBox:aArray , NIL , NIL , bSort )
	EndIF	
	IF ( ( ( nAt := aScan( oListBox:aArray , bAscan ) ) ) > 0 )
		oListBox:nAt := nAt
		oListBox:Refresh()
	Else
		MsgInfo( OemToAnsi( cMsg ) , cTitulo )
		oListBox:aArray := aClone( aCloneArr )
		oListBox:Refresh()
	EndIF
EndIF		

/*
зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё Restaura as Teclas de Atalho                     	  		  Ё
юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
*/
RestKeys( aSvKeys , .T. )
SetKey( VK_F3 , bSvF3 )

Return( NIL )


/*
=====================================================================================
Programa.:              BxTitFid
Autor....:              Tarcisio Galeano
Data.....:              08/02/2018
Descricao / Objetivo:   Efetua a baixa do titulo FIDC
Doc. Origem:            CRE19-20-21
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
User Function BxTitFid(_cChvBx)

	Local cFilRec	:= Space(TamSX3("E1_FILIAL")[1])
	Local cNumTit	:= Space(TamSX3("E1_NUM")[1])
	Local cParTit	:= Space(TamSX3("E1_PARCELA")[1])
	
	Local aRet		:= {}
	Local cQuery, nI
	Local aArea
	local lContinua	:= .T.
	Local cAlias	:= GetNextAlias()
	
	Local oModel	:= FwModelActive()
	Local oMdlZA7	:= oModel:GetModel('ZA7MASTER')
	Local oMdlZA8	:= oModel:GetModel('ZA8GRID')
	Local nLinha	:= oMdlZA8:Length()

	_cChvBx :=oMdlZA8:GetValue('ZA8_FILORI')+oMdlZA8:GetValue('ZA8_PREFIX')+oMdlZA8:GetValue('ZA8_NUM')+oMdlZA8:GetValue('ZA8_PARCEL')+oMdlZA8:GetValue('ZA8_TIPO') 
	
	DbSelectArea("SE1")
	DbSetOrder(1)
	If  SE1->(DbSeek(_cChvBx))

		// Retira o situlo da situaГЦo cobranГa
		SE1->(Reclock("SE1",.F.))
		SE1->E1_SITUACA := '0'
		SE1->(MsUnlock())

        _cMotBx := "FIDC"
        cFilAnt := SE1->E1_FILIAL
        
		aBaixa := { ;
		{"E1_FILIAL"   ,SE1->E1_FILIAL,Nil},;
		{"E1_PREFIXO"  ,SE1->E1_PREFIXO,Nil},;
		{"E1_NUM"      ,SE1->E1_NUM            ,Nil},;
		{"E1_TIPO"     ,SE1->E1_TIPO           ,Nil},;
		{"E1_PARCELA"  ,SE1->E1_PARCELA        ,Nil},;
		{"E1_PARCELA"  ,SE1->E1_VALOR          ,Nil},;
		{"AUTMOTBX"    ,_cMotBx		       	   ,Nil},;     // SIN
		{"AUTDTBAIXA"  ,dDataBase              ,Nil},;
		{"AUTDTCREDITO",dDataBase              ,Nil},; //dDatabase
		{"AUTHIST"     ,"Baixa manual FIDC"   ,Nil},;
		{"AUTJUROS"    ,0                      ,Nil,.T.},;
		{"AUTNMULTA"   ,0              		   ,Nil,.T.},;
		{"AUTDESCONT"  ,0		 		 	   ,Nil,.T.},;
		{"AUTVALREC"   ,SE1->E1_VALOR 	  	   ,Nil}}

		if SE1->E1_SALDO = 0 .AND. ! Empty(SE1->E1_BAIXA)
			ShowHelpDlg("NOTIT", {"Titulo "+SE1->E1_PREFIXO+"-"+SE1->E1_NUM+"-"+SE1->E1_PARCELA+ " jА encontra-se baixado",""},3,;
			{"Verificar situaГЦo do tМtulo junto a Аrea Financeira",""},3)
			lRet := .F.
		Else
			lMsErroAuto := .F.
			MSExecAuto({|x,y| Fina070(x,y)},aBaixa,3)

			If lMsErroAuto
				cFileLog := NomeAutoLog()
				cMsgInfo := ""
				If cFileLog <> ""
					cErrolog := MemoRead(cPath+cFileLog)
				Endif
				msgalert(cErrolog)
				lRet := .F.
			Else
				msgalert("Titulo baixado com sucesso !!! ")
			Endif
		Endif
	
		// Volto o titulo da situaГЦo cobranГa
		SE1->(Reclock("SE1",.F.))
		SE1->E1_SITUACA := '1' //_cSituaca
		SE1->(MsUnlock())
	
	Else

		ShowHelpDlg("NOTIT", {"Titulo "+SE1->E1_PREFIXO+"-"+SE1->E1_NUM+"-"+SE1->E1_PARCELA+" nЦo localizado",""},3,;
		{"Verificar situacao do titulo junto a area financeira",""},3)
		lRet := .F.

	Endif

Return(.T.)

/*
=====================================================================================
Programa.:              MGVldBco
Autor....:              Gilson Nascimento 
Data.....:              28/08/2018
Descricao / Objetivo:   SeleГЦo de parametros (43A ou 44A) para FIDC
Doc. Origem:            Contrato - GAP CRE019/20/21
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Permitir o usr selecionar o BANCO para definiГЦo de ParБmetros
======================================================================================
*/
User Function MGFVldBco()
Local aPergs 	:= {}
Local aRet 		:= {}
Local nRetBco	:= 1
Local cDesc1	:= GETMV("MGF_FIN43A")				// "341-ItaЗ"
Local cDesc2	:= GETMV("MGF_FIN44A") 				// "237-Bradesco"

aAdd( aPergs ,{3,"Defina o ParБmetro PadrЦo:",1, {Alltrim(cDesc1), Alltrim(cDesc2)}, 80,'.T.',.T.})   

If upper(GetMv("MGF_TLFIDC",,"S")) == "S"
	If ParamBox(aPergs ,"FIDC-Banco",aRet) 
		nRetBco := aRet[1]   
	EndIf
Endif

Return nRetBco