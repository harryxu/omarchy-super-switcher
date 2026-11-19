# PR 的快点路径会提前创建预览项

Status: needs-triage
Scope: PR #1 的实现

PR 用 `root.active` 打开列表。离屏 QML 测试确认，尚未判定为长按且面板仍隐藏时，列表项已经实例化。实际 Wayland 抓帧次数未测。

## 验证要点

快点 `Alt+Tab` 或 `Super+grave` 应完成切换且不映射面板、不发起预览抓帧。另测确认长按时预览正常启动。

[PR 评审](https://github.com/harryxu/omarchy-super-switcher/pull/1#issuecomment-6900658919)
