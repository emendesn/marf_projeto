#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"

#define CRLF chr(13) + chr(10)
//-------------------------------------------------------------------
/*/{Protheus.doc} MGFFAT31

Gatilho nos campos acrescenta o campo preço final customizado a porcentagem do desconto

@author Gustavo Ananias Afonso - TOTVS Campinas
@since 20/03/2017
/*/
//-------------------------------------------------------------------
user function MGFFAT31()
	local nRet			:= 0
	local nPosPrcUnt	:= aScan(aHeader, {|x| alltrim(x[2]) == "C6_PRUNIT"		})
	local nPosPrcVen	:= aScan(aHeader, {|x| alltrim(x[2]) == "C6_PRCVEN"		})

	if !isInCallStack("U_MGFFAT53") .or. !isInCallStack("U_runFAT53") .or. !isInCallStack("U_runFATA5")
		if !empty(M->C5_ZDESC)
			nRet := aCols[n, nPosPrcUnt] + (M->C5_ZDESC / 100 * aCols[n, nPosPrcUnt])
		endif
	elseif isInCallStack("U_MGFFAT53") .or. isInCallStack("U_runFAT53") .or. isInCallStack("U_runFATA5")
		nRet := aCols[ n, nPosPrcVen ]
	endif

return nRet
