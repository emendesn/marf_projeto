#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#define CRLF chr(13) + chr(10)
/*
============================================================================================
Programa.:              MGFFINA2
Autor....:              Natanael Filho
Data.....:               24/04/2018
Descricao / Objetivo:    Gerar o desconto do NDF e do TX nos casos de devolução de compra de gado (FUNRURAL).
							O Desconto será realizado através da rotina customizada de tipo de valor do Contas a Pagar
Doc. Origem:            
Solicitante:            Alexandre Rocha
Uso......:              Marfrig
Obs......:              
=============================================================================================
*/
User Function MGFFINA2(opc)
// 1 - Inclusão; 2 - Exclusão
If opc = 1
	Return FINA2INC()
ElseIf opc = 2
	FINA2EXC()
EndIf

Return Nil



//=======================================================
// FINA2INC
// Função para estornar os tipos de valores antes da exclusão do documento
//=======================================================
Static Function FINA2INC()
Local aArea := GetArea()
Local cTPValorTX := Alltrim(SuperGetMV("MGF_FINA2T",.T.,"")) //Código do Tipo de valor do desconto no TX (Imposto). Deixa vazio para não gerar o T. de Valor.
Local cTPValorCP := Alltrim(SuperGetMV("MGF_FINA2P",.T.,"")) //Código do Tipo de valor do desconto no Título a Pagar. Deixa vazio para não gerar o T. de Valor.
Local cFORINSS   := Alltrim(SuperGetMV("MV_FORINSS",.T.,"")) // Fornecedor padrao para titulos de INSS
Local nF1funcp   := 0 //Valor Total RUNRUAL da NF de Origem
Local nD2funcp   := 0  //Valor FUNRAL a creditar do titulo a pagar
Local nD2funtx   := 0  //Valor FUNRAL a creditar do titulo a pagar
Local lRecalc    := .F.

DBSelectArea('SD2')
dbSetOrder(3) // D2_FILIAL + D2_DOC + D2_SERIE + D2_CLENTE + D2_LOJA + D2_COD + D2_ITEM
If Dbseek(xFilial("SF2") + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA)
	While SD2->(!EOF()) .AND. (xFilial("SF2") + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA) = (SD2->D2_FILIAL + SD2->D2_DOC + SD2->D2_SERIE + SD2->D2_CLIENTE + SD2->D2_LOJA)
		
		nF1funcp := POSICIONE("SF1",1,xFILIAL("SD2")+ SD2->D2_NFORI + SD2->D2_SERIORI + SD2->D2_CLIENTE + SD2->D2_LOJA,"F1_CONTSOC")
		nD2funcp := SD2->D2_VALFUN
		nD2funtx := SD2->D2_VALFUN
		
		DBSelectArea('SE2')
		dbSetOrder(1) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA
		If DbSeek(xFilial("SD2") + SD2->D2_SERIORI + SD2->D2_NFORI)
			While SE2->(!EOF()) ;
			.AND. (nD2funtx > 0 .OR. nD2funcp > 0) ;
			.AND. (xFilial("SD2") + SD2->D2_SERIORI + SD2->D2_NFORI) = SE2->E2_FILIAL + SE2->E2_PREFIXO + SE2->E2_NUM
				
				//Verifica qual o tipo do titulo e se não o desconto não é maior que o saldo.
				If ALLTRIM(SE2->E2_TIPO)='TX';
				.AND. !Empty(cTPValorTX) ;				
				.AND. SE2->E2_SALDO >= nD2funtx ;
				.AND. SE2->E2_VALOR = nF1funcp;
				.AND. (SE2->E2_FORNECE) = (cFORINSS)
					
					If SE2->E2_VALOR = SE2->E2_SALDO
						Reclock("ZDS",.T.)
							ZDS->ZDS_FILIAL := SE2->E2_FILIAL
							ZDS->ZDS_PREFIX := SE2->E2_PREFIXO
							ZDS->ZDS_NUM    := SE2->E2_NUM
							ZDS->ZDS_PARCEL := SE2->E2_PARCELA
							ZDS->ZDS_TIPO   := SE2->E2_TIPO
							ZDS->ZDS_FORNEC := SE2->E2_FORNECE
							ZDS->ZDS_LOJA   := SE2->E2_LOJA
							ZDS->ZDS_DOCORI   := ('SD2' + SD2->D2_DOC + SD2->D2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA) //Tabela de origem + Documento + Serie
							ZDS->ZDS_COD    := cTPValorTX
							ZDS->ZDS_HISTOR := "FUNRURAL Dev. Compras. NF: " + SF2->F2_DOC + SF2->F2_SERIE
							ZDS->ZDS_VALOR  := nD2funtx
							nD2funtx -= ZDS->ZDS_VALOR
						ZDS->(MsUnlock())	
						lRecalc := .T. //Houve atualização então é necessário realizar o recalculo.
					Else
						Help( ,, 'MGFFINA2_4',, 'Não foi possível incluir o Tipo de valor do título ' + SE2->E2_NUM + ' ' + SE2->E2_TIPO + ' - Este já sofreu baixa', 1, 0)
					EndIf
					
				//Verifica qual o tipo do titulo e se não o desconto não é maior que o saldo.
				ElseIf ALLTRIM(SE2->E2_TIPO)='NF' ;
				.AND. !Empty(cTPValorCP) ;
				.AND. SE2->E2_SALDO >= nD2funcp ;
				.AND. (SE2->E2_FORNECE + SE2->E2_LOJA) = (SD2->D2_CLIENTE + SD2->D2_LOJA)
					
					If SE2->E2_VALOR = SE2->E2_SALDO
						Reclock("ZDS",.T.)
							ZDS->ZDS_FILIAL := SE2->E2_FILIAL
							ZDS->ZDS_PREFIX := SE2->E2_PREFIXO
							ZDS->ZDS_NUM    := SE2->E2_NUM
							ZDS->ZDS_PARCEL := SE2->E2_PARCELA
							ZDS->ZDS_TIPO   := SE2->E2_TIPO
							ZDS->ZDS_FORNEC := SE2->E2_FORNECE
							ZDS->ZDS_LOJA   := SE2->E2_LOJA
							ZDS->ZDS_DOCORI   := ('SD2' + SD2->D2_DOC + SD2->D2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA) //Tabela de origem + Documento + Serie
							ZDS->ZDS_COD    := cTPValorCP
							ZDS->ZDS_HISTOR := "FUNRURAL Dev. Compras. NF: " + SF2->F2_DOC + SF2->F2_SERIE
							ZDS->ZDS_VALOR  := nD2funcp
							nD2funcp -= ZDS->ZDS_VALOR
						ZDS->(MsUnlock())	
						lRecalc := .T. //Houve atualização então é necessário realizar o recalculo.
					Else
						Help( ,, 'MGFFINA2_3',, 'Não foi possível incluir o Tipo de valor do título ' + SE2->E2_NUM + ' ' + SE2->E2_TIPO + ' - Este já sofreu baixa', 1, 0)
					EndIf
				EndIf
				
				//Função para atualização dos títulos a partir dos tipos de valores.
				If FindFunction("U_MGFFIN87") .AND. lRecalc
					U_MGFFIN87(1)
					lRecalc := .F.
				Endif
				
				SE2->(DbSkip())
			EndDo
		EndIf
		SD2->(DbSkip())
	EndDo
EndIf

RestArea(aArea)


Return Nil


//=======================================================
// FINA2EXC
// Função para estornar os tipos de valores antes da exclusão do documento
//=======================================================
Static Function FINA2EXC()
Local aArea := GetArea()
Local lRet := .T.
Local lRecalc := .F.

//Query para armazenar todos os itens da Nota Fiscal excluída. Varre todos os itens da NF, pois é possivel devolver mais de uma Nota Fiscal no mesmo documento.
BeginSQL Alias "SD2TMP"
	SELECT
		D2_FILIAL,
		D2_DOC,
		D2_SERIE,
		D2_CLIENTE,
		D2_LOJA,
		D2_SERIORI,
		D2_NFORI
	FROM
		%Table:SD2%
	WHERE
		D2_FILIAL 		= %Exp:SF2->F2_FILIAL% 
		AND D2_DOC 		= %Exp:SF2->F2_DOC%
		AND D2_SERIE 	= %Exp:SF2->F2_SERIE%
		AND D2_CLIENTE 	= %Exp:SF2->F2_CLIENTE%
		AND D2_LOJA 	= %Exp:SF2->F2_LOJA%
EndSQL

SD2TMP->(DBGoTop())
While SD2TMP->(!EOF())	
	//Localiza os tipos de valores relacioados ao item da NF de devolução.
	DBSelectArea('ZDS')
	ZDS->(DBSetOrder(3)) //ZDS_FILIAL + ZDS_DOCORI + ZDS_PREFIX + ZDS_NUM
	If ZDS->(DBSeek(SD2TMP->D2_FILIAL + 'SD2' + SD2TMP->D2_DOC + SD2TMP->D2_SERIE + SD2TMP->D2_CLIENTE + SD2TMP->D2_LOJA + SD2TMP->D2_SERIORI + SD2TMP->D2_NFORI))
		While ZDS->(!EOF()) ;
			.AND. (ZDS->(ZDS_FILIAL + ZDS_DOCORI + ZDS_PREFIX + ZDS_NUM)) ;
			= (SD2TMP->D2_FILIAL + 'SD2' + SD2TMP->D2_DOC + SD2TMP->D2_SERIE + SD2TMP->D2_CLIENTE + SD2TMP->D2_LOJA + SD2TMP->D2_SERIORI + SD2TMP->D2_NFORI)
	
			aAreaZDS := ZDS->( GetArea() )
			//Localiza o título origem do tipo de valor para verifica se há saldo disponível para estorno do tipo de valor.
			DBSelectArea('SE2')
			dbSetOrder(1) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA
			SE2->(DBGoTop())
			If SE2->(DbSeek(ZDS->(ZDS_FILIAL + ZDS_PREFIX + ZDS_NUM + ZDS_PARCEL + ZDS_TIPO + ZDS_FORNEC + ZDS_LOJA)))
				If SE2->E2_SALDO >= ZDS->ZDS_VALOR
					Reclock("ZDS",.F.)
						dbDelete()
					ZDS->(MsUnlock())	
					lRecalc := .T. //Houve atualização então é necessário realizar o recalculo.
					lRet := .T.
				Else
					Help( ,, 'MGFFINA2_2',, 'Não foi possível excluir o Documento: Saldo do título menor que o Tipo de Valor', 1, 0)
					DisarmTransaction() //Aborta Todas as alterações
					Break
				EndIf
			EndIf
			
			//Recalcula os campos de acrescimos ou decrescimos do título
			If FindFunction("U_MGFFIN87") .AND. lRecalc
				aZDSArea := ZDS->(GetArea())
				U_MGFFIN87(1)
				lRecalc := .F.
				ZDS->(RestArea(aZDSArea))
			Endif
			ZDS->( RestArea(aAreaZDS) )
			ZDS->(DbSkip())
		EndDo
	EndIf
	SD2TMP->(DbSkip())
EndDo
SD2TMP->(DbCloseArea())
RestArea(aArea)
Return Nil