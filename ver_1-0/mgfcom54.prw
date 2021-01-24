#include "protheus.ch"
#Include 'topconn.ch'
#INCLUDE "rwmake.ch"
#INCLUDE "totvs.ch"

/*
=====================================================================================
Programa.:              MGFCOM54
Autor....:              Gresele
Data.....:              Nov/2017
Descricao / Objetivo:   Funcao chamada pelo ponto de entrada MTA125MNU
Doc. Origem:
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
User Function MGFCOM54()

	Processa({|| MGFCOM54Proc()},,"Importando arquivo .CSV...")

Return()


Static Function MGFCOM54Proc()
    Local cError    := ''
	Local aArea := {SA2->(GetArea()),SE4->(GetArea()),SB1->(GetArea()),GetArea()}
	Local cArq := ""
	Local aCampos := {}
	Local aDadosCab := {}
	Local aDados 	:= {}
	Local aCab := {}
	Local aItens := {}
	Local aItem := {}
	Local nCnt := 0
	Local nCnt1 := 0
	Local lContinua := .T.
	Local nColunas := 12 // 11 // total de colunas do arquivo .CSV
	Local lFirst := .T.
	Local aLinha := {}
	Local cDoc := ""
//	Local cProd := ""
	Local lSX8 := .F.
	Local cErro := ""
	Local lCnpj := .T.
	Local lProd := .T.
	Local cTes := ""
	Local nCompr :=GetAdvFVal("SY1","Y1_COD",xFilial("SY1")+RetCodUsr(),3,"")
	Local I          := 0   
	Local cFilOri	 := cFilAnt
	Local cMensagem  := " "
	Local lContinua  := .T.
	Local lalert     := .T.
	Local NFIL := ""
	Local nCompr 		:= GetAdvFVal("SY1","Y1_COD",xFilial("SY1")+RetCodUsr(),3,"")
	
	// Integração SA5 - Amarração Produto x Fornecedor
	Local cFilSA5	:= xFilial("SA5") // A5_FILIAL
	Local cForSA5	:= "" // A5_FORNECE
	Local cLojSA5	:= "" // A5_LOJA
	Local cNomSA5	:= "" // A5_NOMEFOR
	Local cPrdSA5	:= "" // A5_PRODUTO
	Local cDesSA5	:= "" // A5_NOMPROD
	Local cPrfSA5	:= "" // A5_CODPRF
	Local cTipSA5	:= "0" // A5_A5TIPATU
	Local _Ii		:=	0

	//Public cCodCompr     := nCompr
	Public cCompr     := nCompr

	Public grvcontr  := .T.
	Public cCodCompr := space(03)

	Private lMsErroAuto    := .F.

	// variaveis para manipular o txt de erros
	Private cFile := ""     
	Private nHdlError := 0
	Private lFirstErro := .T.
	Private lExecuta := .T.

	//     xfil :="      "
	//	DEFINE MSDIALOG oDLG2 TITLE "Global em branco ou digite a Filial" FROM 000, 000  TO 080, 395 COLORS 0, 16777215 PIXEL
	//	@ 008, 002 SAY  "Filial :"    SIZE 028, 009 OF oDLG2 			 COLORS 0, 16777215 PIXEL
	//	@ 006, 025 MSGET  xfil     SIZE 168, 010 OF oDLG2 PICTURE "@!" COLORS 0, 16777215 PIXEL
	//	oBtn := TButton():New( 021, 145 ,"Confirma"    , oDlg2,{|| oDLG2:End() }  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )
	//	ACTIVATE MSDIALOG oDLG2 CENTERED

	//IF bPassou
	//MSGALERT("ACHOU "+XFIL)
	//ENDIF   

	// colocar nova rotina para filiais
	//IF lContinua = .T.


	//cCodEmp := FWCodEmp()


	//msgbox("empresa"+cCodEmp)

	cCodCompr    := nCompr

	cArq := cGetFile("Todos os Arquivos|*.csv", OemToAnsi("Informe o diretório onde se encontra o arquivo."), 0, "SERVIDOR\", .F., GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE ,.T.)

	If !File(cArq)
		MsgStop("O arquivo " +cArq + " não foi selecionado. A importação será abortada!","ATENCAO")
		Return
	EndIf

	FT_FUSE(cArq)
	FT_FGOTOP()
	cLinha := FT_FREADLN()

	FT_FGOTOP()
	While !FT_FEOF()
		cLinha := FT_FREADLN()
		If lFirst
			aCampos := Separa(cLinha,";",.T.)
			lFirst := .F.
			If Len(aCampos) < nColunas
				lContinua := .F.
			Endif
		Else
			aAdd(aDados,Separa(cLinha,";",.T.))
			If Len(aDados[Len(aDados)]) < nColunas
				lContinua := .F.
			Endif
		EndIf
		FT_FSKIP()
	EndDo

	FT_FUSE()

	If !lContinua
		APMsgStop(	"Estrutura do arquivo .CSV inválido, cada linha deve ter 12 colunas, conforme abaixo:"+CRLF+CRLF+;
					"Codigo do Produto, %IPI, Valor Unitário, Quantidade, CNPJ Fornecedor, Condição de Pagamento,"+CRLF+;
					"Data Início, Data Fim, Tipo Frete, Transportadora, Tipo Operacao, Cod.Prod.Fornecedor")
		Return()
	Endif

	// Tenta criar o arquivo de Log
	If !COM54Han() 
		Aviso("Erro de criação do arquivo","Não foi possivel criar o arquivo de Log de Erro: "+Alltrim(cFile)+".",{"Fecha"})  
		Return()
	EndIf

	lFirst := .T.
	ProcRegua(Len(aDados))

	SB1->(dbSetOrder(1))
	SA5->(dbSetOrder(1))
	
    //AQUI ESCOLHE A EMPRESA
		// Criado no Matfilcalc para trazer todas empresas e filiais.
		IF NFIL = ""
			aFilsAtu := MFilCaX(.t.)   

			//IF INCLUI 
			FOR I = 1 TO LEN(aFilsAtu)
				IF !EMPTY(aFilsAtu[I][1])
					DbSelectArea("ZD5") 
					ZD5->(dbSetOrder(1))   
					ZD5->(dBGotop())
					IF !DbSeek(xFilial("ZD5")+cDoc+alltrim(aFilsAtu[I][2])+SC3->C3_FORNECE+SC3->C3_LOJA)

						RecLock("ZD5",.T.)
						ZD5->ZD5_CONTRA := cDoc   
						ZD5->ZD5_FORNEC := SA2->A2_COD   
						ZD5->ZD5_LOJA   := SA2->A2_LOJA
						ZD5->ZD5_ITEM   := "0001"                               
						ZD5->ZD5_FILENT := aFilsAtu[I][2]
						MsUnLock() 
						//IF EMPTY(SC3->C3_FILENT)
						//RecLock("SC3",.F.)
						//	 SC3->C3_FILENT := aFilsAtu[I][2]
						//MsUnLock()     
						//ENDIF
						NFIL :=aFilsAtu[I][2]
						grvcontr := .F.
					ENDIF

				ENDIF


			NEXT I            
		ENDIF

	
	For nCnt:=1 to Len(aDados)

		IncProc()

		lCnpj := .T.
		lProd := .T.
		cTes := ""
		aLinha := {}
		aItem := {}


		// Integração SA5 - Amarração Produto x Fornecedor
		cFilSA5	:= xFilial("SA5") // A5_FILIAL
		cForSA5	:= "" // A5_FORNECE
		cLojSA5	:= "" // A5_LOJA
		cNomSA5	:= "" // A5_NOMEFOR
		cPrdSA5	:= "" // A5_PRODUTO
		cDesSA5	:= "" // A5_NOMPROD
		cPrfSA5	:= "" // A5_CODPRF
		cTipSA5	:= "0" // A5_A5TIPATU

		For nCnt1 := 1 To Len(aCampos)
			IF TamSx3(Upper(aCampos[nCnt1]))[3] =='N'
				aAdd(aLinha,{Upper(aCampos[nCnt1]),VAL(aDados[nCnt,nCnt1]),Nil})
				If lFirst
					aAdd(aDadosCab,{Upper(aCampos[nCnt1]),VAL(aDados[nCnt,nCnt1]),Nil})
				Endif
			ELSEIF TamSx3(Upper(aCampos[nCnt1]))[3] =='D'
				aAdd(aLinha,{Upper(aCampos[nCnt1]),CTOD(aDados[nCnt,nCnt1]),Nil})
				If lFirst
					aAdd(aDadosCab,{Upper(aCampos[nCnt1]),CTOD(aDados[nCnt,nCnt1]),Nil})
				Endif
			ELSE
				aAdd(aLinha,{Upper(aCampos[nCnt1]),aDados[nCnt,nCnt1],Nil})
				If lFirst
					aAdd(aDadosCab,{Upper(aCampos[nCnt1]),aDados[nCnt,nCnt1],Nil})
				Endif
			ENDIF
		Next nCnt1

		If lFirst
			lFirst := .F.
			If !(Len(Alltrim(aDadosCab[5][2])) == 11 .or. Len(Alltrim(aDadosCab[5][2])) == 14)
				lContinua := .F.
				lCnpj := .F.
				cErro := "Linha: "+Alltrim(Str(nCnt+1))+" - Tamanho do campo CPF/CNPJ do Fornecedor inválido no arquivo. CPF/CNPJ: "+aDadosCab[5][2]
				COM54GrvLog(cErro)
			Endif
			If lCnpj
				SA2->(dbSetOrder(3))
				If SA2->(!dbSeek(xFilial("SA2")+aDadosCab[5][2]))
					lContinua := .F.
					cErro := "Linha: "+Alltrim(Str(nCnt+1))+" - Fornecedor não cadastrado. Fornecedor: "+aDadosCab[5][2]
					COM54GrvLog(cErro)
				Endif
			Endif	

			SE4->(dbSetOrder(1))
			If SE4->(!dbSeek(xFilial("SE4")+aDadosCab[6][2]))
				lContinua := .F.
				cErro := "Linha: "+Alltrim(Str(nCnt+1))+" - Condição de Pagamento não cadastrada. Condição: "+aDadosCab[6][2]
				COM54GrvLog(cErro)
			Endif

			// tipo de frete
			If !aDadosCab[9][2] $ "C/F/T/R/D/S" 
				lContinua := .F.
				cErro := "Linha: "+Alltrim(Str(nCnt+1))+" - Tipo de Frete inválido. Tipos válidos de Frete: 'C'(CIF)/'F'(FOB)/'T'(TERCEIROS)/'R'(REMETENTE)/'D'(DESTINATÁRIO)/'S'(SEM FRETE). Tipo de Frete: "+aDadosCab[9][2]
				COM54GrvLog(cErro)
			Endif

			// tipo de frete FOB sem informar a transportadora
			If aDadosCab[9][2] == "F" .and. Empty(aDadosCab[10][2])
				lContinua := .F.
				cErro := "Linha: "+Alltrim(Str(nCnt+1))+" - Tipo de Frete 'FOB' e transportadora não informada.
				COM54GrvLog(cErro)
			Endif

			// transportadora
			If !Empty(aDadosCab[10][2])
				SA4->(dbSetOrder(1))
				If SA4->(!dbSeek(xFilial("SA4")+aDadosCab[10][2]))
					lContinua := .F.
					cErro := "Linha: "+Alltrim(Str(nCnt+1))+" - Transportadora não cadastrada. Transportadora: "+aDadosCab[10][2]
					COM54GrvLog(cErro)
				Endif
			Endif	

			If lContinua	


				cDoc := GetSX8Num("SC3","C3_NUM")
				lSX8 := .T.

				DbSelectArea("SC3")
				DbSetOrder(1)

				if	DbSeek(xFilial("SC3")+cDoc,.F.) .or. Empty(cDoc)
					cDoc	:=	PROXNUM(cDoc)
				endif

				aadd(aCab,{"C3_NUM",cDoc,NIL})
				aadd(aCab,{"C3_FORNECE",SA2->A2_COD,NIL})
				aadd(aCab,{"C3_LOJA",SA2->A2_LOJA,NIL})
				aadd(aCab,{"C3_COND",aDadosCab[6][2],NIL})
				aadd(aCab,{"C3_CONTATO",SA2->A2_CONTATO,NIL})
				aadd(aCab,{"C3_EMISSAO",dDataBase})
				aadd(aCab,{"C3_MOEDA","1",NIL})
				aadd(aCab,{"C3_TPFRETE",aDadosCab[9][2],NIL})

				cForSA5	:= SA2->A2_COD // A5_FORNECE
				cLojSA5	:= SA2->A2_LOJA // A5_LOJA
				cNomSA5	:= SA2->A2_NOME // A5_NOMEFOR
	

			Endif

		Endif
		
		aLinha[1][2]	:= Stuff( Space( TamSX3("B1_COD")[1] ) , 1 , Len(aLinha[1][2]) , aLinha[1][2] ) 
		If SB1->(!dbSeek(xFilial("SB1")+aLinha[1][2]))
			lContinua := .F.
			lProd := .F.
			cErro := "Linha: "+Alltrim(Str(nCnt+1))+" - Produto não cadastrado. Produto: "+AllTrim(aLinha[1][2])
			COM54GrvLog(cErro)
		Else
			cPrdSA5	:= SB1->B1_COD		// A5_PRODUTO
			cDesSA5	:= SB1->B1_DESC	 	// A5_NOMPROD
			cPrfSA5	:= Stuff( Space( TamSX3("A5_CODPRF")[1] ) , 1 , Len(aLinha[12][2]) , aLinha[12][2] )	// A5_CODPRF
		Endif

		If Empty(cPrfSA5)
			lContinua := .F.
			cErro := "Linha: "+Alltrim(Str(nCnt+1))+" - Código do Produto para Fornecedor não informado. "
			COM54GrvLog(cErro)
		ElseIf SA5->(dbSeek(cFilSA5+cForSA5+cLojSA5+cPrdSA5))
			If cPrfSA5 <> SA5->A5_CODPRF .And. !Empty(SA5->A5_CODPRF) 
				lContinua := .F.
				cErro := "Linha: "+Alltrim(Str(nCnt+1))+" - Cod. Prod. Forn. "+AllTrim(cPrfSA5)+" diferente de cadastrado em Amarração Produto x Fornecedor: "+AllTrim(SA5->A5_CODPRF)
				COM54GrvLog(cErro)
			EndIf
		Endif

		If aLinha[7][2] > aLinha[8][2]
			lContinua := .F.
			cErro := "Linha: "+Alltrim(Str(nCnt+1))+" - Data Inicial maior que Data Final. Data inicial: "+aLinha[7][2]+", Data final: "+aLinha[8][2]
			COM54GrvLog(cErro)
		Endif

		// tipo de operacao
		If lCnpj .and. SA2->(Found()) .and. lProd .and. SB1->(Found())
			cTes := MaTesInt(1,aLinha[11][2],SA2->A2_COD,SA2->A2_LOJA,"F",SB1->B1_COD)  
			If Empty(cTes)
				lContinua := .F.
				cErro := "Linha: "+Alltrim(Str(nCnt+1))+" - Pelas regras cadastradas de 'TES inteligente', não foi encontrado 'TES' para os dados: Tipo de Operação: "+aLinha[11][2]+", Fornecedor: "+SA2->A2_COD+", Loja: "+SA2->A2_LOJA+", Produto: "+SB1->B1_COD
				COM54GrvLog(cErro)
			Endif	
		Endif	

		nIpip := 0
		nIpip := SB1->B1_IPI
		
		// trata IPI
		lAlert := .T.
/*		
		If aLinha[2][2] <> nIpip
			//lContinua := .F.
			lAlert := .F.
			cErro := "Alerta --> Linha: "+Alltrim(Str(nCnt+1))+"Produto "+AllTrim(aLinha[1][2])+" - IPI divergente do cadastro de produtos: "+trans(nIpip,"99.99")+" , planilha: "+trans(aLinha[2][2],"99.99")
			COM54GrvLog(cErro)
		Endif
*/
		If lContinua .and. lAlert
		
			//aadd(aItem,{"C3_FILIAL",xFilial("SC3"),Nil})
			aadd(aItem,{"C3_ITEM",StrZero(nCnt,Len(SC3->C3_ITEM)),Nil})
			aadd(aItem,{"C3_PRODUTO",aLinha[1][2],Nil})
			aadd(aItem,{"C3_QUANT",aLinha[4][2],Nil})
			aadd(aItem,{"C3_PRECO",aLinha[3][2],Nil})
			aadd(aItem,{"C3_DATPRI",aLinha[7][2],Nil})
			aadd(aItem,{"C3_DATPRF",aLinha[8][2],Nil})
			aadd(aItem,{"C3_TOTAL",aLinha[3][2]*aLinha[4][2],Nil})
//			If !Empty(aLinha[2][2])
				aadd(aItem,{"C3_IPI",aLinha[2][2],Nil})
//			Endif
			aadd(aItem,{"C3_LOCAL",RetFldProd(SB1->B1_COD,"B1_LOCPAD"),Nil})
			If !Empty(aDadosCab[10][2])
				aadd(aItem,{"C3_ZCODTRA",aDadosCab[10][2],Nil})
			Endif	
			aadd(aItem,{"C3_ZOPER",aLinha[11][2],Nil})
			aadd(aItem,{"C3_ZTES",cTes,Nil})
			aadd(aItem,{"C3_FILENT",NFIL,Nil})

			aAdd(aItens,aItem)
		Endif	
	Next nCnt

	// fechamento do arquivo de log
	FClose(nHdlError)

	//If !lContinua .and. !Empty(cErro)
	If !Empty(cErro)
		DEFINE MSDIALOG oDlg TITLE "Log de Erros na Importação" From 0,0 TO 340,550 OF oMainWnd PIXEL
		cShowErr := MemoRead(cFile)
		@ 5,5 GET oMemo Var cShowErr Of oDlg MEMO SIZE 267,145 PIXEL
		oMemo:brClicked := {||AllwaysTrue()}

		DEFINE SBUTTON FROM 153,230 TYPE 01 ACTION oDlg:End() ENABLE OF oDlg PIXEL
		DEFINE SBUTTON FROM 153,200 TYPE 15 ACTION (COM54TelaDet(),oDlg:End()) ENABLE ONSTOP "Visualizar Detalhes" OF oDlg PIXEL        

		ACTIVATE MSDIALOG oDlg CENTER
	Endif	



	If Len(aCab) > 0 .and. Len(aItens) > 0 .and. lContinua


		Begin Transaction

			MsExecAuto({|x,y,z| MATA125(x,y,z)},aCab,aItens,3)

			If lMsErroAuto
				DisarmTransaction()
				If (!IsBlind()) // COM INTERFACE GRÁFICA
				MostraErro()
			    Else // EM ESTADO DE JOB
			        cError := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO
			
			        ConOut(PadC("Automatic routine ended with error", 80))
			        ConOut("Error: "+ cError)
			    EndIf
			EndIF

		End Transaction

		If !lMsErroAuto

			ConfirmSX8()

			If !SA5->(dbSeek("      "+SA2->A2_COD+SA2->A2_LOJA+cPrdSA5))

					RecLock("SA5",.T.)
					//SA5->A5_FILIAL	:= xfilial("SA5")
						SA5->A5_FORNECE	:= SA2->A2_COD//cForSA5
						SA5->A5_LOJA	:= SA2->A2_LOJA//cLojSA5
						SA5->A5_NOMEFOR	:= SA2->A2_NOME//cNomSA5
						SA5->A5_PRODUTO	:= cPrdSA5
						SA5->A5_NOMPROD	:= cDesSA5
						SA5->A5_TIPATU	:= cTipSA5
						SA5->A5_CODPRF	:= cPrfSA5
					SA5->( msUnlock() )

			Else
				If SA5->A5_CODPRF <> cPrfSA5
					RecLock("SA5",.F.)
						SA5->A5_CODPRF	:= cPrfSA5
					SA5->( msUnlock() )
				EndIf
			
			EndIf

			APMsgInfo("Contrato de Parceria número: "+cDoc+" incluído com sucesso.")


			// Aqui para gravar a filial de entrega para todos os itens do contrato.
			//msgalert("achou"+_Cfil+" "+_Cnum)
			_cQry	:= " "
			_cQry	:= " UPDATE " + RetSqlName("SC3") + " SET C3_FILENT ='"+alltrim(nfil)+"' "
			_cQry	+= " WHERE C3_NUM = '"+alltrim(cDoc)+"'  AND D_E_L_E_T_<>'*' "
			TcSqlExec(_cQry)

			//UPDATE ajusta IPI - conforme está na planilha
			for _Ii:=	1	to len (aItens)
				_cQrySFx	:= "UPDATE " + RetSqlName("SC3") + " SET C3_IPI="+alltrim(str(aItens[_iI][8][2]))+" "
				_cQrySFx	+= "WHERE C3_NUM = '"+cDoc+"' AND SC3010.D_E_L_E_T_<>'*' 
				_cQrySFx	+= "AND  C3_ITEM ='"+aItens[_iI][1][2]+"' "
				TcSqlExec(_cQrySFx) 
			next
			//ENDIF

			// aqui colocar update para o comprador.
			_cQrySFN	:=" "
			_cQrySFN	:= "UPDATE " + RetSqlName("SC3") + " SET C3_ZCODCOM='"+nCompr+"' "
			_cQrySFN	+= "WHERE C3_NUM = '"+cDoc+"' AND SC3010.D_E_L_E_T_<>'*' "
			TcSqlExec(_cQrySFN)

		Else
			RollBackSX8()
		Endif
	Else
		If lSX8
			RollBackSX8()
		Endif			
	Endif

	aEval(aArea,{|x| RestArea(x)})

Return()


// rotina de criacao do arquivo de log de erros
Static Function COM54Han()

	Local lRet := .T.
	Local cDir := "c:\temp"

	// monta o nome do arquivo
	cFile := "Erros_Importacao_Contrato_Parceria"
	cFile += "_"
	cFile += Str(Year(dDataBase),4)
	cFile += "_"
	cFile += StrZero(Month(dDataBase),2)
	cFile += "_"
	cFile += StrZero(Day(dDataBase),2)
	cFile += ".txt"
	cFile := cDir+"\"+Upper(cFile)

	MakeDir(cDir)
	If File(cFile)
		fErase(cFile)
	Endif	

	// tenta gerar o arquivo
	nHdlError := FCreate(cFile,0)

	// verifica o sucesso da operacao
	If nHdlError == -1
		lRet := .F.
	EndIf

Return(lRet)


// rotina de gravacao de registros de erro no arquivo de log
Static Function COM54GrvLog(cLinha)

	Local cAlias := Alias()
	Local cCR := Chr(13)+Chr(10)
	Local cReg := ""

	// grava cabecalho no arquivo .txt
	If lFirstErro
		lFirstErro := .F.

		cReg := "Registros de Inconsistências no Processamento da Importação do Contrato de Parceria."
		cReg += cCR

		FWrite(nHdlError,cReg)

		// insere uma linha em branco
		cReg := " "
		cReg += cCR
		FWrite(nHdlError,cReg)
	EndIf

	cReg := cLinha
	cReg += cCR

	FWrite(nHdlError,cReg)

	dbSelectArea(cAlias)

Return()


Static Function COM54TelaDet()

	//Local cTempu      := GetTempPath() 							//pega caminho do temp do client

	//verifica se existe o arquivo na pasta temporaria e apaga
	//If File(cTempu+cFile)
	//  	fErase(cTempu+cFile)
	//EndIf                 

	//IF AvCpyFile(cFile,cTempu+cFile,.F.)
	shellExecute( "Open", "C:\Windows\System32\notepad.exe", cFile, "c:\temp\" /*cTempu*/, 1) 
	//Else
	//	Aviso("Erro na abertura do Arquivo","Problema para realizar a abertura do arquivo "+cFile+" para "+cTempu+cFile,{"Fecha"})  	
	//Endif

Return()



//Incluido para suprir a necessidade de ter todas as empresas e filiais
//Tarcisio galeano - 09/01/2018
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³ MatFilCalc (Original MA330FCalc)                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Autor     ³ Microsiga Software S/A                   ³ Data ³ 22/01/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³ Funcao para selecao das filiais para calculo por empresa   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³ ExpL1 = Indica se apresenta tela para selecao              ³±±
±±³           ³ ExpA2 = Lista com as filiais a serem consideradas (Batch)  ³±±
±±³ÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³±±
±±³Retorno    ³ Array: aFilsCalc[3][n]                                     ³±±
±±³           ³ aFilsCalc[1][n]:           - Logico                        ³±±
±±³           ³ aFilsCalc[2][n]: Filial    - Caracter                      ³±±
±±³           ³ aFilsCalc[3][n]: Descricao - Caracter                      ³±±
±±³           ³ aFilsCalc[4][n]: CNPJ      - Caracter                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static Function MFilCaX(lMos,aListaX)
	Local aFilsC:={}
	Local aAreaSM0:=SM0->(GetArea())
	// Variaveis utilizadas na selecao de categorias
	Local oChkQual,lQual,oQual,cVarQ,oDlg
	// Carrega bitmaps
	Local oOk       := LoadBitmap( GetResources(), "LBOK")
	Local oNo       := LoadBitmap( GetResources(), "LBNO")
	// Variaveis utilizadas para lista de filiais
	Local nx        := 0
	Local nAchou    := 0

	Default lMos :=.F.
	Default aListaX:={{.T., cFilAnt}}

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega filiais da empresa corrente                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SM0")
	dbSeek(cEmpAnt)
	Do While ! Eof() .And. SM0->M0_CODIGO == cEmpAnt
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ aEmpresas - Contem as filiais que sao permitidas para o acesso |
		//| do usuario corrente.                                           |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//nPos := Ascan(aEmprecsas,{|x| AllTrim(x)==Alltrim(SM0->M0_CODIGO+SM0->M0_CODFIL)})
		//If nPos > 0
		//IF SM0->M0_CODFIL <> '010001'
		Aadd(aFilsC,{.F.,SM0->M0_CODFIL,SM0->M0_FILIAL,SM0->M0_CGC})
		//msgalert("filial "+SM0->M0_CODFIL+" "+SM0->M0_FILIAL+" "+SM0->M0_CGC)
		//ENDIF
		//EndIf	                             

		dbSkip()
	EndDo
	RestArea(aAreaSM0)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta tela para selecao de filiais                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lMos
		DEFINE MSDIALOG oDlg TITLE OemToAnsi("Contrato x Filial") STYLE DS_MODALFRAME From 145,0 To 445,628 OF oMainWnd PIXEL
		oDlg:lEscClose := .F.
		@ 05,15 TO 125,300 LABEL OemToAnsi("Seleção") OF oDlg  PIXEL
		@ 15,20 CHECKBOX oChkQual VAR lQual PROMPT OemToAnsi("Filial") SIZE 50, 10 OF oDlg PIXEL ON CLICK (AEval(aFilsC, {|z| z[1] := If(z[1]==.T.,.F.,.T.)}), oQual:Refresh(.F.))
		@ 30,20 LISTBOX oQual VAR cVarQ Fields HEADER "",OemToAnsi("Filial"),OemToAnsi("Razao social") SIZE 273,090 ON DBLCLICK (aFilsC:=MtFCl(oQual:nAt,aFilsC),oQual:Refresh()) NoScroll OF oDlg PIXEL
		oQual:SetArray(aFilsC)
		oQual:bLine := { || {If(aFilsC[oQual:nAt,1],oOk,oNo),aFilsC[oQual:nAt,2]}}
		DEFINE SBUTTON FROM 134,200 TYPE 1 ACTION If(MtFCalOk(aFilsC,.T.,.T.),oDlg:End(),) ENABLE OF oDlg
		DEFINE SBUTTON FROM 134,240 TYPE 2 ACTION If(MtFCalOk(aFilsC,.F.,.T.),oDlg:End(),) ENABLE OF oDlg
		//DEFINE SBUTTON FROM 134,280 TYPE 15 ACTION If(MtFCalOk(aFilsC,.T.,U_MGFCOM84()),oDlg:End(),) ENABLE OF oDlg

		ACTIVATE MSDIALOG oDlg CENTER
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Valida lista de filiais passada como parametro               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Else
		// Checa parametros enviados
		For nx:=1 to Len(aListaX)
			nAchou:=ASCAN(aFilsC,{|x| x[2] == aListaX[nx,2]})
			If nAchou > 0
				aFilsC[nAchou,1]:=.T.
			EndIf
		Next nx
		// Valida e assume somente filial corrente em caso de problema
		If !MtFCalOk(aFilsC,.T.,.F.)                      

			For nx:=1 to Len(aFilsC)
				// Adiciona filial corrente
				aFilsC[nx,1]:=(aFilsC[nx,2]==cFilAnt)
			Next nx
		EndIf
	EndIf
RETURN aFilsC

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³ MtFCalOk (Original MA330FOk)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Autor     ³ Microsiga Software S/A                   ³ Data ³ 22/01/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³ Checa marcacao das filiais para calculo por empresa        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³ ExpA1 = Array com a selecao das filiais                    ³±±
±±³           ³ ExpL1 = Valida array de filiais (.t. se ok e .f. se cancel)³±±
±±³           ³ ExpL2 = Mostra tela de aviso no caso de inconsistencia     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MtFCalOk(aFilsC,lValidaArray,lMos)
	Local lRet:=.F.
	Local nx:=0

	Default lMos := .T.

	If !lValidaArray
		aFilsC := {}
		lRet := .T.
	Else
		// Checa marcacoes efetuadas
		For nx:=1 To Len(aFilsC)
			If aFilsC[nx,1]
				lRet:=.T.
			EndIf
		Next nx
		// Checa se existe alguma filial marcada na confirmacao
		//If !lRet
		//	If lMostraTela
		//		Aviso(OemToAnsi("teste"),OemToAnsi("teste"),{"Ok"})
		//	EndIf
		//EndIf
	EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³ MtFClTroca(Original CA330Troca)                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Autor     ³ Microsiga Software S/A                   ³ Data ³ 12/01/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³ Troca marcador entre x e branco                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³ ExpN1 = Linha onde o click do mouse ocorreu                ³±±
±±³           ³ ExpA2 = Array com as opcoes para selecao                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  Uso      ³ Protheus 8.11                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MtFCl(nIt,aArray)
	aArray[nIt,1] := !aArray[nIt,1]
Return aArray

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FullRange³ Autor ³ Felipe Nunes de Toledo³ Data ³ 30/01/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Converte os parametros do tipo range, para um range cheio, ³±±
±±³          ³ caso o conteudo do parametro esteja vazio.                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³FullRange(cPerg)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cPerg = Nome do Grupo de Perguntas                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static Function FullRange(cPerg)
	Local aArea      := { SX1->(GetArea()), GetArea() }
	Local aTamSX3    := {}
	Local cMvPar     := ''
	Local nTamSX1Cpo := Len(SX1->X1_GRUPO)

	cPerg := Upper(PadR(cPerg,nTamSX1Cpo))

	SX1->( dbSetOrder(1) )
	SX1->( MsSeek(cPerg) )
	Do While SX1->( !Eof() .And. Trim(X1_GRUPO) == Trim(cPerg) )
		If Upper(SX1->X1_GSC) == 'R'
			cMvPar := 'MV_PAR'+SX1->X1_ORDEM
			If Empty(&(cMvPar))
				aTamSX3 := TamSx3(SX1->X1_CNT01)
				If Upper(aTamSX3[3]) == 'C'
					&(cMvPar) := Space(aTamSX3[1])+'-'+Replicate('z',aTamSX3[1])
				ElseIf Upper(aTamSX3[3]) == 'D'
					&(cMvPar) := '01/01/80-31/12/49'
				ElseIf Upper(aTamSX3[3]) == 'N'
					&(cMvPar) := Replicate('0',aTamSX3[1])+'-'+Replicate('9',aTamSX3[1])
				EndIf
			EndIf
		EndIf
		SX1->( dbSkip() )
	EndDo

	RestArea( aArea[1] )
	RestArea( aArea[2] )
Return Nil

STATIC FUNCTION PROXNUM(_cNum)

	Local cNextAlias 	:= GetNextAlias()

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif

	BeginSql Alias cNextAlias

		SELECT MAX(C3_NUM) as MAX
		FROM %Table:SC3% SC3
		WHERE SC3.C3_FILIAL = %xFilial:SC3% AND
		SC3.%NotDel% t
		

	EndSQL

	(cNextAlias)->(dbGoTop())

	if (cNextAlias)->(!EOF())
		_cNum	:=	soma1((cNextAlias)->MAX)
	Else
		_cNum	:=	StrZero(1,Len(SC3->C3_NUM))
	endif

	(cNextAlias)->(DbClosearea())
return _cNum