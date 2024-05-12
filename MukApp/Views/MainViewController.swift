//
//  addViewController.swift
//  MukApp
//
//  Created by Kang on 10/21/23.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - Main뷰 모델
    let viewModel: MainViewModel
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Interface
    // 메인 레이블 (mainLabel)
    private var mainLabel: UILabel = {
        let label = UILabel()
        
        // 텍스트 설정
        label.text = "# 뭐 먹지?"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 메뉴 버튼(menuButton)
    private var menuButton: UIButton = {
        let button = UIButton()
        button.setTitle("룰렛 돌리기", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = MyColor.themeColor
        button.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // categoryTextLabel
    var categoryTextLabel: UILabel = {
        let label = UILabel()
        
        // 텍스트 설정
        label.text = "저장한 맛집 개"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 테이블 뷰
    private let tableView = UITableView()
    
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
        button.backgroundColor = MyColor.disableColor
        button.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var categoryCnt: Int = 0
    private var isLoaded = false
    
    // 해시태그를 저장할 함수
    var hashTagNameArray: [String] = []
    var hashTagTextArray: [String] = []
    var hashImageArray: [UIImage] = []
    lazy var nextNameArray: [String] = viewModel.getCatNameToMain()
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMain()
    }
    
    // MARK: - viewWillApeear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        if isLoaded {
            resetHashTag()
        }
        
        isLoaded = true
    }
    
    // MARK: - viewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
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
        
        // menuButton 둥글게 설정
        menuButton.layer.cornerRadius = 20
        menuButton.clipsToBounds = true
        
        // menuButton 그림자 추가
        menuButton.layer.shadowColor = UIColor.black.cgColor
        menuButton.layer.masksToBounds = false
        menuButton.layer.shadowOffset = CGSize(width: 1, height: 4)
        menuButton.layer.shadowRadius = 5
        menuButton.layer.shadowOpacity = 0.3
    }
    
    // MARK: - SetUp
    // 셋업 - 메인
    func setMain() {
        
        view.backgroundColor = .white
        
        setAddView()
        setTableView()
        setAutoLayout()
        setCategoryTextLabel()
    }
    
    func setCategoryTextLabel() {
        
        let resNum = getResListNum()
        
        if resNum != 0 {
            categoryTextLabel.text = "저장한 맛집: \(resNum)개"
        } else {
            menuButton.backgroundColor = MyColor.disableColor
            categoryTextLabel.text = "맛집을 추가하셔야 룰렛을 돌릴 수 있습니다."
        }
    }
    
    // 셋업 - 애드뷰
    func setAddView() {
        view.addSubview(mainLabel)
        view.addSubview(menuButton)
        view.addSubview(categoryTextLabel)
        view.addSubview(tableView)
        view.addSubview(plusButton)
        view.addSubview(minusButton)
    }
    
    // 셋업 - 테이블 뷰
    func setTableView() {
        // 델리게이트 패턴, 데이터 처리 설정
        tableView.dataSource = self
        tableView.delegate = self
        
        // 셀의 높이 설정
        tableView.rowHeight = CommonCGSize.hashTagTableHeight
        tableView.separatorStyle = .none
        
        // 셀 등록
        tableView.register(MainViewControllerTableViewCell.self, forCellReuseIdentifier: "MainViewControllerTableViewCell")
    }
    
    // MARK: - AutoLayout
    func setAutoLayout() {
        
        // mainLabel 오토 레이아웃
        NSLayoutConstraint.activate([
            mainLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            mainLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            mainLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            
            mainLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        // menuButton 오토 레이아웃
        NSLayoutConstraint.activate([
            menuButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 80),
            menuButton.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 40),
            menuButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -80),
            
            menuButton.heightAnchor.constraint(equalToConstant: CommonCGSize.buttonHeight)
        ])
        
        // categoryTextLabel 오토 레이아웃
        NSLayoutConstraint.activate([
            categoryTextLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            categoryTextLabel.topAnchor.constraint(equalTo: menuButton.bottomAnchor, constant: 40),
            categoryTextLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            
            categoryTextLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        // tableView 오토 레이아웃
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            tableView.topAnchor.constraint(equalTo: categoryTextLabel.bottomAnchor, constant: 5),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40)
        ])
        
        // plusButton, minusButton 오토 레이아웃
        NSLayoutConstraint.activate([
            // plusButton
            plusButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            plusButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            plusButton.heightAnchor.constraint(equalToConstant: 40),
            plusButton.widthAnchor.constraint(equalToConstant: 40),
            
            // minusButton
            minusButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            minusButton.bottomAnchor.constraint(equalTo: plusButton.topAnchor, constant: -10),
            minusButton.heightAnchor.constraint(equalToConstant: 40),
            minusButton.widthAnchor.constraint(equalToConstant: 40),
            
            
        ])
        
    }
    
    // MARK: - Function
    @objc func menuButtonTapped() {
        // 회색이 아니면!!!
        if menuButton.backgroundColor != MyColor.disableColor {
            
            // 마지막 텍스트가 "선택해주세요"면 마지막 배열 삭제한 값 전달
            var modHashTagTextArray: [String] = []
            if hashTagTextArray.last == "선택해주세요" {
                modHashTagTextArray = self.hashTagTextArray.dropLast()
            } else {
                modHashTagTextArray = self.hashTagTextArray
            }
            
            viewModel.handleRouletteTapped(fromCurrentVC: self, selHashTagText: modHashTagTextArray, animated: true)
        }
        // 삭제한 데이터에서 해당되는 식당이 없으면 -> 해당되는 식당이 없습니다.
    }
    
    // 플러스 버튼 눌림
    @objc func plusButtonTapped() {
        // catText가 결정되었을 때 조건
        if hashTagTextArray.last != "선택해주세요" {

            categoryCnt += 1
            
            // 다음 Hash Name Array 설정
            getNextHashName(hashTagNameArray: hashTagNameArray, hashTagTextArray: hashTagTextArray)
            
            // 셀 추가 함수
            addHashTag()
            
            // 버튼 이미지 설정
            hashImageArray = hashImageArray.enumerated().map { (index, element) in
                return index == hashImageArray.count - 1 ? MyImage.arrowDown : MyImage.lock
            }
            
            // + 버튼 색상 설정
            // setPlusButtonTappedColor()
            
            // + 버튼 회색
            plusButton.backgroundColor = MyColor.disableColor
            // - 버튼 흰색
            minusButton.backgroundColor = .white
            
            // hashText가 결정되지 않았을 때 바로 리턴(터치 불가)
        } else {
            
            // ***(Need To Add)
            // 안내 텍스트 넣어주기
            
            return
        }
    }
    
    // 마이너스 버튼 눌림
    @objc func minusButtonTapped() {
        // categoryCnt가 1이면 진행 X
        if categoryCnt == 0 {
            return
            
        // categoryCnt가 1이 아니면 진행
        } else {
            // Cell 삭제
            categoryCnt -= 1
            deleteHashTag()
            
            // 다음 Hash Name Array 설정
            // Array에서 마지막 값을 뺀 배열
            let hashTagNameArray = Array(hashTagNameArray.dropLast())
            let hashTagTextArray = Array(hashTagTextArray.dropLast())
            getNextHashName(hashTagNameArray: hashTagNameArray, hashTagTextArray: hashTagTextArray)
            
            plusButton.backgroundColor = .white
            
            // 예상 맛집 수 구하기
            let resListNum = getResListNum()
            categoryTextLabel.text = "해당되는 맛집: \(resListNum)개"
            // 룰렛 색상 설정
            setRouletteColor(resListNum: resListNum)
            
            // +버튼 동작 가능
            self.plusButton.isUserInteractionEnabled = true
            
            // 컬러 설정
            if categoryCnt == 0 {
                minusButton.backgroundColor = MyColor.disableColor
                setCategoryTextLabel()
            }
        }
    }
    
    // 룰렛 색상 변경하기
    func setRouletteColor(resListNum: Int) {
        if resListNum > 0 {
            menuButton.backgroundColor = MyColor.themeColor
        } else {
            menuButton.backgroundColor = MyColor.disableColor
        }
    }
    
    // 화면 전환할 때 해시태그 리셋
    func resetHashTag() {
        // 카테고리 1개 남기고 삭제
        categoryCnt = 0
        
        // 리셋할 변수들
        hashTagNameArray = []
        hashTagTextArray = []
        hashImageArray = []
        nextNameArray = viewModel.getCatNameToMain()
        
        tableView.reloadData()
        
        // UI 변경
        // 버튼 그레이로
        menuButton.backgroundColor = MyColor.themeColor
        // +, - 색깔 불가능
        plusButton.backgroundColor = .white
        minusButton.backgroundColor = MyColor.disableColor
        
        // +버튼 동작은 가능 ??
        self.plusButton.isUserInteractionEnabled = true
        
        // 레이블 초기화
        setCategoryTextLabel()
    }
    
    private func setCatTextLabel(resListNum: Int) {
        categoryTextLabel.text = "해당되는 맛집: \(resListNum)개"
    }
    
    // 해시태그 추가
    func addHashTag() {
        hashTagNameArray.append("선택해주세요")
        hashTagTextArray.append("선택해주세요")
        hashImageArray.append(MyImage.arrowDown)
        tableView.reloadData()
    }
    
    // 해시태그 삭제
    func deleteHashTag() {
        hashTagNameArray.removeLast()
        hashTagTextArray.removeLast()
        hashImageArray.removeLast()
        
        if categoryCnt == 0 {
            hashImageArray = []
        } else {
            hashImageArray[hashImageArray.count - 1] = MyImage.arrowDown
        }
        
        tableView.reloadData()
    }
    
    // 다음 HashName 가져오기
    func getNextHashName(hashTagNameArray: [String], hashTagTextArray: [String]) {
        self.nextNameArray = self.viewModel.getNextCatNameArray(selHashTagName: hashTagNameArray, selHashTagText: hashTagTextArray)
    }
    
    // 해당하는 식당 수 찾기
    func getResListNum() -> Int {
        var modHashTagTextArray: [String] = []
        
        // "선택해주세요" 삭제한 값 전달
        if hashTagTextArray.last == "선택해주세요" {
            modHashTagTextArray = self.hashTagTextArray.dropLast()
        } else {
            modHashTagTextArray = self.hashTagTextArray
        }
        
        let resListNum = viewModel.getTargetRestaurant(selHashTagText: modHashTagTextArray).count
        categoryTextLabel.text = "해당되는 맛집: \(resListNum)개"
        
        
        // 테스팅
        let testRes = viewModel.getTargetRestaurant(selHashTagText: modHashTagTextArray)
        return resListNum
    }
}

// MARK: - Extension
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryCnt
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainViewControllerTableViewCell", for: indexPath) as! MainViewControllerTableViewCell
        cell.backgroundColor = .white
        cell.selectionStyle = .none
        
        // cell에 정보 할당
        cell.nameDropLabel.text = hashTagNameArray[indexPath.row]
        cell.textDropLabel.text = hashTagTextArray[indexPath.row]
        cell.nameDropImageView.image = hashImageArray[indexPath.row]
        cell.textDropImageView.image = hashImageArray[indexPath.row]
        cell.nameDropDown.dataSource = nextNameArray
        
        // textDropDown 데이터 할당
        cell.setCatTextData(item: hashTagNameArray[indexPath.row])
        
        // lock이 아닌 셀만 터치 가능
        if hashImageArray[indexPath.row] == MyImage.lock {
            cell.isUserInteractionEnabled = false
        } else {
            cell.isUserInteractionEnabled = true
        }
        
        // 해시태그 변경 시 변경값과 indexPath.row를 클로저로 전달받음
        cell.hashTagNameChanged = { hashTagName, indexRow in
            self.hashTagNameArray[indexRow] = hashTagName
            self.hashTagTextArray[indexRow] = "선택해주세요"
            cell.textDropLabel.text = self.hashTagTextArray[indexPath.row]
            self.plusButton.backgroundColor = MyColor.disableColor
            self.menuButton.backgroundColor = MyColor.disableColor
        }
        
        // 해시태그 텍스트 변경 시
        cell.hashTagTextChanged = { hashTagText, indexRow in
            self.hashTagTextArray[indexRow] = hashTagText
            
            // 해당하는 맛집 수 구하기
            let resListNum = self.getResListNum()
            
            // 룰렛 색상 설정하기
            self.setRouletteColor(resListNum: resListNum)
            
            // 후보 식당 텍스트 바꾸기
            self.setCatTextLabel(resListNum: resListNum)
            
            // +버튼 색 설정
            // 다음 누를게 없어도 불가하도록

            
            // 후보 식당이 0일때 +버튼 사용 불가
            if resListNum == 0 {
                // or 전체 식당 로직을 넣어도 좋을듯
                // self.plusButton.isUserInteractionEnabled = false
                self.plusButton.setTitleColor(MyColor.disableColor, for: .normal)
            } else {
                // +버튼 색상 설정하기?
                self.plusButton.isUserInteractionEnabled = true
                self.plusButton.backgroundColor = .white
            }
        }
        return cell
    }
}
