#INCLUDE "totvs.ch" 

//����������������������������������������������������������������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
//���Programa  � MGF06R17	�Autor  � Geronimo Benedito Alves																	�Data �  23/04/18  ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Desc.		� Rotina que mostra na tela os dados da planilha: Financeiro -  Contas a Receber - Relacao de Clientes				(Modulo 06-FIN)���
//���			� Os dados sao obtidos e mostrados na tela atravez da execucao de query, e depois, o usuario pode gerar uma planilha excel com eles���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Uso		�  Global Foods																											   ���
//������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
//����������������������������������������������������������������������������������������������������������������������������������������������������

User Function MGF06R17()

	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""
	
	Aadd(_aDefinePl, "Contas a Receber - Relacao de Clientes"	)	//01-  _cTitulo	- Titulo da planilha a ser gerada. Aparecer� na regua de processamento.
	Aadd(_aDefinePl, "Relacao de Clientes"						)	//02-  _cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Relacao de Clientes"}					)	//03-  _cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Relacao de Clientes"}					)	//04-  _cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}											)	//05-	Array de Arrays que define quais colunas serao mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, sera mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }								)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluido naquela aba  

	_aCpoExce	:= {}
	_cTmp01		:= ""								

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou � usado alguma funcao (Sum,Count,max,Coalesc,etc), � dado a ele um apelido indicado    
	//pela clausula "as" que sera transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sao sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serao preservados.
	//					01			 02										 03						 04	 05		 06	 07	 08		 09		
	Aadd(_aCampoQry, {"A1_COD"		,"COD_CLIENTE			as COD_CLIENT"	,"Cod. Cliente"			,"C",006	,0	,""	,""		,""	 })
	Aadd(_aCampoQry, {"A1_NOME"		,"NOME_CLIENTE			as NOM_CLIENT"	,"Nome Cliente"			,"C",040	,0	,""	,""		,""	 })
	Aadd(_aCampoQry, {"A1_LOJA"		,"LOJA"									,"Loja"					,"C",002	,0	,""	,""		,""	 })
	Aadd(_aCampoQry, {"A1_NREDUZ"	,"NOME_FANTASIA			as NOM_FANTAS"	,"Nome Fantasia"		,"C",020	,0	,""	,""		,""	 })
	Aadd(_aCampoQry, {"ZJ_NOME"		,"TIPO_CLIENTE			as TIPOCLIENT"	,"Tipo Cliente"			,"C",030	,0	,""	,""		,""	 })
	Aadd(_aCampoQry, {"E1_ZDSTPDE"	,"FISICA_JURIDICA		as FISI_JURID"	,"Fisica / Juridica"	,"C",015	,0	,""	,""		,""	 })
	Aadd(_aCampoQry, {"A1_COND"		,"COD_COND_PAGAMENTO	as CODCONDPGT"	,"Cod. Cond. Pgto"		,"C",003	,0	,""	,""		,""	 })
	Aadd(_aCampoQry, {"A2_NOME"		,"COND_PAGAMENTO		as COND_PAGTO"	,"Condicao de Pagto"	,"C",015	,0	,""	,""		,""	 })
	Aadd(_aCampoQry, {"A1_LC"		,"LIMITE_CREDITO		as LIMITECRED"	,"Limite Credito"		,"N",014	,2	,""	,""		,""	 })
	Aadd(_aCampoQry, {"A1_VENCLC"	,"VENC_LIM_CREDITO		as VENCLIMCRE"	,"Venc. Limite Credito"	,"D",008	,0	,""	,""		,""	 })
	Aadd(_aCampoQry, {"A3_NOME"		,"ATIVO_INATIVO			as ATIV_INATI"	,"Ativo / Inativo"		,"C",015	,0	,""	,""		,""	 })
	Aadd(_aCampoQry, {"A1_CGC"		,"CNPJ_CPF"								,"CNPJ / CPF"			,"C",018	,0	,"@!"	,""	,"@!"})
	Aadd(_aCampoQry, {"A1_INSCR"	,"INSCRICAO_ESTADUAL	as INSC_ESTAT"	,"No. Inscr. Estadual"	,"C",018	,0	,""	,""		,""	 })
	Aadd(_aCampoQry, {"AOV_CODSEG"	,"COD_SEGMENTO			as CODSEGMENT"	,"Cod. do Segmento"		,"C",006	,0	,""	,""		,""	 })
	Aadd(_aCampoQry, {"AOV_DESSEG"	,"DESC_SEGMENTO			as DESCSEGMEN"	,"Descricao do Segmento","C",040	,0	,""	,""		,""	 })
	Aadd(_aCampoQry, {"ZQ_COD"		,"COD_REDE"								,"Cod. Rede"			,"C",003	,0	,""	,""		,""	 })
	Aadd(_aCampoQry, {"ZQ_DESCR"	,"DESC_REDE"							,"Descricao Rede"		,"C",040	,0	,""	,""		,""	 })
	Aadd(_aCampoQry, {"A1_CEP"		,"A1_CEP"								,"CEP"					,"C",008	,0	,""	,""		,""	 })
	Aadd(_aCampoQry, {"A1_END"		,"ENDERECO"								,"Endereco"				,"C",080	,0	,""	,""		,""	 })
	Aadd(_aCampoQry, {"A1_BAIRRO"	,"A1_BAIRRO"							,"Bairro"				,"C",040	,0	,""	,""		,""	 })
	Aadd(_aCampoQry, {"CC2_MUN"		,"MUNICIPIO"							,"Municipio"			,"C",060	,0	,""	,""		,""	 })
	Aadd(_aCampoQry, {"A1_EST"		,"ESTADO"								,"Estado"				,"C",002	,0	,""	,""		,""	 })
	Aadd(_aCampoQry, {"A1_DDD"		,"A1_DDD"								,"DDD"					,"C",003	,0	,""	,""		,""	 })
	Aadd(_aCampoQry, {"A1_TEL"		,"A1_TEL"								,"Telefone"				,"C",015	,0	,""	,""		,""	 })
	Aadd(_aCampoQry, {"A1_EMAIL"	,"A1_EMAIL"								,"E-mail"				,"C",080	,0	,""	,""		,""	 })
	Aadd(_aCampoQry, {"A1_DTCAD"	,"DATA_CADASTRO			as VLRADIANTA"	,"Data de Cadastro"		,"D",008	,0	,""	,""		,""	 })
	Aadd(_aCampoQry, {"A1_NATUREZ"	,"COD_NATUREZA			as SALDOTITUL"	,"Cod. Natureza"		,"C",010	,0	,""	,""		,""	 })
	Aadd(_aCampoQry, {"ED_DESCRIC"	,"NATUREZA"								,"Natureza"				,"C",030	,0	,""	,""		,""	 })
	Aadd(_aCampoQry, {"COD_CNAE"	,"COD_CNAE"								,"Cod. CNAE"			,"C",009	,0	,""	,""		,""	 })
	Aadd(_aCampoQry, {"DESC_CNAE"	,"DESC_CNAE"							,"Desc. CNAE"			,"C",200	,0	,""	,""		,""	 })
	
	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet ) ; Return ; Endif
	
	_cQuery += " FROM " + U_IF_BIMFR( "IF_BIMFR", "V_CP_LISTAGEMCLIENTE" ) +CRLF
	
	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})
RETURN