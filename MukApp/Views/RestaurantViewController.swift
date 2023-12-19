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
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
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
        
        setTitle()
        setHashTag()
        setAddView()
        setAutoLayout()
        setTableView()
    }
    
    func setTitle() {
        // 수정하는 경우
        if restaurantCoreData != nil {
            self.title = "수정"
        } else {
            self.title = "추가"
        }
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
                    print("restaurantCoreData 적용")
                }
            }
            // 저장된 데이터가 없는 경우(추가)
        } else {
            addHashTag()
        }
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
        
        // 구분선 없애기
        tableView.separatorStyle = .none
        
        // 셀의 높이 설정
        tableView.rowHeight = CommonCGSize.hashTagTableHeight
        
        // 셀 등록
        tableView.register(RestaurantTableViewCell.self, forCellReuseIdentifier: "RestaurantTableViewCell")
    }
    
    // MARK: - Function
    @objc func addResButtonTapped() {
        // 포함되면 안되는 문자열을 가진 경우 리턴
        if hashTagNameArray.contains("") || hashTagNameArray.contains("선택해주세요") || hashTagTextArray.contains("") || hashTagTextArray.contains("선택해주세요") {
            // 텍스트 안내문 추가해주기
            print("포함되면 안되는 문자열 포함")
            return
        }
        
        // 정보를 수정하는 경우
        else if let restaurantCoreData {
            // 코어 데이터에 정보 업데이트
            viewModel.handleUpdateResData(restaurantData: restaurantCoreData, catNameArray: hashTagNameArray, catTextArray: hashTagTextArray)
            // 루트 뷰로 돌아가기
            viewModel.goBackRootView(fromCurrentVC: self, animated: true)
        }
        
        // 맛집을 추가하는 경우
        else if let restaurantAPIData {
            // 코어 데이터에 정보 생성
            viewModel.addResToCoreData(restaurantData: restaurantAPIData, catNameArray: hashTagNameArray, catTextArray: hashTagTextArray)
            // 루트 뷰로 돌아가기
            viewModel.goBackRootView(fromCurrentVC: self, animated: true)
        }
    }
    
    @objc func plusButtonTapped() {
        // 카테고리 카운트 + 1
        categoryCnt += 1
        print("categoryCnt: \(categoryCnt)")
        
        // 해쉬태그 추가
        addHashTag()
    }
    
    @objc func minusButtonTapped() {
        if categoryCnt == 1 {
            return
        } else {
            // 카테고리 카운트 - 1
            categoryCnt -= 1
            print("categoryCnt: \(categoryCnt)")
            
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
    
    // 마지막 Cell 삭제
    func deleteCell() {
        categoryCnt -= 1
        print("categoryCnt: \(categoryCnt)")
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
            print("\(self.hashTagNameArray)")
        }
        
        cell.hashTagTextChanged = { hashTagText, indexRow in
            self.hashTagTextArray[indexRow] = hashTagText
            print("\(self.hashTagNameArray)")
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
                // viewModel.tableViewCellLongPressedError
                
                
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
