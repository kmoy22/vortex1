// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vtb_mini_wrapper__Syms.h"


void Vtb_mini_wrapper___024root__trace_chg_0_sub_0(Vtb_mini_wrapper___024root* vlSelf, VerilatedVcd::Buffer* bufp);

void Vtb_mini_wrapper___024root__trace_chg_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_mini_wrapper___024root__trace_chg_0\n"); );
    // Init
    Vtb_mini_wrapper___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vtb_mini_wrapper___024root*>(voidSelf);
    Vtb_mini_wrapper__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (VL_UNLIKELY(!vlSymsp->__Vm_activity)) return;
    // Body
    Vtb_mini_wrapper___024root__trace_chg_0_sub_0((&vlSymsp->TOP), bufp);
}

void Vtb_mini_wrapper___024root__trace_chg_0_sub_0(Vtb_mini_wrapper___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    if (false && vlSelf) {}  // Prevent unused
    Vtb_mini_wrapper__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_mini_wrapper___024root__trace_chg_0_sub_0\n"); );
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode + 1);
    // Body
    if (VL_UNLIKELY(vlSelf->__Vm_traceActivity[1U])) {
        bufp->chgQData(oldp+0,(vlSelf->tb_mini_wrapper__DOT__p),48);
        bufp->chgCData(oldp+2,(vlSelf->tb_mini_wrapper__DOT__carryout),4);
        bufp->chgIData(oldp+3,(vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__a1),32);
        bufp->chgIData(oldp+4,(vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__a2),32);
        bufp->chgIData(oldp+5,(vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__b1),32);
        bufp->chgIData(oldp+6,(vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__b2),32);
        bufp->chgIData(oldp+7,(vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__c),32);
        bufp->chgIData(oldp+8,(vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__d),32);
        bufp->chgCData(oldp+9,(vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__opmode),8);
        bufp->chgCData(oldp+10,(vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__alumode),8);
        bufp->chgCData(oldp+11,(vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__inmode),8);
        bufp->chgCData(oldp+12,(vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__carryinsel),8);
        bufp->chgBit(oldp+13,(vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__carryin));
        bufp->chgBit(oldp+14,(vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__carrycascin));
        bufp->chgQData(oldp+15,(vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__result),64);
        bufp->chgBit(oldp+17,(vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__p_carry));
    }
    if (VL_UNLIKELY((vlSelf->__Vm_traceActivity[1U] 
                     | vlSelf->__Vm_traceActivity[2U]))) {
        bufp->chgBit(oldp+18,(vlSelf->tb_mini_wrapper__DOT__rst));
        bufp->chgIData(oldp+19,(vlSelf->tb_mini_wrapper__DOT__a),30);
        bufp->chgIData(oldp+20,(vlSelf->tb_mini_wrapper__DOT__b),18);
        bufp->chgQData(oldp+21,(vlSelf->tb_mini_wrapper__DOT__c),48);
        bufp->chgIData(oldp+23,(vlSelf->tb_mini_wrapper__DOT__d),25);
        bufp->chgCData(oldp+24,(vlSelf->tb_mini_wrapper__DOT__alumode),4);
        bufp->chgCData(oldp+25,(vlSelf->tb_mini_wrapper__DOT__opmode),7);
        bufp->chgCData(oldp+26,(vlSelf->tb_mini_wrapper__DOT__inmode),5);
        bufp->chgIData(oldp+27,(vlSelf->tb_mini_wrapper__DOT__acin),30);
        bufp->chgIData(oldp+28,(vlSelf->tb_mini_wrapper__DOT__bcin),18);
        bufp->chgBit(oldp+29,(vlSelf->tb_mini_wrapper__DOT__carrycascin));
        bufp->chgCData(oldp+30,(vlSelf->tb_mini_wrapper__DOT__carryinsel),3);
        bufp->chgBit(oldp+31,(vlSelf->tb_mini_wrapper__DOT__carryin));
    }
    bufp->chgBit(oldp+32,(vlSelf->tb_mini_wrapper__DOT__clk));
    bufp->chgIData(oldp+33,(vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__A2),30);
    bufp->chgIData(oldp+34,(vlSelf->tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__B2),18);
}

void Vtb_mini_wrapper___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_mini_wrapper___024root__trace_cleanup\n"); );
    // Init
    Vtb_mini_wrapper___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vtb_mini_wrapper___024root*>(voidSelf);
    Vtb_mini_wrapper__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    // Body
    vlSymsp->__Vm_activity = false;
    vlSymsp->TOP.__Vm_traceActivity[0U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[1U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[2U] = 0U;
}
