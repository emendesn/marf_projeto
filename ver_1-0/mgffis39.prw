#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH' 

//-------------------------------------------------------------------
/*/{Protheus.doc} MGFFIS39
GAP387 - Criar inteligencia no campo Cnae do cliente x Grupo de Tributação

@author Natanael Simões
@since 19/10/2018
@version P12.1.17
/*/
//-------------------------------------------------------------------
User Function MGFFIS39()
Local cUser := __cuserid
Local cUsersOK := SuperGetMV('MGF_FIS39B',.T.,'')//Códigos de usuário que podem acessar a rotina
Local oBrowse

If !(cUser $ cUsersOK) .AND. !EMPTY(cUsersOK)
	Help( ,, 'MGFFIS39',, 'Usuário sem permissão de acesso, parâmetro MGF_FIS39B (MGFFIS39)', 1, 0)
	Return
EndIf

oBrowse := FWMBrowse():New()
oBrowse:SetAlias('ZEA')
oBrowse:SetDescription('Regras de Aprov. Automática')
oBrowse:Activate()

Return NIL

//-------------------------------------------------------------------
Static Function MenuDef()
Local aRotina := {}

ADD OPTION aRotina TITLE '&Visualizar' ACTION 'VIEWDEF.MGFFIS39' OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE '&Incluir'    ACTION 'VIEWDEF.MGFFIS39' OPERATION 3 ACCESS 0
ADD OPTION aRotina TITLE '&Alterar'    ACTION 'VIEWDEF.MGFFIS39' OPERATION 4 ACCESS 0
ADD OPTION aRotina TITLE '&Excluir'    ACTION 'VIEWDEF.MGFFIS39' OPERATION 5 ACCESS 0
ADD OPTION aRotina TITLE 'Im&primir'   ACTION 'VIEWDEF.MGFFIS39' OPERATION 8 ACCESS 0
//ADD OPTION aRotina TITLE '&Copiar'     ACTION 'VIEWDEF.MGFFIS39' OPERATION 9 ACCESS 0 //Se habilitar a cópia, deve ser tratado o auto-incremental do ZEA_SEQ 
Return aRotina


//-------------------------------------------------------------------
Static Function ModelDef()
// Cria a estrutura a ser usada no Modelo de Dados
Local oStruZEA := FWFormStruct( 1, 'ZEA', /*bAvalCampo*/,/*lViewUsado*/ )
Local oModel
 

// Cria o objeto do Modelo de Dados
oModel := FWModelActive()
oModel := MPFormModel():New('XMGFFIS39', /*bPreValidacao*/, {|oModel|FIS39POS(oModel)} /*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )

// Adiciona ao modelo uma estrutura de formulário de edição por campo
oModel:AddFields( 'ZEAMASTER', /*cOwner*/, oStruZEA, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

// Adiciona a descricao do Modelo de Dados
oModel:SetDescription( 'Regras de Aprov. Automática' )
oModel:SetPrimaryKey({"ZEA_FILIAL+ZEA_SEQ"})

// Adiciona a descricao do Componente do Modelo de Dados
oModel:GetModel( 'ZEAMASTER' ):SetDescription( 'Regras de Aprov. Automática' )

Return oModel


//-------------------------------------------------------------------
Static Function ViewDef()
// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
Local oModel   := FWLoadModel('MGFFIS39')
// Cria a estrutura a ser usada na View
Local oStruZEA := FWFormStruct( 2, 'ZEA' )
Local oView
Local cCampos := {}

// Crio os Agrupamentos de Campos  
// AddGroup( cID, cTitulo, cIDFolder, nType )   nType => ( 1=Janela; 2=Separador )
oStruZEA:AddGroup( 'GRUPO01', 'Regras', '', 2 )

oStruZEA:SetProperty( '*'         , MVC_VIEW_GROUP_NUMBER, 'GRUPO01' )

// Cria o objeto de View
oView := FWFormView():New()

// Define qual o Modelo de dados será utilizado
oView:SetModel( oModel )

//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
oView:AddField('VIEW_ZEA', oStruZEA, 'ZEAMASTER')

// Criar um "box" horizontal para receber algum elemento da view
oView:CreateHorizontalBox( 'TELA' , 100 )

// Relaciona o ID da View com o "box" para exibicao
oView:SetOwnerView( 'VIEW_ZEA', 'TELA' )

Return oView


//-------------------------------------------------------------------
Static Function FIS39POS( oModel )
Local nOperation := oModel:GetOperation()
Local lRet       := .T.
Local cTmp
Local cQuery

Local cCnae
Local cCliFor
Local cGRPTRI   // para cliente / fornecedor
Local cGRTRIB  // para produto

Local cSeq
Local cGrupo
Local cTipo
Local cTec
Local cEx_NCM
Local cOrigem

Local cPessoa
Local cZtpfor
local cSimnac
local cInscr
Local cEst
Local cAtvFor
Local cAtvCli
local cSufram
Local cAntSeq

cCnae	 := oModel:GetValue( 'ZEAMASTER', 'ZEA_CNAE' )
cCliFor	 := oModel:GetValue( 'ZEAMASTER', 'ZEA_CLIFOR' )
cGRPTRI  := oModel:GetValue( 'ZEAMASTER', 'ZEA_GRPTRI' )
cGRTRIB  := oModel:GetValue( 'ZEAMASTER', 'ZEA_GRTRIB' )

if cCliFor $"C/F" .and. (empty(cGRPTRI) .or. empty(cCnae))
	Help( ,, 'HELP',, 'Campo vazio - Cliente/Fornecedor necessita  CNAE e GrpTri Preenchido.', 1, 0)
	lRet := .F.
elseif cCliFor = "P" .and. empty(cGRTRIB)
	Help( ,, 'HELP',, 'Campo vazio - Produto necessita  GrTrib Preenchido.', 1, 0)
	lRet := .F.
endif

if lRet // testa se ja existe a regra cadastrada
	if cCliFor = "P" .AND. (nOperation = 3 .or. nOperation = 4)
		cSeq	:= oModel:GetValue( 'ZEAMASTER', 'ZEA_SEQ' )
		cGrupo	:= oModel:GetValue( 'ZEAMASTER', 'ZEA_GRUPO' )
		cTipo	:= oModel:GetValue( 'ZEAMASTER', 'ZEA_TIPO' )
		cTec	:= oModel:GetValue( 'ZEAMASTER', 'ZEA_TEC' )
		cEx_NCM	:= oModel:GetValue( 'ZEAMASTER', 'ZEA_EX_NCM' )
		cOrigem	:= oModel:GetValue( 'ZEAMASTER', 'ZEA_ORIGEM' )

		cTmp    := GetNextAlias()

		cQuery := "SELECT ZEA_SEQ , ZEA_TIPO||ZEA_GRUPO||ZEA_TEC||ZEA_EX_NCM||ZEA_ORIGEM||ZEA_GRTRIB XChave "
		cQuery += " FROM " + RetSqlName("ZEA") + " ZEA "
		cQuery += " WHERE ZEA_FILIAL = '" + xFilial("ZEA") +"' "
		cQuery += " AND ZEA_GRUPO = '" + cGrupo + "' "
		cQuery += " AND ZEA_TIPO = '" + cTipo + "' "
		cQuery += " AND ZEA_TEC = '" + cTec + "' "
		cQuery += " AND ZEA_EX_NCM = '" + cEx_NCM  + "' " 
		cQuery += " AND ZEA_ORIGEM = '" + cOrigem + "' "
		cQuery += " AND ZEA_GRTRIB = '" + cGRTRIB + "' "
		IF nOperation = 4
			cQuery += " AND ZEA_SEQ <> '" + cSeq + "' "
		endif
		cQuery += " AND ZEA.D_E_L_E_T_ = ' ' "

		dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ) , cTmp, .F., .T. )

		lRet := (cTmp)->( EOF() )

		cAntSeq := (cTmp)->ZEA_SEQ

		(cTmp)->( dbCloseArea() )
		
		if !lRet
			Help( ,, 'HELP',, 'Já existe essa regra cadastrada. Seq ' + cAntSeq , 1, 0)
		endif

	endif

	if cCliFor $"C/F" .AND. (nOperation = 3 .or. nOperation = 4)
		cSeq	:= oModel:GetValue( 'ZEAMASTER', 'ZEA_SEQ' )
		cPessoa	:= oModel:GetValue( 'ZEAMASTER', 'ZEA_PESSOA' )
		cZtpfor	:= oModel:GetValue( 'ZEAMASTER', 'ZEA_ZTPFOR' )
		cSimnac	:= oModel:GetValue( 'ZEAMASTER', 'ZEA_SIMNAC' )
		cInscr	:= oModel:GetValue( 'ZEAMASTER', 'ZEA_INSCR' )
		cEst	:= oModel:GetValue( 'ZEAMASTER', 'ZEA_EST' )
		cAtvCli	:= oModel:GetValue( 'ZEAMASTER', 'ZEA_ATVCLI' )
		cAtvFor	:= oModel:GetValue( 'ZEAMASTER', 'ZEA_ATVFOR' )
		cSufram	:= oModel:GetValue( 'ZEAMASTER', 'ZEA_SUFRAM' )
		cNature	:= oModel:GetValue( 'ZEAMASTER', 'ZEA_NATURE' )
		

		cTmp    := GetNextAlias()

		cQuery := "SELECT ZEA_SEQ, ZEA_TIPO||ZEA_GRUPO||ZEA_TEC||ZEA_EX_NCM||ZEA_ORIGEM||ZEA_GRTRIB XChave "
		cQuery += " FROM " + RetSqlName("ZEA") + " ZEA "
		cQuery += " WHERE ZEA_FILIAL = '" + xFilial("ZEA") +"' "
		cQuery += " AND ZEA_CNAE = '" + cCnae + "' "
		cQuery += " AND ZEA_PESSOA = '" + cPessoa + "' "
		cQuery += " AND ZEA_SIMNAC = '" + cSimnac + "' "
		cQuery += " AND ZEA_INSCR = '" + cInscr  + "' " 
		cQuery += " AND ZEA_EST = '" + cEst + "' "
		cQuery += " AND ZEA_GRPTRI = '" + cGRPTRI + "' "
		cQuery += " AND ZEA_NATURE = '" + cNature + "' "
		if cCliFor = "C"
			cQuery += " AND ZEA_SUFRAM = '" + cSufram + "' "
			cQuery += " AND ZEA_ATVCLI = '" + cAtvCli + "' "
			cQuery += " AND ZEA_CLIFOR = 'C' "
		else
			cQuery += " AND ZEA_ZTPFOR = '" + cZtpfor + "' "
			cQuery += " AND ZEA_ATVFOR = '" + cAtvFor + "' "
			cQuery += " AND ZEA_CLIFOR = 'F' "
		endif
		IF nOperation = 4
			cQuery += " AND ZEA_SEQ <> '" + cSeq + "' "
		endif
		cQuery += " AND ZEA.D_E_L_E_T_ = ' ' "

		dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ) , cTmp, .F., .T. )

		lRet := (cTmp)->( EOF() )

		cAntSeq := (cTmp)->ZEA_SEQ

		(cTmp)->( dbCloseArea() )
		
		if !lRet
			Help( ,, 'HELP',, 'Já existe essa regra cadastrada. Seq ' + cAntSeq, 1, 0)
		endif

	endif


endif

Return lRet

//-------------------------------------------------------------------
Static Function FIS39ACT( oModel )  // Passa o model sem dados
Local aArea      := GetArea()
Local cQuery     := ''
Local cTmp       := ''
Local lRet       := .T.
Local nOperation := oModel:GetOperation()

If nOperation == 5 .AND. lRet

	cTmp    := GetNextAlias()

	cQuery  := ""
	cQuery  += "SELECT ZA0_CODIGO FROM " + RetSqlName( 'ZA0' ) + " ZA0 "
	cQuery  += " WHERE EXISTS ( "
	cQuery  += "       SELECT 1 FROM " + RetSqlName( 'ZA2' ) + " ZA2 "
	cQuery  += "        WHERE ZA2_AUTOR = ZA0_CODIGO"
	cQuery  += "          AND ZA2.D_E_L_E_T_ = ' ' ) "
	cQuery  += "   AND ZA0_CODIGO = '" + ZA0->ZA0_CODIGO  + "' "
	cQuery  += "   AND ZA0.D_E_L_E_T_ = ' ' "

	dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ) , cTmp, .F., .T. )

	lRet := (cTmp)->( EOF() )

	(cTmp)->( dbCloseArea() )

	If lRet
		cQuery  := ""
		cQuery  += "SELECT ZA0_CODIGO FROM " + RetSqlName( 'ZA0' ) + " ZA0 "
		cQuery  += " WHERE EXISTS ( "
		cQuery  += "       SELECT 1 FROM " + RetSqlName( 'ZA5' ) + " ZA5 "
		cQuery  += "        WHERE ZA5_INTER = ZA0_CODIGO"
		cQuery  += "          AND ZA5.D_E_L_E_T_ = ' ' ) "
		cQuery  += "   AND ZA0_CODIGO = '" + ZA0->ZA0_CODIGO  + "' "
		cQuery  += "   AND ZA0.D_E_L_E_T_ = ' ' "

		dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ) , cTmp, .F., .T. )

		lRet := (cTmp)->( EOF() )

		(cTmp)->( dbCloseArea() )

	EndIf

	If !lRet
		Help( ,, 'HELP',, 'Este Autor/interprete nao pode ser excluido.', 1, 0)
	EndIf

EndIf

RestArea( aArea )

Return lRet
