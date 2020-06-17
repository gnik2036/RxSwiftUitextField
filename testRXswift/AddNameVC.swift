//
//  AddNameVC.swift
//  testRXswift
//
//  Created by mohammed hassan on 6/11/20.
//  Copyright © 2020 mohammed hassan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AddNameVC: UIViewController {
  
    @IBOutlet weak var nameEnterytxtfield:UITextField!
    @IBOutlet weak var submitButton:UIButton!
    
    let diposeBag = DisposeBag()
    let nameSubject = PublishSubject<String>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindSubmitedButton()
    }
    func bindSubmitedButton()
    {
        submitButton.rx.tap
            .subscribe(onNext:{
            if self.nameEnterytxtfield.text != ""
            {
                self.nameSubject.onNext(self.nameEnterytxtfield.text!)
            }
            
        })
        .disposed(by: diposeBag)
        
    }
    
}
