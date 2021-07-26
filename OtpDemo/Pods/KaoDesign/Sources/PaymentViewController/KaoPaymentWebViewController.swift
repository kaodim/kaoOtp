//
//  PaymentWebViewController.swift
//  KaoDesign
//
//  Created by Ismail Sahak on 17/07/2020.
//


import UIKit
import WebKit

open class KaoPaymentWebViewController: KaoBaseViewController {
    public var paymentUrl: String!
    public var callBackUrl: String!

    public let PAYMENTSTATUSSUCCESS = "1"
    public let PAYMENTSTATUSFAILURE = "0"

    public var webView: WKWebView!
    private var loadingView: UIActivityIndicatorView!
    private var progressView: UIProgressView!

    public var isGeneratedResponse = false
    public var paymentSuccess: (() -> Void)?
    public var paymentFail: (() -> Void)?
    public var paymentCancel: (() -> Void)?

    var webViewURLObserver: NSKeyValueObservation?

    override open func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem.kaodimBackButton(
            target: self, action: #selector(showBackAlert))
        view.backgroundColor = .white
        initProgressBar()
        initLoadingView()
        setWebView()
    }

    private func initProgressBar() {
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        progressView.tintColor = UIColor.kaoColor(.crimson)
        navigationController?.navigationBar.addSubview(progressView)
        if let navigationBarBounds = navigationController?.navigationBar.bounds {
            progressView.frame = CGRect(
                x: 0, y: navigationBarBounds.size.height - 2, width: navigationBarBounds.size.width,
                height: 2)
        }
        progressView.isHidden = true
    }

    private func initLoadingView() {
        if #available(iOS 13.0, *) {
            loadingView = UIActivityIndicatorView(style: .large)
        } else {
            loadingView = UIActivityIndicatorView(style: .gray)
        }

        loadingView = UIActivityIndicatorView(style: .gray)
        loadingView.startAnimating()
        loadingView.frame = CGRect(
            x: CGFloat(0), y: CGFloat(0), width: view.bounds.width, height: CGFloat(70)
        )
        loadingView.center = view.center
        loadingView.hidesWhenStopped = true
        view.addSubview(loadingView)
        loadingView.startAnimating()
    }

    @objc open func showBackAlert() { }
    
    private func setWebView() {
        if paymentUrl == nil || callBackUrl == nil {
            popView()
            paymentFail?()
            return
        }

        guard let url = URL(string: paymentUrl) else {
            popView()
            paymentFail?()
            return
        }

       let jscript = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width, initial-scale=0.98, , maximum-scale=0.98 , shrink-to-fit=yes'); document.getElementsByTagName('head')[0].appendChild(meta);"

        let userScript = WKUserScript(source: jscript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let wkUController = WKUserContentController()
        wkUController.addUserScript(userScript)
        let wkWebConfig = WKWebViewConfiguration()
        wkWebConfig.userContentController = wkUController

        webView = WKWebView(frame: .zero, configuration: wkWebConfig)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        view.addSubview(webView)

        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                webView.topAnchor
                    .constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                webView.leftAnchor
                    .constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
                webView.bottomAnchor
                    .constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
                webView.rightAnchor
                    .constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor)
            ])
        } else {
            // Fallback on earlier versions
        }

        let request = URLRequest(url: url)
        webView.load(request)

    }

    @objc open func popView() {
        navigationController?.popViewController(animated: false)
    }

    private func checkUrl(url: URL) {
        guard var components = URLComponents(string: url.absoluteString) else { return }

        components.query = nil

        if let callBackUrl = callBackUrl, let newUrl = components.url {
            if callBackUrl == newUrl.absoluteString {
                generatePaymentResponse(url: url)
            }
        }

    }

    open func generatePaymentResponse(url: URL) { }
}

extension KaoPaymentWebViewController: WKNavigationDelegate {
    // MARK: - WKNavigationDelegate

    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url {
            checkUrl(url: url)
        }

        decisionHandler(.allow)
    }

    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        loadingView.startAnimating()
        progressView.isHidden = true
    }

    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingView.stopAnimating()
        progressView.isHidden = true
    }

    public func webView(
        _ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!,
        withError error: Error
    ) {
        progressView.isHidden = true
        loadingView.stopAnimating()
    }
}
