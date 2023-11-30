//
//  RestaurantViewController.swift
//  MukApp
//
//  Created by Kang on 11/26/23.
//

import UIKit

class RestaurantViewController: UIViewController {
    
    // MARK: - 뷰 모델
    let viewModel: MainViewModel
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 코어 데이터에 있는 맛집 데이터
    var restaurantCoreData: RestaurantData? {
        didSet {
            configureUIWithData()
        }
    }
    
    // API에서 받아온 맛집 데이터
    var restaurantAPIData: Document? {
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
        label.text = "맛집"
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
        label.text = "올림픽대로 대로변 -1234"
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
        label.text = "http:"
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
    
    // 저장 버튼(addResButton)
    private var addResButton: UIButton = {
        let button = UIButton()
        button.setTitle("저     장", for: .normal)
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
    private var categoryCnt: Int = 1
    
    // 초기에만 데이터 셋팅하도록 설정해줄 변수
    var isConfigured: Int = 0
    // category 갯수 맞추기
    var dropCnt = 0
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMain()
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
        setDropDown()
    }
    
    func setDropDown() {
        dropCnt = categoryCnt
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
    
    func setTableView() {
        // 델리게이트 패턴, 데이터 처리 설정
        tableView.dataSource = self
        tableView.delegate = self
        
        // 셀의 높이 설정
        tableView.rowHeight = 60
        
        // 셀 등록
        tableView.register(RestaurantTableViewCell.self, forCellReuseIdentifier: "RestaurantTableViewCell")
    }
    
    // MARK: - Function
    @objc func addResButtonTapped() {
        
        var catNameArray: [String] = []
        var catTextArray: [String] = []
        
        // 각 셀의 Text 가져오기.
        for index in 0...categoryCnt - 1 {
            let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as! RestaurantTableViewCell
            catNameArray.append(cell.nameDropLabel.text ?? "")
            print("\(index)번째 Name 텍스트: \(cell.nameDropLabel.text ?? "")")
            
            catTextArray.append(cell.textDropLabel.text ?? "")
            print("\(index)번째 Text 텍스트: \(cell.textDropLabel.text ?? "")")
        }
    
        // 포함되면 안되는 문자열을 가진 경우 리턴
        if catNameArray.contains("") || catNameArray.contains("선택해주세요") || catTextArray.contains("") || catTextArray.contains("선택해주세요") {
            
            // 텍스트 안내문 추가해주기
            print("포함되면 안되는 문자열 포함")
            
            return
        }
        
        // 정보를 수정하는 경우
        else if let restaurantCoreData {
            viewModel.handleUpdateResData(restaurantData: restaurantCoreData)
        }
        // 맛집을 추가하는 경우
        else if let restaurantAPIData {
            viewModel.addResToCoreData(restaurantData: restaurantAPIData, catNameArray: catNameArray, catTextArray: catTextArray)
        }
    }
    
    // addResButtonTapped이 눌렸을 때 -> 델리게이트로 사용 ****코드 필요한지 체크하기 ******
    var handleAddResButtonTapped: (() -> ()) = {}
    
    @objc func plusButtonTapped() {
        addNewCell()
    }
    
    @objc func minusButtonTapped() {
        if categoryCnt == 1 {
            return
        } else {
            deleteCell()
        }
    }
    
    // 초기 UI 설정
    func configureUIWithData() {
        // 저장된 맛집 수정 -> CoreData에 저장된 데이터 할당
        if let restaurantCoreData {
            resNameLabel.text = restaurantCoreData.placeName
            resPhoneLabel.text = restaurantCoreData.phone
            resAddressLabel.text = restaurantCoreData.roadAddress
            resURLLabel.text = restaurantCoreData.placeURL
            addResButton.setTitle("UPDATE", for: .normal)
            
            guard let categorySet = restaurantCoreData.category as? Set<CategoryData> else { return }
            let categoryArray = Array(categorySet)

            // categoryCnt 갯수 맞추기
            categoryCnt = categoryArray.count
                        
            tableView.reloadData()
        }
        
        // 맛집 추가 -> APIData 데이터 할당
        else if let restaurantAPIData {
            resNameLabel.text = restaurantAPIData.placeName
            resPhoneLabel.text = restaurantAPIData.phone
            resAddressLabel.text = restaurantAPIData.roadAddress
            resURLLabel.text = restaurantAPIData.placeURL
            addResButton.setTitle("SAVE", for: .normal)
        }
    }
    
    // 새로운 Cell 생성
    func addNewCell() {
        // 카테고리 카운트 + 1
        categoryCnt += 1
        print("categoryCnt: \(categoryCnt)")
        
        // 테이블 뷰 마지막 순서에 셀 생성
        tableView.insertRows(at: [IndexPath(row: categoryCnt - 1, section: 0)], with: .fade)
        
        // 셀의 Label.text = "선택해주세요"
        let cell = tableView.cellForRow(at: IndexPath(row: categoryCnt - 1, section: 0)) as! RestaurantTableViewCell
        cell.nameDropLabel.text = "선택해주세요"
        cell.textDropLabel.text = "선택해주세요"
    }
    
    // 마지막 Cell 삭제
    func deleteCell() {
        categoryCnt -= 1
        print("categoryCnt: \(categoryCnt)")
        tableView.deleteRows(at: [IndexPath(row: categoryCnt, section: 0)], with: .fade)
    }
}

// MARK: - Extension
extension RestaurantViewController: UITableViewDelegate {
    // 테이블 뷰 셀이 눌렸을 때
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension RestaurantViewController: UITableViewDataSource {
    // 표시할 테이블 뷰 셀 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryCnt
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantTableViewCell", for: indexPath) as! RestaurantTableViewCell
        
        cell.selectionStyle = .none
        cell.backgroundColor = .white
        
        // 초기에 categoryCnt만큼 실행
        if isConfigured != dropCnt {
            if let restaurantCoreData {
                if let categorySet = restaurantCoreData.category as? Set<CategoryData> {
                    let categoryArray = Array(categorySet)
                    cell.nameDropLabel.text = categoryArray[indexPath.row].categoryName
                    cell.textDropLabel.text = categoryArray[indexPath.row].categoryText
                    print("restaurantCoreData 적용")
                }
            }
            isConfigured += 1
        }
        
        
        return cell
    }
}
