// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtb_mini_wrapper.h for the primary calling header

#include "Vtb_mini_wrapper__pch.h"
#include "Vtb_mini_wrapper__Syms.h"
#include "Vtb_mini_wrapper___024root.h"

void Vtb_mini_wrapper___024root___ctor_var_reset(Vtb_mini_wrapper___024root* vlSelf);

Vtb_mini_wrapper___024root::Vtb_mini_wrapper___024root(Vtb_mini_wrapper__Syms* symsp, const char* v__name)
    : VerilatedModule{v__name}
    , __VdlySched{*symsp->_vm_contextp__}
    , vlSymsp{symsp}
 {
    // Reset structure values
    Vtb_mini_wrapper___024root___ctor_var_reset(this);
}

void Vtb_mini_wrapper___024root::__Vconfigure(bool first) {
    if (false && first) {}  // Prevent unused
}

Vtb_mini_wrapper___024root::~Vtb_mini_wrapper___024root() {
}
