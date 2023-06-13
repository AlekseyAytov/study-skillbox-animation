//
//  FishModel.swift
//  M21_Homework
//
//  Created by Alex Aytov on 6/11/23.
//

import UIKit

protocol MovingObject: UIImageView {
    var isCatched: Bool {get set}
    var catchCompletionHandler: ((UIImageView) -> Void)? {get set}
    func startMoving()
}

class FishModel: UIImageView, MovingObject {
    
    init() {
        let image = UIImage(named: "fish")
        super.init(image: image)
        self.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        self.contentMode = .scaleAspectFit
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isCatched: Bool = false {
        willSet {
            if newValue {
                self.isUserInteractionEnabled = false
                catchCompletionHandler?(self)
            } else {
                self.isUserInteractionEnabled = true
            }
        }
    }
    
    var catchCompletionHandler: ((UIImageView) -> Void)?
    
    func startMoving() {
        move()
    }
    
    func getRandomPoint() -> CGPoint {
        let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
        let windowSize = sceneDelegate.window?.windowScene?.screen.bounds
        
        let marginX = self.frame.width/2
        let marginY = self.frame.height/2
        let newX = Double.random(in: marginX...(windowSize!.maxX - marginX))
        let newY = Double.random(in: marginY...(windowSize!.maxY - marginY))
        return CGPoint(x: newX, y: newY)
    }
    
    // MARK: - Moving methods
    
    private func move() {
        if isCatched { return }
        let newPoint = getRandomPoint()
        if newPoint.x > self.center.x {
            self.transform = CGAffineTransform(scaleX: -1, y: 1)
        } else {
            self.transform = .identity
        }
        
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       options: [.allowUserInteraction],
                       animations: {
            self.center = newPoint
        },
                       completion: { _ in
            self.move()
        })
    }
}

