#include "protheus.ch"
#include "rwmake.ch"
#include "TOTVS.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "DBSTRUCT.CH"
#INCLUDE "MSGRAPHI.CH"

/*
=====================================================================================
Programa.:              MGFIMP02
Autor....:              Atilio Amarilla
Data.....:              29/03/2018
Descricao / Objetivo:   valida��o de Estrutura/informa��es do arquivo de carga de saldos
Doc. Origem:            Contrato - GAP MGFIMP01
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Relacionado � Importa��o de Cadastros - Saldos Iniciais
=====================================================================================
*/

User Function MGFIMP02()


	Local aSays		:={}
	Local aButtons	:={}
	Local nOpca		:= 0


	// Inicializa o log de processamento
	// ProcLogIni( aButtons ) 
	AADD(aSays, 'Este programa tem como objetivo validar estrutura/informa��es de arquivo de saldos.') 
	AADD(aSays, 'Estrutura deve conter os campos:') 
	AADD(aSays, '	D3_FILIAL / D3_COD / D3_QUANT / D3_LOCAL / D3_CUSTO1 / D3_LOCALIZ') 
	AADD(aSays, 'Ser� feita valida��o das informa��es de todos os campos e gerado log com inconsist�ncias')

	//AADD(aButtons, { 5,.T.,{|| Pergunte('XXX190',.T. ) } } ) 

	//AADD(aButtons, { 1,.T.,{|| nOpca:= 1, If( ProcOk(), FechaBatch(), nOpca:=0 ) }} ) 
	AADD(aButtons, { 1,.T.,{|| nOpca:= 1 , FechaBatch()  }} )
	AADD(aButtons, { 2,.T.,{|| FechaBatch() }} )  

	FormBatch( 'Valida��o de Carga - SD3', aSays, aButtons,, 220, 560 )

	If nOpca == 1                   
		// Atualiza o log de processamento  com o in�cio do processamento 
		//ProcLogAtu('INICIO')
		//...Processamento da rotina....
		//.. Em Caso de Erros atualiza o log de erros do processamento
		// Atualiza o log de processamento com o erro 
		//ProcLogAtu('ERRO','Erro no processamento','O campo xxx nao est� dispon�vel na tabela yyy, ')
		// Atualiza o log de processamento caso o processamento seja cancelado
		//ProcLogAtu('CANCEL','Cancalado pelo usuario') 
		// Atualiza o log de processamento com o fim do processamento
		//Proc	LogAtu('FIM')

		MsgRun("Valida��o de arquivo SD3. Aguarde...",,{|| MGFIMP0201() })

	EndIf

Return

Static Function MGFIMP0201()

	Local cArq		:= ""
	Local cPatLoc	:= ""

	Local aColSD3	:= {"Linha","Ocorr�ncia"}
	Local aIteSD3
	Local cLinha, nLinha, nCampos
	Local cFilArq	:= " "
	Local aAreaSM0	:= SM0->( GetArea() )
	Local nPosFil, nPosCod, nPosQtd, nPosLoc, nPosCus, nPosEnd
	Local nTamQtd	:= nDecQtd	:= nTamCus	:= nDecCus	:= nMaxQtd	:= nMaxCus	:= nTamSX3	:= 0
	Local nI		:= 0
	Local cTipo		:= "D3"
	Local cCampo	:= ""
	Local aChave	:= {}

	Local cNome := ""

	Local cArqExc := ""//cNome+".XML"

	Private cPatSrv	:= GetMv("MGF_IMP02A",,"\MGF\IMP\VLDSD3\")				// Path de grava��o de Arquivos Server

	// Abertura de Arquivos
	dbSelectArea("SB1")	// Descricao Generica do Produto 
	dbSetOrder(1)		// B1_FILIAL+B1_COD

	dbSelectArea("NNR")	// Locais de Estoque
	dbSetOrder(1)		// NNR_FILIAL+NNR_CODIGO

	dbSelectArea("SBE")	// Enderecos
	dbSetOrder(1)		// BE_FILIAL+BE_LOCAL+BE_LOCALIZ+BE_ESTFIS

	cArq := cGetFile("Todos os Arquivos|*.csv", OemToAnsi("Informe o diret�rio onde se encontra o arquivo."), 0, "SERVIDOR\", .F., GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE ,.T.)

	If !File(cArq)
		MsgStop("O arquivo " +cArq + " n�o foi selecionado. A valida��o ser� abortada!","ATEN��O")
		Return
	Else
		cPatLoc := Subs(cArq,1, Rat("\",cArq) )
		cNome	:= UPPER( Subs(cArq,Rat("\",cArq) ) )
		cNome	:= StrTran(cNome,".CSV")+"-"+Subs(DTOS(Date()),3,6)+StrTran(Time(),":")
		cArqExc := cNome+".XML"
	EndIf

	aIteSD3	:= {}

	FT_FUSE(cArq)
	FT_FGOTOP()
	cLinha	:= FT_FREADLN()
	cLinha	:= ";"+cLinha+";"
	nLinha	:= 1
	If !";D3_FILIAL;" $ cLinha
		aAdd( aIteSD3 , { StrZero(nLinha,7),'Campo D3_FILIAL n�o informado no arquivo' } )
	EndIf

	If !";D3_COD;" $ cLinha
		aAdd( aIteSD3 , { StrZero(nLinha,7),'Campo D3_COD n�o informado no arquivo' } )
	EndIf

	If !";D3_QUANT;" $ cLinha
		aAdd( aIteSD3 , { StrZero(nLinha,7),'Campo D3_QUANT n�o informado no arquivo' } )
	EndIf

	If !";D3_LOCAL;" $ cLinha
		aAdd( aIteSD3 , { StrZero(nLinha,7),'Campo D3_LOCAL n�o informado no arquivo' } )
	EndIf

	If !";D3_CUSTO1;" $ cLinha
		aAdd( aIteSD3 , { StrZero(nLinha,7),'Campo D3_CUSTO1 n�o informado no arquivo' } )
	EndIf

	If !";D3_LOCALIZ;" $ cLinha
		aAdd( aIteSD3 , { StrZero(nLinha,7),'Campo D3_LOCALIZ n�o informado no arquivo' } )
	EndIf

	aCampos	:= Separa(cLinha,";")
	cLinha	:= ""


	dbSelectArea("SX3")
	DbSetOrder(2)
	For nI := 1 To Len(aCampos)
		If ( ( nI == 1 .Or. nI == Len(aCampos) ) .And. Empty(aCampos[nI]) )
			aDel( aCampos , nI )
			aSize( aCampos , Len(aCampos)-1 )
		EndIf
	Next nI
	For nI := 1 To Len(aCampos)
		cCampo	:= Stuff( Space(Len(SX3->X3_CAMPO)) , 1 , Len(aCampos[nI]) , aCampos[nI] )
		IF cTipo <> SUBSTR( cCampo , 1 , 2 )  
			aAdd( aIteSD3 , { StrZero(nLinha,7),'Campo '+ AllTrim(cCampo) +' n�o pertence � tabela SD3' } )
		ElseIf !SX3->(dbSeek( cCampo ))
			aAdd( aIteSD3 , { StrZero(nLinha,7),'Campo '+ AllTrim(cCampo) +' n�o encontrado no dicion�rio' } )
		ElseIf ( SX3->X3_CONTEXT == "V" )
			aAdd( aIteSD3 , { StrZero(nLinha,7),'Campo '+ AllTrim(cCampo) +' marcado na tabela como virtual (X3_CONTEXT)' } )
		EndIf
	Next nI

	If Len( aIteSD3 ) > 0
		FT_FUSE()
		MsgStop("Diverg�ncia na Estrutura. Verifique Log ","Valida��o Carga SD3")
		cMsg	:= U_zGeraExc(aColSD3,aIteSD3,cArqExc,cPatSrv,cPatLoc,"Valida��o Carga SD3 - Diverg�ncia na Estrutura ")
		Return
	EndIf

	nPosFil	:= aScan(aCampos,{|x| alltrim(x) == "D3_FILIAL"})
	nPosCod	:= aScan(aCampos,{|x| alltrim(x) == "D3_COD"})
	nPosQtd	:= aScan(aCampos,{|x| alltrim(x) == "D3_QUANT"})
	nPosLoc	:= aScan(aCampos,{|x| alltrim(x) == "D3_LOCAL"})
	nPosCus	:= aScan(aCampos,{|x| alltrim(x) == "D3_CUSTO1"})
	nPosEnd	:= aScan(aCampos,{|x| alltrim(x) == "D3_LOCALIZ"})

	aCodPro	:= {}

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
				aAdd( aIteSD3 , { StrZero(nLinha,7),'Filial do arquivo n�o existe: ' + cFilArq } )
				Exit
			EndIf
		EndIf

		If Len(aDados) <> Len(aCampos)
			aAdd( aIteSD3 , { StrZero(nLinha,7),'Estrutura divergente do cabe�alho' } )
		Else
			cFilLin	:= Stuff( Space( TamSX3(Upper(aCampos[nPosFil]))[1] ) , 1 , Len(aDados[nPosFil]) , aDados[nPosFil] )
			cCodLin	:= Stuff( Space( TamSX3(Upper(aCampos[nPosCod]))[1] ) , 1 , Len(aDados[nPosCod]) , aDados[nPosCod] )
			nQtdLin	:= aDados[nPosQtd]
			If At(",",nQtdLin)
				nQtdLin := StrTran(nQtdLin,".")
			EndIf
			nQtdLin := StrTran(nQtdLin,",",".")
			nQtdLin := Val(nQtdLin)
			cLocLin	:= Stuff( Space( TamSX3(Upper(aCampos[nPosLoc]))[1] ) , 1 , Len(aDados[nPosLoc]) , aDados[nPosLoc] )
			nCusLin	:= aDados[nPosCus]
			If At(",",nCusLin)
				nCusLin := StrTran(nCusLin,".")
			EndIf
			nCusLin := StrTran(nCusLin,",",".")
			nCusLin := Val(nCusLin)
			cEndLin	:= Stuff( Space( TamSX3(Upper(aCampos[nPosEnd]))[1] ) , 1 , Len(aDados[nPosEnd]) , aDados[nPosEnd] )

			//D3_FILIAL 
			//- C�digo V�lido 
			//- Todos os c�digos s�o da mesma filial

			If !SM0->( dbSeek(cEmpAnt+cFilLin) )
				aAdd( aIteSD3 , { StrZero(nLinha,7),'Filial n�o existe: ' + cFilLin } )
			Else
				If cFilArq	<> cFilLin
					aAdd( aIteSD3 , { StrZero(nLinha,7),'Filial '+cFilLin+' diferente da filial do arquivo: '+cFilArq } )
				EndIf	

				// D3_COD 
				// - C�digo V�lido
				// - Bloqueio (B1_MSBLQL)
				lCodLin	:= .T.
				If !SB1->( dbSeek( xFilial("SB1",cFilArq) + cCodLin ) )
					aAdd( aIteSD3 , { StrZero(nLinha,7),'Produto n�o existe: ' + AllTrim(cCodLin) } )
					lCodLin	:= .F. 
				ElseIf SB1->( FieldPos("B1_MSBLQL") ) > 0
					If SB1->B1_MSBLQL == "1"
						aAdd( aIteSD3 , { StrZero(nLinha,7),'Produto bloqueado: ' + AllTrim(cCodLin) } )
					EndIf
				EndIf

				// D3_QUANT
				// - Valor > 0
				// - Valor < 999999999999.999 (Valor m�ximo aceito pelo campo)
				If nQtdLin <= 0 .Or. nQtdLin > 999999999999.999 
					aAdd( aIteSD3 , { StrZero(nLinha,7),'Quantidade inv�lida: ' + AllTrim(Str(nQtdLin)) } )
				EndIf

				// D3_LOCAL
				// - C�digo V�lido
				// - Bloqueio (NNR_MSBLQL)
				If !NNR->( dbSeek( xFilial("NNR",cFilArq) + cLocLin ) )
					aAdd( aIteSD3 , { StrZero(nLinha,7),'Armaz�m n�o existe: ' + AllTrim(cLocLin) } )
				ElseIf NNR->( FieldPos("NNR_MSBLQL") ) > 0
					If NNR->NNR_MSBLQL == "1"
						aAdd( aIteSD3 , { StrZero(nLinha,7),'Armaz�m bloqueado: ' + AllTrim(cLocLin) } )
					EndIf
				EndIf

				// D3_CUSTO1
				// - Valor > 0
				// - Valor < 99999999999.99 (Valor m�ximo aceito pelo campo)
				If nCusLin <= 0 .Or. nCusLin > 99999999999.99 
					aAdd( aIteSD3 , { StrZero(nLinha,7),'Custo inv�lido: ' + AllTrim(Str(nCusLin)) } )
				EndIf

				// D3_LOCALIZ
				// - C�digo V�lido
				// - Status (BE_STATUS) - 1=Desocupado;2=Ocupado;3=Bloqueado;4=Bloqueio Entrada;5=Bloqueio Saida;6=Bloqueio Inventario
				// - Bloqueio (BE_MSBLQL)
				lEndLin	:= .T.
				If lCodLin
					If SB1->B1_LOCALIZ = 'S' .And. !Empty(cEndLin)
						If !SBE->( dbSeek( xFilial("SBE",cFilArq) + cLocLin + cEndLin ) )
							aAdd( aIteSD3 , { StrZero(nLinha,7),'Armaz�m + Endere�o n�o existe: ' + AllTrim(cLocLin) + "-" + AllTrim(cEndLin) } )
							lEndLin	:= .F.
						ElseIf SBE->BE_STATUS $ "34"
							aAdd( aIteSD3 , { StrZero(nLinha,7),'Armaz�m + Endere�o - Status bloqueado: ' + AllTrim(cLocLin) + "-" + AllTrim(cEndLin) } )
						ElseIf SBE->( FieldPos("BE_MSBLQL") ) > 0
							If SBE->BE_MSBLQL == "1"
								aAdd( aIteSD3 , { StrZero(nLinha,7),'Armaz�m + Endere�o bloqueado: ' + AllTrim(cLocLin) + "-" + AllTrim(cEndLin) } )
							EndIf
						EndIf
					ElseIf SB1->B1_LOCALIZ = 'S'
						aAdd( aIteSD3 , { StrZero(nLinha,7),'Endere�o n�o informado' } )
					EndIf
				EndIf

				// D3_FILIAL + D3_COD + D3_LOCAL + D3_LOCALIZ
				// - Apontar Duplicidades
				If lCodLin
					If aScan(aChave,{|x| x == cFilLin + cCodLin + cLocLin + cEndLin }) > 0
						aAdd( aIteSD3 , { StrZero(nLinha,7),'Registro em duplicidade (Filial+C�digo+Armaz�m+Endere�o): ' + cFilLin + " - " + cCodLin + " - " + cLocLin + " - " + cEndLin } )
					Else
						aAdd( aChave , cFilLin + cCodLin + cLocLin + cEndLin )
					EndIf
				EndIf

			EndIf
		EndIf

		FT_FSKIP()

	EndDo

	FT_FUSE()

	If Len( aIteSD3 ) > 0
		MsgStop("Diverg�ncia nas Informa��es. Verifique Log ","Valida��o Carga SD3")
		cMsg	:= U_zGeraExc(aColSD3,aIteSD3,cArqExc,cPatSrv,cPatLoc,"Valida��o Carga SD3 - Diverg�ncia na Estrutura ")
	Else
		Aviso("Valida��o Carga SD3","Arquivo com Estrutura e Informa��es validados",{"Ok"})
	EndIf

	RestArea( aAreaSM0 )

Return