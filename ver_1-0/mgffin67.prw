#Include 'Protheus.ch'

/*
=====================================================================================
Programa............: MGFFIN67
Autor...............: Barbieri
Data................: 10/10/2017
Descricao / Objetivo: Nao gerar boletos e bordero para clientes espec�ficos
Doc. Origem.........: Contrato - GAP CRE020 FASE 4
Solicitante.........: Cliente
Uso.................: 
Obs.................:
=====================================================================================
*/
User Function MGFFIN67()

	Local cTxtRede  := "Deseja aplicar a alteracao de GERAR BOLETO para todos os clientes da Rede"
	Local aArea		:= GetArea()
	Local aAreaSA1  := SA1->(GetArea())
	Local nStatusUpd
	Local cUPD      := ""
	Local cA1Boleto := ""
	Local cA1Rede   := ""

	If Altera
		If M->A1_ZBOLETO <> SA1->A1_ZBOLETO
			If !Empty(SA1->A1_ZREDE)
				cA1Rede   := SA1->A1_ZREDE
				cA1Boleto := M->A1_ZBOLETO

				if funName() <> "MGFWSS11"
					If MSGYESNO(cTxtRede,"Atencao")
						cUPD := "UPDATE "+RetSQLName("SA1")+" SET A1_ZBOLETO = '"+cA1Boleto+"' "
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
				endif
			EndIf
		EndIf
	Endif

	RestArea(aAreaSA1)
	RestArea(aArea)

Return
