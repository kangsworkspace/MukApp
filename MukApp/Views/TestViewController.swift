//
//  TestViewController.swift
//  MukApp
//
//  Created by Kang on 10/22/23.
//

import UIKit

class TestViewController: UIViewController {
    
    let coreDataManager = CoreDataManager.shared
    
    private var menuNameTextField: UITextField = {
        let textField = UITextField()
        
        // 텍스트 설정
        textField.placeholder = "메뉴 이름"
        textField.textColor = .black
        textField.font = UIFont.boldSystemFont(ofSize: 20)
        textField.textAlignment = .center
        textField.text = ""
        
        // 보더 설정
        textField.layer.borderWidth = 1
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private var categoryNameTextField: UITextField = {
        let textField = UITextField()
        
        // 텍스트 설정
        textField.placeholder = "카테고리 이름"
        textField.textColor = .black
        textField.font = UIFont.boldSystemFont(ofSize: 20)
        textField.textAlignment = .center
        textField.text = ""
        
        // 보더 설정
        textField.layer.borderWidth = 1
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private var categoryTextTextField: UITextField = {
        let textField = UITextField()
        
        // 텍스트 설정
        textField.placeholder = "카테고리 내용"
        textField.textColor = .black
        textField.font = UIFont.boldSystemFont(ofSize: 20)
        textField.textAlignment = .center
        textField.text = ""
        
        // 보더 설정
        textField.layer.borderWidth = 1
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    // 메뉴 버튼(saveButton)
    private var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("저장 버튼", for: .normal)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "카테고리 관리"
        view.backgroundColor = .white
        
        mainStackView.addArrangedSubview(menuNameTextField)
        mainStackView.addArrangedSubview(categoryNameTextField)
        mainStackView.addArrangedSubview(categoryTextTextField)
        mainStackView.addArrangedSubview(saveButton)
        
        view.addSubview(mainStackView)
        
        setAutoLayout()
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setAutoLayout() {
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            menuNameTextField.heightAnchor.constraint(equalToConstant: 40),
            categoryNameTextField.heightAnchor.constraint(equalToConstant: 40),
            categoryTextTextField.heightAnchor.constraint(equalToConstant: 40),
            saveButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc func saveButtonTapped() {
        print("saveButton이 눌렸습니다.")
        coreDataManager.saveMenuToCoreData(menuName: menuNameTextField.text ?? "", categoryName: categoryNameTextField.text ?? "", categoryText: categoryTextTextField.text ?? "") {
            print("saveButtonTapped 동작 완료")
        }
    }
}
