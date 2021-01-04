#include "protheus.ch"

/*
=====================================================================================
Programa............: MGFTAC03
Autor...............: Mauricio Gresele
Data................: 06/12/2016 
Descricao / Objetivo: Integração Protheus-Taura, para cadastro de Marcas de Produtos
Doc. Origem.........: Protheus-Taura Cadastros
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/
User Function MGFTAC03()

Local cVldAlt := "AllwaysTrue()" // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := "U_TAC03ECad()" // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "ZZS"

dbSelectArea(cString)
dbSetOrder(1)

AxCadastro(cString,"Cadastro de Marcas de Produtos",cVldExc,cVldAlt)

Return()


// valida exclusao
User Function TAC03ECad()

Local aArea := {GetArea()}
Local cAliasTrb := GetNextAlias()
Local cQ := "" 
Local lRet := .T.

cQ := "SELECT B1_COD "
cQ += "FROM "+RetSqlName("SB1")+ " SB1 "
//cQ += "WHERE B1_FILIAL = '"+xFilial("SZW")+"' "
cQ += "WHERE B1_ZCMARCA = '"+ZZS->ZZS_CODIGO+"' "
cQ += "AND SB1.D_E_L_E_T_ = ' ' "
	
cQ := ChangeQuery(cQ)
dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQ),cAliasTrb,.F.,.T.)

While (cAliasTrb)->(!Eof())
	lRet := .F.
	APMsgStop("Marca não poderá ser excluída, utilizada no Produto: "+(cAliasTrb)->B1_COD)
	Exit
Enddo	
	 
(cAliasTrb)->(dbCloseArea())	

aEval(aArea,{|x| RestArea(x)})

Return(lRet)