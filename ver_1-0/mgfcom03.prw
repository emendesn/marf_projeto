#INCLUDE 'PROTHEUS.CH'
#INCLUDE "FWMVCDEF.CH"
#INCLUDE 'TOPCONN.CH'

/*
=====================================================================================
Programa............: MGFCOM03
Autor...............: Joni Lima
Data................: 19/12/2016
Descricao / Objetivo: Cadastro de Niveis
Doc. Origem.........: Contrato - GAP GRADE ERP
Solicitante.........: Cliente
Uso.................: 
Obs.................: Tela de Cadastro de Niveis
=====================================================================================
*/
User Function MGFCOM03()

	Local oMBrowse := nil
	Public __aXAllUser := FwSFAllUsers()

	oMBrowse:= FWmBrowse():New()
	oMBrowse:SetAlias("ZA1")
	oMBrowse:SetDescription('Niveis de Autoridade')

	oMBrowse:Activate()

Return

/*
=====================================================================================
Programa............: MenuDef
Autor...............: Joni Lima
Data................: 19/12/2016
Descricao / Objetivo: MenuDef da rotina
Doc. Origem.........: Contrato - GAP GRADE ERP
Solicitante.........: Cliente
Uso.................: 
Obs.................: Definicao do Menu
=====================================================================================
*/
Static Function MenuDef()

	Local	aRotina	:= {}

	ADD OPTION aRotina TITLE "Pesquisar"  		ACTION "PesqBrw"          OPERATION 1                      ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 		ACTION "VIEWDEF.MGFCOM03" OPERATION MODEL_OPERATION_VIEW   ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"    		ACTION "VIEWDEF.MGFCOM03" OPERATION MODEL_OPERATION_INSERT ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"    		ACTION "VIEWDEF.MGFCOM03" OPERATION MODEL_OPERATION_UPDATE ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"    	    ACTION "VIEWDEF.MGFCOM03" OPERATION MODEL_OPERATION_DELETE ACCESS 0
	ADD OPTION aRotina TITLE "Log de alteracao" ACTION "U_MGFCOM33()"   OPERATION 6   				   ACCESS 0

Return(aRotina)

/*User Function xMG3VerLog()

Return*/

/*
=====================================================================================
Programa............: ModelDef
Autor...............: Joni Lima
Data................: 19/12/2016
Descricao / Objetivo: ModelDef
Doc. Origem.........: Contrato - GAP GRADE ERP
Solicitante.........: Cliente
Uso.................: 
Obs.................: Definicao do Modelo de Dados para cadastro de Niveis
=====================================================================================
*/
Static Function ModelDef()

	Local oModel	:= Nil
	Local oStrZA1 	:= FWFormStruct(1,"ZA1")
	Local oStrZA2 	:= FWFormStruct(1,"ZA2")
	Local bPosVld	:= {|oModel|PosVld(oModel)}
	Local bLinPre	:= {|oMldZA2,nLin,cAction|xPreLinVal(oMldZA2,nLin,cAction)}
	Local bLinPos	:= {|oMdlZA2|xMGF3VerUn(oMdlZA2)}
	Local bCommit	:= {|oModel|xCommit(oModel)}
	Local bActiv	:= {|oModel|xActiv(oModel)}

	oStrZA2:SetProperty("ZA2_NIVEL",MODEL_FIELD_OBRIGAT,.F.)

	//oStrZA2:SetProperty("ZA2_CODUSU",MODEL_FIELD_WHEN,{|oMdlZA2,cField,xValue,nLine|xMGFC03Ins(oMdlZA2,cField,xValue,nLine)})
	oStrZA2:SetProperty("ZA2_EMPFIL",MODEL_FIELD_WHEN,{|oMdlZA2,cField,xValue,nLine|xMGFC03Ins(oMdlZA2,cField,xValue,nLine)})

	oModel := MPFormModel():New("XMGFCOM03",/*bPreValidacao*/,/*bPosValid*/,bCommit,/*bCancel*/ )

	oModel:AddFields("ZA1MASTER",/*cOwner*/,oStrZA1, /*bPreValid*/, /*bPosValid*/, /*bCarga*/ )
	oModel:AddGrid("ZA2DETAIL","ZA1MASTER",oStrZA2, bLinPre/*bLinePreValid*/,bLinPos/*bLinePosValid*/,/*bPreValid*/,/*bPosValid*/, /*bCarga*/ )

	oModel:SetRelation("ZA2DETAIL",{{"ZA2_FILIAL","xFilial('ZA2')"},{"ZA2_NIVEL", "ZA1_NIVEL"}},ZA2->(IndexKey(1)))

	oModel:GetModel( "ZA2DETAIL" ):SetUniqueLine({"ZA2_EMPFIL"})

	oModel:SetDescription("Niveis de Autoridade")
	oModel:SetPrimaryKey({"ZA1_FILIAL","ZA1_NIVEL"})
	
	oModel:SetVldActivate({|oModel|xVldAcivate(oModel)})
	oModel:SetActivate(bActiv)

	oModel:GetModel( 'ZA2DETAIL' ):SetNoDeleteLine( .T. )
Return oModel

/*
=====================================================================================
Programa............: ViewDef
Autor...............: Joni Lima
Data................: 19/12/2016
Descricao / Objetivo: ViewDef
Doc. Origem.........: Contrato - GAP GRADE ERP
Solicitante.........: Cliente
Uso.................: 
Obs.................: Definicao da visualizasao da tela
=====================================================================================
*/
Static Function ViewDef()

	Local oView
	Local oModel  	:= FWLoadModel('MGFCOM03')

	Local cFldZA2   := "ZA2_NIVEL,ZA2_DESCRI,ZA2_CODAPD,ZA2_CODAFN,ZA2_VALMIN,ZA2_VALMAX,ZA2_MOEDA,ZA2_LIMITE,ZA2_TPLIM,ZA2_BLQAPR"

	Local oStrZA1 	:= FWFormStruct( 2, "ZA1",)
	Local oStrZA2 	:= FWFormStruct( 2, "ZA2",{|cCampo|!(AllTrim(cCampo) $ cFldZA2)})
	
	oStrZA1:RemoveField('ZA1_APRFIN')
	
	oView := FWFormView():New()
	oView:SetModel(oModel)

	oView:AddField( 'VIEW_ZA1' , oStrZA1, 'ZA1MASTER' )
	oView:AddGrid( 'VIEW_ZA2' , oStrZA2, 'ZA2DETAIL' )

	oView:SetViewProperty("VIEW_ZA2", "GRIDFILTER", {.T.})
	oView:SetViewProperty("VIEW_ZA2", "GRIDSEEK", {.T.})

	oView:CreateHorizontalBox( 'SUPERIOR' , 20 )
	oView:CreateHorizontalBox( 'INFERIOR' , 80 )

	oView:SetOwnerView( 'VIEW_ZA1', 'SUPERIOR' )
	oView:SetOwnerView( 'VIEW_ZA2', 'INFERIOR' )

	oStrZA2:SetProperty('ZA2_CODUSU', MVC_VIEW_CANCHANGE, .F.)
Return oView

/*
=====================================================================================
Programa............: xVldAcivate
Autor...............: Joni Lima
Data................: 19/12/2016
Descricao / Objetivo: ViewDef
Doc. Origem.........: Contrato - GAP GRADE ERP
Solicitante.........: Cliente
Uso.................: 
Obs.................: Verifica se ja foi utilizado o nivel em alguma grade para permitir a exclusao
=====================================================================================
*/
Static Function xVldAcivate(oModel)

	Local lRet := .T.
	Local cNextAlias := GetNextAlias()	
	Local cNivel  := ''
	
	If oModel:GetOperation() == MODEL_OPERATION_DELETE
		
		cNivel := ZA1->ZA1_NIVEL
		
		If Select(cNextAlias) > 0
			(cNextAlias)->(DbClosearea())
		Endif

		BeginSql Alias cNextAlias

			SELECT 
				ZAD_CODIGO
			FROM 
				%Table:ZAD% ZAD
			WHERE 
				ZAD.ZAD_FILIAL = %xFilial:ZAD% AND
				ZAD.%NotDel% AND
				ZAD.ZAD_NIVEL = %Exp:cNivel%
	
			ORDER BY ZAD_CODIGO

		EndSql

		(cNextAlias)->(DbGoTop())

		While (cNextAlias)->(!EOF())
				lRet := .F.
				Exit
			(cNextAlias)->(dbSkip())
		EndDo
		
		If !lRet
			Help('',1,'Nivel utilizado',,'Nivel ja utilizado em grades de aprovacao',1,0)
		EndIf

		(cNextAlias)->(DbClosearea())
	EndIf
	
Return lRet

/*
=====================================================================================
Programa............: xActiv
Autor...............: Joni Lima
Data................: 20/01/2016
Descricao / Objetivo: Utilizado na Ativacao do Modelo de Dados
Doc. Origem.........: Contrato - GAP GRADE ERP
Solicitante.........: Cliente
Uso.................: 
Obs.................: Carrega as unidades(filiais) na Grid
=====================================================================================
*/
Static Function xActiv(oModel)

	Local aArea 	:= GetArea()
	Local aAreaSM0	:= SM0->(GetArea())
	Local aAreaZA2	:= ZA2->(GetArea())
	Local cxFilOld	:= cFilAnt
	Local oMdlZA2	:= oModel:GetModel('ZA2DETAIL')
	Local oStrucZA2	:= oMdlZA2:GetStruct() 
	Local nLine		:= 1
	Local nTamFil	:= TamSx3('C5_FILIAL')[1]

	oStrucZA2:SetProperty( 'ZA2_CODUSU' , MODEL_FIELD_OBRIGAT,.F.)
	oMdlZA2:SetNoInsertLine(.F.)
	
	If oModel:GetOperation() == MODEL_OPERATION_INSERT
		dbSelectArea('SM0')
		SM0->(dbSetOrder(1))

		While SM0->(!Eof()) .and. SubStr(SM0->M0_CODFIL,1,2) = SubStr(cFilAnt,1,2)
			If nLine <> 1
				oMdlZA2:AddLine()
			EndIf
			oMdlZA2:GoLine(nLine)
			oMdlZA2:SetValue('ZA2_EMPFIL',SubStr(SM0->M0_CODFIL,1,nTamFil))
			oMdlZA2:LoadValue('ZA2_USERCA',U_XMC3NOMUS())
			oMdlZA2:LoadValue('ZA2_DATACA',dDataBase)
			nLine ++
			SM0->(dbSkip())
		EndDo
		oMdlZA2:GoLine(1)
	EndIf

	If oModel:GetOperation() == MODEL_OPERATION_UPDATE
		
		ZA2->(dbSetOrder(2))//ZA2_FILIAL+ZA2_EMPFIL+ZA2_NIVEL
		
		dbSelectArea('SM0')
		SM0->(dbSetOrder(1))

		While SM0->(!Eof()) .and. SubStr(SM0->M0_CODFIL,1,2) = SubStr(cFilAnt,1,2)
			
			If !(ZA2->(dbSeek(SubStr(cFilAnt,1,2) + '    ' + Alltrim(SM0->M0_CODFIL) + ZA1->ZA1_NIVEL )))

				nLine := oMdlZA2:AddLine()
				oMdlZA2:GoLine(nLine)

				oMdlZA2:SetValue('ZA2_EMPFIL',SubStr(SM0->M0_CODFIL,1,nTamFil))
				oMdlZA2:LoadValue('ZA2_USERCA',U_XMC3NOMUS())
				oMdlZA2:LoadValue('ZA2_DATACA',dDataBase)

			EndIf
			SM0->(dbSkip())
		EndDo
		oMdlZA2:GoLine(1)
	EndIf

	//oStrucZA2:SetProperty( 'ZA2_CODUSU' , MODEL_FIELD_OBRIGAT,.T.)
	oMdlZA2:SetNoInsertLine(.T.)

	RestArea(aAreaZA2)
	RestArea(aAreaSM0)
	RestArea(aArea)

Return .T.

/*
=====================================================================================
Programa............: xPreLinVal
Autor...............: Joni Lima
Data................: 19/12/2016
Descricao / Objetivo: ViewDef
Doc. Origem.........: Contrato - GAP GRADE ERP
Solicitante.........: Cliente
Uso.................: 
Obs.................: Realiza a validacao ao tentar realizar uma dele��o de uma linha
=====================================================================================
*/
Static Function xPreLinVal(oMldZA2,nLin,cAction)

	Local aArea := GetArea()

	Local oModel  := oMldZA2:GetModel()
	Local oMdlZA1 := oModel:GetModel('ZA1MASTER') 

	Local lRet := .t.

	Local cUnid 	 := oMldZA2:GetValue('ZA2_EMPFIL')
	Local cNiv		 := oMdlZA1:GetValue('ZA1_NIVEL')
	Local cNextAlias := GetNextAlias()

	If AllTrim(cAction) == "DELETE"

		If Select(cNextAlias) > 0
			(cNextAlias)->(DbClosearea())
		Endif

		BeginSql Alias cNextAlias

		SELECT 
			ZAD_NIVEL
		FROM 
			%Table:ZAD% ZAD
		WHERE 
			ZAD.ZAD_FILIAL = %xFilial:ZAD% AND
			ZAD.%NotDel% AND
			ZAD.ZAD_NIVEL = %Exp:cNiv%

		ORDER BY ZAD_NIVEL DESC

		EndSql

		(cNextAlias)->(DbGoTop())

		While (cNextAlias)->(!EOF())

			lRet := .F.
			Exit

			(cNextAlias)->(dbSkip())
		EndDo

		If !lRet
			Help('',1,'Aprovador Esta vinculado a um Grupo de Aprovador',,'Caso Necessario realizar o bloqueio desse aprovador',1,0)
		EndIf

		(cNextAlias)->(DbClosearea())
	EndIf

Return lRet

/*
=====================================================================================
Programa............: xMGFC03US
Autor...............: Joni Lima
Data................: 19/12/2016
Descricao / Objetivo: Validar codigo de usuario vinculado a outro Nivel
Doc. Origem.........: Contrato - GAP GRADE ERP
Solicitante.........: Cliente
Uso.................: 
Obs.................: Validacao do codigo de usuario
=====================================================================================
*/
User Function xOldMGFC03US(oMdlZA2,cFld,xValor,nLin)

	Local aArea		:= GetArea()
	Local aAreaSAK	:= SAK->(GetArea())

	Local oModel	:= oMdlZA2:GetModel()
	Local oMdlZA1	:= oModel:GetModel('ZA1MASTER')

	Local lRet 		:= .T.

	Local cFil 		:= ''
	Local cxUser	:= ''
	Local cNivel	:= oMdlZA1:GetValue('ZA1_NIVEL')

	If cFld == 'ZA2_EMPFIL'
		cFil 	:= SubStr(xValor,1,TamSX3('AK_FILIAL')[1])
		cxUser	:= oMdlZA2:GetValue('ZA2_CODUSU')
	Else
		cFil 	:= SubStr(oMdlZA2:GetValue('ZA2_EMPFIL'),1,TamSX3('AK_FILIAL')[1])
		cxUser	:= xValor
	EndIf

	If !Empty(cFil) .and. !Empty(cxUser)
		dbSelectArea('SAK')
		SAK->(dbSetOrder(2))//AK_FILIAL, AK_USER
		If SAK->(dbSeek( cFil + cxUser))
			If SAK->AK_ZNIVEL <> cNivel
				lRet := .F.
				oMdlZA2:GetModel():SetErrorMessage(oMdlZA2:GetId(),cFld,oMdlZA2:GetModel():GetId(),cFld,cFld,;
				"Usuario dessa Filial j� esta vinculado a outro Nivel de aprovacao", "Favor Verificar o Nivel: '" + SAK->AK_ZNIVEL + "' , e realizar os ajustes necessarios." )
			EndIf
		EndIf
	EndIf

	RestArea(aAreaSAK)
	RestArea(aArea)

Return lRet

User Function xMGFC03US(oMdlZA2,cFld,xValor,nLin)
	
	Local aArea		:= GetArea()	
	Local cNextAlias := GetNextAlias()

	Local oModel	:= oMdlZA2:GetModel()
	Local oMdlZA1	:= oModel:GetModel('ZA1MASTER')

	Local lRet 		:= .T.

	Local cFil 		:= ''
	Local cxUser	:= ''
	Local cNivel	:= oMdlZA1:GetValue('ZA1_NIVEL')

	If cFld == 'ZA2_EMPFIL'
		cFil 	:= SubStr(xValor,1,TamSX3('ZA2_EMPFIL')[1])
		cxUser	:= oMdlZA2:GetValue('ZA2_CODUSU')
	Else
		cFil 	:= SubStr(oMdlZA2:GetValue('ZA2_EMPFIL'),1,TamSX3('ZA2_EMPFIL')[1])
		cxUser	:= xValor
	EndIf

	If !Empty(cFil) .and. !Empty(cxUser)

		If Select(cNextAlias) > 0
			(cNextAlias)->(DbClosearea())
		Endif
	
		BeginSql Alias cNextAlias
	
			SELECT
			  ZA2.ZA2_NIVEL
			FROM 
			  %Table:ZA2% ZA2
			WHERE 
			  ZA2.%NotDel% AND
			  ZA2.ZA2_CODUSU = %Exp:cxUser% AND
			  ZA2.ZA2_EMPFIL = %Exp:cFil%
	
		EndSql
	
		(cNextAlias)->(DbGoTop())
	
		While (cNextAlias)->(!EOF())
			lRet := .F.
			oMdlZA2:GetModel():SetErrorMessage(oMdlZA2:GetId(),cFld,oMdlZA2:GetModel():GetId(),cFld,cFld,;
			"Usuario dessa Filial j� esta vinculado a outro Nivel de aprovacao", "Favor Verificar o Nivel: '" + (cNextAlias)->ZA2_NIVEL + "' , e realizar os ajustes necessarios." )
			Exit
			(cNextAlias)->(dbSkip())
		EndDo
	
		(cNextAlias)->(DbClosearea())

	EndIf
	
	RestArea(aArea)
	
Return lRet

/*
=====================================================================================
Programa............: xMGFC3VUN
Autor...............: Joni Lima
Data................: 27/12/2016
Descricao / Objetivo: Validar Valores da Unidade se a mesma ja se encontra cadastrada
Doc. Origem.........: Contrato - GAP GRADE ERP
Solicitante.........: Cliente
Uso.................: 
Obs.................: Verifica se existe apenas uma unidade para esse nivel
=====================================================================================
*/
User Function xMGFC3VUN(oMdlZA2,cFld,xValor,nLin)

	Local lRet := .T.
	Local ni   := 1	
	Local aSaveLines	:= FwSaveRows()
	Local nLinAt		:= nLin

	For ni:= 1  TO oMdlZA2:Length()
		oMdlZA2:GoLine(ni)
		If AllTrim(oMdlZA2:GetValue('ZA2_EMPFIL')) == AllTrim(xValor) .and. nLinAt <> ni 
			lRet := .F.
			oMdlZA2:GetModel():SetErrorMessage(oMdlZA2:GetId(),cFld,oMdlZA2:GetModel():GetId(),cFld,cFld,;
			"Unidade j� vinculada em outra linha, que nao esta bloqueada", "Favor Verificar a Linha: '" + AllTrim(str(ni)) + "' , e realizar os ajustes necessarios." )
			Exit
		EndIf
	Next ni

	FWRestRows( aSaveLines )

Return lRet

/*
=====================================================================================
Programa............: xMGF3VerUn
Autor...............: Joni Lima
Data................: 04/01/2016
Descricao / Objetivo: Validar Valores da Unidade se a mesma ja se encontra cadastrada ao mudar de linha
Doc. Origem.........: Contrato - GAP GRADE ERP
Solicitante.........: Cliente
Uso.................: 
Obs.................: Verifica se existe apenas uma unidade para esse nivel
=====================================================================================
*/
Static Function xMGF3VerUn(oMdlZA2)

	Local lRet := .T.
	Local ni   := 1	
	Local aSaveLines	:= FwSaveRows()
	Local nLinAt		:= 0//nLin
	Local cUni			:= ''

	cUni := oMdlZA2:GetValue('ZA2_EMPFIL')
	nLinAt := oMdlZA2:GetLine()

//	If oMdlZA2:GetValue('ZA2_BLQAPR') == 'N'
		For ni:= 1  TO oMdlZA2:Length()

			oMdlZA2:GoLine(ni)

			If AllTrim(oMdlZA2:GetValue('ZA2_EMPFIL')) == AllTrim(cUni) .and. nLinAt <> ni 
				lRet := .F.
				Help('',1,"Unidade j� vinculada em outra linha, que nao esta bloqueada",,"Favor Verificar a Linha: '" + AllTrim(str(ni)) + "' , e realizar os ajustes necessarios.",1,0)
				//oMdlZA2:GetModel():SetErrorMessage(oMdlZA2:GetId(),cFld,oMdlZA2:GetModel():GetId(),cFld,cFld,;
				//	"Unidade j� vinculada em outra linha, que nao esta bloqueada", "Favor Verificar a Linha: '" + AllTrim(str(ni)) + "' , e realizar os ajustes necessarios." )
				Exit
			EndIf

		Next ni
//	EndIf

	FWRestRows( aSaveLines )

Return lRet

/*
=====================================================================================
Programa............: xMGFC03VL
Autor...............: Joni Lima
Data................: 19/12/2016
Descricao / Objetivo: Validar Valores de Min e Maximo
Doc. Origem.........: Contrato - GAP GRADE ERP
Solicitante.........: Cliente
Uso.................: 
Obs.................: Validacao de valores Minimo e Maximo
=====================================================================================
*/
User Function xMGFC03VL(oMdlZA2,cFld,xValor,nLin)

	Local lRet	:= .T.
	Local nVldMin := 0
	Local nVldMax := 0

	If AllTrim(cFld) == "ZA2_VALMIN"
		nVldMin := xValor
		nVldMax := oMdlZA2:GetValue('ZA2_VALMAX')
	Else
		nVldMin := oMdlZA2:GetValue('ZA2_VALMIN')
		nVldMax := xValor
	EndIf

	If ( !Empty(nVldMin) .And. !Empty(nVldMax) .And. (nVldMin > nVldMax ))
		oMdlZA2:GetModel():SetErrorMessage(oMdlZA2:GetId(),cFld,oMdlZA2:GetModel():GetId(),cFld,cFld,;
		"Valor Minimo nao pode ser Superior ao valor Maximo", "verifique os valores digitados" )
		lRet := .F.
	Endif

Return(lRet)

/*
=====================================================================================
Programa............: xMGFC03Ins
Autor...............: Joni Lima
Data................: 20/12/2016
Descricao / Objetivo: Validar Valores que so Podem ser alterados na inclusao
Doc. Origem.........: Contrato - GAP GRADE ERP
Solicitante.........: Cliente
Uso.................: 
Obs.................: Verifica se a linha � inserida.
=====================================================================================
*/
Static Function xMGFC03Ins(oMdlZA2,cField,xValue,nLine)
Return Empty(oMdlZA2:GetValue('ZA2_EMPFIL'))//oMdlZA2:IsInserted()

/*
=====================================================================================
Programa............: PosVld
Autor...............: Joni Lima
Data................: 19/12/2016
Descricao / Objetivo: Validacao Antes do Commit
Doc. Origem.........: Contrato - GAP GRADE ERP
Solicitante.........: Cliente
Uso.................: 
Obs.................: Realiza a validacao antes do commit
=====================================================================================
*/
Static Function PosVld(oModel)

	Local lRet 		:= .T.
	Local oMdlZA2	:= oModel:GetModel('ZA2DETAIL')
	Local ni		:= 0
	Local nVldMin 	:= 0
	Local nVldMax 	:= 0
	Local aRet
	Local cMsg		:=''

	aRet := xMC3Valid(oModel)
	lRet := aRet[1]

	If !(lRet)
		cMsg := aRet[2]//Mensagem com as Filiais que estao sem usuarios.
		Help('',1,'Unidades sem Usuarios',,'Existem unidades sem usuario vinculado obs.: Verificar se nao esta bloqueado',1,0)
	EndIf

	If lRet
		For ni := 1 to oMdlZA2:Length()

			oMdlZA2:GoLine(ni)

			nVldMin	:= oMdlZA2:GetValue('ZA2_VALMIN')
			nVldMax := oMdlZA2:GetValue('ZA2_VALMAX')

			If (!Empty(nVldMin) .or. !Empty(nVldMax)) .And. (nVldMin > nVldMax)
				lRet := .F.
				Help('',1,'Verificar Valores',,'Valor Minimo nao pode ser Superior ao valor Maximo',1,0)
				Exit
			EndIf

		Next ni
	EndIf

Return lRet

/*
=====================================================================================
Programa............: Commit
Autor...............: Joni Lima
Data................: 19/12/2016
Descricao / Objetivo: Tratamentos para Commit
Doc. Origem.........: Contrato - GAP GRADE ERP
Solicitante.........: Cliente
Uso.................: 
Obs.................: Commit do Modelo
=====================================================================================
*/
Static Function xCommit(oModel)
	
	Local lRet 		:= .T.
	Local oMdlZA2	:= oModel:GetModel('ZA2DETAIL')
	Local ni		:= 1
	Local aDados	:= {}
	Local aAreaTmp
	Local aArZA2	:= ZA2->(GetArea())	
	
	If oModel:VldData()
		
		If oModel:GetOperation() == MODEL_OPERATION_UPDATE
			For ni := 1 to oMdlZA2:Length()
				oMdlZA2:GoLine(ni)
				//ZA2_FILIAL+ZA2_EMPFIL+ZA2_NIVEL
				AADD(aDados,{oMdlZA2:GetValue('ZA2_FILIAL') + oMdlZA2:GetValue('ZA2_EMPFIL') + oMdlZA2:GetValue('ZA2_NIVEL'),oMdlZA2:GetValue('ZA2_LOGIN'),oMdlZA2:GetValue('ZA2_CODUSU'),oMdlZA2:GetValue('ZA2_EMPFIL')})
			Next ni
			
			dbSelectArea('ZA2')
			
			For ni := 1 to Len(aDados)
				aAreaTmp := aArZA2
				ZA2->(dbSetOrder(2))//ZA2_FILIAL+ZA2_EMPFIL+ZA2_NIVEL
				If ZA2->(DbSeek(aDados[ni,1]))
					If ZA2->ZA2_LOGIN <> aDados[ni,2]
						
						//Atualizacao do usuario na tabela SCR
						xAtUser(ZA2->ZA2_CODUSU,aDados[ni,3],aDados[ni,4])
						
						//Criacao do Log de Aprovacao
						U_xMC33ILog('ZA2', aDados[ni,1], ZA2->(RECNO()), 'ZA2_LOGIN', ZA2->ZA2_LOGIN, aDados[ni,2], dDataBase, Time(), __CUSERID)
					
					EndIf
				EndIf
				RestArea(aAreaTmp)
			Next ni
			
			RestArea(aArZA2)
		EndIf
		
		FwFormCommit(oModel)
		oModel:DeActivate()
	Else
		JurShowErro( oModel:GetModel():GetErrormessage() )
		lRet := .F.
		DisarmTransaction()	
	EndIf	

return lRet

/*
=====================================================================================
Programa............: Commit
Autor...............: Joni Lima
Data................: 19/12/2016
Descricao / Objetivo: Tratamentos para Commit
Doc. Origem.........: Contrato - GAP GRADE ERP
Solicitante.........: Cliente
Uso.................: 
Obs.................: Commit do Modelo
=====================================================================================
*/
Static Function xOldCommit(oModel)

	Local lRet 		:= .T.
	Local oMdlZA2	:= oModel:GetModel('ZA2DETAIL')
	Local oMdlZA1	:= oModel:GetModel('ZA1MASTER')
	Local aCamp		:= {}
	Local aDados	:= {}
	Local aGrades	:= {}
	Local cCodSAK	:= ''
	Local cCodGSAK	:= ''
	Local cCodFRP	:= ''
	Local cCodGFRP	:= ''

	Local ni		:= 0
	
	private oProcess

	Begin Transaction

		If oModel:GetOperation() <> MODEL_OPERATION_DELETE

			//Realiza Grava��o dos Aprovadores de Pedidos
			For ni := 1 to oMdlZA2:Length()

				oMdlZA2:GoLine(ni)

				If !(oMdlZA2:IsDeleted()) 

					cCodGSAK := oMdlZA2:GetValue('ZA2_CODAPD')

					aCamp := {}
					AADD(aCamp,oMdlZA2:GetValue('ZA2_EMPFIL'))
					AADD(aCamp,oMdlZA1:GetValue('ZA1_NIVEL'))
					AADD(aCamp,oMdlZA1:GetValue('ZA1_DESCRI'))
					AADD(aCamp,oMdlZA2:GetValue('ZA2_VALMIN'))
					AADD(aCamp,oMdlZA2:GetValue('ZA2_VALMAX'))
					AADD(aCamp,oMdlZA2:GetValue('ZA2_LIMITE'))
					AADD(aCamp,oMdlZA2:GetValue('ZA2_TPLIM'))
					AADD(aCamp,oMdlZA2:GetValue('ZA2_CODUSU'))
					AADD(aCamp,cCodGSAK)

					cCodSAK := GrvSAK(oModel,aCamp)
					If Empty(cCodGSAK)
						oMdlZA2:SetValue('ZA2_CODAPD',cCodSAK)
					EndIf

					//Realiza Grava��o dos Gestores Financeiros
					/*If oMdlZA1:GetValue('ZA1_APRFIN') == 'S'

						cCodGFRP := oMdlZA2:GetValue('ZA2_CODAFN')

						AADD(aCamp,cCodGFRP)
						AADD(aCamp,oMdlZA2:GetValue('ZA2_MOEDA'))

						cCodFRP :=GrvFRP(oModel,aCamp)
						If Empty(cCodGFRP)
							oMdlZA2:SetValue('ZA2_CODAFN',cCodFRP)
						EndIf
					EndIf*/

				EndIf
			Next ni
		Else
			For ni := 1 to oMdlZA2:Length()

				oMdlZA2:GoLine(ni)

				ExcSAK(oMdlZA2:GetValue('ZA2_EMPFIL'),oMdlZA2:GetValue('ZA2_CODAPD'))

				/*If oMdlZA1:GetValue('ZA1_APRFIN') == 'S'
					ExcFRP(oMdlZA2:GetValue('ZA2_EMPFIL'),oMdlZA2:GetValue('ZA2_CODAFN'))
				EndIf*/

			Next ni	
		EndIf

		If lRet
			If oModel:VldData()
				FwFormCommit(oModel)
				
				aDados  := xMC3MntAr(oModel)
				If !Empty(aDados)
					
					aGrades := xMC3EncGra(aDados)
					
					If !Empty(aGrades)

						//xMC3AtGrad(aGrades)
						oProcess := MsNewProcess():New( { || u_xMC3AtGrad( aGrades ) } ,"Aguarde", "Processando...", .F.)
						oProcess:Activate()

					EndIf
				EndIf

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
Programa............: GrvSAK
Autor...............: Joni Lima
Data................: 19/12/2016
Descricao / Objetivo: Realiza Manutencao dos Aprovadores de compras no Protheus
Doc. Origem.........: Contrato - GAP GRADE ERP
Solicitante.........: Cliente
Uso.................: 
Obs.................: Faz manutencao de registro SAK
=====================================================================================
*/
Static Function GrvSAK(oModel,aCampo)

	Local aArea	  	:= GetArea()
	Local aAreaSAK	:= SAK->(GetArea())

	Local oMdlSAK 	:= nil 
	Local oMdlMas 	:= nil
	Local cRet    	:= ''
	Local cOldFil	:= cFilAnt

	dbSelectArea('SAK')
	SAK->(dbSetOrder(1))//AK_FILIAL, AK_COD

	cFilAnt := SubStr(aCampo[1],1,TamSX3('AK_FILIAL')[1])

	oMdlSAK := FWLoadModel('MATA095')

	If !(Empty(aCampo[9])) .and. SAK->(dbSeek(xFilial('SAK',cFilAnt) + aCampo[9]))
		oMdlSAK:SetOperation( MODEL_OPERATION_UPDATE )
	Else
		oMdlSAK:SetOperation( MODEL_OPERATION_INSERT )
	EndIf

	If oMdlSAK:Activate()

		oMdlMas := oMdlSAK:GetModel('SAKMASTER')

		If oMdlSAK:GetOperation() == MODEL_OPERATION_INSERT 
			oMdlMas:SetValue('AK_FILIAL' , cFilAnt )//ZA2_FILIAL
			oMdlMas:SetValue('AK_ZNIVEL' , aCampo[2] )//ZA2_NIVEL
			oMdlMas:SetValue('AK_NOME' 	 , SubStr(Alltrim(aCampo[3]),1,TamSX3('AK_NOME')[1]))//ZA1_DESCRI
			oMdlMas:LoadValue('AK_USER'   , aCampo[8] )//ZA2_CODUSU
			oMdlMas:LoadValue('AK_NOME'   , MGFcRegUs(aCampo[8],'NOME') )//ZA2_CODUSU
		EndIf

		oMdlMas:SetValue('AK_LIMMIN' , aCampo[4] )//ZA2_VALMIN
		oMdlMas:SetValue('AK_LIMMAX' , aCampo[5] )//ZA2_VALMAX
		oMdlMas:SetValue('AK_LIMITE' , aCampo[6] )//ZA2_LIMITE
		oMdlMas:SetValue('AK_TIPO'   , aCampo[7] )//ZA2_TIPO

		cRet := oMdlMas:GetValue('AK_COD')

		If oMdlSAK:VldData()
			FwFormCommit(oMdlSAK)
			oMdlSAK:DeActivate()
			oMdlSAK:Destroy()
		Else
			JurShowErro(oMdlSAK:GetModel():GetErrormessage())
		EndIf

	EndIf

	cFilAnt := cOldFil

	RestArea(aAreaSAK)
	RestArea(aArea)

Return cRet

/*
=====================================================================================
Programa............: ExcSAK
Autor...............: Joni Lima
Data................: 19/12/2016
Descricao / Objetivo: Realiza Exclusao dos Aprovadores de compras no Protheus
Doc. Origem.........: Contrato - GAP GRADE ERP
Solicitante.........: Cliente
Uso.................: 
Obs.................: Faz exclusao de registro SAK
=====================================================================================
*/
Static Function ExcSAK(cxFil,cCod)

	Local aArea	  	:= GetArea()
	Local aAreaSAK	:= SAK->(GetArea())
	Local cOldFil	:= cFilAnt

	Local oMdlSAK 	:= nil 
	Local oMdlMas 	:= nil

	cFilAnt := SubStr(cxFil,1,TamSX3('AK_FILIAL')[1])

	dbSelectArea('SAK')
	SAK->(dbSetOrder(1))//AK_FILIAL, AK_COD	

	If SAK->(dbSeek(xFilial('SAK',cFilAnt) + cCod ))
		oMdlSAK := FWLoadModel('MATA095')
		oMdlSAK:SetOperation( MODEL_OPERATION_DELETE )	
		If oMdlSAK:Activate()
			If oMdlSAK:VldData()
				FwFormCommit(oMdlSAK)
				oMdlSAK:DeActivate()
				oMdlSAK:Destroy()
			Else
				JurShowErro(oMdlSAK:GetModel():GetErrormessage())
			EndIf			
		EndIF
	EndIf

	cFilAnt := cOldFil

	RestArea(aAreaSAK)
	RestArea(aArea)

Return

/*
=====================================================================================
Programa............: GrvFRP
Autor...............: Joni Lima
Data................: 19/12/2016
Descricao / Objetivo: Realiza Manutencao dos Aprovadores de compras no Protheus
Doc. Origem.........: Contrato - GAP GRADE ERP
Solicitante.........: Cliente
Uso.................: 
Obs.................: Faz manutencao de registro SAK
=====================================================================================
*/
Static Function GrvFRP(oModel,aCampo)

	Local aArea	  	:= GetArea()
	Local aAreaFRP	:= FRP->(GetArea())
	Local cRet 		:= ''

	Local oMdlFRP 	:= nil
	Local oMdlMas 	:= nil
	Local cRet    	:= ''
	Local cOldFil	:= cFilAnt

	Local cTp	:= '1' //1=Diario;2=Semanal;3=Mensal                                                                                                     

	cFilAnt := SubStr(aCampo[1],1,TamSX3('FRP_FILIAL')[1])

	dbSelectArea('FRP')
	FRP->(dbSetOrder(1))//FRP_FILIAL, FRP_COD, FRP_MOEDA

	If aCampo[7] == 'D'
		cTp	:= '1'	
	ElseIf aCampo[7] == 'S'
		cTp	:= '2'
	ElseIf aCampo[7] == 'M' 
		cTp	:= '3'
	EndIf

	oMdlFRP := FWLoadModel('MGFCOM04')

	If !(Empty(aCampo[10])) .and. FRP->(dbSeek(xFilial('FRP',cFilAnt) + aCampo[10]))
		oMdlFRP:SetOperation( MODEL_OPERATION_UPDATE )
	Else
		oMdlFRP:SetOperation( MODEL_OPERATION_INSERT )
	EndIf

	If oMdlFRP:Activate()

		oMdlMas := oMdlFRP:GetModel('FRPMASTER')

		If oMdlFRP:GetOperation() == MODEL_OPERATION_INSERT
			oMdlMas:SetValue('FRP_FILIAL' , cFilAnt )//ZA2_FILIAL
			oMdlMas:SetValue('FRP_ZNIVEL' , aCampo[2] )//ZA2_NIVEL
			oMdlMas:SetValue('FRP_USER'   , aCampo[8] )//ZA2_CODUSU
			oMdlMas:SetValue('FRP_MOEDA'  , aCampo[11] )//ZA2_MOEDA			
		EndIf

		oMdlMas:SetValue('FRP_LIMMIN' , aCampo[4] )//ZA2_VALMIN
		oMdlMas:SetValue('FRP_LIMMAX' , aCampo[5] )//ZA2_VALMAX
		oMdlMas:SetValue('FRP_LIMITE' , aCampo[6] )//ZA2_LIMITE
		oMdlMas:SetValue('FRP_TIPO'   , cTp )//ZA2_TIPO

		cRet := oMdlMas:GetValue('FRP_COD')

		If oMdlFRP:VldData()
			FwFormCommit(oMdlFRP)
			oMdlFRP:DeActivate()
			oMdlFRP:Destroy()
		Else
			JurShowErro(oMdlFRP:GetModel():GetErrormessage())
		EndIf	

	EndIf

	cFilAnt := cOldFil

	RestArea(aAreaFRP)
	RestArea(aArea)

Return cRet

/*
=====================================================================================
Programa............: ExcFRP
Autor...............: Joni Lima
Data................: 19/12/2016
Descricao / Objetivo: Realiza Exclusao dos Aprovadores de compras no Protheus
Doc. Origem.........: Contrato - GAP GRADE ERP
Solicitante.........: Cliente
Uso.................: 
Obs.................: Faz Exclusao de registro SAK
=====================================================================================
*/
Static Function ExcFRP(cxFil,cCod)

	Local aArea	  	:= GetArea()
	Local aAreaFRP	:= FRP->(GetArea())
	Local cOldFil	:= cFilAnt

	Local oMdlFRP 	:= nil
	Local oMdlMas 	:= nil

	cFilAnt := SubStr(cxFil,1,TamSx3('FRP_FILIAL')[1])//xFilial('FRP',SubStr(cxFil,1,TamSx3('FRP_FILIAL')[1]))

	dbSelectArea('FRP')
	FRP->(dbSetOrder(1))//FRP_FILIAL, FRP_COD, FRP_MOEDA	

	If FRP->(dbSeek(xFilial('FRP',cFilAnt) + cCod ))
		oMdlFRP := FWLoadModel('MGFCOM04')
		oMdlFRP:SetOperation( MODEL_OPERATION_DELETE)
		If oMdlFRP:Activate()
			If oMdlFRP:VldData()
				FwFormCommit(oMdlFRP)
				oMdlFRP:DeActivate()
				oMdlFRP:Destroy()
			Else
				JurShowErro(oMdlFRP:GetModel():GetErrormessage())
			EndIf			
		EndIF
	EndIf

	cFilAnt := cOldFil

	RestArea(aAreaFRP)
	RestArea(aArea)	

Return

/*
=====================================================================================
Programa............: xMC3Valid
Autor...............: Joni Lima
Data................: 20/01/2016
Descricao / Objetivo: Utilizado na Validacao antes da Grava��o
Doc. Origem.........: Contrato - GAP GRADE ERP
Solicitante.........: Cliente
Uso.................: 
Obs.................: Verifica se tem um usuario ativo por filial.
=====================================================================================
*/
Static Function xMC3Valid(oModel)

	Local aArea 		:= GetArea()
	Local aAreaSM0		:= SM0->(GetArea())
	Local aSaveLines	:= FwSaveRows()
	Local aFils			:= {}
	Local aErr			:= {}

	Local lRet := .T.

	Local oMdlZA2 := oModel:GetModel('ZA2DETAIL')

	Local ni	:= 0 
	Local nPos	:= 0

	Local cMsgErr	:= ''

	dbSelectArea('SM0')
	SM0->(dbSetOrder(1))

	If SM0->(DbSeek(cEmpAnt + SubStr(cFilAnt,1,2)))
		While SM0->(!EOF()) .and. SubStr(SM0->M0_CODFIL,1,2) == SubStr(cFilAnt,1,2)  
			AADD(aFils,{Alltrim(SM0->M0_CODFIL),.F.})
			For ni:= 1  to oMdlZA2:Length()
				oMdlZA2:GoLine(ni)
				If AllTrim(SM0->M0_CODFIL) == AllTrim(oMdlZA2:GetValue('ZA2_EMPFIL')) //.and. AllTrim(oMdlZA2:GetValue('ZA2_BLQAPR')) == 'N'
					nPos := aScan(aFils,{|x| Alltrim(x[1]) == Alltrim(oMdlZA2:GetValue('ZA2_EMPFIL'))})
					aFils[nPos,2] := .T.
					Exit
				EndIf
			Next ni
			SM0->(DbSkip())
		EndDo
	EndIf

	For ni:=1 to Len(aFils)
		If !(aFils[ni,2])
			lRet := .F.
			AADD(aErr,'Unidade: ' + Alltrim(aFils[ni,1]))
		EndIf
	Next ni

	If lRet
		cMsgErr := '� Necessario que em todas as Unidades existam um usuario vinculado ao nivel, favor Verficar a(s) unidade(s) :'// + CRLF
		For ni := 1 to Len(aErr)
			cMsgErr += aErr[ni] //+ CRLF
		Next ni
		cMsgErr += 'Obs.: � Necessario que exista um usuario que NAO esteja bloqueado por Unidade'
	EndIf

	FWRestRows( aSaveLines )
	RestArea(aAreaSM0)
	RestArea(aArea)

Return {lRet,cMsgErr}

/*
=====================================================================================
Programa............: xMC3MntAr
Autor...............: Joni Lima
Data................: 20/01/2016
Descricao / Objetivo: Monta Array na Alteracao caso algum usuario seja bloqueado
Doc. Origem.........: Contrato - GAP GRADE ERP
Solicitante.........: Cliente
Uso.................: 
Obs.................: Retorna Array com Filial,nivel,usuario Antigo,Encontrar
=====================================================================================
*/
Static Function xMC3MntAr(oModel)

	Local aSaveLines 	:= FwSaveRows()
	Local oMdlZA1		:= oModel:GetModel('ZA1MASTER')
	Local oMdlZA2 		:= oModel:GetModel('ZA2DETAIL')
	Local aRet			:= {}
	Local ni
	Local nx

	For ni:= 1  to oMdlZA2:Length()
		oMdlZA2:GoLine(ni)
		If oMdlZA2:IsFieldUpdate('ZA2_BLQAPR',ni)
			If oMdlZA2:GetValue('ZA2_BLQAPR') == 'S'
				AADD(aRet,{oMdlZA2:GetValue('ZA2_EMPFIL'),oMdlZA1:GetValue('ZA1_NIVEL'),oMdlZA2:GetValue('ZA2_CODUSU'),'ENCONTRAR'})
			EndIf		
		EndIf
	Next ni

	For ni := 1 to Len(aRet)
		If aRet[ni,4] == 'ENCONTRAR'
			For nx := 1 to oMdlZA2:Length()
				oMdlZA2:GoLine(ni)
				If Alltrim(oMdlZA2:GetValue('ZA2_EMPFIL')) == Alltrim(aRet[ni,1]) .and. oMdlZA2:GetValue('ZA2_BLQAPR') == 'N'
					aRet[ni,4] := oMdlZA2:GetValue('ZA2_CODUSU')
					Exit
				Endif
			Next nx
		EndIf
	Next ni

	FWRestRows( aSaveLines )

Return aRet

/*
=====================================================================================
Programa............: xMC3EncGra
Autor...............: Joni Lima
Data................: 20/01/2016
Descricao / Objetivo: Encontra Grade onde usuario que foi bloqueado esta associado
Doc. Origem.........: Contrato - GAP GRADE ERP
Solicitante.........: Cliente
Uso.................: 
Obs.................: Encontra as Grades onde usuario Old estava associado
=====================================================================================
*/
Static Function xMC3EncGra(aDados)

	Local aArea	:= GetArea()
	Local aRet	:= {}
	Local ni
	Local cNextAlias := GetNextAlias()

	For ni := 1 to len(aDados)

		cNextAlias := GetNextAlias()

		If Select(cNextAlias) > 0
			(cNextAlias)->(DbClosearea())
		Endif

		BeginSql Alias cNextAlias

		SELECT DISTINCT
			ZAB_CODIGO,
			ZAB_VERSAO
		FROM %Table:SAL% SAL

		INNER JOIN %Table:ZAB% ZAB 
		ON ZAB.ZAB_CODIGO = SAL.AL_ZCODGRD 
		AND ZAB.ZAB_VERSAO = SAL.AL_ZVERSAO
		WHERE 
			SAL.%NotDel% AND
			ZAB.%NotDel% AND
			SAL.AL_FILIAL = %xFilial:SAL% AND
			ZAB.ZAB_FILIAL = %xFilial:ZAB% AND
			SAL.AL_USER = %Exp:aDados[ni,3]% AND
			ZAB.ZAB_HOMOLO = 'S'

		EndSql

		(cNextAlias)->(DbGoTop())
		While (cNextAlias)->(!EOF())			
			AADD(aRet,{(cNextAlias)->ZAB_CODIGO,(cNextAlias)->ZAB_VERSAO})
			(cNextAlias)->(dbSkip())
		EndDo
		(cNextAlias)->(DbClosearea())

	Next ni

	RestArea(aArea)

Return aRet

/*
=====================================================================================
Programa............: xMC3AtGrad
Autor...............: Joni Lima
Data................: 20/01/2016
Descricao / Objetivo: Realiza nova vers�o de uma grade e homologa a mesma
Doc. Origem.........: Contrato - GAP GRADE ERP
Solicitante.........: Cliente
Uso.................: 
Obs.................: Realiza cadastro de uma vers�o para grades e homologa a mesma
=====================================================================================
*/
user Function xMC3AtGrad(aDados)
	
	Local aArea		:= GetArea()
	Local aAreaZAB	:= ZAB->(GetArea())
	
	Local ni
	Local nz
	local nc
	Local oModCOM6 := nil 
	Local oMdlZAB := Nil
	Local oMdlZAC := Nil
	Local oMdlZAD := Nil
	Local oMdlZAE := Nil
	
	Local cTp	   	:= ''
	Local nTp		:= 0
	
	Local cVersao	:= '' 
	Local cPerg 	:= 'MGFCOM06'
	
	local nTotGrade	:= 0
	
	dbSelectArea('ZAB')
	ZAB->(dbSetOrder(1))//ZAB_FILIAL+ZAB_CODIGO+ZAB_VERSAO
	
	Begin Transaction
	
	nTotGrade := len( aDados )
	
	oProcess:SetRegua1( nTotGrade )
	
	For ni := 1 to len(aDados)

		oProcess:IncRegua1("Processando Grade : [" + alltrim( aDados[ nI, 1 ] ) + "]")

		If ZAB->(dbSeek(xFilial('ZAB') + aDados[ni,1] + aDados[ni,2]))
			
			cTp	   	:= ZAB->ZAB_TIPO
			cVersao := aDados[ni,2]
			
			If cTp == 'T'
				nTp := 1
			ElseIf cTp == 'P'
				nTp := 2
			ElseIf cTp == 'C'
				nTp := 3
			EndIf
		
			Pergunte(cPerg,.F.)
			MV_PAR01 := nTp
			
			//Inclusao da Nova versao
			oModCOM6 := FwLoadModel('MGFCOM06')
			
			oModCOM6:SetOperation( MODEL_OPERATION_INSERT )
			
			If oModCOM6:Activate()
				
				xCarModel(@oModCOM6,aDados[ni,1],aDados[ni,2],cTp)
				cVersao := Soma1(cVersao)
				
				oMdlZAB := oModCOM6:GetModel('ZABMASTER')
				
				oMdlZAB:SetValue('ZAB_VERSAO',cVersao)
				oMdlZAB:SetValue('ZAB_HOMOLO','N')
				oMdlZAB:SetValue('ZAB_DTINIC',dDataBase) 				
				
				//Tratamento de Campos Especificos
				If cTp == 'T'
					//oMdlZAB := oModCOM6:GetModel('ZABMASTER')
					oMdlZAC := oModCOM6:GetModel('ZACDETAIL') 
					oMdlZAD := oModCOM6:GetModel('ZADDETAIL')
					
					For nz := 1 to oMdlZAC:Length()
						oMdlZAC:Goline(nz)
						oMdlZAC:LoadValue('ZAC_VERSAO',cVersao)
						For nc := 1 To oMdlZAD:Length()
							oMdlZAD:Goline(nc)
							oMdlZAD:LoadValue('ZAD_VERSAO',cVersao)	
						Next nc
					Next nz
					
				ElseIf cTp == 'P'
					//oMdlZAB := oModCOM6:GetModel('ZABMASTER')
					oMdlZAD := oModCOM6:GetModel('ZADDETAIL') 
					
					For nc := 1 To oMdlZAD:Length()
						oMdlZAD:Goline(nc)
						oMdlZAD:LoadValue('ZAD_VERSAO',cVersao)	
					Next nc					
				
				ElseIf cTp == 'C'
					//oMdlZAB := oModCOM6:GetModel('ZABMASTER')
					oMdlZAE := oModCOM6:GetModel('ZAEDETAIL') 
					oMdlZAD := oModCOM6:GetModel('ZADDETAIL') 

					For nz := 1 to oMdlZAE:Length()
						oMdlZAE:Goline(nz)
						oMdlZAE:LoadValue('ZAE_VERSAO',cVersao)
						For nc := 1 To oMdlZAD:Length()
							oMdlZAD:Goline(nc)
							oMdlZAD:LoadValue('ZAD_VERSAO',cVersao)	
						Next nc
					Next nz
					
				EndIf				
				
				If oModCOM6:VldData()
					oModCOM6:CommitData()
					oModCOM6:DeActivate()
					oModCOM6:Destroy()
				Else
					JurShowErro(oModCOM6:GetModel():GetErrormessage())
				EndIf			
			EndIF
		
			If ZAB->(dbSeek(xFilial('ZAB') + aDados[ni,1] + cVersao))
				//Homologa��o da Nova Versao
				U_xHomologar()
			EndIF
		
		EndIf
	
	next ni
	
	End Transaction
	RestArea(aAreaZAB)
	RestArea(aArea)
Return

/*
=====================================================================================
Programa............: xCarModel
Autor...............: Joni Lima
Data................: 20/01/2016
Descricao / Objetivo: Carrega o Modelo de dados da Grade
Doc. Origem.........: Contrato - GAP GRADE ERP
Solicitante.........: Cliente
Uso.................: 
=====================================================================================
*/
Static Function xCarModel(oModel,cCodigo,cVersao,cTipo)

	Local aArea := GetArea()
	
	Local nLine		:= 1
	Local nAddLin	:= 0
	Local ni
	
	Local cField  := ''
	
	Local oMdlZAB := Nil
	Local oMdlZAC := Nil
	Local oMdlZAD := Nil
	Local oMdlZAE := Nil
	
	Local oStruZAB := {}
	Local oStruZAC := {}
	Local oStruZAD := {}
	Local oStruZAE := {}
	
	Local cQry 	  	:= xQryCopy(cCodigo,cVersao,cTipo)
	Local cChave	:= ''
	
	If Select(cQry) > 0
		
		(cQry)->(dbGoTop())
		
		If cTipo == 'T'
		
			oMdlZAB := oModel:GetModel('ZABMASTER')
			oMdlZAC := oModel:GetModel('ZACDETAIL')
			oMdlZAD := oModel:GetModel('ZADDETAIL')
			
			oStruZAB := oMdlZAB:GetStruct()
			oStruZAC := oMdlZAC:GetStruct()
			oStruZAD := oMdlZAD:GetStruct()

			cChave := (cQry)->(ZAB_FILIAL + ZAB_CODIGO + ZAB_VERSAO + ZAC_GRPPRD)

			//Preenche Cabecalho 
			For ni := 1 To Len(oStruZAB:aFields)
				If !oStruZAB:aFields[ni,14]
					cField := oStruZAB:aFields[ni,3]
					If oStruZAB:aFields[ni,4] == 'D'
						oMdlZAB:LoadValue( cField, SToD((cQry)->&(cField)) )
					Else
						oMdlZAB:LoadValue( cField, (cQry)->&(cField) )
					EndIf
				EndIf
			Next ni
			
			//Preenche Primeiro Grupo de produtos
			For ni := 1 To Len(oStruZAC:aFields)
				If !oStruZAC:aFields[ni,14]
					cField := oStruZAC:aFields[ni,3]
					If oStruZAC:aFields[ni,4] == 'D'
						oMdlZAC:LoadValue( cField, SToD((cQry)->&(cField)) )
					Else
						oMdlZAC:LoadValue( cField, (cQry)->&(cField) )
					EndIf
				EndIf
			Next ni
			
			While (cQry)->(!EOF())
				
				//
				If cChave <> (cQry)->(ZAB_FILIAL + ZAB_CODIGO + ZAB_VERSAO + ZAC_GRPPRD)
					
					cChave := (cQry)->(ZAB_FILIAL + ZAB_CODIGO + ZAB_VERSAO + ZAC_GRPPRD)
					nLine	:= 1
					
					oMdlZAC:AddLine()
					
					//Preenche Proximos Grupo de produtos
					For ni := 1 To Len(oStruZAC:aFields)
						If !oStruZAC:aFields[ni,14]
							cField := oStruZAC:aFields[ni,3]
							If oStruZAC:aFields[ni,4] == 'D'
								oMdlZAC:LoadValue( cField, SToD((cQry)->&(cField)) )
							Else
								oMdlZAC:LoadValue( cField, (cQry)->&(cField) )
							EndIf
						EndIf
					Next ni
				EndIf
				
				If nLine <> 1 
					nAddLin := oMdlZAD:AddLine()
					oMdlZAD:GoLine(nAddLin)
				EndIf

				For ni := 1 To Len(oStruZAD:aFields)
					If !oStruZAD:aFields[ni,14]
						cField := oStruZAD:aFields[ni,3]
						oMdlZAD:LoadValue( cField, (cQry)->&(cField) )
						If oStruZAD:aFields[ni,4] == 'D'
							oMdlZAD:LoadValue( cField, SToD((cQry)->&(cField)) )
						Else
							oMdlZAD:LoadValue( cField, (cQry)->&(cField) )
						EndIf
					EndIf
				Next ni
				
				nLine ++
				
				(cQry)->(DbSkip())
			EndDo
			
			(cQry)->(DBCloseArea())
		ElseIf cTipo == 'P'
	
			oMdlZAB := oModel:GetModel('ZABMASTER')
			oMdlZAD := oModel:GetModel('ZADDETAIL') 
			
			oStruZAB := oMdlZAB:GetStruct()
			oStruZAD := oMdlZAD:GetStruct()			
			
			//Preenche Cabecalho 
			For ni := 1 To Len(oStruZAB:aFields)
				If !oStruZAB:aFields[ni,14]
					cField := oStruZAB:aFields[ni,3]
					If oStruZAB:aFields[ni,4] == 'D'
						oMdlZAB:LoadValue( cField, SToD((cQry)->&(cField)) )
					Else
						oMdlZAB:LoadValue( cField, (cQry)->&(cField) )
					EndIf
				EndIF
			Next ni
			
			While (cQry)->(!EOF())
				
				If oMdlZAD:GetLine() <> 1 
					oMdlZAD:AddLine()
				EndIf

				For ni := 1 To Len(oStruZAD:aFields)
					If !oStruZAD:aFields[ni,14]
						cField := oStruZAD:aFields[ni,3]
						If oStruZAD:aFields[ni,4] == 'D'
							oMdlZAD:LoadValue( cField, SToD((cQry)->&(cField)) )
						Else
							oMdlZAD:LoadValue( cField, (cQry)->&(cField) )
						EndIf
					EndIf
				Next ni
			
				(cQry)->(DbSkip())
			
			EndDo
			
			(cQry)->(DBCloseArea())
		ElseIf cTipo == 'C'
	
			oMdlZAB := oModel:GetModel('ZABMASTER')
			oMdlZAE := oModel:GetModel('ZAEDETAIL')
			oMdlZAD := oModel:GetModel('ZADDETAIL')
			
			oStruZAB := oMdlZAB:GetStruct()
			oStruZAE := oMdlZAE:GetStruct()
			oStruZAD := oMdlZAD:GetStruct()

			cChave := (cQry)->(ZAB_FILIAL + ZAB_CODIGO + ZAB_VERSAO + ZAE_NATURE)

			//Preenche Cabecalho 
			For ni := 1 To Len(oStruZAB:aFields)
				If !oStruZAB:aFields[ni,14]
					cField := oStruZAB:aFields[ni,3]
					If oStruZAB:aFields[ni,4] == 'D'
						oMdlZAB:LoadValue( cField, SToD((cQry)->&(cField)) )
					Else
						oMdlZAB:LoadValue( cField, (cQry)->&(cField) )
					EndIf
				EndIf
			Next ni
			
			For ni := 1 To Len(oStruZAE:aFields)
				If !oStruZAE:aFields[ni,14]
					cField := oStruZAE:aFields[ni,3]
					If oStruZAE:aFields[ni,4] == 'D'
						oMdlZAE:LoadValue( cField, SToD((cQry)->&(cField)) )
					Else
						oMdlZAE:LoadValue( cField, (cQry)->&(cField) )
					EndIf
				EndIf
			Next ni
			
			While (cQry)->(!EOF())
				
				//
				If cChave <> (cQry)->(ZAB_FILIAL + ZAB_CODIGO + ZAB_VERSAO + ZAE_NATURE)
					cChave := (cQry)->(ZAB_FILIAL + ZAB_CODIGO + ZAB_VERSAO + ZAE_NATURE)
					
					oMdlZAE:AddLine()
					
					For ni := 1 To Len(oStruZAE:aFields)
						If !oStruZAE:aFields[ni,14]
							cField := oStruZAE:aFields[ni,3]
							If oStruZAE:aFields[ni,4] == 'D'
								oMdlZAE:LoadValue( cField, SToD((cQry)->&(cField)) )
							Else
								oMdlZAE:LoadValue( cField, (cQry)->&(cField) )
							EndIf
						EndIf
					Next ni
				EndIf
				
				If oMdlZAD:GetLine() <> 1 
					oMdlZAD:AddLine()
				EndIf

				For ni := 1 To Len(oStruZAD:aFields)
					If !oStruZAD:aFields[ni,14]
						cField := oStruZAD:aFields[ni,3]
						If oStruZAD:aFields[ni,4] == 'D'
							oMdlZAD:LoadValue( cField, SToD((cQry)->&(cField)) )
						Else
							oMdlZAD:LoadValue( cField, (cQry)->&(cField) )
						EndIf
					EndIf
				Next ni
			
				(cQry)->(DbSkip())
				
			EndDo		

			(cQry)->(DBCloseArea())
		EndIf
	EndIf

	RestArea(aArea)

	if Select(cQry) > 0
		(cQry)->(DBCloseArea())
	endif
Return

/*
=====================================================================================
Programa............: xQryCopy
Autor...............: Joni Lima
Data................: 20/01/2016
Descricao / Objetivo: Realiza query das grades que precisaram ser executados
Doc. Origem.........: Contrato - GAP GRADE ERP
Solicitante.........: Cliente
Uso.................: 
=====================================================================================
*/
Static Function xQryCopy(cCodigo,cVersao,cTipo)

	Local cNextAlias := GetNextAlias()

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif

	If cTipo == 'T'

		BeginSql Alias cNextAlias
			
			SELECT *
			FROM %Table:ZAB% ZAB
			INNER JOIN %Table:ZAC% ZAC
				 ON ZAC.ZAC_CODIGO = ZAB.ZAB_CODIGO
				AND ZAC.ZAC_VERSAO = ZAB.ZAB_VERSAO
			INNER JOIN %Table:ZAD% ZAD
				 ON ZAD.ZAD_CODIGO = ZAC.ZAC_CODIGO
				AND	ZAD.ZAD_VERSAO = ZAC.ZAC_VERSAO
				AND ZAD.ZAD_GRPPRD = ZAC.ZAC_GRPPRD 		
			WHERE
				ZAB.ZAB_FILIAL = %xFilial:ZAB% AND
				ZAC.ZAC_FILIAL = ZAB.ZAB_FILIAL AND
				ZAD.ZAD_FILIAL = ZAC.ZAC_FILIAL AND
				
				ZAB.%NotDel% AND
				ZAC.%NotDel% AND
				ZAD.%NotDel% AND
				
				ZAB.ZAB_CODIGO = %Exp:cCodigo% AND
				ZAB.ZAB_VERSAO = %Exp:cVersao%
				//ZAB.ZAB_HOMOLO = 'S'
		EndSql

	ElseIf cTipo == 'P'

		BeginSql Alias cNextAlias

			SELECT *
			FROM %Table:ZAB% ZAB
			INNER JOIN %Table:ZAD% ZAD
				 ON ZAD.ZAD_CODIGO = ZAB.ZAB_CODIGO
				AND	ZAD.ZAD_VERSAO = ZAB.ZAB_VERSAO
			WHERE		
				ZAB.ZAB_FILIAL = %xFilial:ZAB% AND
				ZAD.ZAD_FILIAL = ZAB.ZAB_FILIAL AND

				ZAB.%NotDel% AND
				ZAD.%NotDel% AND

				ZAB.ZAB_CODIGO = %Exp:cCodigo% AND
				ZAB.ZAB_VERSAO = %Exp:cVersao%

		EndSql


	ElseIf cTipo == 'C'

		BeginSql Alias cNextAlias

			SELECT *
			FROM %Table:ZAB% ZAB
			INNER JOIN %Table:ZAE% ZAE
				 ON ZAE.ZAE_CODIGO = ZAB.ZAB_CODIGO
				AND ZAE.ZAE_VERSAO = ZAB.ZAB_VERSAO
			INNER JOIN %Table:ZAD% ZAD
				 ON ZAD.ZAD_CODIGO = ZAE.ZAE_CODIGO
				AND	ZAD.ZAD_VERSAO = ZAE.ZAE_VERSAO
				AND ZAD.ZAD_NATURE = ZAE.ZAE_NATURE 		
			WHERE
				ZAB.ZAB_FILIAL = %xFilial:ZAB% AND
				ZAE.ZAE_FILIAL = ZAB.ZAB_FILIAL AND
				ZAD.ZAD_FILIAL = ZAE.ZAE_FILIAL AND
				
				ZAB.%NotDel% AND
				ZAE.%NotDel% AND
				ZAD.%NotDel% AND
				
				ZAB.ZAB_CODIGO = %Exp:cCodigo% AND
				ZAB.ZAB_VERSAO = %Exp:cVersao%
				//ZAB.ZAB_HOMOLO = 'S'
		EndSql

	EndIf

	(cNextAlias)->(DbGoTop())

Return cNextAlias

/*
=====================================================================================
Programa............: xMGC3EncUs
Autor...............: Joni Lima
Data................: 05/01/2016
Descricao / Objetivo: Realiza preenchimento do cod de aprovador pedido e se necessario financeiro
Doc. Origem.........: Contrato - GAP GRADE ERP
Solicitante.........: Cliente
Uso.................: 
Obs.................: Busca informacoes SAK e FRP
=====================================================================================
*/
User Function xMGC3EncUs(xcFil,xcUser,cTp)

	Local aArea 	:= GetArea()
	Local aAreaSAK	:= SAK->(GetArea())
	Local aAreaFRP	:= FRP->(GetArea())

	Local cRet 		:= ''
	Local cOldFil 	:= cFilAnt

	Local oModel	:= FwModelActive()
	Local oMdlZA1	:= oModel:GetModel('ZA1MASTER')

	If cTp == 'PED'	
		cFilAnt := SubStr(xcFil,1,TamSx3('AK_FILIAL')[1])

		dbSelectArea('SAK')
		SAK->(dbSetOrder(2))//AK_FILIAL, AK_USER

		If SAK->(dbSeek( xFilial('SAK') + xcUser ))
			cRet := SAK->AK_COD	
		EndIf
	ElseIf cTp == 'FIN'
		/*If oMdlZA1:GetValue('ZA1_APRFIN') == 'S'
			cFilAnt := SubStr(xcFil,1,TamSx3('FRP_FILIAL')[1])

			dbSelectArea('FRP')
			FRP->(dbSetOrder(2))//FRP_FILIAL, FRP_USER, FRP_MOEDA

			If FRP->(dbSeek( xFilial('FRP') + xcUser ))
				cRet := FRP->FRP_COD
			EndIf
		EndIf*/
	EndIf

	cFilAnt := cOldFil

	RestArea(aAreaFRP)
	RestArea(aAreaSAK)
	RestArea(aArea)

Return cRet

/*
=====================================================================================
Programa............: MGF3Achr
Autor...............: Joni Lima
Data................: 20/01/2016
Descricao / Objetivo: Encontra os Prazos para o aprovador informado
Doc. Origem.........: Contrato - GAP GRADE ERP
Solicitante.........: Cliente
Uso.................: 
Obs.................: Retorna um array com {Prazo SC, Prazo PC, Prazo CP}
=====================================================================================
*/
User Function MGF3Achr(cCodAprv)

	Local aArea	:= GetArea()
	Local aRet := {'01','01','01'}
	Local cNextAlias:= GetNextAlias()	

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif

	BeginSql Alias cNextAlias	

	SELECT	
		ZA1.ZA1_SCHORA,
		ZA1.ZA1_PCHORA,
		ZA1.ZA1_CPHORA
	FROM 
		%Table:ZA1% ZA1
		INNER JOIN %Table:ZA2% ZA2 
	ON	ZA2.ZA2_FILIAL = ZA1.ZA1_FILIAL AND 
		ZA1.ZA1_NIVEL= ZA2.ZA2_NIVEL 
		INNER JOIN %Table:SAK% SAK 
	ON	SAK.AK_FILIAL = %xFilial:SAK% AND 
		ZA2.ZA2_EMPFIL = SAK.AK_FILIAL AND 
		SAK.AK_ZNIVEL = ZA2.ZA2_NIVEL 
	WHERE 
		ZA1.%NotDel% AND 
		ZA2.%NotDel% AND 
		SAK.%NotDel% AND
		SAK.AK_COD = %Exp:cCodAprv%

	EndSql

	(cNextAlias)->(DbGoTop())

	While (cNextAlias)->(!EOF())
		aRet := {}
		AADD(aRet,(cNextAlias)->ZA1_SCHORA)
		AADD(aRet,(cNextAlias)->ZA1_PCHORA)
		AADD(aRet,(cNextAlias)->ZA1_CPHORA)
		(cNextAlias)->(dbSkip())
	EndDo

	(cNextAlias)->(DbClosearea())

	RestArea(aArea)

Return aRet

/*
=====================================================================================
Programa............: MGFc3USER
Autor...............: Joni Lima
Data................: 20/01/2016
Descricao / Objetivo: Retorna Dados para o usuario
Doc. Origem.........: Contrato - GAP GRADE ERP
Solicitante.........: Cliente
Uso.................: 
=====================================================================================
*/
User Function MGFc3USER(cCodUsu,lXIncl)

	Local 	cRet 	:= ''//IIF(INCLUI,'',)
	Local 	nPos 	:= 0	
	Default lXIncl 	:= .F.

	If !lXIncl
		
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
	EndIf

return cRet

/*
=====================================================================================
Programa............: MGFcRegUs
Autor...............: Joni Lima
Data................: 20/01/2016
Descricao / Objetivo: Retorna Dados para o usuario
Doc. Origem.........: Contrato - GAP GRADE ERP
=====================================================================================
*/
Static Function MGFcRegUs(cCodUsu,cField)

	Local cRet := ''
	Local nPos := 0
	Local nCampo := 2

	If Type('__aXAllUser') <> 'A'
		U_xMGC10CRIP()
	EndIf

	If ALLTRIM(UPPER(cField)) == 'NOME'
		nCampo := 4
	EndIf

	If ValType(__aXAllUser) == 'A'
		nPos := aScan(__aXAllUser,{|x| Alltrim(x[2]) == Alltrim(cCodUsu)})
		If nPos > 0
			cRet := Alltrim(__aXAllUser[nPos][nCampo])
		EndIf
	EndIf

Return cRet

User Function xMG3VldE(oMdlZA2,cFld,xValor,nLin)
	
	Local lRet := .T.
	Local nPos := 0
	
	If Type('__aXAllUser') <> 'A'
		U_xMGC10CRIP()
	EndIf	
	
	nPos := aScan(__aXAllUser,{|x| Alltrim(x[2]) == Alltrim(xValor)})
	cEmail := Alltrim(__aXAllUser[nPos][5])
	
	If Empty(cEmail)
		oMdlZA2:GetModel():SetErrorMessage(oMdlZA2:GetId(),cFld,oMdlZA2:GetModel():GetId(),cFld,cFld,;
		"Usuario sem e-mail cadastrado", "cadastre um e-mail para esse usuario" )
		lRet := .F.
	EndIf

Return lRet

//--------------------------------------------
// Valida o usuario digitado no cadastro de niveis
// tambem sera executado no cadastro de substitutos
//--------------------------------------------
user function chkUsZA2(cCodUsr)
	local lRet		:= .F.
	local cQryUsr	:= ""

	cQryUsr := "SELECT USR_ID,USR_EMAIL"
	cQryUsr += " FROM SYS_USR USR"
	cQryUsr += " WHERE"
	cQryUsr += " 		USR.USR_CODIGO	=	'" + cCodUsr + "'"
	cQryUsr += " 	AND	USR.D_E_L_E_T_	<>	'*'"

	TcQuery cQryUsr New Alias "QRYUSR"

	If !QRYUSR->(EOF())
		If !(Empty(QRYUSR->USR_EMAIL))
			lRet := .T.
		Else
			Help('',1,'Usuario Sem E-mail',,'Usuario nao tem E-mail Cadastrado.', 1, 0)
		EndIf
	else
		Help('',1,'Usuario nao localizado',,'Usuario nao localizado. Informe um usuario valido.', 1, 0)
	endif

	QRYUSR->(DBCloseArea())
return lRet

//--------------------------------------------
//--------------------------------------------
user function XMCOM03A(cLogin)
	local cRet		:= ""
	local cQryUsr	:= ""

	cQryUsr := "SELECT USR_ID"
	cQryUsr += " FROM SYS_USR USR"
	cQryUsr += " WHERE"
	cQryUsr += " 		USR.USR_CODIGO	=	'" + cLogin + "'"
	cQryUsr += " 	AND	USR.D_E_L_E_T_	<>	'*'"

	TcQuery cQryUsr New Alias "QRYUSR"

	if !QRYUSR->(EOF())
		cRet := allTrim(QRYUSR->USR_ID)
	endif

	QRYUSR->(DBCloseArea())
return cRet

User Function XMC3NOMUS()

	local cRet		:= ""
	local cQryUsr	:= ""

	cQryUsr := "SELECT USR_NOME"
	cQryUsr += " FROM SYS_USR USR"
	cQryUsr += " WHERE"
	cQryUsr += " 		USR.USR_ID	=	'" + __CUSERID + "'"
	cQryUsr += " 	AND	USR.D_E_L_E_T_	<>	'*'"

	TcQuery cQryUsr New Alias "QRYUSR2"

	if !QRYUSR2->(EOF())
		cRet := allTrim(QRYUSR2->USR_NOME)
	endif

	QRYUSR2->(DBCloseArea())
	
return cRet

Static Function xAtUser(cUserOld,cUserNew,cxFil)

	Local cUpd		:= ''

	cUpd := "UPDATE " + RetSQLName("SCR")  + " SCR " + CRLF
	cUpd += " SET CR_USER = '" + cUserNew + "' " + CRLF
	cUpd += " WHERE " + CRLF
	cUpd += " SCR.D_E_L_E_T_ = ' ' AND " + CRLF
	cUpd += " SCR.CR_USER = '" + cUserOld + "' AND " + CRLF
	cUpd += " SCR.CR_FILIAL = '" + cxFil + "' AND " + CRLF	
	cUpd += " SCR.CR_STATUS IN ('01','02') AND " + CRLF
	cUpd += " SCR.CR_DATALIB = ' ' "

	TcSQLExec(cUpd)

	//MemoWrit( "C:\TEMP\" + FunName() + "-1-UPD-xAtUser-"+DTOS(Date()) + StrTran(Time(),":") + ".SQL" , cUpd )	
	
return

