# 应用图标首帧可能跳变尺寸

Status: needs-triage
Scope: 主分支待核实

PR 报告图标会先按回退尺寸显示，随后应用已测得的边界。作者提出同步使用已有几何缓存，并将测量结果跨 Shell 重启保存。

## 验证要点

分别观察冷启动和已有缓存时的首帧，确认是否有可见跳变。若采用持久缓存，验证换主题或更换图标后能使用新的几何。

[来源提交](https://github.com/harryxu/omarchy-super-switcher/commit/03b439a202bcd96bc82748db056cc987eb6580a5)
