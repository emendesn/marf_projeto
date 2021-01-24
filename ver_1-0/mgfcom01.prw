#Include 'Protheus.ch'
#Include 'TbiConn.ch'
#Include 'Fileio.ch'
#include "TopConn.ch"
#INCLUDE "FWMVCDEF.CH" 

/*
=====================================================================================
Programa............: MGFCOM01
Autor...............: Roberto Sidney
Data................: 23/09/2016
Descricao / Objetivo: WF - Cotação de compras aos fornecedores
Doc. Origem.........: COM01 - GAP MGCOM01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Envio de Workflow de cotação aos fornecedores
=====================================================================================
*/
User Function MGFCOM01(nModo,cCotacao,oProcess)
	Local aCond:={}, aFrete:= {}, aSubst:={}, nTotal := 0
	Local _cC8_NUM, _cC8_FORNECE, _cC8_LOJA, _cC8_PRODUTO, _cB1_TIPO
	Local cAttach 	 := ""
	Local cDirLayout := "\WORKFLOW\HTML\"
	Local cEmailBody := ""
	Local cCodSE4    := '001' //GetMV("ZP_WFSE4")
	LOCAL aAreaSM0 := SM0->(GetArea())
	Local cNComprador := ''
	Local cTEL        := ''
	Local cEmail      := ''
	local _cDescri  := ""
//	Local _cMarca  := ""
	Local aSM0        := FWLoadSM0()
	Local cLocalEntrega := ''
	Local cValZero	 := ''//AllTrim(TRANSFORM( 0.00,'@E 99999.99' ))
	Local aObjeto    := {}
	Local cObjeto    := ""
	Local nCnt       := 0
	Local aProdProc  := {}
	Local cArqProdProc := ""
	Local cEmpatual  := Substr(cFilAnt,1,2)

	Private nModTela := nModo // 1- Modelo tela / 2=Modo job
	Private _cEmlFor := ""
	Private _aEmail	 := {}
	Private cContato := ""

	//IF MsgYesNo("Deseja enviar o Workflow de Cotação ?")

		conout("==========>  entrando na MGFCOM01 <==============")
		DbSelectArea("SY1")
		SY1->(dbSetOrder(3))
		IF SY1->(dbSeek(xFilial("SY1")+RetCodUsr())) //__cUserId
			cNComprador := SY1->Y1_NOME
			cTEL        := SY1->Y1_TEL
			cEmail      := SY1->Y1_EMAIL
		ENDIF
		
		dbSelectArea("SA5")
		SA5->(dbSetOrder(2))//A5_FILIAL+A5_PRODUTO+A5_FORNECE+A5_LOJA
		
		// Montagem da tela para selecao das quantidades a serem modificadas pelo usuarios na cotacao. (Adriano)
		dbSelectArea("SC8")
		dbSetOrder(1)
		SC8->(dbSeek(xFilial("SC8")+cCotacao))
		Do while ! SC8->(eof()) .and. xFilial("SC8")+cCotacao==SC8->C8_FILIAL+SC8->C8_NUM
			_cCotacao 	:= SC8->C8_NUM
			_cFornece 	:= SC8->C8_FORNECE
			_cLoja		:= SC8->C8_LOJA
			// Workflow já enviado
			if ! Empty(SC8->C8_ZWFID)
				SC8->(DbSkip())
				Loop
			Endif
			_aCotacao	:= {}
			Do While ! SC8->(eof()) .And. SC8->C8_FILIAL = xFilial("SC8") ;
			.And. SC8->C8_NUM     = _cCotacao ;
			.and. SC8->C8_FORNECE = _cFornece ;
			.and. SC8->C8_LOJA    = _cLoja

				SB1->(DbSeek(xFilial("SB1")+SC8->C8_PRODUTO))
				aAdd(_aCotacao,{SC8->C8_NUM,SC8->C8_FORNECE, SC8->C8_LOJA, SC8->C8_ITEM,SC8->C8_PRODUTO,SB1->B1_DESC,SC8->C8_QUANT})

				SC8->(DbSkip())
			EndDo
			// Tela para usuario selecionar as quantidades de cada produto para o fornecedor.
			fSelec130(_aCotacao)

		EndDo

		// workflow de envio cotacao.

		SA5->(DbSetOrder(1))

		dbSelectArea("SC8")
		dbSetOrder(1)
		dbSeek(xFilial("SC8")+cCotacao)
		conout("==========>  antes do while da função retorno <==============")
		while ! SC8->(eof()) .and. xFilial("SC8")+cCotacao==SC8->C8_FILIAL+SC8->C8_NUM
			_cC8_NUM     	:= SC8->C8_NUM
			_cC8_FORNECE 	:= SC8->C8_FORNECE
			_cC8_LOJA    	:= SC8->C8_LOJA
			_cC8_PRODUTO	:= SC8->C8_PRODUTO
			_cEmlFor		:= ""

			dbSelectArea('SA2')  // Tabela de Fornecedores
			dbSetOrder(1)
			dbSeek( xFilial('SA2') + _cC8_FORNECE + _cC8_LOJA )

			//Campos abaixo alterados em 14.05.10 por nao existirem na basede dados . Utilizados os campos padrao.

			_cEmlFor := SA2->A2_EMAIL //"rsoares@totvs.com.br"  
			cContato := SA2->A2_CONTATO //"Roberto Soares" 


			if ! Empty(_cEmlFor)
				oProcess := TWFProcess():New( "000001", "Cotação de Preços" )
				oProcess :NewTask("Fluxo de Compras", cDirLayout+"COTACAO_" + cEmpAtual + ".HTML" )
				oProcess:cTo		:= "000000"	// Administrador
				conout("==========>  chamando função retorno <==============")
				oProcess:bReturn	:= "U_W1881503(1)" // retorno
				oProcess:cSubject	:= "Solicitação de Cotação de Preços " + _cC8_NUM
				oProcess:UserSiga	:= "000000"
				oProcess:NewVersion(.T.)

				oHtml    := oProcess:oHTML

				dbSelectArea('SC8')  // Cotacoes
				dbSetOrder(1)
				If dbSeek( xFilial('SC8') + _cC8_NUM + _cC8_FORNECE + _cC8_LOJA )
					oHtml:ValByName( "C8_CONTATO" , cContato  )
				Else
					oHtml:ValByName( "C8_CONTATO" , "-"  )
				EndIf

				PswOrder(1)
				if PswSeek(cUsuario,.t.)
					aInfo    := PswRet(1)
					_cUser   := aInfo[1,2]
				endIf
				_cUser := "000000"

				/*** Preenche os dados do cabecalho ***/
				//oHtml:ValByname("EMPRESA", SM0->M0_NOMECOM	)
				//oHtml:ValByname("ENDER",	Alltrim(SM0->M0_ENDCOB) + " - " + AllTrim(SM0->M0_CIDCOB) + " - " + AllTrim(SM0->M0_ESTCOB) +" - CEP:" + Transform(SM0->M0_CEPCOB,"@R 99999-999")		)
				oHtml:ValByname("FONE",	cTEL		)
				oHtml:ValByname("COMPR",cNComprador		)
				oHtml:ValByname("EMAIL",cEmail	)

				oHtml:ValByName( "C8_NUM"    , SC8->C8_NUM     )
				oHtml:ValByName( "C8_VALIDA" , SC8->C8_VALIDA  )
				oHtml:ValByName( "C8_FORNECE", SC8->C8_FORNECE )
				oHtml:ValByName( "C8_LOJA"   , SC8->C8_LOJA    )
				oHtml:ValByName( "C8_OBS"    , AllTrim(SC8->C8_OBS)     )
				dbSelectArea('SA2')  // Tabela de Fornecedores
				dbSetOrder(1)
				dbSeek( xFilial('SA2') + _cC8_FORNECE + _cC8_LOJA )

				oHtml:ValByName( "A2_NOME"   , SA2->A2_NOME   )
				oHtml:ValByName( "A2_END"    , SA2->A2_END    )
				oHtml:ValByName( "A2_MUN"    , SA2->A2_MUN    )
				oHtml:ValByName( "A2_BAIRRO" , SA2->A2_BAIRRO )
				oHtml:ValByName( "A2_TEL"    , SA2->A2_TEL    )
				oHtml:ValByName( "A2_FAX"    , SA2->A2_FAX    )   

				cLocalEntrega := IIF(Empty(SC8->C8_FILENT),SC8->C8_FILIAL,SC8->C8_FILENT)
				aAreaSM0 := SM0->(GetArea())
				SM0->(dbSetOrder(1))
				SM0->(DbSeek(SubStr(cEmpAtual,1,2) +  cLocalEntrega)  )
				oHtml:ValByname("LOCALENTREGA",	Alltrim(SM0->M0_ENDENT) + " - " + AllTrim(SM0->M0_CIDENT) + " - " + AllTrim(SM0->M0_ESTENT) + " - " + AllTrim(SM0->M0_BAIRENT) + " - CEP:" + Transform(SM0->M0_CEPENT,"@R 99999-999")		)

				// Roberto - 14/10/16              
				// Endereço de entrega
				oHtml:ValByName( "M0_ENDENT"   , SM0->M0_ENDENT )
				oHtml:ValByName( "M0_BAIRENT"  , SM0->M0_BAIRENT  )
				oHtml:ValByName( "M0_CIDENT"   , SM0->M0_CIDENT )
				oHtml:ValByName( "M0_CEPENT"   , SM0->M0_CEPENT ) 
				oHtml:ValByName( "M0_ESTENT"   , SM0->M0_ESTENT )  

				// Endereço de cobrança
				oHtml:ValByName( "M0_ENDCOB"   , SM0->M0_ENDCOB )
				oHtml:ValByName( "M0_CEPCOB"   , SM0->M0_CEPCOB  )
				oHtml:ValByName( "M0_CIDCOB"   , SM0->M0_CIDCOB )
				oHtml:ValByName( "M0_ESTCOB"   , SM0->M0_ESTCOB ) 
				RestArea(aAreaSM0)

				dbSelectArea("SE4")
				dbSetOrder(1)
				/*
				If dbSeek(xFilial("SE4") + SA2->A2_COND )
					aAdd( aCond, SE4->E4_CODIGO+" - "+Alltrim(SE4->E4_COND)+" - "+SE4->E4_DESCRI )
				Else
					If dbSeek(xFilial("SE4") + Alltrim(cCodSE4) )
						aAdd( aCond, SE4->E4_CODIGO+" - "+Alltrim(SE4->E4_COND)+" - "+SE4->E4_DESCRI )
					ENDIF
				endif
				*/
				SE4->(dbGotop())
				While SE4->(!Eof())
					aAdd( aCond, SE4->E4_CODIGO+" - "+Alltrim(SE4->E4_COND)+" - "+SE4->E4_DESCRI )
					SE4->(dbSkip())
				Enddo	
				
				dbSelectArea('SC8')  // Cotacoes
				dbSetOrder(1)
				dbSeek( xFilial('SC8') + _cC8_NUM + _cC8_FORNECE + _cC8_LOJA )

				oHtml:ValByName( "C8_CONTATO" , cContato  )
				aAttach		:= {}
				_cChave		:= SC8->C8_FILIAL+SC8->C8_NUM+SC8->C8_FORNECE+SC8->C8_LOJA
	    		aProdProc := {}            
				aObjeto := {}
    	
				while SC8->(!eof()) .and. SC8->C8_FILIAL = xFilial("SC8") ;
				.and. SC8->C8_NUM     = _cC8_NUM ;
				.and. SC8->C8_FORNECE = _cC8_FORNECE ;
				.and. SC8->C8_LOJA    = _cC8_LOJA

					// Busca descricao do SA5
					_cDescri := ""
					//_cMarca := ""
					dbSelectArea("SB5")
					SB5->(dbSetOrder(1))

					If SB5->(DbSeek(xFilial("SB5")+_cC8_FORNECE+_cC8_LOJA+SC8->C8_PRODUTO))
						_cDescri := SB5->B5_CEME    
						//_cMarca  := SB5->B5_MARCA  
					EndIf
					// se nao encontrou no SA5 busca do SB1.
					If Empty(_cDescri)
						SB1->(dbSetOrder(1))
						SB1->(dbSeek(xFilial("SB1") + SC8->C8_PRODUTO ))
						_cDescri := SB1->B1_DESC
						//_cMarca  := SB1->B1_ZMARCA 
						If !Empty(SB1->B1_CODPROC)
							If aScan(aProdProc,{|x| x[1]==SB1->B1_COD}) == 0
								aAdd(aProdProc,{SB1->B1_COD,SB1->B1_CODPROC})
							Endif	
						Endif
					EndIf

					aAdd( (oHtml:ValByName( "it.item"    )), SC8->C8_ITEM    )
					aAdd( (oHtml:ValByName( "it.produto" )), SC8->C8_PRODUTO )
					aAdd( (oHtml:ValByName( "it.descri"  )), _cDescri   )
					//aAdd( (oHtml:ValByName( "it.marca"  )), _cMarca   )
					aAdd( (oHtml:ValByName( "it.quant"   )), AllTrim(TRANSFORM( SC8->C8_QUANT,PesqPict( 'SC8', 'C8_QUANT' )) ) )
					aAdd( (oHtml:ValByName( "it.um"      )), SC8->C8_UM      )
					aAdd( (oHtml:ValByName( "it.preco"   )), cValZero )
					aAdd( (oHtml:ValByName( "it.valor"   )), cValZero )
					aAdd( (oHtml:ValByName( "it.moeda"   )), {"Real","Dolar","Ufir","Euro","Iene"} )
					aAdd( (oHtml:ValByName( "it.prazo"   )), " ")
					aAdd( (oHtml:ValByName( "it.datprf"  )), DTOC(SC8->C8_DATPRF) )
					aAdd( (oHtml:ValByName( "it.complemento" )), SB1->B1_ZPRODES )
					aAdd( (oHtml:ValByName( "it.ipi"     )), cValZero )
					aAdd( (oHtml:ValByName( "it.marca"   )), " " ) 
				    aAdd( (oHtml:ValByName( "it.st" 	 )), cValZero ) 
				    //aAdd( (oHtml:ValByName( "it.prodforn")), " " ) 
				    SA5->(dbSetOrder(2))
				    If SA5->(dbSeek(xFilial("SA5") + SC8->C8_PRODUTO + _cC8_FORNECE + _cC8_LOJA  ))
				    	aAdd( (oHtml:ValByName( "it.prodforn")), SA5->A5_CODPRF )
				    else
				    	aAdd( (oHtml:ValByName( "it.prodforn")), " " )
				    EndIf
				    
					cProduto := SB1->B1_COD
					AC9->(dbSetOrder(2))
					SC1->(dbSetOrder(1))
					If SC1->(dbSeek(xFilial("SC1")+SC8->C8_NUMSC+SC8->C8_ITEMSC))
						If AC9->(dbSeek(xFilial("AC9")+"SC1"+SC1->C1_FILENT+SC1->C1_FILIAL+SC1->C1_NUM+SC1->C1_ITEM))
							While AC9->(!Eof()) .and. AC9->AC9_FILIAL+AC9->AC9_ENTIDA+AC9->AC9_FILENT+Alltrim(AC9->AC9_CODENT) == xFilial("AC9")+"SC1"+SC1->C1_FILENT+SC1->C1_FILIAL+SC1->C1_NUM+Alltrim(SC1->C1_ITEM)
								aAdd(aObjeto,AC9->AC9_CODOBJ)
								AC9->(dbSkip())
							Enddo
						Endif		
					Endif
					ACB->(dbSetOrder(1))
					For nCnt:=1 To Len(aObjeto)	
						If ACB->(dbSeek(xFilial("ACB")+aObjeto[nCnt]))
							cObjeto := "\dirdoc\co"+cEmpAtual+"\shared\"+alltrim(ACB->ACB_OBJETO)
							If aScan(aAttach,cObjeto) == 0
								aAdd(aAttach,cObjeto)
							Endif
						Endif
					Next			

					dbSelectArea("SC8")
					RecLock('SC8')
					SC8->C8_ZWFID := oProcess:fProcessID
					MsUnlock()
					SC8->(dbSkip())
					Loop
				enddo
				
				If Len(aProdProc) > 0
					aProdProc := aSort(aProdProc,,,{|x,y| x[1] < y[1]})
					cArqProdProc := StaticCall(MGFWFPC,RelProdProc,aProdProc)
				Endif

				oHtml:ValByName( "Pagamento", aCond    )
				oHtml:ValByName( "Frete"    , {"CIF","FOB"}   )
				oHtml:ValByName( "C8_ZCOTF" , " ")
				oHtml:ValByName( "subtot"   , cValZero )
				oHtml:ValByName( "vldesc"   , cValZero )
				oHtml:ValByName( "aliipi"   , cValZero )
				oHtml:ValByName( "valfre"   , cValZero )
				oHtml:ValByName( "totped"   , cValZero ) 

				// Roberto - 14/10/16 
//				oHtml:ValByName( "toticms"  , cValZero )
//				oHtml:ValByName( "totpis"   , cValZero )
//				oHtml:ValByName( "totcofins", cValZero )      
//				oHtml:ValByName( "totiss"   , cValZero ) 
				
				_aReturn := {}

				AADD(_aReturn, oProcess:fProcessId)
				aAdd( oProcess:aParams, _cChave)

				oProcess:nEncodeMime := 0

				//garante que o arquivo esteja na pasta onde o arquivo será carregado.
				IF !File("\workflow\messenger\emp" +cEmpAtual  + "\" + _cUser + "\Marfrig.gif")
					__CopyFile(cDirLayout+"Marfrig.gif","\workflow\messenger\emp" +cEmpAtual  + "\" + _cUser + "\Marfrig.gif" )
				endif

				cProcess := oProcess:Start("\workflow\messenger\emp" +cEmpAtual  + "\" + _cUser + "\")

				chtmlfile  := cProcess + ".htm"

				cmailto    := "mailto:" + AllTrim( GetMV('MV_WFMAIL') )

				chtmltexto := wfloadfile("\workflow\messenger\emp" +cEmpAtual  + "\" + _cUser + "\" + chtmlfile )
				chtmltexto := strtran( chtmltexto, cmailto, "WFHTTPRET.APL" )

				wfsavefile("\workflow\messenger\emp" +cEmpAtual  + "\" + _cUser + "\" + chtmlfile+"l", chtmltexto)
				fErase("\workflow\messenger\emp" +cEmpAtual  + "\" + _cUser + "\" + chtmlfile)

				IF !"@" $ oProcess:cTO
					aMsg := {}
					aAdd(aMsg, "Sr.(a) " + cContato )
					AADD(aMsg, "</BR>")
					AADD(aMsg, " Nós da Marfrig S/A através do departamento de compras, gostariamos de fazer uma cotação com a sua empresa.")
					AADD(aMsg, " O número da cotação é <b>" + _cC8_NUM + "</b> e para participar basta clicar no link logo abaixo :")
					If Len(aProdProc) > 0 .and. File(cArqProdProc)
						AADD(aMsg, "</BR>")
						AADD(aMsg, " Em anexo encontra-se o arquivo em .PDF, com as descrições dos produtos constantes na Cotação.")
						aAdd(aAttach,cArqProdProc)
					Endif	
					AADD(aMsg, "</BR>")
					AADD(aMsg, "</BR>")
					AADD(aMsg, "Atenciosamente ")
					AADD(aMsg, "</BR>")
					AADD(aMsg, "Favor não responder este email, em caso de dúvida entrar em contato :")
					AADD(aMsg, "</BR>")
					AADD(aMsg, cNComprador)
					AADD(aMsg, cTEL)
					AADD(aMsg, cEmail)
					AADD(aMsg, "Marfrig S/A")
					AADD(aMsg, "</BR>")
					aAdd(aMsg, '<p><a href="' +GetNewPar("MGF_WFHTTP","http://localhost:8091/WF/")+'/messenger/emp' +cEmpAtual  + '/' + _cUser + '/' + alltrim(cProcess) + '.html">Clique aqui para responder a cotação </a></p>')
					AADD(aMsg, "</BR>")
					AADD(aMsg, "</BR>")
					//	aAdd(aMsg, SM0->M0_NOMECOM)
					//	aAdd(aMsg, Alltrim(SM0->M0_ENDCOB))
					//	aAdd(aMsg, Alltrim(SM0->M0_CIDCOB) + " - " + SM0->M0_ESTCOB + " - CEP:" + Transform(SM0->M0_CEPCOB,"@R 99999-999"))
					//	aAdd(aMsg, "Fone:" + SM0->M0_TEL)
					//	aAdd(aMsg, "Comprador:" + cUserName)
					//	aAdd(aMsg, "E-Mail:" + UsrRetMail(__cUserID))

					U_fEnviaLink( _cEmlFor, oProcess:cSubject , aMsg, aAttach )

				ENDIF
			else
				// Atualizar SC8 para nao processar novamente
				dbSelectArea("SC8")
					RecLock('SC8')
						SC8->C8_ZWFID := "WF9999"
					SC8->(MsUnlock())
				dbSkip()
			endif
		enddo
	//Endif
	
Return
/*
=====================================================================================
Programa............: MT130A
Autor...............: Roberto Sidney
Data................: 23/09/2016
Descricao / Objetivo: WF - Cotação de compras aos fornecedores
Doc. Origem.........: COM01 - GAP MGCOM01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Programa executado durante retorno de cotacoes preenchidas
fornecedores
=====================================================================================
*/

User Function MT130A()

Return("Nós da Marfrig S/A agradecemos o envio da sua cotação.")

/*
=====================================================================================
Programa............: W1881503
Autor...............: Roberto Sidney
Data................: 23/09/2016
Descricao / Objetivo: WF - Cotação de compras aos fornecedores
Doc. Origem.........: COM01 - GAP MGCOM01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Rotina de retorno de cotacao dos fornecedores.
Produto Produtivo
=====================================================================================
*/
User Function W1881503(AOpcao, oProcess)

	Local nPreco	:= 0
	Local nTotIt	:= 0
	Local nAliIpi	:= 0	
	Local nPrazo	:= 0
	Local nValFre	:= 0	
	Local nValDes	:= 0
	Local nSubTot	:= 0
	Local nMoeda	:= 0
	
	Local _nind :=0
	
	Local cCodFor := ""
	
	Conout("=============>Inicio Retorno da Cotação <=============")
	
	If ValType(aOpcao) = "A"
		aOpcao := aOpcao[1]
	EndIf

	If aOpcao == NIL
		aOpcao := 0
	EndIf

	If aOpcao == 1
		_cC8_NUM     := oProcess:oHtml:RetByName("C8_NUM"     )
		_cC8_FORNECE := oProcess:oHtml:RetByName("C8_FORNECE" )
		_cC8_LOJA    := oProcess:oHtml:RetByName("C8_LOJA"    )
	EndIf

	_cC8_VLDESC := oProcess:oHtml:RetByName("VLDESC" )
	_cC8_ALIIPI := oProcess:oHtml:RetByName("ALIIPI" )
	_cC8_VALFRE := oProcess:oHtml:RetByName("VALFRE" )

	// Roberto - 14/10/2016 
	/*_cC8_ICMS := oProcess:oHtml:RetByName("TOTICMS")	
	_cC8_PIS  := oProcess:oHtml:RetByName("TOTPIS")	
	_cC8_COFI := oProcess:oHtml:RetByName("TOTCOFINS")
	_cC8_ISS  := oProcess:oHtml:RetByName("TOTISS") */

	If oProcess:oHtml:RetByName("Frete") = "FOB"
		_cC8_RATFRE := 0
	EndIf
	
	dbSelectArea("SA5")
	SA5->(dbSetOrder(2))//A5_FILIAL+A5_PRODUTO+A5_FORNECE+A5_LOJA
	
	For _nind := 1 To Len(oProcess:oHtml:RetByName("it.preco"))
		
		If oProcess:oHtml:RetByName("Aprovacao") = "S"   // Cotacao Recebida
			
			Conout("=============> APROVADO <=============")

			If !Empty(oProcess:oHtml:RetByName("it.prodforn")[_nind]) 
				cCodFor := oProcess:oHtml:RetByName("it.prodforn")[_nind]
			
				If SA5->(dbSeek(xFilial("SA5") + oProcess:oHtml:RetByName("it.produto")[_nind] + _cC8_FORNECE + _cC8_LOJA ))
					If Alltrim(SA5->A5_CODPRF) <> Alltrim(cCodFor)
						RecLock("SA5",.F.)
							SA5->A5_CODPRF := Alltrim(cCodFor)
						SA5->(MsUnlock())
					EndIf
				Else
					RecLock("SA5",.T.)
						SA5->A5_FILIAL := xFilial("SA5")
						SA5->A5_FORNECE:= _cC8_FORNECE 
						SA5->A5_LOJA   := _cC8_LOJA
						SA5->A5_NOMEFOR:= oProcess:oHtml:RetByName("A2_NOME"    ) 
 						SA5->A5_PRODUTO:= oProcess:oHtml:RetByName("it.produto")[_nind] 
						SA5->A5_NOMPROD:= oProcess:oHtml:RetByName("it.descri")[_nind] 	
						SA5->A5_CODPRF := Alltrim(cCodFor)
					SA5->(MsUnlock())
				EndIf
				
			Endif
			
			_cC8_ITEM := oProcess:oHtml:RetByName("it.item")[_nind]
			
			dbSelectArea("SC8")
			SC8->(dbSetOrder(1))
			If SC8->(dbSeek( xFilial("SC8") + Padr(_cC8_NUM,6) + Padr(_cC8_FORNECE,6) + _cC8_LOJA + _cC8_ITEM ) )
				
				//Realiza a Verificação da Moeda utilizada
				If Substr(oProcess:oHtml:RetByName("it.moeda")[_nind] ,1,1) == "R"
					nMoeda := 1
				ElseIf Substr(oProcess:oHtml:RetByName("it.moeda")[_nind] ,1,1) == "D"
					nMoeda := 2
				ElseIf Substr(oProcess:oHtml:RetByName("it.moeda")[_nind] ,1,1) == "U"
					nMoeda := 3
				ElseIf Substr(oProcess:oHtml:RetByName("it.moeda")[_nind] ,1,1) == "I"
					nMoeda := 4
				ElseIf Substr(oProcess:oHtml:RetByName("it.moeda")[_nind] ,1,1) == "E"
					nMoeda := 5
				Else
					nMoeda := 1
				EndIf

				nPreco  := Val(strtran(oProcess:oHtml:RetByName("it.preco")[_nind],",","."))
				nTotIt	:= Val(strtran(oProcess:oHtml:RetByName("it.valor")[_nind],",",".")) 
				nAliIpi := Val(StrTran(oProcess:oHtml:RetByName("it.ipi")[_nind],",",".")) 
				nPrazo	:= Val(strtran(oProcess:oHtml:RetByName("it.prazo")[_nind],",","."))
				
				nValFre := Val(strtran(oProcess:oHtml:RetByName("valfre"),",",".") )
				nValDes	:= Val(strtran(oProcess:oHtml:RetByName("vldesc"),",",".") )
				nSubTot	:= Val(strtran(oProcess:oHtml:RetByName("subtot"),",",".") )
				nTotal	:= Val(strtran(oProcess:oHtml:RetByName("totped"),",",".") )
				
				Conout("=============> Gravando Item " + oProcess:oHtml:RetByName("it.produto")[_nind] + " <=============")
				
				RecLock("SC8",.f.)

					SC8->C8_PRECO  	:= IIF(ValType(nPreco)=='N',nPreco,0) 
					SC8->C8_TOTAL  	:= IIF(ValType(nTotIt)=='N',nTotIt,0)
					SC8->C8_PRAZO   := IIF(ValType(nPrazo)=='N',nPrazo,0)
					SC8->C8_ZCOTF   := AllTrim(oProcess:oHtml:RetByName("C8_ZCOTF"))
					SC8->C8_OBS	    := Alltrim(oProcess:oHtml:RetByName("C8_OBS"))
					SC8->C8_ZWFENV  := 'S'
					SC8->C8_MOEDA  	:= nMoeda
					SC8->C8_COND   	:= SubStr(oProcess:oHtml:RetByName("pagamento"),1,3)
					SC8->C8_TPFRETE	:= SubStr(oProcess:oHtml:RetByName("Frete"),1,1)
					
					//Valor de IPI
					If ValType(nAliIpi)=='N' .and. nAliIpi > 0 
						SC8->C8_ALIIPI   := nAliIpi
						SC8->C8_VALIPI   := SC8->C8_TOTAL * (SC8->C8_ALIIPI/100)
						SC8->C8_BASEIPI  := SC8->C8_TOTAL
					EndIf
					
					//Valor do Frete por Item
					If oProcess:oHtml:RetByName("Frete") = "FOB" .or. !(ValType(nValFre) == 'N')
						SC8->C8_VALFRE := 0
					Else
						SC8->C8_VALFRE := (nValFre/nSubTot) * nTotIt
					EndIf
					
					//Valor do Desconto Por Item
					If !(ValType(nValDes) == 'N') .or. nValDes == 0
						SC8->C8_VLDESC := 0
					Else
						SC8->C8_VLDESC := (nValDes/nSubTot) * nTotIt
					EndIf
					
					If !Empty(oProcess:oHtml:RetByName("it.st")[_nind]) 
						SC8->C8_ZPERST := Val(StrTran(oProcess:oHtml:RetByName("it.st")[_nind],",",".")) 
					Endif
					If !Empty(oProcess:oHtml:RetByName("it.marca")[_nind]) 
						SC8->C8_ZMARCA := oProcess:oHtml:RetByName("it.marca")[_nind]
					Endif
					If !Empty(oProcess:oHtml:RetByName("it.prodforn")[_nind]) 
						SC8->C8_ZPROFOR := oProcess:oHtml:RetByName("it.prodforn")[_nind]
					Endif
				
				SC8->(MsUnlock())
			Else
				Conout("=============> Não Encontrou Registro Chave: " + xFilial("SC8") + Padr(_cC8_NUM,6) + Padr(_cC8_FORNECE,6) + _cC8_LOJA + _cC8_ITEM + "  <=============")	
			EndIf
			_cProd := oProcess:oHtml:RetByName("it.produto")[_nind]
		Else
			_cProd := oProcess:oHtml:RetByName("it.produto")[_nind]
		EndIf
	Next _nind
	
	Conout("=============>Termino Retorno da Cotação <=============")
	
Return

/*
=====================================================================================
Programa............: ³fSelec130
Autor...............: Roberto Sidney
Data................: 23/09/2016
Descricao / Objetivo: WF - Cotação de compras aos fornecedores
Doc. Origem.........: COM01 - GAP MGCOM01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Tela de selecao das quantidades de cada produto.
=====================================================================================
*/
Static Function fSelec130(_aCot)
	Local _nY := 0
	Private _cCot 	:= ""
	Private _cFornec	:= ""
	Private _cLj		:= ""
	Private aHeader := {}
	Private aCols	:= {}
	Private _lGrava := .f.
	Private aObjects:= {}
	Private oGetD


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta o Array aHeader.                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	dbSelectArea("SX3")
	dbSetOrder(1)
	DbSeek("SC8")

	Do While ! SX3->(Eof()) .And. SX3->X3_ARQUIVO == "SC8"
		If Alltrim(SX3->X3_CAMPO) $ "C8_ITEM/C8_PRODUTO/C8_QUANT"
			If Alltrim(X3_CAMPO)=="C8_QUANT"
				_cVisual := "A"
				AAdd(aHeader,{X3Titulo(),X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,"U_FMT130VL()",X3_USADO,X3_TIPO,X3_F3,X3_CONTEXT,;
				X3_CBOX,X3_RELACAO,X3_WHEN,"A",X3_VLDUSER, X3_PICTVAR,X3_OBRIGAT})
			Else
				AAdd(aHeader,{X3Titulo(),X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,X3_USADO,X3_TIPO,X3_F3,X3_CONTEXT,;
				X3_CBOX,X3_RELACAO,X3_WHEN,"V",X3_VLDUSER, X3_PICTVAR,X3_OBRIGAT})
			EndIf
		Endif
		SX3->(DbSkip())
	EndDo

	dbSelectArea("SX3")
	dbSetOrder(2)
	DbSeek("B1_DESC")
	AAdd(aHeader,{X3Titulo(),X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,X3_USADO,X3_TIPO,X3_F3,X3_CONTEXT,;
	SX3->X3_CBOX,X3_RELACAO,SX3->X3_WHEN,	"V",SX3->X3_VLDUSER, SX3->X3_PICTVAR,SX3->X3_OBRIGAT	})

	nStyle := GD_UPDATE

	// Adiciona os itens recebidos da cotacao no acols.
	For _nY := 1 To Len(_aCot)
		aAdd(aCols,{_aCot[_nY,4],_aCot[_nY,5],_aCot[_nY,7],_aCot[_nY,6],.f.})
		_cCot 		:= _aCot[_nY,1]
		_cFornec	:= _aCot[_nY,2]
		_cLj		:= _aCot[_nY,3]
	Next _nY

	SA2->(DbSetOrder(1))
	SA2->(DbSeek(xFilial("SA2")+_cFornec+_cLj))
	// Modelo de tel
	if nModTela = 1
		aFolder1    := {"COTACAO"}

		aSize := MsAdvSize()
		AAdd( aObjects, { 100, 080 , .T., .F. } )
		AAdd( aObjects, { 100, 100	, .T., .T. } )
		aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
		aPosObj 	:= MsObjSize( aInfo, aObjects,.T.)
		nOpc := 2

		DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 To aSize[6],aSize[5] of oMainWnd PIXEL

		oFolder1:= TFolder():New(aPosObj[1,1],aPosObj[1,2],aFolder1,{},oDlg,,,,.T.,.F.,aPosObj[1,4]-aPosObj[1,2],aPosObj[1,3]-aPosObj[1,1],)

		TSay():New(010,003,{||"COTACAO:"+_cCot},oFolder1:aDialogs[1],,,.F.,.F.,.F.,.T.,,,056,008)
		TSay():New(020,003,{||"FORNECEDOR:"+SA2->A2_COD+"/"+SA2->A2_LOJA+"-"+SA2->A2_NOME},oFolder1:aDialogs[1],,,.F.,.F.,.F.,.T.,,,350,008)

		//oEnchoice:oBox:Align := CONTROL_ALIGN_ALLCLIENT

		oGetD := MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nStyle,"AllWaysTrue","AllWaysTrue",/*"+PAB_ITEM"*/,/*acpos*/,/*freeze*/,999,/*fieldok*/,/*superdel*/,/*delok*/,oDlg,@aHeader,@aCols)

		ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| _lGrava := .t.,oDlg:End()},{||oDlg:End()},,)

		If _lGrava
			MsgRun("Aguarde, gravando os dados",,{ ||fGrava130()})
		EndIf
	Else
		fGrava130()
	Endif

Return

/*
=====================================================================================
Programa............: fGrava130
Autor...............: Roberto Sidney
Data................: 23/09/2016
Descricao / Objetivo: WF - Cotação de compras aos fornecedores
Doc. Origem.........: COM01 - GAP MGCOM01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: uncao para gravacao das quantidades selecionadas.
=====================================================================================
*/
Static Function fGrava130()
	Local _nF:= 0
	_nPosItem	    := aScan(aHeader,{|x| Alltrim(x[2]) == "C8_ITEM" })
	_nPosQtd		:= aScan(aHeader,{|x| Alltrim(x[2]) == "C8_QUANT" })
	_aAreaC82	    := SC8->(GetArea())

	SC8->(DbSetOrder(1))

	For _nF := 1 To Len(aCols)
		If SC8->(DbSeek(xFilial("SC8")+_cCot+_cFornec+_cLj+aCols[_nF,_nPosItem]))
			SB1->(DbSeek(xFilial("SB1")+SC8->C8_PRODUTO))
			// calculo segunda unidade de medida.
			_nQtdSeg := 0
			If SB1->B1_TIPCONV == "M"
				_nQtdSeg := aCols[_nF,_nPosQtd] * SB1->B1_CONV
			ElseIf SB1->B1_TIPCONV == "D" .And. SB1->B1_CONV > 0
				_nQtdSeg := aCols[_nF,_nPosQtd] / SB1->B1_CONV
			EndIf
			RecLock("SC8",.f.)
			SC8->C8_QUANT	:= aCols[_nF,_nPosQtd]
			SC8->C8_QTSEGUM	:= _nQtdSeg
			SC8->(MsUnLock())

		EndIf
	Next _nF

	RestArea(_aAreaC82)

Return
/*
=====================================================================================
Programa............: FMT130VL
Autor...............: Roberto Sidney
Data................: 23/09/2016
Descricao / Objetivo: WF - Cotação de compras aos fornecedores
Doc. Origem.........: COM01 - GAP MGCOM01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Funcao de validacao da quantidade
=====================================================================================
*/
User Function FMT130VL()

	_aArea130 := GetArea()
	_aAr130C8 := SC8->(GetArea())
	_nPosItem	:= aScan(aHeader,{|x| Alltrim(x[2]) == "C8_ITEM"})
	_nPosQtd		:= aScan(aHeader,{|x| Alltrim(x[2]) == "C8_QUANT"})

	_lRet := .t.

	If SC8->(DbSeek(xFilial("SC8")+_cCot+_cFornec+_cLj+aCols[n,_nPosItem]))
		If M->C8_QUANT > SC8->C8_QUANT
			ApMsgStop("Nao pode inserir quantidade maior que a solicitada","BLOQUEIO")
			_lRet := .f.
		EndIf
	EndIf

	RestArea(_aAr130C8)
	RestArea(_aArea130)

Return(_lRet)

/*
=====================================================================================
Programa............: fEnviaLink
Autor...............: Roberto Sidney
Data................: 23/09/2016
Descricao / Objetivo: WF - Cotação de compras aos fornecedores
Doc. Origem.........: COM01 - GAP MGCOM01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Funcao de notificacao.
=====================================================================================
*/
USER FUNCTION fEnviaLink(cTo, cTitle, aMsg, aFiles )
	Local cBody, nInd

	cBody := '<html>'
	cBody += '<DIV><SPAN class=610203920-12022004><FONT face=Verdana color=#ff0000 '
	cBody += 'size=2><STRONG>Workflow - Serviço Envio de Mensagens</STRONG></FONT></SPAN></DIV><hr>'
	For nInd := 1 TO Len(aMsg)
		cBody += '<DIV><FONT face=Verdana color=#000080 size=3><SPAN class=216593018-10022004>' + aMsg[nInd] + '</SPAN></FONT></DIV><p>'
	Next
	cBody += '</html>'
	conout("fEnvialink")
	RETURN WFNotifyAdmin( cTo , cTitle, cBody, aFiles )

Return(.T.)

/*
=====================================================================================
Programa............: SCHWFCOT
Autor...............: Roberto Sidney
Data................: 23/09/2016
Descricao / Objetivo: WF - Cotação de compras aos fornecedores
Doc. Origem.........: COM01 - GAP MGCOM01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Funcao de notificacao.
=====================================================================================
*/
User Function SCHWFCOT()

	Local _nEmpCot :=0
	Local _nCot := 0
	Local _aCotas:= {}
	Private aWF_Emp :={}
	Private aEmps :={}
	Private _cEmpCot := ''
	Private _cFilcot := ''
	Private _cCotacao:= ''
	Private _cAreaCOT :={}


	// Prepara o ambiente para processamento
	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "010001" TABLES "SM0"
	Conout("Iniciando o process Workflow Cotações")
	aWF_Emp := EmpFilWF()

	//aGrupos := Allgroups()
	//aEmps := FWGrpEmp(aGrupos[1,1,1])
	//aEmps := FWGrpEmp(aGrupos[1,1,1])
	_aCotas:= {}

	For _nEmpCot := 1 to len(aWF_Emp)

		// Alimenta variaveis para Query
		// Empresa
		_cEmpCot := aWF_Emp[_nEmpCot,1]
		// Filial
		_cFilcot := aWF_Emp[_nEmpCot,2]

		// Prepara o ambiente para processamento
		PREPARE ENVIRONMENT EMPRESA _cEmpCot FILIAL _cFilcot TABLES "SM0"

		cQryCot := " SELECT C8_FILIAL,C8_NUM,C8_ITEM,C8_NUMPRO,C8_PRODUTO,C8_UM,C8_QTDCTR,C8_QUANT,C8_PRECO,C8_TOTAL,C8_COND,"
		cQryCot += " C8_PRAZO,C8_FORNECE,C8_LOJA,C8_CONTATO,C8_FILENT,C8_EMISSAO,C8_ALIIPI,C8_TES,C8_PICM,C8_VALFRE,C8_VALEMB,"
		cQryCot += " C8_DESC1,C8_TPFRETE C8_TOTFRE,C8_AVISTA,C8_REAJUST,C8_DTVISTA,C8_VALIDA,C8_NUMPED,C8_ITEMPED,C8_NUMSC,C8_ITEMSC,"
		cQryCot += " C8_DATPRF,C8_IDENT,C8_VLDESC,C8_SEGUM,C8_QTSEGUM,C8_OK,C8_DESPESA,C8_SEGURO,C8_VALIPI,C8_VALICM,C8_BASEICM,"
		cQryCot += " C8_BASEIPI,C8_DESC,C8_MSG,C8_MOEDA,C8_TXMOEDA,C8_ORCFOR,C8_SEQFOR,C8_ITEFOR,C8_CODORCA,C8_TPDOC,C8_INTCLIC,"
		cQryCot += " C8_ORIGEM,C8_FORNOME,C8_FORMAIL,C8_WF,C8_OBS,C8_NUMCON,C8_BASESOL,C8_VALSOL,C8_NUMPR,C8_CODED,C8_PRECOOR,"
		cQryCot += " C8_ACCNUM,C8_ACCITEM,C8_ZWFID,C8_ZCOTF,C8_ZWFENV "
		cQryCot += " FROM "+RetSqlName("SC8")+" SC8"
		cQryCot += " WHERE C8_FILIAL = '"+_cFilcot+"'"
		//cQryCot += " AND C8_NUM BETWEEN '"+cContrato+"' AND '"+cContrato+"'"
		cQryCot += " AND C8_ZWFENV IN(' ','N') "
		cQryCot += " AND C8_ZWFID = '' "
		cQryCot += " AND D_E_L_E_T_ = '' "

		If Select("QRYCOT")<>0
			DbSelectArea("QRYCOT")
			QRYCOT->(DbCloseArea())
		EndIf

		TcQuery cQryCot New Alias "QRYCOT"

		// Alimenta array com resultado da Query
		QRYCOT->(DbGoTop())

		While ! QRYCOT->(eof())
			aadd(_aCotas,{_cEmpCot,_cFilcot,QRYCOT->C8_NUM})
			QRYCOT->(DbSkip())
		Enddo

	Next _nEmpCot

	QRYCOT->(DbCloseArea())

	For _nCot := 1 to len(_aCotas)

		// Alimenta variaveis para Query
		_cEmpCot := _aCotas[_nCot,1] // Empresa
		_cFilcot := _aCotas[_nCot,2] // Filial

		// Prepara o ambiente para processamento
		PREPARE ENVIRONMENT EMPRESA _cEmpCot FILIAL _cFilcot TABLES "SM0"

		// Cotação para envio do Workflow
		_cCotacao:= _aCotas[_nCot,3]
		oProcess := TWFProcess():New( "000001", "Cotação de Preços" )
		U_MGFCOM01(2,_cCotacao,oProcess)
	Next _nCot

	Conout("Finalizado processo de Workflow Cotações.")
Return()

/*
=====================================================================================
Programa............: EmpFilWF
Autor...............: Roberto Sidney
Data................: 27/09/2016
Descricao / Objetivo: Monta array com empresas e filiais para processamento
Doc. Origem.........: COM01 - GAP MGCOM01
Solicitante.........: Cliente
Uso.................: Marfrig           
Obs.................:
=====================================================================================
*/
Static Function EmpFilWF()
	Local _cAreaSM0 := GetArea("SM0")
	DbSelectArea("SM0")
	While ! SM0->(EOF())
		aadd(aEmps,{SM0->M0_CODIGO,SM0->M0_CODFIL,SM0->M0_NOME})
		SM0->(DbSkip())
	Enddo
	RestArea(_cAreaSM0)
return(aEmps)
