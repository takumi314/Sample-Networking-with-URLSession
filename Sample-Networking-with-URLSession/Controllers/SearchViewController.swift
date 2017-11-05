//
//  SearchViewController.swift
//  Sample-Networking-with-URLSession
//
//  Created by NishiokaKohei on 2017/10/18.
//  Copyright © 2017年 Kohey.Nishioka. All rights reserved.
//

import UIKit
import AVKit

class SearchViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Private properties

    private var searchResults = [Track]()

    private var downloadService: DownloadService?

    lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
//        let configuration = URLSessionConfiguration.background(withIdentifier: "bgSessionConfiguration")
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self

        downloadService = DownloadService(session: session)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.placeholder = "検索キーワードを入力してください"
        tableView.separatorStyle = .none
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension SearchViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TrackCell  = tableView.dequeueReusableCell(withIdentifier: "trackCell", for: indexPath) as! TrackCell
        
        cell.pauseTappedHandler = { [unowned self] cell in
            if let indexPath = self.tableView.indexPath(for: cell) {
                self.downloadService?.pauseDownload(self.searchResults[indexPath.row])
                self.reload(indexPath.row)
            }
        }
        cell.cancelTappedHandler = { cell in
            if let indexPath = self.tableView.indexPath(for: cell) {
                self.downloadService?.cancelDownload(self.searchResults[indexPath.row])
                self.reload(indexPath.row)
            }
        }
        cell.downloadTappedHandler = { cell in
            if let indexPath = self.tableView.indexPath(for: cell) {
                self.downloadService?.delegate = self
                self.downloadService?.startDownload(self.searchResults[indexPath.row])
                self.reload(indexPath.row)
            }
        }
        cell.resumeTappedHandler = { cell in
            if let indexPath = self.tableView.indexPath(for: cell) {
                self.downloadService?.delegate = self
                self.downloadService?.resumeDownload(self.searchResults[indexPath.row])
                self.reload(indexPath.row)
            }
        }

        let track = searchResults[indexPath.row]
        cell.configure(track: track, downloaded: track.downloaded, download: downloadService?.activeDownloads[track.previewURL])

        return cell
    }

    // Update track cell's buttons
    func reload(_ row: Int) {
        tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
    }
}

extension SearchViewController: DownloadServiceDelegate {
    func didFinish(_ service: DownloadService, download: Download) {
        // Update the cell
        if let index = download.track.index {
            searchResults[index].downloaded = true
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
            }
        }
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // cell tapped by indexPath.row
        let track = searchResults[indexPath.row]
        if track.downloaded {
            AVPlayingService(track: track, parent: self).play()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SearchViewController: UISearchBarDelegate {

    func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }

    func showCancel() {
        searchBar.showsCancelButton = true
    }

    func hideCancel() {
        searchBar.showsCancelButton = false
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Execution
        dismissKeyboard()
        hideCancel()
        if !searchBar.text!.isEmpty, let term = searchBar.text {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            SearchingService(URLSession())
                .getResult(searchTerm: term) { [weak self] (results, error) in
                    guard let `self` = self else {
                        return
                    }
                    if let results = results {
                        self.searchResults = results
                        self.tableView.reloadData()
                        self.tableView.setContentOffset(CGPoint.zero, animated: false)
                    }
                    if !error.isEmpty {
                        print("Search error occured: \(error)")
                    }
            }
        }
    }

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        showCancel()
        return true
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("Cancel tapped")
        dismissKeyboard()
        hideCancel()
        searchBar.text = ""
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Validation
    }
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Validation
        return true
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    }
}

extension SearchViewController: URLSessionDownloadDelegate {

    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        print("did Finish downloadinf")
        guard let url = downloadTask.originalRequest?.url,
            let downloadService = self.downloadService,
            let download = downloadService.activeDownloads[url]  else {
            return
        }
        print("TemporatyPath: \(location)")
        if downloadService.storedTrack(of: download, downloadedTo: location) {
            // Update the cell
            if let index = download.track.index {
                searchResults[index].downloaded = true
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                }
            }
        }
        
    }

    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        print("Downloading ... ")
        guard let requestURL = downloadTask.originalRequest?.url else {
            return
        }
        if var download = downloadService?.activeDownloads[requestURL], download.isDownloading {
            download.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
            let totalSize = ByteCountFormatter.string(fromByteCount: totalBytesExpectedToWrite, countStyle: .file)
            let index = download.track.index
            DispatchQueue.main.sync {
                let cell = tableView.cellForRow(at: IndexPath(row: index!, section: 0)) as? TrackCell
                cell?.progressView.progress = download.progress
                cell?.progressLabel.text = "\(download.progress * 100)% of \(totalSize)"
            }
        }


    }

}

