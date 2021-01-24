#INCLUDE "PROTHEUS.CH"
/*
=====================================================================================
Programa.:              MGFFIN70
Autor....:              Atilio Amarilla
Data.....:              22/12/2017
Descricao / Objetivo:   Título FIDC - Bloquear transferência ou exclusão de borderô
Doc. Origem:            Contrato - GAP CRE019/20/21
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              TransaÃ§Ãµes referentes a Banco/Carteira FIDC
=====================================================================================
*/

User Function MGFFIN70()

	Local cBcoFIDC	:= GetMv("MGF_FIN43A",,"341/1000/123456/001")	// Banco FIDC
	Local aBcoFIDC	:= StrToKArr(cBcoFIDC,"/")
	Local cAgeFIDC, cCtaFIDC

	Local lRet := .T.
	Local aArea := {GetArea()}
	Local cQ := ""
	Local cAliasTrb := GetNextAlias()

	// GDN - 28/08/2018 - Ajuste para tratar o Banco e 
	// definir qual parametro considerar para FIDC
	do Case
		Case SE1->E1_PORTADO = '237'
			cBcoFIDC	:= GetMv("MGF_FIN44A",,"237/123/12345/001")		// Banco FIDC
		Otherwise
			cBcoFIDC	:= GetMv("MGF_FIN43A",,"341/1000/123456/001")	// Banco FIDC
	EndCase
	aBcoFIDC	:= StrToKArr(cBcoFIDC,"/")
	cBcoFIDC	:= aBcoFIDC[1]
	cAgeFIDC	:= Stuff( Space( TamSX3("E1_AGEDEP")[1] ) , 1 , Len(AllTrim(aBcoFIDC[2])) , Alltrim(aBcoFIDC[2]) )
	cCtaFIDC	:= Stuff( Space( TamSX3("E1_CONTA")[1] ) , 1 , Len(AllTrim(aBcoFIDC[3])) , Alltrim(aBcoFIDC[3]) )
	cSubFIDC	:= Stuff( Space( TamSX3("EE_SUBCTA")[1] ) , 1 , Len(AllTrim(aBcoFIDC[4])) , Alltrim(aBcoFIDC[4]) )

	If SE1->( E1_PORTADO + E1_AGEDEP + E1_CONTA ) == cBcoFIDC + cAgeFIDC + cCtaFIDC
	
		// verifica se titulo estah em status de recompra
		cQ := "SELECT 1 "
		cQ += "FROM "+RetSqlName("ZA7")+" ZA7, "+RetSqlName("ZA8")+" ZA8 "
		cQ += "WHERE "
		cQ += "ZA7.D_E_L_E_T_ = ' ' "
		cQ += "AND ZA8.D_E_L_E_T_ = ' ' "		
		cQ += "AND ZA7_FILIAL = '"+xFilial("ZA7")+"' "
		cQ += "AND ZA8_FILIAL = '"+xFilial("ZA8")+"' "		
		cQ += "AND ZA8_FILORI = '"+SE1->E1_FILIAL+"' "
		cQ += "AND ZA8_PREFIX = '"+SE1->E1_PREFIXO+"' "
		cQ += "AND ZA8_NUM = '"+SE1->E1_NUM+"' "		
		cQ += "AND ZA8_PARCEL = '"+SE1->E1_PARCELA+"' "		
		cQ += "AND ZA8_TIPO = '"+SE1->E1_TIPO+"' "
		cQ += "AND ZA8_STATUS IN ('1','2') "
		cQ += "AND ZA8_CODREM = ZA7_CODREM "
		cQ += "AND ZA7_STATUS = '2' "
		
		cQ := ChangeQuery(cQ)
		dbUseArea(.T.,"TOPCONN",tcGenQry(,,cQ),cAliasTrb,.T.,.T.)
		
		// titulo nao estah no status de recompra 
		If (cAliasTrb)->(Eof())
			lRet := .F.

			MsgStop("Este título se encontra na carteira FIDC."+CRLF+"Realize o processo de recompra antes de fazer esta operação.")
		Endif	
             
		(cAliasTrb)->(dbCloseArea())
	EndIf
	
	aEval(aArea,{|x| RestArea(x)})

Return lRet