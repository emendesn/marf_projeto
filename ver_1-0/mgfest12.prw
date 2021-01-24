#include 'totvs.ch'
#include 'protheus.ch'
#include 'topconn.ch'
#include 'fwmvcdef.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} MGFEST12

Tela de cadastro da AmarraÃ§Ã£o ArmazÃ©ns x Unidades

@author Gustavo Ananias Afonso
@since 06/09/2016
/*/
//-------------------------------------------------------------------
user function MGFEST12()
	local oBrowse       
	
	cGetEmpres := cEmpAnt
	cEmpSav := cEmpAnt
	cFilSav := cFilAnt
	
	// variavel usada nas consultas padrao da XX8
	cRetXX8 := ""
	cRetXX8Fil := ""
	
    //Cria um Browse Simples instanciando o FWMBrowse
	oBrowse := FWMBrowse():New()
	//Define um alias para o Browse
	oBrowse:SetAlias('SZ4')
	//Adiciona uma descriÃ§Ã£o para o Browse
	oBrowse:SetDescription('Amarração Armazéns x Unidades')

	/*Define legenda para o Browse de acordo com uma variavel
	   Obs: Para visuzalir as legenda em MVC basta dar duplo clique no marcador de legenda*/
	//oBrowse:AddLegend( "ZA0_TIPO=='1'", "YELLOW", "Autor"  )
	//oBrowse:AddLegend( "ZA0_TIPO=='2'", "BLUE"  , "Interprete"  )      
	//Ativa o Browse
	oBrowse:Activate()

return nil

//-------------------------------------------------------------------
static function MenuDef()
	local aRotina := {}

	ADD OPTION aRotina TITLE 'Pesquisar'  ACTION 'PesqBrw'			OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.MGFEST12'	OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.MGFEST12'	OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.MGFEST12'	OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.MGFEST12'	OPERATION 5 ACCESS 0

return aRotina

//-------------------------------------------------------------------
Static Function ModelDef()
	// Cria a estrutura a ser usada no Modelo de Dados
	Local oStruSZ4 := FWFormStruct( 1, 'SZ4', /*bAvalCampo*/,/*lViewUsado*/ )
	Local oModel
	                         
	// Cria o objeto do Modelo de Dados
	oModel := MPFormModel():New('MGF12MODEL', /*bPreValidacao*/, /*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )
	
	// Adiciona ao modelo uma estrutura de formulÃ¡rio de ediÃ§Ã£o por campo
	oModel:AddFields( 'SZ4MASTER', /*cOwner*/, oStruSZ4, /*bPreValidacao*/, {|oModel| U_Est12VPos(oModel)} /*bPosValidacao*/, /*bCarga*/ )

	// Adiciona a descricao do Modelo de Dados
	oModel:SetDescription( 'Modelo de Amarração Armazéns x Unidades' )
	
	// Adiciona a descricao do Componente do Modelo de Dados
	oModel:GetModel( 'SZ4MASTER' ):SetDescription( 'Dados de Amarração Armazéns x Unidades' )
	
	oModel:SetPrimaryKey({})
	/*
	oStruSZ4:SetProperty("Z4_EMPRESA",MODEL_FIELD_VALID,{|| cEmpAnt:=M->Z4_EMPRESA,.T.})
	oStruSZ4:SetProperty("Z4_UNIDADE",MODEL_FIELD_VALID,{|| cFilAnt:=M->Z4_UNIDADE,.T.})
	*/
Return oModel

//-------------------------------------------------------------------
Static Function ViewDef()
	// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	Local oModel   := FWLoadModel( 'MGFEST12' )
	// Cria a estrutura a ser usada na View
	Local oStruSZ4 := FWFormStruct( 2, 'SZ4' )
	Local oView  

	// Cria o objeto de View
	oView := FWFormView():New()

	// Define qual o Modelo de dados serÃ¡ utilizado
	oView:SetModel( oModel )

	//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
	oView:AddField( 'VIEW_SZ4', oStruSZ4, 'SZ4MASTER' )

	// Criar um "box" horizontal para receber algum elemento da view
	oView:CreateHorizontalBox( 'TELA' , 100 )

	// Relaciona o ID da View com o "box" para exibicao
	oView:SetOwnerView( 'VIEW_SZ4', 'TELA' )
Return oView


// validacao do ok do modelo de dados
User Function Est12VPos(oModel)

Local aArea := {SM0->(GetArea()),NNR->(GetArea()),XX8->(GetArea()),GetArea()}
Local lRet := .T.

If lRet
	If oModel:GetOperation() == MODEL_OPERATION_UPDATE
		if chkSZ5(oModel)
			Help( ,, 'Help',, 'Este cadastro possui um processo de Transferência em andamento e não poderá ser alterado. Finalize os processos em andamento para alterar este cadastro.', 1, 0 )
			lRet := .F.
		endif
	endif
endif

// valida se armazém de origem já possui registro cadastrado
If lRet
	If oModel:GetOperation() == MODEL_OPERATION_INSERT
		If !Empty(oModel:GetValue("Z4_LOCAL")) 
			If Posicione("SZ4",1,xFilial("SZ4")+oModel:GetValue("Z4_LOCAL"),"Z4_LOCAL") == oModel:GetValue("Z4_LOCAL")
				Help( ,, 'Help',, 'Armazém Origem - Já existe cadastro de amarração', 1, 0 )
				lRet := .F.
			Endif	
		Endif
	Endif	
Endif

// valida se empresa/filial destino eh igual a origem
If lRet
	If Alltrim(oModel:GetValue("Z4_EMPRESA")) = cEmpAnt .and. Alltrim(oModel:GetValue("Z4_UNIDADE")) = cFilAnt
		Help( ,, 'Help',, 'Empresa+Filial destino é igual a origem.', 1, 0 )
		lRet := .F.
	Endif
Endif

// valida se existe empresa/filial destino 
If lRet
	If !Empty(oModel:GetValue("Z4_EMPRESA")) .And. !Empty(oModel:GetValue("Z4_UNIDADE"))
		//If GetAdvFVal("SM0","M0_CODFIL",oModel:GetValue("Z4_EMPRESA")+oModel:GetValue("Z4_UNIDADE"),1,"") != oModel:GetValue("Z4_UNIDADE")
		XX8->(dbSetOrder(3))
		If XX8->(!dbSeek(Padr(FWGrpCompany(),Len(XX8->XX8_GRPEMP))+Padr(oModel:GetValue("Z4_EMPRESA"),Len(XX8->XX8_EMPR))+Padr(Subs(oModel:GetValue("Z4_UNIDADE"),3),Len(XX8->XX8_CODIGO)))) .or. ;
		Alltrim(oModel:GetValue("Z4_EMPRESA")) != Subs(oModel:GetValue("Z4_UNIDADE"),1,2)
			Help( ,, 'Help',, 'Empresa+Filial não cadastrada.', 1, 0 )
			lRet := .F.
		Endif
	EndIf
Endif

// retirado em 13/06/17, pois cadastro de armazens passou a ser compartilhado
/* 	
// valida armazem com empresa e filial
If lRet
	NNR->(dbSetOrder(1))
	If NNR->(!dbSeek(Alltrim(oModel:GetValue("Z4_UNIDADE"))+Alltrim(oModel:GetValue("Z4_LOCDEST"))))
		Help( ,, 'Help',, 'Armazém Destino não cadastrado para esta Empresa+Filial.', 1, 0 )
		lRet := .F.
	Endif	
Endif
*/

// valida CNPJ de cliente, tem que ser o mesmo da empresa/filial destino
If lRet
	If !Empty(oModel:GetValue("Z4_CODCLI")) 
		//If Posicione("SA1",1,xFilial("SA1")+oModel:GetValue("Z4_CODCLI")+oModel:GetValue("Z4_LOJACLI"),"A1_CGC") != SM0->M0_CGC
		If GetAdvFVal("SA1","A1_CGC",xFilial("SA1")+oModel:GetValue("Z4_CODCLI")+oModel:GetValue("Z4_LOJACLI"),1,"") != ;
			GetAdvFVal("SM0","M0_CGC",FWGrpCompany()+oModel:GetValue("Z4_UNIDADE"),1,"")
			Help( ,, 'Help',, 'CNPJ do cliente não é igual ao da Empresa/Filial destino', 1, 0 )
			lRet := .F.
		Endif	
	Endif
Endif	

// valida CNPJ de fornecedor, tem que ser o mesmo da empresa/filial origem	
// obs: realizar esta validacao sempre com o SM0 posicionado na filial de origem
If lRet
	If !Empty(oModel:GetValue("Z4_CODFOR")) 
		If Posicione("SA2",1,xFilial("SA2")+oModel:GetValue("Z4_CODFOR")+oModel:GetValue("Z4_LOJAFOR"),"A2_CGC") != ; //SM0->M0_CGC
			GetAdvFVal("SM0","M0_CGC",FWGrpCompany()+cFilAnt,1,"")
			//GetAdvFVal("SM0","M0_CGC",oModel:GetValue("Z4_EMPRESA")+oModel:GetValue("Z4_UNIDADE"),1,"")
			Help( ,, 'Help',, 'CNPJ do fornecedor não é igual ao da Empresa/Filial origem', 1, 0 )
			lRet := .F.
		Endif	
	Endif
Endif
/*
// valida TES de remessa, deve ter controle de P3 - Remessa (F4_PODER3 = R)	
If lRet
	If !Empty(oModel:GetValue("Z4_TESREM")) 
		If Posicione("SF4",1,xFilial("SF4")+oModel:GetValue("Z4_TESREM"),"F4_PODER3") != "R"
			Help( ,, 'Help',, 'TES Remessa deve ter controle de terceiros, remessa', 1, 0 )
			lRet := .F.
		Endif	
	Endif
Endif

// valida TES de retorno, deve ter controle de P3 - Remessa (F4_PODER3 = D)	
If lRet
	If !Empty(oModel:GetValue("Z4_TESRET")) 
		If Posicione("SF4",1,xFilial("SF4")+oModel:GetValue("Z4_TESRET"),"F4_PODER3") != "D"
			Help( ,, 'Help',, 'TES Retorno deve ter controle de terceiros, retorno', 1, 0 )
			lRet := .F.
		Endif	
	Endif
Endif

// valida TES de remessa, deve ter controle de P3 - Remessa (F4_PODER3 = R)	
If lRet
	If !Empty(oModel:GetValue("Z4_TESREME")) 
		If Posicione("SF4",1,xFilial("SF4")+oModel:GetValue("Z4_TESREME"),"F4_PODER3") != "R"
			Help( ,, 'Help',, 'TES Remessa (Entrada) deve ter controle de terceiros, remessa', 1, 0 )
			lRet := .F.
		Endif	
	Endif
Endif

// valida TES de retorno, deve ter controle de P3 - Remessa (F4_PODER3 = D)	
If lRet
	If !Empty(oModel:GetValue("Z4_TESRETE")) 
		If Posicione("SF4",1,xFilial("SF4")+oModel:GetValue("Z4_TESRETE"),"F4_PODER3") != "D"
			Help( ,, 'Help',, 'TES Retorno (Entrada) deve ter controle de terceiros, retorno', 1, 0 )
			lRet := .F.
		Endif	
	Endif
Endif
*/
aEval(aArea,{|x| RestArea(x)})
	
Return(lRet)

//----------------------------------------------------------------
// Verifica se existe transferência entre filiais em andamento para o cadastro alterado
//----------------------------------------------------------------
static function chkSZ5( oModel )
	local cQrySZ5 := ""
	local lRetSZ5 := .F.

	cQrySZ5 := "SELECT *"
	cQrySZ5 += " FROM " + retSQLName("SZ5") + " SZ5"
	cQrySZ5 += " WHERE"
	cQrySZ5 += " "
	cQrySZ5 += " 		( ( Z5_NUMNF = ' ' AND Z5_NUMNFEN = ' ' ) OR ( Z5_NUMNF <> ' ' AND Z5_NUMNFEN = ' ' ) )"
	cQrySZ5 += " 	AND	SZ5.Z5_UNIDADE	=	'" + oModel:GetValue("Z4_UNIDADE")	+ "'"
	cQrySZ5 += " 	AND SZ5.Z5_LOCDEST	=	'" + oModel:GetValue("Z4_LOCDEST")	+ "'"
	cQrySZ5 += " 	AND	SZ5.Z5_EMPRESA	=	'" + oModel:GetValue("Z4_EMPRESA")	+ "'"
	cQrySZ5 += " 	AND	SZ5.Z5_FILIAL	=	'" + xFilial("SZ5")					+ "'"
	cQrySZ5 += " 	AND	SZ5.D_E_L_E_T_	<>	'*'"

	TcQuery cQrySZ5 New Alias "QRYSZ5"

	if !QRYSZ5->(EOF())
		lRetSZ5 := .T.
	endif

	QRYSZ5->(DBCloseArea())
/*
aAdd(aCores,    { 'Empty(Z5_NUMNF) .and. Empty(Z5_NUMNFEN)'    	, 'ENABLE'})
aAdd(aCores,    { '!Empty(Z5_NUMNF) .and. Empty(Z5_NUMNFEN)' 	, 'BR_AMARELO'})
aAdd(aCores,    { '!Empty(Z5_NUMNF) .and. !Empty(Z5_NUMNFEN)'	, 'DISABLE'})
*/

return lRetSZ5