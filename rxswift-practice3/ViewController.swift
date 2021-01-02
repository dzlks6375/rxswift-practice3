//
//  ViewController.swift
//  rxswift-practice3
//
//  Created by SIU on 2021/01/01.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    
    let emailInputText : BehaviorSubject<String> = BehaviorSubject(value: "")
    let emailValid : BehaviorSubject<Bool> = BehaviorSubject(value: false)
    let pwInputText : BehaviorSubject<String> = BehaviorSubject(value: "")
    let pwValid : BehaviorSubject<Bool> = BehaviorSubject(value: false) // value는 default 값 subject는 데이터를 외부에서 넣어줄수 있고 subscribe 할 수 있다
    
    @IBOutlet weak var emailInputTF: UITextField!
    @IBOutlet weak var pwInputTF: UITextField!
    @IBOutlet weak var emailValView: UIView!
    @IBOutlet weak var pwValView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        bindUI()
        
        bindInput()
        bindOutput()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        disposeBag = DisposeBag() // 메모리에서 날리기
        
    }
    
    private func bindInput() {
        
        // input : 아이디 입력, 비번 입력
        
        emailInputTF.rx.text.orEmpty // UI의 인풋은 컴플릿이 되지 않아서 디스포즈되지 않는다.
            .bind(to: emailInputText)
            .disposed(by: disposeBag)
        
        emailInputText
            .map(checkEmailValid)
            .bind(to: emailValid)
            .disposed(by: disposeBag)

        pwInputTF.rx.text.orEmpty
            .bind(to: pwInputText)
            .disposed(by: disposeBag)

        pwInputText
            .map(checkPasswordValid)
            .bind(to: pwValid)
            .disposed(by: disposeBag)
        
    }
    
    private func bindOutput() {
    
        // output : 블릿, 로그인버튼인에이블
        
        emailValid.subscribe(onNext: { b in self.emailValView.isHidden = b})
            .disposed(by: disposeBag)
        
        pwValid.subscribe(onNext: { b in self.pwValView.isHidden = b})
            .disposed(by: disposeBag)

        Observable.combineLatest(emailValid, pwValid, resultSelector: { $0 && $1})
            .subscribe(onNext: {b in self.loginButton.isEnabled = b})
            .disposed(by: disposeBag)
        
    }
    
    private func bindUI() {
        
        // id input +--> check valid --> bullet
        //          |
        //          +--> button enable
        //          |
        // pw input +--> check valid --> bullet
        
        
//        emailInputTF.rx.text.orEmpty // orEmpty 비어있거나 있거나
//            //            .filter { $0 != nil } // 스트링이 옵셔널이 아니면
//            //            .map { $0! }
//            .map(checkEmailValid)
//            .subscribe (onNext: { b in
//                self.emailValView.isHidden = b
//            })
//            .disposed(by: disposeBag)
//
//        pwInputTF.rx.text.orEmpty // orEmpty 비어있거나 있거나
//            //            .filter { $0 != nil } // 스트링이 옵셔널이 아니면
//            //            .map { $0! }
//            .map(checkPasswordValid)
//            .subscribe (onNext: { b in
//                self.pwValView.isHidden = b
//            })
//            .disposed(by: disposeBag)
//
//        Observable.combineLatest( // combineLatest 첫번째 스트림이 바뀌든 두번째 스트림이 바뀌든 하나라도 바뀌면 두개다 내려가는데 가장 최근의 값이 내려간다.
//            // s1과 s2를 받아서 결정된게 밑으로 내려간다
//
//            // zip 두개를 주면 데이터가 생성이 됬을때 둘다 생성이됬을때 전달, 한쪽만 바뀌면 전달이 안되고 두개다 바뀌어야 전달이된다.
//
//            // merge 두개의 스트림을 받는데 들어오는대로 순서대로 다 내려보낸다.
//
//            emailInputTF.rx.text.orEmpty.map(checkPasswordValid),
//            pwInputTF.rx.text.orEmpty.map(checkPasswordValid),
//            resultSelector: {s1, s2 in s1 && s2}
//        ).subscribe (onNext: { b in
//            self.loginButton.isEnabled = b
//        })
//        .disposed(by: disposeBag)
        
    }
    
    // MARK: - Logic
    
    private func checkEmailValid(_ email: String) -> Bool {
        return email.contains("@") && email.contains(".")
    }
    
    private func checkPasswordValid(_ password: String) -> Bool {
        return password.count > 5
    }
    
}

