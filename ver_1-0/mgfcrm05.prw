#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"
#include 'fwmvcdef.ch'
#include 'tbiconn.ch'

#define CRLF chr(13) + chr(10)
#DEFINE SD2CAMPOS "D2_ITEM | D2_COD | D2_QUANT | D2_PRCVEN | D2_TOTAL | D2_DOC | D2_SERIE "
/*
=====================================================================================
Programa.:              MGFCRM05
Autor....:              Gustavo Ananias Afonso - TOTVS Campinas
Data.....:              25/03/2017
Descricao / Objetivo:   RAMI
Doc. Origem:            GAP CRM
Solicitante:            Cliente
Uso......:              
Obs......:
=====================================================================================
*/
user function MGFCRM05()
	Local _aArea := GetArea()

	Private _cAlias	:=	"ZAV"

	oBrowse := FWMBrowse():New()

	//Define um alias para o Browse
	oBrowse:SetAlias(_cAlias)
	//Adiciona uma descrição para o Browse
	oBrowse:SetDescription('Relatorio de An�lise de Mercado Interno')

	/*Define legenda para o Browse de acordo com uma variavel
	Obs: Para visuzalir as legenda em MVC basta dar duplo clique no marcador de legenda*/
	oBrowse:AddLegend( _cAlias + "_STATUS=='0' .AND. " + _cAlias + "_TPFLAG<>'1'"	, "RED"		, "Em andamento"	)
	oBrowse:AddLegend( _cAlias + "_STATUS=='1' .AND. " + _cAlias + "_TPFLAG<>'1'" 	, "GREEN"	, "Finalizado"		)
	oBrowse:AddLegend( _cAlias + "_STATUS<>' ' .AND. " + _cAlias + "_TPFLAG=='1'"	, "Orange"	, "Reclama��o"		)

	//Ativa o Browse
	oBrowse:Activate()

	RestArea(_aArea)

return nil



static function MenuDef()
	If Type("aRotina")=="U"
		Private aRotina := {}
	EndIf

	ADD OPTION aRotina TITLE 'Visualizar'	 			ACTION 'VIEWDEF.MGFCRM05'	OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Incluir'		 			ACTION 'VIEWDEF.MGFCRM05'	OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar'		 			ACTION 'VIEWDEF.MGFCRM05'	OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Excluir'		 			ACTION 'VIEWDEF.MGFCRM05'	OPERATION 5 ACCESS 0
	ADD OPTION aRotina TITLE 'Conhecimento'	 			ACTION 'U_ZAVRECNO'			OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Relatorio'	 			ACTION 'U_MGFCRM45'			OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Finaliza RAMI' 			ACTION 'U_MGFIMRAM'			OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Estorna Finalizacao RAMI' ACTION 'U_MGFEXTRAM'		OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Imprimir Motivo' 			ACTION 'U_MGFCRM53'			OPERATION 2 ACCESS 0

return aRotina



//--------------------------------------------------------
static function ModelDef()
	Local aZAWRel	:= {}
	Local aZAXRel	:= {}
	Local aSD2Rel	:= {}
	Local bPosVld	:= {|| vldMdlRAMI() }
	Local oStruZAV	:= FWFormStruct( 1, _cAlias, )
	Local oStruSD2 	:= FWFormStruct( 1, "SD2")
	Local oStruZAW 	:= FWFormStruct( 1, 'ZAW')
	Local oStruZAX	:= FWFormStruct( 1, 'ZAX', /*{| cCampo | !AllTrim( cCampo ) + '|' $ ZAXCAMPOS }*/)
	Local oModel	:= nil
	Local oMdlGrid	:= nil

	oModel := MPFormModel():New( 'MDLCRM05' , , { | oModel | CRM05POS( oModel ) }, { | oModel | crm05cmt( oModel ) }/*bCommit*/)

	//----------------------------------------------------------------------------------------
	// ADICAO DE CAMPOS
	//----------------------------------------------------------------------------------------

	oStruSD2:AddField(	;	// Ord. Tipo Desc.
	""					, ;	// [01]  C   Titulo do campo
	"D2_ZCRITIC"		, ;	// [02]  C   ToolTip do campo
	"D2_ZCRITIC"		, ;	// [03]  C   Id do Field
	'BT'				, ;	// [04]  C   Tipo do campo
	2					, ;	// [05]  N   Tamanho do campo
	0					, ;	// [06]  N   Decimal do campo
						, ;	// [07]  B   Code-block de validacao do campo
						, ;	// [08]  B   Code-block de validacao When do campo
						, ;	// [09]  A   Lista de valores permitido do campo
	.F.					, ;	// [10]  L   Indica se o campo tem preenchimento obrigat�rio
	{|| iniBtnAdd() }	, ;	// [11]  B   Code-block de inicializacao do campo
	)						// [14]  L   Indica se o campo � virtual

	oStruSD2:AddField(		;	// Ord. Tipo Desc.
	""						, ;	// [01]  C   Titulo do campo
	"D2_ZDESCB1"			, ;	// [02]  C   ToolTip do campo
	"D2_ZDESCB1"			, ;	// [03]  C   Id do Field
	'C'						, ;	// [04]  C   Tipo do campo
	76						, ;	// [05]  N   Tamanho do campo
	0						, ;	// [06]  N   Decimal do campo
							, ;	// [07]  B   Code-block de validacao do campo
							, ;	// [08]  B   Code-block de validacao When do campo
							, ;	// [09]  A   Lista de valores permitido do campo
	.F.						, ;	// [10]  L   Indica se o campo tem preenchimento obrigat�rio
	{ || iniD2Desc() }		, ;	// [11]  B   Code-block de inicializacao do campo
	)							// [14]  L   Indica se o campo � virtual

	//----------------------------------------------------------------------------------------
	// ADICAO DE GATILHOS
	//----------------------------------------------------------------------------------------

	aAux := nil
	aAux := FwStruTrigger(		;
	'D2_ZCRITIC'				,;		// DOMINIO
	'D2_ZCRITIC'				,;		// CONTRA DOMINIO
	'U_sd2ADD(M->D2_ZCRITIC)'	,;		// REGRA PREENCHIMENTO
	.F.							,;		// POSICIONA
								,;		// ALIAS
								,;		// ORDEM
								,;		// CHAVE
								,;		// CONDICAO
	)

	oStruSD2:AddTrigger( ;
	aAux[1], ;                                                      // [01] Id do campo de origem
	aAux[2], ;                                                      // [02] Id do campo de destino
	aAux[3], ;                                                      // [03] Bloco de codigo de validacao da execucao do gatilho
	aAux[4] )                                                       // [04] Bloco de codigo de execucao do gatilho



	aAux := FwStruTrigger(;
	'ZAW_QTD'					,;	// DOMINIO
	'ZAW_QTD'					,;	// CONTRA DOMINIO
	'U_trgZAW(M->ZAW_QTD, 1)'	,;	// REGRA PREENCHIMENTO
	.F.							,;	// POSICIONA
								,;	// ALIAS
								,;	// ORDEM
								,;	// CHAVE
								,;	// CONDICAO
	)

	oStruZAW:AddTrigger( ;
	aAux[1], ;                                                   	// [01] Id do campo de origem
	aAux[2], ;                                                      // [02] Id do campo de destino
	aAux[3], ;                                                      // [03] Bloco de codigo de validacao da execucao do gatilho
	aAux[4] )                                                       // [04] Bloco de codigo de execucao do gatilho

	aAux := FwStruTrigger(;
	'ZAW_PRECO'					,;	// DOMINIO
	'ZAW_PRECO'					,;	// CONTRA DOMINIO
	'U_trgZAW(M->ZAW_PRECO, 2)'	,;	// REGRA PREENCHIMENTO
	.F.							,;	// POSICIONA
								,;	// ALIAS
								,;	// ORDEM
								,;	// CHAVE
								,;	// CONDICAO
	)

	oStruZAW:AddTrigger( ;
	aAux[1], ;                                                      // [01] Id do campo de origem
	aAux[2], ;                                                      // [02] Id do campo de destino
	aAux[3], ;                                                      // [03] Bloco de codigo de validacao da execucao do gatilho
	aAux[4] )                                                       // [04] Bloco de codigo de execucao do gatilho


	aAux := FwStruTrigger(;
	'ZAW_DIRECI'							,;			// DOMINIO
	'ZAW_MOTIVO'							,;			// CONTRA DOMINIO
	"u_getDirec(FWFldGet('ZAW_DIRECI'), 1)"	,;			// REGRA PREENCHIMENTO
	.F.										,;			// POSICIONA
											,;			// ALIAS
											,;			// ORDEM
											,;			// CHAVE
	".T."									,;			// CONDICAO
	)

	oStruZAW:AddTrigger( ;
	aAux[1], ;                                          // [01] Id do campo de origem
	aAux[2], ;                                          // [02] Id do campo de destino
	aAux[3], ;                                          // [03] Bloco de codigo de validacao da execucao do gatilho
	aAux[4] )                                     		// [04] Bloco de codigo de execucao do gatilho

	aAux := FwStruTrigger(;
	'ZAW_DIRECI'								,;		// DOMINIO
	'ZAW_JUSTIF'								,;		// CONTRA DOMINIO
	"u_getDirec(FWFldGet('ZAW_DIRECI'), 2)"		,;		// REGRA PREENCHIMENTO
	.F.											,;		// POSICIONA
												,;		// ALIAS
												,;		// ORDEM
												,;		// CHAVE
	".T."										,;		// CONDICAO
	)

	oStruZAW:AddTrigger( ;
	aAux[1]			,;		// [01] Id do campo de origem
	aAux[2]			,;		// [02] Id do campo de destino
	aAux[3]			,;		// [03] Bloco de codigo de validacao da execucao do gatilho
	aAux[4] )        		// [04] Bloco de codigo de execucao do gatilho


	aAux := FwStruTrigger(;
	'ZAW_QTD'		,;									// DOMINIO
	'ZAW_TOTAL'		,;									// CONTRA DOMINIO
	"fwFldGet('ZAW_QTD') * fwFldGet('ZAW_PRECO')"	,;	// REGRA PREENCHIMENTO
	.F.				,;									// POSICIONA
					,;									// ALIAS
					,;									// ORDEM
					,;									// CHAVE
	".T."			,;									// CONDICAO
	)

	oStruZAW:AddTrigger( ;
	aAux[1], ; 					// [01] Id do campo de origem
	aAux[2], ; 					// [02] Id do campo de destino
	aAux[3], ;					// [03] Bloco de codigo de validacao da execucao do gatilho
	aAux[4] )					// [04] Bloco de codigo de execucao do gatilho

	//identifica o usuario de alteracao do status das ocorrencias
	aAux := FwStruTrigger(;
	"ZAW_STATUS"		,;			// DOMINIO
	"ZAW_LOGUSR"		,;			// CONTRA DOMINIO
	"U_stsZAW()"		,;			// REGRA PREENCHIMENTO
	.F.					,;			// POSICIONA
						,;			// ALIAS
						,;			// ORDEM
						,;			// CHAVE
						,;			// CONDICAO
	)

	oStruZAW:AddTrigger( ;
	aAux[1]				,;          // [01] Id do campo de origem
	aAux[2]				,;          // [02] Id do campo de destino
	aAux[3]				,;          // [03] Bloco de codigo de validacao da execucao do gatilho
	aAux[4] 			) 			// [04] Bloco de codigo de execucao do gatilho

	oStruZAW:SetProperty("ZAW_DIRECI"	, MODEL_FIELD_VALID		, { || U_MGFCRM50( 3 ) } )

	oStruZAV:SetProperty(_cAlias + "_NOTA"	, MODEL_FIELD_VALID		, { || chkNf() } )
	oStruZAV:SetProperty(_cAlias + "_SERIE"	, MODEL_FIELD_VALID		, { || chkNf() } )

	oStruSD2:SetProperty("*", MODEL_FIELD_OBRIGAT	, .F. )
	oStruSD2:SetProperty("*", MODEL_FIELD_VALID		, { || .T. } )

	oModel:AddFields( 'ZAVMASTER',				, oStruZAV, {|a,b,c,d,e| prevldZAV(a,b,c,d,e)} )
	oModel:AddGrid	( 'SD2DETAIL', 'ZAVMASTER'	, oStruSD2, /*{|a,b,c,d,e| prevldSD2(a,b,c,d,e)} bPreValidacao*/ )
	oModel:AddGrid	( 'ZAWDETAIL', 'ZAVMASTER'	, oStruZAW, {|a,b,c,d,e| prevldZAW(a,b,c,d,e)} /*bPreValidacao*/, /*bPosValidacao*/ )
	oModel:AddGrid	( 'ZAXDETAIL', 'ZAVMASTER'	, oStruZAX, {|a,b,c,d,e| prevldZAX(a,b,c,d,e)} /*bPreValidacao*/ )

	oStruZAV:SetProperty(_cAlias + '_CREDEC', MODEL_FIELD_WHEN , { || isEcomBole() } )
	oStruZAV:SetProperty(_cAlias + '_CONTA'	, MODEL_FIELD_WHEN , { || isEcomBole() } )

	//Fazendo o relacionamento entre o Pai e Filho
	aadd(aSD2Rel, {'D2_FILIAL'	, 'xFilial( "SD2" )'	})
	aadd(aSD2Rel, {'D2_DOC'		, _cAlias + '_NOTA'		})
	aadd(aSD2Rel, {'D2_SERIE'	, _cAlias + '_SERIE'	})

	aadd(aZAWRel, {'ZAW_FILIAL'	, 'xFilial( "ZAW" )'	})
	aadd(aZAWRel, {'ZAW_NOTA'	, _cAlias + '_NOTA'		})
	aadd(aZAWRel, {'ZAW_SERIE'	, _cAlias + '_SERIE'	})
	aadd(aZAWRel, {'ZAW_CDRAMI'	, _cAlias + '_CODIGO'	})

	//Fazendo o relacionamento entre o Filho e Neto
	aadd(aZAXRel, {'ZAX_FILIAL'	, 'xFilial( "ZAX" )'	})
	aadd(aZAXRel, {'ZAX_NOTA'	, _cAlias + '_NOTA'		})
	aadd(aZAXRel, {'ZAX_SERIE'	, _cAlias + '_SERIE'	})
	aadd(aZAXRel, {'ZAX_CDRAMI'	, _cAlias + '_CODIGO'	})

	oModel:SetRelation( 'SD2DETAIL' , aSD2Rel , SD2->(IndexKey( 1 )) )
	oModel:SetRelation( 'ZAWDETAIL' , aZAWRel , ZAW->(IndexKey( 1 )) )
	oModel:SetRelation( 'ZAXDETAIL' , aZAXRel , ZAX->(IndexKey( 1 )) )

	oModel:SetDescription( 'Relatorio de An�lise de Mercado Interno' )

	oModel:GetModel( 'ZAWDETAIL'):SetOptional(.T.)
	oModel:GetModel( 'ZAXDETAIL'):SetOptional(.T.)

	oModel:setPrimaryKey( {} )

	oModel:GetModel( 'ZAVMASTER' ):SetDescription( 'RAMI' )
	oModel:GetModel( 'SD2DETAIL' ):SetDescription( 'Notas' )
	oModel:GetModel( 'ZAWDETAIL' ):SetDescription( 'Ocorr�ncias' )
	oModel:GetModel( 'ZAXDETAIL' ):SetDescription( 'Resolu��o' )

	oModel:GetModel( 'SD2DETAIL' ):SetNoInsertLine( .T. )
	oModel:GetModel( 'ZAWDETAIL' ):SetNoInsertLine( .T. )
	oModel:GetModel( 'ZAXDETAIL' ):SetNoInsertLine( .T. )
return oModel



static function ViewDef()
	Local oModel		:= FWLoadModel( 'MGFCRM05' )
	Local oStruZAV	:= FWFormStruct( 2, _cAlias	, {| cCampo | ! allTrim( cCampo ) $ _cAlias + "_FILIAL" })
	Local oStruSD2	:= FWFormStruct( 2, 'SD2'	, {| cCampo | allTrim(cCampo) $ SD2CAMPOS })
	Local oStruZAW	:= FWFormStruct( 2, 'ZAW'	, {| cCampo | ! allTrim( cCampo ) $ "ZAW_CDRAMI | ZAW_FILIAL" } )
	Local oStruZAX	:= FWFormStruct( 2, 'ZAX'	, {| cCampo | ! allTrim( cCampo ) $ "ZAX_CDRAMI | ZAX_FILIAL" } )
	Local oView		:= nil

	oView := FWFormView():New()

	oStruSD2:AddField(	"D2_ZCRITIC"								,;	// [01]  C   Nome do Campo
	"01"															,;	// [02]  C   Ordem
	"Add"															,;	// [03]  C   Titulo do campo//"Descricao"
	"Critica"														,;	// [04]  C   Descricao do campo//"Descricao"
	NIL																,;	// [05]  A   Array com Help
	"BT"															,;	// [06]  C   Tipo do campo
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

	oStruSD2:AddField(	"D2_ZDESCB1"												,;	// [01]  C   Nome do Campo
	"04"																			,;	// [02]  C   Ordem
	"Descricao"																		,;	// [03]  C   Titulo do campo//"Descricao"
	"Descricao"																		,;	// [04]  C   Descricao do campo//"Descricao"
	NIL																				,;	// [05]  A   Array com Help
	"C"																				,;	// [06]  C   Tipo do campo
	""																				,;	// [07]  C   Picture
	NIL																				,;	// [08]  B   Bloco de Picture Var
	NIL																				,;	// [09]  C   Consulta F3
	.F.																				,;	// [10]  L   Indica se o campo � alteravel
	NIL																				,;	// [11]  C   Pasta do campo
	NIL																				,;	// [12]  C   Agrupamento do campo
	NIL																				,;	// [13]  A   Lista de valores permitido do campo (Combo)
	NIL																				,;	// [14]  N   Tamanho maximo da maior opcao do combo
	NIL																				,;	// [15]  C   Inicializador de Browse
	.T.																				,;	// [16]  L   Indica se o campo � virtual
	NIL																				,;	// [17]  C   Picture Variavel
	NIL																				)	// [18]  L   Indica pulo de linha apos o campo

	oView:SetModel( oModel )

	oView:AddField( 'VIEW_ZAV', oStruZAV, 'ZAVMASTER' )
	oView:AddGrid( 'VIEW_SD2', oStruSD2, 'SD2DETAIL' )
	oView:AddGrid( 'VIEW_ZAW', oStruZAW, 'ZAWDETAIL' )
	oView:AddGrid( 'VIEW_ZAX', oStruZAX, 'ZAXDETAIL' )

	oModel:GetModel( 'SD2DETAIL' ):SetOnlyQuery( .T. )

	oView:CreateHorizontalBox( 'RAMI'		, 25 )
	oView:CreateHorizontalBox( 'NOTA'		, 25 )
	oView:CreateHorizontalBox( 'OCORRENCIA'	, 25 )
	oView:CreateHorizontalBox( 'RESOLUCAO'	, 25 )

	oView:SetOwnerView( 'VIEW_ZAV', 'RAMI' )
	oView:SetOwnerView( 'VIEW_SD2', 'NOTA' )
	oView:SetOwnerView( 'VIEW_ZAW', 'OCORRENCIA' )
	oView:SetOwnerView( 'VIEW_ZAX', 'RESOLUCAO' )

	//Habilitando titulo
	oView:EnableTitleView('ZAVMASTER','RAMI')
	oView:EnableTitleView('SD2DETAIL','Itens da Nota')
	oView:EnableTitleView('ZAWDETAIL','Ocorr�ncias')
	oView:EnableTitleView('ZAXDETAIL','Resolu��o')

	oStruZAV:SetProperty(_cAlias + '_COMERC'	, MVC_VIEW_CANCHANGE	, .T.)
	oStruZAV:SetProperty(_cAlias + '_QUALID'	, MVC_VIEW_CANCHANGE	, .T.)
	oStruZAV:SetProperty(_cAlias + '_EXPEDI'	, MVC_VIEW_CANCHANGE	, .T.)
	oStruZAV:SetProperty(_cAlias + '_PCP'		, MVC_VIEW_CANCHANGE	, .T.)
	oStruZAV:SetProperty(_cAlias + '_TRANSP'	, MVC_VIEW_CANCHANGE	, .T.)

	oStruSD2:SetProperty('*'			, MVC_VIEW_CANCHANGE	, .F.)
	oStruSD2:SetProperty('D2_ZCRITIC'	, MVC_VIEW_CANCHANGE	, .T.)

	oStruZAW:SetProperty('ZAW_ID'		, MVC_VIEW_ORDEM		, '002' )
	oStruZAW:SetProperty('*'			, MVC_VIEW_CANCHANGE	, .F.)
	oStruZAW:SetProperty('ZAW_QTD'		, MVC_VIEW_CANCHANGE	, .T.)
	oStruZAW:SetProperty('ZAW_PRECO'	, MVC_VIEW_CANCHANGE	, .T.)
	oStruZAW:SetProperty('ZAW_DIRECI'	, MVC_VIEW_CANCHANGE	, .T.)
	oStruZAW:SetProperty('ZAW_MTDES'	, MVC_VIEW_CANCHANGE	, .T.)
	oStruZAW:SetProperty('ZAW_OBS'		, MVC_VIEW_CANCHANGE	, .T.)
	oStruZAW:SetProperty('ZAW_STATUS'	, MVC_VIEW_CANCHANGE	, .T.)
	oStruZAW:SetProperty('ZAW_RESOLU'	, MVC_VIEW_CANCHANGE	, .T.)

	oStruZAX:SetProperty('ZAX_ID'		, MVC_VIEW_ORDEM		, '001')
	oStruZAX:SetProperty('*'			, MVC_VIEW_CANCHANGE	, .F.)
	oStruZAX:SetProperty('ZAX_QTD'		, MVC_VIEW_CANCHANGE	, .T.)
	oStruZAX:SetProperty('ZAX_PRECO'	, MVC_VIEW_CANCHANGE	, .T.)

	oView:AddIncrementField('VIEW_ZAW', 'ZAW_ID' )

return oView

//--------------------------------------------------------
// Se a ocorrencia ja tiver sido direcionada para algum 
// usuario nao deixa direcionar novamente
//--------------------------------------------------------
user function vldDirec()
	Local lRet			:= .T.
	Local cQryZAX		:= ""
	Local nI			:= 0
	Local oModel 		:= FWModelActive()
	Local oModelZAW		:= oModel:GetModel('ZAWDETAIL')
	Local oModelZAX		:= oModel:GetModel('ZAXDETAIL')
	Local aSaveLines	:= FWSaveRows()

	for nI := 1 to oModelZAX:Length()
		if oModelZAX:getValue("ZAX_NOTA", nI) == oModelZAW:getValue("ZAW_NOTA") .and.;
				oModelZAX:getValue("ZAX_SERIE", nI) == oModelZAW:getValue("ZAW_SERIE") .and.;
				oModelZAX:getValue("ZAX_ITEMNF", nI) == oModelZAW:getValue("ZAW_ITEMNF")

			if !chkStatZAX(oModelZAX:getValue("ZAX_NOTA", nI), oModelZAX:getValue("ZAX_ITEMNF", nI), oModelZAX:getValue("ZAX_SERIE", nI))
				lRet := .F.
			endif

		endif
	next

	FWRestRows( aSaveLines )
return lRet

//--------------------------------------------------------
// Verifica se o item ja esta direcionado
// verifica no banco para permitir o usuario responsavel 
// pelo direcionamento trocar em tela antes da gravacao
//--------------------------------------------------------
static function chkStatZAX(cNotaZAX, cSerieZAX, cItemZAX)
	Local lChkZAX	:= .T.
	Local cQryZAX	:= ""

	cQryZAX := "SELECT *"
	cQryZAX += " FROM " + retSQLName("ZAX") + " ZAX"
	cQryZAX += " WHERE"
	cQryZAX += " 		ZAX.ZAX_ITEMNF	=	'" + cItemZAX		+ "'"
	cQryZAX += " 	AND	ZAX.ZAX_SERIE	=	'" + cSerieZAX		+ "'"
	cQryZAX += " 	AND	ZAX.ZAX_NOTA	=	'" + cNotaZAX		+ "'"
	cQryZAX += " 	AND	ZAX.ZAX_FILIAL	=	'" + xFilial("ZAX")	+ "'"
	cQryZAX += " 	AND	ZAX.D_E_L_E_T_	=	' '"

	tcQuery cQryZAX New Alias "QRYZAX"

	if !QRYZAX->(EOF())
		lChkZAX := .F.
	endif

	QRYZAX->(DBCloseArea())
return lChkZAX

//--------------------------------------------------------
// Nao  permite alterar o cabecalho da RAMI
//--------------------------------------------------------
user function chkAlt()
	Local lRet		:= .T.
	Local oModel	:= FWModelActive()
	Local nOper		:= oModel:getOperation()

	if nOper == MODEL_OPERATION_UPDATE
		lRet := .F.
	endif

return lRet

//--------------------------------------------------------
// Nao  permite alterar o cabecalho da RAMI
//--------------------------------------------------------
user function chkAlt2()
	Local lRet		:= .T.
	Local oModel	:= FWModelActive()
	Local nOper		:= oModel:getOperation()

	if nOper == MODEL_OPERATION_UPDATE .AND. &(_cAlias + '_STATUS')=="1"
		lRet := .F.
	endif

return lRet
//--------------------------------------------------------
// Valida se o usuario pode alterar a resolucao
//--------------------------------------------------------
user function vldResol()
	Local lRet			:= .T.
	Local cQryZAX		:= ""
	Local nI			:= 0
	Local oModel 		:= FWModelActive()
	Local oModelZAV		:= oModel:GetModel('ZAVMASTER')
	Local oModelZAW		:= oModel:GetModel('ZAWDETAIL')
	Local oModelZAX		:= oModel:GetModel('ZAXDETAIL')
	Local aSaveLines	:= FWSaveRows()

	if  oModelZAV:getValue("ZAV_STATUS") == "1"
		lRet := .F.
	else
		for nI := 1 to oModelZAW:Length()
			if oModelZAX:getValue("ZAX_NOTA") == oModelZAW:getValue("ZAW_NOTA", nI) .and.;
					oModelZAX:getValue("ZAX_SERIE") == oModelZAW:getValue("ZAW_SERIE", nI) .and.;
					oModelZAX:getValue("ZAX_ITEMNF") == oModelZAW:getValue("ZAW_ITEMNF", nI)

				if allTrim(getUsrZAU(oModelZAW:getValue("ZAW_DIRECI", nI))) <> allTrim(retCodUsr())
					if allTrim(retCodUsr()) <> allTrim(oModelZAV:getValue("ZAV_CODUSR"))
						lRet := .F.
					endif
				endif

			endif
		next

	endif
	FWRestRows( aSaveLines )
return lRet

//--------------------------------------------------------
//--------------------------------------------------------
static function getUsrZAU(cZAWDir)
	Local cUsrZAU := ""

	cUsrZAU := "SELECT ZAU_USUARI"
	cUsrZAU += " FROM " + retSQLName("ZAU") + " ZAU"
	cUsrZAU += " WHERE"
	cUsrZAU += " 		ZAU.ZAU_CODIGO	=	'" + cZAWDir		+ "'"
	cUsrZAU += " 	AND	ZAU.ZAU_FILIAL	=	'" + xFilial("ZAU")	+ "'"
	cUsrZAU += " 	AND	ZAU.D_E_L_E_T_	<>	'*'"

	tcQuery cUsrZAU New Alias "QRYZAU"

	if !QRYZAU->(EOF())
		cUsrZAU := QRYZAU->ZAU_USUARI
	endif

	QRYZAU->(DBCloseArea())

return cUsrZAU

//--------------------------------------------------------
//--------------------------------------------------------
user function gatilNota(cRet)
	Local lRet			:= .T.
	Local oModel 		:= FWModelActive()
	Local oModelCab		:= oModel:GetModel('ZAVMASTER')
	Local cNota			:= oModelCab:getValue("ZAV_NOTA")
	Local cSerie		:= oModelCab:getValue("ZAV_SERIE")

	private cAlias		:= nil

	if empty(cNota) .or. empty(cSerie)
		lRet	:= .F.
		Help( ,, 'MGFCRM05',, 'Nota e/ou serie inv�lida(s).', 1, 0 )
	else
		cAlias := getItensNF(cNota, cSerie)
		if (cAlias)->(!eof())
			carregaItensNF()
		else
			Help( ,, 'MGFCRM05',, 'Nota e/ou serie nao Localizada(s).', 1, 0 )
		endif
		(cAlias)->(dbCloseArea())
	endif
return cRet

/*
*	Funcao respons�vel pelo retorno dos itens da NF.
*/
static function getItensNF(cNota, cSerie)
	Local _cQuery	:= ""
	Local cAlias	:= getNextAlias()
	Local lRet		:= .T.

	if M->ZAV_TPFLAG <> '1'
		_cQuery := "SELECT D2_ITEM, D2_COD, D2_QUANT, D2_DOC, D2_SERIE, D2_TOTAL, D2_PRCVEN, D2_DESCZFR, B1_DESC,"	+ CRLF

		_cQuery += " D2_QUANT - ("											+ CRLF
		_cQuery += " SELECT COALESCE(SUM(ZAW_QTD),0)"						+ CRLF
		_cQuery += " FROM "	+ retSqlName("ZAW") + " ZAW"					+ CRLF
		_cQuery += " WHERE"													+ CRLF
		_cQuery += " 		SD2.D2_ITEM		= ZAW.ZAW_ITEMNF"				+ CRLF
		_cQuery += " 	AND	SD2.D2_SERIE	= ZAW.ZAW_SERIE"				+ CRLF
		_cQuery += " 	AND	SD2.D2_DOC		= ZAW.ZAW_NOTA"					+ CRLF
		_cQuery += "	AND	ZAW.ZAW_FILIAL	= '" + xFilial("ZAW")	+ "' "	+ CRLF
		_cQuery += "	AND ZAW.D_E_L_E_T_	<>	'*'"						+ CRLF
		_cQuery += " ) QTDDISPO"											+ CRLF

		_cQuery += " FROM "			+ retSqlName("SD2") + " SD2"			+ CRLF
		_cQuery += " INNER JOIN "	+ retSqlName("SB1") + " SB1"			+ CRLF
		_cQuery += " ON SD2.D2_COD = SB1.B1_COD"							+ CRLF
		_cQuery += " WHERE "												+ CRLF
		_cQuery += "		SD2.D2_SERIE	= '" + cSerie			+ "' "	+ CRLF
		_cQuery += "	AND	SD2.D2_DOC 		= '" + cNota			+ "' "	+ CRLF
		_cQuery += "	AND	SB1.B1_FILIAL	= '" + xFilial("SB1")	+ "' "	+ CRLF
		_cQuery += "	AND	SD2.D2_FILIAL	= '" + xFilial("SD2")	+ "' "	+ CRLF
		_cQuery += "	AND SB1.D_E_L_E_T_	<>	'*'"						+ CRLF
		_cQuery += "	AND SD2.D_E_L_E_T_	<>	'*'"						+ CRLF

		_cQuery += "	GROUP BY"											+ CRLF
		_cQuery += "	SD2.D2_ITEM		, SD2.D2_COD	,"					+ CRLF
		_cQuery += "	SD2.D2_QUANT	, SD2.D2_DOC	,"					+ CRLF
		_cQuery += "	SD2.D2_SERIE	, SD2.D2_TOTAL	,"					+ CRLF
		_cQuery += "	SD2.D2_PRCVEN	, D2_DESCZFR	, B1_DESC"			+ CRLF
		_cQuery += "	HAVING"												+ CRLF
		_cQuery += "	("													+ CRLF
		_cQuery += "		SD2.D2_QUANT -"									+ CRLF
		_cQuery += "		("												+ CRLF
		_cQuery += "			SELECT COALESCE(SUM(ZAW_QTD),0) "			+ CRLF
		_cQuery += " 		FROM " + retSqlName("ZAW") + " ZAW"				+ CRLF
		_cQuery += "			WHERE "										+ CRLF
		_cQuery += "				ZAW.ZAW_ITEMNF	=	SD2.D2_ITEM"		+ CRLF
		_cQuery += "			AND ZAW.ZAW_SERIE	=	SD2.D2_SERIE"		+ CRLF
		_cQuery += "			AND ZAW.ZAW_NOTA	=	SD2.D2_DOC"			+ CRLF
		_cQuery += "			AND ZAW.ZAW_FILIAL	=	'" + xFilial("ZAW")	+ "' "	+ CRLF
		_cQuery += "			AND ZAW.D_E_L_E_T_	<>	'*'"				+ CRLF
		_cQuery += "		)"												+ CRLF
		_cQuery += "	) > 0"												+ CRLF
		_cQuery += "	ORDER BY D2_ITEM"									+ CRLF
	else

		_cQuery := "SELECT D2_ITEM, D2_COD, D2_QUANT , D2_DOC, D2_SERIE, D2_TOTAL, D2_PRCVEN, D2_DESCZFR, B1_DESC,"	+ CRLF

		_cQuery += " D2_QUANT  QTDDISPO"									+ CRLF

		_cQuery += " FROM "			+ retSqlName("SD2") + " SD2"		+ CRLF
		_cQuery += " INNER JOIN "	+ retSqlName("SB1") + " SB1"		+ CRLF
		_cQuery += " ON SD2.D2_COD = SB1.B1_COD"							+ CRLF
		_cQuery += " WHERE "												+ CRLF
		_cQuery += "		SD2.D2_SERIE	= '" + cSerie			+ "' "	+ CRLF
		_cQuery += "	AND	SD2.D2_DOC 		= '" + cNota			+ "' "	+ CRLF
		_cQuery += "	AND	SB1.B1_FILIAL	= '" + xFilial("SB1")	+ "' "	+ CRLF
		_cQuery += "	AND	SD2.D2_FILIAL	= '" + xFilial("SD2")	+ "' "	+ CRLF
		_cQuery += "	AND SB1.D_E_L_E_T_	<>	'*'"							+ CRLF
		_cQuery += "	AND SD2.D_E_L_E_T_	<>	'*'"							+ CRLF

		_cQuery += "	GROUP BY"											+ CRLF
		_cQuery += "	SD2.D2_ITEM		, SD2.D2_COD	,"					+ CRLF
		_cQuery += "	SD2.D2_QUANT	, SD2.D2_DOC	,"					+ CRLF
		_cQuery += "	SD2.D2_SERIE	, SD2.D2_TOTAL	,"					+ CRLF
		_cQuery += "	SD2.D2_PRCVEN	, D2_DESCZFR	, B1_DESC"			+ CRLF
		_cQuery += "	ORDER BY D2_ITEM"									+ CRLF

	endif
	//MemoWrite("C:\TEMP\MGFCRM05_getItensNF.SQL", _cQuery)

	_cQuery := ChangeQuery(_cQuery)

	tcQuery _cQuery New Alias (cAlias)

	If (CALIAS)->(EOF())
		MsgAlert('NF j� possui RAMI vinculada a todos os seus itens!')
	EndIf
return cAlias

/*
*	Funcao respons�vel pela carga dos itens da NF.
*/
static function carregaItensNF()
	Local oModel 		:= FWModelActive()
	Local oView 		:= nil
	Local nOper			:= oModel:getOperation()
	Local oModelGrid	:= nil
	Local lRet			:= .T.

	if nOper == MODEL_OPERATION_INSERT
		oModelGrid	:= oModel:GetModel('SD2DETAIL')
		oModelGrid:GoLine(1)

		(cAlias)->(DBGoTop())

		while (cAlias)->(!eof())
			oModelGrid:loadValue("D2_ZCRITIC"	, "MAIS.PNG"				)
			oModelGrid:LoadValue("D2_ITEM"		, (cAlias)->D2_ITEM			)
			oModelGrid:LoadValue("D2_COD"		, (cAlias)->D2_COD			)
			oModelGrid:LoadValue("D2_QUANT"		, (cAlias)->QTDDISPO		)
			oModelGrid:LoadValue("D2_DOC"		, (cAlias)->D2_DOC			)
			oModelGrid:LoadValue("D2_SERIE"		, (cAlias)->D2_SERIE		)
			oModelGrid:LoadValue("D2_PRCVEN"	, ( ( (cAlias)->D2_TOTAL + (cAlias)->D2_DESCZFR ) / D2_QUANT ) )
			//oModelGrid:LoadValue("D2_TOTAL"		, (cAlias)->D2_TOTAL + (cAlias)->D2_DESCZFR )
			oModelGrid:LoadValue("D2_TOTAL"		, (cAlias)->D2_TOTAL 	)
			oModelGrid:LoadValue("D2_ZDESCB1"	, (cAlias)->B1_DESC		)

			(cAlias)->(DBSkip())
			if (cAlias)->(!EOF())
				oModelGrid:AddLine(.T.)
			endif
		enddo
		oModelGrid:GoLine(1)

		oView := FWViewActive()
		oView:refresh()
	endif
return lRet

//--------------------------------------------------------
//--------------------------------------------------------
user function sd2ADD(xRet)
	Local nI			:= 0
	Local oModel 		:= FWModelActive()
	Local oMdlGrid		:= oModel:GetModel('SD2DETAIL')
	Local oMdlZAW		:= oModel:GetModel('ZAWDETAIL')
	//Local aSaveLines	:= FWSaveRows()
	Local nQtdDispo		:= 0
	Local nQtdUtil		:= 0

	// Caso precise enxergar as qtdes em outras RAMIs sera necessario rodar a query
	//nQtdDispo := getQtdIt(oMdlGrid:getValue("D2_DOC"), oMdlGrid:getValue("D2_SERIE"), oMdlGrid:getValue("D2_ITEM"), 1)
	nQtdDispo := oMdlGrid:getValue("D2_QUANT")

	if nQtdDispo > 0
		for nI := 1 to oMdlZAW:Length()
			oMdlZAW:goLine( nI )
			if allTrim( oMdlGrid:getValue("D2_ITEM") ) == allTrim( oMdlZAW:getValue("ZAW_ITEMNF") ) //.and. !oMdlZAW:isDeleted()
				nQtdUtil += oMdlZAW:getValue("ZAW_QTD")
			endif
		next

		nQtdDispo := (nQtdDispo - nQtdUtil)
		if nQtdDispo <= 0
			msgAlert("Este item nao possui quantidade disponivel.")
			return xRet
		endif
	else
		msgAlert("Este item nao possui quantidade disponivel.")
	endif

	// INSERE OCORRENCIA
	oMdlZAW:goLine( oMdlZAW:Length() )

	if !empty(oMdlZAW:getValue("ZAW_CDPROD"))
		oMdlZAW:addLine(.T.)
	endif

	oMdlZAW:loadValue("ZAW_PRECO"	,oMdlGrid:getValue("D2_PRCVEN")		)

	oMdlZAW:loadValue("ZAW_TOTAL"	, oMdlGrid:getValue("D2_PRCVEN") * nQtdDispo		)

	// TESTE
	oMdlZAW:loadValue("ZAW_DESCPR"	,oMdlGrid:getValue("D2_ZDESCB1")	)

	oMdlZAW:loadValue("ZAW_CDPROD"	,oMdlGrid:getValue("D2_COD")	)
	oMdlZAW:loadValue("ZAW_QTD"		,nQtdDispo						)
	oMdlZAW:loadValue("ZAW_NOTA"		,oMdlGrid:getValue("D2_DOC")	)
	oMdlZAW:loadValue("ZAW_SERIE"	,oMdlGrid:getValue("D2_SERIE")	)
	oMdlZAW:loadValue("ZAW_ITEMNF"	,oMdlGrid:getValue("D2_ITEM")	)

	//FWRestRows( aSaveLines )

	/*oView := FWViewActive()
	oView:refresh()*/
return xRet

//----------------------------------------------
//----------------------------------------------
user function quantOco(nZAWQuant)
	Local oModel 		:= FWModelActive()
	Local oMdlGrid		:= oModel:GetModel('SD2DETAIL')
	Local oMdlZAW		:= oModel:GetModel('ZAWDETAIL')
	Local oMdlZAX		:= oModel:GetModel('ZAXDETAIL')
	Local oView			:= nil
	Local aSaveLines	:= FWSaveRows()

	for nI := 1 to oMdlZAX:Length()
		oMdlZAX:goLine( nI )
		if oMdlZAX:getValue("ZAX_ID") == oMdlZAW:getValue("ZAW_ID")
			oMdlZAX:setValue("ZAX_QTD", oMdlZAW:getValue("ZAW_QTD")	)
			oMdlZAX:SetValue("ZAX_TOTAL"	, oMdlZAW:getValue("ZAW_QTD") * oMdlZAW:getValue("ZAW_PRECO"))
		endif
	next

	// Atualiza total da ZAW
	oMdlZAW:SetValue("ZAW_TOTAL"	, nZAWQuant * oMdlZAW:getValue("ZAW_PRECO"))

	FWRestRows( aSaveLines )

	oView := FWViewActive()
	oView:refresh()
return nZAWQuant

//----------------------------------------------
//----------------------------------------------
user function trgZAW(nZAWValue, nType)
	Local oModel 		:= FWModelActive()
	Local oMdlGrid		:= oModel:GetModel('SD2DETAIL')
	Local oMdlZAW		:= oModel:GetModel('ZAWDETAIL')
	Local oMdlZAX		:= oModel:GetModel('ZAXDETAIL')
	Local oView			:= nil
	Local aSaveLines	:= FWSaveRows()

	for nI := 1 to oMdlZAX:Length()
		oMdlZAX:goLine( nI )
		if oMdlZAX:getValue("ZAX_ID") == oMdlZAW:getValue("ZAW_ID")
			if nType == 1
				oMdlZAX:setValue("ZAX_QTD"		, oMdlZAW:getValue("ZAW_QTD")	)
				oMdlZAX:SetValue("ZAX_TOTAL"	, oMdlZAW:getValue("ZAW_QTD") * oMdlZAW:getValue("ZAW_PRECO"))
			elseif nType == 2
				oMdlZAX:setValue("ZAX_PRECO"	, oMdlZAW:getValue("ZAW_PRECO")	)
				oMdlZAX:SetValue("ZAX_TOTAL"	, oMdlZAW:getValue("ZAW_QTD") * oMdlZAW:getValue("ZAW_PRECO"))
			endif
		endif
	next

	// Atualiza total da ZAW
	oMdlZAW:SetValue("ZAW_TOTAL"	, oMdlZAW:getValue("ZAW_QTD") * oMdlZAW:getValue("ZAW_PRECO"))

	FWRestRows( aSaveLines )

	oView := FWViewActive()
	oView:refresh()
return nZAWValue

user function stsZAW()
	Local oModel 		:= FWModelActive()
	Local oMdlGrid		:= oModel:GetModel('SD2DETAIL')
	Local oMdlZAW		:= oModel:GetModel('ZAWDETAIL')
	Local oMdlZAX		:= oModel:GetModel('ZAXDETAIL')
	Local oView			:= nil
	Local aSaveLines	:= FWSaveRows()
	local _cUser		:=	''


	// Atualiza Log de usuario da ZAW
	_cUser	:=	ALLTRIM(cUserName) + '-' + DTOC(dDataBase) + '-' + left(time(), 5)
	oMdlZAW:SetValue("ZAW_LOGUSR", _cUser)
	// FWRestRows( aSaveLines )

	oView := FWViewActive()
	oView:refresh()
return _cUser

//----------------------------------------------
//----------------------------------------------
user function getDirec(cDirec, nTipo)
	Local cRetZAU	:= ""
	Local cQryZAU	:= ""

	cQryZAU += "SELECT ZAU_MOTIVO, ZAU_JUSTIF"
	cQryZAU += " FROM " + retSQLName("ZAU") + " ZAU"
	cQryZAU += " WHERE"
	cQryZAU += " 		ZAU.ZAU_CODIGO	=	'" + cDirec			+ "'"
	cQryZAU += " 	AND	ZAU.ZAU_FILIAL	=	'" + xFilial("ZAU") + "'"
	cQryZAU += " 	AND	ZAU.D_E_L_E_T_	<>	'*'"

	tcQuery cQryZAU New Alias "QRYZAU"

	if !QRYZAU->(EOF())
		if nTipo == 1
			cRetZAU := QRYZAU->ZAU_MOTIVO
		elseif nTipo == 2
			cRetZAU := QRYZAU->ZAU_JUSTIF
		endif
	else
		msgAlert("Nao  encontrado o codigo do direcionamento.")
	endif

	QRYZAU->(DBCloseArea())
return cRetZAU

//----------------------------------------------
//----------------------------------------------
user function MDLCRM05()
	Local lAllAprov		:= .T.
	Local nI			:= 1
	Local cPara			:= ""
	Local cCorpo		:= ""
	Local xRet			:= .T.
	Local cParam		:= If(Type("ParamIxb") = "A",ParamIxb[2],If(Type("ParamIxb") = "C",ParamIxb,""))
	Local oModel		:= FWModelActive()
	Local oMdlZAV		:= nil
	Local oModelZAX		:= ParamIxb[1]:getModel( 'ZAXDETAIL')
	Local nOperation	:= oModelZAX:GetOperation()
	Local cCdRami		:= ""
	Local nQtdZAW		:= 0
	Local nQtdZAX		:= 0
	Local aOcorre		:= {}
	Local aResolu		:= {}
	Local cItemAtu		:= ""
	Local lDel 			:= ""
	Local _cQuery		:= ""
	Local cAliasSD1e	:= ""

	If ParamIxb[2] == 'MODELVLDACTIVE' .and. nOperation == MODEL_OPERATION_UPDATE
		If ZAV->ZAV_STATUS ==  "1" //inicio Alteracao Rafael
			If Select("QRYZAU")   > 0
				QRYZAU->(DBCLOSEAREA())
			endif
			_cQuery := " SELECT ZAU.* FROM "
			_cQuery +=  RetSqlName("ZAU")+" ZAU "
			_cQuery += " INNER JOIN " +  RetSqlName("ZAW")+" ZAW "
			_cQuery += " ON	ZAW.ZAW_DIRECI=ZAU.ZAU_CODIGO"
			_cQuery += " INNER JOIN " +  RetSqlName("ZAV")+" ZAV "
			_cQuery += " ON ZAV.ZAV_SERIE=ZAW.ZAW_SERIE AND	ZAV.ZAV_NOTA=ZAW.ZAW_NOTA AND  ZAV.ZAV_CODIGO = ZAW.ZAW_CDRAMI "
			_cQuery += " WHERE ZAV_CODIGO	=	'"+ZAV->ZAV_CODIGO+"'"
			_cQuery += " AND	ZAU.ZAU_FILIAL	=	'"+XFILIAL("ZAU")+"'"
			_cQuery += " AND	ZAW.ZAW_FILIAL	=	'"+XFILIAL("ZAU")+"'"
			_cQuery += " AND	ZAV.ZAV_FILIAL	=	'"+XFILIAL("ZAU")+"'"
			_cQuery += " AND	ZAU.D_E_L_E_T_	<>	'*'	"
			_cQuery += " AND	ZAW.D_E_L_E_T_	<>	'*'	"
			_cQuery += " AND	ZAV.D_E_L_E_T_	<>	'*'	"

			tcQuery _cQuery New Alias "QRYZAU"

			while QRYZAU->(!eof())
				if retCodUsr()==ALLTRIM(QRYZAU->ZAU_USUARI)
					QRYZAU->(DBCLOSEAREA())
					return .T.
				ELSE
					FOR i:=0 to 9

						If Select("QRYSYS")   > 0
							QRYSYS->(DBCLOSEAREA())
						endif
						if  ALLTRIM(&("QRYZAU->ZAU_EMAIL"+alltrim(STR(i))))<>''

							_cQuery := " SELECT USR_ID FROM SYS_USR "
							_cQuery += " WHERE USR_EMAIL  LIKE '%" + ALLTRIM(&("QRYZAU->ZAU_EMAIL"+alltrim(STR(i))))+ "%'"
							tcQuery _cQuery New Alias "QRYSYS"

							if QRYSYS->(!EOF()) .AND. retCodUsr()==ALLTRIM(QRYSYS->USR_ID)
								QRYZAU->(DBCLOSEAREA())
								QRYSYS->(DBCLOSEAREA())
								return .T.
							endif
						endif
					next
					If Select("QRYSYS")   > 0
						QRYSYS->(DBCLOSEAREA())
					endif
				endif
				QRYZAU->(DBSkip())
			ENDdo
			If Select("QRYZAU")   > 0
				QRYZAU->(DBCLOSEAREA())
			endif
			If Select("QRYSYS")   > 0
				QRYSYS->(DBCLOSEAREA())
			endif
			Help( ,, 'MGFCRM05',, 'Processo finalizado. Nao e possivel alterar.', 1, 0 )
			return .F.
		else //fim alteracao Rafael
			return .T.
		endif
	Elseif ParamIxb[2] == 'MODELVLDACTIVE' .and. nOperation == MODEL_OPERATION_DELETE
		lRet := MsgYesNo('Deseja relamente reabrir essa RAMI?')

		If lRet

			cAliasSD1e := GetNextAlias()

			_cQuery := " SELECT D1_FILIAL FROM "
			_cQuery +=  RetSqlName("SD1")+" SD1 "
			_cQuery += " WHERE D1_FILIAL  ='" + XFILIAL("SD1") + "'"
			_cQuery += " AND   D1_ZRAMI   ='" + ZAV->ZAV_CODIGO  + "'"
			_cQuery += " AND   SD1.D_E_L_E_T_ <>'*' "

			_cQuery := ChangeQuery(_cQuery)

			dbUseArea( .T., "TOPCONN", TCGENQRY(,,_cQuery),cAliasSD1e, .F., .T.)

			If (cAliasSD1e)->(!eof())

				MsgAlert('RAMI nao pode ser excluida! H� processos vinculados a essa RAMI')

				Return .F.
			Else
				Return .T.
			EndIf
		Else
			Return lRet
		EndIf
	EndIf

	if cParam == "MODELCOMMITNTTS" .and. nOperation <> MODEL_OPERATION_DELETE
		oMdlZAV		:= oModel:GetModel('ZAVMASTER')
		oModelZAW	:= oModel:GetModel('ZAWDETAIL')
		oModelZAX	:= oModel:GetModel('ZAXDETAIL')

		aOcorre	:= {}
		for nI := 1 to oModelZAW:length()
			if !oModelZAW:isDeleted()
				aadd( aOcorre, { oModelZAW:getValue("ZAW_ITEMNF", nI) , oModelZAW:getValue("ZAW_QTD", nI) } )
			endif
		next

		aOcorre := aSort( aOcorre, , , { | x,y | x[ 1 ] < y[ 1 ] } )

		aResolu := {}
		for nI := 1 to oModelZAX:length()
			if !oModelZAX:isDeleted()
				aadd( aResolu, { oModelZAX:getValue("ZAX_ITEMNF", nI) , oModelZAX:getValue("ZAX_QTD", nI) } )
			endif
		next

		if len(aResolu) > 0
			aResolu := aSort( aResolu, , , { | x , y | x[ 1 ] < y[ 1 ] } )

			lQtdOk		:= .F. // verificar
			cItemAtu	:= aOcorre[ 1, 1 ]
			nQtdZAW		:= 0

			nI := 1
			while nI <= len( aOcorre )
				if cItemAtu	<> aOcorre[ nI, 1 ]
					nQtdZAX := 0
					nJ := 1
					while nJ <= len( aResolu )
						if cItemAtu == aResolu[ nJ, 1 ]
							nQtdZAX += aResolu[ nJ, 2 ]
						endif
						nJ++
					enddo

					if nQtdZAX <> nQtdZAW
						lQtdOk := .F.
						exit
					endif

					nQtdZAW		:= 0
					cItemAtu	:= aOcorre[ nI, 1 ]
				else
					nQtdZAW += aOcorre[ nI, 2 ]
					nI++
				endif
			enddo

			if lQtdOk
				recLock("ZAV", .F.)
				ZAV->ZAV_STATUS := "1"
				ZAV->(msUnLock())
			endif
		endif

		cPara := ""
		getEmails(@cPara)
		cCdRami		:= allTrim(QRYZAV->ZAV_CODIGO)
		cCorpo		:= ""
		while !QRYZAV->(EOF())
			cCorpo += CRLF + "<P><font face = 'verdana' size='3'>Produto: " + allTrim(QRYZAV->ZAW_CDPROD) + " Quantidade: " + allTrim(str(QRYZAV->ZAW_QTD)) + "  Motivo: " + allTrim(QRYZAV->ZAW_MOTIVO) + " Justificativa: " + allTrim(QRYZAV->ZAW_JUSTIF) + "</font></p>"
			QRYZAV->(DBSkip())
		enddo

		if !empty(cPara)
			EnvMail(cPara, cCorpo, cCdRami)
		endif

		QRYZAV->(DBCloseArea())
	endif

return xRet

//----------------------------------------------
//----------------------------------------------
static function getEmails(cPara)
	Local nI		:= 0
	Local aEmails	:= {}
	Local cQryZAV	:= ""

	cQryZAV += " SELECT ZAU_EMAIL	, ZAU_EMAIL1, ZAU_EMAIL2, ZAU_EMAIL3," + CRLF
	cQryZAV += " 		ZAU_EMAIL4	, ZAU_EMAIL5, ZAU_EMAIL6, ZAU_EMAIL7,"
	cQryZAV += " 		ZAU_EMAIL8	, ZAU_EMAIL9, ZAU_EMAIL0,"
	cQryZAV += " 		ZAV_CODIGO	, ZAW_ITEMNF, ZAW_CDPROD	, ZAW_QTD	, ZAW_MOTIVO, ZAW_JUSTIF, ZAV_PEDIDO, ZAV_ORDRET"	+ CRLF
	cQryZAV += " FROM " + retSQLName("ZAV") + " ZAV"					+ CRLF
	cQryZAV += " INNER JOIN " + retSQLName("ZAW") + " ZAW"				+ CRLF
	cQryZAV += " ON"													+ CRLF
	cQryZAV += " 		ZAV.ZAV_SERIE	=	ZAW.ZAW_SERIE"				+ CRLF
	cQryZAV += " 	AND	ZAV.ZAV_NOTA	=	ZAW.ZAW_NOTA"				+ CRLF
	cQryZAV += " INNER JOIN " + retSQLName("ZAU") + " ZAU"				+ CRLF
	cQryZAV += " ON"													+ CRLF
	cQryZAV += " "														+ CRLF
	cQryZAV += " 	ZAW.ZAW_DIRECI		=	ZAU_CODIGO"					+ CRLF
	cQryZAV += " WHERE"													+ CRLF
	cQryZAV += " 		ZAV_CODIGO		=	'" + ZAV->ZAV_CODIGO+ "'"	+ CRLF
	cQryZAV += " 	AND	ZAU.ZAU_FILIAL	=	'" + xFilial("ZAU") + "'"	+ CRLF
	cQryZAV += " 	AND	ZAW.ZAW_FILIAL	=	'" + xFilial("ZAW") + "'"	+ CRLF
	cQryZAV += " 	AND	ZAV.ZAV_FILIAL	=	'" + xFilial("ZAV") + "'"	+ CRLF
	cQryZAV += " 	AND	ZAU.D_E_L_E_T_	<>	'*'"						+ CRLF
	cQryZAV += " 	AND	ZAW.D_E_L_E_T_	<>	'*'"						+ CRLF
	cQryZAV += " 	AND	ZAV.D_E_L_E_T_	<>	'*'"						+ CRLF
	cQryZAV += " ORDER BY ZAU_EMAIL"									+ CRLF

	tcQuery cQryZAV New Alias "QRYZAV"

	while !QRYZAV->(EOF())
		lAchou := .F.
		for nI := 1 to len(aEmails)
			if aEmails[nI] == allTrim(QRYZAV->ZAU_EMAIL)
				lAchou := .T.
				exit
			endif
		next
		if !lAchou
			aadd(aEmails, allTrim(QRYZAV->ZAU_EMAIL))
		endif

		lAchou := .F.
		for nI := 1 to len(aEmails)
			if aEmails[nI] == allTrim(QRYZAV->ZAU_EMAIL1)
				lAchou := .T.
				exit
			endif
		next
		if !lAchou
			aadd(aEmails, allTrim(QRYZAV->ZAU_EMAIL1))
		endif

		lAchou := .F.
		for nI := 1 to len(aEmails)
			if aEmails[nI] == allTrim(QRYZAV->ZAU_EMAIL2)
				lAchou := .T.
				exit
			endif
		next
		if !lAchou
			aadd(aEmails, allTrim(QRYZAV->ZAU_EMAIL2))
		endif

		lAchou := .F.
		for nI := 1 to len(aEmails)
			if aEmails[nI] == allTrim(QRYZAV->ZAU_EMAIL3)
				lAchou := .T.
				exit
			endif
		next
		if !lAchou
			aadd(aEmails, allTrim(QRYZAV->ZAU_EMAIL3))
		endif

		lAchou := .F.
		for nI := 1 to len(aEmails)
			if aEmails[nI] == allTrim(QRYZAV->ZAU_EMAIL4)
				lAchou := .T.
				exit
			endif
		next
		if !lAchou
			aadd(aEmails, allTrim(QRYZAV->ZAU_EMAIL4))
		endif

		lAchou := .F.
		for nI := 1 to len(aEmails)
			if aEmails[nI] == allTrim(QRYZAV->ZAU_EMAIL5)
				lAchou := .T.
				exit
			endif
		next
		if !lAchou
			aadd(aEmails, allTrim(QRYZAV->ZAU_EMAIL5))
		endif

		lAchou := .F.
		for nI := 1 to len(aEmails)
			if aEmails[nI] == allTrim(QRYZAV->ZAU_EMAIL6)
				lAchou := .T.
				exit
			endif
		next
		if !lAchou
			aadd(aEmails, allTrim(QRYZAV->ZAU_EMAIL6))
		endif

		lAchou := .F.
		for nI := 1 to len(aEmails)
			if aEmails[nI] == allTrim(QRYZAV->ZAU_EMAIL7)
				lAchou := .T.
				exit
			endif
		next
		if !lAchou
			aadd(aEmails, allTrim(QRYZAV->ZAU_EMAIL7))
		endif

		lAchou := .F.
		for nI := 1 to len(aEmails)
			if aEmails[nI] == allTrim(QRYZAV->ZAU_EMAIL8)
				lAchou := .T.
				exit
			endif
		next
		if !lAchou
			aadd(aEmails, allTrim(QRYZAV->ZAU_EMAIL8))
		endif

		lAchou := .F.
		for nI := 1 to len(aEmails)
			if aEmails[nI] == allTrim(QRYZAV->ZAU_EMAIL9)
				lAchou := .T.
				exit
			endif
		next
		if !lAchou
			aadd(aEmails, allTrim(QRYZAV->ZAU_EMAIL9))
		endif

		lAchou := .F.
		for nI := 1 to len(aEmails)
			if aEmails[nI] == allTrim(QRYZAV->ZAU_EMAIL0)
				lAchou := .T.
				exit
			endif
		next
		if !lAchou
			aadd(aEmails, allTrim(QRYZAV->ZAU_EMAIL0))
		endif

		QRYZAV->(DBSkip())
	enddo

	for nI := 1 to len(aEmails)
		if !empty( aEmails[ nI ] )
			cPara += aEmails[nI] + ";"
		endif
	next

	cMailAux := ""
	cMailAux := allTrim( usrRetMail( retCodUsr() ) )

	if !empty( cMailAux )
		cPara += allTrim( cMailAux )
	else
		cPara := subStr(cPara, 1, len(cPara)-1)
	endif

	cMailAux := ""
	cMailAux := getMailVen()

	if !empty(cMailAux)
		cPara += ";" + cMailAux
	endif

	//	If QRYZAV->ZAV_ORDRET == "1"  //0=Nao ,1=Sim ALTERADO RAFAEL
	If ZAV->ZAV_ORDRET == "1"
		cMailAux := ""
		cMailAux := getMailZBK()

		if !empty(cMailAux)
			cPara += ";" + cMailAux
		endif
	EndIf

	QRYZAV->(DBGoTop())
return

//----------------------------------------------
// Retorna email do vendedor
//----------------------------------------------
static function getMailVen()
	Local cRetMail	:= ""
	Local cQrySC5	:= ""

	cQrySC5 := "SELECT C5_NUM, A3_COD, A3_EMAIL"
	cQrySC5 += " FROM "			+ retSQLName("SC5") + " SC5"
	cQrySC5 += " INNER JOIN "	+ retSQLName("SA3") + " SA3"
	cQrySC5 += " ON"
	cQrySC5 += " 		SC5.C5_VEND1	=	SA3.A3_COD"
	cQrySC5 += " 	AND SA3.A3_FILIAL	=	'" + xFilial("SA3") + "'"
	cQrySC5 += " 	AND SA3.D_E_L_E_T_	<>	'*'"
	cQrySC5 += " WHERE"
	cQrySC5 += "		SC5.C5_NUM		=	'" + ZAV->ZAV_PEDIDO	+ "'"
	cQrySC5 += " 	AND SC5.C5_FILIAL	=	'" + xFilial("SC5")		+ "'"
	cQrySC5 += " 	AND SC5.D_E_L_E_T_	<>	'*'"

	tcQuery cQrySC5 New Alias "QRYSC5"

	if !QRYSC5->( EOF() )
		if !empty( QRYSC5->A3_EMAIL )
			cRetMail := allTrim( QRYSC5->A3_EMAIL )
		endif
	endif

	QRYSC5->(DBCloseArea())
return cRetMail

//----------------------------------------------
//----------------------------------------------
static function getMailZBK()
	Local cQryZBK	:= ""
	Local cRetMail	:= ""

	cQryZBK := "SELECT ZBK_CODUSR"
	cQryZBK += " FROM " + retSQLName("ZBK") + " ZBK"
	cQryZBK += " WHERE"
	cQryZBK += " 		ZBK.ZBK_FILIAL	=	'" + xFilial("ZBK") + "'"
	cQryZBK += " 	AND	ZBK.D_E_L_E_T_	<>	'*'"

	tcQuery cQryZBK New Alias "QRYZBK"

	while !QRYZBK->( EOF() )

		if !empty( usrRetMail( QRYZBK->ZBK_CODUSR ) )
			cRetMail += alltrim(usrRetMail( QRYZBK->ZBK_CODUSR )) + ";"
		endif

		QRYZBK->(DBSkip())
	enddo

	cRetMail := subStr(cRetMail, 1, len(cRetMail)-1)

	QRYZBK->(DBCloseArea())
return cRetMail

//----------------------------------------------
//----------------------------------------------
Static Function EnvMail(cPara, cCorpo, cCdRami)

	Local oMail, oMessage
	Local nErro		:= 0
	Local lRetMail 	:= .T.
	Local cSmtpSrv  := GETMV("MGF_SMTPSV")
	Local cCtMail   := GETMV("MGF_CTMAIL")
	Local cPwdMail  := GETMV("MGF_PWMAIL")
	Local nMailPort := GETMV("MGF_PTMAIL")
	Local nParSmtpP := GETMV("MGF_PTSMTP")
	Local nSmtpPort
	Local nTimeOut  := GETMV("MGF_TMOUT")
	Local cEmail    := GETMV("MGF_EMAIL")
	Local cErrMail

	oMail := TMailManager():New()

	if nParSmtpP == 25
		oMail:SetUseSSL( .F. )
		oMail:SetUseTLS( .F. )
		//oMail:Init("", cSmtpSrv, cCtMail, cPwdMail,, nParSmtpP)
		oMail:Init("", cSmtpSrv, "", "",, nParSmtpP)
	elseif nParSmtpP == 465
		nSmtpPort := nParSmtpP
		oMail:SetUseSSL( .T. )
		oMail:Init("", cSmtpSrv, cCtMail, cPwdMail,, nSmtpPort)
	else
		nParSmtpP == 587
		nSmtpPort := nParSmtpP
		oMail:SetUseTLS( .T. )
		oMail:Init("", cSmtpSrv, cCtMail, cPwdMail,, nSmtpPort)
	endif

	oMail:SetSmtpTimeOut( nTimeOut )
	nErro := oMail:SmtpConnect()

	If nErro != 0
		cErrMail :=("ERROR:" + oMail:GetErrorString(nErro))
		conout(cErrMail)
		//Alert(cErrMail)
		oMail:SMTPDisconnect()
		lRetMail := .F.
		Return (lRetMail)
	Endif

	If 	nParSmtpP != 25
		nErro := oMail:SmtpAuth(cCtMail, cPwdMail)
		If nErro != 0
			cErrMail :=("ERROR:" + oMail:GetErrorString(nErro))
			conout(cErrMail)
			oMail:SMTPDisconnect()
			lRetMail := .F.
			Return (lRetMail)
		Endif
	Endif

	oMessage := TMailMessage():New()
	oMessage:Clear()
	oMessage:cFrom                  := cEmail
	oMessage:cTo                    := cPara
	oMessage:cCc                    := ""
	oMessage:cSubject               := "RAMI " + cCdRami
	oMessage:cBody                  := bodyMail(cCorpo, cCdRami)
	nErro := oMessage:Send( oMail )

	if nErro != 0
		cErrMail :=("ERROR:" + oMail:GetErrorString(nErro))
		conout(cErrMail)
		//Alert(cErrMail)
		oMail:SMTPDisconnect()
		lRetMail := .F.
		Return (lRetMail)
	Endif

	conout('Desconectando do SMTP')
	oMail:SMTPDisconnect()

Return

static function bodyMail(cCorpo, cCdRami)
	Local cHtml 	:= ""
	Local cAliasSD2 := ""
	Local cAliasZAW := ""
	Local _cQuery	:= ""
	Local nTotal	:= 0
	Local nValTotal := 0
	Local cEnd 	    := ""
	Local nPerc		:= 0
	Local nCont		:= 0
	Local nPercT	:= 0
	/*
	cHtml := ""
	cHtml += "<HTML>"
	cHtml += "<HEAD>"
	cHtml += "	<META HTTP-EQUIV='CONTENT-TYPE' CONTENT='text/html; charset=utf-8'>"
	cHtml += "	<TITLE></TITLE>"
	cHtml += "	<META NAME='GENERATOR' CONTENT='LibreOffice 4.1.6.2 (Linux)'>"
	cHtml += "	<META NAME='CREATED' CONTENT='0;0'>"
	cHtml += "	<META NAME='CHANGED' CONTENT='0;0'>"
	cHtml += "	<STYLE TYPE='text/html'>"
	cHtml += "	<!--"
	cHtml += "		@page { margin: 0.79in }"
	cHtml += "		P { margin-bottom: 0.08in }"
	cHtml += "		PRE.ctl { font-family: 'arial black', 'avant garde'; font-size: medium; color: #ff0000 }"
	cHtml += "	-->"
	cHtml += "	</STYLE>"
	cHtml += "</HEAD>"
	cHtml += "<BODY LANG='pt-BR' DIR='LTR'>"
	cHtml += "<P><font face = 'verdana' size='5'><strong>RAMI - Relatorio de An�lise de Mercado Interno</strong></font></p>" +CRLF
	cHtml += CRLF+"<P><b><font face = 'verdana' size='3'>Senha do RAMI:" + cCdRami + "</font></b></p>"
	cHtml += CRLF+"<P><b><font face = 'verdana' size='3'>Itens:</font></b></p>"
	cHtml += cCorpo
	cHtml += CRLF+"<P><font face = 'verdana' size='3'>FAVOR INTERAGIR NO ID RAMI MENCIONADO ACIMA.</font></p>"
	cHtml += "</BODY>"
	cHtml += "</HTML>"
	*/
	cAliasZAW := GetNextAlias()

	_cQuery += " SELECT * FROM ZAV010 ZAV, ZAW010 ZAW "

	_cQuery += " WHERE ZAV_FILIAL = '" + XFILIAL("ZAV") + "'"
	_cQuery += " AND ZAV_FILIAL = ZAW_FILIAL "
	_cQuery += " AND ZAV_CODIGO = '" + cCdRami + "'"
	_cQuery += " AND ZAW_CDRAMI = ZAV_CODIGO "
	_cQuery += " AND ZAV.D_E_L_E_T_=' '  "
	_cQuery += " AND ZAW.D_E_L_E_T_=' ' "

	_cQuery := ChangeQuery(_cQuery)

	dbUseArea( .T., "TOPCONN", TCGENQRY(,,_cQuery),cAliasZAW, .F., .T.)

	If (cAliasZAW)->(!eof())

		///posiciona Pedido
		DbSelectArea('SC5')
		DbSetOrder(1)
		SC5->(MsSeek(xFilial('SC5') + (cAliasZAW)->ZAV_PEDIDO ))

		///posiciona vendedor
		DbSelectArea('SA3')
		DbSetOrder(1)
		SA3->(MsSeek(xFilial('SA3') + SC5->C5_VEND1))

		///posiciona Carga
		DbSelectArea('DAI')
		DbSetOrder(6)
		DAI->(MsSeek(xFilial('DAI') + (cAliasZAW)->ZAV_NOTA + (cAliasZAW)->ZAV_SERIE))

		///posiciona Carga
		DbSelectArea('DAK')
		DbSetOrder(1)
		DAK->(MsSeek(xFilial('DAK') + DAI->DAI_COD + DAI->DAI_SEQCAR))

		///posiciona motorista
		DbSelectArea('DA4')
		DbSetOrder(1)
		DA4->(MsSeek(xFilial('DA4') + DAK->DAK_MOTORI ))

		///posiciona Cliente
		DbSelectArea('SA1')
		DbSetOrder(1)
		SA1->(MsSeek(xFilial('SA1') + (cAliasZAW)->ZAV_CLIENTE + (cAliasZAW)->ZAV_LOJA ))

		///posiciona Endereco de entrega
		DbSelectArea('SZ9')
		DbSetOrder(1)//Z9_FILIAL+Z9_ZCLIENT+Z9_ZLOJA+Z9_ZIDEND
		SZ9->(MsSeek(xFilial('SZ9') + SC5->C5_CLIENTE + SC5->C5_LOJACLI + SC5->C5_ZIDEND ))

		///posiciona Nota
		DbSelectArea('SF2')
		DbSetOrder(1)
		SF2->(MsSeek(xFilial('SF2') + (cAliasZAW)->ZAV_NOTA + (cAliasZAW)->ZAV_SERIE))

		cHtml := ""

		cHtml += "<!DOCTYPE html>"
		cHtml += "<html>"
		cHtml += "<head>"
		cHtml += "<style>"
		cHtml += "table {"
		cHtml += "font-family: arial, sans-serif;"
		cHtml += "border-collapse: collapse;"
		cHtml += "width: 100%;"
		cHtml += "}"

		cHtml += "td, th {"
		cHtml += "border: 1px solid #dddddd;"
		cHtml += "text-align: left;"
		cHtml += "padding: 8px;"
		cHtml += "}"


		cHtml += "</style>"
		cHtml += "</head>"
		cHtml += "<body>"

		cHtml += "<table>"
		cHtml += "<tr>"
		cHtml += "<th>Cliente:  " + (cAliasZAW)->ZAV_NMCLI + "</th>"
		cHtml += "<th></th>"

		cHtml += "</tr>"
		cHtml += "<tr>"
		cHtml += "<td>Vendedor:  " + SA3->A3_NOME + "</td>" ///PEGAR NA SC5
		cHtml += "<td></td>"

		cHtml += "</tr>"
		cHtml += "<tr>"
		cHtml += "<td>Administrador:  " + (cAliasZAW)->ZAV_NOMEUS + "</td>"
		cHtml += "<td>Dt.Abertura:  " + DTOC(STOD((cAliasZAW)->ZAV_DTABER)) + "</td>"

		cHtml += "</tr>"
		cHtml += "<tr>"
		cHtml += "<td>Unidade:  " + (cAliasZAW)->ZAV_FILIAL + "</td>"
		cHtml += "<td>Dt.Ocorrencia  " + DTOC(STOD((cAliasZAW)->ZAV_DTABER)) + "</td>"

		cHtml += "</tr>"
		cHtml += "<tr>"
		cHtml += "<td>Pedido:   " + (cAliasZAW)->ZAV_PEDIDO + "</td>"
		cHtml += "<td>Transportadora:  " + (cAliasZAW)->ZAV_NMTRAN + "</td>"

		cHtml += "</tr>"
		cHtml += "<tr>"
		cHtml += "<td>NF Origem: " + (cAliasZAW)->ZAV_NOTA + "</td>"
		cHtml += "<td>Placa:</td>"

		cHtml += "</tr>"
		cHtml += "<tr>"
		cHtml += "<td>Ordem Embarque: " + DAK->DAK_COD + "</td>"
		cHtml += "<td>Motorista: " + DA4->DA4_NOME + "</td>"

		cHtml += "</tr>"
		cHtml += "<tr>"
		cHtml += "<td>No. Entrega:/</td>"
		cHtml += "<td>Fone: " + SA1->A1_TEL + "</td>"

		cHtml += "</tr>"
		cHtml += "<tr>"
		cHtml += "<td>End. Entrega: " + SZ9->Z9_ZENDER + SZ9->Z9_ZBAIRRO + SZ9->Z9_ZMUNIC + ' - ' + SZ9->Z9_ZEST + "</td>"
		cHtml += "<td></td>"

		cHtml += "</tr>"
		cHtml += "</table>"

		cHtml += "</body>"
		cHtml += "</html>"

		// Cabecalho dos Itens

		cHtml += "<HTML>"
		cHtml += "<HEAD>"
		cHtml += " <style> "
		cHtml += " table, th, td { "
		cHtml += "    border: 1px solid black;"

		cHtml += "} "
		cHtml += " th, td {"
		cHtml += " padding: 5px;"
		cHtml += " text-align: left;"
		cHtml += "}"
		cHtml += "</style>"
		cHtml += "</head>"
		cHtml += "<body>"

		cHtml += " <table style='width:100%'> "
		cHtml += " <tr>"

		cHtml += "</tr>"
		cHtml += "<tr>"
		cHtml += "<td>Codigo</td>"
		cHtml += "<td>Descricao</td>"
		cHtml += "<td>Qtd</td>"
		cHtml += "<td>Unid.</td>"
		cHtml += "<td>Valor</td>"
		cHtml += "<td>Motivo</td>"
		cHtml += "<td>Justificativa</td>"
		cHtml += "<td>Qtd %</td>"
		cHtml += "<td>OBS </td>"
		cHtml += "</tr>"

		///Itens do E-mail
		While (cAliasZAW)->(!eof())

			nTotal += (cAliasZAW)->ZAW_QTD
			nValTotal += (cAliasZAW)->ZAW_TOTAL

			cHtml += "</tr>"
			cHtml += "<tr>"
			cHtml += "<td>" + (cAliasZAW)->ZAW_CDPROD + "</td>"
			cHtml += "<td>" + (cAliasZAW)->ZAW_DESCPR + "</td>"
			cHtml += "<td>" + Alltrim(Transform((cAliasZAW)->ZAW_QTD,"@E 99,999,999.99")) + "</td>"
			cHtml += "<td>KILO</td>"
			cHtml += "<td>" +  Alltrim(Transform((cAliasZAW)->ZAW_TOTAL,"@E 99,999,999.99")) + "</td>"
			cHtml += "<td>" + (cAliasZAW)->ZAW_MOTIVO +" </td>"
			cHtml += "<td>" + (cAliasZAW)->ZAW_JUSTIF +"</td>"

			DbSelectArea('SD2')
			DbSetOrder(3) //D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
			SD2->(MsSeek(xFilial('SD2') + (cAliasZAW)->ZAV_NOTA + (cAliasZAW)->ZAV_SERIE + SC5->C5_CLIENTE + SC5->C5_LOJACLI + (cAliasZAW)->ZAW_CDPROD))

			nPerc := ((cAliasZAW)->ZAW_QTD / SD2->D2_QUANT) * 100
			nCont += 1
			nPercT += nPerc

			cHtml += "<td>" +  Alltrim(Transform(nPerc,"@E 99,999,999.99")) + "</td>"
			cHtml += "<td>" + (cAliasZAW)->ZAW_OBS +"</td>"
			//cHtml += "<td></td>"
			cHtml += "</tr>"

			(cAliasZAW)->(DbSkip())
		Enddo

		nPercT := nPercT / nCont

		///Totalizador
		cHtml += "</tr>"
		cHtml += "<tr>"
		cHtml += "<td>TOTAL</td>"
		cHtml += "<td>-------</td>"
		cHtml += "<td>" + Alltrim(Transform(nTotal,"@E 99,999,999.99"))  + "</td>"
		cHtml += "<td>-------</td>"
		cHtml += "<td>" + Alltrim(Transform(nValTotal,"@E 99,999,999.99")) + "</td>"
		cHtml += "<td>" + (cAliasZAW)->ZAW_MOTIVO +" </td>"
		cHtml += "<td>" + (cAliasZAW)->ZAW_JUSTIF +"</td>"
		cHtml += "<td>" +  Alltrim(Transform(nPercT,"@E 99,999,999.99")) + "</td>"
		cHtml += "<td>-------</td>"
		cHtml += "</tr>"

		cHtml += "</table>"

		cHtml += "</body>"
		cHtml += "</html>"


		///tabela totalizador

		cHtml += "<!DOCTYPE html>"
		cHtml += "<html>"
		cHtml += "<head>"
		cHtml += "<style>"
		cHtml += "table { "
		cHtml += "font-family: arial, sans-serif;"
		cHtml += "border-collapse: collapse;"
		cHtml += "width: 100%;"
		cHtml += "}"

		cHtml += "td, th { "
		cHtml += "border: 1px solid #dddddd;"
		cHtml += "text-align: left;"
		cHtml += "padding: 8px;"
		cHtml += "}"


		cHtml += "</style>"
		cHtml += "</head>"
		cHtml += "<body>"

		cHtml += "<table>"
		cHtml += "<tr>"
		cHtml += "<th></th>"
		cHtml += "<th>Qtde</th>"
		cHtml += "<th>Valor</th>"
		cHtml += "</tr>"
		cHtml += "<tr>"
		cHtml += "<th>Total reclamado:</th>"
		cHtml += "<th>" + Alltrim(Transform(nTotal,"@E 99,999,999.99"))    + "</th>"
		cHtml += "<th>" + Alltrim(Transform(nValTotal,"@E 99,999,999.99")) + "</th>"
		cHtml += "</tr>"
		cHtml += "<tr>"

		///Query que retorna o total vendido SD2

		cAliasSD2 := GetNextAlias()


		_cQuery := " SELECT SUM(D2_QUANT)QTD FROM SD2010 SD2 "

		_cQuery += " WHERE D2_FILIAL = '" + XFILIAL("SD2") + "'"
		_cQuery += " AND D2_DOC = '" + SF2->F2_DOC + "'"
		_cQuery += " AND D2_SERIE = '" + SF2->F2_SERIE + "'"
		_cQuery += " AND SD2.D_E_L_E_T_ = ' ' "

		_cQuery := ChangeQuery(_cQuery)

		dbUseArea( .T., "TOPCONN", TCGENQRY(,,_cQuery),cAliasSD2, .F., .T.)

		cHtml += "<th>Total NF:</th>"
		cHtml += "<th>" + Alltrim(Transform((cAliasSD2)->QTD,"@E 99,999,999.99")) + "</th>"
		cHtml += "<th>" + Alltrim(Transform(SF2->F2_VALBRUT ,"@E 99,999,999.99")) + "</th>"
		cHtml += "</tr>"
		cHtml += "<tr>"
		cHtml += "<th>Total %:</th>
		cHtml += "<th>" + Alltrim(Transform( nTotal / (cAliasSD2)->QTD * 100 ,"@E 99,999,999.99")) + "</th>"
		cHtml += "<th>" + Alltrim(Transform( nValTotal / SF2->F2_VALBRUT * 100, "@E 99,999,999.99")) + "</th>"
		cHtml += "</tr>"

		cHtml += "</table>"

		cHtml += "</body>"
		cHtml += "</html>"


	Endif

	//memoWrite("C:\TEMP\RAMI.TXT", cHtml)

return cHtml




//------------------------------------------------
// Pre validacao linha SD2
//------------------------------------------------
static function prevldSD2(oModel, nLin, cPonto, cCpo, e)
	Local xRet := .T.
	Local nOper			:= oModel:getOperation()

	If cPonto == 'DELETE'
		xRet := .F.
		Help( ,, 'Nao  permitido',, "Nao e possivel excluir linhas da Nota Fiscal.", 1, 0 )
	else
		if nOper <> MODEL_OPERATION_INSERT
			xRet := .F.
			Help( ,, 'Nao  permitido',, "Nao e possivel alterar linhas da Nota Fiscal.", 1, 0 )
		endif
	EndIf
Return xRet

//------------------------------------------------
//
//------------------------------------------------
static function prevldZAV(oModel, cPonto, cCpo, xConteud)
	Local xRet			:= .T.
	Local oModel 		:= FWModelActive()
	Local oMdlZAV		:= oModel:GetModel('ZAVMASTER')
	Local oMdlZAW		:= oModel:GetModel('ZAWDETAIL')
	Local aSaveLines	:= FWSaveRows()

	if cPonto == 'SETVALUE'
		if allTrim( cCpo ) == 'ZAV_PEDIDO' .or.;
				allTrim( cCpo ) == 'ZAV_NOTA' .or.;
				allTrim( cCpo ) == 'ZAV_SERIE' .or.;
				allTrim( cCpo ) == 'ZAV_NFEMIS' .or.;
				allTrim( cCpo ) == 'ZAV_CLIENT' .or.;
				allTrim( cCpo ) == 'ZAV_LOJA'

			if oMdlZAW:Length() > 0
				oMdlZAW:goLine(1)
				if !empty( oMdlZAW:getValue("ZAW_NOTA") )
					help( ,, 'MGFCRM05',, 'Nao  perimtido alterar este campo apos a inclusao de Ocorr�ncias.', 1, 0 )
					xRet := .F.
				endif
			endif
		endif
	endif

	FWRestRows( aSaveLines )
return xRet

//------------------------------------------------
//
//------------------------------------------------
Static Function prevldZAW(oModel, nLin, cPonto, cCpo, e)
	Local xRet			:= .T.
	Local oModel 		:= FWModelActive()
	Local oMdlZAV		:= oModel:GetModel('ZAVMASTER')
	Local oMdlSD2		:= oModel:GetModel('SD2DETAIL')
	Local oMdlZAW		:= oModel:GetModel('ZAWDETAIL')
	Local oMdlZAX		:= oModel:GetModel('ZAXDETAIL')
	Local aSaveLines	:= FWSaveRows()

	Local nQtdOcor		:= 0
	Local nQtdDisp		:= 0
	Local cItemOcor		:= ""
	Local cUserAlt		:= ""
	Local lAchou		:= .f.
	DbSelectArea('ZAU')
	DbSetOrder(1)//ZAU_FILIAL+ZAU_CODIGO
	ZAU->(Msseek(xFilial('ZAU') + oMdlZAW:getValue("ZAW_DIRECI")))
	if ZAV_STATUS<>'1'
		cUserAlt:=GETMV('MGF_USRCOM')///Usuarios comercial
	ENDIF
	if cPonto == 'DELETE'
		oMdlZAX:goLine( nLin )
		oMdlZAX:deleteLine()
	elseif cPonto == "UNDELETE"
		oMdlZAX:goLine( nLin )
		oMdlZAX:unDeleteLine()
	else
		if retCodUsr() <> oMdlZAV:getValue("ZAV_CODUSR") // .and. !__cUserID $ cUserAlt .or. !__cUserID $ ZAU->ZAU_USUARI
			DbSelectArea('ZAW')
			DbSetOrder(1)//ZAW_FILIAL+ZAW_CDRAMI+ZAW_ITEMNF
			ZAW->(MsSeek(xFilial('ZAW') + oMdlZAW:getValue("ZAW_CDRAMI") + oMdlZAW:getValue("ZAW_ITEMNF")))

			if oMdlZAW:getValue("ZAW_DIRECI") == ZAW->ZAW_DIRECI
				if __cUserID $ cUserAlt// .or. __cUserID $ ZAU->ZAU_USUARI
					if cPonto == 'SETVALUE'
						if cCpo == 'ZAW_QTD'
							// Soma quantas vezes o item ja foi utilizado no grid das ocorrencias
							nQtdOcor := 0
							cItemOcor := oMdlZAW:getValue("ZAW_ITEMNF")
							for nI := 1 to oMdlZAW:length()
								oMdlZAW:goLine(nI)
								if nI <> nLin .AND. cItemOcor == oMdlZAW:getValue("ZAW_ITEMNF")
									nQtdOcor += oMdlZAW:getValue("ZAW_QTD")
								endif
							next

							for nI := 1 to oMdlSD2:length()
								oMdlSD2:goLine(nI)
								if allTrim( oMdlZAW:getValue( "ZAW_ITEMNF", nLin ) ) == allTrim(oMdlSD2:getValue( "D2_ITEM" ) )
									nQtdDisp := 0
									nQtdDisp := ( oMdlSD2:getValue("D2_QUANT") - nQtdOcor )

									if M->ZAW_QTD > nQtdDisp
										Help( ,, 'Nao  permitido',, "Quantidade informada � maior que a quantidade da Nota Fiscal.", 1, 0 )
										xRet := .F.
										exit
									endif
								endif
							next
						else
							xRet := .T.
						endif
					else
						xRet := .T.
					endif


				else //inicio alteracao Rafael
					if !__cUserID $ ZAU->ZAU_USUARI
						if oMdlZAV:getValue("ZAV_STATUS")=="1" .AND. (cCpo=="ZAW_STATUS" .OR. cCpo=="ZAW_RESOLU")
							xRet := .T.
						elseif oMdlZAV:getValue("ZAV_STATUS")=="0" .AND. (cCpo=="ZAW_STATUS" .OR. cCpo=="ZAW_RESOLU")
							If Select("QRYZAU")   > 0
								QRYZAU->(DBCLOSEAREA())
							endif
							_cQuery := " SELECT ZAU.* FROM "
							_cQuery +=  RetSqlName("ZAU")+" ZAU "
							_cQuery += " WHERE ZAU.ZAU_CODIGO	=	'" + oMdlZAW:getValue("ZAW_DIRECI")	+ "'"
							_cQuery += " 	AND	ZAU.ZAU_FILIAL	=	'" + xFilial("ZAU") + "'"
							_cQuery += " 	AND	ZAU.D_E_L_E_T_	<>	'*'"

							tcQuery _cQuery New Alias "QRYZAU"

							If QRYZAU->(!eof())
								if retCodUsr()==ALLTRIM(QRYZAU->ZAU_USUARI)
									QRYZAU->(DBCLOSEAREA())
									xRet:= .T.
								ELSE
									FOR i:=0 to 9

										If Select("QRYSYS")   > 0
											QRYSYS->(DBCLOSEAREA())
										endif
										if  ALLTRIM(&("QRYZAU->ZAU_EMAIL"+alltrim(STR(i))))<>''

											_cQuery := " SELECT USR_ID FROM SYS_USR "
											_cQuery += " WHERE USR_EMAIL  LIKE '%" + ALLTRIM(&("QRYZAU->ZAU_EMAIL"+alltrim(STR(i))))+ "%'"
											tcQuery _cQuery New Alias "QRYSYS"

											if QRYSYS->(!EOF()) .AND. retCodUsr()==ALLTRIM(QRYSYS->USR_ID)
												QRYZAU->(DBCLOSEAREA())
												QRYSYS->(DBCLOSEAREA())
												lAchou:= .t.
												xRet:= .T.
												exit
											endif
										endif
									next
									If Select("QRYSYS")   > 0
										QRYSYS->(DBCLOSEAREA())
									endif
								endif

							ENDIF
							If Select("QRYZAU")   > 0
								QRYZAU->(DBCLOSEAREA())
							endif
							If Select("QRYSYS")   > 0
								QRYSYS->(DBCLOSEAREA())
							endif
							if !lAchou
								xRet := .F.
								Help( ,, 'Nao  permitido',, "Apenas usuario respons�vel pela abertura do RAMI ou respons�vel pelo direcionamento podera fazer alteracoes.", 1, 0 )
							endif
						else
							xRet := .F.
							Help( ,, 'Nao  permitido',, "Apenas usuario respons�vel pela abertura do RAMI ou respons�vel pelo direcionamento podera fazer alteracoes.", 1, 0 )
						endif
					endif
				endif
			endif

		else
			if oMdlZAV:getValue("ZAV_STATUS")=="1" .AND. (cCpo=="ZAW_STATUS" .OR. cCpo=="ZAW_RESOLU")
				xRet := .T.
			endif//fim alteracao Rafael

			if cPonto == 'SETVALUE'
				if cCpo == 'ZAW_QTD'

					// Soma quantas vezes o item ja foi utilizado no grid das ocorrencias
					nQtdOcor := 0

					cItemOcor := oMdlZAW:getValue("ZAW_ITEMNF")
					for nI := 1 to oMdlZAW:length()
						oMdlZAW:goLine(nI)
						if nI <> nLin .AND. cItemOcor == oMdlZAW:getValue("ZAW_ITEMNF")
							nQtdOcor += oMdlZAW:getValue("ZAW_QTD")
						endif
					next

					for nI := 1 to oMdlSD2:length()
						oMdlSD2:goLine(nI)
						if allTrim( oMdlZAW:getValue( "ZAW_ITEMNF", nLin ) ) == allTrim(oMdlSD2:getValue( "D2_ITEM" ) )
							nQtdDisp := 0
							nQtdDisp := ( oMdlSD2:getValue("D2_QUANT") - nQtdOcor )

							if M->ZAW_QTD > nQtdDisp
								Help( ,, 'Nao  permitido',, "Quantidade informada � maior que a quantidade da Nota Fiscal.", 1, 0 )
								xRet := .F.
								exit
							endif
						endif
					next
				endif
			endif
		endif
	endif

	FWRestRows( aSaveLines )
Return xRet

//------------------------------------------------
//
//------------------------------------------------
Static Function prevldZAX(oModel, nLin, cPonto, cCpo, e)
	Local xRet := .T.
	Local oModel 		:= FWModelActive()
	Local oMdlZAV		:= oModel:GetModel('ZAVMASTER')
	Local oMdlSD2		:= oModel:GetModel('SD2DETAIL')
	Local oMdlZAW		:= oModel:GetModel('ZAWDETAIL')
	Local oMdlZAX		:= oModel:GetModel('ZAXDETAIL')
	Local aSaveLines	:= FWSaveRows()

	Local nQtdReso		:= 0
	Local nQtdDisp		:= 0
	Local cItemReso		:= ""

	if cPonto == 'DELETE' .and. !isInCallStack ( "prevldZAW" )
		xRet := .F.
		Help( ,, 'Nao  permitido',, "Nao e possivel excluir linhas da Resolu��o.", 1, 0 )
	else
		if cPonto == 'SETVALUE'
			if cCpo == 'ZAX_QTD'
				// Soma quantas vezes o item ja foi utilizado no grid das resolucoes
				nQtdReso	:= 0
				cItemReso	:= oMdlZAX:getValue("ZAX_ID")
				for nI := 1 to oMdlZAX:length()
					oMdlZAX:goLine(nI)
					if nI <> nLin .AND. cItemReso == oMdlZAX:getValue("ZAX_ID")
						nQtdReso += oMdlZAX:getValue("ZAX_QTD")
					endif
				next

				for nI := 1 to oMdlZAW:length()
					oMdlZAW:goLine(nI)
					if allTrim( oMdlZAW:getValue( "ZAW_ID" ) ) == allTrim( cItemReso )
						nQtdDisp := 0
						nQtdDisp := ( oMdlZAW:getValue("ZAW_QTD") - nQtdReso )

						if M->ZAX_QTD > nQtdDisp
							Help( ,, 'Nao  permitido',, "Quantidade informada � maior que a quantidade da ocorrencia.", 1, 0 )
							xRet := .F.
							exit
						endif
					endif
				next
			endif
		endif
	endif

	FWRestRows( aSaveLines )
Return xRet

//------------------------------------------------
//
//------------------------------------------------
static function CRM05POS( oModel )
	Local lRet			:= .T.
	Local oModel		:= FWModelActive()
	Local oModelZAV		:= oModel:GetModel('ZAVMASTER')
	Local oModelZAW		:= oModel:GetModel('ZAWDETAIL')
	Local nOper			:= oModel:getOperation()
	Local aSaveLines	:= FWSaveRows()

	if nOper == MODEL_OPERATION_UPDATE .or. nOper == MODEL_OPERATION_INSERT
		if isEcomBole()
			if empty( oModelZAV:getValue("ZAV_CREDEC") )
				help( ,, 'MGFCRM05',, 'Pedido de E-Commerce com Cond de Pagamento em Boleto.' + CRLF + 'Informar o Credito E-Commerce (Sim/Nao )', 1, 0 )
				return .F.
			endif

			if oModelZAV:getValue("ZAV_CREDEC") == "N" .and. empty( oModelZAV:getValue("ZAV_CONTA") )
				help( ,, 'MGFCRM05',, 'Cliente solicitou dep�sito em Conta.' + CRLF + 'Informar Dados Banc�rios.', 1, 0 )
				return .F.
			endif
		endif

		if empty(oModelZAV:getValue("ZAV_NOTA")) .or.;
				empty(oModelZAV:getValue("ZAV_SERIE")) .or.;
				empty(oModelZAV:getValue("ZAV_NFEMIS"))

			help( ,, 'MGFCRM05',, 'Dados da Nota Fiscal inv�lidos.', 1, 0 )
			return .F.
		else
			if !chkSF2(oModelZAV:getValue("ZAV_NOTA"), oModelZAV:getValue("ZAV_SERIE"), oModelZAV:getValue("ZAV_NFEMIS"))
				help( ,, 'MGFCRM05',, 'Dados da Nota Fiscal inv�lidos.', 1, 0 )
				return .F.
			endif
		endif

		for nI := 1 to oModelZAW:Length()
			oModelZAW:GoLine( nI )
			if !oModelZAW:isDeleted()
				if empty(oModelZAW:getValue("ZAW_DIRECI", nI))
					Help( ,, 'MGFCRM05',, 'Nao  foi informado o direcionamento.', 1, 0 )
					return .F.
				endif
			endif
		next
	endif

	FWRestRows( aSaveLines )
return lRet

//------------------------------------------------
//------------------------------------------------
static function chkSF2(cDocSF2, cSerieSF2, dEmisSf2)
	Local lRet		:= .F.
	Local cQrySF2	:= ""

	cQrySF2 := "SELECT F2_DOC, F2_SERIE, F2_EMISSAO"					+ CRLF
	cQrySF2 += " FROM " + retSQLName("SF2") + " SF2"					+ CRLF
	cQrySF2 += " WHERE"													+ CRLF
	cQrySF2 += " 		SF2.F2_EMISSAO	=	'" + dToS(dEmisSf2)	+ "'"	+ CRLF
	cQrySF2 += " 	AND	SF2.F2_SERIE	=	'" + cSerieSF2		+ "'"	+ CRLF
	cQrySF2 += " 	AND	SF2.F2_DOC		=	'" + cDocSF2		+ "'"	+ CRLF
	cQrySF2 += " 	AND	SF2.F2_FILIAL	=	'" + xFilial("SF2") + "'"	+ CRLF
	cQrySF2 += " 	AND	SF2.D_E_L_E_T_	<>	'*'"						+ CRLF

	//memoWrite("C:\TEMP\chkSF2.SQL", cQrySF2)

	tcQuery cQrySF2 New Alias "QRYSF2"

	if !QRYSF2->(EOF())
		lRet := .T.
	endif

	QRYSF2->(DBCloseArea())
return lRet


//------------------------------------------------
//
//------------------------------------------------
static function iniBtnAdd()
return 'MAIS.PNG'

//------------------------------------------------
// Verifica se usuario pode alterar os campos de Aprovacao
//------------------------------------------------
user function chkUsRam(cCpoChk)
	Local lRet		:= .F.
	Local cQryZBK	:= ""
	Local oModel 	:= FWModelActive()
	Local oMdlZAV	:= oModel:GetModel('ZAVMASTER')
	Local nOper		:= oModel:getOperation()

	if oMdlZAV:getValue(_cAlias + "_ORDRET") == "0" .or. nOper == MODEL_OPERATION_INSERT
		return .F.
	endif

	cQryZBK := "SELECT *"																	+ CRLF
	cQryZBK += " FROM " + retSQLName("ZBK") + " ZBK"										+ CRLF
	cQryZBK += " WHERE"																		+ CRLF
	cQryZBK += "		ZBK.ZBK_CODUSR	=	'" + allTrim(retCodUsr()) + "'"					+ CRLF
	cQryZBK += "	AND	ZBK.ZBK_FILIAL	=	'" + xFilial("ZBK") + "'"						+ CRLF
	cQryZBK += "	AND	ZBK.D_E_L_E_T_	<>	'*'"											+ CRLF

	tcQuery cQryZBK New Alias "QRYZBK"

	if !QRYZBK->(EOF())
		// ZBK_DEPTO - 1=Comercial;2=Qualidade;3=Expedicao;4=PCP;5=Transporte
		if cCpoChk == "ZAV_COMERC"
			if QRYZBK->ZBK_DEPTO == "1"
				lRet := .T.
			endif
		elseif cCpoChk == "ZAV_QUALID"
			if QRYZBK->ZBK_DEPTO == "2"
				lRet := .T.
			endif
		elseif cCpoChk == "ZAV_EXPEDI"
			if QRYZBK->ZBK_DEPTO == "3"
				lRet := .T.
			endif
		elseif cCpoChk == "ZAV_PCP"
			lRet := .T.
		elseif cCpoChk == "ZAV_TRANSP"
			if QRYZBK->ZBK_DEPTO == "5" .AND.;
					oMdlZAV:getValue("ZAV_COMERC") == "1" .AND.;
					oMdlZAV:getValue("ZAV_QUALID") == "1"  .AND.;
					oMdlZAV:getValue("ZAV_EXPEDI") == "1" .AND.;
					oMdlZAV:getValue("ZAV_PCP") == "1"
				lRet := .T.
			endif
		endif
	endif

	QRYZBK->(DBCloseArea())
return lRet

//------------------------------------------
// Retorna qtde disponivel do item
//------------------------------------------
static function getQtdIt(cNota, cSerie, cItem, nTipoGrid)
	Local cAlias	:= getNextAlias()
	Local _cQuery	:= ""
	Local nQtdRet	:= 0


	_cQuery := "SELECT D2_ITEM, D2_COD, D2_QUANT, D2_DOC, D2_SERIE, D2_TOTAL, D2_PRCVEN, B1_DESC,"	+ CRLF

	if nTipoGrid == 1
		_cQuery += " D2_QUANT - ("											+ CRLF
		_cQuery += " SELECT COALESCE(SUM(ZAW_QTD),0)"						+ CRLF
		_cQuery += " FROM "	+ retSqlName("ZAW") + " ZAW"					+ CRLF
		_cQuery += " WHERE"													+ CRLF
		_cQuery += " 		SD2.D2_ITEM		= ZAW.ZAW_ITEMNF"				+ CRLF
		_cQuery += " 	AND	SD2.D2_SERIE	= ZAW.ZAW_SERIE"				+ CRLF
		_cQuery += " 	AND	SD2.D2_DOC		= ZAW.ZAW_NOTA"					+ CRLF
		_cQuery += "		AND	ZAW.ZAW_FILIAL	= '" + xFilial("ZAW")	+ "' "	+ CRLF
		_cQuery += "		AND ZAW.D_E_L_E_T_	<>	'*'"						+ CRLF
		_cQuery += " ) QTDDISPO"												+ CRLF
	elseif nTipoGrid == 2
		_cQuery += " D2_QUANT - ("											+ CRLF
		_cQuery += " SELECT COALESCE(SUM(ZAX_QTD),0)"						+ CRLF
		_cQuery += " FROM "	+ retSqlName("ZAX") + " ZAX"					+ CRLF
		_cQuery += " WHERE"													+ CRLF
		_cQuery += " 		SD2.D2_ITEM		=	ZAX.ZAX_ITEMNF"				+ CRLF
		_cQuery += " 	AND	SD2.D2_SERIE	=	ZAX.ZAX_SERIE"				+ CRLF
		_cQuery += " 	AND	SD2.D2_DOC		=	ZAX.ZAX_NOTA"				+ CRLF
		_cQuery += "		AND	ZAX.ZAX_FILIAL	=	'" + xFilial("ZAX")	+ "' "	+ CRLF
		_cQuery += "		AND ZAX.D_E_L_E_T_	<>	'*'"						+ CRLF
		_cQuery += " ) QTDDISPO"												+ CRLF
	endif

	_cQuery += " FROM "			+ retSqlName("SD2") + " SD2"		+ CRLF
	_cQuery += " INNER JOIN "	+ retSqlName("SB1") + " SB1"		+ CRLF
	_cQuery += " ON SD2.D2_COD = SB1.B1_COD"							+ CRLF
	_cQuery += " WHERE "												+ CRLF
	_cQuery += "		SD2.D2_SERIE	= '" + cSerie			+ "' "	+ CRLF
	_cQuery += "	AND	SD2.D2_DOC 		= '" + cNota			+ "' "	+ CRLF
	_cQuery += "	AND	SD2.D2_ITEM		= '" + cItem			+ "' "	+ CRLF
	_cQuery += "	AND	SB1.B1_FILIAL	= '" + xFilial("SB1")	+ "' "	+ CRLF
	_cQuery += "	AND	SD2.D2_FILIAL	= '" + xFilial("SD2")	+ "' "	+ CRLF
	_cQuery += "	AND SB1.D_E_L_E_T_	<>	'*'"							+ CRLF
	_cQuery += "	AND SD2.D_E_L_E_T_	<>	'*'"							+ CRLF

	_cQuery += "	GROUP BY"													+ CRLF
	_cQuery += "	SD2.D2_ITEM		, SD2.D2_COD	,"							+ CRLF
	_cQuery += "	SD2.D2_QUANT	, SD2.D2_DOC	,"							+ CRLF
	_cQuery += "	SD2.D2_SERIE	, SD2.D2_TOTAL	,"							+ CRLF
	_cQuery += "	SD2.D2_PRCVEN	, B1_DESC"									+ CRLF

	if nTipoGrid == 1
		_cQuery += "	HAVING"														+ CRLF
		_cQuery += "	("															+ CRLF
		_cQuery += "		SD2.D2_QUANT -"											+ CRLF
		_cQuery += "		("														+ CRLF
		_cQuery += "			SELECT COALESCE(SUM(ZAW_QTD),0)"					+ CRLF
		_cQuery += "			FROM " + retSqlName("ZAW") + " ZAW "				+ CRLF
		_cQuery += "			WHERE "												+ CRLF
		_cQuery += "				ZAW.ZAW_ITEMNF	=	SD2.D2_ITEM"				+ CRLF
		_cQuery += "			AND ZAW.ZAW_SERIE	=	SD2.D2_SERIE"				+ CRLF
		_cQuery += "			AND ZAW.ZAW_NOTA	=	SD2.D2_DOC"					+ CRLF
		_cQuery += "			AND ZAW.ZAW_FILIAL	=	'" + xFilial("ZAW")	+ "'"	+ CRLF
		_cQuery += "			AND ZAW.D_E_L_E_T_	<>	'*'"						+ CRLF
		_cQuery += "		)"														+ CRLF
		_cQuery += "	) > 0"														+ CRLF
	elseif nTipoGrid == 2
		_cQuery += "	HAVING"														+ CRLF
		_cQuery += "	("															+ CRLF
		_cQuery += "		SD2.D2_QUANT -"											+ CRLF
		_cQuery += "		("														+ CRLF
		_cQuery += "			SELECT COALESCE(SUM(ZAX_QTD),0)"					+ CRLF
		_cQuery += "			FROM " + retSqlName("ZAX") + " ZAX "				+ CRLF
		_cQuery += "			WHERE "												+ CRLF
		_cQuery += "				ZAX.ZAX_ITEMNF	=	SD2.D2_ITEM"				+ CRLF
		_cQuery += "			AND ZAX.ZAX_SERIE	=	SD2.D2_SERIE"				+ CRLF
		_cQuery += "			AND ZAX.ZAX_NOTA	=	SD2.D2_DOC"					+ CRLF
		_cQuery += "			AND ZAX.ZAX_FILIAL	=	'" + xFilial("ZAX")	+ "'"	+ CRLF
		_cQuery += "			AND ZAX.D_E_L_E_T_	<>	'*'"						+ CRLF
		_cQuery += "		)"														+ CRLF
		_cQuery += "	) > 0"														+ CRLF
	endif

	MemoWrite("C:\TEMP\MGFCRM05_2.SQL", _cQuery)

	_cQuery := ChangeQuery(_cQuery)

	tcQuery _cQuery New Alias (cAlias)

	if !(cAlias)->(EOF())
		nQtdRet := (cAlias)->QTDDISPO
	endif

	(cAlias)->(DBCloseArea())
return nQtdRet

//------------------------------------------
//------------------------------------------
static function iniD2Desc()
	Local cRetDesc	:= ""
	Local oModel	:= FWModelActive()
	Local nOper		:= oModel:getOperation()

	if nOper <> MODEL_OPERATION_INSERT
		cRetDesc := getAdvFVal("SB1", "B1_DESC", xFilial("SB1") + SD2->D2_COD, 1, "")
	endif
return cRetDesc

//--------------------------------------------------------------
// Banco de conhecimento - chamado pelo PE FTMSREL
//--------------------------------------------------------------
user function MGCRM05(aRet)

	aadd( aRet, { "ZAV", { "ZAV_CODIGO"}, { || xFilial("ZAV") + ZAV->ZAV_CODIGO} } )

return aRet

//--------------------------------------------------------------
// MENU - Banco de conhecimento
//--------------------------------------------------------------
user function ZAVRECNO()
	Local _aArea    := GetArea()
		msDocument( "ZAV", ZAV->( RECNO() ) , 2 )
	RestArea( _aArea )
return .T.



//--------------------------------------------------------------
//--------------------------------------------------------------
static function crm05cmt( oModel )
	Local lRet := .T.

	If oModel:VldData()
		FwFormCommit( oModel )
		oModel:DeActivate()

		msgAlert("RAMI " + allTrim( ZAV->ZAV_CODIGO ) )
	Else
		JurShowErro( oModel:GetModel():GetErrormessage() )
		lRet := .F.
		DisarmTransaction()
	EndIf
Return lRet

//--------------------------------------------------------------
//--------------------------------------------------------------
user function zawAdd(xZAWAdd)
	Local nI			:= 0
	Local oModel 		:= FWModelActive()
	Local oMdlZAV		:= oModel:GetModel('ZAVMASTER')
	Local oMdlGrid		:= oModel:GetModel('SD2DETAIL')
	Local oMdlZAW		:= oModel:GetModel('ZAWDETAIL')
	Local oMdlZAX		:= oModel:GetModel('ZAXDETAIL')
	Local nQtdDispo		:= 0
	Local nQtdUtil		:= 0

	// Caso precise enxergar as qtdes em outras RAMIs sera necessario rodar a query
	//nQtdDispo := getQtdIt(oMdlGrid:getValue("D2_DOC"), oMdlGrid:getValue("D2_SERIE"), oMdlGrid:getValue("D2_ITEM"), 2)
	nQtdDispo := oMdlZAW:getValue("ZAW_QTD")

	if nQtdDispo > 0
		for nI := 1 to oMdlZAX:Length()
			oMdlZAX:goLine( nI )
			//if allTrim( oMdlZAW:getValue("ZAW_ITEMNF") ) == allTrim( oMdlZAX:getValue("ZAX_ITEMNF") ) //.and. !oMdlZAX:isDeleted()
			if allTrim( oMdlZAW:getValue("ZAW_ID") ) == allTrim( oMdlZAX:getValue("ZAX_ID") ) //.and. !oMdlZAX:isDeleted()
				nQtdUtil += oMdlZAX:getValue("ZAX_QTD")
			endif
		next

		nQtdDispo := (nQtdDispo - nQtdUtil)
		if nQtdDispo <= 0
			msgAlert("Esta ocorrencia nao possui quantidade disponivel.")
			return xZAWAdd
		endif
	else
		msgAlert("Esta ocorrencia nao possui quantidade disponivel.")
		return xZAWAdd
	endif

	//msgAlert( "Clicou na linha " + allTrim( str( oMdlZAW:nLine ) )

	// INSERE RESOLUCAO
	oMdlZAX:goLine( oMdlZAX:Length() )

	if !empty(oMdlZAX:getValue("ZAX_CODPRO"))
		oMdlZAX:addLine(.T.)
	endif

	oMdlZAX:SetValue("ZAX_PRECO"	, oMdlGrid:getValue("D2_PRCVEN")	)
	oMdlZAX:SetValue("ZAX_TOTAL"	, oMdlGrid:getValue("D2_PRCVEN") * nQtdDispo		)
	oMdlZAX:SetValue("ZAX_DESCPR"	, oMdlGrid:getValue("D2_ZDESCB1")	)

	oMdlZAX:SetValue("ZAX_CODPRO"	, oMdlGrid:getValue("D2_COD")	)
	oMdlZAX:SetValue("ZAX_QTD"		, nQtdDispo						)
	oMdlZAX:SetValue("ZAX_NOTA"		, oMdlGrid:getValue("D2_DOC")	)
	oMdlZAX:SetValue("ZAX_SERIE"	, oMdlGrid:getValue("D2_SERIE")	)
	oMdlZAX:SetValue("ZAX_ITEMNF"	, oMdlGrid:getValue("D2_ITEM")	)

	oMdlZAX:SetValue("ZAX_ID"		, oMdlZAW:getValue("ZAW_ID")	)

	oMdlZAX:SetValue("ZAX_STATUS"	, '0')
return xZAWAdd

//--------------------------------------------------------------
// Verifica se a Nota Fiscal foi utilizada em alguma outra RAMI
//--------------------------------------------------------------
static function chkNf()
	Local lRet		:= .T.
	Local oModel	:= fwModelActive()
	Local nOper		:= oModel:getOperation()
	Local cQryZAV	:= ""
	Local lRetm	    := .T.

	if nOper == MODEL_OPERATION_INSERT
		if !empty(M->ZAV_NOTA) .AND. !empty(M->ZAV_SERIE)
			if !M->ZAV_TPFLAG = '1'
				/*
				cQryZAV := "SELECT ZAV_CODIGO, ZAV_NOTA, ZAV_SERIE"
				cQryZAV += " FROM " + retSQLName("ZAV") + " ZAV"
				cQryZAV += " WHERE"
				cQryZAV += " 		ZAV.ZAV_SERIE	=	'" + M->ZAV_SERIE	+ "'"
				cQryZAV += " 	AND	ZAV.ZAV_NOTA	=	'" + M->ZAV_NOTA	+ "'"
				cQryZAV += " 	AND	ZAV.ZAV_FILIAL	=	'" + xFilial("ZAV")	+ "'"
				cQryZAV += " 	AND	ZAV.D_E_L_E_T_	<>	'*'"

				tcQuery cQryZAV New Alias "QRYZAV"

				if !QRYZAV->( EOF() )
				Help( ,, 'MGFCRM05',, "Esta Nota Fiscal foi utilizada na RAMI " + allTrim( QRYZAV->ZAV_CODIGO ), 1, 0 )
				lRet := .F.
				endif

				QRYZAV->(DBCloseArea())
				*/
				DbSelectArea('ZAV')
				DbSetOrder(2)//ZAV_FILIAL+ZAV_NOTA+ZAV_SERIE
				if ZAV->(Msseek(xFilial('ZAV') + M->ZAV_NOTA + M->ZAV_SERIE ))
					lRetm := Msgyesno('Essa Nota j� foi utilizada em outra RAMI, deseja continuar?')
					If lRetm
						Return lRetm
					Else
						Return .F.
					EndIf
				else
					Return .T.
				EndIf
			else
				Return .T.
			endif
		endif
	endif
return lRet

User Function GetTran()

	Local cTransp := ""

	DbSelectArea("SF2")
	DbSetOrder(1)
	SF2->(MsSeek(XFILIAL("SF2") + M->ZAV_NOTA + M->ZAV_SERIE ))

	If !EMPTY(SF2->F2_TRANSP)
		cTransp := SF2->F2_TRANSP
	Else
		MsgAlert('O campo Transp NF nao sera preenchido, pois nao foi encontrado Transportadora para a Nota Selecionada!')
	EndIf

Return cTransp



User Function GetNMTran()

	Local cNmTransp := ""

	DbSelectArea("SA4")
	DbSetOrder(1)
	SA4->(MsSeek(XFILIAL("SA4") + SF2->F2_TRANSP ))

	cNmTransp := SA4->A4_NOME

Return cNmTransp


// Funcao que finaliza a RAMI

User Function MGFIMRAM()
	Local lRet := .F.

	If ZAV->ZAV_STATUS <> "1"

		lRet := MsgYesNo('Deseja relamente finalizar essa RAMI?')

		If lRet

			RecLock('ZAV', .F.)
			ZAV->ZAV_STATUS := "1"
			ZAV->(MsUnlock())
		Else
			MsgInfo('RAMI nao finalizada')
		EndIf
	Else
		MsgAlert('Processo nao executado! RAMI j� esta finalizada!')
	EndIf

Return


// Funcao que Extorna a finaliza��o da RAMI

User Function MGFEXTRAM()

	Local lRet       := .F.
	Local _cQuery 	 := ""
	Local cAliasSD1x := ""

	If ZAV->ZAV_STATUS == "1"

		lRet := MsgYesNo('Deseja relamente reabrir essa RAMI?')

		If lRet
			cAliasSD1x := GetNextAlias()

			_cQuery := " SELECT D1_FILIAL FROM "
			_cQuery +=  RetSqlName("SD1")+" SD1 "
			_cQuery += " WHERE D1_FILIAL  ='" + XFILIAL("SD1") + "'"
			_cQuery += " AND   D1_ZRAMI   ='" + ZAV->ZAV_CODIGO  + "'"
			_cQuery += " AND   SD1.D_E_L_E_T_ <>'*' "

			_cQuery := ChangeQuery(_cQuery)

			dbUseArea( .T., "TOPCONN", TCGENQRY(,,_cQuery),cAliasSD1x, .F., .T.)

			If (cAliasSD1x)->(!eof())
				lRet := .F.
			EndIf


			If lRet

				RecLock('ZAV', .F.)
				ZAV->ZAV_STATUS := "0"
				ZAV->(MsUnlock())
			Else
				MsgInfo('RAMI nao foi reaberta! H� processos vinculados a essa RAMI!')
			EndIf
		EndIf
	Else
		MsgAlert('Processo nao executado! RAMI nao esta finalizada!')
	EndIf

Return

//--------------------------------------------------------
//--------------------------------------------------------
static function isEcomBole()
//user function crm05Eco()
	Local lEcommBol		:= .F.
	Local oModel		:= FWModelActive()
	Local oModelZAV		:= oModel:GetModel('ZAVMASTER')
	Local cQrySC5		:= ""
	Local aAreaX		:= getArea()

	// 1=Credito E-Commerce;2=Deposito em Conta

	if !empty( oModelZAV:getValue("ZAV_PEDIDO") )
		//if !empty( M->ZAV_PEDIDO )
		cQrySC5 := "SELECT C5_FILIAL, C5_NUM"													+ CRLF
		cQrySC5 += " FROM " + retSQLName("SC5") + " SC5"										+ CRLF
		cQrySC5 += " WHERE"																		+ CRLF
		cQrySC5 += " 		SC5.C5_ZIDECOM	<>	' '"											+ CRLF
		cQrySC5 += " 	AND	SC5.C5_ZNSU		=	' '"											+ CRLF
		cQrySC5 += " 	AND	SC5.C5_NUM		=	'" + oModelZAV:getValue("ZAV_PEDIDO")	+ "'"	+ CRLF
		//cQrySC5 += " 	AND	SC5.C5_NUM		=	'" + M->ZAV_PEDIDO	+ "'"	+ CRLF
		cQrySC5 += " 	AND	SC5.C5_FILIAL	=	'" + xFilial("SC5")	+ "'"	+ CRLF
		cQrySC5 += " 	AND	SC5.D_E_L_E_T_	<>	'*'"											+ CRLF

		tcQuery cQrySC5 New Alias "QRYSC5"

		if !QRYSC5->(EOF())
			lEcommBol := .T.
		endif

		QRYSC5->(DBCloseArea())
	endif

	restArea( aAreaX )
return lEcommBol
	******************************************************************************************************************************
User Function CRM05_VLEX

	Local aAreaZAV   := ZAV->(GetArea())

	If !Empty(SD1->D1_ZRAMI)
		ZAV->(DbSetOrder(1))
		IF ZAV->(MsSeek(SD1->D1_FILIAL+SD1->D1_ZRAMI))
			IF ZAV->ZAV_STATUS =='1'
				RecLock("ZAV",.F.)
				ZAV->ZAV_STATUS := '0'
				ZAV->(MsUnlock())
			ENDIF
			ZAX->(DbSetOrder(1))
			ZAX->(DbGotop())
			ZAX->(dbSeek(SD1->D1_FILIAL+SD1->D1_ZRAMI))
			WHILE ZAX->(!EOF()) .AND. ZAX->ZAX_CDRAMI==SD1->D1_ZRAMI .AND. ZAX->ZAX_FILIAL==SD1->D1_FILIAL
				IF ZAX->ZAX_CODPRO == SD1->D1_COD     .AND. ;
						ZAX->ZAX_QTD == SD1->D1_QUANT   .AND.;
						ALLTRIM(ZAX->ZAX_NFGER)==ALLTRIM(SD1->D1_DOC) .AND. ;
						ALLTRIM(ZAX->ZAX_SERGR)==ALLTRIM(SD1->D1_SERIE)

					RecLock("ZAX",.F.)
					ZAX->(dbDelete())
					ZAX->(MsUnlock())

				ENDIF
				ZAX->(dbSkip())
			ENDDO
		ENDIF
	ENDIF

	RestArea(aAreaZAV)

Return



/*/
{Protheus.doc} GATTPRAMI
	Gatilho para verificar se popula automaticamente os itens da Ocorrencia.

@author Marcos Cesar Donizeti Vieira
@since 20/11/2019

@type Function
@param	
@return
/*/
user function GATTPRAMI()
	Local _lRet		:= .T.
	Local oModel 	:= FWModelActive()
	Local oModelCab	:= oModel:GetModel('ZAVMASTER')
	Local _nOper	:= oModel:getOperation()
	Local _cNota	:= oModelCab:getValue("ZAV_NOTA")
	Local _cSerie	:= oModelCab:getValue("ZAV_SERIE")
	Local _cTpDevRe	:= oModelCab:getValue("ZAV_TPFLAG")
	Local _cTpRami	:= oModelCab:getValue("ZAV_TIPO")
	Local _cAliasD2 := nil

	If _nOper == MODEL_OPERATION_INSERT
		If _cTpRami = "T" .AND. _cTpDevRe = "2"
			If MsgYesNo("Deseja adicionar todos itens da NF na Grade das Ocorr�ncias?")
				If EMPTY(_cNota) .OR. EMPTY(_cSerie)
					Help( ,, 'MGFCRM05',, 'Nota e/ou serie inv�lida(s).', 1, 0 )
				Else
					_cAliasD2 := GetItensNF(_cNota, _cSerie)
					If (_cAliasD2)->(!eof())
						CarregOco(_cAliasD2)
					Else
						Help( ,, 'MGFCRM05',, 'Nota e/ou serie nao Localizada(s).', 1, 0 )
					Endif
					(_cAliasD2)->(dbCloseArea())
				EndIf
			EndIf
		EndIf
	EndIf
Return 



/*/
{Protheus.doc} CarregOco
	Rotina para popular automaticamente os itens da Ocorrencia.

@author Marcos Cesar Donizeti Vieira
@since 20/11/2019

@type Function
@param	
@return
/*/
Static Function CarregOco(_cAliasD2)
	Local oModel 	:= FWModelActive()
	Local oView 	:= nil
	Local oMdlZAW	:= nil
	Local _lRet		:= .T.

	oMdlZAW	:= oModel:GetModel('ZAWDETAIL')
	oMdlZAW:GoLine(1)

	(_cAliasD2)->(DBGoTop())
	While (_cAliasD2)->(!eof())

		oMdlZAW:loadValue("ZAW_ID"		, STRZERO(VAL((_cAliasD2)->D2_ITEM),4,0)										)
		oMdlZAW:loadValue("ZAW_ITEMNF"	, (_cAliasD2)->D2_ITEM															)
		oMdlZAW:loadValue("ZAW_NOTA"	, (_cAliasD2)->D2_DOC															)
		oMdlZAW:loadValue("ZAW_SERIE"	, (_cAliasD2)->D2_SERIE															)
		oMdlZAW:loadValue("ZAW_CDPROD"	, (_cAliasD2)->D2_COD															)
		oMdlZAW:loadValue("ZAW_DESCPR"	, (_cAliasD2)->B1_DESC															)
		oMdlZAW:loadValue("ZAW_QTD"		, (_cAliasD2)->QTDDISPO															)
		oMdlZAW:loadValue("ZAW_PRECO"	, (((_cAliasD2)->D2_TOTAL + (_cAliasD2)->D2_DESCZFR ) / (_cAliasD2)->D2_QUANT )	)
		oMdlZAW:loadValue("ZAW_TOTAL"	, (_cAliasD2)->D2_TOTAL															)

		(_cAliasD2)->(DbSkip())
		If (_cAliasD2)->(!EOF())
			oMdlZAW:AddLine(.T.)
		EndIf
	EndDo
	oMdlZAW:GoLine(1)
	oView := FWViewActive()
	oView:Refresh()
Return 