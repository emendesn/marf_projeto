#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"

#define CRLF chr(13) + chr(10)
//---------------------------------------------------------------------
/*/{Protheus.doc} MGFFAT33

Associa campos do Pedido de Venda ao Contrato gatilhando pela sequencia  

@author Gustavo Ananias Afonso - TOTVS Campinas
@since 21/03/2017
/*/
//---------------------------------------------------------------------
user function MGFFAT33(cCpo, xDefault)
	local aArea 	:= getArea()
	local aAreaSC5	:= SC5->(getArea())
	local aAreaSC6	:= SC6->(getArea())
	local xRet		:= xDefault

	getCN9()
	
	QRYCN9->(dbGoTop())
	
	if !QRYCN9->(EOF())
	     if cCpo = "C5_ZMDCTR" 
		     xRet := QRYCN9->CN9_NUMERO
		 elseif cCpo = "C5_ZREVIS"
		     xRet := QRYCN9->CN9_REVISA
		 elseif cCpo = "C5_ZMDPLAN" 
		     xRet := QRYCN9->CNA_NUMERO
		 elseif cCpo = "C5_ZDESC"    
		     xRet := QRYCN9->CN9_ZTOTDE
         endif
	endif

	QRYCN9->( DBCloseArea() )

	restArea(aAreaSC6)
	restArea(aAreaSC5)
	restArea(aArea)
return xRet

//-------------------------------------------------------------------
//-------------------------------------------------------------------
static function getCN9()

	local cQryCN9 := ""
	Local _xcFil	 := Alltrim(GetMV('MGF_CT09FI',.F.,"010001"))	

	cQryCN9 := "SELECT CN9.CN9_FILIAL,CN9.CN9_NUMERO CN9_NUMERO,CN9.CN9_REVISA CN9_REVISA,CN9.CN9_CONDPG,CNA.CNA_NUMERO CNA_NUMERO," + CRLF
	cQryCN9 += " CNA.CNA_CLIENT,CNA.CNA_LOJACL, CN9_ZTOTDE" + CRLF
	cQryCN9 += " FROM " + retSQLName("CN9") + " CN9" + CRLF
	cQryCN9 += " LEFT JOIN " + retSQLName("CNA") + " CNA" + CRLF
	cQryCN9 += " ON" + CRLF
	cQryCN9 += "	CNA.CNA_FILIAL = '" + _xcFil + "'	AND" + CRLF
	cQryCN9 += " 	CNA.CNA_CONTRA = CN9.CN9_NUMERO				AND" + CRLF
	cQryCN9 += "	CNA.CNA_REVISA = CN9.CN9_REVISA				AND" + CRLF
	cQryCN9 += "	CNA.D_E_L_E_T_ <> '*'" + CRLF
	cQryCN9 += " WHERE" + CRLF
	cQryCN9 += " 	CN9.CN9_FILIAL = '" + _xcFil	+ "'	AND" + CRLF
	cQryCN9 += " 	CN9.CN9_CONDPG = '" + M->C5_CONDPAG		+ "'	AND" + CRLF
	cQryCN9 += " 	CNA.CNA_CLIENT = '" + M->C5_CLIENTE		+ "'	AND" + CRLF
	cQryCN9 += " 	CNA.CNA_LOJACL = '" + M->C5_LOJACLI		+ "'	AND" + CRLF
	cQryCN9 += " 	CN9.CN9_SITUAC = '05' " 				+ "		AND" + CRLF
	cQryCN9 += "    CN9.CN9_ZTOTDE > 0 	AND " + CRLF
	cQryCN9 += " 	CN9.D_E_L_E_T_ <> '*'"

	memoWrite( "C:\TEMP\mgffat33.sql", cQryCN9 )
	TcQuery cQryCN9 New Alias "QRYCN9"

	
return
	