# kao-ios-otp


## Example Use case for phone enter view :
---

~~~~
class ViewController: PhoneEnteringViewController {

    var list : [CountryPhone] = []

    override func viewDidLoad() {
        configureList()
        super.phoneEnterDataSource = self
        super.phoneEnterDelegate = self
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func configureList() {
        for index in 0...2 {
            let countryPhone = CountryPhone(icon: UIImage(named: "flag_my")!, phoneExtension: "(+6\(index))")
            list.append(countryPhone)
        }
    }

    private func presentSecondView() {
        let view = SecondViewController()
        navigationController?.pushViewController(view, animated: true)
    }
}

extension ViewController: PhoneEnterDelegate, PhoneEnterDataSource {

    func nextButtonTapped(in view: PhoneEnteringViewController, phoneNumber: String, countryPhone: CountryPhone) {
        print(countryPhone.phoneExtension + " " + phoneNumber)
        print("next please....")
        presentSecondView()
    }

    func supportedCountryPhones(in view: PhoneEnteringViewController) -> [CountryPhone] {
        return list
    }

    func selectedCountryPhone(in view: PhoneEnteringViewController) -> CountryPhone? {
        return list.first
    }

    func headerViewText(in view: PhoneEnteringViewController) -> HeaderViewParams {
        let titleAttr = CustomLabelAttributes(font: .boldSystemFont(ofSize: 20), color: .red)
        return HeaderViewParams(title: "Verify your phone number", titleAttr: titleAttr, message: "This is as part of our effort to provide a safe and secure service, we will send you a 6-digit code for verification.", messageAttr: CustomLabelAttributes(), phoneNumberText: "", phoneNumberTextAttr: CustomLabelAttributes(), updateNumberText: "", updateNumberTextAttr: CustomLabelAttributes())
    }

    func textFieldAttribute(in view: PhoneEnteringViewController) -> TextfieldViewParams {
        let phoneExtensionAttr = CustomLabelAttributes(font: .boldSystemFont(ofSize: 14), color: .red)
        let textfieldAttr = CustomTextfieldAttributes(font: .boldSystemFont(ofSize: 14), color: .blue, placeholder: "Enter phone number", lineColor: .clear, disableLineColor: .clear)
        return TextfieldViewParams(text: nil, phoneExtensionAttr: phoneExtensionAttr, phoneTextfieldAttr: textfieldAttr)
    }

    func bottomViewButtonText(in view: PhoneEnteringViewController) -> CustomButtonAttributes {
        let customFont: UIFont = .boldSystemFont(ofSize: 14)
        return CustomButtonAttributes(text: "NEXT", font: customFont, color: .red, disableColor: .gray, disableText: "NOPE")
    }

    func dropDownUpImages(in view: PhoneEnteringViewController) -> CustomDropUpDownImage {
        return CustomDropUpDownImage(dropUp: UIImage(named: "up"), dropDown: UIImage(named: "down"))
    }
}
~~~~
---

## Example Use case for phone verifying view :
---
~~~~
class SecondViewController: PhoneVerifyingViewController {

    override func viewDidLoad() {
        super.phoneVerifyDelegate = self
        super.phoneVerifyDataSource = self
        super.viewDidLoad()
        view.backgroundColor = .white
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        super.startResendTimer()
    }
}

extension SecondViewController: PhoneVerifyDataSource, PhoneVerifyDelegate {

    func headerViewText(in view: PhoneVerifyingViewController) -> HeaderViewParams {
        let titleAttr = CustomLabelAttributes(font: .boldSystemFont(ofSize: 20), color: .red)
        let phoneAttr = CustomLabelAttributes(font: .systemFont(ofSize: 14), color: .brown)
        let updateAttr = CustomLabelAttributes(font: .systemFont(ofSize: 14), color: .blue)
        return HeaderViewParams(title: "Verify your phone number", titleAttr: titleAttr, message: "Enter the 6-digit code sent to you at", messageAttr: CustomLabelAttributes(), phoneNumberText: "+601938301133", phoneNumberTextAttr: phoneAttr, updateNumberText: "Change you number", updateNumberTextAttr: updateAttr)
    }

    func pinTextFieldAttribute(in view: PhoneVerifyingViewController) -> CustomTextfieldAttributes {
        return CustomTextfieldAttributes(font: .boldSystemFont(ofSize: 14), color: .blue, placeholder: "", lineColor: .blue, disableLineColor: .brown)
    }

    func resendButtonAttribute(in view: PhoneVerifyingViewController) -> CustomButtonAttributes {
        let customFont: UIFont = .boldSystemFont(ofSize: 14)
        return CustomButtonAttributes(text: "Resend code", font: customFont, color: .blue, disableColor: .lightGray, disableText: "Resend code in")
    }

    func bottomViewButtonText(in view: PhoneVerifyingViewController) -> CustomButtonAttributes {
        let customFont: UIFont = .boldSystemFont(ofSize: 14)
        return CustomButtonAttributes(text: "Verify number", font: customFont, color: .red, disableColor: .gray, disableText: "Verified?")
    }

    func resendCodeDelay(in view: PhoneVerifyingViewController) -> Int {
        return 15
    }

    func verifyTapped(in view: PhoneVerifyingViewController, pins: String) {
        print("pins : \(pins)")
    }

    func resendCodeTapped(in view: PhoneVerifyingViewController) {
        print("resendCodeTapped")
    }

    func changeNumberTapped(in view: PhoneVerifyingViewController) {
        print("changeNumberTapped")
    }
}

~~~~
---
## Instalation
---
~~~~
pod 'KaoDesignIos'
~~~~
---

## Notes : Don't forget to specify code below to your podfile (since it's a private library) 
---
~~~~
source 'https://auyotoc@bitbucket.org/kaodim/kaococoapods.git'
source 'https://github.com/CocoaPods/Specs.git'
~~~~

