//
//  ViewController.swift
//  CombineIntro
//
//  Created by Seher Aytekin on 6/23/23.
//

import UIKit
import Combine

class MyCustomCell: UITableViewCell {
    private var button: UIButton! = {
        let button = UIButton()
        button.backgroundColor = .systemPink
        button.setTitle("Button", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    let action = PassthroughSubject<String, Never>() /// Never : Caller never return an error !!!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(button)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc func didTapButton() {
        action.send("Cool button was tapped!")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.frame = CGRect(x: 10, y: 3, width: contentView.frame.size.width - 20, height: contentView.frame.size.height - 6)
    }
}

class ViewController: UIViewController, UITableViewDataSource {
    
    private let tableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(MyCustomCell.self, forCellReuseIdentifier: "Cell")
        return table
    }()

    var observers: [AnyCancellable] = []
    private var models = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        
        APICaller.shared.fetchCompanies()
            .receive(on: DispatchQueue.main) /// notify you on main thread!!!
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("finished")
                case .failure(let error):
                    print(error)
                }
            }, receiveValue: { [weak self] value in
                self?.models = value
                self?.tableView.reloadData()
            }).store(in: &observers)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? MyCustomCell else { fatalError() }
        //cell.textLabel?.text = models[indexPath.row]
        
        cell.action.sink { string in
            print(string)
        }.store(in: &observers)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }

}

