#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "ap5mail.ch"

#DEFINE CRLF Chr(13)+Chr(10)

static _aErr

/*
==============================================================================================================================================================================
Descrição   : Execução envio EXP para o TMS
@author     : Wagner Neves
@since      : 24/06/2020
==============================================================================================================================================================================
*/
User Function MGFEEC81( _cZB8_EXP, _ZB8ANOEXP, _ZB8SUBEXP, _cZB8_MOTE, _xZB8TMSACA, _lTela, aEmpFilial,_cFilTmsMs )

	Local lRet			:= .F.
	Local aArea			:= {}
	Local cURLPost 		:= allTrim( superGetMv( "MGF_TMSURE" , ,"http://integracoes-homologacao.marfrig.com.br:1451/processo-exportacao/api/v1/empresa/" ) )
	Local cURLUse		:= Alltrim(cUrlPost)+_cFilTmsMs+"/exp/"+AllTrim(ZB8->ZB8_EXP)
	local cJson			:= ""
	Local oItens		:= Nil
	Local cChave		:= ""
	Local nRet			:= 0
	Local cQ			:= ""
	Local cTamErro		:= 100
	Local bTms			:= .F.
	Local aExpTms		:= {}
	local aHeadStr		:= {}
	local nTimeOut		:= 120
	local cTimeIni		:= ""
	local cTimeFin		:= ""
	local cTimeProc		:= ""
	local cHttpRet		:= ""
	local _cUltAcao		:= ''
	Private _ZB8TMSACA := _xZB8TMSACA		// Transformo o escopo da variavel de local para private
	Private oPEXP    := Nil
	Private oWSPEXP  := Nil

	aExpTms	:= {}

	IF ( EMPTY(ZB8->ZB8_TMSACA) .OR. ZB8->ZB8_TMSACA='I' ) .and. EMPTY(ZB8->ZB8_ZTMSID) 
		_cUltAcao := _ZB8TMSACA
		cQ := "UPDATE "+ RetSqlName("ZB8")+" "
		cQ += "SET  ZB8_TMSACA = '" + _ZB8TMSACA + "'" 
		cQ += "WHERE R_E_C_N_O_ = "+Alltrim(Str(ZB8->(Recno())))
		nRet := tcSqlExec(cQ)
		If nRet == 0
		Else
			ConOut("Problemas na gravação dos campos da EXP, após o processo de envio ao Tms-MultiSoftware.")
		EndIf
	ElseIf ZB8->ZB8_TMSACA $"IA" .and. !EMPTY(ZB8->ZB8_ZTMSID) .and. ZB8->ZB8_MOTEXP <> '3'
		_cUltAcao := "A"
		cQ := "UPDATE "+ RetSqlName("ZB8")+" "
		cQ += "SET  ZB8_TMSACA = 'A'" 
		cQ += "WHERE R_E_C_N_O_ = "+Alltrim(Str(ZB8->(Recno())))
		nRet := tcSqlExec(cQ)
		If nRet == 0
		Else
			ConOut("Problemas na gravação dos campos da EXP, após o processo de envio ao Tms-MultiSoftware.")
		EndIf
	ElseIf ZB8->ZB8_MOTEXP = '3' .and. ZB8->ZB8_TMSACA $"IA" .and. !EMPTY(ZB8->ZB8_ZTMSID) 
		_cUltAcao := "C"
		cQ := "UPDATE "+ RetSqlName("ZB8")+" "
		cQ += "SET  ZB8_TMSACA = 'C'" 
		cQ += "WHERE R_E_C_N_O_ = "+Alltrim(Str(ZB8->(Recno())))
		nRet := tcSqlExec(cQ)
		If nRet == 0
		Else
			ConOut("Problemas na gravação dos campos da EXP, após o processo de envio ao Tms-MultiSoftware.")
		EndIf
	Else
		Alert("O envio da EXP ao TMS MULTISOFTWARE não foi realizado. Favor verificar os staus de ultima ação !!! ","TMS-MULTISOFTWARE")		
		Return
	EndIf

	nQtd1	:= MLCount(ZB8->ZB8_ZOBSPR)
	nI		:= 0
	cObs1	:= ''
	for nI :=1 to nQtd1
		cObs1 += MemoLine(ZB8->ZB8_ZOBSPR,,ni)
	next nI
	
	cObs2	:= ''
	IF ! EMPTY(ZB8->ZB8_CODMEM)
		_ChaveSyp := ZB8->ZB8_CODMEM
		_cMensSyp := E_MSMM(ZB8->ZB8_CODMEM,60)
		cObs2 := _cMensSyp
	endif

	oExp                                         	:= nil
	oExp                                            := jsonObject():new()
	oExp['dataCriacao']								:= left( fwTimeStamp( 3 , date() ) , 10 )
	oExp['idCliente']								:= allTrim(ZB8->ZB8_ZCLIET)+alltrim(ZB8->ZB8_ZLJAET)
	oExp['idImportador']							:= AllTrim(ZB8->ZB8_IMPORT)
	oExp['traceCode']								:= AllTrim(ZB8->ZB8_ZTRCOD)
	oExp['traceCodeReligioso']						:= AllTrim(ZB8->ZB8_ZTRCDR)
	oExp['halal']									:= If(ZB8->ZB8_ZHALAL=="S",.T.,.F.)
	oExp['observacaoTms']							:= "Observação Prob : "+alltrim(cObs1)+" - Observacao PCP : "+alltrim(cObs2)
	oExp['observacoes']								:= ""
	oExp['status']									:= "N"

	IF ! EMPTY(ZB8->ZB8_ZTMSID)
	  	oExp["idTransacao"] 						:= val(alltrim(ZB8->ZB8_ZTMSID))
	EndIf
	//_chave01 := alltrim(POSICIONE("EYG",1,XFILIAL("EYG")+ZB8->ZB8_ZCONTA,"EYG_CODCON"))
	_chave02 := 0
	_chave03 := ''
	IF EYG->(DBSEEK(XFILIAL("EYG")+ZB8->ZB8_ZCONTA))
		_chave02 := EYG->EYG_COMCON
		_chave03 := EYG->EYG_XTIPO
	ENDIF
	
	if ZB8->ZB8_ZTRANB="S" .Or. ZB8->ZB8_ZARMAZ="S"
		//_dDataCar := IIF(!EMPTY(ZB8->ZB8_ZDTTRA),left( fwTimeStamp( 3 , SToD( DTOS(ZB8->ZB8_ZDTTRA) ) ) , 10 ) +" - "+"00:00:00",'')
		_dDataCar := IIF(!EMPTY(ZB8->ZB8_ZDTTRA),DTOC(ZB8->ZB8_ZDTTRA)+" "+"00:00:00","")
	else
		//_dDataCar := IIF(!EMPTY(ZB8->ZB8_ZDTEST),left( fwTimeStamp( 3 , SToD( DTOS(ZB8->ZB8_ZDTEST) ) ) , 10 ) +" - "+"00:00:00","")
		_dDataCar := IIF(!EMPTY(ZB8->ZB8_ZDTEST),DTOC(ZB8->ZB8_ZDTEST)+" "+"00:00:00","")
	endif

	oExp["modeloVeicular"]  			            := IIF(_Chave02=0,'',alltrim(str(_Chave02)))+alltrim(_Chave03)
	oExp["cargaPaletizada"]                         := iif(alltrim(ZB8->ZB8_ZCARGA)=="1",.T.,.F.)

	IF !EMPTY(_dDataCar)
		oExp["dataCarregamento"]      		   		:= _dDataCar
	ENDIF

	IF ! EMPTY(ZB8->ZB8_ZDTDEC)
		oExp["dataPrevisaoEntrega"]                 := DTOC(ZB8->ZB8_ZDTDEC)+" "+iif(empty(ZB8->ZB8_ZHDECA),"00:00:00",ZB8->ZB8_ZHDECA)
	ENDIF

	IF ! EMPTY(ZB8->ZB8_ZETAOR)
		oExp["dataChegadaPorto"]                    := DTOC(ZB8->ZB8_ZETAOR )+" "+"00:00:00"
	ENDIF

	IF ! EMPTY(ZB8->ZB8_ZDAEST)
		oExp["dataSaidaPorto"]           	        := DTOC(ZB8->ZB8_ZDAEST) +" "+"00:00:00"
	ENDIF

	oExp["dataFreeDetention"]                       := alltrim(ZB8->ZB8_ZFREED) //VERIFICAR COM O HIDEO SE É OBRIGATORIO
	oExp["genset"]   		                        := iif(alltrim(ZB8->ZB8_ZGENSE)=="N",.F.,.T.)
	oExp["temperatura"]                             := alltrim(ZB8->ZB8_ZTEMPE)
	oExp["tipoPagamento"]                           := "C"
	oExp["integraTms"]  	                        := .T.
	oExp["ultimaAcao"]  	                        := _cUltAcao //alltrim(ZB8->ZB8_TMSACA)
	oExp["tipoProbe"]                               := alltrim(ZB8->ZB8_ZUSAPR)
	oExp["tipoFrete"]                       		:= alltrim(ZB8->ZB8_FRPPCC)
	oExp["numeroPedido"]                  			:= IIF(EMPTY(ZB8->ZB8_PEDFAT),SUBS(ZB8->ZB8_EXP,4,6)+"/"+alltrim(ZB8->ZB8_ANOEXP)+"-"+ZB8->ZB8_SUBEXP,ZB8->ZB8_PEDFAT)
	//oExp["idExp"]  		                        := IIF(EMPTY(ZB8->ZB8_PEDFAT),SUBS(ZB8->ZB8_EXP,4,6)+"/"+alltrim(ZB8->ZB8_ANOEXP)+ZB8->ZB8_SUBEXP,ZB8->ZB8_PEDFAT)
	//oExp["numeroExp"]		                        := IIF(EMPTY(ZB8->ZB8_PEDFAT),SUBS(ZB8->ZB8_EXP,4,6)+"/"+alltrim(ZB8->ZB8_ANOEXP)+ZB8->ZB8_SUBEXP,ZB8->ZB8_PEDFAT)
	oExp["numeroExp"]		                        := SUBS(ZB8->ZB8_EXP,4,6)+"/"+alltrim(ZB8->ZB8_ANOEXP)+"-"+ZB8->ZB8_SUBEXP
	oExp["numeroReserva"]                           := alltrim(ZB8->ZB8_ZNUMRE)
	oExp["statusExp"]                               := alltrim(ZB8->ZB8_MOTEXP)

	_Pesoliquido := fPesoLiqPed(ZB8->ZB8_FILIAL, ZB8->ZB8_EXP + ZB8->ZB8_ANOEXP + ZB8->ZB8_SUBEXP)
	_Pesobruto   := fPesoBruto(ZB8->ZB8_FILIAL, ZB8->ZB8_EXP + ZB8->ZB8_ANOEXP + ZB8->ZB8_SUBEXP)

	oExp["pesoLiquido"]                             := _PesoLiquido
	oExp["pesoBruto"]   	                        := iif(_PesoBruto==0,_PesoLiquido,_PesoBruto)

	SA1->(DBSETORDER(1))
	SA1->(DBSEEK(xFilial("SA1")+ZB8->ZB8_CONSIG+ZB8->ZB8_COLOJA))

//CLIENTE
	oCliAdic                                        := nil
	oCliAdic                                        := jsonObject():new()
	oCliAdic["id"] 		                            := alltrim(SA1->A1_COD)+alltrim(SA1->A1_LOJA)
	oCliAdic["cnpj"]                                := IIF(SA1->A1_EST="EX","99999999999999",alltrim(SA1->A1_CGC))
	oCliAdic["email"]  			                    := alltrim(SA1->A1_EMAIL)
	oCliAdic["nomeFantasia"]                        := alltrim(SA1->A1_NREDUZ)
	oCliAdic["rgIe"]                                := alltrim(SA1->A1_INSCR)
	oCliAdic["razaoSocial"]                         := alltrim(SA1->A1_NOME)
	oExp["cliente"]	        	                    := oCliAdic

	oEndCliAdic                                     := nil
	oEndCliAdic                                     := jsonObject():new()
	oEndCliAdic["bairro"]                           := alltrim(SA1->A1_BAIRRO)
	oEndCliAdic["cep"]                              := alltrim(SA1->A1_CEP)
	oEndCliAdic["complemento"]                      := alltrim(SA1->A1_COMPLEM)
	oEndCliAdic["logradouro"]                       := alltrim(SA1->A1_END)
	oEndCliAdic["ddd"] 			                    := VAL(alltrim(SA1->A1_DDD))
	oEndCliAdic["telefone"]                         := iif(Empty(SA1->A1_TEL),"99999999",Alltrim(SA1->A1_TEL))
	oEndCliAdic["cidade"]                           := POSICIONE("CC2",3,xFilial("CC2")+SA1->A1_COD_MUN,"CC2_MUN")
	fIbge(SA1->A1_EST)
	oEndCliAdic["ibge"]                             := val(alltrim(fcodIbge)+alltrim(SA1->A1_COD_MUN))
	oEndCliAdic["nomePais"]                         := POSICIONE("SYA",1,xFilial("SYA")+SA1->A1_PAIS,"YA_DESCR")
	oEndCliAdic["idPais"]                           := POSICIONE("SYA",1,xFilial("SYA")+SA1->A1_PAIS,"YA_SISEXP")
	oCliAdic["endereco"]	           	            := oEndCliAdic


//ARMADOR 
	_cCodArm  := POSICIONE("SY5",1,xFilial("SY5")+ZB8->ZB8_ZARMAD,"Y5_FORNECE")
	_cLojArm  := POSICIONE("SY5",1,xFilial("SY5")+ZB8->ZB8_ZARMAD,"Y5_LOJAF")
	
	SA2->(DBSETORDER(1))
	If SA2->(DBSEEK(xFilial("SY5")+_cCodArm + _cLojArm ))
		oCliDonoCont                               		:= NIL  // ARMADOR
		oCliDonoCont                               		:= jsonObject():new()
		oCliDonoCont["id"]  	                  		:= ""
		oCliDonoCont["cnpj"]                    		:= alltrim(SA2->A2_CGC)
		oCliDonoCont["email"]                    		:= alltrim(SA2->A2_EMAIL)
		oCliDonoCont["nomeFantasia"]               		:= ""
		oCliDonoCont["rgIe"] 		              		:= alltrim(SA2->A2_INSCR)
		oCliDonoCont["razaoSocial"]               		:= alltrim(SA2->A2_NOME)
		oExp["armador"]	        						:= oCliDonoCont

		oCliDonoEnd                                 	:= NIL
		oCliDonoEnd                                 	:= jsonObject():new()
		oCliDonoEnd["bairro"]                       	:= alltrim(SA2->A2_BAIRRO)
		oCliDonoEnd["cep"]                          	:= alltrim(SA2->A2_CEP)
		oCliDonoEnd["complemento"]                  	:= ""
		oCliDonoEnd["logradouro"]                   	:= alltrim(SA2->A2_END)
		oCliDonoEnd["ddd"]   		 	          		:= 0
		oCliDonoEnd["telefone"]                    		:= alltrim(SA2->A2_TEL)
		
		fIbge(SA2->A2_EST)
		oCliDonoEnd["ibge"]   		 	           		:= val(alltrim(fcodIbge)+alltrim(SA2->A2_COD_MUN))
		
		oCliDonoEnd["cidade"]                       	:= alltrim(SA2->A2_MUN)
		oCliDonoEnd["nomePais"]                 	    := POSICIONE("SYA",1,xFilial("SYA")+SA2->A2_PAIS,"YA_DESCR")
		oCliDonoEnd["idPais"]               	        := ALLTRIM(POSICIONE("SYA",1,xFilial("SYA")+SA2->A2_PAIS,"YA_SISEXP"))
		oCliDonoCont["endereco"]						:= oCliDonoEnd
	EndIf
	oDespachante                                    := NIL
	oDespachante                                    := jsonObject():new()
	oDespachante["id"]                              := alltrim(ZB8->ZB8_XAGEMB)
	oDespachante["descricao"]                       := ALLTRIM(POSICIONE("SY5",1,xFilial("SY5")+ZB8->ZB8_XAGEMB,"Y5_NOME"))
	oExp["despachante"]	                       	    := oDespachante

//----------Destinatario -------------------------------------------------------------------------------------------

	fBuscaDest()

	oDestinatario                                   := NIL
	oDestinatario                                   := jsonObject():new()
	oDestinatario["cnpj"]                           := IIF(QRYDEST->A1_EST="EX","99999999999999",alltrim(QRYDEST->SA1_CGC))
	oDestinatario["nomeFantasia"]                   := alltrim(QRYDEST->A1_NREDUZ)
	oDestinatario["rgIe"]                           := alltrim(QRYDEST->A1_INSCR)
	oDestinatario["razaoSocial"]                    := alltrim(QRYDEST->A1_NOME)
	oExp["intermediario"]	                       	:= oDestinatario

	oDestinEnd                               		:= NIL
	oDestinEnd                                		:= jsonObject():new()
	oDestinEnd["bairro"]                     		:= alltrim(QRYDEST->A1_BAIRRO)
	oDestinEnd["cep"]                         		:= alltrim(QRYDEST->A1_CEP)
	oDestinEnd["complemento"]                 		:= alltrim(QRYDEST->A1_COMPLEM)
	oDestinEnd["logradouro"]                 		:= alltrim(QRYDEST->A1_END)
	oDestinEnd["ddd"]     			           		:= val(alltrim(QRYDEST->A1_DDD))
	oDestinEnd["telefone"]                   		:= iif(Empty(QRYDEST->A1_TEL),"99999999",Alltrim(QRYDEST->A1_TEL))
	fIbge(QRYDEST->A1_EST)
	oDestinEnd["ibge"]                        		:= val(alltrim(fcodIbge)+alltrim(QRYDEST->A1_COD_MUN))
	oDestinEnd["nomePais"]                    		:= POSICIONE("SYA",1,xFilial("SYA")+QRYDEST->A1_PAIS,"YA_DESCR")
	oDestinEnd["idPais"]                   			:= POSICIONE("SYA",1,xFilial("SYA")+QRYDEST->A1_PAIS,"YA_SISEXP")
	oDestinatario["endereco"]		          		:= oDestinEnd

	oEspeciePedido                                  := NIL
	oEspeciePedido                                  := jsonObject():new()
	oEspeciePedido["id"]                	        := alltrim(ZB8->ZB8_ZTIPPE)
	oEspeciePedido["descricao"]                     := alltrim(POSICIONE("SZJ",1,xFilial("SZJ")+ZB8->ZB8_ZTIPPE,"ZJ_NOME"))
	oExp["especie"]	    		               	    := oEspeciePedido

	fExpedidor()

	oExpedidor                                      := NIL
	oExpedidor                                      := jsonObject():new()
	oExpedidor["cnpj"]              	            := IIF(QRYEXP->A1_EST="EX","99999999999999",alltrim(QRYEXP->A1_CGC))
	oExpedidor["nomeFantasia"]                      := alltrim(QRYEXP->A1_NREDUZ)
	oExpedidor["rgIe"]                              := alltrim(QRYEXP->A1_INSCR)
	oExpedidor["razaoSocial"]                       := alltrim(QRYEXP->A1_NOME)
	oExp["expedidor"]	                       	    := oExpedidor

	oExpedEnd                                       := NIL
	oExpedEnd                                       := jsonObject():new()
	oExpedEnd["bairro"]                             := alltrim(QRYEXP->A1_BAIRRO)
	oExpedEnd["cep"]                                := alltrim(QRYEXP->A1_CEP)
	oExpedEnd["complemento"]                    	:= alltrim(QRYEXP->A1_COMPLEM)
	oExpedEnd["logradouro"]                    		:= alltrim(QRYEXP->A1_END)
	oExpedEnd["ddd"]                    			:= val(alltrim(QRYEXP->A1_DDD))
	oExpedEnd["telefone"]                           := iif(Empty(QRYEXP->A1_TEL),"99999999",Alltrim(QRYEXP->A1_TEL))
	fIbge(QRYEXP->A1_EST)
	oExpedEnd["ibge"]                               := val(alltrim(fcodIbge)+alltrim(QRYEXP->A1_COD_MUN))
	oExpedEnd["nomePais"]                           := POSICIONE("SYA",1,xFilial("SYA")+QRYEXP->A1_PAIS,"YA_DESCR")
	oExpedEnd["idPais"]                 		    := POSICIONE("SYA",1,xFilial("SYA")+QRYEXP->A1_PAIS,"YA_SISEXP")
	oExpedidor["endereco"]		                    := oExpedEnd

	oFuncVendedor                           		:= NIL
	oFuncVendedor                            		:= jsonObject():new()
	oFuncVendedor["cnpj"]                    		:= POSICIONE("SA3",1,xFilial("SA3")+ZB8->ZB8_ZTRADE,"A3_CGC")
	oFuncVendedor["email"]                   		:= alltrim(POSICIONE("SA3",1,xFilial("SA3")+ZB8->ZB8_ZTRADE,"A3_EMAIL"))
	oFuncVendedor["nomeFantasia"]              		:= POSICIONE("SA3",1,xFilial("SA3")+ZB8->ZB8_ZTRADE,"A3_NOME")
	oExp["vendedor"]	                      	    := oFuncVendedor

	_cDddvend := POSICIONE("SA3",1,xFilial("SA3")+ZB8->ZB8_ZTRADE,"A3_DDD")
	_cTelvend := POSICIONE("SA3",1,xFilial("SA3")+ZB8->ZB8_ZTRADE,"A3_TEL")
	oFuncVenEnd		                           		:= NIL
	oFuncVenEnd     	                       		:= jsonObject():new()
	oFuncVenEnd["telefone"]                   		:= _cDddVend+"-"+_cTelvend
	oFuncVendedor["endereco"]	               	    := oFuncVenEnd

	oInland                                         := NIL
	oInland                                         := jsonObject():new()
	oInland["id"]                                   := alltrim(ZB8->ZB8_INLAND)
	oInland["descricao"]                            := alltrim(ZB8->ZB8_INLADS)
	oExp["inland"]	                          	    := oInland

	oNavio                           		        := NIL
	oNavio                  		                := jsonObject():new()
	oNavio["id"]  			                        := alltrim(ZB8->ZB8_ZNTRAN)
	IF ! EMPTY(ZB8->ZB8_ZDTDEC)
		oNavio["dataDeadlineCarga"]    	            := DTOC(ZB8->ZB8_ZDTDEC)+" "+iif(empty(ZB8->ZB8_ZHDECA),"00:00:00",ZB8->ZB8_ZHDECA)

	ENDIF

	IF ! EMPTY(ZB8->ZB8_ZDELDR)
		oNavio["dataDeadline"]                      := DTOC(ZB8->ZB8_ZDELDR)+" "+iif(empty(ZB8->ZB8_ZHORAS),"00:00:00",ZB8->ZB8_ZHORAS)
	ENDIF

	oNavio["descricao"]  	                        := POSICIONE("EE6",1,xFilial("EE6")+ZB8->ZB8_ZNTRAN,"EE6_NOME")
	oExp["navio"]	                      	        := oNavio

	oPorto      		                       		:= NIL
	oPorto		                             		:= jsonObject():new()
	oExp["porto"]	 		                      	:= oPorto

	oPortoViagOrig                              	:= NIL
	oPortoViagOrig                             		:= jsonObject():new()
	oPortoViagOrig["id"]                         	:= alltrim(ZB8->ZB8_ORIGEM)
	oPortoViagOrig["descricao"]               	 	:= POSICIONE("SY9",2,xFilial("SY9")+ZB8->ZB8_ORIGEM,"Y9_DESCR")

	_CodPaisPorto := POSICIONE("SY9",2,xFilial("SY9")+ZB8->ZB8_ORIGEM,"Y9_PAIS")
	
	oPortoViagOrig["nomePais"]                     	:= POSICIONE("SYA",1,xFilial("SYA")+_CodPaisPorto,"YA_DESCR")
	oPorto["origem"]	 			                := oPortoViagOrig

	oPortoViagDest                             		:= NIL
	oPortoViagDest                             		:= jsonObject():new()
	oPortoViagDest["id"]                      		:= alltrim(ZB8->ZB8_DEST)
	oPortoViagDest["descricao"]               		:= alltrim(POSICIONE("SY9",1,xFilial("SY9")+ZB8->ZB8_DEST,"Y9_DESCR"))
	oPortoViagDest["nomePais"]                 		:= alltrim(POSICIONE("SYA",1,xFilial("SYA")+ZB8->ZB8_PAISET,"YA_DESCR"))
	oPorto["destino"]	               		    	:= oPortoViagDest

// PRODUTO ---------------------------------------------------------------------------------------------------------------------------------
	IF ZB8->ZB8_TMSACA <> "C"		// Se for C=Cancelamento, não envio os itens do PV
		If ZB9->(dbSeek(xFilial("ZB9")+ZB8->ZB8_EXP+ZB8->ZB8_ANOEXP+ZB8->ZB8_SUBEXP))

			oExp["itens"]	:= {}

			While ZB9->(!Eof()) .and. xFilial("ZB9")+ZB8->ZB8_EXP+ZB8->ZB8_ANOEXP+ZB8->ZB8_SUBEXP==ZB9->ZB9_FILIAL +ZB9->ZB9_EXP +ZB9->ZB9_ANOEXP + ZB9->ZB9_SUBEXP
				oItens										:= Nil
				oItens										:=jsonObject():new()
				oItens["idEmpresa"]                         := _cFilTmsMs
				oItens["idProduto"]                     	:= alltrim(ZB9->ZB9_COD_I)
				oItens["quantidade"]                	    := ZB9->ZB9_SLDINI
				oItens["valor"]                 	      	:= ZB9->ZB9_PRECO
				oItens["pesoUnitario"]      	            := 1
				oItens["unidadeMedida"]   	                := alltrim(ZB9->ZB9_UNIDAD)

				_cGrupo 	:= POSICIONE("SB1",1,xFilial("SB1")+ZB9->ZB9_COD_I,"B1_GRUPO")
				_cNomeGrupo := POSICIONE("SBM",1,xFilial("SBM")+_cGrupo,"BM_DESC")
				oItens["descricao"]                  		:= alltrim(ZB9->ZB9_DESC)
				oItens["idGrupo"]						    := _cGrupo
				oItens["nomeGrupo"]							:= alltrim(_cNomeGrupo)
				ZB9->(dbSkip())

				aadd( oExp["itens"] , oItens )

				freeObj( oItens )

			Enddo

		Endif
	Endif

// RECEBEDOR ---------------------------------------------------------------------------------------------------------------------------------

	fBuscaRec()

	oRecebedor                                      := NIL
	oRecebedor                                      := jsonObject():new()
	oRecebedor["cnpj"]                              := alltrim(QRYREC->CGC)
	oRecebedor["nomeFantasia"]                      := alltrim(QryRec->NREDUZ)
	oRecebedor["rgIe"]                              := alltrim(QryRec->INSCR)
	oRecebedor["razaoSocial"]                       := alltrim(QryRec->NOME)
	oExp["recebedor"]	                          	:= oRecebedor

	oRecebEnd                                   	:= NIL
	oRecebEnd                                   	:= jsonObject():new()
	oRecebEnd["bairro"]                         	:= alltrim(QryRec->BAIRRO)
	oRecebEnd["cep"]                            	:= alltrim(QryRec->CEP)
	oRecebEnd["complemento"]                    	:= alltrim(QryRec->COMPLEM)
	oRecebEnd["logradouro"]                     	:= alltrim(QryRec->END)
	oRecebEnd["numero"]    		                	:= " "
	oRecebEnd["ddd"]                    			:= val(alltrim(QryRec->DDD))
	oRecebEnd["telefone"]                       	:= IIF(EMPTY(QryRec->TEL),"99999999",alltrim(QryRec->TEL))
	fIbge(QRYREC->EST)						
	oRecebEnd["ibge"]                           	:= val(alltrim(fcodIbge)+alltrim(QRYREC->CODMUN))
	oRecebEnd["nomePais"]                       	:= alltrim(POSICIONE("SYA",1,xFilial("SYA")+QRYREC->PAIS,"YA_DESCR"))
	oRecebEnd["idPais"]                				:= alltrim(POSICIONE("SYA",1,xFilial("SYA")+QRYREC->PAIS,"YA_SISEXP"))
	oRecebedor["endereco"]	                      	:= oRecebEnd

	fRemetente()

// REMETENTE ---------------------------------------------------------------------------------------------------------------------------------
	oRemetente                                      := NIL
	oRemetente                                      := jsonObject():new()
	oRemetente["cnpj"]                              := IIF(QryRem->A1_EST="EX","99999999999999",alltrim(QryRem->A1_CGC))
	oRemetente["nomeFantasia"]                      := alltrim(QryRem->A1_NREDUZ)
	oRemetente["rgIe"]                              := alltrim(QryRem->A1_INSCR)
	oRemetente["razaoSocial"]                       := alltrim(QryRem->A1_NOME)
	oExp["remetente"]	                          	:= oRemetente

	oRemetEnd                         		        := NIL
	oRemetEnd                               	    := jsonObject():new()
	oRemetEnd["bairro"]                         	:= alltrim(QryRem->A1_BAIRRO)
	oRemetEnd["cep"]                            	:= alltrim(QryRem->A1_CEP)
	oRemetEnd["complemento"]                    	:= alltrim(QryRem->A1_COMPLEM)
	oRemetEnd["logradouro"]                     	:= alltrim(QryRem->A1_END)
	oRemetEnd["ddd"]                            	:= val(alltrim(QryRem->A1_DDD))
	oRemetEnd["telefone"]                       	:= IIF(EMPTY(QryRem->A1_TEL),"99999999",alltrim(QryRem->A1_TEL))
	fIbge(QRYREM->A1_EST)
	oRemetEnd["ibge"]                           	:= val(alltrim(fcodIbge)+alltrim(QRYREM->A1_COD_MUN))
	oRemetEnd["nomePais"]                       	:= POSICIONE("SYA",1,xFilial("SYA")+QRYREM->A1_PAIS,"YA_DESCR")
	oRemetEnd["idPais"]                         	:= POSICIONE("SYA",1,xFilial("SYA")+QRYREM->A1_PAIS,"YA_SISEXP")
	oRemetente["endereco"]		                    := oRemetEnd

	oTipoCargaEmbarcador                            := NIL
	oTipoCargaEmbarcador                            := jsonObject():new()
	oTipoCargaEmbarcador["id"] 				        := alltrim(ZB8->ZB8_ZTPROD)
	oTipoCargaEmbarcador["descricao"]               := POSICIONE("SYC",1,xfilial("SYC")+ZB8->ZB8_ZTPROD,"YC_NOME")
	oExp["tipoCargaEmbarcador"]		                := oTipoCargaEmbarcador

	oViaTransporte                                  := NIL
	oViaTransporte                                  := jsonObject():new()
	oViaTransporte["id"]                            := ZB8->ZB8_VIA
	oViaTransporte["descricao"]                     := alltrim(POSICIONE("SYQ",1,xFilial("SYQ")+ZB8->ZB8_VIA,"YQ_DESCR"))
	oExp["transporte"]		      	     	        := oViaTransporte

	aadd( aExpTms, oExp )

	cHTTPMetho	:= "PUT"
	cJson       := ""

	cJson		:= oExp:toJson()
	cHeaderRet	:= ""
	cHttpRet	:= ""
	cIdInteg	:= fwUUIDv4( .T. )
	cTimeIni	:= time()
	aHeadStr	:= {}

	aadd( aHeadStr , 'Content-Type: application/json'				)
	aadd( aHeadStr , 'origem-criacao: ' + " "						) // ver flag de origem do pedido
	aadd( aHeadStr , 'origem-alteracao: protheus'					)
	aadd( aHeadStr , 'x-marfrig-client-id: ' + ""					)
	aadd( aHeadStr , 'x-correlation-id: ' + cIdInteg				)
	aadd( aHeadStr , 'callback: ' + 'true' 							)

	cHttpRet	:= httpQuote( cURLUse /*<cUrl>*/, cHTTPMetho /*<cMethod>*/, /*[cGETParms]*/, cJson /*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadStr /*[aHeadStr]*/, cHeaderRet /*[@cHeaderRet]*/ )
	cTimeFin	:= time()
	cTimeProc	:= elapTime( cTimeIni , cTimeFin )
	nStatuHttp	:= 0
	nStatuHttp	:= httpGetStatus()

	conout(" [TMS] [MGFEEC81] * * * * * Status da integracao TMS * * * * *"									)
	conout(" [TMS] [MGFEEC81] Inicio.......................: " + cTimeIni + " - " + dToC( dDataBase )	)
	conout(" [TMS] [MGFEEC81] Fim..........................: " + cTimeFin + " - " + dToC( dDataBase )	)
	conout(" [TMS] [MGFEEC81] Tempo de Processamento.......: " + cTimeProc 								)
	conout(" [TMS] [MGFEEC81] URL..........................: " + cURLUse 								)
	conout(" [TMS] [MGFEEC81] HTTP Method..................: " + cHTTPMetho								)
	conout(" [TMS] [MGFEEC81] Status Http (200 a 299 ok)...: " + allTrim( str( nStatuHttp ) ) 			)
	conout(" [TMS] [MGFEEC81] Envio Headers................: " + varInfo( "aHeadStr" , aHeadStr ) 		)
	conout(" [TMS] [MGFEEC81] Envio Body...................: " + cJson 									)
	conout(" [TMS] [MGFEEC81] Retorno......................: " + cHttpRet 								)
	conout(" [TMS] [MGFEEC81] * * * * * * * * * * * * * * * * * * * * "									)

	MemoWrite( "C:\TEMP\TMSEXP_MS_"+ALLTRIM(ZB8->ZB8_EXP)+".TXT",cJson)

	freeObj( oExp )

	cMsgErro := ''

	If Valtype(cHttpRet) == 'C'
		cMsgErro := cHttpRet
	EndIf

	If 	! Empty(cMsgErro)
	   	Alert(AllTrim(cMsgErro),"ATENÇÃO")
	Else   
		Alert("Envio do EXP ao TMS MULTISOFTWARE finalizado com sucesso !!! ","TMS-MULTISOFTWARE")
	EndIf	
//
	If Select("QRYREC") # 0
		QRYREC->(dbCloseArea())
	EndIf

	If Select("QRYREM") # 0
		QRYREM->(DbCloseArea())
	EndIf

	If Select("QRYEXP") # 0
		QRYEXP->(DbCloseArea())
	EndIf

	If Select("QRYDEST") # 0
		QRYDEST->(DbCloseArea())
	EndIf
//	

Return

//--------------------------------------------------------------------------------------------
// Peso Liquido
//--------------------------------------------------------------------------------------------
Static Function fPesoLiqPed(_ZB9FILIAL, _cChave_EXP )		//ZB9_FILIAL || ZB9_EXP || ZB9_ANOEXP || ZB9_SUBEXP
	Local aArea		:= {GetArea()}
	Local cAliasTrb := GetNextAlias()
	_nRet	:= 0
	_cQuery := " SELECT ZB9_PSLQTO PESO_ITEM, ZB9.D_E_L_E_T_ ZB9_D_E_L_E_T_  "
	_cQuery += " FROM "       + RetSqlName("ZB9") + " ZB9 "
	_cQuery += " WHERE  ZB9_FILIAL || ZB9_EXP || ZB9_ANOEXP || ZB9_SUBEXP = '"+ xFilial("ZB9") + _cChave_EXP + "' "
	_cQuery += " AND ZB9.D_E_L_E_T_ <> '*'   "
	_cQuery := ChangeQuery(_cQuery)
	dbUseArea(.T.,"TOPCONN",tcGenQry(,,_cQuery),cAliasTrb,.T.,.T.)
	(cAliasTrb)->(dbGoTop())
	While (cAliasTrb)->(!Eof())
		_nRet += (cAliasTrb)->PESO_ITEM
		(cAliasTrb)->(dbSkip())
	Enddo
	(cAliasTrb)->(dbCloseArea())
	aEval(aArea,{|x| RestArea(x)})
Return _nRet

//--------------------------------------------------------------------------------------------
// Peso Bruto
//--------------------------------------------------------------------------------------------
Static Function fPesoBruto(_ZB9FILIAL, _cChave_EXP )		//ZB9_FILIAL || ZB9_EXP || ZB9_ANOEXP || ZB9_SUBEXP
	Local aArea		:= {GetArea()}
	Local cAliasTrb := GetNextAlias()
	_nRet	:= 0
	_cQuery := " SELECT ZB9_PSBRTO PESO_BRUTO, ZB9.D_E_L_E_T_ ZB9_D_E_L_E_T_  "
	_cQuery += " FROM "       + RetSqlName("ZB9") + " ZB9 "
	_cQuery += " WHERE  ZB9_FILIAL || ZB9_EXP || ZB9_ANOEXP || ZB9_SUBEXP = '"+ xFilial("ZB9") + _cChave_EXP + "' "
	_cQuery += " AND ZB9.D_E_L_E_T_ <> '*'   "
	_cQuery := ChangeQuery(_cQuery)
	dbUseArea(.T.,"TOPCONN",tcGenQry(,,_cQuery),cAliasTrb,.T.,.T.)
	(cAliasTrb)->(dbGoTop())
	While (cAliasTrb)->(!Eof())
		_nRet += (cAliasTrb)->PESO_BRUTO
		(cAliasTrb)->(dbSkip())
	Enddo
	(cAliasTrb)->(dbCloseArea())
	aEval(aArea,{|x| RestArea(x)})
Return _nRet

//--------------------------------------------------------------------------------------------
// Localiza o destinatario
//--------------------------------------------------------------------------------------------
Static function fBuscaDest()
	If Select("QRYDEST") # 0
		QRYDEST->(dbCloseArea())
	EndIf
	cQryDest := ' '
	cQryDest := + CRLF + "SELECT"
	cQryDest += + CRLF + " A1_COD,      A1_LOJA,   A1_NOME,     A1_NREDUZ,  A1_INSCR,   A1_BAIRRO,  A1_CEP,"
	cQryDest += + CRLF + " A1_COMPLEM,  A1_END ,   A1_DDD,      A1_TEL,     A1_COD_MUN, A1_PAIS,    A1_EST, A1_CGC"
	cQryDest += + CRLF + " FROM "	+ RetSQLName("SA1") + " TSA1"
	cQryDest += + CRLF + " WHERE "
	cQryDest += + CRLF + "  TSA1.A1_FILIAL='"+xFilial("SA1")+"'"
	cQryDest += + CRLF + " 	AND TSA1.A1_COD='"+ZB8->ZB8_IMPORT+"'"
	cQryDest += + CRLF + "  AND TSA1.A1_LOJA='"+ZB8->ZB8_IMLOJA+"'"
	cQryDest += + CRLF + "  AND TSA1.D_E_L_E_T_ = ' ' "
	tcQuery cQryDest New Alias "QRYDEST"
Return

//--------------------------------------------------------------------------------------------
// Localiza o Expedidor
//--------------------------------------------------------------------------------------------
Static function fExpedidor()
	If ZB8->ZB8_ZTRANB='S' .Or. ZB8->ZB8_ZARMAZ='S'
		_cExpedidor := ZB8->ZB8_ZLOCAL
		_cFilial    := ZB8->ZB8_ZLOCAL
		_cRemetente := ZB8->ZB8_ZCODES
		_dDataInicioCarregamento := ZB8->ZB8_ZDTTRA
	else
		_cExpedidor := ZB8->ZB8_ZCODES
		_cFilial    := ZB8->ZB8_ZCODES
		_cRemetente := ZB8->ZB8_ZCODES
		_dDataInicioCarregamento := ZB8->ZB8_ZDTEST
	EndIf
	_cCodExpedidor := POSICIONE("ZBM",1,xFilial("ZBM")+_cExpedidor,"ZBM_CODCLI")
	_cLojExpedidor := POSICIONE("ZBM",1,xFilial("ZBM")+_cExpedidor,"ZBM_LOJCLI")

	If Select("QRYEXP") # 0
		QRYEXP->(dbCloseArea())
	EndIf
	cQryExp := ' '
	cQryExp := + CRLF + "SELECT"
	cQryExp += + CRLF + " A1_COD,      A1_LOJA,   A1_NOME,     A1_NREDUZ,  A1_INSCR,   A1_BAIRRO,  A1_CEP,"
	cQryExp += + CRLF + " A1_COMPLEM,  A1_END ,   A1_DDD,      A1_TEL,     A1_COD_MUN, A1_PAIS,    A1_EST, A1_CGC"
	cQryExp += + CRLF + " FROM "	+ RetSQLName("SA1") + " ESA1"
	cQryExp += + CRLF + " WHERE "
	cQryExp += + CRLF + "  ESA1.A1_FILIAL='"+xFilial("SA1")+"'"
	cQryExp += + CRLF + "  AND ESA1.A1_COD='"+_cCodExpedidor+"'"
	cQryExp += + CRLF + "  AND ESA1.A1_LOJA='"+_cLojExpedidor+"'"
	cQryExp += + CRLF + "  AND ESA1.D_E_L_E_T_ = ' ' "
	tcQuery cQryExp New Alias "QRYEXP"
Return

//--------------------------------------------------------------------------------------------
// Localiza o Remetente
//--------------------------------------------------------------------------------------------
Static function fRemetente()
	If ZB8->ZB8_ZTRANB='S' .Or. ZB8->ZB8_ZARMAZ='S'
		_cRemetente := ZB8->ZB8_ZCODES
	else
		_cRemetente := ZB8->ZB8_ZCODES
	EndIf
	_cCodRemetente := POSICIONE("ZBM",1,xFilial("ZBM")+_cRemetente,"ZBM_CODCLI")
	_cLojRemetente := POSICIONE("ZBM",1,xFilial("ZBM")+_cRemetente,"ZBM_LOJCLI")

	If Select("QRYREM") # 0
		QRYREM->(dbCloseArea())
	EndIf
	cQryRem := ' '
	cQryRem := + CRLF + "SELECT"
	cQryRem += + CRLF + " A1_COD,      A1_LOJA,   A1_NOME,     A1_NREDUZ,  A1_INSCR,   A1_BAIRRO,  A1_CEP,"
	cQryRem += + CRLF + " A1_COMPLEM,  A1_END ,   A1_DDD,      A1_TEL,     A1_COD_MUN, A1_PAIS,    A1_EST, A1_CGC"
	cQryRem += + CRLF + " FROM " + RetSQLName("SA1") + " RSA1"
	cQryRem += + CRLF + " WHERE "
	cQryRem += + CRLF + "  RSA1.A1_FILIAL='"+xFilial("SA1")+"'"
	cQryRem += + CRLF + "  AND RSA1.A1_COD='" +_cCodRemetente+"'"
	cQryRem += + CRLF + "  AND RSA1.A1_LOJA='"+_cLojRemetente+"'"
	cQryRem += + CRLF + "  AND RSA1.D_E_L_E_T_ = ' ' "
	tcQuery cQryRem New Alias "QRYREM"
Return

//--------------------------------------------------------------------------------------------
// Localiza o Recebedor
//--------------------------------------------------------------------------------------------
Static function fBuscaRec()
	_cRecebe := allTrim( superGetMv( "MGF_TMSREC" , , "IOA00011301/ITJ00843001/NVG00011601/PNG00117901/RGE00015201/SSZ00843101/VDC06441901/CBE00034905/RND00034904" ) )
	If alltrim(ZB8->ZB8_VIA)=="01" .And. ZB8->ZB8_INLAND $"01|  " // Maritima
		_cOrigRec       := ZB8->ZB8_ORIGEM
		_cCodRecebedor  := Subs(_crecebe,AT(_cOrigRec,_cRecebe)+3,8)
	ENDIF

	IF ZB8->ZB8_ORIGEM == "SSZ" .And. alltrim(ZB8->ZB8_VIA)=="01" .And. ZB8->ZB8_INLAND="02"
		_cOrigRec      := "RND"
		_cCodRecebedor  := Subs(_crecebe,AT(_cOrigRec,_cRecebe)+3,8)
	ENDIF

	IF ZB8->ZB8_ORIGEM == "PNG" .And. alltrim(ZB8->ZB8_VIA)=="01" .And. ZB8->ZB8_INLAND="02"
		_cOrigRec      := "CBE"
		_cCodRecebedor  := Subs(_crecebe,AT(_cOrigRec,_cRecebe)+3,8)
	ENDIF

	IF alltrim(ZB8->ZB8_VIA) $"02|03|04"
		_cCodRecebedor := ZB8->(ZB8_IMPORT+ZB8_IMLOJA)
	ENDIF
	If Select("QRYDREC") # 0
		QRYREC->(dbCloseArea())
	EndIf
	cQryRec := ' '
	IF alltrim(ZB8->ZB8_VIA) $"02|03|04"
		cQryRec := + CRLF + "SELECT"
		cQryRec += + CRLF + " A1_COD COD,      A1_LOJA LOJA,   A1_NOME NOME,     A1_NREDUZ NREDUZ,  A1_INSCR INSCR,   A1_BAIRRO BAIRRO,  A1_CEP CEP,"
		cQryRec += + CRLF + " A1_COMPLEM COMPLEM,  A1_END END,   A1_DDD DDD,      A1_TEL TEL,     A1_COD_MUN CODMUN, A1_PAIS PAIS,    A1_EST EST, A1_CGC CGC"
		cQryRec += + CRLF + " FROM "	+ RetSQLName("SA1") + " TSA1"
		cQryRec += + CRLF + " WHERE "
		cQryRec += + CRLF + "  TSA1.A1_FILIAL='"+xFilial("SA1")+"'"
		cQryRec += + CRLF + " 	AND TSA1.A1_COD='"+SUBS(_cCodRecebedor,1,6)+"'"
		cQryRec += + CRLF + "  AND TSA1.A1_LOJA='"+SUBS(_cCodRecebedor,7,2)+"'"
		cQryRec += + CRLF + "  AND TSA1.D_E_L_E_T_ = ' ' "
	ELSE
	cQryRec := + CRLF + "SELECT"
		cQryRec += + CRLF + " A2_COD COD,      A2_LOJA LOJA,   A2_NOME NOME,     A2_NREDUZ NREDUZ,  A2_INSCR INSCR,   A2_BAIRRO BAIRRO,  A2_CEP CEP,"
		cQryRec += + CRLF + " A2_COMPLEM COMPLEM,  A2_END END,   A2_DDD DDD,      A2_TEL TEL,     A2_COD_MUN CODMUN, A2_PAIS PAIS,    A2_EST EST, A2_CGC CGC"
		cQryRec += + CRLF + " FROM "	+ RetSQLName("SA2") + " TSA2"
		cQryRec += + CRLF + " WHERE "
		cQryRec += + CRLF + "  TSA2.A2_FILIAL='"+xFilial("SA2")+"'"
		cQryRec += + CRLF + " 	AND TSA2.A2_COD='"+SUBS(_cCodRecebedor,1,6)+"'"
		cQryRec += + CRLF + "  AND TSA2.A2_LOJA='"+SUBS(_cCodRecebedor,7,2)+"'"
		cQryRec += + CRLF + "  AND TSA2.D_E_L_E_T_ = ' ' "
	ENDIF
	tcQuery cQryRec New Alias "QRYREC"
Return

//--------------------------------------------------------------------
Static Function fIbge(xCampo)
	Public fcodIbge := " "
	QRYIBGE := GetNextAlias()
	If Select(QRYIBGE) > 0
		(QRYIBGE)->(DbClosearea())
	Endif
	BeginSql Alias QRYIBGE
		SELECT 
			DISTINCT Substr(GU7_NRCID,1,2) NRCID,GU7_CDUF
		FROM 
			%Table:GU7% TGU7
		WHERE 
			TGU7.GU7_CDUF = %EXP:xCampo% 
			AND TGU7.%notdel% 	
	ENDSQL
	(QRYIBGE)->(DbGoTop())
	fCodIbge := (QRYIBGE)->NRCID	
	(QRYIBGE)->(DbCloseArea())
return fCodIbge