#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

/*
=====================================================================================
Programa............: MGFGFE32
Autor...............: Totvs
Data................: Agosto/2018
Descricao / Objetivo: Rotina para gravar campos especificos nas tabelas de carga e GFE
=====================================================================================
*/
User Function MGFGFE32()

Local aMatriz := {"01","010001"}
Local lIsBlind := IsBlind() .OR. Type("__LocalDriver") == "U"
Local lSemaf := .T.

	
lSemaf := GetMv("MGF_GFE325",,.T.)
If lSemaf
	If !LockByName(ProcName())
		Conout("JOB já em Execução : "+ProcName()+" - "+DTOC(dDATABASE) + " - " + TIME() )
		Return()
	EndIf
Endif	
	
conOut("********************************************************************************************************************")
conOut('Inicio do processamento - MGFGFE32 - Gravação campos GFE - ' + DTOC(dDATABASE) + " - " + TIME()  )
conOut("********************************************************************************************************************"+ CRLF)
MGFGFE32Proc()
conOut("********************************************************************************************************************")
conOut('Final do processamento - MGFGFE32 - Gravação campos GFE - ' + DTOC(dDATABASE) + " - " + TIME()  )
conOut("********************************************************************************************************************"+ CRLF)
	
If lSemaf
	UnLockByName(ProcName())
Endif	

Return()


Static Function MGFGFE32Proc()

Local aArea 		:= {GetArea()}
Local cAliasTrb 	:= GetNextAlias()
Local cQ 			:= ""
Local cTimeIni 		:= ""
Local cTimeFim 		:= Time()
Local cTimeProc 	:= ""
Local cDelay 		:= GetMv("MGF_GFE321",,"00:30:00")
Local nQtdDiasRetro := GetMv("MGF_GFE322",,2)
Local nQtdTot 		:= 0
Local nQtdCalc 		:= 0
Local cCalc 		:= GetMv("MGF_GFE323",,"1")
Local cTpOpeNao 	:=  GetMv("MGF_GFE324",,"999,S/FRETE")
Local aMat 			:= {}
Local nCnt 			:= 0

cQ := "SELECT DAK.R_E_C_N_O_ DAK_RECNO "
cQ += "FROM "+RetSqlName("DAK")+" DAK, "+RetSqlName("GW1")+" GW1, "+RetSqlName("GWN")+" GWN "
cQ += "WHERE DAK.D_E_L_E_T_ = ' ' "
cQ += "AND GW1.D_E_L_E_T_ = ' ' "
cQ += "AND GWN.D_E_L_E_T_ = ' ' "
cQ += "AND DAK_DATA >= '"+dTos(dDataBase-nQtdDiasRetro)+"' "  
cQ += "AND DAK_DATA <= '"+dTos(dDataBase)+"' "
cQ += "AND DAK_FILIAL = GW1_FILIAL "
cQ += "AND DAK_COD || DAK_SEQCAR = TRIM(GW1_NRROM) "
cQ += "AND GW1_CDTPDC = 'NFS' "
cQ += "AND DAK_FILIAL = GWN_FILIAL "
cQ += "AND GW1_NRROM = GWN_NRROM "
cQ += "AND GWN_CALC NOT IN "+FormatIn(cCalc,",")+" " 		// ('1','4') " // calculado / necessita recalculo
cQ += "AND GWN_CDTPOP NOT IN "+FormatIn(cTpOpeNao,",")+" " 	//	('999','S/FRETE','N/A') "
cQ += "AND DAK_ZCDTPO = ' ' " 
cQ += "GROUP BY DAK.R_E_C_N_O_ "
cQ += "ORDER BY DAK.R_E_C_N_O_ "

cQ := ChangeQuery(cQ)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),cAliasTrb,.T.,.T.)

While (cAliasTrb)->(!Eof())
	/*
	gera um numero qualquer para depois indexar o array por este numero, a fim de processar 
	os calculos de frete por este numero e garantir que o job pegue romaneios diferentes 
	para execucoes simultaneas, evitando problemas de lock em tabelas do gfe.
	*/
	aAdd(aMat,{(cAliasTrb)->DAK_RECNO,Randomize(1,999999)}) 
	(cAliasTrb)->(dbSkip())
Enddo	
(cAliasTrb)->(dbCloseArea())

aSort(aMat,,,{|x,y| x[2]<y[2]}) // indexa pelo numero randomizado

For nCnt:=1 To Len(aMat)
	DAK->(dbGoto(aMat[nCnt][1]))
	If DAK->(Recno()) == aMat[nCnt][1]
		cTimeIni := DAK->DAK_HORA
		cTimeProc := ElapTime(cTimeIni,cTimeFim)
		cEmpAnt := Subs(DAK->DAK_FILIAL,1,2)
		cFilAnt := DAK->DAK_FILIAL
		ConOut("MGFGFE32 - Encontrando Còdigo Regra para Carga: "+DAK->DAK_FILIAL+"/"+DAK->DAK_COD+DAK->DAK_SEQCAR+" - Data Carga: "+dToc(DAK->DAK_DATA)+" - Hora Carga: "+DAK->DAK_HORA)
		nQtdTot++
		If U_MGFOMS01()
			nQtdCalc++
		Endif
	Endif	
Next

ConOut("MGFGFE32 - Total de Romaneios avaliados: "+Alltrim(Str(nQtdTot))+" - "+dToc(dDataBase)+" - "+Time())
ConOut("MGFGFE32 - Total de Romaneios com retorno .T. para cálculo do Frete: "+Alltrim(Str(nQtdCalc))+" - "+dToc(dDataBase)+" - "+Time())

aEval(aArea,{|x| RestArea(x)})

Return()
