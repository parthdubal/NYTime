//
//  NYTimesResult.swift
//  NYTime
//
//  Created by Parth Dubal on 23/02/20.
//  Copyright © 2020 Parth Dubal. All rights reserved.
//

import Foundation

/// NYTimes News Result data.
/// This model use for data parsing for search result api.
struct NYTimesResult {
    let result: [NYTimesItem]
}

extension NYTimesResult: Decodable {
    enum CodingKeys: String, CodingKey {
        case response
    }

    enum ResponseCodingKeys: String, CodingKey {
        case docs
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let docsContainer = try container.nestedContainer(keyedBy: ResponseCodingKeys.self, forKey: .response)
        result = try docsContainer.decode([NYTimesItem].self, forKey: .docs)
    }
}

struct NYTimesItem {
    let headline: String
    let description: String
    let webURL: String
    let imageURL: String
    let publishDate: Date?
}

extension NYTimesItem: Decodable {
    enum CodingKeys: String, CodingKey {
        case abstract, pub_date
        case web_url, headline, multimedia
    }

    enum HeadlineKeys: String, CodingKey {
        case main
    }

    enum MultimediaKeys: String, CodingKey {
        case url
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        webURL = try container.decode(String.self, forKey: .web_url)
        // descriptoin
        description = try container.decode(String.self, forKey: .abstract)

        let headlineContainer = try container.nestedContainer(keyedBy: HeadlineKeys.self, forKey: .headline)
        headline = try headlineContainer.decode(String.self, forKey: .main)

        var URL = "not found"
        var list = try container.nestedUnkeyedContainer(forKey: .multimedia)

        // Here we pick first non empty URL
        while !list.isAtEnd {
            let object = try list.decode(NYTimesMedia.self)
            if !object.imageURL.isEmpty {
                URL = object.imageURL
                break
            }
        }

        imageURL = URL

        let dateStr = try container.decode(String.self, forKey: .pub_date)
        publishDate = DateFormatter.iso8601Full.date(from: dateStr)
    }
}

struct NYTimesMedia {
    let imageURL: String
}

extension NYTimesMedia: Decodable {
    enum CodingKeys: String, CodingKey {
        case url
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        imageURL = try container.decode(String.self, forKey: .url)
    }
}

extension DateFormatter {
    // 2020-02-19T15:12:08+0000
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
