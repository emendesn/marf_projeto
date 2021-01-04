#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"

#define CRLF chr(13) + chr(10)
//---------------------------------------------------------------------
/*/{Protheus.doc} MGFFAT99

@author Tarcisio Galeano 
@since 17/08/2018
/*/
//---------------------------------------------------------------------
user function MGFFAT99()
	local aArea 	:= getArea()
	local aAreaSC5	:= SC5->(getArea())
	local aAreaSC6	:= SC6->(getArea())
	local xRet		:= ""
	local _cPoscli  := "" 
	local cClix     := ""
	local cCond     := ""
	
    //_cPoscli := Ascan(aHeader,{|x| AllTrim(x[2])=="C5_CLIENTE"})  //aCols[n][2]
    //cclix	 := aCols[n][_cPoscli]
                   
    cClix	 := M->C5_CLIENTE
    cCond	 := M->C5_CONDPAG

	getCN9N(cclix)
	
	
	QRYCN9N->(dbGoTop())
	
	if !QRYCN9N->(EOF())
		CCOND := QRYCN9N->CN9_CONDPG 
		xRet := QRYCN9N->CN9_CONDPG
	endif

	QRYCN9N->( DBCloseArea() )

	//msgalert("fez a query "+CCLIX+" "+CCOND)

    If Empty(xRet) .or. xRet == Nil// = " "
       xRet := cCond
    endif
    
	restArea(aAreaSC6)
	restArea(aAreaSC5)
	restArea(aArea)
return xRet

//-------------------------------------------------------------------
//-------------------------------------------------------------------
static function getCN9N(cclix)

	local cQryCN9N := " "
	//Local _xcFil	 := Alltrim(GetMV('MGF_CT09FI',.F.,"010001"))	

	cQryCN9N := "SELECT CN9_FILIAL,CN9_NUMERO,CNC_CLIENT,CNC_LOJACL,CN9_CONDPG,CN9_REVISA "
	cQryCN9N += " FROM " + retSQLName("CN9") + " CN9" 
	cQryCN9N += " LEFT OUTER JOIN " + retSQLName("CNC") + " CNC" 
	cQryCN9N += " ON " 
	cQryCN9N += "	SUBSTR(CNC.CNC_FILIAL,1,2)=SUBSTR(CN9.CN9_FILIAL,1,2)	AND " 
	cQryCN9N += " 	CNC.CNC_NUMERO = CN9.CN9_NUMERO	AND " 
	cQryCN9N += "	CNC.D_E_L_E_T_ <> '*' AND CNC.CNC_REVISA = CN9_REVISA " 
	cQryCN9N += " WHERE " 
	cQryCN9N += " 	CN9.CN9_DTFIM >= '" + dtos(dDatabase)+ "'	AND "
	cQryCN9N += " 	CN9.CN9_SITUAC='05'	AND " 
	cQryCN9N += " 	CN9.CN9_ESPCTR='2' AND CNC.CNC_CLIENT = '"+cclix+"' AND "
	cQryCN9N += " 	CN9.D_E_L_E_T_ <> '*' AND CN9_REVISA = ("
	cQryCN9N += " SELECT MAX(CN9X.CN9_REVISA) "
	cQryCN9N += " FROM " + retSQLName("CN9") + " CN9X" 
	cQryCN9N += " WHERE	CN9X.D_E_L_E_T_ <> '*' AND CN9X.CN9_NUMERO=CN9.CN9_NUMERO "
	cQryCN9N += " AND	CN9X.CN9_FILIAL=CN9.CN9_FILIAL ) "

	//memoWrite( "C:\TEMP\mgffat99.sql", cQryCN9N )
	TcQuery cQryCN9N New Alias "QRYCN9N"

	
return
	