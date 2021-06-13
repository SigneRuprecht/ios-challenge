//
//  PageLocation.swift
//  iOS Challenge
//
//  Created by Signe Ruprecht on 6/12/21.
//  Copyright © 2021 Signe Ruprecht. All rights reserved.
//

import Foundation

class PageLocation {
    
    var currPage: UInt = 1
    var totalPages: UInt = 1
    var pageDescription: String = ""
    var nextVisible: Bool = false
    var prevVisible: Bool = false
    
    init() {
        
    }
    
    func setTotalPages(totalResults: UInt) {
        self.totalPages = totalResults / 20
        
        if self.totalPages == 0 {
            self.totalPages = 1
        }
        self.pageDescription = "page \(self.currPage)/\(self.totalPages)"
        
        self.nextVisible = true
        self.prevVisible = true
        
        if(self.currPage == self.totalPages) {
            self.nextVisible = false
            return
        }
        
        if(self.currPage == 1) {
            self.prevVisible = false
            return
        }
        
    }
    
    func setPageNotFound() {
        self.currPage = 1
        self.totalPages = 1
        self.pageDescription = "No results found"
        self.nextVisible = false
        self.prevVisible = false
    }
    
    func resetPage() {
        self.currPage = 1
        self.totalPages = 1
        self.pageDescription = ""
        self.nextVisible = false
        self.prevVisible = false
    }
    
    func incrementPage() {
        self.nextVisible = true
        self.prevVisible = true
        
        if(self.currPage == self.totalPages) {
            self.nextVisible = false
            return
        }
        
        self.currPage += 1
        self.pageDescription = "page \(self.currPage)/\(self.totalPages)"
    }
    
    func decrementPage() {
        self.nextVisible = true
        self.prevVisible = true
        
        if(self.currPage == 1) {
            self.prevVisible = false
            return
        }
        
        self.currPage -= 1
        self.pageDescription = "page \(self.currPage)/\(self.totalPages)"
    }
    
}
