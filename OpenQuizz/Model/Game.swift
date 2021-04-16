//
//  Game.swift
//  OpenQuizz
//
//  Created by Gorez Tony on 12/04/2021.
//

import Foundation

class Game {
    enum State {
        case ongoing
        case over
    }
    
    var questions = [Question]()
    var score = Int()
    var state: State = .ongoing
    var currentQuestion: Question {
        return questions[currentIndex]
    }
    
    private var currentIndex = Int()
    
    func answerCurrentQuestion(with answer:Bool) -> Int {
        let question = self.currentQuestion
        if question.isCorrect == answer {
            self.score += 1
        }
        
        goToNextQuestion()
        return self.score
    }
    
    private func makeGameOver() {
        self.state = .over
    }
    
    private func goToNextQuestion() {
        let isLastQuestion = currentIndex == questions.count - 1

        
        if isLastQuestion {
            makeGameOver()
        } else {
            currentIndex += 1
        }
    }
    
    func refresh() {
        score = 0
        currentIndex = 0
        state = .over
        
        QuestionManager.shared.get(completionHandler: self.setQuestions(_:))
    }
    
    private func setQuestions(_ questions: [Question]) {
        print(questions)
        self.questions = questions
        self.state = .ongoing
        
        let notificationName = Notification.Name(rawValue: "questions")
        let notification = Notification(name: notificationName)
        NotificationCenter.default.post(notification)
    }
}
