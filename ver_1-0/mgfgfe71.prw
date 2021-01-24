#include "totvs.ch"
#include "RWMAKE.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "APWEBEX.CH"
#include "APWEBSRV.CH"
#include "FWMVCDEF.CH"  

/*/{Protheus.doc} MGFGFE71	 
Processamento de integracao de inicio de viagem
@type function

@author Josue Danich 
@since 26/10/2020
@version P12
/*/


User function MGFGFE71()


	U_MFCONOUT('Iniciando integracao de inicio de viagem...') 
	
	U_MFCONOUT('Iniciando envio de sinal de inicio de viagem para o multiembarcador...') 
	MGFGFE71A()
	U_MFCONOUT('Completou envio de sinal de inicio de viagem para o multiembarcador...') 

	U_MFCONOUT('Iniciando recuperação de xmls dos ctes no multiembarcador...') 
	MGFGFE71B()
	U_MFCONOUT('Completou recuperação de xmls dos ctes no multiembarcador...') 

	U_MFCONOUT('Iniciando envio dos xmls de ctes para o CtePack...')
	MGFGFE71C()
	U_MFCONOUT('Completou envio dos xmls de ctes para o CtePack...')

	U_MFCONOUT('Iniciando recuperação de NFSs do multiembarcador...')
	MGFGFE71D()
	U_MFCONOUT('Completou recuperação de NFSs do multiembarcador...')

    U_MFCONOUT('Iniciando gravação de NFSs no Protheus...')
	MGFGFE71E()
	U_MFCONOUT('Completou gravação de NFSs no Protheus...')

Return

/*/{Protheus.doc} MGFGFE71A
Envio de integração de data de inicio de viagem
@type function

@author Josué Danich 
@since 27/10/2020
*/
static function MGFGFE71A()

	local nStatuHttp	:= 0
	local aHeadStr		:= {}	
	local cHeaderRet	:= ""
	local nTimeOut		:= 600
	local cTimeIni		:= ""
	local cTimeFin		:= ""
	local cTimeProc		:= ""
	local cHttpRet		:= ""
	local jCustomer		:= nil
	local cJsonRet		:= ""
	local cRetStatus	:= ""
	Local cUrl	 := GetMv("MGF_GFE71A",,"http://integracoes.marfrig.com.br:1672/multiembarcador/api/v1/InformarInicioViagemCarga") 
	Local ntot    := 0
	Local cjson := " "


	cQuery := " SELECT ZHJ_UUID, R_E_C_N_O_ AS RECN "
	cQuery += " FROM " + RetSqlName("ZHJ")
	cQuery += "  WHERE ZHJ_STATUS  = ' ' AND ZHJ_DATAR >= '" + DTOS(DATE() - GETMV("MGF_GFE71T",,60)) + "'"
	cQuery += "  AND D_E_L_E_T_= ' ' "

	If select("ZHJTMP") > 0
		ZHJTMP->(Dbclosearea())
	Endif

	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"ZHJTMP", .F., .T.)
	
	If ZHJTMP->(eof())	
		U_MFCONOUT("Não existem envios de inicio de viagem pendentes de processamento!")
		Return
	Else
		U_MFCONOUT("Contando envios de inicio de viagem pendentes de processamento...")
		_ntot := 0
		Do while ZHJTMP->(!eof())
			_ntot++
			ZHJTMP->(Dbskip())
		Enddo
		ZHJTMP->(Dbgotop())
	Endif
	
	_nnt := 1

	Do while ZHJTMP->(!eof())	

		U_MFCONOUT("Processando envio de inicio de viagem " + strzero(_nnt,6) + " de " +  strzero(_ntot,6) + "...")
		ZHJ->(Dbgoto(ZHJTMP->RECN))

		BEGIN SEQUENCE

		jCustomer := nil
		_cfilial := ""
		_cerro := ""
		_ccarga := ""

		if fwJsonDeserialize( ZHJ->ZHJ_JSONR, @jCustomer )
			cJsonRet := ZHJ->ZHJ_JSONR

			If AttIsMemberOf( JCUSTOMER, "Filial") 
			
				_cfilial := alltrim(JCUSTOMER:Filial)

			Else

				_cerro := "Json sem tag de filial"
				BREAK

			Endif

			If AttIsMemberOf( JCUSTOMER, "NumeroOrdemEmbarque") 
			
				_ccarga := alltrim(JCUSTOMER:NumeroOrdemEmbarque)

			Else

				_cerro := "Json sem tag de ordem de embarque"
				BREAK

			Endif

			DAI->(Dbsetorder(1)) //DAI_FILIAL+DAI_COD

			If !(DAI->(Dbseek(_cfilial+_ccarga))) 

				_cerro := "Carga informada (" + _cfilial + "/" + _ccarga + ") não foi localizada"
				BREAK

			Endif

			If DAI->DAI_XINTME != "I" .OR. empty(DAI->DAI_XRETWS) .or. val(DAI->DAI_XRETWS) = 0

				_cerro := "Carga informada (" + _cfilial + "/" + _ccarga + ") não foi integrada ao Multiembarcador"
				BREAK

			Endif

			_cprotocolo := alltrim(DAI->DAI_XRETWS)

			If empty(_cerro)
	
				U_MFCONOUT("Enviando data de inicio de viagem para multiembarcador  "  + _cfilial + "/";
												+ _ccarga + " - " + strzero(_nnt,6) + " de " +  strzero(_ntot,6) + "...")
	
				cHeadRet 	:= ""
				aHeadOut	:= {}
				cJson		:= ""
				cTimeIni	:= ""
				cTimeProc	:= ""
				xPostRet	:= Nil
				nStatuHttp	:= 0
				nTimeOut    := 600

				aadd( aHeadOut, 'Content-Type: application/json' )

				_cdata := substr(dtos(date()),1,4) + "-" + substr(dtos(date()),5,2) + "-" + substr(dtos(date()),7,2) 

				cjson := "{ "
				cjson +='   "protocoloCarga": "' + _cprotocolo  + '", '
   				cjson +=' 		"data": "' + _CDATA + '", '
   				cjson +=' 		"hora": "' + TIME() + '" '
				cjson +=' } '
				
				cTimeIni := time()

				U_MFCONOUT("Enviando URL...: " + cUrl )
				U_MFCONOUT("Enviando Json..: " + cjson )

				xPostRet := httpQuote( cUrl /*<cUrl>*/, "POST" /*<cMethod>*/, /*[cGETParms]*/, cJson/*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadOut /*[aHeadStr]*/, @cHeadRet /*[@cHeaderRet]*/ )

				nStatuHttp	:= 0
				nStatuHttp	:= httpGetStatus()

				cTimeFin	:= time()
				cTimeProc	:= elapTime( cTimeIni, cTimeFin )

				If AllTrim( str( nStatuHttp ) ) = '200'

					U_MFCONOUT("Retorno com status 200...: " +  xPostRet)

				Elseif AllTrim( str( nStatuHttp ) ) = '400' .and. (('possui a data de' $ xPostRet) .or. ('(Finalizada)' $ xPostRet))

					//Se a carga está finalizada ou já possui data de inicio de viagem continua o processo
					U_MFCONOUT("Retorno válido com status 400...: " +  xPostRet)

				Else

					U_MFCONOUT("Retorno com status " + strzero(nStatuHttp,6) + ", reenviando...")
					_cerro := "Erro no envio para multiembarcador: " + strzero(nStatuHttp,6) + " - " + xPostRet

					For l := 1 To 5

						If ! Empty( cJson )
							U_MFCONOUT("Reenviando URL ("+strzero(l,1)+" de 5)...: " + cUrl )
							U_MFCONOUT("Reenviando Json ("+strzero(l,1)+" de 5)..: " + cjson )
							xPostRet := httpQuote( cUrl /*<cUrl>*/, "POST" /*<cMethod>*/, /*[cGETParms]*/, cJson/*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadOut /*[aHeadStr]*/, @cHeadRet /*[@cHeaderRet]*/ )

							nStatuHttp	:= 0
							nStatuHttp	:= httpGetStatus()
							If AllTrim( str(nStatuHttp)) = '200'
								U_MFCONOUT("Retorno com status 200...: " +  xPostRet)
								l := 5
								_cerro := ""
							Else
								U_MFCONOUT("Retorno com status " + strzero(nStatuHttp,6) + ", reenviando...")
							Endif

						Endif

					Next l

				Endif

			Endif

		Else

			_cerro := "Json invalido"
			BREAK

		Endif

		END SEQUENCE

		If empty(_cerro)
			_cerro := strzero(nStatuHttp,6) + " - " + xPostRet
			_cstatus := 'I'
		Else
			_cstatus := ' '
		Endif
		

		Reclock("ZHJ",.F.)
		ZHJ->ZHJ_FILIAL := _cfilial
		ZHJ->ZHJ_CARGA := _ccarga
		ZHJ->ZHJ_DATAI := date()
		ZHJ->ZHJ_HORAI := time()
		ZHJ->ZHJ_URLI  := cUrl
		ZHJ->ZHJ_JSONIE := cjson
		ZHJ->ZHJ_JSONIR := _cerro
		ZHJ->ZHJ_STATUS := _cstatus
		ZHJ->(Msunlock())
		

		U_MFCONOUT("Completou envio de data de inicio de viagem para multiembarcador  "  + _cfilial + "/";
									+ _ccarga + " - " + strzero(_nnt,6) + " de " +  strzero(_ntot,6) + " com resultado " + _cerro)

		ZHJTMP->(Dbskip())
		_nnt++

	Enddo

Return

/*/{Protheus.doc} MGFGFE71B
Recupera xmls de cte do multiembarcador
@type function

@author Josué Danich 
@since 27/10/2020
*/
static function MGFGFE71B()

	local nStatuHttp	:= 0
	local aHeadStr		:= {}	
	local cHeaderRet	:= ""
	local nTimeOut		:= 600
	local cTimeIni		:= ""
	local cTimeFin		:= ""
	local cTimeProc		:= ""
	local cHttpRet		:= ""
	local jCustomer		:= nil
	local cJsonRet		:= ""
	local cRetStatus	:= ""
	Local cUrl	 := GetMv("MGF_GFE71B",,"http://integracoes.marfrig.com.br:1672/multiembarcador/api/v1/cte/{protocoloIntegracaoCarga}/xml") 
	Local ntot    := 0
	Local cjson := " "


	cQuery := " SELECT ZHJ_UUID, R_E_C_N_O_ AS RECN "
	cQuery += " FROM " + RetSqlName("ZHJ")
	cQuery += "  WHERE ZHJ_STATUS  = 'I' AND ZHJ_DATAR >= '" + DTOS(DATE() - GETMV("MGF_GFE71T",,60)) + "'"
	cQuery += "  AND D_E_L_E_T_= ' ' "

	If select("ZHJTMP") > 0
		ZHJTMP->(Dbclosearea())
	Endif

	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"ZHJTMP", .F., .T.)
	
	If ZHJTMP->(eof())	
		U_MFCONOUT("Não existem recuperações de xml pendentes de processamento!")
		Return
	Else
		U_MFCONOUT("Contando recuperações de xml pendentes de processamento...")
		_ntot := 0
		Do while ZHJTMP->(!eof())
			_ntot++
			ZHJTMP->(Dbskip())
		Enddo
		ZHJTMP->(Dbgotop())
	Endif
	
	_nnt := 1

	Do while ZHJTMP->(!eof())	

		U_MFCONOUT("Processando recuperação de xml " + strzero(_nnt,6) + " de " +  strzero(_ntot,6) + "...")
		ZHJ->(Dbgoto(ZHJTMP->RECN))

		BEGIN SEQUENCE

		cHeadRet 	:= ""
		aHeadOut	:= {}
		cJson		:= ""
		cTimeIni	:= ""
		cTimeProc	:= ""
		xPostRet	:= Nil
		nStatuHttp	:= 0
		nTimeOut    := 600
		_cerro      := ""
		_cfilial    := alltrim(ZHJ->ZHJ_FILIAL)
		_ccarga     := alltrim(ZHJ->ZHJ_CARGA)

		DAI->(Dbsetorder(1)) //DAI_FILIAL+DAI_COD

		If !(DAI->(Dbseek(_cfilial+_ccarga))) 

			_cerro := "Carga informada (" + _cfilial + "/" + _ccarga + ") não foi localizada"
			BREAK

		Endif

		cUrl	 := GetMv("MGF_GFE71B",,"http://integracoes.marfrig.com.br:1672/multiembarcador/api/v1/cte/{protocoloIntegracaoCarga}/xml")  
		curl := strtran(curl,"{protocoloIntegracaoCarga}",alltrim(DAI->DAI_XRETWS) )

		aadd( aHeadOut, 'Content-Type: application/json' )

		cjson := ""

		U_MFCONOUT("Enviando URL...: " + cUrl )
		U_MFCONOUT("Enviando Json..: " + cjson )

		xPostRet := httpQuote( cUrl /*<cUrl>*/, "GET" /*<cMethod>*/, /*[cGETParms]*/, cJson/*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadOut /*[aHeadStr]*/, @cHeadRet /*[@cHeaderRet]*/ )

		nStatuHttp	:= 0
		nStatuHttp	:= httpGetStatus()

		If AllTrim( str( nStatuHttp ) ) = '200'

			U_MFCONOUT("Retorno com status 200...: " +  xPostRet)

		Else

			U_MFCONOUT("Retorno com status " + strzero(nStatuHttp,6) + ", reenviando...")
			_cerro := "Erro no envio para multiembarcador: " + strzero(nStatuHttp,6) + " - " + xPostRet

			For l := 1 To 5

				If ! Empty( cJson )
					U_MFCONOUT("Reenviando URL ("+strzero(l,1)+" de 5)...: " + cUrl )
					U_MFCONOUT("Reenviando Json ("+strzero(l,1)+" de 5)..: " + cjson )
					xPostRet := httpQuote( cUrl /*<cUrl>*/, "GET" /*<cMethod>*/, /*[cGETParms]*/, cJson/*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadOut /*[aHeadStr]*/, @cHeadRet /*[@cHeaderRet]*/ )

					nStatuHttp	:= 0
					nStatuHttp	:= httpGetStatus()
					If AllTrim( str(nStatuHttp)) = '200'
						U_MFCONOUT("Retorno com status 200...: " +  xPostRet)
						l := 5
						_cerro := ""
					Else
						U_MFCONOUT("Retorno com status " + strzero(nStatuHttp,6) + ", reenviando...")
					Endif

				Endif

			Next l

		Endif

		END SEQUENCE

		If empty(_cerro)
			_cerro := xPostRet
			_cstatus := 'X'
		Else
			_cstatus := 'I'
		Endif
		

		Reclock("ZHJ",.F.)
		ZHJ->ZHJ_FILIAL := _cfilial
		ZHJ->ZHJ_CARGA := _ccarga
		ZHJ->ZHJ_DATAX := date()
		ZHJ->ZHJ_HORAX := time()
		ZHJ->ZHJ_URLX  := cUrl
		ZHJ->ZHJ_JSONXE := cjson
		ZHJ->ZHJ_JSONXR := _cerro
		ZHJ->ZHJ_STATUS := _cstatus
		ZHJ->(Msunlock())
		

		U_MFCONOUT("Completou recuperação de xml do multiembarcador  "  + _cfilial + "/";
									+ _ccarga + " - " + strzero(_nnt,6) + " de " +  strzero(_ntot,6) + " com resultado " + _cerro)

		ZHJTMP->(Dbskip())
		_nnt++

	Enddo

Return


/*/{Protheus.doc} MGFGFE71C
Envia xmls de cte para o CTEPack
@type function

@author Josué Danich 
@since 27/10/2020
*/
static function MGFGFE71C()

	local nStatuHttp	:= 0
	local aHeadStr		:= {}	
	local cHeaderRet	:= ""
	local nTimeOut		:= 600
	local cTimeIni		:= ""
	local cTimeFin		:= ""
	local cTimeProc		:= ""
	local cHttpRet		:= ""
	local jCustomer		:= nil
	local cJsonRet		:= ""
	local cRetStatus	:= ""
	Local cUrl	 := GetMv("MGF_GFE71C",,"http://integracoes.marfrig.com.br:1675/ctepack/api/v1/salvarArquivo") 
	Local ntot    := 0
	Local cjson := " "


	cQuery := " SELECT ZHJ_UUID, R_E_C_N_O_ AS RECN "
	cQuery += " FROM " + RetSqlName("ZHJ")
	cQuery += "  WHERE ZHJ_STATUS  = 'X' AND ZHJ_DATAR >= '" + DTOS(DATE() - GETMV("MGF_GFE71T",,60)) + "'"
	cQuery += "  AND D_E_L_E_T_= ' ' "

	If select("ZHJTMP") > 0
		ZHJTMP->(Dbclosearea())
	Endif

	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"ZHJTMP", .F., .T.)
	
	If ZHJTMP->(eof())	
		U_MFCONOUT("Não existem envios de xml pendentes de processamento!")
		Return
	Else
		U_MFCONOUT("Contando envios de xml pendentes de processamento...")
		_ntot := 0
		Do while ZHJTMP->(!eof())
			_ntot++
			ZHJTMP->(Dbskip())
		Enddo
		ZHJTMP->(Dbgotop())
	Endif
	
	_nnt := 1

	Do while ZHJTMP->(!eof())	

		U_MFCONOUT("Processando envio de xml " + strzero(_nnt,6) + " de " +  strzero(_ntot,6) + "...")
		ZHJ->(Dbgoto(ZHJTMP->RECN))

		BEGIN SEQUENCE

		cHeadRet 	:= ""
		aHeadOut	:= {}
		cJson		:= ""
		cTimeIni	:= ""
		cTimeProc	:= ""
		xPostRet	:= Nil
		nStatuHttp	:= 0
		nTimeOut    := 600
		_cerro      := ""
		_cfilial    := alltrim(ZHJ->ZHJ_FILIAL)
		_ccarga     := alltrim(ZHJ->ZHJ_CARGA)

		DAI->(Dbsetorder(1)) //DAI_FILIAL+DAI_COD

		If !(DAI->(Dbseek(_cfilial+_ccarga))) 

			_cerro := "Carga informada (" + _cfilial + "/" + _ccarga + ") não foi localizada"
			BREAK

		Endif

		If fwJsonDeserialize( ZHJ->ZHJ_JSONXR, @jCustomer ) .AND. VALTYPE(jCustomer) = "A"

			For _nnk := 1 to len(jcustomer)
	
				aadd( aHeadOut, 'Content-Type: application/json' )

				_cnomearq := "CTe-Carga_" + _ccarga + "-" + alltrim(str(_nnk))

				cjson := '{'
				cjson +=  '"ConteudoArquivo": "' + STRTRAN(alltrim(jcustomer[_nnk]),'"',"'") + '",'
  				cjson +=  '"NomeArquivo": "' + _cnomearq + '"'
				cjson +=  '}'

				U_MFCONOUT("Enviando URL...: " + cUrl )
				U_MFCONOUT("Enviando Json..: " + cjson )

				xPostRet := httpQuote( cUrl /*<cUrl>*/, "POST" /*<cMethod>*/, /*[cGETParms]*/, cJson/*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadOut /*[aHeadStr]*/, @cHeadRet /*[@cHeaderRet]*/ )

				nStatuHttp	:= 0
				nStatuHttp	:= httpGetStatus()
				_cerrot := ""

				If AllTrim( str( nStatuHttp ) ) = '200' .or. AllTrim( str( nStatuHttp ) ) = '500'

					U_MFCONOUT("Retorno com status 200/500...: " +  xPostRet)

				Else

					U_MFCONOUT("Retorno com status " + strzero(nStatuHttp,6) + ", reenviando...")
					_cerrot := "Erro no envio para ctepack: " + strzero(nStatuHttp,6) + " - " + xPostRet

					For l := 1 To 5

						If ! Empty( cJson )
							U_MFCONOUT("Reenviando URL ("+strzero(l,1)+" de 5)...: " + cUrl )
							U_MFCONOUT("Reenviando Json ("+strzero(l,1)+" de 5)..: " + cjson )
							xPostRet := httpQuote( cUrl /*<cUrl>*/, "POST" /*<cMethod>*/, /*[cGETParms]*/, cJson/*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadOut /*[aHeadStr]*/, @cHeadRet /*[@cHeaderRet]*/ )

							nStatuHttp	:= 0
							nStatuHttp	:= httpGetStatus()
							If AllTrim( str(nStatuHttp)) = '200'
								U_MFCONOUT("Retorno com status 200...: " +  xPostRet)
								l := 5
								_cerrot := ""
							Else
								U_MFCONOUT("Retorno com status " + strzero(nStatuHttp,6) + ", reenviando...")
							Endif

						Endif

					Next l

				Endif

				_cerro += _cerrot

			Next

		Else

			_cerro := "Json de xmls invalido"
			xpostret := "Json de xmls invalido"

		Endif

		END SEQUENCE

		If empty(_cerro) .or. _cerro  == "Json de xmls invalido"
			_cerro := xPostRet
			_cstatus := 'S'
		Else
			_cstatus := 'X'
		Endif
		

		Reclock("ZHJ",.F.)
		ZHJ->ZHJ_FILIAL := _cfilial
		ZHJ->ZHJ_CARGA := _ccarga
		ZHJ->ZHJ_DATAE := date()
		ZHJ->ZHJ_HORAE := time()
		ZHJ->ZHJ_URLE  := cUrl
		ZHJ->ZHJ_JSONEE := cjson
		ZHJ->ZHJ_JSONRE := _cerro
		ZHJ->ZHJ_STATUS := _cstatus
		ZHJ->(Msunlock())
		

		U_MFCONOUT("Completou envio de xml para ctepack  "  + _cfilial + "/";
									+ _ccarga + " - " + strzero(_nnt,6) + " de " +  strzero(_ntot,6) + " com resultado " + _cerro)

		ZHJTMP->(Dbskip())
		_nnt++

	Enddo

Return

/*/{Protheus.doc} MGFGFE71D
Recupera notas de serviço do multiembarcador
@type function

@author Josué Danich 
@since 27/10/2020
*/
static function MGFGFE71D()

	local nStatuHttp	:= 0
	local aHeadStr		:= {}	
	local cHeaderRet	:= ""
	local nTimeOut		:= 600
	local cTimeIni		:= ""
	local cTimeFin		:= ""
	local cTimeProc		:= ""
	local cHttpRet		:= ""
	local jCustomer		:= nil
	local cJsonRet		:= ""
	local cRetStatus	:= ""
	Local cUrl	 := GetMv("MGF_GFE71B",,"http://integracoes.marfrig.com.br:1672/multiembarcador/api/v1/carga/{protocoloIntegracaoCarga}/notafiscalservico") 
	Local ntot    := 0
	Local cjson := " "


	cQuery := " SELECT ZHJ_UUID, R_E_C_N_O_ AS RECN "
	cQuery += " FROM " + RetSqlName("ZHJ")
	cQuery += "  WHERE ZHJ_STATUS  = 'S' AND ZHJ_DATAR >= '" + DTOS(DATE() - GETMV("MGF_GFE71T",,60)) + "'"
	cQuery += "  AND D_E_L_E_T_= ' ' "

	If select("ZHJTMP") > 0
		ZHJTMP->(Dbclosearea())
	Endif

	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"ZHJTMP", .F., .T.)
	
	If ZHJTMP->(eof())	
		U_MFCONOUT("Não existem recuperações de nota de servico pendentes de processamento!")
		Return
	Else
		U_MFCONOUT("Contando recuperações de nota de servico pendentes de processamento...")
		_ntot := 0
		Do while ZHJTMP->(!eof())
			_ntot++
			ZHJTMP->(Dbskip())
		Enddo
		ZHJTMP->(Dbgotop())
	Endif
	
	_nnt := 1

	Do while ZHJTMP->(!eof())	

		U_MFCONOUT("Processando recuperação de nota de servico " + strzero(_nnt,6) + " de " +  strzero(_ntot,6) + "...")
		ZHJ->(Dbgoto(ZHJTMP->RECN))

		BEGIN SEQUENCE

		cHeadRet 	:= ""
		aHeadOut	:= {}
		cJson		:= ""
		cTimeIni	:= ""
		cTimeProc	:= ""
		xPostRet	:= Nil
		nStatuHttp	:= 0
		nTimeOut    := 600
		_cerro      := ""
		_cfilial    := alltrim(ZHJ->ZHJ_FILIAL)
		_ccarga     := alltrim(ZHJ->ZHJ_CARGA)

		DAI->(Dbsetorder(1)) //DAI_FILIAL+DAI_COD

		If !(DAI->(Dbseek(_cfilial+_ccarga))) 

			_cerro := "Carga informada (" + _cfilial + "/" + _ccarga + ") não foi localizada"
			BREAK

		Endif

		cUrl	 := GetMv("MGF_GFE71B",,"http://integracoes.marfrig.com.br:1672/multiembarcador/api/v1/carga/{protocoloIntegracaoCarga}/notafiscalservico") 
		curl := strtran(curl,"{protocoloIntegracaoCarga}",alltrim(DAI->DAI_XRETWS) )

		aadd( aHeadOut, 'Content-Type: application/json' )

		cjson := ""

		U_MFCONOUT("Enviando URL...: " + cUrl )
		U_MFCONOUT("Enviando Json..: " + cjson )

		xPostRet := httpQuote( cUrl /*<cUrl>*/, "GET" /*<cMethod>*/, /*[cGETParms]*/, cJson/*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadOut /*[aHeadStr]*/, @cHeadRet /*[@cHeaderRet]*/ )

		nStatuHttp	:= 0
		nStatuHttp	:= httpGetStatus()

		If AllTrim( str( nStatuHttp ) ) = '200'

			U_MFCONOUT("Retorno com status 200...: " +  xPostRet)

		Else

			U_MFCONOUT("Retorno com status " + strzero(nStatuHttp,6) + ", reenviando...")
			_cerro := "Erro no envio para multiembarcador: " + strzero(nStatuHttp,6) + " - " + xPostRet

			For l := 1 To 5

				If ! Empty( cJson )
					U_MFCONOUT("Reenviando URL ("+strzero(l,1)+" de 5)...: " + cUrl )
					U_MFCONOUT("Reenviando Json ("+strzero(l,1)+" de 5)..: " + cjson )
					xPostRet := httpQuote( cUrl /*<cUrl>*/, "GET" /*<cMethod>*/, /*[cGETParms]*/, cJson/*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadOut /*[aHeadStr]*/, @cHeadRet /*[@cHeaderRet]*/ )

					nStatuHttp	:= 0
					nStatuHttp	:= httpGetStatus()
					If AllTrim( str(nStatuHttp)) = '200'
						U_MFCONOUT("Retorno com status 200...: " +  xPostRet)
						l := 5
						_cerro := ""
					Else
						U_MFCONOUT("Retorno com status " + strzero(nStatuHttp,6) + ", reenviando...")
					Endif

				Endif

			Next l

		Endif

		END SEQUENCE

		If empty(_cerro)
			_cerro := xPostRet
			_cstatus := 'W'
		Else
			_cstatus := 'S'
		Endif
		

		Reclock("ZHJ",.F.)
		ZHJ->ZHJ_FILIAL := _cfilial
		ZHJ->ZHJ_CARGA := _ccarga
		ZHJ->ZHJ_DATAS := date()
		ZHJ->ZHJ_HORAS := time()
		ZHJ->ZHJ_URLS  := cUrl
		ZHJ->ZHJ_JSONSE := cjson
		ZHJ->ZHJ_JSONSR := _cerro
		ZHJ->ZHJ_STATUS := _cstatus
		ZHJ->(Msunlock())
		

		U_MFCONOUT("Completou recuperação de nota de servico do multiembarcador  "  + _cfilial + "/";
									+ _ccarga + " - " + strzero(_nnt,6) + " de " +  strzero(_ntot,6) + " com resultado " + _cerro)

		ZHJTMP->(Dbskip())
		_nnt++

	Enddo

Return

/*/{Protheus.doc} MGFGFE71E
Envia notas de servico para o WSS15
@type function

@author Josué Danich 
@since 27/10/2020
*/
static function MGFGFE71E()


	cQuery := " SELECT ZHJ_UUID, R_E_C_N_O_ AS RECN "
	cQuery += " FROM " + RetSqlName("ZHJ")
	cQuery += "  WHERE ZHJ_STATUS  = 'W' AND ZHJ_DATAR >= '" + DTOS(DATE() - GETMV("MGF_GFE71T",,60)) + "'"
	cQuery += "  AND D_E_L_E_T_= ' ' "

	If select("ZHJTMP") > 0
		ZHJTMP->(Dbclosearea())
	Endif

	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"ZHJTMP", .F., .T.)
	
	If ZHJTMP->(eof())	
		U_MFCONOUT("Não existem envios de nota de servico pendentes...")
		Return
	Else
		U_MFCONOUT("Contando envios de nota de servico...")
		_ntot := 0
		Do while ZHJTMP->(!eof())
			_ntot++
			ZHJTMP->(Dbskip())
		Enddo
		ZHJTMP->(Dbgotop())
	Endif
	
	_nnt := 1
	
	Do while ZHJTMP->(!eof())	

		_cerro := ""
		_cstatus := '1'

		U_MFCONOUT("Processando envio de nota de servico " + strzero(_nnt,6) + " de " +  strzero(_ntot,6) + "...")
		ZHJ->(Dbgoto(ZHJTMP->RECN))

		jcustomer := nil

		If fwJsonDeserialize( ZHJ->ZHJ_JSONSR, @jCustomer ) .AND. VALTYPE(jCustomer) = "A"

			For _nnk := 1 to len(jcustomer)

				_onotaservico := MGFGFE71N():New(_nnk) //objeto principal para o wss15 

				For _nnj := 1 to len(JCUSTOMER[_nnk]:notasFisicais)

					If AttIsMemberOf(JCUSTOMER[_nnk]:notasFisicais[_nnj],"NOTASFISCAL") .and.;
						AttIsMemberOf(JCUSTOMER[_nnk]:notasFisicais[_nnj]:NOTASFISCAL,"cnpjFilial")

						_onfs := nil
						_onfs := MGFGFE71I():New(_nnk,_nnj) //objeto do array de nfs
						aadd(_onotaservico:NotaFiscal,_onfs)

					Endif

				Next

				aRetFuncao	:= u_MGFWSS15(_onotaservico) //Processa nota de serviço 

				If aRetFuncao[1][1] != "1" .AND. !("NFS JA IMPORTADA ANTERIORMENTE" $ aRetFuncao[1][2])
					_cstatus := "2"
				Endif
				_cerro += aRetFuncao[1][2] +  " - "

			Next

		Endif

		If _cstatus == '1'
			_cstatus := 'C'
		Else
			_cstatus := 'W'
		Endif

		If empty(_cerro) .and. _cstatus == 'C'
			_cerro := "Nenhuma nota de serviço processada!"
		Endif
		

		Reclock("ZHJ",.F.)
		ZHJ->ZHJ_DATAW := date()
		ZHJ->ZHJ_HORAW := time()
		ZHJ->ZHJ_LOGNFS := _cerro
		ZHJ->ZHJ_STATUS := _cstatus
		ZHJ->(Msunlock())
		

		U_MFCONOUT("Completou envio de nota de servico  "  + strzero(_nnt,6) + " de " +  strzero(_ntot,6) + " com resultado " + _cerro)

		ZHJTMP->(Dbskip())
		_nnt++

	Enddo

Return

/*/{Protheus.doc} MGFGFE71N
Classe do objeto de chamada da WSS15 (nota fiscal de servico)
@type function

@author Josué Danich 
@since 27/10/2020
*/
Class MGFGFE71N

	DATA Acao			 		as string
	DATA NrLinha				as STRING
	DATA Alterado				as string
	DATA SitEdi					as string
	DATA cnpjFilial				as string
	DATA Especie				as string
	DATA Transportador   		as string
	DATA Origem 				as string
	DATA numeroDocumento		as string
	DATA ProtocoloNFSe			as string 
	DATA OcorrenciaMulti		as string 
	DATA dataEmissao			as date
	DATA CNPJRemetente			as string
	DATA TipoDocto				as string
	DATA CFOP					as string
	DATA ValorDocumento			as float
	DATA AliquotaISS			as float
	DATA ValorISS				as float
	DATA codigoVerificacao		as string
	DATA ValorBaseCalculoISS	as float
	DATA ValorRetencaoISS		as float
	DATA PercentualImpRetido	as float
	DATA quantidadeDocumentos	as float
	DATA ValorCarga				as float
	DATA NotaFiscal				as array 

	Method New(_nnk)

EndClass

Method New(_nnk) Class MGFGFE71N

	::Acao			 		:= "I"
	::NrLinha				:= "0"
	::Alterado				:= "2"
	::SitEdi				:= "1"
	::cnpjFilial			:= STRTRAN(STRTRAN(STRTRAN(ALLTRIM(JCUSTOMER[_nnk]:cnpjFilial),"/",""),".",""),"-","")
	::Especie				:= "NFS"
	::Transportador   		:= ALLTRIM(JCUSTOMER[_nnk]:transportador)
	::Origem 				:= "1"
	::numeroDocumento		:= ALLTRIM(JCUSTOMER[_nnk]:numeroDocumento)
	::ProtocoloNFSe			:= ALLTRIM(JCUSTOMER[_nnk]:ProtocoloNFSe) 
	::OcorrenciaMulti		:= Iif(AttIsMemberOf( JCUSTOMER[_nnk], "OcorrenciaMulti"),ALLTRIM(JCUSTOMER[_nnk]:OcorrenciaMulti),"" ) 
	::dataEmissao			:= stod(strtran(ALLTRIM(JCUSTOMER[_nnk]:dataEmissao),"-",""))
	::CNPJRemetente			:= STRTRAN(STRTRAN(STRTRAN(ALLTRIM(JCUSTOMER[_nnk]:cnpjRemetente),"/",""),".",""),"-","")
	::TipoDocto				:= Iif(AttIsMemberOf( JCUSTOMER[_nnk], "TipoDocto"),ALLTRIM(JCUSTOMER[_nnk]:TipoDocto),"1" ) 
	::CFOP					:= "1933"
	::ValorDocumento		:= val(JCUSTOMER[_nnk]:ValorDocumento)
	::AliquotaISS			:= val(JCUSTOMER[_nnk]:AliquotaISS)
	::ValorISS				:= val(JCUSTOMER[_nnk]:ValorISS)
	::codigoVerificacao		:= ALLTRIM(JCUSTOMER[_nnk]:codigoVerificacao)
	::ValorBaseCalculoISS	:= val(JCUSTOMER[_nnk]:ValorBaseCalculoISS)
	::ValorRetencaoISS		:= val(JCUSTOMER[_nnk]:ValorRetencaoISS)
	::PercentualImpRetido	:= val(JCUSTOMER[_nnk]:PercentualImpRetido)
	::quantidadeDocumentos	:= JCUSTOMER[_nnk]:quantidadeDocumentos
	::ValorCarga			:= val(JCUSTOMER[_nnk]:ValorCarga)
	::NotaFiscal			:= {}

Return

/*/{Protheus.doc} MGFGFE71I
Classe do objeto de itens de chamada da WSS15 (nota fiscal de servico)
@type function

@author Josué Danich 
@since 27/10/2020
*/
Class MGFGFE71I

	DATA FilialDoc    as String
	DATA EmissorDc    as string
	DATA ChaveNfe	  as string

	Method New(_nnk,_nnj)

EndClass

Method New(_nnk,_nnj) Class MGFGFE71I

	::FilialDoc    := STRTRAN(STRTRAN(STRTRAN(ALLTRIM(JCUSTOMER[_nnk]:notasFisicais[_nnj]:NOTASFISCAL:cnpjFilial),"/",""),".",""),"-","")
	::EmissorDc    := STRTRAN(STRTRAN(STRTRAN(ALLTRIM(JCUSTOMER[_nnk]:notasFisicais[_nnj]:NOTASFISCAL:emissoDoc),"/",""),".",""),"-","")
	::ChaveNfe	   := ALLTRIM(JCUSTOMER[_nnk]:notasFisicais[_nnj]:NOTASFISCAL:chaveNFe)

Return





