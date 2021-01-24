#include "protheus.ch"

/*
=====================================================================================
Programa............: MGFGFE25
Autor...............: Totvs
Data................: Julho/2018 
Descricao / Objetivo: Rotina chamada via funcao inserida no SX3
Doc. Origem.........: Compras
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Gravacao de campos do GFE
=====================================================================================
*/
User Function MGFGFE25(cCampo,oModel)
// funcao inserida no X3_RELACAO / X3_INIBRW dos campos: GWN_ZVLFRE / GWN_ZVLCAR / GWN_ZPECAR / GW1_ZPESBR / GW1_ZPESLI

Local aArea := {GW1->(GetArea()),GW8->(GetArea()),GWF->(GetArea()),GWI->(GetArea()),GetArea()}
Local cQ := ""
Local cAliasGW1 := GetNextAlias()
Local cAliasGW8 := GetNextAlias()
Local cAliasGWF := GetNextAlias()
Local cAliasGWI := GetNextAlias()
Local nValorCarga := 0
Local nPesoBCarga := 0
Local nPesoLCarga := 0
Local nValorFrete := 0
Local nRet := 0
Local lGW1 := .F.

Default cCampo := ""

If "GW1" $ cCampo
//If IsInCallStack("GFEA044") // rotina de documento de carga
//If cCampo $ "GW1_ZPESBR/GW1_ZPESLI"
	lGW1 := .T.
Endif	

If !lGW1
	// seleciona todas gw1 com mesmo romaneio - cabeçalho nf
	cQ := "SELECT R_E_C_N_O_ GW1_RECNO "
	cQ += "FROM "+RetSqlName("GW1")+" GW1 "
	cQ += "WHERE GW1_FILIAL = '"+GWN->GWN_FILIAL+"' "
	cQ += "AND GW1_NRROM = '"+GWN->GWN_NRROM+"' "
	cQ += "AND GW1.D_E_L_E_T_ = ' ' "
						
	cQ := ChangeQuery(cQ)
						
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQ),cAliasGW1, .F., .T.)
Endif
	
While IIf(!lGW1,(cAliasGW1)->(!Eof()),lGW1)
	IIf(!lGW1,GW1->(dbGoto((cAliasGW1)->GW1_RECNO)),Nil)
	If IIf(!lGW1,GW1->(Recno()) == (cAliasGW1)->GW1_RECNO,.T.)
		// soma valor e peso da gw8
		cQ := "SELECT SUM(GW8_VALOR) GW8_VALOR, SUM(GW8_PESOR) GW8_PESOR, SUM(GW8_QTDALT) GW8_QTDALT "
		cQ += "FROM "+RetSqlName("GW8")+" GW8 "
		cQ += "WHERE GW8_FILIAL = '"+GW1->GW1_FILIAL+"' "
		cQ += "AND GW8_CDTPDC = '"+GW1->GW1_CDTPDC+"' "
		cQ += "AND GW8_EMISDC = '"+GW1->GW1_EMISDC+"' "		
		cQ += "AND GW8_SERDC = '"+GW1->GW1_SERDC+"' "		
		cQ += "AND GW8_NRDC = '"+GW1->GW1_NRDC+"' "		
		cQ += "AND GW8.D_E_L_E_T_ = ' ' "
							
		cQ := ChangeQuery(cQ)
							
		dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQ),cAliasGW8, .F., .T.)
		
		tcSetField(cAliasGW8,"GW8_VALOR","N",TamSX3("GW8_VALOR")[1],TamSX3("GW8_VALOR")[2])
		tcSetField(cAliasGW8,"GW8_PESOR","N",TamSX3("GW8_PESOR")[1],TamSX3("GW8_PESOR")[2])
		tcSetField(cAliasGW8,"GW8_QTDALT","N",TamSX3("GW8_QTDALT")[1],TamSX3("GW8_QTDALT")[2])		

		While (cAliasGW8)->(!Eof())
			nValorCarga += (cAliasGW8)->GW8_VALOR
			nPesoBCarga += (cAliasGW8)->GW8_PESOR // peso bruto
			nPesoLCarga += (cAliasGW8)->GW8_QTDALT // peso liquido
			(cAliasGW8)->(dbSkip())
		Enddo	
		
		(cAliasGW8)->(dbCloseArea())
	Endif	
	If !lGW1
		(cAliasGW1)->(dbSkip())
	Else
		Exit	
	Endif	
Enddo	

If !lGW1
	(cAliasGW1)->(dbCloseArea())
Endif	

If !lGW1
	// seleciona todas gwf com mesmo romaneio
	cQ := "SELECT R_E_C_N_O_ GWF_RECNO "
	cQ += "FROM "+RetSqlName("GWF")+" GWF "
	cQ += "WHERE GWF_FILIAL = '"+GWN->GWN_FILIAL+"' "
	cQ += "AND GWF_NRROM = '"+GWN->GWN_NRROM+"' "
	cQ += "AND GWF.D_E_L_E_T_ = ' ' "
						
	cQ := ChangeQuery(cQ)
						
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQ),cAliasGWF, .F., .T.)
	
	While (cAliasGWF)->(!Eof())
		GWF->(dbGoto((cAliasGWF)->GWF_RECNO))
		If GWF->(Recno()) == (cAliasGWF)->GWF_RECNO
			// soma valor do frete
			cQ := "SELECT SUM(GWI_VLFRET) GWI_VLFRET "
			cQ += "FROM "+RetSqlName("GWI")+" GWI "
			cQ += "WHERE GWI_FILIAL = '"+GWF->GWF_FILIAL+"' "
			cQ += "AND GWI_NRCALC = '"+GWF->GWF_NRCALC+"' "
			cQ += "AND GWI.D_E_L_E_T_ = ' ' "
								
			cQ := ChangeQuery(cQ)
								
			dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQ),cAliasGWI, .F., .T.)
			
			tcSetField(cAliasGWI,"GWI_VLFRET","N",TamSX3("GWI_VLFRET")[1],TamSX3("GWI_VLFRET")[2])
	
			While (cAliasGWI)->(!Eof())
				nValorFrete += (cAliasGWI)->GWI_VLFRET
				(cAliasGWI)->(dbSkip())
			Enddo	
			
			(cAliasGWI)->(dbCloseArea())
		Endif	
		(cAliasGWF)->(dbSkip())
	Enddo	
	
	(cAliasGWF)->(dbCloseArea())
Endif
	
If cCampo == "GWN_ZVLFRE"
	nRet := nValorFrete
Endif	
	
If cCampo == "GWN_ZVLCAR"
	nRet := nValorCarga
Endif	
	
If cCampo == "GWN_ZPECAR"
	nRet := nPesoBCarga
Endif	

If cCampo == "GW1_ZPESBR"
	nRet := nPesoBCarga
Endif	

If cCampo == "GW1_ZPESLI"
	nRet := nPesoLCarga
Endif	
	
//If ValType(oModel) != "U"
	//oModel:SetValue("GWN_ZVLFRE",nValorFrete)
	//oModel:SetValue("GWN_ZVLCAR",nValorCarga)
	//oModel:SetValue("GWN_ZPECAR",nPesoBCarga)	
//Endif	
			
aEval(aArea,{|x| RestArea(x)})	
		
Return(nRet)