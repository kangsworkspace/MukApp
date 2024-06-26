//
//  resAddTableViewCell.swift
//  MukApp
//
//  Created by Kang on 11/5/23.
//

import UIKit
import DropDown

class MainViewControllerTableViewCell: UITableViewCell {
    
    // MARK: - 뷰 모델
    var viewModel: MainViewModel
    
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
    
    // DropDown 이미지 처리를 위한 변수
    var isNameDropShowed = false
    var isTextDropShowed = false
    
    // MARK: - Interface
    // nameDropDown UI: 카테고리 이름 UI
    var nameDropView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = CommonCGSize.dropDownViewCornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var nameHashLabel: UILabel = {
        let label = UILabel()
        label.text = "#"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var nameDropLabel: UILabel = {
        let label = UILabel()
        label.text = "선택해주세요"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var nameDropImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = UIColor.gray
        imageView.image = UIImage(systemName: "arrowtriangle.down.fill")
        imageView.backgroundColor = .clear
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
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = CommonCGSize.dropDownViewCornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var textHashLabel: UILabel = {
        let label = UILabel()
        label.text = "#"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var textDropLabel: UILabel = {
        let label = UILabel()
        label.text = "선택해주세요"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var textDropImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = UIColor.gray
        imageView.image = UIImage(systemName: "arrowtriangle.down.fill")
        imageView.backgroundColor = .clear
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
        self.viewModel = MainViewModel(coreDataManager: CoreDataManager(), apiServie: APIService(), imageManager: ImageManager())
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        setMain()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // cell 초기화
    override func prepareForReuse() {
        nameDropLabel.text = "선택해주세요"
        textDropLabel.text = "선택해주세요"
        self.isUserInteractionEnabled = true
        nameDropImageView.image = UIImage(systemName: "arrowtriangle.down.fill")
        textDropImageView.image = UIImage(systemName: "arrowtriangle.down.fill")
        isNameDropShowed = false
        isTextDropShowed = false
        textDropDown.dataSource = []
    }
    
    func setMain() {
        // pickerview가 터치 되도록 컨텐츠 뷰 뒤로 보내기
        sendSubviewToBack(contentView)
        
        // setData()
        setDropDown()
        setDropDownData()
        setAddView()
        setAutoLayout()
    }
    
    func setDropDown() {
        DropDown.appearance().textColor = UIColor.black // 아이템 텍스트 색상
        DropDown.appearance().selectedTextColor = UIColor.black // 선택된 아이템 텍스트 색상
        DropDown.appearance().backgroundColor = UIColor.white // 아이템 팝업 배경 색상
        DropDown.appearance().selectionBackgroundColor = UIColor.lightGray // 선택한 아이템 배경 색상
        DropDown.appearance().setupCornerRadius(CommonCGSize.dropDownViewCornerRadius)
        
        // 드롭다운 표시되는 위치 설정
        nameDropDown.anchorView = nameDropButton
        textDropDown.anchorView = textDropButton
        nameDropDown.bottomOffset = CGPoint(x:0, y: 40)
        textDropDown.bottomOffset = CGPoint(x:0, y: 40)
        
        // nameDropDown 선택 시 이벤트 처리
        nameDropDown.selectionAction = { [weak self] (index, item) in
            // 싱글톤 데이터 설정

            // 뷰컨의 hashNameArray에 값 전달하기
            // 현재 cell의 indexPath 가져오기
            if let tableView = self!.superview as? UITableView {
                if let indexPath = tableView.indexPath(for: self!) {
                    // indexPath.row값과 item 전달
                    self!.hashTagNameChanged(item, indexPath.row)
                }
            }
            

            
            // 레이블 텍스트 변경
            self!.nameDropLabel.text = item
            
            // 텍스트 데이터 설정
            self!.setCatTextData(item: item)
            
            // 이미지 원래대로 돌리기
            self!.nameDropImageView.image = UIImage(systemName: "arrowtriangle.down.fill")
            self!.isNameDropShowed = false
        }
        
        // textDropDown 선택 시 이벤트 처리
        textDropDown.selectionAction = { [weak self] (index, item) in
            // 싱글톤 데이터 설정
//            self!.viewModel.handleCatTextSelAction(item: item) {item in
//                
//            }
            
            // 뷰컨의 hashTextArray에 값 전달하기
            // 현재 cell의 indexPath 가져오기
            if let tableView = self!.superview as? UITableView {
                if let indexPath = tableView.indexPath(for: self!) {
                    // indexPath.row값과 item 전달
                    self!.hashTagTextChanged(item, indexPath.row)
                }
            }
            
            // 레이블 텍스트 변경
            self!.textDropLabel.text = item
            // self!.catTextSet()
            
            // 이미지 원래대로 돌리기
            self!.textDropImageView.image = UIImage(systemName: "arrowtriangle.down.fill")
            self!.isTextDropShowed = false
        }
        
        // 드랍다운 취소 시 이미지 원래대로 돌리기
        nameDropDown.cancelAction = {
            self.nameDropImageView.image = UIImage(systemName: "arrowtriangle.down.fill")
        }
        // 드랍다운 취소 시 이미지 원래대로 돌리기
        textDropDown.cancelAction = {
            self.textDropImageView.image = UIImage(systemName: "arrowtriangle.down.fill")
        }
    }
    
    // 초기 데이터 소스 설정
    func setDropDownData() {
        nameDropDown.dataSource = viewModel.getCatNameToMain()
        textDropDown.dataSource = []
    }
    
    // nameDropDown 선택 시 해당하는 Text 가져오기
    func setCatTextData(item: String) {        
        // Name에 해당하는 데이터 가져와서 할당하기
        if item != "선택해주세요" {
            viewModel.changeMainNameSelAction(item: item, completion: { categoryTextArray in
                self.textDropDown.dataSource = categoryTextArray
            })
        }
    }
    
    // 셋업 - 애드뷰
    func setAddView() {
        nameDropView.addSubview(nameHashLabel)
        nameDropView.addSubview(nameDropLabel)
        nameDropView.addSubview(nameDropImageView)
        nameDropView.addSubview(nameDropButton)
        
        textDropView.addSubview(textHashLabel)
        textDropView.addSubview(textDropLabel)
        textDropView.addSubview(textDropImageView)
        textDropView.addSubview(textDropButton)
        
        dropDownStackView.addArrangedSubview(nameDropView)
        dropDownStackView.addArrangedSubview(textDropView)
        
        self.addSubview(dropDownStackView)
    }
    
    // 셋업 - 오토 레이아웃
    func setAutoLayout() {
        // nameHashLabel, textHashLabel 오토 레이아웃
        NSLayoutConstraint.activate([
            // nameHashLabel
            nameHashLabel.leadingAnchor.constraint(equalTo: nameDropView.leadingAnchor, constant: 10),
            nameHashLabel.topAnchor.constraint(equalTo: nameDropView.topAnchor, constant: 10),
            nameHashLabel.bottomAnchor.constraint(equalTo: nameDropView.bottomAnchor, constant: -10),
            nameHashLabel.widthAnchor.constraint(equalToConstant: 10),
            
            // textHashLabel
            textHashLabel.leadingAnchor.constraint(equalTo: textDropView.leadingAnchor, constant: 10),
            textHashLabel.topAnchor.constraint(equalTo: textDropView.topAnchor, constant: 10),
            textHashLabel.bottomAnchor.constraint(equalTo: textDropView.bottomAnchor, constant: -10),
            textHashLabel.widthAnchor.constraint(equalToConstant: 10)
        ])
        
        // nameDropLabel, textDropLabel 오토 레이아웃
        NSLayoutConstraint.activate([
            // nameDropLabel
            nameDropLabel.leadingAnchor.constraint(equalTo: nameHashLabel.trailingAnchor, constant: 4),
            nameDropLabel.topAnchor.constraint(equalTo: nameDropView.topAnchor, constant: 10),
            nameDropLabel.trailingAnchor.constraint(equalTo: nameDropImageView.leadingAnchor, constant: -4),
            nameDropLabel.bottomAnchor.constraint(equalTo: nameDropView.bottomAnchor, constant: -10),

            // textDropLabel
            textDropLabel.leadingAnchor.constraint(equalTo: textHashLabel.trailingAnchor, constant: 4),
            textDropLabel.topAnchor.constraint(equalTo: textDropView.topAnchor, constant: 10),
            textDropLabel.trailingAnchor.constraint(equalTo: textDropImageView.leadingAnchor, constant: -4),
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
            dropDownStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            dropDownStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            dropDownStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0),
            dropDownStackView.heightAnchor.constraint(equalToConstant: CommonCGSize.hashTagHeight)
        ])
    }
    
    // var catTextSet: () -> () = {}
    
    // MARK: - Function
    @objc func nameDropButtonTapped() {
        // DropDown 버튼 문제 해결하기 위해( .show()가 씹힌다.)
        // 버튼을 처음 누를 때 -> TRUE -> 이후 버튼을 다시 눌러도 False
        isNameDropShowed.toggle()

        // NameDrop과 TextDrop을 연달아 눌렀을 때 매끄럽게 동작하기 위해
        isTextDropShowed = false
        
        // 클릭했을 때 이미지 변경
        if isNameDropShowed {
            nameDropDown.show()
            self.nameDropImageView.image = UIImage(systemName: "arrowtriangle.up.fill")
        } else {
            self.nameDropImageView.image = UIImage(systemName: "arrowtriangle.down.fill")
        }
    }
    
    @objc func textDropButtonTapped() {
        // DropDown 버튼 문제 해결하기 위해( .show()가 씹힌다.)
        // 버튼을 처음 누를 때 -> TRUE -> 이후 버튼을 다시 눌러도 False
        isTextDropShowed.toggle()
        // NameDrop과 TextDrop을 연달아 눌렀을 때 매끄럽게 동작하기 위해
        isNameDropShowed = false
        
        // 클릭했을 때 이미지 변경
        if isTextDropShowed {
            textDropDown.show()
            self.textDropImageView.image = UIImage(systemName: "arrowtriangle.up.fill")
        } else {
            self.textDropImageView.image = UIImage(systemName: "arrowtriangle.down.fill")
        }
    }
    
    // 해시태그 값이 변했을 때 값과 indexPath.row를 전달할 클로저
    var hashTagNameChanged: ((String, Int) -> Void) = {_,_ in }
    var hashTagTextChanged: ((String, Int) -> Void) = {_,_ in }
}
// MARK: - Extension


