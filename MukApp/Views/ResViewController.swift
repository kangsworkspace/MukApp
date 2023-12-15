//
//  updateViewController.swift
//  MukApp
//
//  Created by Kang on 10/21/23.
//

import UIKit

class ResViewController: UIViewController {
    
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
        button.setTitle("맛집 추가", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = MyColor.themeColor
        button.addTarget(self, action: #selector(addResButtonTapped), for: .touchUpInside)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
        collectionView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - 셋업
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
        collectionView.register(ResCollectionViewCell.self, forCellWithReuseIdentifier: "ResCollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    // MARK: - Function
    @objc func addResButtonTapped() {
        viewModel.handleAddResButtonTapped(fromCurrentVC: self, animated: true)
    }
}

extension ResViewController: UICollectionViewDelegateFlowLayout {
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
    
    // 셀이 눌렸을 때
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 코어 데이터의 맛집 정보
        let resData = viewModel.getDataFromCoreData()
        // EditCell
        viewModel.goRestaurantController(resData: resData[indexPath.row], fromCurrentVC: self, animated: true)
    }
}


extension ResViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getDataFromCoreData().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ResCollectionViewCell", for: indexPath) as! ResCollectionViewCell
        cell.backgroundColor = .lightGray
        
        let resDataList = viewModel.getDataFromCoreData()
        
        cell.addressLabel.text = resDataList[indexPath.row].address
        cell.retaurantNameLabel.text = resDataList[indexPath.row].placeName
        
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
    
    // // 길게 눌러서 삭제 기능 추가
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            
            let resDataList = viewModel.getDataFromCoreData()
            // gestureRecognizer의 view 속성을 통해 셀에 접근
            guard let cell = gestureRecognizer.view as? ResCollectionViewCell else { return }
            // 셀에서 indexPath 가져오기
            let indexPath = cell.indexPathNum
            // 삭제할 식당
            let savedResData = resDataList[indexPath]
            print("삭제할 데이터: \(savedResData.placeName)")
            
            // 뷰 모델에서 삭제 로직 실행
            viewModel.collectionCellLongPressed(savedResData: savedResData, fromVC: self) {
                // 컬렉션 뷰 초기화
                self.collectionView.reloadData()
            }
        } else if gestureRecognizer.state == .ended {
            // Long Press가 끝났을 때 실행할 코드
            print("Long Press 종료")
        }
    }
}
