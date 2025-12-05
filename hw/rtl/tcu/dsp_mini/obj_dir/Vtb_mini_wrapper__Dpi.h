// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Prototypes for DPI import and export functions.
//
// Verilator includes this file in all generated .cpp files that use DPI functions.
// Manually include this file where DPI .c import functions are declared to ensure
// the C functions match the expectations of the DPI imports.

#ifndef VERILATED_VTB_MINI_WRAPPER__DPI_H_
#define VERILATED_VTB_MINI_WRAPPER__DPI_H_  // guard

#include "svdpi.h"

#ifdef __cplusplus
extern "C" {
#endif


    // DPI IMPORTS
    // DPI import at DSP48E1.sv:100:34
    extern svLogic dsp48e1_carry_dpi_wrapper(int a1, int a2, int b1, int b2, long long c, int d, char opmode, char alumode, char inmode, char carryinsel, svLogic carryin, svLogic carrycascin);
    // DPI import at DSP48E1.sv:99:36
    extern long long dsp48e1_dpi_wrapper(int a1, int a2, int b1, int b2, long long c, int d, char opmode, char alumode, char inmode, char carryinsel, svLogic carryin, svLogic carrycascin);

#ifdef __cplusplus
}
#endif

#endif  // guard
