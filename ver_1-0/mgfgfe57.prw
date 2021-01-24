#INCLUDE "PROTHEUS.CH"
#INCLUDE "XMLXFUN.CH"
#INCLUDE "TOTVS.CH"

/*/
{Protheus.doc} MGFGFE57
    Tela para bloqueio e desbloqueio de Importa��o e Processamento dos XML's.

@description
    Esta rotina � para flexibilizar o bloqueio e a libera��o do
    schedule de importa��o de XML do CTE. Ser� criado um menu
    customizado para que o usu�rio possa liberar / bloquear o
    processo no per�odo de fechamento.

@author Marcos Vieira
@since 26/03/2020

@version P12.1.017
@country Brasil
@language Portugu�s

@type User Function

@param
    Foi criado o par�metro MGF_GFE57A - Permite o processamento dos CTEs. : .T. ou .F.

@menu
    GEST�O DE FRETE EMBARCADOR --> MARFRIG --> Lib Proces CTE.

@history

@return Nill
/*/



User Function MGFGFE57()
 
    Local _lLib         :=  .T.
    Local _cTxtCbc      :=  "Importa��o e Processamento de xml's : "
    Local _nRet         :=  .T.
    Local _cFunc        :=  "MGFGFE57"
    Local _cPathProc    := AllTrim( SuperGetMV("MGF_FATAY1",.T.,"\\spdwfapl214\m$\Totvs\Microsiga\protheus_data\xmlCTe\"))
    Local _cPathNProc   := _cPathProc+"NoProcess\"

    //--------------| Verifica exist�ncia de par�metros e caso n�o exista, cria. |-----
    If !ExisteSx6("MGF_GFE57A")
        CriarSX6("MGF_GFE57A", "L", "Permite o processamento dos CTEs.", .T. )
    EndIf

    _lLib   :=  GetMV("MGF_GFE57A", , .T.)

    If _lLib
        _cTxtCbc +=  "LIBERADO"
    Else
        _cTxtCbc +=  "BLOQUEADO"
    EndIf

    If _lLib 
        _cTipo  :=  "B"
        _cMsg   :=  "Bloqueia a Importacao e o Processamento dos XML's"
        _nRet   :=  Aviso(_cTxtCbc, "Deseja Bloquear a Importa��o e o Processamento dos XML's?", { "Bloquear", "Cancelar" }, 2)
        _nRet   :=  iif(_nRet = 1, .F., .T.)  
    Else 
        _cTipo  :=  "L"
        _cMsg   :=  "Libera a Importacao e o Processamento dos XML's"
        _nRet   :=  Aviso(_cTxtCbc, "Deseja liberar a Importa��o e o Processamento dos XML's?", { "Liberar", "Cancelar" }, 2)
        _nRet   :=  iif(_nRet = 1, .T., .F.)
    EndIf

    If _lLib .AND. !_nRet   // Bloquear a importa��o e o processamento dos XML's
        If CV8->(FieldPos("CV8_IDMOV")) > 0 .And. !Empty(CV8->(IndexKey(5)))
            _cIdCV8:= GetSXENum("CV8","CV8_IDMOV",,5)
            ConfirmSX8()
        EndIf
        GravaCV8(_cTipo, _cFunc, _cMsg, Nil, Nil, Nil, Nil, _cIdCV8)
        PutMV("MGF_GFE57A", .F.)
        PutMV("MV_XMLDIR", _cPathNProc)
        Alert('Processamento bloqueado')
    ElseIf !_lLib .AND. _nRet 
        If CV8->(FieldPos("CV8_IDMOV")) > 0 .And. !Empty(CV8->(IndexKey(5)))
            _cIdCV8:= GetSXENum("CV8","CV8_IDMOV",,5)
            ConfirmSX8()
        EndIf
        GravaCV8(_cTipo, _cFunc, _cMsg, Nil, Nil, Nil, Nil, _cIdCV8)
        PutMV("MGF_GFE57A", .T.)
        PutMV("MV_XMLDIR", _cPathProc)
        Alert("Importa��o e processamento do XML's liberados.")
    EndIf
Return 