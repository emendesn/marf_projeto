#Include 'Protheus.ch'
#Include 'topconn.ch'
/*
=====================================================================================
Programa............: MGFFINX9
Autor...............: Antonio Florêncio
Data................: 04/09/2020
Descriç?o / Objetivo: Rotina que Aplica novas regras para definiç?o da condiç?o de pagamento dos documentos de frete integrados no GFE Documento de Frete.
Doc. Origem.........: RITM0043795
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/
User Function MGFFINC1()

Local _aGetArea := GetArea()
Local _dDataVenc
Local _cFilial  := SE2->E2_FILIAL
Local _cPrefixo := SE2->E2_PREFIXO
Local _cNumTit  := SE2->E2_NUM
Local _cParcela := SE2->E2_PARCELA
Local _cFornece := SE2->E2_FORNECE
Local _cLoja    := SE2->E2_LOJA
Local _cAliasSE2:= GetNextAlias()
Local _nQtdDNorm:= 0 //Qtde de Dias acrescentados na data de ocorrencia quando a Data de Ocorrencia mais a Qtde de dias em relaç?o a data de entrega n?o est? Vencida.
Local _nQtdDVenc:= 0 //Qtde de Dias acrescentados na data corrente quando a Data de Ocorrencia em relaç?o a data de entrega est? Vencida
Local _nDiaSeman:= 0 //Dia fixo da semana para calculo da Data de Vencimento Ex: 3=Terça-feira
Local _dDataReal:= CTOD("  /  /  ")

    	If !ExisteSx6("MGF_FINC1A")
    		CriarSX6("MGF_FINC1A", "N", "Qtde de Dias acrescentados na data de ocorrencia quando a Data de Ocorrencia mais a Qtde de dias em relaç?o a data de entrega n?o est? Vencida.", '30')
    	EndIf

    	If !ExisteSx6("MGF_FINC1B")
    		CriarSX6("MGF_FINC1B", "N", "Qtde de Dias acrescentados na data corrente quando a Data de Ocorrencia em relaç?o a data de entrega est? Vencida", '10')
    	EndIf

    	If !ExisteSx6("MGF_FINC1C")
    		CriarSX6("MGF_FINC1C", "N", "Dia da semana fixo para condiç?o de pgto Doc x Frete. Ex: 3=Terça-feira", '3')
    	EndIf

        _nQtdDNorm := SuperGetMv( "MGF_FINC1A" , , "30") 
        _nQtdDVenc := SuperGetMv( "MGF_FINC1B" , , "10") 
        _nDiaSeman := SuperGetMv( "MGF_FINC1C" , , "3") 

        //Atualiza as variaveis do titulo atual
        _cFilial  := SE2->E2_FILIAL
        _cPrefixo := SE2->E2_PREFIXO
    	_cNumTit  := SE2->E2_NUM
        _cParcela := SE2->E2_PARCELA
        _cFornece := SE2->E2_FORNECE
        _cLoja    := SE2->E2_LOJA

		If Select(_cAliasSE2) > 0
			(_cAliasSE2)->(DbClosearea())
		Endif

        BeginSql Alias _cAliasSE2

			Select 
                    GWD.GWD_FILIAL,GWD.GWD_NROCO,GWD.GWD_DTOCOR,GWL.GWL_NROCO,
                    GW3.GW3_DTEMIS,GW3.GW3_DTENT,GW3.GW3_CTE, 
                    E2.E2_FILIAL,E2.E2_PREFIXO,E2.E2_NUM,E2.E2_FORNECE,E2.E2_LOJA,E2.E2_TIPO,E2.E2_VENCTO,E2.E2_VENCREA
					From %table:SE2% E2
                        LEFT JOIN %table:SA2% A2
                        ON A2.A2_COD = E2.E2_FORNECE
                        AND A2.A2_LOJA = E2.E2_LOJA
                        AND A2.D_E_L_E_T_ =' '
                        LEFT JOIN %table:GW3% GW3
                        ON GW3.GW3_FILIAL = E2.E2_FILIAL
                        AND GW3.GW3_EMISDF = A2.A2_CGC
                        AND GW3.GW3_SERDF =E2.E2_PREFIXO
                        AND GW3.GW3_NRDF = E2.E2_NUM
                        AND GW3.GW3_DTEMIS = E2.E2_EMISSAO
                        AND GW3.D_E_L_E_T_ =' '
                        LEFT JOIN %table:GW4% GW4
                        ON GW4.GW4_FILIAL = GW3.GW3_FILIAL
                        AND GW4.GW4_EMISDF = GW3.GW3_EMISDF
                        AND GW4.GW4_CDESP = GW3.GW3_CDESP
                        AND GW4.GW4_SERDF = GW3.GW3_SERDF
                        AND GW4.GW4_NRDF = GW3.GW3_NRDF
                        AND GW4.GW4_DTEMIS  = GW3.GW3_DTEMIS
                        AND GW4.D_E_L_E_T_ =' '
                        LEFT JOIN %table:GWL% GWL
                        ON GWL.GWL_FILIAL = GW4.GW4_FILIAL
                        AND GWL.GWL_NRDC = GW4.GW4_NRDC
                        AND GWL.GWL_SERDC = GW4.GW4_SERDC
                        AND GWL.GWL_TPDC = GW4.GW4_TPDC
                        AND GWL.D_E_L_E_T_ = ' '
                        LEFT JOIN %table:GWD% GWD
                        ON GWD.GWD_FILIAL = GWL.GWL_FILIAL
                        AND GWD.GWD_NROCO = GWL.GWL_NROCO
                        AND GWD.D_E_L_E_T_ =' '
					Where
						E2.E2_FILIAL      = %EXP:_cFilial%
                        AND E2.E2_PREFIXO = %EXP:_cPrefixo%
                        AND E2.E2_NUM     = %EXP:_cNumTit%
                        AND E2.E2_PARCELA = %EXP:_cParcela%
                        AND E2.E2_FORNECE = %EXP:_cFornece%
                        AND E2.E2_LOJA    = %EXP:_cLoja%
						AND E2.%NotDel%
                        AND GWL.GWL_TPDC IN ('NFS')
        EndSql

        TcSetField(_cAliasSE2,"GWD_DTOCOR","D",8,0)
        TcSetField(_cAliasSE2,"GW3_DTENT","D",8,0)

        (_cAliasSE2)->(dbGoTop())
        IF !(_cAliasSE2)->(EOF()) 
            
            //Faz a verificaç?o somente para Titulos que tem ocorrência
            If !Empty((_cAliasSE2)->GWD_DTOCOR)

                // Criar condiç?o de pagamento que permita que o vencimento seja
                // 30dd com base na data da emiss?o da ocorrência (GWD_DTOCOR) e 
                _dDataVenc := (_cAliasSE2)->GWD_DTOCOR + _nQtdDNorm
                // caso na data da integraç?o (GW3_DTENT) os 30dd tenha expirado, 
                // o sistema lance com vencimento hoje +10 DD e sempre terça-feira.
                If _dDataVenc < (_cAliasSE2)->GW3_DTENT

                    _dDataVenc := dDatabase + _nQtdDVenc 
                    //Calcula a Data para toda terça-feira
                    SE2->E2_VENCTO  := RegCndPgto(_dDataVenc,_nDiaSeman) 
                    _dDataReal      := DataValida(SE2->E2_VENCTO) 
                    
                    //Avaliação da Data Real de Vencto se após passar pela função de datavalida continua sendo no _ndiaSeman escolhido Ex:Terça-feira.
                    //Se não aplica a função para a proxima terça feira.
                    If Dow(_dDataReal) <> _nDiaSeman
                            _dDataReal:= RegCndPgto(_dDataReal,_nDiaSeman) 
                    EndIf
                    
                    SE2->E2_VENCREA := _dDataReal 

                EndIf

            EndIf
        EndIf
        

        (_cAliasSE2)->(dbClosearea())
    
    RestArea(_aGetArea)

Return
/*
=====================================================================================
Programa............: RegCndPgto
Autor...............: Antonio Florêncio
Data................: 04/09/2020
Descriç?o / Objetivo: funç?o que calcula regra de condiç?o de pagamento para documento de frete integrado com gfe.
Doc. Origem.........: RITM0043795
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/
Static Function RegCndPgto(_dDtVencto,_nDiaDaSem)

Local _dDtRetorn := CTOD("")
Local _nDiaDaDat := Dow(_dDtVencto)
Local _nDiaTtSem := 7
If _nDiaDaDat = _nDiaDaSem

	_dDtRetorn :=  _dDtVencto

ElseIf _nDiaDaDat < _nDiaDaSem

	_dDtRetorn := _dDtVencto + (_nDiaDaSem-_nDiaDaDat)

ElseIf _nDiaDaDat > _nDiaDaSem

	_dDtRetorn := _dDtVencto + (_nDiaTtSem-_nDiaDaDat+_nDiaDaSem)

EndIf

Return(_dDtRetorn)
