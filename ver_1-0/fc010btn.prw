#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FONT.CH"   
#INCLUDE "RWMAKE.CH"
/*
=====================================================================================
Programa.:              FC010BTN - PE
Autor....:              Antonio Carlos        
Data.....:              06/10/2016
Descricao / Objetivo:   selecionar somentes titulos vencidos 
Doc. Origem:            Contrato - GAP MGFCRE007
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Criar botão Fc010Brow titulos em aberto selecionar somentes vencidos
=====================================================================================
*/
User Function FC010BTN()

	Local xRet := ""

	If findfunction("u_MGFFI52A")
		xRet := u_MGFFI52A(Paramixb)
	ENDIF
   
Return xRet