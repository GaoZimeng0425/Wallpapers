import Cocoa
import SwiftUI
import WebKit

struct WebView2: View {
  var body: some View {
    Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
  }
}

#Preview {
  WebView2()
}

class ViewController: NSViewController, WKUIDelegate {
  var webView: WKWebView!

  override func loadView() {
    let webConfiguration = WKWebViewConfiguration()
    webConfiguration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
    webView = WKWebView(
      frame: CGRect(x: 0, y: 0, width: 800, height: 600),
      configuration: webConfiguration
    )
    webView.uiDelegate = self
    view = webView
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    if let url = Bundle.main.url(
      forResource: "AppName",
      withExtension: "html",
      subdirectory: "www"
    ) {
      let path = url.deletingLastPathComponent()
      webView.loadFileURL(
        url,
        allowingReadAccessTo: path
      )
      view = webView
    }
  }
}
