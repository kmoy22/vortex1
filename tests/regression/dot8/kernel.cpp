#include <vx_spawn.h>
#include "common.h"
#include <cstdio>

void kernel_body(kernel_arg_t* __UNIFORM__ arg) {
	auto A = reinterpret_cast<int8_t*>(arg->A_addr);
	auto B = reinterpret_cast<int8_t*>(arg->B_addr);
	auto C = reinterpret_cast<int32_t*>(arg->C_addr);
    auto size = arg->size;

    int col = blockIdx.x;
    int row = blockIdx.y;
    /*TYPE sum(0);
    for (int e = 0; e < size; ++e) {
        sum += A[row * size + e] * B[e * size + col];
    }

    C[row * size + col] = sum;*/

    for (int k = 0; k < size; k += 4) {
        // Pack 4 int8_t elements from A and B into 32-bit integers
        uint32_t packedA = ((uint8_t)A[row * size + k + 0] << 0) |
                           ((uint8_t)A[row * size + k + 1] << 8) |
                           ((uint8_t)A[row * size + k + 2] << 16) |
                           ((uint8_t)A[row * size + k + 3] << 24);

        uint32_t packedB = ((uint8_t)B[k * size + col + 0] << 0) |
                           ((uint8_t)B[(k + 1) * size + col] << 8) |
                           ((uint8_t)B[(k + 2) * size + col] << 16) |
                           ((uint8_t)B[(k + 3) * size + col] << 24);

        // Accumulate the dot product result into the C
        C[row * size + col] += vx_dot8(packedA, packedB);
    }
}

int main() {
	kernel_arg_t* arg = (kernel_arg_t*)csr_read(VX_CSR_MSCRATCH);
	return vx_spawn_threads(2, arg->grid_dim, nullptr, (vx_kernel_func_cb)kernel_body, arg);
}
