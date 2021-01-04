#include "protheus.ch"
#include 'parmtype.ch'

/*                                       
=====================================================================================
Programa.:              JA99MDEF_PE
Autor....:              Marcelo Carneiro
Data.....:              27/03/2019
Descricao / Objetivo:   Integracao Grade de Aprovacao SigaJuri
Doc. Origem:            MIT044
Solicitante:            Cliente
Uso......:              
Obs......:              PE para criar os botoes em despesas
=====================================================================================
*/
User Function JA99MDEF()

	Local _aArea 	:= GetArea()
	Local aRotina 	:= {}
			
	IF findfunction("U_MGFJUR03")
		aAdd(aRotina,{ "Aprovar"  ,"u_MGFJUR03(1,'NT3')", 0 , 2, 0, .F.})
		aAdd(aRotina,{ "Reprovar" ,"u_MGFJUR03(2,'NT3')", 0 , 2, 0, .F.})
		aAdd(aRotina,{ "Historico","u_MGFJUR03(3,'NT3')", 0 , 6, 0, .F.})
	EndIf
	
	RestArea(_aArea)
	
Return aRotina