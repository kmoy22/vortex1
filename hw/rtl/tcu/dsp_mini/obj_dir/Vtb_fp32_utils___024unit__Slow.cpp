// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtb_fp32_utils.h for the primary calling header

#include "Vtb_fp32_utils__pch.h"
#include "Vtb_fp32_utils__Syms.h"
#include "Vtb_fp32_utils___024unit.h"

void Vtb_fp32_utils___024unit___ctor_var_reset(Vtb_fp32_utils___024unit* vlSelf);

Vtb_fp32_utils___024unit::Vtb_fp32_utils___024unit(Vtb_fp32_utils__Syms* symsp, const char* v__name)
    : VerilatedModule{v__name}
    , vlSymsp{symsp}
 {
    // Reset structure values
    Vtb_fp32_utils___024unit___ctor_var_reset(this);
}

void Vtb_fp32_utils___024unit::__Vconfigure(bool first) {
    if (false && first) {}  // Prevent unused
}

Vtb_fp32_utils___024unit::~Vtb_fp32_utils___024unit() {
}
