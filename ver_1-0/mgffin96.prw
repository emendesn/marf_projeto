#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE 'FWMVCDEF.CH'

/*
=====================================================================================
Programa............: MGFFIN96
Autor...............: Joni Lima
Data................: 01/04/2016
Descrição / Objetivo: Aprovação da Unidade
Doc. Origem.........: Contrato - GAP Caixinha
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Tela para Aprovação do Caixinha
=====================================================================================
*/
user function MGFFIN96()

	Local cFiltro	:= "Empty(ZE0_APRUNI)"
	Local cPerg		:= "MGFFINCAIX"

	Private oBrowse

	If Pergunte(cPerg,.T.)

		cFiltro	:= "Empty(ZE0_APRUNI) .and. ZE0_CAIXA == '" + Alltrim(MV_PAR01) + "'"

		oBrowse := FWMBrowse():New()
		oBrowse:SetAlias('ZE0')

		oBrowse:SetFilterDefault(cFiltro)

		oBrowse:SetDescription('Aprovação Unidade')

		oBrowse:Activate()
	EndIf

return

/*
=====================================================================================
Autor...............: Joni Lima
Data................: 01/04/2016
Descrição / Objetivo: Titulo do Caixinha
Obs.................: Modelo de Dados
=====================================================================================
*/
Static Function ModelDef()

	local oModel := nil

	Local oStrZE1 	:= FWFormStruct(1,"ZE1")
	Local oStrZE0 	:= FWFormStruct(1,"ZE0",{ |x| ALLTRIM(x) $ 'ZE0_FILIAL,ZE0_VIAGEM;ZE0_ITEM,ZE0_MARKUN,ZE0_EMISSA;ZE0_NATURE;ZE0_DESCNA;ZE0_NRCOMP;ZE0_VALOR;ZE0_OBSLIN;ZE0_CAIXA;ZE0_APRUNI' })

	Local bActive	:= {|oModel|xActivMdl(oModel)}
	Local bCommit	:= {|oModel|xCommit(oModel)}

	oModel := MPFormModel():New("XMGFFIN96", /*bPreValidacao*/,/*bPosValid*/,/*bCommit*/bCommit,/*bCancel*/ )

	oModel:AddFields("ZE1MASTER",/*cOwner*/,oStrZE1, /*bPreValid*/, /*bPosValid*/, /*bCarga*/ )
	oModel:AddGrid("ZE0DETAIL","ZE1MASTER",oStrZE0, /*bLinePreValid*/, /*bLinePosValid*/,/*bPreValid*/,/*bPosValid*/, /*bCarga*/ )

	oModel:GetModel("ZE0DETAIL"):SetDescription("Itens Para Aprovação")

	oModel:AddCalc("CALC", "ZE1MASTER", "ZE0DETAIL", "ZE0_VALOR", "ZE0__TOT", "SUM", {|oModel|xVldSum(oModel)}, ,"Total")

	oModel:SetRelation("ZE0DETAIL",{{"ZE1_FILIAL","xFilial('ZE1')"},{"ZE0_NAPRUN ", "ZE1_NUMAPR"}},ZE0->(IndexKey(3)))

	oModel:GetModel("ZE0DETAIL"):SetOnlyQuery()

	oModel:SetDescription("Titulos Caixinha")
	oModel:SetPrimaryKey({"ZE1_FILIAL","ZE1_NUMAPR"})

	oModel:SetActivate(bActive)

return oModel

/*
=====================================================================================
Autor...............: Joni Lima
Data................: 01/04/2016
Descrição / Objetivo: Titulo do Caixinha
Obs.................: View da Tela
=====================================================================================
*/
Static Function ViewDef()

	Local oView := nil

	Local oModel  	:= FWLoadModel('MGFFIN96')

	Local oStrZE1  := FWFormStruct( 2, "ZE1")
	Local oStrZE0  := FWFormStruct( 2, 'ZE0',{ |x| ALLTRIM(x) $ 'ZE0_MARKUN,ZE0_VIAGEM,ZE0_EMISSA;ZE0_NATURE;ZE0_DESCNA;ZE0_NRCOMP;ZE0_VALOR;ZE0_OBSLIN;ZE0_CAIXA' },/*lViewUsado*/ )

	Local oCalc1	:= FWCalcStruct( oModel:GetModel( 'CALC') )

	oStrZE0:SetProperty( 'ZE0_MARKUN' , MVC_VIEW_ORDEM,'01')

	oStrZE0:SetProperty( '*' , MVC_VIEW_CANCHANGE,.F.)
	oStrZE0:SetProperty( 'ZE0_MARKUN' , MVC_VIEW_CANCHANGE,.T.)

	oView := FWFormView():New()
	oView:SetModel(oModel)

	oView:AddField( 'VIEW_ZE1' , oStrZE1, 'ZE1MASTER' )
	oView:AddGrid( 'VIEW_ZE0'  , oStrZE0, 'ZE0DETAIL' )
	oView:AddField( 'VIEW_CALC', oCalc1, 'CALC' )

	oView:CreateHorizontalBox( 'SUPERIOR' , 25 )
	oView:CreateHorizontalBox( 'MEIO' 	  , 65 )
	oView:CreateHorizontalBox( 'INFERIOR' , 10 )

	oView:SetOwnerView( 'VIEW_ZE1' , 'SUPERIOR' )
	oView:SetOwnerView( 'VIEW_ZE0' , 'MEIO' )
	oView:SetOwnerView( 'VIEW_CALC', 'INFERIOR' )

return oView

/*
=====================================================================================
Autor...............: Joni Lima
Data................: 01/04/2016
Descrição / Objetivo: Titulo do Caixinha
Obs.................: Menu da Tela do Caixinha
=====================================================================================
*/
Static function MenuDef()

	Local aRotina := {}

	//ADD OPTION aRotina Title "Liberacao Lote"  	Action 'U_xMGF96Apv()'		OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE "Aprovar"    		ACTION "VIEWDEF.MGFFIN96" OPERATION MODEL_OPERATION_INSERT ACCESS 0

Return aRotina

/*
=====================================================================================
Autor...............: Joni Lima
Data................: 01/04/2016
Descrição / Objetivo: Titulo do Caixinha
Obs.................: Preenchimento da Tela para Aprovação
=====================================================================================
*/
Static Function xActivMdl(oModel)

	Local oMdlZE1 := oModel:GetModel("ZE1MASTER")
	Local oMdlZE0 := oModel:GetModel("ZE0DETAIL")
	Local nLine		:= 1
	Local nx		:= 0
	Local cQry	 	:= xQryLote()

	Local oStrZE0   := oMdlZE0:GetStruct()

	Local cField	:= ""
	Local cConte	:= ""
	Local cFldQry	:= ""

	If oModel:GetOperation() == MODEL_OPERATION_INSERT

		oMdlZE1:LoadValue("ZE1_NUMAPR",GetSXENUM("ZE1","ZE1_NUMAPR"))
		oMdlZE1:LoadValue("ZE1_TIPO","U")
		oMdlZE1:LoadValue("ZE1_CAIXA",ZE0->ZE0_CAIXA)
		oMdlZE1:LoadValue("ZE1_DATA",dDataBase)

		(cQry)->(dbGoTop())

		While (cQry)->(!EOF())

			If nLine <> 1
				oMdlZE0:AddLine()
			EndIf

			For nx := 1 to Len(oStrZE0:aFields)
				If !oStrZE0:aFields[nx,14] //Verifica Se não é Virtual

					cField  := oStrZE0:aFields[nx,3]//Pega o Id do Campo
					cFldQry := "(cQry)->" + cField //Monta Expressão para macro execução
					cConte  := &( cFldQry ) //Pega o Conteudo da Query

					If !Empty(cConte) //.and. Alltrim(cField) <> "ZE0_MARKUN"//Verifica se o existe conteudo
						oMdlZE0:GoLine(nLine)

						If oStrZE0:aFields[nx,4] == 'D'
							oMdlZE0:SetValue(cField,StoD(cConte))
						ElseIf oStrZE0:aFields[nx,4] == 'L'
							oMdlZE0:SetValue(cField,IIf(ALLTRIM(cConte)=="T",.T.,.F.))
						Else
							oMdlZE0:SetValue(cField,cConte)
						EndIf

					EndIf
				EndIf
			Next nx

			nLine ++

			(cQry)->(dbSkip())
		EndDo

	EndIf

return .t.

/*
=====================================================================================
Autor...............: Joni Lima
Data................: 01/04/2016
Descrição / Objetivo: Titulo do Caixinha
Obs.................: Encontra os Titulos que precisam ser aprovados
=====================================================================================
*/
Static Function xQryLote()

	Local cNextAlias:= GetNextAlias()

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif

	BeginSql Alias cNextAlias

		SELECT ZE0.*
		FROM
		%Table:ZE0% ZE0
		WHERE
		ZE0.ZE0_APRUNI = ' ' AND
		ZE0.ZE0_CAIXA = %Exp:ZE0->ZE0_CAIXA% AND
		ZE0.%NotDel%

	EndSql

return (cNextAlias)

/*
=====================================================================================
Autor...............: Joni Lima
Data................: 01/04/2016
Descrição / Objetivo: Titulo do Caixinha
Obs.................: Validação para soma do Total
=====================================================================================
*/
Static Function xVldSum(oModel)

	Local oMldZE0 := oModel:GetModel("ZE0DETAIL")

	Local lRet := .F.

	If (oMldZE0:GetValue("ZE0_MARKUN"))
		lRet := .T.
	EndIf

return lRet

/*
=====================================================================================
Autor...............: Joni Lima
Data................: 01/04/2016
Descrição / Objetivo: Titulo do Caixinha
Obs.................: Commit do modelo de dados
=====================================================================================
*/
Static Function xCommit(oModel)

	Local aSaveArea := GetArea()

	Local oMdlZE1 := oModel:GetModel("ZE1MASTER")
	Local oMdlZE0 := oModel:GetModel("ZE0DETAIL")

	Local ni
	Local nx

	Local cConte

	Local lRet := .T.

	Local _nSalCxa:= 0
	Local _nSomZE0:= 0
	Local _cCaixa:= ""


	If oModel:VldData()

		For ni := 1  to oMdlZE0:Length()
			oMdlZE0:GoLine(ni)//Posiciona na Linha por garantia
			If (oMdlZE0:GetValue("ZE0_MARKUN"))
				_nSomZE0+=oMdlZE0:GetValue("ZE0_VALOR")
			EndIf
		Next ni

		_cCaixa:=oMdlZE0:GetValue("ZE0_CAIXA")
		If !Empty(_cCaixa)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Posiciona-se no caixinha                               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SET")
			dbSetOrder(1)
			dbSeek( xFilial()+_cCaixa)
			_nSalCxa := SET->ET_SALDO
			If _nSomZE0 > _nSalCxa
				Help(" ",1,'ERRO',,'Valor Total das Despesas Aprovadas: R$ ' + Transform(_nSomZE0, "@E 999,999,999,999.99") + ' maior que do Saldo da Caixinha ',1,0,,,,,,{'Saldo de Caixinha de R$ ' + Transform(_nSalCxa, "@E 999,999,999,999.99") } ) 
				lRet := .F.
			Else
				If _nSomZE0 == 0 // deriva de que a despesa está incorreta em termos de valor ou nenhuma despesa foi marcada no Grid 
					Help(" ",1,'ERRO',,'Valor Total das Despesas Aprovadas está Zerada: R$ ' + Transform(_nSomZE0, "@E 999,999,999,999.99") ,1,0,,,,,,{'Verifique os Valores das Despesas ou se houve marcação no Grid' } ) 
					lRet := .F.
				EndIf	
			EndIf
		EndIf 

		If lRet
			FWFormCommit(oModel)

			For ni := 1  to oMdlZE0:Length()
				oMdlZE0:GoLine(ni)//Posiciona na Linha por garantia
				If (oMdlZE0:GetValue("ZE0_MARKUN"))
					xMGF96Apv(oMdlZE0:GetValue("ZE0_FILIAL"),oMdlZE0:GetValue("ZE0_VIAGEM"),oMdlZE0:GetValue("ZE0_ITEM"),oMdlZE1:GetValue("ZE1_NUMAPR"))
				EndIf
			Next ni

			oModel:DeActivate()
			confirmSX8()
		Else
			RollBackSX8()
			lRet := .F.
			DisarmTransaction()
		EndIf

	Else
		RollBackSX8()
		JurShowErro( oModel:GetModel():GetErrormessage() )
		lRet := .F.
		DisarmTransaction()
	EndIf

	RestArea(aSaveArea)
return lRet

/*
=====================================================================================
Autor...............: Joni Lima
Data................: 01/04/2016
Descrição / Objetivo: Titulo do Caixinha
Obs.................: Grava o Aprovador
=====================================================================================
*/
Static Function xMGF96Apv(cFilZE0,cViagem,cItem,cNumApr)

	Local aArea	 	:= GetArea()
	Local aAreaZE0	:= ZE0->(GetArea())

	dbSelectArea('ZE0')
	ZE0->(dbSetOrder(2))//ZE0_FILIAL+ZE0_VIAGEM+ZE0_ITEM

	If ZE0->(dbSeek(cFilZE0 + cViagem + cItem))
		RecLock("ZE0",.F.)
		ZE0->ZE0_MARKUN := .T.
		ZE0->ZE0_APRUNI := USRRETNAME(RETCODUSR())
		ZE0->ZE0_NAPRUN := cNumApr
		ZE0->(MsUnLock())
	EndIf

	RestArea(aAreaZE0)
	RestArea(aArea)

Return