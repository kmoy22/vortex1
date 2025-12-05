// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtb_fp32_utils.h for the primary calling header

#include "Vtb_fp32_utils__pch.h"
#include "Vtb_fp32_utils__Syms.h"
#include "Vtb_fp32_utils___024root.h"

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtb_fp32_utils___024root___dump_triggers__act(Vtb_fp32_utils___024root* vlSelf);
#endif  // VL_DEBUG

void Vtb_fp32_utils___024root___eval_triggers__act(Vtb_fp32_utils___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtb_fp32_utils__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_fp32_utils___024root___eval_triggers__act\n"); );
    // Body
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vtb_fp32_utils___024root___dump_triggers__act(vlSelf);
    }
#endif
}
