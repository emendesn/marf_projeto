#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "APWEBEX.CH"
#INCLUDE "FWMVCDEF.CH"

static _aErr

/*
=====================================================================================
Programa.:              MGFWSS12
Autor....:              Joni
Data.....:              04/06/2018
Descricao / Objetivo:   Integracao PROTHEUS x MultiEmbarcador
Doc. Origem:            Especificacao de Processos_Emissao_CT-e - EF - 01_v2
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              WS Server Inclusão ocorrencia
=====================================================================================
*/

/*/{Protheus.doc} MGFWSS12DADOS
Estrutura dos Dados que sera recebida no WS
@type property

@author Joni Lima do Carmo
@since 24/07/2019
@version P12
/*/
WSSTRUCT MGFWSS12DADOS
	WSDATA CNPJFilial	 			as String
	WSDATA Transportador 			as String
	WSDATA PrestadorServico 		as String Optional
	WSDATA Descricao	 			as String
	WSDATA Tipo		     			as String
	WSDATA Motivo	     			as String
	WSDATA Problema					as String
	WSDATA Solucao		 			as String
	WSDATA HrOcorren	 			as String
	WSDATA UsrCriacao 	 			as String
	WSDATA UsrBaixa		 			as String
	WSDATA OcorrenciaMultEmbarcador as String
	WSDATA DtOcorrencia	 			as Date
	WSDATA ValorEsp 	 			as Float
	WSDATA QtServicos	 			as Float
	WSDATA NotasFiscais  			as Array of Notas
ENDWSSTRUCT

/*/{Protheus.doc} Notas
Estrutura dos Dados para Notas
@type property

@author Joni Lima do Carmo
@since 24/07/2019
@version P12
/*/
WSSTRUCT Notas
	WSDATA EmissorDc    as String
	WSDATA SerieDc		as String
	WSDATA NrDocCarga   as String
	WSDATA ChaveNfe		as String
	WSDATA SeqTrecho	as String
ENDWSSTRUCT

/*/{Protheus.doc} MGFWSS128Ret
Estrutura dos Dados para retorno do WS
@type property

@author Joni Lima do Carmo
@since 24/07/2019
@version P12
/*/
WSSTRUCT MGFWSS128Ret
	WSDATA status   		AS string
	WSDATA Msg				AS String
ENDWSSTRUCT

/*/{Protheus.doc} MGFWSS12
Classe do WS contendo suas propriedades e metodos
@type class

@author Joni Lima do Carmo
@since 24/07/2019
@version P12
/*/
WSSERVICE MGFWSS12 DESCRIPTION "Integracao Protheus x Multiembarcador - Ocorrencia" NameSpace "http://totvs.com.br/MGFWSS12.apw"

	WSDATA WSS12DADOS  AS MGFWSS12DADOS // Passagem dos parametros de entrada
	WSDATA WSS12RETORNO AS MGFWSS128Ret // Retorno

	WSMETHOD Ocorrencia DESCRIPTION "Integracao Protheus x Multiembarcador - Ocorrencia"

ENDWSSERVICE

/*/{Protheus.doc} Ocorrencia
Metodo que ira realizar a gravação da Ocorrencia
@type method

@param WSS12DADOS, objeto de MGFWSS12DADOS ,  Dados recebidos via WS (Dados da ocorrencia e array com Notas)
@return WSS12RETORNO, objeto de MGFWSS128Ret ,  Dados enviados apos processamento(Status, mensagem)

@author Joni Lima do Carmo
@since 24/07/2019
@version P12
/*/
WSMETHOD Ocorrencia WSRECEIVE WSS12DADOS WSSEND WSS12RETORNO WSSERVICE MGFWSS12

	Local aRetFuncao	:= {}
	Local lReturn		:= .T.
	local ni			:= 1

	Local bError 	:= ErrorBlock( { |oError| MyError( oError ) } )

	Begin Transaction

		BEGIN SEQUENCE
			aRetFuncao := GFEA117(::WSS12DADOS)
			RECOVER
			Conout('[MGFWSS12] - Ocorrencia - Problema Ocorreu as Horas: ' + TIME() )
		END SEQUENCE

		ErrorBlock( bError )

		If ValType(_aErr) == 'A'
			aRetFuncao := _aErr

			If InTransact()//verifica se existe transação aberta
				DisarmTransaction()
			Endif

		EndIf

	End Transaction

	// Cria e alimenta uma nova instancia de retorno do cliente
	::WSS12RETORNO 				:=  WSClassNew( "MGFWSS128Ret" )
	::WSS12RETORNO:status		:= aRetFuncao[1]
	::WSS12RETORNO:Msg			:= aRetFuncao[2]

Return lReturn

/*/{Protheus.doc} MyError
Funcao que ira Preparar o error Log para envio no Retorno do WS
@type Function

@param oError, objeto de ErrorBlock ,  Obejto do Erro gerado no Appserver
@return .T., Boleano ,  Exige .T.

@author Joni Lima do Carmo
@since 24/07/2019
@version P12
/*/
Static Function MyError(oError)

	Local nQtd := MLCount(oError:ERRORSTACK)
	Local ni
	Local cEr := ''

	nQtd := IIF(nQtd > 4,4,nQtd) //Retorna as 4 linhas

	For ni:=1 to nQtd
		cEr += MemoLine(oError:ERRORSTACK,,ni)
	Next ni

	Conout( oError:Description + "Deu Erro" )
	_aErr := {'2',cEr}

	BREAK

Return .T.

/*/{Protheus.doc} GFEA117
Função para gerar a ocorrencia para futuro GFE
@type Function

@param oOcorrencia, objeto MGFWSS12DADOS ,  objeto da Entrada de Dados do WS
@return aRet, Array ,  {Status,Mensagem} Status 1=OK,2=erro, mensagem observacoes do processamento

@author Joni Lima do Carmo
@since 24/07/2019
@version P12
/*/
Static Function GFEA117(oOcorrencia)

	Local aRet 		:= {"1","OK"}
	Local cxFil		:= xMGFQFil(Alltrim(oOcorrencia:CNPJFilial))
	Local cBkpFil	:= cFilAnt
	Local oModel 	:= Nil
	Local oMdlGWD	:= Nil
	Local oMdlGWL	:= Nil
	Local nOpc   	:= 3
	local cOcor  	:= ""
	Local cTipNF	:= ""

	Local ni		:= 1

	If !Empty(cxFil)
		PREPARE ENVIRONMENT EMPRESA "01" FILIAL cxFil MODULO "GFE"

		//Begin Transaction

		cFilAnt := cxFil
		IF SELECT("cGWD") > 0
			cGWD->( dbCloseArea() )
		ENDIF

		cQuery := " SELECT GWD_ZOCMUL FROM "  + RetSQLName("GWD")
		cQuery += "  WHERE GWD_ZOCMUL = '" + oOcorrencia:OcorrenciaMultEmbarcador+ "'"
		cQuery += "  AND D_E_L_E_T_<> '*' "

		TcQuery changeQuery(cQuery) New Alias "cGWD"
		IF !cGWD->(EOF())
			aRet := {"1","Ocorrencia Multiembarcador já processada"}
		else
			oModel := FwLoadModel("GFEA032") // ABERTURA DO MODELO DE DADOS
			oModel:SetOperation(nOpc) // INFORMA A OPERAÇÃO
			If oModel:Activate() // ATIVA O MODELO

				If (oModel:GetOperation() == 3)

					oMdlGWD := oModel:GetModel("GFEA032_GWD")

					//preenche Ocorrencia GWD

					oMdlGWD:SetValue("GWD_DSOCOR",     Alltrim(oOcorrencia:Descricao) 	 )
					oMdlGWD:SetValue("GWD_CDTIPO",     Alltrim(oOcorrencia:Tipo)	  	 )
					oMdlGWD:SetValue("GWD_CDMOT",      Alltrim(oOcorrencia:Motivo)    	 )
					oMdlGWD:SetValue("GWD_DSPROB",     Alltrim(oOcorrencia:Problema)  	 )
					oMdlGWD:SetValue("GWD_DSSOLU",     Alltrim(oOcorrencia:Solucao)   	 )
					oMdlGWD:SetValue("GWD_DTOCOR",     oOcorrencia:DtOcorrencia 		 )
					oMdlGWD:SetValue("GWD_HROCOR",     oOcorrencia:HrOcorren 			 )
					oMdlGWD:SetValue("GWD_USUCRI",     Alltrim(oOcorrencia:UsrCriacao) 	 )
					oMdlGWD:SetValue("GWD_USUBAI",     Alltrim(oOcorrencia:UsrBaixa) 	 )
					oMdlGWD:SetValue("GWD_CDTRP",      Alltrim(oOcorrencia:Transportador))
					oMdlGWD:SetValue("GWD_ACAODC",     "2"								 )//Cancela Docto. de Carga?   1=Cancelar;2=Nenhuma
					oMdlGWD:SetValue("GWD_ACAODF",     "1"								 )//Acao sobre Docto de Frete? 1=Nenhuma Acao;2=Alertar;3=Bloquear
					oMdlGWD:SetValue("GWD_SITTMS",     "0"								 )//Situacao int. com SIGATMS?  0=Não de aplica;1=Não Enviada;2=Pendente;3=Rejeitada;4=Atualizada
					oMdlGWD:SetValue("GWD_ZVAL"  ,	    oOcorrencia:ValorEsp			 )
					oMdlGWD:SetValue("GWD_QTPERN",		oOcorrencia:QtServicos			 )
					oMdlGWD:SetValue("GWD_ZOCMUL",		oOcorrencia:OcorrenciaMultEmbarcador )

					If !Empty(oOcorrencia:PrestadorServico)
						oMdlGWD:SetValue("GWD_PRESTS",		Alltrim(oOcorrencia:PrestadorServico))
					EndIf

					//Preenche GWL - Notas Fiscais
					oMdlGWL := oModel:GetModel("GFEA032_GWL")
					For ni:= 1 to Len(oOcorrencia:NotasFiscais)

						DbSelectArea("GW1")
						GW1->(dbSetOrder(12))//GW1_DANFE  (*Chave NFE)
						If GW1->(dbSeek(alltrim(oOcorrencia:NotasFiscais[ni]:ChaveNfe)))
							cTipNF := Alltrim(GW1->GW1_CDTPDC)
							DbSelectArea("GWN")
							GWN->(DbSetOrder( 1 ))//GWN_FILIAL+GWN_NRROM
							If GWN->(DbSeek( GW1->GW1_FILIAL + GW1->GW1_NRROM ))
								If GWN->GWN_SIT <> "3"
									GFEA050LIB(.T.,"",Date(),SubStr(Time(), 1, 5)) //CHAMADA ROTINA PADRAO PARA LIBERAR O ROMANEIO
								EndIf
							EndIf
						EndIf

						If oMdlGWL:GetLine() <> ni
							oMdlGWL:AddLine()
						EndIf

						oMdlGWL:SetValue("GWL_FILIAL",      cxFil 												)
						oMdlGWL:SetValue("GWL_NROCO",       cOcor												)
						oMdlGWL:SetValue("GWL_NRDC",        Alltrim(oOcorrencia:NotasFiscais[ni]:NrDocCarga)	)
						oMdlGWL:SetValue("GWL_FILDC",       cxFil 												)
						oMdlGWL:SetValue("GWL_EMITDC",      Alltrim(oOcorrencia:NotasFiscais[ni]:EmissorDc) 	)
						oMdlGWL:SetValue("GWL_SERDC",       Alltrim(oOcorrencia:NotasFiscais[ni]:SerieDc) 		)
						oMdlGWL:SetValue("GWL_TPDC",        cTipNF 												)
						oMdlGWL:SetValue("GWL_SDOCDC",      Alltrim(oOcorrencia:NotasFiscais[ni]:SerieDc) 		)
						oMdlGWL:SetValue("GWL_SEQ",      	Alltrim(oOcorrencia:NotasFiscais[ni]:SeqTrecho) 	)

					Next ni

					// VALIDA AS INFORMAÇÕES
					If oModel:VldData()
						oModel:CommitData() // GRAVA AS INFORMAÇÕES
						aRet := {"1","Sucesso"}
					Else
						DisarmTransaction()
						//EndTran()

						aErro   := oModel:GetErrorMessage()

						// A estrutura do vetor com erro:
						//  [1] Id do formulario de origem
						//  [2] Id do campo de origem
						//  [3] Id do formulario de erro
						//  [4] Id do campo de erro
						//  [5] Id do erro
						//  [6] mensagem do erro
						//  [7] mensagem da solucao
						//  [8] Valor atribuido
						//  [9] Valor anterior

						cMsg:="Id do formulario de origem:"  + ' [' + AllToChar( aErro[1] ) + ']' + chr(13)+chr(10)
						cMsg+="Id do campo de origem: " 	 + ' [' + AllToChar( aErro[2] ) + ']' + chr(13)+chr(10)
						cMsg+="Id do formulario de erro: "   + ' [' + AllToChar( aErro[3] ) + ']' + chr(13)+chr(10)
						cMsg+="Id do campo de erro: " 		 + ' [' + AllToChar( aErro[4] ) + ']' + chr(13)+chr(10)
						cMsg+="Id do erro: " 				 + ' [' + AllToChar( aErro[5] ) + ']' + chr(13)+chr(10)
						cMsg+="Mensagem do erro: " 			 + ' [' + AllToChar( aErro[6] ) + ']' + chr(13)+chr(10)
						cMsg+="Mensagem da solucao: " 	 	 + ' [' + AllToChar( aErro[7] ) + ']' + chr(13)+chr(10)
						cMsg+="Valor atribuicao: " 			 + ' [' + AllToChar( aErro[8] ) + ']' + chr(13)+chr(10)
						cMsg+="Valor anterior: " 			 + ' [' + AllToChar( aErro[9] ) + ']' + chr(13)+chr(10)
						aRet := {"2",cMsg}

					EndIf

					oModel:DeActivate() // DESATIVA O MODELO
					//oModel:Destroy() // APÓS DESATIVADO, DESTRÓI O MESMO (EVITA PROBLEMAS DE REFERENCE COUNTER OVERFLOW)

				EndIf
			EndIf
			cFilAnt := cBkpFil
			//End Transaction
		ENDIF
	Else
		aRet := {"2","FILIAL INVALIDO FilialDoc : " + cxFil}
		DisarmTransaction()
	EndIf
	IF SELECT("cGWD") > 0
		cGWD->( dbCloseArea() )
	ENDIF
Return aRet

/*/{Protheus.doc} xMGFQFil
Função para retornar o codigo da Filial apartir do CNPJ
@type Function

@param cCnpj, String , CNPJ da Filial
@return cFil, String , Codigo da Filial

@author Joni Lima do Carmo
@since 24/07/2019
@version P12
/*/
static function xMGFQFil(cCnpj)

	Local cQuery
	LOCAL cFil := ""

	IF SELECT("cSM0") > 0
		cSM0->( dbCloseArea() )
	ENDIF

	cQuery := " SELECT M0_CODFIL FROM SYS_COMPANY "
	cQuery += "  WHERE M0_CGC = '" + cCnpj + "'"
	cQuery += "  AND SYS_COMPANY.D_E_L_E_T_<> '*' "

	IF SELECT("cSM0") > 0
		cSM0->( dbCloseArea() )
	ENDIF
	TcQuery changeQuery(cQuery) New Alias "cSM0"
	cFil := Alltrim(cSM0->M0_CODFIL)

	IF SELECT("cSM0") > 0
		cSM0->( dbCloseArea() )
	ENDIF

Return (cFil)