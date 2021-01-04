/*
===========================================================================================
Programa.:              MGFCOM90
Autor....:              Totvs
Data.....:              Julho/2018
Descricao / Objetivo:   Rotina chamada pelo ponto de entrada A100DEL
Doc. Origem:            
Solicitante:            Cliente
Uso......:              
Obs......:               
===========================================================================================
*/
User Function MGFCOM90()

Local lRet := .T.

//If IsInCallStack("A140EstCla") // estorno de classificacao
	If Alltrim(SF1->F1_ORIGEM) == "GFEA065" .and. !IsInCallStack("GFEA065") //cModulo != "GFE"
		lRet := .F.
		APMsgStop("Estorno de classificacao de documentos incluidos pelo GFE, somente devem ser realizadas pelo modulo GFE.")
	Endif
//Endif		

Return(lRet) 