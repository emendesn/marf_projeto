#Include 'Protheus.ch'
#INCLUDE "FWMVCDEF.CH"
#Include 'TOPCONN.ch'

Static __aF3Ret

/*
=====================================================================================
Programa............: MGFCOM05
Autor...............: Joni Lima
Data................: 20/12/2016
Descricao / Objetivo: Cadastro de Substituto
Doc. Origem.........: Contrato - GAP GRADE ERP
Solicitante.........: Cliente
Uso.................: 
Obs.................: Tela de Cadastro de Substituto
=====================================================================================
*/
User Function MGFCOM05()
	
	Local oMBrowse := nil
	
	oMBrowse:= FWmBrowse():New()
	
	oMBrowse:AddLegend( "dDataBase >= ZA9_DTINIC .and. dDataBase <= ZA9_DTFINA" , "GREEN" , "Ativo"   )
	oMBrowse:AddLegend( "dDataBase > ZA9_DTINIC  .and. dDataBase > ZA9_DTFINA"  , "RED"   , "Expirado" )
	oMBrowse:AddLegend( "dDataBase < ZA9_DTINIC  .and. dDataBase < ZA9_DTFINA"  , "YELLOW", "Agendado" )
	
	oMBrowse:SetAlias("ZA9")
	oMBrowse:SetDescription("Cadastro de Substituto")
	
	oMBrowse:Activate()
	
Return oMBrowse

/*
=====================================================================================
Programa............: MenuDef
Autor...............: Joni Lima
Data................: 20/12/2016
Descricao / Objetivo: MenuDef da rotina
Doc. Origem.........: Contrato - GAP GRADE ERP
Solicitante.........: Cliente
Uso.................: 
Obs.................: Definicao do Menu
=====================================================================================
*/
Static Function MenuDef()
	
	Local	aRotina	:= {}
	
	ADD OPTION aRotina TITLE "Pesquisar"  	  ACTION "PesqBrw"          OPERATION 1                      ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 	  ACTION "VIEWDEF.MGFCOM05" OPERATION MODEL_OPERATION_VIEW   ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"    	  ACTION "VIEWDEF.MGFCOM05" OPERATION MODEL_OPERATION_INSERT ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"    	  ACTION "VIEWDEF.MGFCOM05" OPERATION MODEL_OPERATION_UPDATE ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"    	  ACTION "VIEWDEF.MGFCOM05" OPERATION MODEL_OPERATION_DELETE ACCESS 0
	
Return(aRotina)

/*
=====================================================================================
Programa............: ModelDef
Autor...............: Joni Lima
Data................: 20/12/2016
Descricao / Objetivo: ModelDef
Doc. Origem.........: Contrato - GAP GRADE ERP
Solicitante.........: Cliente
Uso.................: 
Obs.................: Definicao do Modelo de Dados para cadastro de Substituto
=====================================================================================
*/
Static Function ModelDef()
	
	Local oModel	:= Nil
	
	Local oStrZAA 	:= FWFormStruct(1,"ZAA")
	Local oStrZA9 	:= FWFormStruct(1,"ZA9")
	Local bPosVal 	:= {|oModel|xMC5PosVal(oModel)}
	Local bCommit	:= {|oModel|xCommit(oModel)}
	
	//oStrZA9:SetProperty("ZA9_CODIGO",MODEL_FIELD_INIT,{||GETSXENUM('ZA9','ZA9_CODIGO')})
	
	//oStrZA9:SetProperty("*",MODEL_FIELD_OBRIGAT,.F.)
	//oStrZAA:SetProperty("*",MODEL_FIELD_OBRIGAT,.F.)
	
	oModel := MPFormModel():New("XMGFCOM05", /*bPreValidacao*/,bPosVal/*bPosValid*/,bCommit/*bCommit*/,/*bCancel*/ )
	
	oModel:AddFields("ZA9MASTER",/*cOwner*/,oStrZA9, /*bPreValid*/, /*bPosValid*/, /*bCarga*/ )
	oModel:AddGrid("ZAADETAIL","ZA9MASTER",oStrZAA, /*bLinePreValid*/, /*bLinePosValid*/,/*bPreValid*/,/*bPosValid*/, /*bCarga*/ )
	
	oModel:SetRelation("ZAADETAIL",{{"ZAA_FILIAL","xFilial('ZAA')"},{"ZAA_CODIGO","ZA9_CODIGO"}},ZAA->(IndexKey(1)))
	
	//oModel:GetModel('ZA9MASTER'):SetOnlyQuery(.T.)
	
	//oModel:SetVldActivate({|oModel|xVldAcivate(oModel)})
	
	oModel:SetDescription("Substitutos")
	oModel:SetPrimaryKey({"ZA9_FILIAL","ZA9_CODIGO"})

	oModel:GetModel( 'ZAADETAIL' ):SetNoInsertLine( .T. )

	oModel:SetActivate( {|oModel| fInitForm(oModel) } )
Return oModel

Static Function xVldAcivate(oModel)

	Local lRet := .T.
	
	If oModel:GetOperation() == MODEL_OPERATION_UPDATE .OR. oModel:GetOperation() == MODEL_OPERATION_DELETE
		If ZA9->ZA9_INTFLG <> 'S'
			lRet := .F.
			Help('',1,'Substituicao em Integracao com Fluig',,'Favor Aguardar e tentar novamente dentro de 5 minutos',1,0)
		EndIf
	EndIf
	
Return lRet

/*
=====================================================================================
Programa............: ViewDef
Autor...............: Joni Lima
Data................: 20/12/2016
Descricao / Objetivo: ViewDef
Doc. Origem.........: Contrato - GAP GRADE ERP
Solicitante.........: Cliente
Uso.................: 
Obs.................: Definicao da visualizasao da tela
=====================================================================================
*/
Static Function ViewDef()
	
	Local oView := nil
	
	Local oModel  	:= FWLoadModel('MGFCOM05')
	
	Local cFldMas	:= 'ZA9_EMPFIL|ZA9_NIVAPR|ZA9_DESCAP|ZA9_CODAPR|ZA9_NOMAPR|ZA9_MOTIVO|ZA9_DTINIC|ZA9_DTFINA'
	Local cFldDet	:= 'ZAA_CODIGO|ZAA_DTINIC|ZAA_DTFINA|ZAA_CODAPR|ZAA_NOMAPR|ZAA_INTFLG|ZAA_TIPINT'
	
	Local oStrZA9 	:= FWFormStruct( 2, "ZA9"/*,{|cCampo|AllTrim(cCampo) $ cFldMas}*/)
	Local oStrZAA 	:= FWFormStruct( 2, "ZAA",{|cCampo|!(AllTrim(cCampo) $ cFldDet)})
	
	oStrZA9:RemoveField('ZA9_INTFLG')
	
	oStrZA9:AddGroup( 'GRP01', ''  	  	   , '', 1 )
	oStrZA9:AddGroup( 'GRP02', 'Entidade De'  , '', 2 )
	oStrZA9:AddGroup( 'GRP03', '' , '', 3 )
	
	oStrZA9:SetProperty( 'ZA9_CODIGO' , MVC_VIEW_GROUP_NUMBER, 'GRP01' )
	oStrZA9:SetProperty( 'ZA9_DTINIC' , MVC_VIEW_GROUP_NUMBER, 'GRP01' )
	oStrZA9:SetProperty( 'ZA9_DTFINA' , MVC_VIEW_GROUP_NUMBER, 'GRP01' )
	oStrZA9:SetProperty( 'ZA9_MOTIVO' , MVC_VIEW_GROUP_NUMBER, 'GRP01' )
	
	oStrZA9:SetProperty( 'ZA9_EMPFIL' , MVC_VIEW_GROUP_NUMBER, 'GRP02' )
	oStrZA9:SetProperty( 'ZA9_NIVAPR' , MVC_VIEW_GROUP_NUMBER, 'GRP02' )
	oStrZA9:SetProperty( 'ZA9_DESCAP' , MVC_VIEW_GROUP_NUMBER, 'GRP02' )
	oStrZA9:SetProperty( 'ZA9_LOGIN'  , MVC_VIEW_GROUP_NUMBER, 'GRP02' )
	oStrZA9:SetProperty( 'ZA9_CODAPR' , MVC_VIEW_GROUP_NUMBER, 'GRP02' )
	oStrZA9:SetProperty( 'ZA9_NOMAPR' , MVC_VIEW_GROUP_NUMBER, 'GRP02' )

	oStrZA9:SetProperty( 'ZA9_USRCAD' , MVC_VIEW_GROUP_NUMBER, 'GRP03' )
	oStrZA9:SetProperty( 'ZA9_NOMCAD' , MVC_VIEW_GROUP_NUMBER, 'GRP03' )
	
	/*
	oStrZA9M:SetProperty( 'ZA9_NIVSUB' , MVC_VIEW_GROUP_NUMBER, 'GRP03' )
	oStrZA9M:SetProperty( 'ZA9_DESCSU' , MVC_VIEW_GROUP_NUMBER, 'GRP03' )
	oStrZA9M:SetProperty( 'ZA9_CODSUB' , MVC_VIEW_GROUP_NUMBER, 'GRP03' )
	oStrZA9M:SetProperty( 'ZA9_NOMSUB' , MVC_VIEW_GROUP_NUMBER, 'GRP03' )*/
	
	oView := FWFormView():New()
	oView:SetModel(oModel)
	
	oView:AddField( 'VIEW_ZA9' , oStrZA9, 'ZA9MASTER' )
	oView:AddGrid( 'VIEW_ZAA' , oStrZAA, 'ZAADETAIL' )
	
	oView:CreateHorizontalBox( 'SUPERIOR' , 40 )
	oView:CreateHorizontalBox( 'INFERIOR' , 60 )
	
	oView:SetOwnerView( 'VIEW_ZA9', 'SUPERIOR' )
	oView:SetOwnerView( 'VIEW_ZAA', 'INFERIOR' )
	
	oView:AddUserButton( 'Escolher Nivel'  , 'CLIPS', {|oView| U_xMC5PrcGrid('N')} )
	oView:AddUserButton( 'Escolher Usuario', 'CLIPS', {|oView| U_xMC5PrcGrid('U')} )

	//oStrZAA:SetProperty('ZAA_CODSUB', MVC_VIEW_CANCHANGE, .F.)
Return oView

/*
=====================================================================================
Programa............: xMC5PrcGrid
Autor...............: Joni Lima
Data................: 04/01/2016
Descricao / Objetivo: Carrega e preenche a Grid com os Dados escolhido pelo usuario
Doc. Origem.........: Contrato - GAP GRADE ERP
Solicitante.........: Cliente
Uso.................: 
Obs.................: Carrega todos os niveis desse usuario
=====================================================================================
*/
User Function xMC5PrcGrid(cTp)
	
	Local cPergNiv := 'MGF5C30001'
	Local cPergUse := 'MGF5C30003'
	
	Local cNiv	:= ''
	Local cUse  := ''
	
	Local oModel 	:= FwModelActive()
	Local oMdlZAA	:= oModel:GetModel('ZAADETAIL')
	
	Local aSaveLines	:= FwSaveRows()
	
	Local ni
	Local cCodUser := ""
	
	If cTp == 'N'
		If Pergunte(cPergNiv)
			cNiv := MV_PAR01
			For ni := 1  to oMdlZAA:Length()
				oMdlZAA:GoLine(ni)
				oMdlZAA:SetValue('ZAA_NIVSUB',cNiv)
			Next ni
		EndIf
	ElseIf cTp == 'U'
		If Pergunte(cPergUse)
			cUse := MV_PAR01
			//cCodUser := xLogUsr(cUse)
			//If xM5VerUsr(cUse)
				For ni := 1  to oMdlZAA:Length()
					oMdlZAA:GoLine(ni)
					oMdlZAA:SetValue('ZAA_LOGIN',cUse)
				Next ni
			//EndIf
		EndIf
	EndIf
	
	FWRestRows( aSaveLines )
	
Return

Static Function xM5VerUsr(cUse)
	
	Local aArea 	:= GetArea()
	Local aAreaSAK	:= SAK->(GetArea())
	
	Local lRet := .T.
	
	dbSelectArea('SAK')
	SAK->(dbSetOrder(2))//AK_FILIAL, AK_USER
	If SAK->(dbSeek( xFilial('SAK',FwFldGet('ZA9_EMPFIL')) + cUse ))
		lRet := .T.
	Else
		lRet := .F.
		Alert('Usuario deve estar cadastrado como Aprovador nessa Empresa')
	EndIf	
	
	RestArea(aArea)
	RestArea(aAreaSAK)
	
Return lRet

/*
=====================================================================================
Programa............: xMC5PosVal
Autor...............: Joni Lima
Data................: 04/01/2016
Descricao / Objetivo: Pos validacao do Modelo
Doc. Origem.........: Contrato - GAP GRADE ERP
Solicitante.........: Cliente
Uso.................: 
Obs.................: Verifica se todos os usuarios substitutos foram preenchidos
=====================================================================================
*/
Static Function xMC5PosVal(oModel)
	
	Local lRet 		:= .T.
	Local oMdlZA9	:= oModel:GetModel('ZA9MASTER')
	Local oMdlZAA	:= oModel:GetModel('ZAADETAIL')
	Local ni
	Local lNEmpty	:= .F.
	
	For ni := 1  to oMdlZAA:Length()
		oMdlZAA:GoLine(ni)
		
		//Solicitado para permitir inclusao sem substituto
		/*If Empty(oMdlZAA:GetValue('ZAA_CODSUB'))
			lRet := .F.
			Help('',1,'Nao  foi Escolhido o usuario Substituto',,'Favor escolher um substituo para cada item da grid',1,0)
			Exit
		EndIf*/
		
		If !lNEmpty .and. !Empty(oMdlZAA:GetValue('ZAA_CODSUB'))
			lNEmpty := .T.
		EndIf
		
		If oMdlZAA:GetValue('ZAA_CODSUB') == oMdlZA9:GetValue('ZA9_CODAPR')
			lRet := .F.
			Help('',1,'Substituto esta Igual ao Aprovador',,'Favor Verificar a linha' + Alltrim(str(ni)),1,0)
			Exit
		EndIf
	Next ni
	
	If !lNEmpty
		lRet := .F.
		Help('',1,'Sem Substituto',,'Para Salvar, preencher pelo menos uma linha com susbstituto' + Alltrim(str(ni)),1,0)	
	EndIf
	
Return lRet

/*
=====================================================================================
Programa............: xMC05VlDt
Autor...............: Joni Lima
Data................: 21/12/2016
Doc. Origem.........: Contrato - GAP GRADE ERP
Solicitante.........: Cliente
Uso.................: 
Obs.................: Realiza validacao da Data
=====================================================================================
*/
User Function xMC05VlDt(oMdlZA9,cFld,xValue)
	
	Local lRet := .T.
	
	If xValue < oMdlZA9:GetValue('ZA9_DTINIC')
		lRet := .F.
		oMdlZA9:GetModel():SetErrorMessage(oMdlZA9:GetId(),cFld,oMdlZA9:GetModel():GetId(),cFld,cFld,;
			"Data Final Precisa Ser Maior ou Igual a Data Inicial", "Verifique os valores digitados para data" )
	EndIf
	
Return lRet

User Function xMC5VlLg(oMdlZAA,cFld,xValue,nLine)

	Local aArea		:= GetArea()
	Local aAreaZA9	:= ZA9->(GetArea())
	Local cNextAlias:= GetNextAlias()
	
	Local oModel 	:= oMdlZAA:GetModel()
	Local oMdlZA9   := oModel:GetModel("ZA9MASTER")
	
	Local cCod		:= ""
	
	Local lRet := .T.

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif
	
	If AllTrim(UPPER(cFld)) == "ZAA_LOGIN"

		BeginSql Alias cNextAlias
			
			SELECT
				ZAA_CODIGO
			FROM
				%Table:ZAA% ZAA
			WHERE
				ZAA.%NotDel% AND
				ZAA.ZAA_FILIAL = %xFilial:ZAA% AND
				ZAA.ZAA_EMPFIL = %Exp:oMdlZAA:GetValue('ZAA_EMPFIL')% AND
				ZAA.ZAA_CODAPR = %Exp:oMdlZAA:GetValue('ZAA_CODAPR')% AND
				ZAA.ZAA_LOGIN = %Exp:xValue% AND
				(%Exp:oMdlZA9:GetValue('ZA9_DTINIC')% BETWEEN ZAA.ZAA_DTINIC AND ZAA.ZAA_DTFINA OR
				%Exp:oMdlZA9:GetValue('ZA9_DTFINA')% BETWEEN ZAA.ZAA_DTINIC AND ZAA.ZAA_DTFINA OR
				(%Exp:oMdlZA9:GetValue('ZA9_DTINIC')% < ZAA.ZAA_DTINIC AND %Exp:oMdlZA9:GetValue('ZA9_DTFINA')% > ZAA.ZAA_DTFINA))
			
		EndSql
		
		(cNextAlias)->(DbGoTop())
		
		While (cNextAlias)->(!EOF())
			cCod := (cNextAlias)->ZAA_CODIGO
			lRet := .F.
			Exit
		EndDo
		
		(cNextAlias)->(DBCloseArea())
		
		If !lRet
			//MsgInfo("Existe cadastro de substituto para esse aprovador nessa Data, Cadastro: " + cCod )
			oMdlZA9:GetModel():SetErrorMessage(oMdlZA9:GetId(),cFld,oMdlZA9:GetModel():GetId(),cFld,cFld,;
				"Existe cadastro de substituto para esse aprovador nessa Data", "Verifique o cadastro: " + cCod + " ,caso necessario realize a alteracao." )
		EndIf
	
	ElseIf AllTrim(UPPER(cFld)) == "ZAA_CODSUB" 

		BeginSql Alias cNextAlias
			
			SELECT
				ZAA_CODIGO
			FROM
				%Table:ZAA% ZAA
			WHERE
				ZAA.%NotDel% AND
				ZAA.ZAA_FILIAL = %xFilial:ZAA% AND
				ZAA.ZAA_EMPFIL = %Exp:oMdlZAA:GetValue('ZAA_EMPFIL')% AND
				ZAA.ZAA_CODAPR = %Exp:oMdlZAA:GetValue('ZAA_CODAPR')% AND
				ZAA.ZAA_CODSUB = %Exp:xValue% AND
				(%Exp:oMdlZA9:GetValue('ZA9_DTINIC')% BETWEEN ZAA.ZAA_DTINIC AND ZAA.ZAA_DTFINA OR
				%Exp:oMdlZA9:GetValue('ZA9_DTFINA')% BETWEEN ZAA.ZAA_DTINIC AND ZAA.ZAA_DTFINA OR
				(%Exp:oMdlZA9:GetValue('ZA9_DTINIC')% < ZAA.ZAA_DTINIC AND %Exp:oMdlZA9:GetValue('ZA9_DTFINA')% > ZAA.ZAA_DTFINA))
			
		EndSql
		
		(cNextAlias)->(DbGoTop())
		
		While (cNextAlias)->(!EOF())
			cCod := (cNextAlias)->ZAA_CODIGO
			lRet := .F.
			Exit
		EndDo
		
		(cNextAlias)->(DBCloseArea())
		
		If !lRet
			//MsgInfo("Existe cadastro de substituto para esse aprovador nessa Data, Cadastro: " + cCod )
			oMdlZA9:GetModel():SetErrorMessage(oMdlZA9:GetId(),cFld,oMdlZA9:GetModel():GetId(),cFld,cFld,;
				"Existe cadastro de substituto para esse aprovador nessa Filial, dentro dessa Data, com esse Substituto", "Verifique o cadastro: " + cCod + " ,e caso necessario realize a alteracao." )
		EndIf
	
	EndIf

	RestArea(aAreaZA9)
	RestArea(aArea)

Return lRet

/*
=====================================================================================
Programa............: xMC05ZA1
Autor...............: Joni Lima
Data................: 04/01/2016
Descricao / Objetivo: Realiza validacao do Nivel
Doc. Origem.........: Contrato - GAP GRADE ERP
Solicitante.........: Cliente
Uso.................: 
Obs.................: Verifica se o codigo de nivel Existe
=====================================================================================
*/
User Function xMC05ZA1(oMdlZA9,cFld,xValue)
	
	Local aArea		:= GetArea()
	Local aAreaZA1	:= ZA1->(GetArea())
	Local lRet := .T.
	
	dbSelectArea('ZA1')
	ZA1->(dbSetOrder(1))
	
	If !(ZA1->(DbSeek(xFilial('ZA1')+xValue)))
		lRet := .F.
		oMdlZA9:GetModel():SetErrorMessage(oMdlZA9:GetId(),cFld,oMdlZA9:GetModel():GetId(),cFld,cFld,;
			"Nao  Foi encontrado o codigo: " + xValue + ', no cadastro de Niveis', "Verifique o valor digitado" )
	EndIf
	
	RestArea(aAreaZA1)
	RestArea(aArea)
	
Return lRet

/*
=====================================================================================
Programa............: xMC5LimpGr
Autor...............: Joni Lima
Data................: 04/01/2016
Descricao / Objetivo: Faz limpeza da Grid
Doc. Origem.........: Contrato - GAP GRADE ERP
Solicitante.........: Cliente
Uso.................: 
Obs.................: Faz limpeza da Grid
=====================================================================================
*/
User Function xMC5LimpGr(xValue)
	
	Local oModel 	:= FwModelActive()
	Local oMdlZAA 	:= oModel:GetModel('ZAADETAIL')
	
	oModel:GetModel( 'ZAADETAIL' ):SetNoInsertLine( .F. )
	
	If oMdlZAA:Length() > 1
		oMdlZAA:DelAllLine()
		oMdlZAA:ClearData()
		oMdlZAA:AddLine()
	EndIf

	oModel:GetModel( 'ZAADETAIL' ):SetNoInsertLine( .T. )
	
Return xValue

/*
=====================================================================================
Programa............: xMC05FlXB
Autor...............: Joni Lima
Data................: 04/01/2016
Descricao / Objetivo: ViewDef
Doc. Origem.........: Realiza o filtro da Consulta padrao
Solicitante.........: Cliente
Uso.................: 
Obs.................: Realiza o filtro conforme preenchimento da unidade e Nivel
=====================================================================================
*/
User Function xMC05FlXB()
	
	Local lRet := .T.
	
	If Empty(ZA9_NIVAPR)
		lRet := ZA2->ZA2_EMPFIL == ZA9_EMPFIL
	Else
		lRet := ZA2->(ZA2_EMPFIL + ZA2_NIVEL) == ZA9_EMPFIL + ZA9_NIVAPR
	EndIf
	
Return lRet

/*
=====================================================================================
Programa............: xMC05Fl2XB
Autor...............: Joni Lima
Data................: 04/01/2016
Descricao / Objetivo: ViewDef
Doc. Origem.........: Realiza o filtro da Consulta padrao
Solicitante.........: Cliente
Uso.................: 
Obs.................: Realiza o filtro conforme preenchimento da unidade e Nivel
=====================================================================================
*/
User Function xMC05Fl2XB()
	
	Local lRet := .T.
	Local oModel	:= FwModelActive()
	Local oMdlZAA	:= oModel:GetModel('ZAADETAIL')
	
	If Empty(oMdlZAA:GetValue('ZAA_NIVSUB'))
		lRet := ZA2->ZA2_EMPFIL == oMdlZAA:GetValue('ZAA_EMPSUB')
	Else
		lRet := ZA2->(ZA2_EMPFIL + ZA2_NIVEL) == oMdlZAA:GetValue('ZAA_EMPSUB') + oMdlZAA:GetValue('ZAA_NIVSUB')
	EndIf
	
Return lRet

/*
=====================================================================================
Programa............: xMC5GatUN
Autor...............: Joni Lima
Data................: 11/04/2016
Descricao / Objetivo: ViewDef
Doc. Origem.........: Gatilho para preenchimento do Grid
Solicitante.........: Cliente
Uso.................: 
=====================================================================================
*/
User Function xMC5GatUN(cFil,cCod,cTp)
	
	Local aArea 	:= GetArea()
	Local aAreaZA2	:= ZA2->(GetArea())
	
	Local cNextAlias:= GetNextAlias()
	Local cRet		:= ''
	
	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif	
	
	If cTp == 'NV'
		BeginSql Alias cNextAlias	
		SELECT 
			ZA2.ZA2_CODUSU COD                                                                                     
		FROM
			%Table:ZA2% ZA2
		WHERE
			ZA2.%NotDel% AND
			ZA2.ZA2_FILIAL = %xFilial:ZA2% AND
			ZA2.ZA2_EMPFIL = %exp:cFil% AND
			ZA2.ZA2_NIVEL = %exp:cCod%
		EndSql
	ElseIf cTp == 'US'
		BeginSql Alias cNextAlias	
		SELECT 
			ZA2.ZA2_NIVEL COD                                                                                     
		FROM
			%Table:ZA2% ZA2
		WHERE
			ZA2.%NotDel% AND
			ZA2.ZA2_FILIAL = %xFilial:ZA2% AND
			ZA2.ZA2_EMPFIL = %exp:cFil% AND
			ZA2.ZA2_CODUSU = %exp:cCod%
		EndSql	
	EndIf
	
	(cNextAlias)->(DbGoTop())
	
	While (cNextAlias)->(!EOF())
		cRet := (cNextAlias)->COD
		(cNextAlias)->(dbSkip())	
	EndDo
	
	(cNextAlias)->(DBCloseArea())
		
	RestArea(aAreaZA2)
	RestArea(aArea)
	
Return cRet

/*
=====================================================================================
Programa............: xMC5Gat
Autor...............: Joni Lima
Data................: 04/01/2016
Descricao / Objetivo: ViewDef
Doc. Origem.........: Gatilho para preenchimento do Grid
Solicitante.........: Cliente
Uso.................: 
Obs.................: Chama funcao para preencher o Grid
=====================================================================================
*/
User Function xMC5Gat(cValue,cCod)
	
	Local oModel := FwModelActive()
	
	xMC5CarApr(cCod,oModel)
	
Return cValue

/*
=====================================================================================
Programa............: xMC5ValUser
Autor...............: Joni Lima
Data................: 04/01/2016
Descricao / Objetivo: ViewDef
Doc. Origem.........: Validacao do campo de aprovador (usuario)
Solicitante.........: Cliente
Uso.................: 
Obs.................: Validacao do campo de aprovador (usuario)
=====================================================================================
*/
User Function xMC5ValUser(oMdlZA9,cFld,xValue)
	
	Local aArea		:= GetArea()
	Local aAreaZA9	:= ZA9->(GetArea())
	Local cNextAlias:= GetNextAlias()
	Local cCod		:= ''
	Local lRet 		:= .T.
	
	lRet := xExtUsr(xValue)

	If !lRet
		oMdlZA9:GetModel():SetErrorMessage(oMdlZA9:GetId(),cFld,oMdlZA9:GetModel():GetId(),cFld,cFld,;
			"Usuario nao localizado", "Usuario nao localizado. Informe um usuario valido." )
	EndIf
	
	If lRet
		If Select(cNextAlias) > 0
			(cNextAlias)->(DbClosearea())
		Endif
		
		BeginSql Alias cNextAlias
			
			SELECT
				ZAA_CODIGO
			FROM
				%Table:ZAA% ZAA
			WHERE
				ZAA.%NotDel% AND
				ZAA.ZAA_FILIAL = %xFilial:ZAA% AND
				ZAA.ZAA_EMPFIL = %Exp:oMdlZA9:GetValue('ZA9_EMPFIL')% AND
				ZAA.ZAA_CODAPR = %Exp:oMdlZA9:GetValue('ZA9_CODAPR')% AND
				(%Exp:oMdlZA9:GetValue('ZA9_DTINIC')% BETWEEN ZAA.ZAA_DTINIC AND ZAA.ZAA_DTFINA OR
				%Exp:oMdlZA9:GetValue('ZA9_DTFINA')% BETWEEN ZAA.ZAA_DTINIC AND ZAA.ZAA_DTFINA OR
				(%Exp:oMdlZA9:GetValue('ZA9_DTINIC')% < ZAA.ZAA_DTINIC AND %Exp:oMdlZA9:GetValue('ZA9_DTFINA')% > ZAA.ZAA_DTFINA))
			
		EndSql
		
		(cNextAlias)->(DbGoTop())
		
		While (cNextAlias)->(!EOF())
			
			If !Empty((cNextAlias)->ZAA_CODIGO)
				cCod := (cNextAlias)->ZAA_CODIGO
				lRet := .F.
				Exit
			EndIf
			
			(cNextAlias)->(dbSkip())
			
		EndDo
		
		(cNextAlias)->(DBCloseArea())
		
		If !lRet
			lRet := .T. 
			MsgInfo("Existe cadastro de substituto para esse aprovador nessa Data, Cadastro: " + cCod )
			//oMdlZA9:GetModel():SetErrorMessage(oMdlZA9:GetId(),cFld,oMdlZA9:GetModel():GetId(),cFld,cFld,;
			//	"Existe cadastro de substituto para esse aprovador nessa Data", "Verifique o cadastro: " + cCod + " ,caso necessario realize a alteracao." )
		EndIf
	EndIf
	RestArea(aAreaZA9)
	RestArea(aArea)
	
Return lRet

Static Function xExtUsr(cCodUsr)
	
	Local aArea		:= GetArea()
	Local lRet		:= .F.

	Local cNextAlias:= GetNextAlias()

		If Select(cNextAlias) > 0
			(cNextAlias)->(DbClosearea())
		Endif
		
		BeginSql Alias cNextAlias
		
			SELECT 
				USR_ID
			FROM 
				SYS_USR USR
			WHERE
				USR.USR_ID	= %Exp:cCodUsr% AND
				USR.%NotDel%

		EndSql
		
		(cNextAlias)->(DbGoTop())
			
		If (cNextAlias)->(!EOF())
			lRet := .T.
		EndIf	
		
		(cNextAlias)->(DbClosearea())
		
		RestArea(aArea)

return lRet

Static Function xLogUsr(cCodUsr)
	
	Local aArea		:= GetArea()
	Local cRet		:= ""

	Local cNextAlias:= GetNextAlias()

		If Select(cNextAlias) > 0
			(cNextAlias)->(DbClosearea())
		Endif
		
		BeginSql Alias cNextAlias
		
			SELECT 
				USR_CODIGO
			FROM 
				SYS_USR USR
			WHERE
				USR.USR_ID	= %Exp:cCodUsr% AND
				USR.%NotDel%

		EndSql
		
		(cNextAlias)->(DbGoTop())
			
		If (cNextAlias)->(!EOF())
			cRet := (cNextAlias)->USR_CODIGO
		EndIf	
		
		(cNextAlias)->(DbClosearea())
		
		RestArea(aArea)

return cRet

/*
=====================================================================================
Programa............: xMC5CarApr
Autor...............: Joni Lima
Data................: 04/01/2016
Descricao / Objetivo: ViewDef
Doc. Origem.........: Funcao para carregar os Niveis e unidades do pessoal para Substituicao
Solicitante.........: Cliente
Uso.................: 
Obs.................: Preenche a Grid com as unidades e com os niveis para preenchimento
=====================================================================================
*/
Static Function xMC5CarApr(cCod,oModel)
	
	Local aArea 	 := GetArea()
	Local cNextAlias := GetNextAlias()
	Local cRet		 := ''
	
	Local oMdlGrid	 := oModel:GetModel("ZAADETAIL")
	
	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif

	oMdlGrid:SetNoInsertLine( .F. )

	BeginSql Alias cNextAlias

		SELECT
			ZA2_EMPFIL,
			ZA2_NIVEL,
			ZA2_CODUSU
		FROM
			%Table:ZA2% ZA2
		WHERE
			ZA2.ZA2_FILIAL = %xFilial:ZA2% AND
			ZA2.%NotDel% AND
			ZA2.ZA2_CODUSU = %Exp:cCod%

	EndSql
	
	(cNextAlias)->(DbGoTop())
	
	oMdlGrid:DelAllLine()
	oMdlGrid:ClearData()
	//Preenche a Grid
	While (cNextAlias)->(!EOF())

		oMdlGrid:AddLine()

		oMdlGrid:SetValue('ZAA_CODIGO',oModel:GetValue('ZA9MASTER','ZA9_CODIGO'))
		oMdlGrid:SetValue('ZAA_EMPFIL',(cNextAlias)->ZA2_EMPFIL)
		oMdlGrid:SetValue('ZAA_NIVAPR',(cNextAlias)->ZA2_NIVEL)
		oMdlGrid:SetValue('ZAA_CODAPR',(cNextAlias)->ZA2_CODUSU)
		oMdlGrid:SetValue('ZAA_EMPSUB',(cNextAlias)->ZA2_EMPFIL)

		(cNextAlias)->(dbSkip())

	EndDo
	
	(cNextAlias)->(DBCloseArea())
	
	oMdlGrid:GoLine(1)
	RestArea(aArea)

	oMdlGrid:SetNoInsertLine( .T. )
Return

/*
=====================================================================================
Programa............: xCommit
Autor...............: Joni Lima
Data................: 11/04/2017
Descricao / Objetivo: ViewDef
Doc. Origem.........: Commit do Modelo
Solicitante.........: Cliente
Uso.................: 
=====================================================================================
*/
Static Function xCommit(oModel)
	
	Local aArea 	:= GetArea()
	Local aAreaZAA	:= ZAA->(GetArea())
	Local lRet 		:= .T.
	Local aDados 	:= {}
	Local oMdlZA9 	:= oModel:GetModel('ZA9MASTER')
	Local oMdlZAA 	:= oModel:GetModel('ZAADETAIL')
	Local ni
	
	
	Begin Transaction
		
		
		If oModel:GetOperation() <> MODEL_OPERATION_DELETE
			// Inclui substituto na SAK caso nao seja aprovador
			//GrvSAK(oMdlZA9, oMdlZAA)

			oMdlZA9:SetValue('ZA9_INTFLG','S')//Retirar na Integracao Fluig
			For ni := 1 to oMdlZAA:Length()
				
				oMdlZAA:GoLine(ni)
				aDados := {}
				
				oMdlZAA:SetValue('ZAA_DTINIC',oMdlZA9:GetValue('ZA9_DTINIC'))
				oMdlZAA:SetValue('ZAA_DTFINA',oMdlZA9:GetValue('ZA9_DTFINA'))
				oMdlZAA:SetValue('ZAA_INTFLG','')
				
				AADD(aDados,{oMdlZAA:GetValue("ZAA_FILIAL") , oMdlZAA:GetValue("ZAA_CODIGO") , oMdlZAA:GetValue("ZAA_EMPFIL")})
				
				/*AADD(aDados,oMdlZAA:GetValue('ZAA_CODAPR'))
				AADD(aDados,oMdlZAA:GetValue('ZAA_CODSUB'))
				AADD(aDados,oMdlZAA:GetValue('ZAA_DTINIC'))
				AADD(aDados,oMdlZAA:GetValue('ZAA_DTFINA'))
				
				If oModel:GetOperation() == MODEL_OPERATION_INSERT
					xIncFluig(aDados)
				Else
					xAltFluig(aDados)
				EndIf*/
				
			Next ni
		EndIf

		For ni := 1 to oMdlZAA:Length()

			oMdlZAA:GoLine(ni)
		
			If oModel:GetOperation() == MODEL_OPERATION_DELETE
				
				dbSelectArea('ZAA')
				ZAA->(DbSetOrder(1))//ZAA_FILIAL+ZAA_CODIGO+ZAA_EMPFIL
				
				If ZAA->(DbSeek(oMdlZAA:GetValue('ZAA_FILIAL') + oMdlZAA:GetValue('ZAA_CODIGO')+ oMdlZAA:GetValue('ZAA_EMPFIL')))
					
					RecLock('ZAA',.F.)
						ZAA->ZAA_INTFLG := ''
						ZAA->ZAA_TIPINT := 'E'
					ZAA->(MsUnLock())
					
				EndIf
				RestArea(aAreaZAA)
				RestArea(aArea)
				//oMdlZAA:ForceValue('ZAA_TIPINT','E')
			ElseIf oModel:GetOperation() == MODEL_OPERATION_UPDATE  
				oMdlZAA:SetValue('ZAA_TIPINT','A')
			EndIf
		
		Next ni
		
		If lRet
			If oModel:VldData()
				FWFormCommit(oModel)
	
				dbSelectArea("ZAA")
				ZAA->(dbSetOrder(1))//ZAA_FILIAL+ZAA_CODIGO+ZAA_EMPFIL
				
				/*For ni:= 1 to Len(aDados)
					U_xPrcFluig('P','I','ZA2',ZAA->(Recno()),'I','','')
				Next ni*/
				
				oModel:DeActivate()
			Else
				JurShowErro( oModel:GetModel():GetErrormessage() )
				lRet := .F.
				DisarmTransaction()
			EndIf
		EndIf
		
	End Transaction
	
Return lRet

/*
=====================================================================================
Programa............: xIncFluig
Autor...............: Joni Lima
Data................: 11/04/2017
Descricao / Objetivo: Integracao do Fluig
=====================================================================================
*/
Static Function xIncFluig(aDados)
	
	Local oObj := WSECMColleagueReplacementServiceService():New()
	Local oResulObj := nil
	Local oColleag := ECMColleagueReplacementServiceService_colleagueReplacementDto():New()
	
	Local aItem := {}
	
	Local ni
	Local nf
	
	Local cCodFlg	:= ''
	
	oObj:cuserName 	:= Alltrim(SuperGetMV("MGF_FLGUSR",.F.,'adm'))//'adm'
	oObj:cpassword 	:= Alltrim(SuperGetMV("MGF_FLGPSW",.F.,'adm'))//'adm'
	oObj:ncompanyId	:= 1
	
	oColleag:ccolleagueId 			:= aDados[1]//'CARA que vai ser substituido'
	oColleag:ncompanyId 			:= 1
	oColleag:creplacementId 		:= aDados[2] //'Cara que vai substitutir'
	oColleag:cvalidationStartDate 	:= Left(DtoS(aDados[3]),4)+ '-' + Substr(DtoS(aDados[3]),5,2) + '-' + Right(DtoS(aDados[3]),2)//'DATA INICIAL + '
	oColleag:cvalidationFinalDate 	:= Left(DtoS(aDados[4]),4)+ '-' + Substr(DtoS(aDados[4]),5,2) + '-' + Right(DtoS(aDados[4]),2) //'DATA FINAL  + HORA'
	oColleag:lviewWorkflowTasks 	:= .T.
	
	oObj:oWScreateColleagueReplacementcolleagueReplacement	:= oColleag
	
	oObj:createColleagueReplacement()
	
Return

/*
=====================================================================================
Programa............: xAltFluig
Autor...............: Joni Lima
Data................: 11/04/2017
Descricao / Objetivo: Integracao do Fluig Alteracao
=====================================================================================
*/
Static Function xAltFluig(aDados)
	
	Local oObj := WSECMColleagueReplacementServiceService():New()
	Local oResulObj := nil
	Local oColleag := ECMColleagueReplacementServiceService_colleagueReplacementDto():New()
	
	Local aItem := {}
	
	Local ni
	Local nf
	
	Local cCodFlg	:= ''
	
	oObj:cuserName 	:= Alltrim(SuperGetMV("MGF_FLGUSR",.F.,'adm'))
	oObj:cpassword 	:= Alltrim(SuperGetMV("MGF_FLGPSW",.F.,'adm'))
	oObj:ncompanyId	:= 1
	
	oColleag:ccolleagueId 			:= aDados[1]//'CARA que vai ser substituido'
	oColleag:ncompanyId 			:= 1
	oColleag:creplacementId 		:= aDados[2] //'Cara que vai substitutir'
	oColleag:cvalidationStartDate 	:= Left(DtoS(aDados[3]),4)+ '-' + Substr(DtoS(aDados[3]),5,2) + '-' + Right(DtoS(aDados[3]),2) //'DATA INICIAL + '
	oColleag:cvalidationFinalDate 	:= Left(DtoS(aDados[4]),4)+ '-' + Substr(DtoS(aDados[4]),5,2) + '-' + Right(DtoS(aDados[4]),2) //'DATA FINAL  + HORA'
	oColleag:lviewWorkflowTasks 	:= .T.
	
	oObj:oWSupdateColleagueReplacementcolleagueReplacement	:= oColleag
	
	oObj:UpdateColleagueReplacement()
	
Return

/*
=====================================================================================
Programa............: MG5USER
Autor...............: Joni Lima
Data................: 11/04/2017
Descricao / Objetivo: Integracao do Fluig
=====================================================================================
*/
User Function MG5USER(cCodUsu)

	Local 	cRet 	:= ''//IIF(INCLUI,'',)
	Local 	nPos 	:= 0	
	
	If Type('__aXAllUser') <> 'A'
		U_xMGC10CRIP()
	EndIf
	
	If ValType(__aXAllUser) == 'A'			
		nPos := aScan(__aXAllUser,{|x| Alltrim(x[2]) == Alltrim(cCodUsu)})
		If nPos > 0
			cRet := Alltrim(__aXAllUser[nPos][4])
		EndIf
	Else
		cRet := AllTrim(UsrFullName(cCodUsu))
	EndIf

Return cRet

/*
=====================================================================================
Programa............: xMGF5CNP
Autor...............: Joni Lima
Data................: 11/04/2017
Descricao / Objetivo: Consulta padrao para usuarios 
=====================================================================================
*/
User function xMGF5CNP()

	local aArea		:= GetArea()
	
	local aLstVias	:= {}
	local cOpcoes	:= ""
	local cTitulo	:= "Selecao de Usuarios"
	local MvPar		:= &(Alltrim(ReadVar()))		// Carrega Nome da Variavel do Get em Questao
	local mvRet		:= "MV_PAR01"		// Iguala Nome da Variavel ao Nome variavel de Retorno
	Local cxFFIL	:= SUBSTR(xFilial('ZAA',FwFldGet('ZA9_EMPFIL')),1,2)
	
	Local cNextAlias:= GetNextAlias()

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif

	BeginSql Alias cNextAlias

		SELECT DISTINCT 
			ZA2.ZA2_LOGIN,
			USR.USR_NOME
		FROM 
			%Table:ZA2% ZA2
		INNER JOIN SYS_USR USR
		    ON ZA2.ZA2_LOGIN = USR.USR_CODIGO
		Where 
		    ZA2.D_E_L_E_T_ = ' ' AND
		    USR.D_E_L_E_T_ = ' ' AND
		    ZA2.ZA2_FILIAL = %exp:cxFFIL%

	EndSql

	(cNextAlias)->(DbGoTop())

	While (cNextAlias)->(!EOF())
		
		AADD(aLstVias, ALLTRIM((cNextAlias)->ZA2_LOGIN) + " - " + ALLTRIM((cNextAlias)->USR_NOME) )
		cOpcoes += (cNextAlias)->ZA2_LOGIN
		
		(cNextAlias)->(dbSkip())
	EndDo
	
	(cNextAlias)->(DBCloseArea())
	
	/*
	DBSelectArea("SYQ")
	dbGoTop()
	while !SYQ->(EOF())
		aadd(aLstVias, allTrim(SYQ->YQ_COD_DI) + " - " + allTrim(SYQ->YQ_DESCR) + " - " +  allTrim(SYQ->YQ_VIA))
		cOpcoes += SYQ->(YQ_VIA)
		SYQ->(DBSkip())
	enddo()
	SYQ->(DBCloseArea())
	*/
	
	If f_Opcoes(    @MvPar		,;    //Variavel de Retorno
		cTitulo		,;    //Titulo da Coluna com as opcoes
		@aLstVias	,;    //Opcoes de Escolha (Array de Opcoes)
		@cOpcoes	,;    //String de Opcoes para Retorno
		NIL			,;    //Nao Utilizado
		NIL			,;    //Nao Utilizado
		.T.			,;    //Se a Selecao sera de apenas 1 Elemento por vez
		TamSx3("ZA2_LOGIN")[1],; //TamSx3("A6_COD")[1],; //
		900,;				//No maximo de elementos na variavel de retorno
		)
		
		&MvRet := mvpar
	EndIf
	
	RestArea(aArea)

Return .T.

//--------------------------------------------------
// Verifica se usuario esta no grupo para cadastrar substitutos
// senao estiver ele podera cadastrar substitutos apenas para ele mesmo
//--------------------------------------------------
User Function chkGrpSu()
	
	local lRet		 := .F.
	Local cNextAlias := GetNextAlias()
	local cGrupos	 := AllTrim(superGetMv("MGF_GRPSUB", .F., ""))
	
	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif
	
	BeginSql Alias cNextAlias
	
		SELECT 
		  USR.USR_ID 
		FROM 
		  SYS_USR USR 
		INNER JOIN SYS_USR_GROUPS GRP
		  ON USR.USR_ID = GRP.USR_ID
		WHERE  
		  USR.USR_ID = %Exp:retCodUsr()% AND 
		  USR.%NotDel% AND
		  GRP.%NotDel% AND
		  GRP.USR_GRUPO = %exp:cGrupos%

	EndSql

	(cNextAlias)->(DbGoTop())

	if (cNextAlias)->(!EOF())
		lRet := .T.
	EndIf
	
	(cNextAlias)->(DBCloseArea())
	
Return lRet

//--------------------------------------------------
//--------------------------------------------------
Static Function fInitForm(oModel)

	Local lRet := .T.
	Local oModelCab := oModel:GetModel('ZA9MASTER')
	Local cNextAlias := GetNextAlias()
	Local oStrZA9	 := oModelCab:GetStruct() 	

	oStrZA9:SetProperty("ZA9_EMPFIL",MODEL_FIELD_WHEN,{||.T.})
	oStrZA9:SetProperty("ZA9_NIVAPR",MODEL_FIELD_WHEN,{||.T.})
	oStrZA9:SetProperty("ZA9_CODAPR",MODEL_FIELD_WHEN,{||.T.})
	oStrZA9:SetProperty("ZA9_LOGIN",MODEL_FIELD_WHEN,{||.T.})
	 
	If oModel:GetOperation() == MODEL_OPERATION_INSERT
		If Select(cNextAlias) > 0
			(cNextAlias)->(DbClosearea())
		Endif

		BeginSql Alias cNextAlias

			SELECT
				ZA2_EMPFIL,
				ZA2_NIVEL,
				ZA2_CODUSU,
				ZA2_LOGIN
			FROM
				%Table:ZA2% ZA2
			WHERE
				ZA2.ZA2_FILIAL = %xFilial:ZA2% AND
				ZA2.%NotDel% AND
				ZA2.ZA2_CODUSU = %Exp:retCodUsr()%

		EndSql

		(cNextAlias)->(DbGoTop())

		if !(cNextAlias)->(EOF())
			oModelCab:SetValue( "ZA9_EMPFIL"	, (cNextAlias)->ZA2_EMPFIL	)
			oModelCab:SetValue( "ZA9_NIVAPR"	, (cNextAlias)->ZA2_NIVEL	)
			oModelCab:SetValue( "ZA9_LOGIN"		, (cNextAlias)->ZA2_LOGIN	)
		endif

		(cNextAlias)->(DBCloseArea())
	EndIf
	
	oStrZA9:SetProperty("ZA9_EMPFIL",MODEL_FIELD_WHEN,{||U_chkGrpSu()})
	oStrZA9:SetProperty("ZA9_NIVAPR",MODEL_FIELD_WHEN,{||U_chkGrpSu()})
	oStrZA9:SetProperty("ZA9_CODAPR",MODEL_FIELD_WHEN,{||U_chkGrpSu()})
	oStrZA9:SetProperty("ZA9_LOGIN",MODEL_FIELD_WHEN,{||U_chkGrpSu()})
	
Return lRet

//--------------------------------------------------
//--------------------------------------------------
Static Function GrvSAK(oMdlZA9, oMdlZAA)
	Local aArea	  		:= GetArea()
	Local aAreaSAK		:= SAK->(GetArea())
	Local oMdlSAK	 	:= nil
	local oMdlMas		:= nil
	Local cRet   	 	:= ''
	Local cOldFil		:= cFilAnt
	Local aSaveLines	:= FwSaveRows()

	dbSelectArea('SAK')
	SAK->(dbSetOrder(2))//AK_FILIAL+AK_USER

	for nI := 1 to oMdlZAA:Length()
		
		cFilAnt := oMdlZAA:GetValue('ZAA_EMPFIL')
		
		If !SAK->(DBSeek( cFilAnt + oMdlZAA:GetValue('ZAA_CODSUB') ) )
		
			oMdlSAK := FWLoadModel('MATA095')
	
			oMdlMas := oMdlSAK:GetModel('SAKMASTER')
	
			oMdlZAA:GoLine(nI)
			oMdlZAA:GetValue('ZAA_CODSUB')
			cFilAnt := oMdlZAA:GetValue('ZAA_EMPFIL')
	
			SAK->(DBGoTop())
			If SAK->( DBSeek( cFilAnt + oMdlZAA:GetValue('ZAA_CODSUB') ) )
				oMdlSAK:SetOperation( MODEL_OPERATION_UPDATE )
			Else
				oMdlSAK:SetOperation( MODEL_OPERATION_INSERT )
			EndIf
	
			If oMdlSAK:Activate()
				getSAK(oMdlZA9:GetValue('ZA9_CODAPR'))
	
				If oMdlSAK:GetOperation() == MODEL_OPERATION_INSERT
					oMdlMas:SetValue('AK_FILIAL'	, cFilAnt										)//ZA2_FILIAL
					oMdlMas:SetValue('AK_ZNIVEL'	, QRYSAK->AK_ZNIVEL								)//ZA2_NIVEL
					oMdlMas:LoadValue('AK_NOME'		, USRFULLNAME(oMdlZAA:GetValue('ZAA_CODSUB'))	)//ZA1_DESCRI
					oMdlMas:LoadValue('AK_USER'		, oMdlZAA:GetValue('ZAA_CODSUB')				)//ZA2_CODUSU
				EndIf
	
				oMdlMas:SetValue('AK_LIMMIN' , QRYSAK->AK_LIMMIN	)//ZA2_VALMIN
				oMdlMas:SetValue('AK_LIMMAX' , QRYSAK->AK_LIMMAX	)//ZA2_VALMAX
				oMdlMas:SetValue('AK_LIMITE' , QRYSAK->AK_LIMITE	)//ZA2_LIMITE
				oMdlMas:SetValue('AK_TIPO'   , QRYSAK->AK_TIPO		)//ZA2_TIPO
	
				If oMdlSAK:VldData()
					FwFormCommit(oMdlSAK)
					oMdlSAK:DeActivate()
					oMdlSAK:Destroy()
				Else
					JurShowErro(oMdlSAK:GetModel():GetErrormessage())
				EndIf
	
				QRYSAK->(DBCloseArea())
			EndIf
	
			oMdlSAK:DeActivate()
		EndIf
	next
	
	cFilAnt := cOldFil

	RestArea(aAreaSAK)
	RestArea(aArea)

	FWRestRows( aSaveLines )
Return

//--------------------------------------------------
//--------------------------------------------------
static function getSAK(cUsrSAK)
	local cQrySAK := ""

	cQrySAK := "SELECT *"
	cQrySAK += " FROM " + retSQLName("SAK") + " SAK"
	cQrySAK += " WHERE"
	cQrySAK += " 		SAK.AK_USER		=	'" + cUsrSAK		+ "'"
	cQrySAK += " 	AND	SAK.AK_FILIAL	=	'" + xFilial("SAK")	+ "'"
	cQrySAK += " 	AND	SAK.D_E_L_E_T_	<>	'*'"

	TcQuery cQrySAK New Alias "QRYSAK"
return

User Function xMG5ELog(cCod)
	
	Local cRet := ''
	Local cNextAlias := GetNextAlias()

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif

	BeginSql Alias cNextAlias
	
		SELECT 
			USR.USR_CODIGO
		FROM 
			SYS_USR USR
		WHERE 
			USR.USR_ID = %exp:cCod% AND 
			USR.%NotDel%

	EndSql

	(cNextAlias)->(DbGoTop())

	if (cNextAlias)->(!EOF())
		cRet := (cNextAlias)->USR_CODIGO 
	EndIf
	
Return cRet