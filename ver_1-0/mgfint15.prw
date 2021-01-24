#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'TBICONN.CH'

/*
=====================================================================================
Programa.:              MGFINT15
Autor....:              Luis Artuso
Data.....:              08/09/2016
Descricao / Objetivo:   Execução do P.E. F090REST para salvar os arquivos processados na rotina de baixa automática.
Doc. Origem:            Contrato - GAP MGFINT03
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
User Function MGFINT15()

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

	cMvPar01	:= AllTrim(SuperGetMv('MGF_DIRRET' , NIL , ""))

	cMvPar02	:= AllTrim(SuperGetMv('MGF_RETBKP' , NIL , ""))

	cNomePar01	:= "MGF_DIRRET"

	cNomePar02	:= "MGF_RETBKP"

	lContinua	:= U_fVldMvPar(cMvPar01 , cMvPar02 , @aDir01 , @aDir02 , .T. , cNomePar01 , cNomePar02) //MGFINT18.PRW

	If ( (lContinua) .AND. (Len(aDir01) > 0) )

		nLen	:= Len(aDir01)

		For nX := 1 TO nLen

			U_fCopia(cMvPar01 , cMvPar02 , aDir01[nX , 1]) //MGFINT18.PRW

		Next nX

	EndIf

Return
