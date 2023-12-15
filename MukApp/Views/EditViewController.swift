//
//  EditViewController.swift
//  MukApp
//
//  Created by Kang on 12/3/23.
//

import UIKit

class EditViewController: UIViewController {

    // MARK: - Main뷰 모델
    let viewModel: MainViewModel
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setMain()
    }
    
    func setMain() {
        view.backgroundColor = .white
        
        let selHashTagName: [String] = ["a"]
        let selHashTagText: [String] = ["a"]
        let resultResConName = viewModel.getNextCatNameArray(selHashTagName: selHashTagName, selHashTagText: selHashTagText)

        for resultRes in resultResConName {
            print("\(resultRes)")
        }
    }
}
