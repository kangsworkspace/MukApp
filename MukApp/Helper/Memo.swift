//
//  Memo.swift
//  MukApp
//
//  Created by Kang on 10/27/23.
//

import UIKit

// MARK: - 만들어야 할 기능 (Create)

// common
// 코어 데이터 매니저 Delete 만들기
// 설정 페이지 -> 다크모드 라이트 모드, 개발자 문의, 데이터 초기화?
// 화면 전환되면 데이터들 초기화.

// 메인 룰렛 뷰
// 맨 아래 뷰만 터치 가능하도록
// 룰렛 돌릴 수 있을때만 색상 바뀌게 하기
// 빈 배열 -> 룰렛 못돌리기
// 룰렛 돌아가고 결과 페이지로 전환
/* 메인 버튼의 룰렛 돌리기가 눌렸을 때!
1...100 맛집 예시 -> 끝나면 클로저로 101로 가도록
101에 찐 데이터 전달
*/

// 맛집 관리 뷰
// 수정 가능하도록 하기

// 맛집 추가 뷰
// 저장버튼 누르면 화면 전환하기
// 빈 배열 저장 못하게 하기

// MARK: - 처리할 에러 (Fix)




























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

// 블로그용
//        // 옵셔널 해제
//        guard let menuDataList = menuDataList else { return }
//
//        // 메뉴 데이터 배열 -> 카테고리 -> 카테고리 이름 => 반복문으로 할당
//        for menuData in menuDataList {
//            if let category = menuData.category as? Set<CategoryData> {
//                for category in category {
//                    if let categoryName = category.categoryName {
//                        categoryArrayN.append(categoryName)
//                    }
//                }
//            }
//        }
//
//        // 중복된 값 제거
//        categoryArrayN = Array(Set(categoryArrayN))


//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        navigationController?.setNavigationBarHidden(true, animated: animated)
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: animated)
//    }
