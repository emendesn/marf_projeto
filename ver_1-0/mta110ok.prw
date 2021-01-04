#Include 'Protheus.ch'
#INCLUDE 'FIVEWIN.CH'

/*
=====================================================================================
Programa............: MTA110OK
Autor...............: Joni Lima
Data................: 06/01/2016
Descrição / Objetivo: Após a montagem da dialog da Solicitação de compras. É acionado quando o usuario clica nos botões OK (Ctrl O) ou CANCELAR (Ctrl X) na inclusão de uma SC, deve ser utilizado para validar se a SC deve ser incluída  'retorno .T.' ou não 'retorno .F.' , após a confirmação do sistema.
Doc. Origem.........: GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: http://tdn.totvs.com/pages/releaseview.action?pageId=6085567
Manutenção..........: Juscelino - 26/11/2018 - Verificação se e uma operação de INCLUSÃO
                      e Desliga a Tecla < F4 >
=====================================================================================
*/
User Function MTA110OK()


	Local cNumSc := PARAMIXB[1] // NUMERO DA SOLICITAÇÃO 
	Local cNomSC := PARAMIXB[2] // NOME DO SOLICITANTE 
	Local dDtSc	 := PARAMIXB[3] // DATA DA SOLICITAÇÃO
	Local lRet	 := .F.
	
	If FindFunction("U_MC8110OK")
		lRet := U_MC8110OK(cNumSc)
	EndIf
	
	If INCLUI .And. lRet
     Set Key VK_F4 to
    EndIf   
	

Return lRet