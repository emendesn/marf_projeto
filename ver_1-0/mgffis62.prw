#INCLUDE "totvs.ch"
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "fwbrowse.ch"
#INCLUDE "fwmvcdef.ch"
#INCLUDE "rwmake.ch"

#DEFINE CRLF Chr(13) + Chr(10)

/*
============================================================================================================================
Programa.:              MGFFIS62
Autor....:              André Fracassi (DMS Consultoria)
Data.....:              08/07/2020
Descricao / Objetivo:   Gerar Arquivo TXT conforme Layout selecionado
Doc. Origem:
Task.....:              RTASK0011379 - Projeto Fiscal - CAT83
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
============================================================================================================================
*/
User Function MGFFIS62()

    Local _cTitBrw      := "Exportação DW"

    Private _oBrwZGN
    Private _cAliasZGN  := GetNextAlias()
    Private _oTempTable := FWTemporaryTable():New( _cAliasZGN )
    Private _cArqZGN    := ""
    Private _aCpos      := {}
    // Montando colunas do markbrowse
    AAdd( _aCpos, {"Cod Layout"    , "ZGN_LAYOUT"   , "C", TamSx3("ZGN_LAYOUT")[1]   , TamSx3("ZGN_LAYOUT")[2]  , PesqPict("ZGN", "ZGN_LAYOUT")    } )
    AAdd( _aCpos, {"Nome"          , "ZGN_DESCR"    , "C", TamSx3("ZGN_DESCR")[1]    , TamSx3("ZGN_DESCR")[2]   , PesqPict("ZGN", "ZGN_DESCR")     } )
    AAdd( _aCpos, {"Path Arquivo"  , "ZGN_PATHGR"   , "C", TamSx3("ZGN_PATHGR")[1]   , TamSx3("ZGN_PATHGR")[2]  , PesqPict("ZGN", "ZGN_PATHGR")    } )
    AAdd( _aCpos, {"Ult Usr"       , "ZGN_ULTUSR"   , "C", TamSx3("ZGN_ULTUSR")[1]   , TamSx3("ZGN_ULTUSR")[2]  , PesqPict("ZGN", "ZGN_ULTUSR")    } )
    AAdd( _aCpos, {"Nome Ult Usr"  , "NOME"         , "C", 50                        , 00                       , "@!"                             } )
    AAdd( _aCpos, {"Dt Ult Geracao", "ZGN_ULTGER"   , "D", TamSx3("ZGN_ULTGER")[1]   , TamSx3("ZGN_ULTGER")[2]  , PesqPict("ZGN", "ZGN_ULTGER")    } )

    // Montando tabela temporaria
    fCarLayout()

	_oBrwZGN := FWMarkBrowse():New()
    _oBrwZGN:SetTemporary( .T. )
	_oBrwZGN:SetAlias( _cAliasZGN )
	_oBrwZGN:SetDescription( _cTitBrw )
    _oBrwZGN:SetFields( _aCpos )
    _oBrwZGN:SetFieldMark("ZGN_OK")
    _oBrwZGN:AddButton("Exportar", { || fParExtrac( _oBrwZGN:Alias() ) }, , , , .F., 2 )
    _oBrwZGN:bMark      := { || }
    _oBrwZGN:bAllMark   := { || InverteBrw( _oBrwZGN ) }
	_oBrwZGN:Activate()

    // Fechando tabela temporaria
    _oTempTable:Delete()

	// Excluindo tabela temporaria
	If !Empty( _cArqZGN )
		If File( _cArqZGN + ".*" )
			FErase( _cArqZGN + ".*" )
		EndIf
	EndIf


Return



/*
============================================================================================================================
Programa.:              InverteBrw
Programa.:              fCarLayout
Autor....:              André Fracassi (DMS Consultoria)
Data.....:              08/07/2020
Descricao / Objetivo:   Marca/Desmarca registros para exportação
Descricao / Objetivo:   Retorna todos os Layout cadastrados
Doc. Origem:
Task.....:              RTASK0011379 - Projeto Fiscal - CAT83
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
Parametro:              oParam01 = Objeto do Browse
Parametro:
============================================================================================================================
*/
Static Function InverteBrw( _oParam01 )

    Local _oMBrowse := _oParam01
	Local _aAreaTmp	:= ( _oMBrowse:Alias() )->( GetArea() )  	// Guarda a area do browse.
	Local _lGoTop 	:= .T.									    // Posiciona no primeiro registro.
	Local _lRet     := .T.		    						    // Retorno da rotina.

	( _oMBrowse:Alias() )->( DbGoTop() )

	While ( _oMBrowse:Alias() )->( !Eof() )
		If ( !_oMBrowse:IsMark() )
			RecLock( _oMBrowse:Alias(), .F. )
			( _oMBrowse:Alias() )->ZGN_OK  := _oMBrowse:Mark()
			( _oMBrowse:Alias() )->( MsUnLock() )
		Else
			RecLock( _oMBrowse:Alias(), .F.)
			( _oMBrowse:Alias() )->ZGN_OK  := ""
			( _oMBrowse:Alias() )->( MsUnLock() )
		EndIf
		( _oMBrowse:Alias() )->( DbSkip() )
	EndDo

	RestArea( _aAreaTmp )
	_oMBrowse:Refresh( _lGoTop )

Return( _lRet )



/*
============================================================================================================================
Programa.:              fCarLayout
Autor....:              André Fracassi (DMS Consultoria)
Data.....:              08/07/2020
Descricao / Objetivo:   Retorna todos os Layout cadastrados
Doc. Origem:
Task.....:              RTASK0011379 - Projeto Fiscal - CAT83
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
Parametro:
============================================================================================================================
*/
Static Function fCarLayout()

    Local _aStru        := {}
    Local _cAliasBSq    := GetNextAlias()

    // Criando estrutura de tabela temporaria
    AAdd( _aStru, {"ZGN_LAYOUT" , "C", 010, 00 } )
    AAdd( _aStru, {"ZGN_DESCR"  , "C", 060, 00 } )
    AAdd( _aStru, {"ZGN_PATHGR" , "C", 150, 00 } )
    AAdd( _aStru, {"ZGN_ATIVO"  , "C", 001, 00 } )
    AAdd( _aStru, {"ZGN_ULTUSR" , "C", 025, 00 } )
    AAdd( _aStru, {"NOME"       , "C", 050, 00 } )
    AAdd( _aStru, {"ZGN_ULTGER"	, "D", 008, 00 } )
    AAdd( _aStru, {"ZGN_OK"     , "C", 002, 00 } )

    _oTempTable:SetFields( _aStru )
    _oTempTable:AddIndex("1", {"ZGN_LAYOUT"} )
    _oTempTable:Create()

    BeginSql Alias _cAliasBSq
        column ZGN_ULTGER as Date
        Select
            ZGN.*
        From
            %table:ZGN% ZGN
        Where
            ZGN.ZGN_FILIAL = %xFilial:ZGN%
        And ZGN.ZGN_ATIVO  = '1'
        And ZGN.%NotDel%
        Order By
            ZGN.ZGN_LAYOUT
    EndSql

    DbSelectArea( _cAliasBSq )
    ( _cAliasBSq )->( DbGoTop() )
    While ( _cAliasBSq )->( !Eof() )
        If RecLock( _cAliasZGN, .T. )
            ( _cAliasZGN )->ZGN_LAYOUT  := ( _cAliasBSq )->ZGN_LAYOUT
            ( _cAliasZGN )->ZGN_DESCR   := ( _cAliasBSq )->ZGN_DESCR
            ( _cAliasZGN )->ZGN_PATHGR  := ( _cAliasBSq )->ZGN_PATHGR
            ( _cAliasZGN )->ZGN_ATIVO   := ( _cAliasBSq )->ZGN_ATIVO
            ( _cAliasZGN )->ZGN_ULTUSR  := ( _cAliasBSq )->ZGN_ULTUSR
            ( _cAliasZGN )->NOME        := Left( UsrFullName( ( _cAliasBSq )->ZGN_ULTUSR ), 50 )
            ( _cAliasZGN )->ZGN_ULTGER  := ( _cAliasBSq )->ZGN_ULTGER
            ( _cAliasZGN )->ZGN_OK      := ""
            ( _cAliasZGN )->( MsUnLock() )
        EndIf

        DbSelectArea( _cAliasBSq )
        ( _cAliasBSq )->( DbSkip() )
    EndDo

    DbSelectArea( _cAliasBSq )
    ( _cAliasBSq )->( DbCloseArea() )

Return



/*
============================================================================================================================
Programa.:              fParExtrac
Autor....:              André Fracassi (DMS Consultoria)
Data.....:              08/07/2020
Descricao / Objetivo:   Monta Perguntas para extração do Layout
Doc. Origem:
Task.....:              RTASK0011379 - Projeto Fiscal - CAT83
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
Parametro:              cParam01 = Alias do Browse
============================================================================================================================
*/
Static Function fParExtrac( _cParam01 )

    Local _cAliasBrw    := _cParam01
    Local _cTitPerg     := "Parâmetros Exportação"
    Local _aExpXLS      := {"1-Sim", "2-Nao"}

    Private _oProcess

    Private _aRet       := {}
    Private _aParam     := {}

	AAdd( _aParam, { 1, "Filial De"                 , Space( TamSx3("ZGN_FILIAL")[ 01 ] )	        , ""    , ""                , "SM0"	, "", 015, .F. } )          //MV_PAR01
	AAdd( _aParam, { 1, "Filial Até"        	    , Replicate("Z", TamSx3("ZGN_FiLIAL")[ 01 ] )	, ""    , ""                , "SM0"	, "", 015, .T. } )          //MV_PAR02
	AAdd( _aParam, { 1, "Período De"        	    , dDatabase		                  			    , ""    , ""                , ""	, "", 050, .T. } )          //MV_PAR03
	AAdd( _aParam, { 1, "Período Até"	            , dDatabase     			        			, ""    , ""                , ""	, "", 050, .T. } )          //MV_PAR04
	AAdd( _aParam, { 6, "Diretório Gravação"	    , Space( 200 )	            					, "@!"	, ""	            , ""	, 070, .F., "Todos os Arquivos|*.*", GetTempPath(), GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE + GETF_RETDIRECTORY, .F. /*NAO MOSTRA SERVIDOR*/} )   //MV_PAR05
    AAdd( _aParam, { 2, "Conferência em Planilha"   , "2-Nao"                                       , _aExpXLS, 50, "", .T. } )				                        //MV_PAR06
    If ParamBox( _aParam, _cTitPerg, @_aRet )
        _oProcess := MsNewProcess():New( { || fProcArq( _cAliasBrw, _aRet[ 01 ], _aRet[ 02 ], _aRet[ 03 ], _aRet[ 04 ], _aRet[ 05 ], Left( _aRet[ 06 ], 01 ), _oProcess ) }, "Processando...", "Aguarde Geração do(s) Layout" )
        _oProcess:Activate()
    EndIf

Return



/*
============================================================================================================================
Programa.:              fProcArq
Autor....:              André Fracassi (DMS Consultoria)
Data.....:              08/07/2020
Descricao / Objetivo:   Processa geração do arquivo TXT com base no layout e parâmetros
Doc. Origem:
Task.....:              RTASK0011379 - Projeto Fiscal - CAT83
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
Parametro:              _cParam01 = Alias do Browse
                        _cParam02 = Filial De
                        _cParam03 = Filial Ate
                        _dParam04 = Data De
                        _dParam05 = Data Ate
                        -cParam06 = Path para gravação do arquivo
                        _cParam07 = Exporta para Excel
                        _oParam08 = Objeto Barra de Processamento
============================================================================================================================
*/
Static Function fProcArq( _cParam01, _cParam02, _cParam03, _dParam04, _dParam05, _cParam06, _cParam07, _oParam08 )

    Local _cAliasZGN    := _cParam01
    Local _cFilDe       := _cParam02
    Local _cFilAte      := _cParam03
    Local _dDataDe      := _dParam04
    Local _dDataAte     := _dParam05
    Local _cPathGr      := _cParam06
    Local _lExcel       := IIf( _cParam07 = "1", .T., .F. ) // Controla exportação para excel
    Local _oObjProc     := _oParam08

    Local _cParamGrv    := "Filial de - " + _cFilDe + ", Filial ate - " + _cFilAte + ", Data de - " + Dtoc( _dDataDe ) + ", Data ate - " + Dtoc( _dDataAte ) + ", Path Gravacao - " + _cPathGr + ", Exporta Excel - " + IIf( _lExcel, "Sim", "Nao" ) + CRLF

	Local _cNameFile    := ""               // Nome do arquivo TXT
    Local _cFileCSV     := ""               // Nome do arquivo CSV
	Local _nHandle      := 0                // Identifica o número do arquivo TXT
    Local _nHandCSV     := 0                // Identifica o número do arquivo TXT
	Local _cStrTXT      := ""               // Conteudo para gravação (dados)
    Local _cChSepa      := ""               // Character Separador
    Local _cChfLin      := ""               // Character Fim de Linha
    Local _cChNull      := ""               // Character Null
    Local _nTamCpo      := 0                // Controla o Tamanho do Campo. Quando Numérico considera as casas decimais

    Local _nPosCpo      := 0                // Retorna a posição do campo dentro da matriz

    Local _cConteudo    := ""

    Local _nQtdLayout   := 0
    Local _nQAtuLayout  := 0
    Local _nTotalReg    := 0
    Local _nRegAtual    := 0

    Private _cAliasQry  := ""
    Private _aStruQry   := {}               // Guarda a estrutura da Query obtida através do campo ZGN_QUERY

    DbSelectArea( _cAliasZGN )
    ( _cAliasZGN )->( DbEval( { || _nQtdLayout++ }, { || !Empty( ( _cAliasZGN )->ZGN_OK ) } ) )
    ( _cAliasZGN )->( DbGoTop() )
    _oObjProc:SetRegua1( _nQtdLayout )
    While ( _cAliasZGN )->( !Eof() )
        If !Empty( ( _cAliasZGN )->ZGN_OK ) .AND. ( _cAliasZGN )->ZGN_ATIVO = "1"

            // Inicializando variaveis
            _cStrTXT    := ""
            _nRegAtual  := 0
            _nTotalReg  := 0
            _nHandle    := 0
            _nHandCSV   := 0
            _cNameFile  := ""

            // Posicionando no Cadastro de Layout
            DbSelectArea("ZGN")
            ZGN->( DbSetOrder( 1 ) )
            ZGN->( DbSeek( xFilial("ZGN") + ( _cAliasZGN )->ZGN_LAYOUT )  )

            // Verificando se existe instrução sql dentro do campo ZGN_QUERY
            If Empty( ZGN->ZGN_QUERY )
                Help( " ", 1, "NOQUERY", ,"Não existe instrução SQL definido a este Layout", 1, 0, /*lPop*/, /*hWnd*/, /*nHeight*/, /*nWidth*/, /*lGravaLog*/, {"Preencha o campo Query SQL do Layout"} /*aSoluc*/ )
                DbSelectArea( _cAliasZGN )
                ( _cAliasZGN )->( DbSkip() )
                Loop
            EndIf

            // Verifica se houve mudança na gravação do diretório padrão para salvar o arquivo
            If !Empty( _cPathGr )
                _cPathGr := AllTrim( _cPathGr )
            Else
                _cPathGr := AllTrim( ZGN->ZGN_PATHGR )
            EndIf

            // Verificando se diretório existe para gravação do arquivo
            If !ExistDir( _cPathGr )
                If MsgYesNo("Diretório inválido para geração do Layout. Deseja cria-lo ?")
                    If MakeDir( _cPathGr ) != 0
                        Help( " ", 1, "MAKEDIR", ,"Não foi possível criar o diretório", 1, 0, /*lPop*/, /*hWnd*/, /*nHeight*/, /*nWidth*/, /*lGravaLog*/, {"Crie o diretório manualmente"} /*aSoluc*/ )
                    EndIf
                Else
                    Exit
                EndIf
            EndIf

            _cNameFile  := _cPathGr + AllTrim( ZGN->ZGN_LAYOUT ) + "_" + Right( StrTran( DTOC( _dDataDe ), "/", "" ), 06 ) + "." + ZGN->ZGN_EXTENS

            // Verifica se exporta para excel
            If _lExcel
                _nHandCSV   := 0
                _cFileCSV   := ""
                _cFileCSV   := _cPathGr + AllTrim( ZGN->ZGN_LAYOUT ) + "_" + Right( StrTran( DTOC( _dDataDe ), "/", "" ), 06 ) + ".CSV"
                _nHandCSV   := fCreate( _cFileCSV )
            EndIf

            _nHandle := fCreate( _cNameFile )
            If _nHandle > 0 .AND. IIf( _lExcel, _nHandCSV > 0, .T.)
                // Define Character Separador
                If ZGN->ZGN_CHSEPA = "1"
                    _cChSepa := CHR(9)
                ElseIf ZGN->ZGN_CHSEPA = "2"
                    _cChSepa := ";"
                ElseIf ZGN->ZGN_CHSEPA = "3"
                    _cChSepa := "."
                EndIf

                // Define Character Fim de Linha
                If ZGN->ZGN_CHFLIN = "CR/LF"
                    _cChfLin := CRLF
                Else
                    _cChfLin := ZGN->ZGN_CHFLIN
                EndIf

                // Posicionando nos itens do layout selecionado (CAT83) para geração do cabeçalho apenas para excel
                If _lExcel
                    DbSelectArea("ZGO")
                    ZGO->( DbSetOrder( 1 ) )
                    If ZGO->( DbSeek( xFilial("ZGO") + ZGN->ZGN_LAYOUT ) )
                        While ZGO->( !Eof() .AND. ZGO->ZGO_FILIAL = ZGN->ZGN_FILIAL .AND. ZGO->ZGO_LAYOUT = ZGN->ZGN_LAYOUT )
                            _cStrTXT += AllTrim( ZGO->ZGO_CAMPO ) + _cChSepa

                            DbSelectArea("ZGO")
                            ZGO->( DbSkip() )
                        EndDo
                        _cStrTXT := Substr( _cStrTXT, 01, Len( _cStrTXT ) - 1 ) + _cChfLin
                        fWrite( _nHandCSV, _cStrTXT )
                    EndIf
                EndIf

                // Apresentando Barra de Processamento
                _nQAtuLayout++
                _oObjProc:IncRegua1("Processando Layout : " + AllTrim( ZGN->ZGN_LAYOUT ) )

                // Retornando Dados obtidos através da Query contida no campo ZGN_QUERY do Layout selecionado
                _cAliasQry := GetNextAlias()
                MSAguarde( { || fRetLayoutSQL( ZGN->ZGN_QUERY, _cFilDe, _cFilAte, _dDataDe, _dDataAte ) }, "Aguarde...", "Montando Query" )
                DbSelectArea( _cAliasQry )
                MSAguarde( { || ( _cAliasQry )->( DbEval( { || _nTotalReg++ } ) ) }, "Aguarde...", "Retornando total de registros a serem processados" )
                ( _cAliasQry )->( DbGoTop() )
                _oObjProc:SetRegua2( _nTotalReg )
                While ( _cAliasQry )->( !Eof() )

                    // Apresentando Barra de Processamento
                    _nRegAtual++
                    _oObjProc:IncRegua2("Registro(s) : " + cValToChar( _nRegAtual ) + " de " + cValToChar( _nTotalReg ) )

                    // Inicializando variáveis
                    _cStrTXT    := ""
                    _cConteudo  := ""
                    _nPosCpo    := 0

                    // Montando estrutura do arquivo com base no layout
                    DbSelectArea("ZGO")
                    ZGO->( DbSetOrder( 1 ) )
                    If ZGO->( DbSeek( xFilial("ZGO") + ZGN->ZGN_LAYOUT ) )
                        While ZGO->( !Eof() .AND. ZGO->ZGO_FILIAL = ZGN->ZGN_FILIAL .AND. ZGO->ZGO_LAYOUT = ZGN->ZGN_LAYOUT )
                            If ZGO->ZGO_OBRIG = "1"

                                // Define o tamanho total do campo
                                _nTamCpo    := ( ZGO->ZGO_TAMANH + ZGO->ZGO_CASDEC )

                                // Define Character Null
                                _cChNull    := ZGO->ZGO_CHANUL

                                // Inicializando variavel que controla o conteudo texto
                                _cConteudo  := ""

                                // Verificando se a coluna existe na Query
                                _nPosCpo := AScan( _aStruQry, { |x| x[ 1 ] == AllTrim( ZGO->ZGO_CAMPO ) } )
                                If _nPosCpo > 0     // Imprime conteúdo
                                    _cConteudo := ( _cAliasQry )->&( _aStruQry[ _nPosCpo ][ 01 ] )
                                    // Verificando Tipo de Variável
                                    If ZGO->ZGO_TIPO = "N" .AND. ValType( _cConteudo ) = "N"
                                        // Verificando se Completa a Esquerda ou Direita {1=Sim;2=Nao}
                                        If ZGO->ZGO_COMESQ = "1"
                                            _cStrTXT += StrZero( Val( StrTran( AllTrim( Str( _cConteudo, _nTamCpo, ZGO->ZGO_CASDEC ) ), ".", "" ) ), _nTamCpo ) + _cChSepa
                                        ElseIf ZGO->COMDIR = "1"
                                            _cStrTXT += StrTran( AllTrim( Str( _cConteudo, _nTamCpo, ZGO->ZGO_CASDEC ) ), ".", "" ) + Len( StrTran( AllTrim( Str( _cConteudo, _nTamCpo, ZGO->ZGO_CASDEC ) ), ".", "" ) ) + _cChSepa
                                        Else
                                            _cStrTXT += StrZero( Val( StrTran( AllTrim( Str( _cConteudo, _nTamCpo, ZGO->ZGO_CASDEC ) ), ".", "" ) ), _nTamCpo ) + _cChSepa
                                        EndIf
                                    Else
                                        // Verificando se Completa a Esquerda ou Direita {1=Sim;2=Nao}
                                        If ZGO->ZGO_COMESQ = "1"
                                            If ZGO->ZGO_TIPO $ "C|D"
                                                // Formatação correta conforme definido em layout
                                                //_cStrTXT += Replicate( " ", ( _nTamCpo - Len( Substr( Trim( _cConteudo ), 01, _nTamCpo ) ) ) ) + Substr( Trim( _cConteudo ), 01, _nTamCpo ) + _cChSepa

                                                // Solicitado pelo Amorim (Fiscal) para deixar somente o conteúdo do campos, ou seja, retirar os espaços em branco. Com isso não consideramos o tamanho do campo
                                                _cStrTXT += Left( Trim( _cConteudo ), _nTamCpo ) + _cChSepa
                                            Else
                                                _cStrTXT += Replicate( "0", ( _nTamCpo - Len( Substr( _cConteudo, 01, _nTamCpo ) ) ) ) + Substr( _cConteudo, 01, _nTamCpo ) + _cChSepa
                                            EndIf
                                        ElseIf ZGO->ZGO_COMDIR = "1"
                                            If ZGO->ZGO_TIPO $ "C|D"
                                                // Formatação correta conforme definido em layout
                                                //_cStrTXT += Substr( Trim( _cConteudo ), 01, _nTamCpo ) + Replicate( " ", ( _nTamCpo - Len( Substr( Trim( _cConteudo ), 01, _nTamCpo ) ) ) ) + _cChSepa

                                                // Solicitado pelo Amorim (Fiscal) para deixar somente o conteúdo do campos, ou seja, retirar os espaços em branco. Com isso não consideramos o tamanho do campo
                                                _cStrTXT += Left( Trim( _cConteudo ), _nTamCpo ) + _cChSepa
                                            Else
                                                _cStrTXT += Substr( _cConteudo, 01, _nTamCpo ) + Replicate( "0", ( _nTamCpo - Len( Substr( _cConteudo, 01, _nTamCpo ) ) ) ) + _cChSepa
                                            EndIf
                                        Else
                                            // Formatação correta conforme definido em layout
                                            //_cStrTXT += Substr( Trim( _cConteudo ), 01, _nTamCpo ) + Replicate( " ", ( _nTamCpo - Len( Substr( Trim( _cConteudo ), 01, _nTamCpo ) ) ) ) + _cChSepa

                                            // Solicitado pelo Amorim (Fiscal) para deixar somente o conteúdo do campos, ou seja, retirar os espaços em branco. Com isso não consideramos o tamanho do campo
                                            IF EMPTY(_cConteudo) .And. ZGO->ZGO_TIPO $"C|D"
                                                _cConteudo := ZGO->ZGO_CHANUL
                                                _cStrTXT += Left( Trim( _cConteudo ), _nTamCpo ) + _cChSepa
                                            ELSE
                                                _cStrTXT += Left( Trim( _cConteudo ), _nTamCpo ) + _cChSepa
                                            ENDIF
                                        EndIf
                                    EndIf
                                Else                // Não achou o campo do layout na estrutura da query, então imprime conforme conteúdo do campo ZGO->ZGO_CHANUL
                                    If ZGO->ZGO_TIPO = "N"
                                        _cStrTXT += Replicate("0", _nTamCpo ) + _cChSepa
                                    Else
                                        // Formatação correta conforme definido em layout
                                        //_cStrTXT += Replicate( ZGO->ZGO_CHANUL, _nTamCpo ) + _cChSepa

                                        // Solicitado pelo Amorim (Fiscal) para deixar somente um caracter, ao invés de replicar o caracter nulo considerando o tamanho do campo no layout
                                        _cStrTXT += ZGO->ZGO_CHANUL + _cChSepa
                                    EndIf
                                EndIf
                            EndIf

                            DbSelectArea("ZGO")
                            ZGO->( DbSkip() )
                        EndDo

                        // Gravando dados no arquivo TXT
                        fWrite( _nHandle, ( _cStrTXT + _cChfLin ) )

                        // Verifica se exporta para excel e grava dados no arquivo CSV
                        IIf( _lExcel, fWrite( _nHandCSV, ( _cStrTXT + _cChfLin ) ),  )

                    EndIf

                    DbSelectArea( _cAliasQry )
                    ( _cAliasQry )->( DbSkip() )

                EndDo

                DbSelectArea( _cAliasQry )
                ( _cAliasQry )->( DbCloseArea() )

                // Gravando informações sobre a última execução
                DbSelectArea("ZGN")
                If  RecLock("ZGN", .F. )
                    ZGN->ZGN_ULTUSR  := RetCodUsr()
                    ZGN->ZGN_ULTGER  := dDatabase
                    ZGN->ZGN_OK      := Space( 02 )
                    ZGN->( MsUnLock() )
                EndIf

                // Gravando Log de Processamento
                DbSelectArea("ZGM")
                If Reclock("ZGM", .T.)
                    ZGM->ZGM_FILIAL := xFilial("ZGM")
                    ZGM->ZGM_LAYOUT := ZGN->ZGN_LAYOUT
                    ZGM->ZGM_DATA   := dDatabase
                    ZGM->ZGM_HORA   := Time()
                    ZGM->ZGM_USER   := RetCodUsr()
                    ZGM->ZGM_PARAM  := _cParamGrv
                    ZGM->ZGM_OPER   := "1"                  //1=Geracao Layout;2=Proc. SAFX10;3=Alteracao Layout
                    ZGM->( MsUnlock() )
                EndIf

                // Desmarcando Layout
                DbSelectArea( _cAliasZGN )
                If RecLock( _cAliasZGN, .F. )
                    ( _cAliasZGN )->ZGN_OK := Space( 02 )
                    ( _cAliasZGN )->( MsUnLock() )
                EndIf

                // Liberando arquivo TXT para uso
                If _nHandle > 0 .AND. IIf( _lExcel, _nHandCSV > 0, .T.)
                    fClose( _nHandle )
                    // Exportando para excel para simples conferência
                    If _lExcel
                        fClose( _nHandCSV )
                        fExpExcel( _cFileCSV )
                    EndIf
                EndIf
            Else
                Help( " ", 1, "FCREATE", ,"Não foi possível criar o arquivo do Layout : " + AllTrim( ZGN->ZGN_LAYOUT ), 1, 0, /*lPop*/, /*hWnd*/, /*nHeight*/, /*nWidth*/, /*lGravaLog*/, {"Verifique se o arquivo já esta aberto"} /*aSoluc*/ )

                // Desmarcando Layout
                DbSelectArea( _cAliasZGN )
                If RecLock( _cAliasZGN, .F. )
                    ( _cAliasZGN )->ZGN_OK := Space( 02 )
                    ( _cAliasZGN )->( MsUnLock() )
                EndIf

                fClose( _nHandle )

                If _lExcel
                    fClose( _nHandCSV )
                EndIf

                // Atualizando janela
                _oBrwZGN:Refresh( .T. )

            EndIf

        EndIf

        DbSelectArea( _cAliasZGN )
        ( _cAliasZGN )->( DbSkip() )

    EndDo

    If _nHandle > 0
        MsgAlert("Geração do(s) Layout(s) Realizado com sucesso !!!!")
    EndIf

    // Atualizando janela
    _oBrwZGN:Refresh( .T. )


Return



/*
============================================================================================================================
Programa.:              MenuDef
Autor....:              André Fracassi (DMS Consultoria)
Data.....:              08/07/2020
Descricao / Objetivo:   Menu
Doc. Origem:
Task.....:              RTASK0011379 - Projeto Fiscal - CAT83
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
Parametro:              _cParam01 = Conteudo SQL do Layout
                        _cParam02 = Filial De
                        _cParam03 = Filial Ate
                        _dParam04 = Data De
                        _dParam05 = Data Ate
=======================================================================================t1005718t1=====================================
*/
Static Function fRetLayoutSQL( _cParam01, _cParam02, _cParam03, _dParam04, _dParam05 )

    Local _cInstSQL := _cParam01
    Local _cFilDe   := _cParam02
    Local _cFilAte  := _cParam03
    Local _dEmisDe  := _dParam04
    Local _dEmisAte := _dParam05

    If Select( _cAliasQry ) > 0
        ( _cAliasQry )->( DbCloseArea() )
    EndIf

    // Efetuando parse dos campos Filial De, Filial Ate, Dt Emissao De, Dt Emissao Ate
    _cInstSQL := StrTran( _cInstSQL, "MV_PAR01", "'" + _cFilDe + "' ")
    _cInstSQL := StrTran( _cInstSQL, "MV_PAR02", "'" + _cFilAte + "' ")
    _cInstSQL := StrTran( _cInstSQL, "MV_PAR03", "'" + DTOS( _dEmisDe ) + "' ")
    _cInstSQL := StrTran( _cInstSQL, "MV_PAR04", "'" + DTOS( _dEmisAte ) + "' ")

    MPSysOpenQuery( ChangeQuery( _cInstSQL ), _cAliasQry, )

    DbSelectArea( _cAliasQry )
    ( _cAliasQry )->( DbGoTop() )

    // Obtendo Estrutura de Tabela do SQL Layout
    _aStruQry := {}
    _aStruQry := ( _cAliasQry )->( DbStruct() )

Return



/*
============================================================================================================================
Programa.:              fExpExcel
Autor....:              André Fracassi (DMS Consultoria)
Data.....:              15/07/2020
Descricao / Objetivo:   Exporta dados para conferencia em Excel
Doc. Origem:
Task.....:              RTASK0011379 - Projeto Fiscal - CAT83
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
Parametro:              cParam01 = Nome do Arquivo TXT
============================================================================================================================
*/
Static Function fExpExcel( _cParam01 )

    Local _cArqName := _cParam01
    Local _oExcelApp

    _oExcelApp := MsExcel():New()
	_oExcelApp:WorkBooks:Open( _cArqName )
	_oExcelApp:SetVisible(.T.)
    _oExcelApp:Destroy()

Return
