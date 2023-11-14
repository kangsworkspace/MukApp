//
//  CategorySetViewViewController.swift
//  MukApp
//
//  Created by Kang on 11/7/23.
//

import UIKit

class CategorySetViewController: UIViewController {
    
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
        label.text = "저장한 맛집 목록"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 맛집 추가 버튼(addResButtonTapped)
    private var addResButton: UIButton = {
        let button = UIButton()
        button.setTitle("코어 데이터 테스트", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .lightGray
        button.addTarget(self, action: #selector(testButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // 콜렉션 뷰 선언
    let collectionView: UICollectionView = {
        // 컬렉션 뷰의 레이아웃을 담당하는 객체(필수)
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.scrollDirection = .vertical
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setMain()
    }
    
    // MARK: - Setup
    func setMain() {
        // 백그라운드 컬러 설정
        view.backgroundColor = .white
        
        setAddView()
        setAutoLayout()
        setCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // menuButton 둥글게 설정
        addResButton.layer.cornerRadius = 20
        addResButton.clipsToBounds = true
        addResButton.layer.masksToBounds = false
        addResButton.layer.shadowOffset = CGSize(width: 1, height: 4)
        addResButton.layer.shadowRadius = 5
        addResButton.layer.shadowOpacity = 0.3
    }
    
    // 셋업 - 애드 뷰
    func setAddView() {
        view.addSubview(mainLabel)
        view.addSubview(addResButton)
        view.addSubview(collectionView)
    }
    
    
    // MARK: - 오토 레이아웃
    func setAutoLayout() {
        // mainLabel 오토 레이아웃
        NSLayoutConstraint.activate([
            mainLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            mainLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 45),
            mainLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            
            mainLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        // addResButton 오토 레이아웃
        NSLayoutConstraint.activate([
            addResButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 80),
            addResButton.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 10),
            addResButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -80),
            
            addResButton.heightAnchor.constraint(equalToConstant: 46)
        ])
        
        // collectionView 오토 레이아웃
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            collectionView.topAnchor.constraint(equalTo: addResButton.bottomAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60)
        ])
    }
    
    func setCollectionView() {
        collectionView.register(CategorySetCollectionViewCell.self, forCellWithReuseIdentifier: "CategorySetCollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    // MARK: - Function
    @objc func testButtonTapped() {
        print("테스트 버튼 연결")
        viewModel.handeTestingCoreData()
    }
}

extension CategorySetViewController: UICollectionViewDelegateFlowLayout {
    // 셀의 크기 정하기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 원하는 아이템 크기를 CGSize 형태로 반환
        let cellWidth = (collectionView.frame.width - 30) / 3
        let cellHeight = cellWidth + 20
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    // 셀 사이의 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // 셀과 뷰의 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // viewModel.handleResCellTapped(fromCurrentVC: self, animated: true)
    }
}


extension CategorySetViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategorySetCollectionViewCell", for: indexPath) as! CategorySetCollectionViewCell
        cell.backgroundColor = .lightGray
        return cell
    }
}

