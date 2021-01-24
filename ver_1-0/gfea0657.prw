#Include "Protheus.ch"
#Include "TOPCONN.CH"

/*/{Protheus.doc} GFEA0657
//TODO Descri��o auto-gerada.
@author thiago.queiroz
@since 02/10/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function GFEA0657()
	Local aRotina := {}

	AADD(aRotina,{	OemtoAnsi("Integra��o Frete Produtor Rural") ,"u_GFE65XC(.F., '2', .T.)", 0 ,11 })
	AADD(aRotina,{	OemtoAnsi("Desatualiza Integra��o Frete Produtor Rural") ,"u_GFE65XD(.F., '2', .T.)", 0 ,11 })
	AADD(aRotina,{	OemtoAnsi("Altera��o Cond. Pgto - MARFRIG") ,"u_MGFCONPG(.F., '2', .T.)", 0 ,11 })

Return aRotina
