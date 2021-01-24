#Include 'Protheus.ch'
#INCLUDE "FWMVCDEF.CH"

#DEFINE LENGENDAFAT 1
#DEFINE LENGENDAFIN 2

Static _nOpcDesp := 0

/*
=====================================================================================
Programa............: MGFFAT07
Autor...............: Joni Lima
Data................: 06/10/2016
Descrição / Objetivo: Cadastro de Aprovadores
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Tela de Cadastro de Aprovadores
=====================================================================================
*/
User Function MGFFAT07()
	
	Local oMBrowse := nil
	Local oColLFat := Nil
	Local oColLFin := Nil
	Local aTESTE	:= {CONTROL_ALIGN_LEFT,CONTROL_ALIGN_CENTER,CONTROL_ALIGN_RIGHT,CONTROL_ALIGN_ALLCLIENT}
	
	oMBrowse:= FWmBrowse():New()
	oMBrowse:SetAlias("SZS")
	oMBrowse:SetDescription('Aprovadores')
	
	//Aprova Faturamento
	oMBrowse:AddLegend( "ZS_APRFAT<>'1'"  , "BR_VERMELHO"   , "Não Aprova", '1' )
	oMBrowse:AddLegend( "ZS_APRFAT=='1'"  , "BR_VERDE" , "Aprova", '1'     )
	
	//Aprova Financeiro
	oMBrowse:AddLegend( "ZS_APRFIN<>'1'"  , "RED"   , "Não Aprova", '2' )
	oMBrowse:AddLegend( "ZS_APRFIN=='1'"  , "GREEN" , "Aprova", '2'     )
	
	oColLFat := oMBrowse:aColumns[LENGENDAFAT]
	oColLFin := oMBrowse:aColumns[LENGENDAFIN]
	
	oColLFat:SetTitle('Aprv.Fatura.')
	oColLFat:SetAutoSize(.F.)
	oColLFat:SetSIZE(80)
		
	oColLFin:SetTitle('Aprv.Financ.')
	oColLFin:SetAutoSize(.F.)
	oColLFin:SetSIZE(80)
	
	oMBrowse:Activate()
	
Return

/*
=====================================================================================
Programa............: MenuDef
Autor...............: Joni Lima
Data................: 06/10/2016
Descrição / Objetivo: MenuDef da rotina
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Definição do Menu
=====================================================================================
*/
Static Function MenuDef()
	
	Local	aRotina	:= {}
	
	ADD OPTION aRotina TITLE "Pesquisar"  ACTION "PesqBrw"          OPERATION 1                      ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.MGFFAT07" OPERATION MODEL_OPERATION_VIEW   ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"    ACTION "VIEWDEF.MGFFAT07" OPERATION MODEL_OPERATION_INSERT ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"    ACTION "VIEWDEF.MGFFAT07" OPERATION MODEL_OPERATION_UPDATE ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"    ACTION "VIEWDEF.MGFFAT07" OPERATION MODEL_OPERATION_DELETE ACCESS 0
	ADD OPTION aRotina TITLE "Vincular"   ACTION "U_xjMF07Vinc()"    OPERATION MODEL_OPERATION_UPDATE ACCESS 0
	
Return(aRotina)

/*
=====================================================================================
Programa............: ModelDef
Autor...............: Joni Lima
Data................: 06/10/2016
Descrição / Objetivo: ModelDef
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Definição do Modelo de Dados para cadastro de Aprovadores
=====================================================================================
*/
Static Function ModelDef()
	
	Local oModel	:= Nil
	Local oStrSZS 	:= FWFormStruct(1,"SZS")
	Local bTdOk     := {|oModel|xMF07TdOk(oModel)}
	Local bCommit   := {|oModel|xMF07Cmt(oModel)}
	
	oStrSZS:SetProperty('ZS_USER',MODEL_FIELD_VALID,{|oMdlSZS,cField,xValue,xOldValue|U_xjMF07VldUs(oMdlSZS,cField,xValue,xOldValue)})

	oStrSZS:SetProperty('ZS_LIMINI',MODEL_FIELD_VALID,{|oMdlSZS,cField,xValue,xOldValue|xMF070Valor(oMdlSZS,cField,xValue,xOldValue)})
	oStrSZS:SetProperty('ZS_LIMMAX',MODEL_FIELD_VALID,{|oMdlSZS,cField,xValue,xOldValue|xMF070Valor(oMdlSZS,cField,xValue,xOldValue)})

	oStrSZS:SetProperty('ZS_LIMINI',MODEL_FIELD_WHEN,{|oMdlSZS|xMF07WHEN(oMdlSZS)})
	oStrSZS:SetProperty('ZS_LIMMAX',MODEL_FIELD_WHEN,{|oMdlSZS|xMF07WHEN(oMdlSZS)})
	
	oModel := MPFormModel():New("XMGFFAT07", /*bPreValidacao*/,bTdOk/*bPosValidacao*/,bCommit/*bCommit*/,/*bCancel*/ )
	oModel:AddFields("SZSMASTER",/*cOwner*/,oStrSZS, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )
	
	oModel:SetDescription('Aprovadores')
	oModel:SetPrimaryKey({"ZS_FILIAL","ZS_CODIGO"})
	
Return(oModel)

/*
=====================================================================================
Programa............: ViewDef
Autor...............: Joni Lima
Data................: 06/10/2016
Descrição / Objetivo: ViewDef
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Definição da visualização da tela
=====================================================================================
*/
Static Function ViewDef()
	
	Local oView
	Local oModel  := FWLoadModel( 'MGFFAT07' )
	Local oStrSZS := FWFormStruct( 2, "SZS")
	
	oView := FWFormView():New()
	oView:SetModel(oModel)
	
	oView:AddField( 'VIEW_SZS' , oStrSZS, 'SZSMASTER' )
	
	oView:CreateHorizontalBox( 'TELA' , 100 )
	oView:SetOwnerView( 'VIEW_SZS', 'TELA' )
	
Return oView

/*
=====================================================================================
Programa............: xMF07VldUs
Autor...............: Joni Lima
Data................: 06/10/2016
Descrição / Objetivo: Validação do campo de ZS_USER
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Faz a validação do Usuario digitado( se existe e se não esta vinculado a Outro usuario)
=====================================================================================
*/
User Function xjMF07VldUs(oMdlSZS,cField,xValue,xOldValue)
	
	Local aArea 	:= GetArea()
	Local aAreaSZS 	:= SZS->(GetArea())
	Local lRet 	 	:= .T.
	Local oModel 	:= oMdlSZS:GetModel()
	local xcUser 	:= RetCodUsr() //Pega o usuario corrente
	
	If Alltrim(cField) == 'ZS_USER'
		PswOrder(1) //similar ao dbSetOrder ID do usuário/grupo
		If !PswSeek(xValue,.T.)
			lRet := .F.
			oModel:GetModel():SetErrorMessage(oModel:GetId(),"ZS_USER",oModel:GetModel():GetId(),"ZS_USER","ZS_USER",;
				"Código de usuario não existe", "verifique o código digitado" )
		EndIf
		dbSelectArea('SZS')
		SZS->(dbSetOrder(2))//ZS_FILIAL+ZS_USER
		If lRet.and. SZS->(dbSeek(xFilial('SZS') + xValue))
			lRet := .F.
			oModel:GetModel():SetErrorMessage(oModel:GetId(),"ZS_USER",oModel:GetModel():GetId(),"ZS_USER","ZS_USER",;
				"Usuario ja encontra-se vinculado a outro Aprovador", "Escolha outro usuario" )
		EndIf
		PswSeek(xcUser,.T.) //Retorna o usuario incial Segurança
	EndIf
	
	RestArea(aAreaSZS)
	RestArea(aArea)
	
Return lRet

/*
=====================================================================================
Programa............: xMF07TdOk
Autor...............: Joni Lima
Data................: 06/10/2016
Descrição / Objetivo: Validação pos validação do Modelo
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Faz a validação do Modelo de Dados
=====================================================================================
*/
Static Function xMF07TdOk(oModel)
	
	Local aArea 	:= GetArea()
	Local aAreaSZU 	:= SZU->(GetArea())
	Local oMdlSZS 	:= oModel:GetModel('SZSMASTER')
	Local lRet 		:= .T.
	
	If !(oMdlSZS:GetValue('ZS_APRFAT') <> '1' .and. oMdlSZS:GetValue('ZS_APRFAT') <> '1')
		If oMdlSZS:GetValue('ZS_APRFAT') == '1'
			If oModel:GetOperation() == MODEL_OPERATION_DELETE
				dbSelectArea('SZU')
				SZU->(dbSetOrder(2))//ZU_FILIAL+ZU_CODAPR+ZU_CODRGA
				If SZU->(DbSeek(xFilial('SZU') + oMdlSZS:GetValue('ZS_CODIGO')))
					lRet := .F.
					Help("",1,"Aprovador Vinculado",,"Não sera possivel excluir esse Aprovador, pois o mesmo se encontra vinculado a uma ou mais regras,Caso necessario, é possivel realizar o bloqueio do mesmo",1,0)
				EndIf
			EndIf
			
			If lRet .and. oModel:GetOperation() == MODEL_OPERATION_UPDATE .and. (oMdlSZS:GetValue('ZS_MSBLQL') <> SZS->ZS_MSBLQL)
				dbSelectArea('SZU')
				SZU->(dbSetOrder(2))//ZU_FILIAL+ZU_CODAPR
				If SZU->(dbSeek(xFilial('SZU') + oMdlSZS:GetValue('ZS_CODIGO')))
					If oMdlSZS:GetValue('ZS_MSBLQL')=='1'
						If 	Aviso("Bloqueio de Aprovador", "Foi encontrado vinculo desse aprovador com regra(s), caso continue sera efetuado o bloqueio DESSE APROVADOR para toda(s) a(s) regras(s)",;
								{ "Continuar", "Cancelar" }, 1) == 2
							Help(" ",1,"Cancelamento",,"Operação cancelada pelo usuario",1,0)
							lRet := .F.
						EndIf
					Else
						_nOpcDesp := Aviso("Desbloqueio de Aprovador", "Foi encontrado vinculo desse Aprovador com regra(s), deseja que seja desbloqueado o Aprovador para toda(s) a(s) Regra(s)?",;
										  { "Desbloquear", "Não Desbloquear","Cancelar" }, 2)
						If _nOpcDesp == 3
							Help(" ",1,"Cancelamento",,"Operação cancelada pelo usuario",1,0)
							lRet := .F.
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
		If lRet .and. oModel:GetOperation() == MODEL_OPERATION_UPDATE .and. oMdlSZS:GetValue('ZS_APRFAT') == '2'
			dbSelectArea('SZU')
			SZU->(dbSetOrder(2))//ZU_FILIAL+ZU_CODAPR+ZU_CODRGA
			If SZU->(DbSeek(xFilial('SZU') + oMdlSZS:GetValue('ZS_CODIGO')))
				lRet := .F.
				Help("",1,"Aprovador Vinculado",,"Não sera possivel alterar o conteudo do campo 'Aprov. Fatur' para Não pois o Aprovador se encontra vinculado a alguma(s) Regra(s)",1,0)
			EndIf
		EndIf
		If (lRet .and. (oModel:GetOperation() <> MODEL_OPERATION_DELETE) .and. oMdlSZS:GetValue('ZS_APRFIN') == '1')
			If !( oMdlSZS:GetValue('ZS_LIMINI') < oMdlSZS:GetValue('ZS_LIMMAX') )
				lRet	:= .F.
				Help(" ",1,"Valores inconsistentes",,"Valor máximo de aprovação deve estar preenchido e superior ao valor inicial",1,0)
			EndIf
		EndIf
	Else
		lRet := .F.
		Help(" ",1,"Tipo De Liberação",,"É Necessario que o campo de  'Aprov. Fatur' e/ou 'Aprov. Finan' esteja preenchido com SIM",1,0)
	EndIf
	
	RestArea(aAreaSZU)
	RestArea(aArea)
	
Return lRet

/*
=====================================================================================
Programa............: xMF07Cmt
Autor...............: Joni Lima
Data................: 07/10/2016
Descrição / Objetivo: Realizar o Commit do modelo
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Para o desbloqueio ou Bloqueio da SZU.
=====================================================================================
*/
Static Function xMF07Cmt(oModel)
	
	Local aArea := GetArea()
	Local aAreaSZU := SZU->(GetArea())
	Local lRet := .T.
	Local oMdlSZS := oModel:GetModel('SZSMASTER')
	
	dbSelectArea('SZU')
	SZU->(dbSetOrder(2))//ZU_FILIAL+ZU_CODAPR
	
	Begin Transaction
		
		If oMdlSZS:GetValue('ZS_APRFAT') == '1'
			If oModel:GetOperation() == MODEL_OPERATION_UPDATE .and. oMdlSZS:GetValue('ZS_MSBLQL') <> SZS->ZS_MSBLQL
				If SZU->(dbSeek(xFilial('SZU') + oMdlSZS:GetValue('ZS_CODIGO')))		
					If oMdlSZS:GetValue('ZS_MSBLQL')=='1'
						While SZU->(!Eof()) .and. SZU->ZU_CODAPR == oMdlSZS:GetValue('ZS_CODIGO')
							If SZU->ZU_MSBLQL <> '1'
								RecLock('SZU',.F.)
								SZU->ZU_MSBLQL := '1'
								SZU->(MsUnLock())
								SZU->(dbSkip())
							EndIf
						EndDo
					ElseIf _nOpcDesp == 1
						While SZU->(!Eof()) .and. SZU->ZU_CODAPR == oMdlSZS:GetValue('ZS_CODIGO')
							If SZU->ZU_MSBLQL <> '2'
								RecLock('SZU',.F.)
									SZU->ZU_MSBLQL := '2'
									SZU->(MsUnLock())
								SZU->(dbSkip())
							EndIf
						EndDo
					EndIf
				EndIf
			EndIf
		EndIf
		
		If lRet
			If oModel:VldData()
				FwFormCommit(oModel)
				oModel:DeActivate()
				_nOpcDesp == 0
			Else
				JurShowErro( oModel:GetModel():GetErrormessage() )
				lRet := .F.
				DisarmTransaction()
			EndIf
		EndIf
		
	End Transaction
	
	RestArea(aAreaSZU)
	RestArea(aArea)
	
Return lRet

/*
=====================================================================================
Programa............: xMF07Vinc
Autor...............: Joni Lima
Data................: 07/10/2016
Descrição / Objetivo: Realiza o vinculo do Aprovador com as Regras
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Faz o vinculo do Aprovador com as Regras
=====================================================================================
*/
User Function xjMF07Vinc()
	
	Local aArea := GetArea()
	Local aButtons := {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.T.,"Salvar"},{.T.,"Cancelar"},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil}}
		
	If SZS->ZS_MSBLQL <> '1'
		If SZS->ZS_APRFAT == '1'
			FWExecView("Alteração", "MGFFAT09", MODEL_OPERATION_UPDATE,, {|| .T.}, , ,aButtons)//"Alteração"
		Else
			Help(" ",1,"Aprovador Bloqueado",,"Não sera possivel realizar vinculo com nenhuma regra pois o aprovador não esta habilitado para realizar esse tipo de aprovação",1,0)
		EndIf
	Else
		Help(" ",1,"Aprovador Bloqueado",,"Não sera possivel realizar vinculo com nenhuma regra pois o aprovador encontra-se bloqueado",1,0)
	EndIf
	
	RestArea(aArea)
	
Return

/*
=====================================================================================
Programa............: xMF070Valor
Autor...............: Joni Lima
Data................: 21/10/2016
DescriÃ§Ã£o / Objetivo: Validacao dos valores informados nos campos: ZS_LIMINI e ZS_LIMMAX
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................:
=====================================================================================
*/
Static Function xMF070Valor(oMdlSZS,cField,xValue,xOldValue)

	Local lRet		:= .F.
	Local nValor	:= 0

	If ( cField == "ZS_LIMINI" )
		nValor	:= oMdlSZS:GetValue("ZS_LIMMAX")
		If ( nValor > 0 )
			lRet	:= ( xValue <= nValor )
		Else
			lRet	:= .T.
		EndIf
	ElseIf ( cField == "ZS_LIMMAX" )
		nValor	:= oMdlSZS:GetValue("ZS_LIMINI")
		If ( nValor > 0 )
			lRet	:= ( nValor <= xValue )
		Else
			lRet	:= .T.
		EndIf
	EndIf

Return lRet

/*
=====================================================================================
Programa............: xMF07WHEN
Autor...............: Luis Artuso
Data................: 06/10/2016
DescriÃ§Ã£o / Objetivo:
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Permite a verificacao dos limites minimo/maximo de aprovacao
=====================================================================================
*/
Static Function xMF07WHEN(oMdlSZS)
Return oMdlSZS:GetValue("ZS_APRFIN") == '1'
