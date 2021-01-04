#include 'protheus.ch'
#include 'parmtype.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} MT40PC
GAP126 - Exceções para Documento de Entrada sem Pedido de Compra
Precisa também do codigo fonte MFGFIS30


@author Natanael Simões
@since 07/03/2018
@version P12.1.17

Ponto de entrada

Manipula o parâmetro MV_PCNFE
LOCALIZAÇÃO: Ma140LinOk() - Validacao da Getdados
EM QUE PONTO : No inicio da validação. Este Ponto de Entrada tem por objetivo manipular o parâmetro MV_PCNFE utilizado na Pré Nota de Entrada a ser gerada


/*/
//-------------------------------------------------------------------

user function MT140PC()
	
Local lPCNFe := .F.

lPCNFe := PARAMIXB[1] 

lPCNFe := .F.

return lPCNFe