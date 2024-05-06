import Foundation
import Razorpay

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
