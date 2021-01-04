#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"
/*/
=============================================================================
{Protheus.doc} MGFFATBN
Criação de título de ICMS próprio 

@description
Criar titulo de ICMS próprio conf. cad. regra venda interest. x grp tributário
Rotina chamada pelo ponto de entrada M460FIM

@author Cosme Nunes
@since 19/02/2020
@type User Function

@table 
    SF2 - Cabeçalho nota fiscal de saída 
    SE2 - Título a pagar

@param
    Não se aplica
    
@return
    Não se aplica

@menu
    Não se aplica

@history 
    19/02/2020 - RTASK0010790 - Chamados RITM0023263 - Cosme Nunes
    
/*/ 

User Function MGFFATBN()

Local _aArea	:= GetArea()
Local _aAreaSF2	:= SF2->( GetArea() )
Local _aAreaSD2	:= SD2->( GetArea() )
Local _aAreaSB1	:= SB1->( GetArea() )
Local _aAreaSA2	:= SA2->( GetArea() )
Local _aRotExc	:= STRTOKARR(SuperGetMV("MGF_FATBN",.F.,''),";") //Rotinas que não passarão pela validação
Local _cFornec := ""
Local _cLoja   := ""
Local _cNature := ""
Local _cCCusto := ""
Local _cCtaCon := ""
Local _nVlrIcm	:= 0
Local _nMes     := 0
Local _nAno     := 0
Local _aDatas   := CtoD("//")
Local _dDtIni	:= CtoD("//")
Local _dDtFim	:= CtoD("//")
Local _dDtVenc	:= CtoD("//")
Local _naScan   := 0
Local _cNReduz  := ""
Local _aCodPro  := {}
Local _nLaCP    := 0
Local _nI       := 0
Local _cGrpTrib := ""
Local _cFornec := ""
Local _cLoja   := ""
Local _cNature := ""
Local _cCCusto := ""
Local _cCtaCon := ""
Local _nI      := 0
Local _aCodPro := {}
Local _cCodPro := ""
Local _aRgrVIntE := {}
Local _cMVEstado := GetMV("MV_ESTADO")

//Verifica se rotinas que não devem passar pela validação estão na pilha de chamada. Se estiver, sai da função. 
For _nCnt := 1 To Len(_aRotExc)//MATA103
    If IsInCallStack(Alltrim(_aRotExc[_nCnt]))
        Return()
    EndIf
Next

//Verifica se o valor do ICMS foi calculado
//If SF2->F2_VALICM > 0 //ICMS calculado

//ICMS calculado e venda interestadual
If SF2->F2_VALICM > 0 .And. _cMVEstado <> SF2->F2_EST

    //Posiciona item p/ buscar produto
    SD2->(DBSETORDER( 3 ))//D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
    SD2->(DbSeek( xFilial("SD2") + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE +SF2->F2_LOJA ) ) 
    /* While SD2->( !EOF() .And. SD2->D2_DOC == SF2->F2_DOC .And. SD2->D2_SERIE == SF2->F2_SERIE .And. SD2->D2_CLIENTE == SF2->F2_CLIENTE .And. SD2->D2_LOJA == SF2->F2_LOJA)
        AADD(_aCodPro,{SD2->D2_COD})
        SD2->( dbSkip() )
    EndDo */
    _cCodPro := SD2->D2_COD

    //Posiciona produto p/ buscar o grupo tributÃ¡rio 
    /* If Len(_aCodPro) > 0 //NF c/ mais que 1 item
        _nLaCP:= Len(_aCodPro)
        For _nI:=1 To _nLaCP 
            
            _cGrpTrib := Posicione("SB1",1,xFilial("SB1")+_aCodPro[_nI][1],"B1_GRTRIB") */
            _cGrpTrib := Posicione("SB1",1,xFilial("SB1")+_cCodPro,"B1_GRTRIB")

            //Posiciona Cadastro de Regra Venda Interestadual para buscar fornecedor do ICMS
            ZFX->(DBSETORDER( 2 ))//ZFX_FILIAL+ZFX_GRPTRI
            //If (DbSeek(xFilial("ZFX")+_cGrpTrib))
            If (ZFX->(DbSeek(xFilial("ZFX")+SubS(_cGrpTrib,1,4)+_cMVEstado)))
                
                ZFW->(DBSETORDER( 1 ))//ZFW_FILIAL+ZFW_CODFOR+ZFW_LOJA
                If (ZFW->(DbSeek(xFilial("ZFW")+ZFX->ZFX_CODFOR+ZFX->ZFX_LOJA)))
                    _cFornec := ZFW->ZFW_CODFOR
                    _cLoja   := ZFW->ZFW_LOJA
                    _cNature := ZFW->ZFW_NATFIN
                    _cCCusto := ZFW->ZFW_CCUSTO
                    _cCtaCon := ZFW->ZFW_CONTA
                EndIf

                //Atualiza dados para gravaÃ§Ã£o do tÃ­tulo de ICMS
                /*If Len(_aRgrVIntE) == 0 //Primeira passagem
                    AADD(_aRgrVIntE,{"_cFornec"  , _cFornec } )
                    AADD(_aRgrVIntE,{"_cLoja"    , _cLoja   } )
                    AADD(_aRgrVIntE,{"_cNature"  , _cNature } )
                    AADD(_aRgrVIntE,{"_cCCusto"  , _cCCusto } )
                    AADD(_aRgrVIntE,{"_cCtaCon"  , _cCtaCon } )

                    Exit // Finalizo For: Se a condição for atendida para 1 item, deverá gerar o título
                    
                EndIf */
            Else
                // Inclusao WVN não estava tratando quando o registro não existe na tabela ZFX/ZFW
                Return
            EndIf
        //Next

    //EndIf 

    //Grava ICMS Proprio conforme cad. regra venda interestadual x grupo tributário
    //If nValICM > 0 
        //lGRecICMS := Iif(ValType(MV_PAR20)<>"N",.F.,(mv_par20==1))
        //lTitICMS  := Iif(ValType(MV_PAR19)<>"N",.F.,(mv_par19==1))

        //Funcionalidade válida somente para vendas interestaduais
        //If ( GetMV("MV_ESTADO") <> SF2->F2_EST ) .And. Len(_aRgrVIntE) > 0
            _nVlrIcm  := SF2->F2_VALICM
            _nMes     := Month(SF2->F2_EMISSAO)
            _nAno     := Year(SF2->F2_EMISSAO)
            _aDatas   := DetDatas(_nMes,_nAno,3,1)
            _dDtIni	  := _aDatas[1]
            _dDtFim	  := _aDatas[2]
            _dDtVenc  := DataValida(_aDatas[2]+1,.t.)
            
            //O título de ICMS deverá ter o prefixo ICM e ser do tipo TX            

            /*
            //Carrega dados do fornecedor do cadastro de venda interestadual 
            _naScan := aScan(_aRgrVIntE,{|x| x[1] =="_cFornec"})
            If _naScan != 0
                _cFornec := _aRgrVIntE[_naScan][2]
                _naScan := 0
            EndIf 
            _naScan := aScan(_aRgrVIntE,{|x| x[1] =="_cLoja"})
            If _naScan != 0
                _cLoja := _aRgrVIntE[_naScan][2]
                _naScan := 0
            EndIf 
            _naScan := aScan(_aRgrVIntE,{|x| x[1] =="_cNature"})
            If _naScan != 0
                _cNature := _aRgrVIntE[_naScan][2]
                _naScan := 0
            EndIf 
            _naScan := aScan(_aRgrVIntE,{|x| x[1] =="_cCCusto"})
            If _naScan != 0
                _cCCusto := _aRgrVIntE[_naScan][2]
                _naScan := 0
            EndIf 
            _naScan := aScan(_aRgrVIntE,{|x| x[1] =="_cCtaCon"})
            If _naScan != 0
                _cCtaCon := _aRgrVIntE[_naScan][2]
                _naScan := 0
            EndIf         
            */
            //Carrega dados do cadastro de venda interestadual para geração do título
            /*_cFornec := _aRgrVIntE[(aScan(_aRgrVIntE,{|x| x[1] =="_cFornec"}))][2]
            _cLoja   := _aRgrVIntE[(aScan(_aRgrVIntE,{|x| x[1] =="_cLoja"}))][2]
            _cNature := _aRgrVIntE[(aScan(_aRgrVIntE,{|x| x[1] =="_cNature"}))][2]
            _cCCusto := _aRgrVIntE[(aScan(_aRgrVIntE,{|x| x[1] =="_cCCusto"}))][2]
            _cCtaCon := _aRgrVIntE[(aScan(_aRgrVIntE,{|x| x[1] =="_cCtaCon"}))][2] */
            _cNReduz := Posicione("SA2",1,xFilial("SA2")+_cFornec+_cLoja,"A2_NREDUZ")

            //Cria título de ICMS próprio
            RecLock("SE2",.T.)
                SE2->E2_FILIAL  := xFilial("SE2")
                SE2->E2_NUM		:= SF2->F2_DOC
                SE2->E2_PREFIXO := "ICM"
                SE2->E2_TIPO  	:= "TX"
                SE2->E2_NATUREZ	:= _cNature
                SE2->E2_FORNECE := _cFornec
                SE2->E2_LOJA    := _cLoja
                SE2->E2_NOMFOR  := _cNReduz
                SE2->E2_MOEDA	:= SF2->F2_MOEDA
                SE2->E2_VALOR   := SF2->F2_VALICM
                SE2->E2_SALDO   := SF2->F2_VALICM
                SE2->E2_VLCRUZ  := SF2->F2_VALICM
                SE2->E2_HIST    := "ICMS proprio ref. NFS " + SF2->F2_DOC + " serie " + SF2->F2_SERIE
                SE2->E2_LA      := "" 
                SE2->E2_EMISSAO := SF2->F2_EMISSAO
                SE2->E2_VENCTO  := SF2->F2_EMISSAO //SE2->E2_VENCTO  := _dDtVenc
                SE2->E2_VENCREA := DataValida(SF2->F2_EMISSAO,.T.) //SE2->E2_VENCREA := DataValida(_dDtVenc,.T.) 
                SE2->E2_VENCORI := SF2->F2_EMISSAO //SE2->E2_VENCORI := _dDtVenc 
                SE2->E2_EMIS1	:= dDataBase 
                SE2->E2_ORIGEM  := FunName() //"MATA460"
                SE2->E2_FILORIG	:= cFilAnt
                SE2->E2_CCUSTO  := _cCCusto
                SE2->E2_CONTAD  := _cCtaCon
                //Campos default / específicos 
                SE2->E2_RATEIO  := "N" //X3_Relacao("S")
                SE2->E2_OCORREN := "01" //X3_Relacao("01") 
                SE2->E2_FLUXO   := "S" //X3_Relacao("S")
                SE2->E2_DESDOBR := "N"
                SE2->E2_MULTNAT := "2"
                SE2->E2_PROJPMS := "2"
                SE2->E2_DIRF    := "2"
                SE2->E2_MODSPB  := "1"
                SE2->E2_PRETPIS := "1"
                SE2->E2_PRETCOF := "1"
                SE2->E2_PRETCSL := "1"
                SE2->E2_MDRTISS := "1"
                SE2->E2_FRETISS := "1"
                SE2->E2_APLVLMN := "1"
                SE2->E2_TEMDOCS := "2"
                SE2->E2_STATLIB := "01"
                SE2->E2_DATAAGE := SF2->F2_EMISSAO
                SE2->E2_TPDESC  := "C" //Pertence("CI")
                SE2->E2_ZBLQFLG := "S" //Bloqueio Fluig
                SE2->E2_ZHORINC := Time()
                SE2->E2_MSBLQL  := "2"
                SE2->E2_ZVERSAO := "041" //Versao da Grade          
                SE2->E2_ZCONTRA := "1" //1=NORMAL;2=CONTRA APRESENTACAO;3=BOLETO LIQUIDO
                SE2->E2_XCONTRA := "1" //1=NORMAL;2=CONTRA APRESENTACAO                
                SE2->E2_ZIDGRD  := "" //ID Geracao Grade ("?")
                SE2->E2_ZCODGRD := "" //Código da Grade ("?")
                SE2->E2_ZNPORTA := "" //Identificador Num. Portal ("?")
            SE2->(MsUnlock())
        //Endif
    //Endif
EndIf

//_aRgrVIntE := {}

RestArea(_aAreaSA2)
RestArea(_aAreaSB1)
RestArea(_aAreaSD2)
RestArea(_aAreaSF2)
RestArea(_aArea)

Return()