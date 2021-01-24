#Include 'Protheus.ch'

/*
=====================================================================================
Programa............: F040ADLE
Autor...............: Joni Lima
Data................: 11/04/2016
Descrição / Objetivo: O ponto de Entrada F040ADLE adiciona Legenda
Doc. Origem.........: GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: http://tdn.totvs.com/display/public/mp/F040ADLE+-+Adicionar+legenda+em+FINA040+--+24368;jsessionid=8432074F3F380413A5E9A926D031EBAB
=====================================================================================
*/
User Function F040ADLE()
	
	Local aLegenda := PARAMIXB
	
	If UPPER(Alltrim(FunName())) $ 'FINA050|FINA080|FINA090|FINA091|FINA240|FINA290|FINA750'
		AADD(aLegenda,{'BR_MARRON_OCEAN','Adiantamento sem Mov.Bancária'})
		AADD(aLegenda,{'BR_VIOLETA','Não Existe Grade Cadastrada'})
		AADD(aLegenda,{"BR_AMARELO",'Titulo aguardando liberacao'})
		AADD(aLegenda,{'BR_PINK','Titulo aguardando Geração de Alçada'})
		BrwLegenda('Titulos Pagar', "Legenda", aLegenda)
	Else
		BrwLegenda('Titulos Receber', "Legenda", aLegenda)
	EndIf
	
Return aLegenda

