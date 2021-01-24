//-------------------------------------------------------------------------------------
/*/{Protheus.doc} BIDshProtocol
Includes necessários para a funcionalidade do protocolo do Dashboard com outras aplicações externas

@author		2481 - Paulo R Vieira
@version	P11
@since		10/11/2009
/*/
//-------------------------------------------------------------------------------------

// tipo de comandos reconhecídos pelo procotolo
#define LOAD			"DSHBI->LOAD"
#define REFRESH			"DSHBI->REFRESH"
#define ALTER_PROPS		"DSHBI->ALTER_PROPS"
#define ATTR_ALERT		"DSHBI->ATTR_ALERT"
#define ATTR_FILTER		"DSHBI->ATTR_FILTER"
#define PAGE_NEXT		"DSHBI->PAGE_NEXT"
#define PAGE_PREV		"DSHBI->PAGE_PREV"
#define DRILL_DOWN		"DSHBI->DRILL_DOWN"
#define DRILL_UP		"DSHBI->DRILL_UP"

// tipo de Visões (viewType) reconhecídos pelo procotolo
#define VIEW_TABLE		"TABLE"
#define VIEW_GRAPH		"GRAPH"

// Tipos de Eixos para Gráficos
#define GRAPH_LINE					"LINE"
#define GRAPH_AREA					"AREA"
#define GRAPH_PIE					"PIE"
#define GRAPH_BAR					"BAR"
#define GRAPH_STACKED_BAR 			"STACKED_BAR"
#define GRAPH_CANDLESTICK			"CANDLESTICK"
#define GRAPH_SCATTER				"SCATTER"
#define GRAPH_ANALOG_GAUGE 			"ANALOG_GAUGE"
#define GRAPH_FLOATING_BAR			"FLOATING_BAR"
#define GRAPH_TREND         		"TREND"
#define GRAPH_OPEN_HIGH_LOW_CLOSE	"OPEN_HIGH_LOW_CLOSE"
#define GRAPH_FUNCTION				"FUNCTION"

// tipo de alinhamentos para Eixo em Eixos de Visões do tipo Gráfico
#define GRAPH_TOP		"TOP"
#define GRAPH_LEFT		"LEFT"
#define GRAPH_BOTTOM	"BOTTOM"
#define GRAPH_RIGHT		"RIGHT"

// tipos de elementos para expressões
#define EXPR_TEXT		"TEXT"
#define EXPR_LABEL		"LABEL"
#define EXPR_SPAN		"SPAN"
#define EXPR_DATE		"DATE"
#define EXPR_EDIT		"EDIT"
#define EXPR_CHECKBOX	"CHECKBOX"
#define EXPR_RADIO    	"RADIO"
#define EXPR_COMBOBOX	"COMBOBOX"
#define EXPR_COMMAND	"COMMAND"



