#INCLUDE "protheus.ch"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOPCONN.CH"

/*
============================================================================================================================
Programa.:              FA070TIT
Autor....:              Tarcisio Galeano
Data.....:              03/2018
Descricao / Objetivo:   bloquear condição de pagamento pedido de vendas
Doc. Origem:            Faturamento
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              validação do campo C5_CONDPAG
============================================================================================================================
*/
user function MGFFAT84()

LOCAL C_COND := M->C5_CONDPAG
Local C_TPCOND := GetAdvFVal("SE4","E4_ZTP",xFilial("SE4")+C_COND,1,"")
Local lret := .T.
Local ccond := ""

// rotina de importacao de ordem de embarque
If (IsInCallStack("GravarCarga") .or. IsInCallStack("U_GravarCarga") .or. IsInCallStack("INCPEDEXP") .or. IsInCallStack("U_INCPEDEXP"))
	Return(lRet)
Endif	
// rotina de exclusao de nota de saida, desfaz fis45
If (IsInCallStack("MATA521") .or. IsInCallStack("MATA521A") .or. IsInCallStack("MATA521B"))
	Return(lRet)
Endif	

If M->C5_TIPO == "N" // solicitado inclusao pelo TI Marfrig em 03/10/18
	IF !C_TPCOND $ '23' .and. !IsBlind()
   		MSGALERT("CONDIÇÃO DE PAGAMENTO INVALIDA PARA VENDAS ")
	    LRET := .F.
	ENDIF
Endif	

return(LRET)

