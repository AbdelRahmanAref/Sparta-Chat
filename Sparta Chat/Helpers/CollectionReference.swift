//
//  CollectionReference.swift
//  Sparta Chat
//
//  Created by AbdelRahman Aref on 4/21/19.
//  Copyright © 2019 AbdelRahman Aref. All rights reserved.
//

import Foundation
import FirebaseFirestore


enum FCollectionReference: String {
    case User
    case Typing
    case Recent
    case Message
    case Group
    case Call
}


func reference(_ collectionReference: FCollectionReference) -> CollectionReference{
    return Firestore.firestore().collection(collectionReference.rawValue)
}

