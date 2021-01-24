#Include "Protheus.ch"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "APWEBEX.CH"
#INCLUDE "RWMAKE.CH"
#include "tbiconn.ch"
#include "topconn.ch"
#INCLUDE "ap5Mail.ch"
#INCLUDE "FILEIO.CH"

#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "apwebsrv.ch"
#include "apwebex.ch"
/*
==========================================================================================
Programa.:              EECAP100
Autor....:              Leonardo Kume
Data.....:              Nov/2016
Descricao / Objetivo:   Ponto de entrada geral para Pedido de Exportação
Pedido Exportacao
Doc. Origem:            EEC03
Solicitante:            Clientet
Uso......:              Marfrig
==========================================================================================

*/


User Function EECAP100()
	local cParam := If(Type("ParamIxb") = "A",ParamIxb[1],If(Type("ParamIxb") = "C",ParamIxb,""))
	Local lRet := .T.

	//Função para atualizar o campo no momento do cancelamento
	if cParam == 'CANCELA'
		if FindFunction("U_MGFEEC79")
			U_MGFEEC79()
		endif
	endif
	if Alltrim(cParam) == 'GETPESOS' //Não exibir tela de coferência de peso, qdo for execauto. Totvs mão está tratando.
		If (IsInCallStack("U_MGFINT72") .Or. IsInCallStack("U_MONINT72") ) .and. GetNewPar('MGF_INT72X' , .T.)
			Break
		EndIf
	EndIf 
	//Atualização de datas Follow Up
	if findfunction("U_MGFDT15")
		u_MGFDT15()
	Endif

	// validar alteracao/exclusao do pedido de exportacao
	If FindFunction("U_MGFEEC56") // 13/07/18 SERA HABILITADO APOS VALIDACAO DA MARFRIG
		lRet := U_MGFEEC56()
		If !lRet
			BREAK // forcado break, pois ponto de entrada nao espera retorno e preciso interromper o processamento da exclusao do pedido
		Endif
	Endif
	IF findfunction("U_MGFTAS05")

		lRet := u_MGFTAS05(3) // Não permitir alteração.
		If !lRet
			BREAK // forcado break, pois ponto de entrada nao espera retorno e preciso interromper o processamento da alteracao do pedido
		Endif
	Endif

	IF findfunction("U_xM24CAN")

		u_xM24CAN() // Cancelamento de EXP

	Endif

	//Gravação de campos de frete e seguro para empresa 90
	If FindFunction("U_MGFEEC41")
		u_MGFEEC41()
	EndIf


	// Limpar campos usados no GAP FIS45 durante a copia do pedido e setar variavel public para uso no PE EECPEM44
	If FindFunction("U_MGFEEC53") // 13/07/18 SERA HABILITADO APOS VALIDACAO DA MARFRIG
		U_MGFEEC53()
	Endif
	//Programa para validar copia de pedido de exportação
	IF FindFunction("U_MGFEEC57")
		lRet := u_MGFEEC57()

		If !lRet
			BREAK // forcado break, pois ponto de entrada nao espera retorno e preciso interromper o processamento da alteracao do pedido
		Endif
	EndIf

	// Validar linha ok do pedido de exportacao
	If FindFunction("U_MGFEEC78")
		lRet := U_MGFEEC78()
		If !lRet
			BREAK
		Endif
	Endif

Return lRet