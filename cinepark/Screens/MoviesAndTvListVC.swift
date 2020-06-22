//
//  MoviesListVC.swift
//  cinepark
//
//  Created by Abdulsalam Mansour on 6/21/20.
//  Copyright © 2020 abdulsalam. All rights reserved.
//

import UIKit
import RxSwift

class MoviesAndTvListVC: UIViewController {
    
    var contentType: ContentType!
    
    private let disposeBag = DisposeBag()
    
    init(contentType: ContentType) {
        super.init(nibName: nil, bundle: nil)
        self.contentType   = contentType
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        
        ApiClient.getPopularMovies()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { response in
                
                print(response)
            }, onError: { error in
               
            })
            .disposed(by: disposeBag)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func configureViewController(){
        view.backgroundColor = .systemBackground
        title                = contentType.rawValue
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
