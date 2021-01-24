#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOTVS.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'TBICONN.CH'

/*/{Protheus.doc} MGFFATB0
    INC0063083
    Estamos tendo problemas com pedidos que estão sendo totalmente liberados na SZV e estão ficando como bloqueados na SC5.
    abrimos o chamado #6283848 na Totvs, porem até que seja resolvido, por favor criar um job para que efetue a liberação dos pedidos nesta situação.
    Seguem comandos com o roteiro de execução.

    @type  Function
    @author Natanael Filho
    @since 05/07/2019
    @version P12
    @example
    (examples)
    /*/
User Function MGFFATB0(aParam)

    Local cAliasQry := GetNextAlias()
    Local _cTpPed   := ' '
    Local _cTimeRun := ' '
    Local _nQtdReg  := 0

    DEFAULT aParam := {'01','010001'}

    CONOUT(REPLICATE("=",60) + CRLF)
    CONOUT("[" + PROCNAME() + "] Inicio do processamento do JOB - " + DTOC(DATE()) + " " + TIME() + CRLF)
    
    CONOUT(REPLICATE("=",60))

    // Seta JOB para nao consumir licenças
    RpcSetType(3)

    //Prepara o ambiente para inicio do JOB

    PREPARE ENVIRONMENT EMPRESA aParam[1] FILIAL aParam[2]

        // Verifica se existe pedido bloquado na SC5 e liberado na SZV 
        BEGINSQL ALIAS cAliasQry

            SELECT
                C5_FILIAL
                ,C5_NUM
                ,C5_ZTIPPED
                ,C5.R_E_C_N_O_ AS SC5RECNO
            FROM
                %TABLE:SC5% C5
            WHERE
                C5.%notDel%
                AND C5_ZBLQRGA ='B'
                AND EXISTS  (SELECT 1
                            FROM
                                %TABLE:SZV% ZV1
                            WHERE
                                ZV1.%NotDel%
                                AND ZV1.ZV_PEDIDO = C5.C5_NUM
                                AND ZV1.ZV_FILIAL =C5.C5_FILIAL)
                AND NOT EXISTS (
                                SELECT 1
                                FROM
                                    %TABLE:SZV% ZV2
                                WHERE
                                    ZV2.%NotDel%
                                    AND ZV2.ZV_PEDIDO = C5.C5_NUM
                                    AND ZV2.ZV_FILIAL = C5.C5_FILIAL
                                    AND ZV2.ZV_HRAPR=' ')
        ENDSQL

        //Registra o tempo de processamento
        _cTimeRun := Alltrim(Str(GetLastQuery()[5]))


        //Mostra a query gerada pelo JOB
        CONOUT("Query executada (" + _cTimeRun + "s)")// + CRLF + GetLastQuery()[2] + CRLF)

        //Mostra a quantidade de registros encontrados
        Count to _nQtdReg
        CONOUT("Numero de registros encontrado: " + Alltrim(Str(_nQtdReg)) + CRLF)

    

        //Tabela de Tipo de Pedido(SZJ). Analisa se integra ao Tauta
        DbSelectArea("SZJ")
        SZJ->(DBSETORDER(1))//ZJ_FILIAL+ZJ_COD

        //Tabela de log de alterações e integrações.
        DbSelectArea("SZ1")
        
        DbselectArea("SC5")
        
        //Inicio da analise
        (cAliasQry)->(DBGOTOP())
        WHILE (cAliasQry)->(!EOF())

            _cTpPed := (cAliasQry)->C5_ZTIPPED

            IF SZJ->(DBSEEK(xFilial("SZJ") + _cTpPed))

                SC5->(DBGOTO((cAliasQry)->SC5RECNO))
                Reclock('SC5',.F.)
                    SC5->C5_ZBLQRGA := 'L'
                    IF SZJ->ZJ_TAURA = 'S'
                        SC5->C5_ZLIBENV = 'S'
                        SC5->C5_ZTAUREE = 'S'
                    ENDIF
                SC5->(MsUnLock())

                //Incia inserção na tabela SZ1
                Reclock('SZ1',.T.) //Novo Registro

                    SZ1->Z1_FILIAL   := (cAliasQry)->C5_FILIAL
                    SZ1->Z1_ID       := nMaxValue() + 1
                    SZ1->Z1_INTEGRA  := '005'
                    SZ1->Z1_NOMEITG  := 'TAURA'
                    SZ1->Z1_TPINTEG  := '008'
                    SZ1->Z1_NTPINTG  := 'JOB LIBERACAO PEDIDO DE VENDA BLOQUEADO'
                    SZ1->Z1_STATUS   := '1'
                    SZ1->Z1_ERRO     := 'Pedido liberado com sucesso SC5'
                    SZ1->Z1_DTEXEC   := DATE()
                    SZ1->Z1_HREXEC   := TIME()
                    SZ1->Z1_DOCORI   := (cAliasQry)->C5_NUM
                    SZ1->Z1_TMPPRO   := _cTimeRun
                    SZ1->Z1_DOCRECN  := (cAliasQry)->SC5RECNO

                SZ1->(MsUnlock())


            ELSE

                CONOUT("Tipo de pedido " + _cTpPed + "não encontrado na tabela SZJ")
            ENDIF

            (cAliasQry)->(DBSKIP())

        ENDDO


        //Fecha as areas utilizadas
        (cAliasQry)->(DBCLOSEAREA())
        SZJ->(DBCLOSEAREA())
        SC5->(DBCLOSEAREA())
        SZ1->(DBCLOSEAREA())
    
    RESET ENVIRONMENT

    CONOUT("[" + ProcName() + "] Fim do processamento do JOB - " + DTOC(DATE()) + " " + TIME() + CRLF)
    CONOUT(REPLICATE("=",60) + CRLF)
Return NIL

/*/{Protheus.doc} cMaxValue
    Retorna o maior valor de um campo de uma tabela
    @type  Function
    @author natanael.filho@marfrig.com.br
    @since 08/07/2019
    @version P12
    @return nMax, Número, Resultado da consulta.
    /*/
Static Function nMaxValue()

	Local nRet		:= -1
	Local cAliasQry := GetNextAlias()

    BEGINSQL ALIAS cAliasQry
    
		SELECT
			MAX(Z1_ID) as MAXVALUE
		FROM
			%TABLE:SZ1% TAB
		WHERE
			TAB.%notDel%
    ENDSQL
    
	If (cAliasQry)->(!EOF())
		nRet := (cAliasQry)->MAXVALUE		
    EndIf

    (cAliasQry)->(DBCLOSEAREA())
    
	Return nRet