#include "protheus.ch"

/*
=====================================================================================
Programa............: MGFFAT48
Autor...............: Mauricio Gresele
Data................: Set/2017
Descricao / Objetivo: Rotina chamada pelo ponto de entrada MS520VLD
Doc. Origem.........: Protheus
Solicitante.........: Cliente
Uso.................: 
Obs.................: 
=====================================================================================
*/
User Function MGFFAT48()

Local lRet := .T.
Local cQ := ""
Local cAliasTrb := GetNextAlias()

// se nota estiver relacionada a uma carga, obriga parametro para retornar o pedido para carteira, para que o sistema retire o pedido da carga,
// pois se o parametro estiver como 'apto a faturar', o sistema mantem o pedido na carga e a marfrig quer que o pedido seja retirado da carga no caso
// da exclusao da nota.
If !Empty(SF2->F2_CARGA)
	//If SF2->F2_ZTAUINT == "S" .and. SF2->F2_ZTAUFLA == "1" .and. mv_par04 == 2 // nota transmitida ao taura e parametro F1 apto a faturar
	// verifica se carga integra com o taura
	cQ := "SELECT 1 "
	cQ += "FROM "+RetSqlName("DAI")+" DAI, "+RetSqlName("SC5")+" SC5, "+RetSqlName("SZJ")+" SZJ "
	cQ += "WHERE DAI.D_E_L_E_T_ = ' ' "
	cQ += "AND SC5.D_E_L_E_T_ =	' ' "
	cQ += "AND SZJ.D_E_L_E_T_ =	' ' "
	cQ += "AND DAI_FILIAL = '"+SF2->F2_FILIAL+"' "
	cQ += "AND DAI_FILIAL = C5_FILIAL "
	cQ += "AND ZJ_FILIAL = '"+xFilial("SZJ")+"' "
	cQ += "AND DAI_PEDIDO = C5_NUM "
	cQ += "AND C5_ZTIPPED = ZJ_COD "
	cQ += "AND ZJ_TAURA = 'S' "
	cQ += "AND DAI_SERIE = '"+SF2->F2_SERIE+"' "
	cQ += "AND DAI_NFISCA = '"+SF2->F2_DOC+"' "

	cQ := ChangeQuery(cQ)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),cAliasTrb,.T.,.F.)

	If (cAliasTrb)->(!Eof())
		If mv_par04 == 2 // parametro F1 apto a faturar
			lRet := .F.
			APMsgStop("Para notas fiscais geradas a partir de montagem de Carga e j� transmitidas ao Taura, o parametro 'Retornar Ped.Venda ?' deve estar como 'Carteira', para que o Pedido de Venda seja retirado da Carga."+CRLF+;
			"Acesse os parametros da rotina, via tecla F12 e mude este parametro."+CRLF+;
			"Carga: "+SF2->F2_CARGA+CRLF+;
			"Nota Fiscal: "+SF2->F2_DOC+", serie: "+SF2->F2_SERIE)
		Endif		
		/*
		If Empty(SF2->F2_ZTAUINT) .and. SF2->F2_ZTAUFLA != "1" .and. mv_par04 == 1 // nota nao transmitida ao taura e parametro F1 em carteira
			lRet := .F.
			APMsgStop("Para notas fiscais geradas a partir de montagem de Carga e ainda nao transmitidas ao Taura, o parametro 'Retornar Ped.Venda ?' deve estar como 'Apto a Faturar', para que o Pedido de Venda nao seja retirado da Carga."+CRLF+;
			"Acesse os parametros da rotina, via tecla F12 e mude este parametro."+CRLF+;
			"Carga: "+SF2->F2_CARGA+CRLF+;
			"Nota Fiscal: "+SF2->F2_DOC+", serie: "+SF2->F2_SERIE)
		Endif		
		*/
	Endif
	
	(cAliasTrb)->(dbCloseArea())	
Endif
	
Return(lRet)