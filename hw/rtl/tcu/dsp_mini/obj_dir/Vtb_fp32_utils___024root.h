// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vtb_fp32_utils.h for the primary calling header

#ifndef VERILATED_VTB_FP32_UTILS___024ROOT_H_
#define VERILATED_VTB_FP32_UTILS___024ROOT_H_  // guard

#include "verilated.h"


class Vtb_fp32_utils__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vtb_fp32_utils___024root final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    CData/*0:0*/ __VactContinue;
    IData/*31:0*/ __VactIterCount;
    VlTriggerVec<0> __VactTriggered;
    VlTriggerVec<0> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vtb_fp32_utils__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vtb_fp32_utils___024root(Vtb_fp32_utils__Syms* symsp, const char* v__name);
    ~Vtb_fp32_utils___024root();
    VL_UNCOPYABLE(Vtb_fp32_utils___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
