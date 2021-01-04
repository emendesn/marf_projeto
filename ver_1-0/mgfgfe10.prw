#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
/*
=========================================================================================================
Programa.................: GFE1001
Autor:...................: Flavio Dentello
Data.....................: 28/03/2017
Descricao / Objetivo.....: Cadastro de excessoes RCTRC
Doc. Origem..............: GAP - GFE10
Solicitante..............:
Uso......................: 
Obs......................: Criado para regra de descontos de RCTRC
=========================================================================================================
10/07/2020 - Paulo da Mata - RTASK0010971 - Recriacao para PRD em 13/07/2020
*/
User Function GFE1001()

	//���������������������������������������������������������������������Ŀ
	//� Declaracao de Variaveis                                             �
	//�����������������������������������������������������������������������

	Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
	Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

	Private cString := "ZBC"

	dbSelectArea("ZBC")
	dbSetOrder(1)

	AxCadastro(cString,"Excecoes RCTRC",cVldExc,cVldAlt)

Return


/*
=========================================================================================================
Programa.................: GFE1002
Autor:...................: Flavio Dentello
Data.....................: 28/03/2017
Descricao / Objetivo.....: Cadastro de descontos RCTRC
Doc. Origem..............: GAP - GFE10
Solicitante..............: Cliente
Uso......................: 
Obs......................: Criado para regra de descontos de RCTRC
=========================================================================================================
*/

User Function GFE1002()

	//���������������������������������������������������������������������Ŀ
	//� Declaracao de Variaveis                                             �
	//�����������������������������������������������������������������������

	Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
	Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

	Private cString := "ZBB"

	dbSelectArea("ZBB")
	dbSetOrder(1)

	AxCadastro(cString,"Descontos RCTRC",cVldExc,cVldAlt)

Return


////aplica��o do desconto no titulo//////


User Function MGFRCTRC()
//>>> criacao do paramtro MGF_RCTRCA para determinar qual o tipo a ser usado no desconto de conveniencia


	Local nOpcao    := PARAMIXB[1]   // Opcao Escolhida pelo usuario no aRotina
	Local nConfirma := PARAMIXB[2]   // Se o usuario confirmou a operacao de gravacao da NFECODIGO DE APLICA��O DO USUARIO.....
	Local lRet      := .T.
	Local cQuery	:= ""
	Local cAlias1	:= ""
	Local cAlias2   := ""
	Local cTpPed    := SuperGetMv('MGF_TPREF'  , NIL, '')
	//Local cTpfis    := SuperGetMv('MGF_FRCTRC' , NIL, '')
	//Local cTpfis2   := SuperGetMv('MGF_2RCTRC' , NIL, '')
	//Local cTpfis3   := SuperGetMv('MGF_3RCTRC' , NIL, '')
	Local cGrupoP   := SuperGetMv('MGF_GRPPRO' , NIL, '')
	Local cTpDesc   := SuperGetMv('MGF_TPVAL ' , NIL, '')//PARAMETRO FINANCEIRO DE TIPO DE DESCONTO
	Local cTN		:= SuperGetMv('MGF_FATTN')
//	Local _cDRCTRC  := " "
	Local _lDConv   :=  .F.
	Local _cHist    := " "
	Local _nVlDesc  := 0		//valor do desconto por conveniencia
	Local _aParcel	:=	{}
	Local _nN		:= 0
	Local _lRctrc   := .T. // flag determina se deve ou nao executar o desconto RCTRC - caiu num excecao
	Local Lentra	:=	.F.
	Local _lOK		:= .T.
	Local _cKeySE2	:=	""

	Local _aParcel1  := {}
	Local _aParcel2  := {}

	Local _nParcel1  := 0
	Local _nParcel2  := 0

	If !ExisteSx6("MGF_RCTRCA")
		CriarSX6("MGF_RCTRCA", "C", "Determina tipo de Desconto conveniencia seguro", "660" )
	EndIf
	cTpDCon   := SuperGetMv('MGF_RCTRCA' , NIL, '')		// Tipo de desconto conveniencia
//fim da inclusao
	aArea 	:= GetArea()
	aAreaGW3	:= GW3->(GetArea())	//DOCUMENTOS DE FRETE
	aAreaGWN	:= GWN->(GetArea())	//ROMANEIOS DE CARGA
	aAreaZDS	:= ZDS->(GetArea())	//TIPO DE VALOR POR TITULOS
	aAreaGW4	:= GW4->(GetArea())	//DOCTOS CARGA DOS DOCTOS FRETE
	aAreaGW1	:= GW1->(GetArea())	//DOCUMENTOS DE CARGA
	aAreaSF2	:= SF2->(GetArea())
	aAreaZBC	:= ZBC->(GetArea())  //CADASTRO DE EXCECAO RCTRC
	aAreaSA1	:= SA1->(GetArea())
	aAreaSD2	:= SD2->(GetArea())
	aAreaSC5	:= SC5->(GetArea())
	aAreaSB1	:= SB1->(GetArea())
	aAreaZBB	:= ZBB->(GetArea())	//TIPO VEICULO
	aAreaZF0	:= ZF0->(GetArea())	//CFOP PARA AVERBACAO
	aAreaSE2	:= SE2->(GetArea())
	aAreaSA2	:= SA2->(GetArea())
	//Local oMdlBkp	:= fwModelActive()

	//cTpfis += cTpfis2 + cTpfis3

	If isincallstack('GFEA065') .or. isincallstack('GFEA066') .or. isincallstack('GFEA118') .or. isincallstack('U_MGFGFE45')

		If PARAMIXB[1] == 5
			If SE2->E2_DECRESC <> 0
				if empty(SE2->E2_BAIXA)		//>>> SE HOUVER BAIXA NAO ATUALIZA TABELAS
					if VldCTB(SE2->E2_EMISSAO)	//>>> Valida se esta dentro de um periodo contabil valido
						if SE2->E2_EMISSAO > SuperGetMv('MV_ULMES' , NIL, '')	//verifica se esta posterior ao ultimo fechamento do estoque
							DBSELECTAREA("GW4")
							DBSETORDER(1)
							if 	DBSEEK(XFILIAL("GW4")+GW3->GW3_EMISDF+GW3->GW3_CDESP+GW3->GW3_SERDF+GW3->GW3_NRDF)
								DBSELECTAREA("GW1")
								DBSETORDER(1)
								if DBSEEK(XFILIAL("GW1")+GW4->GW4_TPDC+GW4->GW4_EMISDC+GW4->GW4_SERDC+GW4->GW4_NRDC)
									DBSELECTAREA("GWN")
									DBSETORDER(1)
									if DBSEEK(XFILIAL("GWN")+GW1->GW1_NRROM)

										RecLock("GWN",.F.)
										GWN->GWN_ZRCTRC := "1"  //1=Nao
										MsUnLock()
									endif
								endif
							endif

							//Deleta o registro da tabela espec�fica Tipo de Valor por Titulos
				DbSelectArea('ZDS')
				ZDS->(DbSetOrder(1))//ZDS_FILIAL+ZDS_PREFIX+ZDS_NUM+ZDS_PARCEL+ZDS_TIPO+ZDS_FORNEC+ZDS_LOJA
				if ZDS->(MsSeek(xFilial('ZDS') +  SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO + SE2->E2_FORNECE + SE2->E2_LOJA))
					while !eof() .and.  SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO + SE2->E2_FORNECE + SE2->E2_LOJA == ZDS->ZDS_PREFIX+ZDS->ZDS_NUM+ZDS->ZDS_PARCEL+ZDS->ZDS_TIPO+ZDS->ZDS_FORNEC+ZDS->ZDS_LOJA
						RecLock('ZDS',.F.)
						ZDS->(DbDelete())
						ZDS->(MsUnlock())
						ZDS->(DBSKIP())
					Enddo
				EndIf
								RESTAURA()
							Return
						endif
					endif
				endif
			Else
				RESTAURA()
				Return
			EndIf
		Else //Paramixb<>5

			If GW3->GW3_CDESP = 'ND'  //Documentos de frete
				If !empty(cNaturx)
					DBSELECTAREA("SA2") //ALTERADO RAFAEL 29/11/2018
					DBSETORDER(3)
					IF DBSEEK(XFILIAL("SA2")+GW3->GW3_EMISDF)
						DBSELECTAREA("SE2")
						DBSETORDER(6)
						SE2->(DBGOTOP())
						IF DBSEEK(XFILIAL("SE2")+SA2->A2_COD+SA2->A2_LOJA+Left(GW3->GW3_SERDF,TamSX3("E2_PREFIXO")[1])+Left(GW3->GW3_NRDF,TamSX3("E2_NUM")[1]))
							WHILE SE2->(!EOF()) .AND. SE2->E2_FORNECE==SA2->A2_COD .AND. SE2->E2_LOJA==SA2->A2_LOJA .AND.;
									SE2->E2_PREFIXO==Left(GW3->GW3_SERDF,TamSX3("E2_PREFIXO")[1]) .AND. SE2->E2_NUM==Left(GW3->GW3_NRDF,TamSX3("E2_NUM")[1])
								RecLock("SE2",.F.)
								SE2->E2_NATUREZ := cNaturx
								MsUnLock()
								SE2->(DBSKIP())
							ENDDO
						ENDIF
					ENDIF //FIM ALTERACAO RAFAEL
				EndIf
				RESTAURA()
				Return
			EndIf

			If !empty(cNaturx)
				DBSELECTAREA("SA2") //ALTERADO RAFAEL 29/11/2018
				DBSETORDER(3)
				IF DBSEEK(XFILIAL("SA2")+GW3->GW3_EMISDF)
					DBSELECTAREA("SE2")
					DBSETORDER(6)
					SE2->(DBGOTOP())
					IF DBSEEK(XFILIAL("SE2")+SA2->A2_COD+SA2->A2_LOJA+Left(GW3->GW3_SERDF,TamSX3("E2_PREFIXO")[1])+Left(GW3->GW3_NRDF,TamSX3("E2_NUM")[1]))
						WHILE SE2->(!EOF()) .AND. SE2->E2_FORNECE==SA2->A2_COD .AND. SE2->E2_LOJA==SA2->A2_LOJA .AND.;
								SE2->E2_PREFIXO==Left(GW3->GW3_SERDF,TamSX3("E2_PREFIXO")[1]) .AND. SE2->E2_NUM==Left(GW3->GW3_NRDF,TamSX3("E2_NUM")[1])
							RecLock("SE2",.F.)
							SE2->E2_NATUREZ := cNaturx
							MsUnLock()
							SE2->(DBSKIP())
						ENDDO
					ENDIF
				ENDIF //FIM ALTERACAO RAFAEL
			EndIf

			If GW3->GW3_CDESP = 'CTE'
				lentra := .T.
			Else
				If GW3->GW3_CDESP = 'NFS'
					lentra := .T.
				EndIf
			EndIf
		EndIf
		If lentra
			/////// Verifica se documento de carga � de saida.
			dBselectArea("GW4")  //Doctos de carga dos doctos de frete
			GW4->(dbSetOrder(1))//GW4_FILIAL+GW4_EMISDF+GW4_CDESP+GW4_SERDF+GW4_NRDF+DTOS(GW4_DTEMIS)+GW4_EMISDC+GW4_SERDC+GW4_NRDC+GW4_TPDC
			If GW4->(dbSeek(xFilial("GW4")+GW3->GW3_EMISDF+GW3->GW3_CDESP+GW3->GW3_SERDF+GW3->GW3_NRDF))

				If ALLTRIM(GW4_TPDC) <> 'NFS'  //Tipo do Documento de Carga
					lRet := .F.
					_lRctrc	:=	.F.
				EndIf

				/// Verifica se o tipo de frete � CIF frete e o seguro pagos pelo fornecedor
				dBselectArea("GW1")
				GW1->(dbSetOrder(1))//GW1_FILIAL+GW1_CDTPDC+GW1_EMISDC+GW1_SERDC+GW1_NRDC
				If GW1->(dbSeek(xFilial("GW1")+GW4->GW4_TPDC+GW4->GW4_EMISDC+GW4->GW4_SERDC+GW4->GW4_NRDC))

					If GW1->GW1_TPFRET <> '1' //CIF retorna F
						lRet := .F.
						_lRctrc	:=	.F.
					EndIf

					/***************verifica cadastro de execoes
					Excess�o por Remetente*/
					dBselectArea("SF2")
					SF2->(dbSetOrder(1))//F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO
					If SF2->(dbSeek(xFilial("SF2") + ALLTRIM(GW1->GW1_NRDC) + ALLTRIM(GW1->GW1_SERDC)))

						dBselectArea("ZBC")  //Cadastro de Excecao RCTRC
						ZBC->(dbSetOrder(1))//ZBC_FILIAL+ZBC_CLIENT+ZBC_LJCLI
						If ZBC->(dbSeek(xFilial("ZBC")+SF2->F2_CLIENTE+SF2->F2_LOJA))
							lRet := .F.  //Cliente esta na Excecao RCTRC
							_lRctrc	:=	.F.
						EndIf

					EndIf

					/***************verifica cadastro de execoes
					Excess�o por Destinat�rio*/
					dBselectArea("SA1")
					SA1->(dbSetOrder(3))//A1_FILIAL+A1_CGC
					If SA1->(dbSeek(xFilial("SA1")+GW3->GW3_CDDEST))

						dBselectArea("ZBC")
						ZBC->(dbSetOrder(2))//ZBC_FILIAL+ZBC_CLIENT+ZBC_LJCLI
						If ZBC->(dbSeek(xFilial("ZBC")+SA1->A1_COD+SA1->A1_LOJA))
							lRet := .F.
							_lRctrc	:=	.F.
						EndIf

					EndIf

					/***************verifica cadastro de execoes
					Excess�o pelo CNPJ da Transportadora*/

					dBselectArea("ZBC")
					ZBC->(dbSetOrder(3))//ZBC_FILIAL+ZBC_CLIENT+ZBC_LJCLI
					If ZBC->(dbSeek(xFilial("ZBC")+ALLTRIM(GW3->GW3_EMISDF)))
						lRet := .F.
						_lRctrc	:=	.F.
					EndIf

					/***************verifica cadastro de execoes
					Excess�o pela Placa do ve�culo*/

					dBselectArea("GWN") //Romaneio de Carga
					GWN->(dbSetOrder(1))//GWN_FILIAL+GWN_NRROM
					If GWN->(dbSeek(xFilial("GWN")+GW1->GW1_NRROM))
						///verifica se j� foi aplicado o desconto para algum CT-e desse romaneio
						If GWN->GWN_ZRCTRC == '2'
							lRet := .F.
							_lRctrc	:=	.F.
							_lOK	:= 	.F. // validacao conveniencia
						EndIf

						dBselectArea("ZBC")
						ZBC->(dbSetOrder(4))//ZBC_FILIAL+ZBC_CLIENT+ZBC_LJCLI
						If ZBC->(dbSeek(xFilial("ZBC")+ GWN->GWN_PLACAD))
							If Empty(GWN->GWN_CDTPVC)
								If Empty(GWN->GWN_PLACAD)

									lRet := .F.
									_lRctrc	:=	.F.
								EndIf
							EndIf
						EndIf

					EndIF

					///VERIFICA SE O TIPO DE PEDIDO � REFATURAMENTO
					dBselectArea("SD2")
					SD2->(dbSetOrder(3))//D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
					If SD2->(dbSeek(xFilial("SD2")+ALLTRIM(GW1->GW1_NRDC)+GW1->GW1_SERDC))

						dBselectArea("SC5")
						SC5->(dbSetOrder(3))//D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
						If SC5->(dbSeek(xFilial("SC5")+SD2->D2_PEDIDO))


							If SC5->C5_ZTIPPED $ cTpPed

								lRet := .F.
								_lRctrc	:=	.F.

							ElseIf SC5->C5_ZTIPPED $ cTN
								lRet := .F.
								_lRctrc	:=	.F.

							EndIf
						EndIf


						///// VERIFICA OS PRODUTOS, H� PRODUTOS QUE ESTAO FORA DOS GRUPOS DE PRODUTOS DA EXCESSAO,
						///// SE EXISTIR A ROTINA PROSSEGUIRA.
						///// TAMBEM SERA VERIFICADO SE H� PRODUTOS QUE TENHAM VINCULOS DE GRUPOS DE PRODUTOS QUE
						///// NAO ESTEJAM NO PARAMENTRO DE GRUPOS DE PRODUTOS QUE NAO SERAO UTILIZADOS

						lRet := .F.
						While SD2->(!EOF()) .AND. SD2->(xfilial("SD2")+ALLTRIM(D2_DOC)+ALLTRIM(D2_SERIE)) == GW1->(xFilial("GW1")+ALLTRIM(GW1_NRDC)+GW1_SERDC)

							dBselectArea("SB1")
							SB1->(dbSetOrder(1))//D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM

							DbSelectArea('ZF0')
							ZF0->(DbSetOrder(1))
							If ZF0->(Msseek(xFilial('ZF0') + SD2->D2_CF ))

								//	If SD2->D2_CF $ cTpfis
								If SB1->(dbSeek(xFilial("SB1")+SD2->D2_COD))

									cGrupoP := GrupoPRD()

									If !(ALLTRIM(SB1->B1_GRTRIB) $ ALLTRIM(cGrupoP))
										lRet := .T.
									EndIf

								EndIf
							EndIf
							SD2->(dbSkip())
						Enddo


						/// Encontrou produto ou grupo de produto cadastrado na ZC3
						If !lRet
							_lRctrc	:=	.F.
						EndIf
						// FIM DO PROCESSO DE VERIFICA��O SE PROCEDE O DESCONTO
						// A PARTIR DAQUI ATUALIZA AS TABELAS COM OS DESCONTOS
						///Verificar se o existe regra de desconto/excecao conveniencia
						_cHist   := " "
						_nVlDesc := 0
						_nVlDesc	:=	TEMCONV("2"/*SAIDA*/,SA2->A2_CGC,GWN->GWN_CDTPVC,GWN->GWN_CDTPOP,SC5->C5_ZTIPPED,GWN->GWN_PLACAD,GW3->GW3_DTEMIS)
						IF _nVlDesc	>	0 .and. _lOK
							_lDConv  := .T.
							_cHist   := "Desc. Conveniencia"
						ENDIF

						///////GRAVAR O DESCONTO NO T�TULO A PAGAR
						dBselectArea("ZBB")  //Tipo Veiculo
						ZBB->(dbSetOrder(1)) //D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
						If ZBB->(dbSeek(GWN->GWN_CDTPVC))
							//// Verifica se o valor do documento � maior ou igual ao valor do desconto.
							If GW3->GW3_VLDF >= ZBB->ZBB_VALDES .and. GW3->GW3_VLDF >=  _nVlDesc//GW3 Documentos de frete
								DBSELECTAREA("SA2") //ALTERADO RAFAEL 29/11/2018
								DBSETORDER(3)
								IF DBSEEK(XFILIAL("SA2")+GW3->GW3_EMISDF)
									// FUN��O PARA CHECAR AS PARCELAS E FAZER A DIVIS�O
									if 	_lRctrc
										_aParcel1 := CHKPARC1(XFILIAL("SE2"),SA2->A2_COD,SA2->A2_LOJA,Left(GW3->GW3_SERDF,TamSX3("E2_PREFIXO")[1]),Left(GW3->GW3_NRDF,TamSX3("E2_NUM")[1]),ZBB->ZBB_VALDES)
										nParcel1  := If(Empty(_aParcel1[1]),0,_aParcel1[1])
									endif

									if _lDConv
										_aParcel2 := CHKPARC2(XFILIAL("SE2"),SA2->A2_COD,SA2->A2_LOJA,Left(GW3->GW3_SERDF,TamSX3("E2_PREFIXO")[1]),Left(GW3->GW3_NRDF,TamSX3("E2_NUM")[1]), _nVlDesc)
										nParcel2  := If(Empty(_aParcel2[1]),0,_aParcel2[1])
									endif

									_nN	:=	0

									DBSELECTAREA("SE2")
									DBSETORDER(6)
									//SE2->(DBGOTOP())
									//	RVBJ
									_cKeySE2 :=	XFILIAL("SE2")+SA2->(A2_COD+A2_LOJA)+Left(GW3->GW3_SERDF,TamSX3("E2_PREFIXO")[1])+Left(GW3->GW3_NRDF,TamSX3("E2_NUM")[1])
									IF DBSEEK(_cKeySE2)
										WHILE SE2->(!EOF()) .AND. SE2->(E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM) == _cKeySE2
									
									//	WHILE SE2->(!EOF()) .AND. SE2->E2_FORNECE==SA2->A2_COD .AND. SE2->E2_LOJA==SA2->A2_LOJA .AND.;
									//			SE2->E2_PREFIXO==Left(GW3->GW3_SERDF,TamSX3("E2_PREFIXO")[1]) .AND. SE2->E2_NUM==Left(GW3->GW3_NRDF,TamSX3("E2_NUM")[1])
									
											/// GRAVA DESCONTO E HIST�RICO NO T�TULO
											_nN++
											
											RecLock("SE2",.F.)
											SE2->E2_DECRESC += iif(_lRctrc,nParcel1,0)+iif(_lDConv,nParcel2,0)
											SE2->E2_SDDECRE += iif(_lRctrc,nParcel1,0)+iif(_lDConv,nParcel2,0)
											SE2->E2_HIST    := iif(_lRctrc,"Aplicado desconto RCTRC" +"+"+_cHist,iif(_lDConv,_cHist,""))
											MsUnLock()
											
											If _lRctrc
												Grv_ZDS(cTpDesc, nParcel1, " Desconto de RCTRC ")
											EndIf
											If  _lDConv
												Grv_ZDS(cTpDCon, nParcel2, _cHist)
											EndIf
										
											SE2->(DBSKIP())

										EndDo
									EndIf
								EndIf
								/// GRAVA INFORMACAO NO ROMANEIO
								If 	_lRctrc .or. _lDConv
									RecLock("GWN",.F.)
									GWN->GWN_ZRCTRC := "2"
									If _lDConv
										GWN->GWN_ZVLDES := iif(_lRctrc,nParcel1,0)+iif(_lDConv,nParcel2,0)
										GWN->GWN_ZDOCFR := GW3->GW3_NRDF
									EndIf
									MsUnLock()
								EndIf
								//////Gravar dados novos na tabela ZBS - SEGURO RCTRC
								MGFGRAVAZBS()

							EndIf
						ElseIf _lDConv 
							If GW3->GW3_VLDF >=  _nVlDesc
								DBSELECTAREA("SA2")
								DBSETORDER(3)
								DBSEEK(XFILIAL("SA2")+GW3->GW3_EMISDF)

								_aParcel2	:=	CHKPARC2(XFILIAL("SE2"),SA2->A2_COD,SA2->A2_LOJA,Left(GW3->GW3_SERDF,TamSX3("E2_PREFIXO")[1]),Left(GW3->GW3_NRDF,TamSX3("E2_NUM")[1]), _nVlDesc)
								_nN			:=	0

								DBSELECTAREA("SE2")
								DBSETORDER(6)
								SE2->(DBGOTOP())
								If DBSEEK(XFILIAL("SE2")+SA2->A2_COD+SA2->A2_LOJA+Left(GW3->GW3_SERDF,TamSX3("E2_PREFIXO")[1])+Left(GW3->GW3_NRDF,TamSX3("E2_NUM")[1]))
									While SE2->(!EOF()) .AND. SE2->E2_FORNECE==SA2->A2_COD .AND. SE2->E2_LOJA==SA2->A2_LOJA .AND.;
										SE2->E2_PREFIXO==Left(GW3->GW3_SERDF,TamSX3("E2_PREFIXO")[1]) .AND. SE2->E2_NUM==Left(GW3->GW3_NRDF,TamSX3("E2_NUM")[1])
										
										_nN++
										RecLock("SE2",.F.)	// Grava o desconto e o historico no titulo
											SE2->E2_DECRESC += _aParcel2[_nN]
											SE2->E2_SDDECRE += _aParcel2[_nN]
											SE2->E2_HIST    := _cHist
										MsUnLock()
										
										Reclock("ZDS",.T.)
											ZDS->ZDS_FILIAL := SE2->E2_FILIAL
											ZDS->ZDS_PREFIX := SE2->E2_PREFIXO
											ZDS->ZDS_NUM    := SE2->E2_NUM
											ZDS->ZDS_PARCEL := SE2->E2_PARCELA
											ZDS->ZDS_TIPO   := SE2->E2_TIPO
											ZDS->ZDS_FORNEC := SE2->E2_FORNECE
											ZDS->ZDS_LOJA   := SE2->E2_LOJA
											ZDS->ZDS_COD    := cTpDesc
											ZDS->ZDS_VALOR  := _aParcel2[_nN]
											ZDS->ZDS_HISTOR := _cHist
										ZDS->(MsUnlock())
										
										SE2->(DBSKIP())
									Enddo
								EndIf
								RecLock("GWN",.F.)
									GWN->GWN_ZVLDES := _aParcel2[_nN]
									GWN->GWN_ZDOCFR := GW3->GW3_NRDF
								MsUnLock()
							EndIf
						EndIf
					EndIf                                                                                       '
				EndIf
			EndIf
		EndIf
	EndIf
	//oModel := oMdlBkp
	RESTAURA()
return

static function RESTAURA()
	RestArea(aAreaZBB)
	RestArea(aAreaSB1)
	RestArea(aAreaSC5)
	RestArea(aAreaSD2)
	RestArea(aAreaSA1)
	RestArea(aAreaZBC)
	RestArea(aAreaSF2)
	RestArea(aAreaGW1)
	RestArea(aAreaGW4)
	RestArea(aAreaZDS)
	RestArea(aAreaGWN)
	RestArea(aAreaGW3)
	RestArea(aAreaZF0)
	RestArea(aAreaSE2)
	RestArea(aAreaSA2)
	RestArea(aArea)
Return

////Grava informacoes RCTRC na tabela ZBS
Static Function MGFGRAVAZBS()

	Local cQuery 	 := ""
	Local cAliasGW8  := ""
	Local cAliasGW1	 := ""
	Local nPesototal := 0
	Local nPesoNota  := 0
	Local aNotas 	 := {}
	Local cChave
	Local nPesoNota


	//// Verifica o peso total do Romaneio.
	cAliasGW8 := GetNextAlias()

	cQuery := " SELECT SUM(GW8_PESOR) PESO  FROM "
	cQuery +=   RetSqlName("GWN")+" GWN " + " ," + RetSqlName("GW1") + " GW1" + " ," + RetSqlName("GW8") + " GW8"
	cQuery += " WHERE GWN_FILIAL ='"+ xFilial('GWN') + "'"
	cQuery += " AND GWN_NRROM = '" + GWN->GWN_NRROM + "'"
	cQuery += " AND GWN_FILIAL = GW1_FILIAL "
	cQuery += " AND GWN_FILIAL = GW8_FILIAL "
	cQuery += " AND GWN_NRROM = GW1_NRROM "
	cQuery += " AND GW1_NRDC = GW8_NRDC "
	cQuery += " AND GW1_SERDC = GW8_SERDC "
	cQuery += " AND GWN.D_E_L_E_T_= ' ' "
	cQuery += " AND GW1.D_E_L_E_T_= ' ' "
	cQuery += " AND GW8.D_E_L_E_T_= ' ' "

	cQuery := ChangeQuery(cQuery)

	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasGW8, .F., .T.)

	If  (cAliasGW8)->(!eof())

		nPesototal := (cAliasGW8)->PESO

		/// Retorna todas as notas do Romaneio
		cAliasGW1 := GetNextAlias()

		cQuery := " SELECT * FROM "
		cQuery +=   RetSqlName("GWN")+" GWN " + " ," + RetSqlName("GW1") + " GW1" + " ," + RetSqlName("GW8") + " GW8"
		cQuery += " WHERE GWN_FILIAL ='"+ xFilial('GWN') + "'"
		cQuery += " AND GWN_NRROM = '" + GWN->GWN_NRROM + "'"
		cQuery += " AND GWN_FILIAL = GW1_FILIAL "
		cQuery += " AND GWN_FILIAL = GW8_FILIAL "
		cQuery += " AND GWN_NRROM = GW1_NRROM "
		cQuery += " AND GW1_NRDC = GW8_NRDC "
		cQuery += " AND GW1_SERDC = GW8_SERDC "
		cQuery += " AND GWN.D_E_L_E_T_= ' ' "
		cQuery += " AND GW1.D_E_L_E_T_= ' ' "
		cQuery += " AND GW8.D_E_L_E_T_= ' ' "

		cQuery += " ORDER BY GW1_DANFE "

		cQuery := ChangeQuery(cQuery)

		dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasGW1, .F., .T.)


		If (cAliasGW1)->(!eof())

			///Cria array que sera utilizado na gravacao da tabela ZBS
			While  (cAliasGW1)->(!eof())

				AADD(aNotas,{(cAliasGW1)->GW1_FILIAL, (cAliasGW1)->GW1_NRDC, (cAliasGW1)->GW1_SERDC, (cAliasGW1)->GW1_DANFE, STR((cAliasGW1)->GW8_PESOR), (cAliasGW1)->GW1_NRROM, (cAliasGW1)->GWN_CDTPVC  } )

				(cAliasGW1)->(dbskip())
			Enddo
		EndIf

		///// Tratamento para agrupamento do peso para gravar ZBS
		For nI := 1 to len(aNotas)

			nPesoNota := 0

			cChave := aNotas[nI][4]

			For nY := 1 to len(aNotas)

				If cChave = aNotas[nY][4]

					nPesoNota += Val(aNotas[nY][5])

					If Len(aNotas) > 0 .OR. cChave <> aNotas[nY+1][4]

						//Grava ZBS
						DbSelectArea('ZBS')
						DbSetOrder(1)//ZBS_FILIAL+ZBS_NUM+ZBS_SERIE+ZBS_OPER
						If ZBS->(MsSeek(ALLTRIM(aNotas[nY][1]) + ALLTRIM(aNotas[nY][2]) + ALLTRIM(aNotas[nY][3]) + "1"))

							RecLock('ZBS',.F.)
							ZBS->ZBS_TPVEIC := aNotas[nY][7]
							ZBS->ZBS_DESCRA := ZBB->ZBB_VALDES / nPesototal * nPesoNota
							ZBS->ZBS_DESTOT := ZBB->ZBB_VALDES
							ZBS->ZBS_NRROM := aNotas[nY][6]
							ZBS->(MsUnlock())

						EndIf
					EndIf
				EndIf
			Next nY
		Next nI

	EndIf
RETURN
//// Grava informacoes dos titulo provis�rios de frete do GFE

User Function MGFPROV()

	Local cItem     := SuperGetMv('MGF_ITEMCO' , NIL, '')
	Local cNaturPrv := SuperGetMv('MGF_NTFPRO' , NIL, '')
	Local lRet := .F.

	If isincallstack('GFEA096')

		RecLock("SE2",.F.)
		SE2->E2_RATEIO  := "N"
		SE2->E2_ITEMCTA := cItem
		SE2->E2_NATUREZ := cNaturPrv
		MsUnLock()

		dBselectArea("GXF")
		GXF->(dbSetOrder(1))//GXF_FILIAL+GXF_CODLOT+GXF_SEQ
		If GXF->(dbSeek(xFilial("GXF")+ALLTRIM(M->E2_NUM)))

			RecLock("SE2",.F.)
			SE2->E2_CCUSTO  := GXF->GXF_CCUSTO
			MsUnLock()
		EndIf
		lRet := .T.
	EndIf

Return lRet


////// Retorna os grupos de Produtos

Static Function GrupoPRD()

	Local cQuery    := ""
	Local cGrpProd  := ""
	Local cAliasZC3 := ""

	cAliasZC3	:= GetNextAlias()

	cQuery  := " SELECT ZC3_GRTRIB "
	cQuery	+= " FROM "  + RetSqlName('ZC3') + " " + 'ZC3'
	cQuery  += " WHERE ZC3_FILIAL =  '" + xFilial("ZC3") + "' "
	cQuery  += " AND ZC3_GRTRIB =  '" + ALLTRIM(SB1->B1_GRTRIB) + "' "
	cQuery  += " AND ZC3.D_E_L_E_T_= ' ' "


	dbUseArea(.T. , "TOPCONN" , TcGenQry(NIL , NIL , cQuery) , cAliasZC3 , .F. , .T.)

	If (cAliasZC3)->(!eof())
		cGrpProd := (cAliasZC3)->ZC3_GRTRIB
	EndIf

	(cAliasZC3)->(dbCloseArea())
Return cGrpProd
/*/
	>>>=============================================================================
	{Protheus.doc} CHKPARC1
	Funcao para verificar a quantidade de parcelas de um titulo e ratear o valor de desconto

	@description
	Checa no SE2 a quantidade de parcelas de um titulo e divide o valor de desconto nas parcelas fazendo o rateio entre as parcelas
dos descontos de RCTRC e Conveniencia

@retorn
Retorna um array com o valor de cada parcela

@author @heraldo.conrado.hebling
@since 10/12/2019
@type Function
>>>=============================================================================
*/
STATIC FUNCTION CHKPARC1(zFilial,zFornec,zLoja,zPrefixo,zNum,zValor)

	Local _aParcel	:=	{}
	Local cQuery    := ""
	Local cParcelas := ""
	Local cAlias 	:= ""
	Local _i		:=	0
	Local _nVal		:=	0

	cAlias	:= GetNextAlias()

	cQuery  := " SELECT COUNT(*) AS PARCELAS "
	cQuery	+= " FROM "  + RetSqlName('SE2') +  ' SE2'
	cQuery  += " WHERE E2_FILIAL = '"+zFilial+ "' "
	cQuery  += " AND E2_FORNECE = '"+zFornec+ "' "
	cQuery  += " AND E2_LOJA = '"+zLoja+ "' "
	cQuery  += " AND E2_PREFIXO = '"+zPrefixo+ "' "
	cQuery  += " AND E2_NUM = '"+zNum+ "' "
	cQuery  += " AND SE2.D_E_L_E_T_= ' ' "


	dbUseArea(.T. , "TOPCONN" , TcGenQry(NIL , NIL , cQuery) , cAlias , .F. , .T.)

	If (cAlias)->(!eof())
		nParcelas := (cAlias)->PARCELAS
	EndIf

	(cAlias)->(dbCloseArea())
	
	if zValor > 0
	
		_nVal	:=	 zValor / nParcelas
	
		if (_nVal *	nParcelas) - zValor == 0
	
			for _i :=	1 to nParcelas
				aadd(_aParcel,_nVal )
			next
	
		else
			_nRest	:=zValor - (_nVal *	nParcelas)
	
			if _nRest > 0
	
				aadd(_aParcel,_nVal+_nRest )
	
				for _i :=	1 to (nParcelas - 1)
					aadd(_aParcel,_nVal )
				next
	
			else
	
				for _i :=	1 to (nParcelas - 1)
					aadd(_aParcel,_nVal )
				next
	
				aadd(_aParcel,_nVal-_nRest )
	
			endif
	
		endif
	Else
		AADD(_aParcel,_nVal)
	ENDIF

RETURN (_aParcel)
/*/
	>>>=============================================================================
	{Protheus.doc} CHKPARC2
	Funcao para verificar a quantidade de parcelas de um titulo e ratear o valor de desconto de conveniencia

	@description
	Checa no SE2 a quantidade de parcelas de um titulo e divide o valor de desconto nas parcelas fazendo o rateio entre as parcelas
dos descontos de RCTRC e Conveniencia

@retorn
Retorna um array com o valor de cada parcela

@author @heraldo.conrado.hebling
@since 10/12/2019
@type Function
>>>=============================================================================
*/
STATIC FUNCTION CHKPARC2(zFilial,zFornec,zLoja,zPrefixo,zNum,zValor)

	Local _aParcel	:=	{}
	Local cQuery    := ""
	Local cParcelas := ""
	Local cAlias 	:= ""
	Local _i		:=	0
	Local _nVal		:=	0

	cAlias	:= GetNextAlias()

	cQuery  := " SELECT COUNT(*) AS PARCELAS "
	cQuery	+= " FROM "  + RetSqlName('SE2') + " " + 'SE2'
	cQuery  += " WHERE E2_FILIAL = '"+zFilial+ "' "
	cQuery  += " AND E2_FORNECE = '"+zFornec+ "' "
	cQuery  += " AND E2_LOJA = '"+zLoja+ "' "
	cQuery  += " AND E2_PREFIXO = '"+zPrefixo+ "' "
	cQuery  += " AND E2_NUM = '"+zNum+ "' "
	cQuery  += " AND SE2.D_E_L_E_T_= ' ' "


	dbUseArea(.T. , "TOPCONN" , TcGenQry(NIL , NIL , cQuery) , cAlias , .F. , .T.)

	If (cAlias)->(!eof())
		nParcelas := (cAlias)->PARCELAS
	EndIf

	(cAlias)->(dbCloseArea())
	
	if zValor > 0
		_nVal	:=	 zValor / nParcelas
	
		if (_nVal *	nParcelas) - zValor == 0
			for _i :=	1 to nParcelas
				aadd(_aParcel,_nVal )
			next
		else
			_nRest	:=zValor - (_nVal *	nParcelas)
			if _nRest > 0
				aadd(_aParcel,_nVal+_nRest )
				for _i :=	1 to (nParcelas - 1)
					aadd(_aParcel,_nVal )
				next
			else
				for _i :=	1 to (nParcelas - 1)
					aadd(_aParcel,_nVal )
				next
				aadd(_aParcel,_nVal-_nRest )
			endif
		endif
	Else
		AADD(_aParcel,_nVal)	
	ENDIF

RETURN _aParcel

/*/
	>>>=============================================================================
	{Protheus.doc} VLDCTB
	Funcao para verificar se a data de emissao da NF esta dentro do periodo contabil permitindo alteracao

	@description
	Checa no CTG - calend�rio contabil esta aberto para manutencoes

	@retorn
	Logico: .T. se permite alteracoes ou .F.
	Campo CTG_STATUS//1-Aberto, 2-Fechado, 3-Transportado, 4-Bloqueado
	@author @heraldo.conrado.hebling
	@since 11/12/2019
	@type Function
	>>>=============================================================================
*/
STATIC FUNCTION VLDCTB(zData)
	Local _lRet :=	.F.
	Local aAreaCTG	:= CTG->(GetArea())	//Calend�rio contabil

	DbSelectArea("CTG")
	DBSETORDER( 4 )		//CTG_FILIAL+CTG_EXERC+CTG_PERIOD
	if DBSEEK( xFilial("CTG")+alltrim(str(YEAR(zData)))+padl(alltrim(str(MONTH(zData))),2,"0"),.f. )
		if CTG->CTG_STATUS == "1"
			_lRet :=	.T.
		endif
	endif
	RestArea(aAreaCTG)
return _lRet

/*/
	=====================================================================================
	{Protheus.doc} MGFGFE53
	Validador se titulo possui desconto ou cai na excecao do desconto por conveniencia

	@description
	Faz a validacao se o titulo esta na excecao do desconto de conveniencia
	ou se tem desconto de conveniencia


	@autor heraldo.conrado.hebling
	@since 13/12/2019
	@type function
	@table
	ZF3 - Regra Desc Conv
	ZF4 - Excecao de desconto

	@menu
	=====================================================================================
/*/

STATIC FUNCTION TEMCONV(_cTpMov,_cCNPJ,_cTpVei,_cTpOp,_cTipPed,_cPlaca,_dData)
	LOCAL _nVlDesc	:=	0
//	_cTpMov= 1=Entradas; 2=Saidas
/*
ZF3_TIPOM - 1/2
ZF3_TIPOV - F3(GV3) - TABELA RELACIONADA GWN
ZF3_CNPJFO - F3(SA2CNJ)
ZF3_CDTPOP - F3(GV4) - TABELA RELACIONADA GW3
ZF4_TPPED - F3(SZJ2)
ZF4_DESCP
ZF4_CNPJFO
ZF4_PLACA - F3(DA3)
ZF4_DTINC 
ZF3_FILIAL+ZF3_TIPOM+ZF3_CNPJFO
ZF4_FILIAL+ZF4_TPPED+ZF4_DTINC
*/
	dBselectArea("ZF4")  //excecao de regra de descontos
	ZF4->(dbSetOrder(1)) //ZF4_FILIAL+ZF4_TPPED+ZF4_DTINC
	IF DBSEEK(XFILIAL("ZF4")+_cTipPed,.F.)
		while !ZF4->(eof()) .and. (xFilial("ZF4")+_cTipPed) ==(ZF4->ZF4_FILIAL+ZF4->ZF4_TPPED)
			if _dData	>=	ZF4->ZF4_DTINC
				if ZF4->ZF4_ATIVO == '1' //ativo
					if empty(ZF4->ZF4_DTINC) .or. ZF4->ZF4_DTINC <= _dData
						if empty(_cTipPed) .or. ZF4->ZF4_TPPED == _cTipPed
							if empty(ZF4->ZF4_CNPJFO) .or. ZF4->ZF4_CNPJFO = _cCNPJ
								if	empty(ZF4->ZF4_PLACA ) .or. ZF4->ZF4_PLACA == _cPlaca
									_nVlDesc	:=	0
									return _nVlDesc
								endif
							endif
						endif
					endif
				endif
			endif
			ZF4->(DbSkip())
		END
	ENDIF
	dBselectArea("ZF3")  //Regra de desconto de conveniencia
	ZF3->(dbSetOrder(1)) //ZF3_FILIAL+ZF3_TIPOM+ZF3_CNPJFO+ZF3_TIPOV
	IF DBSEEK(XFILIAL("ZF3")+_cTpMov,.F.)
		while !ZF3->(eof()) .and. XFILIAL("ZF3")+_cTpMov == ZF3->ZF3_FILIAL+ZF3->ZF3_TIPOM
			if ZF3->ZF3_ATIVO == "1"  // regra esta ativa
				if empty(ZF3->ZF3_CNPJFO) .or. ZF3->ZF3_CNPJFO == _cCNPJ
					if empty(ZF3->ZF3_TIPOV) .or. ZF3->ZF3_TIPOV == _cTpVei
						if empty(ZF3->ZF3_CDTPOP) .or. ZF3->ZF3_CDTPOP == _cTpOp
							_nVlDesc	:=	ZF3->ZF3_VALDES
							EXIT
						endif
					endif
				endif
			endif
			ZF3->(DbSkip())
		end
	ENDIF
return _nVlDesc


/*/
	=====================================================================================
	@description
	Faz a gravacao da ZDS de acordo com informacoes enviadas

	@autor Renato Junior
	@since 13/05/2020
	@table
	ZDS - TIPO DE VALOR POR TITULOS     
	=====================================================================================
/*/
STATIC FUNCTION Grv_ZDS(_ZDSCOD,	_ZDSVALOR,		_ZDSHISTOR)
local	cAliasAnt := Alias()

DbSelectArea("ZDS")
Reclock("ZDS",.T.)
ZDS->ZDS_FILIAL := SE2->E2_FILIAL
ZDS->ZDS_PREFIX := SE2->E2_PREFIXO
ZDS->ZDS_NUM    := SE2->E2_NUM
ZDS->ZDS_PARCEL := SE2->E2_PARCELA
ZDS->ZDS_TIPO   := SE2->E2_TIPO
ZDS->ZDS_FORNEC := SE2->E2_FORNECE
ZDS->ZDS_LOJA   := SE2->E2_LOJA
ZDS->ZDS_COD    := _ZDSCOD
ZDS->ZDS_VALOR  := _ZDSVALOR
ZDS->ZDS_HISTOR := _ZDSHISTOR

ZDS->(MsUnlock())

dbSelectArea( cAliasAnt )
RETURN NIL
