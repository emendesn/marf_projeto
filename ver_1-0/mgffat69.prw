#include "protheus.ch"
#include "topconn.ch"

/*
=====================================================================================
Programa............: MGFFAT69
Autor...............: Totvs
Data................: Abril/2018
Descricao / Objetivo: Rotina chamada pelo ponto de entrada MA030TOK
Doc. Origem.........: Faturamento
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/
User Function MGFFAT69()

Local lRet := .T.           

// valida se tem mais de 15 digitos apos a virgula do endereco
// taura aceita somente 15 digitos no campo de numero do endereco e a integracao do cliente com o taura, envia como numero tudo que vem depois da primeira virgula do endereco
If At(",",M->A1_END) > 0
	If Len(Alltrim(Subs(M->A1_END,At(",",M->A1_END)+1))) > 15		
		Help( " ", 1, "Endereço do cliente", ,"Atenção, campo de 'Endereço' com mais de 15 dígitos após a vírgula. Taura não aceita este tamanho.", 1, 0, /*lPop*/, /*hWnd*/, /*nHeight*/, /*nWidth*/, /*lGravaLog*/, {"Informe dados corretos."} /*aSoluc*/ )
		lRet := .F.
		/*
		APMsgStop("Atenção, campo de 'Endereço' com mais de 15 dígitos após a vírgula."+CRLF+;
		"Taura não aceita este tamanho. Ajuste o campo.")
		*/
	Endif
Endif		
Return(lRet)
