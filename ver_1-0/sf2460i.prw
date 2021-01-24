#INCLUDE "Protheus.ch"
/*
=====================================================================================
Programa.:              SF2460I
Autor....:              Roberto Sidney
Data.....:              24/10/2016
Descricao / Objetivo:   Ponto de entrada da rotina de faturamento para chamada da função responsável pela medição
Doc. Origem:            VEN03 - GAP MGFVEN03
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Chamada efetuada através do ponto de entrada A410CONS()
=====================================================================================
*/
User Function SF2460I()
	Local aAreaBKP := GetArea()
	Local aItensMed := {}
	Private _cChaveSE1 := ''

	If ! ( IsInCallStack("EECAF200") .OR. IsInCallStack("EECAC100") .OR. IsInCallStack("EECAP100") )  // Baixa automatica e Adiantamentos do EEC nao deve considerar

		If findfunction("u_xItensMed")
			// Monta array com itens para medição
			aItensMed := u_xItensMed()
		Endif
		If findfunction("U_MGFGCT06")
			// Efetua chamada da rotina automática de medições
			MsgRun("Aguarde, gerando Medição...","Medição",{|| U_MGFGCT06(aItensMed,_cChaveSE1)}) //SIGAGCT - Aguarde, processsando Medição...
		endif
		If findfunction("u_mgffat39")
			// Grava campos PesoLiquido e Peso Bruto
			u_mgffat39()
		Endif
		If findfunction("u_MGFGFE21")
			// Dados da Nota Fiscal na tabela ZDL
			u_MGFGFE21()
		Endif
		If findfunction("u_MGFFATBD")
			// Corrigi data da emissão F2_EMISSAO conforme virada de horário e parâmetro MV_HORARMT
			u_MGFFATBD()
		Endif

		//GRAVA PEDIDO NO CNE - MEDICAO
		cUpdCNE := " UPDATE " + retSQLName("CNE") + " SET CNE_PEDIDO = '"+SC5->C5_NUM+"' WHERE CNE_FILIAL='"+xFilial("CNE")+"' "
		cUpdCNE += " AND CNE_NUMMED = '" + CND->CND_NUMMED + "' AND CNE_PEDIDO=' ' "

		nRet := tcSqlExec(cUpdCNE)
		//
		RestArea(aAreaBKP)
	Endif

Return()

/*
=====================================================================================
Programa.:              ItensMed
Autor....:              Roberto Sidney
Data.....:              21/09/2016
Descricao / Objetivo:   Monta array com itens para medição de acordo com a nota
Doc. Origem:            VEN03 - GAP MGFVEN03
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Chamada efetuada através do ponto de entrada A410CONS()
=====================================================================================
*/
User Function xItensMed()
	Local aItens :={}
	Local aItensNEW := {}
	Local aItemCN120 :={}
	Local _cChaveSF2 := ''

	DbSelectArea("SF2")
	_cChaveSF2 := SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA


	_nITSD2 := 1

	DbSelectArea("SD2")
	DbSetOrder(3)
	IF SD2->(DbSeek(xFilial("SD2")+_cChaveSF2))
		While ! SD2->(EOF()) .AND. SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA =  _cChaveSF2
			_cItem := strzero(_nITSD2,3)

			aAdd(aItemCN120,{})
			aAdd(aItemCN120[Len(aItemCN120)],{"CNE_ITEM"  ,_cItem,NIL		 })
			aAdd(aItemCN120[Len(aItemCN120)],{"CNE_PRODUT",SD2->D2_COD,NIL	 })
			aAdd(aItemCN120[Len(aItemCN120)],{"CNE_QUANT" ,SD2->D2_QUANT,NIL })
			aAdd(aItemCN120[Len(aItemCN120)],{"CNE_VLUNIT",SD2->D2_PRCVEN,NIL})
			aAdd(aItemCN120[Len(aItemCN120)],{"CNE_VLTOT" ,SD2->D2_TOTAL,NIL })
			aAdd(aItemCN120[Len(aItemCN120)],{"CNE_DTENT" ,DDATABASE,NIL	 })
			aAdd(aItemCN120[Len(aItemCN120)],{"CNE_TS"    ,SD2->D2_TES,NIL	 })
			aAdd(aItemCN120[Len(aItemCN120)],{"CNE_PEDIDO",SD2->D2_PEDIDO ,NIL	 })

			_nITSD2 ++

			SD2->(DbSkip())

		Enddo
	Endif

Return(aItemCN120)
