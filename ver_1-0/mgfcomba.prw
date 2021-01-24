#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE "TOPCONN.CH"

/*
=====================================================================================
Programa............:  MGFTCOMBA
Autor...............:  Marcos Vieira         
Data................:  07/08/2019 
Descricao / Objetivo:  Validação de regra de tolerância na entrada da NF.
Solicitante.........:  Cliente
Uso.................:  Marfrig
Obs.................:  Ponto de entrada no final da função e deve ser utilizado para 
					   regras especificas de bloqueio pertencentes ao usuario onde será 
					   controlada pelo retorno do ponto de entrada o qual se for .F. o 
					   documento não será bloqueao e se .T. será bloqueado.
============================================================================================
*/

User Function MGFCOMBA()
Local _lRet     := PARAMIXB[1]    
Local _lDescTol	:= SuperGetMV("MV_DESCTOL",.F.,.F.)
Local _nVlOrig  := 0
Local _VlrItem	:= 0

If _lRet	// Se esta Bloqueado.                         
    IF SC7->C7_MOEDA <> 1 .AND. SC7->C7_TXMOEDA > 0
		_nVlOrig  := SC7->C7_PRECO * SC7->C7_TXMOEDA  
		If _lDescTol
			If SD1->D1_QUANT > 0
				_nVlrItem := (SD1->D1_VUNIT - (SD1->D1_VALDESC/SD1->D1_QUANT))
			Else
				_nVlrItem := (SD1->D1_VUNIT - SD1->D1_VALDESC)
			EndIf
		Else
			_nVlrItem := SD1->D1_VUNIT
		EndIf

		If _nVlOrig = _nVlrItem
			_lRet := .F. 	
		EndIF 
    EndIF
EndIF

Return _lRet
