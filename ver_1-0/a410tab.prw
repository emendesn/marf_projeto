#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)                     

user function A410TAB()
	local nPrecoX	:= 0
	local bError 	:= ErrorBlock( { |oError| errorFat74( oError ) } )

	if findFunction("U_MGFFAT74")
		BEGIN SEQUENCE
			nPrecoX := U_MGFFAT74(PARAMIXB[1],PARAMIXB[2],PARAMIXB[3],PARAMIXB[4],PARAMIXB[5],PARAMIXB[6],PARAMIXB[7],PARAMIXB[8],PARAMIXB[9])
			//memoWrite( "\SFA_MGFFAT74_X_" + fwTimeStamp(1) + ".log", PARAMIXB[1] + " - " + PARAMIXB[2] + allTrim( str( nPrecoX ) ) )
		RECOVER
			Conout('[MGFFAT74] [EMPRESA] ' + allTrim(cEmpAnt) + ' [FILIAL] ' + allTrim(cFilAnt) + ' Problema Ocorreu em : ' + dToC(dDataBase) + " - " + time() )
		END SEQUENCE
	endif

return nPrecoX

//-------------------------------------------------------
//-------------------------------------------------------
static function errorFat74(oError)
	local nQtd	:= MLCount(oError:ERRORSTACK)
	local nI	:= 0
	local cEr	:= ''

	for nI:=1 to nQtd
		cEr += memoLine(oError:ERRORSTACK, , nI)
	next nI

	// fwTimeStamp(1) -> aaaammddhhmmss

	//memoWrite("\SFA_MGFFAT74_" + fwTimeStamp(1) + ".log", cEr)

	_aErr := { '0', cEr }
return .T.