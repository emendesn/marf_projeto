/*
=====================================================================================
Programa............: MA103BUT
Autor...............: Totvs
Data................: 02/02/2018 
Descricao / Objetivo: Compras 
Doc. Origem.........: Compras
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Ponto de Entrada para inclusao de botoes na tela de documento de entrada
=====================================================================================
*/
User Function MA103BUT()

Local aBotao := {}
Local lMGFFIS35 := SuperGetMV("MGF_FIS35L",.T.,.F.) //Habilita as funcionalidades do MGFFIS35/GAP133

If FindFunction("U_MGFCOM64")
	aBotao := U_MGFCOM64()
Endif

//GAP133 - Inclusão manual da data de entrada da Nota Fiscal eletrônica para operações de Busca de Gado
If (IIf(Type("l103Class")!="U",l103Class,.T.);
	 .OR. IIf(Type("l103Visual")!="U",l103Visual,.T.));
	 .AND. lMGFFIS35

	aAdd(aBotao,{"Dt Ent. de Gado",{|| U_MGFFIS35()},"Dt Ent. de Gado"})
Endif	

Return(aBotao)