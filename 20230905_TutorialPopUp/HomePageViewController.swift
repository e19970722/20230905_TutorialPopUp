//
//  ViewController.swift
//  20230905_TutorialPopUp
//
//  Created by Yen Lin on 2023/9/5.
//

import UIKit

class HomePageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 測試用
//        UserDefaults.standard.set(false, forKey: "hasSeenTutorial")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        let userDefault = UserDefaults.standard
        if (!userDefault.bool(forKey: "hasSeenTutorial")) {
            let tutorialVC = TutorialViewController()
            tutorialVC.setUserDefaultKey("hasSeenTutorial")
            tutorialVC.modalPresentationStyle = .fullScreen
            self.present(tutorialVC, animated: true)
        }
        
    }
}

