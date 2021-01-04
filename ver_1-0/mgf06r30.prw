#include "totvs.ch"
#Include "rwmake.ch"
#Include "protheus.ch"
/*/
{Protheus.doc} MGF06R30 
Relatorio BI CONTAS RECEBER

@description
MOVIMENTACAO ME  -  Financeiro

@author Antonio Carlos
@since 11/11/2019 
@type Function MGFZZR99 
*/
User Function MGF06R30()

Local _aCpoExce	   := {}
Local _cTmp01	   := ""
Local cEnviroSrv   := ''

Private _aRet	   := {}, _aParambox := {}, _bParameRe
Private _aDefinePl := {}, _aCampoQry := {}, _cTmp01, _aCpoExce, _cQuery

Private _aEmailQry , _cWhereAnd
_aEmailQry	:= {}  ; _cWhereAnd	:= ""

Aadd(_aDefinePl, "MOVIMENTACAO ME"	)	//01-	_cTitulo	- Titulo da planilha a ser gerada. Aparecerá na regua de processamento.
Aadd(_aDefinePl, "MOVIMENTACAO ME"	)	//02-	_cArqName  - Nome da planilha Excel a ser criada
Aadd(_aDefinePl, {"MOVIMENTACAO ME"})	//03-	_cNomAbAna - Titulo(s) da(s) aba(s) na planilha excel
Aadd(_aDefinePl, {"MOVIMENTACAO ME"})	//04-	_cNomTTAna - Titulo(s) da(s) tabela(s) na planilha excel
Aadd(_aDefinePl, {}					)	//05-	Array de Arrays que define quais colunas serão mostradas em quais abas da planilha. Se a Array _aDefinePl ou a sua subArray for {}, será mostrado na(s) aba(s), todas as colunas contidas na array _aCampoQry 
Aadd(_aDefinePl, { {||.T.} }		)	//06-	Array de code blocks (um code block para cada aba) com a regra que determina se aquele registro deve ser incluído naquela aba  

_aCpoExce	:= {}
_cTmp01		:= ""

//1-Campo Base(SX3), 2-Nome campo na View, 3-Titulo do campo, 4-Tipo dado-C,D,N, 5-Tamanho, 6-Decimais, 7-Picture, 8-Apelido, 9-PictVar 
//Se o elemento 2 (nome do campo na view) tem mais de 10 letras ou é usado alguma função (Sum,Count,max,Coalesc,etc), é dado a ele um apelido indicado    
//pela clausula "as" que será transportado para o elemento 8.
//Se o nome indicado no elemento 1, Campo Base(SX3), existir  no SX3, as propriedades do registro do SX3 são sobrepostos aos elemntos correspondentes  		
//do Array, que estiverem vazios. Os elementos do array _aCampoQry que estiverem  preenchidos serão preservados.
//					01			   02					                   03		 		04		 05		                06	 07	 08  09		
Aadd(_aCampoQry, {"EEQ_FILIAL"  , "FILIAL"		                        , "FILIAL"	     , "C"	, TamSx3("EEQ_FILIAL")[1]   ,0	,""	,""	,""	})
Aadd(_aCampoQry, {"EEQ_EVENT"   , "EVENTO" 	                            , "EVENTO"	     , "C"	, TamSx3("EEQ_EVENT")[1]    ,0	,""	,""	,""	})
Aadd(_aCampoQry, {"EEQ_PREEMB"  , "EXP"    	                            , "PROCESSO"     , "C"	, TamSx3("EEQ_PREEMB")[1]   ,0  ,""	,""	,""	})
Aadd(_aCampoQry, {"EEQ_FINNUM"  , "TITULO"                              , "NUM.TITULO"   , "C"	, TamSx3("EEQ_FINNUM")[1]   ,0	,""	,""	,""	})
Aadd(_aCampoQry, {"EEQ_PARC"    , "PARCELA"	                            , "NRO.PARCELA"  , "C"	, TamSx3("EEQ_PARC")[1]     ,0	,""	,""	,""	})
Aadd(_aCampoQry, {"EEQ_EMISSA"  , "EMISSAO"                             , "DT.EMISSAO"   , "C"	, 010                       ,0	,""	,""	,""	})
Aadd(_aCampoQry, {"EEQ_VCT"     , "VENCIMENTO"                          , "DT.VENCTO"    , "C"	, 010                       ,0	,""	,""	,""	})
Aadd(_aCampoQry, {"EEQ_MOEDA"   , "MOEDA"	                            , "MOEDA"        , "C"	, TamSx3("EEQ_MOEDA")[1]    ,0	,""	,""	,""	})
Aadd(_aCampoQry, {"EEQ_VL"      , "VALOR_MOVIMENTACAO"                  , "VL. DA PARC." , "N"	, TamSx3("EEQ_VL")[1]       ,2	,""	,""	,""	})
Aadd(_aCampoQry, {"EEQ_DESCON"  , "DESCONTO"	                        , "DESCONTO"     , "N"	, TamSx3("EEQ_DESCON")[1]   ,2  ,""	,""	,""	})
Aadd(_aCampoQry, {"EEQ_DTCE"    , "DT_CRED_EXT_FILTRO AS DT_CRED_EX"    , "DT.CRED.EXT." , "D"	, TamSx3("EEQ_DTCE")[1]     ,0	,""	,""	,""	})
Aadd(_aCampoQry, {"EEQ_PGT"     , "DT_LIQ_CONTR_FILTRO AS DT_LIQ_CON"   , "DT.LIQ.CONT." , "D"	, TamSx3("EEQ_PGT")[1]      ,0	,""	,""	,""	})
Aadd(_aCampoQry, {"EEQ_FFC"     , "FFC"	                                , "NRO. FFC"     , "C"	, TamSx3("EEQ_FFC")[1]      ,0	,""	,""	,""	})
Aadd(_aCampoQry, {"EEQ_MOTIVO"	, "MOTIVO_BAIXA AS MOTIVO_BAI"  	    , "MOTIVO BAIXA" , "C"	, TamSx3("EEQ_MOTIVO")[1]   ,0	,""	,""	,""	})
Aadd(_aCampoQry, {"EEQ_ZDESP"   , "CLASSE_VALOR AS CLASSE_VAL"	        , "CLASSE VALOR" , "N"	, TamSx3("EEQ_ZDESP")[1]    ,2	,""	,""	,""	})
Aadd(_aCampoQry, {"EEQ_NROP"    , "OPERACAO"	                        , "NRO. OPERACAO", "C"	, TamSx3("EEQ_NROP")[1]     ,0	,""	,""	,""	})
Aadd(_aCampoQry, {"EEQ_TX"	    , "TAXA_CAMBIO AS TAXA_CAMBI"  	        , "TAXA CAMBIO"  , "N"	, TamSx3("EEQ_TX")[1]       ,6	,""	,""	,""	})
Aadd(_aCampoQry, {"EEQ_EQVL"    , "VL_REAIS"	                        , "VALOR EM R$"  , "N"	, TamSx3("EEQ_EQVL")[1]     ,2	,""	,""	,""	})
Aadd(_aCampoQry, {"EEQ_BANC"    , "BANCO"     	                        , "BANCO"        , "C"	, TamSx3("EEQ_BANC")[1]     ,0	,""	,""	,""	})
Aadd(_aCampoQry, {"EEQ_AGEN"	, "NUM_AGENCIA AS NUM_AGENCI"  	        , "NRO. AGENCIA" , "C"  , TamSx3("EEQ_AGEN")[1]     ,0	,""	,""	,""	})
Aadd(_aCampoQry, {"EEQ_NCON"    , "NUM_CONTA"	                        , "NRO. CONTA"   , "C"  , TamSx3("EEQ_NCON")[1]     ,0	,""	,""	,""	})
Aadd(_aCampoQry, {"EEQ_NOMEBC"  , "NOME_BANCO"	                        , "NOME BANCO"   , "C"  , TamSx3("EEQ_NOMEBC")[1]   ,0	,""	,""	,""	})
Aadd(_aCampoQry, {"EEQ_RFBC"	, "REFERENCIA"  	                    , "REFERENCIA"   , "C"  , TamSx3("EEQ_RFBC")[1]     ,0	,""	,""	,""	})
Aadd(_aCampoQry, {"EEQ_OBS"     , "OBSERVACAO"	                        , "OBSERVACOES"  , "C"  , TamSx3("EEQ_OBS")[1]      ,0	,""	,""	,""	})
Aadd(_aCampoQry, {"A1_COD"	    , "COD_CLIENTE AS COD_CLIENT"  	        , "CODIGO"       , "C"  , TamSx3("A1_COD")[1]       ,0	,""	,""	,""	})
Aadd(_aCampoQry, {"A1_NOME"     , "CLIENTE"	                            , "NOME"         , "C"  , TamSx3("A1_NOME")[1]      ,0	,""	,""	,""	})
Aadd(_aCampoQry, {"EEQ_ZORDNT"  , "ORDENANTE"	                        , "ORDENANTE"	 , "C"  , TamSx3("EEQ_ZORDNT")[1]   ,0	,""	,""	,""	})
Aadd(_aCampoQry, {"EEQ_ZREFBC"	, "REF_BANCA"  	                        , "REF BANCA"    , "C"  , TamSx3("EEQ_ZREFBC")[1]   ,0	,""	,""	,""	})
Aadd(_aCampoQry, {"EEQ_ZBANCO"  , "BANCO_BX_GER AS BANCO_BX_G"	        , "BANCO BX GER" , "C"  , TamSx3("EEQ_ZBANCO")[1]   ,0	,""	,""	,""	})
Aadd(_aCampoQry, {"EEQ_ZAGENC"  , "NUM_AG_BX_GER AS NUM_AG_BX_"	        , "AGENCIA BX G" , "C"  , TamSx3("EEQ_ZAGENC")[1]   ,0	,""	,""	,""	})
Aadd(_aCampoQry, {"EEQ_ZCONTA"	, "NOME_BANCO_BX_GER AS NOME_BAN02"     , "CONTA BX GER" , "C"  , TamSx3("EEQ_ZCONTA")[1]   ,0	,""	,""	,""	})
Aadd(_aCampoQry, {"EEQ_ZNOMEB"  , "OBSERVACAO_BX_GER AS OBSERVAC03"     , "O BCO BX GER" , "C"  , TamSx3("EEQ_ZNOMEB")[1]   ,0	,""	,""	,""	})

aAdd(_aParambox,{1,"DT.CRED.EXT. Inicial" ,Ctod("")	,""	,""									  ,"","",050,.F.})
aAdd(_aParambox,{1,"DT.CRED.EXT. Final"	  ,Ctod("")	,""	,"U_VLFIMMAI(MV_PAR01, MV_PAR01,365)" ,"","",050,.F.})
aAdd(_aParambox,{1,"DT.LIQ.CONT. Inicial" ,Ctod("")	,""	,""									  ,"","",050,.F.})
aAdd(_aParambox,{1,"DT.LIQ.CONT. Final"	  ,Ctod("")	,""	,"U_VLFIMMAI(MV_PAR03, MV_PAR04,365)" ,"","",050,.F.})
aAdd(_aParambox,{1,"Cod. Cliente Inicial" ,Space(tamSx3("A1_COD")[1]),"@!",""		                                       ,"CLI","",050,.F.})
aAdd(_aParambox,{1,"Cod. Cliente Final"   ,Space(tamSx3("A1_COD")[1]),"@!","U_VLFIMMAI(MV_PAR05, MV_PAR06, 'Cod. Cliente')","CLI","",050,.F.})
	
If !U_ParameRe(_aParambox, _bParameRe, @_aRet) ; Return ; Endif

cEnviroSrv	:= AllTrim(UPPER(GETENVSERVER()))

IF cEnviroSrv == 'PRODUCAO'                  
    _cQuery += "  FROM " + U_IF_BIMFR( "IF_BIMFR", "V_CR_MOVIMENTACOES_ME"  ) + CRLF
Else
    _cQuery += "  FROM V_CR_MOVIMENTACOES_ME" + CRLF
EndIF

_cQuery += U_WhereAnd(!empty(_aRet[5]), " AND COD_CLIENTE BETWEEN         '" +_aRet[5]+"' AND '"+_aRet[6]+"' ") + CRLF //NAO OBRIGATORIO
_cQuery += U_WhereAnd(!empty(_aRet[1]), " AND DT_CRED_EXT_FILTRO BETWEEN  '" +_aRet[1]+"' AND '"+_aRet[2]+"' ") + CRLF //NAO OBRIGATORIO
_cQuery += U_WhereAnd(!empty(_aRet[3]), " AND DT_LIQ_CONTR_FILTRO BETWEEN '" +_aRet[3]+"' AND '"+_aRet[4]+"' ") + CRLF //NAO OBRIGATORIO
_cQuery += " ORDER BY FILIAL " + CRLF

MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQuery)
MsgRun("Aguarde!!! Montando\Desconectando Tela"	,,{ ||U_TGridRel()})

RETURN