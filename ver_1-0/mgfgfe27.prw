#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*
=========================================================================================================
Programa.................: MGFGFE27
Autor:...................: Flávio Dentello
Data.....................: 16/06/2018
Descrição / Objetivo.....: Cadastro Regras para TES
Doc. Origem..............: 
Solicitante..............: Cliente
Uso......................: Marfrig
Obs......................: 
=========================================================================================================
*/

User Function MGFGFE27

	Local oMBrowse := nil
	Local aAux := {}
	oMBrowse:= FWmBrowse():New()

	oMBrowse:SetAlias("ZE5")
	oMBrowse:SetDescription("Cadastro Regras para TES")
	oMBrowse:Setmenudef("MGFGFE27")
	
	oMBrowse:Activate()
	
Return

**********************************************************
Static Function MenuDef()
	
	Local	aRotina	:= {}
	
	ADD OPTION aRotina TITLE "Pesquisar"  	  ACTION "PesqBrw"          OPERATION 1                      ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 	  ACTION "VIEWDEF.MGFGFE27" OPERATION MODEL_OPERATION_VIEW   ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"    	  ACTION "VIEWDEF.MGFGFE27" OPERATION MODEL_OPERATION_INSERT ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"    	  ACTION "VIEWDEF.MGFGFE27" OPERATION MODEL_OPERATION_UPDATE ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"    	  ACTION "VIEWDEF.MGFGFE27" OPERATION MODEL_OPERATION_DELETE ACCESS 0
	
Return aRotina
**********************************************************
Static Function ModelDef()

Local oStruZE5 := FWFormStruct( 1, 'ZE5', /*bAvalCampo*/,/*lViewUsado*/ )
Local oModel

oModel := MPFormModel():New('XMGFGFE27', /*bPreValidacao*/,{|oModel| U_GFE27V(oModel) } , /*bCommit*/, /*bCancel*/ )

oModel:AddFields( 'ZE5MASTER', /*cOwner*/, oStruZE5, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

oModel:SetDescription( 'Cadastro Regras para TES' )

oModel:SetPrimaryKey({"ZE5_FILIAL","ZE5_GRUPO","ZE5_TPMOV","ZE5_UFTRP","ZE5_FORNEC","ZE5_LOJA","ZE5_TRANSP","ZE5_TPDF","ZE5_REGIME"})

oModel:GetModel( 'ZE5MASTER' ):SetDescription( 'Cadastro Regras para TES' )

Return oModel

**********************************************************
Static Function ViewDef()

Local oModel   := FWLoadModel( 'MGFGFE27' )
Local oStruZD3 := FWFormStruct( 2, 'ZE5' )
Local oView
Local cCampos := {}

oView := FWFormView():New()

oView:SetModel( oModel )

oView:AddField( 'VIEW_ZE5', oStruZD3, 'ZE5MASTER' )

oView:CreateHorizontalBox( 'TELA' , 100 )

oView:SetOwnerView( 'VIEW_ZE5', 'TELA' )

Return oView

**********************************************************
User Function GFE27V(oModel)

Local _lret := .T.
Local _cAlias     := GetNextAlias()
Local _cQuery := ""


_cQuery := 	" SELECT	ZE5_DESCR, R_E_C_N_O_ "
_cQuery +=	" FROM  " + retsqlname("ZE5")
_cQuery +=  " WHERE	D_E_L_E_T_ = ' '  AND R_E_C_N_O_ <> " + alltrim(str(ZE5->(Recno())))   
_cQuery +=  " AND	ZE5_FILIAL = '" + xfilial("ZE5") + "'"
_cQuery +=  " AND	ZE5_GRUPO = '" + oModel:GetValue( 'ZE5MASTER','ZE5_GRUPO' ) + "'"
_cQuery +=  " AND	ZE5_TPDOC = '" + oModel:GetValue( 'ZE5MASTER','ZE5_TPDOC' ) + "'"
_cQuery +=  " AND	ZE5_TPMOV = '" + oModel:GetValue( 'ZE5MASTER','ZE5_TPMOV' ) + "'"
_cQuery +=  " AND	ZE5_TPTRIB = '" + oModel:GetValue( 'ZE5MASTER','ZE5_TPTRIB' ) + "'"
_cQuery +=  " AND	ZE5_UFTRP = '" + oModel:GetValue( 'ZE5MASTER','ZE5_UFTRP' ) + "'"
_cQuery +=  " AND	ZE5_CONTR = '" + oModel:GetValue( 'ZE5MASTER','ZE5_CONTR' ) + "'"
_cQuery +=  " AND	ZE5_FORNEC = '" + oModel:GetValue( 'ZE5MASTER','ZE5_FORNEC' ) + "'"
_cQuery +=  " AND	ZE5_LOJA = '" + oModel:GetValue( 'ZE5MASTER','ZE5_LOJA' ) + "'"
_cQuery +=  " AND	ZE5_TRANSP = '" + oModel:GetValue( 'ZE5MASTER','ZE5_TRANSP' ) + "'"
_cQuery +=  " AND	ZE5_TPDF = '" + oModel:GetValue( 'ZE5MASTER','ZE5_TPDF' ) + "'"
_cQuery +=  " AND	ZE5_REGIME = '" + oModel:GetValue( 'ZE5MASTER','ZE5_REGIME' ) + "'"
_cQuery +=  " AND	ZE5_UFORI = '" + oModel:GetValue( 'ZE5MASTER','ZE5_UFORI' ) + "'"
_cQuery +=  " AND	ZE5_UFDES = '" + oModel:GetValue( 'ZE5MASTER','ZE5_UFDES' ) + "'"
_cQuery +=  " AND	ZE5_CONSUM = '" + oModel:GetValue( 'ZE5MASTER','ZE5_CONSUM' ) + "'"
_cQuery +=  " AND   ZE5_EXPORT = '" + oModel:GetValue( 'ZE5MASTER','ZE5_EXPORT' ) + "'"
_cQuery +=  " AND	ZE5_GRPTRI = '" + oModel:GetValue( 'ZE5MASTER','ZE5_GRPTRI' ) + "'"

DBUseArea( .T. , "TOPCONN" , TCGenQry( ,, _cQuery ) , _cAlias , .F. , .T. )

DBSelectArea(_cAlias)
(_cAlias)->(DBGotop())

If !(_cAlias)->(Eof()) 
    Help( ,, 'Atenção',, 'A regra ' + (_cAlias)->ZE5_DESCR +  ' já possui os mesmos parâmetros!', 1, 0 )
	_lret := .F.
Endif

(_cAlias)->(Dbclosearea())

Return _lret

