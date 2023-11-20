//
//  Memo.swift
//  MukApp
//
//  Created by Kang on 10/27/23.
//

import UIKit

// MARK: - 만들어야 할 기능 (Create)
// 코어 데이터 매니저 Delete 만들기
// 설정 페이지 -> 다크모드 라이트 모드, 개발자 문의, 데이터 초기화?
// 검색 - 관리 페이지 분리
// 룰렛 돌릴 수 있을때만 색상 바뀌게 하기
// 빈 배열 -> 룰렛 못돌리기
// 화면 전환되면 데이터들 초기화.

// MARK: - 처리할 에러 (Fix)

// Add or Fix 뷰 ===
// 1.빈 문자열이 저장됨
// =================


// MARK: - 나중에 사용할 로직
/* 메인 버튼의 룰렛 돌리기가 눌렸을 때!
 1...100 맛집 예시 -> 끝나면 클로저로 101로 가도록
 101에 찐 데이터 전달
*/

/* 메인 화면 삭제 버튼 마지막 순서 삭제시키기
마지막 데이터 삭제
보여줄 수 줄이기
*/


// ??? 상황에서 - 할 때 배열 삭제가 안된다....///


/*
 + - 로직
 +할 때 빈값 무조건 넣기. -> 배열의 수 == categoryCnt 수
 룰렛 돌릴 때 빈 값 제외하기...
 
 -> + -
 
 허위값은 -> 저장이 안되

 ""
 
 
 */



































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
