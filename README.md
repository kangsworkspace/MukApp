### 사용한 기술 
<img src="https://img.shields.io/badge/Swift-F05138?style=for-the-badge&logo=Swift&logoColor=white"> <img src="https://img.shields.io/badge/UIKit-2396F3?style=for-the-badge&logo=Swift&logoColor=white">
### 개발 및 테스트 환경 버전
- Xcode 15.2
- Swift 5.10
- iOS 17.0+
- iPhone 12
- Portrait Only
<br/>

### 앱 소개
### <뭐 먹지? 태그로 관리하는 맛집 & 룰렛>
<img src="https://github.com/kangsworkspace/MukAppOfficial/assets/141600830/b8f26d2d-935a-42aa-9605-8b9751426f0c"  width="900" height="550"/>
<br/>

자주 가는 식당들을 **특정 키워드와 함께 등록**해두고 ex) 지역 - 수원역, 종류 - 양식
<br/>
고민될 때 **랜덤으로 뽑아주는 앱**입니다.

<br/>

### 편하게 맛집을 추가하기 위한 검색기능

<img src="https://github.com/kangsworkspace/DataStorage/assets/141600830/10e99a6d-3b7b-450b-9d36-2edf5a1c57c1"  width="300" height="650"/>
<br/>

### 맛집을 태그와 함께 저장/수정 가능  

<img src="https://github.com/kangsworkspace/DataStorage/assets/141600830/dbd3bf09-6011-4013-9519-cad105fa9fdc"  width="300" height="650"/>
<img src="https://github.com/kangsworkspace/DataStorage/assets/141600830/c1c55af3-1743-4dd3-b832-8dd247a82f1c"  width="300" height="650"/> 
<br/>

### 태그를 이용하여 랜덤으로 저장한 맛집을 룰렛 돌리기  

<img src="https://github.com/kangsworkspace/DataStorage/assets/141600830/fd75c6d1-d88e-47d4-86f7-421077b50768"  width="300" height="650"/>
<img src="https://github.com/kangsworkspace/DataStorage/assets/141600830/b62af681-6c64-45e9-a4f7-918c086e7a2c"  width="300" height="650"/>  
<br/>

### 이미 추가했던 태그는 자동으로 목록에 표시 

<img src="https://github.com/kangsworkspace/DataStorage/assets/141600830/8d60557a-647e-4cdf-9149-a37d26e51a6d"  width="300" height="650"/>
<br/>

### 이전 조건에 해당되는 식당의 태그만 보여주기  

<img src="https://github.com/kangsworkspace/DataStorage/assets/141600830/bc79d597-1502-45af-b6e9-256167f04814"  width="300" height="650"/>    
<br/>


### 이미지 변경

<img src="https://github.com/kangsworkspace/DataStorage/assets/141600830/c0403fc4-468c-49fc-b14f-f4d0790b1882"  width="300" height="650"/> 
<br/>

### 링크를 눌러 페이지로 이동하기
<img src="https://github.com/kangsworkspace/DataStorage/assets/141600830/6aa64849-c6a6-49b7-9a52-5a1e838d3fa4"  width="300" height="650"/>  
<br/>
<br/>
<br/>

# 학습한 내용들     
## 코어데이터 - Relationships  
프로젝트에서 맛집을 저장할 때 아래의 그림처럼 태그를 중분류 - 소분류로 나누어 저장합니다.  
<img src="https://github.com/kangsworkspace/DataStorage/assets/141600830/8d60557a-647e-4cdf-9149-a37d26e51a6d"  width="300" height="650"/>  
그래서 데이터 구조는 아래의 그림처럼 하나의 식당에 여러개의 태그가 들어가는 형식으로 처리되어야 했습니다.  
<img src="https://github.com/kangsworkspace/DataStorage/files/13997469/dataS.pdf"  width="300" height="650"/>  

태그가 몇개가 추가될지 알 수 없기 때문에 코어 데이터의 `entity`에 들어가는 태그에 해당하는 `Attribute`의 개수를 유동적으로 처리할 필요가 있었습니다.  
그래서 `entity`를 식당에 관련된 데이터를 저장하는 `RestaurantData entity`와 태그 정보를 관리하는 `CategoryData entity`로 분리하였습니다.  
그리고 `RestaurantData entity`와 `CategoryData entity`에 `Relationships`의 타입을 To Many로 설정하여 `RestaurantData entity`가 다수의 `CategoryData entity`를 가지도록 하였습니다.

**아래는 코어 데이터로 맛집을 저장하는데 사용한 코드입니다.**  
`RestaurantData entity`를 코어 데이터로 저장하는 코드는 일반적인 방법과 같습니다.  
이후 배열로 받아온 태그 데이터를 반복문을 통해 갯수만큼 새로운 객체를 생성해서 `entity`를 `To Many`로 설정해 제공되는 `.addTo` 함수를 통해  
`RestaurantData`에 `CategoryData`의 관계를 설정하였습니다.  
```swfit
    func saveResToCoreData(address: String, group: String, phone: String, placeName: String, roadAddress: String, placeURL: String, date: Date, imagePath: String, categoryNameArray: [String], categoryTextArray: [String], competion: @escaping () -> Void) {
        // RestaurantData의 entity 유효한지 확인
        guard let entityRestaurant = NSEntityDescription.entity(forEntityName: entityName_Res, in: context) else {
            competion()
            return
        }
        
        // CategoryData의 entity 유효한지 확인
        guard let entityCategory = NSEntityDescription.entity(forEntityName: entityName_Cat, in: context) else {
            competion()
            return
        }
        
        // 할당할 데이터를 가진 객체 생성
        guard let newRes = NSManagedObject(entity: entityRestaurant, insertInto: context) as? RestaurantData else {
            competion()
            return
        }
        
        // 객체에 데이터 할당
        newRes.address = address
        newRes.group = group
        newRes.phone = phone
        newRes.placeName = placeName
        newRes.roadAddress = roadAddress
        newRes.placeURL = placeURL
        newRes.date = date
        newRes.imagePath = imagePath
        
        // 카테고리 배열 할당
        for index in 0...categoryNameArray.count - 1 {
            
            // 할당할 데이터를 가진 객체 생성
            guard let newCat = NSManagedObject(entity: entityCategory, insertInto: context) as? CategoryData else {
                competion()
                return
            }
            
            newCat.categoryName = categoryNameArray[index]
            newCat.categoryText = categoryTextArray[index]
            newCat.order = Int32(index)
            
            // newMenu에 newCategory 더하기
            newRes.addToCategory(newCat)
        }
        
        do {
            try context.save()
            competion()
        } catch {
            print(error)
            competion()
        }
        competion()
    }
```

## 코어 데이터 & 파일매니저 (이미지 저장 방식) 
앞서 언급하였듯이 상단의 이미지를 클릭하면 앨범의 사진을 가져올 수 있습니다.  
<img src="https://github.com/kangsworkspace/DataStorage/assets/141600830/8d60557a-647e-4cdf-9149-a37d26e51a6d"  width="300" height="650"/>
<img src="https://github.com/kangsworkspace/DataStorage/assets/141600830/c0403fc4-468c-49fc-b14f-f4d0790b1882"  width="300" height="650"/>  

이 기능을 구현하기 위해서 코어 데이터와 파일 매니저를 사용하였습니다.  
코어 데이터에 경로를 저장하고 파일 매니저를 통해 경로에 해당하는 파일을 가져오는 형식으로 구현하였습니다.  
경로와 관련된 데이터로 Date()를 통해 생성된 날짜~시간의 값을 설정하였습니다.  
초 단위로 데이터 경로를 설정해두면 겹치는 일을 피할 수 있을 것이라고 생각했는데  
더 찾아보니 경로와 관련된 특정한 값을 따로 지정해두는것이 더 좋다고 하여 다음 프로젝트에 참고할 예정입니다.  

**다음은 파일 매니저를 사용한 코드입니다.**  
- makeDirectory()
  
  앱이 실행될 때 실행하기 위해 AppDelegate의 didFinishLaunchingWithOptions시점에서 동작하도록 하였습니다.  
  처음 실행될 때 파일을 만들고 다음 실행에 생성된 파일이 이미 존재하면 파일이 존재한다는 로그를 남기고 리턴합니다.  
<br/>

- createFile(urlPath: String, image: UIImage)

  이미지를 makeDirectory()에서 생성된 파일에 저장합니다.  
  파라미터로 저장할 경로와 이미지를 받습니다.  
  경로는 이미지를 저장하는 시점의 Date()로 생성되었습니다.
  makeDirectory()에서 생성된 디렉토리에 파라미터로 전달받은 경로로 이미지 파일을 저장합니다.  
<br/>

- readFile(urlPath: String) -> UIImage

  경로를 파라미터로 받아서 해당 경로에 해당하는 이미지를 리턴합니다.  
  경로를 통해 받아온 데이터는 Data 타입이기 때문에 UIImage 타입으로 타입 캐스팅을 합니다.  
  값이 없을 때 기본 이미지로 UIImage(named: "restaurant")을 사용하였습니다.  
  <br/>
  
- deleteFile(urlPath: String)  
  경로를 파라미터로 받아서 해당 경로에 해당하는 이미지를 삭제합니다.
<br/>

이미지를 업데이트 하는 코드는 createFile(urlPath: String, image: UIImage)를 실행했을 때  
같은 경로에 있던 파일이 변경되어 따로 코드를 작성하지 않았습니다.  
```swift
    // 싱글톤
    static let shared = ImageManager()
    
    private let fileManager = FileManager.default
    
    // 파일 매니저 생성(앱 초기화 때 한번만 실행)
    func makeDirectory() {
        // urls 메소드 => 요청된 도메인에서 지정된 공통 디렉토리에 대한 URL배열을 리턴해주는 메소드
        // for: 폴더를 정해주는 요소. Download 혹은 Document 등등
        // in: 제한을 걸어주는 요소. 그 이상은 못가게 하는
        guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        // 생성할 디렉토리 경로(url에 경로 추가)
        let directoryPath = url.appendingPathComponent("RestuarantImages")
        
        // 디렉토리 생성
        do {
            // at: 경로 및 폴더명, 위에서 만든 URL 사용
            // withIntermediateDirectories: “중간 디렉토리들도 만들거니?” 라는 의미
            // attributes: 파일 접근 권한, 그룹 등등 폴더 속성 정의
            try fileManager.createDirectory(
                at: directoryPath,
                withIntermediateDirectories: false,
                attributes: [:]
            )
        } catch {
            print(error)
        }
        
        print("\(url.path)")
    }
    
    // MARK: - Creare: 파일 생성 && Update -> 동일 코드로 동작 시 파일 변경
    func createFile(urlPath: String, image: UIImage) {
        // urls 메소드 => 요청된 도메인에서 지정된 공통 디렉토리에 대한 URL배열을 리턴해주는 메소드
        // for: 폴더를 정해주는 요소. Download 혹은 Document 등등
        // in: 제한을 걸어주는 요소. 그 이상은 못가게 하는
        guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        // 이미지 처리
        guard let imageData = image.jpegData(compressionQuality: 1) else { return } // ?? image.pngData() else { return }
        // 생성할 디렉토리 경로(url에 경로 추가)
        let directoryPath = url.appendingPathComponent("RestuarantImages")
        // 이전 디렉토리 경로에 경로 추가
        let imagePath: URL = directoryPath.appendingPathComponent("\(urlPath).jpeg")
        
        // 경로에 파일 만들기
        do {
            try imageData.write(to: imagePath)
        } catch {
            print(error)
        }
        
    }
    
    // MARK: - Read: 파일 읽기
    func readFile(urlPath: String) -> UIImage {
        // urls 메소드 => 요청된 도메인에서 지정된 공통 디렉토리에 대한 URL배열을 리턴해주는 메소드
        // for: 폴더를 정해주는 요소. Download 혹은 Document 등등
        // in: 제한을 걸어주는 요소. 그 이상은 못가게 하는
        guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return UIImage(named: "restaurant")! }
        
        // 생성할 디렉토리 경로(url에 경로 추가)
        let directoryPath = url.appendingPathComponent("RestuarantImages")
        // 이전 디렉토리 경로에 hi.txt 경로 추가
        let imagePath: URL = directoryPath.appendingPathComponent("\(urlPath).jpeg")
        
        do {
            // URL을 불러와서 Data타입으로 초기화
            let imageData: Data = try Data(contentsOf: imagePath)
            // Data to UIImage
            let image: UIImage = UIImage(data: imageData) ?? UIImage(systemName: "person")!
            
            return image
        } catch {
            print(error)
            return UIImage(systemName: "person")!
        }
    }
    
    // MARK: - Delete: 파일 삭제
    func deleteFile(urlPath: String) {
        // urls 메소드 => 요청된 도메인에서 지정된 공통 디렉토리에 대한 URL배열을 리턴해주는 메소드
        // for: 폴더를 정해주는 요소. Download 혹은 Document 등등
        // in: 제한을 걸어주는 요소. 그 이상은 못가게 하는
        guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        // 생성할 디렉토리 경로(url에 경로 추가)
        let directoryPath = url.appendingPathComponent("RestuarantImages")
        // 이전 디렉토리 경로에 hi.txt 경로 추가
        let imagePath: URL = directoryPath.appendingPathComponent("\(urlPath).jpeg")
        
        do {
            try fileManager.removeItem(at: imagePath)
        } catch {
            print(error)
        }
    }
```

## 기본 이미지가 아닌 경우에만 경로 생성 및 데이터 저장

맛집을 저장할때마다 기기에 사진이 하나씩 이미지 파일이 저장된다면 데이터 공간을 많이 차지할 수 있기 때문에  
앨범에서 따로 이미지를 가져온 경우에만 파일 매니저를 통해 이미지를 저장하도록 코드를 짰습니다.  
 
**이미지의 경로는 맛집이 저장되면서 함께 저장되는 데이터로 무조건 존재하지만**  
**파일의 경로는 앨범의 이미지를 저장하지 않으면 생성되지 않도록 하였습니다.**  
![1111](https://github.com/kangsworkspace/DataStorage/assets/141600830/b92fba2e-2d9c-4629-b333-767a6db2fda9)  
   
파일 경로가 없는 경우 파일 매니저에서 UIImage(systemName: "person")을 리턴하도록 하였습니다.  
리턴값을 보고 다음과 같이 파일을 읽고 쓰는 처리를 다르게 동작하도록 하였습니다.  

**맛집 데이터를 저장하는 경우입니다.**   
```swift
 // 코어 데이터에 맛집 추가
    func addResToCoreData(restaurantData: Document, catNameArray: [String], catTextArray: [String], resImage: UIImage) {
        
        // 데이터 할당
        let address = restaurantData.address ?? ""
        let group = restaurantData.group ?? ""
        
        // 번호 에러처리
        let phone = if restaurantData.phone != "" {
            restaurantData.phone
        } else {
            "번호 정보 없음"
        }
        
        let placeName = restaurantData.placeName ?? ""
        let roadAddress = restaurantData.roadAddress ?? ""
        let placeURL = restaurantData.placeURL ?? ""
        let date = Date()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        let dateString: String = formatter.string(from: date)
        
        // 기본 이미지가 아니면 이미지 파일 생성
        if !checkCommonImage(image: resImage) {
            imageManager.createFile(urlPath: dateString, image: resImage)
        }
        
        guard catNameArray.count == catTextArray.count else {
            fatalError("The length of catNameArray and catTextArray must be the same.")
        }
        
        coreDataManager.saveResToCoreData(address: address, group: group, phone: phone!, placeName: placeName, roadAddress: roadAddress, placeURL: placeURL, date: date, imagePath: dateString, categoryNameArray: catNameArray, categoryTextArray: catTextArray) {
        }
    }
```
 
!checkCommonImage(image: resImage) 함수를 통해 전달받은 이미지가 에셋에 있는 기본 이미지인지 확인합니다.  
아래는 checkCommonImage(image: UIImage) 함수의 내용입니다.   

```swift
private func checkCommonImage(image: UIImage) -> Bool {
        
        //  13개
        switch image {
        case let image where image == RestaurantImages.korean :
            return true
        case let image where image == RestaurantImages.chicken :
            return true
        case let image where image == RestaurantImages.bakery :
            return true
        case let image where image == RestaurantImages.dessertCafe :
            return true
        default:
            return false
        }
    }
 ```
   
여기서 false가 리턴된다면 앨범의 이미지를 따로 저장한 것이라고 볼 수 있게 됩니다.   
그러면 파일 매니저를 통해 이미지 파일을 저장하고 이 때 파일의 경로가 생성됩니다.  
 
반대로 true가 리턴된다면 기본 이미지를 저장한 것이라고 볼 수 있게 됩니다.  
파일의 경로가 생성되지 않습니다.   
 
 
**맛집 데이터를 불러오는 경우**   
1.앨범의 이미지를 저장한 경우와 2.에셋에 있는 기본 이미지로 저장한 경우로 나누었습니다.   
   
파일 매니저에서 데이터를 불러온 결과가 UIImage(systemName: "person") 일 때는 파일 경로가 없고   
반대로 불러온 결과과 UIImage(systemName: "person")가 아닐 경우에는   
파일 경로와 해당 경로에 저장한 이미지가 있다는 것이기 때문에 리턴된 이미지를 사용하도록 하였습니다.  
```swift
  resImageView.image = if imageManager.readFile(urlPath: imagePath) != UIImage(systemName: "person") {
                    imageManager.readFile(urlPath: imagePath)
                } else {
                	// 맛집의 group에 따라 에셋 이미지 할당
                	if let resGroup = restaurantCoreData.group {
                        switch resGroup {
                        case let groupString where groupString.contains("한식"):
                            RestaurantImages.korean
                        case let groupString where groupString.contains("치킨"):
                            RestaurantImages.chicken
                        case let groupString where groupString.contains("제과"):
                            RestaurantImages.bakery
                        default:
                            RestaurantImages.restaurant
                        }
                }
  }
```

### 아쉬운 점  
파일 매니저에서 데이터를 불러올 때 **리턴값을 옵셔널**로 하고 **옵셔널에 대한 에러 처리**를 하는게 훨씬 깔끔한 코드가 나올 것 같습니다.  
<br/>

# 사용성에 대해 고민
### URL 이동
첫번째 그림은 제 <뭐 먹지? 태그로 관리하는 맛집 & 룰렛 > 앱에서 맛집을 저장하거나 수정하는 페이지 입니다.  
저기서 URL을 누르면 두번째 그림처럼 URL에 해당하는 웹뷰를 띄우게 됩니다.  
<img src="https://github.com/kangsworkspace/DataStorage/assets/141600830/38eb23ff-e074-44b9-9521-08fec0fed093"  width="300" height="650"/>
<img src="https://github.com/kangsworkspace/DataStorage/assets/141600830/9d682da0-197e-4e83-a672-949988672669"  width="300" height="650"/>   

해당 기능은 아래의 코드와 같이 `SFSafariViewController`를 사용하였습니다.  
먼저 `SafariServices`를 임포트 하고 해당 url을 파라미터로 넣은 `SFSafariViewController` 타입의 `safariViewController`를 선언했습니다.  
그리고 해당 `safariViewController`를  `present`로 화면을 띄웠습니다.  

```swift
func goWebPage(url: String, fromVC: UIViewController) {
    if url != "등록된 정보가 없습니다" {
        guard let url = URL(string: url) else { return }
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.modalPresentationStyle = .automatic
        fromVC.present(safariViewController, animated: true)
    }
}
```  

처음에 사용한 코드는 아래와 같이 조금 달랐습니다.  
아래 코드로는 `import SafariServices`를 하지 않고 바로 화면을 띄울 수 있었습니다.  
```swift
@objc func buttonTapped(_ url: String) {
    if let url = URL(string: url) {
        UIApplication.shared.open(url, options: [:])
    }
}
```  
그림은 위 코드로 화면을 이동한 모습입니다.
이전의 코드와 달리 완전히 사파리 앱이 켜져서 해당 URL로 이동하는 방식으로 작동합니다.  
<img src="https://github.com/kangsworkspace/DataStorage/assets/141600830/1d7ed3e7-2e71-4326-9690-692ef37cfcb6"  width="300" height="650"/>  
<img src="https://github.com/kangsworkspace/DataStorage/assets/141600830/38c2271e-7441-4417-bc08-157f63c8ae10"  width="300" height="650"/>   

**저는 제 앱에서 사용자가 식당의 정보를 간단하게 둘러보고 아래로 쓱 내려서 창을 끌 수 있으면 좋겠다고 생각했습니다.**  
하지만 이 방식으로는 네비게이션 바의 작은 버튼을 눌러서 돌아가거나 홈 화면으로 돌아가면서 앱을 다시 켜줘야해서  
사용자의 입장에서 번거로울거 같아 `SFSafariViewController` 사용하였습니다.  
그리고 `SFSafariViewController`가 비교적 더 최근에 나온 방식이고 웹 뷰를 따로 설정하지 않고도 간단하게 창을 띄울 수 있어 일반적으로 더 사용성이 좋은 방법이라고 생각하기도 합니다.  

# 추가 / 보완하면 좋을 내용들  
### 저장한 맛집 페이지에서 원하는 맛집을 바로 검색할 수 있는 편의 기능  
- `UISearchController`를 이용한 검색 기능이나 저장한 태그를 설정할 수 있는 항목을 추가하면 완성도가 높아질 것 같습니다.  

### 저장한 맛집이 아닌 주변의 음식점들을 랜덤으로 뽑아주는 기능  
- 카카오 API의 거리를 기준으로 데이터를 받는 기능을 응용하여 구현 가능할 것 같습니다.  

### 디자인 패턴 보완
- **문제점 1: 바인딩 미적용**      
  제작 초기에는 MVVM패턴을 적용하려고 하였으나 바인딩을 하지 않으면서 MVC와 MVVM이 섞인 어중간한 디자인이 되었습니다.
  
- **문제점 2: `View Model`을 분리하지 않음**  
  처음에는 공통적으로 사용할만한 코드가 많아서 일부러 View Model을 분리하지 않고 하나의 `View Model`을 사용하였습니다.
  하지만 프로젝트가 커지면서 점점 원하는 코드의 시인성이 떨어져서 코드를 분리하는것이 더 좋았을 것이라고 생각이 되었습니다.  
  
- 현재 프로젝트에는 기초적인 M-V-VM의 역할에 대한 이해를 바탕으로 의존성 주입은 적용이 되었습니다. 그래서 패턴에 대한 이해를 더 정확하게 하고 바인딩을 시도하면 MVVM 디자인 패턴을 잘 적용해볼 수 있을 것 같습니다.  

# 사용한 외부 라이브러리  
[드롭다운 라이브러리](https://github.com/AssistoLab/DropDown)
- 태그 버튼에 해당하는 UI에 사용되었습니다. 

[카카오 API Service](https://developers.kakao.com)
- 검색 기능에 사용되었습니다.

# License  
Licensed under the [MIT](https://github.com/kangsworkspace/MukAppOfficial/blob/main/LICENSE) license.

