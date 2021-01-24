#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'TBICONN.CH'

/*
=====================================================================================
Programa.:              fVldMvPar
Autor....:              Luis Artuso
Data.....:              05/09/2016
Descricao / Objetivo:   Validar os Parametros responsaveis por indicar os caminhos para envio/retorno dos arquivos CNAB
Doc. Origem:            Contrato - GAP MGFINT03
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
User Function fVldMvPar(cPar01 , cPar02 , aPar01 , aPar02 , lGeraDir , cNomePar01 , cNomePar02)

	Local lRet		:= .F.

	DEFAULT lGeraDir	:= .T.// Se preenche array com os diretorios. Quando .F., a chamada e' realizada pelo P.E. FA420NAR e
							  //nao serao gerados os arrays com os diretorios, pois o intuito e' retornar o destino (MGF_DIRGER)
							  //para geracao do CNAB.

	If ( Empty(cPar01) .OR. ( Empty(cPar02)) ) // Algum dos parametros esta vazio
		If ( Empty(cPar01) )
			MsgAlert('O Parametro : ' + cNomePar01 + ' Está vazio. Preencha-o e reinicie o processo')
		EndIf
		If ( Empty(cPar02) )
			MsgAlert('O Parametro : ' + cNomePar02 + ' Está vazio. Preencha-o e reinicie o processo')
		EndIf
	Else
		If ( lGeraDir )
			lRet	:= fLoadFold(cPar01 , cPar02 , @aPar01 , @aPar02 )
		Else
			lRet	:= .T.
		EndIf
	EndIf

Return lRet

/*
=====================================================================================
Programa.:              fLoadFold
Autor....:              Luis Artuso
Data.....:              06/09/2016
Descricao / Objetivo:   Verifica se as pastas indicadas nos parametros MGF_DIRGER e MGF_DIRENV existem
Doc. Origem:            Contrato - GAP MGFINT03
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
Static Function fLoadFold(cPar01 , cPar02 , aPar01 , aPar02)

	/*
		cPar01 = MGF_DIRGER ** Diretorio 'Origem'
		cPar02 = MGF_DIRENV ** Diretorio 'Destino'
		aPar01 = Array com o conteudo do diretorio de MGF_DIRGER
		aPar02 = Array com o conteudo do diretorio de MGF_DIRENV
	*/

	Local aDir01	:= {} // 'L' - Retorna o diretorio do disco local, caso alguma unidade de disco seja informada
	Local aDir02	:= {} // 'C' - Retorna o diretorio conforme informado no \startpath. Neste caso, nenhuma unidade de disco foi informada.
	Local cDir01	:= "" // Informa o conteudo do MV_PAR
	Local cDir02	:= "" // Informa o conteudo do MV_PAR
	Local nLenDir	:= 0
	Local nX		:= 0
	Local lPastaE	:= .F. // Informa que a pasta existe no diretorio (Pasta Envio)
	Local lPastaR	:= .F. // Informa que a pasta existe no diretorio (Pasta Retorno)
	Local nPosTipo	:= 5   // Dentro do array aDir, a posicao 5 informa o tipo do documento (se P(pasta), A(arquivo), D(Diretorio)...) etc...
	Local nPosNome	:= 1
	Local nPosEnv	:= 0
	Local nPosRet	:= 0
	Local cPath		:= ""
	Local lRet		:= .F.

	cPar01	:= Upper(AllTrim(cPar01))
	cPar02	:= Upper(AllTrim(cPar02))

	cDir01	:= Left(cPar01 , 1)

	cDir02	:= Left(cPar02 , 1)

	If ( ( cDir01 == '/') .OR. (cDir01 == '\') ) // Se conteudo informado NAO e' configurado atraves do \StartPath
		aDir01	:= Directory("*.*" , "D")
	Else
		cPath	:= cDir01 + ":\*.*"
		aDir01	:= Directory(cPath , "D")
	Endif

	If ( ( cDir02 == '/') .OR. (cDir02 == '\') ) // Se conteudo informado NAO e' configurado atraves do \StartPath
		aDir02	:= Directory("*.*" , "D")
	Else
		cPath	:= cDir02 + ":\*.*"
		aDir02	:= Directory(cPath , "D")
	Endif

	nLenDir	:= Len(aDir01)

	Do While ( (!lPastaE) .AND. (++nX <= nLenDir) )
		If ( (aDir01[nX,nPosTipo] == "D") .AND. (aDir01[nX,nPosNome] $ cPar01) ) //Se a pasta definida em MGF_DIRGER existe em aDir
			lPastaE	:= .T.
			nPosEnv	:= nX
		EndIf
	Enddo

	nLenDir	:= Len(aDir02)
	nX		:= 0

	Do While ( (!lPastaR) .AND. (++nX <= nLenDir) )
		If ( (aDir02[nX,nPosTipo] == "D") .AND. (aDir02[nX,nPosNome] $ cPar02) ) //Se a pasta definida em MGF_DIRENV existe em aDir
			lPastaR	:= .T.
			nPosRet	:= nX
		EndIf
	Enddo

	If !(lPastaE) //Se o diretorio (Envio) nao existir
		MsgAlert('O diretório ' + AllTrim(cPar01) + ' Não existe. Crie a pasta e reinicie o processo.')
	Else
		If !( Right(cPar01 , 1) == "\" )
			cPath	:= cPar01 + "\*.*"
		Else
			cPath	:= cPar01 + "*.*"
		EndIf

		aDir01	:= Directory(cPath)
		aPar01	:= aClone(aDir01)
		lRet	:= .T.
	EndIf

	If ( lRet )
		If !(lPastaR) // Se o diretorio (Retorno) nao existir
			MsgAlert('O diretório ' + AllTrim(cPar02) + ' Não existe. Crie a pasta e reinicie o processo.')
			lRet	:= .F.
		Else
			cPath	:= ""
			If !( Right(cPar02 , 1) == "\" )
				cPath	:= cPar02 + "\*.*"
			Else
				cPath	:= cPar02 + "*.*"
			EndIf
			aDir02	:= Directory(cPath)
			aPar02	:= aClone(aDir02)
			lRet	:= .T.
		EndIf
	EndIf

Return lRet

/*
=====================================================================================
Programa.:              fCopia
Autor....:              Luis Artuso
Data.....:              06/09/2016
Descricao / Objetivo:   Move o arquivo processado para a pasta de historico
Doc. Origem:            Contrato - GAP MGFINT03
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
User Function fCopia(cPar01 , cPar02 , cPar03)

	/*
		cPar01 -> Diretorio de origem
		cPar02 -> Diretorio de destino
		cPar03 -> Nome do arquivo a copiar
	*/

	Local cArqOri	:= ""
	Local cArqDest	:= ""

	If !( Right(cPar01 , 1) == '\' )
		cArqOri		:= cPar01 + '\' + cPar03
	Else
		cArqOri		:= cPar01 + cPar03
	EndIf

	If !( Right(cPar02 , 1) == '\' )
		cArqDest	:= cPar02 + '\' + cPar03
	Else
		cArqDest	:= cPar02 + cPar03
	EndIf

	__CopyFile(cArqOri , cArqDest)

	If ( File(cArqDest) )
		// O arquivo existe no destino, portanto, o arquivo 'origem' sera' excluido.
		If !( FERASE(cArqOri) == 0 )
			MsgStop('Falha na exclusão do Arquivo: ' + cArqDest)
		Endif
	EndIf

Return