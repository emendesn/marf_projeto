#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'


/*
=====================================================================================
Programa............: MGFCTB32
Autor...............: Flávio Dentello
Data................: 25/07/2017
Descrição / Objetivo: Regras de integração
Doc. Origem.........: MIT044 GAP CTB32
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Tela de Cadastro de regras
=====================================================================================
*/

User Function MGFCTB32() 

	Local oMBrowse := nil
	Local aAux := {}
	oMBrowse:= FWmBrowse():New()

	oMBrowse:SetAlias("ZD2")
	oMBrowse:SetDescription("Cadastro de Regras de Integração")
	
	oMBrowse:Activate()
	
return oMBrowse

Static Function MenuDef()
	
	Local	aRotina	:= {}
	
	ADD OPTION aRotina TITLE "Pesquisar"  	  ACTION "PesqBrw"          OPERATION 1                      ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 	  ACTION "VIEWDEF.MGFCTB32" OPERATION MODEL_OPERATION_VIEW   ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"    	  ACTION "VIEWDEF.MGFCTB32" OPERATION MODEL_OPERATION_INSERT ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"    	  ACTION "VIEWDEF.MGFCTB32" OPERATION MODEL_OPERATION_UPDATE ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"    	  ACTION "VIEWDEF.MGFCTB32" OPERATION MODEL_OPERATION_DELETE ACCESS 0
	
Return aRotina
 

Static Function ModelDef()

Local oStruZD2 := FWFormStruct( 1, 'ZD2', /*bAvalCampo*/,/*lViewUsado*/ )
Local oStructSB1 := FWFormStruct(1,"SB1")
Local oModel

oModel := MPFormModel():New('XMGFCTB32', /*bPreValidacao*/, /*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )

	
oModel:AddFields( 'ZD2MASTER', /*cOwner*/, oStruZD2, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

oStruZD2:SetProperty('ZD2_TES' , MODEL_FIELD_WHEN, { ||IIF(empty( oModel:Getmodel("ZD2MASTER"):getValue( "ZD2_TPOP" ) ) , .T., .F. ) } )

oStruZD2:setProperty("ZD2_PRODUT",MODEL_FIELD_VALID,{||U_GFEPROD()})
oStruZD2:setProperty("ZD2_TPDOCF",MODEL_FIELD_VALID,{||U_TPDOCF() })
oStruZD2:setProperty("ZD2_GRUPO" ,MODEL_FIELD_VALID,{||U_GRUPO()  })
oStruZD2:setProperty("ZD2_CFOP"  ,MODEL_FIELD_VALID,{||U_CFOP()   })
oStruZD2:setProperty("ZD2_TPPED" ,MODEL_FIELD_VALID,{||U_TPPED()  })
oStruZD2:setProperty("ZD2_GRPTRB",MODEL_FIELD_VALID,{||U_GRPTRB() })
oStruZD2:setProperty("ZD2_TPOCO" ,MODEL_FIELD_VALID,{||U_MOTOCO() })

oModel:SetDescription( 'Regras de Integração' )

//oModel:SetPrimaryKey({"ZD2_FILIAL","ZD2_TPDOC","ZD2_CFOP", "ZD2_GRUPO", "ZD2_PRODUT","ZD2_TPDOCF","ZD2_TPCLI","ZD2_TPPED","ZD2_TPOP"})
oModel:SetPrimaryKey({"ZD2_FILIAL","ZD2_TPDOC","ZD2_PRIORI"})

oModel:GetModel( 'ZD2MASTER' ):SetDescription( 'Regras de Integração' )

Return oModel

//-------------------------------------------------------------------
Static Function ViewDef()
// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
Local oModel   := FWLoadModel( 'MGFCTB32' )

Local oStruZD2 := FWFormStruct( 2, 'ZD2' )

Local oView
Local cCampos := {}


	oStruZD2:AddGroup( 'GRP01', '                                      ', '', 1 )
	oStruZD2:AddGroup( 'GRP02', 'Dados a serem utilizados na integração', '', 2 )

	oStruZD2:SetProperty( 'ZD2_PRIORI', MVC_VIEW_GROUP_NUMBER, 'GRP01' )
	oStruZD2:SetProperty( 'ZD2_DESCR' , MVC_VIEW_GROUP_NUMBER, 'GRP01' )
	oStruZD2:SetProperty( 'ZD2_TPDOC' , MVC_VIEW_GROUP_NUMBER, 'GRP01' )
	oStruZD2:SetProperty( 'ZD2_CFOP'  , MVC_VIEW_GROUP_NUMBER, 'GRP01' )
	oStruZD2:SetProperty( 'ZD2_GRUPO' , MVC_VIEW_GROUP_NUMBER, 'GRP01' )
	oStruZD2:SetProperty( 'ZD2_PRODUT', MVC_VIEW_GROUP_NUMBER, 'GRP01' )
	oStruZD2:SetProperty( 'ZD2_TPDOCF', MVC_VIEW_GROUP_NUMBER, 'GRP01' )
	oStruZD2:SetProperty( 'ZD2_TPCLI' , MVC_VIEW_GROUP_NUMBER, 'GRP01' )
	oStruZD2:SetProperty( 'ZD2_TPPED' , MVC_VIEW_GROUP_NUMBER, 'GRP01' )
	oStruZD2:SetProperty( 'ZD2_TPOP'  , MVC_VIEW_GROUP_NUMBER, 'GRP01' )
	oStruZD2:SetProperty( 'ZD2_GRPTRB', MVC_VIEW_GROUP_NUMBER, 'GRP01' )
	oStruZD2:SetProperty( 'ZD2_TPOCO' , MVC_VIEW_GROUP_NUMBER, 'GRP01' )
	
	
	oStruZD2:SetProperty( 'ZD2_TES'   , MVC_VIEW_GROUP_NUMBER, 'GRP02' )
	oStruZD2:SetProperty( 'ZD2_CONDPG', MVC_VIEW_GROUP_NUMBER, 'GRP02' )
	oStruZD2:SetProperty( 'ZD2_NTFIM' , MVC_VIEW_GROUP_NUMBER, 'GRP02' )
	oStruZD2:SetProperty( 'ZD2_PROD'  , MVC_VIEW_GROUP_NUMBER, 'GRP02' )
	oStruZD2:SetProperty( 'ZD2_CC'    , MVC_VIEW_GROUP_NUMBER, 'GRP02' )
	oStruZD2:SetProperty( 'ZD2_ITEMC' , MVC_VIEW_GROUP_NUMBER, 'GRP02' )
	oStruZD2:SetProperty( 'ZD2_CLASS' , MVC_VIEW_GROUP_NUMBER, 'GRP02' )
	oStruZD2:SetProperty( 'ZD2_CONTA' , MVC_VIEW_GROUP_NUMBER, 'GRP02' )	



oView := FWFormView():New()

oView:SetModel( oModel )

oView:AddField( 'VIEW_ZD2', oStruZD2, 'ZD2MASTER' )

oView:CreateHorizontalBox( 'TELA' , 100 )

oView:SetOwnerView( 'VIEW_ZD2', 'TELA' )

Return oView


/// Retorna expressão do produto
User Function GFEPROD()

	Local oMdlZD2    := FWModelActive()
	Local cExpres   := ""
	Local aProd := {}
	
DbSelectArea('SB1')	

AADD (aProd, "B1_COD")
	cExpres := BuildExpr('SB1',,,.T.,,,aProd) 
	cExpres := Strtran(cExpres,' ','')
	cExpres := If("''" $ cExpres,Strtran(cExpres,"''","' '"),cExpres)
	If Len(cExpres) > TamSX3("ZD2_PRODUT")[1]
		Help( ,, 'HELP',, "O tamanho da expressão (" + cValToChar(Len(cExpres)) + ") é maior do que o sistema comporta (" + cValTochar(TamSX3("ZD2_PRODUT")[1]) + ")", 1, 0,)
		Return cRet 
	EndIf
			
	oMdlZD2:LoadValue("ZD2MASTER","ZD2_PRODUT",cExpres)
	
Return .T.

/// Retorna expressão do tipo de documento de frete
User Function TPDOCF()

Local oMdlZD2    := FWModelActive()
Local cExpres   := ""
Local aDoc		:= {}

DbSelectArea('GVT')	

AADD (aDoc, "GVT_CDESP")
	cExpres := BuildExpr('GVT',,,.T.,,,aDoc) 
	cExpres := Strtran(cExpres,' ','')
	cExpres := If("''" $ cExpres,Strtran(cExpres,"''","' '"),cExpres)
	If Len(cExpres) > TamSX3("ZD2_TPDOCF")[1]
		Help( ,, 'HELP',, "O tamanho da expressão (" + cValToChar(Len(cExpres)) + ") é maior do que o sistema comporta (" + cValTochar(TamSX3("ZD2_TPDOCF")[1]) + ")", 1, 0,)
		Return cRet 
	EndIf
			
	oMdlZD2:LoadValue("ZD2MASTER","ZD2_TPDOCF",cExpres)
	
Return .T.

/// Retorna expressão do Grupo de produto
User Function GRUPO()

Local oMdlZD2   := FWModelActive()
Local cExpres   := ""
Local aGrup		:= {} 
	
DbSelectArea('SB1')
	
AADD (aGrup, "B1_GRUPO")
	cExpres := BuildExpr('SB1',,,.T.,,,aGrup)  
	cExpres := Strtran(cExpres,' ','')
	cExpres := If("''" $ cExpres,Strtran(cExpres,"''","' '"),cExpres)
	If Len(cExpres) > TamSX3("ZD2_GRUPO")[1]
		Help( ,, 'HELP',, "O tamanho da expressão (" + cValToChar(Len(cExpres)) + ") é maior do que o sistema comporta (" + cValTochar(TamSX3("ZD2_GRUPO")[1]) + ")", 1, 0,)
		Return cRet 
	EndIf
			
	oMdlZD2:LoadValue("ZD2MASTER","ZD2_GRUPO",cExpres)
	
Return .T.

//Função que retorna expressão para CFOP
User Function CFOP()

Local oMdlZD2    := FWModelActive()
Local cExpres   := ""
Local aCFOP := {}

dBselectArea('SX5')

AADD (aCFOP, "X5_CHAVE")	
	cExpres := BuildExpr('SX5',,"X5_TABELA = '13'",.T.,,,aCFOP)  

	If Len(cExpres) > TamSX3("ZD2_CFOP")[1]
		Help( ,, 'HELP',, "O tamanho da expressão (" + cValToChar(Len(cExpres)) + ") é maior do que o sistema comporta (" + cValTochar(TamSX3("ZD2_CFOP")[1]) + ")", 1, 0,)
		Return cRet 
	EndIf
			
	oMdlZD2:LoadValue("ZD2MASTER","ZD2_CFOP",cExpres)
	
Return .T.


/// Retorna expressão do Tipo de pedido
User Function TPPED()

Local oMdlZD2   := FWModelActive()
Local cExpres   := ""
Local aTpped	:= {} 
	
DbSelectArea('SZJ')
	
AADD (aTpped, "ZJ_COD")
	cExpres := BuildExpr('SZJ',,,.T.,,,aTpped)  
	cExpres := Strtran(cExpres,' ','')
	cExpres := If("''" $ cExpres,Strtran(cExpres,"''","' '"),cExpres)
	If Len(cExpres) > TamSX3("ZD2_TPPED")[1]
		Help( ,, 'HELP',, "O tamanho da expressão (" + cValToChar(Len(cExpres)) + ") é maior do que o sistema comporta (" + cValTochar(TamSX3("ZD2_GRUPO")[1]) + ")", 1, 0,)
		Return cRet 
	EndIf
			
	oMdlZD2:LoadValue("ZD2MASTER","ZD2_TPPED",cExpres)
	
Return .T.


/// Retorna expressão do Grupo Tributário
User Function GRPTRB()

Local oMdlZD2   := FWModelActive()
Local cExpres   := ""
Local aGRPTRB	:= {} 
	
DbSelectArea('SX5')
	
AADD (aGRPTRB, "X5_CHAVE")
	cExpres := BuildExpr('SX5',,"X5_TABELA = '21'",.T.,,,aGRPTRB)   

	If Len(cExpres) > TamSX3("ZD2_GRPTRB")[1]
		Help( ,, 'HELP',, "O tamanho da expressão (" + cValToChar(Len(cExpres)) + ") é maior do que o sistema comporta (" + cValTochar(TamSX3("ZD2_GRPTRB")[1]) + ")", 1, 0,)
		Return cRet 
	EndIf
			
	oMdlZD2:LoadValue("ZD2MASTER","ZD2_GRPTRB",cExpres)
	
Return .T.


/// Retorna expressão do Motivo Ocorrência
User Function MOTOCO()

Local oMdlZD2   := FWModelActive()
Local cExpres   := ""
Local aMOTOCO	:= {} 
	
DbSelectArea('GWD')
	
AADD (aMOTOCO, "GU6_CDMOT")
	cExpres := BuildExpr('GU6',,,.T.,,,aMOTOCO)   
	cExpres := Strtran(cExpres,' ','')
	cExpres := If("''" $ cExpres,Strtran(cExpres,"''","' '"),cExpres)
	If Len(cExpres) > TamSX3("ZD2_TPOCO")[1]
		Help( ,, 'HELP',, "O tamanho da expressão (" + cValToChar(Len(cExpres)) + ") é maior do que o sistema comporta (" + cValTochar(TamSX3("ZD2_TPOCO")[1]) + ")", 1, 0,)
		Return cRet 
	EndIf
			
	oMdlZD2:LoadValue("ZD2MASTER","ZD2_TPOCO",cExpres)
	
Return .T.
