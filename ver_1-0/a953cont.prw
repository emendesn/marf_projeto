#include 'protheus.ch'
#include 'parmtype.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} 

Descrição do PE: PONTOS DE ENTRADA NA GERAÇÃO DA APURAÇÃO DO ICMS 
	
@author Wagner Neves
@since 19/03/2020
@version P12.1.17
/*/
//-------------------------------------------------------------------

User Function A953CONT()

    If MSGYESNO("Deseja imprimir a apuração do ICMS ? ")
	    Matr940()
	EndIF
    
Return