#include 'protheus.ch'
#include 'totvs.ch'

/*/{Protheus.doc} MGFFINBM
//Descrição : Atualiza a data da baixa nos titulos de frete (RTASK0010971)
@author Paulo da Mata
@since 09/04/2020
@version 1.0
@type function

10/07/2020 - Paulo da Mata - RTASK0010971 - Recriação para PRD em 13/07/2020

/*/

User Function MGFFINBM

   	Local aArea  := GetArea()
	Local cQuery := ""
	Local cCte   := ""
	Local cChave := ""
	Local cCRLF  := CHR(13)+CHR(10)
	Local cCnpj  := Posicione("SA2",1,xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA,"A2_CGC")
	Local dDtBxa := dBaixa
	Local lRet   := .T.

	If Select("TRBSF1") > 0
		TRBSF1->(dbCloseArea())
	Endif
	
	// Busca a Especie do documento de frete
	cQuery := "SELECT F1_FILIAL,F1_DOC,F1_SERIE,F1_FORNECE,F1_LOJA,F1_TIPO,F1_EMISSAO,F1_ESPECIE "+cCRLF
	cQuery += "FROM "+RetSqlName("SF1")+" "+cCRLF
	cQuery += "WHERE D_E_L_E_T_ = ' ' "+cCRLF
	cQuery += "AND F1_FILIAL 	= '"+SE2->E2_FILIAL+"' "+cCRLF
	cQuery += "AND F1_DOC    	= '"+SE2->E2_NUM+"' "+cCRLF
	cQuery += "AND F1_SERIE 	= '"+SE2->E2_PREFIXO+"' "+cCRLF
	cQuery += "AND F1_EMISSAO 	= '"+DtoS(SE2->E2_EMISSAO)+"' "+cCRLF

	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRBSF1",.F.,.T.)
	dbSelectArea("TRBSF1")

	If 	TRBSF1->(!Eof())
	   	
		cCte := TRBSF1->F1_ESPECIE
		
		If AllTrim(cCte) != "CTE"
			TRBSF1->(dbCloseArea())
			RestArea(aArea)
	  		Return lRet
		EndIf

	Else
	
		TRBSF1->(dbCloseArea())
		RestArea(aArea)
	  	Return lRet
	
	EndIf

	If AllTrim(cCte) == "CTE" // Só executa a condição, se for a espécie for realmente CTE

	   cChave := SE2->E2_FILIAL+cCte+cCnpj+SE2->(AllTrim(E2_PREFIXO)+Space(02)+AllTrim(E2_NUM)+Space(07)+DtoS(E2_EMISSAO))

	   dbSelectArea("GW3")
	   dbSetOrder(1)
	   
	   	If dbSeek(cChave)
	     	GW3->(RecLock("GW3",.F.))
	     	GW3->GW3_ZDTBX := dDtBxa
	     	GW3->(MsUnLock())
		EndIf

	EndIf

	dbSelectArea("TRBSF1")	  
	TRBSF1->(dbCloseArea())
	RestArea(aArea)

Return lRet