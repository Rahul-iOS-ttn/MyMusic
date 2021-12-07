//
//  ViewController.swift
//  MyMusic
//
//  Created by TTN on 03/12/21.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // singleton
    static let shared = ViewController()
    
    @IBOutlet weak var table: UITableView!
    
    var songs = [Song]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSongs()
        table.delegate = self
        table.dataSource = self
    }
    
    //MARK: - Song Configuration
    func configureSongs() {
        songs.append(Song(songName: "Background music", albumName: "something", artistName: "Rnado", songCover: "cover1", trackName: "song1"))
        songs.append(Song(songName: "Havana", albumName: "Havana album", artistName: "camilla cabello", songCover: "cover3", trackName: "song3"))
        songs.append(Song(songName: "Viva La Vida", albumName: "Dont know seriously", artistName: "cold play", songCover: "cover2", trackName: "song2"))
        
        // duplicated for population
        songs.append(Song(songName: "Background music", albumName: "something", artistName: "Rnado", songCover: "cover1", trackName: "song1"))
        songs.append(Song(songName: "Havana", albumName: "Havana album", artistName: "camilla cabello", songCover: "cover3", trackName: "song3"))
        songs.append(Song(songName: "Viva La Vida", albumName: "Dont know seriously", artistName: "cold play", songCover: "cover2", trackName: "song2"))
        songs.append(Song(songName: "Background music", albumName: "something", artistName: "Rnado", songCover: "cover1", trackName: "song1"))
        songs.append(Song(songName: "Havana", albumName: "Havana album", artistName: "camilla cabello", songCover: "cover3", trackName: "song3"))
        songs.append(Song(songName: "Viva La Vida", albumName: "Dont know seriously", artistName: "cold play", songCover: "cover2", trackName: "song2"))
        songs.append(Song(songName: "Background music", albumName: "something", artistName: "Rnado", songCover: "cover1", trackName: "song1"))
        songs.append(Song(songName: "Havana", albumName: "Havana album", artistName: "camilla cabello", songCover: "cover3", trackName: "song3"))
        songs.append(Song(songName: "Viva La Vida", albumName: "Dont know seriously", artistName: "cold play", songCover: "cover2", trackName: "song2"))
    }
    
    //MARK:- Table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let song = songs[indexPath.row]
        
        
        //Cell Configuration
        cell.textLabel?.text = song.songName
        cell.detailTextLabel?.text = song.albumName
        cell.accessoryType = .disclosureIndicator
        cell.imageView?.image = UIImage(named: song.songCover)
        
        cell.textLabel?.font = UIFont(name: "Helvetica-Bold", size: 18)
        cell.detailTextLabel?.font = UIFont(name: "Helvetica", size: 17)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)
        
        //Present the player
        /// for this task we usually need an array of the songs/media and also the positioning from where we want to play the song/media
        let position = indexPath.row
        
        guard let vc = storyboard?.instantiateViewController(identifier: "player") as? PlayerViewController else {
            return
        }
        
        vc.songs = songs
        vc.position = position
        
        present(vc, animated: true)
    }
    
}


struct Song {
    let songName: String
    let albumName: String
    let artistName: String
    let songCover: String
    let trackName: String // this will be the actual audio
}
