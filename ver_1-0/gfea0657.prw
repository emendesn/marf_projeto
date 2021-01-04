#Include "Protheus.ch"
#Include "TOPCONN.CH"

/*/{Protheus.doc} GFEA0657
//TODO Descricao auto-gerada.
@author thiago.queiroz
@since 02/10/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function GFEA0657()
	Local aRotina := {}

	AADD(aRotina,{	OemtoAnsi("Integracao Frete Produtor Rural") ,"u_GFE65XC(.F., '2', .T.)", 0 ,11 })
	AADD(aRotina,{	OemtoAnsi("Desatualiza Integracao Frete Produtor Rural") ,"u_GFE65XD(.F., '2', .T.)", 0 ,11 })
	AADD(aRotina,{	OemtoAnsi("Alteracao Cond. Pgto - CLIENTE") ,"u_MGFCONPG(.F., '2', .T.)", 0 ,11 })

Return aRotina
