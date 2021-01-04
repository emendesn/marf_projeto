#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "Rwmake.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"

/*
=====================================================================================
Programa.:              MGFZFUNA
Autor....:              Atilio Amarilla
Data.....:              28/02/2016
Descricao / Objetivo:   Funções genéricas
Doc. Origem:            Contrato - SHAPE
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Biblioteca de funções genéricas
=====================================================================================
zMakeDir( cPath , cTitulo )
- Criação de pastas usando MakeDir a partir de caminho completo (path)
=====================================================================================
zGeraExce(aColunas,aItens,cArqExc,cPatSrv,cPatLoc,cTitulo)
- Gera planilha excel
=====================================================================================
zLerTxt(cArqTxt)
- Ler arquivo txt e retornar conteudo do arquivo
=====================================================================================
zMontaView(cSql,cAliasTRB)
Executa query (select) e retorna número de registros da tabela de trabalho
=====================================================================================
Controle de Threads

zCriaThreads()
- Cria Arquivo Temporário para controle de threads

zSobeThreads(nNumThr)
- Verifica se nova thread pode ser aberta

zBaixaThreads(cArqThr)
- Informar fim do processamento da thread

=====================================================================================

*/

User Function MGFZFUNA()

Return
/*/{Protheus.doc} zMakeDir
Criação de pastas usando MakeDir a partir de caminho completo (path)
@param  	cPath -> Caminho completo a ser criado/verificado, pastas locais ou do server
cTitulo -> Titulo para uso em Aviso()
@author 	Atilio Amarilla
@version  	P11.8
@since  	02/03/2015
@return  	lRet-> Sucesso (.T.) ou Falha (.F.)
@obs
@project	Banco de Horas
@history	Acerto de rotinas IN12 e PP04. Uso de produto alternativo nos Kits
/*/

User Function zMakeDir( cPath , cTitulo )
	
	Local cAux := ""
	Local aAux, nI
	Local lRet := .T.
	Local aPath	:= StrToKArr(cPath,"\")
	
	If cTitulo == NIL
		cTitulo := "zMakeDir"
	EndIf
	
	For nI := 1 To Len( aPath )
		If nI == 1 .And. At(":",aPath[nI]) > 0
			aAux := Directory(aPath[nI]+"\*.*","D")
			cAux	:= aPath[nI]+"\"
			If Len( aAux ) == 0
				Aviso(cTitulo,"Verifique se nome de disco/pasta "+cAux+" é válido!",{'Ok'})
				lRet := .F.
				Exit
			EndIf
		ElseIf nI == 1 .And. Subs(cPath,1,2) == "\\"
			aAux := Directory("\\"+aPath[nI]+"*.*","D")
			cAux	:= "\\"+aPath[nI]+"\"
			/*
			If Len( aAux ) == 0
				Aviso(cTitulo,"Verifique se o endereço do servidor "+cAux+" é válido!",{'Ok'})
				lRet := .F.
				Exit
			EndIf
			*/
		Else
			If nI == 1
				cAux := "\"
			EndIf
			aAux := Directory(cAux+aPath[nI],"D")
			cAux += aPath[nI]+"\"
			If aScan(aAux,{|aAux|alltrim(aAux[1]) == aPath[nI] }) == 0
				If MakeDir( cAux ) > 0
					Aviso(cTitulo,"Verifique se nome de disco/pasta "+cAux+" é válido!",{'Ok'})
					lRet := .F.
					Exit
				EndIf
			EndIf
		EndIf
	Next nI
	
Return lRet

/*/{Protheus.doc} zGeraExcel
Gera planilha excel
@param  	aColunas -> Colunas da planilha
aItens -> Itens/Dados da planilha
cArqExc -> Nome arquivo a ser criado
cPatSrv -> Pasta do server para criação da planilha
cPatLoc -> Pasta local para copiar planilha
cTitulo -> Titulo da planilha
@author 	Atilio Amarilla
@version  	P11.8
@since  	02/03/2015
@return  	NIL
@obs
@project
@history
/*/

User Function zGeraExcel(aColunas,aItens,cArqExc,cPatSrv,cPatLoc,cTitulo)
	
	Local oExcel         := FWMSEXCEL():New()
	Local aLinha         := {}
	Local cWorkSheet     := cTitulo
	Local cTable         := cTitulo
	
	Local cLinhaXML      :=""
	Local nHXML
	Local cColXML        :=""
	
	Local oSay1
	Local oButtonOK
	Local oButtonCancela
	Local cTpSald
	
	local 	_lAll1       := .F.
	local 	_oOk         := LoadBitmap( GetResources(), "LBOK")
	local 	_oNo 	     := LoadBitmap( GetResources(), "LBNO")
	//Local bValid         := {|| Iif(ApOleClient("MsExcel"),.T.,(MsgAlert("MsExcel não instalado"),)) }
	Local nX, nY
	
	cPatSrv	:= IIF(cPatSrv==NIL,"",cPatSrv)
	cPatLoc	:= IIF(cPatLoc==NIL,"",cPatLoc) // GetTempPath()
	
	If !Empty(cPatSrv)
		If !FWMakeDir( cPatSrv , .T. )
			cPatSrv := ""
		EndIf
	EndIf
	
	If !Empty(cPatLoc)
		If !FWMakeDir( cPatLoc , .T. )
			cPatLoc := GetTempPath()
		EndIf
	Else
		cPatLoc := GetTempPath()
	EndIf
	
	
	//Cria Planilha
	oExcel:AddworkSheet(cWorkSheet)
	//Cria Tabela
	oExcel:AddTable (cWorkSheet,cTable)
	
	//Adiciona Colunas
	For nX := 1 to Len( aColunas )
		oExcel:AddColumn(cWorkSheet,cTable,aColunas[nX]		,1,1)
	Next nX
	
	For nX	:= 1 to Len( aItens )
		aLinha	:= {}
		For nY	:= 1 to Len( aItens[nx] )
			aAdd( aLinha , aItens[nX,nY] )
		Next nY
		oExcel:AddRow(cWorkSheet,cTable,aLinha)
	Next nX
	
	//%%%%%%%%%%%%%%%%%%   TODOS A ESTRUTURA MONTADA %%%%%%%%%%%%%%%%%%%%%%%%%
	//Ativa a planilha e deixa pronta para gerar arquivo.
	oExcel:Activate()
	
	oExcel:GetXMLFile(cPatSrv+cArqExc)
	
	If CpyS2T(cPatSrv+cArqExc,cPatLoc)
		//		 MsgInfo( "Arquivo " + cArq + " gerado com sucesso no diretório " + cPath )
		If ApOleClient("MsExcel")
			
			If !"X:" $ AllTrim(cPatLoc)
				oExcelApp := MsExcel():New()
				oExcelApp:WorkBooks:Open( cPatLoc + cArqExc )
				oExcelApp:SetVisible(.T.)              // Abre excel automaticamente .T. // Não .F.
			//		  oExcel:Destroy()                       // exclui Excel.exe do processo no gerenciador de tarefas
			EndIf
		Else
			Aviso("zGeraExcel","MsExcel não instalado"+CRLF+"Planilha "+cArqExc+" copiado para pasta "+cPatLoc+".",{'Ok'})
		EndIf
	else
		Aviso("zGeraExcel","Planilha "+cArqExc+" não copiado para pasta "+cPatLoc+"."+CRLF+"Verifique suas permissões.",{'Ok'})
	endif
	//   Endif
	
Return

/*/{Protheus.doc} zLerTxt
Ler arquivo txt e retornar conteudo do arquivo
@param  	cArqTxt -> Path + Nome do Arquivo
@author 	Atilio Amarilla
@version  	P11.8
@since  	10/03/2017
@return  	cRet -> Conteúdo do arquivo lido
@obs
@project	Banco de Horas
@history	Acerto de rotinas IN12 e PP04. Uso de produto alternativo nos Kits
/*/
User Function zLerTxt(cArqTxt)
	
	Local cRet := ""
	Local nHandle
	
	If !File( cArqTxt )
		cRet += "Arquivo Log não localizado: "+cArqTxt
	Else
		If nHandle := FT_FUSE(cArqTxt) > 0
			While !FT_FEOF()
				cRet += Ft_Freadln()
				
				FT_FSkip()
			EndDo
			
			FT_FUse()
		Else
			cRet += "Não foi possível abrir arquivo: "+cArqTxt
		EndIf
		
	EndIf
	
Return cRet

/*/{Protheus.doc} zMontaView
Executa query (select) e retorna número de registros da tabela de trabalho
@param  	cSql -> Expressão da query
cAlaisTRB -> Alias do arquivo de trabalho
@author 	Atilio Amarilla
@version  	P11.8
@since  	10/03/2017
@return  	nCnt -> Quantidade de registros selecionados
@obs
@project	Banco de Horas
@history	Acerto de rotinas IN12 e PP04. Uso de produto alternativo nos Kits
/*/
User Function zMontaView( cSql, cAliasTRB )
	
	Local nCnt := 0
	Local cSql := ChangeQuery( cSql )
	
	If Select(cAliasTRB) > 0           // Verificar se o Alias ja esta aberto.
		DbSelectArea(cAliasTRB)        // Se estiver, devera ser fechado.
		(cAliasTRB)->( DbCloseArea() )
	EndIf
	
	DbUseArea( .T., "TOPCONN", TcGenQry(,,cSql), cAliasTRB, .T., .F. )
	DbSelectArea(cAliasTRB)
	DbGoTop()
	
	DbEval( {|| nCnt++ })              // Conta quantos sao os registros retornados pelo Select.
	
	DbSelectArea(cAliasTRB)
	DbGoTop()
	
Return( nCnt )


/*/{Protheus.doc} zCriaThreads
Cria Arquivo Temporário para controle de threads
@param  	NIL
@author 	Atilio Amarilla
@version  	P11.8
@since  	10/03/2017
@return  	cArqThr -> Nome do arquivo criado
@obs
@project	Banco de Horas
@history	Acerto de rotinas IN12 e PP04. Uso de produto alternativo nos Kits
/*/
User Function zCriaThreads()
	
	Local __aStrut	:= { { "REG","N",10,0 } }
	Local cArqThr 	:= CriaTrab( __aStrut , .T. )
	
	// Acessar o arquivo e coloca-lo na lista de arquivos abertos.
	dbUseArea( .T., __LocalDriver, cArqThr, "THREADS" , .T. , .F. )
	
	RecLock("THREADS",.T.)
	THREADS->( msUnlock() )
	
Return cArqThr

/*/{Protheus.doc} zSobeThreads
Verifica se nova thread pode ser aberta
@param  	nNumThr -> Número máximo de threads permitidas
@author 	Atilio Amarilla
@version  	P11.8
@since  	10/03/2017
@return  	lRet -> .T. para permitir nova thread
@obs
@project	Banco de Horas
@history	Acerto de rotinas IN12 e PP04. Uso de produto alternativo nos Kits
/*/
User Function zSobeThreads(nNumThr)
	
	Local lRet := .F.
	
	DEFAULT nNumThr	:= 100
	dbSelectArea("THREADS")
	THREADS->( DbGoBottom() ) // Refresh()
	
	If THREADS->REG < nNumThr
		While !THREADS->( RecLock("THREADS",.f.) )
		EndDo
		
		THREADS->REG += 1
		THREADS->( MsUnLock() )
		lRet := .T.
	EndIf
	
Return lRet

/*/{Protheus.doc} zBaixaThreads
Informar fim do processamento da thread
@param  	cArqThr -> Arquivo de controle de threads
@author 	Atilio Amarilla
@version  	P11.8
@since  	10/03/2017
@return  	NIL
@obs
@project	Banco de Horas
@history	Acerto de rotinas IN12 e PP04. Uso de produto alternativo nos Kits
/*/
User Function zBaixaThreads(cArqThr)
	
	If Select("THREADS") == 0
		// Acessar o arquivo e coloca-lo na lista de arquivos abertos.
		dbUseArea( .T., __LocalDriver, cArqThr, "THREADS" , .T. , .F. )
		Conout("THREADS")
	EndIf
	
	THREADS->( DbGoTop() ) // Refresh()
	
	While !THREADS->( RecLock("THREADS",.f.) )
		Conout("NORECLOCK-THREADS")
	EndDo
	
	//THREADS->( RecLock("THREADS",.f.) )
	THREADS->REG -= 1
	THREADS->( MsUnLock() )
	
Return

/*/{Protheus.doc} zNumThread
Retorna número de threads abertas
@param  	cFunName -> Funções a considerar na contagem de threads
@author 	Atilio Amarilla
@version  	P12
@since  	03/04/2017
@return  	lRet -> nQtdThread (número de threads ativas)
@obs
@project	Banco de Horas
@history	Acerto de rotinas IN12 e PP04. Uso de produto alternativo nos Kits
/*/
User Function zNumThread(cFunName,cSubObs,lJob)
	
	Local nQtdThread	:= 0
	Local aThreads		:= GetUserInfoArray()
	Local _nQ			:= 0
	Local nLenThreads	:= Len(aThreads)
	
	// Variável permite 2o. critério de seleção, substring do campo observação GetUserInfoArray()[11]
	DEFAULT cSubObs	:= ""

	default lJob	:= .F.

	If Empty( cFunName )
		nQtdThread := nLenThreads
	Else
		For _nQ := 1 To nLenThreads
			if !lJob
				If Upper(AllTrim(aThreads[_nQ,5])) $ cFunName .And. IIf(!Empty(cSubObs),cSubObs$aThreads[_nQ,11],.T.)
					nQtdThread++
				EndIf
			elseif lJob
				If cFunName $ Upper(AllTrim(aThreads[_nQ,11])) .And. IIf(!Empty(cSubObs),cSubObs$aThreads[_nQ,11],.T.)
					nQtdThread++
				EndIf
			endif
		Next _nQ
	EndIf
	
Return nQtdThread

/*/{Protheus.doc} zMonThread
Monitoramneto de Threads. Retorna informações de threads abertas. 
@param  	cFunName -> Funções a considerar na contagem de threads
@author 	Atilio Amarilla
@version  	P12
@since  	03/04/2017
@return  	aRet ->	nQtdThread (número de threads ativas)
					nMemThread (quantidade de memória consumida pela aplicação appserver)
@obs
@project	Banco de Horas
@history	Acerto de rotinas IN12 e PP04. Uso de produto alternativo nos Kits
/*/
User Function zMonThread(cFunName,cSubObs)
	
	Local nQtdThread	:= 0
	Local nMonThread	:= 0
	Local aThreads		:= GetUserInfoArray()
	Local _nQ			:= 0
	Local nLenThreads	:= Len(aThreads)
	
	// Variável permite 2o. critério de seleção, substring do campo observação GetUserInfoArray()[11]
	DEFAULT cFunName	:= ""
	DEFAULT cSubObs		:= ""
	
	If Empty( cFunName ) .And. Empty( cSubObs ) 
		nQtdThread := nLenThreads
		For _nQ := 1 To nLenThreads
			If aThreads[_nQ,12] > 0
				nMonThread += aThreads[_nQ,12]
			EndIf 				
		Next _nQ
	Else
		For _nQ := 1 To nLenThreads
			If IIf(!Empty(cFunName),Upper(AllTrim(aThreads[_nQ,5])),.T.) $ cFunName .And. IIf(!Empty(cSubObs),cSubObs$aThreads[_nQ,11],.T.)
				nQtdThread++
			EndIf
			If aThreads[_nQ,12] > 0
				nMonThread += aThreads[_nQ,12]
			EndIf 				
		Next _nQ
	EndIf
	
Return( { nQtdThread , nMonThread } ) 

/*/{Protheus.doc} zGravaLog
Gravação de arquivo texto (LOG)
@param  	cLogFile -> Nome do Arquivo (Path + Nome)
@param  	cMsg -> Conteúdo a gravar no arquivo
@author 	Atilio Amarilla
@version  	P12
@since  	05/04/2017
@return  	NIL
@obs
@project	Banco de Horas
@history	Acerto de rotinas IN12 e PP04. Uso de produto alternativo nos Kits
/*/
User Function zGravaLog(cLogFile,cMsg)
	
	If !File(cLogFile)
		nH := FCreate(cLogFile)
	Else
		nH := FOpen(cLogFile,1)
	EndIf
	
	FSeek(nH,0,2)
	FWrite(nH,cMsg+CRLF,Len(cMsg)+2)
	FClose(nH)
	
Return



/*/{Protheus.doc}
============================================================
Valida digito verificador
@param  	CAEPF -> Nome do Arquivo (Path + Nome)
@author 	Natanael Filho
@version  	P12
@since  	22/05/2019
@return  	Bolean
@obs
@project	Dev interno
@history	US: 33994 / Service Now: RITM0020478
===============================================================
/*/
/*
Cálculo do Dígito Verificador: 
"No caso do CAEPF, o DV módulo 11 corresponde ao resto da divisão por 11 do somatório da multiplicação de cada algarismo da base respectivamente por 9, 8, 7, 6, 5, 4, 3, 2, 9, 8, 7, 6 e 5, a partir da unidade. O resto 10 é considerado 0. Veja, abaixo, exemplo de cálculo de DV módulo 11 para o CAEPF nº 293118610001:

2  9  3  1  1  8  6  1  0  0  0  1 = 7
x  x   x  x  x  x   x  x  x  x  x   x
6  7  8  9  2  3  4  5  6  7  8  9
-----------------------------------
12+63+24+ 9+ 2+24+24+ 5+ 0+ 0+ 0+ 9 = 172÷11=15, com resto 7

2  9  3  1  1  8  6  1  0  0  0  1  7 = 2
x  x   x  x  x  x   x  x  x  x   x  x  x
5  6  7  8  9  2  3  4  5  6  7  8  9
--------------------------------------
10+54+21+ 8+ 9+16+18+ 4+ 0+ 0+ 0+ 8+63 = 211÷11=19, com resto 2

Portanto, o CAEPF+DV seria 293.118.610/001-72. Mas há um senão: o método
de cálculo estaria somando 12 ao DV encontrado. E se o resultado da soma
for maior do que 99, diminui-se 100. No exemplo, o DV será 72+12=84. "
*/

User Function zValCAEPF(cCAEPF)

	Local lRet := .F.
	Local aDgs := {}
	Local _nCount := 0
	Local nDVOri		 		//Digitos Verificador enviado
	Local nDV1Calc := 0 		//Primeiro Digito Verificador Calculado
	Local nDV2Calc := 0 		//Segundo Digito Verificador Calculado
	Local nDVFCalc := 0 		//Digito Verificador Calculado Final
	Local nSum	:= 0			//Somatório
	Local nMult	:= 9			//Multiplicador
	
	Local cTitHelp		:= "Validacao do Digito" //Título para o help
	Local cPrbHelp		:= "Digito verificador incorreto." //Descrição do problema do help
	Local cSolHelp		:= "Revise o valor digitado. Deve ser um CAEPF valido." //Descrição do problema do help		
	
	cCAEPF := Alltrim(cCAEPF)
	
	If Len(cCAEPF) = 14
		//Separa os digitos verificadores
		nDVOri := Val(SubStr(cCAEPF,13,2))
		
		//Separa os digitos em Array, apenas os primeiros 12 digitos, sem os digitos verificadores
		For _nCount := 1 to 12
			aAdd(aDgs,Val(Substr(cCAEPF,_nCount,1)))
		Next
		
		//Calcula o primeiro digito
		For _nCount := Len(aDgs) to 1 step -1
			nSum += aDgs[_nCount] * nMult
			IIf(nMult = 2,nMult := 9,nMult--)		//O multiplicador não teve ser menor que 2
		Next
		
		nDV1Calc := IIf(Mod(nSum, 11) = 10, 0, Mod(nSum, 11))			//O resto 10 é considerado 0.
		
		
		//Calcula o segundo digito
		aAdd(aDgs,nDV1Calc)							// Adiciona o primeiro digito ao final para calculo do segundo
		nSum := 0; nMult:= 9 						// Reinicia os valores para calculo
		For _nCount := Len(aDgs) to 1 step -1
			nSum += aDgs[_nCount] * nMult
			IIf(nMult = 2,nMult := 9,nMult--)		//O multiplicador não teve ser menor que 2	
		Next
		
		nDV2Calc := IIf(Mod(nSum, 11) = 10, 0, Mod(nSum, 11))			//O resto 10 é considerado 0.
		
		//Validacao final do digito verificador
		nDVFCalc := Val(Alltrim(Str(nDV1Calc))+Alltrim(Str(nDV2Calc)))
		nDVFCalc += 12								// O método de cálculo deve somar 12 ao DV encontrado. 
		nDVFCalc := IIf(nDVFCalc > 100, nDVFCalc - 100, nDVFCalc) //Se o resultado da soma for maior do que 99, diminui-se 100.
		
		lRet:= IIF(nDVOri = nDVFCalc, .T., .F.)
		
	EndIf
	
	If !lRet
		Help( ,, cTitHelp, , cPrbHelp, 1, 0, , , , , , {cSolHelp})
	EndIf
		
	
		
Return lRet

/*{Protheus.doc}
============================================================
Adiciona Dias uteis a uma Data
@param  	dDtAtual -> Data inicial
			nDiasUteis -> Quantidade de dias uteis que serão somados
@author 	Natanael Filho
@version  	P12
@since  	03/06/2019
@return  	dDtFinal -> Dia útil final
@obs
@project	Dev interno
@history	US: 33994 / Service Now: RITM0020478
===============================================================
*/

User Function zSumDiaUti(dDtAtual,nDiasUteis)

	Local dDtFinal := dDtAtual
	Local _nCount := 0
	
	Default dDtAtual := dDataBase
	Default nDiasUteis := 1

	
	While _nCount < nDiasUteis
		dDtFinal := DaySum(dDtFinal,1)
		dDtFinal := DataValida(dDtFinal,.T.) //Verifica se o dia é útil
		_nCount++
	EndDo
		
Return dDtFinal

/*
=====================================================================================
Programa.:              ECAEPF
Autor....:              ROBERTO R.MEZZALIRA
Data.....:              30/12/2019
Descricao / Objetivo:   GERA O CODIGO CAEPF PARA O CAMPO A2_ZCAEPF
Doc. Origem:
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Biblioteca de funções genéricas
=====================================================================================
*/
User Function ECAEPF()
Local _cCaepf   := ''
Local _cAliacae := GetNextAlias()
Local _cAliaSa2 := GetNextAlias()
Local _cAliaRod := GetNextAlias()
Local _cSEQ     := 0
Local _nX       := 0
Local aDgs      := {}
Local nSum      := 0
Local nMult     := 9
Local _cCPF     := ''
Local _cCodFav  := ''
Local _cLojFav  := ''

Local _cForn    := M->A2_COD 	
Local _cLoja    := M->A2_LOJA 	
Local _cTipo    := M->A2_TIPO 	
Local _cTPessoa := M->A2_TPESSOA 
Local _cUf		:= M->A2_EST 	
Local _cGrpTrib := M->A2_GRPTRIB
Local _cNomeFor := ALLTRIM(M->A2_NOME)
Local _cTiporur := M->A2_TIPORUR
Local _cXCaepf	:= M->A2_ZCAEPF
Local _cCcgc    := M->A2_CGC
	
If _cUf == "SP"  .And. _cTipo == "J" .And. _cTPessoa == "PF" .And. _cGrpTrib == "FPM"  .And. _cTiporur == "F"

	_cCPF := M->A2_CGC
	
	IF INCLUI
		BeginSql Alias _cAliaRod
				SELECT A2_COD,A2_LOJA,A2_NOME,A2_CGC
				FROM %Table:SA2% SA2
				WHERE
				SA2.A2_FILIAL = %xFilial:SA2% AND
				SA2.A2_CGC  = %EXP:_cCcgc %  AND
				SA2.A2_LOJA = '01' AND
				SA2.%notdel%
		EndSql			
		(_cAliaRod)->(DbGoTop())
		_cForn 	  := (_cAliaRod)->A2_COD
		_cNomeFor := (_cAliaRod)->A2_NOME
	ENDIF
	
	If SZA->(DbSeek(xFilial("SZA")+_cForn+"01")) //Sempre pesquisa na loja
			_cCodFav := SZA->ZA_CODFAV
			_cLojFav := SZA->ZA_LOJFAV
			BeginSql Alias _cAliaSa2
				SELECT A2_COD,A2_LOJA,A2_NOME,A2_CGC
				FROM %Table:SA2% SA2
				WHERE
				SA2.A2_FILIAL = %xFilial:SA2% AND
				SA2.A2_COD  = %EXP:_cCodFav %  AND
				SA2.A2_LOJA = %EXP:_cLojFav %  AND
				SA2.%notdel%
			EndSql			
		If  Alltrim((_cAliaSa2)->A2_NOME) == Alltrim(_cNomeFor) //Compara Nome do favorecido com Nome do fornecedorf
				_cCpf := (_cAliaSa2)->A2_CGC			// CPF | CNPJ Favorecido
		Else
				MsgInfo("Nome do favorecido diferente do nome do fornecedor.","Atenção !!!")
				Return(_cXCaepf)
		EndIf
	Else
		MsgInfo("Não foi localizado o cadastro do favorecido.","Atenção !!!")
		Return(_cXCaepf)
	EndIf
ElseIf !_cUf $ "SP|EX"
	If _cTPessoa == "PF" .And. _cTiporur = "J"
		_cCPF := M->A2_CGC
	ELSE
		MsgInfo("Fornecedor fora do estado, Tipo Pessoa diferente de física e Tipo Contr.Soc diferente de Jurídico.","Atenção !!!")
		Return(_cXCaepf)
	ENDIF
ENDIF

_cCPF := ALLTRIM(_cCPF)

BeginSql Alias _cAliacae
	SELECT  A2_COD,A2_LOJA
	FROM %Table:SA2% SA2
	WHERE
	SA2.A2_FILIAL = %xFilial:SA2% AND
	SA2.A2_CGC    = %EXP:_cCcgc %  AND
	SA2.%notdel%
	ORDER BY SA2.A2_FILIAL,SA2.A2_COD,SA2.A2_LOJA
EndSql

(_cAliacae)->(DbGoTop())

While ! (_cAliacae)->(EOF())

	IF (_cAliacae)->A2_LOJA <> '01'
		_cSEQ++
	ENDIF

	(_cAliacae)->(DBSKIP())

ENDDO

IF _cSEQ > 0
	_cSEQ++
EndIf

_cCaepf := SUBSTR(_cCPF,1,9)+STRZERO(_cSEQ,3,0)

For _nX := 1 to 12
	aAdd(aDgs,Val(Substr(_cCaepf ,_nX,1)))
Next _nX

//Calcula o primeiro digito
For _nX := Len(aDgs) to 1 step -1
	nSum += aDgs[_nX] * nMult
	IIf(nMult = 2,nMult := 9,nMult--)                   //O multiplicador não deve ser menor que 2
Next _nX

nDV1Calc := IIf(Mod(nSum, 11) = 10, 0, Mod(nSum, 11))   //O resto 10 é considerado 0.

//Calcula o segundo digito
aAdd(aDgs,nDV1Calc)                                                                                                  // Adiciona o primeiro digito ao final para calculo do segundo

nSum := 0
nMult:= 9                                                                                    // Reinicia os valores para calculo

For _nX := Len(aDgs) to 1 step -1
	nSum += aDgs[_nX] * nMult
	IIF(nMult = 2,nMult := 9,nMult--)                  //O multiplicador não teve ser menor que 2
Next _nX

nDV2Calc := IIf(Mod(nSum, 11) = 10, 0, Mod(nSum, 11))  //O resto 10 é considerado 0.

//Validacao final do digito verificador
nDVFCalc := Val(Alltrim(Str(nDV1Calc))+Alltrim(Str(nDV2Calc)))
nDVFCalc += 12 // O método de cálculo deve somar 12 ao DV encontrado.
nDVFCalc := IIF( nDVFCalc > 100, nDVFCalc - 100, nDVFCalc ) //Se o resultado da soma for maior do que 99, diminui-se 100.
_cCaepf  := _cCaepf+STRZERO(nDVFCalc,2,0)

If Len(Alltrim(_cCaepf))< 14 .Or. Alltrim(_cCaepf)='99999999999999'
	_cCaepf := ' '
EndIf

Return (_cCaepf)


/*{Protheus.doc}
============================================================
Carrega o ultimo dia do mês
@param  	nMes -> Mês da data solicitada
@author 	Paulo da Mata
@version  	P12
@since  	03/03/2020
@return  	cUltDia -> Ultimo dia do MÊS
@obs
@project	Dev interno
@history	Service Now: RTASK0010577
============================================================
*/
User Function fUltDMes(nMes)

	Local cMes    := AllTrim(StrZero(nMes,2))
	Local cUltDia := Space(02)

	If     cMes $ "01/03/05/07/08/10/12"
    	   cUltDia := "31"
	ElseIf cMes $ "04/06/09/11"
    	   cUltDia := "30"
	ElseIf cMes == "02"	
    	   cUltDia := "28"
	EndIf

Return(cUltDia)

/*
@description 
	Rotina genêrica para envio de e-mail. Modelo SEND MAIL - EXEMPLO NA ROTINA MGFFINBL
@author Henrique Vidal Santos
@Type Relatório
@since 20/03/2020
@version P12.1.017
*/
User Function MGFEMAIL(_cTitulo,_cMsg,_cEmail,cCopia,_cAnexo,lAvsUser,cMail)

	Local lEnvio  	:= .F.
	Local _nCont  	:= 0

	Private cSrv  	:= GETMV("MGF_SMTPSV") + ':' + Alltrim(cValtoChar(GETMV("MGF_PTSMTP")))	// Servidor Smtp
	Private cPass 	:= Alltrim(GETNEWPAR("MV_RELPSW",""))       							// Senha
	Private lAuth   := Alltrim(GETNEWPAR('MV_RELAUTH',.F.))									// Autentica e-mail ?
	Default cCopia	:= ''	
	Default cMail 	:= Alltrim(GETNEWPAR("MGF_EMAIL","totvs.any@marfrig.com.br")) 			// email@dominio.com.br
	Default lAvsUser := .T.  										// Notiffica o usuario sobre o email enviado ?

	CONNECT SMTP SERVER cSrv;
	ACCOUNT cMail;
	PASSWORD cPass;
	RESULT lResult

	If !Empty(cPass) .And. lAuth
		lOk := MailAuth(cMail,cPass)

		If !lOk
			lOk := QAGetMail()
		EndIf
	EndIf 

	Do Case 
		Case _cAnexo <> Nil
			SEND MAIL FROM cMail TO _cEmail CC cCopia SUBJECT _ctitulo BODY _cMsg ATTACHMENT _cAnexo RESULT lEnvio
		Otherwise
			SEND MAIL FROM cMail TO _cEmail CC cCopia SUBJECT _ctitulo BODY _cMsg RESULT lEnvio
	EndCase

	If lEnvio 
		If lAvsUser
			Alert("E-mail enviado com sucesso "+If(!Empty(_cEmail),"("+_cEmail+")",""))
		Endif
	Else
		GET MAIL ERROR cError
		ApMsgInfo( "Falha no envio do e-mail" + " - " + cError + " " + _cEmail )  
	Endif

	DISCONNECT SMTP SERVER

Return(lEnvio)

/*
@description 
	Rotina genêrica para Acerto de Acento
@author Rodrigo Franco de Souza
@Type Relatório
@since 02/04/2020
@version P12.1.017
*/
User Function SAcento(_cPedCli)

LOCAL _cFrase := ""

_cFrase := NoAcento(_cPedCli)
_cFrase := strtran(_cFrase,"º","")
_cFrase := strtran(_cFrase,"%","")
_cFrase := strtran(_cFrase,"*","")     
_cFrase := strtran(_cFrase,"&","")
_cFrase := strtran(_cFrase,"$","")
_cFrase := strtran(_cFrase,"#","")
_cFrase := strtran(_cFrase,"§","")
_cFrase := strtran(_cFrase,"ä","a")
_cPedCli := StrTran(_cFrase, " ", "")

return(_cPedCli)