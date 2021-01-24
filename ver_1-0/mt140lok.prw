#include 'protheus.ch'
#include 'parmtype.ch'
/*---------------------------------------------------------------------------------------------------------------------------*
| Desenvolvedor: Caroline Cazela					Data: 11/12/2018														|
| P.E.:  MT140LOK																											|                                                                                                            |
| Desc:  Chamado pelo ponto de entrada MT120OK		                                                                        |
| Obs.:  Valida��o de campos para regra cont�bil (conta cont�bil e classe valor)-> MIT 157									|
*---------------------------------------------------------------------------------------------------------------------------*/
User Function MT140LOK() 
	Local lExecuta := .T. 

	If lExecuta
		If findfunction("U_MGFCOMB6")
			lExecuta := U_MGFCOMB6()
		Endif
	Endif 
return lExecuta