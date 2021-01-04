#include "protheus.ch"
#include "tbiconn.ch"
/*
=====================================================================================
Programa.:              MGFGCT009
Autor....:              Roberto Sidney
Data.....:              28/10/2016
Descricao / Objetivo:   Busca pelo contrato de acordo com a condicao de pagamento, atualiza campos no pedido de venda
Doc. Origem:            VEN02 - GAP MGFVEN02
Solicitante:            Cliente
Uso......:              
Obs......:              Chamada efetuada atraves do ponto de entrada A410INC()
=====================================================================================
*/
User Function MGFGCT09(_cCliente,_cLoja,_cCondPag,lExecAuto)
	
	Local _cContrato := ''
	Local _cContra   := ''
	Local _cRevis    := ''
	Local _cPlan     := ''
	
	Local _xcFil	 := GetMV('MGF_CT09FI',.F.,"010001")		
	
	// efetua a busca apenas para pedido que nao possuam numero do contrato informado
	If FunName() == "EECFATCP" // cModulo == "EEC"
		Return(.T.)
	EndIf

	_cContrato:= IIF(lExecAuto,alltrim(SC5->C5_ZMDCTR),alltrim(M->C5_ZMDCTR))

	if Empty(alltrim(_cContrato))

		//������������������������������������������Ŀ
		//� Filtra parcelas de contratos automaticos �
		//� pendentes para a data atual              �
		//��������������������������������������������
		cArqTrb	:= CriaTrab( nil, .F. )
		cQuery := "SELECT CN9.CN9_FILIAL,CN9.CN9_NUMERO,CN9.CN9_REVISA,CN9.CN9_CONDPG,CNA.CNA_NUMERO," + CRLF
		cQuery += "CNA.CNA_CLIENT,CNA.CNA_LOJACL " + CRLF
		cQuery += "FROM " + RetSQLName("CN9") + " CN9 " + CRLF
		cQuery += "LEFT JOIN " + RetSQLName("CNA") + " CNA ON CNA.CNA_FILIAL = '" + xFilial("CNA",_xcFil) + "' AND " + CRLF
		cQuery += "CNA.CNA_CONTRA = CN9.CN9_NUMERO AND CNA.CNA_REVISA = CN9.CN9_REVISA AND CNA.D_E_L_E_T_ = ' ' " + CRLF
		cQuery += "WHERE  CN9.CN9_FILIAL = '" + xFilial("CN9",_xcFil) + "' AND " + CRLF
		cQuery += "CN9.CN9_CONDPG = '" + _cCondPag + "' AND " + CRLF
		cQuery += "CNA.CNA_CLIENT = '" + _cCliente + "' AND " + CRLF
		cQuery += "CNA.CNA_LOJACL = '" + _cLoja + "' AND " + CRLF
		cQuery += "CN9.CN9_SITUAC = '05'"

		cQuery := ChangeQuery( cQuery )
		
		memoWrite( "C:\TEMP\MGFGCT09_1.sql", cQuery )
		
		dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), cArqTrb, .T., .T. )
		DbSelectArea(cArqTrb)
		If (cArqTrb)->(Eof())
			IF !lExecAuto
				msgalert("Nao � possivel localizar o contratos para o condicao de pagamento "+alltrim(_cCondPag))
				M->C5_ZMDCTR :=''
				M->C5_ZREVIS :=''
				M->C5_ZMDPLAN:=''
			Else
				Conout("Nao � possivel localizar o contratos para o condicao de pagamento "+alltrim(_cCondPag))
			Endif
			Return(.F.)
		Else
			// Temporariamente nao haver� a validacao da quantidades de contrato por Condicao de Pagamento
			_nCont := 0
			While ! (cArqTrb)->(eof())
				_nCont ++
				(cArqTrb)->(DbSkip())
			Enddo
			if _nCont > 1
				IF !lExecAuto
					msgalert("Forma localizados("+alltrim(str(_nCont))+ ") contratos para a condicao de pagamento "+alltrim(_cCondPag))
					M->C5_ZMDCTR :=''
					M->C5_ZREVIS :=''
					M->C5_ZMDPLAN:=''
				Else
					msgalert("Forma localizados("+alltrim(str(_nCont))+ ")contratos para a condicao de pagamento "+alltrim(_cCondPag))
				Endif
				Return(.F.)
			Endif

		EndIf

		(cArqTrb)->(DbGotop())

		_cAreaSC5 := GetArea("SC5")
		_cContra  := (cArqTrb)->CN9_NUMERO
		_cRevis   := (cArqTrb)->CN9_REVISA
		_cPlan	  := (cArqTrb)->CNA_NUMERO

		IF lExecAuto
			Reclock("SC5",.F.)
			SC5->C5_ZMDCTR  := _cContra
			SC5->C5_ZREVIS  := _cRevis
			SC5->C5_ZMDPLAN := _cPlan
			SC5->(MsUnlock())
		Else
			M->C5_ZMDCTR  := _cContra
			M->C5_ZREVIS  := _cRevis
			M->C5_ZMDPLAN := _cPlan
		Endif

		RestArea(_cAreaSC5)
		(cArqTrb)->(dbCloseArea())

	Endif

Return(.T.)
