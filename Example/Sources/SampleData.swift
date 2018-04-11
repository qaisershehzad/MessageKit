/*
 MIT License

 Copyright (c) 2017-2018 MessageKit

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import MessageKit
import CoreLocation

final class SampleData {

    static let shared = SampleData()

    private init() {}

    let messageTextValues = [
        "I think if you do something and it turns out pretty good, then you should go do something else wonderful, not dwell on it for too long. Just figure out what’s next. Price is rarely the most important thing. A cheap product might sell some units. Somebody gets it home and they feel great when they pay the money, but then they get it home and use it and the joy is gone.1 2 3 4 5 6 7 8 9 0 END"
    ]

    let dan = Sender(id: "123456", displayName: "Dan Leonard")
    let steven = Sender(id: "654321", displayName: "Steven")
    let jobs = Sender(id: "000001", displayName: "Steve Jobs")
    let cook = Sender(id: "656361", displayName: "Tim Cook")

    lazy var senders = [dan, steven, jobs, cook]

    var currentSender: Sender {
        return steven
    }

    let messageImages: [UIImage] = [#imageLiteral(resourceName: "Dan-Leonard"), #imageLiteral(resourceName: "Tim-Cook"), #imageLiteral(resourceName: "Steve-Jobs")]

    var now = Date()

//    let messageTypes = ["Text", "Text", "Text", "AttributedText", "Photo", "Video", "Location", "Emoji"]

    let messageTypes = ["AttributedText"]
//    let attributes = ["Font1", "Font2", "Font3", "Font4", "Color", "Combo"]
    let attributes = ["Font1"]

    let locations: [CLLocation] = [
        CLLocation(latitude: 37.3118, longitude: -122.0312),
        CLLocation(latitude: 33.6318, longitude: -100.0386),
        CLLocation(latitude: 29.3358, longitude: -108.8311),
        CLLocation(latitude: 39.3218, longitude: -127.4312),
        CLLocation(latitude: 35.3218, longitude: -127.4314),
        CLLocation(latitude: 39.3218, longitude: -113.3317)
    ]

    let emojis = [
        "👍",
        "👋",
        "👋👋👋",
        "😱😱",
        "🎈",
        "🇧🇷"
    ]

    func attributedString(with text: String) -> NSAttributedString {
        let nsString = NSString(string: text)
        var mutableAttributedString = NSMutableAttributedString(string: text)
        let randomAttribute = Int(arc4random_uniform(UInt32(attributes.count)))
        let range = NSRange(location: 0, length: nsString.length)

        switch attributes[randomAttribute] { //here
        case "Font1":
//            mutableAttributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.preferredFont(forTextStyle: .body), range: range)
            mutableAttributedString.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "Colfax-Regular", size: 14)!, range: range)
        case "Font2":
            mutableAttributedString.addAttributes([NSAttributedStringKey.font: UIFont.monospacedDigitSystemFont(ofSize: UIFont.systemFontSize, weight: UIFont.Weight.bold)], range: range)
        case "Font3":
            mutableAttributedString.addAttributes([NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)], range: range)
        case "Font4":
            mutableAttributedString.addAttributes([NSAttributedStringKey.font: UIFont.italicSystemFont(ofSize: UIFont.systemFontSize)], range: range)
        case "Color":
            mutableAttributedString.addAttributes([NSAttributedStringKey.foregroundColor: UIColor.red], range: range)
        case "Combo":
            let msg9String = "Use .attributedText() to add bold, italic, colored text and more..."
            let msg9Text = NSString(string: msg9String)
            let msg9AttributedText = NSMutableAttributedString(string: String(msg9Text))

            msg9AttributedText.addAttribute(NSAttributedStringKey.font, value: UIFont.preferredFont(forTextStyle: .body), range: NSRange(location: 0, length: msg9Text.length))
            msg9AttributedText.addAttributes([NSAttributedStringKey.font: UIFont.monospacedDigitSystemFont(ofSize: UIFont.systemFontSize, weight: UIFont.Weight.bold)], range: msg9Text.range(of: ".attributedText()"))
            msg9AttributedText.addAttributes([NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)], range: msg9Text.range(of: "bold"))
            msg9AttributedText.addAttributes([NSAttributedStringKey.font: UIFont.italicSystemFont(ofSize: UIFont.systemFontSize)], range: msg9Text.range(of: "italic"))
            msg9AttributedText.addAttributes([NSAttributedStringKey.foregroundColor: UIColor.red], range: msg9Text.range(of: "colored"))
            mutableAttributedString = msg9AttributedText
        default:
            fatalError("Unrecognized attribute for mock message")
        }

        return NSAttributedString(attributedString: mutableAttributedString)
    }

    func dateAddingRandomTime() -> Date {
        let randomNumber = Int(arc4random_uniform(UInt32(10)))
        if randomNumber % 2 == 0 {
            let date = Calendar.current.date(byAdding: .hour, value: randomNumber, to: now)!
            now = date
            return date
        } else {
            let randomMinute = Int(arc4random_uniform(UInt32(59)))
            let date = Calendar.current.date(byAdding: .minute, value: randomMinute, to: now)!
            now = date
            return date
        }
    }

    func randomMessage() -> MockMessage {

        let randomNumberSender = Int(arc4random_uniform(UInt32(senders.count)))
        let randomNumberText = Int(arc4random_uniform(UInt32(messageTextValues.count)))
        let randomNumberImage = Int(arc4random_uniform(UInt32(messageImages.count)))
        let randomMessageType = Int(arc4random_uniform(UInt32(messageTypes.count)))
        let randomNumberLocation = Int(arc4random_uniform(UInt32(locations.count)))
        let randomNumberEmoji = Int(arc4random_uniform(UInt32(emojis.count)))
        let uniqueID = NSUUID().uuidString
        let sender = senders[randomNumberSender]
        let date = dateAddingRandomTime()

        switch messageTypes[randomMessageType] {
        case "Text":
            return MockMessage(text: messageTextValues[randomNumberText], sender: sender, messageId: uniqueID, date: date)
        case "AttributedText":
            let attributedText = attributedString(with: messageTextValues[randomNumberText])
            return MockMessage(attributedText: attributedText, sender: senders[randomNumberSender], messageId: uniqueID, date: date)
        case "Photo":
            let image = messageImages[randomNumberImage]
            return MockMessage(image: image, sender: sender, messageId: uniqueID, date: date)
        case "Video":
            let image = messageImages[randomNumberImage]
            return MockMessage(thumbnail: image, sender: sender, messageId: uniqueID, date: date)
        case "Location":
            return MockMessage(location: locations[randomNumberLocation], sender: sender, messageId: uniqueID, date: date)
        case "Emoji":
            return MockMessage(emoji: emojis[randomNumberEmoji], sender: sender, messageId: uniqueID, date: date)
        default:
            fatalError("Unrecognized mock message type")
        }
    }

    func getMessages(count: Int, completion: ([MockMessage]) -> Void) {
        var messages: [MockMessage] = []
        for _ in 0..<count {
            messages.append(randomMessage())
        }
        completion(messages)
    }

    func getAvatarFor(sender: Sender) -> Avatar {
        switch sender {
        case dan:
            return Avatar(image: #imageLiteral(resourceName: "Dan-Leonard"), initials: "DL")
        case steven:
            return Avatar(initials: "S")
        case jobs:
            return Avatar(image: #imageLiteral(resourceName: "Steve-Jobs"), initials: "SJ")
        case cook:
            return Avatar(image: #imageLiteral(resourceName: "Tim-Cook"))
        default:
            return Avatar()
        }
    }

}
