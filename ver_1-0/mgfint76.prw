#Include 'Protheus.ch'
#include "totvs.ch"
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE "TOPCONN.CH"
#INCLUDE 'FWMVCDEF.CH'
/*
=====================================================================================
Programa.:              MGFINT76
Autor....:              Luiz Cesar Silva
Data.....:              10/09/2020
Descricao / Objetivo:   Fornecedores para recebimento XML
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Programa para identificar fornecedores aptos para recebimento do xml
=====================================================================================
*/
User function MGFINT76()

	Private oBrowse3

    dbSelectArea('ZHB')
    dbgotop()

	if Eof()
       U_MGFINT77()
    Endif

	oBrowse3 := FWMBrowse():New()
	oBrowse3:SetAlias('ZHB')
	oBrowse3:SetDescription('Fornecedores Envio XML')
	
	oBrowse3:Activate()

return NIL

Static function MenuDef()

	Local aRotina := {}
    
	ADD OPTION aRotina TITLE 'Habilita Fornecedores'   ACTION 'U_MGFINT77()' 	    OPERATION 4 ACCESS 0
Return aRotina

Static Function ModelDef()
	// Cria a estrutura a ser usada no Modelo de Dados
	Local oStruZHB := FWFormStruct( 1, 'ZH8')
	Local oModel

	
	// Cria o objeto do Modelo de Dados
	oModel := MPFormModel():New('BRWFINT76',/**/ , , , /*bCancel*/ )

	// Adiciona ao modelo uma estrutura de formulário de edição por campo
	oModel:AddFields( 'ZHBMASTER', /*cOwner*/, oStruZHB, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

	//Adiciona chave Primária
	oModel:SetPrimaryKey({"ZHB_FILIAL","ZHB_FORNEC","ZHB_LOJA"})

	// Adiciona a descricao do Modelo de Dados
	oModel:SetDescription( 'Fornecedores validos XML' )	

	// Adiciona a descricao do Componente do Modelo de Dados
	oModel:GetModel( 'ZHBMASTER' ):SetDescription( 'Fornecedores XML' )

Return oModel

Static Function ViewDef()

	// Cria a estrutura a ser usada na View
	Local oStruZHB := FWFormStruct( 2, 'ZHB') //,{ |x| ALLTRIM(x) $ 'ZP_CODREG, ZP_DESCREG, ZP_ATIVO' })

	// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	Local oModel   := FWLoadModel( 'BRWFINT76' )
	Local oView
	
	// Cria o objeto de View
	oView := FWFormView():New()

	// Define qual o Modelo de dados será utilizado
	oView:SetModel( oModel )

	//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
	oView:AddField( 'VIEW_ZHB', oStruZHB, 'ZHBMASTER' )

//	// Criar um "box" horizontal para receber algum elemento da view
//	oView:CreateHorizontalBox( 'SUPERIOR' , 20 )
//	oView:CreateHorizontalBox( 'INFERIOR' , 80 )
//
//	// Relaciona o ID da View com o "box" para exibicao
//	oView:SetOwnerView( 'VIEW_SZP', 'SUPERIOR' )
//	oView:SetOwnerView( 'VIEW_ZAP', 'INFERIOR' )

Return oView
