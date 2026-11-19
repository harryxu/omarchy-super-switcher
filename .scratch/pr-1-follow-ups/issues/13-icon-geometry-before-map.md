# PR 在面板映射前抓图可能缓存错误图标边界

Status: needs-triage
Scope: PR #1 的实现

预览改动提前实例化列表后，图标可能在面板尚未映射时测量。PR 报告空白或不完整抓图被当成有效边界缓存，造成图标不可见或比例异常。

## 验证要点

验证冷缓存、面板映射前的测量以及关闭后才返回的抓图。无效结果应可重试，并覆盖窄长图标的正常显示。

[来源提交](https://github.com/harryxu/omarchy-super-switcher/commit/97f45c9109d25504868c39ef5976f3cdf42cbcb8)
