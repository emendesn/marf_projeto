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
Descricao / Objetivo:   validação de Estrutura/informações do arquivo de carga de saldos
Doc. Origem:            Contrato - GAP MGFIMP01
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Relacionado á Importação de Cadastros - Saldos Iniciais
=====================================================================================
*/

User Function MGFIMP02()


	Local aSays		:={}
	Local aButtons	:={}
	Local nOpca		:= 0


	// Inicializa o log de processamento
	// ProcLogIni( aButtons ) 
	AADD(aSays, 'Este programa tem como objetivo validar estrutura/informações de arquivo de saldos.') 
	AADD(aSays, 'Estrutura deve conter os campos:') 
	AADD(aSays, '	D3_FILIAL / D3_COD / D3_QUANT / D3_LOCAL / D3_CUSTO1 / D3_LOCALIZ') 
	AADD(aSays, 'Será feita validação das informações de todos os campos e gerado log com inconsistências')

	//AADD(aButtons, { 5,.T.,{|| Pergunte('XXX190',.T. ) } } ) 

	//AADD(aButtons, { 1,.T.,{|| nOpca:= 1, If( ProcOk(), FechaBatch(), nOpca:=0 ) }} ) 
	AADD(aButtons, { 1,.T.,{|| nOpca:= 1 , FechaBatch()  }} )
	AADD(aButtons, { 2,.T.,{|| FechaBatch() }} )  

	FormBatch( 'Validação de Carga - SD3', aSays, aButtons,, 220, 560 )

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

		MsgRun("Validação de arquivo SD3. Aguarde...",,{|| MGFIMP0201() })

	EndIf

Return

Static Function MGFIMP0201()

	Local cArq		:= ""
	Local cPatLoc	:= ""

	Local aColSD3	:= {"Linha","Ocorrência"}
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

	Private cPatSrv	:= GetMv("MGF_IMP02A",,"\MGF\IMP\VLDSD3\")				// Path de gravação de Arquivos Server

	// Abertura de Arquivos
	dbSelectArea("SB1")	// Descricao Generica do Produto 
	dbSetOrder(1)		// B1_FILIAL+B1_COD

	dbSelectArea("NNR")	// Locais de Estoque
	dbSetOrder(1)		// NNR_FILIAL+NNR_CODIGO

	dbSelectArea("SBE")	// Enderecos
	dbSetOrder(1)		// BE_FILIAL+BE_LOCAL+BE_LOCALIZ+BE_ESTFIS

	cArq := cGetFile("Todos os Arquivos|*.csv", OemToAnsi("Informe o diretório onde se encontra o arquivo."), 0, "SERVIDOR\", .F., GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE ,.T.)

	If !File(cArq)
		MsgStop("O arquivo " +cArq + " não foi selecionado. A validação será abortada!","ATENÇÃO")
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
		aAdd( aIteSD3 , { StrZero(nLinha,7),'Campo D3_FILIAL não informado no arquivo' } )
	EndIf

	If !";D3_COD;" $ cLinha
		aAdd( aIteSD3 , { StrZero(nLinha,7),'Campo D3_COD não informado no arquivo' } )
	EndIf

	If !";D3_QUANT;" $ cLinha
		aAdd( aIteSD3 , { StrZero(nLinha,7),'Campo D3_QUANT não informado no arquivo' } )
	EndIf

	If !";D3_LOCAL;" $ cLinha
		aAdd( aIteSD3 , { StrZero(nLinha,7),'Campo D3_LOCAL não informado no arquivo' } )
	EndIf

	If !";D3_CUSTO1;" $ cLinha
		aAdd( aIteSD3 , { StrZero(nLinha,7),'Campo D3_CUSTO1 não informado no arquivo' } )
	EndIf

	If !";D3_LOCALIZ;" $ cLinha
		aAdd( aIteSD3 , { StrZero(nLinha,7),'Campo D3_LOCALIZ não informado no arquivo' } )
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
			aAdd( aIteSD3 , { StrZero(nLinha,7),'Campo '+ AllTrim(cCampo) +' não pertence à tabela SD3' } )
		ElseIf !SX3->(dbSeek( cCampo ))
			aAdd( aIteSD3 , { StrZero(nLinha,7),'Campo '+ AllTrim(cCampo) +' não encontrado no dicionário' } )
		ElseIf ( SX3->X3_CONTEXT == "V" )
			aAdd( aIteSD3 , { StrZero(nLinha,7),'Campo '+ AllTrim(cCampo) +' marcado na tabela como virtual (X3_CONTEXT)' } )
		EndIf
	Next nI

	If Len( aIteSD3 ) > 0
		FT_FUSE()
		MsgStop("Divergência na Estrutura. Verifique Log ","Validação Carga SD3")
		cMsg	:= U_zGeraExc(aColSD3,aIteSD3,cArqExc,cPatSrv,cPatLoc,"Validação Carga SD3 - Divergência na Estrutura ")
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
				aAdd( aIteSD3 , { StrZero(nLinha,7),'Filial do arquivo não existe: ' + cFilArq } )
				Exit
			EndIf
		EndIf

		If Len(aDados) <> Len(aCampos)
			aAdd( aIteSD3 , { StrZero(nLinha,7),'Estrutura divergente do cabeçalho' } )
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
			//- Código Válido 
			//- Todos os códigos são da mesma filial

			If !SM0->( dbSeek(cEmpAnt+cFilLin) )
				aAdd( aIteSD3 , { StrZero(nLinha,7),'Filial não existe: ' + cFilLin } )
			Else
				If cFilArq	<> cFilLin
					aAdd( aIteSD3 , { StrZero(nLinha,7),'Filial '+cFilLin+' diferente da filial do arquivo: '+cFilArq } )
				EndIf	

				// D3_COD 
				// - Código Válido
				// - Bloqueio (B1_MSBLQL)
				lCodLin	:= .T.
				If !SB1->( dbSeek( xFilial("SB1",cFilArq) + cCodLin ) )
					aAdd( aIteSD3 , { StrZero(nLinha,7),'Produto não existe: ' + AllTrim(cCodLin) } )
					lCodLin	:= .F. 
				ElseIf SB1->( FieldPos("B1_MSBLQL") ) > 0
					If SB1->B1_MSBLQL == "1"
						aAdd( aIteSD3 , { StrZero(nLinha,7),'Produto bloqueado: ' + AllTrim(cCodLin) } )
					EndIf
				EndIf

				// D3_QUANT
				// - Valor > 0
				// - Valor < 999999999999.999 (Valor máximo aceito pelo campo)
				If nQtdLin <= 0 .Or. nQtdLin > 999999999999.999 
					aAdd( aIteSD3 , { StrZero(nLinha,7),'Quantidade inválida: ' + AllTrim(Str(nQtdLin)) } )
				EndIf

				// D3_LOCAL
				// - Código Válido
				// - Bloqueio (NNR_MSBLQL)
				If !NNR->( dbSeek( xFilial("NNR",cFilArq) + cLocLin ) )
					aAdd( aIteSD3 , { StrZero(nLinha,7),'Armazém não existe: ' + AllTrim(cLocLin) } )
				ElseIf NNR->( FieldPos("NNR_MSBLQL") ) > 0
					If NNR->NNR_MSBLQL == "1"
						aAdd( aIteSD3 , { StrZero(nLinha,7),'Armazém bloqueado: ' + AllTrim(cLocLin) } )
					EndIf
				EndIf

				// D3_CUSTO1
				// - Valor > 0
				// - Valor < 99999999999.99 (Valor máximo aceito pelo campo)
				If nCusLin <= 0 .Or. nCusLin > 99999999999.99 
					aAdd( aIteSD3 , { StrZero(nLinha,7),'Custo inválido: ' + AllTrim(Str(nCusLin)) } )
				EndIf

				// D3_LOCALIZ
				// - Código Válido
				// - Status (BE_STATUS) - 1=Desocupado;2=Ocupado;3=Bloqueado;4=Bloqueio Entrada;5=Bloqueio Saida;6=Bloqueio Inventario
				// - Bloqueio (BE_MSBLQL)
				lEndLin	:= .T.
				If lCodLin
					If SB1->B1_LOCALIZ = 'S' .And. !Empty(cEndLin)
						If !SBE->( dbSeek( xFilial("SBE",cFilArq) + cLocLin + cEndLin ) )
							aAdd( aIteSD3 , { StrZero(nLinha,7),'Armazém + Endereço não existe: ' + AllTrim(cLocLin) + "-" + AllTrim(cEndLin) } )
							lEndLin	:= .F.
						ElseIf SBE->BE_STATUS $ "34"
							aAdd( aIteSD3 , { StrZero(nLinha,7),'Armazém + Endereço - Status bloqueado: ' + AllTrim(cLocLin) + "-" + AllTrim(cEndLin) } )
						ElseIf SBE->( FieldPos("BE_MSBLQL") ) > 0
							If SBE->BE_MSBLQL == "1"
								aAdd( aIteSD3 , { StrZero(nLinha,7),'Armazém + Endereço bloqueado: ' + AllTrim(cLocLin) + "-" + AllTrim(cEndLin) } )
							EndIf
						EndIf
					ElseIf SB1->B1_LOCALIZ = 'S'
						aAdd( aIteSD3 , { StrZero(nLinha,7),'Endereço não informado' } )
					EndIf
				EndIf

				// D3_FILIAL + D3_COD + D3_LOCAL + D3_LOCALIZ
				// - Apontar Duplicidades
				If lCodLin
					If aScan(aChave,{|x| x == cFilLin + cCodLin + cLocLin + cEndLin }) > 0
						aAdd( aIteSD3 , { StrZero(nLinha,7),'Registro em duplicidade (Filial+Código+Armazém+Endereço): ' + cFilLin + " - " + cCodLin + " - " + cLocLin + " - " + cEndLin } )
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
		MsgStop("Divergência nas Informações. Verifique Log ","Validação Carga SD3")
		cMsg	:= U_zGeraExc(aColSD3,aIteSD3,cArqExc,cPatSrv,cPatLoc,"Validação Carga SD3 - Divergência na Estrutura ")
	Else
		Aviso("Validação Carga SD3","Arquivo com Estrutura e Informações validados",{"Ok"})
	EndIf

	RestArea( aAreaSM0 )

Return