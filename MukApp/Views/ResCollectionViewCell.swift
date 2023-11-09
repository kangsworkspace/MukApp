//
//  RestaurantcollectionViewCell.swift
//  MukApp
//
//  Created by Kang on 10/28/23.
//

import UIKit

class ResCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Interfave
    var imageUrl: String? {
        didSet {
            // loadImage()
        }
    }
    
    // 생성 - 메인 이미지 뷰
    lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var addressLabel: UILabel = {
        let label = UILabel()
        // 텍스트 설정
        label.text = "상리 1길 우엥엥호 1222동 4012412호"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var retaurantNameLabel: UILabel = {
        let label = UILabel()
        // 텍스트 설정
        label.text = "어쭈꾸미"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setMain()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 셀이 재사용되기 전에 호출되는 메서드
    override func prepareForReuse() {
        super.prepareForReuse()
        // 일반적으로 이미지가 바뀌는 것처럼 보이는 현상을 없애기 위해서 실행 ⭐️
        // self.mainImageView.image = nil
    }
    
    // MARK: - 셋업
    // 셋업 - 메인
    func setMain() {        
        setAddView()
        setAutoLayout()
    }
    
    // 셋업 - 애드 뷰
    func setAddView() {
        self.addSubview(mainImageView)
        self.addSubview(addressLabel)
        self.addSubview(retaurantNameLabel)
    }
    
    // 셋업 - 오토 레이아웃
    func setAutoLayout() {
        // mainImageView 오토 레이아웃
        NSLayoutConstraint.activate([
            mainImageView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            mainImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0),
            mainImageView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            mainImageView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0),
        ])
        
        // addressLabel 오토 레이아웃
        NSLayoutConstraint.activate([
            addressLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            addressLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            addressLabel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
        
        // addressLabel 오토 레이아웃
        NSLayoutConstraint.activate([
            retaurantNameLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            retaurantNameLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            retaurantNameLabel.bottomAnchor.constraint(equalTo: addressLabel.topAnchor, constant: -10)
        ])
    }
    
    // MARK: - Function
    // URL ===> 이미지를 셋팅하는 메서드
//    private func loadImage() {
//        guard let urlString = self.imageUrl, let url = URL(string: urlString)  else { return }
//        
//        // 오래걸리는 작업을 동시성 처리
//        DispatchQueue.global().async {
//            // URL을 가지고 데이터를 만드는 메서드
//            // (일반적으로 이미지를 가져올때 많이 사용)
//            guard let data = try? Data(contentsOf: url) else { return }
//            // 오래걸리는 작업이 일어나고 있는 동안에 url이 바뀔 가능성 제거
//            guard self.imageUrl! == url.absoluteString else { return }
//            
//            // 작업의 결과물을 이미지로 표시 (메인큐)
//            DispatchQueue.main.async {
//                self.mainImageView.image = UIImage(data: data)
//            }
//        }
//    }
}
