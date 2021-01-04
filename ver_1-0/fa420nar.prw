#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'TBICONN.CH'
/*
=====================================================================================
Programa.:              FA420NAR
Autor....:              Luis Artuso
Data.....:              05/09/2016
Descricao / Objetivo:   Retornar o conteudo do diretorio destino do CNAB. O conteudo deste parametro substitui o pergunte que informa
						o diretorio destino de geracao do arquivo. Motivo: Nao permitir que o usuario informe o destino e manuseie o arquivo gerado.
Doc. Origem:            Contrato - GAP MGFINT03
Solicitante:            Cliente
Uso......:              
Obs......:
=====================================================================================
*/
USER FUNCTION FA420NAR

	Local cRet	:= ""

If findfunction("U_MGFINT13")
	cRet	:= U_MGFINT13()
Endif

RETURN cRet