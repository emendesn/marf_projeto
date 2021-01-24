#INCLUDE "totvs.ch"
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#INCLUDE "fwbrowse.ch"
#INCLUDE "fwmvcdef.ch"

#DEFINE CRLF Chr(13) + Chr(10)

/*
============================================================================================================================
Programa.:              MGFFIS61
Autor....:              Andr� Fracassi (DMS Consultoria)
Data.....:              08/07/2020
Descricao / Objetivo:   Manutencao Cadastro Layout CAT83
Doc. Origem:
Task.....:              RTASK0011379 - Projeto Fiscal - CAT83
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
============================================================================================================================
*/
User Function MGFFIS61()

	Local _oBrowse

	Public _aLogCpo := {}
	//Cria um Browse Simples instanciando o FWMBrowse
	_oBrowse := FWMBrowse():New()

	//Define um alias para o Browse
	_oBrowse:SetAlias("ZGN")

	//Adiciona uma descrição para o Browse
	_oBrowse:SetDescription( FWX2Nome("ZGN") )

	//Ativa o Browse
	_oBrowse:Activate()

Return( Nil )



/*
============================================================================================================================
Programa.:              MenuDef
Autor....:              Andr� Fracassi (DMS Consultoria)
Data.....:              08/07/2020
Descricao / Objetivo:
Doc. Origem:
Task.....:              RTASK0011379 - Projeto Fiscal - CAT83
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
============================================================================================================================
*/
Static Function MenuDef()

	Local _aRotina := {}

	//ADD OPTION _aRotina TITLE "Pesquisar"  ACTION "PesqBrw"			    OPERATION 1 ACCESS 0
	ADD OPTION _aRotina TITLE "Visualizar" ACTION "VIEWDEF.MGFFIS61"	OPERATION 2 ACCESS 0
	ADD OPTION _aRotina TITLE "Incluir"    ACTION "VIEWDEF.MGFFIS61"	OPERATION 3 ACCESS 0
	ADD OPTION _aRotina TITLE "Alterar"    ACTION "VIEWDEF.MGFFIS61"	OPERATION 4 ACCESS 0
	ADD OPTION _aRotina TITLE "Excluir"    ACTION "VIEWDEF.MGFFIS61"	OPERATION 5 ACCESS 0

Return( _aRotina )



/*
============================================================================================================================
Programa.:              ModelDef
Autor....:              Andr� Fracassi (DMS Consultoria)
Data.....:              08/07/2020
Descricao / Objetivo:   Defini��o do Modelo de Dados para cadastro
Doc. Origem:
Task.....:              RTASK0011379 - Projeto Fiscal - CAT83
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
============================================================================================================================
*/
Static Function ModelDef()

	// Cria a estrutura a ser usada no Modelo de Dados
	Local _oModel
	Local _oStruZGN := FWFormStruct( 1, "ZGN", /*bAvalCampo*/, /*lViewUsado*/ )
	Local _oStruZGO := FWFormStruct( 1, "ZGO", /*bAvalCampo*/, /*lViewUsado*/ )
	Local _nOperation

	// Cria o objeto do Modelo de Dados
	_oModel := MPFormModel():New("XMGFFIS61", /*bPreValidacao*/, /*bPosValidacao*/, /*{ |_oMdl| FIS61Commit( _oMdl ) }*/ /*bCommit*/, /*bCancel*/ )

	_nOperation := _oModel:GetOperation()
	Do Case
		Case _nOperation == MODEL_OPERATION_UPDATE
			AAdd( _aLogCpo, "Opera��o de Altera��o " + CRLF )
		Case _nOperation == MODEL_OPERATION_DELETE
			AAdd( _aLogCpo, "Opera��o de Exclus�o " + CRLF )
		OtherWise
			AAdd( _aLogCpo, " " + CRLF )
	EndCase

	// Adiciona ao modelo uma estrutura de formul�rio de edi��o por campo
	_oModel:AddFields( "ZGNMASTER", /*cOwner*/, _oStruZGN, { | _oModel, cAction, cIDField, xValue| FIS61Pre( _oModel, cAction, cIDField, xValue ) } /*bPre*/, /*bPost*/, /*bLoad*/ )
	_oModel:AddGrid( "ZGODETAIL", "ZGNMASTER", _oStruZGO, { | _oModel, _nLine, _cAction, _cCampo, _cNewValue, _cOldValue | FIS61LPre( _oModel, _nLine, _cAction, _cCampo, _cNewValue, _cOldValue ) } /*bLinePre*/,  /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*bLoad*/ )

	//Adiciona chave Prim�ria
	_oModel:SetPrimaryKey( {"ZGN_FILIAL", "ZGN_LAYOUT"} )

	// Adiciona rela��o entre cabe�alho e item
	_oModel:SetRelation( "ZGODETAIL", { {"ZGO_FILIAL", "xFilial('ZGO')"}, {"ZGO_LAYOUT", "ZGN_LAYOUT"} }, ZGO->( IndexKey( 1 ) ) )

	// Adiciona a descricao do Modelo de Dados
	_oModel:SetDescription( FWX2Nome("ZGN") )

	// Adiciona a descricao do Componente do Modelo de Dados
	_oModel:GetModel( "ZGNMASTER" ):SetDescription( FWX2Nome("ZGN") )
	_oModel:GetModel( "ZGODETAIL" ):SetDescription( FWX2Nome("ZGO") )

	// Valida a ativa��o do model
	_oModel:SetActivate( { |_oModel| FIS61SetAct( _oModel ) } )

Return( _oModel )



/*
============================================================================================================================
Programa.:              ViewDef
Autor....:              Andr� Fracassi (DMS Consultoria)
Data.....:              08/07/2020
Descricao / Objetivo:   Defini��o da View de Dados para cadastro
Doc. Origem:
Task.....:              RTASK0011379 - Projeto Fiscal - CAT83
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
============================================================================================================================
*/
Static Function ViewDef()

	// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	Local _oView
	Local _oModel   := FWLoadModel("MGFFIS61")

	// Cria a estrutura a ser usada na View
	Local _oStruZGN := FWFormStruct( 2, "ZGN")
	Local _oStruZGO := FWFormStruct( 2, "ZGO")

	// Cria o objeto de View e Define qual o Modelo de dados ser� utilizado
	_oView := FWFormView():New()
	_oView:SetModel( _oModel )

	//Adiciona no nosso View um controle do tipo FormFields
	_oView:AddField( "VIEW_ZGN", _oStruZGN, "ZGNMASTER" )
	_oView:AddGrid( "VIEW_ZGO", _oStruZGO, "ZGODETAIL" )

	// Removendo campo do grid
	_oStruZGO:RemoveField("ZGO_LAYOUT")

	// Criar um "box" horizontal para receber algum elemento da view
	_oView:CreateHorizontalBox( "SUPERIOR" , 30 )
	_oView:CreateHorizontalBox( "INFERIOR" , 70 )

	// Relaciona o ID da View com o "box" para exibicao
	_oView:SetOwnerView( "VIEW_ZGN", "SUPERIOR" )
	_oView:SetOwnerView( "VIEW_ZGO", "INFERIOR" )

	_oView:AddIncrementField( "VIEW_ZGO", "ZGO_SEQUEN" )

	// For�a o fechamento da janela na confirma��o
	_oView:SetCloseOnOk( { || .T. } )

Return( _oView )



/*/
    {Protheus.doc} FIS61SetAct
    Valida��o ap�s a ativa��o do model antes de apresenta��o da interface
    Carrega par�metros iniciais para Processamento
    @type  Static Function
    @author Andr� Fracassi (DMS Consultoria)
    @since 01/09/2020
    @version P12 12.1.17
    @param      _oMdl, Objeto   , Nome do Objeto
    @return     _lRet, Boolean  , True/False para controle de exclus�o
    @example
    (examples)
    @see (links_or_references)
    @history
    @obs TASK - RTASK0011379 - Projeto Fiscal - CAT83
    @menu Livros Fiscais-Atualiza��es-Especificos-CAT83-Processamento OP (SAFX10)
/*/
Static Function FIS61SetAct( _oMdl )

    local _lRet := .T.

	_aLogCpo := {}

Return( _lRet )



/*
============================================================================================================================
Programa.:              fSelecArq
Autor....:              Andr� Fracassi (DMS Consultoria)
Data.....:              08/07/2020
Descricao / Objetivo:   Respons�vel por retornar o diret�rio de grava��o dos arquivos
Doc. Origem:
Task.....:              RTASK0011379 - Projeto Fiscal - CAT83
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Chamada efetuada atrav�s do gatilho ZGN_DESCR
============================================================================================================================
*/
User Function fSelecArq()

	Local _oModel 	:= FwModelActive()
	Local _oMdlZGN	:= _oModel:GetModel("ZGNMASTER")
	Local _cDirDef	:= ""

	_cDirDef := cGetFile( "", "Selecione o Diret�rio", 0, "C:\", .F., GETF_LOCALHARD + GETF_RETDIRECTORY + GETF_NETWORKDRIVE )

	_oMdlZGN:LoadValue("ZGN_PATHGR", _cDirDef )

Return( _cDirDef )



/*
============================================================================================================================
Programa.:              FIS61Pre
Autor....:              Andr� Fracassi (DMS Consultoria)
Data.....:              01/09/2020
Descricao / Objetivo:   Respons�vel por verificar se houve algum ajuste no conteudo do campo. Caso positivo gera um log
Doc. Origem:
Task.....:              RTASK0011379 - Projeto Fiscal - CAT83
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
============================================================================================================================
*/
Static Function FIS61Pre( _oModelPre, _cAction, _cIDField, _xValue )

	Local _lRet			:= .T.
	Local _oModel       := FWModelActive()
	Local _oModelZGN 	:= _oModel:GetModel("ZGNMASTER")
	Local _nOperation 	:= _oModel:GetOperation()
	Local _cConteudo    := ""

	If _cAction == "SETVALUE"
		_cConteudo    := AllTrim( _oModelZGN:GetValue( _cIDField ) )
		If _cConteudo != _xValue
			AAdd( _aLogCpo, "Campo : " + _cIDField + ", Valor Anterior : " + cValToChar( _cConteudo ) + ", Valor Atual : " + cValToChar( _xValue ) + " " + CRLF )
		EndIf
	Endif

Return( _lRet )



/*
============================================================================================================================
Programa.:              FIS61Commit
Autor....:              Andr� Fracassi (DMS Consultoria)
Data.....:              01/09/2020
Descricao / Objetivo:   Respons�vel por verificar se houve algum ajuste no conteudo do campo. Caso positivo gera um log
Doc. Origem:
Task.....:              RTASK0011379 - Projeto Fiscal - CAT83
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
============================================================================================================================
*/
Static Function FIS61Commit( _oModelZGN )

	Local _lRet		:= .T.
	Local _nCont	:= 0
	Local _cLogCpo	:= ""

	For _nCont := 1 To Len( _aLogCpo )
		_cLogCpo += _aLogCpo[ _nCont ]
	Next

	DbSelectArea("ZGM")
	If RecLock("ZGM", .T. )
		ZGM->ZGM_FILIAL�:=�xFilial("ZGM")
		ZGM->ZGM_LAYOUT�:=�ZGN->ZGN_LAYOUT
		ZGM->ZGM_DATA���:=�Date()
		ZGM->ZGM_HORA���:=�Time()
		ZGM->ZGM_USER   := RetCodUsr()
		ZGM->ZGM_OPER���:=�"3"                  //1=Geracao Layout;2=Proc. SAFX10;3=Alteracao Layout
		ZGM->ZGM_LOG    := _cLogCpo
		ZGM->( MsUnLock() )
    EndIf

Return( _lRet )



/*
============================================================================================================================
Programa.:              FIS61LPre
Autor....:              Andr� Fracassi (DMS Consultoria)
Data.....:              01/09/2020
Descricao / Objetivo:   Respons�vel por verificar se houve algum ajuste no conteudo do campo. Caso positivo gera um log
Doc. Origem:
Task.....:              RTASK0011379 - Projeto Fiscal - CAT83
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
============================================================================================================================
*/
Static Function FIS61LPre( _oModelZGO, _nLine, _cAction, _cCampo, _cNewValue, _cOldValue )

	Local _lRet			:= .T.
	Local _oModel       := FWModelActive()
	Local _oModelZGO 	:= _oModel:GetModel("ZGODETAIL")
	Local _nOperation 	:= _oModel:GetOperation()
	Local _cColuna      := AllTrim( _oModelZGO:GetValue("ZGO_CAMPO") )

	If _cAction == "SETVALUE"
		If _cOldValue != _cNewValue
			AAdd( _aLogCpo, "Coluna : " + _cColuna + ", Campo : " + _cCampo + ", Valor Anterior : " + cValToChar( _cOldValue ) + ", Valor Atual : " + cValToChar( _cNewValue ) + " " + CRLF )
		EndIf
	Endif

Return( _lRet )
