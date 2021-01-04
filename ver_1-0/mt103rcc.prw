#Include 'Protheus.ch'

/*
=====================================================================================
Programa............: MT103RCC
Autor...............: Joni Lima
Data................: 06/11/2016
Descrição / Objetivo: LOCALIZAÇÃO : Function NFePC2Acol() - Esta rotina atualiza o acols com base no item do pedido de compra 
					  EM QUE PONTO : Ponto de entrada para alimentação do array de rateio por centro de custo através do pedido de compra ou item do pedido de compra.
Doc. Origem.........: Contrato - GAP CTB01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: http://tdn.totvs.com/pages/releaseview.action;jsessionid=64BBB10EF75182546920620CFB7C8164?pageId=6085420
=====================================================================================
*/
User Function MT103RCC()

	Local aHeadSDE	 := PARAMIXB[1]
	Local aColsSDE	 := PARAMIXB[2]
	
	If Findfunction('U_xMF103RCC')
		If Empty(aHeadSDE)
			SX3->(dbSetOrder(1))
			SX3->(DbSeek("SDE"))
			While SX3->(!EOF()) .And. SX3->X3_ARQUIVO == "SDE"
				IF X3Uso(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL .And. !"DE_CUSTO" $ SX3->X3_CAMPO
					AADD(aHeadSDE,{TRIM(x3Titulo()),;
						SX3->X3_CAMPO,;
						SX3->X3_PICTURE,;
						SX3->X3_TAMANHO,;
						SX3->X3_DECIMAL,;
						SX3->X3_VALID,;
						SX3->X3_USADO,;
						SX3->X3_TIPO,;
						SX3->X3_F3,;
						SX3->X3_CONTEXT } )
				EndIf
				SX3->(dbSkip())
			EndDo
			//Adiciona os campos de Alias e Recno ao aHeader para WalkThru
			ADHeadRec("SDE",aHeadSDE)	
		Endif
		aColsSDE := U_xMF103RCC(aHeadSDE,aColsSDE)
	EndIf
	
Return aColsSDE

