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
        button.backgroundColor = MyColor.disableColor
        button.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // categoryTextLabel
    var categoryTextLabel: UILabel = {
        let label = UILabel()
        
        // 텍스트 설정
        label.text = "등록한 전체 맛집 ???개"
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
        button.backgroundColor = MyColor.disableColor
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
    
    // 카테고리 설정 카운트
    private var categoryCnt: Int = 1
    private var isLoaded = false
    
    // 해시태그를 저장할 함수
    var hashTagNameArray: [String] = ["선택해주세요"]
    var hashTagTextArray: [String] = ["선택해주세요"]
    var hashImageArray: [UIImage] = [MyImage.arrowDown]
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
        viewModel.handleRouletteTapped(fromCurrentVC: self, selHashTagText: hashTagTextArray, animated: true)
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
            setPlusButtonTappedColor()
        } else {
            return
        }
    }
    
    // 마이너스 버튼 눌림
    @objc func minusButtonTapped() {
        // categoryCnt가 1이면 진행 X
        if categoryCnt == 1 {
            return
            // categoryCnt가 1이 아니면 진행
        } else {
            // 싱글톤 데이터 삭제
            // viewModel.handleMainMinusButtonTapped()
            
            // Cell 삭제
            categoryCnt -= 1
            
            // deleteCell()
            deleteHashTag()
            
            // 다음 Hash Name Array 설정
            // Array에서 마지막 값을 뺀 배열
            let hashTagNameArray = Array(hashTagNameArray.dropLast())
            let hashTagTextArray = Array(hashTagTextArray.dropLast())
            getNextHashName(hashTagNameArray: hashTagNameArray, hashTagTextArray: hashTagTextArray)
            
            // 버튼 컬러 설정
            setMinusButtonTappedColor()
            
            // +버튼 동작 가능
            self.plusButton.isUserInteractionEnabled = true
        }
    }
    
    // 새로운 Cell 생성
    //    func addNewCell() {
    //        // 카테고리 카운트 + 1
    //        categoryCnt += 1
    //        print("categoryCnt: \(categoryCnt)")
    //
    //        // 테이블 뷰 마지막 순서에 셀 생성
    //        tableView.insertRows(at: [IndexPath(row: categoryCnt - 1, section: 0)], with: .fade)
    //    }
    
    // 마지막 Cell 삭제
    //    func deleteCell() {
    //        categoryCnt -= 1
    //        print("categoryCnt: \(categoryCnt)")
    //        tableView.deleteR ows(at: [IndexPath(row: categoryCnt, section: 0)], with: .fade)
    //    }
    
    // 다음 Cell의 CategoryName 설정하기
    //    func getNextCatName(selHashTagText: [String]) {
    //        // viewModel.getNextCatNameArray(selHashTagText: selHashTagText)
    //    }
    
    // 룰렛 색상 변경하기
    func setRouletteColor(resListNum: Int) {
        if resListNum > 0 {
            menuButton.backgroundColor = MyColor.themeColor
        } else {
            menuButton.backgroundColor = MyColor.disableColor
        }
    }
    
    // + 버튼의 색 하얗게 하기
    func setPlusButtonColorWhite() {
        plusButton.backgroundColor = .white
    }
    
    // + 버튼이 눌렸을 때 관련 색상 변경
    func setPlusButtonTappedColor() {
        // + 버튼 회색
        plusButton.backgroundColor = MyColor.disableColor
        // - 버튼 흰색
        minusButton.backgroundColor = .white
    }
    
    func setMinusButtonTappedColor() {
        if categoryCnt == 1 {
            minusButton.backgroundColor = MyColor.disableColor
        }
        
        plusButton.backgroundColor = .white
    }
    
    func resetHashTag() {
        // 카테고리 전체 삭제
        for _ in 1...categoryCnt {
            // deleteCell()
        }
        
        // 카테고리 추가
        // addNewCell()
        
        // 싱글톤 데이터 처리 (후보식당 관련)
        viewModel.resetHashTagData()
        
        // 카테고리 데이터 설정
        let cell = tableView.cellForRow(at: IndexPath(row: categoryCnt - 1, section: 0)) as! MainViewControllerTableViewCell
        cell.setDropDownData()
        
        cell.textDropLabel.text = "선택해주세요"
        
        // UI 변경
        // 버튼 그레이로
        menuButton.backgroundColor = MyColor.disableColor
        // +, - 불가능
        plusButton.setTitleColor(MyColor.disableColor, for: .normal)
        minusButton.setTitleColor(MyColor.disableColor, for: .normal)
        
        // +버튼 동작은 가능
        self.plusButton.isUserInteractionEnabled = true
        
        // 레이블 초기화
        categoryTextLabel.text = "해당되는 맛집: \(0)개"
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
        
        print("hashTagNameArray: \(hashTagNameArray)")
        print("hashTagTextArray: \(hashTagTextArray)")
    }
    
    // 해시태그 삭제
    func deleteHashTag() {
        hashTagNameArray.removeLast()
        hashTagTextArray.removeLast()
        hashImageArray.removeLast()
        hashImageArray[hashImageArray.count - 1] = MyImage.arrowDown
        tableView.reloadData()
    }
    
    // MARK: - 클로저
//    var getNextHashName: () -> () = {}
    
    func getNextHashName(hashTagNameArray: [String], hashTagTextArray: [String]) {
        self.nextNameArray = self.viewModel.getNextCatNameArray(selHashTagName: self.hashTagNameArray, selHashTagText: self.hashTagTextArray)
        print("nextNameArray: \(self.nextNameArray))")
        print("+ 버튼 동작, getNextHash함수 동작")
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
        
        // + 버튼 동작 -> getNextHash함수로 다음 데이터 세팅
//        getNextHashName = {
//            self.nextNameArray = self.viewModel.getNextCatNameArray(selHashTagName: self.hashTagNameArray, selHashTagText: self.hashTagTextArray)
//            print("nextNameArray: \(self.nextNameArray))")
//            print("+ 버튼 동작, getNextHash함수 동작")
//        }
        
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
        }
        
        // 해시태그 텍스트 변경 시
        cell.hashTagTextChanged = { hashTagText, indexRow in
            self.hashTagTextArray[indexRow] = hashTagText
            print("hashTagNameArray: \(self.hashTagNameArray)")
            print("hashTagTextArray: \(self.hashTagTextArray)")
            
            var resListNum = 0
            
            // 예상 후보 식당 갯수 찾기
            self.viewModel.handleCatTextSelAction(selHashTagText: self.hashTagTextArray) { resNum in
                resListNum = resNum
            }
            
            // 룰렛 색상 설정하기
            self.setRouletteColor(resListNum: resListNum)
            
            // 후보 식당 텍스트 바꾸기
            self.setCatTextLabel(resListNum: resListNum)
            
            // +버튼 색 설정
            self.plusButton.backgroundColor = .white
            
            //            // 후보 식당이 0일때 +버튼 사용 불가
            //            if resListNum == 0 {
            //                // or 전체 식당 로직을 넣어도 좋을듯
            //                self.plusButton.isUserInteractionEnabled = false
            //                self.plusButton.setTitleColor(MyColor.disableColor, for: .normal)
            //                print("후보식당 x")
            //            } else {
            //                // +버튼 색상 설정하기?
            //                self.plusButton.isUserInteractionEnabled = true
            //                self.setPlusButtonColorWhite()
            //            }
        }
        return cell
    }
}
