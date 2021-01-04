#Include "Protheus.ch"
#Include "FWMVCDEF.CH"
#Include "FWMBROWSE.CH"
#Include "TOPCONN.CH"

/*/{Protheus.doc} FA060Qry
//TODO Descrição auto-gerada.
@author thiago.queiroz
@since 02/10/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function FA060Qry()

	Local cRet := ""
	

	cRet := " E1_NUMBCO <> ' ' AND ((SF2.F2_CHVNFE <> ' ' AND E1_ORIGEM = 'MATA460') OR (SF2.F2_CHVNFE = '' AND E1_ORIGEM = 'FINA040')) "

Return cRet
