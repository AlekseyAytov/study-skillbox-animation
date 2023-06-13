//
//  GameModel.swift
//  M21_Homework
//
//  Created by Alex Aytov on 6/11/23.
//

import UIKit

class GameModel<ObjectClass> where ObjectClass: UIImageView, ObjectClass: MovingObject {
    
    var objects: [ObjectClass] = []
    
    var counter: Int = 0
    
    init(count: Int, catchCompletionHandler: ((UIImageView) -> Void)?) {
        for _ in 1...count {
            let object = ObjectClass()
            object.catchCompletionHandler = catchCompletionHandler
            objects.append(object)
        }
    }
    
    func startGame() {
        counter = 0
        objects.forEach {
            $0.isCatched = false
            $0.startMoving()
        }
    }
    
    func updateCounter() {
        counter += 1
    }
}
