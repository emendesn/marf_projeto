#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#DEFINE CRLF CHR(13)+CHR(10)
/*
=====================================================================================
Programa.:              MGFGFE46	
Autor....:              Rafael Garcia
Data.....:              15/03/2018
Descricao / Objetivo:   WS Integracao PROTHEUS x MultiEmbarcador - gatilho paro o Barramento
Doc. Origem:            Especificacao de Processos_Emissao_CT-e - EF - 01_v2
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              WS para Integracao de dados - gatilho paro o Barramento
=====================================================================================
Paulo da Mata - 21/01/2020 - Validação da existência de outro registro com o mesmo numero no DAK_XOEREF
*/
//Chamada multifiliais
User Function mGFE46()

	Local _afiliais := {}
	Local _cfiliais := ""
	Local _ni := 1

	PREPARE ENVIRONMENT EMPRESA '01' FILIAL '010041'


	conout('Thread ' + strzero(threadid(),6) +  ' - [MGFWSC46] Iniciada execução multifiliais de gatilho CTE para barramento - ' +  dToC(dDataBase) + " - " + time())

 	_cfiliais := supergetmv("MV_GFE46FIL",,"010002,010003,010005,010007,010012,010013,010015,010016,010041,010042,010043,010044,010045,010048,010050,010053,010054,010056,010059,010063,010064,010066,010067,010068")
	_afiliais := strtokarr2(_cfiliais,",")

	While _ni <= len(_afiliais)
	
		conout('Thread ' + strzero(threadid(),6) +  ' - [MGFWSC46]] ------------------------------------------------------------------------------------------------------------------------')
		conout('Thread ' + strzero(threadid(),6) +  ' - [MGFWSC46]] Iniciando execução de gatilho CTE para barramento para filial ' + _afiliais[_ni] + ' - ' +  dToC(dDataBase) + " - " + time())
		cfilant := _afiliais[_ni]
		cempant := substr(_afiliais[_ni],1,2)
		runInteg46()
		conout('Thread ' + strzero(threadid(),6) +  ' - [MGFWSC46]] Completou execução de gatilho CTE para barramento para filial ' + _afiliais[_ni] + ' - ' +  dToC(dDataBase) + " - " + time())
		conout('Thread ' + strzero(threadid(),6) +  ' - [MGFWSC46]] ------------------------------------------------------------------------------------------------------------------------')
		_ni++

	EndDo

	RESET ENVIRONMENT


Return

//-------------------------------------------------------------------
static function runInteg46()
	local cURLPost		:= allTrim(getMv("MGF_GFE46"))
	local cURLPost2		:= alltrim(getmv("MGF_GFE462"))
	local cURLPostE		:= alltrim(getmv("MGF_GFE46E"))
	local cURL			:= ""
	local cJson 		:= ""
	local aHeadOut		:= {}
	local nTimeOut		:= 120
	local xPostRet		:= ""
	local nStatuHttp	:= 0
	local cHeadRet		:= ""
	local cTimeIni		:= ""
	local cTimeFin		:= ""
	local cTimeProc		:= ""
	LOCAL cFecha		:= 'false
	local lContinua		:= .f.
	Local _ntot         := 0
	Local _npos         := 1
	Local _linicio       := .F.

	Local cCdTpo 		:= ""
	Local cResp			:= ""

	conout('Thread ' + strzero(threadid(),6) +  ' - [MGFWSC46]] Marcando cargas finalizadas no multiembarcador ' + cfilant + ' - ' +  dToC(dDataBase) + " - " + time())
	QWRFFE46()
	conout('Thread ' + strzero(threadid(),6) +  ' - [MGFWSC46]] Marcou cargas finalizadas no multiembarcador ' + cfilant + ' - ' +  dToC(dDataBase) + " - " + time())

	conout('Thread ' + strzero(threadid(),6) +  ' - [MGFWSC46]] Executando query de update de cargas para reenvio para filial ' + cfilant + ' - ' +  dToC(dDataBase) + " - " + time())
	UQWSGFE46() // UPDATE PARA REENVIO
	conout('Thread ' + strzero(threadid(),6) +  ' - [MGFWSC46]] Completou query de update de cargas para reenvio para filial ' + cfilant + ' - ' +  dToC(dDataBase) + " - " + time())

	conout('Thread ' + strzero(threadid(),6) +  ' - [MGFWSC46]] Executando query de verificação de registros para reenvio de cargas para a filial ' + cfilant + ' - ' +  dToC(dDataBase) + " - " + time())
	QWRGFE46() 
	conout('Thread ' + strzero(threadid(),6) +  ' - [MGFWSC46]] Completou query de verificação de registros para reenvio de cargas para a filial ' + cfilant + ' - ' +  dToC(dDataBase) + " - " + time())

	conout('Thread ' + strzero(threadid(),6) +  ' - [MGFWSC46]] Executando query de gatilho CTE para barramento para filial ' + cfilant + ' - ' +  dToC(dDataBase) + " - " + time())
	QWSGFE46() // CRIAR FUNCAO QUE RETORNA A QUERY DOS REGISTROS
	conout('Thread ' + strzero(threadid(),6) +  ' - [MGFWSC46]] Completou  query de gatilho CTE para barramento para filial ' + cfilant + ' - ' +  dToC(dDataBase) + " - " + time())

	If QRYDAK->(EOF())

		conout('Thread ' + strzero(threadid(),6) +  ' - [MGFWSC46]] Não localizou cargas pendentes de gatilho CTE para barramento para filial ' + cfilant + ' - ' +  dToC(dDataBase) + " - " + time())

	Else

		//Conta cargas para enviar
		QRYDAK->(DBGOTOP())
		_catual := " "
		Do while !(QRYDAK->(EOF()))
			If !(_catual == (alltrim(QRYDAK->DAK_FILIAL) + alltrim(QRYDAK->DAK_COD)))
				_ntot++
				_catual := alltrim(QRYDAK->DAK_FILIAL) + alltrim(QRYDAK->DAK_COD)
			Endif
			QRYDAK->(Dbskip())
		Enddo

	Endif

	QRYDAK->(DBGOTOP())

	aadd( aHeadOut, 'Content-Type: application/json')
	while !QRYDAK->(EOF())

		conout('Thread ' + strzero(threadid(),6) +  ' - [MGFWSC46]] Processando carga ' + ALLTRIM(QRYDAK->DAK_COD);
					 + ' - ' +  strzero(_npos,6) + " de " + strzero(_ntot,6) +  ' para filial ' + cfilant + ' - ' +;
					   dToC(dDataBase) + " - " + time())
		_npos++

		lContinua := .T.
		_linicio := .F.

		//Valida se está com campos obrigatórios preenchidos
		If lcontinua .and. DAK->(dbSeek(QRYDAK->DAK_FILIAL+QRYDAK->DAK_COD))
			If empty(DAK->DAK_CAMINH) .OR. EMPTY(DAK->DAK_MOTORI)
				lContinua := .F.
				cResp := "Carga " + QRYDAK->DAK_COD + ;
					         " possui campo obrigatório de caminhão ou motorista invalido!"

				DAK->(dbSetOrder(1))
				
				If DAK->(dbSeek(QRYDAK->DAK_FILIAL+QRYDAK->DAK_COD))
					RecLock("DAK",.F.)
					DAK->DAK_XRETWS := cResp
					DAK->(MsUnLock())
				 EndIf

				ConOut('Thread '+StrZero(threadid(),6)+' - [MGFWSC46]] '+cResp+" - "+DtoC(dDataBase)+" - "+Time())

			Endif

		Endif

		// Valida se existe outro registro com o mesmo numero no DAK_XOEREF

		If lContinua

		   cQuery := "SELECT DAK_COD,DAK_XOEREF,DAK_ZCDTPO "
		   cQuery += "FROM "+RetSqlName("DAK")+" "
		   cQuery += "WHERE D_E_L_E_T_ = ' ' "
		   cQuery += "AND DAK_FILIAL = '"+QRYDAK->DAK_FILIAL+"' "
		   cQuery += "AND DAK_XOEREF = '"+QRYDAK->DAK_XOEREF+"' "
		   cQuery += "AND DAK_COD <> '"+QRYDAK->DAK_COD+"' "

			IF SELECT("QRYTMP") > 0
				QRYTMP->( dbCloseArea() )
			ENDIF

			TcQuery ChangeQuery(cQuery) New Alias "QRYTMP"

			If QRYTMP->(!Eof())

			   While QRYTMP->(!Eof())
			      
				  If QRYTMP->DAK_ZCDTPO != QRYDAK->DAK_ZCDTPO
				     lContinua := .F.
					 cResp := "Carga vinculada " + QRYTMP->DAK_COD + ;
					         " possui tipo de operação diferente: " + AllTrim(QRYTMP->DAK_ZCDTPO) + " !"

					 DAK->(dbSetOrder(1))
				
					 If DAK->(dbSeek(QRYDAK->DAK_FILIAL+QRYDAK->DAK_COD))
						RecLock("DAK",.F.)
						DAK->DAK_XRETWS := cResp
						DAK->(MsUnLock())
					 EndIf

					 ConOut('Thread '+StrZero(threadid(),6)+' - [MGFWSC46]] '+cResp+" - "+DtoC(dDataBase)+" - "+Time())

				  EndIf
				
				  QRYTMP->(dbSkip())

			   EndDo	  

			EndIf

		EndIf
	
		if lContinua
			//verifica se todos os pedidos da carga foram faturados e impressos
			cQuery := "	SELECT SF2.F2_DOC ,SF2.F2_SERIE, DAI_NFISCA "	+CRLF
			cQuery += " FROM "+retSQLName("DAI")+" DAI"					+CRLF
			cQuery += " INNER JOIN "+retSQLName("DAK")+" DAK"			+CRLF
			cQuery += " ON DAK.DAK_FILIAL=DAI.DAI_FILIAL"				+CRLF
			cQuery += " AND DAK.DAK_COD=DAI.DAI_COD"					+CRLF
			cQuery += " AND DAK.D_E_L_E_T_<>'*'"						+CRLF
			cQuery += " LEFT JOIN "+retSQLName("SF2")+" SF2"			+CRLF
			cQuery += " ON DAI.DAI_FILIAL=SF2.F2_FILIAL"				+CRLF
			cQuery += " AND DAI.DAI_NFISCA=SF2.F2_DOC"					+CRLF
			cQuery += " AND DAI.DAI_SERIE=SF2.F2_SERIE"					+CRLF
			cQuery += " AND SF2.F2_ZARQXML<>' '"						+CRLF
			cQuery += " AND SF2.D_E_L_E_T_<>'*'"						+CRLF
			cQuery += " WHERE"											+CRLF
			cQuery += " DAI.DAI_FILIAL='"+QRYDAK->DAK_FILIAL+"' " 		+CRLF
			cQuery += " AND DAK.DAK_COD='"+QRYDAK->DAK_COD+"' "	+CRLF
			cQuery += " AND DAI.D_E_L_E_T_<>'*'"						+CRLF
			cQuery += " AND SF2.F2_DOC IS NULL"							+CRLF

			IF SELECT("QRYPED") > 0
				QRYPED->( dbCloseArea() )
			ENDIF

			TcQuery changeQuery(cQuery) New Alias "QRYPED"

			IF QRYPED->(eof())
				lcontinua:= .t.
				QRYPED->( dbCloseArea() )
			ELSE
			
				lcontinua:= .F.
				_cnotas := ""
				Do while !(QRYPED->(eof()))
					_cnotas += alltrim(QRYPED->DAI_NFISCA) + " "
					QRYPED->(dbskip())
				Enddo
				
				QRYPED->( dbCloseArea() )
				dbSelectArea("DAK")
				dbSetOrder(1)
				IF DBSEEK(QRYDAK->DAK_FILIAL+QRYDAK->DAK_COD)
					RecLock("DAK",.F.)
					DAK->DAK_XRETWS:="Carga nao enviada ao Multiembarcador - Existe notas pendentes de faturamento/impressao: " + _cnotas 
					DAK->(  msUnlock() )
				ENDIF
				conout('Thread ' + strzero(threadid(),6) +  ' - [MGFWSC46]] ' + ALLTRIM(QRYDAK->DAK_COD);
					 + ' - Carga nao enviada ao Multiembarcador - Existe notas pendentes de faturamento/impressao: ' + _cnotas + " - " + ;
					   dToC(dDataBase) + " - " + time())

			ENDIF
		ENDIF
		if 	lContinua
			//verifica se todas as notas foram averbadas
			cQuery := " SELECT DAI.DAI_PEDIDO, ZBS_NUM " 	+CRLF
			cQuery += " FROM  "+retSQLName("DAI")+" DAI"						+CRLF
			cQuery += " INNER JOIN "+retSQLName("DAK")+" DAK"					+CRLF
			cQuery += " ON DAK.DAK_FILIAL=DAI.DAI_FILIAL"						+CRLF
			cQuery += " AND DAK.DAK_COD=DAI.DAI_COD"							+CRLF
			cQuery += " INNER JOIN "+retSQLName("ZBS")+" ZBS"					+CRLF
			cQuery += " ON ZBS.ZBS_FILIAL=DAI.DAI_FILIAL"						+CRLF
			cQuery += " AND ZBS.ZBS_OE=DAI.DAI_COD"								+CRLF
			cQuery += " AND ZBS.ZBS_PEDIDO=DAI.DAI_PEDIDO"						+CRLF
			cQuery += " WHERE "													+CRLF
			cQuery += " ZBS.ZBS_CNPJSE=' ' "									+CRLF
			cQuery += " AND ZBS.ZBS_FILIAL='"+QRYDAK->DAK_FILIAL+"' "  			+CRLF
			cQuery += " AND DAK.DAK_FILIAL='"+QRYDAK->DAK_FILIAL+"' "  			+CRLF
			cQuery += " AND DAI.DAI_FILIAL='"+QRYDAK->DAK_FILIAL+"' "  			+CRLF
			cQuery += " AND DAK.DAK_COD='"+QRYDAK->DAK_COD+"' " 				+CRLF
			cQuery += " AND DAI.DAI_COD='"+QRYDAK->DAK_COD+"' " 				+CRLF
			cQuery += " AND ZBS.ZBS_OE='"+QRYDAK->DAK_COD+"' " 					+CRLF
			cQuery += " AND ZBS.ZBS_SITUAC='N' " 								+CRLF
			cQuery += " AND ZBS.D_E_L_E_T_<>'*' "								+CRLF
			cQuery += " AND DAK.D_E_L_E_T_<>'*' "								+CRLF
			cQuery += " AND DAI.D_E_L_E_T_<>'*' "								+CRLF

			IF SELECT("QRYPED") > 0
				QRYPED->( dbCloseArea() )
			ENDIF

			TcQuery changeQuery(cQuery) New Alias "QRYPED"

			if QRYPED->(!eof())
				
				_CNOTAS := ""
				Do while QRYPED->(!eof())
					_cnotas += QRYPED->ZBS_NUM + "  "
					QRYPED->(Dbskip())
				Enddo
				
				lContinua:= .f.
				dbSelectArea("DAK")
				dbSetOrder(1)
				IF DBSEEK(QRYDAK->DAK_FILIAL+QRYDAK->DAK_COD)
					RecLock("DAK",.F.)
					DAK->DAK_XRETWS:="Carga nao enviada ao Multiembarcador - Existe pendencia de Averbacao para as NFs " + _cnotas
					DAK->(  msUnlock() )
				ENDIF
				conout('Thread ' + strzero(threadid(),6) +  ' - [MGFWSC46]] ' + ALLTRIM(QRYDAK->DAK_COD);
					 + ' - Carga nao enviada ao Multiembarcador - Existe pendencia de Averbacao para as NFs ' + _cnotas +;
					   dToC(dDataBase) + " - " + time())	
			ENDIF
			IF SELECT("QRYPED") > 0
				QRYPED->( dbCloseArea() )
			ENDIF
		ENDIF
		if 	lContinua
			//verifica se todas as notas sao cif
			cQuery := "	SELECT C5_NUM AS PEDIDO, C5_CLIENTE, C5_LOJACLI,C5_TPFRETE  "		+CRLF
			cQuery += " FROM  "+retSQLName("DAI")+" DAI	"						+CRLF
			cQuery += " INNER JOIN  "+retSQLName("DAK")+" DAK "					+CRLF
			cQuery += " ON DAK.DAK_FILIAL=DAI.DAI_FILIAL"						+CRLF
			cQuery += " AND DAK.DAK_COD=DAI.DAI_COD	"							+CRLF
			cQuery += " AND DAK.D_E_L_E_T_<>'*'	"								+CRLF
			cQuery += " INNER JOIN  "+retSQLName("SC5")+" SC5"					+CRLF
			cQuery += " ON DAI.DAI_PEDIDO=SC5.C5_NUM"							+CRLF
			cQuery += " AND SC5.C5_FILIAL=DAI.DAI_FILIAL"						+CRLF
			cQuery += " AND SC5.D_E_L_E_T_ <>  '*'"								+CRLF
			cQuery += " WHERE "													+CRLF
			cQuery += " DAI.DAI_FILIAL='"+QRYDAK->DAK_FILIAL+"' " 				+CRLF
			cQuery += " AND DAK.DAK_XOEREF='"+QRYDAK->DAK_XOEREF+"' " 			+CRLF
			cQuery += " AND DAI.D_E_L_E_T_<>'*'	"								+CRLF

			IF SELECT("QRYPED") > 0
				QRYPED->( dbCloseArea() )
			ENDIF

			TcQuery changeQuery(cQuery) New Alias "QRYPED"

			if QRYPED->(!eof())

				_cpedidos := ""
				_cpedido2 := ""
				_cpedido3 := ""
				Do while QRYPED->(!eof())
					
					//Pedidos não CIF
					if alltrim(QRYPED->C5_TPFRETE) != 'C'
						_cpedidos += QRYPED->PEDIDO + " "
						
					Endif
					//Campos código de país e código de cidade ibge do cliente
					SA1->(Dbsetorder(1)) //A1_FILIAL+A1_COD+A1_LOJA
					If SA1->(Dbseek(xfilial("SA1")+QRYPED->C5_CLIENTE+QRYPED->C5_LOJACLI))
						If EMPTY(SA1->A1_COD_MUN)
							_cpedido2 += QRYPED->PEDIDO + " "
						Endif
						If EMPTY(SA1->A1_CODPAIS)
							_cpedido3 += QRYPED->PEDIDO + " "
						Endif
					Endif

					QRYPED->(dbskip())
				Enddo
				
				If !empty(_cpedidos)
				
					lContinua:= .f.
					dbSelectArea("DAK")
					dbSetOrder(1)
					IF DBSEEK(QRYDAK->DAK_FILIAL+QRYDAK->DAK_COD)
						RecLock("DAK",.F.)
						DAK->DAK_XRETWS:="Carga nao enviada ao Multiembarcador - Existe Pedidos diferentes de CIF na carga - " + _cpedidos
						DAK->(  msUnlock() )
					ENDIF
					conout('Thread ' + strzero(threadid(),6) +  ' - [MGFWSC46]] ' + ALLTRIM(QRYDAK->DAK_COD);
					 	+ ' - Carga nao enviada ao Multiembarcador - Existe Pedidos diferentes de CIF na carga - ' + _cpedidos + " - " + ;
					   	dToC(dDataBase) + " - " + time())	
		
				ENDIF

				If !empty(_cpedido2) .or. !empty(_cpedido3)
				
					lContinua:= .f.
					dbSelectArea("DAK")
					dbSetOrder(1)
					IF DBSEEK(QRYDAK->DAK_FILIAL+QRYDAK->DAK_COD)
						RecLock("DAK",.F.)
						DAK->DAK_XRETWS:="Carga nao enviada ao Multiembarcador - Existe pedidos com clientes sem campos obrigatórios: "
						If !empty(_cpedido2)
							DAK->DAK_XRETWS+= " Código Municipio: " + _cpedido2
						Endif
						If !empty(_cpedido3)
							DAK->DAK_XRETWS+= " Código País: " + _cpedido3
						Endif
						DAK->(  msUnlock() )
					ENDIF
					conout('Thread ' + strzero(threadid(),6) +  ' - [MGFWSC46]] ' + ALLTRIM(QRYDAK->DAK_COD);
					 	+ ' - Carga nao enviada ao Multiembarcador - ' + alltrim(DAK->DAK_XRETWS)  + " - " + ;
					   	dToC(dDataBase) + " - " + time())	
		
				ENDIF


			Endif

			IF SELECT("QRYPED") > 0
				QRYPED->( dbCloseArea() )
			ENDIF
		ENDIF

		
		_catual := alltrim(QRYDAK->DAK_FILIAL+QRYDAK->DAK_COD)

		//Se falhou validação da carga não faz validação pedido a pedido e pula para próxima carga
		If !lcontinua
			Do while _catual == alltrim(QRYDAK->DAK_FILIAL+QRYDAK->DAK_COD)
				QRYDAK->(DBSKIP())
			Enddo
			Loop
		Endif			

		//Validação e envio pedido a pedido
		Do while lcontinua .and. _catual ==  alltrim(QRYDAK->DAK_FILIAL+QRYDAK->DAK_COD)

			conout('Thread ' + strzero(threadid(),6) +  ' - [MGFWSC46]] ' + ALLTRIM(QRYDAK->DAK_COD);
				 + ' - Processando validações por pedido - ' + alltrim(QRYDAK->DAI_PEDIDO) + ' - ' +;
				   dToC(dDataBase) + " - " + time())	


		  IF lContinua
			//verifica se ja tem algum pedido enviado com protocolo se sim pode enviar o resto
			cQuery := "	SELECT DAI_COD,DAI_PEDIDO "
			cQuery += " FROM "+retSQLName("DAI")+" DAI"					+CRLF
			cQuery += " INNER JOIN  "+retSQLName("DAK")+" DAK"			+CRLF
			cQuery += " ON DAK.DAK_COD=DAI.DAI_COD"						+CRLF
			cQuery += " AND DAK.DAK_FILIAL=DAI.DAI_FILIAL" 				+CRLF
			cQuery += " AND DAI.D_E_L_E_T_      <>  '*'"				+CRLF
			cQuery += " WHERE DAI.DAI_FILIAL='"+QRYDAK->DAK_FILIAL+"' " +CRLF
			cQuery += " AND DAK.DAK_XOEREF='"+QRYDAK->DAK_XOEREF+"' "	+CRLF
			cQuery += " AND DAI_XINTME <>' ' AND DAI_XPROPV <>' '"		+CRLF

			IF SELECT("QRYPED") > 0
				QRYPED->( dbCloseArea() )
			ENDIF

			TcQuery changeQuery(cQuery) New Alias "QRYPED"

			IF QRYPED->(eof())
				//verifica se tem pedido enviado sem protocolo
				cQuery := "	SELECT DAI_COD,DAI_PEDIDO "						+CRLF
				cQuery += " FROM "+retSQLName("DAI")+" DAI"					+CRLF
				cQuery += " INNER JOIN  "+retSQLName("DAK")+" DAK"			+CRLF
				cQuery += " ON DAK.DAK_COD=DAI.DAI_COD"						+CRLF
				cQuery += " AND DAK.DAK_FILIAL=DAI.DAI_FILIAL" 				+CRLF
				cQuery += " AND DAK.D_E_L_E_T_      <>  '*'"				+CRLF
				cQuery += " WHERE DAI.DAI_FILIAL='"+QRYDAK->DAK_FILIAL+"' " +CRLF
				cQuery += " AND DAK.DAK_XOEREF='"+QRYDAK->DAK_XOEREF+"' "	+CRLF
				cQuery += " AND DAI.D_E_L_E_T_      <>  '*'"				+CRLF
				cQuery += " AND DAI_XINTME <>' ' AND DAI_XPROPV =' '"		+CRLF


				IF SELECT("QRYPED") > 0
					QRYPED->( dbCloseArea() )
				ENDIF

				TcQuery changeQuery(cQuery) New Alias "QRYPED"

				IF QRYPED->(eof())
					lContinua:= .t.
				else
					lContinua:= .f.

					conout('Thread ' + strzero(threadid(),6) +  ' - [MGFWSC46]] ' + ALLTRIM(QRYDAK->DAK_COD);
				 	+ ' - Não enviado, aguardando protocolo de abertura de carga enviado com gatilho do pedido ' + alltrim(QRYPED->DAI_PEDIDO) + ' - ' +;
				   	dToC(dDataBase) + " - " + time())

					dbSelectArea("DAK")
					dbSetOrder(1)
					IF DBSEEK(QRYDAK->DAK_FILIAL+QRYDAK->DAK_COD)
						If empty(DAK->DAK_XRETWS)
							RecLock("DAK",.F.)
							DAK->DAK_XRETWS:='Não enviado, aguardando protocolo de abertura de carga enviado com gatilho do pedido ' + alltrim(QRYPED->DAI_PEDIDO)
							DAK->(  msUnlock() )
						Endif
						If ALLTRIM(DAK->DAK_XRETWS) == 'Carga(gatilho) enviado ao Multiembarcador'
							RecLock("DAK",.F.)
							DAK->DAK_XRETWS:='Pedido inicial enviado, aguardando protocolo de abertura de carga enviado com o gatilho do pedido ' + alltrim(QRYPED->DAI_PEDIDO)
							DAK->(  msUnlock() )
							_linicio := .T.
						eNDIF
				
					ENDIF	

				endif

				IF SELECT("QRYPED") > 0
					QRYPED->( dbCloseArea() )
				ENDIF
			else
				lcontinua:= .t.
			ENDIF
		  ENDIF

		  IF lContinua
			//Query para verificar se é o ultimo
			cQuery := "	SELECT DAI_PEDIDO "
			cQuery += " FROM "+retSQLName("DAI")+" DAI"					+CRLF
			cQuery += " INNER JOIN  "+retSQLName("DAK")+" DAK"			+CRLF
			cQuery += " ON DAK.DAK_COD=DAI.DAI_COD"						+CRLF
			cQuery += " AND DAK.DAK_FILIAL=DAI.DAI_FILIAL" 				+CRLF
			cQuery += " AND DAI.D_E_L_E_T_      <>  '*'"				+CRLF
			cQuery += " WHERE DAI.DAI_FILIAL='"+QRYDAK->DAK_FILIAL+"' " +CRLF
			cQuery += " AND DAK.DAK_XOEREF='"+QRYDAK->DAK_XOEREF+"' "	+CRLF
			cQuery += " AND DAI.DAI_PEDIDO<>'"+QRYDAK->DAI_PEDIDO+"' AND DAI.D_E_L_E_T_<>'*'"
			cQuery += " AND DAI_XINTME =' '"							+CRLF

			IF SELECT("QRYPED") > 0
				QRYPED->( dbCloseArea() )
			ENDIF

			TcQuery changeQuery(cQuery) New Alias "QRYPED"

			IF QRYPED->(eof())
				//Se é o último, verifica se todos os outros pedidos já foram processados antes de enviar fechamento
				cQuery := "	SELECT DAI_PEDIDO "
				cQuery += " FROM "+retSQLName("DAI")+" DAI"					+CRLF
				cQuery += " INNER JOIN  "+retSQLName("DAK")+" DAK"			+CRLF
				cQuery += " ON DAK.DAK_COD=DAI.DAI_COD"						+CRLF
				cQuery += " AND DAK.DAK_FILIAL=DAI.DAI_FILIAL" 				+CRLF
				cQuery += " AND DAI.D_E_L_E_T_      <>  '*'"				+CRLF
				cQuery += " WHERE DAI.DAI_FILIAL='"+QRYDAK->DAK_FILIAL+"' " +CRLF
				cQuery += " AND DAK.DAK_XOEREF='"+QRYDAK->DAK_XOEREF+"' "	+CRLF
				cQuery += " AND DAI.DAI_PEDIDO<>'"+QRYDAK->DAI_PEDIDO+"' AND DAI.D_E_L_E_T_<>'*'"
				cQuery += " AND DAI_XPROPV =' '"							+CRLF

				IF SELECT("QRYPED2") > 0
					QRYPED2->( dbCloseArea() )
				ENDIF

				TcQuery changeQuery(cQuery) New Alias "QRYPED2"

				IF QRYPED2->(eof())
			
					cFecha:="true" 

				else

					lContinua := .F.

					conout('Thread ' + strzero(threadid(),6) +  ' - [MGFWSC46]] ' + ALLTRIM(QRYDAK->DAK_COD);
				 	+ ' Aguardando processamento de pedidos enviados para enviar pedido de fechamento: ' + alltrim(QRYDAK->DAI_PEDIDO) + ' - ' +;
				   	dToC(dDataBase) + " - " + time())

				Endif

				IF SELECT("QRYPED") > 0
					QRYPED->( dbCloseArea() )
				ENDIF

			ELSE
				cfecha:= "false"
			endif
		
			IF SELECT("QRYPED") > 0
				QRYPED->( dbCloseArea() )
			ENDIF
		
		  endif

		  If lcontinua
			
				conout('Thread ' + strzero(threadid(),6) +  ' - [MGFWSC46]] - Testando se todos pedidos foram enviados para o Protheus')
				//webservice que pergunta para o Taura se ele enviou todos os pedidos da Ordem de embarque para o Protheus
				cURL:=strTran( cURLPost2, "{OrdemEmbarque}", ALLTRIM(QRYDAK->DAK_XOEREF) )
				cURL:=strTran( cURL, "{Filial}",QRYDAK->DAK_FILIAL)
				cTimeIni := time()
				xPostRet := httpQuote( cURL /*<cUrl>*/, "GET" /*<cMethod>*/, /*[cGETParms]*/, /*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadOut /*[aHeadStr]*/, @cHeadRet /*[@cHeaderRet]*/ )
				cTimeFin	:= time()
				cTimeProc	:= elapTime( cTimeIni, cTimeFin )

				nStatuHttp	:= 0
				nStatuHttp	:= httpGetStatus()

				conout(" [MGFGFE46] * * * * * Status da integracao * * * * *")
				conout(" [MGFGFE46] Inicio.......................: " + cTimeIni + " - " + dToC( dDataBase ) )
				conout(" [MGFGFE46] Fim..........................: " + cTimeFin + " - " + dToC( dDataBase ) )
				conout(" [MGFGFE46] Tempo de Processamento.......: " + cTimeProc )
				conout(" [MGFGFE46] URL..........................: " + cURL)
				conout(" [MGFGFE46] HTTP Method..................: " + "GET" )
				conout(" [MGFGFE46] Status Http (200 a 299 ok)...: " + allTrim( str( nStatuHttp ) ) )
				conout(" [MGFGFE46] Retorno......................: " + allTrim( xPostRet ) )
				conout(" [MGFGFE46] * * * * * * * * * * * * * * * * * * * * ")

				if nStatuHttp == 412 //Existem pedidos da OE Referencia que nAo foram enviados para o Protheus
					lContinua:= .f. //SE NÃO FOI ENVIADO TODAS AS CARGAS PRO PROTHEUS  NÃO PODE ENVIAR
				ELSEif  nStatuHttp >= 500 //erro
					lContinua:= .f.
				else  //nAo localizado(gerado direto no protheus) ou ok
					lContinua:= .t.
				ENDIF
				if !lContinua
					dbSelectArea("DAK")
					dbSetOrder(1)
					IF DBSEEK(QRYDAK->DAK_FILIAL+QRYDAK->DAK_COD)
						RecLock("DAK",.F.)
						DAK->DAK_XRETWS:="Carga nao enviada ao Multiembarcador - Existe pendencia de envio de OE de Bitrem do Taura - " + allTrim( xPostRet )
						DAK->(  msUnlock() )
					ENDIF
					conout('Thread ' + strzero(threadid(),6) +  ' - [MGFWSC46]] ' + ALLTRIM(QRYDAK->DAK_COD);
					 + ' - Carga nao enviada ao Multiembarcador - Existe pendencia de envio de OE de Bitrem do Taura - ' + allTrim( xPostRet ) + " - " + ;
					   dToC(dDataBase) + " - " + time())

				endif
			
		  Endif

		  if 	lContinua
			cJson := '{"Unidade":"'+QRYDAK->DAK_FILIAL+'","OEReferencia":"'+ALLTRIM(QRYDAK->DAK_XOEREF)+'","fecharCargaAutomaticamente":'+cFecha+'}'
			cURL:=strTran( cURLPost, "{NumeroOrdemEmbarque}", ALLTRIM(QRYDAK->DAK_COD) )
			cURL:=strTran( cURL, "{NumeroPedido}", ALLTRIM(QRYDAK->DAI_PEDIDO) )
			cTimeIni := time()
			xPostRet := httpQuote( cURL /*<cUrl>*/, "POST" /*<cMethod>*/, /*[cGETParms]*/, cJson/*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadOut /*[aHeadStr]*/, @cHeadRet /*[@cHeaderRet]*/ )
			cTimeFin	:= time()
			cTimeProc	:= elapTime( cTimeIni, cTimeFin )

			nStatuHttp	:= 0
			nStatuHttp	:= httpGetStatus()

			conout(" [MGFGFE46] * * * * * Status da integracao * * * * *")
			conout(" [MGFGFE46] Inicio.......................: " + cTimeIni + " - " + dToC( dDataBase ) )
			conout(" [MGFGFE46] Fim..........................: " + cTimeFin + " - " + dToC( dDataBase ) )
			conout(" [MGFGFE46] Tempo de Processamento.......: " + cTimeProc )
			conout(" [MGFGFE46] URL..........................: " + cURL)
			conout(" [MGFGFE46] HTTP Method..................: " + "POST" )
			conout(" [MGFGFE46] Status Http (200 a 299 ok)...: " + allTrim( str( nStatuHttp ) ) )
			conout(" [MGFGFE46] Envio........................: " + allTrim( cJson ) )
			conout(" [MGFGFE46] Retorno......................: " + allTrim( xPostRet ) )
			conout(" [MGFGFE46] * * * * * * * * * * * * * * * * * * * * ")

			if nStatuHttp >= 200 .and. nStatuHttp <= 299
				cQuery := " UPDATE " + RetSqlname("DAI")
				cQuery += " SET 	DAI_XINTME = 'S'"
				cQuery += " WHERE DAI_FILIAL = '" + QRYDAK->DAK_FILIAL + "' "
				cQuery += "	AND DAI_COD = '" + QRYDAK->DAK_COD + "' "
				cQuery += " AND DAI_PEDIDO = '"+QRYDAK->DAI_PEDIDO+"' "
				cQuery += "	AND D_E_L_E_T_ <> '*' "
				TcSqlExec(cQuery)

				dbSelectArea("DAK")
				dbSetOrder(1)
				IF DBSEEK(QRYDAK->DAK_FILIAL+QRYDAK->DAK_COD)
					If cFecha == "false"
						RecLock("DAK",.F.)
						DAK->DAK_XRETWS:="Carga(gatilho) em processo de envio ao multiembarcador"
						DAK->(  msUnlock() )
					Elseif !_linicio
						RecLock("DAK",.F.)
						DAK->DAK_XRETWS:="Carga(gatilho) enviado ao Multiembarcador"
						If DAK->DAK_ZRENV != "0"
							DAK->DAK_ZDTEN := date() 
							DAK->DAK_ZTMPE := seconds()
							DAK->DAK_ZRENV := "1"
						Endif
						DAK->(  msUnlock() )	
					Endif
				ENDIF	

				IF ALLTRIM(QRYDAK->DAK_COD) <> ALLTRIM(QRYDAK->DAK_XOEREF)
					cQuery := " UPDATE  " + RetSqlname("GW1")
					cQuery += " SET GW1_NRROM = '"+QRYDAK->DAK_XOEREF+ALLTRIM(QRYDAK->DAK_SEQCAR)+"'"
					cQuery += " WHERE GW1_FILIAL =  '" + QRYDAK->DAK_FILIAL + "' "
					cQuery += " AND GW1_NRROM = '" + QRYDAK->DAK_COD +ALLTRIM(QRYDAK->DAK_SEQCAR)+"'"
					cQuery += "	AND D_E_L_E_T_ <> '*' "
					TcSqlExec(cQuery)				
				ENDIF

				//Se enviou o último pedido e já teve callback pois é reenvio envia fechamento da carga
				If cFecha == "true" .and. !empty(QRYDAK->DAI_XRETWS)


					cJson := '{"PROTOCOLOINTEGRACAOCARGA":"' + ALLTRIM(QRYDAK->DAI_XRETWS) + '"}'
					cURL:=cURLPostE
					cTimeIni := time()
					xPostRet := httpQuote( cURL /*<cUrl>*/, "POST" /*<cMethod>*/, /*[cGETParms]*/, cJson/*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadOut /*[aHeadStr]*/, @cHeadRet /*[@cHeaderRet]*/ )
					cTimeFin	:= time()
					cTimeProc	:= elapTime( cTimeIni, cTimeFin )

					nStatuHttp	:= 0
					nStatuHttp	:= httpGetStatus()

					conout(" [MGFGFE46] * * * * * Status da integracao * * * * *")
					conout(" [MGFGFE46] Inicio.......................: " + cTimeIni + " - " + dToC( dDataBase ) )
					conout(" [MGFGFE46] Fim..........................: " + cTimeFin + " - " + dToC( dDataBase ) )
					conout(" [MGFGFE46] Tempo de Processamento.......: " + cTimeProc )
					conout(" [MGFGFE46] URL..........................: " + cURL)
					conout(" [MGFGFE46] HTTP Method..................: " + "POST" )
					conout(" [MGFGFE46] Status Http (200 a 299 ok)...: " + allTrim( str( nStatuHttp ) ) )
					conout(" [MGFGFE46] Envio........................: " + allTrim( cJson ) )
					conout(" [MGFGFE46] Retorno......................: " + allTrim( xPostRet ) )
					conout(" [MGFGFE46] * * * * * * * * * * * * * * * * * * * * ")

				Endif

			endif
		  
		  else

			//Se falhou validação da carga não faz validação pedido a pedido e pula para próxima carga
			If !lcontinua
				Do while _catual == alltrim(QRYDAK->DAK_FILIAL+QRYDAK->DAK_COD)
					QRYDAK->(DBSKIP())
				Enddo
				Loop
			Endif			
		  
		  endif

          QRYDAK->(DBSKIP())
 	  	  lcontinua := .T.

		Enddo

	enddo

	IF SELECT("QRYDAK") > 0
		QRYDAK->( dbCloseArea() )
	ENDIF


return

//-------------------------------------------------------------------
// Seleciona Notas a serem enviadas
//-------------------------------------------------------------------
static function QWSGFE46()

	local cQry := ""

	cQry := " select DAK.DAK_FILIAL,"							+CRLF
	cQry += " DAK.DAK_COD,"										+CRLF
	cQry += " DAK.DAK_SEQCAR,"									+CRLF
	cQry += " DAK.DAK_XOEREF,"									+CRLF
	cQry += " DAK.DAK_ZCDTPO,"									+CRLF
	cQry += " ZBS.ZBS_NUM,"										+CRLF
	cQry += " ZBS.ZBS_CNPJSE," 									+CRLF
	cQry += " DAI.DAI_PEDIDO,"									+CRLF
	cQry += " UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(DAI_XRETWS, 2000, 1)) DAI_XRETWS "	+CRLF
	cQry += " FROM "+retSQLName("DAK")+" DAK"					+CRLF
	cQry += " INNER JOIN  "+retSQLName("DAI")+" DAI"			+CRLF
	cQry += " ON DAK.DAK_COD=DAI.DAI_COD"						+CRLF
	cQry += " AND DAK.DAK_FILIAL=DAI.DAI_FILIAL" 				+CRLF
	cQry += " AND DAI.D_E_L_E_T_      <>  '*'"					+CRLF
	cQry += " INNER JOIN "+retSQLName("SC5")+" SC5"				+CRLF
	cQry += " ON DAI.DAI_PEDIDO=SC5.C5_NUM"						+CRLF
	cQry += " AND SC5.C5_FILIAL=DAK.DAK_FILIAL"					+CRLF
	cQry += " AND SC5.D_E_L_E_T_ <>  '*'"						+CRLF
	cQry += " INNER JOIN "+retSQLName("SA4")+" SA4"				+CRLF
	cQry += " ON SA4.D_E_L_E_T_ <> '*'" 						+CRLF
	cQry += " AND SA4.A4_FILIAL = '"+XFILIAL("SA4")+"'"			+CRLF
	cQry += " AND SA4.A4_COD = SC5.C5_TRANSP"					+CRLF
	cQry += " INNER JOIN "+retSQLName("SF2")+" SF2"				+CRLF
	cQry += " ON DAI.DAI_NFISCA=SF2.F2_DOC "					+CRLF
	cQry += " AND DAI.DAI_SERIE= SF2.F2_SERIE "					+CRLF
	cQry += " AND SF2.D_E_L_E_T_ <>  '*' "						+CRLF
	cQry += " AND DAI.DAI_FILIAL=SF2.F2_FILIAL "				+CRLF
	cQry += " AND SF2.F2_CHVNFE<>' '"							+CRLF
	cQry += " AND SF2.F2_ZARQXML<>' '"							+CRLF
	cQry += " INNER JOIN "+retSQLName("GV4")+" GV4"				+CRLF
	cQry += " ON GV4.GV4_FILIAL = DAK.DAK_FILIAL"				+CRLF
	cQry += " AND GV4.GV4_CDTPOP = DAK.DAK_ZCDTPO"				+CRLF
	cQry += " AND GV4.D_E_L_E_T_<>'*'"							+CRLF
	cQry += " AND GV4.GV4_XMEMB ='1' "							+CRLF
	cQry += " LEFT JOIN "+retSQLName("SA1")+" SA1"				+CRLF
	cQry += " ON SA1.A1_FILIAL='"+XFILIAL("SA1")+"'"			+CRLF
	cQry += " AND SA1.A1_COD=DAI.DAI_CLIENT"					+CRLF
	cQry += " AND SA1.A1_LOJA=DAI.DAI_LOJA"						+CRLF
	cQry += " AND SA1.D_E_L_E_T_<>'*'"							+CRLF
	cQry += " AND SC5.C5_TIPO='N'"								+CRLF
	cQry += " LEFT JOIN SA2010 SA2"								+CRLF
	cQry += " ON SA2.A2_FILIAL='"+XFILIAL("SA2")+"'"			+CRLF
	cQry += " AND SA2.A2_COD=DAI.DAI_CLIENT"					+CRLF
	cQry += " AND SA2.A2_LOJA=DAI.DAI_LOJA"						+CRLF
	cQry += " AND SA2.D_E_L_E_T_<>'*' "							+CRLF
	cQry += " AND SC5.C5_TIPO='B'"								+CRLF
	cQry += " LEFT JOIN SYS_COMPANY M0"							+CRLF
	cQry += " ON ((SA1.A1_CGC<> NULL AND M0.M0_CGC=SA1.A1_CGC)" +CRLF
	cQry += " OR (SA2.A2_CGC<> NULL AND M0.M0_CGC=SA2.A2_CGC))"	+CRLF
	cQry += " AND M0.D_E_L_E_T_<>'*'"							+CRLF
	cQry += " LEFT JOIN "+ retSQLName("ZBS") +" ZBS"			+CRLF
	cQry += " ON ZBS.ZBS_NUM=SF2.F2_DOC"						+CRLF
	cQry += " AND ZBS.ZBS_SERIE= SF2.F2_SERIE"					+CRLF
	cQry += " AND ZBS.D_E_L_E_T_ <>  '*'"						+CRLF
	cQry += " AND ZBS.ZBS_FILIAL=SF2.F2_FILIAL"					+CRLF
	cQry += " WHERE SA4.A4_ZINTMEM ='1'"						+CRLF
	cQry += " AND SC5.C5_TPFRETE='C'"							+CRLF
	cQry += " AND DAK.D_E_L_E_T_<>'*'"							+CRLF
	cQry += " AND DAI.DAI_XINTME =' '"							+CRLF
	cQry += " AND DAI.DAI_XPROTO =' '"							+CRLF
	cQry += " AND DAK.DAK_DATA >= '" + DTOS(DATE()-GETMV("MGF_GFE469",,30)) + "'"		+CRLF
	cQry += " AND DAK.DAK_XOPEME <>'C'"							+CRLF
	cQry += " AND DAK.DAK_FILIAL='"+XFILIAL("DAK")+"'"			+CRLF
	cQry += " AND DAK.DAK_DATA>='"+SUPERGETMV("MGF_DGFE46",,"20491231")+"'"		+CRLF
	cQry += " GROUP BY DAK.DAK_FILIAL,DAK.DAK_COD,DAK.DAK_SEQCAR,DAK.DAK_XOEREF,DAK.DAK_ZCDTPO,DAI.DAI_PEDIDO,ZBS.ZBS_NUM,ZBS.ZBS_CNPJSE,UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(DAI_XRETWS, 2000, 1))" +CRLF
	cQry += " ORDER BY DAK.DAK_FILIAL,DAK.DAK_COD,DAI.DAI_PEDIDO"+CRLF

	IF SELECT("QRYDAK") > 0
		QRYDAK->( dbCloseArea() )
	ENDIF
	TcQuery changeQuery(cQry) New Alias "QRYDAK"

return

//-------------------------------------------------------------------
// Update cargas para reenvio
//-------------------------------------------------------------------
static function UQWSGFE46()

	local cQry := ""

	cQry := " select DISTINCT DAK.DAK_XOEREF  "					+CRLF
	cQry += " FROM "+retSQLName("DAK")+" DAK"					+CRLF
	cQry += " INNER JOIN  "+retSQLName("DAI")+" DAI"			+CRLF
	cQry += " ON DAK.DAK_COD=DAI.DAI_COD"						+CRLF
	cQry += " AND DAK.DAK_FILIAL=DAI.DAI_FILIAL"				+CRLF
	cQry += " AND DAI.D_E_L_E_T_      <>  '*'" 					+CRLF
	cQry += " WHERE DAK.D_E_L_E_T_<>'*'"						+CRLF
	cQry += " AND DAK.DAK_XOPEME='C' "							+CRLF
	cQry += " AND DAK.DAK_XSTCAN='A'"							+CRLF
	cQry += " AND DAK.DAK_FILIAL='"+XFILIAL("DAK")+"'"	 	 	+CRLF
	cQry += " AND DAI.DAI_XOPEME=' '"							+CRLF

	IF SELECT("QRYDAK2") > 0
		QRYDAK2->( dbCloseArea() )
	ENDIF
	TcQuery changeQuery(cQry) New Alias "QRYDAK2"

	while !QRYDAK2->(EOF())
		cQry := " UPDATE " + RetSqlname("DAK") + " "
		cQry += " SET 	DAK_XINTME = ' ', "
		cQry += " DAK_XOPEME='R',"
		cQry += " DAK_XSTCAN=' '"
		cQry += " WHERE DAK_FILIAL = '" + XFILIAL("DAK") + "' "
		cQry += " AND DAK_XOEREF = '" + QRYDAK2->DAK_XOEREF + "' "
		cQry += " AND D_E_L_E_T_ <> '*' "
		TcSqlExec(cQry)

		cQry := " UPDATE " + RetSqlname("DAI") + " "
		cQry += " SET DAI_XINTME = ' ',"
		cQry += " DAI_XOPEME='R',"
		cQry += " DAI_XPROPV=' ',"
		cQry += " DAI_XPROTO=' '"
		cQry += " WHERE DAI_FILIAL = '" + XFILIAL("DAI") + "' "
		cQry += " AND DAI_COD IN ( SELECT DISTINCT(DAI.DAI_COD) "
		cQry += " FROM "+retSQLName("DAI")+" DAI"
		cQry += " INNER JOIN  "+retSQLName("DAK")+" DAK"
		cQry += " ON DAK.DAK_COD=DAI.DAI_COD"
		cQry += " AND DAK.DAK_FILIAL=DAI.DAI_FILIAL"
		cQry += " AND DAK.D_E_L_E_T_      <>  '*'"
		cQry += " WHERE DAI.DAI_FILIAL = '" + XFILIAL("DAK")+ "' "
		cQry += " AND DAK.DAK_XOEREF = '" +QRYDAK2->DAK_XOEREF  + "' "
		cQry += " AND DAI.D_E_L_E_T_ <> '*' )"
		cQry += " AND D_E_L_E_T_ <> '*' "
		TcSqlExec(cQry)

		QRYDAK2->(DBSKIP())
	ENDDO
	IF SELECT("QRYDAK2") > 0
		QRYDAK2->( dbCloseArea() )
	ENDIF

return

/*/
{Protheus.doc} QWRGFE46 
Filtro para ajuste de registros

@description
Filtro que pega todos os registros da DAK que estejam com :
a) DAK_ZRENV = 1
b) DAK_ZDTEN = date() 
c) DAK_ZTMPE menor que Seconds()-600

@author Paulo da Mata
@since 27/01/2020 
@type Function  

@history 
    27/01/2020 - PRB0040669 - Paulo Henrique Rodrigues da Mata
/*/   

Static Function QWRGFE46()

	Local cQry := ""

	cQry := "SELECT DAK_FILIAL,DAK_COD,DAK_SEQCAR,DAK_ZRENV,DAK_ZDTEN,DAK_ZTMPE "+CRLF
	cQry += "FROM "+RetSqlName("DAK")+" "+CRLF
	cQry += "WHERE D_E_L_E_T_ = ' ' "+CRLF
	cQry += "AND DAK_ZRENV = '1' "+CRLF
	cQry += "AND DAK_ZDTEN = '"+DtoS(Date())+"'" +CRLF
	cQry += "AND DAK_ZTMPE < "+alltrim(str(Seconds()-600))+ CRLF

	If SELECT("QRYTRB") > 0
	   QRYTRB->( dbCloseArea() )
	EndIf
	
	TcQuery ChangeQuery(cQry) New Alias "QRYTRB"
    
	dbSelectArea("QRYTRB")
	QRYTRB->(dbGoTop())

	While QRYTRB->(!Eof())
	
	   DAI->(dbSetOrder(1))
	   If DAI->(dbSeek(QRYTRB->(DAK_FILIAL+DAK_COD)))
	   		Do while ALLTRIM(QRYTRB->(DAK_FILIAL+DAK_COD)) == ALLTRIM(DAI->DAI_FILIAL+DAI->DAI_COD)
	      		DAI->(RecLock("DAI",.F.))
		  		DAI->DAI_XINTME  := " "
		  		DAI->DAI_XOPEME := " "
				DAI->DAI_XPROPV := " "
				DAI->DAI_XPROTO := " "
		  		DAI->(MsUnLock())
				DAI->(Dbskip())
			Enddo
	   Endif

 	   DAK->(dbSetOrder(1))
	   If DAK->(dbSeek(QRYTRB->(DAK_FILIAL+DAK_COD)))
	      DAK->(RecLock("DAK",.F.))
		  DAK->DAK_ZDTEN := STOD("") 
		  DAK->DAK_ZTMPE := 0
		  DAK->DAK_ZRENV   := "0"
		  DAK->(MsUnLock())
	   Endif
       
	   dbSelectArea("QRYTRB")
	   QRYTRB->(dbSkip())

	EndDo

Return


/*/
{Protheus.doc} QWRFFE46 
Filtro para marcar cargas finalizadas

@author Josué Danich
@since 21/02/2020 
@type Function  
/*/   

Static Function QWRFFE46()

	Local cQry := ""
	Local cRegra := getmv("MGF_GFE46T",.F.,"000000017")

	ZFR->(Dbsetorder(1))
	If ZFR->(Dbseek(xfilial("ZFR")+cRegra))

 		_cZFR_PAYLOA := ZFR->ZFR_PAYLOA

   		_cZFR_PAYLOA := strtran(_cZFR_PAYLOA,chr(13)," ")
    	_cZFR_PAYLOA := strtran(_cZFR_PAYLOA,chr(10)," ")

    	_cqry := &(_cZFR_PAYLOA)    

 		If SELECT("QRYTRB") > 0
	   		QRYTRB->( dbCloseArea() )
		EndIf
	
		TcQuery _cqry New Alias "QRYTRB"
    
		dbSelectArea("QRYTRB")
		QRYTRB->(dbGoTop())

		While QRYTRB->(!Eof())
	
			DAI->(Dbsetorder(1))
			If DAI->(Dbseek(QRYTRB->DAK_FILIAL+QRYTRB->DAK_COD))
			
				_cProtoco	:= ALLTRIM(DAI->DAI_XRETWS) 
				_cOrdEmb	:= ALLTRIM(DAI->DAI_COD)

				If val(alltrim(_cprotoco)) <= 0
					QRYTRB->(!Dbskip())
					Loop
				Endif

				//-----| Fazendo a comunicação com o Barramento |-----\\
				oObjRet 	:= nil
				oCarga 		:= nil
				oWSGFE46 	:= nil

				ocarga := GFE46CARGA():new()
				ocarga:setDados()

				_cURLPost :=GetMV('MGF_GFE61C',.F.,"http://spdwvapl203:1337/multiembarcador/api/v1/verificaStatusCarga")
				oWSGFE46 := MGFINT23():new(_cURLPost, ocarga,0, "", "", "", "","","", .T. )
				oWSGFE46:lLogInCons := .T.

				_cSavcInt	:= Nil
				_cSavcInt	:= __cInternet    
				__cInternet	:= "AUTOMATICO"
				oWSGFE46:SendByHttpPost()
				__cInternet := _cSavcInt

						
				If oWSGFE46:lOk
					If fwJsonDeserialize(oWSGFE46:cPostRet , @oObjRet)	//Deserealiza gerando um objeto
						If "SituacaoCarga" $ oWSGFE46:cPostRet .AND.  VALTYPE(oObjRet:SituacaoCarga) == "C"	
						    //Verifica se retorno é válido.
							_cSitCarg := oObjRet:SituacaoCarga	//Guardo o retorno em variavel.
							If _cSitCarg $ ALLTRIM(SuperGetMV("MGF_GFE46S",.F.,"PendeciaDocumentos|AgImpressaoDocumentos|EmTransporte|Encerrada"))
								DAK->(Dbsetorder(1))
								//Marca carga como integrada
								If DAK->(Dbseek(DAI->DAI_FILIAL+DAI->DAI_COD))
									Reclock("DAK",.F.)
									DAK_XRETWS := "Carga(gatilho) enviado ao Multiembarcador"
									DAK->(Msunlock())
								Endif
							Endif
						Endif
					Endif
				Endif

			Endif
       
	   		dbSelectArea("QRYTRB")
	   		QRYTRB->(dbSkip())

		EndDo

	Endif

Return

/*/
{Protheus.doc} GFE46CARGA
Faz comunicação com o Barramento via HTTP Post.

@author Marcos Cesar Donizeti Vieira
@since 18/02/2020

@type Class
@param	
@return
/*/
Class GFE46CARGA
	Data applicationArea   			as ApplicationArea
	Data ProtocoloIntegracaoCarga   as Integer

	Method New()
	Method setDados()
EndClass



/*/
{Protheus.doc} GFE46CARGA->new
Contrutor de Classe.

@author Marcos Cesar Donizeti Vieira
@since 18/02/2020

@type Method
@param	
@return
/*/
Method new() Class GFE46CARGA
	self:applicationArea := ApplicationArea():new()
return



/*/
{Protheus.doc} GFE46CARGA->setDados
Metodo para pegar Protocolo de integração de carga.

@author Marcos Cesar Donizeti Vieira
@since 18/02/2020

@type Method
@param	
@return
/*/
Method SetDados() Class GFE46CARGA
	Self:ProtocoloIntegracaoCarga := Val(Alltrim(_cProtoco))
Return