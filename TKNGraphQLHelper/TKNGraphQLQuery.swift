//
//  TKNGraphQLQuery.swift
//  TKNGraphQLHelper
//
//  Created by Alper Sevindik on 25.11.2019.
//  Copyright © 2019 Alper Sevindik. All rights reserved.
//

public class TKNGraphQLQuery: Encodable {
    var query: String
    var variables: [String: TKNAnyEncodable]?
    
    init(query: String, variables: [String: TKNAnyEncodable]?) {
        self.query = query
        self.variables = variables
    }
    
    enum CodingKeys: String, CodingKey {
        case query
        case variables
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(query, forKey: .query)
        try container.encode(variables, forKey: .variables)
    }
}

