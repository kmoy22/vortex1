// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "Vtb_fp32_utils__pch.h"

//============================================================
// Constructors

Vtb_fp32_utils::Vtb_fp32_utils(VerilatedContext* _vcontextp__, const char* _vcname__)
    : VerilatedModel{*_vcontextp__}
    , vlSymsp{new Vtb_fp32_utils__Syms(contextp(), _vcname__, this)}
    , rootp{&(vlSymsp->TOP)}
{
    // Register model with the context
    contextp()->addModel(this);
}

Vtb_fp32_utils::Vtb_fp32_utils(const char* _vcname__)
    : Vtb_fp32_utils(Verilated::threadContextp(), _vcname__)
{
}

//============================================================
// Destructor

Vtb_fp32_utils::~Vtb_fp32_utils() {
    delete vlSymsp;
}

//============================================================
// Evaluation function

#ifdef VL_DEBUG
void Vtb_fp32_utils___024root___eval_debug_assertions(Vtb_fp32_utils___024root* vlSelf);
#endif  // VL_DEBUG
void Vtb_fp32_utils___024root___eval_static(Vtb_fp32_utils___024root* vlSelf);
void Vtb_fp32_utils___024root___eval_initial(Vtb_fp32_utils___024root* vlSelf);
void Vtb_fp32_utils___024root___eval_settle(Vtb_fp32_utils___024root* vlSelf);
void Vtb_fp32_utils___024root___eval(Vtb_fp32_utils___024root* vlSelf);

void Vtb_fp32_utils::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vtb_fp32_utils::eval_step\n"); );
#ifdef VL_DEBUG
    // Debug assertions
    Vtb_fp32_utils___024root___eval_debug_assertions(&(vlSymsp->TOP));
#endif  // VL_DEBUG
    vlSymsp->__Vm_deleter.deleteAll();
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) {
        vlSymsp->__Vm_didInit = true;
        VL_DEBUG_IF(VL_DBG_MSGF("+ Initial\n"););
        Vtb_fp32_utils___024root___eval_static(&(vlSymsp->TOP));
        Vtb_fp32_utils___024root___eval_initial(&(vlSymsp->TOP));
        Vtb_fp32_utils___024root___eval_settle(&(vlSymsp->TOP));
    }
    VL_DEBUG_IF(VL_DBG_MSGF("+ Eval\n"););
    Vtb_fp32_utils___024root___eval(&(vlSymsp->TOP));
    // Evaluate cleanup
    Verilated::endOfEval(vlSymsp->__Vm_evalMsgQp);
}

//============================================================
// Events and timing
bool Vtb_fp32_utils::eventsPending() { return false; }

uint64_t Vtb_fp32_utils::nextTimeSlot() {
    VL_FATAL_MT(__FILE__, __LINE__, "", "%Error: No delays in the design");
    return 0;
}

//============================================================
// Utilities

const char* Vtb_fp32_utils::name() const {
    return vlSymsp->name();
}

//============================================================
// Invoke final blocks

void Vtb_fp32_utils___024root___eval_final(Vtb_fp32_utils___024root* vlSelf);

VL_ATTR_COLD void Vtb_fp32_utils::final() {
    Vtb_fp32_utils___024root___eval_final(&(vlSymsp->TOP));
}

//============================================================
// Implementations of abstract methods from VerilatedModel

const char* Vtb_fp32_utils::hierName() const { return vlSymsp->name(); }
const char* Vtb_fp32_utils::modelName() const { return "Vtb_fp32_utils"; }
unsigned Vtb_fp32_utils::threads() const { return 1; }
void Vtb_fp32_utils::prepareClone() const { contextp()->prepareClone(); }
void Vtb_fp32_utils::atClone() const {
    contextp()->threadPoolpOnClone();
}

//============================================================
// Trace configuration

VL_ATTR_COLD void Vtb_fp32_utils::trace(VerilatedVcdC* tfp, int levels, int options) {
    vl_fatal(__FILE__, __LINE__, __FILE__,"'Vtb_fp32_utils::trace()' called on model that was Verilated without --trace option");
}
