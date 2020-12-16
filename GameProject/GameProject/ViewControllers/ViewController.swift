//
//  ViewController.swift
//  GameProject
//
//  Created by Pavel Shyker on 9/28/20.
//  Copyright © 2020 Pavel Shyker. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {

    var startMenuThemePlayer: AVAudioPlayer?
    var isSoundNeeded = true
    var isSoundShouldBeRestarted = false
    @IBOutlet weak var titleTextLabel: UILabel!
    
    @IBOutlet weak var startScreenImage: UIImageView!
    
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var recordsButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let text = "Car is on Fire!"
        let attributedText = NSMutableAttributedString(string: text)
        let wholeRange = (text as NSString).range(of: text)
        attributedText.addAttribute(.font, value: UIFont.edgeRacer(ofSize: 40), range: wholeRange)
        titleTextLabel.attributedText = attributedText
      
        let backButton = UIBarButtonItem()
        backButton.title = "Back to menu"
        navigationItem.backBarButtonItem = backButton
        
    
        self.playStartMenuTheme()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)

        isSoundNeeded = UserDefaults.standard.value(forKey: "soundOption") as? Bool ?? true
        isSoundShouldBeRestarted = UserDefaults.standard.value(forKey: "isSoundShouldBeRestarted") as? Bool ?? false
        
        if isSoundNeeded == false {
            startMenuThemePlayer?.stop()
        }
        else if isSoundShouldBeRestarted == true && isSoundNeeded == true {
            playStartMenuTheme()
        }
        
        isSoundShouldBeRestarted = false
        UserDefaults.standard.setValue(isSoundShouldBeRestarted, forKey: "isSoundShouldBeRestarted")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //navigationController?.setNavigationBarHidden(false, animated: animated)
        
        newGameButton.setCornerRadius(radius: newGameButton.frame.height/2)
        newGameButton.setShadow(opacity: 0.7, radius: 5)
        
        recordsButton.setCornerRadius(radius: recordsButton.frame.height/2)
        recordsButton.setShadow(opacity: 0.7, radius: 5)
        
        settingsButton.setCornerRadius(radius: settingsButton.frame.height/2)
        settingsButton.setShadow(opacity: 0.7, radius: 5)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    func playStartMenuTheme() {
        if isSoundNeeded == true {
        if let carStartMenuThemePath = Bundle.main.path(forResource: "carStartMenuTheme", ofType: "mp3") {
        let carStartMenuThemeURL = URL(fileURLWithPath: carStartMenuThemePath)
        do {
            startMenuThemePlayer = try AVAudioPlayer(contentsOf: carStartMenuThemeURL)
        }
        catch {
            print (error)
            }
        startMenuThemePlayer?.play()
            }
        }
    }
    
    
    @IBAction func newGameButtonTap(_ sender: Any) {
        let gameStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let gameViewController = gameStoryBoard.instantiateViewController(withIdentifier: String(describing: GameViewController.self)) as? GameViewController
        navigationController?.pushViewController(gameViewController ?? UIViewController(), animated: true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        startMenuThemePlayer?.stop()
    }
    
    @IBAction func recordsTableButtonTap(_ sender: Any) {
        let recordsStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let recordsViewController = recordsStoryBoard.instantiateViewController(withIdentifier: String(describing: RecordsViewController.self)) as? RecordsViewController
        navigationController?.pushViewController(recordsViewController ?? UIViewController(), animated: true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func settingsButtonTap(_ sender: Any) {
        let settingsStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let settingsViewController = settingsStoryBoard.instantiateViewController(withIdentifier: String(describing: SettingsViewController.self)) as? SettingsViewController
        navigationController?.pushViewController(settingsViewController ?? UIViewController(), animated: true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

