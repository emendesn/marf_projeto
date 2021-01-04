#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"
#include 'fwmvcdef.ch'

#define CRLF chr(13) + chr(10)

static cTipologia := ""
static cDescTipol := ""

user function MGFCOM95()
	local oBrowse

	//Cria um Browse Simples instanciando o FWMBrowse
	oBrowse := FWMBrowse():New()
	//Define um alias para o Browse
	oBrowse:SetAlias('ZE9')
	//Adiciona uma descrição para o Browse
	oBrowse:SetDescription('Hierarquia de Vendas')

	//Ativa o Browse
	oBrowse:Activate()

return nil

//-------------------------------------------------------------------
static function MenuDef()
	local aRotina := {}

	ADD OPTION aRotina TITLE 'Pesquisar'  	ACTION 'PesqBrw'			OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE 'Visualizar' 	ACTION 'VIEWDEF.MGFCOM95'	OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Incluir'    	ACTION 'VIEWDEF.MGFCOM95'	OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar'    	ACTION 'VIEWDEF.MGFCOM95'	OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Excluir'    	ACTION 'VIEWDEF.MGFCOM95'	OPERATION 5 ACCESS 0

return aRotina

//-------------------------------------------------------------------
Static Function ModelDef()
	// Cria a estrutura a ser usada no Modelo de Dados
	Local oStruZE9 := FWFormStruct( 1, 'ZE9', /*bAvalCampo*/,/*lViewUsado*/ )
	Local oModel
	Local oStr1:= FWFormStruct(1,'ZEM')
	// Cria o objeto do Modelo de Dados

	oModel := MPFormModel():New('COM95MODEL', /*bPreValidacao*/, /*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )

	// Adiciona ao modelo uma estrutura de formulário de edição por campo
	oModel:AddFields( 'ZE9MASTER', /*cOwner*/, oStruZE9, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )
	oModel:addGrid('ZEMGRID','ZE9MASTER',oStr1)
	oModel:SetRelation('ZEMGRID', { { 'ZEM_FILIAL', 'ZE9_FILIAL' }, { 'ZEM_TIPOLO', 'ZE9_TIPOLO' }, { 'ZEM_CATEGO', 'ZE9_CATEGO' }, { 'ZEM_CANAL', 'ZE9_CANAL' } }, ZEM->(IndexKey(1)) )

	// Adiciona a descricao do Modelo de Dados
	oModel:SetDescription( 'Modelo de Hierarquia de Vendas' )

	// Adiciona a descricao do Componente do Modelo de Dados
	oModel:GetModel( 'ZE9MASTER' ):SetDescription( 'Dados de Hierarquia de Vendas' )
	oModel:getModel('ZEMGRID'):SetDescription('ZEMGRID')

	oModel:SetPrimaryKey({})
		//deixar o grid opcional
	oModel:GetModel('ZEMGRID'):SetOptional(.T.)

	oModel:GetModel('ZEMGRID'):SetUniqueLine({'ZEM_CNPJ'})

Return oModel

//-------------------------------------------------------------------
Static Function ViewDef()
	// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	Local oModel   := FWLoadModel( 'MGFCOM95' )
	// Cria a estrutura a ser usada na View
	Local oStruZE9 := FWFormStruct( 2, 'ZE9' )
	Local oStr1:= FWFormStruct(2, 'ZEM')
	Local oView

	// Cria o objeto de View
	oView := FWFormView():New()

	// Define qual o Modelo de dados será utilizado
	oView:SetModel( oModel )

	//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
	oView:AddField( 'VIEW_ZE9', oStruZE9, 'ZE9MASTER' )
	oView:AddGrid('VIEW_ZEM' , oStr1,'ZEMGRID')

	// Criar um "box" horizontal para receber algum elemento da view
	oView:CreateHorizontalBox( 'TELA' , 50 )
	oView:CreateHorizontalBox( 'GRID', 50)
	oView:SetOwnerView('VIEW_ZEM','GRID')

	// Relaciona o ID da View com o "box" para exibicao
	oView:SetOwnerView( 'VIEW_ZE9', 'TELA' )
	oStr1:removefield('ZEM_TIPOLO')
	oStr1:removefield('ZEM_CATEGO')
	oStr1:removefield('ZEM_CANAL')
	Return oView

//-------------------------------------------------------------------
// Consulta Padrao Especifica
//-------------------------------------------------------------------
user function XBCOM95A()
	local cQRYZE9 	:= ""
	local aZE9		:= {}
	local oSXBZE9		:= nil
	local aCoors		:= 	FWGetDialogSize( oMainWnd )
	local oSxbEsp		:= nil
	local lOk			:=.T.
	local cCodigo		:= ""
	local oDlg			:= nil


	local cQryZE9	:= ""

	cQryZE9 := "SELECT DISTINCT ZE9_TIPOLO, ZE9_DESTIP"						+ CRLF
	cQryZE9 += " FROM " + retSQLName("ZE9") + " ZE9"						+ CRLF
	cQryZE9 += " WHERE"														+ CRLF
	cQryZE9 += " 		ZE9.ZE9_FILIAL	=	'" + xFilial("ZE9")	+ "'"		+ CRLF
	cQryZE9 += " 	AND	ZE9.D_E_L_E_T_	<>	'*'"							+ CRLF

	TcQuery cQryZE9 New Alias "QRYZE9"

	if !QRYZE9->(EOF())
		while !QRYZE9->(EOF())
			aadd( aZE9, { ZE9_TIPOLO, ZE9_DESTIP } )
			QRYZE9->(DBSkip())
		enddo
	else
		msgAlert("Nenhum dado encontrado.")
	endif

	QRYZE9->(DBCloseArea())

	if len( aZE9 ) > 0
		DEFINE MSDIALOG oDlg TITLE 'Tipologia' FROM aCoors[1]/2, aCoors[2] TO aCoors[3]/2, aCoors[4] PIXEL STYLE DS_MODALFRAME
		oSXBZE9 := fwBrowse():New()
		oSXBZE9:setDataArray()
		oSXBZE9:setArray(aZE9)
		oSXBZE9:disableConfig()
		oSXBZE9:disableReport()
		oSXBZE9:setOwner(oDlg)

		oSXBZE9:addColumn({"Tipologia"		, {||aZE9[oSXBZE9:nAt,1]}, "C", , 1, tamSx3("ZE9_TIPOLO")[1]})
		oSXBZE9:addColumn({"Descricao"		, {||aZE9[oSXBZE9:nAt,2]}, "C", , 1, tamSx3("ZE9_DESTIP")[1]})

		oSXBZE9:setDoubleClick( { || cTipologia := aZE9[oSXBZE9:nAt,1], cDescTipol := aZE9[oSXBZE9:nAt,2], oDlg:end() } )
		oSXBZE9:activate(.T.)

		enchoiceBar(oDlg, { || cTipologia := aZE9[oSXBZE9:nAt,1], cDescTipol := aZE9[oSXBZE9:nAt,2], oDlg:end() } , { || cTipologia := "", cDescTipol := "", oDlg:end() })
		ACTIVATE MSDIALOG oDlg CENTER
	endif

return (.T.)

//------------------------
//------------------------
user function XBCOM95B()
return (cTipologia)

//------------------------
//------------------------
user function XBCOM95C()
return (cDescTipol)

//-------------------------------------------------------------------
// Consulta Padrao Especifica
//-------------------------------------------------------------------
user function XBCOM95D()
	local cQ:=""
	local cCnae:=FWFLDGET("ZEF_CNAE")
	lRet:= .t.
	cQ:= " SELECT * "
	cQ+= " FROM " + retSQLName("ZEF") + " ZEF"						+ CRLF
	cQ+= " WHERE ZEF_CNAE='"+cCnae+"' and D_E_L_E_T_<>'*'"

	IF SELECT("cZEF") > 0
		cZEF->( dbCloseArea() )
	ENDIF
	TcQuery changeQuery(cQ) New Alias "cZEF"

	IF !cZEF->(eof())
		msgAlert("CNAE ja relacionado a outra Tipologia")
		lRet:= .f.
	ELSE
		DBSELECTAREA("CC3")
		DBSETORDER(1)
		IF DBSEEK( XFILIAL("CC3")+cCnae)
		//	FWFLDPUT("ZEF_CNAE",cCnae,n,,,.T.)
			FWFLDPUT("ZEF_DCNAE",CC3->CC3_DESC,,,,.T.)
		ELSE
			msgAlert("CNAE informado nao cadastrado")
			lRet:= .f.
		ENDIF
	endif
	IF SELECT("cZEF") > 0
		cZEF->( dbCloseArea() )
	ENDIF

RETURN(lRet)