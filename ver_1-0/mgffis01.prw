#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
=====================================================================================
Programa.:              MGFFIS01
Autor....:              Luis Artuso
Data.....:              07/10/16
Descricao / Objetivo:   Chamada da rotina principal
Doc. Origem:            Contrato - GAP FIS33
Solicitante:            Cliente
Uso......:              
Obs......:
=====================================================================================
*/
User Function MGFFIS01

	Local cType		:= ""
	Local cArquivo	:= ""
	Local cTitulo01	:= ""
	Local cTitulo02	:= ""
	Local cArq01	:= ""
	Local cArq02	:= ""
	Local cArq03	:= ""
	Local cDirIni	:= ""
	Local cManadRHE	:= "" //Este parametro indica o diretorio padrao para localizacao do arquivo manad gerado pelo RH Evollution
	Local cManadPro	:= "" //Este parametro indica o diretorio padrao para localizacao do arquivo manad gerado pelo Protheus
	Local cDirDest	:= "" //Diretorio sugerido para gravacao do arquivo apos 'merge'.
	Local cExtensao	:= "" //Extensao para geracao
	Local lKeepCase	:= .T.
	Local lArvore	:= .T.
	Local lSalvar	:= .T.
	Local nDialogX	:= 0
	Local nDialogY	:= 0
	Local nTamFonte	:= 0
	Local nLin01	:= 0
	Local nLin02	:= 0
	Local nLabelIni	:= 0
	Local nLabelFim	:= 0
	Local nPosFim	:= 0
	Local nSizeX01	:= 0
	Local nSizeX02	:= 0
	Local nMascPad	:= 0
	Local oSay01
	Local oSay02
	Local oSay03
	Local oSay04
	Local oSay05
	Local oSay06
	Local oDlg
	Local oFont01
	Local oFont02
	Local oButton01
	Local oButton02
	Local oButton03
	Local oButton04
	Local oButton05
	Local oButton06

	cManadPRO	:= SuperGetMv('MGF_ARQPRO' , NIL , 'C:\')

	cManadRHE	:= SuperGetMv('MGF_ARQRHE' , NIL , 'C:\')

	cDirDest	:= SuperGetMv('MGF_ARQDES' , NIL , 'C:\')

	cExtensao	:= ".TXT"

	cType		:= "Todos Arquivos|*.*|Arquivo TXT|*.TXT"
	nMascPad	:= 0

	nTamFonte	:= 15

	nDialogX	:= 430
	nDialogY	:= 900

	DEFINE FONT oFont01 NAME "ARIAL" SIZE 1,nTamFonte BOLD
	DEFINE FONT oFont02 NAME "CREEPY" SIZE 10,nTamFonte BOLD

	nLabelIni	:= 212
	nLabelFim	:= nDialogY / 2

	DEFINE MSDIALOG oDlg TITLE "Geracao Customizada do arquivo - MANAD" FROM 000 , 000  TO nDialogX , nDialogY COLORS 0, 16777215 PIXEL

		@ 004 , 003 TO nLabelIni , nLabelFim LABEL "Geracao customizada do arquivo MANAD" PIXEL OF oDlg

//------- Botao 01

		nLin01		:= 18

		cTitulo01	:= OemToAnsi("Indique a localizacao do arquivo MANAD (PROTHEUS) : ")

		@ nLin01 , 008 SAY oSay01 PROMPT " Informe o arquivo MANAD (PROTHEUS) " SIZE 150, 070 OF oDlg COLORS 0, 16777215 PIXEL FONT oFont01

		@ nLin01 , 160 BUTTON oButton01 PROMPT "Pesquisar" SIZE 037 , 015 OF oDlg PIXEL ACTION ;
			cArq01	:= fManagFile(cType , @cArquivo , cTitulo01 , nMascPad , cManadPRO , lKeepCase  , lArvore , lSalvar)

		nLin01 += 2

		nPosFim		:= 200

		nSizeX01	:= 300

		nSizeX02	:= 70

		@ nLin01 , nPosFim SAY oSay02 PROMPT cArq01 SIZE nSizeX01 , nSizeX01 OF oDlg COLORS CLR_RED , CLR_BLACK PIXEL FONT oFont02

//------- Botao 02

		nLin02		:= 43

		cTitulo02	:= OemToAnsi("Indique a localizacao do arquivo MANAD (RHEVOLUTION): ")

		@ nLin02 , 008 SAY oSay03 PROMPT " Informe o arquivo MANAD (RHEVOLUTION) " SIZE 150, 070 OF oDlg COLORS 0, 16777215 PIXEL FONT oFont01

		@ nLin02 , 160 BUTTON oButton02 PROMPT "Pesquisar" SIZE 037, 015 OF oDlg PIXEL ACTION ;
			cArq02	:= fManagFile(cType , @cArquivo , cTitulo02 , nMascPad , cManadRHE , lKeepCase , lArvore , lSalvar)

		nLin02 += 2

		@ nLin02 , nPosFim SAY oSay04 PROMPT cArq02 SIZE nSizeX01, nSizeX02 OF oDlg COLORS CLR_RED , CLR_BLACK PIXEL FONT oFont02

//------- Botao 03

		nLin03		:= 70

		lSalvar		:= .F.

		cTitulo03	:= "Selecione o arquivo de saida"

		@ nLin03 , 008 SAY oSay05 PROMPT " Informe o arquivo de Saida : " SIZE 150, 070 OF oDlg COLORS 0, 16777215 PIXEL FONT oFont01

		@ nLin03 , 160 BUTTON oButton03 PROMPT "Pesquisar" SIZE 037, 015 OF oDlg PIXEL ACTION ;
			cArq03	:= fManagFile(cType , @cArquivo , cTitulo03 , nMascPad , cDirDest , lKeepCase , lArvore , lSalvar)

		nLin03 += 2

		@ nLin03 , nPosFim SAY oSay06 PROMPT cArq03 SIZE nSizeX01 , nSizeX02 OF oDlg COLORS CLR_RED , CLR_BLACK PIXEL FONT oFont02

//----------- Botao 04

		nLin04		:= 190

		nPosFim02	:= 310

		nSizeX01	:= 45

		nSizeY01	:= 20

		@ nLin04 , nPosFim02 BUTTON oButton04 PROMPT "&Cancela Selecao" SIZE nSizeX01 , nSizeY01 OF oDlg PIXEL ACTION fLimpaSel(@cArq01 , @cArq02 , @cArq03)

//----------- Botao 05

		nLin04		:= 190

		nPosFim03	:= 360

		@ nLin04 , nPosFim03 BUTTON oButton05 PROMPT "&Gera Manad" SIZE nSizeX01 , nSizeY01 OF oDlg PIXEL ACTION fGeraManad(cArq01 , cArq02 , cArq03)

//----------- Botao 06

		nLin04		:= 190

		nPosFim04	:= 410

		@ nLin04 , nPosFim04 BUTTON oButton06 PROMPT "&Encerra" SIZE 038, 20 OF oDlg PIXEL ACTION oDlg:End()

	ACTIVATE MSDIALOG oDlg CENTERED

Return

/*
=====================================================================================
Programa.:              fManagFile
Autor....:              Luis Artuso
Data.....:              06/10/16
Descricao / Objetivo:   Rotina para gerenciamento de arquivos. Permite selecionar/salvar os arquivos conforme parametros enviados.
Doc. Origem:            Contrato - GAP FIS33
Solicitante:            Cliente
Uso......:              
Obs......:
=====================================================================================
*/
Static Function fManagFile(	cType ,;		// Indica os arquivos que podem ser filtrados
							cArquivo ,;		// Arquivo Retorno
							cTitulo ,;		// Titulo da janela
							nMascPad ,;		// Mascara Padrao
							cDirIni ,;		// Diretorio inicial
							lKeepCase ,;	// Indica se, verdadeiro (.T.), mantem o case original; caso contrario, falso (.F.).
							lArvore ,;		// Indica se, verdadeiro (.T.), apresenta o arvore do servidor; caso contrario, falso (.F.).
							lSalvar;		// Informa para a rotina se permite apenas a selecao ou salva em um determinado local. '.T.' -> Abre , '.F.' -> Salva
						)

	cArquivo	:= cGetFile(cType,;
							cTitulo,;
							nMascPad,;
							cDirIni,;
							lSalvar,;
							GETF_NETWORKDRIVE+GETF_LOCALHARD+GETF_LOCALFLOPPY,;
							lArvore,;
							lKeepCase)

	cArqRet	:= cArquivo

Return cArqRet


/*
=====================================================================================
Programa.:              fLimpaSel
Autor....:              Luis Artuso
Data.....:              10/10/16
Descricao / Objetivo:   Elimina o conteudo das variaveis que armazenam os arquivos de origem/destino do MANAD
Doc. Origem:            Contrato - GAP FIS33
Solicitante:            Cliente
Uso......:              
Obs......:
=====================================================================================
*/

Static Function fLimpaSel(	cArq01 ,;
							cArq02 ,;
							cArq03;
						 )

	cArq01	:= ""
	cArq02	:= ""
	cArq03	:= ""

Return

/*
=====================================================================================
Programa.:              fGeraManad
Autor....:              Luis Artuso
Data.....:              10/10/16
Descricao / Objetivo:   Agrupa os arquivos informados e gera o arquivo destino
Doc. Origem:            Contrato - GAP FIS33
Solicitante:            Cliente
Uso......:              
Obs......:
=====================================================================================
*/
Static Function fGeraManad(cArq01 , cArq02 , cArq03)

	Local cTmp01	:= ""
	Local cTmp02	:= ""
	Local oTempTable
	Local lProcessa	:= .T.


	If (Empty(cArq01))

		lProcessa	:= .F.

		MsgAlert('O arquivo MANAD origem referente ao RHEvolution nao foi selecionado.')

	EndIf

	If (Empty(cArq02))

		lProcessa	:= .F.

		MsgAlert('O arquivo MANAD origem referente ao Protheus nao foi selecionado.')

	EndIf


	If (Empty(cArq03))

		lProcessa	:= .F.

		MsgAlert('O arquivo destino nao foi informado.')

	EndIf

	If ( lProcessa )

		cTmp01	:= GetNextAlias()
		cTmp02	:= GetNextAlias()

		fCriaTmp(cTmp01 , cTmp02 , @oTempTable)

		Processa({|| fAppend(cTmp01 , cTmp02 , cArq01 , cArq02 , cArq03 , oTempTable)} , "Aguarde...", "Gerando Merge do arquivo Manad ...",.F.)

		MsgAlert('Arquivo Manad gerado na pasta : ' + cArq03 )

		(cTmp01)->(dbCloseArea())

		(cTmp02)->(dbCloseArea())

		oTempTable:Delete()

	EndIf

Return

/*
=====================================================================================
Programa.:              fCriaTmp
Autor....:              Luis Artuso
Data.....:              11/10/16
Descricao / Objetivo:   Cria os arquivos temporarios para append
Doc. Origem:            Contrato - GAP FIS33
Solicitante:            Cliente
Uso......:              
Obs......:
=====================================================================================
*/
Static Function fCriaTmp(	cTmp01,; // Arquivo Temporario para append (rh evollution)
							cTmp02,; // Arquivo Temporario para append (Protheus)
							oTempTable; // Objeto para criacao das tabelas temporarias
						)

	Local aStruct	:= {}

	AADD(aStruct,{"CAMPO01","C",500,0})
	AADD(aStruct,{"CAMPO02","C",1,0})

	//-Cria o 1 arq. temporario

	oTempTable := FWTemporaryTable():New( cTmp01 )

	oTemptable:SetFields( aStruct )

	oTempTable:AddIndex("Ind01", {"CAMPO02"} )

	oTempTable:Create()


	//-Cria  o 2 arq. temporario

	oTempTable := FWTemporaryTable():New( cTmp02 )

	oTemptable:SetFields( aStruct )

	oTempTable:AddIndex("Ind01", {"CAMPO02"} )

	oTempTable:Create()

Return

/*
=====================================================================================
Programa.:              fAppend
Autor....:              Luis Artuso
Data.....:              11/10/16
Descricao / Objetivo:   Preenche as tabelas temporarias com os conforme arquivos informados no Getfile
Doc. Origem:            Contrato - GAP FIS33
Solicitante:            Cliente
Uso......:              
Obs......:
=====================================================================================
*/
Static Function fAppend(cTmp01 , cTmp02 , cArq01 , cArq02 , cArq03 , oTempTable)

	dbSelectArea(cTmp01)
	Append from &cArq01 SDF

	dbSelectArea(cTmp02)
	Append from &cArq02 SDF

	fMerge(cTmp01 , cTmp02 , cArq03 , oTempTable)

Return


/*
=====================================================================================
Programa.:              fMerge
Autor....:              Luis Artuso
Data.....:              11/10/16
Descricao / Objetivo:   Agrupa os arquivos (manad rh evolution / Protheus e gera o arquivo manad 'total')
Doc. Origem:            Contrato - GAP FIS33
Solicitante:            Cliente
Uso......:              
Obs......:
=====================================================================================
*/
Static Function fMerge(	cTmp01 ,; // 1 alias temporario
						cTmp02 ,; // 2 alias temporario
						cArq03 ,; // Arquivo destino
						oTempTable; //Objeto contendo os arquivos temporarios criados
						)

	Local cAliasTMP	:= ""
	Local cLinha	:= ""
	Local nAsc		:= 0
	Local nHandle	:= 0
	Local nTotReg	:= 0
	Local cReg9001	:= ""
	Local cReg9999	:= ""
	Local nTotGeral	:= 0
	Local nAsc0		:= 0
	Local nAscI		:= 0
	Local nAscK		:= 0
	Local nAscL		:= 0
	Local nAsc9		:= 0

	/* Para fazer o merge dos arquivos, observar as seguintes instrucoes:
		* o arquivo 'cTmp01' refere-se ao arquivo Manad gerado atraves do Protheus;
		* o arquivo 'cTmp02' refere-se ao arquivo Manad gerado pelo RhEvolution;

		Para juntar os arquivos, o loop ira' percorrer os dois arquivos, considerando as seguintes situacoes:
			* Do arquivo cTmp01, serao retirados TODOS os registros cujo inicio NAO seja 'K'
			* Do arquivo cTmp02, serao retirados TODOS os registros cujo inicio seja 'K'
			* Para gravar os totais, sera utilizado como referencia o registro '9900'. Com isto, e possivel fazer com que a rotina
			tenha comportamento similar 'a extracao dos registros do bloco 'K' entre os arquivos. Previne tambem que os totais sejam gravados incorretamente.
	*/

	cAliasTMP	:= GetNextAlias()

	cReg9999	:= "9999" // Atraves desta variavel, e' possivel identificar os totalizadores dos blocos.

	nAsc0		:= ASC('0')
	nAscI		:= ASC('I')
	nAscK		:= ASC('K')
	nAscL		:= ASC('L')
	nAsc9		:= ASC('9')

	nTotReg	:= (cTmp01)->(LastRec()) + (cTmp02)->(LastRec())

	( cTmp01 )->( dbGoTop() )

	( cTmp02 )->( dbGoTop() )

	ProcRegua(nTotReg)

	//-Extrai itens do arquivo RHEVOLUTION, ate o item 'L'
	Do While ((cTmp01)->(!EOF())) .AND. (!ASC(Left(AllTrim((cTmp01)->(CAMPO01)) , 1)) == nAsc9 )

		cLinha	:= ""

		cLinha	:= AllTrim((cTmp01)->(CAMPO01))

		If (ASC(Left(cLinha , 1)) == nAsc0) .OR. (ASC(Left(cLinha , 1)) == nAscI)

			fEscreve(cLinha , @nHandle , cArq03)

			nTotGeral++

		EndIf

		(cTmp01)->(dbSkip())

	EndDo

	//-Extrai itens 'K' do arquivo RhEvolution (Somente itens)
	Do While ((cTmp02)->(!EOF())) .AND. !(ASC(Left(AllTrim((cTmp02)->(CAMPO01)) , 1)) == nAsc9 )

		cLinha	:= ""

		cLinha	:= AllTrim((cTmp02)->(CAMPO01))

		If (ASC(Left(cLinha , 1)) == nAscK )

			fEscreve(cLinha , @nHandle , cArq03)

			nTotGeral++

		EndIf

		(cTmp02)->(dbSkip())

	EndDo

	//- Complementa o arquivo destino com os itens 'L' e inicia gravacao dos totais do arquivo Protheus.
	Do While ((cTmp01)->(!EOF())) .AND. ( !(AT(CHR(nAscK) , AllTrim((cTmp01)->(CAMPO01)) ) > 0) )

		cLinha	:= ""

		cLinha	:= AllTrim((cTmp01)->(CAMPO01))

		If !(AT(CHR(nAscK) , cLinha ) > 0)

			fEscreve(cLinha , @nHandle , cArq03)

			nTotGeral++

		EndIf

		(cTmp01)->(dbSkip())

	EndDo

	//- Complementa o arquivo destino com os totais do bloco 'K' do arquivo MANAD (RhEvolution)
	Do While ((cTmp02)->(!EOF()))

		cLinha	:= ""

		cLinha	:= AllTrim((cTmp02)->(CAMPO01))

		If (AT(CHR(nAscK) , cLinha ) > 0)

			fEscreve(cLinha , @nHandle , cArq03)

			nTotGeral++

		EndIf

		(cTmp02)->(dbSkip())

	EndDo

	Do While ((cTmp01)->(!EOF()))

		cLinha	:= ""

		cLinha	:= AllTrim((cTmp01)->(CAMPO01))

		If (Left(cLinha , 4) == cReg9999)

			nTotGeral++

			cLinha	:= Left(AllTrim((cTmp01)->(CAMPO01)) , 4) + "|" + AllTrim(Str(nTotGeral))

			fEscreve(cLinha , @nHandle , cArq03)

		Else

			If !(AT(CHR(nAscK) , cLinha ) > 0)

				fEscreve(cLinha , @nHandle , cArq03)

				nTotGeral++

			EndIf

		EndIf

		(cTmp01)->(dbSkip())

	EndDo

	fClose(nHandle)

Return

/*
=====================================================================================
Programa.:              fEscreve
Autor....:              Luis Artuso
Data.....:              11/10/16
Descricao / Objetivo:   Cria o arquivo manad de saida
Doc. Origem:            Contrato - GAP FIS33
Solicitante:            Cliente
Uso......:              
Obs......:
=====================================================================================
*/
Static Function fEscreve(cString , nHandle , cArq03)

	Local cEol	:= Chr(13)+Chr(10)

	If ( nHandle == 0 )

		nHandle	:= fCreate(cArq03)

	EndIf

	fWrite(nHandle , cString + cEol )

Return