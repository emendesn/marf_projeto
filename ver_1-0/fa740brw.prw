#Include 'Protheus.ch'

/*
=====================================================================================
Programa............: FA740BRW
Autor...............: Jos� Roberto 
Data................: 23/08/2019
Descri��o / Objetivo: O ponto de entrada FA740BRW - adicionar rotina no menu op��es relacionadas
Doc. Origem.........: GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Inserir op��o Despesas de Cart�rio 
=====================================================================================
Alterado em : 18/11/2019 
Por : Paulo da Mata
Obs.: Incluir a rotina de Automa��o do processo de inclus�o de RA
*/
//---------------------------------------
User Function FA740BRW()
//---------------------------------------
Local aRot := PARAMIXB
Local aRet := {}

AADD(aRet, {'Custo Cart�rio',"U_MGFFINBB",   0 , 1 }) 
AADD(aRet, {'Importar RA'   ,"U_MGFINT71",   0 , 1 }) // Paulo da Mata - Marfrig - 18/11/2019
	
Return aRet