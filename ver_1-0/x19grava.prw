/*/{Protheus.doc} X19GRAVA
//TODO PE Formulas, Valida��o de inclus�o Altera��o e Exclus�o 
@author leonardo.kume
@since 26/09/2017
@version 6

@type function
/*/
User Function X19GRAVA()

If Findfunction("u_CTB05CHK")
	u_CTB05CHK(SM4->M4_CODIGO)
Endif
	
Return .T.