#Include "totvs.ch"
#Include "Protheus.ch"
#Include "topconn.ch"

/*/{Protheus.doc} XGFEENOF
//TODO Descrição auto-gerada.
@author thiago.queiroz
@since 02/10/2019
@version 1.0
@return ${return}, ${return_description}

@type function
10/07/2020 - Paulo da Mata - RTASK0010971 - Recriação para PRD em 13/07/2020
/*/
User Function XGFEENOF()

	Local lRet := .T.

	Local xFilial(Alias()) := PARAMIXB[1]

	Local cEsp 	  := PARAMIXB[2]
	Local cEmisDf := PARAMIXB[3]
	Local cSerie  := PARAMIXB[4]
	Local cNrDc   := PARAMIXB[5]

	Local cQuery := ""
	Local cNumRm := ""
	Local cChave := ""
	Local cEol   := Chr(13)+Chr(10)

	If Isincallstack("GFEA065") .And. (INCLUI .Or. ALTERA)

		dbSelectArea("GW3")

		GW3->( dbSetOrder(1) )

		If GW3->(dbSeek(xFilial("GW3") + cEsp + cEmisDf + cSerie + cNrDc ))

			If	GW3->GW3_TPDF == "2" .AND.  !GW3->GW3_SIT == "4"

				lRet := .F.

				RecLock("GW3", .F. )
				GW3->GW3_SIT := "2"
				MsUnlock()

			Endif

			cChave := GW3->(GW3_FILIAL+SubStr(GW3_SERDF,1,3)+GW3_NRDF)

			If Select("TMPGWF") > 0
			   TMPGWF->(dbCloseArea())
			Endif

		    // Paulo da Mata - RTASK0010971 - 17/06/2020 - Salvando o numero do romaneio, encontrado em GWF
			cQuery := "SELECT GWF_FILIAL,GWF_NRROM,GWF_NRDF,GWF_SERDF,GWF_DTEMDF,GWF_EMISDF "+cEol
			cQuery += "FROM "+RetSqlName("GWF")+" "+cEol
			cQuery += "WHERE D_E_L_E_T_ = ' ' "+cEol
			cQuery += "AND GWF_FILIAL   = '"+GW3->GW3_FILIAL+"' "+cEol
			cQuery += "AND GWF_NRDF     = '"+GW3->GW3_NRDF+"' "+cEol
			cQuery += "AND GWF_SERDF    = '"+GW3->GW3_SERDF+"' "+cEol
			cQuery += "AND GWF_DTEMDF   = '"+DtoS(Posicione("GW1",20,cChave,"GW1_DTEMIS"))+"' "+cEol
			cQuery += "AND GWF_EMISDF   = '"+Posicione("GW1",20,cChave,"GW1_EMISDC")+"' "+cEol

			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TMPGWF",.F.,.T.)
			dbSelectArea("TMPGWF")
 
			cNumRm := TMPGWF->GWF_NRROM

	        If !Empty(cNumRm) .And. Empty(GW3->GW3_ZNRROM)
  	
		    	GW3->(RecLock("GW3",.F.))
            	GW3->GW3_ZNRROM := cNumRm
		    	GW3->(MsUnLock())

        	EndIf
		
		EndIf

	Else

		dbSelectArea("GW3")

		GW3->( dbSetOrder(1) )

		If GW3->(dbSeek(xFilial("GW3") + cEsp + cEmisDf + cSerie + cNrDc ))

			If	GW3->GW3_TPDF == "2"

				lRet := .T.

				RecLock("GW3", .F. )
				GW3->GW3_SIT := "4"
				MsUnlock()

			Endif

			cChave := GW3->(GW3_FILIAL+SubStr(GW3_SERDF,1,3)+GW3_NRDF)

		    // Paulo da Mata - RTASK0010971 - 17/06/2020 - Salvando o numero do romaneio, encontrado em GWF
			If Select("TMPGWF") > 0
			   TMPGWF->(dbCloseArea())
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
			dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TMPGWF",.F.,.T.)
			dbSelectArea("TMPGWF")
 
			cNumRm := TMPGWF->GWF_NRROM

	        If !Empty(cNumRm) .And. Empty(GW3->GW3_ZNRROM)
  	
		    	GW3->(RecLock("GW3",.F.))
            	GW3->GW3_ZNRROM := cNumRm
		    	GW3->(MsUnLock())

        	EndIf

		EndIf

	EndIf

Return lRet