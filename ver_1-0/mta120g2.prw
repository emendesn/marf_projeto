//Bibliotecas
#Include "Protheus.ch"

/*/
=============================================================================
{Protheus.doc} MTA120G2 
Ponto de Entrada para gravar informações no pedido de compra a cada item (usado junto com MT120TEL)

@description
Ponto de Entrada para gravar informações no pedido de compra a cada item (usado junto com MT120TEL)

@author Rodrigo Franco
@since 19/03/2020 
@type Function  

@table 
    SC7 - Pedido de Compra


@history //Manter até as últimas 3 manutenções do fonte para facilitar identificação de versão, remover esse comentário 
/*/   

User Function MTA120G2()

    Local _aArea  := GetArea()
    Local _lMTA120G2 := SuperGetMV("MFG_MTA120",.F.,.T.) // Desabilita a funcionalidade RITM0032854 - Exibir o Solicitante e o Comprador nos Pedidos de Compras 

    If _lMTA120G2 
        MFGMTA120()
    Endif

    RestArea(_aArea)

Return

Static Function MFGMTA120()
Local _nCompr := GetAdvFVal("SY1","Y1_COD",xFilial("SY1")+RetCodUsr(),3,"")
Local _cSolic := GetAdvFVal("SC1","C1_SOLICIT",xFilial("SC1")+SC7->(C7_NUMSC+C7_ITEMSC),1,"")
        
SC7->C7_COMPRA := _nCompr
SC7->C7_SOLICIT := _cSolic
    
_nCompr := ""
_cSolic := ""
        
Return