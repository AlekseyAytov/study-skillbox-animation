//
//  GameViewController.swift
//  M21_Homework
//
//  Created by Alex Aytov on 6/11/23.
//

import UIKit

class GameViewController: UIViewController {
    
    var game: GameModel<FishModel>!
    
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
        label.font = label.font.withSize(50)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let backImage = UIImage(named: "ocean") ?? UIImage()
        view.backgroundColor = UIColor(patternImage: backImage)
        
        game = GameModel<FishModel>(count: 2) { [weak self] object in
            guard let self = self else { return }
            UIView.animate(withDuration: 0.8,
                           animations: {
                object.center = self.counterLabel.center
                object.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            },
                           completion: { _ in
                object.removeFromSuperview()
                self.game.updateCounter()
                self.updateCounterLabel()
            })
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        view.addGestureRecognizer(tap)
        
        setupViews()
        setupConstraints()
        updateCounterLabel()
    }
    
    func setupGameViews() {
        game.objects.forEach {
            self.view.addSubview($0)
            $0.center = $0.getRandomPoint()
            $0.transform = .identity
        }
    }
    
    
    func setupViews() {
        setupGameViews()
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
    
    @objc func startPressed() {
        if game.counter == 0 {
            game.startGame()
            UIView.animate(withDuration: 1, animations: {
                self.startButton.alpha = 0
            }) { _ in
                self.startButton.isHidden = true
            }
        } else {
            setupGameViews()
            startButton.setTitle("Start", for: .normal)
            startButton.superview?.bringSubviewToFront(startButton)
            game.counter = 0
            updateCounterLabel()
            UIView.animate(withDuration: 0.2, animations: {
                self.startButton.layoutIfNeeded()
            }) { _ in
            }
        }
    }
    
    @objc func didTap(_ gesture: UITapGestureRecognizer) {
        // получаем координаты жеста в системе координат self.view
        let tapLocation = gesture.location(in: self.view)
        
        // перебираем все subviews
        for view in self.view.subviews {
            // если сабвью это объект движения
            if let movingObject = view as? MovingObject {
                // и если координаты жеста попадают во фрейм сабвью объекта движения во время совершения жеста
                if !movingObject.isHidden,
                   movingObject.isUserInteractionEnabled,
                   (movingObject.layer.presentation()?.frame.contains(tapLocation))! {
                    // то объект движения считать пойманным
                    movingObject.isCatched = true
                    // чтобы не считать пойманными все объекты движения
                    return
                }
            }
        }
    }
    
    func updateCounterLabel() {
        counterLabel.text = String(game.counter)
        if game.counter == game.objects.count {
            startButton.alpha = 1
            startButton.isHidden = false
            startButton.setTitle("New game", for: .normal)
        }
    }
}
