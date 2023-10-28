//
//  Memo.swift
//  MukApp
//
//  Created by Kang on 10/27/23.
//

import UIKit

// MARK: - 만들어야 할 기능
// 메인 뷰 -> 테이블 뷰 추가 -> 피커 뷰로 카테고리 생성
// 카테고리 입력 뷰, 직접 입력 선택 시 => 텍스트 필드가 나오도록 해야한다.
// 카테고리 입력해야 -> 카테고리 추가 가능
// 카테고리 기본값
// 카테고리 뷰 여러개...
// 검색 -> 카카오


// MARK: - 처리할 에러
// 1.카테고리 안건드리면 작동 x
// 2.빈 문자열이 저장됨
// 3.피커 뷰 터치가 잘 안댐

// MARK: - 생각 노트
// 외부에 저장된 배열 -> 함수 안으로 옮기면 메모리 사용을 줄일 수 있겠다.


// 셋업 - 네비게이션 바
// func setupNavigationBar() {
    
//        let appearance = UINavigationBarAppearance()
//        appearance.configureWithOpaqueBackground() // 불투명
//        appearance.backgroundColor = .white
//        navigationController?.navigationBar.tintColor = .systemBlue
//        navigationController?.navigationBar.standardAppearance = appearance
//        navigationController?.navigationBar.compactAppearance = appearance
//        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    // navigationController?.navigationBar.prefersLargeTitles = true
    
    // 네비게이션 바의 타이틀 설정
    // navigationItem.title = "지금 먹을 메뉴는"
// }


// 메뉴 뽑기 버튼
//@objc func menuButtonTapped() {
//    print("메뉴 버튼이 눌렸습니다.")
//    
//    viewModel.handleMenuButtonTapped()
//    menuLabel.text = viewModel.getSelectedMenu
//}
