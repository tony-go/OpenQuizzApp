//
//  ViewController.swift
//  OpenQuizz
//
//  Created by Gorez Tony on 12/04/2021.
//

import UIKit

let LOADING_MESSAGE = "Loading ..."
let DEFAULT_SCORE = "0 / 10"

class ViewController: UIViewController {
    @IBOutlet weak var questionView: QuestionView!
    
    @IBOutlet weak var newGameButton: UIButton!
    
    @IBOutlet weak var labelScore: UILabel!
    
    @IBOutlet weak var isLoading: UIActivityIndicatorView!
    
    var game = Game()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        handleQuestionLoaded()
        
        startNewGame()
        
        addGestureRecognizer()
    }
    
    private func handleQuestionLoaded() {
        let notificationName = Notification.Name(rawValue: "questions")
        NotificationCenter.default.addObserver(self, selector: #selector(questionLoaded), name: notificationName, object: nil)
    }
 
    @objc func questionLoaded() {
        isLoading.isHidden = true
        newGameButton.isHidden = false
        labelScore.isHidden = false
        
        questionView.title = game.currentQuestion.title
    }
    
    private func addGestureRecognizer() {
        let panGestureReconzier = UIPanGestureRecognizer(target: self, action: #selector(dragQuestionView(_:)))
        questionView.addGestureRecognizer(panGestureReconzier)
    }
    
    @IBAction func didTapeNewGameButton() {
        startNewGame()
    }
    
    private func startNewGame() {
        isLoading.isHidden = false
        newGameButton.isHidden = true
        labelScore.isHidden = true
        labelScore.text = DEFAULT_SCORE
        
        questionView.title = LOADING_MESSAGE
        questionView.style = .standard
        
        game.refresh()
    }
    
    @objc func dragQuestionView(_ sender: UIPanGestureRecognizer) {
        if game.state == .ongoing {
            switch sender.state {
            case .began, .changed:
                transformQuestionView(with: sender)
            case .cancelled, .ended:
                answerQuestion()
            default:
                break
            }
        }
    }
    
    private func transformQuestionView(with sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: questionView)
        let translationTransform = CGAffineTransform(translationX: translation.x, y: translation.y)
        
        let rotationAngle = getRotationAngle(translationX: translation.x)
        let rotationTransform = CGAffineTransform(rotationAngle: rotationAngle)
        
        let transform = translationTransform.concatenating(rotationTransform)
        questionView.transform = transform
        
        updateQuestionStyle(translation: translation)
    }
    
    private func getRotationAngle(translationX: CGFloat) -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let halfScreenWidth = screenWidth / 2
        let translationPercent = translationX / halfScreenWidth
        let rotationAngle = (CGFloat.pi / 6) + translationPercent
        
        return rotationAngle
    }
    
    private func updateQuestionStyle(translation: CGPoint) {
        if translation.x > 0 {
            questionView.style = .correct
        } else {
            questionView.style = .incorrect
        }
    }
    
    private func answerQuestion() {
        var newScore = Int()
        
        switch questionView.style {
        case .correct:
            newScore = game.answerCurrentQuestion(with: true)
        case .incorrect:
            newScore = game.answerCurrentQuestion(with: false)
        case .standard:
            newScore = game.score
            break
        }
        
        labelScore.text = "\(newScore) / 10"
        
        let screenWidth = UIScreen.main.bounds.width
        var translationTransform: CGAffineTransform
        if questionView.style == .correct {
            translationTransform = CGAffineTransform(translationX: screenWidth, y: 0)
        } else {
            translationTransform = CGAffineTransform(translationX: -screenWidth, y: 0)
        }
        
        UIView.animate(
            withDuration: 0.3,
            animations: {
                self.questionView.transform = translationTransform
            },
            completion: {(success) in
                if success {
                    self.showNewQuestion(newScore)
                }
            })
    }
    
    private func showNewQuestion(_ newScore: Int) {
        questionView.transform = .identity
        questionView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        questionView.style = .standard
        
        
        switch game.state {
        case .ongoing:
            questionView.title = game.currentQuestion.title
        case .over:
            questionView.title =
                newScore == 10
                    ? "You win !"
                    : "Game over"
        }
        
        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.5,
            options: [],
            animations: {
                self.questionView.transform = .identity
            },
            completion: nil
        )

    }
 }

