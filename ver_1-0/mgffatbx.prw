//Bibliotecas
#Include "Protheus.ch"

/*/
=============================================================================
{Protheus.doc} MGFFATBX 
Programa para Incluir peso total no cabeçalho do pedido de venda

@description
Programa para Incluir peso total no cabeçalho do pedido de venda

@author Rodrigo Franco
@since 17/04/2020 
@type Function  

@table 
    SC5 - Pedido de Venda
	SC6 - Itens do Pedido de Vendas
 
@history //Manter até as últimas 3 manutenções do fonte para facilitar identificação de versão, remover esse comentário 
/*/   

User Function MGFFATBX()

    Local _aArea := GetArea()
    Local _lFATBX := SuperGetMV("MGF_FATBX1",.F.,.T.) // Ativa/Desabilita a funcionalidade RITM0022251 - Incluir peso total no cabeçalho do pedido de venda
    If FunName() == "MATA410"
        If _lFATBX 
            FATBX01()
        Endif
    ENDIF
	RestArea(_aArea)

Return .T.


Static Function FATBX01()
Local _nTotPes  := M->C5_XTOTPES
Local _nPesol   := M->C5_PESOL
Local _XV       := 0
Local _cProd    := ""
Local _cUM      := ""
Local _nQtd     := 0
Local _nSoma    := 0
Local _nTamHea  := LEN(AHEADER) + 1

FOR _XV := 1 TO LEN(ACOLS)
    IF ACOLS[_XV][_nTamHea] == .F.
        _cProd  := ACOLS[_XV][GDFIELDPOS("C6_PRODUTO")]
        _cUM    := ACOLS[_XV][GDFIELDPOS("C6_UM")]
        _nQtd   := ACOLS[_XV][GDFIELDPOS("C6_QTDVEN")]
        IF Alltrim(_cUM) == "KG"
            _nSoma := _nSoma + _nQtd
        Else
            DbselectArea("SB1")
            DbSetOrder(1)
            if DbSeek(xFilial("SC6")+alltrim(_cProd))
                If Alltrim(SB1->B1_SEGUM) == "KG"
                    _nSoma := _nSoma + (SB1->B1_CONV * _nQtd)
                Endif
            Endif
        Endif
    ENDIF    
NEXT _XV
           
M->C5_XTOTPES   := _nSoma

If oGetPV <> Nil
    oGetPV:Refresh()
EndIf 

Return