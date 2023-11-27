//
//  ResultViewController.swift
//  MukApp
//
//  Created by Kang on 10/30/23.
//

import UIKit

class ResultViewController: UIViewController {

    // MARK: - 변수
    // Target Restaurant 정보
    var targetRes: RestaurantData?
    
    // MARK: - Interface
    // 메인 레이블 (mainLabel)
    private var mainLabel: UILabel = {
        let label = UILabel()
        
        // 텍스트 설정
        label.text = "지금 먹을 메뉴는?"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    lazy var resImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.image = UIImage(systemName: "person")
        imageView.backgroundColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var resNameLabel: UILabel = {
        let label = UILabel()
        label.text = "어쭈꾸미"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var resAddressLabel: UILabel = {
        let label = UILabel()
        label.text = "올림픽대로 다리 밑 ㅇ으엥에아아132라"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("결정!", for: .normal)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var rerollButton: UIButton = {
        let button = UIButton()
        button.setTitle("다시 돌리기!", for: .normal)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(rerollButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // 맛집 관리하기 버튼
    private var editButton: UIButton = {
        let button = UIButton()
        button.setTitle("맛집 관리하기", for: .normal)
        button.backgroundColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        setMain()
    }
    
    // MARK: - SetUp
    func setMain() {
        
        // 백그라운드 컬러 설정
        view.backgroundColor = .white
        
        setAddView()
        setAutoLayout()
        setUI()
    }
    
    // 셋업 - 애드뷰
    func setAddView() {
        view.addSubview(mainLabel)
        
        resImageView.addSubview(resNameLabel)
        resImageView.addSubview(resAddressLabel)
        view.addSubview(resImageView)
        
        buttonStackView.addArrangedSubview(confirmButton)
        buttonStackView.addArrangedSubview(rerollButton)
        view.addSubview(buttonStackView)
        view.addSubview(editButton)
    }
    
    // MARK: - AutoLayout
    func setAutoLayout() {
        // mainLabel 오토 레이아웃
        NSLayoutConstraint.activate([
            mainLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            mainLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 45),
            mainLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            
            mainLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        // mainView 오토 레이아웃
        NSLayoutConstraint.activate([
            resImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 100),
            resImageView.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 80),
            resImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -100),
            
            resImageView.heightAnchor.constraint(equalToConstant: 220)
        ])
        
        // resImageView 오토 레이아웃
        NSLayoutConstraint.activate([
            resAddressLabel.leadingAnchor.constraint(equalTo: resImageView.leadingAnchor, constant: 10),
            resAddressLabel.trailingAnchor.constraint(equalTo: resImageView.trailingAnchor, constant: -10),
            resAddressLabel.bottomAnchor.constraint(equalTo: resImageView.bottomAnchor, constant: -10),
        ])
        
        
        // resImageView 오토 레이아웃
        NSLayoutConstraint.activate([
            resNameLabel.bottomAnchor.constraint(equalTo: resAddressLabel.topAnchor, constant: -10),
            resNameLabel.centerXAnchor.constraint(equalTo: resImageView.centerXAnchor, constant: 0)
        ])
        
        
        // buttonStackView 오토 레이아웃
        NSLayoutConstraint.activate([
            buttonStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            buttonStackView.topAnchor.constraint(equalTo: resImageView.bottomAnchor, constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            
            buttonStackView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // editButton 오토 레이아웃
        NSLayoutConstraint.activate([
            editButton.leadingAnchor.constraint(equalTo: buttonStackView.leadingAnchor, constant: 0),
            editButton.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: 10),
            editButton.trailingAnchor.constraint(equalTo: buttonStackView.trailingAnchor, constant: 0),
            
            editButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // UI 세팅
    func setUI() {
        // 식당 이름
        resNameLabel.text = targetRes?.placeName
        // 식당 주소
        resAddressLabel.text = targetRes?.roadAddress
    }
    
    // 리롤 버튼이 눌렸을 때
    @objc func rerollButtonTapped() {
        print("다시 돌리기!")
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func confirmButtonTapped() {
        print("메인 화면으로")
        self.navigationController?.popToRootViewController(animated: true)
    }
}
