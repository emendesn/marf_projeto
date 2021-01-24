#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)
/*/
=============================================================================
{Protheus.doc} MGFFINBQ
@description
@author TOTVS
@since 27/05/2020
@type Function
@table
@param
@return
 Sem retorno
@menu
 Sem menu
/*/
user function MGFFINBQ()
	local cUpdSA1	:= ""
	local lFilPes	:= superGetMv( "MGFWSC34D" , , .T.) //Filtro para filtrar pessoa Juridica
	local getAreaX	:= getArea()

	cUpdSA1 := "UPDATE " + retSQLName("SA1")							+ CRLF
	cUpdSA1 += "	SET"												+ CRLF
	cUpdSA1 += "		A1_XINTSFO = 'P' "								+ CRLF
	cUpdSA1 += " WHERE"													+ CRLF
	cUpdSA1 += " R_E_C_N_O_"											+ CRLF
	cUpdSA1 += " IN"													+ CRLF
	cUpdSA1 += " ("														+ CRLF
	cUpdSA1 += " SELECT SA1.R_E_C_N_O_"									+ CRLF
	cUpdSA1 += " FROM		CN9010 CN9"									+ CRLF
	cUpdSA1 += " INNER JOIN	CNC010 CNC"									+ CRLF
	cUpdSA1 += " ON"													+ CRLF
	cUpdSA1 += " 		CNC.CNC_REVISA	=	CN9.CN9_REVISA"				+ CRLF
	cUpdSA1 += " 	AND CNC.CNC_NUMERO	=	CN9.CN9_NUMERO"				+ CRLF
	cUpdSA1 += " 	AND	CNC.CNC_FILIAL	=	'" + CNC->CNC_FILIAL + "'"	+ CRLF
	cUpdSA1 += " 	AND	CNC.D_E_L_E_T_	=	' '"						+ CRLF
	cUpdSA1 += " INNER JOIN	SA1010 SA1"									+ CRLF
	cUpdSA1 += " ON"													+ CRLF
	cUpdSA1 += " 		SA1.A1_LOJA		=	CNC.CNC_LOJACL"				+ CRLF
	cUpdSA1 += " 	AND SA1.A1_COD		=	CNC.CNC_CLIENT"				+ CRLF
	cUpdSA1 += " 	AND	SA1.A1_FILIAL	=	'" + xFilial("SA1") + "'"	+ CRLF
	cUpdSA1 += " 	AND	SA1.D_E_L_E_T_	=	' '"						+ CRLF

	if lFilPes
		cUpdSA1 += "	AND	A1_PESSOA = 'J'"							+ CRLF
	endif

	cUpdSA1 += " WHERE"													+ CRLF
	cUpdSA1 += " 		CN9.CN9_ESPCTR	=	'2'"						+ CRLF
	cUpdSA1 += " 	AND	CN9.CN9_REVISA	=	'" + CN9->CN9_REVISA + "'"	+ CRLF
	cUpdSA1 += " 	AND CN9.CN9_NUMERO	=	'" + CN9->CN9_NUMERO + "'"	+ CRLF
	cUpdSA1 += " 	AND	CN9.CN9_FILIAL	=	'" + CN9->CN9_FILIAL + "'"	+ CRLF
	cUpdSA1 += " 	AND	CN9.D_E_L_E_T_	=	' '"						+ CRLF
	cUpdSA1 += " )"														+ CRLF

	if tcSQLExec( cUpdSA1 ) < 0
		conout( "Não foi possível executar UPDATE." + CRLF + tcSqlError() )
	endif

/*
	CN9_NUMERO+CN9_REVISA	=	CNC_NUMERO+CNC_REVISA
	A1_COD+A1_LOJA			=	CNC_CLIENT+CNC_LOJACL
*/

	restArea( getAreaX )
return
