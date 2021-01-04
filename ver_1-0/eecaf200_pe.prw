#Include 'Protheus.ch'

/*
==========================================================================================
Programa.:              MA030BUT
Autor....:              Leonardo Kume
Data.....:              Nov/2016
Descricao / Objetivo:   Ponto de entrada para atualizar as datas do follow up 
  						Pedido Exportacao
Doc. Origem:            EEC03
Solicitante:            Cliente
Uso......:              
==========================================================================================
*/

User Function EECAF200()

If findfunction ("u_MGFDT15")
u_MGFDT15() 
Endif

If (IsInCallStack("U_MGFINT72") .Or. IsInCallStack("U_MONINT72") ) .and. GetNewPar('MGF_INT72X' , .T.)
	If ParamIXB == "AF200GPARC_ALTDTEMBA"
		U_MGFEEC80()
	EndIf
EndIf


Return 

