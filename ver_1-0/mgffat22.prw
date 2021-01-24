#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              MGFFAT22
Autor....:              Gustavo Ananias Afonso
Data.....:              25/10/2016
Descricao / Objetivo:   
Doc. Origem:            GAP MGFINT06
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
=====================================================================================
*/
user function MGFFAT22()
    
	Local cTipos  := SuperGetMv( "MGFWSC81E" , , "NF/JR/RA")  

	if chkSFA()
		if SE1->E1_XSFA == "S"
			recLock("SE1", .F.)
				SE1->E1_XINTEGR := "P"
			SE1->(msUnLock())
		endif
	endif
   
    //Integração com Salesforce
    //Verificar se o tipo do título está na regra de integração.
    if ALLTRIM(SE1->E1_TIPO) $ cTipos
       If vldCli() //Validar Cliente
			recLock("SE1", .F.)
				SE1->E1_XINTSFO := "P"
			SE1->(msUnLock())
	   endif
	endif
return

//---------------------------------------------------------
// Verifica se e um pedido de SFA
//---------------------------------------------------------
static function chkSFA()
	local cQryZC5	:= ""
	local lRetSFA	:= .F.

	cQryZC5 := "SELECT ZC5_IDSFA"											+ CRLF
	cQryZC5 += " FROM " + retSQLName("SE1") + " SE1"						+ CRLF
	cQryZC5 += " INNER JOIN " + retSQLName("SF2") + " SF2"					+ CRLF
	cQryZC5 += " ON"														+ CRLF
	cQryZC5 += "         SE1.E1_LOJA     =   SF2.F2_LOJA"					+ CRLF
	cQryZC5 += "     AND SE1.E1_CLIENTE  =   SF2.F2_CLIENTE"				+ CRLF
	cQryZC5 += "     AND SE1.E1_PREFIXO  =   SF2.F2_SERIE"					+ CRLF
	cQryZC5 += "     AND SE1.E1_NUM      =   SF2.F2_DOC"					+ CRLF
	cQryZC5 += "     AND SF2.F2_FILIAL   =   '" + xFilial("SF2") + "'"		+ CRLF
	cQryZC5 += "     AND SF2.D_E_L_E_T_ <>   '*'"							+ CRLF
	cQryZC5 += " INNER JOIN " + retSQLName("SC5") + " SC5"					+ CRLF
	cQryZC5 += " ON"														+ CRLF
	cQryZC5 += "         SC5.C5_LOJACLI  =   SF2.F2_LOJA"					+ CRLF
	cQryZC5 += "     AND SC5.C5_CLIENTE  =   SF2.F2_CLIENTE"				+ CRLF
	cQryZC5 += "     AND SC5.C5_SERIE    =   SF2.F2_SERIE"					+ CRLF
	cQryZC5 += "     AND SC5.C5_NOTA     =   SF2.F2_DOC"					+ CRLF
	cQryZC5 += "     AND SC5.C5_FILIAL   =   '" + xFilial("SC5") + "'"		+ CRLF
	cQryZC5 += "     AND SC5.D_E_L_E_T_ <>   '*'"							+ CRLF
	cQryZC5 += " INNER JOIN " + retSQLName("ZC5") + " ZC5"					+ CRLF
	cQryZC5 += " ON"														+ CRLF
	cQryZC5 += "         SC5.C5_NUM      =   ZC5.ZC5_PVPROT"				+ CRLF
	cQryZC5 += "     AND ZC5.ZC5_FILIAL  =   '" + xFilial("ZC5") + "'"		+ CRLF
	cQryZC5 += "     AND ZC5.D_E_L_E_T_  <>  '*'"							+ CRLF
	cQryZC5 += " WHERE"														+ CRLF
	cQryZC5 += "		E1_TIPO			=	'" + SE1->E1_TIPO		+ "'"	+ CRLF
	cQryZC5 += "	AND E1_PARCELA		=	'" + SE1->E1_PARCELA	+ "'"	+ CRLF
	cQryZC5 += "	AND E1_NUM			=	'" + SE1->E1_NUM		+ "'"	+ CRLF
	cQryZC5 += "	AND E1_PREFIXO		=	'" + SE1->E1_PREFIXO	+ "'"	+ CRLF
	cQryZC5 += "	AND SE1.E1_FILIAL	=	'" + xFilial("SE1")		+ "'"	+ CRLF
	cQryZC5 += "	AND SE1.D_E_L_E_T_	<>	'*'"							+ CRLF
	cQryZC5 += "	AND ROWNUM			=	1"								+ CRLF

	tcQuery changeQuery(cQryZC5) New Alias "QRYSZ5"

	if !QRYSZ5->(EOF())
		lRetSFA := .T.
	endif

	QRYSZ5->(DBCloseArea())

return lRetSFA


/*/
==============================================================================================================================================================================
{Protheus.doc} vldCli()
Valida se é um cliente é válido p/ integrar o seu título com Salesforce
@type function
@author Rogerio Almeida
@since 21/01/2020
@version P12
/*/
static function  vldCli()
Local cQrySA1  := ""
Local lRetSA1  := .F.
Local lFilPes := superGetMv( "MGFWSC34D" , , .T.) //Filtro para filtrar pessoa Juridica

cQrySA1 := "SELECT A1_COD "			 									+ CRLF
cQrySA1 += " FROM " + retSQLName("SA1") + " SA1"						+ CRLF
cQrySA1 += " WHERE"														+ CRLF
cQrySA1 += "	SA1.D_E_L_E_T_ <> '*' "							     	+ CRLF
cQrySA1 += "	AND SA1.A1_COD	   =	'"+ SE1->E1_CLIENTE + "'"       + CRLF
cQrySA1 += "	AND SA1.A1_LOJA	   =	'"+ SE1->E1_LOJA + "'"			+ CRLF
if lFilPes
	cQrySA1 += "	AND SA1.A1_PESSOA = 'J' "						    + CRLF
endIf
cQrySA1 += "	AND SA1.A1_EST <> 'EX' "						     	+ CRLF
cQrySA1 += "    AND SA1.A1_XIDSFOR  <> ' ' "						    + CRLF
cQrySA1 += "	AND SA1.A1_FILIAL	=	'" + xFilial("SA1")		+ "'"	+ CRLF

tcQuery changeQuery(cQrySA1) New Alias "QRYSA1"

if !QRYSA1->(EOF())
	lRetSA1 := .T.
endif

QRYSA1->(DBCloseArea())

return lRetSA1