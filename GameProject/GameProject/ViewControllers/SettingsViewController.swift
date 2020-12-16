//
//  SettingsViewController.swift
//  GameProject
//
//  Created by Pavel Shyker on 9/28/20.
//  Copyright © 2020 Pavel Shyker. All rights reserved.
//

import UIKit
import AVKit

class SettingsViewController: UIViewController {
    var name = "Player"
    var carColor: String?
    var isSoundNeeded: Bool?
    var isSoundShouldBeRestarted: Bool?
    var startSoundPlayer: AVAudioPlayer?
    var originSoundOption: Int?
    var selectedSoundOption: Int?
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var carColorSegmentControl: UISegmentedControl!
    @IBOutlet weak var soundSettingsSegmentControl: UISegmentedControl!
    @IBOutlet weak var applyButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        applyButton.setCornerRadius(radius: applyButton.frame.size.height/2)
        applyButton.setShadow(opacity: 0.7, radius: 5)

        carColor = UserDefaults.standard.value(forKey: .carColor) as? String ?? "Red"
        isSoundNeeded = UserDefaults.standard.value(forKey: "soundOption") as? Bool ?? true
        name = UserDefaults.standard.value(forKey: .userName) as? String ?? "Player"
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(
            handleTap(_:)))
        view.addGestureRecognizer(tapGestureRecognizer)
        
        nameTextField.returnKeyType = UIReturnKeyType.done
        nameTextField.delegate = self
    }
    
    func playStartGameSound() {
        if isSoundNeeded == true {
        if let carStartSoundPath = Bundle.main.path(forResource: "carStartSound", ofType: "mp3") {
            let carStartSoundUrl = URL(fileURLWithPath: carStartSoundPath)
            do {
                startSoundPlayer = try AVAudioPlayer(contentsOf: carStartSoundUrl)
            }
            catch {
                print (error)
            }
            startSoundPlayer?.play()
        }
        }
    }
    
    @objc func keyboardDidShow(_ notification: Notification) {
    }
    
    @objc func keyboardDidHide(_ notification: Notification) {
    }
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if carColor == "Yellow" {
            carColorSegmentControl.selectedSegmentIndex = 1
        }
        else {
            carColorSegmentControl.selectedSegmentIndex = 0
        }
        
        
        if isSoundNeeded == true {
            soundSettingsSegmentControl.selectedSegmentIndex = 0
        }
        else {
            soundSettingsSegmentControl.selectedSegmentIndex = 1
        }
        nameTextField.text = name
        originSoundOption = soundSettingsSegmentControl.selectedSegmentIndex
    }
    
    @IBAction func applyButtonTapped(_ sender: Any) {
        
        name = nameTextField.text ?? "Player"
        UserDefaults.standard.setValue(name, forKey: .userName)
        
        carColor = carColorSegmentControl.titleForSegment(at: carColorSegmentControl.selectedSegmentIndex) ?? "Red"
        UserDefaults.standard.setValue(carColor, forKey: .carColor)
        
        selectedSoundOption = soundSettingsSegmentControl.selectedSegmentIndex
        rememberSounfOption(selectedSoundOption ?? 0)
        rememberRestartNeededOption(originSoundOption ?? 0, selectedSoundOption ?? 0)
        
        self.navigationController?.popViewController(animated: true)
        self.playStartGameSound()
    }
    
    func rememberSounfOption(_ soundOption: Int) {
        if selectedSoundOption == 0 {
            isSoundNeeded = true
        }
        else {
            isSoundNeeded = false
        }
        UserDefaults.standard.setValue(isSoundNeeded, forKey: "soundOption")
    }
    
    func rememberRestartNeededOption(_ originSoundOption: Int, _ selectedSoundOption: Int) {
        if originSoundOption != selectedSoundOption {
            isSoundShouldBeRestarted = true
        }
        else {
            isSoundShouldBeRestarted = false
        }
        UserDefaults.standard.setValue(isSoundShouldBeRestarted, forKey: "isSoundShouldBeRestarted")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SettingsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
