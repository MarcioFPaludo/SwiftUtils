//
//  ViewController.swift
//  SwiftUtilsSamples
//
//  Created by Marcio F. Paludo on 06/02/21.
//

import SwiftUtils
import UIKit

class ViewModel: ViewModelProtocol {}

class ViewController: UIViewController {

    @IBOutlet weak var bottomSheetButton: UIButton! {
        didSet {
            bottomSheetButton.layer.cornerRadius = 22
        }
    }
    
    // MARK: - General Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch Envirotment.current {
        case .production: title = "Production Envirotment"
        case .homolog: title = "Homolagation Envirotment"
        case .develop: title = "Development Envirotment"
        }
    }

    // MARK: - IBActions
    
    @IBAction func didTouchShorBottomSheet(_ sender: Any) {
        let loadingVC = ViewModel().viewController(LoadingViewController.self)
        let bottomSheetVC = BottomSheetController(withContent: loadingVC)
        bottomSheetVC.sheetSizingStyle = .fixed(height: 250)
        present(bottomSheetVC, animated: true)
    }
}

