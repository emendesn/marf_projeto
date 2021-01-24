#include 'protheus.ch'
#include 'parmtype.ch'
#Define   ENTER Chr( 13 ) + Chr( 10 )
/*
======================================================================================================
Autor....: Caroline Cazela
Data.....: 04/12/2018
Descrição: Chamado pelo ponto de entrada DPCTB102GR para gravaï¿½ï¿½o da SCR e DBM do lançamento contábil.
======================================================================================================
*/
user function MGFCTB25(nxOpc)
	
	Local aArea			:= GetArea()
	Local aAreaCT2		:= CT2->(getArea())
	
	Local cNome			:= ""
	Local cEmpFil		:= ""
	Local cCodigo		:= ""
	Local cVersao   	:= ""
	Local cAliasGrd		:= GetNextAlias()
	Local cNextAlias 	:= GetNextAlias()
	Local cUser			:= ""
	Local cNum			:= ""
	Local cObs			:= ""
	Local nValSCR		:= 0
	Local nIt			:= 1
	Local nValTot		:= 0
	Local lExclusao		:= .F.
	Local lAprov		:= .T.
	
	Default nxOpc := 3

	//Não deve ser gerada grade quando o Execauto é acionado pela rotina de aprovação.
	//Esse provblema estava causando looping e após aprovado o registro voltava para a grade novamente
	IF isInCallStack("U_MGFCOM14")
		Return (.T.)
	EndIf
	
	If CT2->CT2_TPSALD == "2"
		//(nxOpc = 4 .AND. Empty(CT2->CT2_ORIGEM));  // Saldo Orçado ou Alteração ; 18/09/2019: Alteração de lançamento não deve ir para a grade.


		cEmpFil		:= Alltrim(CT2->CT2_FILIAL)
		cUser		:= Alltrim(RetCodUsr())
		cNome		:= UsrFullName(cUser)
		cNum		:= DTOS(CT2->CT2_DATA) + CT2->CT2_LOTE + CT2->CT2_SBLOTE + CT2->CT2_DOC
		cObs		:= CT2->CT2_HIST
		nValTot 	:= xValLanc(xFilial('CT2'),cNum)
		
		
		//Encontra a Grade de aprovação:
		If Select(cAliasGrd) > 0
			(cAliasGrd)->(DbClosearea())
		Endif

		BeginSql Alias cAliasGrd

			SELECT DISTINCT
				ZA0.ZA0_CODIGO,
				ZA0.ZA0_VERSAO
			FROM %Table:ZA0% ZA0
			INNER JOIN %Table:ZAB% ZAB
					ON ZAB.ZAB_CODIGO = ZA0.ZA0_CODIGO
				AND ZAB.ZAB_VERSAO = ZA0.ZA0_VERSAO
				AND ZAB.%NotDel%
			WHERE
				ZAB.ZAB_HOMOLO = 'S' AND
				ZA0.%NotDel% AND
				ZA0.ZA0_EMPFIL = %Exp:cEmpFil% AND
				ZA0.ZA0_CDUSER =  %Exp:cUser% AND
				ZA0.ZA0_FILIAL = %xFilial:ZA0%
			ORDER BY ZA0_CODIGO
		EndSql

		While (cAliasGrd)->(!EOF())

			cCodigo := (cAliasGrd)->ZA0_CODIGO
			cVersao := (cAliasGrd)->ZA0_VERSAO

			(cAliasGrd)->(dbSkip())
		EndDo

		(cAliasGrd)->(DbClosearea())

		//Exclui a Alçada caso exista uma com a mesma chave
		dbSelectArea('SCR')
		SCR->(dbSetOrder(1))//CR_FILIAL, CR_TIPO, CR_NUM, CR_NIVEL

		If SCR->(dbSeek(xFilial('SCR') + 'LC' + PadR(cNum,TamSX3('CR_NUM')[1])))
			nValSCR 	:= SCR->CR_TOTAL
			lExclusao	:= nxOpc == 5
			
			While SCR->(!EOF()) .and. SCR->(CR_FILIAL + CR_TIPO + CR_NUM) ==  xFilial('SCR') + 'LC' + PadR(cNum,TamSX3('CR_NUM')[1])
				If Empty(SCR->CR_DATALIB) //Verifica se falta alguma pessoa aprovar o lançamento
					lAprov := .F.
				EndIf
				RecLock('SCR',.F.)
				SCR->(dbDelete())
				SCR->(MsUnLock())
				SCR->(dbSkip())
			EndDo
			If !lAprov //Retornar o saldo apenas quando a Alçada estiver para ser aprovada
				U_xMC26Som(xFilial('SCR'),cUser,nValSCR)
			EndIf
		EndIf

		If Select(cNextAlias) > 0
			(cNextAlias)->(DbClosearea())
		Endif

		//Separa Itens para criação da Grade de aprovação
		If !lExclusao
			BeginSql Alias cNextAlias
	
				SELECT
					ZAD_SEQ,
					ZAD_NIVEL,
					ZA2_CODUSU
				FROM %Table:ZAD% ZAD
				INNER JOIN %Table:ZA2% ZA2
					ON ZA2_FILIAL = ZAD_FILIAL AND
						ZA2_NIVEL =  ZAD_NIVEL  AND
						ZA2_EMPFIL = %xFilial:CT2%
				WHERE
					ZAD.%NotDel% AND
					ZA2.%NotDel% AND
					ZA2.ZA2_LOGIN <> ' ' AND
					ZAD_FILIAL = %xFilial:ZAD% AND
					ZAD_CODIGO = %Exp:cCodigo% AND
					ZAD_VERSAO = %Exp:cVersao% AND
					ZAD_EMPFIL = %Exp:cEmpFil% AND
					ZAD_CDUSER = %Exp:cUser%
				ORDER BY ZAD_SEQ
	
			EndSql
			
			While (cNextAlias)->(!EOF())
	
				RecLock('SCR',.T.)
	
				SCR->CR_FILIAL 	:= xFilial('SCR')
				SCR->CR_NUM 	:= cNum
				SCR->CR_TIPO 	:= 'LC'
				SCR->CR_USER 	:= (cNextAlias)->ZA2_CODUSU
				SCR->CR_ITGRP 	:= (cNextAlias)->ZAD_SEQ
				SCR->CR_NIVEL 	:= (cNextAlias)->ZAD_SEQ
				SCR->CR_STATUS 	:= IIF(nIt == 1,'02','01')
				SCR->CR_EMISSAO	:= dDataBase
				SCR->CR_ZCODGRD := cCodigo
				SCR->CR_ZVERSAO := cVersao
				SCR->CR_ZNIVEL  := (cNextAlias)->ZAD_NIVEL
				SCR->CR_OBS		:= cObs
				SCR->CR_TOTAL	:= nValTot
	
				SCR->(MsUnlock())
				nIt ++
	
				(cNextAlias)->(dbSkip())
			EndDo
			(cNextAlias)->(DbClosearea())

			dbSelectArea("CT2")
			CT2->(dbSetOrder(1))//CT2_FILIAL+DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_LINHA+CT2_TPSALD+CT2_EMPORI+CT2_FILORI+CT2_MOEDLC
			If CT2->(DbSeek(xFilial("CT2") + Alltrim(cNum)))
				While CT2->(!EOF()) .and. CT2->CT2_FILIAL + DTOS(CT2->CT2_DATA) + CT2->CT2_LOTE + CT2->CT2_SBLOTE + CT2->CT2_DOC = cEmpFil + cNum
					RecLock('CT2',.F.)		
						CT2->CT2_ZCODGR := cCodigo 
						CT2->CT2_ZVERSA := cVersao
						CT2->CT2_ZCDUSE := cUser
						CT2->CT2_TPSALD	 := "2"
						CT2->CT2_ZAPRO  := "B"
					CT2->(MsUnlock())
					CT2->(dbSkip())
				EndDo
			EndIf
			
			U_xMC26Sub(xFilial('SCR'),cUser,nValTot)
		EndIf

	EndIf
	
	RestArea(aAreaCT2)
	RestArea(aArea)
	
Return( .T. )

/*
	Calcula Valor total do Lançamento
*/
Static Function xValLanc(xcFil,cNum)

	Local aArea 	:= GetArea()
	Local aAreaCT2	:= CT2->(GetArea())
	Local nRet 		:= 0

	dbSelectArea("CT2")
	CT2->(dbSetOrder(1))//CT2_FILIAL+DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_LINHA+CT2_TPSALD+CT2_EMPORI+CT2_FILORI+CT2_MOEDLC
	
	If CT2->(dbSeek(xcFil + cNum))
		While CT2->(!EOF()) .and. CT2->(CT2_FILIAL + DTOS(CT2_DATA) + CT2_LOTE + CT2_SBLOTE + CT2_DOC) == (xcFil + cNum)
			//Somar apenas em Partida dobrada e debito
			If CT2->CT2_DC $ '1|3' //1=Debito;2=Credito;3=Partida Dobrada;4=Cont.Hist;5=Rateio;6=Lcto Padrao
				nRet += CT2->CT2_VALOR
			EndIf
			CT2->(dbSkip())
		EndDo
	EndIf
	
	RestArea(aAreaCT2)
	RestArea(aArea)

Return nRet


/*/{Protheus.doc} CTB25Ext
Verifica o lançamento irá para a grade ou é uma exceção.

@author Natanael Filho
@since 20/10/2019
@version 1.0 

@return Logico
/*/

User Function xCTB25Ext()

	Local _lRet			:= .F.
	Local cUser			:= Alltrim(RetCodUsr())
	Local cUsDireto		:= SuperGetMV("MGF_CTB25A",.F.,"000000") //Usuarios contidos no parametro MGF_CTB25A não passam por aprovação.
	Local cEmpDireto	:= SuperGetMV("MGF_CTB25B",.F.,"02/") //Grupo de empresas que não passaram pela grade de aprovação.
	

	If (cUser $ cUsDireto .OR. cEmpAnt $ cEmpDireto)  //Verifica se usuario ou Grupo de empresa passa direto

		_lRet := .T.	

	EndIf

Return _lRet

