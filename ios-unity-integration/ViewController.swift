//
//  ViewController.swift
//  ios-unity-integration
//
//  Created by Betül Çalık on 26.08.2023.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - UI Components
    @IBOutlet weak var startUnityButton: UIButton!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        startUnityButton.layer.cornerRadius = startUnityButton.frame.height / 2
    }

    // MARK: - Actions
    @IBAction func didStartUnityButtonTap(_ sender: UIButton) {
        UnityManager.shared.show()
    }
    
}

