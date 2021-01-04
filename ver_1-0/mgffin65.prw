#Include 'Protheus.ch'

/*
=====================================================================================
Programa............: MGFFIN65
Autor...............: Barbieri
Data................: 09/10/2017
Descricao / Objetivo: Realizar liberacoes automaticas de pedidos de venda Grandes Redes
Doc. Origem.........: Contrato - GAP CRE019 FASE 4
Solicitante.........: Cliente
Uso.................: 
Obs.................:
=====================================================================================
*/
User Function MGFFIN65()

	Local cTxtRede  := "Deseja aplicar a alteracao de GRANDES REDES para todos os clientes da Rede?"
	Local aArea		:= GetArea()
	Local aAreaSA1  := SA1->(GetArea())
	Local nStatusUpd
	Local cUPD      := ""
	Local cA1GrRede := ""
	Local cA1Rede   := ""

	If Altera
		If M->A1_ZGDERED <> SA1->A1_ZGDERED
			If !Empty(SA1->A1_ZREDE)
				cA1Rede   := SA1->A1_ZREDE
				cA1GrRede := M->A1_ZGDERED

				if funName() <> "MGFWSS11"
					If MSGYESNO(cTxtRede,"Atencao")
						cUPD := "UPDATE "+RetSQLName("SA1")+" SET A1_ZGDERED = '"+cA1GrRede+"' "
						cUPD += "WHERE A1_ZREDE = '"+cA1Rede+"' "
						cUPD += "AND D_E_L_E_T_ = ' ' "
						nStatusUpd := TCSqlExec(cUPD)
						If (nStatusUpd < 0)
							conout("TCSQLError() GRANDES REDES: " + TCSQLError())
						Endif
					Endif
				else
					// implementar
					conout( "AAAAAAAAAAAA" )
				Endif
			EndIf
		EndIf
	Endif

	RestArea(aAreaSA1)
	RestArea(aArea)

Return
