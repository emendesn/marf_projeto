#include 'protheus.ch'
#include 'parmtype.ch'
#include "fwmvcdef.ch"
#include "topconn.ch"

/*
=====================================================================================
Programa............: MGFFINB2
Autor...............: Joni Lima
Data................: 26/11/2018
Descricao / Objetivo: Caucao E-Commerce
Doc. Origem.........: Contrato - E-commerce Oracle
Solicitante.........: Cliente
Uso.................: 
Obs.................: Tela de controle do Caucao
=====================================================================================
*/
User Function MGFFINB2()

	Local oMBrowse := nil

	oMBrowse:= FWmBrowse():New()
	oMBrowse:SetAlias("ZE6")
	oMBrowse:SetDescription('Caucao E-commerce')

	oMBrowse:AddLegend( "ZE6_STATUS == '0'"	, "YELLOW"	, "Caucao Aberto"									)
	oMBrowse:AddLegend( "ZE6_STATUS == '1'"	, "BLUE"	, "Titulo Gerado"									)
	oMBrowse:AddLegend( "ZE6_STATUS == '2'"	, "GREEN"	, "Titulo Baixado"									)
	oMBrowse:AddLegend( "ZE6_STATUS == '3'"	, "RED"		, "ERRO"											)
	oMBrowse:AddLegend( "ZE6_STATUS == '4'"	, "PINK"	, "Pagamento autorizado - Aguardando conciliacao"	)
	oMBrowse:AddLegend( "ZE6_STATUS == '5'"	, "ORANGE"	, "Estornado"										)

	oMBrowse:Activate()

return

/*
=====================================================================================
Programa............: MenuDef
Descricao / Objetivo: MenuDef da rotina
Obs.................: Definicao do Menu
=====================================================================================
*/
Static Function MenuDef()

	Local	aRotina	:= {}

	ADD OPTION aRotina TITLE "Pesquisar"  		ACTION "PesqBrw"          OPERATION 1                      ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 		ACTION "VIEWDEF.MGFFINB2" OPERATION MODEL_OPERATION_VIEW   ACCESS 0

Return(aRotina)

/*
=====================================================================================
Programa............: ModelDef
Obs.................: Definicao do Modelo de Dados para cadastro do Caucao
=====================================================================================
*/
Static Function ModelDef()

	Local oModel	:= Nil
	Local oStrZE6 	:= FWFormStruct(1,"ZE6")

	oModel := MPFormModel():New("XMGFFINB2",/*bPreValidacao*/,/*bPosValid*/,/*bCommit*/,/*bCancel*/ )

	oModel:AddFields("ZE6MASTER",/*cOwner*/,oStrZE6, /*bPreValid*/, /*bPosValid*/, /*bCarga*/ )

	oModel:SetDescription("Caucao E-Commerce")
	oModel:SetPrimaryKey({"ZE6_FILIAL","ZE6_PEDIDO"})

Return oModel

/*
=====================================================================================
Programa............: ViewDef
Obs.................: Definicao da View de Dados para cadastro do Caucao
=====================================================================================
*/
Static Function ViewDef()

	Local oView
	Local oModel  	:= FWLoadModel('MGFFINB2')

	Local oStrZE6 	:= FWFormStruct( 2, "ZE6",)	

	oView := FWFormView():New()
	oView:SetModel(oModel)

	oView:AddField( 'VIEW_ZE6' , oStrZE6, 'ZE6MASTER' )
	oView:CreateHorizontalBox( 'SUPERIOR' , 100 )
	oView:SetOwnerView( 'VIEW_ZE6', 'SUPERIOR' )

Return oView

/*
=====================================================================================
Programa............: xFINB2Ped
Obs.................: Funcao para Inclusao do Caucao do E-commerce, (Quando � Gerado o Pedido de Venda)
Parametros..........: 
						xFilCore := Filial Corrente
					    cCliente := Cliente do pedido
					    cLoja	 := Loja do Pedido
					    cCnpj	 := CNPJ do Cliente
					    cNome    := Nome do Cliente
					    cNSU     := Numero do NSU
					    cIdTrans := Id De transacao
					    cPedido  := Numero do Pedido de Venda
					    dDtPedido:= Data de Inclusao do Pedido
					    nValorCau:= Valor do Caucao
					    cCodAdm  := Codigo Administradora
					    cDesAdm  := Descricao Administradora
=====================================================================================
*/
User Function xFINB2Ped(xFilCore,cCliente,cLoja,cCnpj,cNome,cNSU,cIdTrans,cPedido,dDtPedido,nValorCau,cCodAdm,cDesAdm,cObs,cStatus)
	local aArea		:= GetArea()
	local aAreaZE6	:= ZE6->( GetArea() )
	local cQryZE6	:= ""

	default cObs	:= ""
	default cStatus	:= ""

	cQryZE6 := "SELECT *"												+ CRLF
	cQryZE6 += " FROM " + retSQLName("ZE6") + " ZE6"					+ CRLF	
	cQryZE6 += " WHERE"													+ CRLF
	cQryZE6 += " 		ZE6.ZE6_CNPJ	=	'" + cCnpj			+ "'"	+ CRLF
	cQryZE6 += " 	AND	ZE6.ZE6_NSU		=	'" + cNSU			+ "'"	+ CRLF
	cQryZE6 += " 	AND	ZE6.ZE6_FILIAL	=	'" + xFilial("ZE6")	+ "'"	+ CRLF
	cQryZE6 += " 	AND	ZE6.D_E_L_E_T_	<>	'*'"						+ CRLF

	tcQuery cQryZE6 New Alias "QRYZE6"

	if QRYZE6->(EOF())
		DBSelectArea("ZE6")

		RecLock("ZE6",.T.)
			ZE6->ZE6_FILIAL		:= xFilCore

			if !empty( cStatus )
				ZE6->ZE6_STATUS		:= cStatus	// 0-Caucao / 1-Titulo Gerado / 2-Titulo Baixado / 3-Erro
			else
				ZE6->ZE6_STATUS		:= "0"		// 0-Caucao / 1-Titulo Gerado / 2-Titulo Baixado / 3-Erro
			endif

			ZE6->ZE6_CLIENT		:= cCliente
			ZE6->ZE6_LOJACL		:= cLoja
			ZE6->ZE6_CNPJ		:= cCnpj
			ZE6->ZE6_NOMECL		:= cNome
			ZE6->ZE6_NSU		:= cNSU
			ZE6->ZE6_IDTRAN		:= cIdTrans
			ZE6->ZE6_PEDIDO		:= cPedido
			ZE6->ZE6_DTINCL		:= dDtPedido
			ZE6->ZE6_VALCAU		:= ( nValorCau / 100 ) // Valor vem em centavos -  convertido para reais
			ZE6->ZE6_CODADM		:= cCodAdm
			ZE6->ZE6_DESADM		:= cDesAdm
			if !empty( cObs )
				ZE6->ZE6_OBS	:= cObs
			endif
		ZE6->(MsUnLock())
	else
		conout("[E-COM] [xFINB2Ped] Caucao para NSU " + allTrim( cNSU ) + " gerado anteriormente.")
	endif

	QRYZE6->(DBCloseArea())

	restArea( aAreaZE6 )
	restArea( aArea )
Return