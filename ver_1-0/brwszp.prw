#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE 'FWMVCDEF.CH'

/*
=====================================================================================
Programa.:              A DEFINIR 
Autor....:              Barbieri
Data.....:              21/03/2017
Descricao / Objetivo:   BROWSE PARA MANIPULACAO DAS REGIOES 
Doc. Origem:            
Solicitante:            Cliente
Uso......:              
Obs......:              Regioes de Entregas conforme cliente
=====================================================================================
*/

User Function BRWSZP()

	Private oBrowse3
	Private cLinha := ""

	oBrowse3 := FWMBrowse():New()
	oBrowse3:SetAlias('SZP')
	oBrowse3:SetDescription('Cadastro de Regioes ROADNET')
	oBrowse3:Activate()

return NIL

Static Function MenuDef()

	Local aRotina := {}

	ADD OPTION aRotina TITLE 'Visualizar' 		ACTION 'VIEWDEF.BRWSZP' 	OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Incluir'    		ACTION 'VIEWDEF.BRWSZP' 	OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar'    		ACTION 'VIEWDEF.BRWSZP' 	OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Excluir'    		ACTION 'VIEWDEF.BRWSZP' 	OPERATION 5 ACCESS 0

Return aRotina

Static Function ModelDef()
	// Cria a estrutura a ser usada no Modelo de Dados
	Local oStruSZP := FWFormStruct( 1, 'SZP')
	Local oStruZAP := FWFormStruct( 1, 'ZAP')
	Local oModel

	// Cria o objeto do Modelo de Dados
	oModel := MPFormModel():New('XBRWSZP',/**/ , , { | oModel | szpCmt( oModel ) }/*bCommit*/, /*bCancel*/ )

	// Adiciona ao modelo uma estrutura de formulario de edicao por campo
	oModel:AddFields( 'SZPMASTER', /*cOwner*/, oStruSZP, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )
	oModel:AddGrid( 'ZAPDETAIL', 'SZPMASTER', oStruZAP, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

	//Adiciona chave Primaria
	oModel:SetPrimaryKey({"ZP_FILIAL","ZP_CODREG"})

	// Adiciona relacao entre cabecalho e item (relacionamento entre mesma tabela)
	oModel:SetRelation( "ZAPDETAIL",{{"ZAP_FILIAL","XFILIAL('ZAP')"},{"ZAP_CODREG","ZP_CODREG"}},ZAP->(IndexKey(1)))

	// Adiciona a descricao do Modelo de Dados
	oModel:SetDescription( 'Cadastro de Regioes ROADNET' )	

	// Adiciona a descricao do Componente do Modelo de Dados
	oModel:GetModel( 'SZPMASTER' ):SetDescription( 'Regiao' )
	oModel:GetModel( 'ZAPDETAIL' ):SetDescription( 'Cidades da Regiao' )

Return oModel

Static Function ViewDef()

	// Cria a estrutura a ser usada na View
	Local oStruSZP := FWFormStruct( 2, 'SZP') //,{ |x| ALLTRIM(x) $ 'ZP_CODREG, ZP_DESCREG, ZP_ATIVO' })
	Local oStruZAP := FWFormStruct( 2, 'ZAP') //,{ |x| ALLTRIM(x) $ 'ZAP_EST, ZAP_CODMUN, ZAP_MUN' } )

	// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	Local oModel   := FWLoadModel( 'BRWSZP' )
	Local oView

	// Remove o campo Codigo Regiao do detalhe
	oStruZAP:RemoveField( "ZAP_CODREG" )

	// Cria o objeto de View
	oView := FWFormView():New()

	// Define qual o Modelo de dados sera utilizado
	oView:SetModel( oModel )

	//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
	oView:AddField( 'VIEW_SZP', oStruSZP, 'SZPMASTER' )
	oView:AddGrid( 'VIEW_ZAP', oStruZAP, 'ZAPDETAIL' )

	// Criar um "box" horizontal para receber algum elemento da view
	oView:CreateHorizontalBox( 'SUPERIOR' , 20 )
	oView:CreateHorizontalBox( 'INFERIOR' , 80 )

	// Relaciona o ID da View com o "box" para exibicao
	oView:SetOwnerView( 'VIEW_SZP', 'SUPERIOR' )
	oView:SetOwnerView( 'VIEW_ZAP', 'INFERIOR' )

Return oView



//Private cCadastro := "Cadastro Regioes "
//
//Private aRotina := {}
//
//aAdd( aRotina, {"Pesquisar" 		,"AxPesqui"			,0,1} )
//aAdd( aRotina, {"Visualizar"		,"AxVisual"			,0,2} ) 
//aAdd( aRotina, {"Incluir"   		,"AxInclui"			,0,3} )
//aAdd( aRotina, {"Alterar"   		,"AxAltera"			,0,4} )
//aAdd( aRotina, {"Excluir"      		,"AxDeleta"			,0,5} )
//
//Private cAlias := "SZP"
//                                      
//DbSelectArea(cAlias)
//DbSetOrder(1)
//DbGoTop()
//                        
//	mBrowse( 6,1,22,75,cAlias,,,,,,)


User function ZapVldMun()

	Local lRet
	Local cRegRoad := ""

	IF ZAP->(dbSeek(xFilial('ZAP')+FwFldGet("ZAP_CODMUN")))
		cRegRoad := ZAP->ZAP_CODREG
		MsgAlert('Cidade j� cadastrada na regiao '+cRegRoad+'!')
		lRet := .F.
	EndIF 

return lRet

//--------------------------------------------------------------
//--------------------------------------------------------------
static function szpCmt( oModel )
	local lRet		:= .T.
	local oModelSZP	:= oModel:GetModel('SZPMASTER')
	local cUpdSA1	:= ""

	If oModel:VldData()
		FwFormCommit( oModel )
		oModel:DeActivate()
        /*
		cUpdSA1 := "UPDATE " + retSQLName("SA1")
		cUpdSA1 += " SET A1_XINTEGX = 'P', A1_XINTEGR = 'P', A1_ZTAUVEZ = 0 "
		cUpdSA1 += " WHERE"
		cUpdSA1 += " A1_ZREGIAO = '" + SZP->ZP_CODREG + "'"

		tcSQLExec(cUpdSA1)
		*/
	Else
		JurShowErro( oModel:GetModel():GetErrormessage() )
		lRet := .F.
		DisarmTransaction()
	EndIf
Return lRet