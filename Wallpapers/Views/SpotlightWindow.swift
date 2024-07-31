import Cocoa

class SpotlightWindow: NSWindow {
    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
        
        // 设置窗口样式
        self.backgroundColor = NSColor.clear
        self.isOpaque = false
        self.isMovableByWindowBackground = true
        self.level = .floating
        
        // 添加模糊效果
        self.titlebarAppearsTransparent = true
        self.titleVisibility = .hidden
        self.standardWindowButton(.closeButton)?.isHidden = true
        self.standardWindowButton(.miniaturizeButton)?.isHidden = true
        self.standardWindowButton(.zoomButton)?.isHidden = true
        self.contentView?.wantsLayer = true
        self.contentView?.layer?.backgroundColor = NSColor.black.cgColor
        self.contentView?.layer?.opacity = 0.8
        
        // 添加搜索框等 UI 控件
        // ...
    }
}

// 创建一个 SpotlightWindow 实例
// let spotlightWindow = SpotlightWindow(contentRect: NSRect(x: 0, y: 0, width: 400, height: 200), styleMask: [.fullSizeContentView, .titled, .closable, .miniaturizable, .resizable], backing: .buffered, defer: false)

// 显示窗口
// spotlightWindow.makeKeyAndOrderFront(nil)
// NSApp.activate(ignoringOtherApps: true)