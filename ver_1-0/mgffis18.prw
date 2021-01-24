#include "protheus.ch"

/*
=====================================================================================
Programa............: MGFFIS18
Autor...............: Mauricio Gresele
Data................: Agosto/2017 
Descricao / Objetivo: Fiscal
Doc. Origem.........: Marfrig
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Cadastro de amarracao de tipo de operacao X especie da nota de entrada
=====================================================================================
*/
User Function MGFFIS18()

Local cVldAlt := "AllwaysTrue()" // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := "AllwaysTrue()" // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "ZBT"

dbSelectArea(cString)
dbSetOrder(1)

AxCadastro(cString,"Cadastro de Amarração Tipo de Operação X Espécie NFE",cVldExc,cVldAlt)

Return()


// rotina chamada pelo PE MT100TOK
User Function Fis18NFE()

Local lRet := .T.
Local nCnt := 0

/*
// comentado em 13/06/18 a pedido da Marcia, pois foi habilitado o parametro padrao MV_VCHVNFE, o qual faz esta validacao
// valida se numero da nota eh igual ao da chave
If !Empty(M->F1_CHVNFE)
	If cNFiscal != Subs(M->F1_CHVNFE,26,09) //da posição 26 a 34 eh o numero da nota na Chave Nfe
		lRet := .F.
		APMsgStop("Número da NFE não confere com a Chave.")
	Endif
Endif
*/

If lRet
	ZBT->(dbSetOrder(1))
	For nCnt:=1 To Len(aCols)
		If !gdDeleted(nCnt) .and. !Empty(gdFieldGet("D1_OPER",nCnt))
			If ZBT->(!dbSeek(xFilial("ZBT")+gdFieldGet("D1_OPER",nCnt)+cEspecie))
				lRet := .F.
				APMsgStop("Não existe amarração do Tipo de Operação X Espécie NFE cadastrada para esta operação."+CRLF+;
				"Faça o cadastro desta amarração para incluir este Documento de Entrada.")
				Exit
			Endif	
		Endif
	Next
Endif			
      
Return(lRet)