#include "protheus.ch"

/*
=====================================================================================
Programa............: MGFEST42
Autor...............: Totvs
Data................: Agosto/2018 
Descricao / Objetivo: Rotina chamada pelo PE MTA265I
Doc. Origem.........: Estoque
Solicitante.........: Cliente
Uso.................: 
Obs.................: Gravacao de campos complementares no enderecamento de produto
=====================================================================================
*/
User Function MGFEST42()

If Empty(SDA->DA_ZNOMUSU)
	SDA->(RecLock("SDA",.F.))
	SDA->DA_ZNOMUSU := UsrFullName(RetCodUsr())
	SDA->(MsUnLock())
Endif	
	
Return()