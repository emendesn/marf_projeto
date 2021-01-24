#Include 'Protheus.ch'
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "FWBROWSE.CH"

/*
=====================================================================================
Programa............: MGFFIN17
Autor...............: Joni Lima
Data................: 04/10/2016
Descrição / Objetivo: Bloquear Clientes não tiveram faturamento nos ultimos 180 dias e são diferente de REDE
Doc. Origem.........: Contrato - GAP CRE11
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Tela de Marcação de Clientes para bloqueio
=====================================================================================
*/
User Function MGFFIN17()

	Local cFiltro := "A1_MSBLQL<>'1'"
	Local cBasFil := ""
	Local nDias   := SuperGetMV("MGF_FIN17A",.F.,180) //quantidade de dias para bloqueio
	Local bFilter := ''

	Static oBrw := Nil

	Private cCadastro := 'Clientes inativos'

	//Filtro padrão executado na Tela
	cFiltro := "A1_MSBLQL<>'1' .AND. "
	cFiltro += "U_xMF17VBL(A1_ZREDE) .AND. "
	cFiltro += "DateDiffDay(A1_DTCAD,dDataBase) > " + cValtoChar(nDias) + " .AND."
	cFiltro += "DateDiffDay(A1_ULTCOM,dDataBase) > " + cValtoChar(nDias)

	//Montagem do Browse
	oBrw := FwMarkBrowse():New()

	oBrw:SetAlias('SA1')
	oBrw:SetFieldMark('A1_ZMARK')
	oBrw:SetMenudef('MGFFIN17')
	oBrw:SetIgnoreARotina(.T.)
	oBrw:SetDescription( OEmToAnsi( 'Clientes Inativos' ) ) // Monitor de Check-In

	oBrw:SetFilterDefault( cFiltro )
	oBrw:AllMark()

	oBrw:Activate()

Return

/*
=====================================================================================
Programa............: Menudef
Autor...............: Joni Lima
Data................: 04/10/2016
Descrição / Objetivo: Construção do Menu da Rotina
Doc. Origem.........: Contrato - GAP CRE11
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Menu com as opções de visualização e Bloqueio
=====================================================================================
*/
Static Function Menudef()

	Local aMenu := {}
	ADD OPTION aMenu TITLE 'Visualizar' ACTION 'VIEWDEF.MGFFIN17'	OPERATION 2	ACCESS 0
	ADD OPTION aMenu TITLE 'Bloquear'   ACTION 'U_xMF17BLQ'	OPERATION 7	ACCESS 0
	//aAdd(aMenu,{ 'Visualizar', 'AxVisual'  ,0, 2, 0, .F. } )
	//aAdd(aMenu,{ 'Bloquear'  , 'U_xMF17BLQ',0, 7, 0, .F. } )

Return aMenu

/*/{Protheus.doc} ModelDef
//TODO Relação do clientes.
@author Eugenio
@since 17/04/2017
@version 1.0

@type function
/*/
Static Function ModelDef()

Local oModel   := Nil
Local oStruZDP := FWFormStruct(1,'SA1',/*bAvalCampo*/,/*lViewUsado*/)

//oStruZDP:SetProperty('Z2_FABRIC', MODEL_FIELD_WHEN,{|| INCLUI })  // este campo só pode ser alterado no modo inclusão.

oModel := MPFormModel():New('MODELNAME',/*bPreValidacao*/,/*bPosValidacao*/,/*bCommit*/,/*bCancel*/)
oModel:AddFields('SZ2MASTER',/*cOwner*/,oStruZDP,/*bPreValidacao*/,/*bPosValidacao*/,/*bCarga*/)
oModel:SetDescription('Cadastro de Clientes')

//oModel:GetModel('MODELNAME'):SetDescription('Cadastro Divisão do Painel')

oModel:SetPrimaryKey({})

Return(oModel)

//-------------------------------------------------------------------
/*/{Protheus.doc} VIEWDEF()
Clientes
@author Eugenio Arcanjo
@since 17/04/2017
@version 11
@return oView
/*/
//-------------------------------------------------------------------

Static Function ViewDef()

Local oView    := Nil
Local oModel   := FWLoadModel('MGFFIN17')
Local oStruZDP := FWFormStruct(2,'SA1')

oView := FWFormView():New()
oView:SetModel(oModel)
oView:AddField('VIEW_SZ2', oStruZDP,'SZ2MASTER')
oView:CreateHorizontalBox('TELA',100)
oView:SetOwnerView('VIEW_SZ2','TELA')

Return(oView)


/*
=====================================================================================
Programa............: xMF17BLQ
Autor...............: Joni Lima
Data................: 04/10/2016
Descrição / Objetivo: Chama rotina para Bloqueio dos clientes selecionados no FwMarkBrowse
Doc. Origem.........: Contrato - GAP CRE11
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Chamada da rotina de Bloqueio dos clientes
=====================================================================================
*/
User Function xMF17BLQ()

	Processa({|| xProcBlo17()}, '//Bloqueando Clientes...' )

Return

/*
=====================================================================================
Programa............: xProcBlo17
Autor...............: Joni Lima
Data................: 04/10/2016
Descrição / Objetivo: Chama rotina para Bloqueio dos clientes selecionados no FwMarkBrowse
Doc. Origem.........: Contrato - GAP CRE11
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Chamada da rotina de Bloqueio dos clientes
=====================================================================================
*/
Static Function xProcBlo17()

	Local aArea		:= GetArea()
	Local aAreaSA1 	:= SA1->(GetArea())
	Local aAreaBrw  := oBrw:Alias()
	Local aAreaTmp	:= (aAreaBrw)->(GetArea())
	Local aTemAr    := (aAreaBrw)->(GetArea())
	Local aVetor := {}
	Local lRetorno	:= .T.
	Local lGoTop 	:= .T.
	Local nReg		:= 0
	Local nDias   	:= SuperGetMV("MGF_FIN17A",.F.,180) //quantidade de dias para bloqueio
	Local cMark     := oBrw:Mark()
	Local cFiltro   := ''
	Local _cTxtBlq  := "Usuario: "+SubStr(cUsuario,7,15)+" Data: "+DtoC(ddatabase)+" Aviso: "+GetMV("MGF_TXTBLQ")
	//Local _cTxtBlq  := "Usuario: "+SubStr(cUsuario,7,15)+" Data: "+DtoC(ddatabase)+" Aviso: "+SuperGetMV("MGF_TXTBLQ",,"Bloqueado automático por inatividade ")
	Local cError := ""

	Private lMsHelpAuto := .T. // se .t. direciona as mensagens     de help para o arq. de log
	PRIVATE lMsErroAuto := .F.

	//Filtro padrão executado na Tela
	cFiltro := "A1_MSBLQL<>'1' .AND. "
	cFiltro += "U_xMF17VBL(A1_ZREDE) .AND. "
	cFiltro += "DateDiffDay(A1_DTCAD,dDataBase) > " + cValtoChar(nDias) + " .AND. "
	cFiltro += "DateDiffDay(A1_ULTCOM,dDataBase) > " + cValtoChar(nDias)

	(aAreaBrw)->(DBSetFilter(&('{||' + cFiltro + '}'),cFiltro))

	BEGIN TRANSACTION

		ProcRegua((aAreaBrw)->(RECCOUNT()))

		(aAreaBrw)->(DbGoTop())

		While (aAreaBrw)->(!Eof())

			IncProc((aAreaBrw)->(A1_COD + A1_LOJA) + '  : ' + (aAreaBrw)->(A1_NOME)  )

			If oBrw:IsMark(cMark)

				aTemAr := (aAreaBrw)->(GetArea())

				nReg := (aAreaBrw)->(RECNO())//Pega Recno do Browse

				dbSelectArea('SA1')

				If SA1->(DbGoTo(nReg))//Posiciona na tabela SA1

					recLock("SA1", .F.)
						SA1->A1_ZBLQCRED	:= _cTxtBlq
						SA1->A1_MSBLQL		:= "1"
						If FieldPos("A1_ZINATIV") > 0
							SA1->A1_ZINATIV		:= "1"
							If SA1->A1_XENVECO == "1"
								SA1->A1_XINTECO		:= "0"
							EndIF
						EndIf

						if SA1->A1_PESSOA == "J"
							SA1->A1_XENVSFO	:= "S"
							SA1->A1_XINTSFO	:= "P"
						endif
					SA1->(msUnLock())

/*
					aVetor:={{"A1_COD"       ,(aAreaBrw)->(A1_COD)  ,Nil},; // Codigo
							 {"A1_LOJA"      ,(aAreaBrw)->(A1_LOJA)	,Nil},; // Loja
							 {"A1_ZBLQCRED"  ,_cTxtBlq          	,Nil},; // Texto Bloqueio
							 {"A1_MSBLQL"    ,"1"  					,Nil}} // Bloqueio


					MSExecAuto({|x,y| Mata030(x,y)},aVetor,4) //3- Inclusão, 4- Alteração, 5- Exclusão

					If lMsErroAuto
						If (!IsBlind()) // COM INTERFACE GRÁFICA
								MostraErro()
						    Else // EM ESTADO DE JOB
						        cError := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO

						        ConOut(PadC("Automatic routine ended with error", 80))
						        ConOut("Error: "+ cError)
						    EndIf
						DisarmTransaction()
					Endif
*/
				EndIf

				RestArea(aTemAr)

			EndIf

			(aAreaBrw)->( DbSkip() )

		EndDo

	END TRANSACTION

	RestArea(aAreaTmp)
	RestArea(aAreaSA1)
	RestArea(aArea)

	oBrw:Refresh(lGoTop)

Return lRetorno

/*
=====================================================================================
Programa............: xMF17VBL
Autor...............: Joni Lima
Data................: 05/10/2016
Descrição / Objetivo: Verifica se o cadastro de REDE permite ou não o Bloqueio de inatividades
Doc. Origem.........: Contrato - GAP CRE11
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Chamada da rotina de Bloqueio dos clientes
=====================================================================================
*/
User Function xMF17VBL(cCod)

	Local aArea 	:= GetArea()
	Local aAreaSZQ 	:= SZQ->(GetArea())

	Local lRet := .T.

	If !Empty(cCod)

		dbSelectArea('SZQ')
		SZQ->(dbSetOrder(1))

		If SZQ->(dbSeek( xFilial('SZQ') + cCod ))
			If SZQ->ZQ_BLOQUEIO == 'N'
				lRet := .F.
			EndIf
		EndIf

	EndIf

	RestArea(aAreaSZQ)
	RestArea(aArea)

Return lRet
