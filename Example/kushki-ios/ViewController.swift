import UIKit
import Kushki

class ViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: Properties
    @IBOutlet weak var doItHttpButton: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var numberField: UITextField!
    @IBOutlet weak var monthField: UITextField!
    @IBOutlet weak var yearField: UITextField!
    @IBOutlet weak var cvvField: UITextField!
    @IBOutlet weak var userTypeField: UISegmentedControl!
    @IBOutlet weak var documentTypePicker: UIPickerView!
    @IBOutlet weak var documentNumberField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var getSubscriptionTransferButton: UIButton!
    @IBOutlet weak var Name: UITextField!
    @IBOutlet weak var IdentificationDocument: UITextField!
    @IBOutlet weak var docTypePicker: UIPickerView!
    @IBOutlet weak var bankPicker: UIPickerView!
    @IBOutlet weak var Email: UITextField!
    let pickerData = [ "CC" , "NIT" , "CE" , "TI" , "PP" , "RUT"]
    var banks: [Bank] = []
    let publicTransferMerchantId: String? = "20000000100323955000"
    var kushkiTransfer : Kushki?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        documentTypePicker.delegate = self
        documentTypePicker.dataSource = self
        bankPicker.delegate = self
        bankPicker.dataSource = self
         kushkiTransfer  = Kushki(publicMerchantId: self.publicTransferMerchantId!,
                     currency: "CLP",
                     environment: KushkiEnvironment.testing)
        kushkiTransfer!.getBankList(){
            returnedBankList in
            self.banks = returnedBankList
            
        }
        self.bankPicker.reloadAllComponents()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    // MARK: Actions
    @IBAction func handleTouchUpInside(_ sender: UIButton) {
        let card = Card(name: nameField.text!,
                        number: numberField.text!,
                        cvv: cvvField.text!,
                        expiryMonth: monthField.text!,
                        expiryYear: yearField.text!)
        let amount = Amount(subtotalIva: 12.2, subtotalIva0: 0.0, iva: 1.2)
        
        if(sender.titleLabel?.text == "Request Subscription"){
            requestKushkiToken(card: card, subscription: true)
            return
        }
        if(sender.titleLabel?.text == "Request Transfer"){
            requestKushkiToken(amount: amount, callbackUrl: "www.test.com", userType: mapUserType(userType: userTypeField.titleForSegment(at: userTypeField.selectedSegmentIndex)!), documentType: pickerData[documentTypePicker.selectedRow(inComponent: 0)], documentNumber: documentNumberField.text!, reference: documentNumberField.text!, email: emailField.text!, description: descriptionField.text!)
            return
        }
        if(sender.titleLabel?.text == "Request Subscription Transfer Token"){
            requestSubscriptionTransferToken(name: Name.text!, documentType: pickerData[docTypePicker.selectedRow(inComponent: 0)], documentNumber: IdentificationDocument.text!, email: Email.text!)
            
            return
        }
        requestKushkiToken(card: card)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == documentTypePicker{
            return pickerData.count
        }
        else if(pickerView == bankPicker){
            return banks.count
        }
        else{
            return 0
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == documentTypePicker{
            return pickerData[row]
        }
        else if(pickerView == bankPicker){
            return banks[row].name
        }
        else{
            return ""
        }
    }
    
    func mapUserType(userType:String) -> String {
        if(userType == "Natural")
            {return "0"}
        else
            {return "1"}
    }
  

    private func requestKushkiToken(card: Card, subscription: Bool = false) {
        let publicMerchantId = "10000001641125237535111218"
        let kushki = Kushki(publicMerchantId: publicMerchantId,
                            currency: "USD",
                            environment: KushkiEnvironment.testing)
        if(subscription){
            kushki.requestSubscriptionToken(card: card) { transaction in
                let message = transaction.isSuccessful() ?
                    transaction.token : transaction.code + ": " + transaction.message
//                    transaction.code + ": " + transaction.message
                DispatchQueue.main.async(execute: {
                    let alert = UIAlertController(title: "Kushki Token",
                                                  message: message,
                                                  preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default))
                    self.present(alert, animated: true)
                })
            }
            return
        }
        kushki.requestToken(card: card, totalAmount: 19.99) { transaction in
            let message = transaction.isSuccessful() ?
                transaction.token : transaction.code + ": " + transaction.message
//                transaction.code + ": " + transaction.message
            DispatchQueue.main.async(execute: {
                let alert = UIAlertController(title: "Kushki Token",
                                              message: message,
                                              preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(alert, animated: true)
            })
        }
    }
    private func requestKushkiToken(amount: Amount, callbackUrl:String, userType:String, documentType:String,                                   documentNumber:String, reference:String, email:String,description:String) {
        let publicMerchantId = "10000001641125237535111218"
        let kushki = Kushki(publicMerchantId: publicMerchantId,
                            currency: "CLP",
                            environment: KushkiEnvironment.testing)
    
        kushki.requestTransferToken(amount: amount, callbackUrl: callbackUrl, userType: userType, documentType: documentType, documentNumber: documentNumber, email: email,paymentDescription: description) { transaction in
            let message = transaction.isSuccessful() ?
                transaction.token : transaction.code + ": " + transaction.message
            //                transaction.code + ": " + transaction.message
            DispatchQueue.main.async(execute: {
                let alert = UIAlertController(title: "Kushki Token",
                                              message: message,
                                              preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(alert, animated: true)
            })
        }
    }
    
    private func requestSubscriptionTransferToken(name: String, documentType: String, documentNumber: String, email: String) {
        
        kushkiTransfer!.requestTransferSubscriptionToken(accountType: "01", accountNumber: "121212121212", documentType: documentType, documentNumber: documentNumber, totalAmount: 10.0, bankCode: "01", name: name,  lastname: "test Last Name", cityCode: "17", stateCode: "01", phone: "123456789", expeditionDate: "12/01/1996", cuestionaryCode: "1", email: email, currency: "USD") { transaction in
            let message = transaction.isSuccessful() ?
                transaction.token : transaction.code + ": " + transaction.message
            //                transaction.code + ": " + transaction.message
            DispatchQueue.main.async(execute: {
                let alert = UIAlertController(title: "Kushki Transfer Subscription",
                                              message: message,
                                              preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(alert, animated: true)
            })
        }
    }
}
