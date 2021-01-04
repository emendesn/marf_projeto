#INCLUDE "totvs.ch" 

//����������������������������������������������������������������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
//���Programa  � MGF06R19	�Autor  � Geronimo Benedito Alves																	�Data �  20/06/18  ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Desc.		� Rotina que mostra na tela os dados da planilha: Financeiro -  Contas a Receber - Contratos                        (Modulo 06-FIN)���
//���			� Os dados sao obtidos e mostrados na tela atravez da execucao de query, e depois, o usuario pode gerar uma planilha excel com eles���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Uso		� Cliente Global Foods																											   ���
//������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
//����������������������������������������������������������������������������������������������������������������������������������������������������

User Function MGF06R19()

	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery
	Private _aSelFil		:= {}
	Private _aEmailQry, _cWhereAnd
	_aEmailQry	:= {};	_cWhereAnd	:= ""
	
	Aadd(_aDefinePl, "Contas a Receber - Contratos"	)	//01-  _cTitulo	- Titulo da planilha a ser gerada. Aparecer� na regua de processamento.
	Aadd(_aDefinePl, "Contratos"						)	//02-  _cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Contratos"}						)	//03-  _cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Contratos"}						)	//04-  _cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}									)	//05-	Array de Arrays que define quais colunas serao mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, sera mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }						)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluido naquela aba  

	_aCpoExce	:= {}
	_cTmp01		:= ""								

	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou � usado alguma funcao (Sum,Count,max,Coalesc,etc), � dado a ele um apelido indicado    
	//pela clausula "as" que sera transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sao sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serao preservados.
	//					01			 02						 03						 04	 05		 06	 07		  	 08		 09		
	Aadd(_aCampoQry, {"CN9_FILIAL"	,"FILIAL"				,"Cod. Filial"			,"C",006	,0	,"" 		,"" 	,"" })
	Aadd(_aCampoQry, {"CN9_NUMERO"	,"NUMERO_CONTRATO"		,"N� Contrato"			,"C",015	,0	,"" 		,"" 	,"" })
	Aadd(_aCampoQry, {"CN1_DESCRI"	,"TIPO_CONTRATO"		,"Tipo Contrato"		,"C",030	,0	,"" 		,"" 	,"" })
	Aadd(_aCampoQry, {"CNC_CLIENT"	,"COD_CLIENTE"			,"Cod. Cliente"			,"C",006	,0	,"" 		,"" 	,"" })
	Aadd(_aCampoQry, {"CNC_LOJACL"	,"LOJA_CLIENTE"			,"Loja Cliente"			,"C",002	,0	,"" 		,"" 	,"" })
	Aadd(_aCampoQry, {"A1_NOME"		,"NOME_CLIENTE"			,"Nome Cliente"			,"C",040	,0	,""			,"" 	,"" })
	Aadd(_aCampoQry, {"ZQ_DESCR"	,"REDE_CLIENTE"			,"Rede Cliente"			,"C",040	,0	,""			,"" 	,"" })
	Aadd(_aCampoQry, {"XXA1_CGC"	,"CGC"					,"CGC"					,"C",025	,0	,"@!"		,"" 	,"@!" })
	Aadd(_aCampoQry, {"CN9_DTINIC"	,"DT_INI_VIGENCIA"		,"Data Inicio Vigencia"	,"D",008	,0	,""			,"" 	,"" })
	Aadd(_aCampoQry, {"CN9_DTFIM"	,"DT_FIM_VIGENCIA"		,"Data Fim Vigencia"	,"D",008	,0	,""			,"" 	,"" })
	Aadd(_aCampoQry, {"CN9_ZTOTDE"	,"TOTAL_DESCONTO"		,"Total Desconto"		,"N",006	,2	,""			,"" 	,"" })
	Aadd(_aCampoQry, {"XXCN9SITUA"	,"SITUACAO"				,"Situacao"				,"C",020	,0	,""  		,""  	,"" })
	Aadd(_aCampoQry, {"CN9_ZDESCF"	,"PERC_DESC_FECHAMENTO"	,"% Desc. Fechamento"	,"N",006	,2	,""			,"" 	,"" })
	Aadd(_aCampoQry, {"CN9_ZACORD"	,"PERC_ACORDO"			,"% Acordo"				,"N",006	,2	,""			,"" 	,"" })

	aAdd(_aParambox,{1,"N� Contrato"			,Space(tamSx3("CN9_NUMERO")[1])	,""	,""													,"CN9"	,"",100,.F.})
	aAdd(_aParambox,{1,"Cod. Cliente Inicial"	,Space(tamSx3("A1_COD")[1])		,""	,""													,"CLI"	,"",050,.F.})
	aAdd(_aParambox,{1,"Cod. Cliente Final"		,Space(tamSx3("A1_COD")[1])		,""	,"U_VLFIMMAI(MV_PAR02, MV_PAR03	,'Cod. Cliente')" 	,"CLI"	,"",050,.F.})
	aAdd(_aParambox,{1,"Data Vigencia Inicial"	,Ctod("")						,""	,""													,""		,"",050,.F.})
	aAdd(_aParambox,{1,"Data Vigencia Final"	,Ctod("")						,""	,"U_VLFIMMAI(MV_PAR04, MV_PAR05	,'Data Vigencia')"	,""		,"",050,.F.})
	 
	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif
	
	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selecao das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)

	_cQuery += "  FROM " + U_IF_BIMFR( "IF_BIMFR", "V_CR_CONTRATOS"  )            + CRLF
	_cQuery += U_WhereAnd( !empty(_cCODFILIA),     " FILIAL IN "                  + _cCODFILIA                             	 ) //OBRIGATORIO (SELECAO DO COMBO)  CAMPO FILIAL(06 posicoes)
	_cQuery += U_WhereAnd( !empty(_aRet[1]),       " NUMERO_CONTRATO LIKE '%"     + _aRet[1]   + "%' "                       ) //NAO OBRIGATORIO (USUARIO DIGITA)
	_cQuery += U_WhereAnd( !empty(_aRet[3]),       " COD_CLIENTE BETWEEN '"       + _aRet[2]   + "' AND '" + _aRet[3] + "' " ) //NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[4]),       " DT_INI_VIGENCIA_FILTRO >= '" + _aRet[4]   + "' "                        ) //NAO OBRIGATORIO
	_cQuery += U_WhereAnd( !empty(_aRet[5]),       " DT_FIM_VIGENCIA_FILTRO <= '" + _aRet[5]   + "' "						 ) //NAO OBRIGATORIO

	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})

RETURN

