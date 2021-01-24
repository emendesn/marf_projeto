#include 'protheus.ch'
#include 'fwmvcdef.ch'

/*
=====================================================================================
Programa.:              MGFFIS10
Autor....:              Gustavo Ananias Afonso
Data.....:              10/11/2016
Descricao / Objetivo:   Ajuste Fiscal
Doc. Origem:            GAP FIS040
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Manutenção no cadastro de fornecedores
=====================================================================================
*/
User Function MGFFIS10()
	local aArea		:= getArea()
	local aAreaSA2	:= SA2->(getArea())
	local aButtons := {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.T.,"Salvar"},{.T.,"Cancelar"},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil}}
	local cUsuario := SuperGetMv("MGF_UFIS40",.F.,"000000",)

	If !(RetCodUsr() $ cUsuario)
		MsgInfo("Usuário sem permissão para alteração.","Atenção!")
		Return 
	Else
		DBSelectArea("SA2")
		SA2->(DBGoTop())

		if SA2->( DBSeek( xFilial("SA2") + SF1->(F1_FORNECE + F1_LOJA) ) )
			//UPDATE/ exclusao precisa estar possicionado
			fwExecView("Alteração", "MGFFIS10", MODEL_OPERATION_UPDATE,, {|| .T.}, , ,aButtons)//"AlteraÃ§Ã£o"
		else
			msgAlert("Fornecedor da Nota não encontrado!")
		endif

		SA2->(DBCloseArea())

		restArea(aAreaSA2)
		restArea(aArea)
	Endif
return

//-----------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------
static function ModelDef()
	local oModel	:= nil
	local oStrSA2 	:= FWFormStruct(1,"SA2")

	oStrSA2:SetProperty( '*'			, MODEL_FIELD_WHEN,{||.F.}) //* PARA TODOS OS CAMPOS
	oStrSA2:SetProperty( 'A2_END'		, MODEL_FIELD_WHEN,{||.T.})
	oStrSA2:SetProperty( 'A2_BAIRRO'	, MODEL_FIELD_WHEN,{||.T.})
	oStrSA2:SetProperty( 'A2_EST'		, MODEL_FIELD_WHEN,{||.T.})
	oStrSA2:SetProperty( 'A2_COD_MUN'	, MODEL_FIELD_WHEN,{||.T.})
	oStrSA2:SetProperty( 'A2_MUN'		, MODEL_FIELD_WHEN,{||.T.})
	oStrSA2:SetProperty( 'A2_CEP'		, MODEL_FIELD_WHEN,{||.T.})
	oStrSA2:SetProperty( 'A2_PAIS'		, MODEL_FIELD_WHEN,{||.T.})
	oStrSA2:SetProperty( 'A2_CODPAIS'	, MODEL_FIELD_WHEN,{||.T.})
	oStrSA2:SetProperty( 'A2_DDD'		, MODEL_FIELD_WHEN,{||.T.})
	oStrSA2:SetProperty( 'A2_TEL'		, MODEL_FIELD_WHEN,{||.T.})

	oModel := MPFormModel():New("XMGFFIS10", /*bPreValidacao*/,/*bPosValidacao*/, { | oModel | cmtSA2(oModel) }/*bCommit*/,/*bCancel*/ )
	oModel:AddFields("SA2MASTER",/*cOwner*/,oStrSA2, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

	oModel:SetDescription('Alteração do Fornecedor')
	//oModel:SetPrimaryKey({"ZZ5_FILIAL","ZZ5_CODIGO"}) // NecessÃ¡rio apenas quando nao X2_UNICO em branco

return(oModel)

//-----------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------
static function ViewDef()
	local oView		:= Nil
	local oModel	:= FWLoadModel( 'MGFFIS10' )
	local bFields	:= {|cCampo| Alltrim(cCampo) $ "A2_CODIGO|A2_END|A2_BAIRRO|A2_EST|A2_COD_MUN|A2_MUN|A2_CEP|A2_PAIS|A2_CODPAIS|A2_DDD|A2_TEL"}
	local oStrSA2	:= FWFormStruct( 2,"SA2", bFields)

	oView := FWFormView():New()
	oView:SetModel(oModel)

	oView:AddField( 'VIEW_SA2' , oStrSA2, 'SA2MASTER' )

	oView:CreateHorizontalBox( 'TELA' , 100 )
	oView:SetOwnerView( 'VIEW_SA2', 'TELA' )

Return oView

//-----------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------
static function cmtSA2(oModel)
	local lRetCommit	:= .T.
	local oMdlSA2		:= oModel:GetModel('SA2MASTER')
	local cTime			:= time()
	local dDate			:= dDataBase

	BEGIN TRANSACTION
		if oMdlSA2:getValue('A2_END') <> SA2->A2_END
			//MGFFIS12(cTbl, cSeek, nRecno, cTblAlter, nRecnoAlte, cField, cOld, cNew, dDate, cHour, cUser)
			U_MGFFIS12("SF1", SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO), SF1->(RECNO()), "SA2", SA2->(RECNO()), "A2_END", SA2->A2_END, oMdlSA2:getValue('A2_END'), dDate, cTime, usrFullName(retCodUsr()))
		endif

		if oMdlSA2:getValue('A2_BAIRRO') <> SA2->A2_BAIRRO
			U_MGFFIS12("SF1", SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO), SF1->(RECNO()), "SA2", SA2->(RECNO()), "A2_BAIRRO", SA2->A2_BAIRRO, oMdlSA2:getValue('A2_BAIRRO'), dDate, cTime, usrFullName(retCodUsr()))
		endif

		if oMdlSA2:getValue('A2_EST') <> SA2->A2_EST
			U_MGFFIS12("SF1", SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO), SF1->(RECNO()), "SA2", SA2->(RECNO()), "A2_EST", SA2->A2_EST, oMdlSA2:getValue('A2_EST'), dDate, cTime, usrFullName(retCodUsr()))
		endif

		if oMdlSA2:getValue('A2_COD_MUN') <> SA2->A2_COD_MUN
			U_MGFFIS12("SF1", SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO), SF1->(RECNO()), "SA2", SA2->(RECNO()), "A2_COD_MUN", SA2->A2_COD_MUN, oMdlSA2:getValue('A2_COD_MUN'), dDate, cTime, usrFullName(retCodUsr()))
		endif

		if oMdlSA2:getValue('A2_MUN') <> SA2->A2_MUN
			U_MGFFIS12("SF1", SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO), SF1->(RECNO()), "SA2", SA2->(RECNO()), "A2_MUN", SA2->A2_MUN, oMdlSA2:getValue('A2_MUN'), dDate, cTime, usrFullName(retCodUsr()))
		endif

		if oMdlSA2:getValue('A2_CEP') <> SA2->A2_CEP
			U_MGFFIS12("SF1", SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO), SF1->(RECNO()), "SA2", SA2->(RECNO()), "A2_CEP", SA2->A2_CEP, oMdlSA2:getValue('A2_CEP'), dDate, cTime, usrFullName(retCodUsr()))
		endif

		if oMdlSA2:getValue('A2_PAIS') <> SA2->A2_PAIS
			U_MGFFIS12("SF1", SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO), SF1->(RECNO()), "SA2", SA2->(RECNO()), "A2_PAIS", SA2->A2_PAIS, oMdlSA2:getValue('A2_PAIS'), dDate, cTime, usrFullName(retCodUsr()))
		endif

		if oMdlSA2:getValue('A2_CODPAIS') <> SA2->A2_CODPAIS
			U_MGFFIS12("SF1", SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO), SF1->(RECNO()), "SA2", SA2->(RECNO()), "A2_CODPAIS", SA2->A2_CODPAIS, oMdlSA2:getValue('A2_CODPAIS'), dDate, cTime, usrFullName(retCodUsr()))
		endif

		if oMdlSA2:getValue('A2_DDD') <> SA2->A2_DDD
			U_MGFFIS12("SF1", SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO), SF1->(RECNO()), "SA2", SA2->(RECNO()), "A2_DDD", SA2->A2_DDD, oMdlSA2:getValue('A2_DDD'), dDate, cTime, usrFullName(retCodUsr()))
		endif

		if oMdlSA2:getValue('A2_TEL') <> SA2->A2_TEL
			U_MGFFIS12("SF1", SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO), SF1->(RECNO()), "SA2", SA2->(RECNO()), "A2_TEL", SA2->A2_TEL, oMdlSA2:getValue('A2_TEL'), dDate, cTime, usrFullName(retCodUsr()))
		endif

		fwFormCommit(oModel)
	END TRANSACTION
return lRetCommit