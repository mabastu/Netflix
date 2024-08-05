//
//  Movie.swift
//  Netflix
//
//  Created by Mabast on 2024-08-05.
//

import Foundation

struct TrendingMovies: Codable {
    let results: [Movie]
}

struct Movie: Codable {
    let id: Int
    let media_type: String?
    let original_name: String?
    let original_title: String?
    let poster_path: String?
    let overview: String?
    let vote_count: Int
    let release_date: String?
    let vote_average: Double
}
