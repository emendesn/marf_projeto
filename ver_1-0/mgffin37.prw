#Include 'Protheus.ch'
#INCLUDE "FWMVCDEF.CH"

/*
=====================================================================================
Programa............: MGFFIN37
Autor...............: Marcos Andrade
Data................: 26/10/2016
Descricao / Objetivo: Cadastro de Atendimento
Doc. Origem.........: Contrato - GAP CR025
Solicitante.........: Cliente
Uso.................: 
Obs.................: Tela de Cadastro das ocorrencias do titulo
================================================================='====================
*/
User Function MGFFIN37()

Local oMBrowse 	:= nil                      
Local cFilter	:= 	""
cFilter	:=" ZZB_FILIAL == '" +xFilial("ZZB")+ "' " 
cFilter	+=					" .AND. ZZB_FILORI 	== '" 	+ aListBox1[oListBox1:nAT,02] 	+ "' "
cFilter	+=					" .AND. ZZB_PREFIX 	== '" 	+ aListBox1[oListBox1:nAT,04]	+ "' "
cFilter	+=					" .AND. ZZB_NUM 	== '" 	+ aListBox1[oListBox1:nAT,03]	+ "' "
cFilter	+=					" .AND. ZZB_PARCEL 	== '" 	+ aListBox1[oListBox1:nAT,05] 	+ "' "
cFilter	+=					" .AND. ZZB_TIPO 	== '"	+ aListBox1[oListBox1:nAT,06] 	+ "' " 
				
dbselectArea('ZZB')
ZZB->(dbSetOrder(1))

oMBrowse:= FWmBrowse():New()
oMBrowse:SetAlias("ZZB")
oMBrowse:SetDescription('Acompanhamento de Atendimento')

oMBrowse:AddFilter('Flt. Chave',cFilter,.T.,.T.)


oMBrowse:SetMenuDef("MGFFIN37")
oMBrowse:Activate()

Return

/*
=====================================================================================
Programa............: MenuDef
Autor...............: Marcos Andrade
Data................: 26/10/2016
Descricao / Objetivo: MenuDef da rotina
Doc. Origem.........: Contrato - GAP CR025
Solicitante.........: Cliente
Uso.................: 
Obs.................: Definicao do Menu
=====================================================================================
*/
Static Function MenuDef()
	
	Local	aRotina	:= {}
	
	ADD OPTION aRotina TITLE "Pesquisar"  ACTION "PesqBrw"          OPERATION 1                      ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.MGFFIN37" OPERATION MODEL_OPERATION_VIEW   ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"    ACTION "VIEWDEF.MGFFIN37" OPERATION MODEL_OPERATION_INSERT ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"    ACTION "VIEWDEF.MGFFIN37" OPERATION MODEL_OPERATION_UPDATE ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"    ACTION "VIEWDEF.MGFFIN37" OPERATION MODEL_OPERATION_DELETE ACCESS 0
	
Return(aRotina)

/*
=====================================================================================
Programa............: ModelDef
Autor...............: Marcos Andrade
Data................: 26/10/2016
Descricao / Objetivo: ModelDef
Doc. Origem.........: Contrato - GAP CR025
Solicitante.........: Cliente                     
Uso.................: 
Obs.................: Definicao do Modelo de Dados para cadastro Classificacao de Perda
=====================================================================================
*/               

Static Function ModelDef()
	
	Local oModel	:= Nil
	Local oStrZZB 	:= FWFormStruct(1,"ZZB")
	Local _cNomUsr	:= cUserName
	Local aDadosUsu	:={}

	oStrZZB:setproperty("ZZB_FILORI"	, MODEL_FIELD_INIT, { || aListBox1[oListBox1:nAT,02] })	
	oStrZZB:setproperty("ZZB_PREFIX"	, MODEL_FIELD_INIT, { || aListBox1[oListBox1:nAT,04] })
	oStrZZB:setproperty("ZZB_NUM"		, MODEL_FIELD_INIT, { || aListBox1[oListBox1:nAT,03] })
	oStrZZB:setproperty("ZZB_PARCEL"	, MODEL_FIELD_INIT, { || aListBox1[oListBox1:nAT,05] })
	oStrZZB:setproperty("ZZB_TIPO"		, MODEL_FIELD_INIT, { || aListBox1[oListBox1:nAT,06] })
                                                               
	// Busca dados do usuario para saber qtos digitos usa no ANO.
	 PswOrder(2)
	 If PswSeek( _cNomUsr, .T. )
	   	aDadosUsu := PswRet() // Retorna vetor com informacoes do usuario
		oStrZZB:setproperty("ZZB_USUARI"		, MODEL_FIELD_INIT, { || aDadosUsu[1][1] })
		oStrZZB:setproperty("ZZB_USRNOM"		, MODEL_FIELD_INIT, { || aDadosUsu[1][2] })	
	 EndIf

	//oStrZZB:setproperty("ZZB_CLIENT"	, MODEL_FIELD_INIT, { || aListBox1[oListBox1:nAT,06] })	
	
	oModel := MPFormModel():New("XMGFFIN37", /*bPreValidacao*/,/*bPosValidacao*/,/*bCommit*/,/*bCancel*/ )
	oModel:AddFields("TRBMASTER",/*cOwner*/,oStrZZB, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )
	
	oModel:SetDescription('Acompanhamento de Atendimento')
	oModel:SetPrimaryKey({"ZZB_FILIAL","ZZB_PREFIX","ZZB_NUM","ZZB_PARCEL","ZZB_TIPO"})
	
Return(oModel)

/*
=====================================================================================
Programa............: ViewDef
Autor...............: Marcos Andrade
Data................: 26/10/2016
Descricao / Objetivo: ViewDef
Doc. Origem.........: Contrato - GAP CR025
Solicitante.........: Cliente
Uso.................: 
Obs.................: Definicao da visualizacao da tela
=====================================================================================
*/
Static Function ViewDef()
	
	Local oView		:= Nil
	Local oModel	:= FWLoadModel( 'MGFFIN37' )
	Local oStrZZB	:= FWFormStruct( 2,"ZZB" )
	
	oView := FWFormView():New()
	oView:SetModel(oModel)


	//oStrSZU:RemoveField( 'ZU_CODAPR' )

	
	oView:AddField( 'VIEW_ZZB' , oStrZZB, 'TRBMASTER' )
	
	oView:CreateHorizontalBox( 'TELA' , 100 )
	oView:SetOwnerView( 'VIEW_ZZB', 'TELA' )
	
Return oView