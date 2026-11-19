# PR 的应用面板会额外等待预览兜底定时器

Status: needs-triage
Scope: PR #1 的实现

PR 的应用模式提前返回，漏设 `revealed`。即使输入已就绪，也会等 150 ms 定时器；等待期间松键还会推迟依赖键盘焦点的释放检查。离屏测试观察到 163 ms。

## 验证要点

后续预览改动须验证应用模式在输入就绪后立即可见，并覆盖此时松键的激活行为。

[PR 评审](https://github.com/harryxu/omarchy-super-switcher/pull/1#issuecomment-6900658919)
