#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH' 

//-------------------------------------------------------------------
/*/{Protheus.doc} MGFFIS30
GAP126 - Exceções para Documento de Entrada sem Pedido de Compra
Precisa também do ponto de entrada MT103TPC


@author Natanael Simões
@since 05/03/2018
@version P12.1.17
/*/
//-------------------------------------------------------------------
User Function MGFFIS30()

Local cUser := __cuserid
Local cUsersOK := SuperGetMV('MGF_FIS30U',.T.,'000000')//Códigos de usuário que podem acessar a rotina
Local oBrowse

If !(cUser $ cUsersOK)
	Help( ,, 'MGFFIS30',, 'Usuário sem permissão de acesso, parâmetro MGF_FIS30U (MFGFIS30)', 1, 0)
	Return
EndIf

oBrowse := FWMBrowse():New()
oBrowse:SetAlias('ZDO')
oBrowse:SetDescription('Exceção Doc. Entrada sem PC')
//oBrowse:DisableDetails()
oBrowse:Activate()

Return NIL

//-------------------------------------------------------------------
Static Function MenuDef()
Local aRotina := {}

ADD OPTION aRotina TITLE '&Visualizar' ACTION 'VIEWDEF.MGFFIS30' OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE '&Incluir'    ACTION 'VIEWDEF.MGFFIS30' OPERATION 3 ACCESS 0
ADD OPTION aRotina TITLE '&Alterar'    ACTION 'VIEWDEF.MGFFIS30' OPERATION 4 ACCESS 0
ADD OPTION aRotina TITLE '&Excluir'    ACTION 'VIEWDEF.MGFFIS30' OPERATION 5 ACCESS 0
ADD OPTION aRotina TITLE 'Im&primir'   ACTION 'VIEWDEF.MGFFIS30' OPERATION 8 ACCESS 0
ADD OPTION aRotina TITLE '&Copiar'     ACTION 'VIEWDEF.MGFFIS30' OPERATION 9 ACCESS 0
Return aRotina


//-------------------------------------------------------------------
Static Function ModelDef()
// Cria a estrutura a ser usada no Modelo de Dados
Local oStruZDO := FWFormStruct( 1, 'ZDO', /*bAvalCampo*/,/*lViewUsado*/ )
Local oModel
 
//oModel := MPFormModel():New('XMGFFIS30', /*bPreValidacao*/, { |oModel| COMP011POS( oModel ) }, /*bCommit*/, /*bCancel*/ )
oModel := FWModelActive()
oModel := MPFormModel():New('XMGFFIS30', /*bPreValidacao*/, { |oModel| COMP011POS( oModel ) }, /*bCommit*/, /*bCancel*/ )

// Adiciona ao modelo uma estrutura de formulário de edição por campo
oModel:AddFields( 'ZDOMASTER', /*cOwner*/, oStruZDO, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

// Adiciona a descricao do Modelo de Dados
oModel:SetDescription( 'Exceção Doc. Entrada sem PC' )

oModel:SetPrimaryKey({"ZDO_FILIAL+ZDO_SEQ"})

// Adiciona a descricao do Componente do Modelo de Dados
oModel:GetModel( 'ZDOMASTER' ):SetDescription( 'Exceção Doc. Entrada sem PC' )
		
// Liga a validação da ativacao do Modelo de Dados
//oModel:SetVldActivate( { |oModel| COMP011ACT( oModel ) } )

Return oModel


//-------------------------------------------------------------------
Static Function ViewDef()
// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
Local oModel   := FWLoadModel( 'MGFFIS30' )
// Cria a estrutura a ser usada na View
Local oStruZDO := FWFormStruct( 2, 'ZDO' )
//Local oStruZDO := FWFormStruct( 2, 'ZDO', { |cCampo| COMP11STRU(cCampo) } )
Local oView  
Local cCampos := {}

// Crio os Agrupamentos de Campos  
// AddGroup( cID, cTitulo, cIDFolder, nType )   nType => ( 1=Janela; 2=Separador )
oStruZDO:AddGroup( 'GRUPO01', 'Exceções', '', 2 )


// Altero propriedades dos campos da estrutura, no caso colocando cada campo no seu grupo
//
// SetProperty( <Campo>, <Propriedade>, <Valor> )
//
// Propriedades existentes para View (lembre-se de incluir o FWMVCDEF.CH):
//			MVC_VIEW_IDFIELD
//			MVC_VIEW_ORDEM
//			MVC_VIEW_TITULO
//			MVC_VIEW_DESCR
//			MVC_VIEW_HELP
//			MVC_VIEW_PICT
//			MVC_VIEW_PVAR
//			MVC_VIEW_LOOKUP
//			MVC_VIEW_CANCHANGE
//			MVC_VIEW_FOLDER_NUMBER
//			MVC_VIEW_GROUP_NUMBER
//			MVC_VIEW_COMBOBOX
//			MVC_VIEW_MAXTAMCMB
//			MVC_VIEW_INIBROW
//			MVC_VIEW_VIRTUAL
//			MVC_VIEW_PICTVAR	    
//
oStruZDO:SetProperty( '*'         , MVC_VIEW_GROUP_NUMBER, 'GRUPO01' ) 

// Cria o objeto de View
oView := FWFormView():New()

// Define qual o Modelo de dados será utilizado
oView:SetModel( oModel )

//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
oView:AddField( 'VIEW_ZDO', oStruZDO, 'ZDOMASTER' )

// Criar um "box" horizontal para receber algum elemento da view
oView:CreateHorizontalBox( 'TELA' , 100 )

// Relaciona o ID da View com o "box" para exibicao
oView:SetOwnerView( 'VIEW_ZDO', 'TELA' )

//oView:SetViewAction( 'BUTTONOK'    , { |o| Help(,,'HELP',,'Ação de Confirmar ' + o:ClassName(),1,0) } )
//oView:SetViewAction( 'BUTTONCANCEL', { |o| Help(,,'HELP',,'Ação de Cancelar '  + o:ClassName(),1,0) } )
Return oView


//-------------------------------------------------------------------
Static Function COMP011POS( oModel )
Local nOperation := oModel:GetOperation()
Local lRet       := .T.

If nOperation == 4
	If Empty( oModel:GetValue( 'ZDOMASTER', 'ZDO_SEQ' ) )
			   
			   
			   oModel:GetModel( 'ZDOMASTER' )
			   
			   
			   oModel:GetModel( 'ZDOMASTER' )
			   	
			   	
			   	
		Help( ,, 'MGFFIS30',, 'Informe a data', 1, 0)
		lRet := .F.
	EndIf
EndIf

// Inclusão dou alteração dos registros
If nOperation == 3 .or. nOperation == 4 
	// Valida se está todos os campos em branco
	If Vazio(M->ZDO_TIPOP) .AND. Vazio(M->ZDO_TES) .AND. Vazio(M->ZDO_USER) 
		Help( ,, 'MGFFIS30',, 'Todos os campos estão em branco', 1, 0)
		lRet := .F.
	EndIf
	
	// Valida se o cadastro já existe
	If !Vazio(Posicione("ZDO",2,xFilial("ZDO")+M->ZDO_USER+M->ZDO_TIPOP+M->ZDO_TES,"ZDO_SEQ"))
		Help( ,, 'MGFFIS30',, 'Registro/Combinação já existente na Base de Dados', 1, 0)
		lRet := .F.
	EndIf
	
EndIf

Return lRet

//-------------------------------------------------------------------
Static Function COMP011ACT( oModel )  // Passa o model sem dados
Local aArea      := GetArea()
Local cQuery     := ''
Local cTmp       := ''
Local lRet       := .T.
Local nOperation := oModel:GetOperation()

If nOperation == 5 .AND. lRet

/*	cTmp    := GetNextAlias()

	cQuery  := ""
	cQuery  += "SELECT ZDO_CODIGO FROM " + RetSqlName( 'ZDO' ) + " ZDO "
	cQuery  += " WHERE EXISTS ( "
	cQuery  += "       SELECT 1 FROM " + RetSqlName( 'ZA2' ) + " ZA2 "
	cQuery  += "        WHERE ZA2_AUTOR = ZDO_CODIGO"
	cQuery  += "          AND ZA2.D_E_L_E_T_ = ' ' ) "
	cQuery  += "   AND ZDO_CODIGO = '" + ZDO->ZDO_CODIGO  + "' "
	cQuery  += "   AND ZDO.D_E_L_E_T_ = ' ' "

	dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ) , cTmp, .F., .T. )

	lRet := (cTmp)->( EOF() )

	(cTmp)->( dbCloseArea() )

	If lRet
		cQuery  := ""
		cQuery  += "SELECT ZDO_CODIGO FROM " + RetSqlName( 'ZDO' ) + " ZDO "
		cQuery  += " WHERE EXISTS ( "
		cQuery  += "       SELECT 1 FROM " + RetSqlName( 'ZA5' ) + " ZA5 "
		cQuery  += "        WHERE ZA5_INTER = ZDO_CODIGO"
		cQuery  += "          AND ZA5.D_E_L_E_T_ = ' ' ) "
		cQuery  += "   AND ZDO_CODIGO = '" + ZDO->ZDO_CODIGO  + "' "
		cQuery  += "   AND ZDO.D_E_L_E_T_ = ' ' "

		dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ) , cTmp, .F., .T. )

		lRet := (cTmp)->( EOF() )

		(cTmp)->( dbCloseArea() )

	EndIf*/

	If !lRet
		Help( ,, 'MGFFIS30',, 'O Registro não pode ser excluído', 1, 0)
	EndIf

EndIf

RestArea( aArea )

Return lRet


//-------------------------------------------------------------------
Static Function COMP11STRU( cCampo )
Local lRet := .T.

If cCampo == 'ZDO_SEQ'
	lRet := .F.
EndIf

Return lRet
