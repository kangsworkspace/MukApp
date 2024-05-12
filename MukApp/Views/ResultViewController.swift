//
//  ResultViewController.swift
//  MukApp
//
//  Created by Kang on 10/30/23.
//

import UIKit

class ResultViewController: UIViewController {

    // MARK: - ViewModel
    let viewModel: MainViewModel
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 변수
    // Target Restaurant 정보
    var targetRes: RestaurantData?
    
    // MARK: - Interface
    // 메인 레이블 (mainLabel)
    private var mainLabel: UILabel = {
        let label = UILabel()
        
        // 텍스트 설정
        label.text = "지금 가볼 맛집은?"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var resNameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 23)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var resImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // 이미지뷰
    private lazy var resPhoneImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = MyImage.number
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // 이미지뷰
    private lazy var resAddressImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = MyImage.address
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // 이미지뷰
    private lazy var resURLImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = MyImage.url
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // 번호 레이블
    private var resPhoneLabel: UILabel = {
        let label = UILabel()
        // 텍스트 설정
        label.text = "010 - 1234 - 5678"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 주소 레이블
    private var resAddressLabel: UILabel = {
        let label = UILabel()
        // 텍스트 설정
        label.text = "올림픽대로 대로변 -1234"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 11)
        label.textAlignment = .left
        label.numberOfLines = 3
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // url 레이블
//    private var resURLLabel: UILabel = {
//        let label = UILabel()
//        // 텍스트 설정
//        label.text = "http:"
//        label.numberOfLines = 3
//        label.textColor = .black
//        label.font = UIFont.systemFont(ofSize: 13)
//        label.textAlignment = .left
//        label.lineBreakMode = .byWordWrapping
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
    
    private var resURLButton: UIButton = {
        let button = UIButton()
        // 텍스트 설정
        button.setTitle("", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.titleLabel?.textAlignment = .left
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.addTarget(self, action: #selector(resURLButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    // 번호 스택뷰
    private var resPhoneStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // 주소 스택뷰
    private var resAddressStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // url 스택뷰
    private var urlStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // 메인 스택뷰
    private var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("결정!", for: .normal)
        button.backgroundColor = MyColor.themeColor
        button.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var rerollButton: UIButton = {
        let button = UIButton()
        button.setTitle("다시 돌리기!", for: .normal)
        button.backgroundColor = MyColor.themeColor
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
        button.backgroundColor = MyColor.themeColor
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        setMain()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
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
        
        view.addSubview(resNameLabel)
        view.addSubview(resImageView)
        
        resPhoneStackView.addArrangedSubview(resPhoneImageView)
        resPhoneStackView.addArrangedSubview(resPhoneLabel)
        resAddressStackView.addArrangedSubview(resAddressImageView)
        resAddressStackView.addArrangedSubview(resAddressLabel)
        urlStackView.addArrangedSubview(resURLImageView)
        urlStackView.addArrangedSubview(resURLButton)
        
        mainStackView.addArrangedSubview(resPhoneStackView)
        mainStackView.addArrangedSubview(resAddressStackView)
        mainStackView.addArrangedSubview(urlStackView)
        view.addSubview(mainStackView)
    
        view.addSubview(lineView)
        
        
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
        
        // resNameLabel 오토 레이아웃
        NSLayoutConstraint.activate([
            resNameLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 30),
            resNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
        ])
        
        // resImageView 오토 레이아웃
        NSLayoutConstraint.activate([
            resImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            resImageView.topAnchor.constraint(equalTo: resNameLabel.bottomAnchor, constant: 10),
            resImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            
            resImageView.heightAnchor.constraint(equalToConstant: 280)
        ])
        
        // Image 크기 오토 레이아웃
        NSLayoutConstraint.activate([
            resPhoneImageView.heightAnchor.constraint(equalToConstant: 20),
            resPhoneImageView.widthAnchor.constraint(equalToConstant: 20),
            resPhoneLabel.centerYAnchor.constraint(equalTo: resPhoneImageView.centerYAnchor),
            
            resAddressImageView.heightAnchor.constraint(equalToConstant: 20),
            resAddressImageView.widthAnchor.constraint(equalToConstant: 20),
            resAddressLabel.centerYAnchor.constraint(equalTo: resAddressImageView.centerYAnchor),
            
            resURLImageView.heightAnchor.constraint(equalToConstant: 20),
            resURLImageView.widthAnchor.constraint(equalToConstant: 20),
            resURLButton.centerYAnchor.constraint(equalTo: resURLImageView.centerYAnchor)
        ])
        
        // mainStackView 오토 레이아웃
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            mainStackView.topAnchor.constraint(equalTo: resImageView.bottomAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
        
        // lineView 오토 레이아웃
        NSLayoutConstraint.activate([
            lineView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            lineView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            lineView.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 22),
            lineView.heightAnchor.constraint(equalToConstant: 2)
        ])
        
        // buttonStackView 오토 레이아웃
        NSLayoutConstraint.activate([
            buttonStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            buttonStackView.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 30),
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
        // 식당 번호
        resPhoneLabel.text = targetRes?.phone
        
        // 도로명 주소가 없으면 일반주소
        if targetRes?.roadAddress != "" {
            resAddressLabel.text = targetRes?.roadAddress
        } else if targetRes?.address != "" {
            resAddressLabel.text = targetRes?.address
        } else {
            resAddressLabel.text = "주소 정보 없음"
        }
        
        // 식당 URL
        resURLButton.setTitle(targetRes?.placeURL, for: .normal)
        // 식당 이미지
        // resImageView.image = viewModel.getImageFromImageManager(restaurantData: targetRes!)
        
        resImageView.image = if viewModel.getImageFromImageManager(restaurantData: targetRes!) != UIImage(systemName: "person") {
            viewModel.getImageFromImageManager(restaurantData: targetRes!)
        } else {
            if let resGroup = targetRes?.group {
                switch resGroup {
                case let groupString where groupString.contains("한식"):
                    RestaurantImages.korean
                case let groupString where groupString.contains("치킨"):
                    RestaurantImages.chicken
                case let groupString where groupString.contains("제과"):
                    RestaurantImages.bakery
                case let groupString where groupString.contains("디저트카페"):
                    RestaurantImages.dessertCafe
                case let groupString where groupString.contains("간식"):
                    RestaurantImages.dessertCafe
                case let groupString where groupString.contains("카페"):
                    RestaurantImages.cafe
                case let groupString where groupString.contains("일식"):
                    RestaurantImages.japanese
                case let groupString where groupString.contains("햄버거"):
                    RestaurantImages.hamburger
                case let groupString where groupString.contains("양식"):
                    RestaurantImages.europe
                case let groupString where groupString.contains("인도음식"):
                    RestaurantImages.indian
                case let groupString where groupString.contains("중식"):
                    RestaurantImages.chinese
                case let groupString where groupString.contains("아시아음식"):
                    RestaurantImages.asian
                case let groupString where groupString.contains("술집"):
                    RestaurantImages.alcohol
                default:
                    RestaurantImages.restaurant
                }
            } else {
                // 그룹이 설정되지 않은 경우
                RestaurantImages.restaurant
            }
        }
    }
    
    // 리롤 버튼이 눌렸을 때
    @objc func rerollButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func confirmButtonTapped() {
        viewModel.goBackRootView(fromCurrentVC: self, animated: true)
    }
    
    @objc func editButtonTapped() {
        guard let targetRes = targetRes else { return }
        viewModel.goRestaurantController(resData: targetRes, fromCurrentVC: self, animated: true)
    }
    
    @objc func resURLButtonTapped() {
        viewModel.goWebPage(url: resURLButton.currentTitle ?? "", fromVC: self)
    }
}
