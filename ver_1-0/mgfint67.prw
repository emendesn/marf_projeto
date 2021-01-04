#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#include "parmtype.ch"
#include "totvs.ch"
#include "fwbrowse.ch"
#include 'fwmvcdef.ch'

#DEFINE CRLF CHR(13)+CHR(10)

//-----------------------------------------------------------
User Function MGFINT67()
//-----------------------------------------------------------
/*/{Protheus.doc} MGFINT67()
Gera informa��es de titulos em arquivo txt para envio ao serasa.
@param xParam Parameter DescriptionuSER
@return xRet Return Description
@author Jose Roberto - TOTVS 
@since 20/08/2019
/*/

Local _oProcess
Local _aAreaMem := GetArea()
Local _bProcess := {|_oSelf| EXECUTA(_oSelf) }
Local cPerg    	:= "FINT67"
Local _aInfo    := {}
Private cTit := ""
//Gera o arquivo de remessa 

_oProcess := tNewProcess():New(cPerg, "Serasa Relato Reciprocidade", _bProcess, "Rotina respons�vel pela gera��o do arquivo SERASA RECIPROCIDADE.", cPerg, _aInfo, .T., 5, "Gera arquivo Serasa Relato Reciprocidade.", .T.)

RestArea(_aAreaMem)

Return

//-----------------------------------------------------------
Static Function EXECUTA(_oRegua)
//-----------------------------------------------------------
Local _nHdl     := 0
Local _cQuery   := ''
Local _nTitulos := 0
Local _cDtIni   := DtoS(MV_PAR05)				//DtoS(dDataBase - 6) //Periodo Semanal
Local _cDtIni   := DtoS(MV_PAR05)				//DtoS(dDataBase - 60) //Periodo Semanal
Local _cDtFim   := DtoS(MV_PAR06)				//DtoS(dDataBase)
Local _cTipCli  := ''
Local _aTipoTit := Separa(SuperGetMV('MV_TIPSERA',, 'NF'), ';') // Tipos de titulos separados por ponto e virgula.
Local _cTipos   := ''
Local _nT       := 0
Local aTitDupl	:= {} 
Local nAchei	:= 0 
Local cMsgZEL	:= ""
Local _cArq		:= ""
Local _nRegs    := 0 
Local cCodEmp   := FWCodEmp() // C�digo da empresa atual
Private _cCNPJCO := MV_PAR07  // CNPJ Matriz. 

// n�o permite gerar arquivos em duplicidade. MV_PAR05 E MV_PAR06
_cQuery := "SELECT DISTINCT ZEL_ARQ " + CRLF
_cQuery += "FROM " + RetSqlName("ZEL")  + CRLF
_cQuery += "WHERE " + CRLF
_cQuery += "D_E_L_E_T_ <> '*' " + CRLF
_cQuery += "AND ZEL_DE  >= '" + _cDtIni + "' " + CRLF
_cQuery += "AND ZEL_ATE <= '" + _cDtFim + "' " + CRLF

If Select("MFGZEL") > 0
	dbCloseArea("MFGZEL")
EndIf 

TcQuery _cQuery New Alias "MFGZEL"

MFGZEL->(DbGoTop())
While MFGZEL->(!eof())
	cMsgZEL += alltrim(MFGZEL->ZEL_ARQ)+" " 
	MFGZEL->(dbSkip())
EndDo

If !Empty(cMsgZEL)
	If !MsgNoYes("JA FOI GERADO ARQUIVO COM ESTE PERIODO "+CRLF+CRLF+" DATA INICIAL : "+dtoc(stod(_cDtIni)) + "    DATA FINAL: "+dtoc(stod(_cDtFim)) + " -  "+CRLF+ALLTRIM(cMsgZEL)+CRLF+CRLF+"DESEJA GERAR O ARQUIVO NOVAMENTE ? "  )
		If Select("MFGZEL") > 0
			dbCloseArea("MFGZEL")
		EndIf  
		Return
	Else
		cQuery := ""
		cQuery += "UPDATE  "+ RetSqlName("ZEL") + " " + CRLF
		cQuery += "SET R_E_C_D_E_L_ =  R_E_C_N_O_ , D_E_L_E_T_ = '*' "  + CRLF
		cQuery += "WHERE ZEL_DE = '"+_cDtIni+"' " + CRLF
		cQuery += "AND ZEL_ATE  = '"+_cDtFim+"' " + CRLF
		TCSQLExec(cQuery)
	EndIf 
EndIf 

If Select("MFGZEL") > 0
	dbCloseArea("MFGZEL")
EndIf  

If !MsgYesNo("SERASA RECIPROCIDADE - REMESSA" + CRLF + CRLF + "Este processamento pode demorar alguns minutos por conta do volume da base de dados, deseja continuar?","")
	return
EndIf 

_nHdl := FCreate(AllTrim(mv_par03))

If _nHdl == -1
	ApMsgInfo("Ocorreu um erro na cria��o do arquivo. Por favor, tente novamente.")
	Return
Else
	If Len(_aTipoTit) > 0
		For _nT := 1 To Len(_aTipoTit)
			If _nT > 1
				_cTipos += ", "
			EndIf 
			_cTipos += "'" + AllTrim(_aTipoTit[_nT]) + "'"
		Next _nT
	EndIf 

	// Titulos ativos e em aberto.
	_cQuery := "SELECT DISTINCT A1_COD,A1_LOJA,A1_CGC,A1_DTNASC,A1_PRICOM,A1_DTCAD,A1_MSBLQL, "+CRLF
    _cQuery += "                E1_FILIAL,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO,E1_VENCTO, "+CRLF
    _cQuery += "                E1_EMISSAO,E1_VALOR VALOR,E1_BAIXA BAIXA,E1_SALDO SALDO, "+CRLF
    _cQuery += "                'S' TITATIVO,'01' SEQ,'ENTRADA' TIPOREG "+CRLF
	_cQuery += "FROM "+RetSqlName('SE1')+" SE1 "+CRLF
	_cQuery += "INNER JOIN "+RetSqlName('SA1')+" SA1 ON SA1.D_E_L_E_T_ <> '*' "+CRLF
	_cQuery += "AND SA1.A1_COD = SE1.E1_CLIENTE AND SA1.A1_LOJA = SE1.E1_LOJA AND SA1.A1_PESSOA = 'J' "+CRLF // Somente pessoa juridica.
	_cQuery += "WHERE SE1.D_E_L_E_T_ <> '*' "+CRLF
	_cQuery += "AND SE1.E1_PREFIXO NOT IN ('EEC') "+CRLF   	// - Exporta��o
	_cQuery += "AND SE1.E1_TIPO NOT IN ('NCC','RA ','PR ') "+CRLF // Retira recebimento antecipado, nota de cr�dito do cliente e titulo provis�rio.
	_cQuery += "AND SE1.E1_TIPO IN ("+_cTipos+") "+CRLF 	// Considera somente os tipos de titulos do parametro SE_TIPSERA.
	_cQuery += "AND SE1.E1_CLIENTE BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "+CRLF
	_cQuery += "AND SE1.E1_EMISSAO BETWEEN '"+_cDtIni+"' AND '"+_cDtFim+"' "+CRLF
	_cQuery += "AND SE1.E1_SALDO > 0 "+CRLF // Tratamento para titulos em aberto.
	_cQuery += "AND SE1.E1_BAIXA = ' ' "+ CRLF
	_cQuery += "AND SA1.A1_CGC <> ' ' "+ CRLF
	_cQuery += "AND SUBSTR(SE1.E1_FILIAL,1,2) = '"+AllTrim(cCodEmp)+"' "+CRLF

	_cQuery += "UNION ALL " + CRLF

	// Movimento - Considera Saldo e Vencimento diferentes dos enviados
	_cQuery += "SELECT DISTINCT A1_COD,A1_LOJA,A1_CGC,A1_DTNASC,A1_PRICOM,A1_DTCAD,A1_MSBLQL, "+CRLF
    _cQuery += "                E1_FILIAL,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO,E1_VENCTO, "+CRLF
    _cQuery += "                E1_EMISSAO,E1_VALOR VALOR,E1_BAIXA BAIXA,E1_SALDO SALDO, "+CRLF
	_cQuery += "                'N' TITATIVO, '01' SEQ,'MOVIMENTO' TIPOREG "+CRLF
	_cQuery += "FROM "+RetSqlName('SE1')+" SE1 "+CRLF
	_cQuery += "INNER JOIN "+RetSqlName('SA1')+" SA1 ON SA1.D_E_L_E_T_ <> '*' "+CRLF
	_cQuery += "AND SA1.A1_COD = SE1.E1_CLIENTE AND SA1.A1_LOJA = SE1.E1_LOJA AND SA1.A1_PESSOA = 'J' "+CRLF 
	_cQuery += "WHERE SE1.D_E_L_E_T_ <> '*' "+CRLF // Registros deletados.
	_cQuery += "AND SE1.E1_PREFIXO NOT IN ('EEC') "+CRLF // - Exporta��o
	_cQuery += "AND SE1.E1_TIPO NOT IN ('NCC','RA ','PR ') "+CRLF // Retira recebimento antecipado, nota de cr�dito do cliente e titulo provis�rio.
	_cQuery += "AND SE1.E1_TIPO IN ("+_cTipos+") "+CRLF // Considera somente os tipos de titulos do parametro SE_TIPSERA.
	_cQuery += "AND SE1.E1_CLIENTE BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "+CRLF
	_cQuery += "AND SE1.E1_EMISSAO = '"+_cDtFim+"' "+CRLF
	_cQuery += "AND SE1.E1_BAIXA = '"+_cDtFim+"' "+CRLF
	_cQuery += "AND SUBSTR(SE1.E1_FILIAL,1,2) = '"+AllTrim(cCodEmp)+"' "+CRLF
	_cQuery += "AND SA1.A1_CGC <> ' ' "+CRLF

	_cQuery += "UNION ALL "+CRLF

	// Titulos cancelados.
	_cQuery += "SELECT DISTINCT A1_COD,A1_LOJA,A1_CGC,A1_DTNASC,A1_PRICOM,A1_DTCAD,A1_MSBLQL, "+CRLF
    _cQuery += "                E1_FILIAL,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO,E1_VENCTO, "+CRLF
    _cQuery += "                E1_EMISSAO,E1_VALOR VALOR,E1_BAIXA BAIXA,E1_SALDO SALDO, "+CRLF
	_cQuery += "                'N' TITATIVO, '01' SEQ,'CANCELA' TIPOREG "+CRLF
	_cQuery += "FROM "+RetSqlName('SE1')+" SE1 "+CRLF
	_cQuery += "INNER JOIN "+RetSqlName('SA1')+" SA1 ON SA1.D_E_L_E_T_ <> '*' "+CRLF
	_cQuery += "AND SA1.A1_COD = SE1.E1_CLIENTE AND SA1.A1_LOJA = SE1.E1_LOJA AND SA1.A1_PESSOA = 'J' "+CRLF 
	_cQuery += "WHERE SE1.D_E_L_E_T_ = '*' "+CRLF // Registros deletados.
	_cQuery += "AND SE1.E1_PREFIXO NOT IN ('EEC') "+CRLF   	// - Exporta��o
	_cQuery += "AND SE1.E1_TIPO NOT IN ('NCC','RA ','PR ') "+CRLF  // Retira recebimento antecipado, nota de cr�dito do cliente e titulo provis�rio.
	_cQuery += "AND SE1.E1_TIPO IN ("+_cTipos+") "+CRLF // Considera somente os tipos de titulos do parametro SE_TIPSERA.
	_cQuery += "AND SE1.E1_CLIENTE BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "+CRLF
	_cQuery += "AND SE1.E1_EMISSAO = '"+ _cDtFim + "' "+CRLF
	_cQuery += "AND SA1.A1_CGC <> ' ' "+CRLF
	_cQuery += "AND SUBSTR(SE1.E1_FILIAL,1,2) = '"+AllTrim(cCodEmp)+"' "+CRLF
	_cQuery += "ORDER BY A1_CGC "+CRLF

	MemoWrite("C:\TEMP\MFGSERA_"+DtoS(dDataBase)+".SQL",_cQuery)

	TcQuery _cQuery New Alias 'MFGSERA'
	dbSelectArea('MFGSERA')
	MFGSERA->(DbGoTop())

	If MFGSERA->(!EOF())

		// MOVIMENTO ENVIADO PELA EMPRESA � SERASA.
		HEADER01(_nHdl, _cDtIni, _cDtFim)

		While MFGSERA->(!EOF())
			_oRegua:IncRegua1('Processando registros...')

			_cCNPJ := MFGSERA->A1_CGC

			If     MFGSERA->A1_MSBLQL == 'S'
				   _cTipCli := '3' // 3 = Inativo.
			ElseIf (SToD(MFGSERA->A1_DTCAD)+365) <= dDataBase
				   _cTipCli := '2' // 2 = Menos de um ano.
			Else
				   _cTipCli := '1' // 1 = Antigo.
			EndIf 

			// TEMPO DE RELACIONAMENTO.
			// DEVER� SER FORMATADO SOMENTE PARA REMESSA NORMAL.
			CLIENTE(_nHdl, _cTipCli)
			_nRegs++

			While MFGSERA->A1_CGC == _cCNPJ

				// TITULOS.
				cTit := PADL(SubStr(MFGSERA->E1_NUM,4,6)+SubStr(MFGSERA->E1_PARCELA,1,2)+SubStr(MFGSERA->SEQ,1,3),10)
				TITULOS(_nHdl,MFGSERA->VALOR,MFGSERA->BAIXA,cTit)
				_nTitulos++

				MFGSERA->(dbSkip())

			EndDo

		EndDo

		// TRAILLER.
		TRAILLER(_nHdl, _nRegs, _nTitulos)
		FClose(_nHdl)
		//_oRegua:SaveLog("Arquivo gerado com sucesso. Usu�rio: " + AllTrim(UsrRetName(__cUserID)) + ". Caminho: " + _cPasta1 + _cPasta2 + _cArqTxt)
		_oRegua:SaveLog("Arquivo gerado com sucesso. Usu�rio: " + AllTrim(UsrRetName(__cUserID)) + ". Caminho: " + MV_PAR03)
	
	Else
		_oRegua:SaveLog("N�o foram encontrados registros para gera��o do arquivo.")
	EndIf 
	
	MFGSERA->(DbCloseArea())

EndIf

If File(AllTrim(Mv_Par03)) 
 	ApMsgInfo("ARQUIVO GERADO COM SUCESSO !")
EndIf 

Return

//-----------------------------------------------------------
Static Function HEADER01(_nHdl, _cDtIni, _cDtFim)
//-----------------------------------------------------------
Local _cLinha := ''

// MOVIMENTO ENVIADO PELA EMPRESA � SERASA.
_cLinha := '00' 							// 001 - 002 || Identifica��o Registro Header = 00.
_cLinha += PadR('RELATO COMP NEGOCIOS', 20) // 003 - 022 || Constante = 'RELATO COMP NEGOCIOS'.
_cLinha += _cCnpjCO	 						// 023 - 036 || CNPJ Empresa Conveniada.
_cLinha += _cDtIni 							// 037 - 044 || Data In�cio do Per�odo Informado : AAAAMMDD.
_cLinha += _cDtFim 							// 045 - 052 || Data Final do Per�odo Informado : AAAAMMDD.
_cLinha += If (MV_PAR04 == 2,'D','S')		// 053 - 053 || Periodicidade da remessa. Indicar a constante conforme a periodicidade D=Di�rio S=Semanal.
_cLinha += Space(15) 						// 054 - 068 || Reservado Serasa.
_cLinha += '017' 							// 069 - 071 || N�mero identIf icador do Grupo Relato Segmento ou brancos.
_cLinha += Space(29) 						// 072 - 100 || Brancos.
_cLinha += 'V.' 							// 101 - 102 || Identifica��o da Vers�o do Layout => Fixo = "V."
_cLinha += '01' 							// 103 - 104 || N�mero da Vers�o do Layout => Fixo = "01".
_cLinha += Space(26) 						// 105 - 130 || Brancos.
_cLinha += CHR(13) + CHR(10)
FWrite(_nHdl, _cLinha)
Return

//-----------------------------------------------------------
Static Function CLIENTE(_nHdl, _cTipCli)
//-----------------------------------------------------------
Local _cLinha := ''
// TEMPO DE RELACIONAMENTO.
// DEVER� SER FORMATADO SOMENTE PARA REMESSA NORMAL.
_cLinha := '01' 					// 001 - 002 || Identifica��o do Registro de Dados = 01.
_cLinha += MFGSERA->A1_CGC 		    // 003 - 106 || Sacado Pessoa jur�dica: CNPJ Empresa Cliente (Sacado).
_cLinha += '01' 					// 017 - 018 || Tipo de Dados = 01 (Tempo de Relacionamento para Sacado Pessoa jur�dica).
_cLinha += MFGSERA->A1_DTCAD 		// 019 - 026 || Cliente Desde: AAAAMMDD.
_cLinha += _cTipCli 				// 027 - 027 || Tipo de Cliente: 1 = Antigo; 2 = Menos de um ano; 3 = Inativo.
_cLinha += Space(38) 				// 028 - 065 || Brancos.
_cLinha += Space(34) 				// 066 - 099 || Brancos.
_cLinha += Space(1) 				// 100 - 100 || Brancos.
_cLinha += Space(30) 				// 101 - 130 || Brancos.
_cLinha += CHR(13) + CHR(10)
FWrite(_nHdl, _cLinha)
Return

//-----------------------------------------------------------
Static Function TITULOS(_nHdl, _nValor, _cBaixa, _cNumTit)
//-----------------------------------------------------------
Local _cLinha  := ""
Local _cTitNum := ""

//Detalhe dos titulos
_cLinha	:= "01" 			// 001 - 002 || Identifica��o do Registro de Dados = 01.
_cLinha	+= MFGSERA->A1_CGC 	// 003 - 016 || Sacado Pessoa jur�dica: CNPJ Empresa Cliente (Sacado).
_cLinha	+= "05"  			// 017 - 018 || Tipo de Dados = 05 (T�tulos � Para Sacado Pessoa jur�dica).

If ValType(_cNumTit) <> "C"
	cTipVal := ValType(_cNumTit)
	MsgInfo(" variavel com tipo diferente. " + cTipVal )
EndIf 

_cLinha	+= _cNumTit 						// 019 - 028 || N�mero do T�tulo com at� 10 posi��es.
_cLinha	+= MFGSERA->E1_EMISSAO				// 029 - 036 || Data da Emiss�o do T�tulo: AAAAMMDD.

If MFGSERA->TIPOREG <> 'CANCELA'
	_cLinha += StrZero(_nValor * 100, 13) 		// 037 - 049 || Valor do T�tulo, com 2 casas decimais. Ajuste � direita com zeros � esquerda. Formatar 9999999999999 para exclus�o do T�tulo.
Else
	_cLinha += '9999999999999' 					// 037 - 049 || Enviar 9 neste campo para caracterizar exclus�o do titulo no SERASA.
EndIf 

/*
Forma��o da posi��o 066 a 099 
#D : indica N�mero do T�tulo. 
Obs.: O "#D" pode ser utilizado quando o N�mero do T�tulo for maior que dez posi��es. 
Se for informado "#D" nas posi��es 66 e 67, o sistema desprezar� o conte�do das posi��es 19 a 28 
(N�mero do T�tulo), e considerar� como N�mero do T�tulo o N�mero informado nas posi��es 68 a 99.
*/
_cTitNum := PadR("#D"+MFGSERA->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO),34)

_cLinha	+= MFGSERA->E1_VENCTO 	// 050 - 057 || Data de Vencimento: AAAAMMDD.
_cLinha	+= _cBaixa	 			// 058 - 065 || Data de Pagamento: AAAAMMDD ou Brancos. 
                                //              No arquivo de Concilia��o enviado pela Serasa 
								//              esta informa��o estar� com o conte�do 99999999. 
								//              No arquivo de Concilia��o a ser enviado para a Serasa 
								//              esta informa��o dever� ser formatada com a Data de 
								//              Pagamento do T�tulo OU com Brancos, 
								//              se o T�tulo n�o foi pago.
_cLinha	+= _cTitNum 			// 066 - 099 || N�mero do T�tulo com mais de 10 posi��es:
_cLinha	+= Space(1) 			// 100 - 100 || Brancos.
_cLinha	+= Space(24) 			// 101 - 124 || Reservado Serasa.
_cLinha	+= Space(2) 			// 125 - 126 || Reservado Serasa.
_cLinha	+= Space(1) 			// 127 - 127 || Reservado Serasa.
_cLinha	+= Space(1) 			// 128 - 128 || Reservado Serasa.
_cLinha	+= Space(2) 			// 129 - 130 || Reservado Serasa.
_cLinha	+= (CHR(13)+CHR(10))
FWrite(_nHdl, _cLinha)

//Guardando registro da remessa para poder fazer remessas de futuras baixas. 
Begin Transaction
    ZEL->(dbSetOrder(1))

	If !ZEL->(dbSeek(MFGSERA->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)))
	
		ZEL->(RecLock("ZEL",.T.))
		ZEL->ZEL_FILIAL	:= MFGSERA->E1_FILIAL
		ZEL->ZEL_CNPJ	:= MFGSERA->A1_CGC

		// posicionando a tabela de cliente para pegar o codigo. 
		SA1->(dbSetOrder(3))
	
		If SA1->(dbSeek(xFilial("SA1")+MFGSERA->A1_CGC))
			ZEL->ZEL_CLI		:= SA1->A1_COD
			ZEL->ZEL_LOJA		:= SA1->A1_LOJA
		else 
			ZEL->ZEL_CLI		:= " "
			ZEL->ZEL_LOJA		:= " "
		EndIf 

		ZEL->ZEL_PREFIX		:= MFGSERA->E1_PREFIXO
		ZEL->ZEL_NUM   		:= MFGSERA->E1_NUM
		ZEL->ZEL_PARCEL		:= MFGSERA->E1_PARCELA
		ZEL->ZEL_TIPO  		:= MFGSERA->E1_TIPO
		ZEL->ZEL_VENCT		:= STOD(MFGSERA->E1_VENCTO)
		ZEL->ZEL_SALDO 		:= MFGSERA->SALDO
		ZEL->ZEL_DATA		:= dDatabase
		ZEL->ZEL_DE			:= MV_PAR05
		ZEL->ZEL_ATE		:= MV_PAR06
		ZEL->ZEL_ARQ		:= MV_PAR03
		ZEL->ZEL_LINHA		:= _cLinha
		
		ZEL->(msUnlock("ZEL"))
	
	EndIf	
End Transaction 

Return

//-----------------------------------------------------------
Static Function TRAILLER(_nHdl, _nRegs, _nTitulos)
//-----------------------------------------------------------
Local _cLinha := ''

// TRAILLER
_cLinha := "99" 					// 001 - 002 || Identifica��o do Registro Trailler = 99.
_cLinha += StrZero(_nRegs,11)       // 003 - 013 || Quantidade de Registros 
                                    //              01-Tempo de Relacionamento PJ. 
									//              Ajuste � direita com zeros � esquerda 
									//              Para remessa de Concilia��o formatar zeros.
_cLinha += Space(44) 				// 014 - 057 || Brancos.
_cLinha += StrZero(_nTitulos,11) 	// 058 - 068 || Quantidade de Registros 
                                    //              05 - T�tulos PJ. 
									//              Ajuste � direita com zeros � esquerda.
_cLinha += Space(11) 				// 069 - 079 || Reservado Serasa.
_cLinha += Space(11) 				// 080 - 090 || Reservado Serasa.
_cLinha += Space(10) 				// 091 - 100 || Reservado Serasa.
_cLinha += Space(30) 				// 101 - 130 || Brancos.
_cLinha += CHR(13) + CHR(10)
FWrite(_nHdl, _cLinha)

Return

//---------------------------------------------------------------------------------------------------------------


//--------------------------------------------------
User Function Sel_Arq() 
//--------------------------------------------------
MV_PAR01 := "C:\Temp\serasa_reciprocidade_ret.txt"

If Empty(MV_PAR01) 
	APMsgInfo("Arquivo de retorno da SERASA n�o informado" )
	Return
EndIf 

If !file(MV_PAR01)
	APMsgInfo("Arquivo de retorno da SERASA n�o encontrado.")
EndIf 

fwMsgRun(, {| oSay | impArq( oSay ) }, "Processando", "Aguarde. Processando arquivo..." )

APMsgInfo("Importa��o finalizada.")

//Mostrar resultado do retorno.
//Mostar em video e imprimir se desejar 

return



//------------------------------------------------------
Static Function ImpArq( oSay )
//------------------------------------------------------
local nOpen			:= FT_FUSE(AllTrim(MV_PAR01))
local nLast			:= 0
local cLinha		:= ""
local nLinAtu		:= 0

private aLinha		:= {}
private cLogErrors	:= ""
private cLogOk		:= ""
private cLogAll		:= ""

If nOpen < 0
	Alert("Falha na abertura do arquivo.")
else
	//O arquivo deve estar na pasta para processamento

	//If !msgYesNo("A importa��o Referdeste arquivo ir� sobrepor a amarra��o atual de Clientes x Tabela de Pre�o. Deseja prosseguir?", "Altera��o Clientes da Tabela")
	//	return
	//EndIf 

	FT_FGOTOP()
	nLast := FT_FLastRec()
	FT_FGOTOP()

	While !FT_FEOF()
		nLinAtu++
		oSay:cCaption := ( "Importando item " + str( nLinAtu ) + " de " + str( nLast ) )
		cLinha := ""
		cLinha := FT_FREADLN()
		//Mensagem de processamento do arquivo 
		//no registro 77, caso o numero da mensagem seja 01-(Remessa ok), capturar  a mensagem  na posi��o 05 e encerrar o processamento. 
		// caso seja 02 (remessa n�o ok, processar indicando os erros para o relat�rio)
		If substr(cLinha,01,02) = '77'
			MsgInfo("IDENTIFICADO ARQUIVO DE RETORNO INTEGRACAO SERASA RECIPROCIDADE        ")
		
			If substr(cLinha,03,02) = '01'
				//tudo certo
				MsgInfo("MENSAGEM DE ERRO 01 - TUDO CERTO NA INTEGRACAO ")

			elseIf substr(cLinha,03,02) = '02'
				//tem erro, mostrar 
				MsgInfo("MENSAGEM DE ERRO 02 - ENCONTRADAS NAO CONFORMIDADES  ")
			
			EndIf 
		EndIf 
		
		If substr(cLinha,01,02) = '85'
			MsgInfo("MENSAGEM DE ERRO 85 ENCONTRADA ")
			//identIf icar o registro com erro e apresentar no relatorio 
		EndIf 
		
		// Processamento para criticas do arquivo e acumular em array para relatorio. 
		If substr(cLinha,01,02) = '88'
			//identIf icar o registro com erro e apresentar no relatorio 
			MsgInfo("MENSAGEM DE ERRO 88 ENCONTRADA ")
		EndIf 
	
		FT_FSKIP()
	EndDo
EndIf 
return

//----------------------------------------------------------------------
User Function MGFinConc(oRegua)
//----------------------------------------------------------------------
//Esta fun��o tem como finalidade fazer a leitura do arquivo 
//disponibilizado pela SERASA, com o objetivo de conciliar o movimento
//de titulos enviados anteriormente no arquivo Remessa. 
//Utiliza o mesmo layout, mas os campos de data de pagamento
//cont�m uma sequecia de (999999999), que indica que as datas devem sofrer 
//manuten��o conforme consulta na base de dados. 
// 

Local oProcX
Local _aAreaMem  := GetArea()
Local _bProcX    := {|_oSelf| FINCONCX(_oSelf) }
Local cPerg    	 := "FINT67A"
Local _aInfo     := {}
Private cTit     := ""
//Gera o arquivo de remessa 
oProcX 		:= tNewProcess():New(cPerg, "Serasa Relato Reciprocidade - Concilia", _bProcX, "Rotina respons�vel pela Concilia��o do arquivo enviado pela SERASA, atualizando datas de pagamentos dos dados enviados pelo arquivo REMESSA.", cPerg, _aInfo, .T., 5, "Gera arquivo Serasa Relato Reciprocidade.", .T.)

//processa arquivo retorno
//U_Sel_Arq()

//processa concilia
//u_MGFinConc()

RestArea(_aAreaMem)

//--------------------------------------------------------------------------------
Static Function FinConcX(oRegua) 
//--------------------------------------------------------------------------------
Private nHdl_Conciliado := Nil  

//Criando arquivo com os dados conciliados. 
//nHdl_Conciliado := FCreate( AllTrim("c:\temp\serasa_reciprocidade_conciliado.txt") )
nHdl_Conciliado := FCreate( AllTrim(MV_PAR02) )

//Abrindo arquivo enviado pelo SERASA - Concilia
//MV_PAR01 := "C:\Temp\serasa_reciprocidade_concilia.txt"

If Empty(MV_PAR01) 
	APMsgInfo("Arquivo de retorno da SERASA n�o informado" )
	Return
EndIf 

If !file(MV_PAR01)
	APMsgInfo("Arquivo de retorno-reconcilia��o da SERASA n�o encontrado.")
EndIf 

//fwMsgRun(, {| oSay | FinConc( oSay ) }, "Processando", "Aguarde. Processando arquivo..." )
FinConc(oRegua)
APMsgInfo("Concilia��o finalizada com sucesso. ")

Return


//------------------------------------------------------
Static Function FinConc(oRegua)
//------------------------------------------------------
local nOpen			:= FT_FUSE(AllTrim(MV_PAR01))
local nLast			:= 0
local cLinha		:= ""
Local cLinha_r      := ""
local nLinAtu		:= 0
local cDataBaixa    := Space(08)

private aLinha		:= {}

If nOpen < 0
	MsgStop("Falha na abertura do arquivo.")
else
	FT_FGOTOP()
	nLast := FT_FLastRec()
	FT_FGOTOP()
	
	//verIf icando se trata-se de um arquivo de Concilia��o 
	cLinha := ""
	cLinha := FT_FREADLN()

	If at("CONCILIA",cLinha) =  0
		MsgStop("ESTE N�O � UM ARQUIVO DE CONCILIA��O.")
		Return
	EndIf 
	FT_FGOTOP()

	While !FT_FEOF()
		nLinAtu++

		//oSay:cCaption := ( "Importando item " + str( nLinAtu ) + " de " + str( nLast ) )
		oRegua:IncRegua1('Processando registros...')

		cLinha := ""
		cLinha := FT_FREADLN()

		//Localizar titulo na base e atualizar informacao de pagamento 
		If at("#D",cLinha) == 0
			cLinha_r := cLinha + (CHR(13)+CHR(10)) 	
			//gravando novo arquivo remessa-Concilia��o
			FWrite(nHdl_Conciliado, cLinha_r)
		else 
			SE1->(dbSetOrder(1))   //E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
			If SE1->(dbSeek(substr(cLinha, at("#D",cLinha)+2,32)))
				cDataBaixa := DtoS(SE1->E1_BAIXA)
			else                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
				cDataBaixa := Space(8)
			EndIf 
			//remontando a linha para regravar o arquivo
			cLinha_r := substr(cLinha,1,57)+cDataBaixa+substr(cLinha,66,(130-64))+(CHR(13)+CHR(10))
			//gravando novo arquivo remessa-Concilia��o
			FWrite(nHdl_Conciliado, cLinha_r)
		EndIf 
		FT_FSKIP()
	EndDo
EndIf 

FClose(nHdl_conciliado)
MsgInfo("Arquivo de CONCILIADO  - Serasa Reciprocidade,  gerado com sucesso. ")

return