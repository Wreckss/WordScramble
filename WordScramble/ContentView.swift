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
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    @State private var score = 0
    
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
                Button(action: startGame) {
                    Text("New Game")
                }
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
                Text("Score: \(score)")
            }
            .navigationBarTitle(rootWord)
                //this calls startGame upon app launch
            .onAppear(perform: startGame)
            .alert(isPresented: $showingError) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
        //dark mode
        .environment(\.colorScheme, .dark)
    }
    
    func addNewWord() {
        if newWord == rootWord {
            wordError(title: "Cannot use root word.", message: "Try something else")
            return
        }
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count > 0 else {
            return
        }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original.")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word not possible", message: "Submissions must comprise of letters contained within given word.")
            return
        }
        
        guard isRealWord(word: answer) else {
            wordError(title: "Word not recognized", message: "This is not a real word.")
            return
        }
        
        usedWords.insert(answer, at: 0)
        score += newWord.count * 2
        newWord = ""
    }
    
    func startGame() {
        score = 0
        usedWords.removeAll()
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
    
    func isRealWord(word: String) -> Bool {
        if word.count < 3 {
            errorMessage = "Word too short"
            return false
        }
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
