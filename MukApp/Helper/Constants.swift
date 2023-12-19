//
//  Constants.swift
//  MukApp
//
//  Created by Kang on 11/16/23.
//

import UIKit

public enum CommonCGSize {
    // 셀의 높이 (해시태그 Cell)
    static let hashTagTableHeight = CGFloat(50)
    
    // 셀의 간격 (해시태그 Cell)
    static let hashTagHeight = hashTagTableHeight - 10
    
    // 버튼 높이 (룰렛 돌리기)
    static let buttonHeight = CGFloat(50)
    
    // 드랍 다운 뷰 둥글게 설정(해시태그 Cell)
    static let dropDownViewCornerRadius = CGFloat(12)
}

public enum MyColor {
    // 테마 컬러 - 분홍
    static let themeColor = UIColor(hexString: "#ff477e")
    
    // 테마 컬러 - 동작하지 않을 때
    static let disableColor = UIColor(hexString: "#b2b2b2")
}

public enum MyImage {
    // 아래 화살표
    static let arrowDown = UIImage(systemName: "arrowtriangle.down.fill")!
    
    // 위 화살표
    static let arrowUp = UIImage(systemName: "arrowtriangle.up.fill")!
    
    // 자물쇠
    static let lock = UIImage(systemName: "lock.fill")!
    
    // 식당 이미지
    static let restaurant = UIImage(systemName: "fork.knife.circle")!
    
    // 카페 이미지
    static let cafe = UIImage(systemName: "cup.and.saucer.fill")!
    
    // 주소 이미지
    static let address = UIImage(systemName: "map")!
    
    // 전화번호 이미지
    static let number = UIImage(systemName: "phone.circle")!
    
    // URL 이미지
    static let url = UIImage(systemName: "network")!
}
