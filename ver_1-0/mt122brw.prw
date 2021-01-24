#include 'protheus.ch'
#include 'parmtype.ch'

user function MT122BRW()
	
	If findfunction("U_MGFCTB09")
		AADD(aRotina,{	OemtoAnsi("Incluir Rateio") ,'U_MGFCTB09', 0 , 4, 0, nil })  
	Endif

	If findfunction("U_xmc8122m")
		AADD(aRotina,{	OemtoAnsi("Log de Aprovacao") ,'U_xmc8122m', 0 , 4, 0, nil })  
	Endif

	
return