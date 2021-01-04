#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*
===========================================================================================
Programa.:              MGFEEC12
Autor....:              Leonardo Kume
Data.....:              Dez/2016
Descricao / Objetivo:   Fonte MVC para exibicao de Track Aprovacao
Doc. Origem:            EEC09
Solicitante:            Cliente
Uso......:              
Obs......:               
===========================================================================================
*/
User Function MGFEEC12()
	Local oBrowse2
	Local aOldRot := iif(Type("aRotina")<>"U",aRotina,{})
	If Type("aRotina")<>"U"
		aRotina := {}
	EndIf

	oBrowse2 := FWMBrowse():New()
	oBrowse2:SetAlias('ZZG')
	oBrowse2:SetDescription('Orcamento Exportacao Marfrig')
	oBrowse2:AddLegend("ZZG_STATUS = 'P' ","BLUE" ,'Pendente')
	oBrowse2:AddLegend("ZZG_STATUS = 'W' ","YELLOW" ,'Enviado Workflow')
	oBrowse2:AddLegend("ZZG_STATUS = 'A' ","GREEN" ,'Aprovado')
	oBrowse2:AddLegend("ZZG_STATUS = 'C' ","RED" ,'Cancelado')
	oBrowse2:AddLegend("!ALLTRIM(ZZG_STATUS) $ 'P/W/A/C' ","BLACK" ,'Status legado')
	oBrowse2:setMenuDef("MGFEEC12")
	oBrowse2:SetFilterDefault( "SUBSTR(ZZG_FILIAL,1,2) == '"+Substr(xFilial("ZZG"),1,2)+"' .and. ZZG_NUMERO=='"+ZZC->ZZC_ORCAME+"'" )
	oBrowse2:Activate()


	if Type("aRotina")<>"U
		aRotina := aOldRot
	EndIf
Return .T.

Static Function MenuDef()
	Local aRot := {}

	ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.MGFEEC12' OPERATION 2 ACCESS 0

Return aRot


Static Function ModelDef()
// Cria a estrutura a ser usada no Modelo de Dados
	Local oStruZZG := FWFormStruct( 1, 'ZZG')
	Local oModel

// Cria o objeto do Modelo de Dados
	oModel := MPFormModel():New('EEC12M', /*bPreValidacao*/, /*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )

// Adiciona ao modelo uma estrutura de formulario de edicao por campo
	oModel:AddFields( 'EEC12MASTER', /*cOwner*/, oStruZZG, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

// Adiciona a descricao do Modelo de Dados
	oModel:SetDescription( 'Orcamento Exportacao Marfrig' )

// Adiciona a descricao do Componente do Modelo de Dados
	oModel:GetModel( 'EEC12MASTER' ):SetDescription( 'Historico Aprovacao' )

//Adiciona chave Primaria
	oModel:SetPrimaryKey({"ZZG_FILIAL","ZZG_NUMERO"})
	
Return oModel


Static Function ViewDef()
// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	Local oModel   := FWLoadModel( 'MGFEEC12' )
// Cria a estrutura a ser usada na View
	Local oStruZZG := FWFormStruct( 2, 'ZZG',,/*lViewUsado*/ )

	Local oView
	Local cCampos := {}


// Cria o objeto de View
	oView := FWFormView():New()

// Define qual o Modelo de dados sera utilizado
	oView:SetModel( oModel )

//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
	oView:AddField( 'VIEW_ZZG', oStruZZG, 'EEC12MASTER' )

// Criar um "box" horizontal para receber algum elemento da view
	oView:CreateHorizontalBox( 'SUPERIOR' , 100 )

// Relaciona o ID da View com o "box" para exibicao
	oView:SetOwnerView( 'VIEW_ZZG', 'SUPERIOR' )


Return oView
