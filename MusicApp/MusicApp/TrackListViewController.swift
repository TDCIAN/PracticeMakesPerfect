//
//  ViewController.swift
//  MusicApp
//
//  Created by JeongminKim on 2022/12/13.
//

import UIKit

class TrackListViewController: UIViewController {

    var musicTrackList: [Track] = []
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPlayer" {
            if let playerVC = segue.destination as? PlayerViewController, let index = sender as? Int {
                playerVC.track = musicTrackList[index]
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadTrackList()
    }

    func loadTrackList() {
        musicTrackList = [
            Track(title: "Swish", thumb: UIImage(named: "Swish")!, artist: "Tyga"),
            Track(title: "Dip", thumb: UIImage(named: "Dip")!, artist: "Tyga"),
            Track(title: "The Harlem Barber Swing", thumb: UIImage(named: "The Harlem Barber Swing")!, artist: "Jazzinuf"),
            Track(title: "Believer", thumb: UIImage(named: "Believer")!, artist: "Imagine Dragon"),
            Track(title: "Blue Birds", thumb: UIImage(named: "Blue Birds")!, artist: "Eevee"),
            Track(title: "Best Mistake", thumb: UIImage(named: "Best Mistake")!, artist: "Ariana Grande"),
            Track(title: "thank u, next", thumb: UIImage(named: "thank u, next")!, artist: "Ariana Grande"),
            Track(title: "7 rings", thumb: UIImage(named: "7 rings")!, artist: "Ariana Grande"),
        ]
    }
}

extension TrackListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicTrackList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath) as? TrackCell else { return UITableViewCell() }
        let track = musicTrackList[indexPath.row]
        cell.thumbnail.image = track.thumb
        cell.title.text = track.title
        cell.artist.text = track.artist
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowPlayer", sender: indexPath.row)
    }
}

class TrackCell: UITableViewCell {
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var artist: UILabel!
}
