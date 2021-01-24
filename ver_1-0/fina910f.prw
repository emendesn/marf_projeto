#Include "Protheus.ch"

/*/{Protheus.doc} FINA910F
//TODO Descrição auto-gerada.
@author thiago.queiroz
@since 02/10/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function FINA910F()



	Local aRetorno := {}
	Local aArea    := Getarea()
	Local cBanco	:= ""
	Local cAgencia	:= ""
	Local cConta	:= ""
	
	
	
	

	cBanco 	:= "422"


	cAgencia := "11500"


	cConta := "11575"





	aRetorno := { cBanco , cAgencia , cConta }







	RestArea( aArea )
Return( aRetorno )
