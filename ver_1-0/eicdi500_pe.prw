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
Uso......:              Marfrig
Obs......:              Ponto de entrada padrão MVC EICDI500                   
=====================================================================================
*/
user function EICDI500()
//Local xRetorn

If findfunction("U_MGFEIC02")
	U_MGFEIC02() //Programa para filtrar Embarques/Desembaraço do Despachante logado
Endif	
If findfunction("U_EIC06x")
	U_EIC06x() //Programa para retornar numeração automática caso aperte para cancelar a tela
Endif	
If findfunction("U_EIC06c")
	U_EIC06c() //Programa para confirmar a numeração automática caso grave as alterações
Endif	
If findfunction("U_EIC09INC")
	U_EIC09INC() //Programa para incluir PC referente as despesas de desembaraco - RVBJ 
Endif	

return