/*
=========================================================================================================
Programa.................: OMSM0113
Autor:...................: Flavio Dentello
Data.....................: 06/09/2016
Descricao / Objetivo.....: Integrar o peso dos itens das Notas fiscais para os documento de carga do GFE.
Doc. Origem..............: GAP - GFE03
Solicitante..............: Cliente
Uso......................: 
Obs......................: Ponto de entrada executado no momento da integracao com o SIGAGFE.
=========================================================================================================
*/

#include "Protheus.ch"


user Function OMSM0113()
Local oModelGW8 := PARAMIXB[1]
Local cCodPro   := ""
Local nPesor    := 0
Local cAlias1	:= ""
Local cAlias2   := ""
Local cAliasSD2 := "SD2"
Local cAliasDAI := "DAI"
Local cPedido := SD2->D2_PEDIDO


    // Verifica se o item da nota possui peso informado
//	If SD2->D2_PESO > 0

	//	nPesor := SD2->D2_PESO * SD2->D2_QUANT

		//oModelGW8:SetValue("GW8_PESOR", nPesor)

	//Else

	cAlias1	:= GetNextAlias()

	cQuery		:= " SELECT COUNT(D2_PESO)QTDE "

	cQuery		+= " FROM " + RetSqlName(cAliasSD2) + " " + cAliasSD2 + ", " + RetSqlName(cAliasDAI) + " " + cAliasDAI

	cQuery		+= " WHERE D2_PEDIDO = DAI_PEDIDO "
	cQuery		+= " AND D2_PEDIDO = '" + cPedido + "' "
	cQuery		+= " AND D2_FILIAL = '" + xFilial("SD2") + "' "
	cQuery		+= " AND DAI_FILIAL = '" + xFilial("DAI") + "' "
	cQuery		+= " AND SD2.D_E_L_E_T_<>'*'"
	cQuery		+= " AND DAI.D_E_L_E_T_<>'*'"

	dbUseArea(.T. , "TOPCONN" , TcGenQry(NIL , NIL , cQuery) , cAlias1 , .F. , .T.)

	cAlias2	:= GetNextAlias()

	cQuery		:= " SELECT DISTINCT DAI_PESO "

	cQuery		+= " FROM " + RetSqlName(cAliasSD2) + " " + cAliasSD2 + ", " + RetSqlName(cAliasDAI) + " " + cAliasDAI

	cQuery		+= " WHERE D2_PEDIDO = DAI_PEDIDO "
	cQuery		+= " AND D2_PEDIDO = '" + cPedido + "' "
	cQuery		+= " AND D2_FILIAL = '" + xFilial("SD2") + "' "
	cQuery		+= " AND DAI_FILIAL = '" + xFilial("DAI") + "' "
	cQuery		+= " AND SD2.D_E_L_E_T_<>'*'"
	cQuery		+= " AND DAI.D_E_L_E_T_<>'*'"

	dbUseArea(.T. , "TOPCONN" , TcGenQry(NIL , NIL , cQuery) , cAlias2 , .F. , .T.)

	If (cAlias2)->DAI_PESO > 0 .AND. (cAlias1)->QTDE > 0

		nPesor := (cAlias2)->DAI_PESO / (cAlias1)->QTDE
		oModelGW8:SetValue("GW8_PESOR", nPesor)

	// Se nao houver peso na Carga sera considerado o peso bruto do pedido
	Else

		DbSelectArea('SC5')
		DbSetOrder(1)
		If SC5->(MsSeek(xFilial('SC5')+cPedido))

			If SC5->C5_PBRUTO > 0

					cAlias3	:= GetNextAlias()

					cQuery		:= " SELECT COUNT(D2_PESO) QTDE "
					cQuery		+= " FROM " + RetSqlName(cAliasSD2) + " " + cAliasSD2
					//cQuery		+= " WHERE D2_PEDIDO = DAI_PEDIDO "
					cQuery		+= " WHERE D2_PEDIDO = '" + cPedido + "' "
					cQuery		+= " AND D2_FILIAL = '" + xFilial("SD2") + "' "
					cQuery		+= " AND SD2.D_E_L_E_T_<>'*'"

					dbUseArea(.T. , "TOPCONN" , TcGenQry(NIL , NIL , cQuery) , cAlias3 , .F. , .T.)

					If (cAlias3)->QTDE > 0

					nPesor :=  SC5->C5_PBRUTO / (cAlias3)->QTDE
					oModelGW8:SetValue("GW8_PESOR", nPesor)

					EndIf

				(cAlias3)->(dbCloseArea())

			EndIf
		EndIf

	EndIf

	(cAlias1)->(dbCloseArea())
	(cAlias2)->(dbCloseArea())

    //EndIf

Return .T.