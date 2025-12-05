#include "Vtb_mini_wrapper.h"
#include "verilated.h"

vluint64_t main_time = 0;

double sc_time_stamp() {
    return main_time;
}

int main(int argc, char **argv) {
    Verilated::commandArgs(argc, argv);
    Verilated::traceEverOn(true);

    Vtb_mini_wrapper *tb = new Vtb_mini_wrapper;

    while (!Verilated::gotFinish()) {
        tb->eval(); 
        main_time++; 
    }

    delete tb;
    return 0;
}