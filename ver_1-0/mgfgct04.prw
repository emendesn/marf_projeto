#include "rwmake.ch"
#include "topconn.ch"
#INCLUDE "PROTHEUS.CH"
#DEFINE LQBR CHR(13)+CHR(10)

/*
=====================================================================================
Programa.:              MGFGCT04
Autor....:              Luis Artuso
Data.....:              05/10/2016
Descricao / Objetivo:   Execucao do P.E. M460FIM
Doc. Origem:            Contrato - GAP MGFGCT01
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
User Function MGFGCT04()

	Local cAliasSE1	:= ""
	Local cAliasCN9	:= ""
	Local cAliasTMP	:= ""
	Local cAliasSF2	:= ""
	Local aAreaSE1	:= {}
	Local aAreaSF2	:= {}
	Local aAreaCN9	:= {}
	Local cNumContr	:= ""
	Local cTipodes  := SuperGetMv('MGF_CONTDES' , NIL, '')
	Local lAltTpDesc := .F.

	cAliasSE1	:= "SE1"

	cAliasSF2	:= "SF2"

	cAliasCN9	:= "CN9"

//	cNumContr	:= SC5->C5_MDCONTR
	cNumContr	:= SC5->C5_ZMDCTR

	If ( !Empty(AllTrim(cNumContr)) )

		aAreaSE1	:= (cAliasSE1)->(GetArea())

		aAreaSF2	:= (cAliasSF2)->(GetArea())

		aAreaCN9	:= (cAliasCN9)->(GetArea())

		fGeraQry(@cAliasTMP , cNumContr)

		If ( (cAliasTMP)->(!EOF()) )
		
			//cChaveSE1	:= (cAliasSF2)->(F2_FILIAL+F2_DOC+F2_SERIE)
			cChaveSE1	:= (cAliasSF2)->(F2_FILIAL+F2_SERIE+F2_DOC)
		
			(cAliasSE1)->(dbGoTop())
			
			ZZ4->(dbSetOrder(1))
			If ZZ4->(dbSeek(xFilial("ZZ4")+cTipodes))
				lAltTpDesc := .T.
			Endif	
			
			SE1->(DBSETORDER(1))
			If ( (cAliasSE1)->(dbSeek(cChaveSE1)) )
			
				Do While (cAliasSE1)->(E1_FILIAL+E1_PREFIXO+E1_NUM) == (cAliasSF2)->(F2_FILIAL+F2_SERIE+F2_DOC)

					If ( RecLock(cAliasSE1 , .F.) )

						(cAliasSE1)->(E1_DESCFIN)	:= (cAliasTMP)->DESCONTO

						(cAliasSE1)->(E1_DIADESC)	:= 99
						If lAltTpDesc
							(cAliasSE1)->(E1_ZTPDESC) := cTipodes
						Endif	

						(cAliasSE1)->(MsUnlock())

					EndIf

					(cAliasSE1)->(dbSkip())

				EndDo			
			
			EndIf
		
		EndIf

		RestArea(aAreaSE1)

		RestArea(aAreaSF2)

		RestArea(aAreaCN9)
		
		(cAliasTMP)->(dbCloseArea())

	EndIf	

Return

/*
=====================================================================================
Programa.:              fGeraQry
Autor....:              Luis Artuso
Data.....:              05/10/2016
Descricao / Objetivo:   Executa Query para verificar se o pedido tem contrato atrelado.
Doc. Origem:            Contrato - GAP MGFGCT01
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
Static Function fGeraQry(cAliasTMP , cNumContr)

	Local cTamContr	:= ""

	Local cQuery	:= ""

	cAliasTMP	:= GetNextAlias()

	cTamContr	:= Space(TamSX3("C5_ZMDCTR")[1]) //Space(TamSX3("C5_MDCONTR")[1])

	cQuery	:=	"SELECT "

	cQuery	+= 		"CN9_ZTOTDE AS DESCONTO "

	cQuery	+=	"FROM "

	cQuery	+=		RetSqlName("CN9") + " CN9 "

	cQuery	+=	"WHERE "

	cQuery	+= 			"CN9.CN9_FILIAL = " + "'" + Alltrim(GetMV('MGF_CT09FI',.F.,"010001")) /*xFilial("CN9")*/ + "'" + " AND "

	cQuery	+= 			"CN9.CN9_NUMERO = " + "'" + cNumContr + "' AND "
	
	cQuery	+= 			"CN9.CN9_SITUAC = '05' "

	dbUseArea(.T. , "TOPCONN" , TcGenQry(,,cQuery) , cAliasTMP , .F. , .T.)

Return cAliasTMP