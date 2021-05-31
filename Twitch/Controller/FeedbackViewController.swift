//
//  FeedbackViewController.swift
//  Twitch
//
//  Created by Lubov on 23.05.2021.
//

import UIKit
import RateBar

class FeedbackViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var feedbackText: UITextView!
    @IBOutlet weak var rateView: RatingBar!
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendButton.layer.cornerRadius = 4        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        feedbackText.resignFirstResponder()
    }
}
