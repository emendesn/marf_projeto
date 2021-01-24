// ######################################################################################
// Projeto: MVC - Framework para MVC
// Modulo : Include
// Fonte  : mvcCmds - Definições de comandos
// ---------+-------------------+--------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+--------------------------------------------------------
// 15.07.09 | 0548-Alan Candido | FNC ???????????/2009
// --------------------------------------------------------------------------------------

#ifndef _MVC_CMDS_CH

#  define _MVC_CMDS_CH

#  define IDX_CFG_SIZE        2
#  define IDX_CFG_COLLECTIONS 1
#  define IDX_CFG_LOOKUPS     2

#  include "modelCmds.ch"
#  include "viewCmds.ch"
#  include "controlCmds.ch"
      
#command property <name> as <type: OBJECT, CHARACTER, NUMERIC, LOGICAL, ARRAY, BLOCK>;
                            [ default <default>] [on change <doEvent>([<params,...>])];
  => ::defProperty(<"name">, left(<"type">, 1), [<default>], [{ |ctx, old, new| ctx:execCommand(<'doEvent'>, old, new ,<params>) }])

#endif