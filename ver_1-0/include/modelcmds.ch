// ######################################################################################
// Projeto: MVC - Framework para MVC
// Modulo : Include
// Fonte  : modelCmds - Definições de comandos "model"
// ---------+-------------------+--------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+--------------------------------------------------------
// 15.07.09 | 0548-Alan Candido | FNC ???????????/2009
// --------------------------------------------------------------------------------------

#ifndef _MODEL_CMDS_CH

#  define _MODEL_CMDS_CH

// **************************************************************************************
// Comandos para definição de modelos
// **************************************************************************************

# command register model <modelName> ;
  => class _m<modelName> from MVCModel;;
       data FDAOAlias;;
       method _m<modelName>();;
       method _new() constructor;;
       method _end_m<modelName>();;
       method execCommand();;
     end class;;
     method _end_m<modelName>() class _m<modelName>;;
       ::_endMVCModel();;
     return;;
     method _new() class _m<modelName>;;
     return;;
     method execCommand(acCommand, ap1, ap2, ap3, ap4, ap5, ap6, ap7, ap8, ap9, apA) class _m<modelName>;;
       local cCmd := "{|oSelf, ap1, ap2, ap3, ap4, ap5, ap6, ap7, ap8, ap9, apA|" + acCommand + "(oSelf, ap1, ap2, ap3, ap4, ap5, ap6, ap7, ap8, ap9, apA)}";;
     return __runcb(__compstr("eval(" + cCmd + ", self, ap1, ap2, ap3, ap4, ap5, ap6, ap7, ap8, ap9, apA)"));;
     method _m<modelName>(acAlias) class _m<modelName>;;
       local _oField, _oValidator;;
       _oValidator := nil;;
       ::MVCModel(<"modelName">);;
       aAdd(::FClassesName, upper("_m"+<"modelName">));;
       ::FDAOAlias := acAlias

# command singleton;
  => ::setSingleton(.t.);;

# command with dao <daoName> [alias <alias>];
  => ::createDAO(<"daoName">, iif(<.alias.>, <"alias">, ::FDAOAlias))

# command add collection <targetModel> (<keyList,...>) as <apelido>;
  => ::setCollections(<"apelido">, \{ <"keyList"> \}, <"targetModel">)

# command add filter <cName> title <cTitle> expression <exp>;
  => ::FFilterList:addFilter(<cName>, <cTitle>,  <"exp">)

# command add field <fieldName> [label <label>];
  => _oField := ::FFieldsMap:addFieldFromDAO(<"fieldName">, ::getDao() [,<label>]) ;;

# command default value <xDefault>;
  => _oField:setInitialize( {|| <xDefault>} )

# command picture <cPicture>;
  => _oField:setPicture( <cPicture> )

# command autoinc;
  => _oField:setAutoInc(.t.)

# command required;
  => _oValidator := MVCValRequired():MVCValRequired(_oField);;
     _oValidator:setModel( self )

# command length [min <min>] [max <max>];
  => _oValidator := MVCValLen():MVCValLen(_oField, <min>, <max>);;
     _oValidator:setModel( self )

# command len [min <min>] [max <max>];
  => length [min <min>] [max <max>];

# command range [min <min>] [max <max>];
  => _oValidator := MVCValRange():MVCValRange(_oField, <min>, <max>);;
     _oValidator:setModel( self )

# command custom validator <bCode>;
  => _oValidator := MVCValCustom():MVCValCustom(_oField, <"bCode">);;
     _oValidator:setModel( self )

# command value list;
  => _oValidator := MVCValSetValues():MVCValSetValues(_oField, <"bCode">);;
     _oValidator:setModel( self )

# command add option <value> text <text>;
  => _oValidator:addOption(<value>, <text>)

# command custom message <text>;
  => _oValidator:setErrorMsg(<text>)

# command exists in <targetModel> (<keyList,...>) as <apelido>;
  => _oValidator := MVCValExists():MVCValExists(_oField, self:addAliasModel(<"apelido">, <"targetModel">),  \{ <"keyList"> \});;
     _oValidator:setModel( self )

# command lookup <targetModel> (<resultList,...>) as <apelido>;
  => _oValidator := MVCValLookup():MVCValLookup(_oField, self:addAliasModel(<"apelido">, <"targetModel">),  \{ <"resultList"> \});;
     _oValidator:setModel( self )

# command custom rule <bCode>;
  => _oValidator := MVCRuleCustom():MVCRuleCustom( self, <"bCode"> )

# command group rule when <bWhen>;
  => _oValidator := MVCRuleGroup():MVCRuleGroup( self, <"bWhen"> )

# command add required <cFieldname>;
  => _oValidator:addRequireField(<"cFieldname">)

# command abort validation;
  => _oValidator:setAbort(.T.)

# command to dao <bExp>;
  => _oField:setTransfTo( <bExp> )

# command from dao <bExp>;
  => _oField:setTransfFrom( <bExp> )

# command calc expression <doCalc>([<params,...>]) ;
  => _oField:setCalcExp( { |ctx, field| ctx:execCommand(<'doCalc'>, field) }, self )

# command end model;
  => return

#endif