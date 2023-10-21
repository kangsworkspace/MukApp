//
//  ViewController.swift
//  MukApp
//
//  Created by Kang on 10/21/23.
//

import UIKit

class mainViewController: UIViewController {

    
    // MARK: - Interface
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
    
    func setAddView() {
        view.addSubview(mainLabel)
        view.addSubview(menuLabel)
        view.addSubview(categoryView)
        view.addSubview(menuButton)
    }
    
    func setAutoLayout() {
        
        // mainLabel 오토 레이아웃
        NSLayoutConstraint.activate([
            mainLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            mainLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
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
        
        // categoryView 오토 레이아웃
        NSLayoutConstraint.activate([
            categoryView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            categoryView.topAnchor.constraint(equalTo: menuLabel.bottomAnchor, constant: 50),
            categoryView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            
            categoryView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        // menuButton 오토 레이아웃
        NSLayoutConstraint.activate([
            menuButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            menuButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            menuButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            
            menuButton.heightAnchor.constraint(equalToConstant: 80)
        ])
        

    }
}

