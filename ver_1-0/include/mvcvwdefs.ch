// ######################################################################################
// Projeto: MVC - Framework para MVC
// Modulo : Include
// Fonte  : mvcVwDefs - Definições para a view
// ---------+-------------------------+--------------------------------------------------
// Data     | Autor                   | Descricao
// ---------+-------------------------+--------------------------------------------------
// 17.08.09 | 0000 - BI TEAM             | FNC 00000017644/2009
// -----------------------------------+--------------------------------------------------

#ifndef _MVC_VW_DEFS_CH
#  define _MVC_VW_DEFS_CH

// **************************************************************************************
// Altura padrão dos widgets padrões (label, textbox, combobox etc.)
// **************************************************************************************
#  define VW_WIDGET_HEIGHT			20

#  define VW_WIDGET_LBL_HEIGHT	13
#  define VW_WIDGET_BTN_HEIGHT	23
#  define VW_WIDGET_LBL_WIDTH		130

#  define VW_WIDGET_LBL_ADJ_HEIGHT 1

#  define VW_PAD_DEFAULT 10

// **************************************************************************************
// Botões do mouse
// **************************************************************************************
#  define VW_MOUSE_LEFT		1
#  define VW_MOUSE_RIGHT	2

// **************************************************************************************
// Constantes para layout automático
// **************************************************************************************
#  define VW_LAYOUTCOL_SPACEY		7

#  define VW_ALIGN_NONE			1
#  define VW_ALIGN_TOP			2
#  define VW_ALIGN_BOTTOM		3
#  define VW_ALIGN_LEFT			4
#  define VW_ALIGN_RIGHT		5
#  define VW_ALIGN_ALLCLIENT	6

#  define VW_LBL_ALIGN VW_ALIGN_TOP

#  define VW_GRDALIGN_LEFT		1
#  define VW_GRDALIGN_CENTER	2
#  define VW_GRDALIGN_RIGHT	3

// **************************************************************************************
// Constantes para layer
// **************************************************************************************
# define LAYER_QTD_LAYOUT    5
# define LAYER_LAYOUT_CENTER 1
# define LAYER_LAYOUT_NORTH  2
# define LAYER_LAYOUT_SOUTH  3
# define LAYER_LAYOUT_EAST   4
# define LAYER_LAYOUT_WEST   5

// **************************************************************************************
// Scroll
// **************************************************************************************
# define SCROLL_AUTO   1
# define SCROLL_SHOW   2
# define SCROLL_HIDDEN 3
# define SCROLL_NONE   4      

// **************************************************************************************
// Drag
// **************************************************************************************
# define HELPER_CLONE   	"clone"
# define HELPER_ORIGINAL   	"original"

#endif