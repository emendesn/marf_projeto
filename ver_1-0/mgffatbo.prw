#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "ap5mail.ch"

static _aErr

/*/
==============================================================================================================================================================================
Descrição   : Job de retorno de pedidos
@author     : Totvs
@since      : 11/03/2020
/*/
user function MGFFATBO( )

	//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "010041"

	U_MFCONOUT("Iniciou envio de callbacks Salesforce!")

	_cdefault := "010047,010048,010049,010050,010051,010053,010054,010055,010056,010057,010058,010041,010002"
	_cdefault += ",010003,010004,010005,010006,010007,010008,010009,010010,010012,010013,010015,010016,010022,"
	_cdefault += "010024,010025,010027,010029,010033,010038,010042,010044,010045,010059,010063,010064,010066,"
	_cdefault += "010067,010068,010039,010043,010046,010060,010061,010062,010065,010069,010070,020001,020003,020004"

	_cfiliais := getmv("MGFFATBOF",,_cdefault)

	_afiliais := strtokarr2(_cfiliais,",")

	For _nnp := 1 to len(_afiliais)

		U_MFCONOUT("Iniciando callback de pedidos Salesforce para filial - " + _afiliais[_nnp] + "...")

		cfilant := _afiliais[_nnp]
		cempant := substr(_afiliais[_nnp],1,2)

		MGFFATBOE()

		U_MFCONOUT("Completado callback de pedidos Salesforce para filial - " + _afiliais[_nnp] + "...")

	Next

	U_MFCONOUT("Completou envio de callbacks Salesforce!")



Return


//---------------------------------------------------------
user function MNUFATBO()

	MGFFATBOE()

return


/*/
==============================================================================================================================================================================
Descrição   : Execução retorno de pedidos para o SFA

@author     : Totvs
@since      : 02/10/2019
/*/
static function MGFFATBOE()
	local cIdInteg		:= ""
	local cIDMgf		:= allTrim( superGetMv( "MGFIDINTEG"	, , "9265ccc0-420b-11ea-bd9b-d80f99a790cc" ) )
	local cURLInteg		:= allTrim( superGetMv( "MGFFATBOA"		, , "http://spdwvapl203:1650/processo-pedido-venda/api/v2/empresas/{id}/pedidos-vendas" ) )
	local cURLUse		:= ""
	local cHTTPMetho	:= ""
	local cC5Fil		:= ""
	local cC5Num		:= ""
	local cJson			:= ""
	local nStatuHttp	:= 0
	local aHeadStr		:= {}
	local cHeaderRet	:= ""
	local nTimeOut		:= 120
	local cTimeIni		:= ""
	local cTimeFin		:= ""
	local cTimeProc		:= ""
	local cHttpRet		:= ""
	local nMaxItens		:= superGetMv( "MGFFATBOB" , , 100 )
	local nCountItem	:= 0
	local aSalesOrde	:= {}
	local lBlock		:= .F.
	local lBlockIten	:= .F.
	local lFaturado		:= .F.
	local lRoteiriza	:= .F.
	local cCallback		:= ""
	local cOrigemPV		:= ""

	local cCodInteg		:= allTrim( superGetMv( "MGF_CODSZ2"	, , "008" ) ) // SZ2	TABELA DE INTEGRACAO - 008 SALESFORCE
	local cCodTpInt		:= allTrim( superGetMv( "MGFFATBOC"		, , "009" ) ) // SZ3	TABELA DE TIPO DE INTEGRACAO - 009 PEDIDOS PROTHEUS -> SALESFORCE
	local cStaLog		:= ""
	local cErroLog		:= ""
	local nI			:= 0
	local cSC5Recnos	:= ""
	local cZC5Recnos	:= ""
	local cHeadHttp		:= ""
	local cLastProdu	:= ""

	private cQrySalesO	:= ""
	private cQrySZVRet	:= ""

//-------------------------- Identifica se é do TMS MultiSoftware------------------------------------------------------------------
	If FunName()="MATA410" 	 // Veio do Pedido de Vendas
		lTms := .T.
	Else
		lTms := .F.
	EndIf

	If lTms
		cCodInteg		:= allTrim( superGetMv( "MFG_WSS11G"	, , "011" ) ) // SZ2	TABELA DE INTEGRACAO - 011 TMS MULTISOFTWARE
		cCodTpInt		:= allTrim( superGetMv( "MGF_TMSINT"	, , "001" ) ) // SZ3	TABELA DE TIPO DE INTEGRACAO - 002 PE
	EndIf
//---------------------------------------------------------------------------------------------------------------------------------

	BEGIN SEQUENCE

		U_MFCONOUT("Carregando pedidos pendentes de retorno...")

		getSalesOr()

		if (cQrySalesO)->(EOF())
			if lTms	
				MSGINFO("[MGFFATBO_TMS] Não localizou pedidos para serem enviados ao TMS ","Atenção !!!")
			endif
			U_MFCONOUT(" Não localizou pedidos pendentes de retorno" )
			return

		else
			cURLUse := strTran( cURLInteg , "{id}" , allTrim( cFilAnt ) )

			//Conta cargas para enviar
			(cQrySalesO)->(DBGOTOP())
			_ntot := 0
			do while !((cQrySalesO)->(EOF()))
				_ntot++
				(cQrySalesO)->( Dbskip() )
			enddo

		endif

		_nni := 1

		(cQrySalesO)->(DBGOTOP())

		while !(cQrySalesO)->(EOF())
			nCountItem	:= 0
			aSalesOrde	:= {}
			cSC5Recnos	:= ""
			cZC5Recnos	:= ""

			cOrigemPV	:= ""
			cOrigemPV	:= (cQrySalesO)->C5_XORIGEM

			cCallback	:= ""
			cCallback	:= (cQrySalesO)->C5_XCALLBA
			IF lTms
				If (cQrySalesO)->EXCLUIDO=='*'
					cZTMSACA := "C"
				Else
					cZTMSACA := (cQrySalesO)->C5_ZTMSACA
				Endif				 
			endif
			cStaLog		:= ""
			cErroLog	:= ""

			while	!(cQrySalesO)->(EOF())					.and.;	// ATE O FINAL DA QUERY
					nCountItem	<= nMaxItens				.and.;	// LIMITE DE ITENS POR INTEGRACAO
					cOrigemPV	== (cQrySalesO)->C5_XORIGEM	.and.;	// AGRUPA POR ORIGEM
					cCallback	== (cQrySalesO)->C5_XCALLBA			// AGRUPA POR CALLBACK

				lRoteiriza	:= .F.
				lBlock		:= .F.
				lBlockIten	:= .F.

				if (cQrySalesO)->C5_ZROAD == "S"
					lRoteiriza := .T.
				endif

				nCountItem++
				U_MFCONOUT("Processando retorno de pedido " + strzero(_nni,6) + " de " +  strzero(_ntot,6) + " - " + (cQrySalesO)->C5_FILIAL + "|" + (cQrySalesO)->C5_NUM + "...")

				cC5Fil	:= (cQrySalesO)->C5_FILIAL
				cC5Num	:= (cQrySalesO)->C5_NUM
				cfilant := alltrim( (cQrySalesO)->C5_FILIAL )

				IF lTms
					If SC5->C5_TIPO $ ("D/B")	
						cEndNomePais := POSICIONE("SYA",1,XFILIAL("SYA")+ (cQrySalesO)->A2_PAIS,"YA_DESCR" )
					else
						cEndNomePais := POSICIONE("SYA",1,XFILIAL("SYA")+ (cQrySalesO)->A1_PAIS,"YA_DESCR" )
					endif
				endif
				If lTms
					If SC5->C5_TIPO $ ("D/B")	
						cEndIbge	 := IIf( (cQrySalesO)->A2_TIPO=="X","9999999",(cQrySalesO)->A2_COD_MUN)
					ELSE
						cEndIbge	 := IIf( (cQrySalesO)->A1_TIPO=="X","9999999",(cQrySalesO)->A1_COD_MUN)
					ENDIF
				EndIf

				oPedido := nil
				oPedido := jsonObject():new()

				if alltrim( (cQrySalesO)->PEDIDO ) == "S" .and. (cQrySalesO)->EXCLUIDO	<> "*"
					oPedido["status"]				:= "L" // SE GEROU PEDIDO
					cSC5Recnos += allTrim( str( (cQrySalesO)->XC5RECNO ) ) + ","
				elseif alltrim( (cQrySalesO)->PEDIDO ) == "N" .and. (cQrySalesO)->EXCLUIDO	<> "*"
					oPedido["status"]				:= "ER" // ERRO NA GERACAO DO PEDIDO
					cZC5Recnos += allTrim( str( (cQrySalesO)->XC5RECNO ) ) + ","
				elseif (cQrySalesO)->EXCLUIDO == "*"
					oPedido["status"]				:= "C" // SE PEDIDO FOI EXCLUIDO

					if alltrim( (cQrySalesO)->PEDIDO )== "S"
						cSC5Recnos += allTrim( str( (cQrySalesO)->XC5RECNO ) ) + ","
					else
						cZC5Recnos += allTrim( str( (cQrySalesO)->XC5RECNO ) ) + ","
					endif
				endif

				oPedido["idSistemaOrigem"]		:= allTrim( (cQrySalesO)->C5_XIDEXTE )
				oPedido["numeroPedidoERP"]		:= allTrim( (cQrySalesO)->C5_NUM )
				oPedido["tipo"]					:= allTrim( (cQrySalesO)->C5_ZTIPPED )
				oPedido["idVendedor"]			:= allTrim( (cQrySalesO)->C5_VEND1 )
				oPedido["idEndereco"]			:= allTrim( (cQrySalesO)->C5_ZIDEND )
				oPedido["condicaoPagamento"]	:= allTrim( (cQrySalesO)->C5_CONDPAG )
				oPedido["idTabelaPreco"]		:= allTrim( (cQrySalesO)->C5_TABELA )
				oPedido["comercial"]			:= chkType( (cQrySalesO)->C5_TABELA, (cQrySalesO)->C5_ZTIPPED )

				oPedido["observacao"]			:= allTrim( (cQrySalesO)->C5_XOBSPED )
				oPedido["observacaoNF"]			:= allTrim( (cQrySalesO)->C5_MENNOTA )

				oPedido["numeroPedidoCliente"]	:= allTrim( (cQrySalesO)->C5_ZPEDCLI )

				if !empty( (cQrySalesO)->C5_FECENT )
					oPedido["dataEntrega"]			:= left( fwTimeStamp( 3 , sToD( (cQrySalesO)->C5_FECENT ) ) , 10 )
				else
					oPedido["dataEntrega"]			:= nil
				endif

				oPedido["resevaEstoque"]		:= iif( (cQrySalesO)->C5_XRESERV	== "S" , .T. , .F. )
				oPedido["orcamento"]			:= iif( (cQrySalesO)->C5_XORCAME	== "S" , .T. , .F. )
				oPedido["rede"]					:= iif( (cQrySalesO)->C5_XREDE		== "S" , .T. , .F. )
				oPedido["numeroPedidoPaiRede"]	:= allTrim( (cQrySalesO)->C5_XPVPAI )

				oPedido["numeroNF"]				:= allTrim( (cQrySalesO)->D2_DOC )

				if lTms
					if (cQrySalesO)->C5_PBRUTO = 0
						_PesoBruto := fPesoBrutoPed((cQrySalesO)->C5_FILIAL,(cQrySalesO)->C5_NUM)
					Else
						_PesoBruto := (cQrySalesO)->C5_PBRUTO
					EndIf
					if (cQrySalesO)->C5_PESOL = 0
						_PesoLiq := fPesoLiqPed((cQrySalesO)->C5_FILIAL,(cQrySalesO)->C5_NUM)
					Else
						_PesoLiq := (cQrySalesO)->C5_PESOL
					EndIf
	
					oPedido["pesoBruto"]		:= _PesoBruto
					oPedido["pesoLiquido"]		:= _PesoLiq
					oPedido["tipoPagamento"]	:= (cQrySalesO)->C5_TPFRETE //_cTipoFrete
					oPedido["tipoTomador"]		:= (cQrySalesO)->C5_TPFRETE //_cTipoTomador
					oPedido["valordescarga"]	:= (cQrySalesO)->C5_XVLDESC
				endif

				oPedido["dataCarregamento"]		:= left( fwTimeStamp( 3 , sToD( (cQrySalesO)->C5_ZDTEMBA ) ) , 10 )
				oPedido["dataPrevisaoEntrega"]	:= left( fwTimeStamp( 3 , sToD( (cQrySalesO)->C5_FECENT ) ) , 10 )

				oPedido["UID"]					:= fwuuidv4( .T. )
				oPedido["RECNO"]				:= (cQrySalesO)->XC5RECNO

				oCliente 						:= nil
				oCliente 						:= jsonObject():new()

				If lTms
					If SC5->C5_TIPO $ ("D/B")	
						oCliente["id"]					:= allTrim( (cQrySalesO)->A2_COD )
						oCliente["loja"]				:= allTrim( (cQrySalesO)->A2_LOJA )
						oCliente["cnpj"]				:= allTrim( (cQrySalesO)->A2_CGC )
					ELSE
						oCliente["id"]					:= allTrim( (cQrySalesO)->A1_COD )
						oCliente["loja"]				:= allTrim( (cQrySalesO)->A1_LOJA )
						oCliente["cnpj"]				:= allTrim( (cQrySalesO)->A1_CGC )
					endif
				ELSE
					oCliente["id"]					:= allTrim( (cQrySalesO)->A1_COD )
					oCliente["loja"]				:= allTrim( (cQrySalesO)->A1_LOJA )
					oCliente["cnpj"]				:= allTrim( (cQrySalesO)->A1_CGC )
				ENDIF

				oPedido["cliente"]				:= oCliente

				if (cQrySalesO)->PEDIDO == "N" // MENSAGEM DE ERRO É ENVIADA APENAS SE PEDIDO NAO FOR GERADO
					oPedido["mensagemErro"]		:= allTrim( (cQrySalesO)->ZC5_OBS )
				else
					oPedido["mensagemErro"]		:= ""
				endif

				if !empty( (cQrySalesO)->C5_EMISSAO )
					oPedido["dataCriacao"]			:= left( fwTimeStamp( 3 , sToD( (cQrySalesO)->C5_EMISSAO ) ) , 10 )
				else
					oPedido["dataCriacao"]			:= nil
				endif

				//------------------------------------------
				// Bloqueios do Pedido
				//------------------------------------------
				oPedido["bloqueios"]	:= {}

				if (cQrySalesO)->PEDIDO == "S" // SOMENTE VERIFICA BLOQUEIOS SE GERAR PEDIDO
					u_getSZVx( .F. , (cQrySalesO)->C5_FILIAL , (cQrySalesO)->C5_NUM , )

					while !(cQrySZVRet)->( EOF() )
						lBlock					:= .T.
						oBloqueio 				:= nil
						oBloqueio				:= jsonObject():new()
						oBloqueio["codigo"]		:= allTrim( (cQrySZVRet)->ZV_CODRGA )
						oBloqueio["descricao"]	:= allTrim( (cQrySZVRet)->ZT_DESCRI )

						aadd( oPedido["bloqueios"] , oBloqueio )
						freeObj( oBloqueio )

						(cQrySZVRet)->( DBSkip() )
					enddo

					(cQrySZVRet)->( DBCloseArea() )
				endif

				//-------------------------- Dados do Vendedor ----------------------------------------------------------------------------------
				_cNomeVend 						:= Posicione("SA3",1,xFilial("SA3")+(cQrySalesO)->C5_VEND1,"A3_NOME")
				_cCnpjVend						:= Posicione("SA3",1,xFilial("SA3")+(cQrySalesO)->C5_VEND1,"A3_CGC")
				_cEmailVend						:= Posicione("SA3",1,xFilial("SA3")+(cQrySalesO)->C5_VEND1,"A3_EMAIL")
				_cRgIeVend						:= Posicione("SA3",1,xFilial("SA3")+(cQrySalesO)->C5_VEND1,"A3_INSCR")
				_cDDDVend						:= Posicione("SA3",1,xFilial("SA3")+(cQrySalesO)->C5_VEND1,"A3_DDDTEL")
				_cTelVend						:= Posicione("SA3",1,xFilial("SA3")+(cQrySalesO)->C5_VEND1,"A3_TEL")
				_cTipoPVend						:= iif(len(alltrim(_cCnpjVend))==14,"Juridica","Fisica")
				oVendedor 						:= nil
				oVendedor						:= jsonObject():new()
				oVendedor["nomeFantasia"]		:= _cNomeVend
				oVendedor["cnpj"]				:= iif(alltrim(_cCnpjVend)="00000000000","",Alltrim(_cCnpjVend) )
				oVendedor["email"]				:= _cEmailVend
				oVendedor["rgIe"]				:= _cRgIeVend
				oVendedor["tipoPessoa"]			:= _cTipoPVend
				oPedido["vendedor"]				:= oVendedor

				oVendEnd 						:= nil
				oVendEnd						:= jsonObject():new()
				oVendEnd["telefone"]			:= Alltrim(_cDDDVend)+Alltrim(_cTelVend)
				oVendedor["endereco"]			:= oVendEnd

//-------------------------- Dados do Cliente ----------------------------------------------------------------------------------
				If lTms
					If SC5->C5_TIPO $ ("D/B")	
						oCliente["nomeFantasia"]	:= allTrim( (cQrySalesO)->A2_NREDUZ )
						oCliente["rgIe"]			:= allTrim( (cQrySalesO)->A2_INSCR)
						oCliente["razaoSocial"]		:= allTrim( (cQrySalesO)->A2_NOME)
						oCliente["tipoPessoa"]		:= iif( (cQrySalesO)->A2_TIPO=="J","Juridica","")
					ELSE
						oCliente["nomeFantasia"]	:= allTrim( (cQrySalesO)->A1_NREDUZ )
						oCliente["rgIe"]			:= allTrim( (cQrySalesO)->A1_INSCR)
						oCliente["razaoSocial"]		:= allTrim( (cQrySalesO)->A1_NOME)
						oCliente["tipoPessoa"]		:= iif( (cQrySalesO)->A1_PESSOA=="J","Juridica","")
					ENDIF
				EndIf
				oPedido["cliente"]				:= oCliente

//-------------------------- Dados do Endereço do Cliente ----------------------------------------------------------------------------------
				oEndereco 						:= nil
				oEndereco						:= jsonObject():new()
				If lTms
					fIbge()
					If SC5->C5_TIPO $ ("D/B")	
						oEndereco["bairro"]				:= allTrim( (cQrySalesO)->A2_BAIRRO )
						oEndereco["cep"]				:= allTrim( (cQrySalesO)->A2_CEP )
						oEndereco["complemento"]		:= allTrim( (cQrySalesO)->A2_COMPLEM )
						oEndereco["logradouro"]			:= allTrim( (cQrySalesO)->A2_END )
						oEndereco["ddd"]				:= VAL( (cQrySalesO)->A2_DDD )
						oEndereco["telefone"]			:= iif(Empty( (cQrySalesO)->A2_TEL),"99999999", (cQrySalesO)->A2_TEL )
						oEndereco["cidade"]				:= iif( (cQrySalesO)->A2_TIPO=="X","EXPORTACAO", (cQrySalesO)->A2_MUN)
						oEndereco["ibge"]				:= val(alltrim(fcodIbge)+cEndIbge)
						oEndereco["nomePais"]			:= cEndNomePais
						oEndereco["idPais"]				:= (cQrySalesO)->A2_CODPAIS
					ELSE
						oEndereco["bairro"]				:= allTrim( (cQrySalesO)->A1_BAIRRO )
						oEndereco["cep"]				:= allTrim( (cQrySalesO)->A1_CEP )
						oEndereco["complemento"]		:= allTrim( (cQrySalesO)->A1_COMPLEM )
						oEndereco["logradouro"]			:= allTrim( (cQrySalesO)->A1_END )
						oEndereco["ddd"]				:= VAL( (cQrySalesO)->A1_DDD )
						oEndereco["telefone"]			:= iif(Empty( (cQrySalesO)->A1_TEL),"99999999", (cQrySalesO)->A1_TEL )
						oEndereco["cidade"]				:= iif( (cQrySalesO)->A1_TIPO=="X","EXPORTACAO", (cQrySalesO)->A1_MUN)
						oEndereco["ibge"]				:= val(alltrim(fcodIbge)+cEndIbge)
						oEndereco["nomePais"]			:= cEndNomePais
						oEndereco["idPais"]				:= (cQrySalesO)->A1_CODPAIS
					ENDIF
				Endif
				oCliente["endereco"]			:= oEndereco
//-------------------------- Dados do Endereço de Entrega do Cliente -------------------------------------------------------------

				oEntrega 						:= nil
				oEntrega						:= jsonObject():new()
				If lTms
					oEntrega["bairro"]				:= allTrim( (cQrySalesO)->BAIRRO )
					oEntrega["complemento"]			:= allTrim( (cQrySalesO)->COMPLEMEN )
					oEntrega["ddd"]					:= VAL( (cQrySalesO)->DDDZ9 )
					oEntrega["telefone"]			:= alltrim((cQrySalesO)->TELEFONE)
					If SC5->C5_TIPO $ ("D/B")	
						_cIbgeEntrega 					:= IIF((cQrySalesO)->A2_TIPO="X","999999",allTrim( (cQrySalesO)->CODMUNIC ))
					ELSE
						_cIbgeEntrega 					:= IIF((cQrySalesO)->A1_TIPO="X","999999",allTrim( (cQrySalesO)->CODMUNIC ))
					ENDIF
					fIbge()
					oEntrega["ibge"]				:= Val(alltrim(fCodIbge)+_cIbgeEntrega)
				EndIf
				oEntrega["cep"]					:= allTrim( (cQrySalesO)->CEP )
				oEntrega["logradouro"]			:= allTrim( (cQrySalesO)->ENDERECO )
				oEntrega["cidade"]				:= allTrim( (cQrySalesO)->MUNICIPIO )
				if lTms
					oEntrega["nomePais"]			:= cEndNomePais
					If SC5->C5_TIPO $ ("D/B")	
						oEntrega["idPais"]				:= (cQrySalesO)->A2_CODPAIS
					ELSE
						oEntrega["idPais"]				:= (cQrySalesO)->A1_CODPAIS
					ENDIF
				ENDIF
				oCliente["entrega"]				:= oEntrega

				//------------------------------------------
				// Itens do Pedido
				//------------------------------------------
				oPedido["items"]	:= {}
				lFaturado			:= .F.
				cLastProdu			:= ""
				lBlockIten			:= .F.

				_Nx := 0
				while !(cQrySalesO)->(EOF()) .AND.  cC5Fil	== (cQrySalesO)->C5_FILIAL .AND.  cC5Num == (cQrySalesO)->C5_NUM

					if (cQrySalesO)->D2_QUANT > 0
						lFaturado := .T.
					endif
					_Nx += 1
					_cUm 		:= POSICIONE("SB1",1,XFILIAL("SB1")+(cQrySalesO)->C6_PRODUTO,"B1_UM")
					_cGrupo 	:= POSICIONE("SB1",1,XFILIAL("SB1")+(cQrySalesO)->C6_PRODUTO,"B1_GRUPO")
					_NomeGrupo 	:= POSICIONE("SBM",1,XFILIAL("SBM")+_cGrupo,"BM_DESC")
					If lTms
						If _Nx == 1
							oTms 								:= nil
							oTms								:= jsonObject():new()
							oTms["ultimaAcao"]					:= IIF(EMPTY((CQrySalesO)->C5_ZTMSACA),"I",cZTMSACA)
							oTms["integraTms"]					:= "true"
							If lTms
								oTms["refTransExp"]				:= Alltrim((cQrySalesO)->C5_ZNUMEXP)
								oTms["acondicionaCarga"]		:= SUBS((cQrySalesO)->C5_XACONDC,1,1)
							EndIf
							If lTms
								oTms["idTransacao"]				:= IIF(EMPTY((cQrySalesO)->C5_ZTMSID),0,VAL((cQrySalesO)->C5_ZTMSID))
							EndIf
							oTms["codigoIntegracao"]			:= Alltrim(SM0->M0_CGC)

							EE5->(DbSetOrder(1))
							EE5->(DBSEEK(XFILIAL("EE5")+ALLTRIM(SB1->B1_CODEMB)))
							If "1" = EE5->EE5_ZGANCH
							//Posicione("EE5",1,xFilial("EE5")+ALLTRIM(SB1->B1_CODEMB),"EE5_ZGANCH")
								oTms["tipoCargaEmbarcador"]		:= ALLTRIM(SB1->B1_CODEMB) //CARNE COM OSSO
							Else
								If lTms
									IF Empty(SUBS((cQrySalesO)->C5_XTPROD,1,1))
										IF MSGYESNO("Deseja enviar sem o tipo do produto estar informado ?","Atenção !!!")
											oTms["tipoCargaEmbarcador"]	:= SUBS((cQrySalesO)->C5_XTPROD,1,1)
										else
											(cQrySalesO)->(DBCloseArea())
											Return
										Endif
									else
										oTms["tipoCargaEmbarcador"]	:= SUBS((cQrySalesO)->C5_XTPROD,1,3)
									endif
								EndIf
							EndIf
							oTms["numeroPedidoEmbarcador"]  	:= Alltrim((cQrySalesO)->C5_NUM)
				//-------------------------- Especie do pedido -------------------------------------------------------------------------------
							oEspecie 						:= nil
							oEspecie						:= jsonObject():new()
							oEspecie["id"]					:= (cQrySalesO)->C5_ZTIPPED
							oEspecie["descricao"]			:= alltrim(POSICIONE("SZJ",1,xFilial("SZJ")+(cQrySalesO)->C5_ZTIPPED,"ZJ_NOME"))
							oTms["especie"]					:= oEspecie
				//-----------------------------------------------------------------------------------------------------------------------------
							oPedido["tms"]					:= oTms
						EndIf
					EndIf

					if cLastProdu <> (cQrySalesO)->C6_PRODUTO
						cLastProdu := (cQrySalesO)->C6_PRODUTO

						oItem 							:= nil
						oItem							:= jsonObject():new()
						oItem["item"]					:= allTrim( (cQrySalesO)->C6_ITEM )
						oItem["idProduto"]				:= allTrim( (cQrySalesO)->C6_PRODUTO )
						oItem["quantidadeKG"]			:= (cQrySalesO)->C6_QTDVEN
						oItem["preco"]					:= (cQrySalesO)->C6_PRCVEN
						oItem["descricao"]				:= allTrim( (cQrySalesO)->DESCPROD )
						oItem["pesoUnitario"]			:= 1
						oItem["unidadeMedida"]			:= _cUm
						oItem["idGrupo"]				:= _cGrupo
						oItem["nomeGrupo"]				:= _NomeGrupo
						oItem["quantidadeKGFaturada"]	:= (cQrySalesO)->D2_QUANT

						if empty( oPedido["numeroPedidoCliente"] )
							oPedido["numeroPedidoCliente"] := (cQrySalesO)->C6_NUMPCOM
						endif

						if !empty( (cQrySalesO)->C6_ZDTMAX )
							oItem["dataMaxima"]		:= left( fwTimeStamp( 3 , sToD( (cQrySalesO)->C6_ZDTMAX ) ) , 10 )
						endif

						if !empty( (cQrySalesO)->C6_ZDTMIN )
							oItem["dataMinima"]		:= left( fwTimeStamp( 3 , sToD( (cQrySalesO)->C6_ZDTMIN ) ) , 10 )
						endif

						//------------------------------------------
						// Bloqueio dos itens
						//------------------------------------------

						oItem["bloqueios"]		:= {}

						if (cQrySalesO)->PEDIDO == "S" // SOMENTE VERIFICA BLOQUEIOS SE GERAR PEDIDO
							u_getSZVx( .T. , (cQrySalesO)->C5_FILIAL , (cQrySalesO)->C5_NUM , (cQrySalesO)->C6_ITEM )

							while !(cQrySZVRet)->( EOF() )
								lBlock					:= .T. // Flag de Bloqueio do PEDIDO
								lBlockIten				:= .T. // Flag de Bloqueio do ITEM
								oItem["status"]			:= "B" // Flag de Bloqueio do ITEM
								oBloqueio 				:= nil
								oBloqueio				:= jsonObject():new()
								oBloqueio["codigo"]		:= allTrim( (cQrySZVRet)->ZV_CODRGA )
								oBloqueio["descricao"]	:= allTrim( (cQrySZVRet)->ZT_DESCRI )

								aadd( oItem["bloqueios"] , oBloqueio )
								freeObj( oBloqueio )

								(cQrySZVRet)->( DBSkip() )
							enddo

							(cQrySZVRet)->( DBCloseArea() )
						endif

						if (cQrySalesO)->C6DELET == 2
							oItem["status"] := "C"
						else
							if oItem["status"] <> "B"
								oItem["status"] := "L"
							endif
						endif

						aadd( oPedido["items"] , oItem )

						freeObj( oItem )
					endif

					_nni++

					(cQrySalesO)->( DBSkip() )
				enddo // LACO DOS ITENS

				if lBlock .and. oPedido["status"] == "L"
					oPedido["status"] := "B" // CASO TENHA GERADO PEDIDO COM BLOQUEIO
				elseif oPedido["status"] <> "C"
					// LIBERADO
					if lFaturado
						oPedido["status"] := "F" // FATURADO - ENCERRADO
					elseif lRoteiriza
						oPedido["status"] := "R" // ROTEIRIZADO - AGUARDANDO FATURAMENTO
					endif
				endif

				if lBlockIten
					oBloqueio 				:= nil
					oBloqueio				:= jsonObject():new()
					oBloqueio["codigo"]		:= allTrim( "000000" )
					oBloqueio["descricao"]	:= "Item do Pedido Bloqueado"

					aadd( oPedido["bloqueios"] , oBloqueio )

					freeObj( oBloqueio )
				endif

//-------------------------- Dados do Remetente ----------------------------------------------------------------------------------
				oRemetente 						:= nil
				oRemetente						:= jsonObject():new()
				oRemetente["cnpj"]				:= alltrim(SM0->M0_CGC)
				oRemetente["exterior"]			:= "False"
				oRemetente["email"]				:= getmv("MGF_EREMET")
				oRemetente["nomeFantasia"]		:= alltrim(SM0->M0_FILIAL)
				oRemetente["rgIe"]				:= alltrim(SM0->M0_INSC)
				oRemetente["razaoSocial"]		:= alltrim(SM0->M0_NOMECOM)
				oRemetente["tipoPessoa"]		:= "Juridica"
				oPedido["remetente"]			:= oRemetente

//-------------------------- Dados do Endereço do Remetente -------------------------------------------------------------------------
				oEndereco 						:=	nil
				oEndereco						:=	jsonObject():new()
				oEndereco["bairro"]				:=	alltrim(SM0->M0_BAIRENT)
				oEndereco["cep"]				:=	alltrim(SM0->M0_CEPENT)
				oEndereco["complemento"]		:=	alltrim(SM0->M0_COMPENT)
				oEndereco["logradouro"]			:=	alltrim(SM0->M0_ENDENT)
				oEndereco["ddd"]				:=	000
				oEndereco["telefone"]			:= 	iif(EMPTY(SM0->M0_TEL),"99999999",alltrim(SM0->M0_TEL))
				oEndereco["cidade"]				:=	alltrim(SM0->M0_CIDCOB)
				oEndereco["ibge"]				:=	VAL(SM0->M0_CODMUN)
				oEndereco["nomePais"]			:=	POSICIONE("SYA",1,XFILIAL("SYA")+ "105","YA_DESCR" )
				oEndereco["idPais"]				:=  "01058" //POSICIONE("SYA",1,XFILIAL("SYA")+ "105","YA_SISEXP" )
				oRemetente["endereco"]			:= oEndereco

				if cOrigemPV == "005" .and. cCallback == "S"
					cHTTPMetho	:= "POST"
				else
					cHTTPMetho	:= "PUT"
				endif

				aadd( aSalesOrde , oPedido )

				cJson := ""
				cJson := fwJsonSerialize( aSalesOrde , .T. , .T. )  //Serializar o array de Json

				//cJson := ""
				//cJson := oPedido:toJson()

				freeObj( oPedido )
			enddo // LAÇO DO ARRAY

			cSC5Recnos	:= left( cSC5Recnos , len( cSC5Recnos ) - 1 )
			cZC5Recnos	:= left( cZC5Recnos , len( cZC5Recnos ) - 1 )
			cHeaderRet	:= ""
			cHttpRet	:= ""
			cIdInteg	:= fwUUIDv4( .T. )
			aHeadStr	:= {}

			aadd( aHeadStr , 'Content-Type: application/json'							)
			aadd( aHeadStr , 'origem-criacao: ' + getZF5( cOrigemPV )					) // ver flag de origem do pedido
			aadd( aHeadStr , 'origem-alteracao: protheus'								)
			aadd( aHeadStr , 'x-marfrig-client-id: ' + cIDMgf							)
			aadd( aHeadStr , 'x-correlation-id: ' + cIdInteg							)
			aadd( aHeadStr , 'callback: ' + iif( cCallback == 'S' , 'true' , 'false' )	)

			cTimeIni	:= time()
			cHttpRet	:= httpQuote( cURLUse /*<cUrl>*/, cHTTPMetho /*<cMethod>*/, /*[cGETParms]*/, cJson /*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadStr /*[aHeadStr]*/, cHeaderRet /*[@cHeaderRet]*/ )
			cTimeFin	:= time()
			cTimeProc	:= elapTime( cTimeIni , cTimeFin )
			nStatuHttp	:= 0
			nStatuHttp	:= httpGetStatus()
			If lTms
				conout(" [TMS] [MGFFATBO] * * * * * Status da integracao TMS * * * * *"									)
				conout(" [TMS] [MGFFATBO] Inicio.......................: " + cTimeIni + " - " + dToC( dDataBase )	)
				conout(" [TMS] [MGFFATBO] Fim..........................: " + cTimeFin + " - " + dToC( dDataBase )	)
				conout(" [TMS] [MGFFATBO] Tempo de Processamento.......: " + cTimeProc 								)
				conout(" [TMS] [MGFFATBO] URL..........................: " + cURLUse 								)
				conout(" [TMS] [MGFFATBO] HTTP Method..................: " + cHTTPMetho								)
				conout(" [TMS] [MGFFATBO] Status Http (200 a 299 ok)...: " + allTrim( str( nStatuHttp ) ) 			)
				conout(" [TMS] [MGFFATBO] Envio Headers................: " + varInfo( "aHeadStr" , aHeadStr ) 		)
				conout(" [TMS] [MGFFATBO] Envio Body...................: " + cJson 									)
				conout(" [TMS] [MGFFATBO] Retorno......................: " + cHttpRet 								)
				conout(" [TMS] [MGFFATBO] * * * * * * * * * * * * * * * * * * * * "									)
			Else
				conout(" [SALESFORCE] [MGFFATBO] * * * * * Status da integracao * * * * *"									)
				conout(" [SALESFORCE] [MGFFATBO] Inicio.......................: " + cTimeIni + " - " + dToC( dDataBase )	)
				conout(" [SALESFORCE] [MGFFATBO] Fim..........................: " + cTimeFin + " - " + dToC( dDataBase )	)
				conout(" [SALESFORCE] [MGFFATBO] Tempo de Processamento.......: " + cTimeProc 								)
				conout(" [SALESFORCE] [MGFFATBO] URL..........................: " + cURLUse 								)
				conout(" [SALESFORCE] [MGFFATBO] HTTP Method..................: " + cHTTPMetho								)
				conout(" [SALESFORCE] [MGFFATBO] Status Http (200 a 299 ok)...: " + allTrim( str( nStatuHttp ) ) 			)
				conout(" [SALESFORCE] [MGFFATBO] Envio Headers................: " + varInfo( "aHeadStr" , aHeadStr ) 		)
				conout(" [SALESFORCE] [MGFFATBO] Envio Body...................: " + cJson 									)
				conout(" [SALESFORCE] [MGFFATBO] Retorno......................: " + cHttpRet 								)
				conout(" [SALESFORCE] [MGFFATBO] * * * * * * * * * * * * * * * * * * * * "									)
			EndIf

			BEGIN TRANSACTION

			if nStatuHttp >= 200 .and. nStatuHttp <= 299


				//****************************************
				// Atualiza SC5 - Pedidos gerados
				//****************************************
				if !empty( cSC5Recnos )
					cUpdTbl	:= ""
					cUpdTbl := "UPDATE " + retSQLName("SC5")							+ CRLF
					cUpdTbl += "	SET"												+ CRLF
					if lTms
						If Empty(cZTMSACA)
							cUpdTbl += " C5_ZTMSACA	=	'I',"
						ElseIf cZTMSACA = 'I'
							cUpdTbl += " C5_ZTMSACA	=	'A',"
						Endif
						cUpdTbl += " C5_ZTMSERR  =    ' ',"
						cUpdTbl += " C5_ZTMSINT  =    'S',"
					else
						cUpdTbl += " C5_XINTEGR	=	'I',"
					endif

					if cCallback == 'S'
						cUpdTbl += " C5_XCALLBA	=	'N',"
					endif

					cUpdTbl := left( cUpdTbl , len( cUpdTbl ) - 1 ) // REMOVE A VIRGULA

					cUpdTbl += " WHERE"													+ CRLF
					cUpdTbl += " 		R_E_C_N_O_	IN	(" + cSC5Recnos + ")"			+ CRLF
					cUpdTbl += " 	AND	C5_FILIAL	=	'" + xFilial( "SC5" ) + "'"		+ CRLF

					if tcSQLExec( cUpdTbl ) < 0
						U_MFCONOUT( "Não foi possível executar UPDATE." + CRLF + tcSqlError() )
					endif

				endif

				//****************************************
				// Atualiza ZC5 - Pedidos com Erro
				//****************************************
				if !empty( cZC5Recnos )
					cUpdTbl	:= ""
					cUpdTbl := "UPDATE " + retSQLName("ZC5")							+ CRLF
					cUpdTbl += "	SET"												+ CRLF
					cUpdTbl += " 		ZC5_INTEGR	=	'I'"							+ CRLF
					cUpdTbl += " WHERE"													+ CRLF
					cUpdTbl += " 		R_E_C_N_O_	IN	(" + cZC5Recnos + ")"			+ CRLF
					cUpdTbl += " 	AND	ZC5_FILIAL	=	'" + xFilial( "ZC5" ) + "'"		+ CRLF

					if tcSQLExec( cUpdTbl ) < 0
						U_MFCONOUT( "Não foi possível executar UPDATE." + CRLF + tcSqlError() )
					endif
				endif

				cStaLog := "1"		// Sucesso

				IF lTms
					MemoWrite( "C:\TEMP\TMSPI_MS_"+cC5Num+".TXT",cJson)
				ENDIF

				If lTms
					MsgAlert("Integracao TMS Multisoftwsre realizada com sucesso !!!","TMS Multisoftware")
				endif

			else
				cStaLog		:= "2"	// Erro
				cErroLog	:= cHttpRet
				cTamErro 	:= 100
				if lTms
					cUpdTbl	:= ""
					cUpdTbl := "UPDATE " + retSQLName("SC5")							+ CRLF
					cUpdTbl += "	SET"												+ CRLF
					cupdTbl += "    C5_ZTMSERR = '"+SUBSTR(cErroLog,1,cTamErro)+"'"		+ CRLF
					cUpdTbl += " WHERE"													+ CRLF
					cUpdTbl += " 	R_E_C_N_O_ IN (" + cSC5Recnos + ")"					+ CRLF
					cUpdTbl += " 	AND	D_E_L_E_T_	<>	'*'"							+ CRLF
					cUpdTbl += " 	AND	C5_FILIAL	=	'" + xFilial( "SC5" ) + "'"		+ CRLF
					if tcSQLExec( cUpdTbl ) < 0
						U_MFCONOUT( "Não foi possível executar UPDATE." + CRLF + tcSqlError() )
					endif
				EndIf
			endif

			cHeadHttp := ""

			for nI := 1 to len( aHeadStr )
				cHeadHttp += aHeadStr[ nI ]
			next

			ZHW->(Dbsetorder(1))

			for nI := 1 to len( aSalesOrde )
			
				//GRAVAR LOG
				U_MGFMONITOR(																													 ;
				cFilAnt																			/* Filial */									,;
				cStaLog																			/* Status - 1-Suceso / 2-Erro*/					,;
				cCodInteg																		/* Integração */								,;
				cCodTpInt																		/* Tipo de integração */						,;
				iif( empty( cErroLog ) , "Processamento realizado com sucesso!" , cErroLog )	/*cErro*/										,;
				aSalesOrde[ nI ]["numeroPedidoERP"] 											/*cDocori*/										,;
				cTimeProc																		/* Tempo de processamento */					,;
				aSalesOrde[ nI ]:toJson()														/* JSON */										,;
				aSalesOrde[ nI ]["RECNO"]														/* RECNO do registro */							,;
				cValToChar( nStatuHttp )														/* Status HTTP Retornado */						,;
				.F.																				/* Se precisar preparar ambiente enviar .T. */	,;
				{}																				/* Filial para preparar ambiente */				,;
				aSalesOrde[ nI ]["UID"]															/* UUID */	     								,;
				iif( type( cHttpRet ) <> "U", cHttpRet, " ")									/* JSON de RETORNO */							,;
				"A"																				/*cTipWsInt*/									,;
				fwJsonSerialize( aSalesOrde , .T. , .T. )										/*cJsonCB Z1_JSONCB*/							,;
				" "																				/*cJsonRB Z1_JSONRB*/							,;
				sTod("    /  /  ")																/*dDTCallb Z1_DTCALLB*/							,;
				" "																				/*cHoraCall Z1_HRCALLB*/						,;
				" "																				/*cCallBac Z1_CALLBAC*/							,;
				cURLUse																			/*cLinkEnv Z1_LINKENV*/							,;
				" "																				/*cLinkRec Z1_LINKREC*/							,;
				cIdInteg																		/*cHeaderID		Z1_HEADEID*/					,;
				cHeadHttp																		/*cHeadeHttp	Z1_HEADER*/						)
			
				//Atualiza ZHW				

				If !empty(alltrim(aSalesOrde[ nI ]["numeroPedidoERP"])) .and.;
							ZHW->(Dbseek(cfilant+alltrim(aSalesOrde[ nI ]["numeroPedidoERP"]))) 

					_cjsones := aSalesOrde[ nI ]:toJson()
					_cjsonts := fwJsonSerialize( aSalesOrde , .T. , .T. )


					ZHW->(Dbsetorder(1))

					If ZHW->(Dbseek(cFilAnt+alltrim(aSalesOrde[ nI ]["numeroPedidoERP"] ))) 

						If ZHW->(MsRLock(ZHW->(RECNO())))
						
							Reclock("ZHW",.F.)
							ZHW->ZHW_JSONES := _cjsones
							ZHW->ZHW_JSONTS := _cjsonts
							ZHW->ZHW_JSONRS := iif( type( cHttpRet ) <> "U", cHttpRet, " ")
	
							//Controle para envio duplo
							If ZHW->ZHW_STATUS == 1
								ZHW->ZHW_STATUS := nStatuHttp
							Else
								ZHW->ZHW_STATUS := 1
							Endif
	
							ZHW->ZHW_DATAES := Date()
							ZHW->ZHW_HORAES := time()
							ZHW->(Msunlock())

						Endif

					Endif

				Endif		
			
			next

			END TRANSACTION

			U_MFCONOUT("[MGFFATBO] Enviou retorno de " + strzero(len( aSalesOrde ),6) + " pedidos!")
		enddo

		(cQrySalesO)->(DBCloseArea())

		delClassINTF()
	END SEQUENCE

return

//-------------------------------------------------------------------------------------
// QUERY DE PEDIDOS
//-------------------------------------------------------------------------------------
static function getSalesOr()
	local cQrySC5	:= ""

	cQrySalesO	:= ""
	cQrySalesO	:= GetNextAlias()

	cQrySC5 += " SELECT"																						+ chr(13) + chr(10)
	cQrySC5 += " 	'S' PEDIDO						, C5_ZROAD ,"												+ chr(13) + chr(10)
	cQrySC5 += " 	SUBSTR(UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(C5_XOBSPED,2000,1)),1,4000) C5_XOBSPED	,"	+ chr(13) + chr(10)
	cQrySC5 += " 	SC5.R_E_C_N_O_	XC5RECNO,"																	+ chr(13) + chr(10)
	cQrySC5 += " 	C5_FILIAL	, C5_ZPEDCLI	, C5_XIDEXTE	,C5_ZIDEND	,"									+ chr(13) + chr(10)
	cQrySC5 += " 	C5_NUM		, C5_ZTIPPED	, C5_VEND1		,C5_XRESERV	,"									+ chr(13) + chr(10)
	cQrySC5 += " 	C5_CONDPAG	, C5_TABELA		, C5_FECENT		,"												+ chr(13) + chr(10)
	cQrySC5 += " 	C5_XORCAME	, C5_XREDE		, C5_XPVPAI		, C5_ZDTEMBA, "									+ chr(13) + chr(10)

	If lTms
		cQrySc5 += "    C5_XVLDESC  , C5_PBRUTO 	, C5_PESOL		, C5_TPFRETE, C5_ZDTEMBA	, C5_ZTMSACA,"	+ chr(13) + chr(10)
		cQrySc5 += "	C5_ZTMSID	, C5_XACONDC	, C5_ZNUMEXP	, C5_XTPROD	, C5_ZBLQRGA	,"				+ chr(13) + chr(10)		
		IF SC5->C5_TIPO $ ("D/B")
			cQrySc5 += "	A2_TIPO		, A2_COD_MUN	, A2_CODPAIS,"												+ chr(13) + chr(10)
			cQrySC5 += " 	A2_PAIS		, A2_NREDUZ		, A2_INSCR		, A2_NOME 	,"								+ chr(13) + chr(10)
			cQrySC5 += " 	A2_BAIRRO	, A2_COMPLEM	, A2_DDD		, A2_TEL	,"								+ chr(13) + chr(10)
			cQrySC5 += " 	A2_MUN		, A2_CEP		, A2_END		 			,"								+ chr(13) + chr(10)
		ELSE
			cQrySc5 += "	A1_TIPO		, A1_PESSOA		, A1_COD_MUN	, A1_CODPAIS,"								+ chr(13) + chr(10)
			cQrySC5 += " 	A1_PAIS		, A1_NREDUZ		, A1_INSCR		, A1_NOME 	,"								+ chr(13) + chr(10)
			cQrySC5 += " 	A1_BAIRRO	, A1_COMPLEM	, A1_DDD		, A1_TEL	,"								+ chr(13) + chr(10)
			cQrySC5 += " 	A1_MUN		, A1_CEP		, A1_END		 			,"								+ chr(13) + chr(10)
		ENDIF
	ELSE
		cQrySc5 += "	SA1.A1_TIPO		, SA1.A1_PESSOA		, SA1.A1_COD_MUN	, SA1.A1_CODPAIS,"								+ chr(13) + chr(10)
		cQrySC5 += " 	SA1.A1_PAIS		, SA1.A1_NREDUZ		, SA1.A1_INSCR		, SA1.A1_NOME 	,"								+ chr(13) + chr(10)
		cQrySC5 += " 	SA1.A1_BAIRRO	, SA1.A1_COMPLEM	, SA1.A1_DDD		, SA1.A1_TEL	,"								+ chr(13) + chr(10)
		cQrySC5 += " 	SA1.A1_MUN		, SA1.A1_CEP		, SA1.A1_END		 			,"
	EndIf

	cQrySC5 += " 	C6_ITEM		, C6_PRODUTO	, C6_QTDVEN		, C6_PRCVEN,"									+ chr(13) + chr(10)
	cQrySC5 += " 	C6_ZDTMAX	, C6_ZDTMIN		, "																+ chr(13) + chr(10)
	
	If lTms
		IF SC5->C5_TIPO $ ("D/B")	
			cQrySC5 += " 	A2_COD		, A2_LOJA		, A2_CGC		,"												+ chr(13) + chr(10)
			cQrySC5 += "	NVL(SZ9.Z9_ZCEP		, SA2.A2_CEP)  CEP			,"											+ chr(13) + chr(10)
			cQrySC5 += "	NVL(SZ9.Z9_ZENDER	, SA2.A2_END)  ENDERECO		,"											+ chr(13) + chr(10)
			cQrySC5 += "	NVL(SZ9.Z9_ZEST		, SA2.A2_EST)  ESTADO		,"											+ chr(13) + chr(10)
			cQrySC5 += "	NVL(SZ9.Z9_ZMUNIC	, SA2.A2_MUN)  MUNICIPIO	,"											+ chr(13) + chr(10)
			cQrySC5 += "	SC5.D_E_L_E_T_ EXCLUIDO ,"
		ELSE
			cQrySC5 += " 	A1_COD		, A1_LOJA		, A1_CGC		,"												+ chr(13) + chr(10)
			cQrySC5 += "	NVL(SZ9.Z9_ZCEP		, SA1.A1_CEP)  CEP			,"											+ chr(13) + chr(10)
			cQrySC5 += "	NVL(SZ9.Z9_ZENDER	, SA1.A1_END)  ENDERECO		,"											+ chr(13) + chr(10)
			cQrySC5 += "	NVL(SZ9.Z9_ZEST		, SA1.A1_EST)  ESTADO		,"											+ chr(13) + chr(10)
			cQrySC5 += "	NVL(SZ9.Z9_ZMUNIC	, SA1.A1_MUN)  MUNICIPIO	,"											+ chr(13) + chr(10)
			cQrySC5 += "	SC5.D_E_L_E_T_ EXCLUIDO ,"
		ENDIF
	ELSE
		cQrySC5 += " 	SA1.A1_COD		, SA1.A1_LOJA		, SA1.A1_CGC		,"												+ chr(13) + chr(10)
		cQrySC5 += "	NVL(SZ9.Z9_ZCEP		, SA1.A1_CEP)  CEP			,"											+ chr(13) + chr(10)
		cQrySC5 += "	NVL(SZ9.Z9_ZENDER	, SA1.A1_END)  ENDERECO		,"											+ chr(13) + chr(10)
		cQrySC5 += "	NVL(SZ9.Z9_ZEST		, SA1.A1_EST)  ESTADO		,"											+ chr(13) + chr(10)
		cQrySC5 += "	NVL(SZ9.Z9_ZMUNIC	, SA1.A1_MUN)  MUNICIPIO	,"											+ chr(13) + chr(10)
		cQrySC5 += "	SC5.D_E_L_E_T_ EXCLUIDO ,"
	ENDIF
	
	If lTms
		If SC5->C5_TIPO $ ("D/B")	
			cQrySC5 += "	NVL(SZ9.Z9_ZBAIRRO	, SA2.A2_BAIRRO)  BAIRRO	,"											+ chr(13) + chr(10)
			cQrySC5 += "	NVL(SZ9.Z9_ZCOMPLE	, SA2.A2_COMPLEM) COMPLEMEN	,"											+ chr(13) + chr(10)
			cQrySC5 += "	NVL(SZ9.Z9_ZDDD		, SA2.A2_DDD)  DDDZ9		,"											+ chr(13) + chr(10)
			cQrySC5 += "	NVL(SZ9.Z9_ZTEL		, SA2.A2_TEL)  TELEFONE		,"											+ chr(13) + chr(10)
			cQrySC5 += "	NVL(SZ9.Z9_ZCODMUN	, SA2.A2_COD_MUN)  CODMUNIC	,"											+ chr(13) + chr(10)
		Else
			cQrySC5 += "	NVL(SZ9.Z9_ZBAIRRO	, SA1.A1_BAIRRO)  BAIRRO	,"											+ chr(13) + chr(10)
			cQrySC5 += "	NVL(SZ9.Z9_ZCOMPLE	, SA1.A1_COMPLEM) COMPLEMEN	,"											+ chr(13) + chr(10)
			cQrySC5 += "	NVL(SZ9.Z9_ZDDD		, SA1.A1_DDD)  DDDZ9		,"											+ chr(13) + chr(10)
			cQrySC5 += "	NVL(SZ9.Z9_ZTEL		, SA1.A1_TEL)  TELEFONE		,"											+ chr(13) + chr(10)
			cQrySC5 += "	NVL(SZ9.Z9_ZCODMUN	, SA1.A1_COD_MUN)  CODMUNIC	,"											+ chr(13) + chr(10)
		endif
	Else
		cQrySC5 += "	NVL(SZ9.Z9_ZBAIRRO	, SA1.A1_BAIRRO)  BAIRRO	,"											+ chr(13) + chr(10)
		cQrySC5 += "	NVL(SZ9.Z9_ZCOMPLE	, SA1.A1_COMPLEM) COMPLEMEN	,"											+ chr(13) + chr(10)
		cQrySC5 += "	NVL(SZ9.Z9_ZDDD		, SA1.A1_DDD)  DDDZ9		,"											+ chr(13) + chr(10)
		cQrySC5 += "	NVL(SZ9.Z9_ZTEL		, SA1.A1_TEL)  TELEFONE		,"											+ chr(13) + chr(10)
		cQrySC5 += "	NVL(SZ9.Z9_ZCODMUN	, SA1.A1_COD_MUN)  CODMUNIC	,"											+ chr(13) + chr(10)
	endif

	cQrySC5 += "	CASE"																						+ chr(13) + chr(10)
	cQrySC5 += "		WHEN SC6.D_E_L_E_T_ = '*' THEN 2"														+ chr(13) + chr(10)
	cQrySC5 += "	ELSE"																						+ chr(13) + chr(10)
	cQrySC5 += "		1"																						+ chr(13) + chr(10)
	cQrySC5 += "	END    C6DELET,"																			+ chr(13) + chr(10)

	cQrySC5 += "		("																						+ chr(13) + chr(10)
	cQrySC5 += " 			SELECT B1_DESC"																		+ chr(13) + chr(10)
	cQrySC5 += " 			FROM " + retSQLName("SB1") + " SUBSB1"												+ chr(13) + chr(10)
	cQrySC5 += " 			WHERE"																				+ chr(13) + chr(10)
	cQrySC5 += "				SUBSB1.B1_COD		=	SC6.C6_PRODUTO"											+ chr(13) + chr(10)
	cQrySC5 += "			AND	SUBSB1.B1_FILIAL	=	'" + xFilial("SB1") + "'"								+ chr(13) + chr(10)
	cQrySC5 += "			AND	SUBSB1.D_E_L_E_T_	<>	'*'"													+ chr(13) + chr(10)
	cQrySC5 += " 		) DESCPROD , C5_XCALLBA , C5_XORIGEM,"													+ chr(13) + chr(10)
	cQrySC5 += " 	' ' ZC5_OBS	,"																				+ chr(13) + chr(10)
	cQrySC5 += " 	C5_EMISSAO	,"																				+ chr(13) + chr(10)
	cQrySC5 += " 	NVL( D2_QUANT	, 0 ) D2_QUANT		,"														+ chr(13) + chr(10)
	cQrySC5 += " 	NVL( D2_DOC		, '' ) D2_DOC		,"														+ chr(13) + chr(10)
	cQrySC5 += " 	NVL( C5_MENNOTA , '' ) C5_MENNOTA	,"														+ chr(13) + chr(10)
	cQrySC5 += " 	NVL( C6_NUMPCOM , '' ) C6_NUMPCOM	"														+ chr(13) + chr(10)
	cQrySC5 += " FROM "			+ retSQLName("SC5") + " SC5"													+ chr(13) + chr(10)
	cQrySC5 += " INNER JOIN " 	+ retSQLName("SC6") + " SC6"													+ chr(13) + chr(10)
	cQrySC5 += " ON"																							+ chr(13) + chr(10)
	cQrySC5 += " 		SC6.C6_NUM		=	SC5.C5_NUM"															+ chr(13) + chr(10)
	cQrySC5 += " 	AND	SC6.C6_FILIAL	=	SC5.C5_FILIAL"														+ chr(13) + chr(10)
	
	If lTms
		cQrySC5 += " 	AND	SC6.D_E_L_E_T_	<>	'*'"															+ chr(13) + chr(10)
	Endif

	If lTms
		If SC5->C5_TIPO $ ("D/B")		
			cQrySC5 += " INNER JOIN "	+ retSQLName("SA2") + " SA2"													+ chr(13) + chr(10)
			cQrySC5 += " ON"																							+ chr(13) + chr(10)
			cQrySC5 += " 		SA2.A2_LOJA		=	SC5.C5_LOJACLI"														+ chr(13) + chr(10)
			cQrySC5 += " 	AND	SA2.A2_COD		=	SC5.C5_CLIENTE"														+ chr(13) + chr(10)
			cQrySC5 += " 	AND	SA2.A2_FILIAL	=	'" + xFilial("SA2") + "'"											+ chr(13) + chr(10)
			cQrySC5 += " 	AND	SA2.D_E_L_E_T_	<>	'*'"																+ chr(13) + chr(10)
			cQrySC5 += " 	AND	SA2.A2_EST		<>	'EX'"							       								+ chr(13) + chr(10)
			cQrySC5 += " 	AND	SA2.A2_CGC		<>	' '"																+ chr(13) + chr(10)
		Else
			cQrySC5 += " INNER JOIN "	+ retSQLName("SA1") + " SA1"													+ chr(13) + chr(10)
			cQrySC5 += " ON"																							+ chr(13) + chr(10)
			cQrySC5 += " 		SA1.A1_LOJA		=	SC5.C5_LOJACLI"														+ chr(13) + chr(10)
			cQrySC5 += " 	AND	SA1.A1_COD		=	SC5.C5_CLIENTE"														+ chr(13) + chr(10)
			cQrySC5 += " 	AND	SA1.A1_FILIAL	=	'" + xFilial("SA1") + "'"											+ chr(13) + chr(10)
			cQrySC5 += " 	AND	SA1.D_E_L_E_T_	<>	'*'"																+ chr(13) + chr(10)
			cQrySC5 += " 	AND	SA1.A1_EST		<>	'EX'"							       								+ chr(13) + chr(10)
			cQrySC5 += " 	AND	SA1.A1_CGC		<>	' '"																+ chr(13) + chr(10)
		endif
	Else
		cQrySC5 += " INNER JOIN "	+ retSQLName("SA1") + " SA1"													+ chr(13) + chr(10)
		cQrySC5 += " ON"																							+ chr(13) + chr(10)
		cQrySC5 += " 		SA1.A1_LOJA		=	SC5.C5_LOJACLI"														+ chr(13) + chr(10)
		cQrySC5 += " 	AND	SA1.A1_COD		=	SC5.C5_CLIENTE"														+ chr(13) + chr(10)
		cQrySC5 += " 	AND	SA1.A1_FILIAL	=	'" + xFilial("SA1") + "'"											+ chr(13) + chr(10)
		cQrySC5 += " 	AND	SA1.D_E_L_E_T_	<>	'*'"																+ chr(13) + chr(10)
		cQrySC5 += " 	AND	SA1.A1_EST		<>	'EX'"							       								+ chr(13) + chr(10)
		cQrySC5 += " 	AND	SA1.A1_CGC		<>	' '"																+ chr(13) + chr(10)
	endif

	cQrySC5 += " LEFT JOIN "	+ retSQLName("SZ9") + " SZ9"													+ chr(13) + chr(10)
	cQrySC5 += " ON"																							+ chr(13) + chr(10)
	cQrySC5 += "         SZ9.Z9_ZIDEND	=	SC5.C5_ZIDEND"														+ chr(13) + chr(10)

	If lTms
		If SC5->C5_TIPO $ ("D/B")		
			cQrySC5 += "     AND SZ9.Z9_ZCGC	=	SA2.A2_CGC"															+ chr(13) + chr(10)
		ELSE
			cQrySC5 += "     AND SZ9.Z9_ZCGC	=	SA1.A1_CGC"															+ chr(13) + chr(10)
		ENDIF
	ELSE
		cQrySC5 += "     AND SZ9.Z9_ZCGC	=	SA1.A1_CGC"															+ chr(13) + chr(10)
	ENDIF

	cQrySC5 += "     AND SZ9.Z9_FILIAL	=	'" + xFilial("SZ9") + "'"											+ chr(13) + chr(10)
	cQrySC5 += "     AND SZ9.D_E_L_E_T_	<>	'*'"																+ chr(13) + chr(10)

	cQrySC5 += " LEFT JOIN " + retSQLName("SD2") + " SD2" 														+  chr(13) + chr(10)
	cQrySC5 += " ON" 																							+  chr(13) + chr(10)
	cQrySC5 += "  	    SD2.D2_PEDIDO	=	SC5.C5_NUM" 														+  chr(13) + chr(10)
	cQrySC5 += "	AND SD2.D2_ITEMPV	=	SC6.C6_ITEM" 														+  chr(13) + chr(10)
	cQrySC5 += "	AND SD2.D2_FILIAL	=	'" + xFilial("SD2") + "'" 											+  chr(13) + chr(10)
	cQrySC5 += "	AND SD2.D_E_L_E_T_	=	' '" 																+  chr(13) + chr(10)

	cQrySC5 += " WHERE"																							+ chr(13) + chr(10)

	If lTms // Pedidos que vao ser considerados pelo Multisoftware
		cQrySC5 += "  SC5.C5_NUM		='"	+SC5->C5_NUM+"' AND "												+ chr(13) + chr(10)
	else
		
		cQrySC5 += " EXISTS (select ZHW_PEDIDO from " + retSQLName("ZHW") + " ZHW where ZHW.d_e_l_e_t_ <> '*' "     +  chr(13) + chr(10)
		cQrySC5 += "		AND ZHW.ZHW_DATAET = '" + DTOS(DATE()) + "' AND "    									+  chr(13) + chr(10)
		cQrySC5 += "		(ZHW.ZHW_STATUT = '200' or ZHW.ZHW_STATUT = '999' or ZHW.ZHW_STATUT = '998') " 			+  chr(13) + chr(10)
		cQrySC5 += "		AND (ZHW.ZHW_STATUS = 0 OR ZHW.ZHW_STATUS = 1) "  										+  chr(13) + chr(10) 
		cQrySC5 += "		AND ZHW.ZHW_FILIAL = SC5.C5_FILIAL AND ZHW.ZHW_PEDIDO = SC5.C5_NUM ) AND " 				+  chr(13) + chr(10)

		cQrySC5 += " 	SC5.C5_EMISSAO	>=	'" + dtos(date()-getmv("MGF_FAT541",,10))	+ "' AND "					+ chr(13) + chr(10)
	EndIf

	cQrySC5 += " 	SC5.C5_FILIAL	=	'" + xFilial( "SC5" ) + "'"											+ chr(13) + chr(10)

	If ! lTms //cFilAnt $GetMv("MGF_TMSGER") // Pedidos que vao ser considerados pelo Multisoftware
		cQrySC5 += " UNION ALL"																						+ chr(13) + chr(10)

	// PEDIDOS COM ERRO

		cQrySC5 += " SELECT DISTINCT"																				+ chr(13) + chr(10)
		cQrySC5 += " 	'N' PEDIDO	, '' C5_ZROAD,"																	+ chr(13) + chr(10)
		cQrySC5 += " 	' ' C5_XOBSPED			,"																	+ chr(13) + chr(10)
		cQrySC5 += "	ZC5.R_E_C_N_O_ XC5RECNO	,"																	+ chr(13) + chr(10)
		cQrySC5 += "	ZC5_FILIAL	C5_FILIAL	,"																	+ chr(13) + chr(10)
		cQrySC5 += "	ZC5_PEDCLI				,"																	+ chr(13) + chr(10)
		cQrySC5 += "	ZC5_IDEXTE				,"																	+ chr(13) + chr(10)
		cQrySC5 += "	ZC5_ZIDEND				,"																	+ chr(13) + chr(10)
		cQrySC5 += "	' ' C5_NUM				,"																	+ chr(13) + chr(10)
		cQrySC5 += "	ZC5_ZTIPPE				,"																	+ chr(13) + chr(10)
		cQrySC5 += "	ZC5_VENDED				,"																	+ chr(13) + chr(10)
		cQrySC5 += "	ZC5_RESERV				,"																	+ chr(13) + chr(10)
		cQrySC5 += "	ZC5_CODCON				,"																	+ chr(13) + chr(10)
		cQrySC5 += "	ZC5_CODTAB				,"																	+ chr(13) + chr(10)
		cQrySC5 += "	ZC5_DTENTR				,"																	+ chr(13) + chr(10)
		cQrySC5 += "	ZC5_ORCAME				,"																	+ chr(13) + chr(10)
		cQrySC5 += "	ZC5_PVREDE				,"																	+ chr(13) + chr(10)
		cQrySC5 += "	ZC5_PVPAI				,"																	+ chr(13) + chr(10)
		cQrySC5 += "	ZC5_DTEMBA				,"																	+ chr(13) + chr(10)
		cQrySC5 += "	'N' C5_TIPO				,"																	+ chr(13) + chr(10)

		cQrySC5 += "	' ' A1_PESSOA			,"																	+ chr(13) + chr(10)
		cQrySC5 += "	' ' A1_COD_MUN			,"																	+ chr(13) + chr(10)
		cQrySC5 += "	' ' A1_CODPAIS			,"																	+ chr(13) + chr(10)
		cQrySC5 += "	' ' A1_PAIS				,"																	+ chr(13) + chr(10)
		cQrySC5 += "	' ' A1_NREDUZ			,"																	+ chr(13) + chr(10)
		cQrySC5 += "	' ' A1_INSCR			,"																	+ chr(13) + chr(10)
		cQrySC5 += "	' ' A1_NOME				,"																	+ chr(13) + chr(10)
		cQrySC5 += "	' ' A1_BAIRRO			,"																	+ chr(13) + chr(10)
		cQrySC5 += "	' ' A1_COMPLEM			,"																	+ chr(13) + chr(10)
		cQrySC5 += "	' ' A1_DDD				,"																	+ chr(13) + chr(10)
		cQrySC5 += "	' ' A1_TEL				,"																	+ chr(13) + chr(10)
		cQrySC5 += "	' ' A1_MUN				,"																	+ chr(13) + chr(10)
		cQrySC5 += "	' ' A1_CEP				,"																	+ chr(13) + chr(10)
		cQrySC5 += "	' ' A1_END				,"																	+ chr(13) + chr(10)

		cQrySC5 += "	ZC6_ITEM				,"																	+ chr(13) + chr(10)
		cQrySC5 += "	ZC6_PRODUT				,"																	+ chr(13) + chr(10)
		cQrySC5 += "	ZC6_QTDVEN				,"																	+ chr(13) + chr(10)
		cQrySC5 += "	ZC6_PRCVEN				,"																	+ chr(13) + chr(10)
		cQrySC5 += "	ZC6_DTMAXI				,"																	+ chr(13) + chr(10)
		cQrySC5 += "	ZC6_DTMINI				,"																	+ chr(13) + chr(10)
		cQrySC5 += "	' ' A1_COD				,"																	+ chr(13) + chr(10)
		cQrySC5 += "	' ' A1_LOJA				,"																	+ chr(13) + chr(10)
		cQrySC5 += "	ZC5_CLIENT				,"																	+ chr(13) + chr(10)
		cQrySC5 += "	' ' CEP					,"																	+ chr(13) + chr(10)
		cQrySC5 += "	' ' ENDERECO			,"																	+ chr(13) + chr(10)
		cQrySC5 += "	' ' ESTADO				,"																	+ chr(13) + chr(10)
		cQrySC5 += "	' ' MUNICIPIO			,"																	+ chr(13) + chr(10)
		cQrySC5 += "	ZC5.D_E_L_E_T_ EXCLUIDO	,"																	+ chr(13) + chr(10)
		cQrySC5 += "	' ' BAIRRO				,"																	+ chr(13) + chr(10)
		cQrySC5 += "	' ' COMPLEMEN			,"																	+ chr(13) + chr(10)
		cQrySC5 += "	' ' DDDZ9				,"																	+ chr(13) + chr(10)
		cQrySC5 += "	' ' TELEFONE			,"																	+ chr(13) + chr(10)
		cQrySC5 += "	' ' CODMUNIC			,"																	+ chr(13) + chr(10)

		cQrySC5 += "	1	C6DELET				,"																	+ chr(13) + chr(10)
		cQrySC5 += "	' '	DESCPROD			,"																	+ chr(13) + chr(10)
		cQrySC5 += "	' '	C5_XCALLBA			,"																	+ chr(13) + chr(10)
		cQrySC5 += "	ZC5_ORIGEM				,"																	+ chr(13) + chr(10)
		cQrySC5 += "	SUBSTR(UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(ZC5_OBS,2000,1)),1,4000) ZC5_OBS	,"		+ chr(13) + chr(10)
		cQrySC5 += " 	ZC5_DTRECE C5_EMISSAO	,"																	+ chr(13) + chr(10)
		cQrySC5 += " 	0 D2_QUANT				,"																	+ chr(13) + chr(10)
		cQrySC5 += " 	' ' D2_DOC				,"																	+ chr(13) + chr(10)
		cQrySC5 += " 	ZC5_MSGNOT C5_MENNOTA	,"																	+ chr(13) + chr(10)
		cQrySC5 += " 	' ' C6_NUMPCOM"																				+ chr(13) + chr(10)
		cQrySC5 += " FROM "			+ retSQLName("ZC5") + " ZC5"													+ chr(13) + chr(10)
		cQrySC5 += " INNER JOIN " 	+ retSQLName("ZC6") + " ZC6"													+ chr(13) + chr(10)
		cQrySC5 += " ON"																							+ chr(13) + chr(10)
		cQrySC5 += " 		ZC5.ZC5_IDSFA	=	ZC6.ZC6_IDSFA"														+ chr(13) + chr(10)
		cQrySC5 += " 	AND	ZC5.ZC5_FILIAL	=	ZC6.ZC6_FILIAL"														+ chr(13) + chr(10)
		cQrySC5 += " 	AND	ZC6.D_E_L_E_T_	<>	'*'"																+ chr(13) + chr(10)
		cQrySC5 += " WHERE"																							+ chr(13) + chr(10)
		cQrySC5 += " 		ZC5.ZC5_INTEGR	=	'P' AND ZC5.ZC5_STATUS = '4'"										+ chr(13) + chr(10)
		cQrySC5 += "    AND ZC5.ZC5_DTRECE	>=	'" + dtos(date()-getmv("MGF_FAT541",,10))	+ "'"					+ chr(13) + chr(10)
		cQrySC5 += " 	AND	ZC5.D_E_L_E_T_	<>	'*'"																+ chr(13) + chr(10)
		cQrySC5 += " 	AND	ZC5.ZC5_FILIAL	=	'" + xFilial( "ZC5" ) + "'"
    endif									

	cQrySC5 += " ORDER BY"																						+ chr(13) + chr(10)
	cQrySC5 += " C5_XORIGEM		,"																				+ chr(13) + chr(10)
	cQrySC5 += " C5_XCALLBA		,"																				+ chr(13) + chr(10)
	cQrySC5 += " C5_FILIAL		,"																				+ chr(13) + chr(10)
	cQrySC5 += " C5_NUM			,"																				+ chr(13) + chr(10)
	cQrySC5 += " C6_PRODUTO		,"																				+ chr(13) + chr(10)
	cQrySC5 += " C6DELET"																						+ chr(13) + chr(10)

	dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQrySC5), (cQrySalesO) , .F. , .T. )

return

//-------------------------------------------------------------------------------------
// QUERY DE BLOQUEIOS
//-------------------------------------------------------------------------------------
user function getSZVx( lItens , cC5Filial , cC5Num , cItem )
	local cQrySZV	:= ""

	default lItens	:= .F.
	default cItem	:= ""

	cQrySZVRet	:= ""
	cQrySZVRet	:= GetNextAlias()

	if !lItens
		// BLOQUEIOS DO PEDIDO
		cQrySZV += " SELECT"																		+ chr(13) + chr(10)
		cQrySZV += "		C5_FILIAL	, C5_NUM		, '00' C6_ITEM,"							+ chr(13) + chr(10)
		cQrySZV += "		ZT_TIPO		, ZT_DESCRI		, ZV_CODRGA"								+ chr(13) + chr(10)
		cQrySZV += " FROM "			+ retSQLName("SC5") + " SC5"									+ chr(13) + chr(10)
		cQrySZV += " INNER JOIN "	+ retSQLName("SZV") + " SZV"									+ chr(13) + chr(10)
		cQrySZV += " ON"																			+ chr(13) + chr(10)
		cQrySZV += " 		SZV.ZV_ITEMPED  =   '01'"												+ chr(13) + chr(10)
		cQrySZV += " 	AND SZV.ZV_PEDIDO	=	SC5.C5_NUM"											+ chr(13) + chr(10)
		cQrySZV += " 	AND	SZV.ZV_FILIAL	=	SC5.C5_FILIAL"										+ chr(13) + chr(10)
		cQrySZV += " 	AND	SZV.D_E_L_E_T_	<>	'*'"												+ chr(13) + chr(10)
		cQrySZV += " INNER JOIN "	+ retSQLName("SZT") + " SZT"									+ chr(13) + chr(10)
		cQrySZV += " ON"																			+ chr(13) + chr(10)
		cQrySZV += " 		SZV.ZV_CODRGA	=	SZT.ZT_CODIGO"										+ chr(13) + chr(10)
		cQrySZV += " 	AND SZT.ZT_TIPO		IN	('1', '2')"											+ chr(13) + chr(10) // SOMENTE BLOQUEIOS DO PEDIDO
		cQrySZV += " 	AND	SZT.ZT_FILIAL	=	'" + xFilial("SZT") + "'"							+ chr(13) + chr(10)
		cQrySZV += " 	AND	SZT.D_E_L_E_T_	<>	'*'"												+ chr(13) + chr(10)
		cQrySZV += " WHERE"																			+ chr(13) + chr(10)
		cQrySZV += " 		SZV.ZV_CODAPR	=	' '"												+ chr(13) + chr(10) // BLOQUEIOS AINDA NAO LIBERADOS
		//Não envia bloqueios de aguardando keyconsult, só envia se tiver bloqueio permanente
		cQrySZV += "    AND SZV.ZV_CODRGA <> '000096' "												+ chr(13) + chr(10)
		cQrySZV += "    AND SZV.ZV_CODRGA <> '000097' "												+ chr(13) + chr(10)
		cQrySZV += "    AND SZV.ZV_CODRGA <> '000098' "												+ chr(13) + chr(10)
		cQrySZV += " 	AND	SC5.C5_NUM		=	'" + cC5Num		+ "'"								+ chr(13) + chr(10)
		cQrySZV += " 	AND	SC5.C5_FILIAL	=	'" + cC5Filial	+ "'"								+ chr(13) + chr(10)
		cQrySZV += " 	AND	SC5.D_E_L_E_T_	<>	'*'"												+ chr(13) + chr(10)
	else
		// ZT_TIPO - 1=Pedido de Venda;2=Cliente;3=Produto
		// BLOQUEIOS DO ITENS
		cQrySZV += " SELECT"																		+ chr(13) + chr(10)
		cQrySZV += "		C5_FILIAL	, C5_NUM		, C6_ITEM,"									+ chr(13) + chr(10)
		cQrySZV += "		ZT_TIPO		, ZT_DESCRI		, ZV_CODRGA"								+ chr(13) + chr(10)
		cQrySZV += " FROM "			+ retSQLName("SC5") + " SC5"									+ chr(13) + chr(10)
		cQrySZV += " INNER JOIN " 	+ retSQLName("SC6") + " SC6"									+ chr(13) + chr(10)
		cQrySZV += " ON"																			+ chr(13) + chr(10)
		cQrySZV += " 		SC6.C6_ITEM		=	'" + cItem + "'"									+ chr(13) + chr(10)
		cQrySZV += " 	AND	SC6.C6_NUM		=	SC5.C5_NUM"											+ chr(13) + chr(10)
		cQrySZV += " 	AND	SC6.C6_FILIAL	=	SC5.C5_FILIAL"										+ chr(13) + chr(10)
		cQrySZV += " 	AND	SC6.D_E_L_E_T_	<>	'*'"												+ chr(13) + chr(10)
		cQrySZV += " INNER JOIN "	+ retSQLName("SZV") + " SZV"									+ chr(13) + chr(10)
		cQrySZV += " ON"																			+ chr(13) + chr(10)
		cQrySZV += " 		SZV.ZV_ITEMPED  =   '" + cItem + "'"									+ chr(13) + chr(10)
		cQrySZV += " 	AND SZV.ZV_PEDIDO	=	SC5.C5_NUM"											+ chr(13) + chr(10)
		cQrySZV += " 	AND	SZV.ZV_FILIAL	=	SC5.C5_FILIAL"										+ chr(13) + chr(10)
		cQrySZV += " 	AND	SZV.D_E_L_E_T_	<>	'*'"												+ chr(13) + chr(10)
		cQrySZV += " INNER JOIN "	+ retSQLName("SZT") + " SZT"									+ chr(13) + chr(10)
		cQrySZV += " ON"																			+ chr(13) + chr(10)
		cQrySZV += " 		SZV.ZV_CODRGA	=	SZT.ZT_CODIGO"										+ chr(13) + chr(10)
		cQrySZV += " 	AND SZT.ZT_TIPO		IN	('3')"												+ chr(13) + chr(10) // SOMENTE BLOQUEIOS DOS ITENS
		cQrySZV += " 	AND	SZT.ZT_FILIAL	=	'" + xFilial("SZT") + "'"							+ chr(13) + chr(10)
		cQrySZV += " 	AND	SZT.D_E_L_E_T_	<>	'*'"												+ chr(13) + chr(10)
		cQrySZV += " WHERE"																			+ chr(13) + chr(10)
		cQrySZV += " 		SZV.ZV_CODAPR	=	' '"												+ chr(13) + chr(10) // BLOQUEIOS AINDA NAO LIBERADOS

		//Não envia bloqueios de aguardando keyconsult, só envia se tiver bloqueio permanente
		cQrySZV += "    AND SZV.ZV_CODRGA <> '000096' "												+ chr(13) + chr(10)
		cQrySZV += "    AND SZV.ZV_CODRGA <> '000097' "												+ chr(13) + chr(10)
		cQrySZV += "    AND SZV.ZV_CODRGA <> '000098' "												+ chr(13) + chr(10)

		cQrySZV += " 	AND	SC5.C5_NUM		=	'" + cC5Num		+ "'"								+ chr(13) + chr(10)
		cQrySZV += " 	AND	SC5.C5_FILIAL	=	'" + cC5Filial	+ "'"								+ chr(13) + chr(10)
		cQrySZV += " 	AND	SC5.D_E_L_E_T_	<>	'*'"												+ chr(13) + chr(10)
	endif

	cQrySZV += " ORDER BY C5_FILIAL, C5_NUM, ZT_TIPO, C6_ITEM, ZV_CODRGA"						+ chr(13) + chr(10)

	dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQrySZV), (cQrySZVRet) , .F. , .T. )

return

//--------------------------------------------------------------------
//--------------------------------------------------------------------
static function getZF5( cOrigemPV )
	local cQryZF5		:= ""
	local cRetOrigem	:= ""

	cQryZF5 := "SELECT ZF5_DESCRI"										+ CRLF
	cQryZF5 += " FROM " + retSQLName( "ZF5" ) + " ZF5"					+ CRLF
	cQryZF5 += " WHERE"													+ CRLF
	cQryZF5 += " 		ZF5.ZF5_CODIGO	=	'" + cOrigemPV		+ "'"	+ CRLF
	cQryZF5 += " 	AND	ZF5.ZF5_FILIAL	=	'" + xFilial("ZF5")	+ "'"	+ CRLF
	cQryZF5 += " 	AND	ZF5.D_E_L_E_T_	<>	'*'"						+ CRLF

	tcQuery cQryZF5 New Alias "QRYZF5"

	if !QRYZF5->( EOF() )
		cRetOrigem := lower( allTrim( QRYZF5->ZF5_DESCRI ) )
	endif

	QRYZF5->( DBCloseArea() )
return cRetOrigem

//--------------------------------------------------------------------
Static Function fIbge()
	Public fcodIbge := " "
	QRYIBGE := GetNextAlias()
	If Select(QRYIBGE) > 0
		(QRYIBGE)->(DbClosearea())
	Endif
	BeginSql Alias QRYIBGE
		SELECT
			DISTINCT Substr(GU7_NRCID,1,2) NRCID,GU7_CDUF
		FROM
			%Table:GU7% TGU7
		WHERE
			TGU7.GU7_CDUF = %EXP:(cQrySalesO)->ESTADO%
			AND TGU7.%notdel%
	ENDSQL
	(QRYIBGE)->(DbGoTop())
	fCodIbge := (QRYIBGE)->NRCID
return fCodIbge

//---------------------------------------------------------------------------------------------
// Verifica se o Tipo de Pedido é de Venda
//---------------------------------------------------------------------------------------------
static function chkType( cDA0CODTAB, cCodTip )
	local lTipoVenda	:= .F.
	local cQryCHK

	cQryCHK := " SELECT DISTINCT SZK.ZK_CODTPED, DA0.DA0_CODTAB , DA0.DA0_DESCRI , DA0.DA0_DATDE , "	        + CRLF
	cQryCHK += " DA0.DA0_DATATE , DA0.DA0_ATIVO , DA0.D_E_L_E_T_ DA0DELETE , DA0.R_E_C_N_O_ DA0RECNO , "		+ CRLF
	cQryCHK += " DA0.DA0_ZSTASF , DA0.DA0_XENVSF"                                                               + CRLF
	cQryCHK += " FROM			" + retSQLName( "DA0" ) + " DA0"												+ CRLF

	cQryCHK += " INNER JOIN	" + retSQLName( "SZK" ) + " SZK"													+ CRLF
	cQryCHK += " ON"																							+ CRLF
	cQryCHK += " 		SZK.ZK_CODTAB	=	DA0.DA0_CODTAB"														+ CRLF
	cQryCHK += " AND	SZK.ZK_FILIAL	=	'" + xFilial( "SZK") + "'"											+ CRLF
	cQryCHK += " AND 	SZK.D_E_L_E_T_	=	' '"																+ CRLF

	cQryCHK += " INNER JOIN	" + retSQLName( "SZJ" ) + " SZJ"													+ CRLF
	cQryCHK += " ON"																							+ CRLF
	cQryCHK += " 		SZJ.ZJ_VENDA	=	'S'"																+ CRLF
	cQryCHK += " 	AND	SZJ.ZJ_COD		=	SZK.ZK_CODTPED"														+ CRLF
	cQryCHK += " 	AND	SZJ.ZJ_FILIAL	=	'" + xFilial( "SZJ") + "'"											+ CRLF
	cQryCHK += " 	AND	SZJ.ZJ_COD	    =	'" + cCodTip + "'"													+ CRLF
	cQryCHK += " 	AND SZJ.D_E_L_E_T_	=	' '"																+ CRLF

	cQryCHK += " WHERE"																							+ CRLF
	cQryCHK += " 		DA0.DA0_CODTAB	=	'" + cDA0CODTAB + "'"												+ CRLF
	cQryCHK += " 	AND	DA0.DA0_FILIAL	=	'" + xFilial( "DA0") + "'"											+ CRLF
	cQryCHK += " 	AND DA0.D_E_L_E_T_	=	' '"																+ CRLF

	tcQuery cQryCHK new alias "QRYCHK"

	if !QRYCHK->( EOF() )
		lTipoVenda := .T.
	endif

	QRYCHK->( DBCloseArea() )
return lTipoVenda


//--------------------------------------------------------------------------------------------
// Peso Liquido
//--------------------------------------------------------------------------------------------
Static Function fPesoLiqPed(_C5FILIAL, _C5NUM )		//ZB9_FILIAL || ZB9_EXP || ZB9_ANOEXP || ZB9_SUBEXP
	Local aArea		:= {GetArea()}
	Local cAliasTrb := GetNextAlias()
	_nRet	:= 0
	_cQuery := " SELECT C6_QTDVEN PESO_ITEM, SC6.D_E_L_E_T_ SC6_D_E_L_E_T_  "
	_cQuery += " FROM "       + RetSqlName("SC6") + " SC6 "
	_cQuery += " WHERE  C6_FILIAL || C6_NUM = '"+ xFilial("SC6") + _C5NUM + "' "
	_cQuery += " AND SC6.D_E_L_E_T_ <> '*'   "
	_cQuery := ChangeQuery(_cQuery)
	dbUseArea(.T.,"TOPCONN",tcGenQry(,,_cQuery),cAliasTrb,.T.,.T.)
	(cAliasTrb)->(dbGoTop())
	While (cAliasTrb)->(!Eof())
		_nRet += (cAliasTrb)->PESO_ITEM
		(cAliasTrb)->(dbSkip())
	Enddo
	(cAliasTrb)->(dbCloseArea())
	aEval(aArea,{|x| RestArea(x)})
Return _nRet

//--------------------------------------------------------------------------------------------
// Peso Bruto
//--------------------------------------------------------------------------------------------
Static Function fPesoBruto(_C5FILIAL, _C5NUM )		//C5_FILIAL || C5_NUM
	Local aArea		:= {GetArea()}
	Local cAliasTrb := GetNextAlias()
	_nRet	:= 0
	_cQuery := " SELECT C6_QTDVEN PESO_BRUTO, SC6.D_E_L_E_T_ C6_D_E_L_E_T_  "
	_cQuery += " FROM "       + RetSqlName("SC6") + " SC6 "
	_cQuery += " WHERE  C6_FILIAL || C6_NUM = '"+ xFilial("SC6") + _C5NUM + "' "
	_cQuery += " AND SC6.D_E_L_E_T_ <> '*'   "
	_cQuery := ChangeQuery(_cQuery)
	dbUseArea(.T.,"TOPCONN",tcGenQry(,,_cQuery),cAliasTrb,.T.,.T.)
	(cAliasTrb)->(dbGoTop())
	While (cAliasTrb)->(!Eof())
		_nRet += (cAliasTrb)->PESO_BRUTO
		(cAliasTrb)->(dbSkip())
	Enddo
	(cAliasTrb)->(dbCloseArea())
	aEval(aArea,{|x| RestArea(x)})
Return _nRet
