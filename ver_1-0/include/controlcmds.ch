// ######################################################################################
// Projeto: MVC - Framework para MVC
// Modulo : Include
// Fonte  : mvcCmds - Definições de comandos
// ---------+-------------------+--------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+--------------------------------------------------------
// 15.07.09 | 0548-Alan Candido | FNC ???????????/2009
// --------------------------------------------------------------------------------------

#ifndef _CONTROL_CMDS_CH

#  define _CONTROL_CMDS_CH

// **************************************************************************************
// Comandos para definição de controladores
// **************************************************************************************
# command register controller <CtrName>;
  => class _c<ctrName> from MVCController;;
       method _c<ctrName>();;
       method _new() constructor;;
       method execCommand();;
       method _end_c<ctrName>();;
     end class;;
     method _new() class _c<CtrName>;;
     return;;
     method _end_c<CtrName>() class _c<CtrName>;;
       ::_endMVCController();;
     return;;
     method execCommand(acCommand, ap1, ap2, ap3, ap4, ap5, ap6, ap7, ap8, ap9, apA) class _c<CtrName>;;
       local cCmd := "{|oSelf, ap1, ap2, ap3, ap4, ap5, ap6, ap7, ap8, ap9, apA|" + acCommand + "(oSelf, ap1, ap2, ap3, ap4, ap5, ap6, ap7, ap8, ap9, apA)}";;
     return __runcb(__compstr("eval(" + cCmd + ", self, ap1, ap2, ap3, ap4, ap5, ap6, ap7, ap8, ap9, apA)"));;
     method _c<CtrName>() class _c<CtrName>;;
       local _child := nil;;
       _Super:MVCController(<"CtrName">);;
       aAdd(::FClassesName, upper("_c"+<"CtrName">))
     
# command model <ModelName>;
  => ::FModelName := <"ModelName">

# command view <ViewName>;
  => ::FViewName := <"ViewName">

# command crud <crudName>;
  => ::setCRUDName(<"crudName">)

# command wizard <wizardName>;
  => ::setWizardName(<"wizardName">)

# command config <view: view, viewes>;
  => ::FConfigViews := array(IDX_CFG_SIZE);;
	   aEval(::FConfigViews, { |x, i| ::FConfigViews\[i\] := {}})

# command collection <id> using presentation <presentation> ;
  => aAdd(::FConfigViews\[IDX_CFG_COLLECTIONS\], { upper(<"id">), ::getViewName(), <"presentation">, .f. } )

# command collection <id> using controller <ctrName>:<command>();
  => aAdd(::FConfigViews\[IDX_CFG_COLLECTIONS\], { upper(<"id">), <"ctrName">, <"command">, .t. } )

# command lookup <id> using controller <ctrName>:<command>();
  => aAdd(::FConfigViews\[IDX_CFG_LOOKUPS\], { upper(<"id">), <"ctrName">, <"command"> } )

# command callback <command>([<params,...>]) message <notify> from <controller>;
  => <controller>:addCallback(<notify>, self, {|oTarget, oControl| oTarget:execCommand(<"command">, oControl [,<params>])})

# command end config <view: view, viewes>;
  => 
  
# command command <commandName>([<params,...>]);
  => iif(.f.,<commandName>(),);;
     static function <commandName>(self[,<params>])

# command end command [ return (<xRet>)];
  => return [(<xRet>)]

# command end controller;
  => return

# translate call <command>([<params,...>]) of <obj>;
  => <obj>:execCommand(<"command"> [,<params>])

#endif