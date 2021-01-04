#INCLUDE "protheus.ch"
#INCLUDE "FWMVCDEF.CH"
/*
============================================================================================================================
Programa.:              MT125DELOK 
Autor....:              Antonio Carlos        
Data.....:              10/11/2017                                                                                                            
Descricao / Objetivo:   Excluir registro na tabela de amarração Contrato de Parceria x Filial de Entrega
Doc. Origem:            Compras - GAP ID104
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Ponto de Entrada executado no progama MATA125  
============================================================================================================================
*/  
user function MT125DELOK()

	If findfunction('U_MGFCOM59')
		U_MGFCOM59()
	Endif

return(.T.)