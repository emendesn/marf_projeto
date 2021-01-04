#include 'protheus.ch'
#include 'parmtype.ch'


/*
=====================================================================================
Programa.:              EICDI500
Autor....:              Leo Kume
Data.....:              19/10/2016
Descricao / Objetivo:   Ponto de Entrada para filtrar o despachante logado
Doc. Origem:            Easy Import Control - GAP EIC07
Solicitante:            Cliente
Uso......:              
Obs......:              Ponto de entrada padrao MVC EICDI500                   
=====================================================================================
*/
user function EICDI500()
//Local xRetorn

If findfunction("U_MGFEIC02")
	U_MGFEIC02() //Programa para filtrar Embarques/Desembaraco do Despachante logado
Endif	
If findfunction("U_EIC06x")
	U_EIC06x() //Programa para retornar numeracao automatica caso aperte para cancelar a tela
Endif	
If findfunction("U_EIC06c")
	U_EIC06c() //Programa para confirmar a numeracao automatica caso grave as alteracoes
Endif	
If findfunction("U_EIC09INC")
	U_EIC09INC() //Programa para incluir PC referente as despesas de desembaraco - RVBJ 
Endif	

return