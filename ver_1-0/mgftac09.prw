#include "protheus.ch"

/*
=====================================================================================
Programa............: MGFTAC09
Autor...............: Mauricio Gresele
Data................: 16/12/2016 
Descricao / Objetivo: Integração Protheus-Taura, para cadastro de Estrutura de Categoria
Doc. Origem.........: Protheus-Taura Cadastros
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/
User Function MGFTAC09()

Local cVldAlt := "AllwaysTrue()" // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := "U_TAC09ECad()" // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "ZA4"

dbSelectArea(cString)
dbSetOrder(1)

AxCadastro(cString,"Cadastro de Estrutura de Categoria",cVldExc,cVldAlt)

Return()


// valida exclusao
User Function TAC09ECad()

Local aArea := {GetArea()}
Local cAliasTrb := GetNextAlias()
Local cQ := "" 
Local lRet := .T.

cQ := "SELECT B1_COD "
cQ += "FROM "+RetSqlName("SB1")+ " SB1 "
//cQ += "WHERE B1_FILIAL = '"+xFilial("SB1")+"' "
cQ += "WHERE B1_ZCCATEG = '"+ZA4->ZA4_CODIGO+"' "
cQ += "AND SB1.D_E_L_E_T_ = ' ' "
	
cQ := ChangeQuery(cQ)
dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQ),cAliasTrb,.F.,.T.)

While (cAliasTrb)->(!Eof())
	lRet := .F.
	APMsgStop("Estrutura de Categoria não poderá ser excluída, utilizada no Produto: "+(cAliasTrb)->B1_COD)
	Exit
Enddo	
	 
(cAliasTrb)->(dbCloseArea())	

aEval(aArea,{|x| RestArea(x)})

Return(lRet)