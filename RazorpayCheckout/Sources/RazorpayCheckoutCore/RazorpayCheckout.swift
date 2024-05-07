import Razorpay
import Foundation

enum CheckoutErrors: Error {
    case keyMissing
}

extension CheckoutErrors: CustomStringConvertible {
    
    var description: String {
        switch self {
        case .keyMissing: return "Merchant Key is mandatory"
        }
    }
}

@objc public protocol RazorpaySwiftProtocol : NSObjectProtocol {
    
}

public protocol PaymentCompletionDelegate: RazorpaySwiftProtocol {
    func onPaymentError(_ code: Int32, description str: String)
    func onPaymentSuccess(_ payment_id : String)
}

public protocol PaymentCompletionWithDataDelegate: RazorpaySwiftProtocol {
    func onPaymentError(_ code: Int32, description str: String, andData response: [AnyHashable : Any]?)
    func onPaymentSuccess(_ payment_id: String, andData response: [AnyHashable : Any]?)
}

@objc public final class MyRazorPaySample : NSObject{
    
    @objc
    public static func thisIsAbBasicFunction(){
        
    }
}

public final class RazorpaySwift {
    
    private var razorpay: RazorpayCheckout?
    private var key: String?
    private var delegate: RazorpaySwiftProtocol?
    private static let shared: RazorpaySwift = RazorpaySwift()
    
    private init() {}
    
    
    @objc
    public static func thisIsAbBasicFunction(){
        
    }
    
    public static func initWithKey(key: String, andDelegate delegate: PaymentCompletionDelegate) -> RazorpaySwift {
        RazorpaySwift.shared.key = key
        RazorpaySwift.shared.delegate = delegate
        return RazorpaySwift.shared
    }
    
    public static func initWithKey(key: String, andDelegateWithData delegate: PaymentCompletionWithDataDelegate) -> RazorpaySwift {
        RazorpaySwift.shared.key = key
        RazorpaySwift.shared.delegate = delegate
        return RazorpaySwift.shared
    }

    @objc
    public func open(withPayload payload: [AnyHashable: Any]) throws {
        guard let key = self.key else {
            throw CheckoutErrors.keyMissing
        }
        if self.razorpay == nil {
            self.razorpay = RazorpayCheckout.initWithKey(key, andDelegate: self)
        }
        
        self.razorpay?.open(payload)
    }
}

extension RazorpaySwift: RazorpayPaymentCompletionProtocol {
    public func onPaymentError(_ code: Int32, description str: String) {
        (self.delegate as? PaymentCompletionDelegate)?.onPaymentError(code, description: str)
    }
    
    public func onPaymentSuccess(_ payment_id: String) {
        (self.delegate as? PaymentCompletionDelegate)?.onPaymentSuccess(payment_id)
    }
}

extension RazorpaySwift: RazorpayPaymentCompletionProtocolWithData {
    public func onPaymentError(_ code: Int32, description str: String, andData response: [AnyHashable : Any]?) {
        (self.delegate as? PaymentCompletionWithDataDelegate)?.onPaymentError(code, description: str, andData: response)
    }
    
    public func onPaymentSuccess(_ payment_id: String, andData response: [AnyHashable : Any]?) {
        (self.delegate as? PaymentCompletionWithDataDelegate)?.onPaymentSuccess(payment_id, andData: response)
    }
}

@objc class RazorpayBridge: NSObject {
  var razorpay: RazorpayCheckout!
  
  static let shared = RazorpayBridge()
  
  private override init() {
    super.init()
    razorpay = RazorpayCheckout.initWithKey("YOUR_API_KEY", andDelegate: self)
  }
  
  @objc func startPayment() {
    let options: [String: Any] = [
      "amount": "1000", // Specify the amount here
      "currency": "INR",
      "description": "Test payment",
      // Add additional options as needed
    ]
    razorpay.open(options)
  }
}

extension RazorpayBridge: RazorpayPaymentCompletionProtocol {
  func onPaymentError(_ code: Int32, description str: String) {
    print("Error: \(code) | \(str)")
  }
  
  func onPaymentSuccess(_ payment_id: String) {
    print("Success: \(payment_id)")
  }
}
