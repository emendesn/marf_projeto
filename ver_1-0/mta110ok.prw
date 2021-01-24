#Include 'Protheus.ch'
#INCLUDE 'FIVEWIN.CH'

/*
=====================================================================================
Programa............: MTA110OK
Autor...............: Joni Lima
Data................: 06/01/2016
Descri��o / Objetivo: Ap�s a montagem da dialog da Solicita��o de compras. � acionado quando o usuario clica nos bot�es OK (Ctrl O) ou CANCELAR (Ctrl X) na inclus�o de uma SC, deve ser utilizado para validar se a SC deve ser inclu�da  'retorno .T.' ou n�o 'retorno .F.' , ap�s a confirma��o do sistema.
Doc. Origem.........: GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: http://tdn.totvs.com/pages/releaseview.action?pageId=6085567
Manuten��o..........: Juscelino - 26/11/2018 - Verifica��o se e uma opera��o de INCLUS�O
                      e Desliga a Tecla < F4 >
=====================================================================================
*/
User Function MTA110OK()


	Local cNumSc := PARAMIXB[1] // NUMERO DA SOLICITA��O 
	Local cNomSC := PARAMIXB[2] // NOME DO SOLICITANTE 
	Local dDtSc	 := PARAMIXB[3] // DATA DA SOLICITA��O
	Local lRet	 := .F.
	
	If FindFunction("U_MC8110OK")
		lRet := U_MC8110OK(cNumSc)
	EndIf
	
	If INCLUI .And. lRet
     Set Key VK_F4 to
    EndIf   
	

Return lRet