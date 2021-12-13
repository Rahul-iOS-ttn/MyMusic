//
//  APIIntegration+Data.swift
//  MyMusic
//
//  Created by TTN on 09/12/21.
//

import Foundation
import UIKit


//"adult":false,
//"backdrop_path":"/1uKHoFWyYJn060dpIXUCU7Wbc15.jpg", detail screen image will be used with the integrations of stcking and stack view
//"genre_ids":[
//   10752,
//   18,
//   28
//],
//"id":228150,
//"original_language":"en",
//"original_title":"Fury",
//"overview":"In the last months of World War II, as the Allies make their final push in the European theatre, a battle-hardened U.S. Army sergeant named 'Wardaddy' commands a Sherman tank called 'Fury' and its five-man crew on a deadly mission behind enemy lines. Outnumbered and outgunned, Wardaddy and his men face overwhelming odds in their heroic attempts to strike at the heart of Nazi Germany.",
//"popularity":71.549,
//"poster_path":"/pfte7wdMobMF4CVHuOxyu6oqeeA.jpg",
//"release_date":"2014-10-15",
//"title":"Fury",
//"video":false,
//"vote_average":7.5,
//"vote_count":8984

// MARK:- Data Models
struct MovieData : Decodable {
    var adult: Bool?
    var backdrop_path: String?
    var genre_ids: [Int]?
    var id: Int?
    var original_language: String?
    var original_title: String?
    var overview: String?
    var popularity: Double?
    var poster_path: String?
    var release_date: String?
    var title: String?
    var video: Bool?
    var vote_average: Double?
    var vote_count: Int?
}

struct MainData : Decodable {
    var page:Int?
    var results: [MovieData]?
    var total_pages: Int?
    var total_results: Int?
}

struct BindedData {
    var genre: String
    var genreMovies: [MovieData]
}


class API_integrations {
    let imageHomeURL = "https://image.tmdb.org/t/p/w500"
    

    //MARK:- Download Session
    func downloadJSON(finalURL: URL?, completed: @escaping (Result<[MovieData]?, Error>) -> Void) {
        
        URLSession.shared.dataTask(with: finalURL!) { (data, response, error) in
            if let dataError = error {
                DispatchQueue.main.async {
                    completed(.failure(dataError))
                }
            } else if let information = data {
                do {
                    let completeInformation = try JSONDecoder().decode(MainData.self, from: information)
                    DispatchQueue.main.async {//result data type use and return error if it happens here
                        completed(.success(completeInformation.results))
                    }
                }catch {
                    DispatchQueue.main.async {
                        completed(.failure(NSError(domain: "Error in data parsing my friend", code: 101, userInfo: nil)))
                    }
                }
            }else {
                DispatchQueue.main.async {
                    completed(.failure(NSError(domain: "Error api download", code: 101, userInfo: nil)))
                }
            }
        }.resume()
    }
    
    func downloadCase(for genreCategory: String, downloadCaseCompleted: @escaping (Result<[MovieData]?, Error>) -> Void) {
        let homeURL: String = "https://api.themoviedb.org/3/"
        let api_key: String = "&api_key=820016b7116f872f5f27bf56f9fdfb66"
        
        var finalURL = URL(string: homeURL + api_key)
        
        switch genreCategory { // If a category fails to retrieve data then have it throw an error
        case "Banner":
            let banner: String = "trending/movie/day?"
            finalURL = URL(string: homeURL + banner + api_key)
        case "Popular":
            let popular: String = "discover/movie?sort_by=popularity.desc"
            finalURL = URL(string: homeURL + popular + api_key)
        case "Best Dramas":
            let bestDramas: String = "discover/movie?with_genres=18&sort_by=vote_average.desc&vote_count.gte=10"
            finalURL = URL(string: homeURL + bestDramas + api_key)
        case "Kids Movies":
            let kidsMovies: String = "discover/movie?certification_country=US&certification.lte=G&sort_by=vote_average.desc"
            finalURL = URL(string: homeURL + kidsMovies + api_key)
        case "Best Movies":
            let bestMovies: String = "discover/movie?primary_release_year=2010&sort_by=vote_average.desc"
            finalURL = URL(string: homeURL + bestMovies + api_key)
        default:
            print("Error in DownloadCase")
        }
//        DispatchQueue.main.async {
            self.downloadJSON(finalURL: finalURL, completed: downloadCaseCompleted)
//        }
    }
}

//MARK:- Data Handler

class ViewModel {
    
    let api = API_integrations()
    
    var genres = ["Banner", "Popular", "Best Dramas", "Kids Movies", "Best Movies"]
    
    var genreItems: [BindedData] = []
    
    func getInformation( allDone: @escaping (Bool, String) -> Void ) {
        genreItems.removeAll()
        for genre in genres { // result functions
            
            api.downloadCase(for: genre) { (result) in
                switch result {
                case .success(let instanceData):
                    if let data = instanceData{
                        self.genreItems.append(BindedData(genre: genre, genreMovies: data))
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                            self.sendNotification()
                         }
                        allDone(true, "")
                    } else {
                        allDone(false, genre + " Data is empty")
                    }
                case .failure(let error):
//                    print(error.localizedDescription) Always on controllers
                    allDone(false, error.localizedDescription)
                }
            }
        }
    }
    
    func sendNotification() {
        let content = UNMutableNotificationContent()
        content.title = self.genreItems[0].genreMovies[0].title ?? "No Data I guess"
        content.body = self.genreItems[1].genre
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "notify-test"

        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 2, repeats: false)
        let request = UNNotificationRequest.init(identifier: "notify-test", content: content, trigger: trigger)

        let center = UNUserNotificationCenter.current()
        center.add(request)
    }
}
