#include 'protheus.ch'
#include 'fwmvcdef.ch'

/*
=====================================================================================
Programa.:              MGFFIS31
Autor....:              Natanael Simoes
Data.....:              08/03/2018
Descricao / Objetivo:   Ajuste Fiscal
Doc. Origem:            GAP FIS040
Solicitante:            Cliente
Uso......:              
Obs......:              Manutencao no cadastro de produtos
=====================================================================================
*/

User Function MGFFIS31()
	
	local aArea		:= getArea()
	local aAreaSB1	:= SB1->(getArea())
	local aButtons  := {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.T.,"Salvar"},{.T.,"Cancelar"},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil}}
	local cUsuario  := SuperGetMv("MGF_UFIS40",.F.,"000000",) 
	Local cProd	    := ""
	
	If !(RetCodUsr() $ cUsuario)
		MsgInfo("Usuario sem permissao para alteracao.","Atencao!")
		Return  
	Else
		DBSelectArea("SB1")
		SB1->(DBGoTop())
		
		If IsInCallStack("U_MGFFIS04")
			cProd := SD2->(D2_COD) 
		ElseIf IsInCallStack("U_MGFFIS09")
			cProd := SD1->(D1_COD)
		EndIf
		
		If !Empty(cProd)
			if SB1->( DBSeek( xFilial("SB1") + cProd ) )
				//UPDATE/ exclusao precisa estar possicionado
				fwExecView("Alteracao", "MGFFIS31", MODEL_OPERATION_UPDATE,, {|| .T.}, , ,aButtons)//"Alteracao"
			else
				msgAlert("Produto da da linha na Nota Fiscal nao encontrado!")
			endif
		Else
			msgAlert("Produto precisa Ser Informado, Chame o ADM do Sistema, Fonte: MGFFIS31, Linha:43")
		EndIf
		SB1->(DBCloseArea())

		restArea(aAreaSB1)
		restArea(aArea)
	Endif

return

//-----------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------
static function ModelDef()
	local oModel	:= nil
	local oStrSB1 	:= FWFormStruct(1,"SB1")

	oStrSB1:SetProperty( '*'			, MODEL_FIELD_WHEN,{||.F.}) //* PARA TODOS OS CAMPOS
	oStrSB1:SetProperty( 'B1_POSIPI'	, MODEL_FIELD_WHEN,{||.T.})
	oStrSB1:SetProperty( 'B1_CEST'		, MODEL_FIELD_WHEN,{||.T.})


	oModel := MPFormModel():New("XMGFFIS31", /*bPreValidacao*/,/*bPosValidacao*/, { |oModel| cmtSB1(oModel) } /*bCommit*/,/*bCancel*/ )
	oModel:AddFields("SB1MASTER",/*cOwner*/,oStrSB1, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

	oModel:SetDescription('Alteracao do Produto')
	//oModel:SetPrimaryKey({"ZZ5_FILIAL","ZZ5_CODIGO"}) // Necessário apenas quando nao X2_UNICO em branco

return(oModel)

//-----------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------
static function ViewDef()
	local oView		:= Nil
	local oModel	:= FWLoadModel( 'MGFFIS31' )
	local bFields	:= {|cCampo| Alltrim(cCampo) $ "B1_COD|B1_DESC|B1_POSIPI|B1_CEST"}

	local oStrSB1	:= FWFormStruct( 2,"SB1", bFields)

	//oStrSB1:SetProperty( '*' , MODEL_FIELD_WHEN,{||.f.}) //* PARA TODOS OS CAMPOS
	//oStrSB1:SetProperty( 'A1_NOME' , MODEL_FIELD_WHEN,{||.t.})

	oView := FWFormView():New()
	oView:SetModel(oModel)

	oView:AddField( 'VIEW_SB1' , oStrSB1, 'SB1MASTER' )

	oView:CreateHorizontalBox( 'TELA' , 100 )
	oView:SetOwnerView( 'VIEW_SB1', 'TELA' )

return oView

//-----------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------
static function cmtSB1(oModel)
	local lRetCommit	:= .T.
	local oMdlSB1		:= oModel:GetModel('SB1MASTER')
	local cTime			:= time()
	local dDate			:= dDataBase

	BEGIN TRANSACTION	
		
		If IsInCallStack("U_MGFFIS04")
			if oMdlSB1:getValue('B1_POSIPI') <> SB1->B1_POSIPI
				//MGFFIS12(cTbl, cSeek, nRecno, cTblAlter, nRecnoAlte, cField, cOld, cNew, dDate, cHour, cUser)
				U_MGFFIS12("SD2", SD2->(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM), SD2->(RECNO()), "SB1", SB1->(RECNO()), "B1_POSIPI", SB1->B1_POSIPI, oMdlSB1:getValue('B1_POSIPI'), dDate, cTime, usrFullName(retCodUsr()))
			endif
	
			if oMdlSB1:getValue('B1_CEST') <> SB1->B1_CEST
				U_MGFFIS12("SD2", SD2->(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM), SD2->(RECNO()), "SB1", SB1->(RECNO()), "B1_CEST", SB1->B1_CEST, oMdlSB1:getValue('B1_CEST'), dDate, cTime, usrFullName(retCodUsr()))
			endif
		ElseIf IsInCallStack("U_MGFFIS09")
			if oMdlSB1:getValue('B1_POSIPI') <> SB1->B1_POSIPI
				U_MGFFIS12("SD1", SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM), SD1->(RECNO()), "SB1", SB1->(RECNO()), "B1_POSIPI", SB1->B1_POSIPI, oMdlSB1:getValue('B1_POSIPI'), dDate, cTime, usrFullName(retCodUsr()))
			ENdIf

			if oMdlSB1:getValue('B1_CEST') <> SB1->B1_CEST
				U_MGFFIS12("SD1", SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM), SD1->(RECNO()), "SB1", SB1->(RECNO()), "B1_CEST", SB1->B1_CEST, oMdlSB1:getValue('B1_CEST'), dDate, cTime, usrFullName(retCodUsr()))
			endif

		
		EndIf
		
		fwFormCommit(oModel)
	END TRANSACTION
return lRetCommit

static function MenuDef()
	local aRotina := {}

	aadd( aRotina, { 'Alteracao do Produtos'		, 'U_MGFFIS31()()'	, 0, 4, 0, NIL } )

return aRotina