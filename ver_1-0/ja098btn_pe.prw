#include "protheus.ch"
#include 'parmtype.ch'

/*                                       
=====================================================================================
Programa.:              JA098BTN_PE
Autor....:              Marcelo Carneiro
Data.....:              27/03/2019
Descricao / Objetivo:   Integra��o Grade de Aprova��o SigaJuri
Doc. Origem:            MIT044
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              PE para criar os bot�es em garantia  - Garantia
=====================================================================================
*/
User Function JA098BTN()

	Local _aArea 	:= GetArea()
	Local aRotina 	:= {}    
			
	If findfunction("U_MGFJUR03")
		aAdd(aRotina,{ "Aprovar"  ,"u_MGFJUR03(1,'NT2')", 0 , 2, 0, .F.})
		aAdd(aRotina,{ "Reprovar" ,"u_MGFJUR03(2,'NT2')", 0 , 2, 0, .F.})
		aAdd(aRotina,{ "Historico","u_MGFJUR03(3,'NT2')", 0 , 6, 0, .F.})
	EndIf

	RestArea(_aArea)

Return aRotina