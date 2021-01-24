#include "protheus.ch"
#include "totvs.ch"
#include "topconn.ch"

#define CRLF chr(13) + chr(10)

/*
====================================================================================
Programa............: PE01NFESEFAZ()
Autor...............: Flávio Dentello
Data................: 13/04/2017
Descricao / Objetivo: Ponto de entrada para inclusão de mensagens na DANFE
Doc. Origem.........: GAP - FIS29
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................:
=====================================================================================
*/

user function PE01NFESEFAZ()
	local aArea			:= getArea()
	local aAreaSC5		:= SC5->(getArea())
	local aAreaSC6		:= SC6->(getArea())
	local aAreaSF7		:= SF7->(getArea())
	local aAreaSF4		:= SF4->(getArea())
	local aAreaSA2		:= SA2->(getArea())
	local aAreaSA1		:= SA1->(getArea())
	local aAreaSM4		:= SM4->(getArea())
	Local aAreaDAK		:= DAK->(getArea())
	Local aAreaDA3		:= DA3->(getArea())
	Local aAreaSFT		:= SFT->(getArea())	
	local aProd     	:= PARAMIXB[1]
	local cMensCli  	:= PARAMIXB[2] //+ CRLF
	local cMensFis  	:= PARAMIXB[3]
	local aDest     	:= PARAMIXB[4]
	local aNota     	:= PARAMIXB[5]
	local aInfoItem 	:= PARAMIXB[6]
	local aDupl     	:= PARAMIXB[7]
	local aTransp   	:= PARAMIXB[8]
	local aEntrega  	:= PARAMIXB[9]
	local aRetirada 	:= PARAMIXB[10]
	local aVeiculo  	:= PARAMIXB[11]
	local aReboque  	:= PARAMIXB[12]
	local aNfVincRur	:= PARAMIXB[13]
	Local aEspVol     	:= PARAMIXB[14]
	Local aNfVinc		:= PARAMIXB[15]
	Local aAdetPag		:= PARAMIXB[16]
	Local aObsCotAux    := PARAMIXB[17]


	local aRetorno		:= {}
	local cMsg			:= ""
	local cCliFor		:= Iif(aNota[04] == "0", SA2->A2_COD	, SA1->A1_COD) //Considera SF1/SF2 posicionados
	local cLoja			:= Iif(aNota[04] == "0", SA2->A2_LOJA	, SA1->A1_LOJA) //Considera SF1/SF2 posicionados
	local _cENDENT		:= ""
	local _cMUNENT		:= ""
	local _cESTENT		:= ""
	local _cCEPENT		:= ""
	local _cMenscli		:= ""
	Local cFrete        := ""
	Local cAliq         := ""
	Local cICMS			:= ""
	Local nICMS         := 0
	Local nFrete	    := 0
	Local nI            := 1
	Local nPauta		:= 0
	local aAreaCD2		:= CD2->(getArea())
	local aAreaSD2		:= SD2->(getArea())
	local cNfOri		:= ""
	local cPedOri		:= ""
	local cMoeOri		:= ""
	local cTx			:= 0
	Local cFormula		:= GetMV("MGF_MENSFR")
	Local cMsgFrete     := GetMV("MGF_FORFRE")
	Local cAliqFre		:= SuperGetMV("MV_ALIQFRE",.T.," ")
	Local nAliqFre		:= 0
	/*Local cFilfre  		:= GetMv('MGF_VLFRET')*/ //Trecho removido, pois a mensagem será exibida para todas as unidades
	Local cInfHabil		:= ""
	//Local nPedido 		:= 0
	Local cPedido 		:= ""
	Local lMGFFIS35 	:= SuperGetMV("MGF_FIS35L",.T.,.F.) //Habilita as funcionalidades do MGFFIS35/GAP133


	SM4->(dbSetOrder(1))

	If aNota[04] == "0"

		If Findfunction ('U_FIS20_TXT')
			_cMensCli += U_FIS20_TXT(cMensFis,aNota[04])+ " "//CRLF
		EndIf
		If Findfunction ('U_FIS16_TXT')
			cMensFis += U_FIS16_TXT()
		EndIf
		If Findfunction ('U_TAE15PRECOCE')
			aObsCotAux := U_TAE15PRECOCE()
		EndIf
		If SF1->F1_CONTSOC <> 0
		  //_cMensCli += "Valor Funrural:" + alltrim(STR(SF1->F1_CONTSOC))	
			_cMensCli += "Valor INSS (1,2) e RAT (0,1) : " + alltrim(STR(SF1->F1_CONTSOC)) + " "
		EndIf
		If SF1->F1_VLSENAR <> 0
			_cMensCli += "Valor SENAR : " + alltrim(STR(SF1->F1_VLSENAR)) + " "			
		EndIf
		dBselectArea('SD1')
		dbSetOrder(1) //D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
		If DbSeek(xFilial('SD1')+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)

			While !SD1->(Eof()) .And. SD1->D1_DOC == SF1->F1_DOC .And. SD1->D1_SERIE ==  SF1->F1_SERIE

				dBselectArea('SF4')
				dbSetOrder(1) //F4_FILIAL+F4_CODIGO
				If DbSeek(xFilial('SF4')+SD1->D1_TES)

					If ALLTRIM(SF4->F4_XMENS1) <> ""
						dBselectArea('SM4')
						If DbSeek(xFilial('SM4')+ALLTRIM(SF4->F4_XMENS1))
							If !AllTrim(FORMULA(SF4->F4_XMENS1)) $ _cMensCli
								_cMensCli += (FORMULA(SF4->F4_XMENS1)) + " "//CRLF
							EndIf
						EndIf
					EndIf

					If ALLTRIM(SF4->F4_XMENS2) <> ""
						dBselectArea('SM4')
						If DbSeek(xFilial('SM4')+ALLTRIM(SF4->F4_XMENS2))
							If !AllTrim(FORMULA(SF4->F4_XMENS2)) $ _cMensCli
								_cMensCli += ALLTRIM(FORMULA(SF4->F4_XMENS2)) + " "// CRLF
							EndIf
						EndIf
					EndIf

				EndIf

				dBselectArea('SB1')
				dbSetOrder(1) //B1_FILIAL+B1_COD
				If DbSeek(xFilial('SB1')+SD1->D1_COD)
					If ALLTRIM(SB1->B1_XMENS1) <> ""
						dBselectArea('SM4')
						If DbSeek(xFilial('SM4')+ALLTRIM(SB1->B1_XMENS1))
							If !AllTrim(FORMULA(SB1->B1_XMENS1)) $ _cMensCli
								_cMensCli += ALLTRIM(FORMULA(SB1->B1_XMENS1))+ " "//CRLF
							EndIf
						EndIf
					EndIf
					If ALLTRIM(SB1->B1_XMENS2) <> ""
						dBselectArea('SM4')
						If DbSeek(xFilial('SM4')+ALLTRIM(SB1->B1_XMENS2))
							If !AllTrim(FORMULA(SB1->B1_XMENS2)) $ _cMensCli
								_cMensCli += ALLTRIM(FORMULA(SB1->B1_XMENS2)) + " "//CRLF
							EndIf
						EndIf
					EndIf
					MensExcFis(SA2->A2_GRPTRIB,SA2->A2_EST,@_cMensCli)
				EndIf
				SD1->(dbSkip())
			Enddo
		EndIf
		//Informações complementares para Nota de Importação
		If SF1->F1_EST == "EX"
			//		_cMensCli += "CONTR.AUT.EFETUAR PAG.IMPOSTO EM PRAZO PREV. NO RICMS, LIV.I, ART.50, IV, E LIVRO III,"+CRLF
			//		_cMensCli += "ART.53-E,II, CONCESSAO NR 0600124623. "
			DbSelectArea("SW6")
			SW6->(DbSetOrder(1))
			If SW6->(DbSeek(xFilial("SW6")+SF1->F1_HAWB))
				_cMensCli += IIF(!EMPTY(ALLTRIM(SW6->W6_DI_NUM)),"DI "+ALLTRIM(SW6->W6_DI_NUM),"")
				_cMensCli += IIF(!EMPTY(SW6->W6_DT_HAWB)," DE "+DTOC(SW6->W6_DT_HAWB),"")
				DbSelectArea("SW7")
				SW7->(DbSetOrder(1))
				If SW7->(DbSeek(xFilial("SW7")+SW6->W6_PO_NUM))
					_cMensCli += IIF(!EMPTY(SW7->W7_INVOICE)," FATURA "+ALLTRIM(SW7->W7_INVOICE),"")
				EndIF
				DbSelectArea("SW2")
				SW2->(DbSetOrder(1))
				If SW2->(DbSeek(xFilial("SW2")+SW6->W6_PO_NUM))
					_cMensCli += IIF(!EMPTY(SW2->W2_NR_PRO)," PROFORMA "+ALLTRIM(SW2->W2_NR_PRO),"")
				EndIF
				_cMensCli += CRLF
				_cMensCli += IIF(!EMPTY(ALLTRIM(SW6->W6_HAWB)),ALLTRIM(SW6->W6_HAWB),"")
				_cMensCli += "FRETE INTERNACIONAL " + IIF(!EMPTY(ALLTRIM(SW6->W6_FREMOED)),IIF(SW6->W6_VLFREPP<>0,Transform(SW6->W6_VLFREPP,PesqPict('SW6','W6_VLFREPP')),Transform(SW6->W6_VLFRECC,PesqPict('SW6','W6_VLFRECC'))),"")
				DbSelectArea("SWD")
				SWD->(DbSetOrder(1))
				If SWD->(DbSeek(xFilial("SWD")+SF1->F1_HAWB+"494"))
					_cMensCli += "TAXA SISCOMEX " + Transform(SWD->WD_VALOR_R,PesqPict('SWD','WD_VALOR_R'))
				EndIF
				If SWD->(DbSeek(xFilial("SWD")+SF1->F1_HAWB+"507"))
					_cMensCli += " ARMAZENAGEM " + Transform(SWD->WD_VALOR_R,PesqPict('SWD','WD_VALOR_R'))
				EndIF
				_cMensCli += CRLF
				_cMensCli += iif(SW6->W6_TX_US_D>0," TAXA FISCAL R$ "+Transform(SW6->W6_TX_US_D,"@E 999,999.9999"),"")
				_cMensCli += iif(SW6->W6_TX_US_D>0," EUR R$"+Transform(SW6->W6_TX_US_D,"@E 999,999.9999"),"")
				_cMensCli += iif(SF1->F1_VALPIS>0," PIS "+Transform(SF1->F1_VALPIS,"@E 999,999.9999"),"")
				_cMensCli += iif(SF1->F1_VALCOFI>0," COFINS "+Transform(SF1->F1_VALCOFI,"@E 999,999.9999"),"")
				If SWD->(DbSeek(xFilial("SWD")+SF1->F1_HAWB+"201"))
					_cMensCli += " II " + Transform(SWD->WD_VALOR_R,PesqPict('SWD','WD_VALOR_R'))
				EndIF
				_cMensCli += CRLF
				//					_cMensCli += iif(Val(oTotal:_ICMSTOT:_vOutro:TEXT)>0," Despesas aduaneiras "+Transform(Val(oTotal:_ICMSTOT:_vOutro:TEXT),"@E 999,999.9999"),"")
				_cMensCli += CRLF
				_cMensCli += IIF(!EMPTY(ALLTRIM(SW6->W6_DI_NUM)),"DI: "+ALLTRIM(SW6->W6_DI_NUM),"")
				_cMensCli += CRLF
				_cMensCli += IIF(!EMPTY(ALLTRIM(SW6->W6_LOCALN))," LOCAL DESEMBARACO: "+ALLTRIM(SW6->W6_LOCALN),"")
			EndIF
		EndIf

		CD2->(dBSetOrder(2)) //CD2_FILIAL+CD2_TPMOV+CD2_SERIE+CD2_DOC+CD2_CODFOR+CD2_LOJFOR+CD2_ITEM+CD2_CODPRO+CD2_IMP
		For nI := 1 to len(aProd)
			nPauta := 0
			If CD2->(DbSeek(xFilial('CD2')+"E"+SD1->D1_SERIE+SD1->D1_DOC+SF1->F1_FORNECE+SF1->F1_LOJA+StrZero(APROD[nI][01],TamSX3("D1_ITEM")[1])))
				While CD2->(!Eof()) .and. ;
				xFilial('CD2')+"E"+SD1->D1_SERIE+SD1->D1_DOC+SF1->F1_FORNECE+SF1->F1_LOJA+StrZero(APROD[nI][01],TamSX3("D1_ITEM")[1]) == ;
				CD2->(CD2_FILIAL+CD2_TPMOV+CD2_SERIE+CD2_DOC+CD2_CODFOR+CD2_LOJFOR+CD2_ITEM)
					If CD2->CD2_PAUTA > 0
						nPauta += CD2->CD2_PAUTA
						EXIT
					EndIf
					CD2->(dbSkip())
				Enddo
				If nPauta > 0
					APROD[nI][04] := Alltrim(APROD[nI][04])+" (" + Alltrim(Transform(nPauta,"@E 999,999,999.99" )) + ")"
				Endif
			EndIf
		Next nI

		//Informações do veículo para operações internas, uma vez que a mesma não será mais necessária para a Nota Fiscal 4.0 - Natanael Simões
		If !SuperGetMV("MV_INTTRAN",.T.,.T.) .AND.  Len(aVeiculo) > 0 // Parametro que define se as tags <veicTransp> e <reboque>, seram geradas em operações internas.
			If SM0->M0_ESTCOB <> aDest[09] //UF Destino
				cMensCli += "||Veiculo: Placa " + Alltrim(aVeiculo[01]) + ", UF: " + Alltrim(aVeiculo[02])
				If !Empty(Alltrim(aVeiculo[03]))
					cMensCli += ", RNTC: " + Alltrim(aVeiculo[03])
				EndIF
			EndIf
		EndIf
		///

		cMensCli += u_MGF_NOAC(alltrim(_cMensCli )) //Retira caracteres especiais
		cMensCli := STRTRAN(cMensCli,'"','')

		//-----------------------------------------------------------------------------------
		//GAP133/MGFFIS35 - Alteração da data de Entrega para a Operação Busca de Gado - GO
		//Adiciona no topo do array a data que será informada no Campo Data de saída do DANFE.
		//Essa informação será utilizada no fonte NFESEFAZ para preenchimento da TAG <dhSaiEnt>
		//-----------------------------------------------------------------------------------
		If lMGFFIS35
			If SF1->(FieldPos("F1_ZDTBUSC"))>0 .AND.  len(aNota)=6 //Data de Busca de Gado
				If !Empty(SF1->F1_ZDTBUSC) //Deve setificar-se que o array possui 6 posições para uso da mesma no NFESEFAZ
					aadd(aNota,SF1->F1_ZDTBUSC)
				EndIf
			Else
				Help( ,, 'PE01NFESEFAZ_01',, 'É necessário compatibilizar o fonte para o GAP133.', 1, 0)
			EndIf
		EndIf


		//Ajuste das casas decimais da quantidade - GAP372 - Natanael, 20/06/2018.
		For nI := 1 to Len(aProd) Step 1
			aProd[nI,12] := NoRound(aProd[nI,12],3)
		Next
		//

		aadd( aRetorno, aProd)
		aadd( aRetorno, cMensCli	)
		aadd( aRetorno, cMensFis	)
		aadd( aRetorno, aDest		)
		aadd( aRetorno, aNota		)
		aadd( aRetorno, aInfoItem	)
		aadd( aRetorno, aDupl		)
		aadd( aRetorno, aTransp		)
		aadd( aRetorno, aEntrega	)
		aadd( aRetorno, aRetirada	)
		aadd( aRetorno, aVeiculo	)
		aadd( aRetorno, aReboque	)
		aadd( aRetorno, aNfVincRur	)
		aadd( aRetorno, aEspVol 	)
		aadd( aRetorno, aNfVinc 	)
		aadd( aRetorno, aAdetPag)
		aadd( aRetorno, aObsCotAux  )

		restArea(aAreaSC6)
		restArea(aAreaSC5)
		restArea(aAreaSF7)
		restArea(aAreaSF4)
		restArea(aAreaSA2)
		restArea(aAreaSA1)
		restArea(aAreaCD2)
		restArea(aAreaSM4)
		restArea(aAreaDAK)
		restArea(aAreaDA3)
		restArea(aAreaSFT)
		restArea(aArea)

		return aRetorno

	Else

		If IsInCallStack("MATA103")
			aRetorno := {}
			Return aRetorno
		EndIf

		SC6->(DBGoTop())
		SC6->(dbSetOrder(4))
		SC6->( DbSeek( xFilial("SC6") + SF2->F2_DOC + SF2->F2_SERIE) )

		SC5->(DBGoTop())
		SC5->(dbSetOrder(1))
		SC5->( MsSeek( xFilial("SC5") + SC6->C6_NUM ) )


		// Manipulação do endereço de entrega
		// Roberto 14/09/16
		If Findfunction ('u_RetEndXML')
			If !Empty(SC5->C5_ZIDEND)
				_cMensCli += u_RetEndXML(SF2->F2_CLIENTE,SF2->F2_LOJA,SC5->C5_ZIDEND)
			EndIf
		Endif


		//nPedido := val(SC6->C6_NUM) // Comentado por Barbieri pois a numeração dos pedidos chegou no 999999
		//cPedido := alltrim(str(nPedido)) // Barbieri
		cPedido := SC6->C6_NUM // Barbieri

		_cMensCli += "||PEDIDO PROTHEUS "+ cPedido + "||"//CRLF


		If !Empty(SC5->C5_ZMENNOT)
			_cMensCli += "| " + ALLTRIM(SC5->C5_ZMENNOT)//Carneiro
		EndIf

		If !Empty(SC5->C5_ZMENEXP)
			_cMensCli += "| " + ALLTRIM(SC5->C5_ZMENEXP) //Natanael Filho
		EndIf

		///Valor do Frete
		/*If cFilant $ cFilfre*/ // Trecho Removido, pois a mensagem será exibida para todas as unidades
		If .T.
			dBselectArea('DAI')
			dbSetOrder(3) //DAI_FILIAL+DAI_NFISCA+DAI_SERIE+DAI_CLIENT+DAI_LOJA
			If DbSeek(xFilial('DAI')+SF2->F2_DOC + SF2->F2_SERIE )
				DAK->(DBGoTop())
				DAK->(DbSetOrder(1))
				DAK->(dbSeek(xFilial('DAK')+DAI->DAI_COD+DAI->DAI_SEQCAR))
		
				//GRAVA PLACA DO VEÍCULO
				DbSelectArea('DA3')
				DA3->(DbSetOrder(1))
				If DA3->(Msseek(xFilial('DA3') + DAK->DAK_CAMINH))
				
					_cMensCli += "| PLACA: " + DA3->DA3_PLACA
					
				EndIf
				dBselectArea('SA4')
				dbSetOrder(1) //M4_FILIAL+M4_CODIGO
				If DbSeek(xFilial('SA4')+DAK->DAK_TRANSP)

					dBselectArea('SA1')
					dbSetOrder(1) //M4_FILIAL+M4_CODIGO
					If DbSeek(xFilial('SA1')+SF2->F2_CLIENTE + SF2->F2_LOJA)
						nAliqFre := Val(Subs(cAliqFre,AT(SA1->A1_EST,cAliqFre)+2,2))
						If nAliqFre > 0
							If ALLTRIM(SM0->M0_ESTENT) <> ALLTRIM(SA4->A4_EST)
								If nAliqFre > 0

									dBselectArea('DAI')
									dbSetOrder(4) //DAI_FILIAL+DAI_PEDIDO+DAI_COD+DAI_SEQCAR
									If DbSeek(xFilial('DAI')+SC5->C5_NUM)

										If DAI->DAI_ZFRESI > 0
											nFrete := DAI->DAI_ZFRESI
											nICMS := DAI->DAI_ZFRESI * nAliqFre / 100
											//					 cICMS := str(nICMS)
											cFrete := Transform(nFrete,"@E 999,999,999.99" )
											cICMS := Transform(nICMS,"@E 999,999,999.99" )
											//_cMensCli += "FRETE ICMS P/ST CFE Livro III ART. 54 e 56 DEC 37699/97 VALOR DO FRETE R$ " + alltrim(cFrete)+ " ICMS FRETE R$ " + alltrim(cICMS)
											dBselectArea('SM4')
											dbSetOrder(1) //M4_FILIAL+M4_CODIGO
											If DbSeek(xFilial('SM4')+ alltrim(cMsgFrete))
												_cMensCli += "| " + Alltrim(FORMULA(cMsgFrete)) + alltrim(cFrete)+ " ICMS FRETE R$ " + alltrim(cICMS)
											EndIf
										EndIf
									EndIf
								Endif
							Else
								dBselectArea('SM4')
								If DbSeek(xFilial('SM4')+ alltrim(cFormula))
									_cMensCli +=  "| " + ALLTRIM(FORMULA(cFormula))
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			Else

				dBselectArea('SA4')
				dbSetOrder(1)
				If DbSeek(xFilial('SA4')+SC5->C5_TRANSP)

					dBselectArea('SA1')
					dbSetOrder(1) //M4_FILIAL+M4_CODIGO
					If DbSeek(xFilial('SA1')+SF2->F2_CLIENTE + SF2->F2_LOJA)
						nAliqFre := Val(Subs(cAliqFre,AT(SA1->A1_EST,cAliqFre)+2,2))
						If ALLTRIM(SM0->M0_ESTENT) <> ALLTRIM(SA4->A4_EST)
							If nAliqFre > 0
								If SC5->(C5_FRETAUT+C5_ZVLFRET) > 0
									nFrete := (C5_FRETAUT+C5_ZVLFRET)
									nICMS := (C5_FRETAUT+C5_ZVLFRET) * nAliqFre / 100

									cFrete := Transform(nFrete,"@E 999,999,999.99" )
									cICMS := Transform(nICMS,"@E 999,999,999.99" )

									dBselectArea('SM4')
									dbSetOrder(1) //M4_FILIAL+M4_CODIGO
									If DbSeek(xFilial('SM4')+ alltrim(cMsgFrete))
										_cMensCli +=  "| " + Alltrim(FORMULA(cMsgFrete)) + ' ' + alltrim(cFrete)+ " ICMS FRETE R$ " + alltrim(cICMS)
									EndIf
								EndIf
							EndIf
						Else
							dBselectArea('SM4')
							If DbSeek(xFilial('SM4')+ alltrim(cFormula))
								_cMensCli +=  "| " + ALLTRIM(FORMULA(cFormula)) 
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf

		If SC5->C5_TIPO <> "B"
			If ALLTRIM(SA1->A1_XMENS1) <> ""
				dBselectArea('SM4')
				If DbSeek(xFilial('SM4')+ALLTRIM(SA1->A1_XMENS1))
					If !AllTrim(FORMULA(SA1->A1_XMENS1)) $ _cMensCli
						_cMensCli += "| " + ALLTRIM(FORMULA(SA1->A1_XMENS1))//CRLF
					EndIf
				EndIf
			EndIf
			If ALLTRIM(SA1->A1_XMENS2) <> ""
				dBselectArea('SM4')
				If DbSeek(xFilial('SM4')+ALLTRIM(SA1->A1_XMENS2))
					If !AllTrim(FORMULA(SA1->A1_XMENS2)) $ _cMensCli
						_cMensCli += "| " + ALLTRIM(FORMULA(SA1->A1_XMENS2))//CRLF
					Endif
				EndIf
			EndIf
		EndIf

		/// Mensagem do cadastro de fornecedores
		If SC5->C5_TIPO = "B"
			If ALLTRIM(SA2->A2_XMENS1) <> ""
				dBselectArea('SM4')
				If DbSeek(xFilial('SM4')+ALLTRIM(SA2->A1_XMENS1))
					If !AllTrim(FORMULA(SA2->A1_XMENS1)) $ _cMensCli
						_cMensCli +=  "| " + ALLTRIM(FORMULA(SA2->A1_XMENS1))//CRLF
					EndIf
				EndIf
			EndIf
			If ALLTRIM(SA2->A2_XMENS2) <> ""
				dBselectArea('SM4')
				If DbSeek(xFilial('SM4')+ALLTRIM(SA2->A2_XMENS2))
					If !AllTrim(FORMULA(SA2->A2_XMENS2)) $ _cMensCli
						_cMensCli += "| " + ALLTRIM(FORMULA(SA2->A2_XMENS2))//CRLF
					EndIf
				EndIf
			EndIf
		EndIf

		//// Mensagem do faturista
		If ALLTRIM(SC5->C5_XMSGFT) <> ""
			_cMensCli += "| " + SC5->C5_XMSGFT//CRLF
		EndIf
		//// Mensagem do pedido de vendas
		If ALLTRIM(SC5->C5_XMENS1) <> ""
			dBselectArea('SM4')
			If DbSeek(xFilial('SM4')+ALLTRIM(SC5->C5_XMENS1))
				If !AllTrim(FORMULA(SC5->C5_XMENS1)) $ _cMensCli
					_cMensCli += "| " + ALLTRIM(FORMULA(SC5->C5_XMENS1))//CRLF
				EndIf
			EndIf
		EndIf
		If ALLTRIM(SC5->C5_XMENS2) <> ""
			dBselectArea('SM4')
			If DbSeek(xFilial('SM4')+ALLTRIM(SC5->C5_XMENS2))
				If !AllTrim(FORMULA(SC5->C5_XMENS2)) $ _cMensCli
					_cMensCli += "| " + ALLTRIM(FORMULA(SC5->C5_XMENS2))//CRLF
				EndIf
			EndIf
		EndIf

		//For nT := 1 to Len(aInfoItem)

		///Verifica se há mensagem para o produto.
		dBselectArea('SB1')
		dbSetOrder(1) //B1_FILIAL+B1_COD
		If DbSeek(xFilial('SB1')+SC6->C6_PRODUTO)
			If ALLTRIM(SB1->B1_XMENS1) <> ""
				dBselectArea('SM4')
				If DbSeek(xFilial('SM4')+ALLTRIM(SB1->B1_XMENS1))
					If !AllTrim(FORMULA(SB1->B1_XMENS1)) $ _cMensCli
						_cMensCli += "| " + ALLTRIM(FORMULA(SB1->B1_XMENS1))//CRLF
					EndIf
				EndIf
			EndIf
			If ALLTRIM(SB1->B1_XMENS2) <> ""
				dBselectArea('SM4')
				If DbSeek(xFilial('SM4')+ALLTRIM(SB1->B1_XMENS2))
					If !AllTrim(FORMULA(SB1->B1_XMENS2)) $ _cMensCli
						_cMensCli += "| " + ALLTRIM(FORMULA(SB1->B1_XMENS2))//CRLF
					EndIf
				EndIf
			EndIf
		EndIf
		//Next nT

		SF4->(dbSetOrder(1)) //F4_FILIAL+F4_CODIGO
		SD2->(dbSetOrder(3))
		SB1->(dbSetOrder(1))
		If SD2->(DbSeek(xFilial('SD2')+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA))
			While !SD2->(Eof()) .and. xFilial('SD2')+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA == ;
			SD2->(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA)
				If SF4->(DbSeek(xFilial('SF4')+SD2->D2_TES))
					////Mensagem da 1 TES
					If ALLTRIM(SF4->F4_XMENS1) <> ""
						dBselectArea('SM4')
						If DbSeek(xFilial('SM4')+ALLTRIM(SF4->F4_XMENS1))
							If !AllTrim(FORMULA(SF4->F4_XMENS1)) $ _cMensCli
								_cMensCli += "| " + ALLTRIM(FORMULA(SF4->F4_XMENS1))//CRLF
							EndIf
						EndIf
					EndIf
					////Mensagem da 2 TES
					If ALLTRIM(SF4->F4_XMENS2) <> ""
						dBselectArea('SM4')
						If DbSeek(xFilial('SM4')+ALLTRIM(SF4->F4_XMENS2))
							If !AllTrim(FORMULA(SF4->F4_XMENS2)) $ _cMensCli
								_cMensCli += "| " + ALLTRIM(FORMULA(SF4->F4_XMENS2))//CRLF
							EndIf
						EndIf
					EndIf
				Endif
				If SB1->(dbSeek(xFilial("SB1")+SD2->D2_COD))
					MensExcFis(SA1->A1_GRPTRIB,SA1->A1_EST,@_cMensCli)
				Endif

				SD2->(dbSkip())
			Enddo
		Endif
		If !EMPTY(ALLTRIM(SC5->C5_PEDEXP))
			If SC5->C5_TIPO = "C"
				cNfOri		:= GetAdvFVal("SD2","D2_NFORI",xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA,3,"")
				cPedOri		:= GetAdvFVal("SD2","D2_PEDIDO",xFilial("SD2")+cNfOri+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA,3,"")
				nMoeOri		:= GetAdvFVal("SC5","C5_MOEDA",xFilial("SC5")+cPedOri,1,0)
				nTx			:= GetAdvFVal("SM2","M2_MOEDA"+Alltrim(Str(nMoeOri)),SF2->F2_EMISSAO,1,0)
				_cMensCli += " Taxa Cambial : "+GetMv("MV_SIMB"+Alltrim(Str(nMoeOri)))+ " "+Alltrim(Str(nTx,6,4)) +CRLF
				_cMensCli += " Nota Fiscal Complementar "+CRLF
			Else
				cPedOri		:= GetAdvFVal("SD2","D2_PEDIDO",xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA,3,"")
				nMoeOri		:= GetAdvFVal("SC5","C5_MOEDA",xFilial("SC5")+cPedOri,1,0)
				nTx			:= GetAdvFVal("SM2","M2_MOEDA"+Alltrim(Str(nMoeOri)),SF2->F2_EMISSAO,1,0)
				cOrdem		:= GetAdvFVal("ZZR","ZZR_CARGA",xFilial("ZZR")+PADR(SC5->C5_NUM,20),1,0)
				_cMensCli += " Ordem de Embarque : "+ cOrdem +CRLF
				_cMensCli += " EXP  : "+ ALLTRIM(SC5->C5_PEDEXP) +CRLF
				_cMensCli += " Taxa Cambial : "+ GetMv("MV_SIMB"+Alltrim(Str(nMoeOri)))+ " "+Alltrim(Str(nTx,6,4)) + CRLF
			EndIf
		EndIf


		CD2->(dBSetOrder(1)) //CD2_FILIAL+CD2_TPMOV+CD2_SERIE+CD2_DOC+CD2_CODCLI+CD2_LOJCLI+CD2_ITEM+CD2_CODPRO+CD2_IMP
		For nI := 1 to len(aProd)
			nPauta := 0
			If CD2->(DbSeek(xFilial('CD2')+"S"+SF2->F2_SERIE+SF2->F2_DOC+SF2->F2_CLIENTE+SF2->F2_LOJA+StrZero(APROD[nI][01],TamSX3("D2_ITEM")[1])))
				While CD2->(!Eof()) .and. ;
				xFilial('CD2')+"S"+SF2->F2_SERIE+SF2->F2_DOC+SF2->F2_CLIENTE+SF2->F2_LOJA+StrZero(APROD[nI][01],TamSX3("D2_ITEM")[1]) == ;
				CD2->(CD2_FILIAL+CD2_TPMOV+CD2_SERIE+CD2_DOC+CD2_CODCLI+CD2_LOJCLI)+Alltrim(CD2->CD2_ITEM)
					If CD2->CD2_PAUTA > 0
						nPauta += CD2->CD2_PAUTA
						EXIT
					EndIf
					CD2->(dbSkip())
				Enddo
				If nPauta > 0
					APROD[nI][04] := Alltrim(APROD[nI][04])+" (" + Alltrim(Transform(nPauta,"@E 999,999,999.99" )) + ")"
					MensPauta(SM0->M0_ESTENT,@_cMensCli)
				Endif
			EndIf
			//Inclusão informação de quantidade de caixas SOMENTE EXPORTAÇÃO

			//If !Empty(GetAdvFVal("SC5","C5_PEDEXP",xFilial("SC5")+APROD[nI][38],1,""))
				DbSelectArea("ZZR")
				ZZR->(DbSetOrder(1))
				//Informações da linha do produto do NFESEFAZ
				//7==>cD2Cfop,;
				//8==>SB1->B1_UM,;
				//9==>(cAliasSD2)->D2_QUANT,;
				//11==>IIF(Empty(SB5->B5_UMDIPI),SB1->B1_UM,SB5->B5_UMDIPI),;
				//12==>IIF(Empty(SB5->B5_CONVDIP),(cAliasSD2)->D2_QUANT,SB5->B5_CONVDIP*(cAliasSD2)->D2_QUANT),;
				//38-Pedido 39-Item Pedido
				cEspecie		:= GetAdvFVal("SC5","C5_ESPECI1",xFilial("SC5")+APROD[nI][38],1,"")
				If ZZR->( DbSeek( xFilial("ZZR")+PADR(APROD[nI][38],20)+strzero(val(APROD[nI][39]),2) ) )
					//Peso Liquido na Segunda Unidade de medida se for Kg
					If Alltrim(aProd[nI][11]) == "KG" .and. Alltrim(aProd[nI][11]) <> Alltrim(aProd[nI][08])
						If GetAdvFVal("SC5","C5_TIPO",xFilial("SC5")+APROD[nI][38],1,"") <> 'C'
							aProd[nI][12] := ZZR->ZZR_PESOL
						Endif
					EndIf
					//Quantidade de caixas nas informações complementares do pedido
					If ZZR->ZZR_TOTCAI > 0
						aprod[nI][25] += " Qtd."+Alltrim(cEspecie)+": "+Alltrim(Transform(ZZR->ZZR_TOTCAI,"@E 999,999"))  //Informações adicinais
					Endif
				Elseif !Empty(GetAdvFVal("SC5","C5_PEDEXP",xFilial("SC5")+APROD[nI][38],1,""))

					cPedOri		:= GetAdvFVal("SC5","C5_PEDEXP",xFilial("SC5")+APROD[nI][38],1,"")
					aPedExp := QtdCaixas(cPedOri,PADR(APROD[nI][39],2))
					//Quantidade de caixas nas informações complementares do pedido
					If Len(aPedExp) > 0 .and. (aPedExp[1] > 0 )
						aprod[nI][25] += " Qtd."+Alltrim(cEspecie)+": "+Alltrim(Transform(aPedExp[1],"@E 999,999"))  //Informações adicinais
					EndIf
					//Peso Liquido na Segunda Unidade de medida se for Kg
					If Len(aPedExp) > 1 .and. (aPedExp[2] > 0 ).and. Alltrim(aProd[1][11]) == "KG" .and. Alltrim(aProd[nI][11]) <> Alltrim(aProd[nI][08])
						If GetAdvFVal("SC5","C5_TIPO",xFilial("SC5")+APROD[nI][38],1,"") <> 'C'
							aProd[nI][12] := aPedExp[2]
						Endif
					EndIf
				EndIf
			//EndIf

			cInfHabil		:= GetAdvFVal("SC5","C5_ZHABIL",xFilial("SC5")+PADR(APROD[nI][38],20),1,"")
			If !Empty(Alltrim(cInfHabil))
				aprod[nI][25] += " "+Alltrim(cInfHabil)
			EndIF
			
			//Natanael Filho, 25-04-2019
			//Mensagem para impressão do ICMS RJ nas unidades do Rio de Janeiro - Art
			
			//Posiciona na SFT para retornar os valores do ICMS Retido
			SFT->(DbSelectArea("SFT"))
			SFT->(DBSetOrder(1)) //FT_FILIAL+FT_TIPOMOV+FT_SERIE+FT_NFISCAL+FT_CLIEFOR+FT_LOJA+FT_ITEM+FT_PRODUTO
			If SFT->(DBSeek(xFilial("SFT")+"S"+SF3->F3_SERIE+SF3->F3_NFISCAL+SF3->F3_CLIEFOR+SF3->F3_LOJA + Pad( aProd[nI][39],TamSX3("FT_ITEM")[1]) + aProd[nI][2]))
				If SFT->FT_BSTANT > 0 .AND. SFT->FT_VSTANT > 0 .AND. SFT->FT_PSTANT > 0
					If aProd[nI][48] == "1"; // Origem da informação: F4_ART274
					 	.AND. IIF(!SuperGetMV("MV_SPEDEND",.T.,.T.),Alltrim(SM0->M0_ESTCOB),Alltrim(SM0->M0_ESTENT)) == "RJ"; //lEndFis:= MV_SPEDEND: Configurar a NF-e SEFAZ quanto ao endereco que dev	e ser considerado. T = Endereco de entrega ou F = 	Endereco de cobranca.
					 	.AND. aProd[nI][23] == "60" //CST
						cMensFis += " ICMS RECOLHIDO ANTECIPADO POR SUBS. TRIBUTARIA CONF. INC. II ART 27 DO LIVRO II, E ITEM 23 DO ANEXO I DO LIVRO II DO RICMS" +;
							", onde o 'Cod.Produto:  " +Alltrim(aProd[nI][02])+" '  Valor da Base de ST: R$ " +Alltrim(str(SFT->FT_BSTANT,15,2))+" Valor de ICMS ST: R$ "+Alltrim(str(SFT->FT_VSTANT,15,2))+" "
					EndIf
				EndIf
			EndIf


		Next nI




	EndIf

	//Informações do veículo para operações internas, uma vez que a mesma não será mais necessária para a Nota Fiscal 4.0 - Natanael Simões
	If SuperGetMV("MV_INTTRAN",.T.,.T.) .AND.  Len(aVeiculo) > 0 // Parametro que define se as tags <veicTransp> e <reboque>, seram geradas em operações internas.
		If SM0->M0_ESTCOB <> aDest[09] //UF Destino
			cMensCli += "|| Veiculo: Placa " + Alltrim(aVeiculo[01]) + ", UF: " + Alltrim(aVeiculo[02])
			If !Empty(Alltrim(aVeiculo[03]))
				cMensCli += ", RNTC: " + Alltrim(aVeiculo[03])
			EndIF
		EndIf
	EndIf
	///


	//Mensagem para Nota Fiscal sobre o sistema de re-impressão do boleto pelo Cliente - Natanael Filho - 20181114
	_msgFINB0 := SuperGetMV("MGF_FINB0A",.T.,"2ª Via de boletos, favor acessar o portal https://www.portaldeboletos.com.br/MARFRIG-PORTAL-BOLETOS")
	If !Empty(Alltrim(_msgFINB0))
		cMensCli += "||" + _msgFINB0
	EndIf
	///


	cMensCli += ' '+ u_MGF_NOAC(alltrim(_cMensCli )) //Retira caracteres especiais

	cMensCli := STRTRAN(cMensCli,'"','')


	//Ajuste das casas decimais da quantidade - GAP372 - Natanael, 20/06/2018.
	For nI := 1 to Len(aProd) Step 1
		aProd[nI,12] := NoRound(aProd[nI,12],3)
	Next
	//

	aadd( aRetorno, aProd		)
	aadd( aRetorno, cMensCli	)
	aadd( aRetorno, cMensFis	)
	aadd( aRetorno, aDest		)
	aadd( aRetorno, aNota		)
	aadd( aRetorno, aInfoItem	)
	aadd( aRetorno, aDupl		)
	aadd( aRetorno, aTransp		)
	aadd( aRetorno, aEntrega	)
	aadd( aRetorno, aRetirada	)
	aadd( aRetorno, aVeiculo	)
	aadd( aRetorno, aReboque	)
	aadd( aRetorno, aNfVincRur	)
	aadd( aRetorno, aEspVol 	)
	aadd( aRetorno, aNfVinc 	)
	aadd( aRetorno, aAdetPag)
	aadd( aRetorno, aObsCotAux  )


	restArea(aAreaSC6)
	restArea(aAreaSC5)
	restArea(aAreaSF7)
	restArea(aAreaSF4)
	restArea(aAreaSA2)
	restArea(aAreaSA1)
	restArea(aAreaCD2)
	restArea(aAreaSM4)
	restArea(aAreaSD2)
	restArea(aAreaDAK)
	restArea(aAreaDA3)
	restArea(aAreaSFT)
	restArea(aArea)


return aRetorno


Static Function MensPauta(cEst,_cMensCli)

	Local cQ := ""
	Local cAliasTrb := GetNextAlias()
	Local aArea := {GetArea()}

	cQ := "SELECT CFC_ZMENPA "
	cQ += "FROM "+RetSqlName("CFC")+" CFC "
	cQ += "JOIN "+RetSqlName("SD2")+" SD2 "
	cQ += "ON SD2.D_E_L_E_T_ <> '*' "
	cQ += "AND D2_FILIAL = '"+SF2->F2_FILIAL+"' "
	cQ += "AND D2_SERIE = '"+SF2->F2_SERIE+"' "
	cQ += "AND D2_DOC = '"+SF2->F2_DOC+"' "
	cQ += "AND D2_CLIENTE = '"+SF2->F2_CLIENTE+"' "
	cQ += "AND D2_LOJA = '"+SF2->F2_LOJA+"' "
	cQ += "AND D2_EMISSAO = '"+dTos(SF2->F2_EMISSAO)+"' "
	cQ += "WHERE "
	cQ += "CFC.D_E_L_E_T_ <> '*' "
	cQ += "AND CFC_FILIAL = '"+xFilial("CFC")+"' "
	cQ += "AND CFC_UFORIG = '"+cEst+"' "
	cQ += "AND CFC_CODPRD = D2_COD "
	cQ += "AND CFC_ZMENPA <> ' ' "
	cQ += "GROUP BY CFC_ZMENPA "
	cQ += "ORDER BY CFC_ZMENPA "

	cQ := ChangeQuery(cQ)

	dbUseArea(.T.,"TOPCONN",tcGenQry(,,cQ),cAliasTrb,.T.,.T.)

	While (cAliasTrb)->(!Eof())
		If !AllTrim(Formula((cAliasTrb)->CFC_ZMENPA)) $ _cMensCli
			_cMensCli += "| " + AllTrim(Formula((cAliasTrb)->CFC_ZMENPA))//CRLF
		EndIf
		(cAliasTrb)->(dbSkip())
	Enddo

	(cAliasTrb)->(dbCloseArea())

	aEval(aArea,{|x| RestArea(x)})

Return()


// precisa estar com o SB1 posicionado
Static Function MensExcFis(cGrupo,cEst,_cMensCli)

	Local aArea := {SF7->(GetArea()),GetArea()}

	If !Empty(SB1->B1_GRTRIB)
		SF7->(dbSetOrder(1)) //F7_FILIAL+F7_GRTRIB
		If SF7->(DbSeek(xFilial("SF7")+SB1->B1_GRTRIB))
			While SF7->(!Eof()) .and. xFilial("SF7")+SB1->B1_GRTRIB == SF7->F7_FILIAL+SF7->F7_GRTRIB
				If SF7->F7_GRPCLI == cGrupo .and. (SF7->F7_EST == cEst .or. SF7->F7_EST == "**") .and. !Empty(SF7->F7_XMENS1)
					If !AllTrim(Formula(SF7->F7_XMENS1)) $ _cMensCli
						_cMensCli += "| " + AllTrim(Formula(SF7->F7_XMENS1))//CRLF
					EndIf
					Exit
				Endif
				SF7->(dbSkip())
			Enddo
		Endif
	Endif

	aEval(aArea,{|x| RestArea(x)})

Return()



/*/{Protheus.doc} QtdCaixas
//TODO Retorna Informações do Pedido de Exportação
@author leonardo.kume
@since 24/04/2018
@version 6
@return array, [1] qtd Caixas, [2]Peso
@param cPed, characters, descricao
@param cItem, characters, descricao
@type function
/*/
Static Function QtdCaixas(cPed,cItem)

	Local cQ 		:= ""
	Local cAliasTrb := GetNextAlias()
	Local aArea 	:= {GetArea()}
	Local nCaixas 	:= 0
	Local nPeso 	:= 0
	Local aRet		:= {}

	cQ := "select EE8_QTDEM1, EE8_PSLQTO from "+RetSqlName("EE8")+" " + CRLF
	cQ += " where   EE8_FILIAL = '"+xFilial("EE8")+"' AND " + CRLF
	cQ += " 	EE8_PEDIDO = '"+cPed+"' AND " + CRLF
	cQ += " 	EE8_FATIT = '"+cItem+"' AND " + CRLF
	cQ += " 	D_E_L_E_T_ = ' ' "

	cQ := ChangeQuery(cQ)

	dbUseArea(.T.,"TOPCONN",tcGenQry(,,cQ),cAliasTrb,.T.,.T.)

	If (cAliasTrb)->(!Eof())
		nCaixas := (cAliasTrb)->EE8_QTDEM1
		nPeso := (cAliasTrb)->EE8_PSLQTO
		aAdd(aRet,nCaixas)
		aAdd(aRet,nPeso)
	EndIf

	(cAliasTrb)->(dbCloseArea())

	aEval(aArea,{|x| RestArea(x)})

Return(aRet)
