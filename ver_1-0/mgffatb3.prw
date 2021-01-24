#Include "totvs.ch"
#Include "TopConn.ch"

/*
================================================================================================
Programa............: MGFFATB3
Autor...............: Bruno Tamanaka
Data................: 17/05/2019
Descrição / Objetivo: Alimentar o campo virtual no cadastro de clientes
Doc. Origem.........: RITM0022075
Solicitante.........: Joel Ribeiro
Uso.................: Marfrig
Obs.................: Campo da SA1 para exibir o valor somado das compras dos ultimos 180 dias.
================================================================================================
*/

User Function MGFFATB3(cCli,cLoja,lMgfFinBn)

	Local nRet 		:= 0
	Local cQuery
	Local dData		:= Date()

	Local lLoja		:= SuperGetMV("MGF_FATB3A",.T.,.F.) //Considera a loja nos filtros?
	Local cNatNCC	:= Alltrim(SuperGetMV("MGF_FATB3B",.T.,"10107")) //Natureza utilizada para filtro das NCCs. Deixar em branco para considerar todas.
	Local ntPDesc	:= SuperGetMV("MGF_FATB3C",.T.,1) //Qual o tipo de desconto deve ser ralizado: 0-NENHUM;1-E1_VALOR;2-E1_SALDO
	local bCond     := iif( IsBlind(), { || .not. Empty(cCli) }, { || .not. Empty(cCli) .and. ( .not. INCLUI .or. lMgfFinBn ) } )


	DEFAULT lMgfFinBn := .F.

//	If !Empty(cCli) .AND. ( !INCLUI .OR. lMgfFinBn )
	If eval( bCond )

		cDataDe := DTOS(DaySub( dData , 180 )) //Subtrai dias em uma data e converte para string
		cDataAt := DTOS(dData)

		//Query para somar valor dos últimos 180 dias faturados para o cliente
		cQuery	:=	"SELECT SUM(F2_VALFAT) AS F2VL " 						+CRLF
		cQuery	+=	"FROM " + RetSqlName("SF2") + " SF2 "					+CRLF
		cQuery	+=	"WHERE SF2.D_E_L_E_T_ = ' ' "							+CRLF
		cQuery	+=	"AND SF2.F2_TIPO = 'N' "								+CRLF
		cQuery	+=	"AND SF2.F2_ESPECIE = 'SPED' "							+CRLF
		cQuery	+=	"AND SF2.F2_CHVNFE <> ' ' "								+CRLF
		cQuery	+=	"AND SF2.F2_CLIENT = '" + cCli + "' "					+CRLF

		if lLoja .AND. !EMPTY(cLoja) //Considera loja?
			cQuery	+=	"AND SF2.F2_LOJA  = '" + cLoja + "' "			    +CRLF
		EndIf

		cQuery	+=	"AND SF2.F2_EMISSAO BETWEEN '" + cDataDe + "' AND '" + cDataAt + "' " +CRLF

		TcQuery cQuery New Alias "ZSF2"
		DbSelectArea("ZSF2")
		ZSF2->(DbGoTop())

		//cRet recebe a soma do valor encontrado
		nRet	:= ZSF2->F2VL

		ZSF2->(DbClosearea())

		If ntPDesc <> 0

			//Query para somar o saldo das NCCs do cliente dos ultimos 180 dias.
			cQuery	:= "SELECT SUM(" + IIf(ntPDesc=1,"E1_VALOR","E1_SALDO") + ") AS E1VL "	+CRLF
			cQuery	+= "FROM " + RetSqlName("SE1") + " SE1 "								+CRLF
			cQuery	+= "WHERE SE1.D_E_L_E_T_ = ' ' "										+CRLF
			cQuery	+= "AND SE1.E1_CLIENTE = '" + cCli + "' "								+CRLF

			if lLoja .AND. !EMPTY(cLoja) //Considera loja?
				cQuery	+=	"AND SE1.E1_LOJA  = '" + cLoja + "' "			    			+CRLF
			EndIf
			cQuery	+= "AND SE1.E1_TIPO = 'NCC' "											+CRLF

			//Natureza utilizada para filtro das NCCs. Deixar em branco para considerar todas.
			If !EMPTY(cNatNCC)
				cQuery	+= "AND SE1.E1_NATUREZ = '" + cNatNCC + "' "						+CRLF
			EndIf

			cQuery 	+= "AND SE1.E1_EMISSAO BETWEEN '" + cDataDe + "' AND '"  + cDataAt + "' " +CRLF

			TcQuery cQuery New Alias "ZSE1"
			DbSelectArea("ZSE1")

			//Subtrai o valor das NCCS
			nRet	-= ZSE1->E1VL

			ZSE1->(DbClosearea())

		EndIf


	EndIf

	Return nRet
