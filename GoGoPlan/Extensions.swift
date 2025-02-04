import UIKit

extension UIViewController {
    static func topViewController() -> UIViewController? {
        let keyWindow = UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .map { $0 as? UIWindowScene }
            .compactMap { $0 }
            .first?.windows
            .filter { $0.isKeyWindow }.first
        
        return keyWindow?.rootViewController
    }
}
