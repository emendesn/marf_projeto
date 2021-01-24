#Include 'Protheus.ch'
#INCLUDE "FWMVCDEF.CH"
#INCLUDE 'TOPCONN.CH'

STATIC LCOPYCC
STATIC LCOPY
STATIC CVERSAO
/*
==============================================================================================================
Programa............: MGFCOM06
Autor...............: Joni Lima
Data................: 28/12/2016
Descrição / Objetivo: Cadastro de Grade de Aprovação
Doc. Origem.........: Contrato - GAP GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Tela de Cadastro de Grade
==============================================================================================================  
Data da alteração............: 04/12/2018
Autor........................: Caroline Cazela (caroline.cazela@totvspartners.com.br)
Descrição da alteração.......: Inclusão de grade de lançamentos contábeis. Utiliza as tabelas ZAB, ZAD e ZA0.
==============================================================================================================
*/ 
User Function MGFCOM06()
	
	Local oMBrowse := nil
	Public __aXAllUser := FwSFAllUsers()
	
	//xVerDHL()
	
	oMBrowse:= FWmBrowse():New()
	
	oMBrowse:AddLegend( "ZAB_HOMOLO == 'S'", "GREEN"  , "Grade Ativa" )
	oMBrowse:AddLegend( "ZAB_HOMOLO == 'N' .and. Empty(ZAB_VERSAO) ", "YELLOW" , "Em Edição" )
	oMBrowse:AddLegend( "ZAB_HOMOLO == 'N' .and. !Empty(ZAB_VERSAO) ", "RED"    , "Versão Anterior" )
	
	oMBrowse:SetAlias("ZAB")
	oMBrowse:SetDescription("Grade de Aprovação")
	
	oMBrowse:SetMenuDef('MGFCOM06')
	
	oMBrowse:Activate()
	
Return

/*
=====================================================================================
Programa............: MenuDef
Autor...............: Joni Lima
Data................: 28/12/2016
Descrição / Objetivo: MenuDef da rotina
Doc. Origem.........: Contrato - GAP GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Definição do Menu
=====================================================================================
*/
Static Function MenuDef()
	
	Local	aRotina	:= {}
	
	ADD OPTION aRotina TITLE "Pesquisar"  			ACTION "PesqBrw"  	  OPERATION 1                      ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 			ACTION "U_xMGC6Vis"	  OPERATION MODEL_OPERATION_VIEW   ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"    			ACTION "U_xMGC6Incl"  OPERATION MODEL_OPERATION_INSERT ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"    			ACTION "U_xMGC6Alt"   OPERATION MODEL_OPERATION_UPDATE ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"    			ACTION "U_xMGC6Exc"   OPERATION MODEL_OPERATION_DELETE ACCESS 0
	ADD OPTION aRotina TITLE "Gerar Nova Versão"    ACTION "U_xMGC6Cop"   OPERATION 9 					   ACCESS 0
	ADD OPTION aRotina TITLE "Copia para outro CC"  ACTION "U_xMGC6CC"	  OPERATION 9 					   ACCESS 0
	ADD OPTION aRotina TITLE "Homologar"  			ACTION "U_xM06Homl"   OPERATION 7					   ACCESS 0
	
Return(aRotina)

/*
=====================================================================================
Programa............: ModelDef
Autor...............: Joni Lima
Data................: 28/12/2016
Descrição / Objetivo: ModelDef
Doc. Origem.........: Contrato - GAP GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Definição do Modelo de Dados para cadastro de Grade
=====================================================================================
*/
Static Function ModelDef()
	
	Local oModel	:= Nil
	
	Local oStrZAB 	:= FWFormStruct(1,"ZAB")
	Local oStrZAC 	:= FWFormStruct(1,"ZAC")
	Local oStrZAD 	:= FWFormStruct(1,"ZAD")
	Local oStrZAE 	:= FWFormStruct(1,"ZAE") 
	Local oStrZA0 	:= FWFormStruct(1,"ZA0") // Alteração Caroline Cazela 03/12/18 - Contabilidade
	
	If ValType(LCOPY) == 'U'
		LCOPY := .F.
	EndIf
	
	oStrZAB:SetProperty("ZAB_CC",MODEL_FIELD_WHEN,{||!LCOPY})
	
	oStrZAD:SetProperty( 'ZAD_VALFIM' , MODEL_FIELD_OBRIGAT, .T.)
	
	oModel := MPFormModel():New("XMGFCOM06",/*bPreValidacao*/,/*bPosValid*/,/*bCommit*/,/*bCancel*/)
	
	oModel:AddFields("ZABMASTER",/*cOwner*/,oStrZAB, /*bPreValid*/, /*bPosValid*/, /*bCarga*/)
	
	If MV_PAR01 == 1 //Tecnica
		
		oStrZAD:SetProperty( 'ZAD_VALFIM' , MODEL_FIELD_OBRIGAT, .F.)
		
		oModel:AddGrid("ZACDETAIL","ZABMASTER",oStrZAC, /*bLinePreValid*/, /*bLinePosValid*/,/*bPreValid*/,/*bPosValid*/, /*bCarga*/ )
		oModel:AddGrid("ZADDETAIL","ZACDETAIL",oStrZAD, /*bLinePreValid*/, /*bLinePosValid*/,/*bPreValid*/,/*bPosValid*/, /*bCarga*/ )
		
		oModel:SetRelation("ZACDETAIL",{{"ZAC_FILIAL","xFilial('ZAC')"},{"ZAC_CODIGO","ZAB_CODIGO"},{"ZAC_VERSAO","ZAB_VERSAO"}},ZAC->(IndexKey(3)))
		oModel:SetRelation("ZADDETAIL",{{"ZAD_FILIAL","xFilial('ZAD')"},{"ZAD_CODIGO","ZAC_CODIGO"},{"ZAD_VERSAO","ZAC_VERSAO"},{"ZAD_GRPPRD","ZAC_GRPPRD"}},ZAD->(IndexKey(1)))
		
		oModel:SetDescription("Grade Tecnica")
		oModel:SetPrimaryKey({"ZAB_FILIAL","ZAB_CODIGO","ZAB_VERSAO"})
		
		oModel:GetModel( "ZACDETAIL" ):SetUniqueLine({"ZAC_GRPPRD"})
		oModel:GetModel( "ZADDETAIL" ):SetUniqueLine({"ZAD_NIVEL"})
		
	ElseIf MV_PAR01 == 2 //Pedido
		
		oModel:AddGrid("ZADDETAIL","ZABMASTER",oStrZAD, /*bLinePreValid*/, /*bLinePosValid*/,/*bPreValid*/,/*bPosValid*/, /*bCarga*/ )
		oModel:SetRelation("ZADDETAIL",{{"ZAD_FILIAL","xFilial('ZAD')"},{"ZAD_CODIGO","ZAB_CODIGO"},{"ZAD_VERSAO","ZAB_VERSAO"}},ZAD->(IndexKey(2)))
		
		oModel:SetDescription("Grade Pedido")
		oModel:SetPrimaryKey({"ZAB_FILIAL","ZAB_CODIGO","ZAB_VERSAO"})
		
		oModel:GetModel( "ZADDETAIL" ):SetUniqueLine({"ZAD_NIVEL"})
		
	ElseIf MV_PAR01 == 3 //Contas Pagar
		
		oModel:AddGrid("ZAEDETAIL","ZABMASTER",oStrZAE, /*bLinePreValid*/, /*bLinePosValid*/,/*bPreValid*/,/*bPosValid*/, /*bCarga*/ )
		oModel:AddGrid("ZADDETAIL","ZAEDETAIL",oStrZAD, /*bLinePreValid*/, /*bLinePosValid*/,/*bPreValid*/,/*bPosValid*/, /*bCarga*/ )
		
		oModel:SetRelation("ZAEDETAIL",{{"ZAE_FILIAL","xFilial('ZAE')"},{"ZAE_CODIGO","ZAB_CODIGO"},{"ZAE_VERSAO","ZAB_VERSAO"}},ZAE->(IndexKey(1)))
		oModel:SetRelation("ZADDETAIL",{{"ZAD_FILIAL","xFilial('ZAD')"},{"ZAD_CODIGO","ZAE_CODIGO"},{"ZAD_VERSAO","ZAE_VERSAO"},{"ZAD_NATURE","ZAE_NATURE"}},ZAD->(IndexKey(3)))
		
		oModel:SetDescription("Grade Contas a Pagar")
		oModel:SetPrimaryKey({"ZAB_FILIAL","ZAB_CODIGO","ZAB_VERSAO"})
		
		oModel:GetModel( "ZAEDETAIL" ):SetUniqueLine({"ZAE_NATURE"})
		oModel:GetModel( "ZADDETAIL" ):SetUniqueLine({"ZAD_NIVEL"})
		
	ElseIf MV_PAR01 == 4 //Solicitação ao Armazém
		
		oModel:AddGrid("ZADDETAIL","ZABMASTER",oStrZAD, /*bLinePreValid*/, /*bLinePosValid*/,/*bPreValid*/,/*bPosValid*/, /*bCarga*/ )
		oModel:SetRelation("ZADDETAIL",{{"ZAD_FILIAL","xFilial('ZAD')"},{"ZAD_CODIGO","ZAB_CODIGO"},{"ZAD_VERSAO","ZAB_VERSAO"}},ZAD->(IndexKey(2)))
		
		oModel:SetDescription("Grade Solicitação ao Armazém")
		oModel:SetPrimaryKey({"ZAB_FILIAL","ZAB_CODIGO","ZAB_VERSAO"})
		
		oModel:GetModel( "ZADDETAIL" ):SetUniqueLine({"ZAD_NIVEL"})
	
	ElseIf MV_PAR01 == 5 //Lançamento Contábil // Alteração Caroline Cazela 03/12/18 - Contabilidade
		
		oModel:AddGrid("ZA0DETAIL","ZABMASTER",oStrZA0, /*bLinePreValid*/, /*bLinePosValid*/,/*bPreValid*/,/*bPosValid*/, /*bCarga*/ )
		oModel:AddGrid("ZADDETAIL","ZA0DETAIL",oStrZAD, /*bLinePreValid*/, /*bLinePosValid*/,/*bPreValid*/,/*bPosValid*/, /*bCarga*/ )
		
		oModel:SetRelation("ZA0DETAIL",{{"ZA0_FILIAL","xFilial('ZA0')"},{"ZA0_CODIGO","ZAB_CODIGO"},{"ZA0_VERSAO","ZAB_VERSAO"}},ZA0->(IndexKey(1)))
		oModel:SetRelation("ZADDETAIL",{{"ZAD_FILIAL","xFilial('ZAD')"},{"ZAD_CODIGO","ZA0_CODIGO"},{"ZAD_VERSAO","ZA0_VERSAO"},{"ZAD_EMPFIL","ZA0_EMPFIL"},{"ZAD_CDUSER","ZA0_CDUSER"}},ZAD->(IndexKey(4)))
		
		oModel:SetDescription("Grade Contábil")
		oModel:SetPrimaryKey({"ZAB_FILIAL","ZAB_CODIGO","ZAB_VERSAO"})
		
		oModel:GetModel( "ZADDETAIL" ):SetUniqueLine({"ZAD_NIVEL"})	
	EndIf
	
	oModel:SetActivate({|oModel,lCont|xMGC6Activ(oModel,lCont)})
	
Return oModel

/*
=====================================================================================
Programa............: ViewDef
Autor...............: Joni Lima
Data................: 28/12/2016
Descrição / Objetivo: ViewDef
Doc. Origem.........: Contrato - GAP GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Definição da visualização da tela
=====================================================================================
*/
Static Function ViewDef()
	
	Local oView := nil
	
	Local oModel  	:= FWLoadModel('MGFCOM06')
	
	Local cFldZAB	:= 'ZAB_CODAPR|'
	Local cFldZAC	:= 'ZAC_CODIGO|ZAC_VERSAO|ZAC_CODGAP'
	Local cFldZAD	:= 'ZAD_CODIGO|ZAD_VERSAO|ZAD_GRPPRD|ZAD_NATURE|ZAD_TPAPR|ZAD_EMPFIL|ZAD_CDUSER'
	Local cFldZAE	:= 'ZAE_CODIGO|ZAE_VERSAO|ZAE_CODGAP'  
	Local cFldZA0	:= 'ZA0_CODIGO|ZA0_VERSAO'  // Alteração Joni 22/01/19 - Contabilidade
	
	Local oStrZAB 	:= FWFormStruct( 2, "ZAB",{|cCampo|!(AllTrim(cCampo) $ cFldZAB)})
	Local oStrZAC 	:= FWFormStruct( 2, "ZAC",{|cCampo|!(AllTrim(cCampo) $ cFldZAC)})
	Local oStrZAD 	:= FWFormStruct( 2, "ZAD",{|cCampo|!(AllTrim(cCampo) $ cFldZAD)})
	Local oStrZAE	:= FWFormStruct( 2, "ZAE",{|cCampo|!(AllTrim(cCampo) $ cFldZAE)})
	Local oStrZA0	:= FWFormStruct( 2, "ZA0",{|cCampo|!(AllTrim(cCampo) $ cFldZA0)}) // Alteração Caroline Cazela 03/12/18 - Contabilidade
	
	oStrZAD:SetProperty( 'ZAD_SEQ' , MVC_VIEW_CANCHANGE,.F.)
	
	oView := FWFormView():New()
	oView:SetModel(oModel)
	
	oView:AddField( 'VIEW_ZAB' , oStrZAB, 'ZABMASTER' )
	
	If MV_PAR01 == 1 //Tecnica
		
		oStrZAD:RemoveField('ZAD_VALINI')
		oStrZAD:RemoveField('ZAD_VALFIM')
		
		oView:AddGrid( 'VIEW_MEI' , oStrZAC, 'ZACDETAIL' )
		oView:AddGrid( 'VIEW_ZAD' , oStrZAD, 'ZADDETAIL' )
	ElseIf MV_PAR01 == 2 //.or. ZAB->ZAB_TIPO =='P'//Pedido
		
		oView:AddGrid( 'VIEW_ZAD' , oStrZAD, 'ZADDETAIL' )
		
		oView:CreateHorizontalBox( 'SUPERIOR' , 20 )
		oView:CreateHorizontalBox( 'INFERIOR' , 80 )
		
		oView:SetOwnerView( 'VIEW_ZAB', 'SUPERIOR' )
		oView:SetOwnerView( 'VIEW_ZAD', 'INFERIOR' )
		
	ElseIf MV_PAR01 == 3 //Contas Pagar
		oView:AddGrid( 'VIEW_MEI' , oStrZAE, 'ZAEDETAIL' )
		oView:AddGrid( 'VIEW_ZAD' , oStrZAD, 'ZADDETAIL' )
		
		
	ElseIf MV_PAR01 == 4 //.or. ZAB->ZAB_TIPO =='S'//Solicitação ao Armazém
		
		oView:AddGrid( 'VIEW_ZAD' , oStrZAD, 'ZADDETAIL' )
		
		oView:CreateHorizontalBox( 'SUPERIOR' , 20 )
		oView:CreateHorizontalBox( 'INFERIOR' , 80 )
		
		oView:SetOwnerView( 'VIEW_ZAB', 'SUPERIOR' )
		oView:SetOwnerView( 'VIEW_ZAD', 'INFERIOR' )
	ElseIf MV_PAR01 == 5 // Alteração Caroline Cazela 03/12/18 - Contabilidade  
   		//oStrZAB:RemoveField('ZAB_CC')    
   		
		oView:AddGrid( 'VIEW_ZAD' , oStrZAD, 'ZADDETAIL' )
		oView:AddGrid( 'VIEW_ZA0' , oStrZA0, 'ZA0DETAIL' )   
		
		oView:CreateHorizontalBox( 'SUPERIOR' , 20 )
		oView:CreateHorizontalBox( 'MEIO' , 40 )
		oView:CreateHorizontalBox( 'INFERIOR' , 40 )
		
		oView:SetOwnerView( 'VIEW_ZAB', 'SUPERIOR' )
		oView:SetOwnerView( 'VIEW_ZA0', 'MEIO' )  
		oView:SetOwnerView( 'VIEW_ZAD', 'INFERIOR' )
		
	EndIf
	
	If Alltrim(str(MV_PAR01)) $ '1|3' //Quando Tecnica ou Financeiro
		oView:CreateHorizontalBox( 'SUPERIOR' , 20 )
		oView:CreateHorizontalBox( 'MEIO' 	  , 40 )
		oView:CreateHorizontalBox( 'INFERIOR' , 40 )
		
		oView:SetOwnerView( 'VIEW_ZAB', 'SUPERIOR' )
		oView:SetOwnerView( 'VIEW_MEI', 'MEIO' 	   )
		oView:SetOwnerView( 'VIEW_ZAD', 'INFERIOR' )
	EndIf
	
	oView:AddIncrementField( 'VIEW_ZAD', 'ZAD_SEQ' )
	
Return oView

/*
=====================================================================================
Programa............: xMGC6Activ
Autor...............: Joni Lima
Data................: 29/12/2016
Descrição / Objetivo: Utilizado na Ativação do Modelo
Doc. Origem.........: Contrato - GAP GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Foi feito tratamento para cópia de Grade
=====================================================================================
*/
Static Function xMGC6Activ(oModel,lCont)
	
	Local lRet := .T.
	
	Local aSaveLines:=	FwSaveRows()
	
	Local oMdlZAB	:= Nil
	Local oMdlZAC	:= Nil
	Local oMdlZAD	:= Nil
	Local oMdlZAE	:= Nil
	Local oMdlZA0	:= Nil
	Local cCod		:= ''
	Local cVer		:= ''
	Local cxVer		:= ''
	
	Local ni		:= 0
	Local nl		:= 0
	
	If FUNNAME() =='MGFCOM06' .and. oModel:GetOperation() == MODEL_OPERATION_INSERT
		
		//Quando Cópia
		If LCOPY
			
			oMdlZAB := oModel:GetModel('ZABMASTER')
			oMdlZAB:LoadValue('ZAB_CODIGO',ZAB->ZAB_CODIGO)
			oMdlZAB:LoadValue('ZAB_VERSAO','')
			oMdlZAB:LoadValue('ZAB_DTINIC',dDataBase)
			oMdlZAB:LoadValue('ZAB_HOMOLO','N')
			
			If MV_PAR01 == 1 //Tecnica
				
				oMdlZAC := oModel:GetModel('ZACDETAIL')
				oMdlZAD := oModel:GetModel('ZADDETAIL')
				
				For ni := 1 to oMdlZAC:Length()
					oMdlZAC:GoLine(ni)
					oMdlZAC:LoadValue('ZAC_CODIGO',ZAB->ZAB_CODIGO)
					oMdlZAC:LoadValue('ZAC_VERSAO','')
					For nl := 1  to oMdlZAD:Length()
						oMdlZAD:GoLine(nl)
						oMdlZAD:LoadValue('ZAD_CODIGO',ZAB->ZAB_CODIGO)
						oMdlZAD:LoadValue('ZAD_VERSAO','')
					Next nl
				Next ni
				
				oMdlZAC:GoLine(1)
				oMdlZAD:GoLine(1)
				
			ElseIf MV_PAR01 == 2 //Pedido
				
				oMdlZAD := oModel:GetModel('ZADDETAIL')
				
				For ni := 1  to oMdlZAD:Length()
					oMdlZAD:GoLine(ni)
					oMdlZAD:LoadValue('ZAD_CODIGO',ZAB->ZAB_CODIGO)
					oMdlZAD:LoadValue('ZAD_VERSAO','')
				Next ni
				
				oMdlZAD:GoLine(1)
				
			ElseIf MV_PAR01 == 3 //Contas Pagar
				
				oMdlZAE := oModel:GetModel('ZAEDETAIL')
				oMdlZAD := oModel:GetModel('ZADDETAIL')
				
				For ni := 1 to oMdlZAE:Length()
					oMdlZAE:GoLine(ni)
					oMdlZAE:LoadValue('ZAE_CODIGO',ZAB->ZAB_CODIGO)
					oMdlZAE:LoadValue('ZAE_VERSAO','')
					For nl := 1  to oMdlZAD:Length()
						oMdlZAD:GoLine(nl)
						oMdlZAD:LoadValue('ZAD_CODIGO',ZAB->ZAB_CODIGO)
						oMdlZAD:LoadValue('ZAD_VERSAO','')
					Next nl
				Next ni
				
				oMdlZAE:GoLine(1)
				oMdlZAD:GoLine(1)
			ElseIf MV_PAR01 == 5 //Contas Pagar	
				
				//oMdlZAE := oModel:GetModel('ZAEDETAIL')
				oMdlZA0 := oModel:GetModel('ZA0DETAIL')
				oMdlZAD := oModel:GetModel('ZADDETAIL')
				
				For ni := 1 to oMdlZA0:Length()
					oMdlZA0:GoLine(ni)
					oMdlZA0:LoadValue('ZA0_CODIGO',ZAB->ZAB_CODIGO)
					oMdlZA0:LoadValue('ZA0_VERSAO','')
					For nl := 1  to oMdlZAD:Length()
						oMdlZAD:GoLine(nl)
						oMdlZAD:LoadValue('ZAD_CODIGO',ZAB->ZAB_CODIGO)
						oMdlZAD:LoadValue('ZAD_VERSAO','')
					Next nl
				Next ni
				oMdlZA0:GoLine(1)
				oMdlZAD:GoLine(1)	
			EndIf
		EndIf
		
		If LCOPYCC
			
			oMdlZAB := oModel:GetModel('ZABMASTER')
			oMdlZAB:SetValue('ZAB_DTINIC',dDataBase)
			oMdlZAB:SetValue('ZAB_HOMOLO','N')
			//oMdlZAB:SetValue('ZAB_CODIGO','')
			oMdlZAB:LoadValue('ZAB_VERSAO','')
			oMdlZAB:SetValue('ZAB_CC','')
			
			If MV_PAR01 == 1 //Tecnica
				
				oMdlZAC := oModel:GetModel('ZACDETAIL')
				oMdlZAD := oModel:GetModel('ZADDETAIL')
				
				For ni := 1 to oMdlZAC:Length()
					oMdlZAC:GoLine(ni)
					oMdlZAC:LoadValue('ZAC_CODIGO','')
					oMdlZAC:LoadValue('ZAC_VERSAO','')
					For nl := 1  to oMdlZAD:Length()
						oMdlZAD:GoLine(nl)
						oMdlZAD:LoadValue('ZAD_CODIGO','')
						oMdlZAD:LoadValue('ZAD_VERSAO','')
					Next nl
				Next ni
				
				oMdlZAC:GoLine(1)
				oMdlZAD:GoLine(1)
				
			ElseIf MV_PAR01 == 2 //Pedido
				
				oMdlZAD := oModel:GetModel('ZADDETAIL')
				
				For ni := 1  to oMdlZAD:Length()
					oMdlZAD:GoLine(ni)
					oMdlZAD:LoadValue('ZAD_CODIGO','')
					oMdlZAD:LoadValue('ZAD_VERSAO','')
				Next ni
				
			ElseIf MV_PAR01 == 3 //Contas Pagar
				
				oMdlZAE := oModel:GetModel('ZAEDETAIL')
				oMdlZAD := oModel:GetModel('ZADDETAIL')
				
				For ni := 1 to oMdlZAE:Length()
					oMdlZAE:GoLine(ni)
					oMdlZAE:LoadValue('ZAE_CODIGO','')
					oMdlZAE:LoadValue('ZAE_VERSAO','')
					For nl := 1  to oMdlZAD:Length()
						oMdlZAD:GoLine(nl)
						oMdlZAD:LoadValue('ZAD_CODIGO','')
						oMdlZAD:LoadValue('ZAD_VERSAO','')
					Next nl
				Next ni
				
			ElseIf MV_PAR01 == 4 //SA
				
				oMdlZAD := oModel:GetModel('ZADDETAIL')
				
				For ni := 1  to oMdlZAD:Length()
					oMdlZAD:GoLine(ni)
					oMdlZAD:LoadValue('ZAD_CODIGO','')
					oMdlZAD:LoadValue('ZAD_VERSAO','')
				Next ni 
			ElseIf MV_PAR01 == 5 // Alteração Caroline Cazela 03/12/18 - Contabilidade	
				oMdlZA0 := oModel:GetModel('ZA0DETAIL')
				oMdlZAD := oModel:GetModel('ZADDETAIL')
				
				For ni := 1 to oMdlZAC:Length()
					oMdlZA0:GoLine(ni)
					oMdlZA0:LoadValue('ZA0_CODIGO','')
					oMdlZA0:LoadValue('ZA0_VERSAO','')
					For nl := 1  to oMdlZAD:Length()
						oMdlZAD:GoLine(nl)
						oMdlZAD:LoadValue('ZAD_CODIGO','')
						oMdlZAD:LoadValue('ZAD_VERSAO','')
					Next nl
				Next ni
				
				oMdlZA0:GoLine(1)
				oMdlZAD:GoLine(1)
				
			EndIf
			
		EndIf
	ElseIf IsInCallStack('MGFCOM03')
		
		cxVer := Soma1(ZAB->ZAB_VERSAO)
		
		oMdlZAB := oModel:GetModel('ZABMASTER')
		oMdlZAB:SetValue('ZAB_CODIGO',ZAB->ZAB_CODIGO)
		oMdlZAB:SetValue('ZAB_VERSAO',cxVer)
		oMdlZAB:SetValue('ZAB_DTINIC',dDataBase)
		oMdlZAB:SetValue('ZAB_HOMOLO','S')
		oMdlZAB:SetValue('ZAB_HORHML',SUBSTR(Time(),1,5))
		If MV_PAR01 == 1 //Tecnica
			
			oMdlZAC := oModel:GetModel('ZACDETAIL')
			oMdlZAD := oModel:GetModel('ZADDETAIL')
			
			For ni := 1 to oMdlZAC:Length()
				oMdlZAC:GoLine(ni)
				oMdlZAC:SetValue('ZAC_CODIGO',ZAB->ZAB_CODIGO)
				oMdlZAC:SetValue('ZAC_VERSAO',cxVer)
				For nl := 1  to oMdlZAD:Length()
					oMdlZAD:GoLine(nl)
					oMdlZAD:SetValue('ZAD_CODIGO',ZAB->ZAB_CODIGO)
					oMdlZAD:SetValue('ZAD_VERSAO',cxVer)
				Next nl
			Next ni
			
			oMdlZAC:GoLine(1)
			oMdlZAD:GoLine(1)
			
		ElseIf MV_PAR01 == 2 //Pedido
			
			oMdlZAD := oModel:GetModel('ZADDETAIL')
			
			For ni := 1  to oMdlZAD:Length()
				oMdlZAD:GoLine(ni)
				oMdlZAD:SetValue('ZAD_CODIGO',ZAB->ZAB_CODIGO)
				oMdlZAD:SetValue('ZAD_VERSAO',cxVer)
			Next ni
			
			oMdlZAD:GoLine(1)
			
		ElseIf MV_PAR01 == 3 //Contas Pagar
			
			oMdlZAE := oModel:GetModel('ZAEDETAIL')
			oMdlZAD := oModel:GetModel('ZADDETAIL')
			
			For ni := 1 to oMdlZAE:Length()
				oMdlZAE:GoLine(ni)
				oMdlZAE:SetValue('ZAE_CODIGO',ZAB->ZAB_CODIGO)
				oMdlZAE:SetValue('ZAE_VERSAO',cxVer)
				For nl := 1  to oMdlZAD:Length()
					oMdlZAD:GoLine(nl)
					oMdlZAD:SetValue('ZAD_CODIGO',ZAB->ZAB_CODIGO)
					oMdlZAD:SetValue('ZAD_VERSAO',cxVer)
				Next nl
			Next ni
			
			oMdlZAE:GoLine(1)
			oMdlZAD:GoLine(1)
			
		ElseIf MV_PAR01 == 4 //SA
			
			oMdlZAD := oModel:GetModel('ZADDETAIL')
			
			For ni := 1  to oMdlZAD:Length()
				oMdlZAD:GoLine(ni)
				oMdlZAD:SetValue('ZAD_CODIGO',ZAB->ZAB_CODIGO)
				oMdlZAD:SetValue('ZAD_VERSAO',cxVer)
			Next ni
			
			oMdlZAD:GoLine(1)
        ElseIf MV_PAR01 == 5// Alteração Caroline Cazela 03/12/18 - Contabilidade
        	oMdlZA0 := oModel:GetModel('ZA0DETAIL')
			oMdlZAD := oModel:GetModel('ZADDETAIL')
			
			For ni := 1 to oMdlZA0:Length()
				oMdlZA0:GoLine(ni)
				oMdlZA0:SetValue('ZA0_CODIGO',ZAB->ZAB_CODIGO)
				oMdlZA0:SetValue('ZA0_VERSAO',cxVer)
				For nl := 1  to oMdlZAD:Length()
					oMdlZAD:GoLine(nl)
					oMdlZAD:SetValue('ZAD_CODIGO',ZAB->ZAB_CODIGO)
					oMdlZAD:SetValue('ZAD_VERSAO',cxVer)
				Next nl
			Next ni
			
			oMdlZA0:GoLine(1)
			oMdlZAD:GoLine(1)
		EndIf
	EndIf
	
	FWRestRows( aSaveLines )
	
Return .T.

/*
=====================================================================================
Programa............: xMGF6Ver
Autor...............: Joni Lima
Data................: 29/12/2016
Descrição / Objetivo: Verifica a ultima versão e traz a nova
Doc. Origem.........: Contrato - GAP GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Retorna a proxima Versão
=====================================================================================
*/
User Function xMGF6Ver(cCod)
	
	Local aArea := GetArea()
	Local cNextAlias := GetNextAlias()
	Local cRet		:= ''
	
	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif
	
	BeginSql Alias cNextAlias
		
		SELECT MAX(ZAB_VERSAO) ZAB_VERSAO
		FROM %Table:ZAB% ZAB
		WHERE ZAB.%NotDel%
		AND ZAB.ZAB_FILIAL = %xFilial:ZAB%
		AND ZAB.ZAB_CODIGO = %Exp:cCod%
		AND ZAB.ZAB_HOMOLO = 'S'
		
	EndSql
	
	(cNextAlias)->(DbGoTop())
	
	cRet := (cNextAlias)->ZAB_VERSAO //SOMA1((cNextAlias)->ZAB_VERSAO)
	
	dbSelectArea(cNextAlias)
	dbClosearea()
	
	RestArea(aArea)
	
Return cRet

/*
=====================================================================================
Programa............: xMGC06PRCOD
Autor...............: Joni Lima
Data................: 28/12/2016
Descrição / Objetivo: Realiza o Gatilho do Campo ZAB_CODIGO
Doc. Origem.........: Contrato - GAP GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Preenche o modelo filho do modelo ZABMASTER com o Código.
=====================================================================================
*/
User Function xMGC06PRCOD(cCod)
	
	Local oModel 	:= FwModelActive()
	Local aSaveLines:=	FwSaveRows()
	Local oMdlZAC 	:= nil
	Local oMdlZAE	:= nil
	Local oMdlZAD	:= nil  
	Local oMdlZA0	:= nil
	Local ni		:= 1
	
	If MV_PAR01 == 1 //Tecnica
		
		oMdlZAC := oModel:GetModel('ZACDETAIL')
		
		For ni:=1 to oMdlZAC:Length()
			oMdlZAC:GoLine(ni)
			If oMdlZAC:GetValue('ZAC_CODIGO') <> cCod
				oMdlZAC:SetValue('ZAC_CODIGO',cCod)
			EndIf
		Next ni
		
		oMdlZAC:GoLine(1)
		
	ElseIf MV_PAR01 == 2 //Pedido
		
		oMdlZAD := oModel:GetModel('ZADDETAIL')
		
		For ni:=1 to oMdlZAD:Length()
			oMdlZAD:GoLine(ni)
			If oMdlZAD:GetValue('ZAD_CODIGO') <> cCod
				oMdlZAD:SetValue('ZAD_CODIGO',cCod)
			EndIf
		Next ni
		
		oMdlZAD:GoLine(1)
		
	ElseIf MV_PAR01 == 3 //Contas Pagar
		
		oMdlZAE := oModel:GetModel('ZAEDETAIL')
		
		For ni:=1 to oMdlZAE:Length()
			oMdlZAE:GoLine(ni)
			If oMdlZAE:GetValue('ZAE_CODIGO') <> cCod
				oMdlZAE:SetValue('ZAE_CODIGO',cCod)
			EndIf
		Next ni
		
		oMdlZAE:GoLine(1)

	ElseIf MV_PAR01 == 4 //SA
		
		oMdlZAD := oModel:GetModel('ZADDETAIL')
		
		For ni:=1 to oMdlZAD:Length()
			oMdlZAD:GoLine(ni)
			If oMdlZAD:GetValue('ZAD_CODIGO') <> cCod
				oMdlZAD:SetValue('ZAD_CODIGO',cCod)
			EndIf
		Next ni
		
		oMdlZAD:GoLine(1)
	ElseIf MV_PAR01 == 5 // Alteração Caroline Cazela 03/12/18 - Contabilidade
		
		oMdlZA0 := oModel:GetModel('ZA0DETAIL')
		
		For ni:=1 to oMdlZA0:Length()
			oMdlZA0:GoLine(ni)
			If oMdlZA0:GetValue('ZA0_CODIGO') <> cCod
				oMdlZA0:SetValue('ZA0_CODIGO',cCod)
			EndIf
		Next ni
		
		oMdlZA0:GoLine(1)
	EndIf
	
	FWRestRows( aSaveLines )
	
Return cCod

/*
=====================================================================================
Programa............: xMGC6NPCOD
Autor...............: Joni Lima
Data................: 28/12/2016
Descrição / Objetivo: Realiza o Gatilho do Campo ZAC_GRPPRD
Doc. Origem.........: Contrato - GAP GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Preenche o modelo Neto do modelo ZACDetail com o Grupo de Produto.
=====================================================================================
*/
User Function xMGC6NPCOD(cCod,cGrpProd)
	
	Local oModel 	:= FwModelActive()
	Local aSaveLines:=	FwSaveRows()
	Local oMdlZAD 	:= oModel:GetModel('ZADDETAIL')
	Local ni		:= 1
	
	If MV_PAR01 == 1 //Tecnica
		
		For ni:=1 to oMdlZAD:Length()
			oMdlZAD:GoLine(ni)
			If oMdlZAD:GetValue('ZAD_CODIGO') <> cCod .or. oMdlZAD:GetValue('ZAD_GRPPRD') <> cGrpProd
				oMdlZAD:SetValue('ZAD_CODIGO',cCod)
				oMdlZAD:SetValue('ZAD_GRPPRD',cGrpProd)
			EndIf
		Next ni
		
		oMdlZAD:GoLine(1)
		
	EndIf
	
	FWRestRows( aSaveLines )
	
Return cCod

/*
=====================================================================================
Programa............: xMGC6NatN
Autor...............: Joni Lima
Data................: 28/12/2016
Descrição / Objetivo: Realiza o Gatilho do Campo ZAE_NATURE
Doc. Origem.........: Contrato - GAP GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Preenche o modelo Neto do modelo ZAEDetail com a Natureza.
=====================================================================================
*/
User Function xMGC6NatN(cCod,cNaturez)
	
	Local oModel 	:= FwModelActive()
	Local aSaveLines:=	FwSaveRows()
	Local oMdlZAD 	:= oModel:GetModel('ZADDETAIL')
	Local ni		:= 1
	
	If MV_PAR01 == 3 //Contas a Pagar
		
		For ni:=1 to oMdlZAD:Length()
			oMdlZAD:GoLine(ni)
			If oMdlZAD:GetValue('ZAD_CODIGO') <> cCod .or. oMdlZAD:GetValue('ZAD_NATURE') <> cNaturez
				oMdlZAD:SetValue('ZAD_CODIGO',cCod)
				oMdlZAD:SetValue('ZAD_NATURE',cNaturez)
			EndIf
		Next ni
		
		oMdlZAD:GoLine(1)
		
	EndIf
	
	FWRestRows( aSaveLines )
	
Return cCod

/*
=====================================================================================
Programa............: xMGC6NPGP
Autor...............: Joni Lima
Data................: 28/12/2016
Descrição / Objetivo: Realiza o Gatilho do Campo ZAC_GRPPRD
Doc. Origem.........: Contrato - GAP GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Preenche o modelo Neto do modelo ZACDetail com a Grupo e Natureza.
=====================================================================================
*/
User Function xMGC6NPGP(cCod,cGrpProd)
	
	Local oModel 	:= FwModelActive()
	Local aSaveLines:=	FwSaveRows()
	Local oMdlZAD 	:= oModel:GetModel('ZADDETAIL')
	Local ni		:= 1
	
	If MV_PAR01 == 1 //Tecnica
		
		For ni:=1 to oMdlZAD:Length()
			oMdlZAD:GoLine(ni)
			If oMdlZAD:GetValue('ZAD_CODIGO') <> cCod .or. oMdlZAD:GetValue('ZAD_GRPPRD') <> cGrpProd
				oMdlZAD:SetValue('ZAD_CODIGO',cCod)
				oMdlZAD:SetValue('ZAD_GRPPRD',cGrpProd)
			EndIf
		Next ni
		
		oMdlZAD:GoLine(1)
		
	EndIf
	
	FWRestRows( aSaveLines )
	
Return cGrpProd

/*
=====================================================================================
Programa............: xMGC6EMPF
Autor...............: Joni Lima
Data................: 22/01/2019
Descrição / Objetivo: Realiza o Gatilho do Campo ZA0_EMPFIL
Doc. Origem.........: Contrato - GAP GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Preenche o modelo Neto do modelo ZA0Detail com a Filial
=====================================================================================
*/
User Function xMGC6EMPF(cCod,cEmpFil)
	
	Local oModel 	:= FwModelActive()
	Local aSaveLines:=	FwSaveRows()
	Local oMdlZAD 	:= oModel:GetModel('ZADDETAIL')
	Local ni		:= 1
	
	If MV_PAR01 == 5 //Contabil
		
		For ni:=1 to oMdlZAD:Length()
			oMdlZAD:GoLine(ni)
			If oMdlZAD:GetValue('ZAD_CODIGO') <> cCod .or. oMdlZAD:GetValue('ZAD_EMPFIL') <> cEmpFil
				oMdlZAD:SetValue('ZAD_CODIGO',cCod)
				oMdlZAD:SetValue('ZAD_EMPFIL',cEmpFil)
			EndIf
		Next ni
		
		oMdlZAD:GoLine(1)
		
	EndIf
	
	FWRestRows( aSaveLines )
	
Return cEmpFil

/*
=====================================================================================
Programa............: xMGC6CDUS
Autor...............: Joni Lima
Data................: 22/01/2019
Descrição / Objetivo: Realiza o Gatilho do Campo ZA0_CDUSER
Doc. Origem.........: Contrato - GAP GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Preenche o modelo Neto do modelo ZA0Detail com o Usuario.
=====================================================================================
*/
User Function xMGC6CDUS(cCod,cCdUser)
	
	Local oModel 	:= FwModelActive()
	Local aSaveLines:=	FwSaveRows()
	Local oMdlZAD 	:= oModel:GetModel('ZADDETAIL')
	Local ni		:= 1
	
	If MV_PAR01 == 5 //Contabil
		
		For ni:=1 to oMdlZAD:Length()
			oMdlZAD:GoLine(ni)
			If oMdlZAD:GetValue('ZAD_CODIGO') <> cCod .or. oMdlZAD:GetValue('ZAD_CDUSER') <> cCdUser
				oMdlZAD:SetValue('ZAD_CODIGO',cCod)
				oMdlZAD:SetValue('ZAD_CDUSER',cCdUser)
			EndIf
		Next ni
		
		oMdlZAD:GoLine(1)
		
	EndIf
	
	FWRestRows( aSaveLines )
	
Return cCdUser


/*
=====================================================================================
Programa............: xMGC6IniTP
Autor...............: Joni Lima
Data................: 28/12/2016
Descrição / Objetivo: Inicialização Padrão do TIPO de Grade
Doc. Origem.........: Contrato - GAP GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Verifica conforme o parametro o Valor para o Tipo
=====================================================================================
*/
User Function xMGC6IniTP()
	
	Local cRet := 'T'
	
	If MV_PAR01 == 1
		cRet := 'T'
	ElseIf MV_PAR01 == 2
		cRet := 'P'
	ElseIf MV_PAR01 == 3
		cRet := 'C'
	ElseIf MV_PAR01 == 4
		cRet := 'S'     
	ElseIf MV_PAR01 == 5 // Alteração Caroline Cazela 03/12/18 - Contabilidade
		cRet := 'L'
	EndIf
	
Return cRet

/*
=====================================================================================
Programa............: xMG6VlCod
Autor...............: Joni Lima
Data................: 28/12/2016
Descrição / Objetivo: Realiza a Validação do Código da Grade
Doc. Origem.........: Contrato - GAP GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Utilizado no campo ZAB_CODIGO
=====================================================================================
*/
User Function xMG6VlCod(oMdlZAB,cFld,xValue)
	
	Local aArea		:= GetArea()
	Local aAreaZAB	:= ZAB->(GetArea())
	Local lRet := .T.
	
	If !LCOPY
		dbSelectArea('ZAB')
		ZAB->(dbSetOrder(1))//ZAB_FILIAL+ZAB_CODIGO+ZAB_VERSAO
		
		If ZAB->(DbSeek(xFilial('ZAB') + xValue ))
			
			lRet := .F.
			oMdlZAB:GetModel():SetErrorMessage(oMdlZAB:GetId(),cFld,oMdlZAB:GetModel():GetId(),cFld,cFld,;
				"Já Existe esse Código (Tipo +  Centro de Custo)", "Para realizar manutenção no registro sera necessario realizar uma revisão da Grade" + oMdlZAB:GetValue('ZAB_TIPO') + xValue )
		EndIf
	EndIf
	RestArea(aAreaZAB)
	RestArea(aArea)
	
Return lRet

/*
=====================================================================================
Programa............: xMGC6Incl
Autor...............: Joni Lima
Data................: 28/12/2016
Descrição / Objetivo: Realizar a inclusão de uma Grade
Doc. Origem.........: Contrato - GAP GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Abre tela de inclusão
=====================================================================================
*/
User Function xMGC6Incl()
	
	Local cPerg := 'MGFCOM06'
	Local aButtons := {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,"Salvar"},{.T.,"Cancelar"},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil}}
	
	If Pergunte(cPerg,.T.)
		FWExecView('Inclusão Grade','MGFCOM06', MODEL_OPERATION_INSERT, , { || .T. }, , ,aButtons )
	EndIf
	
Return

/*
=====================================================================================
Programa............: xMGC6Alt
Autor...............: Joni Lima
Data................: 28/12/2016
Descrição / Objetivo: Realizar a Alteração da Grade
Doc. Origem.........: Contrato - GAP GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Abre tela de Alteração
=====================================================================================
*/
User Function xMGC6Alt()
	
	Local cPerg := 'MGFCOM06'
	Local aButtons := {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,"Salvar"},{.T.,"Cancelar"},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil}}
	Local cTp	   := ZAB->ZAB_TIPO
	Local nTp	   := 0
	
	If cTp == 'T'
		nTp := 1
	ElseIf cTp == 'P'
		nTp := 2
	ElseIf cTp == 'C'
		nTp := 3
	ElseIf cTp == 'S'
		nTp := 4 
	ElseIf cTp == 'L' // Alteração Caroline Cazela 03/12/18 - Contabilidade
		nTp := 5
	EndIf
	
	If ZAB->ZAB_HOMOLO <> 'S' .and. Empty(ZAB_VERSAO)
		
		Pergunte(cPerg,.F.)
		MV_PAR01 := nTp
		
		FWExecView('Alteração Grade','MGFCOM06', MODEL_OPERATION_UPDATE, , { || .T. }, , ,aButtons )
	Else
		Alert('Só é Permitida a alteração das Grades que não estão homologadas')
	EndIf
Return

/*
=====================================================================================
Programa............: xMGC6Exc
Autor...............: Joni Lima
Data................: 28/12/2016
Descrição / Objetivo: Realizar Exclusão da Grade
Doc. Origem.........: Contrato - GAP GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Abre tela de Exclusão
=====================================================================================
*/
User Function xMGC6Exc()
	
	Local cPerg := 'MGFCOM06'
	Local aButtons := {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,"Salvar"},{.T.,"Cancelar"},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil}}
	Local cTp	   := ZAB->ZAB_TIPO
	Local nTp	   := 0
	
	If cTp == 'T'
		nTp := 1
	ElseIf cTp == 'P'
		nTp := 2
	ElseIf cTp == 'C'
		nTp := 3
	ElseIf cTp == 'S'
		nTp := 4  
	ElseIf cTp == 'L'  // Alteração Caroline Cazela 03/12/18 - Contabilidade
		nTp := 5
	EndIf
	
	If ZAB->ZAB_HOMOLO <> 'S' .and. Empty(ZAB_VERSAO)
		Pergunte(cPerg,.F.)
		MV_PAR01 := nTp
		
		FWExecView('Exclusão Grade','MGFCOM06', MODEL_OPERATION_DELETE, , { || .T. }, , ,aButtons )
	Else
		Alert('Só é Possivel realizar a Exclusão de Grades que não estejam homologadas')
	EndIf
	
Return

/*
=====================================================================================
Programa............: xMGC6Vis
Autor...............: Joni Lima
Data................: 28/12/2016
Descrição / Objetivo: Realizar visualização da Grade
Doc. Origem.........: Contrato - GAP GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Abre tela de Visualização
=====================================================================================
*/
User Function xMGC6Vis()
	
	Local cPerg := 'MGFCOM06'
	Local aButtons := {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,"Salvar"},{.T.,"Cancelar"},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil}}
	Local cTp	   := ZAB->ZAB_TIPO
	Local nTp	   := 0
	
	If cTp == 'T'
		nTp := 1
	ElseIf cTp == 'P'
		nTp := 2
	ElseIf cTp == 'C'
		nTp := 3
	ElseIf cTp == 'S'
		nTp := 4 
	ElseIf cTp == 'L'  // Alteração Caroline Cazela 03/12/18 - Contabilidade
		nTp := 5
	EndIf
	
	Pergunte(cPerg,.F.)
	MV_PAR01 := nTp
	
	FWExecView('Visualização Grade','MGFCOM06', MODEL_OPERATION_VIEW, , { || .T. }, , ,aButtons )
	
Return

/*
=====================================================================================
Programa............: xMGC6Cop
Autor...............: Joni Lima
Data................: 28/12/2016
Descrição / Objetivo: Realizar Geração de uma nova versão para uma Grade
Doc. Origem.........: Contrato - GAP GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Gera uma nova versão da Grade
=====================================================================================
*/
User Function xMGC6Cop()
	
	Local aArea 	:= GetArea()
	Local aAreaZAB	:= ZAB->(GetArea())
	
	Local cPerg := 'MGFCOM06'
	Local aButtons := {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,"Salvar"},{.T.,"Cancelar"},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil}}
	Local cCod	   := ZAB->ZAB_CODIGO
	Local cTp	   := ZAB->ZAB_TIPO
	Local nTp	   := 0
	
	DbSelectArea('ZAB')
	ZAB->(dbSetOrder(1))//ZAB_FILIAL, ZAB_CODIGO, ZAB_VERSAO
	If ZAB->ZAB_HOMOLO == 'S'
		If !ZAB->(DbSeek(xFilial('ZAB') + cCod + '   '))
			
			RestArea(aAreaZAB)
			RestArea(aArea)
			
			If cTp == 'T'
				nTp := 1
			ElseIf cTp == 'P'
				nTp := 2
			ElseIf cTp == 'C'
				nTp := 3
			ElseIf cTp == 'S'
				nTp := 4
			ElseIf cTp == 'L'  // Alteração Caroline Cazela 03/12/18 - Contabilidade
	  			nTp := 5	
			EndIf
			
			Pergunte(cPerg,.F.)
			MV_PAR01 := nTp
			
			LCOPY := .T.
			CVERSAO := ''//U_xMGF6Ver(ZAB->ZAB_CODIGO)
			FWExecView('Copia da Grade','MGFCOM06', 9, , { || .T. }, , ,aButtons )
			
		Else
			Alert('Já existe uma grade em edição para esse código: ' + cCod)
		EndIf
	Else
		Alert('Só é possivel gerar uma nova versão de grade da ultima versão homologada')
	EndIf
	LCOPY := .F.
	
	RestArea(aAreaZAB)
	RestArea(aArea)
Return

/*
=====================================================================================
Programa............: xMGC6CopCC
Autor...............: Joni Lima
Data................: 28/12/2016
Descrição / Objetivo: Realizar a Copia Para um Novo Centro de Custo
Doc. Origem.........: Contrato - GAP GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Realiza a Copia
=====================================================================================
*/
User Function xMGC6CC()
	
	Local aArea 		:= GetArea()
	Local cNextAlias	:= GetNextAlias()
	
	
	Local aRet		:= {}
	Local aPergs	:= {}
	Local cCusIni	:= ZAB->ZAB_CC
	Local cCusFim	:= ZAB->ZAB_CC

	Local nCnt := 0
	Local lContinua := .T.	

	If !Empty( ZAB->ZAB_VERSAO )
		Help( ,, 'Grade - Cópia',, 'Selecione Grade Em Edição para geração de cópias', 1, 0 )
		RestArea( aArea )
		Return
	EndIf

	/*
	1 - MsGet
	[2] : Descrição
	[3] : String contendo o inicializador do campo
	[4] : String contendo a Picture do campo
	[5] : String contendo a validação
	[6] : Consulta F3
	[7] : String contendo a validação When
	[8] : Tamanho do MsGet
	[9] : Flag .T./.F. Parâmetro Obrigatório ?
	*/
	
	aAdd( aPergs ,{1,"Centro de Custo De  : ",cCusIni,"@!",'.T.',"CTT",'.T.',50,.T.})
	aAdd( aPergs ,{1,"Centro de Custo Até : ",cCusFim,"@!",'.T.',"CTT",'.T.',50,.T.})
	
	If !ParamBox(aPergs ,"Grade - Parametros de Cópia",aRet)
		Help( ,, 'Grade - Cópia',, 'Processamento Cancelado', 1, 0 )
		RestArea( aArea )
		Return
	EndIf
	
	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif
	
	BeginSql Alias cNextAlias
		
		SELECT ZAB.R_E_C_N_O_ ZAB_RECNO, ZAB_CODIGO
		FROM %Table:ZAB% ZAB
		WHERE ZAB.%NotDel%
			AND ZAB.ZAB_FILIAL = %xFilial:ZAB%
			AND ZAB.ZAB_TIPO = %Exp:ZAB->ZAB_TIPO%
			AND ZAB.ZAB_HOMOLO = 'N'
			AND ZAB.ZAB_VERSAO = '   '
			AND ZAB_CC BETWEEN %Exp:aRet[1]% AND %Exp:aRet[2]%
			AND ZAB_CC <> %Exp:ZAB->ZAB_CC%
		ORDER BY 1
		
	EndSql
	
	(cNextAlias)->(DbGoTop())
	
	If !Empty( (cNextAlias)->ZAB_RECNO )
	
		DbEval( {|| nCnt++ })              // Conta quantos sao os registros retornados pelo Select.
			
		If MsgYesNo("Existe(m) "+AllTrim(Str(nCnt))+" grade(s) em edição no intervalo selecionado"+CRLF+;
					"Deseja sobrepor as informações existentes?","Cópia de Grade")
			
			(cNextAlias)->(DbGoTop())
			
			While (cNextAlias)->(!EOF())
				ZAB->( dbGoTo( (cNextAlias)->ZAB_RECNO ) )
				
				Begin Transaction
				
					Processa({|| U_xMGC6Del()},"Aguarde...","Excluindo Registros...",.F.)
				
					RecLock("ZAB",.F.)
					//MsgStop("ZAB Del:"+Str(ZAB->( Recno() )))
					dbDelete()
					ZAB->( msUnlock() )
				
				End Transaction
				
				(cNextAlias)->(dbSkip())
			EndDo

			
			
		Else
			lContinua	:= .F.
		EndIf
		
		

	EndIf
	
	dbSelectArea(cNextAlias)
	dbCloseArea()
	
	RestArea(aArea)
	
	If lContinua
	
		//MsgStop( "xMGC6Rep" )
		Processa({|| U_xMGC6Rep(aRet)},"Aguarde...","Replicando Registros...",.F.)
	
	EndIf
	
Return

User Function xMGC6Rep(aRet)

	Local aArea			:= GetArea()
	Local aAreaZAB		:= ZAB->( GetArea() )
	Local cAliasZAB		:= GetNextAlias()
	Local cAliasAux		:= GetNextAlias()
	Local nCount		:= 0
	Local nI			:= 0 
	
	BeginSql Alias cAliasZAB
		
		SELECT %Exp:ZAB->ZAB_TIPO% || CTT_CUSTO AS ZAB_CODIGO, CTT_CUSTO AS ZAB_CC, ZAB.*
		FROM %Table:ZAB% ZAB
		INNER JOIN %Table:CTT% CTT ON CTT.D_E_L_E_T_ = ' '
			AND CTT.CTT_FILIAL = %xFilial:CTT%
			AND CTT_CUSTO BETWEEN %Exp:aRet[1]% AND %Exp:aRet[2]%
			AND CTT_CUSTO <> %Exp:ZAB->ZAB_CC%
			AND CTT_CLASSE = '2'
			AND CTT_BLOQ = '2'
		WHERE ZAB.%NotDel%
			AND ZAB.ZAB_FILIAL = %xFilial:ZAB%
			AND ZAB.ZAB_TIPO = %Exp:ZAB->ZAB_TIPO%
			AND ZAB.ZAB_HOMOLO = 'N'
			AND ZAB.ZAB_CODIGO = %Exp:ZAB->ZAB_CODIGO%
			AND ZAB.ZAB_VERSAO = '   '
			AND ZAB_CC = %Exp:ZAB->ZAB_CC%
		ORDER BY 1
		
	EndSql
	
	aQuery := GetLastQuery()
		
	MemoWrit( "C:\TEMP\"+FunName()+"-ZAB-"+DTOS(Date())+StrTran(Time(),":")+".SQL" , aQuery[2] )


	(cAliasZAB)->(DbGoTop())
	
	ProcRegua( (cAliasZAB)->(LastRec()) )
	
	While (cAliasZAB)->(!EOF())
	
		Incproc()
		
		If (cAliasZAB)->ZAB_TIPO == "T" // ZAC

			nCount	:= ZAC->( fCount() )
			
			BeginSql Alias cAliasAux
		
				SELECT %Exp:(cAliasZAB)->ZAB_CODIGO% AS ZAC_CODIGO, ZAC.*
				FROM %Table:ZAC% ZAC
				WHERE ZAC.%NotDel%
					AND ZAC.ZAC_FILIAL = %xFilial:ZAC%
					AND ZAC.ZAC_CODIGO = %Exp:ZAB->ZAB_CODIGO%
					AND ZAC.ZAC_VERSAO = '   '
				ORDER BY 1
		
			EndSql
	
			aQuery := GetLastQuery()
		
			MemoWrit( "C:\TEMP\"+FunName()+"-ZAC-"+DTOS(Date())+StrTran(Time(),":")+".SQL" , aQuery[2] )

			(cAliasAux)->(DbGoTop())
			
			While (cAliasAux)->(!EOF())
			
				RecLock("ZAC",.T.)
				
				For nI := 0 To nCount
				
					ZAC->( FieldPut( nI , (cAliasAux)->( &(ZAC->(FieldName(nI))) ) ) )
				
				Next
				
				ZAC->( msUnlock() )
			
				(cAliasAux)->( dbSkip() )
			EndDo
			
			dbSelectArea(cAliasAux)
			dbCloseArea()
		
		ElseIf  (cAliasZAB)->ZAB_TIPO == "C" // ZAE
		
			nCount	:= ZAE->( fCount() )
			
			BeginSql Alias cAliasAux
		
				SELECT %Exp:(cAliasZAB)->ZAB_CODIGO% AS ZAE_CODIGO, ZAE.*
				FROM %Table:ZAE% ZAE
				WHERE ZAE.%NotDel%
					AND ZAE.ZAE_FILIAL = %xFilial:ZAE%
					AND ZAE.ZAE_CODIGO = %Exp:ZAB->ZAB_CODIGO%
					AND ZAE.ZAE_VERSAO = '   '
				ORDER BY 1
		
			EndSql
	
			aQuery := GetLastQuery()
		
			MemoWrit( "C:\TEMP\"+FunName()+"-ZAE-"+DTOS(Date())+StrTran(Time(),":")+".SQL" , aQuery[2] )

			(cAliasAux)->(DbGoTop())
			
			While (cAliasAux)->(!EOF())
			
				RecLock("ZAE",.T.)
				
				For nI := 0 To nCount
				
					ZAE->( FieldPut( nI , (cAliasAux)->( &(ZAE->(FieldName(nI))) ) ) )
				
				Next
				
				ZAE->( msUnlock() )
			
				(cAliasAux)->( dbSkip() )
			EndDo
			
			dbSelectArea(cAliasAux)
			dbCloseArea()
		
		EndIf


		nCount	:= ZAD->( fCount() )
			
		BeginSql Alias cAliasAux
		
			SELECT %Exp:(cAliasZAB)->ZAB_CODIGO% AS ZAD_CODIGO, ZAD.*
			FROM %Table:ZAD% ZAD
			WHERE ZAD.%NotDel%
				AND ZAD.ZAD_FILIAL = %xFilial:ZAD%
				AND ZAD.ZAD_CODIGO = %Exp:ZAB->ZAB_CODIGO%
				AND ZAD.ZAD_VERSAO = '   '
			ORDER BY 1
		
		EndSql
	
		aQuery := GetLastQuery()
		
		MemoWrit( "C:\TEMP\"+FunName()+"-ZAD-"+DTOS(Date())+StrTran(Time(),":")+".SQL" , aQuery[2] )

		(cAliasAux)->(DbGoTop())
			
		While (cAliasAux)->(!EOF())
			
			RecLock("ZAD",.T.)
				
			For nI := 0 To nCount
				
				ZAD->( FieldPut( nI , (cAliasAux)->( &(ZAD->(FieldName(nI))) ) ) )
				
			Next
				
			ZAD->( msUnlock() )
			
			(cAliasAux)->( dbSkip() )
		EndDo
			
		dbSelectArea(cAliasAux)
		dbCloseArea()

		nCount	:= ZAB->( fCount() )
			
		RecLock("ZAB",.T.)
				
		For nI := 0 To nCount
				
			ZAB->( FieldPut( nI , (cAliasZAB)->( &(ZAB->(FieldName(nI))) ) ) )
				
		Next
		
		ZAB->( msUnlock() )
		
		(cAliasZAB)->( dbSkip() )
			
	EndDo
	
	dbSelectArea(cAliasZAB)
	dbCloseArea()
	
	RestArea(aAreaZAB)
	RestArea(aArea)
	
Return

User Function xMGC6Del()

Local aArea	:= GetArea()
Local aAreaZAC	:= ZAC->( GetArea() )
Local aAreaZAD	:= ZAD->( GetArea() )
Local aAreaZAE	:= ZAD->( GetArea() ) 
Local aAreaZA0	:= ZA0->( GetArea() )

If ZAB->ZAB_TIPO == "T"
	dbSelectArea("ZAC")
	dbSetOrder(1)
	ZAC->( dbSeek( xFilial("ZAC")+ZAB->(ZAB_CODIGO+ZAB_VERSAO) ) )
	While !ZAC->( eof() ) .And. ZAC->(ZAC_FILIAL+ZAC_CODIGO+ZAC_VERSAO) == xFilial("ZAC")+ZAB->(ZAB_CODIGO+ZAB_VERSAO)

		RecLock("ZAC",.F.)
		//MsgStop("ZAC Del:"+Str(ZAC->( Recno() )))
		dbDelete()
		ZAC->( msUnlock() )
	
		ZAC->( dbSkip() )
	EndDo 
ElseIf ZAB->ZAB_TIPO == "C"
	dbSelectArea("ZAE")
	dbSetOrder(1)
	ZAE->( dbSeek( xFilial("ZAE")+ZAB->(ZAB_CODIGO+ZAB_VERSAO) ) )
	While !ZAE->( eof() ) .And. ZAE->(ZAE_FILIAL+ZAE_CODIGO+ZAE_VERSAO) == xFilial("ZAE")+ZAB->(ZAB_CODIGO+ZAB_VERSAO)

		RecLock("ZAE",.F.)
		//MsgStop("ZAE Del:"+Str(ZAE->( Recno() )))
		dbDelete()
		ZAE->( msUnlock() )
	
		ZAE->( dbSkip() )
	EndDo  
ElseIF ZAB->ZAB_TIPO == "L"
	dbSelectArea("ZA0")
	dbSetOrder(1)
	ZA0->( dbSeek( xFilial("ZA0")+ZAB->(ZAB_CODIGO+ZAB_VERSAO) ) )
	While !ZA0->( eof() ) .And. ZA0->(ZA0_FILIAL+ZA0_CODIGO+ZA0_VERSAO) == xFilial("ZA0")+ZAB->(ZAB_CODIGO+ZAB_VERSAO)

		RecLock("ZA0",.F.)
		//MsgStop("ZAC Del:"+Str(ZAC->( Recno() )))
		dbDelete()
		ZA0->( msUnlock() )
	
		ZA0->( dbSkip() )
	EndDo 
EndIf

dbSelectArea("ZAD")
dbSetOrder(1)
ZAD->( dbSeek( xFilial("ZAD")+ZAB->(ZAB_CODIGO+ZAB_VERSAO) ) )
While !ZAD->( eof() ) .And. ZAD->(ZAD_FILIAL+ZAD_CODIGO+ZAD_VERSAO) == xFilial("ZAD")+ZAB->(ZAB_CODIGO+ZAB_VERSAO)

	RecLock("ZAD",.F.)
	//MsgStop("ZAD Del:"+Str(ZAD->( Recno() )))
	dbDelete()
	ZAD->( msUnlock() )
	
	ZAD->( dbSkip() )
EndDo 

RestArea( aAreaZA0 )
RestArea( aAreaZAE )
RestArea( aAreaZAD )
RestArea( aAreaZAC )   
RestArea( aArea )

Return

/*
=====================================================================================
Programa............: xMGC6CopCC
Autor...............: Joni Lima
Data................: 28/12/2016
Descrição / Objetivo: Realizar a Copia Para um Novo Centro de Custo
Doc. Origem.........: Contrato - GAP GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Realiza a Copia
=====================================================================================
*/
User Function _xMGC6CC()
	
	Local cPerg := 'MGFCOM06'
	Local aButtons := {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,"Salvar"},{.T.,"Cancelar"},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil}}
	Local cTp	   := ZAB->ZAB_TIPO
	Local nTp	   := 0
	
	If cTp == 'T'
		nTp := 1
	ElseIf cTp == 'P'
		nTp := 2
	ElseIf cTp == 'C'
		nTp := 3
	ElseIf cTp == 'S'
		nTp := 4 
	ElseIf cTp == 'L'   // Alteração Caroline Cazela 03/12/18 - Contabilidade
		nTp := 5
	EndIf
	
	Pergunte(cPerg,.F.)
	MV_PAR01 := nTp
	
	LCOPYCC := .T.
	FWExecView('Copia da Grade','MGFCOM06', 9, , { || .T. }, , ,aButtons )
	LCOPYCC := .F.
	
Return

/*
=====================================================================================
Programa............: xAtZABAnt
Autor...............: Joni Lima
Data................: 11/04/2016
Descrição / Objetivo: Atualiza os dados da tabela ZAB antes de homologar
=====================================================================================
*/
Static Function xAtZABAnt(cCod,cVersao)
		
	Local aArea 	:= GetArea()
	Local aAreaZAB	:= ZAB->(GetArea())
	
	
	dbSelectArea('ZAB')
	ZAB->(dbSetOrder(1))//ZAB_FILIAL, ZAB_CODIGO, ZAB_VERSAO
	
	If ZAB->(dbSeek(xFilial('ZAB') + cCod + cVersao ))
		
		RecLock('ZAB')
		ZAB->ZAB_DTFIM  := dDataBase
		ZAB->ZAB_HOMOLO := 'N'
		ZAB->(MsUnLock())
		
	EndIf
	
	RestArea(aAreaZAB)
	RestArea(aArea)
	
Return

User Function xM06Homl()
	
	Local aArea := GetArea()
	Local cNextAlias := GetNextAlias()
	
	Local aRet		:= {}
	Local aPergs	:= {}
	Local cCusIni	:= ZAB->ZAB_CC
	Local cCusFim	:= ZAB->ZAB_CC
	
	/*
	1 - MsGet
	[2] : Descrição
	[3] : String contendo o inicializador do campo
	[4] : String contendo a Picture do campo
	[5] : String contendo a validação
	[6] : Consulta F3
	[7] : String contendo a validação When
	[8] : Tamanho do MsGet
	[9] : Flag .T./.F. Parâmetro Obrigatório ?
	*/
	
	aAdd( aPergs ,{1,"Centro de Custo De  : ",cCusIni,"@!",'.T.',"CTT",'.T.',50,.T.})
	aAdd( aPergs ,{1,"Centro de Custo Até : ",cCusFim,"@!",'.T.',"CTT",'.T.',50,.T.})
	
	If !ParamBox(aPergs ,"Grade - Parametros de Homologação",aRet)
		Help( ,, 'Grade - Homologação',, 'Processamento Cancelado', 1, 0 )
		RestArea( aArea )
		Return
	EndIf
	
	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif
	
	BeginSql Alias cNextAlias
		
		SELECT ZAB.R_E_C_N_O_ ZAB_RECNO
		FROM %Table:ZAB% ZAB
		WHERE ZAB.%NotDel%
			AND ZAB.ZAB_FILIAL = %xFilial:ZAB%
			AND ZAB.ZAB_TIPO = %Exp:ZAB->ZAB_TIPO%
			AND ZAB.ZAB_HOMOLO = 'N'
			AND ZAB.ZAB_VERSAO = '   '
			AND ZAB_CC BETWEEN %Exp:aRet[1]% AND %Exp:aRet[2]%
		ORDER BY 1
		
	EndSql
	
	(cNextAlias)->(DbGoTop())
	
	If !Empty( (cNextAlias)->ZAB_RECNO )
		
		While (cNextAlias)->(!EOF())
			ZAB->( dbGoTo( (cNextAlias)->ZAB_RECNO ) )
			Processa({|| U_xHomologar()},"Aguarde...","Processando Grade...",.F.)
			(cNextAlias)->(dbSkip())
		EndDo
		
	Else
		Help( ,, 'Grade - Homologação',, 'Não existem registros para os parâmetros informados!', 1, 0 )
	EndIf
	
	dbSelectArea(cNextAlias)
	dbCloseArea()
	
	RestArea(aArea)
	
Return

/*
=====================================================================================
Programa............: xHomologar
Autor...............: Joni Lima
Data................: 11/04/2016
Descrição / Objetivo: Realiza a Homologação da grade
=====================================================================================
*/
User Function xHomologar()
	
	Local aArea		:= GetArea()
	// Local aAreaSM0	:= SM0->(GetArea())
	// Local aAreaZAC	:= ZAC->(GetArea())
	// Local aAreaZAD	:= ZAD->(GetArea())
	
	Local cTp	   	:= ZAB->ZAB_TIPO
	Local nTp	   	:= 0
	
	Local cxUser  	:= ''
	Local cCod	  	:= ''
	Local cCodZAB	:= ''
	Local cVersao	:= ''
	Local cOldFil 	:= cFilAnt
	Local cPerg 	:= 'MGFCOM06'
	Local cChav		:= ''
	
	Local cAliQry	:= ''//xMntQuery(ZAB->ZAB_CODIGO,ZAB->ZAB_VERSAO,cTp)
	
	Local aDados  	:= {}
	Local aFLsSAL 	:= {}
	Local aSAL	  	:= {}
	Local aDBL	  	:= {}
	
	Local ni
	Local nx
	
	local nTotReg	:= 0
	
	If IsInCallStack('U_xM06Homl')
		ProcRegua(0)
		//IncProc()
	EndIf
	
	
	cCodZAB := ZAB->ZAB_CODIGO
	
	cVersao	:= U_xMGF6Ver(cCodZAB)
	cNewVer := IIF(Empty(cVersao),"001",Soma1(cVersao))
	
	xAtVers(cCodZAB,ZAB->ZAB_VERSAO,cNewVer)
	
	ZAB->(dbSeek(xFilial('ZAB') + cCodZAB + cNewVer ))
	
	If ZAB->ZAB_VERSAO <> '001'
		xAtZABAnt(ZAB->ZAB_CODIGO,cVersao)
	EndIf
	
	RecLock('ZAB',.F.)
	ZAB->ZAB_HOMOLO := 'S'
	ZAB->ZAB_DTINIC := dDataBase
	ZAB->ZAB_HORHML := SUBSTR(Time(),1,5)
	ZAB->(MsUnlock())
	
	RestArea(aArea)
	
Return

Static Function xAtVers(cCod,cVersao,cNewVers)
	
	Local aArea 	:= GetArea()
	Local aAreaZAB	:= ZAB->(GetArea())
	Local cTp	   	:= ''
	Local nTp		:= 0
	
	Local cPerg 	:= 'MGFCOM06'
	
	Local ni
	Local nc
	
	Local oModCOM6 := nil
	Local oMdlZAB := Nil
	Local oMdlZAC := Nil
	Local oMdlZAD := Nil
	Local oMdlZAE := Nil
	
	dbSelectArea('ZAB')
	ZAB->(dbSetOrder(1))//ZAB_FILIAL+ZAB_CODIGO+ZAB_VERSAO
	
	If ZAB->(DbSeek(xFilial('ZAB') + cCod + cVersao))
		
		cTp	   	:= ZAB->ZAB_TIPO
		
		If cTp == 'T'
			nTp := 1
		ElseIf cTp == 'P'
			nTp := 2
		ElseIf cTp == 'C'
			nTp := 3
		ElseIf cTp == 'S'
			nTp := 4   
		ElseIf cTp == 'L'  // Alteração Caroline Cazela 03/12/18 - Contabilidade
			nTp := 5
		EndIf
		
		Pergunte(cPerg,.F.)
		MV_PAR01 := nTp
		
		oModCOM6 := FwLoadModel('MGFCOM06')
		
		oModCOM6:SetOperation( MODEL_OPERATION_UPDATE )
		
		If oModCOM6:Activate()
			
			If cTp == 'T'
				oMdlZAB := oModCOM6:GetModel('ZABMASTER')
				oMdlZAC := oModCOM6:GetModel('ZACDETAIL')
				oMdlZAD := oModCOM6:GetModel('ZADDETAIL')
				
				oMdlZAB:LoadValue('ZAB_VERSAO',cNewVers)
				
				If Empty(oMdlZAB:GetValue('ZAB_DTINIC'))
					oMdlZAB:LoadValue('ZAB_DTINIC',dDataBase)
				EndIf
				
				For ni:=1 to oMdlZAC:Length()
					oMdlZAC:GoLine(ni)
					oMdlZAC:LoadValue('ZAC_VERSAO',cNewVers)
					For nc:=1 to oMdlZAD:Length()
						oMdlZAD:GoLine(nc)
						oMdlZAD:LoadValue('ZAD_VERSAO',cNewVers)
					next nc
				next ni
				
				If oModCOM6:VldData()
					oModCOM6:CommitData()
					oModCOM6:DeActivate()
					oModCOM6:Destroy()
				Else
					JurShowErro(oModCOM6:GetModel():GetErrormessage())
				EndIf
				
			ElseIf cTp == 'P'
				oMdlZAB := oModCOM6:GetModel('ZABMASTER')
				oMdlZAD := oModCOM6:GetModel('ZADDETAIL')
				
				oMdlZAB:LoadValue('ZAB_VERSAO',cNewVers)
				
				If Empty(oMdlZAB:GetValue('ZAB_DTINIC'))
					oMdlZAB:LoadValue('ZAB_DTINIC',dDataBase)
				EndIf
				
				For nc:=1 to oMdlZAD:Length()
					oMdlZAD:GoLine(nc)
					oMdlZAD:LoadValue('ZAD_VERSAO',cNewVers)
				next nc
				
				If oModCOM6:VldData()
					oModCOM6:CommitData()
					oModCOM6:DeActivate()
					oModCOM6:Destroy()
				Else
					JurShowErro(oModCOM6:GetModel():GetErrormessage())
				EndIf
				
			ElseIf cTp == 'C'
				oMdlZAB := oModCOM6:GetModel('ZABMASTER')
				oMdlZAE := oModCOM6:GetModel('ZAEDETAIL')
				oMdlZAD := oModCOM6:GetModel('ZADDETAIL')
				
				oMdlZAB:LoadValue('ZAB_VERSAO',cNewVers)
				
				If Empty(oMdlZAB:GetValue('ZAB_DTINIC'))
					oMdlZAB:LoadValue('ZAB_DTINIC',dDataBase)
				EndIf
				
				For ni:=1 to oMdlZAE:Length()
					oMdlZAE:GoLine(ni)
					oMdlZAE:LoadValue('ZAE_VERSAO',cNewVers)
					For nc:=1 to oMdlZAD:Length()
						oMdlZAD:GoLine(nc)
						oMdlZAD:LoadValue('ZAD_VERSAO',cNewVers)
					next nc
				next ni
				
				If oModCOM6:VldData()
					oModCOM6:CommitData()
					oModCOM6:DeActivate()
					oModCOM6:Destroy()
				Else
					JurShowErro(oModCOM6:GetModel():GetErrormessage())
				EndIf
			
			ElseIf cTp == 'S'
				oMdlZAB := oModCOM6:GetModel('ZABMASTER')
				oMdlZAD := oModCOM6:GetModel('ZADDETAIL')
				
				oMdlZAB:LoadValue('ZAB_VERSAO',cNewVers)
				
				If Empty(oMdlZAB:GetValue('ZAB_DTINIC'))
					oMdlZAB:LoadValue('ZAB_DTINIC',dDataBase)
				EndIf
				
				For nc:=1 to oMdlZAD:Length()
					oMdlZAD:GoLine(nc)
					oMdlZAD:LoadValue('ZAD_VERSAO',cNewVers)
				next nc
				
				If oModCOM6:VldData()
					oModCOM6:CommitData()
					oModCOM6:DeActivate()
					oModCOM6:Destroy()
				Else
					JurShowErro(oModCOM6:GetModel():GetErrormessage())
				EndIf
		   	ElseIf	cTp == 'L'
				oMdlZAB := oModCOM6:GetModel('ZABMASTER')
				oMdlZA0 := oModCOM6:GetModel('ZA0DETAIL')
				oMdlZAD := oModCOM6:GetModel('ZADDETAIL')
				
				oMdlZAB:LoadValue('ZAB_VERSAO',cNewVers)
				
				If Empty(oMdlZAB:GetValue('ZAB_DTINIC'))
					oMdlZAB:LoadValue('ZAB_DTINIC',dDataBase)
				EndIf
				
				For ni:=1 to oMdlZA0:Length()
					oMdlZA0:GoLine(ni)
					oMdlZA0:LoadValue('ZA0_VERSAO',cNewVers)
					For nc:=1 to oMdlZAD:Length()
						oMdlZAD:GoLine(nc)
						oMdlZAD:LoadValue('ZAD_VERSAO',cNewVers)
					next nc
				next ni
				
				If oModCOM6:VldData()
					oModCOM6:CommitData()
					oModCOM6:DeActivate()
					oModCOM6:Destroy()
				Else
					JurShowErro(oModCOM6:GetModel():GetErrormessage())
				EndIf	
			EndIf
			
		EndIf
	EndIf
	
	RestArea(aAreaZAB)
	RestArea(aArea)
	
Return

Static Function xEncUser(cxFil,cNivel)
	
	Local aArea := GetArea()
	Local cNextAlias := GetNextAlias()
	Local cRet		:= ''
	
	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif
	
	BeginSql Alias cNextAlias
		
		SELECT
		ZA2_CODAPD
		FROM
		%Table:ZA2% ZA2
		WHERE
		ZA2.ZA2_FILIAL = %xFilial:ZA2% AND
		ZA2.%NotDel% AND
		ZA2.ZA2_EMPFIL = %Exp:cxFil% AND
		ZA2.ZA2_NIVEL = %Exp:cNivel%
		
	EndSql
	
	(cNextAlias)->(DbGoTop())
	
	While (cNextAlias)->(!EOF())
		cRet := (cNextAlias)->ZA2_CODAPD
		(cNextAlias)->(dbSkip())
	EndDo
	
	RestArea(aArea)
	
	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif
	
Return cRet

Static Function xMntQuery(cCodigo,cVersao,cTipo)
	
	Local aArea 		:= GetArea()
	Local cNextAlias 	:= GetNextAlias()
	
	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif
	
	If cTipo == 'T'
		
		BeginSql Alias cNextAlias
			
			SELECT
			ZAB.ZAB_CODIGO,
			ZAB.ZAB_VERSAO,
			ZAB.ZAB_CC,
			ZAB.ZAB_DESCRI,
			ZAC.ZAC_GRPPRD,
			ZAD.ZAD_NIVEL,
			ZAD.ZAD_SEQ,
			ZAD.ZAD_TPAPR,
			ZAD.ZAD_VALINI,
			ZAD.ZAD_VALFIM
			FROM
			%Table:ZAB% ZAB
			INNER JOIN %Table:ZAC% ZAC
			ON ZAC_CODIGO = ZAB_CODIGO
			AND ZAC_VERSAO = ZAB_VERSAO
			INNER JOIN %Table:ZAD% ZAD
			ON ZAD_CODIGO = ZAC_CODIGO
			AND ZAD_VERSAO = ZAC_VERSAO
			AND ZAD_GRPPRD = ZAC_GRPPRD
			WHERE
			ZAB.ZAB_FILIAL = %xFilial:ZAB% AND
			ZAC.ZAC_FILIAL = ZAB.ZAB_FILIAL AND
			ZAD.ZAD_FILIAL = ZAC.ZAC_FILIAL AND
			ZAB.%NotDel% AND
			ZAC.%NotDel% AND
			ZAD.%NotDel% AND
			ZAB.ZAB_CODIGO = %Exp:cCodigo% AND
			ZAB.ZAB_VERSAO = %Exp:cVersao%
			
			ORDER BY ZAB_CODIGO,ZAB_VERSAO,ZAB_CC,ZAC_GRPPRD
			
		EndSql
	ElseIf cTipo == 'P'
		
		BeginSql Alias cNextAlias
			
			SELECT
			ZAB.ZAB_CODIGO,
			ZAB.ZAB_VERSAO,
			ZAB.ZAB_CC,
			ZAB.ZAB_DESCRI,
			ZAD.ZAD_NIVEL,
			ZAD.ZAD_SEQ,
			ZAD.ZAD_TPAPR,
			ZAD.ZAD_VALINI,
			ZAD.ZAD_VALFIM
			FROM
			%Table:ZAB% ZAB
			INNER JOIN %Table:ZAD% ZAD
			ON ZAD_CODIGO = ZAB_CODIGO
			AND ZAD_VERSAO = ZAB_VERSAO
			WHERE
			ZAB.ZAB_FILIAL = %xFilial:ZAB% AND
			ZAD.ZAD_FILIAL = ZAB.ZAB_FILIAL AND
			ZAB.%NotDel% AND
			ZAD.%NotDel% AND
			ZAB.ZAB_CODIGO = %Exp:cCodigo% AND
			ZAB.ZAB_VERSAO = %Exp:cVersao%
			
			ORDER BY ZAB_CODIGO,ZAB_VERSAO,ZAB_CC
			
		EndSql
		
		
		
		
	ElseIf cTipo == 'S'
		
		BeginSql Alias cNextAlias
			
			SELECT
			ZAB.ZAB_CODIGO,
			ZAB.ZAB_VERSAO,
			ZAB.ZAB_CC,
			ZAB.ZAB_DESCRI,
			ZAD.ZAD_NIVEL,
			ZAD.ZAD_SEQ,
			ZAD.ZAD_TPAPR,
			ZAD.ZAD_VALINI,
			ZAD.ZAD_VALFIM
			FROM
			%Table:ZAB% ZAB
			INNER JOIN %Table:ZAD% ZAD
			ON ZAD_CODIGO = ZAB_CODIGO
			AND ZAD_VERSAO = ZAB_VERSAO
			WHERE
			ZAB.ZAB_FILIAL = %xFilial:ZAB% AND
			ZAD.ZAD_FILIAL = ZAB.ZAB_FILIAL AND
			ZAB.%NotDel% AND
			ZAD.%NotDel% AND
			ZAB.ZAB_CODIGO = %Exp:cCodigo% AND
			ZAB.ZAB_VERSAO = %Exp:cVersao%
			
			ORDER BY ZAB_CODIGO,ZAB_VERSAO,ZAB_CC
			
		EndSql
		
		
		
		
	ElseIf cTipo == 'C'
		
		BeginSql Alias cNextAlias
			
			SELECT
			ZAB.ZAB_CODIGO,
			ZAB.ZAB_VERSAO,
			ZAB.ZAB_CC,
			ZAB.ZAB_DESCRI,
			ZAE.ZAE_NATURE,
			ZAD.ZAD_NIVEL,
			ZAD.ZAD_SEQ,
			ZAD.ZAD_TPAPR,
			ZAD.ZAD_VALINI,
			ZAD.ZAD_VALFIM
			FROM
			%Table:ZAB% ZAB
			INNER JOIN %Table:ZAE% ZAE
			ON ZAE_CODIGO = ZAB_CODIGO
			AND ZAE_VERSAO = ZAB_VERSAO
			INNER JOIN %Table:ZAD% ZAD
			ON ZAD_CODIGO = ZAE_CODIGO
			AND ZAD_VERSAO = ZAE_VERSAO
			AND ZAD_NATURE = ZAE_NATURE
			WHERE
			ZAB.ZAB_FILIAL = %xFilial:ZAB% AND
			ZAE.ZAE_FILIAL = ZAB.ZAB_FILIAL AND
			ZAD.ZAD_FILIAL = ZAE.ZAE_FILIAL AND
			ZAB.%NotDel% AND
			ZAE.%NotDel% AND
			ZAD.%NotDel% AND
			ZAB.ZAB_CODIGO = %Exp:cCodigo% AND
			ZAB.ZAB_VERSAO = %Exp:cVersao%
			
			ORDER BY ZAB_CODIGO,ZAB_VERSAO,ZAB_CC,ZAE_NATURE
			
		EndSql
		
	EndIf
	
	(cNextAlias)->(DbGoTop())
	
	RestArea(aArea)
	
Return cNextAlias

Static Function xMGC6GRVGA(lInsert,lPedCom,lSolic,lConPag,aDados)
	
	Local aArea 	:= GetArea()
	Local aAreaSAL	:= SAL->(GetArea())
	Local aAreaDBL	:= DBL->(GetArea())
	
	Local cCod		:= ''
	Local cOldFil	:= cFilAnt
	Local cDesc		:= ''
	
	Local oMdl114 	:= FWLoadModel('MATA114')
	Local oMdlSAL 	:= nil
	Local oMdlItSAL := nil
	Local oMdlDBL 	:= nil
	local ni
	local nx
	
	Default lInsert := .T.
	Default lSolic	:= .F.
	Default lPedCom := .F.
	Default lConPag	:= .F.
	
	If lInsert
		oMdl114:SetOperation( MODEL_OPERATION_INSERT )
	Else
		oMdl114:SetOperation( MODEL_OPERATION_UPDATE )
	EndIf
	
	If oMdl114:Activate()
		
		cFilAnt := aDados[1][1][1]
		
		oMdlSAL 	:= oMdl114:GetModel('ModelSAL')
		oMdlItSAL 	:= oMdl114:GetModel('DetailSAL')
		oMdlDBL 	:= oMdl114:GetModel('DetailDBL')
		
		cDesc := SubStr(aDados[1][1][2],1,TamSx3('AL_DESC')[1])
		
		//Código
		//oMdlSAL:SetValue('AL_FILIAL',aDados[1][1][1])
		//oMdlSAL:SetValue('AL_COD',aDados[1][1][2])
		oMdlSAL:SetValue('AL_DESC',cDesc)
		
		//Setar quais liberação
		oMdlSAL:SetValue('AL_DOCAE',.F.)
		oMdlSAL:SetValue('AL_DOCCO',.F.)
		oMdlSAL:SetValue('AL_DOCCP',.F.)
		oMdlSAL:SetValue('AL_DOCMD',.F.)
		oMdlSAL:SetValue('AL_DOCNF',.F.)
		oMdlSAL:SetValue('AL_DOCPC',lPedCom)//Pedido de Compra
		oMdlSAL:SetValue('AL_DOCSA',.F.)
		oMdlSAL:SetValue('AL_DOCSC',lSolic)//Solicitação de Compra
		oMdlSAL:SetValue('AL_DOCST',.F.)
		oMdlSAL:SetValue('AL_DOCIP',.F.)
		oMdlSAL:SetValue('AL_DOCCT',.F.)
		oMdlSAL:SetValue('AL_DOCGA',.F.)
		
		//Grade de Aprovação
		For ni := 1 to Len(aDados[1])
			
			If ni > 1
				oMdlItSAL:AddLine()
			EndIf
			
			oMdlItSAL:SetValue('AL_ITEM',STRZERO(ni,2))
			oMdlItSAL:SetValue('AL_APROV',aDados[1][ni][3])
			//oMdlItSAL:LoadValue('AL_NOME',MGFcRegUs(aDados[1][ni][3],'NOME'))
			oMdlItSAL:SetValue('AL_NIVEL',aDados[1][ni][4])
			oMdlItSAL:SetValue('AL_TPLIBER',aDados[1][ni][5])
			oMdlItSAL:SetValue('AL_ZCODGRD',aDados[1][ni][6])
			oMdlItSAL:SetValue('AL_ZVERSAO',aDados[1][ni][7])
			oMdlItSAL:SetValue('AL_ZVALINI',aDados[1][ni][8])
			oMdlItSAL:SetValue('AL_ZVALFIM',aDados[1][ni][9])
			oMdlItSAL:SetValue('AL_ZDOCFIN',lConPag)
			oMdlItSAL:SetValue('AL_PERFIL','999999')
		Next ni
		
		//Centro de Custo
		oMdlDBL:SetValue('DBL_ITEM'	 ,STRZERO(1,2))
		oMdlDBL:SetValue('DBL_CC'	 ,aDados[2][1][1])
		
		If lSolic .and. ValType(aDados[2][1][2]) == 'C'
			oMdlDBL:SetValue('DBL_ZGRUPO',aDados[2][1][2])
		EndIf
		
		If lConPag .and. ValType(aDados[2][1][2]) == 'C'
			oMdlDBL:SetValue('DBL_ZNATUR',aDados[2][1][2])
		EndIf
		
		cCod := oMdlSAL:GetValue('AL_COD')
		
		If oMdl114:VldData()
			FwFormCommit(oMdl114)
			oMdl114:DeActivate()
			oMdl114:Destroy()
		Else
			JurShowErro(oMdl114:GetModel():GetErrormessage())
		EndIf
	EndIf
	
	cFilAnt := cOldFil
	
	RestArea(aAreaDBL)
	RestArea(aAreaSAL)
	RestArea(aArea)
	
Return cCod

Static Function xInsSAL(lInsert,lPedCom,lSolic,lConPag,aDados)
	
	local ni
	local nx
	Local cInsSAL := ""
	Local cInsDBL := ""
	
	Local cCod	:= GetSxeNum("SAL","AL_COD")
	Local cDesc := SubStr(aDados[1][1][2],1,TamSx3('AL_DESC')[1])
	
	Default lInsert := .T.
	Default lSolic	:= .F.
	Default lPedCom := .F.
	Default lConPag	:= .F.
	
	//Grade de Aprovação
	For ni := 1 to Len(aDados[1])
		
		cInsSAL := "INSERT INTO " + RetSQLName("SAL")
		cInsSAL += " (AL_FILIAL "
		cInsSAL += ",AL_COD    "
		cInsSAL += ",AL_DESC   "
		cInsSAL += ",AL_ITEM   "
		cInsSAL += ",AL_APROV  "
		cInsSAL += ",AL_USER   "
		cInsSAL += ",AL_NIVEL  "
		cInsSAL += ",AL_LIBAPR "
		cInsSAL += ",AL_AUTOLIM "
		cInsSAL += ",AL_TPLIBER "
		cInsSAL += ",AL_DOCAE  "
		cInsSAL += ",AL_DOCCO  "
		cInsSAL += ",AL_DOCCP  "
		cInsSAL += ",AL_DOCMD  "
		cInsSAL += ",AL_DOCNF  "
		cInsSAL += ",AL_DOCPC  "
		cInsSAL += ",AL_DOCSA  "
		cInsSAL += ",AL_DOCSC  "
		cInsSAL += ",AL_DOCST  "
		cInsSAL += ",AL_DOCIP  "
		cInsSAL += ",AL_DOCCT  "
		cInsSAL += ",AL_DOCGA  "
		cInsSAL += ",AL_PERFIL "
		cInsSAL += ",AL_ZDOCFIN "
		cInsSAL += ",AL_ZCODGRD "
		cInsSAL += ",AL_ZVERSAO "
		cInsSAL += ",AL_ZVALINI "
		cInsSAL += ",AL_ZVALFIM "
		cInsSAL += ",R_E_C_N_O_) "
		
		cInsSAL += "Values(
		cInsSAL += " '" + Alltrim(aDados[1][1][1]) + "' "   		//AL_FILIAL
		cInsSAL += ",'" + cCod + "' " 			  		//AL_COD
		cInsSAL += ",'" + cDesc + "' " 			  		//AL_DESC
		cInsSAL += ",'" + STRZERO(ni,2) + "' " 	  		//AL_ITEM
		cInsSAL += ",'" + aDados[1][ni][3] + "' " 		//AL_APROV
		//cInsSAL += ",'" + POSICIONE("SAK",1,aDados[1][1][1] + aDados[1][ni][3], "AK_USER" ) + "' " //AL_USER
		//cInsSAL += ",'" + GetAdvFVal("SAK",SubStr(aDados[1][1][1],1,TamSx3('AL_FILIAL')[1]) + SubStr(aDados[1][ni][3],1,TamSx3('AL_APROV')[1]), "AK_USER",1) + "' "
		cInsSAL += ",'" + GetAdvFVal("SAK", "AK_USER", SubStr(aDados[1][1][1],1,TamSx3('AL_FILIAL')[1]) + SubStr(aDados[1][ni][3],1,TamSx3('AL_APROV')[1]), 1) + "' "
		
		cInsSAL += ",'" + aDados[1][ni][4] + "' " 		//AL_NIVEL
		cInsSAL += ",'" + 'A' + "' " 			  		//AL_LIBAPR
		cInsSAL += ",'" + 'S' + "' " 			  		//AL_AUTOLIM
		cInsSAL += ",'" + aDados[1][ni][5] + "' " 		//AL_TPLIBER
		cInsSAL += ",'" + "F" + "' " 			  		//AL_DOCAE
		cInsSAL += ",'" + "F" + "' " 			  		//AL_DOCCO
		cInsSAL += ",'" + "F" + "' " 			  		//AL_DOCCP
		cInsSAL += ",'" + "F" + "' " 			  		//AL_DOCMD
		cInsSAL += ",'" + "F" + "' " 			  		//AL_DOCNF
		cInsSAL += ",'" + IIF(lPedCom,"T","F") + "' " 	//AL_DOCPC ****
		cInsSAL += ",'" + "F" + "' " 			  		//AL_DOCSA
		cInsSAL += ",'" + IIF(lSolic,"T","F") + "' " 	//AL_DOCSC ****
		cInsSAL += ",'" + "F" + "' " 					//AL_DOCST
		cInsSAL += ",'" + "F" + "' " 					//AL_DOCIP
		cInsSAL += ",'" + "F" + "' " 					//AL_DOCCT
		cInsSAL += ",'" + "F" + "' " 					//AL_DOCGA
		cInsSAL += ",'" + "999999" + "' " 				//AL_PERFIL
		cInsSAL += ",'" + IIF(lConPag,"T","F") + "' " 	//AL_ZDOCFIN
		cInsSAL += ",'" + aDados[1][ni][6] + "' " 		//AL_ZCODGRD
		cInsSAL += ",'" + aDados[1][ni][7] + "' " 		//AL_ZVERSAO
		cInsSAL += ", " + str(aDados[1][ni][8]) + " " 		//AL_ZVALINI
		cInsSAL += ", " + str(aDados[1][ni][9]) + " " 		//AL_ZVALFIM
		cInsSAL += ", " + "( SELECT 1+MAX(R_E_C_N_O_) FROM " + RetSQLName("SAL") + " )"  //R_E_C_N_O_
		cInsSAL += ")"
		
		TcSQLExec(cInsSAL)
		
	Next ni
	
	cInsDBL := "INSERT INTO " + RetSQLName("DBL")
	cInsDBL += "("
	cInsDBL += " DBL_FILIAL   "
	cInsDBL += " ,DBL_GRUPO   "
	cInsDBL += " ,DBL_ITEM    "
	cInsDBL += " ,DBL_CC      "
	cInsDBL += " ,DBL_ZGRUPO  "
	cInsDBL += " ,DBL_ZNATUR  "
	cInsDBL += " ,R_E_C_N_O_  "
	cInsDBL +=")"
	
	cInsDBL += "Values(
	cInsDBL += " '"  + Alltrim(aDados[1][1][1]) + "' " //DBL_FILIAL
	cInsDBL += ", '" + cCod + "' "//DBL_GRUPO
	cInsDBL += ", '" + STRZERO(1,2) + "' "//DBL_ITEM
	cInsDBL += ", '" + aDados[2][1][1] + "' "//DBL_CC
	cInsDBL += ", '" + IIF(lSolic .and. ValType(aDados[2][1][2]) == 'C',aDados[2][1][2]," ") + "' "//DBL_ZGRUPO
	cInsDBL += ", '" + IIF(lConPag .and. ValType(aDados[2][1][2]) == 'C',aDados[2][1][2]," ") + "' "//DBL_ZNATUR
	cInsDBL += ", " + "( SELECT 1+MAX(R_E_C_N_O_) FROM " + RetSQLName("DBL") + " )"  //R_E_C_N_O_
	cInsDBL += ")"
	
	TcSQLExec(cInsDBL)
	
return cCod

Static Function xVerDHL()
	
	Local aArea := GetArea()
	
	dbSelectArea('DHL')
	DHL->(DbSetOrder(1))//DHL_FILIAL+DHL_COD
	
	If !(DHL->(dbSeek(xFilial('DHL') + '999999')))
		RecLock('DHL',.T.)
		DHL->DHL_FILIAL := xFilial('DHL')
		DHL->DHL_COD := '999999'
		DHL->DHL_DESCRI := 'COD PDR'
		DHL->DHL_LIMMAX := 99999999999.99
		DHL->(MsUnlock())
	EndIf
	
	RestArea(aArea)
	
Return

Static Function MGFcRegUs(cCodUsu,cField)
	
	Local cRet := ''
	Local nPos := 0
	Local nCampo := 2
	
	If ALLTRIM(UPPER(cField)) == 'NOME'
		nCampo := 4
	EndIf
	
	If ValType(__aXAllUser) == 'A'
		nPos := aScan(__aXAllUser,{|x| Alltrim(x[2]) == Alltrim(cCodUsu)})
		If nPos > 0
			cRet := Alltrim(__aXAllUser[nPos][nCampo])
		EndIf
	EndIf
	
Return cRet

User Function XMC6NMUS(cCodUser)

	local cRet		:= ""
	local cQryUsr	:= ""

	cQryUsr := "SELECT USR_NOME"
	cQryUsr += " FROM SYS_USR USR"
	cQryUsr += " WHERE"
	cQryUsr += " 		USR.USR_ID	=	'" + cCodUser + "'"
	cQryUsr += " 	AND	USR.D_E_L_E_T_	<>	'*'"

	TcQuery cQryUsr New Alias "QRYUSR4"

	if !QRYUSR4->(EOF())
		cRet := allTrim(QRYUSR4->USR_NOME)
	endif

	QRYUSR4->(DBCloseArea())
	
return cRet


User Function xMGC6VldPo()
	
	Local lRet := .T.
	
	//oModel:GetModel('DetailSAL'):SetUniqueLine( {'AL_ITEM' ,'AL_APROV' } )
	
Return lRet

/*
=====================================================================================
Programa............: xMG6VlUs
Autor...............: Joni Lima
Data................: 29/01/2019
Descrição / Objetivo: Realiza a Validação do Usuario da grade
Obs.................: Utilizado no campo ZA0_EMPFIL e ZA0_CDUSER
=====================================================================================
*/
User Function xMG6VlUs(oMdlZCU,cFld,xValue,nLin)
	
	Local aArea		:= GetArea()
	Local aAreaZCU	:= ZCU->(GetArea())
	Local lRet := .T.
	
	Local cxEmpFil	:= ""
	Local cxUser	:= ""
	
	If !LCOPY
		If cFld == "ZA0_EMPFIL"
			cxEmpFil := xValue 
			cxUser	 := oMdlZCU:GetValue("ZA0_CDUSER")
		ElseIf cFld == "ZA0_CDUSER"
			cxEmpFil := oMdlZCU:GetValue("ZA0_EMPFIL") 
			cxUser	 := xValue		
		EndIf
	
		If !Empty(cxEmpFil) .and. !Empty(cxUser) 
			dbSelectArea('ZCU')
			ZCU->(dbSetOrder(1))//ZCU_FILIAL+ZCU_CDUSER
			If !(ZCU->(dbSeek(cxEmpFil + cxUser)))
				lRet := .F.
				oMdlZCU:GetModel():SetErrorMessage(oMdlZCU:GetId(),cFld,oMdlZCU:GetModel():GetId(),cFld,cFld,;
					"Não Existe cadastro de Limite para esse usuario nessa filial", "Favor realizar o cadastro do limite para esse usuario nessa filial")
			EndIf
		EndIf
	EndIf
	
	RestArea(aAreaZCU)
	RestArea(aArea)
	
Return lRet

/*
=====================================================================================
Programa............: xMG6ExUs
Autor...............: Joni Lima
Data................: 30/01/2019
Descrição / Objetivo: Verifica se Existe Grade cadastrada para o usuario na Filial
Obs.................: Utilizado nas validações de Inclusão de contabilizações txt e automaticas(Manuais)
=====================================================================================
*/
User Function xMG6ExUs()

	Local lRet 			:= .F.
	Local cNextAlias	:= GetNextAlias()
	Local cxEmpFil		:= cFilAnt
	Local cxUser		:= Alltrim(RetCodUsr())
	
	Local cUsDireto		:= SuperGetMV("MGF_CTB25A",.F.,"000000")
	Local cEmpDireto	:= SuperGetMV("MGF_CTB25B",.F.,"02/") //Grupo de empresas que não passaram pela grade de aprovação.

	
	If !(cxUser $ cUsDireto .OR. cEmpAnt $ cEmpDireto)  //Verifica se usuario ou Grupo de empresa passa direto
	
		If Select(cNextAlias) > 0
			(cNextAlias)->(DbClosearea())
		Endif
		
		BeginSql Alias cNextAlias	
		
			SELECT DISTINCT
				ZA0.ZA0_CODIGO,
				ZA0.ZA0_VERSAO
			FROM %Table:ZA0% ZA0
			INNER JOIN %Table:ZAB% ZAB
				 ON ZAB.ZAB_CODIGO = ZA0.ZA0_CODIGO
				AND ZAB.ZAB_VERSAO = ZA0.ZA0_VERSAO
				AND ZAB.%NotDel%
			WHERE
			  ZAB.ZAB_HOMOLO = 'S' AND
			  ZA0.%NotDel% AND
			  ZA0.ZA0_EMPFIL = %Exp:cxEmpFil% AND
		      ZA0.ZA0_CDUSER =  %Exp:cxUser% AND
			  ZA0.ZA0_FILIAL = %xFilial:ZA0%
			ORDER BY ZA0_CODIGO
		
		EndSql
	
		(cNextAlias)->(DbGoTop())
		
		While (cNextAlias)->(!EOF())
			lRet := .T.
			(cNextAlias)->(dbSkip())
		EndDo
		
		If !lRet
			MSGALERT( 'O Seu usuario não está cadatrado em Grade de aprovação para essa Filial, para realizar esse processo favor cadastrar uma Grade para essa filial', 'Grade de Usuario não cadastrada' )
		EndIf
	Else
		lRet := .T.
	EndIf
	
return lRet

