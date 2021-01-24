#include 'protheus.ch'
#include 'fwmvcdef.ch'

/*
=====================================================================================
Programa.:              MGFFIS07
Autor....:              Gustavo Ananias Afonso
Data.....:              09/11/2016
Descricao / Objetivo:   Ajuste Fiscal
Doc. Origem:            GAP FIS040
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Manutenção no cadastro de Veículo
=====================================================================================
*/

User Function MGFFIS07()
	local aArea		:= getArea()
	local aAreaDA3	:= DA3->(getArea())
	local aButtons := {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.T.,"Salvar"},{.T.,"Cancelar"},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil}}
	local cUsuario := SuperGetMv("MGF_UFIS40",.F.,"000000",)

	If !(RetCodUsr() $ cUsuario)
		MsgInfo("Usuário sem permissão para alteração.","Atenção!")
		Return  
	Else
		DBSelectArea("DA3")
		DA3->(DBGoTop())

		if DA3->( DBSeek( xFilial("DA3") + SF2->F2_VEICUL1 ) )
			//UPDATE/ exclusao precisa estar possicionado
			fwExecView("Alteração", "MGFFIS07", MODEL_OPERATION_UPDATE,, {|| .T.}, , , aButtons)//"AlteraÃ§Ã£o"
		else
			msgAlert("Veículo da Nota não encontrada!")
		endif

		DA3->(DBCloseArea())

		restArea(aAreaDA3)
		restArea(aArea)
	Endif
return

//-----------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------
static function ModelDef()
	local oModel	:= nil
	local oStrDA3 	:= FWFormStruct(1,"DA3")

	oStrDA3:SetProperty( '*'			, MODEL_FIELD_WHEN,{||.F.}) //* PARA TODOS OS CAMPOS
	oStrDA3:SetProperty( 'DA3_PLACA'	, MODEL_FIELD_WHEN,{||.T.})
	oStrDA3:SetProperty( 'DA3_MUNPLA'	, MODEL_FIELD_WHEN,{||.T.})
	oStrDA3:SetProperty( 'DA3_ESTPLA'	, MODEL_FIELD_WHEN,{||.T.})

	oModel := MPFormModel():New("XMGFFIS07", /*bPreValidacao*/,/*bPosValidacao*/, { |oModel| cmtDA3(oModel) }/*bCommit*/,/*bCancel*/ )
	oModel:AddFields("DA3MASTER",/*cOwner*/,oStrDA3, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

	oModel:SetDescription('Alteração do Veículo')
	//oModel:SetPrimaryKey({"ZZ5_FILIAL","ZZ5_CODIGO"}) // NecessÃ¡rio apenas quando nao X2_UNICO em branco

return(oModel)

//-----------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------
static function ViewDef()
	local oView		:= Nil
	local oModel	:= FWLoadModel( 'MGFFIS07' )
	local bFields	:= {|cCampo| Alltrim(cCampo) $ "DA3_COD|DA3_PLACA|DA3_MUNPLA|DA3_ESTPLA"}
	local oStrDA3	:= FWFormStruct( 2,"DA3", bFields)

	//oStrDA3:SetProperty( '*' , MODEL_FIELD_WHEN,{||.f.}) //* PARA TODOS OS CAMPOS
	//oStrDA3:SetProperty( 'A1_NOME' , MODEL_FIELD_WHEN,{||.t.})

	oView := FWFormView():New()
	oView:SetModel(oModel)

	oView:AddField( 'VIEW_DA3' , oStrDA3, 'DA3MASTER' )

	oView:CreateHorizontalBox( 'TELA' , 100 )
	oView:SetOwnerView( 'VIEW_DA3', 'TELA' )

Return oView

//-----------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------
static function cmtDA3(oModel)
	local lRetCommit	:= .T.
	local oMdlSDA3		:= oModel:GetModel('DA3MASTER')
	local cTime			:= time()
	local dDate			:= dDataBase

	BEGIN TRANSACTION
		if oMdlSDA3:getValue('DA3_PLACA') <> DA3->DA3_PLACA
			//MGFFIS12(cTbl, cSeek, nRecno, cTblAlter, nRecnoAlte, cField, cOld, cNew, dDate, cHour, cUser)
			U_MGFFIS12("SF2", SF2->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO), SF2->(RECNO()), "DA3", DA3->(RECNO()), "DA3_PLACA", DA3->DA3_PLACA, oMdlSDA3:getValue('DA3_PLACA'), dDate, cTime, usrFullName(retCodUsr()))
		endif

		if oMdlSDA3:getValue('DA3_MUNPLA') <> DA3->DA3_MUNPLA
			U_MGFFIS12("SF2", SF2->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO), SF2->(RECNO()), "DA3", DA3->(RECNO()), "DA3_MUNPLA", DA3->DA3_MUNPLA, oMdlSDA3:getValue('DA3_MUNPLA'), dDate, cTime, usrFullName(retCodUsr()))
		endif

		if oMdlSDA3:getValue('DA3_ESTPLA') <> DA3->DA3_ESTPLA
			U_MGFFIS12("SF2", SF2->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO), SF2->(RECNO()), "DA3", DA3->(RECNO()), "DA3_ESTPLA", DA3->DA3_ESTPLA, oMdlSDA3:getValue('DA3_ESTPLA'), dDate, cTime, usrFullName(retCodUsr()))
		endif

		fwFormCommit(oModel)
	END TRANSACTION
return lRetCommit