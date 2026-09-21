package Probe;

import Rvfi::*;
import RvfiPins::*;

// 库本身不例化硬件：记录类型、组装函数、端口方法都只是线。探针把一条空记录引到 21 个端口，
// 量出来应当近乎为零；核里 rvfi 开着时多出的那一拍寄存器算在核上（hart 的 test.noarea 写明不计）
(* synthesize *)
module mkRvfiProbe(RvfiPins);
  return rvfiPins(idle);
endmodule

endpackage
