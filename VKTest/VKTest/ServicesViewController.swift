//
//  ViewController.swift
//  VKTest
//
//  Created by Сергей Николаев on 13.07.2022.
//

import UIKit
import PinLayout

class ServicesViewController: UIViewController {
    let tableView = UITableView()
    var services: [Service] = []
    let dataURL = "https://publicstorage.hb.bizmrg.com/sirius/result.json"

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .add, target: self, action: #selector(didPullToRefresh))
//        navigationController?.navigationBar.titleTextAttributes
//
        view.addSubview(tableView)
//        tableView.separatorStyle = .none
        tableView.frame = view.bounds
        tableView.register(ServiceTableViewCell.self, forCellReuseIdentifier: "ServiceTableViewCell")
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "basicStyle")
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        tableView.refreshControl?.beginRefreshing()
//
//        tableView.refreshControl?.endRefreshing()
//        tableView.delegate = self
//        tableView.dataSource = self
//        title = "Сервисы VK"
        let tlabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        tlabel.text = "Сервисы VK"
//        tlabel.textColor = UIColor.white
        tlabel.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        tlabel.backgroundColor = UIColor.clear
        tlabel.adjustsFontSizeToFitWidth = true
        tlabel.textAlignment = .center
        navigationItem.titleView = tlabel

//        title.
        
        
        loadData() {
            self.tableView.refreshControl?.endRefreshing()
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.reloadData()
        }

    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
////        tableView.pin
////            .top(0)
////            .bottom(0)
////            .left(0)
////            .right(0)
//    }
    
    private func loadData(compl: (() -> Void)? = nil) {
        NetworkManager.shared.loadServices(urlString: dataURL) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                    
                case .success(let servicesData):
                    print("Success!")
                    self?.services = servicesData.body.services
//                    print(self?.services)
                    self?.tableView.reloadData()
                    break
                    
                case .failure(let error):
                    print("Error! \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .cancel)
                        alertController.addAction(okAction)
                        self?.present(alertController, animated: true, completion: nil)
                    break
                }
                compl?()
            }
        }
    }

    @objc
    private func didPullToRefresh() {
        loadData() {
            self.tableView.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }
}

extension ServicesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceTableViewCell", for: indexPath) as? ServiceTableViewCell
        cell?.mainViewController = self
        
        let service = services[indexPath.row]
        cell?.config(with: service)

        return cell ?? .init()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let application = UIApplication.shared
        
        let service = services[indexPath.row]
        guard let url = URL(string: service.link) else { return }
        
//        let path = "vk://"
        var path = "\(service.link.split(separator: "/")[1].split(separator: ".")[0])://"
        
        switch path {
        case "my://":
            path = "mygamesapp://"
            break
        case "cloud://":
            path = "cloudmailru://"
            break
        case "calendar://":
            path = ""
            break
        default:
            break
        }
        
        let appUrl = URL(string: path) ?? url
        
        if application.canOpenURL(appUrl) {
            application.open(appUrl)
        } else {
            application.open(url)
        }
        
        
//        let service = services[indexPath.row]
//        guard let url = URL(string: service.link) else { return }
//
//        UIApplication.shared.open(url)
    }
    
    //высота ячейки
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
}

