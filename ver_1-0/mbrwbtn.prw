/*
===========================================================================================
Programa.:              MBrwBtn
Autor....:              Mauricio Gresele
Data.....:              Maio/2017
Descricao / Objetivo:   P.E. para validacao de todas as opcoes de todas as mbrowse.
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:               
===========================================================================================
*/
// *******************************
//OBS: USAR ESTE PONTO DE ENTRADA COM CUIDADO EXTREMO, POIS O MESMO EH ACIONADO EM TODAS AS OPCOES DE TODAS AS MBROWSE DO SISTEMA.
// *******************************
User Function MBrwBtn()

Local lRet := .T.

If FindFunction("U_Est26Brw")
	lRet := U_Est26Brw()
Endif	

Return(lRet)