#INCLUDE "totvs.ch" 


//����������������������������������������������������������������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������������������������ͻ��
//���Programa  � MGF06R03	�Autor  �Geronimo Benedito Alves																	�Data �29/12/17	���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Desc.		� Rotina que mostra na tela os dados da planilha: Financeiro -  Contas a Pagar - Devolucoes Contas a Receber		 (Modulo 06-FIN)	���
//���			� Os dados sao obtidos e mostrados na tela atravez da execucao de query, e depois, o usuario pode gerar uma planilha excel com eles ���
//������������������������������������������������������������������������������������������������������������������������������������������������͹��
//���Uso		� Cliente Global Foods																												���
//������������������������������������������������������������������������������������������������������������������������������������������������ͼ��
//����������������������������������������������������������������������������������������������������������������������������������������������������

User Function MGF06R03()
	Private _aRet	:= {}, _aParambox	:= {}, _bParameRe
	Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery, _cCODFILIA
	Private _aSelFil		:= {}
	Private _aEmailQry , _cWhereAnd
	_aEmailQry	:= {}  ; _cWhereAnd	:= ""
 
	Aadd(_aDefinePl, "Contas a Receber - Devolucoes"	)	//01-  _cTitulo	- Titulo da planilha a ser gerada. Aparecera na regua de processamento.
	Aadd(_aDefinePl, "Devolucoes"						)	//02-  _cArqName  - Nome da planilha Excel a ser criada
	Aadd(_aDefinePl, {"Devolucoes"}						)	//03-  _cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
	Aadd(_aDefinePl, {"Devolucoes"}						)	//04-  _cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
	Aadd(_aDefinePl, {}									)	//05-	Array de Arrays que define quais colunas serao mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, sera mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
	Aadd(_aDefinePl, { {||.T.} }						)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluido naquela aba  

	_aCpoExce	:= {}
	_cTmp01		:= ""					
	
	//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
	//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou � usado alguma funcao (Sum,Count,max,Coalesc,etc), � dado a ele um apelido indicado    
	//pela clausula "as" que sera transportado para o elemento 8.
	//Se o nome indicado no elemento 1, Campo Base(SX3), existir no SX3, as propriedades do registro do SX3 sao sobrepostos aos elemntos correspondentes  		
	//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serao preservados.
	//					01			 02										 03								 04	 05		 06	07						08 	 09		
	Aadd(_aCampoQry, {"A1_FILIAL"	,"COD_FILIAL"							,"Cod. Filial"					,"C",006	,0, ""						,""	,""	})
	Aadd(_aCampoQry, {"A1_NOME"		,"DESC_FILIAL			as DESCFILIAL"	,"Nome da Filial"				,"C",041	,0, ""						,""	,""	})
	Aadd(_aCampoQry, {"A1_COD"		,"COD_CLIENTE			as CODCLIENTE"	,"Cod. do Cliente"				,"C",006	,0, ""						,""	,""	})
	Aadd(_aCampoQry, {"A1_NOME"		,"NOM_CLIENTE			as NOMCLIENTE"	,"Nome do Cliente"				,"C",020	,0, ""						,""	,""	})
	Aadd(_aCampoQry, {"F1_EMISSAO"	,"DT_EMISSAO"							,"Data Emissao"					,"D",008	,0, ""						,""	,""	})
	Aadd(_aCampoQry, {"F1_SERIE"	,"NUM_SERIE_NFE			as NUMSERINFE"	,"N� Serie NFD"					,"C",003	,0, ""						,""	,""	})
	Aadd(_aCampoQry, {"F1_DOC"		,"NUM_NFE"								,"N� NFD"						,"C",009	,0, ""						,""	,""	})
	Aadd(_aCampoQry, {"F1_RECBMTO"	,"DT_RECEBIMENTO		as DTRECEBIME"	,"Data de Recebimento"			,"D",008	,0, ""						,""	,""	})
	Aadd(_aCampoQry, {"ZZH_STATUS"	,"DESC_STATUS_AR		as DESCSTA_AR"	,"Descricao Status AR"			,"C",020	,0, ""						,""	,""	})
	Aadd(_aCampoQry, {"ZZH_AR"		,"NUM_AR"								,"N� AR"						,"C",007	,0, ""						,""	,""	})
	Aadd(_aCampoQry, {"ZZH_DOCMOV"	,"NUM_DOC_MOV			as NUMDOC_MOV"	,"N� Documento"					,"C",009	,0, ""						,""	,""	})
	Aadd(_aCampoQry, {"D1_SERIORI"	,"NUM_SERIE_NF_VENDA	as SERIENFVEN"	,"N� Serie NF Venda"			,"C",003	,0, ""						,""	,""	})
	Aadd(_aCampoQry, {"D1_NFORI"	,"NUM_NF_VENDA			as NUMNFVENDA"	,"N� NF Venda"					,"C",009	,0, ""						,""	,""	})
	Aadd(_aCampoQry, {"D1_ZRAMI"	,"NUM_RAMI"								,"Cod. RAMI"					,"C",006	,0, ""						,""	,""	})
	Aadd(_aCampoQry, {"F1_VALBRUT"	,"VLR_BRUTO"							,"Valor Bruto"					,"N",017	,2,"@E 99,999,999,999.99"	,""	,""	}) 		
	Aadd(_aCampoQry, {"ZAW_MOTIVO"	,"MOT_DEVOLUCAO			as MOTDEVOLUC"	,"Motivo da Devolucao"			,"C",060	,0, ""						,""	,""	})
	Aadd(_aCampoQry, {"ZAW_JUSTIF"	,"JUS_DEVOLUCAO			as JUSDEVOLUC"	,"Justificativa de Devolucao"	,"C",060	,0, ""						,""	,""	})

	aAdd(_aParambox,{1,"Data Recebimento Inicial"	,Ctod("")					,""		,""														,""		,,050,.T.})
	aAdd(_aParambox,{1,"Data Recebimento Final"		,Ctod("")					,""		,"U_VLFIMMAI(MV_PAR01, MV_PAR02, 'Data Recebimento')"	,""		,,050,.T.})
	aAdd(_aParambox,{1,"Cod. Cliente Inicial:"		,Space(tamSx3("A1_COD")[1])	,"@!"	,""														,"CLI"	,,070,.F.})  
	aAdd(_aParambox,{1,"Cod. Cliente Final:"		,Space(tamSx3("A1_COD")[1])	,"@!"	,"U_VLFIMMAI(MV_PAR03, MV_PAR04, 'Cod. Cliente')"		,"CLI"	,,070,.F.})		

	If ! U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

	AdmSelecFil("", 0 ,.F.,@_aSelFil,"",.F.)		// Rotina que obtem a selecao das FILIAIS a processar e as armazena na array _aSelFil  
	If Empty(_aSelFil) ; Return ; Endif
	_cCODFILIA	:= U_Array_In(_aSelFil)

	_cQuery += "  FROM " + U_IF_BIMFR( "IF_BIMFR", "V_CR_DEVOLUCOES" ) + ' A ' + CRLF 
	_cQuery += U_WhereAnd( !empty(_aRet[2] ),      " DT_RECEBIMENTO BETWEEN '" + _aRet[1] + "' AND '" + _aRet[2] + "' "	) // OBRIGATORIO, COM A VALIDACAO DE 35 DIAS
	_cQuery += U_WhereAnd( !empty(_cCODFILIA ),    " A.COD_FILIAL IN "         + _cCODFILIA                           	) // OBRIGATORIO (SELECAO DO COMBO)  CAMPO FILIAL(06 posicoes)
	_cQuery += U_WhereAnd( !empty(_aRet[4] ),      " A.COD_CLIENTE BETWEEN '"  + _aRet[3] + "' AND '" + _aRet[4] + "' "	) // NAO OBRIGATORIO

	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
	MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})

RETURN

