#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'TBICONN.CH'

/*
=====================================================================================
Programa.:              F090REST
Autor....:              Luis Artuso
Data.....:              08/09/2016
Descricao / Objetivo:   Chamada do P.E. F090REST para salvar os arquivos processados na rotina de baixa automatica.
Doc. Origem:            Contrato - GAP MGFINT03
Solicitante:            Cliente
Uso......:              
Obs......:
=====================================================================================
*/
User Function F090REST()

If Findfunction("U_MGFINT15")
	U_MGFINT15()
Endif
Return
