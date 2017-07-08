//
//  JSONCOnnection.swift
//  IOSPeticionOLJson
//
//  Created by Carlos on 04/07/2017.
//  Copyright © 2017 Woowrale. All rights reserved.
//
import UIKit
import Foundation

class JSONCOnnection{

    let ISBN = "ISBN:"
    let URL_QUERY = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:"
    
    func getJsonData(codISBN: String) throws -> Book {
        
        let urls = URL_QUERY + codISBN
        let url = NSURL(string: urls)
        let book = Book()
        
        do{
            let isbnCode = ISBN + codISBN
            let datos: NSData! = NSData(contentsOf: url! as URL)
            
            if(datos != nil){
            
                let json = try JSONSerialization.jsonObject(with: datos as Data, options: JSONSerialization.ReadingOptions.mutableLeaves)
                let dicRoot = json as! NSDictionary
                
                let dicISBN: NSDictionary! =  dicRoot[isbnCode] as! NSDictionary
                if(dicISBN != nil){
                    let title = dicISBN["title"] as! NSString
                    book.title = String(title)
                }
                
                let dicAuthors: NSArray! = dicISBN["authors"] as! NSArray
                if(dicAuthors != nil){
                    for authors in dicAuthors {
                        let author = authors as! NSDictionary
                        let name = author["name"] as! NSString
                        book.authors.append(String(name))
                    }
                }

                let dicImages: NSDictionary! = dicISBN["cover"] as! NSDictionary
                if dicImages != nil {
                    let image = dicImages?["large"] as! NSString
                    let imageURL = NSURL(string: String(image))
                    let imageData: NSData! = NSData(contentsOf: imageURL! as URL)
            
                    if(imageData != nil){
                        if let uiImage = UIImage(data: imageData! as Data){
                            book.image = uiImage
                        }
                    }
                }
            }

        } catch _{
            print("Exception in method: getJsonData")
        }
        
        return book
    }
    
}
