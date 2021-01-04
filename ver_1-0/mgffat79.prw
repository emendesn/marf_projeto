#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwmvcdef.ch"

/*
	Verifica se o item digitado na Tabela de Preo já foi incluido
	Não permite duplicados
*/
user function MGFFAT79()
	local nI			:= 0
	local lRet			:= .T.
	local oModel		:= fwModelActive()
	local oModelDA1		:= oModel:GetModel('DA1DETAIL')
	local nOper			:= oModel:getOperation()
	local aSaveLines	:= FWSaveRows()

	if nOper == MODEL_OPERATION_INSERT .or. nOper == MODEL_OPERATION_UPDATE
		for nI := 1 to oModelDA1:length()
			if nI <> oModelDA1:nLine
				if oModelDA1:getValue("DA1_CODPRO", nI) == M->DA1_CODPRO
					msgAlert("Item já inserido. Não é permitido itens duplicados.")
					lRet := .F.
					exit
				endif
			endif
		next
	endif

	FWRestRows( aSaveLines )
return lRet