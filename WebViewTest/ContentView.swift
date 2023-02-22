import SwiftUI
import WebKit
import SafariServices
import BetterSafariView

let someContent = "🤩 CONTENT SUPPOSED TO BE PASSED TO WEBVIEW"

struct ContentView: View {
    private let url = URL(string: "https://danurna.github.io/webview-links-behaviour/")!
    @State private var showWebView = false
    @State private var showSafari = false
    @State private var showBetterSafariView = false
    
    var body: some View {
        VStack {
            Text("Hello, world!")
                .padding()
            Link(destination: url, label: {
                Text("External Link")
                    .foregroundColor(.orange)
            })
            
            Button {
                showWebView.toggle()
            } label: {
                Text("Webview")
                    .foregroundColor(.green)
            }
            .sheet(isPresented: $showWebView) {
                WebView(url: url)
            }
            
            Button {
                showSafari.toggle()
            } label: {
                Text("Safari")
            }
            .sheet(isPresented: $showSafari) {
                SFSafariViewControllerView(url: url)
            }
            
            Button(action: {
                showBetterSafariView.toggle()
            }) {
                Text("BetterSafariView")
                    .foregroundColor(.mint)
            }
            .safariView(isPresented: $showBetterSafariView) {
                SafariView(
                    url: url,
                    configuration: SafariView.Configuration(
                        entersReaderIfAvailable: false,
                        barCollapsingEnabled: true
                    )
                )
                .preferredBarAccentColor(.clear)
                .preferredControlAccentColor(.accentColor)
                .dismissButtonStyle(.done)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

let messageHandlerId = "sampleMessageHandler"
let messageHandler = WebViewMessageHandler()

struct WebView: UIViewRepresentable {
    var url: URL
 
    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.userContentController.addScriptMessageHandler(messageHandler, contentWorld: .page, name: messageHandlerId)
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.scrollView.isScrollEnabled = false
        return webView
    }
 
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

class WebViewMessageHandler: NSObject, WKScriptMessageHandlerWithReply {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage, replyHandler: @escaping (Any?, String?) -> Void) {
        guard message.name == messageHandlerId else { return }
        
        print("Got: \(message.body)")
        replyHandler(someContent, nil)
    }
}

struct SFSafariViewControllerView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: UIViewControllerRepresentableContext<SFSafariViewControllerView>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SFSafariViewControllerView>) {

    }
}
