#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "APWEBEX.CH"

#define CRLF chr(13) + chr(10)


/*/
==============================================================================================================================================================================
{Protheus.doc} MGFWSS20
WS de Integração do Portal do Fornecedor

@author Natanael Filho
@since 03/07/2020 
@type WS  
/*/   

//Receive: Estrutura do Método CONSULTA_TITULO
WSSTRUCT DADOS_FORNEC

	WSDATA CNPJ   		        AS String
	WSDATA NUM      	        as String OPTIONAL
    WSDATA NOME 		        as String OPTIONAL
    WSDATA TPESSOA   	        as String
    WSDATA DTVENCDE	            as String
    WSDATA DTVENCATE            as String
ENDWSSTRUCT

//Retorno: Estrutura do Método CONSULTA_TITULO, TITULOS
WSSTRUCT TITULO

    WSDATA NUMERO_TITULO            as String
    WSDATA SERIE                    as String
    WSDATA TIPO                     as String
    WSDATA LOJA                     as String
    WSDATA FORNECEDOR               as String
    WSDATA NUM_PROCE                as String
    WSDATA POLO                     as String
    WSDATA E2_BAIXA                 as String
    WSDATA ID_PORTAL                as String
    WSDATA IDCNAB                   as String
    WSDATA EMPRESA                  as String
    WSDATA ORIGEM                   as String
    WSDATA NOSSONUMEROAP            as String
    WSDATA EMISSAO                  as String
    WSDATA NOTAFISCAL               as String
    WSDATA DAT_VENCTO_S_DESC        as String
    WSDATA VENCIM_DATA              as String
    WSDATA CNPJCPF                  as String
    WSDATA VLRLIQUIDO               as String
    WSDATA ENVBANCO                 as String
    WSDATA DEPOUBOLETO              as String
    WSDATA HIST                     as String
    WSDATA ACRESC                   as String
    WSDATA DECRES                   as String
    WSDATA CONTR_FAT_EXP            as String
    WSDATA CONTR_FAT_IMP            as String
    WSDATA E2_FATPREF               as String
    WSDATA E2_FILIAL                as String
    WSDATA E2_PARCELA               as String
    WSDATA ADIANTAMENTODEVOLUCAO    as String
    WSDATA ACRESCIMODECRESCIMO      as String

    
ENDWSSTRUCT

//Retorno: Estrutura do Método CONSULTA_TITULO
WSSTRUCT TITULOS

	WSDATA STATUS		as Integer
	WSDATA MSG			as String
	WSDATA aTITULOS		as Array Of TITULO OPTIONAL

ENDWSSTRUCT


//Receive: Estrutura do Método VALIDA_DOCUMENTO
WSSTRUCT DADOS_DOC

	WSDATA CNPJ		        as String
    WSDATA DOCUMENTO        as String
	WSDATA EMISSAO 		    as String

ENDWSSTRUCT

WSSTRUCT RET_VALIDA

	WSDATA STATUS		as Integer
	WSDATA MSG			as String

ENDWSSTRUCT

//Receive: Estrutura do Método ACRESCIMO_DECRESCIMO, DADOS_TITULO
//Também usado no método ADIANTAMENTO_DEVOLUCAO.
WSSTRUCT DADOS_TITULO

    WSDATA FILIAL               as String
    WSDATA COD_FOR              as String
    WSDATA LOJA_FOR             as String
    WSDATA TITULO               as String
    WSDATA PARCELA              as String
    WSDATA PREFIXO              as String
    WSDATA TIPO                 as String

ENDWSSTRUCT

//Retorno: Estrutura do Método ACRESCIMO_DECRESCIMO, ITENS_ZDS
WSSTRUCT ITEM_ZDS

    WSDATA CODIGO               as String
    WSDATA DESCRICAO            as String
    WSDATA HISTORICO            as String
    WSDATA TIPO                 as String
    WSDATA VALOR                as Float
      
ENDWSSTRUCT

//Retorno: Estrutura do Método ACRESCIMO_DECRESCIMO
WSSTRUCT ITENS_ZDS

	WSDATA STATUS		as Integer
	WSDATA MSG			as String
	WSDATA aITENS_ZDS		as Array Of ITEM_ZDS OPTIONAL

ENDWSSTRUCT

//Retorno: Estrutura do Método ADIANTAMENTO_DEVOLUCAO, ITENS_SE5
WSSTRUCT ITEM_SE5

    WSDATA DOCUMENTO               as String
    WSDATA DATA                    as String
    WSDATA HISTORICO               as String
    WSDATA BANCO                   as String
    WSDATA AGENCIA                 as String
    WSDATA CONTA                   as String    
    WSDATA VALORPAGO               as Float
    WSDATA MOTIVO                  as String    

ENDWSSTRUCT

//Retorno: Estrutura do Método ACRESCIMO_DECRESCIMO
WSSTRUCT ITEMS_SE5

	WSDATA STATUS		as Integer
	WSDATA MSG			as String
	WSDATA aITEMS_SE5		as Array Of ITEM_SE5 OPTIONAL

ENDWSSTRUCT


WSSERVICE MGFWSS20 DESCRIPTION "Integracao entre Protheus e Portal do fornecedor" NameSpace "http://totvs.com.br/MGFWSS20.apw"

	WSMETHOD CONSULTA_TITULO DESCRIPTION "Retorna os títulos a pagar"
        WSDATA DADOS_FORNEC AS DADOS_FORNEC
        WSDATA TITULOS AS TITULOS


    WSMETHOD VALIDA_DOCUMENTO DESCRIPTION "Valida se os documento enviado pelo fornecedor no momento do cadastro são validos."
        WSDATA DADOS_DOC  AS DADOS_DOC
        WSDATA RET_VALIDA AS RET_VALIDA

    WSMETHOD ACRESCIMO_DECRESCIMO DESCRIPTION "Retona os acrecimos e decrescimos dos títulos (ZDS)"
    WSDATA DADOS_TITULO AS DADOS_TITULO
    WSDATA ITENS_ZDS AS ITENS_ZDS

    WSMETHOD ADIANTAMENTO_DEVOLUCAO DESCRIPTION "Retona os adiantamentos e devoluções para o título (SE5)"
    WSDATA DADOS_TITULO AS DADOS_TITULO
    WSDATA ITEMS_SE5 AS ITEMS_SE5

ENDWSSERVICE

/*/
==============================================================================================================================================================================
{Protheus.doc} MGFWSS20R
Integração com o portal do Fornecedor

@author Natanael Filho
@since 03/07/2020
@type WS
/*/   
WSMETHOD CONSULTA_TITULO WSRECEIVE DADOS_FORNEC WSSEND TITULOS WSSERVICE MGFWSS20

Local lReturn := .T.
	
//Função para realizar] chamar a view alimentar o objeto de retorno do WS
::TITULOS := WSClassNew( "TITULOS" )
::TITULOS := GetTit(::DADOS_FORNEC)

Return lReturn

/*/
==============================================================================================================================================================================
{Protheus.doc} MGFWSS20R
Integração com o portal do Fornecedor

@author Natanael Filho
@since 03/07/2020
@type WS
/*/   
WSMETHOD VALIDA_DOCUMENTO WSRECEIVE DADOS_DOC WSSEND RET_VALIDA WSSERVICE MGFWSS20

Local lReturn	    := .T.
	
//Função para realizar chamar a view alimentar o objeto de retorno do WS

//Função para realizar] chamar a view alimentar o objeto de retorno do WS
::RET_VALIDA := WSClassNew( "RET_VALIDA" )
::RET_VALIDA := oValidDoc(::DADOS_DOC)

Return lReturn

/*/
==============================================================================================================================================================================
{Protheus.doc} MGFWSS20R
Integração com o portal do Fornecedor

@author Natanael Filho
@since 03/07/2020
@type WS
/*/   
WSMETHOD ACRESCIMO_DECRESCIMO WSRECEIVE DADOS_TITULO WSSEND ITENS_ZDS WSSERVICE MGFWSS20

Local lReturn := .T.
	
//Função para realizar] chamar a view alimentar o objeto de retorno do WS
::ITENS_ZDS := WSClassNew( "ITENS_ZDS" )
::ITENS_ZDS := GetZDS(::DADOS_TITULO)

Return lReturn

/*/
==============================================================================================================================================================================
{Protheus.doc} MGFWSS20R
Integração com o portal do Fornecedor

@author Natanael Filho
@since 03/07/2020
@type WS
/*/   
WSMETHOD ADIANTAMENTO_DEVOLUCAO WSRECEIVE DADOS_TITULO WSSEND ITEMS_SE5 WSSERVICE MGFWSS20

Local lReturn := .T.
	
//Função para realizar] chamar a view alimentar o objeto de retorno do WS
::ITEMS_SE5 := WSClassNew( "ITEMS_SE5" )
::ITEMS_SE5 := GetAdiaDev(::DADOS_TITULO)

Return lReturn








/*/{Protheus.doc} GetTit
    Retornar os títulos a Pagar de acordo com o filtro enviado
    @type  Static Function
    @author Natanael Filho
    @since 06/07/2020
    @version 12.1.17
    @param oFiltroWS, Strutura WS, Objeto de estrutura de títulos recebidos pelo Web service
    @return oTitulos, Objeto de Estrutura WS , Titulos encontrados
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function GetTit( oFiltroWS )

Local oTitulos      := WSClassNew( "TITULOS" )  //Objeto de retorno dos titulos encontrados
Local oTitulo                                  //Objeto de retorno do título da Query. Posteriromente adicionado a oTitulos
Local cQuery       := { }

Private cPortalTab := GetNextAlias()            //Tabela temporária para geração dos títulos que serão enviado nas requisições do WS.
Private oTableBase                              //Tabela com os títulos
Private oTabPedido                              //Tabela com os títulos
Private oTabNF                                  //Seleção das notas fiscais origem (Contas a Pagar - Numero do Titulo [E2_EMISSAO e E2_NUM])
Private oNFFornDE                               //Seleção das notas fiscais do fornecedor (Despesas de Exportação [EET_ZNFORN])
Private oNFForDDI                               //Seleção das notas fiscais do fornecedor (Despesas Declaração Importação [WD_ZNFFOR])


//Encerra a area de trabalho, caso já existe uma em aberto.
If Select(cPortalTab) > 0
    (cPortalTab)->(DbClosearea())
Endif

//Localiza fornecedores
If Empty(oFiltroWS:CNPJ)
    oTitulos:STATUS := 203
    oTitulos:MSG    := "CNPJ ou CPF do Fornecedor não informado."
    return oTitulos
EndIf



//Gera a tabela oTabPortal
If !CreateTab(oFiltroWS)
    oTitulos:STATUS := 500
    oTitulos:MSG    := "Problema na consulta dos dados."
    oTabPortal:Delete()
    return oTitulos
EndIf

(cPortalTab)->(dbGoTop())


If (cPortalTab)->(EOF()) //Gera cotigo de retorno caso não retorne títulos
    oTitulos:STATUS := 204
    oTitulos:MSG    := "Nenhum título foi encontrado com o filtro informado"
    (cPortalTab)->(DbClosearea())
    return oTitulos
Else
    oTitulos:STATUS := 200
    oTitulos:MSG    := "Títulos encontrados."
    oTitulos:aTitulos   := {}
EndIf
		
While (cPortalTab)->(!EOF())
    oTitulo := WSClassNew( "TITULO" )

    oTitulo:NUMERO_TITULO   := Alltrim((cPortalTab)->E2_NUM)
    oTitulo:SERIE           := Alltrim((cPortalTab)->E2_PREFIXO)      
    oTitulo:TIPO            := Alltrim((cPortalTab)->E2_TIPO)       
    oTitulo:LOJA            := Alltrim((cPortalTab)->E2_LOJA)          
    oTitulo:FORNECEDOR      := Alltrim((cPortalTab)->E2_FORNECE)
    oTitulo:NUM_PROCE       := Alltrim((cPortalTab)->E2_ZNUMPRO)
    oTitulo:POLO            := Alltrim((cPortalTab)->E2_ZPOLO)
    oTitulo:E2_BAIXA        := Alltrim((cPortalTab)->E2_BAIXA)
    oTitulo:ID_PORTAL       := Alltrim((cPortalTab)->E2_ZNPORTA)
    oTitulo:IDCNAB          := Alltrim((cPortalTab)->E2_IDCNAB)
    oTitulo:EMPRESA         := SubStr((cPortalTab)->E2_FILIAL,1,2)        
    oTitulo:ORIGEM          := SubStr((cPortalTab)->E2_FILIAL,5,2)        
    oTitulo:NOSSONUMEROAP   := Alltrim((cPortalTab)->E2_ZNPORTA)
    oTitulo:EMISSAO         := Alltrim((cPortalTab)->EMISSAO)
    oTitulo:NOTAFISCAL      := cRetNFFat(oTabNF:GetRealName())      //Retorna as notas ficais de uma Fatura
    oTitulo:DAT_VENCTO_S_DESC := dtoc(Stod((cPortalTab)->E2_VENCREA))
    oTitulo:VENCIM_DATA     := (cPortalTab)->E2_VENCREA
    oTitulo:CNPJCPF         := Alltrim((cPortalTab)->A2_CGC)
    oTitulo:VLRLIQUIDO      := Alltrim(Str((cPortalTab)->VLRLIQUIDO,TamSX3("E2_VALLIQ")[1],2))
    oTitulo:ENVBANCO        := (cPortalTab)->ENVBANCO       
    oTitulo:DEPOUBOLETO     := (cPortalTab)->DEPOUBOL    
    oTitulo:HIST            := Alltrim((cPortalTab)->E2_HIST)
    oTitulo:ACRESC          := Alltrim(Str((cPortalTab)->E2_SDACRES,TamSX3("E2_SDACRES")[1],2))
    oTitulo:DECRES          := Alltrim(Str((cPortalTab)->E2_SDDECRE,TamSX3("E2_SDDECRE")[1],2))
    oTitulo:CONTR_FAT_EXP   := Alltrim((cPortalTab)->EET_ZNFORN)
    oTitulo:CONTR_FAT_IMP   := Alltrim((cPortalTab)->WD_ZNFFOR)
    oTitulo:E2_FATPREF      := Alltrim((cPortalTab)->E2_FATPREF)   
    oTitulo:E2_FILIAL       := (cPortalTab)->E2_FILIAL      
    oTitulo:E2_PARCELA      := Alltrim((cPortalTab)->E2_PARCELA) 
    oTitulo:ACRESCIMODECRESCIMO := (cPortalTab)->EXISTTPVAL
    oTitulo:ADIANTAMENTODEVOLUCAO := (cPortalTab)->EXISTADDEV
    
    //Adiciona o título encotrado ao ARRAY de retorno
    AADD(oTitulos:aTITULOS, oTitulo)
    
    (cPortalTab)->(DBSKIP())
EndDo

//Encerrar a tabela temporária
(cPortalTab)->(DbClosearea())
//Encerrar as tabelas temporárias
oTableBase:Delete()
oTabPedido:Delete()
oTabNF:Delete()
oNFFornDE:Delete()
oNFForDDI:Delete()

return oTitulos

/*/{Protheus.doc} GetAdiaDev
    Retornar os títulos a Pagar de acordo com o filtro enviado
    @type  Static Function
    @author Natanael Filho
    @since 06/07/2020
    @version 12.1.17
    @param oFiltroWS, Strutura WS, Objeto de estrutura de títulos recebidos pelo Web service
    @return oItens_SE5, Objeto de Estrutura WS , Movimentações encontradas
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function GetAdiaDev( oFiltroWS )

Local oItens_SE5      := WSClassNew( "ITEMS_SE5" )  //Objeto de retorno dos titulos encontrados
Local oItem_SE5                                       //Objeto de retorno do título da Query. Posteriromente adicionado a oTitulos
Local cNextAlias    := GetNextAlias()
Local cQuery       := " "
Local cWhere       := " " //Filtro utilizado na Query


//Encerra a area de trabalho, caso já existe uma em aberto.
If Select(cNextAlias) > 0
    (cNextAlias)->(DbClosearea())
Endif

//Filtro de Título
cWhere += " AND SE5.E5_FILIAL = '" + oFiltroWS:FILIAL + "'"
cWhere += " AND SE5.E5_CLIFOR = '" + oFiltroWS:COD_FOR + "'"
cWhere += " AND SE5.E5_LOJA = '" + oFiltroWS:LOJA_FOR + "'"
cWhere += " AND SE5.E5_NUMERO = '" + oFiltroWS:TITULO + "'"
cWhere += " AND SE5.E5_TIPO = '" + oFiltroWS:TIPO + "'"
cWhere += " AND SE5.E5_PREFIXO = '" + oFiltroWS:PREFIXO + "'"
cWhere += " AND SE5.E5_MOTBX = 'CMP'"
cWhere += " AND SE5.E5_MOEDA = '01'"

//Query final que alimentará os atributos do WS
cQuery  := "SELECT E5_DATA,E5_BANCO,E5_HISTOR,E5_AGENCIA,E5_CONTA,E5_DOCUMEN,E5_MOTBX,E5_VALOR"
cQuery  += " FROM " + RetSqlName("SE5") + " SE5"
cQuery  += " WHERE SE5.D_E_L_E_T_ = ' ' " + cWhere

cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cNextAlias,.T.,.T.)
//tcQuery cQuery new alias (cNextAlias)

(cNextAlias)->(dbGoTop())


If (cNextAlias)->(EOF()) //Gera cotigo de retorno caso não retorne registros
    oItens_SE5:STATUS := 204
    oItens_SE5:MSG    := "Nenhum registro foi encontrado com o filtro informado"
    (cNextAlias)->(DbClosearea())
    return oItens_SE5
Else
    oItens_SE5:STATUS := 200
    oItens_SE5:MSG    := "Títulos encontrados."
    oItens_SE5:aITEMS_SE5   := {}
EndIf
		
While (cNextAlias)->(!EOF())
    oItem_SE5 := WSClassNew( "ITEM_SE5" )

    oItem_SE5:DOCUMENTO   := (cNextAlias)->E5_DOCUMEN  
    oItem_SE5:DATA        := (cNextAlias)->E5_DATA          
    oItem_SE5:HISTORICO   := (cNextAlias)->E5_HISTOR           
    oItem_SE5:BANCO       := (cNextAlias)->E5_BANCO           
    oItem_SE5:AGENCIA     := (cNextAlias)->E5_AGENCIA     
    oItem_SE5:CONTA       := (cNextAlias)->E5_CONTA      
    oItem_SE5:VALORPAGO   := (cNextAlias)->E5_VALOR           
    oItem_SE5:MOTIVO      := (cNextAlias)->E5_MOTBX       
    
    //Adiciona o título encotrado ao ARRAY de retorno
    AADD(oItens_SE5:aITEMS_SE5, oItem_SE5)
    
    (cNextAlias)->(DBSKIP())
EndDo

(cNextAlias)->(DbClosearea())

return oItens_SE5

/*/{Protheus.doc} GetZDS
    Retornar os tipos de valoresde acordo com o filtro enviado
    @type  Static Function
    @author Natanael Filho
    @since 06/07/2020
    @version 12.1.17
    @param oFiltroWS, Strutura WS, Objeto de estrutura de títulos recebidos pelo Web service
    @return oItens_ZDS, Objeto de Estrutura WS , Movimentações encontradas
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function GetZDS( oFiltroWS )

Local oItens_ZDS      := WSClassNew( "ITENS_ZDS" )  //Objeto de retorno dos titulos encontrados
Local oItem_ZDS                                       //Objeto de retorno do título da Query. Posteriromente adicionado a oTitulos
Local cNextAlias    := GetNextAlias()
Local cQuery       := " "
Local cWhere       := " " //Filtro utilizado na Query


//Encerra a area de trabalho, caso já existe uma em aberto.
If Select(cNextAlias) > 0
    (cNextAlias)->(DbClosearea())
Endif

//Filtro de Tipo de Valor
cWhere += " AND ZDS.ZDS_FILIAL = '" + oFiltroWS:FILIAL + "'"
cWhere += " AND ZDS.ZDS_PREFIX = '" + oFiltroWS:PREFIXO + "'"
cWhere += " AND ZDS.ZDS_NUM = '" + oFiltroWS:TITULO + "'"
cWhere += " AND ZDS.ZDS_TIPO = '" + oFiltroWS:TIPO + "'"
cWhere += " AND ZDS.ZDS_FORNEC = '" + oFiltroWS:COD_FOR + "'"
cWhere += " AND ZDS.ZDS_LOJA = '" + oFiltroWS:LOJA_FOR + "'"
If Empty(oFiltroWS:PARCELA) //Se a parcela for vazia, adiciona espaço ao filtro. Necessário para o Oracle.
    oFiltroWS:PARCELA   :=  Replicate(" ", TamSX3("ZDS_PREFIX")[1]) 
EndIf
cWhere += " AND ZDS.ZDS_PARCEL = '" + oFiltroWS:PARCELA + "'"


//Query final que alimentará os atributos do WS
cQuery  := "SELECT ZDS_COD,ZDR_DESC,ZDS_HISTOR,ZDR_TIPO,ZDS_VALOR"
cQuery  += " FROM " + RetSqlName("ZDS") + " ZDS"
cQuery  += " 	INNER JOIN " + RetSqlName("ZDR") + " ZDR"
cQuery  += " 	ON ZDS.ZDS_COD = ZDR.ZDR_COD AND "
cQuery  += " 	ZDR.D_E_L_E_T_ = ' ' "
cQuery  += " WHERE ZDS.D_E_L_E_T_ = ' ' " + cWhere

cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cNextAlias,.T.,.T.)
//tcQuery cQuery new alias (cNextAlias)

(cNextAlias)->(dbGoTop())


If (cNextAlias)->(EOF()) //Gera cotigo de retorno caso não retorne registros
    oItens_ZDS:STATUS := 204
    oItens_ZDS:MSG    := "Nenhum registro foi encontrado com o filtro informado"
    (cNextAlias)->(DbClosearea())
    return oItens_ZDS
Else
    oItens_ZDS:STATUS := 200
    oItens_ZDS:MSG    := "Tipos de valor encontrados."
    oItens_ZDS:aITENS_ZDS   := {}
EndIf
		
While (cNextAlias)->(!EOF())
    oItem_ZDS := WSClassNew( "ITEM_ZDS" )

    oItem_ZDS:CODIGO         := (cNextAlias)->ZDS_COD  
    oItem_ZDS:DESCRICAO      := (cNextAlias)->ZDR_DESC          
    oItem_ZDS:HISTORICO      := (cNextAlias)->ZDS_HISTOR           
    oItem_ZDS:TIPO           := (cNextAlias)->ZDR_TIPO           
    oItem_ZDS:VALOR          := (cNextAlias)->ZDS_VALOR     
  
    
    //Adiciona o tipo de valor encotrado ao ARRAY de retorno
    AADD(oItens_ZDS:aITENS_ZDS, oItem_ZDS)
    
    (cNextAlias)->(DBSKIP())
EndDo

(cNextAlias)->(DbClosearea())

return oItens_ZDS

/*/{Protheus.doc} oValidDoc
    Retorna um objeto da estrutura RET_VALIDA para retorno do WS
    @type  Static Function
    @author Natanael Filho
    @since 06/07/2020
    @version 12.1.17
    @param oDoc, Objeto, Dados a validar    
    @return oRetValid, Objeto, Resultado da consulta
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function oValidDoc(oDoc)

Local oRetValid      := WSClassNew( "RET_VALIDA" )  //Objeto de retorno da validação
Local lRaizCNPJ     :=  SuperGetMV("MGF_WSS20A",.T.,.T.) //.T. - Considera apenas a raiz do CNPJ / .F. - Considera o CNPJ conforme enviado ao WS.
Local cNextAlias    := GetNextAlias()
Local cQuery        := ' '
Local cWhere       := ' ' //Filtro utilizado na Query
Local aFornece      := { }                      //Array com os fornecedores que serão adicionados ao Filtro dos títulos
Local cNumDoc       := ' '
Local cCGC          := Alltrim(oDoc:CNPJ)

//Localiza fornecedores
If !Empty(cCGC)
    
    // Considera apenas a Raiz não é um CPF
    If lRaizCNPJ .AND. Len(cCGC) > 11
        cCGC    := LEFT(cCGC,9)
    EndIf
    aFornece := aGetSA2(cCGC)
Else
    oRetValid:STATUS := 203
    oRetValid:MSG    := "CNPJ ou CPF do Fornecedor não informado."
    return oRetValid
EndIf

If Len(aFornece) >0
    for nCount := 1  to Len(aFornece)
        //Adiciona o AND se já existir outros filtros e abre o "(", Parenteses, se for o primeiro indice do array para isolar a proposição com "OR"
        If !Empty(cWhere) .AND. nCount = 1
            cWhere += " AND ("
        ElseIf nCount = 1
            cWhere += " ("
        Else
            cWhere += " OR "
        EndIf

        cWhere += " (SE2.E2_FORNECE = '" + aFornece[nCount,1] + "' " + CRLF
        cWhere += " AND SE2.E2_LOJA = '" + aFornece[nCount,2] + "') " + CRLF

        //Fecha o ")", Parenteses, se for o ultimo indice do array para isolar a proposição com "OR"
        If nCount = Len(aFornece)
            cWhere += ") "
        EndIf

    next
Else
    oRetValid:STATUS := 204
    oRetValid:MSG    := "Nenhum fornecedor foi encontrado com o CNPJ/CPF ou nome informados"
    return oRetValid
EndIf


//Filtro de data de vencimento
If !Empty(oDoc:EMISSAO)
    If !Empty(cWhere)
        cWhere += " AND "
    EndIf
    cWhere += " E2_EMISSAO = '" + oDoc:EMISSAO + "' "+ CRLF
Else
    oRetValid:STATUS := 203
    oRetValid:MSG    := "Data de emissão não informada."
    return oRetValid
EndIf

//Filtro de documento
If !Empty(oDoc:DOCUMENTO)
    cNumDoc := cTrataNum(oDoc:DOCUMENTO) //Função para acrescentar 0 à esqueda
    If !Empty(cWhere)
        cWhere += " AND "
    EndIf
    cWhere += " SE2.E2_NUM = '" + cNumDoc +"' " + CRLF
Else
    oRetValid:STATUS := 203
    oRetValid:MSG    := "Documento não informado."
    return oRetValid
EndIf

//Encerra a area de trabalho, caso já existe uma em aberto.
If Select(cNextAlias) > 0
    (cNextAlias)->(DbClosearea())
Endif

cQuery  := "SELECT 1 " + CRLF
cQuery  += " FROM " + RetSqlName("SE2") + " SE2 " + CRLF
cQuery  += "WHERE D_E_L_E_T_ = ' ' AND " + cWhere

cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cNextAlias,.T.,.T.)

(cNextAlias)->(dbGoTop())
If (cNextAlias)->(EOF()) //Gera cotigo de retorno caso não retorne títulos
    oRetValid:STATUS := 204
    oRetValid:MSG    := "Documento não encontrado"
Else
    oRetValid:STATUS := 200
    oRetValid:MSG    := "Documentos validados"
EndIf

(cNextAlias)->(DbClosearea())
    
Return oRetValid



/*/{Protheus.doc} aGetSA2
    Retorna um array com codigo e loja dos fornecedores a partir do A2_CGC
    @type  Static Function
    @author Natanael Filho
    @since 06/07/2020
    @version 12.1.17
    @param cCGC, String, CNPJ/CPF
    @param cNome, String, Nome do Fornecedor
    @return aFornece, Array, Cod e Loja dos cornecedores
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function aGetSA2(cCGC,cNome)

Local cCampoNome    := Alltrim(SuperGetMV("MGF_WSS20A",.T.,"A2_NOME")) //Define o campo de nome para o Filtro (A2_NOME ou A2_NREDUZ).
Local aFornece      := {}
Local cNextAlias    := GetNextAlias()
Local cQuery        := ' '
Local cWhere       := ' ' //Filtro utilizado na Query


//Filtro para o CGC
If !Empty(cCGC)
    If !Empty(cWhere)
        cWhere += " AND "
    EndIf
    cWhere += " (SA2.A2_CGC LIKE '" + Alltrim(cCGC) + "%' "
    If Empty(cNome) //Fecha parenteses caso não tenho o filtro de nome, pois ambos devem se completarem com OR
        cWhere += ") " + CRLF
    EndIf
EndIf

//Filtro para o Nome
If !Empty(cNome)
    If !Empty(cCGC) //Verifica se existe o filtro de CGC, pois ambos devem se completarem com OR
        cWhere += " OR "
    ElseIf !Empty(cWhere)
        cWhere += " AND ("
    EndIf
    cWhere += " SA2." + cCampoNome + " LIKE '%" + Alltrim(cNome) + "%') " + CRLF
EndIf

//Encerra a area de trabalho, caso já existe uma em aberto.
If Select(cNextAlias) > 0
    (cNextAlias)->(DbClosearea())
Endif

cQuery  := "SELECT A2_COD,A2_LOJA " + CRLF
cQuery  += "FROM " + RetSqlName("SA2") + " SA2 " + CRLF + " WHERE SA2.D_E_L_E_T_ = ' ' "
cQuery  += "AND " + cWhere

cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cNextAlias,.T.,.T.)

(cNextAlias)->(dbGoTop())

While (cNextAlias)->(!EOF())
    AADD( aFornece, {(cNextAlias)->A2_COD,(cNextAlias)->A2_LOJA} )
    (cNextAlias)->(DBSKIP())
EndDo

(cNextAlias)->(DbClosearea())
    
Return aFornece


/*/{Protheus.doc} cTrataNum
    Retorna o numero do título formatado conforme parâmetro.
    @type  Static Function
    @author Natanael Filho
    @since 03/08/2020
    @version 12.1.17
    @param cNum, String, Numero do Título
    @return cRetNum, String, Numero formatado
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function cTrataNum(cNum)

    Local lrepZero      := SuperGetMV("MGF_WSS20B",.T.,.T.)
    Local nTamNumDoc    := 0                        // Tamanho com campo de número
    Local cNumDoc       := ' '

    If lrepZero //Replica zero à esquerta
        nTamNumDoc := TamSX3("E2_NUM")[1]
        cNumDoc := Right(Replicate('0',nTamNumDoc) + cNum,nTamNumDoc) //Acrescenta 0 às esqueda
    Else
        cNumDoc := cNum
    EndIf

return cNumDoc


/*/{Protheus.doc} CreateTab
    (long_description)
    @type  Static Function
    @author user
    @since 15/08/2020
    @version version
    @param oFiltroWS, Objeto, Filtro do título enviado no request do WS
    @return lRet, Boleam, Retorna .T. se a query foi executada com sucesso
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function CreateTab(oFiltroWS)
    Local lRet  := .T.
    Local aStruct   := { }
    Local cQuery    := " "
    Local cFields   := 	" "
    Local NVLcFields := " " //Campos com a função NVL do Oracle para evitar valores Null
    Local aTamSx3   :=  { }
    Local cWhere    := " "
    Local cTimeIni	:= " "
    Local cTimeFin	:= " "
    Local cTimeProc	:= " "
    
    If lRet
        //Tabela temporária da SE2

        /*/
        cFields: Adicionar nessa veriável apenas campos da SX3. Demais deve ser criada a extrutura separadamete.
        Alguns campos tiveram que ser alterados do antigo portal PHP para o WS Prothesu devido ao seu tabanho > 10.
        DE PARA
        EXISTETIPOVALOR -> EXISTTPVAL
        /*/

        cTimeIni	:= time()
        conout(" [MGFWSS20] * * * * * WS PORTAL DO FORNECEDOR * * * * *"							)
        conout(" [MGFWSS20] Processo.....................: Criando as tabelas temporárias          ")
        conout(" [MGFWSS20] Inicio.......................: " + cTimeIni + " - " + dToC( dDataBase )	)


        cFields   := 	"E2_NUM,E2_PREFIXO,E2_TIPO,E2_LOJA,E2_FORNECE,E2_ZNUMPRO,E2_ZPOLO,E2_BAIXA,E2_ZNPORTA,E2_IDCNAB,E2_FILIAL,E2_PARCELA,E2_VENCREA,E2_VALLIQ,E2_NUMBOR,E2_LINDIG,E2_CODBAR,E2_HIST,E2_SDACRES,E2_SDDECRE,E2_FATPREF,E2_SALDO,E2_EMISSAO,A2_TIPO,A2_CGC"

        aStruct := RetStruct(cFields)
        AADD(aStruct,{"EXISTTPVAL","C",1,0})//Campo para indicar se existe tipo de valor

        AADD(aStruct,{"EXISTADDEV","C",1,0})//Campo para indicar existe Adiantamento ou Devolução (SE5)

        // Campo para calcular o valor liquido
        aTamSx3 := TamSX3("E2_VALLIQ")
        AADD(aStruct,{"VLRLIQUIDO",aTamSx3[3],aTamSx3[1],aTamSX3[2]})


        //Cria o Filtro para a tabela temporária
        //Filtro de data de vencimento
        If !Empty(oFiltroWS:DTVENCDE) .AND. !Empty(oFiltroWS:DTVENCATE)
            cWhere += " AND E2_VENCREA BETWEEN '" + oFiltroWS:DTVENCDE + "' AND '" + oFiltroWS:DTVENCATE + "' "
        EndIf

        //Filtro de documento. A query utiliza o número enviado e também o mesmo número acrescentando zeros à esquerda.
        If !Empty(oFiltroWS:NUM)
            cNumDoc := cTrataNum(oFiltroWS:NUM)  //Função para acrescentar 0 à esqueda
            cWhere += " AND (SE2.E2_NUM = '" + cNumDoc  + "' OR SE2.E2_NUM = '" + oFiltroWS:NUM  + "') " + CRLF
        EndIf

        //Filtra fornecedores
        If !Empty(oFiltroWS:CNPJ)
            cWhere += " AND A2_CGC LIKE '" + Alltrim(oFiltroWS:CNPJ) + "%' "
        EndIf

        //Filtra Tipo de pessoa
        If !Empty(oFiltroWS:TPESSOA)
            cWhere += " AND A2_TIPO = '" + Alltrim(oFiltroWS:TPESSOA) + "' "
        EndIf
        
        
        oTableBase:= FWTemporaryTable():New( GetNextAlias()/*cAlias*/, aStruct/*aFields*/)
        oTableBase:AddIndex("01", {"E2_FORNECE", "E2_NUM", "E2_PARCELA", "E2_LOJA"} )
        oTableBase:Create()

        cQuery  := "INSERT INTO " + oTableBase:GetRealName() //Tabela temporaria
        cQuery  += " (" + cFields + ",EXISTTPVAL,EXISTADDEV,VLRLIQUIDO) " //Campos
        cQuery  += " SELECT " + cFields

        //Campos customizados da tabela temporária: EXISTETIPOVALOR
        cQuery  += ", NVL((	SELECT "
        cQuery  += " 			'S' "
        cQuery  += " 		FROM "
        cQuery  += " 			" + RetSqlName("ZDS") + " ZDS "
        cQuery  += " 		WHERE "
        cQuery  += " 			ZDS.D_E_L_E_T_ = ' ' AND "
        cQuery  += " 			ZDS.ZDS_FILIAL = E2_FILIAL AND "
        cQuery  += " 			ZDS.ZDS_PREFIX = E2_PREFIXO AND "
        cQuery  += " 			ZDS.ZDS_NUM = E2_NUM AND "
        cQuery  += " 			ZDS.ZDS_PARCEL = E2_PARCELA AND "
        cQuery  += " 			ZDS.ZDS_TIPO = E2_TIPO AND "
        cQuery  += " 			ZDS.ZDS_FORNEC = E2_FORNECE AND "
        cQuery  += " 			ZDS.ZDS_LOJA = E2_LOJA AND "
        cQuery  += " 			ROWNUM = 1 ), 'N') EXISTTPVAL "
        
        //Campos customizados da tabela temporária: ADIANTAMENTODEVOLUCAO
       cQuery  += ", NVL((	SELECT "
        cQuery  += " 			'S' "
        cQuery  += " 		FROM "
        cQuery  += " 			" + RetSqlName("SE5") + " SE5 "
        cQuery  += " 		WHERE "
        cQuery  += " 			SE5.D_E_L_E_T_ = ' ' AND "
        cQuery  += " 			SE5.E5_FILIAL = E2_FILIAL AND "
        cQuery  += " 			SE5.E5_NUMERO = E2_NUM AND "
        cQuery  += " 			SE5.E5_PREFIXO = E2_PREFIXO AND "        
        cQuery  += " 			SE5.E5_TIPO = E2_TIPO AND "
        cQuery  += " 			SE5.E5_CLIFOR = E2_FORNECE AND "
        cQuery  += " 			SE5.E5_LOJA = E2_LOJA AND "
        cQuery  += "            SE5.E5_MOEDA = '01' AND "
        cQuery  += "            SE5.E5_MOTBX = 'CMP' AND "
        cQuery  += " 			ROWNUM = 1 ), 'N') EXISTADDEV "
        
        //Campos customizados da tabela temporária: VLRLIQUIDO
        cQuery  += ", CASE "
        cQuery  += " 	WHEN E2_VENCREA >= TO_CHAR(SYSDATE, 'YYYYMMDD') "
        cQuery  += " 	THEN E2_VALLIQ + E2_SALDO "
        cQuery  += " 	WHEN E2_VENCREA < TO_CHAR(SYSDATE, 'YYYYMMDD') AND "
        cQuery  += " 	E2_BAIXA <> ' ' "
        cQuery  += " 	THEN E2_VALOR - E2_DECRESC + E2_ACRESC "
        cQuery  += " 	WHEN SE2.E2_BAIXA = ' ' AND "
        cQuery  += " 	SE2.E2_VENCREA < TO_CHAR(SYSDATE, 'YYYYMMDD') AND "
        cQuery  += " 	SE2.E2_TIPO = 'PA' "
        cQuery  += " 	THEN E2_VLCRUZ "
        cQuery  += " 	ELSE (E2_SALDO - E2_DECRESC + E2_ACRESC) "
        cQuery  += " END VLRLIQUIDO"

        cQuery  += " FROM "
        cQuery  += "    " + RetSqlName("SE2") + " SE2 "
        cQuery  += "        INNER JOIN " + RetSqlName("SA2") +  " SA2 "
        cQuery  += "        ON SE2.E2_FORNECE = SA2.A2_COD AND "
        cQuery  += "        SE2.E2_LOJA = SA2.A2_LOJA AND "
        cQuery  += "        SE2.D_E_L_E_T_ = ' ' AND "
        cQuery  += "        SE2.E2_FATPREF = ' ' AND "
        cQuery  += "        SE2.E2_PREFIXO <> 'EEC' "
        cQuery  += " WHERE "
        cQuery  += "    SA2.D_E_L_E_T_ = ' ' AND "
        cQuery  += "    E2_VENCREA >= '20180401' AND "
        cQuery  += "    ( (SE2.E2_VENCREA >= TO_CHAR(SYSDATE, 'YYYYMMDD')) OR "
        cQuery  += "    (SE2.E2_VENCREA < TO_CHAR(SYSDATE, 'YYYYMMDD') AND "
        cQuery  += "    SE2.E2_BAIXA <> ' ') OR "
        cQuery  += "    (SE2.E2_BAIXA = ' ' AND "
        cQuery  += "    SE2.E2_VENCREA < TO_CHAR(SYSDATE, 'YYYYMMDD') )) "
        cQuery  += cWhere

        if TCSqlExec(cQuery) < 0
            ConOut("[MGFWSS20] O comando SQL gerou erro:", TCSqlError())
            lRet := .F.
        EndIf

        cTimeFin	:= time()
        cTimeProc	:= elapTime( cTimeIni , cTimeFin )

        conout(" [MGFWSS20] * * * * * WS PORTAL DO FORNECEDOR * * * * *"							)
        conout(" [MGFWSS20] Processo.....................: Tabela temporária da SE2"        		)        
        conout(" [MGFWSS20] Query........................: " + cQuery                       		)        
        conout(" [MGFWSS20] Inicio.......................: " + cTimeIni + " - " + dToC( dDataBase )	)
        conout(" [MGFWSS20] Fim..........................: " + cTimeFin + " - " + dToC( dDataBase )	)
        conout(" [MGFWSS20] Tempo de Processamento.......: " + cTimeProc							)
        conout(" [MGFWSS20] * * * * * * * * * * * * * * * * * * * * "	                    )

    EndIf

    If lRet
        //Seleção dos pedidos (Itens da NF)
        cTimeIni	:= time()
        //cFields: Adicionar nessa veriável apenas campos da SX3. Demais deve ser criada a extrutura separadamete.
        cFields := 	"D1_DOC,D1_FILIAL,D1_FORNECE,D1_PEDIDO,C7_NUM,C7_FILIAL,C7_FORNECE,EET_PEDCOM,EET_FORNEC,EET_FILIAL,EET_ZNFORN,WD_DOCTO,WD_FORN,WD_FILIAL,WD_ZNFFOR"
        aStruct := RetStruct(cFields)
        NVLcFields := cNVLFields(cFields) // Adiciona a função NVL para evitar valores null

        oTabPedido  := FWTemporaryTable():New( GetNextAlias()/*cAlias*/, aStruct/*aFields*/)
        oTabPedido:AddIndex("01",{"D1_DOC", "D1_FILIAL", "D1_FORNECE"})
        oTabPedido:Create()

        cQuery  := "INSERT INTO " + oTabPedido:GetRealName() //Tabela temporária
        cQuery  += " (" + cFields + ") " //Campos
        cQuery  += " SELECT " + NVLcFields
        cQuery += " FROM "
        cQuery += "     SD1010 SD1 "
        cQuery += "         INNER JOIN " + oTableBase:GetRealName() + " DB "
        cQuery += "         ON SD1.D1_DOC = DB.E2_NUM AND "
        cQuery += "         SD1.D1_FILIAL = DB.E2_FILIAL AND "
        cQuery += "         SD1.D1_FORNECE = DB.E2_FORNECE "
        cQuery += "             LEFT JOIN SC7010 SC7010 "
        cQuery += "             ON SC7010.D_E_L_E_T_ = ' ' AND "
        cQuery += "             SC7010.C7_NUM = SD1.D1_PEDIDO AND "
        cQuery += "             SC7010.C7_FILIAL = DB.E2_FILIAL AND "
        cQuery += "             SC7010.C7_FORNECE = DB.E2_FORNECE "
        cQuery += "                 LEFT JOIN EET010 EET010 "
        cQuery += "                 ON EET010.D_E_L_E_T_ = ' ' AND "
        cQuery += "                 EET010.EET_PEDCOM = SD1.D1_PEDIDO AND "
        cQuery += "                 DB.E2_FORNECE = EET010.EET_FORNEC AND "
        cQuery += "                 DB.E2_FILIAL = EET010.EET_FILIAL "
        cQuery += "                     LEFT JOIN SWD010 SWD010  "
        cQuery += "                     ON SWD010.D_E_L_E_T_ = ' ' AND "
        cQuery += "                     DB.E2_NUM = SWD010.WD_DOCTO AND "
        cQuery += "                     DB.E2_FORNECE = SWD010.WD_FORN AND "
        cQuery += "                     DB.E2_FILIAL = SWD010.WD_FILIAL "
        cQuery += " WHERE "
        cQuery += "     SD1.D_E_L_E_T_ = ' ' "

        If TCSqlExec(cQuery) < 0
            ConOut("[MGFWSS20] O comando SQL gerou erro:", TCSqlError())
            lRet := .F.
        EndIf

        cTimeFin	:= time()
        cTimeProc	:= elapTime( cTimeIni , cTimeFin )

        conout(" [MGFWSS20] * * * * * WS PORTAL DO FORNECEDOR * * * * *"							)
        conout(" [MGFWSS20] Processo.....................: Seleção dos pedidos (Itens da NF)"  		)        
        conout(" [MGFWSS20] Query........................: " + cQuery                       		) 
        conout(" [MGFWSS20] Inicio.......................: " + cTimeIni + " - " + dToC( dDataBase )	)
        conout(" [MGFWSS20] Fim..........................: " + cTimeFin + " - " + dToC( dDataBase )	)
        conout(" [MGFWSS20] Tempo de Processamento.......: " + cTimeProc							)
        conout(" [MGFWSS20] * * * * * * * * * * * * * * * * * * * * "	                    )
    EndIf


    If lRet
        //Seleção das Fotas Fiscais de origem (Contas a Pagar - Numero do Titulo [E2_EMISSAO e E2_NUM])
        cTimeIni	:= time()
        //cFields: Adicionar nessa veriável apenas campos da SX3. Demais deve ser criada a extrutura separadamete.
        cFields   := 	"E2_FORNECE,E2_NUM,E2_PARCELA,E2_LOJA"

        aStruct := RetStruct(cFields)

        /*/
        Adicionado os campos idividualmente devido às duas particularidades do nome, mas sempre referencio a um campo existente no dicionário
        Alguns campos tiveram que ser alterados do antigo portal PHP para o WS Prothesu devido ao seu tabanho > 10.
            DE PARA
            VALORNOTAFISCALTOTAL -> TOTALNOTAF
            VALORNOTAFISCAL -> VLNOTAFIS
        /*/
        aTamSx3 := TamSX3("E2_NUM")
        If Len(aTamSx3)>0
            AADD(aStruct,{"NOTAFISCAL",aTamSx3[3],aTamSx3[1],aTamSX3[2]})
        EndIf

        aTamSx3 := TamSX3("E2_EMISSAO")
        If Len(aTamSx3)>0
            AADD(aStruct,{"EMISSAO",aTamSx3[3],aTamSx3[1],aTamSX3[2]})
        EndIf

        aTamSx3 := TamSX3("E2_VALOR")
        If Len(aTamSx3)>0
            AADD(aStruct,{"TOTALNOTAF",aTamSx3[3],aTamSx3[1],aTamSX3[2]})
        EndIf

        aTamSx3 := TamSX3("E2_VALOR")
        If Len(aTamSx3)>0
            AADD(aStruct,{"VLNOTAFIS",aTamSx3[3],aTamSx3[1],aTamSX3[2]})
        EndIf

        oTabNF := FWTemporaryTable():New( GetNextAlias()/*cAlias*/, aStruct/*aFields*/)
        oTabNF:AddIndex("01",{"E2_FORNECE", "E2_NUM", "E2_PARCELA", "E2_LOJA"})
        oTabNF:Create()

        cQuery  := "INSERT INTO " + oTabNF:GetRealName() //Tabela temporaria
        cQuery  += " (" + cFields + ",NOTAFISCAL,EMISSAO,TOTALNOTAF,VLNOTAFIS) " //Campos
        cQuery  += " SELECT "  
        cQuery  +=  " DB.E2_FORNECE, "
        cQuery  +=  " DB.E2_NUM, "
        cQuery  +=  " DB.E2_PARCELA, "
        cQuery  +=  " DB.E2_LOJA, "
        cQuery  +=  " SE2_DES.E2_NUM, "
        cQuery  +=  " SE2_DES.E2_EMISSAO, "
        cQuery  +=  " SE2_DES.E2_VALOR, "
        cQuery  +=  " CASE "
        cQuery  +=  " 	WHEN SE2_DES.E2_VENCREA >= TO_CHAR(SYSDATE, 'YYYYMMDD') "
        cQuery  +=  " 	THEN SE2_DES.E2_VALLIQ + SE2_DES.E2_SALDO "
        cQuery  +=  " 	WHEN SE2_DES.E2_VENCREA < TO_CHAR(SYSDATE, 'YYYYMMDD') AND SE2_DES.E2_BAIXA <> ' ' "
        cQuery  +=  " 	THEN SE2_DES.E2_VALOR - SE2_DES.E2_DECRESC + SE2_DES.E2_ACRESC "
        cQuery  +=  " 	ELSE 0 "
        cQuery  +=  " END VLNOTAFIS  "

        cQuery  +=  "FROM FI8010 FI8 "
        cQuery  +=  "	INNER JOIN " + oTableBase:GetRealName() + " DB "
        cQuery  +=  "	ON FI8.FI8_NUMDES = DB.E2_NUM AND "
        cQuery  +=  "	FI8.FI8_PARDES = DB.E2_PARCELA AND "
        cQuery  +=  "	FI8.FI8_LOJDES = DB.E2_LOJA "
        cQuery  +=  "		INNER JOIN SE2010 SE2_DES "
        cQuery  +=  "		ON FI8.FI8_FORORI = SE2_DES.E2_FORNECE AND "
        cQuery  +=  "		FI8.FI8_NUMORI = SE2_DES.E2_NUM AND "
        cQuery  +=  "		FI8.FI8_FORDES = DB.E2_FORNECE  "
        cQuery  +=  "WHERE "
        cQuery  +=  "    ( (SE2_DES.E2_VENCREA >= TO_CHAR(SYSDATE, 'YYYYMMDD')) OR "
        cQuery  +=  "    (SE2_DES.E2_VENCREA < TO_CHAR(SYSDATE, 'YYYYMMDD') AND "
        cQuery  +=  "    SE2_DES.E2_BAIXA <> ' ') ) AND "
        cQuery  +=  "    SE2_DES.E2_FATURA = DB.E2_NUM AND "
        cQuery  +=  "    SE2_DES.D_E_L_E_T_ = ' ' "

        if TCSqlExec(cQuery) < 0
            ConOut("[MGFWSS20] O comando SQL gerou erro:", TCSqlError())
            lRet := .F.
        EndIf

        
        cTimeFin	:= time()
        cTimeProc	:= elapTime( cTimeIni , cTimeFin )

        conout(" [MGFWSS20] * * * * * WS PORTAL DO FORNECEDOR * * * * *"							)
        conout(" [MGFWSS20] Processo.....................: Seleção das Fotas Fiscais de origem (Contas a Pagar - Numero do Titulo [E2_EMISSAO e E2_NUM])"  		)        
        conout(" [MGFWSS20] Query........................: " + cQuery                       		) 
        conout(" [MGFWSS20] Inicio.......................: " + cTimeIni + " - " + dToC( dDataBase )	)
        conout(" [MGFWSS20] Fim..........................: " + cTimeFin + " - " + dToC( dDataBase )	)
        conout(" [MGFWSS20] Tempo de Processamento.......: " + cTimeProc							)
        conout(" [MGFWSS20] * * * * * * * * * * * * * * * * * * * * "	                    )

    EndIf


    If lRet
        //Seleção das notas fiscais do fornecedor (Despesas de Exportação [EET_ZNFORN])
        cTimeIni	:= time()
        //cFields: Adicionar nessa veriável apenas campos da SX3. Demais deve ser criada a extrutura separadamete.
        cFields   := 	"E2_FORNECE,E2_NUM,E2_PARCELA,E2_LOJA,EET_ZNFORN"
        aStruct := RetStruct(cFields)

        oNFFornDE:= FWTemporaryTable():New( GetNextAlias()/*cAlias*/, aStruct/*aFields*/)
        oNFFornDE:AddIndex("01", {"E2_FORNECE", "E2_NUM", "E2_PARCELA", "E2_LOJA"} )
        oNFFornDE:Create()

        cQuery  := "INSERT INTO " + oNFFornDE:GetRealName() //Tabela temporaria
        cQuery  += " (" + cFields + ") " //Campos

        cQuery  += " SELECT "
        cQuery  += " 	DB.E2_FORNECE, "
        cQuery  += " 	DB.E2_NUM, "
        cQuery  += " 	DB.E2_PARCELA, "
        cQuery  += " 	DB.E2_LOJA, "
        cQuery  += " 	EET010.EET_ZNFORN "
        cQuery  += " FROM "
        cQuery  += " 	FI8010 FI8 "
        cQuery  += " 		INNER JOIN " + oTableBase:GetRealName() + " DB "
        cQuery  += " 		ON FI8.FI8_FORDES = DB.E2_FORNECE AND "
        cQuery  += " 		FI8.FI8_NUMDES = DB.E2_NUM AND "
        cQuery  += " 		FI8.FI8_PARDES = DB.E2_PARCELA AND "
        cQuery  += " 		FI8.FI8_LOJDES = DB.E2_LOJA "
        cQuery  += " 			INNER JOIN SE2010 SE2010 "
        cQuery  += " 			ON FI8.FI8_FORORI = SE2010.E2_FORNECE AND "
        cQuery  += " 			FI8.FI8_NUMORI = SE2010.E2_NUM AND "
        cQuery  += " 			SE2010.D_E_L_E_T_= ' ' "
        cQuery  += " 				INNER JOIN sd1010 sd1010 "
        cQuery  += " 				ON sd1010.d1_doc = SE2010.E2_NUM AND "
        cQuery  += " 				SD1010.D1_FILIAL = SE2010.E2_FILIAL AND "
        cQuery  += " 				SD1010.D_E_L_E_T_= ' ' "
        cQuery  += " 					INNER JOIN EET010 EET010 "
        cQuery  += " 					ON FI8.FI8_FORORI = EET010.EET_FORNEC AND "
        cQuery  += " 					FI8.FI8_FILIAL = EET010.EET_FILIAL AND "
        cQuery  += " 					EET010.EET_PEDCOM = sd1010.D1_PEDIDO AND "
        cQuery  += " 					EET010.D_E_L_E_T_ = ' ' "
        cQuery  += " 						INNER JOIN SC7010 SC7010 "
        cQuery  += " 						ON SC7010.C7_NUM = sd1010.D1_PEDIDO AND "
        cQuery  += " 						SC7010.C7_FILIAL = SD1010.D1_FILIAL AND "
        cQuery  += " 						SC7010.D_E_L_E_T_ = ' ' "
        cQuery  += " WHERE FI8.D_E_L_E_T_ = ' ' "

        if TCSqlExec(cQuery) < 0
            ConOut("[MGFWSS20] O comando SQL gerou erro:", TCSqlError())
            lRet := .F.
        EndIf

        cTimeFin	:= time()
        cTimeProc	:= elapTime( cTimeIni , cTimeFin )

        conout(" [MGFWSS20] * * * * * WS PORTAL DO FORNECEDOR * * * * *"							)
        conout(" [MGFWSS20] Processo.....................: Seleção das notas fiscais do fornecedor (Despesas de Exportação [EET_ZNFORN])"  		)        
        conout(" [MGFWSS20] Query........................: " + cQuery                       		) 
        conout(" [MGFWSS20] Inicio.......................: " + cTimeIni + " - " + dToC( dDataBase )	)
        conout(" [MGFWSS20] Fim..........................: " + cTimeFin + " - " + dToC( dDataBase )	)
        conout(" [MGFWSS20] Tempo de Processamento.......: " + cTimeProc							)
        conout(" [MGFWSS20] * * * * * * * * * * * * * * * * * * * * "	                    )

    EndIf

    
    If lRet
        //Seleção das notas fiscais do fornecedor (Despesas Declaração Importação [WD_ZNFFOR])
        cTimeIni	:= time()
        //cFields: Adicionar nessa veriável apenas campos da SX3. Demais deve ser criada a extrutura separadamete.
        cFields   := 	"E2_FORNECE,E2_NUM,E2_PARCELA,E2_LOJA,WD_ZNFFOR"
        aStruct := RetStruct(cFields)

        oNFForDDI:= FWTemporaryTable():New( GetNextAlias()/*cAlias*/, aStruct/*aFields*/)
        oNFForDDI:AddIndex("01", {"E2_FORNECE", "E2_NUM", "E2_PARCELA", "E2_LOJA"} )
        oNFForDDI:Create()

        cQuery  := "INSERT INTO " + oNFForDDI:GetRealName() //Tabela temporaria
        cQuery  += " (" + cFields + ") " //Campos

        cQuery  += " SELECT "
        cQuery  += " 	DB.E2_FORNECE, "
        cQuery  += " 	DB.E2_NUM, "
        cQuery  += " 	DB.E2_PARCELA, "
        cQuery  += " 	DB.E2_LOJA, "
        cQuery  += " 	SWD010.WD_ZNFFOR "
        cQuery  += " FROM "
        cQuery  += " 	FI8010 FI8 "
        cQuery  += " 		INNER JOIN " + oTableBase:GetRealName() + " DB "
        cQuery  += " 		ON FI8.FI8_FORDES = DB.E2_FORNECE AND "
        cQuery  += " 		FI8.FI8_NUMDES = DB.E2_NUM AND "
        cQuery  += " 		FI8.FI8_PARDES = DB.E2_PARCELA AND "
        cQuery  += " 		FI8.FI8_LOJDES = DB.E2_LOJA  "
        cQuery  += " 			INNER JOIN SE2010 SE2_DES "
        cQuery  += " 			ON FI8.FI8_FORORI = SE2_DES.E2_FORNECE AND "
        cQuery  += " 			FI8.FI8_NUMORI = SE2_DES.E2_NUM "
        cQuery  += " 				INNER JOIN SWD010 SWD010 "
        cQuery  += " 				ON FI8.FI8_FORORI = SWD010.WD_FORN AND "
        cQuery  += " 				FI8.FI8_FILIAL = SWD010.WD_FILIAL AND "
        cQuery  += " 				SE2_DES.E2_NUM = SWD010.WD_DOCTO "
        cQuery  += " WHERE FI8.D_E_L_E_T_ = ' ' "

        If TCSqlExec(cQuery) < 0
            ConOut("[MGFWSS20] O comando SQL gerou erro:", TCSqlError())
            lRet := .F.
        EndIf

        cTimeFin	:= time()
        cTimeProc	:= elapTime( cTimeIni , cTimeFin )

        conout(" [MGFWSS20] * * * * * WS PORTAL DO FORNECEDOR * * * * *"							)
        conout(" [MGFWSS20] Processo.....................: Seleção das notas fiscais do fornecedor (Despesas Declaração Importação [WD_ZNFFOR])"  		)        
        conout(" [MGFWSS20] Query........................: " + cQuery                       		) 
        conout(" [MGFWSS20] Inicio.......................: " + cTimeIni + " - " + dToC( dDataBase )	)
        conout(" [MGFWSS20] Fim..........................: " + cTimeFin + " - " + dToC( dDataBase )	)
        conout(" [MGFWSS20] Tempo de Processamento.......: " + cTimeProc							)
        conout(" [MGFWSS20] * * * * * * * * * * * * * * * * * * * * "	                    )
    EndIf


    If lRet
        //Tabela temporária para geração dos títulos que serão enviado nas requisições do WS.
        cTimeIni	:= time()
        /*/
        Alguns campos tiveram que ser alterados do antigo portal PHP para o WS Prothesu devido ao seu tabanho > 10.
            DE PARA
            VENCIM_DATA -> VENC_DATA
            NOSSONUMEROAP -> NOSSONUMAP
        /*/

        cQuery  := " SELECT "
        cQuery  += "	DB.E2_NUM , "
        cQuery  += "	DB.E2_PREFIXO, "
        cQuery  += "	DB.E2_TIPO, "
        cQuery  += "	DB.E2_LOJA, "
        cQuery  += "	DB.E2_FORNECE, "
        cQuery  += "	DB.E2_ZNUMPRO, "
        cQuery  += "	DB.E2_ZPOLO, "
        cQuery  += "	NVL(RTRIM(LTRIM(DB.E2_BAIXA)),' ') E2_BAIXA, "
        cQuery  += "	E2_IDCNAB, "
        cQuery  += "	DB.E2_FILIAL, "
        cQuery  += "	NVL(RTRIM(LTRIM(DB.E2_ZNPORTA)), '-') E2_ZNPORTA, "
        cQuery  += " ( NVL( (SELECT "
        cQuery  += " 			rtrim(xmlagg(xmlelement(e,EET_ZNFORN,' ').extract('//text()') "
        cQuery  += " 			ORDER BY "
        cQuery  += " 				EET_ZNFORN),' ') "
        cQuery  += " FROM "
        cQuery  += " 	(	SELECT "
        cQuery  += " 			DISTINCT RTRIM(LTRIM(DBNFFDE.EET_ZNFORN))EET_ZNFORN "
        cQuery  += " 		FROM " + oNFFornDE:GetRealName() + " DBNFFDE " 
        cQuery  += " 		WHERE "
        cQuery  += " 			DB.E2_FORNECE = DBNFFDE.E2_FORNECE AND "
        cQuery  += " 			DB.E2_NUM = DBNFFDE.E2_NUM AND "
        cQuery  += " 			DB.E2_PARCELA = DBNFFDE.E2_PARCELA AND "
        cQuery  += " 			DB.E2_LOJA = DBNFFDE.E2_LOJA ) EET_ZNFORN ) , "
        cQuery  += " NVL( (	SELECT "
        cQuery  += " 			rtrim(xmlagg(xmlelement(e,EET_ZNFORN,' ').extract('//text()') "
        cQuery  += " 			ORDER BY "
        cQuery  += " 				EET_ZNFORN),' ') "
        cQuery  += " FROM "
        cQuery  += " 	(	SELECT "
        cQuery  += " 			DISTINCT RTRIM(LTRIM(DBP.EET_ZNFORN))EET_ZNFORN "
        cQuery  += " 		FROM " + oTabPedido:GetRealName() + " DBP "
        cQuery  += " 		WHERE
        cQuery  += " 			DBP.D1_DOC = DB.E2_NUM AND
        cQuery  += " 			DBP.D1_FILIAL = DB.E2_FILIAL AND
        cQuery  += " 			DBP.D1_FORNECE = DB.E2_FORNECE ) EET_ZNFORN ) ,
        cQuery  += " 	' ' ) ) ) EET_ZNFORN,
        cQuery  += " NVL( (	SELECT "
        cQuery  += " 			rtrim(xmlagg(xmlelement(e,WD_ZNFFOR,' ').extract('//text()') "
        cQuery  += " 			ORDER BY "
        cQuery  += " 				WD_ZNFFOR),' ') "
        cQuery  += " FROM "
        cQuery  += " 	(	SELECT "
        cQuery  += " 			DISTINCT RTRIM(LTRIM(DBNFFDDI.WD_ZNFFOR))WD_ZNFFOR "
        cQuery  += " 		FROM " + oNFForDDI:GetRealName() + " DBNFFDDI "
        cQuery  += " 		WHERE "
        cQuery  += " 			DB.E2_FORNECE = DBNFFDDI.E2_FORNECE AND "
        cQuery  += " 			DB.E2_NUM = DBNFFDDI.E2_NUM AND "
        cQuery  += " 			DB.E2_PARCELA = DBNFFDDI.E2_PARCELA AND "
        cQuery  += " 			DB.E2_LOJA = DBNFFDDI.E2_LOJA) WD_ZNFFOR ) , "
        cQuery  += " 	NVL( (	SELECT "
        cQuery  += " 				rtrim(xmlagg(xmlelement(e,WD_DOCTO,' ').extract('//text()')  "
        cQuery  += " 				ORDER BY "
        cQuery  += " 					WD_DOCTO),' ') "
        cQuery  += " FROM "
        cQuery  += " 	(	SELECT "
        cQuery  += " 			DISTINCT RTRIM(LTRIM(DBP.WD_DOCTO))WD_DOCTO "
        cQuery  += " 		FROM " + oTabPedido:GetRealName() + " DBP " 
        cQuery  += " 		WHERE "
        cQuery  += " 			DBP.D1_DOC = DB.E2_NUM AND "
        cQuery  += " 			DBP.D1_FILIAL = DB.E2_FILIAL AND "
        cQuery  += " 			DBP.D1_FORNECE = DB.E2_FORNECE ) WD_DOCTO ) , "
        cQuery  += " 	' ' ) ) WD_ZNFFOR, "
        cQuery  += "	DB.E2_FATPREF, "
        cQuery  += "	DB.E2_PARCELA, "
        cQuery  += "	DB.E2_VENCREA,  "
        cQuery  += "	A2_CGC, "
        cQuery  += "	E2_HIST, "
        cQuery  += "	E2_SDACRES, "
        cQuery  += "	E2_SDDECRE, "
        cQuery  += "	NVL( (	SELECT "
        cQuery  += "				LISTAGG(EMISSAO, ' ') WITHIN GROUP( "
        cQuery  += "			ORDER BY "
        cQuery  += "				EMISSAO) "
        cQuery  += "	FROM "
        cQuery  += "		(	SELECT "
        cQuery  += "				DISTINCT DBNF.EMISSAO "
        cQuery  += "			FROM "
        cQuery  += "				" + oTabNF:GetRealName() + " DBNF "
        cQuery  += "			WHERE "
        cQuery  += "				DB.E2_FORNECE = DBNF.E2_FORNECE AND "
        cQuery  += "				DB.E2_NUM = DBNF.E2_NUM AND "
        cQuery  += "				DB.E2_PARCELA = DBNF.E2_PARCELA AND "
        cQuery  += "				DB.E2_LOJA = DBNF.E2_LOJA ) NOTAFISCAL_ORIGEM ), "
        cQuery  += "		DB.E2_EMISSAO) EMISSAO, "
        cQuery  += "		' ' NOTAFISCAL, " //Será incluido depois, na montagem o objeto de retorno do WS .cRetNFFat()
        cQuery  += "        DB.VLRLIQUIDO, "
        cQuery  += "		CASE "
        cQuery  += "			WHEN DB.E2_NUMBOR = ' ' AND "
        cQuery  += "			DB.E2_IDCNAB = ' ' AND "
        cQuery  += "			DB.E2_BAIXA = ' ' "
        cQuery  += "			THEN 'Não' "
        cQuery  += "			ELSE 'Sim' "
        cQuery  += "		END ENVBANCO, "
        cQuery  += "		CASE "
        cQuery  += "			WHEN DB.E2_LINDIG <> ' ' OR "
        cQuery  += "			DB.E2_CODBAR <> ' ' "
        cQuery  += "			THEN 'Boleto' "
        cQuery  += "			ELSE 'Depósito' "
        cQuery  += "		END DEPOUBOL, "
        cQuery  += "		DB.EXISTTPVAL, "
        cQuery  += "		DB.EXISTADDEV "
        cQuery  += "	FROM " + oTableBase:GetRealName() + " DB "
        cQuery  += "	WHERE DB.E2_TIPO !='NDF' "
        cQuery  += "	ORDER BY DB.E2_VENCREA "

        cQuery  := ChangeQuery(cQuery)
        dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cPortalTab,.T.,.T.)


        cTimeFin	:= time()
        cTimeProc	:= elapTime( cTimeIni , cTimeFin )

        conout(" [MGFWSS20] * * * * * WS PORTAL DO FORNECEDOR * * * * *"							)
        conout(" [MGFWSS20] Processo.....................: Tabela temporária para geração dos títulos que serão enviado nas requisições do WS."  		)        
        conout(" [MGFWSS20] Query........................: " + cQuery                       		) 
        conout(" [MGFWSS20] Inicio.......................: " + cTimeIni + " - " + dToC( dDataBase )	)
        conout(" [MGFWSS20] Fim..........................: " + cTimeFin + " - " + dToC( dDataBase )	)
        conout(" [MGFWSS20] Tempo de Processamento.......: " + cTimeProc							)
        conout(" [MGFWSS20] * * * * * * * * * * * * * * * * * * * * "	                    )
    EndIf


    Return lRet

/*/{Protheus.doc} aRetStruct
    Gera Array de estrutura para ser usado da classe FWCreateTemporaruTable
    @type  Static Function
    @author user
    @since 15/08/2020
    @version version
    @param cFields, String, Campos que serão adicinados à estrutura.
    @return aStruct, Array, Estrutura para criação da tabela temporária.
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function RetStruct(cFields)
    Local aStruct   := { }
    Local aFields   := { } //Receberá os campos para montagem da estrutura conforme SX3
    Local aTamSx3   :=  { }

    aFields   := StrToArray(cFields,",")

    //Cria a estrutura para a nova tabela temporária.
    For nCount := 1 to Len(aFields)
        aTamSx3 := TamSX3(aFields[nCount])
        If Len(aTamSx3)>0
            AADD(aStruct,{aFields[nCount],aTamSx3[3],aTamSx3[1],aTamSX3[2]})
        EndIf
    Next
    
Return aStruct


/*/{Protheus.doc} NVLFields
    Adiciona a função NVL a todos os campos a fim de evitar campos null
    @type  Static Function
    @author user
    @since 15/08/2020
    @version version
    @param cFields, String, Campos usados na Query
    @return cFields, String, Campos com a sitaxe  NVL pronta.
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function cNVLFields(cFields)

    Local aFields   := { } //Receberá os campos para montagem da estrutura conforme SX3
    Local aTamSx3   :=  { }

    aFields   := StrToArray(cFields,",")
    cFields   := " "

    //Cria a estrutura para a nova tabela temporária.
    For nCount := 1 to Len(aFields)
        aTamSx3 := TamSX3(aFields[nCount])
        If nCount > 1 //Adiciona a vigula para separação dos campos
            cFields += ","
        EndIf
        If aTamSx3[3] = "N" //Campo numérico
            cFields += "NVL(" + aFields[nCount] + ",0) " + aFields[nCount]
        Else
            cFields += "NVL(" + aFields[nCount] + ",' ') " + aFields[nCount]
        EndIf
    Next
    
Return cFields


/*/{Protheus.doc} cRetNFFat
    Retorna as notas ficais de uma Fatura
    @type  Static Function
    @author user
    @since 25/08/2020
    @version 12.1.17
    @param cTableTemp, String, Nome da tabela temporária
    @param oTitulo, String, Nome da tabela temporária
    @return cNotas, String, Notas fiscais da Fatura
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function cRetNFFat(cTableTemp)

    Local cNotas        := " "
    Local cNextAlias    := GetNextAlias()
    Local cQuery        := " "

    //Encerra a area de trabalho, caso já existe uma em aberto.
    If Select(cNextAlias) > 0
        (cNextAlias)->(DbClosearea())
    Endif

    cQuery  = " SELECT DISTINCT(DBNF.NOTAFISCAL||' - R$'||TRIM(TO_CHAR(DBNF.VLNOTAFIS,'9999999990D99'))||'#') AS NOTAFISCAL "
    cQuery  += "			FROM " + cTableTemp + " DBNF "
    cQuery  += "			WHERE "
    cQuery  += "				DBNF.E2_FORNECE = '" + (cPortalTab)->E2_FORNECE + "'"
    cQuery  += "				AND DBNF.E2_NUM = '" + (cPortalTab)->E2_NUM + "'"
    cQuery  += "				AND DBNF.E2_PARCELA = '" + (cPortalTab)->E2_PARCELA + "'"
    cQuery  += "				AND DBNF.E2_LOJA = '" + (cPortalTab)->E2_LOJA + "'"

    cQuery  := ChangeQuery(cQuery)
    dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cNextAlias,.T.,.T.)

    (cNextAlias)->(dbGoTop())

    If (cNextAlias)->(EOF())
        cNotas := (cPortalTab)->E2_NUM
    
    Else
        While (cNextAlias)->(!EOF())
            cNotas  += Alltrim((cNextAlias)->NOTAFISCAL)
        (cNextAlias)->(DBSKIP())
        Enddo
    EndIf

    (cNextAlias)->(DbClosearea())
    
Return cNotas
