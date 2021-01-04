#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'TOTVS.CH'
/*/
=====================================================================================
{Protheus.doc} MGFGFE55
limpar campo ao excluir “Documento de Frete”

@description
Ao excluir “Documento de Frete” deverá ser limpo o campo no Romaneio  
“Valor do Desconto”
“Número do Documento de Frete”

@autor Antonio Carlos
@since 18/11/2019
@type user function 
@table
 GWN - Romaneio 
 
@menu
 =====================================================================================
/*/
User Function MGFGFE55()

	Local aArea		:= Getarea()
	Local lRet 		:= .T.

    dbSelectArea('GWN')
    RecLock('GWN',.F.)
    GWN->GWN_ZVLDES := 00
    GWN->GWN_ZDOCFR := " "
    MsUnLock()	 

    GWN->(dbCloseArea())

	Restarea(aArea)

Return lRet