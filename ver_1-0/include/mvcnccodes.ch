// ######################################################################################
// Projeto: MVC - Framework para MVC
// Modulo : Include
// Fonte  : mvcNCCodes - Definições dos códigos de notificações
// ---------+-------------------+--------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+--------------------------------------------------------
// 15.07.09 | 0548-Alan Candido | FNC ???????????/2009
// --------------------------------------------------------------------------------------

#ifndef _MVC_NCCODES_CH
#  define _MVC_NCCODES_CH

// **************************************************************************************
// Códigos de notificações de eventos ocorridos
// **************************************************************************************

#  define NC_CONTROLLER_FIRST   1000
#  define NC_CHANGE_DATA        1001
#  define NC_CLOSE_VIEW         1002
#  define NC_NAVIGATION         1003
#  define NC_EDIT_RECORD        1004
#  define NC_DELETE_RECORD      1005
#  define NC_NEW_RECORD         1006
#  define NC_REFRESH            1007
#  define NC_DATA_OK            1008
#  define NC_DATA_ERROR         1009
#  define NC_SAVE_DATA          1010
#  define NC_SAVE_ADD_DATA      1011
#  define NC_DELETE_DATA        1012
#  define NC_APPLY_FILTER       1013
#  define NC_MOUSE_CLICK        1014
#  define NC_GRID_DBLCLICK      1015
#  define NC_GRID_HEADERCLICK   1016
#  define NC_GRID_ACTHEADER     1017

#  define NC_CHANGE_PAGE        1019
#  define NC_SET_LOOKUP         1021
#  define NC_STATUS_MSG         1022
#  define NC_STATUS_RESET       1024

#  define NC_GRID_ACTCLICK      1030

// **************************************************************************************
// Códigos de eventos
// Observação: Caso o evento dispare notificação, utilizar o mesmo código da notificação
//             porém negativo.
// **************************************************************************************
#  define EV_CONTROLLER_FIRST   (-1000)
#  define EV_CHANGE_DATA        (-1001)
#  define EV_CLOSE_VIEW         (-1002)
#  define EV_NAVIGATION         (-1003)
#  define EV_EDIT_RECORD        (-1004)
#  define EV_DELETE_RECORD      (-1005)
#  define EV_NEW_RECORD         (-1006)
#  define EV_REFRESH            (-1007)
#  define EV_SAVE_DATA          (-1008)
#  define EV_SAVE_ADD_DATA      (-1009)
#  define EV_DELETE_DATA        (-1010)
#  define EV_APPLY_FILTER       (-1011)
#  define EV_MOUSE_CLICK        (-1012)
#  define EV_GRID_DBLCLICK      (-1013)
#  define EV_GRID_HEADERCLICK   (-1014)
#  define EV_GRID_ACTHEADER     (-1015)
#  define EV_CHANGE_VALUE       (-1016)
#  define EV_SEND_DATA          (-1017)
#  define EV_CHANGE_PAGE        (-1018)
#  define EV_BEFORE_ACTIVATE    (-2019)
#  define EV_ACTIVATE           (-1019)
#  define EV_LOOKUP             (-1020)
#  define EV_SET_LOOKUP         (-1021)
#  define EV_SHOW               (-1022)
#  define EV_DRAG_DROP          (-1023)
#  define EV_LOST_FOCUS         (-1024)
#  define EV_CUSTOM_ROW_DATA    (-1025)
#  define EV_CUSTOM_DBL_CLICK   (-1026)
#  define EV_DIALOG_CLOSE       (-1027)
#  define EV_ABORT_EVENT        (-1028)
#  define EV_UPD_MODEL          (-1029)
#  define EV_GRID_ACTCLICK      (-1030)
#  define EV_USER_FIRST         (-5000)

#endif