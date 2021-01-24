#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FONT.CH"   

/*
=====================================================================================
Programa.:              F010CQTA - PE
Autor....:              Antonio Carlos        
Data.....:              03/10/2016
Descricao / Objetivo:   incluir informa��es de T�tulos Abertos Credito da Rede
Doc. Origem:            Contrato - GAP MGFCRE007
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              T�tulos Abertos por Rede
=====================================================================================
*/
User Function F010CQTA()
	LOCAL cQueryori := PARAMIXB[1]

	If findfunction ("U_MGFFIN31")
		cQuery := U_MGFFIN31(cQueryori)
		If Empty(cQuery)
			cQuery := cQueryori
		EndIf                   
	Endif

Return(cQuery)