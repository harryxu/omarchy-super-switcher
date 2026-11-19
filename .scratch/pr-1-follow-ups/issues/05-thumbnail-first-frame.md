# 面板首屏可能没有预览帧

Status: needs-triage
Scope: 主分支待核实

当前面板可见后才创建预览项，因此工作区或窗口卡片可能先显示占位内容，再填入缩略图。PR 还记录了提前创建预览后，在面板显示时因宽度变化导致预览重建的问题。

## 验证要点

测量从确认长按到面板可用、以及到缩略图就绪的时间。覆盖 `Alt+Tab` 的静态和实时预览、`Super+grave` 的静态预览，以及不可抓取的窗口。相关约束见 #10、#11、#13。

[来源提交](https://github.com/harryxu/omarchy-super-switcher/commit/7b8ab0d6db6474a3b4a2ab3b58e37d4b3c947022)
