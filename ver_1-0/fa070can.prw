#include 'protheus.ch'
// #include 'parmtype.ch'
#include "totvs.ch"
//#include "protheus.ch"
#include "topconn.ch"
//#include "fwbrowse.ch"
//#include 'fwmvcdef.ch'


/*
=====================================================================================
Programa.:              FA070CAN
Autor....:              Edilson Mendes Nascimento
Data.....:              24/10/2020
Descricao / Objetivo:   Ponto de Entrada executado no momento do estorno da compensacao de titulos.
Doc. Origem:            GAP MGFINT06
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              http://tdn.totvs.com/pages/releaseview.action?pageId=6087685
=====================================================================================
*/
user function FA070CAN()

local aArea := SE1->(GetArea())

    begin sequence

        IF SE1->E1_XINTSFO <> "P"
            begin transaction
                recLock("SE1", .F.)
                    SE1->E1_XINTSFO := "P"
                SE1->(msUnLock())
            end transaction
        ENDIF

    end sequence

    RestArea( aArea )

return
