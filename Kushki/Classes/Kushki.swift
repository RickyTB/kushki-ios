import Foundation

public class Kushki {
    
    private let publicMerchantId: String
    private let currency: String
    private let kushkiClient: KushkiClient

    public init(publicMerchantId: String, currency: String, environment: KushkiEnvironment, regional: Bool = false) {
        self.publicMerchantId = publicMerchantId
        self.currency = currency
        self.kushkiClient = KushkiClient(environment: environment, regional: regional)
    }
    
    public func requestToken(card: Card,
                             totalAmount: Double,
                             completion: @escaping (Transaction) -> ()) {
        let requestMessage = kushkiClient.buildParameters( withCard: card, withCurrency: self.currency, withAmount: totalAmount)
        self.kushkiClient.post(withMerchantId: self.publicMerchantId, endpoint: "/v1/tokens", requestMessage: requestMessage, withCompletion: completion)
    }
    
    public func requestSubscriptionToken(card: Card,
                                         completion: @escaping (Transaction)->()){
        let requestMessage = kushkiClient.buildParameters(withCard: card, withCurrency: self.currency)
        self.kushkiClient.post(withMerchantId: self.publicMerchantId, endpoint: "/v1/subscription-tokens", requestMessage: requestMessage, withCompletion: completion)
    }
    
    public func requestTransferToken(amount: Amount, callbackUrl:String,userType:String,documentType:String,
                                     documentNumber:String, email:String,
                                     completion: @escaping (Transaction)->()){
        let requestMessage = kushkiClient.buildParameters(withAmount: amount, withCallbackUrl: callbackUrl,
                                                          withUserType: userType,withDocumentType: documentType,
                                                          withDocumentNumber: documentNumber, withEmail: email,
                                                          withCurrency: self.currency)
        self.kushkiClient.post(withMerchantId: self.publicMerchantId, endpoint: "/transfer/v1/tokens", requestMessage: requestMessage, withCompletion: completion)
        
    }
    public func requestTransferToken(amount: Amount, callbackUrl:String,userType:String,documentType:String,
                                     documentNumber:String, email:String,paymentDescription:String,
                                     completion: @escaping (Transaction)->()){
        let requestMessage = kushkiClient.buildParameters(withAmount: amount, withCallbackUrl: callbackUrl,
                                                          withUserType: userType,withDocumentType: documentType,
                                                          withDocumentNumber: documentNumber, withEmail: email,
                                                          withCurrency: self.currency,withPaymentDescription: paymentDescription)
        self.kushkiClient.post(withMerchantId: self.publicMerchantId, endpoint: "/transfer/v1/tokens", requestMessage: requestMessage, withCompletion: completion)
        
    }
    
    public func getBankList(
        completion: @escaping ([Bank]) -> ()){
        self.kushkiClient.get(withMerchantId: self.publicMerchantId, endpoint: "/transfer-subscriptions/v1/bankList", withCompletion: completion)
    }
    
    public func requestTransferSubscriptionToken(accountType: String, accountNumber: String, documentType: String, documentNumber: String, totalAmount: Double, bankCode: String, name: String, lastname: String, cityCode: String, stateCode: String, phone: String, expeditionDate: String,cuestionaryCode: String, email: String, currency: String, completion: @escaping (Transaction)->()){
        let requestMessage = kushkiClient.buildParameters(withAccountType: accountType, withAccountNumber: accountNumber, withDocumentType: documentType, withDocumentNumber: documentNumber, withTotalAmount: totalAmount, withBankCode: bankCode, withName: name, withLastName: lastname, withCityCode: cityCode, withStateCode: stateCode, withPhone: phone, withExpeditionDate: expeditionDate, withCuestionaryCode: cuestionaryCode, withEmail: email, withCurrency: currency)
        self.kushkiClient.post(withMerchantId: self.publicMerchantId, endpoint: "/transfer-subscriptions/v1/tokens", requestMessage: requestMessage, withCompletion: completion)
    }
    
    
   
    
}
