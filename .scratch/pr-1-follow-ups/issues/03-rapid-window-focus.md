# 快速连按 Super+grave 可能重复选择同一窗口

Status: needs-triage
Scope: 主分支待核实

同一应用有多个窗口时，前一次焦点请求还未被 Hyprland 回报，下一次可能从旧窗口继续计算并重复选择同一个窗口。

## 验证要点

用三个同应用窗口验证连按按稳定顺序访问每个窗口，覆盖跨工作区、反向切换和迟到的焦点报告。另见 #12。

[来源提交](https://github.com/harryxu/omarchy-super-switcher/commit/f69ba4419f4d983271ccdc87661dbb80792dcc7e)
