//
//  AmplitudeLiterals.swift
//  Hankkijogbo
//
//  Created by 심서현 on 8/28/24.
//

enum AmplitudeLiterals {
    enum Home {
        static let tabHankki = "Home_StoreCard_Click"
        static let tabPin = "Home_Map_Pin_Click"
        
        static let tabFilter = "Home_Detail_Filter_Completed"
        
        static let tabCategory = "Home_Food_Categories_Click"
        
    }
    enum Tabbar {
        static let tabHome = "Nav_Home_Click"
        static let tabReport = "Nav_Report_Click"
        static let tabMypage = "Nav_Mypage_Click"
    }
    
    enum MyZipListBottomSheet {
        static let tabAdd = "Home_RestList_Jockbo_Add"
    }
    
    enum Report {
        static let tabSubmit =  "Report_Complete_Click"
    }
    
    enum Mypage {
        static let tabMyzip = "Mypage_MyJokbo_Click"
        static let tabShare = "Mypage_MyJokbo_Share"
        static let completedShare = "Mypage_MyJokbo_Share_Completed"
    }

    enum SharedZip {
        static let present = "Shared_Jokbo_Page"
        static let tabAdd = "Shared_Jokbo_MyJokbo_Add"
        static let completedAdd = "Shared_Jokbo_MyJokbo_Add_Completed"
    }
    
    enum ZipList {
        static let tabCreateZip = "Mypage_MyJokbo_NewJokbo_Create"
    }
    
    enum Detail {
        static let tabHeart = "RestInfo_Like_Click"
        static let tabMenuEdit = "RestInfo_MenuEdit_Click"
    }

    enum UnivSelect {
        static let tabSubmit = "UniversityChoice_AnyUniv_Click"
    }
    
    enum Property {
        static let university = "university"
        static let zip = "족보"
        static let store = "식당"
        static let food = "food"
        static let filterSort = "정렬"
        static let filterPrice = "가격대"
    }
}
