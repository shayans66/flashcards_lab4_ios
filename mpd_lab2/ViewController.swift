//
//  ViewController.swift
//  mpd_lab2
//
//  Created by Shayan Sarnevesht on 3/12/21.
//

import UIKit


struct Flashcard {
    var question: String
    var answer: String
}

class ViewController: UIViewController {

    @IBOutlet weak var backLabel: UILabel!
    
    @IBOutlet weak var frontLabel: UILabel!
    
    var flashcards = [Flashcard]()
    // current flashcard index
    var currentIndex = 0
    
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBAction func didTapOnPrev(_ sender: Any) {
        
        // update cur index
        currentIndex -= 1
        // update labels
        updateLabels()
        // update buttons
        updateNextPrevButtons()
        
        frontLabel.isHidden = false
    }
    @IBAction func didTapOnNext(_ sender: Any) {
        // update cur index
        currentIndex += 1
        // update labels
        updateLabels()
        // update buttons
        updateNextPrevButtons()
        
        frontLabel.isHidden = false
    }
    
    func updateLabels(){
        let currentFlashcard = flashcards[currentIndex]
        
        frontLabel.text = currentFlashcard.question
        backLabel.text = currentFlashcard.answer
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // read saved flashcards
        readSavedFlashcards()
        
        if (flashcards.count == 0) {
            // Do any additional setup after loading the view.
            updateFlashcard(question: "What's the capital of Russia?", answer: "St. Petersburg")
        } else{
            updateLabels()
            updateNextPrevButtons()
        }
        
    }
    func readSavedFlashcards(){
        // read dict array from disk if any
        if let dictionaryArray = UserDefaults.standard.array(forKey: "flashcards") as? [[String: String]] {
            let savedCards = dictionaryArray.map { dictionary -> Flashcard in
                return Flashcard(question: dictionary["question"]!, answer: dictionary["answer"]!)
            }
            // put them in flashcards array
            flashcards.append(contentsOf: savedCards)
        }
        
        
    }

    
    @IBAction func tappedOnFlashcard(_ sender: Any) {
        frontLabel.isHidden = true
    }
    
    
    func updateNextPrevButtons(){
        // disable next button if at end
        if( currentIndex == flashcards.count - 1 ){
            nextButton.isEnabled = false
        }else{
            nextButton.isEnabled = true
        }
        
        // disable prev button if at beginning
        if( currentIndex == 0 ){
            prevButton.isEnabled = false
        }else{
            prevButton.isEnabled = true
        }
    }
    
    func updateFlashcard(question: String, answer: String) {
        
        let flashcard = Flashcard(question: question, answer: answer)
        
        frontLabel.text = flashcard.question
        backLabel.text = flashcard.answer
        
        flashcards.append(flashcard)
        currentIndex = flashcards.count - 1
        
        print(":DD added new flashcard")
        print("We now have \(currentIndex+1) flashcards")
        
        // update button functionality
        updateNextPrevButtons()
        
        // update labels
        updateLabels()
        
        frontLabel.isHidden = false
        
        saveAllFlashcardsToDisk()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        let navigationController = segue.destination as! UINavigationController
        let creationController = navigationController.topViewController as! CreationViewController
        
        creationController.flashcardsController = self
        
    }
    
    func saveAllFlashcardsToDisk() {
        
        
        // map flashcard array to dictionary array
        let dictionaryArray = flashcards.map { (card) -> [String: String] in
            return ["question": card.question, "answer": card.answer]
        }
        // store on disk
        UserDefaults.standard.set(dictionaryArray, forKey: "flashcards")
        // log it
        print("flashcards saved to user defaults")
    }
    
}

