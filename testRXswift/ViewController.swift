//
//  ViewController.swift
//  testRXswift
//
//  Created by mohammed hassan on 6/11/20.
//  Copyright © 2020 mohammed hassan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    @IBOutlet weak var helloLabel:UILabel!
    @IBOutlet weak var nameEnterytxtfield:UITextField!
    @IBOutlet weak var submitButton:UIButton!
    @IBOutlet weak var addName:UIButton!
    @IBOutlet weak var namesLabel:UILabel!
    
    let disposeBag = DisposeBag()
    var namesArray : Variable<[String]> = Variable([])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindTextField()
        bindSubmittedButton()
        bindAddNameButton()
        namesArray.asObservable()
            .subscribe(onNext:{
                self.namesLabel.text = $0.joined(separator: ",  ")
            })
        .disposed(by: disposeBag)
    }
    
    func bindTextField()
    {
        nameEnterytxtfield.rx.text
            //            .debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .map {
                if $0 == ""
                {
                    return "Type Your Name Below"
                }
                else
                {
                    return "Hello, \($0!)."
                    
                }
        }.bind(to: helloLabel.rx.text).disposed(by: disposeBag)
        
    }
    func bindSubmittedButton()
    {
        submitButton.rx.tap
            .subscribe(onNext:{
            if self.nameEnterytxtfield.text != ""
            {
                self.namesArray.value.append(self.nameEnterytxtfield.text!)
                self.namesLabel.rx.text.onNext(self.namesArray.value.joined(separator: ", "))
                self.nameEnterytxtfield.rx.text.onNext("")
                self.helloLabel.rx.text.onNext("Type Your Name Below")
            }
        })
            .disposed(by: disposeBag)
    }
    func bindAddNameButton()
    {
        addName.rx.tap
            .throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext:{
                guard let addNameVc = self.storyboard?.instantiateViewController(identifier: "AddNameVC") as? AddNameVC else { fatalError("coundn't create add name vc ")}
                addNameVc.nameSubject
                    .subscribe(onNext:{ name in
                    self.namesArray.value.append(name)
                    addNameVc.dismiss(animated: true, completion: nil)
                })
                    .disposed(by: self.disposeBag)
                self.present(addNameVc, animated: true, completion: nil)
            })
    }
    
}

