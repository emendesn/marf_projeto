#Include  "Protheus.ch"
#Include  "FwMVCDef.ch"
#Define   ENTER Chr( 13 ) + Chr( 10 )

/*===================================================================================+
|  Programa............:   M410lDel()                                                |
|  Autor...............:   johnny.osugi@totvspartners.com.br                         |
|  Data................:   23/10/2018                                                |
|  Descricao / Objetivo:   Ponto de entrada que trata a respeito das delecoes dos    |
|                          itens da grid do MATA410.                                 |
|  Doc. Origem.........:                                                             |
|  Solicitante.........:                                                             |
|  Uso.................:   Marfrig                                                   |
|  Obs.................:                                                             |
+===================================================================================*/
User Function M410lDel()  // ("eme" "410" "ele" "de" "e" "ele")
Local aArea := GetArea()
Local lRet  := .T.

If FindFunction( "U_DELITEM" )
   lRet := u_DelItem() // >>>-----> Encontrado no MGFFATAK.prw
EndIf 

RestArea( aArea )
Return( lRet )
