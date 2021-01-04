#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE 'FWMVCDEF.CH'

/*
=====================================================================================
Programa............: MGFEEC25
Autor...............: Joni Lima
Data................: 02/05/2017
Descricao / Objetivo: Browse EXP
Doc. Origem.........: Banco de Horas
Solicitante.........: Cliente
Uso.................: 
Obs.................: Tela manutencao Estufa
=====================================================================================
*/
user function MGFEEC25()
	
	Local oMBrowse := nil
	
	oMBrowse:= FWmBrowse():New()
	oMBrowse:SetAlias("ZBM")
	oMBrowse:SetDescription('Planta / Local Estufagem')	

	oMBrowse:Activate()

return

/*
=====================================================================================
Programa............: MenuDef
Autor...............: Joni Lima
Data................: 02/05/2017
Descricao / Objetivo: MenuDef Browse
=====================================================================================
*/
Static function MenuDef()
	
	Local	aRotina	:= {}

	ADD OPTION aRotina TITLE "Pesquisar"    ACTION "PesqBrw"          OPERATION 1                      ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar"   ACTION "VIEWDEF.MGFEEC25" OPERATION MODEL_OPERATION_VIEW   ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"    	ACTION "VIEWDEF.MGFEEC25" OPERATION MODEL_OPERATION_INSERT ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"      ACTION "VIEWDEF.MGFEEC25" OPERATION MODEL_OPERATION_UPDATE ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"      ACTION "VIEWDEF.MGFEEC25" OPERATION MODEL_OPERATION_DELETE ACCESS 0

return(aRotina)

/*
=====================================================================================
Programa............: ModelDef
Autor...............: Joni Lima
Data................: 02/05/2017
Descricao / Objetivo: Modelo de Dados
=====================================================================================
*/
Static function ModelDef()

	Local oStruZBM := FWFormStruct( 1, 'ZBM')
	Local oModel := nil
	
	// Cria o objeto do Modelo de Dados
	oModel := MPFormModel():New('XMGFEEC25', /*bPreValidacao*/, /*bPosValidacao*/, /*bCommit*/, /*bCancel*/)
	
	// Adiciona ao modelo uma estrutura de formulario de edicao por campo
	oModel:AddFields('ZBMMASTER', /*cOwner*/, oStruZBM, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/)
	
	// Adiciona a descricao do Componente do Modelo de Dados
	oModel:GetModel( 'ZBMMASTER' ):SetDescription( 'Local Estufagem' )

	//Adiciona chave Primaria
	oModel:SetPrimaryKey({"ZBM_FILIAL","ZBM_CODIGO"})
	
return oModel

/*
=====================================================================================
Programa............: ViewDef
Autor...............: Joni Lima
Data................: 02/05/2017
Descricao / Objetivo: ViewDef Montagem 
=====================================================================================
*/
Static function ViewDef()
	
	Local oModel 	:= FwLoadModel('MGFEEC25')
	Local oView 	:= nil
	Local oStrZBM 	:= FWFormStruct( 2, "ZBM" )
	
	oView := FWFormView():New()
	oView:SetModel(oModel)
	
	oView:AddField( 'VIEW_ZBM' , oStrZBM, 'ZBMMASTER' )

	oView:CreateHorizontalBox( 'TELA' , 100 )

	oView:SetOwnerView( 'VIEW_ZBM', 'TELA' )
	
return oView 