//
//  Memo.swift
//  MukApp
//
//  Created by Kang on 10/27/23.
//

import UIKit

// MARK: - 만들어야 할 기능
// 카테고리 입력 뷰, 직접 입력 선택 시 => 텍스트 필드가 나오도록 해야한다.
// 카테고리 입력해야 -> 카테고리 추가 가능
// 카테고리 기본값
// 카테고리 뷰 여러개...
// 코어 데이터 매니저 Delete 만들기
// 검색 결과에서 맛집 추가 기능
// 피커뷰 -> 드롭다운으로 수정
// 카테고리 관리 페이지 추가

// MARK: - 관리할 페이지
// 룰렛 돌리는 페이지
// 룰렛 결과 페이지 // (UI - 하는중)
// 맛집 관리 페이지
// 설정 페이지

// MARK: - 처리할 에러
// 1.카테고리 안건드리면 작동 x
// 2.빈 문자열이 저장됨
// 3.피커 뷰 터치가 잘 안댐

// MARK: - 생각 노트
// 외부에 저장된 배열 및 저장변수 -> 함수 안으로 옮기면 메모리 사용을 줄일 수 있겠다.
// 아이콘 그림
// 음식점 그림
// 카페 그림
// 테마 컬러
// 설정 -> 도로명 or 주소

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


// Cell에서 카테고리 선택할 때 커스텀 델리게이트 -> 컨트롤러의 cellforRowAt에서 배열로 받아서 저장해두기 -> 저장버튼 누르면 배열을 데이터 매니저로 호로록
