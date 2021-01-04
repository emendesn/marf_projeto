#INCLUDE 'TOTVS.CH'
#Include "rwmake.ch"

/*/
������������������������������������������������������������������������������������������������������������������������������������������������
������������������������������������������������������������������������������������������������������������������������������������������������
��������������������������������������������������������������������������������������������������������������������������������������������ͻ��
���Programa  � MGF00A01 � Autor � Geronimo Benedito Alves                                                                    �Data �24/04/18 ���
��������������������������������������������������������������������������������������������������������������������������������������������͹��
���Desc.     � Este programa contem varias funcoes genericas e reutlizaveis para criar as consultas padroes (SXB) personalizadas utilizadas  ���
���          � nos relatorios de B.I. Contem tambem as proprias funcoes de chamada das consultas personalizadas                              ���
��������������������������������������������������������������������������������������������������������������������������������������������͹��
���Uso       � Cliente Global Foods                                                                                                          ���
��������������������������������������������������������������������������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������������������������������������������������������������������������
������������������������������������������������������������������������������������������������������������������������������������������������  /*/

/*/
������������������������������������������������������������������������������������������������������������������������������������������������
������������������������������������������������������������������������������������������������������������������������������������������������
��������������������������������������������������������������������������������������������������������������������������������������������ͻ��
���Programa  � F3EE7PED �Autor  �Geronimo Benedito Alves                                                                     �Data �24/04/18 ���
��������������������������������������������������������������������������������������������������������������������������������������������͹��
���Desc.     � Monto a consulta para Mostrar na tela as colunas:EE7_FILIAL,EE7_PEDIDO,EE7_PEDFAT, C5_CLIENTE,C5_LOJACLI,C5_XCGCCPF,C5_XNOMECL���
���          � OBS: nao SE pode utilizar alias para o nome do campo, tem que deixar o nome real dele na tabela.                              ���
��������������������������������������������������������������������������������������������������������������������������������������������͹��
���Uso       � Cliente Global Foods                                                                                                          ���
��������������������������������������������������������������������������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������������������������������������������������������������������������
������������������������������������������������������������������������������������������������������������������������������������������������ /*/

STATIC _xRetF3Gen	:= "XXXXXXXXXXXXXXX"	// Inicio como Static a variavel que sera retornada. Assim ela pode ser usada em qualquer funcao deste programa. 

// Func�o chamada pela consulta padrao SXB de nome ZZH_AR.  Monta a tela com a query abaixo para o usuario selecionar a linha da qual quer o retorno 
// do campo ZZH_AR no campo que ele esta atualmente digitando. 
User Function F3ZZH_AR()
	Local cTitulo		:= "N� do Aviso de Recebimento"
	Local cQuery		:= "" 							//obrigatorio
	Local _cAlias		:= "ZZH"						//obrigatorio
	Local cCpoChave		:= "ZZH_AR" 					//obrigatorio
	Local cTitCampo		:= RetTitle(cCpoChave)			//obrigatorio
	Local cMascara		:= PesqPict(_cAlias,cCpoChave)	//obrigatorio
	Local nTamCpo		:= TamSx3(cCpoChave)[1]		
	Local cRetCpo		:= "M->ZZH_AR"					//obrigatorio
	Local nColuna		:= 2	
	Local cCodigo		:= Space( TamSx3(cCpoChave)[1])	// Inicio com espacos		//M->ZZH_AR	//pego o conteudo atual e levo-o para minha consulta padrao			
	Private bRet 		:=.F.
	
	// A variavel static _xRetF3Gen (que � o retorno desta consulta) � atualizada com o conteudo atual da variavel sobre a qual foi teclado o F3.
	// Isto para que _xRetF3Gen fique com um conteudo inicial valido
	_xRetF3Gen			:= &(cRetCpo)	

	//Monto a consulta
	cQuery := " SELECT ZZH_FILIAL, ZZH_AR, ZZH_DOC, ZZH_SERIE, ZZH_FORNEC, ZZH_LOJA, ZZH_NOME, ZZH_STATUS, ZZH_CNF, ZZH_DOCMOV	 "
	cQuery += " FROM " +RetSQLName("ZZH") + " TMP_ZZH "
	cQuery += " where TMP_ZZH.D_E_L_E_T_ = ' ' "
	cQuery += " ORDER BY ZZH_FILIAL, ZZH_DOC, ZZH_SERIE  "

	bRet := U_FiltroF3(cTitulo,cQuery,nTamCpo,_cAlias,cCodigo,cCpoChave,cTitCampo,cMascara,cRetCpo,nColuna)

Return(bRet)


// Func�o chamada pela consulta padrao SXB de nome EE7PED.  Monta a tela com a query abaixo para o usuario selecionar a linha da qual quer o retorno 
// do campo EE7_PEDFAT no campo que ele esta atualmente digitando. 
User Function F3EE7PED()
	Local cTitulo		:= "N� do Pedido de Venda no Processo de Exportacao"
	Local cQuery		:= "" 							//obrigatorio
	Local _cAlias		:= "EE7"						//obrigatorio
	Local cCpoChave		:= "EE7_PEDFAT" 				//obrigatorio
	Local cTitCampo		:= RetTitle(cCpoChave)			//obrigatorio
	Local cMascara		:= PesqPict(_cAlias,cCpoChave)	//obrigatorio
	Local nTamCpo		:= TamSx3(cCpoChave)[1]		
	Local cRetCpo		:= "M->EE7_PEDFAT"				//obrigatorio
	Local nColuna		:= 1	
	Local cCodigo		:= Space( TamSx3(cCpoChave)[1])	// Inicio com espacos		//M->EE7_PEDFAT	//pego o conteudo atual e levo-o para minha consulta padrao			
	Private bRet 		:=.F.
	
	// A variavel static _xRetF3Gen (que � o retorno desta consulta) � atualizada com o conteudo atual da variavel sobre a qual foi teclado o F3.
	// Isto para que _xRetF3Gen fique com um conteudo inicial valido
	_xRetF3Gen			:= &(cRetCpo)	

	//Monto a consulta
	cQuery := " SELECT EE7_PEDFAT, EE7_FILIAL, EE7_PEDIDO, C5_CLIENTE, C5_LOJACLI, C5_XCGCCPF, C5_XNOMECL "
	cQuery += " FROM " +RetSQLName("EE7") + " TMP_EE7 "
	cQuery += " INNER JOIN " +RetSQLName("SC5") + " TMP_SC5 ON EE7_FILIAL = C5_FILIAL AND EE7_PEDFAT = C5_NUM "
	cQuery += " where TMP_EE7.D_E_L_E_T_ = ' ' AND TMP_SC5.D_E_L_E_T_ = ' ' "
	cQuery += " ORDER BY EE7_FILIAL, EE7_PEDFAT "

	bRet := U_FiltroF3(cTitulo,cQuery,nTamCpo,_cAlias,cCodigo,cCpoChave,cTitCampo,cMascara,cRetCpo,nColuna)

Return(bRet)



/* +---------------+-----------------------------------------------------------------------------------------------------------------------------+
!Nome              ! FiltroF3                                                                                                                    !
+------------------+-----------------------------------------------------------------------------------------------------------------------------+
!Descricao         ! Funcao usada para mostrar na tela uma Consulta Padrao, a partir da query e demais parametros passados.                      !
!                  ! Esta funcao � generica e reutilizavel.                                                                                      !
+------------------+-----------------------------------------------------------------------------------------------------------------------------+
!Autor             ! Geronimo Benedito Alves                                                                                                     !
+------------------+-----------------------------------------------------------------------------------------------------------------------------+
!Data de Criacao   ! 24/04/2018                                                                                                                  !
+------------------+-----------+-------+---------------------------------------------------------------------------------------------------------+
!Campo             ! Tipo      !Obrigat!   Descricao                                                                                             !
+------------------+-----------+-------+---------------------------------------------------------------------------------------------------------+
!cTitulo           ! Caracter  !       ! Titulo da janela da consulta                                                                            !
!cQuery            ! Caracter  ! X     ! cQuery nao pode retornar outro nome para o campo pesquisado, pois a rotina valida o nome do campo real  !
!nTamCpo           ! Numerico  !       ! Tamanho do campo de pesquisar,se nao informado assume 30 caracteres                                     !
!_cAlias            ! Caracter  ! X     ! Alias da tabela, ex: SA1                                                                                !
!cCodigo           ! Caracter  !       ! Conteudo do campo que chama o filtro                                                                    !
!cCpoChave         ! Caracter  ! X     ! Nome do campo que sera utilizado para pesquisa, ex: A1_CODIGO                                           !
!cTitCampo         ! Caracter  ! X     ! Titulo do label do campo                                                                                !
!cMascara          ! Caracter  !       ! Mascara do campo, ex: "@!"                                                                              !
!cRetCpo           ! Caracter  ! X     ! Campo que recebera o retorno do filtro                                                                  !
!nColuna           ! Numerico  !       ! Coluna que sera retornada na pesquisa, padrao coluna 1                                                  !
+------------------+-----------+-----------------------------------------------------------------------------------------------------------------+ */

User Function FiltroF3(cTitulo,cQuery,nTamCpo,_cAlias,cCodigo,cCpoChave,cTitCampo,cMascara,cRetCpo,nColuna)
	Local nLista  
	Local cCampos		:= ""
	Local bCampo		:= {}
	Local nCont			:= 0
	//Local bTitulos		:= {}
	Local aCampos 		:= {}
	Local cCSSGet		:= "QLineEdit{ border: 1px solid gray;border-radius: 3px;background-color: #ffffff;selection-background-color: #3366cc;selection-color: #ffffff;padding-left:1px;}"
	Local cCSSButton 	:= "QPushButton{background-repeat: none; margin: 2px;background-color: #ffffff;border-style: outset;border-width: 2px;border: 1px solid #C0C0C0;border-radius: 5px;border-color: #C0C0C0;font: bold 12px Arial;padding: 6px;QPushButton:pressed {background-color: #ffffff;border-style: inset;}"
	//Local cCSSButF3		:= "QPushButton {background-color: #ffffff;margin: 2px;border-style: outset;border-width: 2px;border: 1px solid #C0C0C0;border-radius: 3px; border-color: #C0C0C0;font: Normal 10px Arial;padding: 3px;} QPushButton:pressed {background-color: #e6e6f9;border-style: inset;}"

	Local nX
	Local aStruTRB	:= {}
	Local cNomeArq	:=	" "
	Local _cTmp01	:= GetNextAlias() 

	Private _oLista		:= nil
	Private _oDlg 		:= nil
	//Private _oCodigo
	Private _cCodigo 	
	Private _aDados 	:= {}
	Private _nColuna	:= 0

	Default cTitulo 	:= ""
	Default cCodigo 	:= ""
	Default nTamCpo 	:= 30
	Default _nColuna 	:= 1
	Default cTitCampo	:= RetTitle(cCpoChave)
	Default cMascara	:= PesqPict('"'+_cAlias+'"',cCpoChave)

	_nColuna		:= nColuna

	If Empty(_cAlias) .OR. Empty(cCpoChave) .OR. Empty(cRetCpo) .OR. Empty(cQuery)
		MsgStop("Os parametros cQuery, cCpoChave, cRetCpo e _cAlias sao obrigatorios!","Erro")
		Return
	Endif

	_cCodigo	:= Space(nTamCpo)
	_cCodigo	:= cCodigo
	aStruTRB	:= U_QueryCpo(cQuery)
	cNomeArq	:= CriaTrab( aStruTRB,.T. )

	// A linha abaixo nao tem efeito p/ o fonte. � apenas p/ na compilacao nao aparecer a MSG "warning W0003 Local variable __LOCALDRIVER never used"
	__LocalDriver	:= __LocalDriver + ""	

	dbUseArea(.T.,__LocalDriver,cNomeArq,_cTmp01,.T.,.F.)
	MsAguarde({|| SqlToTrb(cQuery, aStruTRB, _cTmp01 )},"Criando a tabela com os dados da Query", "Criando a tabela com os dados da Query",.T. )  //MSAguarde( bAcao, cTitulo ,cMensagem, lAbortar)   Obs. lAborta =.T. habilita o Botao

	(_cTmp01)->(DbGoTop())
	If (_cTmp01)->(Eof())
		MsgStop("Nao h� registros para serem exibidos!","Atencao")
		Return
	Endif

	MsgRun("Selecionando dados: " + cTitulo, "Favor Aguardar.",  {|| MontaConsu( _cTmp01, @cCampos, @aCampos, @_aDados) })

	If Len(_aDados) == 0
		MsgInfo("Nao h� dados para exibir!","Aviso")
		Return
	Endif

	nLista := aScan(_aDados, {|x| alltrim(x[1]) == alltrim(_cCodigo)})

	iif(nLista = 0,nLista := 1,nLista)

	//Define MsDialog _oDlg Title "Consulta Padrao" + IIF(!Empty(cTitulo)," - " + cTitulo,"") From 0,0 To 420, 750 Of oMainWnd Pixel
	Define MsDialog _oDlg Title "Consulta Padrao" + IIF(!Empty(cTitulo)," - " + cTitulo,"") From 0,0 To 420, 750 Of _oDlg Pixel

	oCodigo:= TGet():New( 003, 005,{|u| if(PCount()>0,_cCodigo:=u,_cCodigo)},_oDlg,205, 010,cMascara,{|| /*Processa({|| FiltroF3P(M->_cCodigo)},"Aguarde...")*/ },0	,,,.F.	,,.T.	,,.F.	,,.F.,.F.	,,.F.,.F.,"",_cCodigo	,,	,,	,,,cTitCampo + ": ",1 )

	oCodigo:SetCss(cCSSGet)	
	oButton1 := TButton():New(010, 212," &Pesquisar ",_oDlg,{|| Processa({|| FiltroF3P(M->_cCodigo) },"Aguarde...") },037,013	,,,.F.,.T.,.F.	,,.F.	,,,.F. )
	oButton1:SetCss(cCSSButton)	

	_oLista:= TCBrowse():New(26,05,390,135	,,	,,_oDlg	,,	,,,{|| _oLista:Refresh()}	,,	,,	,,,.F.	,,.T.	,,.F.	,,,.f.)

	nCont := 1
	cColuna := ""
	// //Para ficar din�mico a criacao das colunas, eu uso macro substitui��o "&"
	For nX := 1 to len(aCampos)
		cColuna := &('_oLista:AddColumn(TCColumn():New("'+aCampos[nX,2]+'", {|| _aDados[_oLista:nAt,'+StrZero(nCont,2)+']},PesqPict("'+_cAlias+'","'+aCampos[nX,1]+'")	,,,"'+aCampos[nX,3]+'", '+StrZero(aCampos[nX,4],3)+',.F.,.F.	,,{||.F. }	,,.F., ) )')
		nCont++
	Next

	_oLista:SetArray(_aDados)
	_oLista:bWhen 		 := { || Len(_aDados) > 0 }
	_oLista:bLDblClick  := { || FiltroF3R(_oLista:nAt, _aDados, cRetCpo)  }
	_oLista:Refresh()

	oButton2 := TButton():New(185, 005," OK "			,_oDlg,{|| Processa({|| FiltroF3R(_oLista:nAt, _aDados, cRetCpo) },"Aguarde...") },037,012	,,,.F.,.T.,.F.	,,.F.	,,,.F. )
	oButton2:SetCss(cCSSButton)	
	oButton3 := TButton():New(185, 047," Cancelar "	,_oDlg,{|| _oDlg:End() },037,012	,,,.F.,.T.,.F.	,,.F.	,,,.F. )
	oButton3:SetCss(cCSSButton)	

	Activate MSDialog _oDlg Centered	
Return(bRet)


/*/
������������������������������������������������������������������������������������������������������������������������������������������������
������������������������������������������������������������������������������������������������������������������������������������������������
��������������������������������������������������������������������������������������������������������������������������������������������ͻ��
���Programa  � FiltroF3P�Autor  �Geronimo Benedito Alves                                                                     �Data �24/04/18 ���
��������������������������������������������������������������������������������������������������������������������������������������������͹��
���Desc.     � Busco o texto digitado, dentro de cada registro. Uso o tamanho do texto digitado, p/ s� busca-lo no come�o de cada ocorrencia.���
���          � Ao encontrar primeira ocorrencia, me posiciono no grid e saio do laco "For" .                                                 ���
��������������������������������������������������������������������������������������������������������������������������������������������͹��
���Uso       � Cliente Global Foods                                                                                                          ���
��������������������������������������������������������������������������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������������������������������������������������������������������������
������������������������������������������������������������������������������������������������������������������������������������������������ /*/
Static Function FiltroF3P(cBusca)
	Local i 		:= 0
	Local nTamanhBus	:= Iif( Len(AllTrim(cBusca)) > 0 , Len(AllTrim(cBusca)) , 1 )
	Local lencontrou	:=.T.

	if !Empty(cBusca)
		lencontrou	:=.F.
		For i := 1 to len(_aDados)
			//Aqui busco o texto digitado, dentro de cada registro. Porem uso o tamanho do texto digitado, p/ s� busca-lo no come�o de cada ocorrencia.
			if UPPER(Alltrim(cBusca)) $ Subs( UPPER(Alltrim(_aDados[i,_nColuna])) ,1, nTamanhBus )
				// Ao encontrar primeira ocorrencia, me posiciono no grid e saio do laco "For"			
				_oLista:GoPosition(i)
				_oLista:Setfocus()
				lencontrou	:=.T.
				exit
			Endif
		Next
		If !lencontrou
			MsgStop("Nao foi encontrado nenhum registro iniciado por " + cBusca )
		Endif
	Endif
Return


/*/
������������������������������������������������������������������������������������������������������������������������������������������������
������������������������������������������������������������������������������������������������������������������������������������������������
��������������������������������������������������������������������������������������������������������������������������������������������ͻ��
���Programa  � FiltroF3R�Autor  �Geronimo Benedito Alves                                                                     �Data �24/04/18 ���
��������������������������������������������������������������������������������������������������������������������������������������������͹��
���Desc.     � Ao clicar no Botao OK, ou clicar duas vezes em qualquer linha/campo do grid, alimento as variaveis de retorno com o cnteudo   ���
���          � da linha/campo selecionado.       Esta funcao � generica e reutilizavel.                                                      ���
��������������������������������������������������������������������������������������������������������������������������������������������͹��
���Uso       � Cliente Global Foods                                                                                                          ���
��������������������������������������������������������������������������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������������������������������������������������������������������������
������������������������������������������������������������������������������������������������������������������������������������������������ /*/
Static Function FiltroF3R(nLinha,aDados,cRetCpo)

	//cCodigo := Strtran(time, ":" , "" )		// Teste de obtencao do retorno
	
	cCodigo		:= aDados[nLinha,_nColuna]
	_xRetF3Gen	:= cCodigo	

	&(cRetCpo)	:= cCodigo //Uso desta forma para campos como tGet por exemplo.
	//aCpoRet[1] := cCodigo //Nao esquecer de alimentar essa variavel quando for f3 pois ela e o retorno
	aCpoRet := { cCodigo }  //Nao esquecer de alimentar essa variavel quando for f3 pois ela e o retorno
	bRet :=.T.
	_oDlg:End()    
Return aCpoRet


/*/
������������������������������������������������������������������������������������������������������������������������������������������������
������������������������������������������������������������������������������������������������������������������������������������������������
��������������������������������������������������������������������������������������������������������������������������������������������ͻ��
���Programa  � MGF00ARE �Autor  �Geronimo Benedito Alves                                                                     �Data �25/04/18 ���
��������������������������������������������������������������������������������������������������������������������������������������������͹��
���Desc.     � Esta funcao deve ser chamada no campo retorno, da tela de manutencao de consulta padrao do configurador. Inclua U_MGF00ARE()  ���
���          � Ou seja, sera o conteudo do campo XB_CONTEM do registro onde XB_TIPO � igual a 5 (Retorno).                                   ���
��������������������������������������������������������������������������������������������������������������������������������������������͹��
���Uso       � Cliente Global Foods                                                                                                          ���
��������������������������������������������������������������������������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������������������������������������������������������������������������
������������������������������������������������������������������������������������������������������������������������������������������������ /*/
User Function MGF00ARE()
Return(_xRetF3Gen)


/*/
������������������������������������������������������������������������������������������������������������������������������������������������
������������������������������������������������������������������������������������������������������������������������������������������������
��������������������������������������������������������������������������������������������������������������������������������������������ͻ��
���Programa  �MontaConsu�Autor  �Geronimo Benedito Alves                                                                     �Data �25/04/18 ���
��������������������������������������������������������������������������������������������������������������������������������������������͹��
���Desc.     � Le os registros da tabela temporaria e alimenta a vriavel cCampos e o array  aCampos                                          ���
���          �                                                                                                                               ���
��������������������������������������������������������������������������������������������������������������������������������������������͹��
���Uso       � Cliente Global Foods                                                                                                          ���
��������������������������������������������������������������������������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������������������������������������������������������������������������
������������������������������������������������������������������������������������������������������������������������������������������������ /*/
Static Function MontaConsu( _cTmp01, cCampos, aCampos, _aDados )
	Local nX
	Local _nFCount	:= FCount()
	
	Do While (_cTmp01)->(!Eof())
		/*Cria o array conforme a quantidade de campos existentes na consulta SQL*/
		cCampos	:= ""
		aCampos 	:= {}
		For nX := 1 TO _nFCount
			bCampo := {|nX| Field(nX) }
			If ValType((_cTmp01)->&(EVAL(bCampo,nX)) ) <> "M" .OR. ValType((_cTmp01)->&(EVAL(bCampo,nX)) ) <> "U"
				if ValType((_cTmp01)->&(EVAL(bCampo,nX)) )=="C"
					cCampos += "'" + (_cTmp01)->&(EVAL(bCampo,nX)) + "',"
				ElseIf ValType((_cTmp01)->&(EVAL(bCampo,nX)) )=="D"
					cCampos +=  DTOC((_cTmp01)->&(EVAL(bCampo,nX))) + ","
				ElseIf ValType((_cTmp01)->&(EVAL(bCampo,nX)) )=="N"
					cCampos +=  STR((_cTmp01)->&(EVAL(bCampo,nX))) + ","
				Else
					cCampos +=  (_cTmp01)->&(EVAL(bCampo,nX)) + ","
				Endif

				aadd(aCampos,{EVAL(bCampo,nX),Alltrim(RetTitle(EVAL(bCampo,nX))),"LEFT",30})
			Endif
		Next

		If !Empty(cCampos) 
			cCampos 	:= Substr(cCampos,1,len(cCampos)-1)
			aAdd( _aDados,&("{"+cCampos+"}"))
		Endif

		(_cTmp01)->(DbSkip())     
	Enddo

	(_cTmp01)-> ( DbCloseArea() )
	fErase(_cTmp01)

Return



*************************************************************************************************************************************
//-------------------------------------------------------------------------------------------------------
// Este exemplo � para demonstrar a criacao de um arquivo temporario 
// carregar com dados e por fim apresendar em uma MBrowse com opcao de pesquisar e visualizar dados.
//-------------------------------------------------------------------------------------------------------

#Include "Protheus.ch"
#Include "MSMGADD.CH"

#DEFINE nTRB  1
#DEFINE nIND1 2
#DEFINE nIND2 3

User Function MBrowTMP(cCadastro)

Local aTRB := {}
Local aHeadMBrow := {}

Default cCadastro := "MBrowse com arquivo temporario"
Private aRotina := {}

//aTRB[1] -> Nome fisico do arquivo
//aTRB[2] -> Nome do indice 1
//aTRB[3] -> Nome do indice 2
MsgRun("Criando estrutura e carregando dados no arquivo temporario..."	,,{|| aTRB := FileTRB() } )

//aHeadMBrow[1] -> Titulo 
//aHeadMBrow[2] -> Campo
//aHeadMBRow[3] -> Tipo
//aHeadMBrow[4] -> Tamanho
//aHeadMBRow[5] -> Decimal
//aHeadMBrow[6] -> Picture
MsgRun("Criando coluna para MBrowse..."	,,{|| aHeadMBrow := HeadBrow() } )

AAdd( aRotina, { "Pesquisar", "U_MBrowPesq", 0, 1 } )
AAdd( aRotina, { "Visualizar","U_MBrowVisu", 0, 2 } )

dbSelectArea("TRB")
dbSetOrder(1)
MBrowse(	,,	,,"TRB",aHeadMBrow	,,	,,	,,"","") 
//Fecha a �rea
TRB->(dbCloseArea())
//Apaga o arquivo fisicamente
FErase( aTRB[ nTRB ] + GetDbExtension())
//Apaga os arquivos de indices fisicamente
FErase( aTRB[ nIND1 ] + OrdBagExt())
FErase( aTRB[ nIND2 ] + OrdBagExt()) 
Return

/*****
*
* Funcao para criar os titulos do Browse (header).
*
*/
Static Function HeadBrow()
Local aHead := {}
//Campos que aparecerao na MBrowse, como nao � baseado no SX3 deve ser criado.
//Sequencia do vetor: Titulo, Campo, Tipo, Tamanho, Decimal, Picture
AAdd( aHead, { "Prefixo"     , {|| TRB->XA_ALIAS }   ,"C", Len( SXA->XA_ALIAS )  , 0, "" } )
AAdd( aHead, { "Ordem"       , {|| TRB->XA_ORDEM }   ,"C", Len( SXA->XA_ORDEM )  , 0, "" } )
AAdd( aHead, { "Descricao"   , {|| TRB->XA_DESCRIC } ,"C", Len( SXA->XA_DESCRIC ), 0, "" } )
AAdd( aHead, { "Des.Espanhol", {|| TRB->XA_DESCSPA } ,"C", Len( SXA->XA_DESCSPA ), 0, "" } )
AAdd( aHead, { "Desc.Ingl�s" , {|| TRB->XA_DESCENG } ,"C", Len( SXA->XA_DESCENG ), 0, "" } )
AAdd( aHead, { "Pr�prio"     , {|| TRB->XA_PROPRI  } ,"C", Len( SXA->XA_PROPRI ) , 0, "" } )

Return( aHead )

/*****
*
* Funcao para criar o arquivo temporario e seus indices e gravar dados neste.
*  
*/
Static Function FileTRB()
Local aStruct := {}

Local cArqTRB := ""
Local cInd1 := ""
Local cInd2 := ""

Local nI := 0

Local nVez := SXA->( FCount() )
//Pode ser feito de duas maneiras a criacao do arquivo temporario, porem como isto sera
//feito com base em um arquivo que j� existe sera mais f�cil utilizar a primeira maneira.

//Primeira maneira
aStruct := SXA->( dbStruct() ) 
//Segunda maneira
//AAdd( aStruct, { "XA_ALIAS"  , "C", 3, 0 } )
//AAdd( aStruct, { "XA_ORDEM"  , "C", 1, 0 } )
//AAdd( aStruct, { "XA_DESCRIC", "C",30, 0 } )
//AAdd( aStruct, { "XA_DESCSPA", "C",30, 0 } )
//AAdd( aStruct, { "XA_DESCENG", "C",30, 0 } )
//AAdd( aStruct, { "XA_PROPRI" , "C", 1, 0 } )

// Ambas as maneiras devem proceder estes comandos abaixo:
// Criar fisicamente o arquivo.
cArqTRB := CriaTrab( aStruct,.T. )
cInd1 := Left( cArqTRB, 7 ) + "1"
cInd2 := Left( cArqTRB, 7 ) + "2"
// Acessar o arquivo e coloca-lo na lista de arquivos abertos.
dbUseArea(.T., __LocalDriver, cArqTRB, "TRB",.F.,.F. )
// Criar os indices.
IndRegua( "TRB", cInd1, "XA_ALIAS+XA_ORDEM", , , "Criando indices (Prefixo + Ordem)...")
IndRegua( "TRB", cInd2, "XA_DESCRIC", , , "Criando indices (Descricao)...")
// Libera os indices.
dbClearIndex()
// Agrega a lista dos indices da tabela (arquivo).
dbSetIndex( cInd1 + OrdBagExt() )
dbSetIndex( cInd2 + OrdBagExt() )

// Carregar os dados de SXA em TRB.
SXA->( dbSetOrder(1) )
SXA->( dbGoTop() )
While ! SXA->( EOF() )
  TRB->(RecLock("TRB",.T.))
  For nI := 1 To nVez
   TRB->( FieldPut( nI, SXA->(FieldGet( nI ) ) ) )
  Next nI
  TRB->(MsUnLock())
  SXA->( dbSkip() )
End
Return({cArqTRB,cInd1,cInd2})

/*****
*
* Funcao para pesquisar dados no arquivo temporario.
*
*/
User Function MBrowPesq()
local oDlgPesq, oOrdem, oChave, oBtOk, oBtCan, oBtPar
Local cOrdem
Local cChave := Space(255)
Local aOrdens := {}
Local nOrdem := 1
Local nOpcao := 0

AAdd( aOrdens, "Prefixo + Ordem" )
AAdd( aOrdens, "Descricao" )

DEFINE MSDIALOG oDlgPesq TITLE "Pesquisa" FROM 00,00 TO 100,500 PIXEL
  @ 005, 005 COMBOBOX oOrdem VAR cOrdem ITEMS aOrdens SIZE 210,08 PIXEL OF oDlgPesq ON CHANGE nOrdem := oOrdem:nAt
  @ 020, 005 MSGET oChave VAR cChave SIZE 210,08 OF oDlgPesq PIXEL
  DEFINE SBUTTON oBtOk  FROM 05,218 TYPE 1 ACTION (nOpcao := 1, oDlgPesq:End()) ENABLE OF oDlgPesq PIXEL
  DEFINE SBUTTON oBtCan FROM 20,218 TYPE 2 ACTION (nOpcao := 0, oDlgPesq:End()) ENABLE OF oDlgPesq PIXEL
  DEFINE SBUTTON oBtPar FROM 35,218 TYPE 5 WHEN.F. OF oDlgPesq PIXEL
ACTIVATE MSDIALOG oDlgPesq CENTER

If nOpcao == 1
  cChave := AllTrim(cChave)
  TRB->(dbSetOrder(nOrdem)) 
  TRB->(dbSeek(cChave))
Endif
Return

/*****
*
* Funcao para visualizar dados do registro do arquivo temporario.
*
*/
User Function MBrowVisu()
Local nI := 0
Local nRec := TRB->(RecNo())
Local nTop := 0
Local nLeft := 0
Local nBottom := 0
Local nRight := 0

Local aInfo := {}
Local aHead := {}
Local aStruct := {}
Local oDlg
Local oEnchoice

// Carregar o vetor com os titulos dos campos.
aHead := HeadBrow()
// Buscar a estrutura da �rea de trabalho.
aStruct := TRB->( dbStruct() )
// Montar os SAY e GET da Enchoice.
For nI := 1 To Len( aStruct )
  ADD FIELD aInfo TITULO aHead[nI,1] CAMPO aStruct[nI,1] TIPO aStruct[nI,2] TAMANHO aStruct[nI,3] DECIMAL aStruct[nI,4] NIVEL 1
  cField := aInfo[nI][2]
  M->&(cField) := TRB->&(cField)
Next nI
// Definir as coordenadas para a janela.
If SetMDIChild()
  oMainWnd:ReadClientCoors()
  nTop := 40
  nLeft := 30 
  nBottom := oMainWnd:nBottom-80
  nRight := oMainWnd:nRight-70  
Else
  nTop := 135
  nLeft := 0
  nBottom := TranslateBottom(.T.,28)
  nRight := 632
Endif
// Apresentar os dados para visualizasao no objeto.
DEFINE MSDIALOG oDlg TITLE cCadastro FROM nTop,nLeft TO nBottom,nRight PIXEL
  oEnchoice := MsMGet():New("TRB",nRec,2	,,	,,,{0,0,0,0}	,,	,,	,,oDlg	,,,.F.	,,	,,aInfo)
  oEnchoice:oBox:Align := CONTROL_ALIGN_ALLCLIENT
ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| oDlg:End() }, {|| oDlg:End() })
Return

//Read more: http://www.blacktdn.com.br/2012/05/e-ai-galera-beleza-entao.html#ixzz5EuYZhZnR
