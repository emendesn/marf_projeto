#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'TBICONN.CH'

/*
=====================================================================================
Programa.:              F420CRP
Autor....:              Luis Artuso
Data.....:              08/09/2016
Descricao / Objetivo:   Exibe a tela com o conteudo do diretorio e possibilita salvar na pasta de arquivos enviados (backup).
Doc. Origem:            Contrato - GAP MGFINT03
Solicitante:            Cliente
Uso......:              
Obs......:
=====================================================================================
*/
User Function F420CRP()

If findfunction("U_MGFINT14")
	U_MGFINT14()
Endif
Return
