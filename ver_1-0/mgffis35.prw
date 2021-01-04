#include "protheus.ch"

/*
=====================================================================================
Programa............: MGFFIS35
Autor...............: Natanael Filho
Data................: Abril/2018 
Descricao / Objetivo: Fiscal
Doc. Origem.........: 
Solicitante.........: Cliente
Uso.................: 
Obs.................: Inclusao manual da data de entrada da Nota Fiscal eletronica para operacoes de Busca de Gado - GAP133
=====================================================================================
*/
User Function MGFFIS35()

Local oDlg                 
Local cTit := OemToAnsi("Data de Entrada do Gado")
Local oBut1
Local oBut2
Local nOpcA := 0
Local lWhen := .F.
Local dDtEnt := dDataBase
Local cTE    := SuperGetMV("MGF_FIS35T",.T.,"") //Tipos de entrada para operacao de busca de Boi
Local nPosTE := aScan(aHeader,{|x| x[2] = "D1_TES"}) //Posicao da TES no aCols
Public nQtdDias := SuperGetMV('MGF_FIS35D',.T.,3)

If empty(aCols[1,nPosTE])
	Help( ,, 'MGFFIS35_01',, '� necessario informar ao menos um Tipo de Entrada (TES)', 1, 0)
	Return
ElseIf !aCols[1,nPosTE]$cTE
	Help( ,, 'MGFFIS35_02',, 'Funcao nao habilidata para o Tipo de Entrada(TES): ' + aCols[1,nPosTE] + '. (MGF_FIS35T)', 1, 0)
	Return
ElseIf !SF1->(FieldPos("F1_ZDTBUSC"))>0
	Help( ,, 'MGFFIS35_03',, 'O Campo F1_ZDTBUSC nao existe na base de dados.', 1, 0)
	Return	
EndIf

//Verifica se j� foi informada a data de busca anteriormente para trazer para o formulario.
If !Empty(SF1->F1_ZDTBUSC)
	dDtEnt := SF1->F1_ZDTBUSC
EndIf

If IsInCallStack("MATA103")
	lWhen := .T.
	/*If (IIf(Type("l103Class")!="U",l103Class,.F.)) // Verifica se esta classificando a Nota Fiscal
		lWhen := .T.
	Endif*/
Endif
	
DEFINE MSDIALOG oDlg TITLE cTit FROM 200,001 TO 300,350 OF oMainWnd PIXEL

@ 10,05	SAY OemToAnsi("Data de Entrada:") OF oDlg SIZE 50,10 PIXEL
@ 10,60 MSGET dDtEnt WHEN lWhen Valid  ValidDate(dDtEnt)  SIZE 60,10 PIXEL

DEFINE SBUTTON oBut1 FROM 30,50 TYPE 1 ACTION IIf(!Empty(dDtEnt),(nOpcA := 1,oDlg:End()),.F.) ENABLE OF oDlg
DEFINE SBUTTON oBut2 FROM 30,100 TYPE 2 ACTION (oDlg:End()) ENABLE OF oDlg

ACTIVATE MSDIALOG oDlg CENTERED

If nOpcA == 1
	If IsInCallStack("MATA103")
			SF1->(RecLock("SF1",.F.))
			SF1->F1_ZDTBUSC := dDtEnt
			SF1->(MsUnLock())
	Endif	
Endif	

Return


//-----------------------------------------------------------------------------------
//Validacao da data inserida
//-----------------------------------------------------------------------------------
Static Function ValidDate(dDate)
Local lRet := .F.

If dDate>=ddemissao .AND. dDate<=(ddemissao+nQtdDias)
lRet := .T.
Else
Help( ,, 'MGFFIS35_04',, 'Informa uma data maior que a data de emissao ou ate ' + Alltrim(Str(nQtdDias)) + ' dias apos a mesma.', 1, 0)
EndIf

Return lRet