#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fweditpanel.ch"
#include "fwmvcdef.ch"
#INCLUDE "FWBROWSE.CH"
#INCLUDE "PARMTYPE.CH"
#INCLUDE "FILTEREX.CH"
#INCLUDE "STYLE.CH"
#INCLUDE "HBUTTON.CH"
#INCLUDE "FWFILTER.CH"
#include "topconn.ch"
#include "tbiconn.ch"
#INCLUDE "FWBRWSTR.CH"

#define CRLF chr(13) + chr(10)

#DEFINE SC5CAMPOS "C5_NUM|C5_CLIENTE|C5_LOJACLI"
#DEFINE SC6CAMPOS "C6_ITEM|C6_NUM|C6_PRODUTO|C6_QTDVEN|C6_PRCVEN|C6_PRUNIT|C6_VALOR"

static OMDLFAT64
static cMotivoRej
/*
=====================================================================================
Programa.:              MGFFAT64
Autor....:              Gustavo Ananias Afonso - TOTVS Campinas
Data.....:              fev/2018
Descricao / Objetivo:   Tela para \cao de Pedidos com Bloqueio
Doc. Origem:            GAP FAT14
Solicitante:            Cliente
Uso......:              
Obs......:
=====================================================================================
*/
user function MGFFAT64()
	//local aButtons := {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil}}
	local aButtons := {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.T.,"Finalizar"},{.F.,"Cancelar"},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil}}

	fwExecView(	"" /*"Aprovacao de Pedidos com bloqueio - cTitulo*/		,;
				"MGFFAT64"							/*cPrograma*/		,;
				MODEL_OPERATION_INSERT				/*nOperation*/		,;
													/*oDlg*/			,;
				{|| .T.}							/*bCloseOnOK*/		,;
				{|| .T.}							/*bOk*/				,;
													/*nPercReducao*/	,;
				aButtons							/*aEnableButtons*/	,;
				{|| .T.}							/*bCancel*/ )

				/*
				 - cTitulo:			titulo da janela
				 - cPrograma:		nome do programa-fonte
				 - nOperation:		indica o codigo de operacao (inclusao, alteracao ou exclusao)
				 - oDlg:			objeto da janela em que o View deve ser colocado. Se nao informado, uma nova janela sera criada;
				 - bCloseOnOK:		indica se a janela deve ser fechada ao final da operacao. Se ele retornar .T. (verdadeiro) fecha a janela;
				 - bOk:				Bloco executado no acionamento do botao confirmar que retornando .F. (falso) impedir� o fechamento da janela;
				 - nPercReducao:	Se informado reduz a janela em percentualmente;
				 - aEnableButtons:	Indica os bot�es da barra de bot�es que estar�o habilitados;
				 - bCancel:			Bloco executado no acionamento do botao cancelar que retornando .F. (falso) impedir� o fechamento da janela;
				*/

return

//---------------------------------------------------------
//---------------------------------------------------------
Static Function ModelDef()
	Local oModel
	Local oStrTop		:= gtMdlTop()
	local oStrCenter	:= gtMdlCente()
	local oStrDown		:= gtMdlDown()
	local bLoadTop		:= { | oFieldModel	, lCopy | loadTop( oFieldModel, lCopy )		}
	local bLoadCente	:= { | oFieldModel	, lCopy | loadCenter( oFieldModel, lCopy )		}
	local bLoadDown		:= { | oFieldModel	, lCopy | loadDown( oFieldModel, lCopy )		}
	local aPVRel		:= {}

	oModel := MPFormModel():New( 'MDLFAT64',, /*{ || chkMdl() }*/, { |oModel| cmtFat64( oModel ) } )

	oModel:SetDescription( 'Aprovacao de Pedidos com bloqueio' )

	/******************************************************************************
	ADICAO DE GATILHOS - CENTER
	******************************************************************************/
	aAux := FwStruTrigger(;
	'C5_ZSELECT'		,;		// DOMINIO
	'C5_ZSELECT'		,;		// CONTRA DOMINIO
	'U_chkSelec("SC5", M->C5_ZSELECT)'	,;	// REGRA PREENCHIMENTO
	.F.,;	// POSICIONA
	,;	// ALIAS
	,;	// ORDEM
	,;	// CHAVE
	,;	// CONDICAO
	)

	oStrCenter:AddTrigger( ;
	aAux[1], ;                                                      // [01] Id do campo de origem
	aAux[2], ;                                                      // [02] Id do campo de destino
	aAux[3], ;                                                      // [03] Bloco de codigo de validacao da execucao do gatilho
	aAux[4] )

	/******************************************************************************
	ADICAO DE GATILHOS - DOWN
	******************************************************************************/
	aAux := FwStruTrigger(;
	'C6_ZSELECT'		,;		// DOMINIO
	'C6_ZSELECT'		,;		// CONTRA DOMINIO
	'U_chkSelec("SC6", M->C6_ZSELECT)'	,;	// REGRA PREENCHIMENTO
	.F.,;	// POSICIONA
	,;	// ALIAS
	,;	// ORDEM
	,;	// CHAVE
	,;	// CONDICAO
	)

	oStrDown:AddTrigger( ;
	aAux[1], ;                                                      // [01] Id do campo de origem
	aAux[2], ;                                                      // [02] Id do campo de destino
	aAux[3], ;                                                      // [03] Bloco de codigo de validacao da execucao do gatilho
	aAux[4] )

	oStrCenter:SetProperty("*", MODEL_FIELD_OBRIGAT	, .F.			)
	oStrCenter:SetProperty("*", MODEL_FIELD_VALID	, { || .T. }	)
	oStrCenter:SetProperty("*", MODEL_FIELD_WHEN	, { || .T. }	)
	oStrCenter:SetProperty("*", MODEL_FIELD_INIT	, { || }		)

	oStrDown:SetProperty("*", MODEL_FIELD_OBRIGAT	, .F.			)
	oStrDown:SetProperty("*", MODEL_FIELD_VALID	, { || .T. }		)
	oStrDown:SetProperty("*", MODEL_FIELD_WHEN	, { || .T. }		)
	oStrDown:SetProperty("*", MODEL_FIELD_INIT	, { || }			)

	oModel:AddFields( 'TOP'		,			, oStrTop		,,, bLoadTop			)
	oModel:AddGrid( 'CENTER'	, 'TOP'		, oStrCenter	,,,,, bLoadCente		)
	oModel:AddGrid( 'DOWN'		, 'CENTER'	, oStrDown		,,,,, bLoadDown		)

	oModel:getModel("TOP"):SetDescription("Filtro")
	oModel:getModel("CENTER"):SetDescription("Pedidos")
	oModel:getModel("DOWN"):SetDescription("Bloqueios do Pedido")

	oModel:GetModel( 'CENTER' ):SetNoInsertLine( .T. )
	oModel:GetModel( 'DOWN' ):SetNoInsertLine( .T. )

	oModel:GetModel( 'CENTER' ):SetNoDeleteLine( .T. )
	oModel:GetModel( 'DOWN' ):SetNoDeleteLine( .T. )

	//oModel:GetModel( 'CENTER' ):SetNoUpdateLine( .T. )
	//oModel:GetModel( 'DOWN' ):SetNoUpdateLine( .T. )

	oModel:GetModel("CENTER"):SetDelAllLine(.T.)
	oModel:GetModel("DOWN"):SetDelAllLine(.T.)

	oModel:GetModel( 'CENTER' ):SetOptional(.T.)
	oModel:GetModel( 'DOWN' ):SetOptional(.T.)

	//oStrCenter:SetProperty('C5_ZSELECT'		, MVC_VIEW_CANCHANGE	, .T.)
	//oStrDown:SetProperty('C6_ZSELECT'		, MVC_VIEW_CANCHANGE	, .T.)

	//oModel:AddCalc("CALC"	, "ZDZMASTER", "ZE0DETAIL", "ZE0_VALOR", "ZE0__TOT", "SUM", {||.T.}, ,"Caixinha")
	//oModel:addCalc("CALCFAT64", "TOP", "CENTER", "VLRPEDIDO", "SUMPRCVEN", "FORMULA", {||.T.}, {|| 0 }, "Total Pedidos", {|oModel, nTotalAtual, xValor, lSomando| xCalcFat64(oModel, nTotalAtual, xValor, lSomando) } )
	oModel:addCalc("CALCFAT64", "TOP", "CENTER", "VLRPEDIDO", "SUMPRCVEN", "COUNT", {||.T.}, , "Total Pedidos" )

	oModel:SetPrimaryKey( {  } )
return oModel

//---------------------------------------------------------
//---------------------------------------------------------
Static Function ViewDef()
	local oView
	local oModel		:= modelDef()
	local oStrTop		:= getVwTop()
	local oStrCenter	:= getVwCente()
	local oStrDown		:= getVwDown()

	local oCalc1		:= FWCalcStruct( oModel:GetModel( 'CALCFAT64') )

	oView := FWFormView():New()

	oView:showInsertMsg( .F. )
	/*
	oModel:GetModel( 'TOP' ):showInsertMsg( .F. )
	oModel:GetModel( 'CENTER' ):showInsertMsg( .F. )
	oModel:GetModel( 'DOWN' ):showInsertMsg( .F. )
	*/

	oView:SetModel( oModel )

	//oStrCenter:SetProperty( '*'			, MVC_VIEW_CANCHANGE	, .F. )
	//oStrDown:SetProperty( '*'			, MVC_VIEW_CANCHANGE	, .F. )

	//oStrCenter:SetProperty('C5_ZSELECT'	, MVC_VIEW_CANCHANGE	, .T.)
	//oStrDown:SetProperty('C6_ZSELECT'	, MVC_VIEW_CANCHANGE	, .T.)

	oView:AddField('VIEW_TOP'		, oStrTop		, 'TOP'		)
	oView:AddGrid( 'VIEW_CENTER'	, oStrCenter	, 'CENTER'	)
	oView:AddGrid( 'VIEW_DOWN'		, oStrDown		, 'DOWN'	)
	oView:AddField( 'VIEW_CALC'		, oCalc1		, 'CALCFAT64' )

	oView:CreateHorizontalBox( 'BOX_TOP'	, 15)
	oView:CreateHorizontalBox( 'BOX_CENTER'	, 40)
	oView:CreateHorizontalBox( 'BOX_DOWN'	, 35)
	oView:CreateHorizontalBox( 'BOX_CALC'	, 10)

	oView:SetOwnerView('VIEW_TOP'		, 'BOX_TOP'		)
	oView:SetOwnerView('VIEW_CENTER'	, 'BOX_CENTER'	)
	oView:SetOwnerView('VIEW_DOWN'		, 'BOX_DOWN'	)
	oView:SetOwnerView('VIEW_CALC'		, 'BOX_CALC'	)

	oView:EnableTitleView('VIEW_TOP'		,'Filtro'				)
	oView:EnableTitleView('VIEW_CENTER'		,'Pedidos'				)
	oView:EnableTitleView('VIEW_DOWN'		,'Bloqueio do Pedido'	)

	//oView:SetViewProperty("VIEW_CENTER", "GRIDFILTER"	, {.T.})
	//oView:SetViewProperty("VIEW_CENTER", "GRIDSEEK"		, {.T.})

	oView:AddUserButton( 'Aprovar'			, 'CLIPS', {|| OMDLFAT64 := fwModelActive(), aprovaPv()		} )
	oView:AddUserButton( 'Reprovar'			, 'CLIPS', {|| OMDLFAT64 := fwModelActive(), motivoReje()	} )
	oView:AddUserButton( 'Buscar'			, 'CLIPS', {|| OMDLFAT64 := fwModelActive(), buscaPv()		} )
	oView:AddUserButton( 'Marcar Todos'		, 'CLIPS', {|| marcacao(.T.)								} )
	oView:AddUserButton( 'Desmarcar Todos'	, 'CLIPS', {|| marcacao(.F.)								} )

	oModel:GetModel( 'CENTER' ):SetOnlyQuery( .T. )
	oModel:GetModel( 'DOWN' ):SetOnlyQuery( .T. )

	oStrCenter:SetProperty('*'			, MVC_VIEW_CANCHANGE	, .F.)
	oStrCenter:SetProperty('C5_ZSELECT'	, MVC_VIEW_CANCHANGE	, .T.)

	oStrDown:SetProperty('*'			, MVC_VIEW_CANCHANGE	, .F.)
	oStrDown:SetProperty('C6_ZSELECT'	, MVC_VIEW_CANCHANGE	, .T.)
Return oView

Static Function fABA4ACor()
	Local cColor := CLR_YELLOW
Return cColor

//---------------------------------------------------------
// MODEL - TOP
//---------------------------------------------------------
static function gtMdlTop()
	Local oStruct := FWFormModelStruct():New()

	// FWFORMMODELSTRUCT():AddField(<cTitulo >, <cTooltip >, <cIdField >, <cTipo >, <nTamanho >, [ nDecimal ], [ bValid ], [ bWhen ], [ aValues ], [ lObrigat ], [ bInit ], <lKey >, [ lNoUpd ], [ lVirtual ], [ cValid ])
	oStruct:AddField(	"Data"					,; 	// [01] C Titulo do campo
						"Data"					,; 	// [02] C ToolTip do campo
						"DATA"	 				,; 	// [03] C identificador (ID) do Field
						"C" 					,; 	// [04] C Tipo do campo
						10						,; 	// [05] N Tamanho do campo
						0 						,; 	// [06] N Decimal do campo
						{ || .T. } 				,; 	// [07] B Code-block de validacao do campo
						{ || .T. }				,; 	// [08] B Code-block de validacao When do campo
						 						,; 	// [09] A Lista de valores permitido do campo
				      	.F. 					,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
												,; 	// [11] B Code-block de inicializacao do campo
						.F. 					,;	// [12] L Indica se trata de um campo chave
						.F.		 				,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
						.F. )  	            	// [14] L Indica se o campo � virtual

	oStruct:AddField(	"De"						,; 	// [01] C Titulo do campo
						"De"						,; 	// [02] C ToolTip do campo
						"DE"	 					,; 	// [03] C identificador (ID) do Field
						"D" 						,; 	// [04] C Tipo do campo
						8							,; 	// [05] N Tamanho do campo
						0 							,; 	// [06] N Decimal do campo
						{ || .T. } 				,; 	// [07] B Code-block de validacao do campo
						{ || .T. }				,; 	// [08] B Code-block de validacao When do campo
						 						,; 	// [09] A Lista de valores permitido do campo
				      	.F. 					,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
												,; 	// [11] B Code-block de inicializacao do campo
						.F. 					,;	// [12] L Indica se trata de um campo chave
						.F.		 				,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
						.F. )  	            	// [14] L Indica se o campo � virtual

	oStruct:AddField(	"Ate"						,; 	// [01] C Titulo do campo
						"Ate"						,; 	// [02] C ToolTip do campo
						"ATE"	 					,; 	// [03] C identificador (ID) do Field
						"D" 						,; 	// [04] C Tipo do campo
						8							,; 	// [05] N Tamanho do campo
						0 							,; 	// [06] N Decimal do campo
						{ || .T. } 				,; 	// [07] B Code-block de validacao do campo
						{ || .T. }				,; 	// [08] B Code-block de validacao When do campo
						 						,; 	// [09] A Lista de valores permitido do campo
				      	.F. 					,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
												,; 	// [11] B Code-block de inicializacao do campo
						.F. 					,;	// [12] L Indica se trata de um campo chave
						.F.		 				,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
						.F. )  	            	// [14] L Indica se o campo � virtual

	oStruct:AddField(	"Motivo de"							,; 	// [01] C Titulo do campo
						"Motivo de"							,; 	// [02] C ToolTip do campo
						"MOTIVODE"	 						,; 	// [03] C identificador (ID) do Field
						"C" 								,; 	// [04] C Tipo do campo
						tamSX3("ZT_CODIGO")[1]				,; 	// [05] N Tamanho do campo
						0 									,; 	// [06] N Decimal do campo
						{ || .T. } 				,; 	// [07] B Code-block de validacao do campo
						{ || .T. }				,; 	// [08] B Code-block de validacao When do campo
						 						,; 	// [09] A Lista de valores permitido do campo
				      	.F. 					,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
												,; 	// [11] B Code-block de inicializacao do campo
						.F. 					,;	// [12] L Indica se trata de um campo chave
						.F.		 				,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
						.F. )  	            	// [14] L Indica se o campo � virtual

	oStruct:AddField(	"Motivo ate"							,; 	// [01] C Titulo do campo
						"Motivo ate"							,; 	// [02] C ToolTip do campo
						"MOTIVOATE"	 						,; 	// [03] C identificador (ID) do Field
						"C" 								,; 	// [04] C Tipo do campo
						tamSX3("ZT_CODIGO")[1]				,; 	// [05] N Tamanho do campo
						0 									,; 	// [06] N Decimal do campo
						{ || .T. } 				,; 	// [07] B Code-block de validacao do campo
						{ || .T. }				,; 	// [08] B Code-block de validacao When do campo
						 						,; 	// [09] A Lista de valores permitido do campo
				      	.F. 					,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
												,; 	// [11] B Code-block de inicializacao do campo
						.F. 					,;	// [12] L Indica se trata de um campo chave
						.F.		 				,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
						.F. )  	            	// [14] L Indica se o campo � virtual

	oStruct:AddField(	"Regiao de"							,; 	// [01] C Titulo do campo
						"Regiao de"							,; 	// [02] C ToolTip do campo
						"REGIAODE"	 						,; 	// [03] C identificador (ID) do Field
						"C" 								,; 	// [04] C Tipo do campo
						tamSX3("A1_ZREGIAO")[1]				,; 	// [05] N Tamanho do campo
						0 									,; 	// [06] N Decimal do campo
						{ || .T. } 				,; 	// [07] B Code-block de validacao do campo
						{ || .T. }				,; 	// [08] B Code-block de validacao When do campo
						 						,; 	// [09] A Lista de valores permitido do campo
				      	.F. 					,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
												,; 	// [11] B Code-block de inicializacao do campo
						.F. 					,;	// [12] L Indica se trata de um campo chave
						.F.		 				,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
						.F. )  	            	// [14] L Indica se o campo � virtual

	oStruct:AddField(	"Regiao ate"							,; 	// [01] C Titulo do campo
						"Regiao ate"							,; 	// [02] C ToolTip do campo
						"REGIAOATE"	 						,; 	// [03] C identificador (ID) do Field
						"C" 								,; 	// [04] C Tipo do campo
						tamSX3("A1_ZREGIAO")[1]				,; 	// [05] N Tamanho do campo
						0 									,; 	// [06] N Decimal do campo
						{ || .T. } 				,; 	// [07] B Code-block de validacao do campo
						{ || .T. }				,; 	// [08] B Code-block de validacao When do campo
						 						,; 	// [09] A Lista de valores permitido do campo
				      	.F. 					,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
												,; 	// [11] B Code-block de inicializacao do campo
						.F. 					,;	// [12] L Indica se trata de um campo chave
						.F.		 				,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
						.F. )  	            	// [14] L Indica se o campo � virtual

	oStruct:AddField(	"Pedido"							,; 	// [01] C Titulo do campo
						"Pedido"							,; 	// [02] C ToolTip do campo
						"PEDIDO"	 						,; 	// [03] C identificador (ID) do Field
						"C" 								,; 	// [04] C Tipo do campo
						tamSX3("C5_NUM")[1]				,; 	// [05] N Tamanho do campo
						0 									,; 	// [06] N Decimal do campo
						{ || .T. } 				,; 	// [07] B Code-block de validacao do campo
						{ || .T. }				,; 	// [08] B Code-block de validacao When do campo
						 						,; 	// [09] A Lista de valores permitido do campo
				      	.F. 					,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
												,; 	// [11] B Code-block de inicializacao do campo
						.F. 					,;	// [12] L Indica se trata de um campo chave
						.F.		 				,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
						.F. )  	            	// [14] L Indica se o campo � virtual

	oStruct:AddField(	"Gerencia"							,; 	// [01] C Titulo do campo
						"Gerencia"							,; 	// [02] C ToolTip do campo
						"GERENCIA"	 						,; 	// [03] C identificador (ID) do Field
						"C" 								,; 	// [04] C Tipo do campo
						tamSX3("ZBH_REPRES")[1]				,; 	// [05] N Tamanho do campo
						0 									,; 	// [06] N Decimal do campo
						{ || .T. } 				,; 	// [07] B Code-block de validacao do campo
						{ || .T. }				,; 	// [08] B Code-block de validacao When do campo
						 						,; 	// [09] A Lista de valores permitido do campo
				      	.F. 					,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
												,; 	// [11] B Code-block de inicializacao do campo
						.F. 					,;	// [12] L Indica se trata de um campo chave
						.F.		 				,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
						.F. )  	            	// [14] L Indica se o campo � virtual

	oStruct:AddField(	"Classificacao"							,; 	// [01] C Titulo do campo
						"Classificacao"							,; 	// [02] C ToolTip do campo
						"CLASSE"	 						,; 	// [03] C identificador (ID) do Field
						"C" 								,; 	// [04] C Tipo do campo
						1				,; 	// [05] N Tamanho do campo
						0 									,; 	// [06] N Decimal do campo
						{ || .T. } 				,; 	// [07] B Code-block de validacao do campo
						{ || .T. }				,; 	// [08] B Code-block de validacao When do campo
												,; 	// [09] A Lista de valores permitido do campo
				      	.F. 					,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
												,; 	// [11] B Code-block de inicializacao do campo
						.F. 					,;	// [12] L Indica se trata de um campo chave
						.F.		 				,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
						.F. )  	            	// [14] L Indica se o campo � virtual

	oStruct:AddField(	"Buscar"						,; 	// [01] C Titulo do campo
						"Buscar"						,; 	// [02] C ToolTip do campo
						"BUSCAR"	 					,; 	// [03] C identificador (ID) do Field
						"BT" 							,; 	// [04] C Tipo do campo
						10								,; 	// [05] N Tamanho do campo
						0 								,; 	// [06] N Decimal do campo
						{ || OMDLFAT64 := FWModelActive(), buscaPv(), .T. }			,; 	// [07] B Code-block de validacao do campo
						{ || .T. }				,; 	// [08] B Code-block de validacao When do campo
						 						,; 	// [09] A Lista de valores permitido do campo
				      	.F. 					,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
												,; 	// [11] B Code-block de inicializacao do campo
						.F. 					,;	// [12] L Indica se trata de um campo chave
						.F.		 				,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
						.F. )  	            	// [14] L Indica se o campo � virtual

	oStruct:AddField(	"Visualizar Pedido"						,; 	// [01] C Titulo do campo
						"Visualizar Pedido"						,; 	// [02] C ToolTip do campo
						"VISUALPV"	 					,; 	// [03] C identificador (ID) do Field
						"BT" 							,; 	// [04] C Tipo do campo
						10								,; 	// [05] N Tamanho do campo
						0 								,; 	// [06] N Decimal do campo
						{ || visualPv(), .T. }			,; 	// [07] B Code-block de validacao do campo
						{ || .T. }				,; 	// [08] B Code-block de validacao When do campo
						 						,; 	// [09] A Lista de valores permitido do campo
				      	.F. 					,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
												,; 	// [11] B Code-block de inicializacao do campo
						.F. 					,;	// [12] L Indica se trata de um campo chave
						.F.		 				,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
						.F. )  	            	// [14] L Indica se o campo � virtual

	oStruct:AddField(	"Aprovar"						,; 	// [01] C Titulo do campo
						"Aprovar"						,; 	// [02] C ToolTip do campo
						"APROVPV"	 					,; 	// [03] C identificador (ID) do Field
						"BT" 							,; 	// [04] C Tipo do campo
						10								,; 	// [05] N Tamanho do campo
						0 								,; 	// [06] N Decimal do campo
						{ || OMDLFAT64 := FWModelActive(), aprovaPv(), .T. }			,; 	// [07] B Code-block de validacao do campo
						{ || .T. }				,; 	// [08] B Code-block de validacao When do campo
						 						,; 	// [09] A Lista de valores permitido do campo
				      	.F. 					,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
												,; 	// [11] B Code-block de inicializacao do campo
						.F. 					,;	// [12] L Indica se trata de um campo chave
						.F.		 				,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
						.F. )  	            	// [14] L Indica se o campo � virtual

	oStruct:AddField(	"Rejeitar"						,; 	// [01] C Titulo do campo
						"Rejeitar"						,; 	// [02] C ToolTip do campo
						"REJEITAPV"	 					,; 	// [03] C identificador (ID) do Field
						"BT" 							,; 	// [04] C Tipo do campo
						10								,; 	// [05] N Tamanho do campo
						0 								,; 	// [06] N Decimal do campo
						{ || OMDLFAT64 := FWModelActive(), motivoReje(), .T. }			,; 	// [07] B Code-block de validacao do campo
						{ || .T. }				,; 	// [08] B Code-block de validacao When do campo
						 						,; 	// [09] A Lista de valores permitido do campo
				      	.F. 					,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
												,; 	// [11] B Code-block de inicializacao do campo
						.F. 					,;	// [12] L Indica se trata de um campo chave
						.F.		 				,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
						.F. )  	            	// [14] L Indica se o campo � virtual

	oStruct:AddField(	"Posicao Cliente"						,; 	// [01] C Titulo do campo
						"Posicao Cliente"						,; 	// [02] C ToolTip do campo
						"POSICAO"	 					,; 	// [03] C identificador (ID) do Field
						"BT" 							,; 	// [04] C Tipo do campo
						10								,; 	// [05] N Tamanho do campo
						0 								,; 	// [06] N Decimal do campo
						{ || xMF10ClCon(), .T. }			,; 	// [07] B Code-block de validacao do campo
						{ || .T. }				,; 	// [08] B Code-block de validacao When do campo
						 						,; 	// [09] A Lista de valores permitido do campo
				      	.F. 					,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
												,; 	// [11] B Code-block de inicializacao do campo
						.F. 					,;	// [12] L Indica se trata de um campo chave
						.F.		 				,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
						.F. )  	            	// [14] L Indica se o campo � virtual

	oStruct:AddField(	"Acomp. Cobranca"						,; 	// [01] C Titulo do campo
						"Acomp. Cobranca"						,; 	// [02] C ToolTip do campo
						"ACOMPCOB"	 					,; 	// [03] C identificador (ID) do Field
						"BT" 							,; 	// [04] C Tipo do campo
						10								,; 	// [05] N Tamanho do campo
						0 								,; 	// [06] N Decimal do campo
						{ || aRotina := {}, U_MGFFIN36(),  aRotina := {}, .T. }			,; 	// [07] B Code-block de validacao do campo
						{ || .T. }				,; 	// [08] B Code-block de validacao When do campo
						 						,; 	// [09] A Lista de valores permitido do campo
				      	.F. 					,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
												,; 	// [11] B Code-block de inicializacao do campo
						.F. 					,;	// [12] L Indica se trata de um campo chave
						.F.		 				,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
						.F. )  	            	// [14] L Indica se o campo � virtual

	oStruct:AddField(	"Grade"						,; 	// [01] C Titulo do campo
						"Grade"						,; 	// [02] C ToolTip do campo
						"GRADE"	 					,; 	// [03] C identificador (ID) do Field
						"BT" 							,; 	// [04] C Tipo do campo
						10								,; 	// [05] N Tamanho do campo
						0 								,; 	// [06] N Decimal do campo
						{ || showGrid(), .T. }			,; 	// [07] B Code-block de validacao do campo
						{ || .T. }				,; 	// [08] B Code-block de validacao When do campo
						 						,; 	// [09] A Lista de valores permitido do campo
				      	.F. 					,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
												,; 	// [11] B Code-block de inicializacao do campo
						.F. 					,;	// [12] L Indica se trata de um campo chave
						.F.		 				,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
						.F. )  	            	// [14] L Indica se o campo � virtual

	oStruct:AddField(	"Posicao Estoque"						,; 	// [01] C Titulo do campo
						"Posicao Estoque"						,; 	// [02] C ToolTip do campo
						"POSESTOQUE"	 					,; 	// [03] C identificador (ID) do Field
						"BT" 							,; 	// [04] C Tipo do campo
						10								,; 	// [05] N Tamanho do campo
						0 								,; 	// [06] N Decimal do campo
						{ || StaticCall(MGFFAT13,FAT13_Saldo,), .T. }			,; 	// [07] B Code-block de validacao do campo
						{ || .T. }				,; 	// [08] B Code-block de validacao When do campo
						 						,; 	// [09] A Lista de valores permitido do campo
				      	.F. 					,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
												,; 	// [11] B Code-block de inicializacao do campo
						.F. 					,;	// [12] L Indica se trata de um campo chave
						.F.		 				,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
						.F. )  	            	// [14] L Indica se o campo � virtual

	oStruct:AddField(	"Marcar Todos"						,; 	// [01] C Titulo do campo
						"Marcar Todos"						,; 	// [02] C ToolTip do campo
						"MARCA"	 							,; 	// [03] C identificador (ID) do Field
						"BT" 								,; 	// [04] C Tipo do campo
						10									,; 	// [05] N Tamanho do campo
						0 									,; 	// [06] N Decimal do campo
						{ || marcacao(.T.), .T. }			,; 	// [07] B Code-block de validacao do campo
						{ || .T. }							,; 	// [08] B Code-block de validacao When do campo
						 									,; 	// [09] A Lista de valores permitido do campo
				      	.F. 								,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
				      										,; 	// [11] B Code-block de inicializacao do campo
						.F. 								,;	// [12] L Indica se trata de um campo chave
						.F.		 							,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
						.F. )  	            					// [14] L Indica se o campo � virtual

	oStruct:AddField(	"Desmarcar Todos"					,; 	// [01] C Titulo do campo
						"Desmarcar Todos"					,; 	// [02] C ToolTip do campo
						"DESMARCA"	 						,; 	// [03] C identificador (ID) do Field
						"BT" 								,; 	// [04] C Tipo do campo
						10									,; 	// [05] N Tamanho do campo
						0 									,; 	// [06] N Decimal do campo
						{ || marcacao(.F.), .T. }			,; 	// [07] B Code-block de validacao do campo
						{ || .T. }							,; 	// [08] B Code-block de validacao When do campo
						 									,; 	// [09] A Lista de valores permitido do campo
				      	.F. 								,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
				      										,; 	// [11] B Code-block de inicializacao do campo
						.F. 								,;	// [12] L Indica se trata de um campo chave
						.F.		 							,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
						.F. )  	            					// [14] L Indica se o campo � virtual

	oStruct:AddField(	"Lib Estoque"						,; 	// [01] C Titulo do campo
						"Lib Estoque"						,; 	// [02] C ToolTip do campo
						"LIBESTOQ"	 					,; 	// [03] C identificador (ID) do Field
						"BT" 							,; 	// [04] C Tipo do campo
						10								,; 	// [05] N Tamanho do campo
						0 								,; 	// [06] N Decimal do campo
						{ || fwMsgRun(, {|| U_MGFFAT68() }, "Processando. Aguarde...", "Selecionando Pedidos para Liberacao de Estoque..." ), .T. }			,; 	// [07] B Code-block de validacao do campo
						{ || .T. }				,; 	// [08] B Code-block de validacao When do campo
						 						,; 	// [09] A Lista de valores permitido do campo
				      	.F. 					,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
												,; 	// [11] B Code-block de inicializacao do campo
						.F. 					,;	// [12] L Indica se trata de um campo chave
						.F.		 				,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
						.F. )  	            	// [14] L Indica se o campo � virtual
return oStruct

//---------------------------------------------------------
// VIEW - TOP
//---------------------------------------------------------
static function getVwTop()
	Local oStruct := FWFormViewStruct():New()

	//oStruct:AddField('TP_REGRA'  ,'11',buscarSX3('DCF_REGRA' ,,aColsSX3),aColsSX3[1],Nil,'GET',aColsSX3[2],Nil,Nil  ,.T.,Nil,Nil,aRegra,10,Nil,.T.)

	oStruct:AddField(	"DATA"								,;	// [01] cIdField			ID do Field
						"01"								,;	// [02] cOrdem				Ordem do campo
						"Data"								,;	// [03] cTitulo				Titulo do campo
						"Tipo de Data"						,;	// [04] cDescric			Descricao completa do campo
						{}									,;	// [05] aHelp				Array com o help dos campos
						"GET"								,;	// [06] cType               Tipo
						""									,;	// [07] cPicture			Picture do Campo
						{||}								,;	// [08] bPictVar			Bloco de Picture var
						""									,;	// [09] cLookup				Chave para ser usado no Looup
						.T.									,;	// [10] lCanChange			Logico dizendo se o campo pode ser alterado
						""									,;	// [11] cFolder				Id da folder onde o Field esta
						""									,;	// [12] cGroup				Id do Group onde o field esta
						{"Emissao", "Embarque", "Entrega"}	,;	// [13] aComboValues		Array com os valores do combo
						NIL									,;	// [14] nMaxLenCombo		Tamanho maximo da maior opcao do combo
						'//'								,;	// [15] cIniBrow			Inicializador do Browse
						.T.									,;	// [16] lVirtual			Indica se o campo � Virtual
						""									,;	// [17] cPictVar			Picture Variavel
															,;	// [18] lInsertLine			Indica pulo de linha apos o campo
															)	// [19] nWidth				Largura fixa da apresentacao do campo

	oStruct:AddField(	"DE"								,;	// [01] cIdField			ID do Field
						"02"								,;	// [02] cOrdem				Ordem do campo
						"De"								,;	// [03] cTitulo				Titulo do campo
						"Data de"							,;	// [04] cDescric			Descricao completa do campo
						NIL									,;	// [05] aHelp				Array com o help dos campos
						"D"									,;	// [06] cType               Tipo
						NIL									,;	// [07] cPicture			Picture do Campo
						Nil									,;	// [08] bPictVar			Bloco de Picture var
						Nil									,;	// [09] cLookup				Chave para ser usado no Looup
						.T.									,;	// [10] lCanChange			Logico dizendo se o campo pode ser alterado
						Nil									,;	// [11] cFolder				Id da folder onde o Field esta
						NIL									,;	// [12] cGroup				Id do Group onde o field esta
						Nil									,;	// [13] aComboValues		Array com os valores do combo
						NIL									,;	// [14] nMaxLenCombo		Tamanho maximo da maior opcao do combo
						NIL									,;	// [15] cIniBrow			Inicializador do Browse
						.T.									,;	// [16] lVirtual			Indica se o campo � Virtual
						NIL									,;	// [17] cPictVar			Picture Variavel
						NIL	)									// [18] lInsertLine			Indica pulo de linha apos o campo

	oStruct:AddField(	"ATE"								,;	// [01] cIdField			ID do Field
						"03"								,;	// [02] cOrdem				Ordem do campo
						"Ate"								,;	// [03] cTitulo				Titulo do campo
						"Data ate"							,;	// [04] cDescric			Descricao completa do campo
						NIL									,;	// [05] aHelp				Array com o help dos campos
						"D"									,;	// [06] cType               Tipo
						NIL									,;	// [07] cPicture			Picture do Campo
						Nil									,;	// [08] bPictVar			Bloco de Picture var
						Nil									,;	// [09] cLookup				Chave para ser usado no Looup
						.T.									,;	// [10] lCanChange			Logico dizendo se o campo pode ser alterado
						Nil									,;	// [11] cFolder				Id da folder onde o Field esta
						NIL									,;	// [12] cGroup				Id do Group onde o field esta
						Nil									,;	// [13] aComboValues		Array com os valores do combo
						NIL									,;	// [14] nMaxLenCombo		Tamanho maximo da maior opcao do combo
						NIL									,;	// [15] cIniBrow			Inicializador do Browse
						.T.									,;	// [16] lVirtual			Indica se o campo � Virtual
						NIL									,;	// [17] cPictVar			Picture Variavel
						NIL	)									// [18] lInsertLine			Indica pulo de linha apos o campo

	oStruct:AddField(	"MOTIVODE"								,;	// [01] cIdField			ID do Field
						"04"									,;	// [02] cOrdem				Ordem do campo
						"Motivo de"								,;	// [03] cTitulo				Titulo do campo
						"Motivo de"								,;	// [04] cDescric			Descricao completa do campo
						NIL										,;	// [05] aHelp				Array com o help dos campos
						"GET"									,;	// [06] cType               Tipo
						NIL										,;	// [07] cPicture			Picture do Campo
						Nil										,;	// [08] bPictVar			Bloco de Picture var
						"SZT"									,;	// [09] cLookup				Chave para ser usado no Looup
						.T.										,;	// [10] lCanChange			Logico dizendo se o campo pode ser alterado
						Nil										,;	// [11] cFolder				Id da folder onde o Field esta
						NIL										,;	// [12] cGroup				Id do Group onde o field esta
						NIL										,;	// [13] aComboValues		Array com os valores do combo
						NIL										,;	// [14] nMaxLenCombo		Tamanho maximo da maior opcao do combo
						NIL										,;	// [15] cIniBrow			Inicializador do Browse
						.T.										,;	// [16] lVirtual			Indica se o campo � Virtual
						NIL										,;	// [17] cPictVar			Picture Variavel
						NIL	)										// [18] lInsertLine			Indica pulo de linha apos o campo

	oStruct:AddField(	"MOTIVOATE"								,;	// [01] cIdField			ID do Field
						"05"									,;	// [02] cOrdem				Ordem do campo
						"Motivo ate"								,;	// [03] cTitulo				Titulo do campo
						"Motivo ate"								,;	// [04] cDescric			Descricao completa do campo
						NIL										,;	// [05] aHelp				Array com o help dos campos
						"GET"									,;	// [06] cType               Tipo
						NIL										,;	// [07] cPicture			Picture do Campo
						Nil										,;	// [08] bPictVar			Bloco de Picture var
						"SZT"									,;	// [09] cLookup				Chave para ser usado no Looup
						.T.										,;	// [10] lCanChange			Logico dizendo se o campo pode ser alterado
						Nil										,;	// [11] cFolder				Id da folder onde o Field esta
						NIL										,;	// [12] cGroup				Id do Group onde o field esta
						NIL										,;	// [13] aComboValues		Array com os valores do combo
						NIL										,;	// [14] nMaxLenCombo		Tamanho maximo da maior opcao do combo
						NIL										,;	// [15] cIniBrow			Inicializador do Browse
						.T.										,;	// [16] lVirtual			Indica se o campo � Virtual
						NIL										,;	// [17] cPictVar			Picture Variavel
						NIL	)										// [18] lInsertLine			Indica pulo de linha apos o campo

	oStruct:AddField(	"REGIAODE"								,;	// [01] cIdField			ID do Field
						"06"									,;	// [02] cOrdem				Ordem do campo
						"Regiao de"								,;	// [03] cTitulo				Titulo do campo
						"Regiao de"								,;	// [04] cDescric			Descricao completa do campo
						NIL										,;	// [05] aHelp				Array com o help dos campos
						"GET"									,;	// [06] cType               Tipo
						NIL										,;	// [07] cPicture			Picture do Campo
						Nil										,;	// [08] bPictVar			Bloco de Picture var
						"SZP"									,;	// [09] cLookup				Chave para ser usado no Looup
						.T.										,;	// [10] lCanChange			Logico dizendo se o campo pode ser alterado
						Nil										,;	// [11] cFolder				Id da folder onde o Field esta
						NIL										,;	// [12] cGroup				Id do Group onde o field esta
						NIL										,;	// [13] aComboValues		Array com os valores do combo
						NIL										,;	// [14] nMaxLenCombo		Tamanho maximo da maior opcao do combo
						NIL										,;	// [15] cIniBrow			Inicializador do Browse
						.T.										,;	// [16] lVirtual			Indica se o campo � Virtual
						NIL										,;	// [17] cPictVar			Picture Variavel
						NIL	)										// [18] lInsertLine			Indica pulo de linha apos o campo

	oStruct:AddField(	"REGIAOATE"								,;	// [01] cIdField			ID do Field
						"07"									,;	// [02] cOrdem				Ordem do campo
						"Regiao ate"								,;	// [03] cTitulo				Titulo do campo
						"Regiao ate"								,;	// [04] cDescric			Descricao completa do campo
						NIL										,;	// [05] aHelp				Array com o help dos campos
						"GET"									,;	// [06] cType               Tipo
						NIL										,;	// [07] cPicture			Picture do Campo
						Nil										,;	// [08] bPictVar			Bloco de Picture var
						"SZP"									,;	// [09] cLookup				Chave para ser usado no Looup
						.T.										,;	// [10] lCanChange			Logico dizendo se o campo pode ser alterado
						Nil										,;	// [11] cFolder				Id da folder onde o Field esta
						NIL										,;	// [12] cGroup				Id do Group onde o field esta
						NIL										,;	// [13] aComboValues		Array com os valores do combo
						NIL										,;	// [14] nMaxLenCombo		Tamanho maximo da maior opcao do combo
						NIL										,;	// [15] cIniBrow			Inicializador do Browse
						.T.										,;	// [16] lVirtual			Indica se o campo � Virtual
						NIL										,;	// [17] cPictVar			Picture Variavel
						NIL	)										// [18] lInsertLine			Indica pulo de linha apos o campo

	oStruct:AddField(	"PEDIDO"								,;	// [01] cIdField			ID do Field
						"08"									,;	// [02] cOrdem				Ordem do campo
						"Pedido"								,;	// [03] cTitulo				Titulo do campo
						"Pedido"								,;	// [04] cDescric			Descricao completa do campo
						NIL										,;	// [05] aHelp				Array com o help dos campos
						"GET"									,;	// [06] cType               Tipo
						NIL										,;	// [07] cPicture			Picture do Campo
						Nil										,;	// [08] bPictVar			Bloco de Picture var
						"SC5"									,;	// [09] cLookup				Chave para ser usado no Looup
						.T.										,;	// [10] lCanChange			Logico dizendo se o campo pode ser alterado
						Nil										,;	// [11] cFolder				Id da folder onde o Field esta
						NIL										,;	// [12] cGroup				Id do Group onde o field esta
						NIL										,;	// [13] aComboValues		Array com os valores do combo
						NIL										,;	// [14] nMaxLenCombo		Tamanho maximo da maior opcao do combo
						NIL										,;	// [15] cIniBrow			Inicializador do Browse
						.T.										,;	// [16] lVirtual			Indica se o campo � Virtual
						NIL										,;	// [17] cPictVar			Picture Variavel
						NIL	)										// [18] lInsertLine			Indica pulo de linha apos o campo

	oStruct:AddField(	"GERENCIA"								,;	// [01] cIdField			ID do Field
						"09"									,;	// [02] cOrdem				Ordem do campo
						"Gerencia"								,;	// [03] cTitulo				Titulo do campo
						"Gerencia"								,;	// [04] cDescric			Descricao completa do campo
						NIL										,;	// [05] aHelp				Array com o help dos campos
						"GET"									,;	// [06] cType               Tipo
						NIL										,;	// [07] cPicture			Picture do Campo
						Nil										,;	// [08] bPictVar			Bloco de Picture var
						"ZBH2"									,;	// [09] cLookup				Chave para ser usado no Looup
						.T.										,;	// [10] lCanChange			Logico dizendo se o campo pode ser alterado
						Nil										,;	// [11] cFolder				Id da folder onde o Field esta
						NIL										,;	// [12] cGroup				Id do Group onde o field esta
						NIL										,;	// [13] aComboValues		Array com os valores do combo
						NIL										,;	// [14] nMaxLenCombo		Tamanho maximo da maior opcao do combo
						NIL										,;	// [15] cIniBrow			Inicializador do Browse
						.T.										,;	// [16] lVirtual			Indica se o campo � Virtual
						NIL										,;	// [17] cPictVar			Picture Variavel
						NIL	)										// [18] lInsertLine			Indica pulo de linha apos o campo

	oStruct:AddField(	"CLASSE"								,;	// [01] cIdField			ID do Field
						"11"									,;	// [02] cOrdem				Ordem do campo
						"Classificacao"								,;	// [03] cTitulo				Titulo do campo
						"Classificacao"								,;	// [04] cDescric			Descricao completa do campo
						NIL										,;	// [05] aHelp				Array com o help dos campos
						"GET"									,;	// [06] cType               Tipo
						""									,;	// [07] cPicture			Picture do Campo
						{||}								,;	// [08] bPictVar			Bloco de Picture var
						""									,;	// [09] cLookup				Chave para ser usado no Looup
						.T.									,;	// [10] lCanChange			Logico dizendo se o campo pode ser alterado
						""									,;	// [11] cFolder				Id da folder onde o Field esta
						""									,;	// [12] cGroup				Id do Group onde o field esta
						{"", "A", "B", "C", "D", "E"}	,;	// [13] aComboValues		Array com os valores do combo
						NIL									,;	// [14] nMaxLenCombo		Tamanho maximo da maior opcao do combo
						NIL									,;	// [15] cIniBrow			Inicializador do Browse
						.T.									,;	// [16] lVirtual			Indica se o campo � Virtual
						""									,;	// [17] cPictVar			Picture Variavel
															,;	// [18] lInsertLine			Indica pulo de linha apos o campo
															)	// [19] nWidth				Largura fixa da apresentacao do campo

	oStruct:AddField(	"BUSCAR"								,;	// [01] cIdField			ID do Field
						"12"									,;	// [02] cOrdem				Ordem do campo
						"Buscar"								,;	// [03] cTitulo				Titulo do campo
						"Buscar"								,;	// [04] cDescric			Descricao completa do campo
						NIL										,;	// [05] aHelp				Array com o help dos campos
						"BT"									,;	// [06] cType               Tipo
						NIL										,;	// [07] cPicture			Picture do Campo
						Nil										,;	// [08] bPictVar			Bloco de Picture var
						Nil										,;	// [09] cLookup				Chave para ser usado no Looup
						Nil										,;	// [10] lCanChange			Logico dizendo se o campo pode ser alterado
						Nil										,;	// [11] cFolder				Id da folder onde o Field esta
						NIL										,;	// [12] cGroup				Id do Group onde o field esta
						Nil										,;	// [13] aComboValues		Array com os valores do combo
						NIL										,;	// [14] nMaxLenCombo		Tamanho maximo da maior opcao do combo
						NIL										,;	// [15] cIniBrow			Inicializador do Browse
						NIL										,;	// [16] lVirtual			Indica se o campo � Virtual
						NIL										,;	// [17] cPictVar			Picture Variavel
						NIL										,;	// [18] lInsertLine			Indica pulo de linha apos o campo
							) // [19] nWidth Indica a largura fixa da coluna do grid

	oStruct:AddField(	"VISUALPV"								,;	// [01] cIdField			ID do Field
						"13"									,;	// [02] cOrdem				Ordem do campo
						"Visualiza PV"								,;	// [03] cTitulo				Titulo do campo
						"Visualiza PV"								,;	// [04] cDescric			Descricao completa do campo
						NIL										,;	// [05] aHelp				Array com o help dos campos
						"BT"									,;	// [06] cType               Tipo
						NIL										,;	// [07] cPicture			Picture do Campo
						Nil										,;	// [08] bPictVar			Bloco de Picture var
						Nil										,;	// [09] cLookup				Chave para ser usado no Looup
						Nil										,;	// [10] lCanChange			Logico dizendo se o campo pode ser alterado
						Nil										,;	// [11] cFolder				Id da folder onde o Field esta
						NIL										,;	// [12] cGroup				Id do Group onde o field esta
						Nil										,;	// [13] aComboValues		Array com os valores do combo
						NIL										,;	// [14] nMaxLenCombo		Tamanho maximo da maior opcao do combo
						NIL										,;	// [15] cIniBrow			Inicializador do Browse
						NIL										,;	// [16] lVirtual			Indica se o campo � Virtual
						NIL										,;	// [17] cPictVar			Picture Variavel
						NIL										,;	// [18] lInsertLine			Indica pulo de linha apos o campo
							) // [19] nWidth Indica a largura fixa da coluna do grid

	oStruct:AddField(	"APROVPV"								,;	// [01] cIdField			ID do Field
						"14"									,;	// [02] cOrdem				Ordem do campo
						"Aprovar"								,;	// [03] cTitulo				Titulo do campo
						"Aprovar"								,;	// [04] cDescric			Descricao completa do campo
						NIL										,;	// [05] aHelp				Array com o help dos campos
						"BT"									,;	// [06] cType               Tipo
						NIL										,;	// [07] cPicture			Picture do Campo
						Nil										,;	// [08] bPictVar			Bloco de Picture var
						Nil										,;	// [09] cLookup				Chave para ser usado no Looup
						Nil										,;	// [10] lCanChange			Logico dizendo se o campo pode ser alterado
						Nil										,;	// [11] cFolder				Id da folder onde o Field esta
						NIL										,;	// [12] cGroup				Id do Group onde o field esta
						Nil										,;	// [13] aComboValues		Array com os valores do combo
						NIL										,;	// [14] nMaxLenCombo		Tamanho maximo da maior opcao do combo
						NIL										,;	// [15] cIniBrow			Inicializador do Browse
						NIL										,;	// [16] lVirtual			Indica se o campo � Virtual
						NIL										,;	// [17] cPictVar			Picture Variavel
						NIL										,;	// [18] lInsertLine			Indica pulo de linha apos o campo
							) // [19] nWidth Indica a largura fixa da coluna do grid

	oStruct:AddField(	"REJEITAPV"								,;	// [01] cIdField			ID do Field
						"15"									,;	// [02] cOrdem				Ordem do campo
						"Rejeitar"								,;	// [03] cTitulo				Titulo do campo
						"Rejeitar"								,;	// [04] cDescric			Descricao completa do campo
						NIL										,;	// [05] aHelp				Array com o help dos campos
						"BT"									,;	// [06] cType               Tipo
						NIL										,;	// [07] cPicture			Picture do Campo
						Nil										,;	// [08] bPictVar			Bloco de Picture var
						Nil										,;	// [09] cLookup				Chave para ser usado no Looup
						Nil										,;	// [10] lCanChange			Logico dizendo se o campo pode ser alterado
						Nil										,;	// [11] cFolder				Id da folder onde o Field esta
						NIL										,;	// [12] cGroup				Id do Group onde o field esta
						Nil										,;	// [13] aComboValues		Array com os valores do combo
						NIL										,;	// [14] nMaxLenCombo		Tamanho maximo da maior opcao do combo
						NIL										,;	// [15] cIniBrow			Inicializador do Browse
						NIL										,;	// [16] lVirtual			Indica se o campo � Virtual
						NIL										,;	// [17] cPictVar			Picture Variavel
						NIL										,;	// [18] lInsertLine			Indica pulo de linha apos o campo
							) // [19] nWidth Indica a largura fixa da coluna do grid

	oStruct:AddField(	"POSICAO"								,;	// [01] cIdField			ID do Field
						"16"									,;	// [02] cOrdem				Ordem do campo
						"Posicao Cliente"								,;	// [03] cTitulo				Titulo do campo
						"Posicao Cliente"								,;	// [04] cDescric			Descricao completa do campo
						NIL										,;	// [05] aHelp				Array com o help dos campos
						"BT"									,;	// [06] cType               Tipo
						NIL										,;	// [07] cPicture			Picture do Campo
						Nil										,;	// [08] bPictVar			Bloco de Picture var
						Nil										,;	// [09] cLookup				Chave para ser usado no Looup
						Nil										,;	// [10] lCanChange			Logico dizendo se o campo pode ser alterado
						Nil										,;	// [11] cFolder				Id da folder onde o Field esta
						NIL										,;	// [12] cGroup				Id do Group onde o field esta
						Nil										,;	// [13] aComboValues		Array com os valores do combo
						NIL										,;	// [14] nMaxLenCombo		Tamanho maximo da maior opcao do combo
						NIL										,;	// [15] cIniBrow			Inicializador do Browse
						NIL										,;	// [16] lVirtual			Indica se o campo � Virtual
						NIL										,;	// [17] cPictVar			Picture Variavel
						NIL										,;	// [18] lInsertLine			Indica pulo de linha apos o campo
							) // [19] nWidth Indica a largura fixa da coluna do grid

	oStruct:AddField(	"ACOMPCOB"								,;	// [01] cIdField			ID do Field
						"17"									,;	// [02] cOrdem				Ordem do campo
						"Acomp. Cobranca"								,;	// [03] cTitulo				Titulo do campo
						"Acomp. Cobranca"								,;	// [04] cDescric			Descricao completa do campo
						NIL										,;	// [05] aHelp				Array com o help dos campos
						"BT"									,;	// [06] cType               Tipo
						NIL										,;	// [07] cPicture			Picture do Campo
						Nil										,;	// [08] bPictVar			Bloco de Picture var
						Nil										,;	// [09] cLookup				Chave para ser usado no Looup
						Nil										,;	// [10] lCanChange			Logico dizendo se o campo pode ser alterado
						Nil										,;	// [11] cFolder				Id da folder onde o Field esta
						NIL										,;	// [12] cGroup				Id do Group onde o field esta
						Nil										,;	// [13] aComboValues		Array com os valores do combo
						NIL										,;	// [14] nMaxLenCombo		Tamanho maximo da maior opcao do combo
						NIL										,;	// [15] cIniBrow			Inicializador do Browse
						NIL										,;	// [16] lVirtual			Indica se o campo � Virtual
						NIL										,;	// [17] cPictVar			Picture Variavel
						NIL										,;	// [18] lInsertLine			Indica pulo de linha apos o campo
							) // [19] nWidth Indica a largura fixa da coluna do grid

	oStruct:AddField(	"GRADE"								,;	// [01] cIdField			ID do Field
						"18"									,;	// [02] cOrdem				Ordem do campo
						"Grade"								,;	// [03] cTitulo				Titulo do campo
						"Grade"								,;	// [04] cDescric			Descricao completa do campo
						NIL										,;	// [05] aHelp				Array com o help dos campos
						"BT"									,;	// [06] cType               Tipo
						NIL										,;	// [07] cPicture			Picture do Campo
						Nil										,;	// [08] bPictVar			Bloco de Picture var
						Nil										,;	// [09] cLookup				Chave para ser usado no Looup
						Nil										,;	// [10] lCanChange			Logico dizendo se o campo pode ser alterado
						Nil										,;	// [11] cFolder				Id da folder onde o Field esta
						NIL										,;	// [12] cGroup				Id do Group onde o field esta
						Nil										,;	// [13] aComboValues		Array com os valores do combo
						NIL										,;	// [14] nMaxLenCombo		Tamanho maximo da maior opcao do combo
						NIL										,;	// [15] cIniBrow			Inicializador do Browse
						NIL										,;	// [16] lVirtual			Indica se o campo � Virtual
						NIL										,;	// [17] cPictVar			Picture Variavel
						NIL										,;	// [18] lInsertLine			Indica pulo de linha apos o campo
							) // [19] nWidth Indica a largura fixa da coluna do grid

	oStruct:AddField(	"POSESTOQUE"								,;	// [01] cIdField			ID do Field
						"19"									,;	// [02] cOrdem				Ordem do campo
						"Posicao Estoque"								,;	// [03] cTitulo				Titulo do campo
						"Posicao Estoque"								,;	// [04] cDescric			Descricao completa do campo
						NIL										,;	// [05] aHelp				Array com o help dos campos
						"BT"									,;	// [06] cType               Tipo
						NIL										,;	// [07] cPicture			Picture do Campo
						Nil										,;	// [08] bPictVar			Bloco de Picture var
						Nil										,;	// [09] cLookup				Chave para ser usado no Looup
						Nil										,;	// [10] lCanChange			Logico dizendo se o campo pode ser alterado
						Nil										,;	// [11] cFolder				Id da folder onde o Field esta
						NIL										,;	// [12] cGroup				Id do Group onde o field esta
						Nil										,;	// [13] aComboValues		Array com os valores do combo
						NIL										,;	// [14] nMaxLenCombo		Tamanho maximo da maior opcao do combo
						NIL										,;	// [15] cIniBrow			Inicializador do Browse
						NIL										,;	// [16] lVirtual			Indica se o campo � Virtual
						NIL										,;	// [17] cPictVar			Picture Variavel
						NIL										,;	// [18] lInsertLine			Indica pulo de linha apos o campo
							) // [19] nWidth Indica a largura fixa da coluna do grid

	oStruct:AddField(	"MARCA"									,;	// [01] cIdField			ID do Field
						"20"									,;	// [02] cOrdem				Ordem do campo
						"Marca Todos"							,;	// [03] cTitulo				Titulo do campo
						"Marca Todos"							,;	// [04] cDescric			Descricao completa do campo
						NIL										,;	// [05] aHelp				Array com o help dos campos
						"BT"									,;	// [06] cType               Tipo
						NIL										,;	// [07] cPicture			Picture do Campo
						Nil										,;	// [08] bPictVar			Bloco de Picture var
						Nil										,;	// [09] cLookup				Chave para ser usado no Looup
						Nil										,;	// [10] lCanChange			Logico dizendo se o campo pode ser alterado
						Nil										,;	// [11] cFolder				Id da folder onde o Field esta
						NIL										,;	// [12] cGroup				Id do Group onde o field esta
						Nil										,;	// [13] aComboValues		Array com os valores do combo
						NIL										,;	// [14] nMaxLenCombo		Tamanho maximo da maior opcao do combo
						NIL										,;	// [15] cIniBrow			Inicializador do Browse
						NIL										,;	// [16] lVirtual			Indica se o campo � Virtual
						NIL										,;	// [17] cPictVar			Picture Variavel
						NIL										,;	// [18] lInsertLine			Indica pulo de linha apos o campo
							) 										// [19] nWidth Indica a largura fixa da coluna do grid

	oStruct:AddField(	"DESMARCA"								,;	// [01] cIdField			ID do Field
						"21"									,;	// [02] cOrdem				Ordem do campo
						"Desmarca Todos"								,;	// [03] cTitulo				Titulo do campo
						"Desmarca Todos"								,;	// [04] cDescric			Descricao completa do campo
						NIL										,;	// [05] aHelp				Array com o help dos campos
						"BT"									,;	// [06] cType               Tipo
						NIL										,;	// [07] cPicture			Picture do Campo
						Nil										,;	// [08] bPictVar			Bloco de Picture var
						Nil										,;	// [09] cLookup				Chave para ser usado no Looup
						Nil										,;	// [10] lCanChange			Logico dizendo se o campo pode ser alterado
						Nil										,;	// [11] cFolder				Id da folder onde o Field esta
						NIL										,;	// [12] cGroup				Id do Group onde o field esta
						Nil										,;	// [13] aComboValues		Array com os valores do combo
						NIL										,;	// [14] nMaxLenCombo		Tamanho maximo da maior opcao do combo
						NIL										,;	// [15] cIniBrow			Inicializador do Browse
						NIL										,;	// [16] lVirtual			Indica se o campo � Virtual
						NIL										,;	// [17] cPictVar			Picture Variavel
						NIL										,;	// [18] lInsertLine			Indica pulo de linha apos o campo
							) // [19] nWidth Indica a largura fixa da coluna do grid

	oStruct:AddField(	"LIBESTOQ"								,;	// [01] cIdField			ID do Field
						"22"									,;	// [02] cOrdem				Ordem do campo
						"Lib Estoque"								,;	// [03] cTitulo				Titulo do campo
						"Lib Estoque"								,;	// [04] cDescric			Descricao completa do campo
						NIL										,;	// [05] aHelp				Array com o help dos campos
						"BT"									,;	// [06] cType               Tipo
						NIL										,;	// [07] cPicture			Picture do Campo
						Nil										,;	// [08] bPictVar			Bloco de Picture var
						Nil										,;	// [09] cLookup				Chave para ser usado no Looup
						Nil										,;	// [10] lCanChange			Logico dizendo se o campo pode ser alterado
						Nil										,;	// [11] cFolder				Id da folder onde o Field esta
						NIL										,;	// [12] cGroup				Id do Group onde o field esta
						Nil										,;	// [13] aComboValues		Array com os valores do combo
						NIL										,;	// [14] nMaxLenCombo		Tamanho maximo da maior opcao do combo
						NIL										,;	// [15] cIniBrow			Inicializador do Browse
						NIL										,;	// [16] lVirtual			Indica se o campo � Virtual
						NIL										,;	// [17] cPictVar			Picture Variavel
						NIL										,;	// [18] lInsertLine			Indica pulo de linha apos o campo
							) // [19] nWidth Indica a largura fixa da coluna do grid

return oStruct

//---------------------------------------------------------
// LOAD - TOP
//---------------------------------------------------------
static function loadTop()
	local aLoad := {}

	aadd(aLoad, {	space( 10 )		,; // DATA
					cToD('//')		,; // DE
					cToD('//')		,; // ATE
					space( 10 )		,; // MOTIVODE
					space( 10 )		,; // MOTIVOATE
					space( 10 )		,; // REGIAODE
					space( 10 )		,; // REGIAOATE
					space( 10 )		,; // PEDIDO
					""				,; // CLASSE
					""				,; // BUSCAR
					""				,; // VISUALPV
					""				,; // APROVPV
					""				,; // REJEITAPV
					""				,; // POSICAO
					""				,; // ACOMPCOB
					""				,; // GRADE
					""				,; // POSESTOQUE
					""				,; // MARCA
					""				,; // DESMARCA
					"" })				// LIBESTOQ
	aadd(aLoad, 0) //recno

return aLoad

//---------------------------------------------------------
// MODEL - CENTER
//---------------------------------------------------------
static function gtMdlCente()
	local oStruct := FWFormModelStruct():New()

	oStruct:AddField( ;// Ord. Tipo Desc.
	""				, ;	// [01]  C   Titulo do campo
	"C5_ZSELECT"	, ;	// [02]  C   ToolTip do campo
	"C5_ZSELECT"	, ;	// [03]  C   Id do Field
	'L'				, ;	// [04]  C   Tipo do campo
	1				, ;	// [05]  N   Tamanho do campo
	0				, ;	// [06]  N   Decimal do campo
	{ || .T. } 		,; 	// [07] B Code-block de validacao do campo
	{ || .T. }		,; 	// [08] B Code-block de validacao When do campo
	 				,; 	// [09] A Lista de valores permitido do campo
	.F. 			,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
					,; 	// [11] B Code-block de inicializacao do campo
	.F. 			,;	// [12] L Indica se trata de um campo chave
	.F.		 		,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
	.F. )  	           	// [14] L Indica se o campo � virtual

	oStruct:AddField( 	;// Ord. Tipo Desc.
	""						, ;	// [01]  C   Titulo do campo
	"C5_FILIAL"				, ;	// [02]  C   ToolTip do campo
	"C5_FILIAL"				, ;	// [03]  C   Id do Field
	'C'						, ;	// [04]  C   Tipo do campo
	tamSX3("C5_FILIAL")[1]		, ;	// [05]  N   Tamanho do campo
	0						, ;	// [06]  N   Decimal do campo
	{ || .T. } 		,; 	// [07] B Code-block de validacao do campo
	{ || .T. }		,; 	// [08] B Code-block de validacao When do campo
	 				,; 	// [09] A Lista de valores permitido do campo
	.F. 			,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
					,; 	// [11] B Code-block de inicializacao do campo
	.F. 			,;	// [12] L Indica se trata de um campo chave
	.F.		 		,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
	.F. )  	           	// [14] L Indica se o campo � virtual

	oStruct:AddField( 	;// Ord. Tipo Desc.
	""						, ;	// [01]  C   Titulo do campo
	"C5_NUM"				, ;	// [02]  C   ToolTip do campo
	"C5_NUM"				, ;	// [03]  C   Id do Field
	'C'						, ;	// [04]  C   Tipo do campo
	tamSX3("C5_NUM")[1]		, ;	// [05]  N   Tamanho do campo
	0						, ;	// [06]  N   Decimal do campo
	{ || .T. } 		,; 	// [07] B Code-block de validacao do campo
	{ || .T. }		,; 	// [08] B Code-block de validacao When do campo
	 				,; 	// [09] A Lista de valores permitido do campo
	.F. 			,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
					,; 	// [11] B Code-block de inicializacao do campo
	.F. 			,;	// [12] L Indica se trata de um campo chave
	.F.		 		,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
	.F. )  	           	// [14] L Indica se o campo � virtual

	oStruct:AddField( 	;// Ord. Tipo Desc.
	""						, ;	// [01]  C   Titulo do campo
	"C5_TIPO"				, ;	// [02]  C   ToolTip do campo
	"C5_TIPO"				, ;	// [03]  C   Id do Field
	'C'						, ;	// [04]  C   Tipo do campo
	tamSX3("C5_TIPO")[1]		, ;	// [05]  N   Tamanho do campo
	0						, ;	// [06]  N   Decimal do campo
	{ || .T. } 		,; 	// [07] B Code-block de validacao do campo
	{ || .T. }		,; 	// [08] B Code-block de validacao When do campo
	 				,; 	// [09] A Lista de valores permitido do campo
	.F. 			,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
					,; 	// [11] B Code-block de inicializacao do campo
	.F. 			,;	// [12] L Indica se trata de um campo chave
	.F.		 		,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
	.F. )  	           	// [14] L Indica se o campo � virtual

	oStruct:AddField( 	;// Ord. Tipo Desc.
	""						, ;	// [01]  C   Titulo do campo
	"C5_ZTIPPED"				, ;	// [02]  C   ToolTip do campo
	"C5_ZTIPPED"				, ;	// [03]  C   Id do Field
	'C'						, ;	// [04]  C   Tipo do campo
	tamSX3("C5_ZTIPPED")[1]		, ;	// [05]  N   Tamanho do campo
	0						, ;	// [06]  N   Decimal do campo
	{ || .T. } 		,; 	// [07] B Code-block de validacao do campo
	{ || .T. }		,; 	// [08] B Code-block de validacao When do campo
	 				,; 	// [09] A Lista de valores permitido do campo
	.F. 			,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
					,; 	// [11] B Code-block de inicializacao do campo
	.F. 			,;	// [12] L Indica se trata de um campo chave
	.F.		 		,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
	.F. )  	           	// [14] L Indica se o campo � virtual

	oStruct:AddField( 	;// Ord. Tipo Desc.
	""						, ;	// [01]  C   Titulo do campo
	"C5_EMISSAO"			, ;	// [02]  C   ToolTip do campo
	"C5_EMISSAO"			, ;	// [03]  C   Id do Field
	'D'						, ;	// [04]  C   Tipo do campo
	tamSX3("C5_EMISSAO")[1]	, ;	// [05]  N   Tamanho do campo
	0						, ;	// [06]  N   Decimal do campo
	{ || .T. } 		,; 	// [07] B Code-block de validacao do campo
	{ || .T. }		,; 	// [08] B Code-block de validacao When do campo
	 				,; 	// [09] A Lista de valores permitido do campo
	.F. 			,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
					,; 	// [11] B Code-block de inicializacao do campo
	.F. 			,;	// [12] L Indica se trata de um campo chave
	.F.		 		,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
	.F. )  	           	// [14] L Indica se o campo � virtual

	oStruct:AddField( 	;// Ord. Tipo Desc.
	""						, ;	// [01]  C   Titulo do campo
	"A1_ZCLASSE"			, ;	// [02]  C   ToolTip do campo
	"A1_ZCLASSE"			, ;	// [03]  C   Id do Field
	'C'						, ;	// [04]  C   Tipo do campo
	tamSX3("A1_ZCLASSE")[1]	, ;	// [05]  N   Tamanho do campo
	0						, ;	// [06]  N   Decimal do campo
	{ || .T. } 		,; 	// [07] B Code-block de validacao do campo
	{ || .T. }		,; 	// [08] B Code-block de validacao When do campo
	 				,; 	// [09] A Lista de valores permitido do campo
	.F. 			,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
					,; 	// [11] B Code-block de inicializacao do campo
	.F. 			,;	// [12] L Indica se trata de um campo chave
	.F.		 		,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
	.F. )  	           	// [14] L Indica se o campo � virtual

	oStruct:AddField( 	;// Ord. Tipo Desc.
	""						, ;	// [01]  C   Titulo do campo
	"C5_CLIENTE"			, ;	// [02]  C   ToolTip do campo
	"C5_CLIENTE"			, ;	// [03]  C   Id do Field
	'C'						, ;	// [04]  C   Tipo do campo
	tamSX3("C5_CLIENTE")[1]	, ;	// [05]  N   Tamanho do campo
	0						, ;	// [06]  N   Decimal do campo
	{ || .T. } 		,; 	// [07] B Code-block de validacao do campo
	{ || .T. }		,; 	// [08] B Code-block de validacao When do campo
	 				,; 	// [09] A Lista de valores permitido do campo
	.F. 			,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
					,; 	// [11] B Code-block de inicializacao do campo
	.F. 			,;	// [12] L Indica se trata de um campo chave
	.F.		 		,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
	.F. )  	           	// [14] L Indica se o campo � virtual

	oStruct:AddField( 	;// Ord. Tipo Desc.
	""						, ;	// [01]  C   Titulo do campo
	"C5_LOJACLI"			, ;	// [02]  C   ToolTip do campo
	"C5_LOJACLI"			, ;	// [03]  C   Id do Field
	'C'						, ;	// [04]  C   Tipo do campo
	tamSX3("C5_LOJACLI")[1]	, ;	// [05]  N   Tamanho do campo
	0						, ;	// [06]  N   Decimal do campo
	{ || .T. } 		,; 	// [07] B Code-block de validacao do campo
	{ || .T. }		,; 	// [08] B Code-block de validacao When do campo
	 				,; 	// [09] A Lista de valores permitido do campo
	.F. 			,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
					,; 	// [11] B Code-block de inicializacao do campo
	.F. 			,;	// [12] L Indica se trata de um campo chave
	.F.		 		,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
	.F. )  	           	// [14] L Indica se o campo � virtual

	oStruct:AddField( 	;// Ord. Tipo Desc.
	""						, ;	// [01]  C   Titulo do campo
	"A1_NOME"				, ;	// [02]  C   ToolTip do campo
	"A1_NOME"				, ;	// [03]  C   Id do Field
	'C'						, ;	// [04]  C   Tipo do campo
	tamSX3("A1_NOME")[1]	, ;	// [05]  N   Tamanho do campo
	0						, ;	// [06]  N   Decimal do campo
	{ || .T. } 		,; 	// [07] B Code-block de validacao do campo
	{ || .T. }		,; 	// [08] B Code-block de validacao When do campo
	 				,; 	// [09] A Lista de valores permitido do campo
	.F. 			,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
					,; 	// [11] B Code-block de inicializacao do campo
	.F. 			,;	// [12] L Indica se trata de um campo chave
	.F.		 		,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
	.F. )  	           	// [14] L Indica se o campo � virtual

	oStruct:AddField( 	;// Ord. Tipo Desc.
	""						, ;	// [01]  C   Titulo do campo
	"C5_CONDPAG"			, ;	// [02]  C   ToolTip do campo
	"C5_CONDPAG"			, ;	// [03]  C   Id do Field
	'C'						, ;	// [04]  C   Tipo do campo
	tamSX3("C5_CONDPAG")[1] + tamSX3("E4_DESCRI")[1] + 3	, ;	// [05]  N   Tamanho do campo
	0						, ;	// [06]  N   Decimal do campo
	{ || .T. } 		,; 	// [07] B Code-block de validacao do campo
	{ || .T. }		,; 	// [08] B Code-block de validacao When do campo
	 				,; 	// [09] A Lista de valores permitido do campo
	.F. 			,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
					,; 	// [11] B Code-block de inicializacao do campo
	.F. 			,;	// [12] L Indica se trata de um campo chave
	.F.		 		,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
	.F. )  	           	// [14] L Indica se o campo � virtual

	oStruct:AddField( 	;// Ord. Tipo Desc.
	""						, ;	// [01]  C   Titulo do campo
	"A1_COND"			, ;	// [02]  C   ToolTip do campo
	"A1_COND"			, ;	// [03]  C   Id do Field
	'C'						, ;	// [04]  C   Tipo do campo
	tamSX3("A1_COND")[1] + tamSX3("E4_DESCRI")[1] + 3	, ;	// [05]  N   Tamanho do campo
	0						, ;	// [06]  N   Decimal do campo
	{ || .T. } 		,; 	// [07] B Code-block de validacao do campo
	{ || .T. }		,; 	// [08] B Code-block de validacao When do campo
	 				,; 	// [09] A Lista de valores permitido do campo
	.F. 			,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
					,; 	// [11] B Code-block de inicializacao do campo
	.F. 			,;	// [12] L Indica se trata de um campo chave
	.F.		 		,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
	.F. )  	           	// [14] L Indica se o campo � virtual

	oStruct:AddField( 	;// Ord. Tipo Desc.
	""						, ;	// [01]  C   Titulo do campo
	"A1_LC"			, ;	// [02]  C   ToolTip do campo
	"A1_LC"			, ;	// [03]  C   Id do Field
	'N'						, ;	// [04]  C   Tipo do campo
	tamSX3("A1_LC")[1]	, ;	// [05]  N   Tamanho do campo
	tamSX3("A1_LC")[2]						, ;	// [06]  N   Decimal do campo
	{ || .T. } 		,; 	// [07] B Code-block de validacao do campo
	{ || .T. }		,; 	// [08] B Code-block de validacao When do campo
	 				,; 	// [09] A Lista de valores permitido do campo
	.F. 			,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
					,; 	// [11] B Code-block de inicializacao do campo
	.F. 			,;	// [12] L Indica se trata de um campo chave
	.F.		 		,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
	.F. )  	           	// [14] L Indica se o campo � virtual

	oStruct:AddField( 		;// Ord. Tipo Desc.
	""						, ;	// [01]  C   Titulo do campo
	"VLRPEDIDO"				, ;	// [02]  C   ToolTip do campo
	"VLRPEDIDO"				, ;	// [03]  C   Id do Field
	'N'						, ;	// [04]  C   Tipo do campo
	12						, ;	// [05]  N   Tamanho do campo
	2						, ;	// [06]  N   Decimal do campo
	{ || .T. } 		,; 	// [07] B Code-block de validacao do campo
	{ || .T. }		,; 	// [08] B Code-block de validacao When do campo
	 				,; 	// [09] A Lista de valores permitido do campo
	.F. 			,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
					,; 	// [11] B Code-block de inicializacao do campo
	.F. 			,;	// [12] L Indica se trata de um campo chave
	.F.		 		,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
	.F. )  	           	// [14] L Indica se o campo � virtual

	oStruct:AddField( 		;// Ord. Tipo Desc.
	""						, ;	// [01]  C   Titulo do campo
	"LIMDISP"				, ;	// [02]  C   ToolTip do campo
	"LIMDISP"				, ;	// [03]  C   Id do Field
	'N'						, ;	// [04]  C   Tipo do campo
	12						, ;	// [05]  N   Tamanho do campo
	2						, ;	// [06]  N   Decimal do campo
	{ || .T. } 		,; 	// [07] B Code-block de validacao do campo
	{ || .T. }		,; 	// [08] B Code-block de validacao When do campo
	 				,; 	// [09] A Lista de valores permitido do campo
	.F. 			,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
					,; 	// [11] B Code-block de inicializacao do campo
	.F. 			,;	// [12] L Indica se trata de um campo chave
	.F.		 		,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
	.F. )  	           	// [14] L Indica se o campo � virtual

//	oStruct:AddField( 		;// Ord. Tipo Desc.
//	""						, ;	// [01]  C   Titulo do campo
//	"LIMITESUPE"			, ;	// [02]  C   ToolTip do campo
//	"LIMITESUPE"			, ;	// [03]  C   Id do Field
//	'N'						, ;	// [04]  C   Tipo do campo
//	12						, ;	// [05]  N   Tamanho do campo
//	2						, ;	// [06]  N   Decimal do campo
//	{ || .T. } 		,; 	// [07] B Code-block de validacao do campo
//	{ || .T. }		,; 	// [08] B Code-block de validacao When do campo
//	 				,; 	// [09] A Lista de valores permitido do campo
//	.F. 			,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
//					,; 	// [11] B Code-block de inicializacao do campo
//	.F. 			,;	// [12] L Indica se trata de um campo chave
//	.F.		 		,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
//	.F. )  	           	// [14] L Indica se o campo � virtual

	oStruct:AddField( 		;// Ord. Tipo Desc.
	""						, ;	// [01]  C   Titulo do campo
	"SALDORA"			, ;	// [02]  C   ToolTip do campo
	"SALDORA"			, ;	// [03]  C   Id do Field
	'N'						, ;	// [04]  C   Tipo do campo
	12						, ;	// [05]  N   Tamanho do campo
	2						, ;	// [06]  N   Decimal do campo
	{ || .T. } 		,; 	// [07] B Code-block de validacao do campo
	{ || .T. }		,; 	// [08] B Code-block de validacao When do campo
	 				,; 	// [09] A Lista de valores permitido do campo
	.F. 			,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
					,; 	// [11] B Code-block de inicializacao do campo
	.F. 			,;	// [12] L Indica se trata de um campo chave
	.F.		 		,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
	.F. )  	           	// [14] L Indica se o campo � virtual

	oStruct:AddField( 		;// Ord. Tipo Desc.
	""						, ;	// [01]  C   Titulo do campo
	"TITATRASO"			, ;	// [02]  C   ToolTip do campo
	"TITATRASO"			, ;	// [03]  C   Id do Field
	'N'						, ;	// [04]  C   Tipo do campo
	12						, ;	// [05]  N   Tamanho do campo
	2						, ;	// [06]  N   Decimal do campo
	{ || .T. } 		,; 	// [07] B Code-block de validacao do campo
	{ || .T. }		,; 	// [08] B Code-block de validacao When do campo
	 				,; 	// [09] A Lista de valores permitido do campo
	.F. 			,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
					,; 	// [11] B Code-block de inicializacao do campo
	.F. 			,;	// [12] L Indica se trata de um campo chave
	.F.		 		,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
	.F. )  	           	// [14] L Indica se o campo � virtual

	oStruct:AddField( 	;// Ord. Tipo Desc.
	""						, ;	// [01]  C   Titulo do campo
	"SEGMENTO"			, ;	// [02]  C   ToolTip do campo
	"SEGMENTO"			, ;	// [03]  C   Id do Field
	'C'						, ;	// [04]  C   Tipo do campo
	tamSX3("ZBH_DESCRI")[1], ;	// [05]  N   Tamanho do campo
	0						, ;	// [06]  N   Decimal do campo
	{ || .T. } 		,; 	// [07] B Code-block de validacao do campo
	{ || .T. }		,; 	// [08] B Code-block de validacao When do campo
	 				,; 	// [09] A Lista de valores permitido do campo
	.F. 			,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
					,; 	// [11] B Code-block de inicializacao do campo
	.F. 			,;	// [12] L Indica se trata de um campo chave
	.F.		 		,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
	.F. )  	           	// [14] L Indica se o campo � virtual

	oStruct:AddField( 	;// Ord. Tipo Desc.
	""						, ;	// [01]  C   Titulo do campo
	"A1_ZREGIAO"			, ;	// [02]  C   ToolTip do campo
	"A1_ZREGIAO"			, ;	// [03]  C   Id do Field
	'C'						, ;	// [04]  C   Tipo do campo
	tamSX3("A1_ZREGIAO")[1] + tamSX3("ZP_DESCREG")[1] + 3	, ;	// [05]  N   Tamanho do campo
	0						, ;	// [06]  N   Decimal do campo
	{ || .T. } 		,; 	// [07] B Code-block de validacao do campo
	{ || .T. }		,; 	// [08] B Code-block de validacao When do campo
	 				,; 	// [09] A Lista de valores permitido do campo
	.F. 			,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
					,; 	// [11] B Code-block de inicializacao do campo
	.F. 			,;	// [12] L Indica se trata de um campo chave
	.F.		 		,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
	.F. )  	           	// [14] L Indica se o campo � virtual

	oStruct:AddField( 		;// Ord. Tipo Desc.
	""						, ;	// [01]  C   Titulo do campo
	"A1_ZREDE"				, ;	// [02]  C   ToolTip do campo
	"A1_ZREDE"				, ;	// [03]  C   Id do Field
	'C'						, ;	// [04]  C   Tipo do campo
	tamSX3("A1_ZREDE")[1] + tamSX3("ZQ_DESCR")[1] + 3  	, ;	// [05]  N   Tamanho do campo
	0						, ;	// [06]  N   Decimal do campo
	{ || .T. } 		,; 	// [07] B Code-block de validacao do campo
	{ || .T. }		,; 	// [08] B Code-block de validacao When do campo
	 				,; 	// [09] A Lista de valores permitido do campo
	.F. 			,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
					,; 	// [11] B Code-block de inicializacao do campo
	.F. 			,;	// [12] L Indica se trata de um campo chave
	.F.		 		,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
	.F. )  	           	// [14] L Indica se o campo � virtual


	oStruct:AddField( 		;// Ord. Tipo Desc.
	""						, ;	// [01]  C   Titulo do campo
	"C5_ZDTEMBA"				, ;	// [02]  C   ToolTip do campo
	"C5_ZDTEMBA"				, ;	// [03]  C   Id do Field
	'D'						, ;	// [04]  C   Tipo do campo
	tamSX3("C5_ZDTEMBA")[1]	, ;	// [05]  N   Tamanho do campo
	0						, ;	// [06]  N   Decimal do campo
	{ || .T. } 		,; 	// [07] B Code-block de validacao do campo
	{ || .T. }		,; 	// [08] B Code-block de validacao When do campo
	 				,; 	// [09] A Lista de valores permitido do campo
	.F. 			,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
					,; 	// [11] B Code-block de inicializacao do campo
	.F. 			,;	// [12] L Indica se trata de um campo chave
	.F.		 		,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
	.F. )  	           	// [14] L Indica se o campo � virtual

	oStruct:AddField( 		;// Ord. Tipo Desc.
	""						, ;	// [01]  C   Titulo do campo
	"C5_FECENT"				, ;	// [02]  C   ToolTip do campo
	"C5_FECENT"				, ;	// [03]  C   Id do Field
	'D'						, ;	// [04]  C   Tipo do campo
	tamSX3("C5_FECENT")[1]	, ;	// [05]  N   Tamanho do campo
	0						, ;	// [06]  N   Decimal do campo
	{ || .T. } 		,; 	// [07] B Code-block de validacao do campo
	{ || .T. }		,; 	// [08] B Code-block de validacao When do campo
	 				,; 	// [09] A Lista de valores permitido do campo
	.F. 			,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
					,; 	// [11] B Code-block de inicializacao do campo
	.F. 			,;	// [12] L Indica se trata de um campo chave
	.F.		 		,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
	.F. )  	           	// [14] L Indica se o campo � virtual

	oStruct:AddField( 		;// Ord. Tipo Desc.
	""						, ;	// [01]  C   Titulo do campo
	"A1_VEND"				, ;	// [02]  C   ToolTip do campo
	"A1_VEND"				, ;	// [03]  C   Id do Field
	'C'						, ;	// [04]  C   Tipo do campo
	tamSX3("A1_VEND")[1]	, ;	// [05]  N   Tamanho do campo
	0						, ;	// [06]  N   Decimal do campo
	{ || .T. } 		,; 	// [07] B Code-block de validacao do campo
	{ || .T. }		,; 	// [08] B Code-block de validacao When do campo
	 				,; 	// [09] A Lista de valores permitido do campo
	.F. 			,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
					,; 	// [11] B Code-block de inicializacao do campo
	.F. 			,;	// [12] L Indica se trata de um campo chave
	.F.		 		,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
	.F. )  	           	// [14] L Indica se o campo � virtual

	oStruct:AddField( 		;// Ord. Tipo Desc.
	""						, ;	// [01]  C   Titulo do campo
	"A3_NOME"				, ;	// [02]  C   ToolTip do campo
	"A3_NOME"				, ;	// [03]  C   Id do Field
	'C'						, ;	// [04]  C   Tipo do campo
	tamSX3("A3_NOME")[1]	, ;	// [05]  N   Tamanho do campo
	0						, ;	// [06]  N   Decimal do campo
	{ || .T. } 		,; 	// [07] B Code-block de validacao do campo
	{ || .T. }		,; 	// [08] B Code-block de validacao When do campo
	 				,; 	// [09] A Lista de valores permitido do campo
	.F. 			,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
					,; 	// [11] B Code-block de inicializacao do campo
	.F. 			,;	// [12] L Indica se trata de um campo chave
	.F.		 		,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
	.F. )  	           	// [14] L Indica se o campo � virtual

	oStruct:AddField( 		;// Ord. Tipo Desc.
	""						, ;	// [01]  C   Titulo do campo
	"ZBH_REPRES"				, ;	// [02]  C   ToolTip do campo
	"ZBH_REPRES"				, ;	// [03]  C   Id do Field
	'C'						, ;	// [04]  C   Tipo do campo
	tamSX3("ZBH_REPRES")[1]	, ;	// [05]  N   Tamanho do campo
	0						, ;	// [06]  N   Decimal do campo
	{ || .T. } 		,; 	// [07] B Code-block de validacao do campo
	{ || .T. }		,; 	// [08] B Code-block de validacao When do campo
	 				,; 	// [09] A Lista de valores permitido do campo
	.F. 			,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
					,; 	// [11] B Code-block de inicializacao do campo
	.F. 			,;	// [12] L Indica se trata de um campo chave
	.F.		 		,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
	.F. )  	           	// [14] L Indica se o campo � virtual

	oStruct:AddField( 		;// Ord. Tipo Desc.
	""						, ;	// [01]  C   Titulo do campo
	"NOMEGERENC"				, ;	// [02]  C   ToolTip do campo
	"NOMEGERENC"				, ;	// [03]  C   Id do Field
	'C'						, ;	// [04]  C   Tipo do campo
	tamSX3("A3_NOME")[1]	, ;	// [05]  N   Tamanho do campo
	0						, ;	// [06]  N   Decimal do campo
	{ || .T. } 		,; 	// [07] B Code-block de validacao do campo
	{ || .T. }		,; 	// [08] B Code-block de validacao When do campo
	 				,; 	// [09] A Lista de valores permitido do campo
	.F. 			,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
					,; 	// [11] B Code-block de inicializacao do campo
	.F. 			,;	// [12] L Indica se trata de um campo chave
	.F.		 		,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
	.F. )  	           	// [14] L Indica se o campo � virtual

	oStruct:AddField( 		;// Ord. Tipo Desc.
	""						, ;	// [01]  C   Titulo do campo
	"ZBH_DESCRI"				, ;	// [02]  C   ToolTip do campo
	"ZBH_DESCRI"				, ;	// [03]  C   Id do Field
	'C'						, ;	// [04]  C   Tipo do campo
	tamSX3("ZBH_DESCRI")[1]	, ;	// [05]  N   Tamanho do campo
	0						, ;	// [06]  N   Decimal do campo
	{ || .T. } 		,; 	// [07] B Code-block de validacao do campo
	{ || .T. }		,; 	// [08] B Code-block de validacao When do campo
	 				,; 	// [09] A Lista de valores permitido do campo
	.F. 			,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
					,; 	// [11] B Code-block de inicializacao do campo
	.F. 			,;	// [12] L Indica se trata de um campo chave
	.F.		 		,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
	.F. )  	           	// [14] L Indica se o campo � virtual

	oStruct:AddField( 		;// Ord. Tipo Desc.
	""						, ;	// [01]  C   Titulo do campo
	"C5_VEND1"				, ;	// [02]  C   ToolTip do campo
	"C5_VEND1"				, ;	// [03]  C   Id do Field
	'C'						, ;	// [04]  C   Tipo do campo
	tamSX3("C5_VEND1")[1]	, ;	// [05]  N   Tamanho do campo
	0						, ;	// [06]  N   Decimal do campo
	{ || .T. } 		,; 	// [07] B Code-block de validacao do campo
	{ || .T. }		,; 	// [08] B Code-block de validacao When do campo
	 				,; 	// [09] A Lista de valores permitido do campo
	.F. 			,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
					,; 	// [11] B Code-block de inicializacao do campo
	.F. 			,;	// [12] L Indica se trata de um campo chave
	.F.		 		,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
	.F. )  	           	// [14] L Indica se o campo � virtual

	oStruct:AddField( 		;// Ord. Tipo Desc.
	""						, ;	// [01]  C   Titulo do campo
	"VENDPED"				, ;	// [02]  C   ToolTip do campo
	"VENDPED"				, ;	// [03]  C   Id do Field
	'C'						, ;	// [04]  C   Tipo do campo
	tamSX3("A3_NOME")[1]	, ;	// [05]  N   Tamanho do campo
	0						, ;	// [06]  N   Decimal do campo
	{ || .T. } 		,; 	// [07] B Code-block de validacao do campo
	{ || .T. }		,; 	// [08] B Code-block de validacao When do campo
	 				,; 	// [09] A Lista de valores permitido do campo
	.F. 			,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
					,; 	// [11] B Code-block de inicializacao do campo
	.F. 			,;	// [12] L Indica se trata de um campo chave
	.F.		 		,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
	.F. )  	           	// [14] L Indica se o campo � virtual
return oStruct

//---------------------------------------------------------
// VIEW - CENTER
//---------------------------------------------------------
static function getVwCente()
	Local oStruct := FWFormViewStruct():New()

	oStruct:AddField(	"C5_ZSELECT"												,;	// [01]  C   Nome do Campo
					"01"															,;	// [02]  C   Ordem
					"Selecao"														,;	// [03]  C   Titulo do campo//"Descricao"
					"Selecao"														,;	// [04]  C   Descricao do campo//"Descricao"
					{}																,;	// [05]  A   Array com Help
					"L"																,;	// [06]  C   Tipo do campo
					""																,;	// [07]  C   Picture
					{||}															,;	// [08]  B   Bloco de Picture Var
					""																,;	// [09]  C   Consulta F3
					.T.																,;	// [10]  L   Indica se o campo � alteravel
					""																,;	// [11]  C   Pasta do campo
					""																,;	// [12]  C   Agrupamento do campo
																					,;	// [13]  A   Lista de valores permitido do campo (Combo)
																					,;	// [14]  N   Tamanho maximo da maior opcao do combo
					".F."															,;	// [15]  C   Inicializador de Browse
					.T.																,;	// [16]  L   Indica se o campo � virtual
					""																,;	// [17]  C   Picture Variavel
					NIL																,;	// [18]  L   Indica pulo de linha apos o campo
					30)																	// [19]	 N	 Largura fixa da apresentacao do campo

	oStruct:AddField(	"C5_FILIAL"												,;	// [01]  C   Nome do Campo
					"02"															,;	// [02]  C   Ordem
					"Filial"														,;	// [03]  C   Titulo do campo//"Descricao"
					"Filial"														,;	// [04]  C   Descricao do campo//"Descricao"
					NIL																,;	// [05]  A   Array com Help
					"C"																,;	// [06]  C   Tipo do campo
					""																,;	// [07]  C   Picture
					NIL																,;	// [08]  B   Bloco de Picture Var
					NIL																,;	// [09]  C   Consulta F3
					.T.																,;	// [10]  L   Indica se o campo � alteravel
					NIL																,;	// [11]  C   Pasta do campo
					NIL																,;	// [12]  C   Agrupamento do campo
					NIL																,;	// [13]  A   Lista de valores permitido do campo (Combo)
					NIL																,;	// [14]  N   Tamanho maximo da maior opcao do combo
					NIL																,;	// [15]  C   Inicializador de Browse
					.T.																,;	// [16]  L   Indica se o campo � virtual
					NIL																,;	// [17]  C   Picture Variavel
					NIL																,;	// [18]  L   Indica pulo de linha apos o campo
					60)												// [19]	 N	 Largura fixa da apresentacao do campo

	oStruct:AddField(	"C5_NUM"												,;	// [01]  C   Nome do Campo
					"03"															,;	// [02]  C   Ordem
					"Pedido"														,;	// [03]  C   Titulo do campo//"Descricao"
					"Pedido"														,;	// [04]  C   Descricao do campo//"Descricao"
					NIL																,;	// [05]  A   Array com Help
					"C"																,;	// [06]  C   Tipo do campo
					""																,;	// [07]  C   Picture
					NIL																,;	// [08]  B   Bloco de Picture Var
					NIL																,;	// [09]  C   Consulta F3
					.T.																,;	// [10]  L   Indica se o campo � alteravel
					NIL																,;	// [11]  C   Pasta do campo
					NIL																,;	// [12]  C   Agrupamento do campo
					NIL																,;	// [13]  A   Lista de valores permitido do campo (Combo)
					NIL																,;	// [14]  N   Tamanho maximo da maior opcao do combo
					NIL																,;	// [15]  C   Inicializador de Browse
					.T.																,;	// [16]  L   Indica se o campo � virtual
					NIL																,;	// [17]  C   Picture Variavel
					NIL																,;	// [18]  L   Indica pulo de linha apos o campo
					60)												// [19]	 N	 Largura fixa da apresentacao do campo

	oStruct:AddField(	"C5_TIPO"												,;	// [01]  C   Nome do Campo
					"04"															,;	// [02]  C   Ordem
					"Tipo"														,;	// [03]  C   Titulo do campo//"Descricao"
					"Tipo"														,;	// [04]  C   Descricao do campo//"Descricao"
					NIL																,;	// [05]  A   Array com Help
					"C"																,;	// [06]  C   Tipo do campo
					""																,;	// [07]  C   Picture
					NIL																,;	// [08]  B   Bloco de Picture Var
					NIL																,;	// [09]  C   Consulta F3
					.T.																,;	// [10]  L   Indica se o campo � alteravel
					NIL																,;	// [11]  C   Pasta do campo
					NIL																,;	// [12]  C   Agrupamento do campo
					NIL																,;	// [13]  A   Lista de valores permitido do campo (Combo)
					NIL																,;	// [14]  N   Tamanho maximo da maior opcao do combo
					NIL																,;	// [15]  C   Inicializador de Browse
					.T.																,;	// [16]  L   Indica se o campo � virtual
					NIL																,;	// [17]  C   Picture Variavel
					NIL																,;	// [18]  L   Indica pulo de linha apos o campo
					30)												// [19]	 N	 Largura fixa da apresentacao do campo

	oStruct:AddField(	"C5_ZTIPPED"												,;	// [01]  C   Nome do Campo
					"05"															,;	// [02]  C   Ordem
					"Especie"														,;	// [03]  C   Titulo do campo//"Descricao"
					"Especie"														,;	// [04]  C   Descricao do campo//"Descricao"
					NIL																,;	// [05]  A   Array com Help
					"C"																,;	// [06]  C   Tipo do campo
					""																,;	// [07]  C   Picture
					NIL																,;	// [08]  B   Bloco de Picture Var
					NIL																,;	// [09]  C   Consulta F3
					.T.																,;	// [10]  L   Indica se o campo � alteravel
					NIL																,;	// [11]  C   Pasta do campo
					NIL																,;	// [12]  C   Agrupamento do campo
					NIL																,;	// [13]  A   Lista de valores permitido do campo (Combo)
					NIL																,;	// [14]  N   Tamanho maximo da maior opcao do combo
					NIL																,;	// [15]  C   Inicializador de Browse
					.T.																,;	// [16]  L   Indica se o campo � virtual
					NIL																,;	// [17]  C   Picture Variavel
					NIL																,;	// [18]  L   Indica pulo de linha apos o campo
					30)												// [19]	 N	 Largura fixa da apresentacao do campo

	oStruct:AddField(	"C5_EMISSAO"												,;	// [01]  C   Nome do Campo
					"06"															,;	// [02]  C   Ordem
					"Emissao"														,;	// [03]  C   Titulo do campo//"Descricao"
					"Emissao"														,;	// [04]  C   Descricao do campo//"Descricao"
					NIL																,;	// [05]  A   Array com Help
					"D"																,;	// [06]  C   Tipo do campo
					""																,;	// [07]  C   Picture
					NIL																,;	// [08]  B   Bloco de Picture Var
					NIL																,;	// [09]  C   Consulta F3
					.T.																,;	// [10]  L   Indica se o campo � alteravel
					NIL																,;	// [11]  C   Pasta do campo
					NIL																,;	// [12]  C   Agrupamento do campo
					NIL																,;	// [13]  A   Lista de valores permitido do campo (Combo)
					NIL																,;	// [14]  N   Tamanho maximo da maior opcao do combo
					NIL																,;	// [15]  C   Inicializador de Browse
					.T.																,;	// [16]  L   Indica se o campo � virtual
					NIL																,;	// [17]  C   Picture Variavel
					NIL																)	// [18]  L   Indica pulo de linha apos o campo

	oStruct:AddField(	"A1_ZCLASSE"												,;	// [01]  C   Nome do Campo
					"07"															,;	// [02]  C   Ordem
					"Classificacao"														,;	// [03]  C   Titulo do campo//"Descricao"
					"Classificacao"														,;	// [04]  C   Descricao do campo//"Descricao"
					NIL																,;	// [05]  A   Array com Help
					"C"																,;	// [06]  C   Tipo do campo
					""																,;	// [07]  C   Picture
					NIL																,;	// [08]  B   Bloco de Picture Var
					NIL																,;	// [09]  C   Consulta F3
					.T.																,;	// [10]  L   Indica se o campo � alteravel
					NIL																,;	// [11]  C   Pasta do campo
					NIL																,;	// [12]  C   Agrupamento do campo
					NIL																,;	// [13]  A   Lista de valores permitido do campo (Combo)
					NIL																,;	// [14]  N   Tamanho maximo da maior opcao do combo
					NIL																,;	// [15]  C   Inicializador de Browse
					.T.																,;	// [16]  L   Indica se o campo � virtual
					NIL																,;	// [17]  C   Picture Variavel
					NIL																,;	// [18]  L   Indica pulo de linha apos o campo
					60)												// [19]	 N	 Largura fixa da apresentacao do campo

	oStruct:AddField(	"C5_CLIENTE"												,;	// [01]  C   Nome do Campo
					"08"															,;	// [02]  C   Ordem
					"Cod Cli"														,;	// [03]  C   Titulo do campo//"Descricao"
					"Cod Cli"														,;	// [04]  C   Descricao do campo//"Descricao"
					NIL																,;	// [05]  A   Array com Help
					"C"																,;	// [06]  C   Tipo do campo
					""																,;	// [07]  C   Picture
					NIL																,;	// [08]  B   Bloco de Picture Var
					NIL																,;	// [09]  C   Consulta F3
					.T.																,;	// [10]  L   Indica se o campo � alteravel
					NIL																,;	// [11]  C   Pasta do campo
					NIL																,;	// [12]  C   Agrupamento do campo
					NIL																,;	// [13]  A   Lista de valores permitido do campo (Combo)
					NIL																,;	// [14]  N   Tamanho maximo da maior opcao do combo
					NIL																,;	// [15]  C   Inicializador de Browse
					.T.																,;	// [16]  L   Indica se o campo � virtual
					NIL																,;	// [17]  C   Picture Variavel
					NIL																,;	// [18]  L   Indica pulo de linha apos o campo
					60)												// [19]	 N	 Largura fixa da apresentacao do campo

	oStruct:AddField(	"C5_LOJACLI"												,;	// [01]  C   Nome do Campo
					"09"															,;	// [02]  C   Ordem
					"Loja Cli"														,;	// [03]  C   Titulo do campo//"Descricao"
					"Loja Cli"														,;	// [04]  C   Descricao do campo//"Descricao"
					NIL																,;	// [05]  A   Array com Help
					"C"																,;	// [06]  C   Tipo do campo
					""																,;	// [07]  C   Picture
					NIL																,;	// [08]  B   Bloco de Picture Var
					NIL																,;	// [09]  C   Consulta F3
					.T.																,;	// [10]  L   Indica se o campo � alteravel
					NIL																,;	// [11]  C   Pasta do campo
					NIL																,;	// [12]  C   Agrupamento do campo
					NIL																,;	// [13]  A   Lista de valores permitido do campo (Combo)
					NIL																,;	// [14]  N   Tamanho maximo da maior opcao do combo
					NIL																,;	// [15]  C   Inicializador de Browse
					.T.																,;	// [16]  L   Indica se o campo � virtual
					NIL																,;	// [17]  C   Picture Variavel
					NIL																,;	// [18]  L   Indica pulo de linha apos o campo
					30)												// [19]	 N	 Largura fixa da apresentacao do campo


	oStruct:AddField(	"A1_NOME"												,;	// [01]  C   Nome do Campo
					"10"															,;	// [02]  C   Ordem
					"Cliente"														,;	// [03]  C   Titulo do campo//"Descricao"
					"Cliente"														,;	// [04]  C   Descricao do campo//"Descricao"
					NIL																,;	// [05]  A   Array com Help
					"C"																,;	// [06]  C   Tipo do campo
					""																,;	// [07]  C   Picture
					NIL																,;	// [08]  B   Bloco de Picture Var
					NIL																,;	// [09]  C   Consulta F3
					.T.																,;	// [10]  L   Indica se o campo � alteravel
					NIL																,;	// [11]  C   Pasta do campo
					NIL																,;	// [12]  C   Agrupamento do campo
					NIL																,;	// [13]  A   Lista de valores permitido do campo (Combo)
					NIL																,;	// [14]  N   Tamanho maximo da maior opcao do combo
					NIL																,;	// [15]  C   Inicializador de Browse
					.T.																,;	// [16]  L   Indica se o campo � virtual
					NIL																,;	// [17]  C   Picture Variavel
					NIL																,;	// [18]  L   Indica pulo de linha apos o campo
					200)												// [19]	 N	 Largura fixa da apresentacao do campo

	oStruct:AddField(	"NOMEGERENC"												,;	// [01]  C   Nome do Campo
					"11"															,;	// [02]  C   Ordem
					"Nome Gerencia"															,;	// [03]  C   Titulo do campo//"Descricao"
					"Nome Gerencia"															,;	// [04]  C   Descricao do campo//"Descricao"
					NIL																,;	// [05]  A   Array com Help
					"C"																,;	// [06]  C   Tipo do campo
					""																,;	// [07]  C   Picture
					NIL																,;	// [08]  B   Bloco de Picture Var
					NIL																,;	// [09]  C   Consulta F3
					.T.																,;	// [10]  L   Indica se o campo � alteravel
					NIL																,;	// [11]  C   Pasta do campo
					NIL																,;	// [12]  C   Agrupamento do campo
					NIL																,;	// [13]  A   Lista de valores permitido do campo (Combo)
					NIL																,;	// [14]  N   Tamanho maximo da maior opcao do combo
					NIL																,;	// [15]  C   Inicializador de Browse
					.T.																,;	// [16]  L   Indica se o campo � virtual
					NIL																,;	// [17]  C   Picture Variavel
					NIL																)	// [18]  L   Indica pulo de linha apos o campo

	oStruct:AddField(	"C5_CONDPAG"												,;	// [01]  C   Nome do Campo
					"12"															,;	// [02]  C   Ordem
					"Cond. Pgto."														,;	// [03]  C   Titulo do campo//"Descricao"
					"Cond. Pgto."														,;	// [04]  C   Descricao do campo//"Descricao"
					NIL																,;	// [05]  A   Array com Help
					"C"																,;	// [06]  C   Tipo do campo
					""																,;	// [07]  C   Picture
					NIL																,;	// [08]  B   Bloco de Picture Var
					NIL																,;	// [09]  C   Consulta F3
					.T.																,;	// [10]  L   Indica se o campo � alteravel
					NIL																,;	// [11]  C   Pasta do campo
					NIL																,;	// [12]  C   Agrupamento do campo
					NIL																,;	// [13]  A   Lista de valores permitido do campo (Combo)
					NIL																,;	// [14]  N   Tamanho maximo da maior opcao do combo
					NIL																,;	// [15]  C   Inicializador de Browse
					.T.																,;	// [16]  L   Indica se o campo � virtual
					NIL																,;	// [17]  C   Picture Variavel
					NIL																,;	// [18]  L   Indica pulo de linha apos o campo
					100)												// [19]	 N	 Largura fixa da apresentacao do campo

	oStruct:AddField(	"A1_COND"												,;	// [01]  C   Nome do Campo
					"13"															,;	// [02]  C   Ordem
					"Cond. Pgto. Cli."														,;	// [03]  C   Titulo do campo//"Descricao"
					"Cond. Pgto. Cli."														,;	// [04]  C   Descricao do campo//"Descricao"
					NIL																,;	// [05]  A   Array com Help
					"C"																,;	// [06]  C   Tipo do campo
					""																,;	// [07]  C   Picture
					NIL																,;	// [08]  B   Bloco de Picture Var
					NIL																,;	// [09]  C   Consulta F3
					.T.																,;	// [10]  L   Indica se o campo � alteravel
					NIL																,;	// [11]  C   Pasta do campo
					NIL																,;	// [12]  C   Agrupamento do campo
					NIL																,;	// [13]  A   Lista de valores permitido do campo (Combo)
					NIL																,;	// [14]  N   Tamanho maximo da maior opcao do combo
					NIL																,;	// [15]  C   Inicializador de Browse
					.T.																,;	// [16]  L   Indica se o campo � virtual
					NIL																,;	// [17]  C   Picture Variavel
					NIL																,;	// [18]  L   Indica pulo de linha apos o campo
					100)												// [19]	 N	 Largura fixa da apresentacao do campo

	oStruct:AddField(	"VLRPEDIDO"													,;	// [01]  C   Nome do Campo
					"14"															,;	// [02]  C   Ordem
					"Vlr. Pedido"														,;	// [03]  C   Titulo do campo//"Descricao"
					"Vlr. Pedido"														,;	// [04]  C   Descricao do campo//"Descricao"
					NIL																,;	// [05]  A   Array com Help
					"N"																,;	// [06]  C   Tipo do campo
					"@E 9,999,999,999.99"											,;	// [07]  C   Picture
					NIL																,;	// [08]  B   Bloco de Picture Var
					NIL																,;	// [09]  C   Consulta F3
					.T.																,;	// [10]  L   Indica se o campo � alteravel
					NIL																,;	// [11]  C   Pasta do campo
					NIL																,;	// [12]  C   Agrupamento do campo
					NIL																,;	// [13]  A   Lista de valores permitido do campo (Combo)
					NIL																,;	// [14]  N   Tamanho maximo da maior opcao do combo
					NIL																,;	// [15]  C   Inicializador de Browse
					.T.																,;	// [16]  L   Indica se o campo � virtual
					NIL																,;	// [17]  C   Picture Variavel
					NIL																,;	// [18]  L   Indica pulo de linha apos o campo
					100)												// [19]	 N	 Largura fixa da apresentacao do campo

	oStruct:AddField(	"A1_LC"												,;	// [01]  C   Nome do Campo
					"15"															,;	// [02]  C   Ordem
					"Vlr. LC."														,;	// [03]  C   Titulo do campo//"Descricao"
					"Vlr. LC."														,;	// [04]  C   Descricao do campo//"Descricao"
					NIL																,;	// [05]  A   Array com Help
					"N"																,;	// [06]  C   Tipo do campo
					"@E 9,999,999,999.99"																,;	// [07]  C   Picture
					NIL																,;	// [08]  B   Bloco de Picture Var
					NIL																,;	// [09]  C   Consulta F3
					.T.																,;	// [10]  L   Indica se o campo � alteravel
					NIL																,;	// [11]  C   Pasta do campo
					NIL																,;	// [12]  C   Agrupamento do campo
					NIL																,;	// [13]  A   Lista de valores permitido do campo (Combo)
					NIL																,;	// [14]  N   Tamanho maximo da maior opcao do combo
					NIL																,;	// [15]  C   Inicializador de Browse
					.T.																,;	// [16]  L   Indica se o campo � virtual
					NIL																,;	// [17]  C   Picture Variavel
					NIL																,;	// [18]  L   Indica pulo de linha apos o campo
					100)												// [19]	 N	 Largura fixa da apresentacao do campo

	oStruct:AddField(	"LIMDISP"													,;	// [01]  C   Nome do Campo
					"16"															,;	// [02]  C   Ordem
					"Dispon�vel"														,;	// [03]  C   Titulo do campo//"Descricao"
					"Dispon�vel"														,;	// [04]  C   Descricao do campo//"Descricao"
					NIL																,;	// [05]  A   Array com Help
					"N"																,;	// [06]  C   Tipo do campo
					"@E 9,999,999,999.99"																,;	// [07]  C   Picture
					NIL																,;	// [08]  B   Bloco de Picture Var
					NIL																,;	// [09]  C   Consulta F3
					.T.																,;	// [10]  L   Indica se o campo � alteravel
					NIL																,;	// [11]  C   Pasta do campo
					NIL																,;	// [12]  C   Agrupamento do campo
					NIL																,;	// [13]  A   Lista de valores permitido do campo (Combo)
					NIL																,;	// [14]  N   Tamanho maximo da maior opcao do combo
					NIL																,;	// [15]  C   Inicializador de Browse
					.T.																,;	// [16]  L   Indica se o campo � virtual
					NIL																,;	// [17]  C   Picture Variavel
					NIL																,;	// [18]  L   Indica pulo de linha apos o campo
					100)												// [19]	 N	 Largura fixa da apresentacao do campo

//	oStruct:AddField(	"LIMITESUPE"													,;	// [01]  C   Nome do Campo
//					"14"															,;	// [02]  C   Ordem
//					"Limite Superado"														,;	// [03]  C   Titulo do campo//"Descricao"
//					"Limite Superado"														,;	// [04]  C   Descricao do campo//"Descricao"
//					NIL																,;	// [05]  A   Array com Help
//					"N"																,;	// [06]  C   Tipo do campo
//					"@E 9,999,999,999.99"																,;	// [07]  C   Picture
//					NIL																,;	// [08]  B   Bloco de Picture Var
//					NIL																,;	// [09]  C   Consulta F3
//					.T.																,;	// [10]  L   Indica se o campo � alteravel
//					NIL																,;	// [11]  C   Pasta do campo
//					NIL																,;	// [12]  C   Agrupamento do campo
//					NIL																,;	// [13]  A   Lista de valores permitido do campo (Combo)
//					NIL																,;	// [14]  N   Tamanho maximo da maior opcao do combo
//					NIL																,;	// [15]  C   Inicializador de Browse
//					.T.																,;	// [16]  L   Indica se o campo � virtual
//					NIL																,;	// [17]  C   Picture Variavel
//					NIL																)	// [18]  L   Indica pulo de linha apos o campo

	oStruct:AddField(	"TITATRASO"													,;	// [01]  C   Nome do Campo
					"17"															,;	// [02]  C   Ordem
					"Atraso"														,;	// [03]  C   Titulo do campo//"Descricao"
					"Atraso"														,;	// [04]  C   Descricao do campo//"Descricao"
					NIL																,;	// [05]  A   Array com Help
					"N"																,;	// [06]  C   Tipo do campo
					"@E 9,999,999,999.99"																,;	// [07]  C   Picture
					NIL																,;	// [08]  B   Bloco de Picture Var
					NIL																,;	// [09]  C   Consulta F3
					.T.																,;	// [10]  L   Indica se o campo � alteravel
					NIL																,;	// [11]  C   Pasta do campo
					NIL																,;	// [12]  C   Agrupamento do campo
					NIL																,;	// [13]  A   Lista de valores permitido do campo (Combo)
					NIL																,;	// [14]  N   Tamanho maximo da maior opcao do combo
					NIL																,;	// [15]  C   Inicializador de Browse
					.T.																,;	// [16]  L   Indica se o campo � virtual
					NIL																,;	// [17]  C   Picture Variavel
					NIL																,;	// [18]  L   Indica pulo de linha apos o campo
					100)												// [19]	 N	 Largura fixa da apresentacao do campo

	oStruct:AddField(	"SALDORA"													,;	// [01]  C   Nome do Campo
					"18"															,;	// [02]  C   Ordem
					"Adiantamento"											,;	// [03]  C   Titulo do campo//"Descricao"
					"Adiantamento"											,;	// [04]  C   Descricao do campo//"Descricao"
					NIL																,;	// [05]  A   Array com Help
					"N"																,;	// [06]  C   Tipo do campo
					"@E 9,999,999,999.99"																,;	// [07]  C   Picture
					NIL																,;	// [08]  B   Bloco de Picture Var
					NIL																,;	// [09]  C   Consulta F3
					.T.																,;	// [10]  L   Indica se o campo � alteravel
					NIL																,;	// [11]  C   Pasta do campo
					NIL																,;	// [12]  C   Agrupamento do campo
					NIL																,;	// [13]  A   Lista de valores permitido do campo (Combo)
					NIL																,;	// [14]  N   Tamanho maximo da maior opcao do combo
					NIL																,;	// [15]  C   Inicializador de Browse
					.T.																,;	// [16]  L   Indica se o campo � virtual
					NIL																,;	// [17]  C   Picture Variavel
					NIL																,;	// [18]  L   Indica pulo de linha apos o campo
					100)												// [19]	 N	 Largura fixa da apresentacao do campo

	oStruct:AddField(	"SEGMENTO"												,;	// [01]  C   Nome do Campo
					"19"															,;	// [02]  C   Ordem
					"Segmento"														,;	// [03]  C   Titulo do campo//"Descricao"
					"Segmento"														,;	// [04]  C   Descricao do campo//"Descricao"
					NIL																,;	// [05]  A   Array com Help
					"C"																,;	// [06]  C   Tipo do campo
					""																,;	// [07]  C   Picture
					NIL																,;	// [08]  B   Bloco de Picture Var
					NIL																,;	// [09]  C   Consulta F3
					.T.																,;	// [10]  L   Indica se o campo � alteravel
					NIL																,;	// [11]  C   Pasta do campo
					NIL																,;	// [12]  C   Agrupamento do campo
					NIL																,;	// [13]  A   Lista de valores permitido do campo (Combo)
					NIL																,;	// [14]  N   Tamanho maximo da maior opcao do combo
					NIL																,;	// [15]  C   Inicializador de Browse
					.T.																,;	// [16]  L   Indica se o campo � virtual
					NIL																,;	// [17]  C   Picture Variavel
					NIL																)	// [18]  L   Indica pulo de linha apos o campo


	oStruct:AddField(	"A1_ZREGIAO"											,;	// [01]  C   Nome do Campo
					"20"															,;	// [02]  C   Ordem
					"Regiao"														,;	// [03]  C   Titulo do campo//"Descricao"
					"Regiao"														,;	// [04]  C   Descricao do campo//"Descricao"
					NIL																,;	// [05]  A   Array com Help
					"C"																,;	// [06]  C   Tipo do campo
					""																,;	// [07]  C   Picture
					NIL																,;	// [08]  B   Bloco de Picture Var
					NIL																,;	// [09]  C   Consulta F3
					.T.																,;	// [10]  L   Indica se o campo � alteravel
					NIL																,;	// [11]  C   Pasta do campo
					NIL																,;	// [12]  C   Agrupamento do campo
					NIL																,;	// [13]  A   Lista de valores permitido do campo (Combo)
					NIL																,;	// [14]  N   Tamanho maximo da maior opcao do combo
					NIL																,;	// [15]  C   Inicializador de Browse
					.T.																,;	// [16]  L   Indica se o campo � virtual
					NIL																,;	// [17]  C   Picture Variavel
					NIL																)	// [18]  L   Indica pulo de linha apos o campo

	oStruct:AddField(	"A1_ZREDE"												,;	// [01]  C   Nome do Campo
					"21"															,;	// [02]  C   Ordem
					"Rede"															,;	// [03]  C   Titulo do campo//"Descricao"
					"Rede"															,;	// [04]  C   Descricao do campo//"Descricao"
					NIL																,;	// [05]  A   Array com Help
					"C"																,;	// [06]  C   Tipo do campo
					""																,;	// [07]  C   Picture
					NIL																,;	// [08]  B   Bloco de Picture Var
					NIL																,;	// [09]  C   Consulta F3
					.T.																,;	// [10]  L   Indica se o campo � alteravel
					NIL																,;	// [11]  C   Pasta do campo
					NIL																,;	// [12]  C   Agrupamento do campo
					NIL																,;	// [13]  A   Lista de valores permitido do campo (Combo)
					NIL																,;	// [14]  N   Tamanho maximo da maior opcao do combo
					NIL																,;	// [15]  C   Inicializador de Browse
					.T.																,;	// [16]  L   Indica se o campo � virtual
					NIL																,;	// [17]  C   Picture Variavel
					NIL																)	// [18]  L   Indica pulo de linha apos o campo

	oStruct:AddField(	"C5_ZDTEMBA"												,;	// [01]  C   Nome do Campo
					"22"															,;	// [02]  C   Ordem
					"Embarque"															,;	// [03]  C   Titulo do campo//"Descricao"
					"Embarque"															,;	// [04]  C   Descricao do campo//"Descricao"
					NIL																,;	// [05]  A   Array com Help
					"D"																,;	// [06]  C   Tipo do campo
					""																,;	// [07]  C   Picture
					NIL																,;	// [08]  B   Bloco de Picture Var
					NIL																,;	// [09]  C   Consulta F3
					.T.																,;	// [10]  L   Indica se o campo � alteravel
					NIL																,;	// [11]  C   Pasta do campo
					NIL																,;	// [12]  C   Agrupamento do campo
					NIL																,;	// [13]  A   Lista de valores permitido do campo (Combo)
					NIL																,;	// [14]  N   Tamanho maximo da maior opcao do combo
					NIL																,;	// [15]  C   Inicializador de Browse
					.T.																,;	// [16]  L   Indica se o campo � virtual
					NIL																,;	// [17]  C   Picture Variavel
					NIL																)	// [18]  L   Indica pulo de linha apos o campo

	oStruct:AddField(	"C5_FECENT"												,;	// [01]  C   Nome do Campo
					"23"															,;	// [02]  C   Ordem
					"Entrega"															,;	// [03]  C   Titulo do campo//"Descricao"
					"Entrega"															,;	// [04]  C   Descricao do campo//"Descricao"
					NIL																,;	// [05]  A   Array com Help
					"D"																,;	// [06]  C   Tipo do campo
					""																,;	// [07]  C   Picture
					NIL																,;	// [08]  B   Bloco de Picture Var
					NIL																,;	// [09]  C   Consulta F3
					.T.																,;	// [10]  L   Indica se o campo � alteravel
					NIL																,;	// [11]  C   Pasta do campo
					NIL																,;	// [12]  C   Agrupamento do campo
					NIL																,;	// [13]  A   Lista de valores permitido do campo (Combo)
					NIL																,;	// [14]  N   Tamanho maximo da maior opcao do combo
					NIL																,;	// [15]  C   Inicializador de Browse
					.T.																,;	// [16]  L   Indica se o campo � virtual
					NIL																,;	// [17]  C   Picture Variavel
					NIL																)	// [18]  L   Indica pulo de linha apos o campo

	oStruct:AddField(	"A1_VEND"												,;	// [01]  C   Nome do Campo
					"24"															,;	// [02]  C   Ordem
					"Cod. Repres."															,;	// [03]  C   Titulo do campo//"Descricao"
					"Cod. Repres."															,;	// [04]  C   Descricao do campo//"Descricao"
					NIL																,;	// [05]  A   Array com Help
					"C"																,;	// [06]  C   Tipo do campo
					""																,;	// [07]  C   Picture
					NIL																,;	// [08]  B   Bloco de Picture Var
					NIL																,;	// [09]  C   Consulta F3
					.T.																,;	// [10]  L   Indica se o campo � alteravel
					NIL																,;	// [11]  C   Pasta do campo
					NIL																,;	// [12]  C   Agrupamento do campo
					NIL																,;	// [13]  A   Lista de valores permitido do campo (Combo)
					NIL																,;	// [14]  N   Tamanho maximo da maior opcao do combo
					NIL																,;	// [15]  C   Inicializador de Browse
					.T.																,;	// [16]  L   Indica se o campo � virtual
					NIL																,;	// [17]  C   Picture Variavel
					NIL																)	// [18]  L   Indica pulo de linha apos o campo

	oStruct:AddField(	"A3_NOME"												,;	// [01]  C   Nome do Campo
					"25"															,;	// [02]  C   Ordem
					"Nome Repres."															,;	// [03]  C   Titulo do campo//"Descricao"
					"Nome Repres."															,;	// [04]  C   Descricao do campo//"Descricao"
					NIL																,;	// [05]  A   Array com Help
					"C"																,;	// [06]  C   Tipo do campo
					""																,;	// [07]  C   Picture
					NIL																,;	// [08]  B   Bloco de Picture Var
					NIL																,;	// [09]  C   Consulta F3
					.T.																,;	// [10]  L   Indica se o campo � alteravel
					NIL																,;	// [11]  C   Pasta do campo
					NIL																,;	// [12]  C   Agrupamento do campo
					NIL																,;	// [13]  A   Lista de valores permitido do campo (Combo)
					NIL																,;	// [14]  N   Tamanho maximo da maior opcao do combo
					NIL																,;	// [15]  C   Inicializador de Browse
					.T.																,;	// [16]  L   Indica se o campo � virtual
					NIL																,;	// [17]  C   Picture Variavel
					NIL																)	// [18]  L   Indica pulo de linha apos o campo

	oStruct:AddField(	"ZBH_REPRES"												,;	// [01]  C   Nome do Campo
					"26"															,;	// [02]  C   Ordem
					"Gerencia"															,;	// [03]  C   Titulo do campo//"Descricao"
					"Gerencia"															,;	// [04]  C   Descricao do campo//"Descricao"
					NIL																,;	// [05]  A   Array com Help
					"C"																,;	// [06]  C   Tipo do campo
					""																,;	// [07]  C   Picture
					NIL																,;	// [08]  B   Bloco de Picture Var
					NIL																,;	// [09]  C   Consulta F3
					.T.																,;	// [10]  L   Indica se o campo � alteravel
					NIL																,;	// [11]  C   Pasta do campo
					NIL																,;	// [12]  C   Agrupamento do campo
					NIL																,;	// [13]  A   Lista de valores permitido do campo (Combo)
					NIL																,;	// [14]  N   Tamanho maximo da maior opcao do combo
					NIL																,;	// [15]  C   Inicializador de Browse
					.T.																,;	// [16]  L   Indica se o campo � virtual
					NIL																,;	// [17]  C   Picture Variavel
					NIL																)	// [18]  L   Indica pulo de linha apos o campo

	oStruct:AddField(	"ZBH_DESCRI"												,;	// [01]  C   Nome do Campo
					"27"															,;	// [02]  C   Ordem
					"Depto."															,;	// [03]  C   Titulo do campo//"Descricao"
					"Depto."															,;	// [04]  C   Descricao do campo//"Descricao"
					NIL																,;	// [05]  A   Array com Help
					"C"																,;	// [06]  C   Tipo do campo
					""																,;	// [07]  C   Picture
					NIL																,;	// [08]  B   Bloco de Picture Var
					NIL																,;	// [09]  C   Consulta F3
					.T.																,;	// [10]  L   Indica se o campo � alteravel
					NIL																,;	// [11]  C   Pasta do campo
					NIL																,;	// [12]  C   Agrupamento do campo
					NIL																,;	// [13]  A   Lista de valores permitido do campo (Combo)
					NIL																,;	// [14]  N   Tamanho maximo da maior opcao do combo
					NIL																,;	// [15]  C   Inicializador de Browse
					.T.																,;	// [16]  L   Indica se o campo � virtual
					NIL																,;	// [17]  C   Picture Variavel
					NIL																)	// [18]  L   Indica pulo de linha apos o campo

	oStruct:AddField(	"C5_VEND1"												,;	// [01]  C   Nome do Campo
					"28"															,;	// [02]  C   Ordem
					"Cod. Repres. Pedido"															,;	// [03]  C   Titulo do campo//"Descricao"
					"Cod. Repres. Pedido"															,;	// [04]  C   Descricao do campo//"Descricao"
					NIL																,;	// [05]  A   Array com Help
					"C"																,;	// [06]  C   Tipo do campo
					""																,;	// [07]  C   Picture
					NIL																,;	// [08]  B   Bloco de Picture Var
					NIL																,;	// [09]  C   Consulta F3
					.T.																,;	// [10]  L   Indica se o campo � alteravel
					NIL																,;	// [11]  C   Pasta do campo
					NIL																,;	// [12]  C   Agrupamento do campo
					NIL																,;	// [13]  A   Lista de valores permitido do campo (Combo)
					NIL																,;	// [14]  N   Tamanho maximo da maior opcao do combo
					NIL																,;	// [15]  C   Inicializador de Browse
					.T.																,;	// [16]  L   Indica se o campo � virtual
					NIL																,;	// [17]  C   Picture Variavel
					NIL																)	// [18]  L   Indica pulo de linha apos o campo

	oStruct:AddField(	"VENDPED"												,;	// [01]  C   Nome do Campo
					"29"															,;	// [02]  C   Ordem
					"Representante Pedido"															,;	// [03]  C   Titulo do campo//"Descricao"
					"Representante Pedido"															,;	// [04]  C   Descricao do campo//"Descricao"
					NIL																,;	// [05]  A   Array com Help
					"C"																,;	// [06]  C   Tipo do campo
					""																,;	// [07]  C   Picture
					NIL																,;	// [08]  B   Bloco de Picture Var
					NIL																,;	// [09]  C   Consulta F3
					.T.																,;	// [10]  L   Indica se o campo � alteravel
					NIL																,;	// [11]  C   Pasta do campo
					NIL																,;	// [12]  C   Agrupamento do campo
					NIL																,;	// [13]  A   Lista de valores permitido do campo (Combo)
					NIL																,;	// [14]  N   Tamanho maximo da maior opcao do combo
					NIL																,;	// [15]  C   Inicializador de Browse
					.T.																,;	// [16]  L   Indica se o campo � virtual
					NIL																,;	// [17]  C   Picture Variavel
					NIL																)	// [18]  L   Indica pulo de linha apos o campo
return oStruct

//---------------------------------------------------------
// LOAD - CENTER
//---------------------------------------------------------
static function loadCenter()
	local aLoad := {}

	aadd(aLoad, { 0, { .F.															,; // C5_ZSELECT
					space( tamSX3("C5_FILIAL")[1] )									,; // C5_FILIAL
					space( tamSX3("C5_NUM")[1] )									,; // C5_NUM
					space( tamSX3("C5_TIPO")[1] )									,; // C5_TIPO
					space( tamSX3("C5_ZTIPPED")[1] )								,; // C5_ZTIPPED
					cToD('//')														,; // C5_EMISSAO
					space( tamSX3("A1_ZCLASSE")[1] )								,; // A1_ZCLASSE
					space( tamSX3("C5_CLIENTE")[1] )								,; // C5_CLIENTE
					space( tamSX3("C5_LOJACLI")[1] )								,; // C5_LOJACLI
					space( tamSX3("A1_NOME")[1] )									,; // A1_NOME
					space( tamSX3("C5_CONDPAG")[1] + tamSX3("E4_DESCRI")[1] + 3 )	,; // C5_CONDPAG
					space( tamSX3("A1_COND")[1] + tamSX3("E4_DESCRI")[1] + 3 )	,; // A1_COND
					0																,; // A1_LC
					0																,; // VLRPEDIDO
					0																,; // LIMDISP // LIMITESUPE
					0																,; // TITATRASO
					0																,; // SALDORA
					space( tamSX3("ZBH_DESCRI")[1] )	,; // SEGMENTO
					space( tamSX3("A1_ZREGIAO")[1] + tamSX3("ZP_DESCREG")[1] + 3 )	,; // A1_ZREGIAO
					space( tamSX3("A1_ZREDE")[1] + tamSX3("ZQ_DESCR")[1] + 3 )		,; // A1_ZREDE
					cToD('//')														,; // C5_ZDTEMBA
					cToD('//')														,; // C5_FECENT
					space( tamSX3("A1_VEND")[1] )									,; // A1_VEND
					space( tamSX3("A3_NOME")[1] )									,; // A3_NOME
					space( tamSX3("ZBH_REPRES")[1] )								,; // ZBH_REPRES
					space( tamSX3("A3_NOME")[1] )									,; // NOMEGERENC
					space( tamSX3("ZBH_DESCRI")[1] )								,; // ZBH_DESCRI
					space( tamSX3("C5_VEND1")[1] )									,; // C5_VEND1
					space( tamSX3("A3_NOME")[1] )									,; // VENDPED
					} } )

return aLoad

//---------------------------------------------------------
// MODEL - DOWN
//---------------------------------------------------------
static function gtMdlDown()
	local oStruct := FWFormModelStruct():New()

	/******************************************************************************
	ADICAO DE CAMPOS - DOWN
	******************************************************************************/
	oStruct:AddField( ;// Ord. Tipo Desc.
	""				, ;	// [01]  C   Titulo do campo
	"C6_ZSELECT"	, ;	// [02]  C   ToolTip do campo
	"C6_ZSELECT"	, ;	// [03]  C   Id do Field
	'L'				, ;	// [04]  C   Tipo do campo
	1				, ;	// [05]  N   Tamanho do campo
	0				, ;	// [06]  N   Decimal do campo
	{ || .T. } 		,; 	// [07] B Code-block de validacao do campo
	{ || .T. }		,; 	// [08] B Code-block de validacao When do campo
	 				,; 	// [09] A Lista de valores permitido do campo
	.F. 			,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
					,; 	// [11] B Code-block de inicializacao do campo
	.F. 			,;	// [12] L Indica se trata de um campo chave
	.F.		 		,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
	.F. )  	           	// [14] L Indica se o campo � virtual

	oStruct:AddField( 	;// Ord. Tipo Desc.
	""						, ;	// [01]  C   Titulo do campo
	"C6_FILIAL"				, ;	// [02]  C   ToolTip do campo
	"C6_FILIAL"				, ;	// [03]  C   Id do Field
	'C'						, ;	// [04]  C   Tipo do campo
	tamSX3("C6_FILIAL")[1]	, ;	// [05]  N   Tamanho do campo
	0						, ;	// [06]  N   Decimal do campo
	{ || .T. } 		,; 	// [07] B Code-block de validacao do campo
	{ || .T. }		,; 	// [08] B Code-block de validacao When do campo
	 				,; 	// [09] A Lista de valores permitido do campo
	.F. 			,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
					,; 	// [11] B Code-block de inicializacao do campo
	.F. 			,;	// [12] L Indica se trata de um campo chave
	.F.		 		,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
	.F. )  	           	// [14] L Indica se o campo � virtual

	oStruct:AddField( 	;// Ord. Tipo Desc.
	""						, ;	// [01]  C   Titulo do campo
	"ZV_CODRGA"				, ;	// [02]  C   ToolTip do campo
	"ZV_CODRGA"				, ;	// [03]  C   Id do Field
	'C'						, ;	// [04]  C   Tipo do campo
	tamSX3("ZV_CODRGA")[1]	, ;	// [05]  N   Tamanho do campo
	0						, ;	// [06]  N   Decimal do campo
	{ || .T. } 		,; 	// [07] B Code-block de validacao do campo
	{ || .T. }		,; 	// [08] B Code-block de validacao When do campo
	 				,; 	// [09] A Lista de valores permitido do campo
	.F. 			,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
					,; 	// [11] B Code-block de inicializacao do campo
	.F. 			,;	// [12] L Indica se trata de um campo chave
	.F.		 		,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
	.F. )  	           	// [14] L Indica se o campo � virtual

	oStruct:AddField( 	;// Ord. Tipo Desc.
	""						, ;	// [01]  C   Titulo do campo
	"ZT_DESCRI"				, ;	// [02]  C   ToolTip do campo
	"ZT_DESCRI"				, ;	// [03]  C   Id do Field
	'C'						, ;	// [04]  C   Tipo do campo
	tamSX3("ZT_DESCRI")[1]	, ;	// [05]  N   Tamanho do campo
	0						, ;	// [06]  N   Decimal do campo
	{ || .T. } 		,; 	// [07] B Code-block de validacao do campo
	{ || .T. }		,; 	// [08] B Code-block de validacao When do campo
	 				,; 	// [09] A Lista de valores permitido do campo
	.F. 			,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
					,; 	// [11] B Code-block de inicializacao do campo
	.F. 			,;	// [12] L Indica se trata de um campo chave
	.F.		 		,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
	.F. )  	           	// [14] L Indica se o campo � virtual

	oStruct:AddField( 	;// Ord. Tipo Desc.
	""						, ;	// [01]  C   Titulo do campo
	"ZV_DTBLQ"				, ;	// [02]  C   ToolTip do campo
	"ZV_DTBLQ"				, ;	// [03]  C   Id do Field
	'D'						, ;	// [04]  C   Tipo do campo
	tamSX3("ZV_DTBLQ")[1]	, ;	// [05]  N   Tamanho do campo
	0						, ;	// [06]  N   Decimal do campo
	{ || .T. } 		,; 	// [07] B Code-block de validacao do campo
	{ || .T. }		,; 	// [08] B Code-block de validacao When do campo
	 				,; 	// [09] A Lista de valores permitido do campo
	.F. 			,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
					,; 	// [11] B Code-block de inicializacao do campo
	.F. 			,;	// [12] L Indica se trata de um campo chave
	.F.		 		,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
	.F. )  	           	// [14] L Indica se o campo � virtual

	oStruct:AddField( 	;// Ord. Tipo Desc.
	""						, ;	// [01]  C   Titulo do campo
	"C6_ITEM"				, ;	// [02]  C   ToolTip do campo
	"C6_ITEM"				, ;	// [03]  C   Id do Field
	'C'						, ;	// [04]  C   Tipo do campo
	tamSX3("C6_ITEM")[1]	, ;	// [05]  N   Tamanho do campo
	0						, ;	// [06]  N   Decimal do campo
	{ || .T. } 		,; 	// [07] B Code-block de validacao do campo
	{ || .T. }		,; 	// [08] B Code-block de validacao When do campo
	 				,; 	// [09] A Lista de valores permitido do campo
	.F. 			,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
					,; 	// [11] B Code-block de inicializacao do campo
	.F. 			,;	// [12] L Indica se trata de um campo chave
	.F.		 		,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
	.F. )  	           	// [14] L Indica se o campo � virtual

	oStruct:AddField( 	;// Ord. Tipo Desc.
	""						, ;	// [01]  C   Titulo do campo
	"C6_NUM"				, ;	// [02]  C   ToolTip do campo
	"C6_NUM"				, ;	// [03]  C   Id do Field
	'C'						, ;	// [04]  C   Tipo do campo
	tamSX3("C6_NUM")[1]	, ;	// [05]  N   Tamanho do campo
	0						, ;	// [06]  N   Decimal do campo
	{ || .T. } 		,; 	// [07] B Code-block de validacao do campo
	{ || .T. }		,; 	// [08] B Code-block de validacao When do campo
	 				,; 	// [09] A Lista de valores permitido do campo
	.F. 			,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
					,; 	// [11] B Code-block de inicializacao do campo
	.F. 			,;	// [12] L Indica se trata de um campo chave
	.F.		 		,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
	.F. )  	           	// [14] L Indica se o campo � virtual

	oStruct:AddField( 	;// Ord. Tipo Desc.
	""						, ;	// [01]  C   Titulo do campo
	"C6_PRODUTO"				, ;	// [02]  C   ToolTip do campo
	"C6_PRODUTO"				, ;	// [03]  C   Id do Field
	'C'						, ;	// [04]  C   Tipo do campo
	tamSX3("C6_PRODUTO")[1]	, ;	// [05]  N   Tamanho do campo
	0						, ;	// [06]  N   Decimal do campo
	{ || .T. } 		,; 	// [07] B Code-block de validacao do campo
	{ || .T. }		,; 	// [08] B Code-block de validacao When do campo
	 				,; 	// [09] A Lista de valores permitido do campo
	.F. 			,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
					,; 	// [11] B Code-block de inicializacao do campo
	.F. 			,;	// [12] L Indica se trata de um campo chave
	.F.		 		,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
	.F. )  	           	// [14] L Indica se o campo � virtual

	oStruct:AddField( 	;// Ord. Tipo Desc.
	""						, ;	// [01]  C   Titulo do campo
	"B1_DESC"				, ;	// [02]  C   ToolTip do campo
	"B1_DESC"				, ;	// [03]  C   Id do Field
	'C'						, ;	// [04]  C   Tipo do campo
	tamSX3("B1_DESC")[1]	, ;	// [05]  N   Tamanho do campo
	0						, ;	// [06]  N   Decimal do campo
	{ || .T. } 		,; 	// [07] B Code-block de validacao do campo
	{ || .T. }		,; 	// [08] B Code-block de validacao When do campo
	 				,; 	// [09] A Lista de valores permitido do campo
	.F. 			,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
					,; 	// [11] B Code-block de inicializacao do campo
	.F. 			,;	// [12] L Indica se trata de um campo chave
	.F.		 		,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
	.F. )  	           	// [14] L Indica se o campo � virtual


	oStruct:AddField( 	;// Ord. Tipo Desc.
	""						, ;	// [01]  C   Titulo do campo
	"C6_QTDVEN"				, ;	// [02]  C   ToolTip do campo
	"C6_QTDVEN"				, ;	// [03]  C   Id do Field
	'N'						, ;	// [04]  C   Tipo do campo
	tamSX3("C6_QTDVEN")[1]	, ;	// [05]  N   Tamanho do campo
	tamSX3("C6_QTDVEN")[2]	, ;	// [06]  N   Decimal do campo
	{ || .T. } 		,; 	// [07] B Code-block de validacao do campo
	{ || .T. }		,; 	// [08] B Code-block de validacao When do campo
	 				,; 	// [09] A Lista de valores permitido do campo
	.F. 			,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
					,; 	// [11] B Code-block de inicializacao do campo
	.F. 			,;	// [12] L Indica se trata de um campo chave
	.F.		 		,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
	.F. )  	           	// [14] L Indica se o campo � virtual

	oStruct:AddField( 	;// Ord. Tipo Desc.
	""						, ;	// [01]  C   Titulo do campo
	"C6_PRCVEN"				, ;	// [02]  C   ToolTip do campo
	"C6_PRCVEN"				, ;	// [03]  C   Id do Field
	'N'						, ;	// [04]  C   Tipo do campo
	tamSX3("C6_PRCVEN")[1]	, ;	// [05]  N   Tamanho do campo
	tamSX3("C6_PRCVEN")[2]	, ;	// [06]  N   Decimal do campo
	{ || .T. } 		,; 	// [07] B Code-block de validacao do campo
	{ || .T. }		,; 	// [08] B Code-block de validacao When do campo
	 				,; 	// [09] A Lista de valores permitido do campo
	.F. 			,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
					,; 	// [11] B Code-block de inicializacao do campo
	.F. 			,;	// [12] L Indica se trata de um campo chave
	.F.		 		,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
	.F. )  	           	// [14] L Indica se o campo � virtual

	oStruct:AddField( 	;// Ord. Tipo Desc.
	""						, ;	// [01]  C   Titulo do campo
	"C6_PRUNIT"				, ;	// [02]  C   ToolTip do campo
	"C6_PRUNIT"				, ;	// [03]  C   Id do Field
	'N'						, ;	// [04]  C   Tipo do campo
	tamSX3("C6_PRUNIT")[1]	, ;	// [05]  N   Tamanho do campo
	tamSX3("C6_PRUNIT")[2]	, ;	// [06]  N   Decimal do campo
	{ || .T. } 		,; 	// [07] B Code-block de validacao do campo
	{ || .T. }		,; 	// [08] B Code-block de validacao When do campo
	 				,; 	// [09] A Lista de valores permitido do campo
	.F. 			,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
					,; 	// [11] B Code-block de inicializacao do campo
	.F. 			,;	// [12] L Indica se trata de um campo chave
	.F.		 		,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
	.F. )  	           	// [14] L Indica se o campo � virtual

	oStruct:AddField( 	;// Ord. Tipo Desc.
	""						, ;	// [01]  C   Titulo do campo
	"C6_VALOR"				, ;	// [02]  C   ToolTip do campo
	"C6_VALOR"				, ;	// [03]  C   Id do Field
	'N'						, ;	// [04]  C   Tipo do campo
	tamSX3("C6_VALOR")[1]	, ;	// [05]  N   Tamanho do campo
	tamSX3("C6_VALOR")[2]	, ;	// [06]  N   Decimal do campo
	{ || .T. } 		,; 	// [07] B Code-block de validacao do campo
	{ || .T. }		,; 	// [08] B Code-block de validacao When do campo
	 				,; 	// [09] A Lista de valores permitido do campo
	.F. 			,;	// [10] L Indica se o campo tem preenchimento obrigat�rio
					,; 	// [11] B Code-block de inicializacao do campo
	.F. 			,;	// [12] L Indica se trata de um campo chave
	.F.		 		,; 	// [13] L Indica se o campo pode receber valor em uma operacao de update.
	.F. )  	           	// [14] L Indica se o campo � virtual

return oStruct

//---------------------------------------------------------
// VIEW - DOWN
//---------------------------------------------------------
static function getVwDown()
	local oStruct := FWFormViewStruct():New()

	oStruct:AddField(	"C6_ZSELECT"												,;	// [01]  C   Nome do Campo
					"01"															,;	// [02]  C   Ordem
					"Selecao"														,;	// [03]  C   Titulo do campo//"Descricao"
					"Selecao"														,;	// [04]  C   Descricao do campo//"Descricao"
					NIL																,;	// [05]  A   Array com Help
					"L"																,;	// [06]  C   Tipo do campo
					""																,;	// [07]  C   Picture
					NIL																,;	// [08]  B   Bloco de Picture Var
					NIL																,;	// [09]  C   Consulta F3
					.T.																,;	// [10]  L   Indica se o campo � alteravel
					NIL																,;	// [11]  C   Pasta do campo
					NIL																,;	// [12]  C   Agrupamento do campo
					NIL																,;	// [13]  A   Lista de valores permitido do campo (Combo)
					NIL																,;	// [14]  N   Tamanho maximo da maior opcao do combo
					".F."															,;	// [15]  C   Inicializador de Browse
					.T.																,;	// [16]  L   Indica se o campo � virtual
					NIL																,;	// [17]  C   Picture Variavel
					NIL																,;	// [18]  L   Indica pulo de linha apos o campo
					30)																	// [19]	 N	 Largura fixa da apresentacao do campo

	oStruct:AddField(	"C6_FILIAL"												,;	// [01]  C   Nome do Campo
					"02"															,;	// [02]  C   Ordem
					"Filial"														,;	// [03]  C   Titulo do campo//"Descricao"
					"Filial"														,;	// [04]  C   Descricao do campo//"Descricao"
					NIL																,;	// [05]  A   Array com Help
					"C"																,;	// [06]  C   Tipo do campo
					""																,;	// [07]  C   Picture
					NIL																,;	// [08]  B   Bloco de Picture Var
					NIL																,;	// [09]  C   Consulta F3
					.T.																,;	// [10]  L   Indica se o campo � alteravel
					NIL																,;	// [11]  C   Pasta do campo
					NIL																,;	// [12]  C   Agrupamento do campo
					NIL																,;	// [13]  A   Lista de valores permitido do campo (Combo)
					NIL																,;	// [14]  N   Tamanho maximo da maior opcao do combo
					NIL																,;	// [15]  C   Inicializador de Browse
					.T.																,;	// [16]  L   Indica se o campo � virtual
					NIL																,;	// [17]  C   Picture Variavel
					NIL																,;	// [18]  L   Indica pulo de linha apos o campo
					60)												// [19]	 N	 Largura fixa da apresentacao do campo


	oStruct:AddField(	"C6_NUM"												,;	// [01]  C   Nome do Campo
					"03"															,;	// [02]  C   Ordem
					"Pedido"														,;	// [03]  C   Titulo do campo//"Descricao"
					"Pedido"														,;	// [04]  C   Descricao do campo//"Descricao"
					NIL																,;	// [05]  A   Array com Help
					"C"																,;	// [06]  C   Tipo do campo
					""																,;	// [07]  C   Picture
					NIL																,;	// [08]  B   Bloco de Picture Var
					NIL																,;	// [09]  C   Consulta F3
					.T.																,;	// [10]  L   Indica se o campo � alteravel
					NIL																,;	// [11]  C   Pasta do campo
					NIL																,;	// [12]  C   Agrupamento do campo
					NIL																,;	// [13]  A   Lista de valores permitido do campo (Combo)
					NIL																,;	// [14]  N   Tamanho maximo da maior opcao do combo
					NIL																,;	// [15]  C   Inicializador de Browse
					.T.																,;	// [16]  L   Indica se o campo � virtual
					NIL																,;	// [17]  C   Picture Variavel
					NIL																,;	// [18]  L   Indica pulo de linha apos o campo
					60)												// [19]	 N	 Largura fixa da apresentacao do campo

	oStruct:AddField(	"C6_ITEM"												,;	// [01]  C   Nome do Campo
					"04"															,;	// [02]  C   Ordem
					"Item"														,;	// [03]  C   Titulo do campo//"Descricao"
					"Item"														,;	// [04]  C   Descricao do campo//"Descricao"
					NIL																,;	// [05]  A   Array com Help
					"C"																,;	// [06]  C   Tipo do campo
					""																,;	// [07]  C   Picture
					NIL																,;	// [08]  B   Bloco de Picture Var
					NIL																,;	// [09]  C   Consulta F3
					.T.																,;	// [10]  L   Indica se o campo � alteravel
					NIL																,;	// [11]  C   Pasta do campo
					NIL																,;	// [12]  C   Agrupamento do campo
					NIL																,;	// [13]  A   Lista de valores permitido do campo (Combo)
					NIL																,;	// [14]  N   Tamanho maximo da maior opcao do combo
					NIL																,;	// [15]  C   Inicializador de Browse
					.T.																,;	// [16]  L   Indica se o campo � virtual
					NIL																,;	// [17]  C   Picture Variavel
					NIL																)	// [18]  L   Indica pulo de linha apos o campo

	oStruct:AddField(	"C6_PRODUTO"												,;	// [01]  C   Nome do Campo
					"05"															,;	// [02]  C   Ordem
					"Produto"														,;	// [03]  C   Titulo do campo//"Descricao"
					"Produto"														,;	// [04]  C   Descricao do campo//"Descricao"
					NIL																,;	// [05]  A   Array com Help
					"C"																,;	// [06]  C   Tipo do campo
					""																,;	// [07]  C   Picture
					NIL																,;	// [08]  B   Bloco de Picture Var
					NIL																,;	// [09]  C   Consulta F3
					.T.																,;	// [10]  L   Indica se o campo � alteravel
					NIL																,;	// [11]  C   Pasta do campo
					NIL																,;	// [12]  C   Agrupamento do campo
					NIL																,;	// [13]  A   Lista de valores permitido do campo (Combo)
					NIL																,;	// [14]  N   Tamanho maximo da maior opcao do combo
					NIL																,;	// [15]  C   Inicializador de Browse
					.T.																,;	// [16]  L   Indica se o campo � virtual
					NIL																,;	// [17]  C   Picture Variavel
					NIL																,;	// [18]  L   Indica pulo de linha apos o campo
					60)												// [19]	 N	 Largura fixa da apresentacao do campo

	oStruct:AddField(	"B1_DESC"												,;	// [01]  C   Nome do Campo
					"06"															,;	// [02]  C   Ordem
					"Descricao do Produto"														,;	// [03]  C   Titulo do campo//"Descricao"
					"Descricao do Produto"														,;	// [04]  C   Descricao do campo//"Descricao"
					NIL																,;	// [05]  A   Array com Help
					"C"																,;	// [06]  C   Tipo do campo
					""																,;	// [07]  C   Picture
					NIL																,;	// [08]  B   Bloco de Picture Var
					NIL																,;	// [09]  C   Consulta F3
					.T.																,;	// [10]  L   Indica se o campo � alteravel
					NIL																,;	// [11]  C   Pasta do campo
					NIL																,;	// [12]  C   Agrupamento do campo
					NIL																,;	// [13]  A   Lista de valores permitido do campo (Combo)
					NIL																,;	// [14]  N   Tamanho maximo da maior opcao do combo
					NIL																,;	// [15]  C   Inicializador de Browse
					.T.																,;	// [16]  L   Indica se o campo � virtual
					NIL																,;	// [17]  C   Picture Variavel
					NIL																,;	// [18]  L   Indica pulo de linha apos o campo
					200)												// [19]	 N	 Largura fixa da apresentacao do campo


	oStruct:AddField(	"ZV_CODRGA"													,;	// [01]  C   Nome do Campo
					"07"															,;	// [02]  C   Ordem
					"C�d.Bloq."														,;	// [03]  C   Titulo do campo//"Descricao"
					"C�d.Bloq."														,;	// [04]  C   Descricao do campo//"Descricao"
					NIL																,;	// [05]  A   Array com Help
					"C"																,;	// [06]  C   Tipo do campo
					""																,;	// [07]  C   Picture
					NIL																,;	// [08]  B   Bloco de Picture Var
					NIL																,;	// [09]  C   Consulta F3
					.T.																,;	// [10]  L   Indica se o campo � alteravel
					NIL																,;	// [11]  C   Pasta do campo
					NIL																,;	// [12]  C   Agrupamento do campo
					NIL																,;	// [13]  A   Lista de valores permitido do campo (Combo)
					NIL																,;	// [14]  N   Tamanho maximo da maior opcao do combo
					NIL																,;	// [15]  C   Inicializador de Browse
					.T.																,;	// [16]  L   Indica se o campo � virtual
					NIL																,;	// [17]  C   Picture Variavel
					NIL																,;	// [18]  L   Indica pulo de linha apos o campo
					60)												// [19]	 N	 Largura fixa da apresentacao do campo

	oStruct:AddField(	"ZT_DESCRI"													,;	// [01]  C   Nome do Campo
					"08"															,;	// [02]  C   Ordem
					"Bloqueio"														,;	// [03]  C   Titulo do campo//"Descricao"
					"Bloqueio"														,;	// [04]  C   Descricao do campo//"Descricao"
					NIL																,;	// [05]  A   Array com Help
					"C"																,;	// [06]  C   Tipo do campo
					""																,;	// [07]  C   Picture
					NIL																,;	// [08]  B   Bloco de Picture Var
					NIL																,;	// [09]  C   Consulta F3
					.T.																,;	// [10]  L   Indica se o campo � alteravel
					NIL																,;	// [11]  C   Pasta do campo
					NIL																,;	// [12]  C   Agrupamento do campo
					NIL																,;	// [13]  A   Lista de valores permitido do campo (Combo)
					NIL																,;	// [14]  N   Tamanho maximo da maior opcao do combo
					NIL																,;	// [15]  C   Inicializador de Browse
					.T.																,;	// [16]  L   Indica se o campo � virtual
					NIL																,;	// [17]  C   Picture Variavel
					NIL																,;	// [18]  L   Indica pulo de linha apos o campo
					200)												// [19]	 N	 Largura fixa da apresentacao do campo

	oStruct:AddField(	"ZV_DTBLQ"													,;	// [01]  C   Nome do Campo
					"09"															,;	// [02]  C   Ordem
					"Dt. Bloq."														,;	// [03]  C   Titulo do campo//"Descricao"
					"Dt. Bloq."														,;	// [04]  C   Descricao do campo//"Descricao"
					NIL																,;	// [05]  A   Array com Help
					"D"																,;	// [06]  C   Tipo do campo
					""																,;	// [07]  C   Picture
					NIL																,;	// [08]  B   Bloco de Picture Var
					NIL																,;	// [09]  C   Consulta F3
					.T.																,;	// [10]  L   Indica se o campo � alteravel
					NIL																,;	// [11]  C   Pasta do campo
					NIL																,;	// [12]  C   Agrupamento do campo
					NIL																,;	// [13]  A   Lista de valores permitido do campo (Combo)
					NIL																,;	// [14]  N   Tamanho maximo da maior opcao do combo
					NIL																,;	// [15]  C   Inicializador de Browse
					.T.																,;	// [16]  L   Indica se o campo � virtual
					NIL																,;	// [17]  C   Picture Variavel
					NIL																)	// [18]  L   Indica pulo de linha apos o campo

	oStruct:AddField(	"C6_QTDVEN"												,;	// [01]  C   Nome do Campo
					"10"															,;	// [02]  C   Ordem
					"Quantidade"														,;	// [03]  C   Titulo do campo//"Descricao"
					"Quantidade"														,;	// [04]  C   Descricao do campo//"Descricao"
					NIL																,;	// [05]  A   Array com Help
					"N"																,;	// [06]  C   Tipo do campo
					""																,;	// [07]  C   Picture
					NIL																,;	// [08]  B   Bloco de Picture Var
					NIL																,;	// [09]  C   Consulta F3
					.T.																,;	// [10]  L   Indica se o campo � alteravel
					NIL																,;	// [11]  C   Pasta do campo
					NIL																,;	// [12]  C   Agrupamento do campo
					NIL																,;	// [13]  A   Lista de valores permitido do campo (Combo)
					NIL																,;	// [14]  N   Tamanho maximo da maior opcao do combo
					NIL																,;	// [15]  C   Inicializador de Browse
					.T.																,;	// [16]  L   Indica se o campo � virtual
					NIL																,;	// [17]  C   Picture Variavel
					NIL																,;	// [18]  L   Indica pulo de linha apos o campo
					100)												// [19]	 N	 Largura fixa da apresentacao do campo

	oStruct:AddField(	"C6_PRCVEN"												,;	// [01]  C   Nome do Campo
					"11"															,;	// [02]  C   Ordem
					"Prc Unitario"														,;	// [03]  C   Titulo do campo//"Descricao"
					"Prc Unitario"														,;	// [04]  C   Descricao do campo//"Descricao"
					NIL																,;	// [05]  A   Array com Help
					"N"																,;	// [06]  C   Tipo do campo
					"@E 9,999,999,999.99"																,;	// [07]  C   Picture
					NIL																,;	// [08]  B   Bloco de Picture Var
					NIL																,;	// [09]  C   Consulta F3
					.T.																,;	// [10]  L   Indica se o campo � alteravel
					NIL																,;	// [11]  C   Pasta do campo
					NIL																,;	// [12]  C   Agrupamento do campo
					NIL																,;	// [13]  A   Lista de valores permitido do campo (Combo)
					NIL																,;	// [14]  N   Tamanho maximo da maior opcao do combo
					NIL																,;	// [15]  C   Inicializador de Browse
					.T.																,;	// [16]  L   Indica se o campo � virtual
					NIL																,;	// [17]  C   Picture Variavel
					NIL																,;	// [18]  L   Indica pulo de linha apos o campo
					100)												// [19]	 N	 Largura fixa da apresentacao do campo

	oStruct:AddField(	"C6_PRUNIT"												,;	// [01]  C   Nome do Campo
					"12"															,;	// [02]  C   Ordem
					"Prc Lista"														,;	// [03]  C   Titulo do campo//"Descricao"
					"Prc Lista"														,;	// [04]  C   Descricao do campo//"Descricao"
					NIL																,;	// [05]  A   Array com Help
					"N"																,;	// [06]  C   Tipo do campo
					"@E 9,999,999,999.99"																,;	// [07]  C   Picture
					NIL																,;	// [08]  B   Bloco de Picture Var
					NIL																,;	// [09]  C   Consulta F3
					.T.																,;	// [10]  L   Indica se o campo � alteravel
					NIL																,;	// [11]  C   Pasta do campo
					NIL																,;	// [12]  C   Agrupamento do campo
					NIL																,;	// [13]  A   Lista de valores permitido do campo (Combo)
					NIL																,;	// [14]  N   Tamanho maximo da maior opcao do combo
					NIL																,;	// [15]  C   Inicializador de Browse
					.T.																,;	// [16]  L   Indica se o campo � virtual
					NIL																,;	// [17]  C   Picture Variavel
					NIL																,;	// [18]  L   Indica pulo de linha apos o campo
					100)												// [19]	 N	 Largura fixa da apresentacao do campo

	oStruct:AddField(	"C6_VALOR"												,;	// [01]  C   Nome do Campo
					"13"															,;	// [02]  C   Ordem
					"Total"														,;	// [03]  C   Titulo do campo//"Descricao"
					"Total"														,;	// [04]  C   Descricao do campo//"Descricao"
					NIL																,;	// [05]  A   Array com Help
					"N"																,;	// [06]  C   Tipo do campo
					"@E 9,999,999,999.99"																,;	// [07]  C   Picture
					NIL																,;	// [08]  B   Bloco de Picture Var
					NIL																,;	// [09]  C   Consulta F3
					.T.																,;	// [10]  L   Indica se o campo � alteravel
					NIL																,;	// [11]  C   Pasta do campo
					NIL																,;	// [12]  C   Agrupamento do campo
					NIL																,;	// [13]  A   Lista de valores permitido do campo (Combo)
					NIL																,;	// [14]  N   Tamanho maximo da maior opcao do combo
					NIL																,;	// [15]  C   Inicializador de Browse
					.T.																,;	// [16]  L   Indica se o campo � virtual
					NIL																,;	// [17]  C   Picture Variavel
					NIL																,;	// [18]  L   Indica pulo de linha apos o campo
					100)												// [19]	 N	 Largura fixa da apresentacao do campo
return oStruct

//---------------------------------------------------------
// LOAD - DOWN
//---------------------------------------------------------
static function loadDown()
	local aLoad := {}

	aadd(aLoad, { 0, { .F., space( tamSX3("C6_FILIAL")[1] ), space( tamSX3("C6_NUM")[1] ), space( tamSX3("C6_ITEM")[1] ), space( tamSX3("C6_PRODUTO")[1] ), space( tamSX3("B1_DESC")[1] ), space( tamSX3("ZV_CODRGA")[1] ), space( tamSX3("ZT_DESCRI")[1] ), cToD('//'), 	0, 0, 0, 0 } }) //dados

return aLoad

//---------------------------------------------------------
// Buscar PV de acordo com Filtro
//---------------------------------------------------------
static function buscaPV()
	fwMsgRun(, {|| runBuscaPv() }, "Processando", "Aguarde. Selecionando dados..." )
return

//---------------------------------------------------------
// Buscar PV de acordo com Filtro
//---------------------------------------------------------
static function runBuscaPv()
	local oView			:= FwViewActive()
	local oModel		:= FWModelActive()
	local oMdlTop		:= nil
	local oMdlCenter	:= nil
	local oMdlDown		:= nil
	local cQrySC5		:= ""
	local cPVAtu		:= ""
	local nLineSC5		:= 0
	local nLineSC6		:= 0

	//if oModel == nil
		if OMDLFAT64:Activate()
			oModel := FWModelActive()

			oMdlTop		:= OMDLFAT64:GetModel( 'TOP' )
			oMdlCenter	:= OMDLFAT64:GetModel( 'CENTER' )
			oMdlDown	:= OMDLFAT64:GetModel( 'DOWN' )
		endif
	//else
	//	oMdlTop		:= oModel:GetModel( 'TOP' )
	//	oMdlCenter	:= oModel:GetModel( 'CENTER' )
	//	oMdlDown	:= oModel:GetModel( 'DOWN' )
	//endif

	//memoWrite("C:\TEMP\oView.txt"		, u_xMethObj(oView))

	//oView:GETSUBVIEW('VIEW_CENTER'):oBrowse:lUseDefaultColors := .F.
	//oView:GETSUBVIEW('VIEW_CENTER'):oBrowse:SetBlkBackColor({ || fABA4ACor()})

/*
	oView:GETSUBVIEW('VIEW_CENTER'):oBrowse:lUseDefaultColors := .F.
	oView:GETSUBVIEW('VIEW_CENTER'):SetBlkBackColor({ || fABA4ACor()})
	//oObjView := oView:GETSUBVIEW('VIEW_CENTER')
	//oObjView:oBrowse:SetBlkBackColor ( { || CLR_RED } )
	//oObjView:oBrowse:SetBlkBackColor ( { || CLR_LIGHTGRAY } )
	//oView:GETSUBVIEW('VIEW_CENTER'):oBrowse:SetBlkBackColor ( { || 11206655 } )
	//oView:Refresh()

	oGet01:oBrowse:lUseDefaultColors := .F.
	oGet01:oBrowse:SetBlkBackColor({ || fABA4ACor()})
*/

	//oObjView := oView:GETSUBVIEW('VIEW_CENTER')
	//oObjView:oBrowse:SetBlkBackColor ( { || CLR_RED } )
	//oObjView:oBrowse:SetBlkBackColor ( { || CLR_LIGHTGRAY } )
	//oView:GETSUBVIEW('VIEW_CENTER'):oBrowse:SetBlkBackColor ( { || 11206655 } )
	//oView:Refresh()

	/*
	memoWrite("C:\TEMP\oModel.txt"		, u_xMethObj(oModel))
	memoWrite("C:\TEMP\oMdlTop.txt"		, u_xMethObj(oMdlTop))
	memoWrite("C:\TEMP\oMdlCenter.txt"	, u_xMethObj(oMdlCenter))
	memoWrite("C:\TEMP\oMdlDown.txt"	, u_xMethObj(oMdlDown))
	*/

	oMdlCenter:SetNoInsertLine( .F. )
	oMdlDown:SetNoInsertLine( .F. )

	oMdlCenter:SetNoDeleteLine( .F. )
	oMdlDown:SetNoDeleteLine( .F. )

	if !oMdlCenter:isEmpty()
		oMdlCenter:DelAllLine( .T. )
		oMdlCenter:ClearData( .F., .T. )
		oMdlCenter:GoLine(1)
	endif

	if !oMdlDown:isEmpty()
		oMdlDown:DelAllLine( .T. )
		oMdlDown:ClearData( .F. /*lInit*/, .T. /*lBlankLine*/ )
		oMdlDown:GoLine(1)
	endif

	//******************************************************
	// BLOQUEIOS DOS ITENS
	//******************************************************
	cQrySC5 := "SELECT C6_FILIAL, C5_EMISSAO, C5_FILIAL, C5_NUM, C5_TIPO, C5_ZTIPPED, C5_CLIENTE, C5_LOJACLI, C5_CONDPAG || ' - ' || SE4PED.E4_DESCRI C5_CONDPAG, C6_ITEM, LPAD(TRIM(C6_ITEM), 2, 0) C6_ITEMX, ZV_ITEMPED, C6_NUM, C6_PRODUTO, C6_QTDVEN, C6_PRCVEN, C6_PRUNIT, C6_VALOR," + CRLF
	cQrySC5 += " A1_COND || ' - ' || SE4CLI.E4_DESCRI A1_COND, ZBH_DESCRI SEGMENTO,

	cQrySC5 += " (" 											+ CRLF
	cQrySC5 += "	SELECT SUM(A1_LC)" 							+ CRLF
	cQrySC5 += "	FROM " + retSQLName("SA1") + " SUBSA1" 		+ CRLF
	cQrySC5 += "	WHERE" 										+ CRLF
	cQrySC5 += "		SUBSA1.A1_COD		=	SA1.A1_COD" 	+ CRLF
	cQrySC5 += "	AND SUBSA1.D_E_L_E_T_	=	' '" 			+ CRLF
	cQrySC5 += " ) A1_LC,"										+ CRLF

	cQrySC5 += " A1_ZCLASSE, A1_NOME, A1_COD, A1_LOJA, A1_ZREGIAO || ' - ' || ZP_DESCREG AS A1_ZREGIAO, A1_ZREDE || ' - ' || ZQ_DESCR AS A1_ZREDE," + CRLF
	cQrySC5 += " ZV_PEDIDO, ZV_ITEMPED, ZV_CODRGA, ZT_DESCRI, ZT_TIPO, ZV_DTBLQ," + CRLF
	cQrySC5 += " C5_ZDTEMBA, C5_FECENT, A1_VEND, C5_VEND1," 					+ CRLF

	cQrySC5 += " (" 															+ CRLF
	cQrySC5 += " 	SELECT SUBSA3.A3_NOME" 										+ CRLF
	cQrySC5 += " 	FROM "	+ retSQLName("SA3") + " SUBSA3" 					+ CRLF
	cQrySC5 += " 	WHERE" 														+ CRLF
	cQrySC5 += " 		SUBSA3.A3_COD       =   SC5.C5_VEND1" 					+ CRLF
	cQrySC5 += "	AND SUBSA3.A3_FILIAL	=	'" + xFilial("SA3") + "'" 		+ CRLF
	cQrySC5 += " 	AND SUBSA3.D_E_L_E_T_   = ' '" 							+ CRLF
	cQrySC5 += " ) VENDPED," 													+ CRLF

	cQrySC5 += " SA3CLI.A3_COD, SA3CLI.A3_NOME," 								+ CRLF
	cQrySC5 += " ZBH_REPRES GERENCIA,"											+ CRLF

	cQrySC5 += " (" 															+ CRLF
	cQrySC5 += " 	SELECT SUBSA3.A3_NOME" 										+ CRLF
	cQrySC5 += " 	FROM "	+ retSQLName("SA3") + " SUBSA3" 					+ CRLF
	cQrySC5 += " 	WHERE" 														+ CRLF
	cQrySC5 += " 		SUBSA3.A3_COD       = ZBH.ZBH_REPRES" 					+ CRLF
	cQrySC5 += "	AND SUBSA3.A3_FILIAL	=	'" + xFilial("SA3") + "'" 		+ CRLF
	cQrySC5 += " 	AND SUBSA3.D_E_L_E_T_   = ' '" 							+ CRLF
	cQrySC5 += " ) NOMEGERENC," 												+ CRLF

	cQrySC5 += "ZBH_DESCRI DEPTO," 												+ CRLF
	cQrySC5 += " VSA1.SALDO_RA SALDORA, "										+ CRLF
	cQrySC5 += " VSA1.titulos_abertos TITABERTO, " 								+ CRLF
	cQrySC5 += " VSA1.TITULOS_ATRASADOS  TITATRASO, " 							+ CRLF
	cQrySC5 += " VSA1.total_pedidos_liberados PEDIDOSLIB, " 					+ CRLF
	cQrySC5 += " VSA1.total_pedidos PEDSEMNOTA, " + CRLF

	cQrySC5 += " VSA1.LIMITE_CREDITO LIMITECREDITO, " + CRLF
	cQrySC5 += " VSA1.LIMITE_DISPONIVEL LIMITEDISPONIVEL, " + CRLF

	cQrySC5 += "(" 																+ CRLF
	cQrySC5 += "	SELECT COALESCE(SUM(C6_VALOR), 0)" 							+ CRLF
	cQrySC5 += "	FROM "	+ retSQLName("SC6") + " SUBSC6" 					+ CRLF
	cQrySC5 += "	WHERE" 														+ CRLF
	cQrySC5 += "		SUBSC6.C6_LOJA      =   SC5.C5_LOJACLI" 				+ CRLF
	cQrySC5 += "	AND SUBSC6.C6_CLI       =   SC5.C5_CLIENTE" 				+ CRLF
	cQrySC5 += "	AND SUBSC6.C6_NUM       =   SC5.C5_NUM" 					+ CRLF
	cQrySC5 += "	AND	SUBSC6.C6_FILIAL	=	SC5.C5_FILIAL" 					+ CRLF
	cQrySC5 += "	AND	SUBSC6.D_E_L_E_T_	=	' '" 							+ CRLF
	cQrySC5 += ") VLRPEDIDO, B1_DESC" 											+ CRLF

	cQrySC5 += " FROM "			+ retSQLName("SC5") + " SC5"					+ CRLF
	cQrySC5 += " INNER JOIN  "	+ retSQLName("SC6") + " SC6" 					+ CRLF
	cQrySC5 += " ON" 															+ CRLF
	cQrySC5 += "		SC5.C5_LOJACLI	=	SC6.C6_LOJA" 						+ CRLF
	cQrySC5 += "	AND SC5.C5_CLIENTE	=	SC6.C6_CLI" 						+ CRLF
	cQrySC5 += " 	AND SC5.C5_NUM		=	SC6.C6_NUM" 						+ CRLF
	cQrySC5 += " 	AND	SC6.C6_FILIAL	=	SC5.C5_FILIAL" 						+ CRLF
	cQrySC5 += " 	AND	SC6.D_E_L_E_T_	=	' '" 								+ CRLF

	cQrySC5 += " INNER JOIN "	+ retSQLName("SZV") + " SZV" 					+ CRLF
	cQrySC5 += " ON" 															+ CRLF
	cQrySC5 += "		SZV.ZV_CODRJC   			=   ' '" 					+ CRLF // BLOQUEIOS AINDA NAO REJEITADOS
	cQrySC5 += "	AND SZV.ZV_CODAPR				=	' '" 					+ CRLF // BLOQUEIOS AINDA NAO APROVADOS

	// RELACIONAR O C6_ITEM COM A ZV_ITEMPED PARA OS BLOQUEIOS DOS ITENS
	cQrySC5 += "	AND LPAD(TRIM(C6_ITEM), 2, 0)	=	LPAD(TRIM(ZV_ITEMPED), 2, 0)"			+ CRLF

	cQrySC5 += "	AND	SC5.C5_NUM      			=   SZV.ZV_PEDIDO"			+ CRLF
	cQrySC5 += "	AND	SZV.ZV_FILIAL				=	SC5.C5_FILIAL" 			+ CRLF
	cQrySC5 += "	AND	SZV.D_E_L_E_T_				=	' '" 					+ CRLF

	if !empty( oMdlTop:getValue( "MOTIVODE" ) )
		cQrySC5 += "	AND SZV.ZV_CODRGA >= '" + oMdlTop:getValue("MOTIVODE") + "'" + CRLF
	endif

	if !empty( oMdlTop:getValue( "MOTIVOATE" ) )
		cQrySC5 += "	AND SZV.ZV_CODRGA <= '" + oMdlTop:getValue("MOTIVOATE") + "'" + CRLF
	endif

	cQrySC5 += " INNER JOIN "	+ retSQLName("SZT") + " SZT" 						+ CRLF
	cQrySC5 += " ON" 																+ CRLF
	cQrySC5 += "		SZV.ZV_CODRGA		=   SZT.ZT_CODIGO" 						+ CRLF
	cQrySC5 += "	AND	TRIM(SZT.ZT_FILIAL)	=	SUBSTR(SC5.C5_FILIAL, 1, 2)" 		+ CRLF
	cQrySC5 += " 	AND	SZT.ZT_TIPO			=	'3'"								+ CRLF //1=Pedido de Venda;2=Cliente;3=Produto
	cQrySC5 += "	AND	SZT.D_E_L_E_T_		=	' '" 								+ CRLF

	cQrySC5 += " INNER JOIN "	+ retSQLName("SZU") + " SZU" 					+ CRLF
	cQrySC5 += " ON" 															+ CRLF
	cQrySC5 += "		SZV.ZV_CODRGA   =   SZU.ZU_CODRGA" 						+ CRLF
	cQrySC5 += "	AND	SZU.ZU_MSBLQL	<>	'1'" 								+ CRLF
	cQrySC5 += "	AND	SZU.ZU_FILIAL	=	SC5.C5_FILIAL" 						+ CRLF
	cQrySC5 += "	AND	SZU.D_E_L_E_T_	=	' '" 								+ CRLF

	cQrySC5 += " INNER JOIN "	+ retSQLName("SZS") + " SZS" 					+ CRLF
	cQrySC5 += " ON" 															+ CRLF
	cQrySC5 += "		SZU.ZU_CODAPR		=	SZS.ZS_CODIGO" 						+ CRLF
	cQrySC5 += "	AND	SZS.ZS_USER			=	'" + retCodUsr() + "'" 				+ CRLF
	cQrySC5 += "	AND	SZS.ZS_APRFAT		=	'1'" 								+ CRLF
	cQrySC5 += "	AND	TRIM(SZS.ZS_FILIAL)	=	SUBSTR(SC5.C5_FILIAL, 1, 2)" 		+ CRLF
	cQrySC5 += "	AND	SZS.D_E_L_E_T_	=	' '" 								+ CRLF

	cQrySC5 += " INNER JOIN "	+ retSQLName("SA1") + " SA1" 					+ CRLF
	cQrySC5 += " ON" 															+ CRLF
	cQrySC5 += "		SC5.C5_CLIENTE  =   SA1.A1_COD" 						+ CRLF
	cQrySC5 += "	AND	SC5.C5_LOJACLI  =   SA1.A1_LOJA" 						+ CRLF
	cQrySC5 += "	AND	SA1.A1_FILIAL	=	'" + xFilial("SA1") + "'" 			+ CRLF
	cQrySC5 += "	AND	SA1.D_E_L_E_T_	=	' '" 								+ CRLF

	if !empty( oMdlTop:getValue( "REGIAODE" ) )
		cQrySC5 += "	AND SA1.A1_ZREGIAO >= '" + oMdlTop:getValue("REGIAODE") + "'" + CRLF
	endif

	if !empty( oMdlTop:getValue( "REGIAOATE" ) )
		cQrySC5 += "	AND SA1.A1_ZREGIAO <= '" + oMdlTop:getValue("REGIAOATE") + "'" + CRLF
	endif

	if !empty( oMdlTop:getValue( "CLASSE" ) )
		cQrySC5 += "	AND SA1.A1_ZCLASSE = '" + oMdlTop:getValue("CLASSE") + "'" + CRLF
	endif

/*
				ZT_TIPO
							1=Pedido de Venda;	(BLOQUEIO DO PEDIDO)
							2=Cliente;	(BLOQUEIO DO PEDIDO)
							3=Produto (BLOQUEIO DO ITEM DO PEDIDO)
*/

	cQrySC5 += " INNER JOIN v_limites_cliente VSA1 "							+ CRLF
	cQrySC5 += " ON VSA1.RECNO_CLIENTE = SA1.R_E_C_N_O_ "						+ CRLF

	cQrySC5 += " INNER JOIN "	+ retSQLName("SB1") + " SB1" 					+ CRLF
	cQrySC5 += " ON" 															+ CRLF
	cQrySC5 += "		SB1.B1_COD		=   SC6.C6_PRODUTO" 					+ CRLF
	cQrySC5 += "	AND	SB1.B1_FILIAL	=	'" + xFilial("SB1") + "'" 			+ CRLF
	cQrySC5 += "	AND	SB1.D_E_L_E_T_	=	' '" 								+ CRLF

	cQrySC5 += " LEFT JOIN  "	+ retSQLName("SZP") + " SZP" + CRLF
	cQrySC5 += " ON" + CRLF
	cQrySC5 += " 		SA1.A1_ZREGIAO	=	SZP.ZP_CODREG" + CRLF
	cQrySC5 += " 	AND	SZP.ZP_FILIAL	=	'" + xFilial("SZP") + "'" + CRLF
	cQrySC5 += " 	AND	SZP.D_E_L_E_T_	=	' '" + CRLF

	cQrySC5 += " LEFT JOIN  "	+ retSQLName("SZQ") + " SZQ" + CRLF
	cQrySC5 += " ON" + CRLF
	cQrySC5 += " 		SA1.A1_ZREDE	=	SZQ.ZQ_COD" + CRLF
	cQrySC5 += " 	AND	SZQ.ZQ_FILIAL	=	'" + xFilial("SZQ") + "'" + CRLF
	cQrySC5 += " 	AND	SZQ.D_E_L_E_T_	=	' '" + CRLF

	cQrySC5 += " LEFT JOIN  "	+ retSQLName("SE4") + " SE4" + CRLF
	cQrySC5 += " ON" + CRLF
	cQrySC5 += " 		SA1.A1_COND		=	SE4.E4_CODIGO" + CRLF
	cQrySC5 += " 	AND	SE4.E4_FILIAL	=	'" + xFilial("SE4") + "'" + CRLF
	cQrySC5 += " 	AND	SE4.D_E_L_E_T_	=	' '" + CRLF

	cQrySC5 += " LEFT JOIN  "	+ retSQLName("SE4") + " SE4CLI" + CRLF
	cQrySC5 += " ON" + CRLF
	cQrySC5 += " 		SA1.A1_COND		=	SE4CLI.E4_CODIGO" + CRLF
	cQrySC5 += " 	AND	SE4CLI.E4_FILIAL	=	'" + xFilial("SE4") + "'" + CRLF
	cQrySC5 += " 	AND	SE4CLI.D_E_L_E_T_	=	' '" + CRLF

	cQrySC5 += " LEFT JOIN  "	+ retSQLName("SE4") + " SE4PED" + CRLF
	cQrySC5 += " ON" + CRLF
	cQrySC5 += " 		SC5.C5_CONDPAG	=	SE4PED.E4_CODIGO" + CRLF
	cQrySC5 += " 	AND	SE4PED.E4_FILIAL	=	'" + xFilial("SE4") + "'" + CRLF
	cQrySC5 += " 	AND	SE4PED.D_E_L_E_T_	=	' '" + CRLF

	cQrySC5 += " LEFT JOIN  "	+ retSQLName("SA3") + " SA3CLI" 			+ CRLF
	cQrySC5 += "  ON" 														+ CRLF
	cQrySC5 += "  		SA1.A1_VEND         =   SA3CLI.A3_COD" 				+ CRLF
	cQrySC5 += "  	AND	SA3CLI.A3_FILIAL	=	'" + xFilial("SA3") + "'" 	+ CRLF
	cQrySC5 += "  	AND	SA3CLI.D_E_L_E_T_	=	' '" 						+ CRLF
	cQrySC5 += " LEFT JOIN "	+ retSQLName("ZBJ") + " ZBJ" 				+ CRLF
	cQrySC5 += " ON" 														+ CRLF
	cQrySC5 += "         ZBJ.ZBJ_LOJA	=	SA1.A1_LOJA" 					+ CRLF
	cQrySC5 += "     AND ZBJ.ZBJ_CLIENT	=	SA1.A1_COD" 					+ CRLF
	cQrySC5 += "     AND ZBJ.ZBJ_FILIAL	=	'" + xFilial("ZBJ") + "'" 		+ CRLF
	cQrySC5 += "     AND ZBJ.D_E_L_E_T_	= 	' '" 							+ CRLF
	cQrySC5 += " LEFT JOIN "	+ retSQLName("ZBI") + " ZBI" 				+ CRLF
	cQrySC5 += " ON" 														+ CRLF
	cQrySC5 += "         ZBJ.ZBJ_REPRES		=	ZBI.ZBI_REPRES" 			+ CRLF
	cQrySC5 += "     AND ZBI.ZBI_FILIAL		=	'" + xFilial("ZBI") + "'" 	+ CRLF
	cQrySC5 += "     AND ZBI.D_E_L_E_T_		= 	' '" 						+ CRLF

	if !empty( oMdlTop:getValue( "GERENCIA" ) )
		cQrySC5 += " INNER JOIN "	+ retSQLName("ZBH") + " ZBH" 				+ CRLF
	else
		cQrySC5 += " LEFT JOIN "	+ retSQLName("ZBH") + " ZBH" 				+ CRLF
	endif

	cQrySC5 += " ON" 														+ CRLF
	cQrySC5 += "         ZBH.ZBH_CODIGO		=	ZBI.ZBI_SUPERV" 			+ CRLF
	cQrySC5 += "     AND ZBH.ZBH_REGION		=	ZBI.ZBI_REGION" 			+ CRLF
	cQrySC5 += "     AND ZBH.ZBH_TATICA		=	ZBI.ZBI_TATICA" 			+ CRLF
	cQrySC5 += "     AND ZBH.ZBH_NACION		=	ZBI.ZBI_NACION" 			+ CRLF
	cQrySC5 += "     AND ZBH.ZBH_DIRETO		=	ZBI.ZBI_DIRETO" 			+ CRLF
	cQrySC5 += "     AND ZBH.ZBH_FILIAL		=	'" + xFilial("ZBH") + "'" 	+ CRLF
	cQrySC5 += "     AND ZBH.D_E_L_E_T_		=  ' '" 						+ CRLF

	if !empty( oMdlTop:getValue( "GERENCIA" ) )
		cQrySC5 += "	AND ZBH.ZBH_REPRES = '" + oMdlTop:getValue("GERENCIA") + "'" + CRLF
	endif

	cQrySC5 += " WHERE" + CRLF
	cQrySC5 += " "
	cQrySC5 += " 		SC5.D_E_L_E_T_	=	' '"	+ CRLF

	// Pedido de Rede
	cQrySC5 += " 	AND	SC5.C5_XREDE	<>	'S'"	+ CRLF

	if upper( allTrim( oMdlTop:getValue("DATA") ) ) == "EMISS�O"
		if !empty( oMdlTop:getValue("DE") )
			cQrySC5 += " 	AND	SC5.C5_EMISSAO >= '" + dToS( oMdlTop:getValue("DE") ) + "'" + CRLF
		endif

		if !empty( oMdlTop:getValue("ATE") )
			cQrySC5 += " 	AND SC5.C5_EMISSAO <= '" + dToS( oMdlTop:getValue("ATE") ) + "'" + CRLF
		endif
	elseif upper( allTrim( oMdlTop:getValue("DATA") ) ) == "EMBARQUE"
		if !empty( oMdlTop:getValue("DE") )
			cQrySC5 += " 	AND	SC5.C5_ZDTEMBA >= '" + dToS( oMdlTop:getValue("DE") ) + "'" + CRLF
		endif

		if !empty( oMdlTop:getValue("ATE") )
			cQrySC5 += " 	AND SC5.C5_ZDTEMBA <= '" + dToS( oMdlTop:getValue("ATE") ) + "'" + CRLF
		endif
	elseif upper( allTrim( oMdlTop:getValue("DATA") ) ) == "ENTREGA"
		if !empty( oMdlTop:getValue("DE") )
			cQrySC5 += " 	AND	SC5.C5_FECENT >= '" + dToS( oMdlTop:getValue("DE") ) + "'" + CRLF
		endif

		if !empty( oMdlTop:getValue("ATE") )
			cQrySC5 += " 	AND SC5.C5_FECENT <= '" + dToS( oMdlTop:getValue("ATE") ) + "'" + CRLF
		endif
	endif

	if !empty( oMdlTop:getValue( "PEDIDO" ) )
		cQrySC5 += "	AND SC5.C5_NUM = '" + oMdlTop:getValue("PEDIDO") + "'" + CRLF
	endif

	//******************************************************
	// UNION - BLOQUEIOS DO PEDIDO
	//******************************************************

	cQrySC5 += " UNION ALL" + CRLF

	cQrySC5 += " SELECT C5_FILIAL AS C6_FILIAL, C5_EMISSAO, C5_FILIAL, C5_NUM, C5_TIPO, C5_ZTIPPED, C5_CLIENTE, C5_LOJACLI, C5_CONDPAG || ' - ' || SE4PED.E4_DESCRI C5_CONDPAG,"
	cQrySC5 += " '01' AS C6_ITEM, '01' AS C6_ITEMX, ZV_ITEMPED, C5_NUM C6_NUM, 'Pedido Bloq.' C6_PRODUTO, 0 C6_QTDVEN, 0 C6_PRCVEN, 0 C6_PRUNIT, 0 C6_VALOR," + CRLF
	cQrySC5 += " A1_COND || ' - ' || SE4CLI.E4_DESCRI A1_COND, ZBH_DESCRI SEGMENTO,"

	cQrySC5 += " (" 											+ CRLF
	cQrySC5 += "	SELECT SUM(A1_LC)" 							+ CRLF
	cQrySC5 += "	FROM " + retSQLName("SA1") + " SUBSA1" 		+ CRLF
	cQrySC5 += "	WHERE" 										+ CRLF
	cQrySC5 += "		SUBSA1.A1_COD		=	SA1.A1_COD"		+ CRLF
	cQrySC5 += "	AND SUBSA1.D_E_L_E_T_	=	' '"			+ CRLF
	cQrySC5 += " ) A1_LC,"										+ CRLF

	cQrySC5 += " A1_ZCLASSE, A1_NOME, A1_COD, A1_LOJA, A1_ZREGIAO || ' - ' || ZP_DESCREG AS A1_ZREGIAO, A1_ZREDE || ' - ' || ZQ_DESCR AS A1_ZREDE," + CRLF
	cQrySC5 += " ZV_PEDIDO, ZV_ITEMPED, ZV_CODRGA, ZT_DESCRI, ZT_TIPO, ZV_DTBLQ," + CRLF
	cQrySC5 += " C5_ZDTEMBA, C5_FECENT, A1_VEND, C5_VEND1," 					+ CRLF

	cQrySC5 += " (" 															+ CRLF
	cQrySC5 += " 	SELECT SUBSA3.A3_NOME" 										+ CRLF
	cQrySC5 += " 	FROM "	+ retSQLName("SA3") + " SUBSA3" 					+ CRLF
	cQrySC5 += " 	WHERE" 														+ CRLF
	cQrySC5 += " 		SUBSA3.A3_COD       =   SC5.C5_VEND1" 					+ CRLF
	cQrySC5 += "	AND SUBSA3.A3_FILIAL	=	'" + xFilial("SA3") + "'" 		+ CRLF
	cQrySC5 += " 	AND SUBSA3.D_E_L_E_T_   = ' '" 							+ CRLF
	cQrySC5 += " ) VENDPED," 													+ CRLF

	cQrySC5 += " SA3CLI.A3_COD, SA3CLI.A3_NOME," 								+ CRLF
	cQrySC5 += " ZBH_REPRES GERENCIA,"											+ CRLF

	cQrySC5 += " (" 															+ CRLF
	cQrySC5 += " 	SELECT SUBSA3.A3_NOME" 										+ CRLF
	cQrySC5 += " 	FROM "	+ retSQLName("SA3") + " SUBSA3" 					+ CRLF
	cQrySC5 += " 	WHERE" 														+ CRLF
	cQrySC5 += " 		SUBSA3.A3_COD       = ZBH.ZBH_REPRES" 					+ CRLF
	cQrySC5 += "	AND SUBSA3.A3_FILIAL	=	'" + xFilial("SA3") + "'" 		+ CRLF
	cQrySC5 += " 	AND SUBSA3.D_E_L_E_T_   = ' '" 							+ CRLF
	cQrySC5 += " ) NOMEGERENC," 												+ CRLF

	cQrySC5 += "ZBH_DESCRI DEPTO," 												+ CRLF
	cQrySC5 += " VSA1.SALDO_RA SALDORA, "										+ CRLF
	cQrySC5 += " VSA1.titulos_abertos TITABERTO, " 								+ CRLF
	cQrySC5 += " VSA1.TITULOS_ATRASADOS  TITATRASO, " 							+ CRLF
	cQrySC5 += " VSA1.total_pedidos_liberados PEDIDOSLIB, " 					+ CRLF

	cQrySC5 += " VSA1.total_pedidos PEDSEMNOTA, " + CRLF

	cQrySC5 += " VSA1.LIMITE_CREDITO LIMITECREDITO, " + CRLF
	cQrySC5 += " VSA1.LIMITE_DISPONIVEL LIMITEDISPONIVEL, " + CRLF

	cQrySC5 += "(" 																+ CRLF
	cQrySC5 += "	SELECT COALESCE(SUM(C6_VALOR), 0)" 							+ CRLF
	cQrySC5 += "	FROM "	+ retSQLName("SC6") + " SUBSC6" 					+ CRLF
	cQrySC5 += "	WHERE" 														+ CRLF
	cQrySC5 += "		SUBSC6.C6_LOJA      =   SC5.C5_LOJACLI" 				+ CRLF
	cQrySC5 += "	AND SUBSC6.C6_CLI       =   SC5.C5_CLIENTE" 				+ CRLF
	cQrySC5 += "	AND SUBSC6.C6_NUM       =   SC5.C5_NUM" 					+ CRLF
	cQrySC5 += "	AND	SUBSC6.C6_FILIAL	=	SC5.C5_FILIAL" 					+ CRLF
	cQrySC5 += "	AND	SUBSC6.D_E_L_E_T_	=	' '" 							+ CRLF
	cQrySC5 += ") VLRPEDIDO, 'Bloqueio do Pedido' B1_DESC" 						+ CRLF

	cQrySC5 += " FROM "			+ retSQLName("SC5") + " SC5"					+ CRLF

	cQrySC5 += " INNER JOIN "	+ retSQLName("SZV") + " SZV" 					+ CRLF
	cQrySC5 += " ON" 															+ CRLF
	cQrySC5 += "		SZV.ZV_CODRJC   			=   ' '" 					+ CRLF // BLOQUEIOS AINDA NAO REJEITADOS
	cQrySC5 += "	AND SZV.ZV_CODAPR				=	' '" 					+ CRLF // BLOQUEIOS AINDA NAO APROVADOS
	//cQrySC5 += "	AND ZV_ITEMPED					=	'01'"					+ CRLF
	cQrySC5 += "	AND  LPAD(TRIM(ZV_ITEMPED), 2, 0) = '01'"			+ CRLF
	cQrySC5 += "	AND	SC5.C5_NUM      			=   SZV.ZV_PEDIDO"			+ CRLF
	cQrySC5 += "	AND	SZV.ZV_FILIAL				=	SC5.C5_FILIAL" 			+ CRLF
	cQrySC5 += "	AND	SZV.D_E_L_E_T_				=	' '" 					+ CRLF

	if !empty( oMdlTop:getValue( "MOTIVODE" ) )
		cQrySC5 += "	AND SZV.ZV_CODRGA >= '" + oMdlTop:getValue("MOTIVODE") + "'" + CRLF
	endif

	if !empty( oMdlTop:getValue( "MOTIVOATE" ) )
		cQrySC5 += "	AND SZV.ZV_CODRGA <= '" + oMdlTop:getValue("MOTIVOATE") + "'" + CRLF
	endif

	cQrySC5 += " INNER JOIN "	+ retSQLName("SZT") + " SZT" 						+ CRLF
	cQrySC5 += " ON" 																+ CRLF
	cQrySC5 += "		SZV.ZV_CODRGA		=   SZT.ZT_CODIGO" 						+ CRLF
	cQrySC5 += "	AND	TRIM(SZT.ZT_FILIAL)	=	SUBSTR(SC5.C5_FILIAL, 1, 2)" 		+ CRLF
	cQrySC5 += " 	AND	SZT.ZT_TIPO			IN	('1', '2')"							+ CRLF //1=Pedido de Venda;2=Cliente;3=Produto
	cQrySC5 += "	AND	SZT.D_E_L_E_T_		=	' '" 								+ CRLF

	cQrySC5 += " INNER JOIN "	+ retSQLName("SZU") + " SZU" 					+ CRLF
	cQrySC5 += " ON" 															+ CRLF
	cQrySC5 += "		SZV.ZV_CODRGA   =   SZU.ZU_CODRGA" 						+ CRLF
	cQrySC5 += "	AND	SZU.ZU_MSBLQL	<>	'1'" 								+ CRLF
	cQrySC5 += "	AND	SZU.ZU_FILIAL	=	SC5.C5_FILIAL" 						+ CRLF
	cQrySC5 += "	AND	SZU.D_E_L_E_T_	=	' '" 								+ CRLF

	cQrySC5 += " INNER JOIN "	+ retSQLName("SZS") + " SZS" 					+ CRLF
	cQrySC5 += " ON" 															+ CRLF
	cQrySC5 += "		SZU.ZU_CODAPR		=	SZS.ZS_CODIGO" 						+ CRLF
	cQrySC5 += "	AND	SZS.ZS_USER			=	'" + retCodUsr() + "'" 				+ CRLF
	cQrySC5 += "	AND	SZS.ZS_APRFAT		=	'1'" 								+ CRLF
	cQrySC5 += "	AND	TRIM(SZS.ZS_FILIAL)	=	SUBSTR(SC5.C5_FILIAL, 1, 2)" 		+ CRLF
	cQrySC5 += "	AND	SZS.D_E_L_E_T_	=	' '" 								+ CRLF

	cQrySC5 += " INNER JOIN "	+ retSQLName("SA1") + " SA1" 					+ CRLF
	cQrySC5 += " ON" 															+ CRLF
	cQrySC5 += "		SC5.C5_CLIENTE  =   SA1.A1_COD" 						+ CRLF
	cQrySC5 += "	AND	SC5.C5_LOJACLI  =   SA1.A1_LOJA" 						+ CRLF
	cQrySC5 += "	AND	SA1.A1_FILIAL	=	'" + xFilial("SA1") + "'" 			+ CRLF
	cQrySC5 += "	AND	SA1.D_E_L_E_T_	=	' '" 								+ CRLF

	if !empty( oMdlTop:getValue( "REGIAODE" ) )
		cQrySC5 += "	AND SA1.A1_ZREGIAO >= '" + oMdlTop:getValue("REGIAODE") + "'" + CRLF
	endif

	if !empty( oMdlTop:getValue( "REGIAOATE" ) )
		cQrySC5 += "	AND SA1.A1_ZREGIAO <= '" + oMdlTop:getValue("REGIAOATE") + "'" + CRLF
	endif

	if !empty( oMdlTop:getValue( "CLASSE" ) )
		cQrySC5 += "	AND SA1.A1_ZCLASSE = '" + oMdlTop:getValue("CLASSE") + "'" + CRLF
	endif

/*
				ZT_TIPO
							1=Pedido de Venda;	(BLOQUEIO DO PEDIDO)
							2=Cliente;	(BLOQUEIO DO PEDIDO)
							3=Produto (BLOQUEIO DO ITEM DO PEDIDO)
*/

	cQrySC5 += " INNER JOIN v_limites_cliente VSA1 "							+ CRLF
	cQrySC5 += " ON VSA1.RECNO_CLIENTE = SA1.R_E_C_N_O_ "						+ CRLF

	cQrySC5 += " LEFT JOIN  "	+ retSQLName("SZP") + " SZP" + CRLF
	cQrySC5 += " ON" + CRLF
	cQrySC5 += " 		SA1.A1_ZREGIAO	=	SZP.ZP_CODREG" + CRLF
	cQrySC5 += " 	AND	SZP.ZP_FILIAL	=	'" + xFilial("SZP") + "'" + CRLF
	cQrySC5 += " 	AND	SZP.D_E_L_E_T_	=	' '" + CRLF

	cQrySC5 += " LEFT JOIN  "	+ retSQLName("SZQ") + " SZQ" + CRLF
	cQrySC5 += " ON" + CRLF
	cQrySC5 += " 		SA1.A1_ZREDE	=	SZQ.ZQ_COD" + CRLF
	cQrySC5 += " 	AND	SZQ.ZQ_FILIAL	=	'" + xFilial("SZQ") + "'" + CRLF
	cQrySC5 += " 	AND	SZQ.D_E_L_E_T_	=	' '" + CRLF

	cQrySC5 += " LEFT JOIN  "	+ retSQLName("SE4") + " SE4" + CRLF
	cQrySC5 += " ON" + CRLF
	cQrySC5 += " 		SA1.A1_COND		=	SE4.E4_CODIGO" + CRLF
	cQrySC5 += " 	AND	SE4.E4_FILIAL	=	'" + xFilial("SE4") + "'" + CRLF
	cQrySC5 += " 	AND	SE4.D_E_L_E_T_	=	' '" + CRLF

	cQrySC5 += " LEFT JOIN  "	+ retSQLName("SE4") + " SE4CLI" + CRLF
	cQrySC5 += " ON" + CRLF
	cQrySC5 += " 		SA1.A1_COND		=	SE4CLI.E4_CODIGO" + CRLF
	cQrySC5 += " 	AND	SE4CLI.E4_FILIAL	=	'" + xFilial("SE4") + "'" + CRLF
	cQrySC5 += " 	AND	SE4CLI.D_E_L_E_T_	=	' '" + CRLF

	cQrySC5 += " LEFT JOIN  "	+ retSQLName("SE4") + " SE4PED" + CRLF
	cQrySC5 += " ON" + CRLF
	cQrySC5 += " 		SC5.C5_CONDPAG	=	SE4PED.E4_CODIGO" + CRLF
	cQrySC5 += " 	AND	SE4PED.E4_FILIAL	=	'" + xFilial("SE4") + "'" + CRLF
	cQrySC5 += " 	AND	SE4PED.D_E_L_E_T_	=	' '" + CRLF

	cQrySC5 += " LEFT JOIN  "	+ retSQLName("SA3") + " SA3CLI" 			+ CRLF
	cQrySC5 += "  ON" 														+ CRLF
	cQrySC5 += "  		SA1.A1_VEND         =   SA3CLI.A3_COD" 				+ CRLF
	cQrySC5 += "  	AND	SA3CLI.A3_FILIAL	=	'" + xFilial("SA3") + "'" 	+ CRLF
	cQrySC5 += "  	AND	SA3CLI.D_E_L_E_T_	=	' '" 						+ CRLF
	cQrySC5 += " LEFT JOIN "	+ retSQLName("ZBJ") + " ZBJ" 				+ CRLF
	cQrySC5 += " ON" 														+ CRLF
	cQrySC5 += "         ZBJ.ZBJ_LOJA	=	SA1.A1_LOJA" 					+ CRLF
	cQrySC5 += "     AND ZBJ.ZBJ_CLIENT	=	SA1.A1_COD" 					+ CRLF
	cQrySC5 += "     AND ZBJ.ZBJ_FILIAL	=	'" + xFilial("ZBJ") + "'" 		+ CRLF
	cQrySC5 += "     AND ZBJ.D_E_L_E_T_	= 	' '" 							+ CRLF
	cQrySC5 += " LEFT JOIN "	+ retSQLName("ZBI") + " ZBI" 				+ CRLF
	cQrySC5 += " ON" 														+ CRLF
	cQrySC5 += "         ZBJ.ZBJ_REPRES		=	ZBI.ZBI_REPRES" 			+ CRLF
	cQrySC5 += "     AND ZBI.ZBI_FILIAL		=	'" + xFilial("ZBI") + "'" 	+ CRLF
	cQrySC5 += "     AND ZBI.D_E_L_E_T_		=	' '" 						+ CRLF

	if !empty( oMdlTop:getValue( "GERENCIA" ) )
		cQrySC5 += " INNER JOIN "	+ retSQLName("ZBH") + " ZBH" 				+ CRLF
	else
		cQrySC5 += " LEFT JOIN "	+ retSQLName("ZBH") + " ZBH" 				+ CRLF
	endif

	cQrySC5 += " ON" 														+ CRLF
	cQrySC5 += "         ZBH.ZBH_CODIGO		=	ZBI.ZBI_SUPERV" 			+ CRLF
	cQrySC5 += "     AND ZBH.ZBH_REGION		=	ZBI.ZBI_REGION" 			+ CRLF
	cQrySC5 += "     AND ZBH.ZBH_TATICA		=	ZBI.ZBI_TATICA" 			+ CRLF
	cQrySC5 += "     AND ZBH.ZBH_NACION		=	ZBI.ZBI_NACION" 			+ CRLF
	cQrySC5 += "     AND ZBH.ZBH_DIRETO		=	ZBI.ZBI_DIRETO" 			+ CRLF
	cQrySC5 += "     AND ZBH.ZBH_FILIAL		=	'" + xFilial("ZBH") + "'" 	+ CRLF
	cQrySC5 += "     AND ZBH.D_E_L_E_T_		=  ' '" 						+ CRLF

	if !empty( oMdlTop:getValue( "GERENCIA" ) )
		cQrySC5 += "	AND ZBH.ZBH_REPRES = '" + oMdlTop:getValue("GERENCIA") + "'" + CRLF
	endif

	cQrySC5 += " WHERE" + CRLF
	cQrySC5 += " "
	//cQrySC5 += " 		SC5.C5_FILIAL	=	'" + xFilial("SC5") + "'" + CRLF
	//cQrySC5 += " 	AND	SC5.D_E_L_E_T_	<>	'*'" + CRLF
	cQrySC5 += " 		SC5.D_E_L_E_T_	=	' '" + CRLF

	if upper( allTrim( oMdlTop:getValue("DATA") ) ) == "EMISS�O"
		if !empty( oMdlTop:getValue("DE") )
			cQrySC5 += " 	AND	SC5.C5_EMISSAO >= '" + dToS( oMdlTop:getValue("DE") ) + "'" + CRLF
		endif

		if !empty( oMdlTop:getValue("ATE") )
			cQrySC5 += " 	AND SC5.C5_EMISSAO <= '" + dToS( oMdlTop:getValue("ATE") ) + "'" + CRLF
		endif
	elseif upper( allTrim( oMdlTop:getValue("DATA") ) ) == "EMBARQUE"
		if !empty( oMdlTop:getValue("DE") )
			cQrySC5 += " 	AND	SC5.C5_ZDTEMBA >= '" + dToS( oMdlTop:getValue("DE") ) + "'" + CRLF
		endif

		if !empty( oMdlTop:getValue("ATE") )
			cQrySC5 += " 	AND SC5.C5_ZDTEMBA <= '" + dToS( oMdlTop:getValue("ATE") ) + "'" + CRLF
		endif
	elseif upper( allTrim( oMdlTop:getValue("DATA") ) ) == "ENTREGA"
		if !empty( oMdlTop:getValue("DE") )
			cQrySC5 += " 	AND	SC5.C5_FECENT >= '" + dToS( oMdlTop:getValue("DE") ) + "'" + CRLF
		endif

		if !empty( oMdlTop:getValue("ATE") )
			cQrySC5 += " 	AND SC5.C5_FECENT <= '" + dToS( oMdlTop:getValue("ATE") ) + "'" + CRLF
		endif
	endif

	if !empty( oMdlTop:getValue( "PEDIDO" ) )
		cQrySC5 += "	AND SC5.C5_NUM = '" + oMdlTop:getValue("PEDIDO") + "'" + CRLF
	endif

	cQrySC5 += " ORDER BY C5_FILIAL, C5_NUM, C6_FILIAL, C6_ITEM"

	memoWrite("C:\TEMP\MGFCRM64.SQL", cQrySC5)

	tcQuery cQrySC5 New Alias "QRYSC5"

	if !QRYSC5->(EOF())

		nLineSC5 := 1

		while !QRYSC5->(EOF())
			cPVAtu := QRYSC5->( C5_FILIAL + C5_NUM )

			if !empty( oMdlCenter:getValue( "C5_NUM" ) )
				nLineSC5 := oMdlCenter:addLine()
			endif

			oMdlCenter:GoLine( nLineSC5 )

			oMdlCenter:loadValue("C5_ZSELECT"	, .F.						)
			oMdlCenter:loadValue("C5_FILIAL"	, QRYSC5->C5_FILIAL			)
			oMdlCenter:loadValue("C5_NUM"		, QRYSC5->C5_NUM			)
			oMdlCenter:loadValue("A1_ZCLASSE"	, QRYSC5->A1_ZCLASSE		)
			oMdlCenter:loadValue("C5_CLIENTE"	, QRYSC5->C5_CLIENTE		)
			oMdlCenter:loadValue("C5_LOJACLI"	, QRYSC5->C5_LOJACLI		)
			oMdlCenter:loadValue("A1_NOME"		, QRYSC5->A1_NOME			)
			oMdlCenter:loadValue("A1_ZREGIAO"	, QRYSC5->A1_ZREGIAO		)
			oMdlCenter:loadValue("A1_ZREDE"		, QRYSC5->A1_ZREDE			)
			oMdlCenter:loadValue("C5_EMISSAO"	, sToD(QRYSC5->C5_EMISSAO)	)
			oMdlCenter:loadValue("C5_TIPO"		, QRYSC5->C5_TIPO			)
			oMdlCenter:loadValue("C5_ZTIPPED"	, QRYSC5->C5_ZTIPPED			)
			oMdlCenter:loadValue("C5_CONDPAG"	, QRYSC5->C5_CONDPAG		)
			oMdlCenter:loadValue("A1_COND"		, QRYSC5->A1_COND		)
			oMdlCenter:loadValue("A1_LC"		, QRYSC5->LIMITECREDITO		)

			oMdlCenter:setValue("VLRPEDIDO"	, QRYSC5->VLRPEDIDO			)

			oMdlCenter:loadValue("LIMDISP"		, QRYSC5->LIMITEDISPONIVEL	)
			oMdlCenter:loadValue("TITATRASO"	, QRYSC5->TITATRASO			)


//			oMdlCenter:loadValue("LIMITESUPE"	, QRYSC5->LIMDISP-QRYSC5->VLRPEDIDO		)
			oMdlCenter:loadValue("SEGMENTO"		, QRYSC5->SEGMENTO			)
			oMdlCenter:loadValue("A1_VEND"		, QRYSC5->A1_VEND			)
			oMdlCenter:loadValue("A3_NOME"		, QRYSC5->A3_NOME			)
			oMdlCenter:loadValue("ZBH_REPRES"	, QRYSC5->GERENCIA			)
			oMdlCenter:loadValue("NOMEGERENC"	, QRYSC5->NOMEGERENC		)
			oMdlCenter:loadValue("ZBH_DESCRI"	, QRYSC5->DEPTO				)
			oMdlCenter:loadValue("C5_VEND1"		, QRYSC5->C5_VEND1			)
			oMdlCenter:loadValue("VENDPED"		, QRYSC5->VENDPED			)

			oMdlCenter:loadValue("C5_ZDTEMBA"	, sToD(QRYSC5->C5_ZDTEMBA)	)
			oMdlCenter:loadValue("C5_FECENT"	, sToD(QRYSC5->C5_FECENT)	)

			oMdlCenter:loadValue("SALDORA"		, QRYSC5->SALDORA			)


/*
#DEFINE SC5CAMPOS "C5_NUM|C5_CLIENTE|C5_LOJACLI|A1_NOME|A1_ZREGIAO|A1_ZREDE"
#DEFINE SC6CAMPOS "C6_ITEM|C6_NUM|C6_PRODUTO|ZV_CODRGA|ZT_DESCRI|ZV_DTBLQ|C6_QTDVEN|C6_PRCVEN|C6_PRUNIT|C6_VALOR"
*/

			while !QRYSC5->(EOF()) .and. QRYSC5->( C5_FILIAL + C5_NUM ) == cPVAtu

				nLineSC6 := oMdlDown:length()

				if !empty( oMdlDown:getValue( "C6_ITEM" ) )
					nLineSC6 := oMdlDown:addLine()
				endif

				oMdlDown:GoLine( nLineSC6 )

				oMdlDown:loadValue("C6_ZSELECT"	, .F.															)
				oMdlDown:loadValue("C6_FILIAL"	, QRYSC5->C6_FILIAL												)
				oMdlDown:loadValue("C6_NUM"		, QRYSC5->C5_NUM												)
				oMdlDown:loadValue("C6_ITEM"	, padL( allTrim( QRYSC5->C6_ITEM ), tamSx3("C6_ITEM")[1], "0" )	)
				oMdlDown:loadValue("C6_PRODUTO"	, QRYSC5->C6_PRODUTO											)
				oMdlDown:loadValue("C6_QTDVEN"	, QRYSC5->C6_QTDVEN												)
				oMdlDown:loadValue("C6_PRCVEN"	, QRYSC5->C6_PRCVEN												)
				oMdlDown:loadValue("ZV_CODRGA"	, QRYSC5->ZV_CODRGA												)
				oMdlDown:loadValue("ZT_DESCRI"	, QRYSC5->ZT_DESCRI												)
				oMdlDown:loadValue("ZV_DTBLQ"	, sToD(QRYSC5->ZV_DTBLQ)										)
				oMdlDown:loadValue("C6_PRUNIT"	, QRYSC5->C6_PRUNIT												)
				oMdlDown:loadValue("C6_VALOR"	, QRYSC5->C6_VALOR												)

				oMdlDown:loadValue("B1_DESC"		, QRYSC5->B1_DESC			)

				QRYSC5->(DBSkip())
			enddo

			//if !isInCallStack ( "rejeitaPV" ) .AND. !isInCallStack ( "aprovaPV" ) // Quando usuario estiver aprovando/rejeitando nao altera posicionamento da tela
				oMdlDown:GoLine(1)
			//endif
		enddo
	endif

	QRYSC5->(DBCloseArea())

	if !isInCallStack ( "rejeitaPV" ) .AND. !isInCallStack ( "aprovaPV" ) // Quando usuario estiver aprovando/rejeitando nao altera posicionamento da tela
		oMdlCenter:GoLine(1)
	endif

	oMdlCenter:SetNoInsertLine( .T. )
	oMdlDown:SetNoInsertLine( .T. )

	oMdlCenter:SetNoDeleteLine( .T. )
	oMdlDown:SetNoDeleteLine( .T. )

	oView:Refresh()
return

//---------------------------------------------------------
// COMMIT
//---------------------------------------------------------
static function cmtFat64( oModel )
	Local lRet := .T.
/*
	If oModel:VldData()
		FwFormCommit( oModel )
		oModel:DeActivate()

		msgAlert("COMMIT!!!")
	Else
		JurShowErro( oModel:GetModel():GetErrormessage() )
		lRet := .F.
		DisarmTransaction()
	EndIf
*/
Return lRet

//---------------------------------------------------------
// COMMIT
//---------------------------------------------------------
user function chkSelec( cGrid, lCheck )
	local nI			:= 1
	local lAllSC6		:= .T.
	//local aSaveLines	:= FWSaveRows()
	local oView			:= FwViewActive()
	local oModel		:= FWModelActive()
	local oMdlTop		:= oModel:GetModel( 'TOP' )
	local oMdlCenter	:= oModel:GetModel( 'CENTER' )
	local oMdlDown		:= oModel:GetModel( 'DOWN' )

	if cGrid == "SC5"
		for nI := 1 to oMdlDown:length()
			oMdlDown:GoLine( nI )
			oMdlDown:loadValue( "C6_ZSELECT", lCheck )
		next

		// NAO EXECUTAR REFRESH PARA O GRID CENTRAL
		oMdlDown:GoLine( 1 )
		oView:Refresh('VIEW_DOWN')
	elseif cGrid == "SC6"
		if lCheck
			for nI := 1 to oMdlDown:length()
				if nI <> oMdlDown:nLine
					if !oMdlDown:getValue( "C6_ZSELECT", nI )
						lAllSC6 := .F.
						exit
					endif
				endif
			next

			// Se todos os itens do Pedidos marcados - atualiza marcacao da SC5
			if lAllSC6
				oMdlCenter:loadValue( "C5_ZSELECT", .T. )
			endif
		else
			oMdlCenter:loadValue( "C5_ZSELECT", .F. )
		endif
	endif

	//FWRestRows( aSaveLines )
return lCheck

//------------------------------------------------------------------
// Visualiza PV
//------------------------------------------------------------------
static function visualPv()
	local aArea 	:= GetArea()
	local aAreaSC5 	:= SC5->(GetArea())
	local aAreaSC6 	:= SC6->(GetArea())
	local aSavAhead	:= iif( type("aHeader")	== "A", aHeader	, {}	)
	local aSavAcol	:= iif( type("aCols")	== "A", aCols	, {}	)
	local nSavN		:= iif( type("N")		== "N", N		, 0		)
	local cFilBkp	:= cFilAnt

	local oModel		:= FWModelActive()
	local oMdlTop		:= oModel:GetModel( 'TOP' )
	local oMdlCenter	:= oModel:GetModel( 'CENTER' )

	private aRotina := {	{ "Pesquisar"	, "PesqBrw"		, 0 , 1 , 0 , .F. },;	// "Pesquisar"
							{ "Visualizar"	, "A410Visual"	, 0 , 2 , 0 , NIL },;	// "Visualizar"
							{ "Liberar"		, "A440Libera"	, 0 , 6 , 0 , NIL },;	// "Liberar"
							{ "Automatico"	, "A440Automa"	, 0 , 0 , 0 , NIL },;	// "Automatico"
							{ "Legenda"		, "A410Legend"	, 0 , 0 , 0 , .F. }}	// "Legenda"

	if !oMdlCenter:isEmpty()
		DBSelectArea("SC5")
		SC5->(DBSetOrder(1))
		SC5->(DBGoTop())

		//DBSelectArea("SC6")
		//SC6->(DBSetOrder(1))
		//SC6->(DBGoTop())

		if SC5->( DBSeek( oMdlCenter:getValue("C5_FILIAL") + oMdlCenter:getValue("C5_NUM") ) )
			cFilAnt := oMdlCenter:getValue("C5_FILIAL")
			//if SC6->( DBSeek( oMdlCenter:getValue("C5_FILIAL") + oMdlCenter:getValue("C5_NUM") ) )
				nRecSC5 := SC5->( recno() )
				SC5->(a410Visual('SC5', nRecSC5, 2))
			//endif
		endif
	endif

	cFilAnt	:= cFilBkp
	aHeader	:= aSavAHead
	aCols	:= aSavACol
	N		:= nSavN

	restArea(aAreaSC6)
	restArea(aAreaSC5)
	restArea(aArea)
return

//------------------------------------------------------------------
// Aprova Selecionados
//------------------------------------------------------------------
static function aprovaPv( lAprovEst, aItemLib )
	local oModel		:= FWModelActive()
	local oMdlCenter
	local oMdlDown
	local aSaveLines	:= FWSaveRows()
	local oView			:= FwViewActive()
	private _aRegProc	:= {}
	private _aPedTau	:= {}

	default lAprovEst	:= .F.
	default aItemLib	:= {}

	if oModel == nil
		if OMDLFAT64:Activate()
			oModel := FWModelActive()
		endif
	endif

	oMdlTop		:= oModel:GetModel( 'TOP' )
	oMdlCenter	:= oModel:GetModel( 'CENTER' )
	oMdlDown	:= oModel:GetModel( 'DOWN' )

	if lAprovEst
		if len(aItemLib) > 0
			_aRegProc := aClone( aItemLib )
			processa( { || xMF10AtSZV( .T. ) }, "Aguarde...", "Processando a Liberacao...", .F. )

			If Len(_aPedTau) > 0
				StartJob( "U_xM64PRC", GetEnvServer(), .F., _aPedTau )
			EndIf

		endif
	else
		for nJ := 1 to oMdlCenter:length()
			oMdlCenter:goLine(nJ)
			for nI := 1 to oMdlDown:length()
				if oMdlDown:getValue( "C6_ZSELECT", nI )
					//aadd(_aRegProc, { xFilial("SZV") , oMdlDown:getValue( "C6_NUM", nI ), oMdlDown:getValue( "C6_ITEM", nI ), oMdlDown:getValue( "ZV_CODRGA", nI ) })
					aadd(_aRegProc, { oMdlDown:getValue( "C6_FILIAL", nI ) , oMdlDown:getValue( "C6_NUM", nI ), oMdlDown:getValue( "C6_ITEM", nI ), oMdlDown:getValue( "ZV_CODRGA", nI ) })
				endif
			next
		next

		if len(_aRegProc) > 0
			if aviso("Liberacao", "Sera realizada a LIBERACAO de todos os itens marcados. Deseja Continuar?", { "Continuar", "Cancelar" }, 1) == 1
				processa({|| xMF10AtSZV(.T.)},"Aguarde...","Processando a Liberacao...",.F.)

				If Len(_aPedTau) > 0
					StartJob( "U_xM64PRC", GetEnvServer(), .F., _aPedTau )
				EndIf

			endif

			// Realiza nova busca e preenchidmento dos grids apos a aprovacao
			buscaPV()
		else
			alert('Nao foi selecionado nenhum registro para liberacao!')
		endif

		FWRestRows( aSaveLines )
		oView:Refresh()
	endif
return

//------------------------------------------------------------------
// Rejeita Selecionados
//------------------------------------------------------------------
static function rejeitaPv()
	local oModel		:= FWModelActive()
	local oMdlCenter	:= oModel:GetModel( 'CENTER' )
	local oMdlDown		:= oModel:GetModel( 'DOWN' )
	local aSaveLines	:= FWSaveRows()
	local oView			:= FwViewActive()
	private _aRegProc	:= {}

	for nJ := 1 to oMdlCenter:length()
		oMdlCenter:goLine(nJ)
		for nI := 1 to oMdlDown:length()
			if oMdlDown:getValue( "C6_ZSELECT", nI )
				//aadd(_aRegProc, { xFilial("SZV") , oMdlDown:getValue( "C6_NUM", nI ), oMdlDown:getValue( "C6_ITEM", nI ), oMdlDown:getValue( "ZV_CODRGA", nI ) })
				aadd(_aRegProc, { oMdlDown:getValue( "C6_FILIAL", nI ) , oMdlDown:getValue( "C6_NUM", nI ), oMdlDown:getValue( "C6_ITEM", nI ), oMdlDown:getValue( "ZV_CODRGA", nI ) })
			endif
		next
	next

	if len(_aRegProc) > 0
		if aviso("Rejeicao", "Sera realizada a REJEICAO de todos os itens marcados. Deseja Continuar?", { "Continuar", "Cancelar" }, 1) == 1
			processa( { || xMF10AtSZV( .F. ) }, "Aguarde...", "Processando a Rejeicao...", .F. )
		endif

		// Realiza nova busca e preenchidmento dos grids apos a aprovacao
		buscaPV()
	else
		alert('Nao foi selecionado nenhum registro rejeicao!')
	endif

	FWRestRows( aSaveLines )
	oView:Refresh()
return

/*
=====================================================================================
Programa............: xMF10AtSZV
Autor...............: Joni Lima
Data................: 18/10/2016
Descricao / Objetivo: Percorre os Browse executando Liberacao do Pedido ou Rejeicao
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Realiza Varredura dos Browses para Liberacao
=====================================================================================
*/
Static Function xMF10AtSZV(lLibera)
	Local aArea			:= GetArea()
	Local aAreaSC5		:= SC5->(GetArea())
	Local cAprov		:= ""//POSICIONE('SZS', 2, xFilial('SZS') + RetCodUsr(),'ZS_CODIGO')
	Local ni			:= 0
	Local aAux			:= {.T.,''}
	Local cMsg			:= ''
	Local lLib 			:= .F.
	Local lEnv			:= .F.

	ProcRegua(Len(_aRegProc))

	For ni := 1 to Len(_aRegProc)
		IncProc("Filial: " + _aRegProc[ni,1] + "Pedido: " + _aRegProc[ni,2] + "Item: " + _aRegProc[ni,3] )

		cAprov := GetAdvFVal("SZS","ZS_CODIGO",xFilial('SZS',_aRegProc[ni,1]) + RetCodUsr(), 2,"Erro")

		//cAprov := POSICIONE('SZS', 2, xFilial('SZS') + RetCodUsr(),'ZS_CODIGO')

		If _aRegProc[ni,4] == '000099'
			aAux := xMF10VerCl(_aRegProc[ni,1],_aRegProc[ni,2],_aRegProc[ni,3],_aRegProc[ni,4])
			If !aAux[1]
				cMsg += aAux[2] + CRLF
			EndIf
		EndIf

		If aAux[1]
			xMF10LbRj(_aRegProc[ni,1],_aRegProc[ni,2],_aRegProc[ni,3],_aRegProc[ni,4],cAprov,lLibera)

			dbSelectArea('SC5')
			SC5->(dbSetOrder(1))//C5_FILIAL + C5_NUM
			If SC5->(dbSeek(_aRegProc[ni,1] + _aRegProc[ni,2]))

				//Liberacao do WebService
				If xLibWS( _aRegProc[nI, 2] )
					RecLock('SC5',.F.)
					SC5->C5_ZCONWS := 'S'
					SC5->(MsUnlock())
				EndIf

				lLib := !(xMF10ExiB(_aRegProc[ni,1],_aRegProc[ni,2]))

				//Realiza Liberacao ou bloqueio
				RecLock('SC5',.F.)

				If lLib //Liberacao
					lEnv := SC5->C5_ZBLQRGA <> 'L'
					SC5->C5_ZBLQRGA := 'L'
					SC5->C5_ZLIBENV := 'S'
					SC5->C5_ZTAUREE := 'S'
					If SC5->C5_ZTAUINT == "S"
						AADD(_aPedTau,{SC5->C5_FILIAL,{SC5->C5_NUM,2,SC5->(Recno())}})
					Else
						SC5->C5_ZLIBENV := 'S'
					EndIf
				Else
					lEnv := SC5->C5_ZBLQRGA <> 'B'
					SC5->C5_ZBLQRGA := 'B'
					SC5->C5_ZLIBENV := 'S'
					SC5->C5_ZTAUREE := 'S'
				EndIf

				//If lEnv //Envia Novamente. // comentado em 22/03/18 por Gresele, para forcar sempre o envio do pedido ao Taura, toda vez que o pedido for avaliado nas regras de bloqueio
				// independente de ter havido troca do status do pedido

				//EndIf

				SC5->(MsUnlock())

				// TMS Saida		// Efetuo a rotina depois do MsUnlock() pois dentro da rotina tem travamento do SC5
				If FindFunction("U_TMSM410S")		// .and. U_TMSReenv(_aRegProc[ni,1],_aRegProc[ni,2])
					U_TMSM410STTS()
				Endif

			EndIf

		EndIf

	Next ni

	If !Empty(cMsg)
		AVISO("Bloqueios sem Classificacao", cMsg, { "OK" }, 3)
	EndIf

	RestArea(aAreaSC5)
	RestArea(aArea)

Return

/*
=====================================================================================
Programa............: xMF10VerCl
Autor...............: Joni Lima
Data................: 28/11/2016
Descricao / Objetivo: Realiza a Verificacao de classificacao de Perda
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Retorna se existe e uma descricao do problema.
=====================================================================================
*/
Static Function xMF10VerCl(cxFil,cPedido,cItem,cRegra)

	Local cRet := ''
	Local lRet := .T.

	If Empty(Posicione('SZV',1,cxFil + cPedido + cItem + cRegra,'ZV_CODPER'))
		lRet := .F.
		cRet := 'Filial: ' + cxFil + ', Pedido: ' + cPedido + ', Item: ' + cItem + ', Regra: ' + cRegra  + CRLF
		cRet += 'Bloqueio esta sem Classificacao de Perda, Favor Classificar'
	EndIf

Return {lRet,cRet}

/*
=====================================================================================
Programa............: xMF10LbRj
Autor...............: Joni Lima
Data................: 14/10/2016
Descricao / Objetivo: Realiza a liberacao do Item
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: altera a tabela SZV a aprovacao do Bloqueio
=====================================================================================
*/
static Function xMF10LbRj(cFilPed, cPedido,cItem,cReg,cAprov,lLib)
	Local aArea 	:= GetArea()
	Local aAreaSZV	:= SZV->(GetArea())
	local lRet		:= .T.
	Local oModMF10	:= nil
	Local oMdlSVZ	:= nil
	local cUpdSZV	:= ""

	Default lLib := .T.

	If !Empty(cPedido) .and. !Empty(cItem) .and. !Empty(cReg)
		DbSelectArea('SZV')
		SZV->(dbSetOrder(1))//ZV_FILIAL, ZV_PEDIDO, ZV_ITEMPED, ZV_CODRGA
		//If SZV->(dbSeek(xFilial('SZV') + cPedido + cItem + cReg))
		If SZV->(dbSeek(cFilPed + cPedido + cItem + cReg))

			If lLib
				cUpdSZV := ""
				cUpdSZV := "UPDATE " + retSQLName("SZV")						+ CRLF
				cUpdSZV += "	SET"											+ CRLF
				cUpdSZV += " 		ZV_CODAPR	= '" + cAprov			+ "',"	+ CRLF
				cUpdSZV += " 		ZV_DTAPR	= '" + dToS(dDataBase)	+ "',"	+ CRLF
				cUpdSZV += " 		ZV_HRAPR	= '" + LEFT(Time(),5)	+ "'"	+ CRLF
				cUpdSZV += " WHERE"												+ CRLF
				cUpdSZV += " 		ZV_CODRGA	=	'" + cReg		+ "'"		+ CRLF
				cUpdSZV += " 	AND	ZV_ITEMPED	=	'" + cItem		+ "'"		+ CRLF
				cUpdSZV += " 	AND	ZV_PEDIDO	=	'" + cPedido	+ "'"		+ CRLF
				cUpdSZV += " 	AND	ZV_FILIAL	=	'" + cFilPed	+ "'"		+ CRLF
				cUpdSZV += " 	AND	D_E_L_E_T_	=	' '"						+ CRLF

				if tcSQLExec( cUpdSZV ) < 0
					conout("Nao foi possivel executar UPDATE." + CRLF + tcSqlError())
				endif

				sfaZC5( cFilPed, cPedido )
			else
				cUpdSZV := ""
				cUpdSZV := "UPDATE " + retSQLName("SZV")						+ CRLF
				cUpdSZV += "	SET"											+ CRLF
				cUpdSZV += " 		ZV_CODRJC	= '" + cAprov			+ "',"	+ CRLF
				cUpdSZV += " 		ZV_DTRJC	= '" + dToS(dDataBase)	+ "',"	+ CRLF
				cUpdSZV += " 		ZV_HRRJC	= '" + LEFT(Time(),5)	+ "'"	+ CRLF

				if !empty(cMotivoRej)
					cUpdSZV += " 	,	ZV_MOTREJE	= '" + left( cMotivoRej, tamSX3("ZV_MOTREJE")[1] )	+ "'"	+ CRLF
				endif

				cUpdSZV += " WHERE"												+ CRLF
				cUpdSZV += " 		ZV_CODRGA	=	'" + cReg		+ "'"		+ CRLF
				cUpdSZV += " 	AND	ZV_ITEMPED	=	'" + cItem		+ "'"		+ CRLF
				cUpdSZV += " 	AND	ZV_PEDIDO	=	'" + cPedido	+ "'"		+ CRLF
				cUpdSZV += " 	AND	ZV_FILIAL	=	'" + cFilPed	+ "'"		+ CRLF
				cUpdSZV += " 	AND	D_E_L_E_T_	=	' '"						+ CRLF

				if tcSQLExec( cUpdSZV ) < 0
					conout("Nao foi possivel executar UPDATE." + CRLF + tcSqlError())
				endif
			endif

			ecomXC5( cFilPed, cPedido )

			/*oModMF10:= FWLoadModel( 'MGFFAT10' )
			oModMF10:SetOperation( MODEL_OPERATION_UPDATE )

			If oModMF10:Activate()

				oMdlSVZ := oModMF10:GetModel('SZVMASTER')

				If lLib
					oMdlSVZ:SetValue('ZV_CODAPR',cAprov 		)
					oMdlSVZ:SetValue('ZV_DTAPR' ,dDataBase		)
					oMdlSVZ:SetValue('ZV_HRAPR'	,LEFT(Time(),5)	)

					sfaZC5( cFilPed, cPedido )
				Else
					oMdlSVZ:SetValue('ZV_CODRJC',cAprov 		)
					oMdlSVZ:SetValue('ZV_DTRJC' ,dDataBase		)
					oMdlSVZ:SetValue('ZV_HRRJC'	,LEFT(Time(),5)	)

					if fieldPos( "ZV_MOTREJE" ) > 0
						if !empty(cMotivoRej)
							oMdlSVZ:SetValue('ZV_MOTREJE' ,left( cMotivoRej, tamSX3("ZV_MOTREJE")[1] ) )
						endif
					endif
				EndIf

				If oModMF10:VldData()
					lRet := FwFormCommit(oModMF10)
					oModMF10:DeActivate()
					oModMF10:Destroy()
				Else
					JurShowErro( oModMF10:GetModel():GetErrormessage() )
					lRet := .F.
				EndIf
			EndIf*/
		ELSE
			if left(cItem,1) == "0"
				cItem := padR( substring(cItem,2,1), tamSx3("ZV_ITEMPED")[1] )
				SZV->(dbSetOrder(1))//ZV_FILIAL, ZV_PEDIDO, ZV_ITEMPED, ZV_CODRGA
				If SZV->(dbSeek(cFilPed + cPedido + cItem + cReg))

					If lLib
						cUpdSZV := ""
						cUpdSZV := "UPDATE " + retSQLName("SZV")						+ CRLF
						cUpdSZV += "	SET"											+ CRLF
						cUpdSZV += " 		ZV_CODAPR	= '" + cAprov			+ "',"	+ CRLF
						cUpdSZV += " 		ZV_DTAPR	= '" + dToS(dDataBase)	+ "',"	+ CRLF
						cUpdSZV += " 		ZV_HRAPR	= '" + LEFT(Time(),5)	+ "'"	+ CRLF
						cUpdSZV += " WHERE"												+ CRLF
						cUpdSZV += " 		ZV_CODRGA	=	'" + cReg		+ "'"		+ CRLF
						cUpdSZV += " 	AND	ZV_ITEMPED	=	'" + cItem		+ "'"		+ CRLF
						cUpdSZV += " 	AND	ZV_PEDIDO	=	'" + cPedido	+ "'"		+ CRLF
						cUpdSZV += " 	AND	ZV_FILIAL	=	'" + cFilPed	+ "'"		+ CRLF
						cUpdSZV += " 	AND	D_E_L_E_T_	=	' '"						+ CRLF

						if tcSQLExec( cUpdSZV ) < 0
							conout("Nao foi possivel executar UPDATE." + CRLF + tcSqlError())
						endif

						sfaZC5( cFilPed, cPedido )
					else
						cUpdSZV := ""
						cUpdSZV := "UPDATE " + retSQLName("SZV")						+ CRLF
						cUpdSZV += "	SET"											+ CRLF
						cUpdSZV += " 		ZV_CODRJC	= '" + cAprov			+ "',"	+ CRLF
						cUpdSZV += " 		ZV_DTRJC	= '" + dToS(dDataBase)	+ "',"	+ CRLF
						cUpdSZV += " 		ZV_HRRJC	= '" + LEFT(Time(),5)	+ "'"	+ CRLF

						if !empty(cMotivoRej)
							cUpdSZV += " 	,	ZV_MOTREJE	= '" + left( cMotivoRej, tamSX3("ZV_MOTREJE")[1] )	+ "'"	+ CRLF
						endif

						cUpdSZV += " WHERE"												+ CRLF
						cUpdSZV += " 		ZV_CODRGA	=	'" + cReg		+ "'"		+ CRLF
						cUpdSZV += " 	AND	ZV_ITEMPED	=	'" + cItem		+ "'"		+ CRLF
						cUpdSZV += " 	AND	ZV_PEDIDO	=	'" + cPedido	+ "'"		+ CRLF
						cUpdSZV += " 	AND	ZV_FILIAL	=	'" + cFilPed	+ "'"		+ CRLF
						cUpdSZV += " 	AND	D_E_L_E_T_	=	' '"						+ CRLF

						if tcSQLExec( cUpdSZV ) < 0
							conout("Nao foi possivel executar UPDATE." + CRLF + tcSqlError())
						endif
					endif

					ecomXC5( cFilPed, cPedido )

/*					oModMF10:= FWLoadModel( 'MGFFAT10' )
					oModMF10:SetOperation( MODEL_OPERATION_UPDATE )

					If oModMF10:Activate()

						oMdlSVZ := oModMF10:GetModel('SZVMASTER')

						If lLib
							oMdlSVZ:SetValue('ZV_CODAPR',cAprov 		)
							oMdlSVZ:SetValue('ZV_DTAPR' ,dDataBase		)
							oMdlSVZ:SetValue('ZV_HRAPR'	,LEFT(Time(),5)	)

							sfaZC5( cFilPed, cPedido )
						Else
							oMdlSVZ:SetValue('ZV_CODRJC',cAprov 		)
							oMdlSVZ:SetValue('ZV_DTRJC' ,dDataBase		)
							oMdlSVZ:SetValue('ZV_HRRJC'	,LEFT(Time(),5)	)
						EndIf

						If oModMF10:VldData()
							lRet := FwFormCommit(oModMF10)
							oModMF10:DeActivate()
							oModMF10:Destroy()
						Else
							JurShowErro( oModMF10:GetModel():GetErrormessage() )
							lRet := .F.
						EndIf
					EndIf*/
				EndIf
			endif
		EndIf
	Else
		lRet := .F.
	EndIf

	RestArea(aAreaSZV)
	RestArea(aArea)

Return lRet


Static function xLibWS( cC5Num )

	local aArea 	:= GetArea()
	Local aAreaSZV	:= SZV->(GetArea())
	Local lCont		:= .T.

	dbSelectArea('SZV')
	SZV->(dbSetOrder(1))//ZV_FILIAL+ZV_PEDIDO+ZV_ITEMPED+ZV_CODRGA

	//96
	If SZV->(dbSeek(xFilial('SZV') + cC5Num + '01' + '000096'))
		If Empty(SZV->ZV_DTAPR)
			lCont := .F.
		EndIf
	Else
		lCont := .T.
	EndIf
	//97
	If lCont
		If SZV->(dbSeek(xFilial('SZV') + cC5Num + '01' + '000097'))
			If Empty(SZV->ZV_DTAPR)
				lCont := .F.
			EndIf
		Else
			lCont := .T.
		EndIf
	EndIf
	//98
	If lCont
		If SZV->(dbSeek(xFilial('SZV') + cC5Num + '01' + '000098'))
			If Empty(SZV->ZV_DTAPR)
				lCont := .F.
			EndIf
		Else
			lCont := .T.
		EndIf
	EndIf

	RestArea(aAreaSZV)
	RestArea(aArea)

return lCont


/*
=====================================================================================
Programa............: xMF10ExiB
Autor...............: Joni Lima
Data................: 14/10/2016
Descricao / Objetivo: Verifica se existe bloqueio nao aprovado para o pedido
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Verifica na se existe bloqueio para o pedido SZV sem Data de aprovacao
=====================================================================================
*/
static Function xMF10ExiB(cxFil,cPedido)

	Local aArea 	:= GetArea()
	Local aAreaSZV	:= SZV->(GetArea())
	Local aAreaSC5	:= SC5->(GetArea())
	Local lRet 		:= .F.

	Default cPedido := ''

	If !Empty(cPedido)
		dbSelectArea('SC5')
		SC5->(dbSetOrder(1))
		If SC5->(dbSeek(xFilial('SC5',cxFil) + cPedido))
			If SC5->C5_ZCONWS == 'S' //Verifica se ja fez a consulta do Webservice
				dbSelectArea('SZV')
				SZV->(dbSetOrder(1))////ZV_FILIAL, ZV_PEDIDO, ZV_ITEMPED, ZV_CODRGA
				If SZV->(DbSeek(xFilial('SZV',cxFil) + cPedido))
					While SZV->(!Eof()).and. ( SZV->(ZV_FILIAL + ZV_PEDIDO ) == xFilial('SZV',cxFil) + cPedido )
						If Empty(SZV->ZV_DTAPR)
							lRet := .T.
							Exit
						EndIf
						SZV->(dbSkip())
					EndDo
				EndIf
			Else
				lRet := .T.
			EndIf
		Else
			lRet := .T.
		EndIf
	EndIf

	RestArea(aAreaSC5)
	RestArea(aAreaSZV)
	RestArea(aArea)

Return lRet

//-----------------------------------------------------------------
// Atualiza ZC5 para retorno do Pedido na integracao do SFA
//-----------------------------------------------------------------
static function sfaZC5( cFilPed, cPedidoZC5 )
	local cUpdZC5 := ""

	cUpdZC5 := "UPDATE " + retSQLName("ZC5")
	cUpdZC5 += " SET "
	cUpdZC5 += "	ZC5_INTEGR = 'P'"
	cUpdZC5 += " WHERE"
	cUpdZC5 += "		ZC5_FILIAL	=	'" + cFilPed	+ "'"
	cUpdZC5 += "	AND	ZC5_PVPROT	=	'" + cPedidoZC5	+ "'"
	cUpdZC5 += "	AND	D_E_L_E_T_	=	' '"

	tcSQLExec(cUpdZC5)

	// ATUALIZA PEDIDO DE VENDA - SC5
	cUpdZC5 := ""

	cUpdZC5 := "UPDATE " + retSQLName("SC5")
	cUpdZC5 += " SET "
	cUpdZC5 += "	C5_XINTEGR = 'P'"
	cUpdZC5 += " WHERE"
	cUpdZC5 += "		C5_FILIAL	=	'" + cFilPed	+ "'"
	cUpdZC5 += "	AND	C5_NUM		=	'" + cPedidoZC5	+ "'"
	cUpdZC5 += "	AND	D_E_L_E_T_	<>	'*'"

	tcSQLExec(cUpdZC5)
return

//-----------------------------------------------------------------
// Atualiza XC5 para Tracking do E-Commerce
//-----------------------------------------------------------------
static function ecomXC5( cFilPed, cPedidoXC5 )
	local cUpdXC5 := ""

	cUpdXC5 := "UPDATE " + retSQLName("XC5")
	cUpdXC5 += " SET "
	cUpdXC5 += "	XC5_INTEGR = 'P'"
	cUpdXC5 += " WHERE"
	cUpdXC5 += "		XC5_FILIAL	=	'" + cFilPed	+ "'"
	cUpdXC5 += "	AND	XC5_PVPROT	=	'" + cPedidoXC5	+ "'"
	cUpdXC5 += "	AND	D_E_L_E_T_	=	' '"

	tcSQLExec( cUpdXC5 )
return

/*
=====================================================================================
Programa............: xMF10ClCon
Autor...............: Joni Lima
Data................: 10/10/2016
Descricao / Objetivo: Chama rotina de posicao do Cliente
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Faz a visualizacao das consultas dos clientes
=====================================================================================
*/
static Function xMF10ClCon()

	Local aArea		:= GetArea()
	Local aAreaSA1	:= SA1->(GetArea())
	Local cPerg		:= "MGFFAT10"
	Local cCliLoj	:= ''

	local oModel		:= FWModelActive()
	local oMdlTop		:= oModel:GetModel( 'TOP' )
	local oMdlCenter	:= oModel:GetModel( 'CENTER' )

	Private aRotina := {	{"Pesquisar","PesqBrw"		, 0 , 1 , 0 , .F.},;	// "Pesquisar"
	{"Visualizar","A410Visual"	, 0 , 2 , 0 , NIL},;	// "Visualizar"
	{"Liberar","A440Libera"		, 0 , 6 , 0 , NIL},;	// "Liberar"
	{"Automatico","A440Automa"	, 0 , 0 , 0 , NIL},;	// "Automatico"
	{"Legenda","A410Legend"		, 0 , 0 , 0 , .F.}}		// "Legenda"

	DBSelectArea('SA1')
	SA1->(DBSetOrder(1))//A1_FILIAL, A1_COD, A1_LOJA

	cCliLoj := oMdlCenter:getValue("C5_CLIENTE") + oMdlCenter:getValue("C5_LOJACLI")

	If SA1->(DbSeek(xFilial('SA1') + cCliLoj ))
		a450F4Con()
		PERGUNTE(cPerg,.F.)
	EndIf

	RestArea(aAreaSA1)
	RestArea(aArea)
Return

//----------------------------------------------------------------------
// Exibe a Grade de Entrega
//----------------------------------------------------------------------
static function showGrid()
	local oDlgGrid		:= nil
	local aCoors		:= FWGetDialogSize( oMainWnd )
	local oFwBrow		:= nil
	local cQryZDQ		:= ""
	local aGrade		:= {}

	cQryZDQ := "SELECT *"
	cQryZDQ += " FROM " + retSQLName("ZDQ") + " ZDQ"
	cQryZDQ += " WHERE"
	cQryZDQ += "		ZDQ.ZDQ_FILIAL	=	'" + xFilial("ZDQ") + "'"
	cQryZDQ += "	AND	ZDQ.D_E_L_E_T_	=	' '"

	tcQuery cQryZDQ New Alias "QRYZDQ"

	if !QRYZDQ->(EOF())
		while !QRYZDQ->(EOF())
			aadd( aGrade, {QRYZDQ->ZDQ_GRADE, QRYZDQ->ZDQ_SEGUND, QRYZDQ->ZDQ_TERCA, QRYZDQ->ZDQ_QUARTA, QRYZDQ->ZDQ_QUINTA, QRYZDQ->ZDQ_SEXTA} )
			QRYZDQ->(DBSkip())
		enddo

		//-------------------------------------------------------------
		// Tela de selecao da Oportunidade
		//-------------------------------------------------------------
		DEFINE MSDIALOG oDlgGrid TITLE 'Grade de Entrega' FROM aCoors[1]/2, aCoors[2]/2 TO aCoors[3]/2, aCoors[4]/2 PIXEL //STYLE DS_MODALFRAME
			oFwBrow := fwBrowse():New()
			oFwBrow:setDataArray()
			oFwBrow:setArray(aGrade)
			oFwBrow:disableConfig()
			oFwBrow:disableReport()
			oFwBrow:setOwner(oDlgGrid)

			oFwBrow:addColumn({"Grade"		, {||aGrade[oFwBrow:nAt,1]}		, "C", pesqPict("ZDQ","ZDQ_GRADE")	, 1, tamSx3("ZDQ_GRADE")[1]/2	,, .F.})
			oFwBrow:addColumn({"Segunda"	, {||aGrade[oFwBrow:nAt,2]}		, "C", pesqPict("ZDQ","ZDQ_SEGUND")	, 1, tamSx3("ZDQ_SEGUND")[1]	,, .F.})
			oFwBrow:addColumn({"Terca"		, {||aGrade[oFwBrow:nAt,3]}		, "C", pesqPict("ZDQ","ZDQ_TERCA")	, 1, tamSx3("ZDQ_TERCA")[1]		,, .F.})
			oFwBrow:addColumn({"Quarta"		, {||aGrade[oFwBrow:nAt,4]}		, "C", pesqPict("ZDQ","ZDQ_QUARTA")	, 1, tamSx3("ZDQ_QUARTA")[1]	,, .F.})
			oFwBrow:addColumn({"Quinta"		, {||aGrade[oFwBrow:nAt,5]}		, "C", pesqPict("ZDQ","ZDQ_QUINTA")	, 1, tamSx3("ZDQ_QUINTA")[1]	,, .F.})
			oFwBrow:addColumn({"Sexta"		, {||aGrade[oFwBrow:nAt,6]}		, "C", pesqPict("ZDQ","ZDQ_SEXTA")	, 1, tamSx3("ZDQ_SEXTA")[1]		,, .F.})

	/* add(Column
	[n][01] Titulo da coluna
	[n][02] Code-Block de carga dos dados
	[n][03] Tipo de dados
	[n][04] Mascara
	[n][05] Alinhamento (0=Centralizado, 1=Esquerda ou 2=Direita)
	[n][06] Tamanho
	[n][07] Decimal
	[n][08] Indica se permite a edicao
	[n][09] Code-Block de validacao da coluna apos a edicao
	[n][10] Indica se exibe imagem
	[n][11] Code-Block de execucao do duplo clique
	[n][12] Variavel a ser utilizada na edicao (ReadVar)
	[n][13] Code-Block de execucao do clique no header
	[n][14] Indica se a coluna esta deletada
	[n][15] Indica se a coluna sera exibida nos detalhes do Browse
	[n][16] Opcoes de carga dos dados (Ex: 1=Sim, 2=Nao)
	[n][17] Id da coluna
	[n][18] Indica se a coluna � virtual
	*/

			oFwBrow:activate(.T.)

		ACTIVATE MSDIALOG oDlgGrid CENTER
	else
		msgAlert("Nao foi cadastrada Grade de Entrega")
	endif

	QRYZDQ->(DBCloseArea())
return

//--------------------------------------------------
// Faz a marcacao/ desmarcacao dos registros
//--------------------------------------------------
static function marcacao(lMarca)
	local oModel		:= FWModelActive()
	local oMdlCenter	:= oModel:GetModel( 'CENTER' )
	local oMdlDown		:= oModel:GetModel( 'DOWN' )
	local oView			:= FwViewActive()
	local nI			:= 0
	local nJ			:= 0

	for nJ := 1 to oMdlCenter:length()
		oMdlCenter:goLine(nJ)
		oMdlCenter:loadValue("C5_ZSELECT", lMarca)
		for nI := 1 to oMdlDown:length()
			oMdlDown:goLine(nI)
			oMdlDown:loadValue("C6_ZSELECT", lMarca)
		next
		oMdlDown:goLine(1)
	next
	oMdlCenter:goLine(1)

	oView:Refresh()
return

//----------------------------------------------------------
//----------------------------------------------------------
static function motivoReje()
	private oDlg		:= nil
	private oSay1		:= nil
	private oSay2		:= nil
	private oGetMotivo	:= nil
	private cGetMotivo	:= nil
	private aCoors		:= 	FWGetDialogSize( oMainWnd )

	cMotivoRej := ""

	DEFINE MSDIALOG oDlg TITLE 'Motivo de Rejeicao' FROM  aCoors[1]/2, aCoors[2]/2 TO aCoors[3]/2-100, aCoors[4]/2-150 PIXEL STYLE DS_MODALFRAME

		@ 025, 005 SAY oSay2 PROMPT "Motivo:"							SIZE 035, 007 OF oDlg COLORS 0, 16777215 PIXEL
		@ 007, 050 GET oGetMotivo VAR cGetMotivo OF oDlg MULTILINE		SIZE 175, 044 COLORS 0, 16777215 HSCROLL PIXEL

		@ 080, 005 BUTTON oBtnSelec	PROMPT "Confirmar"	SIZE 037, 012 OF oDlg PIXEL ACTION ( nOpcx := 1, cMotivoRej := cGetMotivo, rejeitaPv()	, oDlg:end() )
		@ 080, 050 BUTTON oBtnSair	PROMPT "Sair"		SIZE 037, 012 OF oDlg PIXEL ACTION ( nOpcx := 0, msgAlert("Rejeicao cancelada!")		, oDlg:end() )

	ACTIVATE MSDIALOG oDlg CENTER
return

User Function xM64PRC(aPeds)

	Local ni	:= 1

	RpcSetType(3)
	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "010001" //aParam[1] FILIAL aParam[2]

		dbSelectArea("SC5")
		SC5->(dbSetOrder(1))//C5_FILIAL + C5_NUM


		For ni := 1 to len(aPeds)

			cFilAnt	:= aPeds[ni][1]

			If SC5->(dbSeek(aPeds[ni][1] + aPeds[ni][2][1]))

				RecLock('SC5',.F.)
					SC5->C5_ZLIBENV := 'S'
				SC5->(MsUnlock())

				U_TAS01EnvPV(aPeds[ni][2])
			EndIf
		Next ni

	RESET ENVIRONMENT

Return
