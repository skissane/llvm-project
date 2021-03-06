# REQUIRES: ppc
## Test code sequences of synthesized _savegpr1_{14..31}

# RUN: llvm-mc -filetype=obj -triple=ppc64le %s -o %t14.o
# RUN: ld.lld %t14.o -o %t14
# RUN: llvm-objdump -d %t14 | FileCheck --check-prefix=R14 %s

# R14-LABEL: <_savegpr1_14>:
# R14-NEXT:    std 14, -144(12)
# R14-NEXT:    std 15, -136(12)
# R14-EMPTY:
# R14-NEXT:  <_savegpr1_16>:
# R14-NEXT:    std 16, -128(12)
# R14:         std 31, -8(12)
# R14-NEXT:    blr

## Don't synthesize _savegpr1_{14..30} because they are unused.
# RUN: echo 'bl _savegpr1_31' | llvm-mc -filetype=obj -triple=ppc64 - -o %t31.o
# RUN: ld.lld %t31.o -o %t31
# RUN: llvm-objdump -d %t31 | FileCheck --check-prefix=R31 %s

# R31-LABEL: Disassembly of section .text:
# R31-EMPTY:
# R31-NEXT:  <_savegpr1_31>:
# R31-NEXT:    std 31, -8(12)
# R31-NEXT:    blr

# RUN: echo 'bl _savegpr1_32' | llvm-mc -filetype=obj -triple=ppc64le - -o %t32.o
# RUN: not ld.lld %t32.o -o /dev/null

.globl _start
_start:
  bl _savegpr1_14
  bl _savegpr1_16
