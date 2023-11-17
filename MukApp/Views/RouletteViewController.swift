//
//  RouletteViewController.swift
//  MukApp
//
//  Created by Kang on 11/15/23.
//

import UIKit

class RouletteViewController: UIViewController {
    
    // MARK: - Interface
    // 피커뷰 (룰렛)
    let pickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMain()
        setAddView()
        setAutoLayout()
        setPickerView()
        trigger()
    }
    
    override func viewDidLayoutSubviews() {
        // UIPickerView indicator 숨기기(hide indicator)
        // UIPickerView를 생성하게 되면 selectedRow부분이 회색 바탕으로 표시되거나, 구분선으로 표시가 되는데,
        // Custom 하기 위해서 이 부분을 숨기는 코드이다.
        // pickerView.subviews[index].isHidden = true
    }
    
    
    func setMain() {
        // 백그라운드 색상 설정
        view.backgroundColor = .white
    }
    
    func setAddView() {
        view.addSubview(pickerView)
    }
    
    func setAutoLayout() {
        
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pickerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            pickerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            pickerView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 0),
            pickerView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    func setPickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
        
        // 피커뷰 터치 불가
        pickerView.isUserInteractionEnabled = false
    }
    
    // 트리거
    func trigger() {
        let timer = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(scrollRandomly), userInfo: nil, repeats: true);
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(2*NSEC_PER_SEC))/Double(NSEC_PER_SEC)) {
            timer.invalidate()
            self.scrollRandomly()
        }
    }
    
    // 랜덤 스크롤
    @objc func scrollRandomly() {
        let row: Int = Int.random(in: 0..<100)
        self.pickerView.selectRow(row, inComponent: 0, animated: true)
    }
    
    var testArray: [String] = (1...100).map { String($0) }
}

// MARK: - Extension
extension RouletteViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
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
        return testArray[row]
    }
}

