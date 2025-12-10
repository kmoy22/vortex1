// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vtb_fp32_utils.h for the primary calling header

#ifndef VERILATED_VTB_FP32_UTILS___024UNIT_H_
#define VERILATED_VTB_FP32_UTILS___024UNIT_H_  // guard

#include "verilated.h"


class Vtb_fp32_utils__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vtb_fp32_utils___024unit final : public VerilatedModule {
  public:

    // INTERNAL VARIABLES
    Vtb_fp32_utils__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vtb_fp32_utils___024unit(Vtb_fp32_utils__Syms* symsp, const char* v__name);
    ~Vtb_fp32_utils___024unit();
    VL_UNCOPYABLE(Vtb_fp32_utils___024unit);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
