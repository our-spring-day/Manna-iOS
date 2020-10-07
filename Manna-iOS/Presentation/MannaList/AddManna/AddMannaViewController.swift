//
//  AddMannaViewController.swift
//  Manna-iOS
//
//  Created by once on 2020/08/05.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class AddMannaViewController: UIViewController, UITextFieldDelegate {
    let disposeBag = DisposeBag()
    
    let viewModel: AddMannaViewModelType
    let inviteViewModel = InviteFriendsViewModel()
    static let shared = AddMannaViewController()
    
    let people = PeopleAddManna()
    let time = TimeAddManna()
    let place = PlaceAddManna()
    let finalAdd = FinalAddManna()
    
    let scrollView = UIScrollView()
    let titleLabel = UILabel()
    let titleInput = UITextField()
    let titleButton = UIButton()
    
    let prevButton = UIButton(type: .custom)
    let nextButton = UIButton()
    
    init(viewModel: AddMannaViewModelType = AddMannaViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        viewModel = AddMannaViewModel()
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
        UIBind()
        bind()
    }
    
    func attribute() {
        navigationController?.isNavigationBarHidden = true
        finalAdd.finalPlace.numberOfLines = 0
        finalAdd.completeButton.addTarget(self, action: #selector(addMeet), for: .touchUpInside)
        scrollView.do {
            $0.isHidden = true
            $0.backgroundColor = .red
            $0.bounces = false
        }
        titleLabel.do {
            $0.textColor = .black
            $0.isHidden = true
        }
        titleInput.do {
            $0.layer.borderWidth = 1.0
            $0.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            $0.layer.cornerRadius = 8
            $0.textAlignment = .center
            $0.placeholder = "만남 타이틀"
            $0.delegate = self
        }
        titleButton.do {
            $0.setTitle("완료", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = UIColor(displayP3Red: 97/255, green: 196/255, blue: 174/255, alpha: 1)
            $0.layer.cornerRadius = 8
            $0.addTarget(self, action: #selector(titleBtn), for: .touchUpInside)
        }
        prevButton.do {
            $0.setImage(#imageLiteral(resourceName: "backButton"), for: .normal)
            $0.addTarget(self, action: #selector(prevBtn), for: .touchUpInside)
        }
        nextButton.do {
            $0.setTitle("다음", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = UIColor(displayP3Red: 97/255, green: 196/255, blue: 174/255, alpha: 1)
            $0.layer.cornerRadius = 8
            $0.isHidden = true
            $0.addTarget(self, action: #selector(nextBtn), for: .touchUpInside)
        }
    }
    
    func layout() {
        view.addSubview(titleButton)
        view.addSubview(titleLabel)
        view.addSubview(titleInput)
        view.addSubview(scrollView)
        view.addSubview(prevButton)
        view.addSubview(nextButton)
        scrollView.addSubview(people)
        scrollView.addSubview(time)
        scrollView.addSubview(place)
        scrollView.addSubview(finalAdd)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            $0.centerX.equalTo(view.snp.centerX)
        }
        titleInput.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            $0.centerX.equalTo(view.snp.centerX)
            $0.width.equalTo(200)
            $0.height.equalTo(30)
        }
        titleButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            $0.trailing.equalTo(view.snp.trailing).offset(-10)
            $0.width.equalTo(60)
            $0.height.equalTo(30)
        }
        prevButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.leading.equalTo(view.snp.leading).offset(10)
        }
        nextButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.trailing.equalTo(view.snp.trailing).offset(-10)
            $0.width.equalTo(80)
            $0.height.equalTo(30)
        }
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(60)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        people.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top)
            $0.leading.equalTo(scrollView.snp.leading)
            $0.width.equalToSuperview()
            $0.height.equalToSuperview()
        }
        time.snp.makeConstraints {
            $0.top.equalTo(people)
            $0.leading.equalTo(people.snp.trailing)
            $0.width.equalToSuperview()
            $0.height.equalToSuperview()
        }
        place.snp.makeConstraints {
            $0.top.equalTo(people)
            $0.leading.equalTo(time.snp.trailing)
            $0.width.equalToSuperview()
            $0.height.equalToSuperview()
        }
        finalAdd.snp.makeConstraints {
            $0.top.equalTo(people)
            $0.leading.equalTo(place.snp.trailing)
            $0.width.equalToSuperview()
            $0.height.equalToSuperview()
        }
    }
    
    func UIBind() {
        inviteViewModel.outputs.friendList
            .bind(to: people.tableView.rx.items(cellIdentifier: FriendListCell.identifier, cellType: FriendListCell.self)) { (_: Int, element: User, cell: FriendListCell) in
                cell.friendIdLabel.text = element.name
                cell.friendImageView.image = UIImage(named: "\(element.profileImage)")
                if element.checkedFlag == true {
                    cell.checkBoxImageView.image = UIImage(named: "checked")
                } else {
                    cell.checkBoxImageView.image = UIImage(named: "unchecked")
                }
        }.disposed(by: disposeBag)
        
        //collectionView set
        inviteViewModel.outputs.checkedFriendList
            .bind(to: people.collectionView.rx.items(cellIdentifier: CheckedFriendCell.identifier, cellType: CheckedFriendCell.self)) { (_: Int, element: User, cell: CheckedFriendCell) in
                cell.profileImage.image = UIImage(named: "\(element.profileImage)")
                UIView.animate(withDuration: 0.3) {
                    self.scrollView.layoutIfNeeded()
                }
        }.disposed(by: self.disposeBag)
        
        //checked Friend at tableView
        people.tableView.rx.modelSelected(User.self)
            .bind(to: inviteViewModel.inputs.itemFromTableView)
            .disposed(by: disposeBag)
        
        //selected Friend at collectionView
        people.collectionView.rx.modelSelected(User.self)
            .bind(to: inviteViewModel.inputs.itemFromCollectionView)
            .disposed(by: disposeBag)
        
        //searchID bind
        people.textField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind(to: inviteViewModel.inputs.searchedFriendID)
            .disposed(by: disposeBag)
        
        //dynamic tableView's height by checkedFriend exist
        inviteViewModel.outputs.checkedFriendList
            .skip(1)
            .map { $0.count }
            .filter { $0 <= 1 }
            .subscribe(onNext: { count in
                if count < 1 {
                    self.people.textField.snp.updateConstraints {
                        $0.top.equalToSuperview()
                    }
                } else {
                    self.people.textField.snp.updateConstraints {
                        $0.top.equalToSuperview().offset(100)
                    }
                }
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                }
            })
            .disposed(by: disposeBag)
        
        //keyboard hide when tableView,collectionView scrolling
        Observable.of(people.tableView.rx.didScroll.asObservable(), people.collectionView.rx.didScroll.asObservable())
            .merge()
            .subscribe(onNext: {
                self.view.endEditing(true)
            }).disposed(by: disposeBag)
    }
    
    func bind() {
        inviteViewModel.outputs.checkedFriendList
            .bind(to: finalAdd.finalPeople.rx.items(cellIdentifier: CheckedFriendCell.identifier, cellType: CheckedFriendCell.self)) { _, element, cell in
                cell.profileImage.image = UIImage(named: "\(element.profileImage)")
            }
            .disposed(by: disposeBag)
        
        titleInput.rx.text.orEmpty
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
    
        time.onPicker.rx.date
            .map {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM월 dd일 hh시mm분"
                return dateFormatter.string(from: $0)
        }
        .subscribe(onNext: { [weak self] value in
            self?.finalAdd.finalTime.text = value
        })
            .disposed(by: disposeBag)
        
        place.searchButton.rx.tap
            .flatMap(selectedPlace)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] address in
                self?.finalAdd.finalPlace.text = address.roadAddress
            })
            .disposed(by: disposeBag)
    }
    
    func meetBind() {
        let title = titleLabel.text!
        let time = finalAdd.finalTime.text!
        let place = finalAdd.finalPlace.text!
        
        inviteViewModel.outputs.checkedFriendList
            .map { "\($0[0].name) 외 \($0.count-1) 명" }
            .bind(to: viewModel.inputs.people)
            .disposed(by: disposeBag)
        
        Observable.just(title)
            .bind(to: viewModel.inputs.title)
            .disposed(by: disposeBag)
        
        Observable.just(time)
            .bind(to: viewModel.inputs.time)
            .disposed(by: disposeBag)
        
        Observable.just(place)
            .bind(to: viewModel.inputs.place)
            .disposed(by: disposeBag)
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc func addMeet() {
        meetBind()
    }
    
    func selectedPlace() -> Observable<Address> {
        let view = SelectPlaceViewController.shared
        view.searchText.text = place.mannaPlace.text
        view.modalPresentationStyle = .fullScreen
        present(view, animated: true)
        return view.selectedAddress
    }
    
    @objc func titleBtn(_ sender: Any) {
        guard let text = titleInput.text,
            text.count > 0 else {
                alert(message: "타이틀을 입력하세요")
                return
        }
        
        titleInput.endEditing(true)
        titleInput.isHidden = true
        titleButton.isHidden = true
        titleLabel.isHidden = false
        
        UIView.animate(withDuration: 0.7, animations: {
            let move = CGAffineTransform(translationX: 0, y: -40)
            self.titleLabel.transform = move
        }) { _ in
            self.scrollView.isHidden = false
            self.nextButton.isHidden = false
        }
    }
    
    @objc func nextBtn(_ sender: Any) {
        if scrollView.isHidden == false {
            let maxWidth = min(scrollView.contentOffset.x + view.frame.width, view.frame.width * 2)
            let newOffset = CGPoint(x: maxWidth, y: 0)
            scrollView.contentOffset = newOffset
        }
    }
    
    @objc func prevBtn(_ sender: Any) {
        if scrollView.isHidden == true {
            titleInput.text = ""
            place.mannaPlace.text = ""
            navigationController?.popViewController(animated: true)
        } else if scrollView.isHidden == false && scrollView.contentOffset.x == 0 {
            scrollView.isHidden = true
            UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.titleLabel.transform = CGAffineTransform.identity
                self.titleButton.isHidden = false
                self.nextButton.isHidden = true
            }) { _ in
                self.titleLabel.isHidden = true
                self.titleInput.isHidden = false
            }
        } else if scrollView.isHidden == false {
            let minWidth = max(scrollView.contentOffset.x - view.frame.width, 0)
            let newOffset = CGPoint(x: minWidth, y: 0)
            scrollView.contentOffset = newOffset
        }
    }
}

extension AddMannaViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
