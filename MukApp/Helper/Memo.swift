//
//  Memo.swift
//  MukApp
//
//  Created by Kang on 10/27/23.
//

import UIKit

// MARK: - 만들어야 할 기능 (Create)

// common
// 코어 데이터 매니저 Delete 만들기 (12/02)
// 설정 페이지 -> 다크모드 라이트 모드, 개발자 문의, 데이터 초기화?
// 화면 전환과 데이터 초기화 설정. (12/02)
// 로딩 화면 추가

// 메인 룰렛 뷰
// 하단 텍스트 삭제 및 상황에 따른 텍스트 출력 상단 텍스트에서 (12/01)
// 룰렛 돌리고 -> 결정 -> 데이터 초기화
// - 할 때 후보식당 수 업데이트

// 룰렛 결과 뷰
// 식당 수정 버튼 구현

// 맛집 관리 뷰
// 이미지 수정 가능하도록 하기 (11/30)

// 맛집 추가 뷰


// ==============================================================

// (11/28)
// EditResView 재활용 하도록 하기(룰렛 뷰 - 식당 수정 버튼, 식당 컬렉슌 뷰 - 수정 페이지, 식당 추가 뷰 연결)
// Data가 있을 때 -> 화면 이동 전에 데이터 전달/ 없을 때 구별
// 기본 뷰 -> 데이터 있을 때 셋업 UI

// (11/30)
// 이미지 수정 가능하도록 변경
// 이미지 추가 관련 코어 데이터 및 코드 점검

// (12/01)
// 하단 텍스트 삭제 및 상황에 따른 텍스트 출력 상단 텍스트에서


// (12/02)
// 코어 데이터 매니저 Delete 만들기
// 화면 전환과 데이터 초기화 설정.


// MARK: - 처리할 에러 (Fix)
// 메인 뷰 마지막 카테고리 +가 가능하다.

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




