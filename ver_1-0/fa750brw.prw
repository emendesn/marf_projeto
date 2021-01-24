#Include 'Protheus.ch'

/*
=====================================================================================
Programa............: FA750BRW
Autor...............: Joni Lima
Data................: 11/04/2016
Descri��o / Objetivo: O ponto de entrada FA750BRW foi desenvolvido para adicionar itens no menu da mBrowse. Retorna array com as op��es e manda como par�metro o array com as op��es padr�o.
Doc. Origem.........: GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: http://tdn.totvs.com/pages/releaseview.action?pageId=6071251
=====================================================================================
*/
User Function FA750BRW()
	
	Local aRot := PARAMIXB
	
	Local aRet := {}
	
	AADD(aRet, {'Log AProvacao',"U_xMC8750M",   0 , 1 }) //Adicionado Joni 11/04/2017 - GRADE ERP
	AADD(aRet, {'Gera��o de PA',"U_xMC8PAM",   0 , 1 }) //Adicionado Joni 11/04/2017 - GRADE ERP
	AADD(aRet, {'Altera Venc.PA-EIC',"U_xPAEIC()",   0 , 1 }) //Adicionado Andy 08/11/2018 
	
Return aRet