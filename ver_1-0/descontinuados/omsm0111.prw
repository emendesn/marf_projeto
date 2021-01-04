#include 'protheus.ch'
#include 'parmtype.ch'

user function OMSM0111()

Local cTpFrete := SC5->C5_TPFRETE 
	
	// comentado em 05/09/18 por gresele, pois este fonte encontra o codigo da regra do tipo de operacao do gfe, mas este codigo deve ser encontrado pela funcao MGFGFE32, que eh um job
	//If FindFunction("U_MGFGFE14")
	//	U_MGFGFE14()
	//Endif
	
return cTpFrete