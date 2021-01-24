/*
=====================================================================================
Programa............: MT094END
Autor...............: Totvs
Data................: 02/02/2018 
Descricao / Objetivo: Compras 
Doc. Origem.........: Compras
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Ponto de Entrada apos alteracao no registro da SCR na liberacao de documentos
=====================================================================================
*/
User Function MT094END()

If FindFunction("U_MGFCOM71")
	U_MGFCOM71()
Endif	

If FindFunction("U_MGFCOM72")
	U_MGFCOM72()
Endif	

Return()