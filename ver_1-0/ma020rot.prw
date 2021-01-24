#Include "Protheus.ch"

/*
=====================================================================================
Programa............: MA020ROT
Autor...............: Marcos Andrade / Mauricio Gresele         
Data................: 14/09/2016 
Descricao / Objetivo: Ponto de entrada para incluir rotina no acoes relacionadas fornecedor
Doc. Origem.........: 
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/
User Function MA020ROT()
Local aRotina:= {}

If FindFunction("u_FIN02Menu")
	u_FIN02Menu(@aRotina)
Endif
If FindFunction("u_MGFFIS03")
	U_MGFFIS03(@aRotina)
Endif

 
Return(aRotina)             

