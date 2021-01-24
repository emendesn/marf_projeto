#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "apwebsrv.ch"
#include "apwebex.ch"

#define CRLF chr(13) + chr(10)

//Static _aErr // RETORNAR PARA CONTROLE DE ERROS

Static aCamposPed := {;
{"C6_QTDVEN",0,0,"DIVIDE"},;
{"C6_VALOR",0,0,"DIVIDE"},;
{"C6_UNSVEN",0,0,"DIVIDE"},;
{"C6_VALDESC",0,0,"DIVIDE"},;
{"C6_ZQTDPEC",0,0,"ZERA"},;
{"C6_ZVOLUME",0,0,"ZERA"},;
{"C6_QTDLIB",0,0,"ZERA"},;
{"C6_QTDLIB2",0,0,"ZERA"},;
{"C6_QTDENT",0,0,"ZERA"},;
{"C6_QTDENT2",0,0,"ZERA"},;
{"C6_COMIS1",0,0,"ZERA"},;
{"C6_COMIS2",0,0,"ZERA"},;
{"C6_COMIS3",0,0,"ZERA"},;
{"C6_COMIS4",0,0,"ZERA"},;
{"C6_COMIS5",0,0,"ZERA"},;
{"C6_QTDRESE",0,0,"ZERA"},;
{"C6_QTDEMP",0,0,"ZERA"},;																																																		
{"C6_QTDEMP2",0,0,"ZERA"},;
{"C6_SLDALIB",0,0,"ZERA"};
} // criar como static, pois eh usado em ponto de entrada

/*
=====================================================================================
Programa............: MGFTAS02
Autor...............: Mauricio Gresele
Data................: 25/10/2016 
Descricao / Objetivo: Integração Protheus-Taura, para recebimento da carga - OMS
Doc. Origem.........: Protheus-Taura Saida
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/
WSSTRUCT CABECALHOCARGA
	WSDATA Acao				as String
	WSDATA Filial			as String
	WSDATA Ordem_Embarque	as String
	WSDATA Caminhao			as String
	WSDATA Cavalo			as String Optional
	WSDATA Caminhao2		as String Optional
	WSDATA Caminhao3		as String Optional
	WSDATA Motorista		as String
	WSDATA Transportadora 	as String
	WSDATA NumeroExportacao as String	
	WSDATA Distancia		as Float  Optional
	WSDATA Data_Estufagem	as String Optional
	WSDATA Lacre_Sif		as String Optional
	WSDATA Obs_EEC			as String Optional
	WSDATA Num_Container 	as String Optional 
	WSDATA Tipo_Container	as String Optional
	WSDATA CodIntPortodeColeta	as String Optional
	WSDATA CodIntOrigemTN	as String Optional
	WSDATA CodIntRecebedor	as String Optional
	WSDATA CodIntExpedidor	as String Optional
	WSDATA CodIntCrossDocking	as String Optional
	WSDATA OEReferencia		as String Optional
ENDWSSTRUCT

WSSTRUCT ITEMCARGA
	WSDATA Filial			as String
	WSDATA Ordem_Embarque	as String
	WSDATA Pedido			as String
	WSDATA Item_Ped			as String
	WSDATA Qtd_Lib			as Float
	WSDATA Peso				as Float 
	WSDATA CapVol			as Float Optional
	WSDATA Lote				as String Optional	
	WSDATA Lote_Valid		as String Optional	
	WSDATA Sif_Pedido		as String Optional
	WSDATA Sif				as String Optional
	WSDATA Sif_Produto		as String Optional
	WSDATA Local_Matadouro	as String Optional
	WSDATA Local_Producao	as String Optional	
	WSDATA Total_Caixas		as Integer Optional	
	WSDATA Producao_de		as String Optional	
	WSDATA Producao_ate		as String Optional	
	WSDATA Num_DI			as String Optional
	WSDATA Peso_Bruto		as Float 
ENDWSSTRUCT

WSSTRUCT VOLUMECARGA
	WSDATA Filial			as String
	WSDATA Ordem_Embarque	as String
	WSDATA Pedido			as String
	WSDATA Quantidade       as Float
ENDWSSTRUCT

WSSTRUCT CARGA
	WSDATA Cabecalho		as CABECALHOCARGA
	WSDATA Itens			as Array of ITEMCARGA 
	WSDATA Volumes	        as Array of VOLUMECARGA	
ENDWSSTRUCT

WSSTRUCT WSTAS02RETORNO
	WSDATA Status			as String
	WSDATA Msg				as String
ENDWSSTRUCT

WSSERVICE MGFTAS02 DESCRIPTION "Importação de Ordem de Embarque - Carga" NameSpace "http://www.totvs.com.br/MGFTAS02"
	WSDATA Carga	as CARGA
	WSDATA Retorno	as WSTAS02RETORNO

	WSMETHOD GravarCarga DESCRIPTION "Importa Ordem de Embarque-Carga para o Protheus"	
ENDWSSERVICE


WSMETHOD GravarCarga WSRECEIVE Carga WSSEND Retorno WSSERVICE MGFTAS02

	Local aRet := {}
	Local cMens := ""
	Local cEmpSav := ""
	Local cFilSav := ""
	Local cCarga := ""
	//Local lRet := .T.

	ConOut("-------------------------------------------------------------------------------")
	ConOut("Iniciando importação da Integração de Ordem de Embarque - "+dToc(dDataBase)+" - "+Time())
	ConOut("-------------------------------------------------------------------------------")

	::Retorno := WSClassNew("WSTAS02RETORNO")

	// apenas transforma o objeto em um txt, para poder enviar para a funcao startjob e funcao especifica do monitor de integracoes
	cCarga := fwJsonSerialize(Carga, .F., .T.)

	If !Empty(cCarga)
		//aRet := StartJob("U_GravarCarga",GetEnvServer(),.T.,cCarga)
		aRet := U_GravarCarga(cCarga,Carga)	
	Endif	

	If ValType(aRet) == "A" .and. Len(aRet) > 0
		::Retorno:Status := IIf(aRet[1],"1","2")
		::Retorno:Msg := aRet[2]
	Else
		::Retorno:Status := "2"
		::Retorno:Msg := "Erro Indefinido"
	Endif	

	//lRet := ::Retorno:Status == "1"

	::Carga := Nil
	DelClassINTF()

	ConOut("-------------------------------------------------------------------------------")
	ConOut("Finalizando importação da Integração de Ordem de Embarque - "+dToc(dDataBase)+" - "+Time())
	ConOut("-------------------------------------------------------------------------------")

Return(.T.)


User Function GravarCarga(cCarga,Carga)

	Local aRet := {}
	Local cMens := ""
	Local cEmpSav := ""
	Local cFilSav := ""
	Local cTimeIni := ""
	Local cTimeFim := ""
	Local cTimeProc := ""
	Local cTime1 := ""
	Local cTime2 := ""

	Private cSemaf := GetSrvProfString("Startpath","")+"MGFTAS02_" // private pois eh usada na funcao MyError
	Private nHdl := 0  // private pois eh usada na funcao MyError
	Private lSemaf := GetMv("MGF_OESEMA",,.T.)  // private pois eh usada na funcao MyError

	Private cMensTime := ""
	Private cLogTime := ""

	Private lErro := .F.

	Private aRegSC5 := {}
	Private aRegSA1 := {}
	Private aRegSA2 := {}
	Private aRegSB2 := {}
	Private aRegEE7 := {}

	cTimeIni := Time()

	cEmpSav := cEmpAnt
	cFilSav := cFilAnt

	// valida todos os campos obrigatorios
	aRet := VldObrCampos(Carga)
	If Len(aRet) > 0
		If !aRet[1]
			Return(aRet)
		Endif	
	Endif	

	//--------------| Verifica existência de parâmetros e caso não exista, cria. |-----
	If !ExisteSx6("MGF_TAS02A")
		CriarSX6("MGF_TAS02A", "L", "Exclui Romaneios Filhos?",".T." )	
	EndIf

	ConOut("Ordem de Embarque N.: "+Carga:Cabecalho:Ordem_Embarque)
	//ConOut("Operação: "+IIf(Carga:Cabecalho:Acao=="1","Inclusão",IIf(Carga:Cabecalho:Acao=="3","Exclusão",IIf(Carga:Cabecalho:Acao=="4","Alteração-Inclusão",IIf(Carga:Cabecalho:Acao=="5","Alteração-Exclusão","Indefinido")))))
	ConOut("Operação: "+IIf(Carga:Cabecalho:Acao=="1","Inclusão",IIf(Carga:Cabecalho:Acao=="3","Exclusão",IIf(Carga:Cabecalho:Acao=="4","Alteração-Inclusão","Indefinido"))))

	cEmpAnt := '01'//Subs(Carga:Cabecalho:Filial,1,2)
	cFilAnt := Subs(Carga:Cabecalho:Filial,1,6)

	// valida empresa e filial
	SM0->(dbSetOrder(1))
	If SM0->(!dbSeek(cEmpAnt+cFilAnt))
		cMens := "Empresa/Filial não encontrada, Filial: "+cEmpAnt+"-"+cFilAnt+", Carga: "+Carga:Cabecalho:Ordem_Embarque	
		Conout(cMens)
		aRet := {}
		aAdd(aRet,.F.)
		aAdd(aRet,cMens)

		Return(aRet)
	Endif	

	// validacao do conteudo do campo Acao
	If !Carga:Cabecalho:Acao $ "134"
		cMens := "Conteúdo do Campo Acao inválido."+" Filial: "+Carga:Cabecalho:Filial+", Carga: "+Carga:Cabecalho:Ordem_Embarque
		Conout(cMens)
		aRet := {}
		aAdd(aRet,.F.)
		aAdd(aRet,cMens)

		Return(aRet)
	Endif		

	If lSemaf
		cSemaf += Carga:Cabecalho:Filial+"_"+Carga:Cabecalho:Ordem_Embarque+".TXT"
		// tenta deletar o arquivo de semaforo, pois pode ter ficado gravado de execucoes anteriores, se conseguir excluir eh porque o semaforo nao conseguiu ser deletado por algum problema
		// ainda nao identificado ( por exemplo queda do link, erro de stack over, ou algum erro que a rotina nao consiga chegar ateh o fim e nem passar pelo tratamento de erro do ErrorBlock ),
		// se nao conseguir excluir eh porque o semaforo estah criado devido a ter outra thread ainda processando esta carga, neste caso, o arquivo realmente nao pode ser deletado
		If File(cSemaf)
			fErase(cSemaf)
		Endif

		nHdl := fCreate(cSemaf)
	Endif

	If lSemaf .and. nHdl == -1
		cMens := "JOB já em Execução: MGFTAS02 - Arquivo: "+cSemaf+" já criado e bloqueado na pasta: "+GetSrvProfString("Startpath","")+" - "+DTOC(dDATABASE)+" - "+TIME()
		Conout(cMens)
		aRet := {}
		aAdd(aRet,.F.)
		aAdd(aRet,cMens)
	Else	
		aRet := WSTAS02Mnt(Carga,Carga:Cabecalho:Acao)
		cTime1 := Time()
		DesblqReg("SC5",aRegSC5)
		DesblqReg("SA1",aRegSA1)
		DesblqReg("SA2",aRegSA2)
		DesblqReg("SB2",aRegSB2)
		DesblqReg("EE7",aRegEE7)
		cTime2 := Time()
		cMensTime := "ORDEM EMBARQUE: "+Carga:Cabecalho:Ordem_Embarque+" - FIM DESBLOQUEIO TABELAS: "+ElapTime(cTime1,cTime2)+" - Time: "+Time()+CRLF
		ConOut(cMensTime)
		cLogTime += cMensTime
	Endif	

	If ValType(aRet) != "A" .or. (ValType(aRet) == "A" .and. Len(aRet) == 0)
		//::Retorno:Status := "2"
		//::Retorno:Msg := "Erro indefinido na rotina de importação da Ordem de Embarque - 'MGFTAS02'. "+" Filial: "+Carga:Cabecalho:Filial+", Carga: "+Carga:Cabecalho:Ordem_Embarque
		aRet := {}
		aAdd(aRet,.F.)
		aAdd(aRet,"Erro indefinido na rotina de importação da Ordem de Embarque - 'MGFTAS02'. "+" Filial: "+Carga:Cabecalho:Filial+", Carga: "+Carga:Cabecalho:Ordem_Embarque)
	Endif	

	cTimeFim := Time()
	cTimeProc := ElapTime(cTimeIni,cTimeFim)

	cMensTime := "ORDEM EMBARQUE: "+Carga:Cabecalho:Ordem_Embarque+" - TEMPO TOTAL: "+cTimeProc+" - Time: "+Time()+CRLF
	ConOut(cMensTime)
	cLogTime += cMensTime

	cCarga += CRLF
	cCarga += CRLF
	cCarga += CRLF
	cCarga += cLogTime

	// grava na tabela do monitor
	If !lErro
		U_MGFMONITOR(Carga:Cabecalho:Filial,IIf(aRet[1],"1","2"),AllTrim(GetMv("MGF_MONI01")),AllTrim(GetMv("MGF_MONT13",.F.,"013")),StrTran(aRet[2],Chr(13)+Chr(10)," "),Carga:Cabecalho:Filial+Carga:Cabecalho:Ordem_Embarque,cTimeProc,cCarga)
	Else
		StartJob("U_MGFMONITOR",GetEnvServer(),.T.,Carga:Cabecalho:Filial,IIf(aRet[1],"1","2"),AllTrim(GetMv("MGF_MONI01")),AllTrim(GetMv("MGF_MONT13",.F.,"013")),StrTran(aRet[2],Chr(13)+Chr(10)," "),Carga:Cabecalho:Filial+Carga:Cabecalho:Ordem_Embarque,cTimeProc,cCarga,,,.T.,{cEmpAnt,cFilAnt})
	Endif	

	MsUnLockAll()

	If lSemaf
		If !nHdl == -1 .and. File(cSemaf)
			fClose(nHdl)
			fErase(cSemaf)
		Endif	
	Endif	

	cEmpAnt := cEmpSav
	cFilAnt := cFilSav

	//RESET ENVIRONMENT	

Return(aRet)


// rotina de execucao dos eventos de manutencao da carga
Static Function WSTAS02Mnt(Carga,cAcao)

	Local aRet := {}

	If cAcao == "1" // inclusao da carga
		aRet := WSTAS02Inc(Carga,cAcao)
	Elseif cAcao == "4" .or. cAcao == "5" //"2" // alteracao da carga
		aRet := WSTAS02Alt(Carga,cAcao)
	Elseif cAcao == "3" // exclusao da carga
		aRet := WSTAS02Exc(Carga,cAcao)
	Endif	

Return(aRet)


// rotina de inclusao da carga
Static Function WSTAS02Inc(Carga,cAcao) 

	Local aQtdLib := {}
	Local lContinua := .T.
	Local aPV := {}
	Local aRet := {}
	Local aCabCargaERP := {}
	Local aSif := {}
	Local cSifFil := ""
	Local cTime1 := ""
	Local cTime2 := ""

	// verifica se a carga jah existe
	aRet := ExisteCarga(Carga)
	lContinua := aRet[1]

	If lContinua
		// valida campos do cabecalho da carga
		cTime1 := Time()
		aRet := VldCabCampos(Carga,@aCabCargaERP)
		cTime2 := Time()
		cMensTime := "ORDEM EMBARQUE: "+Carga:Cabecalho:Ordem_Embarque+" - FIM VALIDAÇÃO XML: "+ElapTime(cTime1,cTime2)+" - Time: "+Time()+CRLF
		ConOut(cMensTime)
		cLogTime += cMensTime
		lContinua := aRet[1]

		If lContinua
			cTime1 := Time()
			aRet := AvalSaldo(Carga,@aQtdLib,.F.,.F.,@aSif)
			cTime2 := Time()
			cMensTime := "ORDEM EMBARQUE: "+Carga:Cabecalho:Ordem_Embarque+" - FIM AVALIAÇÃO SALDOS: "+ElapTime(cTime1,cTime2)+" - Time: "+Time()+CRLF
			ConOut(cMensTime)
			cLogTime += cMensTime

			lContinua := aRet[1]

			If lContinua

				Begin Transaction 

					If lContinua	
						If GetMv("MGF_OEGRTE",,.T.) 
							cTime1 := Time()
							aRet := GrvTabTemp(Carga)
							cTime2 := Time()
							cMensTime := "ORDEM EMBARQUE: "+Carga:Cabecalho:Ordem_Embarque+" - GRAVAÇÃO TABELA TEMPORÁRIA: "+ElapTime(cTime1,cTime2)+" - Time: "+Time()+CRLF
							ConOut(cMensTime)
							cLogTime += cMensTime

							lContinua := aRet[1]
						Endif	
					Endif	

					If lContinua	
						// verifica necessidade de alterar o pedido em funcao do sif
						//aSifSav := aClone(aSif)
						//aQtdLibSav := aClone(aQtdLib)
						cTime1 := Time()
						// processa pedidos de exportacao
						//aRet := AltPVISif(@aSif,Carga,@aQtdLib,,.T.,.F.,@lProcOff,@cSifFil)
						aRet := AltPVISif(@aSif,Carga,@aQtdLib)//,,.T.,.F.,@lProcOff,@cSifFil)
						lContinua := aRet[1]
					
						cTime2 := Time()
						cMensTime := "ORDEM EMBARQUE: "+Carga:Cabecalho:Ordem_Embarque+" - FIM FIS45 - SIF: "+ElapTime(cTime1,cTime2)+" - Time: "+Time()+CRLF
						ConOut(cMensTime)
						cLogTime += cMensTime

						// valida se as alteracoes em quantidades foram feitas corretamente no pedido de exportacao
						If lContinua
							If GetMv("MGF_OEVQEX",,.F.) 
								cTime1 := Time()
								aRet := VldQtdExp(aSif,Carga,aQtdLib)
								cTime2 := Time()
								cMensTime := "ORDEM EMBARQUE: "+Carga:Cabecalho:Ordem_Embarque+" - FIM VLD. QTD. PED. EXP.: "+ElapTime(cTime1,cTime2)+" - Time: "+Time()+CRLF
								ConOut(cMensTime)
								cLogTime += cMensTime

								lContinua := aRet[1]
								If !lContinua
									cMens := aRet[2]
								Endif	
							Endif	
						Endif	

						If lContinua
							// verifica necessidade de alterar as quantidades dos pedidos
							//aRet := AltPVQtd(Carga,aQtdLib,aSif)
							//lContinua := aRet[1]

							If lContinua
								// faz as liberacoes no pedido de acordo com as quantidades enviadas pelo Taura
								cTime1 := Time()
								aRet := LibPV(aQtdLib,@aPV,Carga,aCabCargaERP)
								cTime2 := Time()
								cMensTime := "ORDEM EMBARQUE: "+Carga:Cabecalho:Ordem_Embarque+" - FIM LIBPV: "+ElapTime(cTime1,cTime2)+" - Time: "+Time()+CRLF
								ConOut(cMensTime)
								cLogTime += cMensTime

								lContinua := aRet[1]

								// valida se SC9 ficou liberado para todos os itens do pv
								If lContinua
									If GetMv("MGF_OEVLPV",,.F.) 
										cTime1 := Time()
										aRet := VldLib(aSif,Carga,aQtdLib,.T.)
										cTime2 := Time()
										cMensTime := "ORDEM EMBARQUE: "+Carga:Cabecalho:Ordem_Embarque+" - FIM VLD. LIBPV SEM CARGA: "+ElapTime(cTime1,cTime2)+" - Time: "+Time()+CRLF
										ConOut(cMensTime)
										cLogTime += cMensTime

										lContinua := aRet[1]
										If !lContinua
											cMens := aRet[2]
										Endif	
									Endif	
								Endif	

								If lContinua
									// inicia geracao da carga
									aRet := IncCarga(Carga,aPV,aQtdLib,aCabCargaERP,aSif)
									lContinua := aRet[1]

									If lContinua
										cTime1 := Time()
										Cad_Volume(Carga)						
										cTime2 := Time()
										cMensTime := "ORDEM EMBARQUE: "+Carga:Cabecalho:Ordem_Embarque+" - FIM CAD. VOLUME: "+ElapTime(cTime1,cTime2)+" - Time: "+Time()+CRLF
										ConOut(cMensTime)
										cLogTime += cMensTime
									Endif			
								Endif
							Endif	
						Endif	
					Endif	

					MsUnLockAll()				

					If !lContinua
						//If InTransact()	
						DisarmTransaction()
						//Endif	
					Endif	

				End Transaction

				//MsUnLockAll()

			Endif
		Endif
	Endif

	If Len(aRet) == 0
		aAdd(aRet,lContinua)
		aAdd(aRet,cMens)
		If !Empty(cMens)
			Conout(cMens)
		Endif	
	Endif	

Return(aRet)


// rotina de exclusao da carga
Static Function WSTAS02Exc(Carga,cAcao)

	Local lContinua := .T.
	Local aRet := {}
	Local cMens := ""
	Local aRecnoSC9 := {}
	Local aPV := {}
	Local lSifExc := .F.
	//Local lProcOff := .F.
	//Local cFilAntSav := cFilAnt
	Local cTime1 := ""
	Local cTime2 := ""
	//Local aPVQtd := {}

	aRet := ExisteCarga(Carga)
	lContinua := !aRet[1]
	// atualiza o valor do array aRet
	aRet[1] := !aRet[1]

	If !lContinua
		cMens := "Carga não excluída."+CRLF+"Motivo: "+"Carga não localizada."+CRLF+"Filial: "+Carga:Cabecalho:Filial+", Carga: "+Carga:Cabecalho:Ordem_Embarque
		Conout(cMens)
		aRet[2] := cMens
		aRet[1] := .T. // inserido em 04/04/18, para forcar o envio do status 1 para o Taura, somente neste cenario
		Return(aRet) // inserido em 04/04/18, para forcar o envio do status 1 para o Taura, somente neste cenario	
	Endif

	If lContinua 
		// carrega recnos do SC9 referentes a carga, antes de deletar a carga, depois de deletar a carga, o numero da carga eh apagado do SC9
		aRecnoSC9 := RecnoSC9(DAK->DAK_COD,.F.)[1]

		// verifica se houve inclusao de itens no pedido, devido ao sif diferente para o mesmo item do pedido
		// carrega todos os pedidos da carga
		// obs: chamar esta funcao antes da excreserva, para que o sc9 ainda exista na base
		//aPV := RecnoSC9(DAK->DAK_COD,.F.,.T.)[4] // 30/01/18, substituido pela chamada da funcao para carregar o array apv, com o sexto parametro como .t.

		// verifica se houve alteracao da quantidades dos itens
		//aPVQtd := RecnoSC9(DAK->DAK_COD,.F.,.F.,,,.T.)[4] // 30/01/18, substituido pela chamada da funcao para carregar o array apv, com o sexto parametro como .t.
		aPV := RecnoSC9(DAK->DAK_COD,.F.,.T.,,,.T.)[4]

		Begin Transaction 

			If lContinua	
				If GetMv("MGF_OEGRTE",,.T.) 
					cTime1 := Time()
					aRet := GrvTabTemp(Carga)
					cTime2 := Time()
					cMensTime := "ORDEM EMBARQUE: "+Carga:Cabecalho:Ordem_Embarque+" - GRAVAÇÃO TABELA TEMPORÁRIA: "+ElapTime(cTime1,cTime2)+" - Time: "+Time()+CRLF
					ConOut(cMensTime)
					cLogTime += cMensTime

					lContinua := aRet[1]
				Endif	
			Endif	

			If lContinua	
				cTime1 := Time()
				aRet := MyOs200Estor()
				cTime2 := Time()
				cMensTime := "ORDEM EMBARQUE: "+Carga:Cabecalho:Ordem_Embarque+" - FIM EXCLUSÃO CARGA: "+ElapTime(cTime1,cTime2)+" - Time: "+Time()+CRLF
				ConOut(cMensTime)
				cLogTime += cMensTime

				lContinua := aRet[1]

				If lContinua
					// exclui as reservas feitas durante a inclusao
					cTime1 := Time()
					aRet := ExcReserva(Carga,aRecnoSC9)
					cTime2 := Time()
					cMensTime := "ORDEM EMBARQUE: "+Carga:Cabecalho:Ordem_Embarque+" - FIM EXCLUSÃO RESERVA: "+ElapTime(cTime1,cTime2)+" - Time: "+Time()+CRLF
					ConOut(cMensTime)
					cLogTime += cMensTime

					lContinua := aRet[1]

					If lContinua
						aEval(aPV,{|x| IIf(x[3],lSifExc:=.T.,Nil)})
						If lSifExc
							cTime1 := Time()
							// processa pedidos de exportacao
							aRet := AltPVESif(aPV,Carga,)//,.T.,.F.,@lProcOff,cFilAnt)
							lContinua := aRet[1]
							/*
							If lContinua
							// se algum pedido for off-shore, processa pedido na filial off-shore
							If lProcOff
							cFilAntSav := cFilAnt 
							cFilAnt := Alltrim(GetMv("MV_AVG0024"))
							aRet := AltPVESif(aPV,Carga,,.T.,.T.,lProcOff,cFilAntSav)
							lContinua := aRet[1]
							cFilAnt := cFilAntSav
							Endif
							If lContinua
							// processa pedidos de venda
							aRet := AltPVESif(aPV,Carga,,.F.,.F.,lProcOff,cFilAnt)
							lContinua := aRet[1]
							Endif	
							Endif	
							*/
							cTime2 := Time()
							cMensTime := "ORDEM EMBARQUE: "+Carga:Cabecalho:Ordem_Embarque+" - FIM FIS45: "+ElapTime(cTime1,cTime2)+" - Time: "+Time()+CRLF
							ConOut(cMensTime)
							cLogTime += cMensTime
						Endif
					Endif			
					
					If lContinua	
						// exclusao da gravacao de tabela especifica para customizacao do SIGAEEC, GAP EEC09
						cTime1 := Time()
						GrvTabEEC09(Carga,"2") // exclui
						cTime2 := Time()
						cMensTime := "ORDEM EMBARQUE: "+Carga:Cabecalho:Ordem_Embarque+" - FIM GRAVAÇÃO CAMPOS EEC: "+ElapTime(cTime1,cTime2)+" - Time: "+Time()+CRLF
						ConOut(cMensTime)
						cLogTime += cMensTime

						cMens := "Exclusão da Carga com sucesso, Filial: "+Carga:Cabecalho:Filial+", Carga: "+Carga:Cabecalho:Ordem_Embarque
						aRet[2] := cMens
					Endif
				Else	
					cMens := aRet[2]
				Endif			
			Endif	

			MsUnLockAll()		

			If !lContinua
				ConOut(cMens)
				//If InTransact()	
				DisarmTransaction()
				//Endif	
			Endif	

		End Transaction

		//MsUnLockAll()

	Endif

	If Len(aRet) == 0
		aAdd(aRet,lContinua)
		aAdd(aRet,cMens)
		If !Empty(cMens)
			Conout(cMens)
		Endif	
	Endif	

Return(aRet)


// rotina de extracao de dados do SC6
Static Function DadosSC6(cPedido,cItemPed,lInclusao,cProd,cTes,lWhile)

	Local aArea := {GetArea()}
	Local cQ := ""
	Local aRet := {}
	Local cAliasTrb := GetNextAlias()

	Default cProd := ""
	Default cItemPed := ""
	Default lInclusao := .F.
	Default cTes := ""
	Default lWhile := .F.

	cQ := "SELECT C6_PRODUTO,SC6.R_E_C_N_O_ SC6_RECNO,C6_TES,C6_ITEM,C6_ZTESSIF,C6_ZGERSIF,C5_PEDEXP,C6_LOCAL "
	cQ += "FROM "+RetSqlName("SC6")+" SC6 "
	cQ += "JOIN "+RetSqlName("SC5")+" SC5 "
	cQ += "ON SC5.D_E_L_E_T_ <> '*' "
	cQ += "AND C5_FILIAL = C6_FILIAL "
	cQ += "AND C5_NUM = C6_NUM "
	cQ += "AND C5_TPCARGA = '1' " // pedidos de carga
	cQ += "WHERE "
	cQ += "C6_FILIAL = '"+xFilial("SC6")+"' "
	cQ += "AND C6_NUM = '"+cPedido+"' "
	If !Empty(cItemPed)
		cQ += "AND C6_ITEM = '"+cItemPed+"' "
	Endif
	If !Empty(cProd)
		cQ += "AND C6_PRODUTO = '"+cProd+"' "
	Endif	
	If lInclusao
		//cQ += "AND C6_QTDVEN >= (C6_QTDEMP+C6_QTDENT) "
		cQ += "AND C6_QTDVEN >= C6_QTDENT "
		cQ += "AND (C6_BLQ <> 'R ' OR C6_BLQ <> 'S ') "
	Endif
	If !Empty(cTes)
		cQ += "AND C6_TES = '"+cTes+"' "
	Endif	
	cQ += "AND SC6.D_E_L_E_T_ <> '*' "

	cQ := ChangeQuery(cQ)
	//MemoWrite("mgftas02_1.sql",cQ)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),cAliasTrb,.T.,.T.)

	If (cAliasTrb)->(!Eof())
		If !lWhile
			aAdd(aRet,(cAliasTrb)->C6_PRODUTO)
			aAdd(aRet,(cAliasTrb)->SC6_RECNO)
			aAdd(aRet,(cAliasTrb)->C6_TES)
			aAdd(aRet,(cAliasTrb)->C6_ITEM)
			aAdd(aRet,(cAliasTrb)->C6_ZTESSIF)
			aAdd(aRet,(cAliasTrb)->C6_ZGERSIF)
			aAdd(aRet,IIf(Empty((cAliasTrb)->C5_PEDEXP),.F.,.T.))
			aAdd(aRet,(cAliasTrb)->C6_LOCAL)
		Else
			While (cAliasTrb)->(!Eof())
				aAdd(aRet,{Alltrim((cAliasTrb)->C6_PRODUTO),(cAliasTrb)->SC6_RECNO,(cAliasTrb)->C6_TES,(cAliasTrb)->C6_ITEM,(cAliasTrb)->C6_ZTESSIF,(cAliasTrb)->C6_ZGERSIF,IIf(Empty((cAliasTrb)->C5_PEDEXP),.F.,.T.),(cAliasTrb)->C6_LOCAL})
				(cAliasTrb)->(dbSkip())
			Enddo
		Endif		
	Endif

	(cAliasTrb)->(dbCloseArea()) 

	aEval(aArea,{|x| RestArea(x)})	

Return(aRet)


// rotina que avalia os saldos em estoque
Static Function AvalSaldo(Carga,aQtdLib,lNaoAgrupaLote,lNaoAvalSaldo,aSif)

	Local aRet := {}
	Local aSaldo := {}
	Local cLocal := ""
	Local cMens := ""
	Local nPos := 0
	Local nCnt := 0
	Local lContinua := .T.
	Local aDados := {}
	Local nSaldoSB2 := 0
	Local lLote := .F.
	Local nPosSif := 0
	Local cChave := ""
	Local nCount := 0
	Local nQtdProdLoc := 0
	Local nCnt1 := 0
	Local nTamPed := TamSX3("C6_NUM")[1]
	Local nTamProd := TamSX3("B1_COD")[1]
	Local nTamLocal := TamSX3("B8_LOCAL")[1]
	Local nTamLote := TamSX3("B8_LOTECTL")[1]

	Default aSif := {}

	SB1->(dbSetOrder(1))
	SB2->(dbSetOrder(1))
	SC5->(dbSetOrder(1))
	SA1->(dbSetOrder(1))
	SA2->(dbSetOrder(1))

	If !lNaoAgrupaLote
		// avalia os saldos por lote
		For nCnt:=1 To Len(Carga:Itens)
			//aSaldo := {}
			aDados := DadosSC6(Carga:Itens[nCnt]:Pedido,,IIf(lNaoAvalSaldo,.F.,.T.),Carga:Itens[nCnt]:Item_Ped)
			If Len(aDados) == 0
				cMens := "Pedido/Item não encontrado ou totalmente entregue/reservado, Filial: "+Carga:Itens[nCnt]:Filial+", Carga: "+Carga:Itens[nCnt]:Ordem_Embarque+", Pedido: "+Carga:Itens[nCnt]:Pedido+", Item: "+Carga:Itens[nCnt]:Item_Ped
				Conout(cMens)
				lContinua := .F.
				Exit
			Endif
			// verifica se cliente do pedido estah cadastrado
			// obs: esta situacao nunca deveria ocorrer, mas ocorre de as vezes o cliente estar deletado...
			If SC5->(dbSeek(xFilial("SC5")+Carga:Itens[nCnt]:Pedido))
				aRet := LockEEC("SC5",1,Carga:Cabecalho:Filial,Carga:Cabecalho:Ordem_Embarque,Carga:Itens[nCnt]:Pedido,"",Carga:Itens[nCnt]:Pedido)
				lContinua := aRet[1]
				cMens := aRet[2] 
				If !lContinua
					Conout(cMens)			
					Exit
				Endif	

				If aScan(aRegSC5,SC5->(Recno())) == 0
					aAdd(aRegSC5,SC5->(Recno()))
				Endif	
				If SC5->C5_TIPO $ "B/D"
					If SA2->(!dbSeek(xFilial("SA2")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
						cMens := "Fornecedor do pedido não cadastrado, Filial: "+Carga:Itens[nCnt]:Filial+", Carga: "+Carga:Itens[nCnt]:Ordem_Embarque+", Pedido: "+Carga:Itens[nCnt]:Pedido+", Fornecedor: "+SC5->C5_CLIENTE+"/"+SC5->C5_LOJACLI
						Conout(cMens)
						lContinua := .F.
						Exit
					Else
						aRet := LockEEC("SA2",1,Carga:Cabecalho:Filial,Carga:Cabecalho:Ordem_Embarque,Carga:Itens[nCnt]:Pedido,"",SC5->C5_CLIENTE+SC5->C5_LOJACLI)
						lContinua := aRet[1]
						cMens := aRet[2] 
						If !lContinua
							Conout(cMens)
							Exit
						Endif	

						If aScan(aRegSA2,SA2->(Recno())) == 0
							aAdd(aRegSA2,SA2->(Recno()))
						Endif	
					Endif
				Else	
					If SA1->(!dbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
						cMens := "Cliente do pedido não cadastrado, Filial: "+Carga:Itens[nCnt]:Filial+", Carga: "+Carga:Itens[nCnt]:Ordem_Embarque+", Pedido: "+Carga:Itens[nCnt]:Pedido+", Cliente: "+SC5->C5_CLIENTE+"/"+SC5->C5_LOJACLI
						Conout(cMens)
						lContinua := .F.
						Exit
					Else
						aRet := LockEEC("SA1",1,Carga:Cabecalho:Filial,Carga:Cabecalho:Ordem_Embarque,Carga:Itens[nCnt]:Pedido,"",SC5->C5_CLIENTE+SC5->C5_LOJACLI)
						lContinua := aRet[1]
						cMens := aRet[2] 
						If !lContinua
							Conout(cMens)
							Exit
						Endif	

						If aScan(aRegSA1,SA1->(Recno())) == 0
							aAdd(aRegSA1,SA1->(Recno()))
						Endif	
					Endif
				Endif	
			Endif	
			If SB1->(dbSeek(xFilial("SB1")+aDados[1]))
				//If RetFldProd(SB1->B1_COD,"B1_RASTRO") == "L" // nao usar esta funcao para o campo de lote, pois o campo de lote nao tem tratamento nesta funcao padrao
				If SB1->B1_LOCALIZ == "S"
					cMens := "Produto parametrizado para 'Controle de Endereçamento = Sim', esta parametrização não é permitida nesta integração. Filial: "+Carga:Itens[nCnt]:Filial+", Carga: "+Carga:Itens[nCnt]:Ordem_Embarque+", Pedido: "+Carga:Itens[nCnt]:Pedido+", Item: "+Carga:Itens[nCnt]:Item_Ped+", Produto: "+Alltrim(SB1->B1_COD)
					Conout(cMens)
					lContinua := .F.
					Exit
				Endif	
				If SB1->B1_RASTRO == "L"
					lLote := .T.
				Else	
					lLote := .F.
				Endif	                                  

				cLocal := aDados[8]
				If Empty(cLocal)
					cLocal := RetFldProd(SB1->B1_COD,"B1_LOCPAD")
					If Empty(cLocal)
						cLocal := "01"
					Endif	
				Endif	
			Else
				cMens := "Produto não encontrado, Filial: "+Carga:Itens[nCnt]:Filial+", Carga: "+Carga:Itens[nCnt]:Ordem_Embarque+", Pedido: "+Carga:Itens[nCnt]:Pedido+", Item: "+Carga:Itens[nCnt]:Item_Ped
				Conout(cMens)
				lContinua := .F.
				Exit
			Endif
			If lLote
				// verifica a data de validade enviada
				/*
				If !Empty(Carga:Itens[nCnt]:Lote_Valid) .and. sTod(StrTran(Carga:Itens[nCnt]:Lote_Valid,"-","")) < dDataBase
				cMens := "Data de validade menor que a data atual, Filial: "+Carga:Itens[nCnt]:Filial+", Carga: "+Carga:Itens[nCnt]:Ordem_Embarque+", Pedido: "+Carga:Itens[nCnt]:Pedido+", Item: "+Carga:Itens[nCnt]:Item_Ped+", Lote: "+Carga:Itens[nCnt]:Lote+", Validade: "+dToc(sTod(StrTran(Carga:Itens[nCnt]:Lote_Valid,"-","")))
				Conout(cMens)
				lContinua := .F.
				Exit
				Endif	
				*/
			Endif	 
			
			nPos := aScan(aQtdLib,{|x| Alltrim(x[1])+Alltrim(x[2])+Alltrim(x[6])==Alltrim(Carga:Cabecalho:Filial)+Alltrim(Carga:Itens[nCnt]:Pedido)+Alltrim(Carga:Itens[nCnt]:Item_Ped)})
			// agrupa por filial+pedido+produto+lote
			If Empty(nPos)
				aAdd(aQtdLib,{;
				""/*1-filial*/,;		
				""/*2-pedido*/,;		
				""/*3-item*/,;		
				0/*4-qtd liberada*/,;			
				0/*5-recno sc6*/,;			
				""/*6-produto*/,;		
				{}/*7-aSaldo - se lote*/,;		
				""/*8-lote*/,;		
				cTod("")/*9-validade lote Taura*/,;	
				cTod("")/*10-validade lote ERP*/,;	
				0/*11-recno sb8*/,;			
				""/*12-local*/,;		
				.F./*13-lLote*/,;
				""/*14-carga*/,;	
				0/*15-qtd pedido*/,;
				.F./*16-qtd do pedido diferente da liberada*/,;
				.F./*17-Pedido de exportacao*/; 
				})

				aQtdLib[Len(aQtdLib)][1] := Carga:Itens[nCnt]:Filial
				aQtdLib[Len(aQtdLib)][2] := Padr(Carga:Itens[nCnt]:Pedido,nTamPed)
				aQtdLib[Len(aQtdLib)][3] := aDados[4] //Carga:Itens[nCnt]:Item_Ped
				aQtdLib[Len(aQtdLib)][4] := Carga:Itens[nCnt]:Qtd_Lib
				aQtdLib[Len(aQtdLib)][5] := aDados[2] // recno_sc6
				aQtdLib[Len(aQtdLib)][6] := aDados[1] // produto
				If lLote
					aQtdLib[Len(aQtdLib)][8] := Carga:Itens[nCnt]:Lote
					aQtdLib[Len(aQtdLib)][9] := sTod(StrTran(Carga:Itens[nCnt]:Lote_Valid,"-",""))
				Endif	
				aQtdLib[Len(aQtdLib)][12] := cLocal
				aQtdLib[Len(aQtdLib)][13] := lLote
				aQtdLib[Len(aQtdLib)][14] := Carga:Itens[nCnt]:Ordem_Embarque
				aQtdLib[Len(aQtdLib)][17] := aDados[7] // pedido de exportacao
			Else
				//If lLote
				aQtdLib[nPos][4] := aQtdLib[nPos][4]+Carga:Itens[nCnt]:Qtd_Lib
				//Endif	
			Endif	
			// ficou definido em 01/04/17 que esta rotina nao deveria mais tratar o controle de lote, deste forma, o controle por numero de sif nao trata o lote
			nPosSif := aScan(aSif,{|x| Alltrim(x[1])+Alltrim(x[2])+Alltrim(x[4])+Alltrim(x[10])==Alltrim(Carga:Cabecalho:Filial)+Alltrim(Carga:Itens[nCnt]:Pedido)+Alltrim(Carga:Itens[nCnt]:Sif_Produto)+Alltrim(Carga:Itens[nCnt]:Item_Ped)})
			// agrupa por filial+pedido+produto+sif
			If Empty(nPosSif)
				aAdd(aSif,{;
				""/*1-filial*/,;		
				""/*2-pedido*/,;		
				""/*3-item*/,;
				""/*4-Sif*/,;
				""/*5-qtd liberada*/,;			
				""/*6-tes*/,;
				.F./*7-processa alteracao do PV*/,;
				""/*8-tes revenda*/,;
				.F./*9-jah processado*/,;
				""/*10-produto*/,;
				.F./*11-Sif somente de outras filiais, se sim, somente altera o TES do pedido*/,;
				""/*12-indice, para sempre deixar o item da mesma filial do sif em primeira posicao*/,;
				0/*13-recno sc6*/,;
				0/*14-qtd pedido*/,;
				.F./*15-qtd do pedido diferente da liberada*/,;
				.F./*16-Pedido de exportacao*/,; 
				.F./*17-deletar item, somente se pedido exportacao*/;
				})
				aSif[Len(aSif)][1] := Carga:Itens[nCnt]:Filial
				aSif[Len(aSif)][2] := Carga:Itens[nCnt]:Pedido
				aSif[Len(aSif)][3] := aDados[4] //Carga:Itens[nCnt]:Item_Ped
				aSif[Len(aSif)][4] := Carga:Itens[nCnt]:Sif_Produto
				aSif[Len(aSif)][5] := Carga:Itens[nCnt]:Qtd_Lib
				aSif[Len(aSif)][6] := aDados[3] // tes
				aSif[Len(aSif)][10] := Carga:Itens[nCnt]:Item_Ped
				aSif[Len(aSif)][13] := aDados[2] // recno_sc6
				aSif[Len(aSif)][16] := aDados[7] // pedido de exportacao
			Else // soma quantidade por sif
				aSif[nPosSif][5] += Carga:Itens[nCnt]:Qtd_Lib	
			Endif	
		Next
		aSort(aQtdLib,,,{|x,y| x[1]+x[2]+x[3] < y[1]+y[2]+y[3]}) // 22/12/17

		If Len(aSif) > 0
			aSort(aSif,,,{|x,y| x[1]+x[2]+x[3]+x[4] < y[1]+y[2]+y[3]+y[4]})
		Endif
		// verifica se a quantidade liberada dos itens eh igual a do pedido, usado na alteracao do pedido, pelo taura ter enviado a quantidade diferente da cadastrada no pedido
		For nCnt:=1 To Len(aQtdLib)
			If aQtdLib[nCnt][17] // pedido de exportacao
				SC6->(dbGoto(aQtdLib[nCnt][5]))
				If SC6->(Recno()) == aQtdLib[nCnt][5]
					If SC6->C6_QTDVEN-SC6->C6_QTDENT != aQtdLib[nCnt][4]
						aQtdLib[nCnt][15] := SC6->C6_QTDVEN-SC6->C6_QTDENT
						aQtdLib[nCnt][16] := .T.
					Endif
				Endif
			Endif
		Next				
		// verifica se a quantidade liberada dos itens eh igual a do pedido, usado na alteracao do pedido, pelo taura ter enviado a quantidade diferente da cadastrada no pedido
		For nCnt:=1 To Len(aSif)
			If aSif[nCnt][16] // pedido de exportacao
				// posiciona array aqtdlib para carregar quantidade total do item
				If (nPos:=aScan(aQtdLib,{|x| x[1]+x[2]+x[3]==aSif[nCnt][1]+aSif[nCnt][2]+aSif[nCnt][3]})) > 0
					SC6->(dbGoto(aSif[nCnt][13]))
					If SC6->(Recno()) == aSif[nCnt][13]
						If SC6->C6_QTDVEN-SC6->C6_QTDENT != aQtdLib[nPos][4]
							aSif[nCnt][14] := SC6->C6_QTDVEN-SC6->C6_QTDENT
							aSif[nCnt][15] := .T.
						Endif
					Endif
				Endif
			Endif	
		Next				
	Endif

	If !lNaoAvalSaldo
		If lContinua
			For nCnt:=1 To Len(aQtdLib)
				nQtdProdLoc := 0 
				nSaldoSB2 := 0
				// verifica a quantidade deste mesmo produto/armazem nesta carga, para ser considerado no calculo do saldo do produto		
				For nCnt1:=1 To Len(aQtdLib)
					If nCnt!=nCnt1 // nao considera esta mesma linha
						If aQtdLib[nCnt1][6] == aQtdLib[nCnt][6] .and. aQtdLib[nCnt1][12] == aQtdLib[nCnt][12] // mesmo produto e mesmo local
							nQtdProdLoc += aQtdLib[nCnt1][4] // soma quantidades das outras linhas
						Endif
					Endif
				Next			

				If aQtdLib[nCnt][13] // lLote
					aSaldo := SldPorLote(Padr(aQtdLib[nCnt][6],nTamProd),Padr(aQtdLib[nCnt][12],nTamLocal),aQtdLib[nCnt][4],0,Padr(aQtdLib[nCnt][8],nTamLote))
					If Len(aSaldo) > 0
						// verifica necessidade de alteracao da data de validade do lote
						/*
						If AlterVldLote(aQtdLib[nCnt],aSaldo)
						// altera no aSaldo a validade, para as rotinas padroes considerarem esta data como referencia
						aSaldo[1][7] := aQtdLib[nCnt][9]
						Endif
						*/
					Endif		
				Else
					If SB2->(dbSeek(xFilial("SB2")+Padr(aQtdLib[nCnt][6],nTamProd)+Padr(aQtdLib[nCnt][12],nTamLocal)))
						If aScan(aRegSB2,SB2->(Recno())) == 0
							aAdd(aRegSB2,SB2->(Recno()))
						Endif	
						nSaldoSB2 := SaldoSB2() //SaldoMov()
					Else // cria sb2 para nao dar erro de sb2 em final de arquivo
						CriaSB2(Padr(aQtdLib[nCnt][6],nTamProd),Padr(aQtdLib[nCnt][12],nTamLocal))
						If aScan(aRegSB2,SB2->(Recno())) == 0
							aAdd(aRegSB2,SB2->(Recno()))
						Endif	
					Endif
					aRet := LockEEC("SB2",1,aQtdLib[nCnt][1],aQtdLib[nCnt][14],aQtdLib[nCnt][2],"",Padr(aQtdLib[nCnt][6],nTamProd)+Padr(aQtdLib[nCnt][12],nTamLocal))
					lContinua := aRet[1]
					cMens := aRet[2]
					If !lContinua
						Conout(cMens)				
						Exit
					Endif	
				Endif		
				If IIf(aQtdLib[nCnt][13],Len(aSaldo) == 0,nSaldoSB2 == 0)
					If aQtdLib[nCnt][13]
						cMens := "Não localizado lote, ou não há saldo disponível em estoque para este lote, para este produto, Filial: "+aQtdLib[nCnt][1]+", Carga: "+aQtdLib[nCnt][14]+", Pedido: "+aQtdLib[nCnt][2]+", Item: "+aQtdLib[nCnt][3]+", Produto: "+Alltrim(aQtdLib[nCnt][6])+", Local: "+Alltrim(aQtdLib[nCnt][12])+", Lote: "+aQtdLib[nCnt][8]
					Else
						cMens := "Não localizado estoque para este produto, Filial: "+aQtdLib[nCnt][1]+", Carga: "+aQtdLib[nCnt][14]+", Pedido: "+aQtdLib[nCnt][2]+", Item: "+aQtdLib[nCnt][3]+", Produto: "+Alltrim(aQtdLib[nCnt][6])+", Local: "+Alltrim(aQtdLib[nCnt][12])
					Endif	
					Conout(cMens)
					lContinua := .F.
					Exit
				Endif
				// compara se a quantidade do lote eh igual a quantidade liberada no Taura
				If IIf(aQtdLib[nCnt][13],aQtdLib[nCnt][4] > aSaldo[1][5],(aQtdLib[nCnt][4] + nQtdProdLoc) > nSaldoSB2)
					cMens := "Não há saldo disponível em estoque, Filial: "+aQtdLib[nCnt][1]+", Carga: "+aQtdLib[nCnt][14]+", Pedido: "+aQtdLib[nCnt][2]+", Item: "+aQtdLib[nCnt][3]+", Produto: "+Alltrim(aQtdLib[nCnt][6])+", Local: "+Alltrim(aQtdLib[nCnt][12])+IIf(aQtdLib[nCnt][13],", Lote: "+aQtdLib[nCnt][8],"")+", Qtd: "+Alltrim(Str(aQtdLib[nCnt][4]+nQtdProdLoc))+CRLF+;
					"OBS: as quantidades deste mesmo Produto/Local constantes nesta carga também estão sendo considerados para o cálculo da disponibilidade do estoque."
					Conout(cMens)
					lContinua := .F.
					Exit
				Else // preenche demais campos do aQtdLib relacionados ao lote
					If aQtdLib[nCnt][13]
						aAdd(aQtdLib[nCnt][7],aClone(aSaldo[1])) // aSaldo
						aQtdLib[nCnt][10] := aSaldo[1][7] // validade lote na sb8
						aQtdLib[nCnt][11] := aSaldo[1][10][1][1] // recno_sb8
					Endif	
				Endif
			Next			
		Endif
	Endif

	aRet := {}
	aAdd(aRet,lContinua)
	aAdd(aRet,cMens)

Return(aRet)


// faz a nova liberacao do item do PV
Static Function LibPV(aQtdLib,aPV,Carga,lAlterCarga,aCabCargaERP)

	Local aRet := {}
	Local cMens := ""
	Local nCnt := 0
	Local lContinua := .T.
	//Local nCntLote := 0
	Local aSaldo := {}
	//Local nSaldoSB2 := 0
	Local cTime1 := ""
	Local cTime2 := ""
	Local nTamProd := TamSX3("B1_COD")[1]
	Local nTamLote := TamSX3("B8_LOTECTL")[1]
	Local nTamLocal := TamSX3("B8_LOCAL")[1]
	Local aQtdLibSav := aClone(aQtdLib)

	aSort(aQtdLib,,,{|x,y| x[1]+x[6]+x[12] < y[1]+y[6]+y[12]}) // filial+produto+local

	// estorna liberacoes anteriores do pedido/item
	// estorna todas as liberacoes antes de comecar a avaliar quais liberacoes devem ser efetuadas novamente, pois podem ter lotes diferentes para o mesmo pedido, desta forma,
	// para garantir a confiabilidade, estorna tudo antes de liberar tudo de novo  
	For nCnt:=1 To Len(aQtdLib)
		// 04/05/18, linha comentada nesta data, pois foi identificado que alguns pedidos jah estavam liberados no sc9 antes mesmo da carga ser incluida, mas estavam
		// sem numero de carga e com a mesma quantidade enviada pelo taura, neste cenario o sc9 permanecia gravado, mas sem ficar amarrado a carga e quando faturava 
		// a carga, este item ficava de fora do faturamento, com esta alteracao a rotina sempre estorna o sc9 antes de incluir a carga, garantindo que nenhum sc9 vai
		// ficar perdido.
		//If aQtdLib[nCnt][13] .or. (!aQtdLib[nCnt][13] .and. DadosSC9(aQtdLib[nCnt][2],aQtdLib[nCnt][3],.F.) != aQtdLib[nCnt][4])
		aRet := EstornaSC9(aQtdLib[nCnt][2],aQtdLib[nCnt][3],IIf(aQtdLib[nCnt][13],aQtdLib[nCnt][8],""),Carga)
		lContinua := aRet[1]

		If !lContinua
			Exit
		Endif	
		//Endif	
	Next

	If lContinua
		For nCnt:=1 To Len(aQtdLib)
			If aScan(aPV,{|x| x[1]==aQtdLib[nCnt][2]}) == 0
				aAdd(aPV,{aQtdLib[nCnt][2],.F.})
			Endif

			// soh libera novamente o SC9 se o produto tiver controle de lote, pois o Taura vai enviar o lote e no SC9 atual nao vai estar com o lote 
			// ou se nao tiver controle de lote e a quantidade liberada for diferente da que estiver no SC9
			If aQtdLib[nCnt][13] .or. (!aQtdLib[nCnt][13] .and. DadosSC9(aQtdLib[nCnt][2],aQtdLib[nCnt][3],.F.) != aQtdLib[nCnt][4])
				/*
				If aQtdLib[nCnt][13]
				// verifica necessidade de alteracao da data de validade do lote
				AlterVldLote(aQtdLib[nCnt])
				Endif	
				*/
				//EstornaSC9(aQtdLib[nCnt][2],aQtdLib[nCnt][3],IIf(lLote,aQtdLib[nCnt][8],""),Carga)

				// libera por lote
				//For nCntLote:=1 To IIf(aQtdLib[nCnt][13],Len(aQtdLib[nCnt][7]),1)
				//nSaldoSB2 := 0
				// por seguranca, garante novamente o saldo disponivel no estoque
				/* retirado em 30/01/18, para ganho de performance da rotina, uma vez que o saldo jah eh checado anteriormente nesta rotina, esta re-checagem nao se faz necessaria
				If aQtdLib[nCnt][13]
				//aSaldo := SldPorLote(Padr(aQtdLib[nCnt][6],TamSX3("B1_COD")[1]),aQtdLib[nCnt][12],aQtdLib[nCnt][7][nCntLote][5],0,Padr(aQtdLib[nCnt][8],TamSX3("B8_LOTECTL")[1]))
				aSaldo := SldPorLote(Padr(aQtdLib[nCnt][6],nTamProd),aQtdLib[nCnt][12],aQtdLib[nCnt][4],0,Padr(aQtdLib[nCnt][8],nTamLote))
				// soh prossegue se houver saldo maior que a quantidade liberada neste lote
				If !(Len(aSaldo) > 0 .and. aQtdLib[nCnt][4] <= aSaldo[1][5])
				lContinua := .F.
				Endif
				Else
				If SB2->(dbSeek(xFilial("SB2")+Padr(aQtdLib[nCnt][6],nTamProd)+Padr(aQtdLib[nCnt][12],nTamLocal)))
				nSaldoSB2 := SaldoSB2() //SaldoMov()
				If aQtdLib[nCnt][4] > nSaldoSB2
				lContinua := .F.
				Endif	
				Endif		
				Endif		

				If !lContinua
				cMens := "Não há saldo disponível em estoque, Filial: "+aQtdLib[nCnt][1]+", Carga: "+aQtdLib[nCnt][14]+", Pedido: "+aQtdLib[nCnt][2]+", Item: "+aQtdLib[nCnt][3]+", Produto: "+aQtdLib[nCnt][6]+", Local: "+Alltrim(aQtdLib[nCnt][12])+IIf(aQtdLib[nCnt][13],", Lote: "+aQtdLib[nCnt][8],"")+", Qtd: "+Str(aQtdLib[nCnt][4])
				Conout(cMens)
				Exit
				Endif	
				*/

				//If MaLibDoFat(aQtdLib[nCnt][5]/*nRegSC6*/,IIf(lLote,aQtdLib[nCnt][7][nCntLote][5],aQtdLib[nCnt][4])/*nQtdaLib*/,.F./*lCredito*/,.T./*lEstoque*/,.T./*lAvCred*/,.T./*lAvEst*/,/*lLibPar*/,/*lTrfLocal*/,/*aEmpenho*/,/*bBlock*/,IIf(lLote,{aClone(aQtdLib[nCnt][7][nCntLote])},Nil)/*aEmpPronto*/,/*lTrocaLot*/,/*lGeraDCF*/,/*nVlrCred*/,/*nQtdalib2*/) != IIf(lLote,aQtdLib[nCnt][7][nCntLote][5],aQtdLib[nCnt][4])
				// obs: posicionar o SC6 antes de chamar a funcao padrao MaLibdoFat, pois o SC6 jah eh lido nesta funcao, antes mesmo da funcao reposcionar o SC6, 
				// podendo gerar problemas de leitura de campos
				SC6->(dbGoto(aQtdLib[nCnt][5]))
				If MaLibDoFat(aQtdLib[nCnt][5]/*nRegSC6*/,aQtdLib[nCnt][4]/*nQtdaLib*/,.F./*lCredito*/,.T./*lEstoque*/,.T./*lAvCred*/,.T./*lAvEst*/,/*lLibPar*/,/*lTrfLocal*/,/*aEmpenho*/,/*bBlock*/,IIf(aQtdLib[nCnt][13],aClone(aQtdLib[nCnt][7]),Nil)/*aEmpPronto*/,/*lTrocaLot*/,/*lGeraDCF*/,/*nVlrCred*/,/*nQtdalib2*/) != aQtdLib[nCnt][4]
					cMens := "Problemas na Liberação/Reserva da quantidade, Filial: "+aQtdLib[nCnt][1]+", Carga: "+aQtdLib[nCnt][14]+", Pedido: "+aQtdLib[nCnt][2]+", Item: "+aQtdLib[nCnt][3]
					Conout(cMens)
					lContinua := .F.
					Exit
				Else // forca liberacao de credito e estoque
					If !LibCredEst(aQtdLib[nCnt][2],aQtdLib[nCnt][3],IIf(aQtdLib[nCnt][13],aClone(aQtdLib[nCnt][7]),Nil),Carga,aCabCargaERP)	
						cMens := "Problemas na Liberação da quantidade, Filial: "+aQtdLib[nCnt][1]+", Carga: "+aQtdLib[nCnt][14]+", Pedido: "+aQtdLib[nCnt][2]+", Item: "+aQtdLib[nCnt][3]
						Conout(cMens)
						lContinua := .F.					
						Exit
					Endif	

					aPV[aScan(aPV,{|x| x[1]==aQtdLib[nCnt][2]})][2] := .T. // flega que pedido foi liberado novamente
				Endif
				If lErro
					lContinua := .F.
					Exit
				Endif				
				//Next	
			Endif	
		Next
	Endif

	If lContinua
		// reordena aPV por numero de pedido
		aSort(aPV,,,{|x,y| x[1] < y[1]})
		For nCnt:=1 To Len(aPV)
			If aPV[nCnt][2] // se passou novamente pelo processo de liberacao
				MaLiberOk({aPV[nCnt][1]},.F.)
			Endif	
		Next	
	Endif	

	aQtdLib := aClone(aQtdLibSav)

	aRet := {}
	aAdd(aRet,lContinua)
	aAdd(aRet,cMens)

Return(aRet)


// rotina complementar de inclusao da carga
Static Function IncCarga(Carga,aPV,aQtdLib,aCabCargaERP,aSif)

	Local nCnt := 0
	Local cQ := ""
	Local cAliasTrb := GetNextAlias() 
	Local cRota := GetMv("MGF_ROTA",,"999999")
	Local cZona := GetMv("MGF_ZONA",,"999999")
	Local cSetor := GetMv("MGF_SETOR",,"999999")
	Local aArrayGera := {}
	Local aRet := {}
	Local cMens := ""
	Local lContinua := .T.
	Local cSeq := Repl("0",TamSX3("DAI_SEQUEN")[1])
	Local nSeq := 5
	Local aCli := {}
	Local lOms200Fim := ExistBlock("OM200FIM")
	Local cMensGWN := ""
	Local cTime1 := ""
	Local cTime2 := ""
	Local nTamFilial := TamSX3("C9_FILIAL")[1]
	Local nTamPedido := TamSX3("C9_PEDIDO")[1]
	Local nTamItem   := TamSX3("C9_ITEM")[1]

	cTime1 := Time()
	For nCnt:=1 To Len(aPV)
		cQ := "SELECT C9_FILIAL,C9_CLIENTE,C9_LOJA,C9_PEDIDO,C9_ITEM,C9_SEQUEN,SC9.R_E_C_N_O_ RECSC9 "
		cQ += " FROM "
		cQ += RetSqlName("SC9")+ " SC9 "
		cQ += " WHERE "
		cQ += "C9_FILIAL = '"+xFilial("SC9")+"' AND "
		cQ += "C9_PEDIDO = '"+aPV[nCnt][1]+"' AND "
		cQ += "C9_BLCRED = '"+Space(Len(SC9->C9_BLCRED))+"' AND "
		cQ += "C9_BLEST  = '"+Space(Len(SC9->C9_BLEST ))+"' AND "
		cQ += "C9_CARGA  = '"+Space(Len(SC9->C9_CARGA ))+"' AND "
		cQ += "C9_SEQCAR = '"+Space(Len(SC9->C9_SEQCAR))+"' AND "
		cQ += "SC9.D_E_L_E_T_ = ' ' "
		cQ += "ORDER BY C9_FILIAL,C9_CLIENTE,C9_LOJA,C9_PEDIDO,C9_ITEM,C9_SEQUEN "

		cQ := ChangeQuery(cQ)
		//MemoWrite("c:\temp\mgftas02_2.sql",cQ)

		DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),cAliasTrb,.F.,.T.)

		// a cada troca de cliente, incrementa a sequencia
		If aScan(aCli,(cAliasTrb)->C9_CLIENTE+(cAliasTrb)->C9_LOJA) == 0
			aAdd(aCli,(cAliasTrb)->C9_CLIENTE+(cAliasTrb)->C9_LOJA)
			cSeq := StrZero(Val(cSeq)+nSeq,6)
		Endif		

		While (cAliasTrb)->(!Eof())
			// verifica se o item do pedido veio na integracao
			//If aScan(aQtdLib,{|x| x[1]+x[2]+x[3]==(cAliasTrb)->C9_FILIAL+(cAliasTrb)->C9_PEDIDO+(cAliasTrb)->C9_ITEM}) == 0
			If aScan(aQtdLib,{|x| Padr(x[1],nTamFilial)+Padr(x[2],nTamPedido)+Padr(x[3],nTamItem)==(cAliasTrb)->C9_FILIAL+(cAliasTrb)->C9_PEDIDO+(cAliasTrb)->C9_ITEM}) == 0
				(cAliasTrb)->(dbSkip())
				Loop
			Endif	
			AAdd(aArrayGera, {	cSeq,;						//  1- Sequencia
			cRota,;						//  2- Rota
			cZona,;						//  3- Zona
			cSetor,;					//  4- Setor
			(cAliasTrb)->C9_PEDIDO,;	//  5- Pedido
			(cAliasTrb)->C9_ITEM,;		//  6- Item
			(cAliasTrb)->C9_CLIENTE,;	//  7- Cliente
			(cAliasTrb)->C9_LOJA,;		//  8- Loja
			(cAliasTrb)->RECSC9,;		//  9- Reg. SC9
			"",;						// 10- Endereco padrao
			(cAliasTrb)->C9_FILIAL,;	// 11- Filial Pedido
			OsFilial("SA1",(cAliasTrb)->C9_FILIAL),;	// 12- Filial Cliente
			"",;						// 13- Hora chegada
			"",;						// 14- Time Service
			cTod(""),;					// 15- Data chegada
			cTod(""),;					// 16- Data saida
			0,;							// 17- Valor do Frete
			0 })						// 18- Frete Autonomo

			(cAliasTrb)->(dbSkip())
		Enddo

		(cAliasTrb)->(dbCloseArea())
	Next	
	cTime2 := Time()
	cMensTime := "ORDEM EMBARQUE: "+Carga:Cabecalho:Ordem_Embarque+" - FIM SC9 PARA COMPOR CARGA: "+ElapTime(cTime1,cTime2)+" - Time: "+Time()+CRLF
	ConOut(cMensTime)
	cLogTime += cMensTime

	If Len(aArrayGera) > 0
		// integra com GFE
		// verifica se jah existe romaneio para esta carga, pois algumas vezes a carga eh gerada e faturada e excluida a nota em seguida, mas o romaneio estah permanecendo 
		// indevidamente na base, quando a carga eh reenviada, estah ocorrendo erro, pois a gwn jah existe. Neste cenario, a gwn serah excluida caso jah exista
		If GetMv("MGF_OEEXRO",,.T.) 
			GWN->(dbSetOrder(1))
			If GWN->(dbSeek(xFilial("GWN")+Padr(Carga:Cabecalho:Ordem_Embarque,TamSX3("DAK_COD")[1])+"01"))
				GWN->(RecLock("GWN",.F.))
				GWN->(dbDelete())
				GWN->(MsUnLock())
			Endif	
		Endif	

		cTime1 := Time()
		lContinua := OMSA200IPG(3,aCabCargaERP[1]/*cVeiculo*/,aCabCargaERP[2]/*cMotorista*/,.F.,Carga:Cabecalho:Ordem_Embarque/*cCarga*/,Nil,aPV[1]/*aArrayMan[1][5]*/,aCabCargaERP[3]/*cDakTransp*/)
		cTime2 := Time()
		cMensTime := "ORDEM EMBARQUE: "+Carga:Cabecalho:Ordem_Embarque+" - FIM INT. GFE ( VALIDAÇÃO ): "+ElapTime(cTime1,cTime2)+" - Time: "+Time()+CRLF
		ConOut(cMensTime)
		cLogTime += cMensTime
		If lErro
			lContinua := .F.
		Endif	

		If lContinua
			//Function Oms200Carga(aArrayGera,cCarga,cSeqCar,cVeiculo,cMotorista,cAjuda1,cAjuda2,cAjuda3,cHrStart,dDtStart,nSaveSx8,aArrayFrt,aHeaderFrt,aColsFrt,aCargaAnt,cGvCodOper,cGvNoProc,cGvPedComOp,aHeaderAdt,aColsAdt,cDakTransp,lEndeWMS)
			// chama rotina padrao de inclusao da carga
			cTime1 := Time()
			Processa({|| Oms200Carga(@aArrayGera,Carga:Cabecalho:Ordem_Embarque,Nil/*cSeqCar*/,aCabCargaERP[1]/*cVeiculo*/,aCabCargaERP[2]/*cMotorista*/,""/*cAjuda1*/,""/*cAjuda2*/,""/*cAjuda3*/,Time()/*cHrStart*/,dDataBase/*dDtStart*/,0/*nSaveSx8*/,/*aArrayFrt*/,/*aHeaderFrt*/,/*aColsFrt*/,/*aCargaAnt*/,/*cGvCodOper*/,/*cGvNoProc*/,/*cGvPedComOp*/,/*aHeaderAdt*/,/*aColsAdt*/,aCabCargaERP[3]/*cDakTransp*/,/*lEndeWMS*/)})
			cTime2 := Time()
			cMensTime := "ORDEM EMBARQUE: "+Carga:Cabecalho:Ordem_Embarque+" - FIM OMS200GRAVA: "+ElapTime(cTime1,cTime2)+" - Time: "+Time()+CRLF
			ConOut(cMensTime)
			cLogTime += cMensTime
			If lErro
				lContinua := .F.
			Endif	

			// valida se SC9 ficou gerado para todos os itens da carga
			If lContinua
				If GetMv("MGF_OEVLIB",,.F.) 
					cTime1 := Time()
					aRet := VldLib(aSif,Carga,aQtdLib,.F.)
					cTime2 := Time()
					cMensTime := "ORDEM EMBARQUE: "+Carga:Cabecalho:Ordem_Embarque+" - FIM VLD. LIBPV: "+ElapTime(cTime1,cTime2)+" - Time: "+Time()+CRLF
					ConOut(cMensTime)
					cLogTime += cMensTime

					lContinua := aRet[1]
					If !lContinua
						cMens := aRet[2]
					Endif	
				Endif	
			Endif	

			If lContinua
				// grava campos adicionais
				//If Alltrim(DAK->DAK_COD) == Carga:Cabecalho:Ordem_Embarque
				DAK->(dbSetOrder(1))
				If DAK->(dbSeek(xFilial("DAK")+Carga:Cabecalho:Ordem_Embarque)) .and. Alltrim(DAK->DAK_COD) == Carga:Cabecalho:Ordem_Embarque
					//-- Integracao Protheus x GFE (INCLUSAO)
					cTime1 := Time()
					lContinua := (OMSA200IPG(3,,,.T.,,,,aCabCargaERP[3]/*cDakTransp*/)) //.and. OMSA200IPG(4,aCabCargaERP[1]/*cVeiculo*/,aCabCargaERP[2]/*cMotorista*/,.T.,,,,aCabCargaERP[3]/*cDakTransp*/))
					//If !(OMSA200IPG(3,,,.T.,,,,aCabCargaERP[3]/*cDakTransp*/)) //.and. OMSA200IPG(4,aCabCargaERP[1]/*cVeiculo*/,aCabCargaERP[2]/*cMotorista*/,.T.,,,,aCabCargaERP[3]/*cDakTransp*/))
					If lErro
						lContinua := .F.
					Endif				
					If !lContinua
						//If InTransact()	
						//DisarmTransaction() // obs: inserido em 20/06/18, para tentar resolver o problema, pois quando o sistema apresenta erro na funcao padrao OMSA200IPG, 
						// o controle de transacao nao funciona e a carga fica gravada pela metade
						//Endif	
						GWNTrataErro(@cMensGWN)
						//lContinua := .F.
						cMens := "Problemas na execução da função padrão: 'OMSA200IPG' ( execução ), para a geração da Carga, Filial: "+Carga:Cabecalho:Filial+", Carga: "+Carga:Cabecalho:Ordem_Embarque+CRLF
						cMens := cMens+cMensGWN
						Conout(cMens)
					Else
						// gravacao de campos na tabela GWN do GFE
						GWN->(dbSetOrder(1))
						If GWN->(dbSeek(xFilial("GWN")+DAK->DAK_COD+DAK->DAK_SEQCAR))
							GWN->(RecLock("GWN",.F.))
							If AllTrim(Carga:Cabecalho:Ordem_Embarque) = AllTrim(Carga:Cabecalho:OEReferencia) 
								cMensTime := "ORDEM EMBARQUE: "+Carga:Cabecalho:Ordem_Embarque+" - DISTÂNCIA EM ROMANEIO ( INCLUSÃO ): "+ElapTime(cTime1,cTime2)+" - Time: "+Time()+CRLF
								GWN->GWN_DISTAN	:= Carga:Cabecalho:Distancia	
							Else
								If GetMv("MGF_TAS02A",,.T.)	//Se exclui os romaneios filhos
									cMensTime := "ORDEM EMBARQUE: "+Carga:Cabecalho:Ordem_Embarque+" - EXCLUINDO ROMANEIO FILHO ( INCLUSÃO ): "+"OE REFERÊNCIA: "+Carga:Cabecalho:OEReferencia+ElapTime(cTime1,cTime2)+" - Time: "+Time()+CRLF
									GWN->(dbDelete())
								EndIf
							EndIf
							GWN->(MsUnlock())
						Endif	
					EndIf
					cTime2 := Time()
					cMensTime := "ORDEM EMBARQUE: "+Carga:Cabecalho:Ordem_Embarque+" - FIM INT. GFE ( INCLUSÃO ): "+ElapTime(cTime1,cTime2)+" - Time: "+Time()+CRLF
					ConOut(cMensTime)
					cLogTime += cMensTime

					If lContinua
						cTime1 := Time()
						GrvCabCampos(Carga)
						cTime2 := Time()
						cMensTime := "ORDEM EMBARQUE: "+Carga:Cabecalho:Ordem_Embarque+" - FIM GRAV. CAMPOS DAK: "+ElapTime(cTime1,cTime2)+" - Time: "+Time()+CRLF
						ConOut(cMensTime)
						cLogTime += cMensTime

						//-- Ponto de entrada no final do carregamento
						If lOms200Fim
							//ExecBlock("OM200FIM",.F.,.F.)
						EndIf

						// gravacao de tabela especifica para customizacao do SIGAEEC, GAP EEC09
						cTime1 := Time()
						GrvTabEEC09(Carga,"1",aSif) // inclui
						cTime2 := Time()
						cMensTime := "ORDEM EMBARQUE: "+Carga:Cabecalho:Ordem_Embarque+" - FIM GRAV. CAMPOS EEC: "+ElapTime(cTime1,cTime2)+" - Time: "+Time()+CRLF
						ConOut(cMensTime)
						cLogTime += cMensTime

						cMens := "Inclusão da Carga com sucesso, Filial: "+Carga:Cabecalho:Filial+", Carga: "+Carga:Cabecalho:Ordem_Embarque
						Conout(cMens)
					Endif	
				Else
					cMens := "Problemas na Inclusão da Carga, posicionamento da DAK ao final da inclusão, Filial: "+Carga:Cabecalho:Filial+", Carga: "+Carga:Cabecalho:Ordem_Embarque
					Conout(cMens)
					lContinua := .F.
				Endif		
			Endif	
		Else	
			GWNTrataErro(@cMensGWN)
			cMens := "Problemas na execução da função padrão: 'OMSA200IPG' ( validação ), para a geração da Carga, Filial: "+Carga:Cabecalho:Filial+", Carga: "+Carga:Cabecalho:Ordem_Embarque+CRLF
			cMens := cMens+cMensGWN
			Conout(cMens)
		Endif	
	Else
		cMens := "Problemas na filtragem dos Pedidos liberados para a geração da Carga, Filial: "+Carga:Cabecalho:Filial+", Carga: "+Carga:Cabecalho:Ordem_Embarque
		Conout(cMens)
		lContinua := .F.
	Endif

	aRet := {}
	aAdd(aRet,lContinua)
	aAdd(aRet,cMens)

Return(aRet)


// forca liberacao de credito e estoque da nova liberacao do item do PV
Static Function LibCredEst(cPedido,cItemPed,aSaldo,Carga,aCabCargaERP)

	Local aArea	:= {SC9->(GetArea()),GetArea()}
	Local lHelp	:= .F.
	Local lRet := .T.
	Local aAreaSC9 := {}

	SC9->(DbSetOrder(1))//C9_FILIAL, C9_PEDIDO, C9_ITEM, C9_SEQUEN, C9_PRODUTO

	If SC9->(dbSeek(xFilial("SC9")+cPedido+cItemPed))
		While SC9->(!Eof()) .and. xFilial("SC9")+cPedido+cItemPed == SC9->C9_FILIAL+SC9->C9_PEDIDO+SC9->C9_ITEM
			If !((Empty(SC9->C9_BLCRED) .and. Empty(SC9->C9_BLEST)) .Or.;
			(SC9->C9_BLCRED=="10" .and. SC9->C9_BLEST=="10"))
				// trata somente o lote corrente
				If aSaldo != Nil .and. Len(aSaldo) > 0
					If !Alltrim(aSaldo[1][1]) == Alltrim(SC9->C9_LOTECTL)
						SC9->(dbSkip())
						Loop
					Endif
				Endif		
				aAreaSC9 := SC9->(GetArea()) // salva area atual, pois a rotina a450grava pode desposicionar o SC9, pois insere registros na tabela
				//Function a450Grava(nOpc,lAtuCred,lAtuEst,lHelp,aSaldos,lAvEst)
				//a450Grava(1,.T.,.T.,@lHelp,)
				If aSaldo != Nil
					a450Grava(1,.T.,.F.,@lHelp,IIf(aSaldo != Nil .and. Len(aSaldo)>0,aSaldo,Nil))
				Else
					a450Grava(1,.T.,.T.,@lHelp,IIf(aSaldo != Nil .and. Len(aSaldo)>0,aSaldo,Nil),.T.)
				Endif	
				// se ficar com bloqueio de estoque, nao prossegue
				lRet := .F.
				If SC9->(dbSeek(xFilial("SC9")+cPedido+cItemPed))
					While SC9->(!Eof()) .and. xFilial("SC9")+cPedido+cItemPed == SC9->C9_FILIAL+SC9->C9_PEDIDO+SC9->C9_ITEM
						If aSaldo != Nil .and. Len(aSaldo) > 0
							If !Alltrim(aSaldo[1][1]) == Alltrim(SC9->C9_LOTECTL)
								SC9->(dbSkip())
								Loop 
							Endif	
						Endif	
						If Empty(SC9->C9_BLEST) .and. Empty(SC9->C9_BLCRED)
							lRet := .T.
							Exit
						Endif	
						SC9->(dbSkip())
					Enddo
				Endif		
				SC9->(RestArea(aAreaSC9))
			EndIf			
			SC9->(dbSkip())
		Enddo
	Endif

	aEval(aArea,{|x| RestArea(x)})	

Return(lRet)


// rotina de estorno de liberacao do item atual do PV
Static Function EstornaSC9(cPedido,cItemPed,cLote,Carga)

	Local aArea	:= {SC9->(GetArea()),GetArea()}
	Local aRet := {}
	Local lContinua := .T.
	Local cMens := ""

	Default cLote := ""

	SC9->(DbSetOrder(1))//C9_FILIAL, C9_PEDIDO, C9_ITEM, C9_SEQUEN, C9_PRODUTO
	If SC9->(dbSeek(xFilial("SC9")+cPedido+cItemPed))
		While SC9->(!Eof()) .and. xFilial("SC9")+cPedido+cItemPed == SC9->C9_FILIAL+SC9->C9_PEDIDO+SC9->C9_ITEM
			If !(SC9->C9_BLCRED=="10" .and. SC9->C9_BLEST=="10")
				If !Empty(cLote)
					If !Alltrim(SC9->C9_LOTECTL) == Alltrim(cLote)
						SC9->(dbSkip())
						Loop
					Endif	
				Endif	
				If !A460Estorna()
					lContinua := .F.
					If Type("Carga") != "U"
						cMens := "Problemas no estorno da liberação do pedido, Filial: "+Carga:Cabecalho:Filial+", Carga: "+Carga:Cabecalho:Ordem_Embarque+", Pedido: "+cPedido+", Item: "+cItemPed
					Elseif Type("__cCarga") != "U" // chamada pelo ponto de entrada M521DNFS
						cMens := "Problemas no estorno da liberação do pedido, Filial: "+xFilial("SC9")+", Carga: "+__cCarga+", Pedido: "+SC9->C9_PEDIDO+", Item: "+SC9->C9_ITEM
					Endif	
					Conout(cMens)
					Exit
				Endif	
			EndIf			
			SC9->(dbSkip())
		Enddo
	Endif

	aRet := {}
	aAdd(aRet,lContinua)
	aAdd(aRet,cMens)

	aEval(aArea,{|x| RestArea(x)})	

Return(aRet)


// rotina de extracao de dados do SC9
Static Function DadosSC9(cPedido,cItemPed,lFaturado,lOutrasCargas,cCarga,lSemBloq)

	Local aArea := {GetArea()}
	Local cQ := ""
	Local nRet := 0
	Local cAliasTrb := GetNextAlias()

	Default lOutrasCargas := .F.
	Default cCarga := ""
	Default cItemPed := ""
	Default lSemBloq := .F.

	cQ := "SELECT C9_QTDLIB,R_E_C_N_O_ SC9_RECNO "
	cQ += "FROM "+RetSqlName("SC9")+" SC9 "
	cQ += "WHERE "
	cQ += "C9_FILIAL = '"+xFilial("SC9")+"' "
	cQ += "AND C9_PEDIDO = '"+cPedido+"' "
	If !Empty(cItemPed)
		cQ += "AND C9_ITEM = '"+cItemPed+"' "
	Endif	
	If !lFaturado
		cQ += "AND C9_BLEST <> '10' "
		cQ += "AND C9_BLCRED <> '10' "
	Else
		cQ += "AND C9_BLEST = '10' "
		cQ += "AND C9_BLCRED = '10' "
	Endif
	If lOutrasCargas .and. !Empty(cCarga)
		cQ += "AND C9_CARGA <> '"+cCarga+"' "
		cQ += "AND C9_CARGA <> ' ' "
	Endif	
	If !lOutrasCargas .and. !Empty(cCarga)
		cQ += "AND C9_CARGA = '"+cCarga+"' "
	Endif	
	If lSemBloq .and. Empty(cCarga) // valida liberacao do pedido, carga deve estar em branco
		cQ += "AND C9_CARGA = ' ' "
	Endif
	If lSemBloq
		cQ += "AND C9_BLEST = ' ' "
		cQ += "AND C9_BLCRED = ' ' "
	Endif
	cQ += "AND SC9.D_E_L_E_T_ <> '*' "

	cQ := ChangeQuery(cQ)
	//MemoWrite("mgftas02_3.sql",cQ)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),cAliasTrb,.T.,.T.)

	tcSetField(cAliasTrb,"C9_QTDLIB",'N',TamSx3("C9_QTDLIB")[1],TamSx3("C9_QTDLIB")[2])

	While (cAliasTrb)->(!Eof())
		nRet += (cAliasTrb)->C9_QTDLIB
		(cAliasTrb)->(dbSkip())
	Enddo

	(cAliasTrb)->(dbCloseArea()) 

	aEval(aArea,{|x| RestArea(x)})	

Return(nRet)

/*
// altera data de validade dos lotes
Static Function AlterVldLote(aQtdLib,aSaldo)

Local lRet := .F.

// variaveis da rotina padrao mata390
Private aRecno := {}
Private aRecnoSDD := {}
Private aRecnoSBF := {}
Private aRecnoSDC := {}
//

// verifica se a data de validade veio informada pelo Taura e se esta eh diferente do Protheus
//If !Empty(aQtdLib[9]) .and. aQtdLib[9] != aQtdLib[10]
If !Empty(aQtdLib[9]) .and. aQtdLib[9] != aSaldo[1][7]
//aRecno := {aQtdLib[11]}
aRecno := {aSaldo[1][10][1][1]}
A390PrcVal(aQtdLib[9])
lRet := .T.
Endif	

Return(lRet)
*/

// funcao copiada da padrao Os200Estor
// foi necessario replicar esta funcao aqui, pois o padrao nao tem rotina automatica e a variavel lProcessa que controla a exclusao ou nao da carga eh local
// desta forma, nao consigo saber se a carga foi ou nao excluida, e caso nao seja, o motivo
Static Function MyOs200Estor()

	Local lProcessa := .T.
	Local lRetPE    := .T.
	Local lBlqCar   := ( DAK->(FieldPos("DAK_BLQCAR")) > 0 )
	Local lBloqueio := OsBlqExec(DAK->DAK_COD, DAK->DAK_SEQCAR)
	Local aAreaAnt  := {}
	Local aAreaSC9  := {}
	Local cSeekSC9  := ''
	Local lFreteEmb := .F.
	Local aRet := {}
	Local cMens1 := ""
	Local cMens2 := ""
	Local cMens3 := ""
	Local cMens := ""
	Local cMensGWN := ""

	cMens1 := "Carga não excluída."+CRLF
	cMens3 := "Filial: "+Carga:Cabecalho:Filial+", Carga: "+Carga:Cabecalho:Ordem_Embarque			

	//verifico se a carga ja foi unitizada impossibilitando o estorno
	If lProcessa .And. ( DAK->DAK_FLGUNI == "1" )
		//Help(" ",1,"OMS200CUNI") //A carga mencionada j?foi unitizada.
		lProcessa := .F.
		cMens2 := "Motivo: "+"A carga mencionada já foi unitizada."+CRLF
		cMens := cMens1+cMens2+cMens3
	EndIf

	If lProcessa .And. (DAK->DAK_FEZNF == "1" .or. FatSC9(Carga:Cabecalho:Ordem_Embarque))
		//Help(" ",1,"OMS200CFAT") //Esta carga j?se encontra faturada.
		lProcessa := .F.
		cMens2 := "Motivo: "+"Esta carga já se encontra faturada."+CRLF
		cMens := cMens1+cMens2+cMens3
	EndIf

	//Verifica se existe o campo e se esta bloqueada                     
	If lProcessa .And. (( lBlqCar .And. DAK->DAK_BLQCAR == '1' ) .Or. lBloqueio)
		lProcessa := .F.
		//Help(" ",1,"OMS200CGBL") //Carga bloqueada ou com servi? em execu?o.
		cMens2 := "Motivo: "+"Carga bloqueada ou com serviço em execução."+CRLF
		cMens := cMens1+cMens2+cMens3
	EndIf

	//Se a carga possui contrato de carreteiro nao pode ser estornada
	If lProcessa .And. lFreteEmb
		DTY->(DbSetOrder(5)) //DTY_FILIAL+DTY_TIPUSO+DTY_IDENT+DTY_NUMCTC
		If DTY->(DbSeek(xFilial("DTY")+"2"+DAK->DAK_IDENT))
			lProcessa := .F.
			//MsgAlert("Carga possui Contrato de Carreteiro, nao e permitido o Estorno") //"Carga possui Contrato de Carreteiro, nao e permitido o Estorno"
			cMens2 := "Motivo: "+"Carga possui Contrato de Carreteiro, nao e permitido o Estorno."+CRLF
			cMens := cMens1+cMens2+cMens3
		EndIf
	EndIf

	//impede o estorno de Cargas com Servico de WMS jah executado ?
	If lProcessa
		aAreaAnt := GetArea()
		aAreaSC9 := SC9->(GetArea())
		SC5->(DbSetOrder(1)) //C5_FILIAL+C5_NUM
		SC9->(DbSetOrder(5))
		If SC9->(MsSeek(cSeekSC9 := xFilial('SC9')+DAK->DAK_COD+DAK->DAK_SEQCAR))
			While SC9->( !Eof() .And. SC9->C9_FILIAL+SC9->C9_CARGA+SC9->C9_SEQCAR == cSeekSC9 )
				If IntDL(SC9->C9_PRODUTO) .And. !Empty(SC9->C9_SERVIC)
					If SC5->(MsSeek(xFilial('SC5')+SC9->C9_PEDIDO,.F.))
						//-- Somente valida a execu?o da OS se a gera?o da OS ?feita na carga
						//-- 1=no Pedido;2=na Montagem da Carga;3=na Unitizacao da Carga
						If SC5->C5_GERAWMS <> "1"
							If !(lProcessa := WmsAvalSC9())
								Exit
							EndIf
						EndIf
					EndIf
				EndIf
				SC9->(DbSkip())
			EndDo
		EndIf
		RestArea( aAreaSC9 )
		RestArea( aAreaAnt )
	EndIf

	//-- Template DCL-EST - Validacao do estorno de Cargas com Compartimentos/Lacres associados.
	If lProcessa .and. ExistTemplate("OMSA200P")
		lRetPE    := ExecTemplate("OMSA200P",.F.,.F.,{DAK->DAK_COD,DAK->DAK_SEQCAR})
		lProcessa := If(ValType(lRetPE)=="L", lRetPE, lProcessa)
	EndIf

	//--PE antes da pergunta se deseja ou n? realizar o estorno
	If lProcessa .and. ExistBlock("OMSA200P")
		lRetPE    := ExecBlock("OMSA200P",.F.,.F.,{DAK->DAK_COD,DAK->DAK_SEQCAR})
		lProcessa := If(ValType(lRetPE)=="L", lRetPE, lProcessa)
	EndIf

	//-- Integra?o Protheus x GFE (EXCLUSAO)
	If lProcessa .and. !OMSA200IPG(5,,,.T.,,,,DAK->DAK_TRANSP)
		lProcessa := .F.
		GWNTrataErro(@cMensGWN)
		cMens2 := "Motivo: "+"Problemas na execução da função padrão: 'OMSA200IPG' ( execução )."+CRLF
		cMens2 := cMens2+cMensGWN
		cMens := cMens1+cMens2+cMens3
	EndIf

	If lProcessa
		//cMens := OemToAnsi("Confirma estorno das Cargas selecionadas ? Os Pedidos de Venda contidos nestas ") //"Confirma estorno das Cargas selecionadas ? Os Pedidos de Venda contidos nestas "
		//cMens := cMens + OemToAnsi("Cargas voltarao a ficar sem carga definida e aptos a serem utilizados em outras Cargas.") //"Cargas voltarao a ficar sem carga definida e aptos a serem utilizados em outras Cargas."
		//If MsgYesNo(cMens,OemToAnsi("ATEN€AO")) //"ATEN€AO"
		//Processa( { || Os200ProcEst(DAK->DAK_COD) }, cCadastro, OemtoAnsi("Estornando Cargas...") ) //"Estornando Cargas..."
		// chama rotina padrao de exclusao de carga
		Os200ProcEst(DAK->DAK_COD)
		cMens := "Exclusão da Carga com sucesso, Filial: "+Carga:Cabecalho:Filial+", Carga: "+Carga:Cabecalho:Ordem_Embarque
		//EndIf
	EndIf

	aRet := {}
	aAdd(aRet,lProcessa)
	aAdd(aRet,cMens)

Return(aRet)


// exclui as reservas na exclusao da carga
Static Function ExcReserva(Carga,aRecnoSC9)

	Local nCnt := 0
	Local aRet := {}
	Local lContinua := .T.
	Local aArea := {SC9->(GetArea()),GetArea()}
	Local cMens := ""

	For nCnt:=1 To Len(aRecnoSC9)
		SC9->(dbGoto(aRecnoSC9[nCnt]))
		If SC9->(Recno()) == aRecnoSC9[nCnt]
			aRet := EstornaSC9(SC9->C9_PEDIDO,SC9->C9_ITEM,"",Carga)
			lContinua := aRet[1]

			If !lContinua
				//cMens := "Problemas no estorno da liberação do pedido, Filial: "+Carga:Cabecalho:Filial+", Carga: "+Carga:Cabecalho:Ordem_Embarque+", Pedido: "+SC9->C9_PEDIDO+", Item: "+SC9->C9_ITEM
				//Conout(cMens)
				Exit
			Endif	
		Endif		
	Next

	aRet := {}		
	aAdd(aRet,lContinua)
	aAdd(aRet,cMens)

	aEval(aArea,{|x| RestArea(x)})	

Return(aRet)


// valida os campos obrigatorios
Static Function VldObrCampos(Carga)

	Local nCnt := 0
	Local bBlock := {|x| Empty(x)}
	Local aRet := {}
	Local lContinua := .T.
	Local cCampo := ""
	Local cMens := ""
	Local cAcao := Carga:Cabecalho:Acao
	Local aDados := {}
	Local lLote := .F.

	SB1->(dbSetOrder(1))

	If Eval(bBlock,Carga:Cabecalho:Acao)
		lContinua := .F.
		cCampo := "Acao"
	Endif

	If lContinua
		If Eval(bBlock,Carga:Cabecalho:Filial)
			lContinua := .F.
			cCampo := "Filial"
		Endif
	Endif	

	If lContinua
		If Eval(bBlock,Carga:Cabecalho:Ordem_Embarque)
			lContinua := .F.
			cCampo := "Ordem_Embarque"
		Endif
	Endif	

	If cAcao != "3" // se nao for exclusao
		If lContinua
			If Eval(bBlock,Carga:Cabecalho:Caminhao)
				lContinua := .F.
				cCampo := "Caminhao"
			Endif
		Endif	

		If lContinua
			If Eval(bBlock,Carga:Cabecalho:Motorista)
				lContinua := .F.
				cCampo := "Motorista"
			Endif
		Endif	

		If lContinua
			If Eval(bBlock,Carga:Cabecalho:Transportadora) .and. Eval(bBlock,Carga:Cabecalho:NumeroExportacao)
				lContinua := .F.
				cCampo := "Transportadora"
			Endif
		Endif	

		If lContinua
			For nCnt:=1 To Len(Carga:Itens)
				If Eval(bBlock,Carga:Itens[nCnt]:Filial)
					lContinua := .F.
					cCampo := "Filial - Item: "+Alltrim(Str(nCnt))
					Exit
				Endif	

				If lContinua
					If Eval(bBlock,Carga:Itens[nCnt]:Ordem_Embarque)
						lContinua := .F.
						cCampo := "Ordem_Embarque - Item: "+Alltrim(Str(nCnt))
						Exit
					Endif	
				Endif	

				If lContinua
					If Eval(bBlock,Carga:Itens[nCnt]:Pedido)
						lContinua := .F.
						cCampo := "Pedido - Item: "+Alltrim(Str(nCnt))
						Exit
					Endif	
				Endif	

				If lContinua
					If Eval(bBlock,Carga:Itens[nCnt]:Item_Ped)
						lContinua := .F.
						cCampo := "Item_Ped - Item: "+Alltrim(Str(nCnt))
						Exit
					Endif	
				Endif	

				If lContinua
					If Eval(bBlock,Carga:Itens[nCnt]:Qtd_Lib)
						lContinua := .F.
						cCampo := "Qtd_Lib - Item: "+Alltrim(Str(nCnt))
						Exit
					Endif	
				Endif	

				If lContinua
					aDados := DadosSC6(Carga:Itens[nCnt]:Pedido,,.F.,Carga:Itens[nCnt]:Item_Ped)
					If Len(aDados) > 0
						If SB1->(dbSeek(xFilial("SB1")+aDados[1]))
							If SB1->B1_RASTRO == "L"
								lLote := .T.
							Else	
								lLote := .F.
							Endif	
							If lLote
								If Eval(bBlock,Carga:Itens[nCnt]:Lote)
									lContinua := .F.
									cCampo := "Lote - Item: "+Alltrim(Str(nCnt))
									Exit
								Endif	
							Endif	
						Endif
					Endif
				Endif			

				If lContinua
					If Eval(bBlock,Carga:Itens[nCnt]:Peso)
						lContinua := .F.
						cCampo := "Peso - Item: "+Alltrim(Str(nCnt))
						Exit
					Endif	
				Endif	

				If lContinua
					If Eval(bBlock,Carga:Itens[nCnt]:Peso_Bruto)
						lContinua := .F.
						cCampo := "Peso_Bruto - Item: "+Alltrim(Str(nCnt))
						Exit
					Endif	
				Endif	
			Next
		Endif
	Endif

	If !lContinua
		cMens := "Campo obrigatório não enviado, Filial: "+Carga:Cabecalho:Filial+", Carga: "+Carga:Cabecalho:Ordem_Embarque+", Campo: "+cCampo
	Endif	
	aRet := {}
	aAdd(aRet,lContinua)
	aAdd(aRet,cMens)

Return(aRet)				


// gravacao de campos nas tabelas de carga
Static Function GrvCabCampos(Carga)

	Local aArea := {SC5->(GetArea()),DAI->(GetArea()),GetArea()}
	Local cQ   :="" //adicionado Rafael 20/05/2019
	local lAchou:= .f. //adicionado Rafael 20/05/2019
	Local nCnt := 0
	Local aPV := {}
	Local nPeso := 0
	Local nCapVol := 0
	Local nVlrCarga := 0 // variavel usada para calcular o valor da carga, pois no padrao, os registros deletados do SC9 estao sendo somados indevidamente para compor o valor da carga
	Local nTamPed := TamSX3("C6_NUM")[1]

	DAI->(dbSetOrder(4))
	SC5->(dbSetOrder(1))

	// tratamento para os campos de peso e volumes, que nao estao sendo gravados pela rotina padrao
	For nCnt:=1 To Len(Carga:Itens)
		If (nPos:=aScan(aPV,{|x| Alltrim(x[1])==Alltrim(Carga:Itens[nCnt]:Pedido)})) == 0
			//aAdd(aPV,{Carga:Itens[nCnt]:Pedido,Carga:Itens[nCnt]:Peso,Carga:Itens[nCnt]:CapVol})
			aAdd(aPV,{Carga:Itens[nCnt]:Pedido,Carga:Itens[nCnt]:Peso,Carga:Itens[nCnt]:Peso_Bruto})		
		Else
			aPV[nPos][2] += Carga:Itens[nCnt]:Peso	
			aPV[nPos][3] += Carga:Itens[nCnt]:Peso_Bruto
			//aPV[nPos][3] += Carga:Itens[nCnt]:CapVol
		Endif
		nPeso += Carga:Itens[nCnt]:Peso_Bruto
		//nCapVol += Carga:Itens[nCnt]:CapVol 		
	Next

	For nCnt:=1 To Len(aPV)		
		If DAI->(dbseek(xFilial("DAI")+Padr(aPV[nCnt][1],nTamPed)+DAK->DAK_COD))
			DAI->(RecLock("DAI",.F.))
			//If Empty(DAI->DAI_PESO)
			DAI->DAI_PESO := aPV[nCnt][3]
			//Endif	
			//If Empty(DAI->DAI_CAPVOL)
			//DAI->DAI_CAPVOL := aPV[nCnt][3]
			//Endif
			If Empty(DAI->DAI_DTCHEG)
				DAI->DAI_DTCHEG := dDataBase
			Endif	
			If Empty(DAI->DAI_CHEGAD)
				DAI->DAI_CHEGAD := Time()
			Endif	
			If Empty(DAI->DAI_TMSERV)
				DAI->DAI_TMSERV := "0000:00"
			Endif	
			If Empty(DAI->DAI_DTSAID)
				DAI->DAI_DTSAID := dDataBase
			Endif	
			DAI->(MsUnLock())
		Endif
		If SC5->(dbseek(xFilial("SC5")+Padr(aPV[nCnt][1],nTamPed)))
			SC5->(RecLock("SC5",.F.))
			SC5->C5_PESOL := aPV[nCnt][2]
			SC5->C5_PBRUTO := aPV[nCnt][3]
			SC5->(MsUnLock())
		Endif	
	Next		 

	nVlrCarga := RecnoSC9(DAK->DAK_COD,.T.)[2]

	// campos do cabecalho da carga				
	DAK->(RecLock("DAK",.F.))
	If DAK->(FieldPos("DAK_ZDISTA")) > 0
		DAK->DAK_ZDISTA := Carga:Cabecalho:Distancia
	Endif
	//inicio alteração Rafael 20/05/2019 para inclusão dos campos processo CTE Multiembarcador
	DAK->DAK_XOEREF := ALLTRIM(Carga:Cabecalho:OEReferencia)
	if  ALLTRIM(Carga:Cabecalho:Cavalo)<>''
		cQ :="SELECT DA3_COD FROM "+retSQLName("DA3")
		cQ +=" WHERE D_E_L_E_T_<>'*' AND DA3_PLACA='"+ ALLTRIM(Carga:Cabecalho:Cavalo)+"'"
		IF SELECT("QRYDA3") > 0
			QRYDA3->( dbCloseArea() )
		ENDIF   		
		TcQuery changeQuery(cQ) New Alias "QRYDA3"
		IF QRYDA3->(EOF())
			CONOUT := "Caminhão não cadastrado, Filial: "+Carga:Cabecalho:Filial+", Carga: "+Carga:Cabecalho:Ordem_Embarque+", Placa Caminhão: "+Carga:Cabecalho:Cavalo	
		else
			DAK->DAK_XCAVAL:=QRYDA3->DA3_COD
		ENDIF
		IF SELECT("QRYDA3") > 0
			QRYDA3->( dbCloseArea() )
		ENDIF
	ENDIF	   				
	if  ALLTRIM(Carga:Cabecalho:Caminhao2)<>''
		cQ :="SELECT DA3_COD FROM "+retSQLName("DA3")
		cQ +=" WHERE D_E_L_E_T_<>'*' AND DA3_PLACA='"+ ALLTRIM(Carga:Cabecalho:Caminhao2)+"'"
		IF SELECT("QRYDA3") > 0
			QRYDA3->( dbCloseArea() )
		ENDIF   		
		TcQuery changeQuery(cQ) New Alias "QRYDA3"
		IF QRYDA3->(EOF())
			CONOUT := "Caminhao não cadastrado, Filial: "+Carga:Cabecalho:Filial+", Carga: "+Carga:Cabecalho:Ordem_Embarque+", Placa Caminhao: "+Carga:Cabecalho:Caminhao2	
		else
			DAK->DAK_XCAMI2:=QRYDA3->DA3_COD
		ENDIF
		IF SELECT("QRYDA3") > 0
			QRYDA3->( dbCloseArea() )
		ENDIF
	ENDIF	
	if  ALLTRIM(Carga:Cabecalho:Caminhao3)<>''
		cQ :="SELECT DA3_COD FROM "+retSQLName("DA3")
		cQ +=" WHERE D_E_L_E_T_<>'*' AND DA3_PLACA='"+ ALLTRIM(Carga:Cabecalho:Caminhao3)+"'"
		IF SELECT("QRYDA3") > 0
			QRYDA3->( dbCloseArea() )
		ENDIF   		
		TcQuery changeQuery(cQ) New Alias "QRYDA3"
		IF QRYDA3->(EOF())
			CONOUT := "Caminhao não cadastrado, Filial: "+Carga:Cabecalho:Filial+", Carga: "+Carga:Cabecalho:Ordem_Embarque+", Placa Caminhao: "+Carga:Cabecalho:Caminhao3	
		else
			DAK->DAK_XCAMI3:=QRYDA3->DA3_COD
		ENDIF
		IF SELECT("QRYDA3") > 0
			QRYDA3->( dbCloseArea() )
		ENDIF
	ENDIF	   			

	lAchou:= .f.
	if ALLTRIM(Carga:Cabecalho:CodIntPortodeColeta)<>""
		cQ :=" SELECT A2_COD,A2_LOJA,A2_CGC,A2_NOME,A2_COD_MUN,A2_MUN,A2_EST " +CRLF
		cQ +=" FROM "+retSQLName("SA2")					+CRLF
		cQ +=" WHERE D_E_L_E_T_<>'*' AND A2_FILIAL='"+XFILIAL("SA2")+"'AND A2_ZCODMGF ='"+substr(ALLTRIM(Carga:Cabecalho:CodIntPortodeColeta),1,15)+"'" 

		IF SELECT("QRYSA2") > 0
			QRYSA2->( dbCloseArea() )
		ENDIF   

		TcQuery changeQuery(cQ) New Alias "QRYSA2"

		IF QRYSA2->(EOF())

			cQ :=" SELECT A2_COD,A2_LOJA,A2_CGC,A2_NOME,A2_COD_MUN,A2_MUN,A2_EST " +CRLF
			cQ +=" FROM "+retSQLName("SA2")					+CRLF
			cQ +=" WHERE D_E_L_E_T_<>'*' AND  A2_FILIAL='"+XFILIAL("SA2")+"'AND A2_COD||A2_LOJA ='"+ALLTRIM(Carga:Cabecalho:CodIntPortodeColeta)+"'" 

			IF SELECT("QRYSA2") > 0
				QRYSA2->( dbCloseArea() )
			ENDIF   

			TcQuery changeQuery(cQ) New Alias "QRYSA2"

			IF !QRYSA2->(EOF())
				lAchou:= .t.
			endif	
		ELSE 
			lAchou:= .t.
		endif	
		if lAchou
			DAK->DAK_XCODO	:= QRYSA2->A2_COD
			DAK->DAK_XLOJO	:= QRYSA2->A2_LOJA			
			DAK->DAK_XCNPJO := QRYSA2->A2_CGC
			DAK->DAK_XRAZO 	:= QRYSA2->A2_NOME
			DAK->DAK_XCIDO 	:= QRYSA2->A2_COD_MUN
			DAK->DAK_XDCIDO := QRYSA2->A2_MUN
			DAK->DAK_XUFO	:= QRYSA2->A2_EST
		ENDIF
	endif
	lAchou:= .f.
	IF ALLTRIM(Carga:Cabecalho:CodIntOrigemTN)<>""
		cQ :=" SELECT A2_COD,A2_LOJA,A2_CGC,A2_NOME,A2_COD_MUN,A2_MUN,A2_EST " +CRLF
		cQ +=" FROM "+retSQLName("SA2")				+CRLF
		cQ +=" WHERE D_E_L_E_T_<>'*' AND A2_FILIAL='"+XFILIAL("SA2")+"'AND A2_ZCODMGF ='"+substr(ALLTRIM(Carga:Cabecalho:CodIntOrigemTN),1,15)+"'" 

		IF SELECT("QRYSA2") > 0
			QRYSA2->( dbCloseArea() )
		ENDIF   

		TcQuery changeQuery(cQ) New Alias "QRYSA2"

		IF QRYSA2->(EOF())

			cQ :=" SELECT A2_COD,A2_LOJA,A2_CGC,A2_NOME,A2_COD_MUN,A2_MUN,A2_EST " +CRLF
			cQ +=" FROM "+retSQLName("SA2")				+CRLF
			cQ +=" WHERE D_E_L_E_T_<>'*' AND  A2_FILIAL='"+XFILIAL("SA2")+"'AND A2_COD||A2_LOJA ='"+ALLTRIM(Carga:Cabecalho:CodIntOrigemTN)+"'" 

			IF SELECT("QRYSA2") > 0
				QRYSA2->( dbCloseArea() )
			ENDIF  

			TcQuery changeQuery(cQ) New Alias "QRYSA2" 

			IF !QRYSA2->(EOF())
				lAchou:= .t.
			endif	
		ELSE 
			lAchou:= .t.
		endif	
		if lAchou
			DAK->DAK_XCODD	:= QRYSA2->A2_COD
			DAK->DAK_XLOJD	:= QRYSA2->A2_LOJA		
			DAK->DAK_XCNPJD := QRYSA2->A2_CGC
			DAK->DAK_XRAZD 	:= QRYSA2->A2_NOME
			DAK->DAK_XCIDD 	:= QRYSA2->A2_COD_MUN
			DAK->DAK_XDCIDD := QRYSA2->A2_MUN
			DAK->DAK_XUFD	:= QRYSA2->A2_EST
		ENDIF
	ENDIF
	lAchou:= .f.
	IF ALLTRIM(Carga:Cabecalho:CodIntRecebedor)<>"" 
		cQ :=" SELECT A2_COD,A2_LOJA,A2_CGC,A2_NOME,A2_COD_MUN,A2_MUN,A2_EST " +CRLF
		cQ +=" FROM "+retSQLName("SA2")				+CRLF
		cQ +=" WHERE D_E_L_E_T_<>'*' AND A2_FILIAL='"+XFILIAL("SA2")+"'AND A2_ZCODMGF ='"+substr(ALLTRIM(Carga:Cabecalho:CodIntRecebedor),1,15)+"'" 

		IF SELECT("QRYSA2") > 0
			QRYSA2->( dbCloseArea() )
		ENDIF   

		TcQuery changeQuery(cQ) New Alias "QRYSA2"

		IF QRYSA2->(EOF())

			cQ :=" SELECT A2_COD,A2_LOJA,A2_CGC,A2_NOME,A2_COD_MUN,A2_MUN,A2_EST " +CRLF
			cQ +=" FROM "+retSQLName("SA2")				+CRLF
			cQ +=" WHERE D_E_L_E_T_<>'*' AND  A2_FILIAL='"+XFILIAL("SA2")+"'AND A2_COD||A2_LOJA ='"+ALLTRIM(Carga:Cabecalho:CodIntRecebedor)+"'" 

			IF SELECT("QRYSA2") > 0
				QRYSA2->( dbCloseArea() )
			ENDIF   

			TcQuery changeQuery(cQ) New Alias "QRYSA2"

			IF !QRYSA2->(EOF())
				lAchou:= .t.
			endif	
		ELSE 
			lAchou:= .t.
		endif	
		if lAchou
			DAK->DAK_XCODR	:= QRYSA2->A2_COD
			DAK->DAK_XLOJR	:= QRYSA2->A2_LOJA		
			DAK->DAK_XCNPJR := QRYSA2->A2_CGC
			DAK->DAK_XRAZR  := QRYSA2->A2_NOME
			DAK->DAK_XCIDR  := QRYSA2->A2_COD_MUN
			DAK->DAK_XDCIDR := QRYSA2->A2_MUN
			DAK->DAK_XUFR   := QRYSA2->A2_EST
		ENDIF	
	ENDIF

	lAchou:= .f.
	IF ALLTRIM(Carga:Cabecalho:CodIntExpedidor)<>""
		cQ :=" SELECT A2_COD,A2_LOJA,A2_CGC,A2_NOME,A2_COD_MUN,A2_MUN,A2_EST " +CRLF
		cQ +=" FROM "+retSQLName("SA2")				+CRLF
		cQ +=" WHERE D_E_L_E_T_<>'*' AND A2_FILIAL='"+XFILIAL("SA2")+"'AND A2_ZCODMGF ='"+substr(ALLTRIM(Carga:Cabecalho:CodIntExpedidor),1,15)+"'" 

		IF SELECT("QRYSA2") > 0
			QRYSA2->( dbCloseArea() )
		ENDIF   

		TcQuery changeQuery(cQ) New Alias "QRYSA2"

		IF QRYSA2->(EOF())

			cQ :=" SELECT A2_COD,A2_LOJA,A2_CGC,A2_NOME,A2_COD_MUN,A2_MUN,A2_EST " +CRLF
			cQ +=" FROM "+retSQLName("SA2")					+CRLF
			cQ +=" WHERE D_E_L_E_T_<>'*' AND  A2_FILIAL='"+XFILIAL("SA2")+"'AND A2_COD||A2_LOJA ='"+ALLTRIM(Carga:Cabecalho:CodIntExpedidor)+"'" 

			IF SELECT("QRYSA2") > 0
				QRYSA2->( dbCloseArea() )
			ENDIF   

			TcQuery changeQuery(cQ) New Alias "QRYSA2"

			IF !QRYSA2->(EOF())
				lAchou:= .t.
			endif	
		ELSE 
			lAchou:= .t.
		endif	
		if lAchou
			DAK->DAK_XCODE	:= QRYSA2->A2_COD
			DAK->DAK_XLOJE	:= QRYSA2->A2_LOJA		
			DAK->DAK_XCNPJE := QRYSA2->A2_CGC
			DAK->DAK_XRAZE  := QRYSA2->A2_NOME
			DAK->DAK_XCIDE  := QRYSA2->A2_COD_MUN
			DAK->DAK_XDCIDE := QRYSA2->A2_MUN
			DAK->DAK_XUFE   := QRYSA2->A2_EST
		ENDIF	
	ENDIF  
	lAchou:= .f.
	IF ALLTRIM(Carga:Cabecalho:CodIntCrossDocking)<>""
		cQ :=" SELECT A2_COD,A2_LOJA,A2_CGC,A2_NOME,A2_COD_MUN,A2_MUN,A2_EST " +CRLF
		cQ +=" FROM "+retSQLName("SA2")				+CRLF
		cQ +=" WHERE D_E_L_E_T_<>'*' AND A2_FILIAL='"+XFILIAL("SA2")+"'AND A2_ZCODMGF ='"+substr(ALLTRIM(Carga:Cabecalho:CodIntCrossDocking),1,15)+"'" 

		IF SELECT("QRYSA2") > 0
			QRYSA2->( dbCloseArea() )
		ENDIF   

		TcQuery changeQuery(cQ) New Alias "QRYSA2"

		IF QRYSA2->(EOF())

			cQ :=" SELECT A2_COD,A2_LOJA,A2_CGC,A2_NOME,A2_COD_MUN,A2_MUN,A2_EST " +CRLF
			cQ +=" FROM "+retSQLName("SA2")					+CRLF
			cQ +=" WHERE D_E_L_E_T_<>'*' AND  A2_FILIAL='"+XFILIAL("SA2")+"'AND A2_COD||A2_LOJA ='"+ALLTRIM(Carga:Cabecalho:CodIntCrossDocking)+"'" 

			IF SELECT("QRYSA2") > 0
				QRYSA2->( dbCloseArea() )
			ENDIF   

			TcQuery changeQuery(cQ) New Alias "QRYSA2"

			IF !QRYSA2->(EOF())
				lAchou:= .t.
			endif	
		ELSE 
			lAchou:= .t.
		endif	
		if lAchou
			DAK->DAK_XCODC	:= QRYSA2->A2_COD
			DAK->DAK_XLOJC	:= QRYSA2->A2_LOJA		
			DAK->DAK_XCNPJC := QRYSA2->A2_CGC
			DAK->DAK_XRAZC  := QRYSA2->A2_NOME
			DAK->DAK_XCIDC  := QRYSA2->A2_COD_MUN
			DAK->DAK_XDCIDC := QRYSA2->A2_MUN
			DAK->DAK_XUFC   := QRYSA2->A2_EST
		ENDIF	
	ENDIF  
	IF SELECT("QRYSA2") > 0
		QRYSA2->( dbCloseArea() )
	ENDIF 

	//fim alteração Rafael 20/05/2019]
	//>>> inicio alteração heraldo 26/12/2019
	lAchou:= .f.
	IF ALLTRIM(Carga:Cabecalho:CodIntCrossDocking)<>""
		cQ :=" SELECT A2_COD,A2_LOJA,A2_CGC,A2_NOME,A2_COD_MUN,A2_MUN,A2_EST " +CRLF
		cQ +=" FROM "+retSQLName("SA2")				+CRLF
		cQ +=" WHERE D_E_L_E_T_<>'*' AND A2_FILIAL='"+XFILIAL("SA2")+"'AND A2_ZCODMGF ='"+substr(ALLTRIM(Carga:Cabecalho:CodIntCrossDocking),1,15)+"'" 

		IF SELECT("QRYSA2") > 0
			QRYSA2->( dbCloseArea() )
		ENDIF   

		TcQuery changeQuery(cQ) New Alias "QRYSA2"

		IF QRYSA2->(EOF())

			cQ :=" SELECT A2_COD,A2_LOJA,A2_CGC,A2_NOME,A2_COD_MUN,A2_MUN,A2_EST " +CRLF
			cQ +=" FROM "+retSQLName("SA2")					+CRLF
			cQ +=" WHERE D_E_L_E_T_<>'*' AND  A2_FILIAL='"+XFILIAL("SA2")+"'AND A2_COD||A2_LOJA ='"+ALLTRIM(Carga:Cabecalho:CodIntCrossDocking)+"'" 

			IF SELECT("QRYSA2") > 0
				QRYSA2->( dbCloseArea() )
			ENDIF   

			TcQuery changeQuery(cQ) New Alias "QRYSA2"

			IF !QRYSA2->(EOF())
				lAchou:= .t.
			endif	
		ELSE 
			lAchou:= .t.
		endif	
		if lAchou
			DAK->DAK_XCODC	:= QRYSA2->A2_COD
			DAK->DAK_XLOJC	:= QRYSA2->A2_LOJA		
			DAK->DAK_XCNPJC := QRYSA2->A2_CGC
			DAK->DAK_XRAZC  := QRYSA2->A2_NOME
			DAK->DAK_XCIDC  := QRYSA2->A2_COD_MUN
			DAK->DAK_XDCIDC := QRYSA2->A2_MUN
			DAK->DAK_XUFC   := QRYSA2->A2_EST
		ENDIF	
	ENDIF  
	IF SELECT("QRYSA2") > 0
		QRYSA2->( dbCloseArea() )
	ENDIF 
//>>> FIM ALTERAÇÃO HERALDO
	DAK->DAK_PESO := nPeso 
	DAK->DAK_CAPVOL := nCapVol
	DAK->DAK_VALOR := nVlrCarga
	If Empty(DAK->DAK_ROTEIR)
		DAK->DAK_ROTEIR := GetMv("MGF_ROTA",,"999999")
	Endif	
	DAK->(MsUnLock()) 

	aEval(aArea,{|x| RestArea(x)})	

Return()


// rotina de extracao de dados do SC9
Static Function RecnoSC9(cCarga,lInclusao,lExcSif,cSerie,cNota,lAltQtd)

	Local aArea := {GetArea()}
	Local cQ := ""
	Local aRet := {}
	Local cAliasTrb := GetNextAlias()
	Local nVlrCarga := 0 // variavel usada para calcular o valor da carga, pois no padrao, os registros deletados do SC9 estao sendo somados indevidamente para compor o valor da carga
	Local aAlter := {}
	Local nPos := 0 
	Local aPV := {}
	Local nCnt := 0

	Default cSerie := ""
	Default cNota := ""
	Default lExcSif := .F. 
	Default lAltQtd := .F.

	cQ := "SELECT SC9.R_E_C_N_O_ SC9_RECNO,C9_QTDLIB,C9_PRCVEN,C9_PEDIDO,C9_ITEM,C9_LOTECTL "
	cQ += "FROM "+RetSqlName("SC9")+" SC9 "
	cQ += "WHERE "
	cQ += "C9_FILIAL = '"+xFilial("SC9")+"' "
	cQ += "AND C9_CARGA = '"+Padr(cCarga,TamSX3("C9_CARGA")[1])+"' "
	If lInclusao
		cQ += "AND C9_BLCRED = '"+Space(Len("C9_BLCRED"))+"' "
		cQ += "AND C9_BLEST = '"+Space(Len("C9_BLEST"))+"' "	
	Endif	
	If !Empty(cNota)
		cQ += "AND C9_SERIENF = '"+cSerie+"' "	
		cQ += "AND C9_NFISCAL = '"+cNota+"' "	
	Endif	
	cQ += "AND SC9.D_E_L_E_T_ <> '*' "

	cQ := ChangeQuery(cQ)
	//MemoWrite("mgftas02_4.sql",cQ)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),cAliasTrb,.T.,.T.)

	tcSetField(cAliasTrb,"C9_QTDLIB",'N',TamSx3("C9_QTDLIB")[1],TamSx3("C9_QTDLIB")[2])
	tcSetField(cAliasTrb,"C9_PRCVEN",'N',TamSx3("C9_PRCVEN")[1],TamSx3("C9_PRCVEN")[2])

	While (cAliasTrb)->(!Eof())
		aAdd(aRet,(cAliasTrb)->SC9_RECNO)
		nVlrCarga += A410Arred((cAliasTrb)->C9_QTDLIB*(cAliasTrb)->C9_PRCVEN,"DAK_VALOR")
		If (nPos:=aScan(aAlter,{|x| x[1]+x[2]+x[3]==(cAliasTrb)->C9_PEDIDO+(cAliasTrb)->C9_ITEM+(cAliasTrb)->C9_LOTECTL})) == 0
			aAdd(aAlter,{(cAliasTrb)->C9_PEDIDO,(cAliasTrb)->C9_ITEM,(cAliasTrb)->C9_LOTECTL,(cAliasTrb)->C9_QTDLIB,(cAliasTrb)->SC9_RECNO})
		Else
			aAlter[nPos][4] += (cAliasTrb)->C9_QTDLIB
		Endif	
		If aScan(aPV,{|x| x[1]+x[2]==(cAliasTrb)->C9_PEDIDO+(cAliasTrb)->C9_ITEM}) == 0
			aAdd(aPV,{(cAliasTrb)->C9_PEDIDO,(cAliasTrb)->C9_ITEM,.F.,.F.})
		Endif	
		(cAliasTrb)->(dbSkip())
	Enddo

	(cAliasTrb)->(dbCloseArea()) 

	If lExcSif
		// ordena por pedido+item
		aSort(aPV,,,{|x,y| x[1]+x[2] < y[1]+y[2]})

		nCnt := 1
		While .T.
			If nCnt > Len(aPV)
				Exit
			Endif	
			cPV := aPV[nCnt][1]
			PVSif(aPV[nCnt][1],@aPV)
			While cPV == aPV[nCnt][1]
				nCnt++
				If nCnt > Len(aPV)
					Exit
				Endif	
			Enddo	
		Enddo
	Endif

	If lAltQtd
		// ordena por pedido+item
		aSort(aPV,,,{|x,y| x[1]+x[2] < y[1]+y[2]})

		nCnt := 1
		While .T.
			If nCnt > Len(aPV)
				Exit
			Endif	
			cPV := aPV[nCnt][1]
			PVAltQtd(aPV[nCnt][1],@aPV)
			While cPV == aPV[nCnt][1]
				nCnt++
				If nCnt > Len(aPV)
					Exit
				Endif	
			Enddo	
		Enddo
	Endif

	If GetMv("MGF_OEDEL",,.F.)
		If lExcSif .and. lAltQtd // tratamento para verificar se teve exclusao de itens no pedido de exportacao
			// ordena por pedido+item
			aSort(aPV,,,{|x,y| x[1]+x[2] < y[1]+y[2]})

			nCnt := 1
			While .T.
				If nCnt > Len(aPV)
					Exit
				Endif	
				If aPV[nCnt][3] // jah foi flegado anteriormente para ser processado na exclusao do pedido
					nCnt++
					Loop
				Endif	
				cPV := aPV[nCnt][1]
				PVExcEEC(aPV[nCnt][1],@aPV,aPV[nCnt][2])
				While cPV == aPV[nCnt][1]
					nCnt++
					If nCnt > Len(aPV)
						Exit
					Endif	
				Enddo	
			Enddo
		Endif
	Endif

	aEval(aArea,{|x| RestArea(x)})	

Return({aRet,nVlrCarga,aAlter,aPV})


// rotina para verificar se o pedido teve item incluido, devido ao sif diferente para o mesmo item de pedido
Static Function PVSif(cPedido,aPV)

	Local aArea := {GetArea()}
	Local cQ := ""
	Local cAliasTrb := GetNextAlias()
	Local nPos := 0

	cQ := "SELECT C6_NUM,C6_ITEM "
	cQ += "FROM "+RetSqlName("SC6")+" SC6 "
	cQ += "WHERE "
	cQ += "C6_FILIAL = '"+xFilial("SC6")+"' "
	cQ += "AND C6_NUM = '"+cPedido+"' "
	//cQ += "AND (C6_ZQTDSIF > 0 OR C6_ZGERSIF = 'S') " // itens que tiveram quantidade alterada ou que foram incluidos pelo sif diferente para o mesmo pedido+item
	//cQ += "AND (C6_ZGERSIF = 'S' OR C6_ZTESSIF <> ' ') " // itens que foram incluidos pelo sif diferente para o mesmo pedido+item
	cQ += "AND C6_ZGERSIF = 'S' " // itens que foram incluidos pelo sif diferente para o mesmo pedido+item
	cQ += "AND SC6.D_E_L_E_T_ <> '*' "
	cQ += "UNION " // union para nao usar OR na query, tentando melhorar a performance
	cQ += "SELECT C6_NUM,C6_ITEM "
	cQ += "FROM "+RetSqlName("SC6")+" SC6 "
	cQ += "WHERE "
	cQ += "C6_FILIAL = '"+xFilial("SC6")+"' "
	cQ += "AND C6_NUM = '"+cPedido+"' "
	//cQ += "AND (C6_ZQTDSIF > 0 OR C6_ZGERSIF = 'S') " // itens que tiveram quantidade alterada ou que foram incluidos pelo sif diferente para o mesmo pedido+item
	//cQ += "AND (C6_ZGERSIF = 'S' OR C6_ZTESSIF <> ' ') " // itens que foram incluidos pelo sif diferente para o mesmo pedido+item
	cQ += "AND C6_ZTESSIF <> ' ' " // itens que foram incluidos pelo sif diferente para o mesmo pedido+item
	cQ += "AND SC6.D_E_L_E_T_ <> '*' "

	cQ := ChangeQuery(cQ)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),cAliasTrb,.T.,.T.)

	While (cAliasTrb)->(!Eof())
		If (nPos:=aScan(aPV,{|x| x[1]+x[2]==(cAliasTrb)->C6_NUM+(cAliasTrb)->C6_ITEM})) > 0
			aPV[nPos][3] := .T.
		Endif	
		(cAliasTrb)->(dbSkip())
	Enddo

	(cAliasTrb)->(dbCloseArea()) 

	aEval(aArea,{|x| RestArea(x)})	

Return()


// rotina para verificar se o pedido teve a quantidade alterada
Static Function PVAltQtd(cPedido,aPV)

	Local aArea := {GetArea()}
	Local cQ := ""
	Local cAliasTrb := GetNextAlias()
	Local nPos := 0

	cQ := "SELECT C6_NUM,C6_ITEM "
	cQ += "FROM "+RetSqlName("SC6")+" SC6 "
	cQ += "WHERE "
	cQ += "C6_FILIAL = '"+xFilial("SC6")+"' "
	cQ += "AND C6_NUM = '"+cPedido+"' "
	cQ += "AND C6_ZQTDHIS <> 0 " // campo que indica se teve quantidade original alterada
	cQ += "AND SC6.D_E_L_E_T_ <> '*' "

	cQ := ChangeQuery(cQ)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),cAliasTrb,.T.,.T.)

	While (cAliasTrb)->(!Eof())
		If (nPos:=aScan(aPV,{|x| x[1]+x[2]==(cAliasTrb)->C6_NUM+(cAliasTrb)->C6_ITEM})) > 0
			aPV[nPos][3] := .T.
		Endif	
		(cAliasTrb)->(dbSkip())
	Enddo

	(cAliasTrb)->(dbCloseArea()) 

	aEval(aArea,{|x| RestArea(x)})	

Return()


// rotina para verificar se o pedido de exportacao teve itens excluidos durante a inclusao da carga
Static Function PVExcEEC(cPedido,aPV,cItem)

	Local aArea := {GetArea()}
	Local cQ := ""
	Local cAliasTrb := GetNextAlias()
	Local nPos := 0

	cQ := "SELECT C5_FILIAL,C5_NUM,C5_PEDEXP "
	cQ += "FROM "+RetSqlName("SC5")+" SC5 "
	cQ += "WHERE "
	cQ += "C5_FILIAL = '"+xFilial("SC5")+"' "
	cQ += "AND C5_NUM = '"+cPedido+"' "
	cQ += "AND C5_PEDEXP <> ' ' " // somente pedido de exportacao
	cQ += "AND SC5.D_E_L_E_T_ <> '*' "

	cQ := ChangeQuery(cQ)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),cAliasTrb,.T.,.T.)

	While (cAliasTrb)->(!Eof())
		If Len(RegExcPedExp((cAliasTrb)->C5_FILIAL,(cAliasTrb)->C5_PEDEXP)) > 0
			If (nPos:=aScan(aPV,{|x| x[1]+x[2]==(cAliasTrb)->C5_NUM+cItem})) > 0
				aPV[nPos][3] := .T.
			Endif	
		Endif	
		(cAliasTrb)->(dbSkip())
	Enddo

	(cAliasTrb)->(dbCloseArea()) 

	aEval(aArea,{|x| RestArea(x)})	

Return()


// verifica se a carga jah existe
Static Function ExisteCarga(Carga)

	Local aRet := {}
	Local lContinua := .T.
	Local cMens := ""

	DAK->(dbSetOrder(1))
	If DAK->(dbSeek(xFilial("DAK")+Padr(Carga:Cabecalho:Ordem_Embarque,TamSX3("DAK_COD")[1])))
		lContinua := .F.
		cMens := "Carga já existe, Filial: "+Carga:Cabecalho:Filial+", Carga: "+Carga:Cabecalho:Ordem_Embarque
	Endif	

	aRet := {}
	aAdd(aRet,lContinua)
	aAdd(aRet,cMens)

Return(aRet)				


// valida campos do cabecalho da carga
Static Function VldCabCampos(Carga,aCabCargaERP)

	Local aRet := {}
	Local lContinua := .T.
	Local cMens := ""
	Local aProcura := {}

	DA3->(dbSetOrder(3))
	DA4->(dbSetOrder(1))
	SA4->(dbSetOrder(3))

	If !Empty(Carga:Cabecalho:Caminhao) .and. !PesqPlaca(Carga) //DA3->(!dbSeek(xFilial("DA3")+Padr(Carga:Cabecalho:Caminhao,TamSX3("DA3_PLACA")[1])))
		lContinua := .F.
		cMens := "Caminhão não cadastrado, Filial: "+Carga:Cabecalho:Filial+", Carga: "+Carga:Cabecalho:Ordem_Embarque+", Placa Caminhão: "+Carga:Cabecalho:Caminhao
	Else
		aAdd(aCabCargaERP,DA3->DA3_COD)
	Endif

	If lContinua
		If !Empty(Carga:Cabecalho:Motorista) .and. DA4->(!dbSeek(xFilial("DA4")+Padr(Carga:Cabecalho:Motorista,TamSX3("DA4_COD")[1])))
			lContinua := .F.
			//cMens := "Motorista não cadastrado, Filial: "+Carga:Cabecalho:Filial+", Carga: "+Carga:Cabecalho:Ordem_Embarque+", CPF Motorista: "+Carga:Cabecalho:Motorista
			cMens := "Motorista não cadastrado, Filial: "+Carga:Cabecalho:Filial+", Carga: "+Carga:Cabecalho:Ordem_Embarque+", Cod. Motorista: "+Carga:Cabecalho:Motorista
		Elseif DA4->(Found())
			aAdd(aCabCargaERP,DA4->DA4_COD)
		Endif
	Endif	

	If lContinua
		If Empty(Carga:Cabecalho:Transportadora) 
			// Procura pelo Codigo Logix 
			aProcura := Proc_CodLogix(Carga:Cabecalho:NumeroExportacao)
			IF !aProcura[1]
				lContinua := .F.
				cMens := "Transportadora não cadastrada, Filial: "+Carga:Cabecalho:Filial+", Carga: "+Carga:Cabecalho:Ordem_Embarque+", Cod. Transportadora: "+Carga:Cabecalho:NumeroExportacao
			Else
				aAdd(aCabCargaERP,aProcura[2])
			Endif
		Else
			If SA4->(!dbSeek(xFilial("SA4")+Padr(Carga:Cabecalho:Transportadora,TamSX3("A4_CGC")[1])))
				lContinua := .F.
				cMens := "Transportadora não cadastrada, Filial: "+Carga:Cabecalho:Filial+", Carga: "+Carga:Cabecalho:Ordem_Embarque+", CNPJ Transportadora: "+Carga:Cabecalho:Transportadora
				//cMens := "Transportadora não cadastrada, Filial: "+Carga:Cabecalho:Filial+", Carga: "+Carga:Cabecalho:Ordem_Embarque+", Cod. Transportadora: "+Carga:Cabecalho:Transportadora		
			Elseif SA4->(Found())
				aAdd(aCabCargaERP,SA4->A4_COD)
			Endif
		EndIF
	Endif	

	aRet := {}
	aAdd(aRet,lContinua)
	aAdd(aRet,cMens)

Return(aRet)


// gravacao da tabela especifica do modulo EEC, GAP EEC09
Static Function GrvTabEEC09(Carga,cTipoOper,aSif)

	Local aArea := {GetArea()}
	Local nCnt := 0
	Local cQ := ""
	Local aCampos := {}
	Local aDados := {}
	Local cItem := "" 
	Local nCntItem := 0                               
	Local cSif := ""
	Local cSifFil := ""
	Local aPedCarga := {}
	Local aPesos := {}
	Local lFis45 := .T.
	Local aPedItem := {}

	Default aSif := {}

	// verifica se deve executar o FIS45
	If !GetMv("MGF_F45EXE",.F.,.T.)
		lFis45 := .F.
	Endif

	If cTipoOper == "1" // inclusao
		If lFis45
			SX6->(dbSetOrder(1))
			If SX6->(dbSeek(cFilAnt+"MGF_SIFFIL")) .and. !Empty(SX6->X6_CONTEUD) // usa dbseek para garantir a pesquisa do parametro por filial
				cSifFil := Alltrim(SX6->X6_CONTEUD)
			Endif	
		Endif	

		For nCnt:=1 To Len(Carga:Itens)
			cItem := ""
			// encontra o item do pedido
			aDados := DadosSC6(Carga:Itens[nCnt]:Pedido,,.F.,Carga:Itens[nCnt]:Item_Ped,,.T.)

			/*
			If Len(aDados) > 0
			For nCntItem:=1 To Len(aDados)
			cItem := aDados[nCntItem][4]
			If !Empty(cItem)
			// caso haja algum registro com a chave primaria da ZZR, deleta
			DelItemZZR(Carga:Cabecalho:Filial,Alltrim(Carga:Itens[nCnt]:Pedido),cItem,Alltrim(Carga:Cabecalho:Ordem_Embarque))
			Endif	
			Next
			Endif		
			*/

			For nCntItem:=1 To Len(aDados)
				cItem := aDados[nCntItem][4]

				// verifica se jah gravou este pedido/item
				//If aScan(aPedItem,{|x| Alltrim(x[1])+Alltrim(x[2])+Alltrim(x[3]) == Alltrim(Carga:Cabecalho:Filial)+Alltrim(Carga:Itens[nCnt]:Pedido)+Alltrim(cItem)}) == 0 
				//    aAdd(aPedItem,{Alltrim(Carga:Cabecalho:Filial),Alltrim(Carga:Itens[nCnt]:Pedido),Alltrim(cItem)})

				If lFis45
					// garantia para nao processar o item em duplicidade
					//If aScan(aPedItem,{|x| Alltrim(x[1])+Alltrim(x[2])+Alltrim(x[3]) == Alltrim(Carga:Cabecalho:Filial)+Alltrim(Carga:Itens[nCnt]:Pedido)+Alltrim(cItem)}) > 0 
					//	Loop
					//Endif	

					// verifica se o sif eh de outra filial ou se o item do pedido foi duplicado pelo sif diferente para o mesmo produto/item
					//cSif := IIf((!Empty(aDados[nCntItem][5]) .or. Posicione("SF4",1,xFilial("SF4")+aDados[nCntItem][3],"F4_ZREVEND")=="1" .or. aDados[nCntItem][6]=="S"),Carga:Itens[nCnt]:Sif_Produto,Alltrim(Subs(cSifFil,1,IIf(At("/",cSifFil)>0,At("/",cSifFil),100))))
					cSif := IIf((!Empty(aDados[nCntItem][5]) .or. aDados[nCntItem][6]=="S"),Carga:Itens[nCnt]:Sif_Produto,Alltrim(Subs(cSifFil,1,IIf(At("/",cSifFil)>0,At("/",cSifFil),100))))

					// para itens do sif da filial corrente, verifica se o item a ser avaliado estah com o sif da filial corrente, para garantir que estah avaliando os dados do item correto	
					If Alltrim(cSif) $ Alltrim(cSifFil)
						If aScan(aPedItem,{|x| Alltrim(x[1])+Alltrim(x[2])+Alltrim(x[3]) == Alltrim(Carga:Cabecalho:Filial)+Alltrim(Carga:Itens[nCnt]:Pedido)+Alltrim(cItem) .and. Alltrim(x[4]) $ Alltrim(cSifFil) }) == 0 
							aAdd(aPedItem,{Alltrim(Carga:Cabecalho:Filial),Alltrim(Carga:Itens[nCnt]:Pedido),Alltrim(cItem),Alltrim(cSif)})
						Else
							Loop
						Endif	    
					Else
						// para itens com sif de outras filiais, garante que o sif nao estah na filial corrente, para garantir a avaliacao do item correto
						If aScan(aPedItem,{|x| Alltrim(x[1])+Alltrim(x[2])+Alltrim(x[3]) == Alltrim(Carga:Cabecalho:Filial)+Alltrim(Carga:Itens[nCnt]:Pedido)+Alltrim(cItem) .and. !Alltrim(x[4]) $ Alltrim(cSifFil) }) == 0 
							aAdd(aPedItem,{Alltrim(Carga:Cabecalho:Filial),Alltrim(Carga:Itens[nCnt]:Pedido),Alltrim(cItem),Alltrim(cSif)})
						Else
							Loop
						Endif	    
					Endif	

					// se eh revenda soh processa se sif for diferente da filial corrente
					//If (!Empty(aDados[nCntItem][5]) .or. Posicione("SF4",1,xFilial("SF4")+aDados[nCntItem][3],"F4_ZREVEND")=="1" .or. aDados[nCntItem][6]=="S")
					If (!Empty(aDados[nCntItem][5]) .or. aDados[nCntItem][6]=="S")					
						If cSif $ cSifFil //.and. !(cSif == "0" .or. cSif == "00" .or. cSif == "000" .or. cSif == "0000") // sif zerado, sempre considera como se fosse sif de outra filial
							Loop
						Endif
					Else // se eh venda soh processa se sif for da filial corrente
						If !cSif $ cSifFil //.or. (cSif == "0" .or. cSif == "00" .or. cSif == "000" .or. cSif == "0000") // sif zerado, sempre considera como se fosse sif de outra filial
							Loop
						Endif	
					Endif		 
				Else
					cSif := Carga:Itens[nCnt]:Sif_Produto // esta gravacao eh feita apenas para a variavel csif ter conteudo, nao participa de nenhuma regra nesta funcao	
					If aScan(aPedItem,{|x| Alltrim(x[1])+Alltrim(x[2])+Alltrim(x[3]) == Alltrim(Carga:Cabecalho:Filial)+Alltrim(Carga:Itens[nCnt]:Pedido)+Alltrim(cItem)}) == 0 
						aAdd(aPedItem,{Alltrim(Carga:Cabecalho:Filial),Alltrim(Carga:Itens[nCnt]:Pedido),Alltrim(cItem)})
					Else
						Loop
					Endif	    
				Endif	

				If !Empty(cItem)
					// caso haja algum registro com a chave primaria da ZZR, deleta
					DelItemZZR(Carga:Cabecalho:Filial,Alltrim(Carga:Itens[nCnt]:Pedido),cItem,Alltrim(Carga:Cabecalho:Ordem_Embarque))
				Endif	

				If lFis45 // atualiza sif novamente, levando em consideracao se a tes estah cadastrada como revenda, isto eh necessario para calculo correto da quantidade de caixas e pesos
					cSif := IIf((!Empty(aDados[nCntItem][5]) .or. Posicione("SF4",1,xFilial("SF4")+aDados[nCntItem][3],"F4_ZREVEND")=="1" .or. aDados[nCntItem][6]=="S"),Carga:Itens[nCnt]:Sif_Produto,Alltrim(Subs(cSifFil,1,IIf(At("/",cSifFil)>0,At("/",cSifFil),100))))	
				Endif

				aPesos := TotCaixas(Carga,cSif,Carga:Itens[nCnt]:Pedido,Carga:Itens[nCnt]:Item_Ped,cSifFil)

				ZZR->(RecLock("ZZR",.T.))
				ZZR->ZZR_FILIAL	:= Carga:Cabecalho:Filial
				ZZR->ZZR_CARGA := Carga:Cabecalho:Ordem_Embarque
				ZZR->ZZR_PEDIDO := Carga:Itens[nCnt]:Pedido
				ZZR->ZZR_ITEM := cItem //Carga:Itens[nCnt]:Item_Ped
				ZZR->ZZR_DTESTU := IIf(!Empty(Carga:Cabecalho:Data_Estufagem),sTod(StrTran(Carga:Cabecalho:Data_Estufagem,"-","")),cTod(""))
				ZZR->ZZR_LACRE := Carga:Cabecalho:Lacre_Sif
				//ZZR->ZZR_OBSERV := Carga:Cabecalho:Obs_EEC
				//ZZR->ZZR_CONTNR := Carga:Cabecalho:Num_Container
				//ZZR->ZZR_TIPO := Carga:Cabecalho:Tipo_Container		
				ZZR->ZZR_SIFPED := Carga:Itens[nCnt]:Sif_Pedido
				ZZR->ZZR_SIF := Carga:Itens[nCnt]:Sif
				ZZR->ZZR_SIFPRD := cSif
				ZZR->ZZR_MATADO := GetAdvFVal( "GU7", "GU7_NMCID", xFilial('GU7')+ALLTRIM(Carga:Itens[nCnt]:Local_Matadouro), 1, Carga:Itens[nCnt]:Local_Matadouro ) // Carga:Itens[nCnt]:Local_Matadouro 
				ZZR->ZZR_PRODUC := GetAdvFVal( "GU7", "GU7_NMCID", xFilial('GU7')+ALLTRIM(Carga:Itens[nCnt]:Local_Producao), 1, Carga:Itens[nCnt]:Local_Producao ) // Carga:Itens[nCnt]:Local_Producao
				ZZR->ZZR_TOTCAI := aPesos[1] //TotCaixas(Carga,cSif,Carga:Itens[nCnt]:Pedido,Carga:Itens[nCnt]:Item_Ped,cSifFil) //Carga:Itens[nCnt]:Total_Caixas
				ZZR->ZZR_PERDE := IIf(!Empty(Carga:Itens[nCnt]:Producao_de),sTod(StrTran(Carga:Itens[nCnt]:Producao_de,"-","")),cTod(""))
				ZZR->ZZR_PERATE := IIf(!Empty(Carga:Itens[nCnt]:Producao_ate),sTod(StrTran(Carga:Itens[nCnt]:Producao_ate,"-","")),cTod(""))
				ZZR->ZZR_SEQ := CriaVar("ZZR_SEQ")
				ZZR->ZZR_CAMINH := Carga:Cabecalho:Caminhao
				ZZR->ZZR_MOTORI := Carga:Cabecalho:Motorista
				ZZR->ZZR_TRANSP := Carga:Cabecalho:Transportadora
				ZZR->ZZR_NUMEXP := Carga:Cabecalho:NumeroExportacao
				ZZR->ZZR_DIST := Carga:Cabecalho:Distancia
				ZZR->ZZR_OBS := Carga:Cabecalho:Obs_EEC
				ZZR->ZZR_NUMCON := Carga:Cabecalho:Num_Container
				ZZR->ZZR_TPCON := Carga:Cabecalho:Tipo_Container
				ZZR->ZZR_QTDLIB := aPesos[4]
				ZZR->ZZR_PESOL := aPesos[2]
				ZZR->ZZR_PESOB := aPesos[3]
				ZZR->ZZR_CAPVOL := Carga:Itens[nCnt]:CapVol
				ZZR->ZZR_LOTE := Carga:Itens[nCnt]:Lote
				ZZR->ZZR_LOTVLD := IIf(!Empty(Carga:Itens[nCnt]:Lote_Valid),StrTran(Carga:Itens[nCnt]:Lote_Valid,"-",""),"") //IIf(!Empty(Carga:Itens[nCnt]:Lote_Valid),sTod(StrTran(Carga:Itens[nCnt]:Lote_Valid,"-","")),cTod(""))
				ZZR->ZZR_DI := Carga:Itens[nCnt]:Num_DI
				ZZR->(MsUnLock())
				IF AScan(aPedCarga, {| x | x == Alltrim(Carga:Cabecalho:Filial)+Alltrim(Carga:Itens[nCnt]:Pedido)}) == 0 
					AADD(aPedCarga, Alltrim(Carga:Cabecalho:Filial)+Alltrim(Carga:Itens[nCnt]:Pedido))
					// campos de tabelas padroes
					aAdd(aCampos,{"EX9","EX9_LACRE",Carga:Cabecalho:Lacre_Sif})
					aAdd(aCampos,{"EEC","EEC_DTESTU",IIf(!Empty(Carga:Cabecalho:Data_Estufagem),sTod(StrTran(Carga:Cabecalho:Data_Estufagem,"-","")),cTod(""))})
					aAdd(aCampos,{"EEC","EEC_ZOBSER",Carga:Cabecalho:Obs_EEC})
					aAdd(aCampos,{"EX9","EX9_CONTNR",Carga:Cabecalho:Num_Container})		
					aAdd(aCampos,{"EX9","EX9_TIPO",Carga:Cabecalho:Tipo_Container})		
					U_EEC18GRV(Carga:Itens[nCnt]:Pedido,aCampos)
				EndIF
				//Endif
			Next	
		Next
	Endif

	If cTipoOper == "2" // exclusao
		cQ := "DELETE "
		cQ += "FROM "+RetSqlName("ZZR")+" "
		cQ += "WHERE D_E_L_E_T_ <> '*' "
		cQ += "AND ZZR_FILIAL = '"+Carga:Cabecalho:Filial+"' "
		cQ += "AND ZZR_CARGA = '"+Alltrim(Carga:Cabecalho:Ordem_Embarque)+"' "

		nRet := tcSqlExec(cQ)
		If nRet == 0
		Else
			ConOut("Problemas na exclusao da tabela ZZR, processo de recepcao da carga do Taura.")
		EndIf
	Endif	

	If cTipoOper == "3" // exclusao por alteracao da carga, neste caso eh por item
		For nCnt:=1 To Len(Carga:Itens)
			cItem := ""
			// encontra o item do pedido
			aDados := DadosSC6(Carga:Itens[nCnt]:Pedido,,.F.,Carga:Itens[nCnt]:Item_Ped,,.T.)
			If Len(aDados) > 0
				For nCntItem:=1 To Len(aDados)
					cItem := aDados[nCntItem][4]
					If !Empty(cItem)
						// caso haja algum registro com a chave primaria da ZZR, deleta
						DelItemZZR(Carga:Cabecalho:Filial,Alltrim(Carga:Itens[nCnt]:Pedido),cItem,Alltrim(Carga:Cabecalho:Ordem_Embarque)/*,Alltrim(Carga:Itens[nCnt]:Sif_Produto)*/)
					Endif	
				Next
			Endif		
		Next
	Endif		

	aEval(aArea,{|x| RestArea(x)})

Return(.T.)	

/* // RETORNAR PARA CONTROLE DE ERROS
Static Function MyError(oError,cError)

Local nQtd := MLCount(oError:ERRORSTACK)
Local ni
Local cEr := ''
Local cTime1 := ""
Local cTime2 := ""

If lSemaf
If !nHdl == -1 .and. File(cSemaf)
fClose(nHdl)
fErase(cSemaf)
Endif	
Endif	

nQtd := IIF(nQtd > 20,20,nQtd) //Retorna as n linhas 

For ni:=1 to nQtd
cEr += MemoLine(oError:ERRORSTACK,,ni)
Next ni

//If InTransact() // OBS: NUNCA HABILITAR ESTE DISARMTRANSACTION AQUI NESTA FUNCAO, POIS QUEBRA A TRANSACAO
//	DisarmTransaction()
//Endif

cError := cEr

Conout( oError:Description + " - Deu Erro" )
Conout( cError )

_aErr := {.F.,cEr}
lErro := .T.

cTime1 := Time()
DesblqReg("SC5",aRegSC5)
DesblqReg("SA1",aRegSA1)
DesblqReg("SA2",aRegSA2)
DesblqReg("SB2",aRegSB2)
DesblqReg("EE7",aRegEE7)
cTime2 := Time()
cMensTime := "ORDEM EMBARQUE: "+cCodCarga+" - FIM DESBLOQUEIO TABELAS ( MYERROR ): "+ElapTime(cTime1,cTime2)+" - Time: "+Time()+CRLF
ConOut(cMensTime)
cLogTime += cMensTime

BREAK

Return(.T.)
*/

// pesquisa a placa do veiculo sem caracteres de espaco, hifen, ponto, etc
Static Function PesqPlaca(Carga)

	Local aArea := {GetArea()}
	Local cQ := ""
	Local lRet := .F.
	Local cAliasTrb := GetNextAlias()
	Local cPlaca := Carga:Cabecalho:Caminhao

	cPlaca := StrTran(StrTran(StrTran(cPlaca," ",""),"-",""),".","")

	cQ := "SELECT REPLACE(REPLACE(REPLACE(DA3_PLACA,' ',''),'-',''),'.','') DA3_PLACA,R_E_C_N_O_ DA3_RECNO "
	cQ += "FROM "+RetSqlName("DA3")+" DA3 "
	cQ += "WHERE "
	//cQ += "DA3_FILIAL = '"+xFilial("DA3")+"' "
	//cQ += "DA3_MSBLQL <> '1' "
	cQ += "DA3.D_E_L_E_T_ <> '*' "
	cQ += "ORDER BY DA3_PLACA "

	/*
	obs: nao usar o changequery aqui, pois no Oracle o changequery altera a query no techo:
	REPLACE(DA3_PLACA,' ','')
	para
	REPLACE(DA3_PLACA,' ',' ')
	ou seja, insere novamente o espaco, que eh justamente o que estah se querendo retirar nesta query
	*/
	//cQ := ChangeQuery(cQ)
	//MemoWrite("mgftas02_1.sql",cQ)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),cAliasTrb,.T.,.T.)

	While (cAliasTrb)->(!Eof())
		If Alltrim((cAliasTrb)->DA3_PLACA) == Alltrim(cPlaca)
			lRet := .T.
			DA3->(dbGoto((cAliasTrb)->DA3_RECNO))
			Exit
		Endif
		(cAliasTrb)->(dbSkip())
	Enddo

	(cAliasTrb)->(dbCloseArea()) 

	aEval(aArea,{|x| RestArea(x)})	

Return(lRet)


// rotina para retornar o erro na integracao com o GFE
Static Function GWNTrataErro(cMens)

	cMens := MemoRead(NomeAutoLog())

Return()	


// rotina de alteracao do pv, para inclusao de itens, devido a vir mais de um codigo de sif para o mesmo item do pv
// para tratamento do GAP FIS45
Static Function AltPVISif(aSif,Carga,aQtdLib,lAtuaSif)//,lExp,lOffS,lProcOff,cSifFil)

	Local nCount := 0
	Local nCnt := 0
	Local aRet := {}
	Local aCab := {}
	Local aItem := {}
	Local aItens := {}
	Local aArea := {SF4->(GetArea()),SC5->(GetArea()),SC6->(GetArea()),SX3->(GetArea()),EE7->(GetArea()),EE8->(GetArea()),GetArea()}
	Local cChave := ""
	Local cMens := ""
	Local lContinua := .T.
	Local nCnt1 := 0
	Local cTesRev := ""
	Local nPos := 0
	Local lPedExp := .F.
	Local aDadosEE7 := {}
	Local nModuloSav := nModulo
	Local cModuloSav := cModulo
	Local cSifFil := "" // retornado em 12/04/18
	Local aSifQuant := {}
	Local aSif1 := {}
	Local cCfo := ""
	Local lAltera := .F.
	//Local cPedExp := ""
	Local cOrigem := ""
	Local cSitTrib := ""
	Local cTime1 := ""
	Local cTime2 := ""
	Local lPVRotAuto := GetMv("MGF_OEPVRT",.F.,.F.)
	Local lFis45 := .T.
	Local aPesos := {}

	Default lAtuaSif := .F. // indica se deve apenas preparar o array asif

	// filiais que nao tem processo de fis45
	//If Alltrim(xFilial("SC5")) $ Alltrim(GetMv("MGF_F45FIL",.F.,""))
	//	aRet := {.T.,""}
	//	Return(aRet)
	//Endif

	// verifica se deve executar o FIS45
	If !GetMv("MGF_F45EXE",.F.,.T.)
		//aRet := {.T.,""}
		//Return(aRet)
		lFis45 := .F.
	Endif

	cTime1 := Time()
	If lContinua .and. lFis45 // .and. !lOffS
		SX6->(dbSetOrder(1))
		SX6->(dbSeek(cFilAnt+"MGF_SIFFIL")) // usa dbseek para garantir a pesquisa do parametro por filial
		If SX6->(!Found()) .or. (SX6->(Found()) .and. Empty(GetMv("MGF_SIFFIL")))
			lContinua := .F.
			cMens := "Parâmetro 'MGF_SIFFIL' em branco ou não encontrado para esta filial, Filial: "+Carga:Cabecalho:Filial+", Carga: "+Carga:Cabecalho:Ordem_Embarque
			ConOut(cMens)
			aRet := {}
			aAdd(aRet,lContinua)
			aAdd(aRet,cMens)				
		Else
			cSifFil := Alltrim(SX6->X6_CONTEUD)	
		Endif	
	Endif

	If lContinua .and. lFis45
		// verifica se houve duplicidade de item no pedido com sif diferente
		SF4->(dbSetOrder(1))

		For nCnt:=1 To Len(aSif)
			If !lContinua
				Exit
			Endif
			/*	
			If !lAtuaSif
			// verifica se o TES de revenda estah preenchido
			If SF4->(dbSeek(xFilial("SF4")+aSif[nCnt][6]))
			If SF4->F4_ZREVEND = "1"
			cTesRev := SF4->F4_CODIGO
			Else
			cTesRev := SF4->F4_ZTESREV
			Endif	
			If Empty(cTesRev)
			lContinua := .F.
			cMens := "TES de Revenda não cadastrado para o TES: "+aSif[nCnt][6]+", Filial: "+aSif[nCnt][1]+", Carga: "+Carga:Cabecalho:Ordem_Embarque+", Pedido: "+aSif[nCnt][2]+", Item: "+aSif[nCnt][3]
			ConOut(cMens)
			aRet := {}
			aAdd(aRet,lContinua)
			aAdd(aRet,cMens)				
			Exit
			Endif	
			aSif[nCnt][8] := cTesRev
			Endif	
			Endif	
			*/
			cChave := aSif[nCnt][1]+aSif[nCnt][2]+aSif[nCnt][3]
			For nCnt1:=1 To Len(aSif)
				// compara pedido+item iguais com sif diferentes ou sif de outras filiais ( sem a necessidade de ter o sif duplicado ) 
				If ((nCnt != nCnt1) .and. (cChave == aSif[nCnt1][1]+aSif[nCnt1][2]+aSif[nCnt1][3] .and. !Alltrim(aSif[nCnt1][4]) == Alltrim(aSif[nCnt][4]))) .or. ;
				(!Alltrim(aSif[nCnt][4]) $ cSifFil)
					If !lAtuaSif// .and. !lOffS // caso lAtuaSif == .T., pode ocorrer do pedido ter sido alterado anteriormente e nao passarah por esta validacao
						// verifica se neste pedido, sobrou algum item gerado pelo sif, em execucoes anteriores da geracao da carga e que por algum motivo, ainda nao tenham sido excluidos
						aRet := VerPVSif(aSif[nCnt][1],aSif[nCnt][2],Carga)
						lContinua := aRet[1]
						cMens := aRet[2]
						If !Empty(cMens)
							Conout(cMens)
						Endif	

						If !lContinua
							Exit
						Endif
					Endif	
					// verifica se o TES de revenda estah preenchido
					If SF4->(dbSeek(xFilial("SF4")+aSif[nCnt][6]))
						If SF4->F4_ZREVEND = "1"
							cTesRev := SF4->F4_CODIGO
						Else
							cTesRev := SF4->F4_ZTESREV
						Endif	
						If Empty(cTesRev)
							lContinua := .F.
							cMens := "TES de Revenda não cadastrado para o TES: "+aSif[nCnt][6]+", Filial: "+aSif[nCnt][1]+", Carga: "+Carga:Cabecalho:Ordem_Embarque+", Pedido: "+aSif[nCnt][2]+", Item: "+aSif[nCnt][3]
							ConOut(cMens)
							aRet := {}
							aAdd(aRet,lContinua)
							aAdd(aRet,cMens)				
							Exit
						Endif	
						aSif[nCnt][8] := cTesRev
					Endif	
					If !Alltrim(aSif[nCnt][6]) == Alltrim(aSif[nCnt][8]) // se forem tes iguais ( venda e revenda ) nao faz nada com este item do pedido
						aSif[nCnt][7] := .T.
						//Exit // 22/12/17
					Endif	
					// apos encontrar o primeiro item com sif diferente jah pode passar para o proximo item do pedido
					Exit // 22/12/17
				Endif
			Next
		Next
	Endif	

	/*
	faz a otimizacao do array asif da seguinte forma:
	- quando houver mais de um sif para o mesmo item do pedido
	- se nao tem o sif da filial corrente 
	- aglutina todas as quantidades em um sif soh e somente altera o tes do item
	- elege o primeiro sif para ser gravado no array
	- se tem o sif da filial corrente
	- mantem o sif da filial corrente com a respectiva quantidade
	- inclui nova linha com a somatoria das quantidades dos demais sif´s e elege o primeiro sif para ser gravado no array
	- altera o pedido, incluindo mais uma linha para este produto
	*/

	If lContinua// .and. lFis45
		If lFis45
			For nCnt:=1 To Len(aSif)
				If !aSif[nCnt][7]
					Loop
				Endif	
				cChave := aSif[nCnt][1]+aSif[nCnt][2]+aSif[nCnt][3]
				// verifica se algum item veio com o sif desta filial, se nao veio, flega para somente alterar a tes do item
				If aScan(aSif,{|x| x[1]+x[2]+x[3]==cChave .and. Alltrim(x[4])$cSifFil}) == 0 //02/05/18 retirado alltrim do x[3],que foi incluido em 17/04/18 //17/04/18			
					aSif[nCnt][11] := .T.
				Endif	
				// monta array somando as quantidades por sif, se sif da filial corrente, agrupa em um unico item, se sif diferente da filial corrente, agrupa tudo que eh diferente em um unico item
				If (nPos:=aScan(aSifQuant,{|x| x[1]+x[2]+x[3]==aSif[nCnt][1]+aSif[nCnt][2]+aSif[nCnt][3] .and. IIf(aSif[nCnt][4]$cSifFil,x[4]$cSifFil,!x[4]$cSifFil) })) == 0
					aAdd(aSifQuant,{aSif[nCnt][1],aSif[nCnt][2],aSif[nCnt][3],IIf(aSif[nCnt][4]$cSifFil,Alltrim(Subs(cSifFil,1,IIf(At("/",cSifFil)>0,At("/",cSifFil),100))),aSif[nCnt][4]),aSif[nCnt][5]})
				Else
					aSifQuant[nPos][5] += aSif[nCnt][5]
				Endif
			Next

			// refaz array asif, somando os itens conforme a regra descrita anteriormente
			For nCnt:=1 To Len(aSif)
				If !aSif[nCnt][7]
					aAdd(aSif1,aClone(aSif[nCnt]))
					Loop
				Endif	
				cChave := aSif[nCnt][1]+aSif[nCnt][2]+aSif[nCnt][3]
				nPos := aScan(aSifQuant,{|x| x[1]+x[2]+x[3]==aSif[nCnt][1]+aSif[nCnt][2]+aSif[nCnt][3] .and. IIf(aSif[nCnt][4]$cSifFil,x[4]$cSifFil,!x[4]$cSifFil) })
				If nPos > 0
					aAdd(aSif1,aClone(aSif[nCnt]))
					aSif1[Len(aSif1)][5] := aSifQuant[nPos][5]
				Endif
				If !aSif[nCnt][11] // nao eh somente alteracao de tes, adiciona 1 item 
					If nPos > 0 // 22/12/17
						// verifica se o item que jah foi adicionado eh desta filial ou nao, para incluir o proximo item corretamente
						If aSifQuant[nPos][4] $ cSifFil
							lFil := .T.
						Else
							lFil := .F.
						Endif
						// pesquisa a existencia do outro item no array asifquant, ou seja, se jah foi incluido o item da filial corrente, pesquisa se existem itens de outras filiais e 
						// vice-versa		
						nPos := aScan(aSifQuant,{|x| x[1]+x[2]+x[3]==aSif[nCnt][1]+aSif[nCnt][2]+aSif[nCnt][3] .and. IIf(lFil,!x[4]$cSifFil,x[4]$cSifFil) })
						If nPos > 0
							aAdd(aSif1,aClone(aSif[nCnt]))
							aSif1[Len(aSif1)][4] := aSifQuant[nPos][4]
							aSif1[Len(aSif1)][5] := aSifQuant[nPos][5]
						Endif
					Endif	
				Endif
				// pula para proximo item do PV
				While nCnt <= Len(aSif)	
					nCnt++
					If nCnt > Len(aSif)
						Exit
					Endif	
					If aSif[nCnt][1]+aSif[nCnt][2]+aSif[nCnt][3] == cChave
						Loop
					Else
						// retorna 1 na variavel nCnt, para processar item anterior, pois o controle estah dentro de um For e a variavel serah incrementada novamente
						nCnt--
						Exit	
					Endif	
				Enddo
			Next				
		Else
			// apenas agrupa as quantidades por item, para o caso de ser pedido de exportacao, alterar o pedido com a quantidade correta
			For nCnt:=1 To Len(aSif)
				cChave := aSif[nCnt][1]+aSif[nCnt][2]+aSif[nCnt][3]
				// monta array somando as quantidades por chave
				If (nPos:=aScan(aSifQuant,{|x| x[1]+x[2]+x[3]==aSif[nCnt][1]+aSif[nCnt][2]+aSif[nCnt][3] })) == 0
					aAdd(aSifQuant,{aSif[nCnt][1],aSif[nCnt][2],aSif[nCnt][3],"",aSif[nCnt][5]})
				Else
					aSifQuant[nPos][5] += aSif[nCnt][5]
				Endif
			Next

			// refaz array asif, somando os itens
			For nCnt:=1 To Len(aSif)
				cChave := aSif[nCnt][1]+aSif[nCnt][2]+aSif[nCnt][3]
				nPos := aScan(aSifQuant,{|x| x[1]+x[2]+x[3]==aSif[nCnt][1]+aSif[nCnt][2]+aSif[nCnt][3] })
				If nPos > 0
					aAdd(aSif1,aClone(aSif[nCnt]))
					aSif1[Len(aSif1)][5] := aSifQuant[nPos][5]
				Endif
				// pula para proximo item do PV
				While nCnt <= Len(aSif)	
					nCnt++
					If nCnt > Len(aSif)
						Exit
					Endif	
					If aSif[nCnt][1]+aSif[nCnt][2]+aSif[nCnt][3] == cChave
						Loop
					Else
						// retorna 1 na variavel nCnt, para processar item anterior, pois o controle estah dentro de um For e a variavel serah incrementada novamente
						nCnt--
						Exit	
					Endif	
				Enddo
			Next				
		Endif	
	Endif	
	cTime2 := Time()
	cMensTime := "ORDEM EMBARQUE: "+Carga:Cabecalho:Ordem_Embarque+" - FIM AVALIAÇÃO REGRA FIS45: "+ElapTime(cTime1,cTime2)+" - Time: "+Time()+CRLF
	ConOut(cMensTime)
	cLogTime += cMensTime

	cTime1 := Time()		
	If lContinua
		If Len(aSif1) > 0
			For nCnt:=1 To Len(aSif1) // atualiza indice, para posicionar o item da filial do mesmo sif em primeira posicao
				//cChave := aSif[nCnt][1]+[nCnt][2]+[nCnt][3]
				If aSif1[nCnt][4] $ cSifFil
					aSif1[nCnt][12] := "1"
				Else
					aSif1[nCnt][12] := "2"
				Endif		
			Next	
			//aSort(aSif1,,,{|x,y| x[1]+x[2]+x[3]+x[4] < y[1]+y[2]+y[3]+y[4]})
			aSort(aSif1,,,{|x,y| x[1]+x[2]+x[3]+x[12] < y[1]+y[2]+y[3]+y[12]})
			aSif := aClone(aSif1)
		Endif
		If lAtuaSif
			If Len(aRet) == 0
				aRet := {.T.,""}
			Endif

			Return(aRet)
		Endif		

		// verifica se algum item deve ser excluido, por nao ter vindo na integracao. Somente para pedido de exportacao
		If GetMv("MGF_OEDEL",,.F.)

			SC5->(dbSetOrder(1))
			EE8->(dbSetOrder(1))
			For nCnt:=1 To Len(aSif)
				If SC5->(dbSeek(aSif[nCnt][1]+aSif[nCnt][2]))
					If !Empty(SC5->C5_PEDEXP)
						If EE8->(dbSeek(xFilial("EE8")+SC5->C5_PEDEXP))
							While EE8->(!Eof()) .and. xFilial("EE8")+SC5->C5_PEDEXP == EE8->EE8_FILIAL+EE8->EE8_PEDIDO
								If (nPos:=aScan(aQtdLib,{|x| Alltrim(x[1])+Alltrim(x[2])+Alltrim(x[6]) == Alltrim(EE8->EE8_FILIAL)+Alltrim(SC5->C5_NUM)+Alltrim(EE8->EE8_COD_I) })) == 0
									aSif[nCnt][17] := .T.
								Endif
								EE8->(dbSkip())
							Enddo
						Endif
					Endif
				Endif
			Next
		Endif					

		nCnt := 1
		While nCnt <= Len(aSif)
			aCab := {}
			aItem := {}
			aItens := {}
			lPedExp := .F.
			lAltera := .F.

			If aSif[nCnt][7] .or. aSif[nCnt][15] .or. aSif[nCnt][17]
				cChave := aSif[nCnt][1]+aSif[nCnt][2]

				SC5->(dbSetOrder(1)) // obs: deixar estes dbsetorder aqui, pois quando usa rotina automatica a ordem das tabelas podem ser alteradas
				//If IIf(lOffS,.T.,SC5->(dbSeek(aSif[nCnt][1]+aSif[nCnt][2])))
				If SC5->(dbSeek(aSif[nCnt][1]+aSif[nCnt][2]))
					// verifica se deve processar pedido nesta chamada da funcao
					//If (!lOffS .and. (lExp .and. Empty(SC5->C5_PEDEXP)) .or. (!lExp .and. !Empty(SC5->C5_PEDEXP))) .or. (lOffS .and. !lExp)
					/*
					If (!lOffS .and. (lExp .and. Empty(SC5->C5_PEDEXP))) .or. (lOffS .and. !lExp)
					nCnt++
					Loop
					Endif
					*/
					// obs: pv oriundo do pedido de exportacao serah processado como pv se a variavel lexp = .f. e como pedido de exportacao se a variavel for .t.
					//If (lExp .and. !Empty(SC5->C5_PEDEXP)) .or. lOffS
					If !Empty(SC5->C5_PEDEXP)
						lPedExp := .T.
						nModulo := 29 // EEC 
						cModulo := "EEC"
					Endif
					If !lPedExp
						If !aSif[nCnt][7] .and. aSif[nCnt][15]
							nCnt++	
							Loop
						Endif	
						aCab := ArraySX3("SC5")
					Else
						//aDadosEE7 := DadosEE7(IIf(!lOffS,SC5->C5_NUM,aSif[nCnt][2]))	
						aDadosEE7 := DadosEE7(SC5->C5_NUM)	
						If Len(aDadosEE7) > 0
							EE7->(dbGoto(aDadosEE7[1]))
							If EE7->(Recno()) == aDadosEE7[1]
								// verifica off-shore
								//If !lOffS // variavel usada para indicar se este processamento eh dos pedidos off-shore ou nao
								//	If EE7->EE7_INTERM == "1" /*.and. cFilAnt == Alltrim(GetMv("MV_AVG0023"))/*filial origem off-shore*/ .and. !Empty(Alltrim(GetMv("MV_AVG0024")))/*filial destino off-shore*/
								//		lProcOff := .T. // variavel usada para indicar que processou pelo menos 1 pedido off-shore
								//	Endif
								//Else // processando pedidos off-shore		
								//	// verifica na filial de origem se o pedido realmente eh off-shore
								//	cPedExp := EE7->EE7_PEDIDO
								//	EE7->(dbSetOrder(1))
								//	// pesquisa pela filial enviada pelo taura
								//	If EE7->(dbSeek(Carga:Cabecalho:Filial+cPedExp))
								//		If EE7->EE7_INTERM != "1" // nao eh off-shore
								//			nCnt++
								//			Loop
								//		Endif
								//	Endif	
								//	// retorna para recno da filial off-shore
								//	EE7->(dbGoto(aDadosEE7[1]))
								//Endif		
								aCab := ArraySX3("EE7")
							Endif
						Endif		
					Endif	        
				Endif			

				If !lPedExp
					// carrega todos os itens do PV
					SC6->(dbSetOrder(1))
					If SC6->(dbSeek(aSif[nCnt][1]+aSif[nCnt][2]))
						While SC6->(!Eof()) .and. aSif[nCnt][1]+aSif[nCnt][2] == SC6->C6_FILIAL+SC6->C6_NUM
							// reposiciona variavel ncnt para refletir o item correto do array asif
							If (nPos:=aScan(aSif,{|x| Alltrim(x[1])+Alltrim(x[2])+Alltrim(x[3]) == Alltrim(SC6->C6_FILIAL)+Alltrim(SC6->C6_NUM)+Alltrim(SC6->C6_ITEM)})) > 0						
								nCnt := nPos
							Endif	

							If SC6->C6_ITEM == aSif[nCnt][03] .and. aSif[nCnt][11] // somente altera a tes do item
								cCfo := TAS02Cfo(SC6->C6_CLI,SC6->C6_LOJA,aSif[nCnt][08])
								cOrigem := RetFldProd(SC6->C6_PRODUTO,"B1_ORIGEM")
								If Empty(cOrigem)
									cOrigem := GetAdvFVal("SB1","B1_ORIGEM",xFilial("SB1")+SC6->C6_PRODUTO,1,"")
								Endif
								cSitTrib := GetAdvFVal("SF4","F4_SITTRIB",xFilial("SF4")+aSif[nCnt][8],1,"")

								SC6->(RecLock("SC6",.F.))
								SC6->C6_ZTESSIF := SC6->C6_TES
								SC6->C6_ZCFOSIF := SC6->C6_CF
								SC6->C6_TES := aSif[nCnt][8]
								SC6->C6_CF := cCfo
								SC6->C6_CLASFIS := cOrigem+cSitTrib
								SC6->(MsUnLock())
							Endif	
							aItem := {}
							// a rotina automatica estah zerando alguns campos do sc6 que nao estao indo no array
							// , desta forma, estao sendo enviados todos os campos do sc6 que tem conteudo
							aItem := ArraySX3("SC6")
							// zera campo para controle da quantidade original
							If (nPos:=aScan(aItem,{|x| Alltrim(x[1]) == "C6_ZQTDSIF"})) == 0
								aAdd(aItem,{"C6_ZQTDSIF",0,Nil})	
							Else
								aItem[nPos][2] := 0
							Endif		
							If (nPos:=aScan(aItem,{|x| Alltrim(x[1]) == "C6_ZGERSIF"})) == 0
								aAdd(aItem,{"C6_ZGERSIF","N",Nil})	
							Else
								aItem[nPos][2] := "N"
							Endif		

							If !lPVRotAuto
								// sempre deixar este campo por ultimo
								aAdd(aItem,{"",.F.,Nil}) // item criado para fazer o tratamento da gravacao do registro, sem usar rotina automatica
							Endif	

							// verifica se algum item que estah sendo alterado foi flegado para ser processado
							If (nPos:=aScan(aSif,{|x| Alltrim(x[1])+Alltrim(x[2])+Alltrim(x[3]) == Alltrim(SC6->C6_FILIAL)+Alltrim(SC6->C6_NUM)+Alltrim(SC6->C6_ITEM)})) > 0
								If aSif[nPos][7] .and. !aSif[nPos][11]
									lAltera := .T.
								Endif
							Endif		

							aAdd(aItens,aClone(aItem))
							SC6->(dbSkip())
						Enddo
					Endif
				Else
					// carrega todos os itens do pedido de exportacao
					If Len(aDadosEE7) > 0
						EE8->(dbSetOrder(1))
						SC6->(dbSetOrder(1))
						If EE8->(dbSeek(xFilial("EE8")+aDadosEE7[2]))
							While EE8->(!Eof()) .and. xFilial("EE8")+aDadosEE7[2] == EE8->EE8_FILIAL+EE8->EE8_PEDIDO
								// reposiciona variavel ncnt para refletir o item correto do array asif
								If (nPos:=aScan(aSif,{|x| Alltrim(x[1])+Alltrim(x[2])+Alltrim(x[3]) == Alltrim(EE8->EE8_FILIAL)+Alltrim(EE7->EE7_PEDFAT)+Alltrim(EE8->EE8_FATIT)})) > 0
									nCnt := nPos
								Endif	

								If EE8->EE8_FATIT == aSif[nCnt][03] .and. aSif[nCnt][11] // somente altera a tes do item
									//If IIf(lOffS,.T.,SC6->(dbSeek(EE8->EE8_FILIAL+EE7->EE7_PEDFAT+EE8->EE8_FATIT)))
									If SC6->(dbSeek(EE8->EE8_FILIAL+EE7->EE7_PEDFAT+EE8->EE8_FATIT))
										cOrigem := RetFldProd(SC6->C6_PRODUTO,"B1_ORIGEM")
										If Empty(cOrigem)
											cOrigem := GetAdvFVal("SB1","B1_ORIGEM",xFilial("SB1")+SC6->C6_PRODUTO,1,"")
										Endif
										cSitTrib := GetAdvFVal("SF4","F4_SITTRIB",xFilial("SF4")+aSif[nCnt][8],1,"")

										//If !lOffS
										cCfo := TAS02Cfo(SC6->C6_CLI,SC6->C6_LOJA,aSif[nCnt][08])
										//Else
										//	cCfo := TAS02Cfo(EE7->EE7_IMPORT,EE7->EE7_IMLOJA,aSif[nCnt][08])
										//Endif	

										EE8->(RecLock("EE8",.F.))
										EE8->EE8_ZTESSI := EE8->EE8_TES
										EE8->EE8_ZCFOSI := EE8->EE8_CF
										EE8->EE8_TES := aSif[nCnt][8]
										EE8->EE8_CF := cCfo
										EE8->(MsUnLock())

										//If !lOffS
										SC6->(RecLock("SC6",.F.))
										SC6->C6_ZTESSIF := SC6->C6_TES
										SC6->C6_ZCFOSIF := SC6->C6_CF
										SC6->C6_TES := aSif[nCnt][8]
										SC6->C6_CF := cCfo
										SC6->C6_CLASFIS := cOrigem+cSitTrib
										SC6->(MsUnLock())
										//Endif	

									Endif	
								Endif	

								aItem := {}
								aItem := ArraySX3("EE8")
								If aSif[nCnt][7]
									// zera campo para controle da quantidade original
									If (nPos:=aScan(aItem,{|x| Alltrim(x[1]) == "EE8_ZQTDSI"})) == 0
										aAdd(aItem,{"EE8_ZQTDSI",0,Nil})	
									Else
										aItem[nPos][2] := 0
									Endif		
									If (nPos:=aScan(aItem,{|x| Alltrim(x[1]) == "EE8_ZGERSI"})) == 0
										aAdd(aItem,{"EE8_ZGERSI","N",Nil})	
									Else
										aItem[nPos][2] := "N"
									Endif

									// obs: quando o item foi processado no fis45 e foi apenas troca de tes e tambem deve ter a quantidade alterada, o elemento 7 do array asif deve
									// ser gravado como .f. neste momento, para que a sequencia da rotina trate este item como apenas alteracao da quantidade e nao como fis45, 
									// pois se nao for feito este tratamento, a rotina nao grava o campo ee8_zqtdhi e nao faz o tratamento correto para a alteracao de quantidade
									If aSif[nCnt][11] .and. aSif[nCnt][15]
										aSif[nCnt][7] := .F.
									Endif				
								Endif
								If !aSif[nCnt][7] .and. aSif[nCnt][15]	
									// zera campo para controle da quantidade original
									If (nPos:=aScan(aItem,{|x| Alltrim(x[1]) == "EE8_ZQTDHI"})) == 0
										aAdd(aItem,{"EE8_ZQTDHI",0,Nil})	
									Else
										aItem[nPos][2] := 0
									Endif		
								Endif	

								// verifica se campos referente ao pedido de venda foram inseridos no array
								If (nPos:=aScan(aItem,{|x| Alltrim(x[1]) == "EE8_TES"})) == 0
									aAdd(aItem,{"EE8_TES",EE8->EE8_TES,Nil})	
								Endif	
								If (nPos:=aScan(aItem,{|x| Alltrim(x[1]) == "EE8_CF"})) == 0
									aAdd(aItem,{"EE8_CF",EE8->EE8_CF,Nil})	
								Endif	
								If (nPos:=aScan(aItem,{|x| Alltrim(x[1]) == "EE8_FATIT"})) == 0
									aAdd(aItem,{"EE8_FATIT",EE8->EE8_FATIT,Nil})	
								Endif	     

								If GetMv("MGF_OEPESO",,.F.) 
									If lFis45
										aPesos := TotCaixas(Carga,aSif[nCnt][4],EE7->EE7_PEDFAT,EE8->EE8_COD_I,cSifFil)
									Else
										aPesos := TotCaixas(Carga,"",EE7->EE7_PEDFAT,EE8->EE8_COD_I,"")
									Endif	

									//conout("caixas "+str(apesos[1]))
									//conout("liquido "+str(apesos[2]))
									//conout("bruto "+str(apesos[3]))
									//conout("qtde "+str(apesos[4]))																					
									//conout("bruto calc "+str(aPesos[3]/aPesos[4]))

									If (nPos:=aScan(aItem,{|x| Alltrim(x[1]) == "EE8_QTDEM1"})) == 0
										aAdd(aItem,{"EE8_QTDEM1",IIf(aPesos[1]==0,EE8->EE8_QTDEM1,aPesos[1]),Nil})	
									Else
										aItem[nPos][2] := IIf(aPesos[1]==0,EE8->EE8_QTDEM1,aPesos[1])
									Endif
									If (nPos:=aScan(aItem,{|x| Alltrim(x[1]) == "EE8_PSLQUN"})) == 0
										aAdd(aItem,{"EE8_PSLQUN",1,Nil})	
									Else
										aItem[nPos][2] := 1
									Endif

									If (nPos:=aScan(aItem,{|x| Alltrim(x[1]) == "EE8_PSLQTO"})) == 0
										aAdd(aItem,{"EE8_PSLQTO",aPesos[4],Nil})	
									Else
										aItem[nPos][2] := aPesos[4]
									Endif

									If (nPos:=aScan(aItem,{|x| Alltrim(x[1]) == "EE8_PSBRUN"})) == 0
										aAdd(aItem,{"EE8_PSBRUN",IIf(aPesos[4]==0,EE8->EE8_PSBRUN,aPesos[3]/aPesos[4]),Nil})	
									Else
										aItem[nPos][2] := IIf(aPesos[4]==0,EE8->EE8_PSBRUN,aPesos[3]/aPesos[4])
									Endif

									If (nPos:=aScan(aItem,{|x| Alltrim(x[1]) == "EE8_PSBRTO"})) == 0
										aAdd(aItem,{"EE8_PSBRTO",IIf(aPesos[4]==0,EE8->EE8_PSBRTO,aPesos[3]/aPesos[4]*aPesos[4]),Nil})	
									Else
										aItem[nPos][2] := IIf(aPesos[4]==0,EE8->EE8_PSBRTO,aPesos[3]/aPesos[4]*aPesos[4])
									Endif

									If (nPos:=aScan(aItem,{|x| Alltrim(x[1]) == "EE8_QE"})) == 0
										aAdd(aItem,{"EE8_QE",IIf(aPesos[4]==0,EE8->EE8_QE,aPesos[4]),Nil})	
									Else
										aItem[nPos][2] := IIf(aPesos[4]==0,EE8->EE8_QE,aPesos[4])
									Endif
								Endif	

								//If (nPos:=aScan(aItem,{|x| Alltrim(x[1]) == "EE8_SLDATU"})) == 0
								//	aAdd(aItem,{"EE8_SLDATU",0,Nil})	
								//EndIF

								//aAdd(aItem,{"AUTDELETA","N",Nil})

								// deleta itens que nao vieram no arquivo da carga
								If GetMv("MGF_OEDEL",,.F.) 
									If (nPos:=aScan(aQtdLib,{|x| Alltrim(x[1])+Alltrim(x[2])+Alltrim(x[6]) == Alltrim(EE8->EE8_FILIAL)+Alltrim(EE7->EE7_PEDFAT)+Alltrim(EE8->EE8_COD_I) })) == 0
										EE8->(RecLock("EE8",.F.))
										EE8->EE8_ZOEDEL := "S" 
										EE8->(MsUnlock())
										//aAdd(aItem,{"EE8_ZOEDEL","S",Nil}) // nao passar, pois padrao nao grava na exclusao
										aAdd(aItem,{"AUTDELETA","S",Nil})

										// marca para alterar o pedido na rotina automatica
										lAltera := .T.
									Endif	
								Endif	

								// sempre deixar este campo por ultimo
								//aAdd(aItem,{"",.F.,Nil}) // item criado para fazer o tratamento da gravacao do registro, sem usar rotina automatica

								// verifica se algum item que estah sendo alterado foi flegado para ser processado
								If (nPos:=aScan(aSif,{|x| Alltrim(x[1])+Alltrim(x[2])+Alltrim(x[3]) == Alltrim(EE8->EE8_FILIAL)+Alltrim(EE7->EE7_PEDFAT)+Alltrim(EE8->EE8_FATIT)})) > 0
									If (aSif[nPos][7] .and. !aSif[nPos][11]) .or. (!aSif[nPos][7] .and. aSif[nPos][15])	 
										lAltera := .T.
									Endif
								Endif		

								aAdd(aItens,aClone(aItem))
								EE8->(dbSkip())
							Enddo
						Endif
					Endif	
				Endif

				// pula para proximo PV
				While nCnt <= Len(aSif)	
					nCnt++
					If nCnt > Len(aSif)
						Exit
					Endif	
					If aSif[nCnt][1]+aSif[nCnt][2] == cChave
						//aSif[nCnt][8] := cTesRev
						Loop
					Else
						Exit	
					Endif	
				Enddo
				If Len(aItens) > 0 .and. lAltera
					aRet := AltPVI(@aCab,@aItens,@aSif,Carga,@aQtdLib,lPedExp,lFis45,cSifFil)//,lExp,lProcOff)
					lContinua := aRet[1]

					If !lContinua
						Exit
					Endif
				Elseif Len(aItens) > 0 // somente altera quantidades do array aqtdlib
					AltPVIQLib(aCab,aItens,aSif,Carga,@aQtdLib,lPedExp)	
				Endif		
			Else
				nCnt++	
			Endif	 
		Enddo	
	Endif
	cTime2 := Time()
	cMensTime := "ORDEM EMBARQUE: "+Carga:Cabecalho:Ordem_Embarque+" - FIM EXECUÇÃO FIS45: "+ElapTime(cTime1,cTime2)+" - Time: "+Time()+CRLF
	ConOut(cMensTime)
	cLogTime += cMensTime

	If Len(aRet) == 0
		aRet := {.T.,""}
	Endif

	nModulo := nModuloSav
	cModulo := cModuloSav

	aEval(aArea,{|x| RestArea(x)})

Return(aRet)			


// carrega array para rotina automatica a partir do dicionario de dados
Static Function ArraySX3(cAlias)

	Local aArea := {SX3->(GetArea()),GetArea()}
	Local aRet := {}
	//Local aNaoCpos := {"EE8_DTPREM","EE8_DTENTR","EE7_UNIDAD","EE7_CODBOL"} // array com campos para nao serem acrescentados, pois estao dando problema na validacao da rotina automatica
	//Local aNaoCpos := {"EE7_FILIAL","EE8_FILIAL","C5_FILIAL","C6_FILIAL"} // adicionado os campos de filial, pois alguns trechos do fonte esperam localizar o campo _ITEM no 1 
	// elemento do array e se for inserido o campo de filial, este serah o 1 do array
	//18/04/18 duas proximas linhas, variavel aNaoCpos
	//Local aNaoCpos := {"EE8_PSLQTO","EE8_PSBRTO","EE8_DESCON","EE8_VLCOM","EE8_VLFRET","EE8_VLSEGU","EE8_VLOUTR","EE8_VLDESC","EE8_QTDEM1","EE8_PRCTOT","EE8_PRCINC","EE8_SLDATU","EE8_DTENTR","EE8_DTPREM"} // 18/04/18
	//Local aNaoCpos := {"EE8_PSLQTO","EE8_PSBRTO","EE8_DESCON","EE8_VLCOM","EE8_VLFRET","EE8_VLSEGU","EE8_VLOUTR","EE8_VLDESC","EE8_PRCTOT","EE8_PRCINC","EE8_SLDATU","EE8_DTENTR","EE8_DTPREM"} // 18/04/18
	//Local aNaoCpos := {}
	Local aNaoEE8Cpos := {}
	Local aNaoEE7Cpos := {}

	If GetMv("MGF_OEE8NC",,.T.) 
		If GetMv("MGF_OEPESO",,.F.) 
			//aNaoCpos := {"EE8_PSLQTO","EE8_PSBRTO","EE8_DESCON","EE8_VLCOM","EE8_VLFRET","EE8_VLSEGU","EE8_VLOUTR","EE8_VLDESC","EE8_PRCTOT","EE8_PRCINC","EE8_SLDATU","EE8_DTENTR","EE8_DTPREM"} // 18/04/18
			aNaoEE8Cpos := StrTokArr(GetMv("MGF_OEE8P1"),",")
		Else
			//aNaoCpos := {"EE8_PSLQTO","EE8_PSBRTO","EE8_DESCON","EE8_VLCOM","EE8_VLFRET","EE8_VLSEGU","EE8_VLOUTR","EE8_VLDESC","EE8_QTDEM1","EE8_PRCTOT","EE8_PRCINC","EE8_SLDATU","EE8_DTENTR","EE8_DTPREM"} // 18/04/18
			//aNaoCpos := {"EE8_DESCON","EE8_VLCOM","EE8_VLFRET","EE8_VLSEGU","EE8_VLOUTR","EE8_VLDESC","EE8_PRCTOT","EE8_PRCINC","EE8_SLDATU","EE8_DTENTR","EE8_DTPREM"} // 18/04/18	
			aNaoEE8Cpos := StrTokArr(GetMv("MGF_OEE81"),",")
		Endif
	Endif	

	If GetMv("MGF_OEE7NC",,.T.) 
		aNaoEE7Cpos := StrTokArr(GetMv("MGF_OEE71"),",")
	Endif	

	If cAlias == "EE8"
		aAdd(aRet,{"LINPOS","EE8_SEQUEN",EE8->EE8_SEQUEN})
	Endif

	SX3->(dbSetOrder(1))
	SX3->(dbSeek(cAlias))
	While SX3->(!Eof()) .and. SX3->X3_ARQUIVO == cAlias
		// obs: deixar sem a funcao x3uso(), pois alguns campos especificos estao como naousados e somente sao preenchidos sem esta funcao no IF.
		//If X3Uso(SX3->X3_USADO) .and. SX3->X3_CONTEXT != "V" .and. aScan(aNaoCpos,Alltrim(SX3->X3_CAMPO)) == 0 .and. SX3->X3_TIPO != "M" 
		//If SX3->X3_CONTEXT != "V" .and. aScan(aNaoCpos,Alltrim(SX3->X3_CAMPO)) == 0 .and. SX3->X3_TIPO != "M" 
		If SX3->X3_CONTEXT != "V" .and. aScan(aNaoEE8Cpos,Alltrim(SX3->X3_CAMPO)) == 0 .and. aScan(aNaoEE7Cpos,Alltrim(SX3->X3_CAMPO)) == 0 .and. SX3->X3_TIPO != "M" 	
			If !Empty(&(cAlias+"->"+SX3->X3_CAMPO))
				//aAdd(aRet,{Alltrim(SX3->X3_CAMPO),&(cAlias+"->"+SX3->X3_CAMPO),IIf(("_Z" $ SX3->X3_CAMPO .or. "_X" $ SX3->X3_CAMPO .or. SX3->X3_PROPRI == "U"),.T.,Nil)})
				aAdd(aRet,{Alltrim(SX3->X3_CAMPO),&(cAlias+"->"+SX3->X3_CAMPO),Nil})			
			Endif
		Endif		
		SX3->(dbSkip())
	Enddo

	aEval(aArea,{|x| RestArea(x)})

Return(aRet)


// carrega dados da tabela EE7, referente ao pedido de venda
Static Function DadosEE7(cPed)	

	Local aArea := {GetArea()}
	Local cQ := ""
	Local aRet := {}
	Local cAliasTrb := GetNextAlias()

	cQ := "SELECT EE7.R_E_C_N_O_ EE7_RECNO,EE7_PEDIDO "
	cQ += "FROM "+RetSqlName("EE7")+" EE7 "
	cQ += "WHERE "
	cQ += "EE7_FILIAL = '"+xFilial("EE7")+"' "
	cQ += "AND EE7_PEDFAT = '"+cPed+"' "
	cQ += "AND EE7.D_E_L_E_T_ <> '*' "

	cQ := ChangeQuery(cQ)
	//MemoWrite("mgftas02_1.sql",cQ)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),cAliasTrb,.T.,.T.)

	If (cAliasTrb)->(!Eof())
		aAdd(aRet,(cAliasTrb)->EE7_RECNO)
		aAdd(aRet,(cAliasTrb)->EE7_PEDIDO)
	Endif

	(cAliasTrb)->(dbCloseArea()) 

	aEval(aArea,{|x| RestArea(x)})	

Return(aRet)


// rotina complementar da rotina AltPVISif
// para tratamento do GAP FIS45
Static Function AltPVI(aCab,aItens,aSif,Carga,aQtdLib,lPedExp,lFis45,cSifFil)//,lExp,lProcOff)

	Local aArea := {SB1->(GetArea()),EE7->(GetArea()),EE8->(GetArea()),SC6->(GetArea()),GetArea()}
	Local nCnt := 0
	Local aRet := {}
	Local nPos := 0
	Local cItem := ""
	Local cFileLog := ""
	Local lContinua := .T.
	Local nCntSav := 0
	Local aDados := {}
	Local nCntFatIt := 0
	Local cMens := ""
	Local cCfo := ""
	Local nQtdPed := 0
	Local nCntItem := 0
	Local nPos1 := 0
	Local cItemSav := ""
	Local cOrigem := ""
	Local cSitTrib := ""
	//Local cCodLan := ""
	Local lPVRotAuto := GetMv("MGF_OEPVRT",.F.,.F.)
	Local nPosQtd := 0
	Local nQtdAlt := 0 
	Local aPesos := {}

	Private lMsErroAuto := .F.

	// busca o maior item no pedido
	// converte o item de string para numerico, pois podem haver letras no item
	If !lPedExp
		//cItem := aItens[Len(aItens)][aScan(aItens[1],{|x| Alltrim(x[1]) == "C6_ITEM"})][2] //aItens[Len(aItens)][1][3] linpos
		For nCnt:=1 to Len(aItens)
			cItem := RetAsc(Str(Max(Val(RetAsc(cItem,2,.F.)),Val(RetAsc(aItens[nCnt][aScan(aItens[1],{|x| Alltrim(x[1]) == "C6_ITEM"})][2],2,.F.)))),2,.T.)
		Next	
	Else
		//cItem := aItens[Len(aItens)][aScan(aItens[1],{|x| Alltrim(x[1]) == "EE8_SEQUEN"})][2] //aItens[Len(aItens)][aScan(aItens[1],{|x| Alltrim(x[1]) == "LINPOS"})][3] //
		For nCnt:=1 to Len(aItens)
			If Empty(cItemSav) .or. Val(cItemSav) < Val(aItens[nCnt][aScan(aItens[1],{|x| Alltrim(x[1]) == "EE8_SEQUEN"})][2])
				cItemSav := aItens[nCnt][aScan(aItens[1],{|x| Alltrim(x[1]) == "EE8_SEQUEN"})][2]
			Endif	
			cItem := RetAsc(Str(Max(Val(RetAsc(cItem,2,.F.)),Val(RetAsc(aItens[nCnt][aScan(aItens[1],{|x| Alltrim(x[1]) == "EE8_SEQUEN"})][2],2,.F.)))),2,.T.)
		Next	
	Endif		

	For nCnt:=1 To Len(aSif)
		// soh processa o pedido que estah sendo alterado
		If !aSif[nCnt][2] == IIf(!lPedExp,aCab[aScan(aCab,{|x| Alltrim(x[1]) == "C5_NUM"})][2],aCab[aScan(aCab,{|x| Alltrim(x[1]) == "EE7_PEDFAT"})][2])
			Loop
		Endif	
		// verifica se item jah foi processado 
		If aSif[nCnt][9]
			Loop
		Endif	
		// se somente eh alteracao de tes nao processa aqui
		If aSif[nCnt][11] .and. !aSif[nCnt][15]
			// se for exclusao de itens do exportacao, apenas grava a variavel nCntSav, para uso posteriormente
			If aSif[nCnt][17]
				nCntSav := nCnt
			Endif	
			Loop
		Endif	

		If aSif[nCnt][7] .or. aSif[nCnt][15]
			cChave := aSif[nCnt][1]+aSif[nCnt][2]+aSif[nCnt][3] //filial+pedido+item
			nQtdPed := 0 // variavel usada para dividir a quantidade do item ao meio
			If !lPedExp 
				If !aSif[nCnt][7] .and. aSif[nCnt][15]
					Loop
				Endif	

				If !lPVRotAuto
					// zera campos de valor do array
					aEval(aCamposPed,{|x,y| aCamposPed[y][2]:=0,aCamposPed[y][3]:=0})
				Endif	

				// procura item do pedido que veio com sif duplicado e jah altera a quantidade
				// obs: nao mudar o conteudo da variavel nPos, pois a mesma eh usada logo abaixo

				// obs: o elemento [2][2] estah chumbado, pois o campo de item do pedido eh sempre o segundo do array
				// atencao: se o campo filial estiver no array aitens, o campo c6_item eh o elemento 2, ficando [2][2], se nao estiver eh o elemento 1, ficando [1][2]
				// o campo filial soh vai estar no array, se na funcao arraysx3 estiver pegando tambem os campos naousados

				If (nPos:=aScan(aItens,{|x| x[2][2] == aSif[nCnt][3]})) > 0 //(nPos:=aScan(aItens,{|x| x[1][2] == aSif[nCnt][3]})) > 0 //(nPos:=aScan(aItens,{|x| x[1][3] == aSif[nCnt][3]})) > 0 linpos

					If lPVRotAuto
						If aItens[nPos][aScan(aItens[nPos],{|x| Alltrim(x[1]) == "C6_QTDVEN"})][2] > 1.0
							nQtdPed := Int(aItens[nPos][aScan(aItens[nPos],{|x| Alltrim(x[1]) == "C6_QTDVEN"})][2]/2)
						Else
							nQtdPed := NoRound(aItens[nPos][aScan(aItens[nPos],{|x| Alltrim(x[1]) == "C6_QTDVEN"})][2]/2,TamSX3("C6_QTDVEN")[2])
						Endif	
					Endif	

					If !lPVRotAuto
						// atualiza array com os novos valores
						For nCntItem:=1 To Len(aCamposPed)
							If aCamposPed[nCntItem][4] == "DIVIDE"
								If aScan(aItens[nPos],{|x| Alltrim(x[1]) == aCamposPed[nCntItem][1]}) > 0 // verifica se o campo existe no array aitens
									aCamposPed[nCntItem][2] := aItens[nPos][aScan(aItens[nPos],{|x| Alltrim(x[1]) == aCamposPed[nCntItem][1]})][2] // guarda o valor total
									aCamposPed[nCntItem][3] := NoRound(aCamposPed[nCntItem][2]/2,TamSX3(aCamposPed[nCntItem][1])[2]) // divide por 2
								Endif	
							Endif	
						Next	
					Endif	
					/*
					aCamposPed[(nPos1:=aScan(aCamposPed,{|x| Alltrim(x[1])=="C6_QTDVEN"}))][2] := aItens[nPos][aScan(aItens[nPos],{|x| Alltrim(x[1]) == "C6_QTDVEN"})][2] // divide por 2
					aCamposPed[nPos1][3] := NoRound(aCamposPed[nPos1][2]/2,TamSX3(aCamposPed[nPos1][1])[2])
					aCamposPed[(nPos1:=aScan(aCamposPed,{|x| Alltrim(x[1])=="C6_VALOR"}))][2] := aItens[nPos][aScan(aItens[nPos],{|x| Alltrim(x[1]) == "C6_VALOR"})][2] // divide por 2
					aCamposPed[nPos1][3] := NoRound(aCamposPed[nPos1][2]/2,TamSX3(aCamposPed[nPos1][1])[2])
					If aScan(aItens[nPos],{|x| Alltrim(x[1]) == "C6_VALDESC"}) > 0
					aCamposPed[(nPos1:=aScan(aCamposPed,{|x| Alltrim(x[1])=="C6_VALDESC"}))][2] := aItens[nPos][aScan(aItens[nPos],{|x| Alltrim(x[1]) == "C6_VALDESC"})][2] // divide por 2
					aCamposPed[nPos1][3] := NoRound(aCamposPed[nPos1][2]/2,TamSX3(aCamposPed[nPos1][1])[2])
					Endif
					If aScan(aItens[nPos],{|x| Alltrim(x[1]) == "C6_UNSVEN"}) > 0	
					aCamposPed[(nPos1:=aScan(aCamposPed,{|x| Alltrim(x[1])=="C6_UNSVEN"}))][2] := aItens[nPos][aScan(aItens[nPos],{|x| Alltrim(x[1]) == "C6_UNSVEN"})][2] // divide por 2
					aCamposPed[nPos1][3] := NoRound(aCamposPed[nPos1][2]/2,TamSX3(aCamposPed[nPos1][1])[2]) //ConvUm(aItens[nPos][aScan(aItens[nPos],{|x| Alltrim(x[1]) == "C6_PRODUTO"})][2],aCamposPed[aScan(aCamposPed,{|x| Alltrim(x[1])=="C6_QTDVEN"})][3],0,2)
					Endif	
					*/
					// salva quantidade original, para o caso de exclusao da carga, restaurar esta quantidade no pv
					If aScan(aItens[nPos],{|x| Alltrim(x[1]) == "C6_ZQTDSIF"}) > 0
						aItens[nPos][aScan(aItens[nPos],{|x| Alltrim(x[1]) == "C6_ZQTDSIF"})][2] := aItens[nPos][aScan(aItens[nPos],{|x| Alltrim(x[1]) == "C6_QTDVEN"})][2]
					Endif

					If lPVRotAuto	
						aItens[nPos][aScan(aItens[nPos],{|x| Alltrim(x[1]) == "C6_QTDVEN"})][2] := nQtdPed//aSif[nCnt][5] //nQtdPed //aSif[nCnt][5] // qte
						aItens[nPos][aScan(aItens[nPos],{|x| Alltrim(x[1]) == "C6_VALOR"})][2] := A410Arred(aItens[nPos][aScan(aItens[nPos],{|x| Alltrim(x[1]) == "C6_QTDVEN"})][2]*aItens[nPos][aScan(aItens[nPos],{|x| Alltrim(x[1]) == "C6_PRCVEN"})][2],"C6_VALOR") // valor
					Endif	

					If !lPVRotAuto
						// marca o item para ser processado, sem usar rotina automatica
						aItens[nPos][Len(aItens[nPos])][2] := .T. 

						// grava os campos com os novos valores
						For nCntItem:=1 To Len(aCamposPed)
							If aCamposPed[nCntItem][3] > 0 // somente altera os campos que foram calculados
								If (nPos1:=aScan(aItens[nPos],{|x| Alltrim(x[1]) == Alltrim(aCamposPed[nCntItem][1])})) > 0
									aItens[nPos][nPos1][2] := aCamposPed[nCntItem][3]
								Endif
							Endif
						Next			
					Endif	

					If lPVRotAuto
						// prepara variavel para proximo item
						nQtdPed := aItens[nPos][aScan(aItens[nPos],{|x| Alltrim(x[1]) == "C6_ZQTDSIF"})][2]-nQtdPed
					Endif	
				Endif	
			Else
				// deve-se pesquisar o array aitens dentro de um For, pois o campo EE8_FATIT pode estar em posicoes diferentes para o array aItens,
				// desta forma, para cada elemento do array, primeiro acha onde estah o campo EE8_FATIT, em seguida compara se para este elemento o 
				// conteudo eh igual ao do aSif
				For nCntFatIt:=1 To Len(aItens)
					If (nPos:=aScan(aItens[nCntFatIt],{|x| Alltrim(x[1]) == "EE8_FATIT"})) > 0
						If aItens[nCntFatIt][nPos][2] == aSif[nCnt][3]
							// zera campos de valor do array
							//aEval(aCamposExp,{|x,y| aCamposExp[y][2]:=0,aCamposExp[y][3]:=0})

							/*
							If aItens[nCntFatIt][aScan(aItens[nCntFatIt],{|x| Alltrim(x[1]) == "EE8_SLDINI"})][2] > 1.0
							nQtdPed := Int(aItens[nCntFatIt][aScan(aItens[nCntFatIt],{|x| Alltrim(x[1]) == "EE8_SLDINI"})][2]/2)	
							Else
							nQtdPed := NoRound(aItens[nCntFatIt][aScan(aItens[nCntFatIt],{|x| Alltrim(x[1]) == "EE8_SLDINI"})][2]/2,TamSX3("EE8_SLDINI")[2])
							Endif	
							*/
							/*
							// atualiza array com os novos valores
							For nCntItem:=1 To Len(aCamposExp)
							If aCamposExp[nCntItem][1] == "EE8_QE"
							Loop
							Endif		
							If aCamposExp[nCntItem][4] == "DIVIDE"
							If aScan(aItens[nCntFatIt],{|x| Alltrim(x[1]) == aCamposExp[nCntItem][1]}) > 0 // verifica se o campo existe no array aitens
							aCamposExp[nCntItem][2] := aItens[nCntFatIt][aScan(aItens[nCntFatIt],{|x| Alltrim(x[1]) == aCamposExp[nCntItem][1]})][2] // guarda o valor total
							aCamposExp[nCntItem][3] := NoRound(aCamposExp[nCntItem][2]/2,TamSX3(aCamposExp[nCntItem][1])[2]) // divide por 2
							Endif	
							Endif	
							If aCamposExp[nCntItem][4] == "CALCULA" .and. aCamposExp[nCntItem][1] == "EE8_QTDEM1" // total de caixas, nao pode somente dividir por 2, 
							// pois nao tem 1/2 caixa, neste caso, divide por 2 e arredonda para o proximo inteiro 
							aCamposExp[nCntItem][2] := aItens[nCntFatIt][aScan(aItens[nCntFatIt],{|x| Alltrim(x[1]) == aCamposExp[nCntItem][1]})][2] // guarda o valor total
							If aCamposExp[nCntItem][1] == "EE8_QTDEM1" .and. aCamposExp[nCntItem][2] == 1 // quantidade igual a 1, replica a mesma quantidade para o outro item a ser criado
							aCamposExp[nCntItem][3] := 1
							// grava tambem o campo ee8_qe com o mesmo conteudo do ee8_sldini
							// obs: sempre deixar o campo ee8_qe depois do ee8_sldini no array acamposexp, para esta regra funcionar
							aCamposExp[aScan(aCamposExp,{|x| Alltrim(x[1])=="EE8_QE"})][2] := aCamposExp[aScan(aCamposExp,{|x| Alltrim(x[1])=="EE8_SLDINI"})][2]
							aCamposExp[aScan(aCamposExp,{|x| Alltrim(x[1])=="EE8_QE"})][3] := aCamposExp[aScan(aCamposExp,{|x| Alltrim(x[1])=="EE8_SLDINI"})][3]
							Else	
							If Mod(aItens[nCntFatIt][aScan(aItens[nCntFatIt],{|x| Alltrim(x[1]) == "EE8_QTDEM1"})][2],2) != 0
							aCamposExp[nCntItem][3] := Int(aCamposExp[nCntItem][2]/2)+1 // garantir que nunca vai ficar uma fracao e garantir a quantidade total sendo dividida
							Else
							aCamposExp[nCntItem][3] := aCamposExp[nCntItem][2]/2
							Endif
							Endif	
							Endif		
							Next	
							*/
							// salva quantidade original, para o caso de exclusao da carga, restaurar esta quantidade no pv
							If aSif[nCnt][7]
								aItens[nCntFatIt][aScan(aItens[nCntFatIt],{|x| Alltrim(x[1]) == "EE8_ZQTDSI"})][2] := aItens[nCntFatIt][aScan(aItens[nCntFatIt],{|x| Alltrim(x[1]) == "EE8_SLDINI"})][2]
								aItens[nCntFatIt][aScan(aItens[nCntFatIt],{|x| Alltrim(x[1]) == "EE8_SLDINI"})][2] := aSif[nCnt][5]//nQtdPed //aSif[nCnt][5] // qte
								// Alteração Carneiro 18/01
								//aItens[nCntFatIt][aScan(aItens[nCntFatIt],{|x| Alltrim(x[1]) == "EE8_SLDATU"})][2] := aSif[nCnt][5]
							Endif

							If !aSif[nCnt][7] .and. aSif[nCnt][15]	
								// busca quantidade do aqtdlib neste caso, pois a quantidade no asif nao estah agrupada para este item do pedido e no aqtdlib estah agrupada
								If (nPosQtd:=aScan(aQtdLib,{|x| Alltrim(x[1])+Alltrim(x[2])+Alltrim(x[3])==Alltrim(aSif[nCnt][1])+Alltrim(aSif[nCnt][2])+Alltrim(aSif[nCnt][3])})) > 0
									nQtdAlt := aQtdLib[nPosQtd][4]
									aItens[nCntFatIt][aScan(aItens[nCntFatIt],{|x| Alltrim(x[1]) == "EE8_ZQTDHI"})][2] := aItens[nCntFatIt][aScan(aItens[nCntFatIt],{|x| Alltrim(x[1]) == "EE8_SLDINI"})][2]
									aItens[nCntFatIt][aScan(aItens[nCntFatIt],{|x| Alltrim(x[1]) == "EE8_SLDINI"})][2] := nQtdAlt
									//aItens[nCntFatIt][aScan(aItens[nCntFatIt],{|x| Alltrim(x[1]) == "EE8_SLDATU"})][2] := nQtdAlt
								Endif
							Endif		

							// prepara variavel para proximo item
							//nQtdPed := aItens[nCntFatIt][aScan(aItens[nCntFatIt],{|x| Alltrim(x[1]) == "EE8_ZQTDSI"})][2]-nQtdPed

							// marca o item para ser processado, sem usar rotina automatica
							//aItens[nCntFatIt][Len(aItens[nCntFatIt])][2] := .T. 
							/*
							// grava os campos com os novos valores
							For nCntItem:=1 To Len(aCamposExp)
							If aCamposExp[nCntItem][3] > 0 // somente altera os campos que foram calculados
							If (nPos1:=aScan(aItens[nCntFatIt],{|x| Alltrim(x[1]) == Alltrim(aCamposExp[nCntItem][1])})) > 0
							aItens[nCntFatIt][nPos1][2] := aCamposExp[nCntItem][3]
							Endif
							Endif
							Next			
							*/
							/*
							// atualiza demais campos
							If (nPos1:=aScan(aItens[nCntFatIt],{|x| Alltrim(x[1]) == "EE8_DTPREM"})) > 0
							If !Empty(aItens[nCntFatIt][nPos1][2]) .and. aItens[nCntFatIt][nPos1][2] < dDataBase
							aItens[nCntFatIt][nPos1][2] := dDataBase
							Endif	
							Endif
							If (nPos1:=aScan(aItens[nCntFatIt],{|x| Alltrim(x[1]) == "EE8_DTENTR"})) > 0
							If !Empty(aItens[nCntFatIt][nPos1][2]) .and. aItens[nCntFatIt][nPos1][2] < dDataBase
							aItens[nCntFatIt][nPos1][2] := dDataBase
							Endif	
							Endif	
							*/

							// sai do For, pois jah encontrou o item correto no array, nao pode mais incrementar o contador nCntFatIt, 
							// pois este contador serah usado para se copiar este item do array, logo abaixo no fonte
							Exit
						Endif
					Endif		
				Next
			Endif
			aSif[nCnt][9] := .T. // marca item como jah processado
			nCntSav := nCnt
			// em seguida inclui novo item com este mesmo pedido e item
			While nCnt <= Len(aSif)	
				nCnt++
				If nCnt > Len(aSif)
					Exit
				Endif	
				If aSif[nCnt][7]
					// verifica se item jah foi processado 
					If aSif[nCnt][9]
						Loop
					Endif	
					// adiciona item no pedido, para mesmo produto e item
					If aSif[nCnt][1]+aSif[nCnt][2]+aSif[nCnt][3] == cChave
						aAdd(aItens,aClone(aItens[IIf(!lPedExp,nPos,nCntFatIt)]))
						cItem := Soma1(cItem)

						If !lPedExp
							// altera campos para novo item
							cCfo := TAS02Cfo(aCab[aScan(aCab,{|x| Alltrim(x[1]) == "C5_CLIENTE"})][2],aCab[aScan(aCab,{|x| Alltrim(x[1]) == "C5_LOJACLI"})][2],aSif[nCnt][08])

							//aItens[Len(aItens)][1][3] := Soma1(cItem) // item linpos
							aItens[Len(aItens)][aScan(aItens[Len(aItens)],{|x| Alltrim(x[1]) == "C6_ITEM"})][2] := cItem // item
							If lPVRotAuto
								aItens[Len(aItens)][aScan(aItens[Len(aItens)],{|x| Alltrim(x[1]) == "C6_QTDVEN"})][2] := nQtdPed//aSif[nCnt][5]//nQtdPed //aSif[nCnt][5] // quant
								aItens[Len(aItens)][aScan(aItens[Len(aItens)],{|x| Alltrim(x[1]) == "C6_VALOR"})][2] := A410Arred(aItens[Len(aItens)][aScan(aItens[Len(aItens)],{|x| Alltrim(x[1]) == "C6_QTDVEN"})][2]*aItens[Len(aItens)][aScan(aItens[Len(aItens)],{|x| Alltrim(x[1]) == "C6_PRCVEN"})][2],"C6_VALOR") // valor
							Endif	
							aItens[Len(aItens)][aScan(aItens[Len(aItens)],{|x| Alltrim(x[1]) == "C6_TES"})][2] := aSif[nCnt][8] // tes
							aItens[Len(aItens)][aScan(aItens[Len(aItens)],{|x| Alltrim(x[1]) == "C6_CF"})][2] := cCfo
							If aScan(aItens[Len(aItens)],{|x| Alltrim(x[1]) == "C6_ZQTDSIF"}) > 0
								aItens[Len(aItens)][aScan(aItens[Len(aItens)],{|x| Alltrim(x[1]) == "C6_ZQTDSIF"})][2] := 0
							Endif
							If aScan(aItens[Len(aItens)],{|x| Alltrim(x[1]) == "C6_ZGERSIF"}) > 0
								aItens[Len(aItens)][aScan(aItens[Len(aItens)],{|x| Alltrim(x[1]) == "C6_ZGERSIF"})][2] := "S"
							Endif	
							//aItens[Len(aItens)][aScan(aItens[Len(aItens)],{|x| Alltrim(x[1]) == "C6_QTDLIB"})][2] := aSif[nCnt][5] // quant, obs: nao libera o pedido neste momento, pois tem a carga para ser associada ao sc9

							If !lPVRotAuto
								cOrigem := RetFldProd(aItens[Len(aItens)][aScan(aItens[Len(aItens)],{|x| Alltrim(x[1]) == "C6_PRODUTO"})][2],"B1_ORIGEM")
								If Empty(cOrigem)
									cOrigem := GetAdvFVal("SB1","B1_ORIGEM",xFilial("SB1")+aItens[Len(aItens)][aScan(aItens[Len(aItens)],{|x| Alltrim(x[1]) == "C6_PRODUTO"})][2],1,"")
								Endif
								cSitTrib := GetAdvFVal("SF4","F4_SITTRIB",xFilial("SF4")+aItens[Len(aItens)][aScan(aItens[Len(aItens)],{|x| Alltrim(x[1]) == "C6_TES"})][2],1,"")
								//cCodLan := GetAdvFVal("SF4","F4_CODLAN",xFilial("SF4")+aItens[Len(aItens)][aScan(aItens[Len(aItens)],{|x| Alltrim(x[1]) == "C6_TES"})][2],1,"")
								aItens[Len(aItens)][aScan(aItens[Len(aItens)],{|x| Alltrim(x[1]) == "C6_CLASFIS"})][2] := cOrigem+cSitTrib
								//aItens[Len(aItens)][aScan(aItens[Len(aItens)],{|x| Alltrim(x[1]) == "C6_CODLAN"})][2] := cCodLan
							Endif	

							If !lPVRotAuto
								// grava os campos com os novos valores
								For nCntItem:=1 To Len(aCamposPed)
									If (nPos1:=aScan(aItens[Len(aItens)],{|x| Alltrim(x[1]) == Alltrim(aCamposPed[nCntItem][1])})) > 0
										If aCamposPed[nCntItem][4] == "DIVIDE"
											// para garantir que todo o saldo do campo vai estar no novo item, grava o conteudo original do campo - a quantidade que ficou no item original
											aItens[Len(aItens)][nPos1][2] := aCamposPed[nCntItem][2]-aCamposPed[nCntItem][3]
										Else // demais campos, grava o que jah estiver calculado no array
											aItens[Len(aItens)][nPos1][2] := aCamposPed[nCntItem][3]
										Endif	
									Endif
								Next			
							Endif	
						Else
							// no EEC o campo de item eh gravado sem zeros a esquerda e com espacos, entao, deve-se tratar a variavel
							cItem := Val(RetAsc(cItem,2,.F.)) //Val(cItem)
							//cItem := Padl(Alltrim(Str(cItem)),TamSX3("EE8_SEQUEN")[1])
							// alguns registros estao gravados com o campo 'sequen' com espacos a esquerda, outros com zeros, entao trata a variavel
							cItem := Padl(Alltrim(Str(cItem)),TamSX3("EE8_SEQUEN")[1],IIf(Subs(cItemSav,1,1) == " "," ","0"))

							aItens[Len(aItens)][aScan(aItens[Len(aItens)],{|x| Alltrim(x[1]) == "EE8_SEQUEN"})][2] := cItem // item 
							aItens[Len(aItens)][aScan(aItens[Len(aItens)],{|x| Alltrim(x[1]) == "LINPOS"})][3] := cItem
							// atualiza campos do novo item
							aItens[Len(aItens)][aScan(aItens[Len(aItens)],{|x| Alltrim(x[1]) == "EE8_SLDINI"})][2] := aSif[nCnt][5]//nQtdPed //aSif[nCnt][5] // quant
							// Alteração Carneiro 18/01
							//aItens[Len(aItens)][aScan(aItens[Len(aItens)],{|x| Alltrim(x[1]) == "EE8_SLDATU"})][2] := aSif[nCnt][5]
							aItens[Len(aItens)][aScan(aItens[Len(aItens)],{|x| Alltrim(x[1]) == "EE8_TES"})][2] := aSif[nCnt][8] // tes
							If aScan(aItens[Len(aItens)],{|x| Alltrim(x[1]) == "EE8_FATIT"}) > 0
								aItens[Len(aItens)][aScan(aItens[Len(aItens)],{|x| Alltrim(x[1]) == "EE8_FATIT"})][2] := "" // zera o item do pedido, pois serah gerado um novo item pelo padrao
							Endif	

							cCfo := TAS02Cfo(aCab[aScan(aCab,{|x| Alltrim(x[1]) == "EE7_IMPORT"})][2],aCab[aScan(aCab,{|x| Alltrim(x[1]) == "EE7_IMLOJA"})][2],aSif[nCnt][08])
							aItens[Len(aItens)][aScan(aItens[Len(aItens)],{|x| Alltrim(x[1]) == "EE8_CF"})][2] := cCfo
							If Subs(aItens[Len(aItens)][aScan(aItens[Len(aItens)],{|x| Alltrim(x[1]) == "EE8_CF"})][2],1,1) != "7"
								aItens[Len(aItens)][aScan(aItens[Len(aItens)],{|x| Alltrim(x[1]) == "EE8_CF"})][2] := "7"+Subs(aItens[Len(aItens)][aScan(aItens[Len(aItens)],{|x| Alltrim(x[1]) == "EE8_CF"})][2],2)
							Endif	
							aItens[Len(aItens)][aScan(aItens[Len(aItens)],{|x| Alltrim(x[1]) == "EE8_ZQTDSI"})][2] := 0
							aItens[Len(aItens)][aScan(aItens[Len(aItens)],{|x| Alltrim(x[1]) == "EE8_ZGERSI"})][2] := "S"

							If GetMv("MGF_OEPESO",,.F.) 
								If lFis45
									aPesos := TotCaixas(Carga,aSif[nCnt][4],aCab[aScan(aCab,{|x| Alltrim(x[1]) == "EE7_PEDFAT"})][2],aItens[Len(aItens)][aScan(aItens[Len(aItens)],{|x| Alltrim(x[1]) == "EE8_COD_I"})][2],cSifFil)
								Else
									aPesos := TotCaixas(Carga,"",aCab[aScan(aCab,{|x| Alltrim(x[1]) == "EE7_PEDFAT"})][2],aItens[Len(aItens)][aScan(aItens[Len(aItens)],{|x| Alltrim(x[1]) == "EE8_COD_I"})][2],"")
								Endif

								aItens[Len(aItens)][aScan(aItens[Len(aItens)],{|x| Alltrim(x[1]) == "EE8_QTDEM1"})][2] := IIf(aPesos[1]==0,aItens[Len(aItens)][aScan(aItens[Len(aItens)],{|x| Alltrim(x[1]) == "EE8_QTDEM1"})][2],aPesos[1]) 
								aItens[Len(aItens)][aScan(aItens[Len(aItens)],{|x| Alltrim(x[1]) == "EE8_PSLQUN"})][2] := 1
								aItens[Len(aItens)][aScan(aItens[Len(aItens)],{|x| Alltrim(x[1]) == "EE8_PSLQTO"})][2] := aPesos[4]
								aItens[Len(aItens)][aScan(aItens[Len(aItens)],{|x| Alltrim(x[1]) == "EE8_PSBRUN"})][2] := IIf(aPesos[4]==0,aItens[Len(aItens)][aScan(aItens[Len(aItens)],{|x| Alltrim(x[1]) == "EE8_PSBRUN"})][2],aPesos[3]/aPesos[4])
								aItens[Len(aItens)][aScan(aItens[Len(aItens)],{|x| Alltrim(x[1]) == "EE8_PSBRTO"})][2] := IIf(aPesos[4]==0,aItens[Len(aItens)][aScan(aItens[Len(aItens)],{|x| Alltrim(x[1]) == "EE8_PSBRTO"})][2],aPesos[3]/aPesos[4]*aPesos[4])
								aItens[Len(aItens)][aScan(aItens[Len(aItens)],{|x| Alltrim(x[1]) == "EE8_QE"})][2] := IIf(aPesos[4]==0,aItens[Len(aItens)][aScan(aItens[Len(aItens)],{|x| Alltrim(x[1]) == "EE8_QE"})][2],aPesos[4])
							Endif	
						Endif	

						// atualiza o item gerado no PV, no array a Sif
						aSif[nCnt][3] := cItem // grava numero do novo item. Obs: para pedido de exportacao, vai ficar gravado o item do pedido de exportacao, depois serah substituido pelo item do pedido de venda
						aSif[nCnt][9] := .T. // marca item como jah processado
					Else
						// retorna 1 na variavel nCnt, para processar item anterior, pois o controle estah dentro de um For e a variavel serah incrementada novamente
						nCnt--
						Exit	
					Endif	
				Else
					If aSif[nCnt][15] // quando for alteracao de quantidade, retorna variavel nCnt para processar este item
						// retorna 1 na variavel nCnt, para processar item anterior, pois o controle estah dentro de um For e a variavel serah incrementada novamente
						nCnt--
						Exit	
					Endif	
				Endif	
			Enddo
		Else
			// se for exclusao de itens do exportacao, apenas grava a variavel nCntSav, para uso posteriormente
			If aSif[nCnt][17]
				nCntSav := nCnt
			Endif	
		Endif
	Next	

	If Len(aCab) > 0 .and. Len(aItens) > 0
		lMsErroAuto := .F.
		If !lPedExp	
			cMensTime := "Inicio MATA410 - Pedido de Venda: "+aCab[aScan(aCab,{|x| Alltrim(x[1]) == "C5_NUM"})][2]
			ConOut(cMensTime)
			cLogTime += cMensTime+CRLF

			If lPVRotAuto
				MSExecAuto({|x,y,z| Mata410(x,y,z)},aCab,aItens,4)
			Endif

			If !lPVRotAuto
				aRet := GravaPed(aCab,aItens,"1",Carga,"SC6",lPedExp)
				lContinua := aRet[1]
			Endif	

			cMensTime := "Termino MATA410 - Pedido de Venda: "+aCab[aScan(aCab,{|x| Alltrim(x[1]) == "C5_NUM"})][2]
			ConOut(cMensTime)
			cLogTime += cMensTime+CRLF

			If lPVRotAuto
				cMensTime := "Resultado lMsErroAuto MATA410: "+iif(lMsErroAuto,".T.",".F.")+" - Pedido de Venda: "+aCab[aScan(aCab,{|x| Alltrim(x[1]) == "C5_NUM"})][2]
			Endif
			If !lPVRotAuto
				cMensTime := "Resultado lMsErroAuto MATA410: "+iif(!lContinua,".T.",".F.")+" - Pedido de Venda: "+aCab[aScan(aCab,{|x| Alltrim(x[1]) == "C5_NUM"})][2]
			Endif	
			ConOut(cMensTime)
			cLogTime += cMensTime+CRLF
			cLogTime += CRLF

			ConOut("")
		Else	
			//ConOut("Inicio EECAP100 - Pedido de Exportação: "+aCab[aScan(aCab,{|x| Alltrim(x[1]) == "EE7_PEDIDO"})][2]+" - Pedido de Venda: "+aCab[aScan(aCab,{|x| Alltrim(x[1]) == "EE7_PEDFAT"})][2])

			// necessario chamar a rotina eecap100 via execauto, dentro de um startjob, pois a rotina tem diversos pontos que mostra tela usando a funcao msgstop e com a chamada via
			// startjob, alguns destes pontos tem tratamento via variavel, para nao executar a msgstop, quando chamada via job.
			// outros pontos que sao mostrados tela devido a msgstop foram identificados em gatilhos, e foi inserido uma condicao para que o gatilho nao seja acionado, quando
			// chamado por esta rotina.
			//aRet := StartJob("U_TAS02EECAP100",GetEnvServer(),.T.,aCab,aItens,aSif[nCntSav][1],Carga:Cabecalho:Ordem_Embarque,aSif[nCntSav][2],aCab[aScan(aCab,{|x| Alltrim(x[1]) == "EE7_PEDIDO"})][2])
			aRet := U_TAS02EECAP100(aCab,aItens,aSif[nCntSav][1],Carga:Cabecalho:Ordem_Embarque,aSif[nCntSav][2],aCab[aScan(aCab,{|x| Alltrim(x[1]) == "EE7_PEDIDO"})][2])
		Endif		

		If !lPedExp	
			If lMsErroAuto .or. lErro
				cFileLog := NomeAutoLog()
				If !Empty(cFileLog)
					cMens := "Problema na execução da alteração do Pedido de Venda, Filial: "+aSif[nCntSav][1]+", Carga: "+Carga:Cabecalho:Ordem_Embarque+", Pedido: "+aSif[nCntSav][2]
					cMens := cMens+CRLF+MemoRead(cFileLog)
				Endif
				lContinua := .F.
				ConOut(cMens)
				aRet := {}
				aAdd(aRet,lContinua)
				aAdd(aRet,cMens)				
			Else
				If lPVRotAuto
					If GetMv("MGF_OECPUS",,.T.)
						GrvCamposUser(aCab,aItens,.F.,"C6_ZGERSIF","C6_ZQTDSIF","C6_ZQTDHIS")
					Endif	
				Endif	
			Endif
			/*
			// se for pedido de exportacao, atualiza o campo de item do ee8	
			If lContinua
			If !Empty(SC5->C5_PEDEXP)
			aRet := GrvItPVEE8(aCab,aItens,aSif,SC5->C5_PEDEXP,Carga,lProcOff)
			lContinua := aRet[1]
			Endif
			Endif		
			*/
		Else
			// // trecho abaixo foi tratado apos a alteracao do pv ( na funcao GrvItPVEE8 ), ao inves de ser tratado apos alteracao do pedido de exportacao

			lContinua := aRet[1]
			cMens := aRet[2]

			If !lContinua
				ConOut(cMens)
			Else
				// atualiza o item correto do pedido de venda no array asif	
				EE8->(dbSetOrder(1))
				For nCnt:=1 To Len(aSif)
					If !lContinua
						Exit
					Endif	
					// verifica se item tem sif´s diferente e se jah foi processado
					If aSif[nCnt][7] .and. aSif[nCnt][9]
						// verifica se o tamanho do campo de item eh maior que 2 digitos, indicando que o conteudo atual do array eh o item do pedido de exportacao
						If Len(aSif[nCnt][3]) > 2
							// encontra item na EE8 para pegar o item correto do pedido de venda
							If EE8->(dbSeek(xFilial("EE8")+EE7->EE7_PEDIDO))
								While EE8->(!Eof()) .and. xFilial("EE8")+EE7->EE7_PEDIDO == EE8->EE8_FILIAL+EE8->EE8_PEDIDO
									If aSif[nCnt][3] == EE8->EE8_SEQUEN
										If !Empty(EE8->EE8_FATIT)
											aSif[nCnt][3] := EE8->EE8_FATIT
											// estornar liberacao do novo item criado, para item ser liberado depois dentro desta mesma rotina
											aRet := EstornaSC9(aSif[nCnt][2],aSif[nCnt][3],,Carga)
											lContinua := aRet[1]
											//cONOUT("ENCONTROU ITEM CORRETO EE8: "+EE8->EE8_FATIT)
										Else
											cMens := "Problema na execução da alteração do Pedido de Exportação, campo EE8_FATIT em branco, Filial: "+aSif[nCnt][1]+", Carga: "+Carga:Cabecalho:Ordem_Embarque+", Pedido: "+aSif[nCnt][2]+", Pedido de Exportação: "+aCab[aScan(aCab,{|x| Alltrim(x[1]) == "EE7_PEDIDO"})][2]
											lContinua := .F.
											ConOut(cMens)
											aRet := {}
											aAdd(aRet,lContinua)
											aAdd(aRet,cMens)				
										Endif	
										Exit
									Endif
									EE8->(dbSkip())
								Enddo
							Endif
						Endif
					Endif
				Next						
			Endif	

		Endif	
	Endif	

	// insere no array aqtdlib as novas linhas criadas no pedido e altera as quantidades dos itens que foram modificados
	If lContinua
		// se estiver processando pedido de exportacao, nao atualiza neste momento, pois serah atualizado na alteracao do pv
		//If !lExp
		AltPVIQLib(aCab,aItens,aSif,Carga,@aQtdLib,lPedExp)
		//Endif	
	Endif		

	If Len(aRet) == 0
		aRet := {.T.,""}
	Endif

	aEval(aArea,{|x| RestArea(x)})

Return(aRet)	


// insere no array aqtdlib as novas linhas criadas no pedido e altera as quantidades dos itens que foram modificados
// fis45
Static Function AltPVIQLib(aCab,aItens,aSif,Carga,aQtdLib,lPedExp)

	Local aArea := {SB1->(GetArea()),GetArea()}
	Local nCnt := 0
	Local nPos := 0
	Local aDados := {}
	Local cLocal := ""
	Local nCnt1 := 0

	//If lContinua
	SB1->(dbSetOrder(1))

	For nCnt:=1 To Len(aSif)
		// soh processa o pedido que estah sendo alterado
		If !aSif[nCnt][2] == IIf(!lPedExp,aCab[aScan(aCab,{|x| Alltrim(x[1]) == "C5_NUM"})][2],aCab[aScan(aCab,{|x| Alltrim(x[1]) == "EE7_PEDFAT"})][2])
			Loop
		Endif	
		//conout("chequei antes asif")
		If aSif[nCnt][7]
			nPos := aScan(aQtdLib,{|x| Alltrim(x[1])+Alltrim(x[2])+Alltrim(x[3])==Alltrim(aSif[nCnt][1])+Alltrim(aSif[nCnt][2])+Alltrim(aSif[nCnt][3])})
			//conout("npos: "+str(npos))
			If Empty(nPos)
				//conout("antes adados: "+aSif[nCnt][2]+" "+aSif[nCnt][3])
				aDados := DadosSC6(aSif[nCnt][2],aSif[nCnt][3],.F.)
				//conout("len adados"+str(len(adados)))
				If Len(aDados) > 0
					If SB1->(dbSeek(xFilial("SB1")+aDados[1]))
						cLocal := aDados[8]
						If Empty(cLocal)
							cLocal := RetFldProd(SB1->B1_COD,"B1_LOCPAD")
							If Empty(cLocal)
								cLocal := "01"
							Endif	
						Endif	

						aAdd(aQtdLib,{;
						""/*1-filial*/,;		
						""/*2-pedido*/,;		
						""/*3-item*/,;		
						0/*4-qtd liberada*/,;			
						0/*5-recno sc6*/,;			
						""/*6-produto*/,;		
						{}/*7-aSaldo - se lote*/,;		
						""/*8-lote*/,;		
						cTod("")/*9-validade lote Taura*/,;	
						cTod("")/*10-validade lote ERP*/,;	
						0/*11-recno sb8*/,;			
						""/*12-local*/,;		
						.F./*13-lLote*/,;
						""/*14-carga*/,;	
						0/*15-qtd pedido*/,;
						.F./*16-qtd do pedido diferente da liberada*/,;
						.F./*17-Pedido de exportacao*/; 
						})

						aQtdLib[Len(aQtdLib)][1] := aSif[nCnt][1] // filial
						aQtdLib[Len(aQtdLib)][2] := aSif[nCnt][2] // pedido
						aQtdLib[Len(aQtdLib)][3] := aSif[nCnt][3] // item
						aQtdLib[Len(aQtdLib)][4] := aSif[nCnt][5] // qtd liberada
						aQtdLib[Len(aQtdLib)][5] := aDados[2] // recno_sc6
						aQtdLib[Len(aQtdLib)][6] := aDados[1] // produto
						aQtdLib[Len(aQtdLib)][12] := cLocal
						aQtdLib[Len(aQtdLib)][14] := Carga:Cabecalho:Ordem_Embarque
						aQtdLib[Len(aQtdLib)][17] := aDados[7] // pedido de exportacao
						//conout("item novo pv: "+aSif[nCnt][3])
					Endif
				Endif 
			Else 
				// apenas atualiza quantidade liberada no item
				aQtdLib[nPos][4] := aSif[nCnt][5] // qtd liberada
			Endif	 		
		Endif	
	Next
	//Endif		

	aEval(aArea,{|x| RestArea(x)})

Return()


User Function TAS02EECAP100(aCab,aItens,cFil,cCarga,cPed,cPedExp,aEE8Del)
	// obs: nao retirar esta funcao de user function, pois tem gatilhos usando ela na condicao
    Local cError     := ''
	Local aArea := {EE8->(GetArea()),SC6->(GetArea()),GetArea()}
	Local aAreaSA1 := {SA1->(GetArea())}
	Local aRet := {}
	Local cFileLog := ""
	Local cMens := ""
	Local lRet := .F.
	Local nCnt := 0
	Local lContinua := .T.
	Local aErro := {}
	Local cErro := ""

	Private lMsHelpAuto := .T. // Determina se as mensagens de help devem ser direcionadas para o arq. de log
	Private lMsErroAuto := .F. // Determina se houve alguma inconsistência na execução da rotina 
	Private lSched := .T.
	Private lEE7Auto := .T.
	Private lAutoErrNoFile := .T. // Precisa estar como .T. para GetAutoGRLog() retornar o array com erros

	Default aEE8Del := {}

	If aScan(aRegEE7,EE7->(Recno())) == 0
		aAdd(aRegEE7,EE7->(Recno()))
	Endif	
	SA1->(dbSetOrder(1))
	If SA1->(dbSeek(xFilial("SA1")+EE7->EE7_CLIENT+EE7->EE7_CLLOJA))
		If aScan(aRegSA1,SA1->(Recno())) == 0
			aAdd(aRegSA1,SA1->(Recno()))
		Endif	
	Endif	
	If SA1->(dbSeek(xFilial("SA1")+EE7->EE7_IMPORT+EE7->EE7_IMLOJA))
		If aScan(aRegSA1,SA1->(Recno())) == 0
			aAdd(aRegSA1,SA1->(Recno()))
		Endif	
	Endif	
	aEval(aAreaSA1,{|x| RestArea(x)})

	If GetMv("MGF_OELKEE",,.F.)
		aRet := LockEEC("EE7",1,cFil,cCarga,cPed,cPedExp,cPedExp)
		lContinua := aRet[1]
		cMens := aRet[2] 
		If lContinua
			aRet := LockEEC("EEC",1,cFil,cCarga,cPed,cPedExp,cPedExp)
			lContinua := aRet[1]
			cMens := aRet[2] 
		Endif	
		If lContinua
			If !Empty(EE7->EE7_CLIENT)
				aRet := LockEEC("SA1",1,cFil,cCarga,cPed,cPedExp,EE7->EE7_CLIENT+EE7->EE7_CLLOJA)
				lContinua := aRet[1]
				cMens := aRet[2] 
			Endif	
		Endif	
		If lContinua
			If !Empty(EE7->EE7_IMPORT)
				aRet := LockEEC("SA1",1,cFil,cCarga,cPed,cPedExp,EE7->EE7_IMPORT+EE7->EE7_IMLOJA)
				lContinua := aRet[1]
				cMens := aRet[2] 
			Endif	
		Endif	
		If lContinua
			EE8->(dbSetOrder(1))
			SC6->(dbSetOrder(1))
			If EE8->(dbSeek(xFilial("EE8")+EE7->EE7_PEDIDO))
				While EE8->(!Eof()) .and. xFilial("EE8")+EE7->EE7_PEDIDO == EE8->EE8_FILIAL+EE8->EE8_PEDIDO
					If SC6->(dbSeek(EE8->EE8_FILIAL+EE7->EE7_PEDFAT+EE8->EE8_FATIT))
						aRet := LockEEC("SB2",1,cFil,cCarga,cPed,cPedExp,SC6->C6_PRODUTO+SC6->C6_LOCAL)
						lContinua := aRet[1]
						cMens := aRet[2] 
						If !lContinua
							Exit
						Endif
					Endif
					EE8->(dbSkip())
				Enddo
			Endif				
		Endif	
	Endif	

	If lContinua
		If !(IsInCallStack("MATA521") .or. IsInCallStack("MATA521A") .or. IsInCallStack("MATA521B"))  // exclusao doc. saida
			cMensTime := "Inicio EECAP100 "+IIf(Upper(ProcName(1))=="ALTPVQTD" .or. Upper(ProcName(1))=="ALTPVEQTD","Alt. Qtd. ","")+"- Pedido de Exportação: "+aCab[aScan(aCab,{|x| Alltrim(x[1]) == "EE7_PEDIDO"})][2]+" - Pedido de Venda: "+aCab[aScan(aCab,{|x| Alltrim(x[1]) == "EE7_PEDFAT"})][2]
			ConOut(cMensTime)
			cLogTime += cMensTime+CRLF
		Endif	

		MSExecAuto({|x,y,z| EECAP100(x,y,z)},aCab,aItens,4)

		If !(IsInCallStack("MATA521") .or. IsInCallStack("MATA521A") .or. IsInCallStack("MATA521B"))
			cMensTime := "Termino EECAP100 "+IIf(Upper(ProcName(1))=="ALTPVQTD" .or. Upper(ProcName(1))=="ALTPVEQTD","Alt. Qtd. ","")+"- Pedido de Exportação: "+aCab[aScan(aCab,{|x| Alltrim(x[1]) == "EE7_PEDIDO"})][2]+" - Pedido de Venda: "+aCab[aScan(aCab,{|x| Alltrim(x[1]) == "EE7_PEDFAT"})][2]
			ConOut(cMensTime)
			cLogTime += cMensTime+CRLF

			cMensTime := "Resultado lMsErroAuto EECAP100 "+IIf(Upper(ProcName(1))=="ALTPVQTD" .or. Upper(ProcName(1))=="ALTPVEQTD","Alt. Qtd. ","")+": "+iif(lMsErroAuto,".T.",".F.")+" - Pedido de Exportação: "+aCab[aScan(aCab,{|x| Alltrim(x[1]) == "EE7_PEDIDO"})][2]+" - Pedido de Venda: "+aCab[aScan(aCab,{|x| Alltrim(x[1]) == "EE7_PEDFAT"})][2]
			ConOut(cMensTime)
			cLogTime += cMensTime+CRLF
			cLogTime += CRLF

			ConOut("")
		Endif	

		If lMsErroAuto .or. lErro
			aErro := GetAutoGRLog()
			varInfo( "aErro"		, aErro	)
			lRet := .F. 
			cFileLog := NomeAutoLog()
			cMens := "Problema na execução da alteração do Pedido de Exportação, Filial: "+cFil+", Carga: "+cCarga+", Pedido: "+cPed+", Pedido de Exportação: "+cPedExp

			If !Empty(cFileLog)
				cMens := cMens+CRLF+MemoRead(cFileLog)
			Else
				// busca erro gerado pela funcao padrao help()
				aErro := GetAutoGRLog() // Retorna erro em array
				cErro := ""
				If Empty(cErro)
										
					If (!IsBlind()) // COM INTERFACE GRÁFICA
					cErro += MostraErro()
				    Else // EM ESTADO DE JOB
				        cError := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO
				
				        ConOut(PadC("Automatic routine ended with error", 80))
				        ConOut("Error: "+ cError)
				        
				        cErro += PadC("Automatic routine ended with error", 80) + " Error: "+ cError
				    EndIf
				Endif
				If Empty(cErro)			
					For nCnt:=1 To Len(aErro)
						cErro += aErro[nCnt]+CRLF
					Next
				Endif	
				If !Empty(cErro)
					cMens := cMens+CRLF+cErro
				Endif
			Endif
		Else
			lRet := .T.
			//If IsInCallStack("AltPVI") // somente na inclusao da carga
			If GetMv("MGF_OECPUS",,.T.)
				GrvCamposUser(aCab,aItens,.T.,"EE8_ZGERSI","EE8_ZQTDSI","EE8_ZQTDHI")
			Endif	
			// limpa campo gravado na inclusao da carga, referente a itens deletados
			For nCnt := 1 To Len(aEE8Del)
				EE8->(dbGoto(aEE8Del[nCnt]))
				If EE8->(Recno()) == aEE8Del[nCnt]
					EE8->(RecLock("EE8",.F.))
					EE8->EE8_ZOEDEL := "" 
					EE8->(MsUnlock())
				Endif
			Next
			//Endif	
		EndIf
	Endif

	aRet := {}
	aAdd(aRet,lRet)
	aAdd(aRet,cMens) 
	If !Empty(cMens)
		Conout(cMens)
	Endif	

	//RESET ENVIRONMENT

	aEval(aArea,{|x| RestArea(x)})

Return(aRet)


// rotina de alteracao do pv, para exclusao de itens, quando ocorre a exclusao da carga e o pedido em questao sofreu inclusao de itens, devido a vir mais de um codigo de sif para o mesmo item do pv
// para tratamento do GAP FIS45
Static Function AltPVESif(aPV,Carga,aQtdLib)//,lExp,lOffS,lProcOff,cFilAntSav)

	Local nCnt := 0
	Local aRet := {}
	Local aCab := {}
	Local aItem := {}
	Local aItens := {}
	Local aArea := {SC5->(GetArea()),SC6->(GetArea()),SX3->(GetArea()),GetArea()}
	Local cChave := ""
	Local cMens := ""
	Local nPos := 0
	Local cFileLog := ""
	Local lPedExp := .F.
	Local aDadosEE7 := {}
	Local nModuloSav := nModulo
	Local cModuloSav := cModulo
	Local lAltera := .F.
	Local nRecnoSC6 := 0
	Local nPos1 := 0
	Local nCntItem := 0
	//Local nRecnoEE8 := 0
	//Local cPedExp := ""
	Local cOrigem := ""
	Local cSitTrib := ""
	Local lPVRotAuto := GetMv("MGF_OEPVRT",.F.,.F.)
	Local cCarga := ""
	Local nCntEE8 := 0
	Local cItem := ""
	Local cItemSav := ""
	Local aEE8Del := {}

	Default aQtdLib := {}

	Private lMsErroAuto := .F.

	If Type("Carga") == "U" 
		If IsInCallStack("U_MGFFAT49") .and. Type("__cCarga") != "U" .and. !Empty(__cCarga)
			cCarga := __cCarga
		Endif
	Endif		

	nCnt := 1
	While .T.
		If nCnt > Len(aPV)
			Exit
		Endif	
		aCab := {}
		aItem := {}
		aItens := {}
		lPedExp := .F.
		cChave := aPV[nCnt][1] //pedido
		lAltera := .F.

		While cChave == aPV[nCnt][1]
			If aPV[nCnt][3]
				// verifica se o pedido estah nos itens enviados pelo taura
				If Len(aQtdLib) > 0
					If aScan(aQtdLib,{|x| x[2]==aPv[nCnt][1]}) == 0
						nCnt++
						If nCnt > Len(aPV)
							Exit
						Endif	
						Loop
					Endif
				Endif	

				lPedExp := .F.
				If Empty(aCab)

					SC5->(dbSetOrder(1))
					//If IIf(lOffS,.T.,SC5->(dbSeek(xFilial("SC5")+aPV[nCnt][1])))
					If SC5->(dbSeek(xFilial("SC5")+aPV[nCnt][1]))
						
						If !Empty(SC5->C5_PEDEXP)
							lPedExp := .T.
							nModulo := 29 // EEC
							cModulo := "EEC"
						Endif
						If !lPedExp
							aCab := ArraySX3("SC5")
						Else
							//aDadosEE7 := DadosEE7(IIf(!lOffS,SC5->C5_NUM,aPV[nCnt][1]))	
							aDadosEE7 := DadosEE7(SC5->C5_NUM)	
							If Len(aDadosEE7) > 0
								EE7->(dbGoto(aDadosEE7[1]))
								If EE7->(Recno()) == aDadosEE7[1]
									aCab := ArraySX3("EE7")
								Endif
							Endif		
						Endif	        
					Endif	
				Endif	

				If !lPedExp
					SC6->(dbSetOrder(1))
					If SC6->(dbSeek(xFilial("SC6")+aPV[nCnt][1]))//+aPV[nCnt][2]))
						While SC6->(!Eof()) .and. xFilial("SC6")+aPV[nCnt][1] == SC6->C6_FILIAL+SC6->C6_NUM
							If !Empty(SC6->C6_ZTESSIF) // apenas troca a tes
								cOrigem := RetFldProd(SC6->C6_PRODUTO,"B1_ORIGEM")
								If Empty(cOrigem)
									cOrigem := GetAdvFVal("SB1","B1_ORIGEM",xFilial("SB1")+SC6->C6_PRODUTO,1,"")
								Endif
								cSitTrib := GetAdvFVal("SF4","F4_SITTRIB",xFilial("SF4")+SC6->C6_ZTESSIF,1,"")

								SC6->(RecLock("SC6",.F.))
								SC6->C6_TES := SC6->C6_ZTESSIF
								SC6->C6_CF := SC6->C6_ZCFOSIF
								SC6->C6_ZTESSIF := ""
								SC6->C6_ZCFOSIF := ""
								SC6->C6_CLASFIS := cOrigem+cSitTrib
								SC6->(MsUnLock())
							Endif	

							aItem := {}
							aItem := ArraySX3("SC6")

							aAdd(aItem,{"AUTDELETA","N",Nil})

							If !lPVRotAuto
								// sempre deixar este campo por ultimo
								aAdd(aItem,{"",.F.,Nil}) // item criado para fazer o tratamento da gravacao do registro, sem usar rotina automatica
							Endif	

							// se item foi gerado pelo sif diferente para mesmo item do pedido, exclui este item
							If (nPos:=aScan(aItem,{|x| Alltrim(x[1]) == "C6_ZGERSIF"})) > 0 .and. aItem[nPos][2] == "S" 
								// marca campo de gerado pelo sif como Nao
								aItem[nPos][2] := "N"

								// grava autdeleta
								aItem[aScan(aItem,{|x| Alltrim(x[1]) == "AUTDELETA"})][2] := "S"

								If !lPVRotAuto
									// marca o item para ser processado, sem usar rotina automatica
									aItem[Len(aItem)][2] := .T. 
								Endif	
							Endif		

							// se item teve quantidade alterada em funcao do sif, volta quantidade original do item
							If (nPos:=aScan(aItem,{|x| Alltrim(x[1]) == "C6_ZQTDSIF"})) > 0
								If aItem[nPos][2] > 0
									If !lPVRotAuto
										// localiza todas as ocorrencias deste produto no pedido e soma os valores
										nRecnoSC6 := SC6->(Recno())

										// zera campos de valor do array
										aEval(aCamposPed,{|x,y| aCamposPed[y][2]:=0,aCamposPed[y][3]:=0})

										SC6->(dbSeek(xFilial("SC6")+aPV[nCnt][1]))
										While SC6->(!Eof()) .and. xFilial("SC6")+aPV[nCnt][1] == SC6->C6_FILIAL+SC6->C6_NUM
											If SC6->C6_PRODUTO == aItem[aScan(aItem,{|x| Alltrim(x[1])=="C6_PRODUTO"})][2]
												For nCntItem:=1 To Len(aCamposPed)
													If aCamposPed[nCntItem][4] == "DIVIDE"
														If aScan(aItem,{|x| Alltrim(x[1])==aCamposPed[nCntItem][1]}) > 0
															// recompoe o valor total 
															aCamposPed[nCntItem][2] += &("SC6->"+aCamposPed[nCntItem][1])
														Endif
													Endif	
												Next		
												
											Endif		
											SC6->(dbSkip())
										Enddo	

										SC6->(dbGoto(nRecnoSC6))

										// zera quantidade do sif
										aItem[nPos][2] := 0

										For nCntItem:=1 To Len(aCamposPed)
											If aCamposPed[nCntItem][4] $ "DIVIDE/CALCULA"
												If aScan(aItem,{|x| Alltrim(x[1])==aCamposPed[nCntItem][1]}) > 0
													aItem[aScan(aItem,{|x| Alltrim(x[1])==aCamposPed[nCntItem][1]})][2] := aCamposPed[nCntItem][2]
												Endif
											Endif
										Next			
									Endif

									If lPVRotAuto	
										// retorna quantidade do item
										aItem[aScan(aItem,{|x| Alltrim(x[1]) == "C6_QTDVEN"})][2] := aItem[nPos][2]
										//aItem[aScan(aItem,{|x| Alltrim(x[1]) == "C6_QTDVEN"})][2] := aCamposPed[aScan(aCamposPed,{|x| Alltrim(x[1])=="C6_QTDVEN"})][2]
										// recalcula valor total do item
										aItem[aScan(aItem,{|x| Alltrim(x[1]) == "C6_VALOR"})][2] := A410Arred(aItem[aScan(aItem,{|x| Alltrim(x[1]) == "C6_QTDVEN"})][2]*aItem[aScan(aItem,{|x| Alltrim(x[1]) == "C6_PRCVEN"})][2],"C6_VALOR")
									Endif	

									If !lPVRotAuto	
										// marca o item para ser processado, sem usar rotina automatica
										aItem[Len(aItem)][2] := .T. 
									Endif	

									// zera quantidade do sif
									aItem[nPos][2] := 0 // 22/12/17
								Endif
							Endif		

							// verifica se algum item que estah sendo alterado foi inserido pela alteracao do sif
							If SC6->C6_ZGERSIF == "S"
								lAltera := .T.
								aPV[nCnt][4] := .T. // marca item como processado pelo fis45 
							Endif	

							aAdd(aItens,aClone(aItem))
							SC6->(dbSkip())
						Enddo
					Endif
				Else
					// carrega todos os itens do pedido de exportacao
					If Len(aDadosEE7) > 0
						EE8->(dbSetOrder(1))
						SC6->(dbSetOrder(1))
						If EE8->(dbSeek(xFilial("EE8")+aDadosEE7[2]))
							While EE8->(!Eof()) .and. xFilial("EE8")+aDadosEE7[2] == EE8->EE8_FILIAL+EE8->EE8_PEDIDO
								If !Empty(EE8->EE8_ZTESSI) // apenas troca a tes
									//If IIf(lOffS,.T.,SC6->(dbSeek(EE8->EE8_FILIAL+EE7->EE7_PEDFAT+EE8->EE8_FATIT)))
									If SC6->(dbSeek(EE8->EE8_FILIAL+EE7->EE7_PEDFAT+EE8->EE8_FATIT))
										cOrigem := RetFldProd(SC6->C6_PRODUTO,"B1_ORIGEM")
										If Empty(cOrigem)
											cOrigem := GetAdvFVal("SB1","B1_ORIGEM",xFilial("SB1")+SC6->C6_PRODUTO,1,"")
										Endif
										cSitTrib := GetAdvFVal("SF4","F4_SITTRIB",xFilial("SF4")+SC6->C6_ZTESSIF,1,"")

										EE8->(RecLock("EE8",.F.))
										EE8->EE8_TES := EE8->EE8_ZTESSI
										EE8->EE8_CF := EE8->EE8_ZCFOSI
										EE8->EE8_ZTESSI := ""
										EE8->EE8_ZCFOSI := ""
										EE8->(MsUnLock())

										SC6->(RecLock("SC6",.F.))
										SC6->C6_TES := SC6->C6_ZTESSIF
										SC6->C6_CF := SC6->C6_ZCFOSIF
										SC6->C6_ZTESSIF := ""
										SC6->C6_ZCFOSIF := ""
										SC6->C6_CLASFIS := cOrigem+cSitTrib
										SC6->(MsUnLock())
									Endif	
								Endif	

								aItem := {}
								aItem := ArraySX3("EE8")

								aAdd(aItem,{"AUTDELETA","N",Nil})

								// sempre deixar este campo por ultimo
								//aAdd(aItem,{"",.F.,Nil}) // item criado para fazer o tratamento da gravacao do registro, sem usar rotina automatica

								// se item foi gerado pelo sif diferente para mesmo item do pedido, exclui este item
								If (nPos:=aScan(aItem,{|x| Alltrim(x[1]) == "EE8_ZGERSI"})) > 0 .and. aItem[nPos][2] == "S" 
									// marca campo de gerado pelo sif como Nao
									aItem[nPos][2] := "N"

									// grava autdeleta
									aItem[aScan(aItem,{|x| Alltrim(x[1]) == "AUTDELETA"})][2] := "S"

									// marca o item para ser processado, sem usar rotina automatica
									//aItem[Len(aItem)][2] := .T. 
								Endif		
								// se item teve quantidade alterada em funcao do sif, volta quantidade original do item
								If (nPos:=aScan(aItem,{|x| Alltrim(x[1]) == "EE8_ZQTDSI"})) > 0
									If aItem[nPos][2] > 0
										// retorna quantidade do item
										aItem[aScan(aItem,{|x| x[1] == "EE8_SLDINI"})][2] := aItem[nPos][2]
										// Alteração Carneiro 18/01                                       
										//aItem[aScan(aItem,{|x| x[1] == "EE8_SLDATU"})][2] := aItem[nPos][2]
										// zera quantidade do sif
										aItem[nPos][2] := 0
									Endif
								Endif		

								// se item teve quantidade alterada em funcao do taura, volta quantidade original do item
								If (nPos:=aScan(aItem,{|x| Alltrim(x[1]) == "EE8_ZQTDHI"})) > 0
									If aItem[nPos][2] > 0
										// retorna quantidade do item
										aItem[aScan(aItem,{|x| x[1] == "EE8_SLDINI"})][2] := aItem[nPos][2]
										// Alteração Carneiro 18/01                                       
										//aItem[aScan(aItem,{|x| x[1] == "EE8_SLDATU"})][2] := aItem[nPos][2]           
										// zera quantidade do historico                                                                                                       
										aItem[nPos][2] := 0
									Endif
								Endif

								// verifica se algum item que estah sendo alterado foi inserido pela alteracao do sif
								If EE8->EE8_ZGERSI == "S" .or. EE8->EE8_ZQTDHI > 0
									lAltera := .T. 
									aPV[nCnt][4] := .T. // marca item como processado pelo fis45 
								Endif	

								aAdd(aItens,aClone(aItem))
								EE8->(dbSkip())
							Enddo
						Endif

						If GetMv("MGF_OEDEL",,.F.) 
							// tratamento para retornar itens deletados na inclusao
							aEE8Del := RegExcPedExp(EE7->EE7_FILIAL,EE7->EE7_PEDIDO)
							For nCntEE8 := 1 To Len(aEE8Del)
								EE8->(dbGoto(aEE8Del[nCntEE8]))
								If EE8->(Recno()) == aEE8Del[nCntEE8]

									// acha o novo item para restaurar o registro deletado, pois pode ter ocorrido do pedido ter sido alterado pelo fis45, que insere registros
									// novos no pedido e os itens do pedido terem sido mudados, se fazendo necessario recalcular o novo item para restaurar os registros deletados
									For nCntItem := 1 to Len(aItens)
										If Empty(cItemSav) .or. Val(cItemSav) < Val(aItens[nCntItem][aScan(aItens[1],{|x| Alltrim(x[1]) == "EE8_SEQUEN"})][2])
											cItemSav := aItens[nCntItem][aScan(aItens[1],{|x| Alltrim(x[1]) == "EE8_SEQUEN"})][2]
										Endif	
										cItem := RetAsc(Str(Max(Val(RetAsc(cItem,2,.F.)),Val(RetAsc(aItens[nCntItem][aScan(aItens[1],{|x| Alltrim(x[1]) == "EE8_SEQUEN"})][2],2,.F.)))),2,.T.)
									Next	

									cItem := Soma1(cItem)
									// no EEC o campo de item eh gravado sem zeros a esquerda e com espacos, entao, deve-se tratar a variavel
									cItem := Val(RetAsc(cItem,2,.F.)) //Val(cItem)
									// alguns registros estao gravados com o campo 'sequen' com espacos a esquerda, outros com zeros, entao trata a variavel
									cItem := Padl(Alltrim(Str(cItem)),TamSX3("EE8_SEQUEN")[1],IIf(Subs(cItemSav,1,1) == " "," ","0"))

									aItem := {}
									aItem := ArraySX3("EE8")

									If (nPos:=aScan(aItem,{|x| Alltrim(x[1]) == "EE8_ZOEDEL"})) == 0
										aAdd(aItem,{"EE8_ZOEDEL","",Nil})
									Else
										aItem[nPos][2] := ""
									Endif		

									//aItem[aScan(aItem,{|x| x[1] == "EE8_SEQUEN"})][2] := cItem
									//aItem[aScan(aItem,{|x| x[1] == "LINPOS"})][3] := cItem

									// marca este item com N, para nao ser usado novamente, caso a carga seja incluida e excluida novamente, isso garante que somente ficarah um
									// registro valido deletado, com a marca S
									EE8->(RecLock("EE8",.F.))
									EE8->EE8_ZOEDEL := "N"
									EE8->(MsUnLock())

									// forca variavel para alteracao do pedido 
									lAltera := .T. 

									aAdd(aItens,aClone(aItem))
								Endif
							Next	
						Endif	
					Endif	
				Endif
				// pula para proximo PV
				While nCnt <= Len(aPV)	
					nCnt++
					If nCnt > Len(aPV)
						Exit
					Endif	
					If aPV[nCnt][1] == cChave
						Loop
					Else
						Exit	
					Endif	
				Enddo
			Else
				nCnt++
			Endif
			If nCnt > Len(aPV)
				Exit
			Endif	
		Enddo		
		If Len(aCab) > 0 .and. Len(aItens) > 0 .and. lAltera
			lMsErroAuto := .F.
			If !lPedExp	
				If !(IsInCallStack("MATA521") .or. IsInCallStack("MATA521A") .or. IsInCallStack("MATA521B"))
					cMensTime := "Inicio MATA410 - Pedido de Venda: "+aCab[aScan(aCab,{|x| Alltrim(x[1]) == "C5_NUM"})][2]
					ConOut(cMensTime)
					cLogTime += cMensTime+CRLF
				Endif	

				If lPVRotAuto
					MSExecAuto({|x,y,z| Mata410(x,y,z)},aCab,aItens,4)
				Endif
				If !lPVRotAuto	
					aRet := GravaPed(aCab,aItens,"3",IIf(Type("Carga")!="U",Carga,cCarga),"SC6",lPedExp)
					lContinua := aRet[1]
				Endif	

				If !(IsInCallStack("MATA521") .or. IsInCallStack("MATA521A") .or. IsInCallStack("MATA521B"))
					cMensTime := "Termino MATA410 - Pedido de Venda: "+aCab[aScan(aCab,{|x| Alltrim(x[1]) == "C5_NUM"})][2]
					ConOut(cMensTime)
					cLogTime += cMensTime+CRLF

					If !lPVRotAuto
						cMensTime := "Resultado lMsErroAuto MATA410: "+iif(!lContinua,".T.",".F.")+" - Pedido de Venda: "+aCab[aScan(aCab,{|x| Alltrim(x[1]) == "C5_NUM"})][2]
					Endif
					If lPVRotAuto	
						cMensTime := "Resultado lMsErroAuto MATA410: "+iif(lMsErroAuto,".T.",".F.")+" - Pedido de Venda: "+aCab[aScan(aCab,{|x| Alltrim(x[1]) == "C5_NUM"})][2]
					Endif	
					ConOut(cMensTime)
					cLogTime += cMensTime+CRLF
					cLogTime += CRLF

					ConOut("")
				Endif	
			Else
				//ConOut("Inicio EECAP100 - Pedido de Exportação: "+aCab[aScan(aCab,{|x| Alltrim(x[1]) == "EE7_PEDIDO"})][2]+" - Pedido de Venda: "+aCab[aScan(aCab,{|x| Alltrim(x[1]) == "EE7_PEDFAT"})][2])

				//aRet := StartJob("U_TAS02EECAP100",GetEnvServer(),.T.,aCab,aItens,xFilial("SC5"),Carga:Cabecalho:Ordem_Embarque,cChave,aCab[aScan(aCab,{|x| Alltrim(x[1]) == "EE7_PEDIDO"})][2])
				aRet := U_TAS02EECAP100(aCab,aItens,xFilial("SC5"),IIf(Type("Carga")!="U",Carga:Cabecalho:Ordem_Embarque,cCarga),cChave,aCab[aScan(aCab,{|x| Alltrim(x[1]) == "EE7_PEDIDO"})][2])

			Endif	

			If !lPedExp	
				If lMsErroAuto .or. lErro
					cFileLog := NomeAutoLog()
					If !Empty(cFileLog)
						cMens := "Problema na execução da alteração do Pedido de Venda, Filial: "+xFilial("SC5")+", Carga: "+IIf(Type("Carga")!="U",Carga:Cabecalho:Ordem_Embarque,cCarga)+", Pedido: "+cChave
						cMens := cMens+CRLF+MemoRead(cFileLog)
					Endif
					ConOut(cMens)
					aRet := {}
					aAdd(aRet,.F.)
					aAdd(aRet,cMens)				
					Exit
				Else
					If lPVRotAuto
						If GetMv("MGF_OECPUS",,.T.)
							GrvCamposUser(aCab,aItens,.F.,"C6_ZGERSIF","C6_ZQTDSIF","C6_ZQTDHIS")
						Endif	
					Endif	
				Endif	
			Endif				
			If Len(aRet) > 0
				If !aRet[1]
					Exit
				Endif	
			Endif	
		Endif		
	Enddo	

	If Len(aRet) == 0
		aRet := {.T.,""}
	Endif

	nModulo := nModuloSav
	cModulo := cModuloSav

	aEval(aArea,{|x| RestArea(x)})

Return(aRet)			


// verifica se tem algum item no pedido que foi gerado pelo sif diferente para o mesmo produto
Static Function VerPVSif(cFil,cPed,Carga)

	Local aArea := {GetArea()}
	Local cQ := ""
	Local aRet := {}
	Local cAliasTrb := GetNextAlias()
	Local lRet := .T.
	Local cMens := ""

	cQ := "SELECT 1 "
	cQ += "FROM "+RetSqlName("SC6")+" SC6 "
	cQ += "WHERE "
	cQ += "C6_FILIAL = '"+cFil+"' "
	cQ += "AND C6_NUM = '"+cPed+"' "
	//cQ += "AND (C6_ZQTDSIF > 0 "
	//cQ += "AND (C6_ZGERSIF = 'S' OR C6_ZTESSIF <> ' ') "
	cQ += "AND C6_ZGERSIF = 'S' "
	cQ += "AND SC6.D_E_L_E_T_ <> '*' "
	cQ += "UNION "
	cQ += "SELECT 1 "
	cQ += "FROM "+RetSqlName("SC6")+" SC6 "
	cQ += "WHERE "
	cQ += "C6_FILIAL = '"+cFil+"' "
	cQ += "AND C6_NUM = '"+cPed+"' "
	//cQ += "AND (C6_ZQTDSIF > 0 "
	//cQ += "AND (C6_ZGERSIF = 'S' OR C6_ZTESSIF <> ' ') "
	cQ += "AND C6_ZTESSIF <> ' ' "
	cQ += "AND SC6.D_E_L_E_T_ <> '*' "

	cQ := ChangeQuery(cQ)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),cAliasTrb,.T.,.T.)

	If (cAliasTrb)->(!Eof())
		lRet := .F.
		cMens := "Pedido de venda já tem itens gerados por Sif´s diferentes."+CRLF+;
		"É necessário excluir esta Ordem de Embarque, para que as alterações anteriores sejam desfeitas e em seguida incluir novamente a Ordem de Embarque."+CRLF+;
		"Filial: "+cFil+", Carga: "+Carga:Cabecalho:Ordem_Embarque+", Pedido: "+cPed
	Endif

	(cAliasTrb)->(dbCloseArea()) 

	aRet := {}
	aAdd(aRet,lRet)
	aAdd(aRet,cMens)

	aEval(aArea,{|x| RestArea(x)})	

Return(aRet)


Static Function Cad_Volume(Carga)
	Local nCnt       := 0          
	Local cEspFilial := ''

	SC5->(DbSetOrder(1))
	For nCnt:=1 To Len(Carga:Volumes)
		cEspFilial := GetNewPar("MGF_ESPSC5","",Alltrim(Carga:Volumes[nCnt]:Filial))
		IF Empty(cEspFilial)
			cEspFilial := 'CAIXAS'
		EndIF
		If SC5->(MsSeek(Alltrim(Carga:Volumes[nCnt]:Filial)+Alltrim(Carga:Volumes[nCnt]:Pedido)))
			SC5->(RecLock('SC5',.F.))
			SC5->C5_ESPECI1 := cEspFilial
			SC5->C5_VOLUME1 := Carga:Volumes[nCnt]:Quantidade
			SC5->(MsUnlock())
		EndIF
	Next nCnt

Return


Static Function Proc_CodLogix(cNumeroExportacao)
	Local aRet   :={.F.,0}
	Local cQuery := ''

	cQuery := " SELECT *"
	cQuery += " FROM "+RetSQLName("SA4")
	cQuery += " WHERE D_E_L_E_T_ = ' ' "
	cQuery += "   AND A4_ZCODMGF ='"+Alltrim(cNumeroExportacao)+"'"
	If Select("QRY_EX") > 0
		QRY_EX->(dbCloseArea())
	EndIf
	cQuery  := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_EX",.T.,.F.)
	dbSelectArea("QRY_EX")
	QRY_EX->(dbGoTop())
	IF !QRY_EX->(EOF())
		aRet[1] := .T.
		aRet[2] := QRY_EX->A4_COD
	EndIF

Return aRet


// deleta caso exista algum registro com esta chave na ZZR, antes da inclusao de um novo registro
Static Function DelItemZZR(cFil,cPed,cItem,cCarga)//,cSif)

	Local aArea := {GetArea()}
	Local cQ := ""
	Local cAliasTrb := GetNextAlias()
	Local nRet := 0

	cQ := "DELETE "
	cQ += "FROM "+RetSqlName("ZZR")+" "
	cQ += "WHERE D_E_L_E_T_ <> '*' "
	cQ += "AND ZZR_FILIAL = '"+cFil+"' "
	cQ += "AND ZZR_CARGA = '"+cCarga+"' "
	cQ += "AND ZZR_PEDIDO = '"+cPed+"' "
	cQ += "AND ZZR_ITEM = '"+cItem+"' "
	//cQ += "AND ZZR_SIFPRD = '"+cSif+"' "

	nRet := tcSqlExec(cQ)
	If nRet == 0
	Else
		ConOut("Problemas na exclusao da tabela ZZR, processo de recepcao da carga do Taura.")
	EndIf

	aEval(aArea,{|x| RestArea(x)})	

Return()


// define o CFO
Static Function TAS02Cfo(cCliente,cLoja,cTes)

	Local aDadosCfo := {}
	Local cCfo := ""

	Aadd(aDadosCfo,{"OPERNF","S"})
	Aadd(aDadosCfo,{"TPCLIFOR",GetAdvFVal("SA1","A1_TIPO",xFilial("SA1")+cCliente+cLoja,1,"")})
	Aadd(aDadosCfo,{"UFDEST",GetAdvFVal("SA1","A1_EST",xFilial("SA1")+cCliente+cLoja,1,"")})
	cCfo := MaFisCfo(,GetAdvFVal("SF4","F4_CF",xFilial("SF4")+cTes,1,""),aDadosCfo)

Return(cCfo)


// OBS: rotina para gravar campos de usuario na rotina automatica de alteracao, sem explicacao o sistema parou de gravar os campos de usuario, no registro criado
// ***VER DEPOIS: VER SE NO EEC TB VAI DAR PROBLEMA COM A GRAVACAO DOS CAMPOS DE USUARIO
Static Function GrvCamposUser(aCab,aItens,lPedExp,cCampoSif,cCampoQtd,cCampoQHist)

	Local aArea := {SC6->(GetArea()),EE8->(GetArea()),GetArea()}
	Local nCnt := 0
	Local nCnt1 := 0
	Local cCampo := ""
	Local cAlias := ""
	Local cConteudo := ""
	Local aRet := {}

	If !lPedExp
		cAlias := "SC6"
	Else
		cAlias := "EE8"
	Endif	
	(cAlias)->(dbSetOrder(1))
	For nCnt:=1 To Len(aItens)
		// grava para itens que foram adicionados ( campo _zgersif = S ) ou para atualizar o campo _zqtdsif ou quantidade historica		 
		If IIf(aScan(aItens[nCnt],{|x| x[1] == cCampoSif})>0,aItens[nCnt][aScan(aItens[nCnt],{|x| x[1] == cCampoSif})][2] == "S",.F.) .or. IIf(aScan(aItens[nCnt],{|x| x[1] == cCampoQtd})>0,.T.,.F.) .or. IIf(aScan(aItens[nCnt],{|x| x[1] == cCampoQHist})>0,.T.,.F.)
			//conout("1")
			// posiciona registro
			If (cAlias)->(dbSeek(xFilial(cAlias)+IIf(!lPedExp,(aCab[aScan(aCab,{|x| Alltrim(x[1]) == "C5_NUM"})][2]+aItens[nCnt][aScan(aItens[nCnt],{|x| Alltrim(x[1]) == "C6_ITEM"})][2]),aCab[aScan(aCab,{|x| Alltrim(x[1]) == "EE7_PEDIDO"})][2]+aItens[nCnt][aScan(aItens[nCnt],{|x| Alltrim(x[1]) == "EE8_SEQUEN"})][2]+aItens[nCnt][aScan(aItens[nCnt],{|x| Alltrim(x[1]) == "EE8_COD_I"})][2]) ))
				For nCnt1:=1 To Len(aItens[nCnt])
					// somente campos de usuario
					If "_Z" $ aItens[nCnt][nCnt1][1] .or. "_X" $ aItens[nCnt][nCnt1][1]
						//conout("1")
						cCampo := aItens[nCnt][nCnt1][1]
						//conout(ccampo)
						cConteudo := aItens[nCnt][nCnt1][2]
						//conout(cconteudo)
						// atualiza os campos que estiverem em branco e no array tem conteudo ou os campos de controle da rotina ( _zgersif e _zqtdsif )
						If (Empty(&(cAlias+"->"+cCampo)) .and. !Empty(cConteudo)) .or. cCampo == cCampoSif .or. cCampo == cCampoQtd .or. cCampo == cCampoQHist
							(cAlias)->(RecLock(cAlias,.F.))
							&(cAlias+"->"+cCampo) := cConteudo
							(cAlias)->(MsUnLock())
							//conout(&(cAlias+"->"+cCampo))
						Endif
					Endif
				Next
				// se for pedido de exportacao, atualiza tambem o pedido de venda
				If lPedExp
					SC6->(dbSetOrder(1))
					EE8->(dbSetOrder(1))
					If EE8->(dbSeek(xFilial("EE8")+aCab[aScan(aCab,{|x| Alltrim(x[1]) == "EE7_PEDIDO"})][2]+aItens[nCnt][aScan(aItens[nCnt],{|x| Alltrim(x[1]) == "EE8_SEQUEN"})][2]+aItens[nCnt][aScan(aItens[nCnt],{|x| Alltrim(x[1]) == "EE8_COD_I"})][2]))
						If SC6->(dbSeek(xFilial("SC6")+aCab[aScan(aCab,{|x| Alltrim(x[1]) == "EE7_PEDFAT"})][2]+EE8->EE8_FATIT))
							SC6->(RecLock("SC6",.F.))
							SC6->C6_ZGERSIF := EE8->EE8_ZGERSI //aItens[nCnt][aScan(aItens[nCnt],{|x| Alltrim(x[1]) == "EE8_ZGERSI"})][2]
							SC6->C6_ZQTDSIF := EE8->EE8_ZQTDSI //aItens[nCnt][aScan(aItens[nCnt],{|x| Alltrim(x[1]) == "EE8_ZQTDSI"})][2]					
							SC6->C6_ZQTDHIS := EE8->EE8_ZQTDHI //aItens[nCnt][aScan(aItens[nCnt],{|x| Alltrim(x[1]) == "EE8_ZQTDHI"})][2]					
							SC6->(MsUnLock())
						Endif	
					Endif
				Endif		
			Endif
		Endif
	Next

	If Len(aRet) == 0
		aRet := {.T.,""}
	Endif

	aEval(aArea,{|x| RestArea(x)})	

Return(aRet)


// rotina de alteracao da carga
Static Function WSTAS02Alt(Carga,cAcao)

	Local aQtdLib := {}
	Local lContinua := .T.
	Local aRet := {}
	Local aCabCargaERP := {}
	Local lAlterou := .F.
	Local cMens := ""

	// verifica se a carga existe
	aRet := ExisteCarga(Carga)
	lContinua := !aRet[1]
	// atualiza o valor do array aRet
	aRet[1] := !aRet[1]

	If !lContinua
		cMens := "Carga não existe, Filial: "+Carga:Cabecalho:Filial+", Carga: "+Carga:Cabecalho:Ordem_Embarque
		Conout(cMens)
		aRet[2] := cMens
	Endif

	If lContinua
		// valida campos do cabecalho da carga
		aRet := VldCabCampos(Carga,@aCabCargaERP)
		lContinua := aRet[1]

		If lContinua
			// verifica se carga pode ser alterada
			aRet := VldAltCarga(Carga)
			lContinua := aRet[1]

			If lContinua

				Begin Transaction

					// verifica/altera dados dos itens
					aRet := AltCpoItem(Carga,@aQtdLib,cAcao,@lAlterou,aCabCargaERP)
					lContinua := aRet[1]

					If !lContinua
						cMens := aRet[2]
						Conout(cMens)
					Else
						If lAlterou
							// atualiza peso da dak
							GrvCabPeso(Carga)	

							cMens := "Alteração de Carga com sucesso, Filial: "+Carga:Cabecalho:Filial+", Carga: "+Carga:Cabecalho:Ordem_Embarque
							aRet[2] := cMens
							Conout(cMens)
						Else
							cMens := "Carga não alterada, pois nenhuma atualização foi necessária, Filial: "+Carga:Cabecalho:Filial+", Carga: "+Carga:Cabecalho:Ordem_Embarque
							aRet := {}
						Endif
					Endif	

					MsUnLockAll()

					If !lContinua
						//If InTransact()					
						DisarmTransaction()
						//Endif	
					Endif	

				End Transaction 

				//MsUnLockAll()

			Endif	
		Endif	
	Endif

	If Len(aRet) == 0
		aAdd(aRet,lContinua)
		aAdd(aRet,cMens)
		If !Empty(cMens)
			Conout(cMens)
		Endif	
	Endif	

Return(aRet)	


// verifica se carga pode ser alterada
Static Function VldAltCarga(Carga)

	Local lProcessa := .T.
	Local lBlqCar := ( DAK->(FieldPos("DAK_BLQCAR")) > 0 )
	Local lBloqueio := OsBlqExec(DAK->DAK_COD, DAK->DAK_SEQCAR)
	Local aRet := {}
	Local cMens1 := ""
	Local cMens2 := ""
	Local cMens3 := ""
	Local cMens := ""

	cMens1 := "Carga não alterada."+CRLF
	cMens3 := "Filial: "+Carga:Cabecalho:Filial+", Carga: "+Carga:Cabecalho:Ordem_Embarque			

	// Primeiro verifica se a carga selecionada ainda pode ser edit.
	If lProcessa .And. !Empty(DAK->DAK_JUNTOU) .And. !Alltrim(DAK->DAK_JUNTOU) == "JUNTOU" .And. !Alltrim(DAK->DAK_JUNTOU) == "MANUAL" .And. !Alltrim(DAK->DAK_JUNTOU) == "ASSOCI"
		//Help(" ",1,"DS2602141") //A carga selecionada est?indispon?el para manipula?es.
		lProcessa := .F.
		cMens2 := "Motivo: "+"A carga selecionada está indisponível para manipulações."+CRLF
		cMens := cMens1+cMens2+cMens3
	EndIf

	If lProcessa .And. DAK->DAK_ACECAR == "1"
		//Help(" ",1,"DS2602143") //Retorno de Cargas j?realizado, n? ?poss?el a Manipula?o desta Carga.
		lProcessa := .F.
		cMens2 := "Motivo: "+"Retorno de Cargas já realizado, não será possível a manipulação desta Carga."+CRLF
		cMens := cMens1+cMens2+cMens3
	EndIf

	// verifica se existe o campo e se esta bloqueada
	If lProcessa .And. (( lBlqCar .And. DAK->DAK_BLQCAR == '1' ) .Or. lBloqueio)
		lProcessa := .F.
		//Help(" ",1,"OMS200CGBL") //Carga bloqueada ou com servi? em execu?o.
		cMens2 := "Motivo: "+"Carga bloqueada ou com serviço em execução."+CRLF
		cMens := cMens1+cMens2+cMens3
	EndIf

	aRet := {}
	aAdd(aRet,lProcessa)
	aAdd(aRet,cMens)

Return(aRet)


// verifica se houveram alteracoes nos dados dos itens
Static Function	AltCpoItem(Carga,aQtdLib,cAcao,lAlterou,aCabCargaERP)

	Local aArea	:= {SC9->(GetArea()),SC6->(GetArea()),SX6->(GetArea()),GetArea()}
	Local nCnt := 0
	Local aRet := {}
	Local lContinua := .T.
	Local nPos := 0
	Local cMens := ""
	Local cItemPed := ""
	Local aPV := {}
	Local aSif := {}
	Local lSifExc := .F.
	Local aQtdLibSav := {}
	//Local aSifSav := {}
	//Local lProcOff := .F.
	//Local cFilAntSav := cFilAnt
	Local cSifFil := ""
	Local cTime1 := ""
	Local cTime2 := ""
	Local lFis45 := .T.
	Local lAchouFis45 := .F. 

	SC9->(DbSetOrder(1))
	SC6->(DbSetOrder(1))
	SX6->(dbSetOrder(1))

	// obs: nas funcoes abaixo, nao envia o item para a funcao dadossc9, pois pode ter ocorrido do item ter sido duplicado, pelo envio de sif da filial corrente e outras filiais
	// e neste caso deve-se avaliar todos os itens deste mesmo produto

	// agrupa as quantidades por lote, para realizar a analise por lote
	aRet := AvalSaldo(Carga,@aQtdLib,.F.,.T.,@aSif)
	lContinua := aRet[1]

	If lContinua
		// avalia se os itens enviados jah foram faturados na carga
		For nCnt:=1 To Len(aQtdLib)
			If DadosSC9(aQtdLib[nCnt][2],,.T.) > 0
				lContinua := .F.
				cMens := "Item enviado pelo Taura já se encontra faturado, Filial: "+Carga:Cabecalho:Filial+", Carga: "+Carga:Cabecalho:Ordem_Embarque+", Pedido: "+aQtdLib[nCnt][2]+", Item: "+aQtdLib[nCnt][3]
				aRet[1] := lContinua
				aRet[2] := cMens				
				Exit
			Endif
		Next			
	Endif

	If lContinua
		// avalia se os itens enviados estao em outra carga
		For nCnt:=1 To Len(aQtdLib)
			If DadosSC9(aQtdLib[nCnt][2],,.F.,.T.,Carga:Cabecalho:Ordem_Embarque) > 0
				lContinua := .F.
				cMens := "Item enviado pelo Taura já se encontra em outra Carga, Filial: "+Carga:Cabecalho:Filial+", Carga: "+Carga:Cabecalho:Ordem_Embarque+", Pedido: "+aQtdLib[nCnt][2]+", Item: "+aQtdLib[nCnt][3]
				aRet[1] := lContinua
				aRet[2] := cMens				
				Exit
			Endif
		Next			
	Endif

	// neste cenario somente virao os itens a serem alterados e/ou incluidos na carga, os demais itens jah incluidos nesta carga nao devem vir na integracao
	If cAcao == "4" .and. lContinua // alteracao-inclusao

		// verifica se deve executar o FIS45
		If !GetMv("MGF_F45EXE",.F.,.T.)
			lFis45 := .F.
		Endif

		If lContinua .and. lFis45
			SX6->(dbSetOrder(1))
			SX6->(dbSeek(cFilAnt+"MGF_SIFFIL")) // usa dbseek para garantir a pesquisa do parametro por filial
			If SX6->(!Found()) .or. (SX6->(Found()) .and. Empty(GetMv("MGF_SIFFIL")))
				lContinua := .F.
				cMens := "Parâmetro 'MGF_SIFFIL' em branco ou não encontrado para esta filial, Filial: "+Carga:Cabecalho:Filial+", Carga: "+Carga:Cabecalho:Ordem_Embarque
				ConOut(cMens)
				aRet := {}
				aAdd(aRet,lContinua)
				aAdd(aRet,cMens)				
			Else
				cSifFil := Alltrim(SX6->X6_CONTEUD)	
			Endif	
		Endif

		If lContinua	
			If GetMv("MGF_OEGRTE",,.T.) 
				cTime1 := Time()
				aRet := GrvTabTemp(Carga)
				cTime2 := Time()
				cMensTime := "ORDEM EMBARQUE: "+Carga:Cabecalho:Ordem_Embarque+" - GRAVAÇÃO TABELA TEMPORÁRIA: "+ElapTime(cTime1,cTime2)+" - Time: "+Time()+CRLF
				ConOut(cMensTime)
				cLogTime += cMensTime

				lContinua := aRet[1]
			Endif	
		Endif	

		If lContinua
			// verifica necessidade de alterar o pedido em funcao do sif
			//aSifSav := aClone(aSif)
			//aQtdLibSav := aClone(aQtdLib)
			cTime1 := Time()
			// processa pedidos de exportacao
			aRet := AltPVISif(@aSif,Carga,@aQtdLib)//,,.T.,.F.,@lProcOff,@cSifFil)
			lContinua := aRet[1]
			
			cTime2 := Time()
			cMensTime := "ORDEM EMBARQUE: "+Carga:Cabecalho:Ordem_Embarque+" - FIM FIS45 - SIF: "+ElapTime(cTime1,cTime2)+" - Time: "+Time()+CRLF
			ConOut(cMensTime)
			cLogTime += cMensTime
		Endif	
		/*
		If lContinua
		// verifica necessidade de alterar as quantidades dos pedidos
		aRet := AltPVQtd(Carga,aQtdLib,aSif)
		lContinua := aRet[1]
		Endif	
		*/
		// valida se as alteracoes em quantidades foram feitas corretamente no pedido de exportacao
		If lContinua
			If GetMv("MGF_OEVQEX",,.F.) 
				cTime1 := Time()
				aRet := VldQtdExp(aSif,Carga,aQtdLib)
				cTime2 := Time()
				cMensTime := "ORDEM EMBARQUE: "+Carga:Cabecalho:Ordem_Embarque+" - FIM VLD. QTD. PED. EXP.: "+ElapTime(cTime1,cTime2)+" - Time: "+Time()+CRLF
				ConOut(cMensTime)
				cLogTime += cMensTime

				lContinua := aRet[1]
				If !lContinua
					cMens := aRet[2]
				Endif	
			Endif	
		Endif	
		If lContinua
			If !Empty(cSifFil) .or. !lFis45
				For nCnt:=1 To Len(Carga:Itens)
					lAchouFis45 := .F. 			
					cItemPed := ""
					If SC6->(dbSeek(xFilial("SC6")+Carga:Itens[nCnt]:Pedido))
						While SC6->(!Eof()) .and. xFilial("SC6")+Carga:Itens[nCnt]:Pedido == SC6->C6_FILIAL+SC6->C6_NUM
							If Alltrim(Carga:Itens[nCnt]:Item_Ped) == Alltrim(SC6->C6_PRODUTO)
								// verifica se o item do sc6 eh o mesmo enviado pelo taura
								If Alltrim(Carga:Itens[nCnt]:Sif_Produto) $ cSifFil .or. !lFis45
									If SC6->C6_ZGERSIF != "S" .and. !Empty(SC6->C6_ZQTDSIF) // item nao foi gerado pelo fis45
										cItemPed := SC6->C6_ITEM 
										lAchouFis45 := .T. 									
										//conout("1-"+SC6->C6_ITEM )
										Exit
									Endif
								Else
									If SC6->C6_ZGERSIF == "S" .or. !Empty(SC6->C6_ZTESSIF) // item foi gerado pelo fis45
										cItemPed := SC6->C6_ITEM
										lAchouFis45 := .T. 									
										//conout("2-"+SC6->C6_ITEM )
										Exit
									Endif
								Endif		
							Endif	
							SC6->(dbSkip())
						Enddo	
					Endif

					// tratamento para quando nao eh fis45
					If Empty(cItemPed)
						If SC6->(dbSeek(xFilial("SC6")+Carga:Itens[nCnt]:Pedido))
							While SC6->(!Eof()) .and. xFilial("SC6")+Carga:Itens[nCnt]:Pedido == SC6->C6_FILIAL+SC6->C6_NUM
								If Alltrim(Carga:Itens[nCnt]:Item_Ped) == Alltrim(SC6->C6_PRODUTO)
									cItemPed := SC6->C6_ITEM
									lAchouFis45 := .F. 								
									Exit
								Endif
								SC6->(dbSkip())							
							Enddo
						Endif
					Endif			

					If !Empty(cItemPed)
						// busca quantidade totalizada do produto pelo array asif
						//nPos := aScan(aQtdLib,{|x| x[1]+x[2]+x[6]==Alltrim(SC6->C6_FILIAL)+Alltrim(SC6->C6_NUM)+Alltrim(SC6->C6_PRODUTO)})
						If lAchouFis45
							nPos := aScan(aSif,{|x| Alltrim(x[1])+Alltrim(x[2])+Alltrim(x[3])==Alltrim(SC6->C6_FILIAL)+Alltrim(SC6->C6_NUM)+Alltrim(SC6->C6_ITEM)}) //17/04/18
						Else // se nao eh fis45, busca quantidade totalizada pelo array aqtdlib
							nPos := aScan(aQtdLib,{|x| Alltrim(x[1])+Alltrim(x[2])+Alltrim(x[3])==Alltrim(SC6->C6_FILIAL)+Alltrim(SC6->C6_NUM)+Alltrim(SC6->C6_ITEM)}) //30/04/18
						Endif	
						If nPos > 0
							If DadosSC9(SC6->C6_NUM,SC6->C6_ITEM,.F.,.F.,Carga:Cabecalho:Ordem_Embarque) != IIf(lAchouFis45,aSif[nPos][5],aQtdLib[nPos][4]) //Carga:Itens[nCnt]:Qtd_Lib
								aQtdLibSav := aClone(aQtdLib)
								// prepara array aqtdlib para poder usar a funcao libpv
								aQtdLib := {{;
								SC6->C6_FILIAL,;
								SC6->C6_NUM,;
								SC6->C6_ITEM,;
								/*aQtdLib[nPos][4]*/IIf(lAchouFis45,aSif[nPos][5],aQtdLib[nPos][4]),;
								SC6->(Recno()),;
								SC6->C6_PRODUTO,;
								{},;
								"",;
								cTod(""),;
								cTod(""),;
								0,;
								SC6->C6_LOCAL,;
								.F.,;
								Carga:Itens[nCnt]:Ordem_Embarque,;
								0,;
								.F.,;
								.F.; 
								}}

								aRet := LibPV(aQtdLib,@aPV,Carga,aCabCargaERP)
								//aQtdLib := aClone(aQtdLibSav)
								lContinua := aRet[1]

								If !lContinua
									aQtdLib := aClone(aQtdLibSav)
									Exit
								Else
									// valida se SC9 ficou liberado para todos os itens do pv
									If GetMv("MGF_OEVLPV",,.F.) 
										cTime1 := Time()
										aRet := VldLib(aSif,Carga,aQtdLib,.T.)
										cTime2 := Time()
										cMensTime := "ORDEM EMBARQUE: "+Carga:Cabecalho:Ordem_Embarque+" - FIM VLD. LIBPV SEM CARGA: "+ElapTime(cTime1,cTime2)+" - Time: "+Time()+CRLF
										ConOut(cMensTime)
										cLogTime += cMensTime

										lContinua := aRet[1]
										If !lContinua
											cMens := aRet[2]
										Endif	
									Endif	
								Endif	

								aQtdLib := aClone(aQtdLibSav)	

								If !lContinua
									Exit
								Else
									CargaSC9(Carga,aCabCargaERP,cAcao)
									lAlterou := .T.
									GrvTabEEC09(Carga,"1",aSif) // inclui
								Endif
							Endif
						Endif	
					Endif	
				Next	

				If lAlterou
					// reabre carga para faturamento
					If DAK->DAK_FEZNF == "1"
						DAK->(RecLock("DAK",.F.))
						DAK->DAK_FEZNF := "2"
						DAK->(MsUnLock()) 
					Endif	
				Endif	
			Endif	

			// valida se SC9 ficou gerado para todos os itens da carga
			If lContinua
				If GetMv("MGF_OEVLIB",,.F.) 
					cTime1 := Time()
					aRet := VldLib(aSif,Carga,aQtdLib,.F.)
					cTime2 := Time()
					cMensTime := "ORDEM EMBARQUE: "+Carga:Cabecalho:Ordem_Embarque+" - FIM VLD. LIBPV: "+ElapTime(cTime1,cTime2)+" - Time: "+Time()+CRLF
					ConOut(cMensTime)
					cLogTime += cMensTime

					lContinua := aRet[1]
					cMens := aRet[2]
				Endif	
			Endif	
		Endif	
	Endif	

	If Len(aRet) == 0
		aAdd(aRet,lContinua)
		aAdd(aRet,cMens)
	Endif	
	If !Empty(cMens)
		Conout(cMens)
	Endif	

	aEval(aArea,{|x| RestArea(x)})	

Return(aRet)	


// obs: DAK e SC9 devem estar posicionados
Static Function CargaSC9(Carga,aCabCargaERP,cAcao)

	//Local cPrxSeq   := ""
	Local aRotas := {}
	Local cRota := GetMv("MGF_ROTA",,"999999")
	Local cZona := GetMv("MGF_ZONA",,"999999")
	Local cSetor := GetMv("MGF_SETOR",,"999999")

	aRotas := 	{cRota/*[1] Codigo da Rota*/,;
	cZona/*[2] Codigo da Zona*/,;
	cSetor/*[3] Codigo do Setor*/,;
	aCabCargaERP[1]/*[4] Caminhao*/,;
	aCabCargaERP[2]/*[5] Motorista*/,;
	""/*[6] Ajudante 1*/,;
	""/*[7] Ajudante 2*/,;
	""/*[8] Ajudante 3*/,;
	""/*[9] Hora chegada*/,;
	""/*[10] Time Service*/,;
	cTod("")/*[11] Data chegada*/,;
	cTod("")/*[12] Data saida*/,;
	Time()/*[13] Hora de inicio de entrega*/;
	}

	If cAcao == "4"		
		//cPrxSeq := OsSeqCar(Carga:Cabecalho:Ordem_Embarque)
		SC9->(Reclock("SC9",.F.))
		SC9->C9_CARGA  := Carga:Cabecalho:Ordem_Embarque
		SC9->C9_SEQCAR := DAK->DAK_SEQCAR //cPrxSeq // gerar sempre com a mesma sequencia da carga atual
		SC9->C9_SEQENT := OsSeqEnt(SC9->C9_CARGA,SC9->C9_SEQCAR,SC9->C9_PEDIDO)
		SC9->(MsUnlock())

		// inclui o item do SC9 na nova carga
		MaAvalSC9("SC9",7,,,,,,aRotas)
	Endif
	If cAcao == "5"
		// enclui o item do SC9 na nova carga
		MaAvalSC9("SC9",8,,,,,,aRotas)
	Endif

Return()	


// gravacao de campo de peso da dak
Static Function GrvCabPeso(Carga)

	Local aArea := {SC5->(GetArea()),DAI->(GetArea()),GetArea()}
	Local nPeso := 0
	Local aPV := {}
	Local nCnt := 0
	Local nPos := 0
	Local nTamPed := TamSX3("C6_NUM")[1]
	Local nTamCarga := TamSX3("DAI_COD")[1]

	For nCnt:=1 To Len(Carga:Itens)
		If (nPos:=aScan(aPV,{|x| Alltrim(x[1])==Alltrim(Carga:Itens[nCnt]:Pedido)})) == 0
			aAdd(aPV,{Carga:Itens[nCnt]:Pedido,Carga:Itens[nCnt]:Peso,Carga:Itens[nCnt]:Peso_Bruto})		
		Else
			aPV[nPos][2] += Carga:Itens[nCnt]:Peso	
			aPV[nPos][3] += Carga:Itens[nCnt]:Peso_Bruto	
		Endif
	Next

	DAI->(dbSetOrder(4))
	For nCnt:=1 To Len(aPV)		
		If DAI->(dbseek(xFilial("DAI")+Padr(aPV[nCnt][1],nTamPed)+DAK->DAK_COD))
			DAI->(RecLock("DAI",.F.))
			DAI->DAI_PESO := aPV[nCnt][3]
			DAI->(MsUnLock())
		Endif
		If SC5->(dbseek(xFilial("SC5")+Padr(aPV[nCnt][1],nTamPed)))
			SC5->(RecLock("SC5",.F.))
			SC5->C5_PESOL := aPV[nCnt][2]
			SC5->C5_PBRUTO := aPV[nCnt][3]
			SC5->(MsUnLock())
		Endif	
	Next		 

	// le novamente a DAI aqui, pois no caso de alteracao da carga, pode ser enviado apenas um pedido e a carga jah existir com outros pedidos
	nPeso := 0
	DAI->(dbSetOrder(1))
	If DAI->(dbseek(xFilial("DAI")+Padr(Carga:Cabecalho:Ordem_Embarque,nTamCarga)))
		While DAI->(!Eof()) .and. xFilial("DAI")+Padr(Carga:Cabecalho:Ordem_Embarque,nTamCarga) == DAI->DAI_FILIAL+DAI->DAI_COD
			nPeso += DAI->DAI_PESO
			DAI->(dbSkip())
		Enddo	
	Endif

	DAK->(RecLock("DAK",.F.))
	DAK->DAK_PESO := nPeso 
	DAK->(MsUnLock()) 

	aEval(aArea,{|x| RestArea(x)})	

Return()


// realiza a gravacao do item do pedido de exportacao e pv via reclock
Static Function GravaPed(aCab,aItens,cAcao,Carga,cAlias,lPedExp)

	Local aArea := {EE8->(GetArea()),SC6->(GetArea()),GetArea()}
	Local nCnt := 0
	Local nCntItem := 0
	Local cPed := IIf(!lPedExp,aCab[aScan(aCab,{|x| Alltrim(x[1]) == "C5_NUM"})][2],aCab[aScan(aCab,{|x| Alltrim(x[1]) == "EE7_PEDIDO"})][2])
	Local aRet := {}
	Local lContinua := .T.
	Local cCampo := ""
	Local cConteudo := ""
	Local cMens := ""
	Local aCamposAtu := IIf(cAlias=="SC6",aClone(aCamposPed),aClone(aCamposExp)) 

	(cAlias)->(dbSetOrder(1))

	For nCnt:=1 To Len(aItens)
		If aItens[nCnt][Len(aItens[nCnt])][2] // teve alteracao
			// se encontrar o item, altera apenas os campos que foram divididos na quantidade
			If IIf(!lPedExp,(cAlias)->(dbSeek(xFilial(cAlias)+cPed+aItens[nCnt][aScan(aItens[nCnt],{|x| Alltrim(x[1]) == "C6_ITEM"})][2])),(cAlias)->(dbSeek(xFilial(cAlias)+cPed+aItens[nCnt][aScan(aItens[nCnt],{|x| Alltrim(x[1]) == "EE8_SEQUEN"})][2])) )
				//While IIf(!lPedExp,.T.,(cAlias)->(!Eof()) .and. xFilial(cAlias)+cPed == EE8->EE8_FILIAL+EE8->EE8_PEDIDO)
				//If IIf(!lPedExp,.T.,aItens[nCnt][aScan(aItens[nCnt],{|x| Alltrim(x[1]) == "EE8_SEQUEN"})][2] == EE8->EE8_SEQUEN)
				If !lPedExp
					// estorna sc9, caso encontre
					aRet := EstornaSC9(SC6->C6_PRODUTO,SC6->C6_ITEM,,Carga)
					lContinua := aRet[1]

					If !lContinua
						Exit
					Endif	
				Endif	
				// verifica se eh exclusao e item deve ser excluido
				If cAcao == "3" .and. aScan(aItens[nCnt],{|x| Alltrim(x[1]) == "AUTDELETA"}) > 0 .and. aItens[nCnt][aScan(aItens[nCnt],{|x| Alltrim(x[1]) == "AUTDELETA"})][2] == "S"
					(cAlias)->(RecLock(cAlias,.F.))
					(cAlias)->(dbDelete())
					(cAlias)->(MsUnLock())
				Else // alteracao do registro	
					(cAlias)->(RecLock(cAlias,.F.))
					
					For nCntItem:=1 To Len(aCamposAtu)
						If aCamposAtu[nCntItem][4] $ "DIVIDE/CALCULA"
							If aScan(aItens[nCnt],{|x| Alltrim(x[1]) == aCamposAtu[nCntItem][1]}) > 0	
								&(cAlias+"->"+aCamposAtu[nCntItem][1]) := aItens[nCnt][aScan(aItens[nCnt],{|x| Alltrim(x[1]) == aCamposAtu[nCntItem][1]})][2]
							Endif
						Endif
					Next			
					// demais campos com tratamento especifico
					If !lPedExp
						(cAlias)->C6_ZQTDSIF := aItens[nCnt][aScan(aItens[nCnt],{|x| Alltrim(x[1]) == "C6_ZQTDSIF"})][2]
						(cAlias)->C6_ZGERSIF := aItens[nCnt][aScan(aItens[nCnt],{|x| Alltrim(x[1]) == "C6_ZGERSIF"})][2]
						If (cAlias)->C6_TES != aItens[nCnt][aScan(aItens[nCnt],{|x| Alltrim(x[1]) == "C6_TES"})][2]
							(cAlias)->C6_TES := aItens[nCnt][aScan(aItens[nCnt],{|x| Alltrim(x[1]) == "C6_TES"})][2]
							(cAlias)->C6_CF := aItens[nCnt][aScan(aItens[nCnt],{|x| Alltrim(x[1]) == "C6_CF"})][2]
						Endif	
					Else
						(cAlias)->EE8_ZQTDSI := aItens[nCnt][aScan(aItens[nCnt],{|x| Alltrim(x[1]) == "EE8_ZQTDSI"})][2]
						(cAlias)->EE8_ZGERSI := aItens[nCnt][aScan(aItens[nCnt],{|x| Alltrim(x[1]) == "EE8_ZGERSI"})][2]
						If (cAlias)->EE8_TES != aItens[nCnt][aScan(aItens[nCnt],{|x| Alltrim(x[1]) == "EE8_TES"})][2]
							(cAlias)->EE8_TES := aItens[nCnt][aScan(aItens[nCnt],{|x| Alltrim(x[1]) == "EE8_TES"})][2]
							(cAlias)->EE8_CF := aItens[nCnt][aScan(aItens[nCnt],{|x| Alltrim(x[1]) == "EE8_CF"})][2]
						Endif	
					Endif	
					(cAlias)->(MsUnLock())
				Endif				
			Else
				If cAcao == "1"
					// se nao encontrar o item, inclui
					(cAlias)->(RecLock(cAlias,.T.))
					If cAlias == "SC6"
						SC6->C6_FILIAL := xFilial(cAlias)
					Endif	
					If cAlias == "EE8"
						EE8->EE8_FILIAL := xFilial(cAlias)
					Endif	
					For nCntItem:=1 To Len(aItens[nCnt])
						If !Empty(aItens[nCnt][nCntItem][1])
							cCampo := aItens[nCnt][nCntItem][1]
							cConteudo := aItens[nCnt][nCntItem][2]
							If !Empty(cCampo) .and. !Empty(cConteudo) .and. (cAlias)->(FieldPos(cCampo)) > 0
								&(cAlias+"->"+cCampo) := IIf(!Empty(cConteudo),cConteudo,CriaVar(cCampo))
							Endif	
						Endif	
					Next	
					(cAlias)->(MsUnLock())
				Endif	
			Endif
		Endif
	Next			

	If Len(aRet) == 0
		aAdd(aRet,lContinua)
		aAdd(aRet,cMens)
	Endif	
	If !Empty(cMens)
		Conout(cMens)
	Endif	

	aEval(aArea,{|x| RestArea(x)})	

Return(aRet)


/*
// atualiza o campo de item do pv no ee8
Static Function GrvItPVEE8(aCab,aItens,aSif,cPedExp,Carga,lProcOff)

Local aArea := {SC6->(GetArea()),EE7->(GetArea()),EE8->(GetArea()),GetArea()}
Local aRet := {}
Local nCnt := 0
Local cPed := aCab[aScan(aCab,{|x| Alltrim(x[1]) == "C5_NUM"})][2]
Local lGravou := .F.
Local lContinua := .T.
Local cFilAntSav := ""
Local nRecnoEE8 := 0
Local lGrvOffS := .F.

// atualiza o item correto do pedido de venda no array asif	
EE7->(dbSetOrder(1))
EE8->(dbSetOrder(1))
SC6->(dbSetOrder(1))
For nCnt:=1 To Len(aSif)
// verifica se item tem sif´s diferente e se jah foi processado
If aSif[nCnt][2] == cPed .and. aSif[nCnt][7] .and. aSif[nCnt][9]
If SC6->(dbSeek(xFilial("SC6")+cPed))
While SC6->(!Eof()) .and. xFilial("SC6")+cPed == SC6->C6_FILIAL+SC6->C6_NUM
If SC6->C6_ZGERSIF == "S"
lGravou := .F.
lGrvOffS := .F.
If EE8->(dbSeek(xFilial("EE8")+cPedExp))
While EE8->(!Eof()) .and. xFilial("EE8")+cPedExp == EE8->EE8_FILIAL+EE8->EE8_PEDIDO
If SC6->C6_PRODUTO == EE8->EE8_COD_I .and. Empty(EE8->EE8_FATIT) .and. EE8->EE8_ZGERSI == "S"
EE8->(RecLock("EE8",.F.))
EE8->EE8_FATIT := SC6->C6_ITEM
EE8->(MsUnLock())
lGravou := .T.
// verifica off-shore
If lProcOff
nRecnoEE8 := EE8->(Recno())
If EE7->(dbSeek(xFilial("EE7")+cPedExp))
If EE7->EE7_INTERM == "1"
lGravou := .F.
lGrvOffS := .T.
cFilAntSav := cFilAnt 
cFilAnt := Alltrim(GetMv("MV_AVG0024"))
If EE8->(dbSeek(xFilial("EE8")+cPedExp))
While EE8->(!Eof()) .and. xFilial("EE8")+cPedExp == EE8->EE8_FILIAL+EE8->EE8_PEDIDO
If SC6->C6_PRODUTO == EE8->EE8_COD_I .and. Empty(EE8->EE8_FATIT) .and. EE8->EE8_ZGERSI == "S"
EE8->(RecLock("EE8",.F.))
EE8->EE8_FATIT := SC6->C6_ITEM
EE8->(MsUnLock())
lGravou := .T.
Exit
Endif	
EE8->(dbSkip())
Enddo
Endif
cFilAnt := cFilAntSav
Endif
Endif				
EE8->(dbGoto(nRecnoEE8))
Endif	
Exit
Endif
EE8->(dbSkip())
Enddo
Endif
If !lGravou
cMens := "Problema na execução da alteração do Pedido de Exportação"+IIf(lGrvOffS," (OFF-SHORE)","")+", campo EE8_FATIT, Filial: "+aSif[nCnt][1]+", Carga: "+Carga:Cabecalho:Ordem_Embarque+", Pedido: "+aSif[nCnt][2]+", Pedido de Exportação: "+cPedExp
lContinua := .F.
ConOut(cMens)
aRet := {}
aAdd(aRet,lContinua)
aAdd(aRet,cMens)				
Exit
Endif	
Endif
SC6->(dbSkip())
Enddo
Endif
Exit
Endif
Next							

If Len(aRet) == 0
aRet := {.T.,""}
Endif

aEval(aArea,{|x| RestArea(x)})

Return(aRet)	
*/


Static Function GrvTabTemp(Carga)

	Local aArea := {GetArea()}
	Local aRet := {}
	Local nCnt := 0
	Local cId := GetMv("MGF_OEID",,"000000")

	cId := Soma1(cId)
	PutMv("MGF_OEID",cId)

	ZDI->(RecLock("ZDI",.T.))
	ZDI->ZDI_FILIAL := Carga:Cabecalho:Filial
	ZDI->ZDI_ACAO := Carga:Cabecalho:Acao
	ZDI->ZDI_OE := Carga:Cabecalho:Ordem_Embarque
	ZDI->ZDI_PLACA := Carga:Cabecalho:Caminhao
	ZDI->ZDI_MOTORI := Carga:Cabecalho:Motorista
	ZDI->ZDI_TRANSP := Carga:Cabecalho:Transportadora
	ZDI->ZDI_NUMEXP := Carga:Cabecalho:NumeroExportacao
	ZDI->ZDI_DISTAN := Carga:Cabecalho:Distancia
	ZDI->ZDI_DTESTU := sTod(Carga:Cabecalho:Data_Estufagem)
	ZDI->ZDI_LACSIF := Carga:Cabecalho:Lacre_Sif
	ZDI->ZDI_OBSEEC := Carga:Cabecalho:Obs_EEC
	ZDI->ZDI_NUMCON := Carga:Cabecalho:Num_Container
	ZDI->ZDI_TPCON := Carga:Cabecalho:Tipo_Container
	ZDI->ZDI_DATA := dDataBase
	ZDI->ZDI_ID := cId
	ZDI->ZDI_STATUS := "0"
	ZDI->(MsUnLock())

	For nCnt:=1 To Len(Carga:Itens)
		ZDJ->(RecLock("ZDJ",.T.))
		ZDJ->ZDJ_FILIAL := Carga:Itens[nCnt]:Filial	
		ZDJ->ZDJ_OE := Carga:Itens[nCnt]:Ordem_Embarque	     
		ZDJ->ZDJ_PEDIDO := Carga:Itens[nCnt]:Pedido
		ZDJ->ZDJ_PRODPV := Carga:Itens[nCnt]:Item_Ped	     
		ZDJ->ZDJ_QTDLIB := Carga:Itens[nCnt]:Qtd_Lib	     
		ZDJ->ZDJ_PESLIQ := Carga:Itens[nCnt]:Peso	     
		ZDJ->ZDJ_PESBRU := Carga:Itens[nCnt]:Peso_Bruto	     
		ZDJ->ZDJ_SIFPED := Carga:Itens[nCnt]:Sif_Pedido	     
		ZDJ->ZDJ_SIF := Carga:Itens[nCnt]:Sif
		ZDJ->ZDJ_SIFPRO := Carga:Itens[nCnt]:Sif_Produto	     
		ZDJ->ZDJ_LOCMAT := Carga:Itens[nCnt]:Local_Matadouro	     
		ZDJ->ZDJ_LOCPRO := Carga:Itens[nCnt]:Local_Producao	     
		ZDJ->ZDJ_TOTCAI := Carga:Itens[nCnt]:Total_Caixas	     
		ZDJ->ZDJ_DTPRDE := sTod(Carga:Itens[nCnt]:Producao_de)
		ZDJ->ZDJ_DTPRAT := sTod(Carga:Itens[nCnt]:Producao_ate)
		ZDJ->ZDJ_DATA := dDataBase
		ZDJ->ZDJ_ID := cId
		ZDJ->ZDJ_STATUS := "0"
		ZDJ->(MsUnLock())
	Next	

	For nCnt:=1 To Len(Carga:Volumes)
		ZDK->(RecLock("ZDK",.T.))
		ZDK->ZDK_FILIAL := Carga:Volumes[nCnt]:Filial	
		ZDK->ZDK_OE := Carga:Volumes[nCnt]:Ordem_Embarque	
		ZDK->ZDK_PEDIDO := Carga:Volumes[nCnt]:Pedido
		ZDK->ZDK_QTD := Carga:Volumes[nCnt]:Quantidade	
		ZDK->ZDK_DATA := dDataBase
		ZDK->ZDK_ID := cId
		ZDK->ZDK_STATUS := "0"
		ZDK->(MsUnLock())
	Next	

	If Len(aRet) == 0
		aRet := {.T.,""}
	Endif

	aEval(aArea,{|x| RestArea(x)})

Return(aRet)	


/*
// rotina para alterar a quantidado do pedido, em funcao da quantidade do taura ser diferente da quantidade atual do pedido 
Static Function AltPVQtd(Carga,aQtdLib,aSif)

Local nCount := 0
Local nCnt := 0
Local aRet := {}
Local aCab := {}
Local aItem := {}
Local aItens := {}
Local aArea := {SC5->(GetArea()),SC6->(GetArea()),SX3->(GetArea()),EE7->(GetArea()),EE8->(GetArea()),GetArea()}
Local cChave := ""
Local cMens := ""
Local lContinua := .T.
Local nCnt1 := 0
Local nPos := 0
Local lPedExp := .F.
Local aDadosEE7 := {}
Local nModuloSav := nModulo
Local cModuloSav := cModulo
Local cTime1 := ""
Local cTime2 := ""
Local nCntSav := 0
Local nCntFis45 := 0
Local lPula := .F.
Local lPVRotAuto := GetMv("MGF_OEPVRT",.F.,.F.)

Private lMsErroAuto := .F.

// verifica se deve alterar as quantidades dos pedidos
If !GetMv("MGF_OEALTQ",.F.,.F.)
aRet := {.T.,""}
Return(aRet)
Endif

cTime1 := Time()		
If lContinua
nCnt := 1
While nCnt <= Len(aQtdLib)
aCab := {}
aItem := {}
aItens := {}
lPedExp := .F.
lPula := .F.

If aQtdLib[nCnt][16] .and. aQtdLib[nCnt][15] > 0 // soh exportacao
// verifica se o pedido e item jah foi processado no fis45, se foi, nao processa novamente, pois as quantidades jah foram ajustadas
For nCntFis45:=1 To Len(aSif)
If aSif[nCntFis45][1] == aQtdLib[nCnt][1] .and. aSif[nCntFis45][2] == aQtdLib[nCnt][2] .and. aSif[nCntFis45][3] == aQtdLib[nCnt][3] .and. aSif[nCntFis45][9]/*processado no fis45*/
/*					lPula := .T.
Exit
Endif
Next

If lPula		
nCnt++
Loop
Endif	

cChave := aQtdLib[nCnt][1]+aQtdLib[nCnt][2]

SC5->(dbSetOrder(1)) // obs: deixar estes dbsetorder aqui, pois quando usa rotina automatica a ordem das tabelas podem ser alteradas
If SC5->(dbSeek(aQtdLib[nCnt][1]+aQtdLib[nCnt][2]))
If !Empty(SC5->C5_PEDEXP)
lPedExp := .T.
nModulo := 29 // EEC 
cModulo := "EEC"
Endif
If !lPedExp
aCab := ArraySX3("SC5")
Else
aDadosEE7 := DadosEE7(SC5->C5_NUM)	
If Len(aDadosEE7) > 0
EE7->(dbGoto(aDadosEE7[1]))
If EE7->(Recno()) == aDadosEE7[1]
aCab := ArraySX3("EE7")
Endif
Endif		
Endif	        
Endif			

If !lPedExp
// carrega todos os itens do PV
SC6->(dbSetOrder(1))
If SC6->(dbSeek(aQtdLib[nCnt][1]+aQtdLib[nCnt][2]))
While SC6->(!Eof()) .and. aQtdLib[nCnt][1]+aQtdLib[nCnt][2] == SC6->C6_FILIAL+SC6->C6_NUM
lPula := .F.

// reposiciona variavel ncnt para refletir o item correto do array aQtdLib
If (nPos:=aScan(aQtdLib,{|x| Alltrim(x[1])+Alltrim(x[2])+Alltrim(x[3]) == Alltrim(SC6->C6_FILIAL)+Alltrim(SC6->C6_NUM)+Alltrim(SC6->C6_ITEM)})) > 0						
nCnt := nPos
Endif	

aItem := {}
// a rotina automatica estah zerando alguns campos do sc6 que nao estao indo no array
// , desta forma, estao sendo enviados todos os campos do sc6 que tem conteudo
aItem := ArraySX3("SC6")
// zera campo para controle da quantidade original
If (nPos:=aScan(aItem,{|x| Alltrim(x[1]) == "C6_ZQTDHIS"})) == 0
aAdd(aItem,{"C6_ZQTDHIS",0,Nil})	
Else
aItem[nPos][2] := 0
Endif

// soh altera valores nos itens que estao sendo alterados na quantidade		
If aQtdLib[nCnt][16] .and. aQtdLib[nCnt][15] > 0 
// se foi processado no fis45 nao altera as quantidades
For nCntFis45:=1 To Len(aSif)
If aSif[nCntFis45][1] == aQtdLib[nCnt][1] .and. aSif[nCntFis45][2] == aQtdLib[nCnt][2] .and. aSif[nCntFis45][3] == aQtdLib[nCnt][3] .and. aSif[nCntFis45][9]/*processado no fis45*/
/*									lPula := .T.
Exit
Endif
Next

If !lPula
If lPVRotAuto
aItem[aScan(aItem,{|x| Alltrim(x[1]) == "C6_ZQTDHIS"})][2] := aItem[aScan(aItem,{|x| Alltrim(x[1]) == "C6_QTDVEN"})][2]
aItem[aScan(aItem,{|x| Alltrim(x[1]) == "C6_QTDVEN"})][2] := aQtdLib[nCnt][4]
aItem[aScan(aItem,{|x| Alltrim(x[1]) == "C6_VALOR"})][2] := A410Arred(aItem[aScan(aItem,{|x| Alltrim(x[1]) == "C6_QTDVEN"})][2]*aItem[aScan(aItem,{|x| Alltrim(x[1]) == "C6_PRCVEN"})][2],"C6_VALOR") // valor
Endif	

If !lPVRotAuto
ConOut("Inicio MATA410 Alt.Qtd. - Pedido de Venda: "+aCab[aScan(aCab,{|x| Alltrim(x[1]) == "C5_NUM"})][2])

SC6->(RecLock("SC6",.F.))
SC6->C6_ZQTDHIS := aItem[aScan(aItem,{|x| Alltrim(x[1]) == "C6_QTDVEN"})][2]
SC6->C6_QTDVEN := aQtdLib[nCnt][4]
SC6->C6_VALOR := A410Arred(aItem[aScan(aItem,{|x| Alltrim(x[1]) == "C6_QTDVEN"})][2]*aItem[aScan(aItem,{|x| Alltrim(x[1]) == "C6_PRCVEN"})][2],"C6_VALOR") // valor
SC6->(MsUnLock())

ConOut("Termino MATA410 Alt.Qtd. - Pedido de Venda: "+aCab[aScan(aCab,{|x| Alltrim(x[1]) == "C5_NUM"})][2])
ConOut("")
Endif	
Endif	
Endif	

aAdd(aItens,aClone(aItem))
SC6->(dbSkip())
Enddo
Endif
Else
// carrega todos os itens do pedido de exportacao
If Len(aDadosEE7) > 0
EE8->(dbSetOrder(1))
If EE8->(dbSeek(xFilial("EE8")+aDadosEE7[2]))
While EE8->(!Eof()) .and. xFilial("EE8")+aDadosEE7[2] == EE8->EE8_FILIAL+EE8->EE8_PEDIDO
lPula := .F.

// reposiciona variavel ncnt para refletir o item correto do array aQtdLib
If (nPos:=aScan(aQtdLib,{|x| Alltrim(x[1])+Alltrim(x[2])+Alltrim(x[3]) == Alltrim(EE8->EE8_FILIAL)+Alltrim(EE7->EE7_PEDFAT)+Alltrim(EE8->EE8_FATIT)})) > 0
nCnt := nPos
Endif	

aItem := {}
aItem := ArraySX3("EE8")
// zera campo para controle da quantidade original
If (nPos:=aScan(aItem,{|x| Alltrim(x[1]) == "EE8_ZQTDHI"})) == 0
aAdd(aItem,{"EE8_ZQTDHI",0,Nil})	
Else
aItem[nPos][2] := 0
Endif		
If (nPos:=aScan(aItem,{|x| Alltrim(x[1]) == "EE8_SLDATU"})) == 0
aAdd(aItem,{"EE8_SLDATU",0,Nil})	
EndIF

// soh altera valores nos itens que estao sendo alterados na quantidade		
If aQtdLib[nCnt][16] .and. aQtdLib[nCnt][15] > 0 
// se foi processado no fis45 nao altera as quantidades
For nCntFis45:=1 To Len(aSif)
If aSif[nCntFis45][1] == aQtdLib[nCnt][1] .and. aSif[nCntFis45][2] == aQtdLib[nCnt][2] .and. aSif[nCntFis45][3] == aQtdLib[nCnt][3] .and. aSif[nCntFis45][9]/*processado no fis45*/
/*										lPula := .T.
Exit
Endif
Next

If !lPula
aItem[aScan(aItem,{|x| Alltrim(x[1]) == "EE8_ZQTDHI"})][2] := aItem[aScan(aItem,{|x| Alltrim(x[1]) == "EE8_SLDINI"})][2]
aItem[aScan(aItem,{|x| Alltrim(x[1]) == "EE8_SLDINI"})][2] := aQtdLib[nCnt][4]
// Alteração Carneiro 18/01                 
aItem[aScan(aItem,{|x| Alltrim(x[1]) == "EE8_SLDATU"})][2] := aQtdLib[nCnt][4]
Endif	
Endif	

aAdd(aItens,aClone(aItem))
EE8->(dbSkip())
Enddo
Endif
Endif	
Endif

nCntSav := nCnt	
// pula para proximo PV
While nCnt <= Len(aQtdLib)	
nCnt++
If nCnt > Len(aQtdLib)
Exit
Endif	
If aQtdLib[nCnt][1]+aQtdLib[nCnt][2] == cChave
Loop
Else
Exit	
Endif	
Enddo

If Len(aCab) > 0 .and. Len(aItens) > 0
lMsErroAuto := .F.
If !lPedExp	
If lPVRotAuto 
ConOut("Inicio MATA410 Alt.Qtd. - Pedido de Venda: "+aCab[aScan(aCab,{|x| Alltrim(x[1]) == "C5_NUM"})][2])

MSExecAuto({|x,y,z| Mata410(x,y,z)},aCab,aItens,4)

ConOut("Termino MATA410 Alt.Qtd. - Pedido de Venda: "+aCab[aScan(aCab,{|x| Alltrim(x[1]) == "C5_NUM"})][2])
ConOut("Resultado lMsErroAuto MATA410 Alt.Qtd. : "+iif(lMsErroAuto,".T.",".F.")+" - Pedido de Venda: "+aCab[aScan(aCab,{|x| Alltrim(x[1]) == "C5_NUM"})][2])
ConOut("")
Endif	
Else	

// necessario chamar a rotina eecap100 via execauto, dentro de um startjob, pois a rotina tem diversos pontos que mostra tela usando a funcao msgstop e com a chamada via
// startjob, alguns destes pontos tem tratamento via variavel, para nao executar a msgstop, quando chamada via job.
// outros pontos que sao mostrados tela devido a msgstop foram identificados em gatilhos, e foi inserido uma condicao para que o gatilho nao seja acionado, quando
// chamado por esta rotina.
//aRet := StartJob("U_TAS02EECAP100",GetEnvServer(),.T.,aCab,aItens,aSif[nCntSav][1],Carga:Cabecalho:Ordem_Embarque,aSif[nCntSav][2],aCab[aScan(aCab,{|x| Alltrim(x[1]) == "EE7_PEDIDO"})][2])
aRet := U_TAS02EECAP100(aCab,aItens,aQtdLib[nCntSav][1],Carga:Cabecalho:Ordem_Embarque,aQtdLib[nCntSav][2],aCab[aScan(aCab,{|x| Alltrim(x[1]) == "EE7_PEDIDO"})][2])
/*
// tratamento para quando ocorrer erro no startjob, neste caso o tratamento de erro, begin sequence, nao traz o erro retornado pelo sistema
If ValType(aRet) <> "A"
lContinua := .F.
cMens := "Problema na execução da alteração do Pedido de Exportação, 'erro no StartJob', Filial: "+aSif[nCntSav][1]+", Carga: "+Carga:Cabecalho:Ordem_Embarque+", Pedido: "+aSif[nCntSav][2]+", Pedido de Exportação: "+aCab[aScan(aCab,{|x| Alltrim(x[1]) == "EE7_PEDIDO"})][2]
aRet := {}
aAdd(aRet,lContinua)
aAdd(aRet,cMens)
Endif	
*/
/*				Endif		

If !lPedExp	
If lMsErroAuto
cFileLog := NomeAutoLog()
If !Empty(cFileLog)
cMens := "Problema na execução da alteração do Pedido de Venda, Filial: "+aQtdLib[nCntSav][1]+", Carga: "+Carga:Cabecalho:Ordem_Embarque+", Pedido: "+aQtdLib[nCntSav][2]
cMens := cMens+CRLF+MemoRead(cFileLog)
Endif
lContinua := .F.
ConOut(cMens)
aRet := {}
aAdd(aRet,lContinua)
aAdd(aRet,cMens)				
Exit
Endif
Else
lContinua := aRet[1]
cMens := aRet[2]

If !lContinua
ConOut(cMens)
Exit
Endif	
Endif	
Endif	
Else
nCnt++	
Endif	 
Enddo	
Endif
cTime2 := Time()
cMensTime := "ORDEM EMBARQUE: "+Carga:Cabecalho:Ordem_Embarque+" - FIM ALTERAÇÃO PEDIDO QUANTIDADE: "+ElapTime(cTime1,cTime2)+" - Time: "+Time()+CRLF
ConOut(cMensTime)
cLogTime += cMensTime

If Len(aRet) == 0
aRet := {.T.,""}
Endif

nModulo := nModuloSav
cModulo := cModuloSav

aEval(aArea,{|x| RestArea(x)})

Return(aRet)			
*/
/*
// rotina para alterar a quantidado do pedido, em funcao da quantidade do taura ser diferente da quantidade atual do pedido 
// rotina de estorno do pedido
Static Function AltPVEQtd(aPVQtd,Carga,aPV)

Local nCnt := 0
Local aRet := {}
Local aCab := {}
Local aItem := {}
Local aItens := {}
Local aArea := {SC5->(GetArea()),SC6->(GetArea()),SX3->(GetArea()),GetArea()}
Local cChave := ""
Local cMens := ""
Local nPos := 0
Local cFileLog := ""
Local lPedExp := .F.
Local aDadosEE7 := {}
Local nModuloSav := nModulo
Local cModuloSav := cModulo
Local nRecnoSC6 := 0
Local nPos1 := 0
Local nCntItem := 0
Local nRecnoEE8 := 0
Local nCntFis45 := 0
Local lPula := .F.
Local cTime1 := ""
Local cTime2 := ""
Local lPVRotAuto := GetMv("MGF_OEPVRT",.F.,.F.)

Private lMsErroAuto := .F.

// verifica se deve alterar as quantidades dos pedidos
If !GetMv("MGF_OEALTQ",.F.,.F.)
aRet := {.T.,""}
Return(aRet)
Endif

cTime1 := Time()		
nCnt := 1
While .T.
If nCnt > Len(aPVQtd)
Exit
Endif	
aCab := {}
aItem := {}
aItens := {}
lPedExp := .F.
cChave := aPVQtd[nCnt][1] //pedido
lPula := .F.	

While cChave == aPVQtd[nCnt][1]
If aPVQtd[nCnt][3]
// verifica se o pedido e item jah foi processado no fis45, se foi, nao processa novamente, pois as quantidades jah foram ajustadas
For nCntFis45:=1 To Len(aPV)
If aPV[nCntFis45][1] == aPVQtd[nCnt][1] .and. aPV[nCntFis45][2] == aPVQtd[nCnt][2] .and. aPV[nCntFis45][4]/*processado no fis45*/
/*					lPula := .T.
Exit
Endif
Next

If lPula		
nCnt++
Loop
Endif	

lPedExp := .F.
If Empty(aCab)

SC5->(dbSetOrder(1))
If SC5->(dbSeek(xFilial("SC5")+aPVQtd[nCnt][1]))
If !Empty(SC5->C5_PEDEXP)
lPedExp := .T.
nModulo := 29 // EEC
cModulo := "EEC"
Endif
If !lPedExp
aCab := ArraySX3("SC5")
Else
//aDadosEE7 := DadosEE7(IIf(!lOffS,SC5->C5_NUM,aPVQtd[nCnt][1]))	
aDadosEE7 := DadosEE7(SC5->C5_NUM)	
If Len(aDadosEE7) > 0
EE7->(dbGoto(aDadosEE7[1]))
If EE7->(Recno()) == aDadosEE7[1]
aCab := ArraySX3("EE7")
Endif
Endif		
Endif	        
Endif	
Endif	

If !lPedExp
SC6->(dbSetOrder(1))
If SC6->(dbSeek(xFilial("SC6")+aPVQtd[nCnt][1]))//+aPVQtd[nCnt][2]))
While SC6->(!Eof()) .and. xFilial("SC6")+aPVQtd[nCnt][1] == SC6->C6_FILIAL+SC6->C6_NUM
aItem := {}
aItem := ArraySX3("SC6")

aAdd(aItem,{"AUTDELETA","N",Nil})

// se item teve quantidade alterada em funcao do taura, volta quantidade original do item
If (nPos:=aScan(aItem,{|x| Alltrim(x[1]) == "C6_ZQTDHIS"})) > 0
If aItem[nPos][2] > 0
If lPVRotAuto 
// retorna quantidade do item
aItem[aScan(aItem,{|x| Alltrim(x[1]) == "C6_QTDVEN"})][2] := aItem[nPos][2]
// recalcula valor total do item
aItem[aScan(aItem,{|x| Alltrim(x[1]) == "C6_VALOR"})][2] := A410Arred(aItem[aScan(aItem,{|x| Alltrim(x[1]) == "C6_QTDVEN"})][2]*aItem[aScan(aItem,{|x| Alltrim(x[1]) == "C6_PRCVEN"})][2],"C6_VALOR")
Endif

If !lPVRotAuto 	
SC6->(RecLock("SC6",.F.))
// retorna quantidade do item
SC6->C6_QTDVEN := aItem[nPos][2]
// recalcula valor total do item
SC6->C6_VALOR := A410Arred(aItem[aScan(aItem,{|x| Alltrim(x[1]) == "C6_QTDVEN"})][2]*aItem[aScan(aItem,{|x| Alltrim(x[1]) == "C6_PRCVEN"})][2],"C6_VALOR")
SC6->(MsUnLock())
Endif

// zera quantidade do historico
aItem[nPos][2] := 0
Endif
Endif		

aAdd(aItens,aClone(aItem))
SC6->(dbSkip())
Enddo
Endif
Else
// carrega todos os itens do pedido de exportacao
If Len(aDadosEE7) > 0
EE8->(dbSetOrder(1))
If EE8->(dbSeek(xFilial("EE8")+aDadosEE7[2]))
While EE8->(!Eof()) .and. xFilial("EE8")+aDadosEE7[2] == EE8->EE8_FILIAL+EE8->EE8_PEDIDO
aItem := {}
aItem := ArraySX3("EE8")

aAdd(aItem,{"AUTDELETA","N",Nil})

If (nPos:=aScan(aItem,{|x| Alltrim(x[1]) == "EE8_SLDATU"})) == 0
aAdd(aItem,{"EE8_SLDATU",0,Nil})	
EndIF
// se item teve quantidade alterada em funcao do taura, volta quantidade original do item
If (nPos:=aScan(aItem,{|x| Alltrim(x[1]) == "EE8_ZQTDHI"})) > 0
If aItem[nPos][2] > 0
// retorna quantidade do item
aItem[aScan(aItem,{|x| x[1] == "EE8_SLDINI"})][2] := aItem[nPos][2]
// Alteração Carneiro 18/01                                       
aItem[aScan(aItem,{|x| x[1] == "EE8_SLDATU"})][2] := aItem[nPos][2]           
// zera quantidade do historico                                                                                                       
aItem[nPos][2] := 0
Endif
Endif		

aAdd(aItens,aClone(aItem))
EE8->(dbSkip())
Enddo
Endif
Endif	
Endif
// pula para proximo PV
While nCnt <= Len(aPVQtd)	
nCnt++
If nCnt > Len(aPVQtd)
Exit
Endif	
If aPVQtd[nCnt][1] == cChave
Loop
Else
Exit	
Endif	
Enddo
Else
nCnt++
Endif
If nCnt > Len(aPVQtd)
Exit
Endif	
Enddo		
If Len(aCab) > 0 .and. Len(aItens) > 0
lMsErroAuto := .F.
If !lPedExp
If lPVRotAuto	
ConOut("Inicio MATA410 Alt.Qtd. - Pedido de Venda: "+aCab[aScan(aCab,{|x| Alltrim(x[1]) == "C5_NUM"})][2])

MSExecAuto({|x,y,z| Mata410(x,y,z)},aCab,aItens,4)

ConOut("Termino MATA410 Alt.Qtd.  - Pedido de Venda: "+aCab[aScan(aCab,{|x| Alltrim(x[1]) == "C5_NUM"})][2])
ConOut("Resultado lMsErroAuto MATA410 Alt.Qtd.: "+iif(lMsErroAuto,".T.",".F.")+" - Pedido de Venda: "+aCab[aScan(aCab,{|x| Alltrim(x[1]) == "C5_NUM"})][2])
ConOut("")
Endif	
Else
//aRet := StartJob("U_TAS02EECAP100",GetEnvServer(),.T.,aCab,aItens,xFilial("SC5"),Carga:Cabecalho:Ordem_Embarque,cChave,aCab[aScan(aCab,{|x| Alltrim(x[1]) == "EE7_PEDIDO"})][2])
aRet := U_TAS02EECAP100(aCab,aItens,xFilial("SC5"),Carga:Cabecalho:Ordem_Embarque,cChave,aCab[aScan(aCab,{|x| Alltrim(x[1]) == "EE7_PEDIDO"})][2])

/*
// tratamento para quando ocorrer erro no startjob, neste caso o tratamento de erro, begin sequence, nao traz o erro retornado pelo sistema
If ValType(aRet) <> "A"
cMens := "Problema na execução da alteração do Pedido de Exportação, 'erro no StartJob', Filial: "+xFilial("SC5")+", Carga: "+Carga:Cabecalho:Ordem_Embarque+", Pedido: "+cChave+", Pedido de Exportação: "+aCab[aScan(aCab,{|x| Alltrim(x[1]) == "EE7_PEDIDO"})][2]
aRet := {}
aAdd(aRet,.F.)
aAdd(aRet,cMens)
Exit
Endif	
*/
/*		Endif	

If !lPedExp	
If lMsErroAuto
cFileLog := NomeAutoLog()
If !Empty(cFileLog)
cMens := "Problema na execução da alteração do Pedido de Venda, Filial: "+xFilial("SC5")+", Carga: "+Carga:Cabecalho:Ordem_Embarque+", Pedido: "+cChave
cMens := cMens+CRLF+MemoRead(cFileLog)
Endif
ConOut(cMens)
aRet := {}
aAdd(aRet,.F.)
aAdd(aRet,cMens)				
Exit
Endif	
Else
// nao faz nada
Endif				
If Len(aRet) > 0
If !aRet[1]
Exit
Endif	
Endif	
Endif		
Enddo	
cTime2 := Time()
cMensTime := "ORDEM EMBARQUE: "+Carga:Cabecalho:Ordem_Embarque+" - FIM ESTORNO ALTERAÇÃO PEDIDO QUANTIDADE: "+ElapTime(cTime1,cTime2)+" - Time: "+Time()+CRLF
ConOut(cMensTime)
cLogTime += cMensTime

If Len(aRet) == 0
aRet := {.T.,""}
Endif

nModulo := nModuloSav
cModulo := cModuloSav

aEval(aArea,{|x| RestArea(x)})

Return(aRet)			
*/


// rotina para calcular a quantidade de caixas por sif
Static Function TotCaixas(Carga,cSif,cPedido,cProduto,cSifFil)

	Local nCnt := 0
	Local aRet := {0,0,0,0}
	Local lSifFil := .T. // indica se deve avaliar o sif da filial corrente ou de outras filiais
	Local lFis45 := .T.

	// verifica se deve executar o FIS45
	If !GetMv("MGF_F45EXE",.F.,.T.)
		lFis45 := .F.
	Endif

	If cSif $ cSifFil //.and. !(cSif == "0" .or. cSif == "00" .or. cSif == "000" .or. cSif == "0000") // sif zerado, sempre considera como se fosse sif de outra filial
		lSifFil := .T.
	Else
		lSifFil := .F.	
	Endif

	For nCnt:=1 To Len(Carga:Itens)
		If Alltrim(cPedido) == Alltrim(Carga:Itens[nCnt]:Pedido) .and. Alltrim(cProduto) == Alltrim(Carga:Itens[nCnt]:Item_Ped)
			If lFis45
				If lSifFil
					If Carga:Itens[nCnt]:Sif_Produto $ cSifFil
						aRet[1] += Carga:Itens[nCnt]:Total_Caixas
						aRet[2] += Carga:Itens[nCnt]:Peso
						aRet[3] += Carga:Itens[nCnt]:Peso_Bruto
						aRet[4] += Carga:Itens[nCnt]:Qtd_Lib
					Endif
				Else
					If !Carga:Itens[nCnt]:Sif_Produto $ cSifFil //.or. (cSif == "0" .or. cSif == "00" .or. cSif == "000" .or. cSif == "0000") // sif zerado, sempre considera como se fosse sif de outra filial
						aRet[1] += Carga:Itens[nCnt]:Total_Caixas
						aRet[2] += Carga:Itens[nCnt]:Peso
						aRet[3] += Carga:Itens[nCnt]:Peso_Bruto
						aRet[4] += Carga:Itens[nCnt]:Qtd_Lib
					Endif
				Endif
			Else
				aRet[1] += Carga:Itens[nCnt]:Total_Caixas	
				aRet[2] += Carga:Itens[nCnt]:Peso
				aRet[3] += Carga:Itens[nCnt]:Peso_Bruto
				aRet[4] += Carga:Itens[nCnt]:Qtd_Lib
			Endif
		Endif	
	Next

Return(aRet)


// rotina de verificacao do sc9, se jah foi faturado
Static Function FatSC9(cCarga)

	Local aArea := {GetArea()}
	Local cQ := ""
	Local lRet := .F.
	Local cAliasTrb := GetNextAlias()

	cQ := "SELECT 1 "
	cQ += "FROM "+RetSqlName("SC9")+" SC9 "
	cQ += "WHERE "
	cQ += "C9_FILIAL = '"+xFilial("SC9")+"' "
	cQ += "AND C9_CARGA = '"+Padr(cCarga,TamSX3("C9_CARGA")[1])+"' "
	cQ += "AND C9_SERIENF <> ' ' "
	cQ += "AND C9_NFISCAL <> ' ' "
	cQ += "AND SC9.D_E_L_E_T_ <> '*' "

	cQ := ChangeQuery(cQ)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),cAliasTrb,.T.,.T.)

	While (cAliasTrb)->(!Eof())
		lRet := .T.
		Exit
	Enddo

	(cAliasTrb)->(dbCloseArea()) 

Return(lRet)


// carrega registros deletados do pedido de exportacao, pela inclusao da carga
Static Function RegExcPedExp(cFil,cPed)

	Local aArea := {GetArea()}
	Local cQ := ""
	Local aRet := {}
	Local cAliasTrb := GetNextAlias()
	Local aChave := {}

	cQ := "SELECT R_E_C_N_O_ EE8_RECNO "
	cQ += "FROM "+RetSqlName("EE8")+" EE8 "
	cQ += "WHERE "
	cQ += "EE8_FILIAL = '"+cFil+"' "
	cQ += "AND EE8_PEDIDO = '"+cPed+"' "
	cQ += "AND EE8_ZOEDEL = 'S' "
	cQ += "AND EE8.D_E_L_E_T_ = '*' " // somente os deletados
	cQ += "ORDER BY R_E_C_N_O_ DESC "

	cQ := ChangeQuery(cQ)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),cAliasTrb,.T.,.T.)

	While (cAliasTrb)->(!Eof())
		EE8->(dbGoto((cAliasTrb)->EE8_RECNO))
		If EE8->(Recno()) == (cAliasTrb)->EE8_RECNO
			// soh carrega o ultimo recno de cada chave, pois a cada inclusao/exclusao da integracao vai ficar um registro desta chave no ee8
			If aScan(aChave,{|x| x[1]+x[2]+x[3]+x[4] == EE8->EE8_FILIAL+EE8->EE8_PEDIDO+EE8->EE8_SEQUEN+EE8->EE8_COD_I}) == 0 
				aAdd(aChave,{EE8->EE8_FILIAL,EE8->EE8_PEDIDO,EE8->EE8_SEQUEN,EE8->EE8_COD_I})
				aAdd(aRet,(cAliasTrb)->EE8_RECNO)
			Endif	
		Endif	
		(cAliasTrb)->(dbSkip())
	Enddo

	(cAliasTrb)->(dbCloseArea()) 

Return(aRet)


// valida se todos os itens enviados pelo taura foram liberados
Static Function VldLib(aSif,Carga,aQtdLib,lSemCarga)

	Local aArea := {GetArea()}
	Local aRet := {}
	Local lRet := .T.
	Local cMens := ""
	Local nCnt := 0
	Local nQtd := 0
	Local lFis45 := .T.
	Local nQtdAgru := 0
	Local nPos := 0

	// verifica se deve executar o FIS45
	If !GetMv("MGF_F45EXE",.F.,.T.)
		lFis45 := .F.
	Endif

	// compara quantidade liberada com a quantidade enviada pelo taura
	For nCnt := 1 To Len(aSif)
		nQtdAgru := 0

		// se nao tiver fis45 na filial, o array asif jah tem as quantidades agrupadas por item
		If !lFis45
			nQtdAgru := aSif[nCnt][5]
		Else 
			// se tiver fis45 na filial, o array asif somente tem as quantidades agrupadas por item se o item em questao teve processo de fis45, caso contrario, 
			// as quantidades agrupadas devem ser carregadas do array aqtdlib, desta forma, sempre pega no aqtdlib
			If (nPos:=aScan(aQtdLib,{|x| x[1]+x[2]+x[3]==aSif[nCnt][1]+aSif[nCnt][2]+aSif[nCnt][3]})) > 0
				nQtdAgru := aQtdLib[nPos][4]
			Endif
		Endif		

		If !lSemCarga
			nQtd := DadosSC9(aSif[nCnt][2],aSif[nCnt][3],.F.,.F.,Carga:Cabecalho:Ordem_Embarque,.T.)
		Else
			nQtd := DadosSC9(aSif[nCnt][2],aSif[nCnt][3],.F.,.F.,"",.T.)
		Endif	
		If nQtd != nQtdAgru .or. Empty(nQtd) .or. Empty(nQtdAgru)
			lRet := .F.
			If !lSemCarga
				cMens := "Item não encontrado na tabela SC9, liberado nesta carga, Filial: "+Carga:Cabecalho:Filial+", Carga: "+Carga:Cabecalho:Ordem_Embarque+", Pedido: "+aSif[nCnt][2]+", Item: "+aSif[nCnt][3]+", Qtd. Taura: "+Alltrim(Str(nQtdAgru))+", Qtd. liberada Protheus: "+Alltrim(Str(nQtd))
			Else
				cMens := "Item não encontrado na tabela SC9, liberação do PV (carga em branco), Filial: "+Carga:Cabecalho:Filial+", Carga: "+Carga:Cabecalho:Ordem_Embarque+", Pedido: "+aSif[nCnt][2]+", Item: "+aSif[nCnt][3]+", Qtd. Taura: "+Alltrim(Str(nQtdAgru))+", Qtd. liberada Protheus: "+Alltrim(Str(nQtd))
			Endif	
			ConOut(cMens)
			Exit
		Endif
	Next		

	aRet := {}
	aAdd(aRet,lRet)
	aAdd(aRet,cMens)

	aEval(aArea,{|x| RestArea(x)})	

Return(aRet)


// verifica se as tabelas do EEC estao em lock, pois ocorreram alguns casos de erro de lock na tabela EEC e o pedido foi alterado pela metade, 
// a execauto retornou .F. e a rotina seguiu o processamento normalmente. 
// O correto era o execauto retornar .T. para a rotina parar o processamento e desarmar a transacao.
Static Function LockEEC(cAlias,nOrdem,cFil,cCarga,cPed,cPedExp,cChave)

	Local aArea := {(cAlias)->(GetArea()),GetArea()}
	Local aRet := {}
	Local lRet := .T.
	Local cMens := ""
	Local nVezes := 0
	Local cSavcInternet := Nil
	Local nVezesTot := GetMv("MGF_OELKVE",,5)
	Local nVezesTime := GetMv("MGF_OELKTI",,5000)

	If GetMv("MGF_OELKEE",,.F.)
		If Type("__cInterNet") <> "U"
			cSavcInternet := __cInternet
			//conout("***** passei Type(__cInterNet)")
		Endif	
		__cInternet := "AUTOMATICO"

		(cAlias)->(dbSetOrder(nOrdem))
		If (cAlias)->(dbSeek(xFilial(cAlias)+cChave))
			While nVezes <= nVezesTot
				If (cAlias)->(SimpleLock(cAlias))
					(cAlias)->(SoftLock(cAlias))
					(cAlias)->(MsUnLock())
					lRet := .T.
					//conout("***** passei lock: "+cAlias)
					Exit
				Else	
					nVezes++
					lRet := .F.
					ConOut("Verificando Lock: "+cAlias+", Chave: "+xFilial(cAlias)+cChave+", tentativa: "+Str(nVezes))
					Sleep(nVezesTime)
				Endif
			Enddo		
			If !lRet
				cMens := "Registro da tabela: "+cAlias+" em lock por outro usuário. "+Alltrim(TCInternal(53))+". Chave do lock: "+xFilial(cAlias)+cChave+", Filial: "+cFil+", Carga: "+cCarga+", Pedido: "+cPed+", Pedido de Exportação: "+cPedExp
			Endif	
		Endif			

		If cSavcInternet != Nil
			__cInternet := cSavcInternet
		Endif	
	Endif

	aRet := {}
	aAdd(aRet,lRet)
	aAdd(aRet,cMens)

	aEval(aArea,{|x| RestArea(x)})	

Return(aRet)


// valida se as quantidades foram alteradas corretamente no pedido de exportacao
// esta validacao se faz necessaria, pois no execauto do pedido de exportacao, quando ocorre algum lock de arquivos durante o execauto, o sistema aborta o processamento, 
// mas retorna .F. na variavel lmserroauto e a rotina segue o fluxo indevidamente
Static Function VldQtdExp(aSif,Carga,aQtdLib)

	Local aArea := {SC6->(GetArea()),EE7->(GetArea()),EE8->(GetArea()),GetArea()}
	Local aRet := {}
	Local lRet := .T.
	Local cMens := ""
	Local nCnt := 0
	Local nQtd := 0
	Local lFis45 := .T.
	Local nQtdAgru := 0
	Local nPos := 0
	Local aDadosEE7 := {}
	Local nQtdSC6 := 0

	// verifica se deve executar o FIS45
	If !GetMv("MGF_F45EXE",.F.,.T.)
		lFis45 := .F.
	Endif

	EE8->(dbSetOrder(1))
	SC6->(dbSetOrder(1))

	// compara quantidade com a quantidade enviada pelo taura
	For nCnt := 1 To Len(aSif)
		If !aSif[nCnt][16] // verifica se eh pedido de exportacao
			Loop
		Endif

		nQtdAgru := 0
		nQtd := 0
		nQtdSC6 := 0

		// se nao tiver fis45 na filial, o array asif jah tem as quantidades agrupadas por item
		If !lFis45
			nQtdAgru := aSif[nCnt][5]
		Else 
			// se tiver fis45 na filial, o array asif somente tem as quantidades agrupadas por item se o item em questao teve processo de fis45, caso contrario, 
			// as quantidades agrupadas devem ser carregadas do array aqtdlib, desta forma, sempre pega no aqtdlib
			If (nPos:=aScan(aQtdLib,{|x| x[1]+x[2]+x[3]==aSif[nCnt][1]+aSif[nCnt][2]+aSif[nCnt][3]})) > 0
				nQtdAgru := aQtdLib[nPos][4]
			Endif
		Endif		

		aDadosEE7 := DadosEE7(aSif[nCnt][2])
		If Len(aDadosEE7) > 0
			If EE8->(dbSeek(xFilial("EE8")+aDadosEE7[2]))
				While EE8->(!Eof()) .and. xFilial("EE8")+aDadosEE7[2] == EE8->EE8_FILIAL+EE8->EE8_PEDIDO
					If EE8->EE8_FATIT == aSif[nCnt][3]
						If SC6->(dbSeek(EE8->EE8_FILIAL+aSif[nCnt][2]+EE8->EE8_FATIT))
							If EE8->EE8_SLDINI != SC6->C6_QTDVEN
								nQtd := 0
								nQtdSC6 := SC6->C6_QTDVEN
								Exit
							Else
								nQtd := SC6->C6_QTDVEN
							Endif
						Endif
						Exit
					Endif
					EE8->(dbSkip())
				Enddo
			Endif
		Endif						

		//nQtd := GetAdvFVal("SC6","C6_QTDVEN",xFilial("SC6")+aSif[nCnt][2]+aSif[nCnt][3],1,0) //DadosSC9(aSif[nCnt][2],aSif[nCnt][3],.F.,.F.,Carga:Cabecalho:Ordem_Embarque,.T.)
		If nQtd != nQtdAgru .or. Empty(nQtd) .or. Empty(nQtdAgru)
			lRet := .F.
			cMens := "Quantidade enviada pelo Taura diferente do pedido, Filial: "+Carga:Cabecalho:Filial+", Carga: "+Carga:Cabecalho:Ordem_Embarque+", Pedido: "+aSif[nCnt][2]+", Item: "+aSif[nCnt][3]+", Qtd. Taura: "+Alltrim(Str(nQtdAgru))+", Qtd. Pedido: "+Alltrim(Str(nQtdSC6))
			ConOut(cMens)
			Exit
		Endif
	Next		

	aRet := {}
	aAdd(aRet,lRet)
	aAdd(aRet,cMens)

	aEval(aArea,{|x| RestArea(x)})	

Return(aRet)


Static Function DesblqReg(cAlias,aReg)

	Local nCnt := 1

	If GetMv("MGF_OEUNLO",,.T.) 
		For nCnt:=1 To Len(aReg)
			(cAlias)->(dbGoto(aReg[nCnt]))
			If (cAlias)->(Recno()) == aReg[nCnt]
				(cAlias)->(MsUnLock())
			Endif
		Next
	Endif	

Return()