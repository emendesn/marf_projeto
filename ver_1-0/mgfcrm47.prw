#include 'protheus.ch'
#include 'parmtype.ch'


/*
=====================================================================================
Programa............: MGFCRM49
Autor...............: Flavio Dentello
Data................: 08/03/2017 
Descricao / Objetivo: Ponto de entrada para criar resolução da RAMI
Doc. Origem.........: CRM- RAMI
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/

user function MGFCRM47()

Local cRAMI       := ""
Local lRet 	      := .F.
local aArea	      := getArea()
Local cAliasTotal := ""
local aAreaSC6    := SC6->(getArea())
Local aAreaZAV    := ZAV->(getArea())
local cQuery	  := ""
local cAliasRAMI  := ""
local nQTD		  := 0	
local nUsadoRes	  := 0


	If !empty(SC6->C6_ZRAMI)
	                                                                
		SC6->(DbSetOrder(1))
		SC6->(MsSeek(XFILIAL('SC6') + SC6->C6_NUM + '01'))
		
		While SC6->(!EOF()) .AND. SC6->C6_FILIAL == XFILIAL('SC6') .AND. SC6->C6_NOTA == SF2->F2_DOC .AND. SC6->C6_SERIE == SF2->F2_SERIE .AND. SC6->C6_ZRAMI <> ' '
		
			lret := .T.
			
			ZAV->(DbGotop())
			DbSelectArea('ZAV')
			DbSetOrder(1)
			ZAV->(MsSeek(xfilial('ZAV') + SC6->C6_ZRAMI ))
						
					RecLock("ZAX",.T.)
					ZAX->ZAX_FILIAL := XFILIAL('SF2') 
					ZAX->ZAX_CDRAMI := SC6->C6_ZRAMI
					ZAX->ZAX_ITEMNF := SC6->C6_ITEM
					ZAX->ZAX_CODPRO := SC6->C6_PRODUTO
					ZAX->ZAX_DESCPR := POSICIONE('SB1',1,XFILIAL('SB1') + SC6->C6_PRODUTO, "B1_DESC")
					ZAX->ZAX_QTD    := SC6->C6_QTDVEN
					ZAX->ZAX_PRECO  := SC6->C6_PRCVEN
					ZAX->ZAX_TOTAL  := SC6->C6_VALOR
					//ZAX->ZAX_RESOLU := //VERIFICAR
					//ZAX->ZAX_STATUS := "1" //1=Procedente;2=Improcedente                                                                                                     
					//ZAX->ZAX_OBSPED := //VERIFICAR
					ZAX->ZAX_NOTA   := ZAV->ZAV_NOTA
					ZAX->ZAX_SERIE  := ZAV->ZAV_SERIE
					//ZAX->ZAX_COMERC := //VERIFICAR
					//ZAX->ZAX_QUALID := //VERIFICAR
					//ZAX->ZAX_EXPEDI := //VERIFICAR
					//ZAX->ZAX_PCP    := //VERIFICAR
					//ZAX->ZAX_TRANSP := //VERIFICAR
					ZAX->ZAX_DATA   := SF2->F2_EMISSAO
					ZAX->ZAX_ID     := STRZERO(VAL(SC6->C6_ITEM),4)
					//ZAX->ZAX_ID     := //VERIFICAR SEQUENCIAL
					ZAX->ZAX_NFGER  := SF2->F2_DOC
					ZAX->ZAX_SERGR  := SF2->F2_SERIE
					ZAX->(MsUnlock())
					
			SC6->(DBSKIP())
					
		Enddo
	
	
	Else
	
		SC6->(DbSetOrder(1))
		SC6->(MsSeek(XFILIAL('SC6') + SC6->C6_NUM + '01'))
		
		While SC6->(!EOF()) .AND. SC6->C6_FILIAL == XFILIAL('SC6') .AND. SC6->C6_NOTA == SF2->F2_DOC .AND. SC6->C6_SERIE == SF2->F2_SERIE 
	
				nQTD := 0
				cAliasRAMI := GetNextAlias()	
			
				cQuery := " SELECT * FROM "
				cQUERY +=  RetSqlName("ZAW")+" ZAW " + ", " + RetSqlName("ZAV")+" ZAV " 
				cQuery += " WHERE ZAW_FILIAL ='" + XFILIAL("ZAX") +"'"
				cQuery += " AND ZAV_FILIAL ='" + XFILIAL("ZAV") +"'"
				cQuery += " AND ZAW_CDRAMI = ZAV_CODIGO "
				cQuery += " AND ZAV_TPFLAG <> '1' "
				cQuery += " AND ZAV_TPFLAG <> '1' "
				cQuery += " AND ZAW_CDRAMI IN ('" + SC5->C5_ZRAMI1 + "'"  
			
				If !empty(SC5->C5_ZRAMI2)
					cQuery += ", " + "'" + SC5->C5_ZRAMI2 + "'" 
				endif								 
				If !empty(SC5->C5_ZRAMI3)
					cQuery += ", " + "'" + SC5->C5_ZRAMI3 + "'" 
				endif								 
				If !empty(SC5->C5_ZRAMI4)
					cQuery += ", " + "'" + SC5->C5_ZRAMI4 + "'" 
				endif								 
				If !empty(SC5->C5_ZRAMI5)
					cQuery += ", " + "'" + SC5->C5_ZRAMI5 + "'" 
				endif								 
				If !empty(SC5->C5_ZRAMI6)
					cQuery += ", " + "'" + SC5->C5_ZRAMI6 + "'" 
				endif								 
				If !empty(SC5->C5_ZRAMI7)
					cQuery += ", " + "'" + SC5->C5_ZRAMI7 + "'" 
				endif							
				If !empty(SC5->C5_ZRAMI8)
					cQuery += ", " + "'" + SC5->C5_ZRAMI8 + "'" 
				endif								 
				If !empty(SC5->C5_ZRAMI9)
					cQuery += ", " + "'" + SC5->C5_ZRAMI9 + "'" 
				endif								 
				If !empty(SC5->C5_ZRAMI10)
					cQuery += ", " + "'" + SC5->C5_ZRAMI10 + "'" 
				endif								 
				If !empty(SC5->C5_ZRAMI11)
					cQuery += ", " + "'" + SC5->C5_ZRAMI11 + "'" 
				endif								 
				If !empty(SC5->C5_ZRAMI12)
					cQuery += ", " + "'" + SC5->C5_ZRAMI12 + "'" 
				endif								 
				If !empty(SC5->C5_ZRAMI13)
					cQuery += ", " + "'" + SC5->C5_ZRAMI13 + "'" 
				endif								 
				If !empty(SC5->C5_ZRAMI14)
					cQuery += ", " + "'" + SC5->C5_ZRAMI14 + "'" 
				endif								 
				If !empty(SC5->C5_ZRAMI15)
					cQuery += ", " + "'" + SC5->C5_ZRAMI15 + "'" 
				endif								 
				If !empty(SC5->C5_ZRAMI16)
					cQuery += ", " + "'" + SC5->C5_ZRAMI16 + "'" 
				endif								 
				If !empty(SC5->C5_ZRAMI17)
					cQuery += ", " + "'" + SC5->C5_ZRAMI17 + "'" 
				endif								 
				If !empty(SC5->C5_ZRAMI18)
					cQuery += ", " + "'" + SC5->C5_ZRAMI18 + "'" 
				endif								 
				If !empty(SC5->C5_ZRAMI19)
					cQuery += ", " + "'" + SC5->C5_ZRAMI19 + "'" 
				endif								 
				If !empty(SC5->C5_ZRAMI20)
					cQuery += ", " + "'" + SC5->C5_ZRAMI20 + "'" 
				endif								 
				If !empty(SC5->C5_ZRAMI21)
					cQuery += ", " + "'" + SC5->C5_ZRAMI21 + "'" 
				endif								 
				If !empty(SC5->C5_ZRAMI22)
					cQuery += ", " + "'" + SC5->C5_ZRAMI22 + "'" 
				endif								 
				If !empty(SC5->C5_ZRAMI23)
					cQuery += ", " + "'" + SC5->C5_ZRAMI23 + "'" 
				endif								 
				If !empty(SC5->C5_ZRAMI24)
					cQuery += ", " + "'" + SC5->C5_ZRAMI24 + "'" 
				endif								 
				If !empty(SC5->C5_ZRAMI25)
					cQuery += ", " + "'" + SC5->C5_ZRAMI25 + "'" 
				endif								 
	
			
				cQuery += ")"
			
				cQuery += " AND ZAW_CDPROD ='" +  SC6->C6_PRODUTO +"'"
				cQuery += " AND ZAW.D_E_L_E_T_<> '*' "
				cQuery += " AND ZAV.D_E_L_E_T_<> '*' "
			
				cQuery := ChangeQuery(cQuery)
			
				dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasRAMI, .F., .T.)
	
	
				While (cAliasRAMI)->(!EOF()) .AND. (cAliasRAMI)->ZAW_CDPROD == SC6->C6_PRODUTO
						
					nQTD := (cAliasRAMI)->ZAW_QTD
					
					RecLock("ZAX",.T.)
					ZAX->ZAX_FILIAL := XFILIAL('SF2') 
					ZAX->ZAX_CDRAMI := (cAliasRAMI)->ZAW_CDRAMI
					ZAX->ZAX_ITEMNF := (cAliasRAMI)->ZAW_ITEMNF
					ZAX->ZAX_CODPRO := (cAliasRAMI)->ZAW_CDPROD
					ZAX->ZAX_DESCPR := POSICIONE('SB1',1,XFILIAL('SB1') + (cAliasRAMI)->ZAW_CDPROD, "B1_DESC")				
					nUsadoRes := UTILIZADO()
					ZAX->ZAX_QTD    := (cAliasRAMI)->ZAW_QTD //- nUsadoRes
					ZAX->ZAX_TOTAL  := (cAliasRAMI)->ZAW_TOTAL
					ZAX->ZAX_PRECO  := (cAliasRAMI)->ZAW_PRECO
					//ZAX->ZAX_RESOLU := //VERIFICAR
					//ZAX->ZAX_STATUS := "1" //1=Procedente;2=Improcedente                                                                                                     
					//ZAX->ZAX_OBSPED := //VERIFICAR
					ZAX->ZAX_NOTA   := (cAliasRAMI)->ZAV_NOTA
					ZAX->ZAX_SERIE  := (cAliasRAMI)->ZAV_SERIE
					//ZAX->ZAX_COMERC := //VERIFICAR
					//ZAX->ZAX_QUALID := //VERIFICAR
					//ZAX->ZAX_EXPEDI := //VERIFICAR
					//ZAX->ZAX_PCP    := //VERIFICAR
					//ZAX->ZAX_TRANSP := //VERIFICAR
					ZAX->ZAX_DATA   := SF2->F2_EMISSAO
					ZAX->ZAX_ID     := (cAliasRAMI)->ZAW_ID
					//ZAX->ZAX_ID     := //VERIFICAR SEQUENCIAL
					ZAX->ZAX_NFGER  := SF2->F2_DOC
					ZAX->ZAX_SERGR  := SF2->F2_SERIE
					ZAX->(MsUnlock())
	
					(cAliasRAMI)->(DBSKIP())
				Enddo
			SC6->(DBSKIP())
					
		Enddo
	
	EndIf


FinalRAM()

RestArea(aArea)
Restarea(aAreaSC6)
Restarea(aAreaZAV)
	
Return 

Static Function FinalRAM()

Local cQuery 	 := ""
Local cAliasQTDT := ""
Local cAliasQTD  := ""	
Local lFinaliza	 := .T.
Local QTDZAW	 := 0
Local QTDZAX	 := 0

SC6->(DbGoTop())
SC6->(DbSetOrder(1))
SC6->(MsSeek(XFILIAL('SC6') + SC6->C6_NUM + '01'))


	While SC6->(!EOF()) .AND. SC6->C6_FILIAL == XFILIAL('SC6') .AND. SC6->C6_NOTA == SF2->F2_DOC .AND. SC6->C6_SERIE == SF2->F2_SERIE /*.AND. SC6->C6_ZRAMI <> ' '*/ .AND. lFinaliza == .T.		
		
		cAliasQTDT := GetNextAlias()	
		
		cQuery := " SELECT SUM(ZAW_QTD)QTDT  FROM "
		cQUERY +=  RetSqlName("ZAW")+" ZAW "  
		cQuery += " WHERE ZAW_FILIAL ='" + XFILIAL("ZAW") +"'"
		cQuery += " AND ZAW_NOTA ='" + ZAV->ZAV_NOTA +"'"
		cQuery += " AND ZAW_SERIE ='" + ZAV->ZAV_SERIE +"'"
		cQuery += " AND ZAW_CDPROD ='" + SC6->C6_PRODUTO +"'"
		cQuery += " AND ZAW_CDRAMI ='" + ZAV->ZAV_CODIGO +"'"
		
		cQuery += " AND ZAW.D_E_L_E_T_<> '*' "
		
		cQuery := ChangeQuery(cQuery)
		                    
		If (cAliasQTDT)->(!eof()) 
		
			QTDZAW := (cAliasQTDT)->QTDT
			
			cAliasQTD := GetNextAlias()	
			
			cQuery := " SELECT SUM(ZAX_QTD)QTD  FROM "
			cQUERY +=  RetSqlName("ZAX")+" ZAX "  
			cQuery += " WHERE ZAX_FILIAL ='" + XFILIAL("ZAV") +"'"
			cQuery += " AND ZAX_NOTA ='" + ZAV->ZAV_NOTA +"'"
			cQuery += " AND ZAX_SERIE ='" + ZAV->ZAV_SERIE +"'"
			cQuery += " AND ZAX_CODPRO ='" + SC6->C6_PRODUTO +"'"
			cQuery += " AND ZAX_CDRAMI ='" + ZAV->ZAV_CODIGO +"'"
			cQuery += " AND ZAX.D_E_L_E_T_<> '*' "
		
			cQuery := ChangeQuery(cQuery)

			dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasQTD, .F., .T.)
		
		
			If (cAliasQTD)->(!eof())
				
				QTDZAX := (cAliasQTD)->QTD
			
				If QTDZAX <= QTDZAW
					lFinaliza := .T.
				Else
					lFinaliza := .F.
				EndIf
			Else
				lFinaliza := .F.
			EndIf
		Else
			lFinaliza := .F.
		EndIf
		
		SC6->(DBSKIP())
	Enddo	

If lFinaliza
                       
	If ZAV->(!Eof()) // inserido em 08/06/18 por gresele, pois estava dando erro de ZAV em EOF durante o reclock
		ZAV->(RecLock("ZAV",.F.))
		ZAV->ZAV_STATUS := "1"
		ZAV->(MsUnlock())
	Endif	

EndIf

Return 



Static Function UTILIZADO()

Local cquery 	  := ""
Local cAliasUsado := ""
Local nUsado      := 0

cAliasUsado := GetNextAlias()	

cQuery := " SELECT SUM(ZAX_QTD) QTD FROM "
cQuery += RetSqlName("ZAX")+" ZAX "
cQuery += " WHERE ZAX_CDRAMI = '" + ZAX->ZAX_CDRAMI + "' "
cQuery += " AND ZAX.D_E_L_E_T_ = ' '"

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasUsado, .F., .T.)


if (cAliasUsado)->(!eof())
	nUsado := (cAliasUsado)->QTD
EndIf

Return nUsado