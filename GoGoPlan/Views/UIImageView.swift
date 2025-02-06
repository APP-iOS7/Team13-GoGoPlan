//
//  UIImageView.swift
//  GoGoPlan
//
//  Created by Seonghoon Lee on 2/6/25.
//

import SwiftUI
import UIKit
class ViewController: UIViewController {
    
    let logoImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 로고 이미지 설정
        logoImageView.image = UIImage(named: "your_logo_image")
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.frame = CGRect(x: (view.frame.width - 100) / 2, y: (view.frame.height - 100) / 2, width: 100, height: 100)
        
        // contentView에 로고 추가
        if let contentView = self.view {
            contentView.addSubview(logoImageView)
        }
        
        // 애니메이션 시작
        startBurningAnimation()
    }
    
    func startBurningAnimation() {
        // 불타는 효과를 위한 애니메이션
        let burnAnimation = CAKeyframeAnimation(keyPath: "opacity")
        burnAnimation.values = [1.0, 0.5, 0.0]
        burnAnimation.keyTimes = [0.0, 0.5, 1.0]
        burnAnimation.duration = 1.0
        
        // 크기 줄어드는 애니메이션
        UIView.animate(withDuration: 1.0, animations: {
            self.logoImageView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }) { _ in
            // 애니메이션 완료 후 로고 제거
            self.logoImageView.layer.removeAllAnimations()
            self.logoImageView.removeFromSuperview()
        }
        
        // 애니메이션 추가
        logoImageView.layer.add(burnAnimation, forKey: "burnAnimation")
    }
}

#Preview {
    UIImageView()
}
