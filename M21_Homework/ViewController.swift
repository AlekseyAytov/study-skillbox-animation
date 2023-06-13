//
//  ViewController.swift
//  M21_Homework
//
//  Created by Maxim Nikolaev on 15.02.2022.
//

import UIKit
import SnapKit

final class ViewController: UIViewController {

    lazy var fish: UIImageView = {
        let image = UIImage(named: "fish")
        let view = UIImageView(image: image)
        view.frame = CGRect( x: 0, y: 0, width: 200, height: 200)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var startButton: UIButton = {
        let button = UIButton()
        button.setTitle("Start", for: .normal)
        button.setTitleColor(UIColor(red: 0.31, green: 0.44, blue: 0.61, alpha: 1.00), for: .normal)
        button.setTitleColor(UIColor(red: 0.69, green: 0.83, blue: 0.89, alpha: 1.00), for: .highlighted)
        button.backgroundColor = UIColor(red: 1.00, green: 0.65, blue: 0.35, alpha: 1.00)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(startPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var counterLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = String(counter)
        label.font = label.font.withSize(50)
        return label
    }()
             
    var isFishCatched = false
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        view.addGestureRecognizer(tap)
        
        let backImage = UIImage(named: "ocean") ?? UIImage()
        print(backImage)
        view.backgroundColor = UIColor(patternImage: backImage)
    }
    
    func setupViews() {
        view.addSubview(fish)
        view.addSubview(startButton)
        view.addSubview(counterLabel)
    }
    
    func setupConstraints() {
        startButton.snp.makeConstraints { make in
            make.height.equalTo(35)
            make.width.equalTo(120)
            make.center.equalToSuperview()
        }
        
        counterLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(30)
            make.trailing.equalToSuperview().inset(50)
        }
    }
    
    func updateCounter() {
        counter += 1
        counterLabel.text = String(counter)
    }
    
    func resetCounter() {
        counter = 0
        counterLabel.text = "0"
    }
    
    @objc func startPressed() {
        moveLeft()
        UIView.animate(withDuration: 1, animations: {
            self.startButton.alpha = 0
        }) { _ in
            self.startButton.isHidden = true
        }
    }
    
    func moveLeft() {
      if isFishCatched { return }
      
      UIView.animate(withDuration: 1.0,
                     delay: 0,
                     options: [.curveEaseInOut , .allowUserInteraction],
                     animations: {
          self.fish.center = CGPoint(x: 150, y: 300)
          self.fish.transform = .identity
      },
                     completion: { finished in
                      print("fish moved left!")
                      self.moveRight()
      })
    }
    
    
    func moveRight() {
        if isFishCatched { return }
        
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       options: [.curveEaseInOut , .allowUserInteraction],
                       animations: {
            self.fish.center = CGPoint(x: 50, y: 500)
        },
                       completion: { finished in
                        print("fish moved right!")
                        self.moveTop()
        })
    }
    
    func moveTop() {
        if isFishCatched { return }
        
        fish.transform = CGAffineTransform(scaleX: -1, y: 1)
        
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       options: [.curveEaseInOut , .allowUserInteraction],
                       animations: {
            self.fish.center = CGPoint(x: 300, y: 800)
        },
                       completion: { finished in
                        print("fish moved Top!")
                        self.moveBottom()
        })
    }
    
    func moveBottom() {
        if isFishCatched { return }
        
        fish.transform = .identity
        
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       options: [.curveEaseInOut , .allowUserInteraction],
                       animations: {
            self.fish.center = CGPoint(x: 10, y: 200)
            self.fish.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        },
                       completion: { finished in
                        print("fish moved Bottom!")
                        self.moveLeft()
        })
    }
    
    @objc func didTap(_ gesture: UITapGestureRecognizer) {
        let tapLocation = gesture.location(in: fish.superview)
        if (fish.layer.presentation()?.frame.contains(tapLocation))! {
            print("fish tapped!")
            if isFishCatched { return }
            isFishCatched = true
            fishCatchedAnimation()
        }
    }
    
    func fishCatchedAnimation() {
        UIView.animate(withDuration: 0.8,
                       animations: {
            self.fish.center = self.counterLabel.center
            self.fish.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        },
                       completion: { _ in
            self.fish.removeFromSuperview()
            self.updateCounter()
        })
    }
}

