//
//  RealmManager.swift
//  Koinz-Task
//
//  Created by Mohamed Bakr on 07/11/2023.
//

import RealmSwift
import Realm

protocol RealmManagerProtocol {
    func saveObjects<T: Object>(data: [T])
    func fetchObjects<T: Object>(dataType: T.Type, onComplete: @escaping (([T])->()))
}

class RealmManager: RealmManagerProtocol {
    let realm = try! Realm()

    func saveObjects<T>(data: [T]) where T : RealmSwiftObject {
        try! realm.write {
            realm.add(data, update: .modified)
        }
    }
    
    func fetchObjects<T>(dataType: T.Type, onComplete: @escaping (([T]) -> ())) where T : RealmSwiftObject {
        let config = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in},
            deleteRealmIfMigrationNeeded: true
        )
        
        Realm.Configuration.defaultConfiguration = config
        let data = realm.objects(T.self)
        onComplete(data.map { $0 })
    }
}
