#include "protheus.ch"

/*
=====================================================================================
Programa............: MGFFAT50
Autor...............: Mauricio Gresele
Data................: Set/2017
Descricao / Objetivo: Rotina chamada pelo ponto de entrada SF2520E
Doc. Origem.........: Protheus
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/
User Function MGFFAT50()

// prepara variaveis para uso no fonte MGFFAT49
// isto eh necessario, pois no MGFFAT49 a nota de saida jah estah excluida e eh necessario carregar o campo F2_CARGA
If Type("__cCarga") == "U"
	Public __cCarga := ""
Else
	__cCarga := ""
Endif		

If Type("__aPVCarga") == "U"
 	Public __aPVCarga := {}
Else
 	__aPVCarga := {}
Endif		

__cCarga := SF2->F2_CARGA 

If !Empty(__cCarga)
	__aPVCarga := StaticCall(MGFTAS02,RecnoSC9,__cCarga,.F.,.T.,SF2->F2_SERIE,SF2->F2_DOC,.T.)[4]
Endif	

Return()