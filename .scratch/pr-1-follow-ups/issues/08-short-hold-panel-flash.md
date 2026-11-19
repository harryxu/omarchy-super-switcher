# 刚过长按阈值松键可能让面板闪现

Status: needs-triage
Scope: 主分支待核实

PR 报告在面板刚出现时松开修饰键，面板会全亮闪现几帧。作者尝试用 140 ms 淡入降低这种闪现。

## 验证要点

用长按阈值附近的时序复现，核对短暂闪现、正常长按的可用时间，以及松键后的激活时序。

[来源提交](https://github.com/harryxu/omarchy-super-switcher/commit/c9175f9ca3fe05cf3c6154921d184c789fa953d6)
