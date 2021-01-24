#include "totvs.ch"
#include "RWMAKE.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "APWEBEX.CH"
#include "APWEBSRV.CH"
#include "FWMVCDEF.CH"  

/*/{Protheus.doc} MGFFATC6	 
Processamento de integração Keyconsult
@type function

@author Josue Danich 
@since 11/11/2020
@version P12
/*/


User function MGFFATC6()

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
	Local cUrl	        := ""
	Local ntot    := 0
	Local cjson := " "
	
    U_MFCONOUT("Carregando pedidos pendentes da keyconsult na tabela ZC5...")

	_csituacoes := getmv("MGFFATC6S",,"ATIVA,ATIVO,HABILITADO,HABILITADA,HABILITADO ATIVO")
	_csuframa   := getmv("MGFFATC6E",,"AM")
	_ntents		:= getmv("MGFFATC6T",,10)


	cQuery := " SELECT  R_E_C_N_O_ AS RECN "
	cQuery += " FROM " + RetSqlName("ZC5")
	cQuery += "  WHERE ZC5_STATUS  = '1' AND ZC5_DTRECE >= '" + DTOS(DATE()-1) + " '"
	cQuery += "  AND D_E_L_E_T_= ' ' "

	If select("ZC5TMP") > 0
		ZC5TMP->(Dbclosearea())
	Endif

	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"ZC5TMP", .F., .T.)
	
	If ZC5TMP->(eof())	
		U_MFCONOUT("Não existem pedidos pendentes da keyconsult na tabela ZC5!")
		Return
	Else
		U_MFCONOUT("Contando pedidos pendentes da keyconsult na tabela ZC5...")
		_ntot := 0
		Do while ZC5TMP->(!eof())
			_ntot++
			ZC5TMP->(Dbskip())
		Enddo
		ZC5TMP->(Dbgotop())
	Endif
	
	_nnt := 1

	Do while ZC5TMP->(!eof())	


		BEGIN TRANSACTION
 
		BEGIN SEQUENCE

		U_MFCONOUT("Processando integração keyconsult " + strzero(_nnt,6) + " de " +  strzero(_ntot,6) + "...")
		ZC5->(Dbgoto(ZC5TMP->RECN))

		_lloop := .F.

		//Faz lock do registro para controle de execução múltiplas
		If !ZC5->(MsRLock(ZC5->(RECNO())))

			U_MFCONOUT("Pedido já em processamento " + strzero(_nnt,6) + " de " + strzero(_ntot,6) + "...")
			_lloop := .T.
			BREAK

		else

			Reclock("ZC5",.F.)
			ZC5->(Dbgotop())
			ZC5->(Dbgoto(ZC5TMP->RECN))

			If ZC5->ZC5_STATUS != '1'

				U_MFCONOUT("Pedido já processado " + strzero(_nnt,6) + " de " + strzero(_ntot,6) + "...")
				_lloop := .T.
				BREAK

			Endif

		Endif
		
		cHeadRet 	:= ""
		aHeadOut	:= {}
		cJsonR		:= ""
		cJsonS		:= ""
		cJsonU		:= ""
		cTimeIni	:= ""
		cTimeProc	:= ""
		xPostRer	:= ""
		xPostRes	:= ""
		xPostReu	:= ""
		nStatuHttR	:= 0
		nStatuHttS	:= 0
		nStatuHttU	:= 0
		nTimeOut    := 600
        _cerro      := ""
		cURLR		:= ""
		cUrlS		:= ""
		cUrlU		:= ""
		csitr		:= ""
		csits		:= ""
		csitu		:= ""
		_cuuid		:= ""
		_lindis := .F.

        SA1->(Dbsetorder(3)) //A1_FILIAL+A1_CGC

        If SA1->(Dbseek(xfilial("SA1")+ZC5->ZC5_CLIENTE))

            _ccnpj := alltrim(SA1->A1_CGC)		

        Else

            _cerro := "Cliente não localizado"
            Break

        Endif

		//trata inscrição que começa com 0
		_cinsc := SA1->A1_INSCR
		If val(alltrim(_cinsc)) > 0
			_cinsc2 := alltrim(str(val(_cinsc)))
		Else
			_cinsc2 := _cinsc
		Endif

		//trata inscrição que começa com 0
		_csufr := SA1->A1_SUFRAMA
		If val(alltrim(_csufr)) > 0
			_csufr2 := alltrim(str(val(_csufr)))
		Else
			_csufr2 := _csufr
		Endif

		//Parâmetro que ativa liberação automática
		If getmv("MGFFATC7L",,.T.)
			csitr := "L"
			csitl := "L"
			csitu := "L"
			BREAK
		Endif

		If SA1->A1_PESSOA = 'F'

			//Valida pessoa fisica
			curlRF := getmv("MGFFATC6F",,"https://webservice.keyconsultas.net/receita/cpf_simplificada/?cpf=%cpf%&nascimento=%nascimento%&token=MFRd2ff0-1f16-4a57-b944-d9ee5bd52050&cont=0")
    	    cURLRF := strtran(curlRF,"%cpf%",alltrim(SA1->A1_CGC))
			_ddtnasc := SA1->A1_DTNASC
			cURLRF := strtran(curlRF,"%nascimento%",alltrim(substr(dtos(_ddtnasc),7,2)+"/"+substr(dtos(_ddtnasc),5,2)+"/"+substr(dtos(_ddtnasc),1,4)))
			U_MFCONOUT("Enviando URL CPF Receita...: " + cUrlRF )

    	    xPostReF := httpGet( cURLRF, ,30, , @cHeadRet )
	
			nStatuHttRF	:= 0
			nStatuHttRF	:= httpGetStatus()

			cURLR := cURLRF
			cjsonr := xPostReF

			If AllTrim( str( nStatuHttRF ) ) = '200'

				U_MFCONOUT("Retorno com status 200")
				cjsonF := xpostreF
				oobjF := nil

				If fwJsonDeserialize(cjsonF , @oobjF)

					If AttIsMemberOf( oobjF, "uuid") .and. VALTYPE(oobjF:uuid) == "C"
						_cuuid := oobjF:uuid
					Else
						_cuuid := ""
					Endif

					If oobjf:code = 1  .and. AttIsMemberOf( oobjf, "data") .and. VALTYPE(oobjf:data) == "O"  ; 
							.and. AttIsMemberOf( oobjf:data, "situacao_cadastral") .and. VALTYPE(oobjf:data:situacao_cadastral) == "C"

						csitr := iif(alltrim(oobjf:data:situacao_cadastral)$_csituacoes,"L","B")
						csitl := "L"
						csitu := "L"
						BREAK

					Elseif oobjf:code = 2 .or. oobjf:code = 3//Cadastro não encontrado

						csitr := "B"
						csits := "L"
						csitu := "L"
						BREAK


					Else

						U_MFCONOUT("Resultado invalido, retorno com status " + strzero(nStatuHttR,6) + "...:" +  xPostRer)
						_cerro := "Resultado invalido na consulta com Receita - " + strzero(nStatuHttR,6) + ' - ' + xPostRer
						Break

					Endif

				Else

					U_MFCONOUT("Json invalido consulta, retorno com status " + strzero(nStatuHttR,6) + "...:" +  xPostRer)
					_cerro := "Json invalido na consulta com Receita - " + strzero(nStatuHttR,6) + ' - ' + xPostRer
					Break
			
				Endif

			Else

				U_MFCONOUT("Falha na consulta, retorno com status " + strzero(nStatuHttR,6) )
				_cerro := "Falha na consulta com Receita - " + strzero(nStatuHttR,6) 
				Break

			Endif

			BREAK

        Endif



		//Verifica se já tem consulta válida com a receita
		cQuery := " SELECT  R_E_C_N_O_ POS"
		cQuery += " FROM " + RetSqlName("ZHL")
		cQuery += "  WHERE ZHL_CNPJ = '" + alltrim(_ccnpj) + "'
		cQuery += "				AND ZHL_STATR = 'L' AND ZHL_DATAC >= '" +  DTOS(DATE()-getmv("MGFFATC7R",,30)) + "'"
		cQuery += "  AND D_E_L_E_T_= ' ' "

		If select("ZHLTMP") > 0
			ZHLTMP->(Dbclosearea())
		Endif

		dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"ZHLTMP", .F., .T.)

		If !(ZHLTMP->(EOF())) //Achou consulta válida

			ZHL->(Dbgoto(ZHLTMP->POS))
			_cuuid := ZHL->ZHL_UUID
			csitr  := "L"
			cURLR  := ZHL->ZHL_URLR  	
			cjsonr := ZHL->ZHL_JSONRR
			U_MFCONOUT("Aproveitando consulta já efetuada na Receita...")

		Else

			curlRB := getmv("MGFFATC6R",,"https://webservice.keyconsultas.net/receita/cnpj/?cnpj=%CNPJ%&token=MFRd2ff0-1f16-4a57-b944-d9ee5bd52050&cont=0")
    	    cURLR := strtran(curlRB,"%CNPJ%",alltrim(SA1->A1_CGC))
			U_MFCONOUT("Enviando URL Receita...: " + cUrlR )

    	    xPostRer := httpGet( cURLR, ,30, , @cHeadRet )
	
			nStatuHttR	:= 0
			nStatuHttR	:= httpGetStatus()

			If AllTrim( str( nStatuHttR ) ) = '200'

				U_MFCONOUT("Retorno com status 200")
				cjsonr := xpostrer
				oobjr := nil

				If fwJsonDeserialize(cjsonr , @oobjr)

					If AttIsMemberOf( oobjr, "uuid") .and. VALTYPE(oobjr:uuid) == "C"
						_cuuid := oobjr:uuid
					Else
						_cuuid := ""
					Endif

					If oobjr:code = 1  .and. AttIsMemberOf( oobjr, "data") .and. VALTYPE(oobjr:data) == "O"  ; 
							.and. AttIsMemberOf( oobjr:data, "situacao_cadastral") .and. VALTYPE(oobjr:data:situacao_cadastral) == "C"

						csitr := iif(alltrim(oobjr:data:situacao_cadastral)$_csituacoes,"L","B")

					Elseif oobjr:code = 2 //Cadastro não encontrado

						csitr := "B"

					Else

						U_MFCONOUT("Resultado invalido, retorno com status " + strzero(nStatuHttR,6) + "...:" +  xPostRer)
						_cerro := "Resultado invalido na consulta com Receita - " + strzero(nStatuHttR,6) + ' - ' + xPostRer
						Break

					Endif

				Else

					U_MFCONOUT("Json invalido consulta, retorno com status " + strzero(nStatuHttR,6) + "...:" +  xPostRer)
					_cerro := "Json invalido na consulta com Receita - " + strzero(nStatuHttR,6) + ' - ' + xPostRer
					Break
			
				Endif

			Else

				U_MFCONOUT("Falha na consulta, retorno com status " + strzero(nStatuHttR,6) )
				_cerro := "Falha na consulta com Receita - " + strzero(nStatuHttR,6) 
				Break

			Endif

		Endif

		_cisentos := getmv("MGFFATC7I",,"ISENTO,ISENTA")

		If empty(ALLTRIM(_cinsc)) .OR. ALLTRIM(_cinsc) $ _cisentos

			csits := "L"
			csitu := "L"
			BREAK

		Endif

		//Verifica se já tem consulta válida com o sintegra
		cQuery := " SELECT  R_E_C_N_O_ POS"
		cQuery += " FROM " + RetSqlName("ZHL")
		cQuery += "  WHERE ZHL_CNPJ = '" + alltrim(_ccnpj) + "'
		cQuery += "				AND ZHL_STATS = 'L' AND ZHL_DATAC = '" +  DTOS(DATE()) + "'"
		cQuery += "  AND D_E_L_E_T_= ' ' "

		If select("ZHLTMP") > 0
			ZHLTMP->(Dbclosearea())
		Endif

		dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"ZHLTMP", .F., .T.)

		If !(ZHLTMP->(EOF())) //Achou consulta válida

			ZHL->(Dbgoto(ZHLTMP->POS))
			_cuuid := ZHL->ZHL_UUID
			csits  := "L"
			cURLS  := ZHL->ZHL_URLS 	
			cjsons := ZHL->ZHL_JSONRS
			U_MFCONOUT("Aproveitando consulta já efetuada no Sintegra...")

		Else


			_lfalhas := .F.
			curlSB := getmv("MGFFATC6R",,"https://webservice.keyconsultas.net/sintegra_%ESTADO%/cnpj/?cnpj=%CNPJ%&token=MFRd2ff0-1f16-4a57-b944-d9ee5bd52050&cont=0")
    	    cURLS := strtran(curlSB,"%CNPJ%",alltrim(SA1->A1_CGC))
			cURLS := strtran(curlS,"%ESTADO%",lower(alltrim(SA1->A1_EST)))
			_lindis := .F.

			U_MFCONOUT("Enviando URL Sintegra...: " + cUrlS )

	        xPostRes := httpGet( cURLS, ,30 , , @cHeadRet )
	
			nStatuHttS	:= 0
			nStatuHttS	:= httpGetStatus()

			If AllTrim( str( nStatuHttS ) ) = '200'

				U_MFCONOUT("Retorno com status 200" )
				cjsons := xpostres
				oobjs := nil

				If fwJsonDeserialize(cjsonS , @oobjS)

					//uma IE
					If oobjs:code = 1  .and. AttIsMemberOf( oobjs, "data") .and. VALTYPE(oobjs:data) == "O"  ; 
							.and. AttIsMemberOf( oobjs:data, "situacao_cadastral") .and. VALTYPE(oobjs:data:situacao_cadastral) == "C"

						If AttIsMemberOf( oobjs:data, "INSCRICAO_ESTADUAL") .and. VALTYPE(oobjs:data:INSCRICAO_ESTADUAL) == "C";
								.AND. (alltrim(oobjs:data:INSCRICAO_ESTADUAL) == alltrim(_cinsc) .or. ;
											alltrim(oobjs:data:INSCRICAO_ESTADUAL) == alltrim(_cinsc2))

							csits := iif(alltrim(oobjs:data:situacao_cadastral)$_csituacoes,"L","B")

						Else

							csits := "B"

						Endif


					//mais de uma IE
					Elseif oobjs:code = 1  .and. AttIsMemberOf( oobjs, "data") .and. VALTYPE(oobjs:data) == "O"  ; 
						.and. AttIsMemberOf( oobjs:data, "inscricoes") .and. VALTYPE(oobjs:data:inscricoes) == "A"

						_lhabilit := .F.

						For _nni := 1 to len(oobjs:data:inscricoes)

							IF AttIsMemberOf( oobjs:data:inscricoes[_NNI],"SITUACAO_CADASTRAL" ) ;
									.AND. VALTYPE(oobjs:data:inscricoes[_NNI]:SITUACAO_CADASTRAL) == "C"

								If oobjs:data:inscricoes[_NNI]:SITUACAO_CADASTRAL $ _csituacoes .and.;
									(alltrim(oobjs:data:inscricoes[_NNI]:INSCRICAO_ESTADUAL) == alltrim(_cinsc) .or. ;
										alltrim(oobjs:data:inscricoes[_NNI]:INSCRICAO_ESTADUAL) == alltrim(_cinsc2))

									_lhabilit := .T.

								Elseif  "Selecione uma Inscri" $ oobjs:html .OR.;
										oobjs:data:inscricoes[_NNI]:SITUACAO_CADASTRAL $ "CONSULTAR PELA IE"

									_lfalhas := .T.
							
								Endif
					
					
							Elseif "Selecione uma Inscri" $ oobjs:html

								_lfalhas := .T.
						
							Endif

						Next

						If !_lfalhas

							csits := iif(_lhabilit,"L","B")

						Endif

					Elseif oobjs:code = 2 //Cadastro não encontrado

						csits := "B"

					Elseif oobjs:code = 999 .or. oobjs:code = 530

						_lfalhas := .T.
						U_MFCONOUT("Indisponibilidade, retorno com status " + strzero(nStatuHtts,6) + "...:" +  xPostRes + CHR(10) + CHR(13))
	

					Else

						U_MFCONOUT("Json invalido consulta, retorno com status " + strzero(nStatuHttR,6) + "...:" +  xPostRer)
						_cerro := "Json invalido na consulta com Sintegra - " + strzero(nStatuHttR,6) + ' - ' + xPostRer
						_lfalhas := .T.
	
					Endif
			
				Else

					U_MFCONOUT("Json invalido consulta, retorno com status " + strzero(nStatuHtts,6) + "...:" +  xPostRes + CHR(10) + CHR(13))
						_lfalhas := .T.
			
				Endif

			Else

				U_MFCONOUT("Falha na consulta, retorno com status " + strzero(nStatuHttS,6)  + CHR(10) + CHR(13))
				_lfalhas := .T.

			Endif

			If _lfalhas
		
				//Tenta fazer consulta CCC Simplificada
				curlSB := getmv("MGFFATC6W",,"https://webservice.keyconsultas.net/ccc_simplificada/cnpj/?cnpj=%CNPJ%&uf=%ESTADO%&token=MFRd2ff0-1f16-4a57-b944-d9ee5bd52050&cont=0")
    	    	cURLS := strtran(curlSB,"%CNPJ%",alltrim(SA1->A1_CGC))
				cURLS := strtran(curlS,"%ESTADO%",lower(alltrim(SA1->A1_EST)))
				_lindis := .F.

				U_MFCONOUT("Enviando URL CCC Simplificado...: " + cUrlS )

    			xPostRes := httpGet( cURLS, ,30 , , @cHeadRet )
	
				nStatuHttS	:= 0
				nStatuHttS	:= httpGetStatus()

				If AllTrim( str( nStatuHttS ) ) = '200'

					U_MFCONOUT("Retorno com status 200" )
					cjsons := xpostres
					oobjs := nil

					If fwJsonDeserialize(cjsonS , @oobjS)

						If oobjs:code = 1  .and. AttIsMemberOf( oobjs, "data") .and. VALTYPE(oobjs:data) == "O"  ; 
							.and. AttIsMemberOf( oobjs:data, "situacao_cadastral") .and. VALTYPE(oobjs:data:situacao_cadastral) == "C"

								If AttIsMemberOf( oobjs:data, "INSCRICAO_ESTADUAL") .and. VALTYPE(oobjs:data:INSCRICAO_ESTADUAL) == "C";
									.AND. (alltrim(oobjs:data:INSCRICAO_ESTADUAL) == alltrim(_cinsc) .or.;
										alltrim(oobjs:data:INSCRICAO_ESTADUAL) == alltrim(_cinsc2))

									csits := iif(alltrim(oobjs:data:situacao_cadastral)$_csituacoes,"L","B")

								Else

									csits := "B"

								Endif

								_cerro := ""

						Elseif oobjs:code = 999 .or. oobjs:code = 530

							U_MFCONOUT("Indisponibilidade, retorno com status " + strzero(nStatuHtts,6) + "...:" +  xPostRes + CHR(10) + CHR(13))
							_cerro := "Indisponibilidade na consulta com Sintegra e CCC - " + strzero(nStatuHtts,6) + ' - ' + xPostRes
							_lindis := .T.
							Break
					
						//mais de uma IE
						Elseif oobjs:code = 1  .and. AttIsMemberOf( oobjs, "data") .and. VALTYPE(oobjs:data) == "O"  ; 
							.and. AttIsMemberOf( oobjs:data, "inscricoes") .and. VALTYPE(oobjs:data:inscricoes) == "A"

							_lhabilit := .F.

							For _nni := 1 to len(oobjs:data:inscricoes)

								IF AttIsMemberOf( oobjs:data:inscricoes[_NNI],"SITUACAO_CADASTRAL" ) ;
									.AND. VALTYPE(oobjs:data:inscricoes[_NNI]:SITUACAO_CADASTRAL) == "C"

									If oobjs:data:inscricoes[_NNI]:SITUACAO_CADASTRAL $ _csituacoes .and.;
										(alltrim(oobjs:data:inscricoes[_NNI]:INSCRICAO_ESTADUAL) == alltrim(_cinsc) .or.;
											alltrim(oobjs:data:inscricoes[_NNI]:INSCRICAO_ESTADUAL) == alltrim(_cinsc2))

										_lhabilit := .T.

									Endif

								Endif

							Next

							csits := iif(_lhabilit,"L","B")

						Elseif oobjs:code = 2 //Cadastro não encontrado

							csits := "B"

						Else

							U_MFCONOUT("Json invalido consulta, retorno com status " + strzero(nStatuHtts,6) + "...:" +  xPostRes + CHR(10) + CHR(13))
							_cerro := "Json invalido na consulta com Sintegra/CCC - " + strzero(nStatuHtts,6) + ' - ' + xPostRes
							Break
	
						Endif

					Else

						U_MFCONOUT("Json invalido consulta, retorno com status " + strzero(nStatuHtts,6) + "...:" +  xPostRes + CHR(10) + CHR(13))
						_cerro := "Json invalido na consulta com Sintegra/CCC - " + strzero(nStatuHtts,6) + ' - ' + xPostRes
						Break

					Endif

				Else

					U_MFCONOUT("Falha na consulta, retorno com status " + strzero(nStatuHttS,6)  + CHR(10) + CHR(13))
					_cerro := "Falha na consulta com Sintegra/CCC - " + strzero(nStatuHttS,6) 
					Break

				Endif

			Endif

		Endif

		IF alltrim(SA1->A1_EST) $ _csuframa

			curlUB := getmv("MGFFATC6U",,"https://webservice.keyconsultas.net/suframa/cnpj/?cnpj=%CNPJ%&token=MFRd2ff0-1f16-4a57-b944-d9ee5bd52050")
  		    cURLU := strtran(curlUB,"%CNPJ%",alltrim(SA1->A1_CGC))

			U_MFCONOUT("Enviando URL Suframa...: " + cUrlU )

        	xPostReU := httpGet( cURLU, ,10, , @cHeadRet )
	
			nStatuHttU	:= 0
			nStatuHttU	:= httpGetStatus()

			If AllTrim( str( nStatuHttU ) ) = '200'

				U_MFCONOUT("Retorno com status 200" )
				cjsonu := xpostreu
				oobju := nil

				If fwJsonDeserialize(cjsonu , @oobju)

					If oobju:code = 1  .and. AttIsMemberOf( oobju, "data") .and. VALTYPE(oobju:data) == "O"  ; 
							.and. AttIsMemberOf( oobju:data, "situacao_cadastral") .and. VALTYPE(oobju:data:situacao_cadastral) == "C"

						If AttIsMemberOf( oobju:data, "INSCRICAO") .and. VALTYPE(oobju:data:INSCRICAO) == "C";
							.AND. (alltrim(oobju:data:INSCRICAO) == alltrim(_csufr) .or.;
									alltrim(oobju:data:INSCRICAO) == alltrim(_csufr2))

							csitu := iif(alltrim(oobju:data:situacao_cadastral)$_csituacoes,"L","B")

						Else

							csitu := "B"

						Endif
						

					Elseif oobju:code = 2 //Cadastro não encontrado

						csitu := "B"

					elseif oobju:code == 500 .or. oobju:code == 501

						U_MFCONOUT("Resultado timeout, retorno com status " + strzero(nStatuHttu,6) + "...:" +  xPostReu + CHR(10) + CHR(13))
						_cerro := "Resultado timeout na consulta com Suframa - " + strzero(nStatuHttu,6) + ' - ' + xPostReu
						_lindis := .T.
						Break

					else

						U_MFCONOUT("Resultado invalido, retorno com status " + strzero(nStatuHttu,6) + "...:" +  xPostReu + CHR(10) + CHR(13))
						_cerro := "Resultado invalido na consulta com Suframa - " + strzero(nStatuHttu,6) + ' - ' + xPostReu
						_lindis := .T.
						Break

					Endif

				Else

					U_MFCONOUT("Json invalido consulta, retorno com status " + strzero(nStatuHttR,6) + "...:" +  xPostReu + CHR(10) + CHR(13))
					_cerro := "Json invalido na consulta com Suframa - " + strzero(nStatuHttR,6) + ' - ' + xPostReu
					_lindis := .T.
					Break
			
				Endif

			Else

				U_MFCONOUT("Falha na consulta, retorno com status " + strzero(nStatuHttU,6)  + CHR(10) + CHR(13))
				_cerro := "Falha na consulta com Suframa - " + strzero(nStatuHttU,6) 
				_lindis := .T.
				Break

			Endif

		Else

			csitu := "L"
	
	
		Endif
		

		END SEQUENCE

		If !(_lloop)

			If empty(_cerro)

				_cerro := "Consulta realizada com sucesso - MGFFATC6 - Thread " + alltrim(str(threadid()))
				_cstatus := "C"

			Elseif _lindis

				_cstatus := "I"

			Else

				_cstatus := "E"

			Endif

			Reclock("ZHL",.T.)
			ZHL->ZHL_FILIAL := ZC5->ZC5_FILIAL
			ZHL->ZHL_IDSFA 	:= ZC5->ZC5_IDSFA
			ZHL->ZHL_PVPROT	:= ""
			ZHL->ZHL_DATAC 	:= DATE()
			ZHL->ZHL_HORAC 	:= TIME()
			ZHL->ZHL_URLS  	:= cURLS
			ZHL->ZHL_JSONRS	:= cjsons
			ZHL->ZHL_STATS 	:= csits
			ZHL->ZHL_URLR  	:= cURLR
			ZHL->ZHL_JSONRR	:= cjsonr
			ZHL->ZHL_STATR	:= csitr 
			ZHL->ZHL_URLU  	:= cURLU
			ZHL->ZHL_JSONRU	:= cjsonu
			ZHL->ZHL_STATU 	:= csitu
			ZHL->ZHL_UUID  	:= _cuuid
			ZHL->ZHL_CNPJ	:= _ccnpj
			ZHL->ZHL_RESULT := _cerro
			ZHL->ZHL_STATUS := _cstatus

			ZHL->(Msunlock())

			//Se deu certo já libera o pedido pra criação
			If _cstatus == "C" 

				If ZC5->ZC5_STATUS == '1'

					ZC5->ZC5_STATUS := '2'

				Endif

			Else

				//Conta tentativas para o pedido e libera para criação do pedido mesmo com falhas se passou do limite de tentativas
				cQuery := " SELECT  count(R_E_C_N_O_) CONT"
				cQuery += " FROM " + RetSqlName("ZHL")
				cQuery += "  WHERE ZHL_FILIAL = '" + alltrim(ZC5->ZC5_FILIAL) + "' AND ZHL_IDSFA = '" + alltrim(ZC5->ZC5_IDSFA) + "'
				cQuery += "  AND D_E_L_E_T_= ' ' "

				If select("ZHLTMP") > 0
					ZHLTMP->(Dbclosearea())
				Endif

				dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"ZHLTMP", .F., .T.)

				If ZHLTMP->CONT > _ntents

					If ZC5->ZC5_STATUS == '1'

						ZC5->ZC5_STATUS := '2'

					Endif

					If _lindis .and. csitr == "L"

						U_MFCONOUT("Liberando pedido por indisponibilidade do Sintegra com consulta Receita ok - " + strzero(_nnt,6) + " de " +  strzero(_ntot,6) )
						_cerro := "Liberando pedido por indisponibilidade do Sintegra com consulta Receita ok"

						Reclock("ZHL",.F.)
						ZHL->ZHL_STATS 	:= "L"
						ZHL->ZHL_RESULT := _cerro
						ZHL->ZHL_STATUS := "C"
						ZHL->(Msunlock())


					Elseif _lindis .and. csitr == "B"

						U_MFCONOUT("Bloqueando pedido por indisponibilidade do Sintegra com consulta Receita bloquada - " + strzero(_nnt,6) + " de " +  strzero(_ntot,6) )
						_cerro := "Bloqueando pedido por indisponibilidade do Sintegra com consulta Receita bloquada "

						Reclock("ZHL",.F.)
						ZHL->ZHL_STATS 	:= "B"
						ZHL->ZHL_RESULT := _cerro
						ZHL->ZHL_STATUS := "C"
						ZHL->(Msunlock())

					Else

						U_MFCONOUT("Liberando pedido pendente de consulta por falha de integração - " + strzero(_nnt,6) + " de " +  strzero(_ntot,6) )

					Endif
	
				Endif

			Endif
	
			U_MFCONOUT("Completou integração keyconsult do cnpj " + _ccnpj + " - "  + strzero(_nnt,6) + " de " +  strzero(_ntot,6) + " com resultado: " + _cerro + CHR(10) + CHR(13))

		Endif

		ZC5TMP->(Dbskip())
		_nnt++

		END TRANSACTION

		ZC5->(Msunlock())

	Enddo

Return




