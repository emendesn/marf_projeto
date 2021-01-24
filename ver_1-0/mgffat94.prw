#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"
#include 'fwmvcdef.ch'

#define CRLF chr(13) + chr(10)
#define DA0CAMPOS "DA0_FILIAL | DA0_CODTAB | DA0_DESCRI"
#define SA1CAMPOS "A1_FILIAL | A1_COD | A1_LOJA | A1_NOME | A1_CGC"

/*/
===========================================================================================================================
{Protheus.doc} MGFFAT94
Browse de operações de tabela de preços do Ecommerce

@author Josué Danich Prestes
@since 19/12/2019 
@type Job  
/*/   
user function MGFFAT94()
	local oBrowse

    //Cria um Browse Simples instanciando o FWMBrowse
	oBrowse := FWMBrowse():New()
	//Define um alias para o Browse
	oBrowse:SetAlias('DA0')
	//Adiciona uma descriÃ§Ã£o para o Browse
	oBrowse:SetDescription('Tabela de Preço E-Commerce')
	//Ativa o Browse
	oBrowse:Activate()
return nil

//---------------------------------------------------------------
static function MenuDef()
	local aRotina := {}

	ADD OPTION aRotina TITLE 'Alterar'		ACTION 'VIEWDEF.MGFFAT94'	OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Visualizar'	ACTION 'VIEWDEF.MGFFAT94'	OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Excluir'		ACTION 'VIEWDEF.MGFFAT94'	OPERATION 5 ACCESS 0
	ADD OPTION aRotina TITLE 'Exportar'		ACTION 'U_MGFFAT96()'		OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Importar'		ACTION 'U_MGFFAT97()'		OPERATION 2 ACCESS 0

return aRotina

//--------------------------------------------------------
//--------------------------------------------------------
static function ModelDef()
	local aSA1Rel	:= {}
	local oStruDA0 	:= FWFormStruct( 1, "DA0", {| cCampo | allTrim( cCampo ) $ DA0CAMPOS } )
	local oStruSA1	:= FWFormStruct( 1, 'SA1', {| cCampo | allTrim( cCampo ) $ SA1CAMPOS } )
	local oModel	:= nil

	oModel := MPFormModel():New( 'FAT94MDL' , , , { | oModel | fat94cmt( oModel ) } /*bCommit*/)

	oStruDA0:SetProperty("*", MODEL_FIELD_OBRIGAT	, .F.			)
	oStruDA0:SetProperty("*", MODEL_FIELD_VALID		, { || .T. }	)
	oStruSA1:SetProperty("*", MODEL_FIELD_OBRIGAT	, .F.			)
	oStruSA1:SetProperty("*", MODEL_FIELD_VALID		, { || .T. }	)
	oModel:AddFields( 'DA0MASTER',				, oStruDA0 )
	oModel:AddGrid	( 'SA1DETAIL', 'DA0MASTER'	, oStruSA1 )

    //Fazendo o relacionamento entre o Pai e Filho
    aadd( aSA1Rel, {"A1_FILIAL"		, "xFilial('SA1')"	} )
    aadd( aSA1Rel, {"A1_ZPRCECO"	, "DA0_CODTAB"		} )

    oModel:SetRelation("SA1DETAIL",{{"A1_FILIAL" ,"xFilial('SA1')"},{"A1_ZPRCECO","DA0_CODTAB"}},SA1->( IndexKey(1)))

	oModel:SetDescription( 'Clientes da Tabela de Preço E-Commerce' )

	oModel:setPrimaryKey( {} )

	oModel:GetModel( 'DA0MASTER' ):SetDescription( 'Tabela de Preço' )
	oModel:GetModel( 'SA1DETAIL' ):SetDescription( 'Clientes' )

	oModel:GetModel("DA0MASTER"):SetOnlyView( .T. )
	oModel:GetModel("DA0MASTER"):SetOnlyQuery( .T. )

	oModel:GetModel("SA1DETAIL"):SetOnlyQuery( .T. )
	oModel:GetModel("SA1DETAIL"):SetOptional( .T. )

	oModel:GetModel("SA1DETAIL"):SetOnlyQuery( .T. )

return oModel

//--------------------------------------------------------
//--------------------------------------------------------
static function ViewDef()
	local oModel	:= FWLoadModel( 'MGFFAT94' )
	local oStruDA0	:= FWFormStruct( 2, 'DA0'	, {| cCampo | allTrim( cCampo ) $ DA0CAMPOS } )
	local oStruSA1	:= FWFormStruct( 2, 'SA1'	, {| cCampo | allTrim( cCampo ) $ SA1CAMPOS } )
	local oView		:= nil

	oView := FWFormView():New()

	oView:SetModel( oModel )

	oView:AddField( 'VIEW_DA0'	, oStruDA0, 'DA0MASTER' )
	oView:AddGrid( 'VIEW_SA1'	, oStruSA1, 'SA1DETAIL' )

	oStruSA1:SetProperty("*", MVC_VIEW_CANCHANGE	, .F.	)

	oStruSA1:SetProperty("A1_COD"	, MVC_VIEW_CANCHANGE	, .T.	)
	oStruSA1:SetProperty("A1_LOJA"	, MVC_VIEW_CANCHANGE	, .T.	)

	oStruSA1:SetProperty("A1_COD"	, MVC_VIEW_LOOKUP	, "SA1"	)

	oView:CreateHorizontalBox( 'TABELA'		, 25 )
	oView:CreateHorizontalBox( 'CLIENTES'	, 75 )

	oView:SetOwnerView( 'VIEW_DA0', 'TABELA' )
	oView:SetOwnerView( 'VIEW_SA1', 'CLIENTES' )

    //Habilitando título
    oView:EnableTitleView( 'DA0MASTER', 'Tabela de Preço' )
    oView:EnableTitleView( 'SA1DETAIL', 'Clientes' )

return oView

//--------------------------------------------------------------
//--------------------------------------------------------------
static function fat94cmt( oModel )
	local nI		:= 0
	local lRet		:= .T.
	local oModelDA0	:= oModel:GetModel('DA0MASTER')
	local oModelSA1	:= oModel:GetModel('SA1DETAIL')
	local cUpdSA1	:= ""

	Local cListaPdr := alltrim(SuperGetMv( "MGF_LISTEC", , "ECP" ))

	if oModel:VldData()
		for nI := 1 to oModelSA1:length()
			oModelSA1:GoLine( nI )

			if oModelSA1:isDeleted()
				//Update da tabela de preço na tabela de Cliente
				cUpdSA1 := "UPDATE " + retSQLName("SA1")											+ CRLF
				cUpdSA1 += "	SET"																+ CRLF
				cUpdSA1 += "		A1_ZPRCECO = '" + cListaPdr + "' "								+ CRLF
				cUpdSA1 += " WHERE"																	+ CRLF
				cUpdSA1 += " 		A1_LOJA		=	'" + oModelSA1:getValue("A1_LOJA", nI)	+ "'"	+ CRLF
				cUpdSA1 += " 	AND	A1_COD		=	'" + oModelSA1:getValue("A1_COD", nI)	+ "'"	+ CRLF
				cUpdSA1 += " 	AND	A1_FILIAL	=	'" + xFilial("SA1")						+ "'"	+ CRLF
				cUpdSA1 += " 	AND	A1_ZPRCECO	<>	'" + cListaPdr							+ "'"	+ CRLF
				cUpdSA1 += " 	AND	D_E_L_E_T_	<>	'*'"											+ CRLF

				if tcSQLExec( cUpdSA1 ) < 0
					conout("Não foi possível executar UPDATE." + CRLF + tcSqlError())
				endif

				//Caso Cliente seja do E-commerce
				//Update para Reenviar para E-commerce
				cUpdSA1 := "UPDATE " + retSQLName("SA1")											+ CRLF
				cUpdSA1 += "	SET"																+ CRLF
				cUpdSA1 += " 		A1_XINTECO = '0',"												+ CRLF
				cUpdSA1 += " 		A1_XENVECO = '1'"												+ CRLF
				cUpdSA1 += " WHERE"																	+ CRLF
				cUpdSA1 += " 		A1_LOJA		=	'" + oModelSA1:getValue("A1_LOJA", nI)	+ "'"	+ CRLF
				cUpdSA1 += " 	AND	A1_COD		=	'" + oModelSA1:getValue("A1_COD", nI)	+ "'"	+ CRLF
				cUpdSA1 += " 	AND	A1_FILIAL	=	'" + xFilial("SA1")						+ "'"	+ CRLF
				cUpdSA1 += " 	AND	A1_ZCDECOM	<>	' '"											+ CRLF
				cUpdSA1 += " 	AND	D_E_L_E_T_	<>	'*'"											+ CRLF

				if tcSQLExec( cUpdSA1 ) < 0
					conout("Não foi possível executar UPDATE." + CRLF + tcSqlError())
				endif

			else
				//Update da tabela de preço na tabela de Cliente
				cUpdSA1 := "UPDATE " + retSQLName("SA1")											+ CRLF
				cUpdSA1 += "	SET"																+ CRLF
				cUpdSA1 += " 		A1_ZPRCECO = '" + oModelDA0:getValue("DA0_CODTAB")	+ "' "		+ CRLF
				cUpdSA1 += " WHERE"																	+ CRLF
				cUpdSA1 += " 		A1_LOJA		=	'" + oModelSA1:getValue("A1_LOJA", nI)	+ "'"	+ CRLF
				cUpdSA1 += " 	AND	A1_COD		=	'" + oModelSA1:getValue("A1_COD", nI)	+ "'"	+ CRLF
				cUpdSA1 += " 	AND	A1_FILIAL	=	'" + xFilial("SA1")						+ "'"	+ CRLF
				cUpdSA1 += " 	AND	A1_ZPRCECO	<>	'" + oModelDA0:getValue("DA0_CODTAB")	+ "'"	+ CRLF
				cUpdSA1 += " 	AND	D_E_L_E_T_	<>	'*'"											+ CRLF

				if tcSQLExec( cUpdSA1 ) < 0
					conout("Não foi possível executar UPDATE." + CRLF + tcSqlError())
				endif

				//Caso Cliente seja do E-commerce
				//Update para Reenviar para E-commerce
				cUpdSA1 := "UPDATE " + retSQLName("SA1")											+ CRLF
				cUpdSA1 += "	SET"																+ CRLF
				cUpdSA1 += " 		A1_XINTECO = '0',"												+ CRLF
				cUpdSA1 += " 		A1_XENVECO = '1'"												+ CRLF
				cUpdSA1 += " WHERE"																	+ CRLF
				cUpdSA1 += " 		A1_LOJA		=	'" + oModelSA1:getValue("A1_LOJA", nI)	+ "'"	+ CRLF
				cUpdSA1 += " 	AND	A1_COD		=	'" + oModelSA1:getValue("A1_COD", nI)	+ "'"	+ CRLF
				cUpdSA1 += " 	AND	A1_FILIAL	=	'" + xFilial("SA1")						+ "'"	+ CRLF
				cUpdSA1 += " 	AND	A1_ZCDECOM	<>	' '"											+ CRLF
				cUpdSA1 += " 	AND	D_E_L_E_T_	<>	'*'"											+ CRLF

				if tcSQLExec( cUpdSA1 ) < 0
					conout("Não foi possível executar UPDATE." + CRLF + tcSqlError())
				endif

			endif
		next

		oModel:DeActivate()
	else
		JurShowErro( oModel:GetModel():GetErrormessage() )
		lRet := .F.
		DisarmTransaction()
	endif
return lRet

//---------------------------------------------------------
//
//---------------------------------------------------------
user function MNUFAT94()

	local aRotina2 := {													;
						{ "Clientes"			, "U_EXEFAT94", 0, 4 },	;
						{ "Clientes Exportar"	, "U_MGFFAT96", 0, 2 },	;
						{ "Clientes Importar"	, "U_MGFFAT97", 0, 2 },	;
						{ "Preços Exportar"		, "U_MGFFATA1", 0, 2 },	;
						{ "Preços Importar"		, "U_MGFFATA2", 0, 2 },	;
						{ "Integrar tab preços"	, "U_MNUWSC26", 0, 2 }	;
						}

	aadd(aRotina,{"E-Commerce" , aRotina2, 0, 3, 0, nil })

return

//---------------------------------------------------------
//
//---------------------------------------------------------
user function EXEFAT94()
	local aButtons	:= {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.T.,"Salvar"},{.T.,"Cancelar"},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil}}

	fwExecView("Alteração", "MGFFAT94", MODEL_OPERATION_UPDATE,, {|| .T.}, , , aButtons)
return