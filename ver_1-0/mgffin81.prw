#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

/*
=====================================================================================
Programa............: MGFFIN81
Autor...............: Totvs
Data................: Fev/2018
Descricao / Objetivo: Financeiro
Doc. Origem.........: Financeiro
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Rotina para incrementar campo do SE2
=====================================================================================
*/
User Function MGFFIN81()

//Return(Eval({|| x:= Soma1(GetMv("MGF_NPORTA",,"0000000000")),PutMv("MGF_NPORTA",x),x}))

Local aMatriz := {"01","010001"}
Local lIsBlind :=  IsBlind() .OR. Type("__LocalDriver") == "U"

if lIsBlind
	RpcSetType(3)
	RpcSetEnv(aMatriz[1],aMatriz[2])
	
	If !LockByName(ProcName())
		Conout("JOB já em Execução : "+ProcName()+ DTOC(dDATABASE) + " - " + TIME() )
		RpcClearEnv()
		Return()
	EndIf
	
	conOut("********************************************************************************************************************")
	conOut('Inicio do processamento - MGFFIN81 - Campo sequencial SE2 - ' + DTOC(dDATABASE) + " - " + TIME()  )
	conOut("********************************************************************************************************************"+ CRLF)
	MGFFIN81Proc()
	conOut("********************************************************************************************************************")
	conOut('Final do processamento - MGFFIN81 - Campo sequencial SE2 - ' + DTOC(dDATABASE) + " - " + TIME()  )
	conOut("********************************************************************************************************************"+ CRLF)
	
	UnLockByName(ProcName())

	RpcClearEnv()	

EndIf

Return()


Static Function MGFFIN81Proc()

Local aArea := {GetArea()}
Local cAliasTrb := GetNextAlias()
Local cQ := ""
Local cNum := ""
Local nRet := 0

cQ := "SELECT SE2.R_E_C_N_O_ SE2_RECNO "
cQ += "FROM "+RetSqlName("SE2")+" SE2 "
cQ += "WHERE SE2.D_E_L_E_T_ = ' ' "
cQ += "AND E2_ZNPORTA = ' ' "
cQ += "ORDER BY E2_FILIAL,E2_EMISSAO "

cQ := ChangeQuery(cQ)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),cAliasTrb,.T.,.T.)

While (cAliasTrb)->(!Eof())
	cNum := Soma1(GetMv("MGF_NPORTA",,"0000000000"))
	PutMv("MGF_NPORTA",cNum)
	cQ := "UPDATE "
	cQ += RetSqlName("SE2")+" "
	cQ += "SET E2_ZNPORTA = '"+cNum+"' "
	cQ += "WHERE R_E_C_N_O_ = '"+Alltrim(Str((cAliasTrb)->SE2_RECNO))+"' "
	
	nRet := tcSqlExec(cQ)
	If nRet == 0
		If "ORACLE" $ tcGetDB()
			tcSqlExec( "COMMIT" )
		EndIf
	Else
		ConOut("Problemas na gravação do campo E2_ZNPORTA.")
	EndIf
	
	(cAliasTrb)->(dbSkip())
Enddo	
	
(cAliasTrb)->(dbCloseArea())

aEval(aArea,{|x| RestArea(x)})

Return()