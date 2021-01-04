#include "protheus.ch"

/*
=====================================================================================
Programa............: MGFCOM74
Autor...............: Totvs
Data................: 02/02/2018 
Descricao / Objetivo: Compras 
Doc. Origem.........: Compras
Solicitante.........: Cliente
Uso.................: 
Obs.................: Rotina chamada pelo ponto de entrada SF1100E
=====================================================================================
*/
User Function MGFCOM74()

Local aArea := {GetArea()}
Local nOper := 0
Local aDocto := {}

// chamada pela exclusao do documento de entrada
If IsInCallStack("A103GRAVA")
	If !Inclui .and. !Altera
		If !Empty(SF1->F1_ZVLRTOT) .and. !Empty(SF1->F1_ZBLQVAL)
			If COM74AlcVlr(SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA+"_VALOR_NFE")
				// estorna alcadas
				MaAlcDoc({SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA+"_VALOR_NFE","NF",SF1->F1_VALBRUT,,,GetMv("MGF_GRPNFE"),,IIf(Empty(SF1->F1_MOEDA),1,SF1->F1_MOEDA),SF1->F1_TXMOEDA,SF1->F1_EMISSAO},SF1->F1_EMISSAO,3)
			Endif	
		Endif	
	Endif	
Endif

// chamada pela exclusao da pre-nota
If IsInCallStack("Ma140Grava") .and. IsInCallStack("U_MTALCDOC")
	If !Inclui .and. !Altera
		nOper := ParamIxb[3]
		aDocto := ParamIxb[1]
		If nOper == 3 .and. aDocto[2] == "NF"
			If !Empty(SF1->F1_ZVLRTOT) .and. !Empty(SF1->F1_ZBLQVAL)
				// obs: nao chamar a funcao padrao maalcdoc diretamente aqui, sem testar antes se tem algum registro com a string "_VALOR_NFE" na SCR, pois este ponto de entrada
				// estah sendo chamado de dentro da propria funcao maalcdoc, e neste caso, a rotina entra em loop e dah erro de stack over flow 
				If COM74AlcVlr(SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA+"_VALOR_NFE")
					// estorna alcadas
					MaAlcDoc({SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA+"_VALOR_NFE","NF",SF1->F1_VALBRUT,,,GetMv("MGF_GRPNFE"),,IIf(Empty(SF1->F1_MOEDA),1,SF1->F1_MOEDA),SF1->F1_TXMOEDA,SF1->F1_EMISSAO},SF1->F1_EMISSAO,3)
				Endif	
			Endif	
		Endif
	Endif
Endif			
	
aEval(aArea,{|x| RestArea(x)})
			
Return()


Static Function COM74AlcVlr(cDocto)

Local cQ := ""
Local cAliasTrb := GetNextAlias()
Local lRet := .F.

cQ := "SELECT 1 "
cQ += "FROM "+RetSqlName("SCR")+" SCR "
cQ += "WHERE "
cQ += "SCR.D_E_L_E_T_ = ' ' "
cQ += "AND CR_FILIAL = '"+xFilial("SCR")+"' "
cQ += "AND CR_NUM = '"+cDocto+"' "
cQ += "AND CR_TIPO = 'NF' "

cQ := ChangeQuery(cQ)
dbUseArea(.T.,"TOPCONN",tcGenQry(,,cQ),cAliasTrb,.T.,.T.)

If (cAliasTrb)->(!Eof())
	lRet := .T.
Endif

(cAliasTrb)->(dbCloseArea())		

Return(lRet)