#Include 'Protheus.ch'

/*
=====================================================================================
Programa............: MGFCOM61
Autor...............: Gresele
Data................: Nov/2017
Descrição / Objetivo: Rotina chamada pelo ponto de entrada MTA125MNU
Doc. Origem.........: 
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/
User Function MGFCOM61(aRotina)
	
If FindFunction("U_MGFCOM54")
	aAdd(aRotina,{OemToAnsi("Importa .CSV"),"U_MGFCOM54",0,2,0,nil})
EndIf

If FindFunction("U_MGFCOM58")
	aAdd(aRotina,{OemToAnsi("Contrato x filiais"),"U_MGFCOM58",0,2,0,nil})
EndIf

If FindFunction("U_MGFCOM55")
	aAdd(aRotina,{OemToAnsi("Cópia do Contrato"),"U_MGFCOM55",0,4,0,nil})
EndIf

If FindFunction("U_xCP8110M")
	aAdd(aRotina,{OemToAnsi("Log Aprovacao"),"U_xCP8110M",0,4,0,nil})
EndIf


Return(aRotina)

