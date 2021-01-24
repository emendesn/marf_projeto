#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr( 13 ) + chr( 10  )

static _aErr

/*/{Protheus.doc} runFATA5	 
Processa pedido de venda do registro posicionado na XC5
@type function

@author Josué Danich
@since 10/08/2020
@version P12
/*/
user function runFATA5()
	
	local nI				:= 0
	local nX				:= 0
	local aSC5				:= {}
	local aSC6				:= {}
	local aSC6Bonif			:= {}
	local aErro				:= {}
	local cErro				:= ""
	local aLine				:= {}
	local cSalesOrAt		:= ""
	local cTpFretECO		:= allTrim( superGetMv( "MGF_FREECO", , "C" ) )
	local cCondPgEco		:= allTrim( superGetMv( "MGFECOCDPG", , "999" ) )
	local cTpPedCC			:= allTrim( superGetMv( "MGFECOTPCC", , "CC" ) )

	local nStackSX8         := GetSx8Len()

	local cQrySC5			:= ""
	local cAliasSC5			:= getNextAlias()
	local cItemSC6			:= ""

	local nC5DescBol		:= 0
	local nC5DescCup		:= 0
	local nC5DescTot		:= 0 // Total de Desconto em Valor
	local nC5PercTot		:= 0 // Total de Desconto em Porcentual
	local nC6ValoTot		:= 0 // Total dos itens sem Desconto

	local cIdCard			:= ""
	local nCalc				:= 0
	local cPay				:= ""
	Local _cerros 			:= "Erro inderteminado ao gerar caucao"

	private aCustomer		:= {}
	private cAliasXC5		:= getNextAlias()
	private lMsHelpAuto     := .T.
	private lMsErroAuto     := .F.
	private lAutoErrNoFile  := .T. // Precisa estar como .T. para GetAutoGRLog() retornar o array com erros

	BEGIN SEQUENCE
	BEGIN TRANSACTION

			SA1->(Dbsetorder(15)) //A1_ZCDECOM

			if !(SA1->(Dbseek(alltrim(XC5->XC5_CLIENT))))
	

					_cstatus := "4"
					_cmens	 := "Cliente não encontrado"

					Disarmtransaction()
					Break	

			else

				//Valida cartao e gera registro de pre reserva para autorizacao posterior

				nCalc := XC5->XC5_VALCAU
				cPay  := XC5->XC5_PAYMID

				if !empty( XC5->XC5_NSU )
					_cerros := MGFFAT5G( XC5->XC5_IDPROF,SA1->A1_COD,SA1->A1_LOJA,SA1->A1_NOME,SA1->A1_CGC,nCalc,cPay )
				Endif

				If !empty(alltrim(_cerros)) .AND. !empty( XC5->XC5_NSU ) //Não conseguiu criar caução

					while GetSX8Len() > nStackSX8
						ROLLBACKSX8()
					enddo

					_cstatus := "4"
					_cmens	 := _cerros

					Disarmtransaction()
					Break	

				Endif
	
				aSC5 := {}
				aadd(aSC5, {'C5_TIPO'   	, "N"									, NIL})
				aadd(aSC5, {'C5_CLIENTE'	, SA1->A1_COD							, NIL})
				aadd(aSC5, {'C5_LOJACLI'	, SA1->A1_LOJA							, NIL})
				aadd(aSC5, {'C5_TIPOCLI'	, SA1->A1_TIPO							, NIL})

				if !empty( XC5->XC5_NSU )
					// Condição de pagamento POR CARTAO
					aadd(aSC5, {'C5_CONDPAG'	, cCondPgEco						, NIL})
					aadd(aSC5, {'C5_ZNSU'		, XC5->XC5_NSU				, NIL})
				endif

				aadd(aSC5, {'C5_VEND1'		, XC5->XC5_VENDED				, NIL})

				if !empty( XC5->XC5_NSU )
					aadd(aSC5, {'C5_ZTIPPED'	, cTpPedCC				, NIL})
				else
					aadd(aSC5, {'C5_ZTIPPED'	, XC5->XC5_ZTIPPE				, NIL})
				endif

				aadd(aSC5, {'C5_ZTPOPER'	, XC5->XC5_ZTIPOP				, NIL})
				aadd(aSC5, {'C5_TABELA'		, allTrim( XC5->XC5_TABELA )	, NIL})

				if !empty( XC5->XC5_ZIDEND )
					aadd(aSC5, {'C5_ZIDEND'	, XC5->XC5_ZIDEND				, NIL})
				endif

				aadd(aSC5, {'C5_TPFRETE'		, cTpFretECO 						, NIL})

				if !empty( XC5->XC5_DTENTR )
					aadd(aSC5, {'C5_FECENT'		,  XC5->XC5_DTENTR  			, NIL})
					aadd(aSC5, {'C5_ZDTEMBA'	,  XC5->XC5_DTENTR  			, NIL})
				endif

				aadd(aSC5, {'C5_ZIDECOM'	, XC5->XC5_IDECOM					, NIL})

				nC5DescCup := 0

				if XC5->XC5_DESCPV > 0
					nC5DescCup := XC5->XC5_DESCPV
					aadd(aSC5, {'C5_ZDSCECO'	, XC5->XC5_DESCPV	, NIL})
				endif

				nC5DescBol := 0

				if XC5->XC5_DSCBOL > 0
					nC5DescBol := XC5->XC5_DSCBOL
					aadd(aSC5, {'C5_ZDSCBOL'	, XC5->XC5_DSCBOL	, NIL})
				endif

				aadd(aSC5, {'C5_ZUSANCC'	, XC5->XC5_USANCC		, NIL})

				if !empty( XC5->XC5_PROMOC )
					aadd(aSC5, {'C5_ZPROMOC'	, XC5->XC5_PROMOC	, NIL})
				endif

				if !empty( XC5->XC5_DTCARR )
					aadd(aSC5, {'C5_ZDTCARR'	, XC5->XC5_DTCARR	, NIL})
				endif

				aadd(aSC5, {'C5_XORIGEM'	, XC5->XC5_ORIGEM					, NIL})
				aadd(aSC5, {'C5_XCALLBA'	, "S"								, NIL})

				cSalesOrAt	:= XC5->XC5_IDECOM
				cIdCard		:= ""
				cIdCard		:= XC5->XC5_IDPROF

				aSC6		:= {}
				aSC6Bonif	:= {}

				cItemSC6 := ""
				cItemSC6 := strZero ( 0 , tamSX3("C6_ITEM")[1] )

				nC6ValoTot := 0

				//Posiciona XC6 e faz itens
				XC6->(Dbsetorder(1))
				If !(XC6->(Dbseek(XC5->XC5_FILIAL+XC5->XC5_IDECOM)))
	
					_cstatus := "4"
					_cmens	 := "Não foram encontrados itens para o pedido"

					Disarmtransaction()
					Break	

				Endif
	
				while XC5->XC5_IDECOM == XC6->XC6_IDECOM .and. XC5->XC5_FILIAL == XC6->XC6_FILIAL

					nC6ValoTot += XC6->XC6_PRCVEN

					aLine := {}

					cItemSC6 := soma1( cItemSC6 )

					aadd(aLine, {'C6_ITEM'		, cItemSC6															, NIL})
					aadd(aLine, {'C6_PRODUTO'	, alltrim( XC6->XC6_PRODUT )								, NIL})
					aadd(aLine, {'C6_QTDVEN'	, XC6->XC6_QTDVEN											, NIL})

					aadd(aLine, {'C6_PRCVEN'	, ( XC6->XC6_PRCVEN / XC6->XC6_QTDVEN )				, NIL})

					if ( XC6->XC6_PRCVEN - XC6->XC6_DSCITE ) > 0
						aadd(aLine, {'C6_ZDSCITM'	, ( XC6->XC6_PRCVEN - XC6->XC6_DSCITE )	, NIL}) // GRAVA SOMENTE DESCONTO DO ITEM
						aadd(aLine, {'C6_VALDESC'	, ( XC6->XC6_PRCVEN - XC6->XC6_DSCITE )	, NIL}) // GRAVA SOMENTE DESCONTO DO ITEM
					endif
		
					aadd(aLine, {'C6_OPER'		, XC6->XC6_OPER												, NIL})

					aadd(aLine, {'C6_ZDTMIN'	, CTOD("  /  /  ")	, NIL})
					aadd(aLine, {'C6_ZDTMAX'	, CTOD("  /  /  ")	, NIL})

					aadd( aSC6, aLine )

					XC6->( DBSkip() )

				enddo

				nC5DescTot := 0
				nC5DescTot := ( nC5DescBol + nC5DescCup )

				nC5PercTot := 0
				
				if nC5DescTot > 0
					nC5PercTot := ( nC5DescTot * 100 ) / nC6ValoTot

					aadd(aSC5, {'C5_PDESCAB'		, nC5PercTot			, NIL})
				endif

				aSC5 := fwVetByDic( aSC5 /*aVetor*/ , "SC5" /*cTable*/ , .F. /*lItens*/ )
				aSC6 := fwVetByDic( aSC6 /*aVetor*/ , "SC6" /*cTable*/ , .T. /*lItens*/ )

				lMsErroAuto := .F.

				msExecAuto({|x,y,z|MATA410(x,y,z)}, aSC5, aSC6, 3)

				if lMsErroAuto .AND. alltrim(SC5->C5_ZIDECOM) != Alltrim(XC5->XC5_IDECOM)
	
					while GetSX8Len() > nStackSX8
						ROLLBACKSX8()
					enddo

					aErro := GetAutoGRLog() // Retorna erro em array
					cErro := ""

					for nI := 1 to len(aErro)
						cErro += aErro[nI] + CRLF
					next nI


					_cstatus := "4"
					_cmens	 := "Erro na criação do pedido: " + cErro

					Disarmtransaction()
					Break

				else
	
					while GetSX8Len() > nStackSX8
						CONFIRMSX8()
					enddo

					_cstatus := "3"
					_cmens	 := "Pedido Incluido"

					Reclock("XC5",.F.)
					XC5->XC5_STATUS := _cstatus
					XC5->XC5_HRPROC := time()
					XC5->XC5_PVPROT :=  SC5->C5_NUM
					XC5->XC5_HRTOTA := elapTime(XC5->XC5_HRRECE, XC5->XC5_HRPROC)
					XC5->XC5_OBS    := _cmens
					XC5->(Msunlock())	

					//Atualiza número do pedido na ZE6
					cQryZE6 := "SELECT R_E_C_N_O_ REC "									+ CRLF
					cQryZE6 += " FROM " + retSQLName("ZE6") + " ZE6"					+ CRLF	
					cQryZE6 += " WHERE"													+ CRLF
					cQryZE6 += " 		ZE6.ZE6_CNPJ	=	'" + cCnpj			+ "'"	+ CRLF
					cQryZE6 += " 	AND	ZE6.ZE6_NSU		=	'" + cNSU			+ "'"	+ CRLF
					cQryZE6 += " 	AND	ZE6.ZE6_FILIAL	=	'" + xFilial("ZE6")	+ "'"	+ CRLF
					cQryZE6 += " 	AND	ZE6.D_E_L_E_T_	<>	'*'"						+ CRLF

					tcQuery cQryZE6 New Alias "QRYZE6"

					if QRYZE6->(!EOF())

						ZE6->(Dbgoto(QRYZE6->REC))
						
						//Valida se não tem deadlock na ze6
						If !ZE6->(MsRLock(ZE6->(RECNO())))
							QRYZE6->(DBCloseArea())
							Disarmtransaction()
							Break
						else
							ZE6->(MsRunlock())
						Endif

						Reclock("ZE6",.F.)
						ZE6->ZE6_PEDIDO := SC5->C5_NUM
						ZE6->(Msunlock())

						QRYZE6->(DBCloseArea())

					else

						_cstatus := "4"
						_cmens	 := "Falha na atualizacao do registro de caucao"

						QRYZE6->(DBCloseArea())

						Disarmtransaction()
						Break

					Endif

				endif
				
			endif

	END TRANSACTION
	END SEQUENCE

	//Garante que mesmo com disarmtransaction o resultado vai ser gravado na XC5
	Reclock("XC5",.F.)
	XC5->XC5_STATUS := _cstatus
	XC5->XC5_HRPROC := time()
	XC5->XC5_HRTOTA := elapTime(XC5->XC5_HRRECE, XC5->XC5_HRPROC)
	XC5->XC5_OBS    := _cmens
	XC5->(Msunlock())	

return

/*/{Protheus.doc} MGFFATA5G	 
Valida cartao e gera registro de pre reserva para autorizacao posterior
@type function

@author Josué Danich
@since 10/08/2020
@version P12
/*/

static function MGFFAT5G( cIdCard, cCliente, cLoja, cNome, cCGC, nCalc, cPay )

	local aSE1			:= {}
	local cPrefixECO	:= allTrim( superGetMv( "MGF_PREFEC", , "ECO" ) )
	local cTipoECO		:= allTrim( superGetMv( "MGF_TIPOEC", , "CC" ) )
	local nTotalSE1		:= 0
	local aErro			:= {}
	local cErro			:= ""
	local cQrySC6Sum	:= ""
	local cAccessTok	:= ""
	local nStackSX8		:= GetSx8Len()

	local cQryZEC		:= ""
	local cCard			:= ""
	local cUpdSC5		:= ""
	local oCard			:= nil

	local aArea			:= getArea()
	local aAreaSZV		:= SZV->( getArea() )
	local aAreaSC5		:= SC5->( getArea() )

	Local _cerros 		:= "Falha indeterminada ao gerar caucao"

	cAccessTok := ""
	cAccessTok := u_authGtnt() // Retorna Token para utilizar os metodos da GetNet

	if !empty( cAccessTok )

		cCard := ""
		cCard := u_recoCard( cAccessTok, allTrim( cIdCard ) ) // Retorna dados do cartao em JSON 'string'

		oCard := nil

		if fwJsonDeserialize( cCard, @oCard ) // Transforma a string JSON em OBJETO
	
			_cbrand := upper( allTrim( oCard:brand ) )
			_cretorno := ""

			if u_chkCard( cAccessTok, oCard:CARDHOLDER_NAME, oCard:EXPIRATION_MONTH, oCard:EXPIRATION_YEAR, oCard:NUMBER_TOKEN, @_cretorno ) // Verifica se Cartao esta VALIDO
	
				cQryZEC := "SELECT "																	+ CRLF
				cQryZEC += "    ZEC_FILIAL, "															+ CRLF
				cQryZEC += "    ZEC_CODIGO, "															+ CRLF
				cQryZEC += "    ZEC_DESCRI, "															+ CRLF
				cQryZEC += "    ZEC_DIAS,   "															+ CRLF
				cQryZEC += "    ZEC_TAXA,   "															+ CRLF
				cQryZEC += "    ZEC_VENCTO  "															+ CRLF
				cQryZEC += "FROM " + retSQLName("ZEC") + " ZEC "										+ CRLF
				cQryZEC += "WHERE "																		+ CRLF
				cQryZEC += "    ZEC.D_E_L_E_T_ = ' ' "													+ CRLF
				cQryZEC += "    AND ZEC.ZEC_FILIAL = '" + xFilial("SA1")	+ "' "						+ CRLF
				cQryZEC += "    AND ZEC.ZEC_DESCRI LIKE '%" + _cbrand	+ "%'"	+ CRLF

				tcQuery cQryZEC New Alias "QRYZEC"

				If !QRYZEC->(EOF())

					If nCalc > 0


						cQryZE6 := "SELECT R_E_C_N_O_ REC "											+ CRLF
						cQryZE6 += " FROM " + retSQLName("ZE6") + " ZE6"							+ CRLF	
						cQryZE6 += " WHERE"															+ CRLF
						cQryZE6 += " 		ZE6.ZE6_CNPJ	=	'" + cCGC					+ "'"	+ CRLF
						cQryZE6 += " 	AND	ZE6.ZE6_NSU		=	'" + alltrim(XC5->XC5_NSU)	+ "'"	+ CRLF
						cQryZE6 += " 	AND	ZE6.ZE6_FILIAL	=	'" + xFilial("ZE6")			+ "'"	+ CRLF
						cQryZE6 += " 	AND	ZE6.D_E_L_E_T_	<>	'*'"								+ CRLF

						tcQuery cQryZE6 New Alias "QRYZE6"

						if QRYZE6->(EOF())
		
							RecLock("ZE6",.T.)
							ZE6->ZE6_FILIAL		:= XC5->XC5_FILIAL
							ZE6->ZE6_STATUS		:= "0"		// 0-Caução / 1-Título Gerado / 2-Título Baixado / 3-Erro
							ZE6->ZE6_CLIENT		:= cCliente
							ZE6->ZE6_LOJACL		:= cLoja
							ZE6->ZE6_CNPJ		:= cCGC
							ZE6->ZE6_NOMECL		:= cNome
							ZE6->ZE6_NSU		:= XC5->XC5_NSU
							ZE6->ZE6_IDTRAN		:= cPay
							ZE6->ZE6_DTINCL		:= dDataBase
							ZE6->ZE6_VALCAU		:= ( nCalc / 100 ) // Valor vem em centavos -  convertido para reais
							ZE6->ZE6_CODADM		:= QRYZEC->ZEC_CODIGO
							ZE6->ZE6_DESADM		:= QRYZEC->ZEC_DESCRI
							ZE6->ZE6_OBS		:= "Caucao criada a partir do pedido OCC " + ALLTRIM(XC5->XC5_IDECOM)
			
							ZE6->(MsUnLock())

							_cerros := ""
	
						else

							_cerros := "Ja existe caucao para mesmo NSU: " +  XC5->XC5_NSU
						
						endif

						QRYZE6->(DBCloseArea())

					else

						_cerros 		:= "Valor da venda zero"	
					
					endif
	
				else

					_cerros 		:= "Nao localizou operadora cadastrada para o cartao do cofre: " + ccard
				
				endif

				QRYZEC->(DBCloseArea())

			else

				_cerros 		:= "Falha validacao cartao recuperado do cofre: " + CHR(10)+CHR(13) + _cretorno
			
			Endif

		else

			_cerros 		:= "Falha ao recuperar cartao do cofre: " + ccard
		
		endif

	else

		_cerros 		:= "Falha autenticacao na autorizadora ao gerar caucao"
	
	endif

return _cerros
