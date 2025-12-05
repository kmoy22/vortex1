// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtb_fp32_utils.h for the primary calling header

#include "Vtb_fp32_utils__pch.h"
#include "Vtb_fp32_utils___024root.h"

VL_ATTR_COLD void Vtb_fp32_utils___024root___eval_static(Vtb_fp32_utils___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtb_fp32_utils__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_fp32_utils___024root___eval_static\n"); );
}

VL_ATTR_COLD void Vtb_fp32_utils___024root___eval_initial__TOP(Vtb_fp32_utils___024root* vlSelf);

VL_ATTR_COLD void Vtb_fp32_utils___024root___eval_initial(Vtb_fp32_utils___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtb_fp32_utils__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_fp32_utils___024root___eval_initial\n"); );
    // Body
    Vtb_fp32_utils___024root___eval_initial__TOP(vlSelf);
}

VL_ATTR_COLD void Vtb_fp32_utils___024root___eval_initial__TOP(Vtb_fp32_utils___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtb_fp32_utils__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_fp32_utils___024root___eval_initial__TOP\n"); );
    // Init
    QData/*46:0*/ tb_fp32_utils__DOT__d;
    tb_fp32_utils__DOT__d = 0;
    QData/*46:0*/ __Vfunc_fp32_decode__0__Vfuncout;
    __Vfunc_fp32_decode__0__Vfuncout = 0;
    QData/*46:0*/ __Vfunc_fp32_decode__0__d;
    __Vfunc_fp32_decode__0__d = 0;
    IData/*31:0*/ __Vfunc_fp32_decode__0__r;
    __Vfunc_fp32_decode__0__r = 0;
    QData/*46:0*/ __Vfunc_fp32_decode__2__Vfuncout;
    __Vfunc_fp32_decode__2__Vfuncout = 0;
    QData/*46:0*/ __Vfunc_fp32_decode__2__d;
    __Vfunc_fp32_decode__2__d = 0;
    IData/*31:0*/ __Vfunc_fp32_decode__2__r;
    __Vfunc_fp32_decode__2__r = 0;
    QData/*46:0*/ __Vfunc_fp32_decode__4__Vfuncout;
    __Vfunc_fp32_decode__4__Vfuncout = 0;
    QData/*46:0*/ __Vfunc_fp32_decode__4__d;
    __Vfunc_fp32_decode__4__d = 0;
    IData/*31:0*/ __Vfunc_fp32_decode__4__r;
    __Vfunc_fp32_decode__4__r = 0;
    QData/*46:0*/ __Vfunc_fp32_decode__6__Vfuncout;
    __Vfunc_fp32_decode__6__Vfuncout = 0;
    QData/*46:0*/ __Vfunc_fp32_decode__6__d;
    __Vfunc_fp32_decode__6__d = 0;
    IData/*31:0*/ __Vfunc_fp32_decode__6__r;
    __Vfunc_fp32_decode__6__r = 0;
    QData/*46:0*/ __Vfunc_fp32_decode__8__Vfuncout;
    __Vfunc_fp32_decode__8__Vfuncout = 0;
    QData/*46:0*/ __Vfunc_fp32_decode__8__d;
    __Vfunc_fp32_decode__8__d = 0;
    IData/*31:0*/ __Vfunc_fp32_decode__8__r;
    __Vfunc_fp32_decode__8__r = 0;
    // Body
    __Vfunc_fp32_decode__0__r = 0x3f800000U;
    __Vfunc_fp32_decode__0__d = (0x1fc000000000ULL 
                                 | (0x3fffffffffULL 
                                    & __Vfunc_fp32_decode__0__d));
    __Vfunc_fp32_decode__0__d = (0x7ffffffffff0ULL 
                                 & __Vfunc_fp32_decode__0__d);
    if ((1U & (IData)((__Vfunc_fp32_decode__0__d >> 3U)))) {
        __Vfunc_fp32_decode__0__d = (0x7fc00000000fULL 
                                     & __Vfunc_fp32_decode__0__d);
    } else if ((1U & (IData)(__Vfunc_fp32_decode__0__d))) {
        __Vfunc_fp32_decode__0__d = ((0x7fc00000000fULL 
                                      & __Vfunc_fp32_decode__0__d) 
                                     | (0x3820000000ULL 
                                        | ((QData)((IData)(
                                                           (0x7fffffU 
                                                            & __Vfunc_fp32_decode__0__r))) 
                                           << 4U)));
    } else if ((IData)((0ULL != (6ULL & __Vfunc_fp32_decode__0__d)))) {
        __Vfunc_fp32_decode__0__d = (0x7fc00000000fULL 
                                     & __Vfunc_fp32_decode__0__d);
    } else {
        __Vfunc_fp32_decode__0__d = ((0x7ffff000000fULL 
                                      & __Vfunc_fp32_decode__0__d) 
                                     | ((QData)((IData)(
                                                        (0x800000U 
                                                         | (0x7fffffU 
                                                            & __Vfunc_fp32_decode__0__r)))) 
                                        << 4U));
        __Vfunc_fp32_decode__0__d = ((0x7fc00fffffffULL 
                                      & __Vfunc_fp32_decode__0__d) 
                                     | ((QData)((IData)(
                                                        (0x3ffU 
                                                         & (VL_EXTENDS_II(10,10, 
                                                                          (0xffU 
                                                                           & (__Vfunc_fp32_decode__0__r 
                                                                              >> 0x17U))) 
                                                            - (IData)(0x7fU))))) 
                                        << 0x1cU));
    }
    __Vfunc_fp32_decode__0__Vfuncout = __Vfunc_fp32_decode__0__d;
    tb_fp32_utils__DOT__d = __Vfunc_fp32_decode__0__Vfuncout;
    VL_WRITEF("x = 3f800000 (1.0)\n sign=%0# exp=%0# (unbiased=%0d) mant_norm=0x%x zero=%0# inf=%0# nan=%0# sub=%0#\n",
              1,(1U & (IData)((tb_fp32_utils__DOT__d 
                               >> 0x2eU))),8,(0xffU 
                                              & (IData)(
                                                        (tb_fp32_utils__DOT__d 
                                                         >> 0x26U))),
              10,(0x3ffU & (IData)((tb_fp32_utils__DOT__d 
                                    >> 0x1cU))),24,
              (0xffffffU & (IData)((tb_fp32_utils__DOT__d 
                                    >> 4U))),1,(1U 
                                                & (IData)(
                                                          (tb_fp32_utils__DOT__d 
                                                           >> 3U))),
              1,(1U & (IData)((tb_fp32_utils__DOT__d 
                               >> 2U))),1,(1U & (IData)(
                                                        (tb_fp32_utils__DOT__d 
                                                         >> 1U))),
              1,(1U & (IData)(tb_fp32_utils__DOT__d)));
    __Vfunc_fp32_decode__2__r = 0xc0200000U;
    __Vfunc_fp32_decode__2__d = (0x600000000000ULL 
                                 | (0x3fffffffffULL 
                                    & __Vfunc_fp32_decode__2__d));
    __Vfunc_fp32_decode__2__d = (0x7ffffffffff0ULL 
                                 & __Vfunc_fp32_decode__2__d);
    if ((1U & (IData)((__Vfunc_fp32_decode__2__d >> 3U)))) {
        __Vfunc_fp32_decode__2__d = (0x7fc00000000fULL 
                                     & __Vfunc_fp32_decode__2__d);
    } else if ((1U & (IData)(__Vfunc_fp32_decode__2__d))) {
        __Vfunc_fp32_decode__2__d = ((0x7fc00000000fULL 
                                      & __Vfunc_fp32_decode__2__d) 
                                     | (0x3820000000ULL 
                                        | ((QData)((IData)(
                                                           (0x7fffffU 
                                                            & __Vfunc_fp32_decode__2__r))) 
                                           << 4U)));
    } else if ((IData)((0ULL != (6ULL & __Vfunc_fp32_decode__2__d)))) {
        __Vfunc_fp32_decode__2__d = (0x7fc00000000fULL 
                                     & __Vfunc_fp32_decode__2__d);
    } else {
        __Vfunc_fp32_decode__2__d = ((0x7ffff000000fULL 
                                      & __Vfunc_fp32_decode__2__d) 
                                     | ((QData)((IData)(
                                                        (0x800000U 
                                                         | (0x7fffffU 
                                                            & __Vfunc_fp32_decode__2__r)))) 
                                        << 4U));
        __Vfunc_fp32_decode__2__d = ((0x7fc00fffffffULL 
                                      & __Vfunc_fp32_decode__2__d) 
                                     | ((QData)((IData)(
                                                        (0x3ffU 
                                                         & (VL_EXTENDS_II(10,10, 
                                                                          (0xffU 
                                                                           & (__Vfunc_fp32_decode__2__r 
                                                                              >> 0x17U))) 
                                                            - (IData)(0x7fU))))) 
                                        << 0x1cU));
    }
    __Vfunc_fp32_decode__2__Vfuncout = __Vfunc_fp32_decode__2__d;
    tb_fp32_utils__DOT__d = __Vfunc_fp32_decode__2__Vfuncout;
    VL_WRITEF("x = c0200000 (-2.5)\n sign=%0# exp=%0# (unbiased=%0d) mant_norm=0x%x\n",
              1,(1U & (IData)((tb_fp32_utils__DOT__d 
                               >> 0x2eU))),8,(0xffU 
                                              & (IData)(
                                                        (tb_fp32_utils__DOT__d 
                                                         >> 0x26U))),
              10,(0x3ffU & (IData)((tb_fp32_utils__DOT__d 
                                    >> 0x1cU))),24,
              (0xffffffU & (IData)((tb_fp32_utils__DOT__d 
                                    >> 4U))));
    __Vfunc_fp32_decode__4__r = 0x7f800000U;
    __Vfunc_fp32_decode__4__d = (0x3fc000000000ULL 
                                 | (0x3fffffffffULL 
                                    & __Vfunc_fp32_decode__4__d));
    __Vfunc_fp32_decode__4__d = (4ULL | (0x7ffffffffff0ULL 
                                         & __Vfunc_fp32_decode__4__d));
    if ((1U & (IData)((__Vfunc_fp32_decode__4__d >> 3U)))) {
        __Vfunc_fp32_decode__4__d = (0x7fc00000000fULL 
                                     & __Vfunc_fp32_decode__4__d);
    } else if ((1U & (IData)(__Vfunc_fp32_decode__4__d))) {
        __Vfunc_fp32_decode__4__d = ((0x7fc00000000fULL 
                                      & __Vfunc_fp32_decode__4__d) 
                                     | (0x3820000000ULL 
                                        | ((QData)((IData)(
                                                           (0x7fffffU 
                                                            & __Vfunc_fp32_decode__4__r))) 
                                           << 4U)));
    } else if ((IData)((0ULL != (6ULL & __Vfunc_fp32_decode__4__d)))) {
        __Vfunc_fp32_decode__4__d = (0x7fc00000000fULL 
                                     & __Vfunc_fp32_decode__4__d);
    } else {
        __Vfunc_fp32_decode__4__d = ((0x7ffff000000fULL 
                                      & __Vfunc_fp32_decode__4__d) 
                                     | ((QData)((IData)(
                                                        (0x800000U 
                                                         | (0x7fffffU 
                                                            & __Vfunc_fp32_decode__4__r)))) 
                                        << 4U));
        __Vfunc_fp32_decode__4__d = ((0x7fc00fffffffULL 
                                      & __Vfunc_fp32_decode__4__d) 
                                     | ((QData)((IData)(
                                                        (0x3ffU 
                                                         & (VL_EXTENDS_II(10,10, 
                                                                          (0xffU 
                                                                           & (__Vfunc_fp32_decode__4__r 
                                                                              >> 0x17U))) 
                                                            - (IData)(0x7fU))))) 
                                        << 0x1cU));
    }
    __Vfunc_fp32_decode__4__Vfuncout = __Vfunc_fp32_decode__4__d;
    tb_fp32_utils__DOT__d = __Vfunc_fp32_decode__4__Vfuncout;
    VL_WRITEF("x = 7f800000 (+Inf)  nan=%0# inf=%0#\n",
              1,(1U & (IData)((tb_fp32_utils__DOT__d 
                               >> 1U))),1,(1U & (IData)(
                                                        (tb_fp32_utils__DOT__d 
                                                         >> 2U))));
    __Vfunc_fp32_decode__6__r = 0x7fc00000U;
    __Vfunc_fp32_decode__6__d = (0x3fc000000000ULL 
                                 | (0x3fffffffffULL 
                                    & __Vfunc_fp32_decode__6__d));
    __Vfunc_fp32_decode__6__d = (2ULL | (0x7ffffffffff0ULL 
                                         & __Vfunc_fp32_decode__6__d));
    if ((1U & (IData)((__Vfunc_fp32_decode__6__d >> 3U)))) {
        __Vfunc_fp32_decode__6__d = (0x7fc00000000fULL 
                                     & __Vfunc_fp32_decode__6__d);
    } else if ((1U & (IData)(__Vfunc_fp32_decode__6__d))) {
        __Vfunc_fp32_decode__6__d = ((0x7fc00000000fULL 
                                      & __Vfunc_fp32_decode__6__d) 
                                     | (0x3820000000ULL 
                                        | ((QData)((IData)(
                                                           (0x7fffffU 
                                                            & __Vfunc_fp32_decode__6__r))) 
                                           << 4U)));
    } else if ((IData)((0ULL != (6ULL & __Vfunc_fp32_decode__6__d)))) {
        __Vfunc_fp32_decode__6__d = (0x7fc00000000fULL 
                                     & __Vfunc_fp32_decode__6__d);
    } else {
        __Vfunc_fp32_decode__6__d = ((0x7ffff000000fULL 
                                      & __Vfunc_fp32_decode__6__d) 
                                     | ((QData)((IData)(
                                                        (0x800000U 
                                                         | (0x7fffffU 
                                                            & __Vfunc_fp32_decode__6__r)))) 
                                        << 4U));
        __Vfunc_fp32_decode__6__d = ((0x7fc00fffffffULL 
                                      & __Vfunc_fp32_decode__6__d) 
                                     | ((QData)((IData)(
                                                        (0x3ffU 
                                                         & (VL_EXTENDS_II(10,10, 
                                                                          (0xffU 
                                                                           & (__Vfunc_fp32_decode__6__r 
                                                                              >> 0x17U))) 
                                                            - (IData)(0x7fU))))) 
                                        << 0x1cU));
    }
    __Vfunc_fp32_decode__6__Vfuncout = __Vfunc_fp32_decode__6__d;
    tb_fp32_utils__DOT__d = __Vfunc_fp32_decode__6__Vfuncout;
    VL_WRITEF("x = 7fc00000 (NaN)   nan=%0# inf=%0#\n",
              1,(1U & (IData)((tb_fp32_utils__DOT__d 
                               >> 1U))),1,(1U & (IData)(
                                                        (tb_fp32_utils__DOT__d 
                                                         >> 2U))));
    __Vfunc_fp32_decode__8__r = 0U;
    __Vfunc_fp32_decode__8__d = (0x3fffffffffULL & __Vfunc_fp32_decode__8__d);
    __Vfunc_fp32_decode__8__d = (8ULL | (0x7ffffffffff0ULL 
                                         & __Vfunc_fp32_decode__8__d));
    if ((1U & (IData)((__Vfunc_fp32_decode__8__d >> 3U)))) {
        __Vfunc_fp32_decode__8__d = (0x7fc00000000fULL 
                                     & __Vfunc_fp32_decode__8__d);
    } else if ((1U & (IData)(__Vfunc_fp32_decode__8__d))) {
        __Vfunc_fp32_decode__8__d = ((0x7fc00000000fULL 
                                      & __Vfunc_fp32_decode__8__d) 
                                     | (0x3820000000ULL 
                                        | ((QData)((IData)(
                                                           (0x7fffffU 
                                                            & __Vfunc_fp32_decode__8__r))) 
                                           << 4U)));
    } else if ((IData)((0ULL != (6ULL & __Vfunc_fp32_decode__8__d)))) {
        __Vfunc_fp32_decode__8__d = (0x7fc00000000fULL 
                                     & __Vfunc_fp32_decode__8__d);
    } else {
        __Vfunc_fp32_decode__8__d = ((0x7ffff000000fULL 
                                      & __Vfunc_fp32_decode__8__d) 
                                     | ((QData)((IData)(
                                                        (0x800000U 
                                                         | (0x7fffffU 
                                                            & __Vfunc_fp32_decode__8__r)))) 
                                        << 4U));
        __Vfunc_fp32_decode__8__d = ((0x7fc00fffffffULL 
                                      & __Vfunc_fp32_decode__8__d) 
                                     | ((QData)((IData)(
                                                        (0x3ffU 
                                                         & (VL_EXTENDS_II(10,10, 
                                                                          (0xffU 
                                                                           & (__Vfunc_fp32_decode__8__r 
                                                                              >> 0x17U))) 
                                                            - (IData)(0x7fU))))) 
                                        << 0x1cU));
    }
    __Vfunc_fp32_decode__8__Vfuncout = __Vfunc_fp32_decode__8__d;
    tb_fp32_utils__DOT__d = __Vfunc_fp32_decode__8__Vfuncout;
    VL_WRITEF("x = 00000000 (+0.0) zero=%0# sub=%0#\n",
              1,(1U & (IData)((tb_fp32_utils__DOT__d 
                               >> 3U))),1,(1U & (IData)(tb_fp32_utils__DOT__d)));
    VL_FINISH_MT("tb_fp32_utils.sv", 41, "");
}

VL_ATTR_COLD void Vtb_fp32_utils___024root___eval_final(Vtb_fp32_utils___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtb_fp32_utils__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_fp32_utils___024root___eval_final\n"); );
}

VL_ATTR_COLD void Vtb_fp32_utils___024root___eval_settle(Vtb_fp32_utils___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtb_fp32_utils__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_fp32_utils___024root___eval_settle\n"); );
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtb_fp32_utils___024root___dump_triggers__act(Vtb_fp32_utils___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtb_fp32_utils__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_fp32_utils___024root___dump_triggers__act\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VactTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
}
#endif  // VL_DEBUG

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtb_fp32_utils___024root___dump_triggers__nba(Vtb_fp32_utils___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtb_fp32_utils__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_fp32_utils___024root___dump_triggers__nba\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VnbaTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vtb_fp32_utils___024root___ctor_var_reset(Vtb_fp32_utils___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtb_fp32_utils__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_fp32_utils___024root___ctor_var_reset\n"); );
}
