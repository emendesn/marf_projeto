#include "APWIZARD.CH" 
#include "PROTHEUS.CH"
#include "FILEIO.CH"
#include "TBICONN.CH"
#include "TOPCONN.CH"
#include "TOTVS.CH"
#include "BIXDEFMSGREJ.CH"

// índices para campos
#define FIELD_NAME		1 //Índice para nome de campos
#define FIELD_TYPE		2 //Índice para tipos de campos
#define FIELD_SIZE		3 //Índice para tamanhos de campos
#define FIELD_DECIMAL	4 //Índice para decimais de campos
#define FIELD_RELACAO	5 //Índice para o relacionamento entre tabelas

// índices para Lookups
#define LKUP_FLDNAME		1 //Índice para nome de campos em LookUps
#define LKUP_FUNCTION		2 //Índice para nome da function em LookUps
#define LKUP_PARMS			3 //Índice para parâmetros da function em LookUps

// Tratamento de Mensagens
#define INFO				0 //informações de programa
#define EXCEPTION			1 //exeções de programa
#define ERROR				2 //erros graves
#define FATAL				3 //erros fatais (pára o processo)
#define WARNING				4 //Alertas Gerais

// Constantes para faixas

#define PARM_FAIXA_SALARIAL	"FXSALA"
#define PARM_FAIXA_ETARIA 	"FXAETA"
#define PARM_TEMPO_CARGO	"TPCARG"
#define PARM_TEMPO_CASA		"TPCASA"
#define PARM_START			"START"
#define PARM_FINISH			"FINISH"
#define PARM_STATUS			"STATUS"
#define PARM_STATUS_RUNNING	"RUNNING"
#define PARM_STATUS_STOPED 	"STOPPED"
#define PARM_STATUS_ERROR	"ERROR" 
#define PARM_STATUS_OK		"OK" 
#define PARM_MOEDA			"BIX_MOEDA" 
#define PARM_CTB_CG			"BIX_CTB_CG" // CTB - Contas Gerenciais
#define PARM_CTB_LIVRO		"BIX_CTB_LC" // CTB - Livro Contabil.
#define PARM_LINPRO			"LINPRO" 
#define PARM_ISTCIA			"ISTCIA" 
#define PARM_DBTYPE	        "DB_TYPE"
#define PARM_CNTRESULT		"CNTRESULT" // CTB - Contas Resultado
#define PARM_CNTRESUL		"CNTRES" // CTB - Contas Resultado
#define PARM_VISGER			"BIX_VISGER" 
#define PARM_DATAACUM		"BIX_DTACUM"
#define PARM_GRPSLD			"BIX_GRPSLD"  
#define PARM_AREAS			"BIX_AREAS"  //Áreas selecionadas para extração   
#define PARM_FAMCOM			"BIX_FAMCOM" //Utiliza chave consolidada para a Família Comercial
#define PARM_UNITEM			"BIX_UNITEM" //Utiliza chave consolidada para a Unid. Medida Item
#define PARM_CMOEDA			"BIX_CMOEDA" //Utiliza chave consolidada para a Moeda
#define PARM_INTREC			"BIX_INTREC" 
#define PARM_DTOCIO			"BIX_DTOCIO"  
#define PARM_FXHORA			"BIX_FXHORA"
#define PARM_DIASAT			"BIX_DIASAT"
#define PARM_DIASPR			"BIX_DIASPR" 
#define PARM_DIASTM			"BIX_DIASTM"
#define PARM_DIASEV			"BIX_DIASEV"  
#define PARM_PERVENDA		"BIX_PVENDA"
#define PARM_TXMOEDA		"BIX_TXMOED"	// Utiliza taxa negociada
#define PARM_PERENTVE		"BIX_EVENDA"
#define PARM_NOZERO			"BIX_NOZERO"
#define PARM_CARTQUALI		"BIX_CRTQUA" // Qualidade Carteira.
#define PARM_REPRES			"BIX_REPRES" // Representante pelo cadastro de clientes.
#define PARM_CUSTOPER		"BIX_CUSTOP" // Custo por Operação
#define PARM_CARTCOMPR		"BIX_CRTCOM" // Carteira de compras.
#define PARM_CARTMP 		"BIX_CARTMP" // Matéria Prima - Carteira 
#define PARM_CARTPR 		"BIX_CARTPR" // Produção - Carteira
#define PARM_CARTMO 		"BIX_CARTMO" // Mão de Obra - Carteira 
#define PARM_TESDUP 		"BIX_TESDUP" // Faturamento - TES - Gera Duplicata
#define PARM_TESEST 		"BIX_TESEST" // Faturamento - TES - Movimenta Estoque
#define PARM_CONTBL 		"BIX_CONTBL" // Controladoria - Contas Bloqueadas.
#define PARM_CLIREG 		"BIX_CLIREG" // Comercial - Cliente na região geográfica
#define PARM_DEVVENDA		"BIX_DEVVEN" // Devolução de Venda - Indica se devem ser consideradas notas de devolução com cliente diferente da nota de saída

// Scripts de Commandos SQL
#define SCRIPT_DELIM		"|" // delimitador de comandos insert
#define MAX_REG_SQL		100 // máximo de registros a serem executados de uma só vez via TcQuery

// DESCRIPTIVO PARA A LINHA DE PRODUTO PROTHEUS
#define LINHA_PRODUTO	"P "

// DESCRIPTIVO PARA DIMENSÕES QUE NÃO EXISTAM NO PROTHEUS
#define LK_EMPTY       "_"
#define LK_FORM_EMPTY  "-"
#define LK_DESC_EMPTY  "INDEFINIDO"
#define LK_DESC_NOINFO "(VAZIO)"
#define LK_DESC_FORMUL "FORMULA"
#define LK_DESC_SHARED "COMPARTILHADO"

#define DESC_EMPTY		" "
#define FORM_EMPTY		"(F)"
#define NUM_EMPTY		0
#define DATE_EMPTY		STOD('18000101')
#define BOL_EMPTY		'F'

// Parâmetro 'tipo de fato' necessário na chamada da função KPIEstoque da área de Materiais
#define ESTOQUE_MENSAL				1
#define ESTOQUE_DIARIO				2
#define ESTOQUE_SALDO_DIARIO		3

// Identifica o tipo de chave em entidades NoSX. 
#define UK	1
#define FK	2

//Eventos para o log de extração. 
#define EVENT_RUNNING		1
#define EVENT_ERROR			2
#define EVENT_FINISH		3
#define EVENT_UPDATED		5
#DEFINE EVENT_LICENSE		5

// Tipo de atributos do perfil
#DEFINE AREA			1
#DEFINE FACT	   		2
#DEFINE DIMENSION		3  

// Status de execução
#DEFINE EXT_ST_RUNNING		1 
#DEFINE EXT_ST_ERROR  		2
#DEFINE EXT_ST_FINISH  		3
#DEFINE EXT_ST_CANCEL  		4
#DEFINE EXT_ST_UPDATED  	5
#DEFINE EXT_ST_UNDEFINED	"___"

// Tipo de status do Log
#DEFINE LOG_NONE		0 
#DEFINE LOG_INSERT		1 
#DEFINE LOG_UPDATE		2

// Tipo de execução
#DEFINE COMPLETE		1 
#DEFINE CONDITIONAL		2