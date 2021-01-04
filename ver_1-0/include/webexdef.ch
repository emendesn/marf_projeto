
#TRANSLATE HttpGetValue(<x1> [ , <x2> ] ) => IIf( <x1> != NIL , <x1> , <x2> )
            
#TRANSLATE HtmlProcId( [<x>] ) => MkProcId( <x> )

#XCOMMAND WEB INIT <cHtml> USING <_P1> , <_P2> , <_P3> , <_P4> ;
         [ TABLES <aFiles,...>] ;
         [ TIMEOUT <tOut>] ;
         [ START <cInit>] ;
         [ CACHE <cId>] ;
         [ EXPIRES <cExpKey>] ;
         [ <lKill: NOTHREAD> ] => ;
         BEGIN SEQUENCE ;;
         If !WebEnvSet(@<_P1>,@<_P2>,@<_P3>,@<_P4>,@<cHtml>, [\{ <aFiles> \} ] , [<tOut> ] , [<cInit> ], [<cId> ] , [<cExpKey> ] , [<.lKill.>]) ;;
            Return <cHtml> ;;
         Endif 
         
#XCOMMAND WEB END <cHtml> => ;
         END SEQUENCE;;
         WebHtmRet( @<cHtml> )

#XCOMMAND OPEN QUERY <cQuery> ALIAS <cAlias> => WebOpenQuery(<cQuery>,<cAlias>)

#XCOMMAND CLOSE QUERY <cAlias> => ;
         WebCloseQuery(<cAlias>)
         
#TRANSLATE ChangeQuery(<xis>)   => <xis>

#xcommand OPEN WEB TABLES <aRpcTables,...>  ;
                 [ RESULT <lResult> ]       ;
            => [<lResult>:=] WebOpenTable ( \{ <aRpcTables> \} )

#XCOMMAND WEB EXTENDED INIT <cHtml> ;
                [ START <cFnStart> ] ;
            => If WebExInit( @<cHtml> , <cFnStart> )
            
#XCOMMAND WEB EXTENDED END ;
            => Endif

/* Comandos de Preparação de ambiente Hypersite */

#XCOMMAND PREPARE HYPERENV ;
				[ EMP <cEmp> ] ;
				[ FILIAL <cFil> ] ;
				=> HsSetEnv( <cEmp> , <cFil> ) 

#XCOMMAND PREPARE HYPERTOP RESULT <nStatus> => ; 
	<nStatus> := HsConnect()

#XCOMMAND PREPARE HYPERSXS RESULT <lOpenOk> => ; 
	<lOpenOk> := HSOpenSxs()

#XCOMMAND GET HYPERSXS ERROR <cError> => ; 
	<cError> := GetSxError()

#XCOMMAND CLOSE HYPERENV => HSClearEnv()


// -------------   Definicoes Browse e Enchoice EXTENDED ------------

// Definição do Objeto ApData

#DEFINE WXOBJ__DEFINE	18

#DEFINE WXOBJ_ALIAS		1			// Alias do Browse
#DEFINE WXOBJ_TITLE		2			// Titulo do Browse
#DEFINE WXOBJ_ROWS		3			// Numero de linhas do Browse
#DEFINE WXOBJ_WBRSKIN	4			// Skin para utilização em Browse
#DEFINE WXOBJ_WCHSKIN	5			// Skin para utilização em Enchoice
#DEFINE WXOBJ_ORDER		6			// Ordem de indexação do Arquivo
#DEFINE WXOBJ_TOPKEY		7			// String Chave de Topo de Arquivo
#DEFINE WXOBJ_BOTTOMKEY	8			// String Chave de Fim de Arquivo
#DEFINE WXOBJ_FILTER		9			// Condição Advpl de Filtro
#DEFINE WXOBJ_WBRACTION	10			// Acao atual do Browse
#DEFINE WXOBJ_WCHACTION	11			// Acao atual da Enchoice
#DEFINE WXOBJ_RECNO		12			// Ponteiro de Registro atual
#DEFINE WXOBJ_FIRSTROW	13			//	Primeiro registro valido para a página ( Browse )
#DEFINE WXOBJ_LASTROW	14			//	Ultimo Registro Válido para a página ( Browse )
#DEFINE WXOBJ_ID			15			//	ID do Objeto
#DEFINE WXOBJ_CALL		16			// Funcao de Retorno Default do Objeto
#DEFINE WXOBJ_FINDKEY	17			// Chave para busca  ( Browse )
#DEFINE WXOBJ_CARGO		18			// Informações CARGO

/* --------------------------------------------------------------------------
ACTION - BROWSE		0 = REFRESH
							1 = PRIMEIRA
							2 = ANTERIOR
							3 = PROXIMA
							4 = ULTIMA

ACTION - ENCHOICE		1 = VISUALIZAR
							2 = INCLUIR
							3 = ALTERAR
							4 = EXCLUIR
-------------------------------------------------------------------------- */

// Definição das colunas oHeader

#DEFINE WXOBJ_HEAD__DEFINE	16

#DEFINE WXOBJ_HEAD_TITULO   1			// Titulo da Columa
#DEFINE WXOBJ_HEAD_CAMPO    2 		// Nome do Campo / Expresao
#DEFINE WXOBJ_HEAD_TIPO     3			// Tipo do Campo (C/N/D/L)
#DEFINE WXOBJ_HEAD_TAMANHO  4 		// Tamanho do Conteudo do Campo
#DEFINE WXOBJ_HEAD_DECIMAL  5 		// Numero de Casas Decimais
#DEFINE WXOBJ_HEAD_PICTURE  6  		// Picture de Visualizacao Advpl
#DEFINE WXOBJ_HEAD_WIDTH    7			// Tamanho da Coluna em PIXELS
#DEFINE WXOBJ_HEAD_VLDJAVA  8			// Validacao JavaScript
#DEFINE WXOBJ_HEAD_CHECK    9			// Propriedades CHECK
#DEFINE WXOBJ_HEAD_ARQUIVO  10		// Arquivo (Alias) relaconado ao campo 
#DEFINE WXOBJ_HEAD_CONTEXT  11		// Contexto ( V=virtual )
#DEFINE WXOBJ_HEAD_VALUE  	 12		// Valor Inicial do Campo
#DEFINE WXOBJ_HEAD_COMBO  	 13		// Conteudo de Combo BOX
#DEFINE WXOBJ_HEAD_BROWSE 	 14		// Coluna deve ser mostrada em Browse
#DEFINE WXOBJ_HEAD_RELACAO	 15		// Expressão Advpl de Inicialização de Value
#DEFINE WXOBJ_HEAD_HTMLTAG	 16		// Exporessão Html a acrescentar p/ Enchoice

// Comandos relacionados - WXOBJ

#XCOMMAND CREATE WXOBJ <oApData> ;
		[ ALIAS <cAlias> ] ;
		[ ORDER <nOrder> ] ;
		[ TITLE <cTitulo> ] ;
		[ ID <cObjId> ] ;
		[ CARGO <xCargo> ] ;
		[<rec: RECOVER>]  ;
		[ USING <aProc> , <aPost> ] ;
		=> <oApData> := WXOBJ_NEW( <cAlias> , <nOrder> , <cTitulo> ,;
											 <cObjId> , <xCargo> , <.rec.> , <aProc> , <aPost> )

#XCOMMAND RECOVER WXOBJ <oApData> ; 
		[ ID <cId> ] ; 
		[ USING <aProc>,<aPost> ] ;
		=> WXOBJ_Recover(@<oApData> , <aProc> , <aPost> )

#XCOMMAND CREATE WXHEADER <oHeader> ;
			[ HYPERSITE <cAlias> ] ; 
		=> <oHeader> := WXOBJ_NEWH(<cAlias>)

#XCOMMAND AADD 	WXCOLUMN IN <oHeader> ;
						[ TITLE <cTitulo> ] ;
						[ FIELD <cCampo> ] ; 
						[ TYPE <cTipo> ] ; 
						[ LENGTH <nTam> ] ; 
						[ DECIMALS <nDec> ] ; 
						[ PICTURE <cPict> ] ; 
						[ PIXELS <nPixels> ] ; 
						[ VLDJAVA <cVldJava> ] ; 
						[ CHECK <cCheck> ] ; 
						[ ALIAS <cAlias> ] ;
						[ CONTEXT <cContext> ] ;
						[ VALUE <cValue> ] ;
						[ COMBO  <cComboStr> ] ;
						[ RELACAO <cRelacao> ] ;
						[ HTMLTAG <cHtmlTag> ] ;
						[<nob: NOBROWSE>]  ;
						[<ava: AUTOVALID>]  ;
		=> WXOBJ_ADDCOL( @<oHeader> , 	 ;
								<cTitulo> ,		;
								<cCampo> ,		;
								<cTipo> ,		;
								<nTam> ,			;
								<nDec> ,			;
								<cPict> ,		;
								<nPixels> ,		;
								<cVldJava> ,	;
								<cCheck> ,		;
								<cAlias> ,		; 	
								<cContext> ,	;
								<cValue> ,		;
								<cComboStr> ,	;
								<cRelacao> ,	;
								<.nob.> ,		;
								<cHtmlTag> ,	;
								<.ava.> 	)

// Comandos relacionados - WxBrowse

#XCOMMAND UPDATE WXBRROWSE <oApData> ;
		[ ROWS <nLinhas> ] ;
		[ SKIN <cSkin> ] ;
		[ TOPLIMIT <cTopLm> ] ;
		[ BOTTOMLIMIT <cBottomLm> ] ;
		[ FILTER <cFilterExp> ] ;
		=> WxBrw_Upd(@<oApData> ,<nLinhas>,<cSkin>,<cTopLm>,<cBottomLm>,<cFilterExp>)

#XCOMMAND PROCESS WXBROWSE <oApData> ;
		TO <cHtml> ; 
		HEADER <oHeader> ;
		BUTTON <oWebRotina> ;
		[ ROWS <nLinhas> ] ;
		[ SKIN <cSkin> ] ;
		[ TOPLIMIT <cTopLm> ] ;
		[ BOTTOMLIMIT <cBottomLm> ] ;
		[ FILTER <cFilterExp> ] ;
		[ CALL <cCall> ] ; 
		[<noform: NOFORM>]  ;
		=> WxBrw_EXEC( @<cHtml> , <oApData> , <oHeader> , <oWebRotina> ,<nLinhas>,<cSkin>,<cTopLm>,<cBottomLm>,<cFilterExp>,<cCall>,<.noform.>)

// Comandos relacionados - WxChoice

#XCOMMAND LOAD WXCHOICE <oWChoice> ;
		HEADER <oHeader> ;
		[ RECNO <nRecno> ] ;
		[ ACTION <cAction> ] ;
		=> WxWch_Load( @<oWChoice> , @<oHeader> , <nRecno> , <cAction> )

#XCOMMAND UPDATE WXCHOICE <oApData> ;
		[ SKIN <cSkin> ] ;
		=> WxWch_Upd(@<oApData> ,<cSkin> )

#XCOMMAND UPDATE WXHEADER <oHeader> ;
		FIELD <cField> ;
		[ TITLE <cTitulo> ] ;
		[ TYPE <cTipo> ] ; 
		[ LENGTH <nTam> ] ; 
		[ DECIMALS <nDec> ] ; 
		[ PICTURE <cPict> ] ; 
		[ PIXELS <nPixels> ] ; 
		[ VLDJAVA <cVldJava> ] ; 
		[ CHECK <cCheck> ] ; 
		[ ALIAS <cAlias> ] ;
		[ CONTEXT <cContext> ] ;
		[ VALUE <cValue> ] ;
		[ COMBO  <cComboStr> ] ;
		[ RELACAO <cRelacao> ] ;
		[ HTMLTAG <cHtmlTag> ] ;
		[<nob: NOBROWSE>]  ;
		=> WxWch_HUpd( 	@<oHeader> , 	 ;
								<cField> ,		;
								<cTitulo> ,		;
								<cTipo> ,		;
								<nTam> ,			;
								<nDec> ,			;
								<cPict> ,		;
								<nPixels> ,		;
								<cVldJava> ,	;
								<cCheck> ,		;
								<cAlias> ,		; 	
								<cContext> ,	;
								<cValue> ,		;
								<cComboStr> ,	;
								<cRelacao> ,	;
								<.nob.> ,		;
								<cHtmlTag> )

#XCOMMAND PROCESS WXCHOICE <oWChoice> ; 
		TO <cHtml> ; 
		HEADER <oHeader> ; 
		BUTTON <oWebRotina> ; 
		[ SKIN <cSkin> ] ;
		[ CALL <cCall> ] ; 
		[ ACTION <cAction> ] ; 
		=> WxWch_EXEC( <oWChoice> , <oHeader> , <oWebRotina> , @<cHtml> , <cSkin> , <cCall> , <cAction> )

#XCOMMAND RECOVER WXHEADER ;
			[ USING <aProc> , <aPost> ] ;
			TO <aWXOBJ> ;
		=> <aWXOBJ> := WxWch_DataRec( <aProc> , <aPost> )

#XCOMMAND SAVE WXOBJ <oApData> ;
		[<rec: RECNO>] ;
		[ TO <cHtml> ] ;
		=> WxOBJ_Save(<oApData> , <.rec.> , [ @ <cHtml> ] )

       
#XCOMMAND BEGIN MKTRANSACTION => Begin Sequence ; MkOpenTran()

#XCOMMAND ROLLBACK MKTRANSACTION => MkBreakTran() ; BREAK

#XCOMMAND RECOVER MKTRANSACTION => RECOVER

#XCOMMAND END MKTRANSACTION => End Sequence ; MkCloseTran()
