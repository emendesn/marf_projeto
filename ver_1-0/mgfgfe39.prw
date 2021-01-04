#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "APWEBEX.CH"
/*
=====================================================================================
Programa.:              MGFGFE39	
Autor....:              Rafael Garcia
Data.....:              15/03/2019
Descricao / Objetivo:   Integracao PROTHEUS x MultiEmbarcador - addcarga
Doc. Origem:            Especificacao de Processos_Emissao_CT-e - EF - 01_v2
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              WS Server para Integracao de dados 
=====================================================================================
*/

WSSTRUCT MGFGFE39ReqCarga

	WSDATA Filial		 AS string
	WSDATA OrdemEmb		 AS string
	WSDATA PV			 AS string


ENDWSSTRUCT


WSSTRUCT MGFGFE39RetAddCarga
	WSDATA status   AS string
	WSDATA Msg  	AS string
	WSDATA json		AS String

ENDWSSTRUCT


/***************************************************************************
* Definicao do Web Service. Retorno OE multiembarcador.				                       *
***************************************************************************/
WSSERVICE MGFGFE39 DESCRIPTION "Integracao Protheus x Multiembarcador - addCarga" NameSpace "http://totvs.com.br/MGFGFE39.apw"

	// Passagem dos parametros de entrada
	WSDATA MGFGFE39RequiCarga AS MGFGFE39ReqCarga
	// Retorno (array)
	WSDATA MGFGFE39RetornaCarga  AS MGFGFE39RetAddCarga

	WSMETHOD RetaddCarga DESCRIPTION "Integracao Protheus x Multiembarcador - Retorno Add Carga"

ENDWSSERVICE

/************************************************************************************
** Metodo RetornoCarga
** Grava dados de retorno de Carga - Protocolo ou MsgErro
************************************************************************************/
WSMETHOD RetaddCarga WSRECEIVE	MGFGFE39RequiCarga WSSEND MGFGFE39RetornaCarga WSSERVICE MGFGFE39

	Local aRetFuncao := {}

	Local lReturn	:= .T.

	aRetFuncao	:= u_MGFGFE39(	{	;
	::MGFGFE39RequiCarga:Filial		,;
	::MGFGFE39RequiCarga:OrdemEmb	,;	
	::MGFGFE39RequiCarga:PV		})	// Passagem de parametros para rotina


	// Cria e alimenta uma nova instancia de retorno do cliente
	::MGFGFE39RetornaCarga :=  WSClassNew( "MGFGFE39RetAddCarga" )
	::MGFGFE39RetornaCarga:status		:= aRetFuncao[1]
	::MGFGFE39RetornaCarga:Msg			:= aRetFuncao[2]
	::MGFGFE39RetornaCarga:json			:= aRetFuncao[3]


Return lReturn


user function MGFGFE39( aEmb )


	Local cFil				:= ""
	local cJson 			:= ""
	local oaddcarga			
	local oDest
	local oFilial
	local oMV
	local oMotoristas
	local oProduto
	local oRemet
	local oTipoCargaEmbarcador
	local oTipoOperacao
	local oTransportadoraEmitente
	local oValorFrete
	local oVei
	local cQuery :=" "
	LOCAL aRet
	local cf:=""

	RpcSetEnv( "01" , aEmb[1] , Nil, Nil, "EST", Nil )//, aTables )


	QWSGFE39(aEmb) // CRIAR FUNCAO QUE RETORNA A QUERY DOS REGISTRO



	if !QRYDAK->(EOF())

		oaddcarga 	 := nil
		oaddcarga 	 := addcarga():new()

		oaddcarga:Token:= getmv("MGF_TOKMEM")
		oaddcarga:distancia := QRYDAK->DAK_ZDISTA
		oaddcarga:CargaReferencia:= alltrim(QRYDAK->DAK_XOEREF )
		oaddcarga:Destinatario := {} 

		oDest := Destinatario():new()
		IF Alltrim(QRYDAK->C5_TIPO) == "B"
			cf:="2"
		else	
			cf:="1"
		endif	
		oDest:AtualizarEnderecoPessoa			:=  .T.
		oDest:CPFCNPJ						 	:=	alltrim(&("QRYDAK->A"+cf+"_CGC"))
		IF alltrim(&("QRYDAK->A"+cf+"_EST"))=="EX"
			oDest:ClienteExterior				:= .T.
		else
			oDest:ClienteExterior				:= .f.
		endif

		oDest:CodigoAtividade				  	:=	"3"
		//ENDERECO
		oDest:Endereco:={}
		oDest:Endereco:= Endereco():new()
		oDest:Endereco:Bairro					:=	alltrim(&("QRYDAK->A"+cf+"_BAIRRO"))
		oDest:Endereco:CEP						:=  alltrim(&("QRYDAK->A"+cf+"_CEP"))
		//CIDADE
		oDest:Endereco:Cidade={}
		oDest:Endereco:Cidade= CIDAD():new()
		oDest:Endereco:Cidade:IBGE				:=	ALLTRIM(POSICIONE("C09",1,XFILIAL("C09")+&("QRYDAK->A"+cf+"_EST"),"C09_CODIGO")+ALLTRIM(&("QRYDAK->A"+cf+"_COD_MUN")))
		IF alltrim(&("QRYDAK->A"+cf+"_EST"))=="EX"
			oDest:Endereco:Cidade:Descricao		:= "Exportacao"
		else
			oDest:Endereco:Cidade:Descricao		:=" "
		endif
		//Pais
		oDest:Endereco:Pais={}
		oDest:Endereco:Pais= Pais_loc():new()
		oDest:Endereco:Pais:CodigoPais			:=	alltrim(&("QRYDAK->A"+cf+"_CODPAIS"))
		oDest:Endereco:Pais:NomePais			:=  alltrim(POSICIONE("CCH",1,XFILIAL("CCH")+&("QRYDAK->A"+cf+"_CODPAIS"),"CCH_PAIS"))

		//
		oDest:Endereco:Complemento				:=	alltrim(&("QRYDAK->A"+cf+"_COMPLEM"))
		oDest:Endereco:InscricaoEstadual		:=  alltrim(&("QRYDAK->A"+cf+"_INSCR"))
		oDest:Endereco:Logradouro				:=  alltrim(&("QRYDAK->A"+cf+"_END"))
		oDest:Endereco:Numero					:=  "S/N"
		oDest:Endereco:DDDTelefone				:=	alltrim(&("QRYDAK->A"+cf+"_DDD"))
		oDest:Endereco:Telefone					:=  if (alltrim(&("QRYDAK->A"+cf+"_TEL"))=='',"99999999",alltrim(&("QRYDAK->A"+cf+"_TEL")))	
		oDest:NomeFantasia						:=	alltrim(&("QRYDAK->A"+cf+"_NREDUZ"))
		oDest:RGIE								:=  alltrim(&("QRYDAK->A"+cf+"_INSCR"))
		oDest:RazaoSocial						:=	alltrim(&("QRYDAK->A"+cf+"_NOME") )
		if alltrim(if (cf=="1",QRYDAK->A1_PESSOA,QRYDAK->A2_TIPO)) == "X"
			oDest:TipoPessoa					:="J"
		ELSE
			oDest:TipoPessoa					:=	alltrim(if (cf=="1",QRYDAK->A1_PESSOA,QRYDAK->A2_TIPO))
		ENDIF

		aadd( oaddcarga:Destinatario, oDest )
		//Expedidor
		oaddcarga:Expedidor := {} 

		oExp := Expedidor():new()
		oExp:AtualizarEnderecoPessoa			:=  .T.
		
		
		IF !EMPTY(QRYDAK->DAK_XCODE) .AND. !EMPTY(QRYDAK->DAK_XLOJE)
		
			QSA2(QRYDAK->DAK_XCODE,QRYDAK->DAK_XLOJE)
			if !QSA2->(EOF())
				oExp:CPFCNPJ						 	:=	alltrim(QSA2->A2_CGC)
				IF QSA2->A2_EST=="EX"
					oExp:ClienteExterior				:= .T.
				else
					oExp:ClienteExterior				:= .f.
				endif

				oExp:CodigoAtividade				  	:=	"3"
				//ENDERECO
				oExp:Endereco:={}
				oExp:Endereco:= Endereco():new()
				oExp:Endereco:Bairro					:=	alltrim(QSA2->A2_BAIRRO)
				oExp:Endereco:CEP						:=  alltrim(QSA2->A2_CEP)
				//CIDADE
				oExp:Endereco:Cidade={}
				oExp:Endereco:Cidade= CIDAD():new()
				
				
				oExp:Endereco:Cidade:IBGE				:=	ALLTRIM(POSICIONE("C09",1,XFILIAL("C09")+QSA2->A2_EST,"C09_CODIGO"))+ALLTRIM(QSA2->A2_COD_MUN)
				IF QSA2->A2_EST=="EX"
					oExp:Endereco:Cidade:Descricao		:= "Exportacao"
				else
					oExp:Endereco:Cidade:Descricao		:=" "
				endif
				//Pais
				oExp:Endereco:Pais={}
				oExp:Endereco:Pais= Pais_loc():new()
				oExp:Endereco:Pais:CodigoPais			:=	alltrim(QSA2->A2_CODPAIS)
				oExp:Endereco:Pais:NomePais				:=  alltrim(POSICIONE("CCH",1,XFILIAL("CCH")+QSA2->A2_CODPAIS,"CCH_PAIS"))

				//
				oExp:Endereco:Complemento				:=	alltrim(QSA2->A2_COMPLEM)
				oExp:Endereco:InscricaoEstadual			:=  alltrim(QSA2->A2_INSCR)
				oExp:Endereco:Logradouro				:=  alltrim(QSA2->A2_END)
				oExp:Endereco:Numero					:=  "S/N"
				oExp:Endereco:DDDTelefone				:=	alltrim(QSA2->A2_DDD)
				oExp:Endereco:Telefone					:=  if (alltrim(QSA2->A2_TEL)=='',"99999999",alltrim(QSA2->A2_TEL))	
				oExp:NomeFantasia						:=	alltrim(QSA2->A2_NREDUZ)
				oExp:RGIE								:=  alltrim(QSA2->A2_INSCR)
				oExp:RazaoSocial						:=	alltrim(QSA2->A2_NOME) 
				IF alltrim(QSA2->A2_TIPO) == "X"
					oExp:TipoPessoa						:=	"J"
				ELSE
					oExp:TipoPessoa						:=	alltrim(QSA2->A2_TIPO)
				ENDIF
			ENDIF
		ENDIF
		aadd( oaddcarga:Expedidor, oExp )
		//ModeloVeicular
		oaddcarga:ModeloVeicular	:= {}

		oMV:= ModeloVeicular():new()
		oMV:CodigoIntegracao					:=alltrim(QRYDAK->DA3_TIPVEI)
		aadd( oaddcarga:ModeloVeicular, oMV )

		//Motoristas

		oaddcarga:Motoristas:={}
		oMotoristas:=Motoristas():new()
		oMotoristas:Motorista:={}
		oMotoristas:Motorista:= Motorista():new()
		oMotoristas:Motorista:Ativo			:= .T.
		oMotoristas:Motorista:CPF			:= alltrim(QRYDAK->DA4_CGC)
		oMotoristas:Motorista:Nome			:= alltrim(QRYDAK->DA4_NOME)
		aadd(oaddcarga:Motoristas, oMotoristas )

		oaddcarga:NumeroCarga 				:= alltrim(QRYDAK->DAK_COD)
		oaddcarga:NumeroPedidoEmbarcador	:= alltrim(QRYDAK->DAI_PEDIDO)
		oaddcarga:PesoBruto					:= QRYDAK->DAI_PESO
		oaddcarga:pesoLiquido				:= QRYDAK->F2_PLIQUI

		//Produtos
		oaddcarga:Produtos:={}
		oProduto:=Produtos():new()
		oProduto:Produto= PRODUT():new()
		oProduto:Produto:CodigoGrupoProduto    :="1"
		oProduto:Produto:CodigoProduto		   :="1"
		oProduto:Produto:DescricaoGrupoProduto :="Diversos"
		oProduto:Produto:DescricaoProduto	   :="Diversos"
		oProduto:Produto:PesoUnitario		   :="1"
		oProduto:Produto:Quantidade			   :="1"
		oProduto:Produto:ValorUnitario		   :="1"
		aadd(oaddcarga:Produtos, oProduto )

		//Recebedor
		oaddcarga:Recebedor := {}

		oRec := Recebedor():new()
		oRec:AtualizarEnderecoPessoa			:=  .T.

		IF !EMPTY(QRYDAK->DAK_XCODR) .AND. !EMPTY(QRYDAK->DAK_XLOJR)

			QSA2(QRYDAK->DAK_XCODR,QRYDAK->DAK_XLOJR)

			IF !QSA2->(EOF())
				oRec:CPFCNPJ						 	:= alltrim(QSA2->A2_CGC)
				IF QSA2->A2_EST=="EX"
					oRec:ClienteExterior				:= .T.
				else
					oRec:ClienteExterior				:= .f.
				endif

				oRec:CodigoAtividade				  	:=	"3"
				//ENDERECO
				oRec:Endereco:={}
				oRec:Endereco:= Endereco():new()
				oRec:Endereco:Bairro					:=	alltrim(QSA2->A2_BAIRRO)
				oRec:Endereco:CEP						:=  alltrim(QSA2->A2_CEP)
				//CIDADE
				oRec:Endereco:Cidade={}
				oRec:Endereco:Cidade= CIDAD():new()
				oRec:Endereco:Cidade:IBGE				:=	ALLTRIM(POSICIONE("C09",1,XFILIAL("C09")+QSA2->A2_EST,"C09_CODIGO"))+ALLTRIM(QSA2->A2_COD_MUN)
				IF QSA2->A2_EST=="EX"
					oRec:Endereco:Cidade:Descricao		:= "Exportacao"
				else
					oRec:Endereco:Cidade:Descricao		:=" "
				endif
				//Pais
				oRec:Endereco:Pais={}
				oRec:Endereco:Pais= Pais_loc():new()
				oRec:Endereco:Pais:CodigoPais			:=	alltrim(QSA2->A2_CODPAIS)
				oRec:Endereco:Pais:NomePais				:=  alltrim(POSICIONE("CCH",1,XFILIAL("CCH")+QSA2->A2_CODPAIS,"CCH_PAIS"))

				//
				oRec:Endereco:Complemento				:=	alltrim(QSA2->A2_COMPLEM)
				oRec:Endereco:InscricaoEstadual			:=  alltrim(QSA2->A2_INSCR)
				oRec:Endereco:Logradouro				:=  alltrim(QSA2->A2_END)
				oRec:Endereco:Numero					:=  "S/N"
				oRec:Endereco:DDDTelefone				:=	alltrim(QSA2->A2_DDD)
				oRec:Endereco:Telefone					:=  if (alltrim(QSA2->A2_TEL)=='',"99999999",alltrim(QSA2->A2_TEL))
				oRec:NomeFantasia						:=	alltrim(QSA2->A2_NREDUZ)
				oRec:RGIE								:=  alltrim(QSA2->A2_INSCR)
				oRec:RazaoSocial						:=	alltrim(QSA2->A2_NOME)
				IF 	alltrim(QSA2->A2_TIPO) =="X"
					oRec:TipoPessoa						:=	"X"
				ELSE
					oRec:TipoPessoa						:=	alltrim(QSA2->A2_TIPO)	
				ENDIF

			ENDIF
		ENDIF
		aadd( oaddcarga:Recebedor, oRec )

		//Remetente

		oaddcarga:Remetente := {}

		oRemet := Remetente():new()
		QFIL(QRYDAK->DAK_FILIAL)
		oRemet:AtualizarEnderecoPessoa	:= .t.
		oRemet:CPFCNPJ					:= alltrim(cSM0->M0_CGC)
		oRemet:CodigoAtividade			:= "2"
		oRemet:Email				  	:= alltrim(SuperGetMv("MGF_EREMET",.F.,""))
		//ENDERECO
		oRemet:Endereco:={}
		oRemet:Endereco:= Endereco():new()
		oRemet:Endereco:Bairro					:=	alltrim(cSM0->M0_BAIRENT)
		oRemet:Endereco:CEP						:=  alltrim(cSM0->M0_CEPENT)
		//CIDADE
		oRemet:Endereco:Cidade={}
		oRemet:Endereco:Cidade= CIDAD():new()
		oRemet:Endereco:Cidade:IBGE				:=	alltrim(cSM0->M0_CODMUN)
		//
		oRemet:Endereco:Complemento				:=	alltrim(cSM0->M0_COMPENT)
		oRemet:Endereco:InscricaoEstadual		:=  alltrim(cSM0->M0_INSC)
		oRemet:Endereco:Logradouro				:=  alltrim(cSM0->M0_ENDENT)
		oRemet:Endereco:Numero					:=  "S/N"
		oRemet:Endereco:DDDTelefone				:=  "S/N"
		oRemet:Endereco:Telefone				:=  if (alltrim(cSM0->M0_TEL)=='',"99999999",alltrim(cSM0->M0_TEL))
		oRemet:NomeFantasia						:=  alltrim(cSM0->M0_FILIAL)
		oRemet:RGIE								:=  alltrim(cSM0->M0_INSC)
		oRemet:RazaoSocial						:=  alltrim(cSM0->M0_NOMECOM)
		oRemet:TipoPessoa						:=  "Juridica"

		aadd( oaddcarga:Remetente, oRemet )

		//filial
		oaddcarga:Filial	:= {}

		oFilial:= Filial():new()

		oFilial:CodigoIntegracao				:=alltrim(cSM0->M0_CGC)
		oFilial:Logradouro						:=alltrim(cSM0->M0_ENDENT)
		oFilial:Numero							:="S/N"

		aadd( oaddcarga:Filial, oFilial )


		//TipoCargaEmbarcador
		oaddcarga:TipoCargaEmbarcador	:= {}
		oTipoCargaEmbarcador:= TipoCargaEmbarcador():new()

		oTipoCargaEmbarcador:CodigoIntegracao				:= alltrim(QRYDAK->C5_XTPROD)

		aadd( oaddcarga:TipoCargaEmbarcador, oTipoCargaEmbarcador )
		//TipoOperacao
		oaddcarga:TipoOperacao:={}
		oTipoOperacao:= TipoOperacao():new()
		oTipoOperacao:CodigoIntegracao	   := alltrim(QRYDAK->DAK_ZCDTPO)
		aadd( oaddcarga:TipoOperacao, oTipoOperacao )
		IF QRYDAK->C5_TPFRETE == "C"
			oaddcarga:TipoPagamento						:=	"Pago"
			oaddcarga:TipoTomador						:= "Remetente"
		ELSE
			oaddcarga:TipoPagamento						:= "A_Pagar"
			oaddcarga:TipoTomador						:= "Destinatario"
		ENDIF
		//TransportadoraEmitente
		oaddcarga:TransportadoraEmitente:={}
		oTransportadoraEmitente:= TransportadoraEmitente():new()
		oTransportadoraEmitente:CNPJ:= alltrim(QRYDAK->A4_CGC)
		aadd( oaddcarga:TransportadoraEmitente, oTransportadoraEmitente )

		//valor frete
		oaddcarga:ValorFrete:={}
		oValorFrete:= ValorFrete():new()
		oValorFrete:FreteProprio:="0"
		aadd( oaddcarga:ValorFrete, oValorFrete )

		//VEICULO

		oaddcarga:Veiculo:={}
		oVei:= Veiculo():new()
		if ALLTRIM(QRYDAK->DAK_XCAVAL)==""
			oVei:Placa:= ALLTRIM(QPLACA(ALLTRIM(QRYDAK->DAK_CAMINH)))
		else 
			oVei:Placa:=QPLACA(QRYDAK->DAK_XCAVAL)
			oVei:Reboque:={}
			oVei:Reboque:= Reboque():new()
			oVei:Reboque:PLACA1	:=	ALLTRIM(QPLACA(ALLTRIM(QRYDAK->DAK_CAMINH)))
			oVei:Reboque:PLACA2	:=  ALLTRIM(QPLACA(ALLTRIM(QRYDAK->DAK_XCAMI2)))
			oVei:Reboque:PLACA3	:=  ALLTRIM(QPLACA(ALLTRIM(QRYDAK->DAK_XCAMI3)))
		ENDIF	
		aadd( oaddcarga:Veiculo, oVei )
		cJson:=FWJsonSerialize(oaddcarga,.F.,.T.)

		cQuery := " UPDATE " + RetSqlname("DAK") + " "
		cQuery += " SET 	DAK_XINTME = 'P',"
		if alltrim(QRYDAK->DAK_XOPEME) ==""
			cQuery += " DAK_XOPEME = 'I'"
		ELSEif alltrim(QRYDAK->DAK_XOPEME) =="R"
			cQuery += " DAK_XOPEME = 'R'"
		ENDIF
		cQuery += " WHERE DAK_FILIAL = '" + QRYDAK->DAK_FILIAL + "' "
		cQuery += "	AND DAK_COD = '" + QRYDAK->DAK_COD + "' "
		cQuery += "	AND D_E_L_E_T_ <> '*' "
		TcSqlExec(cQuery)

		cQuery := " UPDATE " + RetSqlname("DAI") + " "
		cQuery += " SET 	DAI_XINTME = 'P',"
		if alltrim(QRYDAK->DAK_XOPEME) =="" .or. alltrim(QRYDAK->DAK_XOPEME) =="I"
			cQuery += " DAI_XOPEME = 'I'"
		ELSEif alltrim(QRYDAK->DAK_XOPEME) =="R"
			cQuery += " DAI_XOPEME = 'R'"
		ENDIF
		cQuery += " WHERE DAI_FILIAL = '" + QRYDAK->DAK_FILIAL + "' "
		cQuery += "	AND DAI_COD = '" + QRYDAK->DAK_COD + "' "
		cQuery += " AND DAI_PEDIDO = '"+QRYDAK->DAI_PEDIDO+"' "
		cQuery += "	AND D_E_L_E_T_ <> '*' "
		TcSqlExec(cQuery)
		aRet:={"1","Registro Localizado",cJson}
		QRYDAK->(DBSKIP())

	else
		aRet:={"2","Registro nao Localizado",""}
	endif
	IF SELECT("QRYDAK") > 0
		QRYDAK->( dbCloseArea() )
	ENDIF
	IF SELECT("cSM0") > 0
		cSM0->( dbCloseArea() )
	ENDIF
	IF SELECT("QSA2") > 0
		QSA2->( dbCloseArea() )
	ENDIF

return aRet

//-------------------------------------------------------------------
// Seleciona Notas a serem enviadas
//-------------------------------------------------------------------
static function QWSGFE39(aEmb)

	local cQry := ""

	cQry := " select DAK.DAK_FILIAL,"							+CRLF
	cQry += " SA1.A1_CGC,"										+CRLF
	cQry += " SA1.A1_NREDUZ,"									+CRLF
	cQry += " SA1.A1_NOME,"										+CRLF
	cQry += " SA1.A1_PESSOA,"									+CRLF
	cQry += " SA1.A1_BAIRRO,"									+CRLF
	cQry += " SA1.A1_CEP,"										+CRLF
	cQry += " SA1.A1_COD_MUN,"									+CRLF
	cQry += " SA1.A1_COMPLEM,"									+CRLF
	cQry += " SA1.A1_INSCR,"									+CRLF
	cQry += " SA1.A1_END,"										+CRLF
	cQry += " SA1.A1_TEL,"										+CRLF
	cQry += " SA1.A1_EST,"										+CRLF
	cQry += " SA1.A1_DDD,"										+CRLF
	cQry += " SA1.A1_CODPAIS,"									+CRLF
	cQry += " SA2.A2_CGC,"										+CRLF
	cQry += " SA2.A2_NREDUZ,"									+CRLF
	cQry += " SA2.A2_NOME,"										+CRLF
	cQry += " SA2.A2_TIPO,"										+CRLF
	cQry += " SA2.A2_BAIRRO,"									+CRLF
	cQry += " SA2.A2_CEP,"										+CRLF
	cQry += " SA2.A2_COD_MUN,"									+CRLF
	cQry += " SA2.A2_COMPLEM,"									+CRLF
	cQry += " SA2.A2_INSCR,"									+CRLF
	cQry += " SA2.A2_END,"										+CRLF
	cQry += " SA2.A2_TEL,"										+CRLF
	cQry += " SA2.A2_EST,"										+CRLF
	cQry += " SA2.A2_DDD,"										+CRLF	
	cQry += " SA2.A2_CODPAIS,"									+CRLF
	cQry += " DA4.DA4_CGC,"										+CRLF
	cQry += " DA4.DA4_NOME,"									+CRLF
	cQry += " DAK.DAK_COD,"										+CRLF
	cQry += " DAK.DAK_XOPEME,"									+CRLF
	cQry += " DAK.DAK_ZCDTPO,"									+CRLF
	cQry += " DAK.DAK_XCODE,"									+CRLF
	cQry += " DAK.DAK_XLOJE,"									+CRLF
	cQry += " DAK.DAK_XCODR,"									+CRLF
	cQry += " DAK.DAK_XLOJR,"									+CRLF
	cQry += " DAK.DAK_XOEREF,"									+CRLF
	cQry += " DAK.DAK_ZDISTA,"									+CRLF
	cQry += " DAK.DAK_CAMINH,"									+CRLF
	cQry += " DAK.DAK_XCAVAL,"									+CRLF
	cQry += " DAK.DAK_XCAMI2,"									+CRLF
	cQry += " DAK.DAK_XCAMI3,"									+CRLF
	cQry += " DAI.DAI_PEDIDO,"									+CRLF
	cQry += " DA3.DA3_TIPVEI,"									+CRLF
	cQry += " DAI.DAI_PESO,"									+CRLF
	cQry += " SF2.F2_PLIQUI,"									+CRLF
	cQry += " SA4.A4_CGC,"										+CRLF
	cQry += " SC5.C5_TPFRETE,"									+CRLF
	cQry += " SC5.C5_TIPO,"										+CRLF
	cQry += " SC5.C5_XTPROD"									+CRLF
	cQry += " FROM "+retSQLName("DAK")+" DAK"					+CRLF
	cQry += " INNER JOIN  "+retSQLName("DAI")+" DAI"			+CRLF
	cQry += " ON DAK.DAK_COD=DAI.DAI_COD"						+CRLF
	cQry += " AND DAK.DAK_FILIAL=DAI.DAI_FILIAL" 				+CRLF
	cQry += " AND DAI.D_E_L_E_T_      <>  '*'"					+CRLF
	cQry += " LEFT JOIN "+retSQLName("DA3")+" DA3"				+CRLF
	cQry += " ON  DA3.DA3_COD = DAK.DAK_CAMINH "	 			+CRLF
	cQry += " AND DA3.D_E_L_E_T_<>  '*'"					    +CRLF
	cQry += " AND DA3.DA3_FILIAL = '"+xfilial("DA3")+"' "     	+CRLF
	cQry += " LEFT JOIN "+retSQLName("DA4")+" DA4"				+CRLF
	cQry += " ON DAK.DAK_MOTORI=DA4.DA4_COD"					+CRLF
	cQry += " AND DA4.D_E_L_E_T_ <>  '*'"						+CRLF
	cQry += " AND DA4.DA4_FILIAL = '"+XFILIAL("DA4")+"'"		+CRLF
	cQry += " INNER JOIN "+retSQLName("SF2")+" SF2"				+CRLF
	cQry += " ON DAI.DAI_NFISCA=SF2.F2_DOC"						+CRLF
	cQry += " AND DAI.DAI_SERIE= SF2.F2_SERIE"					+CRLF
	cQry += " AND SF2.D_E_L_E_T_ <>  '*'"						+CRLF
	cQry += " AND DAI.DAI_FILIAL=SF2.F2_FILIAL"					+CRLF
	cQry += " INNER JOIN "+retSQLName("SC5")+" SC5"				+CRLF
	cQry += " ON DAI.DAI_PEDIDO=SC5.C5_NUM"						+CRLF
	cQry += " AND SC5.C5_FILIAL=DAK.DAK_FILIAL"					+CRLF
	cQry += " AND DAI.D_E_L_E_T_ <>  '*'"						+CRLF
	cQry += " LEFT join "+retSQLName("SA1")+" SA1"				+CRLF
	cQry += " ON DAI.DAI_CLIENT=SA1.A1_COD"						+CRLF
	cQry += " AND DAI.DAI_LOJA=SA1.A1_LOJA"						+CRLF
	cQry += " AND SA1.A1_FILIAL='"+XFILIAL("SA1")+"'"			+CRLF
	cQry += " AND SA1.D_E_L_E_T_<>'*'"							+CRLF
	cQry += " AND SC5.C5_TIPO='N'"								+CRLF
	cQry += " LEFT join "+retSQLName("SA2")+" SA2"				+CRLF
	cQry += " ON DAI.DAI_CLIENT=SA2.A2_COD"						+CRLF
	cQry += " AND DAI.DAI_LOJA=SA2.A2_LOJA"						+CRLF
	cQry += " AND SA2.A2_FILIAL='"+XFILIAL("SA2")+"'"			+CRLF
	cQry += " AND SA2.D_E_L_E_T_<>'*'"							+CRLF
	cQry += " AND SC5.C5_TIPO='B'"								+CRLF
	cQry += " INNER JOIN "+retSQLName("SA4")+" SA4"				+CRLF
	cQry += " ON SA4.D_E_L_E_T_ <> '*'" 						+CRLF
	cQry += " AND SA4.A4_FILIAL = '"+XFILIAL("SA4")+"'"			+CRLF
	cQry += " AND SA4.A4_COD = SC5.C5_TRANSP"					+CRLF
	cQry += " WHERE " 											+CRLF
	cQry += " DAK.D_E_L_E_T_<>'*'"								+CRLF
	cQry += " AND DAK.DAK_XOPEME <>'C'"							+CRLF
	cQry += " AND DAK.DAK_FILIAL='"+ aEmb[1] +"'"				+CRLF
	cQry += " AND DAK.DAK_XOEREF = '" + aEmb[2] + "' "			+CRLF
	cQry += " AND DAI.DAI_PEDIDO = '"+ aEmb[3] +"' "			+CRLF
	cQry += " ORDER BY DAK.DAK_COD,DAI.DAI_PEDIDO"				+CRLF

	IF SELECT("QRYDAK") > 0
		QRYDAK->( dbCloseArea() )
	ENDIF
	TcQuery changeQuery(cQry) New Alias "QRYDAK"
return

// Retorna dados da Filial

static function QFIL(cFil)

	Local cQuery

	IF SELECT("cSM0") > 0
		cSM0->( dbCloseArea() )
	ENDIF

	cQuery := " SELECT * FROM SYS_COMPANY "
	cQuery += "  WHERE M0_CODFIL = '" + cFil + "'"
	cQuery += "  AND SYS_COMPANY.D_E_L_E_T_<> '*' "

	TcQuery changeQuery(cQuery) New Alias "cSM0"

Return

// Retorna dados do Forncedor

static function QSA2(cCod,cLoja)

	Local cQuery

	IF SELECT("QSA2") > 0
		QSA2->( dbCloseArea() )
	ENDIF

	cQuery := " SELECT * FROM "+ retSQLName("SA2")
	cQuery +=" WHERE D_E_L_E_T_<>'*' AND A2_FILIAL='"+XFILIAL("SA2")+"'"
	cQuery +=" AND A2_COD="+alltrim(cCod)+" and A2_LOJA ='"+ALLTRIM(cLoja)+"'"

	TcQuery changeQuery(cQuery) New Alias "QSA2"

Return
static function QPLACA(cCOD)

	Local cQuery:=""
	LOCAL cRet:=""

	IF SELECT("QPLACA") > 0
		QPLACA->( dbCloseArea() )
	ENDIF

	cQuery := " SELECT DA3_PLACA FROM "+ retSQLName("DA3")
	cQuery +=" WHERE D_E_L_E_T_<>'*' AND DA3_FILIAL='"+XFILIAL("DA3")+"'"
	cQuery +=" AND DA3_COD='"+alltrim(cCod)+"'"

	TcQuery changeQuery(cQuery) New Alias "QPLACA"

	cRet:=QPLACA->DA3_PLACA

	IF SELECT("QPLACA") > 0
		QPLACA->( dbCloseArea() )
	ENDIF


Return cRet


/*
Classe d addcarga
*/
	class addcarga

		data Token						as string
		data CargaReferencia			as string
		data distancia					as string	
		data Destinatario				as array
		data FecharCargaAutomaticamente as Boolean
		data filial						as array
		data ModeloVeicular				as array
		data Motoristas					as array
		data NumeroCarga				as string
		data NumeroPedidoEmbarcador		as string
		data PesoBruto					as String
		data pesoLiquido				as String
		data Produtos					as array
		data Remetente					as Array
		data TipoCargaEmbarcador		as Array
		data TipoOperacao				as array
		data TipoPagamento				as String
		data TipoTomador				as string
		data TransportadoraEmitente		as Array
		data ValorFrete					as Array
		data Veiculo					as array
		data Expedidor					as array
		data Recebedor					as array

		method New() constructor constructor
//method setProduct()
		return

/*
Construtor
*/
method New() class addcarga

return

/*
Classe de Destinatario
*/
	class Destinatario

		data AtualizarEnderecoPessoa			as Boolean
		data CPFCNPJ							as string
		data CodigoAtividade					as string
		data Endereco							as Array
		data NomeFantasia						as string
		data RGIE								as string
		data RazaoSocial						as string
		data TipoPessoa							as string
		data ClienteExterior					as Boolean

		method New() constructor
//method setProduct()

		return

/*
Construtor
*/
method New() class Destinatario

return

/*
Endereco
*/
class Endereco

	data Bairro				as string
	data Cep				as string
	data Cidade				as Array
	data Pais				as Array
	data Complemento		as string
	data InscricaoEstadual	as string
	data Logradouro			as string
	data Numero				as string
	DATA DDDTelefone 		AS STRING
	data Telefone			as string

	method New() constructor
//method setProduct()

return

/*
Construtor
*/
method New() class Endereco

return

/*
Cidade
*/
	class CIDAD

		data IBGE			as string
		DATA Descricao		as string
		method New() constructor
//method setProduct()

		return

/*
Construtor
*/
method New() class CIDAD

return

/*
Cidade
*/
	class Pais_loc

		data CodigoPais		as string
		data NomePais		as String


		method New() constructor
//method setProduct()

		return

/*
Construtor
*/
method New() class Pais_loc

return

///Filial

	class Filial

		data CodigoIntegracao		as String
		data Logradouro				as String
		data Numero					as String
		method New() constructor
//method setProduct()

		return

/*
Construtor
*/
method New() class Filial

return

///ModeloVeicular

	class ModeloVeicular

		data CodigoIntegracao		as string

		method New() constructor
//method setProduct()

		return

method New() class ModeloVeicular

return

//motoristas
	class Motoristas

		data Motorista  as Array

		method New() constructor


		Return

method New() class Motoristas

return
//motorista
	class Motorista
		data Ativo		as Boolean
		data CPF		as string
		data Nome		as string
		method New() constructor


		Return

method New() class Motorista

return
//produtos
	Class Produtos

		data Produto  as Array

		method New() constructor
//method setProduct()

		Return

method New() class Produtos

return
//produto
	class PRODUT

		data CodigoGrupoProduto		as string
		data CodigoProduto	    	as string
		data DescricaoGrupoProduto	as string
		data DescricaoProduto		as string
		data PesoUnitario			as float
		data Quantidade				as float
		data ValorUnitario			as Float

		method New() constructor

		return

method New() class PRODUT

return
//remetente
	class Remetente

		data AtualizarEnderecoPessoa	as Boolean
		data CPFCNPJ					as string
		data CodigoAtividade			as string
		data Email						as string
		data Endereco					as Array
		data CodigoPais					as string
		data Complemento				as string
		data NomeFantasia				as string
		data RGIE						as string
		data RazaoSocial				as string
		data TipoPessoa					as string

		method New() constructor
//method setProduct()

		return

/*
Construtor
*/
method New() class Remetente

return
//TipoCargaEmbarcador
	class TipoCargaEmbarcador

		data CodigoIntegracao	as string

		method New() constructor
//method setProduct()

		return

method New() class TipoCargaEmbarcador

return
//TipoOperacao
	class TipoOperacao

		data CodigoIntegracao	as string

		method New() constructor
//method setProduct()

		return

/*
Construtor
*/
method New() class TipoOperacao

return

//TransportadoraEmitente
	class TransportadoraEmitente

		data CNPJ			as string

		method New() constructor
//method setProduct()

		return

method New() class TransportadoraEmitente

return

//ValorFrete
	class ValorFrete

		data FreteProprio			as float

		method New() constructor
//method setProduct()

		return

method New() class ValorFrete

return

//Expedidor
	class Expedidor

		data AtualizarEnderecoPessoa	as Boolean
		data CPFCNPJ					as string
		data CodigoAtividade			as string
		data Email						as string
		data Endereco					as Array
		data CodigoPais					as string
		data Complemento				as string
		data NomeFantasia				as string
		data RGIE						as string
		data RazaoSocial				as string
		data TipoPessoa					as string
		data ClienteExterior			as Boolean
		method New() constructor
//method setProduct()

		return

/*
Construtor
*/
method New() class Expedidor

return
//Recebedor
	class Recebedor

		data AtualizarEnderecoPessoa	as Boolean
		data CPFCNPJ					as string
		data CodigoAtividade			as string
		data Email						as string
		data Endereco					as Array
		data CodigoPais					as string
		data Complemento				as string
		data NomeFantasia				as string
		data RGIE						as string
		data RazaoSocial				as string
		data TipoPessoa					as string
		data ClienteExterior			as Boolean

		method New() constructor
//method setProduct()

		return

/*
Construtor
*/
method New() class Recebedor

return

//Veiculo
	class Veiculo

		data Placa	as string
		data Reboque	as Array
//method setProduct()

		return

		method New() constructor
//method setProduct()

		return

/*
Construtor
*/
method New() class Veiculo

return

/*
Endereco
*/
class Reboque

	data Placa1				as string
	data Placa2				as string
	data Placa3 			as string

	method New() constructor
//method setProduct()

return

/*
Construtor
*/
method New() class Reboque

return
