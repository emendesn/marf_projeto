#Include 'Protheus.ch'

/*
=====================================================================================
Programa............: FINALEG
Autor...............: Joni Lima
Data................: 11/04/2016
Descrição / Objetivo: O ponto de entrada FINALEG é utilizado para customizar as legendas de Mbrowse do módulo Financeiro.O resultado deste ponto de entrada substitui as legendas padrões do sistema.
Doc. Origem.........: GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: http://tdn.totvs.com/display/public/mp/FINALEG+-+Customiza+legenda+de+Mbrowse+--+23046
=====================================================================================
*/
User Function FINALEG()	
	Local nReg   := PARAMIXB[1]
	Local cAlias := PARAMIXB[2]
	
	Local aRet := {}
	
	If cAlias == 'SE2' 
		Aadd(aRet,{'(ROUND(E2_SALDO,2) = 0 .AND. (EMPTY(E2_ZNEXGRD) .and. !(EMPTY(E2_ZCODGRD)))) .or. (ROUND(E2_SALDO,2) = 0 .AND. E2_TIPO == "NDF")','BR_VERMELHO' } )
		Aadd(aRet,{'ROUND(E2_SALDO,2)+ ROUND(E2_SDACRES,2) # ROUND(E2_VALOR,2)+ ROUND(E2_ACRESC,2) .AND. (EMPTY(E2_ZNEXGRD) .and. !(EMPTY(E2_ZCODGRD)))', 'BR_AZUL' } )

		Aadd(aRet,{'E2_TIPO == "PA " .and. ROUND(E2_SALDO,2) > 0 .AND. (EMPTY(E2_ZNEXGRD) .and. !(EMPTY(E2_ZCODGRD)) .and. !(EMPTY(E2_DATALIB)) ) .AND. U_MGFFIN62()','BR_BRANCO' } )
		Aadd(aRet,{'!Empty(E2_NUMBOR) .AND. (EMPTY(E2_ZNEXGRD) .and. !(EMPTY(E2_ZCODGRD)))','BR_PRETO' } )

		Aadd(aRet,{'E2_TIPO == "PA " .and. ROUND(E2_SALDO,2) > 0 .AND. (EMPTY(E2_ZNEXGRD) .and. !(EMPTY(E2_ZCODGRD)) .and. !(EMPTY(E2_DATALIB)) ) .AND. !U_MGFFIN62()','BR_MARRON_OCEAN' } )
		

		Aadd(aRet,{'!Empty(E2_NUMBOR) .and.(ROUND(E2_SALDO,2)+ ROUND(E2_SDACRES,2) # ROUND(E2_VALOR,2)+ ROUND(E2_ACRESC,2)) .AND. (EMPTY(E2_ZNEXGRD) .and. !(EMPTY(E2_ZCODGRD)))','BR_CINZA' } )
		Aadd(aRet,{'E2_TIPO $ "INA/TXA" .and. ROUND(E2_SALDO,2) > 0 .And. E2_OK == "TA"   .AND. (EMPTY(E2_ZNEXGRD) .and. !(EMPTY(E2_ZCODGRD)))','BR_MARROM' } )
		Aadd(aRet,{'EMPTY(E2_DATALIB) .AND. (E2_SALDO+E2_SDACRES-E2_SDDECRE) > GetMV("MV_VLMINPG") .AND. E2_SALDO > 0 .AND. (EMPTY(E2_ZNEXGRD) .and. !(EMPTY(E2_ZCODGRD)))','BR_AMARELO' } )
		Aadd(aRet,{'(ALLTRIM(E2_ORIGEM) $ "FINA667|FINA677") .and. E2_MOEDA > 1 .AND. E2_TXMOEDA == 0 .AND. E2_SALDO > 0 .AND. (EMPTY(E2_ZNEXGRD) .and. !(EMPTY(E2_ZCODGRD)))','BR_LARANJA' } )
		AADD(aRet,{" ALLTRIM(E2_ZNEXGRD) == 'S' .and. !(EMPTY(E2_ZIDGRD))",'BR_VIOLETA'})
		AADD(aRet,{" ( EMPTY(E2_ZIDGRD) ).OR. (!EMPTY(E2_ZIDGRD) .AND. EMPTY(E2_ZNEXGRD) .AND. EMPTY(E2_ZCODGRD) )",'BR_PINK'})
		Aadd(aRet,{'.T.','BR_VERDE'} )
	Else
		Aadd(aRet,{'ROUND(E1_SALDO,2) = 0','BR_VERMELHO'} )
		Aadd(aRet,{'!Empty(E1_NUMBOR) .and.(ROUND(E1_SALDO,2) # ROUND(E1_VALOR,2))','BR_CINZA'} )
		Aadd(aRet,{'E1_TIPO == "RA " .and. ROUND(E1_SALDO,2) > 0 .And. !FXAtuTitCo()','BR_BRANCO'} )
		Aadd(aRet,{'!Empty(E1_NUMBOR)','BR_PRETO'} )
		Aadd(aRet,{'ROUND(E1_SALDO,2) + ROUND(E1_SDACRES,2) # ROUND(E1_VALOR,2) + ROUND(E1_ACRESC,2) .And. !FXAtuTitCo()','BR_AZUL'} )
		Aadd(aRet,{'ROUND(E1_SALDO,2) == ROUND(E1_VALOR,2) .and. E1_SITUACA == "F"','BR_AMARELO'} )
		Aadd(aRet,{'.T.','BR_VERDE'} )
	EndIf
	
Return aRet