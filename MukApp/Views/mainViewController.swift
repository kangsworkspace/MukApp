//
//  ViewController.swift
//  MukApp
//
//  Created by Kang on 10/21/23.
//

import UIKit

class mainViewController: UIViewController {

    // ToDo
    // 에러 처리 (빈 문자열 저장 안되도록)
    // 카테고리 여러개 저장 - 출력
    // 목록을 보여주는 뷰(피커 뷰)
    
    
    
    // MARK: - Interface
    // 카테고리를 표시할 피커뷰
    lazy var pickerView: UIPickerView = {
        let picker = UIPickerView()
        
        picker.backgroundColor = .white
        picker.delegate = self
        picker.dataSource = self
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    // 테스트
    private let testValues: [String] = ["A", "B", "C"]
    
    
    
    // 메인 레이블 (mainLabel)
    private var mainLabel: UILabel = {
        let label = UILabel()
        
        // 텍스트 설정
        label.text = "지금 먹을 메뉴는"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textAlignment = .center
        
        // 보더 설정
        label.layer.borderWidth = 1
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 메뉴 레이블 (menuLabel)
    private var menuLabel: UILabel = {
    
        let label = UILabel()
        
        // 텍스트 설정
        label.text = "치킨"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        
        // 보더 설정
        label.layer.borderWidth = 1
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // categoryTextLabel
    var categoryTextLabel: UILabel = {
       let label = UILabel()
        
        // 텍스트 설정
        label.text = "최소 1개의 카테고리를 정해주세요"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        
        // 보더 설정
        label.layer.borderWidth = 1
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // 카테고리 뷰(categoryView)
    private var categoryView: UIView = {
        let view = UIView()
    
        view.layer.borderWidth = 1
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // 메뉴 버튼(menuButton)
    private var menuButton: UIButton = {
        let button = UIButton()
        button.setTitle("메뉴 뽑기", for: .normal)
        button.backgroundColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMain()
    }

    func setupMain() {
        
        view.backgroundColor = .white
        
        setAddView()
        setAutoLayout()
    }
    
    // 셋업 - 애드뷰
    func setAddView() {
        view.addSubview(mainLabel)
        view.addSubview(menuLabel)
        view.addSubview(categoryTextLabel)
        categoryView.addSubview(pickerView)
        view.addSubview(categoryView)
        view.addSubview(menuButton)
    }
    
    // 셋업 - 오토 레이아웃
    func setAutoLayout() {
        
        // mainLabel 오토 레이아웃
        NSLayoutConstraint.activate([
            mainLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            mainLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            mainLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            
            mainLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // menuLabel 오토 레이아웃
        NSLayoutConstraint.activate([
            menuLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            menuLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 20),
            menuLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            
            menuLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // categoryTextLabel 오토 레이아웃
        NSLayoutConstraint.activate([
            categoryTextLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            categoryTextLabel.topAnchor.constraint(equalTo: menuLabel.bottomAnchor, constant: 30),
            categoryTextLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            
            categoryTextLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        // categoryView 오토 레이아웃
        NSLayoutConstraint.activate([
            categoryView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            categoryView.topAnchor.constraint(equalTo: categoryTextLabel.bottomAnchor, constant: 10),
            categoryView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            
            categoryView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        
        
        // pickerView 오토 레이아웃
        NSLayoutConstraint.activate([
            pickerView.leadingAnchor.constraint(equalTo: categoryView.leadingAnchor, constant: 0),
            pickerView.topAnchor.constraint(equalTo: categoryView.topAnchor, constant: 0),
            pickerView.bottomAnchor.constraint(equalTo: categoryView.bottomAnchor, constant: 0),
            
            pickerView.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        // menuButton 오토 레이아웃
        NSLayoutConstraint.activate([
            menuButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            menuButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            menuButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            
            menuButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}

extension mainViewController: UIPickerViewDelegate {
    
}

extension mainViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return testValues.count
    }
    
    
}

