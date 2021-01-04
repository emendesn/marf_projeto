#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"

/*
=====================================================================================
Programa.:              MGFTPF
Autor....:              Barbieri
Data.....:              12/06/2017
Descricao / Objetivo:   Trazer tipo do fornecedor
Doc. Origem:            CNAB MARFRIG
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
User Function MGFTPF(cTp)

	Local cRet		:= ""
	Local cTipo		:= ""

	If cTp == '1'
		cTipo:=GetAdvFval("SA2","A2_TIPO",xFilial("SA2")+M->(ZA_CODFORN+ZA_LOJFORN),1)
		cRet:=PicPes(cTipo)
	Endif

	If cTp == '2'
		If !Empty(SE2->E2_ZCODFAV)
			cRet:=IIF(GetAdvFval("SA2","A2_TIPO",xFilial("SA2")+SE2->E2_ZCODFAV+SE2->E2_ZLOJFAV,1)=="J","2","1")
		Else
			cRet:=IIF(GetAdvFval("SA2","A2_TIPO",xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA,1)=="J","2","1")
		Endif
	Endif

	If cTp == '3'
		cTipo:=GetAdvFval("SA2","A2_TIPO",xFilial("SA2")+M->(E2_ZCODFAV+E2_ZLOJFAV),1)
		cRet:=PicPes(cTipo)
	Endif

	If cTp == '4'
		cRet:=STRZERO(VAL(IIF(!EMPTY(SE2->E2_ZCGCFAV),SE2->E2_ZCGCFAV,GETADVFVAL("SA2","A2_CGC",XFILIAL("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA,1))),14)
	Endif

Return cRet

/*
=====================================================================================
Programa.:              MGFBARCP
Autor....:              Barbieri
Data.....:              25/04/2018
Descricao / Objetivo:   Comparar codigo barras E2_SALDO com E2_LINDIG (10 ultimas posições)
Doc. Origem:            CNAB MARFRIG
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
User Function MGFBARCP(cVl)

	Local cValTit 	 := StrZero((SE2->E2_SALDO)*100,10)
	Local cValCodBar := Right(AllTrim(SE2->E2_LINDIG),10)
	Local cValOK  	 := ""
	Local nValComp   := 0

	If cVl == "1" // Valor E2_SALDO x E2_LINDIG
		If cValCodBar == cValTit
			cValOK    := IIf((SE2->E2_ZCONTRA == "1" .OR. SE2->E2_ZCONTRA == ' '),StrZero((SE2->E2_SALDO)*100, 15),REPLICATE("0",15))
		Else
			nValComp := xSaldComp(SE2->E2_FILIAL,SE2->E2_TIPO,SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_FORNECE,SE2->E2_LOJA)
			cValOK    := IIf((SE2->E2_ZCONTRA == "1" .OR. SE2->E2_ZCONTRA == ' '),StrZero((SE2->(E2_SALDO+E2_SDACRES-E2_SDDECRE)+nValComp)*100, 15),REPLICATE("0",15))
		Endif
	Endif
	If cVl =="2" // Valor E2_SALDO x E2_SDDECRE
		nValComp := xSaldComp(SE2->E2_FILIAL,SE2->E2_TIPO,SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_FORNECE,SE2->E2_LOJA)

		If cValCodBar != cValTit .and. empty(nValComp)
			cValOK := REPLICATE("0",15)
		Else
			cValOK := IIF(!EMPTY(SE2->E2_XDESCO),STRZERO((SE2->E2_XDESCO*100),15),IIF(!EMPTY((SE2->E2_SDDECRE + nValComp)),STRZERO(((SE2->E2_SDDECRE + nValComp)*100),15),REPLICATE("0",15)))
		Endif
	Endif
	If cVl =="3" // Valor E2_SALDO x E2_SDACRES
		If cValCodBar != cValTit
			cValOK := REPLICATE("0",15)
		Else
			cValOK := IIF(SE2->(E2_XJUROS+E2_XMULTA+E2_SDACRES)==0,REPLICATE("0",15),STRZERO((SE2->(E2_XJUROS+E2_XMULTA+E2_SDACRES)*100),15))
		Endif
	Endif

return(cValOK)

Static Function xSaldComp(cxFil,cTipo,cPrefix,cNumero,cParcela,cFornec,cLoja)

	Local aArea 	:= GetArea()
	Local aAreaSE5	:= SE5->(GetArea())

	Local nValComp := 0

	Local cNextAlias 	:= GetNextAlias()

	BeginSql Alias cNextAlias
		SELECT
			SUM(E5_VALOR) E5_VALOR
		FROM
			%Table:SE5% SE5
		WHERE
			SE5.%NotDel%
			AND SE5.E5_FILIAL = %Exp:cxFil%
			AND SE5.E5_TIPO = %Exp:cTipo%
			AND SE5.E5_PREFIXO = %Exp:cPrefix%
			AND SE5.E5_NUMERO = %Exp:cNumero%
			AND SE5.E5_PARCELA = %Exp:cParcela%
			AND SE5.E5_CLIFOR = %Exp:cFornec%
			AND SE5.E5_LOJA = %Exp:cLoja%
			AND SE5.E5_MOTBX = 'CMP'
			AND SE5.E5_TIPODOC = 'CP'
	EndSql

	(cNextAlias)->(dbGoTop())

	While (cNextAlias)->(!EOF())
		nValComp += (cNextAlias)->E5_VALOR
		(cNextAlias)->(dbSkip())
	EndDo

	(cNextAlias)->(DbClosearea())

	RestArea(aAreaSE5)
	RestArea(aArea)

Return nValComp