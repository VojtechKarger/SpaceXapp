//
//  Logger.swift
//  SpaceXapp
//
//  Created by vojta on 02.05.2022.
//

import Foundation

func log(_ message: Any) {
    #if(DEBUG)
        print(message)
    #endif

}


