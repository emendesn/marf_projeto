#INCLUDE "protheus.ch"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOPCONN.CH"

/*
============================================================================================================================
Programa.:              FA070TIT 
Autor....:              Tarcisio Galeano        
Data.....:              03/2018                                                                                                            
Descricao / Objetivo:   Alterar carteira para permitir baixa
Doc. Origem:            Financeiro 
Solicitante:            Cliente
Uso......:              
Obs......:              PE FINA070 --> (TDN) O ponto de entrada FA070TIT sera executado apos a confirmacao da baixa do contas a receber.
============================================================================================================================
*/ 
user function FA070TIT()

LOCAL C_SIT :=SE1->E1_SITUACA  
LOCAL cTipos  := SuperGetMv( "MGFWSC81E" , , "NF/JR/RA") 

IF SE1->E1_SITUACA <> "0"
	SE1->(RecLock("SE1",.F.))
 		SE1->E1_SITUACA  := "0"
        SE1->E1_MOTNEG   := C_SIT
	SE1->(MsUnlock())
ENDIF

//Integracao com Salesforce, baixa
//Verificar se o tipo do titulo esta na regra de Integracao.
if ALLTRIM(SE1->E1_TIPO) $ cTipos
	If vldCli() //Validar Cliente
		recLock("SE1", .F.)
			SE1->E1_XINTSFO := "P"
		SE1->(msUnLock())
	endif
endif

return(.T.)


/*/
==============================================================================================================================================================================
{Protheus.doc} vldCli()
Valida dados do Cliente 
@type function
@author Rogerio Almeida
@since 21/01/2020
@version P12
/*/
static function  vldCli()
Local cQrySA1  := ""
Local lRetSA1  := .F.

cQrySA1 := "SELECT A1_COD "			 									+ CRLF
cQrySA1 += " FROM " + retSQLName("SA1") + " SA1"						+ CRLF
cQrySA1 += " WHERE"														+ CRLF
cQrySA1 += "	SA1.D_E_L_E_T_ <> '*' "							     	+ CRLF
cQrySA1 += "	AND SA1.A1_COD	   =	'"+ SE1->E1_CLIENTE + "'"       + CRLF
cQrySA1 += "	AND SA1.A1_LOJA	   =	'"+ SE1->E1_LOJA + "'"			+ CRLF
cQrySA1 += "	AND SA1.A1_PESSOA = 'J' "						     	+ CRLF
cQrySA1 += "	AND SA1.A1_EST <> 'EX' "						     	+ CRLF
cQrySA1 += "    AND SA1.A1_XIDSFOR  <> ' ' "						    + CRLF
cQrySA1 += "	AND SA1.A1_FILIAL	=	'" + xFilial("SA1")		+ "'"	+ CRLF

tcQuery changeQuery(cQrySA1) New Alias "QRYSA1"

if !QRYSA1->(EOF())
	lRetSA1 := .T.
endif

QRYSA1->(DBCloseArea())

return lRetSA1
