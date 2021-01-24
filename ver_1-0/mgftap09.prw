#INCLUDE "PROTHEUS.CH"
/*
=====================================================================================
Programa.:              MGFTAP09
Autor....:              Atilio Amarilla
Data.....:              08/12/2016
Descricao / Objetivo:   Integração PROTHEUS x Taura - Processos Produtivos
Doc. Origem:            Contrato - GAP TAURA
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Job para Integração de Processos Produtivos do Taura
Obs......:              Chamada de execautos MATA270 (Inventário)
=====================================================================================
*/

User Function MGFTAP09( aParam )
    Local cError     := ''
	Local aTables		:= { "SB1" , "SB2" , "SM0" , "SB7" , "SB8" , "SC2" , "SD3" }
	Local aRetorno	:= {}
	Local aMata270	:= {}
	Local nOpc			:= 0 // Incluir
	Local cCodFil		:= aParam[2]
	Local cDatInv		:= StrTran(aParam[3],"-")
	Local dDatInv		:= STOD(cDatInv)
	Local cNumDoc		:= IIF(!Empty(aParam[7]),aParam[7],aParam[3]+"T")
	Local cCodPro		:= aParam[4]
	Local nQtdInv		:= aParam[5]
	Local cLotCtl		:= aParam[6]

	Local cErro		:= ""
	Local cStatus, cEndPad    

	Local	dMovBlq

	If aParam[1] == "1"
		nOpc := 3
	ElseIf aParam[1] == "2" // Exclusão
		nOpc := 5
	EndIf

	If nOpc == 0
		cStatus	:= "2"
		cNumDoc	:= ""
		cErro		:= "Opção Inválida: "+aParam[1]
	ElseIf Empty( cCodFil )
		cStatus	:= "2"
		cNumDoc	:= ""
		cErro		:= "Filial não informada!"
	ElseIf Empty( dDatInv )
		cStatus	:= "2"
		cNumDoc	:= ""
		cErro		:= "Data Inválida: "+AllTrim(cDatInv)
	Else


		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Preparação do Ambiente.                                                                                  |
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		*/

		//RpcSetEnv( "01" , cCodFil , Nil, Nil, "EST", Nil, aTables )

		If Select("SX3")==0

			lSetEnv	:= .T.
	
			RpcSetEnv( "01" , cCodFil , Nil, Nil, "EST") // , Nil, aTables )
	

		Else

			lSetEnv	:= .F.

		EndIf

		cFilAnt	:= cCodFil

		dMovBlq	:= GetMV("MV_DBLQMOV")
		dMovBlq	:= Max( dMovBlq , GetMV("MV_ULMES") )

		SetFunName("MGFTAP05")

		cEndPad		:= GetMv("MGF_TAP02T",,"01") // Integração Taura Produção
		cEndPad		:= Stuff( Space(TamSX3("D3_LOCALIZ")[1]) , 1 , Len(cEndPad) , cEndPad ) 

		cCodPro	:= Stuff( Space( TamSX3("B1_COD")[1] ) , 1 , Len(AllTrim(cCodPro)) , Alltrim(cCodPro) )
		cLotCtl	:= Stuff( Space( TamSX3("D3_LOTECTL")[1] ) , 1 , Len(AllTrim(cLotCtl)) , Alltrim(cLotCtl) )

		SB1->( dbSeek( xFilial("SB1")+cCodPro ) )
		If !Empty( cLotCtl ) .And. !SB1->B1_RASTRO $ "LS"
			cLotCtl	:= Space( TamSX3("B7_LOTECTL")[1] )
		EndIf



		//Busca SB7
		//B7_FILIAL+DTOS(B7_DATA)+B7_COD+B7_LOCAL+B7_LOCALIZ+B7_NUMSERI+B7_LOTECTL+B7_NUMLOTE+B7_CONTAGE
		If	SB7->( dbSeek( cCodFil + cDatInv + cCodPro + SB1->B1_LOCPAD + Space(Len(B7_LOCALIZ)) + Space(Len(B7_NUMSERI)) + cLotCtl ) )
			If nOpc == 3 /* Inclusão*/
				cStatus	:= "2"
				cNumDoc	:= ""
				cErro		:= "Produto"+IIF(Empty(cLotCtl),"","/Lote")+" "+AllTrim(cCodPro)+IIF(Empty(cLotCtl),"","/"+cLotCtl)+" já informado para data "+DTOC(dDatInv)+"!"
			EndIf
		ElseIf nOpc == 5 /* Exclusão*/ 
			cStatus	:= "2"
			cNumDoc	:= ""
			cErro		:= "[Exclusão] Produto"+IIF(Empty(cLotCtl),"","/Lote")+" "+AllTrim(cCodPro)+IIF(Empty(cLotCtl),"","/"+cLotCtl)+" não existe para data "+DTOC(dDatInv)+"!"
		ElseIf dDatInv <= dMovBlq 
			cStatus	:= "2"
			cErro	:= "Movimentacao com data anterior ao fechamento (Bloqueio de Movimentacao ou Virada de Saldos)."
		EndIf

		If Empty( cErro )
			
			dbSelectArea("SB2")
			dbSetOrder(1)
			If !SB2->( dbSeek( xFilial("SB2")+SB1->B1_COD+SB1->B1_LOCPAD ) )
				CriaSB2(SB1->B1_COD,SB1->B1_LOCPAD)
			EndIf

			aAdd( aMata270 ,	{ "B7_COD"		, cCodPro			, NIL	} )
			aAdd( aMata270 ,	{ "B7_LOCAL"	, SB1->B1_LOCPAD	, NIL	} )
			aAdd( aMata270 ,	{ "B7_DOC"		, cNumDoc			, NIL	} )
			aAdd( aMata270 ,	{ "B7_QUANT"	, nQtdInv			, NIL	} )
			aAdd( aMata270 ,	{ "B7_DATA"		, dDatInv			, NIL	} )
			If !Empty( cLotCtl ) .And. SB1->B1_RASTRO $ "LS"
				aAdd( aMata270 ,	{"B7_LOTECTL"	, cLotCtl		, NIL	} )
			EndIf
			If SB1->B1_LOCALIZ == "S"
				aAdd( aMata270 ,	{"B7_LOCALIZ"	, cEndPad		, NIL	} )
			EndIf

			lMsHelpAuto := .T.
			lMsErroAuto := .F.

			// 23/11/2017 - Atilio - Produto bloqueado. Desbloqueio antes de Integração
			If SB1->B1_MSBLQL == '1'
				RecLock("SB1",.F.)
				SB1->B1_MSBLQL	:= '2'
				SB1->( msUnlock() )
				lMsBlq			:= .T.
			Else
				lMsBlq			:= .F.
			EndIf

			//-- Chamada da rotina automatica
			msExecAuto({|x,y,z| Mata270(x,y,z)},aMata270,.F.,nOpc)

			// 23/11/2017 - Atilio - Produto bloqueado. Bloqueio depois de Integração
			If lMsBlq
				RecLock("SB1",.F.)
				SB1->B1_MSBLQL	:= '1'
				SB1->( msUnlock() )
			EndIf

			If lMsErroAuto

				cStatus	:= "2"
				//cNumDoc	:= ""

				cErro := ""
				cErro += FunName() +" - ExecAuto Mata270" + CRLF

				cErro += "Filial  - "+ cFilAnt + CRLF
				cErro += "Doc.    - "+ cNumDoc + CRLF
				cErro += "Produto - "+ cCodPro + CRLF
				cErro += "Data    - " + DTOC(dDatInv) + CRLF
				cErro += " " + CRLF

								
				If (!IsBlind()) // COM INTERFACE GRÁFICA
			         cErro += MostraErro()
			    Else // EM ESTADO DE JOB
			        cError := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO
			
			        ConOut(PadC("Automatic routine ended with error", 80))
			        ConOut("Error: "+ cError)
			        
			        cErro += PadC("Automatic routine ended with error", 80) + " Error: "+ cError
			    EndIf

			Else

				cStatus	:= "1"
				If nOpc == 5
					cErro := "[Exclusão confirmada] Produto"+IIF(Empty(cLotCtl),"","/Lote")+": "+AllTrim(cCodPro)+IIF(Empty(cLotCtl),"",""+cLotCtl)+"-Data: "+DTOC(dDatInv)
				Else
					cErro := "[Inclusão confirmada] Produto"+IIF(Empty(cLotCtl),"","/Lote")+": "+AllTrim(cCodPro)+IIF(Empty(cLotCtl),"",""+cLotCtl)+"-Data: "+DTOC(dDatInv)
				EndIf

			EndIf

		EndIf


	EndIf

	aRetorno	:= {cStatus,cErro}

	If	.F. // lSetEnv

		RpcClearEnv()

	EndIf

Return aRetorno