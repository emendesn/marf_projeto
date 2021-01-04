#include 'protheus.ch'
#include 'parmtype.ch'

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              FA040GRV
Autor....:              Gustavo Ananias Afonso
Data.....:              24/10/2016
Descricao / Objetivo:   O ponto de entrada FA040GRV sera executado apos a gravacao de todos os dados referentes ao titulo e antes da contabilizacao.
Doc. Origem:            GAP MGFINT06
Solicitante:            Cliente
Uso......:              
Obs......:              http://tdn.totvs.com/pages/releaseview.action?pageId=6071098
=====================================================================================
*/
user function FA040GRV()
    
	If FindFunction("U_MGFFIN82")
		U_MGFFIN82()
    Endif  

	If findfunction("U_MGFFAT22")
		U_MGFFAT22()
	Endif
	
	If FindFunction("U_CRE2905")
	U_CRE2905()
    Endif  


return