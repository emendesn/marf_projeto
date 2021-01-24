#Include 'Protheus.ch'
#INCLUDE "FWMVCDEF.CH"
#include "tbiconn.ch"


/*/{Protheus.doc} mgfeec35
//TODO Programa gerado para Alçada de Aprovadores
GAP 033
@author leonardo.kume
@since 03/10/2017
@version 6

@type function
/*/
user function mgfeec35()
Local oBrowse

oBrowse := FWmBrowse():New()
oBrowse:SetAlias( 'ZBZ' )
oBrowse:SetDescription( 'Cadastro Alçada' )
oBrowse:setMenuDef('mgfeec35')
oBrowse:Activate()

Return NIL


//-------------------------------------------------------------------
Static Function MenuDef()
Local aRotina := {}

	ADD OPTION aRotina TITLE 'Versionar'		ACTION 'VIEWDEF.mgfeec35'	OPERATION 9 ACCESS 0
	ADD OPTION aRotina TITLE 'Visualizar' 		ACTION 'VIEWDEF.mgfeec35' 	OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Incluir'    		ACTION 'VIEWDEF.mgfeec35' 	OPERATION 3 ACCESS 0
//	ADD OPTION aRotina TITLE 'Alterar'    		ACTION 'VIEWDEF.mgfeec35' 	OPERATION 4 ACCESS 0
//	ADD OPTION aRotina TITLE 'Excluir'    		ACTION 'VIEWDEF.mgfeec35' 	OPERATION 5 ACCESS 0
	
Return aRotina


//-------------------------------------------------------------------
Static Function ModelDef()
// Cria a estrutura a ser usada no Modelo de Dados
Local oStruZBZ := FWFormStruct( 1, 'ZBZ', /*bAvalCampo*/, /*lViewUsado*/ )
Local oStruZC1 := FWFormStruct( 1, 'ZC1', /*bAvalCampo*/, /*lViewUsado*/ )
Local oStruZBY := FWFormStruct( 1, 'ZBY', /*bAvalCampo*/, /*lViewUsado*/ )
Local oModel

// Cria o objeto do Modelo de Dados
oModel := MPFormModel():New( 'EEC35', /*bPreValidacao*/,{ | oMdl | COMP35POS( oMdl ) }/*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )
//oModel := MPFormModel():New( 'COMP021M', /*bPreValidacao*/, { | oMdl | COMP021POS( oMdl ) } , /*bCommit*/, /*bCancel*/ )

// Adiciona ao modelo uma estrutura de formulário de edição por campo
oModel:AddFields( 'ZBZMASTER', /*cOwner*/, oStruZBZ )

// Adiciona ao modelo uma estrutura de formulário de edição por grid
oModel:AddGrid( 'ZC1DETAIL', 'ZBZMASTER', oStruZC1, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )
oModel:AddGrid( 'ZBYDETAIL', 'ZC1DETAIL', oStruZBY, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )
//oModel:AddGrid( 'ZA2DETAIL', 'ZA1MASTER', oStruZA2, /*bLinePre*/,  { | oMdlG | COMP021LPOS( oMdlG ) } , /*bPreVal*/, /*bPosVal*/ )

// Faz relaciomaneto entre os compomentes do model
oModel:SetRelation( 'ZC1DETAIL', { { 'ZC1_FILIAL', 'xFilial( "ZC1" )' }, { 'ZC1_VERSAO', 'ZBZ_VERSAO' } }, ZC1->( IndexKey( 1 ) ) )
oModel:SetRelation( 'ZBYDETAIL', { { 'ZBY_FILIAL', 'xFilial( "ZBY" )' }, { 'ZBY_NIVEL', 'ZC1_NIVEL' } }, ZBY->( IndexKey( 1 ) ) )

// Liga o controle de nao repeticao de linha
oModel:GetModel( 'ZC1DETAIL' ):SetUniqueLine( { 'ZC1_NIVEL' } )

// Indica que é opcional ter dados informados na Grid
oModel:GetModel( 'ZBYDETAIL' ):SetOptional(.T.)
oModel:GetModel( 'ZBYDETAIL' ):SetOnlyView(.T.)
oModel:GetModel( 'ZBYDETAIL' ):SetOnlyQuery(.T.)

//Adiciona chave Primária
oModel:SetPrimaryKey({"ZBZ_FILIAL","ZBZ_VERSAO","ZBZ_NIVEL"})

// Adiciona a descricao do Modelo de Dados
//oModel:SetDescription( 'Distribuicao de Orçamento' )

oModel:GetModel( 'ZBYDETAIL' ):SetNoInsertLine( .T. )
oModel:GetModel( 'ZBYDETAIL' ):SetNoUpdateLine( .T. )
oModel:GetModel( 'ZBYDETAIL' ):SetNoDeleteLine( .T. )

oModel:SetActivate({|oModel|xActiv(oModel)})


Return oModel


//-------------------------------------------------------------------
Static Function ViewDef()
// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
// Cria a estrutura a ser usada na View
Local oModel   := FWLoadModel( 'mgfeec35' )
Local oView

Local oStruZBZ 	:= FWFormStruct( 2, 'ZBZ' )
Local oStruZC1 	:= FWFormStruct( 2, 'ZC1' )
Local oStruZBY 	:= FWFormStruct( 2, 'ZBY' )

oStruZBZ:SetNoFolder()
oStruZC1:RemoveField("ZC1_VERSAO")
oStruZBY:RemoveField("ZBY_NIVEL")
oStruZBY:RemoveField("ZBY_DNIVEL")
// Cria o objeto de View
oView := FWFormView():New()

// Define qual o Modelo de dados será utilizado
oView:SetModel( oModel )

//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
oView:AddField( 'VIEW_ZBZ', oStruZBZ, 'ZBZMASTER' )

//Adiciona no nosso View um controle do tipo FormGrid(antiga newgetdados)
oView:AddGrid(  'VIEW_ZC1', oStruZC1, 'ZC1DETAIL' )
oView:AddGrid(  'VIEW_ZBY', oStruZBY, 'ZBYDETAIL' )

// Criar um "box" horizontal para receber algum elemento da view
oView:CreateHorizontalBox( 'SUPERIOR', 30 )
oView:CreateHorizontalBox( 'CENTRAL', 70 )
oView:CreateVerticalBox( 'ESQ', 50 ,'CENTRAL')
oView:CreateVerticalBox( 'DIR', 50, 'CENTRAL' )

// Relaciona o ID da View com o "box" para exibicao
oView:SetOwnerView( 'VIEW_ZBZ', 'SUPERIOR' )
oView:SetOwnerView( 'VIEW_ZC1', 'ESQ' )
oView:SetOwnerView( 'VIEW_ZBY', 'DIR' )

// Define campos que terao Auto Incremento
oView:AddIncrementField( 'VIEW_ZC1', 'ZC1_ORDEM' )

// Liga a Edição de Campos na FormGrid
//oView:SetViewProperty( 'VIEW_ZA2', "ENABLEDGRIDDETAIL", { 50 } )
oView:EnableTitleView( 'VIEW_ZC1', "Alçada" )
oView:EnableTitleView( 'VIEW_ZBY', "Vinculo Nível (Somente Visual)" )


Return oView


/*/{Protheus.doc} xActiv
//TODO Activate para alimentar os campos
@author leonardo.kume
@since 09/10/2017
@version 6
@param oModel, object, descricao
@type function
/*/
Static Function xActiv(oModel)

Local lRet := .T.
Local oMdlZBX := oModel:GetModel("ZBZMASTER")

If oModel:GetOperation() == MODEL_OPERATION_INSERT
	oMdlZBX:SetValue("ZBZ_USER",RetCodUsr())
	oMdlZBX:SetValue("ZBZ_HRINCL",Time())
	oMdlZBX:SetValue("ZBZ_DATAIN",dDataBase)
	oMdlZBX:SetValue("ZBZ_OBSERV","")
EndIf

Return lRet

/*/{Protheus.doc} COMP35POS
//TODO Pos Validação
@author leonardo.kume
@since 10/10/2017
@version 6
@param oMdl, object, descricao
@type function
/*/
Static Function COMP35POS(oMdl)

	Local lRet 		:= MsgYesNo("Ao criar uma nova versão ela será considerada para todos os proximos orçamentos a serem aprovados. Deseja realmente salvar?","Versionamento")
	Local aAreaZBZ 	:= ZBZ->(GetArea())
	Local cUpd		:= ""
	
	If lRet	
		cUpd := "UPDATE " + retSQLName("ZBZ")			+ CRLF
		cUpd += " SET ZBZ_MSBLQL = '1'"			+ CRLF
		cUpd += " WHERE ZBZ_FILIAL= '" + xFilial("ZBZ")+"'"	+ CRLF
		cUpd += "  		AND ZBZ_VERSAO <> '" + oMdl:GetModel("ZBZMASTER"):GetValue("ZBZ_VERSAO")+"'"	+ CRLF
		
		tcSQLExec(cUpd)
	Else
		Help(,,'Não Gravado',,'Registro não foi gravado.',1,0)
	EndIf

	ZBZ->(RestArea(aAreaZBZ))
Return lRet

/*/{Protheus.doc} Refresh35
//TODO Atualiza View
@author leonardo.kume
@since 24/01/2018
@version 6
@return caracter, retorna valor passado por parâmetro
@param cVar, characters, Valor a ser retornado na função
@type function
/*/
User Function Refres35(cVar)
	
	Local oView		:= FwViewActive()
	Local oModel	:= FWModelActive()
	Local oModelZBY	:= oModel:GetModel( 'ZBYDETAIL' )
	Local aArea		:= GetArea()
	

	
	oModelZBY:SetNoInsertLine( .F. )
	oModelZBY:SetNoUpdateLine( .F. )
	oModelZBY:SetNoDeleteLine( .F. )
	
	DbSelectArea("ZBY")
	ZBY->(DbSetOrder(1))
	If ZBY->(DbSeek(xFilial("ZBY")+cVar))
		oModelZBY:ClearData()
	 	While !ZBY->(Eof()) .AND. ZBY->ZBY_NIVEL == cVar
		 	If  !oModelZBY:IsEmpty()
				oModelZBY:GoLine(oModelZBY:Length())
				nLinhaAtu := oModelZBY:GetLine()
				nNewLine := oModelZBY:AddLine(.t.)
				If nNewLine == nLinhaAtu
					lRet := .F.
				EndIf
				oModelZBY:GoLine( nNewLine )
			Else
				oModelZBY:ClearData()
			Endif
			oModelZBY:LoadValue("ZBY_APROVA",ZBY->ZBY_APROVA)
			ZBY->(DbSkip())
		EndDo	
	EndIf	

	oModelZBY:GoLine(1)
	
	oModelZBY:SetNoInsertLine( .F. )
	oModelZBY:SetNoUpdateLine( .F. )
	oModelZBY:SetNoDeleteLine( .F. )
	
	
	oView:Refresh()
	
	
	
	RestArea(aArea)
	
Return cVar
