#Include 'Protheus.ch'

/*
=====================================================================================
Programa............: FA740BRW
Autor...............: Jose Roberto 
Data................: 23/08/2019
Descricao / Objetivo: O ponto de entrada FA740BRW - adicionar rotina no menu opcoes relacionadas
Doc. Origem.........: GRADE ERP
Solicitante.........: Cliente
Uso.................: 
Obs.................: Inserir opcao Despesas de Cartorio 
=====================================================================================
Alterado em : 18/11/2019 
Por : Paulo da Mata
Obs.: Incluir a rotina de Automacao do processo de inclusao de RA
*/
//---------------------------------------
User Function FA740BRW()
//---------------------------------------
Local aRot := PARAMIXB
Local aRet := {}

AADD(aRet, {'Custo Cartorio',"U_MGFFINBB",   0 , 1 }) 
AADD(aRet, {'Importar RA'   ,"U_MGFINT71",   0 , 1 })
	
Return aRet