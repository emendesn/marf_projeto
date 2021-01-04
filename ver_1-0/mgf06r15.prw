#INCLUDE "totvs.ch" 

//����������������������������������������������������������������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
//���Programa  � MGF06R15	�Autor  � Geronimo Benedito Alves																	�Data �  16/04/18  ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Desc.		� Rotina que mostra na tela os dados da planilha: Financeiro -  Contas a Pagar - Relacao de Impostos				 (Modulo 06-FIN)	���
//���			� Os dados sao obtidos e mostrados na tela atravez da execucao de query, e depois, o usuario pode gerar uma planilha excel com eles ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Uso		� Cliente Global Foods																												���
//������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
//����������������������������������������������������������������������������������������������������������������������������������������������������

User Function MGF06R15()

	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery
	Private _nInterval
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""
	
	Aadd(_aDefinePl, "Contas a Pagar - Relacao de Impostos"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecera na regua de processamento.
	Aadd(_aDefinePl, "Relacao de Impostos"					)	//02-	_cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Relacao de Impostos"}				)	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Relacao de Impostos"}				)	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}										)	//05-	Array de Arrays que define quais colunas serao mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, sera mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }							)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluido naquela aba  
	_nInterval	:= 180											//		Intervalo maximo de dias permitido entre a data Inicial e a Data Final
	_aCpoExce	:= {}
	_cTmp01		:= ""								

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou � usado alguma funcao (Sum,Count,max,Coalesc,etc), � dado a ele um apelido indicado    
	//pela clausula "as" que sera transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sao sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serao preservados.
	//					01			 02								 03						 04	 05	  	 06	 07						 08	 	09		
	Aadd(_aCampoQry, {"E2_FILIAL"	,"FILIAL"						,"Cod. Filial"			,"C",006	,0	,""						,""		,""	 })
	Aadd(_aCampoQry, {"A2_CGC"		,"CNPJ"							,"CNPJ"					,"C",018	,0	,"@!"					,""		,"@!"})	
	Aadd(_aCampoQry, {"A2_NOME"		,"FORNECEDOR"					,"Nome Fornecedor"		,"C",040	,0	,""						,""	  	,""	 })
	Aadd(_aCampoQry, {"E2_LOJA"		,"LOJA"							,"Loja"					,"C",002	,0	,""						,""		,""	 })
	Aadd(_aCampoQry, {"E2_PREFIXO"	,"PREFIXO"						,"Prefixo"				,"C",003	,0	,""						,""		,""	 })
	Aadd(_aCampoQry, {"E2_TIPO"		,"TITULO"						,"Titulo"				,"C",009	,0	,""						,""		,""	 })
	Aadd(_aCampoQry, {"E2_NUM"		,"PARCELA"						,"N� Parcela"			,"C",002	,0	,""						,""		,""	 })
	Aadd(_aCampoQry, {"E2_PARCELA"	,"TIPO"							,"Tipo"					,"C",003	,0	,""						,""		,""	 })
	Aadd(_aCampoQry, {"E2_NATUREZ"	,"NATUREZA"						,"Natureza"				,"C",010	,0	,""						,""		,""	 })
	Aadd(_aCampoQry, {"ED_DESCRIC"	,"DESCRICAO"					,"Descricao"			,"C",030	,0	,""						,""		,""	 })
	Aadd(_aCampoQry, {"E2_EMISSAO"	,"EMISSAO"						,"Data Emissao"			,"D",008	,0	,""						,""		,""	 })
	Aadd(_aCampoQry, {"E2_VENCTO" 	,"VENCIMENTO"					,"Data Vencimento"		,"D",008	,0	,""						,""		,""	 })
	Aadd(_aCampoQry, {"E2_VENCREA"	,"VENCIMENTO_REAL as VENCI_REAL","Dt. Vencimento Real"	,"D",008	,0	,""						,""		,""	 })
	Aadd(_aCampoQry, {"E2_VALOR"	,"VALOR"						,"Valor"				,"N",017	,2	,"@E 99,999,999,999.99"	,""		,""	 })
	
	aAdd(_aParambox,{1,"Dt Vencimento Inicial"	,Ctod("")						,""		,"" 												,""		,"",050,.T.})
	aAdd(_aParambox,{1,"Dt Vencimento Final"	,Ctod("")						,""		,"U_VLDTINIF(MV_PAR01, MV_PAR02, _nInterval)"		,""		,"",050,.T.})
	aAdd(_aParambox,{1,"Cod. Natureza Inicial"	,Space(tamSx3("E1_NATUREZ")[1])	,"@!"	,"" 												,"SED"	,"",050,.F.})  
	aAdd(_aParambox,{1,"Cod. Natureza Final"	,Space(tamSx3("E1_NATUREZ")[1])	,"@!"	,"U_VLFIMMAI(MV_PAR03, MV_PAR04, 'Cod. Natureza')"	,"SED"	,"",050,.F.})													

	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	_cQuery += " FROM " + U_IF_BIMFR( "IF_BIMFR", "V_CP_RELACAOIMPOSTOS" ) + CRLF
	_cQuery += U_WhereAnd( !empty(_aRet[2] ),     " VENCIMENTO BETWEEN '"  + _aRet[1] + "' AND '" + _aRet[2] + "' " ) // OBRIGATORIO, COM A VALIDACAO DE 180 DIAS
	_cQuery += U_WhereAnd( !empty(_aRet[4] ),     " NATUREZA BETWEEN '"    + _aRet[3] + "' AND '" + _aRet[4] + "' " ) // NAO OBRIGATORIO

	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
RETURN