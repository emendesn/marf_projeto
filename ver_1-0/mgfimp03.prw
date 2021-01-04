#include "protheus.ch"
#include "rwmake.ch"
#include "TOTVS.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "DBSTRUCT.CH"
#INCLUDE "MSGRAPHI.CH"

/*
=====================================================================================
Programa.:              MGFIMP03
Autor....:              Atilio Amarilla
Data.....:              11/04/2018
Descricao / Objetivo:   Validação de Estrutura/informações do arquivo de carga de ativos
Doc. Origem:            Contrato - GAP MGFIMP01
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Relacionado á Importação de Cadastros - Atifo Fixo
=====================================================================================
*/

User Function MGFIMP03()


	Local aSays		:={}
	Local aButtons	:={}
	Local nOpca		:= 0


	// Inicializa o log de processamento
	// ProcLogIni( aButtons ) 
	AADD(aSays, 'Este programa tem como objetivo validar estrutura/informações de arquivos de ativos.') 
	//AADD(aSays, 'Estrutura deve conter os campos:') 
	//AADD(aSays, '	D3_FILIAL / D3_COD / D3_QUANT / D3_LOCAL / D3_CUSTO1 / D3_LOCALIZ') 
	AADD(aSays, 'Será feita validação das informações de todos os campos e gerado log com inconsistências')

	//AADD(aButtons, { 5,.T.,{|| Pergunte('XXX190',.T. ) } } ) 

	//AADD(aButtons, { 1,.T.,{|| nOpca:= 1, If( ProcOk(), FechaBatch(), nOpca:=0 ) }} ) 
	AADD(aButtons, { 1,.T.,{|| nOpca:= 1 , FechaBatch()  }} )
	AADD(aButtons, { 2,.T.,{|| FechaBatch() }} )  

	FormBatch( 'Validação de Carga - SN1/SN3', aSays, aButtons,, 220, 560 )

	If nOpca == 1                   
		// Atualiza o log de processamento  com o início do processamento 
		//ProcLogAtu('INICIO')
		//...Processamento da rotina....
		//.. Em Caso de Erros atualiza o log de erros do processamento
		// Atualiza o log de processamento com o erro 
		//ProcLogAtu('ERRO','Erro no processamento','O campo xxx nao está disponível na tabela yyy, ')
		// Atualiza o log de processamento caso o processamento seja cancelado
		//ProcLogAtu('CANCEL','Cancalado pelo usuario') 
		// Atualiza o log de processamento com o fim do processamento
		//Proc	LogAtu('FIM')

		MsgRun("Validação de arquivo SN1/SN3. Aguarde...",,{|| MGFIMP0301() })

	EndIf

Return

Static Function MGFIMP0301()

	Local cArqCab	:= cArqDet		:= ""
	Local cPatLoc	:= ""

	Local aColSN1	:= {"Tabela","Linha","Ocorrência"}
	Local aIteSN1
	Local cLinha, nLinha, nCampos
	Local cFilArq	:= " "
	Local aAreaSM0	:= SM0->( GetArea() )
	Local nPosFil, nPosCod, nPosQtd, nPosLoc, nPosCus, nPosEnd
	Local nTamQtd	:= nDecQtd	:= nTamCus	:= nDecCus	:= nMaxQtd	:= nMaxCus	:= nTamSX3	:= 0
	Local nI		:= nX	:= 0
	Local cTipo		:= "N1"
	Local cCampo	:= ""
	Local aChaveN3A	:= {}
	Local aChaveN3B	:= {}
	Local aChaveN1A	:= {}
	Local aChaveN1B	:= {}

	Local cNome := ""

	Local cArqExc := ""//cNome+".XML"

	Private cPatSrv	:= GetMv("MGF_IMP03A",,"\MGF\IMP\VLDSN1\")				// Path de gravação de Arquivos Server

	// Abertura de Arquivos
	dbSelectArea("SN1")	// Descricao Generica do Produto 
	dbSetOrder(1)		// B1_FILIAL+B1_COD

	dbSelectArea("SN3")	// Locais de Estoque
	dbSetOrder(1)		// NNR_FILIAL+NNR_CODIGO

	dbSelectArea("CT1")	// Plano de COntas
	dbSetOrder(1)		// BE_FILIAL+BE_LOCAL+BE_LOCALIZ+BE_ESTFIS

	dbSelectArea("CTT")	// Centro de Custo
	dbSetOrder(1)		// BE_FILIAL+BE_LOCAL+BE_LOCALIZ+BE_ESTFIS

	dbSelectArea("CTD")	// Item Contábil
	dbSetOrder(1)		// BE_FILIAL+BE_LOCAL+BE_LOCALIZ+BE_ESTFIS

	dbSelectArea("SA2")	// Item Contábil
	dbSetOrder(1)		// BE_FILIAL+BE_LOCAL+BE_LOCALIZ+BE_ESTFIS

	MsgAlert("Essa opção precisa de 2 arquivos, o primeiro é o arquivo de CABEÇALHO!","ATENÇÃO")

	cArqCab := cGetFile("Todos os Arquivos|*.csv", OemToAnsi("Informe o diretório onde se encontra o arquivo."), 0, "SERVIDOR\", .F., GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE ,.T.)

	If !File(cArqCab)
		MsgStop("O arquivo " +cArqCab + " não foi selecionado. A validação será abortada!","ATENÇÃO")
		Return
	EndIf
	
	MsgAlert("Agora é o arquivo de DETALHE!","ATENÇÃO")

	cArqDet := cGetFile("Todos os Arquivos|*.csv", OemToAnsi("Informe o diretório onde se encontra o arquivo."), 0, "SERVIDOR\", .F., GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE ,.T.)
	
	If !File(cArqDet)
		MsgStop("O arquivo " +cArqDet + " não foi selecionado. A validação será abortada!","ATENÇÃO")
		Return
	Else
		cPatLoc := Subs(cArqCab,1, Rat("\",cArqCab) )
		cNome	:= UPPER( Subs(cArqCab,Rat("\",cArqCab) ) )
		cNome	:= StrTran(cNome,".CSV")+"-"+Subs(DTOS(Date()),3,6)+StrTran(Time(),":")
		cArqExc := cNome+".XML"
	EndIf

	aIteSN1	:= {}

	aObrSN1	:= {}
	aObrSN3	:= {}
	
	aObrigat:= {}

	dbSelectArea("SX3")
	DbSetOrder(1)
	dbSeek("SN1")
	While !eof() .And. SX3->X3_ARQUIVO == "SN1"
		If AllTrim(SX3->X3_CAMPO) $ "N1_FILIAL/N1_AQUISIC/N1_GRUPO/N1_PATRIM/N1_AQUISIC/N1_CHAPA/" .Or. ;
			(X3Obrigat(SX3->X3_CAMPO) .And. Empty(SX3->X3_RELACAO))
			aAdd(aObrigat,AllTrim(SX3->X3_CAMPO))
		EndIf
		SX3->(dbSkip())
	EndDo

	FT_FUSE(cArqCab)
	FT_FGOTOP()
	cLinha	:= FT_FREADLN()

	FT_FUSE()
	
	cLinha	:= ";"+cLinha+";"
	nLinha	:= 1

	aCampos	:= Separa(cLinha,";")
	For nI := 1 To Len(aCampos)
		If ( ( nI == 1 .Or. nI == Len(aCampos) ) .And. Empty(aCampos[nI]) )
			aDel( aCampos , nI )
			aSize( aCampos , Len(aCampos)-1 )
		EndIf
	Next nI

	For nI := 1 To Len(aObrigat)
		If !(";"+aObrigat[nI]+";")$cLinha
			aAdd( aIteSN1 , { "SN1" , StrZero(nLinha,7),'Campo '+ aObrigat[nI] +' não existe no arquivo de carga' } )
		Else
			aAdd( aObrSN1 , aScan( aCampos,{|x| alltrim(x) == aObrigat[nI] }) )
		EndIf
	Next nI

	cLinha	:= ""

	dbSelectArea("SX3")
	DbSetOrder(2)

	cTipo	:= "N1"
	For nI := 1 To Len(aCampos)
		cCampo	:= Stuff( Space(Len(SX3->X3_CAMPO)) , 1 , Len(aCampos[nI]) , aCampos[nI] )
		IF cTipo <> SUBSTR( cCampo , 1 , 2 )  
			aAdd( aIteSN1 , { "SN1" , StrZero(nLinha,7),'Campo '+ AllTrim(cCampo) +' não pertence à tabela SD3' } )
		ElseIf !SX3->(dbSeek( cCampo ))
			aAdd( aIteSN1 , { "SN1" , StrZero(nLinha,7),'Campo '+ AllTrim(cCampo) +' não encontrado no dicionário' } )
		ElseIf ( SX3->X3_CONTEXT == "V" )
			aAdd( aIteSN1 , { "SN1" , StrZero(nLinha,7),'Campo '+ AllTrim(cCampo) +' marcado na tabela como virtual (X3_CONTEXT)' } )
		EndIf
	Next nI

	
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek("SN3")
	aObrigat	:= {}
	While !eof() .And. SX3->X3_ARQUIVO == "SN3"
		If AllTrim(SX3->X3_CAMPO) $ "N3_FILIAL/N3_CCONTAB/N3_CBASE/N3_ITEM/N3_TPSALDO/N3_TPDEPR/N3_CCONTAB/N3_HISTOR/N3_AQUISIC/N3_SEQ/N3_CUSTBEM/N3_SUBCCON/" .Or. ;
			(X3Obrigat(SX3->X3_CAMPO) .And. Empty(SX3->X3_RELACAO)) 
			aAdd(aObrigat,AllTrim(SX3->X3_CAMPO))
			
		EndIf
		SX3->(dbSkip())
	EndDo

	FT_FUSE(cArqDet)
	FT_FGOTOP()
	cLinha	:= FT_FREADLN()
	cLinha	:= ";"+cLinha+";"
	nLinha	:= 1

	aCampos	:= Separa(cLinha,";")

	For nI := 1 To Len(aCampos)
		If ( ( nI == 1 .Or. nI == Len(aCampos) ) .And. Empty(aCampos[nI]) )
			aDel( aCampos , nI )
			aSize( aCampos , Len(aCampos)-1 )
		EndIf
	Next nI

	For nI := 1 To Len(aObrigat)
		If !(";"+aObrigat[nI]+";")$cLinha
			aAdd( aIteSN1 , { "SN1" , StrZero(nLinha,7),'Campo '+ aObrigat[nI] +' não existe no arquivo de carga' } )
		Else
			aAdd( aObrSN3 , aScan( aCampos,{|x| alltrim(x) == aObrigat[nI] }) )
		EndIf
	Next nI

	cLinha	:= ""

	dbSelectArea("SX3")
	DbSetOrder(2)

	cTipo	:= "N3"
	For nI := 1 To Len(aCampos)
		cCampo	:= Stuff( Space(Len(SX3->X3_CAMPO)) , 1 , Len(aCampos[nI]) , aCampos[nI] )
		IF cTipo <> SUBSTR( cCampo , 1 , 2 )  
			aAdd( aIteSN1 , { "SN3" , StrZero(nLinha,7),'Campo '+ AllTrim(cCampo) +' não pertence à tabela SD3' } )
		ElseIf !SX3->(dbSeek( cCampo ))
			aAdd( aIteSN1 , { "SN3" , StrZero(nLinha,7),'Campo '+ AllTrim(cCampo) +' não encontrado no dicionário' } )
		ElseIf ( SX3->X3_CONTEXT == "V" )
			aAdd( aIteSN1 , { "SN3" , StrZero(nLinha,7),'Campo '+ AllTrim(cCampo) +' marcado na tabela como virtual (X3_CONTEXT)' } )
		EndIf
	Next nI

	If Len( aIteSN1 ) > 0
		FT_FUSE()
		MsgStop("Divergência na Estrutura. Verifique Log ","Validação Carga SN1/SN3")
		cMsg	:= U_zGeraExc(aColSN1,aIteSN1,cArqExc,cPatSrv,cPatLoc,"Validação Carga SN1/SN3 - Divergência na Estrutura ")
		Return
	EndIf

	nPosFil	:= aScan(aCampos,{|x| alltrim(x) == "N3_FILIAL"})
	nPosFOr	:= aScan(aCampos,{|x| alltrim(x) == "N3_FILORIG"})
	nPosCod	:= aScan(aCampos,{|x| alltrim(x) == "N3_CBASE"})
	nTamCod	:= TamSX3("N3_CBASE")[1]
	nPosIte	:= aScan(aCampos,{|x| alltrim(x) == "N3_ITEM"})
	nTamIte	:= TamSX3("N3_ITEM")[1]
	nPosTip	:= aScan(aCampos,{|x| alltrim(x) == "N3_TIPO"})
	nPosTpD	:= aScan(aCampos,{|x| alltrim(x) == "N3_TPDEPR"})
	nPosCta	:= aScan(aCampos,{|x| alltrim(x) == "N3_CCONTAB"})
	nPosCDD	:= aScan(aCampos,{|x| alltrim(x) == "N3_CDEPREC"})
	nPosCDA	:= aScan(aCampos,{|x| alltrim(x) == "N3_CCDEPR"})
	nPosHis	:= aScan(aCampos,{|x| alltrim(x) == "N3_HISTOR"})
	nTamHis	:= TamSX3("N3_HISTOR")[1]
	nPosCus	:= aScan(aCampos,{|x| alltrim(x) == "N3_CUSTBEM"})
	nPosItC	:= aScan(aCampos,{|x| alltrim(x) == "N3_SUBCCON"})
	nPosDtA	:= aScan(aCampos,{|x| alltrim(x) == "N3_AQUISIC"})
	nPosTps	:= aScan(aCampos,{|x| alltrim(x) == "N3_TPSALDO"})
	nPosVO1	:= aScan(aCampos,{|x| alltrim(x) == "N3_VORIG1"})
	nPosVO3	:= aScan(aCampos,{|x| alltrim(x) == "N3_VORIG3"})
	nPosVA1	:= aScan(aCampos,{|x| alltrim(x) == "N3_VRDACM1"})
	nPosVA3	:= aScan(aCampos,{|x| alltrim(x) == "N3_VRDACM3"})
	nPosSeq	:= aScan(aCampos,{|x| alltrim(x) == "N3_SEQ"})
	nTamSeq	:= TamSX3("N3_SEQ")[1]

		
	FT_FSKIP()

	While !FT_FEOF()

		nLinha++

		If Empty( cLinha )
			cLinha := FT_FREADLN()
		EndIf

		aDados	:= Separa(cLinha,";")
		cLinha	:= ""
		
		cFilLin	:= Stuff( Space( TamSX3(Upper(aCampos[nPosFil]))[1] ) , 1 , Len(aDados[nPosFil]) , aDados[nPosFil] )
		

		If Empty( cFilArq )
			cFilArq	:= cFilLin
			If !SM0->( dbSeek(cEmpAnt+cFilArq) )
				aAdd( aIteSN1 , { "SN3" , StrZero(nLinha,7),'Filial do arquivo não existe: ' + cFilArq } )
				Exit
			EndIf
		EndIf

		If Len(aDados) <> Len(aCampos)
			aAdd( aIteSN1 , { "SN3" , StrZero(nLinha,7),'Estrutura divergente do cabeçalho' } )
		Else

			For nI := 1 to Len( aObrSN3 )
				If Empty(aDados[aObrSN3[nI]])
					aAdd( aIteSN1 , { "SN3" , StrZero(nLinha,7),'Campo obrigatório não informado: ' + aCampos[aObrSN3[nI]] } )
				EndIf
			Next nI
			
			cFilLin	:= Stuff( Space( TamSX3(Upper(aCampos[nPosFil]))[1] ) , 1 , Len(aDados[nPosFil]) , aDados[nPosFil] )
			cFOrLin	:= Stuff( Space( TamSX3(Upper(aCampos[nPosFOr]))[1] ) , 1 , Len(aDados[nPosFOr]) , aDados[nPosFOr] )
			cCodLin	:= Stuff( Space( TamSX3(Upper(aCampos[nPosCod]))[1] ) , 1 , Len(aDados[nPosCod]) , aDados[nPosCod] )
			cIteLin	:= Stuff( Space( TamSX3(Upper(aCampos[nPosIte]))[1] ) , 1 , Len(aDados[nPosIte]) , aDados[nPosIte] )
			cTipLin	:= Stuff( Space( TamSX3(Upper(aCampos[nPosTip]))[1] ) , 1 , Len(aDados[nPosTip]) , aDados[nPosTip] )
			cTpDLin	:= Stuff( Space( TamSX3(Upper(aCampos[nPosTpD]))[1] ) , 1 , Len(aDados[nPosTpD]) , aDados[nPosTpD] )
			cCtaLin	:= Stuff( Space( TamSX3(Upper(aCampos[nPosCta]))[1] ) , 1 , Len(aDados[nPosCta]) , aDados[nPosCta] )
			cCDDLin	:= Stuff( Space( TamSX3(Upper(aCampos[nPosCDD]))[1] ) , 1 , Len(aDados[nPosCDD]) , aDados[nPosCDD] )
			cCDALin	:= Stuff( Space( TamSX3(Upper(aCampos[nPosCDA]))[1] ) , 1 , Len(aDados[nPosCDA]) , aDados[nPosCDA] )
			cHisLin	:= Stuff( Space( TamSX3(Upper(aCampos[nPosHis]))[1] ) , 1 , Len(aDados[nPosHis]) , aDados[nPosHis] )
			
			cCusLin	:= Stuff( Space( TamSX3(Upper(aCampos[nPosCus]))[1] ) , 1 , Len(aDados[nPosCus]) , aDados[nPosCus] )
			cItCLin	:= Stuff( Space( TamSX3(Upper(aCampos[nPosItC]))[1] ) , 1 , Len(aDados[nPosItC]) , aDados[nPosItC] )
			cTpSLin	:= Stuff( Space( TamSX3(Upper(aCampos[nPosTpS]))[1] ) , 1 , Len(aDados[nPosTpS]) , aDados[nPosTpS] )
			
			cSeqLin	:= Stuff( Space( TamSX3(Upper(aCampos[nPosSeq]))[1] ) , 1 , Len(aDados[nPosSeq]) , aDados[nPosSeq] )

			nVO1Lin	:= aDados[nPosVO1]
			If At(",",nVO1Lin)
				nVO1Lin := StrTran(nVO1Lin,".")
			EndIf
			nVO1Lin := StrTran(nVO1Lin,",",".")
			nVO1Lin := Val(nVO1Lin)

			nVO3Lin	:= aDados[nPosVO3]
			If At(",",nVO3Lin)
				nVO3Lin := StrTran(nVO3Lin,".")
			EndIf
			nVO3Lin := StrTran(nVO3Lin,",",".")
			nVO3Lin := Val(nVO3Lin)

			nVA1Lin	:= aDados[nPosVA1]
			If At(",",nVA1Lin)
				nVA1Lin := StrTran(nVA1Lin,".")
			EndIf
			nVA1Lin := StrTran(nVA1Lin,",",".")
			nVA1Lin := Val(nVA1Lin)

			nVA3Lin	:= aDados[nPosVA3]
			If At(",",nVA3Lin)
				nVA3Lin := StrTran(nVA3Lin,".")
			EndIf
			nVA3Lin := StrTran(nVA3Lin,",",".")
			nVA3Lin := Val(nVA3Lin)

			If !SM0->( dbSeek(cEmpAnt+cFilLin) )
				aAdd( aIteSN1 , { "SN3" , StrZero(nLinha,7),'Filial não existe: ' + cFilLin } )
			Else
				If cFilArq	<> cFilLin
					aAdd( aIteSN1 , { "SN3" , StrZero(nLinha,7),'Filial '+cFilLin+' diferente da filial do arquivo: '+cFilArq } )
				EndIf	

				If cFOrLin	<> cFilLin
					aAdd( aIteSN1 , { "SN3" , StrZero(nLinha,7),'Filial Origem '+cFOrLin+' diferente da filial N1_FILIAL: '+cFilLin } )
					If !SM0->( dbSeek(cEmpAnt+cFilLin) )
						aAdd( aIteSN1 , { "SN3" , StrZero(nLinha,7),'Filial Origem não existe: ' + cFOrLin } )				
					EndIf
				EndIf	

				lCodLin	:= .T.

				// N3_CBASE 
				// - Tamanho
				If Len(cCodLin) > nTamCod 
					aAdd( aIteSN1 , { "SN3" , StrZero(nLinha,7),'Código '+AllTrim(cCodLin)+' maior que tamanho do campo N3_CBASE ('+AllTrim(Str(nTamCod))+')' } )
				EndIf

				// N3_ITEM 
				// - Tamanho
				If Len(cIteLin) > nTamIte 
					aAdd( aIteSN1 , { "SN3" , StrZero(nLinha,7),'Item '+AllTrim(cIteLin)+' maior que tamanho do campo N3_ITEM ('+AllTrim(Str(nTamIte))+')' } )
				EndIf

				// N3_TIPO 
				// - Código Válido
				If Empty(Tabela("G1",cTipLin,.F.)) 
					aAdd( aIteSN1 , { "SN3" , StrZero(nLinha,7),'Tipo inválido: '+AllTrim(cTipLin) } )
				EndIf

				// N3_TPSALDO 
				// - Código Válido
				If !cTpSLin $ "12349" 
					aAdd( aIteSN1 , { "SN3" , StrZero(nLinha,7),'Tipo Saldo inválido: '+AllTrim(cTpSLin) } )
				EndIf

				// N3_TPDEPR 
				// - Código Válido
				If !cTpDLin $ "12456789A" 
					aAdd( aIteSN1 , { "SN3" , StrZero(nLinha,7),'Tipo Deprec.  inválido: '+AllTrim(cTpDLin) } )
				EndIf

				// N3_CCONTAB 
				// - Código Válido
				// - Conta Ativa CT1_BLOQ <> '1'
				If ! CT1->( dbSeek(xFilial("CT1")+cCtaLin) ) 
					aAdd( aIteSN1 , { "SN3" , StrZero(nLinha,7),'Conta N3_CCONTAB inválida: '+AllTrim(cCtaLin) } )
				ElseIf CT1->CT1_BLOQ == '1'
					aAdd( aIteSN1 , { "SN3" , StrZero(nLinha,7),'Conta N3_CCONTAB bloqueada: '+AllTrim(cCtaLin) } )
				EndIf

				// N3_CDEPREC
				// - Código Válido
				// - Conta Ativa CT1_BLOQ <> '1'
				If !Empty(cCDDLin)
					If ! CT1->( dbSeek(xFilial("CT1")+cCDDLin) ) 
						aAdd( aIteSN1 , { "SN3" , StrZero(nLinha,7),'Conta N3_CDEPREC inválida: '+AllTrim(cCDDLin) } )
					ElseIf CT1->CT1_BLOQ == '1'
						aAdd( aIteSN1 , { "SN3" , StrZero(nLinha,7),'Conta N3_CDEPREC bloqueada: '+AllTrim(cCDDLin) } )
					EndIf
				EndIf

				// N3_CCDEPR
				// - Código Válido
				// - Conta Ativa CT1_BLOQ <> '1'
				If !Empty(cCDALin)
					If ! CT1->( dbSeek(xFilial("CT1")+cCDALin) ) 
						aAdd( aIteSN1 , { "SN3" , StrZero(nLinha,7),'Conta N3_CCDEPR inválida: '+AllTrim(cCDALin) } )
					ElseIf CT1->CT1_BLOQ == '1'
						aAdd( aIteSN1 , { "SN3" , StrZero(nLinha,7),'Conta N3_CCDEPR bloqueada: '+AllTrim(cCDALin) } )
					EndIf
				EndIf

				// N3_HISTOR 
				// - Tamanho
				If Len(cHisLin) > nTamHis 
					aAdd( aIteSN1 , { "SN3" , StrZero(nLinha,7),'Histórico maior que tamanho do campo N3_HISTOR ('+AllTrim(Str(nTamHis))+')' } )
				EndIf

				// N3_SEQ 
				// - Tamanho
				If Len(cSeqLin) > nTamSeq 
					aAdd( aIteSN1 , { "SN3" , StrZero(nLinha,7),'Sequencia '+cSeqLin+' maior que tamanho do campo N3_SEQ ('+AllTrim(Str(nTamSeq))+')' } )
				EndIf

				// N3_CUSTBEM
				// - Código Válido
				// - C.Custo Ativo CTT_BLOQ <> '1'
				If ! CTT->( dbSeek(xFilial("CTT")+cCusLin) ) 
					aAdd( aIteSN1 , { "SN3" , StrZero(nLinha,7),'Centro de Custo inválido: '+AllTrim(cCusLin) } )
				ElseIf CTT->CTT_BLOQ == '1'
					aAdd( aIteSN1 , { "SN3" , StrZero(nLinha,7),'Centro de Custo bloqueada: '+AllTrim(cCusLin) } )
				EndIf

				// N3_SUBCCON
				// - Código Válido
				// - Item Ativo CTD_BLOQ <> '1'
				If ! CTD->( dbSeek(xFilial("CTD")+cItCLin) ) 
					aAdd( aIteSN1 , { "SN3" , StrZero(nLinha,7),'Item Contábil inválido: '+AllTrim(cItCLin) } )
				ElseIf CT1->CT1_BLOQ == '1'
					aAdd( aIteSN1 , { "SN3" , StrZero(nLinha,7),'Item Contábil inválido: '+AllTrim(cItCLin) } )
				EndIf

				// N3_AQUISIC 
				// - <= 31/03/2018
				If CTOD(aDados[nPosDtA]) > CTOD("31/03/2018") 
					aAdd( aIteSN1 , { "SN3" , StrZero(nLinha,7),'Data de aquisição '+aDados[nPosDtA]+' maior 31/03/2018' } )
				EndIf

				// N3_VORIG1
				// - Valor > 0
				// - Valor < 9999999999999.99 (Valor máximo aceito pelo campo) 
				If nVO1Lin <= 0 .Or. nVO1Lin > 9999999999999.99 
					aAdd( aIteSN1 , { "SN3" , StrZero(nLinha,7),'Valor N3_VORIG1 inválido: ' + AllTrim(Str(nVO1Lin)) } )
				EndIf

				// N3_VORIG3
				// - Valor > 0
				// - Valor < 99999999999.9999 (Valor máximo aceito pelo campo) 
				If nVO3Lin <= 0 .Or. nVO3Lin > 99999999999.9999 
					aAdd( aIteSN1 , { "SN3" , StrZero(nLinha,7),'Valor N3_VORIG3 inválido: ' + AllTrim(Str(nVO3Lin)) } )
				EndIf
				
				// N3_VRDACM1
				// - Valor >= 0
				// - Valor < 9999999999999.99 (Valor máximo aceito pelo campo) 
				If nVA1Lin < 0 .Or. nVA1Lin > 9999999999999.99 
					aAdd( aIteSN1 , { "SN3" , StrZero(nLinha,7),'Valor N3_VRDACM1 inválido: ' + AllTrim(Str(nVA1Lin)) } )
				EndIf

				// N3_VRDACM3
				// - Valor >= 0
				// - Valor < 99999999999.9999 (Valor máximo aceito pelo campo) 
				If nVA3Lin < 0 .Or. nVA3Lin > 99999999999.9999 
					aAdd( aIteSN1 , { "SN3" , StrZero(nLinha,7),'Valor N3_VRDACM3 inválido: ' + AllTrim(Str(nVA3Lin)) } )
				EndIf

				// N3_VRDACM1 > N3_VORIG1 
				If nVA1Lin > nVO1Lin  
					aAdd( aIteSN1 , { "SN3" , StrZero(nLinha,7),'Valor N3_VRDACM1 > N3_VORIG1' } )
				EndIf

				// N3_VRDACM3 > N3_VORIG3 
				If nVA3Lin > nVO3Lin  
					aAdd( aIteSN1 , { "SN3" , StrZero(nLinha,7),'Valor N3_VRDACM3 > N3_VORIG3' } )
				EndIf

				// N3_FILIAL + N3_CBASE + N3_ITEM + N3_TIPO
				// - Apontar Duplicidades
				If lCodLin
					//If aScan(aChaveN3A,{|x| x == cFilLin + cCodLin + cIteLin }) == 0
						aAdd( aChaveN3A , cFilLin + cCodLin + cIteLin )
					//EndIf
					If aScan(aChaveN3B,{|x| x == cFilLin + cCodLin + cIteLin + cTipLin }) > 0
						aAdd( aIteSN1 , { "SN3" , StrZero(nLinha,7),'Registro em duplicidade (Filial+Código+Item+Tipo): ' + cFilLin + " - " + cCodLin + " - " + cIteLin + " - " + cTipLin } )
					Else
						aAdd( aChaveN3B , cFilLin + cCodLin + cIteLin + cTipLin )
					EndIf
				EndIf

			EndIf
		EndIf

		FT_FSKIP()

	EndDo

	FT_FUSE()

	FT_FUSE(cArqCab)
	FT_FGOTOP()
	cLinha	:= FT_FREADLN()
	cLinha	:= ";"+cLinha+";"
	nLinha	:= 1

	aCampos	:= Separa(cLinha,";")
	cLinha	:= ""

	For nI := 1 To Len(aCampos)
		If ( ( nI == 1 .Or. nI == Len(aCampos) ) .And. Empty(aCampos[nI]) )
			aDel( aCampos , nI )
			aSize( aCampos , Len(aCampos)-1 )
		EndIf
	Next nI

	nPosFil	:= aScan(aCampos,{|x| alltrim(x) == "N1_FILIAL"})
	nPosCod	:= aScan(aCampos,{|x| alltrim(x) == "N1_CBASE"})
	nPosIte	:= aScan(aCampos,{|x| alltrim(x) == "N1_ITEM"})
	nPosCha	:= aScan(aCampos,{|x| alltrim(x) == "N1_CHAPA"}) 
	nTamCha	:= TamSX3("N1_CHAPA")[1]
	nPosGrp	:= aScan(aCampos,{|x| alltrim(x) == "N1_GRUPO"})
	nPosPat	:= aScan(aCampos,{|x| alltrim(x) == "N1_PATRIM"})
	nPosQtd	:= aScan(aCampos,{|x| alltrim(x) == "N1_QUANTD"})
	nPosDes	:= aScan(aCampos,{|x| alltrim(x) == "N1_DESCRIC"})
	nTamDes	:= TamSX3("N1_DESCRIC")[1]
	nPosFor	:= aScan(aCampos,{|x| alltrim(x) == "N1_FORNEC"})
	nTamFor	:= TamSX3("N1_FORNEC")[1]
	nPosLoj	:= aScan(aCampos,{|x| alltrim(x) == "N1_LOJA"})
	nTamLoj	:= TamSX3("N1_LOJA")[1]

	nPosDtA	:= aScan(aCampos,{|x| alltrim(x) == "N1_AQUISIC"})
	nPosDPt	:= aScan(aCampos,{|x| alltrim(x) == "N1_DETPATR"})
	nPosUPt	:= aScan(aCampos,{|x| alltrim(x) == "N1_UTIPATR"})
	
	nPosPis	:= aScan(aCampos,{|x| alltrim(x) == "N1_CSTPIS"})
	nPosCof	:= aScan(aCampos,{|x| alltrim(x) == "N1_CSTCOFI"})
	nPosBcc	:= aScan(aCampos,{|x| alltrim(x) == "N1_CODBCC"})
	nPosSer	:= aScan(aCampos,{|x| alltrim(x) == "N1_NSERIE"})
	nTamSer	:= TamSX3("N1_NSERIE")[1]
	nPosNot	:= aScan(aCampos,{|x| alltrim(x) == "N1_NFISCAL"})
	nTamNot	:= TamSX3("N1_NFISCAL")[1]
	nPosSta	:= aScan(aCampos,{|x| alltrim(x) == "N1_STATUS"})
	nPosCal	:= aScan(aCampos,{|x| alltrim(x) == "N1_CALCPIS"})
	nPospen	:= aScan(aCampos,{|x| alltrim(x) == "N1_PENHORA"})
	nPosQua	:= aScan(aCampos,{|x| alltrim(x) == "N1_QUALIFI"})
	nPosOri	:= aScan(aCampos,{|x| alltrim(x) == "N1_ORIGCRD"})


	FT_FSKIP()

	While !FT_FEOF()

		nLinha++

		If Empty( cLinha )
			cLinha := FT_FREADLN()
		EndIf

		aDados	:= Separa(cLinha,";")
		cLinha	:= ""
		
		cFilLin	:= Stuff( Space( TamSX3(Upper(aCampos[nPosFil]))[1] ) , 1 , Len(aDados[nPosFil]) , aDados[nPosFil] )

		If Empty( cFilArq )
			cFilArq	:= cFilLin
			If !SM0->( dbSeek(cEmpAnt+cFilArq) )
				aAdd( aIteSN1 , { "SN1" , StrZero(nLinha,7),'Filial do arquivo não existe: ' + cFilArq } )
				Exit
			EndIf
		EndIf

		If Len(aDados) <> Len(aCampos)
			aAdd( aIteSN1 , { "SN1" , StrZero(nLinha,7),'Estrutura divergente do cabeçalho' } )
		Else

			For nI := 1 to Len( aObrSN1 )
				If Empty(aDados[aObrSN1[nI]])
					aAdd( aIteSN1 , { "SN1" , StrZero(nLinha,7),'Campo obrigatório não informado: ' + aCampos[aObrSN1[nI]] } )
				EndIf
			Next nI
			
			cFilLin	:= Stuff( Space( TamSX3(Upper(aCampos[nPosFil]))[1] ) , 1 , Len(aDados[nPosFil]) , aDados[nPosFil] )
			cCodLin	:= Stuff( Space( TamSX3(Upper(aCampos[nPosCod]))[1] ) , 1 , Len(aDados[nPosCod]) , aDados[nPosCod] )
			cIteLin	:= Stuff( Space( TamSX3(Upper(aCampos[nPosIte]))[1] ) , 1 , Len(aDados[nPosIte]) , aDados[nPosIte] )
			cDesLin	:= Stuff( Space( TamSX3(Upper(aCampos[nPosDes]))[1] ) , 1 , Len(aDados[nPosDes]) , aDados[nPosDes] )
			cChaLin	:= Stuff( Space( TamSX3(Upper(aCampos[nPosCha]))[1] ) , 1 , Len(aDados[nPosCha]) , aDados[nPosCha] )
			cGrpLin	:= Stuff( Space( TamSX3(Upper(aCampos[nPosGrp]))[1] ) , 1 , Len(aDados[nPosGrp]) , aDados[nPosGrp] )
			cPatLin	:= Stuff( Space( TamSX3(Upper(aCampos[nPosPat]))[1] ) , 1 , Len(aDados[nPosPat]) , aDados[nPosPat] )
			cForLin	:= Stuff( Space( TamSX3(Upper(aCampos[nPosFor]))[1] ) , 1 , Len(aDados[nPosFor]) , aDados[nPosFor] )
			cLojLin	:= Stuff( Space( TamSX3(Upper(aCampos[nPosLoj]))[1] ) , 1 , Len(aDados[nPosLoj]) , aDados[nPosLoj] )
			cDPtLin	:= Stuff( Space( TamSX3(Upper(aCampos[nPosDPt]))[1] ) , 1 , Len(aDados[nPosDPt]) , aDados[nPosDPt] )
			cUPtLin	:= Stuff( Space( TamSX3(Upper(aCampos[nPosUPt]))[1] ) , 1 , Len(aDados[nPosUPt]) , aDados[nPosUPt] )
			
			cPisLin	:= Stuff( Space( TamSX3(Upper(aCampos[nPosPis]))[1] ) , 1 , Len(aDados[nPosPis]) , aDados[nPosPis] )
			cCofLin	:= Stuff( Space( TamSX3(Upper(aCampos[nPosCof]))[1] ) , 1 , Len(aDados[nPosCof]) , aDados[nPosCof] )
			cBccLin	:= Stuff( Space( TamSX3(Upper(aCampos[nPosBcc]))[1] ) , 1 , Len(aDados[nPosBcc]) , aDados[nPosBcc] )
			cSerLin	:= Stuff( Space( TamSX3(Upper(aCampos[nPosSer]))[1] ) , 1 , Len(aDados[nPosSer]) , aDados[nPosSer] )
			cNotLin	:= Stuff( Space( TamSX3(Upper(aCampos[nPosNot]))[1] ) , 1 , Len(aDados[nPosNot]) , aDados[nPosNot] )
			cStaLin	:= Stuff( Space( TamSX3(Upper(aCampos[nPosSta]))[1] ) , 1 , Len(aDados[nPosSta]) , aDados[nPosSta] )
			cCalLin	:= Stuff( Space( TamSX3(Upper(aCampos[nPosCal]))[1] ) , 1 , Len(aDados[nPosCal]) , aDados[nPosCal] )
			cPenLin	:= Stuff( Space( TamSX3(Upper(aCampos[nPosPen]))[1] ) , 1 , Len(aDados[nPosPen]) , aDados[nPosPen] )
			cQuaLin	:= Stuff( Space( TamSX3(Upper(aCampos[nPosQua]))[1] ) , 1 , Len(aDados[nPosQua]) , aDados[nPosQua] )
			cOriLin	:= Stuff( Space( TamSX3(Upper(aCampos[nPosOri]))[1] ) , 1 , Len(aDados[nPosOri]) , aDados[nPosOri] )

			nQtdLin	:= aDados[nPosQtd]
			If At(",",nQtdLin)
				nQtdLin := StrTran(nQtdLin,".")
			EndIf
			
			nQtdLin := StrTran(nQtdLin,",",".")
			nQtdLin := Val(nQtdLin)

			If !SM0->( dbSeek(cEmpAnt+cFilLin) )
				aAdd( aIteSN1 , { "SN1" , StrZero(nLinha,7),'Filial não existe: ' + cFilLin } )
			Else
				If cFilArq	<> cFilLin
					aAdd( aIteSN1 , { "SN1" , StrZero(nLinha,7),'Filial '+cFilLin+' diferente da filial do arquivo: '+cFilArq } )
				EndIf	

				lCodLin	:= .T.

				// N1_CBASE 
				// - Tamanho
				If Len(cCodLin) > nTamCod 
					aAdd( aIteSN1 , { "SN1" , StrZero(nLinha,7),'Código '+AllTrim(cCodLin)+' maior que tamanho do campo N1_CBASE ('+AllTrim(Str(nTamCod))+')' } )
				EndIf

				// N1_ITEM 
				// - Tamanho
				If Len(cIteLin) > nTamIte 
					aAdd( aIteSN1 , { "SN1" , StrZero(nLinha,7),'Item '+AllTrim(cIteLin)+' maior que tamanho do campo N1_ITEM ('+AllTrim(Str(nTamIte))+')' } )
				EndIf

				// N1_GRUPO 
				// - Código Válido
				If Empty(GetAdvFVal("SNG","NG_GRUPO",xFilial("SNG")+cGrpLin,1,"")) 
					aAdd( aIteSN1 , { "SN1" , StrZero(nLinha,7),'Grupo inválido: '+AllTrim(cGrpLin) } )
				EndIf
				
				// N1_PATRIM 
				// - Código Válido
				If Empty(GetAdvFVal("SN0","N0_CHAVE",xFilial("SN0")+"07"+cPatLin,1,"")) 
					aAdd( aIteSN1 , { "SN1" , StrZero(nLinha,7),'Classificasção inválida: '+AllTrim(cPatLin) } )
				EndIf

				// N1_AQUISIC 
				// - <= 31/03/2018
				If CTOD(aDados[nPosDtA]) > CTOD("31/03/2018") 
					aAdd( aIteSN1 , { "SN1" , StrZero(nLinha,7),'Data de aquisição '+aDados[nPosDtA]+' maior 31/03/2018' } )
				EndIf

				// N1_QUANTD
				// - Valor > 0
				// - Valor < 9999999.999 (Valor máximo aceito pelo campo)
				If nQtdLin <= 0 .Or. nQtdLin > 9999999.999 
					aAdd( aIteSN1 , { "SN1" , StrZero(nLinha,7),'Quantidade inválida: ' + AllTrim(Str(nQtdLin)) } )
				EndIf

				// N1_DESCRIC 
				// - Tamanho
				If Len(cDesLin) > nTamDes 
					aAdd( aIteSN1 , { "SN1" , StrZero(nLinha,7),'Descrição maior que tamanho do campo N1_DESCRIC ('+AllTrim(Str(nTamDes))+')' } )
				EndIf

				// N1_CHAPA 
				// - Tamanho
				If Len(cChaLin) > nTamCha 
					aAdd( aIteSN1 , { "SN1" , StrZero(nLinha,7),'Chapa maior que tamanho do campo N1_CHAPA ('+AllTrim(Str(nTamCha))+')' } )
				EndIf

				// N1_FORNEC+N1_LOJA
				// - Códigos válidos
				// - Tamanho
				If !Empty(cForLin+cLojLin) .And. (Empty(cLojLin).Or.Empty(cLojLin))
					aAdd( aIteSN1 , { "SN1" , StrZero(nLinha,7),'Código/Loja Fornecedor incompleto: '+AllTrim(cForLin)+"/"+AllTrim(cLojLin) } )
				ElseIf !Empty(cForLin+cLojLin)
					If !SA2->( dbSeek(xFilial("SA2")+cForLin+cLojLin) ) 
						aAdd( aIteSN1 , { "SN1" , StrZero(nLinha,7),'Código/Loja Fornecedor não localizado: '+AllTrim(cForLin)+"/"+AllTrim(cLojLin) } )
					ElseIf SA2->A2_MSBLQL == "1"
						aAdd( aIteSN1 , { "SN1" , StrZero(nLinha,7),'Código/Loja Fornecedor bloqueado: '+AllTrim(cForLin)+"/"+AllTrim(cLojLin) } )
					EndIf
				EndIf

				// N1_DETPATR 
				// - Código Válido
				If !Empty(cDPtLin)
					If Empty(GetAdvFVal('SN0','N0_CHAVE',xFilial("SN0")+'11'+cDPtLin,1,""))
						aAdd( aIteSN1 , { "SN1" , StrZero(nLinha,7),'Identif.Bem inválido: '+AllTrim(cDPtLin) } )
						EndIf
				EndIf

				// N1_UTIPATR
				// - Código Válido
				If !Empty(cUPtLin)
					If Empty(GetAdvFVal('SN0','N0_CHAVE',xFilial("SN0")+'12'+cUPtLin,1,""))
						aAdd( aIteSN1 , { "SN1" , StrZero(nLinha,7),'Utiliz.Bem inválida: '+AllTrim(cUPtLin) } )
						EndIf
				EndIf

				// N1_CSTPIS
				// - Código Válido
				If !Empty(cPisLin)
					If Empty(Tabela('SX',cPisLin,.F.))
						aAdd( aIteSN1 , { "SN1" , StrZero(nLinha,7),'Sit.Trib.PIS inválida: '+AllTrim(cPisLin) } )
						EndIf
				EndIf

				// N1_CSTCOFI
				// - Código Válido
				If !Empty(cCofLin)
					If Empty(Tabela('SX',cCofLin,.F.))
						aAdd( aIteSN1 , { "SN1" , StrZero(nLinha,7),'Sit.Trib.Cof inválida: '+AllTrim(cCofLin) } )
						EndIf
				EndIf

				// N1_CODBCC
				// - Código Válido
				If !Empty(cBccLin)
					If Empty(Tabela('MZ',cBccLin,.F.))
						aAdd( aIteSN1 , { "SN1" , StrZero(nLinha,7),'Cod.BC Cred. inválido: '+AllTrim(cBccLin) } )
						EndIf
				EndIf

				// N1_NSERIE
				// - Tamanho
				If Len(cSerLin) > nTamSer 
					aAdd( aIteSN1 , { "SN1" , StrZero(nLinha,7),'Série maior que tamanho do campo N1_NSERIE ('+AllTrim(Str(nTamSer))+')' } )
				EndIf

				// N1_NFISCAL
				// - Tamanho
				If Len(cNotLin) > nTamNot 
					aAdd( aIteSN1 , { "SN1" , StrZero(nLinha,7),'Nota Fiscal maior que tamanho do campo N1_NFISCAL ('+AllTrim(Str(nTamNot))+')' } )
				EndIf

				// N1_STATUS
				// - Código Válido
				If !Empty(cStaLin)
					If !cStaLin $ "1|2|3|4|9" 
						aAdd( aIteSN1 , { "SN1" , StrZero(nLinha,7),'Status Bem inválido: '+AllTrim(cStaLin) } )
					EndIf
				EndIf

				// N1_CALCPIS
				// - Código Válido
				If !Empty(cCalLin)
					If !cCalLin $ "1|2|3|" 
						aAdd( aIteSN1 , { "SN1" , StrZero(nLinha,7),'Calc. PIS inválido: '+AllTrim(cCalLin) } )
					EndIf
				EndIf

				// N1_PENHORA
				// - Código Válido
				If !Empty(cPenLin)
					If !cPenLin $ "0|1||2|3|" 
						aAdd( aIteSN1 , { "SN1" , StrZero(nLinha,7),'Sit. Penhora inválido: '+AllTrim(cPenLin) } )
					EndIf
				EndIf

				// N1_QUALIFI
				// - Código Válido
				If !Empty(cQuaLin)
					If !cQuaLin $ "1||2|3|4|" 
						aAdd( aIteSN1 , { "SN1" , StrZero(nLinha,7),'Qualificação inválida: '+AllTrim(cQuaLin) } )
					EndIf
				EndIf

				// N1_ORIGCRD
				// - Código Válido
				If !Empty(cOriLin)
					If !cOriLin $ "0|1|" 
						aAdd( aIteSN1 , { "SN1" , StrZero(nLinha,7),'Orig. Cred. inválido: '+AllTrim(cOriLin) } )
					EndIf
				EndIf

				// N1_FILIAL + N1_CBASE + N1_ITEM
				// N1_FILIAL + N1_CHAPA 
				// - Apontar Duplicidades
				If lCodLin
					If aScan(aChaveN1A,{|x| x == cFilLin + cCodLin + cIteLin }) > 0
						aAdd( aIteSN1 , { "SN1" , StrZero(nLinha,7),'Registro em duplicidade (Filial+Código+Item): ' + cFilLin + " - " + cCodLin + " - " + cIteLin } )
					Else
						aAdd( aChaveN1A , cFilLin + cCodLin + cIteLin )
					EndIf
					If aScan(aChaveN1B,{|x| x == cFilLin + cChaLin }) > 0
						aAdd( aIteSN1 , { "SN1" , StrZero(nLinha,7),'Registro em duplicidade (Filial+Chapa): ' + cFilLin + " - " + cChaLin } )
					Else
						aAdd( aChaveN1B , cFilLin + cChaLin )
					EndIf
					If aScan(aChaveN3A,{|x| x == cFilLin + cCodLin + cIteLin }) == 0
						aAdd( aIteSN1 , { "SN1" , StrZero(nLinha,7),'Registro SN3 não localizado (Filial+Código+Item): ' + cFilLin + " - " + cCodLin + " - " + cIteLin } )
					EndIf
					If aScan(aChaveN3B,{|x| x == cFilLin + cCodLin + cIteLin + "01" }) == 0
						aAdd( aIteSN1 , { "SN1" , StrZero(nLinha,7),'Registro SN3 Depreciação Fiscal (01) não localizado (Filial+Código+Item): ' + cFilLin + " - " + cCodLin + " - " + cIteLin } )
					EndIf
				EndIf

			EndIf
		EndIf

		FT_FSKIP()

	EndDo

	FT_FUSE()

	For nI := 1 to Len(aChaveN3A)
		If aScan(aChaveN1A,{|x| x == aChaveN3A[nI] }) == 0
			aAdd( aIteSN1 , { "SN3" , StrZero(nI+1,7),'Registro SN1 não localizado (Filial+Código+Item): ' + aChaveN3A[nI] } )
		EndIf
	Next nI

	If Len( aIteSN1 ) > 0
		cMsg	:= U_zGeraExc(aColSN1,aIteSN1,cArqExc,cPatSrv,cPatLoc,"Validação Carga SN1/SN3 - Divergência na Estrutura ")
		MsgStop("Divergência nas Informações. Verifique Log ","Validação Carga SN1/SN3")
	Else
		Aviso("Validação Carga SD3","Arquivo com Estrutura e Informações validados",{"Ok"})
	EndIf

	RestArea( aAreaSM0 )

Return