//
//  resAddTableViewCell.swift
//  MukApp
//
//  Created by Kang on 11/5/23.
//

import UIKit

class AddResTableViewCell: UITableViewCell {
    
    // MARK: - 뷰 모델
    let viewModel: MainViewModel
    
    
    
    
    // MARK: - Interface
    // 카테고리를 표시할 피커뷰
    lazy var pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = .white
        picker.isUserInteractionEnabled = true
        picker.delegate = self
        picker.dataSource = self
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    // MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.viewModel = MainViewModel(coreDataManager: CoreDataManager(), apiServie: APIService())
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        setMain()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setMain() {
        // pickerview가 터치 되도록 컨텐츠 뷰 뒤로 보내기
        sendSubviewToBack(contentView)
        
        setData()
        setAddView()
        setAutoLayout()
    }
    
    func setData() {
        viewModel.getDataFromCoreData()
    }
    
    // 셋업 - 애드뷰
    func setAddView() {
        self.addSubview(pickerView)
    }
    
    // 셋업 - 오토 레이아웃
    func setAutoLayout() {
        // pickerView
        NSLayoutConstraint.activate([
            pickerView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            pickerView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
            pickerView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            pickerView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        ])
    }
}

// MARK: - Extension
// 피커뷰 이벤트 처리
extension AddResTableViewCell: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // 카테고리 Name
        if component == 0 {
            viewModel.handleCategoryNamePickerView(fromVC: (self.window?.rootViewController!)!, row: row) {
                pickerView.reloadComponent(0)
                pickerView.reloadComponent(1)
            }
        }
        // 카테고리 Text
        else
        {
            
        }
    }
}

// 피커뷰 데이터 처리
extension AddResTableViewCell: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    // 표시할 피커뷰 셀의 갯수
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return viewModel.getCatNameArray().count
        } else {
            return viewModel.getCatTextArray().count
        }
    }
    
    // 표시할 피커뷰 셀의 내용
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return viewModel.getCatNameArray()[row]
        } else {
            return viewModel.getCatTextArray()[row]
        }
    }
    
}
