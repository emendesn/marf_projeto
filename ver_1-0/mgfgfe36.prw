#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

/*
=====================================================================================
Programa............: MGFGFE36
Autor...............: Totvs
Data................: Nov/2018
Descricao / Objetivo: Rotina chamada pela MGFGFE24, para gravar regra de operacao e frete do romaneio
=====================================================================================
*/
User Function MGFGFE36(cFil,cCarga)

Local aMatriz := {"01","010001"}
Local lIsBlind := IsBlind() .OR. Type("__LocalDriver") == "U"

if lIsBlind
	RpcSetType(3)
	RpcSetEnv(aMatriz[1],aMatriz[2])
	
	conOut("********************************************************************************************************************")
	conOut('Inicio do processamento - MGFGFE36 - Gravação campos GFE - ' + DTOC(dDATABASE) + " - " + TIME()  )
	conOut("********************************************************************************************************************"+ CRLF)
	MGFGFE36Proc(cFil,cCarga)
	conOut("********************************************************************************************************************")
	conOut('Final do processamento - MGFGFE36 - Gravação campos GFE - ' + DTOC(dDATABASE) + " - " + TIME()  )
	conOut("********************************************************************************************************************"+ CRLF)
	
	RpcClearEnv()	

EndIf

Return()


Static Function MGFGFE36Proc(cFil,cCarga)

Local nQtdCalc := 0

cFilAnt := cFil
cEmpAnt := Subs(cFilAnt,1,2)
DAK->(dbSetOrder(1))
If DAK->(dbSeek(xFilial("DAK")+cCarga))
	ConOut("MGFGFE36 - Encontrando Codigo Regra para Carga: "+DAK->DAK_FILIAL+"/"+DAK->DAK_COD+DAK->DAK_SEQCAR+" - Data Carga: "+dToc(DAK->DAK_DATA)+" - Hora Carga: "+DAK->DAK_HORA)
	If U_MGFOMS01()
		nQtdCalc++
	Endif
Endif
ConOut("MGFGFE36 - Total de Romaneios com retorno .T. para cálculo do Frete: "+Alltrim(Str(nQtdCalc))+" - "+dToc(dDataBase)+" - "+Time())
	
Return()