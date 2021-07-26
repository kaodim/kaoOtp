//
//  UIView+Extension.swift
//  KaodimIosDesign
//
//  Created by augustius cokroe on 23/07/2018.
//  Copyright © 2018 kaodim. All rights reserved.
//

import Foundation
import UIKit

var associateObjectValue: Int = 0

public extension UIView {

    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }

    func addCornerRadius(_ radius: CGFloat = 4) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }

    func addBorderLine(width: CGFloat = 1, color: UIColor) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }

    func makeRoundCorner() {
        addCornerRadius(self.frame.size.height / 2)
        self.clipsToBounds = true
    }

    func makeDashBorder(with color: CGColor = UIColor.kaoColor(.silver).cgColor) {
        let dashBorder = CAShapeLayer()
        dashBorder.strokeColor = color
        dashBorder.lineDashPattern = [2, 3]
        dashBorder.frame = bounds
        dashBorder.fillColor = nil
        dashBorder.path = UIBezierPath(roundedRect: bounds, cornerRadius: 4).cgPath
        layer.addSublayer(dashBorder)
        layer.masksToBounds = true
    }

    class func kaoTableHeaderView(_ title: String, width: CGFloat) -> UIView {
        let headerView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: 40)))
        headerView.backgroundColor = .clear

        let label = UILabel(frame: CGRect(origin: CGPoint(x: 20, y: 20), size: CGSize(width: width - 20, height: 20)))
        label.textColor = .kaoColor(.dustyGray)
        label.font = .kaoFont(style: .medium, size: .regular)
        label.text = title
        headerView.addSubview(label)
        return headerView
    }

    func dropShadow(shadowRadius radius: CGFloat? = 2.0, shadowColor: UIColor = UIColor.gray, shadowPath: CGPath? = nil, shadowOffSet: CGSize = CGSize(width: 0.0, height: 1.0), shadowOpacity: Float = 0.8) {
        layer.cornerRadius = 4
        layer.shadowOffset = shadowOffSet
        layer.shadowOpacity = shadowOpacity

        layer.shadowRadius = (radius ?? 2.0 - 1.0)
        layer.masksToBounds = false
        layer.shadowPath = shadowPath
        layer.borderColor = shadowColor.cgColor
        clipsToBounds = false
    }

    func applyGradient(_ colors: [Any]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0.5)
        self.layer.insertSublayer(gradientLayer, at: 0)
    }

    func applyGradientTopDown(_ colors: [Any]) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
        self.layer.insertSublayer(gradientLayer, at: 0)
        return gradientLayer
    }

    func applyGradientLeftRight(_ colors: [Any]) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0.5)
        self.layer.insertSublayer(gradientLayer, at: 0)
        return gradientLayer
    }

    class func nibFromDesignIos(_ fileName: String) -> UINib {
        return NibLoader.loadNib(fileName: fileName)
    }
    class func nibBundleDesignIos() -> Bundle {
        return NibLoader.loadNibBundle()
    }
}

private class NibLoader {
    class func loadNib(fileName: String) -> UINib {
        let nib: UINib!
        let podBundle = Bundle(for: NibLoader.self)
        if let bundleURL = podBundle.url(forResource: "KaoCustomPod", withExtension: "bundle"), let bundle = Bundle(url: bundleURL) {
            nib = UINib(nibName: fileName, bundle: bundle)
        } else {
            nib = UINib(nibName: fileName, bundle: Bundle.main)
        }
        return nib
    }

    class func loadNibBundle() -> Bundle {

        let podBundle = Bundle(for: NibLoader.self)
        if let bundleURL = podBundle.url(forResource: "KaoCustomPod", withExtension: "bundle"), let bundle = Bundle(url: bundleURL) {
            return bundle
        } else {
            return Bundle.main
        }

    }
}

extension UIView {
    fileprivate var isAnimate: Bool {
        get {
            return objc_getAssociatedObject(self, &associateObjectValue) as? Bool ?? false
        }
        set {
            return objc_setAssociatedObject(self, &associateObjectValue, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }

    public func startShimmerOnMainThread() {
        DispatchQueue.main.async {
            self.startShimmering()
        }
    }

    public func stopShimmerOnMainThread() {
        DispatchQueue.main.async {
            self.stopShimmering()
        }
    }

    @IBInspectable var shimmerAnimation: Bool {
        get {
            return isAnimate
        }
        set {
            self.isAnimate = newValue
        }
    }

    func subviewsRecursive() -> [UIView] {
        return subviews + subviews.flatMap { $0.subviewsRecursive() }
    }

    func getSubViewsForAnimate() -> [UIView] {
        var obj: [UIView] = []
        for objView in self.subviewsRecursive() {
            obj.append(objView)
        }
        return obj.filter({ (obj) -> Bool in
            obj.shimmerAnimation
        })
    }

    func startShimmering() {
        for animateView in getSubViewsForAnimate() {
            animateView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.8)
            animateView.clipsToBounds = true
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [UIColor.clear.cgColor, UIColor.white.withAlphaComponent(0.8).cgColor, UIColor.clear.cgColor]
            gradientLayer.startPoint = CGPoint(x: 0.7, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.8)
            gradientLayer.frame = animateView.bounds
            animateView.layer.mask = gradientLayer

            let animation = CABasicAnimation(keyPath: "transform.translation.x")
            animation.duration = 1.5
            animation.fromValue = -animateView.frame.size.width
            animation.toValue = animateView.frame.size.width
            animation.repeatCount = .infinity

            gradientLayer.add(animation, forKey: "")

            let tempView = UIView()
            tempView.tag = -1
            tempView.layer.cornerRadius = animateView.layer.cornerRadius
            tempView.backgroundColor = UIColor.kaoColor(.veryLightPink)
            tempView.frame = animateView.bounds
            tempView.center = animateView.center
            animateView.superview?.addSubview(tempView)
            animateView.superview?.sendSubviewToBack(tempView)
        }
    }

    func stopShimmering() {
        for animateView in getSubViewsForAnimate() {
            animateView.backgroundColor = .clear
            animateView.superview?.viewWithTag(-1)?.removeFromSuperview()
            animateView.layer.removeAllAnimations()
            animateView.layer.mask = nil
        }
    }
}

public extension UIView {
    func addTopBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: borderWidth)
        addSubview(border)
    }

    func addBottomBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        border.frame = CGRect(x: 0, y: frame.size.height - borderWidth, width: frame.size.width, height: borderWidth)
        addSubview(border)
    }

    func addLeftBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.frame = CGRect(x: 0, y: 0, width: borderWidth, height: frame.size.height)
        border.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
        addSubview(border)
    }

    func addRightBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
        border.frame = CGRect(x: frame.size.width - borderWidth, y: 0, width: borderWidth, height: frame.size.height)
        addSubview(border)
    }
}

public extension UIStackView {

    func removeAllArrangedSubviews() {

        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }

        // Deactivate all constraints
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))

        // Remove the views from self
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}
