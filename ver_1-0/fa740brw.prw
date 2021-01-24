#Include 'Protheus.ch'

/*
=====================================================================================
Programa............: FA740BRW
Autor...............: José Roberto 
Data................: 23/08/2019
Descrição / Objetivo: O ponto de entrada FA740BRW - adicionar rotina no menu opções relacionadas
Doc. Origem.........: GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Inserir opção Despesas de Cartório 
=====================================================================================
Alterado em : 18/11/2019 
Por : Paulo da Mata
Obs.: Incluir a rotina de Automação do processo de inclusão de RA
*/
//---------------------------------------
User Function FA740BRW()
//---------------------------------------
Local aRot := PARAMIXB
Local aRet := {}

AADD(aRet, {'Custo Cartório',"U_MGFFINBB",   0 , 1 }) 
AADD(aRet, {'Importar RA'   ,"U_MGFINT71",   0 , 1 }) // Paulo da Mata - Marfrig - 18/11/2019
	
Return aRet