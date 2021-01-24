#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH' 
//-------------------------------------------------------------------
/*/{Protheus.doc} MGFCOMBI
Cadastro CNPJs de Entidades do Governo

@author Wagner Neves
@since 14/04/2020
@version P12.1.17
/*/
//-------------------------------------------------------------------
User Function MGFCOMBI()
Local oBrowse

oBrowse := FWMBrowse():New()
oBrowse:SetAlias('ZG4')
oBrowse:SetDescription('Cadastro CNPJs de Entidades do Governo')
oBrowse:Activate()

Return NIL

//-------------------------------------------------------------------
Static Function MenuDef()
Local aRotina := {}

ADD OPTION aRotina TITLE '&Visualizar' ACTION 'VIEWDEF.MGFCOMBI' OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE '&Incluir'    ACTION 'VIEWDEF.MGFCOMBI' OPERATION 3 ACCESS 0
ADD OPTION aRotina TITLE '&Alterar'    ACTION 'VIEWDEF.MGFCOMBI' OPERATION 4 ACCESS 0
ADD OPTION aRotina TITLE '&Excluir'    ACTION 'VIEWDEF.MGFCOMBI' OPERATION 5 ACCESS 0
Return aRotina

//-------------------------------------------------------------------
Static Function ModelDef()
// Cria a estrutura a ser usada no Modelo de Dados
Local oStruZG4 := FWFormStruct( 1, 'ZG4', /*bAvalCampo*/,/*lViewUsado*/ )
Local oModel

// Cria o objeto do Modelo de Dados
oModel := FWModelActive()
oModel := MPFormModel():New('XMGFCOMBI', /*bPreValidacao*/, { |oModel| FISBIPOS( oModel )}, /*bCommit*/, /*bCancel*/ )

// Adiciona ao modelo uma estrutura de formulário de edição por campo
oModel:AddFields( 'ZG4MASTER', /*cOwner*/, oStruZG4,  /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

// Adiciona a descricao do Modelo de Dados
oModel:SetDescription( 'Cadastro CNPJs de Entidades do Governo' )
oModel:SetPrimaryKey({"ZG4_FILIAL+ZG4_CODIGO"})

// Adiciona a descricao do Componente do Modelo de Dados
oModel:GetModel( 'ZG4MASTER' ):SetDescription( 'Cadastro CNPJs de Entidades do Governo' )

Return oModel


//-------------------------------------------------------------------
Static Function ViewDef()
// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
Local oModel   := FWLoadModel('MGFCOMBI')
// Cria a estrutura a ser usada na View
Local oStruZG4 := FWFormStruct( 2, 'ZG4' )
Local oView
Local cCampos := {}

// Crio os Agrupamentos de Campos  
// AddGroup( cID, cTitulo, cIDFolder, nType )   nType => ( 1=Janela; 2=Separador )
oStruZG4:AddGroup( 'GRUPO01', 'Informe o CNPJ e o Nome da Entidades do Governo', '', 2 )

oStruZG4:SetProperty( '*'         , MVC_VIEW_GROUP_NUMBER, 'GRUPO01' )

// Cria o objeto de View
oView := FWFormView():New()

// Define qual o Modelo de dados será utilizado
oView:SetModel( oModel )

//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
oView:AddField('VIEW_ZG4', oStruZG4, 'ZG4MASTER')

// Criar um "box" horizontal para receber algum elemento da view
oView:CreateHorizontalBox( 'TELA' , 100 )

// Relaciona o ID da View com o "box" para exibicao
oView:SetOwnerView( 'VIEW_ZG4', 'TELA' )

Return oView


//-------------------------------------------------------------------
Static Function FISBIPOS( oModel )
Local nOperation := oModel:GetOperation()
Local lRet       := .T.
Local cFilialZG4 := xFilial("ZG4")
Local cCodigo    := ZG4->ZG4_CODIGO

// Inclusão dos registros
If nOperation == 3 // INCLUSÃO
	// Valida se o cadastro já existe
	If !Vazio(Posicione("ZG4",1,xFilial("ZG4")+Alltrim(M->ZG4_CODIGO),"ZG4_CODIGO"))
		Help( ,, 'MGFCOMBI',, 'O CNPJ informado já existe na Base de Dados', 1, 0,NIL, NIL, NIL, NIL, NIL, {"Informe outro CNPJ"})
		lRet := .F.
	EndIf
EndIf
Return lRet
