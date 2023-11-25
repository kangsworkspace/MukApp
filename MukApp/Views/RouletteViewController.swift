//
//  RouletteViewController.swift
//  MukApp
//
//  Created by Kang on 11/15/23.
//

import UIKit

class RouletteViewController: UIViewController {
    
    let viewModel: MainViewModel
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var targetResDataList: [RestaurantData]?
    
    var targetRes: RestaurantData?
    
    // MARK: - Interface
    // 피커뷰 (룰렛)
    let pickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMain()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getTargetRes()
        rouletteTrigger()
    }
        
    func setMain() {
        // 백그라운드 색상 설정
        view.backgroundColor = .white
        
        setAddView()
        setAutoLayout()
        setPickerView()
    }
    
    func setAddView() {
        view.addSubview(pickerView)
    }
    
    // 오토 레이아웃 설정
    func setAutoLayout() {
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pickerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            pickerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            pickerView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 0),
            pickerView.heightAnchor.constraint(equalToConstant: 260)
        ])
    }
    
    func setPickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
        
        // 피커뷰 터치 불가
        pickerView.isUserInteractionEnabled = false
    }
    
    // 트리거
    func rouletteTrigger() {
        // 0.25초마다 scrollRandomly 실행하는 타이머 생성
        let timer = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(scrollRandomly), userInfo: nil, repeats: true)
        
        // 메인 큐에서 실행 timer 실행 (2초 후 타이머 동작 멈춤)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(2*NSEC_PER_SEC))/Double(NSEC_PER_SEC)) {
            // 타이머 동작 멈춤
            timer.invalidate()
            
            // 타겟 레스토랑으로 스크롤 하기
            self.scrollTargetRes()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.viewModel.goResultViewController(fromCurrentVC: self, targetRes: self.targetRes!, animated: true)
            }
        }
    }
    
    // 랜덤 스크롤
    @objc func scrollRandomly() {
        let row: Int = Int.random(in: 0..<99)
        self.pickerView.selectRow(row, inComponent: 0, animated: true)
    }
    
    // 타켓 레스토랑 스크롤
    func scrollTargetRes() {
        self.pickerView.selectRow(49, inComponent: 0, animated: true)
    }
    
    func getTargetRes() {
        targetRes = targetResDataList?.randomElement()
    }
}

// MARK: - Extension
extension RouletteViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        scrollTargetRes()
    }
}

extension RouletteViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 100
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let exampleRes: [String] = ["배가 안고파져버렸다", "차타고 4시간 맛집", "커피만 맛없는 카페", "크루아상 전문 한정식집", "닭개장만 파는 치킨집", "생선없는 초밥집", "깍두기 없는 국밥집", "배가 불러지는 마법의 알약", "맛집보단 정신적 배부름", "냉동실에 있는 닭가슴살", "드레싱 없는 샐러드", "마라탕 먹지 마라탕", "팅!팅! 탱!탱! 후라이팬", "탕! 수육", "탕 수!육", "탕! 후루", "딸기가 좋아, 딸기가 좋아",  "단백질 쉐이크", "소금없는 소금빵", "빵 없는 소금빵", "딩 동 냉-동", "올 때 메로나", "아이스 핫초코"]
        
        var randomArray: [String] = (1...100).map { _ in exampleRes.randomElement() ?? "존재하지 않는 맛집" }
        
        randomArray[49] = targetRes?.placeName ?? "에러 - 존재하지 않는 맛집"
        
        return randomArray[row]
    }
}

