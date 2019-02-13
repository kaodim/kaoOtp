# kaoOtp


## Setting Up Podfile & Podspec:
---

Go to your .podspec and add dependency on `KaoDesign`
~~~~
  s.dependency 'KaoDesign', '0.1.33'
~~~~

Go to your Podfile and add the source
~~~~
source 'git@github.com:kaodim/KaoCocoaPods.git'
source 'https://github.com/CocoaPods/Specs.git'
~~~~

## Instalation
---
~~~~
pod 'KaoOtp'
~~~~

## Usage
---

For phone entering, inherit `PhoneEnteringViewController`. 
For phone verification, inherit `PhoneVerifyingViewController`.
~~~~
import KaoOtp

class ViewController: PhoneEnteringViewController {

    override func viewDidLoad() {
        super.phoneEnterDelegate = self
        super.phoneEnterDataSource = self
    }

}
~~~~

## PhoneEnteringViewController
---


Conform the protocol with the following function to: (in order)
- return CountryPhone
- edit Header texts
- edit Text Field label
- autofill TextField
- trigger button tapped

~~~~
    func selectedCountryPhone(in view: PhoneEnteringViewController) -> CountryPhone?

    func headerViewText(in view: PhoneEnteringViewController) -> HeaderViewParams

    func textFieldAttribute(in view: PhoneEnteringViewController) -> CustomTextfieldAttributes

    func bottomViewButtonText(in view: PhoneEnteringViewController) -> CustomButtonAttributes
    
    func textFieldValue(in view: PhoneEnteringViewController) -> CustomTextfieldAttributes

    func nextButtonTapped(in view: PhoneEnteringViewController, phoneNumber: String, countryPhone: CountryPhone)
~~~~

![](https://github.com/zhiyao92/Images/blob/master/OTP%20Images/PhoneEntering.png)

## PhoneVerifyingViewController
---

Conform the protocol with the following function to: (in order)
- edit Header texts
- edit OTP text attributes
- edit Resend OTP text and attributes
- edit the button text
- adjust the code delay time
- edit edit phone number text and attributes
- trigger verify button
- trigger resend button
- trigger change number button

~~~~

    func headerViewText(in view: PhoneVerifyingViewController) -> HeaderViewParams

    func pinTextFieldAttribute(in view: PhoneVerifyingViewController) -> CustomTextfieldAttributes

    func resendButtonAttribute(in view: PhoneVerifyingViewController) -> CustomButtonAttributes

    func bottomViewButtonText(in view: PhoneVerifyingViewController) -> CustomButtonAttributes

    func resendCodeDelay(in view: PhoneVerifyingViewController) -> Int
    
    func editNumberAttributes(in view: PhoneVerifyingViewController) -> CustomButtonAttributes

    func verifyTapped(in view: PhoneVerifyingViewController, pins: String)

    func resendCodeTapped(in view: PhoneVerifyingViewController)

    func changeNumberTapped(in view: PhoneVerifyingViewController)

~~~~
![](https://github.com/zhiyao92/Images/blob/master/OTP%20Images/PhoneVerification.png)

