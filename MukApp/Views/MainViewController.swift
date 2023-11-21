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
        label.text = "최소 1개의 해시태그를 정해주세요"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 테이블 뷰
    private let tableView = UITableView()
    
    // resListLabel
    var resListLabel: UILabel = {
        let label = UILabel()
        
        // 텍스트 설정
        label.text = "해당되는 맛집: 3개"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMain()
    }
    
    // MARK: - viewWillApeear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
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
        view.addSubview(resListLabel)
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
            tableView.bottomAnchor.constraint(equalTo: resListLabel.topAnchor, constant: -20)
        ])
        
        // resListLabel 오토 레이아웃
        NSLayoutConstraint.activate([
            resListLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            resListLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            resListLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
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
        viewModel.handleRouletteTapped(fromCurrentVC: self, animated: true)
    }
    
    // 플러스 버튼 눌림
    @objc func plusButtonTapped() {
        // 뷰 모델의 handleMainPlusButtonTapped이 True 일 때
        if viewModel.handleMainPlusButtonTapped() {
            // 셀 추가 함수
            addNewCell()
            
            // Cell에 접근해서 다음 Cat Name Array 설정
            setNextCatName()
        }
        // 뷰 모델의 handleMainPlusButtonTapped이 False 일 때 -> 리턴
        else {
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
            viewModel.handleMainMinusButtonTapped()
            
            // Cell 삭제
            deleteCell()
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
        let cell = tableView.cellForRow(at: IndexPath(row: categoryCnt - 1, section: 0)) as! MainViewControllerTableViewCell
        
        cell.nameDropLabel.text = "선택해주세요"
        cell.textDropLabel.text = "선택해주세요"
    }
    
    // 마지막 Cell 삭제
    func deleteCell() {
        categoryCnt -= 1
        print("categoryCnt: \(categoryCnt)")
        tableView.deleteRows(at: [IndexPath(row: categoryCnt, section: 0)], with: .fade)
    }
    
    func setNextCatName() {
        // 셀 가져오기
        let cell = tableView.cellForRow(at: IndexPath(row: categoryCnt - 1, section: 0)) as! MainViewControllerTableViewCell
        
        // 싱글톤 데이터에 데이터 세팅
        viewModel.setNextCatNameArray()
        
        // 셀에 데이터 할당
        cell.nameDropDown.dataSource = viewModel.getNextCatNameArray()
    }
}

// MARK: - Extension
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("dk")
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
        return cell
    }
}
