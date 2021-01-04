#include "protheus.ch"

/*
===========================================================================================
Programa.:              MGFEST31
Autor....:              Mauricio Gresele
Data.....:              Junho/2017
Descricao / Objetivo:   Rotina para alterar a data de digitacao da NFE na classificacao do documento.
Doc. Origem:            
Solicitante:            Cliente
Uso......:              
Obs......:               
===========================================================================================
*/
User Function MGFEST31()

Local cQ := ""
Local nRet := 0
Local lContinua := .T.

If l103Class // esta na classificacao da nfe
	If SF1->F1_DTDIGIT != dDataBase // altera a data de digitacao para ficar igual a database
	   	cQ := "UPDATE "
		cQ += RetSqlName("SF1")+" "
		cQ += "SET F1_DTDIGIT = '"+dTos(dDataBase)+"', F1_RECBMTO = '"+dTos(dDataBase)+"' "
		cQ += "WHERE D_E_L_E_T_ = ' ' "
		cQ += "AND F1_FILIAL = '"+xFilial("SF1")+"' "
		cQ += "AND F1_DOC = '"+cNFiscal+"' "
		cQ += "AND F1_SERIE = '"+cSerie+"' "		
		cQ += "AND F1_FORNECE = '"+cA100For+"' "
		cQ += "AND F1_LOJA = '"+cLoja+"' "
	
		nRet := tcSqlExec(cQ)
		If nRet == 0
			If "ORACLE" $ tcGetDB()
				tcSqlExec( "COMMIT" )
			EndIf
		Else
			lContinua := .F.
			APMsgStop("Problemas na gravacao da Data de Digita��o no Documento.")
		EndIf

		If lContinua
		   	cQ := "UPDATE "
			cQ += RetSqlName("SD1")+" "
			cQ += "SET D1_DTDIGIT = '"+dTos(dDataBase)+"' "
			cQ += "WHERE D_E_L_E_T_ = ' ' "
			cQ += "AND D1_FILIAL = '"+xFilial("SD1")+"' "
			cQ += "AND D1_DOC = '"+cNFiscal+"' "
			cQ += "AND D1_SERIE = '"+cSerie+"' "		
			cQ += "AND D1_FORNECE = '"+cA100For+"' "
			cQ += "AND D1_LOJA = '"+cLoja+"' "
		
			nRet := tcSqlExec(cQ)
			If nRet == 0
				If "ORACLE" $ tcGetDB()
					tcSqlExec( "COMMIT" )
				EndIf
			Else
				lContinua := .F.
				APMsgStop("Problemas na gravacao da Data de Digita��o no Documento.")
			EndIf
		Endif
	Endif
Endif			

Return(lContinua) 