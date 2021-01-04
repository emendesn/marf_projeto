#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} SPDFIS001
//TODO Ponto de Entrada para tratamento de tipo de produto no SPEDFISCAL
@author Eugenio
@since 10/04/2017
@version 1.0

@type function
/*/
User Function SPDFIS001()

Local aTipo := ParamIXB[1]

//faz o tratamento de cada tipo de produto priorizando a tabela de indicadores
If FindFunction("U_MGFFIS28")
	aTipo := U_MGFFIS28()
Endif

Return(aTipo)