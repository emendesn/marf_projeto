#Include "RWMAKE.CH"
#INCLUDE 'PROTHEUS.CH'

/*
{Protheus.doc} MGFFINBG 
@description 
    Será utilizado para verificar parametro se usuario pode excluir titulo liberado para pagamento
@author Renato Junior
@Type Chamado no PE FA050UPD
@since 12/05/2020
@history 
    12/05/2020 - RTASK0011089 / RITM0032109
*/
User Function MGFFINBG()
//Local lRet      :=   .T.
Local cNomePar  := "MGF_FINBG"  // Nome do Parametro que determina Usuario(s) que podem excluir titulos em aberto
Local cMensage  :=  "Não pode excluir pois tem título a pagar liberado (Em Aberto) "
Local _aLegend  :=  {}
Local nI        :=  0
local cQualCor  :=  "BR_VERDE"
Local aArea     := GetArea()
Local _cKeySF1  :=  xfilial("SE2")+SF1->(F1_FORNECE+F1_LOJA+F1_SERIE+F1_DOC)

DBSELECTAREA("SE2")
dbsetorder(6)       // E2_FILIAL, E2_FORNECE, E2_LOJA, E2_PREFIXO, E2_NUM
If SE2->(dbSeek(_cKeySF1))

    If !ExisteSx6(cNomePar)
        CriarSX6(cNomePar, "C", "Usuario(s) que podem excluir titulos em aberto", 'smerenda|mneto')
    Endif

    _aLegend  :=  Fa040Legenda("SE2")
    While ! SE2->(EOF()) .AND. SE2->(E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM) == _cKeySF1
            // Verifica se Titulo está em Aberto
            For nI  :=  1   to len(_aLegend)
                If &("SE2->("+_aLegend[nI][1]+")")  // Achou o status
                    If  _aLegend[nI][2] $   cQualCor
                        If ! (AllTrim(UsrRetName(__cUserID))    $   SuperGetMV(cNomePar,.F.,'smerenda|mneto') ) // Usuario(s) que podem excluir titulos em aberto
                            MsgAlert(cMensage)
                            RestArea(aArea)
                            Return(.F.)
                        Endif
                    Else
                        Exit
                    Endif
                Endif
            Next
            SE2->(DBSKIP())
    Enddo
Endif

RestArea(aArea)
Return(.T.)
