package RvfiPins;

// RVFI 的输出端口，名字逐个照 rvfi.rst 原名写。本机锁定的 bsc 2026.01 没有 SplitPorts，
// 结构体拆不成多个端口，只能一个信号一个方法；接进核的接口时子接口要标 prefix = ""，端口才不带前缀

import Rvfi::*;

interface RvfiPins;
  (* always_ready, result = "rvfi_valid" *)     method Bool     valid;
  (* always_ready, result = "rvfi_order" *)     method Bit#(64) order;
  (* always_ready, result = "rvfi_insn" *)      method Bit#(32) insn;
  (* always_ready, result = "rvfi_trap" *)      method Bool     trap;
  (* always_ready, result = "rvfi_halt" *)      method Bool     halt;
  (* always_ready, result = "rvfi_intr" *)      method Bool     intr;
  (* always_ready, result = "rvfi_mode" *)      method Bit#(2)  mode;
  (* always_ready, result = "rvfi_ixl" *)       method Bit#(2)  ixl;
  (* always_ready, result = "rvfi_rs1_addr" *)  method Bit#(5)  rs1_addr;
  (* always_ready, result = "rvfi_rs2_addr" *)  method Bit#(5)  rs2_addr;
  (* always_ready, result = "rvfi_rs1_rdata" *) method Bit#(32) rs1_rdata;
  (* always_ready, result = "rvfi_rs2_rdata" *) method Bit#(32) rs2_rdata;
  (* always_ready, result = "rvfi_rd_addr" *)   method Bit#(5)  rd_addr;
  (* always_ready, result = "rvfi_rd_wdata" *)  method Bit#(32) rd_wdata;
  (* always_ready, result = "rvfi_pc_rdata" *)  method Bit#(32) pc_rdata;
  (* always_ready, result = "rvfi_pc_wdata" *)  method Bit#(32) pc_wdata;
  (* always_ready, result = "rvfi_mem_addr" *)  method Bit#(32) mem_addr;
  (* always_ready, result = "rvfi_mem_rmask" *) method Bit#(4)  mem_rmask;
  (* always_ready, result = "rvfi_mem_wmask" *) method Bit#(4)  mem_wmask;
  (* always_ready, result = "rvfi_mem_rdata" *) method Bit#(32) mem_rdata;
  (* always_ready, result = "rvfi_mem_wdata" *) method Bit#(32) mem_wdata;
endinterface

function RvfiPins rvfiPins(Rvfi r) =
  interface RvfiPins;
    method valid     = r.valid;
    method order     = r.order;
    method insn      = r.insn;
    method trap      = r.trap;
    method halt      = r.halt;
    method intr      = r.intr;
    method mode      = r.mode;
    method ixl       = r.ixl;
    method rs1_addr  = r.rs1_addr;
    method rs2_addr  = r.rs2_addr;
    method rs1_rdata = r.rs1_rdata;
    method rs2_rdata = r.rs2_rdata;
    method rd_addr   = r.rd_addr;
    method rd_wdata  = r.rd_wdata;
    method pc_rdata  = r.pc_rdata;
    method pc_wdata  = r.pc_wdata;
    method mem_addr  = r.mem_addr;
    method mem_rmask = r.mem_rmask;
    method mem_wmask = r.mem_wmask;
    method mem_rdata = r.mem_rdata;
    method mem_wdata = r.mem_wdata;
  endinterface;

endpackage
