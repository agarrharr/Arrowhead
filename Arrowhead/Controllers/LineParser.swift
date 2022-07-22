//
//  LineParser.swift
//  Arrowhead
//
//  Created by Adam Garrett-Harris on 3/28/22.
//

import Foundation

public class LineParser {
    // TODO: Get line number for id
    func getTask(from string: String, at lineNumber: Int) -> Line {
        let regex = try! NSRegularExpression(pattern: #"(^\s*[-*]{1} \[([ xX]{1})\] )"#)
        let matches = regex.matches(in: string, range: NSRange(location: 0, length: string.utf16.count))

        if matches.count > 0 {
            let range = matches[0].range(at: 1)
            
            let fullTitle = regex.stringByReplacingMatches(in: string, options: [], range: range, withTemplate: "")
            let (titleWithoutTags, tags) = findHashtags(string: fullTitle)
            let (titleWitoutDueDate, dueDate) = findDueDate(string: titleWithoutTags)
            let (title, doneDate) = findDoneDate(string: titleWitoutDueDate)
            
            let checkmarkIndex = matches[0]
                .range(at: 2) // get the second matching group
                .lowerBound
            let checkmark = string[string.index(string.startIndex, offsetBy: checkmarkIndex)].lowercased()
            let isCompleted = checkmark == "x"
            
            return Action(id: lineNumber, title: title, completed: isCompleted, tags: tags, dueDate: dueDate, doneDate: doneDate)
        }
        return Note(id: lineNumber, text: string)
    }
    
    // MARK: Private
    private func findHashtags(string: String) -> (newString: String, tags: [String]) {
        var hashtags:[String] = []
        var newString: String = string
        var numberOfRemovedCharacters = 0
        let regex = try? NSRegularExpression(pattern: " (#[a-zA-Z0-9_\\p{Arabic}\\p{N}]*)", options: [])
        if let matches = regex?.matches(in: string, options:[], range:NSMakeRange(0, string.utf16.count)) {
            for match in matches {
                hashtags.append(NSString(string: string).substring(with: NSRange(location: match.range.location, length: match.range.length)))
                newString = regex?.stringByReplacingMatches(in: newString, options: [], range: NSRange(location: match.range.location - numberOfRemovedCharacters, length: match.range.length), withTemplate: "") ?? newString
                numberOfRemovedCharacters += match.range.length
            }
        }
        
        return (newString: newString, tags: hashtags)
    }
    
    private func findDueDate(string: String) -> (newString: String, date: String?) {
        findDate(string, withEmoji: "📅")
    }
    
    private func findDoneDate(string: String) -> (newString: String, date: String?) {
        findDate(string, withEmoji: "✅")
    }
    
    private func findDate(_ string: String, withEmoji emoji: String) -> (newString: String, date: String?) {
        var dates:[String] = []
        var newString: String = string
        var numberOfRemovedCharacters = 0
        let regex = try? NSRegularExpression(pattern: " (\(emoji) [0-9]{4}-[0-9]{2}-[0-9]{2})", options: [])
        if let matches = regex?.matches(in: string, options:[], range:NSMakeRange(0, string.utf16.count)) {
            for match in matches {
                dates.append(NSString(string: string).substring(with: NSRange(location: match.range.location, length: match.range.length)))
                newString = regex?.stringByReplacingMatches(in: newString, options: [], range: NSRange(location: match.range.location - numberOfRemovedCharacters, length: match.range.length), withTemplate: "") ?? newString
                numberOfRemovedCharacters += match.range.length
            }
        }
        
        return (newString: newString, date: dates.count > 0 ? dates[0] : nil)
    }

}
