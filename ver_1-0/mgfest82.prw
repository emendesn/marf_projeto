#Include "Protheus.ch"
#Include "FwMvcDef.ch"
#Include "FwMBrowse.ch"

/*/
==============================================================================================================================================================================
{Protheus.doc} MGFEST82
Cadastro na Tabela (ZHN) Monitor Liberação de Usuarios

@description
Manutenï¿½ï¿½o (Inclusï¿½o/Alteraï¿½ï¿½o/Exclusï¿½o) na Tabela de Monitor Liberação de Usuarios (ZHN)

@author Antonio Florencio
@since 16/10/2020
@type Function

@table
ZHN - Tabela Monitor Liberação de Usuarios

@param

@return
_cret - Nulo

@menu
Gestï¿½o Frete Embarcador-Atualizaï¿½ï¿½es-Especifico-@ Monitor Liberação de Usuarios

@history //Manter atï¿½ as ï¿½ltimas 3 manutenï¿½ï¿½es do fonte para facilitar identificaï¿½ï¿½o de versï¿½o, remover esse comentï¿½rio
/*/   
User Function MGFEST82()

	Local _oBrowse

	//Instanciamento da Classe de Browse
	_oBrowse := FWMBrowse():New()

	//Definiï¿½ï¿½o da tabela do Browse
	_oBrowse:SetAlias("ZHN")

	//Definiï¿½ï¿½o do tï¿½tulo do browser
	_oBrowse:SetDescription( FWX2Nome("ZHN") )

	//Desabilita os detalhes que sï¿½o habilitados para o Browse quando o usuï¿½rio navega nos registros pelo Grid
	_oBrowse:DisableDetails()

	_oBrowse:Activate()

Return()


/*/
==============================================================================================================================================================================
{Protheus.doc} MenuDef()
Funï¿½ï¿½o para criar o Menu (Vizualizar/Incluir/Alterar/Excluir)

@author Antonio Florencio
@since 16/10/2020
@type Function

@param

@return
	_aRotina - Array com os botï¿½es
/*/
Static Function MenuDef()

	Local _aRotina := {}

	ADD OPTION _aRotina TITLE "Visualizar"  ACTION "VIEWDEF.MGFEST82"   OPERATION 2 ACCESS 0
	ADD OPTION _aRotina TITLE "Incluir"     ACTION "VIEWDEF.MGFEST82"   OPERATION 3 ACCESS 0
	ADD OPTION _aRotina TITLE "Alterar"     ACTION "VIEWDEF.MGFEST82"   OPERATION 4 ACCESS 0
	ADD OPTION _aRotina TITLE "Excluir"     ACTION "VIEWDEF.MGFEST82"   OPERATION 5 ACCESS 0

Return( _aRotina )


/*/
==============================================================================================================================================================================
{Protheus.doc} ModelDef()
Funï¿½ï¿½o para Definiï¿½ï¿½o do Modelo de Dados para Cadastro de Monitor Liberação de Usuarios

@author Antonio Florencio
@since 16/10/2020
@type Function

@param

@return
	_oModel - Objeto
/*/
Static Function ModelDef()

	Local _oModel
	Local _oStruZHNM := FWFormStruct( 1, "ZHN", { |x| AllTrim(x) $ "ZHN_FILIAL|ZHN_CODUSU|ZHN_NOMUSU|ZHN_ROTINA|ZHN_DATA" } )

	_oModel := MPFormModel():New('zMGFEST82', /*bMPFormModelo*/, /*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )

	_oModel:AddFields("ZHNMASTER", /*cOwner*/, _oStruZHNM, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )
	
	//Chave Promaria
	_oModel:SetPrimaryKey( { "ZHN_FILIAL", "ZHN_CODUSU", "ZHN_ROTINA" } )

	//Adiciona a descricao do Modelo de Dados
	_oModel:SetDescription( FWX2Nome("ZHN" ) )

	_oModel:GetModel("ZHNMASTER"):SetDescription( FWX2Nome("ZHN" ) )

Return(_oModel)


/*/
==============================================================================================================================================================================
{Protheus.doc} ViewDef()
Funï¿½ï¿½o para Definiï¿½ï¿½o da Visualizaï¿½ï¿½o da Tela

@author Antonio Florencio
@since 16/10/2020
@type Function

@param

@return
	_oView - Objeto
/*/
Static Function ViewDef()

	Local _oView
	Local _oModelVd	 := ModelDef()
	Local _oStruZHNM := FWFormStruct( 2, "ZHN", { |x| AllTrim(x) $ "ZHN_FILIAL|ZHN_CODUSU|ZHN_NOMUSU|ZHN_ROTINA|ZHN_DATA" } )

	// Cria o objeto de View
	_oView := FWFormView():New()
	_oView:SetModel(_oModelVd)

	//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
	_oView:AddField("VIEW_ZHNM", _oStruZHNM, "ZHNMASTER" )
	
	//Criar um "box" horizontal para receber algum elemento da view
	_oView:CreateHorizontalBox("SUPERIOR", 100 )

	//Relaciona o ID da View com o "box" para exibicao
	_oView:SetOwnerView("VIEW_ZHNM", "SUPERIOR" )

Return(_oView)
