#include 'protheus.ch'
#include 'totvs.ch'

/*/{Protheus.doc} MGFFAT60
//TODO Executa gatilho para Complemento de Preço
@author leonardo.kume
@since 30/11/2017
@version 6
@return string, conteudo do campo enviado 
@param cCampo, characters, descricao
@type function
/*/
USER FUNCTION MGFFAT60(cCampo)
	If ExistTrigger("C5_CLIENTE")
		RunTrigger(1,,,,"C5_CLIENTE")
	EndIf	
RETURN cCampo
