#Include "RwMake.ch"

/*/{Protheus.doc} Rfine24
//TODO Descrição auto-gerada.
@author thiago.queiroz
@since 02/10/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function Rfine24()








	SetPrvt("_identemp,")

























	_identemp := "0"
	_identemp := _identemp + "0" + SUBSTR(SEE->EE_CODCART,1,2)
	_identemp := _identemp + STRZERO(VAL(SUBSTR(Alltrim(SA6->A6_AGENCIA),1,Len(AllTrim(SA6->A6_AGENCIA))-1)),5)
	_identemp := _identemp + STRZERO(VAL(Alltrim(SA6->A6_NUMCON)),8)

Return(_identemp)
