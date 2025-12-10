// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table implementation internals

#include "Vtb_fp32_utils__pch.h"
#include "Vtb_fp32_utils.h"
#include "Vtb_fp32_utils___024root.h"
#include "Vtb_fp32_utils___024unit.h"

// FUNCTIONS
Vtb_fp32_utils__Syms::~Vtb_fp32_utils__Syms()
{
}

Vtb_fp32_utils__Syms::Vtb_fp32_utils__Syms(VerilatedContext* contextp, const char* namep, Vtb_fp32_utils* modelp)
    : VerilatedSyms{contextp}
    // Setup internal state of the Syms class
    , __Vm_modelp{modelp}
    // Setup module instances
    , TOP{this, namep}
{
    // Configure time unit / time precision
    _vm_contextp__->timeunit(-9);
    _vm_contextp__->timeprecision(-12);
    // Setup each module's pointers to their submodules
    // Setup each module's pointer back to symbol table (for public functions)
    TOP.__Vconfigure(true);
}
