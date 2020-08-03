//
//  ContentView.swift
//  WordScramble
//
//  Created by taco on 8/1/20.
//  Copyright © 2020 Wrecks. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    var body: some View {
        //this is allows us to access a file
//        if let fileURL = Bundle.main.url(forResource: "some-file", withExtension: "txt") {
//            //file has been found in our bundle
//            if let fileContents = try?
//      //load the file into a string
//      String(contentsOf: fileURL) {
//                      //do some stuff with the string
//                   }
//        }
        
        
//        let input = """
//                    a
//                    b
//                    c
//                    """
//        //this creates an array of elements a,b,c
//        let letters = input.components(separatedBy: "\n")
//        // this assigns letter to a random element of the letters array
//        let letter = letters.randomElement()
//
//        //clean a string of spaces and new lines
//        let trimmed = letter?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        
//        //check the spelling of a word in 4 steps
//        let word = "swift"
//        let checker = UITextChecker()
//        let range = NSRange(location: 0, length: word.utf16.count)
//        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
//        let allGood = misspelledRange.location == NSNotFound
        
        NavigationView {
            VStack {
                //onCommit parameter calls addNewWord when return key is pressed
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .padding(2)
                    TextField("Enter your word",text: $newWord, onCommit: addNewWord)
                }
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray, lineWidth: 1))
                .autocapitalization(.none)
                .padding()
                
                List(usedWords, id: \.self) {
                    Image(systemName: "\($0.count).circle")
                    Text($0)
                }
            }
            .navigationBarTitle(rootWord)
                //this calls startGame upon app launch
            .onAppear(perform: startGame)
        }
        //dark mode
        .environment(\.colorScheme, .dark)
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count > 0 else {
            return
        }
        
        usedWords.insert(answer, at: 0)
        newWord = ""
    }
    
    func startGame() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                let allWords = startWords.components(separatedBy: "\n")
                
                rootWord = allWords.randomElement() ?? "silkworm"
                return
            }
        }
        fatalError("Could not load start.txt from bundle")
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord.lowercased()
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        return true
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
