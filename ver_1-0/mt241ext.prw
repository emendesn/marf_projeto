/*
===========================================================================================
Programa.:              MT241EXT
Autor....:              Mauricio Gresele
Data.....:              Maio/2017
Descricao / Objetivo:   P.E. para validacao do estorno na rotina MATA241.
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:               
===========================================================================================
*/
User Function MT241EXT()

Local lRet 	   := .T.
Local _lAchou  := .F. //Variavel criada para Busca do usuario no cadastro de Libera��o de usuario

If FindFunction("U_MGFEST81")
	_lAchou := U_MGFEST81(_lAchou,__cUserID,FUNNAME())
	If !_lAchou
		u_MGFmsg("Usu�rio sem permiss�o para utilizar esta op��o!!!")
	EndIf
Endif	

If _lAchou //Se o usu�rio est� no cadastro de libera��o ou a rotina est� desativada torna o _lachou verdadeiro para continuar 
	If FindFunction("U_Est26VEst")
		lRet := U_Est26VEst()
	Endif	
Else
	lRet:=.F.
EndIf

Return(lRet)
