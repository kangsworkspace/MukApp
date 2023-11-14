//
//  resAddTableViewCell.swift
//  MukApp
//
//  Created by Kang on 11/5/23.
//

import UIKit
import DropDown

class AddResTableViewCell: UITableViewCell {
    
    // MARK: - 뷰 모델
    let viewModel: MainViewModel
    
    // MARK: - DropDown
    // nameDropDown: 카테고리 이름
    var nameDropDown: DropDown = {
        let dropDown = DropDown()
        dropDown.dismissMode = .automatic // 팝업을 닫을 모드 설정
        return dropDown
    }()
    
    // textDropDown: 카테고리 내용
    var textDropDown: DropDown = {
        let dropDown = DropDown()
        dropDown.dismissMode = .automatic // 팝업을 닫을 모드 설정
        return dropDown
    }()
    
    // MARK: - Interface
    // nameDropDown UI: 카테고리 이름 UI
    var nameDropView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var nameDropLabel: UILabel = {
        let label = UILabel()
        label.text = "선택해주세요"
        label.font = UIFont.systemFont(ofSize: 12)
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var nameDropImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = UIColor.gray
        imageView.image = UIImage(systemName: "arrowtriangle.down.fill")
        imageView.backgroundColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var nameDropButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(nameDropButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // TextDropDown UI: 카테고리 내용 UI
    var textDropView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var textDropLabel: UILabel = {
        let label = UILabel()
        label.text = "선택해주세요"
        label.font = UIFont.systemFont(ofSize: 12)
        label.backgroundColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var textDropImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = UIColor.gray
        imageView.image = UIImage(systemName: "arrowtriangle.down.fill")
        imageView.backgroundColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var textDropButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(textDropButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    var dropDownStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.backgroundColor = .clear
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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
        
        // setData()
        setDropDown()
        setCatNameData()
        setAddView()
        setAutoLayout()
    }
    
    func setDropDown() {
        DropDown.appearance().textColor = UIColor.black // 아이템 텍스트 색상
        DropDown.appearance().selectedTextColor = UIColor.black // 선택된 아이템 텍스트 색상
        DropDown.appearance().backgroundColor = UIColor.white // 아이템 팝업 배경 색상
        DropDown.appearance().selectionBackgroundColor = UIColor.lightGray // 선택한 아이템 배경 색상
        DropDown.appearance().setupCornerRadius(8)
        
        // 드롭다운 표시되는 위치 설정
        nameDropDown.anchorView = nameDropButton
        textDropDown.anchorView = textDropButton
        nameDropDown.bottomOffset = CGPoint(x:0, y: 40)
        textDropDown.bottomOffset = CGPoint(x:0, y: 40)
        
        // nameDropDown 선택 시 이벤트 처리
        nameDropDown.selectionAction = { [weak self] (index, item) in
            self!.viewModel.handleCatSelAction(fromVC: (self?.window!.rootViewController!)!, item: item, category: "name") {item in
                self!.nameDropLabel.text = item
                self!.setCatTextData(item: item)
            }
        }
        
        // textDropDown 선택 시 이벤트 처리
        textDropDown.selectionAction = { [weak self] (index, item) in
            self!.viewModel.handleCatSelAction(fromVC: (self?.window!.rootViewController!)!, item: item, category: "text") {item in
                self!.textDropLabel.text = item
            }
        }
    }
    
    func setCatNameData() {
        nameDropDown.dataSource = viewModel.getCatNameFromCoreData()
        textDropDown.dataSource = []
    }
    
    func setCatTextData(item: String) {
        viewModel.changeNameSelAction(item: item, completion: { categoryTextArray in
            self.textDropDown.dataSource = categoryTextArray
        })
    }
    
    // 셋업 - 애드뷰
    func setAddView() {
        nameDropView.addSubview(nameDropLabel)
        nameDropView.addSubview(nameDropImageView)
        nameDropView.addSubview(nameDropButton)
        
        textDropView.addSubview(textDropLabel)
        textDropView.addSubview(textDropImageView)
        textDropView.addSubview(textDropButton)
        
        dropDownStackView.addArrangedSubview(nameDropView)
        dropDownStackView.addArrangedSubview(textDropView)
        
        self.addSubview(dropDownStackView)
    }
    
    // 셋업 - 오토 레이아웃
    func setAutoLayout() {
        
        // nameDropLabel, textDropLabel 오토 레이아웃
        NSLayoutConstraint.activate([
            // nameDropLabel
            nameDropLabel.leadingAnchor.constraint(equalTo: nameDropView.leadingAnchor, constant: 10),
            nameDropLabel.topAnchor.constraint(equalTo: nameDropView.topAnchor, constant: 10),
            nameDropLabel.bottomAnchor.constraint(equalTo: nameDropView.bottomAnchor, constant: -10),

            // textDropLabel
            textDropLabel.leadingAnchor.constraint(equalTo: textDropView.leadingAnchor, constant: 10),
            textDropLabel.topAnchor.constraint(equalTo: textDropView.topAnchor, constant: 10),
            textDropLabel.bottomAnchor.constraint(equalTo: textDropView.bottomAnchor, constant: -10)
        ])
        
        // nameDropImageView, textDropImageView 오토 레이아웃
        NSLayoutConstraint.activate([
            // nameDropImageView
            nameDropImageView.trailingAnchor.constraint(equalTo: nameDropView.trailingAnchor, constant: -10),
            nameDropImageView.centerYAnchor.constraint(equalTo: nameDropLabel.centerYAnchor, constant: 0),
            
            nameDropImageView.heightAnchor.constraint(equalToConstant: 16),
            nameDropImageView.widthAnchor.constraint(equalToConstant: 16),
                        
            // textDropImageView
            textDropImageView.trailingAnchor.constraint(equalTo: textDropView.trailingAnchor, constant: -10),
            textDropImageView.centerYAnchor.constraint(equalTo: textDropView.centerYAnchor, constant: 0),
            
            textDropImageView.heightAnchor.constraint(equalToConstant: 16),
            textDropImageView.widthAnchor.constraint(equalToConstant: 16),
        ])
        
        // nameDropButton, textDropButton 오토 레이아웃
        NSLayoutConstraint.activate([
            // nameDropButton
            nameDropButton.leadingAnchor.constraint(equalTo: nameDropView.leadingAnchor, constant: 0),
            nameDropButton.topAnchor.constraint(equalTo: nameDropView.topAnchor, constant: 0),
            nameDropButton.trailingAnchor.constraint(equalTo: nameDropView.trailingAnchor, constant: 0),
            nameDropButton.bottomAnchor.constraint(equalTo: nameDropView.bottomAnchor, constant: 0),
                        
            // textDropButton
            textDropButton.leadingAnchor.constraint(equalTo: textDropView.leadingAnchor, constant: 0),
            textDropButton.topAnchor.constraint(equalTo: textDropView.topAnchor, constant: 0),
            textDropButton.trailingAnchor.constraint(equalTo: textDropView.trailingAnchor, constant: 0),
            textDropButton.bottomAnchor.constraint(equalTo: textDropView.bottomAnchor, constant: 0)
        ])
 
        // dropDownStackView 오토 레이아웃
        NSLayoutConstraint.activate([
            dropDownStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            dropDownStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            dropDownStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0),
            dropDownStackView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    // MARK: - Function
    @objc func nameDropButtonTapped() {
        nameDropDown.show()
    }
    
    @objc func textDropButtonTapped() {
        textDropDown.show()
    }
}

// MARK: - Extension


