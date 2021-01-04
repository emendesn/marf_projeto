#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'
#include "protheus.ch"

// tratativa para calcular componente de KM para o segundo trecho
//GFEXFB_1AREA(lTabTemp,cTRBTRE, @aTRBTRE1) //dbSelectArea(cTRBTRE)


User Function GFEXFB02()

	Local nValComp 	  	:=  ParamIxb[1]
	Local nKMOrdemsep 	:= 0
	Local cOrdemSep   	:= ""
	Local nKMGWUEnt	  	:= 0
	Local nPesoPesoNota := 0
	Local nPesoTotal 	:= 0
	Local nPerc			:= 0
	Public x_ChaveGWU

	IF GV2->GV2_ATRCAL = '6'
		conout('Alterando valor de ' + CvalToChar(nValComp) )

		DbSelectArea('GWU')
		DbSetOrder(1)//GWU_FILIAL+GWU_CDTPDC+GWU_EMISDC+GWU_SERDC+GWU_NRDC+GWU_SEQ
		IF GWU->(MsSeek( XfILIAL('GW1') + GW1->GW1_CDTPDC + GW1->GW1_EMISDC + GW1->GW1_SERDC + GW1->GW1_NRDC + '02'))

			IF !EMPTY(GWU->GWU_ZORDEM) .OR. 0
				cOrdemSep := GWU->GWU_ZORDEM
				nKMOrdemsep := KMOrdemsep()
				//nKMOrdemsep := KMOrdemspent()
				nValComp := nKMOrdemsep
			ENDIF	
		ENDIF
		
	ENDIF	
		
Return nValComp
		


////Km da ordem de separação
Static Function KMOrdemsep()

	Local nKM 		:= 0
	Local cAliasGWU := ""
	Local cQuery 	:= ""
	Local cOrdemSep := GWU->GWU_ZORDEM

	DbSelectArea('GW1')
	DbSetOrder(1)//GW1_FILIAL+GW1_CDTPDC+GW1_EMISDC+GW1_SERDC+GW1_NRDC
	GW1->(MsSeek(GWU->GWU_FILIAL + GWU->GWU_CDTPDC + GWU->GWU_EMISDC + GWU->GWU_SERDC + GWU->GWU_NRDC))

	cAliasGWU := GetNextAlias()	

	cQuery := " SELECT SUM(GWU_ZKM2TR) KM " + CRLF
	cQuery += " FROM " + RetSqlName("GW1")+ " GW1 " + " ," + RetSqlName("GWU")+ " GWU " + CRLF  
	cQuery += " WHERE GW1_NRROM = '" + GW1->GW1_NRROM + "' " + CRLF
	cQuery += " AND GW1_FILIAL = '" + xFilial('GW1') + "'" + CRLF
	cQuery += " AND GWU_FILIAL = '" + xFilial('GWU') + "'" + CRLF
	cQuery += " AND GWU_ZORDEM = '" + cOrdemSep + "'" + CRLF
	cQuery += " AND GW1_NRDC = GWU_NRDC " + CRLF
	cQuery += " AND GW1_SERDC = GWU_SERDC " + CRLF
	cQuery += " AND GWU_SEQ = '02' " + CRLF
	cQuery += " AND GW1.D_E_L_E_T_<>'*' " + CRLF
	cQuery += " AND GWU.D_E_L_E_T_<>'*' " + CRLF 

	cQuery := ChangeQuery(cQuery)

	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasGWU, .F., .T.)

	If (cAliasGWU)->(!eof())
		nKM := (cAliasGWU)->KM 
	EndIf

Return nKM


////Km por entrega da ordem de separação
Static Function KMOrdemspent()

	Local nKM 		 := 0
	Local cAliasGWUE := ""
	Local cQuery 	 := ""
	Local cOrdemSep  := GWU->GWU_ZORDEM

	DbSelectArea('GW1')
	DbSetOrder(1)//GW1_FILIAL+GW1_CDTPDC+GW1_EMISDC+GW1_SERDC+GW1_NRDC
	GW1->(MsSeek(GWU->GWU_FILIAL + GWU->GWU_CDTPDC + GWU->GWU_EMISDC + GWU->GWU_SERDC + GWU->GWU_NRDC))

	cAliasGWUE := GetNextAlias()	

	cQuery := " SELECT SUM(GWU_ZKM2TR) KM " + CRLF
	cQuery += " FROM " + RetSqlName("GW1")+ " GW1 " + " ," + RetSqlName("GWU")+ " GWU " + CRLF  
	cQuery += " WHERE GW1_NRROM = '" + GW1->GW1_NRROM + "' " + CRLF
	cQuery += " AND GW1_FILIAL = '" + xFilial('GW1') + "'" + CRLF
	cQuery += " AND GWU_FILIAL = '" + xFilial('GWU') + "'" + CRLF
	cQuery += " AND GWU_ZORDEM = '" + cOrdemSep + "'" + CRLF
	cQuery += " AND GW1_EMISDC = GWU_EMISDC " + CRLF
	cQuery += " AND GW1_NRDC = GWU_NRDC " + CRLF
	cQuery += " AND GW1_SERDC = GWU_SERDC " + CRLF
	cQuery += " AND GWU_SEQ = '02' " + CRLF
	cQuery += " AND GW1_CDDEST = '" + GW1->GW1_CDDEST + "' " + CRLF
	cQuery += " AND GW1.D_E_L_E_T_<>'*' " + CRLF
	cQuery += " AND GWU.D_E_L_E_T_<>'*' " + CRLF 

	cQuery := ChangeQuery(cQuery)

	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasGWUE, .F., .T.)

	If (cAliasGWUE)->(!eof())
		nKM := (cAliasGWUE)->KM 
	EndIf

Return nKM


*/