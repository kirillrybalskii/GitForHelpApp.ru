//
//  FileSave.swift
//  StudentHelpApp
//
//  Created by Кирилл on 18.12.18.
//  Copyright © 2018 Кирилл. All rights reserved.
//

import Foundation
public struct FileSave
{
    public static func buildPath(path:String, inDirectory directory:FileManager.SearchPathDirectory, subdirectory:String?) throws -> String  {
        // Remove unnecessary slash if need
        let newPath = FileHelper.stripSlashIfNeeded(stringWithPossibleSlash: path)
        var newSubdirectory:String?
        if let sub = subdirectory {
            newSubdirectory = FileHelper.stripSlashIfNeeded(stringWithPossibleSlash: sub)
        }
        // Create generic beginning to file save path
        var savePath = ""
        if let direct = FileDirectory.applicationDirectory(directory: directory),
            let path = direct.path {
            savePath = path + "/"
        }
        
        if (newSubdirectory != nil) {
            savePath = savePath.appending(newSubdirectory!)
            try FileHelper.createSubDirectory(subdirectoryPath: savePath)
            savePath += "/"
        }
        
        // Add requested save path
        savePath += newPath
        
        return savePath
    }

}
