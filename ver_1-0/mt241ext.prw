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
Local _lAchou  := .F. //Variavel criada para Busca do usuario no cadastro de Liberação de usuario

If FindFunction("U_MGFEST81")
	_lAchou := U_MGFEST81(_lAchou,__cUserID,FUNNAME())
	If !_lAchou
		u_MGFmsg("Usuário sem permissão para utilizar esta opção!!!")
	EndIf
Endif	

If _lAchou //Se o usuário está no cadastro de liberação ou a rotina está desativada torna o _lachou verdadeiro para continuar 
	If FindFunction("U_Est26VEst")
		lRet := U_Est26VEst()
	Endif	
Else
	lRet:=.F.
EndIf

Return(lRet)
