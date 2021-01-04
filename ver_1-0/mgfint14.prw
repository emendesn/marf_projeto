#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'TBICONN.CH'

/*
=====================================================================================
Programa.:              MGFINT14
Autor....:              Luis Artuso
Data.....:              05/09/2016
Descricao / Objetivo:   Execucao do P.E. F420CRP
Doc. Origem:            Contrato - GAP MGFINT03
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
User Function MGFINT14()

	Local oOK		:= LoadBitmap(GetResources(),"LBOK")
	Local oNO		:= LoadBitmap(GetResources(),"LBNO")
	Local nX		:= 0
	Local nLen		:= 0
	Local aBrowse	:= {}
	Local cMvPar01	:= ""
	Local cMvPar02	:= ""
	Local aDir01	:= {}
	Local aDir02	:= {}
	Local aSelected	:= {}
	Local lContinua	:= .F.
	Local cNomePar01:= ""
	Local cNomePar02:= ""
	Local oBtn01	:= NIL
	Local oBtn02	:= NIL
	Local cBcos		:= ""	

	cMvPar01	:= AllTrim(SuperGetMv('MGF_DIRGER' , NIL , ""))

	cMvPar02	:= AllTrim(SuperGetMv('MGF_DIRENV' , NIL , ""))

	cBcos		:= Upper(AllTrim(SuperGetMv('MGF_FILBCO' , NIL , "")))

	cNomePar01	:= 'MGF_DIRGER'

	cNomePar02	:= 'MGF_DIRENV'

	lContinua	:= U_fVldMvPar(cMvPar01 , cMvPar02 , @aDir01 , @aDir02 , .T. , cNomePar01 , cNomePar02) //MGFINT18.PRW
	// Verifica se algum dos parametros nao esta preenchido OU se o parametro esta preenchido e as respectivas pastas nao foram criadas

	If ( lContinua )

		nLen	:= Len(aDir01)

		For nX := 1 TO nLen

			If ( (Empty(cBcos)) .OR. (Upper(aDir01[nX,1]) $ cBcos) .OR. (cBcos $ Upper(aDir01[nX,1]) ) )

				AADD(aBrowse , {.F. , aDir01[nX,1]})

			EndIf

		Next nX

		If ( Len(aBrowse) == 0 )

			MsgAlert('Não foram localizados arquivos para selecionar')

		Else

			DEFINE DIALOG oDlg TITLE "Selecione o arquivo para envio ao  banco." FROM 180,180 TO 550,700 PIXEL

				oBrowse := TWBrowse():New( 01 , 01, 260,164,,{'','Nome do Arquivo'},{20,30,30},;
				oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )

				oBrowse:SetArray(aBrowse)

				oBrowse:bLine := {||{If(aBrowse[oBrowse:nAt,01],oOK,oNO),aBrowse[oBrowse:nAt,02] } }

				// Troca a imagem no duplo click do mouse
				oBrowse:bLDblClick := {|| aBrowse[oBrowse:nAt][1] := !aBrowse[oBrowse:nAt][1],;
				oBrowse:DrawSelect()}

				oBtn01	:= TButton():New( 170,004,'Confirma a Seleção', oDlg,{|| lContinua := .T. , oDlg:End() }  ,60, 011,,,.F.,.T.,.F.,,.F.,,,.F. )
				oBtn02	:= TButton():New( 170,070,'Cancela', oDlg,{|| lContinua := .F. , oDlg:end() }  ,60, 011,,,.F.,.T.,.F.,,.F.,,,.F. )

			ACTIVATE DIALOG oDlg CENTERED

			If ( lContinua )

				For nX := 1 TO Len(aBrowse)
					//Grava em 'aSelected' somente os arquivos selecionados.

					If (aBrowse[nX , 1])

						AADD(aSelected , aBrowse[nX , 2])

					EndIf

				Next nX

				lContinua	:= ( Len(aSelected) > 0 )

				If ( lContinua )

					nLen	:= Len(aSelected)

					For nX := 1 TO nLen

						U_fCopia(cMvPar01 , cMvPar02 , aSelected[nX]) //MGFINT18.PRW

					Next nX

				EndIf

			EndIf

		EndIf

	EndIf

Return
