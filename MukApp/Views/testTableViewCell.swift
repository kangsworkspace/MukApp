//
//  testTableViewCell.swift
//  MukApp
//
//  Created by Kang on 10/23/23.
//

import UIKit

class testTableViewCell: UITableViewCell {


     var menuNameLabel: UILabel = {
        let label = UILabel()
        
        // 텍스트 설정
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        
        // 보더 설정
        label.layer.borderWidth = 1
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
     var categoryNameLabel: UILabel = {
        let label = UILabel()
        
        // 텍스트 설정
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        
        // 보더 설정
        label.layer.borderWidth = 1
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
     var categoryTextLabel: UILabel = {
        let label = UILabel()
        
        // 텍스트 설정
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        
        // 보더 설정
        label.layer.borderWidth = 1
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)

        self.backgroundColor = .white
        setupMain()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupMain() {
        
        mainStackView.addArrangedSubview(menuNameLabel)
        mainStackView.addArrangedSubview(categoryNameLabel)
        mainStackView.addArrangedSubview(categoryTextLabel)
        
        self.addSubview(mainStackView)
        setAutoLayout()
    }
    
    
    func setAutoLayout() {
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            mainStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        ])
    }
}
