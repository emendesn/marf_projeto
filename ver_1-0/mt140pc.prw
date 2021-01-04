#include 'protheus.ch'
#include 'parmtype.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} MT40PC
GAP126 - Exce��es para Documento de Entrada sem Pedido de Compra
Precisa tamb�m do codigo fonte MFGFIS30


@author Natanael Sim�es
@since 07/03/2018
@version P12.1.17

Ponto de entrada

Manipula o par�metro MV_PCNFE
LOCALIZA��O: Ma140LinOk() - Validacao da Getdados
EM QUE PONTO : No inicio da valida��o. Este Ponto de Entrada tem por objetivo manipular o par�metro MV_PCNFE utilizado na Pr� Nota de Entrada a ser gerada


/*/
//-------------------------------------------------------------------

user function MT140PC()
	
Local lPCNFe := .F.

lPCNFe := PARAMIXB[1] 

lPCNFe := .F.

return lPCNFe