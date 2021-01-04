/*
=====================================================================================
Programa.:              F650VAR
Autor....:              Atilio Amarilla
Data.....:              22/05/2017
Descricao / Objetivo:   PE acionado no relatorio de arquivo CNAB. Busca ID CNAB 
Doc. Origem:            
Solicitante:            Cliente
Uso......:              
Obs......:              PE rotina FINA200
=====================================================================================
*/
User Function F650VAR()
// OBS: FAZER TODOS OS TRATAMENTOS PARA FILTRO DO RELATORIO NESTE PONTO DE ENTRADA.
// NAO USAR EM HIPOTESE NENHUMA O PE FR650FIL, POIS CASO SEJA USADO ESTE PE APENAS PARA CONTAS A PAGAR OU RECEBER
// , UM IMPACTA NO OUTRO, POIS ESTE PE NAO RECEBE A VARIAVEL LACHOUTIT E COM ISSO PERDE O CONTEUDO ANTERIOR DESTA VARIAVEL,
// QUANDO A CARTEIRA ( PAGAR OU RECEBER ) NAO EH TRATADA NESTE PE.

//������������������������������������������������������������������������Ŀ
//�GAP CNAB - Se existe ID CNAB importado (E1_ZIDCNAB), busca E1_IDCNAB    �
//��������������������������������������������������������������������������
//If ExistBlock("MGFFIN49")
//	U_MGFFIN49()
//EndIf

If MV_PAR07 == 1
	If ExistBlock("MGFFIN89")
		U_MGFFIN89()
	EndIf
Endif	

IF MV_PAR07 == 2
	If ExistBlock("MGFFIN90")
		U_MGFFIN90()
	EndIf
ENDIF
// rotina para tratar a variavel cNumTit quando esta estah em branco no arquivo de retorno
//If ExistBlock("FIN89650Tp")
//	U_FIN89650Tp()
//Endif	

Return