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
    
    // MARK: - 이미지 매니저
    let imageManager: ImageManager
    
    // 커스텀 델리게이트
    weak var addResButtonDelegate: AddResButtonDelegate?
    
    init(viewModel: MainViewModel, imageManager: ImageManager) {
        self.viewModel = viewModel
        self.imageManager = imageManager
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
    
    // 사진, 앨범을 열 수 있는 이미지 피커
    let imagePicker = UIImagePickerController()
    
    // MARK: - Interface
    // 이미지뷰
    private lazy var resImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .yellow
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // 이미지뷰
    private lazy var resNameImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = MyImage.restaurant
        imageView.backgroundColor = .clear
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
    
    // 맛집 이름 레이블
    private var resNameLabel: UILabel = {
        let label = UILabel()
        // 텍스트 설정
        label.text = "맛집"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 번호 레이블
    private var resPhoneLabel: UILabel = {
        let label = UILabel()
        // 텍스트 설정
        label.text = ""
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 주소 레이블
    private var resAddressLabel: UILabel = {
        let label = UILabel()
        // 텍스트 설정
        label.text = ""
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 10)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // url 레이블
    private var resURLButton: UIButton = {
        let button = UIButton()
        // 텍스트 설정
        button.setTitle("", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.titleLabel?.textAlignment = .left
        // button.titleLabel?.lineBreakMode = .byWordWrapping
        button.addTarget(self, action: #selector(resURLButtonTapped), for: .touchUpInside)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // 이름 스택뷰
    private var resNameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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
    
    private var hashTagLabel: UILabel = {
        let label = UILabel()
        // 텍스트 설정
        label.text = "Hash Tag"
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var infoLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 0
        label.textColor = .red
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 테이블 뷰
    private let tableView = UITableView()
    
    // 저장 버튼(addResButton)
    private var addResButton: UIButton = {
        let button = UIButton()
        button.setTitle("저     장", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = MyColor.themeColor
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
    
    // MARK: - 변수
    // 카테고리 설정 카운트
    private var categoryCnt: Int = 1
    
    // 해시태그를 저장할 함수
    var hashTagNameArray: [String] = []
    var hashTagTextArray: [String] = []
    
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
        
        setHashTag()
        setAddView()
        setAutoLayout()
        setTableView()
        setupTapGestures()
    }
    
    func setHashTag() {
        // 저장된 데이터가 있는 경우(수정)
        if let restaurantCoreData {
            // 카테고리를 배열로 가져오기
            // 정렬 -> order 순서대로
            let sortDescriptor = NSSortDescriptor(key: "order", ascending: true)
            if let categoryArray = restaurantCoreData.category?.sortedArray(using: [sortDescriptor]) as? [CategoryData] {
                // 기존 데이터를 hashTagArray에 할당
                for category in categoryArray {
                    hashTagNameArray.append(category.categoryName ?? "데이터 없음")
                    hashTagTextArray.append(category.categoryText ?? "데이터 없음")
                }
            }
            // 저장된 데이터가 없는 경우(추가)
        }
    }
    
    func setAddView() {
        view.addSubview(resImageView)
        resNameStackView.addArrangedSubview(resNameImageView)
        resNameStackView.addArrangedSubview(resNameLabel)
        resPhoneStackView.addArrangedSubview(resPhoneImageView)
        resPhoneStackView.addArrangedSubview(resPhoneLabel)
        resAddressStackView.addArrangedSubview(resAddressImageView)
        resAddressStackView.addArrangedSubview(resAddressLabel)
        urlStackView.addArrangedSubview(resURLImageView)
        urlStackView.addArrangedSubview(resURLButton)
        
        mainStackView.addArrangedSubview(resNameStackView)
        mainStackView.addArrangedSubview(resPhoneStackView)
        mainStackView.addArrangedSubview(resAddressStackView)
        mainStackView.addArrangedSubview(urlStackView)
        view.addSubview(mainStackView)
        
        view.addSubview(lineView)
        view.addSubview(hashTagLabel)
        view.addSubview(infoLabel)
        
        view.addSubview(tableView)
        view.addSubview(addResButton)
        view.addSubview(plusButton)
        view.addSubview(minusButton)
    }
    
    func setAutoLayout() {
        // resImageView 오토 레이아웃
        NSLayoutConstraint.activate([
            resImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            resImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            resImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            
            resImageView.heightAnchor.constraint(equalToConstant: 280),
        ])
        
        // Image 크기 오토 레이아웃
        NSLayoutConstraint.activate([
            resNameImageView.heightAnchor.constraint(equalToConstant: 30),
            resNameImageView.widthAnchor.constraint(equalToConstant: 30),
            resNameLabel.centerYAnchor.constraint(equalTo: resNameImageView.centerYAnchor),
            
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
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            mainStackView.topAnchor.constraint(equalTo: resImageView.bottomAnchor, constant: 12),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
        ])
        
        // lineView 오토 레이아웃
        NSLayoutConstraint.activate([
            lineView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            lineView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            lineView.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 12),
            lineView.heightAnchor.constraint(equalToConstant: 2)
        ])
        
        // hashTagLabel 오토 레이아웃
        NSLayoutConstraint.activate([
            hashTagLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 36),
            hashTagLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            hashTagLabel.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 12),
        ])
        
        // infoLabel 오토 레이아웃
        NSLayoutConstraint.activate([
            infoLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            infoLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            infoLabel.topAnchor.constraint(equalTo: hashTagLabel.bottomAnchor, constant: 4),
        ])
            
        // tableView 오토 레이아웃
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            tableView.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 4),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            tableView.bottomAnchor.constraint(equalTo: addResButton.topAnchor, constant: -16)
        ])
        
        // addResButton 오토 레이아웃
        NSLayoutConstraint.activate([
            addResButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 90),
            addResButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -90),
            addResButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            addResButton.heightAnchor.constraint(equalToConstant: 40)
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
        
        // 구분선 없애기
        tableView.separatorStyle = .none
        
        // 셀의 높이 설정
        tableView.rowHeight = CommonCGSize.hashTagTableHeight
        
        // 셀 등록
        tableView.register(RestaurantTableViewCell.self, forCellReuseIdentifier: "RestaurantTableViewCell")
    }
    
    // 앨범에 사진 넣을수 있도록 설정
    func setupTapGestures() {
        // 제스처 생성
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchUpImageView))
        // 이미지뷰에 제스처 넣기
        resImageView.addGestureRecognizer(tapGesture)
        // 유저가 제스쳐 사용 가능하도록 하기
        resImageView.isUserInteractionEnabled = true
        // 이미지 피커 델리게이트 가져오기
        imagePicker.delegate = self
    }
    
    // MARK: - Function
    @objc func addResButtonTapped() {
        // 포함되면 안되는 문자열을 가진 경우 리턴
        if hashTagNameArray.contains("") || hashTagNameArray.contains("선택해주세요") || hashTagTextArray.contains("") || hashTagTextArray.contains("선택해주세요") {
            // 텍스트 안내문 추가해주기
            infoLabel.text = """
                '빈칸'이나 '선택해주세요'는 저장할 수 없습니다.
            """
            return
        }
        
        // 정보를 수정하는 경우
        else if let restaurantCoreData {
            // 코어 데이터에 정보 업데이트
            viewModel.handleUpdateResData(restaurantData: restaurantCoreData, catNameArray: hashTagNameArray, catTextArray: hashTagTextArray, resImage: resImageView.image!)
            // 루트 뷰로 돌아가기
            viewModel.goBackRootView(fromCurrentVC: self, animated: true)
        }
        
        // 맛집을 추가하는 경우
        else if let restaurantAPIData {
            // 코어 데이터에 정보 생성
            viewModel.addResToCoreData(restaurantData: restaurantAPIData, catNameArray: hashTagNameArray, catTextArray: hashTagTextArray, resImage: resImageView.image ?? UIImage(systemName: "person")!)

            // 루트 뷰로 돌아가기
            viewModel.goBackRootView(fromCurrentVC: self, animated: true)
        }
        
        // 커스텀 델리게이트 동작
        addResButtonDelegate?.addResButtonActive()
    }
    
    @objc func plusButtonTapped() {
        // 카테고리 카운트 + 1
        categoryCnt += 1
        
        // 인포 메시지 업데이트
        infoLabel.text = ""
        
        // 해쉬태그 추가
        addHashTag()
    }
    
    @objc func minusButtonTapped() {
        if categoryCnt == 1 {
            
            // 인포 메시지 업데이트
            infoLabel.text = "1개 이상의 해시태그를 설정해야 합니다"
            
            return
        } else {
            // 카테고리 카운트 - 1
            categoryCnt -= 1
            
            // 인포 메시지 업데이트
            infoLabel.text = ""
            
            // 해쉬태그 삭제
            deleteHashTag()
        }
    }
    
    // 초기 UI 설정
    func configureUIWithData() {
        // 저장된 맛집 수정 -> CoreData에 저장된 데이터 할당
        if let restaurantCoreData {
            resNameLabel.text = restaurantCoreData.placeName
            resPhoneLabel.text = restaurantCoreData.phone
            
            // 도로명 주소가 없으면 일반주소
            if restaurantCoreData.roadAddress != "" {
                resAddressLabel.text = restaurantCoreData.roadAddress
            } else if restaurantCoreData.address != "" {
                resAddressLabel.text = restaurantCoreData.address
            } else {
                resAddressLabel.text = "주소 정보 없음"
            }
            
            resURLButton.setTitle(restaurantCoreData.placeURL, for: .normal)
            addResButton.setTitle("UPDATE", for: .normal)
            
            if let imagePath = restaurantCoreData.imagePath {
                resImageView.image = if imageManager.readFile(urlPath: imagePath) != UIImage(systemName: "person") {
                    imageManager.readFile(urlPath: imagePath)
                } else {
                    if let resGroup = restaurantCoreData.group {
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
                
                
                
                // resImageView.image = imageManager.readFile(urlPath: imagePath)
            } else {
                resImageView.image = RestaurantImages.restaurant
            }
            
            guard let categorySet = restaurantCoreData.category as? Set<CategoryData> else { return }
            let categoryArray = Array(categorySet)
            
            // categoryCnt 갯수 맞추기
            categoryCnt = categoryArray.count
            
            tableView.reloadData()
        }
        // 맛집 추가 -> APIData 데이터 할당
        else if let restaurantAPIData {
            resNameLabel.text = restaurantAPIData.placeName
            
            // 에러 처리
            if restaurantAPIData.phone != "" {
                resPhoneLabel.text = restaurantAPIData.phone
            } else {
                resPhoneLabel.text = "번호 정보 없음"
            }
            
            if restaurantAPIData.roadAddress != "" {
                resAddressLabel.text = restaurantAPIData.roadAddress
            } else if restaurantAPIData.address != "" {
                resAddressLabel.text = restaurantAPIData.address
            } else {
                resAddressLabel.text = "주소 정보 없음"
            }
                
                
            if restaurantAPIData.placeURL != "" {
                resURLButton.setTitle(restaurantAPIData.placeURL, for: .normal)
            } else {
                resURLButton.setTitle("등록된 URL 정보가 없습니다", for: .normal)
            }
                
            addResButton.setTitle("SAVE", for: .normal)
            
            // 이미지 세팅
            // cell 이미지 처리
            // 13개
            if let resGroup = restaurantAPIData.group {
                switch resGroup {
                case let groupString where groupString.contains("한식"):
                    resImageView.image = RestaurantImages.korean
                case let groupString where groupString.contains("치킨"):
                    resImageView.image = RestaurantImages.chicken
                case let groupString where groupString.contains("제과"):
                    resImageView.image = RestaurantImages.bakery
                case let groupString where groupString.contains("디저트카페"):
                    resImageView.image = RestaurantImages.dessertCafe
                case let groupString where groupString.contains("간식"):
                    resImageView.image = RestaurantImages.dessertCafe
                case let groupString where groupString.contains("카페"):
                    resImageView.image = RestaurantImages.cafe
                case let groupString where groupString.contains("일식"):
                    resImageView.image = RestaurantImages.japanese
                case let groupString where groupString.contains("햄버거"):
                    resImageView.image = RestaurantImages.hamburger
                case let groupString where groupString.contains("양식"):
                    resImageView.image = RestaurantImages.europe
                case let groupString where groupString.contains("인도음식"):
                    resImageView.image = RestaurantImages.indian
                case let groupString where groupString.contains("중식"):
                    resImageView.image = RestaurantImages.chinese
                case let groupString where groupString.contains("아시아음식"):
                    resImageView.image = RestaurantImages.asian
                case let groupString where groupString.contains("술집"):
                    resImageView.image = RestaurantImages.alcohol
                default:
                    resImageView.image = RestaurantImages.restaurant
                }
            } else {
                // 그룹이 설정되지 않은 경우
                resImageView.image = RestaurantImages.restaurant
            }
            
            // 초기 세팅
            var addressInfo: String = ""
            if restaurantAPIData.roadAddress != "" {
                // addressInfo = restaurantAPIData.roadAddress!.components(separatedBy: " ").first!
                let addressInfos = restaurantAPIData.roadAddress!.components(separatedBy: " ")

                // 두 번째 단어를 가져오기
                if addressInfos.count >= 2 {
                    addressInfo = addressInfos[1]
                } else {
                    addressInfo = addressInfos[0]
                }
            } else if restaurantAPIData.address != "" {
                // addressInfo = restaurantAPIData.address!.components(separatedBy: " ").first!
                let addressInfos = restaurantAPIData.address!.components(separatedBy: " ")

                // 두 번째 단어를 가져오기
                if addressInfos.count >= 2 {
                    addressInfo = addressInfos[1]
                } else {
                    addressInfo = addressInfos[0]
                }
            } else {
                addressInfo = "정보 없음"
            }
            
            var groupInfo: String = ""
            if restaurantAPIData.group != "" {
                groupInfo = restaurantAPIData.group!.components(separatedBy: " ").last!
            } else {
                groupInfo = "정보 없음"
            }
            
            hashTagNameArray = ["위치", "종류"]
            hashTagTextArray = [addressInfo, groupInfo]

            categoryCnt = 2
            tableView.reloadData()
        }
    }
    
    // 마지막 Cell 삭제
    func deleteCell() {
        categoryCnt -= 1
        tableView.deleteRows(at: [IndexPath(row: categoryCnt, section: 0)], with: .fade)
    }
    
    func addHashTag() {
        hashTagNameArray.append("선택해주세요")
        hashTagTextArray.append("선택해주세요")
        tableView.reloadData()
    }
    
    func deleteHashTag() {
        hashTagNameArray.removeLast()
        hashTagTextArray.removeLast()
        tableView.reloadData()
    }
    
    @objc func resURLButtonTapped() {
        viewModel.goWebPage(url: resURLButton.currentTitle ?? "", fromVC: self)
    }
    
    @objc func touchUpImageView() {
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
                
        present(self.imagePicker, animated: true)
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
        
        // cell에 정보 할당
        cell.nameDropLabel.text = hashTagNameArray[indexPath.row]
        cell.textDropLabel.text = hashTagTextArray[indexPath.row]
        
        // textDropDown 데이터 할당
        cell.setCatTextData(item: hashTagNameArray[indexPath.row])
        
        // 해시태그 변경 시 변경값과 indexPath.row를 클로저로 전달받음
        cell.hashTagNameChanged = { hashTagName, indexRow in
            self.hashTagNameArray[indexRow] = hashTagName
            self.hashTagTextArray[indexRow] = "선택해주세요"
            
            // 인포 메시지 업데이트
            self.infoLabel.text = ""
        }
        
        cell.hashTagTextChanged = { hashTagText, indexRow in
            self.hashTagTextArray[indexRow] = hashTagText
            
            // 인포 메시지 업데이트
            self.infoLabel.text = ""
        }
        
        // 길게 눌러서 삭제 기능 추가
        // Long Press Gesture Recognizer 생성
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        
        // Long Press Gesture의 속성 설정 (옵션에 따라 조절 가능)
        longPressGesture.minimumPressDuration = 0.5 // 최소 press 시간 설정
        longPressGesture.allowableMovement = 10 // 허용 가능한 이동 거리 설정
        
        // Gesture Recognizer를 셀에 추가
        cell.addGestureRecognizer(longPressGesture)
        
        // 셀 위치를 파악할 변수
        cell.indexPathNum = indexPath.row
        
        return cell
    }
    
    // 길게 눌러서 삭제 기능 추가
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            // 카테고리가 한개일 때 삭제 불가 얼럿
            if categoryCnt == 1 {
                // 인포 메시지 업데이트
                infoLabel.text = "1개 이상의 해시태그를 설정해야 합니다"
            } else {
                // 카테고리가 한개 이상일 때 뷰 모델에서 삭제 알럿 실행
                viewModel.tableViewCellLongPressed(fromVC: self) { delete in
                    if delete {
                        // gestureRecognizer의 view 속성을 통해 셀에 접근
                        guard let cell = gestureRecognizer.view as? RestaurantTableViewCell else { return }
                        // 셀에서 indexPath 가져오기
                        let indexPath = cell.indexPathNum
                        
                        self.categoryCnt -= 1
                        
                        // 해당 해시태그 삭제
                        self.hashTagNameArray.remove(at: indexPath)
                        self.hashTagTextArray.remove(at: indexPath)
                        
                        self.tableView.reloadData()
                    } else {
                        return
                    }
                }
            }
        }
    }
}

extension RestaurantViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.resImageView.image = image
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

extension RestaurantViewController: UINavigationControllerDelegate {
    
}
