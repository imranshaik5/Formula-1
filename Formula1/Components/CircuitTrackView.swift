import SwiftUI
import WebKit

struct CircuitTrackView: UIViewRepresentable {
    let svgURL: URL
    var neonGlow: Bool = false

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = false
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.isScrollEnabled = false
        webView.navigationDelegate = context.coordinator
        let request = URLRequest(url: svgURL)
        webView.load(request)
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(neonGlow: neonGlow)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        let neonGlow: Bool
        init(neonGlow: Bool) { self.neonGlow = neonGlow }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            guard neonGlow else { return }
            let css = """
            document.querySelectorAll('path, line, polyline, polygon').forEach(el => {
                el.style.filter = "drop-shadow(0 0 3px rgba(255,255,255,0.5)) drop-shadow(0 0 8px rgba(255,255,255,0.2))";
            });
            """
            webView.evaluateJavaScript(css, completionHandler: nil)
        }
    }
}
