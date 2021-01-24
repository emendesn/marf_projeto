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

user function MGFFINA5()

	local aButtons := {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.T.,"Prorrogar"},{.F.,"Cancelar"},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil}}
	local cPerg	   := "MGFFINA5"

	If Pergunte("MGFFINA5",.T.)

		fwExecView(	"Tela" /*"Aprovação de Pedidos com bloqueio - cTitulo*/		,;
					"MGFFINA5"							/*cPrograma*/		,;
					MODEL_OPERATION_INSERT				/*nOperation*/		,;
														/*oDlg*/			,;
					{|| .T.}							/*bCloseOnOK*/		,;
					{|| .T.}							/*bOk*/				,;
														/*nPercReducao*/	,;
					aButtons							/*aEnableButtons*/	,;
					{|| .T.}							/*bCancel*/ )

					/*
					- cTitulo:			título da janela
					- cPrograma:		nome do programa-fonte
					- nOperation:		indica o código de operação (inclusão, alteração ou exclusão)
					- oDlg:			objeto da janela em que o View deve ser colocado. Se não informado, uma nova janela será criada;
					- bCloseOnOK:		indica se a janela deve ser fechada ao final da operação. Se ele retornar .T. (verdadeiro) fecha a janela;
					- bOk:				Bloco executado no acionamento do botão confirmar que retornando .F. (falso) impedirá o fechamento da janela;
					- nPercReducao:	Se informado reduz a janela em percentualmente;
					- aEnableButtons:	Indica os botões da barra de botões que estarão habilitados;
					- bCancel:			Bloco executado no acionamento do botão cancelar que retornando .F. (falso) impedirá o fechamento da janela;
					*/
	EndIf

return

Static Function xQrySE1()

	Local cNextAlias := GetNextAlias()
	Local cDtDe		 := dToS(MV_PAR09)
	Local cDtAte	 := dToS(MV_PAR10)

	Local cInClient  := "1=1"
	Local cInTipo    := "1=1"

	If !Empty(MV_PAR03)
		cInClient := " E1.E1_CLIENTE " + xInQuery(MV_PAR03)
	EndIf
	cInClient := "%" + cInClient + "%"

	If !Empty(MV_PAR04)
		cInTipo := " E1.E1_TIPO " + xInQuery(MV_PAR04)
	EndIf
	cInTipo := "%" + cInTipo + "%"

	BeginSql Alias cNextAlias

		SELECT
			E1_FILIAL,
			E1_PREFIXO,
			E1_NUM,
			E1_PARCELA,
			E1_TIPO,
			E1_NATUREZ,
			E1_CLIENTE,
			E1_LOJA,
			E1_NOMCLI,
			E1_EMISSAO,
			E1_VALOR,
			E1_SALDO,
			E1_SDACRES,
			E1_SDDECRE,
			E1_DESCONT,
			E1_MULTA,
			E1_JUROS,
			E1_VENCTO,
			E1_VENCREA,
			E1_VALOR - E1_SALDO E1_ZVALOR
		FROM
			%TABLE:SE1% E1
		WHERE
			E1.%NOTDEL%
			AND %Exp:cInClient%
			AND %Exp:cInTipo%
			AND E1.E1_CLIENTE BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
			AND E1.E1_MOEDA BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
			AND E1.E1_NATUREZ BETWEEN %Exp:MV_PAR07% AND %Exp:MV_PAR08%
			AND E1.E1_FILIAL BETWEEN %Exp:MV_PAR13% AND %Exp:MV_PAR14%
			AND E1.E1_VENCTO BETWEEN %Exp:cDtDe% AND %Exp:cDtAte%
			AND E1.E1_SALDO > 0

	EndSql

	(cNextAlias)->(dbGoTop())

Return cNextAlias

Static Function xInQuery(cxParam)

	Local cRet 		:= ""
	Local axParam 	:= {}
	Local ni 		:= 0

	If !Empty(cxParam)
		axParam := STRTOKARR(cxParam,';')
		cRet += "IN ("
		For ni := 1 to Len(axParam)
			If Alltrim(cRet) == "IN ("
				cRet += " '" + Alltrim(axParam[ni]) + "'"
			Else
				cRet += " , '" + Alltrim(axParam[ni]) + "'"
			Endif
		Next ni
		cRet += " )"
	EndIf

Return cRet

Static Function ModelDef()

	Local oModel := Nil
	//Local oStrSE1 := FWFormStruct(1,"ZA1")
	Local oStrTop := gtMdlTop()
	Local oStrCen := gtMdlCente()

	oModel := MPFormModel():New( 'xMGFFINA5',, /*{ || chkMdl() }*/, { |oModel| xCommit( oModel ) } )

	oModel:AddFields( 'TOP'	 ,		 , oStrTop )
	oModel:AddGrid( 'CENTER' , 'TOP' , oStrCen )

	oModel:SetDescription( 'Tela para Alteração de Data' )
	oModel:GetModel("TOP"):SetDescription( 'TOP' )
	oModel:GetModel("CENTER"):SetDescription( 'CENTER' )
	oModel:SetPrimaryKey({ })

	oModel:addCalc("CALCFINA5", "TOP", "CENTER", "E1_VALOR", "CNTTIT"	, "COUNT", {|oModel|oModel:GetModel("CENTER"):GetValue("E1_ZFLAG")}, , "Qtd Titulos" )
	oModel:addCalc("CALCFINA5", "TOP", "CENTER", "E1_VALOR", "VLRTIT"	, "SUM"  , {|oModel|oModel:GetModel("CENTER"):GetValue("E1_ZFLAG")}, , "Total Titulos" )

	oModel:SetActivate({|oModel|xActiv(oModel)})

return oModel

Static Function xActiv(oModel)

	Local lRet 		:= .T.
	Local aAliasSE1 := xQrySE1()
	Local nLineSE1 	:= 1
	Local dDtValida := DataValida(MV_PAR11,.T.)

	local oMdlCent	:= oModel:GetModel("CENTER")
	Local oMdlTop	:= oModel:GetModel("TOP")

	oMdlTop:loadValue("CMP_X","A")

	(aAliasSE1)->(dbGoTop())

	While (aAliasSE1)->(!EOF())

		If nLineSE1 > 1
			nLineSE1 := oMdlCent:addLine()
		EndIf

		oMdlCent:GoLine( nLineSE1 )

		oMdlCent:loadValue("E1_ZFLAG"	, .F.											)
		oMdlCent:loadValue("E1_FILIAL"	, (aAliasSE1)->E1_FILIAL						)
		oMdlCent:loadValue("E1_PREFIXO" , (aAliasSE1)->E1_PREFIXO						)
		oMdlCent:loadValue("E1_NUM"     , (aAliasSE1)->E1_NUM   						)
		oMdlCent:loadValue("E1_PARCELA" , (aAliasSE1)->E1_PARCELA						)
		oMdlCent:loadValue("E1_TIPO"    , (aAliasSE1)->E1_TIPO							)
		oMdlCent:loadValue("E1_NATUREZ" , (aAliasSE1)->E1_NATUREZ						)
		oMdlCent:loadValue("E1_CLIENTE" , (aAliasSE1)->E1_CLIENTE						)
		oMdlCent:loadValue("E1_LOJA"    , (aAliasSE1)->E1_LOJA							)
		oMdlCent:loadValue("E1_NOMCLI"  , (aAliasSE1)->E1_NOMCLI						)
		oMdlCent:loadValue("E1_EMISSAO" , StoD((aAliasSE1)->E1_EMISSAO)					)
		oMdlCent:loadValue("E1_VENCTO"  , StoD((aAliasSE1)->E1_VENCTO)                  )
		oMdlCent:loadValue("E1_VENCREA" , StoD((aAliasSE1)->E1_VENCREA)     			)
		oMdlCent:loadValue("E1_VALOR"   , (aAliasSE1)->E1_VALOR							)
		oMdlCent:loadValue("E1_SALDO"   , (aAliasSE1)->E1_SALDO							)
		oMdlCent:loadValue("E1_SDACRES", (aAliasSE1)->E1_SDACRES						)
		oMdlCent:loadValue("E1_SDDECRE" , (aAliasSE1)->E1_SDDECRE						)
		oMdlCent:loadValue("E1_DESCONT" , (aAliasSE1)->E1_DESCONT						)
		oMdlCent:loadValue("E1_MULTA"   , (aAliasSE1)->E1_MULTA							)
		oMdlCent:loadValue("E1_JUROS"   , (aAliasSE1)->E1_JUROS							)
		oMdlCent:loadValue("E1_ZVALOR"  , (aAliasSE1)->E1_ZVALOR 						)

		nLineSE1++

		(aAliasSE1)->(dbSkip())
	EndDo

	(aAliasSE1)->(dbCloseArea())

	oMdlCent:SetNoInsertLine( .T. )
	oMdlCent:SetNoDeleteLine( .T. )

return lRet

Static Function ViewDef()

	Local oView 	:= Nil
	local oModel  	:= modelDef()
	//Local oStrSE1 := FWFormStruct(2,"ZA1")
	Local oStrTop 	:= gtVwTop()
	Local oStrCen 	:= gtVwCente()

	local oCalc1	:= FWCalcStruct( oModel:GetModel( 'CALCFINA5') )

	oView := FWFormView():New()

	//oView:showInsertMsg( .F. )

	oView:SetModel( oModel )

	oView:AddField('VIEW_TOP'	 , oStrTop	, 'TOP'	   )
	oView:AddGrid( 'VIEW_CENTER' , oStrCen	, 'CENTER' )

	oView:AddField( 'VIEW_CALC'	 , oCalc1	, 'CALCFINA5' )

	//oView:SetViewProperty("VIEW_CENTER", "GRIDFILTER", {.T.})
	oView:SetViewProperty("VIEW_CENTER", "GRIDSEEK", {.T.})

	oView:EnableTitleView('VIEW_TOP'		,'Inicial'				)
	oView:EnableTitleView('VIEW_CENTER'		,'Centro'				)
	oView:EnableTitleView('VIEW_CALC'		,'Totalizador'				)

	oView:CreateHorizontalBox( 'BOX_TOP'	, 0)
	oView:CreateHorizontalBox( 'BOX_CENTER'	, 85)
	oView:CreateHorizontalBox( 'BOX_CALC'	, 15)

	oView:SetOwnerView('VIEW_TOP'	 , 'BOX_TOP'	)
	oView:SetOwnerView('VIEW_CENTER' , 'BOX_CENTER'	)
	oView:SetOwnerView('VIEW_CALC' 	 , 'BOX_CALC'	)

	oView:AddUserButton( 'Marcar Tudo' , 'CLIPS', {|| xMarkAll()} )

return oView

static function gtMdlTop()

	Local oStruct := FWFormModelStruct():New()

	oStruct:AddField(	" "					,; 	// [01] C Titulo do campo
						"CMP_X"					,; 	// [02] C ToolTip do campo
						"CMP_X"	 				,; 	// [03] C identificador (ID) do Field
						"C" 					,; 	// [04] C Tipo do campo
						1						,; 	// [05] N Tamanho do campo
						0 						,; 	// [06] N Decimal do campo
						{ || .T. } 				,; 	// [07] B Code-block de validação do campo
						{ || .T. }				,; 	// [08] B Code-block de validação When do campo
						 						,; 	// [09] A Lista de valores permitido do campo
				      	.F. 					,;	// [10] L Indica se o campo tem preenchimento obrigatório
												,; 	// [11] B Code-block de inicializacao do campo
						.F. 					,;	// [12] L Indica se trata de um campo chave
						.F.		 				,; 	// [13] L Indica se o campo pode receber valor em uma operação de update.
						.F. )  	            		// [14] L Indica se o campo é virtual

return oStruct

Static Function gtMdlCente()

	local oStruct := FWFormModelStruct():New()

	oStruct:AddField(	" "						,; 	// [01] C Titulo do campo
						"E1_ZFLAG"				,; 	// [02] C ToolTip do campo
						"E1_ZFLAG"	 			,; 	// [03] C identificador (ID) do Field
						"L" 					,; 	// [04] C Tipo do campo
						1						,; 	// [05] N Tamanho do campo
						0 						,; 	// [06] N Decimal do campo
						{ || .T. } 				,; 	// [07] B Code-block de validação do campo
						{ || .T. }				,; 	// [08] B Code-block de validação When do campo
						 						,; 	// [09] A Lista de valores permitido do campo
				      	.F. 					,;	// [10] L Indica se o campo tem preenchimento obrigatório
												,; 	// [11] B Code-block de inicializacao do campo
						.F. 					,;	// [12] L Indica se trata de um campo chave
						.F.		 				,; 	// [13] L Indica se o campo pode receber valor em uma operação de update.
						.F. )  	            		// [14] L Indica se o campo é virtual

	oStruct:AddField(	" "						,; 	// [01] C Titulo do campo
						"E1_FILIAL"				,; 	// [02] C ToolTip do campo
						"E1_FILIAL"	 			,; 	// [03] C identificador (ID) do Field
						"C" 					,; 	// [04] C Tipo do campo
						6						,; 	// [05] N Tamanho do campo
						0 						,; 	// [06] N Decimal do campo
						{ || .T. } 				,; 	// [07] B Code-block de validação do campo
						{ || .T. }				,; 	// [08] B Code-block de validação When do campo
						 						,; 	// [09] A Lista de valores permitido do campo
				      	.F. 					,;	// [10] L Indica se o campo tem preenchimento obrigatório
												,; 	// [11] B Code-block de inicializacao do campo
						.F. 					,;	// [12] L Indica se trata de um campo chave
						.F.		 				,; 	// [13] L Indica se o campo pode receber valor em uma operação de update.
						.F. )  	            		// [14] L Indica se o campo é virtual

	oStruct:AddField(	" "						,; 	// [01] C Titulo do campo
						"E1_PREFIXO"			,; 	// [02] C ToolTip do campo
						"E1_PREFIXO"	 		,; 	// [03] C identificador (ID) do Field
						"C" 					,; 	// [04] C Tipo do campo
						3						,; 	// [05] N Tamanho do campo
						0 						,; 	// [06] N Decimal do campo
						{ || .T. } 				,; 	// [07] B Code-block de validação do campo
						{ || .T. }				,; 	// [08] B Code-block de validação When do campo
						 						,; 	// [09] A Lista de valores permitido do campo
				      	.F. 					,;	// [10] L Indica se o campo tem preenchimento obrigatório
												,; 	// [11] B Code-block de inicializacao do campo
						.F. 					,;	// [12] L Indica se trata de um campo chave
						.F.		 				,; 	// [13] L Indica se o campo pode receber valor em uma operação de update.
						.F. )  	            		// [14] L Indica se o campo é virtual

	oStruct:AddField(	" "						,; 	// [01] C Titulo do campo
						"E1_NUM"				,; 	// [02] C ToolTip do campo
						"E1_NUM"	 			,; 	// [03] C identificador (ID) do Field
						"C" 					,; 	// [04] C Tipo do campo
						9						,; 	// [05] N Tamanho do campo
						0 						,; 	// [06] N Decimal do campo
						{ || .T. } 				,; 	// [07] B Code-block de validação do campo
						{ || .T. }				,; 	// [08] B Code-block de validação When do campo
						 						,; 	// [09] A Lista de valores permitido do campo
				      	.F. 					,;	// [10] L Indica se o campo tem preenchimento obrigatório
												,; 	// [11] B Code-block de inicializacao do campo
						.F. 					,;	// [12] L Indica se trata de um campo chave
						.F.		 				,; 	// [13] L Indica se o campo pode receber valor em uma operação de update.
						.F. )  	            		// [14] L Indica se o campo é virtual

	oStruct:AddField(	" "						,; 	// [01] C Titulo do campo
						"E1_PARCELA"			,; 	// [02] C ToolTip do campo
						"E1_PARCELA"	 		,; 	// [03] C identificador (ID) do Field
						"C" 					,; 	// [04] C Tipo do campo
						2						,; 	// [05] N Tamanho do campo
						0 						,; 	// [06] N Decimal do campo
						{ || .T. } 				,; 	// [07] B Code-block de validação do campo
						{ || .T. }				,; 	// [08] B Code-block de validação When do campo
						 						,; 	// [09] A Lista de valores permitido do campo
				      	.F. 					,;	// [10] L Indica se o campo tem preenchimento obrigatório
												,; 	// [11] B Code-block de inicializacao do campo
						.F. 					,;	// [12] L Indica se trata de um campo chave
						.F.		 				,; 	// [13] L Indica se o campo pode receber valor em uma operação de update.
						.F. )  	            		// [14] L Indica se o campo é virtual

	oStruct:AddField(	" "						,; 	// [01] C Titulo do campo
						"E1_TIPO"				,; 	// [02] C ToolTip do campo
						"E1_TIPO"	 			,; 	// [03] C identificador (ID) do Field
						"C" 					,; 	// [04] C Tipo do campo
						3						,; 	// [05] N Tamanho do campo
						0 						,; 	// [06] N Decimal do campo
						{ || .T. } 				,; 	// [07] B Code-block de validação do campo
						{ || .T. }				,; 	// [08] B Code-block de validação When do campo
						 						,; 	// [09] A Lista de valores permitido do campo
				      	.F. 					,;	// [10] L Indica se o campo tem preenchimento obrigatório
												,; 	// [11] B Code-block de inicializacao do campo
						.F. 					,;	// [12] L Indica se trata de um campo chave
						.F.		 				,; 	// [13] L Indica se o campo pode receber valor em uma operação de update.
						.F. )  	            		// [14] L Indica se o campo é virtual

	oStruct:AddField(	" "						,; 	// [01] C Titulo do campo
						"E1_NATUREZ"			,; 	// [02] C ToolTip do campo
						"E1_NATUREZ"	 		,; 	// [03] C identificador (ID) do Field
						"C" 					,; 	// [04] C Tipo do campo
						10						,; 	// [05] N Tamanho do campo
						0 						,; 	// [06] N Decimal do campo
						{ || .T. } 				,; 	// [07] B Code-block de validação do campo
						{ || .T. }				,; 	// [08] B Code-block de validação When do campo
						 						,; 	// [09] A Lista de valores permitido do campo
				      	.F. 					,;	// [10] L Indica se o campo tem preenchimento obrigatório
												,; 	// [11] B Code-block de inicializacao do campo
						.F. 					,;	// [12] L Indica se trata de um campo chave
						.F.		 				,; 	// [13] L Indica se o campo pode receber valor em uma operação de update.
						.F. )  	            		// [14] L Indica se o campo é virtual

	oStruct:AddField(	" "						,; 	// [01] C Titulo do campo
						"E1_CLIENTE"				,; 	// [02] C ToolTip do campo
						"E1_CLIENTE"	 			,; 	// [03] C identificador (ID) do Field
						"C" 					,; 	// [04] C Tipo do campo
						6						,; 	// [05] N Tamanho do campo
						0 						,; 	// [06] N Decimal do campo
						{ || .T. } 				,; 	// [07] B Code-block de validação do campo
						{ || .T. }				,; 	// [08] B Code-block de validação When do campo
						 						,; 	// [09] A Lista de valores permitido do campo
				      	.F. 					,;	// [10] L Indica se o campo tem preenchimento obrigatório
												,; 	// [11] B Code-block de inicializacao do campo
						.F. 					,;	// [12] L Indica se trata de um campo chave
						.F.		 				,; 	// [13] L Indica se o campo pode receber valor em uma operação de update.
						.F. )  	            		// [14] L Indica se o campo é virtual

	oStruct:AddField(	" "						,; 	// [01] C Titulo do campo
						"E1_LOJA"				,; 	// [02] C ToolTip do campo
						"E1_LOJA"	 			,; 	// [03] C identificador (ID) do Field
						"C" 					,; 	// [04] C Tipo do campo
						2						,; 	// [05] N Tamanho do campo
						0 						,; 	// [06] N Decimal do campo
						{ || .T. } 				,; 	// [07] B Code-block de validação do campo
						{ || .T. }				,; 	// [08] B Code-block de validação When do campo
						 						,; 	// [09] A Lista de valores permitido do campo
				      	.F. 					,;	// [10] L Indica se o campo tem preenchimento obrigatório
												,; 	// [11] B Code-block de inicializacao do campo
						.F. 					,;	// [12] L Indica se trata de um campo chave
						.F.		 				,; 	// [13] L Indica se o campo pode receber valor em uma operação de update.
						.F. )  	            		// [14] L Indica se o campo é virtual

	oStruct:AddField(	" "						,; 	// [01] C Titulo do campo
						"E1_NOMCLI"				,; 	// [02] C ToolTip do campo
						"E1_NOMCLI"	 			,; 	// [03] C identificador (ID) do Field
						"C" 					,; 	// [04] C Tipo do campo
						20						,; 	// [05] N Tamanho do campo
						0 						,; 	// [06] N Decimal do campo
						{ || .T. } 				,; 	// [07] B Code-block de validação do campo
						{ || .T. }				,; 	// [08] B Code-block de validação When do campo
						 						,; 	// [09] A Lista de valores permitido do campo
				      	.F. 					,;	// [10] L Indica se o campo tem preenchimento obrigatório
												,; 	// [11] B Code-block de inicializacao do campo
						.F. 					,;	// [12] L Indica se trata de um campo chave
						.F.		 				,; 	// [13] L Indica se o campo pode receber valor em uma operação de update.
						.F. )  	            		// [14] L Indica se o campo é virtual

	oStruct:AddField(	" "						,; 	// [01] C Titulo do campo
						"E1_EMISSAO"			,; 	// [02] C ToolTip do campo
						"E1_EMISSAO"	 		,; 	// [03] C identificador (ID) do Field
						"D" 					,; 	// [04] C Tipo do campo
						8						,; 	// [05] N Tamanho do campo
						0 						,; 	// [06] N Decimal do campo
						{ || .T. } 				,; 	// [07] B Code-block de validação do campo
						{ || .T. }				,; 	// [08] B Code-block de validação When do campo
						 						,; 	// [09] A Lista de valores permitido do campo
				      	.F. 					,;	// [10] L Indica se o campo tem preenchimento obrigatório
												,; 	// [11] B Code-block de inicializacao do campo
						.F. 					,;	// [12] L Indica se trata de um campo chave
						.F.		 				,; 	// [13] L Indica se o campo pode receber valor em uma operação de update.
						.F. )  	            		// [14] L Indica se o campo é virtual

	oStruct:AddField(	" "						,; 	// [01] C Titulo do campo
						"E1_VENCTO"				,; 	// [02] C ToolTip do campo
						"E1_VENCTO"	 			,; 	// [03] C identificador (ID) do Field
						"D" 					,; 	// [04] C Tipo do campo
						8						,; 	// [05] N Tamanho do campo
						0 						,; 	// [06] N Decimal do campo
						{ || .T. } 				,; 	// [07] B Code-block de validação do campo
						{ || .T. }				,; 	// [08] B Code-block de validação When do campo
						 						,; 	// [09] A Lista de valores permitido do campo
				      	.F. 					,;	// [10] L Indica se o campo tem preenchimento obrigatório
												,; 	// [11] B Code-block de inicializacao do campo
						.F. 					,;	// [12] L Indica se trata de um campo chave
						.F.		 				,; 	// [13] L Indica se o campo pode receber valor em uma operação de update.
						.F. )  	            		// [14] L Indica se o campo é virtual

	oStruct:AddField(	" "						,; 	// [01] C Titulo do campo
						"E1_VENCREA"			,; 	// [02] C ToolTip do campo
						"E1_VENCREA"	 		,; 	// [03] C identificador (ID) do Field
						"D" 					,; 	// [04] C Tipo do campo
						8						,; 	// [05] N Tamanho do campo
						0 						,; 	// [06] N Decimal do campo
						{ || .T. } 				,; 	// [07] B Code-block de validação do campo
						{ || .T. }				,; 	// [08] B Code-block de validação When do campo
						 						,; 	// [09] A Lista de valores permitido do campo
				      	.F. 					,;	// [10] L Indica se o campo tem preenchimento obrigatório
												,; 	// [11] B Code-block de inicializacao do campo
						.F. 					,;	// [12] L Indica se trata de um campo chave
						.F.		 				,; 	// [13] L Indica se o campo pode receber valor em uma operação de update.
						.F. )  	            		// [14] L Indica se o campo é virtual

	oStruct:AddField(	" "						,; 	// [01] C Titulo do campo
						"E1_VALOR"				,; 	// [02] C ToolTip do campo
						"E1_VALOR"	 			,; 	// [03] C identificador (ID) do Field
						"N" 					,; 	// [04] C Tipo do campo
						16						,; 	// [05] N Tamanho do campo
						2 						,; 	// [06] N Decimal do campo
						{ || .T. } 				,; 	// [07] B Code-block de validação do campo
						{ || .T. }				,; 	// [08] B Code-block de validação When do campo
						 						,; 	// [09] A Lista de valores permitido do campo
				      	.F. 					,;	// [10] L Indica se o campo tem preenchimento obrigatório
												,; 	// [11] B Code-block de inicializacao do campo
						.F. 					,;	// [12] L Indica se trata de um campo chave
						.F.		 				,; 	// [13] L Indica se o campo pode receber valor em uma operação de update.
						.F. )  	            		// [14] L Indica se o campo é virtual

	oStruct:AddField(	" "						,; 	// [01] C Titulo do campo
						"E1_SALDO"				,; 	// [02] C ToolTip do campo
						"E1_SALDO"	 			,; 	// [03] C identificador (ID) do Field
						"N" 					,; 	// [04] C Tipo do campo
						16						,; 	// [05] N Tamanho do campo
						2 						,; 	// [06] N Decimal do campo
						{ || .T. } 				,; 	// [07] B Code-block de validação do campo
						{ || .T. }				,; 	// [08] B Code-block de validação When do campo
						 						,; 	// [09] A Lista de valores permitido do campo
				      	.F. 					,;	// [10] L Indica se o campo tem preenchimento obrigatório
												,; 	// [11] B Code-block de inicializacao do campo
						.F. 					,;	// [12] L Indica se trata de um campo chave
						.F.		 				,; 	// [13] L Indica se o campo pode receber valor em uma operação de update.
						.F. )  	            		// [14] L Indica se o campo é virtual

	oStruct:AddField(	" "						,; 	// [01] C Titulo do campo
						"E1_SDACRES"			,; 	// [02] C ToolTip do campo
						"E1_SDACRES"	 		,; 	// [03] C identificador (ID) do Field
						"N" 					,; 	// [04] C Tipo do campo
						16						,; 	// [05] N Tamanho do campo
						2 						,; 	// [06] N Decimal do campo
						{ || .T. } 				,; 	// [07] B Code-block de validação do campo
						{ || .T. }				,; 	// [08] B Code-block de validação When do campo
						 						,; 	// [09] A Lista de valores permitido do campo
				      	.F. 					,;	// [10] L Indica se o campo tem preenchimento obrigatório
												,; 	// [11] B Code-block de inicializacao do campo
						.F. 					,;	// [12] L Indica se trata de um campo chave
						.F.		 				,; 	// [13] L Indica se o campo pode receber valor em uma operação de update.
						.F. )  	            		// [14] L Indica se o campo é virtual

	oStruct:AddField(	" "						,; 	// [01] C Titulo do campo
						"E1_SDDECRE"			,; 	// [02] C ToolTip do campo
						"E1_SDDECRE"	 		,; 	// [03] C identificador (ID) do Field
						"N" 					,; 	// [04] C Tipo do campo
						16						,; 	// [05] N Tamanho do campo
						2 						,; 	// [06] N Decimal do campo
						{ || .T. } 				,; 	// [07] B Code-block de validação do campo
						{ || .T. }				,; 	// [08] B Code-block de validação When do campo
						 						,; 	// [09] A Lista de valores permitido do campo
				      	.F. 					,;	// [10] L Indica se o campo tem preenchimento obrigatório
												,; 	// [11] B Code-block de inicializacao do campo
						.F. 					,;	// [12] L Indica se trata de um campo chave
						.F.		 				,; 	// [13] L Indica se o campo pode receber valor em uma operação de update.
						.F. )  	            		// [14] L Indica se o campo é virtual

	oStruct:AddField(	" "						,; 	// [01] C Titulo do campo
						"E1_DESCONT"			,; 	// [02] C ToolTip do campo
						"E1_DESCONT"	 		,; 	// [03] C identificador (ID) do Field
						"N" 					,; 	// [04] C Tipo do campo
						16						,; 	// [05] N Tamanho do campo
						2 						,; 	// [06] N Decimal do campo
						{ || .T. } 				,; 	// [07] B Code-block de validação do campo
						{ || .T. }				,; 	// [08] B Code-block de validação When do campo
						 						,; 	// [09] A Lista de valores permitido do campo
				      	.F. 					,;	// [10] L Indica se o campo tem preenchimento obrigatório
												,; 	// [11] B Code-block de inicializacao do campo
						.F. 					,;	// [12] L Indica se trata de um campo chave
						.F.		 				,; 	// [13] L Indica se o campo pode receber valor em uma operação de update.
						.F. )  	            		// [14] L Indica se o campo é virtual

	oStruct:AddField(	" "						,; 	// [01] C Titulo do campo
						"E1_MULTA"				,; 	// [02] C ToolTip do campo
						"E1_MULTA"	 			,; 	// [03] C identificador (ID) do Field
						"N" 					,; 	// [04] C Tipo do campo
						16						,; 	// [05] N Tamanho do campo
						2 						,; 	// [06] N Decimal do campo
						{ || .T. } 				,; 	// [07] B Code-block de validação do campo
						{ || .T. }				,; 	// [08] B Code-block de validação When do campo
						 						,; 	// [09] A Lista de valores permitido do campo
				      	.F. 					,;	// [10] L Indica se o campo tem preenchimento obrigatório
												,; 	// [11] B Code-block de inicializacao do campo
						.F. 					,;	// [12] L Indica se trata de um campo chave
						.F.		 				,; 	// [13] L Indica se o campo pode receber valor em uma operação de update.
						.F. )  	            		// [14] L Indica se o campo é virtual

	oStruct:AddField(	" "						,; 	// [01] C Titulo do campo
						"E1_JUROS"				,; 	// [02] C ToolTip do campo
						"E1_JUROS"	 			,; 	// [03] C identificador (ID) do Field
						"N" 					,; 	// [04] C Tipo do campo
						16						,; 	// [05] N Tamanho do campo
						2						,; 	// [06] N Decimal do campo
						{ || .T. } 				,; 	// [07] B Code-block de validação do campo
						{ || .T. }				,; 	// [08] B Code-block de validação When do campo
						 						,; 	// [09] A Lista de valores permitido do campo
				      	.F. 					,;	// [10] L Indica se o campo tem preenchimento obrigatório
												,; 	// [11] B Code-block de inicializacao do campo
						.F. 					,;	// [12] L Indica se trata de um campo chave
						.F.		 				,; 	// [13] L Indica se o campo pode receber valor em uma operação de update.
						.F. )  	            		// [14] L Indica se o campo é virtual

	oStruct:AddField(	" "						,; 	// [01] C Titulo do campo
						"E1_ZVALOR"				,; 	// [02] C ToolTip do campo
						"E1_ZVALOR"	 			,; 	// [03] C identificador (ID) do Field
						"N" 					,; 	// [04] C Tipo do campo
						16						,; 	// [05] N Tamanho do campo
						2 						,; 	// [06] N Decimal do campo
						{ || .T. } 				,; 	// [07] B Code-block de validação do campo
						{ || .T. }				,; 	// [08] B Code-block de validação When do campo
						 						,; 	// [09] A Lista de valores permitido do campo
				      	.F. 					,;	// [10] L Indica se o campo tem preenchimento obrigatório
												,; 	// [11] B Code-block de inicializacao do campo
						.F. 					,;	// [12] L Indica se trata de um campo chave
						.F.		 				,; 	// [13] L Indica se o campo pode receber valor em uma operação de update.
						.F. )  	            		// [14] L Indica se o campo é virtual

Return oStruct

Static Function gtVwTop()

	Local oStruct := FWFormViewStruct():New()

	//Adicionando o campo Chave para ser exibido
	oStruct:AddField(;
		"CMP_X",;                	// [01]  C   Nome do Campo
		"01",;                      // [02]  C   Ordem
		"Campo",;                   // [03]  C   Titulo do campo
		"Campo Principal",;         // [04]  C   Descricao do campo X3Descric('X5_TABELA')
		Nil,;                       // [05]  A   Array com Help
		"C",;                       // [06]  C   Tipo do campo
		"",;                        // [07]  C   Picture X3Picture("X5_TABELA")
		Nil,;                       // [08]  B   Bloco de PictTre Var
		Nil,;                       // [09]  C   Consulta F3
		.F.,;                       // [10]  L   Indica se o campo é alteravel Iif(INCLUI, .T., .F.)
		Nil,;                       // [11]  C   Pasta do campo
		Nil,;                       // [12]  C   Agrupamento do campo
		Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
		Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
		Nil,;                       // [15]  C   Inicializador de Browse
		Nil,;                       // [16]  L   Indica se o campo é virtual
		Nil,;                       // [17]  C   Picture Variavel
		Nil)                        // [18]  L   Indica pulo de linha após o campo

return oStruct

Static Function gtVwCente()

	local oStruct := FWFormViewStruct():New()

	//Adicionando o campo Chave para ser exibido
	oStruct:AddField(;
		"E1_ZFLAG",;               // [01]  C   Nome do Campo
		"01",;                      // [02]  C   Ordem
		"Flag",;                  // [03]  C   Titulo do campo
		"Flag",;    				// [04]  C   Descricao do campo
		Nil,;                       // [05]  A   Array com Help
		"C",;                       // [06]  C   Tipo do campo
		Nil,;    					// [07]  C   Picture
		Nil,;                       // [08]  B   Bloco de PictTre Var
		Nil,;                       // [09]  C   Consulta F3
		.T.,;                       // [10]  L   Indica se o campo é alteravel Iif(INCLUI, .T., .F.)
		Nil,;                       // [11]  C   Pasta do campo
		Nil,;                       // [12]  C   Agrupamento do campo
		Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
		Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
		Nil,;                       // [15]  C   Inicializador de Browse
		Nil,;                       // [16]  L   Indica se o campo é virtual
		Nil,;                       // [17]  C   Picture Variavel
		Nil)                        // [18]  L   Indica pulo de linha após o campo

	oStruct:AddField(;
		"E1_FILIAL",;               // [01]  C   Nome do Campo
		"01",;                      // [02]  C   Ordem
		"Filial",;                  // [03]  C   Titulo do campo
		"FILIAL",;    				// [04]  C   Descricao do campo
		Nil,;                       // [05]  A   Array com Help
		"C",;                       // [06]  C   Tipo do campo
		Nil,;    					// [07]  C   Picture
		Nil,;                       // [08]  B   Bloco de PictTre Var
		Nil,;                       // [09]  C   Consulta F3
		.F.,;                       // [10]  L   Indica se o campo é alteravel Iif(INCLUI, .T., .F.)
		Nil,;                       // [11]  C   Pasta do campo
		Nil,;                       // [12]  C   Agrupamento do campo
		Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
		Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
		Nil,;                       // [15]  C   Inicializador de Browse
		Nil,;                       // [16]  L   Indica se o campo é virtual
		Nil,;                       // [17]  C   Picture Variavel
		Nil)                        // [18]  L   Indica pulo de linha após o campo

	oStruct:AddField(;
		"E1_PREFIXO",;              // [01]  C   Nome do Campo
		"02",;                      // [02]  C   Ordem
		"Prefixo",;                 // [03]  C   Titulo do campo
		X3Descric('E1_PREFIXO'),;   // [04]  C   Descricao do campo
		Nil,;                       // [05]  A   Array com Help
		"C",;                       // [06]  C   Tipo do campo
		X3Picture("E1_PREFIXO"),;   // [07]  C   Picture
		Nil,;                       // [08]  B   Bloco de PictTre Var
		Nil,;                       // [09]  C   Consulta F3
		.F.,;                       // [10]  L   Indica se o campo é alteravel Iif(INCLUI, .T., .F.)
		Nil,;                       // [11]  C   Pasta do campo
		Nil,;                       // [12]  C   Agrupamento do campo
		Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
		Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
		Nil,;                       // [15]  C   Inicializador de Browse
		Nil,;                       // [16]  L   Indica se o campo é virtual
		Nil,;                       // [17]  C   Picture Variavel
		Nil)                        // [18]  L   Indica pulo de linha após o campo

	oStruct:AddField(;
		"E1_NUM",;              	// [01]  C   Nome do Campo
		"03",;                      // [02]  C   Ordem
		"Numero",;                  // [03]  C   Titulo do campo
		X3Descric('E1_NUM'),;   	// [04]  C   Descricao do campo
		Nil,;                       // [05]  A   Array com Help
		"C",;                       // [06]  C   Tipo do campo
		X3Picture("E1_NUM"),;   	// [07]  C   Picture
		Nil,;                       // [08]  B   Bloco de PictTre Var
		Nil,;                       // [09]  C   Consulta F3
		.F.,;                       // [10]  L   Indica se o campo é alteravel Iif(INCLUI, .T., .F.)
		Nil,;                       // [11]  C   Pasta do campo
		Nil,;                       // [12]  C   Agrupamento do campo
		Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
		Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
		Nil,;                       // [15]  C   Inicializador de Browse
		Nil,;                       // [16]  L   Indica se o campo é virtual
		Nil,;                       // [17]  C   Picture Variavel
		Nil)                        // [18]  L   Indica pulo de linha após o campo

	oStruct:AddField(;
		"E1_PARCELA",;              // [01]  C   Nome do Campo
		"04",;                      // [02]  C   Ordem
		"Parcela",;                 // [03]  C   Titulo do campo
		X3Descric('E1_PARCELA'),;   // [04]  C   Descricao do campo
		Nil,;                       // [05]  A   Array com Help
		"C",;                       // [06]  C   Tipo do campo
		X3Picture("E1_PARCELA"),;   // [07]  C   Picture
		Nil,;                       // [08]  B   Bloco de PictTre Var
		Nil,;                       // [09]  C   Consulta F3
		.F.,;                       // [10]  L   Indica se o campo é alteravel Iif(INCLUI, .T., .F.)
		Nil,;                       // [11]  C   Pasta do campo
		Nil,;                       // [12]  C   Agrupamento do campo
		Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
		Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
		Nil,;                       // [15]  C   Inicializador de Browse
		Nil,;                       // [16]  L   Indica se o campo é virtual
		Nil,;                       // [17]  C   Picture Variavel
		Nil)                        // [18]  L   Indica pulo de linha após o campo

	oStruct:AddField(;
		"E1_TIPO",;              	// [01]  C   Nome do Campo
		"05",;                      // [02]  C   Ordem
		"Tipo",;                    // [03]  C   Titulo do campo
		X3Descric('E1_TIPO'),;   	// [04]  C   Descricao do campo
		Nil,;                       // [05]  A   Array com Help
		"C",;                       // [06]  C   Tipo do campo
		X3Picture("E1_TIPO"),;   	// [07]  C   Picture
		Nil,;                       // [08]  B   Bloco de PictTre Var
		Nil,;                       // [09]  C   Consulta F3
		.F.,;                       // [10]  L   Indica se o campo é alteravel Iif(INCLUI, .T., .F.)
		Nil,;                       // [11]  C   Pasta do campo
		Nil,;                       // [12]  C   Agrupamento do campo
		Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
		Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
		Nil,;                       // [15]  C   Inicializador de Browse
		Nil,;                       // [16]  L   Indica se o campo é virtual
		Nil,;                       // [17]  C   Picture Variavel
		Nil)                        // [18]  L   Indica pulo de linha após o campo


	oStruct:AddField(;
		"E1_NATUREZ",;              // [01]  C   Nome do Campo
		"06",;                      // [02]  C   Ordem
		"Natureza",;                // [03]  C   Titulo do campo
		X3Descric('E1_NATUREZ'),;   // [04]  C   Descricao do campo
		Nil,;                       // [05]  A   Array com Help
		"C",;                       // [06]  C   Tipo do campo
		X3Picture("E1_NATUREZ"),;   // [07]  C   Picture
		Nil,;                       // [08]  B   Bloco de PictTre Var
		Nil,;                       // [09]  C   Consulta F3
		.F.,;                       // [10]  L   Indica se o campo é alteravel Iif(INCLUI, .T., .F.)
		Nil,;                       // [11]  C   Pasta do campo
		Nil,;                       // [12]  C   Agrupamento do campo
		Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
		Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
		Nil,;                       // [15]  C   Inicializador de Browse
		Nil,;                       // [16]  L   Indica se o campo é virtual
		Nil,;                       // [17]  C   Picture Variavel
		Nil)                        // [18]  L   Indica pulo de linha após o campo

oStruct:AddField(;
		"E1_CLIENTE",;              // [01]  C   Nome do Campo
		"07",;                      // [02]  C   Ordem
		"Cliente",;                	// [03]  C   Titulo do campo
		X3Descric('E1_CLIENTE'),;   // [04]  C   Descricao do campo
		Nil,;                       // [05]  A   Array com Help
		"C",;                       // [06]  C   Tipo do campo
		X3Picture("E1_CLIENTE"),;   // [07]  C   Picture
		Nil,;                       // [08]  B   Bloco de PictTre Var
		Nil,;                       // [09]  C   Consulta F3
		.F.,;                       // [10]  L   Indica se o campo é alteravel Iif(INCLUI, .T., .F.)
		Nil,;                       // [11]  C   Pasta do campo
		Nil,;                       // [12]  C   Agrupamento do campo
		Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
		Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
		Nil,;                       // [15]  C   Inicializador de Browse
		Nil,;                       // [16]  L   Indica se o campo é virtual
		Nil,;                       // [17]  C   Picture Variavel
		Nil)                        // [18]  L   Indica pulo de linha após o campo

oStruct:AddField(;
		"E1_LOJA",;              	// [01]  C   Nome do Campo
		"08",;                      // [02]  C   Ordem
		"Loja",;                	// [03]  C   Titulo do campo
		X3Descric('E1_LOJA'),;   	// [04]  C   Descricao do campo
		Nil,;                       // [05]  A   Array com Help
		"C",;                       // [06]  C   Tipo do campo
		X3Picture("E1_LOJA"),;   	// [07]  C   Picture
		Nil,;                       // [08]  B   Bloco de PictTre Var
		Nil,;                       // [09]  C   Consulta F3
		.F.,;                       // [10]  L   Indica se o campo é alteravel Iif(INCLUI, .T., .F.)
		Nil,;                       // [11]  C   Pasta do campo
		Nil,;                       // [12]  C   Agrupamento do campo
		Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
		Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
		Nil,;                       // [15]  C   Inicializador de Browse
		Nil,;                       // [16]  L   Indica se o campo é virtual
		Nil,;                       // [17]  C   Picture Variavel
		Nil)                        // [18]  L   Indica pulo de linha após o campo

oStruct:AddField(;
		"E1_NOMCLI",;              	// [01]  C   Nome do Campo
		"09",;                      // [02]  C   Ordem
		"Nome",;                	// [03]  C   Titulo do campo
		X3Descric('E1_NOMCLI'),;   	// [04]  C   Descricao do campo
		Nil,;                       // [05]  A   Array com Help
		"C",;                       // [06]  C   Tipo do campo
		X3Picture("E1_NOMCLI"),;   	// [07]  C   Picture
		Nil,;                       // [08]  B   Bloco de PictTre Var
		Nil,;                       // [09]  C   Consulta F3
		.F.,;                       // [10]  L   Indica se o campo é alteravel Iif(INCLUI, .T., .F.)
		Nil,;                       // [11]  C   Pasta do campo
		Nil,;                       // [12]  C   Agrupamento do campo
		Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
		Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
		Nil,;                       // [15]  C   Inicializador de Browse
		Nil,;                       // [16]  L   Indica se o campo é virtual
		Nil,;                       // [17]  C   Picture Variavel
		Nil)                        // [18]  L   Indica pulo de linha após o campo

oStruct:AddField(;
		"E1_EMISSAO",;              // [01]  C   Nome do Campo
		"10",;                      // [02]  C   Ordem
		"Emissão",;                	// [03]  C   Titulo do campo
		X3Descric('E1_EMISSAO'),;   // [04]  C   Descricao do campo
		Nil,;                       // [05]  A   Array com Help
		"D",;                       // [06]  C   Tipo do campo
		X3Picture("E1_EMISSAO"),;   // [07]  C   Picture
		Nil,;                       // [08]  B   Bloco de PictTre Var
		Nil,;                       // [09]  C   Consulta F3
		.F.,;                       // [10]  L   Indica se o campo é alteravel Iif(INCLUI, .T., .F.)
		Nil,;                       // [11]  C   Pasta do campo
		Nil,;                       // [12]  C   Agrupamento do campo
		Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
		Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
		Nil,;                       // [15]  C   Inicializador de Browse
		Nil,;                       // [16]  L   Indica se o campo é virtual
		Nil,;                       // [17]  C   Picture Variavel
		Nil)                        // [18]  L   Indica pulo de linha após o campo

oStruct:AddField(;
		"E1_VENCTO",;              	// [01]  C   Nome do Campo
		"11",;                      // [02]  C   Ordem
		"Vencimento",;              // [03]  C   Titulo do campo
		X3Descric('E1_VENCTO'),;   	// [04]  C   Descricao do campo
		Nil,;                       // [05]  A   Array com Help
		"D",;                       // [06]  C   Tipo do campo
		X3Picture("E1_VENCTO"),;   	// [07]  C   Picture
		Nil,;                       // [08]  B   Bloco de PictTre Var
		Nil,;                       // [09]  C   Consulta F3
		.F.,;                       // [10]  L   Indica se o campo é alteravel Iif(INCLUI, .T., .F.)
		Nil,;                       // [11]  C   Pasta do campo
		Nil,;                       // [12]  C   Agrupamento do campo
		Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
		Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
		Nil,;                       // [15]  C   Inicializador de Browse
		Nil,;                       // [16]  L   Indica se o campo é virtual
		Nil,;                       // [17]  C   Picture Variavel
		Nil)                        // [18]  L   Indica pulo de linha após o campo

oStruct:AddField(;
		"E1_VENCREA",;              // [01]  C   Nome do Campo
		"12",;                      // [02]  C   Ordem
		"Venc. Real",;             	// [03]  C   Titulo do campo
		X3Descric('E1_VENCREA'),;   // [04]  C   Descricao do campo
		Nil,;                       // [05]  A   Array com Help
		"D",;                       // [06]  C   Tipo do campo
		X3Picture("E1_VENCREA"),;   // [07]  C   Picture
		Nil,;                       // [08]  B   Bloco de PictTre Var
		Nil,;                       // [09]  C   Consulta F3
		.F.,;                       // [10]  L   Indica se o campo é alteravel Iif(INCLUI, .T., .F.)
		Nil,;                       // [11]  C   Pasta do campo
		Nil,;                       // [12]  C   Agrupamento do campo
		Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
		Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
		Nil,;                       // [15]  C   Inicializador de Browse
		Nil,;                       // [16]  L   Indica se o campo é virtual
		Nil,;                       // [17]  C   Picture Variavel
		Nil)                        // [18]  L   Indica pulo de linha após o campo

oStruct:AddField(;
		"E1_VALOR",;              	// [01]  C   Nome do Campo
		"13",;                      // [02]  C   Ordem
		"Valor",;                	// [03]  C   Titulo do campo
		X3Descric('E1_VALOR'),;   	// [04]  C   Descricao do campo
		Nil,;                       // [05]  A   Array com Help
		"N",;                       // [06]  C   Tipo do campo
		X3Picture("E1_VALOR"),;   	// [07]  C   Picture
		Nil,;                       // [08]  B   Bloco de PictTre Var
		Nil,;                       // [09]  C   Consulta F3
		.F.,;                       // [10]  L   Indica se o campo é alteravel Iif(INCLUI, .T., .F.)
		Nil,;                       // [11]  C   Pasta do campo
		Nil,;                       // [12]  C   Agrupamento do campo
		Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
		Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
		Nil,;                       // [15]  C   Inicializador de Browse
		Nil,;                       // [16]  L   Indica se o campo é virtual
		Nil,;                       // [17]  C   Picture Variavel
		Nil)                        // [18]  L   Indica pulo de linha após o campo

oStruct:AddField(;
		"E1_SALDO",;              	// [01]  C   Nome do Campo
		"14",;                      // [02]  C   Ordem
		"Saldo",;                	// [03]  C   Titulo do campo
		X3Descric('E1_SALDO'),;   	// [04]  C   Descricao do campo
		Nil,;                       // [05]  A   Array com Help
		"N",;                       // [06]  C   Tipo do campo
		X3Picture("E1_SALDO"),;   	// [07]  C   Picture
		Nil,;                       // [08]  B   Bloco de PictTre Var
		Nil,;                       // [09]  C   Consulta F3
		.F.,;                       // [10]  L   Indica se o campo é alteravel Iif(INCLUI, .T., .F.)
		Nil,;                       // [11]  C   Pasta do campo
		Nil,;                       // [12]  C   Agrupamento do campo
		Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
		Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
		Nil,;                       // [15]  C   Inicializador de Browse
		Nil,;                       // [16]  L   Indica se o campo é virtual
		Nil,;                       // [17]  C   Picture Variavel
		Nil)                        // [18]  L   Indica pulo de linha após o campo

oStruct:AddField(;
		"E1_SDACRES",;             // [01]  C   Nome do Campo
		"15",;                      // [02]  C   Ordem
		"Acréscimo",;               // [03]  C   Titulo do campo
		X3Descric('E1_SDACRES'),;  // [04]  C   Descricao do campo
		Nil,;                       // [05]  A   Array com Help
		"N",;                       // [06]  C   Tipo do campo
		X3Picture("E1_SDACRES"),;  // [07]  C   Picture
		Nil,;                       // [08]  B   Bloco de PictTre Var
		Nil,;                       // [09]  C   Consulta F3
		.F.,;                       // [10]  L   Indica se o campo é alteravel Iif(INCLUI, .T., .F.)
		Nil,;                       // [11]  C   Pasta do campo
		Nil,;                       // [12]  C   Agrupamento do campo
		Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
		Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
		Nil,;                       // [15]  C   Inicializador de Browse
		Nil,;                       // [16]  L   Indica se o campo é virtual
		Nil,;                       // [17]  C   Picture Variavel
		Nil)                        // [18]  L   Indica pulo de linha após o campo

oStruct:AddField(;
		"E1_SDDECRE",;              // [01]  C   Nome do Campo
		"16",;                      // [02]  C   Ordem
		"Decréscimo",;            	// [03]  C   Titulo do campo
		X3Descric('E1_SDDECRE'),;  	// [04]  C   Descricao do campo
		Nil,;                       // [05]  A   Array com Help
		"N",;                       // [06]  C   Tipo do campo
		X3Picture("E1_SDDECRE"),;   // [07]  C   Picture
		Nil,;                       // [08]  B   Bloco de PictTre Var
		Nil,;                       // [09]  C   Consulta F3
		.F.,;                       // [10]  L   Indica se o campo é alteravel Iif(INCLUI, .T., .F.)
		Nil,;                       // [11]  C   Pasta do campo
		Nil,;                       // [12]  C   Agrupamento do campo
		Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
		Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
		Nil,;                       // [15]  C   Inicializador de Browse
		Nil,;                       // [16]  L   Indica se o campo é virtual
		Nil,;                       // [17]  C   Picture Variavel
		Nil)                        // [18]  L   Indica pulo de linha após o campo

oStruct:AddField(;
		"E1_DESCONT",;              // [01]  C   Nome do Campo
		"17",;                      // [02]  C   Ordem
		"Desconto",;               	// [03]  C   Titulo do campo
		X3Descric('E1_DESCONT'),;  	// [04]  C   Descricao do campo
		Nil,;                       // [05]  A   Array com Help
		"N",;                       // [06]  C   Tipo do campo
		X3Picture("E1_DESCONT"),;  	// [07]  C   Picture
		Nil,;                       // [08]  B   Bloco de PictTre Var
		Nil,;                       // [09]  C   Consulta F3
		.F.,;                       // [10]  L   Indica se o campo é alteravel Iif(INCLUI, .T., .F.)
		Nil,;                       // [11]  C   Pasta do campo
		Nil,;                       // [12]  C   Agrupamento do campo
		Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
		Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
		Nil,;                       // [15]  C   Inicializador de Browse
		Nil,;                       // [16]  L   Indica se o campo é virtual
		Nil,;                       // [17]  C   Picture Variavel
		Nil)                        // [18]  L   Indica pulo de linha após o campo

oStruct:AddField(;
		"E1_MULTA",;              	// [01]  C   Nome do Campo
		"18",;                      // [02]  C   Ordem
		"Multa",;                	// [03]  C   Titulo do campo
		X3Descric('E1_MULTA'),;   	// [04]  C   Descricao do campo
		Nil,;                       // [05]  A   Array com Help
		"N",;                       // [06]  C   Tipo do campo
		X3Picture("E1_MULTA"),;   	// [07]  C   Picture
		Nil,;                       // [08]  B   Bloco de PictTre Var
		Nil,;                       // [09]  C   Consulta F3
		.F.,;                       // [10]  L   Indica se o campo é alteravel Iif(INCLUI, .T., .F.)
		Nil,;                       // [11]  C   Pasta do campo
		Nil,;                       // [12]  C   Agrupamento do campo
		Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
		Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
		Nil,;                       // [15]  C   Inicializador de Browse
		Nil,;                       // [16]  L   Indica se o campo é virtual
		Nil,;                       // [17]  C   Picture Variavel
		Nil)                        // [18]  L   Indica pulo de linha após o campo

oStruct:AddField(;
		"E1_JUROS",;              	// [01]  C   Nome do Campo
		"19",;                      // [02]  C   Ordem
		"Juros",;                	// [03]  C   Titulo do campo
		X3Descric('E1_JUROS'),;   	// [04]  C   Descricao do campo
		Nil,;                       // [05]  A   Array com Help
		"N",;                       // [06]  C   Tipo do campo
		X3Picture("E1_JUROS"),;   	// [07]  C   Picture
		Nil,;                       // [08]  B   Bloco de PictTre Var
		Nil,;                       // [09]  C   Consulta F3
		.F.,;                       // [10]  L   Indica se o campo é alteravel Iif(INCLUI, .T., .F.)
		Nil,;                       // [11]  C   Pasta do campo
		Nil,;                       // [12]  C   Agrupamento do campo
		Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
		Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
		Nil,;                       // [15]  C   Inicializador de Browse
		Nil,;                       // [16]  L   Indica se o campo é virtual
		Nil,;                       // [17]  C   Picture Variavel
		Nil)                        // [18]  L   Indica pulo de linha após o campo

oStruct:AddField(;
		"E1_ZVALOR",;              	// [01]  C   Nome do Campo
		"20",;                      // [02]  C   Ordem
		"Val. Recebido",;          	// [03]  C   Titulo do campo
		X3Descric('E1_VALOR'),;   	// [04]  C   Descricao do campo
		Nil,;                       // [05]  A   Array com Help
		"N",;                       // [06]  C   Tipo do campo
		X3Picture("E1_VALOR"),;   	// [07]  C   Picture
		Nil,;                       // [08]  B   Bloco de PictTre Var
		Nil,;                       // [09]  C   Consulta F3
		.F.,;                       // [10]  L   Indica se o campo é alteravel Iif(INCLUI, .T., .F.)
		Nil,;                       // [11]  C   Pasta do campo
		Nil,;                       // [12]  C   Agrupamento do campo
		Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
		Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
		Nil,;                       // [15]  C   Inicializador de Browse
		Nil,;                       // [16]  L   Indica se o campo é virtual
		Nil,;                       // [17]  C   Picture Variavel
		Nil)                        // [18]  L   Indica pulo de linha após o campo

/*	E1_FILIAL
	E1_PREFIXO
	E1_NUM
	E1_PARCELA
	E1_TIPO
	E1_NATUREZ
	E1_CLIENTE
	E1_LOJA
	E1_NOMCLI
	E1_EMISSAO
	E1_VENCTO
	E1_VENCREA
	E1_VALOR
	E1_SALDO
	E1_SDACRES
	E1_SDDECRE
	E1_DESCONT
	E1_MULTA
	E1_JUROS
	E1_VALOR - E1_SALDO*/

return oStruct

Static Function xMarkAll()

	Local oModel 	:= FwModelActive()
	Local oMdlCent  := oModel:GetModel("CENTER")
	Local ni		:= 0

	For ni := 1 to oMdlCent:Length()
		oMdlCent:GoLine(ni)
		If oMdlCent:GetValue("E1_ZFLAG")
			oMdlCent:SetValue("E1_ZFLAG",.F.)
		Else
			oMdlCent:SetValue("E1_ZFLAG",.T.)
		EndIf
	Next ni

	oMdlCent:GoLine(1)

return

Static Function xCommit(oModel)

	Local lRet := .T.

	xProcMarc(oModel)

	//oModel:DeActivate()

return lRet

Static Function xProcMarc(oModel)

	Local oMdlCent  := oModel:GetModel("CENTER")
	Local ni		:= 1

	For ni := 1 to oMdlCent:Length()
		oMdlCent:GoLine(ni)
		If oMdlCent:GetValue("E1_ZFLAG")
			xGrvSE1(oMdlCent)
		Endif
	Next ni

Return

Static Function xGrvSE1(oMdlCent)

	Local aArea 	:= GetArea()
	Local aAreaSE1	:= SE1->(GetArea())
	Local aAreaSEB  := SEB->(GetArea())
	Local dDataOld	:= Date()
	Local dDtValida := DataValida(MV_PAR11,.T.)

	dbSelectArea("SE1")
	SE1->(dbSetOrder(1))//E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO

	If SE1->(dbSeek( oMdlCent:GetValue("E1_FILIAL") + oMdlCent:GetValue("E1_PREFIXO") + oMdlCent:GetValue("E1_NUM") + oMdlCent:GetValue("E1_PARCELA") + oMdlCent:GetValue("E1_TIPO") ))

		dDataOld := SE1->E1_VENCREA

		RecLock("SE1",.F.)
			SE1->E1_VENCTO 	:= MV_PAR11//oMdlCent:GetValue("E1_VENCTO")
			SE1->E1_VENCREA := dDtValida//oMdlCent:GetValue("E1_VENCREA")
			SE1->E1_HIST	:= SUBSTR(ALLTRIM(SE1->E1_HIST) + " - " + ALLTRIM(MV_PAR12),1,TamSX3("E1_HIST")[1])
		SE1->(MsUnLock())

		If !Empty(SE1->E1_PORTADO) .AND. ( !(Empty(SE1->E1_IDCNAB)) .OR. !(Empty(SE1->E1_ZIDCNAB)) )
			dbSelectArea("SEB")
			SEB->(dbSetOrder(1))//EB_FILIAL+EB_BANCO+EB_REFBAN+EB_TIPO+EB_MOTBAN
			IF SEB->(DBSEEK(xFilial("SEB",SE1->E1_FILIAL) + SE1->E1_PORTADO + MV_PAR15 + 'R' ))
				dbSelectArea("FI2")
				FI2->(dbSetOrder(1))//FI2_FILIAL+FI2_CARTEI+FI2_NUMBOR+FI2_PREFIX+FI2_TITULO+FI2_PARCEL+FI2_TIPO+FI2_CODCLI+FI2_LOJCLI+FI2_OCORR+FI2_GERADO
				If FI2->(dbSeek(xFilial("FI2",SE1->E1_FILIAL) + SE1->E1_SITUACA + SE1->E1_NUMBOR + SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA + SE1->E1_TIPO + SE1->E1_CLIENTE + SE1->E1_LOJA + SEB->EB_OCORR + '2' ))
					RecLock("FI2",.F.)
					FI2->FI2_DTOCOR := Date()
					FI2->FI2_DTGER  := Date()
					FI2->FI2_VALANT := dToC(dDataOld)
					FI2->FI2_VALNOV := dToC(SE1->E1_VENCREA)
					FI2->FI2_CAMPO  := "E1_VENCREA"
					FI2->(MsUnlock())
				Else
					RecLock("FI2",.T.)
					FI2->FI2_FILIAL  := xFilial("FI2",SE1->E1_FILIAL)
					FI2->FI2_CARTEI := SE1->E1_SITUACA
					FI2->FI2_NUMBOR := SE1->E1_NUMBOR
					FI2->FI2_PREFIX := SE1->E1_PREFIXO
					FI2->FI2_TITULO := SE1->E1_NUM
					FI2->FI2_PARCEL := SE1->E1_PARCELA
					FI2->FI2_TIPO   := SE1->E1_TIPO
					FI2->FI2_CODCLI := SE1->E1_CLIENTE
					FI2->FI2_LOJCLI := SE1->E1_LOJA
					FI2->FI2_DTOCOR := Date()
					FI2->FI2_DTGER  := Date()
					FI2->FI2_OCORR  := SEB->EB_OCORR
					FI2->FI2_DESCOC := SEB->EB_DESCRI
					FI2->FI2_GERADO := '2'
					FI2->FI2_VALANT := dToC(dDataOld)
					FI2->FI2_VALNOV := dToC(SE1->E1_VENCREA)
					FI2->FI2_CAMPO  := "E1_VENCREA"
					FI2->(MsUnlock())
				EndIf
			EndIf
		EndIf

	EndIf

	RestArea(aAreaSEB)
	RestArea(aAreaSE1)
	RestArea(aArea)

Return

