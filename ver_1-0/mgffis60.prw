#INCLUDE "totvs.ch"
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#INCLUDE "fwbrowse.ch"
#INCLUDE "fwmvcdef.ch"

/*
============================================================================================================================
Programa.:              MGFFIS60
Autor....:              André Fracassi (DMS Consultoria) (DMS)
Data.....:              07/07/2020
Descricao / Objetivo:   Manutencao Cadastro Operação Fiscal por CFOP, DE/PARA Empresas, Cadastro de Setores e etc
Doc. Origem:
Task.....:              RTASK0011379 - Projeto Fiscal - CAT83
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
============================================================================================================================
*/
User Function MGFFIS60()

    Local _cTitulo      := "Pré Configuração Extrator - CAT83"
    Local _aLista       := {"1 - Cadastro Operação Fiscal por CFOP",    ;
                            "2 - DE/PARA Empresas",                     ;
                            "3 - Cadastro de Setores"}
    Local _lContinua    := .T.
    Private _aRet       := {}
    Private _aParam     := {}

    AAdd( _aParam, {2, "Opção", "1 - DE/PARA Empresas", _aLista, 110, , .T. } )         //MV_PAR01
    While _lContinua
        If ParamBox( _aParam, _cTitulo, @_aRet )
            If Left( _aRet[ 01 ], 01 ) = "1"
                fCadOperFiscal()
            ElseIf Left( _aRet[ 01 ], 01 ) = "2"
                fCadEmpresa()
            ElseIf Left( _aRet[ 01 ], 01 ) = "3"
                fCadSetores()
            EndIf
        Else
            _lContinua := .F.
        EndIf
    EndDo

Return



/*
============================================================================================================================
Programa.:              fCadOperFiscal
Autor....:              André Fracassi (DMS Consultoria)
Data.....:              07/07/2020
Descricao / Objetivo:   Manutencao Cadastro Operação Fiscal por CFOP
Doc. Origem:
Task.....:              RTASK0011379 - Projeto Fiscal - CAT83
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
============================================================================================================================
*/
Static Function fCadOperFiscal()

    Local _cTitulo      := "Cadastro Operação Fiscal por CFOP"
    Private _cAliasZGI  := "ZGI"

    DbSelectArea( _cAliasZGI )

    AxCadastro( _cAliasZGI, _cTitulo )

Return




/*
============================================================================================================================
Programa.:              fCadEmpresa
Autor....:              André Fracassi (DMS Consultoria)
Data.....:              07/07/2020
Descricao / Objetivo:   Manutencao Cadastro DE/PARA Empresas
Doc. Origem:
Task.....:              RTASK0011379 - Projeto Fiscal - CAT83
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
============================================================================================================================
*/
Static Function fCadEmpresa()

    Local _cTitulo      := "Cadastro DE/PARA Empresas"
    Private _cAliasZGJ  := "ZGJ"

    DbSelectArea( _cAliasZGJ )

    AxCadastro( _cAliasZGJ, _cTitulo )

Return



/*
============================================================================================================================
Programa.:              fCadSetores
Autor....:              André Fracassi (DMS Consultoria)
Data.....:              07/07/2020
Descricao / Objetivo:   Manutencao Cadastro Setores
Doc. Origem:
Task.....:              RTASK0011379 - Projeto Fiscal - CAT83
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
============================================================================================================================
*/
Static Function fCadSetores()

    Local _cTitulo      := "Cadastro de Setores x Item CAT"
    Private _cAliasZGK  := "ZGK"

    DbSelectArea( _cAliasZGK )

    AxCadastro( _cAliasZGK, _cTitulo )

Return



/*
============================================================================================================================
Programa.:              fValInclusao
Autor....:              André Fracassi (DMS Consultoria)
Data.....:              07/07/2020
Descricao / Objetivo:   Valida se já existe o item que esta sendo cadastrado
Doc. Origem:
Task.....:              RTASK0011379 - Projeto Fiscal - CAT83
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
Param    :              _cParam01 = Codigo Tabela
                        _nParam02 = Ordem (indice)
                        _cParam03 = Campo
                        _cParam04 = Mensagem Alerta
============================================================================================================================
*/
User Function fValInclusao( _cParam01, _nParam02, _cParam03, _cParam04 )

    Local _lRet         := .T.
    Local _cTabela      := _cParam01
    Local _nIndice      := _nParam02
    Local _cCampo       := _cParam03
    Local _cMsg         := _cParam04

    DbSelectArea( _cTabela )
    ( _cTabela )->( DbSetOrder( _nIndice ) )
    If ( _cTabela )->( DbSeek( xFilial( _cTabela ) + &_cCampo ) )
        MsgAlert( _cMsg )
        _lRet := .F.
    EndIf

Return( _lRet )
