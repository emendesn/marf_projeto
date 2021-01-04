#include "protheus.ch"

/*
=====================================================================================
Programa............: MGFFIS19
Autor...............: Mauricio Gresele
Data................: Agosto/2017 
Descricao / Objetivo: Fiscal
Doc. Origem.........: 
Solicitante.........: Cliente
Uso.................: 
Obs.................: Cadastro de amarracao de tipo de operacao X especie do pedido de venda
=====================================================================================
*/
User Function MGFFIS19()

Local cVldAlt := "AllwaysTrue()" // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := "AllwaysTrue()" // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "ZBU"

dbSelectArea(cString)
dbSetOrder(1)

AxCadastro(cString,"Cadastro de Amarracao Tipo de Operacao X Especie Pedido de Venda",cVldExc,cVldAlt)

Return()


// rotina chamada pelo PE MT410TOK
User Function Fis19PV()

Local lRet := .T.
Local nCnt := 0

ZBU->(dbSetOrder(1))
For nCnt:=1 To Len(aCols)
	If !gdDeleted(nCnt) .and. !Empty(gdFieldGet("C6_OPER",nCnt))
		If ZBU->(!dbSeek(xFilial("ZBU")+gdFieldGet("C6_OPER",nCnt)+M->C5_ZTIPPED))
			lRet := .F.
			APMsgStop("Nao existe amarracao do Tipo de Operacao X Especie PV cadastrada para esta operacao."+CRLF+;
			"Faca o cadastro desta amarracao para incluir este Pedido de Venda.")
			Exit
		Endif	
	Endif
Next
      
Return(lRet)