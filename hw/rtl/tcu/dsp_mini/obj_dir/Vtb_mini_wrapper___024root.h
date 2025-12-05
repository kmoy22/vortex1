// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vtb_mini_wrapper.h for the primary calling header

#ifndef VERILATED_VTB_MINI_WRAPPER___024ROOT_H_
#define VERILATED_VTB_MINI_WRAPPER___024ROOT_H_  // guard

#include "verilated.h"
#include "verilated_timing.h"


class Vtb_mini_wrapper__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vtb_mini_wrapper___024root final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    CData/*0:0*/ tb_mini_wrapper__DOT__clk;
    CData/*0:0*/ tb_mini_wrapper__DOT__rst;
    CData/*3:0*/ tb_mini_wrapper__DOT__alumode;
    CData/*6:0*/ tb_mini_wrapper__DOT__opmode;
    CData/*4:0*/ tb_mini_wrapper__DOT__inmode;
    CData/*0:0*/ tb_mini_wrapper__DOT__carrycascin;
    CData/*2:0*/ tb_mini_wrapper__DOT__carryinsel;
    CData/*0:0*/ tb_mini_wrapper__DOT__carryin;
    CData/*3:0*/ tb_mini_wrapper__DOT__carryout;
    CData/*7:0*/ tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__opmode;
    CData/*7:0*/ tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__alumode;
    CData/*7:0*/ tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__inmode;
    CData/*7:0*/ tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__carryinsel;
    CData/*0:0*/ tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__carryin;
    CData/*0:0*/ tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__carrycascin;
    CData/*0:0*/ tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__p_carry;
    CData/*0:0*/ __Vdlyvval__tb_mini_wrapper__DOT__clk__v0;
    CData/*0:0*/ __Vdlyvset__tb_mini_wrapper__DOT__clk__v0;
    CData/*0:0*/ __Vtrigprevexpr___TOP__tb_mini_wrapper__DOT__clk__0;
    CData/*0:0*/ __VactContinue;
    IData/*29:0*/ tb_mini_wrapper__DOT__a;
    IData/*17:0*/ tb_mini_wrapper__DOT__b;
    IData/*24:0*/ tb_mini_wrapper__DOT__d;
    IData/*29:0*/ tb_mini_wrapper__DOT__acin;
    IData/*17:0*/ tb_mini_wrapper__DOT__bcin;
    IData/*29:0*/ tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__A2;
    IData/*17:0*/ tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__B2;
    IData/*31:0*/ tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__a1;
    IData/*31:0*/ tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__a2;
    IData/*31:0*/ tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__b1;
    IData/*31:0*/ tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__b2;
    IData/*31:0*/ tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__c;
    IData/*31:0*/ tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__d;
    IData/*31:0*/ __VactIterCount;
    QData/*47:0*/ tb_mini_wrapper__DOT__c;
    QData/*47:0*/ tb_mini_wrapper__DOT__p;
    QData/*63:0*/ tb_mini_wrapper__DOT__DUT__DOT__u_dsp48e1__DOT__unnamedblk1__DOT__result;
    VlUnpacked<CData/*0:0*/, 3> __Vm_traceActivity;
    VlDelayScheduler __VdlySched;
    VlTriggerScheduler __VtrigSched_hb01a9ace__0;
    VlTriggerVec<2> __VactTriggered;
    VlTriggerVec<2> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vtb_mini_wrapper__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vtb_mini_wrapper___024root(Vtb_mini_wrapper__Syms* symsp, const char* v__name);
    ~Vtb_mini_wrapper___024root();
    VL_UNCOPYABLE(Vtb_mini_wrapper___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
