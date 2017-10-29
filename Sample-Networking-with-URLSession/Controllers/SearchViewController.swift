//
//  SearchViewController.swift
//  Sample-Networking-with-URLSession
//
//  Created by NishiokaKohei on 2017/10/18.
//  Copyright © 2017年 Kohey.Nishioka. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    private var searchResults = [Track]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension SearchViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trackCell", for: indexPath)

        return cell
    }

}

extension SearchViewController: UITableViewDelegate {

}

extension SearchViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        if !searchBar.isFirstResponder {
            searchBar.becomeFirstResponder()
        }
        return true
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Execution
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Cancel
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Validation
    }
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {

    }
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        if searchBar.isFirstResponder {
            searchBar.resignFirstResponder()
        }
        return false
    }
}

