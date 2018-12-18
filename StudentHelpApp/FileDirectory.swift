//
//  FileDirectory.swift
//  StudentHelpApp
//
//  Created by Кирилл on 18.12.18.
//  Copyright © 2018 Кирилл. All rights reserved.
//

import Foundation
public struct FileDirectory {
    public static func applicationDirectory(directory:FileManager.SearchPathDirectory, subdirectory:String? = nil) -> NSURL? {
        
        
        if let documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        {
            if let subD = subdirectory {
                return NSURL(fileURLWithPath:documentsDirectoryPath).appendingPathComponent(subD) as NSURL?
            }
            else {
                return NSURL(fileURLWithPath:documentsDirectoryPath)
            }
        }
        else {
            return nil
        }
    }
    
    public static func applicationTemporaryDirectory() -> NSURL? {
        
        let tD = NSTemporaryDirectory()
        
        return NSURL(string:tD)
        
    }
}
