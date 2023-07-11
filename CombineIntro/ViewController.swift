//
//  ViewController.swift
//  CombineIntro
//
//  Created by Seher Aytekin on 6/23/23.
//

import UIKit
import Combine

class MyCustomCell: UITableViewCell {
    @IBOutlet var button: UIButton!
}

class ViewController: UIViewController, UITableViewDataSource {
    
    private let tableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(MyCustomCell.self, forCellReuseIdentifier: "Cell")
        return table
    }()

    var observer: AnyCancellable?
    private var models = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        
        observer = APICaller.shared.fetchCompanies()
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
            })
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? MyCustomCell else { fatalError() }
        cell.textLabel?.text = models[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }

}

