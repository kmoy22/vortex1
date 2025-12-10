// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtb_mini_wrapper.h for the primary calling header

#include "Vtb_mini_wrapper__pch.h"
#include "Vtb_mini_wrapper___024root.h"

VL_ATTR_COLD void Vtb_mini_wrapper___024root___eval_static__TOP(Vtb_mini_wrapper___024root* vlSelf);

VL_ATTR_COLD void Vtb_mini_wrapper___024root___eval_static(Vtb_mini_wrapper___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtb_mini_wrapper__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_mini_wrapper___024root___eval_static\n"); );
    // Body
    Vtb_mini_wrapper___024root___eval_static__TOP(vlSelf);
    vlSelf->__Vm_traceActivity[2U] = 1U;
    vlSelf->__Vm_traceActivity[1U] = 1U;
    vlSelf->__Vm_traceActivity[0U] = 1U;
}

VL_ATTR_COLD void Vtb_mini_wrapper___024root___eval_static__TOP(Vtb_mini_wrapper___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtb_mini_wrapper__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_mini_wrapper___024root___eval_static__TOP\n"); );
    // Body
    vlSelf->tb_mini_wrapper__DOT__clk = 0U;
    vlSelf->tb_mini_wrapper__DOT__rst = 1U;
}

void Vtb_mini_wrapper___024root____Vdpiimwrap_tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__dsp48e1_dpi_wrapper_TOP(IData/*31:0*/ a1, IData/*31:0*/ a2, IData/*31:0*/ b1, IData/*31:0*/ b2, QData/*63:0*/ c, IData/*31:0*/ d, CData/*7:0*/ opmode, CData/*7:0*/ alumode, CData/*7:0*/ inmode, CData/*7:0*/ carryinsel, CData/*0:0*/ carryin, CData/*0:0*/ carrycascin, QData/*63:0*/ &dsp48e1_dpi_wrapper__Vfuncrtn);
void Vtb_mini_wrapper___024root____Vdpiimwrap_tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__dsp48e1_carry_dpi_wrapper_TOP(IData/*31:0*/ a1, IData/*31:0*/ a2, IData/*31:0*/ b1, IData/*31:0*/ b2, QData/*63:0*/ c, IData/*31:0*/ d, CData/*7:0*/ opmode, CData/*7:0*/ alumode, CData/*7:0*/ inmode, CData/*7:0*/ carryinsel, CData/*0:0*/ carryin, CData/*0:0*/ carrycascin, CData/*0:0*/ &dsp48e1_carry_dpi_wrapper__Vfuncrtn);

VL_ATTR_COLD void Vtb_mini_wrapper___024root___eval_initial__TOP(Vtb_mini_wrapper___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtb_mini_wrapper__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_mini_wrapper___024root___eval_initial__TOP\n"); );
    // Init
    QData/*63:0*/ __Vfunc_tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__dsp48e1_dpi_wrapper__0__Vfuncout;
    __Vfunc_tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__dsp48e1_dpi_wrapper__0__Vfuncout = 0;
    CData/*0:0*/ __Vfunc_tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__dsp48e1_carry_dpi_wrapper__1__Vfuncout;
    __Vfunc_tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__dsp48e1_carry_dpi_wrapper__1__Vfuncout = 0;
    // Body
    vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__a1 
        = vlSelf->tb_mini_wrapper__DOT__a;
    vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__a2 
        = vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__A2;
    vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__b1 
        = vlSelf->tb_mini_wrapper__DOT__b;
    vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__b2 
        = vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__B2;
    vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__c 
        = (IData)(vlSelf->tb_mini_wrapper__DOT__c);
    vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__d 
        = vlSelf->tb_mini_wrapper__DOT__d;
    vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__opmode 
        = vlSelf->tb_mini_wrapper__DOT__opmode;
    vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__alumode 
        = vlSelf->tb_mini_wrapper__DOT__alumode;
    vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__inmode 
        = vlSelf->tb_mini_wrapper__DOT__inmode;
    vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__carryinsel 
        = vlSelf->tb_mini_wrapper__DOT__carryinsel;
    vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__carryin 
        = vlSelf->tb_mini_wrapper__DOT__carryin;
    vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__carrycascin 
        = vlSelf->tb_mini_wrapper__DOT__carrycascin;
    Vtb_mini_wrapper___024root____Vdpiimwrap_tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__dsp48e1_dpi_wrapper_TOP(vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__a1, vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__a2, vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__b1, vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__b2, 
                                                                                VL_EXTENDS_QI(64,32, vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__c), vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__d, (IData)(vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__opmode), vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__alumode, (IData)(vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__inmode), vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__carryinsel, (IData)(vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__carryin), vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__carrycascin, __Vfunc_tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__dsp48e1_dpi_wrapper__0__Vfuncout);
    vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__result 
        = __Vfunc_tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__dsp48e1_dpi_wrapper__0__Vfuncout;
    Vtb_mini_wrapper___024root____Vdpiimwrap_tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__dsp48e1_carry_dpi_wrapper_TOP(vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__a1, vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__a2, vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__b1, vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__b2, 
                                                                                VL_EXTENDS_QI(64,32, vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__c), vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__d, (IData)(vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__opmode), vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__alumode, (IData)(vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__inmode), vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__carryinsel, (IData)(vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__carryin), vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__carrycascin, __Vfunc_tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__dsp48e1_carry_dpi_wrapper__1__Vfuncout);
    vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__p_carry 
        = __Vfunc_tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__dsp48e1_carry_dpi_wrapper__1__Vfuncout;
    vlSelf->tb_mini_wrapper__DOT__carryout = ((7U & (IData)(vlSelf->tb_mini_wrapper__DOT__carryout)) 
                                              | ((IData)(vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__p_carry) 
                                                 << 3U));
    vlSelf->tb_mini_wrapper__DOT__p = (0xffffffffffffULL 
                                       & vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__result);
    vlSelf->tb_mini_wrapper__DOT__carryout = (8U & (IData)(vlSelf->tb_mini_wrapper__DOT__carryout));
}

VL_ATTR_COLD void Vtb_mini_wrapper___024root___eval_final(Vtb_mini_wrapper___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtb_mini_wrapper__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_mini_wrapper___024root___eval_final\n"); );
}

VL_ATTR_COLD void Vtb_mini_wrapper___024root___eval_settle(Vtb_mini_wrapper___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtb_mini_wrapper__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_mini_wrapper___024root___eval_settle\n"); );
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtb_mini_wrapper___024root___dump_triggers__act(Vtb_mini_wrapper___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtb_mini_wrapper__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_mini_wrapper___024root___dump_triggers__act\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VactTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelf->__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 0 is active: @(posedge tb_mini_wrapper.clk)\n");
    }
    if ((2ULL & vlSelf->__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 1 is active: @([true] __VdlySched.awaitingCurrentTime())\n");
    }
}
#endif  // VL_DEBUG

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtb_mini_wrapper___024root___dump_triggers__nba(Vtb_mini_wrapper___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtb_mini_wrapper__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_mini_wrapper___024root___dump_triggers__nba\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VnbaTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelf->__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 0 is active: @(posedge tb_mini_wrapper.clk)\n");
    }
    if ((2ULL & vlSelf->__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 1 is active: @([true] __VdlySched.awaitingCurrentTime())\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vtb_mini_wrapper___024root___ctor_var_reset(Vtb_mini_wrapper___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtb_mini_wrapper__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_mini_wrapper___024root___ctor_var_reset\n"); );
    // Body
    vlSelf->tb_mini_wrapper__DOT__clk = VL_RAND_RESET_I(1);
    vlSelf->tb_mini_wrapper__DOT__rst = VL_RAND_RESET_I(1);
    vlSelf->tb_mini_wrapper__DOT__a = VL_RAND_RESET_I(30);
    vlSelf->tb_mini_wrapper__DOT__b = VL_RAND_RESET_I(18);
    vlSelf->tb_mini_wrapper__DOT__c = VL_RAND_RESET_Q(48);
    vlSelf->tb_mini_wrapper__DOT__d = VL_RAND_RESET_I(25);
    vlSelf->tb_mini_wrapper__DOT__alumode = VL_RAND_RESET_I(4);
    vlSelf->tb_mini_wrapper__DOT__opmode = VL_RAND_RESET_I(7);
    vlSelf->tb_mini_wrapper__DOT__inmode = VL_RAND_RESET_I(5);
    vlSelf->tb_mini_wrapper__DOT__acin = VL_RAND_RESET_I(30);
    vlSelf->tb_mini_wrapper__DOT__bcin = VL_RAND_RESET_I(18);
    vlSelf->tb_mini_wrapper__DOT__carrycascin = VL_RAND_RESET_I(1);
    vlSelf->tb_mini_wrapper__DOT__carryinsel = VL_RAND_RESET_I(3);
    vlSelf->tb_mini_wrapper__DOT__carryin = VL_RAND_RESET_I(1);
    vlSelf->tb_mini_wrapper__DOT__p = VL_RAND_RESET_Q(48);
    vlSelf->tb_mini_wrapper__DOT__carryout = VL_RAND_RESET_I(4);
    vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__A2 = VL_RAND_RESET_I(30);
    vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__B2 = VL_RAND_RESET_I(18);
    vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__a1 = 0;
    vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__a2 = 0;
    vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__b1 = 0;
    vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__b2 = 0;
    vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__c = 0;
    vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__d = 0;
    vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__opmode = 0;
    vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__alumode = 0;
    vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__inmode = 0;
    vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__carryinsel = 0;
    vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__carryin = VL_RAND_RESET_I(1);
    vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__carrycascin = VL_RAND_RESET_I(1);
    vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__result = 0;
    vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__p_carry = VL_RAND_RESET_I(1);
    vlSelf->__Vdlyvval__tb_mini_wrapper__DOT__clk__v0 = VL_RAND_RESET_I(1);
    vlSelf->__Vdlyvset__tb_mini_wrapper__DOT__clk__v0 = 0;
    vlSelf->__Vtrigprevexpr___TOP__tb_mini_wrapper__DOT__clk__0 = VL_RAND_RESET_I(1);
    for (int __Vi0 = 0; __Vi0 < 3; ++__Vi0) {
        vlSelf->__Vm_traceActivity[__Vi0] = 0;
    }
}
