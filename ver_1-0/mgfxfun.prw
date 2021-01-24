#Include 'Protheus.ch'
#Include 'Fileio.ch'
#include "totvs.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#Define ENTER	Chr(13)+Chr(10) 

/*
=====================================================================================
Programa............: MGFXFUN
Autor...............: Josué Danich Prestes
Data................: 18/07/2019
Descrição / Objetivo: Rotinas de uso generico na Marfrig
===============================================================================================================================
*/
User Function MGFXFUN()
Return

/*
=====================================================================================
Programa............: MGFHelp
Autor...............: Josué Danich Prestes
Data................: 18/07/2019
Descrição / Objetivo: Help personalizado Marfrig
===============================================================================================================================
*/
USER FUNCTION MGFHelp(cKey,aHelpPor,aHelpEng,aHelpSpa,lUpdate,cStatus)
	xHelp(cKey,aHelpPor,aHelpEng,aHelpSpa,lUpdate,cStatus)
RETURN

/*
=====================================================================================
Programa............: xHelp
Autor...............: Josué Danich Prestes
Data................: 18/07/2019
Descrição / Objetivo: Execução de Help personalizado Marfrig
===============================================================================================================================
*/
STATIC Function xHelp(cKey,aHelpPor,aHelpEng,aHelpSpa,lUpdate,cStatus)
Local cFilePor := "SIGAHLP.HLP"
Local cFileEng := "SIGAHLE.HLE"
Local cFileSpa := "SIGAHLS.HLS"
Local nRet
Local nT
Local nI
Local cLast
Local cNewMemo
Local cAlterPath := ''
Local nPos	

If ( ExistBlock('HLPALTERPATH') )
	cAlterPath := Upper(AllTrim(ExecBlock('HLPALTERPATH', .F., .F.)))
	If ( ValType(cAlterPath) != 'C' )
        cAlterPath := ''
	ElseIf ( (nPos:=Rat('\', cAlterPath)) == 1 )
		cAlterPath += '\'
	ElseIf ( nPos == 0	)
		cAlterPath := '\' + cAlterPath + '\'
	EndIf
	
	cFilePor := cAlterPath + cFilePor
	cFileEng := cAlterPath + cFileEng
	cFileSpa := cAlterPath + cFileSpa
	
EndIf

Default aHelpPor := {}
Default aHelpEng := {}
Default aHelpSpa := {}
Default lUpdate  := .T.
Default cStatus  := ""

If Empty(cKey)
	Return
EndIf

If !(cStatus $ "USER|MODIFIED|TEMPLATE")
	cStatus := NIL
EndIf

cLast 	 := ""
cNewMemo := ""

nT := Len(aHelpPor)

For nI:= 1 to nT
   cLast := Padr(aHelpPor[nI],40)
   If nI == nT
      cLast := RTrim(cLast)
   EndIf
   cNewMemo+= cLast
Next

If !Empty(cNewMemo)
	nRet := SPF_SEEK( cFilePor, cKey, 1 )
	If nRet < 0
		SPF_INSERT( cFilePor, cKey, cStatus,, cNewMemo )
	Else
		If lUpdate
			SPF_UPDATE( cFilePor, nRet, cKey, cStatus,, cNewMemo )
		EndIf
	EndIf
EndIf

cLast 	 := ""
cNewMemo := ""

nT := Len(aHelpEng)

For nI:= 1 to nT
   cLast := Padr(aHelpEng[nI],40)
   If nI == nT
      cLast := RTrim(cLast)
   EndIf
   cNewMemo+= cLast
Next

If !Empty(cNewMemo)
	nRet := SPF_SEEK( cFileEng, cKey, 1 )
	If nRet < 0
		SPF_INSERT( cFileEng, cKey, cStatus,, cNewMemo )
	Else
		If lUpdate
			SPF_UPDATE( cFileEng, nRet, cKey, cStatus,, cNewMemo )
		EndIf
	EndIf
EndIf

cLast 	 := ""
cNewMemo := ""

nT := Len(aHelpSpa)

For nI:= 1 to nT
   cLast := Padr(aHelpSpa[nI],40)
   If nI == nT
      cLast := RTrim(cLast)
   EndIf
   cNewMemo+= cLast
Next

If !Empty(cNewMemo)
	nRet := SPF_SEEK( cFileSpa, cKey, 1 )
	If nRet < 0
		SPF_INSERT( cFileSpa, cKey, cStatus,, cNewMemo )
	Else
		If lUpdate
			SPF_UPDATE( cFileSpa, nRet, cKey, cStatus,, cNewMemo )
		EndIf
	EndIf
EndIf
Return

/*
=====================================================================================
Programa............: MGListBox
Autor...............: Josué Danich Prestes
Data................: 18/07/2019
Descrição / Objetivo: Monta tela para exibição de ListBox com opção de exportação 
======================================================================================
Parametros------: _cTitAux	- Título da Janela
----------------: _aHeader	- Cabeçalho do conteúdo
----------------: _aCols    - Itens do conteúdo
----------------: _lMaxSiz  - Define se utiliza o Listbox em tela cheia
----------------: _nTipo	- Define se o ListBox é de exibição ou de seleção
----------------: _cMsgTop	- Mensagem auxiliar na parte superior do Listbox
----------------: _aSizes	- Tamanho das colunas do Listbox
----------------: _nCampo	- Posição do Array  retornada em caso de  Seleção Simples
=======================================================================================
Retorno---------: lRet	- Se usuário saia da tela clicando em "Confirmar" retorna .T.
=======================================================================================
*/
User Function MgListBox( _cTitAux , _aHeader , _aCols , _lMaxSiz , _nTipo , _cMsgTop , _lSelUnc , _aSizes , _nCampo , bOk , bCancel, _abuttons )

Local oOk			:= LoadBitmap( GetResources() , "LBOK" )
Local oNo			:= LoadBitmap( GetResources() , "LBNO" )
Local _lRet			:= .F.
Local aCoors 		:= FWGetDialogSize(oMainWnd)
Local aSize     	:= MsAdvSize( .T. ) 
Local aObjAux		:= {}
Local aPosAux		:= {}
Local aButtons		:= {}
Local oDlg			:= Nil
Local oFont			:= Nil
Local cColsAux		:= ""
Local nI			:= 0
Local _lVersao12    := (AllTrim(OAPP:CVERSION) = "12")
Local bDblClk	 	:= Nil , _nni , _nnp

Private oLbxAux		:= Nil
Private	nITPosAnt	:= 0

Default _cTitAux	:= "Exibição de dados"
Default _aHeader	:= { "Falha" }
Default _aCols		:= { { "Sem conteúdo para exibir." } }
Default _lMaxSiz	:= .F.
Default _nTipo		:= 1
Default _cMsgTop	:= ""
Default _lSelUnc	:= .F.
Default _aSizes		:= {}
Default _nCampo		:= 1
Default bOk			:= {|x| _lRet := .T. , IIf( _nTipo == 2 , _aCols := oLbxAux:aArray , IIF( _nTipo == 3 , _lRet := oLbxAux:aArray[oLbxAux:nAt][_nCampo] , Nil ) ) , oDlg:End() }
Default bCancel		:= {|x| _lRet := .F. , oDlg:End() }
Default _abuttons   := {}

IF _nTipo = 4
   oOk:= LoadBitmap( GetResources() , "BR_VERDE"    )
   oNo:= LoadBitmap( GetResources() , "BR_VERMELHO" )
ENDIF

bDblClk := {|| MGDblClk( @oLbxAux , _nTipo , _lSelUnc ) }

If _lMaxSiz

	aAdd( aObjAux, { 100, 100, .T., .T. } )
	aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 2 }
	aPosAux := MsObjSize( aInfo , aObjAux )

Else

	aCoors[01]	:= 000
	aCoors[02]	:= 000
	aCoors[03]	:= 400
	aCoors[04]	:= 700
	aPosAux		:= { { 002 , 002 , 186 , 350 } }
    aPosAux[01][01] += 030
	
EndIF

DEFINE FONT oFont NAME "Verdana" SIZE 05,12

aAdd( aButtons , { "Exp. Excel"		, {|| DlgToExcel( { { "ARRAY" , _cTitAux , _aHeader , _aCols } } ) }	, "Exportação de Dados para Excel"		, "Exp. Excel"		} )

_ni := 1

Do while _ni <= len(_abuttons)

	aadd(aButtons, _abuttons[_ni])
	
	_ni++
	
Enddo

DEFINE MSDIALOG oDlg TITLE _cTitAux FROM aCoors[1],aCoors[2] TO aCoors[3],aCoors[4] PIXEL
	
	If !Empty( _cMsgTop )
		@aPosAux[01][01] , aPosAux[01][02] SAY _cMsgTop OF oDlg PIXEL
		aPosAux[01][01] += 010
	EndIf
	
	@aPosAux[01][01] , aPosAux[01][02]	LISTBOX	oLbxAux						;
										FIELDS	HEADER ""					;
										ON		DblClick( Eval(bDblClk) )	;
										SIZE	aPosAux[01][04] , ( aPosAux[01][03] - aPosAux[01][01] ) OF oDlg PIXEL
	
	oLbxAux:AHeaders		:= aClone( _aHeader )
	oLbxAux:bHeaderClick	:= { |oObj,nCol| MGOrdLbx( oObj , nCol , oLbxAux , _nTipo , _lSelUnc ) }
	oLbxAux:SetArray( _aCols )
	oLbxAux:AColSizes		:= aClone( _aSizes )
	
	//===========================================================================
	//| Monta os dados para o ListBox                                           |
	//===========================================================================
	For nI := 1 To Len(_aHeader)
	
		If nI == 1
			
			If _nTipo == 2 .OR. _nTipo == 4
				cColsAux := "{|| {	IIF( _aCols[oLbxAux:nAt,"+ cValtoChar(nI) +"] , oOk , oNo ) ,"
			Else
				cColsAux := "{|| {	_aCols[oLbxAux:nAt,"+ cValtoChar(nI) +"] ,"
			EndIf
			
		Else
			cColsAux += "		_aCols[oLbxAux:nAt,"+ cValtoChar(nI) +"] ,"
		EndIf
		
	Next nI
	
	//===========================================================================
	//| Atribui os dados ao ListBox                                             |
	//===========================================================================
	cColsAux		:= SubStr( cColsAux , 1 , Len(cColsAux)-1 ) + "}}"
	oLbxAux:bLine	:= &( cColsAux )

ACTIVATE MSDIALOG oDlg	ON INIT EnchoiceBar(oDlg,{ || EVAL(bOk,oDlg) },{ || EVAL(bCancel,oDlg) },,aButtons) CENTERED

Return( _lRet )

/*
=====================================================================================
Programa............: MGDBLCLK
Autor...............: Josué Danich Prestes
Data................: 18/07/2019
Descrição / Objetivo: Processa função do duplo click
===============================================================================================================================
*/
Static Function MGDBLCLK( oLbxDados , nTipo , _lSelUnc )

Local _nI			:= 0
Local _lSel			:= .T.

Default _lSelUnc	:= .F.

If nTipo == 2
	
	If _lSelUnc
		
		If oLbxDados:aArray[ oLbxDados:nAt , 01 ]
			_lSel := .T.
		Else
		
			For _nI := 1 To Len( oLbxDados:aArray )
				
				If oLbxDados:aArray[ _nI , 01 ]
				
					_lSel := .F.
					Exit
					
				EndIf
				
			Next _nI
		
		EndIf
	
	EndIf
	
	If _lSel
		oLbxDados:aArray[ oLbxDados:nAt , 01 ] := !oLbxDados:aArray[ oLbxDados:nAt , 01 ]
		oLbxDados:Refresh()
	EndIf

EndIf

Return()

/*
=====================================================================================
Programa............: MGOrdLbx
Autor...............: Josué Danich Prestes
Data................: 18/07/2019
Descrição / Objetivo: Rotina que processa a ordenação dos dados do ListBox
===============================================================================================================================
*/
Static Function MGOrdLbx( oX , nCol , oLbxAux , nTipo , _lSelUnc )

Local nI		:= 0
Default nTipo	:= 1

If nTipo == 2 .And. nCol == 1

	For nI := 1 To Len( oLbxAux:aArray )
		
		If _lSelUnc
			oLbxAux:aArray[nI][01] := .F.
		Else
			oLbxAux:aArray[nI][01] := !oLbxAux:aArray[nI][01]
		EndIf
	
	Next nI

ElseIf nTipo # 4

	If	Type("nITPosAnt") == "U"
		Return()
	EndIf
	
	If	nCol > 0
		
		If nCol <> nITPosAnt
			aSort( oLbxAux:aArray ,,, { |x,y| x[nCol] < y[nCol] } )
			nITPosAnt := nCol
		Else
			aSort( oLbxAux:aArray ,,, { |x,y| x[nCol] > y[nCol] } )
			nITPosAnt := 0
		EndIf
		
	EndIf

EndIf

oLbxAux:Refresh()

Return()

/*
=====================================================================================
Programa............: MGF3GEN
Autor...............: Josué Danich Prestes
Data................: 18/07/2019
Descrição / Objetivo: Função genérica que permite selecionar uma lista de itens conforme configuração informada
===============================================================================================================================
Parametros-------:
01 _cNomeSXB-----: Opção do Case               DEFAULT: 'F3_GENER'           Ex.: "F3_GENER"
02 _cTabela------: Nome da Tabela              DEFAULT: ''                   Ex.: "SA2" ou um "SELECT * FROM SA2010'"
03 _nCpoChave----: Posição do Campo Chave      DEFAULT: 2                    Ex.: SA2->(FIELDPOS("A2_COD")) ou {|| SA2->A2_COD+" "+SA2->A2_LOJA }
04 _nCpoDesc-----: Posição do Campo Descrição  DEFAULT: 3                    Ex.: SA2->(FIELDPOS("A2_NREDUZ")) ou {|| SA2->A2_NREDUZ }
05 _bCondTab-----: CodeBlock de Exceção        DEFAULT: {|| .T. }            Ex.: {|| SA3->A3_MSBLQL <> '1' }
06 _cTitAux------: Titulo da Janela            DEFAULT: ''                   Ex.: "Tipos de Informação"
07 _nTamChv------: Tamanho do Campo Chave      DEFAULT: 1                    Ex.: LEN(SA2->A2_COD)
08 _aDados-------: Array com as descrições     DEFAULT: {}                   Ex.: Função que retorna uma array (_aDados) ou uma String: "V=VENDA;R=REMESSA;O=OUTROS"
09 _nMaxSel------: Quantidade de Seleção       DEFAULT: 0                    Ex.: LEN(_aDados)
10 _lFilAtual----: Opção de ler as Filiais     DEFAULT: .T.                  Ex.: .T. : Le a Filial Atual , .F. : Le Todas as Filiais
11 _cMVRET-------: Nome do campo do ReadVar()  DEFAULT: Alltrim( ReadVar() ) Ex.: "MV_PAR01"
12 _bValida------: Executado antes da Tela     DEFAULT: {|| .T. }            Ex.: {|| IF(LEN(_aDados) > 0 , .T. , .F. ) }
13 _oProc--------: Obejeto do da função FWMSGRUN()
14 _aParam-------: Array equivalente a array _amarfrig_F3
 ================================================================================================================================================================================
Retorno---------: _lRet - Compatibilidade com o F3
================================================================================================================================================================================*/
//                          1           2         3           4           5          6           7         8          9         10           11        12        13       14
User Function MGF3GEN( _cNomeSXB , _cTabela ,_nCpoChave , _nCpoDesc , _bCondTab , _cTitAux , _nTamChv , _aDados , _nMaxSel , _lFilAtual , _cMVRET , _bValida , _oProc , _aParam )

Local _lRet			:= .F.
Local _aDadAux		:= {}
Local _cQuery		:= ''
Local _cAlias		:= ''
Local _cCodAux		:= ''
Local _cParDef		:= ''
Local _nI			:= 0
Local _cCombo		:= ""
Local _cTiposRef , _nX , nPosFil , _nConta:=0

Public _cRetorno	:= ""

DEFAULT _cNomeSXB := 'F3_GENER'
DEFAULT	_cTabela  := ''
DEFAULT	_nCpoChave:= 2
DEFAULT	_nCpoDesc := 3
DEFAULT	_bCondTab := {|| .T. }
DEFAULT	_cTitAux  := ''
DEFAULT	_nTamChv  := 1
DEFAULT	_aDados   := {}
DEFAULT	_nMaxSel  := 0
DEFAULT	_lFilAtual:= .T.
DEFAULT	_cMVRET	  := Alltrim( ReadVar() )
DEFAULT	_bValida  := {|| .T. }

IF TYPE("_cSeparador") <> "C"
   PRIVATE _cSeparador:=";"
ENDIF 

Do Case

	//Processamento de lista genérica de f3
	Case _cNomeSXB == 'F3_GENER'

        IF TYPE("_aParam") == "A"
           _amarfrig_F3 := ACLONE(_aParam)
	    ENDIF 
                                       //  _amarfrig_F3 := {}      1           2         3           4           5          6           7         8          9         10         11      12
        IF TYPE("_amarfrig_F3") == "A" //  AADD(_amarfrig_F3,{"TST_CAMPO",_cTabela ,_nCpoChave , _nCpoDesc , _bCondTab , _cTitAux , _nTamChv , _aDados , _nMaxSel , _lFilAtual,_cMVRET,_bValida})

		   FOR _nI := 1 TO LEN(_amarfrig_F3)

               IF UPPER(_cMVRET) == UPPER(_amarfrig_F3[_ni,1])
                  IF(_amarfrig_F3[_ni,02] # NIL  , _cTabela:=_amarfrig_F3[_ni,02],)
                  IF(LEN(_amarfrig_F3[_ni]) > 02 .AND. _amarfrig_F3[_ni,03] # NIL ,_nCpoChave := _amarfrig_F3[_ni,03],)
                  IF(LEN(_amarfrig_F3[_ni]) > 03 .AND. _amarfrig_F3[_ni,04] # NIL ,_nCpoDesc  := _amarfrig_F3[_ni,04],)
                  IF(LEN(_amarfrig_F3[_ni]) > 04 .AND. _amarfrig_F3[_ni,05] # NIL ,_bCondTab  := _amarfrig_F3[_ni,05],)
                  IF(LEN(_amarfrig_F3[_ni]) > 05 .AND. _amarfrig_F3[_ni,06] # NIL ,_cTitAux   := _amarfrig_F3[_ni,06],)
                  IF(LEN(_amarfrig_F3[_ni]) > 06 .AND. _amarfrig_F3[_ni,07] # NIL ,_nTamChv   := _amarfrig_F3[_ni,07],)
                  IF(LEN(_amarfrig_F3[_ni]) > 07 .AND. _amarfrig_F3[_ni,08] # NIL ,_aDados    := _amarfrig_F3[_ni,08],)
                  IF(LEN(_amarfrig_F3[_ni]) > 08 .AND. _amarfrig_F3[_ni,09] # NIL ,_nMaxSel   := _amarfrig_F3[_ni,09],)
                  IF(LEN(_amarfrig_F3[_ni]) > 09 .AND. _amarfrig_F3[_ni,10] # NIL ,_lFilAtual := _amarfrig_F3[_ni,10],)
                  IF(LEN(_amarfrig_F3[_ni]) > 10 .AND. _amarfrig_F3[_ni,11] # NIL ,_cMVRET    := _amarfrig_F3[_ni,11],)
                  IF(LEN(_amarfrig_F3[_ni]) > 11 .AND. _amarfrig_F3[_ni,12] # NIL ,_bValida   := _amarfrig_F3[_ni,12],)
               ENDIF

           NEXT

        ENDIF

        IF !EVAL(_bValida,"A",_aDados) // ANTES
           RETURN _cRetorno
        ENDIF

		IF !EMPTY(_cTabela) // TABELAS

           IF VALTYPE(_cTabela) == "B" .OR. "SELECT" $ _cTabela

		      _cAlias := GetNextAlias()

              IF VALTYPE(_cTabela) == "B" 
                 _cTabela:=EVAL(_cTabela)//Para os casos que o select dependa dos outros parametros
              ENDIF

		      DBUseArea( .T. , "TOPCONN" , TCGenQry(,,_cTabela) , _cAlias , .F. , .T. )
		      DBGOTOP() 

		      _lFilAtual := .F.
		      _cTabela   := _cAlias

		   ELSE

		      DBSELECTAREA(_cTabela)
		      DBGOTOP() 
		   
		      IF _lFilAtual
		         DBSeek( xFilial(_cTabela) ) 
		      ENDIF   
	       
		      nPosFil := FIELDPOS(IF(LEFT(_cTabela,1) == "S",SUBSTR(_cTabela,2),_cTabela )+"_FILIAL")
           
		   ENDIF

		   WHILE !EOF() .AND. (IF(_lFilAtual, (FIELDGET(nPosFil) == xFilial(_cTabela)) ,.T.))

		      IF EVAL(_bCondTab)
           
		         IF VALTYPE(_oProc) == "O"
                    _nConta++
                    _oProc:cCaption := ("Lendo dados da "+_cTabela+": "+ALLTRIM(STR(_nConta)))
                    ProcessMessages()
                 ENDIF   
           
		         IF 	VALTYPE(_nCpoChave) == "B"
		            	_cParDef += EVAL(_nCpoChave,_cTabela)
                 ELSEIF _lFilAtual
		            	_cParDef += FIELDGET(_nCpoChave)
		         ELSE   
		            	_cParDef += FIELDGET(nPosFil) + FIELDGET(_nCpoChave)
		         ENDIF

                 IF VALTYPE(_nCpoDesc) == "B"
		            AADD( _aDados , EVAL(_nCpoDesc,_cTabela) )
                 ELSE
		            AADD( _aDados , AllTrim( FIELDGET(_nCpoDesc) ) )
		         ENDIF   
		      
			  ENDIF   

		      DBSKIP()
		   
		   ENDDO
           
		   IF 		VALTYPE(_nCpoChave) == "B"
		      		DBSELECTAREA(_cTabela)
		      		DBGOTOP() 
		      		_nTamChv := LEN(EVAL(_nCpoChave,_cTabela))
           ELSEIF 	_lFilAtual
		      		_nTamChv := LEN(FIELDGET(_nCpoChave))
		   ELSE
		      		_nTamChv := LEN(FIELDGET(nPosFil)+FIELDGET(_nCpoChave))
		   ENDIF

		   IF _nMaxSel == 0
		      _nMaxSel := LEN(_aDados)
		   ENDIF   
		   
		   IF EMPTY(_cTitAux)
	         _cTitAux := ALLTRIM(FWX2Nome(_cTabela))
		   ENDIF

		ELSEIF !EMPTY(_aDados)//ARRAYS
           
           IF VALTYPE(_aDados) == "C"
		      _aDados := STRTOKARR(_aDados, ';')
		   ENDIF   

		   IF EMPTY(_cTitAux)
	          _cTitAux := "Lista de Opcoes"
		   ENDIF
		   
		   IF _nMaxSel == 0
		      _nMaxSel  := LEN(_aDados)
		   ENDIF   

		   FOR _ni := 1 TO LEN(_aDados)
            
			  IF VALTYPE(_oProc) == "O"
                 _nConta++
                 _oProc:cCaption := ("Lendo "+_cTitAux+": "+ALLTRIM(STR(_nConta))+" de "+ALLTRIM(STR(_nMaxSel)))
                 ProcessMessages()
              ENDIF   
			
			  _cParDef += SUBSTR(_aDados[_ni],1,_nTamChv)
		   
		   NEXT	

        ENDIF

        IF !EVAL(_bValida,"D",_aDados)//DEPOIS
           RETURN _cRetorno
        ENDIF

	//Lista filiais para seleção
	Case _cNomeSXB == 'LSTFIL'
   
   		_nTamChv   := 06
		_nMaxSel   := 40
		_cTitAux   := 'Filiais'
        _cFilSalva := cFilAnt
		aFilial    := FWAllFilial()

		For _nj := 1 to len(aFilial)
		
           _cParDef += cempant + AllTrim( afilial[_nj] )
           aAdd( _aDados , AllTrim( FWFilialName(cempant,cempant+afilial[_nj]) ))
		
		Next

	// Lista de "táticas" a serem selecionadas - Paulo da Mata - 01/04/2020
	Case _cNomeSXB == 'LSTZBF'
   
   		_nTamChv := 100
		_nMaxSel := 40
		
		ZBF->(dbSetOrder(1))
		ZBF->(dbGoTop())

		While ZBF->(!Eof())
		   AADD(_aDados,ZBF->ZBF_DESCRI)
		   ZBF->(dbSkip())
		EndDo   

EndCase 

If !Empty( _aDados )
   _lRet    := .T.
   &_cMVRET := MG_MNTTELSEL( _nTamChv , _nMaxSel , &_cMVRET , _cTitAux , _cParDef , _aDados )
   _cRetorno := &_cMVRET
EndIf

Return( _lRet )

/*
=====================================================================================
Programa............: MG_MNTTELSEL
Autor...............: Josué Danich Prestes
Data................: 18/07/2019
Descrição / Objetivo: Função que monta a tela para seleção de ítens via F3 de acordo com parâmetros recebidos
===============================================================================================================================
Parametros------: _nTamChv - Tamanho da Chave dos registros
----------------: _nMaxSel - Número máximo de registros que podem ser selecionados ao mesmo tempo
----------------: _cMVRET  - Nome da variável ou campo onde será gravado o retorno
----------------: _cTitAux - Título que será exibido na janela de seleção dos itens
----------------: _cParDef - String contendo os códigos dos itens que serão listados
----------------: _aDados  - Array contendo a descrição dos itens que serão listados
===============================================================================================================================
Retorno---------: _cRetAux - Lista de registros selecionados
===============================================================================================================================
*/

Static Function MG_MNTTELSEL( _nTamChv , _nMaxSel , _cMVRET , _cTitAux , _cParDef , _aDados )

Local _cRetAux	:= _cMVRET
Local _nI		:= 0
Local i

Private nTam       := _nTamChv //Tratamento para carregar variaveis da lista de opcoes
Private nMaxSelect := _nMaxSel //Define a quantidade máxima de itens que podem ser selecionados ao mesmo tempo
Private aCat       := aClone( _aDados )
Private MvPar      := ""
Private cTitulo    := _cTitAux
Private MvParDef   := _cParDef       

#IFDEF WINDOWS
	oWnd := GetWndDefault()
#ENDIF

//====================================================================================================
// Tratativa para carregar selecionados registros já marcados anteriormente
//====================================================================================================
If Len( AllTrim( _cRetAux ) ) == 0

	MvPar		:= PadR( AllTrim( StrTran( _cRetAux , ";" , "" ) ) , Len(aCat) )
	_cRetAux	:= PadR( AllTrim( StrTran( _cRetAux , ";" , "" ) ) , Len(aCat) )

Else

	MvPar  := AllTrim( StrTran( _cRetAux , ";" , "/" ) )

EndIf

//====================================================================================================
// Função que chama a tela de opções e só registra se usuário confirmar com "Ok"
//====================================================================================================
If F_Opcoes( @MvPar , cTitulo , aCat , MvParDef , 12 , 49 , .F. , nTam , nMaxSelect )

	_cRetAux := ""
	
	For i := 1 To Len(MvPar) Step nTam
	
		If !( SubStr( MvPar , i , 1 ) $ " |*" )
			_cRetAux += AllTrim(SubStr( MvPar , i , nTam ) +_cSeparador) //Separa os registros selecionados com ';'
		EndIf
		
	Next i
	
	_cRetAux := StrTran(SubStr( _cRetAux , 1 , Len( _cRetAux ) - 1 )," ","") //Trata para tirar o ultimo caracter

EndIf

Return( _cRetAux )

/*
=====================================================================================
Programa.:              MFConout
Autor....:              Josué Danich Prestes
Data.....:              03/07/2017
Descricao / Objetivo:   Função Counout personalizada
=====================================================================================
*/
User Function MFConout(_cMens)

Local _cfuncao := ""
Local _cambiente := GetEnvServer()

_cfuncao := procname(1) + " (" + strzero(procline(1),6)+")"

conout("[Thread " + strzero(ThreadID(),6) + "] - [" + _cfuncao + "] - [" + dtoc(date()) + " - " + time() + "] -[" + _cambiente + "]   -  [" + _cMens + "]")

Return

/*
===============================================================================================================================
Programa----------: MGFmsg()
Autor-------------: Josué Danich Prestes
Data da Criacao---: 03/07/2017
===============================================================================================================================
Descrição---------: Função mensagem personalizada
===============================================================================================================================
Parametros--------:   _cMens  - String a ser apresentado na mensagem
					  _ctitu  - String com título da mensagem
					  _csolu  - String a ser apresentado como solução
					  _ntipo  - número para escolher estilo e figura da mensagem
					  _nbotao - botão ok (1) ou botão ok e cancela (2)
					  _nmenbot  - Mensagem botões (1) Ok/Cancela (2) Sim/Não
					  _lHelpMvc - .T. chama função Help do MVC, .F. exibe tela customizada para a função MGFMSG.
					  _bMaisDetalhes - CodeBlock que será executado no botão "Mais Detalhes"
===============================================================================================================================
Retorno-----------: True ou False de acordo com botão ok/sim ou cancela/não escolhido
===============================================================================================================================
*/
User Function MGFmsg(_cMens,_ctitu,_csolu,_ntipo,_nbotao,_nmenbot,_lHelpMvc,_cbt1,_cbt2,_bMaisDetalhes)

Local _cfuncao 
Local _cambiente := GetEnvServer()
Local _lRet		:=	.T.
Local oFont		:=	TFont ():New ("Arial",, 15,, .F.)
Local cEstilo1,cEstilo2,cEstilo3 
Local _lret
Local _cmenok := "Ok"
Local _cmencan := "Cancela"
Local _cTextoMsg := ""
Local oDlg,_nProc
Local nConta:=0; aTipo:={""};   aArquivo:={""};   aLinha:={""};   aData:={""};   aHora:={""} ; bPilha:={||""}  ; cPilha:=""

Default _ctitu := "Alerta"
Default _cMens := "Mensagem não definida"
Default _csolu := ""
Default _ntipo := 0
Default _nbotao := 1
Default _nmenbot := 1
Default _lHelpMvc := .F.

Begin Sequence
//==========================================================================================================
// Caso a rotina seja chamada do MVC, chama a função Help padrão do MVC.
//==========================================================================================================
If _lHelpMvc
   _cTextoMvc := _cMens //+ " "

   Help( ,, _ctitu ,, _cTextoMvc , 1 , 0 ,,,,,,{_cSolu} )
   
   Break
EndIf

//==========================================================================================================
//Detecta se tela está montada, se não estiver manda it_conou (conout italac)
//==========================================================================================================
If !(isincallstack("MDIEXECUTE") .or. isincallstack("SIGAADV"))

	If empty(_csolu)
	
		u_MFConout("Mensagem - Titulo: [" + _ctitu + "] Mensagem: [" + _cMens + "]")
	
	Else
	
		u_MFConout("Mensagem - Titulo: [" + _ctitu + "] Mensagem: [" + _cMens + "] Solução: [" + _csolu + "]")
		
	Endif
	
	_lret := .F.
	Break
	
Endif


//==========================================================================================================
// Definição de estilos CSS
//==========================================================================================================
//Janela 
cEstilo0 := "TDialog { " 
cEstilo0 += " background-color: #FFFFFF;"
cEstilo0 += " font: bold 12px Arial;"
cEstilo0 += " padding: 6px};"



//Botão OK
cEstilo1 := "QPushButton {"  
cEstilo1 += " background-image: url(rpo:ok.png);background-repeat: none; margin: 2px;" 
cEstilo1 += " border-style: outset;"
cEstilo1 += " border-width: 2px;"
cEstilo1 += " border: 1px solid #C0C0C0;"
cEstilo1 += " border-radius: 5px;"
cEstilo1 += " border-color: #C0C0C0;"
cEstilo1 += " font: bold 12px Arial;"
cEstilo1 += " padding: 6px;"
cEstilo1 += "}"
cEstilo1 += "QPushButton:pressed {"
cEstilo1 += " background-color: #e6e6f9;"
cEstilo1 += " border-style: inset;"
cEstilo1 += "}"

//Botão Cancel 
cEstilo2 := "QPushButton {background-image: url(rpo:cancel.png);background-repeat: none; margin: 2px; "
cEstilo2 += " border-style: outset;"
cEstilo2 += " border-width: 2px;"
cEstilo2 += " border: 1px solid #C0C0C0;"
cEstilo2 += " border-radius: 5px;"
cEstilo2 += " border-color: #C0C0C0;"
cEstilo2 += " font: bold 12px Arial;"
cEstilo2 += " padding: 6px;"
cEstilo2 += "}"
cEstilo2 += "QPushButton:pressed {"
cEstilo2 += " background-color: #e6e6f9;"
cEstilo2 += " border-style: inset;"
cEstilo2 += "}"
 
//Quadro de função  
cEstilo3 := "QLabel { " 
cEstilo3 += " border-style: outset;"
cEstilo3 += " border-width: 2px;"
cEstilo3 += " border: 1px solid #C0C0C0;"
cEstilo3 += " border-radius: 5px;"
cEstilo3 += " border-color: #C0C0C0;"
cEstilo3 += " background-color: #FFFFFF;"
cEstilo3 += " font: bold 12px Arial;"
cEstilo3 += " padding: 6px};"

//Quadro de mensagem e solução   
cEstilo11 := "QLabel { " 
cEstilo11 += " border-style: none;"
cEstilo11 += " border-width: 2px;"
cEstilo11 += " border: none;"
cEstilo11 += " border-radius: 5px;"
cEstilo11 += " border-color: #C0C0C0;"
cEstilo11 += " background-color: #FFFFFF;"
cEstilo11 += " font: 12px Arial;"
cEstilo11 += " padding: 6px};"
 
//Mensagem e solução     
cEstilo4 := "QLabel { " 
cEstilo4 += " font: bold 12px Arial;"
cEstilo4 += " background-color: #FFFFFF;"
cEstilo4 += " padding: 2px};"

cEstiloMD:= "QPushButton {"  
//cEstiloMD+= " background-image: url(rpo:ok.png);background-repeat: none; margin: 2px;" 
cEstiloMD+= " border-style: outset;"
cEstiloMD+= " border-width: 2px;"
cEstiloMD+= " border: 1px solid #C0C0C0;"
cEstiloMD+= " border-radius: 5px;"
cEstiloMD+= " border-color: #C0C0C0;"
cEstiloMD+= " font: bold 12px Arial;"
cEstiloMD+= " padding: 6px;"
cEstiloMD+= "}"
cEstiloMD+= "QPushButton:pressed {"
cEstiloMD+= " background-color: #e6e6f9;"
cEstiloMD+= " border-style: inset;"
cEstiloMD+= "}"

//=============================================================================
//Monta string com programa e função
//=============================================================================
IF IsInCallStack("U_MT_ITMSG") 
   _nProc:=2
ELSE
   _nProc:=1
ENDIF
If empty(funname())

  _cfuncao := procname(1) + " - Linha " + strzero(procline(1),6)

Else

  _cfuncao := funname() + " - " + procname(_nProc) + " - Linha " + strzero(procline(_nProc),6)
  
Endif 

nConta:=0; cPilha:=""

//Faz 5 interações sem loop
aTipo:={};   aArquivo:={};   aLinha:={};   aData:={};   aHora:={}
GetFuncArray( PROCNAME(nConta),@aTipo,@aArquivo,@aLinha,@aData,@aHora)
IF TYPE("aData[1]") = "D" .AND. TYPE("aLinha[1]") = "C" .AND. VAL(aLinha[1]) > 0
   cPilha+="Chamado de "+PROCNAME(nConta)+" ("+aArquivo[1]+") "+DTOC(aData[1])+" "+aHora[1]+" linha " +aLinha[1]+ENTER
ENDIF   
aTipo:={};   aArquivo:={};   aLinha:={};   aData:={};   aHora:={};nConta++
GetFuncArray( PROCNAME(nConta),@aTipo,@aArquivo,@aLinha,@aData,@aHora)
IF TYPE("aData[1]") = "D" .AND. TYPE("aLinha[1]") = "C" .AND. VAL(aLinha[1]) > 0
   cPilha+="Chamado de "+PROCNAME(nConta)+" ("+aArquivo[1]+") "+DTOC(aData[1])+" "+aHora[1]+" linha " +aLinha[1]+ENTER
ENDIF   
aTipo:={};   aArquivo:={};   aLinha:={};   aData:={};   aHora:={};nConta++
GetFuncArray( PROCNAME(nConta),@aTipo,@aArquivo,@aLinha,@aData,@aHora)
IF TYPE("aData[1]") = "D" .AND. TYPE("aLinha[1]") = "C" .AND. VAL(aLinha[1]) > 0
   cPilha+="Chamado de "+PROCNAME(nConta)+" ("+aArquivo[1]+") "+DTOC(aData[1])+" "+aHora[1]+" linha " +aLinha[1]+ENTER
ENDIF   
aTipo:={};   aArquivo:={};   aLinha:={};   aData:={};   aHora:={};nConta++
GetFuncArray( PROCNAME(nConta),@aTipo,@aArquivo,@aLinha,@aData,@aHora)
IF TYPE("aData[1]") = "D" .AND. TYPE("aLinha[1]") = "C" .AND. VAL(aLinha[1]) > 0
   cPilha+="Chamado de "+PROCNAME(nConta)+" ("+aArquivo[1]+") "+DTOC(aData[1])+" "+aHora[1]+" linha " +aLinha[1]+ENTER
ENDIF   
aTipo:={};   aArquivo:={};   aLinha:={};   aData:={};   aHora:={};nConta++
GetFuncArray( PROCNAME(nConta),@aTipo,@aArquivo,@aLinha,@aData,@aHora)
IF TYPE("aData[1]") = "D" .AND. TYPE("aLinha[1]") = "C" .AND. VAL(aLinha[1]) > 0
   cPilha+="Chamado de "+PROCNAME(nConta)+" ("+aArquivo[1]+") "+DTOC(aData[1])+" "+aHora[1]+" linha " +aLinha[1]+ENTER
ENDIF   

bPilha:={||  AVISO("Pilha de chamadas",cPilha,{"Fechar"},3) }


//=============================================================================
//Monta tamanho da tela de mensagem de acordo com parâmetros
//=============================================================================

_ncini := 0   //coluna inicial da janela
_nlini := 0   //linha inicial da janela

_ncfim := 576 //coluna final da janela
_nlfim := 430 //linha final da janela

_ncbok := 170 //coluna do botao de ok
_ncbcancel := 220  //coluna do botão de cancelar 

IF _nbotao == 2
   _ncfuncin := 160 //largura do campo de função
ELSE
   _ncfuncin := 205 //largura do campo de função
ENDIF

If _nmenbot == 2 //Ajusta texto dos botões se tiver parâmetro diferente do default (Ok/Cancela)

	_cmenok := "Sim"
	_cmencan := "Não"
	
Endif

If _nmenbot == 3 //Ajusta texto dos botões se tiver parâmetro diferente do default (texto personalizado)

	_cmenok := _cbt1
	_cmencan := _cbt2
	
Endif

If !empty(_csolu)

	_lincone := 30 //linha do icone
	_nlinbot := 185 //linha dos botões
	
Else

	_lincone := 03
	_nlinbot := 110
	_nlfim := 290
	
Endif


If _ntipo == 0

	_ncfim := 450
	_ncbok := 100
	_ncbcancel := 150
    IF _nbotao == 2
	   _ncfuncin := 090
	ELSE   
	   _ncfuncin := 140
	ENDIF   
	
Endif

If _nbotao == 1 //Se só tem botão de ok posiciona o ok na coluna do cancel

	_ncbok := _ncbcancel
	
Endif

//=============================================================================
//Monta tela
//=============================================================================

oDlg = TDialog():New( _nlini,_ncini, _nlfim,_ncfim, _ctitu ,,,,, CLR_BLACK,CLR_WHITE ,,,.T.,,,,,, )
oDlg:SetCss(cEstilo0)  
    
 
    //==========================================================================
    //Box de mensagem
    //==========================================================================
    
  	IF VALTYPE(_bMaisDetalhes) = "B" 
       oBtnMD:= TButton():New(50,03,"Mais Detalhes" ,oDlg,{|| EVAL(_bMaisDetalhes) },53,15,,,.F.,.T.,.F.,,.F.,,,.F. )
       oBtnMD:SetCss(cEstiloMD) 
       nLinFim:=42
    ELSE
       nLinFim:=60
    ENDIF

  	oSay1:= TSay():New(03,03,{||"Mensagem"},oDlg,,,,,,.T.,,,205,nLinFim,,,,,,.T.) 
  	oSay1:SetCss(cEstilo3) 

  	oSay11:= TSay():New(15,05,{||_cMens},oDlg,,,,,,.T.,,,200,(nLinFim-13),,,,,,.T.) 
  	oSay11:SetCss(cEstilo11) 
  	
  	//==========================================================================
    //Box de solução
    //==========================================================================
  	If !empty(_csolu)
  	  	
  		oSay3:= TSay():New(70,03,{||"Solução"},oDlg,,,,,,.T.,,,205,70,,,,,,.T.) 
  		oSay3:SetCss(cEstilo3)
  		
  		oSay33:= TSay():New(82,05,{||_csolu},oDlg,,,,,,.T.,,,200,55,,,,,,.T.) 
  		oSay33:SetCss(cEstilo11)
  
  		
  	Endif 
  	
  	
  	//==========================================================================
    //Ícone
    //==========================================================================
  	
  	If _ntipo == 1
  	
  	 	oTBitmap1 := TBitmap():New(_lincone,215,63,275,,"\data\italac\img\cancel.png",.T.,oDlg,;
  	 	{||},,.F.,.F.,,,.F.,,.T.,,.F.)
  	 	oTBitmap1:SetCss(cEstilo4)
  	 	
  	Endif 
  	
  	If _ntipo == 2
  	
  	 	oTBitmap1 := TBitmap():New(_lincone,215,63,275,,"\data\italac\img\ok.png",.T.,oDlg,;
  	 	{||},,.F.,.F.,,,.F.,,.T.,,.F.)
  	 	oTBitmap1:SetCss(cEstilo4)
  	 	
  	Endif 
   	
  	If _ntipo == 3
  	
  	 	oTBitmap1 := TBitmap():New(_lincone,215,63,275,,"\data\italac\img\alert.png",.T.,oDlg,;
  	 	{||},,.F.,.F.,,,.F.,,.T.,,.F.)
  	 	oTBitmap1:SetCss(cEstilo4)
  	 	
  	Endif 
  	
  	//==========================================================================
    //Box de função
    //==========================================================================
   	oSay4:= TSay():New(_nlinbot-38,03,{||"      "+_cfuncao},oDlg,,,,,,.T.,,,_ncfuncin,58,,,,,,.T.) 
  	oSay4:SetCss(cEstilo3) 

  	//==========================================================================
    //Botão OK/Sim
    //==========================================================================
    oBtnOK 		:= TButton():New(_nlinbot,_ncbok,_cmenok	    ,oDlg,{|| _lret := .T. , oDlg:end() },50,20,,,.F.,.T.,.F.,,.F.,,,.F. )
    oBtnOK:SetCss(cEstilo1) 
    
    //==========================================================================
    //Box Cancela/Não
    //==========================================================================
    If _nbotao == 2
    
    	oBtnCan 	:= TButton():New(_nlinbot,_ncbcancel,_cmencan	,oDlg,{|| _lret := .F. , oDlg:end() },60,20,,,.F.,.T.,.F.,,.F.,,,.F. )
    	oBtnCan:SetCss(cEstilo2)
    	
    Endif

  	//==========================================================================
    //Botão das pilhas de chamada
    //==========================================================================
    oBtnMD:= TButton():New(_nlinbot-38,04,"..." ,oDlg,bPilha,10,10,,,.F.,.T.,.F.,,.F.,,,.F. )
    oBtnMD:SetCss(cEstiloMD) 
     
   oDlg:Activate( , , , .T. )
      
End Sequence

Return _lret

/*
============================================================================================
Programa............: MGF_XJOB
Autor...............: Josué Danich Prestes
Data................: 11/09/2020
Descrição / Objetivo: Execucao de job Master/Slave para economia de rpcsetenv
Parametros..........: _ntipo - 1 Master sobe rpcsetenv e fica disponível para chamadas
                               2 Slave - chama função indicada com ipcgo na thread do master
					  _cnome - Nome do Job
					  _cfuncao - userfunction que será chamada
=============================================================================================
*/
User Function MGF_XJOB(_ntipo,_cnome,_cfuncao,xPar01,xPar02,xPar03,xPar04,xPar05,xPar06,xPar07,xPar08,xPar09,xPar10)


Local _lret
Local _cpars := ""
Local _cmostra := ""
Local _ntempo := 0
Local _nvezes := 0

Default _ntipo := "2"
Default _cnome := "INDEFINIDO"
Default _cfuncao := "INDEFINIDO"
Default xPar01 := ""
Default xPar02 := ""
Default xPar03 := ""
Default xPar04 := ""
Default xPar05 := ""
Default xPar06 := ""
Default xPar07 := ""
Default xPar08 := ""
Default xPar09 := ""
Default xPar10 := ""

//monta parametros
If valtype(xpar01) = "C" .and. !empty(xpar01)
	_cpars += " xpar01 "
	_cmostra += "'" + xpar01 + "'"
Endif
If valtype(xpar02) = "C" .and. !empty(xpar02)
	_cpars += " ,xpar02 "
	_cmostra += ",'" + xpar02 + "'"
Endif
If valtype(xpar03) = "C" .and. !empty(xpar02)
	_cpars += " ,xpar03 "
	_cmostra += ",'" + xpar03 + "'"
Endif
If valtype(xpar04) = "C" .and. !empty(xpar02)
	_cpars += " ,xpar04 "
	_cmostra += ",'" + xpar04 + "'"
Endif
If valtype(xpar05) = "C" .and. !empty(xpar02)
	_cpars += " ,xpar05 "
	_cmostra += ",'" + xpar05 + "'"
Endif
If valtype(xpar06) = "C" .and. !empty(xpar02)
	_cpars += " ,xpar06 "
	_cmostra += ",'" + xpar06 + "'"
Endif
If valtype(xpar07) = "C" .and. !empty(xpar02)
	_cpars += " ,xpar07 "
	_cmostra += "'" + xpar07 + "'"
Endif
If valtype(xpar08) = "C" .and. !empty(xpar02)
	_cpars += " ,xpar08 "
	_cmostra += ",'" + xpar08 + "'"
Endif
If valtype(xpar09) = "C" .and. !empty(xpar02)
	_cpars += " ,xpar09 "
	_cmostra += ",'" + xpar09 + "'"
Endif
If valtype(xpar10) = "C" .and. !empty(xpar02)
	_cpars += " ,xpar10 "
	_cmostra += ",'" + xpar10 + "'"
Endif

_cexecuta := "U_"+_cfuncao + "(" + _cpars + ")"
_cmostra := "U_"+_cfuncao + "(" + _cmostra + ")"

If _ntipo == "1" //Execução de master que fica aguardando chamadas slave já com o ambiente montado

	U_MFCONOUT("Abrindo job master: " + _cnome + "...")

	PREPARE ENVIRONMENT EMPRESA '01' FILIAL '010041'

	_ntempo := getmv("MGF_XJOBT",,5000)
	_nvezes := getmv("MGF_XJOBV",,720)
	_nii := 1

 	Do while !killapp() .and. _nii <= _nvezes 
    
		U_MFCONOUT("Aguardando chamadas para job master: " + _cnome + " - " + strzero(_nii,6) + " de " + strzero(_nvezes,6) + "...")
		_nii++
		
		lRet := IpcWaitEx( _cnome, 5000, @_cfuncao, @xPar01,@xPar02,@xPar03,@xPar04,@xPar05,@xPar06,@xPar07,@xPar08,@xPar09,@xPar10 )
    
		if lRet

			//monta parametros
			_cpars := ""
			_cmostra := ""
			If valtype(xpar01) = "C" .and. !empty(xpar01)
				_cpars += " xpar01 "
				_cmostra += "'" + xpar01 + "'"
			Endif
			If valtype(xpar02) = "C" .and. !empty(xpar02)
				_cpars += " ,xpar02 "
				_cmostra += ",'" + xpar02 + "'"
			Endif
			If valtype(xpar03) = "C" .and. !empty(xpar02)
				_cpars += " ,xpar03 "
				_cmostra += ",'" + xpar03 + "'"
			Endif
			If valtype(xpar04) = "C" .and. !empty(xpar02)
				_cpars += " ,xpar04 "
				_cmostra += ",'" + xpar04 + "'"
			Endif
			If valtype(xpar05) = "C" .and. !empty(xpar02)
				_cpars += " ,xpar05 "
				_cmostra += ",'" + xpar05 + "'"
			Endif
			If valtype(xpar06) = "C" .and. !empty(xpar02)
				_cpars += " ,xpar06 "
				_cmostra += ",'" + xpar06 + "'"
			Endif
			If valtype(xpar07) = "C" .and. !empty(xpar02)
				_cpars += " ,xpar07 "
				_cmostra += "'" + xpar07 + "'"
			Endif
			If valtype(xpar08) = "C" .and. !empty(xpar02)
				_cpars += " ,xpar08 "
				_cmostra += ",'" + xpar08 + "'"
			Endif
			If valtype(xpar09) = "C" .and. !empty(xpar02)
				_cpars += " ,xpar09 "
				_cmostra += ",'" + xpar09 + "'"
			Endif
			If valtype(xpar10) = "C" .and. !empty(xpar02)
				_cpars += " ,xpar10 "
				_cmostra += ",'" + xpar10 + "'"
			Endif

			_cexecuta := "U_"+_cfuncao + "(" + _cpars + ")"
			_cmostra := "U_"+_cfuncao + "(" + _cmostra + ")"

 			U_MFCONOUT("Recebeu chamada para job master: " + _cmostra + "...")
			&_cexecuta
			U_MFCONOUT("Completou chamada para job master: " + _cmostra + "...")
 
     	endif
  
  	Enddo

	RpcClearEnv()

Elseif _ntipo == "2" //Execução de slave que envia execução de job para thread do master 

	U_MFCONOUT("Enviando chamada para job master " + _cnome + ": " + _cmostra + "...")
	
	_lret := IPCGo( _cnome, _cfuncao,xPar01,xPar02,xPar03,xPar04,xPar05,xPar06,xPar07,xPar08,xPar09,xPar10 )

	If _lret

		U_MFCONOUT("Chamada para job master " + _cnome + ": " + _cmostra + " iniciada com sucesso.")

	Else

		U_MFCONOUT("Chamada para job master " + _cnome + ": " + _cmostra + " não encontrou job master disponível.")

	Endif

Endif


Return

/*
============================================================================================
Programa............: MGF_NOAC
Autor...............: Josué Danich Prestes
Data................: 11/09/2020
Descrição / Objetivo: Retira caracteres especiais de string enviado
Parametros..........: cstring - string que terá os caracteres especiais retirados
=============================================================================================
*/
User FUNCTION MGF_NOAC(cString)
	Local cChar  := ""
	Local nX     := 0
	Local nY     := 0
	Local cVogal := "aeiouAEIOU"
	Local cAgudo := "áéíóú"+"ÁÉÍÓÚ"
	Local cCircu := "âêîôû"+"ÂÊÎÔÛ"
	Local cTrema := "äëïöü"+"ÄËÏÖÜ"
	Local cCrase := "àèìòù"+"ÀÈÌÒÙ"
	Local cTio   := "ãõÃÕ"
	Local cCecid := "çÇ"
	Local cMaior := "&lt;"
	Local cMenor := "&gt;"
	Local cxBol1 := "Â°"
	Local cxBol2 := "°"
	Local _cexcep := getmv("MGF_NOACE",,"|.$%,/:")

	cSring := StrTran(cString,cxBol1,".")
	cSring := StrTran(cString,cxBol2,".")

	For nX:= 1 To Len(cString)
		cChar:=SubStr(cString, nX, 1)
		IF cChar$cAgudo+cCircu+cTrema+cCecid+cTio+cCrase
			nY:= At(cChar,cAgudo)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf
			nY:= At(cChar,cCircu)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf
			nY:= At(cChar,cTrema)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf
			nY:= At(cChar,cCrase)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf
			nY:= At(cChar,cTio)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr("aoAO",nY,1))
			EndIf
			nY:= At(cChar,cCecid)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr("cC",nY,1))
			EndIf
		Endif
	Next

	If cMaior$ cString
		cString := strTran( cString, cMaior, "" )
	EndIf
	If cMenor$ cString
		cString := strTran( cString, cMenor, "" )
	EndIf

	cString := StrTran( cString, CRLF, " " )

	For nX:=1 To Len(cString)
		cChar:=SubStr(cString, nX, 1)
		If !(Asc(cChar) == 32 .OR. (Asc(cChar) >= 48 .AND. Asc(cChar) <= 57); //espaço e 0-9
						  .Or. (Asc(cChar) >= 65 .AND. Asc(cChar) <= 90); //a-z
						  .Or. (Asc(cChar) >= 97 .AND. Asc(cChar) <= 122); //A-Z
						    ) .and. !cChar $ _cexcep //Exceções
			cString:=StrTran(cString,cChar,".")
		Endif
	Next nX
Return cString

