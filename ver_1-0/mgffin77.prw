#Include "totvs.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"

//
//
//
//
//
/*/{Protheus.doc} MGFFIN77
//TODO Descrição auto-gerada.
@author thiago.queiroz
@since 02/10/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function MGFFIN77()

	if len( allTrim( cNumTit ) ) > 10
		SE1->( DBOrderNickName("MGFXIDCNAB") )
		if SE1->( DBSeek( cNumTit ) )
			cFilAnt		:= SE1->E1_FILIAL
			lAchouTit	:= .T.
			nPos		:= 1
		endif
	else
		SE1->( DBSetOrder( 19 ) )
		if SE1->( DBSeek( Substr( cNumTit, 1 , 10 ) ) )
			cFilAnt		:= SE1->E1_FILIAL
			lAchouTit	:= .T.
			nPos		:= 1
		endif
	endif

return lAchouTit
