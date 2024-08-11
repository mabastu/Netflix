//
//  DataPersistenceManager.swift
//  Netflix
//
//  Created by Mabast on 2024-08-11.
//

import Foundation
import UIKit
import CoreData

class DataPersistenceManager {
    
    enum DatabaseError: Error {
        case savingFailed
        case failedToFetch
        case failedToDelete
    }
    
    static let shared = DataPersistenceManager()
    
    func downloadTitleWith(model: Title, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let item = TitleItem(context: context)
        
        item.id = Int64(model.id)
        item.original_title = model.original_title
        item.original_name = model.original_name
        item.overview = model.overview
        item.media_type = model.media_type
        item.poster_path = model.poster_path
        item.release_date = model.release_date
        item.vote_average = model.vote_average
        item.vote_count = Int64(model.vote_count)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.savingFailed))
        }
    
    }
    
    func fetchAllTitlesFromDatabase(completion: @escaping (Result<[TitleItem], Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<TitleItem> = TitleItem.fetchRequest()
        
        do {
            let titles = try context.fetch(request)
            completion(.success(titles))
        } catch {
            completion(.failure(DatabaseError.failedToFetch))
        }
    }
    
    func deleteTitleWith(model: TitleItem, completion: @escaping (Result<Void, Error>)-> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        context.delete(model)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToDelete))
        }
    }
}
