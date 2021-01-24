#include 'protheus.ch'
#include 'parmtype.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} 

Descri��o do PE: PONTOS DE ENTRADA NA GERA��O DA APURA��O DO ICMS 
	
@author Wagner Neves
@since 19/03/2020
@version P12.1.17
/*/
//-------------------------------------------------------------------

User Function A952CONT()

    If MSGYESNO("Deseja imprimir a apura��o do IPI ? ")
	    Matr942()
	EndIF

Return