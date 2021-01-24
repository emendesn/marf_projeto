#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"

#define CRLF chr(13) + chr(10)
/*
=====================================================================================
Programa.:              MGFCRM34
Autor....:              Gustavo Ananias Afonso - TOTVS Campinas
Data.....:              18/04/2017
Descricao / Objetivo:   RAMI - No Pedido aberto para refaturamento valida se a RAMI foi preenchida
Chamado pelo PE MT410TOK
Doc. Origem:            GAP CRM
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
user function MGFCRM34()
	local lRet  := .T.
	Local nI    := 0
	local cRAMI := ""
	
	If FunName() == "EECFATCP" // cModulo == "EEC"
		Return .T.
	EndIf
	
	if ALTERA .or. INCLUI
		if M->C5_ZREFATU == "S" 
		
			cRAMI := M->C5_ZRAMI1 + ;	
			M->C5_ZRAMI2 + ;
			M->C5_ZRAMI3 + ;
			M->C5_ZRAMI4 + ;
			M->C5_ZRAMI5 + ;
			M->C5_ZRAMI6 + ;
			M->C5_ZRAMI7 + ;
			M->C5_ZRAMI8 + ;
			M->C5_ZRAMI9 + ;
			M->C5_ZRAMI10 + ;
			M->C5_ZRAMI11 + ;
			M->C5_ZRAMI12 + ;
			M->C5_ZRAMI13 + ;
			M->C5_ZRAMI14 + ;				 
			M->C5_ZRAMI15 + ;
			M->C5_ZRAMI16 + ;
			M->C5_ZRAMI17 + ;
			M->C5_ZRAMI18 + ;
			M->C5_ZRAMI19 + ;
			M->C5_ZRAMI20 + ;
			M->C5_ZRAMI21 + ;
			M->C5_ZRAMI22 + ;
			M->C5_ZRAMI23 + ;
			M->C5_ZRAMI24 + ;
			M->C5_ZRAMI25 
			
			If empty(cRAMI)
				msgAlert("Existem itens no pedido de Refaturamento sem RAMI vinculada!")
				lRet := .F.
			Endif
		
	/*		For nI := 1 to Len(aCols)
				
				If Empty(ACOLS[n][144])
				
					msgAlert("Existem itens no pedido de Refaturamento sem RAMI vinculada!")
				
				EndIf
			
			Next*/
		
		EndIf
	Endif	
	
	/*if ALTERA .or. INCLUI
		if M->C5_ZREFATU == "S"
			if empty(M->C5_ZRAMI)
				msgAlert("É obrigatório informar a RAMI para Refaturamento.")
				lRet := .F.
			endif
		endif
	endif
	*/
	/*
	if ALTERA
		if !empty(SC5->C5_ZREFATU)
			if empty(SC5->C5_ZRAMI)
				msgAlert("É obrigatório informar a RAMI para Refaturamento.")
				lRet := .F.
			endif
		endif
	elseif INCLUI
		if !empty(M->C5_ZREFATU)
			if empty(M->C5_ZRAMI)
				msgAlert("É obrigatório informar a RAMI para Refaturamento.")
				lRet := .F.
			endif
		endif
	endif
	*/
return lRet
