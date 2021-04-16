//
//  QuestionView.swift
//  OpenQuizz
//
//  Created by Gorez Tony on 13/04/2021.
//

import UIKit

class QuestionView: UIView {
    @IBOutlet private var label: UILabel!
    @IBOutlet private var icon: UIImageView!
    
    /**
     *
     *  TITLE
     *
     */
    var title = "" {
        didSet {
            label.text = title
        }
    }
    
    /**
     *
     *  STYLE
     *
     */
    enum Style {
        case correct, incorrect, standard
    }
    var style: Style = .standard {
        didSet {
            self.setLabelStyle(style)
        }
    }
    
    private func setLabelStyle(_ style: Style) {
        switch style {
        case .standard:
            backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            icon.isHidden = true
        case .correct:
            backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
            icon.image = UIImage(named: "Icon Correct")
            icon.isHidden = false
        case .incorrect:
            backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
            icon.image = UIImage(named: "Icon Error")
            icon.isHidden = false
        }
    }
    
}
