#include "protheus.ch"

/*
=====================================================================================
Programa............: MGFFAT88
Autor...............: Totvs
Data................: Junho/2018 
Descricao / Objetivo: Rotina chamada pelo PE M460FIM
Doc. Origem.........: Compras
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Gravacao de campos do GFE
=====================================================================================
*/
User Function MGFFAT88()

Local aArea := {SD2->(GetArea()),GW8->(GetArea()),GetArea()}
Local cQ := ""
Local cAliasTrb := GetNextAlias()
Local lContinua := .F.

// verifica se carga estah na zzr
cQ := "SELECT 1 "
cQ += "FROM "+RetSqlName("ZZR")+" ZZR "
cQ += "WHERE ZZR_FILIAL = '"+xFilial("ZZR")+"' "
cQ += "AND ZZR_CARGA = '"+SF2->F2_CARGA+"' "
cQ += "AND D_E_L_E_T_ = ' ' "
					
cQ := ChangeQuery(cQ)
					
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQ),cAliasTrb, .F., .T.)

If (cAliasTrb)->(!Eof())
	lContinua := .T.
Endif

(cAliasTrb)->(dbCloseArea())	

// se achou carga na zzr, continua processamento
If lContinua
	ZZR->(dbSetOrder(1))
	GW8->(dbSetOrder(2))
	SD2->(dbSetOrder(3))
	If SD2->(dbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA))
		While SD2->(!Eof()) .and. xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA == SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA
			//If GW8->(dbSeek(xFilial("GW8")+Padr("NFS",TamSX3("GW8_CDTPDC")[1])+IIf(SD2->D2_TIPO $ ("D/B"),GetAdvfVal("SA2","A2_CGC",xFilial("SA2")+SD2->D2_CLIENTE+SD2->D2_LOJA,1,""),GetAdvfVal("SA1","A1_CGC",xFilial("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA,1,""))+Padr(SD2->D2_SERIE,TamSX3("GW8_SERDC")[1])+Padr(SD2->D2_DOC,TamSX3("GW8_NRDC")[1])+Padr(SD2->D2_ITEM,TamSX3("GW8_SEQ")[1])))
			If GW8->(dbSeek(xFilial("GW8")+Padr("NFS",TamSX3("GW8_CDTPDC")[1])+GetAdvfVal("SM0","M0_CGC",FWGrpCompany()+cFilAnt,1,"")+Padr(SD2->D2_SERIE,TamSX3("GW8_SERDC")[1])+Padr(SD2->D2_DOC,TamSX3("GW8_NRDC")[1])+Padr(SD2->D2_ITEM,TamSX3("GW8_SEQ")[1])))			
				If ZZR->(dbSeek(xFilial("ZZR")+Padr(SD2->D2_PEDIDO,TamSX3("ZZR_PEDIDO")[1])+Padr(SD2->D2_ITEMPV,TamSX3("ZZR_ITEM")[1])))
					If !Empty(ZZR->ZZR_PESOL)
						GW8->(RecLock("GW8",.F.))
						GW8->GW8_QTDALT := ZZR->ZZR_PESOL
						GW8->(MsUnLock())
					Endif	
				Endif		
			Endif
			SD2->(dbSkip())
		Enddo
	Endif
Endif				
			
aEval(aArea,{|x| RestArea(x)})	
		
Return()