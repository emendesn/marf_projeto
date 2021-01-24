#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "VKEY.CH"
#INCLUDE "FONT.CH"
#INCLUDE "FWMVCDEF.CH"

User Function MGFOMS6()

Local cNota    := SF2->F2_DOC
Local cSerie   := SF2->F2_SERIE               
Local cFilfre  := GetMv('MGF_VLFRET') 
local cValfre  := ""
Local cAlias1  := ""
Local cAlias2  := ""
Local cAlias3  := ""
Local nIcms    := 0
Local nAliq	   := 0
Local cRetorno := ""
Local nRetorno := 0 
Local cRetornoIcms := ""
Local cRetornoAliq := "" 
Local cTransp := SF2->F2_TRANSP
Local cUFfil  := SM0->M0_ESTENT

// Verica no paramentro MGF_VLFRET se a filial corrente está parametrizada para a impressão do valor do frete em dados adicionais da nota              
If cFilant $ cFilfre
      
	/// Verifica se a Transportadora é de estado diferente da Filial
	dBselectArea('SA4')
	dBsetOrder(1)//A4_FILIAL+A4_COD
	If DbSeek (xFilial('SA4')+ cTransp )

    	If alltrim(cUFfil) <> alltrim(SA4->A4_EST)

			cAlias1	:= GetNextAlias()
			
			cQuery := " SELECT GWF.GWF_BAPICO FRETE, GWN.GWN_NRROM, GWF_PCICMS "
			cQuery += "FROM "+RetSqlName("GWF") + " GWF " +", " +RetSqlName("SF2") + " SF2 " +", "+RetSqlName("GWN") + " GWN " + ", "+RetSqlName("GW1") + " GW1 "
			cQuery += " WHERE SF2.F2_DOC = '" + cNota + "' "
			cQuery += " AND SF2.F2_SERIE = '" + cSerie + "' "    
			cQuery += " AND GWF.GWF_FILIAL = '" + xFilial("GWF") + "' "
			cQuery += " AND SF2.F2_FILIAL = '" + xFilial("SF2") + "' "
			cQuery += " AND GWN.GWN_FILIAL = '" + xFilial("GWN") + "' "
			cQuery += " AND GWF.GWF_NRROM = GW1.GW1_NRROM
			cQuery += " AND GW1.GW1_NRROM = GWN.GWN_NRROM
			cQuery += " AND SF2.F2_DOC = GW1.GW1_NRDC
			cQuery += " AND SF2.F2_SERIE = GW1.GW1_SERDC
			cQuery += " AND GWF.D_E_L_E_T_=''
			cQuery += " AND GW1.D_E_L_E_T_=''
			cQuery += " AND SF2.D_E_L_E_T_=''
			cQuery += " AND GWN.D_E_L_E_T_=''
			
			
			cQuery := ChangeQuery(cQuery)
			DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlias1, .F., .T.)
			
			              
			cAlias2	:= GetNextAlias()
			
			cQuery := " SELECT SUM(GW8.GW8_PESOR) PESO "
			cQuery += "FROM "+RetSqlName("GWF") + " GWF " +", " +RetSqlName("SF2") + " SF2 " +", "+RetSqlName("GWN") + " GWN "+", "+RetSqlName("GW1") + " GW1 "+", "+RetSqlName("GW8") + " GW8 "
			cQuery += " WHERE GWF.GWF_NRROM ='" + (cAlias1)->GWN_NRROM + "' "
			cQuery += " AND GWF.GWF_FILIAL = '" + xFilial("GWF") + "' "
			cQuery += " AND SF2.F2_FILIAL = '" + xFilial("SF2") + "' "
			cQuery += " AND GWN.GWN_FILIAL = '" + xFilial("GWN") + "' "
			cQuery += " AND GW1.GW1_FILIAL = '" + xFilial("GW1") + "' "
			cQuery += " AND GW8.GW8_FILIAL = '" + xFilial("GW8") + "' "
			cQuery += " AND GWF.GWF_NRROM = GW1.GW1_NRROM
			cQuery += " AND GW1.GW1_NRROM = GWN.GWN_NRROM 
			cQuery += " AND SF2.F2_DOC = GW1.GW1_NRDC
			cQuery += " AND SF2.F2_SERIE = GW1.GW1_SERDC
			cQuery += " AND SF2.F2_DOC = GW8.GW8_NRDC
			cQuery += " AND SF2.F2_SERIE = GW8.GW8_SERDC
			cQuery += " AND GWF.D_E_L_E_T_=''
			cQuery += " AND GW1.D_E_L_E_T_=''
			cQuery += " AND SF2.D_E_L_E_T_=''
			cQuery += " AND GW8.D_E_L_E_T_=''                                 
			cQuery += " AND GWN.D_E_L_E_T_=''                                 
			
			cQuery := ChangeQuery(cQuery)
			DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlias2, .F., .T.)
			
			cAlias3	:= GetNextAlias()
			
			cQuery := " SELECT COUNT(GW1.GW1_NRROM) QTDE "
			cQuery += "FROM "+RetSqlName("GWF") + " GWF " +", " +RetSqlName("SF2") + " SF2 " +", "+RetSqlName("GWN") + " GWN "+", "+RetSqlName("GW1") + " GW1 "+", "+RetSqlName("GW8") + " GW8 "
			cQuery += " WHERE GWF.GWF_NRROM ='" + (cAlias1)->GWN_NRROM + "' "
			cQuery += " AND GWF.GWF_FILIAL = '" + xFilial("GWF") + "' "
			cQuery += " AND SF2.F2_FILIAL = '" + xFilial("SF2") + "' "
			cQuery += " AND GWN.GWN_FILIAL = '" + xFilial("GWN") + "' "
			cQuery += " AND GW1.GW1_FILIAL = '" + xFilial("GW1") + "' "
			cQuery += " AND GW8.GW8_FILIAL = '" + xFilial("GW8") + "' "
			cQuery += " AND GWF.GWF_NRROM = GW1.GW1_NRROM
			cQuery += " AND GW1.GW1_NRROM = GWN.GWN_NRROM 
			cQuery += " AND SF2.F2_DOC = GW1.GW1_NRDC
			cQuery += " AND SF2.F2_SERIE = GW1.GW1_SERDC
			cQuery += " AND SF2.F2_DOC = GW8.GW8_NRDC
			cQuery += " AND SF2.F2_SERIE = GW8.GW8_SERDC
			cQuery += " AND GWF.D_E_L_E_T_=''
			cQuery += " AND GW1.D_E_L_E_T_=''
			cQuery += " AND SF2.D_E_L_E_T_=''
			cQuery += " AND GW8.D_E_L_E_T_=''                                 
			cQuery += " AND GWN.D_E_L_E_T_=''                                 
			
			cQuery := ChangeQuery(cQuery)
			DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlias3, .F., .T.)
			If (cAlias3)->QTDE > 1
				nValfre := (cAlias1)->FRETE / (cAlias2)->PESO * (cAlias3)->QTDE                                       
			else 
				nValfre := (cAlias1)->FRETE 
			EndIf          
			
			nAliq	:= (cAlias1)->GWF_PCICMS
			nIcms   := nvalfre * nAliq / 100
			
			
			If nvalfre > 0                                       
				nvalfre := Alltrim(Transform(nvalfre,"@E 99,999,999.99"))  
				cRetorno := "Frete " +  nvalfre + " "
				If nAliq > 0 
					cRetorno += "Alíquota ICMS "+ alltrim(str(nAliq))+ "%" + " "
			        If nIcms > 0 
						nIcms := Alltrim(Transform(nIcms,"@E 99,999,999.99"))  			
						cRetorno += "Valor ICMS "+ nIcms
			        EndIf
				EndIf	
			EndIf
		EndIf	
	EndIf
EndIf	        

Return cRetorno
