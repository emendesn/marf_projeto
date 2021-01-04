#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'
#Include "Topconn.ch"

/*
===========================================================================================
Programa.:              MGFEST44
Autor....:              Rafael Garcia
Data.....:              Novembro/2018
Descricao / Objetivo:   Tira Reserva SB2
Doc. Origem:            
Solicitante:            Cliente
Uso......:              
Obs......:               
===========================================================================================
*/
User Function MGFEST44()
	LOCAL aFieldCab:= {}
	local cFieldMark:="B2_ZMARCA" 
	Private oBrowse
	Private aMark := {}

	AADD(aFieldCab,'B2_FILIAL')
	AADD(aFieldCab,'B2_LOCAL')
	AADD(aFieldCab,'B2_COD')
	AADD(aFieldCab,'B2_DPROD')
	AADD(aFieldCab,'B2_RESERVA')

	oBrowse := FWMarkBrowse():New()
	oBrowse:SetAlias('SB2')
	oBrowse:SetDescription('Reservas')
	oBrowse:SetFieldMark(cFieldMark)
	oBrowse:SetFilterDefault('B2_FILIAL==XFILIAL("SB2") .AND. B2_RESERVA <> 0  .AND. (B2_QEMP<>0 .or. B2_RESERVA<>0 .or. B2_QACLASS<>0 .OR. B2_NAOCLAS<>0)')
	oBrowse:SetOnlyFields( aFieldCab )
	aRotina := oBrowse:SetMenuDef("MGFEST44")
	oBrowse:SetCustomMarkRec( {|| Est44Mk(cFieldMark) } )
	oBrowse:SetAllMark( {|| marktudo(cFieldMark) } )
	oBrowse:Activate()

Return NIL


Static Function MenuDef()

	Local aRotina := {}

	ADD OPTION aRotina TITLE 'Visualizar' 	   		ACTION 'VIEWDEF.MGFEST44' 	OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Zerar Reserva'		ACTION 'U_Est44Res()' 		OPERATION 4 ACCESS 0

Return aRotina


Static Function ModelDef()

	// Cria a estrutura a ser usada no Modelo de Dados
	Local oStruSB2 := FWFormStruct( 1, 'SB2')
	Local oModel


	Local oStr1:=FWFormStruct(1,'SB2')
	oModel := MPFormModel():New("EST44", /*bPreValidacao*/,/*bPosValidacao*/,/*bCommit*/,/*bCancel*/ )

	// Adiciona ao modelo uma estrutura de formulario de edicao por campo


	oModel:AddFields( 'EST44MASTER', /*cOwner*/, oStr1, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

	// Adiciona a descricao do Modelo de Dados
	oModel:SetDescription( 'Zerar Reservas SB2' )



Return oModel


Static Function ViewDef()

	// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	Local oModel   := FWLoadModel( 'MGFEST44' )

	// Cria a estrutura a ser usada na View
	Local oStruSB2 := FWFormStruct( 2, 'SB2',,/*lViewUsado*/ )

	Local oView

	// Cria o objeto de View
	oView := FWFormView():New()

	// Define qual o Modelo de dados sera utilizado
	oView:SetModel( oModel )

	//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
	oView:AddField( 'VIEW_SB2', oStruSB2, 'EST44MASTER' )

	// Criar um "box" horizontal para receber algum elemento da view

	oView:CreateHorizontalBox( 'SUPERIOR' , 100 )

	// Relaciona o ID da View com o "box" para exibicao
	oView:SetOwnerView( 'VIEW_SB2', 'SUPERIOR' )

Return oView

Static Function Est44Mk(cField)

	Local cFldMrk := ""
	Local cAlias := oBrowse:Alias()
	Local nPos := 0

	cFldMrk := cAlias+'->'+cField
	// Verifica se o item esta sendo marcado ou desmarcado
	If !oBrowse:IsMark()
		(cAlias)->(RecLock(cAlias,.F.))
		&cFldMrk := oBrowse:Mark()
		(cAlias)->(MsUnLock())
		If (nPos:=aScan(aMark,{|x| x[1]==(cAlias)->(Recno())})) == 0
			aAdd(aMark,{(cAlias)->(Recno()),.T.})
		Else
			aMark[nPos][2] := .T.	
		Endif	
	Else
		(cAlias)->(RecLock(cAlias,.F.))
		&cFldMrk := ""
		(cAlias)->(MsUnLock())
		If (nPos:=aScan(aMark,{|x| x[1]==(cAlias)->(Recno())})) > 0
			aMark[nPos][2] := .F.
		Endif	
	EndIf

Return .T.

Static Function marktudo(cFieldMark)

	Local cAlias	:= oBrowse:Alias()
	Local aRest		:= GetArea()

	(cAlias)->(DbGoTop())
	While (cAlias)->(!Eof())
		If (!oBrowse:IsMark())
			RecLock(cAlias,.F.)
			(cAlias)->&cFieldMark  := oBrowse:Mark()
			(cAlias)->(MsUnLock())			
		Else
			RecLock(cAlias,.F.)
			(cAlias)->&cFieldMark  := ""
			(cAlias)->(MsUnLock())
		EndIf
		(cAlias)->(DbSkip())
	EndDo

	RestArea(aRest)

	oBrowse:refresh(.F.)
Return .T.

USER Function Est44Res()

	Local aArea		:= GetArea()
	Local aAreaSB2 	:= SB2->(GetArea())
	Local aAreaBrw  := oBrowse:Alias()
	Local aVetor := {}
	Local lRetorno	:= .T.
	Local lGoTop 	:= .T.
	Local nReg		:= 0
	Local cMark     := oBrowse:Mark()
	Local cFiltro   := ''

	If MsgYesNo("Confirma Zerar Empenho ? ","Zerar Empenho")
		//Filtro padrao executado na Tela
		cFiltro := 'B2_FILIAL==XFILIAL("SB2") .AND. B2_RESERVA <> 0  .AND. (B2_QEMP<>0 .or. B2_RESERVA<>0 .or. B2_QACLASS<>0 .OR. B2_NAOCLAS<>0) '

		(aAreaBrw)->(DBSetFilter(&('{||' + cFiltro + '}'),cFiltro))

		BEGIN TRANSACTION

			ProcRegua((aAreaBrw)->(RECCOUNT()))

			(aAreaBrw)->(DbGoTop())

			While (aAreaBrw)->(!Eof())

				If oBrowse:IsMark(cMark)


					RecLock((aAreaBrw),.F.)
					(aAreaBrw)->B2_ZMARCA  := ""
					(aAreaBrw)->B2_RESERVA :=0	
					(aAreaBrw)->(MsUnLock())

				EndIf




				(aAreaBrw)->( DbSkip() )

			EndDo

		END TRANSACTION

	endif
	RestArea(aAreaSb2)
	RestArea(aArea)

	oBrowse:Refresh(lGoTop)


Return
