#Include "Protheus.Ch"
#Include "Report.Ch"
#include "Rwmake.ch"
#include "Ap5mail.ch"
#include "Topconn.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
#INCLUDE "FWCOMMAND.CH"

/*
=====================================================================================
Programa.:              MGFFIN07
Autor....:              Antonio Carlos
Data.....:              27/09/2016
Descricao / Objetivo:   gerar excel com dados financeiros do cliente
Doc. Origem:            Contrato - GAP MGFCRE09
Solicitante:            Cliente
Uso......:              
Obs......:              utilizado para apresentar os dados financeiros do cliente
Compartilhado (cArqTmp)->FILIAL, aAdd(aCabec, {"FILIAL" 	    ,"C", 02, 00} )    A1_FILIAL FILIAL,
=====================================================================================
*/

User Function MGFFIN07()

Local cStatus		:= ""
Local cBoleto		:= ""

private aSRC 		:= {}
private cSaveArea
private aArea         := GetArea()
private cString		:= "SA1"
private _cQuery 	    := ' '
private _cQuery1	    := ' '
private _cQuery2	    := ' '
private _cQuery3	    := ' '
private cArqTmp1 	:= GetNextAlias()
private cArqTmp2 	:= GetNextAlias()
private cArqTmp3 	:= GetNextAlias()
private cArqTmp  	:= GetNextAlias()
private cPerg 	:= "CRE009"
private oReport
private oSection1
private dMaiAC
private dUlPgto
private cReport		:= "CRE009"
private cTitulo		:= "Relacao de dados financeiros de clientes"
private cDesc			:= "Este programa ira imprimir dados financeiros de Clientes."
private aCabec		:= {}
private aItens		:= {}
private aItem	        := {}
private aArqT1        := {}
private aArqT2        := {}
private aArqT3        := {}
private nX,nW,nY,nT   := 0
private nLen1         := 0
private nLen2         := 0
private nLen3         := 0
private nTotVenc, nTotAven := 0

//CriaSx1(cPerg)
if !Pergunte(cPerg,.T.)
	return
endif

fwMsgRun(, {|oSay| procFin07( oSay ) }, "Gerando arquivo", "Aguarde. Gerando arquivo..." )

Return( Nil )

//---------------------------------------------
//---------------------------------------------
static function procFin07()

	Local cIn			:= ""
	Local cPenFin		:= ""
	Local cInativ		:= ""
	Local cBlqReceit	:= ""
	Local cAutoTempo	:= ""
	Local cGrdRedes		:= ""
	Local _cAliasSF2	:= GetNextAlias()
	Local _cWhrSF2 		:= "%"
	Local _cWhrSF2B		:= "%"
	Local _cWhrSE1 		:= "%"
	Local _cWhrSA1 		:= "%"

	aAdd(aCabec, {"CODIGO"	    				,"C", 06, 00} )
	aAdd(aCabec, {"LOJA"        				,"C", 02, 00} )
	aAdd(aCabec, {"NOME"	    				,"C", 40, 00} )
	aAdd(aCabec, {"COD_REDE"					,"C", 02, 00} )
	aAdd(aCabec, {"REDE"     					,"C", 40, 00} )
	aAdd(aCabec, {"ATRASO"      				,"N", 03, 00} )
	aAdd(aCabec, {"ATRASO_MEDIO"				,"N", 07, 00} )
	aAdd(aCabec, {"ULTIMO_FAT"					,"D", 08, 00} )
	aAdd(aCabec, {"VALOR_LIM_CREDITO"			,"N", 14, 02} )
	aAdd(aCabec, {"VALIDADE_LIM_CRED"			,"D", 08, 00} )
	aAdd(aCabec, {"CONDICAO_PAGAMENTO"			,"C", 03, 00} )
	aAdd(aCabec, {"VALOR_MAIOR_AC"	    		,"N", 14, 02} )
	aAdd(aCabec, {"DATA_MAIOR_AC"	    		,"D", 08, 00} )
	aAdd(aCabec, {"DUPLICATA_ATRASO"			,"C", 01, 00} )
	aAdd(aCabec, {"VALOR_PEDIDO"    			,"N", 14, 02} )
	aAdd(aCabec, {"SALDO"           			,"N", 14, 02} )
	aAdd(aCabec, {"INFORMACOES_DIVER"			,"C", 60, 00} )
	aAdd(aCabec, {"VENCIDAS"         			,"N", 14, 02} )
	aAdd(aCabec, {"A_VENCER"        			,"N", 14, 02} )
	aAdd(aCabec, {"DATA_ULTIMO_PGTO"			,"D", 08, 00} )
	aAdd(aCabec, {"VALOR_ULTIMA_COMPRA"			,"N", 14, 02} )
	aAdd(aCabec, {"MAIOR_FATURA"    			,"N", 14, 02} )
	aAdd(aCabec, {"STATUS_CLIENTE"     			,"C", 10, 00} )
	aAdd(aCabec, {"GERA_BOLETO"     			,"C", 03, 00} )
	aAdd(aCabec, {"CLASSE_CLIENTE"     			,"C", 01, 00} )
	aAdd(aCabec, {"PENDENCIA_FINANCEIRA"		,"C", 03, 00} )
	aAdd(aCabec, {"INATIVIDADE_COMPRA"			,"C", 03, 00} )
	aAdd(aCabec, {"BLOQUEIO_RECEITA_SINTEGRA"	,"C", 03, 00} )
	aAdd(aCabec, {"AUTORIZACAO_TEMPORARIA"		,"C", 03, 00} )
	aAdd(aCabec, {"EMAIL_COBRANCA"				,"C", 03, 00} )
	aAdd(aCabec, {"GRANDES_REDES"				,"C", 03, 00} )
	aAdd(aCabec, {"OBS"     					,"C", 60, 00} )

	If !Empty(MV_PAR07)
		_cInCli		:= xInClien(MV_PAR07)
		_cWhrSF2	+= "SF2.F2_CLIENTE " 	+ 	_cInCli
		_cWhrSF2B	+= "F2_CLIENTE "+ 			_cInCli
		_cWhrSE1	+= "SE1.E1_CLIENTE " 	+ 	_cInCli
		_cWhrSA1	+= "A1.A1_COD " 		+ 	_cInCli
	Else
		_cWhrSF2 	+= "SF2.F2_CLIENTE >= '"+MV_PAR03+"' AND SF2.F2_CLIENTE <= '"+MV_PAR04+"' AND SF2.F2_LOJA >= '"+MV_PAR05+"' AND SF2.F2_LOJA <= '"+MV_PAR06+"'" 
		_cWhrSF2B 	+= "F2_CLIENTE >= '"+MV_PAR03+"' AND F2_CLIENTE <= '"+MV_PAR04+"' AND F2_LOJA >= '"+MV_PAR05+"' AND F2_LOJA <= '"+MV_PAR06+"'"	
		_cWhrSE1 	+= "SE1.E1_CLIENTE >= '"+MV_PAR03+"' AND SE1.E1_CLIENTE <= '"+MV_PAR04+"' AND SE1.E1_LOJA >= '"+MV_PAR05+"' AND SE1.E1_LOJA <= '"+MV_PAR06+"'" 
		_cWhrSA1 	+= "A1.A1_COD 	>= '"+MV_PAR03+"' AND A1.A1_COD <= '"+MV_PAR04+"' AND A1.A1_LOJA >= '"+MV_PAR05+"' AND A1.A1_LOJA <= '"+MV_PAR06+"'"
	EndIf	

	_cWhrSF2 	+= "%"
	_cWhrSF2B	+= "%"
	_cWhrSE1 	+= "%"
	_cWhrSA1 	+= "%"	

	BeginSql Alias _cAliasSF2
						
		SELECT 
			SF2.F2_VALBRUT VALOR_ULTIMA_COMPRA, SF2.F2_EMISSAO EMISSAO, SF2.F2_CLIENTE CLIENTE, SF2.F2_LOJA LOJA
		FROM 
			%Table:SF2% SF2
			INNER JOIN
			(SELECT  F2_CLIENTE, F2_LOJA, MAX(F2_EMISSAO) DATA_ULTIMA_COMPRA FROM %Table:SF2% GROUP BY F2_CLIENTE, F2_LOJA ) DTULTCMP
			ON SF2.F2_CLIENTE||SF2.F2_LOJA = DTULTCMP.F2_CLIENTE||DTULTCMP.F2_LOJA
			AND SF2.F2_EMISSAO = DTULTCMP.DATA_ULTIMA_COMPRA
		WHERE
			SF2.F2_EMISSAO >= %Exp: DTOS(MV_PAR01)% AND 
			SF2.F2_EMISSAO <= %Exp: DTOS(MV_PAR02)% AND
			%Exp:_cWhrSF2% 							AND
			SF2.%notdel%
		ORDER BY CLIENTE, LOJA, EMISSAO
	EndSql
	//MemoWrite("C:\QRY\MGFFIN07_1.SQL",GetLastQuery()[2])

	While (_cAliasSF2)->(!Eof())
		aadd( aArqT1, { (_cAliasSF2)->VALOR_ULTIMA_COMPRA, (_cAliasSF2)->EMISSAO, (_cAliasSF2)->CLIENTE , (_cAliasSF2)->LOJA })
		(_cAliasSF2)->( DbSkip() )
	EndDo

	nLen1  := len(aArqT1)
	If nLen1 > 0
		cdata1 := aArqt1[nlen1, 2]
	EndIf

	//---Fechando area de trabalho
	(_cAliasSF2)->(dbcloseArea())	
	_cAliasSF2	:= GetNextAlias()	

	BeginSql Alias _cAliasSF2

		SELECT
			VALBRUT VALOR_MAIOR_AC, MAX(F2_EMISSAO) DATA_MAIOR_AC, F2_CLIENTE CLIENTE, F2_LOJA LOJA 
		FROM
			%Table:SF2% A,
			(
    			SELECT  
        			F2_CLIENTE CLI, F2_LOJA LOJ, MAX(F2_VALBRUT) VALBRUT 
				FROM
					%Table:SF2% A    
				WHERE 
					F2_TIPO = 'N' 		AND
					F2_DUPL <> ' '		AND
					%Exp:_cWhrSF2B% 	AND 
					%notdel%  
				GROUP BY 
					F2_CLIENTE, F2_LOJA )B
		WHERE
			F2_CLIENTE 	= CLI 		AND
			F2_LOJA 	= LOJ		AND
			VALBRUT 	= F2_VALBRUT
		GROUP BY
			VALBRUT, F2_CLIENTE, F2_LOJA 
		ORDER BY 
			CLIENTE, LOJA
			
	EndSql
	//MemoWrite("C:\QRY\MGFFIN07_2.SQL",GetLastQuery()[2])

	While (_cAliasSF2)->(!Eof())
		aadd( aArqT2, { (_cAliasSF2)->DATA_MAIOR_AC , (_cAliasSF2)->VALOR_MAIOR_AC , (_cAliasSF2)->CLIENTE , (_cAliasSF2)->LOJA })
		(_cAliasSF2)->( DbSkip() )
	EndDo
	nLen2  := len(aArqT2)
	If nLen2 > 0
		cdata2 := aArqt2[nlen2, 1]
	EndIf	

	//---Fechando area de trabalho
	(_cAliasSF2)->(dbcloseArea())	
	_cAliasSE1	:= GetNextAlias()	

	BeginSql Alias _cAliasSE1

		SELECT 
			SE1.E1_BAIXA, SE1.E1_CLIENTE, SE1.E1_LOJA
		FROM
			%Table:SE1% SE1
		INNER JOIN
			(SELECT E1_CLIENTE, E1_LOJA , MAX(E1_BAIXA) DATA_ULTIMO_PGTO FROM %Table:SE1% GROUP BY E1_CLIENTE, E1_LOJA ) DTULPGTO
			ON SE1.E1_CLIENTE||SE1.E1_LOJA = DTULPGTO.E1_CLIENTE||DTULPGTO.E1_LOJA
			AND SE1.E1_BAIXA = DTULPGTO.DATA_ULTIMO_PGTO
		WHERE
			SE1.E1_BAIXA <> ' '	AND 
			%Exp:_cWhrSE1%		AND
			SE1.%notdel%
		ORDER BY SE1.E1_CLIENTE, SE1.E1_LOJA 
			
	EndSql
	//MemoWrite("C:\QRY\MGFFIN07_3.SQL",GetLastQuery()[2])

	While (_cAliasSE1)->(!Eof())
		aadd( aArqT3, { (_cAliasSE1)->E1_BAIXA , (_cAliasSE1)->E1_CLIENTE , (_cAliasSE1)->E1_LOJA })
		(_cAliasSE1)->( DbSkip() )
	EndDo

	nLen3  := len(aArqT3)

	//---Fechando area de trabalho
	(_cAliasSE1)->(dbcloseArea())	
	_cAliasMST	:= GetNextAlias()	

	BeginSql Alias _cAliasMST
						
		SELECT DISTINCT 
			A1_COD CODIGO,A1_LOJA LOJA,A1_NOME NOME,A1_ZREDE COD_REDE,A1_ATR ATRASO,A1_METR ATRASO_MEDIO, A1_ULTCOM ULTIMO_FAT,A1_LC VALOR_LIM_CREDITO,
			A1_VENCLC VALIDADE_LIM_CRED, A1_COND CONDICAO_PAGAMENTO,A1_SALPED VALOR_PEDIDO,A1_LC SALDO,A1_OBSERV INFORMACOES_DIVER,A1_DTULTIT,
			A1_MAIDUPL MAIOR_FATURA,A1_MAIDUPL ,' ' DUPLICATA_ATRASO,A1_METR NUMERO_DIAS_ATRASO,A1_MSBLQL STATUS_CLIENTE,A1_ZBOLETO GERA_BOLETO,
			A1_ZCLASSE CLASSE_CLIENTE, 0 VALOR_MAIOR_AC, ' ' DATA_MAIOR_AC, 0 VALOR_ULTIMA_COMPRA, ' ' DATA_ULTIMO_PGTO, ZQ.ZQ_DESCR REDE,' ' OBS,' ' BRANCO,
			(SELECT SUM(E1.E1_VALOR) FROM %Table:SE1% E1 WHERE A1.A1_COD = E1.E1_CLIENTE AND A1.A1_LOJA = E1.E1_LOJA AND E1.%notdel% AND 
			E1_VENCREA <= %Exp: DTOS(DATE())% AND E1.E1_SALDO > 0)  VENCIDAS,   
			(SELECT SUM(E1.E1_VALOR) FROM %Table:SE1% E1 WHERE A1.A1_COD = E1.E1_CLIENTE AND A1.A1_LOJA = E1.E1_LOJA AND E1.%notdel% AND
			E1_VENCREA > %Exp: DTOS(DATE())% AND E1.E1_SALDO > 0)  A_VENCER, 
			A1_XPENFIN PENDENCIA_FINANCEIRA, A1_ZINATIV INATIVIDADE_COMPRA , 
			A1_XBLQREC BLOQUEIO_RECEITA_SINTEGRA , A1_XTEMPOR AUTORIZACAO_TEMPORARIA , A1_XMAILCO EMAIL_COBRANCA , A1_ZGDERED GRANDES_REDES
		FROM 
			%Table:SA1% A1
			LEFT JOIN %Table:SZQ% ZQ ON ZQ.ZQ_COD = A1.A1_ZREDE AND ZQ.%notdel% 
		WHERE
			A1.%notdel% AND
			A1.A1_VENCLC >= %Exp: DTOS(MV_PAR01)% AND A1.A1_VENCLC <= %Exp: DTOS(MV_PAR02)% AND 
			%Exp:_cWhrSA1%
		ORDER BY 01,02,03
			
	EndSql
	//MemoWrite("C:\QRY\MGFFIN07_4.SQL",GetLastQuery()[2])

	aItem := {}
	While (_cAliasMST)->(!Eof())
		cValUC  := 0
		dMaiAc  := "19910101"
		cMaiAc  := 0
		dUlPgto := "19910101"
		dVenLC  := "19910101"
		dUlFat  := "19910101"

		_nPosT1	:= AScan( aArqT1, { |x| x[3]+x[4] == (_cAliasMST)->CODIGO+(_cAliasMST)->LOJA } )
		If _nPosT1 <> 0
			cValUC := (aArqT1[_nPosT1,1]) 
		Endif

		_nPosT2	:= AScan( aArqT2, { |x| x[3]+x[4] == (_cAliasMST)->CODIGO+(_cAliasMST)->LOJA } )
		If _nPosT2 <> 0
			dMaiAc := aArqT2[_nPosT2,1]
			cMaiAc := aArqT2[_nPosT2,2]
		Endif

		_nPosT3	:= AScan( aArqT3, { |x| x[2]+x[3] == (_cAliasMST)->CODIGO+(_cAliasMST)->LOJA } )
		If _nPosT3 <> 0
			dUlPgto := aArqT3[_nPosT3,1]
		Endif

		IF !EMPTY((_cAliasMST)->ULTIMO_FAT)
			dUlFat := (_cAliasMST)->ULTIMO_FAT
		ENDIF

		IF !EMPTY((_cAliasMST)->VALIDADE_LIM_CRED)
			dVenLC := (_cAliasMST)->VALIDADE_LIM_CRED
		ENDIF

		cStatus := IIF((_cAliasMST)->STATUS_CLIENTE =="1","BLOQUEADO","LIBERADO")
		cBoleto := IIF((_cAliasMST)->GERA_BOLETO == "S","SIM","NAO")

		cPenFin	:= ""
		cPenFin	:= iif( (_cAliasMST)->PENDENCIA_FINANCEIRA == "S" , "SIM" , "NAO" )

		cInativ	:= ""
		cInativ	:= iif( (_cAliasMST)->INATIVIDADE_COMPRA == "1" , "SIM" , "NAO" )

		cBlqReceit	:= ""
		cBlqReceit	:= iif( (_cAliasMST)->BLOQUEIO_RECEITA_SINTEGRA == "S" , "SIM" , "NAO" )

		cAutoTempo	:= ""
		cAutoTempo	:= iif( (_cAliasMST)->AUTORIZACAO_TEMPORARIA == "S" , "SIM" , "NAO" )

		cGrdRedes	:= ""
		cGrdRedes	:= iif( (_cAliasMST)->GRANDES_REDES == "S" , "SIM" , "NAO" )

		aItem := {}

		aadd( aItem, { (_cAliasMST)->CODIGO , (_cAliasMST)->LOJA , (_cAliasMST)->NOME , (_cAliasMST)->COD_REDE , (_cAliasMST)->REDE , ;
						(_cAliasMST)->ATRASO , (_cAliasMST)->ATRASO_MEDIO , dUlFat , (_cAliasMST)->VALOR_LIM_CREDITO , dVenLC , ;
						(_cAliasMST)->CONDICAO_PAGAMENTO , VALOR_MAIOR_AC , DATA_MAIOR_AC , " " , ;
						(_cAliasMST)->VALOR_PEDIDO , " " , (_cAliasMST)->INFORMACOES_DIVER , (_cAliasMST)->VENCIDAS , (_cAliasMST)->A_VENCER , ;
						dUlPgto , cValUC , (_cAliasMST)->MAIOR_FATURA , cStatus ,cBoleto,(_cAliasMST)->CLASSE_CLIENTE," " , cPenFin , cInativ ,;
						cBlqReceit , cAutoTempo , (_cAliasMST)->EMAIL_COBRANCA , cGrdRedes })

		aItem := Array( Len(aCabec) )

		For nT := 1 to Len(aCabec)
			IF aCabec[nT][1] == "ULTIMO_FAT"
				aItem[nT] := dUlFat
			ELSEIF aCabec[nT][1] == "VALIDADE_LIM_CRED"
				aItem[nT] := dVenLC
			ELSEIF aCabec[nT][1] == "VALOR_MAIOR_AC"
				aItem[nT] := cMaiAc
			ELSEIF aCabec[nT][1] == "DATA_MAIOR_AC"
				aItem[nT] := dMaiAc
			ELSEIF aCabec[nT][1] == "VALOR_ULTIMA_COMPRA"
				aItem[nT] := cValUC
			ELSEIF aCabec[nT][1] == "DATA_ULTIMO_PGTO"
				aItem[nT] := dUlPgto
			ELSEIF aCabec[nT][1] == "DUPLICATA_ATRASO"
				aItem[nT] := IIF(!Empty((_cAliasMST)->ATRASO), "S", "N")
			ELSEIF aCabec[nT][1] == "SALDO"
				aItem[nT] := ((_cAliasMST)->VALOR_LIM_CREDITO - (_cAliasMST)->VENCIDAS - (_cAliasMST)->A_VENCER)
			ELSEIF aCabec[nT][1] == "STATUS_CLIENTE"
				aItem[nT] := cStatus
			ELSEIF aCabec[nT][1] == "GERA_BOLETO"
				aItem[nT] := cBoleto
			ELSEIF aCabec[nT][1] == "PENDENCIA_FINANCEIRA"
				aItem[nT] := cPenFin
			ELSEIF aCabec[nT][1] == "INATIVIDADE_COMPRA"
				aItem[nT] := cInativ
			ELSEIF aCabec[nT][1] == "BLOQUEIO_RECEITA_SINTEGRA"
				aItem[nT] := cBlqReceit
			ELSEIF aCabec[nT][1] == "AUTORIZACAO_TEMPORARIA"
				aItem[nT] := cAutoTempo
			ELSEIF aCabec[nT][1] == "GRANDES_REDES"
				aItem[nT] := cGrdRedes
			ELSE
				If aCabec[nT][2] == "C"
					aItem[nT] := Chr(160) + (_cAliasMST)->&(aCabec[nT,01])
				Else
					aItem[nT] := (_cAliasMST)->&(aCabec[nT,01])
				Endif
			Endif
		Next nT

		aAdd( aItens, aItem )
		(_cAliasMST)->( DbSkip() )

	EndDo

//---Fechando area de trabalho
(_cAliasMST)->(dbcloseArea())

MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel", {|| DlgToExcel({{"GETDADOS", "Exporta��o Fin_Clientes", aCabec,aItens } } ) } )
Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CriaSx1   �Autor  �   	    		 � Data � OUT/2013    ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina para criacao do grupo de perguntas	  		          ���
���                  .				                                      ���
�������������������������������������������������������������������������͹��
���Uso       �                                            	              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function CriaSx1(cPerg)
Local aArea    := GetArea()    				// Salva ambiente atual para posterior restauracao
Local aPerg    := {}						// Array com dados referentes ao pergunte a ser criado
Local _sAlias := Alias()
Local aRegs   := {}
Local i,j
Local aHelpPor0 := {'Informe a Data inicial ','Data inicial para o processamento'}
Local aHelpPor1 := {'Informe a Data Final ','Data Final para o processamento'}
Local aHelpPor3 := {'Informe o Cliente Inicial ','Cliente Inicial para o processamento'}
Local aHelpPor4 := {'Informe o Cliente Final ','Cliente Final para o processamento'}
Local aHelpPor3 := {'Informe a Loja Inicial ','Loja Inicial para o processamento'}
Local aHelpPor4 := {'Informe a Loja Final ','Loja Final para o processamento'}
Local aHelpEng,aHelpSpa := {}

cAlias := Alias()
aRegs :={}
dbSelectArea("SX1")
dbgotop()
dbSetOrder(1)
cPerg := PADR(cPerg,6)

If dbSeek(cPerg)
Else
   PutSx1(cPerg,"01","Data inicial","","","mv_ch1","D",08,0,0,"G","","","","","MV_PAR01","","","","","","","","","","","","","","","","",aHelpPor0,aHelpEng,aHelpSpa)
   PutSx1(cPerg,"02","Data final","","","mv_ch2","D",08,0,0,"G","","","","","MV_PAR02","","","","","","","","","","","","","","","","",aHelpPor1,aHelpEng,aHelpSpa)
   PutSx1(cPerg,"03","Cliente inicial","","","mv_ch3","C",06,0,0,"G","","","","","MV_PAR03","","","","","","","","","","","","","","","","",aHelpPor3,aHelpEng,aHelpSpa)
   PutSx1(cPerg,"04","Cliente final","","","mv_ch4","C",06,0,0,"G","","","","","MV_PAR04","","","","","","","","","","","","","","","","",aHelpPor4,aHelpEng,aHelpSpa)
   PutSx1(cPerg,"05","Loja inicial","","","mv_ch5","C",02,0,0,"G","","","","","MV_PAR05","","","","","","","","","","","","","","","","",aHelpPor5,aHelpEng,aHelpSpa)
   PutSx1(cPerg,"06","Loja final","","","mv_ch6","C",02,0,0,"G","","","","","MV_PAR06","","","","","","","","","","","","","","","","",aHelpPor6,aHelpEng,aHelpSpa)
EndIF
DbSelectArea(_sAlias)
RestArea(aArea)
Return

Static Function xInClien(cxParam)

	Local cRet 		:= ""
	Local axParam 	:= {}
	Local ni 		:= 0

	If !Empty(cxParam)
		axParam := STRTOKARR(cxParam,';')
		cRet += "IN ("
		For ni := 1 to Len(axParam)
			If Alltrim(cRet) == "IN ("
				cRet += " '" + Alltrim(axParam[ni]) + "'"
			Else
				cRet += " , '" + Alltrim(axParam[ni]) + "'"
			Endif
		Next ni
		cRet += " )"
	EndIf

Return cRet