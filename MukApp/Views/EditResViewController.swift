//
//  TestViewController.swift
//  MukApp
//
//  Created by Kang on 10/22/23.
//

import UIKit

class EditResViewController: UIViewController {
    
    private var nameT: [String] = []
    private var textT: [String] = []
    
    // MARK: - 뷰 모델
    let viewModel: MainViewModel
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var resData: RestaurantData! {
        didSet {
            configureUIWithData()
        }
    }
    
    // MARK: - Interface
    // 이미지뷰
    private lazy var resImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person")
        imageView.backgroundColor = .yellow
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // 맛집 이름 레이블
    private var resNameLabel: UILabel = {
        let label = UILabel()
        // 텍스트 설정
        label.text = "어쭈꾸미?"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 이름 레이블
    private var resPhoneLabel: UILabel = {
        let label = UILabel()
        // 텍스트 설정
        label.text = "010 - 1234 - 5678"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 주소 레이블
    private var resAddressLabel: UILabel = {
        let label = UILabel()
        // 텍스트 설정
        label.text = "올림픽대로 대로변 다리 밑1 -1234"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // url 레이블
    private var resURLLabel: UILabel = {
        let label = UILabel()
        // 텍스트 설정
        label.text = "httpnkjldkaflanfefaefaeflnfkan>nfek?"
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // 테이블 뷰
    private let tableView = UITableView()
    
    // 저장 버튼(menuButton)
    private var addResButton: UIButton = {
        let button = UIButton()
        button.setTitle("저  장", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .lightGray
        button.addTarget(self, action: #selector(addResButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // 카테고리 추가 버튼
    private var plusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus")!.withTintColor(.darkGray, renderingMode: .alwaysOriginal), for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // 카테고리 삭제 버튼
    private var minusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "minus")!.withTintColor(.darkGray, renderingMode: .alwaysOriginal), for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // 카테고리 설정 카운트
    private var categoryCnt: Int = 0 {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMain()
        viewModel.setNameDropLabel(resData: resData) { nameArray, textArray in
            self.nameT = nameArray
            self.textT = textArray
        }
    }
    
    // MARK: - viewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // saveButton 원으로 설정
        addResButton.layer.cornerRadius = 20
        addResButton.clipsToBounds = true
        
        // saveButton 그림자 추가
        addResButton.layer.shadowColor = UIColor.black.cgColor
        addResButton.layer.masksToBounds = false
        addResButton.layer.shadowOffset = CGSize(width: 1, height: 4)
        addResButton.layer.shadowRadius = 5
        addResButton.layer.shadowOpacity = 0.3
        
        // plusButton 원으로 설정
        plusButton.clipsToBounds = true
        plusButton.layer.cornerRadius = plusButton.frame.width / 2
        
        // plusButton 그림자 추가
        plusButton.layer.shadowColor = UIColor.black.cgColor
        plusButton.layer.masksToBounds = false
        plusButton.layer.shadowOffset = CGSize(width: 1, height: 4)
        plusButton.layer.shadowRadius = 5
        plusButton.layer.shadowOpacity = 0.3
        
        // minusButton 원으로 설정
        minusButton.clipsToBounds = true
        minusButton.layer.cornerRadius = minusButton.frame.width / 2
        
        // minusButton 그림자 추가
        minusButton.layer.shadowColor = UIColor.black.cgColor
        minusButton.layer.masksToBounds = false
        minusButton.layer.shadowOffset = CGSize(width: 1, height: 4)
        minusButton.layer.shadowRadius = 5
        minusButton.layer.shadowOpacity = 0.3
    }
    
    // MARK: - Setup
    func setMain() {
        view.backgroundColor = .white
        self.title = "추가"
        
        setAddView()
        setAutoLayout()
        setTableView()
    }
    
    func setAddView() {
        view.addSubview(resImageView)
        mainStackView.addArrangedSubview(resNameLabel)
        mainStackView.addArrangedSubview(resPhoneLabel)
        mainStackView.addArrangedSubview(resAddressLabel)
        mainStackView.addArrangedSubview(resURLLabel)
        view.addSubview(mainStackView)
        view.addSubview(tableView)
        view.addSubview(addResButton)
        view.addSubview(plusButton)
        view.addSubview(minusButton)
    }
    
    func setAutoLayout() {
        
        // resImageView 오토 레이아웃
        NSLayoutConstraint.activate([
            resImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            resImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            resImageView.heightAnchor.constraint(equalToConstant: 140),
            resImageView.widthAnchor.constraint(equalToConstant: 120)
        ])
        
        // mainStackView 오토 레이아웃
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: resImageView.trailingAnchor, constant: 10),
            mainStackView.topAnchor.constraint(equalTo: resImageView.topAnchor, constant: 30),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            mainStackView.bottomAnchor.constraint(equalTo: resImageView.bottomAnchor, constant: 0),
        ])
        
        // tableView 오토 레이아웃
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            tableView.topAnchor.constraint(equalTo: resImageView.bottomAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            tableView.bottomAnchor.constraint(equalTo: addResButton.topAnchor, constant: -10)
        ])
        
        // addResButton 오토 레이아웃
        NSLayoutConstraint.activate([
            addResButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 80),
            addResButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -80),
            addResButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            addResButton.heightAnchor.constraint(equalToConstant: 46)
        ])
        
        // plusButton, minusButton 오토 레이아웃
        NSLayoutConstraint.activate([
            // plusButton
            plusButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            plusButton.bottomAnchor.constraint(equalTo: addResButton.topAnchor, constant: -10),
            plusButton.heightAnchor.constraint(equalToConstant: 40),
            plusButton.widthAnchor.constraint(equalToConstant: 40),
            
            // minusButton
            minusButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            minusButton.bottomAnchor.constraint(equalTo: plusButton.topAnchor, constant: -10),
            minusButton.heightAnchor.constraint(equalToConstant: 40),
            minusButton.widthAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    // 셋업 - 테이블 뷰
    func setTableView() {
        // 델리게이트 패턴, 데이터 처리 설정
        tableView.dataSource = self
        tableView.delegate = self
        
        // 셀의 높이 설정
        tableView.rowHeight = 60
        
        // 셀 등록
        tableView.register(EditResTableViewCell.self, forCellReuseIdentifier: "EditResTableViewCell")
    }
    
    // MARK: - Function
    // addResButton 동작
    @objc func addResButtonTapped() {
        viewModel.handeTestingCoreData()
    }
    
    var handleAddResButtonTapped: (() -> ()) = {}
    
    @objc func plusButtonTapped() {
        categoryCnt += 1
    }
    
    @objc func minusButtonTapped() {
        if categoryCnt == 1 {
            return
        } else {
            categoryCnt -= 1
        }
    }
    
    func configureUIWithData() {
        resNameLabel.text = resData.placeName
        resPhoneLabel.text = resData.phone
        resAddressLabel.text = resData.roadAddress
        resURLLabel.text = resData.placeURL
    }
}

// MARK: - Extension
extension EditResViewController: UITableViewDelegate {
    // 테이블 뷰 셀이 눌렸을 때
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension EditResViewController: UITableViewDataSource {
    // 표시할 테이블 뷰 셀 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (resData.category?.count ?? 0) + categoryCnt
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EditResTableViewCell", for: indexPath) as! EditResTableViewCell
        
        cell.selectionStyle = .none
        cell.backgroundColor = .white
        
        cell.nameDropLabel.text = nameT[indexPath.row]
        cell.textDropLabel.text = textT[indexPath.row]
        
        return cell
    }
}



