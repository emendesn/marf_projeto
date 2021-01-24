#include "protheus.ch"

/*
=====================================================================================
Programa............: MGFTAC07
Autor...............: Mauricio Gresele
Data................: 06/12/2016 
Descricao / Objetivo: Integração Protheus-Taura, para cadastro de Modelos de Veiculo
Doc. Origem.........: Protheus-Taura Cadastros
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/
User Function MGFTAC07()

Local cVldAlt := "AllwaysTrue()" // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := "U_TAC07ECad()" // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "ZZX"

dbSelectArea(cString)
dbSetOrder(1)

AxCadastro(cString,"Cadastro de Modelos de Veículos",cVldExc,cVldAlt)

Return()


// valida exclusao
User Function TAC07ECad()

Local aArea := {GetArea()}
Local cAliasTrb := GetNextAlias()
Local cQ := "" 
Local lRet := .T.

cQ := "SELECT DA3_COD "
cQ += "FROM "+RetSqlName("DA3")+ " DA3 "
//cQ += "WHERE DA3_FILIAL = '"+xFilial("DA3")+"' "
cQ += "WHERE DA3_ZCMODE = '"+ZZX->ZZX_CODIGO+"' "
cQ += "AND DA3.D_E_L_E_T_ = ' ' "
	
cQ := ChangeQuery(cQ)
dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQ),cAliasTrb,.F.,.T.)

While (cAliasTrb)->(!Eof())
	lRet := .F.
	APMsgStop("Modelo de Veículo não poderá ser excluído, utilizada no Veículo: "+(cAliasTrb)->DA3_COD)
	Exit
Enddo	
	 
(cAliasTrb)->(dbCloseArea())	

aEval(aArea,{|x| RestArea(x)})

Return(lRet)