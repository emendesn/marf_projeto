#include "protheus.ch"
#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa............: MGFFIS37
Autor...............: Natanael Filho
Data................: 16/JULHO/2018 
Descricao / Objetivo: Fiscal
Doc. Origem.........: Marfrig
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: GAP 370 / Bloquear acesso do usu�rio a s�rie de entrada em uma nota de sa�da e vice versa
=====================================================================================
*/
User Function MGFFIS37()

Local aRotEnt := Separa(Alltrim(SuperGetMV("MGF_FIS37A",.T.,"MATA103,MATA140")),",",.F.) //Rotinas de documentos de entrada (Separadas por v�rgula).
Local aRotSai := Separa(Alltrim(SuperGetMV("MGF_FIS37B",.T.,"MATA460A,MATA460B,MATA410,MATA920")),",",.F.) //Rotinas de documentos de sa�da (Separadas por v�rgula).
Local aRotExc := Separa(Alltrim(SuperGetMV("MGF_FIS37C",.T.," ")),",",.F.) //Rotinas que devem ficar de fora do filtro MGFFIS37 (Separadas por v�rgula).
Local aSerEnt := Separa(Alltrim(SuperGetMV("MGF_FIS37D",.T.,"100,101")),",",.F.) //S�ries de Entrada (Separadas por v�rgula).
Local aSerSai := Separa(Alltrim(SuperGetMV("MGF_FIS37E",.T.,"200")),",",.F.) //S�ries de Sa�da (Separadas por v�rgula).


//Verifica se a Rotina est� no par�metro de exce��es e j� retorna TRUE
If Len(aRotExc) > 0
	For nCnt := 1 To Len(aRotExc)
		If IsInCallStack(Alltrim(aRotExc[nCnt]))
			Return .T.
		EndIf
	Next
EndIf

//Verifica se a Rotina � de sa�da.
If Len(aRotSai) > 0
	For nCnt := 1 To Len(aRotSai)
		If IsInCallStack(Alltrim(aRotSai[nCnt]))
			//Verifica se a serie � de sa�da.
			If Len(aSerSai) > 0
				For nCnt2 := 1 to Len(aSerSai)
					If Alltrim(aSerSai[nCnt2]) == Alltrim(SX5->X5_CHAVE)
						Return .T.
					EndIf
				Next.
			Else
				Return .F.
			EndIf
		EndIf
	Next
EndIf


//Verifica se a Rotina � de Entrada.
If Len(aRotEnt) > 0
	For nCnt := 1 To Len(aRotEnt)
		If IsInCallStack(Alltrim(aRotEnt[nCnt]))
			//Verifica se a serie � de sa�da.
			If Len(aSerSai) > 0
				For nCnt2 := 1 to Len(aSerEnt)
					If Alltrim(aSerEnt[nCnt2]) == Alltrim(SX5->X5_CHAVE)
						Return .T.
					EndIf
				Next.
			Else
				Return .F.
			EndIf
		EndIf
	Next
EndIf


Return .F.