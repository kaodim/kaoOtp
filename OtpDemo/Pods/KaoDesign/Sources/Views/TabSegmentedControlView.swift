//
//  TabSegmentedControl.swift
//  Kaodim
//
//  Created by sadman samee on 4/14/20.
//  Copyright © 2020 Kaodim Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

public class TabSegmentedControlView: UIView {

   public var tabSegmentedControlChanged: ((_ index: Int) -> Void)?

    private let segmentControl: UISegmentedControl = {
        let control = UISegmentedControl()

        let whiteImage = UIColor.white.image()
        control.setBackgroundImage(whiteImage, for: .normal, barMetrics: .default)
        control.setBackgroundImage(whiteImage, for: .selected, barMetrics: .default)
        control.setDividerImage(whiteImage, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        control.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .medium),
            NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.423489809, green: 0.4235547483, blue: 0.4234755933, alpha: 1)
            ], for: .normal)
        control.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .medium),
            NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.877774775, green: 0.1001265123, blue: 0.2252686918, alpha: 1),
            NSAttributedString.Key.backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            ], for: .selected)
        control.translatesAutoresizingMaskIntoConstraints = false
        control.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        control.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        if #available(iOS 13.0, *) {
            control.selectedSegmentTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        return control
    }()

    private let bottomBar: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8819062114, green: 0.1067187563, blue: 0.2246125638, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var segmentItems: [String] = ["title", "title"] {
        didSet {
            guard !segmentItems.isEmpty else { return }
            setupSegmentItems()
            bottomBarWidthAnchor?.isActive = false
            bottomBarWidthAnchor = bottomBar.widthAnchor.constraint(equalTo: segmentControl.widthAnchor, multiplier: 1 / CGFloat(segmentItems.count))
            bottomBarWidthAnchor?.isActive = true

        }
    }

    var bottomBarWidthAnchor: NSLayoutConstraint?

   public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

   public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        addSubview(segmentControl)
        addSubview(bottomBar)

        segmentControl.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        segmentControl.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        segmentControl.topAnchor.constraint(equalTo: topAnchor).isActive = true
        segmentControl.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        segmentControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)

        bottomBar.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bottomBar.heightAnchor.constraint(equalToConstant: 3).isActive = true
        bottomBar.leftAnchor.constraint(equalTo: segmentControl.leftAnchor).isActive = true
        bottomBarWidthAnchor = bottomBar.widthAnchor.constraint(equalTo: segmentControl.widthAnchor, multiplier: 1 / CGFloat(segmentItems.count))
        bottomBarWidthAnchor?.isActive = true

        setupSegmentItems()

    }
    public func setupSegmentItems() {
        for (index, value) in segmentItems.enumerated() {
            segmentControl.insertSegment(withTitle: value, at: index, animated: true)
        }
        segmentControl.selectedSegmentIndex = 0
    }

    private func onSegmentedChanged() {
        tabSegmentedControlChanged?(self.segmentControl.selectedSegmentIndex)
        UIView.animate(withDuration: 0.3) {
            let originX = (self.segmentControl.frame.width / CGFloat(self.segmentItems.count)) * CGFloat(self.segmentControl.selectedSegmentIndex)

            self.bottomBar.frame.origin.x = originX
        }
    }

    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        onSegmentedChanged()
    }

   public func setSelectedSegmentIndex(index: Int) {
        if(segmentControl.selectedSegmentIndex != index) {
            segmentControl.selectedSegmentIndex = index
            onSegmentedChanged()
        }
    }

   public func setSegmentItems (titles: [String]) {
        segmentControl.removeAllSegments()
        self.segmentItems = titles
    }
}

