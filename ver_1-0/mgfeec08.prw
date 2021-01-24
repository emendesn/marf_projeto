#Include 'Protheus.ch'
#INCLUDE "FWMVCDEF.CH"

/*
=====================================================================================
Programa.:              MGFEEC08
Autor....:              Luis Artuso
Data.....:              01/11/16
Descricao / Objetivo:   Execucao do P.E. EAE100MNU
Doc. Origem:            Contrato - GAP EEC10
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:				Rotina chamadora: MGFEEC07.PRW
=====================================================================================
*/

User Function fAddBTN(aRet)

	AADD(aRet , { "LOG DE ALTERA��ES" , "U_MGFEEC05" , 0 , 1} )

Return aRet