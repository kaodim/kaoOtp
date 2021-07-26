//
//  KaoSlideUpViewController.swift
//  KaoDesign
//
//  Created by Kelvin Tan on 8/19/19.
//

import UIKit

open class KaoSlideUpViewController: KaoBottomSheetController {

	public var midPresentHeight: CGFloat = UIScreen.main.bounds.height * 0.6
	public var minPresentHeight: CGFloat = UIScreen.main.bounds.height * 0.4
	public var viewAtTop: (() -> Void)?
	public var allowScrollable = false
    public var needGesture: Bool = true

	var cardPanStartingTopConstant : CGFloat = 30.0

	open override func viewDidLoad() {
		super.viewDidLoad()
		configureGesture()
	}

	open override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}

	private func configureGesture() {
        guard needGesture else { return }

		if #available(iOS 11.0, *) {
			let viewPan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
			viewPan.delaysTouchesBegan = false
			viewPan.delaysTouchesEnded = false

			super.presentView.addGestureRecognizer(viewPan)
		} else {
			let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
			swipeUp.direction = UISwipeGestureRecognizer.Direction.up
			super.presentView.addGestureRecognizer(swipeUp)

			let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
			swipeDown.direction = UISwipeGestureRecognizer.Direction.down
			super.presentView.addGestureRecognizer(swipeDown)
		}
	}

	public func hideBlurView() {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
			super.dismiss(animated: false, completion: nil)
		}
	}

	@objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
		switch gesture.direction {
		case .up:
			if allowScrollable {
				let isMid = super.presentViewHeight >= midPresentHeight
				super.presentViewHeight = isMid ? maxPresentHeight : midPresentHeight
				viewAtTop?()
			}
		case .down:
			UIView.animate(withDuration: 5.0, delay: 5.0, options: .curveEaseOut, animations: {
				super.presentViewHeight = 0
				self.hideBlurView()
			})
		default:
			break
		}
		super.startAnimation()
	}

	@available(iOS 11.0, *)
	@objc func handlePan(_ panRecognizer: UIPanGestureRecognizer) {
		let translation = panRecognizer.translation(in: self.view)
		let velocity = panRecognizer.velocity(in: self.view)

		switch panRecognizer.state {
		case .began:
			cardPanStartingTopConstant = presentViewTop.constant
		case .changed:
			if self.cardPanStartingTopConstant + translation.y > -maxPresentHeight {
				self.presentViewTop.constant = self.cardPanStartingTopConstant + translation.y
			} else if -cardPanStartingTopConstant > maxPresentHeight {
				self.presentViewTop.constant = -maxPresentHeight
			}
		case .ended:
			if velocity.y > 1500.0 {
				dismissAnimation {
					self.hideBlurView()
				}
				return
			}

			if presentViewTop.constant < -midPresentHeight {
				self.presentViewTop.constant = -maxPresentHeight
			}  else {
				dismissAnimation {
                    self.hideBlurView()
                }
			}
		default:
			break
		}
	}
}
