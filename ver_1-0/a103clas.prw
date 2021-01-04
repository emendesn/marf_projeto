/*
=====================================================================================
Programa.:              A103CLAS
Autor....:              Atilio Amarilla
Data.....:              26/01/2017
Descricao / Objetivo:   PE para manipulacao de aCols na classificacao da Pre-Nota
Doc. Origem:            
Solicitante:            Cliente
Uso......:              
Obs......:              
=====================================================================================
*/
User Function A103CLAS()

//������������������������������������������������������������������������Ŀ
//�GAP MGFPER03 - Automacao de Vendas e Transferencias                     �
//�               Copia conteudo de D1_ZTES p/ D1_TES no aCols             �
//��������������������������������������������������������������������������
If ExistBlock("MGFEST25") //.And. FunName() == "MGFEST17"
	U_MGFEST25()
EndIf

Return