/*
=====================================================================================
Programa.:              F070ALTV
Autor....:              Atilio Amarilla
Data.....:              03/10/2017
Descricao / Objetivo:   PE acionado na busca de dados adicionais na baixa do CR.
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              PE rotina FINA070.
=====================================================================================
*/
User Function F070ALTV()

//������������������������������������������������������������������������Ŀ
//�GAP CRE041 - manter valor de desconto para t�tulo com baixa parcial     �
//��������������������������������������������������������������������������
If ExistBlock("MGFFIN69")
	U_MGFFIN69()
EndIf

Return