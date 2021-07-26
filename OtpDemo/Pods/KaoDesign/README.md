<p align="center">
   <img src="https://github.com/kaodim/kaodimDesignIos/blob/documentation/Screenshot/kaodim-logo.png" width=400 />
</p>

----------------
## KaoDesign
#### Inspired by the Design Components 

| Design Components  |
|-----------------
|[KaoLabel](#kaolabel)
|[KaoButton](#kaobutton)
|[KaoInfoView](#kaoinfoview)
|[KaoNotificationBanner](#kaonotificationbanner)
|[ToolTips](#tool-tips)
|[KaoModalDialogView](#kaomodaldialogview)
|[KaoSpinningView](#kaospinningview)


Kaodim iOS Design Library is a library that contains most of the design components of Kaodim.

## Installation

Add the following line of code inside your **Podfile** and `pod install`.

```javascript
// top of the file
source 'https://auyotoc@bitbucket.org/kaodim/kaococoapods.git'
source 'git@github.com:kaodim/KaoCocoaPods.git'

// inside def default_pods
pod 'KaoDesign'
```

## Usage

```javascript
import KaoDesign
```

## KaoLabel
You can configure the **font**, **size** and **color** using KaoLabel.

```javascript
@IBOutlet private weak var title: KaoLabel!

title.font = .kaoFont(style: .regular, size: .small)
title.textColor = .kaoColor(.jellyBean)
```

## KaoButton
You can configure to show the standardized button based with the type of **primary(Default)**, **secondary**, **text only** or **link button**.

<p align="center">
  <img src="https://github.com/kaodim/kaodimDesignIos/blob/documentation/Screenshot/KaoButton.png">
</p>

## KaoInfoView
You can configure to show the standardized info with the type of **standard**, **only icon**, **only icon and one button** or **only icon and two buttons**.

<p align="center">
  <img src="https://github.com/kaodim/kaodimDesignIos/blob/documentation/Screenshot/KaoInfoView.png">
</p>

## KaoNotificationBanner

<p align="center">
  <img src="https://github.com/kaodim/kaodimDesignIos/blob/documentation/Screenshot/KaoNotificationBanner.png">
</p>

You can configure the message

```javascript
KaoNotificationBanner.shared.dropNotification(message: "Receipt generated and sent to customer successfully. Job moved to Request history.")
```
<p align="center">
  <img src="https://github.com/kaodim/kaodimDesignIos/blob/documentation/Screenshot/KaoNotificationBanner%20-%20Success.png">
</p>


You can configure the success message or error message.

```javascript
dropSuccessMessage("Receipt generated and sent to customer successfully. Job moved to Request history.")
```

<p align="center">
  <img src="https://github.com/kaodim/kaodimDesignIos/blob/documentation/Screenshot/KaoNotificationBanner%20-%20Error.png">
</p>

```javascript
dropErrorMessage("This is an error message")
```

## Tool Tips
You can configure the message for tool tips.

<p align="center">
  <img src="https://github.com/kaodim/kaodimDesignIos/blob/documentation/Screenshot/ToolTip.png">
</p>

## KaoModalDialogView

You can configure the **image**, **title**, **message**, **first button** or **second button**.

<p align="center">
  <img src="https://github.com/kaodim/kaodimDesignIos/blob/documentation/Screenshot/KaoModalDialogView.png">
</p>

## KaoSpinningView

<p align="center">
  <img src="https://github.com/kaodim/kaodimDesignIos/blob/documentation/Screenshot/Spinner.gif">
</p>

You can show the animation of spinner and configure the color.

```javascript
private lazy var spinner: UIView = {
  let spinningView = KaoSpinningView.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
  spinningView.tintColor = UIColor.kaoColor(.crimson, alpha: 0.5)
  spinningView.show()
  return spinningView
}()
```


## Contributing
### Bumping KaoDesign Step by Step

1. Make sure all changes is done and committed
2. Bump `s.version` under **kaoDesign.podspec** file, then commit push
3. Go to kaoDesign github repo and create release note with the same version number as the previous s.version under podspec file
4. Publish the release note
5. Execute `pod repo push kaococoapods --swift-version=4.0 --allow-warnings KaoDesign.podspec` on terminal

