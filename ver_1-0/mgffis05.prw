#include 'protheus.ch'
#include 'fwmvcdef.ch'

/*
=====================================================================================
Programa.:              MGFFIS05
Autor....:              Gustavo Ananias Afonso
Data.....:              09/11/2016
Descricao / Objetivo:   Ajuste Fiscal
Doc. Origem:            GAP FIS040
Solicitante:            Cliente
Uso......:              
Obs......:              Manutencao no cadastro de clientes
=====================================================================================
*/

User Function MGFFIS05()
	local aArea		:= getArea()
	local aAreaSA1	:= SA1->(getArea())
	local aButtons := {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.T.,"Salvar"},{.T.,"Cancelar"},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil}}
	local cUsuario := SuperGetMv("MGF_UFIS40",.F.,"000000",) 

	If !(RetCodUsr() $ cUsuario)
		MsgInfo("Usuario sem permissao para alteracao.","Atencao!")
		Return  
	Else
		DBSelectArea("SA1")
		SA1->(DBGoTop())

		if SA1->( DBSeek( xFilial("SA1") + SF2->(F2_CLIENTE + F2_LOJA) ) )
			//UPDATE/ exclusao precisa estar possicionado
			fwExecView("Alteracao", "MGFFIS05", MODEL_OPERATION_UPDATE,, {|| .T.}, , ,aButtons)//"Alteracao"
		else
			msgAlert("Cliente da Nota nao encontrado!")
		endif

		SA1->(DBCloseArea())

		restArea(aAreaSA1)
		restArea(aArea)
	Endif
return

//-----------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------
static function ModelDef()
	local oModel	:= nil
	local oStrSA1 	:= FWFormStruct(1,"SA1")

	oStrSA1:SetProperty( '*'			, MODEL_FIELD_WHEN,{||.F.}) //* PARA TODOS OS CAMPOS
	oStrSA1:SetProperty( 'A1_END'		, MODEL_FIELD_WHEN,{||.T.})
	oStrSA1:SetProperty( 'A1_BAIRRO'	, MODEL_FIELD_WHEN,{||.T.})
	oStrSA1:SetProperty( 'A1_EST'		, MODEL_FIELD_WHEN,{||.T.})
	oStrSA1:SetProperty( 'A1_COD_MUN'	, MODEL_FIELD_WHEN,{||.T.})
	oStrSA1:SetProperty( 'A1_MUN'		, MODEL_FIELD_WHEN,{||.T.})
	oStrSA1:SetProperty( 'A1_CEP'		, MODEL_FIELD_WHEN,{||.T.})
	oStrSA1:SetProperty( 'A1_PAIS'		, MODEL_FIELD_WHEN,{||.T.})
	oStrSA1:SetProperty( 'A1_CODPAIS'	, MODEL_FIELD_WHEN,{||.T.})
	oStrSA1:SetProperty( 'A1_DDD'		, MODEL_FIELD_WHEN,{||.T.})
	oStrSA1:SetProperty( 'A1_TEL'		, MODEL_FIELD_WHEN,{||.T.})
	oStrSA1:SetProperty( 'A1_ENDENT'	, MODEL_FIELD_WHEN,{||.T.})
	oStrSA1:SetProperty( 'A1_ESTE'		, MODEL_FIELD_WHEN,{||.T.})
	oStrSA1:SetProperty( 'A1_BAIRROE'	, MODEL_FIELD_WHEN,{||.T.})
	oStrSA1:SetProperty( 'A1_CODMUNE'	, MODEL_FIELD_WHEN,{||.T.})

	oModel := MPFormModel():New("XMGFFIS05", /*bPreValidacao*/,/*bPosValidacao*/, { |oModel| cmtSA1(oModel) } /*bCommit*/,/*bCancel*/ )
	oModel:AddFields("SA1MASTER",/*cOwner*/,oStrSA1, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

	oModel:SetDescription('Alteracao do Cliente')
	//oModel:SetPrimaryKey({"ZZ5_FILIAL","ZZ5_CODIGO"}) // Necessário apenas quando nao X2_UNICO em branco

return(oModel)

//-----------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------
static function ViewDef()
	local oView		:= Nil
	local oModel	:= FWLoadModel( 'MGFFIS05' )
	local bFields	:= {|cCampo| Alltrim(cCampo) $ "A1_COD|A1_LOJA|A1_NOME|A1_END|A1_BAIRRO|A1_EST|A1_COD_MUN|A1_MUN|A1_CEP|A1_PAIS|A1_CODPAIS|A1_DDD|A1_TEL"}

	local oStrSA1	:= FWFormStruct( 2,"SA1", bFields)

	//oStrSA1:SetProperty( '*' , MODEL_FIELD_WHEN,{||.f.}) //* PARA TODOS OS CAMPOS
	//oStrSA1:SetProperty( 'A1_NOME' , MODEL_FIELD_WHEN,{||.t.})

	oView := FWFormView():New()
	oView:SetModel(oModel)

	oView:AddField( 'VIEW_SA1' , oStrSA1, 'SA1MASTER' )

	oView:CreateHorizontalBox( 'TELA' , 100 )
	oView:SetOwnerView( 'VIEW_SA1', 'TELA' )

return oView

//-----------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------
static function cmtSA1(oModel)
	local lRetCommit	:= .T.
	local oMdlSA1		:= oModel:GetModel('SA1MASTER')
	local cTime			:= time()
	local dDate			:= dDataBase

	BEGIN TRANSACTION
		if oMdlSA1:getValue('A1_END') <> SA1->A1_END
			//MGFFIS12(cTbl, cSeek, nRecno, cTblAlter, nRecnoAlte, cField, cOld, cNew, dDate, cHour, cUser)
			U_MGFFIS12("SF2", SF2->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO), SF2->(RECNO()), "SA1", SA1->(RECNO()), "A1_END", SA1->A1_END, oMdlSA1:getValue('A1_END'), dDate, cTime, usrFullName(retCodUsr()))
		endif

		if oMdlSA1:getValue('A1_BAIRRO') <> SA1->A1_BAIRRO
			U_MGFFIS12("SF2", SF2->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO), SF2->(RECNO()), "SA1", SA1->(RECNO()), "A1_BAIRRO", SA1->A1_BAIRRO, oMdlSA1:getValue('A1_BAIRRO'), dDate, cTime, usrFullName(retCodUsr()))
		endif

		if oMdlSA1:getValue('A1_EST') <> SA1->A1_EST
			U_MGFFIS12("SF2", SF2->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO), SF2->(RECNO()), "SA1", SA1->(RECNO()), "A1_EST", SA1->A1_EST, oMdlSA1:getValue('A1_EST'), dDate, cTime, usrFullName(retCodUsr()))
		endif

		if oMdlSA1:getValue('A1_COD_MUN') <> SA1->A1_COD_MUN
			U_MGFFIS12("SF2", SF2->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO), SF2->(RECNO()), "SA1", SA1->(RECNO()), "A1_COD_MUN", SA1->A1_COD_MUN, oMdlSA1:getValue('A1_COD_MUN'), dDate, cTime, usrFullName(retCodUsr()))
		endif

		if oMdlSA1:getValue('A1_MUN') <> SA1->A1_MUN
			U_MGFFIS12("SF2", SF2->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO), SF2->(RECNO()), "SA1", SA1->(RECNO()), "A1_MUN", SA1->A1_MUN, oMdlSA1:getValue('A1_MUN'), dDate, cTime, usrFullName(retCodUsr()))
		endif

		if oMdlSA1:getValue('A1_CEP') <> SA1->A1_CEP
			U_MGFFIS12("SF2", SF2->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO), SF2->(RECNO()), "SA1", SA1->(RECNO()), "A1_CEP", SA1->A1_CEP, oMdlSA1:getValue('A1_CEP'), dDate, cTime, usrFullName(retCodUsr()))
		endif

		if oMdlSA1:getValue('A1_PAIS') <> SA1->A1_PAIS
			U_MGFFIS12("SF2", SF2->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO), SF2->(RECNO()), "SA1", SA1->(RECNO()), "A1_PAIS", SA1->A1_PAIS, oMdlSA1:getValue('A1_PAIS'), dDate, cTime, usrFullName(retCodUsr()))
		endif

		if oMdlSA1:getValue('A1_CODPAIS') <> SA1->A1_CODPAIS
			U_MGFFIS12("SF2", SF2->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO), SF2->(RECNO()), "SA1", SA1->(RECNO()), "A1_CODPAIS", SA1->A1_CODPAIS, oMdlSA1:getValue('A1_CODPAIS'), dDate, cTime, usrFullName(retCodUsr()))
		endif

		if oMdlSA1:getValue('A1_DDD') <> SA1->A1_DDD
			U_MGFFIS12("SF2", SF2->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO), SF2->(RECNO()), "SA1", SA1->(RECNO()), "A1_DDD", SA1->A1_DDD, oMdlSA1:getValue('A1_DDD'), dDate, cTime, usrFullName(retCodUsr()))
		endif

		if oMdlSA1:getValue('A1_TEL') <> SA1->A1_TEL
			U_MGFFIS12("SF2", SF2->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO), SF2->(RECNO()), "SA1", SA1->(RECNO()), "A1_TEL", SA1->A1_TEL, oMdlSA1:getValue('A1_TEL'), dDate, cTime, usrFullName(retCodUsr()))
		endif

		fwFormCommit(oModel)
	END TRANSACTION
return lRetCommit