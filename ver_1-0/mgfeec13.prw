#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE "TBICONN.CH"  

/*
===========================================================================================
Programa.:              MGFEEC13
Autor....:              Leonardo Kume
Data.....:              Dez/2016
Descricao / Objetivo:   Fonte MVC para exibicao de Orcamento e aprovacao
Doc. Origem:            EEC09
Solicitante:            Cliente
Uso......:              
Obs......:               
===========================================================================================
*/
User Function MGFEEC13()
	Private oBrowse3
	Private cLinha := ""

	oBrowse3 := FWMBrowse():New()
	oBrowse3:SetAlias('ZZC')
	oBrowse3:SetDescription('Distribuicao Exportacao Marfrig')
	oBrowse3:AddLegend("ZZC_APROVA = '2' ","YELLOW" ,'Pendente Aprovacao')
	oBrowse3:AddLegend("ZZC_APROVA = '1' ","GREEN" ,'Aprovado')
	oBrowse3:AddLegend("ZZC_APROVA = '3' ","RED" ,'Reprovado')
	oBrowse3:AddLegend("ZZC_APROVA = '4' ","BLUE" ,'Pedido Gerado')
	oBrowse3:AddLegend("ZZC_APROVA = '5' ","GRAY" ,'Pedido Distribuido')
	oBrowse3:SetFilterDefault("ZZC_APROVA $ '1/5'")
	oBrowse3:setMenuDef("MGFEEC13")
	oBrowse3:Activate()

Return NIL

/*/{Protheus.doc} EEC13M
Pontos de entrada MVC
@author leonardo.kume
@since 30/12/2016 
@version 1.0
/*/
User Function EEC13M()
	Local xRet := .T.
	Local cParam := If(Type("ParamIxb") = "A",ParamIxb[2],If(Type("ParamIxb") = "C",ParamIxb,""))
	Local oModel := nil

	/*If cParam == 'FORMLINEPRE'
		
	EndIf*/

Return xRet


Static Function MenuDef()

	Local aRotina := {}

	ADD OPTION aRotina TITLE 'Distribuir'    ACTION 'VIEWDEF.MGFEEC13' 	OPERATION 4 ACCESS 0

Return aRotina


Static Function ModelDef()
	// Cria a estrutura a ser usada no Modelo de Dados
	Local oStruZZC := FWFormStruct( 1, 'ZZC')
	Local oStruZZD := FWFormStruct( 1, 'ZZD')
	Local oStruDis := FWFormStruct( 1, 'ZAN')
	Local oStruPed := FWFormStruct( 1, 'ZAY' ) /*,{ |x| ALLTRIM(x) $ 'ZZD_FILIAL, ZZD_ORCAME, ZZD_FILVEN, ZZD_FILENT, ZZD_SLDINI, ZZD_SEQUEN, ZZD_COD_I ,'+;
	'ZZD_DESC, ZZD_EMBAL1,ZZD_QTDEM1,ZZD_QE,ZZD_PART_N,ZZD_TES,ZZD_CF,ZZD_LOTECT,ZZD_NUMLOT,ZZD_DTVALI' } )*/
	Local oModel

	// Cria o objeto do Modelo de Dados
	oModel := MPFormModel():New('EEC13M',/**/ , /*{|oModel| ValidQuant(oModel)}*/, {|oModel| Gera(oModel)}, /*bCancel*/ )

	// Adiciona ao modelo uma estrutura de formulario de edicao por campo
	oModel:AddFields( 'EEC13MASTER', /*cOwner*/, oStruZZC, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )
	oModel:AddGrid( 'EEC13DETAIL', 'EEC13MASTER', oStruZZD, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )
	oModel:AddGrid( 'EEC13DISTR', 'EEC13DETAIL', oStruDis, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )
	oModel:AddGrid( 'EEC13PED', 'EEC13DETAIL', oStruPed, {|a,b,c,d,e| prevld(a,b,c,d,e)}/*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

	oStruPed:SetProperty('ZAY_SEQUEN',MODEL_FIELD_INIT,{|| oModel:GetModel( 'EEC13DETAIL' ):GetValue('ZZD_SEQUEN') })
	oStruPed:SetProperty('ZAY_COD_I',MODEL_FIELD_INIT,{|| oModel:GetModel( 'EEC13DETAIL' ):GetValue('ZZD_COD_I') })
	oStruPed:SetProperty('ZAY_DESC',MODEL_FIELD_INIT,{|| oModel:GetModel( 'EEC13DETAIL' ):GetValue('ZZD_DESC') })
	oStruPed:SetProperty('ZAY_FILVEN',MODEL_FIELD_INIT,{|| oModel:GetModel( 'EEC13DETAIL' ):GetValue('ZZD_FILVEN') })
	oStruPed:SetProperty('*',MODEL_FIELD_WHEN,{|| Empty(Alltrim(oModel:GetModel("EEC13PED"):GetValue("ZAY_PEDVEN"))) })
	//	oStruPed:SetProperty('ZZD_SLDINI',MODEL_FIELD_VALID,{|| ValidQuant(oModel) })

	oStruDis:SetProperty('ZAN_SEQUEN',MODEL_FIELD_INIT,{|| oModel:GetModel( 'EEC13DETAIL' ):GetValue('ZZD_SEQUEN') })
	oStruDis:SetProperty('ZAN_COD_I',MODEL_FIELD_INIT,{|| oModel:GetModel( 'EEC13DETAIL' ):GetValue('ZZD_COD_I') })
	oStruDis:SetProperty('ZAN_DESC',MODEL_FIELD_INIT,{|| oModel:GetModel( 'EEC13DETAIL' ):GetValue('ZZD_DESC') })
//	oStruDis:SetProperty("*"	,MODEL_FIELD_WHEN,{|| Empty(Alltrim(oModel:GetModel("EEC13DETAIL"):GetValue("ZAN_PEDFAT"))) })

	oStruZZD:SetProperty('*',MODEL_FIELD_WHEN,{||.F.})
	//	oStruZZD:SetProperty("ZZD_EMBAL1"	,MODEL_FIELD_WHEN,{|| oModel:GetModel("EEC13MASTER"):GetValue("ZZC_APROVA") == "1"})
	//	oStruZZD:SetProperty("ZZD_QTDEM1"	,MODEL_FIELD_WHEN,{|| oModel:GetModel("EEC13MASTER"):GetValue("ZZC_APROVA") == "1"})
	//	oStruZZD:SetProperty("ZZD_QE"		,MODEL_FIELD_WHEN,{|| oModel:GetModel("EEC13MASTER"):GetValue("ZZC_APROVA") == "1"})
	//	oStruZZD:SetProperty("ZZD_PART_N"	,MODEL_FIELD_WHEN,{|| oModel:GetModel("EEC13MASTER"):GetValue("ZZC_APROVA") == "1"})
	//	oStruZZD:SetProperty("ZZD_TES"		,MODEL_FIELD_WHEN,{|| oModel:GetModel("EEC13MASTER"):GetValue("ZZC_APROVA") == "1"})
	//	oStruZZD:SetProperty("ZZD_CF"		,MODEL_FIELD_WHEN,{|| oModel:GetModel("EEC13MASTER"):GetValue("ZZC_APROVA") == "1"})
	//	oStruZZD:SetProperty("ZZD_LOTECT"	,MODEL_FIELD_WHEN,{|| oModel:GetModel("EEC13MASTER"):GetValue("ZZC_APROVA") == "1"})
	//	oStruZZD:SetProperty("ZZD_NUMLOT"	,MODEL_FIELD_WHEN,{|| oModel:GetModel("EEC13MASTER"):GetValue("ZZC_APROVA") == "1"})
	//	oStruZZD:SetProperty("ZZD_DTVALI"	,MODEL_FIELD_WHEN,{|| oModel:GetModel("EEC13MASTER"):GetValue("ZZC_APROVA") == "1"})


	// Adiciona a descricao do Modelo de Dados
	oModel:SetDescription( 'Distribuicao Exportacao Marfrig' )

	// Adiciona a descricao do Componente do Modelo de Dados
	oModel:GetModel( 'EEC13MASTER' ):SetDescription( 'Orcamento Exportacao' )
	oModel:GetModel( 'EEC13DETAIL' ):SetDescription( 'Itens' )
	oModel:GetModel( 'EEC13DISTR' ):SetDescription( 'Distribuicao' )
	oModel:GetModel( 'EEC13PED' ):SetDescription( 'Pedido de Exportacao' )

	// Adiciona relacao entre cabecalho e item (relacionamento entre mesma tabela)
	oModel:SetRelation( "EEC13DETAIL", { { "ZZD_FILIAL", "XFILIAL('ZZD')" }, { "ZZD_ORCAME", "ZZC_ORCAME" } }, ZZD->( IndexKey( 1 ) ) )
	oModel:SetRelation( "EEC13DISTR", { { "ZAN_FILIAL", "XFILIAL('ZZD')" }, { "ZAN_ORCAME", "ZZD_ORCAME" }, { "ZAN_SEQUEN", "ZZD_SEQUEN" } }, ZAN->( IndexKey( 1 ) ) )
	oModel:SetRelation( "EEC13PED", { { "ZAY_FILIAL", "XFILIAL('ZZD')" }, { "ZAY_ORCAME", "ZZD_ORCAME" }, { "ZAY_SEQUEN", "ZZD_SEQUEN" } }, ZAY->( IndexKey( 1 ) ) )

	//Adiciona chave Primaria
	oModel:SetPrimaryKey({"ZZC_FILIAL","ZZC_ORCAME"})

	//oModel:GetModel("EEC13MASTER"):SetOnlyView(.T.)
	//oModel:GetModel("EEC13DETAIL"):SetOnlyView(.T.)
	//	oModel:GetModel("EEC13PED"):SetOnlyView(.T.)


	oModel:GetModel( 'EEC13PED' ):SetOptional(.T.)

	oModel:SetActivate({|oModel| MGF13ACT(oModel)})

Return oModel


Static Function ViewDef()
	// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	Local oModel   := FWLoadModel( 'MGFEEC13' )
	// Cria a estrutura a ser usada na View
	Local oStruZZC := FWFormStruct( 2, 'ZZC',,/*lViewUsado*/ )
	Local oStruZZD := FWFormStruct( 2, 'ZZD',,/*lViewUsado*/ )
	Local oStruDis := FWFormStruct( 2, 'ZAN')
	Local oStruPed := FWFormStruct( 2, 'ZAY') /*,{ |x| ALLTRIM(x) $ 'ZZD_FILIAL, ZZD_ORCAME, ZZD_FILVEN, ZZD_FILENT, ZZD_SLDINI, ZZD_SEQUEN, ZZD_COD_I ,'+;
	'ZZD_DESC, ZZD_EMBAL1,ZZD_QTDEM1,ZZD_QE,ZZD_PART_N,ZZD_TES,ZZD_CF,ZZD_LOTECT,ZZD_NUMLOT,ZZD_DTVALI' }, )*/


	Local oView
	Local cCampos := {}

	oStruZZD:RemoveField('ZZD_ORCAME')
	oStruPed:RemoveField('ZAY_ORCAME')
	oStruDis:RemoveField('ZAN_ORCAME')

	oStruZZC:SetProperty('*',MVC_VIEW_CANCHANGE,.F.)

	//	oStruPed:SetProperty('*',MVC_VIEW_CANCHANGE,.F.)
	oStruDis:SetProperty('*',MVC_VIEW_CANCHANGE,.F.)
	//	oStruPed:SetProperty('ZZD_FILENT',MVC_VIEW_CANCHANGE,.T.)
	//	oStruPed:SetProperty('ZZD_SLDINI',MVC_VIEW_CANCHANGE,.T.)
	//	oStruPed:SetProperty('ZZD_COD_I',MVC_VIEW_CANCHANGE,.T.)
	//	oStruPed:SetProperty('ZZD_EMBAL1',MVC_VIEW_CANCHANGE,.T.)
	//	oStruPed:SetProperty('ZZD_QE',MVC_VIEW_CANCHANGE,.T.)
	//	oStruPed:SetProperty('ZZD_QTDEM1',MVC_VIEW_CANCHANGE,.T.)
	//	oStruPed:SetProperty('ZZD_PART_N',MVC_VIEW_CANCHANGE,.T.)
	//	oStruPed:SetProperty('ZZD_TES',MVC_VIEW_CANCHANGE,.T.)
	//	oStruPed:SetProperty('ZZD_CF',MVC_VIEW_CANCHANGE,.T.)
	//	oStruPed:SetProperty('ZZD_LOTECT',MVC_VIEW_CANCHANGE,.T.)
	//	oStruPed:SetProperty('ZZD_NUMLOT',MVC_VIEW_CANCHANGE,.T.)
	//	oStruPed:SetProperty('ZZD_DTVALI',MVC_VIEW_CANCHANGE,.T.)
	oStruDis:SetProperty('ZAN_FILENT',MVC_VIEW_CANCHANGE,.T.)
	oStruDis:SetProperty('ZAN_QUANTI',MVC_VIEW_CANCHANGE,.T.)
	oStruDis:SetProperty('ZAN_COD_I',MVC_VIEW_CANCHANGE,.T.)


	// Cria o objeto de View
	oView := FWFormView():New()

	// Define qual o Modelo de dados sera utilizado
	oView:SetModel( oModel )

	//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
	oView:AddField( 'VIEW_ZZC', oStruZZC, 'EEC13MASTER' )
	oView:AddGrid( 'DET_ZZD', oStruZZD, 'EEC13DETAIL' )
	oView:AddGrid( 'DIS_ZAN', oStruDis, 'EEC13DISTR' )
	oView:AddGrid( 'PED_ZZD', oStruPed, 'EEC13PED' )

	// Criar um "box" horizontal para receber algum elemento da view
	oView:CreateHorizontalBox( 'SUPERIOR' , 20 )
	oView:CreateHorizontalBox( 'MEIO' , 20 )
	oView:CreateHorizontalBox( 'MEIO2' , 30 )
	oView:CreateHorizontalBox( 'INFERIOR' , 30 )

	// Relaciona o ID da View com o "box" para exibicao
	oView:SetOwnerView( 'VIEW_ZZC', 'SUPERIOR' )
	oView:SetOwnerView( 'DET_ZZD', 'MEIO' )
	oView:SetOwnerView( 'DIS_ZAN', 'MEIO2' )
	oView:SetOwnerView( 'PED_ZZD', 'INFERIOR' )

	oView:AddIncrementField('DET_ZZD', 'ZZD_SEQUEN' )

Return oView

Static Function ValidQuant(oModel)

	Local nI := 0
	Local nY := 0
	Local lRet := .T.
	Local nTotLin := 0
	Local cErro := ""
	Local nLinAtu := oModel:GetModel( 'EEC13DISTR' ):nLine

	For nY := 1 to oModel:GetModel( 'EEC13DETAIL' ):Length()
		nTotLin := 0	
		oModel:GetModel( 'EEC13DETAIL' ):GoLine(nY)
		For nI := 1 to oModel:GetModel( 'EEC13DISTR' ):Length()
			If !oModel:GetModel('EEC13DISTR'):IsDeleted(nI)
				nTotLin += oModel:GetModel("EEC13DISTR"):GetValue("ZAN_QUANTI",nI)
			EndIF
		Next nI

		If !nTotLin <= oModel:GetModel( 'EEC13DETAIL' ):GetValue("ZZD_SLDINI")	 
			lRet := .F.	
			cErro += "Linha "+Str(nY)+CRLF
		EndIF
		oModel:GetModel( 'EEC13DETAIL' ):SetValue("ZZD_SLDATU", oModel:GetModel( 'EEC13DETAIL' ):GetValue("ZZD_SLDINI") - nTotLin)	

	Next nY	

	oModel:GetModel( 'EEC13DETAIL' ):GoLine(nLinAtu)

	if !lRet
		Help( ,, 'MGFEEC13-03',, "Soma do itens distribuidos maior que o total do or�amento"+CRLF+cErro, 1, 0 )
	EndIf

Return lRet


Static Function Gera(oModel)
	Local LRet := .t.
	Local aProds := {}
	Local cRetorno := ""
	Local nLinePed := oModel:GetModel('EEC13PED'):nLine
	Local nLineDistr := oModel:GetModel('EEC13DISTR'):nLine
	Local nLineDetail := oModel:GetModel('EEC13DETAIL'):nLine 

	If oModel:GetModel( 'EEC13MASTER' ):GetValue("ZZC_APROVA") == "5" 
		If	MsgYesNo("Deseja Gerar o Pedido de Exportacao?")
			For nI := 1 to oModel:GetModel( 'EEC13PED' ):Length()
				If !oModel:GetModel('EEC13PED'):IsDeleted(nI)
					lRet := lRet .and. !Empty(oModel:GetModel( 'EEC13PED' ):GetValue("ZAY_COD_I",nI))
					lRet := lRet .and. !Empty(oModel:GetModel( 'EEC13PED' ):GetValue("ZAY_FILENT",nI))
					lRet := lRet .and. !Empty(oModel:GetModel( 'EEC13PED' ):GetValue("ZAY_SLDINI",nI))
					lRet := lRet .and. !Empty(oModel:GetModel( 'EEC13PED' ):GetValue("ZAY_EMBAL1",nI))
					lRet := lRet .and. !Empty(oModel:GetModel( 'EEC13PED' ):GetValue("ZAY_QTDEM1",nI))
					lRet := lRet .and. !Empty(oModel:GetModel( 'EEC13PED' ):GetValue("ZAY_QE",nI))
					lRet := lRet .and. !Empty(oModel:GetModel( 'EEC13PED' ):GetValue("ZAY_PART_N",nI))
					lRet := lRet .and. !Empty(oModel:GetModel( 'EEC13PED' ):GetValue("ZAY_TES",nI))
					lRet := lRet .and. !Empty(oModel:GetModel( 'EEC13PED' ):GetValue("ZAY_CF",nI))
					lRet := lRet .and. !Empty(oModel:GetModel( 'EEC13PED' ):GetValue("ZAY_LOTECT",nI))
					lRet := lRet .and. !Empty(oModel:GetModel( 'EEC13PED' ):GetValue("ZAY_NUMLOT",nI))
					lRet := lRet .and. !Empty(oModel:GetModel( 'EEC13PED' ):GetValue("ZAY_DTVALI",nI))
				EndIf
			Next nI
			If lRet	
				//Nao permitir que nao tenha todos os itens no Pedido
				For nI := 1 to oModel:GetModel( 'EEC13DETAIL' ):Length()
					oModel:GetModel( 'EEC13DETAIL' ):GoLine(nI)
					lRet := .F.
					For nZ := 1 to oModel:GetModel( 'EEC13PED' ):Length()
						oModel:GetModel( 'EEC13PED' ):GoLine(nZ)
						If !oModel:GetModel('EEC13PED'):IsDeleted()
							If oModel:GetModel('EEC13PED'):GetValue("ZAY_SLDINI") > 0
								lRet := .T.
							EndIf
						EndIf
					Next nI
					cRetorno += iif(!lRet,CRLF+ "Item "+oModel:GetModel('EEC13DETAIL'):GetValue("ZZD_SEQUEN",nI),"")
				Next nI
			EndIF
			If lRet
				processa ({|| GeraPed(oModel,@lRet)},"Gerando Pedidos de Exportacao")
//				lRet := GeraPed(oModel)
				If lRet
					oModel:GetModel( 'EEC13MASTER' ):SetValue("ZZC_APROVA","4")
					RecLock("ZZC",.F.)
					ZZC->ZZC_APROVA := "4"
					ZZC->(MsUnlock())
				EndIf
			Else 
//				Alert("Favor preencher os campos na parte de pedidos")
				Help( ,, 'MGFEEC13-02',, "Necessario todos os itens no pedido."+cRetorno, 1, 0 )
			EndIf
		EndIf
		If lRet 
		 	lRet := FWFormCommit( oModel )
		Else
			 FWFormCommit( oModel )
		 EndIF
	Else
		//If lRet
		oModel:GetModel( 'EEC13MASTER' ):SetValue("ZZC_APROVA","5")
		GeraDis(oModel)
		/*	Else
		EndIf*/
	EndIF
Return lRet

Static Function GeraDis(oModel)

	Local LRet := .t.
	lRet := FWFormCommit( oModel )

Return lRet


Static Function GeraPed(oModel)

	Local nI := 0
	Local nY := 0
	Local nZ := 0
	Local nSequen := 0
	Local lRet := .T.
	Local nFil := 0
	Local nTotLin := 0
	Local cMsg := ""
	Local nLinAtu := oModel:GetModel( 'EEC13DISTR' ):nLine
	Local aCabec := {}
	Local aItens := {}
	Local aFiliais := {}
	Local cFil	:= cFilAnt

	// Array com os dados a serem enviados pela MsExecAuto() para gravacao automatica da capa do bem 
	Private lMsHelpAuto := .f. // Determina se as mensagens de help devem ser direcionadas para o arq. de log
	Private lMsErroAuto := .f. // Determina se houve alguma inconsist�ncia na execucao da rotina 

	DbSelectArea("EE7")
	DbSelectArea("EE8")
	DbSelectArea("ZAY")
	ZAY->(DbSetOrder(1))
	DbSelectArea("SX3")
	DbSetOrder(1)
	DbSeek("ZZC")
	ProcRegua(0)
	While !SX3->(Eof()) .and. SX3->X3_ARQUIVO == "ZZC"
		cAux := StrTran(SX3->X3_CAMPO,"ZZC","EE7")
		If Type("EE7->"+cAux) <> 'U'
			If (X3USO(SX3->X3_USADO) .OR. cAux == "EE7_FILIAL") .and. ;
			Alltrim(cAux) $ "EE7_FILIAL/EE7_CALCEM/EE7_IMPORT/EE7_IMLOJA/EE7_IMPODE/EE7_FORN/EE7_FOLOJA/EE7_FORNDE/"+;
			"EE7_IDIOMA/EE7_CONDPA/EE7_DIASPA/EE7_DESCPA/EE7_MPGEXP/EE7_DSCMPE/EE7_INCOTE/EE7_MOEDA/EE7_FRPPCC/EE7_VIA/EE7_VIA_DE/"+;
			"EE7_ORIGEM/EE7_DSCORI/EE7_DEST/EE7_DSCDES/EE7_PAISET/EE7_TIPTRA/EE7_TPDESC/EE7_CODBOL"
				aAdd(aCabec,{alltrim(cAux),oModel:GetModel("EEC13MASTER"):GetValue(SX3->X3_CAMPO),Nil})
			ElseIf Alltrim(cAux) $ "EE7_ZORCAM"
				aAdd(aCabec,{alltrim(cAux),oModel:GetModel("EEC13MASTER"):GetValue("ZZC_ORCAME"),Nil})
			EndIf
		EndIf
		IncProc("Criando Cabecalho dos Pedidos")
		SX3->(DbSkip())
	EndDo
	
	ProcRegua(oModel:GetModel( 'EEC13DETAIL' ):Length())
	For nY := 1 to oModel:GetModel( 'EEC13DETAIL' ):Length()
		nTotLin := 0	
		oModel:GetModel( 'EEC13DETAIL' ):GoLine(nY)
		For nI := 1 to oModel:GetModel( 'EEC13PED' ):Length()
			If Empty(Alltrim(oModel:GetModel("EEC13PED"):GetValue("ZAY_PEDVEN",nI))) .and. !oModel:GetModel('EEC13PED'):IsDeleted(nI)
				nFil := aScan(aFiliais,{ |x| x== oModel:GetModel("EEC13PED"):GetValue("ZAY_FILENT",nI) })
				If nFil <= 0
					aAdd(aFiliais,oModel:GetModel("EEC13PED"):GetValue("ZAY_FILENT",nI))
					nFil := Len(aFiliais)
					aAdd(aItens,{})		
				EndIf
				aAdd(aItens[nFil],{})
				DbSelectArea("SX3")
				DbSetOrder(1)
				DbSeek("ZZD")
				While !SX3->(Eof()) .and. SX3->X3_ARQUIVO == "ZZD"
					cAux := StrTran(StrTran(SX3->X3_CAMPO,"ZAY","EE8"),"ZZD","EE8")
					If Type("EE8->"+cAux) <> 'U'
						//If cAux == "EE8_FILIAL"
						//	aAdd(aItens[nFil][Len(aItens[nFil])],{cAux,oModel:GetModel("EEC13PED"):GetValue("ZZD_FILENT"),Nil})
						//Else
						If X3USO(SX3->X3_USADO).and. ;
						Alltrim(cAux) $ "EE8_SLDINI/EE8_SLDTOT"
							aAdd(aItens[nFil][Len(aItens[nFil])],{alltrim(cAux),oModel:GetModel("EEC13PED"):GetValue("ZAY_SLDINI",nI),Nil})
						ElseIf X3USO(SX3->X3_USADO).and. ;
						Alltrim(cAux) $ "EE8_EMBAL1/EE8_QTDEM1/EE8_QE/EE8_PART_N/EE8_TES/EE8_CF/EE8_LOTECT/EE8_NUMLOT/EE8_DTVALI"
							aAdd(aItens[nFil][Len(aItens[nFil])],{alltrim(cAux),oModel:GetModel("EEC13PED"):GetValue(StrTran(SX3->X3_CAMPO,"ZZD","ZAY")),Nil})
						ElseIf Alltrim(cAux) $ "EE8_CF/EE8_TES" .OR. X3USO(SX3->X3_USADO).and. ;
						Alltrim(cAux) $ "EE8_COD_I/EE8_SEQUEN/EE8_DESC/EE8_FORN/EE8_FOLOJA/EE8_PRCINC/EE8_PRCTOT/"+; 
						"EE8_PSLQUN/EE8_POSIPI/EE8_PRECO"
							aAdd(aItens[nFil][Len(aItens[nFil])],{alltrim(cAux),oModel:GetModel("EEC13DETAIL"):GetValue(SX3->X3_CAMPO),Nil})
						ElseIf Alltrim(cAux) $ "EE8_VM_DES"
							aAdd(aItens[nFil][Len(aItens[nFil])],{alltrim(cAux),oModel:GetModel("EEC13DETAIL"):GetValue("ZZD_DESC"),Nil})
						EndIf
						//EndIf
					EndIf
					SX3->(DbSkip())
				EndDo
			EndIf
		Next nI
		IncProc("Criando Itens dos Pedidos")
	Next nY	

	//Begin Transaction
	ProcRegua(Len(aFiliais))
	For nI := 1 to Len(aFiliais)
		//		aAdd(aCabec,{"EE7_PEDIDO","100000000000002",Nil})
		aCabec[aScan(aCabec,{|x| x[1] == "EE7_FILIAL"})][2] := Alltrim(aFiliais[nI])
		
		IncProc("Criando Pedido Filial "+Alltrim(aFiliais[nI]))
		
		/*
		For nY := 1 To Len(aItens)
		For nZ := 1 to Len(aItens[nY])
		aAdd(aItens[nY][nZ],{"EE8_PEDIDO",aCabec[Len(aCabec)][2],Nil})
		Next nZ
		Next nI	
		*/
		lRet := IncluirPed(aCabec,aItens[nI],nI) 



		If !lRet
			cMsg += "Erro ao incluir pedido na filial "+aFiliais[nI]+CRLF
		Else

			For nY := 1 to oModel:GetModel( 'EEC13DETAIL' ):Length()
				oModel:GetModel( 'EEC13DETAIL' ):GoLine(nI)
				For nZ := 1 to oModel:GetModel( 'EEC13PED' ):Length()
					oModel:GetModel( 'EEC13PED' ):GoLine(nZ)
					If !oModel:GetModel('EEC13PED'):IsDeleted()
						If oModel:GetModel('EEC13PED'):GetValue("ZAY_FILENT") == aFiliais[nI]
							oModel:GetModel('EEC13PED'):SetValue("ZAY_PEDEXP",EE7->EE7_PEDIDO)
							oModel:GetModel('EEC13PED'):SetValue("ZAY_PEDVEN",EE7->EE7_PEDFAT)
						EndIf
					EndIf
				Next nI
			Next nY

		EndIf
	Next nI
	//End Transaction


	If nI > 0
		RESET ENVIRONMENT
		PREPARE ENVIRONMENT EMPRESA cEmpAnt FILIAL cFil MODULO "EEC"
	EndIf

	oModel:GetModel( 'EEC13DETAIL' ):GoLine(nLinAtu)

	//iif(lRet,FWFormCommit( oModel ),Nil)

//	DbSelectArea("ZZC")
//	ZZC->(Reclock("ZZC",.F.))
//	ZZC->ZZC_APROVA := "4"
//	ZZC->(MsUnlock())

	lRet := Empty(cMsg)
	iif(!lRet,Help( ,, 'MGFEEC13-01',, cMsg, 1, 0 ),nil)


Return lRet

Static Function IncluirPed(aCabec,aItens)
    Local cError        := ''
	Local lExecAuto := GetMv("MGF_EEC13E",,.T.)
	Local lRet := .F.
	Local nI := 0
	Local nY := 0
	Local aCab := {}
	Local aIt := {}
	Local cFilA := cFilAnt
	Local cFilB := aCabec[AScan(aCabec,{|x| x[1] == "EE7_FILIAL"})][2]
	Local nPosPed := 0
	//Local aIt := {}
	Private lMsHelpAuto := .f. // Determina se as mensagens de help devem ser direcionadas para o arq. de log
	Private lMsErroAuto := .f. // Determina se houve alguma inconsist�ncia na execucao da rotina 

	If cFilA <> cFilB
		If nI <> 1
			RESET ENVIRONMENT
		EndIf
		PREPARE ENVIRONMENT EMPRESA cEmpAnt FILIAL cFilB MODULO "EEC"
	EndIf

	/*	aCab := { {'EE7_FILIAL' ,'01' ,NIL},; 
	{'EE7_PEDIDO' ,GetSxeNum("EE7","EE7_PEDIDO") ,NIL},; //
	{'EE7_CALCEM' ,'1' ,NIL},; //
	{'EE7_IMPORT' ,'000001' ,NIL},; 
	{'EE7_IMLOJA' ,'00' ,NIL},; 
	{'EE7_IMPODE' ,"IMPORTADOR" ,NIL},; 
	{'EE7_FORN' ,'000001' ,NIL},; 
	{'EE7_FOLOJA' ,'00' ,NIL},; 
	{'EE7_CONDPA' ,'00001' ,NIL},;
	{'EE7_DIASPA' ,1 ,NIL},;
	{'EE7_MPGEXP' ,'003' ,NIL},;
	{'EE7_INCOTE' ,'FOB' ,NIL},;
	{'EE7_MOEDA' ,'US$' ,NIL},;
	{'EE7_FRPPCC' ,'PP' ,NIL},;
	{'EE7_VIA' ,'02' ,NIL},;
	{'EE7_ORIGEM' ,'AGA' ,NIL},;
	{'EE7_DEST' ,'NYC' ,NIL},;
	{'EE7_PAISET' ,'100' ,NIL},;	
	{'EE7_IDIOMA' ,"INGLES-INGLES" ,NIL},;
	{'EE7_CODBOL' ,"NY" ,NIL},; //
	{'EE7_TIPTRA' ,'1' ,NIL}}
	aAdd(aIt,{{'EE8_COD_I' ,'1' , NIL},;
	{'EE8_SEQUEN' ,"000001" , NIL},; 
	{'EE8_FORN' ,'000001' , NIL},; 
	{'EE8_FOLOJA' ,'01' , NIL},; 
	{'EE8_SLDINI' , 6 , NIL},; 
	{'EE8_PRCINC' , 10 , NIL},;// 
	{'EE8_PRCTOT' , 60 , NIL},;// 
	{'EE8_EMBAL1' , '001' , NIL},; 
	{'EE8_QE' , 10 , NIL},; 
	{'EE8_PSLQUN' , 10 , NIL},; 
	{'EE8_POSIPI' , "01011010" , NIL},; 
	{'EE8_QTDEM1' , 6 , NIL},;// 
	{'EE8_TES' , "501" , NIL},;// 
	{'EE8_CF' , "7101" , NIL},;// 
	{'EE8_PRECO' , 10 , NIL}})
	*/

	If lExecAuto
		nPosPed := aScan(aCabec,{|x| x[1] == "EE7_PEDIDO"})
		If nPosPed <= 0 
			aAdd(aCabec,{"EE7_PEDIDO",GetSxeNum("EE7","EE7_PEDIDO"),Nil})
		Else
			aCabec[nPosPed][2] := GetSxeNum("EE7","EE7_PEDIDO")
		EndIf

		MSExecAuto( {|X,Y,Z| EECAP100(X,Y,Z)},aCabec ,aItens, 3) 

		If lMsErroAuto 
			lRet := .F. 
			If (!IsBlind()) // COM INTERFACE GRAFICA
			MostraErro()
		    Else // EM ESTADO DE JOB
		        cError := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO
		
		        ConOut(PadC("Automatic routine ended with error", 80))
		        ConOut("Error: "+ cError)
		    EndIf
		Else
			lRet := .T.
		EndIf
	Else
		Begin Transaction
			RecLock("EE7",.T.)
			For nI := 1 To Len(aCabec)
				&("EE7->"+aCabec[nI][1]) := aCabec[nI][2]
			Next nI
			EE7->(MsUnlock())
			For nI := 1 To Len(aItens)
				RecLock("EE8",.T.)
				For nY := 1 to Len(aItens[nI])
					&("EE8->"+aItens[nI][nY][1]) := aItens[nI][nY][2]
				Next nY
				EE8->(MsUnlock())
			Next nI		
		End Transaction
		lRet := .T.
	EndIf
Return lRet

Static Function MGF13ACT(oModel)

	oModel:GetModel( 'EEC13DETAIL' ):SetNoUpdateLine(.t.)
	oModel:GetModel( 'EEC13DETAIL' ):SetNoInsertLine(.t.)
	oModel:GetModel( 'EEC13DETAIL' ):SetNoDeleteLine(.t.)
	If oModel:GetModel( 'EEC13MASTER' ):GetValue("ZZC_APROVA") == "5"
		oModel:GetModel( 'EEC13DISTR' ):SetNoUpdateLine(.t.)
		oModel:GetModel( 'EEC13DISTR' ):SetNoInsertLine(.t.)
		oModel:GetModel( 'EEC13DISTR' ):SetNoDeleteLine(.t.)
	EndIf

Return

Static Function prevld(oModel,n,cPonto,cCpo,e)
	Local xRet := .t.
	If cPonto == 'DELETE'
//		oModel   :=  ParamIxb[1] 
		If !Empty(Alltrim(oModel:GetValue("ZAY_PEDVEN")))
			xRet := .F.
			Help( ,, 'MGFEEC13-04',, "Nao � possivel excluir linhas com Pedido gerado", 1, 0 )
		Endif
	EndIf
Return xRet