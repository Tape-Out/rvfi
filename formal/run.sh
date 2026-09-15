#!/usr/bin/env bash
# 本机跑 riscv-formal：formal/run.sh <核目录> [检查名...]
#
# <核目录> 里放 wrapper.sv、checks.cfg 与被验的 Verilog（checks.cfg 的 verilog-files 列到的文件），
# 目录名就是 riscv-formal 里的核名。riscv-formal 钉在 c992aa61（2026-07-15），第一次跑时克隆到
# $WORK（缺省 build/riscv-formal）。要 sby、yosys-smtbmc 与 checks.cfg 选的求解器在 PATH 上，
# oss-cad-suite 带齐。J 是并行数，缺省为核数。检查名缺省全跑；结论按项列出，有一项不过则退出码为 1。
set -eu
[ $# -ge 1 ] || { sed -n '2,8p' "$0"; exit 2; }
src=$(cd "$1" && pwd)
shift
core=$(basename "$src")
rev=c992aa61fdfe0846c5ed90324c596202a1c69b76
work=${WORK:-$(cd "$(dirname "$0")/.." && pwd)/build/riscv-formal}

if [ ! -d "$work/.git" ]; then
  git clone -q https://github.com/YosysHQ/riscv-formal "$work"
fi
if [ "$(git -C "$work" rev-parse HEAD)" != "$rev" ]; then
  git -C "$work" fetch -q origin "$rev" 2>/dev/null || true
  git -C "$work" checkout -q "$rev"
fi

dst=$work/cores/$core
rm -rf "$dst"
mkdir -p "$dst"
cp "$src"/* "$dst"/
cd "$dst"
python3 ../../checks/genchecks.py > genchecks.log
tail -1 genchecks.log
make -C checks -k -j"${J:-$(nproc)}" "${@:-all}" > make.log 2>&1 || true

cd checks
pass=0
bad=0
for f in *.sby; do
  n=${f%.sby}
  if [ $# -gt 0 ] && ! printf '%s\n' "$@" | grep -qx "$n"; then continue; fi
  r=$(cut -d' ' -f1 "$n/status" 2>/dev/null || echo NONE)
  if [ "$r" = PASS ]; then
    pass=$((pass + 1))
  else
    bad=$((bad + 1))
    echo "$r $n"
  fi
done
echo "PASS $pass, not passing $bad"
[ "$bad" -eq 0 ]
