#include 'protheus.ch'
#include 'fwmvcdef.ch'

/*
=====================================================================================
Programa.:              MGFFIS06
Autor....:              Gustavo Ananias Afonso
Data.....:              09/11/2016
Descricao / Objetivo:   Ajuste Fiscal
Doc. Origem:            GAP FIS040
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Manutenção no cadastro de Transportadora
=====================================================================================
*/

User Function MGFFIS06()
	local aArea		:= getArea()
	local aAreaSA4	:= SA4->(getArea())
	local aButtons	:= {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.T.,"Salvar"},{.T.,"Cancelar"},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil}}
	local cUsuario := SuperGetMv("MGF_UFIS40",.F.,"000000",)

	If !(RetCodUsr() $ cUsuario)
		MsgInfo("Usuário sem permissão para alteração.","Atenção!")
		Return  
	Else
		DBSelectArea("SA4")
		SA4->(DBGoTop())

		if SA4->( DBSeek( xFilial("SA4") + SF2->F2_TRANSP ) )
			//UPDATE/ exclusao precisa estar possicionado
			fwExecView("Alteração", "MGFFIS06", MODEL_OPERATION_UPDATE,, {|| .T.}, , , aButtons)//"AlteraÃ§Ã£o"
		else
			msgAlert("Transportadora da Nota não encontrada!")
		endif

		SA4->(DBCloseArea())

		restArea(aAreaSA4)
		restArea(aArea)
	Endif
return

//-----------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------
static function ModelDef()
	local oModel	:= nil
	local oStrSA4 	:= FWFormStruct(1,"SA4")

	oStrSA4:SetProperty( '*'			, MODEL_FIELD_WHEN,{||.F.}) //* PARA TODOS OS CAMPOS
	oStrSA4:SetProperty( 'A4_END'		, MODEL_FIELD_WHEN,{||.T.})
	oStrSA4:SetProperty( 'A4_BAIRRO'	, MODEL_FIELD_WHEN,{||.T.})
	oStrSA4:SetProperty( 'A4_EST'		, MODEL_FIELD_WHEN,{||.T.})
	oStrSA4:SetProperty( 'A4_COD_MUN'	, MODEL_FIELD_WHEN,{||.T.})
	oStrSA4:SetProperty( 'A4_MUN'		, MODEL_FIELD_WHEN,{||.T.})
	oStrSA4:SetProperty( 'A4_CEP'		, MODEL_FIELD_WHEN,{||.T.})
	oStrSA4:SetProperty( 'A4_CODPAIS'	, MODEL_FIELD_WHEN,{||.T.})
	oStrSA4:SetProperty( 'A4_EMAIL'		, MODEL_FIELD_WHEN,{||.T.})
	oStrSA4:SetProperty( 'A4_DDD'		, MODEL_FIELD_WHEN,{||.T.})
	oStrSA4:SetProperty( 'A4_TEL'		, MODEL_FIELD_WHEN,{||.T.})

	oModel := MPFormModel():New("XMGFFIS06", /*bPreValidacao*/,/*bPosValidacao*/, { |oModel| cmtSA4(oModel) }/*bCommit*/,/*bCancel*/ )
	oModel:AddFields("SA4MASTER",/*cOwner*/,oStrSA4, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

	oModel:SetDescription('Alteração da Transportadora')
	//oModel:SetPrimaryKey({"ZZ5_FILIAL","ZZ5_CODIGO"}) // NecessÃ¡rio apenas quando nao X2_UNICO em branco

return(oModel)

//-----------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------
static function ViewDef()
	local oView		:= Nil
	local oModel	:= FWLoadModel( 'MGFFIS06' )
	local bFields	:= {|cCampo| Alltrim(cCampo) $ "A4_CODIGO|A4_NOME|A4_END|A4_BAIRRO|A4_EST|A4_COD_MUN|A4_MUN|A4_CEP|A4_CODPAIS|A4_EMAIL|A4_DDD|A4_TEL"}

	local oStrSA4	:= FWFormStruct( 2,"SA4", bFields)

	//oStrSA4:SetProperty( '*' , MODEL_FIELD_WHEN,{||.f.}) //* PARA TODOS OS CAMPOS
	//oStrSA4:SetProperty( 'A1_NOME' , MODEL_FIELD_WHEN,{||.t.})

	oView := FWFormView():New()
	oView:SetModel(oModel)

	oView:AddField( 'VIEW_SA4' , oStrSA4, 'SA4MASTER' )

	oView:CreateHorizontalBox( 'TELA' , 100 )
	oView:SetOwnerView( 'VIEW_SA4', 'TELA' )

Return oView

//-----------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------
static function cmtSA4(oModel)
	local lRetCommit	:= .T.
	local oMdlSA4		:= oModel:GetModel('SA4MASTER')
	local cTime			:= time()
	local dDate			:= dDataBase

	BEGIN TRANSACTION
		if oMdlSA4:getValue('A4_END') <> SA4->A4_END
			//MGFFIS12(cTbl, cSeek, nRecno, cTblAlter, nRecnoAlte, cField, cOld, cNew, dDate, cHour, cUser)
			U_MGFFIS12("SF2", SF2->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO), SF2->(RECNO()), "SA4", SA4->(RECNO()), "A4_END", SA4->A4_END, oMdlSA4:getValue('A4_END'), dDate, cTime, usrFullName(retCodUsr()))
		endif

		if oMdlSA4:getValue('A4_BAIRRO') <> SA4->A4_BAIRRO
			U_MGFFIS12("SF2", SF2->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO), SF2->(RECNO()), "SA4", SA4->(RECNO()), "A4_BAIRRO", SA4->A4_BAIRRO, oMdlSA4:getValue('A4_BAIRRO'), dDate, cTime, usrFullName(retCodUsr()))
		endif

		if oMdlSA4:getValue('A4_EST') <> SA4->A4_EST
			U_MGFFIS12("SF2", SF2->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO), SF2->(RECNO()), "SA4", SA4->(RECNO()), "A4_EST", SA4->A4_EST, oMdlSA4:getValue('A4_EST'), dDate, cTime, usrFullName(retCodUsr()))
		endif

		if oMdlSA4:getValue('A4_COD_MUN') <> SA4->A4_COD_MUN
			U_MGFFIS12("SF2", SF2->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO), SF2->(RECNO()), "SA4", SA4->(RECNO()), "A4_COD_MUN", SA4->A4_COD_MUN, oMdlSA4:getValue('A4_COD_MUN'), dDate, cTime, usrFullName(retCodUsr()))
		endif

		if oMdlSA4:getValue('A4_MUN') <> SA4->A4_MUN
			U_MGFFIS12("SF2", SF2->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO), SF2->(RECNO()), "SA4", SA4->(RECNO()), "A4_MUN", SA4->A4_MUN, oMdlSA4:getValue('A4_MUN'), dDate, cTime, usrFullName(retCodUsr()))
		endif

		if oMdlSA4:getValue('A4_CEP') <> SA4->A4_CEP
			U_MGFFIS12("SF2", SF2->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO), SF2->(RECNO()), "SA4", SA4->(RECNO()), "A4_CEP", SA4->A4_CEP, oMdlSA4:getValue('A4_CEP'), dDate, cTime, usrFullName(retCodUsr()))
		endif

		if oMdlSA4:getValue('A4_CODPAIS') <> SA4->A4_CODPAIS
			U_MGFFIS12("SF2", SF2->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO), SF2->(RECNO()), "SA4", SA4->(RECNO()), "A4_CODPAIS", SA4->A4_CODPAIS, oMdlSA4:getValue('A4_CODPAIS'), dDate, cTime, usrFullName(retCodUsr()))
		endif

		if oMdlSA4:getValue('A4_EMAIL') <> SA4->A4_EMAIL
			U_MGFFIS12("SF2", SF2->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO), SF2->(RECNO()), "SA4", SA4->(RECNO()), "A4_EMAIL", SA4->A4_EMAIL, oMdlSA4:getValue('A4_EMAIL'), dDate, cTime, usrFullName(retCodUsr()))
		endif

		if oMdlSA4:getValue('A4_DDD') <> SA4->A4_DDD
			U_MGFFIS12("SF2", SF2->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO), SF2->(RECNO()), "SA4", SA4->(RECNO()), "A4_DDD", SA4->A4_DDD, oMdlSA4:getValue('A4_DDD'), dDate, cTime, usrFullName(retCodUsr()))
		endif

		if oMdlSA4:getValue('A4_TEL') <> SA4->A4_TEL
			U_MGFFIS12("SF2", SF2->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO), SF2->(RECNO()), "SA4", SA4->(RECNO()), "A4_TEL", SA4->A4_TEL, oMdlSA4:getValue('A4_TEL'), dDate, cTime, usrFullName(retCodUsr()))
		endif

		fwFormCommit(oModel)
	END TRANSACTION
return lRetCommit