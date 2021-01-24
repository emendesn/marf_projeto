#include "totvs.ch"                                   
#include "protheus.ch"
#include "topconn.ch"

#Define   ENTER Chr( 13 ) + Chr( 10 )

/*
=====================================================================================
Programa............: MGFCOMBG
Autor...............: Wagner Neves
Data................: 16/03/2020
Descricao / Objetivo: 
Doc. Origem.........: 
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/

User Function MGFCOMBG()
    Local lRet      := .T.  
    Local _cAliaSf1 := GetNextAlias()
       
    //Verifica se é ExecAuto
    If l103Auto
        Return(.T.)
    EndIf

	_lVldRot := SUPERGETMV("MGF_COMBG",.F., '.T.' )

    If ! _lVldRot
        Return(.T.)
    EndIf

    SetPrvt("_ChaveNfe")
    SetPrvt("_chvUF")
    SetPrvt("_chAno")
    SetPrvt("_chMes")
    SetPrvt("_chCnpj")
    SetPrvt("_chModelo")
    SetPrvt("_chSerie")
    SetPrvt("_chNumero")
    SetPrvt("_chFormaEmis")
    SetPrvt("_chCodNum")
    SetPrvt("_chDigVer")
    SetPrvt("_cMsg")
    SetPrvt("_cUf")
    SetPrvt("_cAnoEmis")
    SetPrvt("_cMesEmis")
    SetPrvt("_cCnPjFor")
    SetPrvt("_cModelo")
    SetPrvt("_cSerie")
    SetPrvt("_cNumNf")
    SetPrvt("_CChaveNf")
    SetPrvt("_cDigChNf")
    //Variáveis da chave que foi informada na nota fiscal
    If FUNNAME()<>"MATA910"
        _ChaveNfe     :=   M->F1_ChvNfe
        IF Empty(_ChaveNfe) .And. l103Class .And. Alltrim(cEspecie) $"SPED|CTE"
            _ChaveNfe     :=   aNfeDanfe[13] //SF1->F1_ChvNfe
        ElseIF Empty(_ChaveNfe) .And. !l103Class .And. Alltrim(cEspecie) $"SPED" .And. cTipo $"PBIC"
            _ChaveNfe     :=   aNfeDanfe[13] //SF1->F1_ChvNfe
        Endif
    ElseIf FUNNAME()=="MATA910"
        _ChaveNfe     :=   aDanfe[01]
    EndIf
    _chvUF        :=  Subs(_ChaveNfe,01,02)
    _chAno        :=  Subs(_ChaveNfe,03,02)
    _chMes        :=  Subs(_ChaveNfe,05,02)
    _chCnpj       :=  Subs(_ChaveNfe,07,14)
    _chModelo     :=  Subs(_ChaveNfe,21,02)
    _chSerie      :=  Subs(_ChaveNfe,23,03)
    _chNumero     :=  Subs(_ChaveNfe,26,09)
    _chFormaEmis  :=  Subs(_ChaveNfe,35,01)
    _chCodNum     :=  Subs(_ChaveNfe,36,08)
    _chDigVer     :=  Subs(_ChaveNfe,44,01)
    _cMsg         :=  ' '
    
    IF FUNNAME()<>"MATA910"
        /*-------------------------------------------------------------------------+
        | Montagem da query para verificacao se nao ha' duplicidade no SF1/SD1     |
        +-------------------------------------------------------------------------*/
        cQuery  :=  "SELECT F1_FILIAL UNIDADE, F1_FORNECE CLIENTE, F1_LOJA LOJA, F1_DOC NF, F1_SERIE SERIE, F1_CHVNFE CHAVE_NFE,F1_STATUS STATUS" + ENTER
        cQuery  +=  " FROM " + RetSQLName( "SF1" ) + " SF1 "                  + ENTER
        cQuery  +=  " WHERE  SF1.F1_FILIAL   =   '" + xFilial( "SF1" ) + "' " + ENTER
        cQuery  +=  "    AND SF1.F1_FORNECE     =   '" + cA100For        + "' " + ENTER
        cQuery  +=  "    AND SF1.F1_LOJA        =   '" + cLoja           + "' " + ENTER
        cQuery  +=  "    AND SF1.F1_DOC         =   '" + cNFiscal        + "' " + ENTER
        cQuery  +=  "    AND SF1.F1_ESPECIE     =   '" + Alltrim(cEspecie)        + "' " + ENTER
        IF FunName() == "MATA103"  .AND.  l103Class
            cQuery  +=  "    AND SF1.R_E_C_N_O_   <>  " + Alltrim(STR(SF1->(Recno())))        + " " + ENTER
        EndIF
        cQuery  +=  "    AND SF1.D_E_L_E_T_  <>  '*' "                        + ENTER
        TCQuery cQuery New Alias "QRYSF1"
        QRYSF1->( DbGoTop() )
        Count To nReg
        If nReg > 0 
            MsgAlert("Atenção : "+Alltrim(cEspecie)+" em duplicidade.","MGFCOMBG") // ALTERACAO 14042020
        EndIf
        QRYSF1->( DbCloseArea() )
    ENDIF
    // Verifica se o campo chave está vazio ou não
    If FunName()='MATA103' .And. Empty(_ChaveNfe) .And. cFormul=='N' //ALTERAÇÃO 14042020
            MsgAlert("Chave de Acesso não informada","MGFCOMBG")
            lRet := .F.
            Return lRet
    ElseIf FunName()='MATA910' .And. Empty(_ChaveNfe) .And. cFormul = "N" //ALTERAÇÃO 14042020
            MsgAlert("Chave de Acesso não informada","MGFCOMBG")
            lRet := .F.
            Return lRet            
    ElseIF Len(Alltrim(_ChaveNfe)) <> 44
        MsgAlert("Tamanho da Chave incorreto.","MGFCOMBG")
        lRet := .F.
        Return lRet
    EndIf
    
    // Verifica se o campo chave contém caracteres diferente de números
    lRetChv := .t.
    For nI := 1 To Len(_ChaveNfe)
        IF ! (SUBSTR(_ChaveNfe,nI,1) $ '0123456789')
            lRetcHV := .F.
            Exit
        EndIF
    Next 
    IF !lRetcHV
        MsgAlert("A Chave da NFe deve conter somente números.","MGFCOMBG")
        lRet := .F.
        Return lRet
    EndIf
   
//------------------------Verifica Chave Digitada x Variáveis informadas no cabeçalho da nota fiscal  
    
/*UF*/
    If FUNNAME()=="MATA910"
        IF CTIPO $ "B|D"
            CUFORIG := SA1->A1_EST
        ELSE
            CUFORIG := SA2->A2_EST
        ENDIF
    ENDIF
    
    IF Alltrim(cEspecie) == "CTE" .And. cTipo == "C" //.And. SF1->F1_TPCOMPL=='3'// Frete e complemento
    /*
        IF ! EMPTY(SF1->F1_UFDESTR)
            _cUf  := Posicione("C09",1,XFILIAL("C09")+SF1->F1_UFDESTR,"C09_CODIGO")
        ELSE
    */
        lRet := .t.
    //_cUf  := Posicione("C09",1,XFILIAL("C09")+CUFORIG,"C09_CODIGO")            
    //    ENDIF
    ELSE    
       _cUf  := Posicione("C09",1,XFILIAL("C09")+CUFORIG,"C09_CODIGO")
        IF _cUf <> _chvUf 
            _cMsg += "Uf Divergente Chave x Cabeçalho da Nota"+CRLF
            lRet := .F.
        ENDIF
    ENDIF 


/*Ano Emissao*/
    _cAnoEmis  := Subs(Alltrim(Str(YEAR(DDEMISSAO))),3,2)
    IF _cAnoEmis <> _chAno 
        _cMsg += "Ano Divergente Chave x Cabeçalho da Nota"+CRLF
        lRet := .F.
    ENDIF

/*Mes Emissao*/
    _cMesEmis  := StrZero(MONTH(DDEMISSAO),2)
    IF _cMesEmis <> _chMes 
        _cMsg += "Mês Divergente Chave x Cabeçalho da Nota"+CRLF
        lRet := .F.
    ENDIF

/*CNPJ*/
    If Alltrim(cEspecie) $ "CTE|CTEOS"
        _cCnPjFor   := Alltrim(POSICIONE("SA2",1,xFilial("SA2")+cA100for+cLoja,"A2_CGC"))
        IF _cCnPjFor <> _chCnpj 
            _cMsg += "CNPJ Divergente Chave x Cabeçalho da Nota"+CRLF
            lRet := .F.
        ENDIF
    ElseIf Alltrim(cEspecie) $ "SPED" 
        IF cTipo $ "B|D"
            _cTipo      := Alltrim(POSICIONE("SA1",1,xFilial("SA1")+cA100for+cLoja,"A1_TIPO"))
            _cCnPjFor   := Alltrim(POSICIONE("SA1",1,xFilial("SA1")+cA100for+cLoja,"A1_CGC"))
        ELSE
            _cTipo      := Alltrim(POSICIONE("SA2",1,xFilial("SA2")+cA100for+cLoja,"A2_TIPO"))
            _cCnPjFor   := Alltrim(POSICIONE("SA2",1,xFilial("SA2")+cA100for+cLoja,"A2_CGC"))
        ENDIF
        
                
        //PRB0041029
        IF _cTipo = 'F' //Fisica
            _cCnPjFor := STRZERO(VAL(_cCnPjFor),14)
        ENDIF

        /*
        If _cTipo == "J" //Pessoa Juridica           
            IF _cCnPjFor <> _chCnpj 
                _cMsg += "Pessoa Juridica, CNPJ Divergente Chave x Cabeçalho da Nota"+CRLF
                lRet := .F.
            ENDIF
        ElseIf _cTipo="F"  // Pessoa Fisica*/

        IF _cCnPjFor <> _chCnpj                
            If ! ZG4->(DbSeek(xFilial("ZG4")+_chCnpj))            
                If _cTipo="F"
                    _cMsg += "Pessoa Fisica, CNPJ Divergente Chave x Cabeçalho da Nota"+CRLF
                    lRet := .F.
                ElseIf _cTipo="J"
                    _cMsg += "Pessoa Jurídica, CNPJ Divergente Chave x Cabeçalho da Nota"+CRLF
                    lRet := .F.
                EndIf
            EndIf
        EndIf
    EndIf
/*MODELO*/
If Alltrim(cEspecie) $'CTE|CTEOS'
    IF Alltrim(cEspecie)=='CTE'
        _cModelo := '57'
    ElseIF Alltrim(CESPECIE)='CTEOS'
        _cModelo := '67'
    EndIf    
    If _cModelo <> _chModelo
        _cMsg += "Modelo Divergente Chave x Cabeçalho da Nota"+CRLF
        lRet := .F.
    EndIf
EndIf

/*Serie*/
    _cSerie   := StrZero(Val(cSerie),3)
    If _cSerie <> _chSerie
        _cMsg += "Série Divergente Chave x Cabeçalho da Nota"+CRLF
        lRet := .F.
    EndIf

/*Número*/
    _cNumNf   := StrZero(Val(cNFiscal),9)
    If _cNumNf <> _chNumero
        _cMsg += "Número do documento divergente Chave x Cabeçalho da Nota"+CRLF
        lRet := .F.
    EndIf

/*Digito Chave*/
    _CChaveNf := Subs(_ChaveNfe,1,43)
    _cDigChNf := GeraDv11(_cChaveNf)
    If _cDigChNf <> Val(_chDigVer)
        _cMsg += "Digito Verificador - Chave de acesso informada é inválida"+CRLF
        lRet := .F.
    EndIf

/*Mostra resultado quando retorno for .F. */
    If ! lRet 
        MsgAlert(_cMsg,"Dados do documento informado não conferem com a Chave de Acesso")
    Endif
Return lRet

//-------------------------------------------------------------------------------------------------------
Static Function GeraDv11(cData)
LOCAL L, D, P := 0
L := LEN(cdata)
D := 0
P := 1
WHILE L > 0
     P := P + 1
     D := D + (VAL(SUBSTR(cData, L, 1)) * P)
     IF P = 9
          P := 1
     ENDIF
     L := L - 1
ENDDO
D := 11 - (mod(D,11))
IF D >= 10
    D := 0
ENDIF
RETURN(D)

// Utilizado no MATA140 E MATA103 E MATA910
User Function MGFVALSR()
Local nI     := 0
Local cTexto := ''
For nI := 1 TO Len(cSerie)
    IF SubStr(cSerie,nI,1) $ 'ABCDEFGHIJKLMNOPQRSTUVWYXZ0123456789'
         cTexto += SubStr(cSerie,nI,1)
    ElseIf SubStr(cSerie,nI,1) $ "-*+!@#$%¨&*()=/<>;.,"
        MsgAlert("Existem caracteres inválidos no campo série. Informe a série da nota novamente.","MGFVALSR")
        cTexto := SPACE(03)
    EndIF
Next nI
cTexto := PADR(cTexto, TamSX3("F1_SERIE")[1] )
Return cTexto

// Utilizado no MATA140 E MATA103 E MATA910
User Function MGFVALNF()
Local nI     := 0
Local cTexto := ''
For nI := 1 TO Len(cnfiscal)
    IF SubStr(cnfiscal,nI,1) $ 'ABCDEFGHIJKLMNOPQRSTUVWYXZ0123456789'
         cTexto += SubStr(cnfiscal,nI,1)
    ElseIf SubStr(cnfiscal,nI,1) $ "-*+!@#$%¨&*()=/<>;.,"
        MsgAlert("Existem caracteres inválidos no campo da nota fiscal. Informe o número da Nota novamente.","MGFVALNF")
        cTexto := SPACE(09)
    EndIF
Next nI
cTexto := PADR(cTexto, TamSX3("F1_DOC")[1] )
Return cTexto

// Utilizado no MATA910
User Function MGFVAESP()
    lRet := .T.
    cQuery  :=  "SELECT F1_FILIAL UNIDADE, F1_FORNECE CLIENTE, F1_LOJA LOJA, F1_DOC NF, F1_SERIE SERIE, F1_CHVNFE CHAVE_NFE,F1_STATUS STATUS" + ENTER
    cQuery  +=  " FROM " + RetSQLName( "SF1" ) + " SF1 "                  + ENTER
    cQuery  +=  " WHERE  SF1.F1_FILIAL   =   '" + xFilial( "SF1" ) + "' " + ENTER
    cQuery  +=  "    AND SF1.F1_FORNECE     =   '" + cA100For        + "' " + ENTER
    cQuery  +=  "    AND SF1.F1_LOJA        =   '" + cLoja           + "' " + ENTER
    cQuery  +=  "    AND SF1.F1_DOC         =   '" + cNFiscal        + "' " + ENTER
    cQuery  +=  "    AND SF1.F1_ESPECIE     =   '" + Alltrim(cEspecie)        + "' " + ENTER
    cQuery  +=  "    AND SF1.D_E_L_E_T_  <>  '*' "                        + ENTER
    TCQuery cQuery New Alias "QRYSF1"
    QRYSF1->( DbGoTop() )
    Count To nReg
    If  nReg > 0 
        QRYSF1->( DbGoTop() )
        MsgAlert("Documento em duplicidade.","MGFVALESP")    
        lRet := .f.
    EndIf
    QRYSF1->(DbCloseArea())
Return lRet
