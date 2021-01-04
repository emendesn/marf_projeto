#include 'protheus.ch'
#include 'parmtype.ch'

#DEFINE cEol Chr(13)+Chr(10)

/*
Criado em: 15/04/2020
Por: Paulo da Mata
Task : RTASK0010971
Objetivo: Salvar a data de vencimento, de forma AUTOM�TICA, oriundo da tabela GWN, via importacao do XML do CT-e

10/07/2020 - Paulo da Mata - RTASK0010971 - Recriacao para PRD em 13/07/2020
*/ 
User Function MGFGFE64()

	Local aArea  := GetArea()
	Local cChave := GW3->(GW3_FILIAL+SubStr(GW3_SERDF,1,3)+GW3_NRDF)
	Local cQuery := ""
	Local cNumRm := ""
	Local dDtVnc := CtoD(Space(08))

	If Isincallstack('GFEA065')

		If Select("TRBSE2") > 0
			TRBSE2->(dbCloseArea())
		Endif

		cQuery := "SELECT E2_FILIAL,E2_PREFIXO,E2_NUM,E2_EMISSAO,E2_VENCREA "+cEol
		cQuery += "FROM "+RetSqlName("SE2")+" "+cEol
		cQuery += "WHERE D_E_L_E_T_ = ' ' "+cEol
		cQuery += "AND E2_FILIAL  = '"+GW3->GW3_FILIAL+"' "+cEol
		cQuery += "AND E2_PREFIXO = '"+GW3->GW3_SERDF+"' "+cEol
		cQuery += "AND E2_NUM     = '"+GW3->GW3_NRDF+"' "+cEol

		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRBSE2",.F.,.T.)
		dbSelectArea("TRBSE2")
 
		dDtVnc := TRBSE2->E2_VENCREA
    
        If !Empty(dDtVnc)
		    GW3->(RecLock("GW3",.F.))
			GW3->GW3_ZVECTO := dDtVnc
		    GW3->(MsUnLock())
        EndIf
	
	EndIf

	RestArea(aArea)

Return

/*
Funcao GATGFE64
Criado em: 15/04/2020
Por: Paulo da Mata
Task : RTASK0010971
Objetivo: Salvar o numero do romaneio, oriundo da tabela GWN, quando da inclusao manual da chave da DANFE
*/ 

User Function GATGFE64

	Local aArea  := GetArea()
	Local cChave := GW3->(GW3_FILIAL+SubStr(GW3_SERDF,1,3)+GW3_NRDF)
	Local cNumRm := ""
	Local cQuery := ""

	If Isincallstack('GFEA065')

		If Select("TRBGWF") > 0
			TRBGWF->(dbCloseArea())
		Endif

		cQuery := "SELECT GWF_FILIAL,GWF_NRROM,GWF_NRDF,GWF_SERDF,GWF_DTEMDF,GWF_EMISDF "+cEol
		cQuery += "FROM "+RetSqlName("GWF")+" "+cEol
		cQuery += "WHERE D_E_L_E_T_ = ' ' "+cEol
		cQuery += "AND GWF_FILIAL   = '"+GW3->GW3_FILIAL+"' "+cEol
		cQuery += "AND GWF_NRDF     = '"+GW3->GW3_NRDF+"' "+cEol
		cQuery += "AND GWF_SERDF    = '"+GW3->GW3_SERDF+"' "+cEol
		cQuery += "AND GWF_DTEMDF   = '"+DtoS(Posicione("GW1",20,cChave,"GW1_DTEMIS"))+"' "+cEol
		cQuery += "AND GWF_EMISDF   = '"+Posicione("GW1",20,cChave,"GW1_EMISDC")+"' "+cEol

		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRBGWF",.F.,.T.)
		dbSelectArea("TRBGWF")
 
		cNumRm := TRBGWF->GWF_NRROM

	EndIf

	RestArea(aArea)

Return(cNumRm)

/*
Funcao GFEGAT64
Criado em: 11/05/2020
Por: Paulo da Mata
Task : RTASK0010971
Objetivo: Salvar a data do vencimento do titulo, oriundo da tabela SE2, quando da inclusao ou alteracao manual da chave da DANFE
*/ 

User Function GFEGAT64

	Local aArea  := GetArea()
	Local cChave := GW3->(GW3_FILIAL+SubStr(GW3_SERDF,1,3)+GW3_NRDF)
	Local cQuery := ""
	Local dDtVnc := CtoD(Space(08))

	If Isincallstack('GFEA065')

		If Select("TRBCPR") > 0
			TRBCPR->(dbCloseArea())
		Endif

		cQuery := "SELECT E2_FILIAL,E2_PREFIXO,E2_NUM,E2_EMISSAO,E2_VENCREA "+cEol
		cQuery += "FROM "+RetSqlName("SE2")+" "+cEol
		cQuery += "WHERE D_E_L_E_T_ = ' ' "+cEol
		cQuery += "AND E2_FILIAL  = '"+GW3->GW3_FILIAL+"' "+cEol
		cQuery += "AND E2_PREFIXO = '"+GW3->GW3_SERDF+"' "+cEol
		cQuery += "AND E2_NUM     = '"+GW3->GW3_NRDF+"' "+cEol
		
		cQuery := ChangeQuery(cQuery)

		dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRBCPR",.F.,.T.)
		dbSelectArea("TRBCPR")
 
		dDtVnc := TRBCPR->E2_VENCREA

	EndIf	

	RestArea(aArea)

Return(dDtVnc)
