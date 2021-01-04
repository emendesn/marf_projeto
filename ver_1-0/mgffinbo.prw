#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE 'FWMVCDEF.CH'

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              MGFFINBO 
Autor....:              Renato Junior
Data.....:              01/06/2020
Descricao / Objetivo:   ENVIO DE E-MAIL DE COBRAN�A
Doc. Origem:            
Solicitante:            Cliente
Uso......:              
Obs......:              
=====================================================================================
*/
User Function MGFFINBO()
	Private oBrowse3
	Private cLinha := ""

	oBrowse3 := FWMBrowse():New()
	oBrowse3:SetAlias('ZGD')
	oBrowse3:SetDescription('Gerencia Comercial x Vendedores')
	oBrowse3:Activate()

return NIL

Static Function MenuDef()

	Local aRotina := {}

	ADD OPTION aRotina TITLE 'Visualizar' 		ACTION 'VIEWDEF.MGFFINBO' 	OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Incluir'    		ACTION 'VIEWDEF.MGFFINBO' 	OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar'    		ACTION 'VIEWDEF.MGFFINBO' 	OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Excluir'    		ACTION 'VIEWDEF.MGFFINBO' 	OPERATION 5 ACCESS 0

Return aRotina

Static Function ModelDef()
	// Cria a estrutura a ser usada no Modelo de Dados
	Local oStruZGD := FWFormStruct( 1, 'ZGD')
	Local oStruZGE := FWFormStruct( 1, 'ZGE')
	Local oModel
	Local aAux := {}

	//**********************
	// ZGE_NOMVEN
	//**********************
	aAux := FwStruTrigger("ZGE_CODVEN" ,;
		"ZGE_NOMVEN" ,;
		"POSICIONE('SA3',1,XFILIAL('SA3') + M->ZGE_CODVEN, 'A3_NOME')",;
		.F.,;
		"",;
		0,;
		"")
	oStruZGE:AddTrigger( ;
		aAux[1] , ; // [01] identificador (ID) do campo de origem
	aAux[2] , ; // [02] identificador (ID) do campo de destino
	aAux[3] , ; // [03] Bloco de codigo de validacao da execucao do gatilho
	aAux[4] ) // [04] Bloco de codigo de execucao do gatilho

	// Cria o objeto do Modelo de Dados
	oModel := MPFormModel():New('XMGFFINBO',/**/ , , { | oModel | zgdCmt( oModel ) }/*bCommit*/, ;
		{|oModel| bCancel()}	/*{|| FWFORMCANCEL(SELF)} /*bCancel( oModel )/*bCancel*/ )

	// Adiciona ao modelo uma estrutura de formulario de edicao por campo
	oModel:AddFields( 'ZGDMASTER', /*cOwner*/, oStruZGD, /*bPreValidacao*/, {|oModel| posvldZGD(oModel)} /*bPosValidacao*/, /*bCarga*/ )
	oModel:AddGrid( 'ZGEDETAIL', 'ZGDMASTER', oStruZGE, /*bPreValidacao*/, {|a,b| posvldZGE(a,b)} /*bPosValidacao*/, /*bCarga*/ )

	//Adiciona chave Primaria
	oModel:SetPrimaryKey({"ZGD_FILIAL","ZGD_CODIGO"})

	// Adiciona relacao entre cabecalho e item (relacionamento entre mesma tabela)
	oModel:SetRelation( "ZGEDETAIL",{{"ZGE_FILIAL","XFILIAL('ZGE')"},{"ZGE_CODIGO","ZGD_CODIGO"}},ZGE->(IndexKey(1)))

	// Adiciona a descricao do Modelo de Dados
	oModel:SetDescription( 'Cadastro de Gerencia Comercial x Vendedores' )	

	// Adiciona a descricao do Componente do Modelo de Dados
	oModel:GetModel( 'ZGDMASTER' ):SetDescription( 'Gerencia Comercial' )
	oModel:GetModel( 'ZGEDETAIL' ):SetDescription( 'Vendedores da Gerencia Comercial' )

	oStruZGD:SetProperty("ZGD_CODIGO",MODEL_FIELD_INIT,{||GETSXENUM('ZGD','ZGD_CODIGO')})

Return oModel

Static Function ViewDef()

	// Cria a estrutura a ser usada na View
	Local oStruZGD := FWFormStruct( 2, 'ZGD')
	Local oStruZGE := FWFormStruct( 2, 'ZGE')

	// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	Local oModel   := FWLoadModel( 'MGFFINBO' )
	Local oView

	// Remove o campo Codigo Regiao do detalhe
	oStruZGE:RemoveField( "ZGE_CODIGO" )

	// Cria o objeto de View
	oView := FWFormView():New()

	// Define qual o Modelo de dados sera utilizado
	oView:SetModel( oModel )

	//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
	oView:AddField( 'VIEW_ZGD', oStruZGD, 'ZGDMASTER' )
	oView:AddGrid( 'VIEW_ZGE', oStruZGE, 'ZGEDETAIL'  )

	// Criar um "box" horizontal para receber algum elemento da view
	oView:CreateHorizontalBox( 'SUPERIOR' , 30 )
	oView:CreateHorizontalBox( 'INFERIOR' , 70 )

	// Relaciona o ID da View com o "box" para exibicao
	oView:SetOwnerView( 'VIEW_ZGD', 'SUPERIOR' )
	oView:SetOwnerView( 'VIEW_ZGE', 'INFERIOR' )

Return oView


//--------------------------------------------------------------
//--------------------------------------------------------------
static function zgdCmt( oModel )
	Local lRet		:= .T.
 Local nOperation := oModel:GetOperation()

	If oModel:VldData()
		FwFormCommit( oModel )
		oModel:DeActivate()
		confirmSX8()
	Else
		RollBackSX8()
		JurShowErro( oModel:GetModel():GetErrormessage() )
		lRet := .F.
		DisarmTransaction()
	EndIf
Return lRet


//------------------------------------------------
// 
//------------------------------------------------
Static Function posvldZGE(oModel, nLin)
Local nI			:= 0
Local xRet			:= .T.
Local oModel 		:= FWModelActive()
Local oMdlZGE		:= oModel:GetModel('ZGEDETAIL')
Local aSaveLines	:= FWSaveRows()
Local cChvProd		:=	oMdlZGE:getValue("ZGE_CODVEN")
Local cMsgErr		:= ""

If Empty(cChvProd)
	cMsgErr := "Vendedor nao informado."
Else
	POSICIONE('SA3',1,XFILIAL('SA3') + cChvProd, 'A3_NOME')
	If ! SA3->(FOUND())
		cMsgErr := "Vendedor nao existe."
	Else
		For nI := 1 to oMdlZGE:length()
		 	If nLin <> nI	// Desconsidera a propria linha digitada
				oMdlZGE:goLine(nI)
				if !oMdlZGE:isDeleted()
					If cChvProd == oMdlZGE:getValue("ZGE_CODVEN")
						cMsgErr := "Vendedor j� cadastrado nesta Gerencia."
						Exit
					Endif
				Endif
			Endif
		Next
	Endif
Endif

If ! Empty(cMsgErr)
	Help( ,, 'Nao permitido',, cMsgErr, 1, 0 )
	xRet := .F.
Endif

FWRestRows( aSaveLines )
Return xRet


//------------------------------------------------
//
//------------------------------------------------
static function posvldZGD(oModel)
	Local lRet			:= .T.
	Local oModel		:= FWModelActive()
	Local oModelZGD		:= oModel:GetModel('ZGDMASTER')
	Local oModelZGE		:= oModel:GetModel('ZGEDETAIL')
	Local nOper			:= oModel:getOperation()
	Local aSaveLines	:= FWSaveRows()
	Local nI			:=	0
	Local cTodosVend	:=	""

	If nOper == MODEL_OPERATION_UPDATE .or. nOper == MODEL_OPERATION_INSERT
		If oModelZGD:getValue("ZGD_ATIVO")	== "S"	// VERIFICA SE ATIVO = S
			for nI := 1 to oModelZGE:Length()
				oModelZGE:GoLine( nI )
				if !oModelZGE:isDeleted()
					cTodosVend	+=	Iif(!Empty(cTodosVend),",'","'") + oModelZGE:getValue("ZGE_CODVEN") +"'"
				endif
			next
			lRet	:=	RetExist(oModelZGD:getValue("ZGD_CODIGO"),cTodosVend)
 		Endif
	endif

	FWRestRows( aSaveLines )
return lRet

//-------------------------------------------------------
// Verifica se existem vendedores em outra Gerencia Ativa
//-------------------------------------------------------
Static Function RetExist(cCodGru,cVendGru)
Local cQuery		:= ''
Local _lRet			:= .T.
Local cNextAlias	:= GetNextAlias()
Local cMsgVend	:=	""

cQuery  := ''
cQuery  += " SELECT ZGE_CODVEN,ZGD_CODIGO FROM "+RetSqlName("ZGE")+" ZGE "
cQuery  += " JOIN "+RetSqlName("ZGD")+" ZGD ON ZGD.D_E_L_E_T_ = ' ' "
cQuery  += " AND ZGD_CODIGO = ZGE_CODIGO AND ZGD_ATIVO = 'S' "
cQuery  += " WHERE ZGE.D_E_L_E_T_ = ' ' "
cQuery  += " AND ZGE_CODVEN IN ( "+cVendGru+") "
cQuery  += " AND ZGE_CODIGO <> '"+cCodGru+"' "
cQuery  += " ORDER BY ZGE_CODVEN

If Select(cNextAlias) > 0
	(cNextAlias)->(DbClosearea())
Endif

cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cNextAlias,.T.,.F.)
dbSelectArea(cNextAlias)
(cNextAlias)->(dbGoTop())

If ! (cNextAlias)->(Eof())
	While ! (cNextAlias)->(Eof())
		cMsgVend	+=	"Vendedor: "+(cNextAlias)->ZGE_CODVEN+" j� informado para outra Gerencia Comercial: "+(cNextAlias)->ZGD_CODIGO + CRLF
		(cNextAlias)->(Dbskip())
	Enddo
	Help( ,, 'Nao permitido',, cMsgVend, 1, 0 )
	_lRet			:= .F.
Endif

If Select(cNextAlias) > 0
	(cNextAlias)->(DbClosearea())
Endif

Return _lRet

/*
+------------------------------------------------------------------------------+
¦Programa  ¦BCANCEL  ¦ Autor ¦ "Wagner Neves"  - Marfrig  ¦ Data ¦ 31.10.2019¦
+----------+-------------------------------------------------------------------¦
*/
Static Function bCancel(oModel)
	RollBackSX8()
Return( .T. )
