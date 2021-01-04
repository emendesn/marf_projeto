#include "protheus.ch"

/*
=====================================================================================
Programa............: MGFFIS18
Autor...............: Mauricio Gresele
Data................: Agosto/2017 
Descricao / Objetivo: Fiscal
Doc. Origem.........: 
Solicitante.........: Cliente
Uso.................: 
Obs.................: Cadastro de amarracao de tipo de operacao X especie da nota de entrada
=====================================================================================
*/
User Function MGFFIS18()

Local cVldAlt := "AllwaysTrue()" // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := "AllwaysTrue()" // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "ZBT"

dbSelectArea(cString)
dbSetOrder(1)

AxCadastro(cString,"Cadastro de Amarracao Tipo de Operacao X Especie NFE",cVldExc,cVldAlt)

Return()


// rotina chamada pelo PE MT100TOK
User Function Fis18NFE()

Local lRet := .T.
Local nCnt := 0

/*
// comentado em 13/06/18 a pedido da Marcia, pois foi habilitado o parametro padrao MV_VCHVNFE, o qual faz esta validacao
// valida se numero da nota eh igual ao da chave
If !Empty(M->F1_CHVNFE)
	If cNFiscal != Subs(M->F1_CHVNFE,26,09) //da posicao 26 a 34 eh o numero da nota na Chave Nfe
		lRet := .F.
		APMsgStop("Numero da NFE nao confere com a Chave.")
	Endif
Endif
*/

If lRet
	ZBT->(dbSetOrder(1))
	For nCnt:=1 To Len(aCols)
		If !gdDeleted(nCnt) .and. !Empty(gdFieldGet("D1_OPER",nCnt))
			If ZBT->(!dbSeek(xFilial("ZBT")+gdFieldGet("D1_OPER",nCnt)+cEspecie))
				lRet := .F.
				APMsgStop("Nao existe amarracao do Tipo de Operacao X Especie NFE cadastrada para esta operacao."+CRLF+;
				"Faca o cadastro desta amarracao para incluir este Documento de Entrada.")
				Exit
			Endif	
		Endif
	Next
Endif			
      
Return(lRet)